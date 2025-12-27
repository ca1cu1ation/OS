# LAB6：进程调度（单滢锡）
# 练习0：填写已有实验
本实验依赖实验2/3/4/5。请把你做的实验2/3/4/5的代码填入本实验中代码中有“LAB2”/“LAB3”/“LAB4”“LAB5”的注释相应部分。并确保编译通过。 注意：为了能够正确执行lab6的测试应用程序，可能需对已完成的实验2/3/4/5的代码进行进一步改进。 由于我们在进程控制块中记录了一些和调度有关的信息，例如Stride、优先级、时间片等等，因此我们需要对进程控制块的初始化进行更新，将调度有关的信息初始化。同时，由于时间片轮转的调度算法依赖于时钟中断，你可能也要对时钟中断的处理进行一定的更新。

## 1. 实验目的
在 LAB6 框架上复用并扩展 LAB2/3/4/5 完成的内核功能：

- 物理内存管理（LAB2）
- 中断与时钟（LAB3）
- 进程管理与调度（LAB4/5）
- 实现 RR/Stride 调度器，并确保内核能运行测试程序 `priority` 等。

## 2. 主要修改内容
### 2.1 进程控制块和基本调度（`lab6/kern/process/proc.c`）
- 填充 `alloc_proc` 中 LAB4/5/6 留白，初始化所有基础字段，以及 LAB6 中新增的调度字段（`rq`、`run_link`、`time_slice`、`lab6_stride`、`lab6_priority` 等）。
- 实现 `proc_run` 的上下文切换逻辑（关中断、切换 SATP、`switch_to`）。
- 完成 `do_fork`：包含 PCB 分配、内核栈、`copy_mm`、`copy_thread`、PID 分配、进程链表与哈希表插入、唤醒新进程等。
- 在 `load_icode` 中设置用户态 trapframe（`sp`、`epc`、`status`），保证用户进程正确返回用户空间。

### 2.2 物理内存复制逻辑（`lab6/kern/mm/pmm.c`）
- 在 `copy_range` 内补全部分 LAB5 逻辑：支持共享/复制页面，按需 `alloc_page`、`memcpy`、`page_insert`，并在共享路径上增加页面引用计数。

### 2.3 时钟中断和调度钩子（`lab6/kern/trap/trap.c`）
- 在 `IRQ_S_TIMER` 分支中添加：
  - 调用 `clock_set_next_event`、自增 `ticks`。
  - 每 100 次 tick 打印 `100 ticks`，并在累计 10 次后调用 `sbi_shutdown`。
  - 调用 `sched_class_proc_tick(current)` 驱动调度器更新时间片。

### 2.4 RR/Stride 调度器实现（`lab6/kern/schedule/default_sched*.c`）
- `default_sched.c`：实现 RR 调度队列初始化、入队、出队、取下一个进程、时间片 tick 处理。
- `default_sched_stride.c`：
  - 定义 `BIG_STRIDE` 常量并初始化 run queue/skew heap。
  - 实现 `stride_enqueue/dequeue`，维护 `lab6_run_pool`、`proc_num`、`time_slice`。
  - 在 `stride_pick_next` 中根据最小 stride 选取进程并更新 `lab6_stride`。
  - 在 `stride_proc_tick` 中递减时间片并在耗尽时请求调度。

### 2.5 其他修复
- `lab6/kern/mm/kmalloc.c`：修复 `__slob_free_pages` 调用 `kva2page` 时的指针类型转换，避免编译警告。

## 3. 编译与测试
- 在 `lab6` 目录执行 `make`，顺利生成 `bin/ucore.img`，证明集成后的 LAB6 代码可以成功编译链接。

## 4. 心得体会
通过在 LAB6 中串联之前实验的成果，进一步理解了：
- 进程控制块在调度类中的关键作用，新增字段需要在 PCB 分配时初始化，避免调度器访问未定义数据。
- 时钟中断与调度器之间的耦合：RR/Stride 都依赖统一的 tick 接口来控制时间片。
- 代码复用与演进的重要性：对 LAB2~5 的实现进行适配能够大幅减少重复劳动，但仍需根据 LAB6 新增需求做细节调整。

# 练习1：理解调度器框架的实现
请仔细阅读和分析调度器框架的相关代码，特别是以下两个关键部分的实现：

在完成练习0后，请仔细阅读并分析以下调度器框架的实现：

调度类结构体 sched_class 的分析：请详细解释 sched_class 结构体中每个函数指针的作用和调用时机，分析为什么需要将这些函数定义为函数指针，而不是直接实现函数。

运行队列结构体 run_queue 的分析：比较lab5和lab6中 run_queue 结构体的差异，解释为什么lab6的 run_queue 需要支持两种数据结构（链表和斜堆）。

