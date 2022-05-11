; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "ascii.inc"

        .importzp ibuffp

        .export read_line

        .segment "SYSDATA"

        .align   256
ibuff:  .res    256

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
        lda     #<ibuff
        sta     ibuffp
        lda     #>ibuff
        sta     ibuffp+1
        lda     #^ibuff
        sta     ibuffp+2
        ldy     #0
@loop:  _Call   SYS_CONSOLE_READ
        bcs     @loop
        cmp     #BS
        beq     @bs
        cmp     #CR
        beq     @eol
        cmp     #CLS
        beq     @cls
        cmp     #' '
        bcc     @loop
        sta     [ibuffp],y
        _Call   SYS_CONSOLE_WRITE
        iny
        bne     @loop
        dey
@eol:   lda     #0
        sta     [ibuffp],y
        rts
@bs:    cpy     #0
        beq     @loop
        _Call   SYS_CONSOLE_WRITE
        dey
        bra     @loop
@cls:   _Call   SYS_CONSOLE_WRITE
        bra     @loop
