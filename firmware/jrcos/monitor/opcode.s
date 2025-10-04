
        .segment "OSROM"

        .include "opcode.inc"
        .include "operand.inc"

;;
; Instruction nnemonics
;
instr_mnemonics:
        .byte "ADC", 0  ; $00
        .byte "AND", 0  ; $01
        .byte "ASL", 0  ; $02
        .byte "BIT", 0  ; $03
        .byte "BRK", 0  ; $04
        .byte "CLC", 0  ; $05
        .byte "CLD", 0  ; $06
        .byte "CLI", 0  ; $07
        .byte "CLV", 0  ; $08
        .byte "CMP", 0  ; $09
        .byte "COP", 0  ; $0A
        .byte "CPX", 0  ; $0B
        .byte "CPY", 0  ; $0C
        .byte "DEC", 0  ; $0D
        .byte "DEX", 0  ; $0E
        .byte "DEY", 0  ; $0F
        .byte "EOR", 0  ; $10
        .byte "INC", 0  ; $11
        .byte "INX", 0  ; $12
        .byte "INY", 0  ; $13
        .byte "JML", 0  ; $14
        .byte "JMP", 0  ; $15
        .byte "JSL", 0  ; $16
        .byte "JSR", 0  ; $17
        .byte "LDA", 0  ; $18
        .byte "LDX", 0  ; $19
        .byte "LDY", 0  ; $1A
        .byte "LSR", 0  ; $1B
        .byte "MVN", 0  ; $1C
        .byte "MVP", 0  ; $1D
        .byte "NOP", 0  ; $1E
        .byte "ORA", 0  ; $1F
        .byte "PEA", 0  ; $20
        .byte "PEI", 0  ; $21
        .byte "PHA", 0  ; $22
        .byte "PHB", 0  ; $23
        .byte "PHD", 0  ; $24
        .byte "PHK", 0  ; $25
        .byte "PHP", 0  ; $26
        .byte "PHX", 0  ; $27
        .byte "PHY", 0  ; $28
        .byte "PLA", 0  ; $29
        .byte "PLB", 0  ; $2A
        .byte "PLD", 0  ; $2B
        .byte "PLP", 0  ; $2C
        .byte "PLX", 0  ; $2D
        .byte "PLY", 0  ; $2E
        .byte "REP", 0  ; $2F
        .byte "ROL", 0  ; $30
        .byte "ROR", 0  ; $31
        .byte "RTI", 0  ; $32
        .byte "RTL", 0  ; $33
        .byte "RTS", 0  ; $34
        .byte "SBC", 0  ; $35
        .byte "SEC", 0  ; $36
        .byte "SED", 0  ; $37
        .byte "SEI", 0  ; $38
        .byte "SEP", 0  ; $39
        .byte "STA", 0  ; $3A
        .byte "STP", 0  ; $3B
        .byte "STX", 0  ; $3C
        .byte "STY", 0  ; $3D
        .byte "STZ", 0  ; $3E
        .byte "TAX", 0  ; $3F
        .byte "TAY", 0  ; $40
        .byte "TCD", 0  ; $41
        .byte "TCS", 0  ; $42
        .byte "TDC", 0  ; $43
        .byte "TRB", 0  ; $44
        .byte "TSB", 0  ; $45
        .byte "TSC", 0  ; $46
        .byte "TSX", 0  ; $47
        .byte "TXA", 0  ; $48
        .byte "TXS", 0  ; $49
        .byte "TXY", 0  ; $4A
        .byte "TYA", 0  ; $4B
        .byte "TYX", 0  ; $4C
        .byte "WAI", 0  ; $4D
        .byte "WDC", 0  ; $4E
        .byte "WDM", 0  ; $4F
        .byte "XBA", 0  ; $50
        .byte "XCE", 0  ; $51
        .byte "BCC", 0  ; $52
        .byte "BCS", 0  ; $53
        .byte "BEQ", 0  ; $54
        .byte "BMI", 0  ; $55
        .byte "BNE", 0  ; $56
        .byte "BPL", 0  ; $57
        .byte "BRA", 0  ; $58
        .byte "BVC", 0  ; $59
        .byte "BVS", 0  ; $5A
        .byte "BRL", 0  ; $5B
        .byte "PER", 0  ; $5C
        .dword 0        ; end of table