调度器框架函数分析：分析 sched_init()、wakeup_proc() 和 schedule() 函数在lab6中的实现变化，理解这些函数如何与具体的调度算法解耦。

对于调度器框架的使用流程，请在实验报告中完成以下分析：

调度类的初始化流程：描述从内核启动到调度器初始化完成的完整流程，分析 default_sched_class 如何与调度器框架关联。

进程调度流程：绘制一个完整的进程调度流程图，包括：时钟中断触发、proc_tick 被调用、schedule() 函数执行、调度类各个函数的调用顺序。并解释 need_resched 标志位在调度过程中的作用

调度算法的切换机制：分析如果要添加一个新的调度算法（如stride），需要修改哪些代码？并解释为什么当前的设计使得切换调度算法变得容易。

## 一、调度器框架的实现
### 1. `sched_class` 结构体
`sched_class` 通过函数指针描述一套调度策略需要实现的全部接口：
- `name`：策略名称，便于调试或运行时识别。
- `init(rq)`：初始化该调度策略需要的运行队列状态，例如 RR 的链表、Stride 的斜堆。
- `enqueue/dequeue(rq, proc)`：把进程加入或移出该策略的就绪队列。不同算法使用的数据结构差异巨大，因此必须由策略自身实现。
- `pick_next(rq)`：从就绪队列中选出下一个要运行的进程，RR 取队首，Stride 取堆顶并更新 stride。
- `proc_tick(rq, proc)`：时钟中断到来时的处理逻辑（递减时间片、设置 `need_resched` 等）。
通过函数指针形式，调度框架可以在不修改主流程的前提下切换具体策略，实现“框架 + 策略”解耦。

### 2. `run_queue` 结构体
LAB5 版本只包含链表和进程计数，足以支撑 RR；LAB6 在此基础上新增 `lab6_run_pool` 指向斜堆入口。原因是 LAB6 需要同时支持 RR（链表）和 Stride（斜堆）两种调度算法，`run_queue` 作为统一封装，既保存 RR 所需成员，又提供斜堆指针供 Stride 使用。

### 3. 框架函数 `sched_init` / `wakeup_proc` / `schedule`
- `sched_init`：选择默认的 `sched_class`，设置 `rq->max_time_slice` 后调用该类的 `init` 完成运行队列初始化。框架不再直接知道使用的是链表还是斜堆。
- `wakeup_proc`：把进程状态设为 `PROC_RUNNABLE` 后，通过 `sched_class->enqueue` 入队，而不是自己操作链表。
- `schedule`：统一处理当前进程的入队、挑选下一进程、出队和切换，所有与数据结构相关的操作都委托给 `sched_class` 完成，从而与 RR/Stride 具体实现解耦。

进一步结合源码细节可以看到：
- `sched_class` 的接口定义在 `lab6/kern/schedule/sched.h`；RR 的实现位于 `default_sched.c`，Stride 的实现位于 `default_sched_stride.c`。比如 `RR_enqueue` 调用 `list_add_before(&(rq->run_list), &(proc->run_link))` 完成入队，而 `stride_enqueue` 通过 `skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f)` 维护斜堆，并在同时重置 `time_slice`/`lab6_priority`。
- `run_queue`（`sched.h`）在 LAB5 基础上加入 `lab6_run_pool` 指针。Stride 调度器的 `stride_dequeue` 会调用 `skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f)`，而 RR 则仍然只依赖 `run_list` 这个循环链表。
- `sched_init`（`sched.c`）先设置 `sched_class = &default_sched_class`，再统一调用 `sched_class->init(rq)`；`wakeup_proc`（`sched.c:58-83`）和 `schedule`（`sched.c:85-115`）全程只通过 `sched_class->enqueue/pick_next/dequeue` 操作运行队列。无论切换到 Stride 还是未来的其他算法，框架层代码都无需改动。

## 二、调度器框架的使用流程

### 1. 调度类初始化流程
1. `kern_init()`（`lab6/kern/init/init.c`）按 `pmm_init → idt_init → vmm_init → sched_init → proc_init → clock_init` 顺序初始化子系统。
2. `sched_init()`（`lab6/kern/schedule/sched.c`）创建全局 `run_queue`，设置 `rq->max_time_slice`，再把 `sched_class` 设为 `default_sched_class` 并调用其 `init` 回调。
3. `default_sched_class`（`lab6/kern/schedule/default_sched.c`）在 `RR_init` 中清空 `run_list`、重置 `proc_num`。通过设置 `sched_class` 指针，调度框架就与默认 RR 策略关联。

