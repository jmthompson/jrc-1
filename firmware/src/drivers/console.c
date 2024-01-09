/*
 * JRC/OS
 * (C) 2020-2023 Joshua M. Thompson
 */

#include <errno.h>
#include <kernel/console.h>
#include <kernel/char_device.h>
#include <kernel/fs.h>

static const char __far reset_command[] = "\ec\e[7h\e)0";
static const char __far cls_command[] = "\e[2J";
static const char __far cll_command[] = "\e[2K";

int console_seek(struct inode *, struct file *);
int console_read(struct inode *, struct file *);
int console_write(struct inode *, struct file *);
int console_poll(struct inode *, struct file *);
int console_ioctl(struct inode *, struct file *, int, void *);

struct file_ops console_ops = {
    .seek = console_seek,
    .read = console_read,
    .write = console_write,
    .poll = console_poll,
    .ioctl = console_ioctl
};

void console_init(void)
{
    register_char_device(CONSOLE_MAJOR, &console_ops, NULL);
    console_reset();
    console_clear();
}

void console_reset(void)
{
    printf(reset_command);
}

void console_clear(void)
{
    printf(cls_command);
}

void console_clear_line(void)
{
    printf(cll_command);
}

int console_seek(struct inode *inode, struct file *file)
{
  return 0;
}

int console_read(struct inode *inode, struct file *file)
{
  return 0;
}

int console_write(struct inode *inode, struct file *file)
{
  return 0;
}

int console_poll(struct inode *inode, struct file *file)
{
  return 0;
}

int console_ioctl(struct inode *inode, struct file *file, int request, void *data)
{
  return -ENOTSUP;
}
