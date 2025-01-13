#include "sys/alt_stdio.h"
#include "system.h"
#include "io.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"
#include "unistd.h"
#include "stdbool.h"

int main() {
    alt_u16 segmVal = 0;
    while (1) {
        alt_u8 ones = segmVal % 10;
        alt_u8 tens = (segmVal / 10) % 10;
        alt_u8 hundreds = (segmVal / 100) % 10;

        IOWR_8DIRECT(AV2SEGM3_0_BASE, 0x0, ones);
        alt_printf("ones: %x\r\n", ones);
        IOWR_8DIRECT(AV2SEGM3_0_BASE, 0x1, tens);
        alt_printf("tens: %x\r\n", tens);
        IOWR_8DIRECT(AV2SEGM3_0_BASE, 0x2, hundreds);
        alt_printf("hundreds: %x\r\n", hundreds);

        segmVal++;
        if (segmVal > 999) {
            segmVal = 0;
        }

        usleep(100000);
    }
    return 0;
}
