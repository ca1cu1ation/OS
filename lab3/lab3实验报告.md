## 实验分工

2312773 单滢锡：练习1：完善中断处理

2312819 陈谊斌：扩增练习 Challenge2：理解上下文切换机制

2312424 刘平：扩展练习 Challenge1：描述与理解中断流程 扩展练习Challenge3：完善异常中断  

## 完善中断处理（单滢锡）

### 一、实验目的

本实验的目标是通过定时器中断实现时钟的计数功能，在每100次时钟中断后，输出“100ticks”，并在输出10行后调用系统关机函数 shutdown()，完成定时器中断的中断处理流程。

### 二、实验过程

根据实验要求，我们需要在 trap.c 中实现以下内容：
时钟中断计数：每当时钟中断发生时，我们需要累加一个计数器 ticks。
输出“100ticks”：当 ticks 达到100时，调用 print_ticks() 函数，输出“100ticks”。
计数输出行数：定义一个计数器 print_count，用于记录已打印的次数。当 print_count 达到10时，调用 shutdown() 函数进行系统关机。

### 三、系统中断处理流程

时钟中断触发：每当时钟中断发生，CPU 会跳转到中断处理程序 interrupt_handler()。
处理时钟中断：在 interrupt_handler() 函数中，我们首先调用 clock_set_next_event() 设置下一次时钟中断。然后累加 ticks 计数器。
输出与关机：每当 ticks 达到100时，我们调用 print_ticks() 输出“100ticks”，并将 ticks 重置为0。当打印次数达到10次时，调用 shutdown() 函数关机。

### 四、实验结果

根据改进后的代码，我们运行整个系统时，每秒钟会输出一次“100ticks”，并在输出10行后系统自动关机。

```
OpenSBI v0.4 (Jul  2 2019 11:53:53)
   ____                    _____ ____ _____
  / __ \                  / ____|  _ \_   _|
 | |  | |_ __   ___ _ __ | (___ | |_) || |
 | |  | | '_ \ / _ \ '_ \ \___ \|  _ < | |
 | |__| | |_) |  __/ | | |____) | |_) || |_
  \____/| .__/ \___|_| |_|_____/|____/_____|
        | |
        |_|

Platform Name          : QEMU Virt Machine
Platform HART Features : RV64ACDFIMSU
Platform Max HARTs     : 8
Current Hart           : 0
Firmware Base          : 0x80000000
Firmware Size          : 112 KB
Runtime SBI Version    : 0.1

PMP0: 0x0000000080000000-0x000000008001ffff (A)
PMP1: 0x0000000000000000-0xffffffffffffffff (A,R,W,X)
DTB Init
HartID: 0
DTB Address: 0x82200000
Physical Memory from DTB:
  Base: 0x0000000080000000
  Size: 0x0000000008000000 (128 MB)
  End:  0x0000000087ffffff
DTB init completed
(THU.CST) os is loading ...
Special kernel symbols:
  entry  0xffffffffc0200054 (virtual)
  etext  0xffffffffc0201fe8 (virtual)
  edata  0xffffffffc0207028 (virtual)
  end    0xffffffffc02074a0 (virtual)
Kernel executable memory footprint: 30KB
memory management: default_pmm_manager
physcial memory map:
  memory: 0x0000000008000000, [0x0000000080000000, 0x0000000087ffffff].
check_alloc_page() succeeded!
satp virtual address: 0xffffffffc0206000
satp physical address: 0x0000000080206000
++ setup timer interrupts
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
```

### 五、实验总结

本实验成功地实现了时钟中断处理逻辑，每100次时钟中断后输出一次信息，并在输出10次后关闭系统。通过调用 shutdown() 函数，我们能够模拟系统的自动关机过程。并且在时钟中断的处理中，首先需要设置下一次中断，接着处理计数器，并根据条件输出信息和触发关机。

## 理解上下文切换机制（陈谊斌）

