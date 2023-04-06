; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************
;
; Operand parsing for the miniassembler.

        .include "common.inc"
        .include "constants.inc"
        .include "parser.inc"
        .include "operand.inc"

        .import   arg, operand, operand_size, operand_type, print_error, token
        .importzp ibuffp

        .segment "OSROM"

;;
; Instruction lengths by operand type
;
instr_lengths:
        .byte   2   ; Operand::immediate8
        .byte   3   ; Operand::immediate16
        .byte   3   ; Operand::absolute
        .byte   4   ; Operand::al
        .byte   2   ; Operand::d
        .byte   1   ; Operand::implied
        .byte   2   ; Operand::dix
        .byte   2   ; Operand::dixl
        .byte   2   ; Operand::dxi
        .byte   2   ; Operand::dxx
        .byte   2   ; Operand::dxy
        .byte   3   ; Operand::axx
        .byte   4   ; Operand::alxx
        .byte   3   ; Operand::axy
        .byte   2   ; Operand::pcr
        .byte   3   ; Operand::pcrl
        .byte   3   ; Operand::ai
        .byte   2   ; Operand::di
        .byte   2   ; Operand::dil
        .byte   3   ; Operand::axi
        .byte   2   ; Operand::sr
        .byte   2   ; Operand::arix
        .byte   3   ; Operand::blockmove
        .byte   2   ; Operand::immediate_x
        .byte   2   ; Operand::immediate_m

;;
; Display an INVALID_OPERAND error for the current token
;
operand_error:
        lda     token
        pha
        pea     .hiword(Monitor::INVALID_OPERAND)
        pea     .loword(Monitor::INVALID_OPERAND)
        jsr     print_error
        sec
        rts

;;
; Parse the operand
;
; On exit:
; c = 0 on success
; c = 1 on failure
; C,X,Y trashed
; Operand information in <operand,operand_size,operand_type>
; ibuffp points to char after last successfully parsed token
;
.proc parse_operand
        jsr     skip_whitespace
        lda     ibuffp
        sta     token
        stz     operand
        stz     operand + 2
        jsr     next_token
        cpxw    #Token::eol
        bne     :+
        ldaw    #Operand::implied
        sta     operand_type
        clc
        rts
:       cpxw    #Token::pound
        beq     parse_immediate
        cpxw    #Token::lparen
        beq     parse_indirect
        cpxw    #Token::lbracket
        bne     :+
        brl     parse_indirect_long
:       cpxw    #Token::const8
        bne     :+
        brl     parse_const8
:       cpxw    #Token::const16
        bne     :+
        brl     parse_const16
:       cpxw    #Token::const24
        bne     operand_error
        brl     parse_const24

parse_immediate:
        jsr     next_token
        cpxw    #Token::const8
        beq     @i8
        cpxw    #Token::const16
        beq     @i16
        jmp     operand_error
@i8:    ldaw    #Operand::immediate8
        sta     operand_type
        ldaw    #1
        bra     @done
@i16:   ldaw    #Operand::immediate16
        sta     operand_type
        ldaw    #0
@done:  sta     operand_size
        lda     arg
        sta     operand
        clc
        rts

parse_indirect:
        jsr     next_token
        cpxw    #Token::const16
        beq     parse_absolute_indirect
        cpxw    #Token::const8
        beq     parse_direct_indirect
        jmp     operand_error

parse_absolute_indirect:
        lda     arg
        sta     operand
        jsr     next_token
        cpxw    #Token::rparen
        bne     :+
        ldaw    #Operand::ai
        sta     operand_type
        clc
        rts
:       cpxw    #Token::comma
        bne     @err
        jsr     next_token
        cpxw    #Token::xreg
        bne     @err
        jsr     next_token
        cpxw    #Token::rparen
        bne     @err
        ldaw    #Operand::axi
        sta     operand_type
        clc
        rts
@err:   jmp     operand_error

parse_direct_indirect:
        lda     arg
        sta     operand
        jsr     next_token
        cpxw    #Token::rparen
        beq     parse_direct_indirect_indexed
        cpxw    #Token::comma
        bne     @err
        jsr     next_token
        cpxw    #Token::xreg
        bne     :+
        jsr     next_token
        cpxw    #Token::rparen
        bne     @err
        ldaw    #Operand::dxi
        sta     operand_type
        clc
        rts
:       cpxw    #Token::sreg
        bne     @err
        jsr     next_token
        cpxw    #Token::rparen
        bne     @err
        jsr     next_token
        cpxw    #Token::comma
        bne     @err
        jsr     next_token
        cpxw    #Token::yreg
        bne     @err
        ldaw    #Operand::srix
        sta     operand_type
        clc
        rts
