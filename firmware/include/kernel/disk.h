#pragma once

#include <kernel/device.h>

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
