; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; Filesystem initialization code

        .include    "common.inc"
        .include    "ascii.inc"
        .include    "kernel/console.inc"
        .include    "kernel/device.inc"
        .include    "kernel/fs.inc"
        .include    "stack.inc"

        .import     dentries, devices, disks, files, inodes
        .import     format_decimal, print_hex
        .import     console_register, sdcard_register, spi_register, via_register
        .import     trampoline

        .export     fs_init, fs_startup_scan

        .segment "BSS"

strbuff:        .res    16

        .segment "OSROM"

.proc fs_init
        jsr     console_register
        jsr     spi_register
        jsr     sdcard_register
        jmp     via_register
.endproc

.proc fs_startup_scan
        jsr     disk_scan
        jmp     show_disks
.endproc

.proc show_disks
        _BeginDirectPage
          l_count   .word
          l_size    .dword
          l_diskp   .word
          _StackFrameRTS
        _EndDirectPage

        _SetupDirectPage
        _kprint @banner
        ldaw    #.loword(disks)
        sta     l_diskp
        ldaw    #NUM_DISKS
        sta     l_count
@loop:  ldyw    #Disk::refcount
        lda     (l_diskp),y
        beq     @next
        ldyw    #Disk::num_sectors
        lda     (l_diskp),y
        sta     l_size
        iny
        iny
        lda     (l_diskp),y
        sta     l_size + 2
        ldxw    #11
:       lsr     l_size + 2      ; Divide block count by 2048 to get MB
        ror     l_size
        dex
        bne     :-
        lda     l_diskp
        pha
        jsr     print_disk_name
        lda     l_size + 2
        pha
        lda     l_size
        pha
        pea     $0001           ; use commas
        _PushLong strbuff
        jsl     format_decimal
        _kprint strbuff
        _kprint @mb
@next:  dec     l_count
        beq     @done
        lda     l_diskp
        clc
        adcw    #.sizeof(Disk)
        sta     l_diskp
        bra     @loop
@done:  _kprint @lf
        _RemoveParams
        pld
        rts

@banner:  .byte   ESC, "[4m", "Scanning storage devices", ESC, "[0m", CR, LF, CR, LF, 0
@mb:      .byte   " MB", CR, LF, 0
@lf:      .byte   CR,LF,CR,LF,0

.endproc

;;
; Scan all registered block devices for usable disks
;
.proc disk_scan
        _BeginDirectPage
          l_devicep   .word
          l_ops       .dword
          l_count     .word
          _StackFrameRTS
        _EndDirectPage

        _SetupDirectPage
        ldaw    #.loword(devices)
        sta     l_devicep
        ldaw    #NUM_DEVICES
        sta     l_count
@scan:  ldyw    #Device::major
        lda     (l_devicep),y
        bpl     @next               ; skip character devices

        lda     l_devicep
        pha
        jsl     bdev_open
@next:  dec     l_count
        beq     @done
        lda     l_devicep
        clc
        adcw    #.sizeof(Device)
        sta     l_devicep
        bra     @scan
@done:  _RemoveParams
        pld
        rts
.endproc

;;
; Print the name of the given Disk
;
; Stack frame (top to bottm):
;
; |----------------------|
; | [2] Pointer to Disk  |
; |----------------------|
;
; On entry:
; A = device number
; 
; On exit:
; A,X trashed
;
.proc print_disk_name
        _BeginDirectPage
          l_str       .dword
          l_devicep   .word
          _StackFrameRTS
          i_diskp     .word
        _EndDirectPage

        _SetupDirectPage
        ldyw    #Disk::device
        lda     (i_diskp),y
        sta     l_devicep
        ldyw    #Device::name
        lda     (l_devicep),y
        sta     l_str
        iny
        iny
        lda     (l_devicep),y
        sta     l_str + 2
        shortm
        ldyw    #0
@name:  lda     [l_str],y
        beq     @space
        _kputc
        iny
        cpyw    #15
        bne     @name
@space: cpyw    #17
        beq     @done
        lda     #' '
        _kputc
        iny
        bra     @space
@done:  longm
        _RemoveParams
        pld
        rts
.endproc
