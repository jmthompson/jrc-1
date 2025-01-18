/**
 * This implements a very simple heap system, used by the kernel to manage
 * allocations for things like inodes and open file structures. The heap is
 * assumed to be at less than 64K and does not cross a bank boundary.
 *
 * This is VERY basic for now. Once the OS is more functional I will revisit
 * this and see about optimizing it.
 */

#include <kernel/heap.h>
#include <kernel/console.h>

struct chunk {
  struct chunk *prev;
  struct chunk *next;
  size_t size;
  unsigned int flags;
  char data[1];
};

#define CHUNK_FREE 0x0001
#define HEADER_SIZE 12
#define ALIGN_SIZE 16
#define ALIGN(size) (((size) + (ALIGN_SIZE - 1)) & ~(ALIGN_SIZE - 1))

static struct chunk *head;

static struct chunk *find_free(const size_t size)
{
  for (struct chunk *p = head; p != NULL; p = p->next) {
    if ((p->flags & CHUNK_FREE) && (p->size >= size)) return p;
  }

  return NULL;
}

void split_chunk(struct chunk *chunk, const size_t size)
{
  struct chunk *free_chunk = (struct chunk *)chunk->data + size;

  free_chunk->size = chunk->size - size - HEADER_SIZE;
  free_chunk->flags = CHUNK_FREE;
  free_chunk->next = chunk->next;
  free_chunk->prev = chunk;

  if (free_chunk->next != NULL) free_chunk->next->prev = free_chunk;

  chunk->next = free_chunk;
  chunk->size = size;
}

void merge_free(struct chunk *chunk1, struct chunk *chunk2)
{
  kprintf("Merge %p into %p\n", chunk1, chunk2);
  chunk1->next = chunk2->next;
  if (chunk1->next) chunk1->next->prev = chunk1;
  chunk1->size += chunk2->size + HEADER_SIZE;
}

void initialize_heap(void *heap_start, size_t heap_size)
{
  head = (struct chunk *)heap_start;
  head->prev = NULL;
  head->next = NULL;
  head->size = heap_size - HEADER_SIZE;
  head->flags = CHUNK_FREE;
}

void *kmalloc(const size_t size)
{
  const size_t alloc_size = ALIGN(size);
  struct chunk *chunk = find_free(size);

  if (!chunk) return NULL;

  chunk->flags &= ~CHUNK_FREE;

  // Only split the chunk if the free space is at least enough for one chunk of minimum size
  if (chunk->size > (alloc_size + HEADER_SIZE + ALIGN_SIZE)) split_chunk(chunk, alloc_size);

  return chunk->data;
}

void kfree(void *ptr)
{
  struct chunk *chunk = (struct chunk *)((char *) ptr - HEADER_SIZE);
  chunk->flags |= CHUNK_FREE;

  kprintf("freeing %p (%p)\n", ptr, chunk);
  if (chunk->next && (chunk->next->flags & CHUNK_FREE)) merge_free(chunk, chunk->next);
  if (chunk->prev && (chunk->prev->flags & CHUNK_FREE)) merge_free(chunk->prev, chunk);
}

void dump_heap(void)
{
  kprintf("----\n");
  for (struct chunk *p = head ; p ; p = p->next) {
    kprintf("%p : prev=%p next=%p flags=%04x size=%04x\n", p, p->prev, p->next, p->flags, p->size);
  }

  kprintf("----\n");
}
