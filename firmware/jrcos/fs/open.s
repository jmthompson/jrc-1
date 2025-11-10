; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; open_file

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/device.inc"
        .include    "kernel/fs.inc"
        .include    "stack.inc"
        .include    "kernel/scheduler.inc"

        .import     trampoline
        .import     bdev_operations, dir_operations, file_operations

        .segment "OSROM"

;;
; Open a file and return File pointer for it.
;
; Stack frame (top to bottm):
;
; |---------------------------------|
; | [2] Space for returned pointer  |
; |---------------------------------|
; | [4] Pointer to pathname         |
; |---------------------------------|
; | [2] Flags                       |
; |---------------------------------|
; | [2] Mode                        |
; |---------------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc open_file
        _BeginDirectPage
          l_ops     .dword
          l_devicep .word
          l_inodep  .word
          l_procp   .word
          _StackFrameRTS
          i_mode    .word
          i_flags   .word
          i_path    .dword
          o_filep   .word
        _EndDirectPage

        _SetupDirectPage

        ; start by trying to actually find the inode

        pha
        lda     i_path + 2
        pha
        lda     i_path
        pha
        jsr     lookup_inode
        pla
        sta     l_inodep
        bcc     @alloc
        ldyw    #ENOENT
        jmp     @exit

        ; Got the inode, now try to allocate a slot for it in the global file table

@alloc: pha
        jsr     allocate_file
        pla
        sta     o_filep
        jcs     @put_and_exit
        ldyw    #File::inode
        lda     l_inodep
        sta     (o_filep),y
        iny
        iny
        lda     i_mode
        sta     (o_filep),y
        iny
        iny
        lda     i_flags
        sta     (o_filep),y
        iny
        iny
        ldaw    #0
        sta     (o_filep),y
        iny
        iny
        sta     (o_filep),y

        ; Check for special handling for inodes that aren't plain files

        ldyw    #Inode::type
        lda     (l_inodep),y
        cmpw    #IT_FILE
        beq     @file
        cmpw    #IT_BDEV
        beq     @bdev
        cmpw    #IT_CDEV
        beq     @cdev

        ; must be directory
        ; TOOD: only allow open for read

        ldaw    #.loword(dir_operations)
        sta     l_ops
        ldaw    #.hiword(dir_operations)
        sta     l_ops + 2
        bra     @open
@file:  ldaw    #.loword(file_operations)
        sta     l_ops
        ldaw    #.hiword(file_operations)
        sta     l_ops + 2
        bra     @open
@bdev:  ldyw    #Inode::major
        lda     (l_inodep),y
        pha
        pha
        jsr     find_device
        pla
        sta     l_devicep
        jcs     @put_and_exit
        ldaw    #.loword(bdev_operations)
        sta     l_ops
        ldaw    #.hiword(bdev_operations)
        sta     l_ops + 2
        bra     @dev
@cdev:  ldyw    #Inode::major
        pha
        lda     (l_inodep),y
        pha
        jsr     find_device
        pla
        sta     l_devicep
        jcs     @put_and_exit
        ldyw    #Device::ops
        lda     (l_devicep),y
        sta     l_ops
        iny
        iny
        lda     (l_devicep),y
        sta     l_ops + 2
@dev:   ldyw    #File::device
        lda     l_devicep
        sta     (o_filep),y
        ldyw    #Inode::minor
        lda     (l_inodep),y
        ldyw    #File::unit
        sta     (o_filep),y
@open:  ldyw    #File::ops
        lda     l_ops
        sta     (o_filep),y
        iny
        iny
        lda     l_ops + 2
        sta     (o_filep),y
        ldyw    #FileOperations::open
        lda     [l_ops],y
        sta     trampoline + 1
        iny
        iny
        lda     [l_ops],y
        sta     trampoline + 3
        lda     l_inodep
        pha
        lda     o_filep
        pha
        jsl     trampoline
        bcs     @put_and_exit
        ldyw    #0
@exit:  _RemoveParams o_filep
        _SetExitState
        pld
        rts
@put_and_exit:
        pha
        lda     l_inodep
        pha
        jsr     put_inode
        ply                       ; restore error code
        bra     @exit
.endproc
