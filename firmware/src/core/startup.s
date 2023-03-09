; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "ascii.inc"
        .include "kernel/console.inc"
        .include "kernel/heap.inc"
        .include "kernel/linker.inc"
        .include "kernel/scheduler.inc"

        .export sysreset
        .export trampoline

        .import __BSS_START__, __BSS_SIZE__
        .import syscall_table_init
        .import dm_init

        .import uart_init
        .import via_init
        .import spi_init

        .import kprint

        ;; from buildinfo.s
        .import jrcos_version
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

        longm
        ldaw    #OS_DP
        tcd
        ldaw    #OS_STACKTOP
        tcs
        shortm

        ; Zero out the BSS segment
        lda     #0
        sta     f:__BSS_START__
        longmx
        ldxw    #.loword(__BSS_START__)
        txy
        iny
        ldaw    #__BSS_SIZE__-1
        mvn     __BSS_START__,__BSS_START__
        shortmx

        ; Hardware initialization is done first. note that the drivers
        ; expect the DB register to be in bank $00.

        lda     #IRQ_DB
        pha
        plb
        jsr     via_init
        jsr     uart_init
        jsr     spi_init

        ; initialize the syscall table
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

        jsr     heap_init
        jsr     startup_banner

        jsl     dm_init
        jml     scheduler_start

;;
;
; Print the boot banner to the console
;
startup_banner:
        _kprint @init

        ; top line of box
        ldaw    #SHIFT_OUT
        _kputc
        ldaw    #'l'
        _kputc
        _kprint @line
        ldaw    #'k'
        _kputc
        ldaw    #SHIFT_IN
        _kputc
        ldaw    #CR
        _kputc
        ldaw    #LF
        _kputc

        ; System ID
        _kprint @sysid

        ; jrcOS version
        _kprint @jrcos
        ldaw    f:jrcos_version + 1
        andw    #255
        jsr     print_decimal
        ldaw    #'.'
        _kputc
        lda     f:jrcos_version
        andw    #255
        lsr
        lsr
        lsr
        lsr
        jsr     print_decimal
        ldaw    #'.'
        _kputc
        lda     f:jrcos_version
        andw    #$0F
        jsr     print_decimal
        ldaw    #' '
        _kputc
        ldaw    #'('
        _kputc
        _kprint rom_date
        ldaw    #')'
        _kputc
        _kprint @jrcos2

        ; bottom line of box
        ldaw    #SHIFT_OUT
        _kputc
        ldaw    #'m'
        _kputc
        _kprint @line
        ldaw    #'j'
        _kputc
        ldaw    #SHIFT_IN
        _kputc
        ldaw    #CR
        _kputc
        ldaw    #LF
        _kputc
        ldaw    #CR
        _kputc
        ldaw    #LF
        _kputc

        rts


@init:  .byte   ESC,"c"     ; reset terminal to default state
        .byte   ESC,"[7h"   ; enable line wrap
        .byte   ESC,")0"    ; set char set G1 to line drawing chars
        .byte   ESC,"[2J"
        .byte   0

@line:  .asciiz "qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq"
@sysid: .byte   SHIFT_OUT, "x", SHIFT_IN
        .byte   "  JRC-1 65816 Single Board Computer  "
        .byte   SHIFT_OUT, "x", SHIFT_IN, CR, LF, 0

@jrcos:  .byte   SHIFT_OUT, "x", SHIFT_IN
        .asciiz "  jrcOS Version "
@jrcos2: .byte   "   ", SHIFT_OUT, "x", SHIFT_IN, CR, LF, 0

;;
; Print the 8-bit number in the accumulator in decimal
;
; Accumulator is corrupted on exit
;
print_decimal:
        shortmx
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
        jsr     @digit
        longmx
        rts
@digit: pha
        txa
        ora     #'0'
        _kputc
        pla
        rts
