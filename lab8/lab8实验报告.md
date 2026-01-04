## 练习 1：SFS 文件读操作实现（刘平）

### 一、实验目的

本实验的目的是在理解 **SFS（Simple File System）文件访问流程** 的基础上，补全 `kern/fs/sfs/sfs_inode.c` 中 `sfs_io_nolock()` 函数的**读文件数据部分实现**。
通过本实验，掌握：

* 文件偏移到磁盘块的映射关系
* 处理非对齐读、整块读和尾部读的基本方法
* SFS 文件系统中数据块访问接口的使用方式

---

### 二、相关函数与数据结构说明

`sfs_io_nolock()` 是 SFS 中负责**文件数据 I/O** 的核心函数，其主要参数含义如下：

* `offset`：文件内读写起始偏移
* `endpos`：读写结束位置
* `blkno`：对应的逻辑块号
* `nblks`：需要处理的完整数据块数量
* `buf`：用户缓冲区
* `write`：标志位，区分读操作与写操作

在读文件时，需要通过以下接口完成数据访问：

* `sfs_bmap_load_nolock()`
  将文件的逻辑块号映射为磁盘上的物理块号
* `sfs_buf_op()`
  对块内指定偏移和长度的数据进行读写
* `sfs_block_op()`
  对整个数据块进行读写

---

### 三、实现思路分析

文件读操作需要考虑**文件偏移与磁盘块大小（`SFS_BLKSIZE`）不对齐**的情况，因此整个过程被划分为三类情况处理：

1. **首个不完整数据块**
2. **中间的完整数据块**
3. **最后一个不完整数据块**

这样可以保证在任意偏移和长度条件下，均能正确读取文件数据。

---

### 四、读文件代码实现分析

#### （1）首个部分数据块读取

当 `offset` 不是块大小的整数倍时，说明读操作从一个数据块的中间位置开始：

* 计算块内偏移 `blkoff`
* 根据剩余块数决定本次读取长度
* 若数据块已分配，则从磁盘读取对应部分
* 若未分配且为读操作，则返回全 0 数据

```c
if ((blkoff = offset % SFS_BLKSIZE) != 0) {
        size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)) != 0) {
            goto out;
        }
        alen += size;
        if (nblks == 0) {
            goto out;
        }
        buf += size, blkno++, nblks--;
    }
```

**关键点说明**：

* `sfs_buf_op()` 用于块内偏移访问
* 未分配数据块在读时返回 0，符合稀疏文件语义

---

#### （2）完整数据块读取

对于中间对齐的完整数据块，可以直接按块进行读取：

```c
while (nblks != 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_block_op(sfs, buf, ino, 1)) != 0) {
            goto out;
        }
        size = SFS_BLKSIZE, alen += size;
        buf += size, blkno++, nblks--;
    }
```

**关键点说明**：

* `sfs_block_op()` 一次处理整个数据块
* 对于未分配块，直接填充 0

---

#### （3）最后一个部分数据块读取

当读取长度不足一个完整数据块时，需单独处理尾部：

```c
if ((size = endpos % SFS_BLKSIZE) != 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)) != 0) {
            goto out;
        }
        alen += size;
    }
```

**关键点说明**：

* 块内偏移为 0
* 仅读取实际需要的字节数

---

### 五、实验结果与总结

通过完成 `sfs_io_nolock()` 读文件部分的实现，本实验成功实现了 **SFS 文件系统在任意偏移和长度条件下的正确读操作**。
实验过程中加深了对以下内容的理解：

* 文件逻辑块与物理块的映射机制
* 文件系统中“稀疏文件”的处理方式
* 按块与按偏移访问磁盘数据的区别
* 操作系统中读写路径的整体执行流程

本实验为后续理解 **文件写操作、缓冲区管理以及 VFS 层文件访问流程** 奠定了坚实基础。

下面是一份完整的 **UNIX 管道（Pipe）机制设计方案实验报告（Markdown 格式）**。包含数据结构、接口定义、同步互斥设计、参考 Linux 机制等内容，可直接用于课程实验报告。

