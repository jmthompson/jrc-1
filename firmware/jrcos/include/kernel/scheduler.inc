;;
; Process support
;
; This is very, very crude right now
;

        .global scheduler_start
        .global scheduler_tick
        .global save_context
        .global restore_context
        .global start_task
        .global sched_yield

; Maximum number of processes. The main limit here is
; bank $00 space (at least until we can do virtual memory).
MAX_PROCESSES := 32

; Max FDs per process. Hard coded for now
PROC_MAX_FDS := 16

.struct Process
        pid     .word         ; process ID
        root    .dword        ; Inode of current root
        cwd     .dword        ; Inode of current working directory
        state   .word         ; process state
        tty     .word         ; device ID of controlling TTY
        uid     .word         ; real user ID
        gid     .word         ; real group ID
        euid    .word         ; effective user ID
        egid    .word         ; effective group ID
        sp      .word         ; stack pointer
        files   .dword        ; Pointer to file descriptor table
.endstruct

TASK_UNUSED   := 0            ; marker for empty process table slot
TASK_RUNNABLE := 1
TASK_BLOCKED  := 2
TASK_STOPPED  := 3

TASK_BANK0_SIZE       := 1024
TASK_STACK_DP         := 0
TASK_STACK_SIZE       := TASK_BANK0_SIZE-256
TASK_STACK_TOP        := TASK_BANK0_SIZE-1

