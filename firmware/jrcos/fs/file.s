; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; File struct management functions

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/fs.inc"
        .include    "kernel/function_macros.inc"
        .include    "kernel/object.inc"
        .include    "kernel/scheduler.inc"

        .import     files

        .segment "OSROM"

;;
; Allocate a new File and return a pointer to it.
;
; Stack frame (top to bottm):
;
; |---------------------------------|
; | [4] Space for returned pointer  |
; |---------------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc allocate_file
        _BeginDirectPage
          _StackFrameRTS
          o_filep   .dword
        _EndDirectPage

        _SetupDirectPage
        pha
        pha
        pea     .hiword(files)
        pea     .loword(files)
        pea     NUM_FILES
        pea     .sizeof(File)
        jsr     new_object
        pla
        sta     o_filep
        pla
        sta     o_filep + 2
        bcc     @found
        ldyw    #ENFILE
        bra     @exit
@found: ldaw    #1
        sta     [o_filep]
        ldyw    #0
@exit:  _RemoveParams o_filep
        _SetExitState
        pld
        rts
.endproc

;;
; Release a File. If its reference count goes to zero the File becomes
; available for reallocation.
;
; This function does NOT remove the File from any linked list of which it
; is a part. The caller must take care of this before releasing it.
;
; Stack frame (top to bottm):
;
; |---------------------|
; | [4] Pointer to File |
; |---------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc release_file
        _BeginDirectPage
          _StackFrameRTS
          i_filep   .dword
        _EndDirectPage

        _SetupDirectPage
        lda     [i_filep]
        beq     :+
        dec
        sta     [i_filep]
:       _RemoveParams
        ldaw    #0
        pld
        rts
.endproc
