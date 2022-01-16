; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; This file contains utility functions used by the system monitor,
; mini-assembler and the disassembler.
;
        .include "common.s"
        .include "sys/ascii.s"
        .include "sys/util.s"

        .importzp maxhex
        .importzp arg
        .importzp tmp
        .importzp start_loc

        .export print_hex
        .export print_decimal8
        .export print_decimal32
        .export parse_address
        .export parse_hex
        .export print_spaces
        .export read_line
        .export skip_whitespace

        .import console_write

        .segment "SYSDATA"

        .align   256
ibuff:  .res    256
bcd:    .res    6

        .segment "OSROM"

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
@skip10:
        tax
        jsr     @digit
        rtl
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
        blt     :+
        adc     #6
:       call    SYS_CONSOLE_WRITE
        rts

;;
; Read a line of text from the console with simple editing
;
; On exit:
;
; ibuffp : points to start of input buffer
; A,Y : contents trashed
;
read_line:
        lda     #<ibuff
        sta     ibuffp
        lda     #>ibuff
        sta     ibuffp+1
        lda     #^ibuff
        sta     ibuffp+2
        ldy     #0
@loop:  call    SYS_CONSOLE_READ
        bcc     @loop
        cmp     #BS
        beq     @bs
        cmp     #CR
        beq     @eol
        cmp     #CLS
        beq     @cls
        cmp     #' '
        bcc     @loop
        sta     [ibuffp],y
        call    SYS_CONSOLE_WRITE
        iny
        bne     @loop
        dey
@eol:   lda     #0
        sta     [ibuffp],y
        rts
@bs:    cpy     #0
        beq     @loop
        call    SYS_CONSOLE_WRITE
        dey
        bra     @loop
@cls:   call    SYS_CONSOLE_WRITE
        bra     @loop

;;
; Attempt to parse an address from ibuffp into start_loc. An address
; can be of the form $XXYY or $BB/XXYY. If no bank is specified the
; existing bank value is used.
;
; If no valid hex address could be parsed, start_loc is unchanged.
;
; On exit:
;
; ibuffp : Points to input buffer after any parsed address
; start_loc : contains parsed address, if successful
; A,Y : trashed
;
parse_address:
        ldy     #4
        jsr     parse_hex
        beq     @done       ; No address present
        getc
        cmp     #'/'        ; Was the parsed value a bank value?
        bne     @addr
        lda     arg
        sta     start_loc+2 ; set bank byte
        nextc               ; Skip the "/"
        ldy     #4
        jsr     parse_hex   ; Continue trying to parse an address
        beq     @done
@addr:  longm
        lda     arg
        sta     start_loc
        shortm
@done:  rts

;;
; Attempt to parse up to Y hex digits at the current ibuffp
; and store the result in arg.
;
; On entry:
;
;   Y : maximum number of digits to parse, 1-8
;
; On exit:
;
;   c : Clear if at least one digit was parsed
;   Y : number of digits parsed. 0 -> 8
;
parse_hex:
        sty     maxhex
        longm
        stz     arg
        stz     arg+2
        shortm
        ldy     #0
@next:  getc
        cmp     #' '+1
        blt     @done
        sec
        sbc     #'0'
        cmp     #10
        blt     @store
        ora     #$20            ; shift uppercase to lowercase
        sbc     #'a'-'0'-10
        cmp     #10
        blt     @done
        cmp     #16
        bge     @done
@store: longm
        asl     arg
        asl     arg
        asl     arg
        asl     arg
        shortm
        ora     arg
        sta     arg
        nextc
        iny
        cpy     maxhex
        bne     @next
@done:  cpy     #0
        rts

;
; Print out a string of space whose length is given in the X register.
; X may be zero, in which case nothing is printed.
;
print_spaces:
        cpx     #0
        beq     @exit
        pha
        phx
@loop:  lda     #' '
        call    SYS_CONSOLE_WRITE
        dex
        bne     @loop
        plx
        pla
@exit:  rts

;
; Skip input_index ahead to either the first non-whitespace character,
; or the end of line NULL, whichever occurs first.
;
skip_whitespace:
        pha
@loop:  getc
        beq     @exit
        cmp     #' '+1
        bge     @exit
        nextc
        bra     @loop
@exit:  pla
        rts

;;
; Print the 32-bit number passed on the stack to the console
; as a decimal number.
;
; Inputs:
; 32-bit input number on stack
;
; Outputs:
; All registers trashed
;
print_decimal32:
        longm
        lda     4,s
        sta     arg
        lda     6,s
        sta     arg+2
        lda     1,s
        sta     5,s
        lda     2,s
        sta     6,s
        tsc
        clc
        adcw    #4
        tcs
        stz     bcd
        stz     bcd+2
        stz     bcd+4   ; Start output number at zero
        sed
        ldx     #32
:       asl     arg
        rol     arg+2   ; Shift out a bit
        lda     bcd     ; Multiply BCD x 2, and add bit from arg
        adc     bcd
        sta     bcd
        lda     bcd+2
        adc     bcd+2
        sta     bcd+2
        lda     bcd+4
        adc     bcd+4
        sta     bcd+4
        dex
        bne     :-
        cld
        shortm
        stz     tmp         ; do not print until non-zero digit found
        lda     bcd + 4
        jsr     @byte
        lda     bcd + 3
        jsr     @byte
        lda     bcd + 2
        jsr     @byte
        lda     bcd + 1
        jsr     @byte
        lda     bcd
        jsr     @byte
        lda     tmp
        bne     :+
        lda     #'0'
        call    SYS_CONSOLE_WRITE
:       rtl
@byte:  tax
        lsr
        lsr
        lsr
        lsr
        jsr     @digit
        txa
        and     #$0F
@digit: cmp     #0
        bne     :+
        bit     tmp
        bne     :+
        rts
:       clc
        adc     #'0'
        sta     tmp
        call    SYS_CONSOLE_WRITE
        rts
