; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/ascii.s"
        .include "sys/devices.s"
        .include "sys/io.s"

        .export console_init
        .export console_attach
        .export console_read
        .export console_write
        .export console_writeln
        .export console_device

        .import get_device_func
        .import device_func : far
        .import noop

        .importzp   param

        .segment "SYSDATA": far

console_device_id: .res 1

reset_vec:  .res 4
read_vec:   .res 4
write_vec:  .res 4

        .segment "BOOTROM"

console_init:
        lda #$5C
        sta reset_vec
        sta read_vec
        sta write_vec

        lda #1  ; SERIAL A
        jsl console_attach
        rts

console_attach:
        cmp #0
        bne :+
        syserr  ERR_NOT_SUPPORTED
:       sta console_device_id

        ldx #2
        jsl get_device_func
        lda device_func
        sta reset_vec+1
        lda device_func+1
        sta reset_vec+2
        lda device_func+2
        sta reset_vec+3

        lda console_device_id
        ldx #4
        jsl get_device_func
        lda device_func
        sta read_vec+1
        lda device_func+1
        sta read_vec+2
        lda device_func+2
        sta read_vec+3

        lda console_device_id
        ldx #5
        jsl get_device_func
        lda device_func
        sta write_vec+1
        lda device_func+1
        sta write_vec+2
        lda device_func+2
        sta write_vec+3

        ; fall through

console_reset:
        jsl     reset_vec

        lda     #ESC
        jsl     write_vec
        lda     #'c'
        jsl     write_vec
        ; Enable line wrap
        lda     #ESC
        jsl     write_vec
        lda     #LBRACKET
        jsl     write_vec
        lda     #'7'
        jsl     write_vec
        lda     #'h'
        jsl     write_vec
        ; Set character set G1 to the line drawing chars
        lda     #ESC
        jsl     write_vec
        lda     #')'
        jsl     write_vec
        lda     #'0'
        jsl     write_vec
        lda     #ESC
        jsl     write_vec
        lda     #LBRACKET
        jsl     write_vec
        lda     #'2'
        jsl     write_vec
        lda     #'J'
        jml     write_vec

;;
; Try to read a character from the console. If data is availble,
; returns the char in A and carry is set. Otherwise, returns with
; carry clear.
;
console_read:
        jml     read_vec

;;
; Output character in A to the console
;
console_write:
        pha
        jsl     write_vec
        pla
        cmp     #CR
        bne     @exit
        lda     #LF
        jsl     write_vec
@exit:  rtl

;;
; Print a null-terminated string up to 255 characters in length.
;
console_writeln:
        ldy     #0
@loop:  lda     [param],y
        beq     @exit
        jsl     console_write
        iny
        bne     @loop
@exit:  rtl

console_device:
        .byte   "CONSOLE", 0, 0, 0, 0, 0, 0, 0, 0
        .byte   DEVICE_TYPE_CONSOLE
        longaddr noop           ; startup
        longaddr noop           ; shutdown
        longaddr console_reset  ; reset
        longaddr noop           ; status
        longaddr console_read   ; read
        longaddr console_write  ; write
        longaddr noop           ; rdcheck
        longaddr noop           ; wrcheck
        longaddr noop           ; get params
        longaddr noop           ; set_params
