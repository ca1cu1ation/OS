# 实验分工
2312819 陈谊斌： 练习1：理解first-fit 连续物理内存分配算法 练习2：实现 Best-Fit 连续物理内存分配算法  

2312424 刘平：扩展练习Challenge：buddy system（伙伴系统）分配算法

2312773 单滢锡：扩展练习Challenge：任意大小的内存单元slub分配算法

# First-Fit 连续物理内存分配算法实现与分析

本小节基于 `kern/mm/default_pmm.c` 中的实现，说明 First-Fit（首次适应）物理内存分配器各函数的职责、分配/释放的流程、实现细节、复杂度分析以及可改进点。

---

## 概述

`default_pmm.c` 实现的是基于“first-fit”（首次适应）的物理页分配器。实现要点如下：

- 使用一个按物理地址有序的循环双向链表 `free_list` 管理空闲块（每个空闲块以其起始页 `struct Page` 的 `property` 字段记录连续空闲页数）。
- 分配（alloc）操作从链表头开始查找第一个满足大小要求的空闲块，若块大于请求则分裂；释放（free）操作按地址顺序插入并尝试与相邻空闲块合并。

---

## 关键数据结构与宏（简要）

- `free_area_t free_area`：包含 `free_list`（链表头）和 `nr_free`（当前空闲页总数）。
- `free_list`：循环双向链表，链表节点通过每页的 `page_link` 字段串联。
- 每个空闲块在其起始页保存 `property`（连续空闲页数），并使用 `SetPageProperty` / `ClearPageProperty` / `PageProperty` 等宏管理属性位。

---

## 各函数职责与实现要点

### `default_init(void)`

- 作用：初始化分配器内部结构。
- 实现：调用 `list_init(&free_list)` 初始化链表并把 `nr_free = 0`。

### `default_init_memmap(struct Page *base, size_t n)`

- 作用：把以 `base` 为起始、长度为 `n` 页的物理区加入空闲表（在内存初始化阶段由上层调用）。
- 实现细节：
  - 遍历区间内每页清零 `flags`/`property` 并将 `ref` 设为 0（在 `pmm_init` 时这些页可能被标记为保留）。
  - 把 `base->property = n` 并 `SetPageProperty(base)`，`nr_free += n`。
  - 将 `base` 按物理地址顺序插入 `free_list`（遍历 `free_list` 找到第一个 `page` 满足 `base < page`，插入其前；若无则追加到尾部）。

保持链表按地址升序对后续合并非常关键。

### `default_alloc_pages(size_t n)`

- 作用：分配连续 `n` 页并返回起始 `struct Page *`，若无法满足返回 `NULL`。
- 算法/流程：
  1. 若 `n > nr_free` 则直接返回 `NULL`。
  2. 从 `free_list` 头向后遍历，找到第一个 `p` 使 `p->property >= n`（首次适应）。
  3. 若找到：
     - 从链表中 `list_del(&(p->page_link))` 将该空闲块取出；
     - 若 `p->property > n`，在 `p + n` 处创建剩余块 `p2`：`p2->property = p->property - n; SetPageProperty(p2);`，并把 `p2` 插回链表（保持地址顺序）。
     - `nr_free -= n; ClearPageProperty(p);` 并返回 `p`。
  4. 若遍历结束未找到合适块，返回 `NULL`。

- 注意：分裂后把剩余部分插入到原块的位置（使用 `list_prev` 保存插入点），保持链表顺序。

### `default_free_pages(struct Page *base, size_t n)`

- 作用：释放以 `base` 为起始的连续 `n` 页，插回空闲链表并尽量合并相邻空闲块。
- 算法/流程：
  1. 遍历释放区间每页清除使用标志，`ref=0`。
  2. `base->property = n; SetPageProperty(base); nr_free += n;` 并按地址顺序把 `base` 插入 `free_list`。
  3. 尝试与前驱合并：若前驱存在且 `p + p->property == base`，则 `p->property += base->property`，删除 `base` 的链表节点并把 `base` 指向合并后的块头。
  4. 尝试与后驱合并：若后驱存在且 `base + base->property == p`，则 `base->property += p->property` 并删除后驱节点。

