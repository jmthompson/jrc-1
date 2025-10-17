;;
; Process support
;
; This is very, very crude right now
;

; Maximum number of tasks. The main limit here is
; bank $00 space (at least until we can do virtual memory).
MAX_TASKS := 32

; Max FDs per task. Hard coded for now
TASK_MAX_FDS := 16

.struct Task
        next    .dword        ; [+0 ] Pointer to next task in list
        pid     .word         ; [+4 ] process ID
        root    .dword        ; [+6 ] Inode of current root
        cwd     .dword        ; [+10] Inode of current working directory
        state   .word         ; [+14] task state
        tty     .word         ; [+16] device ID of controlling TTY
        uid     .word         ; [+18] real user ID
        gid     .word         ; [+20] real group ID
        euid    .word         ; [+22] effective user ID
        egid    .word         ; [+24] effective group ID
        sp      .word         ; [+26] stack pointer
        pad     .dword        ; [+28] pad to 32 bytes
        files   .dword 16     ; [+32] Pointers to file descriptors. The 16 is TASK_MAX_FDS
.endstruct

TASK_UNUSED   := 0            ; marker for empty process table slot
TASK_RUNNABLE := 1
TASK_BLOCKED  := 2
TASK_STOPPED  := 3

TASK_BANK0_SIZE       := 1024
TASK_STACK_DP         := 0
TASK_STACK_SIZE       := TASK_BANK0_SIZE-256
TASK_STACK_TOP        := TASK_BANK0_SIZE-1
