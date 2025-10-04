; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "stdio.inc"
        .include "fcntl.inc"
        .include "ascii.inc"
        .include "kernel/syscall_macros.inc"

        .include "constants.inc"

        .export   monitor_brk, monitor_nmi, monitor_start

        .import   print_hex, read_line
        .import   parse_address, parse_hex, skip_whitespace, print_error
        .import   assemble, disassemble, mon_show_heap, XModemRcv, XModemSend
        .import   arg, ibuff, IBUFFSZ
        .importzp cmd, end_loc, ibuffp, row_end, start_loc, xmptr, xmeofp

        .import   a_reg,b_reg,d_reg,p_reg,s_reg,x_reg,y_reg,pc_reg,k_reg,m_width,x_width

        .segment "OSROM"

commands:
        .byte   'h'
        .byte   'l'
        .byte   'm'
        .byte   'g'
        .byte   'q'
        .byte   '<'
        .byte   '>'
        .byte   ':'
        .byte   '!'
        .byte   '#'
        .byte   '='

num_commands = *-commands

.macro putc char
        lda char
        _putchar
.endmacro

.macro puteol
        lda #CR
        _putchar
        lda #LF
        _putchar
.endmacro

.macro puthex value
        lda     value
        jsl     print_hex
.endmacro

handlers:
        .addr   mon_show_heap-1
        .addr   disassemble-1
        .addr   dump_memory-1
        .addr   run_code-1
        .addr   monitor_exit-1
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
        pha
        _PushLong @console
        _PushWord 0
        _PushWord O_RDONLY
        _open               ; open stdin
        pla
        pha
        _PushLong @console
        _PushWord 0
        _PushWord O_WRONLY
        _open               ; open stdou
        pla
        pha
        _PushLong @console
        _PushWord 0
        _PushWord O_WRONLY
        _open               ; open stderr
        pla
        shortm
        stz     m_width
        stz     x_width
        longm
        _puts   start_banner
        bra     monitor_loop

@console:
        .asciiz "/dev/console"

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
        _puts   brk_banner
        jsr     print_registers
        bra     monitor_loop

;;
; System NMI handler
;
monitor_nmi:
        longmx
        jsr     capture_registers
        _puts   nmi_banner
        jsr     print_registers
        ; fall through

monitor_loop:        
        _puts   @prompt
        ldaw    #.hiword(ibuff)
        sta     ibuffp+2
        pha
        ldaw    #.loword(ibuff)
        sta     ibuffp
        pha
        pea     IBUFFSZ
        jsl     read_line
        jsr     parse_line
        bcs     monitor_loop
        pha
        ldaw    #CR
        _putchar
        ldaw    #LF
        _putchar
        pla
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
        jsr     skip_whitespace
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
        ldxw    #4
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
@bad:   longm
        lda     ibuffp
        pha
        pea     .hiword(Monitor::UNKNOWN_COMMAND)
        pea     .loword(Monitor::UNKNOWN_COMMAND)
        jsr     print_error
        sec
        rts

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
        putc    #' '
        putc    #'m'
        putc    #'='
        lda     m_width
        ora     #'0'
        _putchar
        putc    #' '
        putc    #'x'
        putc    #'='
        lda     x_width
        ora     #'0'
        _putchar
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
        _putchar
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
        ldxw    #2
        jsr     parse_hex
        beq     @done
        shortm
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
        ldaw    #0
        clc
        rtl

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
        cmp     #'m'
        beq     @mw
        cmp     #'x'
        beq     @xw
@err:   longm
        lda     ibuffp
        pha
        pea     .hiword(Monitor::UNKNOWN_REGISTER)
        pea     .loword(Monitor::UNKNOWN_REGISTER)
        jsr     print_error
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
@mw:    lda     arg
        and     #1
        sta     m_width
        longm
        rts
@xw:    lda     arg
        and     #1
        sta     x_width
        longm
        rts