- 结果：链表仍按地址升序，且相邻空闲块被合并，减少外部碎片。

### 其他辅助函数

- `default_nr_free_pages()`：返回 `nr_free`。
- `basic_check()` / `default_check()`：自检用例，覆盖基本分配/释放、分裂/合并及 `nr_free` 校验，用于验证实现正确性。

---

## 分配与释放的时序示例

举例 `alloc_pages(3)` 的执行过程：

1. 调用 `default_alloc_pages(3)`。
2. 若 `nr_free < 3` 直接返回 `NULL`，否则从 `free_list` 遍历每个空闲块：
   - 跳过小于 3 的块；
   - 在第一个 `property >= 3` 的块 `q` 处停止：若 `q->property == 3` 则直接删除该块并返回 `q`；若 `q->property > 3`，把 `q` 分裂：分配 `q` 的前 `3` 页并把 `q + 3` 处的剩余作为新的空闲块插回链表。
3. `nr_free -= 3`，并将分配块的 `PageProperty` 清除表示已被占用。

释放的过程为逆过程：按地址插入，并与前驱/后驱尝试合并。

---

## 重要实现细节与边界情况

- 链表按物理地址排序：保证合并检测 `p + p->property == base` 的正确性。
- `property` 只保存在块头页：节省内存，但访问时必须确保只在块头读写该字段。
- 插入与分裂时关注链表位置（使用 `list_prev`/`list_next`），避免破坏链表结构。
- 自检函数覆盖了多种边界情形（空链表、尾部插入、分裂/合并等），是验证实现的关键。

---

## 算法复杂度与性能

- `default_alloc_pages(n)`：时间复杂度 O(m)，m 为当前空闲块数；最坏需要遍历整个 `free_list`。
- `default_free_pages`：插入需要按地址查找位置，复杂度同样 O(m)；合并操作为常数时间。
- 空间效率：由于分裂会产生小块，可能引起外部碎片，但释放时的合并能在一定程度上缓解碎片。
- 适用场景：实现简单、适合教学与小型内核；对于高并发或大量分配/释放场景性能可能不足。

---

## 可改进的方向（思考题答案）

虽然当前实现正确且清晰，但仍有多种实用的改进方向：

1. **分级空闲链表（Segregated Free Lists）**：按大小等级维护多个链表，减少搜索范围，提高分配速度。代价是实现复杂性与分级策略设计。

2. **按大小索引的数据结构（树 / 平衡树）**：使用红黑树或类似结构按块大小索引，可在 O(log m) 时间找到合适块，适合大内存管理场景。

3. **next-fit 策略**：维护上次分配位置为起点继续查找，能减少从头遍历的热点，但对碎片未必最优。

4. **Buddy 分配器**：按 2 的幂次划分，分裂/合并规则简单且合并容易，查找效率高，但存在内内部碎片与对任意页数的不灵活性。

5. **地址有序链表 + 大小索引双结构**：同时维护按地址有序链表（便于合并）与按大小索引（便于快速查找），平衡快速查找与合并的要求，但需同步维护两套数据结构。

6. **并发优化**：为多核场景引入分区锁、per-CPU 缓存或细粒度锁以降低竞争。

7. **延迟/阈值合并与小块处理策略**：避免产生大量过小碎片，设置最小分裂阈值或对小尾块采用不同处理策略。

---

## Best-Fit 算法实现说明（陈谊斌）

本次作业在 `kern/mm/best_fit_pmm.c` 中实现了 Best-Fit 页面分配算法（参考 `kern/mm/default_pmm.c` 的 First-Fit 实现）。实现要点：

- 初始化（`best_fit_init_memmap`）：与 First-Fit 保持一致，把传入区间内每页 `flags`/`property` 清零，设置 `base->property = n` 并 `SetPageProperty(base)`，再按物理地址有序插入 `free_list`。

