; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************
;
; 65c816 mini-assembler, modled after the one included with the
; IIGS monitor.


                .global         assemble

                .extern         read_line
                .extern         arg, error_msg, instr, instr_len, operand, operand_size, operand_type, ibuff, IBUFFSZ, token
                .extern         print_instruction
                .importzp       ibuffp, ptr, start_loc, tmp

                .section        "OSROM"

;;
; Entry point for the monitor's (!) command
;
.proc           assemble
                jsr             show_prompt
                lda             ##.hiword(ibuff)
                sta             ibuffp + 2
                pha
                lda             ##.loword(ibuff)
                sta             ibuffp
                pha
                pea             IBUFFSZ
                jsl             read_line
                shortm
                lda             [ibuffp]
                longm
                beq             exit$
                jsr             parse_line
                bcs             assemble
                jsr             generate_instruction
                bra             assemble
exit$:          rts
.endproc

.proc           show_prompt
                _puts           p$
                rts
p$:             .byte           '!', 0
.endproc

;;
; Try to parse the line in the input buffer.
;
; If the line begins with a space, it is assumed to be an instruction
; to be assembled at the current location. Otherwise, try to parse a
; new assembly address first, followed by a colon and then the instruction
; to assemble.
;
; On exit:
;
; c = 1 on error or 0 on success
;
.proc           parse_line
                shortm
                lda             [ibuffp]
                cmp             #' '
                beq             op$
                longm
                jsr             parse_address
                shortm
                lda             [ibuffp]
                cmp             #':'            ; Address must be followed by a colon
                longm
                beq             op$
                lda             ibuffp
                pha
                pea             .hiword(Monitor::COLON_EXPECTED)
                pea             .loword(Monitor::COLON_EXPECTED)
                jsr             print_error
                sec
                rts
op$:            inc             ibuffp          ; eat the colon or space
                jsr             match_opcode
                bcs             err$
                jmp             parse_operand
err$:           rts

.endproc

;;
; Try Match the text at the current ibuffp against the opcode mnemonic table.
;
.proc           match_opcode
                jsr             skip_whitespace
                stz             arg
                stz             arg + 2
                shortm
                ldy             ##0
copy$:          lda             [ibuffp],y
                beq             find$
                cmp             #' '+1
                blt             find$
                cmp             #'a'
                blt             :+
                cmp             #'z'+1
                bge             :+
                and             #$DF            ; shift to upper case
:               sta             arg,y
                iny
                cpy             ##3
                bne             copy$
find$:          longm
                lda             ##.loword(instr_mnemonics)
                sta             ptr
                lda             ##.hiword(instr_mnemonics)
                sta             ptr + 2
                ldx             ##0             ; entry counter
                ldy             ##2
entry$:         lda             [ptr]
                cmp             arg
                bne             next$
                lda             [ptr],y
                cmp             arg + 2
                beq             match$
next$:          inx
                lda             ptr
                clc
                adc             ##4
                sta             ptr             ; ignore hi word; the table can't cross banks
                lda             [ptr]
                bne             entry$          ; try again if we're not at end-of-table
                lda             ibuffp
                pha
                pea             .hiword(Monitor::UNKNOWN_OPCODE)
                pea             .loword(Monitor::UNKNOWN_OPCODE)
                jsr             print_error
                sec
                rts
match$:         stx             instr
                lda             ibuffp
                clc
                adc             ##3
                sta             ibuffp          ; update ibuffp to skip opcode
                clc
                rts

.endproc

;;
; Given instr/operand find a matching opcode and generate assembly code
; at start_loc, then update start_loc.
;
; On exit:
; c = 0 on success
; c = 1 on failure (ie invalid addressing mode)
;
.proc           generate_instruction
                lda             instr
                cmp             ##Instr::BCC
                blt             :+
                jsr             handle_relative_operand
                bcs             err$
:               shortmx
                ldx             #0
loop$:          lda             f:opcode_operands,x
                cmp             operand_type
                beq             instr$
                cmp             #Operand::immediate_m
                bne             :+
                jsr             match_immediate
                bcs             next$
                bra             instr$
:               cmp             #Operand::immediate_x
                bne             next$
                jsr             match_immediate
                bcs             next$
instr$:         lda             f:opcode_instr,x
                cmp             instr
                beq             match$
next$:          inx
                bne             loop$
err$:           longmx
                jmp             operand_error
match$:         txa
                sta             [start_loc]
                jsr             set_instr_len
                ldy             instr_len
:               dey
                beq             done$
                lda             operand-1,y
                sta             [start_loc],y
                bra             :-
done$:          longmx
                lda             start_loc + 2
                pha
                lda             start_loc
                pha
                shortm
                lda             operand_size
                pha
                pha             ; use as both m and x width
                _puts           cll$
                lda             #CR
                _putchar
                longm
                jsr             print_instruction
                lda             start_loc
                clc
                adc             instr_len
                sta             start_loc
                clc
                rts
cll$:           .byte           ESC, LBRACKET, "2K", 0

match_immediate:
                lda             operand_type
                cmp             #Operand::immediate8
                bne             :+
                lda             #1
                sta             operand_size
                clc
                rts
:               cmp             #Operand::immediate16
                bne             :+
                lda             #0
                sta             operand_size
                clc
                rts
:               sec
                rts

handle_relative_operand:
                lda             operand_type
                cmp             ##Operand::absolute
                beq             :+
                cmp             ##Operand::d
                beq             :+
                sec
                rts
:               lda             operand
                sec
                sbc             start_loc
                dec
                dec
                sta             operand
                lda             instr
                cmp             ##Instr::BRL
                bge             pcrl$
                lda             operand
                and             ##$FF80         ; mask upper 9 bits
                beq             :+              ; must be all zeroe
                cmp             ##$FF80         ; or all ones
                beq             :+
                sec
                rts
:               lda             ##Operand::pcr
                sta             operand_type
                clc
                rts
pcrl$:          dec             operand
                lda             ##Operand::pcrl
                sta             operand_type
                clc
                rts

set_instr_len:
                ldx             operand_type
                lda             f:instr_lengths,x
                sta             instr_len
                stz             instr_len + 1
                cpx             #Operand::immediate_m
                beq             os$
                cpx             #Operand::immediate_x
                beq             os$
:               rts
os$:            ldx             operand_size
                bne             :-
                inc             instr_len
                rts

.endproc
