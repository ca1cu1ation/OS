#include <vmm.h>
#include <sync.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <error.h>
#include <pmm.h>
#include <riscv.h>
#include <kmalloc.h>

// 打开为 1 表示启用 Dirty COW 修复（加锁 + 禁止写穿后备页）
// 保持为 0 表示处于“漏洞态”
#define FIX_DIRTY_COW 0

/*
  vmm design include two parts: mm_struct (mm) & vma_struct (vma)
  mm is the memory manager for the set of continuous virtual memory
  area which have the same PDT. vma is a continuous virtual memory area.
  There a linear link list for vma & a redblack link list for vma in mm.
---------------
  mm related functions:
   golbal functions
     struct mm_struct * mm_create(void)
     void mm_destroy(struct mm_struct *mm)
     int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr)
--------------
  vma related functions:
   global functions
     struct vma_struct * vma_create (uintptr_t vm_start, uintptr_t vm_end,...)
     void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
     struct vma_struct * find_vma(struct mm_struct *mm, uintptr_t addr)
   local functions
     inline void check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
---------------
   check correctness functions
     void check_vmm(void);
     void check_vma_struct(void);
     void check_pgfault(void);
*/

static void check_vmm(void);
static void check_vma_struct(void);

volatile unsigned int pgfault_num = 0;

// do_pgfault - handle page fault exception
// @mm         : the mm_struct that owns the faulting memory
// @error_code : the error code (bit 0: present, bit 1: write/read)
// @addr       : the faulting address
int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr)
{
    int ret = -E_INVAL;
    // 修复态：对同一 mm 的页表改动整体加锁，覆盖 get_pte/*ptep 判定 + page_insert 等关键区
#if FIX_DIRTY_COW
    lock_mm(mm);
#endif
    struct vma_struct *vma = find_vma(mm, addr);

    pgfault_num++;
    // If the addr is not in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr)
    {
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
        goto failed;
    }
    
    // check the error_code
    switch (error_code & 0x3)
    {
    default:
        /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE))
        {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
        goto failed;
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
        {
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
            goto failed;
        }
    }

    // backing-page fast path: if addr in backing range,优先处理与后备页相关的缺页
    extern struct Page *backing_page_global;
    if (backing_page_global != NULL &&
        mm != NULL &&
        mm->backing_start != 0 &&
        addr >= mm->backing_start && addr < mm->backing_end)
    {
        uintptr_t va = ROUNDDOWN(addr, PGSIZE);
        uint32_t perm = PTE_U | PTE_R;
#if !FIX_DIRTY_COW
        // 漏洞态：写 fault 直接加写权限，允许写穿后备页
        if (error_code & 0x2)
        {
            perm |= PTE_W;
        }
        if (page_insert(mm->pgdir, backing_page_global, va, perm) != 0)
        {
            cprintf("backing map failed\n");
            goto failed;
        }
        ret = 0;
        goto done;
#else
        // 修复态：禁止直接写穿后备页，写 fault 对 backing_page_global 做一次 COW
        if (error_code & 0x2)
        {
            // 写 fault：分配新页，拷贝 backing_page_global 内容，仅当前 VA 映射为可写
            struct Page *page = alloc_page();
            if (page == NULL)
            {
                cprintf("backing COW alloc failed\n");
                goto failed;
            }
            memcpy(page2kva(page), page2kva(backing_page_global), PGSIZE);
            if (page_insert(mm->pgdir, page, va, PTE_U | PTE_R | PTE_W) != 0)
            {
                free_page(page);
                cprintf("backing COW page_insert failed\n");
                goto failed;
            }
        }
        else
        {
            // 读 fault：继续共享只读 backing_page_global
            if (page_insert(mm->pgdir, backing_page_global, va, PTE_U | PTE_R) != 0)
            {
                cprintf("backing map failed\n");
                goto failed;
            }
        }
        ret = 0;
        goto done;
#endif
    }
    
    // Calculate permissions based on VMA flags
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_READ)
    {
        perm |= PTE_R;
    }
    if (vma->vm_flags & VM_WRITE)
    {
        perm |= (PTE_R | PTE_W);
    }
    if (vma->vm_flags & VM_EXEC)
    {
        perm |= PTE_X;
    }
    addr = ROUNDDOWN(addr, PGSIZE);

    pte_t *ptep = NULL;
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL)
    {
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }

    if (*ptep == 0 || ((*ptep & PTE_V) == 0))
    {
        // Missing mapping: alloc anonymous or backing mapping already handled above
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL)
        {
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
            goto failed;
        }
    }
    else if ((*ptep & PTE_COW) && (error_code & 0x2))
    {
        // COW: Copy the page
        struct Page *page = alloc_page();
        if (page == NULL)
        {
            cprintf("do_pgfault failed: cannot allocate page for COW\n");
            goto failed;
        }

        struct Page *old_page = pte2page(*ptep);
        // Copy the page content
        void *src_kvaddr = page2kva(old_page);
        void *dst_kvaddr = page2kva(page);
        memcpy(dst_kvaddr, src_kvaddr, PGSIZE);

        uint32_t new_perm = perm; // restore full permissions from VMA
        if (page_insert(mm->pgdir, page, addr, new_perm) != 0)
        {
            free_page(page);
            cprintf("do_pgfault failed: cannot insert page for COW\n");
            goto failed;
        }
    }
    else
    {
        // Page exists but permissions insufficient: fix up per VMA
#if FIX_DIRTY_COW
        // 修复态：backing 区域不允许走“权限修正”分支，避免把只读 backing 映射改成可写
        if (mm->backing_start != 0 &&
            addr >= mm->backing_start && addr < mm->backing_end)
        {
            goto failed;
        }
#endif
        uint32_t ppn = PTE_ADDR(*ptep) >> PGSHIFT;
        uint32_t new_pte = pte_create(ppn, PTE_V | perm);
        *ptep = new_pte;
        tlb_invalidate(mm->pgdir, addr);
    }
    ret = 0;
