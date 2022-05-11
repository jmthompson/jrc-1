; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"

        .importzp ibuffp

        .export skip_whitespace

        .segment "OSROM"

;;
; Skip input_index ahead to either the first non-whitespace character,
; or the end of line NULL, whichever occurs first.
;
skip_whitespace:
        pha
@loop:  lda     [ibuffp]
        beq     @exit
        cmp     #' '+1
        bge     @exit
        inc     ibuffp
        bra     @loop
@exit:  pla
        rts
