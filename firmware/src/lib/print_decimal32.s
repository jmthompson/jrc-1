; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "console.inc"

        .export print_decimal32

        .segment "OSROM"

;;
; Print the 32-bit number passed on the stack to the console
; as a decimal number.
;
; Stack frame:
; +1..7   : local varaibles
; +8      : saved D
; +10     : Saved P
; +11..13 : return address
; +14..17 : Input number
;
; Inputs:
; 32-bit input number on stack
;
; Outputs:
; All registers trashed
;
print_decimal32:

; local variables
@bcd    = $01
@tmp    = $07
@arg    = $0E

; Stack offsets
@dreg   = $08

; constants
@psize  = 4         ; Size of input parameters
@lsize  = 7         ; Size of local variables

        php
        phd
        longmx
        tsc
        sec
        sbcw    #@lsize
        tcs
        tcd

        stz     @bcd
        stz     @bcd+2
        stz     @bcd+4  ; Start output number at zero
        sed
        ldxw    #32
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
        shortm
        stz     @tmp        ; do not print until non-zero digit found
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
        lda     #'0'
        _PrintChar
:       longm
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
        bne     :+
        bit     @tmp
        bmi     :+
        rts
:       clc
        adc     #'0'
        _PrintChar
        lda     #$80
        sta     @tmp
        rts
