
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/memory.inc"
        .include    "kernel/syscall_macros.inc"

        .export     mm_alloc_handle
        .export     mm_check_low_water_mark
        .export     mm_dispose_handle
        .export     mm_create_handle_list
        .export     mm_find_handle
        .export     mm_add_to_active
        .export     mm_remove_from_active
        .export     mm_add_to_free
        .export     mm_remove_from_free

        .import     mm_active_list
        .import     mm_alloc_internal
        .import     mm_alloc_size
        .import     mm_free_list
        .import     mm_inactive_list
        .import     mm_low_water_mark
        .import     mm_num_inactive

        .import     multiply_8x8
        .importzp   ptr

        .segment    "OSROM"

;;
; Allocate a new handle from the inactive list and return it.
;
; Stack frame (top to bottm):
;
; |---------------------------------|
; | [4] Space for returned handle   |
; |---------------------------------|
; | [4] Handle start address        |
; |---------------------------------|
; | [4] Handle size                 |
; |---------------------------------|
; | [2] Owner ID                    |
; |---------------------------------|
;
; On exit:
;
; C,Y trashed
; c=0 on success
; c=1 on error
; New handle on stack
;
.proc mm_alloc_handle

BEGIN_PARAMS
  PARAM s_dreg,     .word
  PARAM s_ret,      .word
  PARAM i_owner_id, .word
  PARAM i_size,     .dword
  PARAM i_start,    .dword
  PARAM o_handle,   .dword
END_PARAMS

@lsize  :=  s_dreg - 1
@psize  :=  10

        phd
        tsc
        tcd

        lda   mm_inactive_list
        sta   o_handle
        lda   mm_inactive_list + 2
        sta   o_handle + 2
        ora   o_handle
        beq   @exit

        ldyw  #Handle::Next
        lda   [o_handle],y
        sta   mm_inactive_list    ; Disconnect this handle from the inactive list
        iny
        iny
        lda   [o_handle],y
        sta   mm_inactive_list + 2
        dec   mm_num_inactive
        lda   i_start
        sta   [o_handle]
        iny
        iny
        ldyw  #Handle::Start + 2
        lda   i_start + 2
        sta   [o_handle],y
        iny
        iny
        lda   i_size
        sta   [o_handle],y
        iny
        iny
        lda   i_size + 2
        sta   [o_handle],y
        iny
        iny
        lda   i_owner_id
        sta   [o_handle],y
        iny
        iny
        ldaw  #0
        sta   [o_handle],y     ; reserved space
        iny
        iny
        sta   [o_handle],y     ; next handle (lo)
        iny
        iny
        sta   [o_handle],y     ; next handle (hi)
@exit:  lda   s_dreg,s
        sta   s_dreg + @psize,s
        lda   s_ret,s
        sta   s_ret + @psize,s
        tsc
        clc
        adcw  #@psize + @lsize
        tcs
        lda   o_handle
        ora   o_handle + 2
        beq   :+
        pld
        clc
        rts
:       pld
        ldaw  #ERR_OUT_OF_MEMORY
        sec
        rts
.endproc

;; Dispose of a handle by adding it to the inactive handle list
;
; Stack frame (top to bottm):
;
; |---------------------------|
; | [4] Handle to be disposed |
; |---------------------------|
;
; On exit:
;
; C,Y trashed
;
.proc mm_dispose_handle

BEGIN_PARAMS
  PARAM s_dreg,     .word
  PARAM s_ret,      .word
  PARAM i_handle,   .dword
END_PARAMS

@lsize  :=  s_dreg - 1
@psize  :=  4

        phd
        tsc
        tcd
        ldyw  #Handle::Next
        lda   mm_inactive_list
        sta   [i_handle],y
        iny
        iny
        lda   mm_inactive_list + 2
        sta   [i_handle],y
        lda   i_handle
        sta   mm_inactive_list
        lda   i_handle + 2
        sta   mm_inactive_list + 2
        inc   mm_num_inactive
        lda   s_dreg,s
        sta   s_dreg + @psize,s
        lda   s_ret,s
        sta   s_ret + @psize,s
        tsc
        clc
        adcw    #@psize
        tcs
        pld
        rts
.endproc

;;
; Build a linked list of handles from a given block of memory
;
; Stack frame (top to bottm):
;
; |---------------------------------|
; | [4] Pointer to current head     |
; |---------------------------------|
; | [4] Pointer to memory block     |
; |---------------------------------|
; | [2] Number of handles to make   |
; |---------------------------------|
;
; On exit:
;
; C,X,Y trashed
; Memory area contains linked list of handles
;
.proc mm_create_handle_list

