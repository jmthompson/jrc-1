; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "console.inc"
        .include "ascii.inc"

        .import disassemble
        .import assemble
        .import read_line
        .import parse_address
        .import parse_hex
        .import print_hex
        .import print_spaces
        .import XModemSend
        .import XModemRcv
        .import mon_show_handles
        ;.import flash_update

        .importzp   cmd
        .importzp   arg
        .importzp   start_loc
        .importzp   end_loc
        .importzp   row_end
        .importzp   xmptr
        .importzp   xmeofp

        .importzp   ibuffp
        .import     ibuff
        .import     IBUFFSZ

        .export monitor_start
        .export monitor_brk
        .export monitor_nmi

        .segment "BSS"

a_reg:      .res    2
b_reg:      .res    1
d_reg:      .res    2
p_reg:      .res    1
s_reg:      .res    2
x_reg:      .res    2
y_reg:      .res    2
pc_reg:     .res    2
k_reg:      .res    1

        .segment "OSROM"

commands:
        .byte   'h'
        .byte   'l'
        .byte   'm'
        .byte   'g'
        .byte   'q'
        ;.byte   'u'
        .byte   '<'
        .byte   '>'
        .byte   ':'
        .byte   '!'
        .byte   '#'
        .byte   '='

num_commands = *-commands

.macro putc char
        lda char
        _PrintChar
.endmacro

.macro puteol
        lda #CR
        _PrintChar
        lda #LF
        _PrintChar
.endmacro

.macro puthex value
        lda     value
        jsl     print_hex
.endmacro

handlers:
        .addr   mon_show_handles-1
        .addr   disassemble-1
        .addr   dump_memory-1
        .addr   run_code-1
        .addr   monitor_exit-1
        ;.addr   flash_update-1
        .addr   xmodem_receive-1
        .addr   xmodem_send-1
        .addr   set_memory-1
        .addr   assemble-1
        .addr   print_registers-1
        .addr   set_register-1

brk_banner:
        .byte   "*** Break ***", CR, LF, 0
nmi_banner:
        .byte   "*** NMI ***", CR, LF, 0
start_banner:
        .byte   "Monitor Ready.", CR, LF, 0

monitor_start:
        _PrintString start_banner
        bra     monitor_loop

;;
; Capture the processor registers from an IRQ/NMI/BRK stack frame
;
capture_registers:
        lda     3,s
        sta     y_reg
        lda     5,s
        sta     x_reg
        lda     7,s
        sta     a_reg
        lda     9,s
        sta     d_reg
        lda     13,s
        dec
        dec
        sta     pc_reg
        tsc
        clc
        adcw    #15
        sta     s_reg
        shortm
        lda     11,s
        sta     b_reg
        lda     12,s
        sta     p_reg
        lda     15,s
        sta     k_reg
        longm
        rts

;;
; System BRK handler
;
monitor_brk:
        longmx
        jsr     capture_registers
        _PrintString brk_banner
        jsr     print_registers
        bra     monitor_loop

;;
; System NMI handler
;
monitor_nmi:
        longmx
        jsr     capture_registers
        _PrintString nmi_banner
        jsr     print_registers
        ; fall through

monitor_loop:        
        _PrintString @prompt
        ldaw    #.hiword(ibuff)
        sta     ibuffp+2
        pha
        ldaw    #.loword(ibuff)
        sta     ibuffp
        pha
        pea     IBUFFSZ
        jsl     read_line
        ldaw    #CR
        _PrintChar
        ldaw    #LF
        _PrintChar
        jsr     parse_line
        bcs     monitor_loop
        jsr     dispatch
        bra     monitor_loop
@prompt: .byte  CR, LF, '*', 0

dispatch:
        andw    #255
        asl
        tax
        lda     f:handlers,X
        pha
        rts

;;
; Parse the current input line
;
parse_line:
        jsr     parse_address
        lda     start_loc
        sta     end_loc
        shortm
        lda     start_loc+2
        sta     end_loc+2

        lda     [ibuffp]
        cmp     #'.'            ; did they specify a memory range?
        bne     @find
        longm
        inc     ibuffp
        jsr     parse_hex       ; get end range
        beq     @bad
        lda     arg
        cmp     start_loc
        blt     @bad
        sta     end_loc
        shortm
@find:  lda     [ibuffp]
        bne     :+
        lda     #'m'        ; if no command given default to 'm'
:       cmp     #'A'
        blt     :+
        cmp     #'Z'+1
        bge     :+
        ora     #$20        ; force lowercase
:       sta     cmd
        ldxw    #0
@loop:  lda     f:commands,X
        cmp     cmd
        beq     @match
        inx
        cpxw    #num_commands
        bne     @loop
        bra     @bad
@match: longm
        inc     ibuffp
        txa
        clc
        rts
@bad:   jsr     syntax_error
        longm
        sec
        rts

syntax_error:
        _PrintString @msg
        rts
@msg:   .byte   "Syntax Error", CR, LF, 0

