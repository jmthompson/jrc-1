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
        .import getc_serialb
        .import putc_serialb

        .import spi_select
        .import spi_deselect
        .import spi_transfer
        .import spi_slow_speed
        .import spi_fast_speed

        .import jros_register_device
        .import jros_eject_device
        .import jros_format_device
        .import jros_device_status
        .import jros_read_block
        .import jros_write_block

        .export syscall_table_init
        .export syscall_table

; Macro for declaring dispatch table entries
.macro  DEFINE_SYSCALL func, psize
        .faraddr    func
        .byte       psize
.endmacro

        .segment "SC_TABLE"
syscall_table: .res 8*256

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
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $00
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $01
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $02
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $03
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $04
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $05
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $06
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $07
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $08
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $09
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $0A
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $0B
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $0C
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $0D
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $0E
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $0F

        ; Console
        DEFINE_SYSCALL  console_reset, 0            ; $10
        DEFINE_SYSCALL  getc_seriala, 0             ; $11
        DEFINE_SYSCALL  putc_seriala, 0             ; $12
        DEFINE_SYSCALL  console_writeln, 4          ; $13
        DEFINE_SYSCALL  console_cls, 0              ; $14
        DEFINE_SYSCALL  console_cll, 0              ; $15
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $16
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $17
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $18
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $19
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $1A
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $1B
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $1C
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $1D
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $1E
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $1F

        ; Serial ports
        DEFINE_SYSCALL  getc_seriala, 0             ; $20
        DEFINE_SYSCALL  putc_seriala, 0             ; $21
        DEFINE_SYSCALL  getc_serialb, 0             ; $22
        DEFINE_SYSCALL  putc_serialb, 0             ; $23
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $24
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $25
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $26
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $27
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $28
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $29
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $2A
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $2B
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $2C
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $2D
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $2E
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $2F

        ; SPI
        DEFINE_SYSCALL  spi_select, 0               ; $30
        DEFINE_SYSCALL  spi_deselect, 0             ; $31
        DEFINE_SYSCALL  spi_transfer, 0             ; $32
        DEFINE_SYSCALL  spi_slow_speed, 0           ; $33
        DEFINE_SYSCALL  spi_fast_speed, 0           ; $34
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $35
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $36
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $37
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $38
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $39
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $3A
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $3B
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $3C
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $3D
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $3E
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $3F

        ; JR/OS
        DEFINE_SYSCALL  jros_register_device, 4     ; $40
        DEFINE_SYSCALL  jros_device_status, 4       ; $41
        DEFINE_SYSCALL  jros_eject_device, 0        ; $42
        DEFINE_SYSCALL  jros_format_device, 4       ; $43
        DEFINE_SYSCALL  jros_read_block, 4          ; $44
        DEFINE_SYSCALL  jros_write_block, 4         ; $45
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $46
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $47
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $48
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $49
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $4A
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $4B
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $4C
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $4D
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $4E
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $4F

        DEFINE_SYSCALL  unsupported_syscall, 0      ; $50
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $51
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $52
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $53
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $54
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $55
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $56
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $57
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $58
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $59
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $5A
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $5B
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $5C
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $5D
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $5E
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $5F

        DEFINE_SYSCALL  unsupported_syscall, 0      ; $60
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $61
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $62
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $63
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $64
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $65
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $66
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $67
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $68
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $69
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $6A
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $6B
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $6C
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $6D
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $6E
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $6F

        DEFINE_SYSCALL  unsupported_syscall, 0      ; $70
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $71
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $72
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $73
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $74
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $75
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $76
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $77
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $78
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $79
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $7A
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $7B
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $7C
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $7D
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $7E
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $7F

        DEFINE_SYSCALL  unsupported_syscall, 0      ; $80
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $81
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $82
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $83
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $84
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $85
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $86
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $87
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $88
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $89
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $8A
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $8B
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $8C
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $8D
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $8E
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $8F

        DEFINE_SYSCALL  unsupported_syscall, 0      ; $90
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $91
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $92
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $93
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $94
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $95
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $96
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $97
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $98
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $99
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $9A
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $9B
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $9C
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $9D
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $9E
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $9F

        DEFINE_SYSCALL  unsupported_syscall, 0      ; $A0
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $A1
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $A2
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $A3
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $A4
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $A5
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $A6
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $A7
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $A8
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $A9
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $AA
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $AB
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $AC
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $AD
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $AE
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $AF

        DEFINE_SYSCALL  unsupported_syscall, 0      ; $B0
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $B1
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $B2
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $B3
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $B4
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $B5
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $B6
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $B7
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $B8
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $B9
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $BA
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $BB
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $BC
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $BD
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $BE
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $BF

        DEFINE_SYSCALL  unsupported_syscall, 0      ; $C0
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $C1
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $C2
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $C3
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $C4
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $C5
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $C6
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $C7
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $C8
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $C9
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $CA
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $CB
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $CC
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $CD
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $CE
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $CF

        DEFINE_SYSCALL  unsupported_syscall, 0      ; $D0
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $D1
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $D2
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $D3
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $D4
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $D5
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $D6
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $D7
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $D8
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $D9
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $DA
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $DB
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $DC
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $DD
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $DE
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $DF

        DEFINE_SYSCALL  unsupported_syscall, 0      ; $E0
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $E1
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $E2
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $E3
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $E4
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $E5
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $E6
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $E7
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $E8
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $E9
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $EA
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $EB
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $EC
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $ED
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $EE
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $EF

        DEFINE_SYSCALL  unsupported_syscall, 0      ; $F0
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $F1
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $F2
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $F3
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $F4
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $F5
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $F6
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $F7
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $F8
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $F9
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $FA
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $FB
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $FC
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $FD
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $FE
        DEFINE_SYSCALL  unsupported_syscall, 0      ; $FF