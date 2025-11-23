# 练习一：分配并初始化一个进程控制块（陈谊斌）

## 设计实现过程
`alloc_proc` 的实现过程如下：

1. **分配空间**：调用 `kmalloc` 为新的 `struct proc_struct` 分配内存空间。
2. **初始化成员变量**：对进程控制块中的各个字段进行初始化，确保新进程处于未初始化状态，包括：
   - 状态设为 `PROC_UNINIT`
   - 进程号 `pid` 设为 -1
   - 运行次数 `runs` 设为 0
   - 内核栈指针 `kstack` 设为 0
   - 是否需要调度 `need_resched` 设为 0
   - 父进程指针 `parent` 设为 NULL
   - 内存管理结构 `mm` 设为 NULL
   - 上下文 `context` 清零
   - 中断帧指针 `tf` 设为 NULL
   - 页表基址 `pgdir` 设为 `boot_pgdir_pa`
   - 标志位 `flags` 设为 0
   - 进程名 `name` 清零
3. **返回结果**：返回初始化后的 `proc_struct` 指针。

## proc_struct中struct context context和struct trapframe *tf成员变量含义和在本实验中的作用
1.  **`struct trapframe *tf` (中断帧指针)**
    *   **含义**: `tf` 指向一个 `trapframe` 结构体，该结构体保存在内核栈上。`trapframe` 用于保存进程/线程在从用户态切换到内核态（例如，由于中断、异常或系统调用）时的完整上下文。这包括所有通用寄存器（`gpr`）、`sstatus` 寄存器（包含了中断使能位等状态）以及 `epc`（异常程序计数器，即返回用户态时要执行的指令地址）。
    *   **作用**:
        *   **保存和恢复现场**: 当发生中断或异常时，硬件或软件会将CPU的当前状态保存到中断帧中，以便内核处理完毕后能够精确地恢复到原来的执行状态，让程序无缝地继续运行。
        *   **新进程/线程的起点**: 在 `do_fork` -> `copy_thread` 的流程中，父进程的 `trapframe` 被复制给子进程。对于新创建的内核线程（如 `kernel_thread`），我们会手动构建一个 `trapframe`，并将其 `epc` 设置为线程的入口函数（`kernel_thread_entry`），这样当新线程第一次被调度执行时，它就会从指定的位置开始运行。对于子进程，我们会修改 `trapframe` 中的 `a0` 寄存器为0，作为 `fork` 系统调用的返回值。

2.  **`struct context context` (上下文)**
    *   **含义**: `context` 结构体保存了内核线程进行上下文切换（context switch）时需要保存和恢复的最小信息。它只包含那些在函数调用过程中需要由被调用者保存的寄存器（callee-saved registers），即 `ra` (返回地址) 和 `s0`-`s11` (通用寄存器)，以及 `sp` (栈指针)。
    *   **作用**:
        *   **内核级线程切换**: `context` 专门用于 `switch_to` 函数，实现内核线程之间的调度和切换。当调度器决定从一个内核线程（`current`）切换到另一个内核线程（`next`）时，`switch_to` 函数会：
            1.  保存 `current` 线程的 `ra` 和 `s0`-`s11` 寄存器到 `current->context` 中。
            2.  从 `next->context` 中加载 `next` 线程的 `ra` 和 `s0`-`s11` 寄存器。
            3.  切换栈指针 `sp`。
        *   **与 `trapframe` 的区别**: `trapframe` 保存的是完整的用户态上下文，用于用户态和内核态之间的切换。而 `context` 只保存内核态执行上下文的一个子集，用于内核线程之间的切换。这种设计更高效，因为在内核线程切换时，我们不需要保存和恢复所有寄存器，只需要保证被调用者保存的寄存器状态不被破坏即可。新线程的 `context.ra` 被设置为 `forkret`，这样在 `switch_to` 之后，新线程会从 `forkret` 函数开始执行，完成后续的初始化工作。

## 总结
`tf` 是**用户态与内核态切换的桥梁**，保存了完整的处理器状态；而 `context` 是**内核线程之间切换的专用工具**，只保存了保持内核函数调用栈正确性所必需的最小寄存器集合。

---

