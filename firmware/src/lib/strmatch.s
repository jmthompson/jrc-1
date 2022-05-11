; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"

        .export strmatch

        .segment "OSROM"

;;
; Compare two strings in a case-sensitive manner
;
; Stack frame:
; +10 [4,I] Pointer to second string
; +6  [4,I] Pointer to first string
; +3  [3,S] Return address
; +1  [2,L] Caller DP
;
; On exit:
; c = 1 if strings do not match, c = 0 if they match
; C,X,Y undefined
;
strmatch:

@s1 = $00
@s2 = $04

        phd
        tsc
        clc
        adcw    #6
        tcd         ; DP now points at +6 in stack frame
        shortm
        ldyw    #0
@cmp:   lda     [@s1],y
        cmp     [@s2],y
        bne     @no
        cmp     #0
        beq     @yes
        iny
        bra     @cmp
@yes:   clc
        bra     @exit
@no:    sec
@exit:  pld
        php             ; save carry state
        lda     2,s
        sta     10,s
        longm
        lda     3,s
        sta     11,s
        tsc
        clc
        adcw    #9
        plp             ; restore carry
        longm           ; the plp will have reset this
        tcs             ; remove params from stack
        rtl
