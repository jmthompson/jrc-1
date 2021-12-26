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
        .export bios_call_device

MAX_DEVICES = 64

        .segment "SYSDATA": far

devices: .res MAX_DEVICES * 4
num_devices: .res 1

ptmp:   .res 4        ; for saving stuff from the syscall DP

        .segment "ZEROPAGE"

ptr:    .res 4
current_device: 
        .res 4

        .segment "BIOSROM"

device_manager_init:
        lda     #0
        sta     num_devices
        ; todo: regiser all built-in hardware devices
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
        lda     $1
        sta     devices,x
        lda     $3
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
        longm
        lda     $01
        sta     ptmp        ; Copy pointer to name to search for
        lda     $03
        sta     ptmp+2      ; into a temporary spot
        ldaw    #BIOS_DP
        tcd                 ; and then switch to the BIOS DP
        lda     ptmp
        sta     ptr         ; Now put name pointer in ptr
        lda     ptmp+2
        sta     ptr+2
        shortm
        ldx     #0
@loop:  txa
        cmp     num_devices ; are at the end of the table?
        beq     @error      ; yes, so exit with error
        jsr     set_current_device
        ldy     #0
@check: lda     [current_device],y
        cmp     [ptr],y     ; does this device's name match what was requested?
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

bios_call_device:
        rtl

;;
; Given a device_id in X, set current_device to point to its device descriptor
;
set_current_device:
        phx
        txa
        asl
        asl
        tax
        longm
        lda     devices,x
        sta     current_device
        lda     devices+2,x
        sta     current_device+2
        shortm
        plx
        rts
