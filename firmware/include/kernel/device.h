#pragma once

#include <kernel/types.h>
#include <kernel/fs.h>

#define MAX_BLOCK_DEV 16
#define MAX_CHAR_DEV 16

struct block_dev {
  unsigned int major;
  void *ops;
  void *privdata;
};

struct char_dev {
  unsigned int major;
  void *ops;
  void *privdata;
};

struct block_ops {
  int (*open)(struct block_dev *);
  void (*release)(struct block_dev *);
  int (*rdblock)(struct block_dev *, unsigned long sector, void __far *buffer);
  int (*wrblock)(struct block_dev *, unsigned long sector, void __far *buffer);
  int (*ioctl)(struct block_dev *, int request, void __far *data);
  int (*mediachanged)(struct block_dev *);
};

extern struct char_dev char_devices[MAX_CHAR_DEV];
extern struct block_dev block_devices[MAX_BLOCK_DEV];

void device_init(void);
int register_block_device(unsigned int major, struct block_ops *, void *);
int register_char_device(unsigned int major, struct file_ops *, void *);
