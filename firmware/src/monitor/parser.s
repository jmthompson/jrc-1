; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; This file contains subroutines used by the monitor for parsing the
; input buffer.
;

        .include "common.inc"

        .import   arg
        .importzp ibuffp, maxhex, start_loc
        .export   parse_address, parse_hex, skip_whitespace

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
        jsr     parse_hex   ; Continue trying to parse an address
        beq     @done
@addr:  longm
        lda     arg
        sta     start_loc
@done:  rts
.endproc
        .segment "OSROM"

;;
; Attempt to parse up to 4 hex digits at the current ibuffp
; and return the results in arg.
;
; On exit:
;
; Y = number of digits parsed
; n = reflects value in Y
;
.proc parse_hex
        php
        stz     arg
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
        asl     arg
        asl     arg
        asl     arg
        shortm
        ora     arg
        sta     arg
        longm
        inc     ibuffp
        iny
        bne     @next
@done:  plp
        cpyw    #0
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
