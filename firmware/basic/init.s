; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "stdio.inc"
        .include "fcntl.inc"
        .include "syscalls.inc"
        .include "ascii.inc"

        .include "constants.inc"

        .import   read_line

        .segment  "DATA"

IBUFFSZ := 256
ibuff:  .res IBUFFSZ

        .segment  "ZEROPAGE"

ibuffp: .res 4

        .segment  "HEADER"

        jmp     entrypoint
        .res    13

        .segment  "CODE"

appname:
        .asciiz "jrcOS Integrated Basic"

open_stdio:
        pha
        _PushLong @console
        _PushWord 0
        _PushWord O_RDONLY
        _open               ; open stdin
        pla
        pha
        _PushLong @console
        _PushWord 0
        _PushWord O_WRONLY
        _open               ; open stdout
        pla
        pha
        _PushLong @console
        _PushWord 0
        _PushWord O_WRONLY
        _open               ; open stderr
        pla
        rts

@console:
        .asciiz "/dev/console"

entrypoint:
        jsr     open_stdio
        _puts  appname
        ldaw    #' '
        _putchar
        ldaw    #'v'
        _putchar
        _puts  VERSION
        ldaw    #CR
        _putchar
        ldaw    #LF
        _putchar
        ldaw    #CR
        _putchar
        ldaw    #LF
        _putchar

basic_loop:
        _puts @prompt
        ldaw    #.hiword(ibuff)
        sta     ibuffp+2
        pha
        ldaw    #.loword(ibuff)
        sta     ibuffp
        pha
        pea     IBUFFSZ
        jsl     read_line
        lda     [ibuffp]
        andw    #255
        beq     basic_loop
        _syscall  SYS_ENTER_MONITOR
        ldaw    #CR
        _putchar
        ldaw    #LF
        _putchar
        bra     basic_loop
@prompt: .byte  CR, LF, ']', 0
