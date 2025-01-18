#pragma rtattr initialize="normal"

#include <kernel/heap.h>

struct __init_data {
  void       *dest;
  const void *src;
  size_t           size;
};

void __initialize_sections(struct __init_data *p, struct __init_data *end) {
  while (p < end) {
    if (p->src) {
      kmemcpy(p->dest, p->src, p->size);
    } else {
      kmemset(p->dest, 0, p->size);
    }
    p++;
  }
}
