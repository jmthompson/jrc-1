;;
; System monitor data locations
;

        .exportzp   am, address, arg, cmd, end_loc, ibuffp, len, mwidth, opcode, row_end, start_loc, xwidth

        .segment    "ZEROPAGE"

ibuffp:     .res    4
mwidth:     .res    1
xwidth:     .res    1
opcode:     .res    1
am:         .res    1
len:        .res    1
cmd:        .res    1
arg:        .res    4
address:    .res    3
start_loc:  .res    3
end_loc:    .res    3
row_end:    .res    1
