/****************************************************************************
 * heap.h
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.  The
 * ASF licenses this file to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the
 * License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
 * License for the specific language governing permissions and limitations
 * under the License.
 *
 ****************************************************************************/

/****************************************************************************
 *
 * This file has been modified for inclusion in the Calypsi C library.
 *
 * Changes include, but is not limited to, things such as:
 * - Removing FAR style keywords
 * - Changing non-standard symbols to avoid polluting the C library namespace.
 *   Typically it means add two underscores to such symbols.
 * - The way the library is configured has been changed to mostly not use
 *   compile time defines. Remaining CONFIG_XXX symbols have been renamed
 *   to have a leading underscore (underscore plus capital letter) to not
 *   pollute the namespace.
 * - Real time and POSIX style features, such as semaphores have been removed
 *   as this variant is meant to be a standard C library.
 * - Changes have been made to configuraton, some compile-time and some are
 *   dynamically done by internal settings from the Calypsi compiler.
 * - The low level stubs API has been renamed and changed.
 *
 ****************************************************************************/

#ifndef __INCLUDE_HEAP_H
#define __INCLUDE_HEAP_H

/****************************************************************************
 * Included Files
 ****************************************************************************/

#include <calypsi/config.h>

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "b2c.h"

/****************************************************************************
 * Pre-processor Definitions
 ****************************************************************************/

/* Configuration ************************************************************/

/* If the MCU has a small (16-bit) address capability, then we will use
 * a smaller chunk header that contains 16-bit size/offset information.
 * We will also use the smaller header on MCUs with wider addresses if
 * _CONFIG_MM_SMALL is selected.  This configuration is common with MCUs
 * that have a large FLASH space, but only a tiny internal SRAM.
 */

#ifdef _CONFIG_SMALL_MEMORY
  /* If the MCU has a small addressing capability, then force the smaller
   * chunk header.
   */

#  undef  _CONFIG_HEAP_SMALL
#  define _CONFIG_HEAP_SMALL 1
#endif

/* Chunk Header Definitions *************************************************/

/* These definitions define the characteristics of allocator
 *
 * _MM_MIN_SHIFT is used to define _MM_MIN_CHUNK.
 * _MM_MIN_CHUNK - is the smallest physical chunk that can be allocated.  It
 *   must be at least a large as sizeof(struct __freenode_s).  Larger values
 *   may improve performance slightly, but will waste memory due to
 *   quantization losses.
 *
 * _MM_MAX_SHIFT is used to define _MM_MAX_CHUNK
 * _MM_MAX_CHUNK is the largest, contiguous chunk of memory that can be
 *   allocated.  It can range from 16-bytes to 4Gb.  Larger values of
 *   _MM_MAX_SHIFT can cause larger data structure sizes and, perhaps,
 *   minor performance losses.
 */

#if defined(_CONFIG_HEAP_SMALL) && UINTPTR_MAX <= UINT32_MAX
/* Two byte offsets; Pointers may be 2 or 4 bytes;
 * sizeof(struct __freenode_s) is 8 or 12 bytes.
 */

#  define _MM_MIN_SHIFT   B2C_SHIFT( 4)  /* 16 bytes */
#  define _MM_MAX_SHIFT   B2C_SHIFT(15)  /* 32 Kb */

#elif defined(_CONFIG_HAVE_LONG_LONG)
/* Four byte offsets; Pointers may be 4 or 8 bytes
 * sizeof(struct __freenode_s) is 16 or 24 bytes.
 */

#  if UINTPTR_MAX <= UINT32_MAX
#    define _MM_MIN_SHIFT B2C_SHIFT( 4)  /* 16 bytes */
#  elif UINTPTR_MAX <= UINT64_MAX
#    define _MM_MIN_SHIFT B2C_SHIFT( 5)  /* 32 bytes */
#  endif
#  define _MM_MAX_SHIFT   B2C_SHIFT(22)  /*  4 Mb */

#else
/* Four byte offsets; Pointers must be 4 bytes.
 * sizeof(struct __freenode_s) is 16 bytes.
 */

#  define _MM_MIN_SHIFT   B2C_SHIFT( 4)  /* 16 bytes */
#  define _MM_MAX_SHIFT   B2C_SHIFT(22)  /*  4 Mb */
#endif

/* All other definitions derive from these two */

#define _MM_MIN_CHUNK     (1 << _MM_MIN_SHIFT)
#define _MM_MAX_CHUNK     (1L << _MM_MAX_SHIFT)

