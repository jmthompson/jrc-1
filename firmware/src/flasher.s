; Flash updater for JRC-1 and family
;
; This uses the built-in Xmodem routines to receive a ROM image, which
; is then burned into the EEPROM. Afterwards the system is rebooted.
;
        .include "common.s"
        .include "sys/console.s"

        .import XModemRcv
        .importzp xmptr

        .export flash_update

IMAGE_START = $1000
IMAGE_END   = $8000
ROM_START   = $9000
ROM_PAGES   = $7000 / 64    ; number of EEPROM pages to write
WRITE_RAM   = $0100     ; bottom of application stack

ROM_LOCK1   = $D555     ; Seen by EEPROM as $5555
ROM_LOCK2   = $AAAA     ; Seen by EEPROM as $2AAA

acia_status = $8000
acia_data   = $8001

; We'll use the application zero page

src  = $00  ; source location in RAM
dst  = $02  ; destination location in ROM
last = $04  ; last data read for write cycle polling

        .segment "BIOSROM"

flash_update:
        longm
        ldaw    #IMAGE_START
        sta     xmptr
        shortm
        jsr     XModemRcv
        bcc     @check
        puts    @bad_xfer
        rts
@check: longm
        lda     xmptr
        cmpw    #IMAGE_END
        shortm
        beq     @good
        puts    @bad_image
        rts
@good:  puts    @flashing
        longmx
        ldaw    #0000
        tcd             ; Switch to the application zero page
;        ldxw    #write
;        ldyw    #WRITE_RAM
;        ldaw    #write_end-write
;        mvn     #0, #0          ; Copy ROM writer to RAM so it can run during update
        jmp     WRITE_RAM

@bad_xfer:
        .byte   "Update operation aborted due to transfer error.", $0d, $0d, $00

@bad_image:
        .byte   "Image size is incorret; update aborted.", $0d, $0d, 00

@flashing:
        .byte   "The EEPROM will now be flashed.", $0d
        .byte   "The system will restart once the process is complete.", $0d
        .byte   $00

write:
        sei
        ldaw    #IMAGE_START
        sta     src
        ldaw    #ROM_START
        sta     dst
        shortm
        longx

        ; Disable software data protection
       
        lda     #$AA
        sta     ROM_LOCK1
        lda     #$55
        sta     ROM_LOCK2
        lda     #$80
        sta     ROM_LOCK1
        lda     #$AA
        sta     ROM_LOCK1
        lda     #$55
        sta     ROM_LOCK2
        lda     #$20
        sta     ROM_LOCK1

        ldxw    #ROM_PAGES

        ; Write one 64-byte page

@page:  ldyw    #63
@byte:  lda     (src),y
        sta     (dst),y
        dey
        bpl     @byte

        ; Poll IO6 until it stops flipping

        lda     ROM_START
        and     #%01000000
@wait:  sta     last
        lda     ROM_START
        and     #%01000000
        cmp     last
        bne     @wait

        ; next page

        dex
        beq     @lock
        longm
        lda     src
        clc
        adcw    #64
        sta     src
        lda     dst
        clc
        adcw    #64
        sta     dst
        shortm
        lda     #%00000010
@wait2: bit     acia_status
        beq     @wait2
        lda     #'.'
        sta     acia_data
        bra     @page

        ; Enable software data protection

@lock:  lda     #$AA
        sta     ROM_LOCK1
        lda     #$55
        sta     ROM_LOCK2
        lda     #$A0
        sta     ROM_LOCK1

        ; Wait for lock/write cycle to finish

        lda     ROM_START
        and     #%01000000
@wait3: sta     last
        lda     ROM_START
        and     #%01000000
        cmp     last
        bne     @wait3

        ; and reset the board
        jmp     ($FFFC)
write_end:
