; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/console.s"

        .import disassemble
        .import XModemSend
        .import XModemRcv
        .import flash_update

        .importzp   cmd
        .importzp   arg
        .importzp   address
        .importzp   start_loc
        .importzp   end_loc
        .importzp   row_end
        .importzp   ibuffp
        .importzp   xmptr
        .importzp   xmeofp

        .export monitor_start
        .export monitor_brk
        .export monitor_nmi

        .export print_spaces

; Get a single character
.macro  getc
        lda     [ibuffp]
.endmacro

; Advance to the next character
.macro  nextc
        inc      ibuffp
.endmacro

maxhex  = 8

        .segment "SYSDATA": far

a_reg:      .res    2
x_reg:      .res    2
y_reg:      .res    2
sp_reg:     .res    2
d_reg:      .res    2
pc_reg:     .res    2
pb_reg:     .res    1
db_reg:     .res    1
sr_reg:     .res    1

            .align 256
ibuff:      .res   256

        .segment "BIOSROM"

commands:
        .byte   'l'
        .byte   'm'
        .byte   'g'
        .byte   'q'
        .byte   'u'
        .byte   '<'
        .byte   '>'
        .byte   ':'

num_commands = *-commands

handlers:
        .addr   disassemble-1
        .addr   dump_memory-1
        .addr   run_code-1
        .addr   monitor_exit-1
        .addr   flash_update-1
        .addr   xmodem_receive-1
        .addr   xmodem_send-1
        .addr   set_memory-1

brk_banner:
        .byte   "*** Break ***", CR, 0
nmi_banner:
        .byte   "*** NMI ***", CR, 0
start_banner:
        .byte   "Monitor Ready.", CR, 0

monitor_start:
        ;phk
        ;plb
        puts    start_banner
        bra     monitor_loop

capture_registers:
        longm
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
        sta     sp_reg
        shortmx
        lda     11,s
        sta     db_reg
        lda     12,s
        sta     sr_reg
        lda     15,s
        sta     pb_reg
        rts

monitor_brk:
        jsr     capture_registers
        puts    brk_banner
        jsr     print_registers
        jmp     monitor_loop

monitor_nmi:
        jsr     capture_registers
        puts    nmi_banner
        jsr     print_registers

monitor_loop:        
        puteol
        putc    #'*'
        putc    #'>'
        gets    ibuff
        puteol
        jsr     parse_ibuff
        bcs     monitor_loop
        jsr     dispatch
        bra     monitor_loop

dispatch:
        asl
        tax
        longm
        lda     f:handlers,x
        pha
        shortm
        rts

;;
;
; Attempt to parse up to six hex digits at the current ibuff
; and store the result in arg.
;
; On exit:
;
;   c : Set if at least one digit was parsed
;   Y : number of digits parsed. 0 -> 8
;
parsehex:
        longm
        stz     arg 
        stz     arg+2
        shortm
        ldy     #0
@next:  getc
        cmp     #' '+1
        blt     @done
        sec
        sbc     #'0'
        cmp     #10
        blt     @store
        ora     #$20            ; shift uppercase to lowercase
        sbc     #'a'-'0'-10
        cmp     #10
        blt     @done
        cmp     #16
        bge     @done
@store: longm
        asl     arg
        rol     arg+2
        asl     arg
        rol     arg+2
        asl     arg
        rol     arg+2
        asl     arg
        rol     arg+2
        shortm
        ora     arg
        sta     arg
        nextc
        iny
        cpy     #maxhex
        bne     @next
@done:  cpy     #1
        rts

;
; Parse the current ibuff
;
parse_ibuff:
        lda     #<ibuff
        sta     ibuffp
        lda     #>ibuff
        sta     ibuffp+1
        lda     #^ibuff
        sta     ibuffp+2
        jsr     parsehex
        longm
        bcc     @nostart

        lda     arg
        sta     start_loc
        lda     arg+1       ; overlap so we only copy three bytes
        sta     start_loc+1
@nostart:
        lda     start_loc
        sta     end_loc
        lda     start_loc+1
        sta     end_loc+1
        shortm

        getc
        cmp     #'.'            ; did they specify a memory range?
        bne     @find
        nextc
        jsr     parsehex       ; get end range
        bcc     @bad
        longm
        lda     arg
        sta     end_loc
        lda     arg+1
        sta     end_loc+1
        shortm

@find:  getc
        bne     @found
        lda     #'m'        ; if no command given default to 'm'
@found: sta     cmd
        ldx     #0
@loop:  lda     f:commands,x
        cmp     cmd
        beq     @match
        inx
        cpx     #num_commands
        bne     @loop
        bra     @bad
@match: nextc
        txa
        clc
        rts
@bad:   jsr     syntax_error
        sec
        rts

;;
; Display the position of a syntax error in the input buffer
; The error is assumed to be at the current input index.
;
syntax_error:
        ldx     ibuffp
        inx
        inx
        jsr     print_spaces
        putc    #'^'
        puts    @msg
        rts

@msg:   .byte   " Error", CR, 0

;
; Print out a string of space whose length is given in the X register.
; X may be zero, in which case nothing is printed.
;
print_spaces:
        cpx     #0
        beq     @exit
        pha
        phx
@loop:  lda     #' '
        call    SYS_CONSOLE_WRITE
        dex
        bne     @loop
        plx
        pla
@exit:  rts

;
; Skip input_index ahead to either the first non-whitespace character,
; or the end of line NULL, whichever occurs first.
;
skip_whitespace:
        pha
@loop:  getc
        beq     @exit
        cmp     #' '+1
        bge     @exit
        nextc
        bra     @loop
@exit:  pla
        rts

;
; Display the values of the saved CPU registers.
;
print_registers:
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
        putc    #'S'
        putc    #'R'
        putc    #'='
        puthex  sr_reg
        putc    #' '
        putc    #'S'
        putc    #'P'
        putc    #'='
        puthex  sp_reg+1
        puthex  sp_reg
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
        putc    #'P'
        putc    #'B'
        putc    #'='
        puthex  pb_reg
        putc    #' '
        putc    #'D'
        putc    #'B'
        putc    #'='
        puthex  db_reg
        puteol
        rts

dump_memory:
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
        call    SYS_CONSOLE_WRITE
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
        shortm
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
        getc
        cmp     #$27                ; '
        bne     @hex
@ascii: nextc
        getc
        beq     @done
        sta     [start_loc]
        longm
        inc     start_loc
        shortm
        bra     @ascii
@hex:   jsr     skip_whitespace
        jsr     parsehex
        bcc     @done
        lda     arg
        sta     [start_loc]
        longm
        inc     start_loc
        shortm
        bra     @hex
@done:  rts

run_code:
        phk
        longm
        ldaw    #(@ret & $ffff)-1
        pha
        shortm
        lda     start_loc+2
        pha
        longm
        lda     start_loc
        dec
        pha
        shortm
        rtl
@ret:   rts

monitor_exit:
        pla                         ; pop return address of the dispatcher
        pla
        rts

xmodem_send:
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
        jmp     XModemSend

xmodem_receive:
        lda     start_loc
        sta     xmptr
        lda     start_loc+1
        sta     xmptr+1
        lda     start_loc+2
        sta     xmptr+2
        jmp     XModemRcv
