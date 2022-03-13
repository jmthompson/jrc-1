; * (C) 2021 Joshua M. Thompson *
; *******************************

;;
; This file defines the direct page locations for the BIOS and JR/OS
;
; Currently this file has a lot of locations that are only used by one
; specific routine and could be consolidated to save space.
;;

        .exportzp   params
        .exportzp   ptr
        .exportzp   tmp
        .exportzp   rxa_rdi
        .exportzp   rxa_wri
        .exportzp   txa_rdi
        .exportzp   txa_wri
        .exportzp   rxb_rdi
        .exportzp   rxb_wri
        .exportzp   txb_rdi
        .exportzp   txb_wri
        .exportzp   txa_on
        .exportzp   txb_on
        .exportzp   devicenr
        .exportzp   device
        .exportzp   device_params
        .exportzp   blkbuff
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
        .exportzp   ibuffsz
        .exportzp   jiffies
        .exportzp   lastblk
        .exportzp   blkno
        .exportzp   errcnt
        .exportzp   crc
        .exportzp   xmptr
        .exportzp   xmeofp
        .exportzp   retry

        .segment "ZEROPAGE"

; API call parameters
params:         .res    4

; Generic temp locations, used lots of places. VERY temporary!
ptr:            .res    4
tmp:            .res    2

; Serial buffer r/w indices
rxa_rdi: .res   1
rxa_wri: .res   1
txa_rdi: .res   1
txa_wri: .res   1
rxb_rdi: .res   1
rxb_wri: .res   1
txb_rdi: .res   1
txb_wri: .res   1

; UART tx status
txa_on: .res    1
txb_on: .res    1

; Current device number
devicenr:       .res    2
; Pointer to current device
device:         .res    4
; Device params block
device_params:  .res    4

; JR/OS
blkbuff:        .res    4

; Disassembler variables
mwidth:         .res    1
xwidth:         .res    1
opcode:         .res    1
am:             .res    1
len:            .res    1

; System nonitor variables
cmd:            .res    1
arg:            .res    4
maxhex:         .res    1
address:        .res    3
start_loc:      .res    3
end_loc:        .res    3
row_end:        .res    1
ibuffp:         .res    3
ibuffsz:        .res    1

; VIA driver variables
jiffies:        .res    4

; Xmodem routines variables
lastblk:        .res    1   ; flag for last block
blkno:          .res    1   ; block number 
errcnt:         .res    1   ; error counter 10 is the limit
crc:            .res    2   ; CRC
xmptr:          .res    3   ; data pointer (two byte variable)
xmeofp:         .res    3   ; end of file address pointer (2 bytes)
retry:          .res    2   ; retry counter 
