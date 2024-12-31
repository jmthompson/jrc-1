#include "globals.h"
#include "messages.h"
#include "parser.h"
#include <ctype.h>
#include <kernel/console.h>
#include <stdio.h>

void set_register(void)
{
  token_t token = get_token();

  if ((token != TK_LITERAL) && (token != TK_IDENTIFIER)) {
    parse_error(UNEXPECTED_TOKEN);
    return;
  }
  if (token_len != 1) {
    parse_error(UNKNOWN_REGISTER);
    return;
  }

  unsigned char reg = *token_ptr;

  if (get_token() != TK_EQUALS) {
    parse_error(UNEXPECTED_TOKEN);
    return;
  }

  token = get_token();
  if (token != TK_LITERAL) {
    parse_error(UNEXPECTED_TOKEN);
    return;
  }

  unsigned int value = token_to_uint16();

  switch (reg) {
  case 'A':
    a_reg = value;
    break;
  case 'B':
    b_reg = value & 0xFF;
    break;
  case 'D':
    d_reg = value;
    break;
  case 'P':
    d_reg = value & 0xFF;
    break;
  case 'X':
    x_reg = value;
    break;
  case 'Y':
    y_reg = value;
    break;
  case 'm':
    m_width = value & 0x01;
    break;
  case 'x':
    x_width = value & 0x01;
    break;
  default:
    parse_error(UNKNOWN_REGISTER);
    break;
  }
}
#if 0
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
#endif
