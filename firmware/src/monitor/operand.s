; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************
;
; Operand parsing for the miniassembler.


                .extern         arg, operand, operand_size, operand_type, print_error, token
                .importzp       ibuffp

                .section        "OSROM"

;;
; Instruction lengths by operand type
;
instr_lengths:
                .byte           2               ; Operand::immediate8
                .byte           3               ; Operand::immediate16
                .byte           3               ; Operand::absolute
                .byte           4               ; Operand::al
                .byte           2               ; Operand::d
                .byte           1               ; Operand::implied
                .byte           2               ; Operand::dix
                .byte           2               ; Operand::dixl
                .byte           2               ; Operand::dxi
                .byte           2               ; Operand::dxx
                .byte           2               ; Operand::dxy
                .byte           3               ; Operand::axx
                .byte           4               ; Operand::alxx
                .byte           3               ; Operand::axy
                .byte           2               ; Operand::pcr
                .byte           3               ; Operand::pcrl
                .byte           3               ; Operand::ai
                .byte           2               ; Operand::di
                .byte           2               ; Operand::dil
                .byte           3               ; Operand::axi
                .byte           2               ; Operand::sr
                .byte           2               ; Operand::arix
                .byte           3               ; Operand::blockmove
                .byte           2               ; Operand::immediate_x
                .byte           2               ; Operand::immediate_m

;;
; Display an INVALID_OPERAND error for the current token
;
operand_error:
                lda             token
                pha
                pea             .hiword(Monitor::INVALID_OPERAND)
                pea             .loword(Monitor::INVALID_OPERAND)
                jsr             print_error
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
.proc           parse_operand
                jsr             skip_whitespace
                lda             ibuffp
                sta             token
                stz             operand
                stz             operand + 2
                jsr             next_token
                cpx             ##Token::eol
                bne             :+
                lda             ##Operand::implied
                sta             operand_type
                clc
                rts
:               cpx             ##Token::pound
                beq             parse_immediate
                cpx             ##Token::lparen
                beq             parse_indirect
                cpx             ##Token::lbracket
                bne             :+
                brl             parse_indirect_long
:               cpx             ##Token::const8
                bne             :+
                brl             parse_const8
:               cpx             ##Token::const16
                bne             :+
                brl             parse_const16
:               cpx             ##Token::const24
                bne             operand_error
                brl             parse_const24

parse_immediate:
                jsr             next_token
                cpx             ##Token::const8
                beq             i8$
                cpx             ##Token::const16
                beq             i16$
                jmp             operand_error
i8$:            lda             ##Operand::immediate8
                sta             operand_type
                lda             ##1
                bra             done$
i16$:           lda             ##Operand::immediate16
                sta             operand_type
                lda             ##0
done$:          sta             operand_size
                lda             arg
                sta             operand
                clc
                rts

parse_indirect:
                jsr             next_token
                cpx             ##Token::const16
                beq             parse_absolute_indirect
                cpx             ##Token::const8
                beq             parse_direct_indirect
                jmp             operand_error

parse_absolute_indirect:
                lda             arg
                sta             operand
                jsr             next_token
                cpx             ##Token::rparen
                bne             :+
                lda             ##Operand::ai
                sta             operand_type
                clc
                rts
:               cpx             ##Token::comma
                bne             err$
                jsr             next_token
                cpx             ##Token::xreg
                bne             err$
                jsr             next_token
                cpx             ##Token::rparen
                bne             err$
                lda             ##Operand::axi
                sta             operand_type
                clc
                rts
err$:           jmp             operand_error

parse_direct_indirect:
                lda             arg
                sta             operand
                jsr             next_token
                cpx             ##Token::rparen
                beq             parse_direct_indirect_indexed
                cpx             ##Token::comma
                bne             err$
                jsr             next_token
                cpx             ##Token::xreg
                bne             :+
                jsr             next_token
                cpx             ##Token::rparen
                bne             err$
                lda             ##Operand::dxi
                sta             operand_type
                clc
                rts
:               cpx             ##Token::sreg
                bne             err$
                jsr             next_token
                cpx             ##Token::rparen
                bne             err$
                jsr             next_token
                cpx             ##Token::comma
                bne             err$
                jsr             next_token
                cpx             ##Token::yreg
                bne             err$
                lda             ##Operand::srix
                sta             operand_type
                clc
                rts
err$:           jmp             operand_error

parse_direct_indirect_indexed:
                jsr             next_token
                cpx             ##Token::eol
                bne             :+
                lda             ##Operand::di
                sta             operand_type
                clc
                rts
