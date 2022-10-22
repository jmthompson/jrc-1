;;
; System monitor data locations
;

        .export     ibuff, IBUFFSZ

        .segment "BSS"

IBUFFSZ = 256

        .align  256
ibuff:  .res    IBUFFSZ