---

## 练习2: 完成基于文件系统的执行程序机制的实现（陈谊斌）

改写 `proc.c` 中的 `load_icode` 函数和其他相关函数，实现基于文件系统的执行程序机制。

### 1. `alloc_proc` 函数的修改
在 `alloc_proc` 函数中，我们需要初始化 `proc_struct` 中的 `filesp` 指针。`filesp` 是指向文件描述符表的指针，用于管理进程打开的文件。

```c
// kern/process/proc.c

static struct proc_struct *
alloc_proc(void) {
    // ...
    proc->filesp = NULL; // 初始化 filesp 为 NULL
    // ...
}
```

### 2. `do_fork` 函数的修改
在 `do_fork` 函数中，当创建一个新的子进程时，我们需要复制父进程的文件描述符表。这通过调用 `copy_files` 函数来实现。

```c
// kern/process/proc.c

int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    // ...
    // 复制文件描述符表
    if (copy_files(clone_flags, proc) != 0) { 
        goto bad_fork_cleanup_kstack;
    }
    // ...
}
```

### 3. `load_icode` 函数的实现
`load_icode` 函数的主要功能是加载执行程序。在 Lab 8 中，我们需要从文件系统中读取 ELF 格式的二进制文件，并将其加载到内存中执行。

主要步骤如下：
1.  **建立内存管理器**：检查当前进程的内存管理器 `mm` 是否为空，如果不为空则报错。创建一个新的 `mm` 结构，并设置页目录表。
2.  **读取 ELF 头**：使用 `load_icode_read` 函数从文件描述符 `fd` 中读取 ELF 头 (`elfhdr`)。
3.  **校验 ELF 头**：检查 ELF 魔数是否正确。
4.  **加载程序段**：
    *   遍历 ELF 头中的程序头表 (`proghdr`)。
    *   对于类型为 `ELF_PT_LOAD` 的段，根据其标志位（读、写、执行）设置虚拟内存权限 (`vm_flags`) 和页表权限 (`perm`)。
    *   调用 `mm_map` 建立虚拟地址空间的映射。
    *   分配物理页，并使用 `load_icode_read` 将文件中的段内容读取到内存中。
    *   处理 BSS 段（未初始化数据段），将其对应的内存清零。
5.  **建立用户栈**：
    *   调用 `mm_map` 映射用户栈空间 (`USTACKTOP - USTACKSIZE`)。
    *   分配物理页以支持栈的使用。
6.  **切换页表**：
    *   增加 `mm` 的引用计数。
    *   更新当前进程的 `mm` 和 `pgdir`。
    *   调用 `lsatp` 切换页表基址寄存器，并刷新 TLB。
7.  **处理用户参数**：
    *   计算参数字符串的总长度，并确定栈顶位置。
    *   将参数字符串逐个拷贝到用户栈中。
    *   在栈上设置参数指针数组 (`argv`)，使其指向栈上的参数字符串。
    *   确保栈指针对齐。
8.  **设置 Trapframe**：
    *   清空 `trapframe`。
    *   设置栈指针 `sp` 为当前用户栈顶。
    *   设置 `epc` 为 ELF 文件的入口点 (`e_entry`)。
    *   设置状态寄存器 `status`，清除 `SSTATUS_SPP`（进入用户模式），设置 `SSTATUS_SPIE`（允许中断）。
    *   设置参数 `a0` (argc) 和 `a1` (argv)。

关键代码片段：

