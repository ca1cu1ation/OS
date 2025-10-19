# First-Fit 连续物理内存分配算法实现与分析

本文档基于 `kern/mm/default_pmm.c` 中的实现，说明 First-Fit（首次适应）物理内存分配器各函数的职责、分配/释放的流程、实现细节、复杂度分析以及可改进点，供实验报告直接引用。

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
- `basic_check()` / `default_check()`：自检用例，覆盖基本分配/释放、分裂/合并及 `nr_free` 校验，用于验证实现正确性（不应修改）。

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

综合建议：教学环境下可保留当前实现并实现 `next-fit` 作为性能对比；工程化场景优先考虑分级链表或大小索引结构，再结合并发优化。

---

## Best-Fit 算法实现说明

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

- 使用代码中的 `default_check()` 和 `basic_check()` 进行自检，这些测试覆盖了常见的功能与边界行为。
- 为更深入评估，可编写压力测试脚本模拟随机分配/释放序列，统计成功率、平均分配时间与碎片率。

---

## 总结

- 实现简洁明了：按地址有序的空闲块链表 + 块头 `property` 字段，使分裂与合并逻辑清晰。
- 优点：实现简单、便于理解，合并操作直接且高效。
- 缺点：分配查找为线性时间，面对大量空闲块或频繁分配场景性能不足；外部碎片在某些负载下会增多。
- 可改进方向：分级链表、大小索引、buddy 系统、并发优化等，按需求和实现复杂度权衡选取。


---
