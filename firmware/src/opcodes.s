
        .segment "RODATA"

        .include "disasm_constants.s"

        .export length_table
        .export mnemonic_table
        .export opcode_table
        .export am_table

;;
; Instruction lengths by addressing mode
;;
length_table:
        .byte   2,3,3,4,2,1,1,2,2,2,2,2,3,4,3,2,3,3,2,2,3,1,2,2,3

;;
; Instruction nnemonics
;;
mnemonic_table:
        .byte "???", 0  ; $00
        .byte "ADC", 0  ; $01
        .byte "AND", 0  ; $02
        .byte "ASL", 0  ; $03
        .byte "BCC", 0  ; $04
        .byte "BCS", 0  ; $05
        .byte "BEQ", 0  ; $06
        .byte "BIT", 0  ; $07
        .byte "BMI", 0  ; $08
        .byte "BNE", 0  ; $09
        .byte "BPL", 0  ; $0A
        .byte "BRK", 0  ; $0B
        .byte "BVC", 0  ; $0C
        .byte "BVS", 0  ; $0D
        .byte "CLC", 0  ; $0E
        .byte "CLD", 0  ; $0F
        .byte "CLI", 0  ; $10
        .byte "CLV", 0  ; $11
        .byte "CMP", 0  ; $12
        .byte "CPX", 0  ; $13
        .byte "CPY", 0  ; $14
        .byte "DEC", 0  ; $15
        .byte "DEX", 0  ; $16
        .byte "DEY", 0  ; $17
        .byte "EOR", 0  ; $18
        .byte "INC", 0  ; $19
        .byte "INX", 0  ; $1A
        .byte "INY", 0  ; $1B
        .byte "JMP", 0  ; $1C
        .byte "JSR", 0  ; $1D
        .byte "LDA", 0  ; $1E
        .byte "LDX", 0  ; $1F
        .byte "LDY", 0  ; $20
        .byte "LSR", 0  ; $21
        .byte "NOP", 0  ; $22
        .byte "ORA", 0  ; $23
        .byte "PHA", 0  ; $24
        .byte "PHP", 0  ; $25
        .byte "PLA", 0  ; $26
        .byte "PLP", 0  ; $27
        .byte "ROL", 0  ; $28
        .byte "ROR", 0  ; $29
        .byte "RTI", 0  ; $2A
        .byte "RTS", 0  ; $2B
        .byte "SBC", 0  ; $2C
        .byte "SEC", 0  ; $2D
        .byte "SED", 0  ; $2E
        .byte "SEI", 0  ; $2F
        .byte "STA", 0  ; $30
        .byte "STX", 0  ; $31
        .byte "STY", 0  ; $32
        .byte "TAX", 0  ; $33
        .byte "TAY", 0  ; $34
        .byte "TSX", 0  ; $35
        .byte "TXA", 0  ; $36
        .byte "TXS", 0  ; $37
        .byte "TYA", 0  ; $38
        .byte "BRA", 0  ; $39
        .byte "BRL", 0  ; $3A
        .byte "PHX", 0  ; $3B
        .byte "PHY", 0  ; $3C
        .byte "PLX", 0  ; $3D
        .byte "PLY", 0  ; $3E
        .byte "STZ", 0  ; $3F
        .byte "TRB", 0  ; $40
        .byte "TSB", 0  ; $41
        .byte "STP", 0  ; $42
        .byte "WAI", 0  ; $43
        .byte "MVP", 0  ; $44
        .byte "MVN", 0  ; $45
        .byte "COP", 0  ; $46
        .byte "WDC", 0  ; $47
        .byte "XCE", 0  ; $48
        .byte "PEA", 0  ; $49
        .byte "XBA", 0  ; $4A
        .byte "SEP", 0  ; $4B
        .byte "JML", 0  ; $4C
        .byte "PEI", 0  ; $4D
        .byte "REP", 0  ; $4E
        .byte "TYX", 0  ; $4F
        .byte "PLB", 0  ; $50
        .byte "TXY", 0  ; $51
        .byte "PHB", 0  ; $52
        .byte "TDC", 0  ; $53
        .byte "RTL", 0  ; $54
        .byte "PER", 0  ; $55
        .byte "TCD", 0  ; $56
        .byte "PHK", 0  ; $57
        .byte "WDM", 0  ; $58
        .byte "TSC", 0  ; $59
        .byte "PLD", 0  ; $5A
        .byte "JSL", 0  ; $5B
        .byte "TCS", 0  ; $5C
        .byte "PHD", 0  ; $5D

