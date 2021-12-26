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

        .import vt100_reset
        .import getc_seriala
        .import vt100_write

        .importzp   param

.macro  set_vector  vector, address
        lda     #$5C    ; JML
        sta     vector
        lda     #<address
        sta     vector+1
        lda     #>address
        sta     vector+2
        lda     #^address
        sta     vector+3
.endmacro

        .segment "SYSDATA": far

reset_vec:  .res 4
read_vec:   .res 4
write_vec:  .res 4

        .segment "BIOSROM"

console_init:

console_attach:
        set_vector  reset_vec, vt100_reset
        set_vector  read_vec, getc_seriala
        set_vector  write_vec, vt100_write
@cont:  jml     console_reset

console_reset:
        jml     reset_vec
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
        jml     write_vec

;;
; Print a null-terminated string up to 255 characters in length.
;
console_writeln:
        ldy     #0
@loop:  lda     [param],y
        beq     @exit
        jsl     write_vec
        iny
        bne     @loop
@exit:  rtl

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
