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
xmptr:      .res    3   ; data pointer (two byte variable)
xmeofp:     .res    3   ; end of file address pointer (2 bytes)
retry:      .res    2   ; retry counter 
ibuffp:     .res    4
cmd:        .res    1
start_loc:  .res    3
end_loc:    .res    3
row_end:    .res    1
