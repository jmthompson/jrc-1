; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"

        .export format_decimal

        .segment "OSROM"

;;
; Cnvert a 32-bit number to decimal with optional commas.
;
; Stack frame:
; +1..7   : local varaibles
; +8      : saved D
; +10     : Saved P
; +11..13 : return address
; +14..17 : Pointer to buffer
; +18..19 : Format flags
; +20..23 : Input number
;
; Inputs:
; [4] Number to conver
; [2] Fomatting flags (bit 0 = commas on/off)
; [4] Pointer to output buffer
;
; Outputs:
; Formatted number in output buffer
; All registers trashed
;
format_decimal:

; local variables
@bcd    = $01
@tmp    = $07
@buffer = $0E
@format = $12
@arg    = $14

; Stack offsets
@dreg   = $08

; constants
@psize  = 10        ; Size of input parameters
@lsize  = 7         ; Size of local variables

        php
        phd
        longm
        shortx
        tsc
        sec
        sbcw    #@lsize
        tcs
        tcd

        stz     @bcd
        stz     @bcd+2
        stz     @bcd+4  ; Start output number at zero
        sed
        ldx     #32
:       asl     @arg
        rol     @arg+2  ; Shift out a bit
        lda     @bcd    ; Multiply BCD x 2, and add bit from arg
        adc     @bcd
        sta     @bcd
        lda     @bcd+2
        adc     @bcd+2
        sta     @bcd+2
        lda     @bcd+4
        adc     @bcd+4
        sta     @bcd+4
        dex
        bne     :-
        cld
        ldaw    #%1001001000000000
        sta     @arg         ; digit positions after which a comma should be printed
        shortm
        stz     @tmp        ; do not print until non-zero digit found
        ldy     #0          ; output buffer index
        lda     @bcd + 4
        jsr     @byte
        lda     @bcd + 3
        jsr     @byte
        lda     @bcd + 2
        jsr     @byte
        lda     @bcd + 1
        jsr     @byte
        lda     @bcd
        jsr     @byte
        bit     @tmp
        bmi     :+
        lda     #0
        jsr     @store
:       lda     #0
        sta     [@buffer],y
        longm
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
@byte:  tax
        lsr
        lsr
        lsr
        lsr
        jsr     @digit
        txa
        and     #$0F
@digit: cmp     #0
        bne     @store
        bit     @tmp
        bmi     @store
        longm
        asl     @arg
        shortm
        rts
@store: clc
        adc     #'0'
        sta     [@buffer],Y
        iny
        lda     #$80
        sta     @tmp
        lda     @format
        and     #1
        beq     :+
        longm
        asl     @arg
        shortm
        bcc     :+
        lda     #','
        sta     [@buffer],Y
        iny
:       rts