failed:
#if FIX_DIRTY_COW
    unlock_mm(mm);
#endif
    return ret;
done:
#if FIX_DIRTY_COW
    unlock_mm(mm);
#endif
    return ret;
}

// A minimalist madvise(MADV_DONTNEED) analog, intentionally without locking
// to allow race windows for Dirty COW style testing.
int do_madvise_dontneed(struct mm_struct *mm, uintptr_t addr, size_t len)
{
    if (mm == NULL || len == 0)
    {
        return 0;
    }
#if FIX_DIRTY_COW
    // 修复态：对同一 mm 的页表改动加锁，关闭 COW+madvise 竞态窗口
    lock_mm(mm);
#endif
    uintptr_t start = ROUNDDOWN(addr, PGSIZE);
    uintptr_t end = ROUNDUP(addr + len, PGSIZE);
    if (!USER_ACCESS(start, end) || start >= end)
    {
#if FIX_DIRTY_COW
        unlock_mm(mm);
#endif
        return -E_INVAL;
    }
    // if this range is the backing range, only clear PTEs without freeing backing_page
    if (mm->backing_start != 0 &&
        start >= mm->backing_start && end <= mm->backing_end)
    {
        for (uintptr_t va = start; va < end; va += PGSIZE)
        {
            pte_t *ptep = get_pte(mm->pgdir, va, 0);
            if (ptep && (*ptep & PTE_V))
            {
                *ptep = 0;
                tlb_invalidate(mm->pgdir, va);
            }
        }
    }
    else
    {
        // 非后备区：仍走普通 unmap_range
        unmap_range(mm->pgdir, start, end);
    }
#if FIX_DIRTY_COW
    unlock_mm(mm);
#endif
    return 0;
}

// Global backing page to simulate page cache
struct Page *backing_page_global = NULL;

// simple unmapped-area finder: pick a start and bump until no overlap
static uintptr_t simple_get_unmapped_area(struct mm_struct *mm, size_t len)
{
    uintptr_t start = 0x40000000;
    uintptr_t end = 0;
    size_t l = ROUNDUP(len, PGSIZE);
    while (1)
    {
        end = start + l;
        if (!USER_ACCESS(start, end) || start >= end)
        {
            return (uintptr_t)-1;
        }
        struct vma_struct *vma = find_vma(mm, start);
        if (vma == NULL || end <= vma->vm_start)
        {
            return start;
        }
        start = ROUNDDOWN(vma->vm_end + PGSIZE, PGSIZE);
    }
}

