; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/console.s"

        .import print_decimal8
        .import sdcard_driver
        .import trampoline

        .importzp   param
        .importzp   device_cmd

        .export jros_init
        .export jros_register_device
        .export jros_mount_device
        .export jros_eject_device
        .export jros_format_device
        .export jros_device_status
        .export jros_read_block
        .export jros_write_block

;;
; Device/drive/volume limits. The limits are set up to allow for up to four
; volumes per device (assuming standard PC partioning)
;
MAX_DEVICES = 4
MAX_VOLUMES = MAX_DEVICES*4

; Device driver function numbers
DEV_INIT    = $00
DEV_STATUS  = $01
DEV_MOUNT   = $02
DEV_EJECT   = $03
DEV_FORMAT  = $04
DEV_RDBLOCK = $05
DEV_WRBLOCK = $06

        .segment "ZEROPAGE"

device:     .res    4

        .segment "SYSDATA"

devicenr:       .res    1
cmd_buffer:     .res    32
block_buffer:   .res    512

;;
; The device list is a list of pointers to device driver
; structure.

num_devices:    .res 1
devices:        .res MAX_DEVICES*2

;;
; Volume structure is 16 bytes:
;
;    0 : device ID
;  1-4 : starting block
;  5-8 : number of blocks
; 9-15 : reserved

VOLUME_STRUCT_SIZE = 16

num_volumes:    .res    1
volumes:        .res    MAX_VOLUMES * VOLUME_STRUCT_SIZE

        .segment "OSROM"

jros_init:
        puts    @banner

        stz     num_devices
        stz     num_volumes

        ; pre-register the built-in devices
        longm
        ldaw    #.loword(sdcard_driver)
        sta     param
        ldaw    #.hiword(sdcard_driver)
        sta     param+2
        shortm
        jsl     jros_register_device

        ; For each registered drive, try to mount it, and display
        ; its name and status
        stz     devicenr
@scan:  lda     devicenr
        cmp     num_devices
        beq     @done
        jsr     select_device
        jsr     print_device_name
        jsr     mount_device
        bcc     :+
        putc    #'-'
        bra     @next
:       putc    #'.'
@next:  puteol
        inc     devicenr
        bra     @scan
@done:  rtl

@banner:    .byte   "Scanning storage devices", CR, LF, CR, LF, 0

;;
; Register a device with JR/OS.
;
; On entry:
; param is pointer to device structure
;
; On exit:
; c = 0 on success
; c = 1 on failure
;
jros_register_device:
        lda     num_devices
        cmp     #MAX_DEVICES
        bne     :+
        syserr  ERR_NO_MORE_DEVICES
:       longm
        lda     param
        sta     device
        lda     param+2
        sta     device+2
        shortm

        ldy     #DEV_INIT
        jsr     call_device
        bcs     @exit

        lda     num_devices
        asl
        asl
        tax
        longm
        lda     device
        sta     devices,X
        lda     device+2
        sta     devices+2,X
        shortm
        inc     num_devices
        clc
@exit:  rtl

;;
; Attempt to mount any volumes on a device
;
; On entry:
; A = device id
;
; On exit:
; c = 0 on success
; c = 1 on failure
; On success any volumes found will be added to the volume list
;
jros_mount_device:
        jsr     mount_device
        bcs     @exit           ; don't scan if mount failed
        jsr     scan_device
        clc
@exit:  rtl

;;
; Eject the media on a device, and unmount any volumes on it
;
; On entry:
; A = device id
;
; On exit:
; c = 0 on success
; c = 1 on failure
; On success any volumes on the device will be removed from the volume list
;
jros_eject_device:
        clc
        rtl

;;
; Format a device
;
; On entry:
; A = device id
;
; On exit:
; c = 0 on success
; c = 1 on failure
;
jros_format_device:
        clc
        rtl

;;
; Format a device
;
; On entry:
; A = device id
; Pointer to param block in param
;
; On exit:
; c = 0 on success
; c = 1 on failure
;
jros_device_status:
        clc
        rtl

;;
; Attempt to read a block from a device
;
; On entry:
; A = device id
; Pointer to param block in param
;
; On exit:
; c = 0 on success
; c = 1 on failure
;
jros_read_block:
        clc
        rtl

;;
; Attempt to write a block to a device
;
; On entry:
; A = device id
; Pointer to param block in param
;
; On exit:
; c = 0 on success
; c = 1 on failure
;
jros_write_block:
        clc
        rtl

;-------- Private methods --------;

;;
; Make a device the currently selecte device
;
; On entry:
; A = device ID
;
; On exit:
; C,X trashed
;
select_device:
        sta     devicenr
        asl
        tax
        longm
        lda     devices,X
        sta     device
        lda     devices+2,X
        sta     device+2
        shortm
        rts

;;
; Call function Y in the currently selected device
;
call_device:
        tya
        asl
        asl
        clc
        adc     #16         ; skip device name
        tay
        longm
        lda     [device],Y
        sta     trampoline+1
        shortm
        iny
        iny
        lda     [device],Y
        sta     trampoline+3
        jsl     trampoline
        rts

;;
; Attemp to mount the currently selected device
;
; On entry:
; device points to device to mount
;
; On exit:
; All registers trashed
; c = 0 on success
; c = 1 on failure
;
mount_device:
        ldy     #DEV_MOUNT
        jsr     call_device
        rts

;;
; Scan the currently selected device for readable volumes
;
; On entry:
; device points to device to mount
;
; On exit:
; All registers trashed
; c = 0 on success
; c = 1 on failure
;
scan_device:
        clc
        rts

;;
; Print the name of the currently selected device
;
; On entry:
; device points to current device
; 
; On exit:
; A,Y trashed
;
print_device_name:
        longm
        lda     device+2
        pha
        lda     device
        pha
        shortm
        call    SYS_CONSOLE_WRITELN
        rts
