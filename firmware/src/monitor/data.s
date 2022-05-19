;;
; System monitor data locations
;

        .exportzp   mwidth
        .exportzp   xwidth
        .exportzp   opcode
        .exportzp   am
        .exportzp   len
        .exportzp   cmd
        .exportzp   arg
        .exportzp   maxhex
        .exportzp   address
        .exportzp   start_loc
        .exportzp   end_loc
        .exportzp   row_end
        .exportzp   ibuffp

        .export     ibuff
        .export     IBUFFSZ

        .segment    "ZEROPAGE"

; System nonitor variables
ibuffp:         .res    4
mwidth:         .res    1
xwidth:         .res    1
opcode:         .res    1
am:             .res    1
len:            .res    1
cmd:            .res    1
arg:            .res    4
maxhex:         .res    1
address:        .res    3
start_loc:      .res    3
end_loc:        .res    3
row_end:        .res    1

        .segment "SYSDATA"

IBUFFSZ = 256

        .align  256
ibuff:  .res    IBUFFSZ

