#ifndef __KERN_MM_SLUB_H__
#define __KERN_MM_SLUB_H__

#include <defs.h>
#include <memlayout.h>
#include <pmm.h>
#include <list.h>

/* —— 没有 sync.h 时的“无锁”占位实现 —— */
typedef int spinlock_t;
#define spinlock_init(l)  ((void)0)
#define spin_lock(l)      ((void)0)
#define spin_unlock(l)    ((void)0)
#define intr_save()       (0)
#define intr_restore(x)   ((void)0)

/* 魔数：用于大块 kmalloc 头部识别 */
#define SLAB_MAGIC   0x51AB51ABu
/* flags：课堂版只用到 NONE，给成 0 即可 */
#define SLAB_F_NONE  0

/* ---- 通用 VA/PA/Page helper（给 kmalloc.c/slub.c 共用） ---- */
// 由 pmm.c 提供
extern uint64_t va_pa_offset;

/* Page* <-> KVA 辅助函数（用 VA = PA + va_pa_offset） */
static inline void *page_to_kva(struct Page *p) {
    return (void *)((uintptr_t)page2pa(p) + va_pa_offset);
}
static inline struct Page *kva_to_page(void *k) {
    return pa2page((uintptr_t)k - va_pa_offset);
}


static inline void *page_aligned(void *p) {
    return (void *)((uintptr_t)p & ~(PGSIZE - 1));
}
static inline struct slab_page *obj2slab(void *obj) {
    return (struct slab_page *)page_aligned(obj);
}


struct kmem_cache;

typedef struct slab_page {
    struct kmem_cache *cache;   // 所属 cache
    void *free;                 // freelist 头（嵌入对象首字）
    uint16_t inuse;             // 已使用对象数
    uint16_t total;             // 对象总数
    list_entry_t lru;           // partial/full 链
} slab_page_t;

typedef struct kmem_cache {
    const char *name;
    uint32_t object_size;
    uint32_t align;
    uint16_t flags;
    uint16_t objs_per_slab;

    list_entry_t partial;
    list_entry_t full;

    spinlock_t lock;            // 占位锁（单核够用）
} kmem_cache_t;

kmem_cache_t *slub_create_cache(const char *name, size_t size, size_t align, uint16_t flags);
void slub_destroy_cache(kmem_cache_t *cache);

void *slub_alloc(kmem_cache_t *cache);
void  slub_free(kmem_cache_t *cache, void *obj);

void slub_init(void);

void *kmalloc(size_t size);
void  kfree(void *ptr);

void slub_selftest(void);

#endif /* __KERN_MM_SLUB_H__ */
