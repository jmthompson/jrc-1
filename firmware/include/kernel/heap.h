#include <kernel/types.h>

void initialize_heap(void *, size_t);
void *kmalloc(unsigned int);
void kfree(void *);
void kmemcpy(void *, const void *, size_t);
void kmemset(void *, unsigned char, size_t);
void dump_heap(void);
