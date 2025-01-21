#include "sys/alt_stdio.h"
#include "system.h"
#include "io.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "unistd.h"
#include "stdbool.h"

#include <opencores_i2c.h>
#include <stdio.h>
#include <stdlib.h> 

#define I2C_READ_OP 1
#define I2C_WRITE_OP 0
#define I2C_STOP 1
#define I2C_CONTINUE 0

#define IMU_ADDR 0x1D
#define IMU_DAT_REG_START_ADDR 0x32
#define IMU_POWER_CTL_REG_ADDR 0x2D
#define IMU_DAT_FORMAT_REG_ADDR 0x31
#define IMU_FIFO_CTL_REG_ADDR 0x38

#define EXCEPT_TRAP while(1){};


volatile int segmVal = -15502;
volatile bool update_display = true;

typedef struct {
    alt_16 x;
    alt_16 y;
    alt_16 z;
}accel_dat;

typedef struct {
    float x;
    float y;
    float z;
    float coeff;
}accel_trims;

alt_u8 read8bit(alt_u32 addr, alt_u32 reg_addr){
    alt_u32 data = 0;
    I2C_start(OPENCORES_I2C_0_BASE,addr,I2C_WRITE_OP);  //start as WRITE mode
    data =  I2C_write(OPENCORES_I2C_0_BASE,reg_addr,I2C_CONTINUE); // write requested reg addr
    I2C_start(OPENCORES_I2C_0_BASE,addr,I2C_READ_OP);   // restart as READ
    data =  I2C_read(OPENCORES_I2C_0_BASE,I2C_STOP);           //read one byte
    return (alt_u8)data;
}

bool I2C_AddressAuto(alt_u32 addr, alt_u32 reg_addr){
    int acked = I2C_start(OPENCORES_I2C_0_BASE,addr, I2C_WRITE_OP);  //start as WRITE mode
    if(acked != 0)
        alt_printf("BAD ADDR: %x, no ACK\r\n",addr);
    I2C_write(OPENCORES_I2C_0_BASE,reg_addr,I2C_CONTINUE); // write requested reg addr
    return acked == 0;
}

void write8bit(alt_u32 addr, alt_u32 reg_addr, alt_u8 dat){
    I2C_AddressAuto(addr, reg_addr);
    I2C_write(OPENCORES_I2C_0_BASE, dat, I2C_STOP);
}

void setup(){
    alt_printf("Doing IMU setup");
    write8bit(IMU_ADDR, IMU_POWER_CTL_REG_ADDR, 0b00001000); // measure mode ON
    write8bit(IMU_ADDR, IMU_DAT_FORMAT_REG_ADDR, 0b0001011); // right justified with sign, +- 16G range, full resolution mode ON
    write8bit(IMU_ADDR, IMU_FIFO_CTL_REG_ADDR, 0x00); //no fifo
    alt_printf("Done IMU setup");
}

void mass_dump(){
    I2C_AddressAuto(IMU_ADDR, 0x00);
    I2C_start(OPENCORES_I2C_0_BASE,IMU_ADDR,I2C_READ_OP);   // restart as READ
    alt_u8 stop = 0x39; //stop at FIFO_STATUS
    for(int i = 0; i < stop; i++){
        alt_printf("0x%x => 0x%x \r\n", i, I2C_read(OPENCORES_I2C_0_BASE,I2C_CONTINUE));
    }
    alt_printf("0x%x => 0x%x \r\n\r\n", 0x39, I2C_read(OPENCORES_I2C_0_BASE,I2C_STOP));
}

accel_dat readXYZ(){
    accel_dat d;
    alt_u32 dat[6] = {0,0,0,0,0,0};
    I2C_AddressAuto(IMU_ADDR, IMU_DAT_REG_START_ADDR);
    I2C_start(OPENCORES_I2C_0_BASE,IMU_ADDR,I2C_READ_OP);   // restart as READ

    //format (right justified): D1 4-0 + D0 7-0 -> 16g mode full res
    
    dat[0] =  I2C_read(OPENCORES_I2C_0_BASE,I2C_CONTINUE);
    dat[1] =  I2C_read(OPENCORES_I2C_0_BASE,I2C_CONTINUE);
    dat[2] =  I2C_read(OPENCORES_I2C_0_BASE,I2C_CONTINUE);
    dat[3] =  I2C_read(OPENCORES_I2C_0_BASE,I2C_CONTINUE);
    dat[4] =  I2C_read(OPENCORES_I2C_0_BASE,I2C_CONTINUE);
    dat[5] =  I2C_read(OPENCORES_I2C_0_BASE,I2C_STOP);

    d.x = (dat[1] << 8) | dat[0];
    d.y = ( dat[3] << 8) |  dat[2];
    d.z = ( dat[5] << 8) |  dat[4];

    return d;
}

accel_trims calibrate(){
    accel_dat d = readXYZ();    //board must be flat on the table there.
    float coeff = 1.0f / d.z;
    printf("Got coeff %f from calibration\r\n", coeff);
    accel_trims t;
    d = readXYZ();
    t.x  = 0.0f-(d.x*coeff);
    t.y  = 0.0f-(d.y*coeff);
    t.z  = 1.0f-(d.z*coeff);
    t.coeff = coeff;
    return t;
}