;
; Display the values of the saved CPU registers.
;
print_registers:
        shortm
        putc    #'A'
        putc    #'='
        puthex  a_reg+1
        puthex  a_reg
        putc    #' '
        putc    #'X'
        putc    #'='
        puthex  x_reg+1
        puthex  x_reg
        putc    #' '
        putc    #'Y'
        putc    #'='
        puthex  y_reg+1
        puthex  y_reg
        putc    #' '
        putc    #'P'
        putc    #'='
        puthex  p_reg
        putc    #' '
        putc    #'S'
        putc    #'='
        puthex  s_reg+1
        puthex  s_reg
        putc    #' '
        putc    #'B'
        putc    #'='
        puthex  b_reg
        putc    #' '
        putc    #'D'
        putc    #'='
        puthex  d_reg+1
        puthex  d_reg
        putc    #' '
        putc    #'P'
        putc    #'C'
        putc    #'='
        puthex  pc_reg+1
        puthex  pc_reg
        putc    #' '
        putc    #'K'
        putc    #'='
        puthex  k_reg
        puteol
        longm
        rts

dump_memory:
        shortm
        lda     start_loc
        ora     #7
        sta     row_end
        puthex  start_loc+2
        putc    #'/'
        puthex  start_loc+1
        lda     start_loc+1
        cmp     end_loc+1
        bne     @ok         ; if high bytes don't match we are definitely
        lda     end_loc     ; not at the end of the row. If they are then
        cmp     row_end     ; check the low bytes
        bcs     @ok         
        sta     row_end     ; cap row end to range end
@ok:    lda     start_loc
        pha                 ; save original start for ascii loop
        jsl     print_hex
        putc    #':'
@loop1: putc    #' '
        lda     [start_loc]
        jsl     print_hex
        lda     start_loc    
        cmp     row_end     ; at last byte of line?
        beq     @ascii      ; yes, so now draw the ascii version
        inc
        sta     start_loc
        bra     @loop1
@ascii: putc    #' '
        putc    #'|'
        putc    #' '
        pla
        sta     start_loc
@loop2: lda     [start_loc]
        and     #$7F
        cmp     #' '
        bcs     @printable
        lda     #'?'
@printable:
        _PrintChar
        lda     start_loc
        cmp     row_end
        beq     @endofrow
        inc
        sta     start_loc
        bra     @loop2
@endofrow:
        puteol
        lda     start_loc+1
        cmp     end_loc+1
        bne     @nextrow
        lda     row_end
        cmp     end_loc
        bne     @nextrow
        longm
        lda     end_loc
        inc
        sta     start_loc
        rts
@nextrow:
        lda     row_end
        clc
        adc     #1
        sta     start_loc
        lda     start_loc+1
        adc     #0
        sta     start_loc+1
        jmp     dump_memory

set_memory:
        jsr     skip_whitespace
        shortm
        lda     [ibuffp]
        cmp     #$27                ; '
        bne     @hex
@ascii: longm
        inc     ibuffp
        shortm
        lda     [ibuffp]
        beq     @done
        sta     [start_loc]
        longm
        inc     start_loc
        shortm
        bra     @ascii
@hex:   jsr     skip_whitespace
        jsr     parse_hex
        beq     @done
        lda     arg
        sta     [start_loc]
        longm
        inc     start_loc
        shortm
        bra     @hex
@done:  longm
        rts

;;
; Perform a simulated JSL to the code at start_loc. The code will
; be called in full 16-bit mode.
;
run_code:
        phk
        pea     .loword(@ret)-1
        shortm
        lda     start_loc+2
        pha
        longm
        lda     start_loc
        dec
        pha
        lda     a_reg
        ldx     x_reg
        ldy     y_reg
        rtl
@ret:   longmx
        sta     a_reg
        stx     x_reg
        sty     y_reg
        rts

monitor_exit:
        pla                         ; pop return address of the dispatcher
        pla
        rts

xmodem_send:
        shortm
        lda     start_loc
        sta     xmptr
        lda     start_loc+1
        sta     xmptr+1
        lda     start_loc+2
        sta     xmptr+2
        lda     end_loc
        sta     xmeofp
        lda     end_loc+1
        sta     xmeofp+1
        lda     end_loc+2
        sta     xmeofp+2
        jsr     XModemSend
        longm
        rts

xmodem_receive:
        lda     start_loc
        sta     xmptr
        shortm
        lda     start_loc+2
        sta     xmptr+2
        jsr     XModemRcv
        longm
        rts

set_register:
        shortm
        lda     [ibuffp]        ; grab two chars so we can test for 'DB'
        cmp     #'A'
        beq     @a
        cmp     #'B'
        beq     @b
        cmp     #'D'
        beq     @d
        cmp     #'P'
        beq     @p
        cmp     #'X'
        beq     @x
        cmp     #'Y'
        beq     @y
@err:   jsr     syntax_error
        longm
        rts
@a:     longm
        lda     arg
        sta     a_reg
        rts
@b:     lda     arg
        sta     b_reg
        longm
        rts
@d:     longm
        lda     arg
        sta     d_reg
        rts
@p:     lda     arg
        sta     p_reg
        longm
        rts
@x:     longm
        lda     arg
        sta     x_reg
        rts
@y:     longm
        lda     arg
        sta     y_reg
        rts

;;
; Skip input_index ahead to either the first non-whitespace character,
; or the end of line NULL, whichever occurs first.
;
skip_whitespace:
@loop:  shortm
        lda     [ibuffp]
        beq     @exit
        cmp     #' '+1
        bge     @exit
        longm
        inc     ibuffp
        bra     @loop
@exit:  longm
        rts
