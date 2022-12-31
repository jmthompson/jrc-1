; * (C) 2021 Joshua M. Thompson *
; *******************************

;;
; This file defines the direct page locations for the BIOS and JR/OS
;
; Currently this file has a lot of locations that are only used by one
; specific routine and could be consolidated to save space.
;;

        .exportzp   ptr
        .exportzp   tmp

        .exportzp   lastblk
        .exportzp   blkno
        .exportzp   errcnt
        .exportzp   crc
        .exportzp   xmptr
        .exportzp   xmeofp
        .exportzp   retry

        .segment "ZEROPAGE"

; Generic temp locations, used lots of places. VERY temporary!
ptr:            .res    4
tmp:            .res    2

; Xmodem routines variables
lastblk:        .res    1   ; flag for last block
blkno:          .res    1   ; block number 
errcnt:         .res    1   ; error counter 10 is the limit
crc:            .res    2   ; CRC
xmptr:          .res    3   ; data pointer (two byte variable)
xmeofp:         .res    3   ; end of file address pointer (2 bytes)
retry:          .res    2   ; retry counter 
