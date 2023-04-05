; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "console.inc"
        .include "ascii.inc"

        .export     read_line

        .segment "OSROM"

;;
; Read a line of text from the console with simple editing
;
; On exit:
;
; ibuffp : points to start of input buffer
; A,Y : contents trashed
;
read_line:

; local direct page variables
@ibuffsz = $07          ; size of input buffer
@ibuffp  = @ibuffsz+2   ; pointer to input buffer
@psize   = 6             ; # of bytes to remove from stack

        php
        phd
        tsc
        tcd
        shortm
        longx
        ldyw    #0
@loop:  _GetChar
        bcs     @loop
        cmp     #BS
        beq     @bs
        cmp     #CR
        beq     @eol
        cmp     #CLS
        beq     @cls
        cmp     #' '
        bcc     @loop
        sta     [@ibuffp],Y
        _PrintChar
        iny
        cpyw    @ibuffsz
        bne     @loop
        dey
@eol:   lda     #0
        sta     [@ibuffp],Y
        lda     4,s
        sta     4+@psize,s
        longm
        lda     5,s
        sta     5+@psize,s
        tsc
        clc
        adcw    #@psize+3
        pld
        plp
        tcs
        rtl
@bs:    cpyw    #0
        beq     @loop
        _PrintChar
        dey
        bra     @loop
@cls:   _PrintChar
        bra     @loop
