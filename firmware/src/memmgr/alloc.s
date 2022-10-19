; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .include    "common.inc"
        .include    "errors.inc"
        .include    "memory.inc"
        .include    "syscall_macros.inc"

        .export     mm_alloc_internal

        .import     mm_alloc_handle
        .import     mm_add_to_active
        .import     mm_add_to_free
        .import     mm_check_low_water_mark
        .import     mm_in_alloc
        .import     mm_free_list
        .import     mm_remove_from_free

        .segment    "OSROM"

;;
; Allocate memory based on the given parameters, and returns the resulting handle on success.
;
; Stack frame (top to bottm):
;
; |---------------------------------|
; | [4] Space for returned pointer  |
; |---------------------------------|
; | [4] Number of bytes to allocate |
; |---------------------------------|
; | [2] Attributes word             |
; |---------------------------------|
; | [2] Owner ID                    |
; |---------------------------------|
;
; On exit:
; C,Y trashed
; c=0 on success
; c=1 on error
;
.proc mm_alloc_internal

BEGIN_PARAMS
  ; best handle match so far, along with its calculated end address
  PARAM l_best_handle,  .dword
  PARAM l_bh_end,       .dword
  ; The start and end address of the block we intend to allocate from
  ; l_best_handle
  PARAM l_best_start,   .dword
  PARAM l_best_end,     .dword
  ; current handle being tested, along with its calculated and address
  PARAM l_curr_handle,  .dword
  PARAM l_ch_end,       .dword

  ; the allocation currently being tested
  PARAM l_try_start,    .dword
  PARAM l_try_end,      .dword

  ; stack frame
  PARAM s_dreg,         .word
  PARAM s_ret,          .word

  ; Parameters from caller
  PARAM i_owner,        .word
  PARAM i_attr,         .word
  PARAM i_size,         .dword

  ; Result to caller
  PARAM o_handle,       .word
END_PARAMS

@lsize  := s_dreg - 1
@psize  := 8

; enter
        phd
        tsc
        sec
        sbcw    #@lsize
        tcs
        tcd

; Round allocation up to the nearest MM_MIN_ALLOCATION bytes
        lda     i_size
        andw    #MM_MIN_ALLOCATION-1
        beq     @check_page_cross
        lda     i_size
        andw    #(~(MM_MIN_ALLOCATION-1))&$FFFF
        clc
        adcw    #MM_MIN_ALLOCATION
        sta     i_size
        lda     i_size + 2
        adcw    #0
        sta     i_size + 2

; If no page crossing bit is set make sure the request fits in a page
@check_page_cross:
        lda     i_attr
        andw    #MM_ATTR_SINGLE_PAGE
        beq     @check_bank_cross
        lda     i_size
        andw    #$FF
        beq     @check_bank_cross
        brl     @done

; If no bank crossing bit is set make sure the request fits in a bank
@check_bank_cross:
        lda     i_attr
        andw    #MM_ATTR_SINGLE_BANK
        beq     @prep
        lda     i_size + 2
        beq     @prep
        brl     @done

; Get ready to start walking the free handle list
@prep:  stz     l_best_handle
        stz     l_best_handle + 2
        lda     mm_free_list
        sta     l_curr_handle
        lda     mm_free_list + 2
        sta     l_curr_handle + 2

; Try to construct a suitable allocation inside l_curr_handle
@try_handle:
        lda     l_curr_handle
        ora     l_curr_handle + 2
        bne     :+
        brl     @done
:       ldyw    #Handle::Start
        lda     [l_curr_handle],y
        sta     l_try_start
        sta     l_ch_end
        iny
        iny
        lda     [l_curr_handle],y
        sta     l_try_start + 2
        sta     l_ch_end + 2
        ldyw    #Handle::Size
        lda     [l_curr_handle],y
        clc
        adc     l_ch_end
        sta     l_ch_end
        iny
        iny
        lda     [l_curr_handle],y
        adc     l_ch_end + 2
        sta     l_ch_end + 2

; If bank $00 is requested make sure this handle is bank $00.
        ldyw    #Handle::Start + 2
        lda     [l_curr_handle],y
        tax                           ; save upper word (bank byte)
        lda     i_attr
        andw    #MM_ATTR_BANK_ZERO    ; did caller request bank $00?
        bne     :+
        cpxw    #0
        bne     @check_bank_align
        brl     @next_handle          ; handle is bank $00 but bank $00 not requested
:       cpxw    #0
        beq     @check_bank_align
        brl     @next_handle          ; handle is not bank $00 but bank $00 was requested

; Round up to bank boundary if necessary
@check_bank_align:
        ldaw    i_attr
        andw    #MM_ATTR_BANK_ALIGN
        beq     @check_page_align
        lda     l_try_start
        beq     @check_page_align     ; only care if low word isn't zero
        ldaw    #0
        sta     l_try_start
        lda     l_try_start + 2
        inc
        sta     l_try_start + 2

; Round up to page boundary if necessary
@check_page_align:
        ldaw    i_attr
        andw    #MM_ATTR_PAGE_ALIGN
        beq     @check_end
        lda     l_try_start
        andw    #$00FF
        beq     @check_end
        lda     l_try_start
        andw    #$FF00
        clc
        adcw    #1
        sta     l_try_start
        lda     l_try_start + 2
        adcw    #0
        sta     l_try_start + 2

; At this point we have a l_try_start that meets the caller's requirements.
; Calculate l_try_end, and make sure it's still within l_curr_handle.

@check_end:
        lda     l_try_start
        clc
        adc     i_size
        sta     l_try_end
        lda     l_try_start + 2
        adc     i_size + 2
        sta     l_try_end + 2
        cmp     l_ch_end + 2
        blt     @check_match
        beq     :+
        bra     @next_handle
