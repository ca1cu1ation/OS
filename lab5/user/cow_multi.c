// user/cow_multi.c
//2312773
#include <ulib.h>
#include <stdio.h>
#include <string.h>

#define PGSIZE 4096
__attribute__((aligned(PGSIZE))) static char buf[PGSIZE * 2];

static void fail(const char *m) { cprintf("FAIL: %s\n", m); exit(-1); }

int main(void) {
    cprintf("=== cow_multi: start ===\n");
    // 初始化：两页不同内容
    memset(buf, 'A', PGSIZE);
    memset(buf + PGSIZE, 'B', PGSIZE);

    int pid = fork();
    if (pid < 0) fail("fork failed");

    if (pid == 0) { // child
        if (buf[0] != 'A' || buf[PGSIZE] != 'B') fail("child wrong init");
        // 只改第二页，触发第二页 COW
        memset(buf + PGSIZE, 'C', PGSIZE);
        cprintf("child wrote second page to C, exiting\n");
        exit(0);
    }

    wait(); // parent 等待
    // 父视角：第一页仍为 A（仍共享且未写），第二页保持 B（父的副本未改）
    if (buf[0] != 'A') fail("parent first page changed");
    if (buf[PGSIZE] != 'B') fail("parent second page changed");
    cprintf("PASS: page0 shared intact, page1 COW isolated\n");
    cprintf("=== cow_multi: done ===\n");
    return 0;
}