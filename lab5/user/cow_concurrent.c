// Concurrent COW validation: parent and child write the same page at
// different offsets and should observe isolated copies.
//2312773
#include <ulib.h>
#include <stdio.h>
#include <string.h>

#define PGSIZE 4096
__attribute__((aligned(PGSIZE))) static char buf[PGSIZE];

static void fail(const char *m) { cprintf("FAIL: %s\n", m); exit(-1); }

int main(void) {
    const int parent_off = 0;
    const int child_off = PGSIZE / 2;

    cprintf("=== cow_concurrent: start ===\n");
    memset(buf, 'A', sizeof(buf));

    int pid = fork();
    if (pid < 0) {
        fail("fork failed");
    }

    if (pid == 0) {
        // child side: ensure parent's area is untouched, then write its own
        if (buf[parent_off] != 'A') fail("child saw parent write");
        buf[child_off] = 'C'; // trigger COW on this page
        if (buf[parent_off] != 'A') fail("child saw parent write after COW");
        if (buf[child_off] != 'C') fail("child lost its own write");
        exit(0);
    }

    // parent side: wait for child, then ensure isolation
    wait();

    // child write must not affect parent view
    if (buf[child_off] != 'A') fail("parent saw child's write");

    buf[parent_off] = 'P'; // parent write should be private
    if (buf[parent_off] != 'P') fail("parent lost its own write");
    if (buf[child_off] != 'A') fail("parent saw child's write after own COW");

    cprintf("PASS: parent/child writes isolated under COW\n");
    cprintf("=== cow_concurrent: done ===\n");
    return 0;
}
