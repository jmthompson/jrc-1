; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; Filesystem initialization code

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/device.inc"
        .include    "kernel/fs.inc"
        .include    "kernel/function_macros.inc"
        .include    "kernel/object.inc"

        .import   block_buffer, disks, trampoline
        .import   kmalloc
        .importzp ptr

        .segment "OSROM"

;;
; Allocate a new Disk and return a pointer to it
;
; Stack frame (top to bottm):
;
; |--------------------------------|
; | [4] Space for returned pointer |
; |--------------------------------|
; 
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc allocate_disk
        _BeginDirectPage
          _StackFrameRTS
          o_diskp   .dword
        _EndDirectPage

        _SetupDirectPage
        pha
        pha
        pea     .hiword(disks)
        pea     .loword(disks)
        pea     NUM_DISKS
        pea     .sizeof(Disk)
        jsr     new_object
        pla
        sta     o_diskp
        pla
        sta     o_diskp + 2
        bcc     @found
        ldyw    #ENOMEM
        bra     @exit
@found: ldaw    #1
        sta     [o_diskp]
        ldyw    #0
@exit:  _RemoveParams o_diskp
        _SetExitState
        pld
        rts
.endproc

;;
; Attach a Disk, amking it available to the system. This will immediately
; trigger a partition scan on the disk.
;
; Stack frame (top to bottm):
;
; |----------------------------|
; | [4] Pointer to Disk to add |
; |----------------------------|
;
; On exit:
;
; c = 0 on success or 1 on failure
;
.proc attach_disk
        _BeginDirectPage
          l_count     .dword
          l_devicep   .dword
          l_ops       .dword
          l_newdiskp  .dword
          l_partp     .dword
          l_start     .dword
          l_size      .dword
          _StackFrameRTS
          i_diskp   .dword
        _EndDirectPage

        _SetupDirectPage
        ldyw    #Disk::device + 2
        lda     [i_diskp],y
        sta     l_devicep + 2
        dey
        dey
        lda     [i_diskp],y
        sta     l_devicep

        _PushLong 0                 ; Read block zero
        _PushLong block_buffer
        lda     l_devicep + 2
        pha
        lda     l_devicep
        pha
        jsl     bdev_rdblock
        jcs     @done
        jsr     check_mbr
        jcs     @done

        ; Parittion entries start at offset +446
        ldaw    #.loword(block_buffer+446)
        sta     l_partp
        ldaw    #.hiword(block_buffer+448)
        sta     l_partp+2

        ; partition entry format (important parts):
        ;
        ; +0  = status ($80 active, $00 normal),
        ; +4  = partition type
        ; +8  = starting sector
        ; +12 = number of sectors

        ldaw    #4          ; Max of four partitions (we don't do extended)
        sta     l_count
@part:  ldyw    #4
        lda     [l_partp],Y     ; get partition type
        andw    #255
        cmpw    #$0c        ; W95 FAT32 LBA
        beq     @fat
        cmpw    #$0e        ; W95 FAT16 LBA
        beq     @fat
        cmpw    #$81        ; MINIX
        bne     @next
@minix:
@fat:   ldyw    #8
        lda     [l_partp],y
        sta     l_start
        iny
        iny
        lda     [l_partp],y
        sta     l_start + 2
        iny
        iny
        lda     [l_partp],y
        sta     l_size
        iny
        iny
        lda     [l_partp],y
        sta     l_size + 2
        pha
        pha
        jsr     allocate_disk
        pla
        sta     l_newdiskp
        pla
        sta     l_newdiskp + 2
        bcs     @done               ; exit on memory allocation error
        ldyw    #Disk::device
        ldaw    l_devicep
        sta     [l_newdiskp],y  ; device (lo)
        iny
        iny
        ldaw    l_devicep + 2
        sta     [l_newdiskp],y  ; device (hi)
        iny
        iny
        ldaw    i_diskp
        sta     [l_newdiskp],y  ; parent (lo)
        iny
        iny
        ldaw    i_diskp + 2
        sta     [l_newdiskp],y  ; parent (hi)
        iny
        iny
        lda     l_start
        sta     [l_newdiskp],y  ; start_sector (lo)
        iny
        iny
        lda     l_start + 2
        sta     [l_newdiskp],y  ; start_sector (hi)
        iny
        iny
        lda     l_size
        sta     [l_newdiskp],y  ; num_sectors (lo)
        iny
        iny
        lda     l_size + 2
        sta     [l_newdiskp],y  ; num_sectors (hi)
        iny
        iny
        ldaw    #0
        sta     [l_newdiskp],y  ; type
@next:  dec     l_count
        beq     @done
        ldaw    l_partp
        clc
        adcw    #16
        sta     l_partp
        jmp     @part
@done:  _RemoveParams
        ldaw    #0
        clc
        pld
        rts
.endproc

;;
; Check to see if the block in the block_buffer contins a valid MBR
;
; Inputs:
; block_buffer = contents of block to check
;
; Outputs:
; All registered trashed
; c = 1 if MBR is valid
; c = 0 if MBR is invalid
;
.proc check_mbr
        ; Look for $AA55 signature to indicate presence of an MBR
        ldaw    block_buffer+510
        cmpw    #$AA55
        bne     @bad
        ; FAT VBR shares the same signature; a simple way to tell
        ; them apart is that the VBR should have a string starting
        ; with "FAT" at offset $36
        lda     block_buffer+54
        cmpw    #$4146
        beq     @bad
        clc
        rts
@bad:   sec
        rts
.endproc
