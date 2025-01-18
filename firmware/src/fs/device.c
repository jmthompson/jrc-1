#include <errno.h>
#include <kernel/types.h>
#include <kernel/console.h>
#include <kernel/device.h>

struct block_dev block_devices[MAX_BLOCK_DEV];
struct char_dev char_devices[MAX_CHAR_DEV];

void device_init(void)
{

}
int register_block_device(unsigned int major, struct block_ops *ops, void *privdata)
{
  if (block_devices[major].ops != NULL) return -EINVAL;

  block_devices[major].major = major;
  block_devices[major].ops = ops;
  block_devices[major].privdata = privdata;

  return 0;
}

int register_char_device(unsigned int major, struct file_ops *ops, void *privdata)
{
  if (char_devices[major].ops != NULL) return -EINVAL;

  char_devices[major].major = major;
  char_devices[major].ops = ops;
  char_devices[major].privdata = privdata;

  return 0;
}
