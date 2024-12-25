/****************************************************************************
 * mm/mm_heap/mm_initialize.c
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

#include <calypsi/config.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include "heap.h"

#if defined(__CALYPSI_TARGET_SYSTEM_AMIGA__)
#include <proto/exec.h>
#endif

struct __heap_s __default_heap;

#if defined(__CALYPSI_TARGET_SYSTEM_AMIGA__)
bool __amiga_heap_addregion(struct __heap_s *heap, size_t next_alloc_size)
{
  if (heap->nregions >= _CONFIG_MM_REGIONS)
    {
      return false;
    }
  size_t chunksize = heap->nextsize;

  // Next time we allocate twice as much
  heap->nextsize <<= 1;

  // Ensure we get enough memory this time
  while (next_alloc_size > chunksize + 32)
    {
      chunksize <<= 1;
      if (chunksize == 0)
	{
	  return false;
	}
    }

  APTR memptr = AllocMem(chunksize, 0);
  if (!memptr)
    {
      return false;
    }
  heap->block[heap->nregions] = memptr;
  heap->blocksize[heap->nregions] = chunksize;
  return __heap_addregion(heap, memptr, chunksize);
}

static void amiga_deallocate_memory()
{
  for (unsigned i = 0; i < __default_heap.nregions; i++)
    {
      FreeMem((APTR)__default_heap.block[i], __default_heap.blocksize[i]);
    }
}
#endif

/****************************************************************************
 * Name: __heap_addregion
 *
 * Description:
 *   This function adds a region of contiguous memory to the selected heap.
 *
 * Input Parameters:
 *   heap      - The selected heap
 *   heapstart - Start of the heap region
 *   heapsize  - Size of the heap region
 *
 * Returned Value:
 *   True if successful
 *
 * Assumptions:
 *
 ****************************************************************************/

bool __heap_addregion(struct __heap_s *heap, void *heapstart,
                      size_t heapsize)
{
  struct __freenode_s *node;
  uintptr_t heapbase;
  uintptr_t heapend;
#if _CONFIG_MM_REGIONS > 1
  int IDX = heap->nregions;

  /* Writing past _CONFIG_MM_REGIONS would have catastrophic consequences */
  /* For the Amiga target this is already tested before we get here, so   */
  /* we can omit the test in that case.                                   */
#if !defined(__CALYPSI_TARGET_SYSTEM_AMIGA__)
  DEBUGASSERT(IDX < _CONFIG_MM_REGIONS);
  if (IDX >= _CONFIG_MM_REGIONS)
    {
      return false;
    }
#endif

#else
# define IDX 0
#endif

#if defined(_CONFIG_MM_SMALL) && !defined(_CONFIG_SMALL_MEMORY)
  /* If the MCU handles wide addresses but the memory manager is configured
   * for a small heap, then verify that the caller is  not doing something
   * crazy.
   */

  DEBUGASSERT(heapsize <= MMSIZE_MAX + 1);
#endif

  /* Adjust the provide heap start and size so that they are both aligned
   * with the _MM_MIN_CHUNK size.
   */

  heapbase = _MM_ALIGN_UP((uintptr_t)heapstart);
  heapend  = _MM_ALIGN_DOWN((uintptr_t)heapstart + (uintptr_t)heapsize);
  heapsize = heapend - heapbase;

  /* Add the size of this region to the total size of the heap */

  heap->heapsize += heapsize;

  /* Create two "allocated" guard nodes at the beginning and end of
   * the heap.  These only serve to keep us from allocating outside
   * of the heap.
   *
   * And create one free node between the guard nodes that contains
   * all available memory.
   */

  heap->heapstart[IDX]            = (struct __allocnode_s *)heapbase;
  heap->heapstart[IDX]->size      = _SIZEOF_MM_ALLOCNODE;
  heap->heapstart[IDX]->preceding = _MM_ALLOC_BIT;

  node                               = (struct __freenode_s *)
                                       (heapbase + _SIZEOF_MM_ALLOCNODE);
  node->size                         = heapsize - 2*_SIZEOF_MM_ALLOCNODE;
  node->preceding                    = _SIZEOF_MM_ALLOCNODE;

  heap->heapend[IDX]              = (struct __allocnode_s *)
                                    (heapend - _SIZEOF_MM_ALLOCNODE);
  heap->heapend[IDX]->size        = _SIZEOF_MM_ALLOCNODE;
  heap->heapend[IDX]->preceding   = node->size | _MM_ALLOC_BIT;

#undef IDX

#if _CONFIG_MM_REGIONS > 1
  heap->nregions++;
#endif

  /* Add the single, large free node to the nodelist */

  __addfreechunk(heap, node);

  return true;
}

/****************************************************************************
 * Name: mm_initialize
 *
 * Description:
 *   Initialize the selected heap data structures, providing the initial
 *   heap region.
 *
 * Input Parameters:
 *   heap      - The selected heap
 *   heapstart - Start of the initial heap region
 *   heapsize  - Size of the initial heap region
 *
 * Returned Value:
 *   None
 *
 * Assumptions:
 *
 ****************************************************************************/

void __heap_initialize(struct __heap_s *heap, void *heapstart,
                       size_t heapsize)
{
  unsigned i;

  _CHECK_ALLOCNODE_SIZE;
  _CHECK_FREENODE_SIZE;
  _DEBUGASSERT(_MM_MIN_CHUNK >= _SIZEOF_MM_FREENODE);
  _DEBUGASSERT(_MM_MIN_CHUNK >= _SIZEOF_MM_ALLOCNODE);

  /* Set up global variables */

  heap->heapsize = 0;

#if _CONFIG_MM_REGIONS > 1
  heap->nregions = 0;
#endif

  /* Initialize the node array */

  memset(heap->nodelist, 0, sizeof(struct __freenode_s) * _MM_NNODES);
  for (i = 1; i < _MM_NNODES; i++)
    {
      heap->nodelist[i - 1].flink = &heap->nodelist[i];
      heap->nodelist[i].blink     = &heap->nodelist[i - 1];
    }

#if defined(__CALYPSI_TARGET_SYSTEM_AMIGA__)
  /* Only configure on the Amiga, allocation occurs when first block is requested */
  atexit(amiga_deallocate_memory);
  heap->nextsize = heapsize;
#else
  /* Add the initial region of memory to the heap */
  __heap_addregion(heap, heapstart, heapsize);
#endif
}
