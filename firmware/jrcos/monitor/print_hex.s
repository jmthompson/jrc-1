; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

          .include  "common.inc"
          .include  "kernel/console.inc"
          .include  "stack.inc"

          .export   print_hex
          .export   print_address

          .segment  "OSROM"

;;
; Print the contents of the accumulator as a two-digit hexadecimal number.
;
; On exit:
;
; All registers preserved
;
.proc print_hex
          pha
          pha
          lsr
          lsr
          lsr
          lsr
          jsr       @digit
          pla
          and       #$0F
          jsr       @digit
          pla
          rtl
@digit:   and       #$0F
          ora       #'0'
          cmp       #'9'+1
          blt       :+
          adc       #6
:         _kputc
          rts
.endproc

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
          _BeginDirectPage
          _StackFrameRTL
          _Param32  i_addr
          _EndDirectPage

          _SetupDirectPage
          shortmx
          lda       i_addr + 2
          jsl       print_hex
          lda       #'/'
          _kputc
          lda       i_addr + 1
          jsl       print_hex
          lda       i_addr
          jsl       print_hex

          longmx
          _RemoveParams
          pld
          rtl
.endproc
