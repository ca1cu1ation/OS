# gdb调试记录

## 一、gdb调试页表翻译

### 启动终端1：QEMU模拟器

输入下列命令：
```
make debug
```

### 启动终端2：附加调试QEMU进程

输入下列命令获取QEMU进程的PID
```
pgrep -f qemu-system-riscv64
```

启动QEMU调试gdb
```
sudo gdb
```

并将PID附加到gdb中
```
(gdb) attach <刚才查到的PID>
(gdb) handle SIGPIPE nostop noprint 
# handle SIGPIPE nostop noprint的作用是：收到 SIGPIPE 信号时，GDB 不会让被调试程序停止（nostop）。收到 SIGPIPE 信号时，GDB 不会输出任何提示信息（noprint）。
(gdb) c
```

### 启动终端3：调试ucore内核

启动调试ucore的gdb
```
make gdb
```

在kern_init处添加断点信息
```
(gdb) b kern_init
Breakpoint 1 at 0xffffffffc020004a: file kern/init/init.c, line 22.
(gdb) c
Continuing.

Breakpoint 1, kern_init () at kern/init/init.c:22
22          memset(edata, 0, end - edata);
```

### 调试细节

1. 执行到断点时，gdb停止
```
(gdb) x/8i $pc #查看后续8条指令
=> 0xffffffffc020004a <kern_init>:      auipc   a0,0xda
   0xffffffffc020004e <kern_init+4>:    addi    a0,a0,1606
   0xffffffffc0200052 <kern_init+8>:    auipc   a2,0xdf
   0xffffffffc0200056 <kern_init+12>:   addi    a2,a2,-1294
   0xffffffffc020005a <kern_init+16>:   addi    sp,sp,-16
   0xffffffffc020005c <kern_init+18>:   sub     a2,a2,a0
   0xffffffffc020005e <kern_init+20>:   li      a1,0
   0xffffffffc0200060 <kern_init+22>:   sd      ra,8(sp)
```

2. 在终端2中在tlb_fill函数处打上断点
```
(gdb) b tlb_fill #tlb_fill 是 QEMU CPU 仿真层在发生 TLB miss 时，用于“填充”TLB 项的内部函数。
Breakpoint 1 at 0x61523c4c03b5: file /mnt/e/操作系统/qemu-4.1.1/accel/tcg/cputlb.c, line 871.
```

3. 在终端3中单步调试到sd ra,8(sp)
```
(gdb) si #使用si单步执行到sd ra,8(sp)
```

4. 到达sd ra,8(sp)指令时终端2执行到tlb_fill发生中断，使用p/x addr查看对应addr
```
Thread 2 "qemu-system-ris" hit Breakpoint 1, tlb_fill (cpu=0x618b65571660, 
    addr=18446744072637947896, size=8, access_type=MMU_DATA_STORE, mmu_idx=1, 
    retaddr=134034193641797) at /mnt/e/操作系统/qemu-4.1.1/accel/tcg/cputlb.c:871
871         CPUClass *cc = CPU_GET_CLASS(cpu);
(gdb) p/x addr
$1 = 0xffffffffc0209ff8
(gdb) p/x riscv_cpu_get_phys_page_debug(cpu, addr) #获取addr对应的物理页基址地址
(gdb) $3 = 0x80209000
(gdb) n
878         ok = cc->tlb_fill(cpu, addr, size, access_type, mmu_idx, false, retaddr);
(gdb) c
```

5. 同时在终端3中查看sp
```
sp             0xffffffffc0209ff0       0xffffffffc0209ff0
```
sp+8的结果正好是addr

## 二、gdb调试系统调用

### 启动终端
启动流程如页表翻译大致相同

需要在ucore的gdb中将 __user_exit.out 这个目标文件的符号信息（如函数名、变量名、源码行号等）加载到 GDB 当前调试会话中。
```
(gdb) add-symbol-file obj/__user_exit.out
add symbol table from file "obj/__user_exit.out"
(y or n) y
Reading symbols from obj/__user_exit.out...
```

### ecall调试细节

1. 在ucore的gdb中syscall函数处打上断点并执行到断点
```
(gdb) b user/libs/syscall.c:18
Breakpoint 1 at 0x8000f8: file user/libs/syscall.c, line 19.
(gdb) c
Continuing.

Breakpoint 1, syscall (num=2) at user/libs/syscall.c:19
19          asm volatile (
```