BEGIN_PARAMS
  PARAM s_dreg,   .word
  PARAM s_ret,    .word
  PARAM i_count,  .word
  PARAM i_ptr,    .dword
  PARAM i_head,   .dword
END_PARAMS

@lsize  :=  s_dreg - 1
@psize  :=  10

        phd
        tsc
        tcd
@build: dec     i_count
        beq     @last
        ldyw    #Handle::Next
        lda     i_ptr
        clc
        adcw    #MM_HANDLE_SIZE
        sta     [i_ptr],y
        pha
        iny
        iny
        lda     i_ptr + 2
        adcw    #0
        sta     [i_ptr],y
        sta     i_ptr + 2
        pla
        sta     i_ptr
        bra     @build
@last:  ldyw    #Handle::Next
        lda     i_head
        sta     [i_ptr],y
        iny
        iny
        lda     i_head + 2
        sta     [i_ptr],y
        lda     s_dreg,s
        sta     s_dreg + @psize,s
        lda     s_ret,s
        sta     s_ret + @psize,s
        tsc
        clc
        adcw    #@psize + @lsize
        tcs
        pld
        clc
        rts
.endproc

;;
; Find an active handle by its start address
;
; Stack frame (top to bottm):
;
; |-------------------------------|
; | [4] Space for returned handle |
; |-------------------------------|
; | [4] Pointer to find           |
; |-------------------------------|
;
; On exit:
;
; C,X,Y trashed
; 
.proc mm_find_handle

BEGIN_PARAMS
  PARAM s_dreg, .word
  PARAM s_ret, .word
  PARAM i_ptr, .dword
  PARAM o_handle, .dword
END_PARAMS

@psize := 4
@lsize := s_dreg - 1

        phd
        tsc
        sec
        sbcw    #@lsize
        tcs
        tcd

        lda     mm_active_list
        sta     o_handle
        lda     mm_active_list + 2
        sta     o_handle + 2
@check: lda     o_handle
        ora     o_handle + 2
        beq     @exit
        lda     [o_handle]
        cmp     i_ptr
        bne     @next
        ldyw    #Handle::Start + 2
        lda     [o_handle],y
        cmp     i_ptr + 2
        beq     @exit
@next:  ldyw    #Handle::Next
        lda     [o_handle],y
        tax
        iny
        iny
        lda     [o_handle],y
        sta     o_handle + 2
        stx     o_handle
        bra     @check
@exit:  lda     s_dreg,s
        sta     s_dreg+@psize,s
        lda     s_ret,s
        sta     s_ret+@psize,s
        tsc
        clc
        adcw    #@psize + @lsize
        tcs
        pld
        rts
.endproc

;;
; Add a handle to the active handle list.
;
; Stack frame (top to bottm):
;
; |-------------------|
; | [4] Handle to add |
; |-------------------|
;
; On exit:
;
; C,X,Y trashed
; 
.proc mm_add_to_active

BEGIN_PARAMS
  PARAM s_dreg, .word
  PARAM s_ret, .word
  PARAM i_handle, .dword
END_PARAMS

@psize := 4
@lsize := s_dreg - 1

        phd
        tsc
        tcd

        lda     mm_active_list + 2
        pha
        lda     mm_active_list
        pha
        lda     i_handle + 2
        pha
        lda     i_handle
        pha
        jsr     mm_add_to_list
        pla
        sta     mm_active_list
        pla
        sta     mm_active_list + 2

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

;;
; Remove a handle from the active handle list.
;
; Stack frame (top to bottm):
;
; |----------------------|
; | [4] Handle to remove |
; |----------------------|
;
; On exit:
;
; C,Y trashed
; 
.proc mm_remove_from_active

BEGIN_PARAMS
  PARAM l_prev, .dword
  PARAM l_curr, .dword
  PARAM s_dreg, .word
  PARAM s_ret, .word
  PARAM i_handle, .dword
END_PARAMS

@psize := 4
@lsize := s_dreg - 1

        phd
        tsc
        sec
        sbcw    #@lsize
        tcs
        tcd

        stz     l_prev
        stz     l_prev + 2
        lda     mm_active_list
        sta     l_curr
        lda     mm_active_list + 2
        sta     l_curr + 2
