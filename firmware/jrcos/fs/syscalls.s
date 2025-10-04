; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/device.inc"
        .include    "kernel/fs.inc"
        .include    "kernel/function_macros.inc"
        .include    "kernel/scheduler.inc"
        .include    "kernel/syscall_macros.inc"

        .export     sys_open, sys_seek, sys_read, sys_write

        .importzp   current_process, currfd, currfile, ptr, tmp

        .segment "OSROM"

;;
; Open a file and return File pointer for it.
;
; Stack frame (top to bottm):
;
; |---------------------------|
; | [2] Space for returned FD |
; |---------------------------|
; | [4] Pointer to pathname   |
; |---------------------------|
; | [2] Flags                 |
; |---------------------------|
; | [2] Mode                  |
; |---------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc sys_open
        .struct
          i_mode    .word
          i_flags   .word
          i_path    .dword
          o_fd      .word
        .endstruct

        ; Get a free fd number in the current process' file table
        ; and store it in currfd
        jsr     get_free_fd
        bcs     @exit
        
        pha
        pha
        _GetParam32 i_path
        phx
        pha
        _GetParam16 i_flags
        pha
        _GetParam16 i_mode
        pha
        jsl     open_file
        bcc     @ok
        ply
        ply
        bra     @exit
@ok:    lda     currfd
        asl
        asl
        clc
        adcw    #Process::files
        tay
        pla
        sta     [current_process],y
        iny
        iny
        pla
        sta     [current_process],y
        lda     currfd
        _PutParam16 o_fd
        ldaw    #0
        clc
@exit:  rtl
.endproc

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
; | [2] File descriptor           |
; |-------------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc sys_seek
        .struct
          i_fd      .word
          i_whence  .word
          i_offset  .dword
          o_offset  .dword
        .endstruct

        _GetParam16 i_fd
        sta   currfd
        jsr   fd_to_file
        bcs   @exit

        pha
        pha
        _PushParam32 i_offset
        _PushParam16 i_whence
        lda   currfile + 2
        pha
        lda   currfile
        pha
        jsl   read_file
        bcc   @ok
        ply
        ply
        bra   @exit
@ok:    _PullParam32 o_offset
        ldaw  #0
        clc
@exit:  rtl
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
; | [2] File descriptor          |
; |------------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc sys_read
        .struct
          i_fd      .word
          i_bufferp .dword
          i_size    .dword
          o_count   .dword
        .endstruct

        _GetParam16 i_fd
        sta   currfd
        jsr   fd_to_file
        bcs   @exit

        pha
        pha
        _PushParam32 i_size
        _PushParam32 i_bufferp
        lda   currfile + 2
        pha
        lda   currfile
        pha
        jsl   read_file
        bcc   @ok
        ply
        ply
        bra   @exit
@ok:    _PullParam32 o_count
        ldaw  #0
        clc
@exit:  rtl
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
; | [2] File descriptor          |
; |------------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C = error code
;
.proc sys_write
        .struct
          i_fd      .word
          i_bufferp .dword
          i_size    .dword
          o_count   .dword
        .endstruct

        _GetParam16 i_fd
        sta   currfd
        jsr   fd_to_file
        bcs   @exit

        pha
        pha
        _PushParam32 i_size
        _PushParam32 i_bufferp
        lda   currfile + 2
        pha
        lda   currfile
        pha
        jsl   write_file
        bcc   @ok
        ply
        ply
        bra   @exit
@ok:    _PullParam32 o_count
        ldaw  #0
        clc
@exit:  rtl
.endproc