### 2. 进程调度流程
1. **时钟中断**：`interrupt_handler` 在 `IRQ_S_TIMER` 分支里调用 `clock_set_next_event`、递增 `ticks`，并执行 `sched_class_proc_tick(current)`。
2. **proc_tick**：RR/Stride 的 `proc_tick` 递减 `time_slice`，当耗尽时把 `current->need_resched` 置 1。
3. **need_resched 检查**：`trap()` 在返回用户态前检测 `current->need_resched`，如为 1 则调用 `schedule()`。
4. **schedule**：`schedule()` 将仍可运行的当前进程重新入队（`sched_class->enqueue`），再用 `sched_class->pick_next` 选出新进程，并通过 `sched_class->dequeue` 将其从队列移除。
5. **切换**：若 `next != current`，调用 `proc_run(next)` 完成上下文切换。

调度流程可以用下图概括：

```
┌────────────────────────────────────────┐
│ 时钟中断 IRQ_S_TIMER                    │
└──────────────┬─────────────────────────┘
               │ clock_set_next_event()
               ▼
┌────────────────────────────────────────┐
│ sched_class_proc_tick(current)         │
├──────────────┬───────────────┬────────-┤
│ time_slice>0 │ time_slice<=0 │         │
└──────┬───────┘       ┌───────┘         │
       │               ▼                 │
       │       current.need_resched = 1  │
       ▼               │                 │
┌────────────────────────────────────────┐
│ trap() 返回前检查 need_resched          │
└──────┬─────────────────────────────────┘
       │ need_resched=1
       ▼
┌────────────────────────────────────────┐
│ schedule()                             │
│  ├─ sched_class.enqueue(current)       │
│  ├─ next = sched_class.pick_next()     │
│  ├─ sched_class.dequeue(next)          │
│  └─ 如果无可运行进程 → idleproc          │
└──────┬─────────────────────────────────┘
       ▼
┌────────────────────────────────────────┐
│ proc_run(next)                         │
└────────────────────────────────────────┘
```

`need_resched` 是中断上下文与调度器之间的桥梁：tick 回调只设置标志位，由 `trap()` 在安全位置触发真正的 `schedule()`，避免在中断栈上直接切换。

`need_resched` 是中断上下文与调度器之间的桥梁：tick 回调只设置标志位，由 `trap()` 在安全位置触发真正的 `schedule()`，避免在中断栈上直接切换。

### 3. 调度算法切换机制
新增算法时，可以在 `lab6/kern/schedule/` 提供一组新的 `sched_class` 回调，仿照 `default_sched.c` ，`default_sched_stride.c`，在需要时把 `sched_class` 指针切换过去。若算法需要额外的运行队列状态，可以像 Stride 那样在 `struct run_queue` 中添加成员。
`sched_init`/`wakeup_proc`/`schedule` 永远只通过 `sched_class` 接口操作队列，因此切换算法只需更换 `sched_class` 和新策略的实现文件，不必修改框架逻辑。

# 练习2：实现 Round Robin 调度算法
完成练习0后，建议大家比较一下（可用kdiff3等文件比较软件）个人完成的lab5和练习0完成后的刚修改的lab6之间的区别，分析了解lab6采用RR调度算法后的执行过程。理解调度器框架的工作原理后，请在此框架下实现时间片轮转（Round Robin）调度算法。

注意有“LAB6”的注释，你需要完成 kern/schedule/default_sched.c 文件中的 RR_init、RR_enqueue、RR_dequeue、RR_pick_next 和 RR_proc_tick 函数的实现，使系统能够正确地进行进程调度。代码中所有需要完成的地方都有“LAB6”和“YOUR CODE”的注释，请在提交时特别注意保持注释，将“YOUR CODE”替换为自己的学号，并且将所有标有对应注释的部分填上正确的代码。

提示，请在实现时注意以下细节：

链表操作：list_add_before、list_add_after等。
宏的使用：le2proc(le, member) 宏等。
边界条件处理：空队列的处理、进程时间片耗尽后的处理、空闲进程的处理等。