;;
; Opcode table, maps actual opcodes to Instr::xxx constants
;
opcode_instr:
        .byte Instr::BRK
        .byte Instr::ORA
        .byte Instr::COP
        .byte Instr::ORA
        .byte Instr::TSB
        .byte Instr::ORA
        .byte Instr::ASL
        .byte Instr::ORA
        .byte Instr::PHP
        .byte Instr::ORA
        .byte Instr::ASL
        .byte Instr::PHD
        .byte Instr::TSB
        .byte Instr::ORA
        .byte Instr::ASL
        .byte Instr::ORA
        .byte Instr::BPL
        .byte Instr::ORA
        .byte Instr::ORA
        .byte Instr::ORA
        .byte Instr::TRB
        .byte Instr::ORA
        .byte Instr::ASL
        .byte Instr::ORA
        .byte Instr::CLC
        .byte Instr::ORA
        .byte Instr::INC
        .byte Instr::TCS
        .byte Instr::TRB
        .byte Instr::ORA
        .byte Instr::ASL
        .byte Instr::ORA
        .byte Instr::JSR
        .byte Instr::AND
        .byte Instr::JSL
        .byte Instr::AND
        .byte Instr::BIT
        .byte Instr::AND
        .byte Instr::ROL
        .byte Instr::AND
        .byte Instr::PLP
        .byte Instr::AND
        .byte Instr::ROL
        .byte Instr::PLD
        .byte Instr::BIT
        .byte Instr::AND
        .byte Instr::ROL
        .byte Instr::AND
        .byte Instr::BMI
        .byte Instr::AND
        .byte Instr::AND
        .byte Instr::AND
        .byte Instr::BIT
        .byte Instr::AND
        .byte Instr::ROL
        .byte Instr::AND
        .byte Instr::SEC
        .byte Instr::AND
        .byte Instr::DEC
        .byte Instr::TSC
        .byte Instr::BIT
        .byte Instr::AND
        .byte Instr::ROL
        .byte Instr::AND
        .byte Instr::RTI
        .byte Instr::EOR
        .byte Instr::WDM
        .byte Instr::EOR
        .byte Instr::MVP
        .byte Instr::EOR
        .byte Instr::LSR
        .byte Instr::EOR
        .byte Instr::PHA
        .byte Instr::EOR
        .byte Instr::LSR
        .byte Instr::PHK
        .byte Instr::JMP
        .byte Instr::EOR
        .byte Instr::LSR
        .byte Instr::EOR
        .byte Instr::BVC
        .byte Instr::EOR
        .byte Instr::EOR
        .byte Instr::EOR
        .byte Instr::MVN
        .byte Instr::EOR
        .byte Instr::LSR
        .byte Instr::EOR
        .byte Instr::CLI
        .byte Instr::EOR
        .byte Instr::PHY
        .byte Instr::TCD
        .byte Instr::JMP
        .byte Instr::EOR
        .byte Instr::LSR
        .byte Instr::EOR
        .byte Instr::RTS
        .byte Instr::ADC
        .byte Instr::PER
        .byte Instr::ADC
        .byte Instr::STZ
        .byte Instr::ADC
        .byte Instr::ROR
        .byte Instr::ADC
        .byte Instr::PLA
        .byte Instr::ADC
        .byte Instr::ROR
        .byte Instr::RTL
        .byte Instr::JMP
        .byte Instr::ADC
        .byte Instr::ROR
        .byte Instr::ADC
        .byte Instr::BVS
        .byte Instr::ADC
        .byte Instr::ADC
        .byte Instr::ADC
        .byte Instr::STZ
        .byte Instr::ADC
        .byte Instr::ROR
        .byte Instr::ADC
        .byte Instr::SEI
        .byte Instr::ADC
        .byte Instr::PLY
        .byte Instr::TDC
        .byte Instr::JMP
        .byte Instr::ADC
        .byte Instr::ROR
        .byte Instr::ADC
        .byte Instr::BRA
        .byte Instr::STA
        .byte Instr::BRL
        .byte Instr::STA
        .byte Instr::STY
        .byte Instr::STA
        .byte Instr::STX
        .byte Instr::STA
        .byte Instr::DEY
        .byte Instr::BIT
        .byte Instr::TXA
        .byte Instr::PHB
        .byte Instr::STY
        .byte Instr::STA
        .byte Instr::STX
        .byte Instr::STA
        .byte Instr::BCC
        .byte Instr::STA
        .byte Instr::STA
        .byte Instr::STA
        .byte Instr::STY
        .byte Instr::STA
        .byte Instr::STX
        .byte Instr::STA
        .byte Instr::TYA
        .byte Instr::STA
        .byte Instr::TXS
        .byte Instr::TXY
        .byte Instr::STZ
        .byte Instr::STA
        .byte Instr::STZ
        .byte Instr::STA
        .byte Instr::LDY
        .byte Instr::LDA
        .byte Instr::LDX
        .byte Instr::LDA
        .byte Instr::LDY
        .byte Instr::LDA
        .byte Instr::LDX
        .byte Instr::LDA
        .byte Instr::TAY
        .byte Instr::LDA
        .byte Instr::TAX
        .byte Instr::PLB
        .byte Instr::LDY
        .byte Instr::LDA
        .byte Instr::LDX
        .byte Instr::LDA
        .byte Instr::BCS
        .byte Instr::LDA
        .byte Instr::LDA
        .byte Instr::LDA
        .byte Instr::LDY
        .byte Instr::LDA
        .byte Instr::LDX
        .byte Instr::LDA
        .byte Instr::CLV
        .byte Instr::LDA
        .byte Instr::TSX
        .byte Instr::TYX
        .byte Instr::LDY
        .byte Instr::LDA
        .byte Instr::LDX
        .byte Instr::LDA
        .byte Instr::CPY
        .byte Instr::CMP
        .byte Instr::REP
        .byte Instr::CMP
        .byte Instr::CPY
        .byte Instr::CMP
        .byte Instr::DEC
        .byte Instr::CMP
        .byte Instr::INY
        .byte Instr::CMP
        .byte Instr::DEX
        .byte Instr::WAI
        .byte Instr::CPY
        .byte Instr::CMP
        .byte Instr::DEC
        .byte Instr::CMP
        .byte Instr::BNE
        .byte Instr::CMP
        .byte Instr::CMP
        .byte Instr::CMP
        .byte Instr::PEI
        .byte Instr::CMP
        .byte Instr::DEC
        .byte Instr::CMP
        .byte Instr::CLD
        .byte Instr::CMP
        .byte Instr::PHX
        .byte Instr::STP
        .byte Instr::JML
        .byte Instr::CMP
        .byte Instr::DEC
        .byte Instr::CMP
        .byte Instr::CPX
        .byte Instr::SBC
        .byte Instr::SEP
        .byte Instr::SBC
        .byte Instr::CPX
        .byte Instr::SBC
        .byte Instr::INC
        .byte Instr::SBC
        .byte Instr::INX
        .byte Instr::SBC
        .byte Instr::NOP
        .byte Instr::XBA
        .byte Instr::CPX
        .byte Instr::SBC
        .byte Instr::INC
        .byte Instr::SBC
        .byte Instr::BEQ
        .byte Instr::SBC
        .byte Instr::SBC
        .byte Instr::SBC
        .byte Instr::PEA
        .byte Instr::SBC
        .byte Instr::INC
        .byte Instr::SBC
        .byte Instr::SED
        .byte Instr::SBC
        .byte Instr::PLX
        .byte Instr::XCE
        .byte Instr::JSR
        .byte Instr::SBC
        .byte Instr::INC
        .byte Instr::SBC

