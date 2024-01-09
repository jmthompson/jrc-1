;;
; System monitor data locations
;

                .exportzp       cmd, end_loc, ibuffp, row_end, start_loc
                .exportzp       blkno, crc, errcnt, lastblk, retry, xmeofp, xmptr

                .section        "ZEROPAGE"

; Xmodem routines variables
lastblk:        .space          1               ; flag for last block
blkno:          .space          1               ; block number
errcnt:         .space          1               ; error counter 10 is the limit
crc:            .space          2               ; CRC
xmptr:          .space          3               ; data pointer (two byte variable)
xmeofp:         .space          3               ; end of file address pointer (2 bytes)
retry:          .space          2               ; retry counter
ibuffp:         .space          4
cmd:            .space          1
start_loc:      .space          3
end_loc:        .space          3
row_end:        .space          1
