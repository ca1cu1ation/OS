// Basic COW validation: parent initializes two pages, child reads then writes,
// parent must see original data unchanged after child's modifications.
//2312773
#include <ulib.h>
#include <stdio.h>
#include <string.h>

#define PGSIZE 4096

static char buf[PGSIZE * 2];

static void
fail(const char *msg)
{
    cprintf("FAIL: %s\n", msg);
    exit(-1);
}

int
main(void)
{
    cprintf("=== cow_basic: start ===\n");

    // Parent initializes two pages with distinct patterns.
    memset(buf, 'P', PGSIZE);
    memset(buf + PGSIZE, 'Q', PGSIZE);

    int pid = fork();
    if (pid < 0)
    {
        fail("fork failed");
    }
    else if (pid == 0)
    {
        // Child: verify inherited data, then modify to trigger COW.
        if (buf[0] != 'P' || buf[PGSIZE] != 'Q')
        {
            fail("child observed wrong initial data");
        }
        buf[0] = 'C';
        buf[PGSIZE] = 'D';
        cprintf("child wrote C/D, exiting\n");
        exit(0);
    }

    // Parent waits for child and then re-checks its own copy.
    wait();
    if (buf[0] != 'P' || buf[PGSIZE] != 'Q')
    {
        fail("parent data changed after child write (COW broken)");
    }

    cprintf("PASS: parent data intact, COW works\n");
    cprintf("=== cow_basic: done ===\n");
    return 0;
}
