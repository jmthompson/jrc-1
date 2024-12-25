/****************************************************************************
 * libs/libc/string/lib_memset.c
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

/****************************************************************************
 * Included Files
 ****************************************************************************/

#include <calypsi/config.h>

#include <stdint.h>
#include <string.h>
#include <assert.h>

/****************************************************************************
 * Pre-processor Definitions
 ****************************************************************************/

/* Can't support _CONFIG_MEMSET_64BIT if the platform does not have 64-bit
 * integer types.
 */

#ifndef _CONFIG_HAVE_LONG_LONG
#  undef _CONFIG_MEMSET_64BIT
#endif

/****************************************************************************
 * Public Functions
 ****************************************************************************/

#ifndef _CONFIG_LIBC_ARCH_MEMSET
void *memset(void *s, int c, size_t n)
{
#ifdef _CONFIG_MEMSET_OPTSPEED
  /* This version is optimized for speed (you could do better
   * still by exploiting processor caching or memory burst
   * knowledge.)
   */

  uintptr_t addr  = (uintptr_t)s;
  uint16_t  val16 = ((uint16_t)c << 8) | (uint16_t)c;
  uint32_t  val32 = ((uint32_t)val16 << 16) | (uint32_t)val16;
#ifdef _CONFIG_MEMSET_64BIT
  uint64_t  val64 = ((uint64_t)val32 << 32) | (uint64_t)val32;
#endif

  /* Make sure that there is something to be cleared */

  if (n > 0)
    {
      /* Align to a 16-bit boundary */

      if ((addr & 1) != 0)
        {
          *(uint8_t *)addr = (uint8_t)c;
          addr += 1;
          n    -= 1;
        }

      /* Check if there are at least 16-bits left to be written */

      if (n >= 2)
        {
          /* Align to a 32-bit boundary (we know that the destination
           * address is already aligned to at least a 16-bit boundary).
           */

          if ((addr & 3) != 0)
            {
              *(uint16_t *)addr = val16;
              addr += 2;
              n    -= 2;
            }

#ifndef _CONFIG_MEMSET_64BIT
          /* Loop while there are at least 32-bits left to be written */

          while (n >= 4)
            {
              *(uint32_t *)addr = val32;
              addr += 4;
              n    -= 4;
            }
#else
          /* Check if there are at least 32-bits left to be written */

          if (n >= 4)
            {
              /* Align to a 64-bit boundary (we know that the destination
               * address is already aligned to at least a 32-bit boundary).
               */

              if ((addr & 7) != 0)
                {
                  *(uint32_t *)addr = val32;
                  addr += 4;
                  n    -= 4;
                }

              /* Loop while there are at least 64-bits left to be written */

              while (n >= 8)
                {
                  *(uint64_t *)addr = val64;
                  addr += 8;
                  n    -= 8;
                }
            }
#endif
        }

#ifdef _CONFIG_MEMSET_64BIT
      /* We may get here with n in the range 0..7.  If n >= 4, then we should
       * have 64-bit alignment.
       */

      if (n >= 4)
        {
          *(uint32_t *)addr = val32;
          addr += 4;
          n    -= 4;
        }
#endif

      /* We may get here under the following conditions:
       *
       *   n = 0, addr may or may not be aligned
       *   n = 1, addr is aligned to at least a 16-bit boundary
       *   n = 2, addr is aligned to a 32-bit boundary
       *   n = 3, addr is aligned to a 32-bit boundary
       */

      if (n >= 2)
        {
          *(uint16_t *)addr = val16;
          addr += 2;
          n    -= 2;
        }

      if (n >= 1)
        {
          *(uint8_t *)addr = (uint8_t)c;
        }
    }
#else
  /* This version is optimized for size */

  unsigned char *p = (unsigned char*)s;
  while (n-- > 0) *p++ = c;
#endif
  return s;
}
#endif
