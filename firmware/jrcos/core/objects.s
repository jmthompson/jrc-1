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
        .include "stack.inc"
        .include "kernel/object.inc"

        .segment "OSROM"

;;
; Find a free entry in a table of objects. If one is found, its reference
; count is incremented and a pointer to the entry is returned.
;
; Stack frame (top to bottm):
;
; |---------------------------------|
; | [2] Space for returned pointer  |
; |---------------------------------|
; | [2] Pointer to object table     |
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
i_size := 3
i_count := 5
i_table := 7
o_entry := 9

        lda     i_table,s
        sta     o_entry,s
@search:
        ldyw    #0
        lda     (o_entry,s),y
        beq     @found
        lda     i_count,s
        dec
        sta     i_count,s
        beq     @error
        lda     o_entry,s
        clc
        adc     i_size,s
        sta     o_entry,s
        bra     @search
@found: ldaw    #1
        sta     (o_entry,s),y
        lda     1,s
        sta     7,s
        tsc
        clc
        adcw    #6
        tcs
        ldaw    #0
        clc
        rts
@error: lda     1,s
        sta     7,s
        tsc
        clc
        adcw    #6
        ldaw    #ENOMEM
        sec
        rts
.endproc
