; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "console.inc"
        .include "syscalls.inc"
        .include "kernel/syscall_macros.inc"

        .export print_hex
        .export print_address

        .segment "OSROM"

;;
; Print the contents of the accumulator as a two-digit hexadecimal number.
;
; On exit:
;
; All registers preserved
;
print_hex:
        pha
        pha
        lsr
        lsr
        lsr
        lsr
        jsr     @digit
        pla
        and     #$0F
        jsr     @digit
        pla
        rtl
@digit: and     #$0F
        ora     #'0'
        cmp     #'9'+1
        blt     :+
        adc     #6
:       _PrintChar
        rts

;;
; Print a 24-bit address in th form XX/YYZZ.
;
; This function requires 16-bit mode on entry.
;
; Stack frame (top to bottom):
;
; |----------------------|
; | [4] Address to print |
; |----------------------|
;
; On exit:
; C,Y trashed
; c=0 on success
; c=1 on error
;
.proc print_address

BEGIN_PARAMS
  PARAM s_dreg, .word
  PARAM s_ret,  .faraddr
  PARAM i_addr, .dword
END_PARAMS

@lsize := s_dreg - 1
@psize := 4

        phd
        tsc
        tcd

        shortmx
        lda   i_addr + 2
        jsl   print_hex
        lda   #'/'
        _PrintChar
        lda   i_addr + 1
        jsl   print_hex
        lda   i_addr
        jsl   print_hex

        lda   s_ret + 2,s
        sta   s_ret + 2 + @psize,s
        longmx
        lda   s_ret,s
        sta   s_ret + @psize,s
        lda   s_dreg,s
        sta   s_dreg + @psize,s
        tsc
        clc
        adcw    #@psize + @lsize
        tcs
        pld
        rtl
.endproc
