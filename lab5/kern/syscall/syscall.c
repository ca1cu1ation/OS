#include <unistd.h>
#include <proc.h>
#include <syscall.h>
#include <trap.h>
#include <stdio.h>
#include <pmm.h>
#include <assert.h>
#include <vmm.h>

static int
sys_exit(uint64_t arg[]) {
    int error_code = (int)arg[0];
    return do_exit(error_code);
}

static int
sys_fork(uint64_t arg[]) {
    struct trapframe *tf = current->tf;
    uintptr_t stack = tf->gpr.sp;
    return do_fork(0, stack, tf);
}

static int
sys_wait(uint64_t arg[]) {
    int pid = (int)arg[0];
    int *store = (int *)arg[1];
    return do_wait(pid, store);
}

static int
sys_exec(uint64_t arg[]) {
    const char *name = (const char *)arg[0];
    size_t len = (size_t)arg[1];
    unsigned char *binary = (unsigned char *)arg[2];
    size_t size = (size_t)arg[3];
    return do_execve(name, len, binary, size);
}

static int
sys_yield(uint64_t arg[]) {
    return do_yield();
}

static int
sys_kill(uint64_t arg[]) {
    int pid = (int)arg[0];
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
}

static int
sys_putc(uint64_t arg[]) {
    int c = (int)arg[0];
    cputchar(c);
    return 0;
}

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}

static int
sys_madvise(uint64_t arg[])
{
    uintptr_t addr = (uintptr_t)arg[0];
    size_t len = (size_t)arg[1];
    return do_madvise_dontneed(current->mm, addr, len);
}

static intptr_t
sys_map_backing(uint64_t arg[])
{
    uintptr_t addr = (uintptr_t)arg[0];
    size_t len = (size_t)arg[1];
    return do_map_backing(current->mm, addr, len);
}

static intptr_t (*syscalls[])(uint64_t arg[]) = {
    [SYS_exit]              (intptr_t (*)(uint64_t[]))sys_exit,
    [SYS_fork]              (intptr_t (*)(uint64_t[]))sys_fork,
    [SYS_wait]              (intptr_t (*)(uint64_t[]))sys_wait,
    [SYS_exec]              (intptr_t (*)(uint64_t[]))sys_exec,
    [SYS_yield]             (intptr_t (*)(uint64_t[]))sys_yield,
    [SYS_kill]              (intptr_t (*)(uint64_t[]))sys_kill,
    [SYS_getpid]            (intptr_t (*)(uint64_t[]))sys_getpid,
    [SYS_putc]              (intptr_t (*)(uint64_t[]))sys_putc,
    [SYS_pgdir]             (intptr_t (*)(uint64_t[]))sys_pgdir,
    [SYS_madvise]           (intptr_t (*)(uint64_t[]))sys_madvise,
    [SYS_map_backing]       sys_map_backing,
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
    struct trapframe *tf = current->tf;
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
        if (syscalls[num] != NULL) {
            arg[0] = tf->gpr.a1;
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
            return ;
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}

