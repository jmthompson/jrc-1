; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; read_file

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/device.inc"
        .include    "kernel/fs.inc"
        .include    "kernel/function_macros.inc"

        .import     trampoline

        .segment "OSROM"

.macro _Dispatch op
        _BeginDirectPage
          l_ops     .dword
          _StackFrameRTL
          i_filep   .dword
        _EndDirectPage

        phd
        pha
        pha
        tsc
        tcd
        ldyw    #File::ops
        lda     [i_filep],y
        sta     l_ops
        iny
        iny
        lda     [i_filep],y
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
; Set file seek position
;
; Stack frame (top to bottm):
;
; |-------------------------------|
; | [4] Space for returned offset |
; |-------------------------------|
; | [4] Offset                    |
; |-------------------------------|
; | [2] Whence                    |
; |-------------------------------|
; | [4] Pointer to File           |
; |-------------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc seek_file
        _Dispatch FileOperations::seek
.endproc

;;
; Read data from a file
;
; Stack frame (top to bottm):
;
; |------------------------------|
; | [4] Space for returned count |
; |------------------------------|
; | [4] Number of bytes to read  |
; |------------------------------|
; | [4] Pointer to buffer        |
; |------------------------------|
; | [4] Pointer to File          |
; |------------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc read_file
        _Dispatch FileOperations::read
.endproc

;;
; Write data to a file
;
; Stack frame (top to bottm):
;
; |------------------------------|
; | [4] Space for returned count |
; |------------------------------|
; | [4] Number of bytes to write |
; |------------------------------|
; | [4] Pointer to buffer        |
; |------------------------------|
; | [4] Pointer to File          |
; |------------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc write_file
        _Dispatch FileOperations::write
.endproc