:       lda     l_try_end
        cmp     l_ch_end
        beq     @check_match
        bge     @next_handle

; We know l_curr_handle can contain the requested block now. So now check to see
; if it is a better fit than l_best_handle. For now this is determined by just
; making the smallest handle the best one.

@check_match:
        lda     l_best_handle
        ora     l_best_handle + 2
        beq     @save_match

        ldyw    #Handle::Size + 2
        lda     [l_best_handle],y
        cmp     [l_curr_handle],y    ; compare upper words
        blt     @next_handle        ; if upper word < go to next handle
        beq     :+                  ; if upper word == check lower word
        bra     @save_match         ; upper word is > so use this handle
:       dey
        dey
        lda     [l_best_handle],y
        cmp     [l_curr_handle],y    ; compare lower words
        blt     @next_handle        ; if lower word < go to next handle
        beq     @next_handle        ; if lower word == go to next handle

@save_match:
        lda     l_curr_handle
        sta     l_best_handle
        lda     l_curr_handle + 2
        sta     l_best_handle + 2
        lda     l_ch_end
        sta     l_bh_end
        lda     l_ch_end + 2
        sta     l_bh_end + 2
        lda     l_try_start
        sta     l_best_start
        lda     l_try_start + 2
        sta     l_best_start + 2
        lda     l_try_end
        sta     l_best_end
        lda     l_try_end + 2
        sta     l_best_end + 2

@next_handle:
        ldyw    #Handle::Next
        lda     [l_curr_handle],y
        tax
        iny
        iny
        lda     [l_curr_handle],y
        sta     l_curr_handle + 2
        stx     l_curr_handle
        brl     @try_handle

@done:  lda     l_best_handle
        ora     l_best_handle + 2
        bne     :+
        
; If no handles matched return ERR_NO_MEMORY
        stz     o_handle
        stz     o_handle + 2
        brl     @exit

; Remove l_best_handle from the free handle list and get
; ready to return it to the caller.
:       lda     l_best_handle + 2
        pha
        lda     l_best_handle
        pha
        jsr     mm_remove_from_free
        lda     l_best_handle
        sta     o_handle
        lda     l_best_handle + 2
        sta     o_handle + 2

; Now, check to see if l_best_start == l_best_handle.Start.
        lda     [l_best_handle]
        cmp     l_best_start
        bne     @split_front
        ldyw    #Handle::Start + 2
        lda     [l_best_handle],y
        cmp     l_best_start + 2
        beq     @check_back

; new block starts after the start of l_best_handle, so allocate a
; new free space handle to cover that unused space.
@split_front:
        pha
        pha
        ldyw    #Handle::Start + 2
        lda     [l_best_handle],y
        pha                         ; start (hi)
        lda     [l_best_handle]
        pha                         ; start (lo)
        lda     l_best_start
        sec
        sbc     [l_best_handle]
        tax
        lda     l_best_start + 2
        sbc     [l_best_handle],y
        pha                         ; size (hi)
        phx                         ; size (io)
        pea     MM_OWNER_SYSTEM     ; owner id
        jsr     mm_alloc_handle
        bcs     @abort
        jsr     mm_add_to_free
        bra     @check_back
@abort: pla
        pla
        stz     o_handle
        stz     o_handle + 2
        lda     l_best_handle + 2
        pha
        lda     l_best_handle
        pha
        jsr     mm_add_to_free      ; restore free handle
        brl     @exit

; Same check as above, but now checking the end of the allocation vs
; the end of l_best_handle.
@check_back:
        lda     l_bh_end
        cmp     l_best_end
        bne     @split_back
        lda     l_bh_end + 2
        cmp     l_best_end + 2
        beq     @mark_active

@split_back:
        pha
        pha
        lda     l_best_end + 2
        pha                         ; start (hi)
        lda     l_best_end
        pha                         ; start (lo)
        lda     l_bh_end
        sec
        sbc     l_best_end
        tax
        lda     l_bh_end + 2
        sbc     l_best_end + 2
        pha                         ; size (hi)
        phx                         ; size (io)
        pea     0                   ; owner id
        jsr     mm_alloc_handle
        bcs     @abort
        jsr     mm_add_to_free

; Set the start/size/owner on o_handle and add it to the active list
@mark_active:
        lda     l_best_start
        sta     [o_handle]
        ldyw    #Handle::Start + 2
        lda     l_best_start + 2
        sta     [o_handle],y
        iny
        iny
        lda     i_size
        sta     [o_handle],y
        iny
        iny
        lda     i_size + 2
        sta     [o_handle],y
        iny
        iny
        lda     i_owner
        sta     [o_handle],y
        lda     o_handle + 2
        pha
        lda     o_handle
        pha
        jsr     mm_add_to_active
@exit:  lda     s_dreg,s
        sta     s_dreg + @psize,s
        lda     s_ret,s
        sta     s_ret + @psize,s
        tsc
        clc
        adcw    #@psize + @lsize
        tcs
        lda     o_handle
        ora     o_handle
        beq     @oom
        ldyw    #Handle::Start + 2
        lda     [o_handle],y
        tax
        lda     [o_handle]
        sta     o_handle
        stx     o_handle + 2
        pld
        ldaw    #$8000
        tsb     mm_in_alloc
        bne     :+
        jsr     mm_check_low_water_mark
        stz     mm_in_alloc
:       ldaw    #0
        clc
        rts
@oom:   pld
        ldaw    #ERR_OUT_OF_MEMORY
        sec
        rts
.endproc