# 练习2：为新创建的内核线程分配资源（单滢锡）
## 一、实验目的
本实验的目标是理解并实现操作系统内核中进程创建（`fork`）的核心机制，通过完成 `do_fork` 函数，使得内核能够创建新的内核线程或用户进程，从而掌握进程控制块`PCB`、内核栈、上下文切换及父子进程关系等操作系统中最基本的进程管理机制。
## 二、实验原理
进程是程序的一次执行过程，系统通过复制已有进程来创建新的执行实体，`do_fork()` 是 `uCore` 实现进程创建的核心函数。其主要任务包括：
分配进程控制块`PCB`
分配内核栈空间
复制父进程的寄存器状态（`trapframe`）
建立父子关系
插入系统进程链表并设为可运行状态
## 三、实验实现
核心函数：`do_fork()`
```c
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf)
{
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;

    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
    }

    ret = -E_NO_MEM;

    // 1. 分配 PCB
    if ((proc = alloc_proc()) == NULL) {
        goto fork_out;
    }

    // 2. 分配内核栈
    if (setup_kstack(proc) != 0) {
        goto bad_fork_cleanup_proc;
    }

    // 3. 拷贝内存信息
    if (copy_mm(clone_flags, proc) != 0) {
        goto bad_fork_cleanup_kstack;
    }

    // 4. 拷贝寄存器与上下文
    copy_thread(proc, stack, tf);

    // 5. 分配 PID、建立父子关系
    proc->pid = get_pid();
    proc->parent = current;

    // 6. 插入链表与哈希表
    hash_proc(proc);
    list_add(&proc_list, &(proc->list_link));

    // 7. 唤醒子进程
    wakeup_proc(proc);

    // 8. 更新进程数
    nr_process++;
    ret = proc->pid;

fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
```
## 四、实验结果

重新编译并运行：
```c
make clean
make qemu
```
输出结果如下：
```c
Special kernel symbols:
entry 0xc020004a (virtual)
etext 0xc0203d34 (virtual)
edata 0xc0209030 (virtual)
end 0xc020d4e4 (virtual)
Kernel executable memory footprint: 54KB
memory management: default_pmm_manager
physical memory map:
memory: 0x08000000, [0x80000000, 0x87ffffff].
vapaofset is 18446744070488326144
check_alloc_page() succeeded!
check_pgdir() succeeded!
check_boot_pgdir() succeeded!
use SLOB allocator
kmalloc_init() succeeded!
check_vma_struct() succeeded!
check_vmm() succeeded.
alloc_proc() correct!
++ setup timer interrupts
```

可以看出系统现在停在：
```c
alloc_proc() correct!
++ setup timer interrupts
```
这说明`alloc_proc()` 和 `do_fork()`（练习一、练习二）都已经正确实现，目前内核已经初始化完所有内存管理、虚拟内存、页表和内核堆分配。
接下来正在初始化定时器中断，但此时还没有进入 `init_main` 线程，原因是调度切换（练习三）还没完成。

## 五、实验问题
Q：请说明`ucore`是否做到给每个新`fork`的线程一个唯一的`id`？请说明你的分析和理由。
A：`uCore` 实现中确实保证了每个新 `fork` 的线程在系统当前运行期间拥有唯一的 `PID`。
在`proc.c`中，`pid`由函数 `get_pid()` 分配，而 `do_fork()` 调用此函数来为每个新创建的线程设置`proc->pid`。（代码是`proc->pid = get_pid()`）
每次调用该函数时，都发生以下的内容：
`last_pid` 自增：尝试下一个可用 `PID`；
越界回绕：若超过 `MAX_PID`，则回绕到 1；
检查冲突：遍历 `proc_list`，判断当前 `PID` 是否已被使用；
若冲突则递增，继续查找；
更新 `next_safe`，加快下次分配时的查找；
返回唯一`PID`。
在`get_pid()` 具体代码中体现如下：
```c
if (++last_pid >= MAX_PID) {
    last_pid = 1;
    goto inside;
}
if (last_pid >= next_safe) {
inside:
    next_safe = MAX_PID;
repeat:
    le = list;
    while ((le = list_next(le)) != list) {
        proc = le2proc(le, list_link);
        if (proc->pid == last_pid) {
            if (++last_pid >= next_safe) {
                if (last_pid >= MAX_PID) {
                    last_pid = 1;
                }
                next_safe = MAX_PID;
                goto repeat;
            }
        } else if (proc->pid > last_pid && next_safe > proc->pid) {
            next_safe = proc->pid;
        }
    }
}
return last_pid;
```
`proc = le2proc(le, list_link)`用来取出链表中的每个进程；然后比较 `proc->pid == last_pid`：如果冲突，就继续加 1；当所有已存在进程的 `PID` 都不等于当前候选 `PID` 时，说明该 `PID` 未被占用；最后函数返回这个唯一的 `last_pid`。
由于在返回之前会完整遍历整个 `proc_list`，确保不会出现与现有进程相同的 `PID`，因此在系统任一时刻，每个进程的 `PID` 都是唯一的。当旧进程退出后，其 `PID` 会被移出 `proc_list`，下一次 `get_pid()` 就可以再次使用该数值。