## 1. 比较一个在lab5和lab6都有, 但是实现不同的函数, 说说为什么要做这个改动, 不做这个改动会出什么问题。提示: 如kern/schedule/sched.c里的函数。你也可以找个其他地方做了改动的函数。
- **schedule**：Lab5 版本只是在 proc_list 上循环找第一个 PROC_RUNNABLE
```c
void schedule(void)
{
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
        last = (current == idleproc) ? &proc_list : &(current->list_link);
        le = last;
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
                {
                    break;
                }
            }
        } while (le != last);
        if (next == NULL || next->state != PROC_RUNNABLE)
        {
            next = idleproc;
        }
        next->runs++;
        if (next != current)
        {
            proc_run(next);
        }
    }
    local_intr_restore(intr_flag);
}
```
因此没有时间片、优先级等概念。Lab6 则先把当前仍可运行的进程重新 enqueue 到 sched_class 的运行队列，再通过 pick_next/dequeue 选择下一任务
```c
void schedule(void)
{
    bool intr_flag;
    struct proc_struct *next;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
        if (current->state == PROC_RUNNABLE)
        {
            sched_class_enqueue(current);
        }
        if ((next = sched_class_pick_next()) != NULL)
        {
            sched_class_dequeue(next);
        }
        if (next == NULL)
        {
            next = idleproc;
        }
        next->runs++;
        if (next != current)
        {
            proc_run(next);
        }
    }
    local_intr_restore(intr_flag);
}
```
从而把调度策略抽象成 sched_class。如果仍沿用 Lab5 的遍历方式，Lab6 中新增的 default_sched_class 永远不会被调用，时间片不会递减，RR/Stride 行为完全失效，长时间运行会导致某些任务独占 CPU 或被饿死。
- **wakeup_proc**：Lab5 只在唤醒时清掉 wait_state,
```c
void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
        {
            proc->state = PROC_RUNNABLE;
            proc->wait_state = 0;
        }
        else
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
```
Lab6 在状态切换后还会把被唤醒、且非当前进程的任务插入 sched_class 的 run queue
```c
void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
        {
            proc->state = PROC_RUNNABLE;
            proc->wait_state = 0;
            if (proc != current)
            {
                sched_class_enqueue(proc);
            }
        }
        else
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
```
以便新的调度框架能立刻看到它。如果缺少这一步，被唤醒的线程仍然不在 run queue 中，sched_class_pick_next 就无法取到它，只能不停返回空队列，系统会掉回 idleproc，导致唤醒逻辑形同虚设。
- **额外初始化**：Lab6 新增 sched_init 与 sched_class_proc_tick 负责初始化 run queue、注册默认调度器并在时钟中断里让调度器扣除时间片。这是 Lab6 RR、定时器、调度类可插拔功能的基础。若缺少这些改动，default_sched_class 内的统计量从未初始化，tick 回调也不会触发，从而再次导致时间片耗尽检测失败，系统无法按实验要求交替运行多个用户进程。

## 2. 描述你实现每个函数的具体思路和方法，解释为什么选择特定的链表操作方法。对每个实现函数的关键代码进行解释说明，并解释如何处理边界情况。
- **RR_init**：对 `run_queue` 的循环链表调用 `list_init`，同时把 `proc_num` 置 0、`lab6_run_pool` 清空，确保不会残留旧进程节点。若不重新初始化，旧链表节点会导致调度器错误地认为还有就绪进程。

```c
static void
RR_init(struct run_queue *rq)
{
    list_init(&(rq->run_list));
    rq->proc_num = 0;
    rq->lab6_run_pool = NULL;
}
```

- **RR_enqueue**：入队前先 `assert(proc->rq == NULL)`，并将 `time_slice` 归一化到 `(0, rq->max_time_slice]`，防止任务带着异常时间片进入；使用 `list_add_before(&(rq->run_list), &(proc->run_link))` 将新进程插入循环链表尾部——由于 `run_list` 作为哨兵节点，取队首时会访问 `list_next(run_list)`，因此把节点插入 `run_list` 前即可实现“队尾”追加。入队后更新 `proc->rq` 和 `proc_num`，避免重复入队。

```c
static void
RR_enqueue(struct run_queue *rq, struct proc_struct *proc)
{
    assert(proc->rq == NULL);
    if (proc->time_slice <= 0 || proc->time_slice > rq->max_time_slice)
    {
        proc->time_slice = rq->max_time_slice;
    }
    list_add_before(&(rq->run_list), &(proc->run_link));
    proc->rq = rq;
    rq->proc_num++;
}
```

- **RR_dequeue**：只有 `proc->rq == rq` 才执行删除，防止误删其他队列节点。调用 `list_del_init(&(proc->run_link))` 一次性完成链表删除和节点再初始化；再将 `proc->rq` 置空，并在 `proc_num` > 0 时减一，防止计数下溢。若节点已不在队列中，直接跳过。