```c
static int load_icode(int fd, int argc, char **kargv) {
    // ... (初始化 mm 和 pgdir)

    // 读取 ELF 头
    if ((ret = load_icode_read(fd, elf, sizeof(struct elfhdr), 0)) != 0) {
        goto bad_elf_cleanup_pgdir;
    }

    // ... (校验 ELF)

    // 遍历程序头并加载段
    for (int i = 0; i < elf->e_phnum; i ++) {
        // ... (读取 proghdr)
        if (ph->p_type != ELF_PT_LOAD) continue;
        
        // 设置权限
        vm_flags = 0, perm = PTE_U | PTE_V;
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
        if (vm_flags & VM_WRITE) perm |= PTE_W;
        if (vm_flags & VM_EXEC) perm |= PTE_X;
        if (vm_flags & VM_READ) perm |= PTE_R;

        // 建立映射并分配内存
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
            goto bad_cleanup_mmap;
        }
        
        // ... (分配页并读取文件内容到内存)
    }

    // 建立用户栈
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
        goto bad_cleanup_mmap;
    }
    // 分配栈内存
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_U | PTE_V | PTE_R | PTE_W  ) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_U | PTE_V | PTE_R | PTE_W) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_U | PTE_V | PTE_R | PTE_W) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_U | PTE_V | PTE_R | PTE_W) != NULL);

    // 切换页表
    mm_count_inc(mm);
    current->mm = mm;
    current->pgdir = PADDR(mm->pgdir);
    lsatp(PADDR(mm->pgdir));
    flush_tlb();

    // 处理用户参数 (argc, argv)
    uintptr_t sp = USTACKTOP;
    uintptr_t uargv_ptr[EXEC_MAX_ARG_NUM];
    
    // 将参数字符串拷贝到用户栈
    for (int i = 0; i < argc; i++) {
        size_t len = strlen(kargv[i]) + 1;
        sp -= len;
        // ... (拷贝字符串内容到 sp 指向的内存)
        uargv_ptr[i] = sp;
    }
    
    // 栈指针对齐
    sp = sp & ~((uintptr_t)sizeof(uintptr_t) - 1);
    
    // 压入 argv 数组 (NULL 结尾)
    sp -= sizeof(uintptr_t);
    *(uintptr_t *)(page2kva(pte2page(*get_pte(mm->pgdir, sp, 0))) + (sp % PGSIZE)) = 0;
    
    for (int i = argc - 1; i >= 0; i--) {
        sp -= sizeof(uintptr_t);
        *(uintptr_t *)(page2kva(pte2page(*get_pte(mm->pgdir, sp, 0))) + (sp % PGSIZE)) = uargv_ptr[i];
    }
    
    uintptr_t argv_base = sp;

    // 设置 Trapframe
    struct trapframe *tf = current->tf;
    memset(tf, 0, sizeof(struct trapframe));
    tf->gpr.sp = sp;
    tf->epc = elf->e_entry;
    tf->status = read_csr(sstatus) & ~SSTATUS_SPP;
    tf->status |= SSTATUS_SPIE;
    tf->gpr.a0 = argc;
    tf->gpr.a1 = argv_base;

    return 0;
    // ... (错误处理)
}
```

通过以上修改，内核能够从文件系统中读取程序并创建进程执行，完成了 Lab 8 的核心功能。

## 扩展练习 Challenge1：基于 UNIX 的 PIPE 机制设计方案

### 一、实验目的

实现 uCore 内核中 **UNIX 风格的管道（Pipe）机制** 的设计方案。

UNIX 管道是一种轻量级进程间通信（IPC）机制，允许一个进程的输出直接作为另一个进程的输入。本实验旨在：

* 设计适用于 uCore 内核的数据结构和接口
* 理解管道的缓冲区管理、同步互斥机制
* 分析可能出现的竞态条件并提出解决方案

---

### 二、设计原则与背景

UNIX 管道具有以下基本特征：

1. **无名管道（Unnamed Pipe）**
   管道由内核创建，通常用于父子进程间通信，与文件系统路径无关。
2. **单向数据流**
   管道从写端到读端单向传输数据。
3. **阻塞与非阻塞 I/O**
   在读端无数据时阻塞读者；写端缓冲区满时阻塞写者。
4. **引用计数 / 生命周期管理**
   管道可由多个文件描述符引用，直至所有读写端关闭再释放资源。

Linux 中的 pipe 实现大致基于一个循环缓冲区结构：

* 每个管道由 `struct pipe_inode_info` 表示
* 两个 file 对象分别表示读端和写端
* 内核通过缓冲区、信号量/自旋锁保证并发安全