:               cpx             ##Token::comma
                bne             err$
                jsr             next_token
                cpx             ##Token::yreg
                bne             err$
                lda             ##Operand::dix
                sta             operand_type
                clc
                rts
err$:           jmp             operand_error

parse_indirect_long:
                jsr             next_token
                cpx             ##Token::const8
                bne             err$
                lda             arg
                sta             operand
                jsr             next_token
                cpx             ##Token::rbracket
                bne             err$
                jsr             next_token
                cpx             ##Token::eol
                bne             :+
                lda             ##Operand::dil
                sta             operand_type
                clc
                rts
:               cpx             ##Token::comma
                bne             err$
                jsr             next_token
                cpx             ##Token::yreg
                bne             err$
                lda             ##Operand::dixl
                sta             operand_type
                clc
                rts
err$:           jmp             operand_error

parse_const8:
                lda             arg
                sta             operand
                jsr             next_token
                cpx             ##Token::eol
                bne             :+
                lda             ##Operand::d
                sta             operand_type
                clc
                rts
:               cpx             ##Token::comma
                bne             err$
                jsr             next_token
                cpx             ##Token::const8
                bne             :+
                lda             arg + 1
                sta             operand + 1
                lda             ##Operand::blockmove
                sta             operand_type
                clc
                rts
:               cpx             ##Token::sreg
                bne             :+
                lda             ##Operand::sr
                sta             operand_type
                clc
                rts
:               cpx             ##Token::xreg
                bne             :+
                lda             ##Operand::dxx
                sta             operand_type
                clc
                rts
:               cpx             ##Token::yreg
                bne             err$
                lda             ##Operand::dxy
                sta             operand_type
                clc
                rts
err$:           jmp             operand_error

parse_const16:
                lda             arg
                sta             operand
                jsr             next_token
                cpx             ##Token::eol
                bne             :+
                lda             ##Operand::absolute
                sta             operand_type
                clc
                rts
:               cpx             ##Token::comma
                bne             err$
                jsr             next_token
                cpx             ##Token::xreg
                bne             :+
                lda             ##Operand::axx
                sta             operand_type
                clc
                rts
:               cpx             ##Token::yreg
                bne             err$
                lda             ##Operand::axy
                sta             operand_type
                clc
                rts
err$:           jmp             operand_error

parse_const24:
                lda             arg
                sta             operand
                lda             arg + 2
                sta             operand + 2
                jsr             next_token
                cpx             ##Token::eol
                bne             :+
                lda             ##Operand::al
                sta             operand_type
                clc
                rts
:               cpx             ##Token::comma
                bne             err$
                jsr             next_token
                cpx             ##Token::xreg
                bne             err$
                lda             ##Operand::alxx
                sta             operand_type
                clc
                rts
err$:           jmp             operand_error
.endproc

;;
; Parse the next token in the input buffer.
;
; Output:
; token value in arg
; X = token type
;
.proc           next_token
                jsr             skip_whitespace
                shortm
                lda             [ibuffp]
                bne             :+
                ldx             ##Token::eol
                bra             done$
:               cmp             #'#'
                bne             :+
                ldx             ##Token::pound
                bra             advance$
:               cmp             #'('
                bne             :+
                ldx             ##Token::lparen
                bra             advance$
:               cmp             #')'
                bne             :+
                ldx             ##Token::rparen
                bra             advance$
:               cmp             #'['
                bne             :+
                ldx             ##Token::lbracket
                bra             advance$
:               cmp             #']'
                bne             :+
                ldx             ##Token::rbracket
                bra             advance$
:               cmp             #','
                bne             :+
                ldx             ##Token::comma
                bra             advance$
:               ora             #$20
                cmp             #'s'
                bne             :+
                ldx             ##Token::sreg
                bra             advance$
:               cmp             #'x'
                bne             :+
                ldx             ##Token::xreg
                bra             advance$
:               cmp             #'y'
                bne             :+
                ldx             ##Token::yreg
                bra             advance$
:               jsr             is_hex_digit
                bcc             :+
                ldx             ##Token::unknown
                bra             done$
:               ldx             ##6
                jsr             parse_hex
                cpy             ##5
                blt             :+
                ldx             ##Token::const24
                bra             done$
:               cpy             ##3
                blt             :+
                ldx             ##Token::const16
                bra             done$
:               ldx             ##Token::const8
done$:          longm
                rts
advance$:
                longm
                inc             ibuffp
                rts

.endproc
