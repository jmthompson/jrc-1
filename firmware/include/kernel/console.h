#pragma once

#include <kernel/types.h>

#define CONSOLE_MAJOR   0

/* Definitions for various common ASCII characters */
#define SOH   0x01
#define EOT   0x04
#define ACK   0x06
#define BELL  0x07
#define BS    0x08
#define LF    0x0a
#define CLS   0x0c
#define CR    0x0d
#define NAK   0x15
#define CAN   0x18
#define ESC   0x1b
#define SPC   0x20
#define LBRACKET '['

/* VT-100 codes for shiftin in and out of alternate char set */
#define SHIFT_OUT     14
#define SHIFT_IN      15

int kprintf(const char* format, ...);
int ksprintf(char* buffer, const char* format, ...);
int ksnprintf(char* buffer, size_t count, const char* format, ...);

void console_init(void);
void console_reset(void);
void console_clear(void);
void console_clear_line(void);
