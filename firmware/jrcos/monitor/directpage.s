;;
; System monitor data locations
;

        .exportzp   cmd, end_loc, ibuffp, row_end, start_loc
        .exportzp   blkno, crc, errcnt, lastblk, retry, xmeofp, xmptr

        .segment    "ZEROPAGE"

; Xmodem routines variables
lastblk:    .res    1   ; flag for last block
blkno:      .res    1   ; block number 
errcnt:     .res    1   ; error counter 10 is the limit
crc:        .res    2   ; CRC
xmptr:      .res    4   ; data pointer
xmeofp:     .res    4   ; end of file address pointer
retry:      .res    2   ; retry counter 
ibuffp:     .res    4
cmd:        .res    1
start_loc:  .res    4
end_loc:    .res    4
row_end:    .res    1
