#include <errno.h>
#include <kernel/types.h>
#include <kernel/console.h>
#include <kernel/device.h>

static const char __far banner[] = "\x1B[4mScanning storage devices\x1B[0m\n\n";
static const char __far mb[] = " MB\n";
static const char __far lf[] = "\n\n";

void disk_scan(void)
{
  struct block_dev *device = block_devices;

  /*
  ldaw    #.loword(devices)
  sta     l_devicep
  ldaw    #.hiword(devices)
  sta     l_devicep + 2
  ldaw    #NUM_DEVICES
  sta     l_count
@scan:  ldyw    #Device::major
  lda     [l_devicep],y
  bpl     @next               ; skip character devices

  lda     l_devicep + 2
  pha
  lda     l_devicep
  pha
  jsl     bdev_open
@next:  dec     l_count
  beq     @done
  lda     l_devicep
  clc
  adcw    #.sizeof(Device)
  sta     l_devicep
  bra     @scan
  */
}

void show_disks(void) {
}

void fs_init(void)
{
  kprintf(banner);
  disk_scan();
  show_disks();
}
