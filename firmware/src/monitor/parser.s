; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; This file contains subroutines used by the monitor for parsing the
; input buffer.
;

        .include "common.inc"
        .include "ascii.inc"
        .include "console.inc"
        .include "syscalls.inc"
        .include "syscall_macros.inc"

        .include "parser.inc"

        .import   arg, error_loc, error_msg, ibuff
        .importzp ibuffp, maxhex, start_loc

        .segment "OSROM"

;;
; Attempt to parse an address from ibuffp into start_loc. An address
; can be of the form $XXYY or $BB/XXYY. If no bank is specified the
; existing bank value is used.
;
; If no valid hex address could be parsed, start_loc is unchanged.
;
; On exit:
;
; ibuffp    = Points to input buffer after any parsed address
; start_loc = parsed address
;
.proc parse_address
        ldxw    #4
        jsr     parse_hex
        beq     @done       ; No address present
        shortm
        lda     [ibuffp]
        cmp     #'/'        ; Was the parsed value a bank value?
        bne     @addr
        lda     arg
        sta     start_loc+2 ; set bank byte
        longm
        inc     ibuffp      ; Skip the "/"
        ldxw    #4
        jsr     parse_hex   ; Continue trying to parse an address
        beq     @done
@addr:  longm
        lda     arg
        sta     start_loc
@done:  rts
.endproc

;;
; Attempt to parse up to 8 hex digits at the current ibuffp
; and return the results in arg.
;
; On entry:
; X = maximum number of digits to parse
;
; On exit:
;
; Y = number of digits parsed
; n = reflects value in Y
;
.proc parse_hex
        php
        longm
        stz     arg
        stz     arg + 2
        ldyw    #0
@next:  shortm
        lda     [ibuffp]
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
        rol     arg + 2
        asl     arg
        rol     arg + 2
        asl     arg
        rol     arg + 2
        asl     arg
        rol     arg + 2
        shortm
        ora     arg
        sta     arg
        longm
        inc     ibuffp
        iny
        dex
        bne     @next
@done:  plp
        cpyw    #0
        rts
.endproc

;;
; Check to see if the character in A is a hexidecimal digit.
;
; On exit:
; c = 0 if character is a hex digit
; c = 1 if character is not a hex digit
;
.proc is_hex_digit
        php
        shortm
        pha
        cmp     #'0'
        blt     @no
        cmp     #'9'+1
        blt     @yes        ; it's 0..9
        ora     #$20        ; shift uppercase to lower case
        cmp     #'a'
        blt     @no
        cmp     #'f'+1
        bge     @no
@yes:   pla
        plp
        clc
        rts
@no:    pla
        plp
        sec
        rts
.endproc

;;
; Check to see if the character in A is whitespace
;
; On exit:
; c = 0 if character is whitespce
; c = 1 if character is not whitespace
;
.proc is_whitespace
        php
        shortm
        cmp     #' '+1
        blt     :+
        plp
        sec
        rts
:       plp
        clc
        rts
.endproc

;;
; Skip input_index ahead to either the first non-whitespace character,
; or the end of line NULL, whichever occurs first.
;
.proc skip_whitespace
        php
@loop:  shortm
        lda     [ibuffp]
        beq     @exit
        cmp     #' '+1
        bge     @exit
        longm
        inc     ibuffp
        bra     @loop
@exit:  plp
        rts
.endproc

;;
; Display an error message pointing at a location on the input line.
;
.proc print_error

BEGIN_PARAMS
  PARAM s_dreg, .word
  PARAM s_ret, .word
  PARAM i_error_msg, .dword
  PARAM i_error_loc, .word
END_PARAMS

@psize := 6
@lsize := s_dreg - 1

        phd
        tsc
        sec
        sbcw    #@lsize
        tcs
        tcd

        lda     i_error_loc
        sec
        sbcw    #.loword(ibuff)
        inc
        tax
        shortm
        lda     #CR
        _PrintChar
        lda     #LF
        _PrintChar
:       lda   #' '
        _PrintChar
        dex
        bne     :-
        lda     #'^'
        _PrintChar
        lda     #' '
        _PrintChar
        longm
        lda     i_error_msg + 2
        pha
        lda     i_error_msg
        pha
        _PrintString 
        shortm
        lda     #CR
        _PrintChar
        lda     #LF
        _PrintChar
        longm
        lda     s_dreg,s
        sta     s_dreg+@psize,s
        lda     s_ret,s
        sta     s_ret+@psize,s
        tsc
        clc
        adcw    #@psize + @lsize
        tcs
        pld
        rts
.endproc
