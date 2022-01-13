; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"

        .import console_reset
        .import console_writeln
        .import console_cls
        .import console_cll

        .import getc_seriala
        .import putc_seriala

        .import spi_select
        .import spi_deselect
        .import spi_transfer
        .import spi_slow_speed
        .import spi_fast_speed

        .import jros_register_device
        .import jros_mount_device
        .import jros_eject_device
        .import jros_format_device
        .import jros_device_status
        .import jros_read_block
        .import jros_write_block

        .export syscall_table_init
        .export syscall_table

; Macro for declaring dispatch table entries
.macro  syscall_entry func, psize
        .faraddr    func
        .byte       psize
.endmacro

        .segment "SYSDATA"
        .align 256
syscall_table: .res 4*256

        .segment "BOOTROM"

syscall_table_init:
        longmx
        ldxw    #.loword(default_table)
        ldyw    #.loword(syscall_table)
        ldaw    #256*4
        mvn     default_table,syscall_table
        shortmx
        rts

        .segment "OSROM"

unsupported_syscall:
        syserr  ERR_NOT_SUPPORTED

default_table:
        syscall_entry   unsupported_syscall, 0      ; $00
        syscall_entry   unsupported_syscall, 0      ; $01
        syscall_entry   unsupported_syscall, 0      ; $02
        syscall_entry   unsupported_syscall, 0      ; $03
        syscall_entry   unsupported_syscall, 0      ; $04
        syscall_entry   unsupported_syscall, 0      ; $05
        syscall_entry   unsupported_syscall, 0      ; $06
        syscall_entry   unsupported_syscall, 0      ; $07
        syscall_entry   unsupported_syscall, 0      ; $08
        syscall_entry   unsupported_syscall, 0      ; $09
        syscall_entry   unsupported_syscall, 0      ; $0A
        syscall_entry   unsupported_syscall, 0      ; $0B
        syscall_entry   unsupported_syscall, 0      ; $0C
        syscall_entry   unsupported_syscall, 0      ; $0D
        syscall_entry   unsupported_syscall, 0      ; $0E
        syscall_entry   unsupported_syscall, 0      ; $0F

        ; Console
        syscall_entry   console_reset, 0            ; $10
        syscall_entry   getc_seriala, 0             ; $11
        syscall_entry   putc_seriala, 0             ; $12
        syscall_entry   console_writeln, 4          ; $13
        syscall_entry   console_cls, 0              ; $14
        syscall_entry   console_cll, 0              ; $15
        syscall_entry   unsupported_syscall, 0      ; $16
        syscall_entry   unsupported_syscall, 0      ; $17
        syscall_entry   unsupported_syscall, 0      ; $18
        syscall_entry   unsupported_syscall, 0      ; $19
        syscall_entry   unsupported_syscall, 0      ; $1A
        syscall_entry   unsupported_syscall, 0      ; $1B
        syscall_entry   unsupported_syscall, 0      ; $1C
        syscall_entry   unsupported_syscall, 0      ; $1D
        syscall_entry   unsupported_syscall, 0      ; $1E
        syscall_entry   unsupported_syscall, 0      ; $1F

        ; Serial ports
        syscall_entry   unsupported_syscall, 0      ; $20
        syscall_entry   unsupported_syscall, 0      ; $21
        syscall_entry   unsupported_syscall, 0      ; $22
        syscall_entry   unsupported_syscall, 0      ; $23
        syscall_entry   unsupported_syscall, 0      ; $24
        syscall_entry   unsupported_syscall, 0      ; $25
        syscall_entry   unsupported_syscall, 0      ; $26
        syscall_entry   unsupported_syscall, 0      ; $27
        syscall_entry   unsupported_syscall, 0      ; $28
        syscall_entry   unsupported_syscall, 0      ; $29
        syscall_entry   unsupported_syscall, 0      ; $2A
        syscall_entry   unsupported_syscall, 0      ; $2B
        syscall_entry   unsupported_syscall, 0      ; $2C
        syscall_entry   unsupported_syscall, 0      ; $2D
        syscall_entry   unsupported_syscall, 0      ; $2E
        syscall_entry   unsupported_syscall, 0      ; $2F

        ; SPI
        syscall_entry   spi_select, 0               ; $30
        syscall_entry   spi_deselect, 0             ; $31
        syscall_entry   spi_transfer, 0             ; $32
        syscall_entry   spi_slow_speed, 0           ; $33
        syscall_entry   spi_fast_speed, 0           ; $34
        syscall_entry   unsupported_syscall, 0      ; $35
        syscall_entry   unsupported_syscall, 0      ; $36
        syscall_entry   unsupported_syscall, 0      ; $37
        syscall_entry   unsupported_syscall, 0      ; $38
        syscall_entry   unsupported_syscall, 0      ; $39
        syscall_entry   unsupported_syscall, 0      ; $3A
        syscall_entry   unsupported_syscall, 0      ; $3B
        syscall_entry   unsupported_syscall, 0      ; $3C
        syscall_entry   unsupported_syscall, 0      ; $3D
        syscall_entry   unsupported_syscall, 0      ; $3E
        syscall_entry   unsupported_syscall, 0      ; $3F

        ; JR/OS
        syscall_entry   jros_register_device, 0     ; $40
        syscall_entry   jros_mount_device, 0        ; $41
        syscall_entry   jros_eject_device, 0        ; $42
        syscall_entry   jros_format_device, 0       ; $43
        syscall_entry   jros_device_status, 0       ; $44
        syscall_entry   jros_read_block, 0          ; $45
        syscall_entry   jros_write_block, 0         ; $46
        syscall_entry   unsupported_syscall, 0      ; $47
        syscall_entry   unsupported_syscall, 0      ; $48
        syscall_entry   unsupported_syscall, 0      ; $49
        syscall_entry   unsupported_syscall, 0      ; $4A
        syscall_entry   unsupported_syscall, 0      ; $4B
        syscall_entry   unsupported_syscall, 0      ; $4C
        syscall_entry   unsupported_syscall, 0      ; $4D
        syscall_entry   unsupported_syscall, 0      ; $4E
        syscall_entry   unsupported_syscall, 0      ; $4F

        syscall_entry   unsupported_syscall, 0      ; $50
        syscall_entry   unsupported_syscall, 0      ; $51
        syscall_entry   unsupported_syscall, 0      ; $52
        syscall_entry   unsupported_syscall, 0      ; $53
        syscall_entry   unsupported_syscall, 0      ; $54
        syscall_entry   unsupported_syscall, 0      ; $55
        syscall_entry   unsupported_syscall, 0      ; $56
        syscall_entry   unsupported_syscall, 0      ; $57
        syscall_entry   unsupported_syscall, 0      ; $58
        syscall_entry   unsupported_syscall, 0      ; $59
        syscall_entry   unsupported_syscall, 0      ; $5A
        syscall_entry   unsupported_syscall, 0      ; $5B
        syscall_entry   unsupported_syscall, 0      ; $5C
        syscall_entry   unsupported_syscall, 0      ; $5D
        syscall_entry   unsupported_syscall, 0      ; $5E
        syscall_entry   unsupported_syscall, 0      ; $5F

        syscall_entry   unsupported_syscall, 0      ; $60
        syscall_entry   unsupported_syscall, 0      ; $61
        syscall_entry   unsupported_syscall, 0      ; $62
        syscall_entry   unsupported_syscall, 0      ; $63
        syscall_entry   unsupported_syscall, 0      ; $64
        syscall_entry   unsupported_syscall, 0      ; $65
        syscall_entry   unsupported_syscall, 0      ; $66
        syscall_entry   unsupported_syscall, 0      ; $67
        syscall_entry   unsupported_syscall, 0      ; $68
        syscall_entry   unsupported_syscall, 0      ; $69
        syscall_entry   unsupported_syscall, 0      ; $6A
        syscall_entry   unsupported_syscall, 0      ; $6B
        syscall_entry   unsupported_syscall, 0      ; $6C
        syscall_entry   unsupported_syscall, 0      ; $6D
        syscall_entry   unsupported_syscall, 0      ; $6E
        syscall_entry   unsupported_syscall, 0      ; $6F

        syscall_entry   unsupported_syscall, 0      ; $70
        syscall_entry   unsupported_syscall, 0      ; $71
        syscall_entry   unsupported_syscall, 0      ; $72
        syscall_entry   unsupported_syscall, 0      ; $73
        syscall_entry   unsupported_syscall, 0      ; $74
        syscall_entry   unsupported_syscall, 0      ; $75
        syscall_entry   unsupported_syscall, 0      ; $76
        syscall_entry   unsupported_syscall, 0      ; $77
        syscall_entry   unsupported_syscall, 0      ; $78
        syscall_entry   unsupported_syscall, 0      ; $79
        syscall_entry   unsupported_syscall, 0      ; $7A
        syscall_entry   unsupported_syscall, 0      ; $7B
        syscall_entry   unsupported_syscall, 0      ; $7C
        syscall_entry   unsupported_syscall, 0      ; $7D
        syscall_entry   unsupported_syscall, 0      ; $7E
        syscall_entry   unsupported_syscall, 0      ; $7F

        syscall_entry   unsupported_syscall, 0      ; $80
        syscall_entry   unsupported_syscall, 0      ; $81
        syscall_entry   unsupported_syscall, 0      ; $82
        syscall_entry   unsupported_syscall, 0      ; $83
        syscall_entry   unsupported_syscall, 0      ; $84
        syscall_entry   unsupported_syscall, 0      ; $85
        syscall_entry   unsupported_syscall, 0      ; $86
        syscall_entry   unsupported_syscall, 0      ; $87
        syscall_entry   unsupported_syscall, 0      ; $88
        syscall_entry   unsupported_syscall, 0      ; $89
        syscall_entry   unsupported_syscall, 0      ; $8A
        syscall_entry   unsupported_syscall, 0      ; $8B
        syscall_entry   unsupported_syscall, 0      ; $8C
        syscall_entry   unsupported_syscall, 0      ; $8D
        syscall_entry   unsupported_syscall, 0      ; $8E
        syscall_entry   unsupported_syscall, 0      ; $8F

        syscall_entry   unsupported_syscall, 0      ; $90
        syscall_entry   unsupported_syscall, 0      ; $91
        syscall_entry   unsupported_syscall, 0      ; $92
        syscall_entry   unsupported_syscall, 0      ; $93
        syscall_entry   unsupported_syscall, 0      ; $94
        syscall_entry   unsupported_syscall, 0      ; $95
        syscall_entry   unsupported_syscall, 0      ; $96
        syscall_entry   unsupported_syscall, 0      ; $97
        syscall_entry   unsupported_syscall, 0      ; $98
        syscall_entry   unsupported_syscall, 0      ; $99
        syscall_entry   unsupported_syscall, 0      ; $9A
        syscall_entry   unsupported_syscall, 0      ; $9B
        syscall_entry   unsupported_syscall, 0      ; $9C
        syscall_entry   unsupported_syscall, 0      ; $9D
        syscall_entry   unsupported_syscall, 0      ; $9E
        syscall_entry   unsupported_syscall, 0      ; $9F

        syscall_entry   unsupported_syscall, 0      ; $A0
        syscall_entry   unsupported_syscall, 0      ; $A1
        syscall_entry   unsupported_syscall, 0      ; $A2
        syscall_entry   unsupported_syscall, 0      ; $A3
        syscall_entry   unsupported_syscall, 0      ; $A4
        syscall_entry   unsupported_syscall, 0      ; $A5
        syscall_entry   unsupported_syscall, 0      ; $A6
        syscall_entry   unsupported_syscall, 0      ; $A7
        syscall_entry   unsupported_syscall, 0      ; $A8
        syscall_entry   unsupported_syscall, 0      ; $A9
        syscall_entry   unsupported_syscall, 0      ; $AA
        syscall_entry   unsupported_syscall, 0      ; $AB
        syscall_entry   unsupported_syscall, 0      ; $AC
        syscall_entry   unsupported_syscall, 0      ; $AD
        syscall_entry   unsupported_syscall, 0      ; $AE
        syscall_entry   unsupported_syscall, 0      ; $AF

        syscall_entry   unsupported_syscall, 0      ; $B0
        syscall_entry   unsupported_syscall, 0      ; $B1
        syscall_entry   unsupported_syscall, 0      ; $B2
        syscall_entry   unsupported_syscall, 0      ; $B3
        syscall_entry   unsupported_syscall, 0      ; $B4
        syscall_entry   unsupported_syscall, 0      ; $B5
        syscall_entry   unsupported_syscall, 0      ; $B6
        syscall_entry   unsupported_syscall, 0      ; $B7
        syscall_entry   unsupported_syscall, 0      ; $B8
        syscall_entry   unsupported_syscall, 0      ; $B9
        syscall_entry   unsupported_syscall, 0      ; $BA
        syscall_entry   unsupported_syscall, 0      ; $BB
        syscall_entry   unsupported_syscall, 0      ; $BC
        syscall_entry   unsupported_syscall, 0      ; $BD
        syscall_entry   unsupported_syscall, 0      ; $BE
        syscall_entry   unsupported_syscall, 0      ; $BF

        syscall_entry   unsupported_syscall, 0      ; $C0
        syscall_entry   unsupported_syscall, 0      ; $C1
        syscall_entry   unsupported_syscall, 0      ; $C2
        syscall_entry   unsupported_syscall, 0      ; $C3
        syscall_entry   unsupported_syscall, 0      ; $C4
        syscall_entry   unsupported_syscall, 0      ; $C5
        syscall_entry   unsupported_syscall, 0      ; $C6
        syscall_entry   unsupported_syscall, 0      ; $C7
        syscall_entry   unsupported_syscall, 0      ; $C8
        syscall_entry   unsupported_syscall, 0      ; $C9
        syscall_entry   unsupported_syscall, 0      ; $CA
        syscall_entry   unsupported_syscall, 0      ; $CB
        syscall_entry   unsupported_syscall, 0      ; $CC
        syscall_entry   unsupported_syscall, 0      ; $CD
        syscall_entry   unsupported_syscall, 0      ; $CE
        syscall_entry   unsupported_syscall, 0      ; $CF

        syscall_entry   unsupported_syscall, 0      ; $D0
        syscall_entry   unsupported_syscall, 0      ; $D1
        syscall_entry   unsupported_syscall, 0      ; $D2
        syscall_entry   unsupported_syscall, 0      ; $D3
        syscall_entry   unsupported_syscall, 0      ; $D4
        syscall_entry   unsupported_syscall, 0      ; $D5
        syscall_entry   unsupported_syscall, 0      ; $D6
        syscall_entry   unsupported_syscall, 0      ; $D7
        syscall_entry   unsupported_syscall, 0      ; $D8
        syscall_entry   unsupported_syscall, 0      ; $D9
        syscall_entry   unsupported_syscall, 0      ; $DA
        syscall_entry   unsupported_syscall, 0      ; $DB
        syscall_entry   unsupported_syscall, 0      ; $DC
        syscall_entry   unsupported_syscall, 0      ; $DD
        syscall_entry   unsupported_syscall, 0      ; $DE
        syscall_entry   unsupported_syscall, 0      ; $DF

        syscall_entry   unsupported_syscall, 0      ; $E0
        syscall_entry   unsupported_syscall, 0      ; $E1
        syscall_entry   unsupported_syscall, 0      ; $E2
        syscall_entry   unsupported_syscall, 0      ; $E3
        syscall_entry   unsupported_syscall, 0      ; $E4
        syscall_entry   unsupported_syscall, 0      ; $E5
        syscall_entry   unsupported_syscall, 0      ; $E6
        syscall_entry   unsupported_syscall, 0      ; $E7
        syscall_entry   unsupported_syscall, 0      ; $E8
        syscall_entry   unsupported_syscall, 0      ; $E9
        syscall_entry   unsupported_syscall, 0      ; $EA
        syscall_entry   unsupported_syscall, 0      ; $EB
        syscall_entry   unsupported_syscall, 0      ; $EC
        syscall_entry   unsupported_syscall, 0      ; $ED
        syscall_entry   unsupported_syscall, 0      ; $EE
        syscall_entry   unsupported_syscall, 0      ; $EF

        syscall_entry   unsupported_syscall, 0      ; $F0
        syscall_entry   unsupported_syscall, 0      ; $F1
        syscall_entry   unsupported_syscall, 0      ; $F2
        syscall_entry   unsupported_syscall, 0      ; $F3
        syscall_entry   unsupported_syscall, 0      ; $F4
        syscall_entry   unsupported_syscall, 0      ; $F5
        syscall_entry   unsupported_syscall, 0      ; $F6
        syscall_entry   unsupported_syscall, 0      ; $F7
        syscall_entry   unsupported_syscall, 0      ; $F8
        syscall_entry   unsupported_syscall, 0      ; $F9
        syscall_entry   unsupported_syscall, 0      ; $FA
        syscall_entry   unsupported_syscall, 0      ; $FB
        syscall_entry   unsupported_syscall, 0      ; $FC
        syscall_entry   unsupported_syscall, 0      ; $FD
        syscall_entry   unsupported_syscall, 0      ; $FE
        syscall_entry   unsupported_syscall, 0      ; $FF
