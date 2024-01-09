#include <ctype.h>
#include <stddef.h>
#include <string.h>
#include <calypsi/intrinsics65816.h>
#include <kernel/console.h>

static char input_buffer[256];
static char *ibuffp;
static const ibuffsz = sizeof(input_buffer);

struct token token;

__attribute__((simple_call))
int getc_seriala(void);

__attribute__((simple_call))
void putc_seriala(char character);

static void read_line()
{
    size_t count = 0;
    char *pos = input_buffer;

    while(count < ibuffsz-1) {
        int ch = getc_seriala();

        if (ch < 0) {
            __wait_for_interrupt();
        }
        else if ((ch == BS) && (count > 0)) {
          putc_seriala((char) ch);
          pos--;
          count--;
        }
        else if (ch == CR) {
            break;
        }
        else if (ch >= ' ') {
          *pos++ = (char) ch;
          putc_seriala((char) ch);
          count++;
        }
    }

    *pos = 0;
    ibuffp = input_buffer;
}

static void skip_whitespace(void)
{
    while (*buffp && (*buffp != ' ')) {
        buffp++;
    }
}

static int hex_to_bin(char c)
{
    if (isdigit(c)) {
        return c - '0';
    }
    else if ((c >= 'A') && (c <= 'Z')) {
        return c - 'A' + 10;
    }
    else if ((c >= 'a') && (c <= 'z')) {
        return c - 'a' + 10;
    }
    else {
        return -1;
    }
}

void next_token(void)
{
    skip_whitespace();

    token.type = TK_EOL;
    token.start = ibuffp;
    token.len  = 0;

    while (c = *ibuffp) {
        if (token.type == TK_CONST) {
        }
        else if (token.type == TK_STRING) {
        }
        else {
            if (isxdigit(c)) {
                token.type = TK_CONST;
                token.len  = 1;
                token.const_value = hex_to_bin(c);
                ibuffp++;
            }
            else if (c == '"') {
                token.type = TK_STRING;
                token.len  = 0;
                ibuffp++;
            }
            else {
                token.type = TK_CHAR;
                token.size = 1;
                token.char_value = c;
                ibuffp++;
                return;
            }
        }


            if (isxdigit(c)) {
                current_token.const_value = (current_token.const_value << 4) | hex_to_bin(c);
                in_const++;
            }
            else {
                    // figure out size, return token
            }
        }

        ibuffp++;
    }
}

mem_bank_t parse_bank(mem_bank_t default_bank)
{
    char *p = ibuffp;

    if (isxdigit(p[0]) && isxdigit(p[1]) && (p[2] == '/')) {
        return 
}

mem_ptr_t parse_adress(mem_bank_t default_bank)
{
    mem_ptr_t ptr;
    
    ptr.bank = default_bank;

    


    return ptr;
}

parse_address:
                ldx             ##4
                jsr             parse_hex
                beq             done$           ; No address present
                shortm
                lda             [ibuffp]
                cmp             #'/'            ; Was the parsed value a bank value?
                bne             addr$
                lda             arg
                sta             start_loc+2     ; set bank byte
                longm
                inc             ibuffp          ; Skip the "/"
                ldx             ##4
                jsr             parse_hex       ; Continue trying to parse an address
                beq             done$
addr$:          longm
                lda             arg
                sta             start_loc
done$:          rts

parse_hex:
                php
                longm
                stz             arg
                stz             arg + 2
                ldy             ##0
next$:          shortm
                lda             [ibuffp]
                cmp             #' '+1
                blt             done$
                sec
                sbc             #'0'
                cmp             #10
                blt             store$
                ora             #$20            ; shift uppercase to lowercase
                sbc             #'a'-'0'-10
                cmp             #10
                blt             done$
                cmp             #16
                bge             done$
store$:         longm
                asl             arg
                rol             arg + 2
                asl             arg
                rol             arg + 2
                asl             arg
                rol             arg + 2
                asl             arg
                rol             arg + 2
                shortm
                ora             arg
                sta             arg
                longm
                inc             ibuffp
                iny
                dex
                bne             next$
done$:          plp
                cpy             ##0
                rts

void parse_line()
{
    char * buffp = skip_whitespace(input_buffer);
}


;;
; Parse the current input line
;
parse_line:
                jsr             parse_address
                lda             start_loc
                sta             end_loc
                shortm
                lda             start_loc+2
                sta             end_loc+2

                lda             [ibuffp]
                cmp             #'.'            ; did they specify a memory range?
                bne             find$
                longm
                inc             ibuffp
                ldx             ##4
                jsr             parse_hex       ; get end range
                beq             bad$
                lda             arg
                cmp             start_loc
                blt             bad$
                sta             end_loc
                shortm
find$:          lda             [ibuffp]
                bne             :+
                lda             #'m'            ; if no command given default to 'm'
:               cmp             #'A'
                blt             :+
                cmp             #'Z'+1
                bge             :+
                ora             #$20            ; force lowercase
:               sta             cmd
                ldx             ##0
loop$:          lda             f:commands,X
                cmp             cmd
                beq             match$
                inx
                cpx             ##num_commands
                bne             loop$
                bra             bad$
match$:         longm
                inc             ibuffp
                txa
                clc
                rts
bad$:           longm
                lda             ibuffp
                pha
                pea             .hiword(Monitor::UNKNOWN_COMMAND)
                pea             .loword(Monitor::UNKNOWN_COMMAND)
                jsr             print_error
                sec
                rts

