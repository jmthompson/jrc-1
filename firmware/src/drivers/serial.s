serial_name:
        .asciiz     "serial"

; Serial operations
serial_ops:
        .dword  serial_open
        .dword  serial_release
        .dword  serial_seek
        .dword  serial_read
        .dword  serial_write
        .dword  serial_flush
        .dword  serial_poll
        .dword  serial_ioctl

;;
; Register the SPI device drivers
;
.proc serial_register
        _PushLong serial_name
        _PushWord DEVICE_ID_SERIAL
        _PushLong serial_ops
        _PushLong 0
        jsr     register_device
        rts
.endproc

;-------- FileOperations methods --------;

;;
; Open a serial port.
;
; Stack frame:
;
; |-----------------------|
; | [4] Pointer to File   |
; |-----------------------|
; | [4] Pointer to Inode  |
; |-----------------------|
;
; On exit:
; C,X,Y trashed
;
.proc serial_open
        _BeginDirectPage
          _StackFrameRTL
          i_inodep  .dword
          i_filep   .dword
        _EndDirectPage

        _SetupDirectPage
        ldyw    #File::unit
        lda     [i_filep],y
        cmpw    #2
        blt     @ok
        ldyw    #ENOSYS
        bra     @exit
@ok:    ldyw    #0
@exit:  _RemoveParams
        _SetExitState
        pld
        rtl
.endproc

;;
; Close the console
;
; Stack frame:
;
; |-----------------------|
; | [4] Pointer to File   |
; |-----------------------|
; | [4] Pointer to Inode  |
; |-----------------------|
;
.proc serial_release
        _BeginDirectPage
          _StackFrameRTL
          i_inodep  .dword
          i_filep   .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Seek
;
; Stack frame:
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
; C,X,Y trashed
;
.proc serial_seek
        _BeginDirectPage
          _StackFrameRTL
          i_filep   .dword
          i_whence  .word
          i_offset  .dword
          o_offset  .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams o_offset
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Read from a serial port
;
; Stack frame:
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
.proc serial_read
        _BeginDirectPage
          l_nonblock  .byte
          _StackFrameRTL
          i_filep     .dword
          i_bufferp   .dword
          i_size      .dword
          o_size      .dword
        _EndDirectPage

        _SetupDirectPage
        ldyw    #File::unit
        lda     [i_filep],y
        bne     @s2
        ldaw    #.loword(getc_seriala)
        sta     trampoline + 1
        ldaw    #.hiword(getc_seriala)
        sta     trampoline + 3
        bra     @cont
@s2:    ldaw    #.loword(getc_serialb)
        sta     trampoline + 1
        ldaw    #.hiword(getc_serialb)
        sta     trampoline + 3
@cont:  ldyw    #File::flags
        shortm
        lda     [i_filep],y
        and     #O_NONBLOCK
        sta     l_nonblock
        longm
        stz     o_size
        stz     o_size + 2
@loop:  lda     i_size
        ora     i_size + 2
        beq     @exit
        shortm
@wait:  jsl     trampoline
        bcc     @store
        lda     l_nonblock
        beq     @wait
        longm
        bra     @exit
@store: sta     [i_bufferp]
        longm
        inc32   i_bufferp
        inc32   o_size
        dec32   i_size
        bra     @loop
@exit:  _RemoveParams o_size
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Write to a serial port
;
; Stack frame:
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
.proc serial_write
        _BeginDirectPage
          _StackFrameRTL
          i_filep     .dword
          i_bufferp   .dword
          i_size      .dword
          o_size      .dword
        _EndDirectPage

        _SetupDirectPage
        ldyw    #File::unit
        lda     [i_filep],y
        bne     @s2
        ldaw    #.loword(putc_seriala)
        sta     trampoline + 1
        ldaw    #.hiword(putc_seriala)
        sta     trampoline + 3
        bra     @cont
@s2:    ldaw    #.loword(putc_serialb)
        sta     trampoline + 1
        ldaw    #.hiword(putc_serialb)
        sta     trampoline + 3
