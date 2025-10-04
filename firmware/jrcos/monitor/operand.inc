        .global instr_lengths, operand_error, parse_operand

;;
; Operand types as returned by parse_operand
;
.struct Operand
        immediate8  .byte   ; $00
        immediate16 .byte   ; $01
        absolute    .byte   ; $02
        al          .byte   ; $03
        d           .byte   ; $04
        implied     .byte   ; $05
        dix         .byte   ; $06
        dixl        .byte   ; $07
        dxi         .byte   ; $08
        dxx         .byte   ; $09
        dxy         .byte   ; $0A
        axx         .byte   ; $0B
        alxx        .byte   ; $0C
        axy         .byte   ; $0D
        pcr         .byte   ; $0E
        pcrl        .byte   ; $0F
        ai          .byte   ; $10
        di          .byte   ; $11
        dil         .byte   ; $12
        axi         .byte   ; $13
        sr          .byte   ; $14
        srix        .byte   ; $15
        blockmove   .byte   ; $16
        immediate_x .byte   ; $17
        immediate_m .byte   ; $18
.endstruct
