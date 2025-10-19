#include "slub.h"
#include <stdio.h>
#include <string.h>
#include <assert.h>

static void t_basic(void) {
    size_t s[] = {1,4,8,15,16,33,64,65,96,127,128,191,192,255,256,383,384,511,512,1024,1536,2048};
    for (int i = 0; i < (int)(sizeof(s)/sizeof(s[0])); ++i) {
        void *p = kmalloc(s[i]);
        assert(p != NULL);
        memset(p, 0xAB, s[i]);
        kfree(p);
    }
    cprintf("[SLUB] basic OK\n");
}

static void t_stress_small(void) {
    const int N = 70;
    void *ptrs[N];
    for (int i = 0; i < N; ++i) {
        size_t sz = (i % 200) + 1;
        ptrs[i] = kmalloc(sz);
        assert(ptrs[i] != NULL);
    }
    for (int i = 0; i < N; i += 2) kfree(ptrs[i]);
    for (int i = 1; i < N; i += 2) kfree(ptrs[i]);
    cprintf("[SLUB] stress small OK\n");
}

static void t_big(void) {
    void *a = kmalloc(PGSIZE * 2);
    void *b = kmalloc(PGSIZE * 3 + 123);
    assert(a && b);
    kfree(a); kfree(b);
    cprintf("[SLUB] big blocks OK\n");
}

static void t_mix(void) {
    void *a = kmalloc(40), *b = kmalloc(2000), *c = kmalloc(384);
    assert(a && b && c);
    memset(a, 0x11, 40);
    memset(c, 0x22, 384);
    kfree(a); kfree(c); kfree(b);
    cprintf("[SLUB] mix OK\n");
}

void slub_selftest(void) {
    t_basic();
    t_stress_small();
    t_big();
    t_mix();
    cprintf("[SLUB] all tests passed!\n");
}
