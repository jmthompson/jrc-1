#include <errno.h>
#include <stdlib.h>
#include <kernel/console.h>
#include <kernel/block_device.h>
#include <kernel/char_device.h>

struct block_dev *block_devices;
struct char_dev *char_devices;

struct block_dev *find_block_device(unsigned int major)
{
    struct block_dev *p = block_devices;

    while (p != NULL) {
      if (p->major == major) return p;
      p = p->next;
    }

    return NULL;
}

int register_block_device(unsigned int major, struct block_ops *ops, void *privdata)
{
    if (find_block_device(major) != NULL) return -EINVAL;

    struct block_dev *p = malloc(sizeof(struct block_dev));
    if (!p) return -ENOMEM;

    p->next = block_devices;
    block_devices = p;

    return 0;
}

struct char_dev *find_char_device(unsigned int major)
{
    struct char_dev *p = char_devices;

    while (p != NULL) {
      if (p->major == major) return p;
      p = p->next;
    }

    return NULL;
}

int register_char_device(unsigned int major, struct file_ops *ops, void *privdata)
{
    if (find_char_device(major) != NULL) return -EINVAL;

    struct char_dev *p = malloc(sizeof(struct char_dev));
    if (!p) return -ENOMEM;

    p->next = char_devices;
    char_devices = p;

    return 0;
}
