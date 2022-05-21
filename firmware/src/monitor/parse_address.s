; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"

        .importzp arg
        .importzp ibuffp
        .importzp maxhex
        .importzp start_loc

        .import parse_hex

        .export parse_address

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
parse_address:
        jsr     parse_hex
        beq     @done       ; No address present
        shortm
        lda     [ibuffp]
        cmp     #'/'        ; Was the parsed value a bank value?
        bne     @addr
        lda     arg
        sta     start_loc+2 ; set bank byte
        longm
        inc32   ibuffp      ; Skip the "/"
        jsr     parse_hex   ; Continue trying to parse an address
        beq     @done
@addr:  longm
        lda     arg
        sta     start_loc
@done:  rts
