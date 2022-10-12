; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; This is the gbeneric device handling for the BIOS.

        .include    "common.inc"
        .include    "device.inc"
        .include    "errors.inc"
        .include    "linker.inc"
        .include    "syscall_macros.inc"

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

        .segment    "BSS"

; Currently selected device
device:         .res    4
; Currently selected devicenr
devicenr:       .res    2
; The number of registered devices
num_devices:    .res    2
; An array of block device structure pointers
device_list:    .res    MAX_DEVICES * 4

; Temporary storage for device name pointers
device_name:    .res    4

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
@i_device   = $01
@o_devicenr = @i_device + 4

        SC_ENTER
        lda     @i_device
        sta     device
        lda     @i_device + 2
        sta     device + 2
        jsr     register_device
        lda     devicenr
        sta     @o_devicenr
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

@o_num_devices = $01

        SC_ENTER
        lda     num_devices
        sta     @o_num_devices
        SC_SUCCESS

;;
; Return device driver structure for a given device ID
;
; Params:
; [2,I]: Device ID
; [4,O]: Pointer to device structure
;
dm_get_device:

@i_devicenr = $01
@o_device   = @i_devicenr + 2

        SC_ENTER
        lda     @i_devicenr
        sta     devicenr
        jsr     select_device
        bcc     :+
        SC_EXIT
:       lda     device
        sta     @o_device
        lda     device + 2
        sta     @o_device + 2
        SC_SUCCESS

;;
; Return device ID for a given device name
;
; Params:
; [4,I]: Pointer to device name
; [2,O]: Device number
;
dm_find_device:

@i_device_name  = $01
@o_devicenr     = @i_device_name + 4
@ptr            = @i_device_name    ; reusing input param

        SC_ENTER

        lda     @i_device_name
        sta     device_name
        lda     @i_device_name + 2
        sta     device_name + 2

        stz     devicenr
@check: jsr     select_device
        lda     device
        sta     @ptr
        lda     device + 2
        sta     @ptr + 2
        lda     device_name + 2
        pha
        lda     device_name
        pha
        ldyw    #6
        lda     [@ptr],y
        pha
        dey
        dey
        lda     [@ptr],y
        pha
        jsl     strmatch
        bcc     @found
        inc     devicenr
        lda     devicenr
        cmp     num_devices
        bne     @check
        SC_ERROR ERR_NO_SUCH_DEVICE
@found: lda     devicenr
        sta     @o_devicenr
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

@i_param_block  = $01
@i_function     = @i_param_block + 4
@i_devicenr     = @i_function + 2

        SC_ENTER
        lda     @i_devicenr
        sta     devicenr
        jsr     select_device
        bcs     :+
        lda     @i_param_block
        ldy     @i_param_block + 2
        ldx     @i_function
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
; A/Y = param block ptr (low/hi)
; X = function number
;
; On exit:
; Error status in C/c
; X,Y undefined
;
call_device:
        phd
        phy
        pha                       ; save param block ptr on stack for driver call
        ldaw    #OS_DP
        tcd
        lda     device
        sta     ptr
        lda     device + 2
        sta     ptr + 2
        ldyw    #12
        lda     [ptr],y  ; get number of functions
        sta     tmp
        cpx     tmp
        blt     :+
        pla
        pla
        ldaw    #ERR_NOT_SUPPORTED
        pld
        sec
        rts
:       txa
        asl
        asl
        clc
        adcw    #14         ; Function pointers start at +12
        tay
        lda     [ptr],y
        sta     trampoline+1
        iny
        iny
        lda     [ptr],y
        sta     trampoline+3
        ldyw    #10
        lda     [ptr],y
        pha
        dey
        dey
        lda     [ptr],y
        pha
        jsl     trampoline
        plx                 ; Clean up the stack
        plx
        plx
        plx
        pld
        rts
