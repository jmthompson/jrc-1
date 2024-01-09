/*
 * JRC/OS
 * (C) 2020-2023 Joshua M. Thompson
 */

#include <kernel/console.h>
#include <kernel/fs.h>
#include <kernel/version.h>

extern void monitor_start(void);

const char __far startup_banner[] = "\016lqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk\017\n\016x\017  JRC-1 65816 Single Board Computer  \016x\017\n\016x\017  jrcOS Version %d.%d.%d (%-10.10s)   \016x\017\n\016mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj\017\n\n\0";

void os_start(void)
{
    fs_init();
    console_init();
    printf(startup_banner, JRCOS_MAJOR, JRCOS_MINOR, JRCOS_PATCH, BUILD_DATE);
    while(1) {
        monitor_start();
    }
}
