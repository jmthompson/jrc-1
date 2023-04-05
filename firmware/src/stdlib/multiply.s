; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .include "common.inc"

        .export multiply_8x8

        .segment "OSROM"

;;
; Multiply two 8-bit numbers and return the 16-bit result.
;
; Stack frame:
; +1..2   : local variables
; +3      : saved D
; +5      : Saved P
; +7..8   : return address
; +9..10  : First number
; +11..12 : Second number
; +13..14 : Result
;
; Inputs:
; [2] Second number (only lower 8 bits considered)
; [2] First number (only lower 8 bits considered)
; [2] Space for result
;
; Outputs:
; Product in result space on stack
; C trashed
;
multiply_8x8:

; local variables
@addend = $01

; Stack offsets
@dreg   = $03
@num2   = $09
@num1   = $0B
@result = $0D

; constants
@psize  = 4         ; Size of input parameters
@lsize  = 2         ; Size of local variables

        php
        phd
        longm
        tsc
        sec
        sbcw    #@lsize
        tcs
        tcd

        stz     @result
        lda     @num1
        sta     @addend
@mult:  lda     @num2
        andw    #1
        beq     @next
        lda     @result
        clc
        adc     @addend
        sta     @result
@next:  asl     @addend
        lsr     @num2
        bne     @mult
        lda     @dreg+4,s
        sta     @dreg+4+@psize,s
        lda     @dreg+2,s
        sta     @dreg+2+@psize,s
        lda     @dreg,s
        sta     @dreg+@psize,s
        tsc
        clc
        adcw    #@lsize+@psize
        tcs
        pld
        plp
        clc
        rtl
