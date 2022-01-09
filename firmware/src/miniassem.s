; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************
;
; 65c816 mini-assembler, modled after the one included with the
; IIGS monitor.

        .include "common.s"
        .include "sys/console.s"
        .include "sys/util.s"

        .export assemble

        .import read_line
        .import parse_address
        .import parse_hex
        .import print_spaces

        .importzp   arg
        .importzp   ibuffp
        .importzp   start_loc

        .segment "OSROM"

;;
; Entry point for the monitor's (!) command
;;
assemble:
        puteol
        putc    #'!'
        jsr     read_line
        getc
        beq     @exit
        puts    @erase
        puts    @msg
        puteol
        bra     assemble
@exit:  rts

@erase: .byte   ESC, LBRACKET, "2K", 0
@msg:   .byte   "got it", 0

parse_line:
        jsr     parse_address
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
@msg:   .byte   " Syntax error", CR, 0
