; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/ascii.s"
        .include "sys/io.s"

        .export console_init
        .export console_attach
        .export console_read
        .export console_readln
        .export console_write
        .export console_writeln
        .export print_hex
        .export print_decimal8

        .import get_device_func
        .import device_func : far

        .importzp   param

        .segment "SYSDATA": far

console_device: .res 1

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
        sta console_device

        ldx #2
        jsl get_device_func
        lda device_func
        sta reset_vec+1
        lda device_func+1
        sta reset_vec+2
        lda device_func+2
        sta reset_vec+3

        lda console_device
        ldx #4
        jsl get_device_func
        lda device_func
        sta read_vec+1
        lda device_func+1
        sta read_vec+2
        lda device_func+2
        sta read_vec+3

        lda console_device
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
; Interactively read a line of text from the console into the given input
; buffer.
;
console_readln:
        ldy     #0
@loop:  jsl     console_read
        bcc     @loop
        cmp     #BS
        beq     @bs
        cmp     #CR
        beq     @eol
        cmp     #CLS
        beq     @cls
        cmp     #' '
        bcc     @loop
        sta     [param],y
        jsl     console_write 
        iny
        bne     @loop
        dey
@eol:   lda     #0
        sta     [param],y
        rtl
@bs:    cpy     #0
        beq     @loop
        jsl     console_write 
        dey
        bra     @loop
@cls:   jsl     console_write
        bra     @loop

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

;;
; Print the 8-bit number in the accumulator in decimal
;
; Accumulator is corrupted on exit
;
print_decimal8:
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
@skip10: tax
@digit: pha
        txa
        ora     #'0'
        call    SYS_CONSOLE_WRITE
        pla 
        rts

;;
; Print the contents of the accumulator as a two-digit hexadecimal number.
;
; On exit:
;
; All registers preserved
;
print_hex:
        pha
        pha
        lsr
        lsr
        lsr
        lsr
        jsr     @digit
        pla
        and     #$0f
        jsr     @digit
        pla
        rtl
@digit: and     #$0f
        ora     #'0'
        cmp     #'9'+1
        blt     @print
        adc     #6
@print: jsl     console_write
        rts