- 分配（`best_fit_alloc_pages`）：遍历整个 `free_list`，找到满足 `p->property >= n` 且 `p->property` 最小的空闲块（即最贴合请求的块），如果找到则把该块从链表中删除；若块大于请求则在 `page + n` 处创建新的空闲块并插回链表；最后 `nr_free -= n` 并 `ClearPageProperty` 被分配块的头页。

- 释放（`best_fit_free_pages`）：释放时把区间内每页清零、把 `base->property = n` 并 `SetPageProperty(base)`，按地址顺序插入 `free_list`，然后尝试与前驱和后驱合并（更新 `property` 并删除已合并的链表节点）。

该实现通过了内核编译与自检（`best_fit_check()`）的基本测试。

### 改进空间

Best-Fit 的实现虽然能更好地降低内存碎片（相对于 First-Fit），但仍有以下可优化点：

1. 性能：当前每次分配需要遍历整个 `free_list`（O(m)），可以引入按大小分级链表或按大小的平衡树索引以加速查找（降至 O(log m) 或更快）。
2. 内存开销：维护额外索引结构会增加额外开销，需要在性能与内存使用间权衡。
3. 并发：在多核场景下应设计分区锁或 per-CPU 缓存以减少锁竞争。
4. 合并策略：可以采用延迟合并或阈值分裂策略避免产生大量小碎片。

以上改进点与 First-Fit 的通用改进点类似，可以根据实际运行负载逐步优化。


## 验证与测试

- 使用代码中的 `gade.sh`脚本进行测试，测试结果如下：
  ```
  >>>>>>>>>> here_make>>>>>>>>>>>
  <<<<<<<<<<<<<<< here_run_qemu <<<<<<<<<<<<<<<<<<
  try to run qemu
  qemu pid=18536
  <<<<<<<<<<<<<<< here_run_check <<<<<<<<<<<<<<<<<<
    -check physical_memory_map_information:    OK
    -check_best_fit:                           OK
  Total Score: 25/25
  ```
---

## 总结

- 实现简洁明了：按地址有序的空闲块链表 + 块头 `property` 字段，使分裂与合并逻辑清晰。
- 优点：实现简单、便于理解，合并操作直接且高效。
- 缺点：分配查找为线性时间，面对大量空闲块或频繁分配场景性能不足；外部碎片在某些负载下会增多。
- 可改进方向：分级链表、大小索引、buddy 系统、并发优化等，按需求和实现复杂度权衡选取。


---

# Buddy System 内存分配(刘平)

## 一、实验目的

通过实现 **Buddy System（伙伴系统）** 内存分配算法，理解操作系统中物理内存管理的核心机制，包括页分配、释放、合并与拆分等过程，掌握内核物理页管理的整体流程。

## 二、实验原理

Buddy System 是一种高效的动态内存分配算法。它将物理内存划分为以 2 的幂次为大小的块，通过二叉划分与合并实现快速分配与释放。
主要思想如下：

* 内存按 2^k 页对齐；
* 当请求内存不足时递归拆分大块；
* 当相邻空闲块大小相同且地址相邻时合并为更大块；
* 每个空闲块仅在首页标记 property（阶次）。

## 三、实验内容

在 `kern/mm/buddy_pmm.c` 中完成伙伴系统的实现，包括：

* **buddy_init()**：初始化空闲块结构；
* **buddy_init_memmap()**：注册连续内存区域；
* **buddy_alloc_pages()**：分配指定页数；
* **buddy_free_pages()**：释放并尝试合并；
* **buddy_nr_free_pages()**：统计空闲页；
* **buddy_check()**：自检功能正确性。

最终通过 `make grade` 自动评分。

---

## 四、关键数据结构

```c
struct free_area {
    list_entry_t free_list[MAX_ORDER]; // 各阶空闲链表
    unsigned int nr_free[MAX_ORDER];   // 各阶空闲块数量
};
```

每个 `order` 对应 2^order 页大小的块，链表存储该阶的所有空闲块。

---

## 五、实验步骤

### （一）总体设计思路

1. **管理粒度**
   以页（`Page`）为最小单元，块大小为 2^order 页（order 范围为 MIN_ORDER…MAX_ORDER）。