;;
; Opcode table, maps actual opcodes to OP_xxx constants
;;
opcode_table:
        .byte OP_BRK
        .byte OP_ORA
        .byte OP_COP
        .byte OP_ORA
        .byte OP_TSB
        .byte OP_ORA
        .byte OP_ASL
        .byte OP_ORA
        .byte OP_PHP
        .byte OP_ORA
        .byte OP_ASL
        .byte OP_PHD
        .byte OP_TSB
        .byte OP_ORA
        .byte OP_ASL
        .byte OP_ORA
        .byte OP_BPL
        .byte OP_ORA
        .byte OP_ORA
        .byte OP_ORA
        .byte OP_TRB
        .byte OP_ORA
        .byte OP_ASL
        .byte OP_ORA
        .byte OP_CLC
        .byte OP_ORA
        .byte OP_INC
        .byte OP_TCS
        .byte OP_TRB
        .byte OP_ORA
        .byte OP_ASL
        .byte OP_ORA
        .byte OP_JSR
        .byte OP_AND
        .byte OP_JSL
        .byte OP_AND
        .byte OP_BIT
        .byte OP_AND
        .byte OP_ROL
        .byte OP_AND
        .byte OP_PLP
        .byte OP_AND
        .byte OP_ROL
        .byte OP_PLD
        .byte OP_BIT
        .byte OP_AND
        .byte OP_ROL
        .byte OP_AND
        .byte OP_BMI
        .byte OP_AND
        .byte OP_AND
        .byte OP_AND
        .byte OP_BIT
        .byte OP_AND
        .byte OP_ROL
        .byte OP_AND
        .byte OP_SEC
        .byte OP_AND
        .byte OP_DEC
        .byte OP_TSC
        .byte OP_BIT
        .byte OP_AND
        .byte OP_ROL
        .byte OP_AND
        .byte OP_RTI
        .byte OP_EOR
        .byte OP_WDM
        .byte OP_EOR
        .byte OP_MVP
        .byte OP_EOR
        .byte OP_LSR
        .byte OP_EOR
        .byte OP_PHA
        .byte OP_EOR
        .byte OP_LSR
        .byte OP_PHK
        .byte OP_JMP
        .byte OP_EOR
        .byte OP_LSR
        .byte OP_EOR
        .byte OP_BVC
        .byte OP_EOR
        .byte OP_EOR
        .byte OP_EOR
        .byte OP_MVN
        .byte OP_EOR
        .byte OP_LSR
        .byte OP_EOR
        .byte OP_CLI
        .byte OP_EOR
        .byte OP_PHY
        .byte OP_TCD
        .byte OP_JMP
        .byte OP_EOR
        .byte OP_LSR
        .byte OP_EOR
        .byte OP_RTS
        .byte OP_ADC
        .byte OP_PER
        .byte OP_ADC
        .byte OP_STZ
        .byte OP_ADC
        .byte OP_ROR
        .byte OP_ADC
        .byte OP_PLA
        .byte OP_ADC
        .byte OP_ROR
        .byte OP_RTL
        .byte OP_JMP
        .byte OP_ADC
        .byte OP_ROR
        .byte OP_ADC
        .byte OP_BVS
        .byte OP_ADC
        .byte OP_ADC
        .byte OP_ADC
        .byte OP_STZ
        .byte OP_ADC
        .byte OP_ROR
        .byte OP_ADC
        .byte OP_SEI
        .byte OP_ADC
        .byte OP_PLY
        .byte OP_TDC
        .byte OP_JMP
        .byte OP_ADC
        .byte OP_ROR
        .byte OP_ADC
        .byte OP_BRA
        .byte OP_STA
        .byte OP_BRL
        .byte OP_STA
        .byte OP_STY
        .byte OP_STA
        .byte OP_STX
        .byte OP_STA
        .byte OP_DEY
        .byte OP_BIT
        .byte OP_TXA
        .byte OP_PHB
        .byte OP_STY
        .byte OP_STA
        .byte OP_STX
        .byte OP_STA
        .byte OP_BCC
        .byte OP_STA
        .byte OP_STA
        .byte OP_STA
        .byte OP_STY
        .byte OP_STA
        .byte OP_STX
        .byte OP_STA
        .byte OP_TYA
        .byte OP_STA
        .byte OP_TXS
        .byte OP_TXY
        .byte OP_STZ
        .byte OP_STA
        .byte OP_STZ
        .byte OP_STA
        .byte OP_LDY
        .byte OP_LDA
        .byte OP_LDX
        .byte OP_LDA
        .byte OP_LDY
        .byte OP_LDA
        .byte OP_LDX
        .byte OP_LDA
        .byte OP_TAY
        .byte OP_LDA
        .byte OP_TAX
        .byte OP_PLB
        .byte OP_LDY
        .byte OP_LDA
        .byte OP_LDX
        .byte OP_LDA
        .byte OP_BCS
        .byte OP_LDA
        .byte OP_LDA
        .byte OP_LDA
        .byte OP_LDY
        .byte OP_LDA
        .byte OP_LDX
        .byte OP_LDA
        .byte OP_CLV
        .byte OP_LDA
        .byte OP_TSX
        .byte OP_TYX
        .byte OP_LDY
        .byte OP_LDA
        .byte OP_LDX
        .byte OP_LDA
        .byte OP_CPY
        .byte OP_CMP
        .byte OP_REP
        .byte OP_CMP
        .byte OP_CPY
        .byte OP_CMP
        .byte OP_DEC
        .byte OP_CMP
        .byte OP_INY
        .byte OP_CMP
        .byte OP_DEX
        .byte OP_WAI
        .byte OP_CPY
        .byte OP_CMP
        .byte OP_DEC
        .byte OP_CMP
        .byte OP_BNE
        .byte OP_CMP
        .byte OP_CMP
        .byte OP_CMP
        .byte OP_PEI
        .byte OP_CMP
        .byte OP_DEC
        .byte OP_CMP
        .byte OP_CLD
        .byte OP_CMP
        .byte OP_PHX
        .byte OP_STP
        .byte OP_JML
        .byte OP_CMP
        .byte OP_DEC
        .byte OP_CMP
        .byte OP_CPX
        .byte OP_SBC
        .byte OP_SEP
        .byte OP_SBC
        .byte OP_CPX
        .byte OP_SBC
        .byte OP_INC
        .byte OP_SBC
        .byte OP_INX
        .byte OP_SBC
        .byte OP_NOP
        .byte OP_XBA
        .byte OP_CPX
        .byte OP_SBC
        .byte OP_INC
        .byte OP_SBC
        .byte OP_BEQ
        .byte OP_SBC
        .byte OP_SBC
        .byte OP_SBC
        .byte OP_PEA
        .byte OP_SBC
        .byte OP_INC
        .byte OP_SBC
        .byte OP_SED
        .byte OP_SBC
        .byte OP_PLX
        .byte OP_XCE
        .byte OP_JSR
        .byte OP_SBC
        .byte OP_INC
        .byte OP_SBC

