/****************************************************************************
 * addfreechunk.c
 *
 *   Copyright (C) 2007, 2009, 2013 Gregory Nutt. All rights reserved.
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

/****************************************************************************
 * Included Files
 ****************************************************************************/

#include "heap.h"

/****************************************************************************
 * Public Functions
 ****************************************************************************/

/****************************************************************************
 * Name: __size2ndx
 *
 * Description:
 *    Convert the size to a nodelist index.
 *
 ****************************************************************************/

int __size2ndx(size_t size)
{
  int ndx = 0;

  if (size >= _MM_MAX_CHUNK)
    {
      return _MM_NNODES - 1;
    }

  size >>= _MM_MIN_SHIFT;
  while (size > 1)
    {
      ndx++;
      size >>= 1;
    }

  return ndx;
}

/****************************************************************************
 * Name: __addfreechunk
 *
 * Description:
 *   Add a free chunk to the node next.
 *
 ****************************************************************************/

void __addfreechunk(struct __heap_s *heap, struct __freenode_s *node)
{
  struct __freenode_s *next;
  struct __freenode_s *prev;
  int ndx;

  /* Convert the size to a nodelist index */

  ndx = __size2ndx(node->size);

  /* Now put the new node into the next */

  for (prev = &heap->nodelist[ndx], next = heap->nodelist[ndx].flink;
       next && next->size && next->size < node->size;
       prev = next, next = next->flink);

  /* Does it go in mid next or at the end? */

  prev->flink = node;
  node->blink = prev;
  node->flink = next;

  if (next)
    {
      /* The new node goes between prev and next */

      next->blink = node;
    }
}
