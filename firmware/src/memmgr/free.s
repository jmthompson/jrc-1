; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/memory.inc"
        .include    "kernel/syscall_macros.inc"

        .export     mm_free_internal

        .import     mm_add_to_free
        .import     mm_compact
        .import     mm_find_handle
        .import     mm_remove_from_active

        .segment    "OSROM"

;;
; Deallocate a memory block
;
; Stack frame (top to bottom):
;
; |------------------------------|
; | [4] Pointer to block to free |
; |------------------------------|
;
; On exit:
;
; C,Y trashed
; c=0 on success
; c=1 on error
;
.proc mm_free_internal

BEGIN_PARAMS
  PARAM s_dreg, .word
  PARAM s_ret, .word
  PARAM i_ptr, .dword
END_PARAMS

@lsize := s_dreg - 1
@psize := 4

        phd
        tsc
        tcd

        pha
        pha
        lda     i_ptr + 2
        pha
        lda     i_ptr
        pha
        jsr     mm_find_handle
        pla
        sta     i_ptr
        pla
        sta     i_ptr + 2
        ora     i_ptr
        beq     @exit
        lda     i_ptr + 2
        pha
        lda     i_ptr
        pha
        jsr     mm_remove_from_active
        lda     i_ptr + 2
        pha
        lda     i_ptr
        pha
        jsr     mm_add_to_free
        jsr     mm_compact
@exit:  lda     s_dreg,s
        sta     s_dreg + @psize,s
        lda     s_ret,s
        sta     s_ret + @psize,s
        tsc
        clc
        adcw    #@psize + @lsize
        tcs
        pld
        ldaw    #0
        clc
        rts
.endproc