void scanI2CDevices(void)
{
    alt_u32 address;
    alt_printf("I2C Scanner\r\n");
    alt_printf("Scanning I2C bus for devices...\r\n");

    for (address = 0x03; address <= 0x20; address++)
    {
        if(I2C_start(OPENCORES_I2C_0_BASE, address, 1) == 0)
            alt_printf("\r\nDevice found at address 0x%x\r\n", address);
        else
            alt_printf(" NODEV: %x ", address);
    }

    I2C_write(OPENCORES_I2C_0_BASE,0x00,I2C_STOP);
    I2C_write(OPENCORES_I2C_0_BASE,0x00,I2C_STOP);  //cleanup

    alt_printf("\r\nScan completed.\r\n");
}

volatile alt_u8 dispVal = 0;

static void btn0_isr(void * context) {
    dispVal++;
    if(dispVal > 2) dispVal = 0;
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_0_BASE, 0x1);
    IORD_ALTERA_AVALON_PIO_EDGE_CAP(PIO_0_BASE);
}

int main() {
    alt_printf("init\r\n");

    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(PIO_0_BASE, 0xf);
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_0_BASE, 0x0);

    alt_irq_register(PIO_0_IRQ, PIO_0_BASE, btn0_isr);

    alt_printf("Starting i2C Demo\r\n");

    I2C_init(OPENCORES_I2C_0_BASE, 50000000,100000);
    usleep(1000000);
    alt_printf("begin I2C scan\r\n");
    scanI2CDevices();
    usleep(1000000);

    alt_u8 dat = read8bit(IMU_ADDR, 0x00);
    if(dat == 0xe5)//read CHIPID -> should be 11100101
        alt_printf("Chip valid, got 0b11100101 (e5)\r\n");
    else{
        alt_printf("Wrong IMU, got WHOAMI = %x, should be 0xe5\r\n", dat);  
        EXCEPT_TRAP
    }

    setup();
    accel_trims t = calibrate();
    char buf[255];
    alt_u8 decs[] = {0,0,0,0,0,0,0,0,0,0};

    alt_u32 x = 0;
    alt_u32 y = 0;

#define PREV_SIZE 25
    accel_dat prev[PREV_SIZE];  //just a quick lil average filter to remove some noise for the crosshair
    int index;

    while(1){
        //mass_dump();
        accel_dat d = readXYZ();
        //printf("x = %fg, y=%fg, z=%fg\r\n", ((float)d.x*t.coeff)+t.x, ((float)d.y*t.coeff)+t.y, ((float)d.z*t.coeff)+t.z);

        prev[index] = d;
        index = (index + 1) % PREV_SIZE;

        float avg_x = 0, avg_y = 0, avg_z = 0;
        for (int i = 0; i < PREV_SIZE; i++) {
            avg_x += (float)prev[i].x;
            avg_y += (float)prev[i].y;
            avg_z += (float)prev[i].z;
        }
        avg_x /= PREV_SIZE;
        avg_y /= PREV_SIZE;
        avg_z /= PREV_SIZE;

        sprintf(buf, "%.5f", dispVal==0 ? (avg_x*t.coeff)+t.x : dispVal == 1 ? (avg_y*t.coeff)+t.y : (avg_z*t.coeff))+t.z;
        int u = 0;
        for(int i = 0; i < 7; i++){
            if(buf[u] == '.' && u < 6){
                decs[i-1] |= 0b00010000; //add decimal point to prev
                u++;
            }
            if(buf[u] == '-'){
                decs[u] = 0b00001010;
                u++;
                continue;
            }
            decs[i] =  buf[u] - '0'; //char to dec
            u++;
        }

        alt_u8 ones = (decs[5]);
        alt_u8 tens = (decs[4]);
        alt_u8 hundreds = (decs[3]);
        alt_u8 thousands = (decs[2]);
        alt_u8 tens_thousands = (decs[1]);
        alt_u8 hundreds_thou = (decs[0]);

        IOWR_8DIRECT(AV2SEGM3_0_BASE, 0x0, ones);
        IOWR_8DIRECT(AV2SEGM3_0_BASE, 0x1, tens);
        IOWR_8DIRECT(AV2SEGM3_0_BASE, 0x2, hundreds);

        IOWR_8DIRECT(AV2SEGM3_1_BASE, 0x0, thousands);
        IOWR_8DIRECT(AV2SEGM3_1_BASE, 0x1, tens_thousands);
        IOWR_8DIRECT(AV2SEGM3_1_BASE, 0x2, hundreds_thou);

        x = (640/2)+ (((avg_x*t.coeff)+t.x)*(640/2));
        y = (480/2)+ (((avg_y*t.coeff)+t.y)*(480/2));

        //printf("x = %u; y = %u\n\r", x, y);

        IOWR(VGA_0_BASE, 0b00, x);
        IOWR(VGA_0_BASE, 0b01, y);
        usleep(100);
    }

    return 0;
}