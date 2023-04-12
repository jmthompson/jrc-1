; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; Inode struct management functions

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/device.inc"
        .include    "kernel/fs.inc"
        .include    "kernel/function_macros.inc"
        .include    "kernel/object.inc"

        .import     inodes

        .segment "OSROM"

;;
; Get an inode by filesystem and inode number. If the
; requested inode is already loaded it will be returned;
; otherwise a free inode is allocated and populated from
; the on-disk copy.
;
; TODO: inode locking
;
; Stack frame (top to bottm):
;
; |--------------------------------|
; | [4] Space for returned pointer |
; |--------------------------------|
; | [4] Pointer to parent Disk     |
; |--------------------------------|
; | [2] Inode number               |
; |--------------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc get_inode
        _BeginDirectPage
          _StackFrameRTS
          i_inum    .word
          i_diskp   .dword
          o_inodep  .dword
        _EndDirectPage

        _SetupDirectPage
        lda     .loword(inodes)
        sta     o_inodep
        lda     .hiword(inodes)
        sta     o_inodep + 2
        ldxw    #NUM_INODES
@find:  lda     [o_inodep]
        beq     @next           ; skip free entries
        ldyw    #Inode::disk
        lda     [o_inodep],y
        cmp     i_diskp
        bne     @next
        iny
        iny
        lda     [o_inodep],y
        cmp     i_diskp
        bne     @next
        iny
        iny
        lda     [o_inodep],y
        cmp     i_inum
        bne     @next

        ; inode found. Increment reference count and exit.

        lda     [o_inodep]
        inc
        sta     [o_inodep]
        ldyw    #0
        bra     @exit

@next:  dex
        beq     @notfound
        lda     o_inodep
        clc
        adcw    #.sizeof(Inode)
        sta     o_inodep
        bra     @find

        ; inode isn't in memory; find a free table entry and
        ; read it from disk.

@notfound:
        pha
        pha
        pea     .hiword(inodes)
        pea     .loword(inodes)
        pea     NUM_INODES
        pea     .sizeof(Inode)
        jsr     new_object
        pla
        sta     o_inodep
        pla
        sta     o_inodep + 2
        bcc     @load
        ldyw    #ENOMEM
        bra     @exit
@load:



@exit:  _RemoveParams o_inodep
        _SetExitState
        pld
        rts
.endproc

;;
; Release an Inode. If its reference count goes to zero the Inode's memory is
; deallocated.
;
; This function does NOT remove the Inode from any linked list of which it
; is a part. The caller must take care of this before releasing it.
;
; Stack frame (top to bottm):
;
; |----------------------|
; | [4] Pointer to Inode |
; |----------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc put_inode
        _BeginDirectPage
          _StackFrameRTS
          i_inodep  .dword
        _EndDirectPage

        _SetupDirectPage
        lda     [i_inodep]
        beq     :+
        dec
        sta     [i_inodep]
:       bne     :+
:       _RemoveParams
        ldaw    #0
        pld
        rts
.endproc

;;
; Look up an inode by path and return the inode, if found.
;
; Stack frame (top to bottm):
;
; |----------------------------|
; | [4] Pointer to path string |
; |----------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc lookup_inode
        _BeginDirectPage
          _StackFrameRTL
          i_path    .dword
          o_inodep  .dword
        _EndDirectPage

        _SetupDirectPage
        ; FIXME: do real lookup here
        pha
        pha
        pea     .hiword(inodes)
        pea     .loword(inodes)
        pea     NUM_INODES
        pea     .sizeof(Inode)
        jsr     new_object
        pla
        sta     o_inodep
        pla
        sta     o_inodep + 2
        bcc     @make
        ldyw    #ENOMEM
        bra     @exit
@make:  ldaw    #1
        sta     [o_inodep]
        ldyw    #Inode::type
        ldaw    #IT_CDEV
        sta     [o_inodep],y
        ldyw    #Inode::major
        ldaw    #DEVICE_ID_CONSOLE
        sta     [o_inodep],y
        iny
        iny
        ldaw    #0
        sta     [o_inodep],y
        ldyw    #0
@exit:  _RemoveParams o_inodep
        _SetExitState
        pld
        rtl
.endproc