本设计方案借鉴 Linux 机制，同时简化为适配 uCore 内核。

---

### 三、主要设计方案

#### 3.1 关键数据结构

##### 3.1.1 管道缓冲区

```c
#define PIPE_BUF_SIZE 4096  /* 管道缓冲区大小 */

struct pipe_buffer {
    char data[PIPE_BUF_SIZE]; /* 环形缓冲区 */
    int head;                 /* 写者写入位置 */
    int tail;                 /* 读者读取位置 */
    int count;                /* 当前缓冲区中字节数 */
};
```

---

##### 3.1.2 管道对象结构

```c
#include <types.h>
#include <spinlock.h>
#include <condvar.h>

struct pipe {
    struct pipe_buffer buf; /* 管道数据缓冲区 */

    struct spinlock lock;   /* 保护缓冲区和状态 */
    struct condvar read_cv; /* 等待读者条件变量 */
    struct condvar write_cv;/* 等待写者条件变量 */

    int ref_read;  /* 读端引用计数 */
    int ref_write; /* 写端引用计数 */
    int closed_read;  /* 读端是否关闭 */
    int closed_write; /* 写端是否关闭 */
};
```

---

##### 3.1.3 文件对象扩展

为使文件描述符区分管道读写端，可扩展文件结构：

```c
#define PIPE_READ  0x1
#define PIPE_WRITE 0x2

struct file {
    ...
    struct pipe *pipe;    /* 若是管道，则指向管道对象 */
    int pipe_mode;        /* 管道打开模式：PIPE_READ / PIPE_WRITE */
    ...
};
```

---

#### 3.2 管道接口设计

以下接口为功能语义说明，不要求具体实现：

##### 3.2.1 创建管道

```c
/*
 * pipe(fd[2]):
 *   创建一个新的管道
 *   fd[0] -> 读端文件描述符
 *   fd[1] -> 写端文件描述符
 */
int sys_pipe(int fd[2]);
```

---

##### 3.2.2 管道读操作

```c
/*
 * pipe_read(file, buf, len):
 *   从管道读取最多 len 字节
 *   若缓冲区为空，则阻塞直到有数据或写端关闭
 * 返回读取实际字节数，失败返回 < 0
 */
ssize_t pipe_read(struct file *file, void *buf, size_t len);
```

---

##### 3.2.3 管道写操作

```c
/*
 * pipe_write(file, buf, len):
 *   向管道写最多 len 字节
 *   若缓冲区已满，则阻塞直到有可用空间或读端关闭
 * 返回写入字节数，失败返回 < 0
 */
ssize_t pipe_write(struct file *file, const void *buf, size_t len);
```

---

##### 3.2.4 关闭管道端口

```c
/*
 * pipe_close(file):
 *   关闭管道的读/写端
 *   若所有端均关闭，则释放管道资源
 */
int pipe_close(struct file *file);
```

---

### 四、同步互斥机制设计

#### 4.1 为什么需要同步

在多进程环境下：

* 读端和写端可能竞争访问同一内核缓冲区
* 多个写者同时写入，或多个读者同时读取
* 若无适当同步，会导致缓冲区数据破坏、竞态条件或不可预期行为

---

#### 4.2 锁与条件变量机制

本设计中管道采用以下机制实现安全访问：

* **自旋锁（spinlock）保护缓冲区和状态**
  在读写操作进入临界区前必须先获取锁，确保缓冲区一致性。
* **条件变量（condvar）实现阻塞与唤醒**

  * 读者在缓冲区为空时进入读等待队列
  * 写者在缓冲区为满时进入写等待队列
  * 数据到达/空间释放时通过条件变量唤醒相对端

---

#### 4.3 细节说明

##### 4.3.1 读阻塞情况

当缓冲区无数据且写端仍存活时：

1. 获取锁
2. 检查缓冲区
3. 进入等待 `read_cv`
4. 被写端唤醒后重新检查缓冲区

当写端全部关闭且缓冲区为空时，应返回 EOF。

---

##### 4.3.2 写阻塞情况

当缓冲区无可写空间且读端仍存活时：

