; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/console.s"

        .import sdcard_driver
        .import trampoline

        .importzp   device_cmd

        .export jros_init

;;
; Device/drive/volume limits. The limits are set up to allow
; for up to four drives per device, and four volumes pe
; drive (assuming standard PC partioning)
;
MAX_DEVICES = 4
MAX_DRIVES  = MAX_DEVICES*4
MAX_VOLUMES = MAX_DRIVES*4

DRIVE_STRUCT_SIZE  = 8
VOLUME_STRUCT_SIZE = 16

        .segment "ZEROPAGE"

device:     .res    4
devicenr:   .res    1
drive:      .res    4
drivenr:    .res    1
unit:       .res    4
unitnr:     .res    1

        .segment "SYSDATA"

cmd_buffer:     .res    32
block_buffer:   .res    512

;;
; The device list is a list of pointers to device driver
; structure.

num_devices:    .res 1
devices:        .res MAX_DEVICES*2

;;
; Drive structure is 8 bytes:
;
; 0 : drive ID ($DU)
; 1 : unit status (0 = offline, 1 = online)
; 2-5 : num_blocks
; 6-7 : reserved

num_drives: .res    1
drives:     .res    MAX_DRIVES * DRIVE_STRUCT_SIZE

; Volume structure is 16 bytes:
;
;    0 : drive ID ($DU)
;  1-4 : starting block
;  5-8 : number of blocks
; 9-15 : reserved

num_volumes:    .res    1
volumes:        .res    MAX_VOLUMES * VOLUME_STRUCT_SIZE

        .segment "OSROM"

jros_init:
        puts    @banner

        lda     #0
        sta     num_devices
        sta     num_drives
        sta     num_volumes

        pea     .hiword(sdcard_driver)
        pea     .loword(sdcard_driver)
        jsr     register_device

        puteol

        ;jsr     enumerate_drives
        ;jsr     enumerate_volumes

        rtl
@banner:
        .byte   "JR/OS Version 0.1", CR, LF, 0

; Register a device.
;
; On entry four byte pointer to driver block is on the stack
;
; On exit carry is set on failure and clear on success

register_device:
        lda     num_devices
        cmp     #MAX_DEVICES
        beq     @error

        longm
        lda     3,s
        sta     device
        lda     5,s
        sta     device+2
        lda     1,s
        sta     5,s
        tsc
        clc
        adcw    #4
        tcs
        shortm

        pea     0
        pea     0       ; no params
        ldy     #1      ; INIT
        jsr     call_device
        bcs     @error

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
@exit:  rts
@error: rts

; For each registered device, perform a STATUS call and register all
; online drives
;
enumerate_drives:
        lda     #0
        sta     devicenr
@devices:
        lda     devicenr
        cmp     num_devices
        beq     @exit
        jsr     select_device

        lda     #<block_buffer
        sta     cmd_buffer
        lda     #>block_buffer
        sta     cmd_buffer+1

        lda     #<cmd_buffer
        ldx     #>cmd_buffer
        ldy     #2              ; STATUS
        jsr     call_device
        bcs     @nextdrive

        lda     #<block_buffer
        sta     unit
        lda     #>block_buffer
        sta     unit+1
        lda     #0
        sta     unitnr
@units: lda     unitnr
        cmp     cmd_buffer+2    ; unit count from STATUS call
        beq     @exit
        jsr     register_drive
        lda     unitnr
        inc
        sta     unitnr
        rep     #$20
        inc     unit
        sep     #$20
        bra     @units

@nextdrive:
        lda     devicenr
        inc
        sta     devicenr
        bra     @devices

@exit:  rts

; Register drive for unit whose descriptor is pointed to by unit ptr

register_drive:
        lda     num_drives
        cmp     #MAX_DRIVES
        beq     @error
        jsr     select_drive

        puts    @msg
        lda     drive+1
        jsl     print_hex
        lda     drive
        jsl     print_hex
        puteol

        ldy     #0
        lda     devicenr
        asl
        asl
        asl
        asl
        ora     (unit),Y        ; put unit # in low four bits
        sta     (drive),Y
        iny
@copy:  lda     (unit),Y
        sta     (drive),Y
        iny
        cpy     #6
        bne     @copy
        clc
        rts
@error: sec
        rts
@msg:   .byte   "reg drive ",$00

; Select device whose # is in A. Trashes X.

select_device:
        asl
        tax
        longm
        lda     devices,X
        sta     device
        lda     devices+2,X
        sta     device+2
        shortm
        rts

; Select drive whose #is in A.

select_drive:
        longm
        andw    #255
        asl                 ; x8 (DRIVE_STRUCT_SIZE)
        asl
        asl
        clc
        adcw    #.loword(drives)
        sta     drive
        ldaw    #.hiword(drives)
        adcw    #0
        sta     drive+2
        shortm
        rts

; Call function Y in the currently selected device, using
; command block passed on the stack

call_device:
        longm
        lda     3,s
        sta     device_cmd
        lda     5,s
        sta     device_cmd+2
        lda     1,s
        sta     5,s
        tsc
        clc
        adcw    #4
        tcs
        shortm
        tya
        asl
        asl
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

; Print the name of the currently selected device

print_device_name:
        longm
        ldy     #2
        lda     [device],Y
        pha
        lda     [device]
        pha
        shortm
        call    SYS_CONSOLE_WRITELN
        rts