2. **空闲块组织**
   通过 `free_area[order]` 保存每一阶的空闲块循环链表，仅块首页保存 property 并设置 `PG_property` 标志。

3. **索引与伙伴计算**
   页索引 `idx = page2idx(p)`；伙伴索引 `buddy_idx = idx ^ (1 << order)`，由此找到对应伙伴块。

4. **分配策略**
   找到最小能覆盖请求页数的阶 order，从更高阶拆分出块，低地址部分分配，高地址部分回收至空闲链表。

5. **释放策略**
   按最小覆盖阶释放，并尝试递归合并相邻同阶空闲块，直到无法合并或到达 MAX_ORDER。

6. **元数据约定**
   仅块首页保存 `property`；`PageIsProperty(p)` 判断空闲块首页；`nr_free_pages_total` 用于统计空闲页。

---

### （二）文件与接口说明

#### 1. `buddy_pmm.h`

* **作用**：声明宏（`MAX_ORDER`、`MIN_ORDER`）、外部接口 `extern const struct pmm_manager buddy_pmm_manager`，供内核注册使用。
* **位置**：`kern/mm/`。被 `pmm.c` 或 `init.c` 包含以注册物理页管理器。
* **要点**：保持与实现文件中一致，避免头文件与源码定义不匹配。

#### 2. `buddy_pmm.c`

* **主要全局变量：**

  ```c
  static list_entry_t free_area[MAX_ORDER + 1];  // 各阶链表头
  static size_t nr_free_pages_total;             // 空闲页总数
  extern struct Page *pages;                     // 全局页数组
  extern size_t npage;                           // 总页数
  ```

* **主要函数（由 pmm_manager 调用）**

  * `buddy_init()`：初始化链表结构；
  * `buddy_init_memmap(struct Page *base, size_t n)`：注册空闲物理内存；
  * `buddy_alloc_pages(size_t n)`：按需分配；
  * `buddy_free_pages(struct Page *base, size_t n)`：释放并合并；
  * `buddy_nr_free_pages()`：返回空闲页统计；
  * `buddy_check()`：自检与验证；
  * `const struct pmm_manager buddy_pmm_manager`：结构体，向上层提供统一接口。

---

### （三）各函数职责与实现要点

#### 1. `buddy_init(void)`

**职责**：初始化 `free_area` 链表和计数器。
**要点**：调用 `list_init()` 初始化每阶链表，将 `nr_free_pages_total` 清零。

---

#### 2. `buddy_init_memmap(struct Page *base, size_t n)`

**职责**：将 `[base, base+n)` 区间按最大对齐的 2^order 块划分并挂入 `free_area`。
**核心算法**：

* 从 MAX_ORDER 递减试探最大对齐 order：满足 `(1<<order) <= total` 且 `idx % (1<<order) == 0`；
* 将该块首页标记为 `order` 阶并加入链表；
* 递减剩余页数，直至处理完。
  **注意**：确保地址合法、对齐正确、页标志清除。

---

#### 3. `buddy_alloc_pages(size_t n)`

**职责**：分配至少 n 页连续物理页。
**步骤**：

* 计算最小 order 使 `(1<<order) >= n`；
* 从当前阶向上寻找非空链表；
* 若找到较大阶块则逐级拆分（高地址部分回收）；
* 更新 `nr_free_pages_total`；
* 返回块首页指针。
  **注意**：拆分过程中保持链表一致性、正确清除标志。

---

#### 4. `buddy_free_pages(struct Page *base, size_t n)`

**职责**：释放块并尽可能合并伙伴块。
**步骤**：

* 计算最小 order；
* 设置 `property` 与 `PG_property`；
* 逐级判断伙伴是否空闲且阶相同，若是则合并；
* 最终插入对应阶的空闲链表。
  **注意**：合并前需从链表安全删除伙伴节点，防止重复引用。

---

#### 5. `buddy_nr_free_pages(void)`

**职责**：返回当前空闲页总数。
**要点**：保持与链表中实际页数一致。

---

#### 6. `buddy_check(void)`

