; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include    "common.inc"
        .include    "syscalls.inc"
        .include    "device.inc"
        .include    "console.inc"
        .include    "ascii.inc"

        .import     cmd_buffer
        .import     devicenr
        .import     num_volumes
        .import     print_decimal32
        .import     sdcard_driver
        .import     volume_scan

        .importzp   devicep
        .importzp   ptr

        .export     dos_init

        .segment "SYSDATA"

num_devices:    .res    2

        .segment "OSROM"

dos_init:
        stz     num_devices
        stz     num_volumes

        _PrintString @banner

        ; For each registered block device, display its name and status
        stz     devicenr
@scan:  pea     0
        pea     0
        lda     devicenr
        pha
        _Call   SYS_GET_DEVICE_BY_ID
        pla
        sta     devicep
        pla
        sta     devicep+2
        bcs     @done
        ldyw    #2
        lda     [devicep],Y         ; get device features
        andw    #DEVICE_TYPE_CHAR
        bne     @next
        jsr     print_device_name
        _DMMount devicenr, cmd_buffer
        bcs     @offline
        _DMGetStatus devicenr, cmd_buffer
        bcs     @offline
        lda     cmd_buffer          ; get online status
        andw    #DEVICE_ONLINE
        bne     @online
@offline:
        _PrintString @nomedia
        bra     @next
@online:
        ldxw    #11
:       lsr     cmd_buffer+4    ; Divide block count by 2048 to get MB
        ror     cmd_buffer+2
        dex
        bne     :-
        lda     cmd_buffer+4
        pha
        lda     cmd_buffer+2
        pha
        jsl     print_decimal32
        _PrintString @mb
        jsr     volume_scan
@next:  inc     devicenr
        brl     @scan
@done:  _PrintString @f1
        pea     0
        lda     num_volumes
        pha
        jsl     print_decimal32
        _PrintString @f2
        lda     num_volumes
        cmpw    #1
        beq     :+
        ldaw    #'s'
        _PrintChar
:       _PrintString @lf
        rtl
@banner: 
        .byte   ESC, "[4m", "Scanning storage devices", ESC, "[0m", CR, LF, 0

@nomedia:
        .byte   "---", CR, LF, 0
@mb:    .byte   " MB", CR, LF, 0
@f1:    .byte   CR, LF, "Found ", 0
@f2:    .byte   " volume", 0
@lf:    .byte   CR, LF, CR, LF, 0

;;
; _Print the name of the currently selected device
;
; On entry:
; A = device number
; 
; On exit:
; A,X trashed
;
print_device_name:
        ldyw    #4
        lda     [devicep],Y
        sta     ptr
        iny
        iny
        lda     [devicep],y
        sta     ptr + 2
        shortm
        ldxw    #15         ; show up to 15 chars of the device name
        ldyw    #0          ; start at beginning of string
@print: lda     [ptr],Y
        beq     @pad        ; end of string?
        _Call   SYS_CONSOLE_WRITE
        iny
        dex
        bne     @print      ; do another char, if we have space left
        ldxw    #2          ; always add at least two spaces
@pad:   lda     #' '
        _Call   SYS_CONSOLE_WRITE
        dex
        bne     @pad
        longm
        rts