### 汇编代码 `csrw sscratch, sp` 和 `csrrw s0, sscratch, x0` 的作用

1. **`csrw sscratch, sp`**:
   - 将当前的栈指针（`sp`）保存到 `sscratch` 寄存器中。
   - `sscratch` 是一个用户定义的 CSR（Control and Status Register），通常在陷入（trap）时用于保存临时值。

2. **`csrrw s0, sscratch, x0`**:
   - 通过 `csrrw` 指令，将 `sscratch` 的值交换到寄存器 `s0` 中，同时将 `x0`（值为 0）写入 `sscratch`。
   - 这一步的目的是将之前保存的 `sp` 值取回到寄存器 `s0` 中。

### 目的
- 这两条指令的主要目的是在陷入（trap）时保存和恢复栈指针（`sp`）。
- 在陷入时，`sp` 可能会被切换到内核栈或其他上下文，因此需要将其保存到 `sscratch`，以便在需要时恢复。

---

### 关于 `save all` 和 `restore all` 的问题

1. **`save all` 保存了 `stval` 和 `scause`**:
   - 在陷入时，`stval` 和 `scause` 是非常重要的 CSR，它们分别保存了异常的相关信息（如地址）和异常的原因。
   - 保存这些寄存器的目的是为了在陷入处理过程中，能够记录和分析异常的具体情况。

2. **`restore all` 不还原 `stval` 和 `scause`**:
   - `restore all` 的目的是恢复陷入前的寄存器状态，以便返回用户态或之前的上下文。
   - **不还原 `stval` 和 `scause` 的原因**：
     - 这些寄存器的值在陷入时由硬件自动设置，恢复它们没有意义。
     - 在返回用户态时，`stval` 和 `scause` 的值通常已经不再需要，因为它们的作用仅限于异常处理的过程。

---

### `store` 的意义
- 保存 `stval` 和 `scause` 的意义在于：
  1. **调试和分析**：在异常处理过程中，操作系统可以通过读取这些寄存器的值来分析异常的原因和位置。
  2. **多任务环境**：在多任务操作系统中，保存这些寄存器的值可以确保在任务切换时，不会丢失当前任务的异常信息。

- **不还原的合理性**：
  - `stval` 和 `scause` 是只读寄存器，硬件会在每次陷入时自动更新它们的值。
  - 因此，保存它们的值仅用于当前陷入的分析，而不需要在返回时还原。

### 总结
- `csrw sscratch, sp` 和 `csrrw s0, sscratch, x0` 的目的是在陷入时保存和恢复栈指针。
- `save all` 保存 `stval` 和 `scause` 是为了分析异常原因，而 `restore all` 不还原它们是因为它们的值由硬件自动更新，恢复没有意义。

## 描述与理解中断流程(刘平)

### 异常产生到处理流程

1. **异常发生**：当CPU执行指令时遇到异常（如非法指令、断点等）或中断信号
2. **硬件自动处理**：
   - CPU自动将当前PC值保存到`epc`寄存器
   - 将异常原因保存到`scause`寄存器
   - 设置`sstatus`中的SPP位表示异常发生时的特权级
   - 跳转到`stvec`寄存器指向的异常处理入口（在代码中为`__alltraps`）

3. **软件处理流程**：
   - 执行`__alltraps`汇编代码（在trapentry.S中定义）
   - 保存寄存器现场到栈中
   - 调用C语言的`trap`函数处理异常
   - `trap`函数根据异常类型分发给相应的处理函数
   - 处理完成后恢复寄存器现场并返回

### mov a0, sp的目的

`mov a0, sp`指令的目的是将当前栈指针作为参数传递给C语言的trap处理函数。在RISC-V的函数调用约定中，`a0`寄存器用于传递第一个参数。这里的sp指向保存了所有寄存器状态的栈空间，通过这个参数，C语言函数可以访问到完整的`trapframe`结构。

### SAVE_ALL中寄存器在栈中的位置确定