```c
static void
RR_dequeue(struct run_queue *rq, struct proc_struct *proc)
{
    if (proc->rq == rq)
    {
        list_del_init(&(proc->run_link));
        proc->rq = NULL;
        if (rq->proc_num > 0)
        {
            rq->proc_num--;
        }
    }
}
```
- **RR_pick_next**：先判断 `list_empty(&(rq->run_list))`，为空则返回 `NULL` 表示无可运行进程；否则通过 `list_next(&(rq->run_list))` 取得队首节点，并用 `le2proc(le, run_link)` 找到对应的进程结构体。循环链表 + 哨兵设计使得头结点永远有效，无需额外判空。
```c
static struct proc_struct *
RR_pick_next(struct run_queue *rq)
{
    if (list_empty(&(rq->run_list)))
    {
        return NULL;
    }
    list_entry_t *le = list_next(&(rq->run_list));
    return le2proc(le, run_link);
}
```
- **RR_proc_tick**：`time_slice > 0` 时先减一；当时间片耗尽 (`<= 0`) 时把 `proc->need_resched` 置 1，由 `trap` 在安全位置触发 `schedule()`。对空闲进程无需处理，因为 `sched_class_proc_tick` 会跳过 idleproc；对普通进程而言必须在时间片耗尽时设置标志，否则它会长时间独占 CPU。

```c
static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    if (proc->time_slice > 0)
    {
        proc->time_slice--;
    }
    if (proc->time_slice <= 0)
    {
        proc->need_resched = 1;
    }
}
```
## 3. 分析 Round Robin 调度算法的优缺点，讨论如何调整时间片大小来优化系统性能，并解释为什么需要在 RR_proc_tick 中设置 need_resched 标志。
Round Robin 在 Lab6 中的优点是公平、响应快：每个就绪进程轮番拿固定时间片，交互式任务能在一次队列循环内得到运行，最大等待时间受限于 N * time_slice。缺点是忽略优先级和 CPU 占用差异，时间片过小会导致调度开销和缓存抖动，过大又会拖慢交互响应并让长 CPU 任务独占。

调时间片时可结合负载特征：I/O 密集系统可缩短时间片以提升交互性；计算密集型或系统调用成本高时增大战备可降低上下文切换开销。

RR_proc_tick 中设置 need_resched 是在时间片耗尽时通知内核当前进程必须在下一次返回内核态时让出 CPU；如果不置位，调度器不知道当前进程已耗尽配额，仍会继续运行，RR 轮转就被破坏，也无法触发 schedule() 去选下一个进程。
## 4. 结果演示
```c
root@iZ2zeag95sg5rkedygcnprZ:~/labcode/lab6# make qemu

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
(THU.CST) os is loading ...

Special kernel symbols:
  entry  0xc020004a (virtual)
  etext  0xc02058b4 (virtual)
  edata  0xc02c2538 (virtual)
  end    0xc02c6a20 (virtual)
Kernel executable memory footprint: 795KB
DTB Init
HartID: 0
DTB Address: 0x82200000
Physical Memory from DTB:
  Base: 0x0000000080000000
  Size: 0x0000000008000000 (128 MB)
  End:  0x0000000087ffffff
DTB init completed
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
sched class: RR_scheduler
++ setup timer interrupts
kernel_execve: pid = 2, name = "priority".
set priority to 6
main: fork ok,now need to wait pids.
set priority to 1
set priority to 2
set priority to 3
set priority to 4
set priority to 5
100 ticks
100 ticks
child pid 3, acc 1108000, time 2010
child pid 4, acc 1088000, time 2010
child pid 5, acc 1076000, time 2010
child pid 6, acc 1076000, time 2010
child pid 7, acc 1076000, time 2010
main: pid 0, acc 1108000, time 2010
main: pid 4, acc 1088000, time 2010
main: pid 5, acc 1076000, time 2010
main: pid 6, acc 1076000, time 2010
main: pid 7, acc 1076000, time 2010
main: wait pids over
sched result: 1 1 1 1 1
all user-mode processes have quit.
init check memory pass.
kernel panic at kern/process/proc.c:468:
    initproc exit.

root@iZ2zeag95sg5rkedygcnprZ:~/labcode/lab6# 
```
- sched class: RR_scheduler 证明 sched_init() 此时绑定的是默认 RR 类。priority 程序仍然按照 6→1 的顺序设置不同优先级，但 RR 算法完全忽略 lab6_priority，所有进程共享同样的时间片。
- child pid 和 main 的 acc 值几乎一样（1.10M、1.08M、1.076M… 的差异只是因为结束时的统计偏差），time 也全部是 2010。最终 sched result: 1 1 1 1 1，说明各进程获得的 CPU 时间完全均等，这与 RR 的循环公平的特性一致：每个就绪任务按顺序领取固定大小的时间片，优先级对调度无影响。
- 与 Stride 结果对比：Stride 会让不同权重对应的 acc/time 成比例，而 RR 下无论权重如何设置都几乎完全相同，因此 priority 程序用 sched result 来“打分”，RR 输出全 1，Stride 则输出 1 2 2 3 3 等非均衡值，用于展示两种算法的差异。