2. 查看后续8条指令找到ecall，单步执行到ecall
```
(gdb) x/8i $pc
=> 0x8000f8 <syscall+32>:       ld      a0,8(sp)
   0x8000fa <syscall+34>:       ld      a1,40(sp)
   0x8000fc <syscall+36>:       ld      a2,48(sp)
   0x8000fe <syscall+38>:       ld      a3,56(sp)
   0x800100 <syscall+40>:       ld      a4,64(sp)
   0x800102 <syscall+42>:       ld      a5,72(sp)
   0x800104 <syscall+44>:       ecall
   0x800108 <syscall+48>:       sd      a0,28(sp)
```

3. 在riscv_raise_exception和riscv_cpu_do_interrupt处设置断点
```
(gdb) b riscv_raise_exception #设置异常类型，并调用 cpu_loop_exit_restore，让主循环处理异常。                                        
Breakpoint 1 at 0x636aa76e95e9: file /mnt/e/操作系统/qemu-4.1.1/target/riscv/op_helper.c, line 31.
(gdb) b riscv_cpu_do_interrupt #模拟硬件 trap 处理，保存/恢复上下文，设置异常相关寄存器。
Breakpoint 2 at 0x636aa76eb276: file /mnt/e/操作系统/qemu-4.1.1/target/riscv/cpu_helper.c, line 507.
```

4. 继续单步执行到断点
```
Thread 2 "qemu-system-ris" hit Breakpoint 6, riscv_raise_exception (env=0x57917c436070, 
    exception=8, pc=0) at /mnt/e/操作系统/qemu-4.1.1/target/riscv/op_helper.c:31
31          CPUState *cs = env_cpu(env);
(gdb) info args
env = 0x636ac7959070 #当前 CPU 的 RISC-V 状态指针
exception = 8 #异常号 8，代表 RISCV_EXCP_U_ECALL（用户态 ecall）
pc = 0 #异常发生时的指针，暂时未设置
```

5. 通过n单步执行查看
```
(gdb) n
32          qemu_log_mask(CPU_LOG_INT, "%s: %d\n", __func__, exception); #输出日志
(gdb) n
33          cs->exception_index = exception; #设置当前 CPU 的异常类型
(gdb) n
34          cpu_loop_exit_restore(cs, pc); #让 QEMU 主循环退出当前翻译块，进入异常处理
```

6. 进入riscv_cpu_do_interrupt函数断点
```
Thread 2 "qemu-system-ris" hit Breakpoint 5, riscv_cpu_do_interrupt (cs=0x57917c42d660)
    at /mnt/e/操作系统/qemu-4.1.1/target/riscv/cpu_helper.c:507
507         RISCVCPU *cpu = RISCV_CPU(cs);
```

7. 通过n单步执行查看具体流程
```
(gdb) n
508         CPURISCVState *env = &cpu->env;
(gdb) n
513         bool async = !!(cs->exception_index & RISCV_EXCP_INT_FLAG);
(gdb) n
514         target_ulong cause = cs->exception_index & RISCV_EXCP_INT_MASK;
(gdb) n
515         target_ulong deleg = async ? env->mideleg : env->medeleg;
(gdb) n
516         target_ulong tval = 0;
(gdb) n
......
```

### sret调试细节

1. 在sret指令处打上断点
```
b kern/trap/trapentry.S:133
Breakpoint 2 at 0xffffffffc0200fce: file kern/trap/trapentry.S, line 133.
```

2. 执行到sret指令
```
(gdb) c
Continuing.

Breakpoint 2, __trapret () at kern/trap/trapentry.S:133
133         sret
```

3. 在qemu中helper_sret处打上断点
```
(gdb) b helper_sret #模拟 sret 指令行为的辅助函数
Breakpoint 3 at 0x636aa76e9845: file /mnt/e/操作系统/qemu-4.1.1/target/riscv/op_helper.c, line 76.
```

2. 到达断点helper_sret
```
Thread 2 "qemu-system-ris" hit Breakpoint 3, helper_sret (env=0x636ac7959070, 
    cpu_pc_deb=18446744072637910990) at /mnt/e/操作系统/qemu-4.1.1/target/riscv/op_helper.c:76
76          if (!(env->priv >= PRV_S)) {
```

3. 可以通过n单步调试
```
(gdb) n
80          target_ulong retpc = env->sepc;
(gdb) n
81          if (!riscv_has_ext(env, RVC) && (retpc & 0x3)) {
(gdb) n
85          if (env->priv_ver >= PRIV_VERSION_1_10_0 &&
(gdb) n
86              get_field(env->mstatus, MSTATUS_TSR)) {
(gdb) n
85          if (env->priv_ver >= PRIV_VERSION_1_10_0 &&
(gdb) n
90          target_ulong mstatus = env->mstatus;
......
```