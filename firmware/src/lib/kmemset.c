/**
 * 65816-optimized kmemset implementation.
 * Can only fill up to size_t (64K) bytes at once and cannot cross bank boundaries.
 */

#include <kernel/heap.h>
#include <kernel/types.h>

#define MVP 0x44
#define MVN 0x54
#define PHB 0x8B
#define PLB 0xAB
#define RTL 0x6B

static unsigned char trampoline[6];

void kmemset(void *src, unsigned char fill, size_t count)
{
  const mem_addr_t _src = { .ptr = src };

  trampoline[0] = PHB;
  trampoline[1] = MVN;
  trampoline[2] = trampoline[3] = (unsigned long) _src.bank;
  trampoline[4] = PLB;
  trampoline[5] = RTL;

  *((unsigned char *) src) = fill;
  __asm__(" jsl trampoline\n" ::"Kc"(count - 1), "Kx"(_src.loc), "Ky"(_src.loc + 1) : "c", "x", "y");
}
