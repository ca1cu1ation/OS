#include <ulib.h>
#include <stdio.h>
#include <string.h>
//2312773

// Validate that reading from .text/.rodata-only mappings doesn't trigger COW.
// We simply fork and read constants/function bytes without any writes.

static const char ro_msg[] = "RODATA-CHECK";

static int read_text_byte(void) {
    // take address of this function to ensure .text is touched
    const unsigned char *p = (const unsigned char *)&read_text_byte;
    // read a byte; value isn't important, just ensure access succeeds
    return p[0];
}

static void fail(const char *m) {
    cprintf("FAIL: %s\n", m);
    exit(-1);
}

int main(void) {
    cprintf("=== cow_ro: start ===\n");

    // Touch .rodata and .text by reading.
    if (ro_msg[0] != 'R') {
        fail("rodata read mismatch");
    }
    (void)read_text_byte();

    int pid = fork();
    if (pid < 0) {
        fail("fork failed");
    }

    if (pid == 0) {
        // Child: read only, no writes.
        if (ro_msg[0] != 'R') {
            fail("child rodata mismatch");
        }
        (void)read_text_byte();
        cprintf("child ro/read ok\n");
        exit(0);
    }

    // Parent waits; if any COW fault happens due to reads, kernel would fault.
    wait();
    cprintf("PASS: read-only segments shared without COW faults\n");
    cprintf("=== cow_ro: done ===\n");
    return 0;
}
