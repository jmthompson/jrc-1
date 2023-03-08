; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; This implements a very simple heap system, used by the kernel to manage
; allocations for things like inodes and open file structures. The heap is
; assumed to be at less than 64K and does not cross a bank boundary.
; Allocations are rounded up to the nearest four bytes.
;
; Blocks are kept in an implied linked list by maintaining a pointer to the
; start of the heap, and from there each block (free or allocated) contains
; its size as the first and last two bytes of the block:
;
; Block start   ----> |---------------------|
;                     | ssss ssss ssss ss0f |
;                     |---------------------|
; Actual data ptr --> | [ data ]            |
;                     |---------------------|
;                     | ssss ssss ssss ss0f |
;                     |---------------------|
;
; s is the block size in bytes. The last two bits of the size are assumed
; to be 00.
;
; f is the allocation flag; it will be 0 for free blocks and 1 for allocated
; blocks.
;
        .include "common.inc"
        .include "errors.inc"
        .include "kernel/function_macros.inc"
        .include "kernel/heap.inc"

        .import __HEAP_START__
        .import __HEAP_SIZE__

        .importzp ptr

        .segment "BOOTROM"

;;
; Initialize the heap
;
; On exit:
; c = 0
; C/Y undefined
;
.proc heap_init
        ldaw    #.loword(__HEAP_START__)
        sta     ptr
        ldaw    #.hiword(__HEAP_START__)
        sta     ptr + 2
        ldaw    #__HEAP_SIZE__
        sta     [ptr]
        ldyw    #__HEAP_SIZE__ - 2
        sta     [ptr],y
        rts
.endproc

        .segment "OSROM"

;;
; Allocate a block of memory holding at least the number of requested bytes.
; The actual allocated size will be four bytes larger due to header & footer
; overhead.
;
; Stack frame (top to bottm):
;
; |---------------------------------|
; | [4] Space for returned pointer  |
; |---------------------------------|
; | [2] Number of bytes to allocate |
; |---------------------------------|
;
; On exit:
; c=0 on success
; c=1 on error
; C,Y trashed
;
.proc kmalloc
        _BeginDirectPage
          l_best_size   .word
          l_ptr         .dword
          _StackFrameRTS
          i_size        .word
          o_block       .dword
        _EndDirectPage

        _SetupDirectPage
        ldaw    #.loword(__HEAP_START__)
        sta     l_ptr
        ldaw    #.hiword(__HEAP_START__)
        sta     l_ptr + 2
        stz     o_block
        stz     o_block + 2
        lda     i_size
        cmpw    #$1001
        bge     @exit           ; Don't allow allocations > 4K
        clc
        adcw    #7              ; +4 for overhed and +3 for runding
        andw    #$FFFC          ; mask low bits
        sta     i_size
        ldaw    #$FFFF
        sta     l_best_size
@find:  lda     [l_ptr]
        tay
        andw    #1
        bne     @next           ; skip allocated blocks
        tya
        cmp     i_size
        blt     @next           ; block is too small
        cmp     l_best_size
        bge     @next           ; block is larger then current best match
        sta     l_best_size
        lda     l_ptr
        sta     o_block
        lda     l_ptr + 2
        sta     o_block + 2
@next:  tya
        andw    #$FFFC
        clc
        adc     l_ptr
        sta     l_ptr
        bcs     @last           ; we should never pass a bank boundary
        cmpw    #.loword(__HEAP_START__ + __HEAP_SIZE__ - 1)
        blt     @find
        beq     @find

        ; We've looked through the entire block list. If we found a free block
        ; of sufficient size l_best_size will be positive

@last:  lda     l_best_size
        cmpw    #$FFFF
        beq     @exit           ; if size is still $FFFF we did not find a block
        cmp     i_size
        beq     @alloc          ; l_best_size will always be >= i_size.

        lda     i_size
        clc
        adc     o_block
        sta     l_ptr
        lda     l_best_size
        sec
        sbc     i_size
        sta     [l_ptr]
        tay
        dey
        dey
        sta     [l_ptr],y
@alloc: lda     i_size
        tay
        oraw    #$0001
        sta     [o_block]
        dey
        dey
        sta     [o_block],y
@exit:  _RemoveParams o_block
        lda     o_block
        ora     o_block + 2
        beq     @oom
        lda     o_block
        clc
        adcw    #4
        sta     o_block
        ldaw    #0
        pld
        rts
@oom:   ldaw    #ERR_OUT_OF_MEMORY
        sec
        pld
        rts
.endproc

;;
; Free a block of memmory previously allocated via kmalloc. This consists of
; marking the block as free and then trying to consolidate it with any
; consecutive free blocks.
;
; Stack frame (top to bottm):
;
; |------------------------------|
; | [4] Pointer to block to free |
; |------------------------------|
;
; On exit:
; c=0 on success
; c=1 on error
; C,Y trashed
;
.proc kfree
        _BeginDirectPage
          l_size  .word
          l_ptr   .dword
          _StackFrameRTS
          i_block .dword
        _EndDirectPage

        _SetupDirectPage
        lda     i_block
        sec
        sbcw    #4
        sta     i_block     ; back up to the header
        lda     [i_block]
        tay
        andw    #1
        beq     @exit       ; this is not an allocated block
        tya
        dey
        dey
        dey
        cmp     [i_block],y ; sanity check; first and last word should match
        bne     @exit       ; if not this is not a valid block, or the heap is corrupted
        andw    #$FFFC
        sta     [i_block]
        sta     [i_block],y ; mark block as free

        ; if the previous block is free then merge it with i_block
        lda     i_block
        dec
        dec
        sta     l_ptr
        lda     i_block + 2
        sta     l_ptr + 2
        lda     [l_ptr]
        sta     l_size
        andw    #1
        bne     @merge_after  ; block isn't free

        lda     i_block
        sec
        sbc     l_size
        sta     i_block       ; i_block is now the start of the previous block
        lda     [i_block]
        clc
        adc     l_size
        sta     [i_block]     ; new size is combined size of both blocks
        tay
        dey
        dey
        sta     [i_block],y   ; update footer word too

        ; if the next block is free then merge it with i_block
@merge_after:
        lda     [i_block]
        sta     l_size
        clc
        adc     i_block
        sta     l_ptr
        lda     [l_ptr]
        andw    #1
        bne     @exit         ; block isn't free
        lda     [l_ptr]
        clc
        adc     l_size
        sta     [i_block]     ; save combined size
        tay
        dey
        dey
        sta     [i_block],y   ; update footer word too
@exit:  _RemoveParams
        pld
        rts
.endproc

