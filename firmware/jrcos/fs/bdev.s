; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/device.inc"
        .include    "kernel/fs.inc"
        .include    "kernel/function_macros.inc"

        .import     trampoline

        .segment "OSROM"

.macro _Dispatch op
        _BeginDirectPage
          l_ops       .dword
          _StackFrameRTL
          i_devicep   .dword
        _EndDirectPage

        phd
        pha
        pha
        tsc
        tcd
        ldyw    #Device::ops
        lda     [i_devicep],y
        sta     l_ops
        iny
        iny
        lda     [i_devicep],y
        sta     l_ops + 2
        ldyw    #op
        lda     [l_ops],y
        sta     trampoline + 1
        iny
        iny
        lda     [l_ops],y
        sta     trampoline + 3
        pla
        pla
        pld
        jml     trampoline
.endmacro

;;
; Open a block device
;
; Stack frame (top to bottm):
;
; |-----------------------|
; | [4] Pointer to Device |
; |-----------------------|
;
; On exit:
; C,X,Y trashed
;
.proc bdev_open
        _Dispatch BlockOperations::open
.endproc

;;
; Release a block device
;
; Stack frame (top to bottm):
;
; |-----------------------|
; | [4] Pointer to Device |
; |-----------------------|
;
; On exit:
; C,X,Y trashed
;
.proc bdev_release
        _Dispatch BlockOperations::release
.endproc

;;
; Read a single 512-byte block
;
; Stack frame (top to bottm):
;
; |----------------------------|
; | [4] Pointer to Device      |
; |----------------------------|
; | [4] Sector number          |
; |----------------------------|
; | [4] Pointer to data buffer |
; |----------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc bdev_rdblock
        _Dispatch BlockOperations::rdblock
.endproc

;;
; Write a single 512-byte block
;
; Stack frame (top to bottm):
;
; |----------------------------|
; | [4] Pointer to Device      |
; |----------------------------|
; | [4] Sector number          |
; |----------------------------|
; | [4] Pointer to data buffer |
; |----------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc bdev_wrblock
        _Dispatch BlockOperations::wrblock
.endproc
