; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .include  "common.inc"
        .include  "errors.inc"
        .include  "kernel/linker.inc"
        .include  "kernel/memory.inc"
        .include  "kernel/syscall_macros.inc"

        .export   MM_Allocate
        .export   MM_Free

        .import   current_pid
        .import   mm_alloc_internal
        .import   mm_free_internal

        .segment "OSROM"

;;
; Allocate a block of memory
;
; Stack frame (top to bottm):
;
; |---------------------------------|
; | [4] Space for returned pointer  |
; |---------------------------------|
; | [4] Number of bytes to allocate |
; |---------------------------------|
; | [2] Attributes                  |
; |---------------------------------|
;
; On exit:
; c = 0 on success
; c = 1 on failure
;
.proc MM_Allocate

BEGIN_PARAMS
  PARAM i_attr, .word
  PARAM i_size, .dword
  PARAM o_ptr,  .dword
END_PARAMS

        pha
        pha
        lda   i_size + 2
        pha                   ; size (hi)
        lda   i_size
        pha                   ; size (lo)
        lda   i_attr
        pha                   ; attributes
        lda   current_pid
        pha                   ; owner id
        jsr   mm_alloc_internal
        plx
        stx   o_ptr
        plx
        stx   o_ptr + 2
        bcs   @err
        ldaw  #0
@err:   rtl
.endproc

;;
; Free a previously allocated a block of memory
;
; Stack frame (top to bottm):
;
; |---------------------------------|
; | [4] Pointer to block to free    |
; |---------------------------------|
;
; On exit:
; c = 0 on success
; c = 1 on failure
;
.proc MM_Free

BEGIN_PARAMS
  PARAM i_ptr, .dword
END_PARAMS

        lda     i_ptr + 2
        pha
        lda     i_ptr
        pha
        jsr     mm_free_internal
        rtl
.endproc