@check: lda     l_curr
        ora     l_curr + 2
        beq     @exit         ; end of list
        lda     l_curr
        cmp     i_handle
        bne     @next
        lda     l_curr + 2
        cmp     i_handle + 2
        bne     @next

        lda     l_prev
        ora     l_prev + 2
        bne     :+

        ; i_handle is the mm_active_list head, so just set the new list head and exit

        ldyw    #Handle::Next
        lda     [i_handle],y
        sta     mm_active_list
        iny
        iny
        lda     [i_handle],y
        sta     mm_active_list + 2
        bra     @exit

        ; Set l_prev->Next to i_handle->Next, thus removing it from the list

:       ldyw    #Handle::Next
        lda     [l_curr],y
        sta     [l_prev],y
        iny
        iny
        lda     [l_curr],y
        sta     [l_prev],y
        bra     @exit
        
        ; Go to the next entry in the list, saving our current position first
        ; in case we need to change its Next pointer later.

@next:  lda     l_curr
        sta     l_prev
        lda     l_curr + 2
        sta     l_prev + 2
        ldyw    #Handle::Next
        lda     [l_prev],y
        sta     l_curr
        iny
        iny
        lda     [l_prev],y
        sta     l_curr + 2
        bra     @check

@exit:  lda     s_dreg,s
        sta     s_dreg+@psize,s
        lda     s_ret,s
        sta     s_ret+@psize,s
        tsc
        clc
        adcw    #@psize + @lsize
        tcs
        pld
        rts
.endproc

;;
; Add a handle to the free handle list.
;
; Stack frame (top to bottm):
;
; |-------------------|
; | [4] Handle to add |
; |-------------------|
;
; On exit:
;
; C,X,Y trashed
; 
.proc mm_add_to_free

BEGIN_PARAMS
  PARAM s_dreg,   .word
  PARAM s_ret,    .word
  PARAM i_handle, .dword
END_PARAMS

@psize := 4
@lsize := s_dreg - 1

        phd
        tsc
        tcd

        lda     mm_free_list + 2
        pha
        lda     mm_free_list
        pha
        lda     i_handle + 2
        pha
        lda     i_handle
        pha
        jsr     mm_add_to_list
        pla
        sta     mm_free_list
        pla
        sta     mm_free_list + 2
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

;;
; Remove a handle from the free handle list.
;
; Stack frame (top to bottm):
;
; |----------------------|
; | [4] Handle to remove |
; |----------------------|
;
; On exit:
; 
; C,Y trashed
; 
.proc mm_remove_from_free

BEGIN_PARAMS
  PARAM l_prev, .dword
  PARAM l_curr, .dword
  PARAM s_dreg, .word
  PARAM s_ret, .word
  PARAM i_handle, .dword
END_PARAMS

@psize := 4
@lsize := s_dreg - 1

        phd
        tsc
        sec
        sbcw    #@lsize
        tcs
        tcd

        stz     l_prev
        stz     l_prev + 2
        lda     mm_free_list
        sta     l_curr
        lda     mm_free_list + 2
        sta     l_curr + 2
@check: lda     l_curr
        ora     l_curr + 2
        beq     @exit         ; end of list
        lda     l_curr
        cmp     i_handle
        bne     @next
        lda     l_curr + 2
        cmp     i_handle + 2
        bne     @next

        lda     l_prev
        ora     l_prev + 2
        bne     :+

        ; i_handle is the mm_free_list head, so just set the new list head and exit

        ldyw    #Handle::Next
        lda     [i_handle],y
        sta     mm_free_list
        iny
        iny
        lda     [i_handle],y
        sta     mm_free_list + 2
        bra     @exit

        ; Set l_prev->Next to i_handle->Next, thus removing it from the list

:       ldyw    #Handle::Next
        lda     [l_curr],y
        sta     [l_prev],y
        iny
        iny
        lda     [l_curr],y
        sta     [l_prev],y
        bra     @exit
        
        ; Go to the next entry in the list, saving our current position first
        ; in case we need to change its Next pointer later.

@next:  lda     l_curr
        sta     l_prev
        lda     l_curr + 2
        sta     l_prev + 2
        ldyw    #Handle::Next
        lda     [l_prev],y
        sta     l_curr
        iny
        iny
        lda     [l_prev],y
        sta     l_curr + 2
        bra     @check

@exit:  lda     s_dreg,s
        sta     s_dreg+@psize,s
        lda     s_ret,s
        sta     s_ret+@psize,s
        tsc
        clc
        adcw    #@psize + @lsize
        tcs
        pld
        rts
