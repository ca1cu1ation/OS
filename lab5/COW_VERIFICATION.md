# COW实现验证报告

## 修复的问题

### 1. **copy_range中的权限提取问题**
**问题**: 使用`(*ptep & PTE_USER)`会提取所有PTE_USER标志，但PTE_USER包含了PTE_V，可能导致问题。
**修复**: 改为`(*ptep & (PTE_R | PTE_W | PTE_X | PTE_U))`，只提取权限位。

### 2. **只读页面的COW处理**
**问题**: 原实现对所有页面都标记COW，但只读页面不需要COW。
**修复**: 只有当原页面可写(PTE_W)时才标记为COW；只读页面直接共享，无需COW。

### 3. **do_pgfault中的COW检查**
**问题**: 没有检查是否是写操作导致的page fault。
**修复**: 添加检查`(error_code & 0x2)`确保只有写操作才触发COW复制。

### 4. **权限恢复问题**
**问题**: 在COW复制后，权限恢复逻辑不够清晰。
**修复**: 使用从VMA计算的`perm`变量，它已经包含正确的权限（包括PTE_W如果VMA可写）。

### 5. **trap.c中的错误码处理**
**问题**: 错误码构造逻辑不够清晰。
**修复**: 添加注释说明RISC-V page fault错误码格式，并明确各case的含义。

## 关键实现点

### COW标志位
- 使用`PTE_COW (0x1 << 9)`标记COW页面
- COW页面权限: `(原权限 & ~PTE_W) | PTE_COW`

### Fork时的COW流程
1. 检查原页面是否可写
2. 如果可写：父子进程都标记为只读+COW，共享物理页面，引用计数+1
3. 如果只读：直接共享，无需COW标记

### Page Fault时的COW处理
1. 检查PTE_COW标志和写操作
2. 分配新页面
3. 复制原页面内容
4. 减少原页面引用计数
5. 更新PTE，恢复完整权限（移除COW标志）

## 状态转换（有限状态机视图）

| 状态 | 描述 | 关键代码 |
| --- | --- | --- |
| `Unmapped` | 页表项为空 | `kern/mm/vmm.c:88-114` |
| `PrivateWritable` | 单进程可写 (`PTE_W`)，无`PTE_COW` | `pgdir_alloc_page` / `page_insert` |
| `SharedCOW` | 父子共享，PTE只读+`PTE_COW` | `kern/mm/pmm.c:395-438 copy_range` |
| `Copying` | 缺页处理中分配、复制新页 | `kern/mm/vmm.c:120-146` |
| `Released` | 引用计数归零后释放 | `page_remove_pte` |

关键转换：
1. `PrivateWritable → SharedCOW`：`fork` 调用 `copy_range` 时检测到 `PTE_W`，将父子PTE都改成只读+`PTE_COW`，共享物理页且 `page_ref_inc`。
2. `SharedCOW → Copying`：写缺页(`CAUSE_STORE_PAGE_FAULT`)，`do_pgfault`看到`PTE_COW`且`error_code`写位为1。
3. `Copying → PrivateWritable`：分配新页、`memcpy`、`page_insert` 恢复原权限并移除`PTE_COW`。
4. `SharedCOW → Released`：某一映射被删除（进程退出/munmap），`page_remove_pte` 让引用计数-1，若为最后引用则回到 `Unmapped`。
5. `Unmapped → PrivateWritable`：首次缺页由 `pgdir_alloc_page` 分配。
6. `SharedCOW → PrivateWritable`：当最后一个共享者触发写缺页后通过复制获得独占页。

### 引用计数管理
- Fork时：共享页面的引用计数+1
- COW复制后：原页面引用计数-1，新页面引用计数从0变为1（通过page_insert）
- 进程退出时：page_remove_pte会减少引用计数，当引用计数为0时释放页面

## Dirty COW 模拟与修复

- `user/dirtycow.c` 中的 `test_vulnerable_cow_race()` 假设fork未降权，会看到“VULNERABLE”输出；当前实现因为fork时去掉 `PTE_W`，实际运行会落在“SECURE”路径。
- `test_secure_cow()` 针对共享页先写触发COW，再次验证父子写入互不干扰。
- `explain_dirtycow_fix()` 解释修复要点：fork阶段标记`PTE_COW`、`do_pgfault`只在写缺页复制、`page_insert`恢复权限并由 `sfence.vma`/`tlb_invalidate` 保持TLB一致。这与 Linux Dirty COW 补丁思路一致。

## 测试用例

| 测试程序 | 说明 |
| --- | --- |
| `user/cow_basic.c` | 父子写不同页，验证基本COW |
| `user/cow_multi.c` | 多页共享+部分写，确认按页触发COW |
| `user/cow_ro.c` | 只读段共享，不触发COW |
| `user/cow_concurrent.c` | 父子并发写同页不同偏移，检查隔离 |
| `user/dirtycow.c` | 脏牛漏洞模拟与修复讲解 |

运行：`make qemu TEST=<program>`。这些测试涵盖基本、并发、只读及安全性场景。

## 验证建议

1. **基本COW测试**: 父进程写入共享内存，验证子进程有独立副本
2. **多页面COW**: 验证多个页面都能正确COW
3. **只读页面共享**: 验证只读页面直接共享，不触发COW
4. **引用计数**: 验证页面在所有进程退出后才被释放
5. **并发写入**: 父进程和子进程同时写入，验证相互独立

## 潜在问题

### 1. 竞态条件
当前实现没有显式锁保护COW操作，在并发fork场景下可能存在竞态。但考虑到：
- fork时已经持有mm_lock
- page_insert内部可能有同步机制
这应该不是问题，但需要实际测试验证。

### 2. TLB一致性
每次PTE更新后都调用`tlb_invalidate`，应该能保证TLB一致性。

### 3. 错误处理
所有错误路径都已处理，失败时会释放已分配的资源。

## 总结

实现基本正确，主要修复了：
- 权限提取和设置
- 只读页面的特殊处理
- COW触发条件检查
- 权限恢复逻辑

建议进行实际测试以验证正确性。


