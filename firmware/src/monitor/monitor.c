#include "monitor.h"
#include "commands.h"
#include "globals.h"
#include "parser.h"
#include <calypsi/intrinsics65816.h>
#include <ctype.h>
#include <kernel/console.h>

const char __far brk_banner[] = "*** Break ***\n\0";
const char __far nmi_banner[] = "*** NMI ***\n\0";
const char __far start_banner[] = "Monitor Ready.\n\0";

__attribute__((simple_call)) int getc_seriala(void);
__attribute__((simple_call)) void putc_seriala(char character);

static char __near input_buffer[IBUFFSZ];
static char __near *ibuffp;

static void capture_registers(void)
{
  __asm(" lda   4,s\n"
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
        " rep   #0x20\n");
}

static void show_registers(void)
{
  printf(
      "A=%04X X=%04X Y=%04X P=%02X S=%04X B=%02X D=%04X PC=%04X K=%02X m=%1d x=%1d\n", a_reg, x_reg, y_reg, p_reg, s_reg, b_reg,
      d_reg, pc_reg, k_reg, m_width, x_width
  );
}

/**
 * Read a line of input to input_buffer. Input stops when ENTER
 * is received or the buffer fills.
 */
static void read_line()
{
  size_t count = 0;
  char __near *pos = input_buffer;

  while (count < IBUFFSZ - 1) {
    int ch = getc_seriala();

    if (ch < 0) {
      __wait_for_interrupt();
    } else if ((ch == BS) && (count > 0)) {
      putc_seriala((char)ch);
      pos--;
      count--;
    } else if (ch == CR) {
      break;
    } else if (ch >= ' ') {
      *pos++ = (char)ch;
      putc_seriala((char)ch);
      count++;
    }
  }

  *pos = 0;
}

void monitor_loop(void)
{
  while (1) {
    printf("\n* ");
    read_line();
    putc_seriala('\n');

    reset_scanner(input_buffer);

    int token = get_token();

    if (token == TK_LITERAL) {
      if (parse_range(&start_loc, &end_loc)) {
        syntax_error();
      }

      continue;
    }

    unsigned char cmd;

    if (token == TK_EOL) {
      cmd = 'M';
    } else if (token == TK_IDENTIFIER) {
      cmd = toupper(*token_ptr);
    } else {
      syntax_error();
      continue;
    }

    switch (cmd) {
    case 'L':
      disassemble();
    case 'M':
      dump_memory();
    default:
      syntax_error();
    }
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
  start_loc.ptr = end_loc.ptr = 0;
  m_width = x_width = 0;

  printf(start_banner);
  monitor_loop();
}

/*
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
