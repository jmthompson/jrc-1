        .global   is_hex_digit, is_whitespace
        .global   next_token
        .global   parse_address, parse_hex, print_error, skip_whitespace

;;
; Token types as returned by next_token
;
.struct Token
        unknown   .byte     ; $00
        eol       .byte     ; $01
        pound     .byte     ; $02
        lparen    .byte     ; $03
        rparen    .byte     ; $04
        lbracket  .byte     ; $05
        rbracket  .byte     ; $06
        comma     .byte     ; $07
        xreg      .byte     ; $08
        yreg      .byte     ; $09
        sreg      .byte     ; $0A
        const8    .byte     ; $0B
        const16   .byte     ; $0C
        const24   .byte     ; $00
.endstruct


