#pragma once

struct block_dev {
    struct block_dev  *next;
    unsigned int      refcount;     // number of references currently held to this device
    unsigned int      major;        // Major device ID
    void *            ops;          // Pointer to operations table
    void *            privdata;     // Pointer to private driver data
};

struct block_ops {
    int (*open)(struct block_dev *);
    void (*release)(struct block_dev *);
    int (*rdblock)(struct block_dev *, unsigned long sector, void *buffer);
    int (*wrblock)(struct block_dev *, unsigned long sector, void *buffer);
    int (*ioctl)(struct block_dev *, int request, void *data);
    int (*mediachanged)(struct block_dev *);
};

extern int bdev_register(unsigned int major, struct block_ops *, void *);
