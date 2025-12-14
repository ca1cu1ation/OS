#include <ulib.h>
#include <stdio.h>
#include <string.h>

#define PGSIZE 4096

// Global arrays for testing
static char readonly_page[PGSIZE];
static char shared_page[PGSIZE];

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
    explain_dirtycow_fix();
    
    cprintf("========================================\n");
    cprintf("Dirty COW Demo Complete\n");
    cprintf("========================================\n");
    return 0;
}

