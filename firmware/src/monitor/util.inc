        .importzp ibuffp
        .importzp ibuffsz

; Get a single character
.macro  getc
        lda     [ibuffp]
.endmacro

; Advance to the next character
.macro  nextc
        inc      ibuffp
.endmacro

