;;
; System monitor data locations
;

        .exportzp   cmd, end_loc, ibuffp, row_end, start_loc

        .segment    "ZEROPAGE"

ibuffp:     .res    4
cmd:        .res    1
start_loc:  .res    3
end_loc:    .res    3
row_end:    .res    1