uintptr_t do_map_backing(struct mm_struct *mm, uintptr_t addr, size_t len)
{
    if (mm == NULL || len == 0)
    {
        cprintf("map_backing: invalid mm/len mm=%p len=%lx\n", mm, len);
        return -E_INVAL;
    }
    uintptr_t start, end;

    if (addr == 0)
    {
        start = simple_get_unmapped_area(mm, len);
        if (start == 0 || start == (uintptr_t)-1)
        {
            cprintf("map_backing: get_unmapped_area failed len=%lx\n", len);
            return -E_NO_MEM;
        }
        end = start + ROUNDUP(len, PGSIZE);
    }
    else
    {
        start = ROUNDDOWN(addr, PGSIZE);
        end = ROUNDUP(addr + len, PGSIZE);
        if (!USER_ACCESS(start, end) || start >= end)
        {
            cprintf("map_backing: USER_ACCESS fail start=%lx end=%lx\n", start, end);
            return -E_INVAL;
        }
    }

    if (backing_page_global == NULL)
    {
        backing_page_global = alloc_page();
        if (backing_page_global == NULL)
        {
            cprintf("map_backing: alloc_page fail\n");
            return -E_NO_MEM;
        }
        memset(page2kva(backing_page_global), 'P', PGSIZE);
    }

    // ensure VMA exists for this range so find_vma works on faults
    struct vma_struct *vma = NULL;
    if (mm_map(mm, start, end - start, VM_READ | VM_WRITE, &vma) != 0)
    {
        cprintf("map_backing: mm_map fail start=%lx end=%lx\n", start, end);
        return -E_NO_MEM;
    }

    // record backing region in mm
    mm->backing_start = start;
    mm->backing_end = end;

    // map backing page as read-only initially
    for (uintptr_t va = start; va < end; va += PGSIZE)
    {
        if (page_insert(mm->pgdir, backing_page_global, va, PTE_U | PTE_R) != 0)
        {
            return -E_NO_MEM;
        }
    }
    return start;
}

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void)
{
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));

    if (mm != NULL)
    {
        list_init(&(mm->mmap_list));
        mm->mmap_cache = NULL;
        mm->pgdir = NULL;
        mm->map_count = 0;

        mm->sm_priv = NULL;

        set_mm_count(mm, 0);
        lock_init(&(mm->mm_lock));
        mm->backing_start = 0;
        mm->backing_end = 0;
    }
    return mm;
}

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags)
{
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));

    if (vma != NULL)
    {
        vma->vm_start = vm_start;
        vma->vm_end = vm_end;
        vma->vm_flags = vm_flags;
    }
    return vma;
}

// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr)
{
    struct vma_struct *vma = NULL;
    if (mm != NULL)
    {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
        {
            bool found = 0;
            list_entry_t *list = &(mm->mmap_list), *le = list;
            while ((le = list_next(le)) != list)
            {
                vma = le2vma(le, list_link);
                if (vma->vm_start <= addr && addr < vma->vm_end)
                {
                    found = 1;
                    break;
                }
            }
            if (!found)
            {
                vma = NULL;
            }
        }
        if (vma != NULL)
        {
            mm->mmap_cache = vma;
        }
    }
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
        {
            break;
        }
        le_prev = le;
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
    }
    if (le_next != list)
    {
        check_vma_overlap(vma, le2vma(le_next, list_link));
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
}

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
    }
    kfree(mm); // kfree mm
    mm = NULL;
}

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
    if (!USER_ACCESS(start, end))
    {
        return -E_INVAL;
    }

    assert(mm != NULL);

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
    {
        goto out;
    }
    ret = -E_NO_MEM;

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;

out:
    return ret;
}

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
    assert(to != NULL && from != NULL);
    list_entry_t *list = &(from->mmap_list), *le = list;
    while ((le = list_prev(le)) != list)
    {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}

void exit_mmap(struct mm_struct *mm)
{
    assert(mm != NULL && mm_count(mm) == 0);
    pde_t *pgdir = mm->pgdir;
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
    }
}

bool copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable)
{
    if (!user_mem_check(mm, (uintptr_t)src, len, writable))
    {
        return 0;
    }
    memcpy(dst, src, len);
    return 1;
}

bool copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len)
{
    if (!user_mem_check(mm, (uintptr_t)dst, len, 1))
    {
        return 0;
    }
    memcpy(dst, src, len);
    return 1;
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
    check_vmm();
}

// check_vmm - check correctness of vmm
static void
check_vmm(void)
{
    // size_t nr_free_pages_store = nr_free_pages();

    check_vma_struct();
    // check_pgfault();

    cprintf("check_vmm() succeeded.\n");
}

static void
check_vma_struct(void)
{
    // size_t nr_free_pages_store = nr_free_pages();

    struct mm_struct *mm = mm_create();
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i++)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
    {
        assert(le != &(mm->mmap_list));
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
    {
        struct vma_struct *vma1 = find_vma(mm, i);
        assert(vma1 != NULL);
        struct vma_struct *vma2 = find_vma(mm, i + 1);
        assert(vma2 != NULL);
        struct vma_struct *vma3 = find_vma(mm, i + 2);
        assert(vma3 == NULL);
        struct vma_struct *vma4 = find_vma(mm, i + 3);
        assert(vma4 == NULL);
        struct vma_struct *vma5 = find_vma(mm, i + 4);
        assert(vma5 == NULL);

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
    }

    for (i = 4; i >= 0; i--)
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
        if (vma_below_5 != NULL)
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);

    cprintf("check_vma_struct() succeeded!\n");
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
    if (mm != NULL)
    {
        if (!USER_ACCESS(addr, addr + len))
        {
            return 0;
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
        while (start < end)
        {
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
            {
                return 0;
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}