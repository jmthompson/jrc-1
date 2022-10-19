; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "ascii.inc"
        .include "console.inc"
        .include "memory.inc"
        .include "syscalls.inc"
        .include "syscall_macros.inc"

        .export mon_show_handles

        .import print_address
        .import print_hex
        .import print_spaces

        ; Memory manager internals
        .import mm_active_list, mm_free_list

        .segment "OSROM"

.proc mon_show_handles
        _PrintString active_msg
        lda   mm_active_list + 2
        pha
        lda   mm_active_list
        pha
        jsr   show_list
        _PrintString free_msg
        lda   mm_free_list + 2
        pha
        lda   mm_free_list
        pha
        jsr   show_list

        clc
        rts
.endproc

;;
; Display all handles in a list, with optionl size & range display
;
; Stack frame:
;
;     |-------------------------------------|
;  +1 | [2] Direct page register            |
;     |-------------------------------------|
;  +3 | [2] Return address                  |
;     |-------------------------------------|
;  +5 | [4] Pointer to first handle in list |
;     |-------------------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc show_list

BEGIN_PARAMS
  PARAM   l_end,  .dword
  PARAM   s_dreg, .word
  PARAM   s_ret,  .word
  PARAM   i_list, .dword
END_PARAMS

@lsize := s_dreg - 1
@psize := 4

        phd
        tsc
        sec
        sbcw    #@lsize
        tcs
        tcd

@loop:  lda     i_list
        ora     i_list + 2
        bne     :+
        brl     @end

        ; Line format: "xx/xxxx    xx/xxxx - xx/xxxx [xxxxxx]"

:       lda     i_list + 2
        pha
        lda     i_list
        pha
        jsl     print_address
        shortm
        lda     #' '
        _PrintChar
        lda     #' '
        _PrintChar
        lda     #' '
        _PrintChar
        longm
        ldyw    #Handle::Start + 2
        lda     [i_list],y
        pha
        dey
        dey
        lda     [i_list],y
        pha
        jsl     print_address
        shortm
        lda     #' '
        _PrintChar
        lda     #'-'
        _PrintChar
        lda     #' '
        _PrintChar
        longm
        lda     [i_list]
        sta     l_end
        ldyw    #Handle::Start + 2
        lda     [i_list],y
        sta     l_end + 2
        ldyw    #Handle::Size
        lda     [i_list],y
        clc
        adc     l_end
        sta     l_end
        iny
        iny
        lda     [i_list],y
        adc     l_end + 2
        sta     l_end + 2
        lda     l_end
        sec
        sbcw    #1
        tax
        lda     l_end + 2
        sbcw    #0
        pha
        phx
        jsl     print_address
        shortm
        lda     #' '
        _PrintChar
        lda     #'['
        _PrintChar
        ldyw    #Handle::Size + 2
        lda     [i_list],y
        jsl     print_hex
        dey
        lda     [i_list],y
        jsl     print_hex
        dey
        lda     [i_list],y
        jsl     print_hex
        lda     #']'
        _PrintChar
        longm
@next:  ldaw    #CR
        _PrintChar
        ldaw    #LF
        _PrintChar
        ldyw    #Handle::Next + 2
        lda     [i_list],y
        tax
        dey
        dey
        lda     [i_list],y
        sta     i_list
        stx     i_list + 2
        brl     @loop
@end:   ldaw    #CR
        _PrintChar
        ldaw    #LF
        _PrintChar
        lda     s_dreg,s
        sta     s_dreg + @psize,s
        lda     s_ret,s
        sta     s_ret + @psize,s
        tsc
        clc
        adcw    #@psize + @lsize
        tcs
        pld
        rts
.endproc

active_msg:   .byte "++ Active Handles ++", CR, LF, CR, LF, 0
free_msg:     .byte "++ Free Handles ++", CR, LF, CR, LF, 0
