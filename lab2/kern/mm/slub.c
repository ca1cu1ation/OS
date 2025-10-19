#include "slub.h"
#ifndef list_entry
// 如果 list.h 里没有定义，就自己补一个
#define list_entry(ptr, type, member) \
    ((type *)((char *)(ptr) - (unsigned long)(&((type *)0)->member)))
#endif

#include <string.h>
#include <stdio.h>

#ifndef ALIGN
#define ALIGN(x,a)  (((x)+((a)-1)) & ~((a)-1))
#endif

static void slab_build_freelist(struct slab_page *sp, void *area, uint32_t unit, uint16_t n) {
    sp->inuse = 0; sp->total = n; sp->free = NULL;
    for (int i = n - 1; i >= 0; --i) {
        void **p = (void **)((uintptr_t)area + (uint32_t)i * unit);
        *p = sp->free; sp->free = (void *)p;
    }
}

static struct slab_page *cache_grow(struct kmem_cache *c) {
    struct Page *pg = alloc_pages(1);
    if (pg == NULL) return NULL;
    void *kva = page_to_kva(pg);

    struct slab_page *sp = (struct slab_page *)kva;
    memset(sp, 0, sizeof(*sp));
    sp->cache = c;
    list_init(&sp->lru);

    uint32_t unit = ALIGN(c->object_size, c->align ? c->align : sizeof(void*));
    uintptr_t area = (uintptr_t)kva + ALIGN(sizeof(struct slab_page), c->align ? c->align : sizeof(void*));
    uint32_t bytes = PGSIZE - (uint32_t)(area - (uintptr_t)kva);
    uint16_t n = bytes / unit;
    if (n == 0) {
        free_pages(pg, 1);
        return NULL;
    }
    c->objs_per_slab = n;
    slab_build_freelist(sp, (void *)area, unit, n);

    list_add(&c->partial, &sp->lru);
    return sp;
}

struct kmem_cache *slub_create_cache(const char *name, size_t size, size_t align, uint16_t flags) {
    // 简化：用一页放 kmem_cache，自身不回收
    struct Page *pg = alloc_pages(1);
    if (!pg) return NULL;
    struct kmem_cache *c = (struct kmem_cache *)page_to_kva(pg);
    memset(c, 0, sizeof(*c));
    c->name = name;
    c->object_size = (uint32_t)size;
    c->align = (uint32_t)(align ? align : sizeof(void*));
    c->flags = flags;
    list_init(&c->partial);
    list_init(&c->full);
    spinlock_init(&c->lock);

    uint32_t unit = ALIGN(c->object_size, c->align);
    uint32_t head = ALIGN(sizeof(struct slab_page), c->align);
    if (head < PGSIZE && unit) {
        c->objs_per_slab = (PGSIZE - head) / unit;
    }
    return c;
}

void slub_destroy_cache(struct kmem_cache *cache) {
    // 简化：不实现销毁（课堂版本够用）
    (void)cache;
}

void *slub_alloc(struct kmem_cache *c) {
    if (!c) return NULL;
    void *obj = NULL;

    bool i = intr_save();          // 关中断临界区（sync.h 通常提供）
    spin_lock(&c->lock);

    if (list_empty(&c->partial)) {
        if (!cache_grow(c)) {
            spin_unlock(&c->lock);
            intr_restore(i);
            return NULL;
        }
    }
    struct slab_page *sp = list_entry(list_next(&c->partial), struct slab_page, lru);

    obj = sp->free;
    if (!obj) { // 理论不该发生
        spin_unlock(&c->lock);
        intr_restore(i);
        return NULL;
    }
    sp->free = *(void **)obj;
    sp->inuse++;

    if (sp->free == NULL) { // slab 满
        list_del(&sp->lru);
        list_add(&c->full, &sp->lru);
    }

    spin_unlock(&c->lock);
    intr_restore(i);
    return obj;
}

void slub_free(struct kmem_cache *c, void *obj) {
    if (!c || !obj) return;
    struct slab_page *sp = obj2slab(obj);

    bool i = intr_save();
    spin_lock(&c->lock);

    // push 回 freelist
    *(void **)obj = sp->free;
    sp->free = obj;
    uint16_t pre = sp->inuse;
    sp->inuse--;

    // 若原本满，现在有空位：full->partial
    if (pre == sp->total) {
        list_del(&sp->lru);
        list_add(&c->partial, &sp->lru);
    }

    // slab 空：直接还页（课堂版策略）
    if (sp->inuse == 0) {
        list_del(&sp->lru);
        spin_unlock(&c->lock);
        intr_restore(i);
        free_pages(kva_to_page((void*)sp), 1);
        return;
    }

    spin_unlock(&c->lock);
    intr_restore(i);
}