在`SAVE_ALL`宏中，寄存器在栈中的位置是通过精心设计的栈帧布局来确定的。栈帧结构严格按照`trapframe`结构体的定义来组织：

```c
struct trapframe {
    struct pushregs gpr;  // 通用寄存器
    uintptr_t status;     // 状态寄存器
    uintptr_t epc;        // 异常程序计数器
    uintptr_t badvaddr;   // 出错地址
    uintptr_t cause;      // 异常原因
};
```

每个寄存器在栈中的偏移量与`trapframe`结构体中对应成员的偏移量完全一致，这样可以通过结构体指针直接访问栈中的寄存器值。

### 是否需要保存所有寄存器

对于任何中断，`__alltraps`中都需要保存所有寄存器，理由如下：

#### 需要保存所有寄存器的原因：

1. **保持执行状态一致性**：
   - 中断处理完成后需要恢复到中断前的确切状态
   - 如果不保存所有寄存器，可能会破坏被中断程序的执行状态

2. **通用性考虑**：
   - 不同类型的中断可能需要访问不同的寄存器值
   - 事先保存所有寄存器可以确保处理函数有足够的信息进行处理

3. **嵌套中断处理**：
   - 系统可能支持中断嵌套，需要完整保存和恢复上下文

4. **调试和诊断**：
   - 完整的寄存器信息有助于调试和异常分析
   - 如代码中的`print_trapframe`函数需要访问所有寄存器信息

#### 例外情况：

虽然通常需要保存所有寄存器，但在某些特定优化场景下可能会有例外：
- 对于某些确定不会修改寄存器的简单中断处理
- 采用`lazy save/restore`策略的系统

但在ucore的设计中，为了简化和保证正确性，采用了一致的保存所有寄存器的策略。

###  总结

ucore的中断异常处理机制通过硬件自动保存关键状态和软件保存完整寄存器现场的方式，确保了中断处理的正确性和系统稳定性。`mov a0, sp`用于传递trapframe指针，寄存器在栈中的位置严格按照结构体布局确定，而保存所有寄存器是为了保证处理的通用性和正确性。

## 完善异常中断（刘平）

### 代码
根据问题要求，我需要完善 `kern/trap/trap.c` 中的异常处理函数，使其能够正确处理非法指令异常和断点异常，并按指定格式输出相关信息。

```c
void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
        case CAUSE_MISALIGNED_FETCH:
            break;
        case CAUSE_FAULT_FETCH:
            break;
        case CAUSE_ILLEGAL_INSTRUCTION:
             // 非法指令异常处理
             /* LAB3 CHALLENGE3   YOUR CODE :  */
            /*(1)输出指令异常类型（ Illegal instruction）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
            cprintf("Illegal instruction caught at 0x%08x\n", tf->epc);
            cprintf("Exception type: Illegal instruction\n");
            tf->epc += 4; // 跳过当前非法指令，继续执行下一条指令
            break;
        case CAUSE_BREAKPOINT:
            //断点异常处理
            /* LAB3 CHALLLENGE3   YOUR CODE :  */
            /*(1)输出指令异常类型（ breakpoint）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
            cprintf("ebreak caught at 0x%08x\n", tf->epc);
            cprintf("Exception type: breakpoint\n");
            tf->epc += 4; // 跳过断点指令，继续执行下一条指令
            break;
        case CAUSE_MISALIGNED_LOAD:
            break;
        case CAUSE_FAULT_LOAD:
            break;
        case CAUSE_MISALIGNED_STORE:
            break;
        case CAUSE_FAULT_STORE:
            break;
        case CAUSE_USER_ECALL:
            break;
        case CAUSE_SUPERVISOR_ECALL:
            break;
        case CAUSE_HYPERVISOR_ECALL:
            break;
        case CAUSE_MACHINE_ECALL:
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
```

这段代码实现了以下功能：

