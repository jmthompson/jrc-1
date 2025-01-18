#pragma once

#include <stddef.h>
#include <stdint.h>

// Make VSCode stop erroring on custom Calypsi type qualifiers
#ifdef __INTELLISENSE__
#define __tiny
#define __near
#define __far
#define __far24
#define SIMPLE_CALL
#else
#define SIMPLE_CALL __attribute__((simple_call))
#endif

#define true 1
#define false 0

typedef unsigned char __u8;
typedef unsigned int __u16;
typedef unsigned long __u32;
typedef unsigned long long __u64;

typedef signed char __s8;
typedef signed int __s16;
typedef signed long __s32;
typedef signed long long __s64;

/* These are exposed to userspace through syscalls. Should move to another header. */
typedef unsigned int size_t;
typedef signed int ssize_t;

typedef unsigned char bool;

typedef unsigned int mem_loc_t;
typedef unsigned int mem_bank_t;
typedef unsigned char *mem_ptr_t;

typedef union {
  struct {
    mem_loc_t loc;
    mem_bank_t bank;
  };
  mem_ptr_t ptr;
} mem_addr_t;
