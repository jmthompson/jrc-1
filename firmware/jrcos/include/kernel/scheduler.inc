;;
; Process support
;
; This is very, very crude right now
;

        .global scheduler_init
        .global scheduler_tick
        .global start_task
        .global sched_yield

; Maximum number of tasks. The main limit here is
; bank $00 space (at least until we can do virtual memory).
MAX_TASKS := 32

; Max FDs per task. Hard coded for now
TASK_MAX_FDS := 16

.struct Task
        pid     .word         ; [+0 ] process ID
        root    .dword        ; [+2 ] Inode of current root
        cwd     .dword        ; [+6 ] Inode of current working directory
        state   .word         ; [+10] task state
        tty     .word         ; [+12] device ID of controlling TTY
        uid     .word         ; [+14] real user ID
        gid     .word         ; [+16] real group ID
        euid    .word         ; [+18] effective user ID
        egid    .word         ; [+20] effective group ID
        sp      .word         ; [+22] stack pointer
        files   .dword        ; [+24] Pointer to file descriptor table
        pad     .dword        ; [+28] pad size to 32 bytes
.endstruct

TASK_UNUSED   := 0            ; marker for empty process table slot
TASK_RUNNABLE := 1
TASK_BLOCKED  := 2
TASK_STOPPED  := 3

TASK_BANK0_SIZE       := 1024
TASK_STACK_DP         := 0
TASK_STACK_SIZE       := TASK_BANK0_SIZE-256
TASK_STACK_TOP        := TASK_BANK0_SIZE-1