1. **非法指令异常处理** (`CAUSE_ILLEGAL_INSTRUCTION`):
   - 输出异常类型 "Exception type: Illegal instruction"
   - 按照要求输出 "Illegal instruction caught at 0x(地址)" 格式的信息
   - 更新 `tf->epc` 寄存器，增加4字节跳过当前非法指令

2. **断点异常处理** (`CAUSE_BREAKPOINT`):
   - 输出异常类型 "Exception type: breakpoint"
   - 按照要求输出 "ebreak caught at 0x(地址)" 格式的信息
   - 更新 `tf->epc` 寄存器，增加4字节跳过当前断点指令

这样实现后，当系统遇到非法指令或断点异常时，会按照要求的格式输出异常信息，并通过增加EPC值使程序能够继续执行下一条指令，避免系统崩溃。

### 测试
在 `kern/init/init.c`中增加测试函数
```c
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
```

并在`kern_init`中调用，测试结果如下
```
root@LAPTOP-ECMJ94NP:~/lab3# make qemu

OpenSBI v0.4 (Jul  2 2019 11:53:53)
   ____                    _____ ____ _____
  / __ \                  / ____|  _ \_   _|
 | |  | |_ __   ___ _ __ | (___ | |_) || |
 | |  | | '_ \ / _ \ '_ \ \___ \|  _ < | |
 | |__| | |_) |  __/ | | |____) | |_) || |_
  \____/| .__/ \___|_| |_|_____/|____/_____|
        | |
        |_|

Platform Name          : QEMU Virt Machine
Platform HART Features : RV64ACDFIMSU
Platform Max HARTs     : 8
Current Hart           : 0
Firmware Base          : 0x80000000
Firmware Size          : 112 KB
Runtime SBI Version    : 0.1

PMP0: 0x0000000080000000-0x000000008001ffff (A)
PMP1: 0x0000000000000000-0xffffffffffffffff (A,R,W,X)
DTB Init
HartID: 0
DTB Address: 0x82200000
Physical Memory from DTB:
  Base: 0x0000000080000000
  Size: 0x0000000008000000 (128 MB)
  End:  0x0000000087ffffff
DTB init completed
(THU.CST) os is loading ...
Special kernel symbols:
  entry  0xffffffffc0200054 (virtual)
  etext  0xffffffffc0201f5e (virtual)
  edata  0xffffffffc0207020 (virtual)
  end    0xffffffffc0207490 (virtual)
Kernel executable memory footprint: 30KB
memory management: default_pmm_manager
physcial memory map:
  memory: 0x0000000008000000, [0x0000000080000000, 0x0000000087ffffff].
check_alloc_page() succeeded!
satp virtual address: 0xffffffffc0206000
satp physical address: 0x0000000080206000
++ setup timer interrupts
Testing illegal instruction...
Exception type: Illegal instruction
Illegal instruction caught at 0xc02000a8
After illegal instruction
Testing breakpoint...
Exception type: breakpoint
ebreak caught at 0xc02000c4
After breakpoint
```
测试结果正确。

值得注意的是

RISC-V 的指令编码标准如下（参考《RISC-V Privileged Spec v1.12》）：

| 指令低两位（opcode[1:0]） | 含义                                |
| ------------------ | --------------------------------- |
| `00`、`01`、`10`     | 表示 **合法的 16 位压缩指令**（C-extension）  |
| `11`               | 表示 **标准的 32 位或更长指令（RV32/64/128）** |

但这里的重点是：
**只有在支持 C 扩展时（即实现了压缩指令集），“00/01/10” 才表示合法的 16 位指令。**

在实验的 uCore 环境中：

* 并不启用 C 扩展（即无压缩指令支持）；
* 所以 **任何低两位不是 `11` 的指令都应该视为非法 32 位指令**；
* 因此，我们应当让异常处理逻辑识别 “非法压缩指令模式”，统一按 4 字节跳过。

故实验中没考虑跳过两字节

