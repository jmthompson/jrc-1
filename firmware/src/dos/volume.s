; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include    "common.inc"
        .include    "syscalls.inc"
        .include    "device.inc"
        .include    "volume.inc"

        .export     volume_scan

        .import     block_buffer
        .import     cmd_buffer
        .import     num_volumes
        .import     devicenr

        .segment   "ZEROPAGE"

; Partition entry pointer
partp:      .res    4

        .segment    "SYSDATA"

vol_buffer: .res    VOLUME_STRUCT_SIZE

        .segment    "OSROM"

;;
; Scan the currently selected device for volumes. If there is a valid
; parittion table, regiser all partitions as volumes. Otherwise, just
; register the device itself.
;
; On entry:
; devicenr = device to scan
;
; On exit:
; All registers trashed
; New volumes registered
;
volume_scan:
        stz     cmd_buffer
        stz     cmd_buffer+2        ; Get block #0
        ldaw    #.loword(block_buffer)
        sta     cmd_buffer+4
        ldaw    #.hiword(block_buffer)
        sta     cmd_buffer+6
        _DMReadBlock devicenr, cmd_buffer
        bcs     @done

        jsr     check_mbr
        bcc     @mbr

        ; TODO: regiater whole device as volume here

@mbr:
        ; Parittion entries start at offset +446
        ldaw    #.loword(block_buffer+446)
        sta     partp
        ldaw    #.hiword(block_buffer+448)
        sta     partp+2

        ; partition entry format (important parts):
        ;
        ; +0  = status ($80 active, $00 normal),
        ; +4  = partition type
        ; +8  = starting sector
        ; +12 = number of sectors

        ldxw    #4          ; Max of four partitions (we don't do extended)
@part:  ldyw    #4
        lda     [partp],Y     ; get partition type
        andw    #255
        cmpw    #$0c        ; W95 FAT32 LBA
        beq     @add
        cmpw    #$0e        ; W95 FAT16 LBA
        bne     @next
@add:   lda     devicenr
        sta     vol_buffer
        ldyw    #8
        lda     [partp],y
        sta     vol_buffer+2
        iny
        iny
        lda     [partp],y
        sta     vol_buffer+4
        iny
        iny
        lda     [partp],y
        sta     vol_buffer+6
        iny
        iny
        lda     [partp],y
        sta     vol_buffer+8
        jsr     add_volume
@next:  dex
        beq     @done
        ldaw    partp
        clc
        adcw    #16
        sta     partp
        lda     partp+2
        adcw    #0
        sta     partp+2
        bra     @part
@done:  rts

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
check_mbr:
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

;;
; 
add_volume:
        inc     num_volumes
        phx
        plx
        rts

