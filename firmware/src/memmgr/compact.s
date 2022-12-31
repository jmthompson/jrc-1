; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/memory.inc"
        .include    "kernel/syscall_macros.inc"

        .export     mm_compact

        .import     mm_dispose_handle
        .import     mm_remove_from_free

        .import     mm_free_list

        .segment    "OSROM"

;;
; Attempt to consolidate consecutive blocks in the free list.
;
; On exit:
;
; C,Y trashed
; c=0 on success
; c=1 on error
;
.proc mm_compact

BEGIN_PARAMS
  PARAM l_curr, .dword
  PARAM l_next, .dword
  PARAM l_end, .dword
  PARAM s_dreg, .word
  PARAM s_reg, .word
END_PARAMS

@lsize := s_dreg - 1
@psize := 0

        phd
        tsc
        sec
        sbcw    #@lsize
        tcs
        tcd

        lda     mm_free_list
        sta     l_curr
        lda     mm_free_list + 2
        sta     l_curr + 2
@loop:  lda     l_curr 
        ora     l_curr + 2
        beq     @done               ; abort if at end of list
        ldyw    #Handle::Next
        lda     [l_curr],y
        sta     l_next
        iny
        iny
        lda     [l_curr],y
        sta     l_next + 2
        ora     l_next
        beq     @done             ; Stop if there is no block after this one

        ; Calculate the end address of the current block

        lda     [l_curr]
        sta     l_end
        ldyw    #Handle::Start + 2
        lda     [l_curr],y
        sta     l_end + 2
        iny
        iny
        lda     [l_curr],y
        clc
        adc     l_end
        sta     l_end
        iny
        iny
        lda     [l_curr],y
        adc     l_end + 2
        sta     l_end + 2

        ; Check if the next block is directly adjacent to this one

        lda     [l_next]
        cmp     l_end
        bne     @next
        ldyw    #Handle::Start + 2
        lda     [l_next],y
        cmp     l_end + 2
        bne     @next

        ; Add next block's size to this one

        ldyw    #Handle::Size
        lda     [l_curr],y
        clc
        adc     [l_next],y
        sta     [l_curr],y
        iny
        iny
        lda     [l_curr],y
        adc     [l_next],y
        sta     [l_curr],y

        ; Dispose of l_next and remove it from the free list.

        ldyw    #Handle::Next
        lda     [l_next],y
        sta     [l_curr],y
        iny
        iny
        lda     [l_next],y
        sta     [l_curr],y
        lda     l_next + 2
        pha
        lda     l_next
        pha
        jsr     mm_dispose_handle
        bra     @loop             ; try again in case new next block can be consolidated
@next:  ldyw    #Handle::Next + 2
        lda     [l_curr],y
        tax
        dey
        dey
        lda     [l_curr],y
        sta     l_curr
        stx     l_curr + 2
        bra     @loop
@done:  tsc
        clc
        adcw    #@psize + @lsize
        tcs
        pld
        clc
        rts
.endproc