1. 获取锁
2. 检查缓冲区空间
3. 进入等待 `write_cv`
4. 被读端唤醒后重新检查空间

若读端已全部关闭，则写操作应收到 `SIGPIPE` 或返回错误。

---

### 五、流程图（核心读写流程）

```
   PIPE READ                              PIPE WRITE
+--------------+                      +---------------+
| lock acquired|                      | lock acquired |
+--------------+                      +---------------+
        |                                      |
if buf empty? ---- YES -----> if write open? ---- YES --> wait read_cv
        |                     |                     |
 ELSE   v                     NO                    NO
read bytes + signal write_cv  return EOF          return EPIPE
        |
 signal write_cv
 unlock
```

---

### 六、参考 Linux 实现概览

Linux 内核中的管道机制大致定义如下：

* `struct pipe_inode_info`
  管道内核对象，包含循环缓冲区、锁与等待队列
* 通过 `pipe()` 系统调用创建一对文件描述符
* `pipefs` 文件系统用于管理匿名管道
* 使用 `wait_event()` / `wake_up()` 实现阻塞与线程唤醒

该实现保证了 UNIX 规范的语义行为。

---

### 七、实验总结

本设计方案通过：

* 管道缓冲区结构，保证数据以环形队列存放
* 管道对象引用计数和生命周期控制
* 锁与条件变量实现多进程安全访问

满足了 UNIX 管道的基本要求，并兼顾阻塞语义。

通过本实验，对 uCore 内核中 IPC 机制设计有了更深理解，为后续实现多进程同步、消息队列、共享内存等高级机制打下良好基础。


## 扩展练习 Challenge2：UNIX 软连接和硬连接机制设计方案

### 1. 机制概述

*   **硬连接 (Hard Link)**：硬连接本质上是文件系统中的一个目录项，它指向一个已经存在的 inode。多个目录项可以指向同一个 inode。只有当指向该 inode 的所有硬连接都被删除（引用计数为 0），且该文件没有被任何进程打开时，文件的数据和 inode 才会被真正释放。硬连接通常不能跨文件系统，也不能指向目录（为了避免循环）。
*   **软连接 (Symbolic Link / Soft Link)**：软连接是一个特殊类型的文件，其内容是一个字符串，该字符串指向另一个文件或目录的路径。软连接有自己的 inode。如果目标文件被删除，软连接将变为“悬空”状态（dangling link）。软连接可以跨文件系统，也可以指向目录。

### 2. 数据结构设计

ucore 的 SFS (Simple File System) 已经定义了基本的 inode 结构。我们需要利用现有的字段并稍作扩展。

#### 2.1 磁盘上的 Inode (`struct sfs_disk_inode`)

SFS 现有的 `sfs_disk_inode` 结构体已经包含了 `nlinks` 和 `type` 字段，这非常适合实现链接机制。

```c
/* kern/fs/sfs/sfs.h */

/* file types */
#define SFS_TYPE_INVAL                              0
#define SFS_TYPE_FILE                               1
#define SFS_TYPE_DIR                                2
#define SFS_TYPE_LINK                               3  // 软连接类型

/* inode (on disk) */
struct sfs_disk_inode {
    uint32_t size;                                  /* 如果是软连接，这里表示路径字符串的长度 */
    uint16_t type;                                  /* SFS_TYPE_FILE, SFS_TYPE_DIR, SFS_TYPE_LINK */
    uint16_t nlinks;                                /* 硬连接计数 */
    uint32_t blocks;                                /* 占用的块数 */
    uint32_t direct[SFS_NDIRECT];                   /* 直接块索引 */
    uint32_t indirect;                              /* 间接块索引 */
};
```

*   **硬连接**：多个 `sfs_disk_entry` (目录项) 中的 `ino` 字段指向同一个 `sfs_disk_inode` 的索引。该 inode 的 `nlinks` 字段记录有多少个目录项指向它。
*   **软连接**：创建一个新的 inode，其 `type` 为 `SFS_TYPE_LINK`。该 inode 的数据块（`direct` 数组指向的块）中存储目标文件的路径字符串。