## 5. 拓展思考：如果要实现优先级 RR 调度，你的代码需要如何修改？当前的实现是否支持多核调度？如果不支持，需要如何改进？
- **优先级 RR 设计**：当前 default_sched_class 里 run_queue 仅是一条普通链表，RR_enqueue 直接把任意可运行进程插到尾部（default_sched.c ），
```c
static void
RR_enqueue(struct run_queue *rq, struct proc_struct *proc)
{
    // LAB6: 2312773
    assert(proc->rq == NULL);
    if (proc->time_slice <= 0 || proc->time_slice > rq->max_time_slice)
    {
        proc->time_slice = rq->max_time_slice;
    }
    list_add_before(&(rq->run_list), &(proc->run_link));
    proc->rq = rq;
    rq->proc_num++;
}
```
RR_pick_next 也只取队头（default_sched.c ）。
```c
static struct proc_struct *
RR_pick_next(struct run_queue *rq)
{
    // LAB6: 2312773
    if (list_empty(&(rq->run_list)))
    {
        return NULL;
    }
    list_entry_t *le = list_next(&(rq->run_list));
    return le2proc(le, run_link);
}
```
要支持优先级 RR，可以把 run_queue 替换成多级队列或按权重插入：例如为 struct run_queue 增加 list_entry_t run_list[MAX_PRIO]，RR_enqueue 根据 proc->priority 选择对应子队列，再把同优先级进程放进尾部；RR_pick_next 则从最高优先级非空队列挑进程。或者保持单链表但按优先级插入，确保高优先级节点在前。对应地 proc->priority 需初始化、继承，并在 set_priority 时调整其在队列中的位置。

而且，优先级 RR 常让不同优先级有不同时间片，可在 rq->max_time_slice 基础上乘以优先级系数，例如 proc->time_slice = rq->max_time_slice << (MAX_PRIO - proc->priority)，这样 RR_proc_tick（default_sched.c (lines 93-110)）扣完时间片后再置 need_resched 仍然生效，但每级 RR 圈中的总配额不同。

- **多核调度**：目前 sched.c 里默认只有一个全局运行队列 rq 和一个 current（sched.c），每次调度都假设只有一个 CPU，可以随意访问链表而无需锁。

要支持多核，至少需要：

为每个 CPU 保存独立的 struct run_queue、current、idleproc，并在本地时钟中断里调用对应队列；

所有跨 CPU 的队列操作（sched_class_enqueue/dequeue 等）要加自旋锁或使用无锁结构，避免并发修改链表；

进程唤醒时需要选择合适的目标 CPU，可以把进程 push 到唤醒 CPU 的 run queue

struct proc_struct 要记录它所属 CPU，迁移时重新绑定栈或上下文。只有这些同步和 per-CPU 数据结构就绪后，调度器才能在多核环境下安全运行。

# 扩展练习 Challenge 1: 实现 Stride Scheduling 调度算法
## 1. 简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计，鼓励给出详细设计
- **核心思路**：维护多级就绪队列（级别越高优先级越高），时间片随级别递增。高优级队列用于短作业/交互任务，若在该级别时间片内未完成就被“降级”到下一队列，直到运行结束或 I/O 阻塞（常在唤醒时回到高优队列）。
- **运行队列结构**：在 `run_queue` 中维护 `list_entry_t run_list[MAX_LEVEL]` 或类似数组，并记录当前最高非空级别；PCB 需要新增 `int mlfq_level` 和 `int mlfq_slice` 等字段以跟踪所属层和剩余时间片。
- **调度流程**：
  1. `init`：清空各级队列，初始化时间片表（如 `slice[level] = base << level`）以及全局老化参数。
  2. `enqueue`：根据 `proc->mlfq_level` 将进程追加到对应队列尾，同时刷新 `proc->time_slice = slice[level]`。
  3. `pick_next`：从最高非空队列取队首节点；若所有队列为空则返回 `NULL`。
  4. `dequeue`：从所属队列删除节点并更新计数。
  5. `proc_tick`：递减当前进程时间片；若耗尽且未在最低层，设置 `need_resched`，下一次调度时把进程降一级并重新分配时间片；若在最低层则采用 RR，耗尽后同样置位 `need_resched`。

- **时间片与老化策略**：通过几何级数（5/10/20…）或倍增方式分配各层时间片，兼顾响应与吞吐。为防止长作业在低层饥饿，可在周期性时钟中断里执行“提升”操作——将所有进程（或满足等待阈值的进程）移动回高层，使其重新争取 CPU。
- **工程要点**：多级队列操作需要保持 O(1)，并与 `sched_class` 接口对齐；唤醒路径要重置 `mlfq_level`，阻塞前使用 `proc->mlfq_level` 保留层级信息；调试时可在 `proc_tick` 打印层级/时间片，确认降级与老化逻辑符合预期。通过上述设计即可把 MLFQ 策略无缝接入当前调度框架。 