;;
; Addressing mode table, maps opcodes to their addressing modes
;;
am_table:
        .byte AM_d
        .byte AM_dxi
        .byte AM_d
        .byte AM_sr
        .byte AM_d
        .byte AM_d
        .byte AM_d
        .byte AM_dil
        .byte AM_implied
        .byte AM_immediate_m
        .byte AM_accumulator
        .byte AM_implied
        .byte AM_a
        .byte AM_a
        .byte AM_a
        .byte AM_al
        .byte AM_pcr
        .byte AM_dix
        .byte AM_di
        .byte AM_srix
        .byte AM_d
        .byte AM_dxx
        .byte AM_dxx
        .byte AM_dixl
        .byte AM_implied
        .byte AM_axy
        .byte AM_accumulator
        .byte AM_implied
        .byte AM_a
        .byte AM_axx
        .byte AM_axx
        .byte AM_alxx
        .byte AM_a
        .byte AM_dxi
        .byte AM_al
        .byte AM_sr
        .byte AM_d
        .byte AM_d
        .byte AM_d
        .byte AM_dil
        .byte AM_implied
        .byte AM_immediate_m
        .byte AM_accumulator
        .byte AM_implied
        .byte AM_a
        .byte AM_a
        .byte AM_a
        .byte AM_al
        .byte AM_pcr
        .byte AM_dix
        .byte AM_di
        .byte AM_srix
        .byte AM_dxx
        .byte AM_dxx
        .byte AM_dxx
        .byte AM_dixl
        .byte AM_implied
        .byte AM_axy
        .byte AM_accumulator
        .byte AM_implied
        .byte AM_axx
        .byte AM_axx
        .byte AM_axx
        .byte AM_alxx
        .byte AM_implied
        .byte AM_dxi
        .byte AM_immediate8
        .byte AM_sr
        .byte AM_blockmove
        .byte AM_d
        .byte AM_d
        .byte AM_dil
        .byte AM_implied
        .byte AM_immediate_m
        .byte AM_accumulator
        .byte AM_implied
        .byte AM_a
        .byte AM_a
        .byte AM_a
        .byte AM_al
        .byte AM_pcr
        .byte AM_dix
        .byte AM_di
        .byte AM_srix
        .byte AM_blockmove
        .byte AM_dxx
        .byte AM_dxx
        .byte AM_dixl
        .byte AM_implied
        .byte AM_axy
        .byte AM_implied
        .byte AM_implied
        .byte AM_al
        .byte AM_axx
        .byte AM_axx
        .byte AM_alxx
        .byte AM_implied
        .byte AM_dxi
        .byte AM_pcrl
        .byte AM_sr
        .byte AM_d
        .byte AM_d
        .byte AM_d
        .byte AM_dil
        .byte AM_implied
        .byte AM_immediate_m
        .byte AM_accumulator
        .byte AM_implied
        .byte AM_ai
        .byte AM_a
        .byte AM_a
        .byte AM_al
        .byte AM_pcr
        .byte AM_dix
        .byte AM_di
        .byte AM_srix
        .byte AM_dxx
        .byte AM_dxx
        .byte AM_dxx
        .byte AM_dixl
        .byte AM_implied
        .byte AM_axy
        .byte AM_implied
        .byte AM_implied
        .byte AM_axi
        .byte AM_axx
        .byte AM_axx
        .byte AM_alxx
        .byte AM_pcr
        .byte AM_dxi
        .byte AM_pcrl
        .byte AM_sr
        .byte AM_d
        .byte AM_d
        .byte AM_d
        .byte AM_dil
        .byte AM_implied
        .byte AM_immediate_m
        .byte AM_implied
        .byte AM_implied
        .byte AM_a
        .byte AM_a
        .byte AM_a
        .byte AM_al
        .byte AM_pcr
        .byte AM_dix
        .byte AM_di
        .byte AM_srix
        .byte AM_dxx
        .byte AM_dxx
        .byte AM_dxy
        .byte AM_dixl
        .byte AM_implied
        .byte AM_axy
        .byte AM_implied
        .byte AM_implied
        .byte AM_a
        .byte AM_axx
        .byte AM_axx
        .byte AM_alxx
        .byte AM_immediate_x
        .byte AM_dxi
        .byte AM_immediate_x
        .byte AM_sr
        .byte AM_d
        .byte AM_d
        .byte AM_d
        .byte AM_dil
        .byte AM_implied
        .byte AM_immediate_m
        .byte AM_implied
        .byte AM_implied
        .byte AM_a
        .byte AM_a
        .byte AM_a
        .byte AM_al
        .byte AM_pcr
        .byte AM_dix
        .byte AM_di
        .byte AM_srix
        .byte AM_dxx
        .byte AM_dxx
        .byte AM_dxy
        .byte AM_dixl
        .byte AM_implied
        .byte AM_axy
        .byte AM_implied
        .byte AM_implied
        .byte AM_axx
        .byte AM_axx
        .byte AM_axy
        .byte AM_alxx
        .byte AM_immediate_x
        .byte AM_dxi
        .byte AM_immediate8
        .byte AM_sr
        .byte AM_d
        .byte AM_d
        .byte AM_d
        .byte AM_dil
        .byte AM_implied
        .byte AM_immediate_m
        .byte AM_implied
        .byte AM_implied
        .byte AM_a
        .byte AM_a
        .byte AM_a
        .byte AM_al
        .byte AM_pcr
        .byte AM_dix
        .byte AM_di
        .byte AM_srix
        .byte AM_d
        .byte AM_dxx
        .byte AM_dxx
        .byte AM_dixl
        .byte AM_implied
        .byte AM_axy
        .byte AM_implied
        .byte AM_implied
        .byte AM_ai
        .byte AM_axx
        .byte AM_axx
        .byte AM_alxx
        .byte AM_immediate_x
        .byte AM_dxi
        .byte AM_immediate8
        .byte AM_sr
        .byte AM_d
        .byte AM_d
        .byte AM_d
        .byte AM_di
        .byte AM_implied
        .byte AM_immediate_m
        .byte AM_implied
        .byte AM_implied
        .byte AM_a
        .byte AM_a
        .byte AM_a
        .byte AM_al
        .byte AM_pcr
        .byte AM_dix
        .byte AM_di
        .byte AM_srix
        .byte AM_immediate16
        .byte AM_dxx
        .byte AM_dxx
        .byte AM_dixl
        .byte AM_implied
        .byte AM_axy
        .byte AM_implied
        .byte AM_implied
        .byte AM_axi
        .byte AM_axx
        .byte AM_axx
        .byte AM_alxx
