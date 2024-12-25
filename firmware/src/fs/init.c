#include <errno.h>
#include <kernel/console.h>

void disk_scan(void);
void show_disks(void);

void fs_init(void)
{
    disk_scan();
    show_disks();
}

void show_disks(void)
{
}

//@banner:  .byte   ESC, "[4m", "Scanning storage devices", ESC, "[0m", CR, LF, CR, LF, 0
//@mb:      .byte   " MB", CR, LF, 0
//@lf:      .byte   CR,LF,CR,LF,0

void disk_scan(void)
{
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
