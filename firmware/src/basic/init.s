; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "console.inc"
        .include "ascii.inc"
        .include "kernel/syscall_macros.inc"

        .include "constants.inc"

.scope Basic
        .export   Startup
.endscope

        .import   read_line
        .import   ibuff, IBUFFSZ
        .importzp ibuffp

        .segment  "OSROM"

Startup:
        _PrintString  Basic::VERSION
        ldaw    #CR
        _PrintChar
        ldaw    #LF
        _PrintChar
        ldaw    #CR
        _PrintChar
        ldaw    #LF
        _PrintChar

basic_loop:
        _PrintString @prompt
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
        _Call   SYS_ENTER_MONITOR
        ldaw    #CR
        _PrintChar
        ldaw    #LF
        _PrintChar
        bra     basic_loop
@prompt: .byte  CR, LF, ']', 0
