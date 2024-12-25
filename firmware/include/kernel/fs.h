#pragma once

#include <kernel/block_device.h>

/*
 * Disk structure, represents an attached disk. This includes partitions on
 * another Disk.
 */
struct disk {
    int refcount;
    struct block_dev *device;
    struct disk *parent;
    long start_sector;
    long num_sectors;
};

#define IT_FILE 0
#define IT_DIR  1
#define IT_BDEV 2
#define IT_CDEV 3

/*
 * Inode structure. This represents the actual file on disk but in a
 * FS-agnostic way.
 */
struct inode {
    int refcount;
    struct disk *disk;
    long inum;
    int type;
    int mode;
    int uid;
    int gid;
    int major;
    int minor;
};

#define FMODE_READ  1  // file is open for reading
#define FMODE_WRITE 2  // file is open for writing
#define FMODE_SEEK  4  // file is seekable

/*
 * Open file structure. This represents an open instance of an inode.
 *
 * Free files are indicated by a refcount of zero.
 */
struct file {
    int refcount;
    struct inode *inode;
    int mode;
    int flags;
    long pos;
    struct device * device;
    int unit;
    struct file_ops *fops;
};

struct file_ops {
    int (*open)(struct inode *, struct file *);
    void (*release)(struct inode *, struct file *);
    int (*seek)(struct inode *, struct file *);
    int (*read)(struct inode *, struct file *);
    int (*write)(struct inode *, struct file *);
    int (*flush)(struct inode *, struct file *);
    int (*poll)(struct inode *, struct file *);
    int (*ioctl)(struct inode*, struct file *, int request, void *);
};

extern void fs_init(void);
