; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/ascii.s"
        .include "sys/io.s"

        .export sysreset

        .import uart_init
        .import monitor_start
        .import spi_init
        .import via_init
        .import console_init
        .import jros_init
        .import syscall_table_init
        .import device_manager_init
        .import syscall_trampoline 
        .import print_decimal8

        .import __SYSSTACK_START__
        .import __SYSSTACK_SIZE__

        ;; from buildinfo.s
        .import hw_revision
        .import rom_version
        .import rom_date

STACKTOP    = __SYSSTACK_START__ + __SYSSTACK_SIZE__ - 1

SHIFT_OUT   = 14
SHIFT_IN    = 15

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
        ldaw    #STACKTOP
        tcs
        shortm

        lda     #IRQ_DB
        pha
        plb

        jsr     via_init
        jsr     spi_init
        jsr     uart_init
        jsr     syscall_table_init

        cli

        lda     #OS_DB
        pha
        plb

        lda     #$5C                ; JML $xxyyzz
        sta     syscall_trampoline  ; Init syscall trampoline vector

        ;jsl     device_manager_init
        
        jsr     console_init
        jsr     startup_banner

        ;jsr     jros_init
        jml     monitor_start

;;
;
; Print the boot banner to the console
;
startup_banner:
        ; top line of box
        putc    #SHIFT_OUT
        putc    #'l'
        puts    @line
        putc    #'k'
        putc    #SHIFT_IN
        puteol

        ; System ID
        puts    @sysid

        ; HW Revision
        puts    @hwrev
        lda     f:hw_revision
        jsl     print_decimal8
        puts    @hwrev2

        ; ROM Version
        puts    @romver
        lda     f:rom_version
        lsr
        lsr
        lsr
        lsr
        jsl     print_decimal8
        putc    #'.'
        lda     f:rom_version
        and     #$0f
        jsl     print_decimal8
        putc    #' '
        putc    #'('
        puts    rom_date
        putc    #')'
        puts    @romver2

        ; bottom line of box
        putc    #SHIFT_OUT
        putc    #'m'
        puts    @line
        putc    #'j'
        putc    #SHIFT_IN
        puteol

        puteol
        puteol

        rts

@line:  .repeat 31
        .byte   "q"
        .endrepeat
        .byte   0

@sysid:  .byte  SHIFT_OUT, "x", SHIFT_IN
         .byte  " JRC-1 Single Board Computer   "
         .byte  SHIFT_OUT, "x", SHIFT_IN, CR, LF, 0

@hwrev:  .byte  SHIFT_OUT, "x", SHIFT_IN, " Hardware Revision ", 0
@hwrev2: .byte  "           ", SHIFT_OUT, "x", SHIFT_IN, CR, LF, 0

@romver:  .byte SHIFT_OUT, "x", SHIFT_IN, " ROM Version ", 0
@romver2: .byte "  ", SHIFT_OUT, "x", SHIFT_IN, CR, LF, 0
