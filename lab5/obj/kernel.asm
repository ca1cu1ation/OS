
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000b297          	auipc	t0,0xb
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020b000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000b297          	auipc	t0,0xb
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020b008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020a2b7          	lui	t0,0xc020a
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
ffffffffc020003c:	c020a137          	lui	sp,0xc020a

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
ffffffffc020004a:	000da517          	auipc	a0,0xda
ffffffffc020004e:	64650513          	addi	a0,a0,1606 # ffffffffc02da690 <buf>
ffffffffc0200052:	000df617          	auipc	a2,0xdf
ffffffffc0200056:	af260613          	addi	a2,a2,-1294 # ffffffffc02deb44 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	06f050ef          	jal	ra,ffffffffc02058d0 <memset>
    dtb_init();
ffffffffc0200066:	598000ef          	jal	ra,ffffffffc02005fe <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	522000ef          	jal	ra,ffffffffc020058c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00006597          	auipc	a1,0x6
ffffffffc0200072:	89258593          	addi	a1,a1,-1902 # ffffffffc0205900 <etext+0x6>
ffffffffc0200076:	00006517          	auipc	a0,0x6
ffffffffc020007a:	8aa50513          	addi	a0,a0,-1878 # ffffffffc0205920 <etext+0x26>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	19a000ef          	jal	ra,ffffffffc020021c <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	11b020ef          	jal	ra,ffffffffc02029a0 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	131000ef          	jal	ra,ffffffffc02009ba <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12f000ef          	jal	ra,ffffffffc02009bc <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	3b5030ef          	jal	ra,ffffffffc0203c46 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	78d040ef          	jal	ra,ffffffffc0205022 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	4a0000ef          	jal	ra,ffffffffc020053a <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	111000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	118050ef          	jal	ra,ffffffffc02051ba <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	715d                	addi	sp,sp,-80
ffffffffc02000a8:	e486                	sd	ra,72(sp)
ffffffffc02000aa:	e0a6                	sd	s1,64(sp)
ffffffffc02000ac:	fc4a                	sd	s2,56(sp)
ffffffffc02000ae:	f84e                	sd	s3,48(sp)
ffffffffc02000b0:	f452                	sd	s4,40(sp)
ffffffffc02000b2:	f056                	sd	s5,32(sp)
ffffffffc02000b4:	ec5a                	sd	s6,24(sp)
ffffffffc02000b6:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000b8:	c901                	beqz	a0,ffffffffc02000c8 <readline+0x22>
ffffffffc02000ba:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000bc:	00006517          	auipc	a0,0x6
ffffffffc02000c0:	86c50513          	addi	a0,a0,-1940 # ffffffffc0205928 <etext+0x2e>
ffffffffc02000c4:	0d0000ef          	jal	ra,ffffffffc0200194 <cprintf>
readline(const char *prompt) {
ffffffffc02000c8:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ca:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000cc:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000ce:	4aa9                	li	s5,10
ffffffffc02000d0:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000d2:	000dab97          	auipc	s7,0xda
ffffffffc02000d6:	5beb8b93          	addi	s7,s7,1470 # ffffffffc02da690 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000da:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000de:	12e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000e2:	00054a63          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e6:	00a95a63          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc02000ea:	029a5263          	bge	s4,s1,ffffffffc020010e <readline+0x68>
        c = getchar();
ffffffffc02000ee:	11e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000f2:	fe055ae3          	bgez	a0,ffffffffc02000e6 <readline+0x40>
            return NULL;
ffffffffc02000f6:	4501                	li	a0,0
ffffffffc02000f8:	a091                	j	ffffffffc020013c <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fa:	03351463          	bne	a0,s3,ffffffffc0200122 <readline+0x7c>
ffffffffc02000fe:	e8a9                	bnez	s1,ffffffffc0200150 <readline+0xaa>
        c = getchar();
ffffffffc0200100:	10c000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc0200104:	fe0549e3          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200108:	fea959e3          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc020010c:	4481                	li	s1,0
            cputchar(c);
ffffffffc020010e:	e42a                	sd	a0,8(sp)
ffffffffc0200110:	0ba000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i ++] = c;
ffffffffc0200114:	6522                	ld	a0,8(sp)
ffffffffc0200116:	009b87b3          	add	a5,s7,s1
ffffffffc020011a:	2485                	addiw	s1,s1,1
ffffffffc020011c:	00a78023          	sb	a0,0(a5)
ffffffffc0200120:	bf7d                	j	ffffffffc02000de <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200122:	01550463          	beq	a0,s5,ffffffffc020012a <readline+0x84>
ffffffffc0200126:	fb651ce3          	bne	a0,s6,ffffffffc02000de <readline+0x38>
            cputchar(c);
ffffffffc020012a:	0a0000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i] = '\0';
ffffffffc020012e:	000da517          	auipc	a0,0xda
ffffffffc0200132:	56250513          	addi	a0,a0,1378 # ffffffffc02da690 <buf>
ffffffffc0200136:	94aa                	add	s1,s1,a0
ffffffffc0200138:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc020013c:	60a6                	ld	ra,72(sp)
ffffffffc020013e:	6486                	ld	s1,64(sp)
ffffffffc0200140:	7962                	ld	s2,56(sp)
ffffffffc0200142:	79c2                	ld	s3,48(sp)
ffffffffc0200144:	7a22                	ld	s4,40(sp)
ffffffffc0200146:	7a82                	ld	s5,32(sp)
ffffffffc0200148:	6b62                	ld	s6,24(sp)
ffffffffc020014a:	6bc2                	ld	s7,16(sp)
ffffffffc020014c:	6161                	addi	sp,sp,80
ffffffffc020014e:	8082                	ret
            cputchar(c);
ffffffffc0200150:	4521                	li	a0,8
ffffffffc0200152:	078000ef          	jal	ra,ffffffffc02001ca <cputchar>
            i --;
ffffffffc0200156:	34fd                	addiw	s1,s1,-1
ffffffffc0200158:	b759                	j	ffffffffc02000de <readline+0x38>

ffffffffc020015a <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015a:	1141                	addi	sp,sp,-16
ffffffffc020015c:	e022                	sd	s0,0(sp)
ffffffffc020015e:	e406                	sd	ra,8(sp)
ffffffffc0200160:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200162:	42c000ef          	jal	ra,ffffffffc020058e <cons_putc>
    (*cnt)++;
ffffffffc0200166:	401c                	lw	a5,0(s0)
}
ffffffffc0200168:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc020016a:	2785                	addiw	a5,a5,1
ffffffffc020016c:	c01c                	sw	a5,0(s0)
}
ffffffffc020016e:	6402                	ld	s0,0(sp)
ffffffffc0200170:	0141                	addi	sp,sp,16
ffffffffc0200172:	8082                	ret

ffffffffc0200174 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200174:	1101                	addi	sp,sp,-32
ffffffffc0200176:	862a                	mv	a2,a0
ffffffffc0200178:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017a:	00000517          	auipc	a0,0x0
ffffffffc020017e:	fe050513          	addi	a0,a0,-32 # ffffffffc020015a <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
{
ffffffffc0200184:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200186:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc0200188:	324050ef          	jal	ra,ffffffffc02054ac <vprintfmt>
    return cnt;
}
ffffffffc020018c:	60e2                	ld	ra,24(sp)
ffffffffc020018e:	4532                	lw	a0,12(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret

ffffffffc0200194 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200194:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200196:	02810313          	addi	t1,sp,40 # ffffffffc020a028 <boot_page_table_sv39+0x28>
{
ffffffffc020019a:	8e2a                	mv	t3,a0
ffffffffc020019c:	f42e                	sd	a1,40(sp)
ffffffffc020019e:	f832                	sd	a2,48(sp)
ffffffffc02001a0:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a2:	00000517          	auipc	a0,0x0
ffffffffc02001a6:	fb850513          	addi	a0,a0,-72 # ffffffffc020015a <cputch>
ffffffffc02001aa:	004c                	addi	a1,sp,4
ffffffffc02001ac:	869a                	mv	a3,t1
ffffffffc02001ae:	8672                	mv	a2,t3
{
ffffffffc02001b0:	ec06                	sd	ra,24(sp)
ffffffffc02001b2:	e0ba                	sd	a4,64(sp)
ffffffffc02001b4:	e4be                	sd	a5,72(sp)
ffffffffc02001b6:	e8c2                	sd	a6,80(sp)
ffffffffc02001b8:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001bc:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001be:	2ee050ef          	jal	ra,ffffffffc02054ac <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c2:	60e2                	ld	ra,24(sp)
ffffffffc02001c4:	4512                	lw	a0,4(sp)
ffffffffc02001c6:	6125                	addi	sp,sp,96
ffffffffc02001c8:	8082                	ret

ffffffffc02001ca <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001ca:	a6d1                	j	ffffffffc020058e <cons_putc>

ffffffffc02001cc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001cc:	1101                	addi	sp,sp,-32
ffffffffc02001ce:	e822                	sd	s0,16(sp)
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e426                	sd	s1,8(sp)
ffffffffc02001d4:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d6:	00054503          	lbu	a0,0(a0)
ffffffffc02001da:	c51d                	beqz	a0,ffffffffc0200208 <cputs+0x3c>
ffffffffc02001dc:	0405                	addi	s0,s0,1
ffffffffc02001de:	4485                	li	s1,1
ffffffffc02001e0:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001e2:	3ac000ef          	jal	ra,ffffffffc020058e <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e6:	00044503          	lbu	a0,0(s0)
ffffffffc02001ea:	008487bb          	addw	a5,s1,s0
ffffffffc02001ee:	0405                	addi	s0,s0,1
ffffffffc02001f0:	f96d                	bnez	a0,ffffffffc02001e2 <cputs+0x16>
    (*cnt)++;
ffffffffc02001f2:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001f6:	4529                	li	a0,10
ffffffffc02001f8:	396000ef          	jal	ra,ffffffffc020058e <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fc:	60e2                	ld	ra,24(sp)
ffffffffc02001fe:	8522                	mv	a0,s0
ffffffffc0200200:	6442                	ld	s0,16(sp)
ffffffffc0200202:	64a2                	ld	s1,8(sp)
ffffffffc0200204:	6105                	addi	sp,sp,32
ffffffffc0200206:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc0200208:	4405                	li	s0,1
ffffffffc020020a:	b7f5                	j	ffffffffc02001f6 <cputs+0x2a>

ffffffffc020020c <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020020c:	1141                	addi	sp,sp,-16
ffffffffc020020e:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200210:	3b2000ef          	jal	ra,ffffffffc02005c2 <cons_getc>
ffffffffc0200214:	dd75                	beqz	a0,ffffffffc0200210 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200216:	60a2                	ld	ra,8(sp)
ffffffffc0200218:	0141                	addi	sp,sp,16
ffffffffc020021a:	8082                	ret

ffffffffc020021c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc020021c:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020021e:	00005517          	auipc	a0,0x5
ffffffffc0200222:	71250513          	addi	a0,a0,1810 # ffffffffc0205930 <etext+0x36>
{
ffffffffc0200226:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	f6dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020022c:	00000597          	auipc	a1,0x0
ffffffffc0200230:	e1e58593          	addi	a1,a1,-482 # ffffffffc020004a <kern_init>
ffffffffc0200234:	00005517          	auipc	a0,0x5
ffffffffc0200238:	71c50513          	addi	a0,a0,1820 # ffffffffc0205950 <etext+0x56>
ffffffffc020023c:	f59ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200240:	00005597          	auipc	a1,0x5
ffffffffc0200244:	6ba58593          	addi	a1,a1,1722 # ffffffffc02058fa <etext>
ffffffffc0200248:	00005517          	auipc	a0,0x5
ffffffffc020024c:	72850513          	addi	a0,a0,1832 # ffffffffc0205970 <etext+0x76>
ffffffffc0200250:	f45ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200254:	000da597          	auipc	a1,0xda
ffffffffc0200258:	43c58593          	addi	a1,a1,1084 # ffffffffc02da690 <buf>
ffffffffc020025c:	00005517          	auipc	a0,0x5
ffffffffc0200260:	73450513          	addi	a0,a0,1844 # ffffffffc0205990 <etext+0x96>
ffffffffc0200264:	f31ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200268:	000df597          	auipc	a1,0xdf
ffffffffc020026c:	8dc58593          	addi	a1,a1,-1828 # ffffffffc02deb44 <end>
ffffffffc0200270:	00005517          	auipc	a0,0x5
ffffffffc0200274:	74050513          	addi	a0,a0,1856 # ffffffffc02059b0 <etext+0xb6>
ffffffffc0200278:	f1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020027c:	000df597          	auipc	a1,0xdf
ffffffffc0200280:	cc758593          	addi	a1,a1,-825 # ffffffffc02def43 <end+0x3ff>
ffffffffc0200284:	00000797          	auipc	a5,0x0
ffffffffc0200288:	dc678793          	addi	a5,a5,-570 # ffffffffc020004a <kern_init>
ffffffffc020028c:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200290:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200294:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200296:	3ff5f593          	andi	a1,a1,1023
ffffffffc020029a:	95be                	add	a1,a1,a5
ffffffffc020029c:	85a9                	srai	a1,a1,0xa
ffffffffc020029e:	00005517          	auipc	a0,0x5
ffffffffc02002a2:	73250513          	addi	a0,a0,1842 # ffffffffc02059d0 <etext+0xd6>
}
ffffffffc02002a6:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002a8:	b5f5                	j	ffffffffc0200194 <cprintf>

ffffffffc02002aa <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002aa:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002ac:	00005617          	auipc	a2,0x5
ffffffffc02002b0:	75460613          	addi	a2,a2,1876 # ffffffffc0205a00 <etext+0x106>
ffffffffc02002b4:	04f00593          	li	a1,79
ffffffffc02002b8:	00005517          	auipc	a0,0x5
ffffffffc02002bc:	76050513          	addi	a0,a0,1888 # ffffffffc0205a18 <etext+0x11e>
{
ffffffffc02002c0:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002c2:	1cc000ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02002c6 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02002c6:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002c8:	00005617          	auipc	a2,0x5
ffffffffc02002cc:	76860613          	addi	a2,a2,1896 # ffffffffc0205a30 <etext+0x136>
ffffffffc02002d0:	00005597          	auipc	a1,0x5
ffffffffc02002d4:	78058593          	addi	a1,a1,1920 # ffffffffc0205a50 <etext+0x156>
ffffffffc02002d8:	00005517          	auipc	a0,0x5
ffffffffc02002dc:	78050513          	addi	a0,a0,1920 # ffffffffc0205a58 <etext+0x15e>
{
ffffffffc02002e0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e2:	eb3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002e6:	00005617          	auipc	a2,0x5
ffffffffc02002ea:	78260613          	addi	a2,a2,1922 # ffffffffc0205a68 <etext+0x16e>
ffffffffc02002ee:	00005597          	auipc	a1,0x5
ffffffffc02002f2:	7a258593          	addi	a1,a1,1954 # ffffffffc0205a90 <etext+0x196>
ffffffffc02002f6:	00005517          	auipc	a0,0x5
ffffffffc02002fa:	76250513          	addi	a0,a0,1890 # ffffffffc0205a58 <etext+0x15e>
ffffffffc02002fe:	e97ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200302:	00005617          	auipc	a2,0x5
ffffffffc0200306:	79e60613          	addi	a2,a2,1950 # ffffffffc0205aa0 <etext+0x1a6>
ffffffffc020030a:	00005597          	auipc	a1,0x5
ffffffffc020030e:	7b658593          	addi	a1,a1,1974 # ffffffffc0205ac0 <etext+0x1c6>
ffffffffc0200312:	00005517          	auipc	a0,0x5
ffffffffc0200316:	74650513          	addi	a0,a0,1862 # ffffffffc0205a58 <etext+0x15e>
ffffffffc020031a:	e7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    return 0;
}
ffffffffc020031e:	60a2                	ld	ra,8(sp)
ffffffffc0200320:	4501                	li	a0,0
ffffffffc0200322:	0141                	addi	sp,sp,16
ffffffffc0200324:	8082                	ret

ffffffffc0200326 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200326:	1141                	addi	sp,sp,-16
ffffffffc0200328:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020032a:	ef3ff0ef          	jal	ra,ffffffffc020021c <print_kerninfo>
    return 0;
}
ffffffffc020032e:	60a2                	ld	ra,8(sp)
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	0141                	addi	sp,sp,16
ffffffffc0200334:	8082                	ret

ffffffffc0200336 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200336:	1141                	addi	sp,sp,-16
ffffffffc0200338:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020033a:	f71ff0ef          	jal	ra,ffffffffc02002aa <print_stackframe>
    return 0;
}
ffffffffc020033e:	60a2                	ld	ra,8(sp)
ffffffffc0200340:	4501                	li	a0,0
ffffffffc0200342:	0141                	addi	sp,sp,16
ffffffffc0200344:	8082                	ret

ffffffffc0200346 <kmonitor>:
{
ffffffffc0200346:	7115                	addi	sp,sp,-224
ffffffffc0200348:	ed5e                	sd	s7,152(sp)
ffffffffc020034a:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020034c:	00005517          	auipc	a0,0x5
ffffffffc0200350:	78450513          	addi	a0,a0,1924 # ffffffffc0205ad0 <etext+0x1d6>
{
ffffffffc0200354:	ed86                	sd	ra,216(sp)
ffffffffc0200356:	e9a2                	sd	s0,208(sp)
ffffffffc0200358:	e5a6                	sd	s1,200(sp)
ffffffffc020035a:	e1ca                	sd	s2,192(sp)
ffffffffc020035c:	fd4e                	sd	s3,184(sp)
ffffffffc020035e:	f952                	sd	s4,176(sp)
ffffffffc0200360:	f556                	sd	s5,168(sp)
ffffffffc0200362:	f15a                	sd	s6,160(sp)
ffffffffc0200364:	e962                	sd	s8,144(sp)
ffffffffc0200366:	e566                	sd	s9,136(sp)
ffffffffc0200368:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036a:	e2bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020036e:	00005517          	auipc	a0,0x5
ffffffffc0200372:	78a50513          	addi	a0,a0,1930 # ffffffffc0205af8 <etext+0x1fe>
ffffffffc0200376:	e1fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc020037a:	000b8563          	beqz	s7,ffffffffc0200384 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	025000ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
ffffffffc0200384:	00005c17          	auipc	s8,0x5
ffffffffc0200388:	7e4c0c13          	addi	s8,s8,2020 # ffffffffc0205b68 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020038c:	00005917          	auipc	s2,0x5
ffffffffc0200390:	79490913          	addi	s2,s2,1940 # ffffffffc0205b20 <etext+0x226>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200394:	00005497          	auipc	s1,0x5
ffffffffc0200398:	79448493          	addi	s1,s1,1940 # ffffffffc0205b28 <etext+0x22e>
        if (argc == MAXARGS - 1)
ffffffffc020039c:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039e:	00005b17          	auipc	s6,0x5
ffffffffc02003a2:	792b0b13          	addi	s6,s6,1938 # ffffffffc0205b30 <etext+0x236>
        argv[argc++] = buf;
ffffffffc02003a6:	00005a17          	auipc	s4,0x5
ffffffffc02003aa:	6aaa0a13          	addi	s4,s4,1706 # ffffffffc0205a50 <etext+0x156>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003ae:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL)
ffffffffc02003b0:	854a                	mv	a0,s2
ffffffffc02003b2:	cf5ff0ef          	jal	ra,ffffffffc02000a6 <readline>
ffffffffc02003b6:	842a                	mv	s0,a0
ffffffffc02003b8:	dd65                	beqz	a0,ffffffffc02003b0 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003ba:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003be:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003c0:	e1bd                	bnez	a1,ffffffffc0200426 <kmonitor+0xe0>
    if (argc == 0)
ffffffffc02003c2:	fe0c87e3          	beqz	s9,ffffffffc02003b0 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003c6:	6582                	ld	a1,0(sp)
ffffffffc02003c8:	00005d17          	auipc	s10,0x5
ffffffffc02003cc:	7a0d0d13          	addi	s10,s10,1952 # ffffffffc0205b68 <commands>
        argv[argc++] = buf;
ffffffffc02003d0:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d2:	4401                	li	s0,0
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003d6:	4a0050ef          	jal	ra,ffffffffc0205876 <strcmp>
ffffffffc02003da:	c919                	beqz	a0,ffffffffc02003f0 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003dc:	2405                	addiw	s0,s0,1
ffffffffc02003de:	0b540063          	beq	s0,s5,ffffffffc020047e <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003e2:	000d3503          	ld	a0,0(s10)
ffffffffc02003e6:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003e8:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003ea:	48c050ef          	jal	ra,ffffffffc0205876 <strcmp>
ffffffffc02003ee:	f57d                	bnez	a0,ffffffffc02003dc <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003f0:	00141793          	slli	a5,s0,0x1
ffffffffc02003f4:	97a2                	add	a5,a5,s0
ffffffffc02003f6:	078e                	slli	a5,a5,0x3
ffffffffc02003f8:	97e2                	add	a5,a5,s8
ffffffffc02003fa:	6b9c                	ld	a5,16(a5)
ffffffffc02003fc:	865e                	mv	a2,s7
ffffffffc02003fe:	002c                	addi	a1,sp,8
ffffffffc0200400:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200404:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc0200406:	fa0555e3          	bgez	a0,ffffffffc02003b0 <kmonitor+0x6a>
}
ffffffffc020040a:	60ee                	ld	ra,216(sp)
ffffffffc020040c:	644e                	ld	s0,208(sp)
ffffffffc020040e:	64ae                	ld	s1,200(sp)
ffffffffc0200410:	690e                	ld	s2,192(sp)
ffffffffc0200412:	79ea                	ld	s3,184(sp)
ffffffffc0200414:	7a4a                	ld	s4,176(sp)
ffffffffc0200416:	7aaa                	ld	s5,168(sp)
ffffffffc0200418:	7b0a                	ld	s6,160(sp)
ffffffffc020041a:	6bea                	ld	s7,152(sp)
ffffffffc020041c:	6c4a                	ld	s8,144(sp)
ffffffffc020041e:	6caa                	ld	s9,136(sp)
ffffffffc0200420:	6d0a                	ld	s10,128(sp)
ffffffffc0200422:	612d                	addi	sp,sp,224
ffffffffc0200424:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200426:	8526                	mv	a0,s1
ffffffffc0200428:	492050ef          	jal	ra,ffffffffc02058ba <strchr>
ffffffffc020042c:	c901                	beqz	a0,ffffffffc020043c <kmonitor+0xf6>
ffffffffc020042e:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc0200432:	00040023          	sb	zero,0(s0)
ffffffffc0200436:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200438:	d5c9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc020043a:	b7f5                	j	ffffffffc0200426 <kmonitor+0xe0>
        if (*buf == '\0')
ffffffffc020043c:	00044783          	lbu	a5,0(s0)
ffffffffc0200440:	d3c9                	beqz	a5,ffffffffc02003c2 <kmonitor+0x7c>
        if (argc == MAXARGS - 1)
ffffffffc0200442:	033c8963          	beq	s9,s3,ffffffffc0200474 <kmonitor+0x12e>
        argv[argc++] = buf;
ffffffffc0200446:	003c9793          	slli	a5,s9,0x3
ffffffffc020044a:	0118                	addi	a4,sp,128
ffffffffc020044c:	97ba                	add	a5,a5,a4
ffffffffc020044e:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200452:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc0200456:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200458:	e591                	bnez	a1,ffffffffc0200464 <kmonitor+0x11e>
ffffffffc020045a:	b7b5                	j	ffffffffc02003c6 <kmonitor+0x80>
ffffffffc020045c:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc0200460:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200462:	d1a5                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200464:	8526                	mv	a0,s1
ffffffffc0200466:	454050ef          	jal	ra,ffffffffc02058ba <strchr>
ffffffffc020046a:	d96d                	beqz	a0,ffffffffc020045c <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020046c:	00044583          	lbu	a1,0(s0)
ffffffffc0200470:	d9a9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200472:	bf55                	j	ffffffffc0200426 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200474:	45c1                	li	a1,16
ffffffffc0200476:	855a                	mv	a0,s6
ffffffffc0200478:	d1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020047c:	b7e9                	j	ffffffffc0200446 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020047e:	6582                	ld	a1,0(sp)
ffffffffc0200480:	00005517          	auipc	a0,0x5
ffffffffc0200484:	6d050513          	addi	a0,a0,1744 # ffffffffc0205b50 <etext+0x256>
ffffffffc0200488:	d0dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
ffffffffc020048c:	b715                	j	ffffffffc02003b0 <kmonitor+0x6a>

ffffffffc020048e <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc020048e:	000de317          	auipc	t1,0xde
ffffffffc0200492:	62a30313          	addi	t1,t1,1578 # ffffffffc02deab8 <is_panic>
ffffffffc0200496:	00033e03          	ld	t3,0(t1)
{
ffffffffc020049a:	715d                	addi	sp,sp,-80
ffffffffc020049c:	ec06                	sd	ra,24(sp)
ffffffffc020049e:	e822                	sd	s0,16(sp)
ffffffffc02004a0:	f436                	sd	a3,40(sp)
ffffffffc02004a2:	f83a                	sd	a4,48(sp)
ffffffffc02004a4:	fc3e                	sd	a5,56(sp)
ffffffffc02004a6:	e0c2                	sd	a6,64(sp)
ffffffffc02004a8:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc02004aa:	020e1a63          	bnez	t3,ffffffffc02004de <__panic+0x50>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02004ae:	4785                	li	a5,1
ffffffffc02004b0:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b4:	8432                	mv	s0,a2
ffffffffc02004b6:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004b8:	862e                	mv	a2,a1
ffffffffc02004ba:	85aa                	mv	a1,a0
ffffffffc02004bc:	00005517          	auipc	a0,0x5
ffffffffc02004c0:	6f450513          	addi	a0,a0,1780 # ffffffffc0205bb0 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c4:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004c6:	ccfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ca:	65a2                	ld	a1,8(sp)
ffffffffc02004cc:	8522                	mv	a0,s0
ffffffffc02004ce:	ca7ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004d2:	00007517          	auipc	a0,0x7
ffffffffc02004d6:	81650513          	addi	a0,a0,-2026 # ffffffffc0206ce8 <default_pmm_manager+0x588>
ffffffffc02004da:	cbbff0ef          	jal	ra,ffffffffc0200194 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004de:	4501                	li	a0,0
ffffffffc02004e0:	4581                	li	a1,0
ffffffffc02004e2:	4601                	li	a2,0
ffffffffc02004e4:	48a1                	li	a7,8
ffffffffc02004e6:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004ea:	4ca000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc02004ee:	4501                	li	a0,0
ffffffffc02004f0:	e57ff0ef          	jal	ra,ffffffffc0200346 <kmonitor>
    while (1)
ffffffffc02004f4:	bfed                	j	ffffffffc02004ee <__panic+0x60>

ffffffffc02004f6 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc02004f6:	715d                	addi	sp,sp,-80
ffffffffc02004f8:	832e                	mv	t1,a1
ffffffffc02004fa:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004fc:	85aa                	mv	a1,a0
{
ffffffffc02004fe:	8432                	mv	s0,a2
ffffffffc0200500:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200502:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200504:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200506:	00005517          	auipc	a0,0x5
ffffffffc020050a:	6ca50513          	addi	a0,a0,1738 # ffffffffc0205bd0 <commands+0x68>
{
ffffffffc020050e:	ec06                	sd	ra,24(sp)
ffffffffc0200510:	f436                	sd	a3,40(sp)
ffffffffc0200512:	f83a                	sd	a4,48(sp)
ffffffffc0200514:	e0c2                	sd	a6,64(sp)
ffffffffc0200516:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0200518:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020051a:	c7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020051e:	65a2                	ld	a1,8(sp)
ffffffffc0200520:	8522                	mv	a0,s0
ffffffffc0200522:	c53ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc0200526:	00006517          	auipc	a0,0x6
ffffffffc020052a:	7c250513          	addi	a0,a0,1986 # ffffffffc0206ce8 <default_pmm_manager+0x588>
ffffffffc020052e:	c67ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    va_end(ap);
}
ffffffffc0200532:	60e2                	ld	ra,24(sp)
ffffffffc0200534:	6442                	ld	s0,16(sp)
ffffffffc0200536:	6161                	addi	sp,sp,80
ffffffffc0200538:	8082                	ret

ffffffffc020053a <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc020053a:	67e1                	lui	a5,0x18
ffffffffc020053c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_dirtycow_out_size+0xd150>
ffffffffc0200540:	000de717          	auipc	a4,0xde
ffffffffc0200544:	58f73423          	sd	a5,1416(a4) # ffffffffc02deac8 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200548:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc020054c:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020054e:	953e                	add	a0,a0,a5
ffffffffc0200550:	4601                	li	a2,0
ffffffffc0200552:	4881                	li	a7,0
ffffffffc0200554:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200558:	02000793          	li	a5,32
ffffffffc020055c:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc0200560:	00005517          	auipc	a0,0x5
ffffffffc0200564:	69050513          	addi	a0,a0,1680 # ffffffffc0205bf0 <commands+0x88>
    ticks = 0;
ffffffffc0200568:	000de797          	auipc	a5,0xde
ffffffffc020056c:	5407bc23          	sd	zero,1368(a5) # ffffffffc02deac0 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200570:	b115                	j	ffffffffc0200194 <cprintf>

ffffffffc0200572 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200572:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200576:	000de797          	auipc	a5,0xde
ffffffffc020057a:	5527b783          	ld	a5,1362(a5) # ffffffffc02deac8 <timebase>
ffffffffc020057e:	953e                	add	a0,a0,a5
ffffffffc0200580:	4581                	li	a1,0
ffffffffc0200582:	4601                	li	a2,0
ffffffffc0200584:	4881                	li	a7,0
ffffffffc0200586:	00000073          	ecall
ffffffffc020058a:	8082                	ret

ffffffffc020058c <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020058c:	8082                	ret

ffffffffc020058e <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020058e:	100027f3          	csrr	a5,sstatus
ffffffffc0200592:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200594:	0ff57513          	zext.b	a0,a0
ffffffffc0200598:	e799                	bnez	a5,ffffffffc02005a6 <cons_putc+0x18>
ffffffffc020059a:	4581                	li	a1,0
ffffffffc020059c:	4601                	li	a2,0
ffffffffc020059e:	4885                	li	a7,1
ffffffffc02005a0:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc02005a4:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02005a6:	1101                	addi	sp,sp,-32
ffffffffc02005a8:	ec06                	sd	ra,24(sp)
ffffffffc02005aa:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02005ac:	408000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005b0:	6522                	ld	a0,8(sp)
ffffffffc02005b2:	4581                	li	a1,0
ffffffffc02005b4:	4601                	li	a2,0
ffffffffc02005b6:	4885                	li	a7,1
ffffffffc02005b8:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02005bc:	60e2                	ld	ra,24(sp)
ffffffffc02005be:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc02005c0:	a6fd                	j	ffffffffc02009ae <intr_enable>

ffffffffc02005c2 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02005c2:	100027f3          	csrr	a5,sstatus
ffffffffc02005c6:	8b89                	andi	a5,a5,2
ffffffffc02005c8:	eb89                	bnez	a5,ffffffffc02005da <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005ca:	4501                	li	a0,0
ffffffffc02005cc:	4581                	li	a1,0
ffffffffc02005ce:	4601                	li	a2,0
ffffffffc02005d0:	4889                	li	a7,2
ffffffffc02005d2:	00000073          	ecall
ffffffffc02005d6:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005d8:	8082                	ret
int cons_getc(void) {
ffffffffc02005da:	1101                	addi	sp,sp,-32
ffffffffc02005dc:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005de:	3d6000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005e2:	4501                	li	a0,0
ffffffffc02005e4:	4581                	li	a1,0
ffffffffc02005e6:	4601                	li	a2,0
ffffffffc02005e8:	4889                	li	a7,2
ffffffffc02005ea:	00000073          	ecall
ffffffffc02005ee:	2501                	sext.w	a0,a0
ffffffffc02005f0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005f2:	3bc000ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc02005f6:	60e2                	ld	ra,24(sp)
ffffffffc02005f8:	6522                	ld	a0,8(sp)
ffffffffc02005fa:	6105                	addi	sp,sp,32
ffffffffc02005fc:	8082                	ret

ffffffffc02005fe <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005fe:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200600:	00005517          	auipc	a0,0x5
ffffffffc0200604:	61050513          	addi	a0,a0,1552 # ffffffffc0205c10 <commands+0xa8>
void dtb_init(void) {
ffffffffc0200608:	fc86                	sd	ra,120(sp)
ffffffffc020060a:	f8a2                	sd	s0,112(sp)
ffffffffc020060c:	e8d2                	sd	s4,80(sp)
ffffffffc020060e:	f4a6                	sd	s1,104(sp)
ffffffffc0200610:	f0ca                	sd	s2,96(sp)
ffffffffc0200612:	ecce                	sd	s3,88(sp)
ffffffffc0200614:	e4d6                	sd	s5,72(sp)
ffffffffc0200616:	e0da                	sd	s6,64(sp)
ffffffffc0200618:	fc5e                	sd	s7,56(sp)
ffffffffc020061a:	f862                	sd	s8,48(sp)
ffffffffc020061c:	f466                	sd	s9,40(sp)
ffffffffc020061e:	f06a                	sd	s10,32(sp)
ffffffffc0200620:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200622:	b73ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200626:	0000b597          	auipc	a1,0xb
ffffffffc020062a:	9da5b583          	ld	a1,-1574(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc020062e:	00005517          	auipc	a0,0x5
ffffffffc0200632:	5f250513          	addi	a0,a0,1522 # ffffffffc0205c20 <commands+0xb8>
ffffffffc0200636:	b5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020063a:	0000b417          	auipc	s0,0xb
ffffffffc020063e:	9ce40413          	addi	s0,s0,-1586 # ffffffffc020b008 <boot_dtb>
ffffffffc0200642:	600c                	ld	a1,0(s0)
ffffffffc0200644:	00005517          	auipc	a0,0x5
ffffffffc0200648:	5ec50513          	addi	a0,a0,1516 # ffffffffc0205c30 <commands+0xc8>
ffffffffc020064c:	b49ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200650:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200654:	00005517          	auipc	a0,0x5
ffffffffc0200658:	5f450513          	addi	a0,a0,1524 # ffffffffc0205c48 <commands+0xe0>
    if (boot_dtb == 0) {
ffffffffc020065c:	120a0463          	beqz	s4,ffffffffc0200784 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200660:	57f5                	li	a5,-3
ffffffffc0200662:	07fa                	slli	a5,a5,0x1e
ffffffffc0200664:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200668:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066a:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020066e:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200670:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200674:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200678:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067c:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200680:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200684:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200686:	8ec9                	or	a3,a3,a0
ffffffffc0200688:	0087979b          	slliw	a5,a5,0x8
ffffffffc020068c:	1b7d                	addi	s6,s6,-1
ffffffffc020068e:	0167f7b3          	and	a5,a5,s6
ffffffffc0200692:	8dd5                	or	a1,a1,a3
ffffffffc0200694:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200696:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020069a:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc020069c:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe013a9>
ffffffffc02006a0:	10f59163          	bne	a1,a5,ffffffffc02007a2 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02006a4:	471c                	lw	a5,8(a4)
ffffffffc02006a6:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02006a8:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006aa:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006ae:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02006b2:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ba:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006be:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c2:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ca:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ce:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d2:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d4:	01146433          	or	s0,s0,a7
ffffffffc02006d8:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006dc:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006e0:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006e2:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006e6:	8c49                	or	s0,s0,a0
ffffffffc02006e8:	0166f6b3          	and	a3,a3,s6
ffffffffc02006ec:	00ca6a33          	or	s4,s4,a2
ffffffffc02006f0:	0167f7b3          	and	a5,a5,s6
ffffffffc02006f4:	8c55                	or	s0,s0,a3
ffffffffc02006f6:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fa:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006fc:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fe:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200700:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200704:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200706:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200708:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020070c:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020070e:	00005917          	auipc	s2,0x5
ffffffffc0200712:	58a90913          	addi	s2,s2,1418 # ffffffffc0205c98 <commands+0x130>
ffffffffc0200716:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200718:	4d91                	li	s11,4
ffffffffc020071a:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071c:	00005497          	auipc	s1,0x5
ffffffffc0200720:	57448493          	addi	s1,s1,1396 # ffffffffc0205c90 <commands+0x128>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200724:	000a2703          	lw	a4,0(s4)
ffffffffc0200728:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020072c:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200730:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200734:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200738:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073c:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200740:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200742:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200746:	0087171b          	slliw	a4,a4,0x8
ffffffffc020074a:	8fd5                	or	a5,a5,a3
ffffffffc020074c:	00eb7733          	and	a4,s6,a4
ffffffffc0200750:	8fd9                	or	a5,a5,a4
ffffffffc0200752:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200754:	09778c63          	beq	a5,s7,ffffffffc02007ec <dtb_init+0x1ee>
ffffffffc0200758:	00fbea63          	bltu	s7,a5,ffffffffc020076c <dtb_init+0x16e>
ffffffffc020075c:	07a78663          	beq	a5,s10,ffffffffc02007c8 <dtb_init+0x1ca>
ffffffffc0200760:	4709                	li	a4,2
ffffffffc0200762:	00e79763          	bne	a5,a4,ffffffffc0200770 <dtb_init+0x172>
ffffffffc0200766:	4c81                	li	s9,0
ffffffffc0200768:	8a56                	mv	s4,s5
ffffffffc020076a:	bf6d                	j	ffffffffc0200724 <dtb_init+0x126>
ffffffffc020076c:	ffb78ee3          	beq	a5,s11,ffffffffc0200768 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200770:	00005517          	auipc	a0,0x5
ffffffffc0200774:	5a050513          	addi	a0,a0,1440 # ffffffffc0205d10 <commands+0x1a8>
ffffffffc0200778:	a1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	5cc50513          	addi	a0,a0,1484 # ffffffffc0205d48 <commands+0x1e0>
}
ffffffffc0200784:	7446                	ld	s0,112(sp)
ffffffffc0200786:	70e6                	ld	ra,120(sp)
ffffffffc0200788:	74a6                	ld	s1,104(sp)
ffffffffc020078a:	7906                	ld	s2,96(sp)
ffffffffc020078c:	69e6                	ld	s3,88(sp)
ffffffffc020078e:	6a46                	ld	s4,80(sp)
ffffffffc0200790:	6aa6                	ld	s5,72(sp)
ffffffffc0200792:	6b06                	ld	s6,64(sp)
ffffffffc0200794:	7be2                	ld	s7,56(sp)
ffffffffc0200796:	7c42                	ld	s8,48(sp)
ffffffffc0200798:	7ca2                	ld	s9,40(sp)
ffffffffc020079a:	7d02                	ld	s10,32(sp)
ffffffffc020079c:	6de2                	ld	s11,24(sp)
ffffffffc020079e:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02007a0:	bad5                	j	ffffffffc0200194 <cprintf>
}
ffffffffc02007a2:	7446                	ld	s0,112(sp)
ffffffffc02007a4:	70e6                	ld	ra,120(sp)
ffffffffc02007a6:	74a6                	ld	s1,104(sp)
ffffffffc02007a8:	7906                	ld	s2,96(sp)
ffffffffc02007aa:	69e6                	ld	s3,88(sp)
ffffffffc02007ac:	6a46                	ld	s4,80(sp)
ffffffffc02007ae:	6aa6                	ld	s5,72(sp)
ffffffffc02007b0:	6b06                	ld	s6,64(sp)
ffffffffc02007b2:	7be2                	ld	s7,56(sp)
ffffffffc02007b4:	7c42                	ld	s8,48(sp)
ffffffffc02007b6:	7ca2                	ld	s9,40(sp)
ffffffffc02007b8:	7d02                	ld	s10,32(sp)
ffffffffc02007ba:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007bc:	00005517          	auipc	a0,0x5
ffffffffc02007c0:	4ac50513          	addi	a0,a0,1196 # ffffffffc0205c68 <commands+0x100>
}
ffffffffc02007c4:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c6:	b2f9                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c8:	8556                	mv	a0,s5
ffffffffc02007ca:	064050ef          	jal	ra,ffffffffc020582e <strlen>
ffffffffc02007ce:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d0:	4619                	li	a2,6
ffffffffc02007d2:	85a6                	mv	a1,s1
ffffffffc02007d4:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d6:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d8:	0bc050ef          	jal	ra,ffffffffc0205894 <strncmp>
ffffffffc02007dc:	e111                	bnez	a0,ffffffffc02007e0 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc02007de:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007e0:	0a91                	addi	s5,s5,4
ffffffffc02007e2:	9ad2                	add	s5,s5,s4
ffffffffc02007e4:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007e8:	8a56                	mv	s4,s5
ffffffffc02007ea:	bf2d                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007ec:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007f0:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007f4:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02007f8:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007fc:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200800:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200804:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200808:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080c:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200810:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200814:	00eaeab3          	or	s5,s5,a4
ffffffffc0200818:	00fb77b3          	and	a5,s6,a5
ffffffffc020081c:	00faeab3          	or	s5,s5,a5
ffffffffc0200820:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200822:	000c9c63          	bnez	s9,ffffffffc020083a <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200826:	1a82                	slli	s5,s5,0x20
ffffffffc0200828:	00368793          	addi	a5,a3,3
ffffffffc020082c:	020ada93          	srli	s5,s5,0x20
ffffffffc0200830:	9abe                	add	s5,s5,a5
ffffffffc0200832:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200836:	8a56                	mv	s4,s5
ffffffffc0200838:	b5f5                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020083a:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020083e:	85ca                	mv	a1,s2
ffffffffc0200840:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200842:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200846:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020084a:	0187971b          	slliw	a4,a5,0x18
ffffffffc020084e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200852:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200856:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200858:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020085c:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200860:	8d59                	or	a0,a0,a4
ffffffffc0200862:	00fb77b3          	and	a5,s6,a5
ffffffffc0200866:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200868:	1502                	slli	a0,a0,0x20
ffffffffc020086a:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020086c:	9522                	add	a0,a0,s0
ffffffffc020086e:	008050ef          	jal	ra,ffffffffc0205876 <strcmp>
ffffffffc0200872:	66a2                	ld	a3,8(sp)
ffffffffc0200874:	f94d                	bnez	a0,ffffffffc0200826 <dtb_init+0x228>
ffffffffc0200876:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200826 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020087a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020087e:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200882:	00005517          	auipc	a0,0x5
ffffffffc0200886:	41e50513          	addi	a0,a0,1054 # ffffffffc0205ca0 <commands+0x138>
           fdt32_to_cpu(x >> 32);
ffffffffc020088a:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020088e:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200892:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200896:	0187de1b          	srliw	t3,a5,0x18
ffffffffc020089a:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020089e:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008a2:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008a6:	0187d693          	srli	a3,a5,0x18
ffffffffc02008aa:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02008ae:	0087579b          	srliw	a5,a4,0x8
ffffffffc02008b2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b6:	0106561b          	srliw	a2,a2,0x10
ffffffffc02008ba:	010f6f33          	or	t5,t5,a6
ffffffffc02008be:	0187529b          	srliw	t0,a4,0x18
ffffffffc02008c2:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c6:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008ca:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008ce:	0186f6b3          	and	a3,a3,s8
ffffffffc02008d2:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02008d6:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008da:	0107581b          	srliw	a6,a4,0x10
ffffffffc02008de:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008e2:	8361                	srli	a4,a4,0x18
ffffffffc02008e4:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008e8:	0105d59b          	srliw	a1,a1,0x10
ffffffffc02008ec:	01e6e6b3          	or	a3,a3,t5
ffffffffc02008f0:	00cb7633          	and	a2,s6,a2
ffffffffc02008f4:	0088181b          	slliw	a6,a6,0x8
ffffffffc02008f8:	0085959b          	slliw	a1,a1,0x8
ffffffffc02008fc:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200900:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200904:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200908:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020090c:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200910:	011b78b3          	and	a7,s6,a7
ffffffffc0200914:	005eeeb3          	or	t4,t4,t0
ffffffffc0200918:	00c6e733          	or	a4,a3,a2
ffffffffc020091c:	006c6c33          	or	s8,s8,t1
ffffffffc0200920:	010b76b3          	and	a3,s6,a6
ffffffffc0200924:	00bb7b33          	and	s6,s6,a1
ffffffffc0200928:	01d7e7b3          	or	a5,a5,t4
ffffffffc020092c:	016c6b33          	or	s6,s8,s6
ffffffffc0200930:	01146433          	or	s0,s0,a7
ffffffffc0200934:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200936:	1702                	slli	a4,a4,0x20
ffffffffc0200938:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093a:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020093c:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093e:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200940:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200944:	0167eb33          	or	s6,a5,s6
ffffffffc0200948:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020094a:	84bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020094e:	85a2                	mv	a1,s0
ffffffffc0200950:	00005517          	auipc	a0,0x5
ffffffffc0200954:	37050513          	addi	a0,a0,880 # ffffffffc0205cc0 <commands+0x158>
ffffffffc0200958:	83dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020095c:	014b5613          	srli	a2,s6,0x14
ffffffffc0200960:	85da                	mv	a1,s6
ffffffffc0200962:	00005517          	auipc	a0,0x5
ffffffffc0200966:	37650513          	addi	a0,a0,886 # ffffffffc0205cd8 <commands+0x170>
ffffffffc020096a:	82bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020096e:	008b05b3          	add	a1,s6,s0
ffffffffc0200972:	15fd                	addi	a1,a1,-1
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	38450513          	addi	a0,a0,900 # ffffffffc0205cf8 <commands+0x190>
ffffffffc020097c:	819ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	3c850513          	addi	a0,a0,968 # ffffffffc0205d48 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200988:	000de797          	auipc	a5,0xde
ffffffffc020098c:	1487b423          	sd	s0,328(a5) # ffffffffc02dead0 <memory_base>
        memory_size = mem_size;
ffffffffc0200990:	000de797          	auipc	a5,0xde
ffffffffc0200994:	1567b423          	sd	s6,328(a5) # ffffffffc02dead8 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200998:	b3f5                	j	ffffffffc0200784 <dtb_init+0x186>

ffffffffc020099a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020099a:	000de517          	auipc	a0,0xde
ffffffffc020099e:	13653503          	ld	a0,310(a0) # ffffffffc02dead0 <memory_base>
ffffffffc02009a2:	8082                	ret

ffffffffc02009a4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02009a4:	000de517          	auipc	a0,0xde
ffffffffc02009a8:	13453503          	ld	a0,308(a0) # ffffffffc02dead8 <memory_size>
ffffffffc02009ac:	8082                	ret

ffffffffc02009ae <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ae:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009b4:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009b8:	8082                	ret

ffffffffc02009ba <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009ba:	8082                	ret

ffffffffc02009bc <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009bc:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009c0:	00000797          	auipc	a5,0x0
ffffffffc02009c4:	54878793          	addi	a5,a5,1352 # ffffffffc0200f08 <__alltraps>
ffffffffc02009c8:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009cc:	000407b7          	lui	a5,0x40
ffffffffc02009d0:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009d4:	8082                	ret

ffffffffc02009d6 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d6:	610c                	ld	a1,0(a0)
{
ffffffffc02009d8:	1141                	addi	sp,sp,-16
ffffffffc02009da:	e022                	sd	s0,0(sp)
ffffffffc02009dc:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009de:	00005517          	auipc	a0,0x5
ffffffffc02009e2:	38250513          	addi	a0,a0,898 # ffffffffc0205d60 <commands+0x1f8>
{
ffffffffc02009e6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e8:	facff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ec:	640c                	ld	a1,8(s0)
ffffffffc02009ee:	00005517          	auipc	a0,0x5
ffffffffc02009f2:	38a50513          	addi	a0,a0,906 # ffffffffc0205d78 <commands+0x210>
ffffffffc02009f6:	f9eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fa:	680c                	ld	a1,16(s0)
ffffffffc02009fc:	00005517          	auipc	a0,0x5
ffffffffc0200a00:	39450513          	addi	a0,a0,916 # ffffffffc0205d90 <commands+0x228>
ffffffffc0200a04:	f90ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a08:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0a:	00005517          	auipc	a0,0x5
ffffffffc0200a0e:	39e50513          	addi	a0,a0,926 # ffffffffc0205da8 <commands+0x240>
ffffffffc0200a12:	f82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a16:	700c                	ld	a1,32(s0)
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	3a850513          	addi	a0,a0,936 # ffffffffc0205dc0 <commands+0x258>
ffffffffc0200a20:	f74ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a24:	740c                	ld	a1,40(s0)
ffffffffc0200a26:	00005517          	auipc	a0,0x5
ffffffffc0200a2a:	3b250513          	addi	a0,a0,946 # ffffffffc0205dd8 <commands+0x270>
ffffffffc0200a2e:	f66ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a32:	780c                	ld	a1,48(s0)
ffffffffc0200a34:	00005517          	auipc	a0,0x5
ffffffffc0200a38:	3bc50513          	addi	a0,a0,956 # ffffffffc0205df0 <commands+0x288>
ffffffffc0200a3c:	f58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a40:	7c0c                	ld	a1,56(s0)
ffffffffc0200a42:	00005517          	auipc	a0,0x5
ffffffffc0200a46:	3c650513          	addi	a0,a0,966 # ffffffffc0205e08 <commands+0x2a0>
ffffffffc0200a4a:	f4aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4e:	602c                	ld	a1,64(s0)
ffffffffc0200a50:	00005517          	auipc	a0,0x5
ffffffffc0200a54:	3d050513          	addi	a0,a0,976 # ffffffffc0205e20 <commands+0x2b8>
ffffffffc0200a58:	f3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5c:	642c                	ld	a1,72(s0)
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	3da50513          	addi	a0,a0,986 # ffffffffc0205e38 <commands+0x2d0>
ffffffffc0200a66:	f2eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6a:	682c                	ld	a1,80(s0)
ffffffffc0200a6c:	00005517          	auipc	a0,0x5
ffffffffc0200a70:	3e450513          	addi	a0,a0,996 # ffffffffc0205e50 <commands+0x2e8>
ffffffffc0200a74:	f20ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a78:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7a:	00005517          	auipc	a0,0x5
ffffffffc0200a7e:	3ee50513          	addi	a0,a0,1006 # ffffffffc0205e68 <commands+0x300>
ffffffffc0200a82:	f12ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a86:	702c                	ld	a1,96(s0)
ffffffffc0200a88:	00005517          	auipc	a0,0x5
ffffffffc0200a8c:	3f850513          	addi	a0,a0,1016 # ffffffffc0205e80 <commands+0x318>
ffffffffc0200a90:	f04ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a94:	742c                	ld	a1,104(s0)
ffffffffc0200a96:	00005517          	auipc	a0,0x5
ffffffffc0200a9a:	40250513          	addi	a0,a0,1026 # ffffffffc0205e98 <commands+0x330>
ffffffffc0200a9e:	ef6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa2:	782c                	ld	a1,112(s0)
ffffffffc0200aa4:	00005517          	auipc	a0,0x5
ffffffffc0200aa8:	40c50513          	addi	a0,a0,1036 # ffffffffc0205eb0 <commands+0x348>
ffffffffc0200aac:	ee8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab0:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab2:	00005517          	auipc	a0,0x5
ffffffffc0200ab6:	41650513          	addi	a0,a0,1046 # ffffffffc0205ec8 <commands+0x360>
ffffffffc0200aba:	edaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abe:	604c                	ld	a1,128(s0)
ffffffffc0200ac0:	00005517          	auipc	a0,0x5
ffffffffc0200ac4:	42050513          	addi	a0,a0,1056 # ffffffffc0205ee0 <commands+0x378>
ffffffffc0200ac8:	eccff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200acc:	644c                	ld	a1,136(s0)
ffffffffc0200ace:	00005517          	auipc	a0,0x5
ffffffffc0200ad2:	42a50513          	addi	a0,a0,1066 # ffffffffc0205ef8 <commands+0x390>
ffffffffc0200ad6:	ebeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ada:	684c                	ld	a1,144(s0)
ffffffffc0200adc:	00005517          	auipc	a0,0x5
ffffffffc0200ae0:	43450513          	addi	a0,a0,1076 # ffffffffc0205f10 <commands+0x3a8>
ffffffffc0200ae4:	eb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae8:	6c4c                	ld	a1,152(s0)
ffffffffc0200aea:	00005517          	auipc	a0,0x5
ffffffffc0200aee:	43e50513          	addi	a0,a0,1086 # ffffffffc0205f28 <commands+0x3c0>
ffffffffc0200af2:	ea2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af6:	704c                	ld	a1,160(s0)
ffffffffc0200af8:	00005517          	auipc	a0,0x5
ffffffffc0200afc:	44850513          	addi	a0,a0,1096 # ffffffffc0205f40 <commands+0x3d8>
ffffffffc0200b00:	e94ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b04:	744c                	ld	a1,168(s0)
ffffffffc0200b06:	00005517          	auipc	a0,0x5
ffffffffc0200b0a:	45250513          	addi	a0,a0,1106 # ffffffffc0205f58 <commands+0x3f0>
ffffffffc0200b0e:	e86ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b12:	784c                	ld	a1,176(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	45c50513          	addi	a0,a0,1116 # ffffffffc0205f70 <commands+0x408>
ffffffffc0200b1c:	e78ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b20:	7c4c                	ld	a1,184(s0)
ffffffffc0200b22:	00005517          	auipc	a0,0x5
ffffffffc0200b26:	46650513          	addi	a0,a0,1126 # ffffffffc0205f88 <commands+0x420>
ffffffffc0200b2a:	e6aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2e:	606c                	ld	a1,192(s0)
ffffffffc0200b30:	00005517          	auipc	a0,0x5
ffffffffc0200b34:	47050513          	addi	a0,a0,1136 # ffffffffc0205fa0 <commands+0x438>
ffffffffc0200b38:	e5cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3c:	646c                	ld	a1,200(s0)
ffffffffc0200b3e:	00005517          	auipc	a0,0x5
ffffffffc0200b42:	47a50513          	addi	a0,a0,1146 # ffffffffc0205fb8 <commands+0x450>
ffffffffc0200b46:	e4eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4a:	686c                	ld	a1,208(s0)
ffffffffc0200b4c:	00005517          	auipc	a0,0x5
ffffffffc0200b50:	48450513          	addi	a0,a0,1156 # ffffffffc0205fd0 <commands+0x468>
ffffffffc0200b54:	e40ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b58:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5a:	00005517          	auipc	a0,0x5
ffffffffc0200b5e:	48e50513          	addi	a0,a0,1166 # ffffffffc0205fe8 <commands+0x480>
ffffffffc0200b62:	e32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b66:	706c                	ld	a1,224(s0)
ffffffffc0200b68:	00005517          	auipc	a0,0x5
ffffffffc0200b6c:	49850513          	addi	a0,a0,1176 # ffffffffc0206000 <commands+0x498>
ffffffffc0200b70:	e24ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b74:	746c                	ld	a1,232(s0)
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	4a250513          	addi	a0,a0,1186 # ffffffffc0206018 <commands+0x4b0>
ffffffffc0200b7e:	e16ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b82:	786c                	ld	a1,240(s0)
ffffffffc0200b84:	00005517          	auipc	a0,0x5
ffffffffc0200b88:	4ac50513          	addi	a0,a0,1196 # ffffffffc0206030 <commands+0x4c8>
ffffffffc0200b8c:	e08ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b92:	6402                	ld	s0,0(sp)
ffffffffc0200b94:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	4b250513          	addi	a0,a0,1202 # ffffffffc0206048 <commands+0x4e0>
}
ffffffffc0200b9e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ba0:	df4ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200ba4 <print_trapframe>:
{
ffffffffc0200ba4:	1141                	addi	sp,sp,-16
ffffffffc0200ba6:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba8:	85aa                	mv	a1,a0
{
ffffffffc0200baa:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bac:	00005517          	auipc	a0,0x5
ffffffffc0200bb0:	4b450513          	addi	a0,a0,1204 # ffffffffc0206060 <commands+0x4f8>
{
ffffffffc0200bb4:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb6:	ddeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bba:	8522                	mv	a0,s0
ffffffffc0200bbc:	e1bff0ef          	jal	ra,ffffffffc02009d6 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bc0:	10043583          	ld	a1,256(s0)
ffffffffc0200bc4:	00005517          	auipc	a0,0x5
ffffffffc0200bc8:	4b450513          	addi	a0,a0,1204 # ffffffffc0206078 <commands+0x510>
ffffffffc0200bcc:	dc8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd0:	10843583          	ld	a1,264(s0)
ffffffffc0200bd4:	00005517          	auipc	a0,0x5
ffffffffc0200bd8:	4bc50513          	addi	a0,a0,1212 # ffffffffc0206090 <commands+0x528>
ffffffffc0200bdc:	db8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be0:	11043583          	ld	a1,272(s0)
ffffffffc0200be4:	00005517          	auipc	a0,0x5
ffffffffc0200be8:	4c450513          	addi	a0,a0,1220 # ffffffffc02060a8 <commands+0x540>
ffffffffc0200bec:	da8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf4:	6402                	ld	s0,0(sp)
ffffffffc0200bf6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	4c050513          	addi	a0,a0,1216 # ffffffffc02060b8 <commands+0x550>
}
ffffffffc0200c00:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c02:	d92ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200c06 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c06:	11853783          	ld	a5,280(a0)
ffffffffc0200c0a:	472d                	li	a4,11
ffffffffc0200c0c:	0786                	slli	a5,a5,0x1
ffffffffc0200c0e:	8385                	srli	a5,a5,0x1
ffffffffc0200c10:	08f76c63          	bltu	a4,a5,ffffffffc0200ca8 <interrupt_handler+0xa2>
ffffffffc0200c14:	00005717          	auipc	a4,0x5
ffffffffc0200c18:	56c70713          	addi	a4,a4,1388 # ffffffffc0206180 <commands+0x618>
ffffffffc0200c1c:	078a                	slli	a5,a5,0x2
ffffffffc0200c1e:	97ba                	add	a5,a5,a4
ffffffffc0200c20:	439c                	lw	a5,0(a5)
ffffffffc0200c22:	97ba                	add	a5,a5,a4
ffffffffc0200c24:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c26:	00005517          	auipc	a0,0x5
ffffffffc0200c2a:	50a50513          	addi	a0,a0,1290 # ffffffffc0206130 <commands+0x5c8>
ffffffffc0200c2e:	d66ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c32:	00005517          	auipc	a0,0x5
ffffffffc0200c36:	4de50513          	addi	a0,a0,1246 # ffffffffc0206110 <commands+0x5a8>
ffffffffc0200c3a:	d5aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	49250513          	addi	a0,a0,1170 # ffffffffc02060d0 <commands+0x568>
ffffffffc0200c46:	d4eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c4a:	00005517          	auipc	a0,0x5
ffffffffc0200c4e:	4a650513          	addi	a0,a0,1190 # ffffffffc02060f0 <commands+0x588>
ffffffffc0200c52:	d42ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200c56:	1141                	addi	sp,sp,-16
ffffffffc0200c58:	e406                	sd	ra,8(sp)
ffffffffc0200c5a:	e022                	sd	s0,0(sp)
        /*(1)设置下次时钟中断- clock_set_next_event()
         *(2)计数器（ticks）加一
         *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
         * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
         */
        clock_set_next_event();
ffffffffc0200c5c:	917ff0ef          	jal	ra,ffffffffc0200572 <clock_set_next_event>
        ticks++;
ffffffffc0200c60:	000de797          	auipc	a5,0xde
ffffffffc0200c64:	e6078793          	addi	a5,a5,-416 # ffffffffc02deac0 <ticks>
ffffffffc0200c68:	6398                	ld	a4,0(a5)
ffffffffc0200c6a:	0705                	addi	a4,a4,1
ffffffffc0200c6c:	e398                	sd	a4,0(a5)
        if (ticks % TICK_NUM == 0 && current) {
ffffffffc0200c6e:	639c                	ld	a5,0(a5)
ffffffffc0200c70:	06400713          	li	a4,100
ffffffffc0200c74:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200c78:	cb8d                	beqz	a5,ffffffffc0200caa <interrupt_handler+0xa4>
            print_ticks();
            current->need_resched = 1;
            num++;
        }
        if (num == 10) {
ffffffffc0200c7a:	000de797          	auipc	a5,0xde
ffffffffc0200c7e:	e667b783          	ld	a5,-410(a5) # ffffffffc02deae0 <num>
ffffffffc0200c82:	4729                	li	a4,10
ffffffffc0200c84:	00e79863          	bne	a5,a4,ffffffffc0200c94 <interrupt_handler+0x8e>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200c88:	4501                	li	a0,0
ffffffffc0200c8a:	4581                	li	a1,0
ffffffffc0200c8c:	4601                	li	a2,0
ffffffffc0200c8e:	48a1                	li	a7,8
ffffffffc0200c90:	00000073          	ecall
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c94:	60a2                	ld	ra,8(sp)
ffffffffc0200c96:	6402                	ld	s0,0(sp)
ffffffffc0200c98:	0141                	addi	sp,sp,16
ffffffffc0200c9a:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c9c:	00005517          	auipc	a0,0x5
ffffffffc0200ca0:	4c450513          	addi	a0,a0,1220 # ffffffffc0206160 <commands+0x5f8>
ffffffffc0200ca4:	cf0ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200ca8:	bdf5                	j	ffffffffc0200ba4 <print_trapframe>
        if (ticks % TICK_NUM == 0 && current) {
ffffffffc0200caa:	000de417          	auipc	s0,0xde
ffffffffc0200cae:	e7e40413          	addi	s0,s0,-386 # ffffffffc02deb28 <current>
ffffffffc0200cb2:	601c                	ld	a5,0(s0)
ffffffffc0200cb4:	d3f9                	beqz	a5,ffffffffc0200c7a <interrupt_handler+0x74>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200cb6:	06400593          	li	a1,100
ffffffffc0200cba:	00005517          	auipc	a0,0x5
ffffffffc0200cbe:	49650513          	addi	a0,a0,1174 # ffffffffc0206150 <commands+0x5e8>
ffffffffc0200cc2:	cd2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
            num++;
ffffffffc0200cc6:	000de717          	auipc	a4,0xde
ffffffffc0200cca:	e1a70713          	addi	a4,a4,-486 # ffffffffc02deae0 <num>
ffffffffc0200cce:	631c                	ld	a5,0(a4)
            current->need_resched = 1;
ffffffffc0200cd0:	6014                	ld	a3,0(s0)
ffffffffc0200cd2:	4605                	li	a2,1
            num++;
ffffffffc0200cd4:	0785                	addi	a5,a5,1
            current->need_resched = 1;
ffffffffc0200cd6:	ee90                	sd	a2,24(a3)
            num++;
ffffffffc0200cd8:	e31c                	sd	a5,0(a4)
ffffffffc0200cda:	b765                	j	ffffffffc0200c82 <interrupt_handler+0x7c>

ffffffffc0200cdc <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200cdc:	11853583          	ld	a1,280(a0)
{
ffffffffc0200ce0:	1101                	addi	sp,sp,-32
ffffffffc0200ce2:	e822                	sd	s0,16(sp)
ffffffffc0200ce4:	ec06                	sd	ra,24(sp)
ffffffffc0200ce6:	e426                	sd	s1,8(sp)
ffffffffc0200ce8:	e04a                	sd	s2,0(sp)
ffffffffc0200cea:	47bd                	li	a5,15
ffffffffc0200cec:	842a                	mv	s0,a0
ffffffffc0200cee:	10b7e763          	bltu	a5,a1,ffffffffc0200dfc <exception_handler+0x120>
ffffffffc0200cf2:	00005697          	auipc	a3,0x5
ffffffffc0200cf6:	66e68693          	addi	a3,a3,1646 # ffffffffc0206360 <commands+0x7f8>
ffffffffc0200cfa:	00259713          	slli	a4,a1,0x2
ffffffffc0200cfe:	9736                	add	a4,a4,a3
ffffffffc0200d00:	431c                	lw	a5,0(a4)
ffffffffc0200d02:	97b6                	add	a5,a5,a3
ffffffffc0200d04:	8782                	jr	a5
        break;
    case CAUSE_FETCH_PAGE_FAULT:
    case CAUSE_LOAD_PAGE_FAULT:
    case CAUSE_STORE_PAGE_FAULT:
        {
            if (current == NULL || current->mm == NULL)
ffffffffc0200d06:	000de917          	auipc	s2,0xde
ffffffffc0200d0a:	e2290913          	addi	s2,s2,-478 # ffffffffc02deb28 <current>
ffffffffc0200d0e:	00093783          	ld	a5,0(s2)
            {
                cprintf("page fault at 0x%08x: no memory management\n", tf->tval);
                print_trapframe(tf);
                goto bad_pgfault;
            }
            uintptr_t addr = tf->tval;
ffffffffc0200d12:	11053483          	ld	s1,272(a0)
            if (current == NULL || current->mm == NULL)
ffffffffc0200d16:	10078663          	beqz	a5,ffffffffc0200e22 <exception_handler+0x146>
ffffffffc0200d1a:	7788                	ld	a0,40(a5)
ffffffffc0200d1c:	10050363          	beqz	a0,ffffffffc0200e22 <exception_handler+0x146>
            // we set P=0 (not present) for normal faults, but do_pgfault will check if PTE exists
            uint32_t error_code = 0;
            if (tf->cause == CAUSE_STORE_PAGE_FAULT) {
                error_code = 0x2; // Write, not present (0b010) - bit 1=write, bit 0=not present
            } else if (tf->cause == CAUSE_LOAD_PAGE_FAULT) {
                error_code = 0x0; // Read, not present (0b000) - bit 1=read, bit 0=not present  
ffffffffc0200d20:	15c5                	addi	a1,a1,-15
ffffffffc0200d22:	0015b593          	seqz	a1,a1
            } else if (tf->cause == CAUSE_FETCH_PAGE_FAULT) {
                error_code = 0x0; // Fetch, not present (0b000) - treated as read
            }
            ret = do_pgfault(current->mm, error_code, addr);
ffffffffc0200d26:	8626                	mv	a2,s1
ffffffffc0200d28:	0586                	slli	a1,a1,0x1
ffffffffc0200d2a:	20d020ef          	jal	ra,ffffffffc0203736 <do_pgfault>
            if (ret != 0)
ffffffffc0200d2e:	12051063          	bnez	a0,ffffffffc0200e4e <exception_handler+0x172>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200d32:	60e2                	ld	ra,24(sp)
ffffffffc0200d34:	6442                	ld	s0,16(sp)
ffffffffc0200d36:	64a2                	ld	s1,8(sp)
ffffffffc0200d38:	6902                	ld	s2,0(sp)
ffffffffc0200d3a:	6105                	addi	sp,sp,32
ffffffffc0200d3c:	8082                	ret
        cprintf("Environment call from S-mode\n");
ffffffffc0200d3e:	00005517          	auipc	a0,0x5
ffffffffc0200d42:	55a50513          	addi	a0,a0,1370 # ffffffffc0206298 <commands+0x730>
ffffffffc0200d46:	c4eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200d4a:	10843783          	ld	a5,264(s0)
}
ffffffffc0200d4e:	60e2                	ld	ra,24(sp)
ffffffffc0200d50:	64a2                	ld	s1,8(sp)
        tf->epc += 4;
ffffffffc0200d52:	0791                	addi	a5,a5,4
ffffffffc0200d54:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200d58:	6442                	ld	s0,16(sp)
ffffffffc0200d5a:	6902                	ld	s2,0(sp)
ffffffffc0200d5c:	6105                	addi	sp,sp,32
        syscall();
ffffffffc0200d5e:	64c0406f          	j	ffffffffc02053aa <syscall>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d62:	00005517          	auipc	a0,0x5
ffffffffc0200d66:	44e50513          	addi	a0,a0,1102 # ffffffffc02061b0 <commands+0x648>
}
ffffffffc0200d6a:	6442                	ld	s0,16(sp)
ffffffffc0200d6c:	60e2                	ld	ra,24(sp)
ffffffffc0200d6e:	64a2                	ld	s1,8(sp)
ffffffffc0200d70:	6902                	ld	s2,0(sp)
ffffffffc0200d72:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200d74:	c20ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200d78:	00005517          	auipc	a0,0x5
ffffffffc0200d7c:	45850513          	addi	a0,a0,1112 # ffffffffc02061d0 <commands+0x668>
ffffffffc0200d80:	b7ed                	j	ffffffffc0200d6a <exception_handler+0x8e>
        cprintf("Illegal instruction\n");
ffffffffc0200d82:	00005517          	auipc	a0,0x5
ffffffffc0200d86:	46e50513          	addi	a0,a0,1134 # ffffffffc02061f0 <commands+0x688>
ffffffffc0200d8a:	b7c5                	j	ffffffffc0200d6a <exception_handler+0x8e>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d8c:	00005517          	auipc	a0,0x5
ffffffffc0200d90:	54c50513          	addi	a0,a0,1356 # ffffffffc02062d8 <commands+0x770>
ffffffffc0200d94:	bfd9                	j	ffffffffc0200d6a <exception_handler+0x8e>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d96:	00005517          	auipc	a0,0x5
ffffffffc0200d9a:	52250513          	addi	a0,a0,1314 # ffffffffc02062b8 <commands+0x750>
ffffffffc0200d9e:	b7f1                	j	ffffffffc0200d6a <exception_handler+0x8e>
        cprintf("Store/AMO access fault\n");
ffffffffc0200da0:	00005517          	auipc	a0,0x5
ffffffffc0200da4:	4e050513          	addi	a0,a0,1248 # ffffffffc0206280 <commands+0x718>
ffffffffc0200da8:	b7c9                	j	ffffffffc0200d6a <exception_handler+0x8e>
        cprintf("Breakpoint\n");
ffffffffc0200daa:	00005517          	auipc	a0,0x5
ffffffffc0200dae:	45e50513          	addi	a0,a0,1118 # ffffffffc0206208 <commands+0x6a0>
ffffffffc0200db2:	be2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200db6:	6458                	ld	a4,136(s0)
ffffffffc0200db8:	47a9                	li	a5,10
ffffffffc0200dba:	f6f71ce3          	bne	a4,a5,ffffffffc0200d32 <exception_handler+0x56>
            tf->epc += 4;
ffffffffc0200dbe:	10843783          	ld	a5,264(s0)
ffffffffc0200dc2:	0791                	addi	a5,a5,4
ffffffffc0200dc4:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200dc8:	5e2040ef          	jal	ra,ffffffffc02053aa <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dcc:	000de797          	auipc	a5,0xde
ffffffffc0200dd0:	d5c7b783          	ld	a5,-676(a5) # ffffffffc02deb28 <current>
ffffffffc0200dd4:	6b9c                	ld	a5,16(a5)
ffffffffc0200dd6:	8522                	mv	a0,s0
}
ffffffffc0200dd8:	6442                	ld	s0,16(sp)
ffffffffc0200dda:	60e2                	ld	ra,24(sp)
ffffffffc0200ddc:	64a2                	ld	s1,8(sp)
ffffffffc0200dde:	6902                	ld	s2,0(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200de0:	6589                	lui	a1,0x2
ffffffffc0200de2:	95be                	add	a1,a1,a5
}
ffffffffc0200de4:	6105                	addi	sp,sp,32
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200de6:	aac5                	j	ffffffffc0200fd6 <kernel_execve_ret>
        cprintf("Load address misaligned\n");
ffffffffc0200de8:	00005517          	auipc	a0,0x5
ffffffffc0200dec:	43050513          	addi	a0,a0,1072 # ffffffffc0206218 <commands+0x6b0>
ffffffffc0200df0:	bfad                	j	ffffffffc0200d6a <exception_handler+0x8e>
        cprintf("Load access fault\n");
ffffffffc0200df2:	00005517          	auipc	a0,0x5
ffffffffc0200df6:	44650513          	addi	a0,a0,1094 # ffffffffc0206238 <commands+0x6d0>
ffffffffc0200dfa:	bf85                	j	ffffffffc0200d6a <exception_handler+0x8e>
        print_trapframe(tf);
ffffffffc0200dfc:	8522                	mv	a0,s0
}
ffffffffc0200dfe:	6442                	ld	s0,16(sp)
ffffffffc0200e00:	60e2                	ld	ra,24(sp)
ffffffffc0200e02:	64a2                	ld	s1,8(sp)
ffffffffc0200e04:	6902                	ld	s2,0(sp)
ffffffffc0200e06:	6105                	addi	sp,sp,32
        print_trapframe(tf);
ffffffffc0200e08:	bb71                	j	ffffffffc0200ba4 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200e0a:	00005617          	auipc	a2,0x5
ffffffffc0200e0e:	44660613          	addi	a2,a2,1094 # ffffffffc0206250 <commands+0x6e8>
ffffffffc0200e12:	0c400593          	li	a1,196
ffffffffc0200e16:	00005517          	auipc	a0,0x5
ffffffffc0200e1a:	45250513          	addi	a0,a0,1106 # ffffffffc0206268 <commands+0x700>
ffffffffc0200e1e:	e70ff0ef          	jal	ra,ffffffffc020048e <__panic>
                cprintf("page fault at 0x%08x: no memory management\n", tf->tval);
ffffffffc0200e22:	85a6                	mv	a1,s1
ffffffffc0200e24:	00005517          	auipc	a0,0x5
ffffffffc0200e28:	4d450513          	addi	a0,a0,1236 # ffffffffc02062f8 <commands+0x790>
ffffffffc0200e2c:	b68ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
                print_trapframe(tf);
ffffffffc0200e30:	8522                	mv	a0,s0
ffffffffc0200e32:	d73ff0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
                panic("unhandled page fault.\n");
ffffffffc0200e36:	00005617          	auipc	a2,0x5
ffffffffc0200e3a:	51260613          	addi	a2,a2,1298 # ffffffffc0206348 <commands+0x7e0>
ffffffffc0200e3e:	0fc00593          	li	a1,252
ffffffffc0200e42:	00005517          	auipc	a0,0x5
ffffffffc0200e46:	42650513          	addi	a0,a0,1062 # ffffffffc0206268 <commands+0x700>
ffffffffc0200e4a:	e44ff0ef          	jal	ra,ffffffffc020048e <__panic>
                cprintf("page fault at 0x%08x: %e\n", addr, ret);
ffffffffc0200e4e:	862a                	mv	a2,a0
ffffffffc0200e50:	85a6                	mv	a1,s1
ffffffffc0200e52:	00005517          	auipc	a0,0x5
ffffffffc0200e56:	4d650513          	addi	a0,a0,1238 # ffffffffc0206328 <commands+0x7c0>
ffffffffc0200e5a:	b3aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
                if (current == NULL || !trap_in_kernel(tf))
ffffffffc0200e5e:	00093783          	ld	a5,0(s2)
ffffffffc0200e62:	c791                	beqz	a5,ffffffffc0200e6e <exception_handler+0x192>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e64:	10043783          	ld	a5,256(s0)
ffffffffc0200e68:	1007f793          	andi	a5,a5,256
                if (current == NULL || !trap_in_kernel(tf))
ffffffffc0200e6c:	e781                	bnez	a5,ffffffffc0200e74 <exception_handler+0x198>
                    do_exit(-E_KILLED);
ffffffffc0200e6e:	555d                	li	a0,-9
ffffffffc0200e70:	7a4030ef          	jal	ra,ffffffffc0204614 <do_exit>
                print_trapframe(tf);
ffffffffc0200e74:	8522                	mv	a0,s0
ffffffffc0200e76:	d2fff0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
ffffffffc0200e7a:	bf75                	j	ffffffffc0200e36 <exception_handler+0x15a>

ffffffffc0200e7c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200e7c:	1101                	addi	sp,sp,-32
ffffffffc0200e7e:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200e80:	000de417          	auipc	s0,0xde
ffffffffc0200e84:	ca840413          	addi	s0,s0,-856 # ffffffffc02deb28 <current>
ffffffffc0200e88:	6018                	ld	a4,0(s0)
{
ffffffffc0200e8a:	ec06                	sd	ra,24(sp)
ffffffffc0200e8c:	e426                	sd	s1,8(sp)
ffffffffc0200e8e:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e90:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200e94:	cf1d                	beqz	a4,ffffffffc0200ed2 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e96:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200e9a:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200e9e:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200ea0:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200ea4:	0206c463          	bltz	a3,ffffffffc0200ecc <trap+0x50>
        exception_handler(tf);
ffffffffc0200ea8:	e35ff0ef          	jal	ra,ffffffffc0200cdc <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200eac:	601c                	ld	a5,0(s0)
ffffffffc0200eae:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200eb2:	e499                	bnez	s1,ffffffffc0200ec0 <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200eb4:	0b07a703          	lw	a4,176(a5)
ffffffffc0200eb8:	8b05                	andi	a4,a4,1
ffffffffc0200eba:	e329                	bnez	a4,ffffffffc0200efc <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200ebc:	6f9c                	ld	a5,24(a5)
ffffffffc0200ebe:	eb85                	bnez	a5,ffffffffc0200eee <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200ec0:	60e2                	ld	ra,24(sp)
ffffffffc0200ec2:	6442                	ld	s0,16(sp)
ffffffffc0200ec4:	64a2                	ld	s1,8(sp)
ffffffffc0200ec6:	6902                	ld	s2,0(sp)
ffffffffc0200ec8:	6105                	addi	sp,sp,32
ffffffffc0200eca:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200ecc:	d3bff0ef          	jal	ra,ffffffffc0200c06 <interrupt_handler>
ffffffffc0200ed0:	bff1                	j	ffffffffc0200eac <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200ed2:	0006c863          	bltz	a3,ffffffffc0200ee2 <trap+0x66>
}
ffffffffc0200ed6:	6442                	ld	s0,16(sp)
ffffffffc0200ed8:	60e2                	ld	ra,24(sp)
ffffffffc0200eda:	64a2                	ld	s1,8(sp)
ffffffffc0200edc:	6902                	ld	s2,0(sp)
ffffffffc0200ede:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200ee0:	bbf5                	j	ffffffffc0200cdc <exception_handler>
}
ffffffffc0200ee2:	6442                	ld	s0,16(sp)
ffffffffc0200ee4:	60e2                	ld	ra,24(sp)
ffffffffc0200ee6:	64a2                	ld	s1,8(sp)
ffffffffc0200ee8:	6902                	ld	s2,0(sp)
ffffffffc0200eea:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200eec:	bb29                	j	ffffffffc0200c06 <interrupt_handler>
}
ffffffffc0200eee:	6442                	ld	s0,16(sp)
ffffffffc0200ef0:	60e2                	ld	ra,24(sp)
ffffffffc0200ef2:	64a2                	ld	s1,8(sp)
ffffffffc0200ef4:	6902                	ld	s2,0(sp)
ffffffffc0200ef6:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200ef8:	3c60406f          	j	ffffffffc02052be <schedule>
                do_exit(-E_KILLED);
ffffffffc0200efc:	555d                	li	a0,-9
ffffffffc0200efe:	716030ef          	jal	ra,ffffffffc0204614 <do_exit>
            if (current->need_resched)
ffffffffc0200f02:	601c                	ld	a5,0(s0)
ffffffffc0200f04:	bf65                	j	ffffffffc0200ebc <trap+0x40>
	...

ffffffffc0200f08 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200f08:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200f0c:	00011463          	bnez	sp,ffffffffc0200f14 <__alltraps+0xc>
ffffffffc0200f10:	14002173          	csrr	sp,sscratch
ffffffffc0200f14:	712d                	addi	sp,sp,-288
ffffffffc0200f16:	e002                	sd	zero,0(sp)
ffffffffc0200f18:	e406                	sd	ra,8(sp)
ffffffffc0200f1a:	ec0e                	sd	gp,24(sp)
ffffffffc0200f1c:	f012                	sd	tp,32(sp)
ffffffffc0200f1e:	f416                	sd	t0,40(sp)
ffffffffc0200f20:	f81a                	sd	t1,48(sp)
ffffffffc0200f22:	fc1e                	sd	t2,56(sp)
ffffffffc0200f24:	e0a2                	sd	s0,64(sp)
ffffffffc0200f26:	e4a6                	sd	s1,72(sp)
ffffffffc0200f28:	e8aa                	sd	a0,80(sp)
ffffffffc0200f2a:	ecae                	sd	a1,88(sp)
ffffffffc0200f2c:	f0b2                	sd	a2,96(sp)
ffffffffc0200f2e:	f4b6                	sd	a3,104(sp)
ffffffffc0200f30:	f8ba                	sd	a4,112(sp)
ffffffffc0200f32:	fcbe                	sd	a5,120(sp)
ffffffffc0200f34:	e142                	sd	a6,128(sp)
ffffffffc0200f36:	e546                	sd	a7,136(sp)
ffffffffc0200f38:	e94a                	sd	s2,144(sp)
ffffffffc0200f3a:	ed4e                	sd	s3,152(sp)
ffffffffc0200f3c:	f152                	sd	s4,160(sp)
ffffffffc0200f3e:	f556                	sd	s5,168(sp)
ffffffffc0200f40:	f95a                	sd	s6,176(sp)
ffffffffc0200f42:	fd5e                	sd	s7,184(sp)
ffffffffc0200f44:	e1e2                	sd	s8,192(sp)
ffffffffc0200f46:	e5e6                	sd	s9,200(sp)
ffffffffc0200f48:	e9ea                	sd	s10,208(sp)
ffffffffc0200f4a:	edee                	sd	s11,216(sp)
ffffffffc0200f4c:	f1f2                	sd	t3,224(sp)
ffffffffc0200f4e:	f5f6                	sd	t4,232(sp)
ffffffffc0200f50:	f9fa                	sd	t5,240(sp)
ffffffffc0200f52:	fdfe                	sd	t6,248(sp)
ffffffffc0200f54:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200f58:	100024f3          	csrr	s1,sstatus
ffffffffc0200f5c:	14102973          	csrr	s2,sepc
ffffffffc0200f60:	143029f3          	csrr	s3,stval
ffffffffc0200f64:	14202a73          	csrr	s4,scause
ffffffffc0200f68:	e822                	sd	s0,16(sp)
ffffffffc0200f6a:	e226                	sd	s1,256(sp)
ffffffffc0200f6c:	e64a                	sd	s2,264(sp)
ffffffffc0200f6e:	ea4e                	sd	s3,272(sp)
ffffffffc0200f70:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200f72:	850a                	mv	a0,sp
    jal trap
ffffffffc0200f74:	f09ff0ef          	jal	ra,ffffffffc0200e7c <trap>

ffffffffc0200f78 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200f78:	6492                	ld	s1,256(sp)
ffffffffc0200f7a:	6932                	ld	s2,264(sp)
ffffffffc0200f7c:	1004f413          	andi	s0,s1,256
ffffffffc0200f80:	e401                	bnez	s0,ffffffffc0200f88 <__trapret+0x10>
ffffffffc0200f82:	1200                	addi	s0,sp,288
ffffffffc0200f84:	14041073          	csrw	sscratch,s0
ffffffffc0200f88:	10049073          	csrw	sstatus,s1
ffffffffc0200f8c:	14191073          	csrw	sepc,s2
ffffffffc0200f90:	60a2                	ld	ra,8(sp)
ffffffffc0200f92:	61e2                	ld	gp,24(sp)
ffffffffc0200f94:	7202                	ld	tp,32(sp)
ffffffffc0200f96:	72a2                	ld	t0,40(sp)
ffffffffc0200f98:	7342                	ld	t1,48(sp)
ffffffffc0200f9a:	73e2                	ld	t2,56(sp)
ffffffffc0200f9c:	6406                	ld	s0,64(sp)
ffffffffc0200f9e:	64a6                	ld	s1,72(sp)
ffffffffc0200fa0:	6546                	ld	a0,80(sp)
ffffffffc0200fa2:	65e6                	ld	a1,88(sp)
ffffffffc0200fa4:	7606                	ld	a2,96(sp)
ffffffffc0200fa6:	76a6                	ld	a3,104(sp)
ffffffffc0200fa8:	7746                	ld	a4,112(sp)
ffffffffc0200faa:	77e6                	ld	a5,120(sp)
ffffffffc0200fac:	680a                	ld	a6,128(sp)
ffffffffc0200fae:	68aa                	ld	a7,136(sp)
ffffffffc0200fb0:	694a                	ld	s2,144(sp)
ffffffffc0200fb2:	69ea                	ld	s3,152(sp)
ffffffffc0200fb4:	7a0a                	ld	s4,160(sp)
ffffffffc0200fb6:	7aaa                	ld	s5,168(sp)
ffffffffc0200fb8:	7b4a                	ld	s6,176(sp)
ffffffffc0200fba:	7bea                	ld	s7,184(sp)
ffffffffc0200fbc:	6c0e                	ld	s8,192(sp)
ffffffffc0200fbe:	6cae                	ld	s9,200(sp)
ffffffffc0200fc0:	6d4e                	ld	s10,208(sp)
ffffffffc0200fc2:	6dee                	ld	s11,216(sp)
ffffffffc0200fc4:	7e0e                	ld	t3,224(sp)
ffffffffc0200fc6:	7eae                	ld	t4,232(sp)
ffffffffc0200fc8:	7f4e                	ld	t5,240(sp)
ffffffffc0200fca:	7fee                	ld	t6,248(sp)
ffffffffc0200fcc:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200fce:	10200073          	sret

ffffffffc0200fd2 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200fd2:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200fd4:	b755                	j	ffffffffc0200f78 <__trapret>

ffffffffc0200fd6 <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200fd6:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cc0>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200fda:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200fde:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200fe2:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200fe6:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200fea:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200fee:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200ff2:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200ff6:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200ffa:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200ffc:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200ffe:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0201000:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0201002:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0201004:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0201006:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0201008:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc020100a:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc020100c:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc020100e:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0201010:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0201012:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0201014:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0201016:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0201018:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc020101a:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc020101c:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc020101e:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0201020:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0201022:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0201024:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0201026:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0201028:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc020102a:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc020102c:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc020102e:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0201030:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0201032:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0201034:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0201036:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0201038:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc020103a:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc020103c:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc020103e:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0201040:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0201042:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0201044:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0201046:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0201048:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc020104a:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc020104c:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc020104e:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0201050:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0201052:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0201054:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0201056:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0201058:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc020105a:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc020105c:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc020105e:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0201060:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0201062:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0201064:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0201066:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0201068:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc020106a:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc020106c:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc020106e:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0201070:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0201072:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0201074:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0201076:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0201078:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc020107a:	812e                	mv	sp,a1
ffffffffc020107c:	bdf5                	j	ffffffffc0200f78 <__trapret>

ffffffffc020107e <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc020107e:	000da797          	auipc	a5,0xda
ffffffffc0201082:	a1278793          	addi	a5,a5,-1518 # ffffffffc02daa90 <free_area>
ffffffffc0201086:	e79c                	sd	a5,8(a5)
ffffffffc0201088:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc020108a:	0007a823          	sw	zero,16(a5)
}
ffffffffc020108e:	8082                	ret

ffffffffc0201090 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0201090:	000da517          	auipc	a0,0xda
ffffffffc0201094:	a1056503          	lwu	a0,-1520(a0) # ffffffffc02daaa0 <free_area+0x10>
ffffffffc0201098:	8082                	ret

ffffffffc020109a <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc020109a:	715d                	addi	sp,sp,-80
ffffffffc020109c:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc020109e:	000da417          	auipc	s0,0xda
ffffffffc02010a2:	9f240413          	addi	s0,s0,-1550 # ffffffffc02daa90 <free_area>
ffffffffc02010a6:	641c                	ld	a5,8(s0)
ffffffffc02010a8:	e486                	sd	ra,72(sp)
ffffffffc02010aa:	fc26                	sd	s1,56(sp)
ffffffffc02010ac:	f84a                	sd	s2,48(sp)
ffffffffc02010ae:	f44e                	sd	s3,40(sp)
ffffffffc02010b0:	f052                	sd	s4,32(sp)
ffffffffc02010b2:	ec56                	sd	s5,24(sp)
ffffffffc02010b4:	e85a                	sd	s6,16(sp)
ffffffffc02010b6:	e45e                	sd	s7,8(sp)
ffffffffc02010b8:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02010ba:	2a878d63          	beq	a5,s0,ffffffffc0201374 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc02010be:	4481                	li	s1,0
ffffffffc02010c0:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02010c2:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02010c6:	8b09                	andi	a4,a4,2
ffffffffc02010c8:	2a070a63          	beqz	a4,ffffffffc020137c <default_check+0x2e2>
        count++, total += p->property;
ffffffffc02010cc:	ff87a703          	lw	a4,-8(a5)
ffffffffc02010d0:	679c                	ld	a5,8(a5)
ffffffffc02010d2:	2905                	addiw	s2,s2,1
ffffffffc02010d4:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02010d6:	fe8796e3          	bne	a5,s0,ffffffffc02010c2 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc02010da:	89a6                	mv	s3,s1
ffffffffc02010dc:	6df000ef          	jal	ra,ffffffffc0201fba <nr_free_pages>
ffffffffc02010e0:	6f351e63          	bne	a0,s3,ffffffffc02017dc <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010e4:	4505                	li	a0,1
ffffffffc02010e6:	657000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc02010ea:	8aaa                	mv	s5,a0
ffffffffc02010ec:	42050863          	beqz	a0,ffffffffc020151c <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02010f0:	4505                	li	a0,1
ffffffffc02010f2:	64b000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc02010f6:	89aa                	mv	s3,a0
ffffffffc02010f8:	70050263          	beqz	a0,ffffffffc02017fc <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02010fc:	4505                	li	a0,1
ffffffffc02010fe:	63f000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc0201102:	8a2a                	mv	s4,a0
ffffffffc0201104:	48050c63          	beqz	a0,ffffffffc020159c <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201108:	293a8a63          	beq	s5,s3,ffffffffc020139c <default_check+0x302>
ffffffffc020110c:	28aa8863          	beq	s5,a0,ffffffffc020139c <default_check+0x302>
ffffffffc0201110:	28a98663          	beq	s3,a0,ffffffffc020139c <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201114:	000aa783          	lw	a5,0(s5)
ffffffffc0201118:	2a079263          	bnez	a5,ffffffffc02013bc <default_check+0x322>
ffffffffc020111c:	0009a783          	lw	a5,0(s3)
ffffffffc0201120:	28079e63          	bnez	a5,ffffffffc02013bc <default_check+0x322>
ffffffffc0201124:	411c                	lw	a5,0(a0)
ffffffffc0201126:	28079b63          	bnez	a5,ffffffffc02013bc <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc020112a:	000de797          	auipc	a5,0xde
ffffffffc020112e:	9de7b783          	ld	a5,-1570(a5) # ffffffffc02deb08 <pages>
ffffffffc0201132:	40fa8733          	sub	a4,s5,a5
ffffffffc0201136:	00007617          	auipc	a2,0x7
ffffffffc020113a:	b2263603          	ld	a2,-1246(a2) # ffffffffc0207c58 <nbase>
ffffffffc020113e:	8719                	srai	a4,a4,0x6
ffffffffc0201140:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201142:	000de697          	auipc	a3,0xde
ffffffffc0201146:	9be6b683          	ld	a3,-1602(a3) # ffffffffc02deb00 <npage>
ffffffffc020114a:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc020114c:	0732                	slli	a4,a4,0xc
ffffffffc020114e:	28d77763          	bgeu	a4,a3,ffffffffc02013dc <default_check+0x342>
    return page - pages + nbase;
ffffffffc0201152:	40f98733          	sub	a4,s3,a5
ffffffffc0201156:	8719                	srai	a4,a4,0x6
ffffffffc0201158:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020115a:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020115c:	4cd77063          	bgeu	a4,a3,ffffffffc020161c <default_check+0x582>
    return page - pages + nbase;
ffffffffc0201160:	40f507b3          	sub	a5,a0,a5
ffffffffc0201164:	8799                	srai	a5,a5,0x6
ffffffffc0201166:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201168:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020116a:	30d7f963          	bgeu	a5,a3,ffffffffc020147c <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc020116e:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201170:	00043c03          	ld	s8,0(s0)
ffffffffc0201174:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201178:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc020117c:	e400                	sd	s0,8(s0)
ffffffffc020117e:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201180:	000da797          	auipc	a5,0xda
ffffffffc0201184:	9207a023          	sw	zero,-1760(a5) # ffffffffc02daaa0 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201188:	5b5000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc020118c:	2c051863          	bnez	a0,ffffffffc020145c <default_check+0x3c2>
    free_page(p0);
ffffffffc0201190:	4585                	li	a1,1
ffffffffc0201192:	8556                	mv	a0,s5
ffffffffc0201194:	5e7000ef          	jal	ra,ffffffffc0201f7a <free_pages>
    free_page(p1);
ffffffffc0201198:	4585                	li	a1,1
ffffffffc020119a:	854e                	mv	a0,s3
ffffffffc020119c:	5df000ef          	jal	ra,ffffffffc0201f7a <free_pages>
    free_page(p2);
ffffffffc02011a0:	4585                	li	a1,1
ffffffffc02011a2:	8552                	mv	a0,s4
ffffffffc02011a4:	5d7000ef          	jal	ra,ffffffffc0201f7a <free_pages>
    assert(nr_free == 3);
ffffffffc02011a8:	4818                	lw	a4,16(s0)
ffffffffc02011aa:	478d                	li	a5,3
ffffffffc02011ac:	28f71863          	bne	a4,a5,ffffffffc020143c <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02011b0:	4505                	li	a0,1
ffffffffc02011b2:	58b000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc02011b6:	89aa                	mv	s3,a0
ffffffffc02011b8:	26050263          	beqz	a0,ffffffffc020141c <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02011bc:	4505                	li	a0,1
ffffffffc02011be:	57f000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc02011c2:	8aaa                	mv	s5,a0
ffffffffc02011c4:	3a050c63          	beqz	a0,ffffffffc020157c <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02011c8:	4505                	li	a0,1
ffffffffc02011ca:	573000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc02011ce:	8a2a                	mv	s4,a0
ffffffffc02011d0:	38050663          	beqz	a0,ffffffffc020155c <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc02011d4:	4505                	li	a0,1
ffffffffc02011d6:	567000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc02011da:	36051163          	bnez	a0,ffffffffc020153c <default_check+0x4a2>
    free_page(p0);
ffffffffc02011de:	4585                	li	a1,1
ffffffffc02011e0:	854e                	mv	a0,s3
ffffffffc02011e2:	599000ef          	jal	ra,ffffffffc0201f7a <free_pages>
    assert(!list_empty(&free_list));
ffffffffc02011e6:	641c                	ld	a5,8(s0)
ffffffffc02011e8:	20878a63          	beq	a5,s0,ffffffffc02013fc <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc02011ec:	4505                	li	a0,1
ffffffffc02011ee:	54f000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc02011f2:	30a99563          	bne	s3,a0,ffffffffc02014fc <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc02011f6:	4505                	li	a0,1
ffffffffc02011f8:	545000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc02011fc:	2e051063          	bnez	a0,ffffffffc02014dc <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0201200:	481c                	lw	a5,16(s0)
ffffffffc0201202:	2a079d63          	bnez	a5,ffffffffc02014bc <default_check+0x422>
    free_page(p);
ffffffffc0201206:	854e                	mv	a0,s3
ffffffffc0201208:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc020120a:	01843023          	sd	s8,0(s0)
ffffffffc020120e:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0201212:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201216:	565000ef          	jal	ra,ffffffffc0201f7a <free_pages>
    free_page(p1);
ffffffffc020121a:	4585                	li	a1,1
ffffffffc020121c:	8556                	mv	a0,s5
ffffffffc020121e:	55d000ef          	jal	ra,ffffffffc0201f7a <free_pages>
    free_page(p2);
ffffffffc0201222:	4585                	li	a1,1
ffffffffc0201224:	8552                	mv	a0,s4
ffffffffc0201226:	555000ef          	jal	ra,ffffffffc0201f7a <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc020122a:	4515                	li	a0,5
ffffffffc020122c:	511000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc0201230:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201232:	26050563          	beqz	a0,ffffffffc020149c <default_check+0x402>
ffffffffc0201236:	651c                	ld	a5,8(a0)
ffffffffc0201238:	8385                	srli	a5,a5,0x1
ffffffffc020123a:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc020123c:	54079063          	bnez	a5,ffffffffc020177c <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201240:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201242:	00043b03          	ld	s6,0(s0)
ffffffffc0201246:	00843a83          	ld	s5,8(s0)
ffffffffc020124a:	e000                	sd	s0,0(s0)
ffffffffc020124c:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc020124e:	4ef000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc0201252:	50051563          	bnez	a0,ffffffffc020175c <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201256:	08098a13          	addi	s4,s3,128
ffffffffc020125a:	8552                	mv	a0,s4
ffffffffc020125c:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc020125e:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0201262:	000da797          	auipc	a5,0xda
ffffffffc0201266:	8207af23          	sw	zero,-1986(a5) # ffffffffc02daaa0 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc020126a:	511000ef          	jal	ra,ffffffffc0201f7a <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc020126e:	4511                	li	a0,4
ffffffffc0201270:	4cd000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc0201274:	4c051463          	bnez	a0,ffffffffc020173c <default_check+0x6a2>
ffffffffc0201278:	0889b783          	ld	a5,136(s3)
ffffffffc020127c:	8385                	srli	a5,a5,0x1
ffffffffc020127e:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201280:	48078e63          	beqz	a5,ffffffffc020171c <default_check+0x682>
ffffffffc0201284:	0909a703          	lw	a4,144(s3)
ffffffffc0201288:	478d                	li	a5,3
ffffffffc020128a:	48f71963          	bne	a4,a5,ffffffffc020171c <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020128e:	450d                	li	a0,3
ffffffffc0201290:	4ad000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc0201294:	8c2a                	mv	s8,a0
ffffffffc0201296:	46050363          	beqz	a0,ffffffffc02016fc <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc020129a:	4505                	li	a0,1
ffffffffc020129c:	4a1000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc02012a0:	42051e63          	bnez	a0,ffffffffc02016dc <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc02012a4:	418a1c63          	bne	s4,s8,ffffffffc02016bc <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02012a8:	4585                	li	a1,1
ffffffffc02012aa:	854e                	mv	a0,s3
ffffffffc02012ac:	4cf000ef          	jal	ra,ffffffffc0201f7a <free_pages>
    free_pages(p1, 3);
ffffffffc02012b0:	458d                	li	a1,3
ffffffffc02012b2:	8552                	mv	a0,s4
ffffffffc02012b4:	4c7000ef          	jal	ra,ffffffffc0201f7a <free_pages>
ffffffffc02012b8:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc02012bc:	04098c13          	addi	s8,s3,64
ffffffffc02012c0:	8385                	srli	a5,a5,0x1
ffffffffc02012c2:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02012c4:	3c078c63          	beqz	a5,ffffffffc020169c <default_check+0x602>
ffffffffc02012c8:	0109a703          	lw	a4,16(s3)
ffffffffc02012cc:	4785                	li	a5,1
ffffffffc02012ce:	3cf71763          	bne	a4,a5,ffffffffc020169c <default_check+0x602>
ffffffffc02012d2:	008a3783          	ld	a5,8(s4)
ffffffffc02012d6:	8385                	srli	a5,a5,0x1
ffffffffc02012d8:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02012da:	3a078163          	beqz	a5,ffffffffc020167c <default_check+0x5e2>
ffffffffc02012de:	010a2703          	lw	a4,16(s4)
ffffffffc02012e2:	478d                	li	a5,3
ffffffffc02012e4:	38f71c63          	bne	a4,a5,ffffffffc020167c <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02012e8:	4505                	li	a0,1
ffffffffc02012ea:	453000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc02012ee:	36a99763          	bne	s3,a0,ffffffffc020165c <default_check+0x5c2>
    free_page(p0);
ffffffffc02012f2:	4585                	li	a1,1
ffffffffc02012f4:	487000ef          	jal	ra,ffffffffc0201f7a <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02012f8:	4509                	li	a0,2
ffffffffc02012fa:	443000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc02012fe:	32aa1f63          	bne	s4,a0,ffffffffc020163c <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc0201302:	4589                	li	a1,2
ffffffffc0201304:	477000ef          	jal	ra,ffffffffc0201f7a <free_pages>
    free_page(p2);
ffffffffc0201308:	4585                	li	a1,1
ffffffffc020130a:	8562                	mv	a0,s8
ffffffffc020130c:	46f000ef          	jal	ra,ffffffffc0201f7a <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201310:	4515                	li	a0,5
ffffffffc0201312:	42b000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc0201316:	89aa                	mv	s3,a0
ffffffffc0201318:	48050263          	beqz	a0,ffffffffc020179c <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc020131c:	4505                	li	a0,1
ffffffffc020131e:	41f000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc0201322:	2c051d63          	bnez	a0,ffffffffc02015fc <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201326:	481c                	lw	a5,16(s0)
ffffffffc0201328:	2a079a63          	bnez	a5,ffffffffc02015dc <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc020132c:	4595                	li	a1,5
ffffffffc020132e:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201330:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201334:	01643023          	sd	s6,0(s0)
ffffffffc0201338:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc020133c:	43f000ef          	jal	ra,ffffffffc0201f7a <free_pages>
    return listelm->next;
ffffffffc0201340:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201342:	00878963          	beq	a5,s0,ffffffffc0201354 <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc0201346:	ff87a703          	lw	a4,-8(a5)
ffffffffc020134a:	679c                	ld	a5,8(a5)
ffffffffc020134c:	397d                	addiw	s2,s2,-1
ffffffffc020134e:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201350:	fe879be3          	bne	a5,s0,ffffffffc0201346 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc0201354:	26091463          	bnez	s2,ffffffffc02015bc <default_check+0x522>
    assert(total == 0);
ffffffffc0201358:	46049263          	bnez	s1,ffffffffc02017bc <default_check+0x722>
}
ffffffffc020135c:	60a6                	ld	ra,72(sp)
ffffffffc020135e:	6406                	ld	s0,64(sp)
ffffffffc0201360:	74e2                	ld	s1,56(sp)
ffffffffc0201362:	7942                	ld	s2,48(sp)
ffffffffc0201364:	79a2                	ld	s3,40(sp)
ffffffffc0201366:	7a02                	ld	s4,32(sp)
ffffffffc0201368:	6ae2                	ld	s5,24(sp)
ffffffffc020136a:	6b42                	ld	s6,16(sp)
ffffffffc020136c:	6ba2                	ld	s7,8(sp)
ffffffffc020136e:	6c02                	ld	s8,0(sp)
ffffffffc0201370:	6161                	addi	sp,sp,80
ffffffffc0201372:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc0201374:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201376:	4481                	li	s1,0
ffffffffc0201378:	4901                	li	s2,0
ffffffffc020137a:	b38d                	j	ffffffffc02010dc <default_check+0x42>
        assert(PageProperty(p));
ffffffffc020137c:	00005697          	auipc	a3,0x5
ffffffffc0201380:	02468693          	addi	a3,a3,36 # ffffffffc02063a0 <commands+0x838>
ffffffffc0201384:	00005617          	auipc	a2,0x5
ffffffffc0201388:	02c60613          	addi	a2,a2,44 # ffffffffc02063b0 <commands+0x848>
ffffffffc020138c:	11000593          	li	a1,272
ffffffffc0201390:	00005517          	auipc	a0,0x5
ffffffffc0201394:	03850513          	addi	a0,a0,56 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201398:	8f6ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020139c:	00005697          	auipc	a3,0x5
ffffffffc02013a0:	0c468693          	addi	a3,a3,196 # ffffffffc0206460 <commands+0x8f8>
ffffffffc02013a4:	00005617          	auipc	a2,0x5
ffffffffc02013a8:	00c60613          	addi	a2,a2,12 # ffffffffc02063b0 <commands+0x848>
ffffffffc02013ac:	0db00593          	li	a1,219
ffffffffc02013b0:	00005517          	auipc	a0,0x5
ffffffffc02013b4:	01850513          	addi	a0,a0,24 # ffffffffc02063c8 <commands+0x860>
ffffffffc02013b8:	8d6ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02013bc:	00005697          	auipc	a3,0x5
ffffffffc02013c0:	0cc68693          	addi	a3,a3,204 # ffffffffc0206488 <commands+0x920>
ffffffffc02013c4:	00005617          	auipc	a2,0x5
ffffffffc02013c8:	fec60613          	addi	a2,a2,-20 # ffffffffc02063b0 <commands+0x848>
ffffffffc02013cc:	0dc00593          	li	a1,220
ffffffffc02013d0:	00005517          	auipc	a0,0x5
ffffffffc02013d4:	ff850513          	addi	a0,a0,-8 # ffffffffc02063c8 <commands+0x860>
ffffffffc02013d8:	8b6ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02013dc:	00005697          	auipc	a3,0x5
ffffffffc02013e0:	0ec68693          	addi	a3,a3,236 # ffffffffc02064c8 <commands+0x960>
ffffffffc02013e4:	00005617          	auipc	a2,0x5
ffffffffc02013e8:	fcc60613          	addi	a2,a2,-52 # ffffffffc02063b0 <commands+0x848>
ffffffffc02013ec:	0de00593          	li	a1,222
ffffffffc02013f0:	00005517          	auipc	a0,0x5
ffffffffc02013f4:	fd850513          	addi	a0,a0,-40 # ffffffffc02063c8 <commands+0x860>
ffffffffc02013f8:	896ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!list_empty(&free_list));
ffffffffc02013fc:	00005697          	auipc	a3,0x5
ffffffffc0201400:	15468693          	addi	a3,a3,340 # ffffffffc0206550 <commands+0x9e8>
ffffffffc0201404:	00005617          	auipc	a2,0x5
ffffffffc0201408:	fac60613          	addi	a2,a2,-84 # ffffffffc02063b0 <commands+0x848>
ffffffffc020140c:	0f700593          	li	a1,247
ffffffffc0201410:	00005517          	auipc	a0,0x5
ffffffffc0201414:	fb850513          	addi	a0,a0,-72 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201418:	876ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020141c:	00005697          	auipc	a3,0x5
ffffffffc0201420:	fe468693          	addi	a3,a3,-28 # ffffffffc0206400 <commands+0x898>
ffffffffc0201424:	00005617          	auipc	a2,0x5
ffffffffc0201428:	f8c60613          	addi	a2,a2,-116 # ffffffffc02063b0 <commands+0x848>
ffffffffc020142c:	0f000593          	li	a1,240
ffffffffc0201430:	00005517          	auipc	a0,0x5
ffffffffc0201434:	f9850513          	addi	a0,a0,-104 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201438:	856ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 3);
ffffffffc020143c:	00005697          	auipc	a3,0x5
ffffffffc0201440:	10468693          	addi	a3,a3,260 # ffffffffc0206540 <commands+0x9d8>
ffffffffc0201444:	00005617          	auipc	a2,0x5
ffffffffc0201448:	f6c60613          	addi	a2,a2,-148 # ffffffffc02063b0 <commands+0x848>
ffffffffc020144c:	0ee00593          	li	a1,238
ffffffffc0201450:	00005517          	auipc	a0,0x5
ffffffffc0201454:	f7850513          	addi	a0,a0,-136 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201458:	836ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020145c:	00005697          	auipc	a3,0x5
ffffffffc0201460:	0cc68693          	addi	a3,a3,204 # ffffffffc0206528 <commands+0x9c0>
ffffffffc0201464:	00005617          	auipc	a2,0x5
ffffffffc0201468:	f4c60613          	addi	a2,a2,-180 # ffffffffc02063b0 <commands+0x848>
ffffffffc020146c:	0e900593          	li	a1,233
ffffffffc0201470:	00005517          	auipc	a0,0x5
ffffffffc0201474:	f5850513          	addi	a0,a0,-168 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201478:	816ff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020147c:	00005697          	auipc	a3,0x5
ffffffffc0201480:	08c68693          	addi	a3,a3,140 # ffffffffc0206508 <commands+0x9a0>
ffffffffc0201484:	00005617          	auipc	a2,0x5
ffffffffc0201488:	f2c60613          	addi	a2,a2,-212 # ffffffffc02063b0 <commands+0x848>
ffffffffc020148c:	0e000593          	li	a1,224
ffffffffc0201490:	00005517          	auipc	a0,0x5
ffffffffc0201494:	f3850513          	addi	a0,a0,-200 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201498:	ff7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != NULL);
ffffffffc020149c:	00005697          	auipc	a3,0x5
ffffffffc02014a0:	0fc68693          	addi	a3,a3,252 # ffffffffc0206598 <commands+0xa30>
ffffffffc02014a4:	00005617          	auipc	a2,0x5
ffffffffc02014a8:	f0c60613          	addi	a2,a2,-244 # ffffffffc02063b0 <commands+0x848>
ffffffffc02014ac:	11800593          	li	a1,280
ffffffffc02014b0:	00005517          	auipc	a0,0x5
ffffffffc02014b4:	f1850513          	addi	a0,a0,-232 # ffffffffc02063c8 <commands+0x860>
ffffffffc02014b8:	fd7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc02014bc:	00005697          	auipc	a3,0x5
ffffffffc02014c0:	0cc68693          	addi	a3,a3,204 # ffffffffc0206588 <commands+0xa20>
ffffffffc02014c4:	00005617          	auipc	a2,0x5
ffffffffc02014c8:	eec60613          	addi	a2,a2,-276 # ffffffffc02063b0 <commands+0x848>
ffffffffc02014cc:	0fd00593          	li	a1,253
ffffffffc02014d0:	00005517          	auipc	a0,0x5
ffffffffc02014d4:	ef850513          	addi	a0,a0,-264 # ffffffffc02063c8 <commands+0x860>
ffffffffc02014d8:	fb7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014dc:	00005697          	auipc	a3,0x5
ffffffffc02014e0:	04c68693          	addi	a3,a3,76 # ffffffffc0206528 <commands+0x9c0>
ffffffffc02014e4:	00005617          	auipc	a2,0x5
ffffffffc02014e8:	ecc60613          	addi	a2,a2,-308 # ffffffffc02063b0 <commands+0x848>
ffffffffc02014ec:	0fb00593          	li	a1,251
ffffffffc02014f0:	00005517          	auipc	a0,0x5
ffffffffc02014f4:	ed850513          	addi	a0,a0,-296 # ffffffffc02063c8 <commands+0x860>
ffffffffc02014f8:	f97fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02014fc:	00005697          	auipc	a3,0x5
ffffffffc0201500:	06c68693          	addi	a3,a3,108 # ffffffffc0206568 <commands+0xa00>
ffffffffc0201504:	00005617          	auipc	a2,0x5
ffffffffc0201508:	eac60613          	addi	a2,a2,-340 # ffffffffc02063b0 <commands+0x848>
ffffffffc020150c:	0fa00593          	li	a1,250
ffffffffc0201510:	00005517          	auipc	a0,0x5
ffffffffc0201514:	eb850513          	addi	a0,a0,-328 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201518:	f77fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020151c:	00005697          	auipc	a3,0x5
ffffffffc0201520:	ee468693          	addi	a3,a3,-284 # ffffffffc0206400 <commands+0x898>
ffffffffc0201524:	00005617          	auipc	a2,0x5
ffffffffc0201528:	e8c60613          	addi	a2,a2,-372 # ffffffffc02063b0 <commands+0x848>
ffffffffc020152c:	0d700593          	li	a1,215
ffffffffc0201530:	00005517          	auipc	a0,0x5
ffffffffc0201534:	e9850513          	addi	a0,a0,-360 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201538:	f57fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020153c:	00005697          	auipc	a3,0x5
ffffffffc0201540:	fec68693          	addi	a3,a3,-20 # ffffffffc0206528 <commands+0x9c0>
ffffffffc0201544:	00005617          	auipc	a2,0x5
ffffffffc0201548:	e6c60613          	addi	a2,a2,-404 # ffffffffc02063b0 <commands+0x848>
ffffffffc020154c:	0f400593          	li	a1,244
ffffffffc0201550:	00005517          	auipc	a0,0x5
ffffffffc0201554:	e7850513          	addi	a0,a0,-392 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201558:	f37fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020155c:	00005697          	auipc	a3,0x5
ffffffffc0201560:	ee468693          	addi	a3,a3,-284 # ffffffffc0206440 <commands+0x8d8>
ffffffffc0201564:	00005617          	auipc	a2,0x5
ffffffffc0201568:	e4c60613          	addi	a2,a2,-436 # ffffffffc02063b0 <commands+0x848>
ffffffffc020156c:	0f200593          	li	a1,242
ffffffffc0201570:	00005517          	auipc	a0,0x5
ffffffffc0201574:	e5850513          	addi	a0,a0,-424 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201578:	f17fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020157c:	00005697          	auipc	a3,0x5
ffffffffc0201580:	ea468693          	addi	a3,a3,-348 # ffffffffc0206420 <commands+0x8b8>
ffffffffc0201584:	00005617          	auipc	a2,0x5
ffffffffc0201588:	e2c60613          	addi	a2,a2,-468 # ffffffffc02063b0 <commands+0x848>
ffffffffc020158c:	0f100593          	li	a1,241
ffffffffc0201590:	00005517          	auipc	a0,0x5
ffffffffc0201594:	e3850513          	addi	a0,a0,-456 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201598:	ef7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020159c:	00005697          	auipc	a3,0x5
ffffffffc02015a0:	ea468693          	addi	a3,a3,-348 # ffffffffc0206440 <commands+0x8d8>
ffffffffc02015a4:	00005617          	auipc	a2,0x5
ffffffffc02015a8:	e0c60613          	addi	a2,a2,-500 # ffffffffc02063b0 <commands+0x848>
ffffffffc02015ac:	0d900593          	li	a1,217
ffffffffc02015b0:	00005517          	auipc	a0,0x5
ffffffffc02015b4:	e1850513          	addi	a0,a0,-488 # ffffffffc02063c8 <commands+0x860>
ffffffffc02015b8:	ed7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(count == 0);
ffffffffc02015bc:	00005697          	auipc	a3,0x5
ffffffffc02015c0:	12c68693          	addi	a3,a3,300 # ffffffffc02066e8 <commands+0xb80>
ffffffffc02015c4:	00005617          	auipc	a2,0x5
ffffffffc02015c8:	dec60613          	addi	a2,a2,-532 # ffffffffc02063b0 <commands+0x848>
ffffffffc02015cc:	14600593          	li	a1,326
ffffffffc02015d0:	00005517          	auipc	a0,0x5
ffffffffc02015d4:	df850513          	addi	a0,a0,-520 # ffffffffc02063c8 <commands+0x860>
ffffffffc02015d8:	eb7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc02015dc:	00005697          	auipc	a3,0x5
ffffffffc02015e0:	fac68693          	addi	a3,a3,-84 # ffffffffc0206588 <commands+0xa20>
ffffffffc02015e4:	00005617          	auipc	a2,0x5
ffffffffc02015e8:	dcc60613          	addi	a2,a2,-564 # ffffffffc02063b0 <commands+0x848>
ffffffffc02015ec:	13a00593          	li	a1,314
ffffffffc02015f0:	00005517          	auipc	a0,0x5
ffffffffc02015f4:	dd850513          	addi	a0,a0,-552 # ffffffffc02063c8 <commands+0x860>
ffffffffc02015f8:	e97fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02015fc:	00005697          	auipc	a3,0x5
ffffffffc0201600:	f2c68693          	addi	a3,a3,-212 # ffffffffc0206528 <commands+0x9c0>
ffffffffc0201604:	00005617          	auipc	a2,0x5
ffffffffc0201608:	dac60613          	addi	a2,a2,-596 # ffffffffc02063b0 <commands+0x848>
ffffffffc020160c:	13800593          	li	a1,312
ffffffffc0201610:	00005517          	auipc	a0,0x5
ffffffffc0201614:	db850513          	addi	a0,a0,-584 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201618:	e77fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020161c:	00005697          	auipc	a3,0x5
ffffffffc0201620:	ecc68693          	addi	a3,a3,-308 # ffffffffc02064e8 <commands+0x980>
ffffffffc0201624:	00005617          	auipc	a2,0x5
ffffffffc0201628:	d8c60613          	addi	a2,a2,-628 # ffffffffc02063b0 <commands+0x848>
ffffffffc020162c:	0df00593          	li	a1,223
ffffffffc0201630:	00005517          	auipc	a0,0x5
ffffffffc0201634:	d9850513          	addi	a0,a0,-616 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201638:	e57fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020163c:	00005697          	auipc	a3,0x5
ffffffffc0201640:	06c68693          	addi	a3,a3,108 # ffffffffc02066a8 <commands+0xb40>
ffffffffc0201644:	00005617          	auipc	a2,0x5
ffffffffc0201648:	d6c60613          	addi	a2,a2,-660 # ffffffffc02063b0 <commands+0x848>
ffffffffc020164c:	13200593          	li	a1,306
ffffffffc0201650:	00005517          	auipc	a0,0x5
ffffffffc0201654:	d7850513          	addi	a0,a0,-648 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201658:	e37fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc020165c:	00005697          	auipc	a3,0x5
ffffffffc0201660:	02c68693          	addi	a3,a3,44 # ffffffffc0206688 <commands+0xb20>
ffffffffc0201664:	00005617          	auipc	a2,0x5
ffffffffc0201668:	d4c60613          	addi	a2,a2,-692 # ffffffffc02063b0 <commands+0x848>
ffffffffc020166c:	13000593          	li	a1,304
ffffffffc0201670:	00005517          	auipc	a0,0x5
ffffffffc0201674:	d5850513          	addi	a0,a0,-680 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201678:	e17fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc020167c:	00005697          	auipc	a3,0x5
ffffffffc0201680:	fe468693          	addi	a3,a3,-28 # ffffffffc0206660 <commands+0xaf8>
ffffffffc0201684:	00005617          	auipc	a2,0x5
ffffffffc0201688:	d2c60613          	addi	a2,a2,-724 # ffffffffc02063b0 <commands+0x848>
ffffffffc020168c:	12e00593          	li	a1,302
ffffffffc0201690:	00005517          	auipc	a0,0x5
ffffffffc0201694:	d3850513          	addi	a0,a0,-712 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201698:	df7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020169c:	00005697          	auipc	a3,0x5
ffffffffc02016a0:	f9c68693          	addi	a3,a3,-100 # ffffffffc0206638 <commands+0xad0>
ffffffffc02016a4:	00005617          	auipc	a2,0x5
ffffffffc02016a8:	d0c60613          	addi	a2,a2,-756 # ffffffffc02063b0 <commands+0x848>
ffffffffc02016ac:	12d00593          	li	a1,301
ffffffffc02016b0:	00005517          	auipc	a0,0x5
ffffffffc02016b4:	d1850513          	addi	a0,a0,-744 # ffffffffc02063c8 <commands+0x860>
ffffffffc02016b8:	dd7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 + 2 == p1);
ffffffffc02016bc:	00005697          	auipc	a3,0x5
ffffffffc02016c0:	f6c68693          	addi	a3,a3,-148 # ffffffffc0206628 <commands+0xac0>
ffffffffc02016c4:	00005617          	auipc	a2,0x5
ffffffffc02016c8:	cec60613          	addi	a2,a2,-788 # ffffffffc02063b0 <commands+0x848>
ffffffffc02016cc:	12800593          	li	a1,296
ffffffffc02016d0:	00005517          	auipc	a0,0x5
ffffffffc02016d4:	cf850513          	addi	a0,a0,-776 # ffffffffc02063c8 <commands+0x860>
ffffffffc02016d8:	db7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016dc:	00005697          	auipc	a3,0x5
ffffffffc02016e0:	e4c68693          	addi	a3,a3,-436 # ffffffffc0206528 <commands+0x9c0>
ffffffffc02016e4:	00005617          	auipc	a2,0x5
ffffffffc02016e8:	ccc60613          	addi	a2,a2,-820 # ffffffffc02063b0 <commands+0x848>
ffffffffc02016ec:	12700593          	li	a1,295
ffffffffc02016f0:	00005517          	auipc	a0,0x5
ffffffffc02016f4:	cd850513          	addi	a0,a0,-808 # ffffffffc02063c8 <commands+0x860>
ffffffffc02016f8:	d97fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02016fc:	00005697          	auipc	a3,0x5
ffffffffc0201700:	f0c68693          	addi	a3,a3,-244 # ffffffffc0206608 <commands+0xaa0>
ffffffffc0201704:	00005617          	auipc	a2,0x5
ffffffffc0201708:	cac60613          	addi	a2,a2,-852 # ffffffffc02063b0 <commands+0x848>
ffffffffc020170c:	12600593          	li	a1,294
ffffffffc0201710:	00005517          	auipc	a0,0x5
ffffffffc0201714:	cb850513          	addi	a0,a0,-840 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201718:	d77fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020171c:	00005697          	auipc	a3,0x5
ffffffffc0201720:	ebc68693          	addi	a3,a3,-324 # ffffffffc02065d8 <commands+0xa70>
ffffffffc0201724:	00005617          	auipc	a2,0x5
ffffffffc0201728:	c8c60613          	addi	a2,a2,-884 # ffffffffc02063b0 <commands+0x848>
ffffffffc020172c:	12500593          	li	a1,293
ffffffffc0201730:	00005517          	auipc	a0,0x5
ffffffffc0201734:	c9850513          	addi	a0,a0,-872 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201738:	d57fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc020173c:	00005697          	auipc	a3,0x5
ffffffffc0201740:	e8468693          	addi	a3,a3,-380 # ffffffffc02065c0 <commands+0xa58>
ffffffffc0201744:	00005617          	auipc	a2,0x5
ffffffffc0201748:	c6c60613          	addi	a2,a2,-916 # ffffffffc02063b0 <commands+0x848>
ffffffffc020174c:	12400593          	li	a1,292
ffffffffc0201750:	00005517          	auipc	a0,0x5
ffffffffc0201754:	c7850513          	addi	a0,a0,-904 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201758:	d37fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020175c:	00005697          	auipc	a3,0x5
ffffffffc0201760:	dcc68693          	addi	a3,a3,-564 # ffffffffc0206528 <commands+0x9c0>
ffffffffc0201764:	00005617          	auipc	a2,0x5
ffffffffc0201768:	c4c60613          	addi	a2,a2,-948 # ffffffffc02063b0 <commands+0x848>
ffffffffc020176c:	11e00593          	li	a1,286
ffffffffc0201770:	00005517          	auipc	a0,0x5
ffffffffc0201774:	c5850513          	addi	a0,a0,-936 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201778:	d17fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!PageProperty(p0));
ffffffffc020177c:	00005697          	auipc	a3,0x5
ffffffffc0201780:	e2c68693          	addi	a3,a3,-468 # ffffffffc02065a8 <commands+0xa40>
ffffffffc0201784:	00005617          	auipc	a2,0x5
ffffffffc0201788:	c2c60613          	addi	a2,a2,-980 # ffffffffc02063b0 <commands+0x848>
ffffffffc020178c:	11900593          	li	a1,281
ffffffffc0201790:	00005517          	auipc	a0,0x5
ffffffffc0201794:	c3850513          	addi	a0,a0,-968 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201798:	cf7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020179c:	00005697          	auipc	a3,0x5
ffffffffc02017a0:	f2c68693          	addi	a3,a3,-212 # ffffffffc02066c8 <commands+0xb60>
ffffffffc02017a4:	00005617          	auipc	a2,0x5
ffffffffc02017a8:	c0c60613          	addi	a2,a2,-1012 # ffffffffc02063b0 <commands+0x848>
ffffffffc02017ac:	13700593          	li	a1,311
ffffffffc02017b0:	00005517          	auipc	a0,0x5
ffffffffc02017b4:	c1850513          	addi	a0,a0,-1000 # ffffffffc02063c8 <commands+0x860>
ffffffffc02017b8:	cd7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == 0);
ffffffffc02017bc:	00005697          	auipc	a3,0x5
ffffffffc02017c0:	f3c68693          	addi	a3,a3,-196 # ffffffffc02066f8 <commands+0xb90>
ffffffffc02017c4:	00005617          	auipc	a2,0x5
ffffffffc02017c8:	bec60613          	addi	a2,a2,-1044 # ffffffffc02063b0 <commands+0x848>
ffffffffc02017cc:	14700593          	li	a1,327
ffffffffc02017d0:	00005517          	auipc	a0,0x5
ffffffffc02017d4:	bf850513          	addi	a0,a0,-1032 # ffffffffc02063c8 <commands+0x860>
ffffffffc02017d8:	cb7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == nr_free_pages());
ffffffffc02017dc:	00005697          	auipc	a3,0x5
ffffffffc02017e0:	c0468693          	addi	a3,a3,-1020 # ffffffffc02063e0 <commands+0x878>
ffffffffc02017e4:	00005617          	auipc	a2,0x5
ffffffffc02017e8:	bcc60613          	addi	a2,a2,-1076 # ffffffffc02063b0 <commands+0x848>
ffffffffc02017ec:	11300593          	li	a1,275
ffffffffc02017f0:	00005517          	auipc	a0,0x5
ffffffffc02017f4:	bd850513          	addi	a0,a0,-1064 # ffffffffc02063c8 <commands+0x860>
ffffffffc02017f8:	c97fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02017fc:	00005697          	auipc	a3,0x5
ffffffffc0201800:	c2468693          	addi	a3,a3,-988 # ffffffffc0206420 <commands+0x8b8>
ffffffffc0201804:	00005617          	auipc	a2,0x5
ffffffffc0201808:	bac60613          	addi	a2,a2,-1108 # ffffffffc02063b0 <commands+0x848>
ffffffffc020180c:	0d800593          	li	a1,216
ffffffffc0201810:	00005517          	auipc	a0,0x5
ffffffffc0201814:	bb850513          	addi	a0,a0,-1096 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201818:	c77fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020181c <default_free_pages>:
{
ffffffffc020181c:	1141                	addi	sp,sp,-16
ffffffffc020181e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201820:	14058463          	beqz	a1,ffffffffc0201968 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0201824:	00659693          	slli	a3,a1,0x6
ffffffffc0201828:	96aa                	add	a3,a3,a0
ffffffffc020182a:	87aa                	mv	a5,a0
ffffffffc020182c:	02d50263          	beq	a0,a3,ffffffffc0201850 <default_free_pages+0x34>
ffffffffc0201830:	6798                	ld	a4,8(a5)
ffffffffc0201832:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201834:	10071a63          	bnez	a4,ffffffffc0201948 <default_free_pages+0x12c>
ffffffffc0201838:	6798                	ld	a4,8(a5)
ffffffffc020183a:	8b09                	andi	a4,a4,2
ffffffffc020183c:	10071663          	bnez	a4,ffffffffc0201948 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc0201840:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201844:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201848:	04078793          	addi	a5,a5,64
ffffffffc020184c:	fed792e3          	bne	a5,a3,ffffffffc0201830 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201850:	2581                	sext.w	a1,a1
ffffffffc0201852:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201854:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201858:	4789                	li	a5,2
ffffffffc020185a:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc020185e:	000d9697          	auipc	a3,0xd9
ffffffffc0201862:	23268693          	addi	a3,a3,562 # ffffffffc02daa90 <free_area>
ffffffffc0201866:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201868:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020186a:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc020186e:	9db9                	addw	a1,a1,a4
ffffffffc0201870:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201872:	0ad78463          	beq	a5,a3,ffffffffc020191a <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc0201876:	fe878713          	addi	a4,a5,-24
ffffffffc020187a:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc020187e:	4581                	li	a1,0
            if (base < page)
ffffffffc0201880:	00e56a63          	bltu	a0,a4,ffffffffc0201894 <default_free_pages+0x78>
    return listelm->next;
ffffffffc0201884:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201886:	04d70c63          	beq	a4,a3,ffffffffc02018de <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc020188a:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc020188c:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201890:	fee57ae3          	bgeu	a0,a4,ffffffffc0201884 <default_free_pages+0x68>
ffffffffc0201894:	c199                	beqz	a1,ffffffffc020189a <default_free_pages+0x7e>
ffffffffc0201896:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020189a:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc020189c:	e390                	sd	a2,0(a5)
ffffffffc020189e:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02018a0:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02018a2:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc02018a4:	00d70d63          	beq	a4,a3,ffffffffc02018be <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc02018a8:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc02018ac:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc02018b0:	02059813          	slli	a6,a1,0x20
ffffffffc02018b4:	01a85793          	srli	a5,a6,0x1a
ffffffffc02018b8:	97b2                	add	a5,a5,a2
ffffffffc02018ba:	02f50c63          	beq	a0,a5,ffffffffc02018f2 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc02018be:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc02018c0:	00d78c63          	beq	a5,a3,ffffffffc02018d8 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc02018c4:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc02018c6:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc02018ca:	02061593          	slli	a1,a2,0x20
ffffffffc02018ce:	01a5d713          	srli	a4,a1,0x1a
ffffffffc02018d2:	972a                	add	a4,a4,a0
ffffffffc02018d4:	04e68a63          	beq	a3,a4,ffffffffc0201928 <default_free_pages+0x10c>
}
ffffffffc02018d8:	60a2                	ld	ra,8(sp)
ffffffffc02018da:	0141                	addi	sp,sp,16
ffffffffc02018dc:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02018de:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02018e0:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02018e2:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02018e4:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc02018e6:	02d70763          	beq	a4,a3,ffffffffc0201914 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc02018ea:	8832                	mv	a6,a2
ffffffffc02018ec:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc02018ee:	87ba                	mv	a5,a4
ffffffffc02018f0:	bf71                	j	ffffffffc020188c <default_free_pages+0x70>
            p->property += base->property;
ffffffffc02018f2:	491c                	lw	a5,16(a0)
ffffffffc02018f4:	9dbd                	addw	a1,a1,a5
ffffffffc02018f6:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02018fa:	57f5                	li	a5,-3
ffffffffc02018fc:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201900:	01853803          	ld	a6,24(a0)
ffffffffc0201904:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201906:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201908:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc020190c:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020190e:	0105b023          	sd	a6,0(a1)
ffffffffc0201912:	b77d                	j	ffffffffc02018c0 <default_free_pages+0xa4>
ffffffffc0201914:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201916:	873e                	mv	a4,a5
ffffffffc0201918:	bf41                	j	ffffffffc02018a8 <default_free_pages+0x8c>
}
ffffffffc020191a:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020191c:	e390                	sd	a2,0(a5)
ffffffffc020191e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201920:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201922:	ed1c                	sd	a5,24(a0)
ffffffffc0201924:	0141                	addi	sp,sp,16
ffffffffc0201926:	8082                	ret
            base->property += p->property;
ffffffffc0201928:	ff87a703          	lw	a4,-8(a5)
ffffffffc020192c:	ff078693          	addi	a3,a5,-16
ffffffffc0201930:	9e39                	addw	a2,a2,a4
ffffffffc0201932:	c910                	sw	a2,16(a0)
ffffffffc0201934:	5775                	li	a4,-3
ffffffffc0201936:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020193a:	6398                	ld	a4,0(a5)
ffffffffc020193c:	679c                	ld	a5,8(a5)
}
ffffffffc020193e:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201940:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201942:	e398                	sd	a4,0(a5)
ffffffffc0201944:	0141                	addi	sp,sp,16
ffffffffc0201946:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201948:	00005697          	auipc	a3,0x5
ffffffffc020194c:	dc868693          	addi	a3,a3,-568 # ffffffffc0206710 <commands+0xba8>
ffffffffc0201950:	00005617          	auipc	a2,0x5
ffffffffc0201954:	a6060613          	addi	a2,a2,-1440 # ffffffffc02063b0 <commands+0x848>
ffffffffc0201958:	09400593          	li	a1,148
ffffffffc020195c:	00005517          	auipc	a0,0x5
ffffffffc0201960:	a6c50513          	addi	a0,a0,-1428 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201964:	b2bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201968:	00005697          	auipc	a3,0x5
ffffffffc020196c:	da068693          	addi	a3,a3,-608 # ffffffffc0206708 <commands+0xba0>
ffffffffc0201970:	00005617          	auipc	a2,0x5
ffffffffc0201974:	a4060613          	addi	a2,a2,-1472 # ffffffffc02063b0 <commands+0x848>
ffffffffc0201978:	09000593          	li	a1,144
ffffffffc020197c:	00005517          	auipc	a0,0x5
ffffffffc0201980:	a4c50513          	addi	a0,a0,-1460 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201984:	b0bfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201988 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201988:	c941                	beqz	a0,ffffffffc0201a18 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc020198a:	000d9597          	auipc	a1,0xd9
ffffffffc020198e:	10658593          	addi	a1,a1,262 # ffffffffc02daa90 <free_area>
ffffffffc0201992:	0105a803          	lw	a6,16(a1)
ffffffffc0201996:	872a                	mv	a4,a0
ffffffffc0201998:	02081793          	slli	a5,a6,0x20
ffffffffc020199c:	9381                	srli	a5,a5,0x20
ffffffffc020199e:	00a7ee63          	bltu	a5,a0,ffffffffc02019ba <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc02019a2:	87ae                	mv	a5,a1
ffffffffc02019a4:	a801                	j	ffffffffc02019b4 <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc02019a6:	ff87a683          	lw	a3,-8(a5)
ffffffffc02019aa:	02069613          	slli	a2,a3,0x20
ffffffffc02019ae:	9201                	srli	a2,a2,0x20
ffffffffc02019b0:	00e67763          	bgeu	a2,a4,ffffffffc02019be <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc02019b4:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc02019b6:	feb798e3          	bne	a5,a1,ffffffffc02019a6 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc02019ba:	4501                	li	a0,0
}
ffffffffc02019bc:	8082                	ret
    return listelm->prev;
ffffffffc02019be:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02019c2:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc02019c6:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc02019ca:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc02019ce:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc02019d2:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc02019d6:	02c77863          	bgeu	a4,a2,ffffffffc0201a06 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc02019da:	071a                	slli	a4,a4,0x6
ffffffffc02019dc:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc02019de:	41c686bb          	subw	a3,a3,t3
ffffffffc02019e2:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02019e4:	00870613          	addi	a2,a4,8
ffffffffc02019e8:	4689                	li	a3,2
ffffffffc02019ea:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc02019ee:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc02019f2:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc02019f6:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc02019fa:	e290                	sd	a2,0(a3)
ffffffffc02019fc:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0201a00:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0201a02:	01173c23          	sd	a7,24(a4)
ffffffffc0201a06:	41c8083b          	subw	a6,a6,t3
ffffffffc0201a0a:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201a0e:	5775                	li	a4,-3
ffffffffc0201a10:	17c1                	addi	a5,a5,-16
ffffffffc0201a12:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201a16:	8082                	ret
{
ffffffffc0201a18:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201a1a:	00005697          	auipc	a3,0x5
ffffffffc0201a1e:	cee68693          	addi	a3,a3,-786 # ffffffffc0206708 <commands+0xba0>
ffffffffc0201a22:	00005617          	auipc	a2,0x5
ffffffffc0201a26:	98e60613          	addi	a2,a2,-1650 # ffffffffc02063b0 <commands+0x848>
ffffffffc0201a2a:	06c00593          	li	a1,108
ffffffffc0201a2e:	00005517          	auipc	a0,0x5
ffffffffc0201a32:	99a50513          	addi	a0,a0,-1638 # ffffffffc02063c8 <commands+0x860>
{
ffffffffc0201a36:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201a38:	a57fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201a3c <default_init_memmap>:
{
ffffffffc0201a3c:	1141                	addi	sp,sp,-16
ffffffffc0201a3e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201a40:	c5f1                	beqz	a1,ffffffffc0201b0c <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc0201a42:	00659693          	slli	a3,a1,0x6
ffffffffc0201a46:	96aa                	add	a3,a3,a0
ffffffffc0201a48:	87aa                	mv	a5,a0
ffffffffc0201a4a:	00d50f63          	beq	a0,a3,ffffffffc0201a68 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201a4e:	6798                	ld	a4,8(a5)
ffffffffc0201a50:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc0201a52:	cf49                	beqz	a4,ffffffffc0201aec <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc0201a54:	0007a823          	sw	zero,16(a5)
ffffffffc0201a58:	0007b423          	sd	zero,8(a5)
ffffffffc0201a5c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201a60:	04078793          	addi	a5,a5,64
ffffffffc0201a64:	fed795e3          	bne	a5,a3,ffffffffc0201a4e <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201a68:	2581                	sext.w	a1,a1
ffffffffc0201a6a:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201a6c:	4789                	li	a5,2
ffffffffc0201a6e:	00850713          	addi	a4,a0,8
ffffffffc0201a72:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201a76:	000d9697          	auipc	a3,0xd9
ffffffffc0201a7a:	01a68693          	addi	a3,a3,26 # ffffffffc02daa90 <free_area>
ffffffffc0201a7e:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201a80:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201a82:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201a86:	9db9                	addw	a1,a1,a4
ffffffffc0201a88:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201a8a:	04d78a63          	beq	a5,a3,ffffffffc0201ade <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc0201a8e:	fe878713          	addi	a4,a5,-24
ffffffffc0201a92:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201a96:	4581                	li	a1,0
            if (base < page)
ffffffffc0201a98:	00e56a63          	bltu	a0,a4,ffffffffc0201aac <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201a9c:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201a9e:	02d70263          	beq	a4,a3,ffffffffc0201ac2 <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0201aa2:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201aa4:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201aa8:	fee57ae3          	bgeu	a0,a4,ffffffffc0201a9c <default_init_memmap+0x60>
ffffffffc0201aac:	c199                	beqz	a1,ffffffffc0201ab2 <default_init_memmap+0x76>
ffffffffc0201aae:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201ab2:	6398                	ld	a4,0(a5)
}
ffffffffc0201ab4:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201ab6:	e390                	sd	a2,0(a5)
ffffffffc0201ab8:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201aba:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201abc:	ed18                	sd	a4,24(a0)
ffffffffc0201abe:	0141                	addi	sp,sp,16
ffffffffc0201ac0:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201ac2:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201ac4:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201ac6:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201ac8:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201aca:	00d70663          	beq	a4,a3,ffffffffc0201ad6 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201ace:	8832                	mv	a6,a2
ffffffffc0201ad0:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201ad2:	87ba                	mv	a5,a4
ffffffffc0201ad4:	bfc1                	j	ffffffffc0201aa4 <default_init_memmap+0x68>
}
ffffffffc0201ad6:	60a2                	ld	ra,8(sp)
ffffffffc0201ad8:	e290                	sd	a2,0(a3)
ffffffffc0201ada:	0141                	addi	sp,sp,16
ffffffffc0201adc:	8082                	ret
ffffffffc0201ade:	60a2                	ld	ra,8(sp)
ffffffffc0201ae0:	e390                	sd	a2,0(a5)
ffffffffc0201ae2:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201ae4:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201ae6:	ed1c                	sd	a5,24(a0)
ffffffffc0201ae8:	0141                	addi	sp,sp,16
ffffffffc0201aea:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201aec:	00005697          	auipc	a3,0x5
ffffffffc0201af0:	c4c68693          	addi	a3,a3,-948 # ffffffffc0206738 <commands+0xbd0>
ffffffffc0201af4:	00005617          	auipc	a2,0x5
ffffffffc0201af8:	8bc60613          	addi	a2,a2,-1860 # ffffffffc02063b0 <commands+0x848>
ffffffffc0201afc:	04b00593          	li	a1,75
ffffffffc0201b00:	00005517          	auipc	a0,0x5
ffffffffc0201b04:	8c850513          	addi	a0,a0,-1848 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201b08:	987fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201b0c:	00005697          	auipc	a3,0x5
ffffffffc0201b10:	bfc68693          	addi	a3,a3,-1028 # ffffffffc0206708 <commands+0xba0>
ffffffffc0201b14:	00005617          	auipc	a2,0x5
ffffffffc0201b18:	89c60613          	addi	a2,a2,-1892 # ffffffffc02063b0 <commands+0x848>
ffffffffc0201b1c:	04700593          	li	a1,71
ffffffffc0201b20:	00005517          	auipc	a0,0x5
ffffffffc0201b24:	8a850513          	addi	a0,a0,-1880 # ffffffffc02063c8 <commands+0x860>
ffffffffc0201b28:	967fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201b2c <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201b2c:	c94d                	beqz	a0,ffffffffc0201bde <slob_free+0xb2>
{
ffffffffc0201b2e:	1141                	addi	sp,sp,-16
ffffffffc0201b30:	e022                	sd	s0,0(sp)
ffffffffc0201b32:	e406                	sd	ra,8(sp)
ffffffffc0201b34:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201b36:	e9c1                	bnez	a1,ffffffffc0201bc6 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b38:	100027f3          	csrr	a5,sstatus
ffffffffc0201b3c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b3e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b40:	ebd9                	bnez	a5,ffffffffc0201bd6 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b42:	000d9617          	auipc	a2,0xd9
ffffffffc0201b46:	b3e60613          	addi	a2,a2,-1218 # ffffffffc02da680 <slobfree>
ffffffffc0201b4a:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b4c:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b4e:	679c                	ld	a5,8(a5)
ffffffffc0201b50:	02877a63          	bgeu	a4,s0,ffffffffc0201b84 <slob_free+0x58>
ffffffffc0201b54:	00f46463          	bltu	s0,a5,ffffffffc0201b5c <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b58:	fef76ae3          	bltu	a4,a5,ffffffffc0201b4c <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201b5c:	400c                	lw	a1,0(s0)
ffffffffc0201b5e:	00459693          	slli	a3,a1,0x4
ffffffffc0201b62:	96a2                	add	a3,a3,s0
ffffffffc0201b64:	02d78a63          	beq	a5,a3,ffffffffc0201b98 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201b68:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201b6a:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201b6c:	00469793          	slli	a5,a3,0x4
ffffffffc0201b70:	97ba                	add	a5,a5,a4
ffffffffc0201b72:	02f40e63          	beq	s0,a5,ffffffffc0201bae <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201b76:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201b78:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201b7a:	e129                	bnez	a0,ffffffffc0201bbc <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201b7c:	60a2                	ld	ra,8(sp)
ffffffffc0201b7e:	6402                	ld	s0,0(sp)
ffffffffc0201b80:	0141                	addi	sp,sp,16
ffffffffc0201b82:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b84:	fcf764e3          	bltu	a4,a5,ffffffffc0201b4c <slob_free+0x20>
ffffffffc0201b88:	fcf472e3          	bgeu	s0,a5,ffffffffc0201b4c <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201b8c:	400c                	lw	a1,0(s0)
ffffffffc0201b8e:	00459693          	slli	a3,a1,0x4
ffffffffc0201b92:	96a2                	add	a3,a3,s0
ffffffffc0201b94:	fcd79ae3          	bne	a5,a3,ffffffffc0201b68 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201b98:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201b9a:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201b9c:	9db5                	addw	a1,a1,a3
ffffffffc0201b9e:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201ba0:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201ba2:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201ba4:	00469793          	slli	a5,a3,0x4
ffffffffc0201ba8:	97ba                	add	a5,a5,a4
ffffffffc0201baa:	fcf416e3          	bne	s0,a5,ffffffffc0201b76 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201bae:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201bb0:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201bb2:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201bb4:	9ebd                	addw	a3,a3,a5
ffffffffc0201bb6:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201bb8:	e70c                	sd	a1,8(a4)
ffffffffc0201bba:	d169                	beqz	a0,ffffffffc0201b7c <slob_free+0x50>
}
ffffffffc0201bbc:	6402                	ld	s0,0(sp)
ffffffffc0201bbe:	60a2                	ld	ra,8(sp)
ffffffffc0201bc0:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201bc2:	dedfe06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201bc6:	25bd                	addiw	a1,a1,15
ffffffffc0201bc8:	8191                	srli	a1,a1,0x4
ffffffffc0201bca:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bcc:	100027f3          	csrr	a5,sstatus
ffffffffc0201bd0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201bd2:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bd4:	d7bd                	beqz	a5,ffffffffc0201b42 <slob_free+0x16>
        intr_disable();
ffffffffc0201bd6:	ddffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201bda:	4505                	li	a0,1
ffffffffc0201bdc:	b79d                	j	ffffffffc0201b42 <slob_free+0x16>
ffffffffc0201bde:	8082                	ret

ffffffffc0201be0 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201be0:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201be2:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201be4:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201be8:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201bea:	352000ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
	if (!page)
ffffffffc0201bee:	c91d                	beqz	a0,ffffffffc0201c24 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201bf0:	000dd697          	auipc	a3,0xdd
ffffffffc0201bf4:	f186b683          	ld	a3,-232(a3) # ffffffffc02deb08 <pages>
ffffffffc0201bf8:	8d15                	sub	a0,a0,a3
ffffffffc0201bfa:	8519                	srai	a0,a0,0x6
ffffffffc0201bfc:	00006697          	auipc	a3,0x6
ffffffffc0201c00:	05c6b683          	ld	a3,92(a3) # ffffffffc0207c58 <nbase>
ffffffffc0201c04:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201c06:	00c51793          	slli	a5,a0,0xc
ffffffffc0201c0a:	83b1                	srli	a5,a5,0xc
ffffffffc0201c0c:	000dd717          	auipc	a4,0xdd
ffffffffc0201c10:	ef473703          	ld	a4,-268(a4) # ffffffffc02deb00 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c14:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201c16:	00e7fa63          	bgeu	a5,a4,ffffffffc0201c2a <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201c1a:	000dd697          	auipc	a3,0xdd
ffffffffc0201c1e:	efe6b683          	ld	a3,-258(a3) # ffffffffc02deb18 <va_pa_offset>
ffffffffc0201c22:	9536                	add	a0,a0,a3
}
ffffffffc0201c24:	60a2                	ld	ra,8(sp)
ffffffffc0201c26:	0141                	addi	sp,sp,16
ffffffffc0201c28:	8082                	ret
ffffffffc0201c2a:	86aa                	mv	a3,a0
ffffffffc0201c2c:	00005617          	auipc	a2,0x5
ffffffffc0201c30:	b6c60613          	addi	a2,a2,-1172 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc0201c34:	07100593          	li	a1,113
ffffffffc0201c38:	00005517          	auipc	a0,0x5
ffffffffc0201c3c:	b8850513          	addi	a0,a0,-1144 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc0201c40:	84ffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201c44 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201c44:	1101                	addi	sp,sp,-32
ffffffffc0201c46:	ec06                	sd	ra,24(sp)
ffffffffc0201c48:	e822                	sd	s0,16(sp)
ffffffffc0201c4a:	e426                	sd	s1,8(sp)
ffffffffc0201c4c:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c4e:	01050713          	addi	a4,a0,16
ffffffffc0201c52:	6785                	lui	a5,0x1
ffffffffc0201c54:	0cf77363          	bgeu	a4,a5,ffffffffc0201d1a <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201c58:	00f50493          	addi	s1,a0,15
ffffffffc0201c5c:	8091                	srli	s1,s1,0x4
ffffffffc0201c5e:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c60:	10002673          	csrr	a2,sstatus
ffffffffc0201c64:	8a09                	andi	a2,a2,2
ffffffffc0201c66:	e25d                	bnez	a2,ffffffffc0201d0c <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201c68:	000d9917          	auipc	s2,0xd9
ffffffffc0201c6c:	a1890913          	addi	s2,s2,-1512 # ffffffffc02da680 <slobfree>
ffffffffc0201c70:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c74:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201c76:	4398                	lw	a4,0(a5)
ffffffffc0201c78:	08975e63          	bge	a4,s1,ffffffffc0201d14 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201c7c:	00f68b63          	beq	a3,a5,ffffffffc0201c92 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c80:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201c82:	4018                	lw	a4,0(s0)
ffffffffc0201c84:	02975a63          	bge	a4,s1,ffffffffc0201cb8 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201c88:	00093683          	ld	a3,0(s2)
ffffffffc0201c8c:	87a2                	mv	a5,s0
ffffffffc0201c8e:	fef699e3          	bne	a3,a5,ffffffffc0201c80 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201c92:	ee31                	bnez	a2,ffffffffc0201cee <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201c94:	4501                	li	a0,0
ffffffffc0201c96:	f4bff0ef          	jal	ra,ffffffffc0201be0 <__slob_get_free_pages.constprop.0>
ffffffffc0201c9a:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201c9c:	cd05                	beqz	a0,ffffffffc0201cd4 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201c9e:	6585                	lui	a1,0x1
ffffffffc0201ca0:	e8dff0ef          	jal	ra,ffffffffc0201b2c <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ca4:	10002673          	csrr	a2,sstatus
ffffffffc0201ca8:	8a09                	andi	a2,a2,2
ffffffffc0201caa:	ee05                	bnez	a2,ffffffffc0201ce2 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201cac:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201cb0:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201cb2:	4018                	lw	a4,0(s0)
ffffffffc0201cb4:	fc974ae3          	blt	a4,s1,ffffffffc0201c88 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201cb8:	04e48763          	beq	s1,a4,ffffffffc0201d06 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201cbc:	00449693          	slli	a3,s1,0x4
ffffffffc0201cc0:	96a2                	add	a3,a3,s0
ffffffffc0201cc2:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201cc4:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201cc6:	9f05                	subw	a4,a4,s1
ffffffffc0201cc8:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201cca:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201ccc:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201cce:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201cd2:	e20d                	bnez	a2,ffffffffc0201cf4 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201cd4:	60e2                	ld	ra,24(sp)
ffffffffc0201cd6:	8522                	mv	a0,s0
ffffffffc0201cd8:	6442                	ld	s0,16(sp)
ffffffffc0201cda:	64a2                	ld	s1,8(sp)
ffffffffc0201cdc:	6902                	ld	s2,0(sp)
ffffffffc0201cde:	6105                	addi	sp,sp,32
ffffffffc0201ce0:	8082                	ret
        intr_disable();
ffffffffc0201ce2:	cd3fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc0201ce6:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201cea:	4605                	li	a2,1
ffffffffc0201cec:	b7d1                	j	ffffffffc0201cb0 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201cee:	cc1fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201cf2:	b74d                	j	ffffffffc0201c94 <slob_alloc.constprop.0+0x50>
ffffffffc0201cf4:	cbbfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc0201cf8:	60e2                	ld	ra,24(sp)
ffffffffc0201cfa:	8522                	mv	a0,s0
ffffffffc0201cfc:	6442                	ld	s0,16(sp)
ffffffffc0201cfe:	64a2                	ld	s1,8(sp)
ffffffffc0201d00:	6902                	ld	s2,0(sp)
ffffffffc0201d02:	6105                	addi	sp,sp,32
ffffffffc0201d04:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201d06:	6418                	ld	a4,8(s0)
ffffffffc0201d08:	e798                	sd	a4,8(a5)
ffffffffc0201d0a:	b7d1                	j	ffffffffc0201cce <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201d0c:	ca9fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201d10:	4605                	li	a2,1
ffffffffc0201d12:	bf99                	j	ffffffffc0201c68 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201d14:	843e                	mv	s0,a5
ffffffffc0201d16:	87b6                	mv	a5,a3
ffffffffc0201d18:	b745                	j	ffffffffc0201cb8 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201d1a:	00005697          	auipc	a3,0x5
ffffffffc0201d1e:	ab668693          	addi	a3,a3,-1354 # ffffffffc02067d0 <default_pmm_manager+0x70>
ffffffffc0201d22:	00004617          	auipc	a2,0x4
ffffffffc0201d26:	68e60613          	addi	a2,a2,1678 # ffffffffc02063b0 <commands+0x848>
ffffffffc0201d2a:	06300593          	li	a1,99
ffffffffc0201d2e:	00005517          	auipc	a0,0x5
ffffffffc0201d32:	ac250513          	addi	a0,a0,-1342 # ffffffffc02067f0 <default_pmm_manager+0x90>
ffffffffc0201d36:	f58fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201d3a <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201d3a:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201d3c:	00005517          	auipc	a0,0x5
ffffffffc0201d40:	acc50513          	addi	a0,a0,-1332 # ffffffffc0206808 <default_pmm_manager+0xa8>
{
ffffffffc0201d44:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201d46:	c4efe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201d4a:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201d4c:	00005517          	auipc	a0,0x5
ffffffffc0201d50:	ad450513          	addi	a0,a0,-1324 # ffffffffc0206820 <default_pmm_manager+0xc0>
}
ffffffffc0201d54:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201d56:	c3efe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201d5a <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201d5a:	4501                	li	a0,0
ffffffffc0201d5c:	8082                	ret

ffffffffc0201d5e <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201d5e:	1101                	addi	sp,sp,-32
ffffffffc0201d60:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d62:	6905                	lui	s2,0x1
{
ffffffffc0201d64:	e822                	sd	s0,16(sp)
ffffffffc0201d66:	ec06                	sd	ra,24(sp)
ffffffffc0201d68:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d6a:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bb1>
{
ffffffffc0201d6e:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d70:	04a7f963          	bgeu	a5,a0,ffffffffc0201dc2 <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201d74:	4561                	li	a0,24
ffffffffc0201d76:	ecfff0ef          	jal	ra,ffffffffc0201c44 <slob_alloc.constprop.0>
ffffffffc0201d7a:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201d7c:	c929                	beqz	a0,ffffffffc0201dce <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201d7e:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201d82:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201d84:	00f95763          	bge	s2,a5,ffffffffc0201d92 <kmalloc+0x34>
ffffffffc0201d88:	6705                	lui	a4,0x1
ffffffffc0201d8a:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201d8c:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201d8e:	fef74ee3          	blt	a4,a5,ffffffffc0201d8a <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201d92:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201d94:	e4dff0ef          	jal	ra,ffffffffc0201be0 <__slob_get_free_pages.constprop.0>
ffffffffc0201d98:	e488                	sd	a0,8(s1)
ffffffffc0201d9a:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201d9c:	c525                	beqz	a0,ffffffffc0201e04 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d9e:	100027f3          	csrr	a5,sstatus
ffffffffc0201da2:	8b89                	andi	a5,a5,2
ffffffffc0201da4:	ef8d                	bnez	a5,ffffffffc0201dde <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201da6:	000dd797          	auipc	a5,0xdd
ffffffffc0201daa:	d4278793          	addi	a5,a5,-702 # ffffffffc02deae8 <bigblocks>
ffffffffc0201dae:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201db0:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201db2:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201db4:	60e2                	ld	ra,24(sp)
ffffffffc0201db6:	8522                	mv	a0,s0
ffffffffc0201db8:	6442                	ld	s0,16(sp)
ffffffffc0201dba:	64a2                	ld	s1,8(sp)
ffffffffc0201dbc:	6902                	ld	s2,0(sp)
ffffffffc0201dbe:	6105                	addi	sp,sp,32
ffffffffc0201dc0:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201dc2:	0541                	addi	a0,a0,16
ffffffffc0201dc4:	e81ff0ef          	jal	ra,ffffffffc0201c44 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201dc8:	01050413          	addi	s0,a0,16
ffffffffc0201dcc:	f565                	bnez	a0,ffffffffc0201db4 <kmalloc+0x56>
ffffffffc0201dce:	4401                	li	s0,0
}
ffffffffc0201dd0:	60e2                	ld	ra,24(sp)
ffffffffc0201dd2:	8522                	mv	a0,s0
ffffffffc0201dd4:	6442                	ld	s0,16(sp)
ffffffffc0201dd6:	64a2                	ld	s1,8(sp)
ffffffffc0201dd8:	6902                	ld	s2,0(sp)
ffffffffc0201dda:	6105                	addi	sp,sp,32
ffffffffc0201ddc:	8082                	ret
        intr_disable();
ffffffffc0201dde:	bd7fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201de2:	000dd797          	auipc	a5,0xdd
ffffffffc0201de6:	d0678793          	addi	a5,a5,-762 # ffffffffc02deae8 <bigblocks>
ffffffffc0201dea:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201dec:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201dee:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201df0:	bbffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc0201df4:	6480                	ld	s0,8(s1)
}
ffffffffc0201df6:	60e2                	ld	ra,24(sp)
ffffffffc0201df8:	64a2                	ld	s1,8(sp)
ffffffffc0201dfa:	8522                	mv	a0,s0
ffffffffc0201dfc:	6442                	ld	s0,16(sp)
ffffffffc0201dfe:	6902                	ld	s2,0(sp)
ffffffffc0201e00:	6105                	addi	sp,sp,32
ffffffffc0201e02:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e04:	45e1                	li	a1,24
ffffffffc0201e06:	8526                	mv	a0,s1
ffffffffc0201e08:	d25ff0ef          	jal	ra,ffffffffc0201b2c <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201e0c:	b765                	j	ffffffffc0201db4 <kmalloc+0x56>

ffffffffc0201e0e <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201e0e:	c169                	beqz	a0,ffffffffc0201ed0 <kfree+0xc2>
{
ffffffffc0201e10:	1101                	addi	sp,sp,-32
ffffffffc0201e12:	e822                	sd	s0,16(sp)
ffffffffc0201e14:	ec06                	sd	ra,24(sp)
ffffffffc0201e16:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201e18:	03451793          	slli	a5,a0,0x34
ffffffffc0201e1c:	842a                	mv	s0,a0
ffffffffc0201e1e:	e3d9                	bnez	a5,ffffffffc0201ea4 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e20:	100027f3          	csrr	a5,sstatus
ffffffffc0201e24:	8b89                	andi	a5,a5,2
ffffffffc0201e26:	e7d9                	bnez	a5,ffffffffc0201eb4 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e28:	000dd797          	auipc	a5,0xdd
ffffffffc0201e2c:	cc07b783          	ld	a5,-832(a5) # ffffffffc02deae8 <bigblocks>
    return 0;
ffffffffc0201e30:	4601                	li	a2,0
ffffffffc0201e32:	cbad                	beqz	a5,ffffffffc0201ea4 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201e34:	000dd697          	auipc	a3,0xdd
ffffffffc0201e38:	cb468693          	addi	a3,a3,-844 # ffffffffc02deae8 <bigblocks>
ffffffffc0201e3c:	a021                	j	ffffffffc0201e44 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e3e:	01048693          	addi	a3,s1,16
ffffffffc0201e42:	c3a5                	beqz	a5,ffffffffc0201ea2 <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201e44:	6798                	ld	a4,8(a5)
ffffffffc0201e46:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201e48:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201e4a:	fe871ae3          	bne	a4,s0,ffffffffc0201e3e <kfree+0x30>
				*last = bb->next;
ffffffffc0201e4e:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201e50:	ee2d                	bnez	a2,ffffffffc0201eca <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201e52:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201e56:	4098                	lw	a4,0(s1)
ffffffffc0201e58:	08f46963          	bltu	s0,a5,ffffffffc0201eea <kfree+0xdc>
ffffffffc0201e5c:	000dd697          	auipc	a3,0xdd
ffffffffc0201e60:	cbc6b683          	ld	a3,-836(a3) # ffffffffc02deb18 <va_pa_offset>
ffffffffc0201e64:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201e66:	8031                	srli	s0,s0,0xc
ffffffffc0201e68:	000dd797          	auipc	a5,0xdd
ffffffffc0201e6c:	c987b783          	ld	a5,-872(a5) # ffffffffc02deb00 <npage>
ffffffffc0201e70:	06f47163          	bgeu	s0,a5,ffffffffc0201ed2 <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201e74:	00006517          	auipc	a0,0x6
ffffffffc0201e78:	de453503          	ld	a0,-540(a0) # ffffffffc0207c58 <nbase>
ffffffffc0201e7c:	8c09                	sub	s0,s0,a0
ffffffffc0201e7e:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201e80:	000dd517          	auipc	a0,0xdd
ffffffffc0201e84:	c8853503          	ld	a0,-888(a0) # ffffffffc02deb08 <pages>
ffffffffc0201e88:	4585                	li	a1,1
ffffffffc0201e8a:	9522                	add	a0,a0,s0
ffffffffc0201e8c:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201e90:	0ea000ef          	jal	ra,ffffffffc0201f7a <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201e94:	6442                	ld	s0,16(sp)
ffffffffc0201e96:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e98:	8526                	mv	a0,s1
}
ffffffffc0201e9a:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e9c:	45e1                	li	a1,24
}
ffffffffc0201e9e:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201ea0:	b171                	j	ffffffffc0201b2c <slob_free>
ffffffffc0201ea2:	e20d                	bnez	a2,ffffffffc0201ec4 <kfree+0xb6>
ffffffffc0201ea4:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201ea8:	6442                	ld	s0,16(sp)
ffffffffc0201eaa:	60e2                	ld	ra,24(sp)
ffffffffc0201eac:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201eae:	4581                	li	a1,0
}
ffffffffc0201eb0:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201eb2:	b9ad                	j	ffffffffc0201b2c <slob_free>
        intr_disable();
ffffffffc0201eb4:	b01fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201eb8:	000dd797          	auipc	a5,0xdd
ffffffffc0201ebc:	c307b783          	ld	a5,-976(a5) # ffffffffc02deae8 <bigblocks>
        return 1;
ffffffffc0201ec0:	4605                	li	a2,1
ffffffffc0201ec2:	fbad                	bnez	a5,ffffffffc0201e34 <kfree+0x26>
        intr_enable();
ffffffffc0201ec4:	aebfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201ec8:	bff1                	j	ffffffffc0201ea4 <kfree+0x96>
ffffffffc0201eca:	ae5fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201ece:	b751                	j	ffffffffc0201e52 <kfree+0x44>
ffffffffc0201ed0:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201ed2:	00005617          	auipc	a2,0x5
ffffffffc0201ed6:	99660613          	addi	a2,a2,-1642 # ffffffffc0206868 <default_pmm_manager+0x108>
ffffffffc0201eda:	06900593          	li	a1,105
ffffffffc0201ede:	00005517          	auipc	a0,0x5
ffffffffc0201ee2:	8e250513          	addi	a0,a0,-1822 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc0201ee6:	da8fe0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201eea:	86a2                	mv	a3,s0
ffffffffc0201eec:	00005617          	auipc	a2,0x5
ffffffffc0201ef0:	95460613          	addi	a2,a2,-1708 # ffffffffc0206840 <default_pmm_manager+0xe0>
ffffffffc0201ef4:	07700593          	li	a1,119
ffffffffc0201ef8:	00005517          	auipc	a0,0x5
ffffffffc0201efc:	8c850513          	addi	a0,a0,-1848 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc0201f00:	d8efe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201f04 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201f04:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201f06:	00005617          	auipc	a2,0x5
ffffffffc0201f0a:	96260613          	addi	a2,a2,-1694 # ffffffffc0206868 <default_pmm_manager+0x108>
ffffffffc0201f0e:	06900593          	li	a1,105
ffffffffc0201f12:	00005517          	auipc	a0,0x5
ffffffffc0201f16:	8ae50513          	addi	a0,a0,-1874 # ffffffffc02067c0 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201f1a:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201f1c:	d72fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201f20 <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201f20:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201f22:	00005617          	auipc	a2,0x5
ffffffffc0201f26:	96660613          	addi	a2,a2,-1690 # ffffffffc0206888 <default_pmm_manager+0x128>
ffffffffc0201f2a:	07f00593          	li	a1,127
ffffffffc0201f2e:	00005517          	auipc	a0,0x5
ffffffffc0201f32:	89250513          	addi	a0,a0,-1902 # ffffffffc02067c0 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201f36:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201f38:	d56fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201f3c <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f3c:	100027f3          	csrr	a5,sstatus
ffffffffc0201f40:	8b89                	andi	a5,a5,2
ffffffffc0201f42:	e799                	bnez	a5,ffffffffc0201f50 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f44:	000dd797          	auipc	a5,0xdd
ffffffffc0201f48:	bcc7b783          	ld	a5,-1076(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc0201f4c:	6f9c                	ld	a5,24(a5)
ffffffffc0201f4e:	8782                	jr	a5
{
ffffffffc0201f50:	1141                	addi	sp,sp,-16
ffffffffc0201f52:	e406                	sd	ra,8(sp)
ffffffffc0201f54:	e022                	sd	s0,0(sp)
ffffffffc0201f56:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201f58:	a5dfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f5c:	000dd797          	auipc	a5,0xdd
ffffffffc0201f60:	bb47b783          	ld	a5,-1100(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc0201f64:	6f9c                	ld	a5,24(a5)
ffffffffc0201f66:	8522                	mv	a0,s0
ffffffffc0201f68:	9782                	jalr	a5
ffffffffc0201f6a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201f6c:	a43fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201f70:	60a2                	ld	ra,8(sp)
ffffffffc0201f72:	8522                	mv	a0,s0
ffffffffc0201f74:	6402                	ld	s0,0(sp)
ffffffffc0201f76:	0141                	addi	sp,sp,16
ffffffffc0201f78:	8082                	ret

ffffffffc0201f7a <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f7a:	100027f3          	csrr	a5,sstatus
ffffffffc0201f7e:	8b89                	andi	a5,a5,2
ffffffffc0201f80:	e799                	bnez	a5,ffffffffc0201f8e <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201f82:	000dd797          	auipc	a5,0xdd
ffffffffc0201f86:	b8e7b783          	ld	a5,-1138(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc0201f8a:	739c                	ld	a5,32(a5)
ffffffffc0201f8c:	8782                	jr	a5
{
ffffffffc0201f8e:	1101                	addi	sp,sp,-32
ffffffffc0201f90:	ec06                	sd	ra,24(sp)
ffffffffc0201f92:	e822                	sd	s0,16(sp)
ffffffffc0201f94:	e426                	sd	s1,8(sp)
ffffffffc0201f96:	842a                	mv	s0,a0
ffffffffc0201f98:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201f9a:	a1bfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f9e:	000dd797          	auipc	a5,0xdd
ffffffffc0201fa2:	b727b783          	ld	a5,-1166(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc0201fa6:	739c                	ld	a5,32(a5)
ffffffffc0201fa8:	85a6                	mv	a1,s1
ffffffffc0201faa:	8522                	mv	a0,s0
ffffffffc0201fac:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201fae:	6442                	ld	s0,16(sp)
ffffffffc0201fb0:	60e2                	ld	ra,24(sp)
ffffffffc0201fb2:	64a2                	ld	s1,8(sp)
ffffffffc0201fb4:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201fb6:	9f9fe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc0201fba <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201fba:	100027f3          	csrr	a5,sstatus
ffffffffc0201fbe:	8b89                	andi	a5,a5,2
ffffffffc0201fc0:	e799                	bnez	a5,ffffffffc0201fce <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201fc2:	000dd797          	auipc	a5,0xdd
ffffffffc0201fc6:	b4e7b783          	ld	a5,-1202(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc0201fca:	779c                	ld	a5,40(a5)
ffffffffc0201fcc:	8782                	jr	a5
{
ffffffffc0201fce:	1141                	addi	sp,sp,-16
ffffffffc0201fd0:	e406                	sd	ra,8(sp)
ffffffffc0201fd2:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201fd4:	9e1fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201fd8:	000dd797          	auipc	a5,0xdd
ffffffffc0201fdc:	b387b783          	ld	a5,-1224(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc0201fe0:	779c                	ld	a5,40(a5)
ffffffffc0201fe2:	9782                	jalr	a5
ffffffffc0201fe4:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201fe6:	9c9fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201fea:	60a2                	ld	ra,8(sp)
ffffffffc0201fec:	8522                	mv	a0,s0
ffffffffc0201fee:	6402                	ld	s0,0(sp)
ffffffffc0201ff0:	0141                	addi	sp,sp,16
ffffffffc0201ff2:	8082                	ret

ffffffffc0201ff4 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201ff4:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201ff8:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201ffc:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201ffe:	078e                	slli	a5,a5,0x3
{
ffffffffc0202000:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202002:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0202006:	6094                	ld	a3,0(s1)
{
ffffffffc0202008:	f04a                	sd	s2,32(sp)
ffffffffc020200a:	ec4e                	sd	s3,24(sp)
ffffffffc020200c:	e852                	sd	s4,16(sp)
ffffffffc020200e:	fc06                	sd	ra,56(sp)
ffffffffc0202010:	f822                	sd	s0,48(sp)
ffffffffc0202012:	e456                	sd	s5,8(sp)
ffffffffc0202014:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0202016:	0016f793          	andi	a5,a3,1
{
ffffffffc020201a:	892e                	mv	s2,a1
ffffffffc020201c:	8a32                	mv	s4,a2
ffffffffc020201e:	000dd997          	auipc	s3,0xdd
ffffffffc0202022:	ae298993          	addi	s3,s3,-1310 # ffffffffc02deb00 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0202026:	efbd                	bnez	a5,ffffffffc02020a4 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202028:	14060c63          	beqz	a2,ffffffffc0202180 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020202c:	100027f3          	csrr	a5,sstatus
ffffffffc0202030:	8b89                	andi	a5,a5,2
ffffffffc0202032:	14079963          	bnez	a5,ffffffffc0202184 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202036:	000dd797          	auipc	a5,0xdd
ffffffffc020203a:	ada7b783          	ld	a5,-1318(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc020203e:	6f9c                	ld	a5,24(a5)
ffffffffc0202040:	4505                	li	a0,1
ffffffffc0202042:	9782                	jalr	a5
ffffffffc0202044:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202046:	12040d63          	beqz	s0,ffffffffc0202180 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc020204a:	000ddb17          	auipc	s6,0xdd
ffffffffc020204e:	abeb0b13          	addi	s6,s6,-1346 # ffffffffc02deb08 <pages>
ffffffffc0202052:	000b3503          	ld	a0,0(s6)
ffffffffc0202056:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020205a:	000dd997          	auipc	s3,0xdd
ffffffffc020205e:	aa698993          	addi	s3,s3,-1370 # ffffffffc02deb00 <npage>
ffffffffc0202062:	40a40533          	sub	a0,s0,a0
ffffffffc0202066:	8519                	srai	a0,a0,0x6
ffffffffc0202068:	9556                	add	a0,a0,s5
ffffffffc020206a:	0009b703          	ld	a4,0(s3)
ffffffffc020206e:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202072:	4685                	li	a3,1
ffffffffc0202074:	c014                	sw	a3,0(s0)
ffffffffc0202076:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202078:	0532                	slli	a0,a0,0xc
ffffffffc020207a:	16e7f763          	bgeu	a5,a4,ffffffffc02021e8 <get_pte+0x1f4>
ffffffffc020207e:	000dd797          	auipc	a5,0xdd
ffffffffc0202082:	a9a7b783          	ld	a5,-1382(a5) # ffffffffc02deb18 <va_pa_offset>
ffffffffc0202086:	6605                	lui	a2,0x1
ffffffffc0202088:	4581                	li	a1,0
ffffffffc020208a:	953e                	add	a0,a0,a5
ffffffffc020208c:	045030ef          	jal	ra,ffffffffc02058d0 <memset>
    return page - pages + nbase;
ffffffffc0202090:	000b3683          	ld	a3,0(s6)
ffffffffc0202094:	40d406b3          	sub	a3,s0,a3
ffffffffc0202098:	8699                	srai	a3,a3,0x6
ffffffffc020209a:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020209c:	06aa                	slli	a3,a3,0xa
ffffffffc020209e:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02020a2:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02020a4:	77fd                	lui	a5,0xfffff
ffffffffc02020a6:	068a                	slli	a3,a3,0x2
ffffffffc02020a8:	0009b703          	ld	a4,0(s3)
ffffffffc02020ac:	8efd                	and	a3,a3,a5
ffffffffc02020ae:	00c6d793          	srli	a5,a3,0xc
ffffffffc02020b2:	10e7ff63          	bgeu	a5,a4,ffffffffc02021d0 <get_pte+0x1dc>
ffffffffc02020b6:	000dda97          	auipc	s5,0xdd
ffffffffc02020ba:	a62a8a93          	addi	s5,s5,-1438 # ffffffffc02deb18 <va_pa_offset>
ffffffffc02020be:	000ab403          	ld	s0,0(s5)
ffffffffc02020c2:	01595793          	srli	a5,s2,0x15
ffffffffc02020c6:	1ff7f793          	andi	a5,a5,511
ffffffffc02020ca:	96a2                	add	a3,a3,s0
ffffffffc02020cc:	00379413          	slli	s0,a5,0x3
ffffffffc02020d0:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc02020d2:	6014                	ld	a3,0(s0)
ffffffffc02020d4:	0016f793          	andi	a5,a3,1
ffffffffc02020d8:	ebad                	bnez	a5,ffffffffc020214a <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02020da:	0a0a0363          	beqz	s4,ffffffffc0202180 <get_pte+0x18c>
ffffffffc02020de:	100027f3          	csrr	a5,sstatus
ffffffffc02020e2:	8b89                	andi	a5,a5,2
ffffffffc02020e4:	efcd                	bnez	a5,ffffffffc020219e <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc02020e6:	000dd797          	auipc	a5,0xdd
ffffffffc02020ea:	a2a7b783          	ld	a5,-1494(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc02020ee:	6f9c                	ld	a5,24(a5)
ffffffffc02020f0:	4505                	li	a0,1
ffffffffc02020f2:	9782                	jalr	a5
ffffffffc02020f4:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02020f6:	c4c9                	beqz	s1,ffffffffc0202180 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc02020f8:	000ddb17          	auipc	s6,0xdd
ffffffffc02020fc:	a10b0b13          	addi	s6,s6,-1520 # ffffffffc02deb08 <pages>
ffffffffc0202100:	000b3503          	ld	a0,0(s6)
ffffffffc0202104:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202108:	0009b703          	ld	a4,0(s3)
ffffffffc020210c:	40a48533          	sub	a0,s1,a0
ffffffffc0202110:	8519                	srai	a0,a0,0x6
ffffffffc0202112:	9552                	add	a0,a0,s4
ffffffffc0202114:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202118:	4685                	li	a3,1
ffffffffc020211a:	c094                	sw	a3,0(s1)
ffffffffc020211c:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020211e:	0532                	slli	a0,a0,0xc
ffffffffc0202120:	0ee7f163          	bgeu	a5,a4,ffffffffc0202202 <get_pte+0x20e>
ffffffffc0202124:	000ab783          	ld	a5,0(s5)
ffffffffc0202128:	6605                	lui	a2,0x1
ffffffffc020212a:	4581                	li	a1,0
ffffffffc020212c:	953e                	add	a0,a0,a5
ffffffffc020212e:	7a2030ef          	jal	ra,ffffffffc02058d0 <memset>
    return page - pages + nbase;
ffffffffc0202132:	000b3683          	ld	a3,0(s6)
ffffffffc0202136:	40d486b3          	sub	a3,s1,a3
ffffffffc020213a:	8699                	srai	a3,a3,0x6
ffffffffc020213c:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020213e:	06aa                	slli	a3,a3,0xa
ffffffffc0202140:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202144:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202146:	0009b703          	ld	a4,0(s3)
ffffffffc020214a:	068a                	slli	a3,a3,0x2
ffffffffc020214c:	757d                	lui	a0,0xfffff
ffffffffc020214e:	8ee9                	and	a3,a3,a0
ffffffffc0202150:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202154:	06e7f263          	bgeu	a5,a4,ffffffffc02021b8 <get_pte+0x1c4>
ffffffffc0202158:	000ab503          	ld	a0,0(s5)
ffffffffc020215c:	00c95913          	srli	s2,s2,0xc
ffffffffc0202160:	1ff97913          	andi	s2,s2,511
ffffffffc0202164:	96aa                	add	a3,a3,a0
ffffffffc0202166:	00391513          	slli	a0,s2,0x3
ffffffffc020216a:	9536                	add	a0,a0,a3
}
ffffffffc020216c:	70e2                	ld	ra,56(sp)
ffffffffc020216e:	7442                	ld	s0,48(sp)
ffffffffc0202170:	74a2                	ld	s1,40(sp)
ffffffffc0202172:	7902                	ld	s2,32(sp)
ffffffffc0202174:	69e2                	ld	s3,24(sp)
ffffffffc0202176:	6a42                	ld	s4,16(sp)
ffffffffc0202178:	6aa2                	ld	s5,8(sp)
ffffffffc020217a:	6b02                	ld	s6,0(sp)
ffffffffc020217c:	6121                	addi	sp,sp,64
ffffffffc020217e:	8082                	ret
            return NULL;
ffffffffc0202180:	4501                	li	a0,0
ffffffffc0202182:	b7ed                	j	ffffffffc020216c <get_pte+0x178>
        intr_disable();
ffffffffc0202184:	831fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202188:	000dd797          	auipc	a5,0xdd
ffffffffc020218c:	9887b783          	ld	a5,-1656(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc0202190:	6f9c                	ld	a5,24(a5)
ffffffffc0202192:	4505                	li	a0,1
ffffffffc0202194:	9782                	jalr	a5
ffffffffc0202196:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202198:	817fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020219c:	b56d                	j	ffffffffc0202046 <get_pte+0x52>
        intr_disable();
ffffffffc020219e:	817fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02021a2:	000dd797          	auipc	a5,0xdd
ffffffffc02021a6:	96e7b783          	ld	a5,-1682(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc02021aa:	6f9c                	ld	a5,24(a5)
ffffffffc02021ac:	4505                	li	a0,1
ffffffffc02021ae:	9782                	jalr	a5
ffffffffc02021b0:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc02021b2:	ffcfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02021b6:	b781                	j	ffffffffc02020f6 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02021b8:	00004617          	auipc	a2,0x4
ffffffffc02021bc:	5e060613          	addi	a2,a2,1504 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc02021c0:	0fa00593          	li	a1,250
ffffffffc02021c4:	00004517          	auipc	a0,0x4
ffffffffc02021c8:	6ec50513          	addi	a0,a0,1772 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02021cc:	ac2fe0ef          	jal	ra,ffffffffc020048e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02021d0:	00004617          	auipc	a2,0x4
ffffffffc02021d4:	5c860613          	addi	a2,a2,1480 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc02021d8:	0ed00593          	li	a1,237
ffffffffc02021dc:	00004517          	auipc	a0,0x4
ffffffffc02021e0:	6d450513          	addi	a0,a0,1748 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02021e4:	aaafe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02021e8:	86aa                	mv	a3,a0
ffffffffc02021ea:	00004617          	auipc	a2,0x4
ffffffffc02021ee:	5ae60613          	addi	a2,a2,1454 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc02021f2:	0e900593          	li	a1,233
ffffffffc02021f6:	00004517          	auipc	a0,0x4
ffffffffc02021fa:	6ba50513          	addi	a0,a0,1722 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02021fe:	a90fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202202:	86aa                	mv	a3,a0
ffffffffc0202204:	00004617          	auipc	a2,0x4
ffffffffc0202208:	59460613          	addi	a2,a2,1428 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc020220c:	0f700593          	li	a1,247
ffffffffc0202210:	00004517          	auipc	a0,0x4
ffffffffc0202214:	6a050513          	addi	a0,a0,1696 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0202218:	a76fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020221c <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc020221c:	1141                	addi	sp,sp,-16
ffffffffc020221e:	e022                	sd	s0,0(sp)
ffffffffc0202220:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202222:	4601                	li	a2,0
{
ffffffffc0202224:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202226:	dcfff0ef          	jal	ra,ffffffffc0201ff4 <get_pte>
    if (ptep_store != NULL)
ffffffffc020222a:	c011                	beqz	s0,ffffffffc020222e <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc020222c:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020222e:	c511                	beqz	a0,ffffffffc020223a <get_page+0x1e>
ffffffffc0202230:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202232:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202234:	0017f713          	andi	a4,a5,1
ffffffffc0202238:	e709                	bnez	a4,ffffffffc0202242 <get_page+0x26>
}
ffffffffc020223a:	60a2                	ld	ra,8(sp)
ffffffffc020223c:	6402                	ld	s0,0(sp)
ffffffffc020223e:	0141                	addi	sp,sp,16
ffffffffc0202240:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202242:	078a                	slli	a5,a5,0x2
ffffffffc0202244:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202246:	000dd717          	auipc	a4,0xdd
ffffffffc020224a:	8ba73703          	ld	a4,-1862(a4) # ffffffffc02deb00 <npage>
ffffffffc020224e:	00e7ff63          	bgeu	a5,a4,ffffffffc020226c <get_page+0x50>
ffffffffc0202252:	60a2                	ld	ra,8(sp)
ffffffffc0202254:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc0202256:	fff80537          	lui	a0,0xfff80
ffffffffc020225a:	97aa                	add	a5,a5,a0
ffffffffc020225c:	079a                	slli	a5,a5,0x6
ffffffffc020225e:	000dd517          	auipc	a0,0xdd
ffffffffc0202262:	8aa53503          	ld	a0,-1878(a0) # ffffffffc02deb08 <pages>
ffffffffc0202266:	953e                	add	a0,a0,a5
ffffffffc0202268:	0141                	addi	sp,sp,16
ffffffffc020226a:	8082                	ret
ffffffffc020226c:	c99ff0ef          	jal	ra,ffffffffc0201f04 <pa2page.part.0>

ffffffffc0202270 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202270:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202272:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202276:	f486                	sd	ra,104(sp)
ffffffffc0202278:	f0a2                	sd	s0,96(sp)
ffffffffc020227a:	eca6                	sd	s1,88(sp)
ffffffffc020227c:	e8ca                	sd	s2,80(sp)
ffffffffc020227e:	e4ce                	sd	s3,72(sp)
ffffffffc0202280:	e0d2                	sd	s4,64(sp)
ffffffffc0202282:	fc56                	sd	s5,56(sp)
ffffffffc0202284:	f85a                	sd	s6,48(sp)
ffffffffc0202286:	f45e                	sd	s7,40(sp)
ffffffffc0202288:	f062                	sd	s8,32(sp)
ffffffffc020228a:	ec66                	sd	s9,24(sp)
ffffffffc020228c:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020228e:	17d2                	slli	a5,a5,0x34
ffffffffc0202290:	e3ed                	bnez	a5,ffffffffc0202372 <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc0202292:	002007b7          	lui	a5,0x200
ffffffffc0202296:	842e                	mv	s0,a1
ffffffffc0202298:	0ef5ed63          	bltu	a1,a5,ffffffffc0202392 <unmap_range+0x122>
ffffffffc020229c:	8932                	mv	s2,a2
ffffffffc020229e:	0ec5fa63          	bgeu	a1,a2,ffffffffc0202392 <unmap_range+0x122>
ffffffffc02022a2:	4785                	li	a5,1
ffffffffc02022a4:	07fe                	slli	a5,a5,0x1f
ffffffffc02022a6:	0ec7e663          	bltu	a5,a2,ffffffffc0202392 <unmap_range+0x122>
ffffffffc02022aa:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02022ac:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02022ae:	000ddc97          	auipc	s9,0xdd
ffffffffc02022b2:	852c8c93          	addi	s9,s9,-1966 # ffffffffc02deb00 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02022b6:	000ddc17          	auipc	s8,0xdd
ffffffffc02022ba:	852c0c13          	addi	s8,s8,-1966 # ffffffffc02deb08 <pages>
ffffffffc02022be:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc02022c2:	000ddd17          	auipc	s10,0xdd
ffffffffc02022c6:	84ed0d13          	addi	s10,s10,-1970 # ffffffffc02deb10 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02022ca:	00200b37          	lui	s6,0x200
ffffffffc02022ce:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc02022d2:	4601                	li	a2,0
ffffffffc02022d4:	85a2                	mv	a1,s0
ffffffffc02022d6:	854e                	mv	a0,s3
ffffffffc02022d8:	d1dff0ef          	jal	ra,ffffffffc0201ff4 <get_pte>
ffffffffc02022dc:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02022de:	cd29                	beqz	a0,ffffffffc0202338 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc02022e0:	611c                	ld	a5,0(a0)
ffffffffc02022e2:	e395                	bnez	a5,ffffffffc0202306 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc02022e4:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02022e6:	ff2466e3          	bltu	s0,s2,ffffffffc02022d2 <unmap_range+0x62>
}
ffffffffc02022ea:	70a6                	ld	ra,104(sp)
ffffffffc02022ec:	7406                	ld	s0,96(sp)
ffffffffc02022ee:	64e6                	ld	s1,88(sp)
ffffffffc02022f0:	6946                	ld	s2,80(sp)
ffffffffc02022f2:	69a6                	ld	s3,72(sp)
ffffffffc02022f4:	6a06                	ld	s4,64(sp)
ffffffffc02022f6:	7ae2                	ld	s5,56(sp)
ffffffffc02022f8:	7b42                	ld	s6,48(sp)
ffffffffc02022fa:	7ba2                	ld	s7,40(sp)
ffffffffc02022fc:	7c02                	ld	s8,32(sp)
ffffffffc02022fe:	6ce2                	ld	s9,24(sp)
ffffffffc0202300:	6d42                	ld	s10,16(sp)
ffffffffc0202302:	6165                	addi	sp,sp,112
ffffffffc0202304:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202306:	0017f713          	andi	a4,a5,1
ffffffffc020230a:	df69                	beqz	a4,ffffffffc02022e4 <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc020230c:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202310:	078a                	slli	a5,a5,0x2
ffffffffc0202312:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202314:	08e7ff63          	bgeu	a5,a4,ffffffffc02023b2 <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202318:	000c3503          	ld	a0,0(s8)
ffffffffc020231c:	97de                	add	a5,a5,s7
ffffffffc020231e:	079a                	slli	a5,a5,0x6
ffffffffc0202320:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202322:	411c                	lw	a5,0(a0)
ffffffffc0202324:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202328:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc020232a:	cf11                	beqz	a4,ffffffffc0202346 <unmap_range+0xd6>
        *ptep = 0;
ffffffffc020232c:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202330:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202334:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202336:	bf45                	j	ffffffffc02022e6 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202338:	945a                	add	s0,s0,s6
ffffffffc020233a:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc020233e:	d455                	beqz	s0,ffffffffc02022ea <unmap_range+0x7a>
ffffffffc0202340:	f92469e3          	bltu	s0,s2,ffffffffc02022d2 <unmap_range+0x62>
ffffffffc0202344:	b75d                	j	ffffffffc02022ea <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202346:	100027f3          	csrr	a5,sstatus
ffffffffc020234a:	8b89                	andi	a5,a5,2
ffffffffc020234c:	e799                	bnez	a5,ffffffffc020235a <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc020234e:	000d3783          	ld	a5,0(s10)
ffffffffc0202352:	4585                	li	a1,1
ffffffffc0202354:	739c                	ld	a5,32(a5)
ffffffffc0202356:	9782                	jalr	a5
    if (flag)
ffffffffc0202358:	bfd1                	j	ffffffffc020232c <unmap_range+0xbc>
ffffffffc020235a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020235c:	e58fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202360:	000d3783          	ld	a5,0(s10)
ffffffffc0202364:	6522                	ld	a0,8(sp)
ffffffffc0202366:	4585                	li	a1,1
ffffffffc0202368:	739c                	ld	a5,32(a5)
ffffffffc020236a:	9782                	jalr	a5
        intr_enable();
ffffffffc020236c:	e42fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202370:	bf75                	j	ffffffffc020232c <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202372:	00004697          	auipc	a3,0x4
ffffffffc0202376:	54e68693          	addi	a3,a3,1358 # ffffffffc02068c0 <default_pmm_manager+0x160>
ffffffffc020237a:	00004617          	auipc	a2,0x4
ffffffffc020237e:	03660613          	addi	a2,a2,54 # ffffffffc02063b0 <commands+0x848>
ffffffffc0202382:	12000593          	li	a1,288
ffffffffc0202386:	00004517          	auipc	a0,0x4
ffffffffc020238a:	52a50513          	addi	a0,a0,1322 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020238e:	900fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202392:	00004697          	auipc	a3,0x4
ffffffffc0202396:	55e68693          	addi	a3,a3,1374 # ffffffffc02068f0 <default_pmm_manager+0x190>
ffffffffc020239a:	00004617          	auipc	a2,0x4
ffffffffc020239e:	01660613          	addi	a2,a2,22 # ffffffffc02063b0 <commands+0x848>
ffffffffc02023a2:	12100593          	li	a1,289
ffffffffc02023a6:	00004517          	auipc	a0,0x4
ffffffffc02023aa:	50a50513          	addi	a0,a0,1290 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02023ae:	8e0fe0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc02023b2:	b53ff0ef          	jal	ra,ffffffffc0201f04 <pa2page.part.0>

ffffffffc02023b6 <exit_range>:
{
ffffffffc02023b6:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023b8:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02023bc:	fc86                	sd	ra,120(sp)
ffffffffc02023be:	f8a2                	sd	s0,112(sp)
ffffffffc02023c0:	f4a6                	sd	s1,104(sp)
ffffffffc02023c2:	f0ca                	sd	s2,96(sp)
ffffffffc02023c4:	ecce                	sd	s3,88(sp)
ffffffffc02023c6:	e8d2                	sd	s4,80(sp)
ffffffffc02023c8:	e4d6                	sd	s5,72(sp)
ffffffffc02023ca:	e0da                	sd	s6,64(sp)
ffffffffc02023cc:	fc5e                	sd	s7,56(sp)
ffffffffc02023ce:	f862                	sd	s8,48(sp)
ffffffffc02023d0:	f466                	sd	s9,40(sp)
ffffffffc02023d2:	f06a                	sd	s10,32(sp)
ffffffffc02023d4:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023d6:	17d2                	slli	a5,a5,0x34
ffffffffc02023d8:	20079a63          	bnez	a5,ffffffffc02025ec <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc02023dc:	002007b7          	lui	a5,0x200
ffffffffc02023e0:	24f5e463          	bltu	a1,a5,ffffffffc0202628 <exit_range+0x272>
ffffffffc02023e4:	8ab2                	mv	s5,a2
ffffffffc02023e6:	24c5f163          	bgeu	a1,a2,ffffffffc0202628 <exit_range+0x272>
ffffffffc02023ea:	4785                	li	a5,1
ffffffffc02023ec:	07fe                	slli	a5,a5,0x1f
ffffffffc02023ee:	22c7ed63          	bltu	a5,a2,ffffffffc0202628 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02023f2:	c00009b7          	lui	s3,0xc0000
ffffffffc02023f6:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02023fa:	ffe00937          	lui	s2,0xffe00
ffffffffc02023fe:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc0202402:	5cfd                	li	s9,-1
ffffffffc0202404:	8c2a                	mv	s8,a0
ffffffffc0202406:	0125f933          	and	s2,a1,s2
ffffffffc020240a:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc020240c:	000dcd17          	auipc	s10,0xdc
ffffffffc0202410:	6f4d0d13          	addi	s10,s10,1780 # ffffffffc02deb00 <npage>
    return KADDR(page2pa(page));
ffffffffc0202414:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202418:	000dc717          	auipc	a4,0xdc
ffffffffc020241c:	6f070713          	addi	a4,a4,1776 # ffffffffc02deb08 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc0202420:	000dcd97          	auipc	s11,0xdc
ffffffffc0202424:	6f0d8d93          	addi	s11,s11,1776 # ffffffffc02deb10 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202428:	c0000437          	lui	s0,0xc0000
ffffffffc020242c:	944e                	add	s0,s0,s3
ffffffffc020242e:	8079                	srli	s0,s0,0x1e
ffffffffc0202430:	1ff47413          	andi	s0,s0,511
ffffffffc0202434:	040e                	slli	s0,s0,0x3
ffffffffc0202436:	9462                	add	s0,s0,s8
ffffffffc0202438:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_dirtycow_out_size+0xffffffffbfff4ab0>
        if (pde1 & PTE_V)
ffffffffc020243c:	001a7793          	andi	a5,s4,1
ffffffffc0202440:	eb99                	bnez	a5,ffffffffc0202456 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc0202442:	12098463          	beqz	s3,ffffffffc020256a <exit_range+0x1b4>
ffffffffc0202446:	400007b7          	lui	a5,0x40000
ffffffffc020244a:	97ce                	add	a5,a5,s3
ffffffffc020244c:	894e                	mv	s2,s3
ffffffffc020244e:	1159fe63          	bgeu	s3,s5,ffffffffc020256a <exit_range+0x1b4>
ffffffffc0202452:	89be                	mv	s3,a5
ffffffffc0202454:	bfd1                	j	ffffffffc0202428 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc0202456:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc020245a:	0a0a                	slli	s4,s4,0x2
ffffffffc020245c:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202460:	1cfa7263          	bgeu	s4,a5,ffffffffc0202624 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202464:	fff80637          	lui	a2,0xfff80
ffffffffc0202468:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc020246a:	000806b7          	lui	a3,0x80
ffffffffc020246e:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202470:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202474:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202476:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202478:	18f5fa63          	bgeu	a1,a5,ffffffffc020260c <exit_range+0x256>
ffffffffc020247c:	000dc817          	auipc	a6,0xdc
ffffffffc0202480:	69c80813          	addi	a6,a6,1692 # ffffffffc02deb18 <va_pa_offset>
ffffffffc0202484:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc0202488:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc020248a:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc020248e:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc0202490:	00080337          	lui	t1,0x80
ffffffffc0202494:	6885                	lui	a7,0x1
ffffffffc0202496:	a819                	j	ffffffffc02024ac <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc0202498:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc020249a:	002007b7          	lui	a5,0x200
ffffffffc020249e:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02024a0:	08090c63          	beqz	s2,ffffffffc0202538 <exit_range+0x182>
ffffffffc02024a4:	09397a63          	bgeu	s2,s3,ffffffffc0202538 <exit_range+0x182>
ffffffffc02024a8:	0f597063          	bgeu	s2,s5,ffffffffc0202588 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc02024ac:	01595493          	srli	s1,s2,0x15
ffffffffc02024b0:	1ff4f493          	andi	s1,s1,511
ffffffffc02024b4:	048e                	slli	s1,s1,0x3
ffffffffc02024b6:	94da                	add	s1,s1,s6
ffffffffc02024b8:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc02024ba:	0017f693          	andi	a3,a5,1
ffffffffc02024be:	dee9                	beqz	a3,ffffffffc0202498 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc02024c0:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02024c4:	078a                	slli	a5,a5,0x2
ffffffffc02024c6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024c8:	14b7fe63          	bgeu	a5,a1,ffffffffc0202624 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02024cc:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc02024ce:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc02024d2:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02024d6:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02024da:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02024dc:	12bef863          	bgeu	t4,a1,ffffffffc020260c <exit_range+0x256>
ffffffffc02024e0:	00083783          	ld	a5,0(a6)
ffffffffc02024e4:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02024e6:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc02024ea:	629c                	ld	a5,0(a3)
ffffffffc02024ec:	8b85                	andi	a5,a5,1
ffffffffc02024ee:	f7d5                	bnez	a5,ffffffffc020249a <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02024f0:	06a1                	addi	a3,a3,8
ffffffffc02024f2:	fed59ce3          	bne	a1,a3,ffffffffc02024ea <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc02024f6:	631c                	ld	a5,0(a4)
ffffffffc02024f8:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02024fa:	100027f3          	csrr	a5,sstatus
ffffffffc02024fe:	8b89                	andi	a5,a5,2
ffffffffc0202500:	e7d9                	bnez	a5,ffffffffc020258e <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc0202502:	000db783          	ld	a5,0(s11)
ffffffffc0202506:	4585                	li	a1,1
ffffffffc0202508:	e032                	sd	a2,0(sp)
ffffffffc020250a:	739c                	ld	a5,32(a5)
ffffffffc020250c:	9782                	jalr	a5
    if (flag)
ffffffffc020250e:	6602                	ld	a2,0(sp)
ffffffffc0202510:	000dc817          	auipc	a6,0xdc
ffffffffc0202514:	60880813          	addi	a6,a6,1544 # ffffffffc02deb18 <va_pa_offset>
ffffffffc0202518:	fff80e37          	lui	t3,0xfff80
ffffffffc020251c:	00080337          	lui	t1,0x80
ffffffffc0202520:	6885                	lui	a7,0x1
ffffffffc0202522:	000dc717          	auipc	a4,0xdc
ffffffffc0202526:	5e670713          	addi	a4,a4,1510 # ffffffffc02deb08 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020252a:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc020252e:	002007b7          	lui	a5,0x200
ffffffffc0202532:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202534:	f60918e3          	bnez	s2,ffffffffc02024a4 <exit_range+0xee>
            if (free_pd0)
ffffffffc0202538:	f00b85e3          	beqz	s7,ffffffffc0202442 <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc020253c:	000d3783          	ld	a5,0(s10)
ffffffffc0202540:	0efa7263          	bgeu	s4,a5,ffffffffc0202624 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202544:	6308                	ld	a0,0(a4)
ffffffffc0202546:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202548:	100027f3          	csrr	a5,sstatus
ffffffffc020254c:	8b89                	andi	a5,a5,2
ffffffffc020254e:	efad                	bnez	a5,ffffffffc02025c8 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc0202550:	000db783          	ld	a5,0(s11)
ffffffffc0202554:	4585                	li	a1,1
ffffffffc0202556:	739c                	ld	a5,32(a5)
ffffffffc0202558:	9782                	jalr	a5
ffffffffc020255a:	000dc717          	auipc	a4,0xdc
ffffffffc020255e:	5ae70713          	addi	a4,a4,1454 # ffffffffc02deb08 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202562:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc0202566:	ee0990e3          	bnez	s3,ffffffffc0202446 <exit_range+0x90>
}
ffffffffc020256a:	70e6                	ld	ra,120(sp)
ffffffffc020256c:	7446                	ld	s0,112(sp)
ffffffffc020256e:	74a6                	ld	s1,104(sp)
ffffffffc0202570:	7906                	ld	s2,96(sp)
ffffffffc0202572:	69e6                	ld	s3,88(sp)
ffffffffc0202574:	6a46                	ld	s4,80(sp)
ffffffffc0202576:	6aa6                	ld	s5,72(sp)
ffffffffc0202578:	6b06                	ld	s6,64(sp)
ffffffffc020257a:	7be2                	ld	s7,56(sp)
ffffffffc020257c:	7c42                	ld	s8,48(sp)
ffffffffc020257e:	7ca2                	ld	s9,40(sp)
ffffffffc0202580:	7d02                	ld	s10,32(sp)
ffffffffc0202582:	6de2                	ld	s11,24(sp)
ffffffffc0202584:	6109                	addi	sp,sp,128
ffffffffc0202586:	8082                	ret
            if (free_pd0)
ffffffffc0202588:	ea0b8fe3          	beqz	s7,ffffffffc0202446 <exit_range+0x90>
ffffffffc020258c:	bf45                	j	ffffffffc020253c <exit_range+0x186>
ffffffffc020258e:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc0202590:	e42a                	sd	a0,8(sp)
ffffffffc0202592:	c22fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202596:	000db783          	ld	a5,0(s11)
ffffffffc020259a:	6522                	ld	a0,8(sp)
ffffffffc020259c:	4585                	li	a1,1
ffffffffc020259e:	739c                	ld	a5,32(a5)
ffffffffc02025a0:	9782                	jalr	a5
        intr_enable();
ffffffffc02025a2:	c0cfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02025a6:	6602                	ld	a2,0(sp)
ffffffffc02025a8:	000dc717          	auipc	a4,0xdc
ffffffffc02025ac:	56070713          	addi	a4,a4,1376 # ffffffffc02deb08 <pages>
ffffffffc02025b0:	6885                	lui	a7,0x1
ffffffffc02025b2:	00080337          	lui	t1,0x80
ffffffffc02025b6:	fff80e37          	lui	t3,0xfff80
ffffffffc02025ba:	000dc817          	auipc	a6,0xdc
ffffffffc02025be:	55e80813          	addi	a6,a6,1374 # ffffffffc02deb18 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc02025c2:	0004b023          	sd	zero,0(s1)
ffffffffc02025c6:	b7a5                	j	ffffffffc020252e <exit_range+0x178>
ffffffffc02025c8:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc02025ca:	beafe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02025ce:	000db783          	ld	a5,0(s11)
ffffffffc02025d2:	6502                	ld	a0,0(sp)
ffffffffc02025d4:	4585                	li	a1,1
ffffffffc02025d6:	739c                	ld	a5,32(a5)
ffffffffc02025d8:	9782                	jalr	a5
        intr_enable();
ffffffffc02025da:	bd4fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02025de:	000dc717          	auipc	a4,0xdc
ffffffffc02025e2:	52a70713          	addi	a4,a4,1322 # ffffffffc02deb08 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02025e6:	00043023          	sd	zero,0(s0)
ffffffffc02025ea:	bfb5                	j	ffffffffc0202566 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02025ec:	00004697          	auipc	a3,0x4
ffffffffc02025f0:	2d468693          	addi	a3,a3,724 # ffffffffc02068c0 <default_pmm_manager+0x160>
ffffffffc02025f4:	00004617          	auipc	a2,0x4
ffffffffc02025f8:	dbc60613          	addi	a2,a2,-580 # ffffffffc02063b0 <commands+0x848>
ffffffffc02025fc:	13500593          	li	a1,309
ffffffffc0202600:	00004517          	auipc	a0,0x4
ffffffffc0202604:	2b050513          	addi	a0,a0,688 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0202608:	e87fd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc020260c:	00004617          	auipc	a2,0x4
ffffffffc0202610:	18c60613          	addi	a2,a2,396 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc0202614:	07100593          	li	a1,113
ffffffffc0202618:	00004517          	auipc	a0,0x4
ffffffffc020261c:	1a850513          	addi	a0,a0,424 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc0202620:	e6ffd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202624:	8e1ff0ef          	jal	ra,ffffffffc0201f04 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202628:	00004697          	auipc	a3,0x4
ffffffffc020262c:	2c868693          	addi	a3,a3,712 # ffffffffc02068f0 <default_pmm_manager+0x190>
ffffffffc0202630:	00004617          	auipc	a2,0x4
ffffffffc0202634:	d8060613          	addi	a2,a2,-640 # ffffffffc02063b0 <commands+0x848>
ffffffffc0202638:	13600593          	li	a1,310
ffffffffc020263c:	00004517          	auipc	a0,0x4
ffffffffc0202640:	27450513          	addi	a0,a0,628 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0202644:	e4bfd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202648 <copy_range>:
{
ffffffffc0202648:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020264a:	00d667b3          	or	a5,a2,a3
{
ffffffffc020264e:	f486                	sd	ra,104(sp)
ffffffffc0202650:	f0a2                	sd	s0,96(sp)
ffffffffc0202652:	eca6                	sd	s1,88(sp)
ffffffffc0202654:	e8ca                	sd	s2,80(sp)
ffffffffc0202656:	e4ce                	sd	s3,72(sp)
ffffffffc0202658:	e0d2                	sd	s4,64(sp)
ffffffffc020265a:	fc56                	sd	s5,56(sp)
ffffffffc020265c:	f85a                	sd	s6,48(sp)
ffffffffc020265e:	f45e                	sd	s7,40(sp)
ffffffffc0202660:	f062                	sd	s8,32(sp)
ffffffffc0202662:	ec66                	sd	s9,24(sp)
ffffffffc0202664:	e86a                	sd	s10,16(sp)
ffffffffc0202666:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202668:	17d2                	slli	a5,a5,0x34
ffffffffc020266a:	18079263          	bnez	a5,ffffffffc02027ee <copy_range+0x1a6>
    assert(USER_ACCESS(start, end));
ffffffffc020266e:	002007b7          	lui	a5,0x200
ffffffffc0202672:	8432                	mv	s0,a2
ffffffffc0202674:	12f66163          	bltu	a2,a5,ffffffffc0202796 <copy_range+0x14e>
ffffffffc0202678:	84b6                	mv	s1,a3
ffffffffc020267a:	10d67e63          	bgeu	a2,a3,ffffffffc0202796 <copy_range+0x14e>
ffffffffc020267e:	4785                	li	a5,1
ffffffffc0202680:	07fe                	slli	a5,a5,0x1f
ffffffffc0202682:	10d7ea63          	bltu	a5,a3,ffffffffc0202796 <copy_range+0x14e>
ffffffffc0202686:	8a2a                	mv	s4,a0
ffffffffc0202688:	892e                	mv	s2,a1
ffffffffc020268a:	8aba                	mv	s5,a4
        start += PGSIZE;
ffffffffc020268c:	6985                	lui	s3,0x1
    if (PPN(pa) >= npage)
ffffffffc020268e:	000dcc17          	auipc	s8,0xdc
ffffffffc0202692:	472c0c13          	addi	s8,s8,1138 # ffffffffc02deb00 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202696:	fff80bb7          	lui	s7,0xfff80
ffffffffc020269a:	000dcb17          	auipc	s6,0xdc
ffffffffc020269e:	46eb0b13          	addi	s6,s6,1134 # ffffffffc02deb08 <pages>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02026a2:	00200d37          	lui	s10,0x200
ffffffffc02026a6:	ffe00cb7          	lui	s9,0xffe00
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02026aa:	4601                	li	a2,0
ffffffffc02026ac:	85a2                	mv	a1,s0
ffffffffc02026ae:	854a                	mv	a0,s2
ffffffffc02026b0:	945ff0ef          	jal	ra,ffffffffc0201ff4 <get_pte>
ffffffffc02026b4:	8daa                	mv	s11,a0
        if (ptep == NULL)
ffffffffc02026b6:	c92d                	beqz	a0,ffffffffc0202728 <copy_range+0xe0>
        if (*ptep & PTE_V)
ffffffffc02026b8:	6118                	ld	a4,0(a0)
ffffffffc02026ba:	8b05                	andi	a4,a4,1
ffffffffc02026bc:	e705                	bnez	a4,ffffffffc02026e4 <copy_range+0x9c>
        start += PGSIZE;
ffffffffc02026be:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc02026c0:	fe9465e3          	bltu	s0,s1,ffffffffc02026aa <copy_range+0x62>
    return 0;
ffffffffc02026c4:	4501                	li	a0,0
}
ffffffffc02026c6:	70a6                	ld	ra,104(sp)
ffffffffc02026c8:	7406                	ld	s0,96(sp)
ffffffffc02026ca:	64e6                	ld	s1,88(sp)
ffffffffc02026cc:	6946                	ld	s2,80(sp)
ffffffffc02026ce:	69a6                	ld	s3,72(sp)
ffffffffc02026d0:	6a06                	ld	s4,64(sp)
ffffffffc02026d2:	7ae2                	ld	s5,56(sp)
ffffffffc02026d4:	7b42                	ld	s6,48(sp)
ffffffffc02026d6:	7ba2                	ld	s7,40(sp)
ffffffffc02026d8:	7c02                	ld	s8,32(sp)
ffffffffc02026da:	6ce2                	ld	s9,24(sp)
ffffffffc02026dc:	6d42                	ld	s10,16(sp)
ffffffffc02026de:	6da2                	ld	s11,8(sp)
ffffffffc02026e0:	6165                	addi	sp,sp,112
ffffffffc02026e2:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc02026e4:	4605                	li	a2,1
ffffffffc02026e6:	85a2                	mv	a1,s0
ffffffffc02026e8:	8552                	mv	a0,s4
ffffffffc02026ea:	90bff0ef          	jal	ra,ffffffffc0201ff4 <get_pte>
ffffffffc02026ee:	c551                	beqz	a0,ffffffffc020277a <copy_range+0x132>
            uint32_t perm = (*ptep & (PTE_R | PTE_W | PTE_X | PTE_U));
ffffffffc02026f0:	000db683          	ld	a3,0(s11)
    if (!(pte & PTE_V))
ffffffffc02026f4:	0016f713          	andi	a4,a3,1
ffffffffc02026f8:	c359                	beqz	a4,ffffffffc020277e <copy_range+0x136>
    if (PPN(pa) >= npage)
ffffffffc02026fa:	000c3603          	ld	a2,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc02026fe:	00269713          	slli	a4,a3,0x2
ffffffffc0202702:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202704:	0cc77963          	bgeu	a4,a2,ffffffffc02027d6 <copy_range+0x18e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202708:	000b3603          	ld	a2,0(s6)
ffffffffc020270c:	975e                	add	a4,a4,s7
ffffffffc020270e:	071a                	slli	a4,a4,0x6
ffffffffc0202710:	963a                	add	a2,a2,a4
            assert(page != NULL);
ffffffffc0202712:	c255                	beqz	a2,ffffffffc02027b6 <copy_range+0x16e>
    page->ref += 1;
ffffffffc0202714:	420c                	lw	a1,0(a2)
ffffffffc0202716:	2585                	addiw	a1,a1,1
            if (share)
ffffffffc0202718:	000a8f63          	beqz	s5,ffffffffc0202736 <copy_range+0xee>
ffffffffc020271c:	c20c                	sw	a1,0(a2)
                *nptep = *ptep;
ffffffffc020271e:	e114                	sd	a3,0(a0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202720:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202724:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc0202726:	bf69                	j	ffffffffc02026c0 <copy_range+0x78>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202728:	946a                	add	s0,s0,s10
ffffffffc020272a:	01947433          	and	s0,s0,s9
    } while (start != 0 && start < end);
ffffffffc020272e:	d859                	beqz	s0,ffffffffc02026c4 <copy_range+0x7c>
ffffffffc0202730:	f6946de3          	bltu	s0,s1,ffffffffc02026aa <copy_range+0x62>
ffffffffc0202734:	bf41                	j	ffffffffc02026c4 <copy_range+0x7c>
    return page - pages + nbase;
ffffffffc0202736:	8719                	srai	a4,a4,0x6
ffffffffc0202738:	000807b7          	lui	a5,0x80
ffffffffc020273c:	973e                	add	a4,a4,a5
                if (perm & PTE_W)
ffffffffc020273e:	0046f813          	andi	a6,a3,4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202742:	072a                	slli	a4,a4,0xa
            uint32_t perm = (*ptep & (PTE_R | PTE_W | PTE_X | PTE_U));
ffffffffc0202744:	2681                	sext.w	a3,a3
                if (perm & PTE_W)
ffffffffc0202746:	02080063          	beqz	a6,ffffffffc0202766 <copy_range+0x11e>
                    uint32_t cow_perm = (perm & ~PTE_W) | PTE_COW;
ffffffffc020274a:	8ae9                	andi	a3,a3,26
ffffffffc020274c:	8f55                	or	a4,a4,a3
    page->ref += 1;
ffffffffc020274e:	c20c                	sw	a1,0(a2)
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202750:	20176713          	ori	a4,a4,513
                    *nptep = pte_create(page2ppn(page), PTE_V | cow_perm);
ffffffffc0202754:	e118                	sd	a4,0(a0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202756:	12040073          	sfence.vma	s0
                    *ptep = pte_create(page2ppn(page), PTE_V | old_perm);
ffffffffc020275a:	00edb023          	sd	a4,0(s11)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020275e:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202762:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc0202764:	bfb1                	j	ffffffffc02026c0 <copy_range+0x78>
            uint32_t perm = (*ptep & (PTE_R | PTE_W | PTE_X | PTE_U));
ffffffffc0202766:	8af9                	andi	a3,a3,30
ffffffffc0202768:	8f55                	or	a4,a4,a3
    page->ref += 1;
ffffffffc020276a:	c20c                	sw	a1,0(a2)
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020276c:	00176713          	ori	a4,a4,1
                    *nptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202770:	e118                	sd	a4,0(a0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202772:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202776:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc0202778:	b7a1                	j	ffffffffc02026c0 <copy_range+0x78>
                return -E_NO_MEM;
ffffffffc020277a:	5571                	li	a0,-4
ffffffffc020277c:	b7a9                	j	ffffffffc02026c6 <copy_range+0x7e>
        panic("pte2page called with invalid pte");
ffffffffc020277e:	00004617          	auipc	a2,0x4
ffffffffc0202782:	10a60613          	addi	a2,a2,266 # ffffffffc0206888 <default_pmm_manager+0x128>
ffffffffc0202786:	07f00593          	li	a1,127
ffffffffc020278a:	00004517          	auipc	a0,0x4
ffffffffc020278e:	03650513          	addi	a0,a0,54 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc0202792:	cfdfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202796:	00004697          	auipc	a3,0x4
ffffffffc020279a:	15a68693          	addi	a3,a3,346 # ffffffffc02068f0 <default_pmm_manager+0x190>
ffffffffc020279e:	00004617          	auipc	a2,0x4
ffffffffc02027a2:	c1260613          	addi	a2,a2,-1006 # ffffffffc02063b0 <commands+0x848>
ffffffffc02027a6:	17c00593          	li	a1,380
ffffffffc02027aa:	00004517          	auipc	a0,0x4
ffffffffc02027ae:	10650513          	addi	a0,a0,262 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02027b2:	cddfd0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(page != NULL);
ffffffffc02027b6:	00004697          	auipc	a3,0x4
ffffffffc02027ba:	15268693          	addi	a3,a3,338 # ffffffffc0206908 <default_pmm_manager+0x1a8>
ffffffffc02027be:	00004617          	auipc	a2,0x4
ffffffffc02027c2:	bf260613          	addi	a2,a2,-1038 # ffffffffc02063b0 <commands+0x848>
ffffffffc02027c6:	19300593          	li	a1,403
ffffffffc02027ca:	00004517          	auipc	a0,0x4
ffffffffc02027ce:	0e650513          	addi	a0,a0,230 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02027d2:	cbdfd0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02027d6:	00004617          	auipc	a2,0x4
ffffffffc02027da:	09260613          	addi	a2,a2,146 # ffffffffc0206868 <default_pmm_manager+0x108>
ffffffffc02027de:	06900593          	li	a1,105
ffffffffc02027e2:	00004517          	auipc	a0,0x4
ffffffffc02027e6:	fde50513          	addi	a0,a0,-34 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc02027ea:	ca5fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02027ee:	00004697          	auipc	a3,0x4
ffffffffc02027f2:	0d268693          	addi	a3,a3,210 # ffffffffc02068c0 <default_pmm_manager+0x160>
ffffffffc02027f6:	00004617          	auipc	a2,0x4
ffffffffc02027fa:	bba60613          	addi	a2,a2,-1094 # ffffffffc02063b0 <commands+0x848>
ffffffffc02027fe:	17b00593          	li	a1,379
ffffffffc0202802:	00004517          	auipc	a0,0x4
ffffffffc0202806:	0ae50513          	addi	a0,a0,174 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020280a:	c85fd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020280e <page_remove>:
{
ffffffffc020280e:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202810:	4601                	li	a2,0
{
ffffffffc0202812:	ec26                	sd	s1,24(sp)
ffffffffc0202814:	f406                	sd	ra,40(sp)
ffffffffc0202816:	f022                	sd	s0,32(sp)
ffffffffc0202818:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020281a:	fdaff0ef          	jal	ra,ffffffffc0201ff4 <get_pte>
    if (ptep != NULL)
ffffffffc020281e:	c511                	beqz	a0,ffffffffc020282a <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0202820:	611c                	ld	a5,0(a0)
ffffffffc0202822:	842a                	mv	s0,a0
ffffffffc0202824:	0017f713          	andi	a4,a5,1
ffffffffc0202828:	e711                	bnez	a4,ffffffffc0202834 <page_remove+0x26>
}
ffffffffc020282a:	70a2                	ld	ra,40(sp)
ffffffffc020282c:	7402                	ld	s0,32(sp)
ffffffffc020282e:	64e2                	ld	s1,24(sp)
ffffffffc0202830:	6145                	addi	sp,sp,48
ffffffffc0202832:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202834:	078a                	slli	a5,a5,0x2
ffffffffc0202836:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202838:	000dc717          	auipc	a4,0xdc
ffffffffc020283c:	2c873703          	ld	a4,712(a4) # ffffffffc02deb00 <npage>
ffffffffc0202840:	06e7f363          	bgeu	a5,a4,ffffffffc02028a6 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202844:	fff80537          	lui	a0,0xfff80
ffffffffc0202848:	97aa                	add	a5,a5,a0
ffffffffc020284a:	079a                	slli	a5,a5,0x6
ffffffffc020284c:	000dc517          	auipc	a0,0xdc
ffffffffc0202850:	2bc53503          	ld	a0,700(a0) # ffffffffc02deb08 <pages>
ffffffffc0202854:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202856:	411c                	lw	a5,0(a0)
ffffffffc0202858:	fff7871b          	addiw	a4,a5,-1
ffffffffc020285c:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc020285e:	cb11                	beqz	a4,ffffffffc0202872 <page_remove+0x64>
        *ptep = 0;
ffffffffc0202860:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202864:	12048073          	sfence.vma	s1
}
ffffffffc0202868:	70a2                	ld	ra,40(sp)
ffffffffc020286a:	7402                	ld	s0,32(sp)
ffffffffc020286c:	64e2                	ld	s1,24(sp)
ffffffffc020286e:	6145                	addi	sp,sp,48
ffffffffc0202870:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202872:	100027f3          	csrr	a5,sstatus
ffffffffc0202876:	8b89                	andi	a5,a5,2
ffffffffc0202878:	eb89                	bnez	a5,ffffffffc020288a <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc020287a:	000dc797          	auipc	a5,0xdc
ffffffffc020287e:	2967b783          	ld	a5,662(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc0202882:	739c                	ld	a5,32(a5)
ffffffffc0202884:	4585                	li	a1,1
ffffffffc0202886:	9782                	jalr	a5
    if (flag)
ffffffffc0202888:	bfe1                	j	ffffffffc0202860 <page_remove+0x52>
        intr_disable();
ffffffffc020288a:	e42a                	sd	a0,8(sp)
ffffffffc020288c:	928fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202890:	000dc797          	auipc	a5,0xdc
ffffffffc0202894:	2807b783          	ld	a5,640(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc0202898:	739c                	ld	a5,32(a5)
ffffffffc020289a:	6522                	ld	a0,8(sp)
ffffffffc020289c:	4585                	li	a1,1
ffffffffc020289e:	9782                	jalr	a5
        intr_enable();
ffffffffc02028a0:	90efe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02028a4:	bf75                	j	ffffffffc0202860 <page_remove+0x52>
ffffffffc02028a6:	e5eff0ef          	jal	ra,ffffffffc0201f04 <pa2page.part.0>

ffffffffc02028aa <page_insert>:
{
ffffffffc02028aa:	7139                	addi	sp,sp,-64
ffffffffc02028ac:	e852                	sd	s4,16(sp)
ffffffffc02028ae:	8a32                	mv	s4,a2
ffffffffc02028b0:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02028b2:	4605                	li	a2,1
{
ffffffffc02028b4:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02028b6:	85d2                	mv	a1,s4
{
ffffffffc02028b8:	f426                	sd	s1,40(sp)
ffffffffc02028ba:	fc06                	sd	ra,56(sp)
ffffffffc02028bc:	f04a                	sd	s2,32(sp)
ffffffffc02028be:	ec4e                	sd	s3,24(sp)
ffffffffc02028c0:	e456                	sd	s5,8(sp)
ffffffffc02028c2:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02028c4:	f30ff0ef          	jal	ra,ffffffffc0201ff4 <get_pte>
    if (ptep == NULL)
ffffffffc02028c8:	c961                	beqz	a0,ffffffffc0202998 <page_insert+0xee>
    page->ref += 1;
ffffffffc02028ca:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc02028cc:	611c                	ld	a5,0(a0)
ffffffffc02028ce:	89aa                	mv	s3,a0
ffffffffc02028d0:	0016871b          	addiw	a4,a3,1
ffffffffc02028d4:	c018                	sw	a4,0(s0)
ffffffffc02028d6:	0017f713          	andi	a4,a5,1
ffffffffc02028da:	ef05                	bnez	a4,ffffffffc0202912 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc02028dc:	000dc717          	auipc	a4,0xdc
ffffffffc02028e0:	22c73703          	ld	a4,556(a4) # ffffffffc02deb08 <pages>
ffffffffc02028e4:	8c19                	sub	s0,s0,a4
ffffffffc02028e6:	000807b7          	lui	a5,0x80
ffffffffc02028ea:	8419                	srai	s0,s0,0x6
ffffffffc02028ec:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02028ee:	042a                	slli	s0,s0,0xa
ffffffffc02028f0:	8cc1                	or	s1,s1,s0
ffffffffc02028f2:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02028f6:	0099b023          	sd	s1,0(s3) # 1000 <_binary_obj___user_faultread_out_size-0x8ba0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02028fa:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc02028fe:	4501                	li	a0,0
}
ffffffffc0202900:	70e2                	ld	ra,56(sp)
ffffffffc0202902:	7442                	ld	s0,48(sp)
ffffffffc0202904:	74a2                	ld	s1,40(sp)
ffffffffc0202906:	7902                	ld	s2,32(sp)
ffffffffc0202908:	69e2                	ld	s3,24(sp)
ffffffffc020290a:	6a42                	ld	s4,16(sp)
ffffffffc020290c:	6aa2                	ld	s5,8(sp)
ffffffffc020290e:	6121                	addi	sp,sp,64
ffffffffc0202910:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202912:	078a                	slli	a5,a5,0x2
ffffffffc0202914:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202916:	000dc717          	auipc	a4,0xdc
ffffffffc020291a:	1ea73703          	ld	a4,490(a4) # ffffffffc02deb00 <npage>
ffffffffc020291e:	06e7ff63          	bgeu	a5,a4,ffffffffc020299c <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202922:	000dca97          	auipc	s5,0xdc
ffffffffc0202926:	1e6a8a93          	addi	s5,s5,486 # ffffffffc02deb08 <pages>
ffffffffc020292a:	000ab703          	ld	a4,0(s5)
ffffffffc020292e:	fff80937          	lui	s2,0xfff80
ffffffffc0202932:	993e                	add	s2,s2,a5
ffffffffc0202934:	091a                	slli	s2,s2,0x6
ffffffffc0202936:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc0202938:	01240c63          	beq	s0,s2,ffffffffc0202950 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc020293c:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fca14bc>
ffffffffc0202940:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202944:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc0202948:	c691                	beqz	a3,ffffffffc0202954 <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020294a:	120a0073          	sfence.vma	s4
}
ffffffffc020294e:	bf59                	j	ffffffffc02028e4 <page_insert+0x3a>
ffffffffc0202950:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202952:	bf49                	j	ffffffffc02028e4 <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202954:	100027f3          	csrr	a5,sstatus
ffffffffc0202958:	8b89                	andi	a5,a5,2
ffffffffc020295a:	ef91                	bnez	a5,ffffffffc0202976 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc020295c:	000dc797          	auipc	a5,0xdc
ffffffffc0202960:	1b47b783          	ld	a5,436(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc0202964:	739c                	ld	a5,32(a5)
ffffffffc0202966:	4585                	li	a1,1
ffffffffc0202968:	854a                	mv	a0,s2
ffffffffc020296a:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc020296c:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202970:	120a0073          	sfence.vma	s4
ffffffffc0202974:	bf85                	j	ffffffffc02028e4 <page_insert+0x3a>
        intr_disable();
ffffffffc0202976:	83efe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020297a:	000dc797          	auipc	a5,0xdc
ffffffffc020297e:	1967b783          	ld	a5,406(a5) # ffffffffc02deb10 <pmm_manager>
ffffffffc0202982:	739c                	ld	a5,32(a5)
ffffffffc0202984:	4585                	li	a1,1
ffffffffc0202986:	854a                	mv	a0,s2
ffffffffc0202988:	9782                	jalr	a5
        intr_enable();
ffffffffc020298a:	824fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020298e:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202992:	120a0073          	sfence.vma	s4
ffffffffc0202996:	b7b9                	j	ffffffffc02028e4 <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0202998:	5571                	li	a0,-4
ffffffffc020299a:	b79d                	j	ffffffffc0202900 <page_insert+0x56>
ffffffffc020299c:	d68ff0ef          	jal	ra,ffffffffc0201f04 <pa2page.part.0>

ffffffffc02029a0 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02029a0:	00004797          	auipc	a5,0x4
ffffffffc02029a4:	dc078793          	addi	a5,a5,-576 # ffffffffc0206760 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02029a8:	638c                	ld	a1,0(a5)
{
ffffffffc02029aa:	7159                	addi	sp,sp,-112
ffffffffc02029ac:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02029ae:	00004517          	auipc	a0,0x4
ffffffffc02029b2:	f6a50513          	addi	a0,a0,-150 # ffffffffc0206918 <default_pmm_manager+0x1b8>
    pmm_manager = &default_pmm_manager;
ffffffffc02029b6:	000dcb17          	auipc	s6,0xdc
ffffffffc02029ba:	15ab0b13          	addi	s6,s6,346 # ffffffffc02deb10 <pmm_manager>
{
ffffffffc02029be:	f486                	sd	ra,104(sp)
ffffffffc02029c0:	e8ca                	sd	s2,80(sp)
ffffffffc02029c2:	e4ce                	sd	s3,72(sp)
ffffffffc02029c4:	f0a2                	sd	s0,96(sp)
ffffffffc02029c6:	eca6                	sd	s1,88(sp)
ffffffffc02029c8:	e0d2                	sd	s4,64(sp)
ffffffffc02029ca:	fc56                	sd	s5,56(sp)
ffffffffc02029cc:	f45e                	sd	s7,40(sp)
ffffffffc02029ce:	f062                	sd	s8,32(sp)
ffffffffc02029d0:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc02029d2:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02029d6:	fbefd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc02029da:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02029de:	000dc997          	auipc	s3,0xdc
ffffffffc02029e2:	13a98993          	addi	s3,s3,314 # ffffffffc02deb18 <va_pa_offset>
    pmm_manager->init();
ffffffffc02029e6:	679c                	ld	a5,8(a5)
ffffffffc02029e8:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02029ea:	57f5                	li	a5,-3
ffffffffc02029ec:	07fa                	slli	a5,a5,0x1e
ffffffffc02029ee:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc02029f2:	fa9fd0ef          	jal	ra,ffffffffc020099a <get_memory_base>
ffffffffc02029f6:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc02029f8:	fadfd0ef          	jal	ra,ffffffffc02009a4 <get_memory_size>
    if (mem_size == 0)
ffffffffc02029fc:	200505e3          	beqz	a0,ffffffffc0203406 <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202a00:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202a02:	00004517          	auipc	a0,0x4
ffffffffc0202a06:	f4e50513          	addi	a0,a0,-178 # ffffffffc0206950 <default_pmm_manager+0x1f0>
ffffffffc0202a0a:	f8afd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202a0e:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202a12:	fff40693          	addi	a3,s0,-1
ffffffffc0202a16:	864a                	mv	a2,s2
ffffffffc0202a18:	85a6                	mv	a1,s1
ffffffffc0202a1a:	00004517          	auipc	a0,0x4
ffffffffc0202a1e:	f4e50513          	addi	a0,a0,-178 # ffffffffc0206968 <default_pmm_manager+0x208>
ffffffffc0202a22:	f72fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0202a26:	c8000737          	lui	a4,0xc8000
ffffffffc0202a2a:	87a2                	mv	a5,s0
ffffffffc0202a2c:	54876163          	bltu	a4,s0,ffffffffc0202f6e <pmm_init+0x5ce>
ffffffffc0202a30:	757d                	lui	a0,0xfffff
ffffffffc0202a32:	000dd617          	auipc	a2,0xdd
ffffffffc0202a36:	11160613          	addi	a2,a2,273 # ffffffffc02dfb43 <end+0xfff>
ffffffffc0202a3a:	8e69                	and	a2,a2,a0
ffffffffc0202a3c:	000dc497          	auipc	s1,0xdc
ffffffffc0202a40:	0c448493          	addi	s1,s1,196 # ffffffffc02deb00 <npage>
ffffffffc0202a44:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202a48:	000dcb97          	auipc	s7,0xdc
ffffffffc0202a4c:	0c0b8b93          	addi	s7,s7,192 # ffffffffc02deb08 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202a50:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202a52:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202a56:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202a5a:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202a5c:	02f50863          	beq	a0,a5,ffffffffc0202a8c <pmm_init+0xec>
ffffffffc0202a60:	4781                	li	a5,0
ffffffffc0202a62:	4585                	li	a1,1
ffffffffc0202a64:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202a68:	00679513          	slli	a0,a5,0x6
ffffffffc0202a6c:	9532                	add	a0,a0,a2
ffffffffc0202a6e:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd204c4>
ffffffffc0202a72:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202a76:	6088                	ld	a0,0(s1)
ffffffffc0202a78:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202a7a:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202a7e:	00d50733          	add	a4,a0,a3
ffffffffc0202a82:	fee7e3e3          	bltu	a5,a4,ffffffffc0202a68 <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202a86:	071a                	slli	a4,a4,0x6
ffffffffc0202a88:	00e606b3          	add	a3,a2,a4
ffffffffc0202a8c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202a90:	2ef6ece3          	bltu	a3,a5,ffffffffc0203588 <pmm_init+0xbe8>
ffffffffc0202a94:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202a98:	77fd                	lui	a5,0xfffff
ffffffffc0202a9a:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202a9c:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202a9e:	5086eb63          	bltu	a3,s0,ffffffffc0202fb4 <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202aa2:	00004517          	auipc	a0,0x4
ffffffffc0202aa6:	eee50513          	addi	a0,a0,-274 # ffffffffc0206990 <default_pmm_manager+0x230>
ffffffffc0202aaa:	eeafd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202aae:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202ab2:	000dc917          	auipc	s2,0xdc
ffffffffc0202ab6:	04690913          	addi	s2,s2,70 # ffffffffc02deaf8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202aba:	7b9c                	ld	a5,48(a5)
ffffffffc0202abc:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202abe:	00004517          	auipc	a0,0x4
ffffffffc0202ac2:	eea50513          	addi	a0,a0,-278 # ffffffffc02069a8 <default_pmm_manager+0x248>
ffffffffc0202ac6:	ecefd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202aca:	00007697          	auipc	a3,0x7
ffffffffc0202ace:	53668693          	addi	a3,a3,1334 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202ad2:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202ad6:	c02007b7          	lui	a5,0xc0200
ffffffffc0202ada:	28f6ebe3          	bltu	a3,a5,ffffffffc0203570 <pmm_init+0xbd0>
ffffffffc0202ade:	0009b783          	ld	a5,0(s3)
ffffffffc0202ae2:	8e9d                	sub	a3,a3,a5
ffffffffc0202ae4:	000dc797          	auipc	a5,0xdc
ffffffffc0202ae8:	00d7b623          	sd	a3,12(a5) # ffffffffc02deaf0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202aec:	100027f3          	csrr	a5,sstatus
ffffffffc0202af0:	8b89                	andi	a5,a5,2
ffffffffc0202af2:	4a079763          	bnez	a5,ffffffffc0202fa0 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202af6:	000b3783          	ld	a5,0(s6)
ffffffffc0202afa:	779c                	ld	a5,40(a5)
ffffffffc0202afc:	9782                	jalr	a5
ffffffffc0202afe:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202b00:	6098                	ld	a4,0(s1)
ffffffffc0202b02:	c80007b7          	lui	a5,0xc8000
ffffffffc0202b06:	83b1                	srli	a5,a5,0xc
ffffffffc0202b08:	66e7e363          	bltu	a5,a4,ffffffffc020316e <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202b0c:	00093503          	ld	a0,0(s2)
ffffffffc0202b10:	62050f63          	beqz	a0,ffffffffc020314e <pmm_init+0x7ae>
ffffffffc0202b14:	03451793          	slli	a5,a0,0x34
ffffffffc0202b18:	62079b63          	bnez	a5,ffffffffc020314e <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202b1c:	4601                	li	a2,0
ffffffffc0202b1e:	4581                	li	a1,0
ffffffffc0202b20:	efcff0ef          	jal	ra,ffffffffc020221c <get_page>
ffffffffc0202b24:	60051563          	bnez	a0,ffffffffc020312e <pmm_init+0x78e>
ffffffffc0202b28:	100027f3          	csrr	a5,sstatus
ffffffffc0202b2c:	8b89                	andi	a5,a5,2
ffffffffc0202b2e:	44079e63          	bnez	a5,ffffffffc0202f8a <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202b32:	000b3783          	ld	a5,0(s6)
ffffffffc0202b36:	4505                	li	a0,1
ffffffffc0202b38:	6f9c                	ld	a5,24(a5)
ffffffffc0202b3a:	9782                	jalr	a5
ffffffffc0202b3c:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202b3e:	00093503          	ld	a0,0(s2)
ffffffffc0202b42:	4681                	li	a3,0
ffffffffc0202b44:	4601                	li	a2,0
ffffffffc0202b46:	85d2                	mv	a1,s4
ffffffffc0202b48:	d63ff0ef          	jal	ra,ffffffffc02028aa <page_insert>
ffffffffc0202b4c:	26051ae3          	bnez	a0,ffffffffc02035c0 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202b50:	00093503          	ld	a0,0(s2)
ffffffffc0202b54:	4601                	li	a2,0
ffffffffc0202b56:	4581                	li	a1,0
ffffffffc0202b58:	c9cff0ef          	jal	ra,ffffffffc0201ff4 <get_pte>
ffffffffc0202b5c:	240502e3          	beqz	a0,ffffffffc02035a0 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0202b60:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202b62:	0017f713          	andi	a4,a5,1
ffffffffc0202b66:	5a070263          	beqz	a4,ffffffffc020310a <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202b6a:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202b6c:	078a                	slli	a5,a5,0x2
ffffffffc0202b6e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b70:	58e7fb63          	bgeu	a5,a4,ffffffffc0203106 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b74:	000bb683          	ld	a3,0(s7)
ffffffffc0202b78:	fff80637          	lui	a2,0xfff80
ffffffffc0202b7c:	97b2                	add	a5,a5,a2
ffffffffc0202b7e:	079a                	slli	a5,a5,0x6
ffffffffc0202b80:	97b6                	add	a5,a5,a3
ffffffffc0202b82:	14fa17e3          	bne	s4,a5,ffffffffc02034d0 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc0202b86:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8ba0>
ffffffffc0202b8a:	4785                	li	a5,1
ffffffffc0202b8c:	12f692e3          	bne	a3,a5,ffffffffc02034b0 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202b90:	00093503          	ld	a0,0(s2)
ffffffffc0202b94:	77fd                	lui	a5,0xfffff
ffffffffc0202b96:	6114                	ld	a3,0(a0)
ffffffffc0202b98:	068a                	slli	a3,a3,0x2
ffffffffc0202b9a:	8efd                	and	a3,a3,a5
ffffffffc0202b9c:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202ba0:	0ee67ce3          	bgeu	a2,a4,ffffffffc0203498 <pmm_init+0xaf8>
ffffffffc0202ba4:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202ba8:	96e2                	add	a3,a3,s8
ffffffffc0202baa:	0006ba83          	ld	s5,0(a3)
ffffffffc0202bae:	0a8a                	slli	s5,s5,0x2
ffffffffc0202bb0:	00fafab3          	and	s5,s5,a5
ffffffffc0202bb4:	00cad793          	srli	a5,s5,0xc
ffffffffc0202bb8:	0ce7f3e3          	bgeu	a5,a4,ffffffffc020347e <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202bbc:	4601                	li	a2,0
ffffffffc0202bbe:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202bc0:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202bc2:	c32ff0ef          	jal	ra,ffffffffc0201ff4 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202bc6:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202bc8:	55551363          	bne	a0,s5,ffffffffc020310e <pmm_init+0x76e>
ffffffffc0202bcc:	100027f3          	csrr	a5,sstatus
ffffffffc0202bd0:	8b89                	andi	a5,a5,2
ffffffffc0202bd2:	3a079163          	bnez	a5,ffffffffc0202f74 <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202bd6:	000b3783          	ld	a5,0(s6)
ffffffffc0202bda:	4505                	li	a0,1
ffffffffc0202bdc:	6f9c                	ld	a5,24(a5)
ffffffffc0202bde:	9782                	jalr	a5
ffffffffc0202be0:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202be2:	00093503          	ld	a0,0(s2)
ffffffffc0202be6:	46d1                	li	a3,20
ffffffffc0202be8:	6605                	lui	a2,0x1
ffffffffc0202bea:	85e2                	mv	a1,s8
ffffffffc0202bec:	cbfff0ef          	jal	ra,ffffffffc02028aa <page_insert>
ffffffffc0202bf0:	060517e3          	bnez	a0,ffffffffc020345e <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202bf4:	00093503          	ld	a0,0(s2)
ffffffffc0202bf8:	4601                	li	a2,0
ffffffffc0202bfa:	6585                	lui	a1,0x1
ffffffffc0202bfc:	bf8ff0ef          	jal	ra,ffffffffc0201ff4 <get_pte>
ffffffffc0202c00:	02050fe3          	beqz	a0,ffffffffc020343e <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc0202c04:	611c                	ld	a5,0(a0)
ffffffffc0202c06:	0107f713          	andi	a4,a5,16
ffffffffc0202c0a:	7c070e63          	beqz	a4,ffffffffc02033e6 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc0202c0e:	8b91                	andi	a5,a5,4
ffffffffc0202c10:	7a078b63          	beqz	a5,ffffffffc02033c6 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202c14:	00093503          	ld	a0,0(s2)
ffffffffc0202c18:	611c                	ld	a5,0(a0)
ffffffffc0202c1a:	8bc1                	andi	a5,a5,16
ffffffffc0202c1c:	78078563          	beqz	a5,ffffffffc02033a6 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc0202c20:	000c2703          	lw	a4,0(s8)
ffffffffc0202c24:	4785                	li	a5,1
ffffffffc0202c26:	76f71063          	bne	a4,a5,ffffffffc0203386 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202c2a:	4681                	li	a3,0
ffffffffc0202c2c:	6605                	lui	a2,0x1
ffffffffc0202c2e:	85d2                	mv	a1,s4
ffffffffc0202c30:	c7bff0ef          	jal	ra,ffffffffc02028aa <page_insert>
ffffffffc0202c34:	72051963          	bnez	a0,ffffffffc0203366 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc0202c38:	000a2703          	lw	a4,0(s4)
ffffffffc0202c3c:	4789                	li	a5,2
ffffffffc0202c3e:	70f71463          	bne	a4,a5,ffffffffc0203346 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc0202c42:	000c2783          	lw	a5,0(s8)
ffffffffc0202c46:	6e079063          	bnez	a5,ffffffffc0203326 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202c4a:	00093503          	ld	a0,0(s2)
ffffffffc0202c4e:	4601                	li	a2,0
ffffffffc0202c50:	6585                	lui	a1,0x1
ffffffffc0202c52:	ba2ff0ef          	jal	ra,ffffffffc0201ff4 <get_pte>
ffffffffc0202c56:	6a050863          	beqz	a0,ffffffffc0203306 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0202c5a:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202c5c:	00177793          	andi	a5,a4,1
ffffffffc0202c60:	4a078563          	beqz	a5,ffffffffc020310a <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202c64:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202c66:	00271793          	slli	a5,a4,0x2
ffffffffc0202c6a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c6c:	48d7fd63          	bgeu	a5,a3,ffffffffc0203106 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c70:	000bb683          	ld	a3,0(s7)
ffffffffc0202c74:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202c78:	97d6                	add	a5,a5,s5
ffffffffc0202c7a:	079a                	slli	a5,a5,0x6
ffffffffc0202c7c:	97b6                	add	a5,a5,a3
ffffffffc0202c7e:	66fa1463          	bne	s4,a5,ffffffffc02032e6 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202c82:	8b41                	andi	a4,a4,16
ffffffffc0202c84:	64071163          	bnez	a4,ffffffffc02032c6 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202c88:	00093503          	ld	a0,0(s2)
ffffffffc0202c8c:	4581                	li	a1,0
ffffffffc0202c8e:	b81ff0ef          	jal	ra,ffffffffc020280e <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202c92:	000a2c83          	lw	s9,0(s4)
ffffffffc0202c96:	4785                	li	a5,1
ffffffffc0202c98:	60fc9763          	bne	s9,a5,ffffffffc02032a6 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202c9c:	000c2783          	lw	a5,0(s8)
ffffffffc0202ca0:	5e079363          	bnez	a5,ffffffffc0203286 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202ca4:	00093503          	ld	a0,0(s2)
ffffffffc0202ca8:	6585                	lui	a1,0x1
ffffffffc0202caa:	b65ff0ef          	jal	ra,ffffffffc020280e <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202cae:	000a2783          	lw	a5,0(s4)
ffffffffc0202cb2:	52079a63          	bnez	a5,ffffffffc02031e6 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202cb6:	000c2783          	lw	a5,0(s8)
ffffffffc0202cba:	50079663          	bnez	a5,ffffffffc02031c6 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202cbe:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202cc2:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cc4:	000a3683          	ld	a3,0(s4)
ffffffffc0202cc8:	068a                	slli	a3,a3,0x2
ffffffffc0202cca:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ccc:	42b6fd63          	bgeu	a3,a1,ffffffffc0203106 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cd0:	000bb503          	ld	a0,0(s7)
ffffffffc0202cd4:	96d6                	add	a3,a3,s5
ffffffffc0202cd6:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202cd8:	00d507b3          	add	a5,a0,a3
ffffffffc0202cdc:	439c                	lw	a5,0(a5)
ffffffffc0202cde:	4d979463          	bne	a5,s9,ffffffffc02031a6 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202ce2:	8699                	srai	a3,a3,0x6
ffffffffc0202ce4:	00080637          	lui	a2,0x80
ffffffffc0202ce8:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202cea:	00c69713          	slli	a4,a3,0xc
ffffffffc0202cee:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202cf0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202cf2:	48b77e63          	bgeu	a4,a1,ffffffffc020318e <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202cf6:	0009b703          	ld	a4,0(s3)
ffffffffc0202cfa:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cfc:	629c                	ld	a5,0(a3)
ffffffffc0202cfe:	078a                	slli	a5,a5,0x2
ffffffffc0202d00:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202d02:	40b7f263          	bgeu	a5,a1,ffffffffc0203106 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d06:	8f91                	sub	a5,a5,a2
ffffffffc0202d08:	079a                	slli	a5,a5,0x6
ffffffffc0202d0a:	953e                	add	a0,a0,a5
ffffffffc0202d0c:	100027f3          	csrr	a5,sstatus
ffffffffc0202d10:	8b89                	andi	a5,a5,2
ffffffffc0202d12:	30079963          	bnez	a5,ffffffffc0203024 <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202d16:	000b3783          	ld	a5,0(s6)
ffffffffc0202d1a:	4585                	li	a1,1
ffffffffc0202d1c:	739c                	ld	a5,32(a5)
ffffffffc0202d1e:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d20:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202d24:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d26:	078a                	slli	a5,a5,0x2
ffffffffc0202d28:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202d2a:	3ce7fe63          	bgeu	a5,a4,ffffffffc0203106 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d2e:	000bb503          	ld	a0,0(s7)
ffffffffc0202d32:	fff80737          	lui	a4,0xfff80
ffffffffc0202d36:	97ba                	add	a5,a5,a4
ffffffffc0202d38:	079a                	slli	a5,a5,0x6
ffffffffc0202d3a:	953e                	add	a0,a0,a5
ffffffffc0202d3c:	100027f3          	csrr	a5,sstatus
ffffffffc0202d40:	8b89                	andi	a5,a5,2
ffffffffc0202d42:	2c079563          	bnez	a5,ffffffffc020300c <pmm_init+0x66c>
ffffffffc0202d46:	000b3783          	ld	a5,0(s6)
ffffffffc0202d4a:	4585                	li	a1,1
ffffffffc0202d4c:	739c                	ld	a5,32(a5)
ffffffffc0202d4e:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202d50:	00093783          	ld	a5,0(s2)
ffffffffc0202d54:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd204bc>
    asm volatile("sfence.vma");
ffffffffc0202d58:	12000073          	sfence.vma
ffffffffc0202d5c:	100027f3          	csrr	a5,sstatus
ffffffffc0202d60:	8b89                	andi	a5,a5,2
ffffffffc0202d62:	28079b63          	bnez	a5,ffffffffc0202ff8 <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d66:	000b3783          	ld	a5,0(s6)
ffffffffc0202d6a:	779c                	ld	a5,40(a5)
ffffffffc0202d6c:	9782                	jalr	a5
ffffffffc0202d6e:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202d70:	4b441b63          	bne	s0,s4,ffffffffc0203226 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202d74:	00004517          	auipc	a0,0x4
ffffffffc0202d78:	f5c50513          	addi	a0,a0,-164 # ffffffffc0206cd0 <default_pmm_manager+0x570>
ffffffffc0202d7c:	c18fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202d80:	100027f3          	csrr	a5,sstatus
ffffffffc0202d84:	8b89                	andi	a5,a5,2
ffffffffc0202d86:	24079f63          	bnez	a5,ffffffffc0202fe4 <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d8a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d8e:	779c                	ld	a5,40(a5)
ffffffffc0202d90:	9782                	jalr	a5
ffffffffc0202d92:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202d94:	6098                	ld	a4,0(s1)
ffffffffc0202d96:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202d9a:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202d9c:	00c71793          	slli	a5,a4,0xc
ffffffffc0202da0:	6a05                	lui	s4,0x1
ffffffffc0202da2:	02f47c63          	bgeu	s0,a5,ffffffffc0202dda <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202da6:	00c45793          	srli	a5,s0,0xc
ffffffffc0202daa:	00093503          	ld	a0,0(s2)
ffffffffc0202dae:	2ee7ff63          	bgeu	a5,a4,ffffffffc02030ac <pmm_init+0x70c>
ffffffffc0202db2:	0009b583          	ld	a1,0(s3)
ffffffffc0202db6:	4601                	li	a2,0
ffffffffc0202db8:	95a2                	add	a1,a1,s0
ffffffffc0202dba:	a3aff0ef          	jal	ra,ffffffffc0201ff4 <get_pte>
ffffffffc0202dbe:	32050463          	beqz	a0,ffffffffc02030e6 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202dc2:	611c                	ld	a5,0(a0)
ffffffffc0202dc4:	078a                	slli	a5,a5,0x2
ffffffffc0202dc6:	0157f7b3          	and	a5,a5,s5
ffffffffc0202dca:	2e879e63          	bne	a5,s0,ffffffffc02030c6 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202dce:	6098                	ld	a4,0(s1)
ffffffffc0202dd0:	9452                	add	s0,s0,s4
ffffffffc0202dd2:	00c71793          	slli	a5,a4,0xc
ffffffffc0202dd6:	fcf468e3          	bltu	s0,a5,ffffffffc0202da6 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202dda:	00093783          	ld	a5,0(s2)
ffffffffc0202dde:	639c                	ld	a5,0(a5)
ffffffffc0202de0:	42079363          	bnez	a5,ffffffffc0203206 <pmm_init+0x866>
ffffffffc0202de4:	100027f3          	csrr	a5,sstatus
ffffffffc0202de8:	8b89                	andi	a5,a5,2
ffffffffc0202dea:	24079963          	bnez	a5,ffffffffc020303c <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202dee:	000b3783          	ld	a5,0(s6)
ffffffffc0202df2:	4505                	li	a0,1
ffffffffc0202df4:	6f9c                	ld	a5,24(a5)
ffffffffc0202df6:	9782                	jalr	a5
ffffffffc0202df8:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202dfa:	00093503          	ld	a0,0(s2)
ffffffffc0202dfe:	4699                	li	a3,6
ffffffffc0202e00:	10000613          	li	a2,256
ffffffffc0202e04:	85d2                	mv	a1,s4
ffffffffc0202e06:	aa5ff0ef          	jal	ra,ffffffffc02028aa <page_insert>
ffffffffc0202e0a:	44051e63          	bnez	a0,ffffffffc0203266 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202e0e:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8ba0>
ffffffffc0202e12:	4785                	li	a5,1
ffffffffc0202e14:	42f71963          	bne	a4,a5,ffffffffc0203246 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202e18:	00093503          	ld	a0,0(s2)
ffffffffc0202e1c:	6405                	lui	s0,0x1
ffffffffc0202e1e:	4699                	li	a3,6
ffffffffc0202e20:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8aa0>
ffffffffc0202e24:	85d2                	mv	a1,s4
ffffffffc0202e26:	a85ff0ef          	jal	ra,ffffffffc02028aa <page_insert>
ffffffffc0202e2a:	72051363          	bnez	a0,ffffffffc0203550 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202e2e:	000a2703          	lw	a4,0(s4)
ffffffffc0202e32:	4789                	li	a5,2
ffffffffc0202e34:	6ef71e63          	bne	a4,a5,ffffffffc0203530 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202e38:	00004597          	auipc	a1,0x4
ffffffffc0202e3c:	fe058593          	addi	a1,a1,-32 # ffffffffc0206e18 <default_pmm_manager+0x6b8>
ffffffffc0202e40:	10000513          	li	a0,256
ffffffffc0202e44:	221020ef          	jal	ra,ffffffffc0205864 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202e48:	10040593          	addi	a1,s0,256
ffffffffc0202e4c:	10000513          	li	a0,256
ffffffffc0202e50:	227020ef          	jal	ra,ffffffffc0205876 <strcmp>
ffffffffc0202e54:	6a051e63          	bnez	a0,ffffffffc0203510 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202e58:	000bb683          	ld	a3,0(s7)
ffffffffc0202e5c:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202e60:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202e62:	40da06b3          	sub	a3,s4,a3
ffffffffc0202e66:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202e68:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202e6a:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202e6c:	8031                	srli	s0,s0,0xc
ffffffffc0202e6e:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202e72:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202e74:	30f77d63          	bgeu	a4,a5,ffffffffc020318e <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202e78:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202e7c:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202e80:	96be                	add	a3,a3,a5
ffffffffc0202e82:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202e86:	1a9020ef          	jal	ra,ffffffffc020582e <strlen>
ffffffffc0202e8a:	66051363          	bnez	a0,ffffffffc02034f0 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202e8e:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202e92:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e94:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd204bc>
ffffffffc0202e98:	068a                	slli	a3,a3,0x2
ffffffffc0202e9a:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e9c:	26f6f563          	bgeu	a3,a5,ffffffffc0203106 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202ea0:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202ea2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202ea4:	2ef47563          	bgeu	s0,a5,ffffffffc020318e <pmm_init+0x7ee>
ffffffffc0202ea8:	0009b403          	ld	s0,0(s3)
ffffffffc0202eac:	9436                	add	s0,s0,a3
ffffffffc0202eae:	100027f3          	csrr	a5,sstatus
ffffffffc0202eb2:	8b89                	andi	a5,a5,2
ffffffffc0202eb4:	1e079163          	bnez	a5,ffffffffc0203096 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202eb8:	000b3783          	ld	a5,0(s6)
ffffffffc0202ebc:	4585                	li	a1,1
ffffffffc0202ebe:	8552                	mv	a0,s4
ffffffffc0202ec0:	739c                	ld	a5,32(a5)
ffffffffc0202ec2:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ec4:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202ec6:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ec8:	078a                	slli	a5,a5,0x2
ffffffffc0202eca:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ecc:	22e7fd63          	bgeu	a5,a4,ffffffffc0203106 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ed0:	000bb503          	ld	a0,0(s7)
ffffffffc0202ed4:	fff80737          	lui	a4,0xfff80
ffffffffc0202ed8:	97ba                	add	a5,a5,a4
ffffffffc0202eda:	079a                	slli	a5,a5,0x6
ffffffffc0202edc:	953e                	add	a0,a0,a5
ffffffffc0202ede:	100027f3          	csrr	a5,sstatus
ffffffffc0202ee2:	8b89                	andi	a5,a5,2
ffffffffc0202ee4:	18079d63          	bnez	a5,ffffffffc020307e <pmm_init+0x6de>
ffffffffc0202ee8:	000b3783          	ld	a5,0(s6)
ffffffffc0202eec:	4585                	li	a1,1
ffffffffc0202eee:	739c                	ld	a5,32(a5)
ffffffffc0202ef0:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ef2:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202ef6:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ef8:	078a                	slli	a5,a5,0x2
ffffffffc0202efa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202efc:	20e7f563          	bgeu	a5,a4,ffffffffc0203106 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202f00:	000bb503          	ld	a0,0(s7)
ffffffffc0202f04:	fff80737          	lui	a4,0xfff80
ffffffffc0202f08:	97ba                	add	a5,a5,a4
ffffffffc0202f0a:	079a                	slli	a5,a5,0x6
ffffffffc0202f0c:	953e                	add	a0,a0,a5
ffffffffc0202f0e:	100027f3          	csrr	a5,sstatus
ffffffffc0202f12:	8b89                	andi	a5,a5,2
ffffffffc0202f14:	14079963          	bnez	a5,ffffffffc0203066 <pmm_init+0x6c6>
ffffffffc0202f18:	000b3783          	ld	a5,0(s6)
ffffffffc0202f1c:	4585                	li	a1,1
ffffffffc0202f1e:	739c                	ld	a5,32(a5)
ffffffffc0202f20:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202f22:	00093783          	ld	a5,0(s2)
ffffffffc0202f26:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202f2a:	12000073          	sfence.vma
ffffffffc0202f2e:	100027f3          	csrr	a5,sstatus
ffffffffc0202f32:	8b89                	andi	a5,a5,2
ffffffffc0202f34:	10079f63          	bnez	a5,ffffffffc0203052 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202f38:	000b3783          	ld	a5,0(s6)
ffffffffc0202f3c:	779c                	ld	a5,40(a5)
ffffffffc0202f3e:	9782                	jalr	a5
ffffffffc0202f40:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202f42:	4c8c1e63          	bne	s8,s0,ffffffffc020341e <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202f46:	00004517          	auipc	a0,0x4
ffffffffc0202f4a:	f4a50513          	addi	a0,a0,-182 # ffffffffc0206e90 <default_pmm_manager+0x730>
ffffffffc0202f4e:	a46fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0202f52:	7406                	ld	s0,96(sp)
ffffffffc0202f54:	70a6                	ld	ra,104(sp)
ffffffffc0202f56:	64e6                	ld	s1,88(sp)
ffffffffc0202f58:	6946                	ld	s2,80(sp)
ffffffffc0202f5a:	69a6                	ld	s3,72(sp)
ffffffffc0202f5c:	6a06                	ld	s4,64(sp)
ffffffffc0202f5e:	7ae2                	ld	s5,56(sp)
ffffffffc0202f60:	7b42                	ld	s6,48(sp)
ffffffffc0202f62:	7ba2                	ld	s7,40(sp)
ffffffffc0202f64:	7c02                	ld	s8,32(sp)
ffffffffc0202f66:	6ce2                	ld	s9,24(sp)
ffffffffc0202f68:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202f6a:	dd1fe06f          	j	ffffffffc0201d3a <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202f6e:	c80007b7          	lui	a5,0xc8000
ffffffffc0202f72:	bc7d                	j	ffffffffc0202a30 <pmm_init+0x90>
        intr_disable();
ffffffffc0202f74:	a41fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202f78:	000b3783          	ld	a5,0(s6)
ffffffffc0202f7c:	4505                	li	a0,1
ffffffffc0202f7e:	6f9c                	ld	a5,24(a5)
ffffffffc0202f80:	9782                	jalr	a5
ffffffffc0202f82:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202f84:	a2bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202f88:	b9a9                	j	ffffffffc0202be2 <pmm_init+0x242>
        intr_disable();
ffffffffc0202f8a:	a2bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202f8e:	000b3783          	ld	a5,0(s6)
ffffffffc0202f92:	4505                	li	a0,1
ffffffffc0202f94:	6f9c                	ld	a5,24(a5)
ffffffffc0202f96:	9782                	jalr	a5
ffffffffc0202f98:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202f9a:	a15fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202f9e:	b645                	j	ffffffffc0202b3e <pmm_init+0x19e>
        intr_disable();
ffffffffc0202fa0:	a15fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202fa4:	000b3783          	ld	a5,0(s6)
ffffffffc0202fa8:	779c                	ld	a5,40(a5)
ffffffffc0202faa:	9782                	jalr	a5
ffffffffc0202fac:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202fae:	a01fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202fb2:	b6b9                	j	ffffffffc0202b00 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202fb4:	6705                	lui	a4,0x1
ffffffffc0202fb6:	177d                	addi	a4,a4,-1
ffffffffc0202fb8:	96ba                	add	a3,a3,a4
ffffffffc0202fba:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202fbc:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202fc0:	14a77363          	bgeu	a4,a0,ffffffffc0203106 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202fc4:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202fc8:	fff80537          	lui	a0,0xfff80
ffffffffc0202fcc:	972a                	add	a4,a4,a0
ffffffffc0202fce:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202fd0:	8c1d                	sub	s0,s0,a5
ffffffffc0202fd2:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202fd6:	00c45593          	srli	a1,s0,0xc
ffffffffc0202fda:	9532                	add	a0,a0,a2
ffffffffc0202fdc:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202fde:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202fe2:	b4c1                	j	ffffffffc0202aa2 <pmm_init+0x102>
        intr_disable();
ffffffffc0202fe4:	9d1fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202fe8:	000b3783          	ld	a5,0(s6)
ffffffffc0202fec:	779c                	ld	a5,40(a5)
ffffffffc0202fee:	9782                	jalr	a5
ffffffffc0202ff0:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202ff2:	9bdfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202ff6:	bb79                	j	ffffffffc0202d94 <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202ff8:	9bdfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202ffc:	000b3783          	ld	a5,0(s6)
ffffffffc0203000:	779c                	ld	a5,40(a5)
ffffffffc0203002:	9782                	jalr	a5
ffffffffc0203004:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0203006:	9a9fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020300a:	b39d                	j	ffffffffc0202d70 <pmm_init+0x3d0>
ffffffffc020300c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020300e:	9a7fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0203012:	000b3783          	ld	a5,0(s6)
ffffffffc0203016:	6522                	ld	a0,8(sp)
ffffffffc0203018:	4585                	li	a1,1
ffffffffc020301a:	739c                	ld	a5,32(a5)
ffffffffc020301c:	9782                	jalr	a5
        intr_enable();
ffffffffc020301e:	991fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203022:	b33d                	j	ffffffffc0202d50 <pmm_init+0x3b0>
ffffffffc0203024:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203026:	98ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020302a:	000b3783          	ld	a5,0(s6)
ffffffffc020302e:	6522                	ld	a0,8(sp)
ffffffffc0203030:	4585                	li	a1,1
ffffffffc0203032:	739c                	ld	a5,32(a5)
ffffffffc0203034:	9782                	jalr	a5
        intr_enable();
ffffffffc0203036:	979fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020303a:	b1dd                	j	ffffffffc0202d20 <pmm_init+0x380>
        intr_disable();
ffffffffc020303c:	979fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203040:	000b3783          	ld	a5,0(s6)
ffffffffc0203044:	4505                	li	a0,1
ffffffffc0203046:	6f9c                	ld	a5,24(a5)
ffffffffc0203048:	9782                	jalr	a5
ffffffffc020304a:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc020304c:	963fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203050:	b36d                	j	ffffffffc0202dfa <pmm_init+0x45a>
        intr_disable();
ffffffffc0203052:	963fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0203056:	000b3783          	ld	a5,0(s6)
ffffffffc020305a:	779c                	ld	a5,40(a5)
ffffffffc020305c:	9782                	jalr	a5
ffffffffc020305e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203060:	94ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203064:	bdf9                	j	ffffffffc0202f42 <pmm_init+0x5a2>
ffffffffc0203066:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203068:	94dfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020306c:	000b3783          	ld	a5,0(s6)
ffffffffc0203070:	6522                	ld	a0,8(sp)
ffffffffc0203072:	4585                	li	a1,1
ffffffffc0203074:	739c                	ld	a5,32(a5)
ffffffffc0203076:	9782                	jalr	a5
        intr_enable();
ffffffffc0203078:	937fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020307c:	b55d                	j	ffffffffc0202f22 <pmm_init+0x582>
ffffffffc020307e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203080:	935fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203084:	000b3783          	ld	a5,0(s6)
ffffffffc0203088:	6522                	ld	a0,8(sp)
ffffffffc020308a:	4585                	li	a1,1
ffffffffc020308c:	739c                	ld	a5,32(a5)
ffffffffc020308e:	9782                	jalr	a5
        intr_enable();
ffffffffc0203090:	91ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203094:	bdb9                	j	ffffffffc0202ef2 <pmm_init+0x552>
        intr_disable();
ffffffffc0203096:	91ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020309a:	000b3783          	ld	a5,0(s6)
ffffffffc020309e:	4585                	li	a1,1
ffffffffc02030a0:	8552                	mv	a0,s4
ffffffffc02030a2:	739c                	ld	a5,32(a5)
ffffffffc02030a4:	9782                	jalr	a5
        intr_enable();
ffffffffc02030a6:	909fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02030aa:	bd29                	j	ffffffffc0202ec4 <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02030ac:	86a2                	mv	a3,s0
ffffffffc02030ae:	00003617          	auipc	a2,0x3
ffffffffc02030b2:	6ea60613          	addi	a2,a2,1770 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc02030b6:	26f00593          	li	a1,623
ffffffffc02030ba:	00003517          	auipc	a0,0x3
ffffffffc02030be:	7f650513          	addi	a0,a0,2038 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02030c2:	bccfd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02030c6:	00004697          	auipc	a3,0x4
ffffffffc02030ca:	c6a68693          	addi	a3,a3,-918 # ffffffffc0206d30 <default_pmm_manager+0x5d0>
ffffffffc02030ce:	00003617          	auipc	a2,0x3
ffffffffc02030d2:	2e260613          	addi	a2,a2,738 # ffffffffc02063b0 <commands+0x848>
ffffffffc02030d6:	27000593          	li	a1,624
ffffffffc02030da:	00003517          	auipc	a0,0x3
ffffffffc02030de:	7d650513          	addi	a0,a0,2006 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02030e2:	bacfd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02030e6:	00004697          	auipc	a3,0x4
ffffffffc02030ea:	c0a68693          	addi	a3,a3,-1014 # ffffffffc0206cf0 <default_pmm_manager+0x590>
ffffffffc02030ee:	00003617          	auipc	a2,0x3
ffffffffc02030f2:	2c260613          	addi	a2,a2,706 # ffffffffc02063b0 <commands+0x848>
ffffffffc02030f6:	26f00593          	li	a1,623
ffffffffc02030fa:	00003517          	auipc	a0,0x3
ffffffffc02030fe:	7b650513          	addi	a0,a0,1974 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203102:	b8cfd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203106:	dfffe0ef          	jal	ra,ffffffffc0201f04 <pa2page.part.0>
ffffffffc020310a:	e17fe0ef          	jal	ra,ffffffffc0201f20 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020310e:	00004697          	auipc	a3,0x4
ffffffffc0203112:	9da68693          	addi	a3,a3,-1574 # ffffffffc0206ae8 <default_pmm_manager+0x388>
ffffffffc0203116:	00003617          	auipc	a2,0x3
ffffffffc020311a:	29a60613          	addi	a2,a2,666 # ffffffffc02063b0 <commands+0x848>
ffffffffc020311e:	23f00593          	li	a1,575
ffffffffc0203122:	00003517          	auipc	a0,0x3
ffffffffc0203126:	78e50513          	addi	a0,a0,1934 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020312a:	b64fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc020312e:	00004697          	auipc	a3,0x4
ffffffffc0203132:	8fa68693          	addi	a3,a3,-1798 # ffffffffc0206a28 <default_pmm_manager+0x2c8>
ffffffffc0203136:	00003617          	auipc	a2,0x3
ffffffffc020313a:	27a60613          	addi	a2,a2,634 # ffffffffc02063b0 <commands+0x848>
ffffffffc020313e:	23200593          	li	a1,562
ffffffffc0203142:	00003517          	auipc	a0,0x3
ffffffffc0203146:	76e50513          	addi	a0,a0,1902 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020314a:	b44fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc020314e:	00004697          	auipc	a3,0x4
ffffffffc0203152:	89a68693          	addi	a3,a3,-1894 # ffffffffc02069e8 <default_pmm_manager+0x288>
ffffffffc0203156:	00003617          	auipc	a2,0x3
ffffffffc020315a:	25a60613          	addi	a2,a2,602 # ffffffffc02063b0 <commands+0x848>
ffffffffc020315e:	23100593          	li	a1,561
ffffffffc0203162:	00003517          	auipc	a0,0x3
ffffffffc0203166:	74e50513          	addi	a0,a0,1870 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020316a:	b24fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020316e:	00004697          	auipc	a3,0x4
ffffffffc0203172:	85a68693          	addi	a3,a3,-1958 # ffffffffc02069c8 <default_pmm_manager+0x268>
ffffffffc0203176:	00003617          	auipc	a2,0x3
ffffffffc020317a:	23a60613          	addi	a2,a2,570 # ffffffffc02063b0 <commands+0x848>
ffffffffc020317e:	23000593          	li	a1,560
ffffffffc0203182:	00003517          	auipc	a0,0x3
ffffffffc0203186:	72e50513          	addi	a0,a0,1838 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020318a:	b04fd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc020318e:	00003617          	auipc	a2,0x3
ffffffffc0203192:	60a60613          	addi	a2,a2,1546 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc0203196:	07100593          	li	a1,113
ffffffffc020319a:	00003517          	auipc	a0,0x3
ffffffffc020319e:	62650513          	addi	a0,a0,1574 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc02031a2:	aecfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc02031a6:	00004697          	auipc	a3,0x4
ffffffffc02031aa:	ad268693          	addi	a3,a3,-1326 # ffffffffc0206c78 <default_pmm_manager+0x518>
ffffffffc02031ae:	00003617          	auipc	a2,0x3
ffffffffc02031b2:	20260613          	addi	a2,a2,514 # ffffffffc02063b0 <commands+0x848>
ffffffffc02031b6:	25800593          	li	a1,600
ffffffffc02031ba:	00003517          	auipc	a0,0x3
ffffffffc02031be:	6f650513          	addi	a0,a0,1782 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02031c2:	accfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02031c6:	00004697          	auipc	a3,0x4
ffffffffc02031ca:	a6a68693          	addi	a3,a3,-1430 # ffffffffc0206c30 <default_pmm_manager+0x4d0>
ffffffffc02031ce:	00003617          	auipc	a2,0x3
ffffffffc02031d2:	1e260613          	addi	a2,a2,482 # ffffffffc02063b0 <commands+0x848>
ffffffffc02031d6:	25600593          	li	a1,598
ffffffffc02031da:	00003517          	auipc	a0,0x3
ffffffffc02031de:	6d650513          	addi	a0,a0,1750 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02031e2:	aacfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc02031e6:	00004697          	auipc	a3,0x4
ffffffffc02031ea:	a7a68693          	addi	a3,a3,-1414 # ffffffffc0206c60 <default_pmm_manager+0x500>
ffffffffc02031ee:	00003617          	auipc	a2,0x3
ffffffffc02031f2:	1c260613          	addi	a2,a2,450 # ffffffffc02063b0 <commands+0x848>
ffffffffc02031f6:	25500593          	li	a1,597
ffffffffc02031fa:	00003517          	auipc	a0,0x3
ffffffffc02031fe:	6b650513          	addi	a0,a0,1718 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203202:	a8cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0203206:	00004697          	auipc	a3,0x4
ffffffffc020320a:	b4268693          	addi	a3,a3,-1214 # ffffffffc0206d48 <default_pmm_manager+0x5e8>
ffffffffc020320e:	00003617          	auipc	a2,0x3
ffffffffc0203212:	1a260613          	addi	a2,a2,418 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203216:	27300593          	li	a1,627
ffffffffc020321a:	00003517          	auipc	a0,0x3
ffffffffc020321e:	69650513          	addi	a0,a0,1686 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203222:	a6cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203226:	00004697          	auipc	a3,0x4
ffffffffc020322a:	a8268693          	addi	a3,a3,-1406 # ffffffffc0206ca8 <default_pmm_manager+0x548>
ffffffffc020322e:	00003617          	auipc	a2,0x3
ffffffffc0203232:	18260613          	addi	a2,a2,386 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203236:	26000593          	li	a1,608
ffffffffc020323a:	00003517          	auipc	a0,0x3
ffffffffc020323e:	67650513          	addi	a0,a0,1654 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203242:	a4cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 1);
ffffffffc0203246:	00004697          	auipc	a3,0x4
ffffffffc020324a:	b5a68693          	addi	a3,a3,-1190 # ffffffffc0206da0 <default_pmm_manager+0x640>
ffffffffc020324e:	00003617          	auipc	a2,0x3
ffffffffc0203252:	16260613          	addi	a2,a2,354 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203256:	27800593          	li	a1,632
ffffffffc020325a:	00003517          	auipc	a0,0x3
ffffffffc020325e:	65650513          	addi	a0,a0,1622 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203262:	a2cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203266:	00004697          	auipc	a3,0x4
ffffffffc020326a:	afa68693          	addi	a3,a3,-1286 # ffffffffc0206d60 <default_pmm_manager+0x600>
ffffffffc020326e:	00003617          	auipc	a2,0x3
ffffffffc0203272:	14260613          	addi	a2,a2,322 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203276:	27700593          	li	a1,631
ffffffffc020327a:	00003517          	auipc	a0,0x3
ffffffffc020327e:	63650513          	addi	a0,a0,1590 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203282:	a0cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203286:	00004697          	auipc	a3,0x4
ffffffffc020328a:	9aa68693          	addi	a3,a3,-1622 # ffffffffc0206c30 <default_pmm_manager+0x4d0>
ffffffffc020328e:	00003617          	auipc	a2,0x3
ffffffffc0203292:	12260613          	addi	a2,a2,290 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203296:	25200593          	li	a1,594
ffffffffc020329a:	00003517          	auipc	a0,0x3
ffffffffc020329e:	61650513          	addi	a0,a0,1558 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02032a2:	9ecfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02032a6:	00004697          	auipc	a3,0x4
ffffffffc02032aa:	82a68693          	addi	a3,a3,-2006 # ffffffffc0206ad0 <default_pmm_manager+0x370>
ffffffffc02032ae:	00003617          	auipc	a2,0x3
ffffffffc02032b2:	10260613          	addi	a2,a2,258 # ffffffffc02063b0 <commands+0x848>
ffffffffc02032b6:	25100593          	li	a1,593
ffffffffc02032ba:	00003517          	auipc	a0,0x3
ffffffffc02032be:	5f650513          	addi	a0,a0,1526 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02032c2:	9ccfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02032c6:	00004697          	auipc	a3,0x4
ffffffffc02032ca:	98268693          	addi	a3,a3,-1662 # ffffffffc0206c48 <default_pmm_manager+0x4e8>
ffffffffc02032ce:	00003617          	auipc	a2,0x3
ffffffffc02032d2:	0e260613          	addi	a2,a2,226 # ffffffffc02063b0 <commands+0x848>
ffffffffc02032d6:	24e00593          	li	a1,590
ffffffffc02032da:	00003517          	auipc	a0,0x3
ffffffffc02032de:	5d650513          	addi	a0,a0,1494 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02032e2:	9acfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02032e6:	00003697          	auipc	a3,0x3
ffffffffc02032ea:	7d268693          	addi	a3,a3,2002 # ffffffffc0206ab8 <default_pmm_manager+0x358>
ffffffffc02032ee:	00003617          	auipc	a2,0x3
ffffffffc02032f2:	0c260613          	addi	a2,a2,194 # ffffffffc02063b0 <commands+0x848>
ffffffffc02032f6:	24d00593          	li	a1,589
ffffffffc02032fa:	00003517          	auipc	a0,0x3
ffffffffc02032fe:	5b650513          	addi	a0,a0,1462 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203302:	98cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203306:	00004697          	auipc	a3,0x4
ffffffffc020330a:	85268693          	addi	a3,a3,-1966 # ffffffffc0206b58 <default_pmm_manager+0x3f8>
ffffffffc020330e:	00003617          	auipc	a2,0x3
ffffffffc0203312:	0a260613          	addi	a2,a2,162 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203316:	24c00593          	li	a1,588
ffffffffc020331a:	00003517          	auipc	a0,0x3
ffffffffc020331e:	59650513          	addi	a0,a0,1430 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203322:	96cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203326:	00004697          	auipc	a3,0x4
ffffffffc020332a:	90a68693          	addi	a3,a3,-1782 # ffffffffc0206c30 <default_pmm_manager+0x4d0>
ffffffffc020332e:	00003617          	auipc	a2,0x3
ffffffffc0203332:	08260613          	addi	a2,a2,130 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203336:	24b00593          	li	a1,587
ffffffffc020333a:	00003517          	auipc	a0,0x3
ffffffffc020333e:	57650513          	addi	a0,a0,1398 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203342:	94cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203346:	00004697          	auipc	a3,0x4
ffffffffc020334a:	8d268693          	addi	a3,a3,-1838 # ffffffffc0206c18 <default_pmm_manager+0x4b8>
ffffffffc020334e:	00003617          	auipc	a2,0x3
ffffffffc0203352:	06260613          	addi	a2,a2,98 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203356:	24a00593          	li	a1,586
ffffffffc020335a:	00003517          	auipc	a0,0x3
ffffffffc020335e:	55650513          	addi	a0,a0,1366 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203362:	92cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203366:	00004697          	auipc	a3,0x4
ffffffffc020336a:	88268693          	addi	a3,a3,-1918 # ffffffffc0206be8 <default_pmm_manager+0x488>
ffffffffc020336e:	00003617          	auipc	a2,0x3
ffffffffc0203372:	04260613          	addi	a2,a2,66 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203376:	24900593          	li	a1,585
ffffffffc020337a:	00003517          	auipc	a0,0x3
ffffffffc020337e:	53650513          	addi	a0,a0,1334 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203382:	90cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203386:	00004697          	auipc	a3,0x4
ffffffffc020338a:	84a68693          	addi	a3,a3,-1974 # ffffffffc0206bd0 <default_pmm_manager+0x470>
ffffffffc020338e:	00003617          	auipc	a2,0x3
ffffffffc0203392:	02260613          	addi	a2,a2,34 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203396:	24700593          	li	a1,583
ffffffffc020339a:	00003517          	auipc	a0,0x3
ffffffffc020339e:	51650513          	addi	a0,a0,1302 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02033a2:	8ecfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02033a6:	00004697          	auipc	a3,0x4
ffffffffc02033aa:	80a68693          	addi	a3,a3,-2038 # ffffffffc0206bb0 <default_pmm_manager+0x450>
ffffffffc02033ae:	00003617          	auipc	a2,0x3
ffffffffc02033b2:	00260613          	addi	a2,a2,2 # ffffffffc02063b0 <commands+0x848>
ffffffffc02033b6:	24600593          	li	a1,582
ffffffffc02033ba:	00003517          	auipc	a0,0x3
ffffffffc02033be:	4f650513          	addi	a0,a0,1270 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02033c2:	8ccfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_W);
ffffffffc02033c6:	00003697          	auipc	a3,0x3
ffffffffc02033ca:	7da68693          	addi	a3,a3,2010 # ffffffffc0206ba0 <default_pmm_manager+0x440>
ffffffffc02033ce:	00003617          	auipc	a2,0x3
ffffffffc02033d2:	fe260613          	addi	a2,a2,-30 # ffffffffc02063b0 <commands+0x848>
ffffffffc02033d6:	24500593          	li	a1,581
ffffffffc02033da:	00003517          	auipc	a0,0x3
ffffffffc02033de:	4d650513          	addi	a0,a0,1238 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02033e2:	8acfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_U);
ffffffffc02033e6:	00003697          	auipc	a3,0x3
ffffffffc02033ea:	7aa68693          	addi	a3,a3,1962 # ffffffffc0206b90 <default_pmm_manager+0x430>
ffffffffc02033ee:	00003617          	auipc	a2,0x3
ffffffffc02033f2:	fc260613          	addi	a2,a2,-62 # ffffffffc02063b0 <commands+0x848>
ffffffffc02033f6:	24400593          	li	a1,580
ffffffffc02033fa:	00003517          	auipc	a0,0x3
ffffffffc02033fe:	4b650513          	addi	a0,a0,1206 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203402:	88cfd0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("DTB memory info not available");
ffffffffc0203406:	00003617          	auipc	a2,0x3
ffffffffc020340a:	52a60613          	addi	a2,a2,1322 # ffffffffc0206930 <default_pmm_manager+0x1d0>
ffffffffc020340e:	06500593          	li	a1,101
ffffffffc0203412:	00003517          	auipc	a0,0x3
ffffffffc0203416:	49e50513          	addi	a0,a0,1182 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020341a:	874fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc020341e:	00004697          	auipc	a3,0x4
ffffffffc0203422:	88a68693          	addi	a3,a3,-1910 # ffffffffc0206ca8 <default_pmm_manager+0x548>
ffffffffc0203426:	00003617          	auipc	a2,0x3
ffffffffc020342a:	f8a60613          	addi	a2,a2,-118 # ffffffffc02063b0 <commands+0x848>
ffffffffc020342e:	28a00593          	li	a1,650
ffffffffc0203432:	00003517          	auipc	a0,0x3
ffffffffc0203436:	47e50513          	addi	a0,a0,1150 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020343a:	854fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020343e:	00003697          	auipc	a3,0x3
ffffffffc0203442:	71a68693          	addi	a3,a3,1818 # ffffffffc0206b58 <default_pmm_manager+0x3f8>
ffffffffc0203446:	00003617          	auipc	a2,0x3
ffffffffc020344a:	f6a60613          	addi	a2,a2,-150 # ffffffffc02063b0 <commands+0x848>
ffffffffc020344e:	24300593          	li	a1,579
ffffffffc0203452:	00003517          	auipc	a0,0x3
ffffffffc0203456:	45e50513          	addi	a0,a0,1118 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020345a:	834fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020345e:	00003697          	auipc	a3,0x3
ffffffffc0203462:	6ba68693          	addi	a3,a3,1722 # ffffffffc0206b18 <default_pmm_manager+0x3b8>
ffffffffc0203466:	00003617          	auipc	a2,0x3
ffffffffc020346a:	f4a60613          	addi	a2,a2,-182 # ffffffffc02063b0 <commands+0x848>
ffffffffc020346e:	24200593          	li	a1,578
ffffffffc0203472:	00003517          	auipc	a0,0x3
ffffffffc0203476:	43e50513          	addi	a0,a0,1086 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020347a:	814fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020347e:	86d6                	mv	a3,s5
ffffffffc0203480:	00003617          	auipc	a2,0x3
ffffffffc0203484:	31860613          	addi	a2,a2,792 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc0203488:	23e00593          	li	a1,574
ffffffffc020348c:	00003517          	auipc	a0,0x3
ffffffffc0203490:	42450513          	addi	a0,a0,1060 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203494:	ffbfc0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203498:	00003617          	auipc	a2,0x3
ffffffffc020349c:	30060613          	addi	a2,a2,768 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc02034a0:	23d00593          	li	a1,573
ffffffffc02034a4:	00003517          	auipc	a0,0x3
ffffffffc02034a8:	40c50513          	addi	a0,a0,1036 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02034ac:	fe3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02034b0:	00003697          	auipc	a3,0x3
ffffffffc02034b4:	62068693          	addi	a3,a3,1568 # ffffffffc0206ad0 <default_pmm_manager+0x370>
ffffffffc02034b8:	00003617          	auipc	a2,0x3
ffffffffc02034bc:	ef860613          	addi	a2,a2,-264 # ffffffffc02063b0 <commands+0x848>
ffffffffc02034c0:	23b00593          	li	a1,571
ffffffffc02034c4:	00003517          	auipc	a0,0x3
ffffffffc02034c8:	3ec50513          	addi	a0,a0,1004 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02034cc:	fc3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02034d0:	00003697          	auipc	a3,0x3
ffffffffc02034d4:	5e868693          	addi	a3,a3,1512 # ffffffffc0206ab8 <default_pmm_manager+0x358>
ffffffffc02034d8:	00003617          	auipc	a2,0x3
ffffffffc02034dc:	ed860613          	addi	a2,a2,-296 # ffffffffc02063b0 <commands+0x848>
ffffffffc02034e0:	23a00593          	li	a1,570
ffffffffc02034e4:	00003517          	auipc	a0,0x3
ffffffffc02034e8:	3cc50513          	addi	a0,a0,972 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02034ec:	fa3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02034f0:	00004697          	auipc	a3,0x4
ffffffffc02034f4:	97868693          	addi	a3,a3,-1672 # ffffffffc0206e68 <default_pmm_manager+0x708>
ffffffffc02034f8:	00003617          	auipc	a2,0x3
ffffffffc02034fc:	eb860613          	addi	a2,a2,-328 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203500:	28100593          	li	a1,641
ffffffffc0203504:	00003517          	auipc	a0,0x3
ffffffffc0203508:	3ac50513          	addi	a0,a0,940 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020350c:	f83fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203510:	00004697          	auipc	a3,0x4
ffffffffc0203514:	92068693          	addi	a3,a3,-1760 # ffffffffc0206e30 <default_pmm_manager+0x6d0>
ffffffffc0203518:	00003617          	auipc	a2,0x3
ffffffffc020351c:	e9860613          	addi	a2,a2,-360 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203520:	27e00593          	li	a1,638
ffffffffc0203524:	00003517          	auipc	a0,0x3
ffffffffc0203528:	38c50513          	addi	a0,a0,908 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020352c:	f63fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203530:	00004697          	auipc	a3,0x4
ffffffffc0203534:	8d068693          	addi	a3,a3,-1840 # ffffffffc0206e00 <default_pmm_manager+0x6a0>
ffffffffc0203538:	00003617          	auipc	a2,0x3
ffffffffc020353c:	e7860613          	addi	a2,a2,-392 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203540:	27a00593          	li	a1,634
ffffffffc0203544:	00003517          	auipc	a0,0x3
ffffffffc0203548:	36c50513          	addi	a0,a0,876 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020354c:	f43fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203550:	00004697          	auipc	a3,0x4
ffffffffc0203554:	86868693          	addi	a3,a3,-1944 # ffffffffc0206db8 <default_pmm_manager+0x658>
ffffffffc0203558:	00003617          	auipc	a2,0x3
ffffffffc020355c:	e5860613          	addi	a2,a2,-424 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203560:	27900593          	li	a1,633
ffffffffc0203564:	00003517          	auipc	a0,0x3
ffffffffc0203568:	34c50513          	addi	a0,a0,844 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020356c:	f23fc0ef          	jal	ra,ffffffffc020048e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0203570:	00003617          	auipc	a2,0x3
ffffffffc0203574:	2d060613          	addi	a2,a2,720 # ffffffffc0206840 <default_pmm_manager+0xe0>
ffffffffc0203578:	0c900593          	li	a1,201
ffffffffc020357c:	00003517          	auipc	a0,0x3
ffffffffc0203580:	33450513          	addi	a0,a0,820 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc0203584:	f0bfc0ef          	jal	ra,ffffffffc020048e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203588:	00003617          	auipc	a2,0x3
ffffffffc020358c:	2b860613          	addi	a2,a2,696 # ffffffffc0206840 <default_pmm_manager+0xe0>
ffffffffc0203590:	08100593          	li	a1,129
ffffffffc0203594:	00003517          	auipc	a0,0x3
ffffffffc0203598:	31c50513          	addi	a0,a0,796 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020359c:	ef3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02035a0:	00003697          	auipc	a3,0x3
ffffffffc02035a4:	4e868693          	addi	a3,a3,1256 # ffffffffc0206a88 <default_pmm_manager+0x328>
ffffffffc02035a8:	00003617          	auipc	a2,0x3
ffffffffc02035ac:	e0860613          	addi	a2,a2,-504 # ffffffffc02063b0 <commands+0x848>
ffffffffc02035b0:	23900593          	li	a1,569
ffffffffc02035b4:	00003517          	auipc	a0,0x3
ffffffffc02035b8:	2fc50513          	addi	a0,a0,764 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02035bc:	ed3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02035c0:	00003697          	auipc	a3,0x3
ffffffffc02035c4:	49868693          	addi	a3,a3,1176 # ffffffffc0206a58 <default_pmm_manager+0x2f8>
ffffffffc02035c8:	00003617          	auipc	a2,0x3
ffffffffc02035cc:	de860613          	addi	a2,a2,-536 # ffffffffc02063b0 <commands+0x848>
ffffffffc02035d0:	23600593          	li	a1,566
ffffffffc02035d4:	00003517          	auipc	a0,0x3
ffffffffc02035d8:	2dc50513          	addi	a0,a0,732 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc02035dc:	eb3fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02035e0 <pgdir_alloc_page>:
{
ffffffffc02035e0:	7179                	addi	sp,sp,-48
ffffffffc02035e2:	ec26                	sd	s1,24(sp)
ffffffffc02035e4:	e84a                	sd	s2,16(sp)
ffffffffc02035e6:	e052                	sd	s4,0(sp)
ffffffffc02035e8:	f406                	sd	ra,40(sp)
ffffffffc02035ea:	f022                	sd	s0,32(sp)
ffffffffc02035ec:	e44e                	sd	s3,8(sp)
ffffffffc02035ee:	8a2a                	mv	s4,a0
ffffffffc02035f0:	84ae                	mv	s1,a1
ffffffffc02035f2:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02035f4:	100027f3          	csrr	a5,sstatus
ffffffffc02035f8:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc02035fa:	000db997          	auipc	s3,0xdb
ffffffffc02035fe:	51698993          	addi	s3,s3,1302 # ffffffffc02deb10 <pmm_manager>
ffffffffc0203602:	ef8d                	bnez	a5,ffffffffc020363c <pgdir_alloc_page+0x5c>
ffffffffc0203604:	0009b783          	ld	a5,0(s3)
ffffffffc0203608:	4505                	li	a0,1
ffffffffc020360a:	6f9c                	ld	a5,24(a5)
ffffffffc020360c:	9782                	jalr	a5
ffffffffc020360e:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203610:	cc09                	beqz	s0,ffffffffc020362a <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203612:	86ca                	mv	a3,s2
ffffffffc0203614:	8626                	mv	a2,s1
ffffffffc0203616:	85a2                	mv	a1,s0
ffffffffc0203618:	8552                	mv	a0,s4
ffffffffc020361a:	a90ff0ef          	jal	ra,ffffffffc02028aa <page_insert>
ffffffffc020361e:	e915                	bnez	a0,ffffffffc0203652 <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203620:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203622:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc0203624:	4785                	li	a5,1
ffffffffc0203626:	04f71e63          	bne	a4,a5,ffffffffc0203682 <pgdir_alloc_page+0xa2>
}
ffffffffc020362a:	70a2                	ld	ra,40(sp)
ffffffffc020362c:	8522                	mv	a0,s0
ffffffffc020362e:	7402                	ld	s0,32(sp)
ffffffffc0203630:	64e2                	ld	s1,24(sp)
ffffffffc0203632:	6942                	ld	s2,16(sp)
ffffffffc0203634:	69a2                	ld	s3,8(sp)
ffffffffc0203636:	6a02                	ld	s4,0(sp)
ffffffffc0203638:	6145                	addi	sp,sp,48
ffffffffc020363a:	8082                	ret
        intr_disable();
ffffffffc020363c:	b78fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203640:	0009b783          	ld	a5,0(s3)
ffffffffc0203644:	4505                	li	a0,1
ffffffffc0203646:	6f9c                	ld	a5,24(a5)
ffffffffc0203648:	9782                	jalr	a5
ffffffffc020364a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020364c:	b62fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203650:	b7c1                	j	ffffffffc0203610 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203652:	100027f3          	csrr	a5,sstatus
ffffffffc0203656:	8b89                	andi	a5,a5,2
ffffffffc0203658:	eb89                	bnez	a5,ffffffffc020366a <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc020365a:	0009b783          	ld	a5,0(s3)
ffffffffc020365e:	8522                	mv	a0,s0
ffffffffc0203660:	4585                	li	a1,1
ffffffffc0203662:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203664:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203666:	9782                	jalr	a5
    if (flag)
ffffffffc0203668:	b7c9                	j	ffffffffc020362a <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc020366a:	b4afd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020366e:	0009b783          	ld	a5,0(s3)
ffffffffc0203672:	8522                	mv	a0,s0
ffffffffc0203674:	4585                	li	a1,1
ffffffffc0203676:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203678:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc020367a:	9782                	jalr	a5
        intr_enable();
ffffffffc020367c:	b32fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203680:	b76d                	j	ffffffffc020362a <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc0203682:	00004697          	auipc	a3,0x4
ffffffffc0203686:	82e68693          	addi	a3,a3,-2002 # ffffffffc0206eb0 <default_pmm_manager+0x750>
ffffffffc020368a:	00003617          	auipc	a2,0x3
ffffffffc020368e:	d2660613          	addi	a2,a2,-730 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203692:	21700593          	li	a1,535
ffffffffc0203696:	00003517          	auipc	a0,0x3
ffffffffc020369a:	21a50513          	addi	a0,a0,538 # ffffffffc02068b0 <default_pmm_manager+0x150>
ffffffffc020369e:	df1fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02036a2 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02036a2:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02036a4:	00004697          	auipc	a3,0x4
ffffffffc02036a8:	82468693          	addi	a3,a3,-2012 # ffffffffc0206ec8 <default_pmm_manager+0x768>
ffffffffc02036ac:	00003617          	auipc	a2,0x3
ffffffffc02036b0:	d0460613          	addi	a2,a2,-764 # ffffffffc02063b0 <commands+0x848>
ffffffffc02036b4:	0ec00593          	li	a1,236
ffffffffc02036b8:	00004517          	auipc	a0,0x4
ffffffffc02036bc:	83050513          	addi	a0,a0,-2000 # ffffffffc0206ee8 <default_pmm_manager+0x788>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02036c0:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02036c2:	dcdfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02036c6 <mm_create>:
{
ffffffffc02036c6:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036c8:	04000513          	li	a0,64
{
ffffffffc02036cc:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036ce:	e90fe0ef          	jal	ra,ffffffffc0201d5e <kmalloc>
    if (mm != NULL)
ffffffffc02036d2:	cd19                	beqz	a0,ffffffffc02036f0 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc02036d4:	e508                	sd	a0,8(a0)
ffffffffc02036d6:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02036d8:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02036dc:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02036e0:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02036e4:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02036e8:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02036ec:	02053c23          	sd	zero,56(a0)
}
ffffffffc02036f0:	60a2                	ld	ra,8(sp)
ffffffffc02036f2:	0141                	addi	sp,sp,16
ffffffffc02036f4:	8082                	ret

ffffffffc02036f6 <find_vma>:
{
ffffffffc02036f6:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc02036f8:	c505                	beqz	a0,ffffffffc0203720 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc02036fa:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02036fc:	c501                	beqz	a0,ffffffffc0203704 <find_vma+0xe>
ffffffffc02036fe:	651c                	ld	a5,8(a0)
ffffffffc0203700:	02f5f263          	bgeu	a1,a5,ffffffffc0203724 <find_vma+0x2e>
    return listelm->next;
ffffffffc0203704:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0203706:	00f68d63          	beq	a3,a5,ffffffffc0203720 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc020370a:	fe87b703          	ld	a4,-24(a5) # ffffffffc7ffffe8 <end+0x7d214a4>
ffffffffc020370e:	00e5e663          	bltu	a1,a4,ffffffffc020371a <find_vma+0x24>
ffffffffc0203712:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203716:	00e5ec63          	bltu	a1,a4,ffffffffc020372e <find_vma+0x38>
ffffffffc020371a:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc020371c:	fef697e3          	bne	a3,a5,ffffffffc020370a <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0203720:	4501                	li	a0,0
}
ffffffffc0203722:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203724:	691c                	ld	a5,16(a0)
ffffffffc0203726:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203704 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc020372a:	ea88                	sd	a0,16(a3)
ffffffffc020372c:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc020372e:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203732:	ea88                	sd	a0,16(a3)
ffffffffc0203734:	8082                	ret

ffffffffc0203736 <do_pgfault>:
{
ffffffffc0203736:	7179                	addi	sp,sp,-48
ffffffffc0203738:	e44e                	sd	s3,8(sp)
ffffffffc020373a:	89ae                	mv	s3,a1
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc020373c:	85b2                	mv	a1,a2
{
ffffffffc020373e:	f022                	sd	s0,32(sp)
ffffffffc0203740:	ec26                	sd	s1,24(sp)
ffffffffc0203742:	f406                	sd	ra,40(sp)
ffffffffc0203744:	e84a                	sd	s2,16(sp)
ffffffffc0203746:	e052                	sd	s4,0(sp)
ffffffffc0203748:	8432                	mv	s0,a2
ffffffffc020374a:	84aa                	mv	s1,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc020374c:	fabff0ef          	jal	ra,ffffffffc02036f6 <find_vma>
    pgfault_num++;
ffffffffc0203750:	000db797          	auipc	a5,0xdb
ffffffffc0203754:	3d07a783          	lw	a5,976(a5) # ffffffffc02deb20 <pgfault_num>
ffffffffc0203758:	2785                	addiw	a5,a5,1
ffffffffc020375a:	000db717          	auipc	a4,0xdb
ffffffffc020375e:	3cf72323          	sw	a5,966(a4) # ffffffffc02deb20 <pgfault_num>
    if (vma == NULL || vma->vm_start > addr)
ffffffffc0203762:	14050b63          	beqz	a0,ffffffffc02038b8 <do_pgfault+0x182>
ffffffffc0203766:	651c                	ld	a5,8(a0)
ffffffffc0203768:	14f46863          	bltu	s0,a5,ffffffffc02038b8 <do_pgfault+0x182>
    switch (error_code & 0x3)
ffffffffc020376c:	0039f793          	andi	a5,s3,3
ffffffffc0203770:	0e078b63          	beqz	a5,ffffffffc0203866 <do_pgfault+0x130>
ffffffffc0203774:	4705                	li	a4,1
ffffffffc0203776:	0ce78963          	beq	a5,a4,ffffffffc0203848 <do_pgfault+0x112>
        if (!(vma->vm_flags & VM_WRITE))
ffffffffc020377a:	4d1c                	lw	a5,24(a0)
        perm |= (PTE_R | PTE_W);
ffffffffc020377c:	4959                	li	s2,22
        if (!(vma->vm_flags & VM_WRITE))
ffffffffc020377e:	0027f713          	andi	a4,a5,2
ffffffffc0203782:	16070c63          	beqz	a4,ffffffffc02038fa <do_pgfault+0x1c4>
    if (vma->vm_flags & VM_EXEC)
ffffffffc0203786:	8b91                	andi	a5,a5,4
ffffffffc0203788:	c399                	beqz	a5,ffffffffc020378e <do_pgfault+0x58>
        perm |= PTE_X;
ffffffffc020378a:	00896913          	ori	s2,s2,8
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc020378e:	767d                	lui	a2,0xfffff
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL)
ffffffffc0203790:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0203792:	8c71                	and	s0,s0,a2
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL)
ffffffffc0203794:	85a2                	mv	a1,s0
ffffffffc0203796:	4605                	li	a2,1
ffffffffc0203798:	85dfe0ef          	jal	ra,ffffffffc0201ff4 <get_pte>
ffffffffc020379c:	8a2a                	mv	s4,a0
ffffffffc020379e:	16050663          	beqz	a0,ffffffffc020390a <do_pgfault+0x1d4>
    if (*ptep == 0)
ffffffffc02037a2:	611c                	ld	a5,0(a0)
ffffffffc02037a4:	c3e5                	beqz	a5,ffffffffc0203884 <do_pgfault+0x14e>
        if ((*ptep & PTE_COW) && (error_code & 0x2))
ffffffffc02037a6:	2007f793          	andi	a5,a5,512
ffffffffc02037aa:	12078063          	beqz	a5,ffffffffc02038ca <do_pgfault+0x194>
ffffffffc02037ae:	0029f993          	andi	s3,s3,2
ffffffffc02037b2:	10098c63          	beqz	s3,ffffffffc02038ca <do_pgfault+0x194>
            struct Page *page = alloc_page();
ffffffffc02037b6:	4505                	li	a0,1
ffffffffc02037b8:	f84fe0ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc02037bc:	89aa                	mv	s3,a0
            if (page == NULL)
ffffffffc02037be:	10050e63          	beqz	a0,ffffffffc02038da <do_pgfault+0x1a4>
            struct Page *old_page = pte2page(*ptep);
ffffffffc02037c2:	000a3683          	ld	a3,0(s4)
    if (!(pte & PTE_V))
ffffffffc02037c6:	0016f793          	andi	a5,a3,1
ffffffffc02037ca:	18078163          	beqz	a5,ffffffffc020394c <do_pgfault+0x216>
    return pa2page(PTE_ADDR(pte));
ffffffffc02037ce:	068a                	slli	a3,a3,0x2
ffffffffc02037d0:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc02037d2:	000db617          	auipc	a2,0xdb
ffffffffc02037d6:	32e63603          	ld	a2,814(a2) # ffffffffc02deb00 <npage>
ffffffffc02037da:	14c6fd63          	bgeu	a3,a2,ffffffffc0203934 <do_pgfault+0x1fe>
    return &pages[PPN(pa) - nbase];
ffffffffc02037de:	00004517          	auipc	a0,0x4
ffffffffc02037e2:	47a53503          	ld	a0,1146(a0) # ffffffffc0207c58 <nbase>
ffffffffc02037e6:	8e89                	sub	a3,a3,a0
ffffffffc02037e8:	069a                	slli	a3,a3,0x6
    return page - pages + nbase;
ffffffffc02037ea:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc02037ec:	577d                	li	a4,-1
    return page - pages + nbase;
ffffffffc02037ee:	96aa                	add	a3,a3,a0
    return KADDR(page2pa(page));
ffffffffc02037f0:	8331                	srli	a4,a4,0xc
ffffffffc02037f2:	00e6f5b3          	and	a1,a3,a4
    return &pages[PPN(pa) - nbase];
ffffffffc02037f6:	000db797          	auipc	a5,0xdb
ffffffffc02037fa:	3127b783          	ld	a5,786(a5) # ffffffffc02deb08 <pages>
    return page2ppn(page) << PGSHIFT;
ffffffffc02037fe:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203800:	10c5fe63          	bgeu	a1,a2,ffffffffc020391c <do_pgfault+0x1e6>
    return page - pages + nbase;
ffffffffc0203804:	40f987b3          	sub	a5,s3,a5
ffffffffc0203808:	8799                	srai	a5,a5,0x6
ffffffffc020380a:	97aa                	add	a5,a5,a0
    return KADDR(page2pa(page));
ffffffffc020380c:	8f7d                	and	a4,a4,a5
ffffffffc020380e:	000db517          	auipc	a0,0xdb
ffffffffc0203812:	30a53503          	ld	a0,778(a0) # ffffffffc02deb18 <va_pa_offset>
ffffffffc0203816:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc020381a:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc020381c:	0ec77f63          	bgeu	a4,a2,ffffffffc020391a <do_pgfault+0x1e4>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc0203820:	6605                	lui	a2,0x1
ffffffffc0203822:	953e                	add	a0,a0,a5
ffffffffc0203824:	0be020ef          	jal	ra,ffffffffc02058e2 <memcpy>
            if (page_insert(mm->pgdir, page, addr, new_perm) != 0)
ffffffffc0203828:	6c88                	ld	a0,24(s1)
ffffffffc020382a:	86ca                	mv	a3,s2
ffffffffc020382c:	8622                	mv	a2,s0
ffffffffc020382e:	85ce                	mv	a1,s3
ffffffffc0203830:	87aff0ef          	jal	ra,ffffffffc02028aa <page_insert>
ffffffffc0203834:	e535                	bnez	a0,ffffffffc02038a0 <do_pgfault+0x16a>
}
ffffffffc0203836:	70a2                	ld	ra,40(sp)
ffffffffc0203838:	7402                	ld	s0,32(sp)
ffffffffc020383a:	64e2                	ld	s1,24(sp)
ffffffffc020383c:	6942                	ld	s2,16(sp)
ffffffffc020383e:	69a2                	ld	s3,8(sp)
ffffffffc0203840:	6a02                	ld	s4,0(sp)
    ret = 0;
ffffffffc0203842:	4501                	li	a0,0
}
ffffffffc0203844:	6145                	addi	sp,sp,48
ffffffffc0203846:	8082                	ret
        cprintf("do_pgfault failed: error code flag = read AND present\n");
ffffffffc0203848:	00003517          	auipc	a0,0x3
ffffffffc020384c:	74050513          	addi	a0,a0,1856 # ffffffffc0206f88 <default_pmm_manager+0x828>
ffffffffc0203850:	945fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc0203854:	5575                	li	a0,-3
}
ffffffffc0203856:	70a2                	ld	ra,40(sp)
ffffffffc0203858:	7402                	ld	s0,32(sp)
ffffffffc020385a:	64e2                	ld	s1,24(sp)
ffffffffc020385c:	6942                	ld	s2,16(sp)
ffffffffc020385e:	69a2                	ld	s3,8(sp)
ffffffffc0203860:	6a02                	ld	s4,0(sp)
ffffffffc0203862:	6145                	addi	sp,sp,48
ffffffffc0203864:	8082                	ret
        if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
ffffffffc0203866:	4d1c                	lw	a5,24(a0)
ffffffffc0203868:	0057f713          	andi	a4,a5,5
ffffffffc020386c:	cf3d                	beqz	a4,ffffffffc02038ea <do_pgfault+0x1b4>
    if (vma->vm_flags & VM_READ)
ffffffffc020386e:	0017f713          	andi	a4,a5,1
        if (!(vma->vm_flags & VM_WRITE))
ffffffffc0203872:	0027f693          	andi	a3,a5,2
    uint32_t perm = PTE_U;
ffffffffc0203876:	4941                	li	s2,16
    if (vma->vm_flags & VM_READ)
ffffffffc0203878:	c311                	beqz	a4,ffffffffc020387c <do_pgfault+0x146>
        perm |= PTE_R;
ffffffffc020387a:	4949                	li	s2,18
    if (vma->vm_flags & VM_WRITE)
ffffffffc020387c:	f00685e3          	beqz	a3,ffffffffc0203786 <do_pgfault+0x50>
        perm |= (PTE_R | PTE_W);
ffffffffc0203880:	4959                	li	s2,22
ffffffffc0203882:	b711                	j	ffffffffc0203786 <do_pgfault+0x50>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL)
ffffffffc0203884:	6c88                	ld	a0,24(s1)
ffffffffc0203886:	864a                	mv	a2,s2
ffffffffc0203888:	85a2                	mv	a1,s0
ffffffffc020388a:	d57ff0ef          	jal	ra,ffffffffc02035e0 <pgdir_alloc_page>
ffffffffc020388e:	f545                	bnez	a0,ffffffffc0203836 <do_pgfault+0x100>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0203890:	00003517          	auipc	a0,0x3
ffffffffc0203894:	7b850513          	addi	a0,a0,1976 # ffffffffc0207048 <default_pmm_manager+0x8e8>
ffffffffc0203898:	8fdfc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc020389c:	5575                	li	a0,-3
            goto failed;
ffffffffc020389e:	bf65                	j	ffffffffc0203856 <do_pgfault+0x120>
                free_page(page);
ffffffffc02038a0:	4585                	li	a1,1
ffffffffc02038a2:	854e                	mv	a0,s3
ffffffffc02038a4:	ed6fe0ef          	jal	ra,ffffffffc0201f7a <free_pages>
                cprintf("do_pgfault failed: cannot insert page for COW\n");
ffffffffc02038a8:	00004517          	auipc	a0,0x4
ffffffffc02038ac:	80050513          	addi	a0,a0,-2048 # ffffffffc02070a8 <default_pmm_manager+0x948>
ffffffffc02038b0:	8e5fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc02038b4:	5575                	li	a0,-3
                goto failed;
ffffffffc02038b6:	b745                	j	ffffffffc0203856 <do_pgfault+0x120>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc02038b8:	85a2                	mv	a1,s0
ffffffffc02038ba:	00003517          	auipc	a0,0x3
ffffffffc02038be:	63e50513          	addi	a0,a0,1598 # ffffffffc0206ef8 <default_pmm_manager+0x798>
ffffffffc02038c2:	8d3fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc02038c6:	5575                	li	a0,-3
        goto failed;
ffffffffc02038c8:	b779                	j	ffffffffc0203856 <do_pgfault+0x120>
            cprintf("do_pgfault: page exists but permission denied\n");
ffffffffc02038ca:	00004517          	auipc	a0,0x4
ffffffffc02038ce:	80e50513          	addi	a0,a0,-2034 # ffffffffc02070d8 <default_pmm_manager+0x978>
ffffffffc02038d2:	8c3fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc02038d6:	5575                	li	a0,-3
            goto failed;
ffffffffc02038d8:	bfbd                	j	ffffffffc0203856 <do_pgfault+0x120>
                cprintf("do_pgfault failed: cannot allocate page for COW\n");
ffffffffc02038da:	00003517          	auipc	a0,0x3
ffffffffc02038de:	79650513          	addi	a0,a0,1942 # ffffffffc0207070 <default_pmm_manager+0x910>
ffffffffc02038e2:	8b3fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc02038e6:	5575                	li	a0,-3
                goto failed;
ffffffffc02038e8:	b7bd                	j	ffffffffc0203856 <do_pgfault+0x120>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
ffffffffc02038ea:	00003517          	auipc	a0,0x3
ffffffffc02038ee:	6d650513          	addi	a0,a0,1750 # ffffffffc0206fc0 <default_pmm_manager+0x860>
ffffffffc02038f2:	8a3fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc02038f6:	5575                	li	a0,-3
            goto failed;
ffffffffc02038f8:	bfb9                	j	ffffffffc0203856 <do_pgfault+0x120>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
ffffffffc02038fa:	00003517          	auipc	a0,0x3
ffffffffc02038fe:	62e50513          	addi	a0,a0,1582 # ffffffffc0206f28 <default_pmm_manager+0x7c8>
ffffffffc0203902:	893fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc0203906:	5575                	li	a0,-3
            goto failed;
ffffffffc0203908:	b7b9                	j	ffffffffc0203856 <do_pgfault+0x120>
        cprintf("get_pte in do_pgfault failed\n");
ffffffffc020390a:	00003517          	auipc	a0,0x3
ffffffffc020390e:	71e50513          	addi	a0,a0,1822 # ffffffffc0207028 <default_pmm_manager+0x8c8>
ffffffffc0203912:	883fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc0203916:	5575                	li	a0,-3
        goto failed;
ffffffffc0203918:	bf3d                	j	ffffffffc0203856 <do_pgfault+0x120>
ffffffffc020391a:	86be                	mv	a3,a5
ffffffffc020391c:	00003617          	auipc	a2,0x3
ffffffffc0203920:	e7c60613          	addi	a2,a2,-388 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc0203924:	07100593          	li	a1,113
ffffffffc0203928:	00003517          	auipc	a0,0x3
ffffffffc020392c:	e9850513          	addi	a0,a0,-360 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc0203930:	b5ffc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203934:	00003617          	auipc	a2,0x3
ffffffffc0203938:	f3460613          	addi	a2,a2,-204 # ffffffffc0206868 <default_pmm_manager+0x108>
ffffffffc020393c:	06900593          	li	a1,105
ffffffffc0203940:	00003517          	auipc	a0,0x3
ffffffffc0203944:	e8050513          	addi	a0,a0,-384 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc0203948:	b47fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc020394c:	00003617          	auipc	a2,0x3
ffffffffc0203950:	f3c60613          	addi	a2,a2,-196 # ffffffffc0206888 <default_pmm_manager+0x128>
ffffffffc0203954:	07f00593          	li	a1,127
ffffffffc0203958:	00003517          	auipc	a0,0x3
ffffffffc020395c:	e6850513          	addi	a0,a0,-408 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc0203960:	b2ffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203964 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203964:	6590                	ld	a2,8(a1)
ffffffffc0203966:	0105b803          	ld	a6,16(a1)
{
ffffffffc020396a:	1141                	addi	sp,sp,-16
ffffffffc020396c:	e406                	sd	ra,8(sp)
ffffffffc020396e:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203970:	01066763          	bltu	a2,a6,ffffffffc020397e <insert_vma_struct+0x1a>
ffffffffc0203974:	a085                	j	ffffffffc02039d4 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203976:	fe87b703          	ld	a4,-24(a5)
ffffffffc020397a:	04e66863          	bltu	a2,a4,ffffffffc02039ca <insert_vma_struct+0x66>
ffffffffc020397e:	86be                	mv	a3,a5
ffffffffc0203980:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0203982:	fef51ae3          	bne	a0,a5,ffffffffc0203976 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203986:	02a68463          	beq	a3,a0,ffffffffc02039ae <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc020398a:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc020398e:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203992:	08e8f163          	bgeu	a7,a4,ffffffffc0203a14 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203996:	04e66f63          	bltu	a2,a4,ffffffffc02039f4 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc020399a:	00f50a63          	beq	a0,a5,ffffffffc02039ae <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020399e:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc02039a2:	05076963          	bltu	a4,a6,ffffffffc02039f4 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc02039a6:	ff07b603          	ld	a2,-16(a5)
ffffffffc02039aa:	02c77363          	bgeu	a4,a2,ffffffffc02039d0 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc02039ae:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc02039b0:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02039b2:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc02039b6:	e390                	sd	a2,0(a5)
ffffffffc02039b8:	e690                	sd	a2,8(a3)
}
ffffffffc02039ba:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02039bc:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02039be:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc02039c0:	0017079b          	addiw	a5,a4,1
ffffffffc02039c4:	d11c                	sw	a5,32(a0)
}
ffffffffc02039c6:	0141                	addi	sp,sp,16
ffffffffc02039c8:	8082                	ret
    if (le_prev != list)
ffffffffc02039ca:	fca690e3          	bne	a3,a0,ffffffffc020398a <insert_vma_struct+0x26>
ffffffffc02039ce:	bfd1                	j	ffffffffc02039a2 <insert_vma_struct+0x3e>
ffffffffc02039d0:	cd3ff0ef          	jal	ra,ffffffffc02036a2 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02039d4:	00003697          	auipc	a3,0x3
ffffffffc02039d8:	73468693          	addi	a3,a3,1844 # ffffffffc0207108 <default_pmm_manager+0x9a8>
ffffffffc02039dc:	00003617          	auipc	a2,0x3
ffffffffc02039e0:	9d460613          	addi	a2,a2,-1580 # ffffffffc02063b0 <commands+0x848>
ffffffffc02039e4:	0f200593          	li	a1,242
ffffffffc02039e8:	00003517          	auipc	a0,0x3
ffffffffc02039ec:	50050513          	addi	a0,a0,1280 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc02039f0:	a9ffc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02039f4:	00003697          	auipc	a3,0x3
ffffffffc02039f8:	75468693          	addi	a3,a3,1876 # ffffffffc0207148 <default_pmm_manager+0x9e8>
ffffffffc02039fc:	00003617          	auipc	a2,0x3
ffffffffc0203a00:	9b460613          	addi	a2,a2,-1612 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203a04:	0eb00593          	li	a1,235
ffffffffc0203a08:	00003517          	auipc	a0,0x3
ffffffffc0203a0c:	4e050513          	addi	a0,a0,1248 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203a10:	a7ffc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203a14:	00003697          	auipc	a3,0x3
ffffffffc0203a18:	71468693          	addi	a3,a3,1812 # ffffffffc0207128 <default_pmm_manager+0x9c8>
ffffffffc0203a1c:	00003617          	auipc	a2,0x3
ffffffffc0203a20:	99460613          	addi	a2,a2,-1644 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203a24:	0ea00593          	li	a1,234
ffffffffc0203a28:	00003517          	auipc	a0,0x3
ffffffffc0203a2c:	4c050513          	addi	a0,a0,1216 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203a30:	a5ffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a34 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0203a34:	591c                	lw	a5,48(a0)
{
ffffffffc0203a36:	1141                	addi	sp,sp,-16
ffffffffc0203a38:	e406                	sd	ra,8(sp)
ffffffffc0203a3a:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203a3c:	e78d                	bnez	a5,ffffffffc0203a66 <mm_destroy+0x32>
ffffffffc0203a3e:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203a40:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0203a42:	00a40c63          	beq	s0,a0,ffffffffc0203a5a <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203a46:	6118                	ld	a4,0(a0)
ffffffffc0203a48:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203a4a:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203a4c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203a4e:	e398                	sd	a4,0(a5)
ffffffffc0203a50:	bbefe0ef          	jal	ra,ffffffffc0201e0e <kfree>
    return listelm->next;
ffffffffc0203a54:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203a56:	fea418e3          	bne	s0,a0,ffffffffc0203a46 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203a5a:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203a5c:	6402                	ld	s0,0(sp)
ffffffffc0203a5e:	60a2                	ld	ra,8(sp)
ffffffffc0203a60:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0203a62:	bacfe06f          	j	ffffffffc0201e0e <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203a66:	00003697          	auipc	a3,0x3
ffffffffc0203a6a:	70268693          	addi	a3,a3,1794 # ffffffffc0207168 <default_pmm_manager+0xa08>
ffffffffc0203a6e:	00003617          	auipc	a2,0x3
ffffffffc0203a72:	94260613          	addi	a2,a2,-1726 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203a76:	11600593          	li	a1,278
ffffffffc0203a7a:	00003517          	auipc	a0,0x3
ffffffffc0203a7e:	46e50513          	addi	a0,a0,1134 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203a82:	a0dfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a86 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc0203a86:	7139                	addi	sp,sp,-64
ffffffffc0203a88:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203a8a:	6405                	lui	s0,0x1
ffffffffc0203a8c:	147d                	addi	s0,s0,-1
ffffffffc0203a8e:	77fd                	lui	a5,0xfffff
ffffffffc0203a90:	9622                	add	a2,a2,s0
ffffffffc0203a92:	962e                	add	a2,a2,a1
{
ffffffffc0203a94:	f426                	sd	s1,40(sp)
ffffffffc0203a96:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203a98:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203a9c:	f04a                	sd	s2,32(sp)
ffffffffc0203a9e:	ec4e                	sd	s3,24(sp)
ffffffffc0203aa0:	e852                	sd	s4,16(sp)
ffffffffc0203aa2:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203aa4:	002005b7          	lui	a1,0x200
ffffffffc0203aa8:	00f67433          	and	s0,a2,a5
ffffffffc0203aac:	06b4e363          	bltu	s1,a1,ffffffffc0203b12 <mm_map+0x8c>
ffffffffc0203ab0:	0684f163          	bgeu	s1,s0,ffffffffc0203b12 <mm_map+0x8c>
ffffffffc0203ab4:	4785                	li	a5,1
ffffffffc0203ab6:	07fe                	slli	a5,a5,0x1f
ffffffffc0203ab8:	0487ed63          	bltu	a5,s0,ffffffffc0203b12 <mm_map+0x8c>
ffffffffc0203abc:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203abe:	cd21                	beqz	a0,ffffffffc0203b16 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203ac0:	85a6                	mv	a1,s1
ffffffffc0203ac2:	8ab6                	mv	s5,a3
ffffffffc0203ac4:	8a3a                	mv	s4,a4
ffffffffc0203ac6:	c31ff0ef          	jal	ra,ffffffffc02036f6 <find_vma>
ffffffffc0203aca:	c501                	beqz	a0,ffffffffc0203ad2 <mm_map+0x4c>
ffffffffc0203acc:	651c                	ld	a5,8(a0)
ffffffffc0203ace:	0487e263          	bltu	a5,s0,ffffffffc0203b12 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203ad2:	03000513          	li	a0,48
ffffffffc0203ad6:	a88fe0ef          	jal	ra,ffffffffc0201d5e <kmalloc>
ffffffffc0203ada:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203adc:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203ade:	02090163          	beqz	s2,ffffffffc0203b00 <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0203ae2:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc0203ae4:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc0203ae8:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc0203aec:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc0203af0:	85ca                	mv	a1,s2
ffffffffc0203af2:	e73ff0ef          	jal	ra,ffffffffc0203964 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc0203af6:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc0203af8:	000a0463          	beqz	s4,ffffffffc0203b00 <mm_map+0x7a>
        *vma_store = vma;
ffffffffc0203afc:	012a3023          	sd	s2,0(s4)

out:
    return ret;
}
ffffffffc0203b00:	70e2                	ld	ra,56(sp)
ffffffffc0203b02:	7442                	ld	s0,48(sp)
ffffffffc0203b04:	74a2                	ld	s1,40(sp)
ffffffffc0203b06:	7902                	ld	s2,32(sp)
ffffffffc0203b08:	69e2                	ld	s3,24(sp)
ffffffffc0203b0a:	6a42                	ld	s4,16(sp)
ffffffffc0203b0c:	6aa2                	ld	s5,8(sp)
ffffffffc0203b0e:	6121                	addi	sp,sp,64
ffffffffc0203b10:	8082                	ret
        return -E_INVAL;
ffffffffc0203b12:	5575                	li	a0,-3
ffffffffc0203b14:	b7f5                	j	ffffffffc0203b00 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc0203b16:	00003697          	auipc	a3,0x3
ffffffffc0203b1a:	66a68693          	addi	a3,a3,1642 # ffffffffc0207180 <default_pmm_manager+0xa20>
ffffffffc0203b1e:	00003617          	auipc	a2,0x3
ffffffffc0203b22:	89260613          	addi	a2,a2,-1902 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203b26:	12b00593          	li	a1,299
ffffffffc0203b2a:	00003517          	auipc	a0,0x3
ffffffffc0203b2e:	3be50513          	addi	a0,a0,958 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203b32:	95dfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203b36 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203b36:	7139                	addi	sp,sp,-64
ffffffffc0203b38:	fc06                	sd	ra,56(sp)
ffffffffc0203b3a:	f822                	sd	s0,48(sp)
ffffffffc0203b3c:	f426                	sd	s1,40(sp)
ffffffffc0203b3e:	f04a                	sd	s2,32(sp)
ffffffffc0203b40:	ec4e                	sd	s3,24(sp)
ffffffffc0203b42:	e852                	sd	s4,16(sp)
ffffffffc0203b44:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203b46:	c52d                	beqz	a0,ffffffffc0203bb0 <dup_mmap+0x7a>
ffffffffc0203b48:	892a                	mv	s2,a0
ffffffffc0203b4a:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203b4c:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203b4e:	e595                	bnez	a1,ffffffffc0203b7a <dup_mmap+0x44>
ffffffffc0203b50:	a085                	j	ffffffffc0203bb0 <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203b52:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0203b54:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_dirtycow_out_size+0x1f4ab8>
        vma->vm_end = vm_end;
ffffffffc0203b58:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203b5c:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0203b60:	e05ff0ef          	jal	ra,ffffffffc0203964 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203b64:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0203b68:	fe843603          	ld	a2,-24(s0)
ffffffffc0203b6c:	6c8c                	ld	a1,24(s1)
ffffffffc0203b6e:	01893503          	ld	a0,24(s2)
ffffffffc0203b72:	4701                	li	a4,0
ffffffffc0203b74:	ad5fe0ef          	jal	ra,ffffffffc0202648 <copy_range>
ffffffffc0203b78:	e105                	bnez	a0,ffffffffc0203b98 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203b7a:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203b7c:	02848863          	beq	s1,s0,ffffffffc0203bac <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b80:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203b84:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203b88:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203b8c:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b90:	9cefe0ef          	jal	ra,ffffffffc0201d5e <kmalloc>
ffffffffc0203b94:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203b96:	fd55                	bnez	a0,ffffffffc0203b52 <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203b98:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203b9a:	70e2                	ld	ra,56(sp)
ffffffffc0203b9c:	7442                	ld	s0,48(sp)
ffffffffc0203b9e:	74a2                	ld	s1,40(sp)
ffffffffc0203ba0:	7902                	ld	s2,32(sp)
ffffffffc0203ba2:	69e2                	ld	s3,24(sp)
ffffffffc0203ba4:	6a42                	ld	s4,16(sp)
ffffffffc0203ba6:	6aa2                	ld	s5,8(sp)
ffffffffc0203ba8:	6121                	addi	sp,sp,64
ffffffffc0203baa:	8082                	ret
    return 0;
ffffffffc0203bac:	4501                	li	a0,0
ffffffffc0203bae:	b7f5                	j	ffffffffc0203b9a <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0203bb0:	00003697          	auipc	a3,0x3
ffffffffc0203bb4:	5e068693          	addi	a3,a3,1504 # ffffffffc0207190 <default_pmm_manager+0xa30>
ffffffffc0203bb8:	00002617          	auipc	a2,0x2
ffffffffc0203bbc:	7f860613          	addi	a2,a2,2040 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203bc0:	14700593          	li	a1,327
ffffffffc0203bc4:	00003517          	auipc	a0,0x3
ffffffffc0203bc8:	32450513          	addi	a0,a0,804 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203bcc:	8c3fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203bd0 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203bd0:	1101                	addi	sp,sp,-32
ffffffffc0203bd2:	ec06                	sd	ra,24(sp)
ffffffffc0203bd4:	e822                	sd	s0,16(sp)
ffffffffc0203bd6:	e426                	sd	s1,8(sp)
ffffffffc0203bd8:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203bda:	c531                	beqz	a0,ffffffffc0203c26 <exit_mmap+0x56>
ffffffffc0203bdc:	591c                	lw	a5,48(a0)
ffffffffc0203bde:	84aa                	mv	s1,a0
ffffffffc0203be0:	e3b9                	bnez	a5,ffffffffc0203c26 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203be2:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203be4:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203be8:	02850663          	beq	a0,s0,ffffffffc0203c14 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203bec:	ff043603          	ld	a2,-16(s0)
ffffffffc0203bf0:	fe843583          	ld	a1,-24(s0)
ffffffffc0203bf4:	854a                	mv	a0,s2
ffffffffc0203bf6:	e7afe0ef          	jal	ra,ffffffffc0202270 <unmap_range>
ffffffffc0203bfa:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203bfc:	fe8498e3          	bne	s1,s0,ffffffffc0203bec <exit_mmap+0x1c>
ffffffffc0203c00:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203c02:	00848c63          	beq	s1,s0,ffffffffc0203c1a <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203c06:	ff043603          	ld	a2,-16(s0)
ffffffffc0203c0a:	fe843583          	ld	a1,-24(s0)
ffffffffc0203c0e:	854a                	mv	a0,s2
ffffffffc0203c10:	fa6fe0ef          	jal	ra,ffffffffc02023b6 <exit_range>
ffffffffc0203c14:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203c16:	fe8498e3          	bne	s1,s0,ffffffffc0203c06 <exit_mmap+0x36>
    }
}
ffffffffc0203c1a:	60e2                	ld	ra,24(sp)
ffffffffc0203c1c:	6442                	ld	s0,16(sp)
ffffffffc0203c1e:	64a2                	ld	s1,8(sp)
ffffffffc0203c20:	6902                	ld	s2,0(sp)
ffffffffc0203c22:	6105                	addi	sp,sp,32
ffffffffc0203c24:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203c26:	00003697          	auipc	a3,0x3
ffffffffc0203c2a:	58a68693          	addi	a3,a3,1418 # ffffffffc02071b0 <default_pmm_manager+0xa50>
ffffffffc0203c2e:	00002617          	auipc	a2,0x2
ffffffffc0203c32:	78260613          	addi	a2,a2,1922 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203c36:	16000593          	li	a1,352
ffffffffc0203c3a:	00003517          	auipc	a0,0x3
ffffffffc0203c3e:	2ae50513          	addi	a0,a0,686 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203c42:	84dfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203c46 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203c46:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203c48:	04000513          	li	a0,64
{
ffffffffc0203c4c:	fc06                	sd	ra,56(sp)
ffffffffc0203c4e:	f822                	sd	s0,48(sp)
ffffffffc0203c50:	f426                	sd	s1,40(sp)
ffffffffc0203c52:	f04a                	sd	s2,32(sp)
ffffffffc0203c54:	ec4e                	sd	s3,24(sp)
ffffffffc0203c56:	e852                	sd	s4,16(sp)
ffffffffc0203c58:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203c5a:	904fe0ef          	jal	ra,ffffffffc0201d5e <kmalloc>
    if (mm != NULL)
ffffffffc0203c5e:	2e050663          	beqz	a0,ffffffffc0203f4a <vmm_init+0x304>
ffffffffc0203c62:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203c64:	e508                	sd	a0,8(a0)
ffffffffc0203c66:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203c68:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203c6c:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203c70:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203c74:	02053423          	sd	zero,40(a0)
ffffffffc0203c78:	02052823          	sw	zero,48(a0)
ffffffffc0203c7c:	02053c23          	sd	zero,56(a0)
ffffffffc0203c80:	03200413          	li	s0,50
ffffffffc0203c84:	a811                	j	ffffffffc0203c98 <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203c86:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203c88:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203c8a:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203c8e:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203c90:	8526                	mv	a0,s1
ffffffffc0203c92:	cd3ff0ef          	jal	ra,ffffffffc0203964 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203c96:	c80d                	beqz	s0,ffffffffc0203cc8 <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203c98:	03000513          	li	a0,48
ffffffffc0203c9c:	8c2fe0ef          	jal	ra,ffffffffc0201d5e <kmalloc>
ffffffffc0203ca0:	85aa                	mv	a1,a0
ffffffffc0203ca2:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203ca6:	f165                	bnez	a0,ffffffffc0203c86 <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203ca8:	00003697          	auipc	a3,0x3
ffffffffc0203cac:	6a068693          	addi	a3,a3,1696 # ffffffffc0207348 <default_pmm_manager+0xbe8>
ffffffffc0203cb0:	00002617          	auipc	a2,0x2
ffffffffc0203cb4:	70060613          	addi	a2,a2,1792 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203cb8:	1a400593          	li	a1,420
ffffffffc0203cbc:	00003517          	auipc	a0,0x3
ffffffffc0203cc0:	22c50513          	addi	a0,a0,556 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203cc4:	fcafc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203cc8:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203ccc:	1f900913          	li	s2,505
ffffffffc0203cd0:	a819                	j	ffffffffc0203ce6 <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203cd2:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203cd4:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203cd6:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203cda:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203cdc:	8526                	mv	a0,s1
ffffffffc0203cde:	c87ff0ef          	jal	ra,ffffffffc0203964 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203ce2:	03240a63          	beq	s0,s2,ffffffffc0203d16 <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203ce6:	03000513          	li	a0,48
ffffffffc0203cea:	874fe0ef          	jal	ra,ffffffffc0201d5e <kmalloc>
ffffffffc0203cee:	85aa                	mv	a1,a0
ffffffffc0203cf0:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203cf4:	fd79                	bnez	a0,ffffffffc0203cd2 <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203cf6:	00003697          	auipc	a3,0x3
ffffffffc0203cfa:	65268693          	addi	a3,a3,1618 # ffffffffc0207348 <default_pmm_manager+0xbe8>
ffffffffc0203cfe:	00002617          	auipc	a2,0x2
ffffffffc0203d02:	6b260613          	addi	a2,a2,1714 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203d06:	1ab00593          	li	a1,427
ffffffffc0203d0a:	00003517          	auipc	a0,0x3
ffffffffc0203d0e:	1de50513          	addi	a0,a0,478 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203d12:	f7cfc0ef          	jal	ra,ffffffffc020048e <__panic>
    return listelm->next;
ffffffffc0203d16:	649c                	ld	a5,8(s1)
ffffffffc0203d18:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203d1a:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203d1e:	16f48663          	beq	s1,a5,ffffffffc0203e8a <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203d22:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd204a4>
ffffffffc0203d26:	ffe70693          	addi	a3,a4,-2
ffffffffc0203d2a:	10d61063          	bne	a2,a3,ffffffffc0203e2a <vmm_init+0x1e4>
ffffffffc0203d2e:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203d32:	0ed71c63          	bne	a4,a3,ffffffffc0203e2a <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203d36:	0715                	addi	a4,a4,5
ffffffffc0203d38:	679c                	ld	a5,8(a5)
ffffffffc0203d3a:	feb712e3          	bne	a4,a1,ffffffffc0203d1e <vmm_init+0xd8>
ffffffffc0203d3e:	4a1d                	li	s4,7
ffffffffc0203d40:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203d42:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203d46:	85a2                	mv	a1,s0
ffffffffc0203d48:	8526                	mv	a0,s1
ffffffffc0203d4a:	9adff0ef          	jal	ra,ffffffffc02036f6 <find_vma>
ffffffffc0203d4e:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203d50:	16050d63          	beqz	a0,ffffffffc0203eca <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203d54:	00140593          	addi	a1,s0,1
ffffffffc0203d58:	8526                	mv	a0,s1
ffffffffc0203d5a:	99dff0ef          	jal	ra,ffffffffc02036f6 <find_vma>
ffffffffc0203d5e:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203d60:	14050563          	beqz	a0,ffffffffc0203eaa <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203d64:	85d2                	mv	a1,s4
ffffffffc0203d66:	8526                	mv	a0,s1
ffffffffc0203d68:	98fff0ef          	jal	ra,ffffffffc02036f6 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203d6c:	16051f63          	bnez	a0,ffffffffc0203eea <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203d70:	00340593          	addi	a1,s0,3
ffffffffc0203d74:	8526                	mv	a0,s1
ffffffffc0203d76:	981ff0ef          	jal	ra,ffffffffc02036f6 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203d7a:	1a051863          	bnez	a0,ffffffffc0203f2a <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203d7e:	00440593          	addi	a1,s0,4
ffffffffc0203d82:	8526                	mv	a0,s1
ffffffffc0203d84:	973ff0ef          	jal	ra,ffffffffc02036f6 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203d88:	18051163          	bnez	a0,ffffffffc0203f0a <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203d8c:	00893783          	ld	a5,8(s2)
ffffffffc0203d90:	0a879d63          	bne	a5,s0,ffffffffc0203e4a <vmm_init+0x204>
ffffffffc0203d94:	01093783          	ld	a5,16(s2)
ffffffffc0203d98:	0b479963          	bne	a5,s4,ffffffffc0203e4a <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203d9c:	0089b783          	ld	a5,8(s3)
ffffffffc0203da0:	0c879563          	bne	a5,s0,ffffffffc0203e6a <vmm_init+0x224>
ffffffffc0203da4:	0109b783          	ld	a5,16(s3)
ffffffffc0203da8:	0d479163          	bne	a5,s4,ffffffffc0203e6a <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203dac:	0415                	addi	s0,s0,5
ffffffffc0203dae:	0a15                	addi	s4,s4,5
ffffffffc0203db0:	f9541be3          	bne	s0,s5,ffffffffc0203d46 <vmm_init+0x100>
ffffffffc0203db4:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203db6:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203db8:	85a2                	mv	a1,s0
ffffffffc0203dba:	8526                	mv	a0,s1
ffffffffc0203dbc:	93bff0ef          	jal	ra,ffffffffc02036f6 <find_vma>
ffffffffc0203dc0:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203dc4:	c90d                	beqz	a0,ffffffffc0203df6 <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203dc6:	6914                	ld	a3,16(a0)
ffffffffc0203dc8:	6510                	ld	a2,8(a0)
ffffffffc0203dca:	00003517          	auipc	a0,0x3
ffffffffc0203dce:	50650513          	addi	a0,a0,1286 # ffffffffc02072d0 <default_pmm_manager+0xb70>
ffffffffc0203dd2:	bc2fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203dd6:	00003697          	auipc	a3,0x3
ffffffffc0203dda:	52268693          	addi	a3,a3,1314 # ffffffffc02072f8 <default_pmm_manager+0xb98>
ffffffffc0203dde:	00002617          	auipc	a2,0x2
ffffffffc0203de2:	5d260613          	addi	a2,a2,1490 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203de6:	1d100593          	li	a1,465
ffffffffc0203dea:	00003517          	auipc	a0,0x3
ffffffffc0203dee:	0fe50513          	addi	a0,a0,254 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203df2:	e9cfc0ef          	jal	ra,ffffffffc020048e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203df6:	147d                	addi	s0,s0,-1
ffffffffc0203df8:	fd2410e3          	bne	s0,s2,ffffffffc0203db8 <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203dfc:	8526                	mv	a0,s1
ffffffffc0203dfe:	c37ff0ef          	jal	ra,ffffffffc0203a34 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203e02:	00003517          	auipc	a0,0x3
ffffffffc0203e06:	50e50513          	addi	a0,a0,1294 # ffffffffc0207310 <default_pmm_manager+0xbb0>
ffffffffc0203e0a:	b8afc0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0203e0e:	7442                	ld	s0,48(sp)
ffffffffc0203e10:	70e2                	ld	ra,56(sp)
ffffffffc0203e12:	74a2                	ld	s1,40(sp)
ffffffffc0203e14:	7902                	ld	s2,32(sp)
ffffffffc0203e16:	69e2                	ld	s3,24(sp)
ffffffffc0203e18:	6a42                	ld	s4,16(sp)
ffffffffc0203e1a:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203e1c:	00003517          	auipc	a0,0x3
ffffffffc0203e20:	51450513          	addi	a0,a0,1300 # ffffffffc0207330 <default_pmm_manager+0xbd0>
}
ffffffffc0203e24:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203e26:	b6efc06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203e2a:	00003697          	auipc	a3,0x3
ffffffffc0203e2e:	3be68693          	addi	a3,a3,958 # ffffffffc02071e8 <default_pmm_manager+0xa88>
ffffffffc0203e32:	00002617          	auipc	a2,0x2
ffffffffc0203e36:	57e60613          	addi	a2,a2,1406 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203e3a:	1b500593          	li	a1,437
ffffffffc0203e3e:	00003517          	auipc	a0,0x3
ffffffffc0203e42:	0aa50513          	addi	a0,a0,170 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203e46:	e48fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203e4a:	00003697          	auipc	a3,0x3
ffffffffc0203e4e:	42668693          	addi	a3,a3,1062 # ffffffffc0207270 <default_pmm_manager+0xb10>
ffffffffc0203e52:	00002617          	auipc	a2,0x2
ffffffffc0203e56:	55e60613          	addi	a2,a2,1374 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203e5a:	1c600593          	li	a1,454
ffffffffc0203e5e:	00003517          	auipc	a0,0x3
ffffffffc0203e62:	08a50513          	addi	a0,a0,138 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203e66:	e28fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203e6a:	00003697          	auipc	a3,0x3
ffffffffc0203e6e:	43668693          	addi	a3,a3,1078 # ffffffffc02072a0 <default_pmm_manager+0xb40>
ffffffffc0203e72:	00002617          	auipc	a2,0x2
ffffffffc0203e76:	53e60613          	addi	a2,a2,1342 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203e7a:	1c700593          	li	a1,455
ffffffffc0203e7e:	00003517          	auipc	a0,0x3
ffffffffc0203e82:	06a50513          	addi	a0,a0,106 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203e86:	e08fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203e8a:	00003697          	auipc	a3,0x3
ffffffffc0203e8e:	34668693          	addi	a3,a3,838 # ffffffffc02071d0 <default_pmm_manager+0xa70>
ffffffffc0203e92:	00002617          	auipc	a2,0x2
ffffffffc0203e96:	51e60613          	addi	a2,a2,1310 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203e9a:	1b300593          	li	a1,435
ffffffffc0203e9e:	00003517          	auipc	a0,0x3
ffffffffc0203ea2:	04a50513          	addi	a0,a0,74 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203ea6:	de8fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2 != NULL);
ffffffffc0203eaa:	00003697          	auipc	a3,0x3
ffffffffc0203eae:	38668693          	addi	a3,a3,902 # ffffffffc0207230 <default_pmm_manager+0xad0>
ffffffffc0203eb2:	00002617          	auipc	a2,0x2
ffffffffc0203eb6:	4fe60613          	addi	a2,a2,1278 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203eba:	1be00593          	li	a1,446
ffffffffc0203ebe:	00003517          	auipc	a0,0x3
ffffffffc0203ec2:	02a50513          	addi	a0,a0,42 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203ec6:	dc8fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1 != NULL);
ffffffffc0203eca:	00003697          	auipc	a3,0x3
ffffffffc0203ece:	35668693          	addi	a3,a3,854 # ffffffffc0207220 <default_pmm_manager+0xac0>
ffffffffc0203ed2:	00002617          	auipc	a2,0x2
ffffffffc0203ed6:	4de60613          	addi	a2,a2,1246 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203eda:	1bc00593          	li	a1,444
ffffffffc0203ede:	00003517          	auipc	a0,0x3
ffffffffc0203ee2:	00a50513          	addi	a0,a0,10 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203ee6:	da8fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma3 == NULL);
ffffffffc0203eea:	00003697          	auipc	a3,0x3
ffffffffc0203eee:	35668693          	addi	a3,a3,854 # ffffffffc0207240 <default_pmm_manager+0xae0>
ffffffffc0203ef2:	00002617          	auipc	a2,0x2
ffffffffc0203ef6:	4be60613          	addi	a2,a2,1214 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203efa:	1c000593          	li	a1,448
ffffffffc0203efe:	00003517          	auipc	a0,0x3
ffffffffc0203f02:	fea50513          	addi	a0,a0,-22 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203f06:	d88fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma5 == NULL);
ffffffffc0203f0a:	00003697          	auipc	a3,0x3
ffffffffc0203f0e:	35668693          	addi	a3,a3,854 # ffffffffc0207260 <default_pmm_manager+0xb00>
ffffffffc0203f12:	00002617          	auipc	a2,0x2
ffffffffc0203f16:	49e60613          	addi	a2,a2,1182 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203f1a:	1c400593          	li	a1,452
ffffffffc0203f1e:	00003517          	auipc	a0,0x3
ffffffffc0203f22:	fca50513          	addi	a0,a0,-54 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203f26:	d68fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma4 == NULL);
ffffffffc0203f2a:	00003697          	auipc	a3,0x3
ffffffffc0203f2e:	32668693          	addi	a3,a3,806 # ffffffffc0207250 <default_pmm_manager+0xaf0>
ffffffffc0203f32:	00002617          	auipc	a2,0x2
ffffffffc0203f36:	47e60613          	addi	a2,a2,1150 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203f3a:	1c200593          	li	a1,450
ffffffffc0203f3e:	00003517          	auipc	a0,0x3
ffffffffc0203f42:	faa50513          	addi	a0,a0,-86 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203f46:	d48fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(mm != NULL);
ffffffffc0203f4a:	00003697          	auipc	a3,0x3
ffffffffc0203f4e:	23668693          	addi	a3,a3,566 # ffffffffc0207180 <default_pmm_manager+0xa20>
ffffffffc0203f52:	00002617          	auipc	a2,0x2
ffffffffc0203f56:	45e60613          	addi	a2,a2,1118 # ffffffffc02063b0 <commands+0x848>
ffffffffc0203f5a:	19c00593          	li	a1,412
ffffffffc0203f5e:	00003517          	auipc	a0,0x3
ffffffffc0203f62:	f8a50513          	addi	a0,a0,-118 # ffffffffc0206ee8 <default_pmm_manager+0x788>
ffffffffc0203f66:	d28fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203f6a <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203f6a:	7179                	addi	sp,sp,-48
ffffffffc0203f6c:	f022                	sd	s0,32(sp)
ffffffffc0203f6e:	f406                	sd	ra,40(sp)
ffffffffc0203f70:	ec26                	sd	s1,24(sp)
ffffffffc0203f72:	e84a                	sd	s2,16(sp)
ffffffffc0203f74:	e44e                	sd	s3,8(sp)
ffffffffc0203f76:	e052                	sd	s4,0(sp)
ffffffffc0203f78:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203f7a:	c135                	beqz	a0,ffffffffc0203fde <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203f7c:	002007b7          	lui	a5,0x200
ffffffffc0203f80:	04f5e663          	bltu	a1,a5,ffffffffc0203fcc <user_mem_check+0x62>
ffffffffc0203f84:	00c584b3          	add	s1,a1,a2
ffffffffc0203f88:	0495f263          	bgeu	a1,s1,ffffffffc0203fcc <user_mem_check+0x62>
ffffffffc0203f8c:	4785                	li	a5,1
ffffffffc0203f8e:	07fe                	slli	a5,a5,0x1f
ffffffffc0203f90:	0297ee63          	bltu	a5,s1,ffffffffc0203fcc <user_mem_check+0x62>
ffffffffc0203f94:	892a                	mv	s2,a0
ffffffffc0203f96:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203f98:	6a05                	lui	s4,0x1
ffffffffc0203f9a:	a821                	j	ffffffffc0203fb2 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203f9c:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203fa0:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203fa2:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203fa4:	c685                	beqz	a3,ffffffffc0203fcc <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203fa6:	c399                	beqz	a5,ffffffffc0203fac <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203fa8:	02e46263          	bltu	s0,a4,ffffffffc0203fcc <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203fac:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203fae:	04947663          	bgeu	s0,s1,ffffffffc0203ffa <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203fb2:	85a2                	mv	a1,s0
ffffffffc0203fb4:	854a                	mv	a0,s2
ffffffffc0203fb6:	f40ff0ef          	jal	ra,ffffffffc02036f6 <find_vma>
ffffffffc0203fba:	c909                	beqz	a0,ffffffffc0203fcc <user_mem_check+0x62>
ffffffffc0203fbc:	6518                	ld	a4,8(a0)
ffffffffc0203fbe:	00e46763          	bltu	s0,a4,ffffffffc0203fcc <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203fc2:	4d1c                	lw	a5,24(a0)
ffffffffc0203fc4:	fc099ce3          	bnez	s3,ffffffffc0203f9c <user_mem_check+0x32>
ffffffffc0203fc8:	8b85                	andi	a5,a5,1
ffffffffc0203fca:	f3ed                	bnez	a5,ffffffffc0203fac <user_mem_check+0x42>
            return 0;
ffffffffc0203fcc:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203fce:	70a2                	ld	ra,40(sp)
ffffffffc0203fd0:	7402                	ld	s0,32(sp)
ffffffffc0203fd2:	64e2                	ld	s1,24(sp)
ffffffffc0203fd4:	6942                	ld	s2,16(sp)
ffffffffc0203fd6:	69a2                	ld	s3,8(sp)
ffffffffc0203fd8:	6a02                	ld	s4,0(sp)
ffffffffc0203fda:	6145                	addi	sp,sp,48
ffffffffc0203fdc:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203fde:	c02007b7          	lui	a5,0xc0200
ffffffffc0203fe2:	4501                	li	a0,0
ffffffffc0203fe4:	fef5e5e3          	bltu	a1,a5,ffffffffc0203fce <user_mem_check+0x64>
ffffffffc0203fe8:	962e                	add	a2,a2,a1
ffffffffc0203fea:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203fce <user_mem_check+0x64>
ffffffffc0203fee:	c8000537          	lui	a0,0xc8000
ffffffffc0203ff2:	0505                	addi	a0,a0,1
ffffffffc0203ff4:	00a63533          	sltu	a0,a2,a0
ffffffffc0203ff8:	bfd9                	j	ffffffffc0203fce <user_mem_check+0x64>
        return 1;
ffffffffc0203ffa:	4505                	li	a0,1
ffffffffc0203ffc:	bfc9                	j	ffffffffc0203fce <user_mem_check+0x64>

ffffffffc0203ffe <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203ffe:	8526                	mv	a0,s1
	jalr s0
ffffffffc0204000:	9402                	jalr	s0

	jal do_exit
ffffffffc0204002:	612000ef          	jal	ra,ffffffffc0204614 <do_exit>

ffffffffc0204006 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0204006:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204008:	10800513          	li	a0,264
{
ffffffffc020400c:	e022                	sd	s0,0(sp)
ffffffffc020400e:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204010:	d4ffd0ef          	jal	ra,ffffffffc0201d5e <kmalloc>
ffffffffc0204014:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0204016:	cd21                	beqz	a0,ffffffffc020406e <alloc_proc+0x68>
        /*
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        proc->state = PROC_UNINIT;
ffffffffc0204018:	57fd                	li	a5,-1
ffffffffc020401a:	1782                	slli	a5,a5,0x20
ffffffffc020401c:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc020401e:	07000613          	li	a2,112
ffffffffc0204022:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0204024:	00052423          	sw	zero,8(a0) # ffffffffc8000008 <end+0x7d214c4>
        proc->kstack = 0;
ffffffffc0204028:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc020402c:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0204030:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0204034:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0204038:	03050513          	addi	a0,a0,48
ffffffffc020403c:	095010ef          	jal	ra,ffffffffc02058d0 <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0204040:	000db797          	auipc	a5,0xdb
ffffffffc0204044:	ab07b783          	ld	a5,-1360(a5) # ffffffffc02deaf0 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc0204048:	0a043023          	sd	zero,160(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc020404c:	f45c                	sd	a5,168(s0)
        proc->flags = 0;
ffffffffc020404e:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN);
ffffffffc0204052:	463d                	li	a2,15
ffffffffc0204054:	4581                	li	a1,0
ffffffffc0204056:	0b440513          	addi	a0,s0,180
ffffffffc020405a:	077010ef          	jal	ra,ffffffffc02058d0 <memset>
        // LAB5 新增
        proc->wait_state = 0;
ffffffffc020405e:	0e042623          	sw	zero,236(s0)
        proc->cptr = NULL;
ffffffffc0204062:	0e043823          	sd	zero,240(s0)
        proc->yptr = NULL;
ffffffffc0204066:	0e043c23          	sd	zero,248(s0)
        proc->optr = NULL;
ffffffffc020406a:	10043023          	sd	zero,256(s0)
    }
    return proc;
}
ffffffffc020406e:	60a2                	ld	ra,8(sp)
ffffffffc0204070:	8522                	mv	a0,s0
ffffffffc0204072:	6402                	ld	s0,0(sp)
ffffffffc0204074:	0141                	addi	sp,sp,16
ffffffffc0204076:	8082                	ret

ffffffffc0204078 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0204078:	000db797          	auipc	a5,0xdb
ffffffffc020407c:	ab07b783          	ld	a5,-1360(a5) # ffffffffc02deb28 <current>
ffffffffc0204080:	73c8                	ld	a0,160(a5)
ffffffffc0204082:	f51fc06f          	j	ffffffffc0200fd2 <forkrets>

ffffffffc0204086 <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204086:	000db797          	auipc	a5,0xdb
ffffffffc020408a:	aa27b783          	ld	a5,-1374(a5) # ffffffffc02deb28 <current>
ffffffffc020408e:	43cc                	lw	a1,4(a5)
{
ffffffffc0204090:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204092:	00003617          	auipc	a2,0x3
ffffffffc0204096:	2c660613          	addi	a2,a2,710 # ffffffffc0207358 <default_pmm_manager+0xbf8>
ffffffffc020409a:	00003517          	auipc	a0,0x3
ffffffffc020409e:	2ce50513          	addi	a0,a0,718 # ffffffffc0207368 <default_pmm_manager+0xc08>
{
ffffffffc02040a2:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc02040a4:	8f0fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02040a8:	3fe07797          	auipc	a5,0x3fe07
ffffffffc02040ac:	8b878793          	addi	a5,a5,-1864 # a960 <_binary_obj___user_forktest_out_size>
ffffffffc02040b0:	e43e                	sd	a5,8(sp)
ffffffffc02040b2:	00003517          	auipc	a0,0x3
ffffffffc02040b6:	2a650513          	addi	a0,a0,678 # ffffffffc0207358 <default_pmm_manager+0xbf8>
ffffffffc02040ba:	0007a797          	auipc	a5,0x7a
ffffffffc02040be:	a6678793          	addi	a5,a5,-1434 # ffffffffc027db20 <_binary_obj___user_forktest_out_start>
ffffffffc02040c2:	f03e                	sd	a5,32(sp)
ffffffffc02040c4:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc02040c6:	e802                	sd	zero,16(sp)
ffffffffc02040c8:	766010ef          	jal	ra,ffffffffc020582e <strlen>
ffffffffc02040cc:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc02040ce:	4511                	li	a0,4
ffffffffc02040d0:	55a2                	lw	a1,40(sp)
ffffffffc02040d2:	4662                	lw	a2,24(sp)
ffffffffc02040d4:	5682                	lw	a3,32(sp)
ffffffffc02040d6:	4722                	lw	a4,8(sp)
ffffffffc02040d8:	48a9                	li	a7,10
ffffffffc02040da:	9002                	ebreak
ffffffffc02040dc:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc02040de:	65c2                	ld	a1,16(sp)
ffffffffc02040e0:	00003517          	auipc	a0,0x3
ffffffffc02040e4:	2b050513          	addi	a0,a0,688 # ffffffffc0207390 <default_pmm_manager+0xc30>
ffffffffc02040e8:	8acfc0ef          	jal	ra,ffffffffc0200194 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc02040ec:	00003617          	auipc	a2,0x3
ffffffffc02040f0:	2b460613          	addi	a2,a2,692 # ffffffffc02073a0 <default_pmm_manager+0xc40>
ffffffffc02040f4:	3c100593          	li	a1,961
ffffffffc02040f8:	00003517          	auipc	a0,0x3
ffffffffc02040fc:	2c850513          	addi	a0,a0,712 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204100:	b8efc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204104 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0204104:	6d14                	ld	a3,24(a0)
{
ffffffffc0204106:	1141                	addi	sp,sp,-16
ffffffffc0204108:	e406                	sd	ra,8(sp)
ffffffffc020410a:	c02007b7          	lui	a5,0xc0200
ffffffffc020410e:	02f6ee63          	bltu	a3,a5,ffffffffc020414a <put_pgdir+0x46>
ffffffffc0204112:	000db517          	auipc	a0,0xdb
ffffffffc0204116:	a0653503          	ld	a0,-1530(a0) # ffffffffc02deb18 <va_pa_offset>
ffffffffc020411a:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc020411c:	82b1                	srli	a3,a3,0xc
ffffffffc020411e:	000db797          	auipc	a5,0xdb
ffffffffc0204122:	9e27b783          	ld	a5,-1566(a5) # ffffffffc02deb00 <npage>
ffffffffc0204126:	02f6fe63          	bgeu	a3,a5,ffffffffc0204162 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc020412a:	00004517          	auipc	a0,0x4
ffffffffc020412e:	b2e53503          	ld	a0,-1234(a0) # ffffffffc0207c58 <nbase>
}
ffffffffc0204132:	60a2                	ld	ra,8(sp)
ffffffffc0204134:	8e89                	sub	a3,a3,a0
ffffffffc0204136:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0204138:	000db517          	auipc	a0,0xdb
ffffffffc020413c:	9d053503          	ld	a0,-1584(a0) # ffffffffc02deb08 <pages>
ffffffffc0204140:	4585                	li	a1,1
ffffffffc0204142:	9536                	add	a0,a0,a3
}
ffffffffc0204144:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0204146:	e35fd06f          	j	ffffffffc0201f7a <free_pages>
    return pa2page(PADDR(kva));
ffffffffc020414a:	00002617          	auipc	a2,0x2
ffffffffc020414e:	6f660613          	addi	a2,a2,1782 # ffffffffc0206840 <default_pmm_manager+0xe0>
ffffffffc0204152:	07700593          	li	a1,119
ffffffffc0204156:	00002517          	auipc	a0,0x2
ffffffffc020415a:	66a50513          	addi	a0,a0,1642 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc020415e:	b30fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204162:	00002617          	auipc	a2,0x2
ffffffffc0204166:	70660613          	addi	a2,a2,1798 # ffffffffc0206868 <default_pmm_manager+0x108>
ffffffffc020416a:	06900593          	li	a1,105
ffffffffc020416e:	00002517          	auipc	a0,0x2
ffffffffc0204172:	65250513          	addi	a0,a0,1618 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc0204176:	b18fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020417a <proc_run>:
{
ffffffffc020417a:	7179                	addi	sp,sp,-48
ffffffffc020417c:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc020417e:	000db917          	auipc	s2,0xdb
ffffffffc0204182:	9aa90913          	addi	s2,s2,-1622 # ffffffffc02deb28 <current>
{
ffffffffc0204186:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0204188:	00093483          	ld	s1,0(s2)
{
ffffffffc020418c:	f406                	sd	ra,40(sp)
ffffffffc020418e:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0204190:	02a48863          	beq	s1,a0,ffffffffc02041c0 <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204194:	100027f3          	csrr	a5,sstatus
ffffffffc0204198:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020419a:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020419c:	ef9d                	bnez	a5,ffffffffc02041da <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc020419e:	755c                	ld	a5,168(a0)
ffffffffc02041a0:	577d                	li	a4,-1
ffffffffc02041a2:	177e                	slli	a4,a4,0x3f
ffffffffc02041a4:	83b1                	srli	a5,a5,0xc
            current = proc;
ffffffffc02041a6:	00a93023          	sd	a0,0(s2)
ffffffffc02041aa:	8fd9                	or	a5,a5,a4
ffffffffc02041ac:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(next->context));
ffffffffc02041b0:	03050593          	addi	a1,a0,48
ffffffffc02041b4:	03048513          	addi	a0,s1,48
ffffffffc02041b8:	01c010ef          	jal	ra,ffffffffc02051d4 <switch_to>
    if (flag)
ffffffffc02041bc:	00099863          	bnez	s3,ffffffffc02041cc <proc_run+0x52>
}
ffffffffc02041c0:	70a2                	ld	ra,40(sp)
ffffffffc02041c2:	7482                	ld	s1,32(sp)
ffffffffc02041c4:	6962                	ld	s2,24(sp)
ffffffffc02041c6:	69c2                	ld	s3,16(sp)
ffffffffc02041c8:	6145                	addi	sp,sp,48
ffffffffc02041ca:	8082                	ret
ffffffffc02041cc:	70a2                	ld	ra,40(sp)
ffffffffc02041ce:	7482                	ld	s1,32(sp)
ffffffffc02041d0:	6962                	ld	s2,24(sp)
ffffffffc02041d2:	69c2                	ld	s3,16(sp)
ffffffffc02041d4:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02041d6:	fd8fc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc02041da:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02041dc:	fd8fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02041e0:	6522                	ld	a0,8(sp)
ffffffffc02041e2:	4985                	li	s3,1
ffffffffc02041e4:	bf6d                	j	ffffffffc020419e <proc_run+0x24>

ffffffffc02041e6 <do_fork>:
{
ffffffffc02041e6:	7119                	addi	sp,sp,-128
ffffffffc02041e8:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc02041ea:	000db917          	auipc	s2,0xdb
ffffffffc02041ee:	95690913          	addi	s2,s2,-1706 # ffffffffc02deb40 <nr_process>
ffffffffc02041f2:	00092703          	lw	a4,0(s2)
{
ffffffffc02041f6:	fc86                	sd	ra,120(sp)
ffffffffc02041f8:	f8a2                	sd	s0,112(sp)
ffffffffc02041fa:	f4a6                	sd	s1,104(sp)
ffffffffc02041fc:	ecce                	sd	s3,88(sp)
ffffffffc02041fe:	e8d2                	sd	s4,80(sp)
ffffffffc0204200:	e4d6                	sd	s5,72(sp)
ffffffffc0204202:	e0da                	sd	s6,64(sp)
ffffffffc0204204:	fc5e                	sd	s7,56(sp)
ffffffffc0204206:	f862                	sd	s8,48(sp)
ffffffffc0204208:	f466                	sd	s9,40(sp)
ffffffffc020420a:	f06a                	sd	s10,32(sp)
ffffffffc020420c:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc020420e:	6785                	lui	a5,0x1
ffffffffc0204210:	32f75863          	bge	a4,a5,ffffffffc0204540 <do_fork+0x35a>
ffffffffc0204214:	8a2a                	mv	s4,a0
ffffffffc0204216:	89ae                	mv	s3,a1
ffffffffc0204218:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc020421a:	dedff0ef          	jal	ra,ffffffffc0204006 <alloc_proc>
ffffffffc020421e:	84aa                	mv	s1,a0
ffffffffc0204220:	30050163          	beqz	a0,ffffffffc0204522 <do_fork+0x33c>
    proc->parent = current;
ffffffffc0204224:	000dbc17          	auipc	s8,0xdb
ffffffffc0204228:	904c0c13          	addi	s8,s8,-1788 # ffffffffc02deb28 <current>
ffffffffc020422c:	000c3783          	ld	a5,0(s8)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0204230:	4509                	li	a0,2
    proc->parent = current;
ffffffffc0204232:	f09c                	sd	a5,32(s1)
    current->wait_state = 0;
ffffffffc0204234:	0e07a623          	sw	zero,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x8ab4>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0204238:	d05fd0ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
    if (page != NULL)
ffffffffc020423c:	2e050063          	beqz	a0,ffffffffc020451c <do_fork+0x336>
    return page - pages + nbase;
ffffffffc0204240:	000dba97          	auipc	s5,0xdb
ffffffffc0204244:	8c8a8a93          	addi	s5,s5,-1848 # ffffffffc02deb08 <pages>
ffffffffc0204248:	000ab683          	ld	a3,0(s5)
ffffffffc020424c:	00004b17          	auipc	s6,0x4
ffffffffc0204250:	a0cb0b13          	addi	s6,s6,-1524 # ffffffffc0207c58 <nbase>
ffffffffc0204254:	000b3783          	ld	a5,0(s6)
ffffffffc0204258:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc020425c:	000dbb97          	auipc	s7,0xdb
ffffffffc0204260:	8a4b8b93          	addi	s7,s7,-1884 # ffffffffc02deb00 <npage>
    return page - pages + nbase;
ffffffffc0204264:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204266:	5dfd                	li	s11,-1
ffffffffc0204268:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc020426c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020426e:	00cddd93          	srli	s11,s11,0xc
ffffffffc0204272:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0204276:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204278:	32e67a63          	bgeu	a2,a4,ffffffffc02045ac <do_fork+0x3c6>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc020427c:	000c3603          	ld	a2,0(s8)
ffffffffc0204280:	000dbc17          	auipc	s8,0xdb
ffffffffc0204284:	898c0c13          	addi	s8,s8,-1896 # ffffffffc02deb18 <va_pa_offset>
ffffffffc0204288:	000c3703          	ld	a4,0(s8)
ffffffffc020428c:	02863d03          	ld	s10,40(a2)
ffffffffc0204290:	e43e                	sd	a5,8(sp)
ffffffffc0204292:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204294:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc0204296:	020d0863          	beqz	s10,ffffffffc02042c6 <do_fork+0xe0>
    if (clone_flags & CLONE_VM)
ffffffffc020429a:	100a7a13          	andi	s4,s4,256
ffffffffc020429e:	1c0a0163          	beqz	s4,ffffffffc0204460 <do_fork+0x27a>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc02042a2:	030d2703          	lw	a4,48(s10) # 200030 <_binary_obj___user_dirtycow_out_size+0x1f4ae0>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042a6:	018d3783          	ld	a5,24(s10)
ffffffffc02042aa:	c02006b7          	lui	a3,0xc0200
ffffffffc02042ae:	2705                	addiw	a4,a4,1
ffffffffc02042b0:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc02042b4:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042b8:	2cd7e163          	bltu	a5,a3,ffffffffc020457a <do_fork+0x394>
ffffffffc02042bc:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02042c0:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042c2:	8f99                	sub	a5,a5,a4
ffffffffc02042c4:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02042c6:	6789                	lui	a5,0x2
ffffffffc02042c8:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cc0>
ffffffffc02042cc:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02042ce:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02042d0:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02042d2:	87b6                	mv	a5,a3
ffffffffc02042d4:	12040893          	addi	a7,s0,288
ffffffffc02042d8:	00063803          	ld	a6,0(a2)
ffffffffc02042dc:	6608                	ld	a0,8(a2)
ffffffffc02042de:	6a0c                	ld	a1,16(a2)
ffffffffc02042e0:	6e18                	ld	a4,24(a2)
ffffffffc02042e2:	0107b023          	sd	a6,0(a5)
ffffffffc02042e6:	e788                	sd	a0,8(a5)
ffffffffc02042e8:	eb8c                	sd	a1,16(a5)
ffffffffc02042ea:	ef98                	sd	a4,24(a5)
ffffffffc02042ec:	02060613          	addi	a2,a2,32
ffffffffc02042f0:	02078793          	addi	a5,a5,32
ffffffffc02042f4:	ff1612e3          	bne	a2,a7,ffffffffc02042d8 <do_fork+0xf2>
    proc->tf->gpr.a0 = 0;
ffffffffc02042f8:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02042fc:	12098f63          	beqz	s3,ffffffffc020443a <do_fork+0x254>
ffffffffc0204300:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204304:	00000797          	auipc	a5,0x0
ffffffffc0204308:	d7478793          	addi	a5,a5,-652 # ffffffffc0204078 <forkret>
ffffffffc020430c:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020430e:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204310:	100027f3          	csrr	a5,sstatus
ffffffffc0204314:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204316:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204318:	14079063          	bnez	a5,ffffffffc0204458 <do_fork+0x272>
    if (++last_pid >= MAX_PID)
ffffffffc020431c:	000d6817          	auipc	a6,0xd6
ffffffffc0204320:	36c80813          	addi	a6,a6,876 # ffffffffc02da688 <last_pid.1>
ffffffffc0204324:	00082783          	lw	a5,0(a6)
ffffffffc0204328:	6709                	lui	a4,0x2
ffffffffc020432a:	0017851b          	addiw	a0,a5,1
ffffffffc020432e:	00a82023          	sw	a0,0(a6)
ffffffffc0204332:	08e55d63          	bge	a0,a4,ffffffffc02043cc <do_fork+0x1e6>
    if (last_pid >= next_safe)
ffffffffc0204336:	000d6317          	auipc	t1,0xd6
ffffffffc020433a:	35630313          	addi	t1,t1,854 # ffffffffc02da68c <next_safe.0>
ffffffffc020433e:	00032783          	lw	a5,0(t1)
ffffffffc0204342:	000da417          	auipc	s0,0xda
ffffffffc0204346:	76640413          	addi	s0,s0,1894 # ffffffffc02deaa8 <proc_list>
ffffffffc020434a:	08f55963          	bge	a0,a5,ffffffffc02043dc <do_fork+0x1f6>
        proc->pid = get_pid();
ffffffffc020434e:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204350:	45a9                	li	a1,10
ffffffffc0204352:	2501                	sext.w	a0,a0
ffffffffc0204354:	0d6010ef          	jal	ra,ffffffffc020542a <hash32>
ffffffffc0204358:	02051793          	slli	a5,a0,0x20
ffffffffc020435c:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204360:	000d6797          	auipc	a5,0xd6
ffffffffc0204364:	74878793          	addi	a5,a5,1864 # ffffffffc02daaa8 <hash_list>
ffffffffc0204368:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc020436a:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020436c:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020436e:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc0204372:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0204374:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc0204376:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204378:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc020437a:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc020437e:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc0204380:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc0204382:	e21c                	sd	a5,0(a2)
ffffffffc0204384:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc0204386:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc0204388:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc020438a:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020438e:	10e4b023          	sd	a4,256(s1)
ffffffffc0204392:	c311                	beqz	a4,ffffffffc0204396 <do_fork+0x1b0>
        proc->optr->yptr = proc;
ffffffffc0204394:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc0204396:	00092783          	lw	a5,0(s2)
    proc->parent->cptr = proc;
ffffffffc020439a:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc020439c:	2785                	addiw	a5,a5,1
ffffffffc020439e:	00f92023          	sw	a5,0(s2)
    if (flag)
ffffffffc02043a2:	18099263          	bnez	s3,ffffffffc0204526 <do_fork+0x340>
    wakeup_proc(proc);
ffffffffc02043a6:	8526                	mv	a0,s1
ffffffffc02043a8:	697000ef          	jal	ra,ffffffffc020523e <wakeup_proc>
    ret = proc->pid;
ffffffffc02043ac:	40c8                	lw	a0,4(s1)
}
ffffffffc02043ae:	70e6                	ld	ra,120(sp)
ffffffffc02043b0:	7446                	ld	s0,112(sp)
ffffffffc02043b2:	74a6                	ld	s1,104(sp)
ffffffffc02043b4:	7906                	ld	s2,96(sp)
ffffffffc02043b6:	69e6                	ld	s3,88(sp)
ffffffffc02043b8:	6a46                	ld	s4,80(sp)
ffffffffc02043ba:	6aa6                	ld	s5,72(sp)
ffffffffc02043bc:	6b06                	ld	s6,64(sp)
ffffffffc02043be:	7be2                	ld	s7,56(sp)
ffffffffc02043c0:	7c42                	ld	s8,48(sp)
ffffffffc02043c2:	7ca2                	ld	s9,40(sp)
ffffffffc02043c4:	7d02                	ld	s10,32(sp)
ffffffffc02043c6:	6de2                	ld	s11,24(sp)
ffffffffc02043c8:	6109                	addi	sp,sp,128
ffffffffc02043ca:	8082                	ret
        last_pid = 1;
ffffffffc02043cc:	4785                	li	a5,1
ffffffffc02043ce:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02043d2:	4505                	li	a0,1
ffffffffc02043d4:	000d6317          	auipc	t1,0xd6
ffffffffc02043d8:	2b830313          	addi	t1,t1,696 # ffffffffc02da68c <next_safe.0>
    return listelm->next;
ffffffffc02043dc:	000da417          	auipc	s0,0xda
ffffffffc02043e0:	6cc40413          	addi	s0,s0,1740 # ffffffffc02deaa8 <proc_list>
ffffffffc02043e4:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc02043e8:	6789                	lui	a5,0x2
ffffffffc02043ea:	00f32023          	sw	a5,0(t1)
ffffffffc02043ee:	86aa                	mv	a3,a0
ffffffffc02043f0:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02043f2:	6e89                	lui	t4,0x2
ffffffffc02043f4:	148e0163          	beq	t3,s0,ffffffffc0204536 <do_fork+0x350>
ffffffffc02043f8:	88ae                	mv	a7,a1
ffffffffc02043fa:	87f2                	mv	a5,t3
ffffffffc02043fc:	6609                	lui	a2,0x2
ffffffffc02043fe:	a811                	j	ffffffffc0204412 <do_fork+0x22c>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204400:	00e6d663          	bge	a3,a4,ffffffffc020440c <do_fork+0x226>
ffffffffc0204404:	00c75463          	bge	a4,a2,ffffffffc020440c <do_fork+0x226>
ffffffffc0204408:	863a                	mv	a2,a4
ffffffffc020440a:	4885                	li	a7,1
ffffffffc020440c:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020440e:	00878d63          	beq	a5,s0,ffffffffc0204428 <do_fork+0x242>
            if (proc->pid == last_pid)
ffffffffc0204412:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c64>
ffffffffc0204416:	fed715e3          	bne	a4,a3,ffffffffc0204400 <do_fork+0x21a>
                if (++last_pid >= next_safe)
ffffffffc020441a:	2685                	addiw	a3,a3,1
ffffffffc020441c:	10c6d863          	bge	a3,a2,ffffffffc020452c <do_fork+0x346>
ffffffffc0204420:	679c                	ld	a5,8(a5)
ffffffffc0204422:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0204424:	fe8797e3          	bne	a5,s0,ffffffffc0204412 <do_fork+0x22c>
ffffffffc0204428:	c581                	beqz	a1,ffffffffc0204430 <do_fork+0x24a>
ffffffffc020442a:	00d82023          	sw	a3,0(a6)
ffffffffc020442e:	8536                	mv	a0,a3
ffffffffc0204430:	f0088fe3          	beqz	a7,ffffffffc020434e <do_fork+0x168>
ffffffffc0204434:	00c32023          	sw	a2,0(t1)
ffffffffc0204438:	bf19                	j	ffffffffc020434e <do_fork+0x168>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020443a:	89b6                	mv	s3,a3
ffffffffc020443c:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204440:	00000797          	auipc	a5,0x0
ffffffffc0204444:	c3878793          	addi	a5,a5,-968 # ffffffffc0204078 <forkret>
ffffffffc0204448:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020444a:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020444c:	100027f3          	csrr	a5,sstatus
ffffffffc0204450:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204452:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204454:	ec0784e3          	beqz	a5,ffffffffc020431c <do_fork+0x136>
        intr_disable();
ffffffffc0204458:	d5cfc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020445c:	4985                	li	s3,1
ffffffffc020445e:	bd7d                	j	ffffffffc020431c <do_fork+0x136>
    if ((mm = mm_create()) == NULL)
ffffffffc0204460:	a66ff0ef          	jal	ra,ffffffffc02036c6 <mm_create>
ffffffffc0204464:	8caa                	mv	s9,a0
ffffffffc0204466:	c159                	beqz	a0,ffffffffc02044ec <do_fork+0x306>
    if ((page = alloc_page()) == NULL)
ffffffffc0204468:	4505                	li	a0,1
ffffffffc020446a:	ad3fd0ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc020446e:	cd25                	beqz	a0,ffffffffc02044e6 <do_fork+0x300>
    return page - pages + nbase;
ffffffffc0204470:	000ab683          	ld	a3,0(s5)
ffffffffc0204474:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc0204476:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc020447a:	40d506b3          	sub	a3,a0,a3
ffffffffc020447e:	8699                	srai	a3,a3,0x6
ffffffffc0204480:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204482:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0204486:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204488:	12edf263          	bgeu	s11,a4,ffffffffc02045ac <do_fork+0x3c6>
ffffffffc020448c:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204490:	6605                	lui	a2,0x1
ffffffffc0204492:	000da597          	auipc	a1,0xda
ffffffffc0204496:	6665b583          	ld	a1,1638(a1) # ffffffffc02deaf8 <boot_pgdir_va>
ffffffffc020449a:	9a36                	add	s4,s4,a3
ffffffffc020449c:	8552                	mv	a0,s4
ffffffffc020449e:	444010ef          	jal	ra,ffffffffc02058e2 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc02044a2:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc02044a6:	014cbc23          	sd	s4,24(s9) # ffffffffffe00018 <end+0x3fb214d4>
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02044aa:	4785                	li	a5,1
ffffffffc02044ac:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc02044b0:	8b85                	andi	a5,a5,1
ffffffffc02044b2:	4a05                	li	s4,1
ffffffffc02044b4:	c799                	beqz	a5,ffffffffc02044c2 <do_fork+0x2dc>
    {
        schedule();
ffffffffc02044b6:	609000ef          	jal	ra,ffffffffc02052be <schedule>
ffffffffc02044ba:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc02044be:	8b85                	andi	a5,a5,1
ffffffffc02044c0:	fbfd                	bnez	a5,ffffffffc02044b6 <do_fork+0x2d0>
        ret = dup_mmap(mm, oldmm);
ffffffffc02044c2:	85ea                	mv	a1,s10
ffffffffc02044c4:	8566                	mv	a0,s9
ffffffffc02044c6:	e70ff0ef          	jal	ra,ffffffffc0203b36 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02044ca:	57f9                	li	a5,-2
ffffffffc02044cc:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc02044d0:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02044d2:	cfa5                	beqz	a5,ffffffffc020454a <do_fork+0x364>
good_mm:
ffffffffc02044d4:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc02044d6:	dc0506e3          	beqz	a0,ffffffffc02042a2 <do_fork+0xbc>
    exit_mmap(mm);
ffffffffc02044da:	8566                	mv	a0,s9
ffffffffc02044dc:	ef4ff0ef          	jal	ra,ffffffffc0203bd0 <exit_mmap>
    put_pgdir(mm);
ffffffffc02044e0:	8566                	mv	a0,s9
ffffffffc02044e2:	c23ff0ef          	jal	ra,ffffffffc0204104 <put_pgdir>
    mm_destroy(mm);
ffffffffc02044e6:	8566                	mv	a0,s9
ffffffffc02044e8:	d4cff0ef          	jal	ra,ffffffffc0203a34 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02044ec:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc02044ee:	c02007b7          	lui	a5,0xc0200
ffffffffc02044f2:	0af6e163          	bltu	a3,a5,ffffffffc0204594 <do_fork+0x3ae>
ffffffffc02044f6:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc02044fa:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc02044fe:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204502:	83b1                	srli	a5,a5,0xc
ffffffffc0204504:	04e7ff63          	bgeu	a5,a4,ffffffffc0204562 <do_fork+0x37c>
    return &pages[PPN(pa) - nbase];
ffffffffc0204508:	000b3703          	ld	a4,0(s6)
ffffffffc020450c:	000ab503          	ld	a0,0(s5)
ffffffffc0204510:	4589                	li	a1,2
ffffffffc0204512:	8f99                	sub	a5,a5,a4
ffffffffc0204514:	079a                	slli	a5,a5,0x6
ffffffffc0204516:	953e                	add	a0,a0,a5
ffffffffc0204518:	a63fd0ef          	jal	ra,ffffffffc0201f7a <free_pages>
    kfree(proc);
ffffffffc020451c:	8526                	mv	a0,s1
ffffffffc020451e:	8f1fd0ef          	jal	ra,ffffffffc0201e0e <kfree>
    ret = -E_NO_MEM;
ffffffffc0204522:	5571                	li	a0,-4
    return ret;
ffffffffc0204524:	b569                	j	ffffffffc02043ae <do_fork+0x1c8>
        intr_enable();
ffffffffc0204526:	c88fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020452a:	bdb5                	j	ffffffffc02043a6 <do_fork+0x1c0>
                    if (last_pid >= MAX_PID)
ffffffffc020452c:	01d6c363          	blt	a3,t4,ffffffffc0204532 <do_fork+0x34c>
                        last_pid = 1;
ffffffffc0204530:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204532:	4585                	li	a1,1
ffffffffc0204534:	b5c1                	j	ffffffffc02043f4 <do_fork+0x20e>
ffffffffc0204536:	c599                	beqz	a1,ffffffffc0204544 <do_fork+0x35e>
ffffffffc0204538:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc020453c:	8536                	mv	a0,a3
ffffffffc020453e:	bd01                	j	ffffffffc020434e <do_fork+0x168>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204540:	556d                	li	a0,-5
ffffffffc0204542:	b5b5                	j	ffffffffc02043ae <do_fork+0x1c8>
    return last_pid;
ffffffffc0204544:	00082503          	lw	a0,0(a6)
ffffffffc0204548:	b519                	j	ffffffffc020434e <do_fork+0x168>
    {
        panic("Unlock failed.\n");
ffffffffc020454a:	00003617          	auipc	a2,0x3
ffffffffc020454e:	e8e60613          	addi	a2,a2,-370 # ffffffffc02073d8 <default_pmm_manager+0xc78>
ffffffffc0204552:	03f00593          	li	a1,63
ffffffffc0204556:	00003517          	auipc	a0,0x3
ffffffffc020455a:	e9250513          	addi	a0,a0,-366 # ffffffffc02073e8 <default_pmm_manager+0xc88>
ffffffffc020455e:	f31fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204562:	00002617          	auipc	a2,0x2
ffffffffc0204566:	30660613          	addi	a2,a2,774 # ffffffffc0206868 <default_pmm_manager+0x108>
ffffffffc020456a:	06900593          	li	a1,105
ffffffffc020456e:	00002517          	auipc	a0,0x2
ffffffffc0204572:	25250513          	addi	a0,a0,594 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc0204576:	f19fb0ef          	jal	ra,ffffffffc020048e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020457a:	86be                	mv	a3,a5
ffffffffc020457c:	00002617          	auipc	a2,0x2
ffffffffc0204580:	2c460613          	addi	a2,a2,708 # ffffffffc0206840 <default_pmm_manager+0xe0>
ffffffffc0204584:	18e00593          	li	a1,398
ffffffffc0204588:	00003517          	auipc	a0,0x3
ffffffffc020458c:	e3850513          	addi	a0,a0,-456 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204590:	efffb0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204594:	00002617          	auipc	a2,0x2
ffffffffc0204598:	2ac60613          	addi	a2,a2,684 # ffffffffc0206840 <default_pmm_manager+0xe0>
ffffffffc020459c:	07700593          	li	a1,119
ffffffffc02045a0:	00002517          	auipc	a0,0x2
ffffffffc02045a4:	22050513          	addi	a0,a0,544 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc02045a8:	ee7fb0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc02045ac:	00002617          	auipc	a2,0x2
ffffffffc02045b0:	1ec60613          	addi	a2,a2,492 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc02045b4:	07100593          	li	a1,113
ffffffffc02045b8:	00002517          	auipc	a0,0x2
ffffffffc02045bc:	20850513          	addi	a0,a0,520 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc02045c0:	ecffb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02045c4 <kernel_thread>:
{
ffffffffc02045c4:	7129                	addi	sp,sp,-320
ffffffffc02045c6:	fa22                	sd	s0,304(sp)
ffffffffc02045c8:	f626                	sd	s1,296(sp)
ffffffffc02045ca:	f24a                	sd	s2,288(sp)
ffffffffc02045cc:	84ae                	mv	s1,a1
ffffffffc02045ce:	892a                	mv	s2,a0
ffffffffc02045d0:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02045d2:	4581                	li	a1,0
ffffffffc02045d4:	12000613          	li	a2,288
ffffffffc02045d8:	850a                	mv	a0,sp
{
ffffffffc02045da:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02045dc:	2f4010ef          	jal	ra,ffffffffc02058d0 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02045e0:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02045e2:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02045e4:	100027f3          	csrr	a5,sstatus
ffffffffc02045e8:	edd7f793          	andi	a5,a5,-291
ffffffffc02045ec:	1207e793          	ori	a5,a5,288
ffffffffc02045f0:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02045f2:	860a                	mv	a2,sp
ffffffffc02045f4:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02045f8:	00000797          	auipc	a5,0x0
ffffffffc02045fc:	a0678793          	addi	a5,a5,-1530 # ffffffffc0203ffe <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204600:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204602:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204604:	be3ff0ef          	jal	ra,ffffffffc02041e6 <do_fork>
}
ffffffffc0204608:	70f2                	ld	ra,312(sp)
ffffffffc020460a:	7452                	ld	s0,304(sp)
ffffffffc020460c:	74b2                	ld	s1,296(sp)
ffffffffc020460e:	7912                	ld	s2,288(sp)
ffffffffc0204610:	6131                	addi	sp,sp,320
ffffffffc0204612:	8082                	ret

ffffffffc0204614 <do_exit>:
{
ffffffffc0204614:	7179                	addi	sp,sp,-48
ffffffffc0204616:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204618:	000da417          	auipc	s0,0xda
ffffffffc020461c:	51040413          	addi	s0,s0,1296 # ffffffffc02deb28 <current>
ffffffffc0204620:	601c                	ld	a5,0(s0)
{
ffffffffc0204622:	f406                	sd	ra,40(sp)
ffffffffc0204624:	ec26                	sd	s1,24(sp)
ffffffffc0204626:	e84a                	sd	s2,16(sp)
ffffffffc0204628:	e44e                	sd	s3,8(sp)
ffffffffc020462a:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc020462c:	000da717          	auipc	a4,0xda
ffffffffc0204630:	50473703          	ld	a4,1284(a4) # ffffffffc02deb30 <idleproc>
ffffffffc0204634:	0ce78c63          	beq	a5,a4,ffffffffc020470c <do_exit+0xf8>
    if (current == initproc)
ffffffffc0204638:	000da497          	auipc	s1,0xda
ffffffffc020463c:	50048493          	addi	s1,s1,1280 # ffffffffc02deb38 <initproc>
ffffffffc0204640:	6098                	ld	a4,0(s1)
ffffffffc0204642:	0ee78b63          	beq	a5,a4,ffffffffc0204738 <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc0204646:	0287b983          	ld	s3,40(a5)
ffffffffc020464a:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc020464c:	02098663          	beqz	s3,ffffffffc0204678 <do_exit+0x64>
ffffffffc0204650:	000da797          	auipc	a5,0xda
ffffffffc0204654:	4a07b783          	ld	a5,1184(a5) # ffffffffc02deaf0 <boot_pgdir_pa>
ffffffffc0204658:	577d                	li	a4,-1
ffffffffc020465a:	177e                	slli	a4,a4,0x3f
ffffffffc020465c:	83b1                	srli	a5,a5,0xc
ffffffffc020465e:	8fd9                	or	a5,a5,a4
ffffffffc0204660:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204664:	0309a783          	lw	a5,48(s3)
ffffffffc0204668:	fff7871b          	addiw	a4,a5,-1
ffffffffc020466c:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204670:	cb55                	beqz	a4,ffffffffc0204724 <do_exit+0x110>
        current->mm = NULL;
ffffffffc0204672:	601c                	ld	a5,0(s0)
ffffffffc0204674:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204678:	601c                	ld	a5,0(s0)
ffffffffc020467a:	470d                	li	a4,3
ffffffffc020467c:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc020467e:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204682:	100027f3          	csrr	a5,sstatus
ffffffffc0204686:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204688:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020468a:	e3f9                	bnez	a5,ffffffffc0204750 <do_exit+0x13c>
        proc = current->parent;
ffffffffc020468c:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc020468e:	800007b7          	lui	a5,0x80000
ffffffffc0204692:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc0204694:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204696:	0ec52703          	lw	a4,236(a0)
ffffffffc020469a:	0af70f63          	beq	a4,a5,ffffffffc0204758 <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc020469e:	6018                	ld	a4,0(s0)
ffffffffc02046a0:	7b7c                	ld	a5,240(a4)
ffffffffc02046a2:	c3a1                	beqz	a5,ffffffffc02046e2 <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02046a4:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046a8:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc02046aa:	0985                	addi	s3,s3,1
ffffffffc02046ac:	a021                	j	ffffffffc02046b4 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc02046ae:	6018                	ld	a4,0(s0)
ffffffffc02046b0:	7b7c                	ld	a5,240(a4)
ffffffffc02046b2:	cb85                	beqz	a5,ffffffffc02046e2 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02046b4:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_dirtycow_out_size+0xffffffff7fff4bb0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02046b8:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02046ba:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02046bc:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02046be:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02046c2:	10e7b023          	sd	a4,256(a5)
ffffffffc02046c6:	c311                	beqz	a4,ffffffffc02046ca <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02046c8:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046ca:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02046cc:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02046ce:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046d0:	fd271fe3          	bne	a4,s2,ffffffffc02046ae <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02046d4:	0ec52783          	lw	a5,236(a0)
ffffffffc02046d8:	fd379be3          	bne	a5,s3,ffffffffc02046ae <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02046dc:	363000ef          	jal	ra,ffffffffc020523e <wakeup_proc>
ffffffffc02046e0:	b7f9                	j	ffffffffc02046ae <do_exit+0x9a>
    if (flag)
ffffffffc02046e2:	020a1263          	bnez	s4,ffffffffc0204706 <do_exit+0xf2>
    schedule();
ffffffffc02046e6:	3d9000ef          	jal	ra,ffffffffc02052be <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02046ea:	601c                	ld	a5,0(s0)
ffffffffc02046ec:	00003617          	auipc	a2,0x3
ffffffffc02046f0:	d3460613          	addi	a2,a2,-716 # ffffffffc0207420 <default_pmm_manager+0xcc0>
ffffffffc02046f4:	24800593          	li	a1,584
ffffffffc02046f8:	43d4                	lw	a3,4(a5)
ffffffffc02046fa:	00003517          	auipc	a0,0x3
ffffffffc02046fe:	cc650513          	addi	a0,a0,-826 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204702:	d8dfb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_enable();
ffffffffc0204706:	aa8fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020470a:	bff1                	j	ffffffffc02046e6 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc020470c:	00003617          	auipc	a2,0x3
ffffffffc0204710:	cf460613          	addi	a2,a2,-780 # ffffffffc0207400 <default_pmm_manager+0xca0>
ffffffffc0204714:	21400593          	li	a1,532
ffffffffc0204718:	00003517          	auipc	a0,0x3
ffffffffc020471c:	ca850513          	addi	a0,a0,-856 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204720:	d6ffb0ef          	jal	ra,ffffffffc020048e <__panic>
            exit_mmap(mm);
ffffffffc0204724:	854e                	mv	a0,s3
ffffffffc0204726:	caaff0ef          	jal	ra,ffffffffc0203bd0 <exit_mmap>
            put_pgdir(mm);
ffffffffc020472a:	854e                	mv	a0,s3
ffffffffc020472c:	9d9ff0ef          	jal	ra,ffffffffc0204104 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204730:	854e                	mv	a0,s3
ffffffffc0204732:	b02ff0ef          	jal	ra,ffffffffc0203a34 <mm_destroy>
ffffffffc0204736:	bf35                	j	ffffffffc0204672 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204738:	00003617          	auipc	a2,0x3
ffffffffc020473c:	cd860613          	addi	a2,a2,-808 # ffffffffc0207410 <default_pmm_manager+0xcb0>
ffffffffc0204740:	21800593          	li	a1,536
ffffffffc0204744:	00003517          	auipc	a0,0x3
ffffffffc0204748:	c7c50513          	addi	a0,a0,-900 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc020474c:	d43fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc0204750:	a64fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204754:	4a05                	li	s4,1
ffffffffc0204756:	bf1d                	j	ffffffffc020468c <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204758:	2e7000ef          	jal	ra,ffffffffc020523e <wakeup_proc>
ffffffffc020475c:	b789                	j	ffffffffc020469e <do_exit+0x8a>

ffffffffc020475e <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc020475e:	715d                	addi	sp,sp,-80
ffffffffc0204760:	f84a                	sd	s2,48(sp)
ffffffffc0204762:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc0204764:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204768:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc020476a:	fc26                	sd	s1,56(sp)
ffffffffc020476c:	f052                	sd	s4,32(sp)
ffffffffc020476e:	ec56                	sd	s5,24(sp)
ffffffffc0204770:	e85a                	sd	s6,16(sp)
ffffffffc0204772:	e45e                	sd	s7,8(sp)
ffffffffc0204774:	e486                	sd	ra,72(sp)
ffffffffc0204776:	e0a2                	sd	s0,64(sp)
ffffffffc0204778:	84aa                	mv	s1,a0
ffffffffc020477a:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc020477c:	000dab97          	auipc	s7,0xda
ffffffffc0204780:	3acb8b93          	addi	s7,s7,940 # ffffffffc02deb28 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204784:	00050b1b          	sext.w	s6,a0
ffffffffc0204788:	fff50a9b          	addiw	s5,a0,-1
ffffffffc020478c:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc020478e:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc0204790:	ccbd                	beqz	s1,ffffffffc020480e <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204792:	0359e863          	bltu	s3,s5,ffffffffc02047c2 <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204796:	45a9                	li	a1,10
ffffffffc0204798:	855a                	mv	a0,s6
ffffffffc020479a:	491000ef          	jal	ra,ffffffffc020542a <hash32>
ffffffffc020479e:	02051793          	slli	a5,a0,0x20
ffffffffc02047a2:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02047a6:	000d6797          	auipc	a5,0xd6
ffffffffc02047aa:	30278793          	addi	a5,a5,770 # ffffffffc02daaa8 <hash_list>
ffffffffc02047ae:	953e                	add	a0,a0,a5
ffffffffc02047b0:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc02047b2:	a029                	j	ffffffffc02047bc <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc02047b4:	f2c42783          	lw	a5,-212(s0)
ffffffffc02047b8:	02978163          	beq	a5,s1,ffffffffc02047da <do_wait.part.0+0x7c>
ffffffffc02047bc:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc02047be:	fe851be3          	bne	a0,s0,ffffffffc02047b4 <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc02047c2:	5579                	li	a0,-2
}
ffffffffc02047c4:	60a6                	ld	ra,72(sp)
ffffffffc02047c6:	6406                	ld	s0,64(sp)
ffffffffc02047c8:	74e2                	ld	s1,56(sp)
ffffffffc02047ca:	7942                	ld	s2,48(sp)
ffffffffc02047cc:	79a2                	ld	s3,40(sp)
ffffffffc02047ce:	7a02                	ld	s4,32(sp)
ffffffffc02047d0:	6ae2                	ld	s5,24(sp)
ffffffffc02047d2:	6b42                	ld	s6,16(sp)
ffffffffc02047d4:	6ba2                	ld	s7,8(sp)
ffffffffc02047d6:	6161                	addi	sp,sp,80
ffffffffc02047d8:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02047da:	000bb683          	ld	a3,0(s7)
ffffffffc02047de:	f4843783          	ld	a5,-184(s0)
ffffffffc02047e2:	fed790e3          	bne	a5,a3,ffffffffc02047c2 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02047e6:	f2842703          	lw	a4,-216(s0)
ffffffffc02047ea:	478d                	li	a5,3
ffffffffc02047ec:	0ef70b63          	beq	a4,a5,ffffffffc02048e2 <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc02047f0:	4785                	li	a5,1
ffffffffc02047f2:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc02047f4:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc02047f8:	2c7000ef          	jal	ra,ffffffffc02052be <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02047fc:	000bb783          	ld	a5,0(s7)
ffffffffc0204800:	0b07a783          	lw	a5,176(a5)
ffffffffc0204804:	8b85                	andi	a5,a5,1
ffffffffc0204806:	d7c9                	beqz	a5,ffffffffc0204790 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0204808:	555d                	li	a0,-9
ffffffffc020480a:	e0bff0ef          	jal	ra,ffffffffc0204614 <do_exit>
        proc = current->cptr;
ffffffffc020480e:	000bb683          	ld	a3,0(s7)
ffffffffc0204812:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204814:	d45d                	beqz	s0,ffffffffc02047c2 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204816:	470d                	li	a4,3
ffffffffc0204818:	a021                	j	ffffffffc0204820 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc020481a:	10043403          	ld	s0,256(s0)
ffffffffc020481e:	d869                	beqz	s0,ffffffffc02047f0 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204820:	401c                	lw	a5,0(s0)
ffffffffc0204822:	fee79ce3          	bne	a5,a4,ffffffffc020481a <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc0204826:	000da797          	auipc	a5,0xda
ffffffffc020482a:	30a7b783          	ld	a5,778(a5) # ffffffffc02deb30 <idleproc>
ffffffffc020482e:	0c878963          	beq	a5,s0,ffffffffc0204900 <do_wait.part.0+0x1a2>
ffffffffc0204832:	000da797          	auipc	a5,0xda
ffffffffc0204836:	3067b783          	ld	a5,774(a5) # ffffffffc02deb38 <initproc>
ffffffffc020483a:	0cf40363          	beq	s0,a5,ffffffffc0204900 <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc020483e:	000a0663          	beqz	s4,ffffffffc020484a <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc0204842:	0e842783          	lw	a5,232(s0)
ffffffffc0204846:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8ba0>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020484a:	100027f3          	csrr	a5,sstatus
ffffffffc020484e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204850:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204852:	e7c1                	bnez	a5,ffffffffc02048da <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204854:	6c70                	ld	a2,216(s0)
ffffffffc0204856:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204858:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc020485c:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc020485e:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204860:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204862:	6470                	ld	a2,200(s0)
ffffffffc0204864:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0204866:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204868:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc020486a:	c319                	beqz	a4,ffffffffc0204870 <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc020486c:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc020486e:	7c7c                	ld	a5,248(s0)
ffffffffc0204870:	c3b5                	beqz	a5,ffffffffc02048d4 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc0204872:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc0204876:	000da717          	auipc	a4,0xda
ffffffffc020487a:	2ca70713          	addi	a4,a4,714 # ffffffffc02deb40 <nr_process>
ffffffffc020487e:	431c                	lw	a5,0(a4)
ffffffffc0204880:	37fd                	addiw	a5,a5,-1
ffffffffc0204882:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc0204884:	e5a9                	bnez	a1,ffffffffc02048ce <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204886:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204888:	c02007b7          	lui	a5,0xc0200
ffffffffc020488c:	04f6ee63          	bltu	a3,a5,ffffffffc02048e8 <do_wait.part.0+0x18a>
ffffffffc0204890:	000da797          	auipc	a5,0xda
ffffffffc0204894:	2887b783          	ld	a5,648(a5) # ffffffffc02deb18 <va_pa_offset>
ffffffffc0204898:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc020489a:	82b1                	srli	a3,a3,0xc
ffffffffc020489c:	000da797          	auipc	a5,0xda
ffffffffc02048a0:	2647b783          	ld	a5,612(a5) # ffffffffc02deb00 <npage>
ffffffffc02048a4:	06f6fa63          	bgeu	a3,a5,ffffffffc0204918 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc02048a8:	00003517          	auipc	a0,0x3
ffffffffc02048ac:	3b053503          	ld	a0,944(a0) # ffffffffc0207c58 <nbase>
ffffffffc02048b0:	8e89                	sub	a3,a3,a0
ffffffffc02048b2:	069a                	slli	a3,a3,0x6
ffffffffc02048b4:	000da517          	auipc	a0,0xda
ffffffffc02048b8:	25453503          	ld	a0,596(a0) # ffffffffc02deb08 <pages>
ffffffffc02048bc:	9536                	add	a0,a0,a3
ffffffffc02048be:	4589                	li	a1,2
ffffffffc02048c0:	ebafd0ef          	jal	ra,ffffffffc0201f7a <free_pages>
    kfree(proc);
ffffffffc02048c4:	8522                	mv	a0,s0
ffffffffc02048c6:	d48fd0ef          	jal	ra,ffffffffc0201e0e <kfree>
    return 0;
ffffffffc02048ca:	4501                	li	a0,0
ffffffffc02048cc:	bde5                	j	ffffffffc02047c4 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02048ce:	8e0fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02048d2:	bf55                	j	ffffffffc0204886 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02048d4:	701c                	ld	a5,32(s0)
ffffffffc02048d6:	fbf8                	sd	a4,240(a5)
ffffffffc02048d8:	bf79                	j	ffffffffc0204876 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02048da:	8dafc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02048de:	4585                	li	a1,1
ffffffffc02048e0:	bf95                	j	ffffffffc0204854 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02048e2:	f2840413          	addi	s0,s0,-216
ffffffffc02048e6:	b781                	j	ffffffffc0204826 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc02048e8:	00002617          	auipc	a2,0x2
ffffffffc02048ec:	f5860613          	addi	a2,a2,-168 # ffffffffc0206840 <default_pmm_manager+0xe0>
ffffffffc02048f0:	07700593          	li	a1,119
ffffffffc02048f4:	00002517          	auipc	a0,0x2
ffffffffc02048f8:	ecc50513          	addi	a0,a0,-308 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc02048fc:	b93fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc0204900:	00003617          	auipc	a2,0x3
ffffffffc0204904:	b4060613          	addi	a2,a2,-1216 # ffffffffc0207440 <default_pmm_manager+0xce0>
ffffffffc0204908:	36900593          	li	a1,873
ffffffffc020490c:	00003517          	auipc	a0,0x3
ffffffffc0204910:	ab450513          	addi	a0,a0,-1356 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204914:	b7bfb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204918:	00002617          	auipc	a2,0x2
ffffffffc020491c:	f5060613          	addi	a2,a2,-176 # ffffffffc0206868 <default_pmm_manager+0x108>
ffffffffc0204920:	06900593          	li	a1,105
ffffffffc0204924:	00002517          	auipc	a0,0x2
ffffffffc0204928:	e9c50513          	addi	a0,a0,-356 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc020492c:	b63fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204930 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0204930:	1141                	addi	sp,sp,-16
ffffffffc0204932:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204934:	e86fd0ef          	jal	ra,ffffffffc0201fba <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204938:	c22fd0ef          	jal	ra,ffffffffc0201d5a <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc020493c:	4601                	li	a2,0
ffffffffc020493e:	4581                	li	a1,0
ffffffffc0204940:	fffff517          	auipc	a0,0xfffff
ffffffffc0204944:	74650513          	addi	a0,a0,1862 # ffffffffc0204086 <user_main>
ffffffffc0204948:	c7dff0ef          	jal	ra,ffffffffc02045c4 <kernel_thread>
    if (pid <= 0)
ffffffffc020494c:	00a04563          	bgtz	a0,ffffffffc0204956 <init_main+0x26>
ffffffffc0204950:	a071                	j	ffffffffc02049dc <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc0204952:	16d000ef          	jal	ra,ffffffffc02052be <schedule>
    if (code_store != NULL)
ffffffffc0204956:	4581                	li	a1,0
ffffffffc0204958:	4501                	li	a0,0
ffffffffc020495a:	e05ff0ef          	jal	ra,ffffffffc020475e <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc020495e:	d975                	beqz	a0,ffffffffc0204952 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204960:	00003517          	auipc	a0,0x3
ffffffffc0204964:	b2050513          	addi	a0,a0,-1248 # ffffffffc0207480 <default_pmm_manager+0xd20>
ffffffffc0204968:	82dfb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020496c:	000da797          	auipc	a5,0xda
ffffffffc0204970:	1cc7b783          	ld	a5,460(a5) # ffffffffc02deb38 <initproc>
ffffffffc0204974:	7bf8                	ld	a4,240(a5)
ffffffffc0204976:	e339                	bnez	a4,ffffffffc02049bc <init_main+0x8c>
ffffffffc0204978:	7ff8                	ld	a4,248(a5)
ffffffffc020497a:	e329                	bnez	a4,ffffffffc02049bc <init_main+0x8c>
ffffffffc020497c:	1007b703          	ld	a4,256(a5)
ffffffffc0204980:	ef15                	bnez	a4,ffffffffc02049bc <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc0204982:	000da697          	auipc	a3,0xda
ffffffffc0204986:	1be6a683          	lw	a3,446(a3) # ffffffffc02deb40 <nr_process>
ffffffffc020498a:	4709                	li	a4,2
ffffffffc020498c:	0ae69463          	bne	a3,a4,ffffffffc0204a34 <init_main+0x104>
    return listelm->next;
ffffffffc0204990:	000da697          	auipc	a3,0xda
ffffffffc0204994:	11868693          	addi	a3,a3,280 # ffffffffc02deaa8 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204998:	6698                	ld	a4,8(a3)
ffffffffc020499a:	0c878793          	addi	a5,a5,200
ffffffffc020499e:	06f71b63          	bne	a4,a5,ffffffffc0204a14 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02049a2:	629c                	ld	a5,0(a3)
ffffffffc02049a4:	04f71863          	bne	a4,a5,ffffffffc02049f4 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc02049a8:	00003517          	auipc	a0,0x3
ffffffffc02049ac:	bc050513          	addi	a0,a0,-1088 # ffffffffc0207568 <default_pmm_manager+0xe08>
ffffffffc02049b0:	fe4fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc02049b4:	60a2                	ld	ra,8(sp)
ffffffffc02049b6:	4501                	li	a0,0
ffffffffc02049b8:	0141                	addi	sp,sp,16
ffffffffc02049ba:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02049bc:	00003697          	auipc	a3,0x3
ffffffffc02049c0:	aec68693          	addi	a3,a3,-1300 # ffffffffc02074a8 <default_pmm_manager+0xd48>
ffffffffc02049c4:	00002617          	auipc	a2,0x2
ffffffffc02049c8:	9ec60613          	addi	a2,a2,-1556 # ffffffffc02063b0 <commands+0x848>
ffffffffc02049cc:	3d700593          	li	a1,983
ffffffffc02049d0:	00003517          	auipc	a0,0x3
ffffffffc02049d4:	9f050513          	addi	a0,a0,-1552 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc02049d8:	ab7fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("create user_main failed.\n");
ffffffffc02049dc:	00003617          	auipc	a2,0x3
ffffffffc02049e0:	a8460613          	addi	a2,a2,-1404 # ffffffffc0207460 <default_pmm_manager+0xd00>
ffffffffc02049e4:	3ce00593          	li	a1,974
ffffffffc02049e8:	00003517          	auipc	a0,0x3
ffffffffc02049ec:	9d850513          	addi	a0,a0,-1576 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc02049f0:	a9ffb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02049f4:	00003697          	auipc	a3,0x3
ffffffffc02049f8:	b4468693          	addi	a3,a3,-1212 # ffffffffc0207538 <default_pmm_manager+0xdd8>
ffffffffc02049fc:	00002617          	auipc	a2,0x2
ffffffffc0204a00:	9b460613          	addi	a2,a2,-1612 # ffffffffc02063b0 <commands+0x848>
ffffffffc0204a04:	3da00593          	li	a1,986
ffffffffc0204a08:	00003517          	auipc	a0,0x3
ffffffffc0204a0c:	9b850513          	addi	a0,a0,-1608 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204a10:	a7ffb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204a14:	00003697          	auipc	a3,0x3
ffffffffc0204a18:	af468693          	addi	a3,a3,-1292 # ffffffffc0207508 <default_pmm_manager+0xda8>
ffffffffc0204a1c:	00002617          	auipc	a2,0x2
ffffffffc0204a20:	99460613          	addi	a2,a2,-1644 # ffffffffc02063b0 <commands+0x848>
ffffffffc0204a24:	3d900593          	li	a1,985
ffffffffc0204a28:	00003517          	auipc	a0,0x3
ffffffffc0204a2c:	99850513          	addi	a0,a0,-1640 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204a30:	a5ffb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_process == 2);
ffffffffc0204a34:	00003697          	auipc	a3,0x3
ffffffffc0204a38:	ac468693          	addi	a3,a3,-1340 # ffffffffc02074f8 <default_pmm_manager+0xd98>
ffffffffc0204a3c:	00002617          	auipc	a2,0x2
ffffffffc0204a40:	97460613          	addi	a2,a2,-1676 # ffffffffc02063b0 <commands+0x848>
ffffffffc0204a44:	3d800593          	li	a1,984
ffffffffc0204a48:	00003517          	auipc	a0,0x3
ffffffffc0204a4c:	97850513          	addi	a0,a0,-1672 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204a50:	a3ffb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204a54 <do_execve>:
{
ffffffffc0204a54:	7171                	addi	sp,sp,-176
ffffffffc0204a56:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204a58:	000dad97          	auipc	s11,0xda
ffffffffc0204a5c:	0d0d8d93          	addi	s11,s11,208 # ffffffffc02deb28 <current>
ffffffffc0204a60:	000db783          	ld	a5,0(s11)
{
ffffffffc0204a64:	e54e                	sd	s3,136(sp)
ffffffffc0204a66:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204a68:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204a6c:	e94a                	sd	s2,144(sp)
ffffffffc0204a6e:	87b2                	mv	a5,a2
ffffffffc0204a70:	892a                	mv	s2,a0
ffffffffc0204a72:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204a74:	862e                	mv	a2,a1
ffffffffc0204a76:	4681                	li	a3,0
ffffffffc0204a78:	85aa                	mv	a1,a0
ffffffffc0204a7a:	854e                	mv	a0,s3
{
ffffffffc0204a7c:	f506                	sd	ra,168(sp)
ffffffffc0204a7e:	f122                	sd	s0,160(sp)
ffffffffc0204a80:	e152                	sd	s4,128(sp)
ffffffffc0204a82:	fcd6                	sd	s5,120(sp)
ffffffffc0204a84:	f8da                	sd	s6,112(sp)
ffffffffc0204a86:	f4de                	sd	s7,104(sp)
ffffffffc0204a88:	f0e2                	sd	s8,96(sp)
ffffffffc0204a8a:	ece6                	sd	s9,88(sp)
ffffffffc0204a8c:	e8ea                	sd	s10,80(sp)
ffffffffc0204a8e:	f03e                	sd	a5,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204a90:	cdaff0ef          	jal	ra,ffffffffc0203f6a <user_mem_check>
ffffffffc0204a94:	40050263          	beqz	a0,ffffffffc0204e98 <do_execve+0x444>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204a98:	4641                	li	a2,16
ffffffffc0204a9a:	4581                	li	a1,0
ffffffffc0204a9c:	1808                	addi	a0,sp,48
ffffffffc0204a9e:	633000ef          	jal	ra,ffffffffc02058d0 <memset>
    memcpy(local_name, name, len);
ffffffffc0204aa2:	47bd                	li	a5,15
ffffffffc0204aa4:	8626                	mv	a2,s1
ffffffffc0204aa6:	1c97ea63          	bltu	a5,s1,ffffffffc0204c7a <do_execve+0x226>
ffffffffc0204aaa:	85ca                	mv	a1,s2
ffffffffc0204aac:	1808                	addi	a0,sp,48
ffffffffc0204aae:	635000ef          	jal	ra,ffffffffc02058e2 <memcpy>
    if (mm != NULL)
ffffffffc0204ab2:	1c098b63          	beqz	s3,ffffffffc0204c88 <do_execve+0x234>
        cputs("mm != NULL");
ffffffffc0204ab6:	00002517          	auipc	a0,0x2
ffffffffc0204aba:	6ca50513          	addi	a0,a0,1738 # ffffffffc0207180 <default_pmm_manager+0xa20>
ffffffffc0204abe:	f0efb0ef          	jal	ra,ffffffffc02001cc <cputs>
ffffffffc0204ac2:	000da797          	auipc	a5,0xda
ffffffffc0204ac6:	02e7b783          	ld	a5,46(a5) # ffffffffc02deaf0 <boot_pgdir_pa>
ffffffffc0204aca:	577d                	li	a4,-1
ffffffffc0204acc:	177e                	slli	a4,a4,0x3f
ffffffffc0204ace:	83b1                	srli	a5,a5,0xc
ffffffffc0204ad0:	8fd9                	or	a5,a5,a4
ffffffffc0204ad2:	18079073          	csrw	satp,a5
ffffffffc0204ad6:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7b70>
ffffffffc0204ada:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204ade:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204ae2:	2a070c63          	beqz	a4,ffffffffc0204d9a <do_execve+0x346>
        current->mm = NULL;
ffffffffc0204ae6:	000db783          	ld	a5,0(s11)
ffffffffc0204aea:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204aee:	bd9fe0ef          	jal	ra,ffffffffc02036c6 <mm_create>
ffffffffc0204af2:	84aa                	mv	s1,a0
ffffffffc0204af4:	1c050563          	beqz	a0,ffffffffc0204cbe <do_execve+0x26a>
    if ((page = alloc_page()) == NULL)
ffffffffc0204af8:	4505                	li	a0,1
ffffffffc0204afa:	c42fd0ef          	jal	ra,ffffffffc0201f3c <alloc_pages>
ffffffffc0204afe:	3a050163          	beqz	a0,ffffffffc0204ea0 <do_execve+0x44c>
    return page - pages + nbase;
ffffffffc0204b02:	000dac17          	auipc	s8,0xda
ffffffffc0204b06:	006c0c13          	addi	s8,s8,6 # ffffffffc02deb08 <pages>
ffffffffc0204b0a:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc0204b0e:	000dac97          	auipc	s9,0xda
ffffffffc0204b12:	ff2c8c93          	addi	s9,s9,-14 # ffffffffc02deb00 <npage>
    return page - pages + nbase;
ffffffffc0204b16:	00003717          	auipc	a4,0x3
ffffffffc0204b1a:	14273703          	ld	a4,322(a4) # ffffffffc0207c58 <nbase>
ffffffffc0204b1e:	40d506b3          	sub	a3,a0,a3
ffffffffc0204b22:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204b24:	5afd                	li	s5,-1
ffffffffc0204b26:	000cb783          	ld	a5,0(s9)
    return page - pages + nbase;
ffffffffc0204b2a:	96ba                	add	a3,a3,a4
ffffffffc0204b2c:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204b2e:	00cad713          	srli	a4,s5,0xc
ffffffffc0204b32:	ec3a                	sd	a4,24(sp)
ffffffffc0204b34:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b36:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b38:	36f77863          	bgeu	a4,a5,ffffffffc0204ea8 <do_execve+0x454>
ffffffffc0204b3c:	000dab17          	auipc	s6,0xda
ffffffffc0204b40:	fdcb0b13          	addi	s6,s6,-36 # ffffffffc02deb18 <va_pa_offset>
ffffffffc0204b44:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204b48:	6605                	lui	a2,0x1
ffffffffc0204b4a:	000da597          	auipc	a1,0xda
ffffffffc0204b4e:	fae5b583          	ld	a1,-82(a1) # ffffffffc02deaf8 <boot_pgdir_va>
ffffffffc0204b52:	9936                	add	s2,s2,a3
ffffffffc0204b54:	854a                	mv	a0,s2
ffffffffc0204b56:	58d000ef          	jal	ra,ffffffffc02058e2 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204b5a:	7782                	ld	a5,32(sp)
ffffffffc0204b5c:	4398                	lw	a4,0(a5)
ffffffffc0204b5e:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204b62:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204b66:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_dirtycow_out_size+0x464b902f>
ffffffffc0204b6a:	14f71063          	bne	a4,a5,ffffffffc0204caa <do_execve+0x256>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204b6e:	7682                	ld	a3,32(sp)
ffffffffc0204b70:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204b74:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204b78:	00371793          	slli	a5,a4,0x3
ffffffffc0204b7c:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204b7e:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204b80:	078e                	slli	a5,a5,0x3
ffffffffc0204b82:	97ce                	add	a5,a5,s3
ffffffffc0204b84:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204b86:	00f9fc63          	bgeu	s3,a5,ffffffffc0204b9e <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204b8a:	0009a783          	lw	a5,0(s3)
ffffffffc0204b8e:	4705                	li	a4,1
ffffffffc0204b90:	12e78963          	beq	a5,a4,ffffffffc0204cc2 <do_execve+0x26e>
    for (; ph < ph_end; ph++)
ffffffffc0204b94:	77a2                	ld	a5,40(sp)
ffffffffc0204b96:	03898993          	addi	s3,s3,56
ffffffffc0204b9a:	fef9e8e3          	bltu	s3,a5,ffffffffc0204b8a <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204b9e:	4701                	li	a4,0
ffffffffc0204ba0:	46ad                	li	a3,11
ffffffffc0204ba2:	00100637          	lui	a2,0x100
ffffffffc0204ba6:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204baa:	8526                	mv	a0,s1
ffffffffc0204bac:	edbfe0ef          	jal	ra,ffffffffc0203a86 <mm_map>
ffffffffc0204bb0:	892a                	mv	s2,a0
ffffffffc0204bb2:	1c051a63          	bnez	a0,ffffffffc0204d86 <do_execve+0x332>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204bb6:	6c88                	ld	a0,24(s1)
ffffffffc0204bb8:	467d                	li	a2,31
ffffffffc0204bba:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204bbe:	a23fe0ef          	jal	ra,ffffffffc02035e0 <pgdir_alloc_page>
ffffffffc0204bc2:	36050b63          	beqz	a0,ffffffffc0204f38 <do_execve+0x4e4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204bc6:	6c88                	ld	a0,24(s1)
ffffffffc0204bc8:	467d                	li	a2,31
ffffffffc0204bca:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204bce:	a13fe0ef          	jal	ra,ffffffffc02035e0 <pgdir_alloc_page>
ffffffffc0204bd2:	34050363          	beqz	a0,ffffffffc0204f18 <do_execve+0x4c4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204bd6:	6c88                	ld	a0,24(s1)
ffffffffc0204bd8:	467d                	li	a2,31
ffffffffc0204bda:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204bde:	a03fe0ef          	jal	ra,ffffffffc02035e0 <pgdir_alloc_page>
ffffffffc0204be2:	30050b63          	beqz	a0,ffffffffc0204ef8 <do_execve+0x4a4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204be6:	6c88                	ld	a0,24(s1)
ffffffffc0204be8:	467d                	li	a2,31
ffffffffc0204bea:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204bee:	9f3fe0ef          	jal	ra,ffffffffc02035e0 <pgdir_alloc_page>
ffffffffc0204bf2:	2e050363          	beqz	a0,ffffffffc0204ed8 <do_execve+0x484>
    mm->mm_count += 1;
ffffffffc0204bf6:	5898                	lw	a4,48(s1)
    current->mm = mm;
ffffffffc0204bf8:	000db783          	ld	a5,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204bfc:	6c94                	ld	a3,24(s1)
ffffffffc0204bfe:	2705                	addiw	a4,a4,1
ffffffffc0204c00:	d898                	sw	a4,48(s1)
    current->mm = mm;
ffffffffc0204c02:	f784                	sd	s1,40(a5)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204c04:	c0200737          	lui	a4,0xc0200
ffffffffc0204c08:	2ae6ec63          	bltu	a3,a4,ffffffffc0204ec0 <do_execve+0x46c>
ffffffffc0204c0c:	000b3703          	ld	a4,0(s6)
ffffffffc0204c10:	8e99                	sub	a3,a3,a4
ffffffffc0204c12:	00c6d713          	srli	a4,a3,0xc
ffffffffc0204c16:	f7d4                	sd	a3,168(a5)
ffffffffc0204c18:	56fd                	li	a3,-1
ffffffffc0204c1a:	16fe                	slli	a3,a3,0x3f
ffffffffc0204c1c:	8f55                	or	a4,a4,a3
ffffffffc0204c1e:	18071073          	csrw	satp,a4
    struct trapframe *tf = current->tf;
ffffffffc0204c22:	73d4                	ld	a3,160(a5)
    tf->epc = elf->e_entry;//epc设置为文件的入口地址
ffffffffc0204c24:	7702                	ld	a4,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c26:	0b478413          	addi	s0,a5,180
ffffffffc0204c2a:	4581                	li	a1,0
    tf->epc = elf->e_entry;//epc设置为文件的入口地址
ffffffffc0204c2c:	6f10                	ld	a2,24(a4)
    uintptr_t sstatus = tf->status;
ffffffffc0204c2e:	1006b703          	ld	a4,256(a3)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c32:	8522                	mv	a0,s0
    tf->epc = elf->e_entry;//epc设置为文件的入口地址
ffffffffc0204c34:	10c6b423          	sd	a2,264(a3)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204c38:	edf77793          	andi	a5,a4,-289
    tf->gpr.sp = USTACKTOP;//将sp设置为栈顶
ffffffffc0204c3c:	4705                	li	a4,1
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204c3e:	0207e793          	ori	a5,a5,32
    tf->gpr.sp = USTACKTOP;//将sp设置为栈顶
ffffffffc0204c42:	077e                	slli	a4,a4,0x1f
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c44:	4641                	li	a2,16
    tf->gpr.sp = USTACKTOP;//将sp设置为栈顶
ffffffffc0204c46:	ea98                	sd	a4,16(a3)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204c48:	10f6b023          	sd	a5,256(a3)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c4c:	485000ef          	jal	ra,ffffffffc02058d0 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204c50:	463d                	li	a2,15
ffffffffc0204c52:	180c                	addi	a1,sp,48
ffffffffc0204c54:	8522                	mv	a0,s0
ffffffffc0204c56:	48d000ef          	jal	ra,ffffffffc02058e2 <memcpy>
}
ffffffffc0204c5a:	70aa                	ld	ra,168(sp)
ffffffffc0204c5c:	740a                	ld	s0,160(sp)
ffffffffc0204c5e:	64ea                	ld	s1,152(sp)
ffffffffc0204c60:	69aa                	ld	s3,136(sp)
ffffffffc0204c62:	6a0a                	ld	s4,128(sp)
ffffffffc0204c64:	7ae6                	ld	s5,120(sp)
ffffffffc0204c66:	7b46                	ld	s6,112(sp)
ffffffffc0204c68:	7ba6                	ld	s7,104(sp)
ffffffffc0204c6a:	7c06                	ld	s8,96(sp)
ffffffffc0204c6c:	6ce6                	ld	s9,88(sp)
ffffffffc0204c6e:	6d46                	ld	s10,80(sp)
ffffffffc0204c70:	6da6                	ld	s11,72(sp)
ffffffffc0204c72:	854a                	mv	a0,s2
ffffffffc0204c74:	694a                	ld	s2,144(sp)
ffffffffc0204c76:	614d                	addi	sp,sp,176
ffffffffc0204c78:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204c7a:	463d                	li	a2,15
ffffffffc0204c7c:	85ca                	mv	a1,s2
ffffffffc0204c7e:	1808                	addi	a0,sp,48
ffffffffc0204c80:	463000ef          	jal	ra,ffffffffc02058e2 <memcpy>
    if (mm != NULL)
ffffffffc0204c84:	e20999e3          	bnez	s3,ffffffffc0204ab6 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204c88:	000db783          	ld	a5,0(s11)
ffffffffc0204c8c:	779c                	ld	a5,40(a5)
ffffffffc0204c8e:	e60780e3          	beqz	a5,ffffffffc0204aee <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204c92:	00003617          	auipc	a2,0x3
ffffffffc0204c96:	8f660613          	addi	a2,a2,-1802 # ffffffffc0207588 <default_pmm_manager+0xe28>
ffffffffc0204c9a:	25400593          	li	a1,596
ffffffffc0204c9e:	00002517          	auipc	a0,0x2
ffffffffc0204ca2:	72250513          	addi	a0,a0,1826 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204ca6:	fe8fb0ef          	jal	ra,ffffffffc020048e <__panic>
    put_pgdir(mm);
ffffffffc0204caa:	8526                	mv	a0,s1
ffffffffc0204cac:	c58ff0ef          	jal	ra,ffffffffc0204104 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204cb0:	8526                	mv	a0,s1
ffffffffc0204cb2:	d83fe0ef          	jal	ra,ffffffffc0203a34 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204cb6:	5961                	li	s2,-8
    do_exit(ret);
ffffffffc0204cb8:	854a                	mv	a0,s2
ffffffffc0204cba:	95bff0ef          	jal	ra,ffffffffc0204614 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204cbe:	5971                	li	s2,-4
ffffffffc0204cc0:	bfe5                	j	ffffffffc0204cb8 <do_execve+0x264>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204cc2:	0289b603          	ld	a2,40(s3)
ffffffffc0204cc6:	0209b783          	ld	a5,32(s3)
ffffffffc0204cca:	1cf66d63          	bltu	a2,a5,ffffffffc0204ea4 <do_execve+0x450>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204cce:	0049a783          	lw	a5,4(s3)
ffffffffc0204cd2:	0017f693          	andi	a3,a5,1
ffffffffc0204cd6:	c291                	beqz	a3,ffffffffc0204cda <do_execve+0x286>
            vm_flags |= VM_EXEC;
ffffffffc0204cd8:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204cda:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204cde:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204ce0:	e779                	bnez	a4,ffffffffc0204dae <do_execve+0x35a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204ce2:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ce4:	c781                	beqz	a5,ffffffffc0204cec <do_execve+0x298>
            vm_flags |= VM_READ;
ffffffffc0204ce6:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204cea:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204cec:	0026f793          	andi	a5,a3,2
ffffffffc0204cf0:	e3f1                	bnez	a5,ffffffffc0204db4 <do_execve+0x360>
        if (vm_flags & VM_EXEC)
ffffffffc0204cf2:	0046f793          	andi	a5,a3,4
ffffffffc0204cf6:	c399                	beqz	a5,ffffffffc0204cfc <do_execve+0x2a8>
            perm |= PTE_X;
ffffffffc0204cf8:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204cfc:	0109b583          	ld	a1,16(s3)
ffffffffc0204d00:	4701                	li	a4,0
ffffffffc0204d02:	8526                	mv	a0,s1
ffffffffc0204d04:	d83fe0ef          	jal	ra,ffffffffc0203a86 <mm_map>
ffffffffc0204d08:	892a                	mv	s2,a0
ffffffffc0204d0a:	ed35                	bnez	a0,ffffffffc0204d86 <do_execve+0x332>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204d0c:	0109ba83          	ld	s5,16(s3)
ffffffffc0204d10:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204d12:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204d16:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204d1a:	00fafbb3          	and	s7,s5,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204d1e:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204d20:	9a56                	add	s4,s4,s5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204d22:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204d24:	054ae963          	bltu	s5,s4,ffffffffc0204d76 <do_execve+0x322>
ffffffffc0204d28:	aa95                	j	ffffffffc0204e9c <do_execve+0x448>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204d2a:	6785                	lui	a5,0x1
ffffffffc0204d2c:	417a8533          	sub	a0,s5,s7
ffffffffc0204d30:	9bbe                	add	s7,s7,a5
ffffffffc0204d32:	415b8633          	sub	a2,s7,s5
            if (end < la)
ffffffffc0204d36:	017a7463          	bgeu	s4,s7,ffffffffc0204d3e <do_execve+0x2ea>
                size -= la - end;
ffffffffc0204d3a:	415a0633          	sub	a2,s4,s5
    return page - pages + nbase;
ffffffffc0204d3e:	000c3683          	ld	a3,0(s8)
ffffffffc0204d42:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204d44:	000cb583          	ld	a1,0(s9)
    return page - pages + nbase;
ffffffffc0204d48:	40d406b3          	sub	a3,s0,a3
ffffffffc0204d4c:	8699                	srai	a3,a3,0x6
ffffffffc0204d4e:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204d50:	67e2                	ld	a5,24(sp)
ffffffffc0204d52:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204d56:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204d58:	14b87863          	bgeu	a6,a1,ffffffffc0204ea8 <do_execve+0x454>
ffffffffc0204d5c:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204d60:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204d62:	9ab2                	add	s5,s5,a2
ffffffffc0204d64:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204d66:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204d68:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204d6a:	379000ef          	jal	ra,ffffffffc02058e2 <memcpy>
            start += size, from += size;
ffffffffc0204d6e:	6622                	ld	a2,8(sp)
ffffffffc0204d70:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204d72:	054af363          	bgeu	s5,s4,ffffffffc0204db8 <do_execve+0x364>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204d76:	6c88                	ld	a0,24(s1)
ffffffffc0204d78:	866a                	mv	a2,s10
ffffffffc0204d7a:	85de                	mv	a1,s7
ffffffffc0204d7c:	865fe0ef          	jal	ra,ffffffffc02035e0 <pgdir_alloc_page>
ffffffffc0204d80:	842a                	mv	s0,a0
ffffffffc0204d82:	f545                	bnez	a0,ffffffffc0204d2a <do_execve+0x2d6>
        ret = -E_NO_MEM;
ffffffffc0204d84:	5971                	li	s2,-4
    exit_mmap(mm);
ffffffffc0204d86:	8526                	mv	a0,s1
ffffffffc0204d88:	e49fe0ef          	jal	ra,ffffffffc0203bd0 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204d8c:	8526                	mv	a0,s1
ffffffffc0204d8e:	b76ff0ef          	jal	ra,ffffffffc0204104 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204d92:	8526                	mv	a0,s1
ffffffffc0204d94:	ca1fe0ef          	jal	ra,ffffffffc0203a34 <mm_destroy>
    return ret;
ffffffffc0204d98:	b705                	j	ffffffffc0204cb8 <do_execve+0x264>
            exit_mmap(mm);
ffffffffc0204d9a:	854e                	mv	a0,s3
ffffffffc0204d9c:	e35fe0ef          	jal	ra,ffffffffc0203bd0 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204da0:	854e                	mv	a0,s3
ffffffffc0204da2:	b62ff0ef          	jal	ra,ffffffffc0204104 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204da6:	854e                	mv	a0,s3
ffffffffc0204da8:	c8dfe0ef          	jal	ra,ffffffffc0203a34 <mm_destroy>
ffffffffc0204dac:	bb2d                	j	ffffffffc0204ae6 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204dae:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204db2:	fb95                	bnez	a5,ffffffffc0204ce6 <do_execve+0x292>
            perm |= (PTE_W | PTE_R);
ffffffffc0204db4:	4d5d                	li	s10,23
ffffffffc0204db6:	bf35                	j	ffffffffc0204cf2 <do_execve+0x29e>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204db8:	0109b683          	ld	a3,16(s3)
ffffffffc0204dbc:	0289b903          	ld	s2,40(s3)
ffffffffc0204dc0:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204dc2:	077afd63          	bgeu	s5,s7,ffffffffc0204e3c <do_execve+0x3e8>
            if (start == end)
ffffffffc0204dc6:	dd5907e3          	beq	s2,s5,ffffffffc0204b94 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204dca:	6785                	lui	a5,0x1
ffffffffc0204dcc:	00fa8533          	add	a0,s5,a5
ffffffffc0204dd0:	41750533          	sub	a0,a0,s7
                size -= la - end;
ffffffffc0204dd4:	41590a33          	sub	s4,s2,s5
            if (end < la)
ffffffffc0204dd8:	0b797d63          	bgeu	s2,s7,ffffffffc0204e92 <do_execve+0x43e>
    return page - pages + nbase;
ffffffffc0204ddc:	000c3683          	ld	a3,0(s8)
ffffffffc0204de0:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204de2:	000cb603          	ld	a2,0(s9)
    return page - pages + nbase;
ffffffffc0204de6:	40d406b3          	sub	a3,s0,a3
ffffffffc0204dea:	8699                	srai	a3,a3,0x6
ffffffffc0204dec:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204dee:	67e2                	ld	a5,24(sp)
ffffffffc0204df0:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204df4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204df6:	0ac5f963          	bgeu	a1,a2,ffffffffc0204ea8 <do_execve+0x454>
ffffffffc0204dfa:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204dfe:	8652                	mv	a2,s4
ffffffffc0204e00:	4581                	li	a1,0
ffffffffc0204e02:	96c2                	add	a3,a3,a6
ffffffffc0204e04:	9536                	add	a0,a0,a3
ffffffffc0204e06:	2cb000ef          	jal	ra,ffffffffc02058d0 <memset>
            start += size;
ffffffffc0204e0a:	015a0733          	add	a4,s4,s5
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204e0e:	03797463          	bgeu	s2,s7,ffffffffc0204e36 <do_execve+0x3e2>
ffffffffc0204e12:	d8e901e3          	beq	s2,a4,ffffffffc0204b94 <do_execve+0x140>
ffffffffc0204e16:	00002697          	auipc	a3,0x2
ffffffffc0204e1a:	79a68693          	addi	a3,a3,1946 # ffffffffc02075b0 <default_pmm_manager+0xe50>
ffffffffc0204e1e:	00001617          	auipc	a2,0x1
ffffffffc0204e22:	59260613          	addi	a2,a2,1426 # ffffffffc02063b0 <commands+0x848>
ffffffffc0204e26:	2bd00593          	li	a1,701
ffffffffc0204e2a:	00002517          	auipc	a0,0x2
ffffffffc0204e2e:	59650513          	addi	a0,a0,1430 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204e32:	e5cfb0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0204e36:	ff7710e3          	bne	a4,s7,ffffffffc0204e16 <do_execve+0x3c2>
ffffffffc0204e3a:	8ade                	mv	s5,s7
        while (start < end)
ffffffffc0204e3c:	d52afce3          	bgeu	s5,s2,ffffffffc0204b94 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204e40:	6c88                	ld	a0,24(s1)
ffffffffc0204e42:	866a                	mv	a2,s10
ffffffffc0204e44:	85de                	mv	a1,s7
ffffffffc0204e46:	f9afe0ef          	jal	ra,ffffffffc02035e0 <pgdir_alloc_page>
ffffffffc0204e4a:	842a                	mv	s0,a0
ffffffffc0204e4c:	dd05                	beqz	a0,ffffffffc0204d84 <do_execve+0x330>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204e4e:	6785                	lui	a5,0x1
ffffffffc0204e50:	417a8533          	sub	a0,s5,s7
ffffffffc0204e54:	9bbe                	add	s7,s7,a5
ffffffffc0204e56:	415b8633          	sub	a2,s7,s5
            if (end < la)
ffffffffc0204e5a:	01797463          	bgeu	s2,s7,ffffffffc0204e62 <do_execve+0x40e>
                size -= la - end;
ffffffffc0204e5e:	41590633          	sub	a2,s2,s5
    return page - pages + nbase;
ffffffffc0204e62:	000c3683          	ld	a3,0(s8)
ffffffffc0204e66:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204e68:	000cb583          	ld	a1,0(s9)
    return page - pages + nbase;
ffffffffc0204e6c:	40d406b3          	sub	a3,s0,a3
ffffffffc0204e70:	8699                	srai	a3,a3,0x6
ffffffffc0204e72:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204e74:	67e2                	ld	a5,24(sp)
ffffffffc0204e76:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204e7a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204e7c:	02b87663          	bgeu	a6,a1,ffffffffc0204ea8 <do_execve+0x454>
ffffffffc0204e80:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204e84:	4581                	li	a1,0
            start += size;
ffffffffc0204e86:	9ab2                	add	s5,s5,a2
ffffffffc0204e88:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204e8a:	9536                	add	a0,a0,a3
ffffffffc0204e8c:	245000ef          	jal	ra,ffffffffc02058d0 <memset>
ffffffffc0204e90:	b775                	j	ffffffffc0204e3c <do_execve+0x3e8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204e92:	415b8a33          	sub	s4,s7,s5
ffffffffc0204e96:	b799                	j	ffffffffc0204ddc <do_execve+0x388>
        return -E_INVAL;
ffffffffc0204e98:	5975                	li	s2,-3
ffffffffc0204e9a:	b3c1                	j	ffffffffc0204c5a <do_execve+0x206>
        while (start < end)
ffffffffc0204e9c:	86d6                	mv	a3,s5
ffffffffc0204e9e:	bf39                	j	ffffffffc0204dbc <do_execve+0x368>
    int ret = -E_NO_MEM;
ffffffffc0204ea0:	5971                	li	s2,-4
ffffffffc0204ea2:	bdc5                	j	ffffffffc0204d92 <do_execve+0x33e>
            ret = -E_INVAL_ELF;
ffffffffc0204ea4:	5961                	li	s2,-8
ffffffffc0204ea6:	b5c5                	j	ffffffffc0204d86 <do_execve+0x332>
ffffffffc0204ea8:	00002617          	auipc	a2,0x2
ffffffffc0204eac:	8f060613          	addi	a2,a2,-1808 # ffffffffc0206798 <default_pmm_manager+0x38>
ffffffffc0204eb0:	07100593          	li	a1,113
ffffffffc0204eb4:	00002517          	auipc	a0,0x2
ffffffffc0204eb8:	90c50513          	addi	a0,a0,-1780 # ffffffffc02067c0 <default_pmm_manager+0x60>
ffffffffc0204ebc:	dd2fb0ef          	jal	ra,ffffffffc020048e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204ec0:	00002617          	auipc	a2,0x2
ffffffffc0204ec4:	98060613          	addi	a2,a2,-1664 # ffffffffc0206840 <default_pmm_manager+0xe0>
ffffffffc0204ec8:	2dc00593          	li	a1,732
ffffffffc0204ecc:	00002517          	auipc	a0,0x2
ffffffffc0204ed0:	4f450513          	addi	a0,a0,1268 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204ed4:	dbafb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ed8:	00002697          	auipc	a3,0x2
ffffffffc0204edc:	7f068693          	addi	a3,a3,2032 # ffffffffc02076c8 <default_pmm_manager+0xf68>
ffffffffc0204ee0:	00001617          	auipc	a2,0x1
ffffffffc0204ee4:	4d060613          	addi	a2,a2,1232 # ffffffffc02063b0 <commands+0x848>
ffffffffc0204ee8:	2d700593          	li	a1,727
ffffffffc0204eec:	00002517          	auipc	a0,0x2
ffffffffc0204ef0:	4d450513          	addi	a0,a0,1236 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204ef4:	d9afb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ef8:	00002697          	auipc	a3,0x2
ffffffffc0204efc:	78868693          	addi	a3,a3,1928 # ffffffffc0207680 <default_pmm_manager+0xf20>
ffffffffc0204f00:	00001617          	auipc	a2,0x1
ffffffffc0204f04:	4b060613          	addi	a2,a2,1200 # ffffffffc02063b0 <commands+0x848>
ffffffffc0204f08:	2d600593          	li	a1,726
ffffffffc0204f0c:	00002517          	auipc	a0,0x2
ffffffffc0204f10:	4b450513          	addi	a0,a0,1204 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204f14:	d7afb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204f18:	00002697          	auipc	a3,0x2
ffffffffc0204f1c:	72068693          	addi	a3,a3,1824 # ffffffffc0207638 <default_pmm_manager+0xed8>
ffffffffc0204f20:	00001617          	auipc	a2,0x1
ffffffffc0204f24:	49060613          	addi	a2,a2,1168 # ffffffffc02063b0 <commands+0x848>
ffffffffc0204f28:	2d500593          	li	a1,725
ffffffffc0204f2c:	00002517          	auipc	a0,0x2
ffffffffc0204f30:	49450513          	addi	a0,a0,1172 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204f34:	d5afb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204f38:	00002697          	auipc	a3,0x2
ffffffffc0204f3c:	6b868693          	addi	a3,a3,1720 # ffffffffc02075f0 <default_pmm_manager+0xe90>
ffffffffc0204f40:	00001617          	auipc	a2,0x1
ffffffffc0204f44:	47060613          	addi	a2,a2,1136 # ffffffffc02063b0 <commands+0x848>
ffffffffc0204f48:	2d400593          	li	a1,724
ffffffffc0204f4c:	00002517          	auipc	a0,0x2
ffffffffc0204f50:	47450513          	addi	a0,a0,1140 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0204f54:	d3afb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204f58 <do_yield>:
    current->need_resched = 1;
ffffffffc0204f58:	000da797          	auipc	a5,0xda
ffffffffc0204f5c:	bd07b783          	ld	a5,-1072(a5) # ffffffffc02deb28 <current>
ffffffffc0204f60:	4705                	li	a4,1
ffffffffc0204f62:	ef98                	sd	a4,24(a5)
}
ffffffffc0204f64:	4501                	li	a0,0
ffffffffc0204f66:	8082                	ret

ffffffffc0204f68 <do_wait>:
{
ffffffffc0204f68:	1101                	addi	sp,sp,-32
ffffffffc0204f6a:	e822                	sd	s0,16(sp)
ffffffffc0204f6c:	e426                	sd	s1,8(sp)
ffffffffc0204f6e:	ec06                	sd	ra,24(sp)
ffffffffc0204f70:	842e                	mv	s0,a1
ffffffffc0204f72:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204f74:	c999                	beqz	a1,ffffffffc0204f8a <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204f76:	000da797          	auipc	a5,0xda
ffffffffc0204f7a:	bb27b783          	ld	a5,-1102(a5) # ffffffffc02deb28 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204f7e:	7788                	ld	a0,40(a5)
ffffffffc0204f80:	4685                	li	a3,1
ffffffffc0204f82:	4611                	li	a2,4
ffffffffc0204f84:	fe7fe0ef          	jal	ra,ffffffffc0203f6a <user_mem_check>
ffffffffc0204f88:	c909                	beqz	a0,ffffffffc0204f9a <do_wait+0x32>
ffffffffc0204f8a:	85a2                	mv	a1,s0
}
ffffffffc0204f8c:	6442                	ld	s0,16(sp)
ffffffffc0204f8e:	60e2                	ld	ra,24(sp)
ffffffffc0204f90:	8526                	mv	a0,s1
ffffffffc0204f92:	64a2                	ld	s1,8(sp)
ffffffffc0204f94:	6105                	addi	sp,sp,32
ffffffffc0204f96:	fc8ff06f          	j	ffffffffc020475e <do_wait.part.0>
ffffffffc0204f9a:	60e2                	ld	ra,24(sp)
ffffffffc0204f9c:	6442                	ld	s0,16(sp)
ffffffffc0204f9e:	64a2                	ld	s1,8(sp)
ffffffffc0204fa0:	5575                	li	a0,-3
ffffffffc0204fa2:	6105                	addi	sp,sp,32
ffffffffc0204fa4:	8082                	ret

ffffffffc0204fa6 <do_kill>:
{
ffffffffc0204fa6:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204fa8:	6789                	lui	a5,0x2
{
ffffffffc0204faa:	e406                	sd	ra,8(sp)
ffffffffc0204fac:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204fae:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204fb2:	17f9                	addi	a5,a5,-2
ffffffffc0204fb4:	02e7e963          	bltu	a5,a4,ffffffffc0204fe6 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204fb8:	842a                	mv	s0,a0
ffffffffc0204fba:	45a9                	li	a1,10
ffffffffc0204fbc:	2501                	sext.w	a0,a0
ffffffffc0204fbe:	46c000ef          	jal	ra,ffffffffc020542a <hash32>
ffffffffc0204fc2:	02051793          	slli	a5,a0,0x20
ffffffffc0204fc6:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204fca:	000d6797          	auipc	a5,0xd6
ffffffffc0204fce:	ade78793          	addi	a5,a5,-1314 # ffffffffc02daaa8 <hash_list>
ffffffffc0204fd2:	953e                	add	a0,a0,a5
ffffffffc0204fd4:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204fd6:	a029                	j	ffffffffc0204fe0 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204fd8:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204fdc:	00870b63          	beq	a4,s0,ffffffffc0204ff2 <do_kill+0x4c>
ffffffffc0204fe0:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204fe2:	fef51be3          	bne	a0,a5,ffffffffc0204fd8 <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204fe6:	5475                	li	s0,-3
}
ffffffffc0204fe8:	60a2                	ld	ra,8(sp)
ffffffffc0204fea:	8522                	mv	a0,s0
ffffffffc0204fec:	6402                	ld	s0,0(sp)
ffffffffc0204fee:	0141                	addi	sp,sp,16
ffffffffc0204ff0:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204ff2:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204ff6:	00177693          	andi	a3,a4,1
ffffffffc0204ffa:	e295                	bnez	a3,ffffffffc020501e <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204ffc:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204ffe:	00176713          	ori	a4,a4,1
ffffffffc0205002:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0205006:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0205008:	fe06d0e3          	bgez	a3,ffffffffc0204fe8 <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc020500c:	f2878513          	addi	a0,a5,-216
ffffffffc0205010:	22e000ef          	jal	ra,ffffffffc020523e <wakeup_proc>
}
ffffffffc0205014:	60a2                	ld	ra,8(sp)
ffffffffc0205016:	8522                	mv	a0,s0
ffffffffc0205018:	6402                	ld	s0,0(sp)
ffffffffc020501a:	0141                	addi	sp,sp,16
ffffffffc020501c:	8082                	ret
        return -E_KILLED;
ffffffffc020501e:	545d                	li	s0,-9
ffffffffc0205020:	b7e1                	j	ffffffffc0204fe8 <do_kill+0x42>

ffffffffc0205022 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0205022:	1101                	addi	sp,sp,-32
ffffffffc0205024:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0205026:	000da797          	auipc	a5,0xda
ffffffffc020502a:	a8278793          	addi	a5,a5,-1406 # ffffffffc02deaa8 <proc_list>
ffffffffc020502e:	ec06                	sd	ra,24(sp)
ffffffffc0205030:	e822                	sd	s0,16(sp)
ffffffffc0205032:	e04a                	sd	s2,0(sp)
ffffffffc0205034:	000d6497          	auipc	s1,0xd6
ffffffffc0205038:	a7448493          	addi	s1,s1,-1420 # ffffffffc02daaa8 <hash_list>
ffffffffc020503c:	e79c                	sd	a5,8(a5)
ffffffffc020503e:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0205040:	000da717          	auipc	a4,0xda
ffffffffc0205044:	a6870713          	addi	a4,a4,-1432 # ffffffffc02deaa8 <proc_list>
ffffffffc0205048:	87a6                	mv	a5,s1
ffffffffc020504a:	e79c                	sd	a5,8(a5)
ffffffffc020504c:	e39c                	sd	a5,0(a5)
ffffffffc020504e:	07c1                	addi	a5,a5,16
ffffffffc0205050:	fef71de3          	bne	a4,a5,ffffffffc020504a <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0205054:	fb3fe0ef          	jal	ra,ffffffffc0204006 <alloc_proc>
ffffffffc0205058:	000da917          	auipc	s2,0xda
ffffffffc020505c:	ad890913          	addi	s2,s2,-1320 # ffffffffc02deb30 <idleproc>
ffffffffc0205060:	00a93023          	sd	a0,0(s2)
ffffffffc0205064:	0e050f63          	beqz	a0,ffffffffc0205162 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0205068:	4789                	li	a5,2
ffffffffc020506a:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc020506c:	00003797          	auipc	a5,0x3
ffffffffc0205070:	f9478793          	addi	a5,a5,-108 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205074:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205078:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc020507a:	4785                	li	a5,1
ffffffffc020507c:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020507e:	4641                	li	a2,16
ffffffffc0205080:	4581                	li	a1,0
ffffffffc0205082:	8522                	mv	a0,s0
ffffffffc0205084:	04d000ef          	jal	ra,ffffffffc02058d0 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205088:	463d                	li	a2,15
ffffffffc020508a:	00002597          	auipc	a1,0x2
ffffffffc020508e:	69e58593          	addi	a1,a1,1694 # ffffffffc0207728 <default_pmm_manager+0xfc8>
ffffffffc0205092:	8522                	mv	a0,s0
ffffffffc0205094:	04f000ef          	jal	ra,ffffffffc02058e2 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0205098:	000da717          	auipc	a4,0xda
ffffffffc020509c:	aa870713          	addi	a4,a4,-1368 # ffffffffc02deb40 <nr_process>
ffffffffc02050a0:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc02050a2:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02050a6:	4601                	li	a2,0
    nr_process++;
ffffffffc02050a8:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02050aa:	4581                	li	a1,0
ffffffffc02050ac:	00000517          	auipc	a0,0x0
ffffffffc02050b0:	88450513          	addi	a0,a0,-1916 # ffffffffc0204930 <init_main>
    nr_process++;
ffffffffc02050b4:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc02050b6:	000da797          	auipc	a5,0xda
ffffffffc02050ba:	a6d7b923          	sd	a3,-1422(a5) # ffffffffc02deb28 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02050be:	d06ff0ef          	jal	ra,ffffffffc02045c4 <kernel_thread>
ffffffffc02050c2:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc02050c4:	08a05363          	blez	a0,ffffffffc020514a <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc02050c8:	6789                	lui	a5,0x2
ffffffffc02050ca:	fff5071b          	addiw	a4,a0,-1
ffffffffc02050ce:	17f9                	addi	a5,a5,-2
ffffffffc02050d0:	2501                	sext.w	a0,a0
ffffffffc02050d2:	02e7e363          	bltu	a5,a4,ffffffffc02050f8 <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02050d6:	45a9                	li	a1,10
ffffffffc02050d8:	352000ef          	jal	ra,ffffffffc020542a <hash32>
ffffffffc02050dc:	02051793          	slli	a5,a0,0x20
ffffffffc02050e0:	01c7d693          	srli	a3,a5,0x1c
ffffffffc02050e4:	96a6                	add	a3,a3,s1
ffffffffc02050e6:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc02050e8:	a029                	j	ffffffffc02050f2 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc02050ea:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c74>
ffffffffc02050ee:	04870b63          	beq	a4,s0,ffffffffc0205144 <proc_init+0x122>
    return listelm->next;
ffffffffc02050f2:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02050f4:	fef69be3          	bne	a3,a5,ffffffffc02050ea <proc_init+0xc8>
    return NULL;
ffffffffc02050f8:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02050fa:	0b478493          	addi	s1,a5,180
ffffffffc02050fe:	4641                	li	a2,16
ffffffffc0205100:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0205102:	000da417          	auipc	s0,0xda
ffffffffc0205106:	a3640413          	addi	s0,s0,-1482 # ffffffffc02deb38 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020510a:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc020510c:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020510e:	7c2000ef          	jal	ra,ffffffffc02058d0 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205112:	463d                	li	a2,15
ffffffffc0205114:	00002597          	auipc	a1,0x2
ffffffffc0205118:	63c58593          	addi	a1,a1,1596 # ffffffffc0207750 <default_pmm_manager+0xff0>
ffffffffc020511c:	8526                	mv	a0,s1
ffffffffc020511e:	7c4000ef          	jal	ra,ffffffffc02058e2 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205122:	00093783          	ld	a5,0(s2)
ffffffffc0205126:	cbb5                	beqz	a5,ffffffffc020519a <proc_init+0x178>
ffffffffc0205128:	43dc                	lw	a5,4(a5)
ffffffffc020512a:	eba5                	bnez	a5,ffffffffc020519a <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020512c:	601c                	ld	a5,0(s0)
ffffffffc020512e:	c7b1                	beqz	a5,ffffffffc020517a <proc_init+0x158>
ffffffffc0205130:	43d8                	lw	a4,4(a5)
ffffffffc0205132:	4785                	li	a5,1
ffffffffc0205134:	04f71363          	bne	a4,a5,ffffffffc020517a <proc_init+0x158>
}
ffffffffc0205138:	60e2                	ld	ra,24(sp)
ffffffffc020513a:	6442                	ld	s0,16(sp)
ffffffffc020513c:	64a2                	ld	s1,8(sp)
ffffffffc020513e:	6902                	ld	s2,0(sp)
ffffffffc0205140:	6105                	addi	sp,sp,32
ffffffffc0205142:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205144:	f2878793          	addi	a5,a5,-216
ffffffffc0205148:	bf4d                	j	ffffffffc02050fa <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc020514a:	00002617          	auipc	a2,0x2
ffffffffc020514e:	5e660613          	addi	a2,a2,1510 # ffffffffc0207730 <default_pmm_manager+0xfd0>
ffffffffc0205152:	3fd00593          	li	a1,1021
ffffffffc0205156:	00002517          	auipc	a0,0x2
ffffffffc020515a:	26a50513          	addi	a0,a0,618 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc020515e:	b30fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0205162:	00002617          	auipc	a2,0x2
ffffffffc0205166:	5ae60613          	addi	a2,a2,1454 # ffffffffc0207710 <default_pmm_manager+0xfb0>
ffffffffc020516a:	3ee00593          	li	a1,1006
ffffffffc020516e:	00002517          	auipc	a0,0x2
ffffffffc0205172:	25250513          	addi	a0,a0,594 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0205176:	b18fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020517a:	00002697          	auipc	a3,0x2
ffffffffc020517e:	60668693          	addi	a3,a3,1542 # ffffffffc0207780 <default_pmm_manager+0x1020>
ffffffffc0205182:	00001617          	auipc	a2,0x1
ffffffffc0205186:	22e60613          	addi	a2,a2,558 # ffffffffc02063b0 <commands+0x848>
ffffffffc020518a:	40400593          	li	a1,1028
ffffffffc020518e:	00002517          	auipc	a0,0x2
ffffffffc0205192:	23250513          	addi	a0,a0,562 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc0205196:	af8fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020519a:	00002697          	auipc	a3,0x2
ffffffffc020519e:	5be68693          	addi	a3,a3,1470 # ffffffffc0207758 <default_pmm_manager+0xff8>
ffffffffc02051a2:	00001617          	auipc	a2,0x1
ffffffffc02051a6:	20e60613          	addi	a2,a2,526 # ffffffffc02063b0 <commands+0x848>
ffffffffc02051aa:	40300593          	li	a1,1027
ffffffffc02051ae:	00002517          	auipc	a0,0x2
ffffffffc02051b2:	21250513          	addi	a0,a0,530 # ffffffffc02073c0 <default_pmm_manager+0xc60>
ffffffffc02051b6:	ad8fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02051ba <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02051ba:	1141                	addi	sp,sp,-16
ffffffffc02051bc:	e022                	sd	s0,0(sp)
ffffffffc02051be:	e406                	sd	ra,8(sp)
ffffffffc02051c0:	000da417          	auipc	s0,0xda
ffffffffc02051c4:	96840413          	addi	s0,s0,-1688 # ffffffffc02deb28 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02051c8:	6018                	ld	a4,0(s0)
ffffffffc02051ca:	6f1c                	ld	a5,24(a4)
ffffffffc02051cc:	dffd                	beqz	a5,ffffffffc02051ca <cpu_idle+0x10>
        {
            schedule();
ffffffffc02051ce:	0f0000ef          	jal	ra,ffffffffc02052be <schedule>
ffffffffc02051d2:	bfdd                	j	ffffffffc02051c8 <cpu_idle+0xe>

ffffffffc02051d4 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc02051d4:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc02051d8:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc02051dc:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc02051de:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc02051e0:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc02051e4:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc02051e8:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc02051ec:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc02051f0:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc02051f4:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc02051f8:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc02051fc:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0205200:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0205204:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205208:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc020520c:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0205210:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0205212:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0205214:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205218:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc020521c:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0205220:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205224:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205228:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc020522c:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205230:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205234:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205238:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc020523c:	8082                	ret

ffffffffc020523e <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020523e:	4118                	lw	a4,0(a0)
{
ffffffffc0205240:	1101                	addi	sp,sp,-32
ffffffffc0205242:	ec06                	sd	ra,24(sp)
ffffffffc0205244:	e822                	sd	s0,16(sp)
ffffffffc0205246:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205248:	478d                	li	a5,3
ffffffffc020524a:	04f70b63          	beq	a4,a5,ffffffffc02052a0 <wakeup_proc+0x62>
ffffffffc020524e:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205250:	100027f3          	csrr	a5,sstatus
ffffffffc0205254:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205256:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205258:	ef9d                	bnez	a5,ffffffffc0205296 <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc020525a:	4789                	li	a5,2
ffffffffc020525c:	02f70163          	beq	a4,a5,ffffffffc020527e <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc0205260:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc0205262:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc0205266:	e491                	bnez	s1,ffffffffc0205272 <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205268:	60e2                	ld	ra,24(sp)
ffffffffc020526a:	6442                	ld	s0,16(sp)
ffffffffc020526c:	64a2                	ld	s1,8(sp)
ffffffffc020526e:	6105                	addi	sp,sp,32
ffffffffc0205270:	8082                	ret
ffffffffc0205272:	6442                	ld	s0,16(sp)
ffffffffc0205274:	60e2                	ld	ra,24(sp)
ffffffffc0205276:	64a2                	ld	s1,8(sp)
ffffffffc0205278:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020527a:	f34fb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc020527e:	00002617          	auipc	a2,0x2
ffffffffc0205282:	56260613          	addi	a2,a2,1378 # ffffffffc02077e0 <default_pmm_manager+0x1080>
ffffffffc0205286:	45d1                	li	a1,20
ffffffffc0205288:	00002517          	auipc	a0,0x2
ffffffffc020528c:	54050513          	addi	a0,a0,1344 # ffffffffc02077c8 <default_pmm_manager+0x1068>
ffffffffc0205290:	a66fb0ef          	jal	ra,ffffffffc02004f6 <__warn>
ffffffffc0205294:	bfc9                	j	ffffffffc0205266 <wakeup_proc+0x28>
        intr_disable();
ffffffffc0205296:	f1efb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc020529a:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc020529c:	4485                	li	s1,1
ffffffffc020529e:	bf75                	j	ffffffffc020525a <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02052a0:	00002697          	auipc	a3,0x2
ffffffffc02052a4:	50868693          	addi	a3,a3,1288 # ffffffffc02077a8 <default_pmm_manager+0x1048>
ffffffffc02052a8:	00001617          	auipc	a2,0x1
ffffffffc02052ac:	10860613          	addi	a2,a2,264 # ffffffffc02063b0 <commands+0x848>
ffffffffc02052b0:	45a5                	li	a1,9
ffffffffc02052b2:	00002517          	auipc	a0,0x2
ffffffffc02052b6:	51650513          	addi	a0,a0,1302 # ffffffffc02077c8 <default_pmm_manager+0x1068>
ffffffffc02052ba:	9d4fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02052be <schedule>:

void schedule(void)
{
ffffffffc02052be:	1141                	addi	sp,sp,-16
ffffffffc02052c0:	e406                	sd	ra,8(sp)
ffffffffc02052c2:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02052c4:	100027f3          	csrr	a5,sstatus
ffffffffc02052c8:	8b89                	andi	a5,a5,2
ffffffffc02052ca:	4401                	li	s0,0
ffffffffc02052cc:	efbd                	bnez	a5,ffffffffc020534a <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc02052ce:	000da897          	auipc	a7,0xda
ffffffffc02052d2:	85a8b883          	ld	a7,-1958(a7) # ffffffffc02deb28 <current>
ffffffffc02052d6:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02052da:	000da517          	auipc	a0,0xda
ffffffffc02052de:	85653503          	ld	a0,-1962(a0) # ffffffffc02deb30 <idleproc>
ffffffffc02052e2:	04a88e63          	beq	a7,a0,ffffffffc020533e <schedule+0x80>
ffffffffc02052e6:	0c888693          	addi	a3,a7,200
ffffffffc02052ea:	000d9617          	auipc	a2,0xd9
ffffffffc02052ee:	7be60613          	addi	a2,a2,1982 # ffffffffc02deaa8 <proc_list>
        le = last;
ffffffffc02052f2:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc02052f4:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc02052f6:	4809                	li	a6,2
ffffffffc02052f8:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc02052fa:	00c78863          	beq	a5,a2,ffffffffc020530a <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc02052fe:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0205302:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc0205306:	03070163          	beq	a4,a6,ffffffffc0205328 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc020530a:	fef697e3          	bne	a3,a5,ffffffffc02052f8 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc020530e:	ed89                	bnez	a1,ffffffffc0205328 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc0205310:	451c                	lw	a5,8(a0)
ffffffffc0205312:	2785                	addiw	a5,a5,1
ffffffffc0205314:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc0205316:	00a88463          	beq	a7,a0,ffffffffc020531e <schedule+0x60>
        {
            proc_run(next);
ffffffffc020531a:	e61fe0ef          	jal	ra,ffffffffc020417a <proc_run>
    if (flag)
ffffffffc020531e:	e819                	bnez	s0,ffffffffc0205334 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205320:	60a2                	ld	ra,8(sp)
ffffffffc0205322:	6402                	ld	s0,0(sp)
ffffffffc0205324:	0141                	addi	sp,sp,16
ffffffffc0205326:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205328:	4198                	lw	a4,0(a1)
ffffffffc020532a:	4789                	li	a5,2
ffffffffc020532c:	fef712e3          	bne	a4,a5,ffffffffc0205310 <schedule+0x52>
ffffffffc0205330:	852e                	mv	a0,a1
ffffffffc0205332:	bff9                	j	ffffffffc0205310 <schedule+0x52>
}
ffffffffc0205334:	6402                	ld	s0,0(sp)
ffffffffc0205336:	60a2                	ld	ra,8(sp)
ffffffffc0205338:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc020533a:	e74fb06f          	j	ffffffffc02009ae <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020533e:	000d9617          	auipc	a2,0xd9
ffffffffc0205342:	76a60613          	addi	a2,a2,1898 # ffffffffc02deaa8 <proc_list>
ffffffffc0205346:	86b2                	mv	a3,a2
ffffffffc0205348:	b76d                	j	ffffffffc02052f2 <schedule+0x34>
        intr_disable();
ffffffffc020534a:	e6afb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020534e:	4405                	li	s0,1
ffffffffc0205350:	bfbd                	j	ffffffffc02052ce <schedule+0x10>

ffffffffc0205352 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0205352:	000d9797          	auipc	a5,0xd9
ffffffffc0205356:	7d67b783          	ld	a5,2006(a5) # ffffffffc02deb28 <current>
}
ffffffffc020535a:	43c8                	lw	a0,4(a5)
ffffffffc020535c:	8082                	ret

ffffffffc020535e <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc020535e:	4501                	li	a0,0
ffffffffc0205360:	8082                	ret

ffffffffc0205362 <sys_putc>:
    cputchar(c);
ffffffffc0205362:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205364:	1141                	addi	sp,sp,-16
ffffffffc0205366:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205368:	e63fa0ef          	jal	ra,ffffffffc02001ca <cputchar>
}
ffffffffc020536c:	60a2                	ld	ra,8(sp)
ffffffffc020536e:	4501                	li	a0,0
ffffffffc0205370:	0141                	addi	sp,sp,16
ffffffffc0205372:	8082                	ret

ffffffffc0205374 <sys_kill>:
    return do_kill(pid);
ffffffffc0205374:	4108                	lw	a0,0(a0)
ffffffffc0205376:	c31ff06f          	j	ffffffffc0204fa6 <do_kill>

ffffffffc020537a <sys_yield>:
    return do_yield();
ffffffffc020537a:	bdfff06f          	j	ffffffffc0204f58 <do_yield>

ffffffffc020537e <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc020537e:	6d14                	ld	a3,24(a0)
ffffffffc0205380:	6910                	ld	a2,16(a0)
ffffffffc0205382:	650c                	ld	a1,8(a0)
ffffffffc0205384:	6108                	ld	a0,0(a0)
ffffffffc0205386:	eceff06f          	j	ffffffffc0204a54 <do_execve>

ffffffffc020538a <sys_wait>:
    return do_wait(pid, store);
ffffffffc020538a:	650c                	ld	a1,8(a0)
ffffffffc020538c:	4108                	lw	a0,0(a0)
ffffffffc020538e:	bdbff06f          	j	ffffffffc0204f68 <do_wait>

ffffffffc0205392 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205392:	000d9797          	auipc	a5,0xd9
ffffffffc0205396:	7967b783          	ld	a5,1942(a5) # ffffffffc02deb28 <current>
ffffffffc020539a:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020539c:	4501                	li	a0,0
ffffffffc020539e:	6a0c                	ld	a1,16(a2)
ffffffffc02053a0:	e47fe06f          	j	ffffffffc02041e6 <do_fork>

ffffffffc02053a4 <sys_exit>:
    return do_exit(error_code);
ffffffffc02053a4:	4108                	lw	a0,0(a0)
ffffffffc02053a6:	a6eff06f          	j	ffffffffc0204614 <do_exit>

ffffffffc02053aa <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc02053aa:	715d                	addi	sp,sp,-80
ffffffffc02053ac:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc02053ae:	000d9497          	auipc	s1,0xd9
ffffffffc02053b2:	77a48493          	addi	s1,s1,1914 # ffffffffc02deb28 <current>
ffffffffc02053b6:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc02053b8:	e0a2                	sd	s0,64(sp)
ffffffffc02053ba:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc02053bc:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc02053be:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02053c0:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc02053c2:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02053c6:	0327ee63          	bltu	a5,s2,ffffffffc0205402 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc02053ca:	00391713          	slli	a4,s2,0x3
ffffffffc02053ce:	00002797          	auipc	a5,0x2
ffffffffc02053d2:	47a78793          	addi	a5,a5,1146 # ffffffffc0207848 <syscalls>
ffffffffc02053d6:	97ba                	add	a5,a5,a4
ffffffffc02053d8:	639c                	ld	a5,0(a5)
ffffffffc02053da:	c785                	beqz	a5,ffffffffc0205402 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc02053dc:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02053de:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02053e0:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02053e2:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02053e4:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02053e6:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02053e8:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02053ea:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02053ec:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02053ee:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02053f0:	0028                	addi	a0,sp,8
ffffffffc02053f2:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02053f4:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02053f6:	e828                	sd	a0,80(s0)
}
ffffffffc02053f8:	6406                	ld	s0,64(sp)
ffffffffc02053fa:	74e2                	ld	s1,56(sp)
ffffffffc02053fc:	7942                	ld	s2,48(sp)
ffffffffc02053fe:	6161                	addi	sp,sp,80
ffffffffc0205400:	8082                	ret
    print_trapframe(tf);
ffffffffc0205402:	8522                	mv	a0,s0
ffffffffc0205404:	fa0fb0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205408:	609c                	ld	a5,0(s1)
ffffffffc020540a:	86ca                	mv	a3,s2
ffffffffc020540c:	00002617          	auipc	a2,0x2
ffffffffc0205410:	3f460613          	addi	a2,a2,1012 # ffffffffc0207800 <default_pmm_manager+0x10a0>
ffffffffc0205414:	43d8                	lw	a4,4(a5)
ffffffffc0205416:	06200593          	li	a1,98
ffffffffc020541a:	0b478793          	addi	a5,a5,180
ffffffffc020541e:	00002517          	auipc	a0,0x2
ffffffffc0205422:	41250513          	addi	a0,a0,1042 # ffffffffc0207830 <default_pmm_manager+0x10d0>
ffffffffc0205426:	868fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020542a <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc020542a:	9e3707b7          	lui	a5,0x9e370
ffffffffc020542e:	2785                	addiw	a5,a5,1
ffffffffc0205430:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205434:	02000793          	li	a5,32
ffffffffc0205438:	9f8d                	subw	a5,a5,a1
}
ffffffffc020543a:	00f5553b          	srlw	a0,a0,a5
ffffffffc020543e:	8082                	ret

ffffffffc0205440 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205440:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205444:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0205446:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020544a:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020544c:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205450:	f022                	sd	s0,32(sp)
ffffffffc0205452:	ec26                	sd	s1,24(sp)
ffffffffc0205454:	e84a                	sd	s2,16(sp)
ffffffffc0205456:	f406                	sd	ra,40(sp)
ffffffffc0205458:	e44e                	sd	s3,8(sp)
ffffffffc020545a:	84aa                	mv	s1,a0
ffffffffc020545c:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020545e:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0205462:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0205464:	03067e63          	bgeu	a2,a6,ffffffffc02054a0 <printnum+0x60>
ffffffffc0205468:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020546a:	00805763          	blez	s0,ffffffffc0205478 <printnum+0x38>
ffffffffc020546e:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205470:	85ca                	mv	a1,s2
ffffffffc0205472:	854e                	mv	a0,s3
ffffffffc0205474:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205476:	fc65                	bnez	s0,ffffffffc020546e <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205478:	1a02                	slli	s4,s4,0x20
ffffffffc020547a:	00002797          	auipc	a5,0x2
ffffffffc020547e:	4ce78793          	addi	a5,a5,1230 # ffffffffc0207948 <syscalls+0x100>
ffffffffc0205482:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205486:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205488:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020548a:	000a4503          	lbu	a0,0(s4)
}
ffffffffc020548e:	70a2                	ld	ra,40(sp)
ffffffffc0205490:	69a2                	ld	s3,8(sp)
ffffffffc0205492:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205494:	85ca                	mv	a1,s2
ffffffffc0205496:	87a6                	mv	a5,s1
}
ffffffffc0205498:	6942                	ld	s2,16(sp)
ffffffffc020549a:	64e2                	ld	s1,24(sp)
ffffffffc020549c:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020549e:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02054a0:	03065633          	divu	a2,a2,a6
ffffffffc02054a4:	8722                	mv	a4,s0
ffffffffc02054a6:	f9bff0ef          	jal	ra,ffffffffc0205440 <printnum>
ffffffffc02054aa:	b7f9                	j	ffffffffc0205478 <printnum+0x38>

ffffffffc02054ac <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02054ac:	7119                	addi	sp,sp,-128
ffffffffc02054ae:	f4a6                	sd	s1,104(sp)
ffffffffc02054b0:	f0ca                	sd	s2,96(sp)
ffffffffc02054b2:	ecce                	sd	s3,88(sp)
ffffffffc02054b4:	e8d2                	sd	s4,80(sp)
ffffffffc02054b6:	e4d6                	sd	s5,72(sp)
ffffffffc02054b8:	e0da                	sd	s6,64(sp)
ffffffffc02054ba:	fc5e                	sd	s7,56(sp)
ffffffffc02054bc:	f06a                	sd	s10,32(sp)
ffffffffc02054be:	fc86                	sd	ra,120(sp)
ffffffffc02054c0:	f8a2                	sd	s0,112(sp)
ffffffffc02054c2:	f862                	sd	s8,48(sp)
ffffffffc02054c4:	f466                	sd	s9,40(sp)
ffffffffc02054c6:	ec6e                	sd	s11,24(sp)
ffffffffc02054c8:	892a                	mv	s2,a0
ffffffffc02054ca:	84ae                	mv	s1,a1
ffffffffc02054cc:	8d32                	mv	s10,a2
ffffffffc02054ce:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054d0:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02054d4:	5b7d                	li	s6,-1
ffffffffc02054d6:	00002a97          	auipc	s5,0x2
ffffffffc02054da:	49ea8a93          	addi	s5,s5,1182 # ffffffffc0207974 <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02054de:	00002b97          	auipc	s7,0x2
ffffffffc02054e2:	6b2b8b93          	addi	s7,s7,1714 # ffffffffc0207b90 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054e6:	000d4503          	lbu	a0,0(s10)
ffffffffc02054ea:	001d0413          	addi	s0,s10,1
ffffffffc02054ee:	01350a63          	beq	a0,s3,ffffffffc0205502 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02054f2:	c121                	beqz	a0,ffffffffc0205532 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02054f4:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054f6:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02054f8:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054fa:	fff44503          	lbu	a0,-1(s0)
ffffffffc02054fe:	ff351ae3          	bne	a0,s3,ffffffffc02054f2 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205502:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0205506:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc020550a:	4c81                	li	s9,0
ffffffffc020550c:	4881                	li	a7,0
        width = precision = -1;
ffffffffc020550e:	5c7d                	li	s8,-1
ffffffffc0205510:	5dfd                	li	s11,-1
ffffffffc0205512:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0205516:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205518:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020551c:	0ff5f593          	zext.b	a1,a1
ffffffffc0205520:	00140d13          	addi	s10,s0,1
ffffffffc0205524:	04b56263          	bltu	a0,a1,ffffffffc0205568 <vprintfmt+0xbc>
ffffffffc0205528:	058a                	slli	a1,a1,0x2
ffffffffc020552a:	95d6                	add	a1,a1,s5
ffffffffc020552c:	4194                	lw	a3,0(a1)
ffffffffc020552e:	96d6                	add	a3,a3,s5
ffffffffc0205530:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205532:	70e6                	ld	ra,120(sp)
ffffffffc0205534:	7446                	ld	s0,112(sp)
ffffffffc0205536:	74a6                	ld	s1,104(sp)
ffffffffc0205538:	7906                	ld	s2,96(sp)
ffffffffc020553a:	69e6                	ld	s3,88(sp)
ffffffffc020553c:	6a46                	ld	s4,80(sp)
ffffffffc020553e:	6aa6                	ld	s5,72(sp)
ffffffffc0205540:	6b06                	ld	s6,64(sp)
ffffffffc0205542:	7be2                	ld	s7,56(sp)
ffffffffc0205544:	7c42                	ld	s8,48(sp)
ffffffffc0205546:	7ca2                	ld	s9,40(sp)
ffffffffc0205548:	7d02                	ld	s10,32(sp)
ffffffffc020554a:	6de2                	ld	s11,24(sp)
ffffffffc020554c:	6109                	addi	sp,sp,128
ffffffffc020554e:	8082                	ret
            padc = '0';
ffffffffc0205550:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0205552:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205556:	846a                	mv	s0,s10
ffffffffc0205558:	00140d13          	addi	s10,s0,1
ffffffffc020555c:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205560:	0ff5f593          	zext.b	a1,a1
ffffffffc0205564:	fcb572e3          	bgeu	a0,a1,ffffffffc0205528 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0205568:	85a6                	mv	a1,s1
ffffffffc020556a:	02500513          	li	a0,37
ffffffffc020556e:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205570:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205574:	8d22                	mv	s10,s0
ffffffffc0205576:	f73788e3          	beq	a5,s3,ffffffffc02054e6 <vprintfmt+0x3a>
ffffffffc020557a:	ffed4783          	lbu	a5,-2(s10)
ffffffffc020557e:	1d7d                	addi	s10,s10,-1
ffffffffc0205580:	ff379de3          	bne	a5,s3,ffffffffc020557a <vprintfmt+0xce>
ffffffffc0205584:	b78d                	j	ffffffffc02054e6 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0205586:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020558a:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020558e:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0205590:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0205594:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205598:	02d86463          	bltu	a6,a3,ffffffffc02055c0 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc020559c:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02055a0:	002c169b          	slliw	a3,s8,0x2
ffffffffc02055a4:	0186873b          	addw	a4,a3,s8
ffffffffc02055a8:	0017171b          	slliw	a4,a4,0x1
ffffffffc02055ac:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02055ae:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02055b2:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02055b4:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02055b8:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02055bc:	fed870e3          	bgeu	a6,a3,ffffffffc020559c <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02055c0:	f40ddce3          	bgez	s11,ffffffffc0205518 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02055c4:	8de2                	mv	s11,s8
ffffffffc02055c6:	5c7d                	li	s8,-1
ffffffffc02055c8:	bf81                	j	ffffffffc0205518 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02055ca:	fffdc693          	not	a3,s11
ffffffffc02055ce:	96fd                	srai	a3,a3,0x3f
ffffffffc02055d0:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055d4:	00144603          	lbu	a2,1(s0)
ffffffffc02055d8:	2d81                	sext.w	s11,s11
ffffffffc02055da:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02055dc:	bf35                	j	ffffffffc0205518 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02055de:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055e2:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02055e6:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055e8:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02055ea:	bfd9                	j	ffffffffc02055c0 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02055ec:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02055ee:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02055f2:	01174463          	blt	a4,a7,ffffffffc02055fa <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02055f6:	1a088e63          	beqz	a7,ffffffffc02057b2 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02055fa:	000a3603          	ld	a2,0(s4)
ffffffffc02055fe:	46c1                	li	a3,16
ffffffffc0205600:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205602:	2781                	sext.w	a5,a5
ffffffffc0205604:	876e                	mv	a4,s11
ffffffffc0205606:	85a6                	mv	a1,s1
ffffffffc0205608:	854a                	mv	a0,s2
ffffffffc020560a:	e37ff0ef          	jal	ra,ffffffffc0205440 <printnum>
            break;
ffffffffc020560e:	bde1                	j	ffffffffc02054e6 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0205610:	000a2503          	lw	a0,0(s4)
ffffffffc0205614:	85a6                	mv	a1,s1
ffffffffc0205616:	0a21                	addi	s4,s4,8
ffffffffc0205618:	9902                	jalr	s2
            break;
ffffffffc020561a:	b5f1                	j	ffffffffc02054e6 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020561c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020561e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205622:	01174463          	blt	a4,a7,ffffffffc020562a <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0205626:	18088163          	beqz	a7,ffffffffc02057a8 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020562a:	000a3603          	ld	a2,0(s4)
ffffffffc020562e:	46a9                	li	a3,10
ffffffffc0205630:	8a2e                	mv	s4,a1
ffffffffc0205632:	bfc1                	j	ffffffffc0205602 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205634:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0205638:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020563a:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020563c:	bdf1                	j	ffffffffc0205518 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc020563e:	85a6                	mv	a1,s1
ffffffffc0205640:	02500513          	li	a0,37
ffffffffc0205644:	9902                	jalr	s2
            break;
ffffffffc0205646:	b545                	j	ffffffffc02054e6 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205648:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc020564c:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020564e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205650:	b5e1                	j	ffffffffc0205518 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0205652:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205654:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205658:	01174463          	blt	a4,a7,ffffffffc0205660 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc020565c:	14088163          	beqz	a7,ffffffffc020579e <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0205660:	000a3603          	ld	a2,0(s4)
ffffffffc0205664:	46a1                	li	a3,8
ffffffffc0205666:	8a2e                	mv	s4,a1
ffffffffc0205668:	bf69                	j	ffffffffc0205602 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020566a:	03000513          	li	a0,48
ffffffffc020566e:	85a6                	mv	a1,s1
ffffffffc0205670:	e03e                	sd	a5,0(sp)
ffffffffc0205672:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0205674:	85a6                	mv	a1,s1
ffffffffc0205676:	07800513          	li	a0,120
ffffffffc020567a:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020567c:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020567e:	6782                	ld	a5,0(sp)
ffffffffc0205680:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205682:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0205686:	bfb5                	j	ffffffffc0205602 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205688:	000a3403          	ld	s0,0(s4)
ffffffffc020568c:	008a0713          	addi	a4,s4,8
ffffffffc0205690:	e03a                	sd	a4,0(sp)
ffffffffc0205692:	14040263          	beqz	s0,ffffffffc02057d6 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0205696:	0fb05763          	blez	s11,ffffffffc0205784 <vprintfmt+0x2d8>
ffffffffc020569a:	02d00693          	li	a3,45
ffffffffc020569e:	0cd79163          	bne	a5,a3,ffffffffc0205760 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056a2:	00044783          	lbu	a5,0(s0)
ffffffffc02056a6:	0007851b          	sext.w	a0,a5
ffffffffc02056aa:	cf85                	beqz	a5,ffffffffc02056e2 <vprintfmt+0x236>
ffffffffc02056ac:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02056b0:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056b4:	000c4563          	bltz	s8,ffffffffc02056be <vprintfmt+0x212>
ffffffffc02056b8:	3c7d                	addiw	s8,s8,-1
ffffffffc02056ba:	036c0263          	beq	s8,s6,ffffffffc02056de <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02056be:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02056c0:	0e0c8e63          	beqz	s9,ffffffffc02057bc <vprintfmt+0x310>
ffffffffc02056c4:	3781                	addiw	a5,a5,-32
ffffffffc02056c6:	0ef47b63          	bgeu	s0,a5,ffffffffc02057bc <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02056ca:	03f00513          	li	a0,63
ffffffffc02056ce:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056d0:	000a4783          	lbu	a5,0(s4)
ffffffffc02056d4:	3dfd                	addiw	s11,s11,-1
ffffffffc02056d6:	0a05                	addi	s4,s4,1
ffffffffc02056d8:	0007851b          	sext.w	a0,a5
ffffffffc02056dc:	ffe1                	bnez	a5,ffffffffc02056b4 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02056de:	01b05963          	blez	s11,ffffffffc02056f0 <vprintfmt+0x244>
ffffffffc02056e2:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02056e4:	85a6                	mv	a1,s1
ffffffffc02056e6:	02000513          	li	a0,32
ffffffffc02056ea:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02056ec:	fe0d9be3          	bnez	s11,ffffffffc02056e2 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02056f0:	6a02                	ld	s4,0(sp)
ffffffffc02056f2:	bbd5                	j	ffffffffc02054e6 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02056f4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02056f6:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02056fa:	01174463          	blt	a4,a7,ffffffffc0205702 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02056fe:	08088d63          	beqz	a7,ffffffffc0205798 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0205702:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205706:	0a044d63          	bltz	s0,ffffffffc02057c0 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc020570a:	8622                	mv	a2,s0
ffffffffc020570c:	8a66                	mv	s4,s9
ffffffffc020570e:	46a9                	li	a3,10
ffffffffc0205710:	bdcd                	j	ffffffffc0205602 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0205712:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205716:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0205718:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020571a:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020571e:	8fb5                	xor	a5,a5,a3
ffffffffc0205720:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205724:	02d74163          	blt	a4,a3,ffffffffc0205746 <vprintfmt+0x29a>
ffffffffc0205728:	00369793          	slli	a5,a3,0x3
ffffffffc020572c:	97de                	add	a5,a5,s7
ffffffffc020572e:	639c                	ld	a5,0(a5)
ffffffffc0205730:	cb99                	beqz	a5,ffffffffc0205746 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205732:	86be                	mv	a3,a5
ffffffffc0205734:	00000617          	auipc	a2,0x0
ffffffffc0205738:	1f460613          	addi	a2,a2,500 # ffffffffc0205928 <etext+0x2e>
ffffffffc020573c:	85a6                	mv	a1,s1
ffffffffc020573e:	854a                	mv	a0,s2
ffffffffc0205740:	0ce000ef          	jal	ra,ffffffffc020580e <printfmt>
ffffffffc0205744:	b34d                	j	ffffffffc02054e6 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205746:	00002617          	auipc	a2,0x2
ffffffffc020574a:	22260613          	addi	a2,a2,546 # ffffffffc0207968 <syscalls+0x120>
ffffffffc020574e:	85a6                	mv	a1,s1
ffffffffc0205750:	854a                	mv	a0,s2
ffffffffc0205752:	0bc000ef          	jal	ra,ffffffffc020580e <printfmt>
ffffffffc0205756:	bb41                	j	ffffffffc02054e6 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0205758:	00002417          	auipc	s0,0x2
ffffffffc020575c:	20840413          	addi	s0,s0,520 # ffffffffc0207960 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205760:	85e2                	mv	a1,s8
ffffffffc0205762:	8522                	mv	a0,s0
ffffffffc0205764:	e43e                	sd	a5,8(sp)
ffffffffc0205766:	0e2000ef          	jal	ra,ffffffffc0205848 <strnlen>
ffffffffc020576a:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020576e:	01b05b63          	blez	s11,ffffffffc0205784 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0205772:	67a2                	ld	a5,8(sp)
ffffffffc0205774:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205778:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020577a:	85a6                	mv	a1,s1
ffffffffc020577c:	8552                	mv	a0,s4
ffffffffc020577e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205780:	fe0d9ce3          	bnez	s11,ffffffffc0205778 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205784:	00044783          	lbu	a5,0(s0)
ffffffffc0205788:	00140a13          	addi	s4,s0,1
ffffffffc020578c:	0007851b          	sext.w	a0,a5
ffffffffc0205790:	d3a5                	beqz	a5,ffffffffc02056f0 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205792:	05e00413          	li	s0,94
ffffffffc0205796:	bf39                	j	ffffffffc02056b4 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0205798:	000a2403          	lw	s0,0(s4)
ffffffffc020579c:	b7ad                	j	ffffffffc0205706 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc020579e:	000a6603          	lwu	a2,0(s4)
ffffffffc02057a2:	46a1                	li	a3,8
ffffffffc02057a4:	8a2e                	mv	s4,a1
ffffffffc02057a6:	bdb1                	j	ffffffffc0205602 <vprintfmt+0x156>
ffffffffc02057a8:	000a6603          	lwu	a2,0(s4)
ffffffffc02057ac:	46a9                	li	a3,10
ffffffffc02057ae:	8a2e                	mv	s4,a1
ffffffffc02057b0:	bd89                	j	ffffffffc0205602 <vprintfmt+0x156>
ffffffffc02057b2:	000a6603          	lwu	a2,0(s4)
ffffffffc02057b6:	46c1                	li	a3,16
ffffffffc02057b8:	8a2e                	mv	s4,a1
ffffffffc02057ba:	b5a1                	j	ffffffffc0205602 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02057bc:	9902                	jalr	s2
ffffffffc02057be:	bf09                	j	ffffffffc02056d0 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02057c0:	85a6                	mv	a1,s1
ffffffffc02057c2:	02d00513          	li	a0,45
ffffffffc02057c6:	e03e                	sd	a5,0(sp)
ffffffffc02057c8:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02057ca:	6782                	ld	a5,0(sp)
ffffffffc02057cc:	8a66                	mv	s4,s9
ffffffffc02057ce:	40800633          	neg	a2,s0
ffffffffc02057d2:	46a9                	li	a3,10
ffffffffc02057d4:	b53d                	j	ffffffffc0205602 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02057d6:	03b05163          	blez	s11,ffffffffc02057f8 <vprintfmt+0x34c>
ffffffffc02057da:	02d00693          	li	a3,45
ffffffffc02057de:	f6d79de3          	bne	a5,a3,ffffffffc0205758 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02057e2:	00002417          	auipc	s0,0x2
ffffffffc02057e6:	17e40413          	addi	s0,s0,382 # ffffffffc0207960 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057ea:	02800793          	li	a5,40
ffffffffc02057ee:	02800513          	li	a0,40
ffffffffc02057f2:	00140a13          	addi	s4,s0,1
ffffffffc02057f6:	bd6d                	j	ffffffffc02056b0 <vprintfmt+0x204>
ffffffffc02057f8:	00002a17          	auipc	s4,0x2
ffffffffc02057fc:	169a0a13          	addi	s4,s4,361 # ffffffffc0207961 <syscalls+0x119>
ffffffffc0205800:	02800513          	li	a0,40
ffffffffc0205804:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205808:	05e00413          	li	s0,94
ffffffffc020580c:	b565                	j	ffffffffc02056b4 <vprintfmt+0x208>

ffffffffc020580e <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020580e:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205810:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205814:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205816:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205818:	ec06                	sd	ra,24(sp)
ffffffffc020581a:	f83a                	sd	a4,48(sp)
ffffffffc020581c:	fc3e                	sd	a5,56(sp)
ffffffffc020581e:	e0c2                	sd	a6,64(sp)
ffffffffc0205820:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0205822:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205824:	c89ff0ef          	jal	ra,ffffffffc02054ac <vprintfmt>
}
ffffffffc0205828:	60e2                	ld	ra,24(sp)
ffffffffc020582a:	6161                	addi	sp,sp,80
ffffffffc020582c:	8082                	ret

ffffffffc020582e <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc020582e:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0205832:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0205834:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0205836:	cb81                	beqz	a5,ffffffffc0205846 <strlen+0x18>
        cnt ++;
ffffffffc0205838:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc020583a:	00a707b3          	add	a5,a4,a0
ffffffffc020583e:	0007c783          	lbu	a5,0(a5)
ffffffffc0205842:	fbfd                	bnez	a5,ffffffffc0205838 <strlen+0xa>
ffffffffc0205844:	8082                	ret
    }
    return cnt;
}
ffffffffc0205846:	8082                	ret

ffffffffc0205848 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205848:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020584a:	e589                	bnez	a1,ffffffffc0205854 <strnlen+0xc>
ffffffffc020584c:	a811                	j	ffffffffc0205860 <strnlen+0x18>
        cnt ++;
ffffffffc020584e:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205850:	00f58863          	beq	a1,a5,ffffffffc0205860 <strnlen+0x18>
ffffffffc0205854:	00f50733          	add	a4,a0,a5
ffffffffc0205858:	00074703          	lbu	a4,0(a4)
ffffffffc020585c:	fb6d                	bnez	a4,ffffffffc020584e <strnlen+0x6>
ffffffffc020585e:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0205860:	852e                	mv	a0,a1
ffffffffc0205862:	8082                	ret

ffffffffc0205864 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0205864:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205866:	0005c703          	lbu	a4,0(a1)
ffffffffc020586a:	0785                	addi	a5,a5,1
ffffffffc020586c:	0585                	addi	a1,a1,1
ffffffffc020586e:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0205872:	fb75                	bnez	a4,ffffffffc0205866 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0205874:	8082                	ret

ffffffffc0205876 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205876:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020587a:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020587e:	cb89                	beqz	a5,ffffffffc0205890 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0205880:	0505                	addi	a0,a0,1
ffffffffc0205882:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205884:	fee789e3          	beq	a5,a4,ffffffffc0205876 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205888:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020588c:	9d19                	subw	a0,a0,a4
ffffffffc020588e:	8082                	ret
ffffffffc0205890:	4501                	li	a0,0
ffffffffc0205892:	bfed                	j	ffffffffc020588c <strcmp+0x16>

ffffffffc0205894 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205894:	c20d                	beqz	a2,ffffffffc02058b6 <strncmp+0x22>
ffffffffc0205896:	962e                	add	a2,a2,a1
ffffffffc0205898:	a031                	j	ffffffffc02058a4 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc020589a:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020589c:	00e79a63          	bne	a5,a4,ffffffffc02058b0 <strncmp+0x1c>
ffffffffc02058a0:	00b60b63          	beq	a2,a1,ffffffffc02058b6 <strncmp+0x22>
ffffffffc02058a4:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02058a8:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02058aa:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02058ae:	f7f5                	bnez	a5,ffffffffc020589a <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02058b0:	40e7853b          	subw	a0,a5,a4
}
ffffffffc02058b4:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02058b6:	4501                	li	a0,0
ffffffffc02058b8:	8082                	ret

ffffffffc02058ba <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02058ba:	00054783          	lbu	a5,0(a0)
ffffffffc02058be:	c799                	beqz	a5,ffffffffc02058cc <strchr+0x12>
        if (*s == c) {
ffffffffc02058c0:	00f58763          	beq	a1,a5,ffffffffc02058ce <strchr+0x14>
    while (*s != '\0') {
ffffffffc02058c4:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02058c8:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02058ca:	fbfd                	bnez	a5,ffffffffc02058c0 <strchr+0x6>
    }
    return NULL;
ffffffffc02058cc:	4501                	li	a0,0
}
ffffffffc02058ce:	8082                	ret

ffffffffc02058d0 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02058d0:	ca01                	beqz	a2,ffffffffc02058e0 <memset+0x10>
ffffffffc02058d2:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02058d4:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02058d6:	0785                	addi	a5,a5,1
ffffffffc02058d8:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02058dc:	fec79de3          	bne	a5,a2,ffffffffc02058d6 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02058e0:	8082                	ret

ffffffffc02058e2 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02058e2:	ca19                	beqz	a2,ffffffffc02058f8 <memcpy+0x16>
ffffffffc02058e4:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02058e6:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02058e8:	0005c703          	lbu	a4,0(a1)
ffffffffc02058ec:	0585                	addi	a1,a1,1
ffffffffc02058ee:	0785                	addi	a5,a5,1
ffffffffc02058f0:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02058f4:	fec59ae3          	bne	a1,a2,ffffffffc02058e8 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02058f8:	8082                	ret
