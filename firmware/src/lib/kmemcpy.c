/**
 * 65816-optimized kmemcpy implementation.
 * Can only copy up to size_t (64K) bytes, and cannot cross bank boundaries.
 */

#include <kernel/heap.h>
#include <kernel/types.h>

#define MVP 0x44
#define MVN 0x54
#define PHB 0x8B
#define PLB 0xAB
#define RTL 0x6B

static unsigned char trampoline[6];

void kmemcpy(void *src, const void *dst, size_t count)
{
  const mem_addr_t _src = { .ptr = src };
  const mem_addr_t _dst = { .ptr = (void *) dst };

  trampoline[0] = PHB;
  trampoline[1] = (dst > src) ? MVP : MVN;
  trampoline[2] = _src.bank;
  trampoline[3] = _dst.bank;
  trampoline[4] = PLB;
  trampoline[5] = RTL;

  __asm__(" jsl trampoline\n" ::"Kc"(count - 1), "Kx"(_src.loc), "Ky"(_dst.loc) : "c", "x", "y");
}
