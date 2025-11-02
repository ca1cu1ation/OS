#include <clock.h>
#include <console.h>
#include <defs.h>
#include <intr.h>
#include <kdebug.h>
#include <kmonitor.h>
#include <pmm.h>
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <dtb.h>

// 测试函数定义
static void test_illegal_instruction(void) {
    cprintf("Testing illegal instruction...\n");
    // 插入一条非法指令，确保正确对齐
    asm volatile(
        ".align 2\n\t"           // 确保4字节对齐
        ".word 0x00000000\n\t"   // 明确的非法指令
        ".align 2"               // 恢复对齐
        ::: "memory"
    );
    cprintf("After illegal instruction\n");
}

static void test_breakpoint(void) {
    cprintf("Testing breakpoint...\n");
    // 插入断点指令，确保正确对齐
    asm volatile(
        ".align 2\n\t"           // 确保4字节对齐
        "ebreak\n\t"             // RISC-V断点指令
        ".align 2"               // 恢复对齐
        ::: "memory"
    );
    cprintf("After breakpoint\n");
}

int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);

int kern_init(void) {
    extern char edata[], end[];
    // 先清零 BSS，再读取并保存 DTB 的内存信息，避免被清零覆盖（为了解释变化 正式上传时我觉得应该删去这句话）
    memset(edata, 0, end - edata);
    dtb_init();
    cons_init();  // init the console
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);

    print_kerninfo();

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table

    pmm_init();  // init physical memory management

    idt_init();  // init interrupt descriptor table

    clock_init();   // init clock interrupt
    intr_enable();  // enable irq interrupt

    // 测试非法指令异常
    test_illegal_instruction();
    
    // 测试断点异常
    test_breakpoint();


    /* do nothing */
    while (1)
        ;
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
    mon_backtrace(0, NULL, NULL);
}

void __attribute__((noinline)) grade_backtrace1(int arg0, int arg1) {
    grade_backtrace2(arg0, (uintptr_t)&arg0, arg1, (uintptr_t)&arg1);
}

void __attribute__((noinline)) grade_backtrace0(int arg0, int arg1, int arg2) {
    grade_backtrace1(arg0, arg2);
}

void grade_backtrace(void) { grade_backtrace0(0, (uintptr_t)kern_init, 0xffff0000); }