;;
; Addressing mode table, maps opcodes to their addressing modes
;
opcode_operands:
        .byte Operand::d
        .byte Operand::dxi
        .byte Operand::d
        .byte Operand::sr
        .byte Operand::d
        .byte Operand::d
        .byte Operand::d
        .byte Operand::dil
        .byte Operand::implied
        .byte Operand::immediate_m
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::al
        .byte Operand::pcr
        .byte Operand::dix
        .byte Operand::di
        .byte Operand::srix
        .byte Operand::d
        .byte Operand::dxx
        .byte Operand::dxx
        .byte Operand::dixl
        .byte Operand::implied
        .byte Operand::axy
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::absolute
        .byte Operand::axx
        .byte Operand::axx
        .byte Operand::alxx
        .byte Operand::absolute
        .byte Operand::dxi
        .byte Operand::al
        .byte Operand::sr
        .byte Operand::d
        .byte Operand::d
        .byte Operand::d
        .byte Operand::dil
        .byte Operand::implied
        .byte Operand::immediate_m
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::al
        .byte Operand::pcr
        .byte Operand::dix
        .byte Operand::di
        .byte Operand::srix
        .byte Operand::dxx
        .byte Operand::dxx
        .byte Operand::dxx
        .byte Operand::dixl
        .byte Operand::implied
        .byte Operand::axy
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::axx
        .byte Operand::axx
        .byte Operand::axx
        .byte Operand::alxx
        .byte Operand::implied
        .byte Operand::dxi
        .byte Operand::immediate8
        .byte Operand::sr
        .byte Operand::blockmove
        .byte Operand::d
        .byte Operand::d
        .byte Operand::dil
        .byte Operand::implied
        .byte Operand::immediate_m
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::al
        .byte Operand::pcr
        .byte Operand::dix
        .byte Operand::di
        .byte Operand::srix
        .byte Operand::blockmove
        .byte Operand::dxx
        .byte Operand::dxx
        .byte Operand::dixl
        .byte Operand::implied
        .byte Operand::axy
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::al
        .byte Operand::axx
        .byte Operand::axx
        .byte Operand::alxx
        .byte Operand::implied
        .byte Operand::dxi
        .byte Operand::pcrl
        .byte Operand::sr
        .byte Operand::d
        .byte Operand::d
        .byte Operand::d
        .byte Operand::dil
        .byte Operand::implied
        .byte Operand::immediate_m
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::ai
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::al
        .byte Operand::pcr
        .byte Operand::dix
        .byte Operand::di
        .byte Operand::srix
        .byte Operand::dxx
        .byte Operand::dxx
        .byte Operand::dxx
        .byte Operand::dixl
        .byte Operand::implied
        .byte Operand::axy
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::axi
        .byte Operand::axx
        .byte Operand::axx
        .byte Operand::alxx
        .byte Operand::pcr
        .byte Operand::dxi
        .byte Operand::pcrl
        .byte Operand::sr
        .byte Operand::d
        .byte Operand::d
        .byte Operand::d
        .byte Operand::dil
        .byte Operand::implied
        .byte Operand::immediate_m
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::al
        .byte Operand::pcr
        .byte Operand::dix
        .byte Operand::di
        .byte Operand::srix
        .byte Operand::dxx
        .byte Operand::dxx
        .byte Operand::dxy
        .byte Operand::dixl
        .byte Operand::implied
        .byte Operand::axy
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::absolute
        .byte Operand::axx
        .byte Operand::axx
        .byte Operand::alxx
        .byte Operand::immediate_x
        .byte Operand::dxi
        .byte Operand::immediate_x
        .byte Operand::sr
        .byte Operand::d
        .byte Operand::d
        .byte Operand::d
        .byte Operand::dil
        .byte Operand::implied
        .byte Operand::immediate_m
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::al
        .byte Operand::pcr
        .byte Operand::dix
        .byte Operand::di
        .byte Operand::srix
        .byte Operand::dxx
        .byte Operand::dxx
        .byte Operand::dxy
        .byte Operand::dixl
        .byte Operand::implied
        .byte Operand::axy
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::axx
        .byte Operand::axx
        .byte Operand::axy
        .byte Operand::alxx
        .byte Operand::immediate_x
        .byte Operand::dxi
        .byte Operand::immediate8
        .byte Operand::sr
        .byte Operand::d
        .byte Operand::d
        .byte Operand::d
        .byte Operand::dil
        .byte Operand::implied
        .byte Operand::immediate_m
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::al
        .byte Operand::pcr
        .byte Operand::dix
        .byte Operand::di
        .byte Operand::srix
        .byte Operand::d
        .byte Operand::dxx
        .byte Operand::dxx
        .byte Operand::dixl
        .byte Operand::implied
        .byte Operand::axy
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::ai
        .byte Operand::axx
        .byte Operand::axx
        .byte Operand::alxx
        .byte Operand::immediate_x
        .byte Operand::dxi
        .byte Operand::immediate8
        .byte Operand::sr
        .byte Operand::d
        .byte Operand::d
        .byte Operand::d
        .byte Operand::di
        .byte Operand::implied
        .byte Operand::immediate_m
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::absolute
        .byte Operand::al
        .byte Operand::pcr
        .byte Operand::dix
        .byte Operand::di
        .byte Operand::srix
        .byte Operand::immediate16
        .byte Operand::dxx
        .byte Operand::dxx
        .byte Operand::dixl
        .byte Operand::implied
        .byte Operand::axy
        .byte Operand::implied
        .byte Operand::implied
        .byte Operand::axi
        .byte Operand::axx
        .byte Operand::axx
        .byte Operand::alxx
