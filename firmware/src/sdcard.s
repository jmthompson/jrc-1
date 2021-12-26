; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"

        .import spi_select
        .import spi_deselect
        .import spi_transfer
        .import wait_ms

        .export sdcard_driver

        .segment "ZEROPAGE"

device_cmd:
jrtmp:      .res 2

        .segment "BUFFERS"

cmd51:
csd:    .res    16

        .segment "BIOSROM"

SD_DEVICE_ID = 0     ; SPI device ID
SD_CMD_SIZE  = 6     ; acmd flag + cmd byte + 4 byte arg + CRC
SD_FILL      = $ff   ; fill byte

driver_name:
        .byte   "SD Card", $00

sdcard_driver:
        .faraddr driver_name
        .faraddr sdc_init
        .faraddr sdc_status
        .faraddr sdc_format
        .faraddr sdc_rdblock
        .faraddr sdc_wrblock

sdc_init:
        jsr     set_spi_mode
        jsr     set_idle
        bcc     @tryinit
        brl     @error

@tryinit:
        jsr     send_cmd
        .faraddr @cmd08
        bcs     @initv1             ; Might be an older card

        jsl     spi_transfer
        bne     @error
        jsl     spi_transfer
        bne     @error
        jsl     spi_transfer
        cmp     #$01
        bne     @error
        jsl     spi_transfer
        cmp     #$AA
        bne     @error

        ldx     #255
@initv2:
        jsr     deselect
        jsr     send_cmd
        .faraddr @cmd55
        bcs     @initv1

        jsr     deselect
        jsr     send_cmd
        .faraddr @acmd41
        beq     @setblksize
        lda     #15
        jsl     wait_ms
        dex
        bne     @initv2
        bra     @error

@initv1:
        jsr     send_cmd
        .faraddr @cmd01
        bcc     @setblksize
        lda     #15
        jsl     wait_ms
        dex
        bne     @initv1
        bra     @error

@cmd01: .byte   $41,$00,$00,$00,$00,$01
@cmd08: .byte   $48,$00,$00,$01,$AA,$87
@cmd55: .byte   $77,$00,$00,$00,$00,$65
@acmd41: .byte   $69,$40,$00,$00,$00,$01

@setblksize:
        jsr     deselect
        jsr     send_cmd
        .faraddr @cmd16
        bne     @error

        jsr     deselect
        clc
        rtl

@cmd16: .byte   $50,$00,$00,$02,$00,$01

@error: jsr     deselect
        sec
        rtl

; STATUS command, returns a list of all units, their offline status,
; and the device size in sectors

sdc_status:
        jsr     send_cmd
        .faraddr @cmd09
        beq     @ok
@error2:
        jmp     @error

@ok:    jsr     wait_data
        bcs     @error2

        ldx     #0
@read:  lda     #SD_FILL
        jsl     spi_transfer
        sta     csd,X
        inx
        cpx     #16
        bne     @read

        dex
        bit     csd,X           ; check CSD structure bits
        bmi     @error
        bvs     @v1

        stz     csd+6
        lda     csd+7
        and     #%00000011      ; clear reserved bits, just in case
        sta     csd+7

        lda     csd+9
        clc
        adc     #1
        sta     csd+9
        lda     csd+8
        adc     #0
        sta     csd+8
        lda     csd+7
        adc     #0
        sta     csd+7
        lda     csd+6
        adc     #0
        sta     csd+6

        ldx     #9              ; (C_SIZE+1) * 1024 = NR_SECTORS
@mult:  asl     csd+9
        rol     csd+8
        rol     csd+7
        rol     csd+6
        dex
        bpl     @mult

        ldy     #0
        lda     (device_cmd),Y
        sta     jrtmp           ; Set up output buffer pointer in jrtmp
        iny
        lda     (device_cmd),Y
        sta     jrtmp+1
        iny
        lda     #1
        sta     (device_cmd),Y  ; 1 unit

        ldy     #0
        tya
        sta     (jrtmp),Y       ; unit #0
        iny
        tya
        sta     (jrtmp),Y       ; unit is online
        iny
        ldx     #3
@copy2: lda     csd+6,X
        sta     (jrtmp),Y       ; copy block count in LE order
        iny
        dex
        bpl     @copy2

@name:  lda     driver_name-6,Y
        sta     (jrtmp),Y       ; Copy driver name as unit name
        beq     @exit
        iny
        bra     @name

