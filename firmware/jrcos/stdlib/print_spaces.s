; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "stdio.inc"

        .export print_spaces

        .segment "OSROM"

;;
; Print out a string of space whose length is given in the X register.
; X may be zero, in which case nothing is printed.
;
print_spaces:
        cpx     #0
        beq     @exit
        pha
        phx
@loop:  lda     #' '
        _putchar
        dex
        bne     @loop
        plx
        pla
@exit:  rts

