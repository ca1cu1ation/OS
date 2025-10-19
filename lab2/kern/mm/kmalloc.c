#include "slub.h"
#include <string.h>

/* size-classes：可按需增删 */
static const size_t kmalloc_sizes[] = {
    8,16,32,64,96,128,192,256,384,512,768,1024,1536,2048
};
#define N_KC (sizeof(kmalloc_sizes)/sizeof(kmalloc_sizes[0]))

static struct kmem_cache *kc[N_KC];

struct bigblk_hdr {
    uint32_t magic;   // SLAB_MAGIC
    uint32_t pages;   // 分配页数
};

static inline int pick_idx(size_t sz) {
    for (int i = 0; i < (int)N_KC; ++i) if (sz <= kmalloc_sizes[i]) return i;
    return -1;
}

void slub_init(void) {
    for (int i = 0; i < (int)N_KC; ++i) {
        kc[i] = slub_create_cache("kmalloc", kmalloc_sizes[i],
                                  sizeof(void*), SLAB_F_NONE);
    }
}

void *kmalloc(size_t sz) {
    if (sz == 0) return NULL;
    int idx = pick_idx(sz);
    if (idx >= 0) return slub_alloc(kc[idx]);

    // ---- 大块：直接按页分配 ----
    size_t need  = sz + sizeof(struct bigblk_hdr);
    size_t pages = (need + PGSIZE - 1) / PGSIZE;
    struct Page *pg = alloc_pages(pages);
    if (!pg) return NULL;

    void *kva = page_to_kva(pg);
    struct bigblk_hdr *h = (struct bigblk_hdr *)kva;
    h->magic = SLAB_MAGIC;
    h->pages = (uint32_t)pages;
    return (void *)((uintptr_t)kva + sizeof(struct bigblk_hdr));
}

void kfree(void *p) {
    if (!p) return;

    // 回到页首，检查大块头
    struct slab_page *sp = obj2slab(p);
    struct bigblk_hdr *h = (struct bigblk_hdr *)((uintptr_t)sp);

    if (h->magic == SLAB_MAGIC && h->pages > 1) {
        free_pages(kva_to_page((void *)h), h->pages);
        return;
    }

    // 小块：交给 SLUB
    slub_free(sp->cache, p);
}
