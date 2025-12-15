#include <defs.h>
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
    sys_exit(error_code);
    cprintf("BUG: exit failed.\n");
    while (1);
}

int
fork(void) {
    return sys_fork();
}

int
wait(void) {
    return sys_wait(0, NULL);
}

int
waitpid(int pid, int *store) {
    return sys_wait(pid, store);
}

void
yield(void) {
    sys_yield();
}

int
kill(int pid) {
    return sys_kill(pid);
}

int
getpid(void) {
    return sys_getpid();
}

int
madvise_dontneed(void *addr, size_t len) {
    return sys_madvise((uintptr_t)addr, len);
}

void *
map_backing(void *addr, size_t len) {
    return (void *)sys_map_backing((uintptr_t)addr, len);
}

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    sys_pgdir();
}

