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
        .include    "stack.inc"
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
; | [2] Space for returned pointer |
; |--------------------------------|
; | [2] Pointer to parent Disk     |
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
          i_diskp   .word
          o_inodep  .word
        _EndDirectPage

        _SetupDirectPage
        lda     .loword(inodes)
        sta     o_inodep
        ldxw    #NUM_INODES
@find:  lda     (o_inodep)
        beq     @next           ; skip free entries
        ldyw    #Inode::disk
        lda     (o_inodep),y
        cmp     i_diskp
        bne     @next
        iny
        iny
        lda     (o_inodep),y
        cmp     i_inum
        bne     @next

        ; inode found. Increment reference count and exit.

        lda     (o_inodep)
        inc
        sta     (o_inodep)
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
        pea     .loword(inodes)
        pea     NUM_INODES
        pea     .sizeof(Inode)
        jsr     new_object
        pla
        sta     o_inodep
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
; | [2] Pointer to Inode |
; |----------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc put_inode
        _BeginDirectPage
          _StackFrameRTS
          i_inodep  .word
        _EndDirectPage

        _SetupDirectPage
        lda     (i_inodep)
        beq     :+
        dec
        sta     (i_inodep)
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
; |--------------------------------|
; | [2] Space for returned pointer |
; |--------------------------------|
; | [4] Pointer to path string     |
; |--------------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc lookup_inode
i_path := $03
o_inodep := $07
        ; FIXME: do real lookup here
        ldaw     #.loword(inodes)
        clc
        ;pha
        ;pea     .hiword(inodes)
        ;pea     .loword(inodes)
        ;pea     NUM_INODES
        ;pea     .sizeof(Inode)
        ;jsr     new_object
        ;pla
        sta     o_inodep
        bcc     @make
        ldyw    #ENOMEM
        bra     @exit
@make:  ldyw    #0
        ldaw    #1
        sta     (o_inodep,s),y
        ldyw    #Inode::type
        ldaw    #IT_CDEV
        sta     (o_inodep,s),y
        ldyw    #Inode::major
        ldaw    #DEVICE_ID_CONSOLE
        sta     (o_inodep,s),y
        iny
        iny
        ldaw    #0
        sta     (o_inodep,s),y
@exit:  lda     1,s
        sta     5,s
        tsc
        clc
        adcw    #4
        tcs
        ldaw    #0
        rts
@error: lda     1,s
        sta     5,s
        tsc
        clc
        adcw    #4
        tcs
        tya
        sec
        rts
.endproc
