;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Filesystem structures for tracking dentries, inodes, and files              ;
;                                                                             ;
; Heavily inspired by the Linux kernel, but greatly simplified for limited    ;
; hardware resources                                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        .global fs_init
        .global allocate_disk, attach_disk
        .global partition_scan
        .global open_file, read_file, write_file, allocate_file
        .global get_free_fd, fd_to_file
        .global get_inode, put_inode, lookup_inode  

;;
; Disk structure, represents an attached disk. This includes partitions on
; another Disk.
;
; Free disks are indicated by a refcount of zero.
;
.struct Disk
        refcount      .word   ; number of references currently held to this volume
        device        .dword  ; Pointer to owning Device
        parent        .dword  ; Pointer to parent Disk if this is a partition
        start_sector  .dword  ; Starting sector of partition
        num_sectors   .dword  ; Size in sectors
.endstruct

;;
; Maximum number of supported online disks
NUM_DISKS := 8

;;
; Inode structure. This represents the actual file on disk but in a FS-agnostic
; way.
;
; Free inodes are indicated by a refcount of zero.
;
.struct Inode
        refcount  .word       ; number of references currently held to this inode
        disk      .dword      ; Pointer to owning Disk
        num       .dword      ; inode number
        type      .word       ; File type (one of IT_xxxx)
        mode      .word       ; file mode bits
        uid       .word       ; user id
        gid       .word       ; group id
        major     .word       ; device major ID for IT_BDEV/IT_CDEV
        minor     .word       ; device minor ID for IT_BDEV/IT_CDEV
.endstruct

NUM_INODES := 64

IT_FILE   := 0
IT_DIR    := 1
IT_BDEV   := 2
IT_CDEV   := 3

;;
; Open file structure. This represents an open instance of an inode.
;
; Free files are indicated by a refcount of zero.
;
.struct File
        refcount  .word       ; number of references currently held to this file
        inode     .dword      ; Pointer to Inode representing this file
        mode      .word       ; file mode bits
        flags     .word       ; open mode flags
        pos       .word       ; current read/write position
        device    .dword      ; Device pointer, if this is an open device
        unit      .word       ; unit number, if this is an open device
        ops       .dword      ; Pointer to FileOperations structure
.endstruct

NUM_FILES   := 128

FMODE_READ  := 1  ; file is open for reading
FMODE_WRITE := 2  ; file is open for writing
FMODE_SEEK  := 4  ; file is seekable

;;
; The FileOerations structure is a table of pointers to functions that
; implement file access functions.
;
.struct FileOperations
        open          .dword      ; Pointer to open function
        release       .dword      ; Pointer to release function
        seek          .dword      ; Pointer to seek function
        read          .dword      ; Pointer to read function
        write         .dword      ; Pointer to write function
        flush         .dword      ; Pointer to flush function
        poll          .dword      ; Pointer to poll function
        ioctl         .dword      ; Pointer to ioctl function
.endstruct

