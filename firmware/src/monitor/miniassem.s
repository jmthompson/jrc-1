; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************
;
; 65c816 mini-assembler, modled after the one included with the
; IIGS monitor.

        .include "common.inc"
        .include "syscalls.inc"
        .include "console.inc"
        .include "ascii.inc"
        .include "util.inc"

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
        lda     #CR
        _PrintChar
        lda     #LF
        _PrintChar
        lda     #'!'
        _PrintChar
        jsr     read_line
        getc
        beq     @exit
        _PrintString @erase
        _PrintString @msg
        lda     #CR
        _PrintChar
        lda     #LF
        _PrintChar
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
        lda     #'^'
        _PrintChar
        _PrintString @msg
        rts
@msg:   .byte   " Syntax error", CR, 0