#### 2.2 内存中的 Inode (`struct sfs_inode`)

内存中的 inode 结构保持不变，但需要注意 `reclaim_count` (内存引用计数) 和磁盘上的 `nlinks` (硬连接计数) 的区别。

### 3. 接口设计

需要在 VFS 层和 SFS 层添加相应的操作接口。

#### 3.1 系统调用与 VFS 接口

*   **`int link(const char *oldpath, const char *newpath)`**
    *   **语义**：为 `oldpath` 指定的文件创建一个名为 `newpath` 的硬连接。
    *   **VFS 接口**：`vop_link(old_node, new_dir, new_name)`。

*   **`int symlink(const char *target, const char *linkpath)`**
    *   **语义**：创建一个名为 `linkpath` 的软连接，其内容为 `target`。
    *   **VFS 接口**：`vop_symlink(dir, name, target)`。

*   **`int unlink(const char *path)`**
    *   **语义**：删除 `path` 指定的目录项。如果该目录项是文件的最后一个硬连接，则删除该文件。
    *   **VFS 接口**：`vop_unlink(dir, name)`。

*   **`int readlink(const char *path, char *buf, size_t bufsiz)`**
    *   **语义**：读取软连接 `path` 的内容（即目标路径）到 `buf` 中。
    *   **VFS 接口**：`vop_readlink(node, iobuf)`。

#### 3.2 SFS 层实现概要

*   **`sfs_link`**:
    1.  查找 `oldpath` 对应的 inode (`old_inode`)。
    2.  检查 `old_inode` 是否为目录（通常禁止硬连接目录）。
    3.  在 `newpath` 的父目录中创建一个新的目录项 (`sfs_disk_entry`)，将其 `ino` 指向 `old_inode` 的编号。
    4.  **同步互斥**：锁定 `old_inode`，增加其 `nlinks` 计数，标记为 dirty，写入磁盘。
    5.  解锁。

*   **`sfs_symlink`**:
    1.  分配一个新的 inode (`new_inode`)，设置类型为 `SFS_TYPE_LINK`。
    2.  将 `target` 路径字符串写入 `new_inode` 的数据块中。
    3.  在 `linkpath` 的父目录中创建一个新的目录项，指向 `new_inode`。
    4.  设置 `new_inode` 的 `nlinks` 为 1。
    5.  将 `new_inode` 写入磁盘。

*   **`sfs_unlink`**:
    1.  在父目录中查找并删除对应的目录项。
    2.  查找对应的 inode (`target_inode`)。
    3.  **同步互斥**：锁定 `target_inode`，递减 `nlinks`。
    4.  如果 `nlinks` 变为 0 且内存引用计数 (`reclaim_count`) 允许，则释放该 inode 及其占用的所有数据块（位图操作）。
    5.  更新 inode 到磁盘。

*   **路径查找 (`vop_lookup`) 的修改**:
    *   在解析路径时，如果遇到 inode 类型为 `SFS_TYPE_LINK`：
        1.  读取软连接的内容（目标路径）。
        2.  将当前路径组件替换为目标路径。
        3.  **循环检测**：维护一个递归深度计数器（例如限制为 32），防止软连接循环导致死循环。

### 4. 同步互斥问题的处理

在实现过程中，必须处理并发访问导致的竞争条件：

1.  **Inode 锁 (`sfs_inode.sem`)**:
    *   在修改 inode 的 `nlinks` 字段时，必须持有该 inode 的信号量/锁。
    *   在读取或写入软连接内容时，需要持有锁。

2.  **文件系统锁 (`sfs_fs.mutex_sem`)**:
    *   目录操作（创建链接、删除链接）涉及到修改目录的数据块（添加/删除 `sfs_disk_entry`）。这些操作应该是原子的。
    *   可以使用文件系统级别的锁，或者更细粒度的目录 inode 锁来保护目录项的修改。