@err:   jmp     operand_error

parse_direct_indirect_indexed:
        jsr     next_token
        cpxw    #Token::eol
        bne     :+
        ldaw    #Operand::di
        sta     operand_type
        clc
        rts
:       cpxw    #Token::comma
        bne     @err
        jsr     next_token
        cpxw    #Token::yreg
        bne     @err
        ldaw    #Operand::dix
        sta     operand_type
        clc
        rts
@err:   jmp     operand_error

parse_indirect_long:
        jsr     next_token
        cpxw    #Token::const8
        bne     @err
        lda     arg
        sta     operand
        jsr     next_token
        cpxw    #Token::rbracket
        bne     @err
        jsr     next_token
        cpxw    #Token::eol
        bne     :+
        ldaw    #Operand::dil
        sta     operand_type
        clc
        rts
:       cpxw    #Token::comma
        bne     @err
        jsr     next_token
        cpxw    #Token::yreg
        bne     @err
        ldaw    #Operand::dixl
        sta     operand_type
        clc
        rts
@err:   jmp     operand_error

parse_const8:
        lda     arg
        sta     operand
        jsr     next_token
        cpxw    #Token::eol
        bne     :+
        ldaw    #Operand::d
        sta     operand_type
        clc
        rts
:       cpxw    #Token::comma
        bne     @err
        jsr     next_token
        cpxw    #Token::const8
        bne     :+
        lda     arg + 1
        sta     operand + 1
        ldaw    #Operand::blockmove
        sta     operand_type
        clc
        rts
:       cpxw    #Token::sreg
        bne     :+
        ldaw    #Operand::sr
        sta     operand_type
        clc
        rts
:       cpxw    #Token::xreg
        bne     :+
        ldaw    #Operand::dxx
        sta     operand_type
        clc
        rts
:       cpxw    #Token::yreg
        bne     @err
        ldaw    #Operand::dxy
        sta     operand_type
        clc
        rts
@err:   jmp     operand_error

parse_const16:
        lda     arg
        sta     operand
        jsr     next_token
        cpxw    #Token::eol
        bne     :+
        ldaw    #Operand::absolute
        sta     operand_type
        clc
        rts
:       cpxw    #Token::comma
        bne     @err
        jsr     next_token
        cpxw    #Token::xreg
        bne     :+
        ldaw    #Operand::axx
        sta     operand_type
        clc
        rts
:       cpxw    #Token::yreg
        bne     @err
        ldaw    #Operand::axy
        sta     operand_type
        clc
        rts
@err:   jmp     operand_error

parse_const24:
        lda     arg
        sta     operand
        lda     arg + 2
        sta     operand + 2
        jsr     next_token
        cpxw    #Token::eol
        bne     :+
        ldaw    #Operand::al
        sta     operand_type
        clc
        rts
:       cpxw    #Token::comma
        bne     @err
        jsr     next_token
        cpxw    #Token::xreg
        bne     @err
        ldaw    #Operand::alxx
        sta     operand_type
        clc
        rts
@err:   jmp     operand_error
.endproc

;;
; Parse the next token in the input buffer.
;
; Output:
; token value in arg
; X = token type
;
.proc next_token
        jsr     skip_whitespace
        shortm
        lda     [ibuffp]
        bne     :+
        ldxw    #Token::eol
        bra     @done
:       cmp     #'#'
        bne     :+
        ldxw    #Token::pound
        bra     @advance
:       cmp     #'('
        bne     :+
        ldxw    #Token::lparen
        bra     @advance
:       cmp     #')'
        bne     :+
        ldxw    #Token::rparen
        bra     @advance
:       cmp     #'['
        bne     :+
        ldxw    #Token::lbracket
        bra     @advance
:       cmp     #']'
        bne     :+
        ldxw    #Token::rbracket
        bra     @advance
:       cmp     #','
        bne     :+
        ldxw    #Token::comma
        bra     @advance
:       ora     #$20
        cmp     #'s'
        bne     :+
        ldxw    #Token::sreg
        bra     @advance
:       cmp     #'x'
        bne     :+
        ldxw    #Token::xreg
        bra     @advance
:       cmp     #'y'
        bne     :+
        ldxw    #Token::yreg
        bra     @advance
:       jsr     is_hex_digit
        bcc     :+
        ldxw    #Token::unknown
        bra     @done
:       ldxw    #6
        jsr     parse_hex
        cpyw    #5
        blt     :+
        ldxw    #Token::const24
        bra     @done
:       cpyw    #3
        blt     :+
        ldxw    #Token::const16
        bra     @done
:       ldxw    #Token::const8
@done:  longm
        rts
@advance:
        longm
        inc     ibuffp
        rts

.endproc
