; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; This module implements some basic functions for dealing with lists of
; reference counted objects.
;

        .include "common.inc"
        .include "errors.inc"
        .include "kernel/function_macros.inc"
        .include "kernel/object.inc"

        .segment "OSROM"

;;
; Find a free entry in a table of objects. If one is found, its reference
; count is incremented and a pointer to the entry is returned.
;
; Stack frame (top to bottm):
;
; |---------------------------------|
; | [4] Space for returned pointer  |
; |---------------------------------|
; | [4] Pointer to object table     |
; |---------------------------------|
; | [2] Number of entries in table  |
; |---------------------------------|
; | [2] Size of entries in bytes    |
; |---------------------------------|
;
; On exit:
; c=0 on success
; c=1 on error
; C,Y trashed
;
.proc new_object
        _BeginDirectPage
          _StackFrameRTS
          i_size        .word
          i_count       .word
          i_table       .dword
          o_entry       .dword
        _EndDirectPage

        _SetupDirectPage
        lda     i_table
        sta     o_entry
        lda     i_table + 2
        sta     o_entry + 2
@search:
        lda     [o_entry]
        beq     @found
        dec     i_count
        beq     @error
        lda     o_entry
        clc
        adc     i_size
        sta     o_entry
        bra     @search
@found: ldaw    #1
        sta     [o_entry]
        ldyw    #0
@exit:  _RemoveParams o_entry
        _SetExitState
        pld
        rts
@error: ldyw    #ERR_OUT_OF_MEMORY
        bra     @exit
.endproc
