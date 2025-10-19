#ifndef __KERN_MM_BUDDY_PMM_H__
#define __KERN_MM_BUDDY_PMM_H__

#include <pmm.h>

/*
 * 伙伴系统物理内存管理器
 *
 * MAX_ORDER 定义了最大阶数（块大小 = 2^order 页）。
 * 该管理器提供标准的 pmm_manager 接口。
 */

#define MAX_ORDER 10   /* 最大阶数：2^10 页 */
#define MIN_ORDER 0    /* 最小阶数：2^0 页 */

extern const struct pmm_manager buddy_pmm_manager;

#endif /* !__KERN_MM_BUDDY_PMM_H__ */