3.  **死锁避免**:
    *   在 `link` 操作中，可能涉及两个 inode（源文件和目标目录）。需要规定加锁顺序（例如按 inode 编号排序，或者先锁目录再锁文件）以避免死锁。
    *   在 `unlink` 操作中，同样涉及目录 inode 和目标文件 inode。

4.  **引用计数一致性**:
    *   `nlinks` 的修改和目录项的增删必须保持一致。如果在增加 `nlinks` 后创建目录项失败，必须回滚 `nlinks` 的修改。这通常需要日志系统支持，但在简单实现中，应确保操作顺序：先修改 inode (inc nlinks)，再写入目录项。如果目录项写入失败，再回滚 inode。或者，利用 SFS 的 `dirty` 标志，确保在关键步骤完成前不刷新到磁盘，但这在 ucore 这种简单文件系统中可能较难完全保证崩溃一致性。

通过上述设计，ucore 可以支持标准的 UNIX 链接机制，增强文件系统的灵活性和兼容性。

## 实验运行结果

### 一、测试 sh 用户程序执行

**进入 sh 用户执行界面**

输入 `make qemu` ，进入sh用户执行界面
```bash
root@LAPTOP-N6OUKIU2:/mnt/e/labcode/lab8# make qemu

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
  etext  0xc020b60e (virtual)
  edata  0xc0291060 (virtual)
  end    0xc0296910 (virtual)
Kernel executable memory footprint: 603KB
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
Page table directory switch succeeded!
Kernel stack guardians set succeeded!
check_pgdir() succeeded!
check_boot_pgdir() succeeded!
use SLOB allocator
kmalloc_init() succeeded!
check_vma_struct() succeeded!
check_vmm() succeeded.
sched class: RR_scheduler
Initrd: 0xc0214010 - 0xc021bd0f, size: 0x00007d00
Initrd: 0xc021bd10 - 0xc029100f, size: 0x00075300
sfs: mount: 'simple file system' (106/11/117)
vfs: mount disk0.
++ setup timer interrupts
kernel_execve: pid = 2, name = "sh".
user sh is running!!!
$ 
```

sh 启动成功后，可以在用户界面输入 user 目录下的文件名，执行对应程序。

下面展示几个程序的执行结果：

1. **执行hello程序**

```bash
Hello world!!.
I am process 4.
hello pass.
```

执行 hello ，程序成功加载并输出信息，证明 load_icode 能够正确解析并加载 ELF 格式文件。

2. **执行fortest程序**

```bash
I am child 0
I am child 1
I am child 2
I am child 3
I am child 4
I am child 5
I am child 6
I am child 7
I am child 8
I am child 9
I am child 10
I am child 11
I am child 12
I am child 13
I am child 14
I am child 15
I am child 16
I am child 17
I am child 18
I am child 19
I am child 20
I am child 21
I am child 22
I am child 23
I am child 24
I am child 25
I am child 26
I am child 27
I am child 28
I am child 29
I am child 30
I am child 31
forktest pass.
```

执行 forktest，大量创建子进程并正常回收，证明文件系统与进程管理模块协同工作正常。

3. **执行exit程序**

```bash
I am the parent. Forking the child...
I am parent, fork a child pid 9
I am the parent, waiting now..
I am the child.
waitpid 9 ok.
exit pass.
```

执行 exit，程序成功加载并输出信息，然后退出，证明 load_icode 能够正确解析并加载 ELF 格式文件。

4. **执行testbss程序**

```bash
Making sure bss works right...
Yes, good.  Now doing a wild write off the end...
testbss may pass.
not valid addr c02000, and  can not find it in vma
page fault at 0x00c02000: invalid parameter
error: -9 - process is killed
```

执行 testbss，程序验证了 BSS 段已被正确清零。随后程序尝试非法写入内存，触发缺页异常并被内核终止，符合预期。

### 二、测试 make grade

输入 `make grade` ，终端输出如下：

```bash
  -sh execve:                                OK
  -user sh :                                 OK
Total Score: 100/100
```

虚拟文件系统（VFS）能够正确挂载磁盘，内核能够正确执行用户程序，用户态 shell 程序能够正常运行，测试脚本成功通过。