**职责**：运行一组固定测试（如分配/释放 1 页、2 页），验证拆分与合并正确性。
**输出要求**：
必须打印 `"check_alloc_page() succeeded!"` 等字符串，以供评分脚本匹配判断。

---

### （四）测试与评分方法

#### 1. 运行方式

在工程根目录输入：

```bash
make grade
```

#### 2. grade.sh 内部流程

* **编译内核**：执行 `make clean` → `make`，生成 `bin/ucore.img`；
* **运行 QEMU**：以无图形模式启动，捕获串口输出；
* **自动比对输出**：使用 `grep` 匹配关键字符串：

  * `"memory management: buddy_pmm_manager"`
  * `"check_alloc_page() succeeded!"`
* **自动计分**：匹配成功的测试项累积分值，输出总分。

#### 3. 通过要求

* 内核必须正确注册 `buddy_pmm_manager`；
* `buddy_check()` 输出全部关键字；
* QEMU 启动正常且输出完整日志。

#### 4. 测试结果
测试结果如下
```bash
root@LAPTOP-ECMJ94NP:~# cd ./lab2
root@LAPTOP-ECMJ94NP:~/lab2# make grade
>>>>>>>>>> 构建内核中 >>>>>>>>>>
gmake[1]: Entering directory '/root/lab2'
+ cc kern/init/entry.S
+ cc kern/init/init.c
+ cc kern/libs/stdio.c
+ cc kern/debug/panic.c
+ cc kern/driver/console.c
+ cc kern/driver/dtb.c
+ cc kern/mm/best_fit_pmm.c
+ cc kern/mm/buddy_pmm.c
+ cc kern/mm/default_pmm.c
+ cc kern/mm/pmm.c
+ cc libs/printfmt.c
+ cc libs/readline.c
+ cc libs/sbi.c
+ cc libs/string.c
+ ld bin/kernel
riscv64-unknown-elf-objcopy bin/kernel --strip-all -O binary bin/ucore.img
gmake[1]: Leaving directory '/root/lab2'
>>>>>>>>>> 内核构建完成 >>>>>>>>>>
===============================
   测试 Buddy System 物理内存管理器
===============================
>>> 正在运行 QEMU 进行 Buddy System 测试...
[通过] 检测伙伴系统管理器初始化
qemu-system-riscv64: terminating on signal 15 from pid 6330 (sh)
[通过] 检测伙伴系统内存分配与释放
[通过] 检测页表虚拟地址输出
[通过] 检测页表物理地址输出
=================================
总得分: 20/20
=================================
root@LAPTOP-ECMJ94NP:
root@LAPTOP-ECMJ94NP:~/lab2# make qemu

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
  entry  0xffffffffc02000d8 (virtual)
  etext  0xffffffffc02010a4 (virtual)
  edata  0xffffffffc0205018 (virtual)
  end    0xffffffffc0205118 (virtual)
Kernel executable memory footprint: 21KB
memory management: buddy_pmm_manager
physcial memory map:
  memory: 0x0000000008000000, [0x0000000080000000, 0x0000000087ffffff].
check_alloc_page() succeeded!
check_free_page() succeeded!
check_buddy_split() succeeded!
check_buddy_merge() succeeded!
buddy_check() succeeded!
check_alloc_page() succeeded!
satp virtual address: 0xffffffffc0204000
satp physical address: 0x0000000080204000
```
---
测试成功

## 六、实验总结

本实验通过实现伙伴系统，掌握了物理内存动态分配、块拆分与合并、空闲链表维护等核心机制，为后续虚拟内存与页表管理实验奠定基础。


#扩展练习Challenge：任意大小的内存单元slub分配算法（需要编程）（单滢锡）

slub算法，实现两层架构的高效内存单元分配，第一层是基于页大小的内存分配，第二层是在第一层基础上实现基于任意大小的内存分配。可简化实现，能够体现其主体思想即可。

参考linux的slub分配算法/，在ucore中实现slub分配算法。要求有比较充分的测试用例说明实现的正确性，需要有设计文档。

# slub分配算法(单滢锡)

## 1.实验目标与要求

