
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000c297          	auipc	t0,0xc
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020c000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000c297          	auipc	t0,0xc
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020c008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020b2b7          	lui	t0,0xc020b
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c020b137          	lui	sp,0xc020b

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc020004a:	000c2517          	auipc	a0,0xc2
ffffffffc020004e:	62650513          	addi	a0,a0,1574 # ffffffffc02c2670 <buf>
ffffffffc0200052:	000c7617          	auipc	a2,0xc7
ffffffffc0200056:	b0660613          	addi	a2,a2,-1274 # ffffffffc02c6b58 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	039050ef          	jal	ra,ffffffffc020589a <memset>
    cons_init(); // init the console
ffffffffc0200066:	520000ef          	jal	ra,ffffffffc0200586 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006a:	00006597          	auipc	a1,0x6
ffffffffc020006e:	85e58593          	addi	a1,a1,-1954 # ffffffffc02058c8 <etext+0x4>
ffffffffc0200072:	00006517          	auipc	a0,0x6
ffffffffc0200076:	87650513          	addi	a0,a0,-1930 # ffffffffc02058e8 <etext+0x24>
ffffffffc020007a:	11e000ef          	jal	ra,ffffffffc0200198 <cprintf>

    print_kerninfo();
ffffffffc020007e:	1a2000ef          	jal	ra,ffffffffc0200220 <print_kerninfo>

    // grade_backtrace();

    dtb_init(); // init dtb
ffffffffc0200082:	576000ef          	jal	ra,ffffffffc02005f8 <dtb_init>

    pmm_init(); // init physical memory management
ffffffffc0200086:	5f0020ef          	jal	ra,ffffffffc0202676 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	12b000ef          	jal	ra,ffffffffc02009b4 <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	129000ef          	jal	ra,ffffffffc02009b6 <idt_init>

    vmm_init(); // init virtual memory management
ffffffffc0200092:	123030ef          	jal	ra,ffffffffc02039b4 <vmm_init>
    sched_init();
ffffffffc0200096:	09a050ef          	jal	ra,ffffffffc0205130 <sched_init>
    proc_init(); // init process table
ffffffffc020009a:	557040ef          	jal	ra,ffffffffc0204df0 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009e:	4a0000ef          	jal	ra,ffffffffc020053e <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc02000a2:	107000ef          	jal	ra,ffffffffc02009a8 <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a6:	6e3040ef          	jal	ra,ffffffffc0204f88 <cpu_idle>

ffffffffc02000aa <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000aa:	715d                	addi	sp,sp,-80
ffffffffc02000ac:	e486                	sd	ra,72(sp)
ffffffffc02000ae:	e0a6                	sd	s1,64(sp)
ffffffffc02000b0:	fc4a                	sd	s2,56(sp)
ffffffffc02000b2:	f84e                	sd	s3,48(sp)
ffffffffc02000b4:	f452                	sd	s4,40(sp)
ffffffffc02000b6:	f056                	sd	s5,32(sp)
ffffffffc02000b8:	ec5a                	sd	s6,24(sp)
ffffffffc02000ba:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000bc:	c901                	beqz	a0,ffffffffc02000cc <readline+0x22>
ffffffffc02000be:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000c0:	00006517          	auipc	a0,0x6
ffffffffc02000c4:	83050513          	addi	a0,a0,-2000 # ffffffffc02058f0 <etext+0x2c>
ffffffffc02000c8:	0d0000ef          	jal	ra,ffffffffc0200198 <cprintf>
readline(const char *prompt) {
ffffffffc02000cc:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ce:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000d0:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000d2:	4aa9                	li	s5,10
ffffffffc02000d4:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000d6:	000c2b97          	auipc	s7,0xc2
ffffffffc02000da:	59ab8b93          	addi	s7,s7,1434 # ffffffffc02c2670 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000de:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000e2:	12e000ef          	jal	ra,ffffffffc0200210 <getchar>
        if (c < 0) {
ffffffffc02000e6:	00054a63          	bltz	a0,ffffffffc02000fa <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ea:	00a95a63          	bge	s2,a0,ffffffffc02000fe <readline+0x54>
ffffffffc02000ee:	029a5263          	bge	s4,s1,ffffffffc0200112 <readline+0x68>
        c = getchar();
ffffffffc02000f2:	11e000ef          	jal	ra,ffffffffc0200210 <getchar>
        if (c < 0) {
ffffffffc02000f6:	fe055ae3          	bgez	a0,ffffffffc02000ea <readline+0x40>
            return NULL;
ffffffffc02000fa:	4501                	li	a0,0
ffffffffc02000fc:	a091                	j	ffffffffc0200140 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fe:	03351463          	bne	a0,s3,ffffffffc0200126 <readline+0x7c>
ffffffffc0200102:	e8a9                	bnez	s1,ffffffffc0200154 <readline+0xaa>
        c = getchar();
ffffffffc0200104:	10c000ef          	jal	ra,ffffffffc0200210 <getchar>
        if (c < 0) {
ffffffffc0200108:	fe0549e3          	bltz	a0,ffffffffc02000fa <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020010c:	fea959e3          	bge	s2,a0,ffffffffc02000fe <readline+0x54>
ffffffffc0200110:	4481                	li	s1,0
            cputchar(c);
ffffffffc0200112:	e42a                	sd	a0,8(sp)
ffffffffc0200114:	0ba000ef          	jal	ra,ffffffffc02001ce <cputchar>
            buf[i ++] = c;
ffffffffc0200118:	6522                	ld	a0,8(sp)
ffffffffc020011a:	009b87b3          	add	a5,s7,s1
ffffffffc020011e:	2485                	addiw	s1,s1,1
ffffffffc0200120:	00a78023          	sb	a0,0(a5)
ffffffffc0200124:	bf7d                	j	ffffffffc02000e2 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200126:	01550463          	beq	a0,s5,ffffffffc020012e <readline+0x84>
ffffffffc020012a:	fb651ce3          	bne	a0,s6,ffffffffc02000e2 <readline+0x38>
            cputchar(c);
ffffffffc020012e:	0a0000ef          	jal	ra,ffffffffc02001ce <cputchar>
            buf[i] = '\0';
ffffffffc0200132:	000c2517          	auipc	a0,0xc2
ffffffffc0200136:	53e50513          	addi	a0,a0,1342 # ffffffffc02c2670 <buf>
ffffffffc020013a:	94aa                	add	s1,s1,a0
ffffffffc020013c:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0200140:	60a6                	ld	ra,72(sp)
ffffffffc0200142:	6486                	ld	s1,64(sp)
ffffffffc0200144:	7962                	ld	s2,56(sp)
ffffffffc0200146:	79c2                	ld	s3,48(sp)
ffffffffc0200148:	7a22                	ld	s4,40(sp)
ffffffffc020014a:	7a82                	ld	s5,32(sp)
ffffffffc020014c:	6b62                	ld	s6,24(sp)
ffffffffc020014e:	6bc2                	ld	s7,16(sp)
ffffffffc0200150:	6161                	addi	sp,sp,80
ffffffffc0200152:	8082                	ret
            cputchar(c);
ffffffffc0200154:	4521                	li	a0,8
ffffffffc0200156:	078000ef          	jal	ra,ffffffffc02001ce <cputchar>
            i --;
ffffffffc020015a:	34fd                	addiw	s1,s1,-1
ffffffffc020015c:	b759                	j	ffffffffc02000e2 <readline+0x38>

ffffffffc020015e <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015e:	1141                	addi	sp,sp,-16
ffffffffc0200160:	e022                	sd	s0,0(sp)
ffffffffc0200162:	e406                	sd	ra,8(sp)
ffffffffc0200164:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200166:	422000ef          	jal	ra,ffffffffc0200588 <cons_putc>
    (*cnt)++;
ffffffffc020016a:	401c                	lw	a5,0(s0)
}
ffffffffc020016c:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc020016e:	2785                	addiw	a5,a5,1
ffffffffc0200170:	c01c                	sw	a5,0(s0)
}
ffffffffc0200172:	6402                	ld	s0,0(sp)
ffffffffc0200174:	0141                	addi	sp,sp,16
ffffffffc0200176:	8082                	ret

ffffffffc0200178 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200178:	1101                	addi	sp,sp,-32
ffffffffc020017a:	862a                	mv	a2,a0
ffffffffc020017c:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017e:	00000517          	auipc	a0,0x0
ffffffffc0200182:	fe050513          	addi	a0,a0,-32 # ffffffffc020015e <cputch>
ffffffffc0200186:	006c                	addi	a1,sp,12
{
ffffffffc0200188:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020018a:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020018c:	2ea050ef          	jal	ra,ffffffffc0205476 <vprintfmt>
    return cnt;
}
ffffffffc0200190:	60e2                	ld	ra,24(sp)
ffffffffc0200192:	4532                	lw	a0,12(sp)
ffffffffc0200194:	6105                	addi	sp,sp,32
ffffffffc0200196:	8082                	ret

ffffffffc0200198 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200198:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020019a:	02810313          	addi	t1,sp,40 # ffffffffc020b028 <boot_page_table_sv39+0x28>
{
ffffffffc020019e:	8e2a                	mv	t3,a0
ffffffffc02001a0:	f42e                	sd	a1,40(sp)
ffffffffc02001a2:	f832                	sd	a2,48(sp)
ffffffffc02001a4:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a6:	00000517          	auipc	a0,0x0
ffffffffc02001aa:	fb850513          	addi	a0,a0,-72 # ffffffffc020015e <cputch>
ffffffffc02001ae:	004c                	addi	a1,sp,4
ffffffffc02001b0:	869a                	mv	a3,t1
ffffffffc02001b2:	8672                	mv	a2,t3
{
ffffffffc02001b4:	ec06                	sd	ra,24(sp)
ffffffffc02001b6:	e0ba                	sd	a4,64(sp)
ffffffffc02001b8:	e4be                	sd	a5,72(sp)
ffffffffc02001ba:	e8c2                	sd	a6,80(sp)
ffffffffc02001bc:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001be:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001c0:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001c2:	2b4050ef          	jal	ra,ffffffffc0205476 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c6:	60e2                	ld	ra,24(sp)
ffffffffc02001c8:	4512                	lw	a0,4(sp)
ffffffffc02001ca:	6125                	addi	sp,sp,96
ffffffffc02001cc:	8082                	ret

ffffffffc02001ce <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001ce:	ae6d                	j	ffffffffc0200588 <cons_putc>

ffffffffc02001d0 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001d0:	1101                	addi	sp,sp,-32
ffffffffc02001d2:	e822                	sd	s0,16(sp)
ffffffffc02001d4:	ec06                	sd	ra,24(sp)
ffffffffc02001d6:	e426                	sd	s1,8(sp)
ffffffffc02001d8:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001da:	00054503          	lbu	a0,0(a0)
ffffffffc02001de:	c51d                	beqz	a0,ffffffffc020020c <cputs+0x3c>
ffffffffc02001e0:	0405                	addi	s0,s0,1
ffffffffc02001e2:	4485                	li	s1,1
ffffffffc02001e4:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001e6:	3a2000ef          	jal	ra,ffffffffc0200588 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001ea:	00044503          	lbu	a0,0(s0)
ffffffffc02001ee:	008487bb          	addw	a5,s1,s0
ffffffffc02001f2:	0405                	addi	s0,s0,1
ffffffffc02001f4:	f96d                	bnez	a0,ffffffffc02001e6 <cputs+0x16>
    (*cnt)++;
ffffffffc02001f6:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001fa:	4529                	li	a0,10
ffffffffc02001fc:	38c000ef          	jal	ra,ffffffffc0200588 <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc0200200:	60e2                	ld	ra,24(sp)
ffffffffc0200202:	8522                	mv	a0,s0
ffffffffc0200204:	6442                	ld	s0,16(sp)
ffffffffc0200206:	64a2                	ld	s1,8(sp)
ffffffffc0200208:	6105                	addi	sp,sp,32
ffffffffc020020a:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc020020c:	4405                	li	s0,1
ffffffffc020020e:	b7f5                	j	ffffffffc02001fa <cputs+0x2a>

ffffffffc0200210 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc0200210:	1141                	addi	sp,sp,-16
ffffffffc0200212:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200214:	3a8000ef          	jal	ra,ffffffffc02005bc <cons_getc>
ffffffffc0200218:	dd75                	beqz	a0,ffffffffc0200214 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc020021a:	60a2                	ld	ra,8(sp)
ffffffffc020021c:	0141                	addi	sp,sp,16
ffffffffc020021e:	8082                	ret

ffffffffc0200220 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200220:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200222:	00005517          	auipc	a0,0x5
ffffffffc0200226:	6d650513          	addi	a0,a0,1750 # ffffffffc02058f8 <etext+0x34>
void print_kerninfo(void) {
ffffffffc020022a:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc020022c:	f6dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200230:	00000597          	auipc	a1,0x0
ffffffffc0200234:	e1a58593          	addi	a1,a1,-486 # ffffffffc020004a <kern_init>
ffffffffc0200238:	00005517          	auipc	a0,0x5
ffffffffc020023c:	6e050513          	addi	a0,a0,1760 # ffffffffc0205918 <etext+0x54>
ffffffffc0200240:	f59ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200244:	00005597          	auipc	a1,0x5
ffffffffc0200248:	68058593          	addi	a1,a1,1664 # ffffffffc02058c4 <etext>
ffffffffc020024c:	00005517          	auipc	a0,0x5
ffffffffc0200250:	6ec50513          	addi	a0,a0,1772 # ffffffffc0205938 <etext+0x74>
ffffffffc0200254:	f45ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200258:	000c2597          	auipc	a1,0xc2
ffffffffc020025c:	41858593          	addi	a1,a1,1048 # ffffffffc02c2670 <buf>
ffffffffc0200260:	00005517          	auipc	a0,0x5
ffffffffc0200264:	6f850513          	addi	a0,a0,1784 # ffffffffc0205958 <etext+0x94>
ffffffffc0200268:	f31ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc020026c:	000c7597          	auipc	a1,0xc7
ffffffffc0200270:	8ec58593          	addi	a1,a1,-1812 # ffffffffc02c6b58 <end>
ffffffffc0200274:	00005517          	auipc	a0,0x5
ffffffffc0200278:	70450513          	addi	a0,a0,1796 # ffffffffc0205978 <etext+0xb4>
ffffffffc020027c:	f1dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200280:	000c7597          	auipc	a1,0xc7
ffffffffc0200284:	cd758593          	addi	a1,a1,-809 # ffffffffc02c6f57 <end+0x3ff>
ffffffffc0200288:	00000797          	auipc	a5,0x0
ffffffffc020028c:	dc278793          	addi	a5,a5,-574 # ffffffffc020004a <kern_init>
ffffffffc0200290:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200294:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200298:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020029a:	3ff5f593          	andi	a1,a1,1023
ffffffffc020029e:	95be                	add	a1,a1,a5
ffffffffc02002a0:	85a9                	srai	a1,a1,0xa
ffffffffc02002a2:	00005517          	auipc	a0,0x5
ffffffffc02002a6:	6f650513          	addi	a0,a0,1782 # ffffffffc0205998 <etext+0xd4>
}
ffffffffc02002aa:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002ac:	b5f5                	j	ffffffffc0200198 <cprintf>

ffffffffc02002ae <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02002ae:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002b0:	00005617          	auipc	a2,0x5
ffffffffc02002b4:	71860613          	addi	a2,a2,1816 # ffffffffc02059c8 <etext+0x104>
ffffffffc02002b8:	04d00593          	li	a1,77
ffffffffc02002bc:	00005517          	auipc	a0,0x5
ffffffffc02002c0:	72450513          	addi	a0,a0,1828 # ffffffffc02059e0 <etext+0x11c>
void print_stackframe(void) {
ffffffffc02002c4:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002c6:	1cc000ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02002ca <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002ca:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002cc:	00005617          	auipc	a2,0x5
ffffffffc02002d0:	72c60613          	addi	a2,a2,1836 # ffffffffc02059f8 <etext+0x134>
ffffffffc02002d4:	00005597          	auipc	a1,0x5
ffffffffc02002d8:	74458593          	addi	a1,a1,1860 # ffffffffc0205a18 <etext+0x154>
ffffffffc02002dc:	00005517          	auipc	a0,0x5
ffffffffc02002e0:	74450513          	addi	a0,a0,1860 # ffffffffc0205a20 <etext+0x15c>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002e4:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e6:	eb3ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc02002ea:	00005617          	auipc	a2,0x5
ffffffffc02002ee:	74660613          	addi	a2,a2,1862 # ffffffffc0205a30 <etext+0x16c>
ffffffffc02002f2:	00005597          	auipc	a1,0x5
ffffffffc02002f6:	76658593          	addi	a1,a1,1894 # ffffffffc0205a58 <etext+0x194>
ffffffffc02002fa:	00005517          	auipc	a0,0x5
ffffffffc02002fe:	72650513          	addi	a0,a0,1830 # ffffffffc0205a20 <etext+0x15c>
ffffffffc0200302:	e97ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc0200306:	00005617          	auipc	a2,0x5
ffffffffc020030a:	76260613          	addi	a2,a2,1890 # ffffffffc0205a68 <etext+0x1a4>
ffffffffc020030e:	00005597          	auipc	a1,0x5
ffffffffc0200312:	77a58593          	addi	a1,a1,1914 # ffffffffc0205a88 <etext+0x1c4>
ffffffffc0200316:	00005517          	auipc	a0,0x5
ffffffffc020031a:	70a50513          	addi	a0,a0,1802 # ffffffffc0205a20 <etext+0x15c>
ffffffffc020031e:	e7bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    }
    return 0;
}
ffffffffc0200322:	60a2                	ld	ra,8(sp)
ffffffffc0200324:	4501                	li	a0,0
ffffffffc0200326:	0141                	addi	sp,sp,16
ffffffffc0200328:	8082                	ret

ffffffffc020032a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc020032a:	1141                	addi	sp,sp,-16
ffffffffc020032c:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020032e:	ef3ff0ef          	jal	ra,ffffffffc0200220 <print_kerninfo>
    return 0;
}
ffffffffc0200332:	60a2                	ld	ra,8(sp)
ffffffffc0200334:	4501                	li	a0,0
ffffffffc0200336:	0141                	addi	sp,sp,16
ffffffffc0200338:	8082                	ret

ffffffffc020033a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc020033a:	1141                	addi	sp,sp,-16
ffffffffc020033c:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020033e:	f71ff0ef          	jal	ra,ffffffffc02002ae <print_stackframe>
    return 0;
}
ffffffffc0200342:	60a2                	ld	ra,8(sp)
ffffffffc0200344:	4501                	li	a0,0
ffffffffc0200346:	0141                	addi	sp,sp,16
ffffffffc0200348:	8082                	ret

ffffffffc020034a <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc020034a:	7115                	addi	sp,sp,-224
ffffffffc020034c:	ed5e                	sd	s7,152(sp)
ffffffffc020034e:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200350:	00005517          	auipc	a0,0x5
ffffffffc0200354:	74850513          	addi	a0,a0,1864 # ffffffffc0205a98 <etext+0x1d4>
kmonitor(struct trapframe *tf) {
ffffffffc0200358:	ed86                	sd	ra,216(sp)
ffffffffc020035a:	e9a2                	sd	s0,208(sp)
ffffffffc020035c:	e5a6                	sd	s1,200(sp)
ffffffffc020035e:	e1ca                	sd	s2,192(sp)
ffffffffc0200360:	fd4e                	sd	s3,184(sp)
ffffffffc0200362:	f952                	sd	s4,176(sp)
ffffffffc0200364:	f556                	sd	s5,168(sp)
ffffffffc0200366:	f15a                	sd	s6,160(sp)
ffffffffc0200368:	e962                	sd	s8,144(sp)
ffffffffc020036a:	e566                	sd	s9,136(sp)
ffffffffc020036c:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036e:	e2bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200372:	00005517          	auipc	a0,0x5
ffffffffc0200376:	74e50513          	addi	a0,a0,1870 # ffffffffc0205ac0 <etext+0x1fc>
ffffffffc020037a:	e1fff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    if (tf != NULL) {
ffffffffc020037e:	000b8563          	beqz	s7,ffffffffc0200388 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc0200382:	855e                	mv	a0,s7
ffffffffc0200384:	01b000ef          	jal	ra,ffffffffc0200b9e <print_trapframe>
ffffffffc0200388:	00005c17          	auipc	s8,0x5
ffffffffc020038c:	7a8c0c13          	addi	s8,s8,1960 # ffffffffc0205b30 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200390:	00005917          	auipc	s2,0x5
ffffffffc0200394:	75890913          	addi	s2,s2,1880 # ffffffffc0205ae8 <etext+0x224>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200398:	00005497          	auipc	s1,0x5
ffffffffc020039c:	75848493          	addi	s1,s1,1880 # ffffffffc0205af0 <etext+0x22c>
        if (argc == MAXARGS - 1) {
ffffffffc02003a0:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003a2:	00005b17          	auipc	s6,0x5
ffffffffc02003a6:	756b0b13          	addi	s6,s6,1878 # ffffffffc0205af8 <etext+0x234>
        argv[argc ++] = buf;
ffffffffc02003aa:	00005a17          	auipc	s4,0x5
ffffffffc02003ae:	66ea0a13          	addi	s4,s4,1646 # ffffffffc0205a18 <etext+0x154>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003b2:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02003b4:	854a                	mv	a0,s2
ffffffffc02003b6:	cf5ff0ef          	jal	ra,ffffffffc02000aa <readline>
ffffffffc02003ba:	842a                	mv	s0,a0
ffffffffc02003bc:	dd65                	beqz	a0,ffffffffc02003b4 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003be:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003c2:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003c4:	e1bd                	bnez	a1,ffffffffc020042a <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc02003c6:	fe0c87e3          	beqz	s9,ffffffffc02003b4 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003ca:	6582                	ld	a1,0(sp)
ffffffffc02003cc:	00005d17          	auipc	s10,0x5
ffffffffc02003d0:	764d0d13          	addi	s10,s10,1892 # ffffffffc0205b30 <commands>
        argv[argc ++] = buf;
ffffffffc02003d4:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003d6:	4401                	li	s0,0
ffffffffc02003d8:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003da:	466050ef          	jal	ra,ffffffffc0205840 <strcmp>
ffffffffc02003de:	c919                	beqz	a0,ffffffffc02003f4 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003e0:	2405                	addiw	s0,s0,1
ffffffffc02003e2:	0b540063          	beq	s0,s5,ffffffffc0200482 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003e6:	000d3503          	ld	a0,0(s10)
ffffffffc02003ea:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003ec:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003ee:	452050ef          	jal	ra,ffffffffc0205840 <strcmp>
ffffffffc02003f2:	f57d                	bnez	a0,ffffffffc02003e0 <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003f4:	00141793          	slli	a5,s0,0x1
ffffffffc02003f8:	97a2                	add	a5,a5,s0
ffffffffc02003fa:	078e                	slli	a5,a5,0x3
ffffffffc02003fc:	97e2                	add	a5,a5,s8
ffffffffc02003fe:	6b9c                	ld	a5,16(a5)
ffffffffc0200400:	865e                	mv	a2,s7
ffffffffc0200402:	002c                	addi	a1,sp,8
ffffffffc0200404:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200408:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc020040a:	fa0555e3          	bgez	a0,ffffffffc02003b4 <kmonitor+0x6a>
}
ffffffffc020040e:	60ee                	ld	ra,216(sp)
ffffffffc0200410:	644e                	ld	s0,208(sp)
ffffffffc0200412:	64ae                	ld	s1,200(sp)
ffffffffc0200414:	690e                	ld	s2,192(sp)
ffffffffc0200416:	79ea                	ld	s3,184(sp)
ffffffffc0200418:	7a4a                	ld	s4,176(sp)
ffffffffc020041a:	7aaa                	ld	s5,168(sp)
ffffffffc020041c:	7b0a                	ld	s6,160(sp)
ffffffffc020041e:	6bea                	ld	s7,152(sp)
ffffffffc0200420:	6c4a                	ld	s8,144(sp)
ffffffffc0200422:	6caa                	ld	s9,136(sp)
ffffffffc0200424:	6d0a                	ld	s10,128(sp)
ffffffffc0200426:	612d                	addi	sp,sp,224
ffffffffc0200428:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020042a:	8526                	mv	a0,s1
ffffffffc020042c:	458050ef          	jal	ra,ffffffffc0205884 <strchr>
ffffffffc0200430:	c901                	beqz	a0,ffffffffc0200440 <kmonitor+0xf6>
ffffffffc0200432:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200436:	00040023          	sb	zero,0(s0)
ffffffffc020043a:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020043c:	d5c9                	beqz	a1,ffffffffc02003c6 <kmonitor+0x7c>
ffffffffc020043e:	b7f5                	j	ffffffffc020042a <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc0200440:	00044783          	lbu	a5,0(s0)
ffffffffc0200444:	d3c9                	beqz	a5,ffffffffc02003c6 <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc0200446:	033c8963          	beq	s9,s3,ffffffffc0200478 <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc020044a:	003c9793          	slli	a5,s9,0x3
ffffffffc020044e:	0118                	addi	a4,sp,128
ffffffffc0200450:	97ba                	add	a5,a5,a4
ffffffffc0200452:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200456:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020045a:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020045c:	e591                	bnez	a1,ffffffffc0200468 <kmonitor+0x11e>
ffffffffc020045e:	b7b5                	j	ffffffffc02003ca <kmonitor+0x80>
ffffffffc0200460:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200464:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200466:	d1a5                	beqz	a1,ffffffffc02003c6 <kmonitor+0x7c>
ffffffffc0200468:	8526                	mv	a0,s1
ffffffffc020046a:	41a050ef          	jal	ra,ffffffffc0205884 <strchr>
ffffffffc020046e:	d96d                	beqz	a0,ffffffffc0200460 <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200470:	00044583          	lbu	a1,0(s0)
ffffffffc0200474:	d9a9                	beqz	a1,ffffffffc02003c6 <kmonitor+0x7c>
ffffffffc0200476:	bf55                	j	ffffffffc020042a <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200478:	45c1                	li	a1,16
ffffffffc020047a:	855a                	mv	a0,s6
ffffffffc020047c:	d1dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc0200480:	b7e9                	j	ffffffffc020044a <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200482:	6582                	ld	a1,0(sp)
ffffffffc0200484:	00005517          	auipc	a0,0x5
ffffffffc0200488:	69450513          	addi	a0,a0,1684 # ffffffffc0205b18 <etext+0x254>
ffffffffc020048c:	d0dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    return 0;
ffffffffc0200490:	b715                	j	ffffffffc02003b4 <kmonitor+0x6a>

ffffffffc0200492 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200492:	000c6317          	auipc	t1,0xc6
ffffffffc0200496:	63630313          	addi	t1,t1,1590 # ffffffffc02c6ac8 <is_panic>
ffffffffc020049a:	00033e03          	ld	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc020049e:	715d                	addi	sp,sp,-80
ffffffffc02004a0:	ec06                	sd	ra,24(sp)
ffffffffc02004a2:	e822                	sd	s0,16(sp)
ffffffffc02004a4:	f436                	sd	a3,40(sp)
ffffffffc02004a6:	f83a                	sd	a4,48(sp)
ffffffffc02004a8:	fc3e                	sd	a5,56(sp)
ffffffffc02004aa:	e0c2                	sd	a6,64(sp)
ffffffffc02004ac:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02004ae:	020e1a63          	bnez	t3,ffffffffc02004e2 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02004b2:	4785                	li	a5,1
ffffffffc02004b4:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b8:	8432                	mv	s0,a2
ffffffffc02004ba:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004bc:	862e                	mv	a2,a1
ffffffffc02004be:	85aa                	mv	a1,a0
ffffffffc02004c0:	00005517          	auipc	a0,0x5
ffffffffc02004c4:	6b850513          	addi	a0,a0,1720 # ffffffffc0205b78 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c8:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004ca:	ccfff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ce:	65a2                	ld	a1,8(sp)
ffffffffc02004d0:	8522                	mv	a0,s0
ffffffffc02004d2:	ca7ff0ef          	jal	ra,ffffffffc0200178 <vcprintf>
    cprintf("\n");
ffffffffc02004d6:	00006517          	auipc	a0,0x6
ffffffffc02004da:	7aa50513          	addi	a0,a0,1962 # ffffffffc0206c80 <default_pmm_manager+0x578>
ffffffffc02004de:	cbbff0ef          	jal	ra,ffffffffc0200198 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004e2:	4501                	li	a0,0
ffffffffc02004e4:	4581                	li	a1,0
ffffffffc02004e6:	4601                	li	a2,0
ffffffffc02004e8:	48a1                	li	a7,8
ffffffffc02004ea:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004ee:	4c0000ef          	jal	ra,ffffffffc02009ae <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02004f2:	4501                	li	a0,0
ffffffffc02004f4:	e57ff0ef          	jal	ra,ffffffffc020034a <kmonitor>
    while (1) {
ffffffffc02004f8:	bfed                	j	ffffffffc02004f2 <__panic+0x60>

ffffffffc02004fa <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004fa:	715d                	addi	sp,sp,-80
ffffffffc02004fc:	832e                	mv	t1,a1
ffffffffc02004fe:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200500:	85aa                	mv	a1,a0
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc0200502:	8432                	mv	s0,a2
ffffffffc0200504:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200506:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200508:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020050a:	00005517          	auipc	a0,0x5
ffffffffc020050e:	68e50513          	addi	a0,a0,1678 # ffffffffc0205b98 <commands+0x68>
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc0200512:	ec06                	sd	ra,24(sp)
ffffffffc0200514:	f436                	sd	a3,40(sp)
ffffffffc0200516:	f83a                	sd	a4,48(sp)
ffffffffc0200518:	e0c2                	sd	a6,64(sp)
ffffffffc020051a:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020051c:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020051e:	c7bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200522:	65a2                	ld	a1,8(sp)
ffffffffc0200524:	8522                	mv	a0,s0
ffffffffc0200526:	c53ff0ef          	jal	ra,ffffffffc0200178 <vcprintf>
    cprintf("\n");
ffffffffc020052a:	00006517          	auipc	a0,0x6
ffffffffc020052e:	75650513          	addi	a0,a0,1878 # ffffffffc0206c80 <default_pmm_manager+0x578>
ffffffffc0200532:	c67ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    va_end(ap);
}
ffffffffc0200536:	60e2                	ld	ra,24(sp)
ffffffffc0200538:	6442                	ld	s0,16(sp)
ffffffffc020053a:	6161                	addi	sp,sp,80
ffffffffc020053c:	8082                	ret

ffffffffc020053e <clock_init>:
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void)
{
    set_csr(sie, MIP_STIP);
ffffffffc020053e:	02000793          	li	a5,32
ffffffffc0200542:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200546:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020054a:	67e1                	lui	a5,0x18
ffffffffc020054c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xbf98>
ffffffffc0200550:	953e                	add	a0,a0,a5
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200552:	4581                	li	a1,0
ffffffffc0200554:	4601                	li	a2,0
ffffffffc0200556:	4881                	li	a7,0
ffffffffc0200558:	00000073          	ecall
    cprintf("++ setup timer interrupts\n");
ffffffffc020055c:	00005517          	auipc	a0,0x5
ffffffffc0200560:	65c50513          	addi	a0,a0,1628 # ffffffffc0205bb8 <commands+0x88>
    ticks = 0;
ffffffffc0200564:	000c6797          	auipc	a5,0xc6
ffffffffc0200568:	5607b623          	sd	zero,1388(a5) # ffffffffc02c6ad0 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020056c:	b135                	j	ffffffffc0200198 <cprintf>

ffffffffc020056e <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020056e:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200572:	67e1                	lui	a5,0x18
ffffffffc0200574:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xbf98>
ffffffffc0200578:	953e                	add	a0,a0,a5
ffffffffc020057a:	4581                	li	a1,0
ffffffffc020057c:	4601                	li	a2,0
ffffffffc020057e:	4881                	li	a7,0
ffffffffc0200580:	00000073          	ecall
ffffffffc0200584:	8082                	ret

ffffffffc0200586 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200586:	8082                	ret

ffffffffc0200588 <cons_putc>:
#include <assert.h>
#include <atomic.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200588:	100027f3          	csrr	a5,sstatus
ffffffffc020058c:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc020058e:	0ff57513          	zext.b	a0,a0
ffffffffc0200592:	e799                	bnez	a5,ffffffffc02005a0 <cons_putc+0x18>
ffffffffc0200594:	4581                	li	a1,0
ffffffffc0200596:	4601                	li	a2,0
ffffffffc0200598:	4885                	li	a7,1
ffffffffc020059a:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc020059e:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02005a0:	1101                	addi	sp,sp,-32
ffffffffc02005a2:	ec06                	sd	ra,24(sp)
ffffffffc02005a4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02005a6:	408000ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc02005aa:	6522                	ld	a0,8(sp)
ffffffffc02005ac:	4581                	li	a1,0
ffffffffc02005ae:	4601                	li	a2,0
ffffffffc02005b0:	4885                	li	a7,1
ffffffffc02005b2:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02005b6:	60e2                	ld	ra,24(sp)
ffffffffc02005b8:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc02005ba:	a6fd                	j	ffffffffc02009a8 <intr_enable>

ffffffffc02005bc <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02005bc:	100027f3          	csrr	a5,sstatus
ffffffffc02005c0:	8b89                	andi	a5,a5,2
ffffffffc02005c2:	eb89                	bnez	a5,ffffffffc02005d4 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005c4:	4501                	li	a0,0
ffffffffc02005c6:	4581                	li	a1,0
ffffffffc02005c8:	4601                	li	a2,0
ffffffffc02005ca:	4889                	li	a7,2
ffffffffc02005cc:	00000073          	ecall
ffffffffc02005d0:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005d2:	8082                	ret
int cons_getc(void) {
ffffffffc02005d4:	1101                	addi	sp,sp,-32
ffffffffc02005d6:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005d8:	3d6000ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc02005dc:	4501                	li	a0,0
ffffffffc02005de:	4581                	li	a1,0
ffffffffc02005e0:	4601                	li	a2,0
ffffffffc02005e2:	4889                	li	a7,2
ffffffffc02005e4:	00000073          	ecall
ffffffffc02005e8:	2501                	sext.w	a0,a0
ffffffffc02005ea:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005ec:	3bc000ef          	jal	ra,ffffffffc02009a8 <intr_enable>
}
ffffffffc02005f0:	60e2                	ld	ra,24(sp)
ffffffffc02005f2:	6522                	ld	a0,8(sp)
ffffffffc02005f4:	6105                	addi	sp,sp,32
ffffffffc02005f6:	8082                	ret

ffffffffc02005f8 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005f8:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc02005fa:	00005517          	auipc	a0,0x5
ffffffffc02005fe:	5de50513          	addi	a0,a0,1502 # ffffffffc0205bd8 <commands+0xa8>
void dtb_init(void) {
ffffffffc0200602:	fc86                	sd	ra,120(sp)
ffffffffc0200604:	f8a2                	sd	s0,112(sp)
ffffffffc0200606:	e8d2                	sd	s4,80(sp)
ffffffffc0200608:	f4a6                	sd	s1,104(sp)
ffffffffc020060a:	f0ca                	sd	s2,96(sp)
ffffffffc020060c:	ecce                	sd	s3,88(sp)
ffffffffc020060e:	e4d6                	sd	s5,72(sp)
ffffffffc0200610:	e0da                	sd	s6,64(sp)
ffffffffc0200612:	fc5e                	sd	s7,56(sp)
ffffffffc0200614:	f862                	sd	s8,48(sp)
ffffffffc0200616:	f466                	sd	s9,40(sp)
ffffffffc0200618:	f06a                	sd	s10,32(sp)
ffffffffc020061a:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc020061c:	b7dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200620:	0000c597          	auipc	a1,0xc
ffffffffc0200624:	9e05b583          	ld	a1,-1568(a1) # ffffffffc020c000 <boot_hartid>
ffffffffc0200628:	00005517          	auipc	a0,0x5
ffffffffc020062c:	5c050513          	addi	a0,a0,1472 # ffffffffc0205be8 <commands+0xb8>
ffffffffc0200630:	b69ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200634:	0000c417          	auipc	s0,0xc
ffffffffc0200638:	9d440413          	addi	s0,s0,-1580 # ffffffffc020c008 <boot_dtb>
ffffffffc020063c:	600c                	ld	a1,0(s0)
ffffffffc020063e:	00005517          	auipc	a0,0x5
ffffffffc0200642:	5ba50513          	addi	a0,a0,1466 # ffffffffc0205bf8 <commands+0xc8>
ffffffffc0200646:	b53ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc020064a:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc020064e:	00005517          	auipc	a0,0x5
ffffffffc0200652:	5c250513          	addi	a0,a0,1474 # ffffffffc0205c10 <commands+0xe0>
    if (boot_dtb == 0) {
ffffffffc0200656:	120a0463          	beqz	s4,ffffffffc020077e <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc020065a:	57f5                	li	a5,-3
ffffffffc020065c:	07fa                	slli	a5,a5,0x1e
ffffffffc020065e:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200662:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200664:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200668:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066a:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020066e:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200672:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200676:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067a:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067e:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200680:	8ec9                	or	a3,a3,a0
ffffffffc0200682:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200686:	1b7d                	addi	s6,s6,-1
ffffffffc0200688:	0167f7b3          	and	a5,a5,s6
ffffffffc020068c:	8dd5                	or	a1,a1,a3
ffffffffc020068e:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200690:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200694:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc0200696:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe19395>
ffffffffc020069a:	10f59163          	bne	a1,a5,ffffffffc020079c <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc020069e:	471c                	lw	a5,8(a4)
ffffffffc02006a0:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02006a2:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a4:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006a8:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02006ac:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b0:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b4:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b8:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006bc:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c0:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c4:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c8:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006cc:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ce:	01146433          	or	s0,s0,a7
ffffffffc02006d2:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006d6:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006da:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006dc:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006e0:	8c49                	or	s0,s0,a0
ffffffffc02006e2:	0166f6b3          	and	a3,a3,s6
ffffffffc02006e6:	00ca6a33          	or	s4,s4,a2
ffffffffc02006ea:	0167f7b3          	and	a5,a5,s6
ffffffffc02006ee:	8c55                	or	s0,s0,a3
ffffffffc02006f0:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006f4:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006f6:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006f8:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006fa:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fe:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200700:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200702:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc0200706:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200708:	00005917          	auipc	s2,0x5
ffffffffc020070c:	55890913          	addi	s2,s2,1368 # ffffffffc0205c60 <commands+0x130>
ffffffffc0200710:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200712:	4d91                	li	s11,4
ffffffffc0200714:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200716:	00005497          	auipc	s1,0x5
ffffffffc020071a:	54248493          	addi	s1,s1,1346 # ffffffffc0205c58 <commands+0x128>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020071e:	000a2703          	lw	a4,0(s4)
ffffffffc0200722:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200726:	0087569b          	srliw	a3,a4,0x8
ffffffffc020072a:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020072e:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200732:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200736:	0107571b          	srliw	a4,a4,0x10
ffffffffc020073a:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020073c:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200740:	0087171b          	slliw	a4,a4,0x8
ffffffffc0200744:	8fd5                	or	a5,a5,a3
ffffffffc0200746:	00eb7733          	and	a4,s6,a4
ffffffffc020074a:	8fd9                	or	a5,a5,a4
ffffffffc020074c:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc020074e:	09778c63          	beq	a5,s7,ffffffffc02007e6 <dtb_init+0x1ee>
ffffffffc0200752:	00fbea63          	bltu	s7,a5,ffffffffc0200766 <dtb_init+0x16e>
ffffffffc0200756:	07a78663          	beq	a5,s10,ffffffffc02007c2 <dtb_init+0x1ca>
ffffffffc020075a:	4709                	li	a4,2
ffffffffc020075c:	00e79763          	bne	a5,a4,ffffffffc020076a <dtb_init+0x172>
ffffffffc0200760:	4c81                	li	s9,0
ffffffffc0200762:	8a56                	mv	s4,s5
ffffffffc0200764:	bf6d                	j	ffffffffc020071e <dtb_init+0x126>
ffffffffc0200766:	ffb78ee3          	beq	a5,s11,ffffffffc0200762 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc020076a:	00005517          	auipc	a0,0x5
ffffffffc020076e:	56e50513          	addi	a0,a0,1390 # ffffffffc0205cd8 <commands+0x1a8>
ffffffffc0200772:	a27ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200776:	00005517          	auipc	a0,0x5
ffffffffc020077a:	59a50513          	addi	a0,a0,1434 # ffffffffc0205d10 <commands+0x1e0>
}
ffffffffc020077e:	7446                	ld	s0,112(sp)
ffffffffc0200780:	70e6                	ld	ra,120(sp)
ffffffffc0200782:	74a6                	ld	s1,104(sp)
ffffffffc0200784:	7906                	ld	s2,96(sp)
ffffffffc0200786:	69e6                	ld	s3,88(sp)
ffffffffc0200788:	6a46                	ld	s4,80(sp)
ffffffffc020078a:	6aa6                	ld	s5,72(sp)
ffffffffc020078c:	6b06                	ld	s6,64(sp)
ffffffffc020078e:	7be2                	ld	s7,56(sp)
ffffffffc0200790:	7c42                	ld	s8,48(sp)
ffffffffc0200792:	7ca2                	ld	s9,40(sp)
ffffffffc0200794:	7d02                	ld	s10,32(sp)
ffffffffc0200796:	6de2                	ld	s11,24(sp)
ffffffffc0200798:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc020079a:	bafd                	j	ffffffffc0200198 <cprintf>
}
ffffffffc020079c:	7446                	ld	s0,112(sp)
ffffffffc020079e:	70e6                	ld	ra,120(sp)
ffffffffc02007a0:	74a6                	ld	s1,104(sp)
ffffffffc02007a2:	7906                	ld	s2,96(sp)
ffffffffc02007a4:	69e6                	ld	s3,88(sp)
ffffffffc02007a6:	6a46                	ld	s4,80(sp)
ffffffffc02007a8:	6aa6                	ld	s5,72(sp)
ffffffffc02007aa:	6b06                	ld	s6,64(sp)
ffffffffc02007ac:	7be2                	ld	s7,56(sp)
ffffffffc02007ae:	7c42                	ld	s8,48(sp)
ffffffffc02007b0:	7ca2                	ld	s9,40(sp)
ffffffffc02007b2:	7d02                	ld	s10,32(sp)
ffffffffc02007b4:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007b6:	00005517          	auipc	a0,0x5
ffffffffc02007ba:	47a50513          	addi	a0,a0,1146 # ffffffffc0205c30 <commands+0x100>
}
ffffffffc02007be:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c0:	bae1                	j	ffffffffc0200198 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c2:	8556                	mv	a0,s5
ffffffffc02007c4:	034050ef          	jal	ra,ffffffffc02057f8 <strlen>
ffffffffc02007c8:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007ca:	4619                	li	a2,6
ffffffffc02007cc:	85a6                	mv	a1,s1
ffffffffc02007ce:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d0:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d2:	08c050ef          	jal	ra,ffffffffc020585e <strncmp>
ffffffffc02007d6:	e111                	bnez	a0,ffffffffc02007da <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc02007d8:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007da:	0a91                	addi	s5,s5,4
ffffffffc02007dc:	9ad2                	add	s5,s5,s4
ffffffffc02007de:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007e2:	8a56                	mv	s4,s5
ffffffffc02007e4:	bf2d                	j	ffffffffc020071e <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007e6:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007ea:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ee:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02007f2:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007f6:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007fa:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007fe:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200802:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200806:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020080a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020080e:	00eaeab3          	or	s5,s5,a4
ffffffffc0200812:	00fb77b3          	and	a5,s6,a5
ffffffffc0200816:	00faeab3          	or	s5,s5,a5
ffffffffc020081a:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020081c:	000c9c63          	bnez	s9,ffffffffc0200834 <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200820:	1a82                	slli	s5,s5,0x20
ffffffffc0200822:	00368793          	addi	a5,a3,3
ffffffffc0200826:	020ada93          	srli	s5,s5,0x20
ffffffffc020082a:	9abe                	add	s5,s5,a5
ffffffffc020082c:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200830:	8a56                	mv	s4,s5
ffffffffc0200832:	b5f5                	j	ffffffffc020071e <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200834:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200838:	85ca                	mv	a1,s2
ffffffffc020083a:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020083c:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200840:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200844:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200848:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020084c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200850:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200852:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200856:	0087979b          	slliw	a5,a5,0x8
ffffffffc020085a:	8d59                	or	a0,a0,a4
ffffffffc020085c:	00fb77b3          	and	a5,s6,a5
ffffffffc0200860:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200862:	1502                	slli	a0,a0,0x20
ffffffffc0200864:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200866:	9522                	add	a0,a0,s0
ffffffffc0200868:	7d9040ef          	jal	ra,ffffffffc0205840 <strcmp>
ffffffffc020086c:	66a2                	ld	a3,8(sp)
ffffffffc020086e:	f94d                	bnez	a0,ffffffffc0200820 <dtb_init+0x228>
ffffffffc0200870:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200820 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200874:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200878:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020087c:	00005517          	auipc	a0,0x5
ffffffffc0200880:	3ec50513          	addi	a0,a0,1004 # ffffffffc0205c68 <commands+0x138>
           fdt32_to_cpu(x >> 32);
ffffffffc0200884:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200888:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc020088c:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200890:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200894:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200898:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020089c:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008a0:	0187d693          	srli	a3,a5,0x18
ffffffffc02008a4:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02008a8:	0087579b          	srliw	a5,a4,0x8
ffffffffc02008ac:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b0:	0106561b          	srliw	a2,a2,0x10
ffffffffc02008b4:	010f6f33          	or	t5,t5,a6
ffffffffc02008b8:	0187529b          	srliw	t0,a4,0x18
ffffffffc02008bc:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c0:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008c4:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c8:	0186f6b3          	and	a3,a3,s8
ffffffffc02008cc:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02008d0:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008d4:	0107581b          	srliw	a6,a4,0x10
ffffffffc02008d8:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008dc:	8361                	srli	a4,a4,0x18
ffffffffc02008de:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008e2:	0105d59b          	srliw	a1,a1,0x10
ffffffffc02008e6:	01e6e6b3          	or	a3,a3,t5
ffffffffc02008ea:	00cb7633          	and	a2,s6,a2
ffffffffc02008ee:	0088181b          	slliw	a6,a6,0x8
ffffffffc02008f2:	0085959b          	slliw	a1,a1,0x8
ffffffffc02008f6:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008fa:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008fe:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200902:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200906:	0088989b          	slliw	a7,a7,0x8
ffffffffc020090a:	011b78b3          	and	a7,s6,a7
ffffffffc020090e:	005eeeb3          	or	t4,t4,t0
ffffffffc0200912:	00c6e733          	or	a4,a3,a2
ffffffffc0200916:	006c6c33          	or	s8,s8,t1
ffffffffc020091a:	010b76b3          	and	a3,s6,a6
ffffffffc020091e:	00bb7b33          	and	s6,s6,a1
ffffffffc0200922:	01d7e7b3          	or	a5,a5,t4
ffffffffc0200926:	016c6b33          	or	s6,s8,s6
ffffffffc020092a:	01146433          	or	s0,s0,a7
ffffffffc020092e:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200930:	1702                	slli	a4,a4,0x20
ffffffffc0200932:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200934:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200936:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200938:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020093a:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093e:	0167eb33          	or	s6,a5,s6
ffffffffc0200942:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200944:	855ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200948:	85a2                	mv	a1,s0
ffffffffc020094a:	00005517          	auipc	a0,0x5
ffffffffc020094e:	33e50513          	addi	a0,a0,830 # ffffffffc0205c88 <commands+0x158>
ffffffffc0200952:	847ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200956:	014b5613          	srli	a2,s6,0x14
ffffffffc020095a:	85da                	mv	a1,s6
ffffffffc020095c:	00005517          	auipc	a0,0x5
ffffffffc0200960:	34450513          	addi	a0,a0,836 # ffffffffc0205ca0 <commands+0x170>
ffffffffc0200964:	835ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200968:	008b05b3          	add	a1,s6,s0
ffffffffc020096c:	15fd                	addi	a1,a1,-1
ffffffffc020096e:	00005517          	auipc	a0,0x5
ffffffffc0200972:	35250513          	addi	a0,a0,850 # ffffffffc0205cc0 <commands+0x190>
ffffffffc0200976:	823ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc020097a:	00005517          	auipc	a0,0x5
ffffffffc020097e:	39650513          	addi	a0,a0,918 # ffffffffc0205d10 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200982:	000c6797          	auipc	a5,0xc6
ffffffffc0200986:	1487bb23          	sd	s0,342(a5) # ffffffffc02c6ad8 <memory_base>
        memory_size = mem_size;
ffffffffc020098a:	000c6797          	auipc	a5,0xc6
ffffffffc020098e:	1567bb23          	sd	s6,342(a5) # ffffffffc02c6ae0 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200992:	b3f5                	j	ffffffffc020077e <dtb_init+0x186>

ffffffffc0200994 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200994:	000c6517          	auipc	a0,0xc6
ffffffffc0200998:	14453503          	ld	a0,324(a0) # ffffffffc02c6ad8 <memory_base>
ffffffffc020099c:	8082                	ret

ffffffffc020099e <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc020099e:	000c6517          	auipc	a0,0xc6
ffffffffc02009a2:	14253503          	ld	a0,322(a0) # ffffffffc02c6ae0 <memory_size>
ffffffffc02009a6:	8082                	ret

ffffffffc02009a8 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009a8:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009ac:	8082                	ret

ffffffffc02009ae <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ae:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009b4:	8082                	ret

ffffffffc02009b6 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009b6:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009ba:	00000797          	auipc	a5,0x0
ffffffffc02009be:	49278793          	addi	a5,a5,1170 # ffffffffc0200e4c <__alltraps>
ffffffffc02009c2:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009c6:	000407b7          	lui	a5,0x40
ffffffffc02009ca:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009ce:	8082                	ret

ffffffffc02009d0 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d0:	610c                	ld	a1,0(a0)
{
ffffffffc02009d2:	1141                	addi	sp,sp,-16
ffffffffc02009d4:	e022                	sd	s0,0(sp)
ffffffffc02009d6:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d8:	00005517          	auipc	a0,0x5
ffffffffc02009dc:	35050513          	addi	a0,a0,848 # ffffffffc0205d28 <commands+0x1f8>
{
ffffffffc02009e0:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e2:	fb6ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009e6:	640c                	ld	a1,8(s0)
ffffffffc02009e8:	00005517          	auipc	a0,0x5
ffffffffc02009ec:	35850513          	addi	a0,a0,856 # ffffffffc0205d40 <commands+0x210>
ffffffffc02009f0:	fa8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009f4:	680c                	ld	a1,16(s0)
ffffffffc02009f6:	00005517          	auipc	a0,0x5
ffffffffc02009fa:	36250513          	addi	a0,a0,866 # ffffffffc0205d58 <commands+0x228>
ffffffffc02009fe:	f9aff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a02:	6c0c                	ld	a1,24(s0)
ffffffffc0200a04:	00005517          	auipc	a0,0x5
ffffffffc0200a08:	36c50513          	addi	a0,a0,876 # ffffffffc0205d70 <commands+0x240>
ffffffffc0200a0c:	f8cff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a10:	700c                	ld	a1,32(s0)
ffffffffc0200a12:	00005517          	auipc	a0,0x5
ffffffffc0200a16:	37650513          	addi	a0,a0,886 # ffffffffc0205d88 <commands+0x258>
ffffffffc0200a1a:	f7eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a1e:	740c                	ld	a1,40(s0)
ffffffffc0200a20:	00005517          	auipc	a0,0x5
ffffffffc0200a24:	38050513          	addi	a0,a0,896 # ffffffffc0205da0 <commands+0x270>
ffffffffc0200a28:	f70ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a2c:	780c                	ld	a1,48(s0)
ffffffffc0200a2e:	00005517          	auipc	a0,0x5
ffffffffc0200a32:	38a50513          	addi	a0,a0,906 # ffffffffc0205db8 <commands+0x288>
ffffffffc0200a36:	f62ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a3a:	7c0c                	ld	a1,56(s0)
ffffffffc0200a3c:	00005517          	auipc	a0,0x5
ffffffffc0200a40:	39450513          	addi	a0,a0,916 # ffffffffc0205dd0 <commands+0x2a0>
ffffffffc0200a44:	f54ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a48:	602c                	ld	a1,64(s0)
ffffffffc0200a4a:	00005517          	auipc	a0,0x5
ffffffffc0200a4e:	39e50513          	addi	a0,a0,926 # ffffffffc0205de8 <commands+0x2b8>
ffffffffc0200a52:	f46ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a56:	642c                	ld	a1,72(s0)
ffffffffc0200a58:	00005517          	auipc	a0,0x5
ffffffffc0200a5c:	3a850513          	addi	a0,a0,936 # ffffffffc0205e00 <commands+0x2d0>
ffffffffc0200a60:	f38ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a64:	682c                	ld	a1,80(s0)
ffffffffc0200a66:	00005517          	auipc	a0,0x5
ffffffffc0200a6a:	3b250513          	addi	a0,a0,946 # ffffffffc0205e18 <commands+0x2e8>
ffffffffc0200a6e:	f2aff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a72:	6c2c                	ld	a1,88(s0)
ffffffffc0200a74:	00005517          	auipc	a0,0x5
ffffffffc0200a78:	3bc50513          	addi	a0,a0,956 # ffffffffc0205e30 <commands+0x300>
ffffffffc0200a7c:	f1cff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a80:	702c                	ld	a1,96(s0)
ffffffffc0200a82:	00005517          	auipc	a0,0x5
ffffffffc0200a86:	3c650513          	addi	a0,a0,966 # ffffffffc0205e48 <commands+0x318>
ffffffffc0200a8a:	f0eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a8e:	742c                	ld	a1,104(s0)
ffffffffc0200a90:	00005517          	auipc	a0,0x5
ffffffffc0200a94:	3d050513          	addi	a0,a0,976 # ffffffffc0205e60 <commands+0x330>
ffffffffc0200a98:	f00ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200a9c:	782c                	ld	a1,112(s0)
ffffffffc0200a9e:	00005517          	auipc	a0,0x5
ffffffffc0200aa2:	3da50513          	addi	a0,a0,986 # ffffffffc0205e78 <commands+0x348>
ffffffffc0200aa6:	ef2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200aaa:	7c2c                	ld	a1,120(s0)
ffffffffc0200aac:	00005517          	auipc	a0,0x5
ffffffffc0200ab0:	3e450513          	addi	a0,a0,996 # ffffffffc0205e90 <commands+0x360>
ffffffffc0200ab4:	ee4ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200ab8:	604c                	ld	a1,128(s0)
ffffffffc0200aba:	00005517          	auipc	a0,0x5
ffffffffc0200abe:	3ee50513          	addi	a0,a0,1006 # ffffffffc0205ea8 <commands+0x378>
ffffffffc0200ac2:	ed6ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200ac6:	644c                	ld	a1,136(s0)
ffffffffc0200ac8:	00005517          	auipc	a0,0x5
ffffffffc0200acc:	3f850513          	addi	a0,a0,1016 # ffffffffc0205ec0 <commands+0x390>
ffffffffc0200ad0:	ec8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ad4:	684c                	ld	a1,144(s0)
ffffffffc0200ad6:	00005517          	auipc	a0,0x5
ffffffffc0200ada:	40250513          	addi	a0,a0,1026 # ffffffffc0205ed8 <commands+0x3a8>
ffffffffc0200ade:	ebaff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae2:	6c4c                	ld	a1,152(s0)
ffffffffc0200ae4:	00005517          	auipc	a0,0x5
ffffffffc0200ae8:	40c50513          	addi	a0,a0,1036 # ffffffffc0205ef0 <commands+0x3c0>
ffffffffc0200aec:	eacff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af0:	704c                	ld	a1,160(s0)
ffffffffc0200af2:	00005517          	auipc	a0,0x5
ffffffffc0200af6:	41650513          	addi	a0,a0,1046 # ffffffffc0205f08 <commands+0x3d8>
ffffffffc0200afa:	e9eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200afe:	744c                	ld	a1,168(s0)
ffffffffc0200b00:	00005517          	auipc	a0,0x5
ffffffffc0200b04:	42050513          	addi	a0,a0,1056 # ffffffffc0205f20 <commands+0x3f0>
ffffffffc0200b08:	e90ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b0c:	784c                	ld	a1,176(s0)
ffffffffc0200b0e:	00005517          	auipc	a0,0x5
ffffffffc0200b12:	42a50513          	addi	a0,a0,1066 # ffffffffc0205f38 <commands+0x408>
ffffffffc0200b16:	e82ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b1a:	7c4c                	ld	a1,184(s0)
ffffffffc0200b1c:	00005517          	auipc	a0,0x5
ffffffffc0200b20:	43450513          	addi	a0,a0,1076 # ffffffffc0205f50 <commands+0x420>
ffffffffc0200b24:	e74ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b28:	606c                	ld	a1,192(s0)
ffffffffc0200b2a:	00005517          	auipc	a0,0x5
ffffffffc0200b2e:	43e50513          	addi	a0,a0,1086 # ffffffffc0205f68 <commands+0x438>
ffffffffc0200b32:	e66ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b36:	646c                	ld	a1,200(s0)
ffffffffc0200b38:	00005517          	auipc	a0,0x5
ffffffffc0200b3c:	44850513          	addi	a0,a0,1096 # ffffffffc0205f80 <commands+0x450>
ffffffffc0200b40:	e58ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b44:	686c                	ld	a1,208(s0)
ffffffffc0200b46:	00005517          	auipc	a0,0x5
ffffffffc0200b4a:	45250513          	addi	a0,a0,1106 # ffffffffc0205f98 <commands+0x468>
ffffffffc0200b4e:	e4aff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b52:	6c6c                	ld	a1,216(s0)
ffffffffc0200b54:	00005517          	auipc	a0,0x5
ffffffffc0200b58:	45c50513          	addi	a0,a0,1116 # ffffffffc0205fb0 <commands+0x480>
ffffffffc0200b5c:	e3cff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b60:	706c                	ld	a1,224(s0)
ffffffffc0200b62:	00005517          	auipc	a0,0x5
ffffffffc0200b66:	46650513          	addi	a0,a0,1126 # ffffffffc0205fc8 <commands+0x498>
ffffffffc0200b6a:	e2eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b6e:	746c                	ld	a1,232(s0)
ffffffffc0200b70:	00005517          	auipc	a0,0x5
ffffffffc0200b74:	47050513          	addi	a0,a0,1136 # ffffffffc0205fe0 <commands+0x4b0>
ffffffffc0200b78:	e20ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b7c:	786c                	ld	a1,240(s0)
ffffffffc0200b7e:	00005517          	auipc	a0,0x5
ffffffffc0200b82:	47a50513          	addi	a0,a0,1146 # ffffffffc0205ff8 <commands+0x4c8>
ffffffffc0200b86:	e12ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b8a:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b8c:	6402                	ld	s0,0(sp)
ffffffffc0200b8e:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	00005517          	auipc	a0,0x5
ffffffffc0200b94:	48050513          	addi	a0,a0,1152 # ffffffffc0206010 <commands+0x4e0>
}
ffffffffc0200b98:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b9a:	dfeff06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0200b9e <print_trapframe>:
{
ffffffffc0200b9e:	1141                	addi	sp,sp,-16
ffffffffc0200ba0:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba2:	85aa                	mv	a1,a0
{
ffffffffc0200ba4:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba6:	00005517          	auipc	a0,0x5
ffffffffc0200baa:	48250513          	addi	a0,a0,1154 # ffffffffc0206028 <commands+0x4f8>
{
ffffffffc0200bae:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb0:	de8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bb4:	8522                	mv	a0,s0
ffffffffc0200bb6:	e1bff0ef          	jal	ra,ffffffffc02009d0 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bba:	10043583          	ld	a1,256(s0)
ffffffffc0200bbe:	00005517          	auipc	a0,0x5
ffffffffc0200bc2:	48250513          	addi	a0,a0,1154 # ffffffffc0206040 <commands+0x510>
ffffffffc0200bc6:	dd2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bca:	10843583          	ld	a1,264(s0)
ffffffffc0200bce:	00005517          	auipc	a0,0x5
ffffffffc0200bd2:	48a50513          	addi	a0,a0,1162 # ffffffffc0206058 <commands+0x528>
ffffffffc0200bd6:	dc2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200bda:	11043583          	ld	a1,272(s0)
ffffffffc0200bde:	00005517          	auipc	a0,0x5
ffffffffc0200be2:	49250513          	addi	a0,a0,1170 # ffffffffc0206070 <commands+0x540>
ffffffffc0200be6:	db2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bea:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bee:	6402                	ld	s0,0(sp)
ffffffffc0200bf0:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf2:	00005517          	auipc	a0,0x5
ffffffffc0200bf6:	48e50513          	addi	a0,a0,1166 # ffffffffc0206080 <commands+0x550>
}
ffffffffc0200bfa:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bfc:	d9cff06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0200c00 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c00:	11853783          	ld	a5,280(a0)
ffffffffc0200c04:	472d                	li	a4,11
ffffffffc0200c06:	0786                	slli	a5,a5,0x1
ffffffffc0200c08:	8385                	srli	a5,a5,0x1
ffffffffc0200c0a:	08f76663          	bltu	a4,a5,ffffffffc0200c96 <interrupt_handler+0x96>
ffffffffc0200c0e:	00005717          	auipc	a4,0x5
ffffffffc0200c12:	53a70713          	addi	a4,a4,1338 # ffffffffc0206148 <commands+0x618>
ffffffffc0200c16:	078a                	slli	a5,a5,0x2
ffffffffc0200c18:	97ba                	add	a5,a5,a4
ffffffffc0200c1a:	439c                	lw	a5,0(a5)
ffffffffc0200c1c:	97ba                	add	a5,a5,a4
ffffffffc0200c1e:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c20:	00005517          	auipc	a0,0x5
ffffffffc0200c24:	4d850513          	addi	a0,a0,1240 # ffffffffc02060f8 <commands+0x5c8>
ffffffffc0200c28:	d70ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c2c:	00005517          	auipc	a0,0x5
ffffffffc0200c30:	4ac50513          	addi	a0,a0,1196 # ffffffffc02060d8 <commands+0x5a8>
ffffffffc0200c34:	d64ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c38:	00005517          	auipc	a0,0x5
ffffffffc0200c3c:	46050513          	addi	a0,a0,1120 # ffffffffc0206098 <commands+0x568>
ffffffffc0200c40:	d58ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c44:	00005517          	auipc	a0,0x5
ffffffffc0200c48:	47450513          	addi	a0,a0,1140 # ffffffffc02060b8 <commands+0x588>
ffffffffc0200c4c:	d4cff06f          	j	ffffffffc0200198 <cprintf>
{
ffffffffc0200c50:	1141                	addi	sp,sp,-16
ffffffffc0200c52:	e022                	sd	s0,0(sp)
ffffffffc0200c54:	e406                	sd	ra,8(sp)
        // In fact, Call sbi_set_timer will clear STIP, or you can clear it
        // directly.
        // clear_csr(sip, SIP_STIP);
        // 2312773

        clock_set_next_event();
ffffffffc0200c56:	919ff0ef          	jal	ra,ffffffffc020056e <clock_set_next_event>
        ticks++;
ffffffffc0200c5a:	000c6717          	auipc	a4,0xc6
ffffffffc0200c5e:	e7670713          	addi	a4,a4,-394 # ffffffffc02c6ad0 <ticks>
ffffffffc0200c62:	631c                	ld	a5,0(a4)
        if (current != NULL)
ffffffffc0200c64:	000c6417          	auipc	s0,0xc6
ffffffffc0200c68:	ec440413          	addi	s0,s0,-316 # ffffffffc02c6b28 <current>
ffffffffc0200c6c:	6008                	ld	a0,0(s0)
        ticks++;
ffffffffc0200c6e:	0785                	addi	a5,a5,1
ffffffffc0200c70:	e31c                	sd	a5,0(a4)
        if (current != NULL)
ffffffffc0200c72:	c125                	beqz	a0,ffffffffc0200cd2 <interrupt_handler+0xd2>
        {
            if (ticks % TICK_NUM == 0)
ffffffffc0200c74:	631c                	ld	a5,0(a4)
ffffffffc0200c76:	06400713          	li	a4,100
ffffffffc0200c7a:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200c7e:	cf89                	beqz	a5,ffffffffc0200c98 <interrupt_handler+0x98>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c80:	6402                	ld	s0,0(sp)
ffffffffc0200c82:	60a2                	ld	ra,8(sp)
ffffffffc0200c84:	0141                	addi	sp,sp,16
            sched_class_proc_tick(current);
ffffffffc0200c86:	4820406f          	j	ffffffffc0205108 <sched_class_proc_tick>
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c8a:	00005517          	auipc	a0,0x5
ffffffffc0200c8e:	49e50513          	addi	a0,a0,1182 # ffffffffc0206128 <commands+0x5f8>
ffffffffc0200c92:	d06ff06f          	j	ffffffffc0200198 <cprintf>
        print_trapframe(tf);
ffffffffc0200c96:	b721                	j	ffffffffc0200b9e <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c98:	06400593          	li	a1,100
ffffffffc0200c9c:	00005517          	auipc	a0,0x5
ffffffffc0200ca0:	47c50513          	addi	a0,a0,1148 # ffffffffc0206118 <commands+0x5e8>
ffffffffc0200ca4:	cf4ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
                num++;
ffffffffc0200ca8:	000c6717          	auipc	a4,0xc6
ffffffffc0200cac:	e4070713          	addi	a4,a4,-448 # ffffffffc02c6ae8 <num>
ffffffffc0200cb0:	631c                	ld	a5,0(a4)
                current->need_resched = 1;
ffffffffc0200cb2:	6008                	ld	a0,0(s0)
ffffffffc0200cb4:	4685                	li	a3,1
                num++;
ffffffffc0200cb6:	0785                	addi	a5,a5,1
ffffffffc0200cb8:	e31c                	sd	a5,0(a4)
                current->need_resched = 1;
ffffffffc0200cba:	ed14                	sd	a3,24(a0)
                if (num == 10)
ffffffffc0200cbc:	4729                	li	a4,10
ffffffffc0200cbe:	fce791e3          	bne	a5,a4,ffffffffc0200c80 <interrupt_handler+0x80>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200cc2:	4501                	li	a0,0
ffffffffc0200cc4:	4581                	li	a1,0
ffffffffc0200cc6:	4601                	li	a2,0
ffffffffc0200cc8:	48a1                	li	a7,8
ffffffffc0200cca:	00000073          	ecall
            sched_class_proc_tick(current);
ffffffffc0200cce:	6008                	ld	a0,0(s0)
}
ffffffffc0200cd0:	bf45                	j	ffffffffc0200c80 <interrupt_handler+0x80>
}
ffffffffc0200cd2:	60a2                	ld	ra,8(sp)
ffffffffc0200cd4:	6402                	ld	s0,0(sp)
ffffffffc0200cd6:	0141                	addi	sp,sp,16
ffffffffc0200cd8:	8082                	ret

ffffffffc0200cda <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200cda:	11853783          	ld	a5,280(a0)
{
ffffffffc0200cde:	1141                	addi	sp,sp,-16
ffffffffc0200ce0:	e022                	sd	s0,0(sp)
ffffffffc0200ce2:	e406                	sd	ra,8(sp)
ffffffffc0200ce4:	473d                	li	a4,15
ffffffffc0200ce6:	842a                	mv	s0,a0
ffffffffc0200ce8:	0af76b63          	bltu	a4,a5,ffffffffc0200d9e <exception_handler+0xc4>
ffffffffc0200cec:	00005717          	auipc	a4,0x5
ffffffffc0200cf0:	61c70713          	addi	a4,a4,1564 # ffffffffc0206308 <commands+0x7d8>
ffffffffc0200cf4:	078a                	slli	a5,a5,0x2
ffffffffc0200cf6:	97ba                	add	a5,a5,a4
ffffffffc0200cf8:	439c                	lw	a5,0(a5)
ffffffffc0200cfa:	97ba                	add	a5,a5,a4
ffffffffc0200cfc:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cfe:	00005517          	auipc	a0,0x5
ffffffffc0200d02:	56250513          	addi	a0,a0,1378 # ffffffffc0206260 <commands+0x730>
ffffffffc0200d06:	c92ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        tf->epc += 4;
ffffffffc0200d0a:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200d0e:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200d10:	0791                	addi	a5,a5,4
ffffffffc0200d12:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200d16:	6402                	ld	s0,0(sp)
ffffffffc0200d18:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200d1a:	6580406f          	j	ffffffffc0205372 <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d1e:	00005517          	auipc	a0,0x5
ffffffffc0200d22:	56250513          	addi	a0,a0,1378 # ffffffffc0206280 <commands+0x750>
}
ffffffffc0200d26:	6402                	ld	s0,0(sp)
ffffffffc0200d28:	60a2                	ld	ra,8(sp)
ffffffffc0200d2a:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200d2c:	c6cff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d30:	00005517          	auipc	a0,0x5
ffffffffc0200d34:	57050513          	addi	a0,a0,1392 # ffffffffc02062a0 <commands+0x770>
ffffffffc0200d38:	b7fd                	j	ffffffffc0200d26 <exception_handler+0x4c>
        cprintf("Instruction page fault\n");
ffffffffc0200d3a:	00005517          	auipc	a0,0x5
ffffffffc0200d3e:	58650513          	addi	a0,a0,1414 # ffffffffc02062c0 <commands+0x790>
ffffffffc0200d42:	b7d5                	j	ffffffffc0200d26 <exception_handler+0x4c>
        cprintf("Load page fault\n");
ffffffffc0200d44:	00005517          	auipc	a0,0x5
ffffffffc0200d48:	59450513          	addi	a0,a0,1428 # ffffffffc02062d8 <commands+0x7a8>
ffffffffc0200d4c:	bfe9                	j	ffffffffc0200d26 <exception_handler+0x4c>
        cprintf("Store/AMO page fault\n");
ffffffffc0200d4e:	00005517          	auipc	a0,0x5
ffffffffc0200d52:	5a250513          	addi	a0,a0,1442 # ffffffffc02062f0 <commands+0x7c0>
ffffffffc0200d56:	bfc1                	j	ffffffffc0200d26 <exception_handler+0x4c>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d58:	00005517          	auipc	a0,0x5
ffffffffc0200d5c:	42050513          	addi	a0,a0,1056 # ffffffffc0206178 <commands+0x648>
ffffffffc0200d60:	b7d9                	j	ffffffffc0200d26 <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200d62:	00005517          	auipc	a0,0x5
ffffffffc0200d66:	43650513          	addi	a0,a0,1078 # ffffffffc0206198 <commands+0x668>
ffffffffc0200d6a:	bf75                	j	ffffffffc0200d26 <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200d6c:	00005517          	auipc	a0,0x5
ffffffffc0200d70:	44c50513          	addi	a0,a0,1100 # ffffffffc02061b8 <commands+0x688>
ffffffffc0200d74:	bf4d                	j	ffffffffc0200d26 <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200d76:	00005517          	auipc	a0,0x5
ffffffffc0200d7a:	45a50513          	addi	a0,a0,1114 # ffffffffc02061d0 <commands+0x6a0>
ffffffffc0200d7e:	b765                	j	ffffffffc0200d26 <exception_handler+0x4c>
        cprintf("Load address misaligned\n");
ffffffffc0200d80:	00005517          	auipc	a0,0x5
ffffffffc0200d84:	46050513          	addi	a0,a0,1120 # ffffffffc02061e0 <commands+0x6b0>
ffffffffc0200d88:	bf79                	j	ffffffffc0200d26 <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200d8a:	00005517          	auipc	a0,0x5
ffffffffc0200d8e:	47650513          	addi	a0,a0,1142 # ffffffffc0206200 <commands+0x6d0>
ffffffffc0200d92:	bf51                	j	ffffffffc0200d26 <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d94:	00005517          	auipc	a0,0x5
ffffffffc0200d98:	4b450513          	addi	a0,a0,1204 # ffffffffc0206248 <commands+0x718>
ffffffffc0200d9c:	b769                	j	ffffffffc0200d26 <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200d9e:	8522                	mv	a0,s0
}
ffffffffc0200da0:	6402                	ld	s0,0(sp)
ffffffffc0200da2:	60a2                	ld	ra,8(sp)
ffffffffc0200da4:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200da6:	bbe5                	j	ffffffffc0200b9e <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200da8:	00005617          	auipc	a2,0x5
ffffffffc0200dac:	47060613          	addi	a2,a2,1136 # ffffffffc0206218 <commands+0x6e8>
ffffffffc0200db0:	0c100593          	li	a1,193
ffffffffc0200db4:	00005517          	auipc	a0,0x5
ffffffffc0200db8:	47c50513          	addi	a0,a0,1148 # ffffffffc0206230 <commands+0x700>
ffffffffc0200dbc:	ed6ff0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0200dc0 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200dc0:	1101                	addi	sp,sp,-32
ffffffffc0200dc2:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200dc4:	000c6417          	auipc	s0,0xc6
ffffffffc0200dc8:	d6440413          	addi	s0,s0,-668 # ffffffffc02c6b28 <current>
ffffffffc0200dcc:	6018                	ld	a4,0(s0)
{
ffffffffc0200dce:	ec06                	sd	ra,24(sp)
ffffffffc0200dd0:	e426                	sd	s1,8(sp)
ffffffffc0200dd2:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dd4:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200dd8:	cf1d                	beqz	a4,ffffffffc0200e16 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200dda:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200dde:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200de2:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200de4:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200de8:	0206c463          	bltz	a3,ffffffffc0200e10 <trap+0x50>
        exception_handler(tf);
ffffffffc0200dec:	eefff0ef          	jal	ra,ffffffffc0200cda <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200df0:	601c                	ld	a5,0(s0)
ffffffffc0200df2:	0b27b023          	sd	s2,160(a5) # 400a0 <_binary_obj___user_matrix_out_size+0x33998>
        if (!in_kernel)
ffffffffc0200df6:	e499                	bnez	s1,ffffffffc0200e04 <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200df8:	0b07a703          	lw	a4,176(a5)
ffffffffc0200dfc:	8b05                	andi	a4,a4,1
ffffffffc0200dfe:	e329                	bnez	a4,ffffffffc0200e40 <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200e00:	6f9c                	ld	a5,24(a5)
ffffffffc0200e02:	eb85                	bnez	a5,ffffffffc0200e32 <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200e04:	60e2                	ld	ra,24(sp)
ffffffffc0200e06:	6442                	ld	s0,16(sp)
ffffffffc0200e08:	64a2                	ld	s1,8(sp)
ffffffffc0200e0a:	6902                	ld	s2,0(sp)
ffffffffc0200e0c:	6105                	addi	sp,sp,32
ffffffffc0200e0e:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200e10:	df1ff0ef          	jal	ra,ffffffffc0200c00 <interrupt_handler>
ffffffffc0200e14:	bff1                	j	ffffffffc0200df0 <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e16:	0006c863          	bltz	a3,ffffffffc0200e26 <trap+0x66>
}
ffffffffc0200e1a:	6442                	ld	s0,16(sp)
ffffffffc0200e1c:	60e2                	ld	ra,24(sp)
ffffffffc0200e1e:	64a2                	ld	s1,8(sp)
ffffffffc0200e20:	6902                	ld	s2,0(sp)
ffffffffc0200e22:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200e24:	bd5d                	j	ffffffffc0200cda <exception_handler>
}
ffffffffc0200e26:	6442                	ld	s0,16(sp)
ffffffffc0200e28:	60e2                	ld	ra,24(sp)
ffffffffc0200e2a:	64a2                	ld	s1,8(sp)
ffffffffc0200e2c:	6902                	ld	s2,0(sp)
ffffffffc0200e2e:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200e30:	bbc1                	j	ffffffffc0200c00 <interrupt_handler>
}
ffffffffc0200e32:	6442                	ld	s0,16(sp)
ffffffffc0200e34:	60e2                	ld	ra,24(sp)
ffffffffc0200e36:	64a2                	ld	s1,8(sp)
ffffffffc0200e38:	6902                	ld	s2,0(sp)
ffffffffc0200e3a:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e3c:	3f80406f          	j	ffffffffc0205234 <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e40:	555d                	li	a0,-9
ffffffffc0200e42:	4fa030ef          	jal	ra,ffffffffc020433c <do_exit>
            if (current->need_resched)
ffffffffc0200e46:	601c                	ld	a5,0(s0)
ffffffffc0200e48:	bf65                	j	ffffffffc0200e00 <trap+0x40>
	...

ffffffffc0200e4c <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e4c:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e50:	00011463          	bnez	sp,ffffffffc0200e58 <__alltraps+0xc>
ffffffffc0200e54:	14002173          	csrr	sp,sscratch
ffffffffc0200e58:	712d                	addi	sp,sp,-288
ffffffffc0200e5a:	e002                	sd	zero,0(sp)
ffffffffc0200e5c:	e406                	sd	ra,8(sp)
ffffffffc0200e5e:	ec0e                	sd	gp,24(sp)
ffffffffc0200e60:	f012                	sd	tp,32(sp)
ffffffffc0200e62:	f416                	sd	t0,40(sp)
ffffffffc0200e64:	f81a                	sd	t1,48(sp)
ffffffffc0200e66:	fc1e                	sd	t2,56(sp)
ffffffffc0200e68:	e0a2                	sd	s0,64(sp)
ffffffffc0200e6a:	e4a6                	sd	s1,72(sp)
ffffffffc0200e6c:	e8aa                	sd	a0,80(sp)
ffffffffc0200e6e:	ecae                	sd	a1,88(sp)
ffffffffc0200e70:	f0b2                	sd	a2,96(sp)
ffffffffc0200e72:	f4b6                	sd	a3,104(sp)
ffffffffc0200e74:	f8ba                	sd	a4,112(sp)
ffffffffc0200e76:	fcbe                	sd	a5,120(sp)
ffffffffc0200e78:	e142                	sd	a6,128(sp)
ffffffffc0200e7a:	e546                	sd	a7,136(sp)
ffffffffc0200e7c:	e94a                	sd	s2,144(sp)
ffffffffc0200e7e:	ed4e                	sd	s3,152(sp)
ffffffffc0200e80:	f152                	sd	s4,160(sp)
ffffffffc0200e82:	f556                	sd	s5,168(sp)
ffffffffc0200e84:	f95a                	sd	s6,176(sp)
ffffffffc0200e86:	fd5e                	sd	s7,184(sp)
ffffffffc0200e88:	e1e2                	sd	s8,192(sp)
ffffffffc0200e8a:	e5e6                	sd	s9,200(sp)
ffffffffc0200e8c:	e9ea                	sd	s10,208(sp)
ffffffffc0200e8e:	edee                	sd	s11,216(sp)
ffffffffc0200e90:	f1f2                	sd	t3,224(sp)
ffffffffc0200e92:	f5f6                	sd	t4,232(sp)
ffffffffc0200e94:	f9fa                	sd	t5,240(sp)
ffffffffc0200e96:	fdfe                	sd	t6,248(sp)
ffffffffc0200e98:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200e9c:	100024f3          	csrr	s1,sstatus
ffffffffc0200ea0:	14102973          	csrr	s2,sepc
ffffffffc0200ea4:	143029f3          	csrr	s3,stval
ffffffffc0200ea8:	14202a73          	csrr	s4,scause
ffffffffc0200eac:	e822                	sd	s0,16(sp)
ffffffffc0200eae:	e226                	sd	s1,256(sp)
ffffffffc0200eb0:	e64a                	sd	s2,264(sp)
ffffffffc0200eb2:	ea4e                	sd	s3,272(sp)
ffffffffc0200eb4:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200eb6:	850a                	mv	a0,sp
    jal trap
ffffffffc0200eb8:	f09ff0ef          	jal	ra,ffffffffc0200dc0 <trap>

ffffffffc0200ebc <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200ebc:	6492                	ld	s1,256(sp)
ffffffffc0200ebe:	6932                	ld	s2,264(sp)
ffffffffc0200ec0:	1004f413          	andi	s0,s1,256
ffffffffc0200ec4:	e401                	bnez	s0,ffffffffc0200ecc <__trapret+0x10>
ffffffffc0200ec6:	1200                	addi	s0,sp,288
ffffffffc0200ec8:	14041073          	csrw	sscratch,s0
ffffffffc0200ecc:	10049073          	csrw	sstatus,s1
ffffffffc0200ed0:	14191073          	csrw	sepc,s2
ffffffffc0200ed4:	60a2                	ld	ra,8(sp)
ffffffffc0200ed6:	61e2                	ld	gp,24(sp)
ffffffffc0200ed8:	7202                	ld	tp,32(sp)
ffffffffc0200eda:	72a2                	ld	t0,40(sp)
ffffffffc0200edc:	7342                	ld	t1,48(sp)
ffffffffc0200ede:	73e2                	ld	t2,56(sp)
ffffffffc0200ee0:	6406                	ld	s0,64(sp)
ffffffffc0200ee2:	64a6                	ld	s1,72(sp)
ffffffffc0200ee4:	6546                	ld	a0,80(sp)
ffffffffc0200ee6:	65e6                	ld	a1,88(sp)
ffffffffc0200ee8:	7606                	ld	a2,96(sp)
ffffffffc0200eea:	76a6                	ld	a3,104(sp)
ffffffffc0200eec:	7746                	ld	a4,112(sp)
ffffffffc0200eee:	77e6                	ld	a5,120(sp)
ffffffffc0200ef0:	680a                	ld	a6,128(sp)
ffffffffc0200ef2:	68aa                	ld	a7,136(sp)
ffffffffc0200ef4:	694a                	ld	s2,144(sp)
ffffffffc0200ef6:	69ea                	ld	s3,152(sp)
ffffffffc0200ef8:	7a0a                	ld	s4,160(sp)
ffffffffc0200efa:	7aaa                	ld	s5,168(sp)
ffffffffc0200efc:	7b4a                	ld	s6,176(sp)
ffffffffc0200efe:	7bea                	ld	s7,184(sp)
ffffffffc0200f00:	6c0e                	ld	s8,192(sp)
ffffffffc0200f02:	6cae                	ld	s9,200(sp)
ffffffffc0200f04:	6d4e                	ld	s10,208(sp)
ffffffffc0200f06:	6dee                	ld	s11,216(sp)
ffffffffc0200f08:	7e0e                	ld	t3,224(sp)
ffffffffc0200f0a:	7eae                	ld	t4,232(sp)
ffffffffc0200f0c:	7f4e                	ld	t5,240(sp)
ffffffffc0200f0e:	7fee                	ld	t6,248(sp)
ffffffffc0200f10:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200f12:	10200073          	sret

ffffffffc0200f16 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200f16:	812a                	mv	sp,a0
ffffffffc0200f18:	b755                	j	ffffffffc0200ebc <__trapret>

ffffffffc0200f1a <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200f1a:	000c2797          	auipc	a5,0xc2
ffffffffc0200f1e:	b5678793          	addi	a5,a5,-1194 # ffffffffc02c2a70 <free_area>
ffffffffc0200f22:	e79c                	sd	a5,8(a5)
ffffffffc0200f24:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200f26:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200f2a:	8082                	ret

ffffffffc0200f2c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200f2c:	000c2517          	auipc	a0,0xc2
ffffffffc0200f30:	b5456503          	lwu	a0,-1196(a0) # ffffffffc02c2a80 <free_area+0x10>
ffffffffc0200f34:	8082                	ret

ffffffffc0200f36 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0200f36:	715d                	addi	sp,sp,-80
ffffffffc0200f38:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200f3a:	000c2417          	auipc	s0,0xc2
ffffffffc0200f3e:	b3640413          	addi	s0,s0,-1226 # ffffffffc02c2a70 <free_area>
ffffffffc0200f42:	641c                	ld	a5,8(s0)
ffffffffc0200f44:	e486                	sd	ra,72(sp)
ffffffffc0200f46:	fc26                	sd	s1,56(sp)
ffffffffc0200f48:	f84a                	sd	s2,48(sp)
ffffffffc0200f4a:	f44e                	sd	s3,40(sp)
ffffffffc0200f4c:	f052                	sd	s4,32(sp)
ffffffffc0200f4e:	ec56                	sd	s5,24(sp)
ffffffffc0200f50:	e85a                	sd	s6,16(sp)
ffffffffc0200f52:	e45e                	sd	s7,8(sp)
ffffffffc0200f54:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0200f56:	2a878d63          	beq	a5,s0,ffffffffc0201210 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0200f5a:	4481                	li	s1,0
ffffffffc0200f5c:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200f5e:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200f62:	8b09                	andi	a4,a4,2
ffffffffc0200f64:	2a070a63          	beqz	a4,ffffffffc0201218 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc0200f68:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200f6c:	679c                	ld	a5,8(a5)
ffffffffc0200f6e:	2905                	addiw	s2,s2,1
ffffffffc0200f70:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0200f72:	fe8796e3          	bne	a5,s0,ffffffffc0200f5e <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200f76:	89a6                	mv	s3,s1
ffffffffc0200f78:	6df000ef          	jal	ra,ffffffffc0201e56 <nr_free_pages>
ffffffffc0200f7c:	6f351e63          	bne	a0,s3,ffffffffc0201678 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f80:	4505                	li	a0,1
ffffffffc0200f82:	657000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc0200f86:	8aaa                	mv	s5,a0
ffffffffc0200f88:	42050863          	beqz	a0,ffffffffc02013b8 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200f8c:	4505                	li	a0,1
ffffffffc0200f8e:	64b000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc0200f92:	89aa                	mv	s3,a0
ffffffffc0200f94:	70050263          	beqz	a0,ffffffffc0201698 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200f98:	4505                	li	a0,1
ffffffffc0200f9a:	63f000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc0200f9e:	8a2a                	mv	s4,a0
ffffffffc0200fa0:	48050c63          	beqz	a0,ffffffffc0201438 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200fa4:	293a8a63          	beq	s5,s3,ffffffffc0201238 <default_check+0x302>
ffffffffc0200fa8:	28aa8863          	beq	s5,a0,ffffffffc0201238 <default_check+0x302>
ffffffffc0200fac:	28a98663          	beq	s3,a0,ffffffffc0201238 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200fb0:	000aa783          	lw	a5,0(s5)
ffffffffc0200fb4:	2a079263          	bnez	a5,ffffffffc0201258 <default_check+0x322>
ffffffffc0200fb8:	0009a783          	lw	a5,0(s3)
ffffffffc0200fbc:	28079e63          	bnez	a5,ffffffffc0201258 <default_check+0x322>
ffffffffc0200fc0:	411c                	lw	a5,0(a0)
ffffffffc0200fc2:	28079b63          	bnez	a5,ffffffffc0201258 <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0200fc6:	000c6797          	auipc	a5,0xc6
ffffffffc0200fca:	b4a7b783          	ld	a5,-1206(a5) # ffffffffc02c6b10 <pages>
ffffffffc0200fce:	40fa8733          	sub	a4,s5,a5
ffffffffc0200fd2:	00007617          	auipc	a2,0x7
ffffffffc0200fd6:	1a663603          	ld	a2,422(a2) # ffffffffc0208178 <nbase>
ffffffffc0200fda:	8719                	srai	a4,a4,0x6
ffffffffc0200fdc:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200fde:	000c6697          	auipc	a3,0xc6
ffffffffc0200fe2:	b2a6b683          	ld	a3,-1238(a3) # ffffffffc02c6b08 <npage>
ffffffffc0200fe6:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0200fe8:	0732                	slli	a4,a4,0xc
ffffffffc0200fea:	28d77763          	bgeu	a4,a3,ffffffffc0201278 <default_check+0x342>
    return page - pages + nbase;
ffffffffc0200fee:	40f98733          	sub	a4,s3,a5
ffffffffc0200ff2:	8719                	srai	a4,a4,0x6
ffffffffc0200ff4:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200ff6:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200ff8:	4cd77063          	bgeu	a4,a3,ffffffffc02014b8 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0200ffc:	40f507b3          	sub	a5,a0,a5
ffffffffc0201000:	8799                	srai	a5,a5,0x6
ffffffffc0201002:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201004:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201006:	30d7f963          	bgeu	a5,a3,ffffffffc0201318 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc020100a:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020100c:	00043c03          	ld	s8,0(s0)
ffffffffc0201010:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201014:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201018:	e400                	sd	s0,8(s0)
ffffffffc020101a:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc020101c:	000c2797          	auipc	a5,0xc2
ffffffffc0201020:	a607a223          	sw	zero,-1436(a5) # ffffffffc02c2a80 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201024:	5b5000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc0201028:	2c051863          	bnez	a0,ffffffffc02012f8 <default_check+0x3c2>
    free_page(p0);
ffffffffc020102c:	4585                	li	a1,1
ffffffffc020102e:	8556                	mv	a0,s5
ffffffffc0201030:	5e7000ef          	jal	ra,ffffffffc0201e16 <free_pages>
    free_page(p1);
ffffffffc0201034:	4585                	li	a1,1
ffffffffc0201036:	854e                	mv	a0,s3
ffffffffc0201038:	5df000ef          	jal	ra,ffffffffc0201e16 <free_pages>
    free_page(p2);
ffffffffc020103c:	4585                	li	a1,1
ffffffffc020103e:	8552                	mv	a0,s4
ffffffffc0201040:	5d7000ef          	jal	ra,ffffffffc0201e16 <free_pages>
    assert(nr_free == 3);
ffffffffc0201044:	4818                	lw	a4,16(s0)
ffffffffc0201046:	478d                	li	a5,3
ffffffffc0201048:	28f71863          	bne	a4,a5,ffffffffc02012d8 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020104c:	4505                	li	a0,1
ffffffffc020104e:	58b000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc0201052:	89aa                	mv	s3,a0
ffffffffc0201054:	26050263          	beqz	a0,ffffffffc02012b8 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201058:	4505                	li	a0,1
ffffffffc020105a:	57f000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc020105e:	8aaa                	mv	s5,a0
ffffffffc0201060:	3a050c63          	beqz	a0,ffffffffc0201418 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201064:	4505                	li	a0,1
ffffffffc0201066:	573000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc020106a:	8a2a                	mv	s4,a0
ffffffffc020106c:	38050663          	beqz	a0,ffffffffc02013f8 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0201070:	4505                	li	a0,1
ffffffffc0201072:	567000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc0201076:	36051163          	bnez	a0,ffffffffc02013d8 <default_check+0x4a2>
    free_page(p0);
ffffffffc020107a:	4585                	li	a1,1
ffffffffc020107c:	854e                	mv	a0,s3
ffffffffc020107e:	599000ef          	jal	ra,ffffffffc0201e16 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201082:	641c                	ld	a5,8(s0)
ffffffffc0201084:	20878a63          	beq	a5,s0,ffffffffc0201298 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201088:	4505                	li	a0,1
ffffffffc020108a:	54f000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc020108e:	30a99563          	bne	s3,a0,ffffffffc0201398 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0201092:	4505                	li	a0,1
ffffffffc0201094:	545000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc0201098:	2e051063          	bnez	a0,ffffffffc0201378 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc020109c:	481c                	lw	a5,16(s0)
ffffffffc020109e:	2a079d63          	bnez	a5,ffffffffc0201358 <default_check+0x422>
    free_page(p);
ffffffffc02010a2:	854e                	mv	a0,s3
ffffffffc02010a4:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc02010a6:	01843023          	sd	s8,0(s0)
ffffffffc02010aa:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc02010ae:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc02010b2:	565000ef          	jal	ra,ffffffffc0201e16 <free_pages>
    free_page(p1);
ffffffffc02010b6:	4585                	li	a1,1
ffffffffc02010b8:	8556                	mv	a0,s5
ffffffffc02010ba:	55d000ef          	jal	ra,ffffffffc0201e16 <free_pages>
    free_page(p2);
ffffffffc02010be:	4585                	li	a1,1
ffffffffc02010c0:	8552                	mv	a0,s4
ffffffffc02010c2:	555000ef          	jal	ra,ffffffffc0201e16 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc02010c6:	4515                	li	a0,5
ffffffffc02010c8:	511000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc02010cc:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc02010ce:	26050563          	beqz	a0,ffffffffc0201338 <default_check+0x402>
ffffffffc02010d2:	651c                	ld	a5,8(a0)
ffffffffc02010d4:	8385                	srli	a5,a5,0x1
ffffffffc02010d6:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc02010d8:	54079063          	bnez	a5,ffffffffc0201618 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc02010dc:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02010de:	00043b03          	ld	s6,0(s0)
ffffffffc02010e2:	00843a83          	ld	s5,8(s0)
ffffffffc02010e6:	e000                	sd	s0,0(s0)
ffffffffc02010e8:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc02010ea:	4ef000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc02010ee:	50051563          	bnez	a0,ffffffffc02015f8 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02010f2:	08098a13          	addi	s4,s3,128
ffffffffc02010f6:	8552                	mv	a0,s4
ffffffffc02010f8:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02010fa:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc02010fe:	000c2797          	auipc	a5,0xc2
ffffffffc0201102:	9807a123          	sw	zero,-1662(a5) # ffffffffc02c2a80 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201106:	511000ef          	jal	ra,ffffffffc0201e16 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc020110a:	4511                	li	a0,4
ffffffffc020110c:	4cd000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc0201110:	4c051463          	bnez	a0,ffffffffc02015d8 <default_check+0x6a2>
ffffffffc0201114:	0889b783          	ld	a5,136(s3)
ffffffffc0201118:	8385                	srli	a5,a5,0x1
ffffffffc020111a:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020111c:	48078e63          	beqz	a5,ffffffffc02015b8 <default_check+0x682>
ffffffffc0201120:	0909a703          	lw	a4,144(s3)
ffffffffc0201124:	478d                	li	a5,3
ffffffffc0201126:	48f71963          	bne	a4,a5,ffffffffc02015b8 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020112a:	450d                	li	a0,3
ffffffffc020112c:	4ad000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc0201130:	8c2a                	mv	s8,a0
ffffffffc0201132:	46050363          	beqz	a0,ffffffffc0201598 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0201136:	4505                	li	a0,1
ffffffffc0201138:	4a1000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc020113c:	42051e63          	bnez	a0,ffffffffc0201578 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0201140:	418a1c63          	bne	s4,s8,ffffffffc0201558 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201144:	4585                	li	a1,1
ffffffffc0201146:	854e                	mv	a0,s3
ffffffffc0201148:	4cf000ef          	jal	ra,ffffffffc0201e16 <free_pages>
    free_pages(p1, 3);
ffffffffc020114c:	458d                	li	a1,3
ffffffffc020114e:	8552                	mv	a0,s4
ffffffffc0201150:	4c7000ef          	jal	ra,ffffffffc0201e16 <free_pages>
ffffffffc0201154:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201158:	04098c13          	addi	s8,s3,64
ffffffffc020115c:	8385                	srli	a5,a5,0x1
ffffffffc020115e:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201160:	3c078c63          	beqz	a5,ffffffffc0201538 <default_check+0x602>
ffffffffc0201164:	0109a703          	lw	a4,16(s3)
ffffffffc0201168:	4785                	li	a5,1
ffffffffc020116a:	3cf71763          	bne	a4,a5,ffffffffc0201538 <default_check+0x602>
ffffffffc020116e:	008a3783          	ld	a5,8(s4)
ffffffffc0201172:	8385                	srli	a5,a5,0x1
ffffffffc0201174:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201176:	3a078163          	beqz	a5,ffffffffc0201518 <default_check+0x5e2>
ffffffffc020117a:	010a2703          	lw	a4,16(s4)
ffffffffc020117e:	478d                	li	a5,3
ffffffffc0201180:	38f71c63          	bne	a4,a5,ffffffffc0201518 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201184:	4505                	li	a0,1
ffffffffc0201186:	453000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc020118a:	36a99763          	bne	s3,a0,ffffffffc02014f8 <default_check+0x5c2>
    free_page(p0);
ffffffffc020118e:	4585                	li	a1,1
ffffffffc0201190:	487000ef          	jal	ra,ffffffffc0201e16 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201194:	4509                	li	a0,2
ffffffffc0201196:	443000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc020119a:	32aa1f63          	bne	s4,a0,ffffffffc02014d8 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc020119e:	4589                	li	a1,2
ffffffffc02011a0:	477000ef          	jal	ra,ffffffffc0201e16 <free_pages>
    free_page(p2);
ffffffffc02011a4:	4585                	li	a1,1
ffffffffc02011a6:	8562                	mv	a0,s8
ffffffffc02011a8:	46f000ef          	jal	ra,ffffffffc0201e16 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02011ac:	4515                	li	a0,5
ffffffffc02011ae:	42b000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc02011b2:	89aa                	mv	s3,a0
ffffffffc02011b4:	48050263          	beqz	a0,ffffffffc0201638 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc02011b8:	4505                	li	a0,1
ffffffffc02011ba:	41f000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc02011be:	2c051d63          	bnez	a0,ffffffffc0201498 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc02011c2:	481c                	lw	a5,16(s0)
ffffffffc02011c4:	2a079a63          	bnez	a5,ffffffffc0201478 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02011c8:	4595                	li	a1,5
ffffffffc02011ca:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc02011cc:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc02011d0:	01643023          	sd	s6,0(s0)
ffffffffc02011d4:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc02011d8:	43f000ef          	jal	ra,ffffffffc0201e16 <free_pages>
    return listelm->next;
ffffffffc02011dc:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02011de:	00878963          	beq	a5,s0,ffffffffc02011f0 <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc02011e2:	ff87a703          	lw	a4,-8(a5)
ffffffffc02011e6:	679c                	ld	a5,8(a5)
ffffffffc02011e8:	397d                	addiw	s2,s2,-1
ffffffffc02011ea:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02011ec:	fe879be3          	bne	a5,s0,ffffffffc02011e2 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02011f0:	26091463          	bnez	s2,ffffffffc0201458 <default_check+0x522>
    assert(total == 0);
ffffffffc02011f4:	46049263          	bnez	s1,ffffffffc0201658 <default_check+0x722>
}
ffffffffc02011f8:	60a6                	ld	ra,72(sp)
ffffffffc02011fa:	6406                	ld	s0,64(sp)
ffffffffc02011fc:	74e2                	ld	s1,56(sp)
ffffffffc02011fe:	7942                	ld	s2,48(sp)
ffffffffc0201200:	79a2                	ld	s3,40(sp)
ffffffffc0201202:	7a02                	ld	s4,32(sp)
ffffffffc0201204:	6ae2                	ld	s5,24(sp)
ffffffffc0201206:	6b42                	ld	s6,16(sp)
ffffffffc0201208:	6ba2                	ld	s7,8(sp)
ffffffffc020120a:	6c02                	ld	s8,0(sp)
ffffffffc020120c:	6161                	addi	sp,sp,80
ffffffffc020120e:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc0201210:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201212:	4481                	li	s1,0
ffffffffc0201214:	4901                	li	s2,0
ffffffffc0201216:	b38d                	j	ffffffffc0200f78 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201218:	00005697          	auipc	a3,0x5
ffffffffc020121c:	13068693          	addi	a3,a3,304 # ffffffffc0206348 <commands+0x818>
ffffffffc0201220:	00005617          	auipc	a2,0x5
ffffffffc0201224:	13860613          	addi	a2,a2,312 # ffffffffc0206358 <commands+0x828>
ffffffffc0201228:	11000593          	li	a1,272
ffffffffc020122c:	00005517          	auipc	a0,0x5
ffffffffc0201230:	14450513          	addi	a0,a0,324 # ffffffffc0206370 <commands+0x840>
ffffffffc0201234:	a5eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201238:	00005697          	auipc	a3,0x5
ffffffffc020123c:	1d068693          	addi	a3,a3,464 # ffffffffc0206408 <commands+0x8d8>
ffffffffc0201240:	00005617          	auipc	a2,0x5
ffffffffc0201244:	11860613          	addi	a2,a2,280 # ffffffffc0206358 <commands+0x828>
ffffffffc0201248:	0db00593          	li	a1,219
ffffffffc020124c:	00005517          	auipc	a0,0x5
ffffffffc0201250:	12450513          	addi	a0,a0,292 # ffffffffc0206370 <commands+0x840>
ffffffffc0201254:	a3eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201258:	00005697          	auipc	a3,0x5
ffffffffc020125c:	1d868693          	addi	a3,a3,472 # ffffffffc0206430 <commands+0x900>
ffffffffc0201260:	00005617          	auipc	a2,0x5
ffffffffc0201264:	0f860613          	addi	a2,a2,248 # ffffffffc0206358 <commands+0x828>
ffffffffc0201268:	0dc00593          	li	a1,220
ffffffffc020126c:	00005517          	auipc	a0,0x5
ffffffffc0201270:	10450513          	addi	a0,a0,260 # ffffffffc0206370 <commands+0x840>
ffffffffc0201274:	a1eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201278:	00005697          	auipc	a3,0x5
ffffffffc020127c:	1f868693          	addi	a3,a3,504 # ffffffffc0206470 <commands+0x940>
ffffffffc0201280:	00005617          	auipc	a2,0x5
ffffffffc0201284:	0d860613          	addi	a2,a2,216 # ffffffffc0206358 <commands+0x828>
ffffffffc0201288:	0de00593          	li	a1,222
ffffffffc020128c:	00005517          	auipc	a0,0x5
ffffffffc0201290:	0e450513          	addi	a0,a0,228 # ffffffffc0206370 <commands+0x840>
ffffffffc0201294:	9feff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201298:	00005697          	auipc	a3,0x5
ffffffffc020129c:	26068693          	addi	a3,a3,608 # ffffffffc02064f8 <commands+0x9c8>
ffffffffc02012a0:	00005617          	auipc	a2,0x5
ffffffffc02012a4:	0b860613          	addi	a2,a2,184 # ffffffffc0206358 <commands+0x828>
ffffffffc02012a8:	0f700593          	li	a1,247
ffffffffc02012ac:	00005517          	auipc	a0,0x5
ffffffffc02012b0:	0c450513          	addi	a0,a0,196 # ffffffffc0206370 <commands+0x840>
ffffffffc02012b4:	9deff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02012b8:	00005697          	auipc	a3,0x5
ffffffffc02012bc:	0f068693          	addi	a3,a3,240 # ffffffffc02063a8 <commands+0x878>
ffffffffc02012c0:	00005617          	auipc	a2,0x5
ffffffffc02012c4:	09860613          	addi	a2,a2,152 # ffffffffc0206358 <commands+0x828>
ffffffffc02012c8:	0f000593          	li	a1,240
ffffffffc02012cc:	00005517          	auipc	a0,0x5
ffffffffc02012d0:	0a450513          	addi	a0,a0,164 # ffffffffc0206370 <commands+0x840>
ffffffffc02012d4:	9beff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free == 3);
ffffffffc02012d8:	00005697          	auipc	a3,0x5
ffffffffc02012dc:	21068693          	addi	a3,a3,528 # ffffffffc02064e8 <commands+0x9b8>
ffffffffc02012e0:	00005617          	auipc	a2,0x5
ffffffffc02012e4:	07860613          	addi	a2,a2,120 # ffffffffc0206358 <commands+0x828>
ffffffffc02012e8:	0ee00593          	li	a1,238
ffffffffc02012ec:	00005517          	auipc	a0,0x5
ffffffffc02012f0:	08450513          	addi	a0,a0,132 # ffffffffc0206370 <commands+0x840>
ffffffffc02012f4:	99eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012f8:	00005697          	auipc	a3,0x5
ffffffffc02012fc:	1d868693          	addi	a3,a3,472 # ffffffffc02064d0 <commands+0x9a0>
ffffffffc0201300:	00005617          	auipc	a2,0x5
ffffffffc0201304:	05860613          	addi	a2,a2,88 # ffffffffc0206358 <commands+0x828>
ffffffffc0201308:	0e900593          	li	a1,233
ffffffffc020130c:	00005517          	auipc	a0,0x5
ffffffffc0201310:	06450513          	addi	a0,a0,100 # ffffffffc0206370 <commands+0x840>
ffffffffc0201314:	97eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201318:	00005697          	auipc	a3,0x5
ffffffffc020131c:	19868693          	addi	a3,a3,408 # ffffffffc02064b0 <commands+0x980>
ffffffffc0201320:	00005617          	auipc	a2,0x5
ffffffffc0201324:	03860613          	addi	a2,a2,56 # ffffffffc0206358 <commands+0x828>
ffffffffc0201328:	0e000593          	li	a1,224
ffffffffc020132c:	00005517          	auipc	a0,0x5
ffffffffc0201330:	04450513          	addi	a0,a0,68 # ffffffffc0206370 <commands+0x840>
ffffffffc0201334:	95eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(p0 != NULL);
ffffffffc0201338:	00005697          	auipc	a3,0x5
ffffffffc020133c:	20868693          	addi	a3,a3,520 # ffffffffc0206540 <commands+0xa10>
ffffffffc0201340:	00005617          	auipc	a2,0x5
ffffffffc0201344:	01860613          	addi	a2,a2,24 # ffffffffc0206358 <commands+0x828>
ffffffffc0201348:	11800593          	li	a1,280
ffffffffc020134c:	00005517          	auipc	a0,0x5
ffffffffc0201350:	02450513          	addi	a0,a0,36 # ffffffffc0206370 <commands+0x840>
ffffffffc0201354:	93eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free == 0);
ffffffffc0201358:	00005697          	auipc	a3,0x5
ffffffffc020135c:	1d868693          	addi	a3,a3,472 # ffffffffc0206530 <commands+0xa00>
ffffffffc0201360:	00005617          	auipc	a2,0x5
ffffffffc0201364:	ff860613          	addi	a2,a2,-8 # ffffffffc0206358 <commands+0x828>
ffffffffc0201368:	0fd00593          	li	a1,253
ffffffffc020136c:	00005517          	auipc	a0,0x5
ffffffffc0201370:	00450513          	addi	a0,a0,4 # ffffffffc0206370 <commands+0x840>
ffffffffc0201374:	91eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201378:	00005697          	auipc	a3,0x5
ffffffffc020137c:	15868693          	addi	a3,a3,344 # ffffffffc02064d0 <commands+0x9a0>
ffffffffc0201380:	00005617          	auipc	a2,0x5
ffffffffc0201384:	fd860613          	addi	a2,a2,-40 # ffffffffc0206358 <commands+0x828>
ffffffffc0201388:	0fb00593          	li	a1,251
ffffffffc020138c:	00005517          	auipc	a0,0x5
ffffffffc0201390:	fe450513          	addi	a0,a0,-28 # ffffffffc0206370 <commands+0x840>
ffffffffc0201394:	8feff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201398:	00005697          	auipc	a3,0x5
ffffffffc020139c:	17868693          	addi	a3,a3,376 # ffffffffc0206510 <commands+0x9e0>
ffffffffc02013a0:	00005617          	auipc	a2,0x5
ffffffffc02013a4:	fb860613          	addi	a2,a2,-72 # ffffffffc0206358 <commands+0x828>
ffffffffc02013a8:	0fa00593          	li	a1,250
ffffffffc02013ac:	00005517          	auipc	a0,0x5
ffffffffc02013b0:	fc450513          	addi	a0,a0,-60 # ffffffffc0206370 <commands+0x840>
ffffffffc02013b4:	8deff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02013b8:	00005697          	auipc	a3,0x5
ffffffffc02013bc:	ff068693          	addi	a3,a3,-16 # ffffffffc02063a8 <commands+0x878>
ffffffffc02013c0:	00005617          	auipc	a2,0x5
ffffffffc02013c4:	f9860613          	addi	a2,a2,-104 # ffffffffc0206358 <commands+0x828>
ffffffffc02013c8:	0d700593          	li	a1,215
ffffffffc02013cc:	00005517          	auipc	a0,0x5
ffffffffc02013d0:	fa450513          	addi	a0,a0,-92 # ffffffffc0206370 <commands+0x840>
ffffffffc02013d4:	8beff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013d8:	00005697          	auipc	a3,0x5
ffffffffc02013dc:	0f868693          	addi	a3,a3,248 # ffffffffc02064d0 <commands+0x9a0>
ffffffffc02013e0:	00005617          	auipc	a2,0x5
ffffffffc02013e4:	f7860613          	addi	a2,a2,-136 # ffffffffc0206358 <commands+0x828>
ffffffffc02013e8:	0f400593          	li	a1,244
ffffffffc02013ec:	00005517          	auipc	a0,0x5
ffffffffc02013f0:	f8450513          	addi	a0,a0,-124 # ffffffffc0206370 <commands+0x840>
ffffffffc02013f4:	89eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02013f8:	00005697          	auipc	a3,0x5
ffffffffc02013fc:	ff068693          	addi	a3,a3,-16 # ffffffffc02063e8 <commands+0x8b8>
ffffffffc0201400:	00005617          	auipc	a2,0x5
ffffffffc0201404:	f5860613          	addi	a2,a2,-168 # ffffffffc0206358 <commands+0x828>
ffffffffc0201408:	0f200593          	li	a1,242
ffffffffc020140c:	00005517          	auipc	a0,0x5
ffffffffc0201410:	f6450513          	addi	a0,a0,-156 # ffffffffc0206370 <commands+0x840>
ffffffffc0201414:	87eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201418:	00005697          	auipc	a3,0x5
ffffffffc020141c:	fb068693          	addi	a3,a3,-80 # ffffffffc02063c8 <commands+0x898>
ffffffffc0201420:	00005617          	auipc	a2,0x5
ffffffffc0201424:	f3860613          	addi	a2,a2,-200 # ffffffffc0206358 <commands+0x828>
ffffffffc0201428:	0f100593          	li	a1,241
ffffffffc020142c:	00005517          	auipc	a0,0x5
ffffffffc0201430:	f4450513          	addi	a0,a0,-188 # ffffffffc0206370 <commands+0x840>
ffffffffc0201434:	85eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201438:	00005697          	auipc	a3,0x5
ffffffffc020143c:	fb068693          	addi	a3,a3,-80 # ffffffffc02063e8 <commands+0x8b8>
ffffffffc0201440:	00005617          	auipc	a2,0x5
ffffffffc0201444:	f1860613          	addi	a2,a2,-232 # ffffffffc0206358 <commands+0x828>
ffffffffc0201448:	0d900593          	li	a1,217
ffffffffc020144c:	00005517          	auipc	a0,0x5
ffffffffc0201450:	f2450513          	addi	a0,a0,-220 # ffffffffc0206370 <commands+0x840>
ffffffffc0201454:	83eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(count == 0);
ffffffffc0201458:	00005697          	auipc	a3,0x5
ffffffffc020145c:	23868693          	addi	a3,a3,568 # ffffffffc0206690 <commands+0xb60>
ffffffffc0201460:	00005617          	auipc	a2,0x5
ffffffffc0201464:	ef860613          	addi	a2,a2,-264 # ffffffffc0206358 <commands+0x828>
ffffffffc0201468:	14600593          	li	a1,326
ffffffffc020146c:	00005517          	auipc	a0,0x5
ffffffffc0201470:	f0450513          	addi	a0,a0,-252 # ffffffffc0206370 <commands+0x840>
ffffffffc0201474:	81eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free == 0);
ffffffffc0201478:	00005697          	auipc	a3,0x5
ffffffffc020147c:	0b868693          	addi	a3,a3,184 # ffffffffc0206530 <commands+0xa00>
ffffffffc0201480:	00005617          	auipc	a2,0x5
ffffffffc0201484:	ed860613          	addi	a2,a2,-296 # ffffffffc0206358 <commands+0x828>
ffffffffc0201488:	13a00593          	li	a1,314
ffffffffc020148c:	00005517          	auipc	a0,0x5
ffffffffc0201490:	ee450513          	addi	a0,a0,-284 # ffffffffc0206370 <commands+0x840>
ffffffffc0201494:	ffffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201498:	00005697          	auipc	a3,0x5
ffffffffc020149c:	03868693          	addi	a3,a3,56 # ffffffffc02064d0 <commands+0x9a0>
ffffffffc02014a0:	00005617          	auipc	a2,0x5
ffffffffc02014a4:	eb860613          	addi	a2,a2,-328 # ffffffffc0206358 <commands+0x828>
ffffffffc02014a8:	13800593          	li	a1,312
ffffffffc02014ac:	00005517          	auipc	a0,0x5
ffffffffc02014b0:	ec450513          	addi	a0,a0,-316 # ffffffffc0206370 <commands+0x840>
ffffffffc02014b4:	fdffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02014b8:	00005697          	auipc	a3,0x5
ffffffffc02014bc:	fd868693          	addi	a3,a3,-40 # ffffffffc0206490 <commands+0x960>
ffffffffc02014c0:	00005617          	auipc	a2,0x5
ffffffffc02014c4:	e9860613          	addi	a2,a2,-360 # ffffffffc0206358 <commands+0x828>
ffffffffc02014c8:	0df00593          	li	a1,223
ffffffffc02014cc:	00005517          	auipc	a0,0x5
ffffffffc02014d0:	ea450513          	addi	a0,a0,-348 # ffffffffc0206370 <commands+0x840>
ffffffffc02014d4:	fbffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02014d8:	00005697          	auipc	a3,0x5
ffffffffc02014dc:	17868693          	addi	a3,a3,376 # ffffffffc0206650 <commands+0xb20>
ffffffffc02014e0:	00005617          	auipc	a2,0x5
ffffffffc02014e4:	e7860613          	addi	a2,a2,-392 # ffffffffc0206358 <commands+0x828>
ffffffffc02014e8:	13200593          	li	a1,306
ffffffffc02014ec:	00005517          	auipc	a0,0x5
ffffffffc02014f0:	e8450513          	addi	a0,a0,-380 # ffffffffc0206370 <commands+0x840>
ffffffffc02014f4:	f9ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02014f8:	00005697          	auipc	a3,0x5
ffffffffc02014fc:	13868693          	addi	a3,a3,312 # ffffffffc0206630 <commands+0xb00>
ffffffffc0201500:	00005617          	auipc	a2,0x5
ffffffffc0201504:	e5860613          	addi	a2,a2,-424 # ffffffffc0206358 <commands+0x828>
ffffffffc0201508:	13000593          	li	a1,304
ffffffffc020150c:	00005517          	auipc	a0,0x5
ffffffffc0201510:	e6450513          	addi	a0,a0,-412 # ffffffffc0206370 <commands+0x840>
ffffffffc0201514:	f7ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201518:	00005697          	auipc	a3,0x5
ffffffffc020151c:	0f068693          	addi	a3,a3,240 # ffffffffc0206608 <commands+0xad8>
ffffffffc0201520:	00005617          	auipc	a2,0x5
ffffffffc0201524:	e3860613          	addi	a2,a2,-456 # ffffffffc0206358 <commands+0x828>
ffffffffc0201528:	12e00593          	li	a1,302
ffffffffc020152c:	00005517          	auipc	a0,0x5
ffffffffc0201530:	e4450513          	addi	a0,a0,-444 # ffffffffc0206370 <commands+0x840>
ffffffffc0201534:	f5ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201538:	00005697          	auipc	a3,0x5
ffffffffc020153c:	0a868693          	addi	a3,a3,168 # ffffffffc02065e0 <commands+0xab0>
ffffffffc0201540:	00005617          	auipc	a2,0x5
ffffffffc0201544:	e1860613          	addi	a2,a2,-488 # ffffffffc0206358 <commands+0x828>
ffffffffc0201548:	12d00593          	li	a1,301
ffffffffc020154c:	00005517          	auipc	a0,0x5
ffffffffc0201550:	e2450513          	addi	a0,a0,-476 # ffffffffc0206370 <commands+0x840>
ffffffffc0201554:	f3ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201558:	00005697          	auipc	a3,0x5
ffffffffc020155c:	07868693          	addi	a3,a3,120 # ffffffffc02065d0 <commands+0xaa0>
ffffffffc0201560:	00005617          	auipc	a2,0x5
ffffffffc0201564:	df860613          	addi	a2,a2,-520 # ffffffffc0206358 <commands+0x828>
ffffffffc0201568:	12800593          	li	a1,296
ffffffffc020156c:	00005517          	auipc	a0,0x5
ffffffffc0201570:	e0450513          	addi	a0,a0,-508 # ffffffffc0206370 <commands+0x840>
ffffffffc0201574:	f1ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201578:	00005697          	auipc	a3,0x5
ffffffffc020157c:	f5868693          	addi	a3,a3,-168 # ffffffffc02064d0 <commands+0x9a0>
ffffffffc0201580:	00005617          	auipc	a2,0x5
ffffffffc0201584:	dd860613          	addi	a2,a2,-552 # ffffffffc0206358 <commands+0x828>
ffffffffc0201588:	12700593          	li	a1,295
ffffffffc020158c:	00005517          	auipc	a0,0x5
ffffffffc0201590:	de450513          	addi	a0,a0,-540 # ffffffffc0206370 <commands+0x840>
ffffffffc0201594:	efffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201598:	00005697          	auipc	a3,0x5
ffffffffc020159c:	01868693          	addi	a3,a3,24 # ffffffffc02065b0 <commands+0xa80>
ffffffffc02015a0:	00005617          	auipc	a2,0x5
ffffffffc02015a4:	db860613          	addi	a2,a2,-584 # ffffffffc0206358 <commands+0x828>
ffffffffc02015a8:	12600593          	li	a1,294
ffffffffc02015ac:	00005517          	auipc	a0,0x5
ffffffffc02015b0:	dc450513          	addi	a0,a0,-572 # ffffffffc0206370 <commands+0x840>
ffffffffc02015b4:	edffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02015b8:	00005697          	auipc	a3,0x5
ffffffffc02015bc:	fc868693          	addi	a3,a3,-56 # ffffffffc0206580 <commands+0xa50>
ffffffffc02015c0:	00005617          	auipc	a2,0x5
ffffffffc02015c4:	d9860613          	addi	a2,a2,-616 # ffffffffc0206358 <commands+0x828>
ffffffffc02015c8:	12500593          	li	a1,293
ffffffffc02015cc:	00005517          	auipc	a0,0x5
ffffffffc02015d0:	da450513          	addi	a0,a0,-604 # ffffffffc0206370 <commands+0x840>
ffffffffc02015d4:	ebffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02015d8:	00005697          	auipc	a3,0x5
ffffffffc02015dc:	f9068693          	addi	a3,a3,-112 # ffffffffc0206568 <commands+0xa38>
ffffffffc02015e0:	00005617          	auipc	a2,0x5
ffffffffc02015e4:	d7860613          	addi	a2,a2,-648 # ffffffffc0206358 <commands+0x828>
ffffffffc02015e8:	12400593          	li	a1,292
ffffffffc02015ec:	00005517          	auipc	a0,0x5
ffffffffc02015f0:	d8450513          	addi	a0,a0,-636 # ffffffffc0206370 <commands+0x840>
ffffffffc02015f4:	e9ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02015f8:	00005697          	auipc	a3,0x5
ffffffffc02015fc:	ed868693          	addi	a3,a3,-296 # ffffffffc02064d0 <commands+0x9a0>
ffffffffc0201600:	00005617          	auipc	a2,0x5
ffffffffc0201604:	d5860613          	addi	a2,a2,-680 # ffffffffc0206358 <commands+0x828>
ffffffffc0201608:	11e00593          	li	a1,286
ffffffffc020160c:	00005517          	auipc	a0,0x5
ffffffffc0201610:	d6450513          	addi	a0,a0,-668 # ffffffffc0206370 <commands+0x840>
ffffffffc0201614:	e7ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201618:	00005697          	auipc	a3,0x5
ffffffffc020161c:	f3868693          	addi	a3,a3,-200 # ffffffffc0206550 <commands+0xa20>
ffffffffc0201620:	00005617          	auipc	a2,0x5
ffffffffc0201624:	d3860613          	addi	a2,a2,-712 # ffffffffc0206358 <commands+0x828>
ffffffffc0201628:	11900593          	li	a1,281
ffffffffc020162c:	00005517          	auipc	a0,0x5
ffffffffc0201630:	d4450513          	addi	a0,a0,-700 # ffffffffc0206370 <commands+0x840>
ffffffffc0201634:	e5ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201638:	00005697          	auipc	a3,0x5
ffffffffc020163c:	03868693          	addi	a3,a3,56 # ffffffffc0206670 <commands+0xb40>
ffffffffc0201640:	00005617          	auipc	a2,0x5
ffffffffc0201644:	d1860613          	addi	a2,a2,-744 # ffffffffc0206358 <commands+0x828>
ffffffffc0201648:	13700593          	li	a1,311
ffffffffc020164c:	00005517          	auipc	a0,0x5
ffffffffc0201650:	d2450513          	addi	a0,a0,-732 # ffffffffc0206370 <commands+0x840>
ffffffffc0201654:	e3ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(total == 0);
ffffffffc0201658:	00005697          	auipc	a3,0x5
ffffffffc020165c:	04868693          	addi	a3,a3,72 # ffffffffc02066a0 <commands+0xb70>
ffffffffc0201660:	00005617          	auipc	a2,0x5
ffffffffc0201664:	cf860613          	addi	a2,a2,-776 # ffffffffc0206358 <commands+0x828>
ffffffffc0201668:	14700593          	li	a1,327
ffffffffc020166c:	00005517          	auipc	a0,0x5
ffffffffc0201670:	d0450513          	addi	a0,a0,-764 # ffffffffc0206370 <commands+0x840>
ffffffffc0201674:	e1ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(total == nr_free_pages());
ffffffffc0201678:	00005697          	auipc	a3,0x5
ffffffffc020167c:	d1068693          	addi	a3,a3,-752 # ffffffffc0206388 <commands+0x858>
ffffffffc0201680:	00005617          	auipc	a2,0x5
ffffffffc0201684:	cd860613          	addi	a2,a2,-808 # ffffffffc0206358 <commands+0x828>
ffffffffc0201688:	11300593          	li	a1,275
ffffffffc020168c:	00005517          	auipc	a0,0x5
ffffffffc0201690:	ce450513          	addi	a0,a0,-796 # ffffffffc0206370 <commands+0x840>
ffffffffc0201694:	dfffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201698:	00005697          	auipc	a3,0x5
ffffffffc020169c:	d3068693          	addi	a3,a3,-720 # ffffffffc02063c8 <commands+0x898>
ffffffffc02016a0:	00005617          	auipc	a2,0x5
ffffffffc02016a4:	cb860613          	addi	a2,a2,-840 # ffffffffc0206358 <commands+0x828>
ffffffffc02016a8:	0d800593          	li	a1,216
ffffffffc02016ac:	00005517          	auipc	a0,0x5
ffffffffc02016b0:	cc450513          	addi	a0,a0,-828 # ffffffffc0206370 <commands+0x840>
ffffffffc02016b4:	ddffe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02016b8 <default_free_pages>:
{
ffffffffc02016b8:	1141                	addi	sp,sp,-16
ffffffffc02016ba:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02016bc:	14058463          	beqz	a1,ffffffffc0201804 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc02016c0:	00659693          	slli	a3,a1,0x6
ffffffffc02016c4:	96aa                	add	a3,a3,a0
ffffffffc02016c6:	87aa                	mv	a5,a0
ffffffffc02016c8:	02d50263          	beq	a0,a3,ffffffffc02016ec <default_free_pages+0x34>
ffffffffc02016cc:	6798                	ld	a4,8(a5)
ffffffffc02016ce:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02016d0:	10071a63          	bnez	a4,ffffffffc02017e4 <default_free_pages+0x12c>
ffffffffc02016d4:	6798                	ld	a4,8(a5)
ffffffffc02016d6:	8b09                	andi	a4,a4,2
ffffffffc02016d8:	10071663          	bnez	a4,ffffffffc02017e4 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc02016dc:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02016e0:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02016e4:	04078793          	addi	a5,a5,64
ffffffffc02016e8:	fed792e3          	bne	a5,a3,ffffffffc02016cc <default_free_pages+0x14>
    base->property = n;
ffffffffc02016ec:	2581                	sext.w	a1,a1
ffffffffc02016ee:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02016f0:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02016f4:	4789                	li	a5,2
ffffffffc02016f6:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02016fa:	000c1697          	auipc	a3,0xc1
ffffffffc02016fe:	37668693          	addi	a3,a3,886 # ffffffffc02c2a70 <free_area>
ffffffffc0201702:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201704:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201706:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc020170a:	9db9                	addw	a1,a1,a4
ffffffffc020170c:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc020170e:	0ad78463          	beq	a5,a3,ffffffffc02017b6 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc0201712:	fe878713          	addi	a4,a5,-24
ffffffffc0201716:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc020171a:	4581                	li	a1,0
            if (base < page)
ffffffffc020171c:	00e56a63          	bltu	a0,a4,ffffffffc0201730 <default_free_pages+0x78>
    return listelm->next;
ffffffffc0201720:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201722:	04d70c63          	beq	a4,a3,ffffffffc020177a <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc0201726:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201728:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc020172c:	fee57ae3          	bgeu	a0,a4,ffffffffc0201720 <default_free_pages+0x68>
ffffffffc0201730:	c199                	beqz	a1,ffffffffc0201736 <default_free_pages+0x7e>
ffffffffc0201732:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201736:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201738:	e390                	sd	a2,0(a5)
ffffffffc020173a:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc020173c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020173e:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc0201740:	00d70d63          	beq	a4,a3,ffffffffc020175a <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc0201744:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201748:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc020174c:	02059813          	slli	a6,a1,0x20
ffffffffc0201750:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201754:	97b2                	add	a5,a5,a2
ffffffffc0201756:	02f50c63          	beq	a0,a5,ffffffffc020178e <default_free_pages+0xd6>
    return listelm->next;
ffffffffc020175a:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc020175c:	00d78c63          	beq	a5,a3,ffffffffc0201774 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0201760:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201762:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201766:	02061593          	slli	a1,a2,0x20
ffffffffc020176a:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020176e:	972a                	add	a4,a4,a0
ffffffffc0201770:	04e68a63          	beq	a3,a4,ffffffffc02017c4 <default_free_pages+0x10c>
}
ffffffffc0201774:	60a2                	ld	ra,8(sp)
ffffffffc0201776:	0141                	addi	sp,sp,16
ffffffffc0201778:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020177a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020177c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020177e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201780:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201782:	02d70763          	beq	a4,a3,ffffffffc02017b0 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201786:	8832                	mv	a6,a2
ffffffffc0201788:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc020178a:	87ba                	mv	a5,a4
ffffffffc020178c:	bf71                	j	ffffffffc0201728 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020178e:	491c                	lw	a5,16(a0)
ffffffffc0201790:	9dbd                	addw	a1,a1,a5
ffffffffc0201792:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201796:	57f5                	li	a5,-3
ffffffffc0201798:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020179c:	01853803          	ld	a6,24(a0)
ffffffffc02017a0:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc02017a2:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02017a4:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc02017a8:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc02017aa:	0105b023          	sd	a6,0(a1)
ffffffffc02017ae:	b77d                	j	ffffffffc020175c <default_free_pages+0xa4>
ffffffffc02017b0:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc02017b2:	873e                	mv	a4,a5
ffffffffc02017b4:	bf41                	j	ffffffffc0201744 <default_free_pages+0x8c>
}
ffffffffc02017b6:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02017b8:	e390                	sd	a2,0(a5)
ffffffffc02017ba:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02017bc:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02017be:	ed1c                	sd	a5,24(a0)
ffffffffc02017c0:	0141                	addi	sp,sp,16
ffffffffc02017c2:	8082                	ret
            base->property += p->property;
ffffffffc02017c4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02017c8:	ff078693          	addi	a3,a5,-16
ffffffffc02017cc:	9e39                	addw	a2,a2,a4
ffffffffc02017ce:	c910                	sw	a2,16(a0)
ffffffffc02017d0:	5775                	li	a4,-3
ffffffffc02017d2:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02017d6:	6398                	ld	a4,0(a5)
ffffffffc02017d8:	679c                	ld	a5,8(a5)
}
ffffffffc02017da:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02017dc:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02017de:	e398                	sd	a4,0(a5)
ffffffffc02017e0:	0141                	addi	sp,sp,16
ffffffffc02017e2:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02017e4:	00005697          	auipc	a3,0x5
ffffffffc02017e8:	ed468693          	addi	a3,a3,-300 # ffffffffc02066b8 <commands+0xb88>
ffffffffc02017ec:	00005617          	auipc	a2,0x5
ffffffffc02017f0:	b6c60613          	addi	a2,a2,-1172 # ffffffffc0206358 <commands+0x828>
ffffffffc02017f4:	09400593          	li	a1,148
ffffffffc02017f8:	00005517          	auipc	a0,0x5
ffffffffc02017fc:	b7850513          	addi	a0,a0,-1160 # ffffffffc0206370 <commands+0x840>
ffffffffc0201800:	c93fe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(n > 0);
ffffffffc0201804:	00005697          	auipc	a3,0x5
ffffffffc0201808:	eac68693          	addi	a3,a3,-340 # ffffffffc02066b0 <commands+0xb80>
ffffffffc020180c:	00005617          	auipc	a2,0x5
ffffffffc0201810:	b4c60613          	addi	a2,a2,-1204 # ffffffffc0206358 <commands+0x828>
ffffffffc0201814:	09000593          	li	a1,144
ffffffffc0201818:	00005517          	auipc	a0,0x5
ffffffffc020181c:	b5850513          	addi	a0,a0,-1192 # ffffffffc0206370 <commands+0x840>
ffffffffc0201820:	c73fe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201824 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201824:	c941                	beqz	a0,ffffffffc02018b4 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc0201826:	000c1597          	auipc	a1,0xc1
ffffffffc020182a:	24a58593          	addi	a1,a1,586 # ffffffffc02c2a70 <free_area>
ffffffffc020182e:	0105a803          	lw	a6,16(a1)
ffffffffc0201832:	872a                	mv	a4,a0
ffffffffc0201834:	02081793          	slli	a5,a6,0x20
ffffffffc0201838:	9381                	srli	a5,a5,0x20
ffffffffc020183a:	00a7ee63          	bltu	a5,a0,ffffffffc0201856 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc020183e:	87ae                	mv	a5,a1
ffffffffc0201840:	a801                	j	ffffffffc0201850 <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc0201842:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201846:	02069613          	slli	a2,a3,0x20
ffffffffc020184a:	9201                	srli	a2,a2,0x20
ffffffffc020184c:	00e67763          	bgeu	a2,a4,ffffffffc020185a <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201850:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201852:	feb798e3          	bne	a5,a1,ffffffffc0201842 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201856:	4501                	li	a0,0
}
ffffffffc0201858:	8082                	ret
    return listelm->prev;
ffffffffc020185a:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020185e:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201862:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201866:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc020186a:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc020186e:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc0201872:	02c77863          	bgeu	a4,a2,ffffffffc02018a2 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201876:	071a                	slli	a4,a4,0x6
ffffffffc0201878:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc020187a:	41c686bb          	subw	a3,a3,t3
ffffffffc020187e:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201880:	00870613          	addi	a2,a4,8
ffffffffc0201884:	4689                	li	a3,2
ffffffffc0201886:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc020188a:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc020188e:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201892:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201896:	e290                	sd	a2,0(a3)
ffffffffc0201898:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc020189c:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc020189e:	01173c23          	sd	a7,24(a4)
ffffffffc02018a2:	41c8083b          	subw	a6,a6,t3
ffffffffc02018a6:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02018aa:	5775                	li	a4,-3
ffffffffc02018ac:	17c1                	addi	a5,a5,-16
ffffffffc02018ae:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02018b2:	8082                	ret
{
ffffffffc02018b4:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02018b6:	00005697          	auipc	a3,0x5
ffffffffc02018ba:	dfa68693          	addi	a3,a3,-518 # ffffffffc02066b0 <commands+0xb80>
ffffffffc02018be:	00005617          	auipc	a2,0x5
ffffffffc02018c2:	a9a60613          	addi	a2,a2,-1382 # ffffffffc0206358 <commands+0x828>
ffffffffc02018c6:	06c00593          	li	a1,108
ffffffffc02018ca:	00005517          	auipc	a0,0x5
ffffffffc02018ce:	aa650513          	addi	a0,a0,-1370 # ffffffffc0206370 <commands+0x840>
{
ffffffffc02018d2:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02018d4:	bbffe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02018d8 <default_init_memmap>:
{
ffffffffc02018d8:	1141                	addi	sp,sp,-16
ffffffffc02018da:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02018dc:	c5f1                	beqz	a1,ffffffffc02019a8 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc02018de:	00659693          	slli	a3,a1,0x6
ffffffffc02018e2:	96aa                	add	a3,a3,a0
ffffffffc02018e4:	87aa                	mv	a5,a0
ffffffffc02018e6:	00d50f63          	beq	a0,a3,ffffffffc0201904 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02018ea:	6798                	ld	a4,8(a5)
ffffffffc02018ec:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc02018ee:	cf49                	beqz	a4,ffffffffc0201988 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02018f0:	0007a823          	sw	zero,16(a5)
ffffffffc02018f4:	0007b423          	sd	zero,8(a5)
ffffffffc02018f8:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02018fc:	04078793          	addi	a5,a5,64
ffffffffc0201900:	fed795e3          	bne	a5,a3,ffffffffc02018ea <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201904:	2581                	sext.w	a1,a1
ffffffffc0201906:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201908:	4789                	li	a5,2
ffffffffc020190a:	00850713          	addi	a4,a0,8
ffffffffc020190e:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201912:	000c1697          	auipc	a3,0xc1
ffffffffc0201916:	15e68693          	addi	a3,a3,350 # ffffffffc02c2a70 <free_area>
ffffffffc020191a:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020191c:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020191e:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201922:	9db9                	addw	a1,a1,a4
ffffffffc0201924:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201926:	04d78a63          	beq	a5,a3,ffffffffc020197a <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc020192a:	fe878713          	addi	a4,a5,-24
ffffffffc020192e:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201932:	4581                	li	a1,0
            if (base < page)
ffffffffc0201934:	00e56a63          	bltu	a0,a4,ffffffffc0201948 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201938:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc020193a:	02d70263          	beq	a4,a3,ffffffffc020195e <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc020193e:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201940:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201944:	fee57ae3          	bgeu	a0,a4,ffffffffc0201938 <default_init_memmap+0x60>
ffffffffc0201948:	c199                	beqz	a1,ffffffffc020194e <default_init_memmap+0x76>
ffffffffc020194a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020194e:	6398                	ld	a4,0(a5)
}
ffffffffc0201950:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201952:	e390                	sd	a2,0(a5)
ffffffffc0201954:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201956:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201958:	ed18                	sd	a4,24(a0)
ffffffffc020195a:	0141                	addi	sp,sp,16
ffffffffc020195c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020195e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201960:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201962:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201964:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201966:	00d70663          	beq	a4,a3,ffffffffc0201972 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc020196a:	8832                	mv	a6,a2
ffffffffc020196c:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc020196e:	87ba                	mv	a5,a4
ffffffffc0201970:	bfc1                	j	ffffffffc0201940 <default_init_memmap+0x68>
}
ffffffffc0201972:	60a2                	ld	ra,8(sp)
ffffffffc0201974:	e290                	sd	a2,0(a3)
ffffffffc0201976:	0141                	addi	sp,sp,16
ffffffffc0201978:	8082                	ret
ffffffffc020197a:	60a2                	ld	ra,8(sp)
ffffffffc020197c:	e390                	sd	a2,0(a5)
ffffffffc020197e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201980:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201982:	ed1c                	sd	a5,24(a0)
ffffffffc0201984:	0141                	addi	sp,sp,16
ffffffffc0201986:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201988:	00005697          	auipc	a3,0x5
ffffffffc020198c:	d5868693          	addi	a3,a3,-680 # ffffffffc02066e0 <commands+0xbb0>
ffffffffc0201990:	00005617          	auipc	a2,0x5
ffffffffc0201994:	9c860613          	addi	a2,a2,-1592 # ffffffffc0206358 <commands+0x828>
ffffffffc0201998:	04b00593          	li	a1,75
ffffffffc020199c:	00005517          	auipc	a0,0x5
ffffffffc02019a0:	9d450513          	addi	a0,a0,-1580 # ffffffffc0206370 <commands+0x840>
ffffffffc02019a4:	aeffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(n > 0);
ffffffffc02019a8:	00005697          	auipc	a3,0x5
ffffffffc02019ac:	d0868693          	addi	a3,a3,-760 # ffffffffc02066b0 <commands+0xb80>
ffffffffc02019b0:	00005617          	auipc	a2,0x5
ffffffffc02019b4:	9a860613          	addi	a2,a2,-1624 # ffffffffc0206358 <commands+0x828>
ffffffffc02019b8:	04700593          	li	a1,71
ffffffffc02019bc:	00005517          	auipc	a0,0x5
ffffffffc02019c0:	9b450513          	addi	a0,a0,-1612 # ffffffffc0206370 <commands+0x840>
ffffffffc02019c4:	acffe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02019c8 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc02019c8:	c94d                	beqz	a0,ffffffffc0201a7a <slob_free+0xb2>
{
ffffffffc02019ca:	1141                	addi	sp,sp,-16
ffffffffc02019cc:	e022                	sd	s0,0(sp)
ffffffffc02019ce:	e406                	sd	ra,8(sp)
ffffffffc02019d0:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc02019d2:	e9c1                	bnez	a1,ffffffffc0201a62 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02019d4:	100027f3          	csrr	a5,sstatus
ffffffffc02019d8:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02019da:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02019dc:	ebd9                	bnez	a5,ffffffffc0201a72 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02019de:	000c1617          	auipc	a2,0xc1
ffffffffc02019e2:	c8260613          	addi	a2,a2,-894 # ffffffffc02c2660 <slobfree>
ffffffffc02019e6:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019e8:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02019ea:	679c                	ld	a5,8(a5)
ffffffffc02019ec:	02877a63          	bgeu	a4,s0,ffffffffc0201a20 <slob_free+0x58>
ffffffffc02019f0:	00f46463          	bltu	s0,a5,ffffffffc02019f8 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019f4:	fef76ae3          	bltu	a4,a5,ffffffffc02019e8 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc02019f8:	400c                	lw	a1,0(s0)
ffffffffc02019fa:	00459693          	slli	a3,a1,0x4
ffffffffc02019fe:	96a2                	add	a3,a3,s0
ffffffffc0201a00:	02d78a63          	beq	a5,a3,ffffffffc0201a34 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201a04:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201a06:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201a08:	00469793          	slli	a5,a3,0x4
ffffffffc0201a0c:	97ba                	add	a5,a5,a4
ffffffffc0201a0e:	02f40e63          	beq	s0,a5,ffffffffc0201a4a <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201a12:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201a14:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201a16:	e129                	bnez	a0,ffffffffc0201a58 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201a18:	60a2                	ld	ra,8(sp)
ffffffffc0201a1a:	6402                	ld	s0,0(sp)
ffffffffc0201a1c:	0141                	addi	sp,sp,16
ffffffffc0201a1e:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201a20:	fcf764e3          	bltu	a4,a5,ffffffffc02019e8 <slob_free+0x20>
ffffffffc0201a24:	fcf472e3          	bgeu	s0,a5,ffffffffc02019e8 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201a28:	400c                	lw	a1,0(s0)
ffffffffc0201a2a:	00459693          	slli	a3,a1,0x4
ffffffffc0201a2e:	96a2                	add	a3,a3,s0
ffffffffc0201a30:	fcd79ae3          	bne	a5,a3,ffffffffc0201a04 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201a34:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201a36:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201a38:	9db5                	addw	a1,a1,a3
ffffffffc0201a3a:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201a3c:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201a3e:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201a40:	00469793          	slli	a5,a3,0x4
ffffffffc0201a44:	97ba                	add	a5,a5,a4
ffffffffc0201a46:	fcf416e3          	bne	s0,a5,ffffffffc0201a12 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201a4a:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201a4c:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201a4e:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201a50:	9ebd                	addw	a3,a3,a5
ffffffffc0201a52:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201a54:	e70c                	sd	a1,8(a4)
ffffffffc0201a56:	d169                	beqz	a0,ffffffffc0201a18 <slob_free+0x50>
}
ffffffffc0201a58:	6402                	ld	s0,0(sp)
ffffffffc0201a5a:	60a2                	ld	ra,8(sp)
ffffffffc0201a5c:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201a5e:	f4bfe06f          	j	ffffffffc02009a8 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201a62:	25bd                	addiw	a1,a1,15
ffffffffc0201a64:	8191                	srli	a1,a1,0x4
ffffffffc0201a66:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a68:	100027f3          	csrr	a5,sstatus
ffffffffc0201a6c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201a6e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a70:	d7bd                	beqz	a5,ffffffffc02019de <slob_free+0x16>
        intr_disable();
ffffffffc0201a72:	f3dfe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc0201a76:	4505                	li	a0,1
ffffffffc0201a78:	b79d                	j	ffffffffc02019de <slob_free+0x16>
ffffffffc0201a7a:	8082                	ret

ffffffffc0201a7c <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a7c:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201a7e:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a80:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201a84:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a86:	352000ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
	if (!page)
ffffffffc0201a8a:	c91d                	beqz	a0,ffffffffc0201ac0 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201a8c:	000c5697          	auipc	a3,0xc5
ffffffffc0201a90:	0846b683          	ld	a3,132(a3) # ffffffffc02c6b10 <pages>
ffffffffc0201a94:	8d15                	sub	a0,a0,a3
ffffffffc0201a96:	8519                	srai	a0,a0,0x6
ffffffffc0201a98:	00006697          	auipc	a3,0x6
ffffffffc0201a9c:	6e06b683          	ld	a3,1760(a3) # ffffffffc0208178 <nbase>
ffffffffc0201aa0:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201aa2:	00c51793          	slli	a5,a0,0xc
ffffffffc0201aa6:	83b1                	srli	a5,a5,0xc
ffffffffc0201aa8:	000c5717          	auipc	a4,0xc5
ffffffffc0201aac:	06073703          	ld	a4,96(a4) # ffffffffc02c6b08 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201ab0:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201ab2:	00e7fa63          	bgeu	a5,a4,ffffffffc0201ac6 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201ab6:	000c5697          	auipc	a3,0xc5
ffffffffc0201aba:	06a6b683          	ld	a3,106(a3) # ffffffffc02c6b20 <va_pa_offset>
ffffffffc0201abe:	9536                	add	a0,a0,a3
}
ffffffffc0201ac0:	60a2                	ld	ra,8(sp)
ffffffffc0201ac2:	0141                	addi	sp,sp,16
ffffffffc0201ac4:	8082                	ret
ffffffffc0201ac6:	86aa                	mv	a3,a0
ffffffffc0201ac8:	00005617          	auipc	a2,0x5
ffffffffc0201acc:	c7860613          	addi	a2,a2,-904 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc0201ad0:	07100593          	li	a1,113
ffffffffc0201ad4:	00005517          	auipc	a0,0x5
ffffffffc0201ad8:	c9450513          	addi	a0,a0,-876 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc0201adc:	9b7fe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201ae0 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201ae0:	1101                	addi	sp,sp,-32
ffffffffc0201ae2:	ec06                	sd	ra,24(sp)
ffffffffc0201ae4:	e822                	sd	s0,16(sp)
ffffffffc0201ae6:	e426                	sd	s1,8(sp)
ffffffffc0201ae8:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201aea:	01050713          	addi	a4,a0,16
ffffffffc0201aee:	6785                	lui	a5,0x1
ffffffffc0201af0:	0cf77363          	bgeu	a4,a5,ffffffffc0201bb6 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201af4:	00f50493          	addi	s1,a0,15
ffffffffc0201af8:	8091                	srli	s1,s1,0x4
ffffffffc0201afa:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201afc:	10002673          	csrr	a2,sstatus
ffffffffc0201b00:	8a09                	andi	a2,a2,2
ffffffffc0201b02:	e25d                	bnez	a2,ffffffffc0201ba8 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201b04:	000c1917          	auipc	s2,0xc1
ffffffffc0201b08:	b5c90913          	addi	s2,s2,-1188 # ffffffffc02c2660 <slobfree>
ffffffffc0201b0c:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b10:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201b12:	4398                	lw	a4,0(a5)
ffffffffc0201b14:	08975e63          	bge	a4,s1,ffffffffc0201bb0 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201b18:	00f68b63          	beq	a3,a5,ffffffffc0201b2e <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b1c:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201b1e:	4018                	lw	a4,0(s0)
ffffffffc0201b20:	02975a63          	bge	a4,s1,ffffffffc0201b54 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201b24:	00093683          	ld	a3,0(s2)
ffffffffc0201b28:	87a2                	mv	a5,s0
ffffffffc0201b2a:	fef699e3          	bne	a3,a5,ffffffffc0201b1c <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201b2e:	ee31                	bnez	a2,ffffffffc0201b8a <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201b30:	4501                	li	a0,0
ffffffffc0201b32:	f4bff0ef          	jal	ra,ffffffffc0201a7c <__slob_get_free_pages.constprop.0>
ffffffffc0201b36:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201b38:	cd05                	beqz	a0,ffffffffc0201b70 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201b3a:	6585                	lui	a1,0x1
ffffffffc0201b3c:	e8dff0ef          	jal	ra,ffffffffc02019c8 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b40:	10002673          	csrr	a2,sstatus
ffffffffc0201b44:	8a09                	andi	a2,a2,2
ffffffffc0201b46:	ee05                	bnez	a2,ffffffffc0201b7e <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201b48:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b4c:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201b4e:	4018                	lw	a4,0(s0)
ffffffffc0201b50:	fc974ae3          	blt	a4,s1,ffffffffc0201b24 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201b54:	04e48763          	beq	s1,a4,ffffffffc0201ba2 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201b58:	00449693          	slli	a3,s1,0x4
ffffffffc0201b5c:	96a2                	add	a3,a3,s0
ffffffffc0201b5e:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201b60:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201b62:	9f05                	subw	a4,a4,s1
ffffffffc0201b64:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201b66:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201b68:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201b6a:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201b6e:	e20d                	bnez	a2,ffffffffc0201b90 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201b70:	60e2                	ld	ra,24(sp)
ffffffffc0201b72:	8522                	mv	a0,s0
ffffffffc0201b74:	6442                	ld	s0,16(sp)
ffffffffc0201b76:	64a2                	ld	s1,8(sp)
ffffffffc0201b78:	6902                	ld	s2,0(sp)
ffffffffc0201b7a:	6105                	addi	sp,sp,32
ffffffffc0201b7c:	8082                	ret
        intr_disable();
ffffffffc0201b7e:	e31fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
			cur = slobfree;
ffffffffc0201b82:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201b86:	4605                	li	a2,1
ffffffffc0201b88:	b7d1                	j	ffffffffc0201b4c <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201b8a:	e1ffe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0201b8e:	b74d                	j	ffffffffc0201b30 <slob_alloc.constprop.0+0x50>
ffffffffc0201b90:	e19fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
}
ffffffffc0201b94:	60e2                	ld	ra,24(sp)
ffffffffc0201b96:	8522                	mv	a0,s0
ffffffffc0201b98:	6442                	ld	s0,16(sp)
ffffffffc0201b9a:	64a2                	ld	s1,8(sp)
ffffffffc0201b9c:	6902                	ld	s2,0(sp)
ffffffffc0201b9e:	6105                	addi	sp,sp,32
ffffffffc0201ba0:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201ba2:	6418                	ld	a4,8(s0)
ffffffffc0201ba4:	e798                	sd	a4,8(a5)
ffffffffc0201ba6:	b7d1                	j	ffffffffc0201b6a <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201ba8:	e07fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc0201bac:	4605                	li	a2,1
ffffffffc0201bae:	bf99                	j	ffffffffc0201b04 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201bb0:	843e                	mv	s0,a5
ffffffffc0201bb2:	87b6                	mv	a5,a3
ffffffffc0201bb4:	b745                	j	ffffffffc0201b54 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201bb6:	00005697          	auipc	a3,0x5
ffffffffc0201bba:	bc268693          	addi	a3,a3,-1086 # ffffffffc0206778 <default_pmm_manager+0x70>
ffffffffc0201bbe:	00004617          	auipc	a2,0x4
ffffffffc0201bc2:	79a60613          	addi	a2,a2,1946 # ffffffffc0206358 <commands+0x828>
ffffffffc0201bc6:	06300593          	li	a1,99
ffffffffc0201bca:	00005517          	auipc	a0,0x5
ffffffffc0201bce:	bce50513          	addi	a0,a0,-1074 # ffffffffc0206798 <default_pmm_manager+0x90>
ffffffffc0201bd2:	8c1fe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201bd6 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201bd6:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201bd8:	00005517          	auipc	a0,0x5
ffffffffc0201bdc:	bd850513          	addi	a0,a0,-1064 # ffffffffc02067b0 <default_pmm_manager+0xa8>
{
ffffffffc0201be0:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201be2:	db6fe0ef          	jal	ra,ffffffffc0200198 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201be6:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201be8:	00005517          	auipc	a0,0x5
ffffffffc0201bec:	be050513          	addi	a0,a0,-1056 # ffffffffc02067c8 <default_pmm_manager+0xc0>
}
ffffffffc0201bf0:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201bf2:	da6fe06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0201bf6 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201bf6:	4501                	li	a0,0
ffffffffc0201bf8:	8082                	ret

ffffffffc0201bfa <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201bfa:	1101                	addi	sp,sp,-32
ffffffffc0201bfc:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201bfe:	6905                	lui	s2,0x1
{
ffffffffc0201c00:	e822                	sd	s0,16(sp)
ffffffffc0201c02:	ec06                	sd	ra,24(sp)
ffffffffc0201c04:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201c06:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8f41>
{
ffffffffc0201c0a:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201c0c:	04a7f963          	bgeu	a5,a0,ffffffffc0201c5e <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201c10:	4561                	li	a0,24
ffffffffc0201c12:	ecfff0ef          	jal	ra,ffffffffc0201ae0 <slob_alloc.constprop.0>
ffffffffc0201c16:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201c18:	c929                	beqz	a0,ffffffffc0201c6a <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201c1a:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201c1e:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201c20:	00f95763          	bge	s2,a5,ffffffffc0201c2e <kmalloc+0x34>
ffffffffc0201c24:	6705                	lui	a4,0x1
ffffffffc0201c26:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201c28:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201c2a:	fef74ee3          	blt	a4,a5,ffffffffc0201c26 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201c2e:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201c30:	e4dff0ef          	jal	ra,ffffffffc0201a7c <__slob_get_free_pages.constprop.0>
ffffffffc0201c34:	e488                	sd	a0,8(s1)
ffffffffc0201c36:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201c38:	c525                	beqz	a0,ffffffffc0201ca0 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c3a:	100027f3          	csrr	a5,sstatus
ffffffffc0201c3e:	8b89                	andi	a5,a5,2
ffffffffc0201c40:	ef8d                	bnez	a5,ffffffffc0201c7a <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201c42:	000c5797          	auipc	a5,0xc5
ffffffffc0201c46:	eae78793          	addi	a5,a5,-338 # ffffffffc02c6af0 <bigblocks>
ffffffffc0201c4a:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201c4c:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201c4e:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201c50:	60e2                	ld	ra,24(sp)
ffffffffc0201c52:	8522                	mv	a0,s0
ffffffffc0201c54:	6442                	ld	s0,16(sp)
ffffffffc0201c56:	64a2                	ld	s1,8(sp)
ffffffffc0201c58:	6902                	ld	s2,0(sp)
ffffffffc0201c5a:	6105                	addi	sp,sp,32
ffffffffc0201c5c:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201c5e:	0541                	addi	a0,a0,16
ffffffffc0201c60:	e81ff0ef          	jal	ra,ffffffffc0201ae0 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201c64:	01050413          	addi	s0,a0,16
ffffffffc0201c68:	f565                	bnez	a0,ffffffffc0201c50 <kmalloc+0x56>
ffffffffc0201c6a:	4401                	li	s0,0
}
ffffffffc0201c6c:	60e2                	ld	ra,24(sp)
ffffffffc0201c6e:	8522                	mv	a0,s0
ffffffffc0201c70:	6442                	ld	s0,16(sp)
ffffffffc0201c72:	64a2                	ld	s1,8(sp)
ffffffffc0201c74:	6902                	ld	s2,0(sp)
ffffffffc0201c76:	6105                	addi	sp,sp,32
ffffffffc0201c78:	8082                	ret
        intr_disable();
ffffffffc0201c7a:	d35fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
		bb->next = bigblocks;
ffffffffc0201c7e:	000c5797          	auipc	a5,0xc5
ffffffffc0201c82:	e7278793          	addi	a5,a5,-398 # ffffffffc02c6af0 <bigblocks>
ffffffffc0201c86:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201c88:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201c8a:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201c8c:	d1dfe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
		return bb->pages;
ffffffffc0201c90:	6480                	ld	s0,8(s1)
}
ffffffffc0201c92:	60e2                	ld	ra,24(sp)
ffffffffc0201c94:	64a2                	ld	s1,8(sp)
ffffffffc0201c96:	8522                	mv	a0,s0
ffffffffc0201c98:	6442                	ld	s0,16(sp)
ffffffffc0201c9a:	6902                	ld	s2,0(sp)
ffffffffc0201c9c:	6105                	addi	sp,sp,32
ffffffffc0201c9e:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201ca0:	45e1                	li	a1,24
ffffffffc0201ca2:	8526                	mv	a0,s1
ffffffffc0201ca4:	d25ff0ef          	jal	ra,ffffffffc02019c8 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201ca8:	b765                	j	ffffffffc0201c50 <kmalloc+0x56>

ffffffffc0201caa <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201caa:	c169                	beqz	a0,ffffffffc0201d6c <kfree+0xc2>
{
ffffffffc0201cac:	1101                	addi	sp,sp,-32
ffffffffc0201cae:	e822                	sd	s0,16(sp)
ffffffffc0201cb0:	ec06                	sd	ra,24(sp)
ffffffffc0201cb2:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201cb4:	03451793          	slli	a5,a0,0x34
ffffffffc0201cb8:	842a                	mv	s0,a0
ffffffffc0201cba:	e3d9                	bnez	a5,ffffffffc0201d40 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201cbc:	100027f3          	csrr	a5,sstatus
ffffffffc0201cc0:	8b89                	andi	a5,a5,2
ffffffffc0201cc2:	e7d9                	bnez	a5,ffffffffc0201d50 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201cc4:	000c5797          	auipc	a5,0xc5
ffffffffc0201cc8:	e2c7b783          	ld	a5,-468(a5) # ffffffffc02c6af0 <bigblocks>
    return 0;
ffffffffc0201ccc:	4601                	li	a2,0
ffffffffc0201cce:	cbad                	beqz	a5,ffffffffc0201d40 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201cd0:	000c5697          	auipc	a3,0xc5
ffffffffc0201cd4:	e2068693          	addi	a3,a3,-480 # ffffffffc02c6af0 <bigblocks>
ffffffffc0201cd8:	a021                	j	ffffffffc0201ce0 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201cda:	01048693          	addi	a3,s1,16
ffffffffc0201cde:	c3a5                	beqz	a5,ffffffffc0201d3e <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201ce0:	6798                	ld	a4,8(a5)
ffffffffc0201ce2:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201ce4:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201ce6:	fe871ae3          	bne	a4,s0,ffffffffc0201cda <kfree+0x30>
				*last = bb->next;
ffffffffc0201cea:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201cec:	ee2d                	bnez	a2,ffffffffc0201d66 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201cee:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201cf2:	4098                	lw	a4,0(s1)
ffffffffc0201cf4:	08f46963          	bltu	s0,a5,ffffffffc0201d86 <kfree+0xdc>
ffffffffc0201cf8:	000c5697          	auipc	a3,0xc5
ffffffffc0201cfc:	e286b683          	ld	a3,-472(a3) # ffffffffc02c6b20 <va_pa_offset>
ffffffffc0201d00:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201d02:	8031                	srli	s0,s0,0xc
ffffffffc0201d04:	000c5797          	auipc	a5,0xc5
ffffffffc0201d08:	e047b783          	ld	a5,-508(a5) # ffffffffc02c6b08 <npage>
ffffffffc0201d0c:	06f47163          	bgeu	s0,a5,ffffffffc0201d6e <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201d10:	00006517          	auipc	a0,0x6
ffffffffc0201d14:	46853503          	ld	a0,1128(a0) # ffffffffc0208178 <nbase>
ffffffffc0201d18:	8c09                	sub	s0,s0,a0
ffffffffc0201d1a:	041a                	slli	s0,s0,0x6
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201d1c:	000c5517          	auipc	a0,0xc5
ffffffffc0201d20:	df453503          	ld	a0,-524(a0) # ffffffffc02c6b10 <pages>
ffffffffc0201d24:	4585                	li	a1,1
ffffffffc0201d26:	9522                	add	a0,a0,s0
ffffffffc0201d28:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201d2c:	0ea000ef          	jal	ra,ffffffffc0201e16 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201d30:	6442                	ld	s0,16(sp)
ffffffffc0201d32:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d34:	8526                	mv	a0,s1
}
ffffffffc0201d36:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d38:	45e1                	li	a1,24
}
ffffffffc0201d3a:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201d3c:	b171                	j	ffffffffc02019c8 <slob_free>
ffffffffc0201d3e:	e20d                	bnez	a2,ffffffffc0201d60 <kfree+0xb6>
ffffffffc0201d40:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201d44:	6442                	ld	s0,16(sp)
ffffffffc0201d46:	60e2                	ld	ra,24(sp)
ffffffffc0201d48:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201d4a:	4581                	li	a1,0
}
ffffffffc0201d4c:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201d4e:	b9ad                	j	ffffffffc02019c8 <slob_free>
        intr_disable();
ffffffffc0201d50:	c5ffe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d54:	000c5797          	auipc	a5,0xc5
ffffffffc0201d58:	d9c7b783          	ld	a5,-612(a5) # ffffffffc02c6af0 <bigblocks>
        return 1;
ffffffffc0201d5c:	4605                	li	a2,1
ffffffffc0201d5e:	fbad                	bnez	a5,ffffffffc0201cd0 <kfree+0x26>
        intr_enable();
ffffffffc0201d60:	c49fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0201d64:	bff1                	j	ffffffffc0201d40 <kfree+0x96>
ffffffffc0201d66:	c43fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0201d6a:	b751                	j	ffffffffc0201cee <kfree+0x44>
ffffffffc0201d6c:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201d6e:	00005617          	auipc	a2,0x5
ffffffffc0201d72:	aa260613          	addi	a2,a2,-1374 # ffffffffc0206810 <default_pmm_manager+0x108>
ffffffffc0201d76:	06900593          	li	a1,105
ffffffffc0201d7a:	00005517          	auipc	a0,0x5
ffffffffc0201d7e:	9ee50513          	addi	a0,a0,-1554 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc0201d82:	f10fe0ef          	jal	ra,ffffffffc0200492 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201d86:	86a2                	mv	a3,s0
ffffffffc0201d88:	00005617          	auipc	a2,0x5
ffffffffc0201d8c:	a6060613          	addi	a2,a2,-1440 # ffffffffc02067e8 <default_pmm_manager+0xe0>
ffffffffc0201d90:	07700593          	li	a1,119
ffffffffc0201d94:	00005517          	auipc	a0,0x5
ffffffffc0201d98:	9d450513          	addi	a0,a0,-1580 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc0201d9c:	ef6fe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201da0 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201da0:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201da2:	00005617          	auipc	a2,0x5
ffffffffc0201da6:	a6e60613          	addi	a2,a2,-1426 # ffffffffc0206810 <default_pmm_manager+0x108>
ffffffffc0201daa:	06900593          	li	a1,105
ffffffffc0201dae:	00005517          	auipc	a0,0x5
ffffffffc0201db2:	9ba50513          	addi	a0,a0,-1606 # ffffffffc0206768 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201db6:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201db8:	edafe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201dbc <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201dbc:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201dbe:	00005617          	auipc	a2,0x5
ffffffffc0201dc2:	a7260613          	addi	a2,a2,-1422 # ffffffffc0206830 <default_pmm_manager+0x128>
ffffffffc0201dc6:	07f00593          	li	a1,127
ffffffffc0201dca:	00005517          	auipc	a0,0x5
ffffffffc0201dce:	99e50513          	addi	a0,a0,-1634 # ffffffffc0206768 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201dd2:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201dd4:	ebefe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201dd8 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201dd8:	100027f3          	csrr	a5,sstatus
ffffffffc0201ddc:	8b89                	andi	a5,a5,2
ffffffffc0201dde:	e799                	bnez	a5,ffffffffc0201dec <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201de0:	000c5797          	auipc	a5,0xc5
ffffffffc0201de4:	d387b783          	ld	a5,-712(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc0201de8:	6f9c                	ld	a5,24(a5)
ffffffffc0201dea:	8782                	jr	a5
{
ffffffffc0201dec:	1141                	addi	sp,sp,-16
ffffffffc0201dee:	e406                	sd	ra,8(sp)
ffffffffc0201df0:	e022                	sd	s0,0(sp)
ffffffffc0201df2:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201df4:	bbbfe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201df8:	000c5797          	auipc	a5,0xc5
ffffffffc0201dfc:	d207b783          	ld	a5,-736(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc0201e00:	6f9c                	ld	a5,24(a5)
ffffffffc0201e02:	8522                	mv	a0,s0
ffffffffc0201e04:	9782                	jalr	a5
ffffffffc0201e06:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201e08:	ba1fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201e0c:	60a2                	ld	ra,8(sp)
ffffffffc0201e0e:	8522                	mv	a0,s0
ffffffffc0201e10:	6402                	ld	s0,0(sp)
ffffffffc0201e12:	0141                	addi	sp,sp,16
ffffffffc0201e14:	8082                	ret

ffffffffc0201e16 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e16:	100027f3          	csrr	a5,sstatus
ffffffffc0201e1a:	8b89                	andi	a5,a5,2
ffffffffc0201e1c:	e799                	bnez	a5,ffffffffc0201e2a <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201e1e:	000c5797          	auipc	a5,0xc5
ffffffffc0201e22:	cfa7b783          	ld	a5,-774(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc0201e26:	739c                	ld	a5,32(a5)
ffffffffc0201e28:	8782                	jr	a5
{
ffffffffc0201e2a:	1101                	addi	sp,sp,-32
ffffffffc0201e2c:	ec06                	sd	ra,24(sp)
ffffffffc0201e2e:	e822                	sd	s0,16(sp)
ffffffffc0201e30:	e426                	sd	s1,8(sp)
ffffffffc0201e32:	842a                	mv	s0,a0
ffffffffc0201e34:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201e36:	b79fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201e3a:	000c5797          	auipc	a5,0xc5
ffffffffc0201e3e:	cde7b783          	ld	a5,-802(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc0201e42:	739c                	ld	a5,32(a5)
ffffffffc0201e44:	85a6                	mv	a1,s1
ffffffffc0201e46:	8522                	mv	a0,s0
ffffffffc0201e48:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201e4a:	6442                	ld	s0,16(sp)
ffffffffc0201e4c:	60e2                	ld	ra,24(sp)
ffffffffc0201e4e:	64a2                	ld	s1,8(sp)
ffffffffc0201e50:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201e52:	b57fe06f          	j	ffffffffc02009a8 <intr_enable>

ffffffffc0201e56 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e56:	100027f3          	csrr	a5,sstatus
ffffffffc0201e5a:	8b89                	andi	a5,a5,2
ffffffffc0201e5c:	e799                	bnez	a5,ffffffffc0201e6a <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201e5e:	000c5797          	auipc	a5,0xc5
ffffffffc0201e62:	cba7b783          	ld	a5,-838(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc0201e66:	779c                	ld	a5,40(a5)
ffffffffc0201e68:	8782                	jr	a5
{
ffffffffc0201e6a:	1141                	addi	sp,sp,-16
ffffffffc0201e6c:	e406                	sd	ra,8(sp)
ffffffffc0201e6e:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201e70:	b3ffe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201e74:	000c5797          	auipc	a5,0xc5
ffffffffc0201e78:	ca47b783          	ld	a5,-860(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc0201e7c:	779c                	ld	a5,40(a5)
ffffffffc0201e7e:	9782                	jalr	a5
ffffffffc0201e80:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201e82:	b27fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201e86:	60a2                	ld	ra,8(sp)
ffffffffc0201e88:	8522                	mv	a0,s0
ffffffffc0201e8a:	6402                	ld	s0,0(sp)
ffffffffc0201e8c:	0141                	addi	sp,sp,16
ffffffffc0201e8e:	8082                	ret

ffffffffc0201e90 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e90:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201e94:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201e98:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e9a:	078e                	slli	a5,a5,0x3
{
ffffffffc0201e9c:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e9e:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201ea2:	6094                	ld	a3,0(s1)
{
ffffffffc0201ea4:	f04a                	sd	s2,32(sp)
ffffffffc0201ea6:	ec4e                	sd	s3,24(sp)
ffffffffc0201ea8:	e852                	sd	s4,16(sp)
ffffffffc0201eaa:	fc06                	sd	ra,56(sp)
ffffffffc0201eac:	f822                	sd	s0,48(sp)
ffffffffc0201eae:	e456                	sd	s5,8(sp)
ffffffffc0201eb0:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201eb2:	0016f793          	andi	a5,a3,1
{
ffffffffc0201eb6:	892e                	mv	s2,a1
ffffffffc0201eb8:	8a32                	mv	s4,a2
ffffffffc0201eba:	000c5997          	auipc	s3,0xc5
ffffffffc0201ebe:	c4e98993          	addi	s3,s3,-946 # ffffffffc02c6b08 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201ec2:	efbd                	bnez	a5,ffffffffc0201f40 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201ec4:	14060c63          	beqz	a2,ffffffffc020201c <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ec8:	100027f3          	csrr	a5,sstatus
ffffffffc0201ecc:	8b89                	andi	a5,a5,2
ffffffffc0201ece:	14079963          	bnez	a5,ffffffffc0202020 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ed2:	000c5797          	auipc	a5,0xc5
ffffffffc0201ed6:	c467b783          	ld	a5,-954(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc0201eda:	6f9c                	ld	a5,24(a5)
ffffffffc0201edc:	4505                	li	a0,1
ffffffffc0201ede:	9782                	jalr	a5
ffffffffc0201ee0:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201ee2:	12040d63          	beqz	s0,ffffffffc020201c <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201ee6:	000c5b17          	auipc	s6,0xc5
ffffffffc0201eea:	c2ab0b13          	addi	s6,s6,-982 # ffffffffc02c6b10 <pages>
ffffffffc0201eee:	000b3503          	ld	a0,0(s6)
ffffffffc0201ef2:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201ef6:	000c5997          	auipc	s3,0xc5
ffffffffc0201efa:	c1298993          	addi	s3,s3,-1006 # ffffffffc02c6b08 <npage>
ffffffffc0201efe:	40a40533          	sub	a0,s0,a0
ffffffffc0201f02:	8519                	srai	a0,a0,0x6
ffffffffc0201f04:	9556                	add	a0,a0,s5
ffffffffc0201f06:	0009b703          	ld	a4,0(s3)
ffffffffc0201f0a:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201f0e:	4685                	li	a3,1
ffffffffc0201f10:	c014                	sw	a3,0(s0)
ffffffffc0201f12:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201f14:	0532                	slli	a0,a0,0xc
ffffffffc0201f16:	16e7f763          	bgeu	a5,a4,ffffffffc0202084 <get_pte+0x1f4>
ffffffffc0201f1a:	000c5797          	auipc	a5,0xc5
ffffffffc0201f1e:	c067b783          	ld	a5,-1018(a5) # ffffffffc02c6b20 <va_pa_offset>
ffffffffc0201f22:	6605                	lui	a2,0x1
ffffffffc0201f24:	4581                	li	a1,0
ffffffffc0201f26:	953e                	add	a0,a0,a5
ffffffffc0201f28:	173030ef          	jal	ra,ffffffffc020589a <memset>
    return page - pages + nbase;
ffffffffc0201f2c:	000b3683          	ld	a3,0(s6)
ffffffffc0201f30:	40d406b3          	sub	a3,s0,a3
ffffffffc0201f34:	8699                	srai	a3,a3,0x6
ffffffffc0201f36:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201f38:	06aa                	slli	a3,a3,0xa
ffffffffc0201f3a:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201f3e:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201f40:	77fd                	lui	a5,0xfffff
ffffffffc0201f42:	068a                	slli	a3,a3,0x2
ffffffffc0201f44:	0009b703          	ld	a4,0(s3)
ffffffffc0201f48:	8efd                	and	a3,a3,a5
ffffffffc0201f4a:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201f4e:	10e7ff63          	bgeu	a5,a4,ffffffffc020206c <get_pte+0x1dc>
ffffffffc0201f52:	000c5a97          	auipc	s5,0xc5
ffffffffc0201f56:	bcea8a93          	addi	s5,s5,-1074 # ffffffffc02c6b20 <va_pa_offset>
ffffffffc0201f5a:	000ab403          	ld	s0,0(s5)
ffffffffc0201f5e:	01595793          	srli	a5,s2,0x15
ffffffffc0201f62:	1ff7f793          	andi	a5,a5,511
ffffffffc0201f66:	96a2                	add	a3,a3,s0
ffffffffc0201f68:	00379413          	slli	s0,a5,0x3
ffffffffc0201f6c:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0201f6e:	6014                	ld	a3,0(s0)
ffffffffc0201f70:	0016f793          	andi	a5,a3,1
ffffffffc0201f74:	ebad                	bnez	a5,ffffffffc0201fe6 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f76:	0a0a0363          	beqz	s4,ffffffffc020201c <get_pte+0x18c>
ffffffffc0201f7a:	100027f3          	csrr	a5,sstatus
ffffffffc0201f7e:	8b89                	andi	a5,a5,2
ffffffffc0201f80:	efcd                	bnez	a5,ffffffffc020203a <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f82:	000c5797          	auipc	a5,0xc5
ffffffffc0201f86:	b967b783          	ld	a5,-1130(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc0201f8a:	6f9c                	ld	a5,24(a5)
ffffffffc0201f8c:	4505                	li	a0,1
ffffffffc0201f8e:	9782                	jalr	a5
ffffffffc0201f90:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f92:	c4c9                	beqz	s1,ffffffffc020201c <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201f94:	000c5b17          	auipc	s6,0xc5
ffffffffc0201f98:	b7cb0b13          	addi	s6,s6,-1156 # ffffffffc02c6b10 <pages>
ffffffffc0201f9c:	000b3503          	ld	a0,0(s6)
ffffffffc0201fa0:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201fa4:	0009b703          	ld	a4,0(s3)
ffffffffc0201fa8:	40a48533          	sub	a0,s1,a0
ffffffffc0201fac:	8519                	srai	a0,a0,0x6
ffffffffc0201fae:	9552                	add	a0,a0,s4
ffffffffc0201fb0:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201fb4:	4685                	li	a3,1
ffffffffc0201fb6:	c094                	sw	a3,0(s1)
ffffffffc0201fb8:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201fba:	0532                	slli	a0,a0,0xc
ffffffffc0201fbc:	0ee7f163          	bgeu	a5,a4,ffffffffc020209e <get_pte+0x20e>
ffffffffc0201fc0:	000ab783          	ld	a5,0(s5)
ffffffffc0201fc4:	6605                	lui	a2,0x1
ffffffffc0201fc6:	4581                	li	a1,0
ffffffffc0201fc8:	953e                	add	a0,a0,a5
ffffffffc0201fca:	0d1030ef          	jal	ra,ffffffffc020589a <memset>
    return page - pages + nbase;
ffffffffc0201fce:	000b3683          	ld	a3,0(s6)
ffffffffc0201fd2:	40d486b3          	sub	a3,s1,a3
ffffffffc0201fd6:	8699                	srai	a3,a3,0x6
ffffffffc0201fd8:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201fda:	06aa                	slli	a3,a3,0xa
ffffffffc0201fdc:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201fe0:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201fe2:	0009b703          	ld	a4,0(s3)
ffffffffc0201fe6:	068a                	slli	a3,a3,0x2
ffffffffc0201fe8:	757d                	lui	a0,0xfffff
ffffffffc0201fea:	8ee9                	and	a3,a3,a0
ffffffffc0201fec:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201ff0:	06e7f263          	bgeu	a5,a4,ffffffffc0202054 <get_pte+0x1c4>
ffffffffc0201ff4:	000ab503          	ld	a0,0(s5)
ffffffffc0201ff8:	00c95913          	srli	s2,s2,0xc
ffffffffc0201ffc:	1ff97913          	andi	s2,s2,511
ffffffffc0202000:	96aa                	add	a3,a3,a0
ffffffffc0202002:	00391513          	slli	a0,s2,0x3
ffffffffc0202006:	9536                	add	a0,a0,a3
}
ffffffffc0202008:	70e2                	ld	ra,56(sp)
ffffffffc020200a:	7442                	ld	s0,48(sp)
ffffffffc020200c:	74a2                	ld	s1,40(sp)
ffffffffc020200e:	7902                	ld	s2,32(sp)
ffffffffc0202010:	69e2                	ld	s3,24(sp)
ffffffffc0202012:	6a42                	ld	s4,16(sp)
ffffffffc0202014:	6aa2                	ld	s5,8(sp)
ffffffffc0202016:	6b02                	ld	s6,0(sp)
ffffffffc0202018:	6121                	addi	sp,sp,64
ffffffffc020201a:	8082                	ret
            return NULL;
ffffffffc020201c:	4501                	li	a0,0
ffffffffc020201e:	b7ed                	j	ffffffffc0202008 <get_pte+0x178>
        intr_disable();
ffffffffc0202020:	98ffe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202024:	000c5797          	auipc	a5,0xc5
ffffffffc0202028:	af47b783          	ld	a5,-1292(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc020202c:	6f9c                	ld	a5,24(a5)
ffffffffc020202e:	4505                	li	a0,1
ffffffffc0202030:	9782                	jalr	a5
ffffffffc0202032:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202034:	975fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202038:	b56d                	j	ffffffffc0201ee2 <get_pte+0x52>
        intr_disable();
ffffffffc020203a:	975fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc020203e:	000c5797          	auipc	a5,0xc5
ffffffffc0202042:	ada7b783          	ld	a5,-1318(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc0202046:	6f9c                	ld	a5,24(a5)
ffffffffc0202048:	4505                	li	a0,1
ffffffffc020204a:	9782                	jalr	a5
ffffffffc020204c:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc020204e:	95bfe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202052:	b781                	j	ffffffffc0201f92 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202054:	00004617          	auipc	a2,0x4
ffffffffc0202058:	6ec60613          	addi	a2,a2,1772 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc020205c:	0fa00593          	li	a1,250
ffffffffc0202060:	00004517          	auipc	a0,0x4
ffffffffc0202064:	7f850513          	addi	a0,a0,2040 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202068:	c2afe0ef          	jal	ra,ffffffffc0200492 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020206c:	00004617          	auipc	a2,0x4
ffffffffc0202070:	6d460613          	addi	a2,a2,1748 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc0202074:	0ed00593          	li	a1,237
ffffffffc0202078:	00004517          	auipc	a0,0x4
ffffffffc020207c:	7e050513          	addi	a0,a0,2016 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202080:	c12fe0ef          	jal	ra,ffffffffc0200492 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202084:	86aa                	mv	a3,a0
ffffffffc0202086:	00004617          	auipc	a2,0x4
ffffffffc020208a:	6ba60613          	addi	a2,a2,1722 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc020208e:	0e900593          	li	a1,233
ffffffffc0202092:	00004517          	auipc	a0,0x4
ffffffffc0202096:	7c650513          	addi	a0,a0,1990 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc020209a:	bf8fe0ef          	jal	ra,ffffffffc0200492 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020209e:	86aa                	mv	a3,a0
ffffffffc02020a0:	00004617          	auipc	a2,0x4
ffffffffc02020a4:	6a060613          	addi	a2,a2,1696 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc02020a8:	0f700593          	li	a1,247
ffffffffc02020ac:	00004517          	auipc	a0,0x4
ffffffffc02020b0:	7ac50513          	addi	a0,a0,1964 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc02020b4:	bdefe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02020b8 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc02020b8:	1141                	addi	sp,sp,-16
ffffffffc02020ba:	e022                	sd	s0,0(sp)
ffffffffc02020bc:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02020be:	4601                	li	a2,0
{
ffffffffc02020c0:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02020c2:	dcfff0ef          	jal	ra,ffffffffc0201e90 <get_pte>
    if (ptep_store != NULL)
ffffffffc02020c6:	c011                	beqz	s0,ffffffffc02020ca <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc02020c8:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02020ca:	c511                	beqz	a0,ffffffffc02020d6 <get_page+0x1e>
ffffffffc02020cc:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc02020ce:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02020d0:	0017f713          	andi	a4,a5,1
ffffffffc02020d4:	e709                	bnez	a4,ffffffffc02020de <get_page+0x26>
}
ffffffffc02020d6:	60a2                	ld	ra,8(sp)
ffffffffc02020d8:	6402                	ld	s0,0(sp)
ffffffffc02020da:	0141                	addi	sp,sp,16
ffffffffc02020dc:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02020de:	078a                	slli	a5,a5,0x2
ffffffffc02020e0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02020e2:	000c5717          	auipc	a4,0xc5
ffffffffc02020e6:	a2673703          	ld	a4,-1498(a4) # ffffffffc02c6b08 <npage>
ffffffffc02020ea:	00e7ff63          	bgeu	a5,a4,ffffffffc0202108 <get_page+0x50>
ffffffffc02020ee:	60a2                	ld	ra,8(sp)
ffffffffc02020f0:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc02020f2:	fff80537          	lui	a0,0xfff80
ffffffffc02020f6:	97aa                	add	a5,a5,a0
ffffffffc02020f8:	079a                	slli	a5,a5,0x6
ffffffffc02020fa:	000c5517          	auipc	a0,0xc5
ffffffffc02020fe:	a1653503          	ld	a0,-1514(a0) # ffffffffc02c6b10 <pages>
ffffffffc0202102:	953e                	add	a0,a0,a5
ffffffffc0202104:	0141                	addi	sp,sp,16
ffffffffc0202106:	8082                	ret
ffffffffc0202108:	c99ff0ef          	jal	ra,ffffffffc0201da0 <pa2page.part.0>

ffffffffc020210c <unmap_range>:
        tlb_invalidate(pgdir, la); //(6) flush tlb
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc020210c:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020210e:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202112:	f486                	sd	ra,104(sp)
ffffffffc0202114:	f0a2                	sd	s0,96(sp)
ffffffffc0202116:	eca6                	sd	s1,88(sp)
ffffffffc0202118:	e8ca                	sd	s2,80(sp)
ffffffffc020211a:	e4ce                	sd	s3,72(sp)
ffffffffc020211c:	e0d2                	sd	s4,64(sp)
ffffffffc020211e:	fc56                	sd	s5,56(sp)
ffffffffc0202120:	f85a                	sd	s6,48(sp)
ffffffffc0202122:	f45e                	sd	s7,40(sp)
ffffffffc0202124:	f062                	sd	s8,32(sp)
ffffffffc0202126:	ec66                	sd	s9,24(sp)
ffffffffc0202128:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020212a:	17d2                	slli	a5,a5,0x34
ffffffffc020212c:	e3ed                	bnez	a5,ffffffffc020220e <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc020212e:	002007b7          	lui	a5,0x200
ffffffffc0202132:	842e                	mv	s0,a1
ffffffffc0202134:	0ef5ed63          	bltu	a1,a5,ffffffffc020222e <unmap_range+0x122>
ffffffffc0202138:	8932                	mv	s2,a2
ffffffffc020213a:	0ec5fa63          	bgeu	a1,a2,ffffffffc020222e <unmap_range+0x122>
ffffffffc020213e:	4785                	li	a5,1
ffffffffc0202140:	07fe                	slli	a5,a5,0x1f
ffffffffc0202142:	0ec7e663          	bltu	a5,a2,ffffffffc020222e <unmap_range+0x122>
ffffffffc0202146:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0202148:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc020214a:	000c5c97          	auipc	s9,0xc5
ffffffffc020214e:	9bec8c93          	addi	s9,s9,-1602 # ffffffffc02c6b08 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202152:	000c5c17          	auipc	s8,0xc5
ffffffffc0202156:	9bec0c13          	addi	s8,s8,-1602 # ffffffffc02c6b10 <pages>
ffffffffc020215a:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc020215e:	000c5d17          	auipc	s10,0xc5
ffffffffc0202162:	9bad0d13          	addi	s10,s10,-1606 # ffffffffc02c6b18 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202166:	00200b37          	lui	s6,0x200
ffffffffc020216a:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020216e:	4601                	li	a2,0
ffffffffc0202170:	85a2                	mv	a1,s0
ffffffffc0202172:	854e                	mv	a0,s3
ffffffffc0202174:	d1dff0ef          	jal	ra,ffffffffc0201e90 <get_pte>
ffffffffc0202178:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020217a:	cd29                	beqz	a0,ffffffffc02021d4 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc020217c:	611c                	ld	a5,0(a0)
ffffffffc020217e:	e395                	bnez	a5,ffffffffc02021a2 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc0202180:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202182:	ff2466e3          	bltu	s0,s2,ffffffffc020216e <unmap_range+0x62>
}
ffffffffc0202186:	70a6                	ld	ra,104(sp)
ffffffffc0202188:	7406                	ld	s0,96(sp)
ffffffffc020218a:	64e6                	ld	s1,88(sp)
ffffffffc020218c:	6946                	ld	s2,80(sp)
ffffffffc020218e:	69a6                	ld	s3,72(sp)
ffffffffc0202190:	6a06                	ld	s4,64(sp)
ffffffffc0202192:	7ae2                	ld	s5,56(sp)
ffffffffc0202194:	7b42                	ld	s6,48(sp)
ffffffffc0202196:	7ba2                	ld	s7,40(sp)
ffffffffc0202198:	7c02                	ld	s8,32(sp)
ffffffffc020219a:	6ce2                	ld	s9,24(sp)
ffffffffc020219c:	6d42                	ld	s10,16(sp)
ffffffffc020219e:	6165                	addi	sp,sp,112
ffffffffc02021a0:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc02021a2:	0017f713          	andi	a4,a5,1
ffffffffc02021a6:	df69                	beqz	a4,ffffffffc0202180 <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc02021a8:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02021ac:	078a                	slli	a5,a5,0x2
ffffffffc02021ae:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02021b0:	08e7ff63          	bgeu	a5,a4,ffffffffc020224e <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc02021b4:	000c3503          	ld	a0,0(s8)
ffffffffc02021b8:	97de                	add	a5,a5,s7
ffffffffc02021ba:	079a                	slli	a5,a5,0x6
ffffffffc02021bc:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02021be:	411c                	lw	a5,0(a0)
ffffffffc02021c0:	fff7871b          	addiw	a4,a5,-1
ffffffffc02021c4:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc02021c6:	cf11                	beqz	a4,ffffffffc02021e2 <unmap_range+0xd6>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc02021c8:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02021cc:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02021d0:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02021d2:	bf45                	j	ffffffffc0202182 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02021d4:	945a                	add	s0,s0,s6
ffffffffc02021d6:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc02021da:	d455                	beqz	s0,ffffffffc0202186 <unmap_range+0x7a>
ffffffffc02021dc:	f92469e3          	bltu	s0,s2,ffffffffc020216e <unmap_range+0x62>
ffffffffc02021e0:	b75d                	j	ffffffffc0202186 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02021e2:	100027f3          	csrr	a5,sstatus
ffffffffc02021e6:	8b89                	andi	a5,a5,2
ffffffffc02021e8:	e799                	bnez	a5,ffffffffc02021f6 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc02021ea:	000d3783          	ld	a5,0(s10)
ffffffffc02021ee:	4585                	li	a1,1
ffffffffc02021f0:	739c                	ld	a5,32(a5)
ffffffffc02021f2:	9782                	jalr	a5
    if (flag)
ffffffffc02021f4:	bfd1                	j	ffffffffc02021c8 <unmap_range+0xbc>
ffffffffc02021f6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02021f8:	fb6fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc02021fc:	000d3783          	ld	a5,0(s10)
ffffffffc0202200:	6522                	ld	a0,8(sp)
ffffffffc0202202:	4585                	li	a1,1
ffffffffc0202204:	739c                	ld	a5,32(a5)
ffffffffc0202206:	9782                	jalr	a5
        intr_enable();
ffffffffc0202208:	fa0fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020220c:	bf75                	j	ffffffffc02021c8 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020220e:	00004697          	auipc	a3,0x4
ffffffffc0202212:	65a68693          	addi	a3,a3,1626 # ffffffffc0206868 <default_pmm_manager+0x160>
ffffffffc0202216:	00004617          	auipc	a2,0x4
ffffffffc020221a:	14260613          	addi	a2,a2,322 # ffffffffc0206358 <commands+0x828>
ffffffffc020221e:	12200593          	li	a1,290
ffffffffc0202222:	00004517          	auipc	a0,0x4
ffffffffc0202226:	63650513          	addi	a0,a0,1590 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc020222a:	a68fe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020222e:	00004697          	auipc	a3,0x4
ffffffffc0202232:	66a68693          	addi	a3,a3,1642 # ffffffffc0206898 <default_pmm_manager+0x190>
ffffffffc0202236:	00004617          	auipc	a2,0x4
ffffffffc020223a:	12260613          	addi	a2,a2,290 # ffffffffc0206358 <commands+0x828>
ffffffffc020223e:	12300593          	li	a1,291
ffffffffc0202242:	00004517          	auipc	a0,0x4
ffffffffc0202246:	61650513          	addi	a0,a0,1558 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc020224a:	a48fe0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc020224e:	b53ff0ef          	jal	ra,ffffffffc0201da0 <pa2page.part.0>

ffffffffc0202252 <exit_range>:
{
ffffffffc0202252:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202254:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202258:	fc86                	sd	ra,120(sp)
ffffffffc020225a:	f8a2                	sd	s0,112(sp)
ffffffffc020225c:	f4a6                	sd	s1,104(sp)
ffffffffc020225e:	f0ca                	sd	s2,96(sp)
ffffffffc0202260:	ecce                	sd	s3,88(sp)
ffffffffc0202262:	e8d2                	sd	s4,80(sp)
ffffffffc0202264:	e4d6                	sd	s5,72(sp)
ffffffffc0202266:	e0da                	sd	s6,64(sp)
ffffffffc0202268:	fc5e                	sd	s7,56(sp)
ffffffffc020226a:	f862                	sd	s8,48(sp)
ffffffffc020226c:	f466                	sd	s9,40(sp)
ffffffffc020226e:	f06a                	sd	s10,32(sp)
ffffffffc0202270:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202272:	17d2                	slli	a5,a5,0x34
ffffffffc0202274:	20079a63          	bnez	a5,ffffffffc0202488 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0202278:	002007b7          	lui	a5,0x200
ffffffffc020227c:	24f5e463          	bltu	a1,a5,ffffffffc02024c4 <exit_range+0x272>
ffffffffc0202280:	8ab2                	mv	s5,a2
ffffffffc0202282:	24c5f163          	bgeu	a1,a2,ffffffffc02024c4 <exit_range+0x272>
ffffffffc0202286:	4785                	li	a5,1
ffffffffc0202288:	07fe                	slli	a5,a5,0x1f
ffffffffc020228a:	22c7ed63          	bltu	a5,a2,ffffffffc02024c4 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020228e:	c00009b7          	lui	s3,0xc0000
ffffffffc0202292:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202296:	ffe00937          	lui	s2,0xffe00
ffffffffc020229a:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc020229e:	5cfd                	li	s9,-1
ffffffffc02022a0:	8c2a                	mv	s8,a0
ffffffffc02022a2:	0125f933          	and	s2,a1,s2
ffffffffc02022a6:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc02022a8:	000c5d17          	auipc	s10,0xc5
ffffffffc02022ac:	860d0d13          	addi	s10,s10,-1952 # ffffffffc02c6b08 <npage>
    return KADDR(page2pa(page));
ffffffffc02022b0:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc02022b4:	000c5717          	auipc	a4,0xc5
ffffffffc02022b8:	85c70713          	addi	a4,a4,-1956 # ffffffffc02c6b10 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc02022bc:	000c5d97          	auipc	s11,0xc5
ffffffffc02022c0:	85cd8d93          	addi	s11,s11,-1956 # ffffffffc02c6b18 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc02022c4:	c0000437          	lui	s0,0xc0000
ffffffffc02022c8:	944e                	add	s0,s0,s3
ffffffffc02022ca:	8079                	srli	s0,s0,0x1e
ffffffffc02022cc:	1ff47413          	andi	s0,s0,511
ffffffffc02022d0:	040e                	slli	s0,s0,0x3
ffffffffc02022d2:	9462                	add	s0,s0,s8
ffffffffc02022d4:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_matrix_out_size+0xffffffffbfff38f8>
        if (pde1 & PTE_V)
ffffffffc02022d8:	001a7793          	andi	a5,s4,1
ffffffffc02022dc:	eb99                	bnez	a5,ffffffffc02022f2 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc02022de:	12098463          	beqz	s3,ffffffffc0202406 <exit_range+0x1b4>
ffffffffc02022e2:	400007b7          	lui	a5,0x40000
ffffffffc02022e6:	97ce                	add	a5,a5,s3
ffffffffc02022e8:	894e                	mv	s2,s3
ffffffffc02022ea:	1159fe63          	bgeu	s3,s5,ffffffffc0202406 <exit_range+0x1b4>
ffffffffc02022ee:	89be                	mv	s3,a5
ffffffffc02022f0:	bfd1                	j	ffffffffc02022c4 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc02022f2:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02022f6:	0a0a                	slli	s4,s4,0x2
ffffffffc02022f8:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc02022fc:	1cfa7263          	bgeu	s4,a5,ffffffffc02024c0 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202300:	fff80637          	lui	a2,0xfff80
ffffffffc0202304:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc0202306:	000806b7          	lui	a3,0x80
ffffffffc020230a:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc020230c:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202310:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202312:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202314:	18f5fa63          	bgeu	a1,a5,ffffffffc02024a8 <exit_range+0x256>
ffffffffc0202318:	000c5817          	auipc	a6,0xc5
ffffffffc020231c:	80880813          	addi	a6,a6,-2040 # ffffffffc02c6b20 <va_pa_offset>
ffffffffc0202320:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc0202324:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc0202326:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc020232a:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc020232c:	00080337          	lui	t1,0x80
ffffffffc0202330:	6885                	lui	a7,0x1
ffffffffc0202332:	a819                	j	ffffffffc0202348 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc0202334:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc0202336:	002007b7          	lui	a5,0x200
ffffffffc020233a:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc020233c:	08090c63          	beqz	s2,ffffffffc02023d4 <exit_range+0x182>
ffffffffc0202340:	09397a63          	bgeu	s2,s3,ffffffffc02023d4 <exit_range+0x182>
ffffffffc0202344:	0f597063          	bgeu	s2,s5,ffffffffc0202424 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202348:	01595493          	srli	s1,s2,0x15
ffffffffc020234c:	1ff4f493          	andi	s1,s1,511
ffffffffc0202350:	048e                	slli	s1,s1,0x3
ffffffffc0202352:	94da                	add	s1,s1,s6
ffffffffc0202354:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc0202356:	0017f693          	andi	a3,a5,1
ffffffffc020235a:	dee9                	beqz	a3,ffffffffc0202334 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc020235c:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202360:	078a                	slli	a5,a5,0x2
ffffffffc0202362:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202364:	14b7fe63          	bgeu	a5,a1,ffffffffc02024c0 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202368:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc020236a:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc020236e:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202372:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202376:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202378:	12bef863          	bgeu	t4,a1,ffffffffc02024a8 <exit_range+0x256>
ffffffffc020237c:	00083783          	ld	a5,0(a6)
ffffffffc0202380:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202382:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc0202386:	629c                	ld	a5,0(a3)
ffffffffc0202388:	8b85                	andi	a5,a5,1
ffffffffc020238a:	f7d5                	bnez	a5,ffffffffc0202336 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc020238c:	06a1                	addi	a3,a3,8
ffffffffc020238e:	fed59ce3          	bne	a1,a3,ffffffffc0202386 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc0202392:	631c                	ld	a5,0(a4)
ffffffffc0202394:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202396:	100027f3          	csrr	a5,sstatus
ffffffffc020239a:	8b89                	andi	a5,a5,2
ffffffffc020239c:	e7d9                	bnez	a5,ffffffffc020242a <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc020239e:	000db783          	ld	a5,0(s11)
ffffffffc02023a2:	4585                	li	a1,1
ffffffffc02023a4:	e032                	sd	a2,0(sp)
ffffffffc02023a6:	739c                	ld	a5,32(a5)
ffffffffc02023a8:	9782                	jalr	a5
    if (flag)
ffffffffc02023aa:	6602                	ld	a2,0(sp)
ffffffffc02023ac:	000c4817          	auipc	a6,0xc4
ffffffffc02023b0:	77480813          	addi	a6,a6,1908 # ffffffffc02c6b20 <va_pa_offset>
ffffffffc02023b4:	fff80e37          	lui	t3,0xfff80
ffffffffc02023b8:	00080337          	lui	t1,0x80
ffffffffc02023bc:	6885                	lui	a7,0x1
ffffffffc02023be:	000c4717          	auipc	a4,0xc4
ffffffffc02023c2:	75270713          	addi	a4,a4,1874 # ffffffffc02c6b10 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc02023c6:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc02023ca:	002007b7          	lui	a5,0x200
ffffffffc02023ce:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02023d0:	f60918e3          	bnez	s2,ffffffffc0202340 <exit_range+0xee>
            if (free_pd0)
ffffffffc02023d4:	f00b85e3          	beqz	s7,ffffffffc02022de <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc02023d8:	000d3783          	ld	a5,0(s10)
ffffffffc02023dc:	0efa7263          	bgeu	s4,a5,ffffffffc02024c0 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02023e0:	6308                	ld	a0,0(a4)
ffffffffc02023e2:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02023e4:	100027f3          	csrr	a5,sstatus
ffffffffc02023e8:	8b89                	andi	a5,a5,2
ffffffffc02023ea:	efad                	bnez	a5,ffffffffc0202464 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc02023ec:	000db783          	ld	a5,0(s11)
ffffffffc02023f0:	4585                	li	a1,1
ffffffffc02023f2:	739c                	ld	a5,32(a5)
ffffffffc02023f4:	9782                	jalr	a5
ffffffffc02023f6:	000c4717          	auipc	a4,0xc4
ffffffffc02023fa:	71a70713          	addi	a4,a4,1818 # ffffffffc02c6b10 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02023fe:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc0202402:	ee0990e3          	bnez	s3,ffffffffc02022e2 <exit_range+0x90>
}
ffffffffc0202406:	70e6                	ld	ra,120(sp)
ffffffffc0202408:	7446                	ld	s0,112(sp)
ffffffffc020240a:	74a6                	ld	s1,104(sp)
ffffffffc020240c:	7906                	ld	s2,96(sp)
ffffffffc020240e:	69e6                	ld	s3,88(sp)
ffffffffc0202410:	6a46                	ld	s4,80(sp)
ffffffffc0202412:	6aa6                	ld	s5,72(sp)
ffffffffc0202414:	6b06                	ld	s6,64(sp)
ffffffffc0202416:	7be2                	ld	s7,56(sp)
ffffffffc0202418:	7c42                	ld	s8,48(sp)
ffffffffc020241a:	7ca2                	ld	s9,40(sp)
ffffffffc020241c:	7d02                	ld	s10,32(sp)
ffffffffc020241e:	6de2                	ld	s11,24(sp)
ffffffffc0202420:	6109                	addi	sp,sp,128
ffffffffc0202422:	8082                	ret
            if (free_pd0)
ffffffffc0202424:	ea0b8fe3          	beqz	s7,ffffffffc02022e2 <exit_range+0x90>
ffffffffc0202428:	bf45                	j	ffffffffc02023d8 <exit_range+0x186>
ffffffffc020242a:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc020242c:	e42a                	sd	a0,8(sp)
ffffffffc020242e:	d80fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202432:	000db783          	ld	a5,0(s11)
ffffffffc0202436:	6522                	ld	a0,8(sp)
ffffffffc0202438:	4585                	li	a1,1
ffffffffc020243a:	739c                	ld	a5,32(a5)
ffffffffc020243c:	9782                	jalr	a5
        intr_enable();
ffffffffc020243e:	d6afe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202442:	6602                	ld	a2,0(sp)
ffffffffc0202444:	000c4717          	auipc	a4,0xc4
ffffffffc0202448:	6cc70713          	addi	a4,a4,1740 # ffffffffc02c6b10 <pages>
ffffffffc020244c:	6885                	lui	a7,0x1
ffffffffc020244e:	00080337          	lui	t1,0x80
ffffffffc0202452:	fff80e37          	lui	t3,0xfff80
ffffffffc0202456:	000c4817          	auipc	a6,0xc4
ffffffffc020245a:	6ca80813          	addi	a6,a6,1738 # ffffffffc02c6b20 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020245e:	0004b023          	sd	zero,0(s1)
ffffffffc0202462:	b7a5                	j	ffffffffc02023ca <exit_range+0x178>
ffffffffc0202464:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0202466:	d48fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020246a:	000db783          	ld	a5,0(s11)
ffffffffc020246e:	6502                	ld	a0,0(sp)
ffffffffc0202470:	4585                	li	a1,1
ffffffffc0202472:	739c                	ld	a5,32(a5)
ffffffffc0202474:	9782                	jalr	a5
        intr_enable();
ffffffffc0202476:	d32fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020247a:	000c4717          	auipc	a4,0xc4
ffffffffc020247e:	69670713          	addi	a4,a4,1686 # ffffffffc02c6b10 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202482:	00043023          	sd	zero,0(s0)
ffffffffc0202486:	bfb5                	j	ffffffffc0202402 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202488:	00004697          	auipc	a3,0x4
ffffffffc020248c:	3e068693          	addi	a3,a3,992 # ffffffffc0206868 <default_pmm_manager+0x160>
ffffffffc0202490:	00004617          	auipc	a2,0x4
ffffffffc0202494:	ec860613          	addi	a2,a2,-312 # ffffffffc0206358 <commands+0x828>
ffffffffc0202498:	13700593          	li	a1,311
ffffffffc020249c:	00004517          	auipc	a0,0x4
ffffffffc02024a0:	3bc50513          	addi	a0,a0,956 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc02024a4:	feffd0ef          	jal	ra,ffffffffc0200492 <__panic>
    return KADDR(page2pa(page));
ffffffffc02024a8:	00004617          	auipc	a2,0x4
ffffffffc02024ac:	29860613          	addi	a2,a2,664 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc02024b0:	07100593          	li	a1,113
ffffffffc02024b4:	00004517          	auipc	a0,0x4
ffffffffc02024b8:	2b450513          	addi	a0,a0,692 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc02024bc:	fd7fd0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc02024c0:	8e1ff0ef          	jal	ra,ffffffffc0201da0 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc02024c4:	00004697          	auipc	a3,0x4
ffffffffc02024c8:	3d468693          	addi	a3,a3,980 # ffffffffc0206898 <default_pmm_manager+0x190>
ffffffffc02024cc:	00004617          	auipc	a2,0x4
ffffffffc02024d0:	e8c60613          	addi	a2,a2,-372 # ffffffffc0206358 <commands+0x828>
ffffffffc02024d4:	13800593          	li	a1,312
ffffffffc02024d8:	00004517          	auipc	a0,0x4
ffffffffc02024dc:	38050513          	addi	a0,a0,896 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc02024e0:	fb3fd0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02024e4 <page_remove>:
{
ffffffffc02024e4:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02024e6:	4601                	li	a2,0
{
ffffffffc02024e8:	ec26                	sd	s1,24(sp)
ffffffffc02024ea:	f406                	sd	ra,40(sp)
ffffffffc02024ec:	f022                	sd	s0,32(sp)
ffffffffc02024ee:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02024f0:	9a1ff0ef          	jal	ra,ffffffffc0201e90 <get_pte>
    if (ptep != NULL)
ffffffffc02024f4:	c511                	beqz	a0,ffffffffc0202500 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc02024f6:	611c                	ld	a5,0(a0)
ffffffffc02024f8:	842a                	mv	s0,a0
ffffffffc02024fa:	0017f713          	andi	a4,a5,1
ffffffffc02024fe:	e711                	bnez	a4,ffffffffc020250a <page_remove+0x26>
}
ffffffffc0202500:	70a2                	ld	ra,40(sp)
ffffffffc0202502:	7402                	ld	s0,32(sp)
ffffffffc0202504:	64e2                	ld	s1,24(sp)
ffffffffc0202506:	6145                	addi	sp,sp,48
ffffffffc0202508:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020250a:	078a                	slli	a5,a5,0x2
ffffffffc020250c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020250e:	000c4717          	auipc	a4,0xc4
ffffffffc0202512:	5fa73703          	ld	a4,1530(a4) # ffffffffc02c6b08 <npage>
ffffffffc0202516:	06e7f363          	bgeu	a5,a4,ffffffffc020257c <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc020251a:	fff80537          	lui	a0,0xfff80
ffffffffc020251e:	97aa                	add	a5,a5,a0
ffffffffc0202520:	079a                	slli	a5,a5,0x6
ffffffffc0202522:	000c4517          	auipc	a0,0xc4
ffffffffc0202526:	5ee53503          	ld	a0,1518(a0) # ffffffffc02c6b10 <pages>
ffffffffc020252a:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020252c:	411c                	lw	a5,0(a0)
ffffffffc020252e:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202532:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202534:	cb11                	beqz	a4,ffffffffc0202548 <page_remove+0x64>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc0202536:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020253a:	12048073          	sfence.vma	s1
}
ffffffffc020253e:	70a2                	ld	ra,40(sp)
ffffffffc0202540:	7402                	ld	s0,32(sp)
ffffffffc0202542:	64e2                	ld	s1,24(sp)
ffffffffc0202544:	6145                	addi	sp,sp,48
ffffffffc0202546:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202548:	100027f3          	csrr	a5,sstatus
ffffffffc020254c:	8b89                	andi	a5,a5,2
ffffffffc020254e:	eb89                	bnez	a5,ffffffffc0202560 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc0202550:	000c4797          	auipc	a5,0xc4
ffffffffc0202554:	5c87b783          	ld	a5,1480(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc0202558:	739c                	ld	a5,32(a5)
ffffffffc020255a:	4585                	li	a1,1
ffffffffc020255c:	9782                	jalr	a5
    if (flag)
ffffffffc020255e:	bfe1                	j	ffffffffc0202536 <page_remove+0x52>
        intr_disable();
ffffffffc0202560:	e42a                	sd	a0,8(sp)
ffffffffc0202562:	c4cfe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202566:	000c4797          	auipc	a5,0xc4
ffffffffc020256a:	5b27b783          	ld	a5,1458(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc020256e:	739c                	ld	a5,32(a5)
ffffffffc0202570:	6522                	ld	a0,8(sp)
ffffffffc0202572:	4585                	li	a1,1
ffffffffc0202574:	9782                	jalr	a5
        intr_enable();
ffffffffc0202576:	c32fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020257a:	bf75                	j	ffffffffc0202536 <page_remove+0x52>
ffffffffc020257c:	825ff0ef          	jal	ra,ffffffffc0201da0 <pa2page.part.0>

ffffffffc0202580 <page_insert>:
{
ffffffffc0202580:	7139                	addi	sp,sp,-64
ffffffffc0202582:	e852                	sd	s4,16(sp)
ffffffffc0202584:	8a32                	mv	s4,a2
ffffffffc0202586:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202588:	4605                	li	a2,1
{
ffffffffc020258a:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020258c:	85d2                	mv	a1,s4
{
ffffffffc020258e:	f426                	sd	s1,40(sp)
ffffffffc0202590:	fc06                	sd	ra,56(sp)
ffffffffc0202592:	f04a                	sd	s2,32(sp)
ffffffffc0202594:	ec4e                	sd	s3,24(sp)
ffffffffc0202596:	e456                	sd	s5,8(sp)
ffffffffc0202598:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020259a:	8f7ff0ef          	jal	ra,ffffffffc0201e90 <get_pte>
    if (ptep == NULL)
ffffffffc020259e:	c961                	beqz	a0,ffffffffc020266e <page_insert+0xee>
    page->ref += 1;
ffffffffc02025a0:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc02025a2:	611c                	ld	a5,0(a0)
ffffffffc02025a4:	89aa                	mv	s3,a0
ffffffffc02025a6:	0016871b          	addiw	a4,a3,1
ffffffffc02025aa:	c018                	sw	a4,0(s0)
ffffffffc02025ac:	0017f713          	andi	a4,a5,1
ffffffffc02025b0:	ef05                	bnez	a4,ffffffffc02025e8 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc02025b2:	000c4717          	auipc	a4,0xc4
ffffffffc02025b6:	55e73703          	ld	a4,1374(a4) # ffffffffc02c6b10 <pages>
ffffffffc02025ba:	8c19                	sub	s0,s0,a4
ffffffffc02025bc:	000807b7          	lui	a5,0x80
ffffffffc02025c0:	8419                	srai	s0,s0,0x6
ffffffffc02025c2:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02025c4:	042a                	slli	s0,s0,0xa
ffffffffc02025c6:	8cc1                	or	s1,s1,s0
ffffffffc02025c8:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02025cc:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_matrix_out_size+0xffffffffbfff38f8>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025d0:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc02025d4:	4501                	li	a0,0
}
ffffffffc02025d6:	70e2                	ld	ra,56(sp)
ffffffffc02025d8:	7442                	ld	s0,48(sp)
ffffffffc02025da:	74a2                	ld	s1,40(sp)
ffffffffc02025dc:	7902                	ld	s2,32(sp)
ffffffffc02025de:	69e2                	ld	s3,24(sp)
ffffffffc02025e0:	6a42                	ld	s4,16(sp)
ffffffffc02025e2:	6aa2                	ld	s5,8(sp)
ffffffffc02025e4:	6121                	addi	sp,sp,64
ffffffffc02025e6:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02025e8:	078a                	slli	a5,a5,0x2
ffffffffc02025ea:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02025ec:	000c4717          	auipc	a4,0xc4
ffffffffc02025f0:	51c73703          	ld	a4,1308(a4) # ffffffffc02c6b08 <npage>
ffffffffc02025f4:	06e7ff63          	bgeu	a5,a4,ffffffffc0202672 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02025f8:	000c4a97          	auipc	s5,0xc4
ffffffffc02025fc:	518a8a93          	addi	s5,s5,1304 # ffffffffc02c6b10 <pages>
ffffffffc0202600:	000ab703          	ld	a4,0(s5)
ffffffffc0202604:	fff80937          	lui	s2,0xfff80
ffffffffc0202608:	993e                	add	s2,s2,a5
ffffffffc020260a:	091a                	slli	s2,s2,0x6
ffffffffc020260c:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc020260e:	01240c63          	beq	s0,s2,ffffffffc0202626 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc0202612:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcb94a8>
ffffffffc0202616:	fff7869b          	addiw	a3,a5,-1
ffffffffc020261a:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc020261e:	c691                	beqz	a3,ffffffffc020262a <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202620:	120a0073          	sfence.vma	s4
}
ffffffffc0202624:	bf59                	j	ffffffffc02025ba <page_insert+0x3a>
ffffffffc0202626:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202628:	bf49                	j	ffffffffc02025ba <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020262a:	100027f3          	csrr	a5,sstatus
ffffffffc020262e:	8b89                	andi	a5,a5,2
ffffffffc0202630:	ef91                	bnez	a5,ffffffffc020264c <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc0202632:	000c4797          	auipc	a5,0xc4
ffffffffc0202636:	4e67b783          	ld	a5,1254(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc020263a:	739c                	ld	a5,32(a5)
ffffffffc020263c:	4585                	li	a1,1
ffffffffc020263e:	854a                	mv	a0,s2
ffffffffc0202640:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202642:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202646:	120a0073          	sfence.vma	s4
ffffffffc020264a:	bf85                	j	ffffffffc02025ba <page_insert+0x3a>
        intr_disable();
ffffffffc020264c:	b62fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202650:	000c4797          	auipc	a5,0xc4
ffffffffc0202654:	4c87b783          	ld	a5,1224(a5) # ffffffffc02c6b18 <pmm_manager>
ffffffffc0202658:	739c                	ld	a5,32(a5)
ffffffffc020265a:	4585                	li	a1,1
ffffffffc020265c:	854a                	mv	a0,s2
ffffffffc020265e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202660:	b48fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202664:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202668:	120a0073          	sfence.vma	s4
ffffffffc020266c:	b7b9                	j	ffffffffc02025ba <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc020266e:	5571                	li	a0,-4
ffffffffc0202670:	b79d                	j	ffffffffc02025d6 <page_insert+0x56>
ffffffffc0202672:	f2eff0ef          	jal	ra,ffffffffc0201da0 <pa2page.part.0>

ffffffffc0202676 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202676:	00004797          	auipc	a5,0x4
ffffffffc020267a:	09278793          	addi	a5,a5,146 # ffffffffc0206708 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020267e:	638c                	ld	a1,0(a5)
{
ffffffffc0202680:	7159                	addi	sp,sp,-112
ffffffffc0202682:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202684:	00004517          	auipc	a0,0x4
ffffffffc0202688:	22c50513          	addi	a0,a0,556 # ffffffffc02068b0 <default_pmm_manager+0x1a8>
    pmm_manager = &default_pmm_manager;
ffffffffc020268c:	000c4b17          	auipc	s6,0xc4
ffffffffc0202690:	48cb0b13          	addi	s6,s6,1164 # ffffffffc02c6b18 <pmm_manager>
{
ffffffffc0202694:	f486                	sd	ra,104(sp)
ffffffffc0202696:	e8ca                	sd	s2,80(sp)
ffffffffc0202698:	e4ce                	sd	s3,72(sp)
ffffffffc020269a:	f0a2                	sd	s0,96(sp)
ffffffffc020269c:	eca6                	sd	s1,88(sp)
ffffffffc020269e:	e0d2                	sd	s4,64(sp)
ffffffffc02026a0:	fc56                	sd	s5,56(sp)
ffffffffc02026a2:	f45e                	sd	s7,40(sp)
ffffffffc02026a4:	f062                	sd	s8,32(sp)
ffffffffc02026a6:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc02026a8:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02026ac:	aedfd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    pmm_manager->init();
ffffffffc02026b0:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02026b4:	000c4997          	auipc	s3,0xc4
ffffffffc02026b8:	46c98993          	addi	s3,s3,1132 # ffffffffc02c6b20 <va_pa_offset>
    pmm_manager->init();
ffffffffc02026bc:	679c                	ld	a5,8(a5)
ffffffffc02026be:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02026c0:	57f5                	li	a5,-3
ffffffffc02026c2:	07fa                	slli	a5,a5,0x1e
ffffffffc02026c4:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc02026c8:	accfe0ef          	jal	ra,ffffffffc0200994 <get_memory_base>
ffffffffc02026cc:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc02026ce:	ad0fe0ef          	jal	ra,ffffffffc020099e <get_memory_size>
    if (mem_size == 0)
ffffffffc02026d2:	200505e3          	beqz	a0,ffffffffc02030dc <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02026d6:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc02026d8:	00004517          	auipc	a0,0x4
ffffffffc02026dc:	21050513          	addi	a0,a0,528 # ffffffffc02068e8 <default_pmm_manager+0x1e0>
ffffffffc02026e0:	ab9fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02026e4:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02026e8:	fff40693          	addi	a3,s0,-1
ffffffffc02026ec:	864a                	mv	a2,s2
ffffffffc02026ee:	85a6                	mv	a1,s1
ffffffffc02026f0:	00004517          	auipc	a0,0x4
ffffffffc02026f4:	21050513          	addi	a0,a0,528 # ffffffffc0206900 <default_pmm_manager+0x1f8>
ffffffffc02026f8:	aa1fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02026fc:	c8000737          	lui	a4,0xc8000
ffffffffc0202700:	87a2                	mv	a5,s0
ffffffffc0202702:	54876163          	bltu	a4,s0,ffffffffc0202c44 <pmm_init+0x5ce>
ffffffffc0202706:	757d                	lui	a0,0xfffff
ffffffffc0202708:	000c5617          	auipc	a2,0xc5
ffffffffc020270c:	44f60613          	addi	a2,a2,1103 # ffffffffc02c7b57 <end+0xfff>
ffffffffc0202710:	8e69                	and	a2,a2,a0
ffffffffc0202712:	000c4497          	auipc	s1,0xc4
ffffffffc0202716:	3f648493          	addi	s1,s1,1014 # ffffffffc02c6b08 <npage>
ffffffffc020271a:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020271e:	000c4b97          	auipc	s7,0xc4
ffffffffc0202722:	3f2b8b93          	addi	s7,s7,1010 # ffffffffc02c6b10 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202726:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202728:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020272c:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202730:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202732:	02f50863          	beq	a0,a5,ffffffffc0202762 <pmm_init+0xec>
ffffffffc0202736:	4781                	li	a5,0
ffffffffc0202738:	4585                	li	a1,1
ffffffffc020273a:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc020273e:	00679513          	slli	a0,a5,0x6
ffffffffc0202742:	9532                	add	a0,a0,a2
ffffffffc0202744:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd384b0>
ffffffffc0202748:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020274c:	6088                	ld	a0,0(s1)
ffffffffc020274e:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202750:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202754:	00d50733          	add	a4,a0,a3
ffffffffc0202758:	fee7e3e3          	bltu	a5,a4,ffffffffc020273e <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020275c:	071a                	slli	a4,a4,0x6
ffffffffc020275e:	00e606b3          	add	a3,a2,a4
ffffffffc0202762:	c02007b7          	lui	a5,0xc0200
ffffffffc0202766:	2ef6ece3          	bltu	a3,a5,ffffffffc020325e <pmm_init+0xbe8>
ffffffffc020276a:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020276e:	77fd                	lui	a5,0xfffff
ffffffffc0202770:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202772:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202774:	5086eb63          	bltu	a3,s0,ffffffffc0202c8a <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202778:	00004517          	auipc	a0,0x4
ffffffffc020277c:	1b050513          	addi	a0,a0,432 # ffffffffc0206928 <default_pmm_manager+0x220>
ffffffffc0202780:	a19fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202784:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202788:	000c4917          	auipc	s2,0xc4
ffffffffc020278c:	37890913          	addi	s2,s2,888 # ffffffffc02c6b00 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202790:	7b9c                	ld	a5,48(a5)
ffffffffc0202792:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202794:	00004517          	auipc	a0,0x4
ffffffffc0202798:	1ac50513          	addi	a0,a0,428 # ffffffffc0206940 <default_pmm_manager+0x238>
ffffffffc020279c:	9fdfd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02027a0:	00009697          	auipc	a3,0x9
ffffffffc02027a4:	86068693          	addi	a3,a3,-1952 # ffffffffc020b000 <boot_page_table_sv39>
ffffffffc02027a8:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02027ac:	c02007b7          	lui	a5,0xc0200
ffffffffc02027b0:	28f6ebe3          	bltu	a3,a5,ffffffffc0203246 <pmm_init+0xbd0>
ffffffffc02027b4:	0009b783          	ld	a5,0(s3)
ffffffffc02027b8:	8e9d                	sub	a3,a3,a5
ffffffffc02027ba:	000c4797          	auipc	a5,0xc4
ffffffffc02027be:	32d7bf23          	sd	a3,830(a5) # ffffffffc02c6af8 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02027c2:	100027f3          	csrr	a5,sstatus
ffffffffc02027c6:	8b89                	andi	a5,a5,2
ffffffffc02027c8:	4a079763          	bnez	a5,ffffffffc0202c76 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc02027cc:	000b3783          	ld	a5,0(s6)
ffffffffc02027d0:	779c                	ld	a5,40(a5)
ffffffffc02027d2:	9782                	jalr	a5
ffffffffc02027d4:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02027d6:	6098                	ld	a4,0(s1)
ffffffffc02027d8:	c80007b7          	lui	a5,0xc8000
ffffffffc02027dc:	83b1                	srli	a5,a5,0xc
ffffffffc02027de:	66e7e363          	bltu	a5,a4,ffffffffc0202e44 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02027e2:	00093503          	ld	a0,0(s2)
ffffffffc02027e6:	62050f63          	beqz	a0,ffffffffc0202e24 <pmm_init+0x7ae>
ffffffffc02027ea:	03451793          	slli	a5,a0,0x34
ffffffffc02027ee:	62079b63          	bnez	a5,ffffffffc0202e24 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02027f2:	4601                	li	a2,0
ffffffffc02027f4:	4581                	li	a1,0
ffffffffc02027f6:	8c3ff0ef          	jal	ra,ffffffffc02020b8 <get_page>
ffffffffc02027fa:	60051563          	bnez	a0,ffffffffc0202e04 <pmm_init+0x78e>
ffffffffc02027fe:	100027f3          	csrr	a5,sstatus
ffffffffc0202802:	8b89                	andi	a5,a5,2
ffffffffc0202804:	44079e63          	bnez	a5,ffffffffc0202c60 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202808:	000b3783          	ld	a5,0(s6)
ffffffffc020280c:	4505                	li	a0,1
ffffffffc020280e:	6f9c                	ld	a5,24(a5)
ffffffffc0202810:	9782                	jalr	a5
ffffffffc0202812:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202814:	00093503          	ld	a0,0(s2)
ffffffffc0202818:	4681                	li	a3,0
ffffffffc020281a:	4601                	li	a2,0
ffffffffc020281c:	85d2                	mv	a1,s4
ffffffffc020281e:	d63ff0ef          	jal	ra,ffffffffc0202580 <page_insert>
ffffffffc0202822:	26051ae3          	bnez	a0,ffffffffc0203296 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202826:	00093503          	ld	a0,0(s2)
ffffffffc020282a:	4601                	li	a2,0
ffffffffc020282c:	4581                	li	a1,0
ffffffffc020282e:	e62ff0ef          	jal	ra,ffffffffc0201e90 <get_pte>
ffffffffc0202832:	240502e3          	beqz	a0,ffffffffc0203276 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0202836:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202838:	0017f713          	andi	a4,a5,1
ffffffffc020283c:	5a070263          	beqz	a4,ffffffffc0202de0 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202840:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202842:	078a                	slli	a5,a5,0x2
ffffffffc0202844:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202846:	58e7fb63          	bgeu	a5,a4,ffffffffc0202ddc <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020284a:	000bb683          	ld	a3,0(s7)
ffffffffc020284e:	fff80637          	lui	a2,0xfff80
ffffffffc0202852:	97b2                	add	a5,a5,a2
ffffffffc0202854:	079a                	slli	a5,a5,0x6
ffffffffc0202856:	97b6                	add	a5,a5,a3
ffffffffc0202858:	14fa17e3          	bne	s4,a5,ffffffffc02031a6 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc020285c:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f30>
ffffffffc0202860:	4785                	li	a5,1
ffffffffc0202862:	12f692e3          	bne	a3,a5,ffffffffc0203186 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202866:	00093503          	ld	a0,0(s2)
ffffffffc020286a:	77fd                	lui	a5,0xfffff
ffffffffc020286c:	6114                	ld	a3,0(a0)
ffffffffc020286e:	068a                	slli	a3,a3,0x2
ffffffffc0202870:	8efd                	and	a3,a3,a5
ffffffffc0202872:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202876:	0ee67ce3          	bgeu	a2,a4,ffffffffc020316e <pmm_init+0xaf8>
ffffffffc020287a:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020287e:	96e2                	add	a3,a3,s8
ffffffffc0202880:	0006ba83          	ld	s5,0(a3)
ffffffffc0202884:	0a8a                	slli	s5,s5,0x2
ffffffffc0202886:	00fafab3          	and	s5,s5,a5
ffffffffc020288a:	00cad793          	srli	a5,s5,0xc
ffffffffc020288e:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0203154 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202892:	4601                	li	a2,0
ffffffffc0202894:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202896:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202898:	df8ff0ef          	jal	ra,ffffffffc0201e90 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020289c:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020289e:	55551363          	bne	a0,s5,ffffffffc0202de4 <pmm_init+0x76e>
ffffffffc02028a2:	100027f3          	csrr	a5,sstatus
ffffffffc02028a6:	8b89                	andi	a5,a5,2
ffffffffc02028a8:	3a079163          	bnez	a5,ffffffffc0202c4a <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc02028ac:	000b3783          	ld	a5,0(s6)
ffffffffc02028b0:	4505                	li	a0,1
ffffffffc02028b2:	6f9c                	ld	a5,24(a5)
ffffffffc02028b4:	9782                	jalr	a5
ffffffffc02028b6:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02028b8:	00093503          	ld	a0,0(s2)
ffffffffc02028bc:	46d1                	li	a3,20
ffffffffc02028be:	6605                	lui	a2,0x1
ffffffffc02028c0:	85e2                	mv	a1,s8
ffffffffc02028c2:	cbfff0ef          	jal	ra,ffffffffc0202580 <page_insert>
ffffffffc02028c6:	060517e3          	bnez	a0,ffffffffc0203134 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02028ca:	00093503          	ld	a0,0(s2)
ffffffffc02028ce:	4601                	li	a2,0
ffffffffc02028d0:	6585                	lui	a1,0x1
ffffffffc02028d2:	dbeff0ef          	jal	ra,ffffffffc0201e90 <get_pte>
ffffffffc02028d6:	02050fe3          	beqz	a0,ffffffffc0203114 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc02028da:	611c                	ld	a5,0(a0)
ffffffffc02028dc:	0107f713          	andi	a4,a5,16
ffffffffc02028e0:	7c070e63          	beqz	a4,ffffffffc02030bc <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc02028e4:	8b91                	andi	a5,a5,4
ffffffffc02028e6:	7a078b63          	beqz	a5,ffffffffc020309c <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02028ea:	00093503          	ld	a0,0(s2)
ffffffffc02028ee:	611c                	ld	a5,0(a0)
ffffffffc02028f0:	8bc1                	andi	a5,a5,16
ffffffffc02028f2:	78078563          	beqz	a5,ffffffffc020307c <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc02028f6:	000c2703          	lw	a4,0(s8)
ffffffffc02028fa:	4785                	li	a5,1
ffffffffc02028fc:	76f71063          	bne	a4,a5,ffffffffc020305c <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202900:	4681                	li	a3,0
ffffffffc0202902:	6605                	lui	a2,0x1
ffffffffc0202904:	85d2                	mv	a1,s4
ffffffffc0202906:	c7bff0ef          	jal	ra,ffffffffc0202580 <page_insert>
ffffffffc020290a:	72051963          	bnez	a0,ffffffffc020303c <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc020290e:	000a2703          	lw	a4,0(s4)
ffffffffc0202912:	4789                	li	a5,2
ffffffffc0202914:	70f71463          	bne	a4,a5,ffffffffc020301c <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc0202918:	000c2783          	lw	a5,0(s8)
ffffffffc020291c:	6e079063          	bnez	a5,ffffffffc0202ffc <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202920:	00093503          	ld	a0,0(s2)
ffffffffc0202924:	4601                	li	a2,0
ffffffffc0202926:	6585                	lui	a1,0x1
ffffffffc0202928:	d68ff0ef          	jal	ra,ffffffffc0201e90 <get_pte>
ffffffffc020292c:	6a050863          	beqz	a0,ffffffffc0202fdc <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0202930:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202932:	00177793          	andi	a5,a4,1
ffffffffc0202936:	4a078563          	beqz	a5,ffffffffc0202de0 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc020293a:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020293c:	00271793          	slli	a5,a4,0x2
ffffffffc0202940:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202942:	48d7fd63          	bgeu	a5,a3,ffffffffc0202ddc <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202946:	000bb683          	ld	a3,0(s7)
ffffffffc020294a:	fff80ab7          	lui	s5,0xfff80
ffffffffc020294e:	97d6                	add	a5,a5,s5
ffffffffc0202950:	079a                	slli	a5,a5,0x6
ffffffffc0202952:	97b6                	add	a5,a5,a3
ffffffffc0202954:	66fa1463          	bne	s4,a5,ffffffffc0202fbc <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202958:	8b41                	andi	a4,a4,16
ffffffffc020295a:	64071163          	bnez	a4,ffffffffc0202f9c <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc020295e:	00093503          	ld	a0,0(s2)
ffffffffc0202962:	4581                	li	a1,0
ffffffffc0202964:	b81ff0ef          	jal	ra,ffffffffc02024e4 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202968:	000a2c83          	lw	s9,0(s4)
ffffffffc020296c:	4785                	li	a5,1
ffffffffc020296e:	60fc9763          	bne	s9,a5,ffffffffc0202f7c <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202972:	000c2783          	lw	a5,0(s8)
ffffffffc0202976:	5e079363          	bnez	a5,ffffffffc0202f5c <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc020297a:	00093503          	ld	a0,0(s2)
ffffffffc020297e:	6585                	lui	a1,0x1
ffffffffc0202980:	b65ff0ef          	jal	ra,ffffffffc02024e4 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202984:	000a2783          	lw	a5,0(s4)
ffffffffc0202988:	52079a63          	bnez	a5,ffffffffc0202ebc <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc020298c:	000c2783          	lw	a5,0(s8)
ffffffffc0202990:	50079663          	bnez	a5,ffffffffc0202e9c <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202994:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202998:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020299a:	000a3683          	ld	a3,0(s4)
ffffffffc020299e:	068a                	slli	a3,a3,0x2
ffffffffc02029a0:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc02029a2:	42b6fd63          	bgeu	a3,a1,ffffffffc0202ddc <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02029a6:	000bb503          	ld	a0,0(s7)
ffffffffc02029aa:	96d6                	add	a3,a3,s5
ffffffffc02029ac:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc02029ae:	00d507b3          	add	a5,a0,a3
ffffffffc02029b2:	439c                	lw	a5,0(a5)
ffffffffc02029b4:	4d979463          	bne	a5,s9,ffffffffc0202e7c <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc02029b8:	8699                	srai	a3,a3,0x6
ffffffffc02029ba:	00080637          	lui	a2,0x80
ffffffffc02029be:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02029c0:	00c69713          	slli	a4,a3,0xc
ffffffffc02029c4:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02029c6:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02029c8:	48b77e63          	bgeu	a4,a1,ffffffffc0202e64 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc02029cc:	0009b703          	ld	a4,0(s3)
ffffffffc02029d0:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc02029d2:	629c                	ld	a5,0(a3)
ffffffffc02029d4:	078a                	slli	a5,a5,0x2
ffffffffc02029d6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029d8:	40b7f263          	bgeu	a5,a1,ffffffffc0202ddc <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02029dc:	8f91                	sub	a5,a5,a2
ffffffffc02029de:	079a                	slli	a5,a5,0x6
ffffffffc02029e0:	953e                	add	a0,a0,a5
ffffffffc02029e2:	100027f3          	csrr	a5,sstatus
ffffffffc02029e6:	8b89                	andi	a5,a5,2
ffffffffc02029e8:	30079963          	bnez	a5,ffffffffc0202cfa <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc02029ec:	000b3783          	ld	a5,0(s6)
ffffffffc02029f0:	4585                	li	a1,1
ffffffffc02029f2:	739c                	ld	a5,32(a5)
ffffffffc02029f4:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02029f6:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc02029fa:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02029fc:	078a                	slli	a5,a5,0x2
ffffffffc02029fe:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a00:	3ce7fe63          	bgeu	a5,a4,ffffffffc0202ddc <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a04:	000bb503          	ld	a0,0(s7)
ffffffffc0202a08:	fff80737          	lui	a4,0xfff80
ffffffffc0202a0c:	97ba                	add	a5,a5,a4
ffffffffc0202a0e:	079a                	slli	a5,a5,0x6
ffffffffc0202a10:	953e                	add	a0,a0,a5
ffffffffc0202a12:	100027f3          	csrr	a5,sstatus
ffffffffc0202a16:	8b89                	andi	a5,a5,2
ffffffffc0202a18:	2c079563          	bnez	a5,ffffffffc0202ce2 <pmm_init+0x66c>
ffffffffc0202a1c:	000b3783          	ld	a5,0(s6)
ffffffffc0202a20:	4585                	li	a1,1
ffffffffc0202a22:	739c                	ld	a5,32(a5)
ffffffffc0202a24:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202a26:	00093783          	ld	a5,0(s2)
ffffffffc0202a2a:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd384a8>
    asm volatile("sfence.vma");
ffffffffc0202a2e:	12000073          	sfence.vma
ffffffffc0202a32:	100027f3          	csrr	a5,sstatus
ffffffffc0202a36:	8b89                	andi	a5,a5,2
ffffffffc0202a38:	28079b63          	bnez	a5,ffffffffc0202cce <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202a3c:	000b3783          	ld	a5,0(s6)
ffffffffc0202a40:	779c                	ld	a5,40(a5)
ffffffffc0202a42:	9782                	jalr	a5
ffffffffc0202a44:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202a46:	4b441b63          	bne	s0,s4,ffffffffc0202efc <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202a4a:	00004517          	auipc	a0,0x4
ffffffffc0202a4e:	21e50513          	addi	a0,a0,542 # ffffffffc0206c68 <default_pmm_manager+0x560>
ffffffffc0202a52:	f46fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc0202a56:	100027f3          	csrr	a5,sstatus
ffffffffc0202a5a:	8b89                	andi	a5,a5,2
ffffffffc0202a5c:	24079f63          	bnez	a5,ffffffffc0202cba <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202a60:	000b3783          	ld	a5,0(s6)
ffffffffc0202a64:	779c                	ld	a5,40(a5)
ffffffffc0202a66:	9782                	jalr	a5
ffffffffc0202a68:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202a6a:	6098                	ld	a4,0(s1)
ffffffffc0202a6c:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202a70:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202a72:	00c71793          	slli	a5,a4,0xc
ffffffffc0202a76:	6a05                	lui	s4,0x1
ffffffffc0202a78:	02f47c63          	bgeu	s0,a5,ffffffffc0202ab0 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202a7c:	00c45793          	srli	a5,s0,0xc
ffffffffc0202a80:	00093503          	ld	a0,0(s2)
ffffffffc0202a84:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202d82 <pmm_init+0x70c>
ffffffffc0202a88:	0009b583          	ld	a1,0(s3)
ffffffffc0202a8c:	4601                	li	a2,0
ffffffffc0202a8e:	95a2                	add	a1,a1,s0
ffffffffc0202a90:	c00ff0ef          	jal	ra,ffffffffc0201e90 <get_pte>
ffffffffc0202a94:	32050463          	beqz	a0,ffffffffc0202dbc <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202a98:	611c                	ld	a5,0(a0)
ffffffffc0202a9a:	078a                	slli	a5,a5,0x2
ffffffffc0202a9c:	0157f7b3          	and	a5,a5,s5
ffffffffc0202aa0:	2e879e63          	bne	a5,s0,ffffffffc0202d9c <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202aa4:	6098                	ld	a4,0(s1)
ffffffffc0202aa6:	9452                	add	s0,s0,s4
ffffffffc0202aa8:	00c71793          	slli	a5,a4,0xc
ffffffffc0202aac:	fcf468e3          	bltu	s0,a5,ffffffffc0202a7c <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202ab0:	00093783          	ld	a5,0(s2)
ffffffffc0202ab4:	639c                	ld	a5,0(a5)
ffffffffc0202ab6:	42079363          	bnez	a5,ffffffffc0202edc <pmm_init+0x866>
ffffffffc0202aba:	100027f3          	csrr	a5,sstatus
ffffffffc0202abe:	8b89                	andi	a5,a5,2
ffffffffc0202ac0:	24079963          	bnez	a5,ffffffffc0202d12 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202ac4:	000b3783          	ld	a5,0(s6)
ffffffffc0202ac8:	4505                	li	a0,1
ffffffffc0202aca:	6f9c                	ld	a5,24(a5)
ffffffffc0202acc:	9782                	jalr	a5
ffffffffc0202ace:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202ad0:	00093503          	ld	a0,0(s2)
ffffffffc0202ad4:	4699                	li	a3,6
ffffffffc0202ad6:	10000613          	li	a2,256
ffffffffc0202ada:	85d2                	mv	a1,s4
ffffffffc0202adc:	aa5ff0ef          	jal	ra,ffffffffc0202580 <page_insert>
ffffffffc0202ae0:	44051e63          	bnez	a0,ffffffffc0202f3c <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202ae4:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f30>
ffffffffc0202ae8:	4785                	li	a5,1
ffffffffc0202aea:	42f71963          	bne	a4,a5,ffffffffc0202f1c <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202aee:	00093503          	ld	a0,0(s2)
ffffffffc0202af2:	6405                	lui	s0,0x1
ffffffffc0202af4:	4699                	li	a3,6
ffffffffc0202af6:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8e30>
ffffffffc0202afa:	85d2                	mv	a1,s4
ffffffffc0202afc:	a85ff0ef          	jal	ra,ffffffffc0202580 <page_insert>
ffffffffc0202b00:	72051363          	bnez	a0,ffffffffc0203226 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202b04:	000a2703          	lw	a4,0(s4)
ffffffffc0202b08:	4789                	li	a5,2
ffffffffc0202b0a:	6ef71e63          	bne	a4,a5,ffffffffc0203206 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202b0e:	00004597          	auipc	a1,0x4
ffffffffc0202b12:	2a258593          	addi	a1,a1,674 # ffffffffc0206db0 <default_pmm_manager+0x6a8>
ffffffffc0202b16:	10000513          	li	a0,256
ffffffffc0202b1a:	515020ef          	jal	ra,ffffffffc020582e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202b1e:	10040593          	addi	a1,s0,256
ffffffffc0202b22:	10000513          	li	a0,256
ffffffffc0202b26:	51b020ef          	jal	ra,ffffffffc0205840 <strcmp>
ffffffffc0202b2a:	6a051e63          	bnez	a0,ffffffffc02031e6 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202b2e:	000bb683          	ld	a3,0(s7)
ffffffffc0202b32:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202b36:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202b38:	40da06b3          	sub	a3,s4,a3
ffffffffc0202b3c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202b3e:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202b40:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202b42:	8031                	srli	s0,s0,0xc
ffffffffc0202b44:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b48:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202b4a:	30f77d63          	bgeu	a4,a5,ffffffffc0202e64 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202b4e:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202b52:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202b56:	96be                	add	a3,a3,a5
ffffffffc0202b58:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202b5c:	49d020ef          	jal	ra,ffffffffc02057f8 <strlen>
ffffffffc0202b60:	66051363          	bnez	a0,ffffffffc02031c6 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202b64:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202b68:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b6a:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd384a8>
ffffffffc0202b6e:	068a                	slli	a3,a3,0x2
ffffffffc0202b70:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b72:	26f6f563          	bgeu	a3,a5,ffffffffc0202ddc <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202b76:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b78:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202b7a:	2ef47563          	bgeu	s0,a5,ffffffffc0202e64 <pmm_init+0x7ee>
ffffffffc0202b7e:	0009b403          	ld	s0,0(s3)
ffffffffc0202b82:	9436                	add	s0,s0,a3
ffffffffc0202b84:	100027f3          	csrr	a5,sstatus
ffffffffc0202b88:	8b89                	andi	a5,a5,2
ffffffffc0202b8a:	1e079163          	bnez	a5,ffffffffc0202d6c <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202b8e:	000b3783          	ld	a5,0(s6)
ffffffffc0202b92:	4585                	li	a1,1
ffffffffc0202b94:	8552                	mv	a0,s4
ffffffffc0202b96:	739c                	ld	a5,32(a5)
ffffffffc0202b98:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b9a:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202b9c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b9e:	078a                	slli	a5,a5,0x2
ffffffffc0202ba0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ba2:	22e7fd63          	bgeu	a5,a4,ffffffffc0202ddc <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ba6:	000bb503          	ld	a0,0(s7)
ffffffffc0202baa:	fff80737          	lui	a4,0xfff80
ffffffffc0202bae:	97ba                	add	a5,a5,a4
ffffffffc0202bb0:	079a                	slli	a5,a5,0x6
ffffffffc0202bb2:	953e                	add	a0,a0,a5
ffffffffc0202bb4:	100027f3          	csrr	a5,sstatus
ffffffffc0202bb8:	8b89                	andi	a5,a5,2
ffffffffc0202bba:	18079d63          	bnez	a5,ffffffffc0202d54 <pmm_init+0x6de>
ffffffffc0202bbe:	000b3783          	ld	a5,0(s6)
ffffffffc0202bc2:	4585                	li	a1,1
ffffffffc0202bc4:	739c                	ld	a5,32(a5)
ffffffffc0202bc6:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202bc8:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202bcc:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202bce:	078a                	slli	a5,a5,0x2
ffffffffc0202bd0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202bd2:	20e7f563          	bgeu	a5,a4,ffffffffc0202ddc <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202bd6:	000bb503          	ld	a0,0(s7)
ffffffffc0202bda:	fff80737          	lui	a4,0xfff80
ffffffffc0202bde:	97ba                	add	a5,a5,a4
ffffffffc0202be0:	079a                	slli	a5,a5,0x6
ffffffffc0202be2:	953e                	add	a0,a0,a5
ffffffffc0202be4:	100027f3          	csrr	a5,sstatus
ffffffffc0202be8:	8b89                	andi	a5,a5,2
ffffffffc0202bea:	14079963          	bnez	a5,ffffffffc0202d3c <pmm_init+0x6c6>
ffffffffc0202bee:	000b3783          	ld	a5,0(s6)
ffffffffc0202bf2:	4585                	li	a1,1
ffffffffc0202bf4:	739c                	ld	a5,32(a5)
ffffffffc0202bf6:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202bf8:	00093783          	ld	a5,0(s2)
ffffffffc0202bfc:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202c00:	12000073          	sfence.vma
ffffffffc0202c04:	100027f3          	csrr	a5,sstatus
ffffffffc0202c08:	8b89                	andi	a5,a5,2
ffffffffc0202c0a:	10079f63          	bnez	a5,ffffffffc0202d28 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c0e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c12:	779c                	ld	a5,40(a5)
ffffffffc0202c14:	9782                	jalr	a5
ffffffffc0202c16:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202c18:	4c8c1e63          	bne	s8,s0,ffffffffc02030f4 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202c1c:	00004517          	auipc	a0,0x4
ffffffffc0202c20:	20c50513          	addi	a0,a0,524 # ffffffffc0206e28 <default_pmm_manager+0x720>
ffffffffc0202c24:	d74fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
}
ffffffffc0202c28:	7406                	ld	s0,96(sp)
ffffffffc0202c2a:	70a6                	ld	ra,104(sp)
ffffffffc0202c2c:	64e6                	ld	s1,88(sp)
ffffffffc0202c2e:	6946                	ld	s2,80(sp)
ffffffffc0202c30:	69a6                	ld	s3,72(sp)
ffffffffc0202c32:	6a06                	ld	s4,64(sp)
ffffffffc0202c34:	7ae2                	ld	s5,56(sp)
ffffffffc0202c36:	7b42                	ld	s6,48(sp)
ffffffffc0202c38:	7ba2                	ld	s7,40(sp)
ffffffffc0202c3a:	7c02                	ld	s8,32(sp)
ffffffffc0202c3c:	6ce2                	ld	s9,24(sp)
ffffffffc0202c3e:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202c40:	f97fe06f          	j	ffffffffc0201bd6 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202c44:	c80007b7          	lui	a5,0xc8000
ffffffffc0202c48:	bc7d                	j	ffffffffc0202706 <pmm_init+0x90>
        intr_disable();
ffffffffc0202c4a:	d65fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202c4e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c52:	4505                	li	a0,1
ffffffffc0202c54:	6f9c                	ld	a5,24(a5)
ffffffffc0202c56:	9782                	jalr	a5
ffffffffc0202c58:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202c5a:	d4ffd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202c5e:	b9a9                	j	ffffffffc02028b8 <pmm_init+0x242>
        intr_disable();
ffffffffc0202c60:	d4ffd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202c64:	000b3783          	ld	a5,0(s6)
ffffffffc0202c68:	4505                	li	a0,1
ffffffffc0202c6a:	6f9c                	ld	a5,24(a5)
ffffffffc0202c6c:	9782                	jalr	a5
ffffffffc0202c6e:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202c70:	d39fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202c74:	b645                	j	ffffffffc0202814 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202c76:	d39fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c7a:	000b3783          	ld	a5,0(s6)
ffffffffc0202c7e:	779c                	ld	a5,40(a5)
ffffffffc0202c80:	9782                	jalr	a5
ffffffffc0202c82:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202c84:	d25fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202c88:	b6b9                	j	ffffffffc02027d6 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202c8a:	6705                	lui	a4,0x1
ffffffffc0202c8c:	177d                	addi	a4,a4,-1
ffffffffc0202c8e:	96ba                	add	a3,a3,a4
ffffffffc0202c90:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202c92:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202c96:	14a77363          	bgeu	a4,a0,ffffffffc0202ddc <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202c9a:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202c9e:	fff80537          	lui	a0,0xfff80
ffffffffc0202ca2:	972a                	add	a4,a4,a0
ffffffffc0202ca4:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202ca6:	8c1d                	sub	s0,s0,a5
ffffffffc0202ca8:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202cac:	00c45593          	srli	a1,s0,0xc
ffffffffc0202cb0:	9532                	add	a0,a0,a2
ffffffffc0202cb2:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202cb4:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202cb8:	b4c1                	j	ffffffffc0202778 <pmm_init+0x102>
        intr_disable();
ffffffffc0202cba:	cf5fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cbe:	000b3783          	ld	a5,0(s6)
ffffffffc0202cc2:	779c                	ld	a5,40(a5)
ffffffffc0202cc4:	9782                	jalr	a5
ffffffffc0202cc6:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202cc8:	ce1fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202ccc:	bb79                	j	ffffffffc0202a6a <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202cce:	ce1fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202cd2:	000b3783          	ld	a5,0(s6)
ffffffffc0202cd6:	779c                	ld	a5,40(a5)
ffffffffc0202cd8:	9782                	jalr	a5
ffffffffc0202cda:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202cdc:	ccdfd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202ce0:	b39d                	j	ffffffffc0202a46 <pmm_init+0x3d0>
ffffffffc0202ce2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202ce4:	ccbfd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202ce8:	000b3783          	ld	a5,0(s6)
ffffffffc0202cec:	6522                	ld	a0,8(sp)
ffffffffc0202cee:	4585                	li	a1,1
ffffffffc0202cf0:	739c                	ld	a5,32(a5)
ffffffffc0202cf2:	9782                	jalr	a5
        intr_enable();
ffffffffc0202cf4:	cb5fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202cf8:	b33d                	j	ffffffffc0202a26 <pmm_init+0x3b0>
ffffffffc0202cfa:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202cfc:	cb3fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202d00:	000b3783          	ld	a5,0(s6)
ffffffffc0202d04:	6522                	ld	a0,8(sp)
ffffffffc0202d06:	4585                	li	a1,1
ffffffffc0202d08:	739c                	ld	a5,32(a5)
ffffffffc0202d0a:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d0c:	c9dfd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d10:	b1dd                	j	ffffffffc02029f6 <pmm_init+0x380>
        intr_disable();
ffffffffc0202d12:	c9dfd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d16:	000b3783          	ld	a5,0(s6)
ffffffffc0202d1a:	4505                	li	a0,1
ffffffffc0202d1c:	6f9c                	ld	a5,24(a5)
ffffffffc0202d1e:	9782                	jalr	a5
ffffffffc0202d20:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202d22:	c87fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d26:	b36d                	j	ffffffffc0202ad0 <pmm_init+0x45a>
        intr_disable();
ffffffffc0202d28:	c87fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d2c:	000b3783          	ld	a5,0(s6)
ffffffffc0202d30:	779c                	ld	a5,40(a5)
ffffffffc0202d32:	9782                	jalr	a5
ffffffffc0202d34:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202d36:	c73fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d3a:	bdf9                	j	ffffffffc0202c18 <pmm_init+0x5a2>
ffffffffc0202d3c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202d3e:	c71fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202d42:	000b3783          	ld	a5,0(s6)
ffffffffc0202d46:	6522                	ld	a0,8(sp)
ffffffffc0202d48:	4585                	li	a1,1
ffffffffc0202d4a:	739c                	ld	a5,32(a5)
ffffffffc0202d4c:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d4e:	c5bfd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d52:	b55d                	j	ffffffffc0202bf8 <pmm_init+0x582>
ffffffffc0202d54:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202d56:	c59fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202d5a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d5e:	6522                	ld	a0,8(sp)
ffffffffc0202d60:	4585                	li	a1,1
ffffffffc0202d62:	739c                	ld	a5,32(a5)
ffffffffc0202d64:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d66:	c43fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d6a:	bdb9                	j	ffffffffc0202bc8 <pmm_init+0x552>
        intr_disable();
ffffffffc0202d6c:	c43fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202d70:	000b3783          	ld	a5,0(s6)
ffffffffc0202d74:	4585                	li	a1,1
ffffffffc0202d76:	8552                	mv	a0,s4
ffffffffc0202d78:	739c                	ld	a5,32(a5)
ffffffffc0202d7a:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d7c:	c2dfd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d80:	bd29                	j	ffffffffc0202b9a <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202d82:	86a2                	mv	a3,s0
ffffffffc0202d84:	00004617          	auipc	a2,0x4
ffffffffc0202d88:	9bc60613          	addi	a2,a2,-1604 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc0202d8c:	24a00593          	li	a1,586
ffffffffc0202d90:	00004517          	auipc	a0,0x4
ffffffffc0202d94:	ac850513          	addi	a0,a0,-1336 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202d98:	efafd0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202d9c:	00004697          	auipc	a3,0x4
ffffffffc0202da0:	f2c68693          	addi	a3,a3,-212 # ffffffffc0206cc8 <default_pmm_manager+0x5c0>
ffffffffc0202da4:	00003617          	auipc	a2,0x3
ffffffffc0202da8:	5b460613          	addi	a2,a2,1460 # ffffffffc0206358 <commands+0x828>
ffffffffc0202dac:	24b00593          	li	a1,587
ffffffffc0202db0:	00004517          	auipc	a0,0x4
ffffffffc0202db4:	aa850513          	addi	a0,a0,-1368 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202db8:	edafd0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202dbc:	00004697          	auipc	a3,0x4
ffffffffc0202dc0:	ecc68693          	addi	a3,a3,-308 # ffffffffc0206c88 <default_pmm_manager+0x580>
ffffffffc0202dc4:	00003617          	auipc	a2,0x3
ffffffffc0202dc8:	59460613          	addi	a2,a2,1428 # ffffffffc0206358 <commands+0x828>
ffffffffc0202dcc:	24a00593          	li	a1,586
ffffffffc0202dd0:	00004517          	auipc	a0,0x4
ffffffffc0202dd4:	a8850513          	addi	a0,a0,-1400 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202dd8:	ebafd0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc0202ddc:	fc5fe0ef          	jal	ra,ffffffffc0201da0 <pa2page.part.0>
ffffffffc0202de0:	fddfe0ef          	jal	ra,ffffffffc0201dbc <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202de4:	00004697          	auipc	a3,0x4
ffffffffc0202de8:	c9c68693          	addi	a3,a3,-868 # ffffffffc0206a80 <default_pmm_manager+0x378>
ffffffffc0202dec:	00003617          	auipc	a2,0x3
ffffffffc0202df0:	56c60613          	addi	a2,a2,1388 # ffffffffc0206358 <commands+0x828>
ffffffffc0202df4:	21a00593          	li	a1,538
ffffffffc0202df8:	00004517          	auipc	a0,0x4
ffffffffc0202dfc:	a6050513          	addi	a0,a0,-1440 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202e00:	e92fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202e04:	00004697          	auipc	a3,0x4
ffffffffc0202e08:	bbc68693          	addi	a3,a3,-1092 # ffffffffc02069c0 <default_pmm_manager+0x2b8>
ffffffffc0202e0c:	00003617          	auipc	a2,0x3
ffffffffc0202e10:	54c60613          	addi	a2,a2,1356 # ffffffffc0206358 <commands+0x828>
ffffffffc0202e14:	20d00593          	li	a1,525
ffffffffc0202e18:	00004517          	auipc	a0,0x4
ffffffffc0202e1c:	a4050513          	addi	a0,a0,-1472 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202e20:	e72fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202e24:	00004697          	auipc	a3,0x4
ffffffffc0202e28:	b5c68693          	addi	a3,a3,-1188 # ffffffffc0206980 <default_pmm_manager+0x278>
ffffffffc0202e2c:	00003617          	auipc	a2,0x3
ffffffffc0202e30:	52c60613          	addi	a2,a2,1324 # ffffffffc0206358 <commands+0x828>
ffffffffc0202e34:	20c00593          	li	a1,524
ffffffffc0202e38:	00004517          	auipc	a0,0x4
ffffffffc0202e3c:	a2050513          	addi	a0,a0,-1504 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202e40:	e52fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202e44:	00004697          	auipc	a3,0x4
ffffffffc0202e48:	b1c68693          	addi	a3,a3,-1252 # ffffffffc0206960 <default_pmm_manager+0x258>
ffffffffc0202e4c:	00003617          	auipc	a2,0x3
ffffffffc0202e50:	50c60613          	addi	a2,a2,1292 # ffffffffc0206358 <commands+0x828>
ffffffffc0202e54:	20b00593          	li	a1,523
ffffffffc0202e58:	00004517          	auipc	a0,0x4
ffffffffc0202e5c:	a0050513          	addi	a0,a0,-1536 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202e60:	e32fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202e64:	00004617          	auipc	a2,0x4
ffffffffc0202e68:	8dc60613          	addi	a2,a2,-1828 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc0202e6c:	07100593          	li	a1,113
ffffffffc0202e70:	00004517          	auipc	a0,0x4
ffffffffc0202e74:	8f850513          	addi	a0,a0,-1800 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc0202e78:	e1afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202e7c:	00004697          	auipc	a3,0x4
ffffffffc0202e80:	d9468693          	addi	a3,a3,-620 # ffffffffc0206c10 <default_pmm_manager+0x508>
ffffffffc0202e84:	00003617          	auipc	a2,0x3
ffffffffc0202e88:	4d460613          	addi	a2,a2,1236 # ffffffffc0206358 <commands+0x828>
ffffffffc0202e8c:	23300593          	li	a1,563
ffffffffc0202e90:	00004517          	auipc	a0,0x4
ffffffffc0202e94:	9c850513          	addi	a0,a0,-1592 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202e98:	dfafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202e9c:	00004697          	auipc	a3,0x4
ffffffffc0202ea0:	d2c68693          	addi	a3,a3,-724 # ffffffffc0206bc8 <default_pmm_manager+0x4c0>
ffffffffc0202ea4:	00003617          	auipc	a2,0x3
ffffffffc0202ea8:	4b460613          	addi	a2,a2,1204 # ffffffffc0206358 <commands+0x828>
ffffffffc0202eac:	23100593          	li	a1,561
ffffffffc0202eb0:	00004517          	auipc	a0,0x4
ffffffffc0202eb4:	9a850513          	addi	a0,a0,-1624 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202eb8:	ddafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202ebc:	00004697          	auipc	a3,0x4
ffffffffc0202ec0:	d3c68693          	addi	a3,a3,-708 # ffffffffc0206bf8 <default_pmm_manager+0x4f0>
ffffffffc0202ec4:	00003617          	auipc	a2,0x3
ffffffffc0202ec8:	49460613          	addi	a2,a2,1172 # ffffffffc0206358 <commands+0x828>
ffffffffc0202ecc:	23000593          	li	a1,560
ffffffffc0202ed0:	00004517          	auipc	a0,0x4
ffffffffc0202ed4:	98850513          	addi	a0,a0,-1656 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202ed8:	dbafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202edc:	00004697          	auipc	a3,0x4
ffffffffc0202ee0:	e0468693          	addi	a3,a3,-508 # ffffffffc0206ce0 <default_pmm_manager+0x5d8>
ffffffffc0202ee4:	00003617          	auipc	a2,0x3
ffffffffc0202ee8:	47460613          	addi	a2,a2,1140 # ffffffffc0206358 <commands+0x828>
ffffffffc0202eec:	24e00593          	li	a1,590
ffffffffc0202ef0:	00004517          	auipc	a0,0x4
ffffffffc0202ef4:	96850513          	addi	a0,a0,-1688 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202ef8:	d9afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202efc:	00004697          	auipc	a3,0x4
ffffffffc0202f00:	d4468693          	addi	a3,a3,-700 # ffffffffc0206c40 <default_pmm_manager+0x538>
ffffffffc0202f04:	00003617          	auipc	a2,0x3
ffffffffc0202f08:	45460613          	addi	a2,a2,1108 # ffffffffc0206358 <commands+0x828>
ffffffffc0202f0c:	23b00593          	li	a1,571
ffffffffc0202f10:	00004517          	auipc	a0,0x4
ffffffffc0202f14:	94850513          	addi	a0,a0,-1720 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202f18:	d7afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202f1c:	00004697          	auipc	a3,0x4
ffffffffc0202f20:	e1c68693          	addi	a3,a3,-484 # ffffffffc0206d38 <default_pmm_manager+0x630>
ffffffffc0202f24:	00003617          	auipc	a2,0x3
ffffffffc0202f28:	43460613          	addi	a2,a2,1076 # ffffffffc0206358 <commands+0x828>
ffffffffc0202f2c:	25300593          	li	a1,595
ffffffffc0202f30:	00004517          	auipc	a0,0x4
ffffffffc0202f34:	92850513          	addi	a0,a0,-1752 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202f38:	d5afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202f3c:	00004697          	auipc	a3,0x4
ffffffffc0202f40:	dbc68693          	addi	a3,a3,-580 # ffffffffc0206cf8 <default_pmm_manager+0x5f0>
ffffffffc0202f44:	00003617          	auipc	a2,0x3
ffffffffc0202f48:	41460613          	addi	a2,a2,1044 # ffffffffc0206358 <commands+0x828>
ffffffffc0202f4c:	25200593          	li	a1,594
ffffffffc0202f50:	00004517          	auipc	a0,0x4
ffffffffc0202f54:	90850513          	addi	a0,a0,-1784 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202f58:	d3afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f5c:	00004697          	auipc	a3,0x4
ffffffffc0202f60:	c6c68693          	addi	a3,a3,-916 # ffffffffc0206bc8 <default_pmm_manager+0x4c0>
ffffffffc0202f64:	00003617          	auipc	a2,0x3
ffffffffc0202f68:	3f460613          	addi	a2,a2,1012 # ffffffffc0206358 <commands+0x828>
ffffffffc0202f6c:	22d00593          	li	a1,557
ffffffffc0202f70:	00004517          	auipc	a0,0x4
ffffffffc0202f74:	8e850513          	addi	a0,a0,-1816 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202f78:	d1afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202f7c:	00004697          	auipc	a3,0x4
ffffffffc0202f80:	aec68693          	addi	a3,a3,-1300 # ffffffffc0206a68 <default_pmm_manager+0x360>
ffffffffc0202f84:	00003617          	auipc	a2,0x3
ffffffffc0202f88:	3d460613          	addi	a2,a2,980 # ffffffffc0206358 <commands+0x828>
ffffffffc0202f8c:	22c00593          	li	a1,556
ffffffffc0202f90:	00004517          	auipc	a0,0x4
ffffffffc0202f94:	8c850513          	addi	a0,a0,-1848 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202f98:	cfafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202f9c:	00004697          	auipc	a3,0x4
ffffffffc0202fa0:	c4468693          	addi	a3,a3,-956 # ffffffffc0206be0 <default_pmm_manager+0x4d8>
ffffffffc0202fa4:	00003617          	auipc	a2,0x3
ffffffffc0202fa8:	3b460613          	addi	a2,a2,948 # ffffffffc0206358 <commands+0x828>
ffffffffc0202fac:	22900593          	li	a1,553
ffffffffc0202fb0:	00004517          	auipc	a0,0x4
ffffffffc0202fb4:	8a850513          	addi	a0,a0,-1880 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202fb8:	cdafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202fbc:	00004697          	auipc	a3,0x4
ffffffffc0202fc0:	a9468693          	addi	a3,a3,-1388 # ffffffffc0206a50 <default_pmm_manager+0x348>
ffffffffc0202fc4:	00003617          	auipc	a2,0x3
ffffffffc0202fc8:	39460613          	addi	a2,a2,916 # ffffffffc0206358 <commands+0x828>
ffffffffc0202fcc:	22800593          	li	a1,552
ffffffffc0202fd0:	00004517          	auipc	a0,0x4
ffffffffc0202fd4:	88850513          	addi	a0,a0,-1912 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202fd8:	cbafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202fdc:	00004697          	auipc	a3,0x4
ffffffffc0202fe0:	b1468693          	addi	a3,a3,-1260 # ffffffffc0206af0 <default_pmm_manager+0x3e8>
ffffffffc0202fe4:	00003617          	auipc	a2,0x3
ffffffffc0202fe8:	37460613          	addi	a2,a2,884 # ffffffffc0206358 <commands+0x828>
ffffffffc0202fec:	22700593          	li	a1,551
ffffffffc0202ff0:	00004517          	auipc	a0,0x4
ffffffffc0202ff4:	86850513          	addi	a0,a0,-1944 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0202ff8:	c9afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202ffc:	00004697          	auipc	a3,0x4
ffffffffc0203000:	bcc68693          	addi	a3,a3,-1076 # ffffffffc0206bc8 <default_pmm_manager+0x4c0>
ffffffffc0203004:	00003617          	auipc	a2,0x3
ffffffffc0203008:	35460613          	addi	a2,a2,852 # ffffffffc0206358 <commands+0x828>
ffffffffc020300c:	22600593          	li	a1,550
ffffffffc0203010:	00004517          	auipc	a0,0x4
ffffffffc0203014:	84850513          	addi	a0,a0,-1976 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203018:	c7afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc020301c:	00004697          	auipc	a3,0x4
ffffffffc0203020:	b9468693          	addi	a3,a3,-1132 # ffffffffc0206bb0 <default_pmm_manager+0x4a8>
ffffffffc0203024:	00003617          	auipc	a2,0x3
ffffffffc0203028:	33460613          	addi	a2,a2,820 # ffffffffc0206358 <commands+0x828>
ffffffffc020302c:	22500593          	li	a1,549
ffffffffc0203030:	00004517          	auipc	a0,0x4
ffffffffc0203034:	82850513          	addi	a0,a0,-2008 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203038:	c5afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc020303c:	00004697          	auipc	a3,0x4
ffffffffc0203040:	b4468693          	addi	a3,a3,-1212 # ffffffffc0206b80 <default_pmm_manager+0x478>
ffffffffc0203044:	00003617          	auipc	a2,0x3
ffffffffc0203048:	31460613          	addi	a2,a2,788 # ffffffffc0206358 <commands+0x828>
ffffffffc020304c:	22400593          	li	a1,548
ffffffffc0203050:	00004517          	auipc	a0,0x4
ffffffffc0203054:	80850513          	addi	a0,a0,-2040 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203058:	c3afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc020305c:	00004697          	auipc	a3,0x4
ffffffffc0203060:	b0c68693          	addi	a3,a3,-1268 # ffffffffc0206b68 <default_pmm_manager+0x460>
ffffffffc0203064:	00003617          	auipc	a2,0x3
ffffffffc0203068:	2f460613          	addi	a2,a2,756 # ffffffffc0206358 <commands+0x828>
ffffffffc020306c:	22200593          	li	a1,546
ffffffffc0203070:	00003517          	auipc	a0,0x3
ffffffffc0203074:	7e850513          	addi	a0,a0,2024 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203078:	c1afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020307c:	00004697          	auipc	a3,0x4
ffffffffc0203080:	acc68693          	addi	a3,a3,-1332 # ffffffffc0206b48 <default_pmm_manager+0x440>
ffffffffc0203084:	00003617          	auipc	a2,0x3
ffffffffc0203088:	2d460613          	addi	a2,a2,724 # ffffffffc0206358 <commands+0x828>
ffffffffc020308c:	22100593          	li	a1,545
ffffffffc0203090:	00003517          	auipc	a0,0x3
ffffffffc0203094:	7c850513          	addi	a0,a0,1992 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203098:	bfafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(*ptep & PTE_W);
ffffffffc020309c:	00004697          	auipc	a3,0x4
ffffffffc02030a0:	a9c68693          	addi	a3,a3,-1380 # ffffffffc0206b38 <default_pmm_manager+0x430>
ffffffffc02030a4:	00003617          	auipc	a2,0x3
ffffffffc02030a8:	2b460613          	addi	a2,a2,692 # ffffffffc0206358 <commands+0x828>
ffffffffc02030ac:	22000593          	li	a1,544
ffffffffc02030b0:	00003517          	auipc	a0,0x3
ffffffffc02030b4:	7a850513          	addi	a0,a0,1960 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc02030b8:	bdafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(*ptep & PTE_U);
ffffffffc02030bc:	00004697          	auipc	a3,0x4
ffffffffc02030c0:	a6c68693          	addi	a3,a3,-1428 # ffffffffc0206b28 <default_pmm_manager+0x420>
ffffffffc02030c4:	00003617          	auipc	a2,0x3
ffffffffc02030c8:	29460613          	addi	a2,a2,660 # ffffffffc0206358 <commands+0x828>
ffffffffc02030cc:	21f00593          	li	a1,543
ffffffffc02030d0:	00003517          	auipc	a0,0x3
ffffffffc02030d4:	78850513          	addi	a0,a0,1928 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc02030d8:	bbafd0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("DTB memory info not available");
ffffffffc02030dc:	00003617          	auipc	a2,0x3
ffffffffc02030e0:	7ec60613          	addi	a2,a2,2028 # ffffffffc02068c8 <default_pmm_manager+0x1c0>
ffffffffc02030e4:	06500593          	li	a1,101
ffffffffc02030e8:	00003517          	auipc	a0,0x3
ffffffffc02030ec:	77050513          	addi	a0,a0,1904 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc02030f0:	ba2fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02030f4:	00004697          	auipc	a3,0x4
ffffffffc02030f8:	b4c68693          	addi	a3,a3,-1204 # ffffffffc0206c40 <default_pmm_manager+0x538>
ffffffffc02030fc:	00003617          	auipc	a2,0x3
ffffffffc0203100:	25c60613          	addi	a2,a2,604 # ffffffffc0206358 <commands+0x828>
ffffffffc0203104:	26500593          	li	a1,613
ffffffffc0203108:	00003517          	auipc	a0,0x3
ffffffffc020310c:	75050513          	addi	a0,a0,1872 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203110:	b82fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203114:	00004697          	auipc	a3,0x4
ffffffffc0203118:	9dc68693          	addi	a3,a3,-1572 # ffffffffc0206af0 <default_pmm_manager+0x3e8>
ffffffffc020311c:	00003617          	auipc	a2,0x3
ffffffffc0203120:	23c60613          	addi	a2,a2,572 # ffffffffc0206358 <commands+0x828>
ffffffffc0203124:	21e00593          	li	a1,542
ffffffffc0203128:	00003517          	auipc	a0,0x3
ffffffffc020312c:	73050513          	addi	a0,a0,1840 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203130:	b62fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203134:	00004697          	auipc	a3,0x4
ffffffffc0203138:	97c68693          	addi	a3,a3,-1668 # ffffffffc0206ab0 <default_pmm_manager+0x3a8>
ffffffffc020313c:	00003617          	auipc	a2,0x3
ffffffffc0203140:	21c60613          	addi	a2,a2,540 # ffffffffc0206358 <commands+0x828>
ffffffffc0203144:	21d00593          	li	a1,541
ffffffffc0203148:	00003517          	auipc	a0,0x3
ffffffffc020314c:	71050513          	addi	a0,a0,1808 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203150:	b42fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203154:	86d6                	mv	a3,s5
ffffffffc0203156:	00003617          	auipc	a2,0x3
ffffffffc020315a:	5ea60613          	addi	a2,a2,1514 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc020315e:	21900593          	li	a1,537
ffffffffc0203162:	00003517          	auipc	a0,0x3
ffffffffc0203166:	6f650513          	addi	a0,a0,1782 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc020316a:	b28fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020316e:	00003617          	auipc	a2,0x3
ffffffffc0203172:	5d260613          	addi	a2,a2,1490 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc0203176:	21800593          	li	a1,536
ffffffffc020317a:	00003517          	auipc	a0,0x3
ffffffffc020317e:	6de50513          	addi	a0,a0,1758 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203182:	b10fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203186:	00004697          	auipc	a3,0x4
ffffffffc020318a:	8e268693          	addi	a3,a3,-1822 # ffffffffc0206a68 <default_pmm_manager+0x360>
ffffffffc020318e:	00003617          	auipc	a2,0x3
ffffffffc0203192:	1ca60613          	addi	a2,a2,458 # ffffffffc0206358 <commands+0x828>
ffffffffc0203196:	21600593          	li	a1,534
ffffffffc020319a:	00003517          	auipc	a0,0x3
ffffffffc020319e:	6be50513          	addi	a0,a0,1726 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc02031a2:	af0fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02031a6:	00004697          	auipc	a3,0x4
ffffffffc02031aa:	8aa68693          	addi	a3,a3,-1878 # ffffffffc0206a50 <default_pmm_manager+0x348>
ffffffffc02031ae:	00003617          	auipc	a2,0x3
ffffffffc02031b2:	1aa60613          	addi	a2,a2,426 # ffffffffc0206358 <commands+0x828>
ffffffffc02031b6:	21500593          	li	a1,533
ffffffffc02031ba:	00003517          	auipc	a0,0x3
ffffffffc02031be:	69e50513          	addi	a0,a0,1694 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc02031c2:	ad0fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02031c6:	00004697          	auipc	a3,0x4
ffffffffc02031ca:	c3a68693          	addi	a3,a3,-966 # ffffffffc0206e00 <default_pmm_manager+0x6f8>
ffffffffc02031ce:	00003617          	auipc	a2,0x3
ffffffffc02031d2:	18a60613          	addi	a2,a2,394 # ffffffffc0206358 <commands+0x828>
ffffffffc02031d6:	25c00593          	li	a1,604
ffffffffc02031da:	00003517          	auipc	a0,0x3
ffffffffc02031de:	67e50513          	addi	a0,a0,1662 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc02031e2:	ab0fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02031e6:	00004697          	auipc	a3,0x4
ffffffffc02031ea:	be268693          	addi	a3,a3,-1054 # ffffffffc0206dc8 <default_pmm_manager+0x6c0>
ffffffffc02031ee:	00003617          	auipc	a2,0x3
ffffffffc02031f2:	16a60613          	addi	a2,a2,362 # ffffffffc0206358 <commands+0x828>
ffffffffc02031f6:	25900593          	li	a1,601
ffffffffc02031fa:	00003517          	auipc	a0,0x3
ffffffffc02031fe:	65e50513          	addi	a0,a0,1630 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203202:	a90fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203206:	00004697          	auipc	a3,0x4
ffffffffc020320a:	b9268693          	addi	a3,a3,-1134 # ffffffffc0206d98 <default_pmm_manager+0x690>
ffffffffc020320e:	00003617          	auipc	a2,0x3
ffffffffc0203212:	14a60613          	addi	a2,a2,330 # ffffffffc0206358 <commands+0x828>
ffffffffc0203216:	25500593          	li	a1,597
ffffffffc020321a:	00003517          	auipc	a0,0x3
ffffffffc020321e:	63e50513          	addi	a0,a0,1598 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203222:	a70fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203226:	00004697          	auipc	a3,0x4
ffffffffc020322a:	b2a68693          	addi	a3,a3,-1238 # ffffffffc0206d50 <default_pmm_manager+0x648>
ffffffffc020322e:	00003617          	auipc	a2,0x3
ffffffffc0203232:	12a60613          	addi	a2,a2,298 # ffffffffc0206358 <commands+0x828>
ffffffffc0203236:	25400593          	li	a1,596
ffffffffc020323a:	00003517          	auipc	a0,0x3
ffffffffc020323e:	61e50513          	addi	a0,a0,1566 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203242:	a50fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0203246:	00003617          	auipc	a2,0x3
ffffffffc020324a:	5a260613          	addi	a2,a2,1442 # ffffffffc02067e8 <default_pmm_manager+0xe0>
ffffffffc020324e:	0c900593          	li	a1,201
ffffffffc0203252:	00003517          	auipc	a0,0x3
ffffffffc0203256:	60650513          	addi	a0,a0,1542 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc020325a:	a38fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020325e:	00003617          	auipc	a2,0x3
ffffffffc0203262:	58a60613          	addi	a2,a2,1418 # ffffffffc02067e8 <default_pmm_manager+0xe0>
ffffffffc0203266:	08100593          	li	a1,129
ffffffffc020326a:	00003517          	auipc	a0,0x3
ffffffffc020326e:	5ee50513          	addi	a0,a0,1518 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203272:	a20fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203276:	00003697          	auipc	a3,0x3
ffffffffc020327a:	7aa68693          	addi	a3,a3,1962 # ffffffffc0206a20 <default_pmm_manager+0x318>
ffffffffc020327e:	00003617          	auipc	a2,0x3
ffffffffc0203282:	0da60613          	addi	a2,a2,218 # ffffffffc0206358 <commands+0x828>
ffffffffc0203286:	21400593          	li	a1,532
ffffffffc020328a:	00003517          	auipc	a0,0x3
ffffffffc020328e:	5ce50513          	addi	a0,a0,1486 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203292:	a00fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203296:	00003697          	auipc	a3,0x3
ffffffffc020329a:	75a68693          	addi	a3,a3,1882 # ffffffffc02069f0 <default_pmm_manager+0x2e8>
ffffffffc020329e:	00003617          	auipc	a2,0x3
ffffffffc02032a2:	0ba60613          	addi	a2,a2,186 # ffffffffc0206358 <commands+0x828>
ffffffffc02032a6:	21100593          	li	a1,529
ffffffffc02032aa:	00003517          	auipc	a0,0x3
ffffffffc02032ae:	5ae50513          	addi	a0,a0,1454 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc02032b2:	9e0fd0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02032b6 <copy_range>:
{
ffffffffc02032b6:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02032b8:	00d667b3          	or	a5,a2,a3
{
ffffffffc02032bc:	fc86                	sd	ra,120(sp)
ffffffffc02032be:	f8a2                	sd	s0,112(sp)
ffffffffc02032c0:	f4a6                	sd	s1,104(sp)
ffffffffc02032c2:	f0ca                	sd	s2,96(sp)
ffffffffc02032c4:	ecce                	sd	s3,88(sp)
ffffffffc02032c6:	e8d2                	sd	s4,80(sp)
ffffffffc02032c8:	e4d6                	sd	s5,72(sp)
ffffffffc02032ca:	e0da                	sd	s6,64(sp)
ffffffffc02032cc:	fc5e                	sd	s7,56(sp)
ffffffffc02032ce:	f862                	sd	s8,48(sp)
ffffffffc02032d0:	f466                	sd	s9,40(sp)
ffffffffc02032d2:	f06a                	sd	s10,32(sp)
ffffffffc02032d4:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02032d6:	17d2                	slli	a5,a5,0x34
{
ffffffffc02032d8:	e03a                	sd	a4,0(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02032da:	28079163          	bnez	a5,ffffffffc020355c <copy_range+0x2a6>
    assert(USER_ACCESS(start, end));
ffffffffc02032de:	002007b7          	lui	a5,0x200
ffffffffc02032e2:	8432                	mv	s0,a2
ffffffffc02032e4:	1ef66f63          	bltu	a2,a5,ffffffffc02034e2 <copy_range+0x22c>
ffffffffc02032e8:	84b6                	mv	s1,a3
ffffffffc02032ea:	1ed67c63          	bgeu	a2,a3,ffffffffc02034e2 <copy_range+0x22c>
ffffffffc02032ee:	4785                	li	a5,1
ffffffffc02032f0:	07fe                	slli	a5,a5,0x1f
ffffffffc02032f2:	1ed7e863          	bltu	a5,a3,ffffffffc02034e2 <copy_range+0x22c>
ffffffffc02032f6:	5bfd                	li	s7,-1
ffffffffc02032f8:	8a2a                	mv	s4,a0
ffffffffc02032fa:	892e                	mv	s2,a1
        start += PGSIZE;
ffffffffc02032fc:	6985                	lui	s3,0x1
    if (PPN(pa) >= npage)
ffffffffc02032fe:	000c4b17          	auipc	s6,0xc4
ffffffffc0203302:	80ab0b13          	addi	s6,s6,-2038 # ffffffffc02c6b08 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0203306:	000c4a97          	auipc	s5,0xc4
ffffffffc020330a:	80aa8a93          	addi	s5,s5,-2038 # ffffffffc02c6b10 <pages>
ffffffffc020330e:	fff80cb7          	lui	s9,0xfff80
    return KADDR(page2pa(page));
ffffffffc0203312:	00cbdb93          	srli	s7,s7,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc0203316:	000c4d17          	auipc	s10,0xc4
ffffffffc020331a:	802d0d13          	addi	s10,s10,-2046 # ffffffffc02c6b18 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc020331e:	4601                	li	a2,0
ffffffffc0203320:	85a2                	mv	a1,s0
ffffffffc0203322:	854a                	mv	a0,s2
ffffffffc0203324:	b6dfe0ef          	jal	ra,ffffffffc0201e90 <get_pte>
ffffffffc0203328:	8c2a                	mv	s8,a0
        if (ptep == NULL)
ffffffffc020332a:	12050363          	beqz	a0,ffffffffc0203450 <copy_range+0x19a>
        if (*ptep & PTE_V)
ffffffffc020332e:	6118                	ld	a4,0(a0)
ffffffffc0203330:	8b05                	andi	a4,a4,1
ffffffffc0203332:	e705                	bnez	a4,ffffffffc020335a <copy_range+0xa4>
        start += PGSIZE;
ffffffffc0203334:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc0203336:	fe9464e3          	bltu	s0,s1,ffffffffc020331e <copy_range+0x68>
    return 0;
ffffffffc020333a:	4501                	li	a0,0
}
ffffffffc020333c:	70e6                	ld	ra,120(sp)
ffffffffc020333e:	7446                	ld	s0,112(sp)
ffffffffc0203340:	74a6                	ld	s1,104(sp)
ffffffffc0203342:	7906                	ld	s2,96(sp)
ffffffffc0203344:	69e6                	ld	s3,88(sp)
ffffffffc0203346:	6a46                	ld	s4,80(sp)
ffffffffc0203348:	6aa6                	ld	s5,72(sp)
ffffffffc020334a:	6b06                	ld	s6,64(sp)
ffffffffc020334c:	7be2                	ld	s7,56(sp)
ffffffffc020334e:	7c42                	ld	s8,48(sp)
ffffffffc0203350:	7ca2                	ld	s9,40(sp)
ffffffffc0203352:	7d02                	ld	s10,32(sp)
ffffffffc0203354:	6de2                	ld	s11,24(sp)
ffffffffc0203356:	6109                	addi	sp,sp,128
ffffffffc0203358:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc020335a:	4605                	li	a2,1
ffffffffc020335c:	85a2                	mv	a1,s0
ffffffffc020335e:	8552                	mv	a0,s4
ffffffffc0203360:	b31fe0ef          	jal	ra,ffffffffc0201e90 <get_pte>
ffffffffc0203364:	12050863          	beqz	a0,ffffffffc0203494 <copy_range+0x1de>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203368:	000c3783          	ld	a5,0(s8)
    if (!(pte & PTE_V))
ffffffffc020336c:	0017f713          	andi	a4,a5,1
ffffffffc0203370:	01f7fc13          	andi	s8,a5,31
ffffffffc0203374:	14070b63          	beqz	a4,ffffffffc02034ca <copy_range+0x214>
    if (PPN(pa) >= npage)
ffffffffc0203378:	000b3703          	ld	a4,0(s6)
    return pa2page(PTE_ADDR(pte));
ffffffffc020337c:	078a                	slli	a5,a5,0x2
ffffffffc020337e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203380:	10e7fc63          	bgeu	a5,a4,ffffffffc0203498 <copy_range+0x1e2>
    return &pages[PPN(pa) - nbase];
ffffffffc0203384:	000ab583          	ld	a1,0(s5)
ffffffffc0203388:	97e6                	add	a5,a5,s9
ffffffffc020338a:	079a                	slli	a5,a5,0x6
ffffffffc020338c:	95be                	add	a1,a1,a5
            assert(page != NULL);
ffffffffc020338e:	1a058763          	beqz	a1,ffffffffc020353c <copy_range+0x286>
            if (share)
ffffffffc0203392:	6782                	ld	a5,0(sp)
ffffffffc0203394:	e3dd                	bnez	a5,ffffffffc020343a <copy_range+0x184>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203396:	100027f3          	csrr	a5,sstatus
ffffffffc020339a:	8b89                	andi	a5,a5,2
ffffffffc020339c:	e42e                	sd	a1,8(sp)
ffffffffc020339e:	e7e1                	bnez	a5,ffffffffc0203466 <copy_range+0x1b0>
        page = pmm_manager->alloc_pages(n);
ffffffffc02033a0:	000d3783          	ld	a5,0(s10)
ffffffffc02033a4:	4505                	li	a0,1
ffffffffc02033a6:	6f9c                	ld	a5,24(a5)
ffffffffc02033a8:	9782                	jalr	a5
ffffffffc02033aa:	65a2                	ld	a1,8(sp)
ffffffffc02033ac:	8daa                	mv	s11,a0
                assert(npage != NULL);
ffffffffc02033ae:	160d8763          	beqz	s11,ffffffffc020351c <copy_range+0x266>
    return page - pages + nbase;
ffffffffc02033b2:	000ab703          	ld	a4,0(s5)
ffffffffc02033b6:	000808b7          	lui	a7,0x80
    return KADDR(page2pa(page));
ffffffffc02033ba:	000b3603          	ld	a2,0(s6)
    return page - pages + nbase;
ffffffffc02033be:	40e587b3          	sub	a5,a1,a4
ffffffffc02033c2:	8799                	srai	a5,a5,0x6
ffffffffc02033c4:	97c6                	add	a5,a5,a7
    return KADDR(page2pa(page));
ffffffffc02033c6:	0177f5b3          	and	a1,a5,s7
    return page2ppn(page) << PGSHIFT;
ffffffffc02033ca:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc02033cc:	12c5fb63          	bgeu	a1,a2,ffffffffc0203502 <copy_range+0x24c>
    return page - pages + nbase;
ffffffffc02033d0:	40ed8733          	sub	a4,s11,a4
    return KADDR(page2pa(page));
ffffffffc02033d4:	000c3697          	auipc	a3,0xc3
ffffffffc02033d8:	74c68693          	addi	a3,a3,1868 # ffffffffc02c6b20 <va_pa_offset>
ffffffffc02033dc:	6288                	ld	a0,0(a3)
    return page - pages + nbase;
ffffffffc02033de:	8719                	srai	a4,a4,0x6
ffffffffc02033e0:	9746                	add	a4,a4,a7
    return KADDR(page2pa(page));
ffffffffc02033e2:	017778b3          	and	a7,a4,s7
ffffffffc02033e6:	00a785b3          	add	a1,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc02033ea:	0732                	slli	a4,a4,0xc
    return KADDR(page2pa(page));
ffffffffc02033ec:	0cc8f263          	bgeu	a7,a2,ffffffffc02034b0 <copy_range+0x1fa>
                memcpy(dst_kva, src_kva, PGSIZE);
ffffffffc02033f0:	6605                	lui	a2,0x1
ffffffffc02033f2:	953a                	add	a0,a0,a4
ffffffffc02033f4:	4b8020ef          	jal	ra,ffffffffc02058ac <memcpy>
                ret = page_insert(to, npage, start, perm);
ffffffffc02033f8:	86e2                	mv	a3,s8
ffffffffc02033fa:	8622                	mv	a2,s0
ffffffffc02033fc:	85ee                	mv	a1,s11
ffffffffc02033fe:	8552                	mv	a0,s4
ffffffffc0203400:	980ff0ef          	jal	ra,ffffffffc0202580 <page_insert>
                if (ret != 0)
ffffffffc0203404:	d905                	beqz	a0,ffffffffc0203334 <copy_range+0x7e>
ffffffffc0203406:	100027f3          	csrr	a5,sstatus
ffffffffc020340a:	8b89                	andi	a5,a5,2
ffffffffc020340c:	ebad                	bnez	a5,ffffffffc020347e <copy_range+0x1c8>
        pmm_manager->free_pages(base, n);
ffffffffc020340e:	000d3783          	ld	a5,0(s10)
ffffffffc0203412:	4585                	li	a1,1
ffffffffc0203414:	856e                	mv	a0,s11
ffffffffc0203416:	739c                	ld	a5,32(a5)
ffffffffc0203418:	9782                	jalr	a5
            assert(ret == 0);
ffffffffc020341a:	00004697          	auipc	a3,0x4
ffffffffc020341e:	a4e68693          	addi	a3,a3,-1458 # ffffffffc0206e68 <default_pmm_manager+0x760>
ffffffffc0203422:	00003617          	auipc	a2,0x3
ffffffffc0203426:	f3660613          	addi	a2,a2,-202 # ffffffffc0206358 <commands+0x828>
ffffffffc020342a:	1a900593          	li	a1,425
ffffffffc020342e:	00003517          	auipc	a0,0x3
ffffffffc0203432:	42a50513          	addi	a0,a0,1066 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203436:	85cfd0ef          	jal	ra,ffffffffc0200492 <__panic>
    page->ref += 1;
ffffffffc020343a:	419c                	lw	a5,0(a1)
                ret = page_insert(to, page, start, perm);
ffffffffc020343c:	86e2                	mv	a3,s8
ffffffffc020343e:	8622                	mv	a2,s0
ffffffffc0203440:	2785                	addiw	a5,a5,1
ffffffffc0203442:	c19c                	sw	a5,0(a1)
ffffffffc0203444:	8552                	mv	a0,s4
ffffffffc0203446:	93aff0ef          	jal	ra,ffffffffc0202580 <page_insert>
            assert(ret == 0);
ffffffffc020344a:	f961                	bnez	a0,ffffffffc020341a <copy_range+0x164>
        start += PGSIZE;
ffffffffc020344c:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc020344e:	b5e5                	j	ffffffffc0203336 <copy_range+0x80>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203450:	00200637          	lui	a2,0x200
ffffffffc0203454:	9432                	add	s0,s0,a2
ffffffffc0203456:	ffe00637          	lui	a2,0xffe00
ffffffffc020345a:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc020345c:	ec040fe3          	beqz	s0,ffffffffc020333a <copy_range+0x84>
ffffffffc0203460:	ea946fe3          	bltu	s0,s1,ffffffffc020331e <copy_range+0x68>
ffffffffc0203464:	bdd9                	j	ffffffffc020333a <copy_range+0x84>
        intr_disable();
ffffffffc0203466:	d48fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020346a:	000d3783          	ld	a5,0(s10)
ffffffffc020346e:	4505                	li	a0,1
ffffffffc0203470:	6f9c                	ld	a5,24(a5)
ffffffffc0203472:	9782                	jalr	a5
ffffffffc0203474:	8daa                	mv	s11,a0
        intr_enable();
ffffffffc0203476:	d32fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020347a:	65a2                	ld	a1,8(sp)
ffffffffc020347c:	bf0d                	j	ffffffffc02033ae <copy_range+0xf8>
        intr_disable();
ffffffffc020347e:	d30fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0203482:	000d3783          	ld	a5,0(s10)
ffffffffc0203486:	4585                	li	a1,1
ffffffffc0203488:	856e                	mv	a0,s11
ffffffffc020348a:	739c                	ld	a5,32(a5)
ffffffffc020348c:	9782                	jalr	a5
        intr_enable();
ffffffffc020348e:	d1afd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0203492:	b761                	j	ffffffffc020341a <copy_range+0x164>
                return -E_NO_MEM;
ffffffffc0203494:	5571                	li	a0,-4
ffffffffc0203496:	b55d                	j	ffffffffc020333c <copy_range+0x86>
        panic("pa2page called with invalid pa");
ffffffffc0203498:	00003617          	auipc	a2,0x3
ffffffffc020349c:	37860613          	addi	a2,a2,888 # ffffffffc0206810 <default_pmm_manager+0x108>
ffffffffc02034a0:	06900593          	li	a1,105
ffffffffc02034a4:	00003517          	auipc	a0,0x3
ffffffffc02034a8:	2c450513          	addi	a0,a0,708 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc02034ac:	fe7fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    return KADDR(page2pa(page));
ffffffffc02034b0:	86ba                	mv	a3,a4
ffffffffc02034b2:	00003617          	auipc	a2,0x3
ffffffffc02034b6:	28e60613          	addi	a2,a2,654 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc02034ba:	07100593          	li	a1,113
ffffffffc02034be:	00003517          	auipc	a0,0x3
ffffffffc02034c2:	2aa50513          	addi	a0,a0,682 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc02034c6:	fcdfc0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02034ca:	00003617          	auipc	a2,0x3
ffffffffc02034ce:	36660613          	addi	a2,a2,870 # ffffffffc0206830 <default_pmm_manager+0x128>
ffffffffc02034d2:	07f00593          	li	a1,127
ffffffffc02034d6:	00003517          	auipc	a0,0x3
ffffffffc02034da:	29250513          	addi	a0,a0,658 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc02034de:	fb5fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02034e2:	00003697          	auipc	a3,0x3
ffffffffc02034e6:	3b668693          	addi	a3,a3,950 # ffffffffc0206898 <default_pmm_manager+0x190>
ffffffffc02034ea:	00003617          	auipc	a2,0x3
ffffffffc02034ee:	e6e60613          	addi	a2,a2,-402 # ffffffffc0206358 <commands+0x828>
ffffffffc02034f2:	17e00593          	li	a1,382
ffffffffc02034f6:	00003517          	auipc	a0,0x3
ffffffffc02034fa:	36250513          	addi	a0,a0,866 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc02034fe:	f95fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    return KADDR(page2pa(page));
ffffffffc0203502:	86be                	mv	a3,a5
ffffffffc0203504:	00003617          	auipc	a2,0x3
ffffffffc0203508:	23c60613          	addi	a2,a2,572 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc020350c:	07100593          	li	a1,113
ffffffffc0203510:	00003517          	auipc	a0,0x3
ffffffffc0203514:	25850513          	addi	a0,a0,600 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc0203518:	f7bfc0ef          	jal	ra,ffffffffc0200492 <__panic>
                assert(npage != NULL);
ffffffffc020351c:	00004697          	auipc	a3,0x4
ffffffffc0203520:	93c68693          	addi	a3,a3,-1732 # ffffffffc0206e58 <default_pmm_manager+0x750>
ffffffffc0203524:	00003617          	auipc	a2,0x3
ffffffffc0203528:	e3460613          	addi	a2,a2,-460 # ffffffffc0206358 <commands+0x828>
ffffffffc020352c:	19f00593          	li	a1,415
ffffffffc0203530:	00003517          	auipc	a0,0x3
ffffffffc0203534:	32850513          	addi	a0,a0,808 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203538:	f5bfc0ef          	jal	ra,ffffffffc0200492 <__panic>
            assert(page != NULL);
ffffffffc020353c:	00004697          	auipc	a3,0x4
ffffffffc0203540:	90c68693          	addi	a3,a3,-1780 # ffffffffc0206e48 <default_pmm_manager+0x740>
ffffffffc0203544:	00003617          	auipc	a2,0x3
ffffffffc0203548:	e1460613          	addi	a2,a2,-492 # ffffffffc0206358 <commands+0x828>
ffffffffc020354c:	19400593          	li	a1,404
ffffffffc0203550:	00003517          	auipc	a0,0x3
ffffffffc0203554:	30850513          	addi	a0,a0,776 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203558:	f3bfc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020355c:	00003697          	auipc	a3,0x3
ffffffffc0203560:	30c68693          	addi	a3,a3,780 # ffffffffc0206868 <default_pmm_manager+0x160>
ffffffffc0203564:	00003617          	auipc	a2,0x3
ffffffffc0203568:	df460613          	addi	a2,a2,-524 # ffffffffc0206358 <commands+0x828>
ffffffffc020356c:	17d00593          	li	a1,381
ffffffffc0203570:	00003517          	auipc	a0,0x3
ffffffffc0203574:	2e850513          	addi	a0,a0,744 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc0203578:	f1bfc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020357c <pgdir_alloc_page>:
{
ffffffffc020357c:	7179                	addi	sp,sp,-48
ffffffffc020357e:	ec26                	sd	s1,24(sp)
ffffffffc0203580:	e84a                	sd	s2,16(sp)
ffffffffc0203582:	e052                	sd	s4,0(sp)
ffffffffc0203584:	f406                	sd	ra,40(sp)
ffffffffc0203586:	f022                	sd	s0,32(sp)
ffffffffc0203588:	e44e                	sd	s3,8(sp)
ffffffffc020358a:	8a2a                	mv	s4,a0
ffffffffc020358c:	84ae                	mv	s1,a1
ffffffffc020358e:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203590:	100027f3          	csrr	a5,sstatus
ffffffffc0203594:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc0203596:	000c3997          	auipc	s3,0xc3
ffffffffc020359a:	58298993          	addi	s3,s3,1410 # ffffffffc02c6b18 <pmm_manager>
ffffffffc020359e:	ef8d                	bnez	a5,ffffffffc02035d8 <pgdir_alloc_page+0x5c>
ffffffffc02035a0:	0009b783          	ld	a5,0(s3)
ffffffffc02035a4:	4505                	li	a0,1
ffffffffc02035a6:	6f9c                	ld	a5,24(a5)
ffffffffc02035a8:	9782                	jalr	a5
ffffffffc02035aa:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc02035ac:	cc09                	beqz	s0,ffffffffc02035c6 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc02035ae:	86ca                	mv	a3,s2
ffffffffc02035b0:	8626                	mv	a2,s1
ffffffffc02035b2:	85a2                	mv	a1,s0
ffffffffc02035b4:	8552                	mv	a0,s4
ffffffffc02035b6:	fcbfe0ef          	jal	ra,ffffffffc0202580 <page_insert>
ffffffffc02035ba:	e915                	bnez	a0,ffffffffc02035ee <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc02035bc:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc02035be:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc02035c0:	4785                	li	a5,1
ffffffffc02035c2:	04f71e63          	bne	a4,a5,ffffffffc020361e <pgdir_alloc_page+0xa2>
}
ffffffffc02035c6:	70a2                	ld	ra,40(sp)
ffffffffc02035c8:	8522                	mv	a0,s0
ffffffffc02035ca:	7402                	ld	s0,32(sp)
ffffffffc02035cc:	64e2                	ld	s1,24(sp)
ffffffffc02035ce:	6942                	ld	s2,16(sp)
ffffffffc02035d0:	69a2                	ld	s3,8(sp)
ffffffffc02035d2:	6a02                	ld	s4,0(sp)
ffffffffc02035d4:	6145                	addi	sp,sp,48
ffffffffc02035d6:	8082                	ret
        intr_disable();
ffffffffc02035d8:	bd6fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02035dc:	0009b783          	ld	a5,0(s3)
ffffffffc02035e0:	4505                	li	a0,1
ffffffffc02035e2:	6f9c                	ld	a5,24(a5)
ffffffffc02035e4:	9782                	jalr	a5
ffffffffc02035e6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02035e8:	bc0fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc02035ec:	b7c1                	j	ffffffffc02035ac <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02035ee:	100027f3          	csrr	a5,sstatus
ffffffffc02035f2:	8b89                	andi	a5,a5,2
ffffffffc02035f4:	eb89                	bnez	a5,ffffffffc0203606 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc02035f6:	0009b783          	ld	a5,0(s3)
ffffffffc02035fa:	8522                	mv	a0,s0
ffffffffc02035fc:	4585                	li	a1,1
ffffffffc02035fe:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203600:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203602:	9782                	jalr	a5
    if (flag)
ffffffffc0203604:	b7c9                	j	ffffffffc02035c6 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203606:	ba8fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc020360a:	0009b783          	ld	a5,0(s3)
ffffffffc020360e:	8522                	mv	a0,s0
ffffffffc0203610:	4585                	li	a1,1
ffffffffc0203612:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203614:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203616:	9782                	jalr	a5
        intr_enable();
ffffffffc0203618:	b90fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020361c:	b76d                	j	ffffffffc02035c6 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc020361e:	00004697          	auipc	a3,0x4
ffffffffc0203622:	85a68693          	addi	a3,a3,-1958 # ffffffffc0206e78 <default_pmm_manager+0x770>
ffffffffc0203626:	00003617          	auipc	a2,0x3
ffffffffc020362a:	d3260613          	addi	a2,a2,-718 # ffffffffc0206358 <commands+0x828>
ffffffffc020362e:	1f200593          	li	a1,498
ffffffffc0203632:	00003517          	auipc	a0,0x3
ffffffffc0203636:	22650513          	addi	a0,a0,550 # ffffffffc0206858 <default_pmm_manager+0x150>
ffffffffc020363a:	e59fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020363e <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc020363e:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0203640:	00004697          	auipc	a3,0x4
ffffffffc0203644:	85068693          	addi	a3,a3,-1968 # ffffffffc0206e90 <default_pmm_manager+0x788>
ffffffffc0203648:	00003617          	auipc	a2,0x3
ffffffffc020364c:	d1060613          	addi	a2,a2,-752 # ffffffffc0206358 <commands+0x828>
ffffffffc0203650:	07400593          	li	a1,116
ffffffffc0203654:	00004517          	auipc	a0,0x4
ffffffffc0203658:	85c50513          	addi	a0,a0,-1956 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc020365c:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc020365e:	e35fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203662 <mm_create>:
{
ffffffffc0203662:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203664:	04000513          	li	a0,64
{
ffffffffc0203668:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020366a:	d90fe0ef          	jal	ra,ffffffffc0201bfa <kmalloc>
    if (mm != NULL)
ffffffffc020366e:	cd19                	beqz	a0,ffffffffc020368c <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc0203670:	e508                	sd	a0,8(a0)
ffffffffc0203672:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203674:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203678:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc020367c:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203680:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc0203684:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc0203688:	02053c23          	sd	zero,56(a0)
}
ffffffffc020368c:	60a2                	ld	ra,8(sp)
ffffffffc020368e:	0141                	addi	sp,sp,16
ffffffffc0203690:	8082                	ret

ffffffffc0203692 <find_vma>:
{
ffffffffc0203692:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0203694:	c505                	beqz	a0,ffffffffc02036bc <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0203696:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203698:	c501                	beqz	a0,ffffffffc02036a0 <find_vma+0xe>
ffffffffc020369a:	651c                	ld	a5,8(a0)
ffffffffc020369c:	02f5f263          	bgeu	a1,a5,ffffffffc02036c0 <find_vma+0x2e>
    return listelm->next;
ffffffffc02036a0:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc02036a2:	00f68d63          	beq	a3,a5,ffffffffc02036bc <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc02036a6:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_obj___user_matrix_out_size+0x1f38e0>
ffffffffc02036aa:	00e5e663          	bltu	a1,a4,ffffffffc02036b6 <find_vma+0x24>
ffffffffc02036ae:	ff07b703          	ld	a4,-16(a5)
ffffffffc02036b2:	00e5ec63          	bltu	a1,a4,ffffffffc02036ca <find_vma+0x38>
ffffffffc02036b6:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc02036b8:	fef697e3          	bne	a3,a5,ffffffffc02036a6 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc02036bc:	4501                	li	a0,0
}
ffffffffc02036be:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02036c0:	691c                	ld	a5,16(a0)
ffffffffc02036c2:	fcf5ffe3          	bgeu	a1,a5,ffffffffc02036a0 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc02036c6:	ea88                	sd	a0,16(a3)
ffffffffc02036c8:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc02036ca:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc02036ce:	ea88                	sd	a0,16(a3)
ffffffffc02036d0:	8082                	ret

ffffffffc02036d2 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc02036d2:	6590                	ld	a2,8(a1)
ffffffffc02036d4:	0105b803          	ld	a6,16(a1)
{
ffffffffc02036d8:	1141                	addi	sp,sp,-16
ffffffffc02036da:	e406                	sd	ra,8(sp)
ffffffffc02036dc:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc02036de:	01066763          	bltu	a2,a6,ffffffffc02036ec <insert_vma_struct+0x1a>
ffffffffc02036e2:	a085                	j	ffffffffc0203742 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc02036e4:	fe87b703          	ld	a4,-24(a5)
ffffffffc02036e8:	04e66863          	bltu	a2,a4,ffffffffc0203738 <insert_vma_struct+0x66>
ffffffffc02036ec:	86be                	mv	a3,a5
ffffffffc02036ee:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc02036f0:	fef51ae3          	bne	a0,a5,ffffffffc02036e4 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc02036f4:	02a68463          	beq	a3,a0,ffffffffc020371c <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc02036f8:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc02036fc:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203700:	08e8f163          	bgeu	a7,a4,ffffffffc0203782 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203704:	04e66f63          	bltu	a2,a4,ffffffffc0203762 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0203708:	00f50a63          	beq	a0,a5,ffffffffc020371c <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020370c:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203710:	05076963          	bltu	a4,a6,ffffffffc0203762 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0203714:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203718:	02c77363          	bgeu	a4,a2,ffffffffc020373e <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc020371c:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc020371e:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0203720:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0203724:	e390                	sd	a2,0(a5)
ffffffffc0203726:	e690                	sd	a2,8(a3)
}
ffffffffc0203728:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc020372a:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc020372c:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc020372e:	0017079b          	addiw	a5,a4,1
ffffffffc0203732:	d11c                	sw	a5,32(a0)
}
ffffffffc0203734:	0141                	addi	sp,sp,16
ffffffffc0203736:	8082                	ret
    if (le_prev != list)
ffffffffc0203738:	fca690e3          	bne	a3,a0,ffffffffc02036f8 <insert_vma_struct+0x26>
ffffffffc020373c:	bfd1                	j	ffffffffc0203710 <insert_vma_struct+0x3e>
ffffffffc020373e:	f01ff0ef          	jal	ra,ffffffffc020363e <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203742:	00003697          	auipc	a3,0x3
ffffffffc0203746:	77e68693          	addi	a3,a3,1918 # ffffffffc0206ec0 <default_pmm_manager+0x7b8>
ffffffffc020374a:	00003617          	auipc	a2,0x3
ffffffffc020374e:	c0e60613          	addi	a2,a2,-1010 # ffffffffc0206358 <commands+0x828>
ffffffffc0203752:	07a00593          	li	a1,122
ffffffffc0203756:	00003517          	auipc	a0,0x3
ffffffffc020375a:	75a50513          	addi	a0,a0,1882 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc020375e:	d35fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203762:	00003697          	auipc	a3,0x3
ffffffffc0203766:	79e68693          	addi	a3,a3,1950 # ffffffffc0206f00 <default_pmm_manager+0x7f8>
ffffffffc020376a:	00003617          	auipc	a2,0x3
ffffffffc020376e:	bee60613          	addi	a2,a2,-1042 # ffffffffc0206358 <commands+0x828>
ffffffffc0203772:	07300593          	li	a1,115
ffffffffc0203776:	00003517          	auipc	a0,0x3
ffffffffc020377a:	73a50513          	addi	a0,a0,1850 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc020377e:	d15fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203782:	00003697          	auipc	a3,0x3
ffffffffc0203786:	75e68693          	addi	a3,a3,1886 # ffffffffc0206ee0 <default_pmm_manager+0x7d8>
ffffffffc020378a:	00003617          	auipc	a2,0x3
ffffffffc020378e:	bce60613          	addi	a2,a2,-1074 # ffffffffc0206358 <commands+0x828>
ffffffffc0203792:	07200593          	li	a1,114
ffffffffc0203796:	00003517          	auipc	a0,0x3
ffffffffc020379a:	71a50513          	addi	a0,a0,1818 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc020379e:	cf5fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02037a2 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc02037a2:	591c                	lw	a5,48(a0)
{
ffffffffc02037a4:	1141                	addi	sp,sp,-16
ffffffffc02037a6:	e406                	sd	ra,8(sp)
ffffffffc02037a8:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc02037aa:	e78d                	bnez	a5,ffffffffc02037d4 <mm_destroy+0x32>
ffffffffc02037ac:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc02037ae:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc02037b0:	00a40c63          	beq	s0,a0,ffffffffc02037c8 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc02037b4:	6118                	ld	a4,0(a0)
ffffffffc02037b6:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc02037b8:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02037ba:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02037bc:	e398                	sd	a4,0(a5)
ffffffffc02037be:	cecfe0ef          	jal	ra,ffffffffc0201caa <kfree>
    return listelm->next;
ffffffffc02037c2:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc02037c4:	fea418e3          	bne	s0,a0,ffffffffc02037b4 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc02037c8:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc02037ca:	6402                	ld	s0,0(sp)
ffffffffc02037cc:	60a2                	ld	ra,8(sp)
ffffffffc02037ce:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc02037d0:	cdafe06f          	j	ffffffffc0201caa <kfree>
    assert(mm_count(mm) == 0);
ffffffffc02037d4:	00003697          	auipc	a3,0x3
ffffffffc02037d8:	74c68693          	addi	a3,a3,1868 # ffffffffc0206f20 <default_pmm_manager+0x818>
ffffffffc02037dc:	00003617          	auipc	a2,0x3
ffffffffc02037e0:	b7c60613          	addi	a2,a2,-1156 # ffffffffc0206358 <commands+0x828>
ffffffffc02037e4:	09e00593          	li	a1,158
ffffffffc02037e8:	00003517          	auipc	a0,0x3
ffffffffc02037ec:	6c850513          	addi	a0,a0,1736 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc02037f0:	ca3fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02037f4 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc02037f4:	7139                	addi	sp,sp,-64
ffffffffc02037f6:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02037f8:	6405                	lui	s0,0x1
ffffffffc02037fa:	147d                	addi	s0,s0,-1
ffffffffc02037fc:	77fd                	lui	a5,0xfffff
ffffffffc02037fe:	9622                	add	a2,a2,s0
ffffffffc0203800:	962e                	add	a2,a2,a1
{
ffffffffc0203802:	f426                	sd	s1,40(sp)
ffffffffc0203804:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203806:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc020380a:	f04a                	sd	s2,32(sp)
ffffffffc020380c:	ec4e                	sd	s3,24(sp)
ffffffffc020380e:	e852                	sd	s4,16(sp)
ffffffffc0203810:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203812:	002005b7          	lui	a1,0x200
ffffffffc0203816:	00f67433          	and	s0,a2,a5
ffffffffc020381a:	06b4e363          	bltu	s1,a1,ffffffffc0203880 <mm_map+0x8c>
ffffffffc020381e:	0684f163          	bgeu	s1,s0,ffffffffc0203880 <mm_map+0x8c>
ffffffffc0203822:	4785                	li	a5,1
ffffffffc0203824:	07fe                	slli	a5,a5,0x1f
ffffffffc0203826:	0487ed63          	bltu	a5,s0,ffffffffc0203880 <mm_map+0x8c>
ffffffffc020382a:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc020382c:	cd21                	beqz	a0,ffffffffc0203884 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc020382e:	85a6                	mv	a1,s1
ffffffffc0203830:	8ab6                	mv	s5,a3
ffffffffc0203832:	8a3a                	mv	s4,a4
ffffffffc0203834:	e5fff0ef          	jal	ra,ffffffffc0203692 <find_vma>
ffffffffc0203838:	c501                	beqz	a0,ffffffffc0203840 <mm_map+0x4c>
ffffffffc020383a:	651c                	ld	a5,8(a0)
ffffffffc020383c:	0487e263          	bltu	a5,s0,ffffffffc0203880 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203840:	03000513          	li	a0,48
ffffffffc0203844:	bb6fe0ef          	jal	ra,ffffffffc0201bfa <kmalloc>
ffffffffc0203848:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc020384a:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc020384c:	02090163          	beqz	s2,ffffffffc020386e <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0203850:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc0203852:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc0203856:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc020385a:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc020385e:	85ca                	mv	a1,s2
ffffffffc0203860:	e73ff0ef          	jal	ra,ffffffffc02036d2 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc0203864:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc0203866:	000a0463          	beqz	s4,ffffffffc020386e <mm_map+0x7a>
        *vma_store = vma;
ffffffffc020386a:	012a3023          	sd	s2,0(s4)

out:
    return ret;
}
ffffffffc020386e:	70e2                	ld	ra,56(sp)
ffffffffc0203870:	7442                	ld	s0,48(sp)
ffffffffc0203872:	74a2                	ld	s1,40(sp)
ffffffffc0203874:	7902                	ld	s2,32(sp)
ffffffffc0203876:	69e2                	ld	s3,24(sp)
ffffffffc0203878:	6a42                	ld	s4,16(sp)
ffffffffc020387a:	6aa2                	ld	s5,8(sp)
ffffffffc020387c:	6121                	addi	sp,sp,64
ffffffffc020387e:	8082                	ret
        return -E_INVAL;
ffffffffc0203880:	5575                	li	a0,-3
ffffffffc0203882:	b7f5                	j	ffffffffc020386e <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc0203884:	00003697          	auipc	a3,0x3
ffffffffc0203888:	6b468693          	addi	a3,a3,1716 # ffffffffc0206f38 <default_pmm_manager+0x830>
ffffffffc020388c:	00003617          	auipc	a2,0x3
ffffffffc0203890:	acc60613          	addi	a2,a2,-1332 # ffffffffc0206358 <commands+0x828>
ffffffffc0203894:	0b300593          	li	a1,179
ffffffffc0203898:	00003517          	auipc	a0,0x3
ffffffffc020389c:	61850513          	addi	a0,a0,1560 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc02038a0:	bf3fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02038a4 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc02038a4:	7139                	addi	sp,sp,-64
ffffffffc02038a6:	fc06                	sd	ra,56(sp)
ffffffffc02038a8:	f822                	sd	s0,48(sp)
ffffffffc02038aa:	f426                	sd	s1,40(sp)
ffffffffc02038ac:	f04a                	sd	s2,32(sp)
ffffffffc02038ae:	ec4e                	sd	s3,24(sp)
ffffffffc02038b0:	e852                	sd	s4,16(sp)
ffffffffc02038b2:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc02038b4:	c52d                	beqz	a0,ffffffffc020391e <dup_mmap+0x7a>
ffffffffc02038b6:	892a                	mv	s2,a0
ffffffffc02038b8:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc02038ba:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc02038bc:	e595                	bnez	a1,ffffffffc02038e8 <dup_mmap+0x44>
ffffffffc02038be:	a085                	j	ffffffffc020391e <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc02038c0:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc02038c2:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_matrix_out_size+0x1f3900>
        vma->vm_end = vm_end;
ffffffffc02038c6:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc02038ca:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc02038ce:	e05ff0ef          	jal	ra,ffffffffc02036d2 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc02038d2:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8f40>
ffffffffc02038d6:	fe843603          	ld	a2,-24(s0)
ffffffffc02038da:	6c8c                	ld	a1,24(s1)
ffffffffc02038dc:	01893503          	ld	a0,24(s2)
ffffffffc02038e0:	4701                	li	a4,0
ffffffffc02038e2:	9d5ff0ef          	jal	ra,ffffffffc02032b6 <copy_range>
ffffffffc02038e6:	e105                	bnez	a0,ffffffffc0203906 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc02038e8:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc02038ea:	02848863          	beq	s1,s0,ffffffffc020391a <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02038ee:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc02038f2:	fe843a83          	ld	s5,-24(s0)
ffffffffc02038f6:	ff043a03          	ld	s4,-16(s0)
ffffffffc02038fa:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02038fe:	afcfe0ef          	jal	ra,ffffffffc0201bfa <kmalloc>
ffffffffc0203902:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203904:	fd55                	bnez	a0,ffffffffc02038c0 <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203906:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203908:	70e2                	ld	ra,56(sp)
ffffffffc020390a:	7442                	ld	s0,48(sp)
ffffffffc020390c:	74a2                	ld	s1,40(sp)
ffffffffc020390e:	7902                	ld	s2,32(sp)
ffffffffc0203910:	69e2                	ld	s3,24(sp)
ffffffffc0203912:	6a42                	ld	s4,16(sp)
ffffffffc0203914:	6aa2                	ld	s5,8(sp)
ffffffffc0203916:	6121                	addi	sp,sp,64
ffffffffc0203918:	8082                	ret
    return 0;
ffffffffc020391a:	4501                	li	a0,0
ffffffffc020391c:	b7f5                	j	ffffffffc0203908 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc020391e:	00003697          	auipc	a3,0x3
ffffffffc0203922:	62a68693          	addi	a3,a3,1578 # ffffffffc0206f48 <default_pmm_manager+0x840>
ffffffffc0203926:	00003617          	auipc	a2,0x3
ffffffffc020392a:	a3260613          	addi	a2,a2,-1486 # ffffffffc0206358 <commands+0x828>
ffffffffc020392e:	0cf00593          	li	a1,207
ffffffffc0203932:	00003517          	auipc	a0,0x3
ffffffffc0203936:	57e50513          	addi	a0,a0,1406 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc020393a:	b59fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020393e <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc020393e:	1101                	addi	sp,sp,-32
ffffffffc0203940:	ec06                	sd	ra,24(sp)
ffffffffc0203942:	e822                	sd	s0,16(sp)
ffffffffc0203944:	e426                	sd	s1,8(sp)
ffffffffc0203946:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203948:	c531                	beqz	a0,ffffffffc0203994 <exit_mmap+0x56>
ffffffffc020394a:	591c                	lw	a5,48(a0)
ffffffffc020394c:	84aa                	mv	s1,a0
ffffffffc020394e:	e3b9                	bnez	a5,ffffffffc0203994 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203950:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203952:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203956:	02850663          	beq	a0,s0,ffffffffc0203982 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc020395a:	ff043603          	ld	a2,-16(s0)
ffffffffc020395e:	fe843583          	ld	a1,-24(s0)
ffffffffc0203962:	854a                	mv	a0,s2
ffffffffc0203964:	fa8fe0ef          	jal	ra,ffffffffc020210c <unmap_range>
ffffffffc0203968:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc020396a:	fe8498e3          	bne	s1,s0,ffffffffc020395a <exit_mmap+0x1c>
ffffffffc020396e:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203970:	00848c63          	beq	s1,s0,ffffffffc0203988 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203974:	ff043603          	ld	a2,-16(s0)
ffffffffc0203978:	fe843583          	ld	a1,-24(s0)
ffffffffc020397c:	854a                	mv	a0,s2
ffffffffc020397e:	8d5fe0ef          	jal	ra,ffffffffc0202252 <exit_range>
ffffffffc0203982:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203984:	fe8498e3          	bne	s1,s0,ffffffffc0203974 <exit_mmap+0x36>
    }
}
ffffffffc0203988:	60e2                	ld	ra,24(sp)
ffffffffc020398a:	6442                	ld	s0,16(sp)
ffffffffc020398c:	64a2                	ld	s1,8(sp)
ffffffffc020398e:	6902                	ld	s2,0(sp)
ffffffffc0203990:	6105                	addi	sp,sp,32
ffffffffc0203992:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203994:	00003697          	auipc	a3,0x3
ffffffffc0203998:	5d468693          	addi	a3,a3,1492 # ffffffffc0206f68 <default_pmm_manager+0x860>
ffffffffc020399c:	00003617          	auipc	a2,0x3
ffffffffc02039a0:	9bc60613          	addi	a2,a2,-1604 # ffffffffc0206358 <commands+0x828>
ffffffffc02039a4:	0e800593          	li	a1,232
ffffffffc02039a8:	00003517          	auipc	a0,0x3
ffffffffc02039ac:	50850513          	addi	a0,a0,1288 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc02039b0:	ae3fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02039b4 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc02039b4:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02039b6:	04000513          	li	a0,64
{
ffffffffc02039ba:	fc06                	sd	ra,56(sp)
ffffffffc02039bc:	f822                	sd	s0,48(sp)
ffffffffc02039be:	f426                	sd	s1,40(sp)
ffffffffc02039c0:	f04a                	sd	s2,32(sp)
ffffffffc02039c2:	ec4e                	sd	s3,24(sp)
ffffffffc02039c4:	e852                	sd	s4,16(sp)
ffffffffc02039c6:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02039c8:	a32fe0ef          	jal	ra,ffffffffc0201bfa <kmalloc>
    if (mm != NULL)
ffffffffc02039cc:	2e050663          	beqz	a0,ffffffffc0203cb8 <vmm_init+0x304>
ffffffffc02039d0:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc02039d2:	e508                	sd	a0,8(a0)
ffffffffc02039d4:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02039d6:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02039da:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02039de:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02039e2:	02053423          	sd	zero,40(a0)
ffffffffc02039e6:	02052823          	sw	zero,48(a0)
ffffffffc02039ea:	02053c23          	sd	zero,56(a0)
ffffffffc02039ee:	03200413          	li	s0,50
ffffffffc02039f2:	a811                	j	ffffffffc0203a06 <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc02039f4:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc02039f6:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc02039f8:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc02039fc:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc02039fe:	8526                	mv	a0,s1
ffffffffc0203a00:	cd3ff0ef          	jal	ra,ffffffffc02036d2 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203a04:	c80d                	beqz	s0,ffffffffc0203a36 <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a06:	03000513          	li	a0,48
ffffffffc0203a0a:	9f0fe0ef          	jal	ra,ffffffffc0201bfa <kmalloc>
ffffffffc0203a0e:	85aa                	mv	a1,a0
ffffffffc0203a10:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203a14:	f165                	bnez	a0,ffffffffc02039f4 <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203a16:	00003697          	auipc	a3,0x3
ffffffffc0203a1a:	6ea68693          	addi	a3,a3,1770 # ffffffffc0207100 <default_pmm_manager+0x9f8>
ffffffffc0203a1e:	00003617          	auipc	a2,0x3
ffffffffc0203a22:	93a60613          	addi	a2,a2,-1734 # ffffffffc0206358 <commands+0x828>
ffffffffc0203a26:	12c00593          	li	a1,300
ffffffffc0203a2a:	00003517          	auipc	a0,0x3
ffffffffc0203a2e:	48650513          	addi	a0,a0,1158 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203a32:	a61fc0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc0203a36:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203a3a:	1f900913          	li	s2,505
ffffffffc0203a3e:	a819                	j	ffffffffc0203a54 <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203a40:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203a42:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a44:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203a48:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203a4a:	8526                	mv	a0,s1
ffffffffc0203a4c:	c87ff0ef          	jal	ra,ffffffffc02036d2 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203a50:	03240a63          	beq	s0,s2,ffffffffc0203a84 <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a54:	03000513          	li	a0,48
ffffffffc0203a58:	9a2fe0ef          	jal	ra,ffffffffc0201bfa <kmalloc>
ffffffffc0203a5c:	85aa                	mv	a1,a0
ffffffffc0203a5e:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203a62:	fd79                	bnez	a0,ffffffffc0203a40 <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203a64:	00003697          	auipc	a3,0x3
ffffffffc0203a68:	69c68693          	addi	a3,a3,1692 # ffffffffc0207100 <default_pmm_manager+0x9f8>
ffffffffc0203a6c:	00003617          	auipc	a2,0x3
ffffffffc0203a70:	8ec60613          	addi	a2,a2,-1812 # ffffffffc0206358 <commands+0x828>
ffffffffc0203a74:	13300593          	li	a1,307
ffffffffc0203a78:	00003517          	auipc	a0,0x3
ffffffffc0203a7c:	43850513          	addi	a0,a0,1080 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203a80:	a13fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    return listelm->next;
ffffffffc0203a84:	649c                	ld	a5,8(s1)
ffffffffc0203a86:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203a88:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203a8c:	16f48663          	beq	s1,a5,ffffffffc0203bf8 <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203a90:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd38490>
ffffffffc0203a94:	ffe70693          	addi	a3,a4,-2 # ffe <_binary_obj___user_faultread_out_size-0x8f32>
ffffffffc0203a98:	10d61063          	bne	a2,a3,ffffffffc0203b98 <vmm_init+0x1e4>
ffffffffc0203a9c:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203aa0:	0ed71c63          	bne	a4,a3,ffffffffc0203b98 <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203aa4:	0715                	addi	a4,a4,5
ffffffffc0203aa6:	679c                	ld	a5,8(a5)
ffffffffc0203aa8:	feb712e3          	bne	a4,a1,ffffffffc0203a8c <vmm_init+0xd8>
ffffffffc0203aac:	4a1d                	li	s4,7
ffffffffc0203aae:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203ab0:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203ab4:	85a2                	mv	a1,s0
ffffffffc0203ab6:	8526                	mv	a0,s1
ffffffffc0203ab8:	bdbff0ef          	jal	ra,ffffffffc0203692 <find_vma>
ffffffffc0203abc:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203abe:	16050d63          	beqz	a0,ffffffffc0203c38 <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203ac2:	00140593          	addi	a1,s0,1
ffffffffc0203ac6:	8526                	mv	a0,s1
ffffffffc0203ac8:	bcbff0ef          	jal	ra,ffffffffc0203692 <find_vma>
ffffffffc0203acc:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203ace:	14050563          	beqz	a0,ffffffffc0203c18 <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203ad2:	85d2                	mv	a1,s4
ffffffffc0203ad4:	8526                	mv	a0,s1
ffffffffc0203ad6:	bbdff0ef          	jal	ra,ffffffffc0203692 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203ada:	16051f63          	bnez	a0,ffffffffc0203c58 <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203ade:	00340593          	addi	a1,s0,3
ffffffffc0203ae2:	8526                	mv	a0,s1
ffffffffc0203ae4:	bafff0ef          	jal	ra,ffffffffc0203692 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203ae8:	1a051863          	bnez	a0,ffffffffc0203c98 <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203aec:	00440593          	addi	a1,s0,4
ffffffffc0203af0:	8526                	mv	a0,s1
ffffffffc0203af2:	ba1ff0ef          	jal	ra,ffffffffc0203692 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203af6:	18051163          	bnez	a0,ffffffffc0203c78 <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203afa:	00893783          	ld	a5,8(s2)
ffffffffc0203afe:	0a879d63          	bne	a5,s0,ffffffffc0203bb8 <vmm_init+0x204>
ffffffffc0203b02:	01093783          	ld	a5,16(s2)
ffffffffc0203b06:	0b479963          	bne	a5,s4,ffffffffc0203bb8 <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b0a:	0089b783          	ld	a5,8(s3)
ffffffffc0203b0e:	0c879563          	bne	a5,s0,ffffffffc0203bd8 <vmm_init+0x224>
ffffffffc0203b12:	0109b783          	ld	a5,16(s3)
ffffffffc0203b16:	0d479163          	bne	a5,s4,ffffffffc0203bd8 <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203b1a:	0415                	addi	s0,s0,5
ffffffffc0203b1c:	0a15                	addi	s4,s4,5
ffffffffc0203b1e:	f9541be3          	bne	s0,s5,ffffffffc0203ab4 <vmm_init+0x100>
ffffffffc0203b22:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203b24:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203b26:	85a2                	mv	a1,s0
ffffffffc0203b28:	8526                	mv	a0,s1
ffffffffc0203b2a:	b69ff0ef          	jal	ra,ffffffffc0203692 <find_vma>
ffffffffc0203b2e:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203b32:	c90d                	beqz	a0,ffffffffc0203b64 <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203b34:	6914                	ld	a3,16(a0)
ffffffffc0203b36:	6510                	ld	a2,8(a0)
ffffffffc0203b38:	00003517          	auipc	a0,0x3
ffffffffc0203b3c:	55050513          	addi	a0,a0,1360 # ffffffffc0207088 <default_pmm_manager+0x980>
ffffffffc0203b40:	e58fc0ef          	jal	ra,ffffffffc0200198 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203b44:	00003697          	auipc	a3,0x3
ffffffffc0203b48:	56c68693          	addi	a3,a3,1388 # ffffffffc02070b0 <default_pmm_manager+0x9a8>
ffffffffc0203b4c:	00003617          	auipc	a2,0x3
ffffffffc0203b50:	80c60613          	addi	a2,a2,-2036 # ffffffffc0206358 <commands+0x828>
ffffffffc0203b54:	15900593          	li	a1,345
ffffffffc0203b58:	00003517          	auipc	a0,0x3
ffffffffc0203b5c:	35850513          	addi	a0,a0,856 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203b60:	933fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203b64:	147d                	addi	s0,s0,-1
ffffffffc0203b66:	fd2410e3          	bne	s0,s2,ffffffffc0203b26 <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203b6a:	8526                	mv	a0,s1
ffffffffc0203b6c:	c37ff0ef          	jal	ra,ffffffffc02037a2 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203b70:	00003517          	auipc	a0,0x3
ffffffffc0203b74:	55850513          	addi	a0,a0,1368 # ffffffffc02070c8 <default_pmm_manager+0x9c0>
ffffffffc0203b78:	e20fc0ef          	jal	ra,ffffffffc0200198 <cprintf>
}
ffffffffc0203b7c:	7442                	ld	s0,48(sp)
ffffffffc0203b7e:	70e2                	ld	ra,56(sp)
ffffffffc0203b80:	74a2                	ld	s1,40(sp)
ffffffffc0203b82:	7902                	ld	s2,32(sp)
ffffffffc0203b84:	69e2                	ld	s3,24(sp)
ffffffffc0203b86:	6a42                	ld	s4,16(sp)
ffffffffc0203b88:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203b8a:	00003517          	auipc	a0,0x3
ffffffffc0203b8e:	55e50513          	addi	a0,a0,1374 # ffffffffc02070e8 <default_pmm_manager+0x9e0>
}
ffffffffc0203b92:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203b94:	e04fc06f          	j	ffffffffc0200198 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203b98:	00003697          	auipc	a3,0x3
ffffffffc0203b9c:	40868693          	addi	a3,a3,1032 # ffffffffc0206fa0 <default_pmm_manager+0x898>
ffffffffc0203ba0:	00002617          	auipc	a2,0x2
ffffffffc0203ba4:	7b860613          	addi	a2,a2,1976 # ffffffffc0206358 <commands+0x828>
ffffffffc0203ba8:	13d00593          	li	a1,317
ffffffffc0203bac:	00003517          	auipc	a0,0x3
ffffffffc0203bb0:	30450513          	addi	a0,a0,772 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203bb4:	8dffc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203bb8:	00003697          	auipc	a3,0x3
ffffffffc0203bbc:	47068693          	addi	a3,a3,1136 # ffffffffc0207028 <default_pmm_manager+0x920>
ffffffffc0203bc0:	00002617          	auipc	a2,0x2
ffffffffc0203bc4:	79860613          	addi	a2,a2,1944 # ffffffffc0206358 <commands+0x828>
ffffffffc0203bc8:	14e00593          	li	a1,334
ffffffffc0203bcc:	00003517          	auipc	a0,0x3
ffffffffc0203bd0:	2e450513          	addi	a0,a0,740 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203bd4:	8bffc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203bd8:	00003697          	auipc	a3,0x3
ffffffffc0203bdc:	48068693          	addi	a3,a3,1152 # ffffffffc0207058 <default_pmm_manager+0x950>
ffffffffc0203be0:	00002617          	auipc	a2,0x2
ffffffffc0203be4:	77860613          	addi	a2,a2,1912 # ffffffffc0206358 <commands+0x828>
ffffffffc0203be8:	14f00593          	li	a1,335
ffffffffc0203bec:	00003517          	auipc	a0,0x3
ffffffffc0203bf0:	2c450513          	addi	a0,a0,708 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203bf4:	89ffc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203bf8:	00003697          	auipc	a3,0x3
ffffffffc0203bfc:	39068693          	addi	a3,a3,912 # ffffffffc0206f88 <default_pmm_manager+0x880>
ffffffffc0203c00:	00002617          	auipc	a2,0x2
ffffffffc0203c04:	75860613          	addi	a2,a2,1880 # ffffffffc0206358 <commands+0x828>
ffffffffc0203c08:	13b00593          	li	a1,315
ffffffffc0203c0c:	00003517          	auipc	a0,0x3
ffffffffc0203c10:	2a450513          	addi	a0,a0,676 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203c14:	87ffc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma2 != NULL);
ffffffffc0203c18:	00003697          	auipc	a3,0x3
ffffffffc0203c1c:	3d068693          	addi	a3,a3,976 # ffffffffc0206fe8 <default_pmm_manager+0x8e0>
ffffffffc0203c20:	00002617          	auipc	a2,0x2
ffffffffc0203c24:	73860613          	addi	a2,a2,1848 # ffffffffc0206358 <commands+0x828>
ffffffffc0203c28:	14600593          	li	a1,326
ffffffffc0203c2c:	00003517          	auipc	a0,0x3
ffffffffc0203c30:	28450513          	addi	a0,a0,644 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203c34:	85ffc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma1 != NULL);
ffffffffc0203c38:	00003697          	auipc	a3,0x3
ffffffffc0203c3c:	3a068693          	addi	a3,a3,928 # ffffffffc0206fd8 <default_pmm_manager+0x8d0>
ffffffffc0203c40:	00002617          	auipc	a2,0x2
ffffffffc0203c44:	71860613          	addi	a2,a2,1816 # ffffffffc0206358 <commands+0x828>
ffffffffc0203c48:	14400593          	li	a1,324
ffffffffc0203c4c:	00003517          	auipc	a0,0x3
ffffffffc0203c50:	26450513          	addi	a0,a0,612 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203c54:	83ffc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma3 == NULL);
ffffffffc0203c58:	00003697          	auipc	a3,0x3
ffffffffc0203c5c:	3a068693          	addi	a3,a3,928 # ffffffffc0206ff8 <default_pmm_manager+0x8f0>
ffffffffc0203c60:	00002617          	auipc	a2,0x2
ffffffffc0203c64:	6f860613          	addi	a2,a2,1784 # ffffffffc0206358 <commands+0x828>
ffffffffc0203c68:	14800593          	li	a1,328
ffffffffc0203c6c:	00003517          	auipc	a0,0x3
ffffffffc0203c70:	24450513          	addi	a0,a0,580 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203c74:	81ffc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma5 == NULL);
ffffffffc0203c78:	00003697          	auipc	a3,0x3
ffffffffc0203c7c:	3a068693          	addi	a3,a3,928 # ffffffffc0207018 <default_pmm_manager+0x910>
ffffffffc0203c80:	00002617          	auipc	a2,0x2
ffffffffc0203c84:	6d860613          	addi	a2,a2,1752 # ffffffffc0206358 <commands+0x828>
ffffffffc0203c88:	14c00593          	li	a1,332
ffffffffc0203c8c:	00003517          	auipc	a0,0x3
ffffffffc0203c90:	22450513          	addi	a0,a0,548 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203c94:	ffefc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma4 == NULL);
ffffffffc0203c98:	00003697          	auipc	a3,0x3
ffffffffc0203c9c:	37068693          	addi	a3,a3,880 # ffffffffc0207008 <default_pmm_manager+0x900>
ffffffffc0203ca0:	00002617          	auipc	a2,0x2
ffffffffc0203ca4:	6b860613          	addi	a2,a2,1720 # ffffffffc0206358 <commands+0x828>
ffffffffc0203ca8:	14a00593          	li	a1,330
ffffffffc0203cac:	00003517          	auipc	a0,0x3
ffffffffc0203cb0:	20450513          	addi	a0,a0,516 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203cb4:	fdefc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(mm != NULL);
ffffffffc0203cb8:	00003697          	auipc	a3,0x3
ffffffffc0203cbc:	28068693          	addi	a3,a3,640 # ffffffffc0206f38 <default_pmm_manager+0x830>
ffffffffc0203cc0:	00002617          	auipc	a2,0x2
ffffffffc0203cc4:	69860613          	addi	a2,a2,1688 # ffffffffc0206358 <commands+0x828>
ffffffffc0203cc8:	12400593          	li	a1,292
ffffffffc0203ccc:	00003517          	auipc	a0,0x3
ffffffffc0203cd0:	1e450513          	addi	a0,a0,484 # ffffffffc0206eb0 <default_pmm_manager+0x7a8>
ffffffffc0203cd4:	fbefc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203cd8 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203cd8:	7179                	addi	sp,sp,-48
ffffffffc0203cda:	f022                	sd	s0,32(sp)
ffffffffc0203cdc:	f406                	sd	ra,40(sp)
ffffffffc0203cde:	ec26                	sd	s1,24(sp)
ffffffffc0203ce0:	e84a                	sd	s2,16(sp)
ffffffffc0203ce2:	e44e                	sd	s3,8(sp)
ffffffffc0203ce4:	e052                	sd	s4,0(sp)
ffffffffc0203ce6:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203ce8:	c135                	beqz	a0,ffffffffc0203d4c <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203cea:	002007b7          	lui	a5,0x200
ffffffffc0203cee:	04f5e663          	bltu	a1,a5,ffffffffc0203d3a <user_mem_check+0x62>
ffffffffc0203cf2:	00c584b3          	add	s1,a1,a2
ffffffffc0203cf6:	0495f263          	bgeu	a1,s1,ffffffffc0203d3a <user_mem_check+0x62>
ffffffffc0203cfa:	4785                	li	a5,1
ffffffffc0203cfc:	07fe                	slli	a5,a5,0x1f
ffffffffc0203cfe:	0297ee63          	bltu	a5,s1,ffffffffc0203d3a <user_mem_check+0x62>
ffffffffc0203d02:	892a                	mv	s2,a0
ffffffffc0203d04:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d06:	6a05                	lui	s4,0x1
ffffffffc0203d08:	a821                	j	ffffffffc0203d20 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d0a:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d0e:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d10:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d12:	c685                	beqz	a3,ffffffffc0203d3a <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d14:	c399                	beqz	a5,ffffffffc0203d1a <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d16:	02e46263          	bltu	s0,a4,ffffffffc0203d3a <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203d1a:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203d1c:	04947663          	bgeu	s0,s1,ffffffffc0203d68 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203d20:	85a2                	mv	a1,s0
ffffffffc0203d22:	854a                	mv	a0,s2
ffffffffc0203d24:	96fff0ef          	jal	ra,ffffffffc0203692 <find_vma>
ffffffffc0203d28:	c909                	beqz	a0,ffffffffc0203d3a <user_mem_check+0x62>
ffffffffc0203d2a:	6518                	ld	a4,8(a0)
ffffffffc0203d2c:	00e46763          	bltu	s0,a4,ffffffffc0203d3a <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d30:	4d1c                	lw	a5,24(a0)
ffffffffc0203d32:	fc099ce3          	bnez	s3,ffffffffc0203d0a <user_mem_check+0x32>
ffffffffc0203d36:	8b85                	andi	a5,a5,1
ffffffffc0203d38:	f3ed                	bnez	a5,ffffffffc0203d1a <user_mem_check+0x42>
            return 0;
ffffffffc0203d3a:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc0203d3c:	70a2                	ld	ra,40(sp)
ffffffffc0203d3e:	7402                	ld	s0,32(sp)
ffffffffc0203d40:	64e2                	ld	s1,24(sp)
ffffffffc0203d42:	6942                	ld	s2,16(sp)
ffffffffc0203d44:	69a2                	ld	s3,8(sp)
ffffffffc0203d46:	6a02                	ld	s4,0(sp)
ffffffffc0203d48:	6145                	addi	sp,sp,48
ffffffffc0203d4a:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203d4c:	c02007b7          	lui	a5,0xc0200
ffffffffc0203d50:	4501                	li	a0,0
ffffffffc0203d52:	fef5e5e3          	bltu	a1,a5,ffffffffc0203d3c <user_mem_check+0x64>
ffffffffc0203d56:	962e                	add	a2,a2,a1
ffffffffc0203d58:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203d3c <user_mem_check+0x64>
ffffffffc0203d5c:	c8000537          	lui	a0,0xc8000
ffffffffc0203d60:	0505                	addi	a0,a0,1
ffffffffc0203d62:	00a63533          	sltu	a0,a2,a0
ffffffffc0203d66:	bfd9                	j	ffffffffc0203d3c <user_mem_check+0x64>
        return 1;
ffffffffc0203d68:	4505                	li	a0,1
ffffffffc0203d6a:	bfc9                	j	ffffffffc0203d3c <user_mem_check+0x64>

ffffffffc0203d6c <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203d6c:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203d6e:	9402                	jalr	s0

	jal do_exit
ffffffffc0203d70:	5cc000ef          	jal	ra,ffffffffc020433c <do_exit>

ffffffffc0203d74 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203d74:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203d76:	14800513          	li	a0,328
{
ffffffffc0203d7a:	e022                	sd	s0,0(sp)
ffffffffc0203d7c:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203d7e:	e7dfd0ef          	jal	ra,ffffffffc0201bfa <kmalloc>
ffffffffc0203d82:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203d84:	c941                	beqz	a0,ffffffffc0203e14 <alloc_proc+0xa0>
    // 2312773
    {
        proc->state = PROC_UNINIT;
ffffffffc0203d86:	57fd                	li	a5,-1
ffffffffc0203d88:	1782                	slli	a5,a5,0x20
ffffffffc0203d8a:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203d8c:	07000613          	li	a2,112
ffffffffc0203d90:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0203d92:	00052423          	sw	zero,8(a0) # ffffffffc8000008 <end+0x7d394b0>
        proc->kstack = 0;
ffffffffc0203d96:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203d9a:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203d9e:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203da2:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203da6:	03050513          	addi	a0,a0,48
ffffffffc0203daa:	2f1010ef          	jal	ra,ffffffffc020589a <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203dae:	000c3797          	auipc	a5,0xc3
ffffffffc0203db2:	d4a7b783          	ld	a5,-694(a5) # ffffffffc02c6af8 <boot_pgdir_pa>
ffffffffc0203db6:	f45c                	sd	a5,168(s0)
        proc->tf = NULL;
ffffffffc0203db8:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0203dbc:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203dc0:	4641                	li	a2,16
ffffffffc0203dc2:	4581                	li	a1,0
ffffffffc0203dc4:	0b440513          	addi	a0,s0,180
ffffffffc0203dc8:	2d3010ef          	jal	ra,ffffffffc020589a <memset>

        proc->wait_state = 0;
        proc->cptr = proc->yptr = proc->optr = NULL;

        proc->rq = NULL;
        list_init(&(proc->run_link));
ffffffffc0203dcc:	11040793          	addi	a5,s0,272
    elm->prev = elm->next = elm;
ffffffffc0203dd0:	10f43c23          	sd	a5,280(s0)
ffffffffc0203dd4:	10f43823          	sd	a5,272(s0)
        proc->time_slice = 0;
        skew_heap_init(&(proc->lab6_run_pool));
        proc->lab6_stride = 0;
ffffffffc0203dd8:	4785                	li	a5,1
        proc->lab6_priority = 1;
        list_init(&(proc->list_link));
ffffffffc0203dda:	0c840693          	addi	a3,s0,200
        list_init(&(proc->hash_link));
ffffffffc0203dde:	0d840713          	addi	a4,s0,216
        proc->lab6_stride = 0;
ffffffffc0203de2:	1782                	slli	a5,a5,0x20
        proc->exit_code = 0;
ffffffffc0203de4:	0e043423          	sd	zero,232(s0)
        proc->cptr = proc->yptr = proc->optr = NULL;
ffffffffc0203de8:	0e043823          	sd	zero,240(s0)
ffffffffc0203dec:	0e043c23          	sd	zero,248(s0)
ffffffffc0203df0:	10043023          	sd	zero,256(s0)
        proc->rq = NULL;
ffffffffc0203df4:	10043423          	sd	zero,264(s0)
        proc->time_slice = 0;
ffffffffc0203df8:	12042023          	sw	zero,288(s0)
     compare_f comp) __attribute__((always_inline));

static inline void
skew_heap_init(skew_heap_entry_t *a)
{
     a->left = a->right = a->parent = NULL;
ffffffffc0203dfc:	12043423          	sd	zero,296(s0)
ffffffffc0203e00:	12043823          	sd	zero,304(s0)
ffffffffc0203e04:	12043c23          	sd	zero,312(s0)
        proc->lab6_stride = 0;
ffffffffc0203e08:	14f43023          	sd	a5,320(s0)
ffffffffc0203e0c:	e874                	sd	a3,208(s0)
ffffffffc0203e0e:	e474                	sd	a3,200(s0)
ffffffffc0203e10:	f078                	sd	a4,224(s0)
ffffffffc0203e12:	ec78                	sd	a4,216(s0)
    }
    return proc;
}
ffffffffc0203e14:	60a2                	ld	ra,8(sp)
ffffffffc0203e16:	8522                	mv	a0,s0
ffffffffc0203e18:	6402                	ld	s0,0(sp)
ffffffffc0203e1a:	0141                	addi	sp,sp,16
ffffffffc0203e1c:	8082                	ret

ffffffffc0203e1e <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203e1e:	000c3797          	auipc	a5,0xc3
ffffffffc0203e22:	d0a7b783          	ld	a5,-758(a5) # ffffffffc02c6b28 <current>
ffffffffc0203e26:	73c8                	ld	a0,160(a5)
ffffffffc0203e28:	8eefd06f          	j	ffffffffc0200f16 <forkrets>

ffffffffc0203e2c <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203e2c:	6d14                	ld	a3,24(a0)
}

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm)
{
ffffffffc0203e2e:	1141                	addi	sp,sp,-16
ffffffffc0203e30:	e406                	sd	ra,8(sp)
ffffffffc0203e32:	c02007b7          	lui	a5,0xc0200
ffffffffc0203e36:	02f6ee63          	bltu	a3,a5,ffffffffc0203e72 <put_pgdir+0x46>
ffffffffc0203e3a:	000c3517          	auipc	a0,0xc3
ffffffffc0203e3e:	ce653503          	ld	a0,-794(a0) # ffffffffc02c6b20 <va_pa_offset>
ffffffffc0203e42:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0203e44:	82b1                	srli	a3,a3,0xc
ffffffffc0203e46:	000c3797          	auipc	a5,0xc3
ffffffffc0203e4a:	cc27b783          	ld	a5,-830(a5) # ffffffffc02c6b08 <npage>
ffffffffc0203e4e:	02f6fe63          	bgeu	a3,a5,ffffffffc0203e8a <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203e52:	00004517          	auipc	a0,0x4
ffffffffc0203e56:	32653503          	ld	a0,806(a0) # ffffffffc0208178 <nbase>
    free_page(kva2page(mm->pgdir));
}
ffffffffc0203e5a:	60a2                	ld	ra,8(sp)
ffffffffc0203e5c:	8e89                	sub	a3,a3,a0
ffffffffc0203e5e:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203e60:	000c3517          	auipc	a0,0xc3
ffffffffc0203e64:	cb053503          	ld	a0,-848(a0) # ffffffffc02c6b10 <pages>
ffffffffc0203e68:	4585                	li	a1,1
ffffffffc0203e6a:	9536                	add	a0,a0,a3
}
ffffffffc0203e6c:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203e6e:	fa9fd06f          	j	ffffffffc0201e16 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203e72:	00003617          	auipc	a2,0x3
ffffffffc0203e76:	97660613          	addi	a2,a2,-1674 # ffffffffc02067e8 <default_pmm_manager+0xe0>
ffffffffc0203e7a:	07700593          	li	a1,119
ffffffffc0203e7e:	00003517          	auipc	a0,0x3
ffffffffc0203e82:	8ea50513          	addi	a0,a0,-1814 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc0203e86:	e0cfc0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203e8a:	00003617          	auipc	a2,0x3
ffffffffc0203e8e:	98660613          	addi	a2,a2,-1658 # ffffffffc0206810 <default_pmm_manager+0x108>
ffffffffc0203e92:	06900593          	li	a1,105
ffffffffc0203e96:	00003517          	auipc	a0,0x3
ffffffffc0203e9a:	8d250513          	addi	a0,a0,-1838 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc0203e9e:	df4fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203ea2 <proc_run>:
{
ffffffffc0203ea2:	7179                	addi	sp,sp,-48
ffffffffc0203ea4:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0203ea6:	000c3917          	auipc	s2,0xc3
ffffffffc0203eaa:	c8290913          	addi	s2,s2,-894 # ffffffffc02c6b28 <current>
{
ffffffffc0203eae:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203eb0:	00093483          	ld	s1,0(s2)
{
ffffffffc0203eb4:	f406                	sd	ra,40(sp)
ffffffffc0203eb6:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0203eb8:	02a48863          	beq	s1,a0,ffffffffc0203ee8 <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203ebc:	100027f3          	csrr	a5,sstatus
ffffffffc0203ec0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203ec2:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203ec4:	ef9d                	bnez	a5,ffffffffc0203f02 <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203ec6:	755c                	ld	a5,168(a0)
ffffffffc0203ec8:	577d                	li	a4,-1
ffffffffc0203eca:	177e                	slli	a4,a4,0x3f
ffffffffc0203ecc:	83b1                	srli	a5,a5,0xc
            current = proc;
ffffffffc0203ece:	00a93023          	sd	a0,0(s2)
ffffffffc0203ed2:	8fd9                	or	a5,a5,a4
ffffffffc0203ed4:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(next->context));
ffffffffc0203ed8:	03050593          	addi	a1,a0,48
ffffffffc0203edc:	03048513          	addi	a0,s1,48
ffffffffc0203ee0:	0fc010ef          	jal	ra,ffffffffc0204fdc <switch_to>
    if (flag)
ffffffffc0203ee4:	00099863          	bnez	s3,ffffffffc0203ef4 <proc_run+0x52>
}
ffffffffc0203ee8:	70a2                	ld	ra,40(sp)
ffffffffc0203eea:	7482                	ld	s1,32(sp)
ffffffffc0203eec:	6962                	ld	s2,24(sp)
ffffffffc0203eee:	69c2                	ld	s3,16(sp)
ffffffffc0203ef0:	6145                	addi	sp,sp,48
ffffffffc0203ef2:	8082                	ret
ffffffffc0203ef4:	70a2                	ld	ra,40(sp)
ffffffffc0203ef6:	7482                	ld	s1,32(sp)
ffffffffc0203ef8:	6962                	ld	s2,24(sp)
ffffffffc0203efa:	69c2                	ld	s3,16(sp)
ffffffffc0203efc:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0203efe:	aabfc06f          	j	ffffffffc02009a8 <intr_enable>
ffffffffc0203f02:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203f04:	aabfc0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc0203f08:	6522                	ld	a0,8(sp)
ffffffffc0203f0a:	4985                	li	s3,1
ffffffffc0203f0c:	bf6d                	j	ffffffffc0203ec6 <proc_run+0x24>

ffffffffc0203f0e <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf)
{
ffffffffc0203f0e:	7119                	addi	sp,sp,-128
ffffffffc0203f10:	f0ca                	sd	s2,96(sp)
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS)
ffffffffc0203f12:	000c3917          	auipc	s2,0xc3
ffffffffc0203f16:	c2e90913          	addi	s2,s2,-978 # ffffffffc02c6b40 <nr_process>
ffffffffc0203f1a:	00092703          	lw	a4,0(s2)
{
ffffffffc0203f1e:	fc86                	sd	ra,120(sp)
ffffffffc0203f20:	f8a2                	sd	s0,112(sp)
ffffffffc0203f22:	f4a6                	sd	s1,104(sp)
ffffffffc0203f24:	ecce                	sd	s3,88(sp)
ffffffffc0203f26:	e8d2                	sd	s4,80(sp)
ffffffffc0203f28:	e4d6                	sd	s5,72(sp)
ffffffffc0203f2a:	e0da                	sd	s6,64(sp)
ffffffffc0203f2c:	fc5e                	sd	s7,56(sp)
ffffffffc0203f2e:	f862                	sd	s8,48(sp)
ffffffffc0203f30:	f466                	sd	s9,40(sp)
ffffffffc0203f32:	f06a                	sd	s10,32(sp)
ffffffffc0203f34:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203f36:	6785                	lui	a5,0x1
ffffffffc0203f38:	32f75863          	bge	a4,a5,ffffffffc0204268 <do_fork+0x35a>
ffffffffc0203f3c:	8a2a                	mv	s4,a0
ffffffffc0203f3e:	89ae                	mv	s3,a1
ffffffffc0203f40:	8432                	mv	s0,a2
    {
        goto fork_out;
    }
    ret = -E_NO_MEM;
    if ((proc = alloc_proc()) == NULL)
ffffffffc0203f42:	e33ff0ef          	jal	ra,ffffffffc0203d74 <alloc_proc>
ffffffffc0203f46:	84aa                	mv	s1,a0
ffffffffc0203f48:	30050163          	beqz	a0,ffffffffc020424a <do_fork+0x33c>
    {
        goto fork_out;
    }
    proc->parent = current;
ffffffffc0203f4c:	000c3c17          	auipc	s8,0xc3
ffffffffc0203f50:	bdcc0c13          	addi	s8,s8,-1060 # ffffffffc02c6b28 <current>
ffffffffc0203f54:	000c3783          	ld	a5,0(s8)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203f58:	4509                	li	a0,2
    proc->parent = current;
ffffffffc0203f5a:	f09c                	sd	a5,32(s1)
    current->wait_state = 0;
ffffffffc0203f5c:	0e07a623          	sw	zero,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x8e44>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203f60:	e79fd0ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
    if (page != NULL)
ffffffffc0203f64:	2e050063          	beqz	a0,ffffffffc0204244 <do_fork+0x336>
    return page - pages + nbase;
ffffffffc0203f68:	000c3a97          	auipc	s5,0xc3
ffffffffc0203f6c:	ba8a8a93          	addi	s5,s5,-1112 # ffffffffc02c6b10 <pages>
ffffffffc0203f70:	000ab683          	ld	a3,0(s5)
ffffffffc0203f74:	00004b17          	auipc	s6,0x4
ffffffffc0203f78:	204b0b13          	addi	s6,s6,516 # ffffffffc0208178 <nbase>
ffffffffc0203f7c:	000b3783          	ld	a5,0(s6)
ffffffffc0203f80:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0203f84:	000c3b97          	auipc	s7,0xc3
ffffffffc0203f88:	b84b8b93          	addi	s7,s7,-1148 # ffffffffc02c6b08 <npage>
    return page - pages + nbase;
ffffffffc0203f8c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0203f8e:	5dfd                	li	s11,-1
ffffffffc0203f90:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0203f94:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0203f96:	00cddd93          	srli	s11,s11,0xc
ffffffffc0203f9a:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0203f9e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203fa0:	32e67a63          	bgeu	a2,a4,ffffffffc02042d4 <do_fork+0x3c6>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0203fa4:	000c3603          	ld	a2,0(s8)
ffffffffc0203fa8:	000c3c17          	auipc	s8,0xc3
ffffffffc0203fac:	b78c0c13          	addi	s8,s8,-1160 # ffffffffc02c6b20 <va_pa_offset>
ffffffffc0203fb0:	000c3703          	ld	a4,0(s8)
ffffffffc0203fb4:	02863d03          	ld	s10,40(a2)
ffffffffc0203fb8:	e43e                	sd	a5,8(sp)
ffffffffc0203fba:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0203fbc:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc0203fbe:	020d0863          	beqz	s10,ffffffffc0203fee <do_fork+0xe0>
    if (clone_flags & CLONE_VM)
ffffffffc0203fc2:	100a7a13          	andi	s4,s4,256
ffffffffc0203fc6:	1c0a0163          	beqz	s4,ffffffffc0204188 <do_fork+0x27a>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0203fca:	030d2703          	lw	a4,48(s10)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203fce:	018d3783          	ld	a5,24(s10)
ffffffffc0203fd2:	c02006b7          	lui	a3,0xc0200
ffffffffc0203fd6:	2705                	addiw	a4,a4,1
ffffffffc0203fd8:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc0203fdc:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203fe0:	2cd7e163          	bltu	a5,a3,ffffffffc02042a2 <do_fork+0x394>
ffffffffc0203fe4:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203fe8:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203fea:	8f99                	sub	a5,a5,a4
ffffffffc0203fec:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203fee:	6789                	lui	a5,0x2
ffffffffc0203ff0:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x8050>
ffffffffc0203ff4:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc0203ff6:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203ff8:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc0203ffa:	87b6                	mv	a5,a3
ffffffffc0203ffc:	12040893          	addi	a7,s0,288
ffffffffc0204000:	00063803          	ld	a6,0(a2)
ffffffffc0204004:	6608                	ld	a0,8(a2)
ffffffffc0204006:	6a0c                	ld	a1,16(a2)
ffffffffc0204008:	6e18                	ld	a4,24(a2)
ffffffffc020400a:	0107b023          	sd	a6,0(a5)
ffffffffc020400e:	e788                	sd	a0,8(a5)
ffffffffc0204010:	eb8c                	sd	a1,16(a5)
ffffffffc0204012:	ef98                	sd	a4,24(a5)
ffffffffc0204014:	02060613          	addi	a2,a2,32
ffffffffc0204018:	02078793          	addi	a5,a5,32
ffffffffc020401c:	ff1612e3          	bne	a2,a7,ffffffffc0204000 <do_fork+0xf2>
    proc->tf->gpr.a0 = 0;
ffffffffc0204020:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204024:	12098f63          	beqz	s3,ffffffffc0204162 <do_fork+0x254>
ffffffffc0204028:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020402c:	00000797          	auipc	a5,0x0
ffffffffc0204030:	df278793          	addi	a5,a5,-526 # ffffffffc0203e1e <forkret>
ffffffffc0204034:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204036:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204038:	100027f3          	csrr	a5,sstatus
ffffffffc020403c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020403e:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204040:	14079063          	bnez	a5,ffffffffc0204180 <do_fork+0x272>
    if (++last_pid >= MAX_PID)
ffffffffc0204044:	000be817          	auipc	a6,0xbe
ffffffffc0204048:	62480813          	addi	a6,a6,1572 # ffffffffc02c2668 <last_pid.1>
ffffffffc020404c:	00082783          	lw	a5,0(a6)
ffffffffc0204050:	6709                	lui	a4,0x2
ffffffffc0204052:	0017851b          	addiw	a0,a5,1
ffffffffc0204056:	00a82023          	sw	a0,0(a6)
ffffffffc020405a:	08e55d63          	bge	a0,a4,ffffffffc02040f4 <do_fork+0x1e6>
    if (last_pid >= next_safe)
ffffffffc020405e:	000be317          	auipc	t1,0xbe
ffffffffc0204062:	60e30313          	addi	t1,t1,1550 # ffffffffc02c266c <next_safe.0>
ffffffffc0204066:	00032783          	lw	a5,0(t1)
ffffffffc020406a:	000c3417          	auipc	s0,0xc3
ffffffffc020406e:	a1e40413          	addi	s0,s0,-1506 # ffffffffc02c6a88 <proc_list>
ffffffffc0204072:	08f55963          	bge	a0,a5,ffffffffc0204104 <do_fork+0x1f6>
    copy_thread(proc, stack, tf);

    bool intr_flag;
    local_intr_save(intr_flag);
    {
        proc->pid = get_pid();
ffffffffc0204076:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204078:	45a9                	li	a1,10
ffffffffc020407a:	2501                	sext.w	a0,a0
ffffffffc020407c:	378010ef          	jal	ra,ffffffffc02053f4 <hash32>
ffffffffc0204080:	02051793          	slli	a5,a0,0x20
ffffffffc0204084:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204088:	000bf797          	auipc	a5,0xbf
ffffffffc020408c:	a0078793          	addi	a5,a5,-1536 # ffffffffc02c2a88 <hash_list>
ffffffffc0204090:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204092:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204094:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204096:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc020409a:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc020409c:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc020409e:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02040a0:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc02040a2:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc02040a6:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc02040a8:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc02040aa:	e21c                	sd	a5,0(a2)
ffffffffc02040ac:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc02040ae:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc02040b0:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc02040b2:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02040b6:	10e4b023          	sd	a4,256(s1)
ffffffffc02040ba:	c311                	beqz	a4,ffffffffc02040be <do_fork+0x1b0>
        proc->optr->yptr = proc;
ffffffffc02040bc:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc02040be:	00092783          	lw	a5,0(s2)
    proc->parent->cptr = proc;
ffffffffc02040c2:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc02040c4:	2785                	addiw	a5,a5,1
ffffffffc02040c6:	00f92023          	sw	a5,0(s2)
    if (flag)
ffffffffc02040ca:	18099263          	bnez	s3,ffffffffc020424e <do_fork+0x340>
        hash_proc(proc);
        set_links(proc);
    }
    local_intr_restore(intr_flag);

    wakeup_proc(proc);
ffffffffc02040ce:	8526                	mv	a0,s1
ffffffffc02040d0:	0b2010ef          	jal	ra,ffffffffc0205182 <wakeup_proc>
    ret = proc->pid;
ffffffffc02040d4:	40c8                	lw	a0,4(s1)
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
ffffffffc02040d6:	70e6                	ld	ra,120(sp)
ffffffffc02040d8:	7446                	ld	s0,112(sp)
ffffffffc02040da:	74a6                	ld	s1,104(sp)
ffffffffc02040dc:	7906                	ld	s2,96(sp)
ffffffffc02040de:	69e6                	ld	s3,88(sp)
ffffffffc02040e0:	6a46                	ld	s4,80(sp)
ffffffffc02040e2:	6aa6                	ld	s5,72(sp)
ffffffffc02040e4:	6b06                	ld	s6,64(sp)
ffffffffc02040e6:	7be2                	ld	s7,56(sp)
ffffffffc02040e8:	7c42                	ld	s8,48(sp)
ffffffffc02040ea:	7ca2                	ld	s9,40(sp)
ffffffffc02040ec:	7d02                	ld	s10,32(sp)
ffffffffc02040ee:	6de2                	ld	s11,24(sp)
ffffffffc02040f0:	6109                	addi	sp,sp,128
ffffffffc02040f2:	8082                	ret
        last_pid = 1;
ffffffffc02040f4:	4785                	li	a5,1
ffffffffc02040f6:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02040fa:	4505                	li	a0,1
ffffffffc02040fc:	000be317          	auipc	t1,0xbe
ffffffffc0204100:	57030313          	addi	t1,t1,1392 # ffffffffc02c266c <next_safe.0>
    return listelm->next;
ffffffffc0204104:	000c3417          	auipc	s0,0xc3
ffffffffc0204108:	98440413          	addi	s0,s0,-1660 # ffffffffc02c6a88 <proc_list>
ffffffffc020410c:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc0204110:	6789                	lui	a5,0x2
ffffffffc0204112:	00f32023          	sw	a5,0(t1)
ffffffffc0204116:	86aa                	mv	a3,a0
ffffffffc0204118:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc020411a:	6e89                	lui	t4,0x2
ffffffffc020411c:	148e0163          	beq	t3,s0,ffffffffc020425e <do_fork+0x350>
ffffffffc0204120:	88ae                	mv	a7,a1
ffffffffc0204122:	87f2                	mv	a5,t3
ffffffffc0204124:	6609                	lui	a2,0x2
ffffffffc0204126:	a811                	j	ffffffffc020413a <do_fork+0x22c>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204128:	00e6d663          	bge	a3,a4,ffffffffc0204134 <do_fork+0x226>
ffffffffc020412c:	00c75463          	bge	a4,a2,ffffffffc0204134 <do_fork+0x226>
ffffffffc0204130:	863a                	mv	a2,a4
ffffffffc0204132:	4885                	li	a7,1
ffffffffc0204134:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204136:	00878d63          	beq	a5,s0,ffffffffc0204150 <do_fork+0x242>
            if (proc->pid == last_pid)
ffffffffc020413a:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7ff4>
ffffffffc020413e:	fed715e3          	bne	a4,a3,ffffffffc0204128 <do_fork+0x21a>
                if (++last_pid >= next_safe)
ffffffffc0204142:	2685                	addiw	a3,a3,1
ffffffffc0204144:	10c6d863          	bge	a3,a2,ffffffffc0204254 <do_fork+0x346>
ffffffffc0204148:	679c                	ld	a5,8(a5)
ffffffffc020414a:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc020414c:	fe8797e3          	bne	a5,s0,ffffffffc020413a <do_fork+0x22c>
ffffffffc0204150:	c581                	beqz	a1,ffffffffc0204158 <do_fork+0x24a>
ffffffffc0204152:	00d82023          	sw	a3,0(a6)
ffffffffc0204156:	8536                	mv	a0,a3
ffffffffc0204158:	f0088fe3          	beqz	a7,ffffffffc0204076 <do_fork+0x168>
ffffffffc020415c:	00c32023          	sw	a2,0(t1)
ffffffffc0204160:	bf19                	j	ffffffffc0204076 <do_fork+0x168>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204162:	89b6                	mv	s3,a3
ffffffffc0204164:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204168:	00000797          	auipc	a5,0x0
ffffffffc020416c:	cb678793          	addi	a5,a5,-842 # ffffffffc0203e1e <forkret>
ffffffffc0204170:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204172:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204174:	100027f3          	csrr	a5,sstatus
ffffffffc0204178:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020417a:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020417c:	ec0784e3          	beqz	a5,ffffffffc0204044 <do_fork+0x136>
        intr_disable();
ffffffffc0204180:	82ffc0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc0204184:	4985                	li	s3,1
ffffffffc0204186:	bd7d                	j	ffffffffc0204044 <do_fork+0x136>
    if ((mm = mm_create()) == NULL)
ffffffffc0204188:	cdaff0ef          	jal	ra,ffffffffc0203662 <mm_create>
ffffffffc020418c:	8caa                	mv	s9,a0
ffffffffc020418e:	c159                	beqz	a0,ffffffffc0204214 <do_fork+0x306>
    if ((page = alloc_page()) == NULL)
ffffffffc0204190:	4505                	li	a0,1
ffffffffc0204192:	c47fd0ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc0204196:	cd25                	beqz	a0,ffffffffc020420e <do_fork+0x300>
    return page - pages + nbase;
ffffffffc0204198:	000ab683          	ld	a3,0(s5)
ffffffffc020419c:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc020419e:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc02041a2:	40d506b3          	sub	a3,a0,a3
ffffffffc02041a6:	8699                	srai	a3,a3,0x6
ffffffffc02041a8:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02041aa:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc02041ae:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02041b0:	12edf263          	bgeu	s11,a4,ffffffffc02042d4 <do_fork+0x3c6>
ffffffffc02041b4:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc02041b8:	6605                	lui	a2,0x1
ffffffffc02041ba:	000c3597          	auipc	a1,0xc3
ffffffffc02041be:	9465b583          	ld	a1,-1722(a1) # ffffffffc02c6b00 <boot_pgdir_va>
ffffffffc02041c2:	9a36                	add	s4,s4,a3
ffffffffc02041c4:	8552                	mv	a0,s4
ffffffffc02041c6:	6e6010ef          	jal	ra,ffffffffc02058ac <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc02041ca:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc02041ce:	014cbc23          	sd	s4,24(s9) # fffffffffff80018 <end+0x3fcb94c0>
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02041d2:	4785                	li	a5,1
ffffffffc02041d4:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc02041d8:	8b85                	andi	a5,a5,1
ffffffffc02041da:	4a05                	li	s4,1
ffffffffc02041dc:	c799                	beqz	a5,ffffffffc02041ea <do_fork+0x2dc>
    {
        schedule();
ffffffffc02041de:	056010ef          	jal	ra,ffffffffc0205234 <schedule>
ffffffffc02041e2:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc02041e6:	8b85                	andi	a5,a5,1
ffffffffc02041e8:	fbfd                	bnez	a5,ffffffffc02041de <do_fork+0x2d0>
        ret = dup_mmap(mm, oldmm);
ffffffffc02041ea:	85ea                	mv	a1,s10
ffffffffc02041ec:	8566                	mv	a0,s9
ffffffffc02041ee:	eb6ff0ef          	jal	ra,ffffffffc02038a4 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02041f2:	57f9                	li	a5,-2
ffffffffc02041f4:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc02041f8:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02041fa:	cfa5                	beqz	a5,ffffffffc0204272 <do_fork+0x364>
good_mm:
ffffffffc02041fc:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc02041fe:	dc0506e3          	beqz	a0,ffffffffc0203fca <do_fork+0xbc>
    exit_mmap(mm);
ffffffffc0204202:	8566                	mv	a0,s9
ffffffffc0204204:	f3aff0ef          	jal	ra,ffffffffc020393e <exit_mmap>
    put_pgdir(mm);
ffffffffc0204208:	8566                	mv	a0,s9
ffffffffc020420a:	c23ff0ef          	jal	ra,ffffffffc0203e2c <put_pgdir>
    mm_destroy(mm);
ffffffffc020420e:	8566                	mv	a0,s9
ffffffffc0204210:	d92ff0ef          	jal	ra,ffffffffc02037a2 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204214:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc0204216:	c02007b7          	lui	a5,0xc0200
ffffffffc020421a:	0af6e163          	bltu	a3,a5,ffffffffc02042bc <do_fork+0x3ae>
ffffffffc020421e:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc0204222:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc0204226:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc020422a:	83b1                	srli	a5,a5,0xc
ffffffffc020422c:	04e7ff63          	bgeu	a5,a4,ffffffffc020428a <do_fork+0x37c>
    return &pages[PPN(pa) - nbase];
ffffffffc0204230:	000b3703          	ld	a4,0(s6)
ffffffffc0204234:	000ab503          	ld	a0,0(s5)
ffffffffc0204238:	4589                	li	a1,2
ffffffffc020423a:	8f99                	sub	a5,a5,a4
ffffffffc020423c:	079a                	slli	a5,a5,0x6
ffffffffc020423e:	953e                	add	a0,a0,a5
ffffffffc0204240:	bd7fd0ef          	jal	ra,ffffffffc0201e16 <free_pages>
    kfree(proc);
ffffffffc0204244:	8526                	mv	a0,s1
ffffffffc0204246:	a65fd0ef          	jal	ra,ffffffffc0201caa <kfree>
    ret = -E_NO_MEM;
ffffffffc020424a:	5571                	li	a0,-4
    return ret;
ffffffffc020424c:	b569                	j	ffffffffc02040d6 <do_fork+0x1c8>
        intr_enable();
ffffffffc020424e:	f5afc0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0204252:	bdb5                	j	ffffffffc02040ce <do_fork+0x1c0>
                    if (last_pid >= MAX_PID)
ffffffffc0204254:	01d6c363          	blt	a3,t4,ffffffffc020425a <do_fork+0x34c>
                        last_pid = 1;
ffffffffc0204258:	4685                	li	a3,1
                    goto repeat;
ffffffffc020425a:	4585                	li	a1,1
ffffffffc020425c:	b5c1                	j	ffffffffc020411c <do_fork+0x20e>
ffffffffc020425e:	c599                	beqz	a1,ffffffffc020426c <do_fork+0x35e>
ffffffffc0204260:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc0204264:	8536                	mv	a0,a3
ffffffffc0204266:	bd01                	j	ffffffffc0204076 <do_fork+0x168>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204268:	556d                	li	a0,-5
ffffffffc020426a:	b5b5                	j	ffffffffc02040d6 <do_fork+0x1c8>
    return last_pid;
ffffffffc020426c:	00082503          	lw	a0,0(a6)
ffffffffc0204270:	b519                	j	ffffffffc0204076 <do_fork+0x168>
    {
        panic("Unlock failed.\n");
ffffffffc0204272:	00003617          	auipc	a2,0x3
ffffffffc0204276:	e9e60613          	addi	a2,a2,-354 # ffffffffc0207110 <default_pmm_manager+0xa08>
ffffffffc020427a:	04000593          	li	a1,64
ffffffffc020427e:	00003517          	auipc	a0,0x3
ffffffffc0204282:	ea250513          	addi	a0,a0,-350 # ffffffffc0207120 <default_pmm_manager+0xa18>
ffffffffc0204286:	a0cfc0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020428a:	00002617          	auipc	a2,0x2
ffffffffc020428e:	58660613          	addi	a2,a2,1414 # ffffffffc0206810 <default_pmm_manager+0x108>
ffffffffc0204292:	06900593          	li	a1,105
ffffffffc0204296:	00002517          	auipc	a0,0x2
ffffffffc020429a:	4d250513          	addi	a0,a0,1234 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc020429e:	9f4fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042a2:	86be                	mv	a3,a5
ffffffffc02042a4:	00002617          	auipc	a2,0x2
ffffffffc02042a8:	54460613          	addi	a2,a2,1348 # ffffffffc02067e8 <default_pmm_manager+0xe0>
ffffffffc02042ac:	17600593          	li	a1,374
ffffffffc02042b0:	00003517          	auipc	a0,0x3
ffffffffc02042b4:	e8850513          	addi	a0,a0,-376 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc02042b8:	9dafc0ef          	jal	ra,ffffffffc0200492 <__panic>
    return pa2page(PADDR(kva));
ffffffffc02042bc:	00002617          	auipc	a2,0x2
ffffffffc02042c0:	52c60613          	addi	a2,a2,1324 # ffffffffc02067e8 <default_pmm_manager+0xe0>
ffffffffc02042c4:	07700593          	li	a1,119
ffffffffc02042c8:	00002517          	auipc	a0,0x2
ffffffffc02042cc:	4a050513          	addi	a0,a0,1184 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc02042d0:	9c2fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    return KADDR(page2pa(page));
ffffffffc02042d4:	00002617          	auipc	a2,0x2
ffffffffc02042d8:	46c60613          	addi	a2,a2,1132 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc02042dc:	07100593          	li	a1,113
ffffffffc02042e0:	00002517          	auipc	a0,0x2
ffffffffc02042e4:	48850513          	addi	a0,a0,1160 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc02042e8:	9aafc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02042ec <kernel_thread>:
{
ffffffffc02042ec:	7129                	addi	sp,sp,-320
ffffffffc02042ee:	fa22                	sd	s0,304(sp)
ffffffffc02042f0:	f626                	sd	s1,296(sp)
ffffffffc02042f2:	f24a                	sd	s2,288(sp)
ffffffffc02042f4:	84ae                	mv	s1,a1
ffffffffc02042f6:	892a                	mv	s2,a0
ffffffffc02042f8:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02042fa:	4581                	li	a1,0
ffffffffc02042fc:	12000613          	li	a2,288
ffffffffc0204300:	850a                	mv	a0,sp
{
ffffffffc0204302:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204304:	596010ef          	jal	ra,ffffffffc020589a <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0204308:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc020430a:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc020430c:	100027f3          	csrr	a5,sstatus
ffffffffc0204310:	edd7f793          	andi	a5,a5,-291
ffffffffc0204314:	1207e793          	ori	a5,a5,288
ffffffffc0204318:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020431a:	860a                	mv	a2,sp
ffffffffc020431c:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204320:	00000797          	auipc	a5,0x0
ffffffffc0204324:	a4c78793          	addi	a5,a5,-1460 # ffffffffc0203d6c <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204328:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020432a:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020432c:	be3ff0ef          	jal	ra,ffffffffc0203f0e <do_fork>
}
ffffffffc0204330:	70f2                	ld	ra,312(sp)
ffffffffc0204332:	7452                	ld	s0,304(sp)
ffffffffc0204334:	74b2                	ld	s1,296(sp)
ffffffffc0204336:	7912                	ld	s2,288(sp)
ffffffffc0204338:	6131                	addi	sp,sp,320
ffffffffc020433a:	8082                	ret

ffffffffc020433c <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int do_exit(int error_code)
{
ffffffffc020433c:	7179                	addi	sp,sp,-48
ffffffffc020433e:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204340:	000c2417          	auipc	s0,0xc2
ffffffffc0204344:	7e840413          	addi	s0,s0,2024 # ffffffffc02c6b28 <current>
ffffffffc0204348:	601c                	ld	a5,0(s0)
{
ffffffffc020434a:	f406                	sd	ra,40(sp)
ffffffffc020434c:	ec26                	sd	s1,24(sp)
ffffffffc020434e:	e84a                	sd	s2,16(sp)
ffffffffc0204350:	e44e                	sd	s3,8(sp)
ffffffffc0204352:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc0204354:	000c2717          	auipc	a4,0xc2
ffffffffc0204358:	7dc73703          	ld	a4,2012(a4) # ffffffffc02c6b30 <idleproc>
ffffffffc020435c:	0ce78c63          	beq	a5,a4,ffffffffc0204434 <do_exit+0xf8>
    {
        panic("idleproc exit.\n");
    }
    if (current == initproc)
ffffffffc0204360:	000c2497          	auipc	s1,0xc2
ffffffffc0204364:	7d848493          	addi	s1,s1,2008 # ffffffffc02c6b38 <initproc>
ffffffffc0204368:	6098                	ld	a4,0(s1)
ffffffffc020436a:	0ee78b63          	beq	a5,a4,ffffffffc0204460 <do_exit+0x124>
    {
        panic("initproc exit.\n");
    }
    struct mm_struct *mm = current->mm;
ffffffffc020436e:	0287b983          	ld	s3,40(a5)
ffffffffc0204372:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc0204374:	02098663          	beqz	s3,ffffffffc02043a0 <do_exit+0x64>
ffffffffc0204378:	000c2797          	auipc	a5,0xc2
ffffffffc020437c:	7807b783          	ld	a5,1920(a5) # ffffffffc02c6af8 <boot_pgdir_pa>
ffffffffc0204380:	577d                	li	a4,-1
ffffffffc0204382:	177e                	slli	a4,a4,0x3f
ffffffffc0204384:	83b1                	srli	a5,a5,0xc
ffffffffc0204386:	8fd9                	or	a5,a5,a4
ffffffffc0204388:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc020438c:	0309a783          	lw	a5,48(s3)
ffffffffc0204390:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204394:	02e9a823          	sw	a4,48(s3)
    {
        lsatp(boot_pgdir_pa);
        if (mm_count_dec(mm) == 0)
ffffffffc0204398:	cb55                	beqz	a4,ffffffffc020444c <do_exit+0x110>
        {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
ffffffffc020439a:	601c                	ld	a5,0(s0)
ffffffffc020439c:	0207b423          	sd	zero,40(a5)
    }
    current->state = PROC_ZOMBIE;
ffffffffc02043a0:	601c                	ld	a5,0(s0)
ffffffffc02043a2:	470d                	li	a4,3
ffffffffc02043a4:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc02043a6:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02043aa:	100027f3          	csrr	a5,sstatus
ffffffffc02043ae:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02043b0:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02043b2:	e3f9                	bnez	a5,ffffffffc0204478 <do_exit+0x13c>
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
    {
        proc = current->parent;
ffffffffc02043b4:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc02043b6:	800007b7          	lui	a5,0x80000
ffffffffc02043ba:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc02043bc:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc02043be:	0ec52703          	lw	a4,236(a0)
ffffffffc02043c2:	0af70f63          	beq	a4,a5,ffffffffc0204480 <do_exit+0x144>
        {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL)
ffffffffc02043c6:	6018                	ld	a4,0(s0)
ffffffffc02043c8:	7b7c                	ld	a5,240(a4)
ffffffffc02043ca:	c3a1                	beqz	a5,ffffffffc020440a <do_exit+0xce>
            }
            proc->parent = initproc;
            initproc->cptr = proc;
            if (proc->state == PROC_ZOMBIE)
            {
                if (initproc->wait_state == WT_CHILD)
ffffffffc02043cc:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc02043d0:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc02043d2:	0985                	addi	s3,s3,1
ffffffffc02043d4:	a021                	j	ffffffffc02043dc <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc02043d6:	6018                	ld	a4,0(s0)
ffffffffc02043d8:	7b7c                	ld	a5,240(a4)
ffffffffc02043da:	cb85                	beqz	a5,ffffffffc020440a <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02043dc:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_matrix_out_size+0xffffffff7fff39f8>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02043e0:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02043e2:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02043e4:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02043e6:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02043ea:	10e7b023          	sd	a4,256(a5)
ffffffffc02043ee:	c311                	beqz	a4,ffffffffc02043f2 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02043f0:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02043f2:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02043f4:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02043f6:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02043f8:	fd271fe3          	bne	a4,s2,ffffffffc02043d6 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02043fc:	0ec52783          	lw	a5,236(a0)
ffffffffc0204400:	fd379be3          	bne	a5,s3,ffffffffc02043d6 <do_exit+0x9a>
                {
                    wakeup_proc(initproc);
ffffffffc0204404:	57f000ef          	jal	ra,ffffffffc0205182 <wakeup_proc>
ffffffffc0204408:	b7f9                	j	ffffffffc02043d6 <do_exit+0x9a>
    if (flag)
ffffffffc020440a:	020a1263          	bnez	s4,ffffffffc020442e <do_exit+0xf2>
                }
            }
        }
    }
    local_intr_restore(intr_flag);
    schedule();
ffffffffc020440e:	627000ef          	jal	ra,ffffffffc0205234 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0204412:	601c                	ld	a5,0(s0)
ffffffffc0204414:	00003617          	auipc	a2,0x3
ffffffffc0204418:	d5c60613          	addi	a2,a2,-676 # ffffffffc0207170 <default_pmm_manager+0xa68>
ffffffffc020441c:	20400593          	li	a1,516
ffffffffc0204420:	43d4                	lw	a3,4(a5)
ffffffffc0204422:	00003517          	auipc	a0,0x3
ffffffffc0204426:	d1650513          	addi	a0,a0,-746 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc020442a:	868fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        intr_enable();
ffffffffc020442e:	d7afc0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0204432:	bff1                	j	ffffffffc020440e <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc0204434:	00003617          	auipc	a2,0x3
ffffffffc0204438:	d1c60613          	addi	a2,a2,-740 # ffffffffc0207150 <default_pmm_manager+0xa48>
ffffffffc020443c:	1d000593          	li	a1,464
ffffffffc0204440:	00003517          	auipc	a0,0x3
ffffffffc0204444:	cf850513          	addi	a0,a0,-776 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204448:	84afc0ef          	jal	ra,ffffffffc0200492 <__panic>
            exit_mmap(mm);
ffffffffc020444c:	854e                	mv	a0,s3
ffffffffc020444e:	cf0ff0ef          	jal	ra,ffffffffc020393e <exit_mmap>
            put_pgdir(mm);
ffffffffc0204452:	854e                	mv	a0,s3
ffffffffc0204454:	9d9ff0ef          	jal	ra,ffffffffc0203e2c <put_pgdir>
            mm_destroy(mm);
ffffffffc0204458:	854e                	mv	a0,s3
ffffffffc020445a:	b48ff0ef          	jal	ra,ffffffffc02037a2 <mm_destroy>
ffffffffc020445e:	bf35                	j	ffffffffc020439a <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204460:	00003617          	auipc	a2,0x3
ffffffffc0204464:	d0060613          	addi	a2,a2,-768 # ffffffffc0207160 <default_pmm_manager+0xa58>
ffffffffc0204468:	1d400593          	li	a1,468
ffffffffc020446c:	00003517          	auipc	a0,0x3
ffffffffc0204470:	ccc50513          	addi	a0,a0,-820 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204474:	81efc0ef          	jal	ra,ffffffffc0200492 <__panic>
        intr_disable();
ffffffffc0204478:	d36fc0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc020447c:	4a05                	li	s4,1
ffffffffc020447e:	bf1d                	j	ffffffffc02043b4 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204480:	503000ef          	jal	ra,ffffffffc0205182 <wakeup_proc>
ffffffffc0204484:	b789                	j	ffffffffc02043c6 <do_exit+0x8a>

ffffffffc0204486 <do_wait.part.0>:
}

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int do_wait(int pid, int *code_store)
ffffffffc0204486:	715d                	addi	sp,sp,-80
ffffffffc0204488:	f84a                	sd	s2,48(sp)
ffffffffc020448a:	f44e                	sd	s3,40(sp)
        }
    }
    if (haskid)
    {
        current->state = PROC_SLEEPING;
        current->wait_state = WT_CHILD;
ffffffffc020448c:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204490:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc0204492:	fc26                	sd	s1,56(sp)
ffffffffc0204494:	f052                	sd	s4,32(sp)
ffffffffc0204496:	ec56                	sd	s5,24(sp)
ffffffffc0204498:	e85a                	sd	s6,16(sp)
ffffffffc020449a:	e45e                	sd	s7,8(sp)
ffffffffc020449c:	e486                	sd	ra,72(sp)
ffffffffc020449e:	e0a2                	sd	s0,64(sp)
ffffffffc02044a0:	84aa                	mv	s1,a0
ffffffffc02044a2:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc02044a4:	000c2b97          	auipc	s7,0xc2
ffffffffc02044a8:	684b8b93          	addi	s7,s7,1668 # ffffffffc02c6b28 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc02044ac:	00050b1b          	sext.w	s6,a0
ffffffffc02044b0:	fff50a9b          	addiw	s5,a0,-1
ffffffffc02044b4:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc02044b6:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc02044b8:	ccbd                	beqz	s1,ffffffffc0204536 <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc02044ba:	0359e863          	bltu	s3,s5,ffffffffc02044ea <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02044be:	45a9                	li	a1,10
ffffffffc02044c0:	855a                	mv	a0,s6
ffffffffc02044c2:	733000ef          	jal	ra,ffffffffc02053f4 <hash32>
ffffffffc02044c6:	02051793          	slli	a5,a0,0x20
ffffffffc02044ca:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02044ce:	000be797          	auipc	a5,0xbe
ffffffffc02044d2:	5ba78793          	addi	a5,a5,1466 # ffffffffc02c2a88 <hash_list>
ffffffffc02044d6:	953e                	add	a0,a0,a5
ffffffffc02044d8:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc02044da:	a029                	j	ffffffffc02044e4 <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc02044dc:	f2c42783          	lw	a5,-212(s0)
ffffffffc02044e0:	02978163          	beq	a5,s1,ffffffffc0204502 <do_wait.part.0+0x7c>
ffffffffc02044e4:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc02044e6:	fe851be3          	bne	a0,s0,ffffffffc02044dc <do_wait.part.0+0x56>
        {
            do_exit(-E_KILLED);
        }
        goto repeat;
    }
    return -E_BAD_PROC;
ffffffffc02044ea:	5579                	li	a0,-2
    }
    local_intr_restore(intr_flag);
    put_kstack(proc);
    kfree(proc);
    return 0;
}
ffffffffc02044ec:	60a6                	ld	ra,72(sp)
ffffffffc02044ee:	6406                	ld	s0,64(sp)
ffffffffc02044f0:	74e2                	ld	s1,56(sp)
ffffffffc02044f2:	7942                	ld	s2,48(sp)
ffffffffc02044f4:	79a2                	ld	s3,40(sp)
ffffffffc02044f6:	7a02                	ld	s4,32(sp)
ffffffffc02044f8:	6ae2                	ld	s5,24(sp)
ffffffffc02044fa:	6b42                	ld	s6,16(sp)
ffffffffc02044fc:	6ba2                	ld	s7,8(sp)
ffffffffc02044fe:	6161                	addi	sp,sp,80
ffffffffc0204500:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc0204502:	000bb683          	ld	a3,0(s7)
ffffffffc0204506:	f4843783          	ld	a5,-184(s0)
ffffffffc020450a:	fed790e3          	bne	a5,a3,ffffffffc02044ea <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020450e:	f2842703          	lw	a4,-216(s0)
ffffffffc0204512:	478d                	li	a5,3
ffffffffc0204514:	0ef70b63          	beq	a4,a5,ffffffffc020460a <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc0204518:	4785                	li	a5,1
ffffffffc020451a:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc020451c:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc0204520:	515000ef          	jal	ra,ffffffffc0205234 <schedule>
        if (current->flags & PF_EXITING)
ffffffffc0204524:	000bb783          	ld	a5,0(s7)
ffffffffc0204528:	0b07a783          	lw	a5,176(a5)
ffffffffc020452c:	8b85                	andi	a5,a5,1
ffffffffc020452e:	d7c9                	beqz	a5,ffffffffc02044b8 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0204530:	555d                	li	a0,-9
ffffffffc0204532:	e0bff0ef          	jal	ra,ffffffffc020433c <do_exit>
        proc = current->cptr;
ffffffffc0204536:	000bb683          	ld	a3,0(s7)
ffffffffc020453a:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc020453c:	d45d                	beqz	s0,ffffffffc02044ea <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020453e:	470d                	li	a4,3
ffffffffc0204540:	a021                	j	ffffffffc0204548 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204542:	10043403          	ld	s0,256(s0)
ffffffffc0204546:	d869                	beqz	s0,ffffffffc0204518 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204548:	401c                	lw	a5,0(s0)
ffffffffc020454a:	fee79ce3          	bne	a5,a4,ffffffffc0204542 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc020454e:	000c2797          	auipc	a5,0xc2
ffffffffc0204552:	5e27b783          	ld	a5,1506(a5) # ffffffffc02c6b30 <idleproc>
ffffffffc0204556:	0c878963          	beq	a5,s0,ffffffffc0204628 <do_wait.part.0+0x1a2>
ffffffffc020455a:	000c2797          	auipc	a5,0xc2
ffffffffc020455e:	5de7b783          	ld	a5,1502(a5) # ffffffffc02c6b38 <initproc>
ffffffffc0204562:	0cf40363          	beq	s0,a5,ffffffffc0204628 <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc0204566:	000a0663          	beqz	s4,ffffffffc0204572 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc020456a:	0e842783          	lw	a5,232(s0)
ffffffffc020456e:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204572:	100027f3          	csrr	a5,sstatus
ffffffffc0204576:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204578:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020457a:	e7c1                	bnez	a5,ffffffffc0204602 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc020457c:	6c70                	ld	a2,216(s0)
ffffffffc020457e:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204580:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc0204584:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0204586:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204588:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020458a:	6470                	ld	a2,200(s0)
ffffffffc020458c:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc020458e:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204590:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc0204592:	c319                	beqz	a4,ffffffffc0204598 <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc0204594:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc0204596:	7c7c                	ld	a5,248(s0)
ffffffffc0204598:	c3b5                	beqz	a5,ffffffffc02045fc <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc020459a:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc020459e:	000c2717          	auipc	a4,0xc2
ffffffffc02045a2:	5a270713          	addi	a4,a4,1442 # ffffffffc02c6b40 <nr_process>
ffffffffc02045a6:	431c                	lw	a5,0(a4)
ffffffffc02045a8:	37fd                	addiw	a5,a5,-1
ffffffffc02045aa:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc02045ac:	e5a9                	bnez	a1,ffffffffc02045f6 <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02045ae:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc02045b0:	c02007b7          	lui	a5,0xc0200
ffffffffc02045b4:	04f6ee63          	bltu	a3,a5,ffffffffc0204610 <do_wait.part.0+0x18a>
ffffffffc02045b8:	000c2797          	auipc	a5,0xc2
ffffffffc02045bc:	5687b783          	ld	a5,1384(a5) # ffffffffc02c6b20 <va_pa_offset>
ffffffffc02045c0:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02045c2:	82b1                	srli	a3,a3,0xc
ffffffffc02045c4:	000c2797          	auipc	a5,0xc2
ffffffffc02045c8:	5447b783          	ld	a5,1348(a5) # ffffffffc02c6b08 <npage>
ffffffffc02045cc:	06f6fa63          	bgeu	a3,a5,ffffffffc0204640 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc02045d0:	00004517          	auipc	a0,0x4
ffffffffc02045d4:	ba853503          	ld	a0,-1112(a0) # ffffffffc0208178 <nbase>
ffffffffc02045d8:	8e89                	sub	a3,a3,a0
ffffffffc02045da:	069a                	slli	a3,a3,0x6
ffffffffc02045dc:	000c2517          	auipc	a0,0xc2
ffffffffc02045e0:	53453503          	ld	a0,1332(a0) # ffffffffc02c6b10 <pages>
ffffffffc02045e4:	9536                	add	a0,a0,a3
ffffffffc02045e6:	4589                	li	a1,2
ffffffffc02045e8:	82ffd0ef          	jal	ra,ffffffffc0201e16 <free_pages>
    kfree(proc);
ffffffffc02045ec:	8522                	mv	a0,s0
ffffffffc02045ee:	ebcfd0ef          	jal	ra,ffffffffc0201caa <kfree>
    return 0;
ffffffffc02045f2:	4501                	li	a0,0
ffffffffc02045f4:	bde5                	j	ffffffffc02044ec <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02045f6:	bb2fc0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc02045fa:	bf55                	j	ffffffffc02045ae <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02045fc:	701c                	ld	a5,32(s0)
ffffffffc02045fe:	fbf8                	sd	a4,240(a5)
ffffffffc0204600:	bf79                	j	ffffffffc020459e <do_wait.part.0+0x118>
        intr_disable();
ffffffffc0204602:	bacfc0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc0204606:	4585                	li	a1,1
ffffffffc0204608:	bf95                	j	ffffffffc020457c <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc020460a:	f2840413          	addi	s0,s0,-216
ffffffffc020460e:	b781                	j	ffffffffc020454e <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc0204610:	00002617          	auipc	a2,0x2
ffffffffc0204614:	1d860613          	addi	a2,a2,472 # ffffffffc02067e8 <default_pmm_manager+0xe0>
ffffffffc0204618:	07700593          	li	a1,119
ffffffffc020461c:	00002517          	auipc	a0,0x2
ffffffffc0204620:	14c50513          	addi	a0,a0,332 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc0204624:	e6ffb0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc0204628:	00003617          	auipc	a2,0x3
ffffffffc020462c:	b6860613          	addi	a2,a2,-1176 # ffffffffc0207190 <default_pmm_manager+0xa88>
ffffffffc0204630:	31d00593          	li	a1,797
ffffffffc0204634:	00003517          	auipc	a0,0x3
ffffffffc0204638:	b0450513          	addi	a0,a0,-1276 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc020463c:	e57fb0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204640:	00002617          	auipc	a2,0x2
ffffffffc0204644:	1d060613          	addi	a2,a2,464 # ffffffffc0206810 <default_pmm_manager+0x108>
ffffffffc0204648:	06900593          	li	a1,105
ffffffffc020464c:	00002517          	auipc	a0,0x2
ffffffffc0204650:	11c50513          	addi	a0,a0,284 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc0204654:	e3ffb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204658 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0204658:	1141                	addi	sp,sp,-16
ffffffffc020465a:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc020465c:	ffafd0ef          	jal	ra,ffffffffc0201e56 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204660:	d96fd0ef          	jal	ra,ffffffffc0201bf6 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204664:	4601                	li	a2,0
ffffffffc0204666:	4581                	li	a1,0
ffffffffc0204668:	00000517          	auipc	a0,0x0
ffffffffc020466c:	62850513          	addi	a0,a0,1576 # ffffffffc0204c90 <user_main>
ffffffffc0204670:	c7dff0ef          	jal	ra,ffffffffc02042ec <kernel_thread>
    if (pid <= 0)
ffffffffc0204674:	00a04563          	bgtz	a0,ffffffffc020467e <init_main+0x26>
ffffffffc0204678:	a071                	j	ffffffffc0204704 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc020467a:	3bb000ef          	jal	ra,ffffffffc0205234 <schedule>
    if (code_store != NULL)
ffffffffc020467e:	4581                	li	a1,0
ffffffffc0204680:	4501                	li	a0,0
ffffffffc0204682:	e05ff0ef          	jal	ra,ffffffffc0204486 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204686:	d975                	beqz	a0,ffffffffc020467a <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204688:	00003517          	auipc	a0,0x3
ffffffffc020468c:	b4850513          	addi	a0,a0,-1208 # ffffffffc02071d0 <default_pmm_manager+0xac8>
ffffffffc0204690:	b09fb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204694:	000c2797          	auipc	a5,0xc2
ffffffffc0204698:	4a47b783          	ld	a5,1188(a5) # ffffffffc02c6b38 <initproc>
ffffffffc020469c:	7bf8                	ld	a4,240(a5)
ffffffffc020469e:	e339                	bnez	a4,ffffffffc02046e4 <init_main+0x8c>
ffffffffc02046a0:	7ff8                	ld	a4,248(a5)
ffffffffc02046a2:	e329                	bnez	a4,ffffffffc02046e4 <init_main+0x8c>
ffffffffc02046a4:	1007b703          	ld	a4,256(a5)
ffffffffc02046a8:	ef15                	bnez	a4,ffffffffc02046e4 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc02046aa:	000c2697          	auipc	a3,0xc2
ffffffffc02046ae:	4966a683          	lw	a3,1174(a3) # ffffffffc02c6b40 <nr_process>
ffffffffc02046b2:	4709                	li	a4,2
ffffffffc02046b4:	0ae69463          	bne	a3,a4,ffffffffc020475c <init_main+0x104>
    return listelm->next;
ffffffffc02046b8:	000c2697          	auipc	a3,0xc2
ffffffffc02046bc:	3d068693          	addi	a3,a3,976 # ffffffffc02c6a88 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02046c0:	6698                	ld	a4,8(a3)
ffffffffc02046c2:	0c878793          	addi	a5,a5,200
ffffffffc02046c6:	06f71b63          	bne	a4,a5,ffffffffc020473c <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02046ca:	629c                	ld	a5,0(a3)
ffffffffc02046cc:	04f71863          	bne	a4,a5,ffffffffc020471c <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc02046d0:	00003517          	auipc	a0,0x3
ffffffffc02046d4:	be850513          	addi	a0,a0,-1048 # ffffffffc02072b8 <default_pmm_manager+0xbb0>
ffffffffc02046d8:	ac1fb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    return 0;
}
ffffffffc02046dc:	60a2                	ld	ra,8(sp)
ffffffffc02046de:	4501                	li	a0,0
ffffffffc02046e0:	0141                	addi	sp,sp,16
ffffffffc02046e2:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02046e4:	00003697          	auipc	a3,0x3
ffffffffc02046e8:	b1468693          	addi	a3,a3,-1260 # ffffffffc02071f8 <default_pmm_manager+0xaf0>
ffffffffc02046ec:	00002617          	auipc	a2,0x2
ffffffffc02046f0:	c6c60613          	addi	a2,a2,-916 # ffffffffc0206358 <commands+0x828>
ffffffffc02046f4:	38900593          	li	a1,905
ffffffffc02046f8:	00003517          	auipc	a0,0x3
ffffffffc02046fc:	a4050513          	addi	a0,a0,-1472 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204700:	d93fb0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("create user_main failed.\n");
ffffffffc0204704:	00003617          	auipc	a2,0x3
ffffffffc0204708:	aac60613          	addi	a2,a2,-1364 # ffffffffc02071b0 <default_pmm_manager+0xaa8>
ffffffffc020470c:	38000593          	li	a1,896
ffffffffc0204710:	00003517          	auipc	a0,0x3
ffffffffc0204714:	a2850513          	addi	a0,a0,-1496 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204718:	d7bfb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc020471c:	00003697          	auipc	a3,0x3
ffffffffc0204720:	b6c68693          	addi	a3,a3,-1172 # ffffffffc0207288 <default_pmm_manager+0xb80>
ffffffffc0204724:	00002617          	auipc	a2,0x2
ffffffffc0204728:	c3460613          	addi	a2,a2,-972 # ffffffffc0206358 <commands+0x828>
ffffffffc020472c:	38c00593          	li	a1,908
ffffffffc0204730:	00003517          	auipc	a0,0x3
ffffffffc0204734:	a0850513          	addi	a0,a0,-1528 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204738:	d5bfb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc020473c:	00003697          	auipc	a3,0x3
ffffffffc0204740:	b1c68693          	addi	a3,a3,-1252 # ffffffffc0207258 <default_pmm_manager+0xb50>
ffffffffc0204744:	00002617          	auipc	a2,0x2
ffffffffc0204748:	c1460613          	addi	a2,a2,-1004 # ffffffffc0206358 <commands+0x828>
ffffffffc020474c:	38b00593          	li	a1,907
ffffffffc0204750:	00003517          	auipc	a0,0x3
ffffffffc0204754:	9e850513          	addi	a0,a0,-1560 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204758:	d3bfb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_process == 2);
ffffffffc020475c:	00003697          	auipc	a3,0x3
ffffffffc0204760:	aec68693          	addi	a3,a3,-1300 # ffffffffc0207248 <default_pmm_manager+0xb40>
ffffffffc0204764:	00002617          	auipc	a2,0x2
ffffffffc0204768:	bf460613          	addi	a2,a2,-1036 # ffffffffc0206358 <commands+0x828>
ffffffffc020476c:	38a00593          	li	a1,906
ffffffffc0204770:	00003517          	auipc	a0,0x3
ffffffffc0204774:	9c850513          	addi	a0,a0,-1592 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204778:	d1bfb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020477c <do_execve>:
{
ffffffffc020477c:	7171                	addi	sp,sp,-176
ffffffffc020477e:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204780:	000c2d97          	auipc	s11,0xc2
ffffffffc0204784:	3a8d8d93          	addi	s11,s11,936 # ffffffffc02c6b28 <current>
ffffffffc0204788:	000db783          	ld	a5,0(s11)
{
ffffffffc020478c:	e54e                	sd	s3,136(sp)
ffffffffc020478e:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204790:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204794:	e94a                	sd	s2,144(sp)
ffffffffc0204796:	f4de                	sd	s7,104(sp)
ffffffffc0204798:	892a                	mv	s2,a0
ffffffffc020479a:	8bb2                	mv	s7,a2
ffffffffc020479c:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc020479e:	862e                	mv	a2,a1
ffffffffc02047a0:	4681                	li	a3,0
ffffffffc02047a2:	85aa                	mv	a1,a0
ffffffffc02047a4:	854e                	mv	a0,s3
{
ffffffffc02047a6:	f506                	sd	ra,168(sp)
ffffffffc02047a8:	f122                	sd	s0,160(sp)
ffffffffc02047aa:	e152                	sd	s4,128(sp)
ffffffffc02047ac:	fcd6                	sd	s5,120(sp)
ffffffffc02047ae:	f8da                	sd	s6,112(sp)
ffffffffc02047b0:	f0e2                	sd	s8,96(sp)
ffffffffc02047b2:	ece6                	sd	s9,88(sp)
ffffffffc02047b4:	e8ea                	sd	s10,80(sp)
ffffffffc02047b6:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc02047b8:	d20ff0ef          	jal	ra,ffffffffc0203cd8 <user_mem_check>
ffffffffc02047bc:	40050a63          	beqz	a0,ffffffffc0204bd0 <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc02047c0:	4641                	li	a2,16
ffffffffc02047c2:	4581                	li	a1,0
ffffffffc02047c4:	1808                	addi	a0,sp,48
ffffffffc02047c6:	0d4010ef          	jal	ra,ffffffffc020589a <memset>
    memcpy(local_name, name, len);
ffffffffc02047ca:	47bd                	li	a5,15
ffffffffc02047cc:	8626                	mv	a2,s1
ffffffffc02047ce:	1e97e263          	bltu	a5,s1,ffffffffc02049b2 <do_execve+0x236>
ffffffffc02047d2:	85ca                	mv	a1,s2
ffffffffc02047d4:	1808                	addi	a0,sp,48
ffffffffc02047d6:	0d6010ef          	jal	ra,ffffffffc02058ac <memcpy>
    if (mm != NULL)
ffffffffc02047da:	1e098363          	beqz	s3,ffffffffc02049c0 <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc02047de:	00002517          	auipc	a0,0x2
ffffffffc02047e2:	75a50513          	addi	a0,a0,1882 # ffffffffc0206f38 <default_pmm_manager+0x830>
ffffffffc02047e6:	9ebfb0ef          	jal	ra,ffffffffc02001d0 <cputs>
ffffffffc02047ea:	000c2797          	auipc	a5,0xc2
ffffffffc02047ee:	30e7b783          	ld	a5,782(a5) # ffffffffc02c6af8 <boot_pgdir_pa>
ffffffffc02047f2:	577d                	li	a4,-1
ffffffffc02047f4:	177e                	slli	a4,a4,0x3f
ffffffffc02047f6:	83b1                	srli	a5,a5,0xc
ffffffffc02047f8:	8fd9                	or	a5,a5,a4
ffffffffc02047fa:	18079073          	csrw	satp,a5
ffffffffc02047fe:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7f00>
ffffffffc0204802:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204806:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc020480a:	2c070463          	beqz	a4,ffffffffc0204ad2 <do_execve+0x356>
        current->mm = NULL;
ffffffffc020480e:	000db783          	ld	a5,0(s11)
ffffffffc0204812:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204816:	e4dfe0ef          	jal	ra,ffffffffc0203662 <mm_create>
ffffffffc020481a:	84aa                	mv	s1,a0
ffffffffc020481c:	1c050d63          	beqz	a0,ffffffffc02049f6 <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc0204820:	4505                	li	a0,1
ffffffffc0204822:	db6fd0ef          	jal	ra,ffffffffc0201dd8 <alloc_pages>
ffffffffc0204826:	3a050963          	beqz	a0,ffffffffc0204bd8 <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc020482a:	000c2c97          	auipc	s9,0xc2
ffffffffc020482e:	2e6c8c93          	addi	s9,s9,742 # ffffffffc02c6b10 <pages>
ffffffffc0204832:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204836:	000c2c17          	auipc	s8,0xc2
ffffffffc020483a:	2d2c0c13          	addi	s8,s8,722 # ffffffffc02c6b08 <npage>
    return page - pages + nbase;
ffffffffc020483e:	00004717          	auipc	a4,0x4
ffffffffc0204842:	93a73703          	ld	a4,-1734(a4) # ffffffffc0208178 <nbase>
ffffffffc0204846:	40d506b3          	sub	a3,a0,a3
ffffffffc020484a:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020484c:	5afd                	li	s5,-1
ffffffffc020484e:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204852:	96ba                	add	a3,a3,a4
ffffffffc0204854:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204856:	00cad713          	srli	a4,s5,0xc
ffffffffc020485a:	ec3a                	sd	a4,24(sp)
ffffffffc020485c:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc020485e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204860:	38f77063          	bgeu	a4,a5,ffffffffc0204be0 <do_execve+0x464>
ffffffffc0204864:	000c2b17          	auipc	s6,0xc2
ffffffffc0204868:	2bcb0b13          	addi	s6,s6,700 # ffffffffc02c6b20 <va_pa_offset>
ffffffffc020486c:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204870:	6605                	lui	a2,0x1
ffffffffc0204872:	000c2597          	auipc	a1,0xc2
ffffffffc0204876:	28e5b583          	ld	a1,654(a1) # ffffffffc02c6b00 <boot_pgdir_va>
ffffffffc020487a:	9936                	add	s2,s2,a3
ffffffffc020487c:	854a                	mv	a0,s2
ffffffffc020487e:	02e010ef          	jal	ra,ffffffffc02058ac <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204882:	7782                	ld	a5,32(sp)
ffffffffc0204884:	4398                	lw	a4,0(a5)
ffffffffc0204886:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc020488a:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc020488e:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_matrix_out_size+0x464b7e77>
ffffffffc0204892:	14f71863          	bne	a4,a5,ffffffffc02049e2 <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204896:	7682                	ld	a3,32(sp)
ffffffffc0204898:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc020489c:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02048a0:	00371793          	slli	a5,a4,0x3
ffffffffc02048a4:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc02048a6:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02048a8:	078e                	slli	a5,a5,0x3
ffffffffc02048aa:	97ce                	add	a5,a5,s3
ffffffffc02048ac:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc02048ae:	00f9fc63          	bgeu	s3,a5,ffffffffc02048c6 <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc02048b2:	0009a783          	lw	a5,0(s3)
ffffffffc02048b6:	4705                	li	a4,1
ffffffffc02048b8:	14e78163          	beq	a5,a4,ffffffffc02049fa <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc02048bc:	77a2                	ld	a5,40(sp)
ffffffffc02048be:	03898993          	addi	s3,s3,56
ffffffffc02048c2:	fef9e8e3          	bltu	s3,a5,ffffffffc02048b2 <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc02048c6:	4701                	li	a4,0
ffffffffc02048c8:	46ad                	li	a3,11
ffffffffc02048ca:	00100637          	lui	a2,0x100
ffffffffc02048ce:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02048d2:	8526                	mv	a0,s1
ffffffffc02048d4:	f21fe0ef          	jal	ra,ffffffffc02037f4 <mm_map>
ffffffffc02048d8:	8a2a                	mv	s4,a0
ffffffffc02048da:	1e051263          	bnez	a0,ffffffffc0204abe <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc02048de:	6c88                	ld	a0,24(s1)
ffffffffc02048e0:	467d                	li	a2,31
ffffffffc02048e2:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02048e6:	c97fe0ef          	jal	ra,ffffffffc020357c <pgdir_alloc_page>
ffffffffc02048ea:	38050363          	beqz	a0,ffffffffc0204c70 <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc02048ee:	6c88                	ld	a0,24(s1)
ffffffffc02048f0:	467d                	li	a2,31
ffffffffc02048f2:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02048f6:	c87fe0ef          	jal	ra,ffffffffc020357c <pgdir_alloc_page>
ffffffffc02048fa:	34050b63          	beqz	a0,ffffffffc0204c50 <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc02048fe:	6c88                	ld	a0,24(s1)
ffffffffc0204900:	467d                	li	a2,31
ffffffffc0204902:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204906:	c77fe0ef          	jal	ra,ffffffffc020357c <pgdir_alloc_page>
ffffffffc020490a:	32050363          	beqz	a0,ffffffffc0204c30 <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc020490e:	6c88                	ld	a0,24(s1)
ffffffffc0204910:	467d                	li	a2,31
ffffffffc0204912:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204916:	c67fe0ef          	jal	ra,ffffffffc020357c <pgdir_alloc_page>
ffffffffc020491a:	2e050b63          	beqz	a0,ffffffffc0204c10 <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc020491e:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204920:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204924:	6c94                	ld	a3,24(s1)
ffffffffc0204926:	2785                	addiw	a5,a5,1
ffffffffc0204928:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc020492a:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc020492c:	c02007b7          	lui	a5,0xc0200
ffffffffc0204930:	2cf6e463          	bltu	a3,a5,ffffffffc0204bf8 <do_execve+0x47c>
ffffffffc0204934:	000b3783          	ld	a5,0(s6)
ffffffffc0204938:	577d                	li	a4,-1
ffffffffc020493a:	177e                	slli	a4,a4,0x3f
ffffffffc020493c:	8e9d                	sub	a3,a3,a5
ffffffffc020493e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204942:	f654                	sd	a3,168(a2)
ffffffffc0204944:	8fd9                	or	a5,a5,a4
ffffffffc0204946:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc020494a:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc020494c:	4581                	li	a1,0
ffffffffc020494e:	12000613          	li	a2,288
ffffffffc0204952:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204954:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204958:	743000ef          	jal	ra,ffffffffc020589a <memset>
    tf->epc = elf->e_entry;
ffffffffc020495c:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020495e:	000db903          	ld	s2,0(s11)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204962:	edf4f493          	andi	s1,s1,-289
    tf->epc = elf->e_entry;
ffffffffc0204966:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204968:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020496a:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_matrix_out_size+0xffffffff7fff39ac>
    tf->gpr.sp = USTACKTOP;
ffffffffc020496e:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204970:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204974:	4641                	li	a2,16
ffffffffc0204976:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204978:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc020497a:	10e43423          	sd	a4,264(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc020497e:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204982:	854a                	mv	a0,s2
ffffffffc0204984:	717000ef          	jal	ra,ffffffffc020589a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204988:	463d                	li	a2,15
ffffffffc020498a:	180c                	addi	a1,sp,48
ffffffffc020498c:	854a                	mv	a0,s2
ffffffffc020498e:	71f000ef          	jal	ra,ffffffffc02058ac <memcpy>
}
ffffffffc0204992:	70aa                	ld	ra,168(sp)
ffffffffc0204994:	740a                	ld	s0,160(sp)
ffffffffc0204996:	64ea                	ld	s1,152(sp)
ffffffffc0204998:	694a                	ld	s2,144(sp)
ffffffffc020499a:	69aa                	ld	s3,136(sp)
ffffffffc020499c:	7ae6                	ld	s5,120(sp)
ffffffffc020499e:	7b46                	ld	s6,112(sp)
ffffffffc02049a0:	7ba6                	ld	s7,104(sp)
ffffffffc02049a2:	7c06                	ld	s8,96(sp)
ffffffffc02049a4:	6ce6                	ld	s9,88(sp)
ffffffffc02049a6:	6d46                	ld	s10,80(sp)
ffffffffc02049a8:	6da6                	ld	s11,72(sp)
ffffffffc02049aa:	8552                	mv	a0,s4
ffffffffc02049ac:	6a0a                	ld	s4,128(sp)
ffffffffc02049ae:	614d                	addi	sp,sp,176
ffffffffc02049b0:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc02049b2:	463d                	li	a2,15
ffffffffc02049b4:	85ca                	mv	a1,s2
ffffffffc02049b6:	1808                	addi	a0,sp,48
ffffffffc02049b8:	6f5000ef          	jal	ra,ffffffffc02058ac <memcpy>
    if (mm != NULL)
ffffffffc02049bc:	e20991e3          	bnez	s3,ffffffffc02047de <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc02049c0:	000db783          	ld	a5,0(s11)
ffffffffc02049c4:	779c                	ld	a5,40(a5)
ffffffffc02049c6:	e40788e3          	beqz	a5,ffffffffc0204816 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc02049ca:	00003617          	auipc	a2,0x3
ffffffffc02049ce:	90e60613          	addi	a2,a2,-1778 # ffffffffc02072d8 <default_pmm_manager+0xbd0>
ffffffffc02049d2:	21000593          	li	a1,528
ffffffffc02049d6:	00002517          	auipc	a0,0x2
ffffffffc02049da:	76250513          	addi	a0,a0,1890 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc02049de:	ab5fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    put_pgdir(mm);
ffffffffc02049e2:	8526                	mv	a0,s1
ffffffffc02049e4:	c48ff0ef          	jal	ra,ffffffffc0203e2c <put_pgdir>
    mm_destroy(mm);
ffffffffc02049e8:	8526                	mv	a0,s1
ffffffffc02049ea:	db9fe0ef          	jal	ra,ffffffffc02037a2 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc02049ee:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc02049f0:	8552                	mv	a0,s4
ffffffffc02049f2:	94bff0ef          	jal	ra,ffffffffc020433c <do_exit>
    int ret = -E_NO_MEM;
ffffffffc02049f6:	5a71                	li	s4,-4
ffffffffc02049f8:	bfe5                	j	ffffffffc02049f0 <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc02049fa:	0289b603          	ld	a2,40(s3)
ffffffffc02049fe:	0209b783          	ld	a5,32(s3)
ffffffffc0204a02:	1cf66d63          	bltu	a2,a5,ffffffffc0204bdc <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204a06:	0049a783          	lw	a5,4(s3)
ffffffffc0204a0a:	0017f693          	andi	a3,a5,1
ffffffffc0204a0e:	c291                	beqz	a3,ffffffffc0204a12 <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204a10:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204a12:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204a16:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204a18:	e779                	bnez	a4,ffffffffc0204ae6 <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204a1a:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204a1c:	c781                	beqz	a5,ffffffffc0204a24 <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204a1e:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204a22:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204a24:	0026f793          	andi	a5,a3,2
ffffffffc0204a28:	e3f1                	bnez	a5,ffffffffc0204aec <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc0204a2a:	0046f793          	andi	a5,a3,4
ffffffffc0204a2e:	c399                	beqz	a5,ffffffffc0204a34 <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204a30:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204a34:	0109b583          	ld	a1,16(s3)
ffffffffc0204a38:	4701                	li	a4,0
ffffffffc0204a3a:	8526                	mv	a0,s1
ffffffffc0204a3c:	db9fe0ef          	jal	ra,ffffffffc02037f4 <mm_map>
ffffffffc0204a40:	8a2a                	mv	s4,a0
ffffffffc0204a42:	ed35                	bnez	a0,ffffffffc0204abe <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204a44:	0109bb83          	ld	s7,16(s3)
ffffffffc0204a48:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204a4a:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204a4e:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204a52:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204a56:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204a58:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204a5a:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204a5c:	054be963          	bltu	s7,s4,ffffffffc0204aae <do_execve+0x332>
ffffffffc0204a60:	aa95                	j	ffffffffc0204bd4 <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204a62:	6785                	lui	a5,0x1
ffffffffc0204a64:	415b8533          	sub	a0,s7,s5
ffffffffc0204a68:	9abe                	add	s5,s5,a5
ffffffffc0204a6a:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204a6e:	015a7463          	bgeu	s4,s5,ffffffffc0204a76 <do_execve+0x2fa>
                size -= la - end;
ffffffffc0204a72:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204a76:	000cb683          	ld	a3,0(s9)
ffffffffc0204a7a:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204a7c:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204a80:	40d406b3          	sub	a3,s0,a3
ffffffffc0204a84:	8699                	srai	a3,a3,0x6
ffffffffc0204a86:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204a88:	67e2                	ld	a5,24(sp)
ffffffffc0204a8a:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204a8e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204a90:	14b87863          	bgeu	a6,a1,ffffffffc0204be0 <do_execve+0x464>
ffffffffc0204a94:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204a98:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204a9a:	9bb2                	add	s7,s7,a2
ffffffffc0204a9c:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204a9e:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204aa0:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204aa2:	60b000ef          	jal	ra,ffffffffc02058ac <memcpy>
            start += size, from += size;
ffffffffc0204aa6:	6622                	ld	a2,8(sp)
ffffffffc0204aa8:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204aaa:	054bf363          	bgeu	s7,s4,ffffffffc0204af0 <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204aae:	6c88                	ld	a0,24(s1)
ffffffffc0204ab0:	866a                	mv	a2,s10
ffffffffc0204ab2:	85d6                	mv	a1,s5
ffffffffc0204ab4:	ac9fe0ef          	jal	ra,ffffffffc020357c <pgdir_alloc_page>
ffffffffc0204ab8:	842a                	mv	s0,a0
ffffffffc0204aba:	f545                	bnez	a0,ffffffffc0204a62 <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc0204abc:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204abe:	8526                	mv	a0,s1
ffffffffc0204ac0:	e7ffe0ef          	jal	ra,ffffffffc020393e <exit_mmap>
    put_pgdir(mm);
ffffffffc0204ac4:	8526                	mv	a0,s1
ffffffffc0204ac6:	b66ff0ef          	jal	ra,ffffffffc0203e2c <put_pgdir>
    mm_destroy(mm);
ffffffffc0204aca:	8526                	mv	a0,s1
ffffffffc0204acc:	cd7fe0ef          	jal	ra,ffffffffc02037a2 <mm_destroy>
    return ret;
ffffffffc0204ad0:	b705                	j	ffffffffc02049f0 <do_execve+0x274>
            exit_mmap(mm);
ffffffffc0204ad2:	854e                	mv	a0,s3
ffffffffc0204ad4:	e6bfe0ef          	jal	ra,ffffffffc020393e <exit_mmap>
            put_pgdir(mm);
ffffffffc0204ad8:	854e                	mv	a0,s3
ffffffffc0204ada:	b52ff0ef          	jal	ra,ffffffffc0203e2c <put_pgdir>
            mm_destroy(mm);
ffffffffc0204ade:	854e                	mv	a0,s3
ffffffffc0204ae0:	cc3fe0ef          	jal	ra,ffffffffc02037a2 <mm_destroy>
ffffffffc0204ae4:	b32d                	j	ffffffffc020480e <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204ae6:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204aea:	fb95                	bnez	a5,ffffffffc0204a1e <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0204aec:	4d5d                	li	s10,23
ffffffffc0204aee:	bf35                	j	ffffffffc0204a2a <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204af0:	0109b683          	ld	a3,16(s3)
ffffffffc0204af4:	0289b903          	ld	s2,40(s3)
ffffffffc0204af8:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204afa:	075bfd63          	bgeu	s7,s5,ffffffffc0204b74 <do_execve+0x3f8>
            if (start == end)
ffffffffc0204afe:	db790fe3          	beq	s2,s7,ffffffffc02048bc <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204b02:	6785                	lui	a5,0x1
ffffffffc0204b04:	00fb8533          	add	a0,s7,a5
ffffffffc0204b08:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204b0c:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204b10:	0b597d63          	bgeu	s2,s5,ffffffffc0204bca <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204b14:	000cb683          	ld	a3,0(s9)
ffffffffc0204b18:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204b1a:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204b1e:	40d406b3          	sub	a3,s0,a3
ffffffffc0204b22:	8699                	srai	a3,a3,0x6
ffffffffc0204b24:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204b26:	67e2                	ld	a5,24(sp)
ffffffffc0204b28:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b2c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b2e:	0ac5f963          	bgeu	a1,a2,ffffffffc0204be0 <do_execve+0x464>
ffffffffc0204b32:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204b36:	8652                	mv	a2,s4
ffffffffc0204b38:	4581                	li	a1,0
ffffffffc0204b3a:	96c2                	add	a3,a3,a6
ffffffffc0204b3c:	9536                	add	a0,a0,a3
ffffffffc0204b3e:	55d000ef          	jal	ra,ffffffffc020589a <memset>
            start += size;
ffffffffc0204b42:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204b46:	03597463          	bgeu	s2,s5,ffffffffc0204b6e <do_execve+0x3f2>
ffffffffc0204b4a:	d6e909e3          	beq	s2,a4,ffffffffc02048bc <do_execve+0x140>
ffffffffc0204b4e:	00002697          	auipc	a3,0x2
ffffffffc0204b52:	7b268693          	addi	a3,a3,1970 # ffffffffc0207300 <default_pmm_manager+0xbf8>
ffffffffc0204b56:	00002617          	auipc	a2,0x2
ffffffffc0204b5a:	80260613          	addi	a2,a2,-2046 # ffffffffc0206358 <commands+0x828>
ffffffffc0204b5e:	27900593          	li	a1,633
ffffffffc0204b62:	00002517          	auipc	a0,0x2
ffffffffc0204b66:	5d650513          	addi	a0,a0,1494 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204b6a:	929fb0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc0204b6e:	ff5710e3          	bne	a4,s5,ffffffffc0204b4e <do_execve+0x3d2>
ffffffffc0204b72:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204b74:	d52bf4e3          	bgeu	s7,s2,ffffffffc02048bc <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204b78:	6c88                	ld	a0,24(s1)
ffffffffc0204b7a:	866a                	mv	a2,s10
ffffffffc0204b7c:	85d6                	mv	a1,s5
ffffffffc0204b7e:	9fffe0ef          	jal	ra,ffffffffc020357c <pgdir_alloc_page>
ffffffffc0204b82:	842a                	mv	s0,a0
ffffffffc0204b84:	dd05                	beqz	a0,ffffffffc0204abc <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204b86:	6785                	lui	a5,0x1
ffffffffc0204b88:	415b8533          	sub	a0,s7,s5
ffffffffc0204b8c:	9abe                	add	s5,s5,a5
ffffffffc0204b8e:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204b92:	01597463          	bgeu	s2,s5,ffffffffc0204b9a <do_execve+0x41e>
                size -= la - end;
ffffffffc0204b96:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204b9a:	000cb683          	ld	a3,0(s9)
ffffffffc0204b9e:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204ba0:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204ba4:	40d406b3          	sub	a3,s0,a3
ffffffffc0204ba8:	8699                	srai	a3,a3,0x6
ffffffffc0204baa:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204bac:	67e2                	ld	a5,24(sp)
ffffffffc0204bae:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204bb2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204bb4:	02b87663          	bgeu	a6,a1,ffffffffc0204be0 <do_execve+0x464>
ffffffffc0204bb8:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204bbc:	4581                	li	a1,0
            start += size;
ffffffffc0204bbe:	9bb2                	add	s7,s7,a2
ffffffffc0204bc0:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204bc2:	9536                	add	a0,a0,a3
ffffffffc0204bc4:	4d7000ef          	jal	ra,ffffffffc020589a <memset>
ffffffffc0204bc8:	b775                	j	ffffffffc0204b74 <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204bca:	417a8a33          	sub	s4,s5,s7
ffffffffc0204bce:	b799                	j	ffffffffc0204b14 <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204bd0:	5a75                	li	s4,-3
ffffffffc0204bd2:	b3c1                	j	ffffffffc0204992 <do_execve+0x216>
        while (start < end)
ffffffffc0204bd4:	86de                	mv	a3,s7
ffffffffc0204bd6:	bf39                	j	ffffffffc0204af4 <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204bd8:	5a71                	li	s4,-4
ffffffffc0204bda:	bdc5                	j	ffffffffc0204aca <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204bdc:	5a61                	li	s4,-8
ffffffffc0204bde:	b5c5                	j	ffffffffc0204abe <do_execve+0x342>
ffffffffc0204be0:	00002617          	auipc	a2,0x2
ffffffffc0204be4:	b6060613          	addi	a2,a2,-1184 # ffffffffc0206740 <default_pmm_manager+0x38>
ffffffffc0204be8:	07100593          	li	a1,113
ffffffffc0204bec:	00002517          	auipc	a0,0x2
ffffffffc0204bf0:	b7c50513          	addi	a0,a0,-1156 # ffffffffc0206768 <default_pmm_manager+0x60>
ffffffffc0204bf4:	89ffb0ef          	jal	ra,ffffffffc0200492 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204bf8:	00002617          	auipc	a2,0x2
ffffffffc0204bfc:	bf060613          	addi	a2,a2,-1040 # ffffffffc02067e8 <default_pmm_manager+0xe0>
ffffffffc0204c00:	29800593          	li	a1,664
ffffffffc0204c04:	00002517          	auipc	a0,0x2
ffffffffc0204c08:	53450513          	addi	a0,a0,1332 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204c0c:	887fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204c10:	00003697          	auipc	a3,0x3
ffffffffc0204c14:	80868693          	addi	a3,a3,-2040 # ffffffffc0207418 <default_pmm_manager+0xd10>
ffffffffc0204c18:	00001617          	auipc	a2,0x1
ffffffffc0204c1c:	74060613          	addi	a2,a2,1856 # ffffffffc0206358 <commands+0x828>
ffffffffc0204c20:	29300593          	li	a1,659
ffffffffc0204c24:	00002517          	auipc	a0,0x2
ffffffffc0204c28:	51450513          	addi	a0,a0,1300 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204c2c:	867fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204c30:	00002697          	auipc	a3,0x2
ffffffffc0204c34:	7a068693          	addi	a3,a3,1952 # ffffffffc02073d0 <default_pmm_manager+0xcc8>
ffffffffc0204c38:	00001617          	auipc	a2,0x1
ffffffffc0204c3c:	72060613          	addi	a2,a2,1824 # ffffffffc0206358 <commands+0x828>
ffffffffc0204c40:	29200593          	li	a1,658
ffffffffc0204c44:	00002517          	auipc	a0,0x2
ffffffffc0204c48:	4f450513          	addi	a0,a0,1268 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204c4c:	847fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204c50:	00002697          	auipc	a3,0x2
ffffffffc0204c54:	73868693          	addi	a3,a3,1848 # ffffffffc0207388 <default_pmm_manager+0xc80>
ffffffffc0204c58:	00001617          	auipc	a2,0x1
ffffffffc0204c5c:	70060613          	addi	a2,a2,1792 # ffffffffc0206358 <commands+0x828>
ffffffffc0204c60:	29100593          	li	a1,657
ffffffffc0204c64:	00002517          	auipc	a0,0x2
ffffffffc0204c68:	4d450513          	addi	a0,a0,1236 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204c6c:	827fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204c70:	00002697          	auipc	a3,0x2
ffffffffc0204c74:	6d068693          	addi	a3,a3,1744 # ffffffffc0207340 <default_pmm_manager+0xc38>
ffffffffc0204c78:	00001617          	auipc	a2,0x1
ffffffffc0204c7c:	6e060613          	addi	a2,a2,1760 # ffffffffc0206358 <commands+0x828>
ffffffffc0204c80:	29000593          	li	a1,656
ffffffffc0204c84:	00002517          	auipc	a0,0x2
ffffffffc0204c88:	4b450513          	addi	a0,a0,1204 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204c8c:	807fb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204c90 <user_main>:
{
ffffffffc0204c90:	1101                	addi	sp,sp,-32
ffffffffc0204c92:	e04a                	sd	s2,0(sp)
    KERNEL_EXECVE(priority);
ffffffffc0204c94:	000c2917          	auipc	s2,0xc2
ffffffffc0204c98:	e9490913          	addi	s2,s2,-364 # ffffffffc02c6b28 <current>
ffffffffc0204c9c:	00093783          	ld	a5,0(s2)
ffffffffc0204ca0:	00002617          	auipc	a2,0x2
ffffffffc0204ca4:	7c060613          	addi	a2,a2,1984 # ffffffffc0207460 <default_pmm_manager+0xd58>
ffffffffc0204ca8:	00002517          	auipc	a0,0x2
ffffffffc0204cac:	7c850513          	addi	a0,a0,1992 # ffffffffc0207470 <default_pmm_manager+0xd68>
ffffffffc0204cb0:	43cc                	lw	a1,4(a5)
{
ffffffffc0204cb2:	ec06                	sd	ra,24(sp)
ffffffffc0204cb4:	e822                	sd	s0,16(sp)
ffffffffc0204cb6:	e426                	sd	s1,8(sp)
    KERNEL_EXECVE(priority);
ffffffffc0204cb8:	ce0fb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    size_t len = strlen(name);
ffffffffc0204cbc:	00002517          	auipc	a0,0x2
ffffffffc0204cc0:	7a450513          	addi	a0,a0,1956 # ffffffffc0207460 <default_pmm_manager+0xd58>
ffffffffc0204cc4:	335000ef          	jal	ra,ffffffffc02057f8 <strlen>
    struct trapframe *old_tf = current->tf;
ffffffffc0204cc8:	00093783          	ld	a5,0(s2)
    size_t len = strlen(name);
ffffffffc0204ccc:	84aa                	mv	s1,a0
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204cce:	12000613          	li	a2,288
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0204cd2:	6b80                	ld	s0,16(a5)
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204cd4:	73cc                	ld	a1,160(a5)
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0204cd6:	6789                	lui	a5,0x2
ffffffffc0204cd8:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x8050>
ffffffffc0204cdc:	943e                	add	s0,s0,a5
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204cde:	8522                	mv	a0,s0
ffffffffc0204ce0:	3cd000ef          	jal	ra,ffffffffc02058ac <memcpy>
    current->tf = new_tf;
ffffffffc0204ce4:	00093783          	ld	a5,0(s2)
    ret = do_execve(name, len, binary, size);
ffffffffc0204ce8:	3fe07697          	auipc	a3,0x3fe07
ffffffffc0204cec:	a5068693          	addi	a3,a3,-1456 # b738 <_binary_obj___user_priority_out_size>
ffffffffc0204cf0:	0007d617          	auipc	a2,0x7d
ffffffffc0204cf4:	fb060613          	addi	a2,a2,-80 # ffffffffc0281ca0 <_binary_obj___user_priority_out_start>
    current->tf = new_tf;
ffffffffc0204cf8:	f3c0                	sd	s0,160(a5)
    ret = do_execve(name, len, binary, size);
ffffffffc0204cfa:	85a6                	mv	a1,s1
ffffffffc0204cfc:	00002517          	auipc	a0,0x2
ffffffffc0204d00:	76450513          	addi	a0,a0,1892 # ffffffffc0207460 <default_pmm_manager+0xd58>
ffffffffc0204d04:	a79ff0ef          	jal	ra,ffffffffc020477c <do_execve>
    asm volatile(
ffffffffc0204d08:	8122                	mv	sp,s0
ffffffffc0204d0a:	9b2fc06f          	j	ffffffffc0200ebc <__trapret>
    panic("user_main execve failed.\n");
ffffffffc0204d0e:	00002617          	auipc	a2,0x2
ffffffffc0204d12:	78a60613          	addi	a2,a2,1930 # ffffffffc0207498 <default_pmm_manager+0xd90>
ffffffffc0204d16:	37300593          	li	a1,883
ffffffffc0204d1a:	00002517          	auipc	a0,0x2
ffffffffc0204d1e:	41e50513          	addi	a0,a0,1054 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204d22:	f70fb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204d26 <do_yield>:
    current->need_resched = 1;
ffffffffc0204d26:	000c2797          	auipc	a5,0xc2
ffffffffc0204d2a:	e027b783          	ld	a5,-510(a5) # ffffffffc02c6b28 <current>
ffffffffc0204d2e:	4705                	li	a4,1
ffffffffc0204d30:	ef98                	sd	a4,24(a5)
}
ffffffffc0204d32:	4501                	li	a0,0
ffffffffc0204d34:	8082                	ret

ffffffffc0204d36 <do_wait>:
{
ffffffffc0204d36:	1101                	addi	sp,sp,-32
ffffffffc0204d38:	e822                	sd	s0,16(sp)
ffffffffc0204d3a:	e426                	sd	s1,8(sp)
ffffffffc0204d3c:	ec06                	sd	ra,24(sp)
ffffffffc0204d3e:	842e                	mv	s0,a1
ffffffffc0204d40:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204d42:	c999                	beqz	a1,ffffffffc0204d58 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204d44:	000c2797          	auipc	a5,0xc2
ffffffffc0204d48:	de47b783          	ld	a5,-540(a5) # ffffffffc02c6b28 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204d4c:	7788                	ld	a0,40(a5)
ffffffffc0204d4e:	4685                	li	a3,1
ffffffffc0204d50:	4611                	li	a2,4
ffffffffc0204d52:	f87fe0ef          	jal	ra,ffffffffc0203cd8 <user_mem_check>
ffffffffc0204d56:	c909                	beqz	a0,ffffffffc0204d68 <do_wait+0x32>
ffffffffc0204d58:	85a2                	mv	a1,s0
}
ffffffffc0204d5a:	6442                	ld	s0,16(sp)
ffffffffc0204d5c:	60e2                	ld	ra,24(sp)
ffffffffc0204d5e:	8526                	mv	a0,s1
ffffffffc0204d60:	64a2                	ld	s1,8(sp)
ffffffffc0204d62:	6105                	addi	sp,sp,32
ffffffffc0204d64:	f22ff06f          	j	ffffffffc0204486 <do_wait.part.0>
ffffffffc0204d68:	60e2                	ld	ra,24(sp)
ffffffffc0204d6a:	6442                	ld	s0,16(sp)
ffffffffc0204d6c:	64a2                	ld	s1,8(sp)
ffffffffc0204d6e:	5575                	li	a0,-3
ffffffffc0204d70:	6105                	addi	sp,sp,32
ffffffffc0204d72:	8082                	ret

ffffffffc0204d74 <do_kill>:
{
ffffffffc0204d74:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204d76:	6789                	lui	a5,0x2
{
ffffffffc0204d78:	e406                	sd	ra,8(sp)
ffffffffc0204d7a:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204d7c:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204d80:	17f9                	addi	a5,a5,-2
ffffffffc0204d82:	02e7e963          	bltu	a5,a4,ffffffffc0204db4 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204d86:	842a                	mv	s0,a0
ffffffffc0204d88:	45a9                	li	a1,10
ffffffffc0204d8a:	2501                	sext.w	a0,a0
ffffffffc0204d8c:	668000ef          	jal	ra,ffffffffc02053f4 <hash32>
ffffffffc0204d90:	02051793          	slli	a5,a0,0x20
ffffffffc0204d94:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204d98:	000be797          	auipc	a5,0xbe
ffffffffc0204d9c:	cf078793          	addi	a5,a5,-784 # ffffffffc02c2a88 <hash_list>
ffffffffc0204da0:	953e                	add	a0,a0,a5
ffffffffc0204da2:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204da4:	a029                	j	ffffffffc0204dae <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204da6:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204daa:	00870b63          	beq	a4,s0,ffffffffc0204dc0 <do_kill+0x4c>
ffffffffc0204dae:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204db0:	fef51be3          	bne	a0,a5,ffffffffc0204da6 <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204db4:	5475                	li	s0,-3
}
ffffffffc0204db6:	60a2                	ld	ra,8(sp)
ffffffffc0204db8:	8522                	mv	a0,s0
ffffffffc0204dba:	6402                	ld	s0,0(sp)
ffffffffc0204dbc:	0141                	addi	sp,sp,16
ffffffffc0204dbe:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204dc0:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204dc4:	00177693          	andi	a3,a4,1
ffffffffc0204dc8:	e295                	bnez	a3,ffffffffc0204dec <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204dca:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204dcc:	00176713          	ori	a4,a4,1
ffffffffc0204dd0:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0204dd4:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204dd6:	fe06d0e3          	bgez	a3,ffffffffc0204db6 <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0204dda:	f2878513          	addi	a0,a5,-216
ffffffffc0204dde:	3a4000ef          	jal	ra,ffffffffc0205182 <wakeup_proc>
}
ffffffffc0204de2:	60a2                	ld	ra,8(sp)
ffffffffc0204de4:	8522                	mv	a0,s0
ffffffffc0204de6:	6402                	ld	s0,0(sp)
ffffffffc0204de8:	0141                	addi	sp,sp,16
ffffffffc0204dea:	8082                	ret
        return -E_KILLED;
ffffffffc0204dec:	545d                	li	s0,-9
ffffffffc0204dee:	b7e1                	j	ffffffffc0204db6 <do_kill+0x42>

ffffffffc0204df0 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204df0:	1101                	addi	sp,sp,-32
ffffffffc0204df2:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204df4:	000c2797          	auipc	a5,0xc2
ffffffffc0204df8:	c9478793          	addi	a5,a5,-876 # ffffffffc02c6a88 <proc_list>
ffffffffc0204dfc:	ec06                	sd	ra,24(sp)
ffffffffc0204dfe:	e822                	sd	s0,16(sp)
ffffffffc0204e00:	e04a                	sd	s2,0(sp)
ffffffffc0204e02:	000be497          	auipc	s1,0xbe
ffffffffc0204e06:	c8648493          	addi	s1,s1,-890 # ffffffffc02c2a88 <hash_list>
ffffffffc0204e0a:	e79c                	sd	a5,8(a5)
ffffffffc0204e0c:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204e0e:	000c2717          	auipc	a4,0xc2
ffffffffc0204e12:	c7a70713          	addi	a4,a4,-902 # ffffffffc02c6a88 <proc_list>
ffffffffc0204e16:	87a6                	mv	a5,s1
ffffffffc0204e18:	e79c                	sd	a5,8(a5)
ffffffffc0204e1a:	e39c                	sd	a5,0(a5)
ffffffffc0204e1c:	07c1                	addi	a5,a5,16
ffffffffc0204e1e:	fef71de3          	bne	a4,a5,ffffffffc0204e18 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204e22:	f53fe0ef          	jal	ra,ffffffffc0203d74 <alloc_proc>
ffffffffc0204e26:	000c2917          	auipc	s2,0xc2
ffffffffc0204e2a:	d0a90913          	addi	s2,s2,-758 # ffffffffc02c6b30 <idleproc>
ffffffffc0204e2e:	00a93023          	sd	a0,0(s2)
ffffffffc0204e32:	0e050f63          	beqz	a0,ffffffffc0204f30 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204e36:	4789                	li	a5,2
ffffffffc0204e38:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e3a:	00004797          	auipc	a5,0x4
ffffffffc0204e3e:	1c678793          	addi	a5,a5,454 # ffffffffc0209000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e42:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e46:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0204e48:	4785                	li	a5,1
ffffffffc0204e4a:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e4c:	4641                	li	a2,16
ffffffffc0204e4e:	4581                	li	a1,0
ffffffffc0204e50:	8522                	mv	a0,s0
ffffffffc0204e52:	249000ef          	jal	ra,ffffffffc020589a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204e56:	463d                	li	a2,15
ffffffffc0204e58:	00002597          	auipc	a1,0x2
ffffffffc0204e5c:	67858593          	addi	a1,a1,1656 # ffffffffc02074d0 <default_pmm_manager+0xdc8>
ffffffffc0204e60:	8522                	mv	a0,s0
ffffffffc0204e62:	24b000ef          	jal	ra,ffffffffc02058ac <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204e66:	000c2717          	auipc	a4,0xc2
ffffffffc0204e6a:	cda70713          	addi	a4,a4,-806 # ffffffffc02c6b40 <nr_process>
ffffffffc0204e6e:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204e70:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204e74:	4601                	li	a2,0
    nr_process++;
ffffffffc0204e76:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204e78:	4581                	li	a1,0
ffffffffc0204e7a:	fffff517          	auipc	a0,0xfffff
ffffffffc0204e7e:	7de50513          	addi	a0,a0,2014 # ffffffffc0204658 <init_main>
    nr_process++;
ffffffffc0204e82:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204e84:	000c2797          	auipc	a5,0xc2
ffffffffc0204e88:	cad7b223          	sd	a3,-860(a5) # ffffffffc02c6b28 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204e8c:	c60ff0ef          	jal	ra,ffffffffc02042ec <kernel_thread>
ffffffffc0204e90:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204e92:	08a05363          	blez	a0,ffffffffc0204f18 <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204e96:	6789                	lui	a5,0x2
ffffffffc0204e98:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204e9c:	17f9                	addi	a5,a5,-2
ffffffffc0204e9e:	2501                	sext.w	a0,a0
ffffffffc0204ea0:	02e7e363          	bltu	a5,a4,ffffffffc0204ec6 <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204ea4:	45a9                	li	a1,10
ffffffffc0204ea6:	54e000ef          	jal	ra,ffffffffc02053f4 <hash32>
ffffffffc0204eaa:	02051793          	slli	a5,a0,0x20
ffffffffc0204eae:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204eb2:	96a6                	add	a3,a3,s1
ffffffffc0204eb4:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204eb6:	a029                	j	ffffffffc0204ec0 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0204eb8:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x8004>
ffffffffc0204ebc:	04870b63          	beq	a4,s0,ffffffffc0204f12 <proc_init+0x122>
    return listelm->next;
ffffffffc0204ec0:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204ec2:	fef69be3          	bne	a3,a5,ffffffffc0204eb8 <proc_init+0xc8>
    return NULL;
ffffffffc0204ec6:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204ec8:	0b478493          	addi	s1,a5,180
ffffffffc0204ecc:	4641                	li	a2,16
ffffffffc0204ece:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204ed0:	000c2417          	auipc	s0,0xc2
ffffffffc0204ed4:	c6840413          	addi	s0,s0,-920 # ffffffffc02c6b38 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204ed8:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204eda:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204edc:	1bf000ef          	jal	ra,ffffffffc020589a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204ee0:	463d                	li	a2,15
ffffffffc0204ee2:	00002597          	auipc	a1,0x2
ffffffffc0204ee6:	61658593          	addi	a1,a1,1558 # ffffffffc02074f8 <default_pmm_manager+0xdf0>
ffffffffc0204eea:	8526                	mv	a0,s1
ffffffffc0204eec:	1c1000ef          	jal	ra,ffffffffc02058ac <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204ef0:	00093783          	ld	a5,0(s2)
ffffffffc0204ef4:	cbb5                	beqz	a5,ffffffffc0204f68 <proc_init+0x178>
ffffffffc0204ef6:	43dc                	lw	a5,4(a5)
ffffffffc0204ef8:	eba5                	bnez	a5,ffffffffc0204f68 <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204efa:	601c                	ld	a5,0(s0)
ffffffffc0204efc:	c7b1                	beqz	a5,ffffffffc0204f48 <proc_init+0x158>
ffffffffc0204efe:	43d8                	lw	a4,4(a5)
ffffffffc0204f00:	4785                	li	a5,1
ffffffffc0204f02:	04f71363          	bne	a4,a5,ffffffffc0204f48 <proc_init+0x158>
}
ffffffffc0204f06:	60e2                	ld	ra,24(sp)
ffffffffc0204f08:	6442                	ld	s0,16(sp)
ffffffffc0204f0a:	64a2                	ld	s1,8(sp)
ffffffffc0204f0c:	6902                	ld	s2,0(sp)
ffffffffc0204f0e:	6105                	addi	sp,sp,32
ffffffffc0204f10:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204f12:	f2878793          	addi	a5,a5,-216
ffffffffc0204f16:	bf4d                	j	ffffffffc0204ec8 <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0204f18:	00002617          	auipc	a2,0x2
ffffffffc0204f1c:	5c060613          	addi	a2,a2,1472 # ffffffffc02074d8 <default_pmm_manager+0xdd0>
ffffffffc0204f20:	3af00593          	li	a1,943
ffffffffc0204f24:	00002517          	auipc	a0,0x2
ffffffffc0204f28:	21450513          	addi	a0,a0,532 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204f2c:	d66fb0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204f30:	00002617          	auipc	a2,0x2
ffffffffc0204f34:	58860613          	addi	a2,a2,1416 # ffffffffc02074b8 <default_pmm_manager+0xdb0>
ffffffffc0204f38:	3a000593          	li	a1,928
ffffffffc0204f3c:	00002517          	auipc	a0,0x2
ffffffffc0204f40:	1fc50513          	addi	a0,a0,508 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204f44:	d4efb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f48:	00002697          	auipc	a3,0x2
ffffffffc0204f4c:	5e068693          	addi	a3,a3,1504 # ffffffffc0207528 <default_pmm_manager+0xe20>
ffffffffc0204f50:	00001617          	auipc	a2,0x1
ffffffffc0204f54:	40860613          	addi	a2,a2,1032 # ffffffffc0206358 <commands+0x828>
ffffffffc0204f58:	3b600593          	li	a1,950
ffffffffc0204f5c:	00002517          	auipc	a0,0x2
ffffffffc0204f60:	1dc50513          	addi	a0,a0,476 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204f64:	d2efb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204f68:	00002697          	auipc	a3,0x2
ffffffffc0204f6c:	59868693          	addi	a3,a3,1432 # ffffffffc0207500 <default_pmm_manager+0xdf8>
ffffffffc0204f70:	00001617          	auipc	a2,0x1
ffffffffc0204f74:	3e860613          	addi	a2,a2,1000 # ffffffffc0206358 <commands+0x828>
ffffffffc0204f78:	3b500593          	li	a1,949
ffffffffc0204f7c:	00002517          	auipc	a0,0x2
ffffffffc0204f80:	1bc50513          	addi	a0,a0,444 # ffffffffc0207138 <default_pmm_manager+0xa30>
ffffffffc0204f84:	d0efb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204f88 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0204f88:	1141                	addi	sp,sp,-16
ffffffffc0204f8a:	e022                	sd	s0,0(sp)
ffffffffc0204f8c:	e406                	sd	ra,8(sp)
ffffffffc0204f8e:	000c2417          	auipc	s0,0xc2
ffffffffc0204f92:	b9a40413          	addi	s0,s0,-1126 # ffffffffc02c6b28 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0204f96:	6018                	ld	a4,0(s0)
ffffffffc0204f98:	6f1c                	ld	a5,24(a4)
ffffffffc0204f9a:	dffd                	beqz	a5,ffffffffc0204f98 <cpu_idle+0x10>
        {
            schedule();
ffffffffc0204f9c:	298000ef          	jal	ra,ffffffffc0205234 <schedule>
ffffffffc0204fa0:	bfdd                	j	ffffffffc0204f96 <cpu_idle+0xe>

ffffffffc0204fa2 <lab6_set_priority>:
        }
    }
}
// FOR LAB6, set the process's priority (bigger value will get more CPU time)
void lab6_set_priority(uint32_t priority)
{
ffffffffc0204fa2:	1141                	addi	sp,sp,-16
ffffffffc0204fa4:	e022                	sd	s0,0(sp)
    cprintf("set priority to %d\n", priority);
ffffffffc0204fa6:	85aa                	mv	a1,a0
{
ffffffffc0204fa8:	842a                	mv	s0,a0
    cprintf("set priority to %d\n", priority);
ffffffffc0204faa:	00002517          	auipc	a0,0x2
ffffffffc0204fae:	5a650513          	addi	a0,a0,1446 # ffffffffc0207550 <default_pmm_manager+0xe48>
{
ffffffffc0204fb2:	e406                	sd	ra,8(sp)
    cprintf("set priority to %d\n", priority);
ffffffffc0204fb4:	9e4fb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    if (priority == 0)
        current->lab6_priority = 1;
ffffffffc0204fb8:	000c2797          	auipc	a5,0xc2
ffffffffc0204fbc:	b707b783          	ld	a5,-1168(a5) # ffffffffc02c6b28 <current>
    if (priority == 0)
ffffffffc0204fc0:	e801                	bnez	s0,ffffffffc0204fd0 <lab6_set_priority+0x2e>
    else
        current->lab6_priority = priority;
}
ffffffffc0204fc2:	60a2                	ld	ra,8(sp)
ffffffffc0204fc4:	6402                	ld	s0,0(sp)
        current->lab6_priority = 1;
ffffffffc0204fc6:	4705                	li	a4,1
ffffffffc0204fc8:	14e7a223          	sw	a4,324(a5)
}
ffffffffc0204fcc:	0141                	addi	sp,sp,16
ffffffffc0204fce:	8082                	ret
ffffffffc0204fd0:	60a2                	ld	ra,8(sp)
        current->lab6_priority = priority;
ffffffffc0204fd2:	1487a223          	sw	s0,324(a5)
}
ffffffffc0204fd6:	6402                	ld	s0,0(sp)
ffffffffc0204fd8:	0141                	addi	sp,sp,16
ffffffffc0204fda:	8082                	ret

ffffffffc0204fdc <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0204fdc:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0204fe0:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0204fe4:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0204fe6:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0204fe8:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0204fec:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0204ff0:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0204ff4:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0204ff8:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0204ffc:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0205000:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0205004:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0205008:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc020500c:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205010:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0205014:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0205018:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc020501a:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc020501c:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205020:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0205024:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0205028:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc020502c:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205030:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0205034:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205038:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc020503c:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205040:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0205044:	8082                	ret

ffffffffc0205046 <RR_init>:
    elm->prev = elm->next = elm;
ffffffffc0205046:	e508                	sd	a0,8(a0)
ffffffffc0205048:	e108                	sd	a0,0(a0)
static void
RR_init(struct run_queue *rq)
{
    // LAB6: 2312773
    list_init(&(rq->run_list));
    rq->proc_num = 0;
ffffffffc020504a:	00052823          	sw	zero,16(a0)
    rq->lab6_run_pool = NULL;
ffffffffc020504e:	00053c23          	sd	zero,24(a0)
}
ffffffffc0205052:	8082                	ret

ffffffffc0205054 <RR_pick_next>:
    return list->next == list;
ffffffffc0205054:	651c                	ld	a5,8(a0)
 */
static struct proc_struct *
RR_pick_next(struct run_queue *rq)
{
    // LAB6: 2312773
    if (list_empty(&(rq->run_list)))
ffffffffc0205056:	00f50563          	beq	a0,a5,ffffffffc0205060 <RR_pick_next+0xc>
    {
        return NULL;
    }
    list_entry_t *le = list_next(&(rq->run_list));
    return le2proc(le, run_link);
ffffffffc020505a:	ef078513          	addi	a0,a5,-272
ffffffffc020505e:	8082                	ret
        return NULL;
ffffffffc0205060:	4501                	li	a0,0
}
ffffffffc0205062:	8082                	ret

ffffffffc0205064 <RR_proc_tick>:
 */
static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    // LAB6: 2312773
    if (proc->time_slice > 0)
ffffffffc0205064:	1205a783          	lw	a5,288(a1)
ffffffffc0205068:	00f05863          	blez	a5,ffffffffc0205078 <RR_proc_tick+0x14>
    {
        proc->time_slice--;
ffffffffc020506c:	fff7871b          	addiw	a4,a5,-1
ffffffffc0205070:	12e5a023          	sw	a4,288(a1)
    }
    if (proc->time_slice <= 0)
ffffffffc0205074:	c311                	beqz	a4,ffffffffc0205078 <RR_proc_tick+0x14>
    {
        proc->need_resched = 1;
    }
}
ffffffffc0205076:	8082                	ret
        proc->need_resched = 1;
ffffffffc0205078:	4785                	li	a5,1
ffffffffc020507a:	ed9c                	sd	a5,24(a1)
ffffffffc020507c:	8082                	ret

ffffffffc020507e <RR_dequeue>:
    if (proc->rq == rq)
ffffffffc020507e:	1085b783          	ld	a5,264(a1)
ffffffffc0205082:	00a78363          	beq	a5,a0,ffffffffc0205088 <RR_dequeue+0xa>
}
ffffffffc0205086:	8082                	ret
    __list_del(listelm->prev, listelm->next);
ffffffffc0205088:	1105b503          	ld	a0,272(a1)
ffffffffc020508c:	1185b603          	ld	a2,280(a1)
        if (rq->proc_num > 0)
ffffffffc0205090:	4b98                	lw	a4,16(a5)
        list_del_init(&(proc->run_link));
ffffffffc0205092:	11058693          	addi	a3,a1,272
    prev->next = next;
ffffffffc0205096:	e510                	sd	a2,8(a0)
    next->prev = prev;
ffffffffc0205098:	e208                	sd	a0,0(a2)
    elm->prev = elm->next = elm;
ffffffffc020509a:	10d5bc23          	sd	a3,280(a1)
ffffffffc020509e:	10d5b823          	sd	a3,272(a1)
        proc->rq = NULL;
ffffffffc02050a2:	1005b423          	sd	zero,264(a1)
        if (rq->proc_num > 0)
ffffffffc02050a6:	d365                	beqz	a4,ffffffffc0205086 <RR_dequeue+0x8>
            rq->proc_num--;
ffffffffc02050a8:	377d                	addiw	a4,a4,-1
ffffffffc02050aa:	cb98                	sw	a4,16(a5)
}
ffffffffc02050ac:	8082                	ret

ffffffffc02050ae <RR_enqueue>:
    assert(proc->rq == NULL);
ffffffffc02050ae:	1085b783          	ld	a5,264(a1)
ffffffffc02050b2:	eb8d                	bnez	a5,ffffffffc02050e4 <RR_enqueue+0x36>
    if (proc->time_slice <= 0 || proc->time_slice > rq->max_time_slice)
ffffffffc02050b4:	1205a783          	lw	a5,288(a1)
ffffffffc02050b8:	4958                	lw	a4,20(a0)
ffffffffc02050ba:	00f05463          	blez	a5,ffffffffc02050c2 <RR_enqueue+0x14>
ffffffffc02050be:	00f75463          	bge	a4,a5,ffffffffc02050c6 <RR_enqueue+0x18>
        proc->time_slice = rq->max_time_slice;
ffffffffc02050c2:	12e5a023          	sw	a4,288(a1)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02050c6:	6118                	ld	a4,0(a0)
    rq->proc_num++;
ffffffffc02050c8:	491c                	lw	a5,16(a0)
    list_add_before(&(rq->run_list), &(proc->run_link));
ffffffffc02050ca:	11058693          	addi	a3,a1,272
    prev->next = next->prev = elm;
ffffffffc02050ce:	e114                	sd	a3,0(a0)
ffffffffc02050d0:	e714                	sd	a3,8(a4)
    elm->next = next;
ffffffffc02050d2:	10a5bc23          	sd	a0,280(a1)
    elm->prev = prev;
ffffffffc02050d6:	10e5b823          	sd	a4,272(a1)
    proc->rq = rq;
ffffffffc02050da:	10a5b423          	sd	a0,264(a1)
    rq->proc_num++;
ffffffffc02050de:	2785                	addiw	a5,a5,1
ffffffffc02050e0:	c91c                	sw	a5,16(a0)
ffffffffc02050e2:	8082                	ret
{
ffffffffc02050e4:	1141                	addi	sp,sp,-16
    assert(proc->rq == NULL);
ffffffffc02050e6:	00002697          	auipc	a3,0x2
ffffffffc02050ea:	48268693          	addi	a3,a3,1154 # ffffffffc0207568 <default_pmm_manager+0xe60>
ffffffffc02050ee:	00001617          	auipc	a2,0x1
ffffffffc02050f2:	26a60613          	addi	a2,a2,618 # ffffffffc0206358 <commands+0x828>
ffffffffc02050f6:	02900593          	li	a1,41
ffffffffc02050fa:	00002517          	auipc	a0,0x2
ffffffffc02050fe:	48650513          	addi	a0,a0,1158 # ffffffffc0207580 <default_pmm_manager+0xe78>
{
ffffffffc0205102:	e406                	sd	ra,8(sp)
    assert(proc->rq == NULL);
ffffffffc0205104:	b8efb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0205108 <sched_class_proc_tick>:
    return sched_class->pick_next(rq);
}

void sched_class_proc_tick(struct proc_struct *proc)
{
    if (proc != idleproc)
ffffffffc0205108:	000c2797          	auipc	a5,0xc2
ffffffffc020510c:	a287b783          	ld	a5,-1496(a5) # ffffffffc02c6b30 <idleproc>
{
ffffffffc0205110:	85aa                	mv	a1,a0
    if (proc != idleproc)
ffffffffc0205112:	00a78c63          	beq	a5,a0,ffffffffc020512a <sched_class_proc_tick+0x22>
    {
        sched_class->proc_tick(rq, proc);
ffffffffc0205116:	000c2797          	auipc	a5,0xc2
ffffffffc020511a:	a3a7b783          	ld	a5,-1478(a5) # ffffffffc02c6b50 <sched_class>
ffffffffc020511e:	779c                	ld	a5,40(a5)
ffffffffc0205120:	000c2517          	auipc	a0,0xc2
ffffffffc0205124:	a2853503          	ld	a0,-1496(a0) # ffffffffc02c6b48 <rq>
ffffffffc0205128:	8782                	jr	a5
    }
    else
    {
        proc->need_resched = 1;
ffffffffc020512a:	4705                	li	a4,1
ffffffffc020512c:	ef98                	sd	a4,24(a5)
    }
}
ffffffffc020512e:	8082                	ret

ffffffffc0205130 <sched_init>:

static struct run_queue __rq;

void sched_init(void)
{
ffffffffc0205130:	1141                	addi	sp,sp,-16
    list_init(&timer_list);

    sched_class = &default_sched_class;
ffffffffc0205132:	000bd717          	auipc	a4,0xbd
ffffffffc0205136:	4fe70713          	addi	a4,a4,1278 # ffffffffc02c2630 <default_sched_class>
{
ffffffffc020513a:	e022                	sd	s0,0(sp)
ffffffffc020513c:	e406                	sd	ra,8(sp)
    elm->prev = elm->next = elm;
ffffffffc020513e:	000c2797          	auipc	a5,0xc2
ffffffffc0205142:	97a78793          	addi	a5,a5,-1670 # ffffffffc02c6ab8 <timer_list>

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    sched_class->init(rq);
ffffffffc0205146:	6714                	ld	a3,8(a4)
    rq = &__rq;
ffffffffc0205148:	000c2517          	auipc	a0,0xc2
ffffffffc020514c:	95050513          	addi	a0,a0,-1712 # ffffffffc02c6a98 <__rq>
ffffffffc0205150:	e79c                	sd	a5,8(a5)
ffffffffc0205152:	e39c                	sd	a5,0(a5)
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc0205154:	4795                	li	a5,5
ffffffffc0205156:	c95c                	sw	a5,20(a0)
    sched_class = &default_sched_class;
ffffffffc0205158:	000c2417          	auipc	s0,0xc2
ffffffffc020515c:	9f840413          	addi	s0,s0,-1544 # ffffffffc02c6b50 <sched_class>
    rq = &__rq;
ffffffffc0205160:	000c2797          	auipc	a5,0xc2
ffffffffc0205164:	9ea7b423          	sd	a0,-1560(a5) # ffffffffc02c6b48 <rq>
    sched_class = &default_sched_class;
ffffffffc0205168:	e018                	sd	a4,0(s0)
    sched_class->init(rq);
ffffffffc020516a:	9682                	jalr	a3

    cprintf("sched class: %s\n", sched_class->name);
ffffffffc020516c:	601c                	ld	a5,0(s0)
}
ffffffffc020516e:	6402                	ld	s0,0(sp)
ffffffffc0205170:	60a2                	ld	ra,8(sp)
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205172:	638c                	ld	a1,0(a5)
ffffffffc0205174:	00002517          	auipc	a0,0x2
ffffffffc0205178:	43c50513          	addi	a0,a0,1084 # ffffffffc02075b0 <default_pmm_manager+0xea8>
}
ffffffffc020517c:	0141                	addi	sp,sp,16
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc020517e:	81afb06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0205182 <wakeup_proc>:

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205182:	4118                	lw	a4,0(a0)
{
ffffffffc0205184:	1101                	addi	sp,sp,-32
ffffffffc0205186:	ec06                	sd	ra,24(sp)
ffffffffc0205188:	e822                	sd	s0,16(sp)
ffffffffc020518a:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020518c:	478d                	li	a5,3
ffffffffc020518e:	08f70363          	beq	a4,a5,ffffffffc0205214 <wakeup_proc+0x92>
ffffffffc0205192:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205194:	100027f3          	csrr	a5,sstatus
ffffffffc0205198:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020519a:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020519c:	e7bd                	bnez	a5,ffffffffc020520a <wakeup_proc+0x88>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc020519e:	4789                	li	a5,2
ffffffffc02051a0:	04f70863          	beq	a4,a5,ffffffffc02051f0 <wakeup_proc+0x6e>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc02051a4:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc02051a6:	0e042623          	sw	zero,236(s0)
            if (proc != current)
ffffffffc02051aa:	000c2797          	auipc	a5,0xc2
ffffffffc02051ae:	97e7b783          	ld	a5,-1666(a5) # ffffffffc02c6b28 <current>
ffffffffc02051b2:	02878363          	beq	a5,s0,ffffffffc02051d8 <wakeup_proc+0x56>
    if (proc != idleproc)
ffffffffc02051b6:	000c2797          	auipc	a5,0xc2
ffffffffc02051ba:	97a7b783          	ld	a5,-1670(a5) # ffffffffc02c6b30 <idleproc>
ffffffffc02051be:	00f40d63          	beq	s0,a5,ffffffffc02051d8 <wakeup_proc+0x56>
        sched_class->enqueue(rq, proc);
ffffffffc02051c2:	000c2797          	auipc	a5,0xc2
ffffffffc02051c6:	98e7b783          	ld	a5,-1650(a5) # ffffffffc02c6b50 <sched_class>
ffffffffc02051ca:	6b9c                	ld	a5,16(a5)
ffffffffc02051cc:	85a2                	mv	a1,s0
ffffffffc02051ce:	000c2517          	auipc	a0,0xc2
ffffffffc02051d2:	97a53503          	ld	a0,-1670(a0) # ffffffffc02c6b48 <rq>
ffffffffc02051d6:	9782                	jalr	a5
    if (flag)
ffffffffc02051d8:	e491                	bnez	s1,ffffffffc02051e4 <wakeup_proc+0x62>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02051da:	60e2                	ld	ra,24(sp)
ffffffffc02051dc:	6442                	ld	s0,16(sp)
ffffffffc02051de:	64a2                	ld	s1,8(sp)
ffffffffc02051e0:	6105                	addi	sp,sp,32
ffffffffc02051e2:	8082                	ret
ffffffffc02051e4:	6442                	ld	s0,16(sp)
ffffffffc02051e6:	60e2                	ld	ra,24(sp)
ffffffffc02051e8:	64a2                	ld	s1,8(sp)
ffffffffc02051ea:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02051ec:	fbcfb06f          	j	ffffffffc02009a8 <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc02051f0:	00002617          	auipc	a2,0x2
ffffffffc02051f4:	41060613          	addi	a2,a2,1040 # ffffffffc0207600 <default_pmm_manager+0xef8>
ffffffffc02051f8:	05100593          	li	a1,81
ffffffffc02051fc:	00002517          	auipc	a0,0x2
ffffffffc0205200:	3ec50513          	addi	a0,a0,1004 # ffffffffc02075e8 <default_pmm_manager+0xee0>
ffffffffc0205204:	af6fb0ef          	jal	ra,ffffffffc02004fa <__warn>
ffffffffc0205208:	bfc1                	j	ffffffffc02051d8 <wakeup_proc+0x56>
        intr_disable();
ffffffffc020520a:	fa4fb0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc020520e:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc0205210:	4485                	li	s1,1
ffffffffc0205212:	b771                	j	ffffffffc020519e <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205214:	00002697          	auipc	a3,0x2
ffffffffc0205218:	3b468693          	addi	a3,a3,948 # ffffffffc02075c8 <default_pmm_manager+0xec0>
ffffffffc020521c:	00001617          	auipc	a2,0x1
ffffffffc0205220:	13c60613          	addi	a2,a2,316 # ffffffffc0206358 <commands+0x828>
ffffffffc0205224:	04200593          	li	a1,66
ffffffffc0205228:	00002517          	auipc	a0,0x2
ffffffffc020522c:	3c050513          	addi	a0,a0,960 # ffffffffc02075e8 <default_pmm_manager+0xee0>
ffffffffc0205230:	a62fb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0205234 <schedule>:

void schedule(void)
{
ffffffffc0205234:	7179                	addi	sp,sp,-48
ffffffffc0205236:	f406                	sd	ra,40(sp)
ffffffffc0205238:	f022                	sd	s0,32(sp)
ffffffffc020523a:	ec26                	sd	s1,24(sp)
ffffffffc020523c:	e84a                	sd	s2,16(sp)
ffffffffc020523e:	e44e                	sd	s3,8(sp)
ffffffffc0205240:	e052                	sd	s4,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205242:	100027f3          	csrr	a5,sstatus
ffffffffc0205246:	8b89                	andi	a5,a5,2
ffffffffc0205248:	4a01                	li	s4,0
ffffffffc020524a:	e3cd                	bnez	a5,ffffffffc02052ec <schedule+0xb8>
    bool intr_flag;
    struct proc_struct *next;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc020524c:	000c2497          	auipc	s1,0xc2
ffffffffc0205250:	8dc48493          	addi	s1,s1,-1828 # ffffffffc02c6b28 <current>
ffffffffc0205254:	608c                	ld	a1,0(s1)
        sched_class->enqueue(rq, proc);
ffffffffc0205256:	000c2997          	auipc	s3,0xc2
ffffffffc020525a:	8fa98993          	addi	s3,s3,-1798 # ffffffffc02c6b50 <sched_class>
ffffffffc020525e:	000c2917          	auipc	s2,0xc2
ffffffffc0205262:	8ea90913          	addi	s2,s2,-1814 # ffffffffc02c6b48 <rq>
        if (current->state == PROC_RUNNABLE)
ffffffffc0205266:	4194                	lw	a3,0(a1)
        current->need_resched = 0;
ffffffffc0205268:	0005bc23          	sd	zero,24(a1)
        if (current->state == PROC_RUNNABLE)
ffffffffc020526c:	4709                	li	a4,2
        sched_class->enqueue(rq, proc);
ffffffffc020526e:	0009b783          	ld	a5,0(s3)
ffffffffc0205272:	00093503          	ld	a0,0(s2)
        if (current->state == PROC_RUNNABLE)
ffffffffc0205276:	04e68e63          	beq	a3,a4,ffffffffc02052d2 <schedule+0x9e>
    return sched_class->pick_next(rq);
ffffffffc020527a:	739c                	ld	a5,32(a5)
ffffffffc020527c:	9782                	jalr	a5
ffffffffc020527e:	842a                	mv	s0,a0
        {
            sched_class_enqueue(current);
        }
        if ((next = sched_class_pick_next()) != NULL)
ffffffffc0205280:	c521                	beqz	a0,ffffffffc02052c8 <schedule+0x94>
    sched_class->dequeue(rq, proc);
ffffffffc0205282:	0009b783          	ld	a5,0(s3)
ffffffffc0205286:	00093503          	ld	a0,0(s2)
ffffffffc020528a:	85a2                	mv	a1,s0
ffffffffc020528c:	6f9c                	ld	a5,24(a5)
ffffffffc020528e:	9782                	jalr	a5
        }
        if (next == NULL)
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc0205290:	441c                	lw	a5,8(s0)
        if (next != current)
ffffffffc0205292:	6098                	ld	a4,0(s1)
        next->runs++;
ffffffffc0205294:	2785                	addiw	a5,a5,1
ffffffffc0205296:	c41c                	sw	a5,8(s0)
        if (next != current)
ffffffffc0205298:	00870563          	beq	a4,s0,ffffffffc02052a2 <schedule+0x6e>
        {
            proc_run(next);
ffffffffc020529c:	8522                	mv	a0,s0
ffffffffc020529e:	c05fe0ef          	jal	ra,ffffffffc0203ea2 <proc_run>
    if (flag)
ffffffffc02052a2:	000a1a63          	bnez	s4,ffffffffc02052b6 <schedule+0x82>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02052a6:	70a2                	ld	ra,40(sp)
ffffffffc02052a8:	7402                	ld	s0,32(sp)
ffffffffc02052aa:	64e2                	ld	s1,24(sp)
ffffffffc02052ac:	6942                	ld	s2,16(sp)
ffffffffc02052ae:	69a2                	ld	s3,8(sp)
ffffffffc02052b0:	6a02                	ld	s4,0(sp)
ffffffffc02052b2:	6145                	addi	sp,sp,48
ffffffffc02052b4:	8082                	ret
ffffffffc02052b6:	7402                	ld	s0,32(sp)
ffffffffc02052b8:	70a2                	ld	ra,40(sp)
ffffffffc02052ba:	64e2                	ld	s1,24(sp)
ffffffffc02052bc:	6942                	ld	s2,16(sp)
ffffffffc02052be:	69a2                	ld	s3,8(sp)
ffffffffc02052c0:	6a02                	ld	s4,0(sp)
ffffffffc02052c2:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02052c4:	ee4fb06f          	j	ffffffffc02009a8 <intr_enable>
            next = idleproc;
ffffffffc02052c8:	000c2417          	auipc	s0,0xc2
ffffffffc02052cc:	86843403          	ld	s0,-1944(s0) # ffffffffc02c6b30 <idleproc>
ffffffffc02052d0:	b7c1                	j	ffffffffc0205290 <schedule+0x5c>
    if (proc != idleproc)
ffffffffc02052d2:	000c2717          	auipc	a4,0xc2
ffffffffc02052d6:	85e73703          	ld	a4,-1954(a4) # ffffffffc02c6b30 <idleproc>
ffffffffc02052da:	fae580e3          	beq	a1,a4,ffffffffc020527a <schedule+0x46>
        sched_class->enqueue(rq, proc);
ffffffffc02052de:	6b9c                	ld	a5,16(a5)
ffffffffc02052e0:	9782                	jalr	a5
    return sched_class->pick_next(rq);
ffffffffc02052e2:	0009b783          	ld	a5,0(s3)
ffffffffc02052e6:	00093503          	ld	a0,0(s2)
ffffffffc02052ea:	bf41                	j	ffffffffc020527a <schedule+0x46>
        intr_disable();
ffffffffc02052ec:	ec2fb0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc02052f0:	4a05                	li	s4,1
ffffffffc02052f2:	bfa9                	j	ffffffffc020524c <schedule+0x18>

ffffffffc02052f4 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc02052f4:	000c2797          	auipc	a5,0xc2
ffffffffc02052f8:	8347b783          	ld	a5,-1996(a5) # ffffffffc02c6b28 <current>
}
ffffffffc02052fc:	43c8                	lw	a0,4(a5)
ffffffffc02052fe:	8082                	ret

ffffffffc0205300 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205300:	4501                	li	a0,0
ffffffffc0205302:	8082                	ret

ffffffffc0205304 <sys_gettime>:
static int sys_gettime(uint64_t arg[]){
    return (int)ticks*10;
ffffffffc0205304:	000c1797          	auipc	a5,0xc1
ffffffffc0205308:	7cc7b783          	ld	a5,1996(a5) # ffffffffc02c6ad0 <ticks>
ffffffffc020530c:	0027951b          	slliw	a0,a5,0x2
ffffffffc0205310:	9d3d                	addw	a0,a0,a5
}
ffffffffc0205312:	0015151b          	slliw	a0,a0,0x1
ffffffffc0205316:	8082                	ret

ffffffffc0205318 <sys_lab6_set_priority>:
static int sys_lab6_set_priority(uint64_t arg[]){
    uint64_t priority = (uint64_t)arg[0];
    lab6_set_priority(priority);
ffffffffc0205318:	4108                	lw	a0,0(a0)
static int sys_lab6_set_priority(uint64_t arg[]){
ffffffffc020531a:	1141                	addi	sp,sp,-16
ffffffffc020531c:	e406                	sd	ra,8(sp)
    lab6_set_priority(priority);
ffffffffc020531e:	c85ff0ef          	jal	ra,ffffffffc0204fa2 <lab6_set_priority>
    return 0;
}
ffffffffc0205322:	60a2                	ld	ra,8(sp)
ffffffffc0205324:	4501                	li	a0,0
ffffffffc0205326:	0141                	addi	sp,sp,16
ffffffffc0205328:	8082                	ret

ffffffffc020532a <sys_putc>:
    cputchar(c);
ffffffffc020532a:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc020532c:	1141                	addi	sp,sp,-16
ffffffffc020532e:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205330:	e9ffa0ef          	jal	ra,ffffffffc02001ce <cputchar>
}
ffffffffc0205334:	60a2                	ld	ra,8(sp)
ffffffffc0205336:	4501                	li	a0,0
ffffffffc0205338:	0141                	addi	sp,sp,16
ffffffffc020533a:	8082                	ret

ffffffffc020533c <sys_kill>:
    return do_kill(pid);
ffffffffc020533c:	4108                	lw	a0,0(a0)
ffffffffc020533e:	a37ff06f          	j	ffffffffc0204d74 <do_kill>

ffffffffc0205342 <sys_yield>:
    return do_yield();
ffffffffc0205342:	9e5ff06f          	j	ffffffffc0204d26 <do_yield>

ffffffffc0205346 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205346:	6d14                	ld	a3,24(a0)
ffffffffc0205348:	6910                	ld	a2,16(a0)
ffffffffc020534a:	650c                	ld	a1,8(a0)
ffffffffc020534c:	6108                	ld	a0,0(a0)
ffffffffc020534e:	c2eff06f          	j	ffffffffc020477c <do_execve>

ffffffffc0205352 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205352:	650c                	ld	a1,8(a0)
ffffffffc0205354:	4108                	lw	a0,0(a0)
ffffffffc0205356:	9e1ff06f          	j	ffffffffc0204d36 <do_wait>

ffffffffc020535a <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc020535a:	000c1797          	auipc	a5,0xc1
ffffffffc020535e:	7ce7b783          	ld	a5,1998(a5) # ffffffffc02c6b28 <current>
ffffffffc0205362:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc0205364:	4501                	li	a0,0
ffffffffc0205366:	6a0c                	ld	a1,16(a2)
ffffffffc0205368:	ba7fe06f          	j	ffffffffc0203f0e <do_fork>

ffffffffc020536c <sys_exit>:
    return do_exit(error_code);
ffffffffc020536c:	4108                	lw	a0,0(a0)
ffffffffc020536e:	fcffe06f          	j	ffffffffc020433c <do_exit>

ffffffffc0205372 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc0205372:	715d                	addi	sp,sp,-80
ffffffffc0205374:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205376:	000c1497          	auipc	s1,0xc1
ffffffffc020537a:	7b248493          	addi	s1,s1,1970 # ffffffffc02c6b28 <current>
ffffffffc020537e:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0205380:	e0a2                	sd	s0,64(sp)
ffffffffc0205382:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205384:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc0205386:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205388:	0ff00793          	li	a5,255
    int num = tf->gpr.a0;
ffffffffc020538c:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205390:	0327ee63          	bltu	a5,s2,ffffffffc02053cc <syscall+0x5a>
        if (syscalls[num] != NULL) {
ffffffffc0205394:	00391713          	slli	a4,s2,0x3
ffffffffc0205398:	00002797          	auipc	a5,0x2
ffffffffc020539c:	2d078793          	addi	a5,a5,720 # ffffffffc0207668 <syscalls>
ffffffffc02053a0:	97ba                	add	a5,a5,a4
ffffffffc02053a2:	639c                	ld	a5,0(a5)
ffffffffc02053a4:	c785                	beqz	a5,ffffffffc02053cc <syscall+0x5a>
            arg[0] = tf->gpr.a1;
ffffffffc02053a6:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02053a8:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02053aa:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02053ac:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02053ae:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02053b0:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02053b2:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02053b4:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02053b6:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02053b8:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02053ba:	0028                	addi	a0,sp,8
ffffffffc02053bc:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02053be:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02053c0:	e828                	sd	a0,80(s0)
}
ffffffffc02053c2:	6406                	ld	s0,64(sp)
ffffffffc02053c4:	74e2                	ld	s1,56(sp)
ffffffffc02053c6:	7942                	ld	s2,48(sp)
ffffffffc02053c8:	6161                	addi	sp,sp,80
ffffffffc02053ca:	8082                	ret
    print_trapframe(tf);
ffffffffc02053cc:	8522                	mv	a0,s0
ffffffffc02053ce:	fd0fb0ef          	jal	ra,ffffffffc0200b9e <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc02053d2:	609c                	ld	a5,0(s1)
ffffffffc02053d4:	86ca                	mv	a3,s2
ffffffffc02053d6:	00002617          	auipc	a2,0x2
ffffffffc02053da:	24a60613          	addi	a2,a2,586 # ffffffffc0207620 <default_pmm_manager+0xf18>
ffffffffc02053de:	43d8                	lw	a4,4(a5)
ffffffffc02053e0:	06c00593          	li	a1,108
ffffffffc02053e4:	0b478793          	addi	a5,a5,180
ffffffffc02053e8:	00002517          	auipc	a0,0x2
ffffffffc02053ec:	26850513          	addi	a0,a0,616 # ffffffffc0207650 <default_pmm_manager+0xf48>
ffffffffc02053f0:	8a2fb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02053f4 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc02053f4:	9e3707b7          	lui	a5,0x9e370
ffffffffc02053f8:	2785                	addiw	a5,a5,1
ffffffffc02053fa:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc02053fe:	02000793          	li	a5,32
ffffffffc0205402:	9f8d                	subw	a5,a5,a1
}
ffffffffc0205404:	00f5553b          	srlw	a0,a0,a5
ffffffffc0205408:	8082                	ret

ffffffffc020540a <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020540a:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020540e:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0205410:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205414:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205416:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020541a:	f022                	sd	s0,32(sp)
ffffffffc020541c:	ec26                	sd	s1,24(sp)
ffffffffc020541e:	e84a                	sd	s2,16(sp)
ffffffffc0205420:	f406                	sd	ra,40(sp)
ffffffffc0205422:	e44e                	sd	s3,8(sp)
ffffffffc0205424:	84aa                	mv	s1,a0
ffffffffc0205426:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205428:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc020542c:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc020542e:	03067e63          	bgeu	a2,a6,ffffffffc020546a <printnum+0x60>
ffffffffc0205432:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0205434:	00805763          	blez	s0,ffffffffc0205442 <printnum+0x38>
ffffffffc0205438:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc020543a:	85ca                	mv	a1,s2
ffffffffc020543c:	854e                	mv	a0,s3
ffffffffc020543e:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205440:	fc65                	bnez	s0,ffffffffc0205438 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205442:	1a02                	slli	s4,s4,0x20
ffffffffc0205444:	00003797          	auipc	a5,0x3
ffffffffc0205448:	a2478793          	addi	a5,a5,-1500 # ffffffffc0207e68 <syscalls+0x800>
ffffffffc020544c:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205450:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205452:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205454:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0205458:	70a2                	ld	ra,40(sp)
ffffffffc020545a:	69a2                	ld	s3,8(sp)
ffffffffc020545c:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020545e:	85ca                	mv	a1,s2
ffffffffc0205460:	87a6                	mv	a5,s1
}
ffffffffc0205462:	6942                	ld	s2,16(sp)
ffffffffc0205464:	64e2                	ld	s1,24(sp)
ffffffffc0205466:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205468:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc020546a:	03065633          	divu	a2,a2,a6
ffffffffc020546e:	8722                	mv	a4,s0
ffffffffc0205470:	f9bff0ef          	jal	ra,ffffffffc020540a <printnum>
ffffffffc0205474:	b7f9                	j	ffffffffc0205442 <printnum+0x38>

ffffffffc0205476 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0205476:	7119                	addi	sp,sp,-128
ffffffffc0205478:	f4a6                	sd	s1,104(sp)
ffffffffc020547a:	f0ca                	sd	s2,96(sp)
ffffffffc020547c:	ecce                	sd	s3,88(sp)
ffffffffc020547e:	e8d2                	sd	s4,80(sp)
ffffffffc0205480:	e4d6                	sd	s5,72(sp)
ffffffffc0205482:	e0da                	sd	s6,64(sp)
ffffffffc0205484:	fc5e                	sd	s7,56(sp)
ffffffffc0205486:	f06a                	sd	s10,32(sp)
ffffffffc0205488:	fc86                	sd	ra,120(sp)
ffffffffc020548a:	f8a2                	sd	s0,112(sp)
ffffffffc020548c:	f862                	sd	s8,48(sp)
ffffffffc020548e:	f466                	sd	s9,40(sp)
ffffffffc0205490:	ec6e                	sd	s11,24(sp)
ffffffffc0205492:	892a                	mv	s2,a0
ffffffffc0205494:	84ae                	mv	s1,a1
ffffffffc0205496:	8d32                	mv	s10,a2
ffffffffc0205498:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020549a:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc020549e:	5b7d                	li	s6,-1
ffffffffc02054a0:	00003a97          	auipc	s5,0x3
ffffffffc02054a4:	9f4a8a93          	addi	s5,s5,-1548 # ffffffffc0207e94 <syscalls+0x82c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02054a8:	00003b97          	auipc	s7,0x3
ffffffffc02054ac:	c08b8b93          	addi	s7,s7,-1016 # ffffffffc02080b0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054b0:	000d4503          	lbu	a0,0(s10)
ffffffffc02054b4:	001d0413          	addi	s0,s10,1
ffffffffc02054b8:	01350a63          	beq	a0,s3,ffffffffc02054cc <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02054bc:	c121                	beqz	a0,ffffffffc02054fc <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02054be:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054c0:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02054c2:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054c4:	fff44503          	lbu	a0,-1(s0)
ffffffffc02054c8:	ff351ae3          	bne	a0,s3,ffffffffc02054bc <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054cc:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02054d0:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02054d4:	4c81                	li	s9,0
ffffffffc02054d6:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02054d8:	5c7d                	li	s8,-1
ffffffffc02054da:	5dfd                	li	s11,-1
ffffffffc02054dc:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc02054e0:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054e2:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02054e6:	0ff5f593          	zext.b	a1,a1
ffffffffc02054ea:	00140d13          	addi	s10,s0,1
ffffffffc02054ee:	04b56263          	bltu	a0,a1,ffffffffc0205532 <vprintfmt+0xbc>
ffffffffc02054f2:	058a                	slli	a1,a1,0x2
ffffffffc02054f4:	95d6                	add	a1,a1,s5
ffffffffc02054f6:	4194                	lw	a3,0(a1)
ffffffffc02054f8:	96d6                	add	a3,a3,s5
ffffffffc02054fa:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02054fc:	70e6                	ld	ra,120(sp)
ffffffffc02054fe:	7446                	ld	s0,112(sp)
ffffffffc0205500:	74a6                	ld	s1,104(sp)
ffffffffc0205502:	7906                	ld	s2,96(sp)
ffffffffc0205504:	69e6                	ld	s3,88(sp)
ffffffffc0205506:	6a46                	ld	s4,80(sp)
ffffffffc0205508:	6aa6                	ld	s5,72(sp)
ffffffffc020550a:	6b06                	ld	s6,64(sp)
ffffffffc020550c:	7be2                	ld	s7,56(sp)
ffffffffc020550e:	7c42                	ld	s8,48(sp)
ffffffffc0205510:	7ca2                	ld	s9,40(sp)
ffffffffc0205512:	7d02                	ld	s10,32(sp)
ffffffffc0205514:	6de2                	ld	s11,24(sp)
ffffffffc0205516:	6109                	addi	sp,sp,128
ffffffffc0205518:	8082                	ret
            padc = '0';
ffffffffc020551a:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc020551c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205520:	846a                	mv	s0,s10
ffffffffc0205522:	00140d13          	addi	s10,s0,1
ffffffffc0205526:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020552a:	0ff5f593          	zext.b	a1,a1
ffffffffc020552e:	fcb572e3          	bgeu	a0,a1,ffffffffc02054f2 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0205532:	85a6                	mv	a1,s1
ffffffffc0205534:	02500513          	li	a0,37
ffffffffc0205538:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020553a:	fff44783          	lbu	a5,-1(s0)
ffffffffc020553e:	8d22                	mv	s10,s0
ffffffffc0205540:	f73788e3          	beq	a5,s3,ffffffffc02054b0 <vprintfmt+0x3a>
ffffffffc0205544:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0205548:	1d7d                	addi	s10,s10,-1
ffffffffc020554a:	ff379de3          	bne	a5,s3,ffffffffc0205544 <vprintfmt+0xce>
ffffffffc020554e:	b78d                	j	ffffffffc02054b0 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0205550:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0205554:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205558:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc020555a:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc020555e:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205562:	02d86463          	bltu	a6,a3,ffffffffc020558a <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0205566:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc020556a:	002c169b          	slliw	a3,s8,0x2
ffffffffc020556e:	0186873b          	addw	a4,a3,s8
ffffffffc0205572:	0017171b          	slliw	a4,a4,0x1
ffffffffc0205576:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0205578:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc020557c:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc020557e:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0205582:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205586:	fed870e3          	bgeu	a6,a3,ffffffffc0205566 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc020558a:	f40ddce3          	bgez	s11,ffffffffc02054e2 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc020558e:	8de2                	mv	s11,s8
ffffffffc0205590:	5c7d                	li	s8,-1
ffffffffc0205592:	bf81                	j	ffffffffc02054e2 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0205594:	fffdc693          	not	a3,s11
ffffffffc0205598:	96fd                	srai	a3,a3,0x3f
ffffffffc020559a:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020559e:	00144603          	lbu	a2,1(s0)
ffffffffc02055a2:	2d81                	sext.w	s11,s11
ffffffffc02055a4:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02055a6:	bf35                	j	ffffffffc02054e2 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02055a8:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055ac:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02055b0:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055b2:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02055b4:	bfd9                	j	ffffffffc020558a <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02055b6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02055b8:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02055bc:	01174463          	blt	a4,a7,ffffffffc02055c4 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02055c0:	1a088e63          	beqz	a7,ffffffffc020577c <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02055c4:	000a3603          	ld	a2,0(s4)
ffffffffc02055c8:	46c1                	li	a3,16
ffffffffc02055ca:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02055cc:	2781                	sext.w	a5,a5
ffffffffc02055ce:	876e                	mv	a4,s11
ffffffffc02055d0:	85a6                	mv	a1,s1
ffffffffc02055d2:	854a                	mv	a0,s2
ffffffffc02055d4:	e37ff0ef          	jal	ra,ffffffffc020540a <printnum>
            break;
ffffffffc02055d8:	bde1                	j	ffffffffc02054b0 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc02055da:	000a2503          	lw	a0,0(s4)
ffffffffc02055de:	85a6                	mv	a1,s1
ffffffffc02055e0:	0a21                	addi	s4,s4,8
ffffffffc02055e2:	9902                	jalr	s2
            break;
ffffffffc02055e4:	b5f1                	j	ffffffffc02054b0 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02055e6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02055e8:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02055ec:	01174463          	blt	a4,a7,ffffffffc02055f4 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc02055f0:	18088163          	beqz	a7,ffffffffc0205772 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc02055f4:	000a3603          	ld	a2,0(s4)
ffffffffc02055f8:	46a9                	li	a3,10
ffffffffc02055fa:	8a2e                	mv	s4,a1
ffffffffc02055fc:	bfc1                	j	ffffffffc02055cc <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055fe:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0205602:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205604:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205606:	bdf1                	j	ffffffffc02054e2 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0205608:	85a6                	mv	a1,s1
ffffffffc020560a:	02500513          	li	a0,37
ffffffffc020560e:	9902                	jalr	s2
            break;
ffffffffc0205610:	b545                	j	ffffffffc02054b0 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205612:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0205616:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205618:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020561a:	b5e1                	j	ffffffffc02054e2 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc020561c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020561e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205622:	01174463          	blt	a4,a7,ffffffffc020562a <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0205626:	14088163          	beqz	a7,ffffffffc0205768 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc020562a:	000a3603          	ld	a2,0(s4)
ffffffffc020562e:	46a1                	li	a3,8
ffffffffc0205630:	8a2e                	mv	s4,a1
ffffffffc0205632:	bf69                	j	ffffffffc02055cc <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0205634:	03000513          	li	a0,48
ffffffffc0205638:	85a6                	mv	a1,s1
ffffffffc020563a:	e03e                	sd	a5,0(sp)
ffffffffc020563c:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc020563e:	85a6                	mv	a1,s1
ffffffffc0205640:	07800513          	li	a0,120
ffffffffc0205644:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205646:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205648:	6782                	ld	a5,0(sp)
ffffffffc020564a:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020564c:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0205650:	bfb5                	j	ffffffffc02055cc <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205652:	000a3403          	ld	s0,0(s4)
ffffffffc0205656:	008a0713          	addi	a4,s4,8
ffffffffc020565a:	e03a                	sd	a4,0(sp)
ffffffffc020565c:	14040263          	beqz	s0,ffffffffc02057a0 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0205660:	0fb05763          	blez	s11,ffffffffc020574e <vprintfmt+0x2d8>
ffffffffc0205664:	02d00693          	li	a3,45
ffffffffc0205668:	0cd79163          	bne	a5,a3,ffffffffc020572a <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020566c:	00044783          	lbu	a5,0(s0)
ffffffffc0205670:	0007851b          	sext.w	a0,a5
ffffffffc0205674:	cf85                	beqz	a5,ffffffffc02056ac <vprintfmt+0x236>
ffffffffc0205676:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020567a:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020567e:	000c4563          	bltz	s8,ffffffffc0205688 <vprintfmt+0x212>
ffffffffc0205682:	3c7d                	addiw	s8,s8,-1
ffffffffc0205684:	036c0263          	beq	s8,s6,ffffffffc02056a8 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0205688:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020568a:	0e0c8e63          	beqz	s9,ffffffffc0205786 <vprintfmt+0x310>
ffffffffc020568e:	3781                	addiw	a5,a5,-32
ffffffffc0205690:	0ef47b63          	bgeu	s0,a5,ffffffffc0205786 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0205694:	03f00513          	li	a0,63
ffffffffc0205698:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020569a:	000a4783          	lbu	a5,0(s4)
ffffffffc020569e:	3dfd                	addiw	s11,s11,-1
ffffffffc02056a0:	0a05                	addi	s4,s4,1
ffffffffc02056a2:	0007851b          	sext.w	a0,a5
ffffffffc02056a6:	ffe1                	bnez	a5,ffffffffc020567e <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02056a8:	01b05963          	blez	s11,ffffffffc02056ba <vprintfmt+0x244>
ffffffffc02056ac:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02056ae:	85a6                	mv	a1,s1
ffffffffc02056b0:	02000513          	li	a0,32
ffffffffc02056b4:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02056b6:	fe0d9be3          	bnez	s11,ffffffffc02056ac <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02056ba:	6a02                	ld	s4,0(sp)
ffffffffc02056bc:	bbd5                	j	ffffffffc02054b0 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02056be:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02056c0:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02056c4:	01174463          	blt	a4,a7,ffffffffc02056cc <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02056c8:	08088d63          	beqz	a7,ffffffffc0205762 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc02056cc:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02056d0:	0a044d63          	bltz	s0,ffffffffc020578a <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc02056d4:	8622                	mv	a2,s0
ffffffffc02056d6:	8a66                	mv	s4,s9
ffffffffc02056d8:	46a9                	li	a3,10
ffffffffc02056da:	bdcd                	j	ffffffffc02055cc <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc02056dc:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02056e0:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc02056e2:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02056e4:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02056e8:	8fb5                	xor	a5,a5,a3
ffffffffc02056ea:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02056ee:	02d74163          	blt	a4,a3,ffffffffc0205710 <vprintfmt+0x29a>
ffffffffc02056f2:	00369793          	slli	a5,a3,0x3
ffffffffc02056f6:	97de                	add	a5,a5,s7
ffffffffc02056f8:	639c                	ld	a5,0(a5)
ffffffffc02056fa:	cb99                	beqz	a5,ffffffffc0205710 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc02056fc:	86be                	mv	a3,a5
ffffffffc02056fe:	00000617          	auipc	a2,0x0
ffffffffc0205702:	1f260613          	addi	a2,a2,498 # ffffffffc02058f0 <etext+0x2c>
ffffffffc0205706:	85a6                	mv	a1,s1
ffffffffc0205708:	854a                	mv	a0,s2
ffffffffc020570a:	0ce000ef          	jal	ra,ffffffffc02057d8 <printfmt>
ffffffffc020570e:	b34d                	j	ffffffffc02054b0 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205710:	00002617          	auipc	a2,0x2
ffffffffc0205714:	77860613          	addi	a2,a2,1912 # ffffffffc0207e88 <syscalls+0x820>
ffffffffc0205718:	85a6                	mv	a1,s1
ffffffffc020571a:	854a                	mv	a0,s2
ffffffffc020571c:	0bc000ef          	jal	ra,ffffffffc02057d8 <printfmt>
ffffffffc0205720:	bb41                	j	ffffffffc02054b0 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0205722:	00002417          	auipc	s0,0x2
ffffffffc0205726:	75e40413          	addi	s0,s0,1886 # ffffffffc0207e80 <syscalls+0x818>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020572a:	85e2                	mv	a1,s8
ffffffffc020572c:	8522                	mv	a0,s0
ffffffffc020572e:	e43e                	sd	a5,8(sp)
ffffffffc0205730:	0e2000ef          	jal	ra,ffffffffc0205812 <strnlen>
ffffffffc0205734:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0205738:	01b05b63          	blez	s11,ffffffffc020574e <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc020573c:	67a2                	ld	a5,8(sp)
ffffffffc020573e:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205742:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0205744:	85a6                	mv	a1,s1
ffffffffc0205746:	8552                	mv	a0,s4
ffffffffc0205748:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020574a:	fe0d9ce3          	bnez	s11,ffffffffc0205742 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020574e:	00044783          	lbu	a5,0(s0)
ffffffffc0205752:	00140a13          	addi	s4,s0,1
ffffffffc0205756:	0007851b          	sext.w	a0,a5
ffffffffc020575a:	d3a5                	beqz	a5,ffffffffc02056ba <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020575c:	05e00413          	li	s0,94
ffffffffc0205760:	bf39                	j	ffffffffc020567e <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0205762:	000a2403          	lw	s0,0(s4)
ffffffffc0205766:	b7ad                	j	ffffffffc02056d0 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0205768:	000a6603          	lwu	a2,0(s4)
ffffffffc020576c:	46a1                	li	a3,8
ffffffffc020576e:	8a2e                	mv	s4,a1
ffffffffc0205770:	bdb1                	j	ffffffffc02055cc <vprintfmt+0x156>
ffffffffc0205772:	000a6603          	lwu	a2,0(s4)
ffffffffc0205776:	46a9                	li	a3,10
ffffffffc0205778:	8a2e                	mv	s4,a1
ffffffffc020577a:	bd89                	j	ffffffffc02055cc <vprintfmt+0x156>
ffffffffc020577c:	000a6603          	lwu	a2,0(s4)
ffffffffc0205780:	46c1                	li	a3,16
ffffffffc0205782:	8a2e                	mv	s4,a1
ffffffffc0205784:	b5a1                	j	ffffffffc02055cc <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0205786:	9902                	jalr	s2
ffffffffc0205788:	bf09                	j	ffffffffc020569a <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc020578a:	85a6                	mv	a1,s1
ffffffffc020578c:	02d00513          	li	a0,45
ffffffffc0205790:	e03e                	sd	a5,0(sp)
ffffffffc0205792:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0205794:	6782                	ld	a5,0(sp)
ffffffffc0205796:	8a66                	mv	s4,s9
ffffffffc0205798:	40800633          	neg	a2,s0
ffffffffc020579c:	46a9                	li	a3,10
ffffffffc020579e:	b53d                	j	ffffffffc02055cc <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02057a0:	03b05163          	blez	s11,ffffffffc02057c2 <vprintfmt+0x34c>
ffffffffc02057a4:	02d00693          	li	a3,45
ffffffffc02057a8:	f6d79de3          	bne	a5,a3,ffffffffc0205722 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02057ac:	00002417          	auipc	s0,0x2
ffffffffc02057b0:	6d440413          	addi	s0,s0,1748 # ffffffffc0207e80 <syscalls+0x818>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057b4:	02800793          	li	a5,40
ffffffffc02057b8:	02800513          	li	a0,40
ffffffffc02057bc:	00140a13          	addi	s4,s0,1
ffffffffc02057c0:	bd6d                	j	ffffffffc020567a <vprintfmt+0x204>
ffffffffc02057c2:	00002a17          	auipc	s4,0x2
ffffffffc02057c6:	6bfa0a13          	addi	s4,s4,1727 # ffffffffc0207e81 <syscalls+0x819>
ffffffffc02057ca:	02800513          	li	a0,40
ffffffffc02057ce:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057d2:	05e00413          	li	s0,94
ffffffffc02057d6:	b565                	j	ffffffffc020567e <vprintfmt+0x208>

ffffffffc02057d8 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02057d8:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02057da:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02057de:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02057e0:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02057e2:	ec06                	sd	ra,24(sp)
ffffffffc02057e4:	f83a                	sd	a4,48(sp)
ffffffffc02057e6:	fc3e                	sd	a5,56(sp)
ffffffffc02057e8:	e0c2                	sd	a6,64(sp)
ffffffffc02057ea:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02057ec:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02057ee:	c89ff0ef          	jal	ra,ffffffffc0205476 <vprintfmt>
}
ffffffffc02057f2:	60e2                	ld	ra,24(sp)
ffffffffc02057f4:	6161                	addi	sp,sp,80
ffffffffc02057f6:	8082                	ret

ffffffffc02057f8 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02057f8:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc02057fc:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc02057fe:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0205800:	cb81                	beqz	a5,ffffffffc0205810 <strlen+0x18>
        cnt ++;
ffffffffc0205802:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0205804:	00a707b3          	add	a5,a4,a0
ffffffffc0205808:	0007c783          	lbu	a5,0(a5)
ffffffffc020580c:	fbfd                	bnez	a5,ffffffffc0205802 <strlen+0xa>
ffffffffc020580e:	8082                	ret
    }
    return cnt;
}
ffffffffc0205810:	8082                	ret

ffffffffc0205812 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205812:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205814:	e589                	bnez	a1,ffffffffc020581e <strnlen+0xc>
ffffffffc0205816:	a811                	j	ffffffffc020582a <strnlen+0x18>
        cnt ++;
ffffffffc0205818:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc020581a:	00f58863          	beq	a1,a5,ffffffffc020582a <strnlen+0x18>
ffffffffc020581e:	00f50733          	add	a4,a0,a5
ffffffffc0205822:	00074703          	lbu	a4,0(a4)
ffffffffc0205826:	fb6d                	bnez	a4,ffffffffc0205818 <strnlen+0x6>
ffffffffc0205828:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc020582a:	852e                	mv	a0,a1
ffffffffc020582c:	8082                	ret

ffffffffc020582e <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc020582e:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205830:	0005c703          	lbu	a4,0(a1)
ffffffffc0205834:	0785                	addi	a5,a5,1
ffffffffc0205836:	0585                	addi	a1,a1,1
ffffffffc0205838:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020583c:	fb75                	bnez	a4,ffffffffc0205830 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc020583e:	8082                	ret

ffffffffc0205840 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205840:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205844:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205848:	cb89                	beqz	a5,ffffffffc020585a <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc020584a:	0505                	addi	a0,a0,1
ffffffffc020584c:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020584e:	fee789e3          	beq	a5,a4,ffffffffc0205840 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205852:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205856:	9d19                	subw	a0,a0,a4
ffffffffc0205858:	8082                	ret
ffffffffc020585a:	4501                	li	a0,0
ffffffffc020585c:	bfed                	j	ffffffffc0205856 <strcmp+0x16>

ffffffffc020585e <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020585e:	c20d                	beqz	a2,ffffffffc0205880 <strncmp+0x22>
ffffffffc0205860:	962e                	add	a2,a2,a1
ffffffffc0205862:	a031                	j	ffffffffc020586e <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0205864:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205866:	00e79a63          	bne	a5,a4,ffffffffc020587a <strncmp+0x1c>
ffffffffc020586a:	00b60b63          	beq	a2,a1,ffffffffc0205880 <strncmp+0x22>
ffffffffc020586e:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205872:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205874:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0205878:	f7f5                	bnez	a5,ffffffffc0205864 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020587a:	40e7853b          	subw	a0,a5,a4
}
ffffffffc020587e:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205880:	4501                	li	a0,0
ffffffffc0205882:	8082                	ret

ffffffffc0205884 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205884:	00054783          	lbu	a5,0(a0)
ffffffffc0205888:	c799                	beqz	a5,ffffffffc0205896 <strchr+0x12>
        if (*s == c) {
ffffffffc020588a:	00f58763          	beq	a1,a5,ffffffffc0205898 <strchr+0x14>
    while (*s != '\0') {
ffffffffc020588e:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0205892:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0205894:	fbfd                	bnez	a5,ffffffffc020588a <strchr+0x6>
    }
    return NULL;
ffffffffc0205896:	4501                	li	a0,0
}
ffffffffc0205898:	8082                	ret

ffffffffc020589a <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc020589a:	ca01                	beqz	a2,ffffffffc02058aa <memset+0x10>
ffffffffc020589c:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020589e:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02058a0:	0785                	addi	a5,a5,1
ffffffffc02058a2:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02058a6:	fec79de3          	bne	a5,a2,ffffffffc02058a0 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02058aa:	8082                	ret

ffffffffc02058ac <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02058ac:	ca19                	beqz	a2,ffffffffc02058c2 <memcpy+0x16>
ffffffffc02058ae:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02058b0:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02058b2:	0005c703          	lbu	a4,0(a1)
ffffffffc02058b6:	0585                	addi	a1,a1,1
ffffffffc02058b8:	0785                	addi	a5,a5,1
ffffffffc02058ba:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02058be:	fec59ae3          	bne	a1,a2,ffffffffc02058b2 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02058c2:	8082                	ret
