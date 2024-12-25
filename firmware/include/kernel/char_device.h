#pragma once

#include <kernel/fs.h>

struct char_dev {
    struct char_dev *next;
    unsigned int    refcount;   // number of references currently held to this device
    unsigned int    major;      // Major device ID
    void *          ops;        // Pointer to operations table
    void *          privdata;   // Pointer to private driver data
};

extern int register_char_device(unsigned int major, struct file_ops *, void *);
