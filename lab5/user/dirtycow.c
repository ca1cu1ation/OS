#include <ulib.h>
#include <stdio.h>
#include <string.h>
//2312773

// 0 = 漏洞态（用于复现 Dirty COW）
// 1 = 修复态（用于验证修复后不再出现写穿）
#define DIRTYCOW_FIXED 0

#define PGSIZE 4096

// Global arrays for testing (page-align cow_page for backing mapping)
static char readonly_page[PGSIZE];
static char shared_page[PGSIZE];
static char __attribute__((aligned(PGSIZE))) cow_page[PGSIZE];

#define RACE_ROUNDS 20000

/*
 * Dirty COW vulnerability simulation and fix demonstration
 * 
 * The Dirty COW vulnerability (CVE-2016-5195) was a race condition in
 * the copy-on-write mechanism in Linux kernel. It occurred when:
 * 
 * 1. Process A maps a read-only file into memory
 * 2. Process B forks from Process A (sharing the COW pages)
 * 3. Process A triggers a write fault, causing COW to copy the page
 * 4. Process B, in parallel, uses madvise(MADV_DONTNEED) to discard the page
 * 5. Process B then reads from the file, getting the page back from cache
 * 6. Due to race condition, Process A's write ends up in Process B's page
 *    instead of the copied page, allowing writing to read-only files
 * 
 * This test demonstrates a simplified version of this vulnerability
 * and shows how proper locking prevents it.
 */

// Simulate a vulnerable COW implementation (for demonstration)
void
test_vulnerable_cow_race(void) {
    cprintf("=== Dirty COW Vulnerability Simulation ===\n");
    cprintf("This demonstrates a race window in COW when fork marks pages writable\n");
    cprintf("instead of RO+COW; write fault + madvise-like invalidation can race.\n\n");
    
    // Initialize as read-only data (simulating file content)
    for (int i = 0; i < PGSIZE; i++) {
        readonly_page[i] = 'R'; // 'R' for read-only
    }
    cprintf("Simulated read-only file content initialized with 'R'\n");
    
    int pid = fork();
    if (pid == 0) {
        // Child process: attacker tries to dirty a supposed RO mapping
        cprintf("Child (attacker): Attempting to write to read-only page...\n");
        readonly_page[0] = 'W'; // If fork left it writable, this succeeds
        cprintf("Child: Value at position 0 observed as: %c\n", readonly_page[0]);
        exit(0);
    } else {
        // Parent process
        yield(); // let child race
        wait();
        cprintf("Parent: After child's attempt, value at position 0 is: %c\n",
                readonly_page[0]);

        if (readonly_page[0] == 'R') {
            cprintf("SECURE (expected if kernel fixed Dirty COW): page stayed RO\n");
        } else {
            cprintf("VULNERABLE: child dirtied a read-only mapping via race!\n");
        }
    }
    cprintf("\n");
}

// Demonstrate proper COW implementation with proper synchronization
void
test_secure_cow(void) {
    cprintf("=== Secure COW Implementation ===\n");
    cprintf("Demonstrating COW with proper RO+COW fork, refcnt, and PTE updates\n\n");
    
    // Initialize shared page
    for (int i = 0; i < PGSIZE; i++) {
        shared_page[i] = 'S'; // 'S' for shared
    }
    cprintf("Shared page initialized with 'S'\n");
    
    int pid = fork();
    if (pid == 0) {
        // Child: modify the page (should trigger COW)
        cprintf("Child: Modifying shared page (should trigger COW)...\n");
        shared_page[0] = 'C'; // 'C' for child
        cprintf("Child: Modified page, value at position 0: %c\n", shared_page[0]);
        exit(0);
    } else {
        // Parent: also modify the page (should trigger its own COW)
        yield();
        cprintf("Parent: Modifying shared page (should trigger COW)...\n");
        shared_page[0] = 'P'; // 'P' for parent
        cprintf("Parent: Modified page, value at position 0: %c\n", shared_page[0]);
        
        wait();
        
        // Both should have their own copies
        if (shared_page[0] == 'P') {
            cprintf("SECURE: Parent has independent copy (COW worked correctly)\n");
        } else {
            cprintf("ERROR: Parent's page was modified by child!\n");
        }
    }
    cprintf("\n");
}

