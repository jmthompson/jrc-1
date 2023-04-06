; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; Data private to the file system code

        .include  "kernel/device.inc"
        .include  "kernel/fs.inc"

        .export     devices, disks, files, inodes, root_inode
        .export     block_buffer

        .segment    "BSS"

devices:        .res    .sizeof(Device) * NUM_DEVICES
disks:          .res    .sizeof(Disk) * NUM_DISKS
files:          .res    .sizeof(File) * NUM_FILES
inodes:         .res    .sizeof(Inode) * NUM_INODES

; The inode corresponding to /
root_inode:     .res    4

; General-purpose block r/w buffer
block_buffer:   .res    512
