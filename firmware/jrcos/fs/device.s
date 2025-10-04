; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/device.inc"
        .include    "kernel/fs.inc"
        .include    "kernel/heap.inc"
        .include    "kernel/function_macros.inc"
        .include    "kernel/object.inc"

        .import     devices
        .import     trampoline

        .segment "OSROM"

;;
; Register a new device
;
; Stack frame (top to bottm):
;
; |--------------------------------------|
; | [4] Pointer to device name           |
; |--------------------------------------|
; | [2] Device major number              |
; |--------------------------------------|
; | [4] Pointer to operations table      |
; |--------------------------------------|
; | [4] Pointer to private driver data   |
; |--------------------------------------|
;
; On exit:
; C,Y trashed
; c = 0 on success
; c = 1 on failure
;
.proc register_device
        _BeginDirectPage
          l_ptr       .dword
          _StackFrameRTS
          i_privatep  .dword
          i_ops       .dword
          i_devicenr  .word
          i_name      .dword
        _EndDirectPage

        _SetupDirectPage
        pha
        pha
        pea     .hiword(devices)
        pea     .loword(devices)
        pea     NUM_DEVICES
        pea     .sizeof(Device)
        jsr     new_object
        pla
        sta     l_ptr
        pla
        sta     l_ptr + 2
        bcc     @found
        ldyw    #ENOMEM
        bra     @exit
@found: ldyw    #Device::name
        lda     i_name
        sta     [l_ptr],y
        iny
        iny
        lda     i_name + 2
        sta     [l_ptr],y
        iny
        iny
        lda     i_devicenr
        sta     [l_ptr],y
        iny
        iny
        lda     i_ops
        sta     [l_ptr],y
        iny
        iny
        lda     i_ops + 2
        sta     [l_ptr],y
        iny
        iny
        lda     i_privatep
        sta     [l_ptr],y
        iny
        iny
        lda     i_privatep + 2
        sta     [l_ptr],y
        ldyw    #0
@exit:  _RemoveParams
        _SetExitState
        pld
        rts
.endproc

;;
; Find a device by its major number
;
; Stack frame (top to bottm):
;
; |--------------------------------|
; | [4] Space for returned pointer |
; |--------------------------------|
; | [2] Device major number        |
; |--------------------------------|
;
; On exit:
; C,Y trashed
; c = 0 on success
; c = 1 on failure
;
.proc find_device
        _BeginDirectPage
          _StackFrameRTS
          i_major     .word
          o_devicep   .dword
        _EndDirectPage

        _SetupDirectPage
        ldaw    #.loword(devices)
        sta     o_devicep
        ldaw    #.hiword(devices)
        sta     o_devicep + 2
        ldxw    #0
        ldyw    #Device::major
@loop:  lda     [o_devicep],y
        cmp     i_major
        beq     @found
        inx
        cpxw    #NUM_DEVICES
        beq     @error
        lda     o_devicep
        clc
        adcw    #.sizeof(Device)
        sta     o_devicep
        bra     @loop
@found: ldyw    #0
@exit:  _RemoveParams o_devicep
        _SetExitState
        pld
        rts
@error: ldyw    #ENXIO
        bra     @exit
.endproc