@cont:  stz     o_size
        stz     o_size + 2
@loop:  lda     i_size
        ora     i_size + 2
        beq     @exit
        shortm
        lda     [i_bufferp]
        jsl     trampoline
        longm
        inc32   i_bufferp
        inc32   o_size
        dec32   i_size
        bra     @loop
@exit:  _RemoveParams o_size
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Flush serial buffers
;
; Stack frame:
;
; |------------------------------|
; | [4] Pointer to File          |
; |------------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc serial_flush
        _BeginDirectPage
          _StackFrameRTL
          i_filep     .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Serial poll
;
; Stack frame:
;
; |------------------------------|
; | [4] Pointer to File          |
; |------------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc serial_poll
        _BeginDirectPage
          _StackFrameRTL
          i_filep     .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Serial ioctl
;
; Stack frame:
;
; |------------------------------|
; | [4] Pointer to File          |
; |------------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc serial_ioctl
        _BeginDirectPage
          _StackFrameRTL
          i_filep     .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

; --------- Private/internal functions --------

;;
; Get next character from serial channel A. On exit, C=1 if
; no character was available; otherwise, C=0 and the character
; code is in A.
;
getc_seriala:
        phd
        php
        longm
        ldaw    #OS_DP
        tcd
        shortmx
        ldx     rxa_rdi
        cpx     rxa_wri
        beq     @empty
        lda     f:rxa_ibuf,X
        inx
        stx     rxa_rdi
        plp

        pld
        clc
        rtl
@empty: plp
        pld
        sec
        rtl

;;
; Get next character from serial channel B. On exit, C=1 if
; no character was available; otherwise, C=0 and the character
; code is in A.
;
getc_serialb:
        phd
        php
        longm
        ldaw    #OS_DP
        tcd
        shortmx
        ldx     rxb_rdi
        cpx     rxb_wri
        beq     @empty
        lda     f:rxb_ibuf,X
        inx
        stx     rxb_rdi
        plp
        pld
        clc
        rtl
@empty: plp
        pld
        sec
        rtl

;;
; Transmit character in A on serial channel A. This is a blocking
; operation, meaning this function will wait for the Tx FIFO to
; have an empty slot before returning.
;
putc_seriala:
        phd
        php
        longm
        pha
        ldaw    #OS_DP
        tcd
        pla
        shortmx
        ldx     txa_wri
        inx
@wait:  cpx     txa_rdi             ; is the buffer full?
        bne     @store              ; if no then store
        ;wai                        ; yes, so wait for an interrupt to hopefully clear some space
        bra     @wait               ; and then check again
@store: dex
        sta     f:txa_ibuf,x        ; Store the byte in the output buffer
        inx
        stx     txa_wri             ; ... and update write index
        lda     #$80
        tsb     txa_on              ; is the transmitter enabled?
        bne     :+                  ; if yes, we're done
        lda     #nxpcrtxe
        sta     f:nxp_base+nx_cra   ; Enable transmitter
:       plp
        pld
        clc
        rtl

;;
; Transmit character in A on serial channel B. This is a blocking
; operation, meaning this function will wait for the Tx FIFO to
; have an empty slot before returning.
;
putc_serialb:
        phd
        php
        longm
        pha
        ldaw    #OS_DP
        tcd
        pla
        shortmx
        ldx     txb_wri
        inx
@wait:  cpx     txb_rdi             ; is the buffer full?
        bne     @store              ; if no then store
        ;wai                        ; yes, so wait for an interrupt to hopefully clear some space
        bra     @wait               ; and then check again
@store: dex
        sta     f:txb_ibuf,x        ; Store the byte in the output buffer
        inx
        stx     txb_wri             ; ... and update write index
        lda     #$80
        tsb     txb_on              ; is the transmitter enabled?
        bne     :+                  ; if yes, we're done
        lda     #nxpcrtxe
        sta     f:nxp_base+nx_crb   ; Enable transmitter
:       plp
        pld
        clc
        rtl