## 六、实验总结

通过本次实验，我深入理解了操作系统中进程创建机制的底层实现原理，`do_fork` 的实现揭示了一个进程从控制块分配 → 内核栈设置 → 上下文复制 → 调度唤醒的完整生命周期。

# 练习三：编写`proc_run` 函数（刘平）
## 代码编写
```c
void proc_run(struct proc_struct *proc)
{
    if (proc != current)
    {
        // LAB4:EXERCISE3 YOUR CODE
        /*
         * Some Useful MACROs, Functions and DEFINEs, you can use them in below implementation.
         * MACROs or Functions:
         *   local_intr_save():        Disable interrupts
         *   local_intr_restore():     Enable Interrupts
         *   lsatp():                   Modify the value of satp register
         *   switch_to():              Context switching between two processes
         */
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
        
        local_intr_save(intr_flag);
        {
            current = proc;
            lsatp(next->pgdir);
            switch_to(&(prev->context), &(next->context));
        }
        local_intr_restore(intr_flag);
    }
}
```
 检查要切换的进程是否与当前正在运行的进程相同：

```c
if (proc != current)
```
这行代码确保只有当要切换的进程与当前进程不同时才执行切换操作。

禁用中断：

```c
local_intr_save(intr_flag);
```
使用了 `local_intr_save` 宏来禁用中断，保证切换过程的原子性。

切换当前进程为要运行的进程：

```c
current = proc;
```
将全局变量 `current` 更新为要运行的进程。

切换页表，以便使用新进程的地址空间：

```c
lsatp(next->pgdir);
```
使用 `lsatp()` 函数修改 `SATP` 寄存器，切换到新进程的页表。

实现上下文切换：

```c
switch_to(&(prev->context), &(next->context));
```
调用 `switch_to()` 函数实现两个进程的上下文切换。

允许中断：

```c
local_intr_restore(intr_flag);
```
使用 `local_intr_restore` 宏重新启用中断。

## 实验结果
运行`make qemu`,结果如下
```c
Special kernel symbols:
  entry  0xc020004a (virtual)
  etext  0xc0203e94 (virtual)
  edata  0xc0209030 (virtual)
  end    0xc020d4ec (virtual)
Kernel executable memory footprint: 54KB
memory management: default_pmm_manager
physcial memory map:
  memory: 0x08000000, [0x80000000, 0x87ffffff].
vapaofset is 18446744070488326144
check_alloc_page() succeeded!
check_pgdir() succeeded!
check_boot_pgdir() succeeded!
use SLOB allocator
kmalloc_init() succeeded!
check_vma_struct() succeeded!
check_vmm() succeeded.
alloc_proc() correct!
++ setup timer interrupts
this initproc, pid = 1, name = "init"
To U: "Hello world!!".
To U: "en.., Bye, Bye. :)"
kernel panic at kern/process/proc.c:396:
    process exit!!.

Welcome to the kernel debug monitor!!
Type 'help' for a list of commands.
```
运行`make grade`，结果如下
```c
gmake[1]: Entering directory '/root/lab4' + cc kern/init/entry.S + cc kern/init/init.c + cc kern/libs/readline.c + cc kern/libs/stdio.c + cc kern/debug/kdebug.c + cc kern/debug/kmonitor.c + cc kern/debug/panic.c + cc kern/driver/clock.c + cc kern/driver/console.c + cc kern/driver/dtb.c + cc kern/driver/intr.c + cc kern/driver/picirq.c + cc kern/trap/trap.c + cc kern/trap/trapentry.S + cc kern/mm/default_pmm.c + cc kern/mm/kmalloc.c + cc kern/mm/pmm.c + cc kern/mm/vmm.c + cc kern/process/entry.S + cc kern/process/proc.c + cc kern/process/switch.S + cc kern/schedule/sched.c + cc libs/hash.c + cc libs/printfmt.c + cc libs/string.c + ld bin/kernel riscv64-unknown-elf-objcopy bin/kernel --strip-all -O binary bin/ucore.img gmake[1]: Leaving directory '/root/lab4'
  -check alloc proc:                         OK
  -check initproc:                           OK
Total Score: 30/30
```
## 实验问题
根据实验的执行过程和代码分析，在本实验中创建并运行了两个内核线程：