@v1:    ; TODO implement v1 parsing

@error: ldy     #2
        lda     #0
        sta     (device_cmd),Y  ; 0 units
@exit:  jsr     deselect
        clc
        rtl

@cmd09: .byte   $49,$00,$00,$00,$00,$01

sdc_format:
        sec
        rts

sdc_rdblock:
        ldy     #0
        lda     (device_cmd),Y
        beq     @ok             ; only supports unit 0
        sec
        rts

; Build CMD51 with device number in command block

@ok:    lda     #$51
        sta     cmd51
        lda     #$01
        sta     cmd51+5

        ldx     #4
        iny
@copy:  lda     (device_cmd),Y
        sta     cmd51,X
        iny
        dex
        bne     @copy

        ; Coy pblock buffer pointer to jrtmp
        lda     (device_cmd),Y
        sta     jrtmp
        iny
        lda     (device_cmd),Y
        sta     jrtmp+1

        jsr     send_cmd
        .faraddr cmd51
        bne     @error
        jsr     wait_data
        bcc     @recv
@error: jsr     deselect
        sec
        bra     @exit
@recv:  ldy     #0
@recv1: lda     #SD_FILL
        jsl     spi_transfer
        sta     (jrtmp),Y
        iny
        bne     @recv1
        inc     jrtmp+1
@recv2: lda     #SD_FILL
        jsl     spi_transfer
        sta     (jrtmp),Y
        iny
        bne     @recv2
        jsr     deselect
        clc
@exit:  rts

sdc_wrblock:
        sec
        rts

; Put the SD card into SPI mode

set_spi_mode:
        jsr     deselect
        ldx     #10
@loop:  lda     #SD_FILL
        jsl     spi_transfer
        dex
        bne     @loop
        rts

; Tell the SD card to go into the idle state

set_idle:
        ldx     #8
@retry: jsr     send_cmd
        .faraddr @cmd00
        bcc     @r1
        lda     #1
        jsl     wait_ms
        dex
        bne     @retry
@error: jsr     deselect
        sec
        rts
@r1:    cmp     #1                  ; is the idle bit set now?
        bne     @error
        jsr     deselect
        clc
        rts
@cmd00: .byte   $40,$00,$00,$00,$00,$95

; Wait for the SD card to be ready. Returns carry clear on success or set on failure

wait_rdy:
        lda     #$ff
        sta     jrtmp
@loop:  lda     #SD_FILL
        jsl     spi_transfer
        cmp     #SD_FILL
        beq     @ready
        dec     jrtmp
        bne     @loop
        sec
        rts
@ready: clc
        rts

; Wait for data to be ready. Returns carry set on error.

wait_data:
        ldx     #255
@wait:  lda     #SD_FILL
        jsl     spi_transfer
        cmp     #$FE
        beq     @ok
        dex
        bne     @wait
        sec
        rts
@ok:    clc
        rts

; Send a command to the SD card. The pointer to the command to send should be the
; two bytes immediately following the JSR instruction

send_cmd:
        phx
        phy

        tsx
        lda     $0103,X
        sta     jrtmp
        clc
        adc     #2
        sta     $0103,X
        lda     $0104,X
        sta     jrtmp+1
        adc     #0
        sta     $0104,X

        ldy     #2
        lda     (jrtmp),Y
        tax
        dey
        lda     (jrtmp),Y
        sta     jrtmp
        stx     jrtmp+1

        jsr     select

        ldy     #0
@send:  lda     (jrtmp),Y
        jsl     spi_transfer
        iny
        cpy     #SD_CMD_SIZE
        bne     @send
        ldy     #17
@wait:  lda     #SD_FILL
        jsl     spi_transfer
        bpl     @r1
        dey
        bne     @wait
        pha
@error: jsr     deselect
        pla
        sec
        bra     @exit
@r1:    pha
        and     #%01111100  ; see if any of the error bits are set
        bne     @error
        pla
        clc
@exit:  ply
        plx
        ora     #0          ; set N/Z flags for caller
        rts

; Select the SD card interface board

select:
        ldx     #SD_DEVICE_ID
        jsl     spi_select
        rts

; Deselect the SD card interface board

deselect:
        jsl     spi_deselect
        lda     #SD_FILL
        jsl     spi_transfer        ; give SD card time to release DO
        rts
