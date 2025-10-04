; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; Filesystem initialization code

        .include    "common.inc"
        .include    "ascii.inc"
        .include    "kernel/console.inc"
        .include    "kernel/scheduler.inc"

        .importzp   current_process
        .import     processes
        .import     monitor_start

        .segment "OSROM"

.proc scheduler_start
        ; One process for now
        ldaw    #.loword(processes)
        sta     current_process
        ldaw    #.hiword(processes)
        sta     current_process + 2

        ;ldaw    #.loword(monitor_start)
        ;ldxw    #.hiword(monitor_start)
        ;jsr     start_task
        jml     monitor_start
.endproc