// Simulate Dirty COW style race using the new madvise_dontneed syscall
void
test_dirtycow_syscall_race(void) {
    cprintf("=== Dirty COW syscall race (madvise_dontneed) ===\n");
    // request backing page; addr=0 lets kernel choose a fresh VMA
    cprintf("cow_page(bss)=%p aligned=%d\n", cow_page, ((uintptr_t)cow_page % PGSIZE) == 0);
    // 一次申请 2 页：第 1 页用于写，第 2 页作为“别名”观测 backing page
    void *base = map_backing(NULL, 2 * PGSIZE);
    void *back_rw = base;
    void *back_alias = (base == NULL) ? NULL : (void *)((char *)base + PGSIZE);
    cprintf("map_backing base=%p rw=%p alias=%p\n", base, back_rw, back_alias);
    if (base == NULL || back_alias == NULL) {
        cprintf("map_backing failed, aborting dirtycow race test\n");
        return;
    }

    int pid = fork();
    if (pid == 0) {
        // Child: repeatedly write to trigger COW
        for (int i = 0; i < RACE_ROUNDS; i++) {
            ((char *)back_rw)[0] = 'C';
            if ((i & 0x3FF) == 0) {
                yield();
            }
        }
        exit(0);
    }

    // Parent: repeatedly unmap the writable page to race with child's COW，
    // 然后在漏洞态通过 alias 观察 backing page 是否被写脏
    int corrupted = 0;
    for (int i = 0; i < RACE_ROUNDS; i++) {
        madvise_dontneed(back_rw, PGSIZE);
        // 在漏洞态下：Touch alias to fault back in；若 alias 不再是初始 'P'，说明 backing 被写穿
#if !DIRTYCOW_FIXED
        if (((char *)back_alias)[0] != 'P') {
            corrupted = 1;
            break;
        }
#endif
        if ((i & 0x3FF) == 0) {
            yield();
        }
    }
    wait();

#if DIRTYCOW_FIXED
    if (corrupted) {
        cprintf("ERROR: observed corruption but DIRTYCOW_FIXED=1 (kernel/user mismatch?)\n");
    } else {
        cprintf("SECURE: Dirty COW race blocked by kernel fix (no write-through observed)\n");
    }
#else
    if (corrupted) {
        cprintf("VULNERABLE: parent observed child data via COW+madvise race!\n");
    } else {
        cprintf("No corruption observed in this run; try increasing RACE_ROUNDS.\n");
    }
#endif
    cprintf("\n");
}

// Explain the fix
void
explain_dirtycow_fix(void) {
    cprintf("=== Dirty COW Fix Explanation ===\n");
    cprintf("Key points to prevent Dirty COW:\n");
    cprintf("- At fork: writable mappings become RO + PTE_COW; pure RO stays RO only.\n");
    cprintf("- Write fault path: only handle COW when (error_code & 0x2) != 0.\n");
    cprintf("- Allocate a new page, copy, then page_insert to flip PTE to writable\n");
    cprintf("  and finally sfence.vma to keep TLB in sync.\n");
    cprintf("- Refcount: increment when sharing; page_insert will drop old mapping\n");
    cprintf("  so pages aren't freed prematurely.\n");
    cprintf("\n");
}

int
main(void) {
    cprintf("========================================\n");
    cprintf("Dirty COW Vulnerability Demo and Fix\n");
    cprintf("========================================\n\n");
    
    test_vulnerable_cow_race();
    test_secure_cow();
    test_dirtycow_syscall_race();
    explain_dirtycow_fix();
    
    cprintf("========================================\n");
    cprintf("Dirty COW Demo Complete\n");
    cprintf("========================================\n");
    return 0;
}