`idleproc`（空闲进程）：

这是系统启动时创建的第一个内核线程
在`proc_init()`函数中通过`alloc_proc()`创建
`PID`为0
主要作用是在没有其他可运行进程时执行空闲循环
`initproc`（初始化进程）：

这是通过`kernel_thread(init_main, "Hello world!!", 0)`创建的第二个内核线程
`PID`为1
执行`init_main`函数，打印欢迎信息后退出
从运行输出可以清楚地看到这两个进程的执行：
```c
alloc_proc() correct!
++ setup timer interrupts
this initproc, pid = 1, name = "init"
To U: "Hello world!!".
To U: "en.., Bye, Bye. :)"
```
第一行表明`idleproc`正在运行（通过`alloc_proc() correct!`检查），第二行显示定时器中断已设置，然后第三行开始显示`initproc`的执行信息（`PID`为1，名称为"`init`"），接着输出了`init_main`函数中的消息。

所以总共创建并运行了2个内核线程。

## 总结
本次实验实现了`proc_run`函数，完成进程上下文切换，加深了对以下内容的理解：
**进程切换流程**：通过检查进程、关开中断、更新`current`、切换页表、调用`switch_to`完成上下文切换，保障切换原子性与正确性。
**内核线程运行**：共创建并运行 2 个内核线程，即 `PID` 为 0 的 `idleproc`（空闲进程）和 `PID` 为 1 的 `initproc`（初始化进程）。
**实验验证**：`make qemu`和`make grade`均显示代码正确，成功实现进程调度功能，加深了对操作系统进程管理和调度机制的理解。

# Challenge1:local_intr_save(intr_flag);....local_intr_restore(intr_flag);实现开关中断的原理
在 `proc_run` 函数中，语句 `local_intr_save(intr_flag);` 和 `local_intr_restore(intr_flag);` 是用来实现**开关中断**的。这些宏的实现依赖于 `sync.h` 文件中的内联函数和宏定义。以下是具体的实现和工作原理：

## **1. `local_intr_save(intr_flag)` 的作用**
- **功能**：保存当前中断状态，并关闭中断。
- **实现**：
  ```c
  #define local_intr_save(x) \
      do {                   \
          x = __intr_save(); \
      } while (0)
  ```
  宏 `local_intr_save(x)` 调用了 `__intr_save()` 函数，并将返回值存储到变量 `x` 中。

- **`__intr_save()` 的实现**：
  ```c
  static inline bool __intr_save(void) {
      if (read_csr(sstatus) & SSTATUS_SIE) { // 检查中断是否启用
          intr_disable();                   // 如果启用，则关闭中断
          return 1;                         // 返回 1 表示之前中断是启用的
      }
      return 0;                             // 返回 0 表示之前中断是关闭的
  }
  ```
  - `read_csr(sstatus)`：读取 `sstatus` 寄存器的值。
  - `SSTATUS_SIE`：这是 `sstatus` 寄存器中的中断使能位。如果该位为 1，表示中断启用；如果为 0，表示中断关闭。
  - `intr_disable()`：关闭中断，通常通过清除 `sstatus` 寄存器中的 `SIE` 位来实现。

## **2. `local_intr_restore(intr_flag)` 的作用**
- **功能**：根据之前保存的中断状态，恢复中断。
- **实现**：
  ```c
  #define local_intr_restore(x) __intr_restore(x);
  ```
  宏 `local_intr_restore(x)` 调用了 `__intr_restore(x)` 函数。

- **`__intr_restore()` 的实现**：
  ```c
  static inline void __intr_restore(bool flag) {
      if (flag) {            // 如果之前中断是启用的
          intr_enable();     // 重新启用中断
      }
  }
  ```
  - `flag` 是之前保存的中断状态。如果 `flag == 1`，表示之前中断是启用的，此时调用 `intr_enable()` 重新启用中断。
  - `intr_enable()`：启用中断，通常通过设置 `sstatus` 寄存器中的 `SIE` 位来实现。