#define _MM_NNODES        (_MM_MAX_SHIFT - _MM_MIN_SHIFT + 1)

#define _MM_GRAN_MASK     (_MM_MIN_CHUNK-1)
#define _MM_ALIGN_UP(a)   (((a) + _MM_GRAN_MASK) & ~_MM_GRAN_MASK)
#define _MM_ALIGN_DOWN(a) ((a) & ~_MM_GRAN_MASK)

/* An allocated chunk is distinguished from a free chunk by bit 31 (or 15)
 * of the 'preceding' chunk size.  If set, then this is an allocated chunk.
 */

#ifdef _CONFIG_HEAP_SMALL
# define _MM_ALLOC_BIT    0x8000
#else
# define _MM_ALLOC_BIT    0x80000000
#endif
#define _MM_IS_ALLOCATED(n) \
  ((int)((struct __allocnode_s*)(n)->preceding) < 0)

/****************************************************************************
 * Public Types
 ****************************************************************************/

/* Determines the size of the chunk size/offset type */

#ifdef _CONFIG_HEAP_SMALL
typedef uint16_t __heap_size_t;
#  define _MMSIZE_MAX UINT16_MAX
#else
typedef uint32_t __heap_size_t;
#  define _MMSIZE_MAX UINT32_MAX
#endif

/* This describes an allocated chunk.  An allocated chunk is
 * distinguished from a free chunk by bit 15/31 of the 'preceding' chunk
 * size.  If set, then this is an allocated chunk.
 */

struct __allocnode_s
{
  __heap_size_t size;           /* Size of this chunk */
  __heap_size_t preceding;      /* Size of the preceding chunk */
};

/* What is the size of the allocnode? */

#ifdef _CONFIG_HEAP_SMALL
# define _SIZEOF_MM_ALLOCNODE   B2C(4)
#else
# define _SIZEOF_MM_ALLOCNODE   B2C(8)
#endif

#define _CHECK_ALLOCNODE_SIZE \
  _DEBUGASSERT(sizeof(struct __allocnode_s) == _SIZEOF_MM_ALLOCNODE)

/* This describes a free chunk */

struct __freenode_s
{
  __heap_size_t size;              /* Size of this chunk */
  __heap_size_t preceding;         /* Size of the preceding chunk */
  struct __freenode_s *flink; /* Supports a doubly linked list */
  struct __freenode_s *blink;
};

/* What is the size of the freenode? */

#define _MM_PTR_SIZE sizeof(struct __freenode_s *)
#define _SIZEOF_MM_FREENODE (_SIZEOF_MM_ALLOCNODE + 2*_MM_PTR_SIZE)

#define _CHECK_FREENODE_SIZE \
  _DEBUGASSERT(sizeof(struct __freenode_s) == _SIZEOF_MM_FREENODE)

/* This describes one heap (possibly with multiple regions) */

struct __heap_s
{
  size_t heapsize;

  /* This is the first and last nodes of the heap */

  struct __allocnode_s *heapstart[_CONFIG_MM_REGIONS];
  struct __allocnode_s *heapend[_CONFIG_MM_REGIONS];

#if _CONFIG_MM_REGIONS > 1
  int nregions;
#endif

#if defined(__CALYPSI_TARGET_SYSTEM_AMIGA__)
  void *block[_CONFIG_MM_REGIONS];
  size_t blocksize[_CONFIG_MM_REGIONS];
  size_t nextsize;
#endif
  /* All free nodes are maintained in a doubly linked list.  This
   * array provides some hooks into the list at various points to
   * speed searches for free nodes.
   */

  struct __freenode_s nodelist[_MM_NNODES];
};

/****************************************************************************
 * Public Data
 ****************************************************************************/

#if defined(__cplusplus)
extern "C"
{
#endif

/* The default heap */
extern struct __heap_s __default_heap;

void __addfreechunk(struct __heap_s *heap,
                    struct __freenode_s *node);

int __size2ndx(size_t size);
bool __heap_addregion(struct __heap_s *heap, void *heapstart,
                      size_t heapsize);

#if defined(__CALYPSI_TARGET_SYSTEM_AMIGA__)
bool __amiga_heap_addregion(struct __heap_s *heap, size_t next_alloc_size);
#endif

#ifdef __cplusplus
}
#endif

#endif /* __INCLUDE_HEAP_H */
