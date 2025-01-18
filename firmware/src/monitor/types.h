#pragma once

#include <stddef.h>
#include <kernel/types.h>

typedef union {
    unsigned char b[4];
    unsigned int w[2];
    unsigned long l;
} value_t;
