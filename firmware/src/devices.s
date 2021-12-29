; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/io.s"

        .export device_manager_init
        .export install_device
        .export remove_device
        .export find_device
        .export call_device

        .export get_device_func
        .export device_func

        .import seriala_device
        .import serialb_device

        .importzp param

MAX_DEVICES = 64

        .segment "SYSDATA": far

devices: .res MAX_DEVICES * 4
num_devices: .res 1
device_func: .res 4

        .segment "ZEROPAGE"

ptr:    .res 4
device: .res 4

        .segment "OSROM"

.macro  install id,descriptor
        ldaw    #.loword(descriptor)
        sta     devices+(id*4)
        ldaw    #.hiword(descriptor)
        sta     devices+(id*4)+2
.endmacro

device_manager_init:
        lda     #3
        sta     num_devices
        
        longm
        install 1,seriala_device
        install 2,serialb_device
        shortm

        rtl

;;
; Install a new device
;
; Inputs:
; $1 - $3 : pointe to device descriptor block
; 
; Outputs:
; A = device ID or error
;
install_device:
        lda     num_devices
        cmp     #MAX_DEVICES    ; is the table full?
        beq     @full           ; Yes, so return error
        asl
        asl
        tax
        longm
        lda     param
        sta     devices,x
        lda     param+2
        sta     devices+2,x
        shortm
        lda     num_devices     ; get device_id we just installed
        tax                     ; save it in X
        inc
        sta     num_devices     ; we now have one more device
        txa                     ; return device_id to caller
        clc
        rtl
@full:  syserr  ERR_NO_MORE_DEVICES

;;
; Remove a device
; 
; Currently not supported/implemented
;
remove_device:
        syserr  ERR_NOT_SUPPORTED

; Find a device by its name
;
; Inputs:
; $1 - $3 : pointe to device name string
; 
; Outputs:
; A = device ID or error
;
find_device:
        ldx     #0
@loop:  txa
        cmp     num_devices ; are at the end of the table?
        beq     @error      ; yes, so exit with error
        jsr     set_device
        ldy     #0
@check: lda     [device],y
        cmp     [param],y   ; does this device's name match what was requested?
        bne     @next       ; if not try the next device
        cmp     #0          ; ok they matchd...are we at the end of the name?
        beq     @match      ; if so, this is the one we want
        iny
        bne     @check      ; if we somehow go past 255 let's assume no match
@next:  inx                 ; inc device id
        bra     @loop       ; and try again
@match: txa                 ; put device_id in A for caller
        clc                 ; and signal success
        rtl
@error: syserr  ERR_NO_SUCH_DEVICE

call_device:
        rtl

;;
; Given a device_id in A, set device to point to its device descriptor
;
set_device:
        phx
        asl
        asl
        tax
        longm
        lda     devices,x
        sta     device
        lda     devices+2,x
        sta     device+2
        shortm
        plx
        rts

; Given a device ID in A and a function number in X, retrieve the
; entry point for that function and store it in device_func.
;
; This is primarily used by the console to obtain the read/write
; functions for the selected console device.
;
get_device_func:
        jsr     set_device
        txa
        asl
        asl
        clc
        adc     #16    ; skip header
        tay
        longm
        lda     [device],y
        sta     device_func
        iny
        iny
        lda     [device],y
        sta     device_func+2
        shortm
        rtl
