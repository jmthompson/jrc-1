; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "linker.inc"
        .include "syscalls.inc"
        .include "console.inc"
        .include "ascii.inc"

        .export sysreset
        .export trampoline

        .import uart_init
        .import monitor_start
        .import via_init
        .import console_init
        .import dos_init
        .import syscall_table_init
        .import dm_init
        .import spi_init
        .import sdcard_init 

        ;; from buildinfo.s
        .import hw_revision
        .import rom_version
        .import rom_date

        .segment "BSS"

; General purpose JML trampoline for calling functions. First byte
; is always a JML instruction, the last four bytes are for the
; function address.  Using four bytes makes this easier to manipulate
; with wide registers
trampoline:     .res    5

        .segment "BOOTROM"

sysreset:
        sei
        cld
        clc
        xce

        shortx

        longm
        ldaw    #OS_DP
        tcd
        ldaw    #OS_STACKTOP
        tcs
        shortm

        ; Hardware initialization is done first. note that the drivers
        ; expect the DB register to be in bank $00.

        lda     #IRQ_DB
        pha
        plb
        jsr     via_init
        jsr     uart_init
        jsr     syscall_table_init

        cli

        ; Now do the remaining initialization. At this point all code
        ; is running with DB set to the OS bank (BSS segment)

        lda     #OS_DB
        pha
        plb                         ; Set the OS data bank
        lda     #$5C                ; JML $xxyyzz
        sta     trampoline          ; Init trampoline vector

        longmx

        jsr     console_init
        jsr     startup_banner

        jsl     dm_init
        jsl     spi_init
        jsl     sdcard_init
        jsl     dos_init

        jml     monitor_start

;;
;
; Print the boot banner to the console
;
startup_banner:
        php
        shortmx
        ; top line of box
        lda     #SHIFT_OUT
        _PrintChar
        lda     #'l'
        _PrintChar
        _PrintString @line
        lda     #'k'
        _PrintChar
        lda     #SHIFT_IN
        _PrintChar
        lda     #CR
        _PrintChar
        lda     #LF
        _PrintChar

        ; System ID
        _PrintString @sysid

        ; HW Revision
        _PrintString @hwrev
        lda     f:hw_revision
        jsr     print_decimal
        _PrintString @hwrev2

        ; ROM Version
        _PrintString @romver
        lda     f:rom_version
        lsr
        lsr
        lsr
        lsr
        jsr     print_decimal
        lda     #'.'
        _PrintChar
        lda     f:rom_version
        and     #$0f
        jsr     print_decimal
        lda     #' '
        _PrintChar
        lda     #'('
        _PrintChar
        _PrintString rom_date
        lda     #')'
        _PrintChar
        _PrintString @romver2

        ; bottom line of box
        lda     #SHIFT_OUT
        _PrintChar
        lda     #'m'
        _PrintChar
        _PrintString @line
        lda     #'j'
        _PrintChar
        lda     #SHIFT_IN
        _PrintChar
        lda     #CR
        _PrintChar
        lda     #LF
        _PrintChar
        lda     #CR
        _PrintChar
        lda     #LF
        _PrintChar

        plp
        rts

@line:  .repeat 32
        .byte   "q"
        .endrepeat
        .byte   0

@sysid:  .byte  SHIFT_OUT, "x", SHIFT_IN
         .byte  " JRC-1 Single Board Computer    "
         .byte  SHIFT_OUT, "x", SHIFT_IN, CR, LF, 0

@hwrev:  .byte  SHIFT_OUT, "x", SHIFT_IN, " Hardware Revision ", 0
@hwrev2: .byte  "            ", SHIFT_OUT, "x", SHIFT_IN, CR, LF, 0

@romver:  .byte SHIFT_OUT, "x", SHIFT_IN, " JR/OS Version ", 0
@romver2: .byte " ", SHIFT_OUT, "x", SHIFT_IN, CR, LF, 0

;;
; Print the 8-bit number in the accumulator in decimal
;
; Accumulator is corrupted on exit
;
print_decimal:
        ldx     #$ff
        sec
@pr100: inx
        sbc     #100
        bcs     @pr100
        adc     #100
        cpx     #0
        beq     @skip100
        jsr     @digit
@skip100: ldx     #$ff
        sec
@pr10:  inx
        sbc     #10
        bcs     @pr10
        adc     #10
        cpx     #0
        beq     @skip10
        jsr     @digit
@skip10:
        tax
@digit: pha
        txa
        ora     #'0'
        _Call   SYS_CONSOLE_WRITE
        pla
        rts
