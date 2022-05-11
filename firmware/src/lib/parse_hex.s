; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"

        .importzp arg
        .importzp ibuffp
        .importzp maxhex

        .export parse_hex

        .segment "OSROM"

;;
; Attempt to parse up to Y hex digits at the current ibuffp
; and store the result in arg.
;
; On entry:
;
;   Y : maximum number of digits to parse, 1-8
;
; On exit:
;
;   c : Clear if at least one digit was parsed
;   Y : number of digits parsed. 0 -> 8
;
parse_hex:
        sty     maxhex
        longm
        stz     arg
        stz     arg+2
        shortm
        ldy     #0
@next:  lda     [ibuffp]
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
        inc     ibuffp
        iny
        cpy     maxhex
        bne     @next
@done:  cpy     #0
        rts