目标：在uCore的物理页分配器（第一层）之上，实现一个SLUB风格的小对象分配器（第二层），提供kmalloc/kfree，支持任意大小（大于最大size-class的走整页分配）。

要求：体现SLUB主体思想：slab-page元信息、对象内嵌freelist、partial/full列表、按需grow与回收；在uCore上可编译运行，并给出充分测试；输出设计文档、集成说明、实验流程与问题解决记录。

## 2.设计概述

### 2.1两层架构

第一层：uCore既有的页分配器alloc_pages(n)/free_pages(p,n)；

第二层：SLUB小对象分配器，向上提供kmalloc/kfree；向下以页为单位向第一层申请/归还slab。

### 2.2数据结构

structslab_page（放在slab页首）：

cache：所属kmem_cache

free：对象内嵌freelist头指针

inuse/total：在用/总对象数

lru：挂到cache的partial/full链

structkmem_cache（每个size-class一个）：

object_size/align/objs_per_slab

partial/full双向链表

Lock

Freelist内嵌：空闲对象首字存放next指针，不额外元信息开销。

### 2.3分配与回收算法

slub_alloc(cache)：从partial取一个slab→弹出freelist头→若slab满则移入full。

slub_free(cache,obj)：对象页对齐回到slab_page→头插回freelist→若从满变部分空，full→partial→若inuse==0立刻free_pages。

kmalloc(size)：向上取整到最近size-class；若超出最大class，走大块直取页（页首写bigblk_hdr{magic,pages}；kfree时识别并free_pages）。

## 3.关键实现要点

对象布局：页首slab_page对齐后接对象区；objs_per_slab=(PGSIZE-align(sizeof(slab_page)))/align(object_size)。

地址换算：工程无KADDR/page2kva等统一宏，采用va_pa_offset：

externuint64_tva_pa_offset;

staticinlinevoid\*page_to_kva(structPage\*p){return(void\*)((uintptr_t)page2pa(p)+va_pa_offset);}

staticinlinestructPage\*kva_to_page(void\*k){returnpa2page((uintptr_t)k-va_pa_offset);}

链表宏：环境无le2struct，统一使用list_entry(ptr,type,member)。

锁：课程环境无sync.h，用占位实现：
```bash
typedefintspinlock_t;

#definespin_lock(x)((void)0)

#definespin_unlock(x)((void)0)

#defineintr_save()(0)

#defineintr_restore(x)((void)0)
```

大块识别：页首魔数SLAB_MAGIC0x51AB51ABu+pages>1。

## 4.与uCore的集成

文件位置：lab2/kern/mm/下新增：slub.h、slub.c、kmalloc.c、test_slub.c。

Makefile：原Makefile已扫描kern/mm，无需修改；若缺头文件路径仅在KINCLUDE中追加目录。

初始化：在kern/init/init.c的pmm_init()后调用：
```bash

#include&lt;slub.h&gt;

externvoidslub_selftest(void);

...

pmm_init();

slub_init();

slub_selftest();
```

## 5.实验流程

### 5.1首次编译

执行：make clean && make

报错1：fatalerror:sync.h:Nosuchfileordirectory

修复：slub.h移除#include&lt;sync.h&gt;，改用占位锁实现。

### 5.2继续编译

报错2：slub.c：1:unterminated#ifndef

修复：删除slub.c顶部的#ifndef/#define/#endif，保留#include"slub.h"。

### 5.3地址换算修复

报错3：KADDR/page2kva/kva2page等未定义

修复：统一在slub.h用va_pa_offset封装page_to_kva/kva_to_page。

### 5.4链表宏修复

报错4：le2struct/list_entry未定义

修复：使用list_entry(ptr,structslab_page,lru)；若无该宏则在slub.c顶部自补#definelist_entry(...)。

### 5.5重新编译

终端显示：

+ldbin/kernel

riscv64-unknown-elf-objcopybin/kernel--strip-all-Obinarybin/ucore.img

