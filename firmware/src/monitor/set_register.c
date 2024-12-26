#include <ctype.h>
#include <stdio.h>
#include <kernel/console.h>
#include "globals.h"
#include "parser.h"

void set_register(void)
{
  token_t token = get_token();
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
