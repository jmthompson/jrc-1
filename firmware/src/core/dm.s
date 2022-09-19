; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; This is the gbeneric device handling for the BIOS.

        .include    "common.inc"
        .include    "device.inc"
        .include    "errors.inc"
        .include    "syscall_macros.inc"

        .importzp   params
        .importzp   ptr
        .importzp   tmp

        .export     dm_init 
        .export     dm_register
        .export     dm_register_internal
        .export     dm_unregister
        .export     dm_get_num_devices
        .export     dm_get_device
        .export     dm_find_device
        .export     dm_call

        .import     strmatch
        .import     trampoline

        .segment    "ZEROPAGE"

device:         .res    4

        .segment    "BSS"

; Currently selected devicenr
devicenr:       .res    2
; The number of registered devices
num_devices:    .res    2
; An array of block device structure pointers
device_list:    .res    MAX_DEVICES * 4

        .segment "OSROM"

dm_init:
        stz     num_devices
        rts

;;
; Register a block device
;
; Parameters
;
; [4,I] Poiner to device structure
; [2,O] Assigned device iD
;
; On exit:
; c = 0 on success
; c = 1 on failure
;
dm_register:
        SC_ENTER
        PARAM32 device, 1
        jsr     register_device
        RET16   devicenr
        SC_EXIT

;;
; Register a device
;
; Stack frame:
;
; [2,I] <device ptr high>
; [2,I] <evice ptr low>
;
; On exit:
; c = 0 on success
; c = 1 on failure
;
dm_register_internal:
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
        jmp     register_device

;;
; Unregfister a device. Not currently implemented
;
dm_unregister:
        SC_ERROR ERR_NOT_SUPPORTED

;;
; Return the number of registered devices
; 
; Params:
; [2,O]: Device count
;
dm_get_num_devices:
        SC_ENTER
        RET16   num_devices
        SC_SUCCESS

;;
; Return device driver structure for a given device ID
;
; Params:
; [2,I]: Device ID
; [4,O]: Pointer to device structure
;
dm_get_device:
        SC_ENTER
        PARAM16 devicenr, 1
        jsr     select_device
        bcc     :+
        SC_EXIT
:       RET32   device
        SC_SUCCESS

;;
; Return device ID for a given device name
;
; Params:
; [4,I]: Pointer to device name
; [2,O]: Pointer to device structure
;
dm_find_device:
        SC_ENTER
        PARAM32 ptr, 1
        phy
        stz     devicenr
@check: jsr     select_device
        lda     ptr + 2
        pha
        lda     ptr
        pha
        ldyw    #6
        lda     [device],y
        pha
        dey
        dey
        lda     [device],y
        pha
        jsl     strmatch
        bcc     @found
        inc     devicenr
        lda     devicenr
        cmp     num_devices
        bne     @check
        ply
        SC_ERROR ERR_NO_SUCH_DEVICE
@found: ply
        RET16   devicenr
        SC_SUCCESS

;;
; Call a function on a device.
;
; Params:
;
; +0: [I2] Device number
; +2: [I2] Function number
; +4 .. function-specific
;
dm_call:
        SC_ENTER
        PARAM32 ptr, 1
        PARAM16 tmp, 1
        PARAM16 devicenr, 1
        jsr     select_device
        bcs     :+
        ldx     tmp
        jsr     call_device
:       SC_EXIT

;-------- Private methods --------;

;;
; Register currently selected device
;
; On entry:
; device = pointer to new device
;
; On exit:
; C,c contain error status
; devicenr = newly assigned device id
;
register_device:
        lda     num_devices
        cmpw    #MAX_DEVICES
        bne     @init
        ldaw    #ERR_NO_MORE_DEVICES
        sec
        rts
@init:  ldxw    #DEV_STARTUP
        jsr     call_device
        bcc     :+
        rts
:       lda     num_devices
        sta     devicenr
        asl
        asl
        tax
        lda     device
        sta     device_list,x
        lda     device+2
        sta     device_list+2,x
        inc     num_devices
        clc
        rts

;;
; Make a device the currently selecte device
;
; On exit:
; C,X undefined
; Y preserved
;
select_device:
        lda     devicenr
        cmp     num_devices
        blt     :+
        ldaw    #ERR_NO_SUCH_DEVICE
        sec
        rts
:       asl
        asl
        tax
        lda     device_list,x
        sta     device
        lda     device_list+2,x
        sta     device+2
        ldaw    #0
        clc
        rts

;;
; Call function X in the currently selected device.
;
; On entry:
; X = function number
; Param block in [ptr]
;
; On exit:
; Error status in C/c
; X undefined
; Y preserved
;
call_device:
        phy
        ldyw    #12
        lda     [device],y  ; get number of functions
        sta     tmp
        cpx     tmp
        bge     @err
        txa
        asl
        asl
        clc
        adcw    #14         ; Function pointers start at +12
        tay
        lda     [device],y
        sta     trampoline+1
        iny
        iny
        lda     [device],y
        sta     trampoline+3
        lda     ptr + 2
        pha
        lda     ptr
        pha
        ldyw    #10
        lda     [device],y
        pha
        dey
        dey
        lda     [device],y
        pha
        jsl     trampoline
        plx                 ; Clean up the stack
        plx
        plx
        plx
        ply                 ; restore Y
        rts
@err:   ldaw    #ERR_NOT_SUPPORTED
        sec
        rts
