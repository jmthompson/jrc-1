/****************************************************************************
 * free.c
 *
 *   Copyright (C) 2007, 2009, 2013-2014 Gregory Nutt. All rights reserved.
 *   Author: Gregory Nutt <gnutt@nuttx.org>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 * 3. Neither the name NuttX nor the names of its contributors may be
 *    used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
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

#pragma require __call_heap_initialize

/****************************************************************************
 * Included Files
 ****************************************************************************/

#include <calypsi/config.h>
#include <stdlib.h>
#include "heap.h"

/****************************************************************************
 * Public Functions
 ****************************************************************************/

/****************************************************************************
 * Name: free
 *
 * Description:
 *   Returns a chunk of memory to the list of free nodes,  merging with
 *   adjacent free chunks if possible.
 *
 ****************************************************************************/

void free(void *mem)
{
  struct __heap_s *heap = &__default_heap;
  struct __freenode_s *node;
  struct __freenode_s *prev;
  struct __freenode_s *next;

  /* Protect against attempts to free a NULL reference */
  if (!mem)
    {
      return;
    }

  /* Map the memory chunk into a free node */

  node = (struct __freenode_s *)((char *)mem - _SIZEOF_MM_ALLOCNODE);

  node->preceding &= ~_MM_ALLOC_BIT;

  /* Check if the following node is free and, if so, merge it */

  next = (struct __freenode_s *)((char *)node + node->size);
  if ((next->preceding & _MM_ALLOC_BIT) == 0)
    {
      struct __allocnode_s *andbeyond;

      /* Get the node following the next node (which will
       * become the new next node). We know that we can never
       * index past the tail chunk because it is always allocated.
       */

      andbeyond = (struct __allocnode_s *)
                    ((char *)next + next->size);

      /* Remove the next node.  There must be a predecessor,
       * but there may not be a successor node.
       */

      next->blink->flink = next->flink;
      if (next->flink)
        {
          next->flink->blink = next->blink;
        }

      /* Then merge the two chunks */

      node->size          += next->size;
      andbeyond->preceding =  node->size |
                              (andbeyond->preceding & _MM_ALLOC_BIT);
      next                 = (struct __freenode_s *)andbeyond;
    }

  /* Check if the preceding node is also free and, if so, merge
   * it with this node
   */

  prev = (struct __freenode_s *)((char *)node - node->preceding);
  if ((prev->preceding & _MM_ALLOC_BIT) == 0)
    {
      /* Remove the node.  There must be a predecessor, but there may
       * not be a successor node.
       */

      prev->blink->flink = prev->flink;
      if (prev->flink)
        {
          prev->flink->blink = prev->blink;
        }

      /* Then merge the two chunks */

      prev->size     += node->size;
      next->preceding = prev->size | (next->preceding & _MM_ALLOC_BIT);
      node            = prev;
    }

  /* Add the merged node to the nodelist */
  __addfreechunk(heap, node);
}