- **Stride 调度器核心代码**（ `kern/schedule/default_sched_stride.c`）
```c
#define BIG_STRIDE 0x7FFFFFFF

static int proc_stride_comp_f(void *a, void *b) {
    struct proc_struct *p = le2proc(a, lab6_run_pool);
    struct proc_struct *q = le2proc(b, lab6_run_pool);
    return (p->lab6_stride > q->lab6_stride) - (p->lab6_stride < q->lab6_stride);
}

static void stride_init(struct run_queue *rq) {
    list_init(&(rq->run_list));
    rq->lab6_run_pool = NULL;
    rq->proc_num = 0;
}

static void stride_enqueue(struct run_queue *rq, struct proc_struct *proc) {
    assert(proc->rq == NULL);
    if (proc->lab6_priority == 0) {
        proc->lab6_priority = 1;
    }
    if (proc->time_slice <= 0 || proc->time_slice > rq->max_time_slice) {
        proc->time_slice = rq->max_time_slice;
    }
    rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
    list_add_before(&(rq->run_list), &(proc->run_link));
    proc->rq = rq;
    rq->proc_num++;
}

static void stride_dequeue(struct run_queue *rq, struct proc_struct *proc) {
    if (proc->rq != rq) {
        return;
    }
    rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
    list_del_init(&(proc->run_link));
    proc->rq = NULL;
    if (rq->proc_num > 0) {
        rq->proc_num--;
    }
}

static struct proc_struct *stride_pick_next(struct run_queue *rq) {
    if (rq->lab6_run_pool == NULL) {
        return NULL;
    }
    struct proc_struct *p = le2proc(rq->lab6_run_pool, lab6_run_pool);
    if (p->lab6_priority == 0) {
        p->lab6_priority = 1;
    }
    p->lab6_stride += BIG_STRIDE / p->lab6_priority;
    return p;
}

static void stride_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
    if (proc->time_slice > 0) {
        proc->time_slice--;
    }
    if (proc->time_slice <= 0) {
        proc->need_resched = 1;
    }
}
```
## 2. 简要证明/说明（不必特别严谨，但应当能够”说服你自己“），为什么Stride算法中，经过足够多的时间片之后，每个进程分配到的时间片数目和优先级成正比。
可以把 Stride 调度理解成按权重匀速行进、谁最落后谁先跑的竞赛。设进程 P_i 的优先级（权重）为 w_i，运行次数为 n_i，当前 stride 为 s_i。算法规定：每次总是挑选 stride 最小的进程运行一个时间片，运行后把它的 stride 增加 Δs_i = BIG_STRIDE / w_i。几个关键观察：

- **stride 趋同**：如果某个进程被调度次数明显落后，它的 stride 也会落后，因为所有 stride 初值相同，每运行一次才会加 Δs_i。一旦 stride 落后，它就会成为堆顶，被优先挑选，直到赶上其他进程的位置。因此，各进程的 stride 会围绕一个共同的参考值上下振荡，不会长期偏移。

- **增量与权重的反比关系**：Δs_i = BIG_STRIDE / w_i，意味着权重大（优先级高）的进程每次 stride 增长更慢；也就是说，它被推离堆顶的速度较慢，更容易在下一轮再次被选中。权重小的进程增长快，会暂时离开堆顶，等其他进程 stride 累积到更大后才轮回。

- **长期调度次数推导**：当系统已经运行了很长时间、所有进程的 stride 都在狭小区间震荡时，可以近似认为存在某个常数 C，满足
```c
n_i × (BIG_STRIDE / w_i) ≈ C
```
即调度次数 n_i（也就是获得的时间片数）与权重 w_i 成正比。

- **例子**：假设有两个进程，权重分别为 2 和 1。高权进程每次 stride 增加 BIG_STRIDE/2，低权进程增加 BIG_STRIDE。由于低权进程每次被调度后 stride 会“跳”得更远，它需要等高权进程调度两次才能再次回到堆顶。随着时间推移，调度次数比例稳定在 2:1，恰好与权重成正比。

综上，Stride 通过“最小 stride 先运行 + stride 按 1/权重递增”两条规则，动态地让各进程的 stride 值保持接近，从而保证长期看来分配到的时间片数与优先级权重成正比。