.endproc

;;
; Check to see if the inactive handle count is below the low water mark,
; and if so attempt to allocate a new block of handles. This function
; may fail if memory is tight, but it does not return an error condition.
; 
; Inputs:
; None
; 
; Outputs:
; All registers undefined
;
.proc mm_check_low_water_mark
        lda   mm_num_inactive     ; get current inactive handle count
        cmp   mm_low_water_mark   ; Are we below the water mark?
        blt   :+
        rts                       ; nothing to do
:       pha
        pha
        ldaw    #0
        pha                       ; size (hi)
        pha                       ; size (lo) [ as result from multiply_8x8 ]
        lda   mm_alloc_size
        pha                       ; first operand
        ldaw  #MM_HANDLE_SIZE
        pha                       ; second operand
        jsl   multiply_8x8        ; low byte of allocation size left on stack
        pea   0                   ; attributes
        pea   MM_OWNER_SYSTEM     ; owner id
        jsr   mm_alloc_internal
        pla
        sta   ptr
        pla
        sta   ptr + 2
        bcc   :+
        rts
:       lda   mm_inactive_list + 2
        pha                       ; list head (hi)
        lda   mm_inactive_list
        pha                       ; list head (lo)
        lda   ptr + 2
        sta   mm_inactive_list + 2
        pha                       ; start (hi)
        lda   ptr
        sta   mm_inactive_list
        pha                       ; start (lo)
        lda   mm_alloc_size
        pha                       ; # of handles
        jsr   mm_create_handle_list
        lda   mm_num_inactive
        clc
        adc   mm_alloc_size
        sta   mm_num_inactive
        rts
.endproc

;;
; Add a handle to the given list, keeping the list sorted
; by start address
;
; Stack frame (top to bottm):
;
; |---------------------------------|
; | [4] List head (may be modified) |
; |---------------------------------|
; | [4] Handle to add               |
; |---------------------------------|
;
; On exit:
;
; C,X,Y trashed
; List head on stack may be modified (caller must remove)
; 
.proc mm_add_to_list

BEGIN_PARAMS
  PARAM l_prev,   .dword
  PARAM l_curr,   .dword
  PARAM s_dreg,   .word
  PARAM s_ret,    .word
  PARAM i_handle, .dword
  PARAM o_list,   .dword
END_PARAMS

@psize := 4
@lsize := s_dreg - 1

        phd
        tsc
        sec
        sbcw    #@lsize
        tcs
        tcd

        stz     l_prev
        stz     l_prev + 2
        lda     o_list
        sta     l_curr
        lda     o_list + 2
        sta     l_curr + 2

        ; Traverse the list until either we hit the end or we hit an entry
        ; whose start address is greater than that of i_handle. Then insert
        ; i_handle at that point in the list.

@check: lda     l_curr
        ora     l_curr + 2          ; end of list?
        beq     @done
        ldyw    #Handle::Start + 2
        lda     [i_handle],y
        cmp     [l_curr],y
        blt     @done
        beq     :+
        bra     @next
:       lda     [i_handle]
        cmp     [l_curr]
        blt     @done
@next:  lda     l_curr
        sta     l_prev
        lda     l_curr + 2
        sta     l_prev + 2
        ldyw    #Handle::Next
        lda     [l_curr],y
        tax
        iny
        iny
        lda     [l_curr],y
        sta     l_curr + 2
        stx     l_curr
        bra     @check

        ; l_prev and l_curr are now the entries between which i_handle will
        ; be linked. l_prev may be nULL here in which case i_handle will be
        ; the new list head.

@done:  ldyw    #Handle::Next
        lda     l_curr
        sta     [i_handle],y
        iny
        iny
        lda     l_curr + 2
        sta     [i_handle],y
        lda     l_prev
        ora     l_prev + 2
        bne     :+
        lda     i_handle
        sta     o_list
        lda     i_handle + 2
        sta     o_list + 2
        bra     @exit
:       ldyw    #Handle::Next
        lda     i_handle
        sta     [l_prev],y
        iny
        iny
        lda     i_handle + 2
        sta     [l_prev],y
@exit:  lda     s_dreg,s
        sta     s_dreg+@psize,s
        lda     s_ret,s
        sta     s_ret+@psize,s
        tsc
        clc
        adcw    #@psize + @lsize
        tcs
        pld
        rts
.endproc