## **3. 开关中断的实现原理**
- **中断的启用和关闭**：
  - 在 RISC-V 架构中，中断的启用和关闭是通过修改 `sstatus` 寄存器中的 `SIE` 位来实现的：
    - `SIE = 1`：启用中断。
    - `SIE = 0`：关闭中断。
  - `intr_disable()` 和 `intr_enable()` 分别用于清除和设置 `SIE` 位。

- **保存和恢复中断状态**：
  - `local_intr_save(intr_flag)` 会检查当前中断状态（通过 `SIE` 位），并将其保存到 `intr_flag` 中，同时关闭中断。
  - `local_intr_restore(intr_flag)` 会根据 `intr_flag` 的值决定是否重新启用中断。

## **4. 在 `proc_run` 中的作用**
在 `proc_run` 函数中，`local_intr_save` 和 `local_intr_restore` 的作用是：
1. **保护临界区**：在进程切换的过程中，必须关闭中断以防止中断处理程序打断上下文切换的过程。
2. **恢复中断状态**：在完成上下文切换后，恢复之前的中断状态，确保系统能够正常响应中断。

## **5. 总结**
- `local_intr_save(intr_flag)`：
  - 保存当前中断状态到 `intr_flag`。
  - 关闭中断，防止中断打断关键操作。
- `local_intr_restore(intr_flag)`：
  - 根据 `intr_flag` 的值恢复中断状态。
- **实现原理**：通过操作 `sstatus` 寄存器中的 `SIE` 位来启用或关闭中断。
- **在 `proc_run` 中的作用**：确保进程切换的关键代码段不被中断打断，同时在切换完成后恢复中断状态。

# Challenge 2 ： 深入理解不同分页模式的工作原理（思考题）
`get_pte()`函数（位于`kern/mm/pmm.c`）用于在页表中查找或创建页表项，从而实现对指定线性地址对应的物理页的访问和映射操作。这在操作系统中的分页机制下，是实现虚拟内存与物理内存之间映射关系非常重要的内容。

## Q1:`get_pte()`函数中有两段形式类似的代码， 结合`sv32`，`sv39`，`sv48`的异同，解释这两段代码为什么如此相像。
`get_pte()`函数的具体内容如下：
```c
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
    if (!(*pdep1 & PTE_V))
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
    }
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
    if (!(*pdep0 & PTE_V))
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
}
```
其中：
```c
pde_t *pdep1 = &pgdir[PDX1(la)];   
if (!(*pdep1 & PTE_V)) { ... 分配/清零下一层页表; *pdep1 = pte_create(..., PTE_U|PTE_V); }
pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)]; if (!(*pdep0 & PTE_V)) { ... 分配/清零下一层页表; *pdep0 = pte_create(..., PTE_U|PTE_V); }
return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)]; 
```
这两段几乎完全相同。这是因为`RISC-V` 多级页表（`SV32/39/48`）每一层的走表逻辑是同构的：即取索引 → 看有效位 `PTE_V` → 如需要且允许 `create` 则分配一个页表页、清零、写入指向下一层的 `PTE` → 进入下一层。
差别只在于层数与各层索引位宽（`SV32` 两层、`SV39` 三层、`SV48` 四层）以及用到的索引宏，所以在 `SV39` 下需要两段中间层几乎相同的代码来走到最后一层（`L0`）并返回最终的 `PTE` 指针。
这相似的两段块分别对应 `L2`→`L1` 和 `L1`→`L0` 的下降；返回处取到 `L0` 的条目 `PTX`。

## Q2:目前`get_pte()`函数将页表项的查找和页表项的分配合并在一个函数里，你认为这种写法好吗？有没有必要把两个功能拆开？
现在的 `get_pte(pgdir, la, create)` 同时承担查找和创建功能。
查找：`create == 0` 时只走表，不分配；
创建：`create == 1` 时遇到缺页表就分配。
现在的优点是调用方简单；内核建表常常需要查不到就建，合并可减少调用层数与判断。
缺点是有些场景（如仅探测映射、做页故障判定）希望只查不改，混在一起可读性与安全性差；并且扩展时更难维护，如果拆开的话会得到一定程度上的解决。
但我认为还是合并起来比较清晰，我们可以提供只查和查建两个api，比如这样：
只查：
```c
 pte_t *pte_lookup(pde_t *pgdir, uintptr_t la) {
    return get_pte(pgdir, la, /*create=*/0);
}
```
查+建：
```c
pte_t *pte_walk_create(pde_t *pgdir, uintptr_t la) {
    return get_pte(pgdir, la, /*create=*/1);
}
```