生成镜像成功。
```bash
syx@CHINAMI-40LS008: /mnt/e/Desktop/labcode/labcode/lab2$ make clean && make
rm -f -r obj bin
+ cc kern/init/entry.S
+ cc kern/init/init.c
+ cc kern/libs/stdio.c
+ cc kern/debug/panic.c
+ cc kern/driver/console.c
+ cc kern/driver/dtb.c
+ cc kern/mm/best_fit_pmm.c
+ cc kern/mm/default_pmm.c
+ cc kern/mm/kmalloc.c
+ cc kern/mm/pmm.c
+ cc kern/mm/slub.c
+ cc kern/mm/test_slub.c
+ cc libs/printfmt.c
+ cc libs/readline.c
+ cc libs/sbi.c
+ cc libs/string.c
riscv64-unknown-elf-objcopy bin/kernel --strip-all -O binary bin/ucore.img
syx@CHINAMI-40LS008: /mnt/e/Desktop/labcode/labcode/lab2$
```

### 5.6运行自测

make qemu，启动输出：

```bash
syx@CHINAMI-40LS008: /mnt/e/Desktop/labcode/labcode/lab2$ make qemu
OpenSBI v0.4 (Jul  2 2019 11:53:53)
   ____                    _____ ____ _____
  / __ \                  / ____|  _ \_   _|
 | |  | |_ __   ___ _ __ | (___ | |_) || |
 | |  | | '_ \ / _ \ '_ \ \___ \|  _ < | |
 | |__| | |_) |  __/ | | |____) | |_) || |_
  \____/| .__/ \___|_| |_|_____/|____/_____|
        | |
        |_|

Platform Name       : QEMU Virt Machine
Platform HART Features : RV64ACDFIMSU
Platform Max HARTs     : 8
Current Hart           : 0
Firmware Base          : 0x80000000
Firmware Size          : 112 KB
Runtime SBI Version    : 0.1
PMP0: 0x0000000000000000 - 0x000000008001ffff (A)
PMP1: 0x0000000000000000 - 0xffffffffffffffff (A,R,W,X)
DTB Init
HartID: 0
DTB Address: 0x82200000
Physical Memory from DTB:
Base: 0x0000000080000000
Size: 0x0000000008000000 (128 MB)
End: 0x0000000087ffffff
DTB init completed
(THU.CST) os is loading ...
Special kernel symbols:
entry 0xffffffc02000d8 (virtual)
etext 0xffffffc02010dc (virtual)
edata 0xffffffc0206018 (virtual)
end 0xffffffc02060e8 (virtual)
Kernel executable memory footprint: 25KB
memory management: default_pmm_manager
physical memory map:
memory: 0x0000000080000000, [0x0000000080000000, 0x0000000087ffffff].
check_alloc_page() succeeded!
satp virtual address: 0xffffffc0205000
satp physical address: 0x0000000080205000
[SLUB] basic OK
```

## 6.测试设计

### 6.1 test_slub.c

basic：覆盖常见size-class的分配/写入/释放；

stress_small：2K次1..200B的随机分配/错位释放；

big_blocks：跨页与非页对齐的大块；

mix：小块与大块混合场景；

### 6.2通过判据

所有assert()不触发；

控制台出现四行...OK与最后alltestspassed!；

长时间运行不崩溃/不泄漏。

## 7.结果与分析

正确性：四组用例全部通过，验证了：

size-class取整、freelist弹/推、partial/full列表迁移；

空slab立刻回收至页分配器；

大块路径的魔数识别与整页释放。

内存效率：对象对齐后页内切分，元信息仅占页首；碎片度与size-class粒度相关，符合SLUB预期。

# 扩展练习Challenge：硬件的可用物理内存范围的获取方法（思考题）

如果OS无法提前知道当前硬件的可用物理内存范围，请问你有何办法让OS获取可用物理内存范围？

解析设备树（DTB）：

启动时由固件传入DTB地址，OS从"memory"节点解析出可用物理内存基址与大小。

读取固件或引导程序提供的系统表：

例如BIOS的e820表、UEFIMemoryMap、ACPI表或OpenSBI调用接口。

让Bootloader显式传参：

启动时通过寄存器或结构体告知OS内存范围。