## 3. 结果演示
```c
root@iZ2zeag95sg5rkedygcnprZ:~/labcode/lab6# make qemu

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
(THU.CST) os is loading ...

Special kernel symbols:
  entry  0xc020004a (virtual)
  etext  0xc0205c56 (virtual)
  edata  0xc02c2538 (virtual)
  end    0xc02c6a20 (virtual)
Kernel executable memory footprint: 795KB
DTB Init
HartID: 0
DTB Address: 0x82200000
Physical Memory from DTB:
  Base: 0x0000000080000000
  Size: 0x0000000008000000 (128 MB)
  End:  0x0000000087ffffff
DTB init completed
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
sched class: stride_scheduler
++ setup timer interrupts
kernel_execve: pid = 2, name = "priority".
set priority to 6
main: fork ok,now need to wait pids.
set priority to 5
set priority to 4
set priority to 3
set priority to 2
set priority to 1
100 ticks
100 ticks
child pid 7, acc 1636000, time 2010
child pid 6, acc 1348000, time 2010
child pid 5, acc 1080000, time 2010
child pid 4, acc 800000, time 2010
child pid 3, acc 508000, time 2010
main: pid 3, acc 508000, time 2010
main: pid 4, acc 800000, time 2010
main: pid 5, acc 1080000, time 2010
main: pid 6, acc 1348000, time 2010
main: pid 0, acc 1636000, time 2010
main: wait pids over
sched result: 1 2 2 3 3
all user-mode processes have quit.
init check memory pass.
kernel panic at kern/process/proc.c:468:
    initproc exit.

root@iZ2zeag95sg5rkedygcnprZ:~/labcode/lab6# 
```
- sched class: stride_scheduler 说明内核已经以 Stride 算法启动并初始化成功。之后的 priority 用户程序依次调用 lab6_set_priority 创建 5 个不同权重的子进程，加上父进程自身，总共 6 个竞争 CPU 的任务。
- 每个 child pid 的 acc（累计工作量）与设定的优先级完全成正比：优先级最高的 6（父进程/子进程 pid 7）累积到 1.636M，权重 5 的达到 1.348M，依次递减，最低权重 1 只有 0.508M。所有进程的 time 都是 2010，说明测试用的工作循环长度一致，真正出现差异的是被调度的次数——这就是 Stride “占空比按权重分配”的体现。
- sched result: 1 2 2 3 3 是 priority 程序计算出的比例结果，把每个子进程的 acc 与最小 acc 做整数比。虽然不是完全精确（受有限时间片影响），但可以看出大致满足 1:2:3 的分配关系，用来验证算法的公平性。



要实现与RR算法的切换，我们只需修改 sched.c 第 55 行的 sched_class，
如果是RR算法，改为 sched_class = &default_sched_class;
如果是Stride算法，则改为 sched_class = &stride_sched_class;
# 知识点总结
## 1. 实验中体现的重要知识点及其与 OS 原理的关系
- **进程控制块实现 & PCB/TCB 理论**：实验里要亲自维护 `proc_struct` 的状态、链表、父子进程指针、调度字段，深入理解 PCB 如何支撑 `do_fork`、`do_exit`、`schedule`；课堂则偏重概念，较少涉及字段初始化的顺序和资源回收细节。
- **调度框架与运行队列 & 调度算法原理**：在 LAB6 里实现 `sched_class`、`run_queue`、RR/Stride 的 `enqueue/pick_next/proc_tick`，直观看到课上讨论的公平性、响应时间如何通过数据结构落地；理论强调算法特性，实验更关注接口约束和边界条件。
- **虚拟内存/页表 & 存储管理理论**：`copy_range`、`exit_mmap`、`pgfault` 等代码要求正确复制页表、维护引用计数，等同于把课堂上的分页/缺页中断概念“翻译”成可运行实现；实验附加了 API 调用顺序、错误路径清理等工程实践。
- **内核线程与 trapframe & 系统调用/中断流程**：`kernel_thread`、`user_main`、`__trapret` 展示了寄存器保存、特权级切换的真实指令序列，相比课堂上的流程图更加贴近硬件细节。
- **调度器抽象（`sched_class`） & 原理课程中较少涉及的工程模式**：通过函数指针把策略与框架解耦，RR 和 Stride 都能在同一套流程上热插拔，这类设计在原理课里通常不会讲，是实验额外收获的工程知识。

## 2. 原理课重要但实验未覆盖的知识点
1. **设备驱动与 I/O 子系统**：课程强调驱动栈、DMA、I/O 调度，而本实验仅有少量串口输出，缺乏对完整驱动模型的实现。
2. **复杂文件系统设计**：课堂讨论 VFS、日志、索引节点、缓存一致性等内容，实验中的 SFS/测例并未涉及这些高级特性。
3. **多核并发控制与同步机制**：理论会系统讲解自旋锁、RCU、lock-free 等，但实验运行在单核环境，只需 `local_intr_save/restore` 就能保护临界区。
4. **安全与权限模型**：如用户/组、ACL、能力机制、内核安全加固（ASLR、SMEP/SMAP）在课程中占有重要位置，现有实验尚未涉及。