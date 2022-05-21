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
; Attempt to parse up to 4 hex digits at the current ibuffp
; and return the results in arg.
;
; On exit:
;
; Y = number of digits parsed
; n = reflects value in Y
;
parse_hex:
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
        inc32   ibuffp
        iny
        bne     @next
@done:  longm
        cpyw    #0
        rts
