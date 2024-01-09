#include <kernel/console.h>
#include "monitor.h"
#include "parser.h"

const char __far brk_banner[] = "*** Break ***\n\0";
const char __far nmi_banner[] = "*** NMI ***\n\0";
const char __far start_banner[] = "Monitor Ready.\n\0";

char *ibuffp;

void capture_registers(void)
{
    __asm(
      " lda   4,s\n"
      " sta   .near y_reg\n"
      " lda   6,s\n"
      " sta   .near x_reg\n"
      " lda   8,s\n"
      " sta   .near a_reg\n"
      " lda   10,s\n"
      " sta   .near d_reg\n"
      " lda   14,s\n"
      " dec   a\n"
      " dec   a\n"
      " sta   .near pc_reg\n"
      " tsc\n"
      " clc\n"
      " adc   ##16\n"
      " sta   .near s_reg\n"
      " sep   #0x20\n"
      " lda   12,s\n"
      " sta   .near b_reg\n"
      " lda   13,s\n"
      " sta   .near p_reg\n"
      " lda   16,s\n"
      " sta   .near k_reg\n"
      " rep   #0x20\n"
    );
}

void show_registers(void)
{
    printf("A=%04X X=%04X Y=%04X P=%02X S=%04X B=%02X D=%04X PC=%04X K=%02X m=%1d x=%1d\n",
      a_reg, x_reg, y_reg, p_reg, s_reg, b_reg, d_reg, pc_reg, k_reg, m_width, x_width
    );
}

void monitor_loop(void)
{
    while(1) {
        printf("\n* ");
        read_line(input_buffer, sizeof(input_buffer));
    }
}

void monitor_brk(void)
{
    capture_registers();
    printf(brk_banner);
    show_registers();
    monitor_loop();
}

void monitor_nmi(void)
{
    capture_registers();
    printf(nmi_banner);
    show_registers();
    monitor_loop();
}

void monitor_start(void)
{
    printf(start_banner);
    monitor_loop();
}

/*
dump_memory:
                shortm
                lda             start_loc
                ora             #7
                sta             row_end
                puthex          start_loc+2
                putc            #'/'
                puthex          start_loc+1
                lda             start_loc+1
                cmp             end_loc+1
                bne             ok$             ; if high bytes don't match we are definitely
                lda             end_loc         ; not at the end of the row. If they are then
                cmp             row_end         ; check the low bytes
                bcs             ok$
                sta             row_end         ; cap row end to range end
ok$:            lda             start_loc
                pha             ; save original start for ascii loop
                jsl             print_hex
                putc            #':'
loop1$:         putc            #' '
                lda             [start_loc]
                jsl             print_hex
                lda             start_loc
                cmp             row_end         ; at last byte of line?
                beq             ascii$          ; yes, so now draw the ascii version
                inc
                sta             start_loc
                bra             loop1$
ascii$:         putc            #' '
                putc            #'|'
                putc            #' '
                pla
                sta             start_loc
loop2$:         lda             [start_loc]
                and             #$7F
                cmp             #' '
                bcs             printable$
                lda             #'?'
printable$:
                _putchar
                lda             start_loc
                cmp             row_end
                beq             endofrow$
                inc
                sta             start_loc
                bra             loop2$
endofrow$:
                puteol
                lda             start_loc+1
                cmp             end_loc+1
                bne             nextrow$
                lda             row_end
                cmp             end_loc
                bne             nextrow$
                longm
                lda             end_loc
                inc
                sta             start_loc
                rts
nextrow$:
                lda             row_end
                clc
                adc             #1
                sta             start_loc
                lda             start_loc+1
                adc             #0
                sta             start_loc+1
                jmp             dump_memory

set_memory:
                jsr             skip_whitespace
                shortm
                lda             [ibuffp]
                cmp             #$27            ; '
                bne             hex$
ascii$:         longm
                inc             ibuffp
                shortm
                lda             [ibuffp]
                beq             done$
                sta             [start_loc]
                longm
                inc             start_loc
                shortm
                bra             ascii$
hex$:           jsr             skip_whitespace
                ldx             ##2
                jsr             parse_hex
                beq             done$
                shortm
                lda             arg
                sta             [start_loc]
                longm
                inc             start_loc
                shortm
                bra             hex$
done$:          longm
                rts

;;
; Perform a simulated JSL to the code at start_loc. The code will
; be called in full 16-bit mode.
;
run_code:
                phk
                pea             .loword(@ret)-1
                shortm
                lda             start_loc+2
                pha
                longm
                lda             start_loc
                dec
                pha
                lda             a_reg
                ldx             x_reg
                ldy             y_reg
                rtl
ret$:           longmx
                sta             a_reg
                stx             x_reg
                sty             y_reg
                rts

monitor_exit:
                pla             ; pop return address of the dispatcher
                pla
                lda             ##0
                clc
                rtl

xmodem_send:
                shortm
                lda             start_loc
                sta             xmptr
                lda             start_loc+1
                sta             xmptr+1
                lda             start_loc+2
                sta             xmptr+2
                lda             end_loc
                sta             xmeofp
                lda             end_loc+1
                sta             xmeofp+1
                lda             end_loc+2
                sta             xmeofp+2
                jsr             XModemSend
                longm
                rts

xmodem_receive:
                lda             start_loc
                sta             xmptr
                shortm
                lda             start_loc+2
                sta             xmptr+2
                jsr             XModemRcv
                longm
                rts

set_register:
                shortm
                lda             [ibuffp]        ; grab two chars so we can test for 'DB'
                cmp             #'A'
                beq             a$
                cmp             #'B'
                beq             b$
                cmp             #'D'
                beq             d$
                cmp             #'P'
                beq             p$
                cmp             #'X'
                beq             x$
                cmp             #'Y'
                beq             y$
                cmp             #'m'
                beq             mw$
                cmp             #'x'
                beq             xw$
err$:           longm
                lda             ibuffp
                pha
                pea             .hiword(Monitor::UNKNOWN_REGISTER)
                pea             .loword(Monitor::UNKNOWN_REGISTER)
                jsr             print_error
                rts
a$:             longm
                lda             arg
                sta             a_reg
                rts
b$:             lda             arg
                sta             b_reg
                longm
                rts
d$:             longm
                lda             arg
                sta             d_reg
                rts
p$:             lda             arg
                sta             p_reg
                longm
                rts
x$:             longm
                lda             arg
                sta             x_reg
                rts
y$:             longm
                lda             arg
                sta             y_reg
                rts
mw$:            lda             arg
                and             #1
                sta             m_width
                longm
                rts
xw$:            lda             arg
                and             #1
                sta             x_width
                longm
                rts
*/
