#include "sys/alt_stdio.h"
#include "system.h"
#include "io.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "unistd.h"
#include "stdbool.h"

volatile alt_u16 segmVal = 0;
volatile bool update_display = false;

static void timer_isr(void *context) {
    alt_printf("trig\r\n");
    IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_0_BASE, 0);
    segmVal++;
    if (segmVal > 999) {
        segmVal = 0;
    }
    update_display = true;
}

int main() {
    alt_printf("init\r\n");
    alt_ic_irq_disable(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID, TIMER_0_IRQ);
    alt_ic_isr_register(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID, TIMER_0_IRQ, timer_isr, 0x00, 0x00);
    alt_ic_irq_enable(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID, TIMER_0_IRQ);

    alt_printf("Starting Timer Interrupt Demo\r\n");

    while (1) {
        if (update_display) {
            alt_u8 ones = segmVal % 10;
            alt_u8 tens = (segmVal / 10) % 10;
            alt_u8 hundreds = (segmVal / 100) % 10;

            IOWR_8DIRECT(AV2SEGM3_0_BASE, 0x0, ones);
            IOWR_8DIRECT(AV2SEGM3_0_BASE, 0x1, tens);
            IOWR_8DIRECT(AV2SEGM3_0_BASE, 0x2, hundreds);

            alt_printf("Value: %x\r\n", segmVal);
            update_display = false;
        }
       usleep(10000);
    }

    return 0;
}