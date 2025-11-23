
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00009297          	auipc	t0,0x9
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0209000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00009297          	auipc	t0,0x9
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0209008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02082b7          	lui	t0,0xc0208
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
ffffffffc020003c:	c0208137          	lui	sp,0xc0208

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
ffffffffc020004a:	00009517          	auipc	a0,0x9
ffffffffc020004e:	fe650513          	addi	a0,a0,-26 # ffffffffc0209030 <buf>
ffffffffc0200052:	0000d617          	auipc	a2,0xd
ffffffffc0200056:	49a60613          	addi	a2,a2,1178 # ffffffffc020d4ec <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	5e5030ef          	jal	ra,ffffffffc0203e46 <memset>
    dtb_init();
ffffffffc0200066:	514000ef          	jal	ra,ffffffffc020057a <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	49e000ef          	jal	ra,ffffffffc0200508 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00004597          	auipc	a1,0x4
ffffffffc0200072:	e2a58593          	addi	a1,a1,-470 # ffffffffc0203e98 <etext+0x4>
ffffffffc0200076:	00004517          	auipc	a0,0x4
ffffffffc020007a:	e4250513          	addi	a0,a0,-446 # ffffffffc0203eb8 <etext+0x24>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	15a000ef          	jal	ra,ffffffffc02001dc <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	0d8020ef          	jal	ra,ffffffffc020215e <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	0ad000ef          	jal	ra,ffffffffc0200936 <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	0ab000ef          	jal	ra,ffffffffc0200938 <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	641020ef          	jal	ra,ffffffffc0202ed2 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	570030ef          	jal	ra,ffffffffc0203606 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	41c000ef          	jal	ra,ffffffffc02004b6 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	08d000ef          	jal	ra,ffffffffc020092a <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	7b2030ef          	jal	ra,ffffffffc0203854 <cpu_idle>

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
ffffffffc02000bc:	00004517          	auipc	a0,0x4
ffffffffc02000c0:	e0450513          	addi	a0,a0,-508 # ffffffffc0203ec0 <etext+0x2c>
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
ffffffffc02000d2:	00009b97          	auipc	s7,0x9
ffffffffc02000d6:	f5eb8b93          	addi	s7,s7,-162 # ffffffffc0209030 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000da:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000de:	0ee000ef          	jal	ra,ffffffffc02001cc <getchar>
        if (c < 0) {
ffffffffc02000e2:	00054a63          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e6:	00a95a63          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc02000ea:	029a5263          	bge	s4,s1,ffffffffc020010e <readline+0x68>
        c = getchar();
ffffffffc02000ee:	0de000ef          	jal	ra,ffffffffc02001cc <getchar>
        if (c < 0) {
ffffffffc02000f2:	fe055ae3          	bgez	a0,ffffffffc02000e6 <readline+0x40>
            return NULL;
ffffffffc02000f6:	4501                	li	a0,0
ffffffffc02000f8:	a091                	j	ffffffffc020013c <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fa:	03351463          	bne	a0,s3,ffffffffc0200122 <readline+0x7c>
ffffffffc02000fe:	e8a9                	bnez	s1,ffffffffc0200150 <readline+0xaa>
        c = getchar();
ffffffffc0200100:	0cc000ef          	jal	ra,ffffffffc02001cc <getchar>
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
ffffffffc020012e:	00009517          	auipc	a0,0x9
ffffffffc0200132:	f0250513          	addi	a0,a0,-254 # ffffffffc0209030 <buf>
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
ffffffffc0200162:	3a8000ef          	jal	ra,ffffffffc020050a <cons_putc>
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
ffffffffc0200188:	09b030ef          	jal	ra,ffffffffc0203a22 <vprintfmt>
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
ffffffffc0200196:	02810313          	addi	t1,sp,40 # ffffffffc0208028 <boot_page_table_sv39+0x28>
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
ffffffffc02001be:	065030ef          	jal	ra,ffffffffc0203a22 <vprintfmt>
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
ffffffffc02001ca:	a681                	j	ffffffffc020050a <cons_putc>

ffffffffc02001cc <getchar>:
}

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc02001cc:	1141                	addi	sp,sp,-16
ffffffffc02001ce:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02001d0:	36e000ef          	jal	ra,ffffffffc020053e <cons_getc>
ffffffffc02001d4:	dd75                	beqz	a0,ffffffffc02001d0 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc02001d6:	60a2                	ld	ra,8(sp)
ffffffffc02001d8:	0141                	addi	sp,sp,16
ffffffffc02001da:	8082                	ret

ffffffffc02001dc <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc02001dc:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02001de:	00004517          	auipc	a0,0x4
ffffffffc02001e2:	cea50513          	addi	a0,a0,-790 # ffffffffc0203ec8 <etext+0x34>
{
ffffffffc02001e6:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001e8:	fadff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc02001ec:	00000597          	auipc	a1,0x0
ffffffffc02001f0:	e5e58593          	addi	a1,a1,-418 # ffffffffc020004a <kern_init>
ffffffffc02001f4:	00004517          	auipc	a0,0x4
ffffffffc02001f8:	cf450513          	addi	a0,a0,-780 # ffffffffc0203ee8 <etext+0x54>
ffffffffc02001fc:	f99ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200200:	00004597          	auipc	a1,0x4
ffffffffc0200204:	c9458593          	addi	a1,a1,-876 # ffffffffc0203e94 <etext>
ffffffffc0200208:	00004517          	auipc	a0,0x4
ffffffffc020020c:	d0050513          	addi	a0,a0,-768 # ffffffffc0203f08 <etext+0x74>
ffffffffc0200210:	f85ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200214:	00009597          	auipc	a1,0x9
ffffffffc0200218:	e1c58593          	addi	a1,a1,-484 # ffffffffc0209030 <buf>
ffffffffc020021c:	00004517          	auipc	a0,0x4
ffffffffc0200220:	d0c50513          	addi	a0,a0,-756 # ffffffffc0203f28 <etext+0x94>
ffffffffc0200224:	f71ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200228:	0000d597          	auipc	a1,0xd
ffffffffc020022c:	2c458593          	addi	a1,a1,708 # ffffffffc020d4ec <end>
ffffffffc0200230:	00004517          	auipc	a0,0x4
ffffffffc0200234:	d1850513          	addi	a0,a0,-744 # ffffffffc0203f48 <etext+0xb4>
ffffffffc0200238:	f5dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020023c:	0000d597          	auipc	a1,0xd
ffffffffc0200240:	6af58593          	addi	a1,a1,1711 # ffffffffc020d8eb <end+0x3ff>
ffffffffc0200244:	00000797          	auipc	a5,0x0
ffffffffc0200248:	e0678793          	addi	a5,a5,-506 # ffffffffc020004a <kern_init>
ffffffffc020024c:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200250:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200254:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200256:	3ff5f593          	andi	a1,a1,1023
ffffffffc020025a:	95be                	add	a1,a1,a5
ffffffffc020025c:	85a9                	srai	a1,a1,0xa
ffffffffc020025e:	00004517          	auipc	a0,0x4
ffffffffc0200262:	d0a50513          	addi	a0,a0,-758 # ffffffffc0203f68 <etext+0xd4>
}
ffffffffc0200266:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200268:	b735                	j	ffffffffc0200194 <cprintf>

ffffffffc020026a <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc020026a:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc020026c:	00004617          	auipc	a2,0x4
ffffffffc0200270:	d2c60613          	addi	a2,a2,-724 # ffffffffc0203f98 <etext+0x104>
ffffffffc0200274:	04900593          	li	a1,73
ffffffffc0200278:	00004517          	auipc	a0,0x4
ffffffffc020027c:	d3850513          	addi	a0,a0,-712 # ffffffffc0203fb0 <etext+0x11c>
{
ffffffffc0200280:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200282:	1d8000ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0200286 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200286:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200288:	00004617          	auipc	a2,0x4
ffffffffc020028c:	d4060613          	addi	a2,a2,-704 # ffffffffc0203fc8 <etext+0x134>
ffffffffc0200290:	00004597          	auipc	a1,0x4
ffffffffc0200294:	d5858593          	addi	a1,a1,-680 # ffffffffc0203fe8 <etext+0x154>
ffffffffc0200298:	00004517          	auipc	a0,0x4
ffffffffc020029c:	d5850513          	addi	a0,a0,-680 # ffffffffc0203ff0 <etext+0x15c>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002a0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002a2:	ef3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002a6:	00004617          	auipc	a2,0x4
ffffffffc02002aa:	d5a60613          	addi	a2,a2,-678 # ffffffffc0204000 <etext+0x16c>
ffffffffc02002ae:	00004597          	auipc	a1,0x4
ffffffffc02002b2:	d7a58593          	addi	a1,a1,-646 # ffffffffc0204028 <etext+0x194>
ffffffffc02002b6:	00004517          	auipc	a0,0x4
ffffffffc02002ba:	d3a50513          	addi	a0,a0,-710 # ffffffffc0203ff0 <etext+0x15c>
ffffffffc02002be:	ed7ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002c2:	00004617          	auipc	a2,0x4
ffffffffc02002c6:	d7660613          	addi	a2,a2,-650 # ffffffffc0204038 <etext+0x1a4>
ffffffffc02002ca:	00004597          	auipc	a1,0x4
ffffffffc02002ce:	d8e58593          	addi	a1,a1,-626 # ffffffffc0204058 <etext+0x1c4>
ffffffffc02002d2:	00004517          	auipc	a0,0x4
ffffffffc02002d6:	d1e50513          	addi	a0,a0,-738 # ffffffffc0203ff0 <etext+0x15c>
ffffffffc02002da:	ebbff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    return 0;
}
ffffffffc02002de:	60a2                	ld	ra,8(sp)
ffffffffc02002e0:	4501                	li	a0,0
ffffffffc02002e2:	0141                	addi	sp,sp,16
ffffffffc02002e4:	8082                	ret

ffffffffc02002e6 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002e6:	1141                	addi	sp,sp,-16
ffffffffc02002e8:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02002ea:	ef3ff0ef          	jal	ra,ffffffffc02001dc <print_kerninfo>
    return 0;
}
ffffffffc02002ee:	60a2                	ld	ra,8(sp)
ffffffffc02002f0:	4501                	li	a0,0
ffffffffc02002f2:	0141                	addi	sp,sp,16
ffffffffc02002f4:	8082                	ret

ffffffffc02002f6 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002f6:	1141                	addi	sp,sp,-16
ffffffffc02002f8:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002fa:	f71ff0ef          	jal	ra,ffffffffc020026a <print_stackframe>
    return 0;
}
ffffffffc02002fe:	60a2                	ld	ra,8(sp)
ffffffffc0200300:	4501                	li	a0,0
ffffffffc0200302:	0141                	addi	sp,sp,16
ffffffffc0200304:	8082                	ret

ffffffffc0200306 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200306:	7115                	addi	sp,sp,-224
ffffffffc0200308:	ed5e                	sd	s7,152(sp)
ffffffffc020030a:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020030c:	00004517          	auipc	a0,0x4
ffffffffc0200310:	d5c50513          	addi	a0,a0,-676 # ffffffffc0204068 <etext+0x1d4>
kmonitor(struct trapframe *tf) {
ffffffffc0200314:	ed86                	sd	ra,216(sp)
ffffffffc0200316:	e9a2                	sd	s0,208(sp)
ffffffffc0200318:	e5a6                	sd	s1,200(sp)
ffffffffc020031a:	e1ca                	sd	s2,192(sp)
ffffffffc020031c:	fd4e                	sd	s3,184(sp)
ffffffffc020031e:	f952                	sd	s4,176(sp)
ffffffffc0200320:	f556                	sd	s5,168(sp)
ffffffffc0200322:	f15a                	sd	s6,160(sp)
ffffffffc0200324:	e962                	sd	s8,144(sp)
ffffffffc0200326:	e566                	sd	s9,136(sp)
ffffffffc0200328:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020032a:	e6bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020032e:	00004517          	auipc	a0,0x4
ffffffffc0200332:	d6250513          	addi	a0,a0,-670 # ffffffffc0204090 <etext+0x1fc>
ffffffffc0200336:	e5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL) {
ffffffffc020033a:	000b8563          	beqz	s7,ffffffffc0200344 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020033e:	855e                	mv	a0,s7
ffffffffc0200340:	7e0000ef          	jal	ra,ffffffffc0200b20 <print_trapframe>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200344:	4501                	li	a0,0
ffffffffc0200346:	4581                	li	a1,0
ffffffffc0200348:	4601                	li	a2,0
ffffffffc020034a:	48a1                	li	a7,8
ffffffffc020034c:	00000073          	ecall
ffffffffc0200350:	00004c17          	auipc	s8,0x4
ffffffffc0200354:	db0c0c13          	addi	s8,s8,-592 # ffffffffc0204100 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200358:	00004917          	auipc	s2,0x4
ffffffffc020035c:	d6090913          	addi	s2,s2,-672 # ffffffffc02040b8 <etext+0x224>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200360:	00004497          	auipc	s1,0x4
ffffffffc0200364:	d6048493          	addi	s1,s1,-672 # ffffffffc02040c0 <etext+0x22c>
        if (argc == MAXARGS - 1) {
ffffffffc0200368:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020036a:	00004b17          	auipc	s6,0x4
ffffffffc020036e:	d5eb0b13          	addi	s6,s6,-674 # ffffffffc02040c8 <etext+0x234>
        argv[argc ++] = buf;
ffffffffc0200372:	00004a17          	auipc	s4,0x4
ffffffffc0200376:	c76a0a13          	addi	s4,s4,-906 # ffffffffc0203fe8 <etext+0x154>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020037a:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020037c:	854a                	mv	a0,s2
ffffffffc020037e:	d29ff0ef          	jal	ra,ffffffffc02000a6 <readline>
ffffffffc0200382:	842a                	mv	s0,a0
ffffffffc0200384:	dd65                	beqz	a0,ffffffffc020037c <kmonitor+0x76>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200386:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020038a:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020038c:	e1bd                	bnez	a1,ffffffffc02003f2 <kmonitor+0xec>
    if (argc == 0) {
ffffffffc020038e:	fe0c87e3          	beqz	s9,ffffffffc020037c <kmonitor+0x76>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200392:	6582                	ld	a1,0(sp)
ffffffffc0200394:	00004d17          	auipc	s10,0x4
ffffffffc0200398:	d6cd0d13          	addi	s10,s10,-660 # ffffffffc0204100 <commands>
        argv[argc ++] = buf;
ffffffffc020039c:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020039e:	4401                	li	s0,0
ffffffffc02003a0:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003a2:	24b030ef          	jal	ra,ffffffffc0203dec <strcmp>
ffffffffc02003a6:	c919                	beqz	a0,ffffffffc02003bc <kmonitor+0xb6>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003a8:	2405                	addiw	s0,s0,1
ffffffffc02003aa:	0b540063          	beq	s0,s5,ffffffffc020044a <kmonitor+0x144>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003ae:	000d3503          	ld	a0,0(s10)
ffffffffc02003b2:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003b4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003b6:	237030ef          	jal	ra,ffffffffc0203dec <strcmp>
ffffffffc02003ba:	f57d                	bnez	a0,ffffffffc02003a8 <kmonitor+0xa2>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003bc:	00141793          	slli	a5,s0,0x1
ffffffffc02003c0:	97a2                	add	a5,a5,s0
ffffffffc02003c2:	078e                	slli	a5,a5,0x3
ffffffffc02003c4:	97e2                	add	a5,a5,s8
ffffffffc02003c6:	6b9c                	ld	a5,16(a5)
ffffffffc02003c8:	865e                	mv	a2,s7
ffffffffc02003ca:	002c                	addi	a1,sp,8
ffffffffc02003cc:	fffc851b          	addiw	a0,s9,-1
ffffffffc02003d0:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02003d2:	fa0555e3          	bgez	a0,ffffffffc020037c <kmonitor+0x76>
}
ffffffffc02003d6:	60ee                	ld	ra,216(sp)
ffffffffc02003d8:	644e                	ld	s0,208(sp)
ffffffffc02003da:	64ae                	ld	s1,200(sp)
ffffffffc02003dc:	690e                	ld	s2,192(sp)
ffffffffc02003de:	79ea                	ld	s3,184(sp)
ffffffffc02003e0:	7a4a                	ld	s4,176(sp)
ffffffffc02003e2:	7aaa                	ld	s5,168(sp)
ffffffffc02003e4:	7b0a                	ld	s6,160(sp)
ffffffffc02003e6:	6bea                	ld	s7,152(sp)
ffffffffc02003e8:	6c4a                	ld	s8,144(sp)
ffffffffc02003ea:	6caa                	ld	s9,136(sp)
ffffffffc02003ec:	6d0a                	ld	s10,128(sp)
ffffffffc02003ee:	612d                	addi	sp,sp,224
ffffffffc02003f0:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003f2:	8526                	mv	a0,s1
ffffffffc02003f4:	23d030ef          	jal	ra,ffffffffc0203e30 <strchr>
ffffffffc02003f8:	c901                	beqz	a0,ffffffffc0200408 <kmonitor+0x102>
ffffffffc02003fa:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc02003fe:	00040023          	sb	zero,0(s0)
ffffffffc0200402:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200404:	d5c9                	beqz	a1,ffffffffc020038e <kmonitor+0x88>
ffffffffc0200406:	b7f5                	j	ffffffffc02003f2 <kmonitor+0xec>
        if (*buf == '\0') {
ffffffffc0200408:	00044783          	lbu	a5,0(s0)
ffffffffc020040c:	d3c9                	beqz	a5,ffffffffc020038e <kmonitor+0x88>
        if (argc == MAXARGS - 1) {
ffffffffc020040e:	033c8963          	beq	s9,s3,ffffffffc0200440 <kmonitor+0x13a>
        argv[argc ++] = buf;
ffffffffc0200412:	003c9793          	slli	a5,s9,0x3
ffffffffc0200416:	0118                	addi	a4,sp,128
ffffffffc0200418:	97ba                	add	a5,a5,a4
ffffffffc020041a:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020041e:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200422:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200424:	e591                	bnez	a1,ffffffffc0200430 <kmonitor+0x12a>
ffffffffc0200426:	b7b5                	j	ffffffffc0200392 <kmonitor+0x8c>
ffffffffc0200428:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc020042c:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020042e:	d1a5                	beqz	a1,ffffffffc020038e <kmonitor+0x88>
ffffffffc0200430:	8526                	mv	a0,s1
ffffffffc0200432:	1ff030ef          	jal	ra,ffffffffc0203e30 <strchr>
ffffffffc0200436:	d96d                	beqz	a0,ffffffffc0200428 <kmonitor+0x122>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200438:	00044583          	lbu	a1,0(s0)
ffffffffc020043c:	d9a9                	beqz	a1,ffffffffc020038e <kmonitor+0x88>
ffffffffc020043e:	bf55                	j	ffffffffc02003f2 <kmonitor+0xec>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200440:	45c1                	li	a1,16
ffffffffc0200442:	855a                	mv	a0,s6
ffffffffc0200444:	d51ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200448:	b7e9                	j	ffffffffc0200412 <kmonitor+0x10c>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020044a:	6582                	ld	a1,0(sp)
ffffffffc020044c:	00004517          	auipc	a0,0x4
ffffffffc0200450:	c9c50513          	addi	a0,a0,-868 # ffffffffc02040e8 <etext+0x254>
ffffffffc0200454:	d41ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
ffffffffc0200458:	b715                	j	ffffffffc020037c <kmonitor+0x76>

ffffffffc020045a <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc020045a:	0000d317          	auipc	t1,0xd
ffffffffc020045e:	00e30313          	addi	t1,t1,14 # ffffffffc020d468 <is_panic>
ffffffffc0200462:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200466:	715d                	addi	sp,sp,-80
ffffffffc0200468:	ec06                	sd	ra,24(sp)
ffffffffc020046a:	e822                	sd	s0,16(sp)
ffffffffc020046c:	f436                	sd	a3,40(sp)
ffffffffc020046e:	f83a                	sd	a4,48(sp)
ffffffffc0200470:	fc3e                	sd	a5,56(sp)
ffffffffc0200472:	e0c2                	sd	a6,64(sp)
ffffffffc0200474:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200476:	020e1a63          	bnez	t3,ffffffffc02004aa <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc020047a:	4785                	li	a5,1
ffffffffc020047c:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200480:	8432                	mv	s0,a2
ffffffffc0200482:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200484:	862e                	mv	a2,a1
ffffffffc0200486:	85aa                	mv	a1,a0
ffffffffc0200488:	00004517          	auipc	a0,0x4
ffffffffc020048c:	cc050513          	addi	a0,a0,-832 # ffffffffc0204148 <commands+0x48>
    va_start(ap, fmt);
ffffffffc0200490:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200492:	d03ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200496:	65a2                	ld	a1,8(sp)
ffffffffc0200498:	8522                	mv	a0,s0
ffffffffc020049a:	cdbff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc020049e:	00005517          	auipc	a0,0x5
ffffffffc02004a2:	d5a50513          	addi	a0,a0,-678 # ffffffffc02051f8 <default_pmm_manager+0x530>
ffffffffc02004a6:	cefff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc02004aa:	486000ef          	jal	ra,ffffffffc0200930 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02004ae:	4501                	li	a0,0
ffffffffc02004b0:	e57ff0ef          	jal	ra,ffffffffc0200306 <kmonitor>
    while (1) {
ffffffffc02004b4:	bfed                	j	ffffffffc02004ae <__panic+0x54>

ffffffffc02004b6 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc02004b6:	67e1                	lui	a5,0x18
ffffffffc02004b8:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02004bc:	0000d717          	auipc	a4,0xd
ffffffffc02004c0:	faf73e23          	sd	a5,-68(a4) # ffffffffc020d478 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02004c4:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc02004c8:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004ca:	953e                	add	a0,a0,a5
ffffffffc02004cc:	4601                	li	a2,0
ffffffffc02004ce:	4881                	li	a7,0
ffffffffc02004d0:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc02004d4:	02000793          	li	a5,32
ffffffffc02004d8:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc02004dc:	00004517          	auipc	a0,0x4
ffffffffc02004e0:	c8c50513          	addi	a0,a0,-884 # ffffffffc0204168 <commands+0x68>
    ticks = 0;
ffffffffc02004e4:	0000d797          	auipc	a5,0xd
ffffffffc02004e8:	f807b623          	sd	zero,-116(a5) # ffffffffc020d470 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc02004ec:	b165                	j	ffffffffc0200194 <cprintf>

ffffffffc02004ee <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02004ee:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004f2:	0000d797          	auipc	a5,0xd
ffffffffc02004f6:	f867b783          	ld	a5,-122(a5) # ffffffffc020d478 <timebase>
ffffffffc02004fa:	953e                	add	a0,a0,a5
ffffffffc02004fc:	4581                	li	a1,0
ffffffffc02004fe:	4601                	li	a2,0
ffffffffc0200500:	4881                	li	a7,0
ffffffffc0200502:	00000073          	ecall
ffffffffc0200506:	8082                	ret

ffffffffc0200508 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200508:	8082                	ret

ffffffffc020050a <cons_putc>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020050a:	100027f3          	csrr	a5,sstatus
ffffffffc020050e:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200510:	0ff57513          	zext.b	a0,a0
ffffffffc0200514:	e799                	bnez	a5,ffffffffc0200522 <cons_putc+0x18>
ffffffffc0200516:	4581                	li	a1,0
ffffffffc0200518:	4601                	li	a2,0
ffffffffc020051a:	4885                	li	a7,1
ffffffffc020051c:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc0200520:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200522:	1101                	addi	sp,sp,-32
ffffffffc0200524:	ec06                	sd	ra,24(sp)
ffffffffc0200526:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200528:	408000ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020052c:	6522                	ld	a0,8(sp)
ffffffffc020052e:	4581                	li	a1,0
ffffffffc0200530:	4601                	li	a2,0
ffffffffc0200532:	4885                	li	a7,1
ffffffffc0200534:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200538:	60e2                	ld	ra,24(sp)
ffffffffc020053a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020053c:	a6fd                	j	ffffffffc020092a <intr_enable>

ffffffffc020053e <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020053e:	100027f3          	csrr	a5,sstatus
ffffffffc0200542:	8b89                	andi	a5,a5,2
ffffffffc0200544:	eb89                	bnez	a5,ffffffffc0200556 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc0200546:	4501                	li	a0,0
ffffffffc0200548:	4581                	li	a1,0
ffffffffc020054a:	4601                	li	a2,0
ffffffffc020054c:	4889                	li	a7,2
ffffffffc020054e:	00000073          	ecall
ffffffffc0200552:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200554:	8082                	ret
int cons_getc(void) {
ffffffffc0200556:	1101                	addi	sp,sp,-32
ffffffffc0200558:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc020055a:	3d6000ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020055e:	4501                	li	a0,0
ffffffffc0200560:	4581                	li	a1,0
ffffffffc0200562:	4601                	li	a2,0
ffffffffc0200564:	4889                	li	a7,2
ffffffffc0200566:	00000073          	ecall
ffffffffc020056a:	2501                	sext.w	a0,a0
ffffffffc020056c:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc020056e:	3bc000ef          	jal	ra,ffffffffc020092a <intr_enable>
}
ffffffffc0200572:	60e2                	ld	ra,24(sp)
ffffffffc0200574:	6522                	ld	a0,8(sp)
ffffffffc0200576:	6105                	addi	sp,sp,32
ffffffffc0200578:	8082                	ret

ffffffffc020057a <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc020057a:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc020057c:	00004517          	auipc	a0,0x4
ffffffffc0200580:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0204188 <commands+0x88>
void dtb_init(void) {
ffffffffc0200584:	fc86                	sd	ra,120(sp)
ffffffffc0200586:	f8a2                	sd	s0,112(sp)
ffffffffc0200588:	e8d2                	sd	s4,80(sp)
ffffffffc020058a:	f4a6                	sd	s1,104(sp)
ffffffffc020058c:	f0ca                	sd	s2,96(sp)
ffffffffc020058e:	ecce                	sd	s3,88(sp)
ffffffffc0200590:	e4d6                	sd	s5,72(sp)
ffffffffc0200592:	e0da                	sd	s6,64(sp)
ffffffffc0200594:	fc5e                	sd	s7,56(sp)
ffffffffc0200596:	f862                	sd	s8,48(sp)
ffffffffc0200598:	f466                	sd	s9,40(sp)
ffffffffc020059a:	f06a                	sd	s10,32(sp)
ffffffffc020059c:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc020059e:	bf7ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005a2:	00009597          	auipc	a1,0x9
ffffffffc02005a6:	a5e5b583          	ld	a1,-1442(a1) # ffffffffc0209000 <boot_hartid>
ffffffffc02005aa:	00004517          	auipc	a0,0x4
ffffffffc02005ae:	bee50513          	addi	a0,a0,-1042 # ffffffffc0204198 <commands+0x98>
ffffffffc02005b2:	be3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005b6:	00009417          	auipc	s0,0x9
ffffffffc02005ba:	a5240413          	addi	s0,s0,-1454 # ffffffffc0209008 <boot_dtb>
ffffffffc02005be:	600c                	ld	a1,0(s0)
ffffffffc02005c0:	00004517          	auipc	a0,0x4
ffffffffc02005c4:	be850513          	addi	a0,a0,-1048 # ffffffffc02041a8 <commands+0xa8>
ffffffffc02005c8:	bcdff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02005cc:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02005d0:	00004517          	auipc	a0,0x4
ffffffffc02005d4:	bf050513          	addi	a0,a0,-1040 # ffffffffc02041c0 <commands+0xc0>
    if (boot_dtb == 0) {
ffffffffc02005d8:	120a0463          	beqz	s4,ffffffffc0200700 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc02005dc:	57f5                	li	a5,-3
ffffffffc02005de:	07fa                	slli	a5,a5,0x1e
ffffffffc02005e0:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc02005e4:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005e6:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ea:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ec:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005f0:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005f4:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005f8:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005fc:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200600:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200602:	8ec9                	or	a3,a3,a0
ffffffffc0200604:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200608:	1b7d                	addi	s6,s6,-1
ffffffffc020060a:	0167f7b3          	and	a5,a5,s6
ffffffffc020060e:	8dd5                	or	a1,a1,a3
ffffffffc0200610:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200612:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200616:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc0200618:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed2a01>
ffffffffc020061c:	10f59163          	bne	a1,a5,ffffffffc020071e <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc0200620:	471c                	lw	a5,8(a4)
ffffffffc0200622:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc0200624:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200626:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020062a:	0086d51b          	srliw	a0,a3,0x8
ffffffffc020062e:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200632:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200636:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020063a:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020063e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200642:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200646:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020064a:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020064e:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200650:	01146433          	or	s0,s0,a7
ffffffffc0200654:	0086969b          	slliw	a3,a3,0x8
ffffffffc0200658:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020065c:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020065e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200662:	8c49                	or	s0,s0,a0
ffffffffc0200664:	0166f6b3          	and	a3,a3,s6
ffffffffc0200668:	00ca6a33          	or	s4,s4,a2
ffffffffc020066c:	0167f7b3          	and	a5,a5,s6
ffffffffc0200670:	8c55                	or	s0,s0,a3
ffffffffc0200672:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200676:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200678:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020067a:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020067c:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200680:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200682:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200684:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc0200688:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020068a:	00004917          	auipc	s2,0x4
ffffffffc020068e:	b8690913          	addi	s2,s2,-1146 # ffffffffc0204210 <commands+0x110>
ffffffffc0200692:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200694:	4d91                	li	s11,4
ffffffffc0200696:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200698:	00004497          	auipc	s1,0x4
ffffffffc020069c:	b7048493          	addi	s1,s1,-1168 # ffffffffc0204208 <commands+0x108>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006a0:	000a2703          	lw	a4,0(s4)
ffffffffc02006a4:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a8:	0087569b          	srliw	a3,a4,0x8
ffffffffc02006ac:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b0:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b4:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b8:	0107571b          	srliw	a4,a4,0x10
ffffffffc02006bc:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006be:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c2:	0087171b          	slliw	a4,a4,0x8
ffffffffc02006c6:	8fd5                	or	a5,a5,a3
ffffffffc02006c8:	00eb7733          	and	a4,s6,a4
ffffffffc02006cc:	8fd9                	or	a5,a5,a4
ffffffffc02006ce:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc02006d0:	09778c63          	beq	a5,s7,ffffffffc0200768 <dtb_init+0x1ee>
ffffffffc02006d4:	00fbea63          	bltu	s7,a5,ffffffffc02006e8 <dtb_init+0x16e>
ffffffffc02006d8:	07a78663          	beq	a5,s10,ffffffffc0200744 <dtb_init+0x1ca>
ffffffffc02006dc:	4709                	li	a4,2
ffffffffc02006de:	00e79763          	bne	a5,a4,ffffffffc02006ec <dtb_init+0x172>
ffffffffc02006e2:	4c81                	li	s9,0
ffffffffc02006e4:	8a56                	mv	s4,s5
ffffffffc02006e6:	bf6d                	j	ffffffffc02006a0 <dtb_init+0x126>
ffffffffc02006e8:	ffb78ee3          	beq	a5,s11,ffffffffc02006e4 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02006ec:	00004517          	auipc	a0,0x4
ffffffffc02006f0:	b9c50513          	addi	a0,a0,-1124 # ffffffffc0204288 <commands+0x188>
ffffffffc02006f4:	aa1ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006f8:	00004517          	auipc	a0,0x4
ffffffffc02006fc:	bc850513          	addi	a0,a0,-1080 # ffffffffc02042c0 <commands+0x1c0>
}
ffffffffc0200700:	7446                	ld	s0,112(sp)
ffffffffc0200702:	70e6                	ld	ra,120(sp)
ffffffffc0200704:	74a6                	ld	s1,104(sp)
ffffffffc0200706:	7906                	ld	s2,96(sp)
ffffffffc0200708:	69e6                	ld	s3,88(sp)
ffffffffc020070a:	6a46                	ld	s4,80(sp)
ffffffffc020070c:	6aa6                	ld	s5,72(sp)
ffffffffc020070e:	6b06                	ld	s6,64(sp)
ffffffffc0200710:	7be2                	ld	s7,56(sp)
ffffffffc0200712:	7c42                	ld	s8,48(sp)
ffffffffc0200714:	7ca2                	ld	s9,40(sp)
ffffffffc0200716:	7d02                	ld	s10,32(sp)
ffffffffc0200718:	6de2                	ld	s11,24(sp)
ffffffffc020071a:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc020071c:	bca5                	j	ffffffffc0200194 <cprintf>
}
ffffffffc020071e:	7446                	ld	s0,112(sp)
ffffffffc0200720:	70e6                	ld	ra,120(sp)
ffffffffc0200722:	74a6                	ld	s1,104(sp)
ffffffffc0200724:	7906                	ld	s2,96(sp)
ffffffffc0200726:	69e6                	ld	s3,88(sp)
ffffffffc0200728:	6a46                	ld	s4,80(sp)
ffffffffc020072a:	6aa6                	ld	s5,72(sp)
ffffffffc020072c:	6b06                	ld	s6,64(sp)
ffffffffc020072e:	7be2                	ld	s7,56(sp)
ffffffffc0200730:	7c42                	ld	s8,48(sp)
ffffffffc0200732:	7ca2                	ld	s9,40(sp)
ffffffffc0200734:	7d02                	ld	s10,32(sp)
ffffffffc0200736:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200738:	00004517          	auipc	a0,0x4
ffffffffc020073c:	aa850513          	addi	a0,a0,-1368 # ffffffffc02041e0 <commands+0xe0>
}
ffffffffc0200740:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200742:	bc89                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc0200744:	8556                	mv	a0,s5
ffffffffc0200746:	65e030ef          	jal	ra,ffffffffc0203da4 <strlen>
ffffffffc020074a:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020074c:	4619                	li	a2,6
ffffffffc020074e:	85a6                	mv	a1,s1
ffffffffc0200750:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc0200752:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200754:	6b6030ef          	jal	ra,ffffffffc0203e0a <strncmp>
ffffffffc0200758:	e111                	bnez	a0,ffffffffc020075c <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc020075a:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc020075c:	0a91                	addi	s5,s5,4
ffffffffc020075e:	9ad2                	add	s5,s5,s4
ffffffffc0200760:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200764:	8a56                	mv	s4,s5
ffffffffc0200766:	bf2d                	j	ffffffffc02006a0 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200768:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020076c:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200770:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200774:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200778:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020077c:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200780:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200784:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200788:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020078c:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200790:	00eaeab3          	or	s5,s5,a4
ffffffffc0200794:	00fb77b3          	and	a5,s6,a5
ffffffffc0200798:	00faeab3          	or	s5,s5,a5
ffffffffc020079c:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020079e:	000c9c63          	bnez	s9,ffffffffc02007b6 <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02007a2:	1a82                	slli	s5,s5,0x20
ffffffffc02007a4:	00368793          	addi	a5,a3,3
ffffffffc02007a8:	020ada93          	srli	s5,s5,0x20
ffffffffc02007ac:	9abe                	add	s5,s5,a5
ffffffffc02007ae:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007b2:	8a56                	mv	s4,s5
ffffffffc02007b4:	b5f5                	j	ffffffffc02006a0 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007b6:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007ba:	85ca                	mv	a1,s2
ffffffffc02007bc:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007be:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007c2:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007c6:	0187971b          	slliw	a4,a5,0x18
ffffffffc02007ca:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007ce:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02007d2:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007d4:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007d8:	0087979b          	slliw	a5,a5,0x8
ffffffffc02007dc:	8d59                	or	a0,a0,a4
ffffffffc02007de:	00fb77b3          	and	a5,s6,a5
ffffffffc02007e2:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02007e4:	1502                	slli	a0,a0,0x20
ffffffffc02007e6:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007e8:	9522                	add	a0,a0,s0
ffffffffc02007ea:	602030ef          	jal	ra,ffffffffc0203dec <strcmp>
ffffffffc02007ee:	66a2                	ld	a3,8(sp)
ffffffffc02007f0:	f94d                	bnez	a0,ffffffffc02007a2 <dtb_init+0x228>
ffffffffc02007f2:	fb59f8e3          	bgeu	s3,s5,ffffffffc02007a2 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02007f6:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02007fa:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007fe:	00004517          	auipc	a0,0x4
ffffffffc0200802:	a1a50513          	addi	a0,a0,-1510 # ffffffffc0204218 <commands+0x118>
           fdt32_to_cpu(x >> 32);
ffffffffc0200806:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080a:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc020080e:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200812:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200816:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020081a:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020081e:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200822:	0187d693          	srli	a3,a5,0x18
ffffffffc0200826:	01861f1b          	slliw	t5,a2,0x18
ffffffffc020082a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020082e:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200832:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200836:	010f6f33          	or	t5,t5,a6
ffffffffc020083a:	0187529b          	srliw	t0,a4,0x18
ffffffffc020083e:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200842:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200846:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020084a:	0186f6b3          	and	a3,a3,s8
ffffffffc020084e:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200852:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200856:	0107581b          	srliw	a6,a4,0x10
ffffffffc020085a:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020085e:	8361                	srli	a4,a4,0x18
ffffffffc0200860:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200864:	0105d59b          	srliw	a1,a1,0x10
ffffffffc0200868:	01e6e6b3          	or	a3,a3,t5
ffffffffc020086c:	00cb7633          	and	a2,s6,a2
ffffffffc0200870:	0088181b          	slliw	a6,a6,0x8
ffffffffc0200874:	0085959b          	slliw	a1,a1,0x8
ffffffffc0200878:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020087c:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200880:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200884:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200888:	0088989b          	slliw	a7,a7,0x8
ffffffffc020088c:	011b78b3          	and	a7,s6,a7
ffffffffc0200890:	005eeeb3          	or	t4,t4,t0
ffffffffc0200894:	00c6e733          	or	a4,a3,a2
ffffffffc0200898:	006c6c33          	or	s8,s8,t1
ffffffffc020089c:	010b76b3          	and	a3,s6,a6
ffffffffc02008a0:	00bb7b33          	and	s6,s6,a1
ffffffffc02008a4:	01d7e7b3          	or	a5,a5,t4
ffffffffc02008a8:	016c6b33          	or	s6,s8,s6
ffffffffc02008ac:	01146433          	or	s0,s0,a7
ffffffffc02008b0:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc02008b2:	1702                	slli	a4,a4,0x20
ffffffffc02008b4:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02008b6:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02008b8:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02008ba:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02008bc:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02008c0:	0167eb33          	or	s6,a5,s6
ffffffffc02008c4:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc02008c6:	8cfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc02008ca:	85a2                	mv	a1,s0
ffffffffc02008cc:	00004517          	auipc	a0,0x4
ffffffffc02008d0:	96c50513          	addi	a0,a0,-1684 # ffffffffc0204238 <commands+0x138>
ffffffffc02008d4:	8c1ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02008d8:	014b5613          	srli	a2,s6,0x14
ffffffffc02008dc:	85da                	mv	a1,s6
ffffffffc02008de:	00004517          	auipc	a0,0x4
ffffffffc02008e2:	97250513          	addi	a0,a0,-1678 # ffffffffc0204250 <commands+0x150>
ffffffffc02008e6:	8afff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008ea:	008b05b3          	add	a1,s6,s0
ffffffffc02008ee:	15fd                	addi	a1,a1,-1
ffffffffc02008f0:	00004517          	auipc	a0,0x4
ffffffffc02008f4:	98050513          	addi	a0,a0,-1664 # ffffffffc0204270 <commands+0x170>
ffffffffc02008f8:	89dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02008fc:	00004517          	auipc	a0,0x4
ffffffffc0200900:	9c450513          	addi	a0,a0,-1596 # ffffffffc02042c0 <commands+0x1c0>
        memory_base = mem_base;
ffffffffc0200904:	0000d797          	auipc	a5,0xd
ffffffffc0200908:	b687be23          	sd	s0,-1156(a5) # ffffffffc020d480 <memory_base>
        memory_size = mem_size;
ffffffffc020090c:	0000d797          	auipc	a5,0xd
ffffffffc0200910:	b767be23          	sd	s6,-1156(a5) # ffffffffc020d488 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200914:	b3f5                	j	ffffffffc0200700 <dtb_init+0x186>

ffffffffc0200916 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200916:	0000d517          	auipc	a0,0xd
ffffffffc020091a:	b6a53503          	ld	a0,-1174(a0) # ffffffffc020d480 <memory_base>
ffffffffc020091e:	8082                	ret

ffffffffc0200920 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc0200920:	0000d517          	auipc	a0,0xd
ffffffffc0200924:	b6853503          	ld	a0,-1176(a0) # ffffffffc020d488 <memory_size>
ffffffffc0200928:	8082                	ret

ffffffffc020092a <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc020092a:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020092e:	8082                	ret

ffffffffc0200930 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200930:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200934:	8082                	ret

ffffffffc0200936 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc0200936:	8082                	ret

ffffffffc0200938 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200938:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc020093c:	00000797          	auipc	a5,0x0
ffffffffc0200940:	3e878793          	addi	a5,a5,1000 # ffffffffc0200d24 <__alltraps>
ffffffffc0200944:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200948:	000407b7          	lui	a5,0x40
ffffffffc020094c:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200950:	8082                	ret

ffffffffc0200952 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200952:	610c                	ld	a1,0(a0)
{
ffffffffc0200954:	1141                	addi	sp,sp,-16
ffffffffc0200956:	e022                	sd	s0,0(sp)
ffffffffc0200958:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020095a:	00004517          	auipc	a0,0x4
ffffffffc020095e:	97e50513          	addi	a0,a0,-1666 # ffffffffc02042d8 <commands+0x1d8>
{
ffffffffc0200962:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200964:	831ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200968:	640c                	ld	a1,8(s0)
ffffffffc020096a:	00004517          	auipc	a0,0x4
ffffffffc020096e:	98650513          	addi	a0,a0,-1658 # ffffffffc02042f0 <commands+0x1f0>
ffffffffc0200972:	823ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200976:	680c                	ld	a1,16(s0)
ffffffffc0200978:	00004517          	auipc	a0,0x4
ffffffffc020097c:	99050513          	addi	a0,a0,-1648 # ffffffffc0204308 <commands+0x208>
ffffffffc0200980:	815ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200984:	6c0c                	ld	a1,24(s0)
ffffffffc0200986:	00004517          	auipc	a0,0x4
ffffffffc020098a:	99a50513          	addi	a0,a0,-1638 # ffffffffc0204320 <commands+0x220>
ffffffffc020098e:	807ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200992:	700c                	ld	a1,32(s0)
ffffffffc0200994:	00004517          	auipc	a0,0x4
ffffffffc0200998:	9a450513          	addi	a0,a0,-1628 # ffffffffc0204338 <commands+0x238>
ffffffffc020099c:	ff8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02009a0:	740c                	ld	a1,40(s0)
ffffffffc02009a2:	00004517          	auipc	a0,0x4
ffffffffc02009a6:	9ae50513          	addi	a0,a0,-1618 # ffffffffc0204350 <commands+0x250>
ffffffffc02009aa:	feaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02009ae:	780c                	ld	a1,48(s0)
ffffffffc02009b0:	00004517          	auipc	a0,0x4
ffffffffc02009b4:	9b850513          	addi	a0,a0,-1608 # ffffffffc0204368 <commands+0x268>
ffffffffc02009b8:	fdcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02009bc:	7c0c                	ld	a1,56(s0)
ffffffffc02009be:	00004517          	auipc	a0,0x4
ffffffffc02009c2:	9c250513          	addi	a0,a0,-1598 # ffffffffc0204380 <commands+0x280>
ffffffffc02009c6:	fceff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02009ca:	602c                	ld	a1,64(s0)
ffffffffc02009cc:	00004517          	auipc	a0,0x4
ffffffffc02009d0:	9cc50513          	addi	a0,a0,-1588 # ffffffffc0204398 <commands+0x298>
ffffffffc02009d4:	fc0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02009d8:	642c                	ld	a1,72(s0)
ffffffffc02009da:	00004517          	auipc	a0,0x4
ffffffffc02009de:	9d650513          	addi	a0,a0,-1578 # ffffffffc02043b0 <commands+0x2b0>
ffffffffc02009e2:	fb2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02009e6:	682c                	ld	a1,80(s0)
ffffffffc02009e8:	00004517          	auipc	a0,0x4
ffffffffc02009ec:	9e050513          	addi	a0,a0,-1568 # ffffffffc02043c8 <commands+0x2c8>
ffffffffc02009f0:	fa4ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02009f4:	6c2c                	ld	a1,88(s0)
ffffffffc02009f6:	00004517          	auipc	a0,0x4
ffffffffc02009fa:	9ea50513          	addi	a0,a0,-1558 # ffffffffc02043e0 <commands+0x2e0>
ffffffffc02009fe:	f96ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a02:	702c                	ld	a1,96(s0)
ffffffffc0200a04:	00004517          	auipc	a0,0x4
ffffffffc0200a08:	9f450513          	addi	a0,a0,-1548 # ffffffffc02043f8 <commands+0x2f8>
ffffffffc0200a0c:	f88ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a10:	742c                	ld	a1,104(s0)
ffffffffc0200a12:	00004517          	auipc	a0,0x4
ffffffffc0200a16:	9fe50513          	addi	a0,a0,-1538 # ffffffffc0204410 <commands+0x310>
ffffffffc0200a1a:	f7aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200a1e:	782c                	ld	a1,112(s0)
ffffffffc0200a20:	00004517          	auipc	a0,0x4
ffffffffc0200a24:	a0850513          	addi	a0,a0,-1528 # ffffffffc0204428 <commands+0x328>
ffffffffc0200a28:	f6cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a2c:	7c2c                	ld	a1,120(s0)
ffffffffc0200a2e:	00004517          	auipc	a0,0x4
ffffffffc0200a32:	a1250513          	addi	a0,a0,-1518 # ffffffffc0204440 <commands+0x340>
ffffffffc0200a36:	f5eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a3a:	604c                	ld	a1,128(s0)
ffffffffc0200a3c:	00004517          	auipc	a0,0x4
ffffffffc0200a40:	a1c50513          	addi	a0,a0,-1508 # ffffffffc0204458 <commands+0x358>
ffffffffc0200a44:	f50ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a48:	644c                	ld	a1,136(s0)
ffffffffc0200a4a:	00004517          	auipc	a0,0x4
ffffffffc0200a4e:	a2650513          	addi	a0,a0,-1498 # ffffffffc0204470 <commands+0x370>
ffffffffc0200a52:	f42ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200a56:	684c                	ld	a1,144(s0)
ffffffffc0200a58:	00004517          	auipc	a0,0x4
ffffffffc0200a5c:	a3050513          	addi	a0,a0,-1488 # ffffffffc0204488 <commands+0x388>
ffffffffc0200a60:	f34ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200a64:	6c4c                	ld	a1,152(s0)
ffffffffc0200a66:	00004517          	auipc	a0,0x4
ffffffffc0200a6a:	a3a50513          	addi	a0,a0,-1478 # ffffffffc02044a0 <commands+0x3a0>
ffffffffc0200a6e:	f26ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200a72:	704c                	ld	a1,160(s0)
ffffffffc0200a74:	00004517          	auipc	a0,0x4
ffffffffc0200a78:	a4450513          	addi	a0,a0,-1468 # ffffffffc02044b8 <commands+0x3b8>
ffffffffc0200a7c:	f18ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200a80:	744c                	ld	a1,168(s0)
ffffffffc0200a82:	00004517          	auipc	a0,0x4
ffffffffc0200a86:	a4e50513          	addi	a0,a0,-1458 # ffffffffc02044d0 <commands+0x3d0>
ffffffffc0200a8a:	f0aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200a8e:	784c                	ld	a1,176(s0)
ffffffffc0200a90:	00004517          	auipc	a0,0x4
ffffffffc0200a94:	a5850513          	addi	a0,a0,-1448 # ffffffffc02044e8 <commands+0x3e8>
ffffffffc0200a98:	efcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200a9c:	7c4c                	ld	a1,184(s0)
ffffffffc0200a9e:	00004517          	auipc	a0,0x4
ffffffffc0200aa2:	a6250513          	addi	a0,a0,-1438 # ffffffffc0204500 <commands+0x400>
ffffffffc0200aa6:	eeeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200aaa:	606c                	ld	a1,192(s0)
ffffffffc0200aac:	00004517          	auipc	a0,0x4
ffffffffc0200ab0:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0204518 <commands+0x418>
ffffffffc0200ab4:	ee0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200ab8:	646c                	ld	a1,200(s0)
ffffffffc0200aba:	00004517          	auipc	a0,0x4
ffffffffc0200abe:	a7650513          	addi	a0,a0,-1418 # ffffffffc0204530 <commands+0x430>
ffffffffc0200ac2:	ed2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200ac6:	686c                	ld	a1,208(s0)
ffffffffc0200ac8:	00004517          	auipc	a0,0x4
ffffffffc0200acc:	a8050513          	addi	a0,a0,-1408 # ffffffffc0204548 <commands+0x448>
ffffffffc0200ad0:	ec4ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200ad4:	6c6c                	ld	a1,216(s0)
ffffffffc0200ad6:	00004517          	auipc	a0,0x4
ffffffffc0200ada:	a8a50513          	addi	a0,a0,-1398 # ffffffffc0204560 <commands+0x460>
ffffffffc0200ade:	eb6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200ae2:	706c                	ld	a1,224(s0)
ffffffffc0200ae4:	00004517          	auipc	a0,0x4
ffffffffc0200ae8:	a9450513          	addi	a0,a0,-1388 # ffffffffc0204578 <commands+0x478>
ffffffffc0200aec:	ea8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200af0:	746c                	ld	a1,232(s0)
ffffffffc0200af2:	00004517          	auipc	a0,0x4
ffffffffc0200af6:	a9e50513          	addi	a0,a0,-1378 # ffffffffc0204590 <commands+0x490>
ffffffffc0200afa:	e9aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200afe:	786c                	ld	a1,240(s0)
ffffffffc0200b00:	00004517          	auipc	a0,0x4
ffffffffc0200b04:	aa850513          	addi	a0,a0,-1368 # ffffffffc02045a8 <commands+0x4a8>
ffffffffc0200b08:	e8cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b0c:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b0e:	6402                	ld	s0,0(sp)
ffffffffc0200b10:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b12:	00004517          	auipc	a0,0x4
ffffffffc0200b16:	aae50513          	addi	a0,a0,-1362 # ffffffffc02045c0 <commands+0x4c0>
}
ffffffffc0200b1a:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b1c:	e78ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200b20 <print_trapframe>:
{
ffffffffc0200b20:	1141                	addi	sp,sp,-16
ffffffffc0200b22:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b24:	85aa                	mv	a1,a0
{
ffffffffc0200b26:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b28:	00004517          	auipc	a0,0x4
ffffffffc0200b2c:	ab050513          	addi	a0,a0,-1360 # ffffffffc02045d8 <commands+0x4d8>
{
ffffffffc0200b30:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b32:	e62ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200b36:	8522                	mv	a0,s0
ffffffffc0200b38:	e1bff0ef          	jal	ra,ffffffffc0200952 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200b3c:	10043583          	ld	a1,256(s0)
ffffffffc0200b40:	00004517          	auipc	a0,0x4
ffffffffc0200b44:	ab050513          	addi	a0,a0,-1360 # ffffffffc02045f0 <commands+0x4f0>
ffffffffc0200b48:	e4cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b4c:	10843583          	ld	a1,264(s0)
ffffffffc0200b50:	00004517          	auipc	a0,0x4
ffffffffc0200b54:	ab850513          	addi	a0,a0,-1352 # ffffffffc0204608 <commands+0x508>
ffffffffc0200b58:	e3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200b5c:	11043583          	ld	a1,272(s0)
ffffffffc0200b60:	00004517          	auipc	a0,0x4
ffffffffc0200b64:	ac050513          	addi	a0,a0,-1344 # ffffffffc0204620 <commands+0x520>
ffffffffc0200b68:	e2cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b6c:	11843583          	ld	a1,280(s0)
}
ffffffffc0200b70:	6402                	ld	s0,0(sp)
ffffffffc0200b72:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b74:	00004517          	auipc	a0,0x4
ffffffffc0200b78:	ac450513          	addi	a0,a0,-1340 # ffffffffc0204638 <commands+0x538>
}
ffffffffc0200b7c:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b7e:	e16ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200b82 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200b82:	11853783          	ld	a5,280(a0)
ffffffffc0200b86:	472d                	li	a4,11
ffffffffc0200b88:	0786                	slli	a5,a5,0x1
ffffffffc0200b8a:	8385                	srli	a5,a5,0x1
ffffffffc0200b8c:	08f76a63          	bltu	a4,a5,ffffffffc0200c20 <interrupt_handler+0x9e>
ffffffffc0200b90:	00004717          	auipc	a4,0x4
ffffffffc0200b94:	b7070713          	addi	a4,a4,-1168 # ffffffffc0204700 <commands+0x600>
ffffffffc0200b98:	078a                	slli	a5,a5,0x2
ffffffffc0200b9a:	97ba                	add	a5,a5,a4
ffffffffc0200b9c:	439c                	lw	a5,0(a5)
ffffffffc0200b9e:	97ba                	add	a5,a5,a4
ffffffffc0200ba0:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200ba2:	00004517          	auipc	a0,0x4
ffffffffc0200ba6:	b0e50513          	addi	a0,a0,-1266 # ffffffffc02046b0 <commands+0x5b0>
ffffffffc0200baa:	deaff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200bae:	00004517          	auipc	a0,0x4
ffffffffc0200bb2:	ae250513          	addi	a0,a0,-1310 # ffffffffc0204690 <commands+0x590>
ffffffffc0200bb6:	ddeff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200bba:	00004517          	auipc	a0,0x4
ffffffffc0200bbe:	a9650513          	addi	a0,a0,-1386 # ffffffffc0204650 <commands+0x550>
ffffffffc0200bc2:	dd2ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200bc6:	00004517          	auipc	a0,0x4
ffffffffc0200bca:	aaa50513          	addi	a0,a0,-1366 # ffffffffc0204670 <commands+0x570>
ffffffffc0200bce:	dc6ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200bd2:	1141                	addi	sp,sp,-16
ffffffffc0200bd4:	e406                	sd	ra,8(sp)
        // In fact, Call sbi_set_timer will clear STIP, or you can clear it
        // directly.
        // clear_csr(sip, SIP_STIP);

        /*LAB3 请补充你在lab3中的代码 */
        clock_set_next_event();
ffffffffc0200bd6:	919ff0ef          	jal	ra,ffffffffc02004ee <clock_set_next_event>
        ticks++;
ffffffffc0200bda:	0000d797          	auipc	a5,0xd
ffffffffc0200bde:	89678793          	addi	a5,a5,-1898 # ffffffffc020d470 <ticks>
ffffffffc0200be2:	6398                	ld	a4,0(a5)
ffffffffc0200be4:	0705                	addi	a4,a4,1
ffffffffc0200be6:	e398                	sd	a4,0(a5)
        if (ticks % TICK_NUM == 0) {
ffffffffc0200be8:	639c                	ld	a5,0(a5)
ffffffffc0200bea:	06400713          	li	a4,100
ffffffffc0200bee:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200bf2:	cb85                	beqz	a5,ffffffffc0200c22 <interrupt_handler+0xa0>
            print_ticks();
            num++;
        }
        if (num == 10) {
ffffffffc0200bf4:	0000d717          	auipc	a4,0xd
ffffffffc0200bf8:	89c72703          	lw	a4,-1892(a4) # ffffffffc020d490 <num>
ffffffffc0200bfc:	47a9                	li	a5,10
ffffffffc0200bfe:	00f71863          	bne	a4,a5,ffffffffc0200c0e <interrupt_handler+0x8c>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200c02:	4501                	li	a0,0
ffffffffc0200c04:	4581                	li	a1,0
ffffffffc0200c06:	4601                	li	a2,0
ffffffffc0200c08:	48a1                	li	a7,8
ffffffffc0200c0a:	00000073          	ecall
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c0e:	60a2                	ld	ra,8(sp)
ffffffffc0200c10:	0141                	addi	sp,sp,16
ffffffffc0200c12:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c14:	00004517          	auipc	a0,0x4
ffffffffc0200c18:	acc50513          	addi	a0,a0,-1332 # ffffffffc02046e0 <commands+0x5e0>
ffffffffc0200c1c:	d78ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c20:	b701                	j	ffffffffc0200b20 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c22:	06400593          	li	a1,100
ffffffffc0200c26:	00004517          	auipc	a0,0x4
ffffffffc0200c2a:	aaa50513          	addi	a0,a0,-1366 # ffffffffc02046d0 <commands+0x5d0>
ffffffffc0200c2e:	d66ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
            num++;
ffffffffc0200c32:	0000d697          	auipc	a3,0xd
ffffffffc0200c36:	85e68693          	addi	a3,a3,-1954 # ffffffffc020d490 <num>
ffffffffc0200c3a:	429c                	lw	a5,0(a3)
ffffffffc0200c3c:	0017871b          	addiw	a4,a5,1
ffffffffc0200c40:	c298                	sw	a4,0(a3)
ffffffffc0200c42:	bf6d                	j	ffffffffc0200bfc <interrupt_handler+0x7a>

ffffffffc0200c44 <exception_handler>:

void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c44:	11853783          	ld	a5,280(a0)
ffffffffc0200c48:	473d                	li	a4,15
ffffffffc0200c4a:	0cf76563          	bltu	a4,a5,ffffffffc0200d14 <exception_handler+0xd0>
ffffffffc0200c4e:	00004717          	auipc	a4,0x4
ffffffffc0200c52:	c7a70713          	addi	a4,a4,-902 # ffffffffc02048c8 <commands+0x7c8>
ffffffffc0200c56:	078a                	slli	a5,a5,0x2
ffffffffc0200c58:	97ba                	add	a5,a5,a4
ffffffffc0200c5a:	439c                	lw	a5,0(a5)
ffffffffc0200c5c:	97ba                	add	a5,a5,a4
ffffffffc0200c5e:	8782                	jr	a5
        break;
    case CAUSE_LOAD_PAGE_FAULT:
        cprintf("Load page fault\n");
        break;
    case CAUSE_STORE_PAGE_FAULT:
        cprintf("Store/AMO page fault\n");
ffffffffc0200c60:	00004517          	auipc	a0,0x4
ffffffffc0200c64:	c5050513          	addi	a0,a0,-944 # ffffffffc02048b0 <commands+0x7b0>
ffffffffc0200c68:	d2cff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Instruction address misaligned\n");
ffffffffc0200c6c:	00004517          	auipc	a0,0x4
ffffffffc0200c70:	ac450513          	addi	a0,a0,-1340 # ffffffffc0204730 <commands+0x630>
ffffffffc0200c74:	d20ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Instruction access fault\n");
ffffffffc0200c78:	00004517          	auipc	a0,0x4
ffffffffc0200c7c:	ad850513          	addi	a0,a0,-1320 # ffffffffc0204750 <commands+0x650>
ffffffffc0200c80:	d14ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Illegal instruction\n");
ffffffffc0200c84:	00004517          	auipc	a0,0x4
ffffffffc0200c88:	aec50513          	addi	a0,a0,-1300 # ffffffffc0204770 <commands+0x670>
ffffffffc0200c8c:	d08ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Breakpoint\n");
ffffffffc0200c90:	00004517          	auipc	a0,0x4
ffffffffc0200c94:	af850513          	addi	a0,a0,-1288 # ffffffffc0204788 <commands+0x688>
ffffffffc0200c98:	cfcff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Load address misaligned\n");
ffffffffc0200c9c:	00004517          	auipc	a0,0x4
ffffffffc0200ca0:	afc50513          	addi	a0,a0,-1284 # ffffffffc0204798 <commands+0x698>
ffffffffc0200ca4:	cf0ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Load access fault\n");
ffffffffc0200ca8:	00004517          	auipc	a0,0x4
ffffffffc0200cac:	b1050513          	addi	a0,a0,-1264 # ffffffffc02047b8 <commands+0x6b8>
ffffffffc0200cb0:	ce4ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("AMO address misaligned\n");
ffffffffc0200cb4:	00004517          	auipc	a0,0x4
ffffffffc0200cb8:	b1c50513          	addi	a0,a0,-1252 # ffffffffc02047d0 <commands+0x6d0>
ffffffffc0200cbc:	cd8ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Store/AMO access fault\n");
ffffffffc0200cc0:	00004517          	auipc	a0,0x4
ffffffffc0200cc4:	b2850513          	addi	a0,a0,-1240 # ffffffffc02047e8 <commands+0x6e8>
ffffffffc0200cc8:	cccff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from U-mode\n");
ffffffffc0200ccc:	00004517          	auipc	a0,0x4
ffffffffc0200cd0:	b3450513          	addi	a0,a0,-1228 # ffffffffc0204800 <commands+0x700>
ffffffffc0200cd4:	cc0ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from S-mode\n");
ffffffffc0200cd8:	00004517          	auipc	a0,0x4
ffffffffc0200cdc:	b4850513          	addi	a0,a0,-1208 # ffffffffc0204820 <commands+0x720>
ffffffffc0200ce0:	cb4ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from H-mode\n");
ffffffffc0200ce4:	00004517          	auipc	a0,0x4
ffffffffc0200ce8:	b5c50513          	addi	a0,a0,-1188 # ffffffffc0204840 <commands+0x740>
ffffffffc0200cec:	ca8ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200cf0:	00004517          	auipc	a0,0x4
ffffffffc0200cf4:	b7050513          	addi	a0,a0,-1168 # ffffffffc0204860 <commands+0x760>
ffffffffc0200cf8:	c9cff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Instruction page fault\n");
ffffffffc0200cfc:	00004517          	auipc	a0,0x4
ffffffffc0200d00:	b8450513          	addi	a0,a0,-1148 # ffffffffc0204880 <commands+0x780>
ffffffffc0200d04:	c90ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Load page fault\n");
ffffffffc0200d08:	00004517          	auipc	a0,0x4
ffffffffc0200d0c:	b9050513          	addi	a0,a0,-1136 # ffffffffc0204898 <commands+0x798>
ffffffffc0200d10:	c84ff06f          	j	ffffffffc0200194 <cprintf>
        break;
    default:
        print_trapframe(tf);
ffffffffc0200d14:	b531                	j	ffffffffc0200b20 <print_trapframe>

ffffffffc0200d16 <trap>:
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0)
ffffffffc0200d16:	11853783          	ld	a5,280(a0)
ffffffffc0200d1a:	0007c363          	bltz	a5,ffffffffc0200d20 <trap+0xa>
        interrupt_handler(tf);
    }
    else
    {
        // exceptions
        exception_handler(tf);
ffffffffc0200d1e:	b71d                	j	ffffffffc0200c44 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200d20:	b58d                	j	ffffffffc0200b82 <interrupt_handler>
	...

ffffffffc0200d24 <__alltraps>:
    LOAD  x2,2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200d24:	14011073          	csrw	sscratch,sp
ffffffffc0200d28:	712d                	addi	sp,sp,-288
ffffffffc0200d2a:	e406                	sd	ra,8(sp)
ffffffffc0200d2c:	ec0e                	sd	gp,24(sp)
ffffffffc0200d2e:	f012                	sd	tp,32(sp)
ffffffffc0200d30:	f416                	sd	t0,40(sp)
ffffffffc0200d32:	f81a                	sd	t1,48(sp)
ffffffffc0200d34:	fc1e                	sd	t2,56(sp)
ffffffffc0200d36:	e0a2                	sd	s0,64(sp)
ffffffffc0200d38:	e4a6                	sd	s1,72(sp)
ffffffffc0200d3a:	e8aa                	sd	a0,80(sp)
ffffffffc0200d3c:	ecae                	sd	a1,88(sp)
ffffffffc0200d3e:	f0b2                	sd	a2,96(sp)
ffffffffc0200d40:	f4b6                	sd	a3,104(sp)
ffffffffc0200d42:	f8ba                	sd	a4,112(sp)
ffffffffc0200d44:	fcbe                	sd	a5,120(sp)
ffffffffc0200d46:	e142                	sd	a6,128(sp)
ffffffffc0200d48:	e546                	sd	a7,136(sp)
ffffffffc0200d4a:	e94a                	sd	s2,144(sp)
ffffffffc0200d4c:	ed4e                	sd	s3,152(sp)
ffffffffc0200d4e:	f152                	sd	s4,160(sp)
ffffffffc0200d50:	f556                	sd	s5,168(sp)
ffffffffc0200d52:	f95a                	sd	s6,176(sp)
ffffffffc0200d54:	fd5e                	sd	s7,184(sp)
ffffffffc0200d56:	e1e2                	sd	s8,192(sp)
ffffffffc0200d58:	e5e6                	sd	s9,200(sp)
ffffffffc0200d5a:	e9ea                	sd	s10,208(sp)
ffffffffc0200d5c:	edee                	sd	s11,216(sp)
ffffffffc0200d5e:	f1f2                	sd	t3,224(sp)
ffffffffc0200d60:	f5f6                	sd	t4,232(sp)
ffffffffc0200d62:	f9fa                	sd	t5,240(sp)
ffffffffc0200d64:	fdfe                	sd	t6,248(sp)
ffffffffc0200d66:	14002473          	csrr	s0,sscratch
ffffffffc0200d6a:	100024f3          	csrr	s1,sstatus
ffffffffc0200d6e:	14102973          	csrr	s2,sepc
ffffffffc0200d72:	143029f3          	csrr	s3,stval
ffffffffc0200d76:	14202a73          	csrr	s4,scause
ffffffffc0200d7a:	e822                	sd	s0,16(sp)
ffffffffc0200d7c:	e226                	sd	s1,256(sp)
ffffffffc0200d7e:	e64a                	sd	s2,264(sp)
ffffffffc0200d80:	ea4e                	sd	s3,272(sp)
ffffffffc0200d82:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200d84:	850a                	mv	a0,sp
    jal trap
ffffffffc0200d86:	f91ff0ef          	jal	ra,ffffffffc0200d16 <trap>

ffffffffc0200d8a <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200d8a:	6492                	ld	s1,256(sp)
ffffffffc0200d8c:	6932                	ld	s2,264(sp)
ffffffffc0200d8e:	10049073          	csrw	sstatus,s1
ffffffffc0200d92:	14191073          	csrw	sepc,s2
ffffffffc0200d96:	60a2                	ld	ra,8(sp)
ffffffffc0200d98:	61e2                	ld	gp,24(sp)
ffffffffc0200d9a:	7202                	ld	tp,32(sp)
ffffffffc0200d9c:	72a2                	ld	t0,40(sp)
ffffffffc0200d9e:	7342                	ld	t1,48(sp)
ffffffffc0200da0:	73e2                	ld	t2,56(sp)
ffffffffc0200da2:	6406                	ld	s0,64(sp)
ffffffffc0200da4:	64a6                	ld	s1,72(sp)
ffffffffc0200da6:	6546                	ld	a0,80(sp)
ffffffffc0200da8:	65e6                	ld	a1,88(sp)
ffffffffc0200daa:	7606                	ld	a2,96(sp)
ffffffffc0200dac:	76a6                	ld	a3,104(sp)
ffffffffc0200dae:	7746                	ld	a4,112(sp)
ffffffffc0200db0:	77e6                	ld	a5,120(sp)
ffffffffc0200db2:	680a                	ld	a6,128(sp)
ffffffffc0200db4:	68aa                	ld	a7,136(sp)
ffffffffc0200db6:	694a                	ld	s2,144(sp)
ffffffffc0200db8:	69ea                	ld	s3,152(sp)
ffffffffc0200dba:	7a0a                	ld	s4,160(sp)
ffffffffc0200dbc:	7aaa                	ld	s5,168(sp)
ffffffffc0200dbe:	7b4a                	ld	s6,176(sp)
ffffffffc0200dc0:	7bea                	ld	s7,184(sp)
ffffffffc0200dc2:	6c0e                	ld	s8,192(sp)
ffffffffc0200dc4:	6cae                	ld	s9,200(sp)
ffffffffc0200dc6:	6d4e                	ld	s10,208(sp)
ffffffffc0200dc8:	6dee                	ld	s11,216(sp)
ffffffffc0200dca:	7e0e                	ld	t3,224(sp)
ffffffffc0200dcc:	7eae                	ld	t4,232(sp)
ffffffffc0200dce:	7f4e                	ld	t5,240(sp)
ffffffffc0200dd0:	7fee                	ld	t6,248(sp)
ffffffffc0200dd2:	6142                	ld	sp,16(sp)
    # go back from supervisor call
    sret
ffffffffc0200dd4:	10200073          	sret

ffffffffc0200dd8 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200dd8:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200dda:	bf45                	j	ffffffffc0200d8a <__trapret>
	...

ffffffffc0200dde <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200dde:	00008797          	auipc	a5,0x8
ffffffffc0200de2:	65278793          	addi	a5,a5,1618 # ffffffffc0209430 <free_area>
ffffffffc0200de6:	e79c                	sd	a5,8(a5)
ffffffffc0200de8:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200dea:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200dee:	8082                	ret

ffffffffc0200df0 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200df0:	00008517          	auipc	a0,0x8
ffffffffc0200df4:	65056503          	lwu	a0,1616(a0) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200df8:	8082                	ret

ffffffffc0200dfa <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200dfa:	715d                	addi	sp,sp,-80
ffffffffc0200dfc:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200dfe:	00008417          	auipc	s0,0x8
ffffffffc0200e02:	63240413          	addi	s0,s0,1586 # ffffffffc0209430 <free_area>
ffffffffc0200e06:	641c                	ld	a5,8(s0)
ffffffffc0200e08:	e486                	sd	ra,72(sp)
ffffffffc0200e0a:	fc26                	sd	s1,56(sp)
ffffffffc0200e0c:	f84a                	sd	s2,48(sp)
ffffffffc0200e0e:	f44e                	sd	s3,40(sp)
ffffffffc0200e10:	f052                	sd	s4,32(sp)
ffffffffc0200e12:	ec56                	sd	s5,24(sp)
ffffffffc0200e14:	e85a                	sd	s6,16(sp)
ffffffffc0200e16:	e45e                	sd	s7,8(sp)
ffffffffc0200e18:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e1a:	2a878d63          	beq	a5,s0,ffffffffc02010d4 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0200e1e:	4481                	li	s1,0
ffffffffc0200e20:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200e22:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200e26:	8b09                	andi	a4,a4,2
ffffffffc0200e28:	2a070a63          	beqz	a4,ffffffffc02010dc <default_check+0x2e2>
        count ++, total += p->property;
ffffffffc0200e2c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200e30:	679c                	ld	a5,8(a5)
ffffffffc0200e32:	2905                	addiw	s2,s2,1
ffffffffc0200e34:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e36:	fe8796e3          	bne	a5,s0,ffffffffc0200e22 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200e3a:	89a6                	mv	s3,s1
ffffffffc0200e3c:	6db000ef          	jal	ra,ffffffffc0201d16 <nr_free_pages>
ffffffffc0200e40:	6f351e63          	bne	a0,s3,ffffffffc020153c <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e44:	4505                	li	a0,1
ffffffffc0200e46:	653000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200e4a:	8aaa                	mv	s5,a0
ffffffffc0200e4c:	42050863          	beqz	a0,ffffffffc020127c <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200e50:	4505                	li	a0,1
ffffffffc0200e52:	647000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200e56:	89aa                	mv	s3,a0
ffffffffc0200e58:	70050263          	beqz	a0,ffffffffc020155c <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200e5c:	4505                	li	a0,1
ffffffffc0200e5e:	63b000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200e62:	8a2a                	mv	s4,a0
ffffffffc0200e64:	48050c63          	beqz	a0,ffffffffc02012fc <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200e68:	293a8a63          	beq	s5,s3,ffffffffc02010fc <default_check+0x302>
ffffffffc0200e6c:	28aa8863          	beq	s5,a0,ffffffffc02010fc <default_check+0x302>
ffffffffc0200e70:	28a98663          	beq	s3,a0,ffffffffc02010fc <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200e74:	000aa783          	lw	a5,0(s5)
ffffffffc0200e78:	2a079263          	bnez	a5,ffffffffc020111c <default_check+0x322>
ffffffffc0200e7c:	0009a783          	lw	a5,0(s3)
ffffffffc0200e80:	28079e63          	bnez	a5,ffffffffc020111c <default_check+0x322>
ffffffffc0200e84:	411c                	lw	a5,0(a0)
ffffffffc0200e86:	28079b63          	bnez	a5,ffffffffc020111c <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0200e8a:	0000c797          	auipc	a5,0xc
ffffffffc0200e8e:	62e7b783          	ld	a5,1582(a5) # ffffffffc020d4b8 <pages>
ffffffffc0200e92:	40fa8733          	sub	a4,s5,a5
ffffffffc0200e96:	00005617          	auipc	a2,0x5
ffffffffc0200e9a:	b4a63603          	ld	a2,-1206(a2) # ffffffffc02059e0 <nbase>
ffffffffc0200e9e:	8719                	srai	a4,a4,0x6
ffffffffc0200ea0:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200ea2:	0000c697          	auipc	a3,0xc
ffffffffc0200ea6:	60e6b683          	ld	a3,1550(a3) # ffffffffc020d4b0 <npage>
ffffffffc0200eaa:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0200eac:	0732                	slli	a4,a4,0xc
ffffffffc0200eae:	28d77763          	bgeu	a4,a3,ffffffffc020113c <default_check+0x342>
    return page - pages + nbase;
ffffffffc0200eb2:	40f98733          	sub	a4,s3,a5
ffffffffc0200eb6:	8719                	srai	a4,a4,0x6
ffffffffc0200eb8:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200eba:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200ebc:	4cd77063          	bgeu	a4,a3,ffffffffc020137c <default_check+0x582>
    return page - pages + nbase;
ffffffffc0200ec0:	40f507b3          	sub	a5,a0,a5
ffffffffc0200ec4:	8799                	srai	a5,a5,0x6
ffffffffc0200ec6:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200ec8:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200eca:	30d7f963          	bgeu	a5,a3,ffffffffc02011dc <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0200ece:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200ed0:	00043c03          	ld	s8,0(s0)
ffffffffc0200ed4:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200ed8:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200edc:	e400                	sd	s0,8(s0)
ffffffffc0200ede:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200ee0:	00008797          	auipc	a5,0x8
ffffffffc0200ee4:	5607a023          	sw	zero,1376(a5) # ffffffffc0209440 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200ee8:	5b1000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200eec:	2c051863          	bnez	a0,ffffffffc02011bc <default_check+0x3c2>
    free_page(p0);
ffffffffc0200ef0:	4585                	li	a1,1
ffffffffc0200ef2:	8556                	mv	a0,s5
ffffffffc0200ef4:	5e3000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
    free_page(p1);
ffffffffc0200ef8:	4585                	li	a1,1
ffffffffc0200efa:	854e                	mv	a0,s3
ffffffffc0200efc:	5db000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
    free_page(p2);
ffffffffc0200f00:	4585                	li	a1,1
ffffffffc0200f02:	8552                	mv	a0,s4
ffffffffc0200f04:	5d3000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
    assert(nr_free == 3);
ffffffffc0200f08:	4818                	lw	a4,16(s0)
ffffffffc0200f0a:	478d                	li	a5,3
ffffffffc0200f0c:	28f71863          	bne	a4,a5,ffffffffc020119c <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f10:	4505                	li	a0,1
ffffffffc0200f12:	587000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200f16:	89aa                	mv	s3,a0
ffffffffc0200f18:	26050263          	beqz	a0,ffffffffc020117c <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200f1c:	4505                	li	a0,1
ffffffffc0200f1e:	57b000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200f22:	8aaa                	mv	s5,a0
ffffffffc0200f24:	3a050c63          	beqz	a0,ffffffffc02012dc <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200f28:	4505                	li	a0,1
ffffffffc0200f2a:	56f000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200f2e:	8a2a                	mv	s4,a0
ffffffffc0200f30:	38050663          	beqz	a0,ffffffffc02012bc <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0200f34:	4505                	li	a0,1
ffffffffc0200f36:	563000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200f3a:	36051163          	bnez	a0,ffffffffc020129c <default_check+0x4a2>
    free_page(p0);
ffffffffc0200f3e:	4585                	li	a1,1
ffffffffc0200f40:	854e                	mv	a0,s3
ffffffffc0200f42:	595000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200f46:	641c                	ld	a5,8(s0)
ffffffffc0200f48:	20878a63          	beq	a5,s0,ffffffffc020115c <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0200f4c:	4505                	li	a0,1
ffffffffc0200f4e:	54b000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200f52:	30a99563          	bne	s3,a0,ffffffffc020125c <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0200f56:	4505                	li	a0,1
ffffffffc0200f58:	541000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200f5c:	2e051063          	bnez	a0,ffffffffc020123c <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0200f60:	481c                	lw	a5,16(s0)
ffffffffc0200f62:	2a079d63          	bnez	a5,ffffffffc020121c <default_check+0x422>
    free_page(p);
ffffffffc0200f66:	854e                	mv	a0,s3
ffffffffc0200f68:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200f6a:	01843023          	sd	s8,0(s0)
ffffffffc0200f6e:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200f72:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200f76:	561000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
    free_page(p1);
ffffffffc0200f7a:	4585                	li	a1,1
ffffffffc0200f7c:	8556                	mv	a0,s5
ffffffffc0200f7e:	559000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
    free_page(p2);
ffffffffc0200f82:	4585                	li	a1,1
ffffffffc0200f84:	8552                	mv	a0,s4
ffffffffc0200f86:	551000ef          	jal	ra,ffffffffc0201cd6 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200f8a:	4515                	li	a0,5
ffffffffc0200f8c:	50d000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200f90:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200f92:	26050563          	beqz	a0,ffffffffc02011fc <default_check+0x402>
ffffffffc0200f96:	651c                	ld	a5,8(a0)
ffffffffc0200f98:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200f9a:	8b85                	andi	a5,a5,1
ffffffffc0200f9c:	54079063          	bnez	a5,ffffffffc02014dc <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200fa0:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200fa2:	00043b03          	ld	s6,0(s0)
ffffffffc0200fa6:	00843a83          	ld	s5,8(s0)
ffffffffc0200faa:	e000                	sd	s0,0(s0)
ffffffffc0200fac:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200fae:	4eb000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200fb2:	50051563          	bnez	a0,ffffffffc02014bc <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200fb6:	08098a13          	addi	s4,s3,128
ffffffffc0200fba:	8552                	mv	a0,s4
ffffffffc0200fbc:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200fbe:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0200fc2:	00008797          	auipc	a5,0x8
ffffffffc0200fc6:	4607af23          	sw	zero,1150(a5) # ffffffffc0209440 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200fca:	50d000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200fce:	4511                	li	a0,4
ffffffffc0200fd0:	4c9000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200fd4:	4c051463          	bnez	a0,ffffffffc020149c <default_check+0x6a2>
ffffffffc0200fd8:	0889b783          	ld	a5,136(s3)
ffffffffc0200fdc:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200fde:	8b85                	andi	a5,a5,1
ffffffffc0200fe0:	48078e63          	beqz	a5,ffffffffc020147c <default_check+0x682>
ffffffffc0200fe4:	0909a703          	lw	a4,144(s3)
ffffffffc0200fe8:	478d                	li	a5,3
ffffffffc0200fea:	48f71963          	bne	a4,a5,ffffffffc020147c <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200fee:	450d                	li	a0,3
ffffffffc0200ff0:	4a9000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0200ff4:	8c2a                	mv	s8,a0
ffffffffc0200ff6:	46050363          	beqz	a0,ffffffffc020145c <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0200ffa:	4505                	li	a0,1
ffffffffc0200ffc:	49d000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0201000:	42051e63          	bnez	a0,ffffffffc020143c <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0201004:	418a1c63          	bne	s4,s8,ffffffffc020141c <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201008:	4585                	li	a1,1
ffffffffc020100a:	854e                	mv	a0,s3
ffffffffc020100c:	4cb000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
    free_pages(p1, 3);
ffffffffc0201010:	458d                	li	a1,3
ffffffffc0201012:	8552                	mv	a0,s4
ffffffffc0201014:	4c3000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
ffffffffc0201018:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc020101c:	04098c13          	addi	s8,s3,64
ffffffffc0201020:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201022:	8b85                	andi	a5,a5,1
ffffffffc0201024:	3c078c63          	beqz	a5,ffffffffc02013fc <default_check+0x602>
ffffffffc0201028:	0109a703          	lw	a4,16(s3)
ffffffffc020102c:	4785                	li	a5,1
ffffffffc020102e:	3cf71763          	bne	a4,a5,ffffffffc02013fc <default_check+0x602>
ffffffffc0201032:	008a3783          	ld	a5,8(s4)
ffffffffc0201036:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201038:	8b85                	andi	a5,a5,1
ffffffffc020103a:	3a078163          	beqz	a5,ffffffffc02013dc <default_check+0x5e2>
ffffffffc020103e:	010a2703          	lw	a4,16(s4)
ffffffffc0201042:	478d                	li	a5,3
ffffffffc0201044:	38f71c63          	bne	a4,a5,ffffffffc02013dc <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201048:	4505                	li	a0,1
ffffffffc020104a:	44f000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc020104e:	36a99763          	bne	s3,a0,ffffffffc02013bc <default_check+0x5c2>
    free_page(p0);
ffffffffc0201052:	4585                	li	a1,1
ffffffffc0201054:	483000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201058:	4509                	li	a0,2
ffffffffc020105a:	43f000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc020105e:	32aa1f63          	bne	s4,a0,ffffffffc020139c <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc0201062:	4589                	li	a1,2
ffffffffc0201064:	473000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
    free_page(p2);
ffffffffc0201068:	4585                	li	a1,1
ffffffffc020106a:	8562                	mv	a0,s8
ffffffffc020106c:	46b000ef          	jal	ra,ffffffffc0201cd6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201070:	4515                	li	a0,5
ffffffffc0201072:	427000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0201076:	89aa                	mv	s3,a0
ffffffffc0201078:	48050263          	beqz	a0,ffffffffc02014fc <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc020107c:	4505                	li	a0,1
ffffffffc020107e:	41b000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
ffffffffc0201082:	2c051d63          	bnez	a0,ffffffffc020135c <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201086:	481c                	lw	a5,16(s0)
ffffffffc0201088:	2a079a63          	bnez	a5,ffffffffc020133c <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc020108c:	4595                	li	a1,5
ffffffffc020108e:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201090:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201094:	01643023          	sd	s6,0(s0)
ffffffffc0201098:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc020109c:	43b000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
    return listelm->next;
ffffffffc02010a0:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010a2:	00878963          	beq	a5,s0,ffffffffc02010b4 <default_check+0x2ba>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc02010a6:	ff87a703          	lw	a4,-8(a5)
ffffffffc02010aa:	679c                	ld	a5,8(a5)
ffffffffc02010ac:	397d                	addiw	s2,s2,-1
ffffffffc02010ae:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010b0:	fe879be3          	bne	a5,s0,ffffffffc02010a6 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02010b4:	26091463          	bnez	s2,ffffffffc020131c <default_check+0x522>
    assert(total == 0);
ffffffffc02010b8:	46049263          	bnez	s1,ffffffffc020151c <default_check+0x722>
}
ffffffffc02010bc:	60a6                	ld	ra,72(sp)
ffffffffc02010be:	6406                	ld	s0,64(sp)
ffffffffc02010c0:	74e2                	ld	s1,56(sp)
ffffffffc02010c2:	7942                	ld	s2,48(sp)
ffffffffc02010c4:	79a2                	ld	s3,40(sp)
ffffffffc02010c6:	7a02                	ld	s4,32(sp)
ffffffffc02010c8:	6ae2                	ld	s5,24(sp)
ffffffffc02010ca:	6b42                	ld	s6,16(sp)
ffffffffc02010cc:	6ba2                	ld	s7,8(sp)
ffffffffc02010ce:	6c02                	ld	s8,0(sp)
ffffffffc02010d0:	6161                	addi	sp,sp,80
ffffffffc02010d2:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010d4:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02010d6:	4481                	li	s1,0
ffffffffc02010d8:	4901                	li	s2,0
ffffffffc02010da:	b38d                	j	ffffffffc0200e3c <default_check+0x42>
        assert(PageProperty(p));
ffffffffc02010dc:	00004697          	auipc	a3,0x4
ffffffffc02010e0:	82c68693          	addi	a3,a3,-2004 # ffffffffc0204908 <commands+0x808>
ffffffffc02010e4:	00004617          	auipc	a2,0x4
ffffffffc02010e8:	83460613          	addi	a2,a2,-1996 # ffffffffc0204918 <commands+0x818>
ffffffffc02010ec:	0f000593          	li	a1,240
ffffffffc02010f0:	00004517          	auipc	a0,0x4
ffffffffc02010f4:	84050513          	addi	a0,a0,-1984 # ffffffffc0204930 <commands+0x830>
ffffffffc02010f8:	b62ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02010fc:	00004697          	auipc	a3,0x4
ffffffffc0201100:	8cc68693          	addi	a3,a3,-1844 # ffffffffc02049c8 <commands+0x8c8>
ffffffffc0201104:	00004617          	auipc	a2,0x4
ffffffffc0201108:	81460613          	addi	a2,a2,-2028 # ffffffffc0204918 <commands+0x818>
ffffffffc020110c:	0bd00593          	li	a1,189
ffffffffc0201110:	00004517          	auipc	a0,0x4
ffffffffc0201114:	82050513          	addi	a0,a0,-2016 # ffffffffc0204930 <commands+0x830>
ffffffffc0201118:	b42ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020111c:	00004697          	auipc	a3,0x4
ffffffffc0201120:	8d468693          	addi	a3,a3,-1836 # ffffffffc02049f0 <commands+0x8f0>
ffffffffc0201124:	00003617          	auipc	a2,0x3
ffffffffc0201128:	7f460613          	addi	a2,a2,2036 # ffffffffc0204918 <commands+0x818>
ffffffffc020112c:	0be00593          	li	a1,190
ffffffffc0201130:	00004517          	auipc	a0,0x4
ffffffffc0201134:	80050513          	addi	a0,a0,-2048 # ffffffffc0204930 <commands+0x830>
ffffffffc0201138:	b22ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020113c:	00004697          	auipc	a3,0x4
ffffffffc0201140:	8f468693          	addi	a3,a3,-1804 # ffffffffc0204a30 <commands+0x930>
ffffffffc0201144:	00003617          	auipc	a2,0x3
ffffffffc0201148:	7d460613          	addi	a2,a2,2004 # ffffffffc0204918 <commands+0x818>
ffffffffc020114c:	0c000593          	li	a1,192
ffffffffc0201150:	00003517          	auipc	a0,0x3
ffffffffc0201154:	7e050513          	addi	a0,a0,2016 # ffffffffc0204930 <commands+0x830>
ffffffffc0201158:	b02ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(!list_empty(&free_list));
ffffffffc020115c:	00004697          	auipc	a3,0x4
ffffffffc0201160:	95c68693          	addi	a3,a3,-1700 # ffffffffc0204ab8 <commands+0x9b8>
ffffffffc0201164:	00003617          	auipc	a2,0x3
ffffffffc0201168:	7b460613          	addi	a2,a2,1972 # ffffffffc0204918 <commands+0x818>
ffffffffc020116c:	0d900593          	li	a1,217
ffffffffc0201170:	00003517          	auipc	a0,0x3
ffffffffc0201174:	7c050513          	addi	a0,a0,1984 # ffffffffc0204930 <commands+0x830>
ffffffffc0201178:	ae2ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020117c:	00003697          	auipc	a3,0x3
ffffffffc0201180:	7ec68693          	addi	a3,a3,2028 # ffffffffc0204968 <commands+0x868>
ffffffffc0201184:	00003617          	auipc	a2,0x3
ffffffffc0201188:	79460613          	addi	a2,a2,1940 # ffffffffc0204918 <commands+0x818>
ffffffffc020118c:	0d200593          	li	a1,210
ffffffffc0201190:	00003517          	auipc	a0,0x3
ffffffffc0201194:	7a050513          	addi	a0,a0,1952 # ffffffffc0204930 <commands+0x830>
ffffffffc0201198:	ac2ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(nr_free == 3);
ffffffffc020119c:	00004697          	auipc	a3,0x4
ffffffffc02011a0:	90c68693          	addi	a3,a3,-1780 # ffffffffc0204aa8 <commands+0x9a8>
ffffffffc02011a4:	00003617          	auipc	a2,0x3
ffffffffc02011a8:	77460613          	addi	a2,a2,1908 # ffffffffc0204918 <commands+0x818>
ffffffffc02011ac:	0d000593          	li	a1,208
ffffffffc02011b0:	00003517          	auipc	a0,0x3
ffffffffc02011b4:	78050513          	addi	a0,a0,1920 # ffffffffc0204930 <commands+0x830>
ffffffffc02011b8:	aa2ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011bc:	00004697          	auipc	a3,0x4
ffffffffc02011c0:	8d468693          	addi	a3,a3,-1836 # ffffffffc0204a90 <commands+0x990>
ffffffffc02011c4:	00003617          	auipc	a2,0x3
ffffffffc02011c8:	75460613          	addi	a2,a2,1876 # ffffffffc0204918 <commands+0x818>
ffffffffc02011cc:	0cb00593          	li	a1,203
ffffffffc02011d0:	00003517          	auipc	a0,0x3
ffffffffc02011d4:	76050513          	addi	a0,a0,1888 # ffffffffc0204930 <commands+0x830>
ffffffffc02011d8:	a82ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02011dc:	00004697          	auipc	a3,0x4
ffffffffc02011e0:	89468693          	addi	a3,a3,-1900 # ffffffffc0204a70 <commands+0x970>
ffffffffc02011e4:	00003617          	auipc	a2,0x3
ffffffffc02011e8:	73460613          	addi	a2,a2,1844 # ffffffffc0204918 <commands+0x818>
ffffffffc02011ec:	0c200593          	li	a1,194
ffffffffc02011f0:	00003517          	auipc	a0,0x3
ffffffffc02011f4:	74050513          	addi	a0,a0,1856 # ffffffffc0204930 <commands+0x830>
ffffffffc02011f8:	a62ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(p0 != NULL);
ffffffffc02011fc:	00004697          	auipc	a3,0x4
ffffffffc0201200:	90468693          	addi	a3,a3,-1788 # ffffffffc0204b00 <commands+0xa00>
ffffffffc0201204:	00003617          	auipc	a2,0x3
ffffffffc0201208:	71460613          	addi	a2,a2,1812 # ffffffffc0204918 <commands+0x818>
ffffffffc020120c:	0f800593          	li	a1,248
ffffffffc0201210:	00003517          	auipc	a0,0x3
ffffffffc0201214:	72050513          	addi	a0,a0,1824 # ffffffffc0204930 <commands+0x830>
ffffffffc0201218:	a42ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(nr_free == 0);
ffffffffc020121c:	00004697          	auipc	a3,0x4
ffffffffc0201220:	8d468693          	addi	a3,a3,-1836 # ffffffffc0204af0 <commands+0x9f0>
ffffffffc0201224:	00003617          	auipc	a2,0x3
ffffffffc0201228:	6f460613          	addi	a2,a2,1780 # ffffffffc0204918 <commands+0x818>
ffffffffc020122c:	0df00593          	li	a1,223
ffffffffc0201230:	00003517          	auipc	a0,0x3
ffffffffc0201234:	70050513          	addi	a0,a0,1792 # ffffffffc0204930 <commands+0x830>
ffffffffc0201238:	a22ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_page() == NULL);
ffffffffc020123c:	00004697          	auipc	a3,0x4
ffffffffc0201240:	85468693          	addi	a3,a3,-1964 # ffffffffc0204a90 <commands+0x990>
ffffffffc0201244:	00003617          	auipc	a2,0x3
ffffffffc0201248:	6d460613          	addi	a2,a2,1748 # ffffffffc0204918 <commands+0x818>
ffffffffc020124c:	0dd00593          	li	a1,221
ffffffffc0201250:	00003517          	auipc	a0,0x3
ffffffffc0201254:	6e050513          	addi	a0,a0,1760 # ffffffffc0204930 <commands+0x830>
ffffffffc0201258:	a02ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc020125c:	00004697          	auipc	a3,0x4
ffffffffc0201260:	87468693          	addi	a3,a3,-1932 # ffffffffc0204ad0 <commands+0x9d0>
ffffffffc0201264:	00003617          	auipc	a2,0x3
ffffffffc0201268:	6b460613          	addi	a2,a2,1716 # ffffffffc0204918 <commands+0x818>
ffffffffc020126c:	0dc00593          	li	a1,220
ffffffffc0201270:	00003517          	auipc	a0,0x3
ffffffffc0201274:	6c050513          	addi	a0,a0,1728 # ffffffffc0204930 <commands+0x830>
ffffffffc0201278:	9e2ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020127c:	00003697          	auipc	a3,0x3
ffffffffc0201280:	6ec68693          	addi	a3,a3,1772 # ffffffffc0204968 <commands+0x868>
ffffffffc0201284:	00003617          	auipc	a2,0x3
ffffffffc0201288:	69460613          	addi	a2,a2,1684 # ffffffffc0204918 <commands+0x818>
ffffffffc020128c:	0b900593          	li	a1,185
ffffffffc0201290:	00003517          	auipc	a0,0x3
ffffffffc0201294:	6a050513          	addi	a0,a0,1696 # ffffffffc0204930 <commands+0x830>
ffffffffc0201298:	9c2ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_page() == NULL);
ffffffffc020129c:	00003697          	auipc	a3,0x3
ffffffffc02012a0:	7f468693          	addi	a3,a3,2036 # ffffffffc0204a90 <commands+0x990>
ffffffffc02012a4:	00003617          	auipc	a2,0x3
ffffffffc02012a8:	67460613          	addi	a2,a2,1652 # ffffffffc0204918 <commands+0x818>
ffffffffc02012ac:	0d600593          	li	a1,214
ffffffffc02012b0:	00003517          	auipc	a0,0x3
ffffffffc02012b4:	68050513          	addi	a0,a0,1664 # ffffffffc0204930 <commands+0x830>
ffffffffc02012b8:	9a2ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02012bc:	00003697          	auipc	a3,0x3
ffffffffc02012c0:	6ec68693          	addi	a3,a3,1772 # ffffffffc02049a8 <commands+0x8a8>
ffffffffc02012c4:	00003617          	auipc	a2,0x3
ffffffffc02012c8:	65460613          	addi	a2,a2,1620 # ffffffffc0204918 <commands+0x818>
ffffffffc02012cc:	0d400593          	li	a1,212
ffffffffc02012d0:	00003517          	auipc	a0,0x3
ffffffffc02012d4:	66050513          	addi	a0,a0,1632 # ffffffffc0204930 <commands+0x830>
ffffffffc02012d8:	982ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02012dc:	00003697          	auipc	a3,0x3
ffffffffc02012e0:	6ac68693          	addi	a3,a3,1708 # ffffffffc0204988 <commands+0x888>
ffffffffc02012e4:	00003617          	auipc	a2,0x3
ffffffffc02012e8:	63460613          	addi	a2,a2,1588 # ffffffffc0204918 <commands+0x818>
ffffffffc02012ec:	0d300593          	li	a1,211
ffffffffc02012f0:	00003517          	auipc	a0,0x3
ffffffffc02012f4:	64050513          	addi	a0,a0,1600 # ffffffffc0204930 <commands+0x830>
ffffffffc02012f8:	962ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02012fc:	00003697          	auipc	a3,0x3
ffffffffc0201300:	6ac68693          	addi	a3,a3,1708 # ffffffffc02049a8 <commands+0x8a8>
ffffffffc0201304:	00003617          	auipc	a2,0x3
ffffffffc0201308:	61460613          	addi	a2,a2,1556 # ffffffffc0204918 <commands+0x818>
ffffffffc020130c:	0bb00593          	li	a1,187
ffffffffc0201310:	00003517          	auipc	a0,0x3
ffffffffc0201314:	62050513          	addi	a0,a0,1568 # ffffffffc0204930 <commands+0x830>
ffffffffc0201318:	942ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(count == 0);
ffffffffc020131c:	00004697          	auipc	a3,0x4
ffffffffc0201320:	93468693          	addi	a3,a3,-1740 # ffffffffc0204c50 <commands+0xb50>
ffffffffc0201324:	00003617          	auipc	a2,0x3
ffffffffc0201328:	5f460613          	addi	a2,a2,1524 # ffffffffc0204918 <commands+0x818>
ffffffffc020132c:	12500593          	li	a1,293
ffffffffc0201330:	00003517          	auipc	a0,0x3
ffffffffc0201334:	60050513          	addi	a0,a0,1536 # ffffffffc0204930 <commands+0x830>
ffffffffc0201338:	922ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(nr_free == 0);
ffffffffc020133c:	00003697          	auipc	a3,0x3
ffffffffc0201340:	7b468693          	addi	a3,a3,1972 # ffffffffc0204af0 <commands+0x9f0>
ffffffffc0201344:	00003617          	auipc	a2,0x3
ffffffffc0201348:	5d460613          	addi	a2,a2,1492 # ffffffffc0204918 <commands+0x818>
ffffffffc020134c:	11a00593          	li	a1,282
ffffffffc0201350:	00003517          	auipc	a0,0x3
ffffffffc0201354:	5e050513          	addi	a0,a0,1504 # ffffffffc0204930 <commands+0x830>
ffffffffc0201358:	902ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_page() == NULL);
ffffffffc020135c:	00003697          	auipc	a3,0x3
ffffffffc0201360:	73468693          	addi	a3,a3,1844 # ffffffffc0204a90 <commands+0x990>
ffffffffc0201364:	00003617          	auipc	a2,0x3
ffffffffc0201368:	5b460613          	addi	a2,a2,1460 # ffffffffc0204918 <commands+0x818>
ffffffffc020136c:	11800593          	li	a1,280
ffffffffc0201370:	00003517          	auipc	a0,0x3
ffffffffc0201374:	5c050513          	addi	a0,a0,1472 # ffffffffc0204930 <commands+0x830>
ffffffffc0201378:	8e2ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020137c:	00003697          	auipc	a3,0x3
ffffffffc0201380:	6d468693          	addi	a3,a3,1748 # ffffffffc0204a50 <commands+0x950>
ffffffffc0201384:	00003617          	auipc	a2,0x3
ffffffffc0201388:	59460613          	addi	a2,a2,1428 # ffffffffc0204918 <commands+0x818>
ffffffffc020138c:	0c100593          	li	a1,193
ffffffffc0201390:	00003517          	auipc	a0,0x3
ffffffffc0201394:	5a050513          	addi	a0,a0,1440 # ffffffffc0204930 <commands+0x830>
ffffffffc0201398:	8c2ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020139c:	00004697          	auipc	a3,0x4
ffffffffc02013a0:	87468693          	addi	a3,a3,-1932 # ffffffffc0204c10 <commands+0xb10>
ffffffffc02013a4:	00003617          	auipc	a2,0x3
ffffffffc02013a8:	57460613          	addi	a2,a2,1396 # ffffffffc0204918 <commands+0x818>
ffffffffc02013ac:	11200593          	li	a1,274
ffffffffc02013b0:	00003517          	auipc	a0,0x3
ffffffffc02013b4:	58050513          	addi	a0,a0,1408 # ffffffffc0204930 <commands+0x830>
ffffffffc02013b8:	8a2ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02013bc:	00004697          	auipc	a3,0x4
ffffffffc02013c0:	83468693          	addi	a3,a3,-1996 # ffffffffc0204bf0 <commands+0xaf0>
ffffffffc02013c4:	00003617          	auipc	a2,0x3
ffffffffc02013c8:	55460613          	addi	a2,a2,1364 # ffffffffc0204918 <commands+0x818>
ffffffffc02013cc:	11000593          	li	a1,272
ffffffffc02013d0:	00003517          	auipc	a0,0x3
ffffffffc02013d4:	56050513          	addi	a0,a0,1376 # ffffffffc0204930 <commands+0x830>
ffffffffc02013d8:	882ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02013dc:	00003697          	auipc	a3,0x3
ffffffffc02013e0:	7ec68693          	addi	a3,a3,2028 # ffffffffc0204bc8 <commands+0xac8>
ffffffffc02013e4:	00003617          	auipc	a2,0x3
ffffffffc02013e8:	53460613          	addi	a2,a2,1332 # ffffffffc0204918 <commands+0x818>
ffffffffc02013ec:	10e00593          	li	a1,270
ffffffffc02013f0:	00003517          	auipc	a0,0x3
ffffffffc02013f4:	54050513          	addi	a0,a0,1344 # ffffffffc0204930 <commands+0x830>
ffffffffc02013f8:	862ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02013fc:	00003697          	auipc	a3,0x3
ffffffffc0201400:	7a468693          	addi	a3,a3,1956 # ffffffffc0204ba0 <commands+0xaa0>
ffffffffc0201404:	00003617          	auipc	a2,0x3
ffffffffc0201408:	51460613          	addi	a2,a2,1300 # ffffffffc0204918 <commands+0x818>
ffffffffc020140c:	10d00593          	li	a1,269
ffffffffc0201410:	00003517          	auipc	a0,0x3
ffffffffc0201414:	52050513          	addi	a0,a0,1312 # ffffffffc0204930 <commands+0x830>
ffffffffc0201418:	842ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(p0 + 2 == p1);
ffffffffc020141c:	00003697          	auipc	a3,0x3
ffffffffc0201420:	77468693          	addi	a3,a3,1908 # ffffffffc0204b90 <commands+0xa90>
ffffffffc0201424:	00003617          	auipc	a2,0x3
ffffffffc0201428:	4f460613          	addi	a2,a2,1268 # ffffffffc0204918 <commands+0x818>
ffffffffc020142c:	10800593          	li	a1,264
ffffffffc0201430:	00003517          	auipc	a0,0x3
ffffffffc0201434:	50050513          	addi	a0,a0,1280 # ffffffffc0204930 <commands+0x830>
ffffffffc0201438:	822ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_page() == NULL);
ffffffffc020143c:	00003697          	auipc	a3,0x3
ffffffffc0201440:	65468693          	addi	a3,a3,1620 # ffffffffc0204a90 <commands+0x990>
ffffffffc0201444:	00003617          	auipc	a2,0x3
ffffffffc0201448:	4d460613          	addi	a2,a2,1236 # ffffffffc0204918 <commands+0x818>
ffffffffc020144c:	10700593          	li	a1,263
ffffffffc0201450:	00003517          	auipc	a0,0x3
ffffffffc0201454:	4e050513          	addi	a0,a0,1248 # ffffffffc0204930 <commands+0x830>
ffffffffc0201458:	802ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020145c:	00003697          	auipc	a3,0x3
ffffffffc0201460:	71468693          	addi	a3,a3,1812 # ffffffffc0204b70 <commands+0xa70>
ffffffffc0201464:	00003617          	auipc	a2,0x3
ffffffffc0201468:	4b460613          	addi	a2,a2,1204 # ffffffffc0204918 <commands+0x818>
ffffffffc020146c:	10600593          	li	a1,262
ffffffffc0201470:	00003517          	auipc	a0,0x3
ffffffffc0201474:	4c050513          	addi	a0,a0,1216 # ffffffffc0204930 <commands+0x830>
ffffffffc0201478:	fe3fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020147c:	00003697          	auipc	a3,0x3
ffffffffc0201480:	6c468693          	addi	a3,a3,1732 # ffffffffc0204b40 <commands+0xa40>
ffffffffc0201484:	00003617          	auipc	a2,0x3
ffffffffc0201488:	49460613          	addi	a2,a2,1172 # ffffffffc0204918 <commands+0x818>
ffffffffc020148c:	10500593          	li	a1,261
ffffffffc0201490:	00003517          	auipc	a0,0x3
ffffffffc0201494:	4a050513          	addi	a0,a0,1184 # ffffffffc0204930 <commands+0x830>
ffffffffc0201498:	fc3fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc020149c:	00003697          	auipc	a3,0x3
ffffffffc02014a0:	68c68693          	addi	a3,a3,1676 # ffffffffc0204b28 <commands+0xa28>
ffffffffc02014a4:	00003617          	auipc	a2,0x3
ffffffffc02014a8:	47460613          	addi	a2,a2,1140 # ffffffffc0204918 <commands+0x818>
ffffffffc02014ac:	10400593          	li	a1,260
ffffffffc02014b0:	00003517          	auipc	a0,0x3
ffffffffc02014b4:	48050513          	addi	a0,a0,1152 # ffffffffc0204930 <commands+0x830>
ffffffffc02014b8:	fa3fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014bc:	00003697          	auipc	a3,0x3
ffffffffc02014c0:	5d468693          	addi	a3,a3,1492 # ffffffffc0204a90 <commands+0x990>
ffffffffc02014c4:	00003617          	auipc	a2,0x3
ffffffffc02014c8:	45460613          	addi	a2,a2,1108 # ffffffffc0204918 <commands+0x818>
ffffffffc02014cc:	0fe00593          	li	a1,254
ffffffffc02014d0:	00003517          	auipc	a0,0x3
ffffffffc02014d4:	46050513          	addi	a0,a0,1120 # ffffffffc0204930 <commands+0x830>
ffffffffc02014d8:	f83fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(!PageProperty(p0));
ffffffffc02014dc:	00003697          	auipc	a3,0x3
ffffffffc02014e0:	63468693          	addi	a3,a3,1588 # ffffffffc0204b10 <commands+0xa10>
ffffffffc02014e4:	00003617          	auipc	a2,0x3
ffffffffc02014e8:	43460613          	addi	a2,a2,1076 # ffffffffc0204918 <commands+0x818>
ffffffffc02014ec:	0f900593          	li	a1,249
ffffffffc02014f0:	00003517          	auipc	a0,0x3
ffffffffc02014f4:	44050513          	addi	a0,a0,1088 # ffffffffc0204930 <commands+0x830>
ffffffffc02014f8:	f63fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02014fc:	00003697          	auipc	a3,0x3
ffffffffc0201500:	73468693          	addi	a3,a3,1844 # ffffffffc0204c30 <commands+0xb30>
ffffffffc0201504:	00003617          	auipc	a2,0x3
ffffffffc0201508:	41460613          	addi	a2,a2,1044 # ffffffffc0204918 <commands+0x818>
ffffffffc020150c:	11700593          	li	a1,279
ffffffffc0201510:	00003517          	auipc	a0,0x3
ffffffffc0201514:	42050513          	addi	a0,a0,1056 # ffffffffc0204930 <commands+0x830>
ffffffffc0201518:	f43fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(total == 0);
ffffffffc020151c:	00003697          	auipc	a3,0x3
ffffffffc0201520:	74468693          	addi	a3,a3,1860 # ffffffffc0204c60 <commands+0xb60>
ffffffffc0201524:	00003617          	auipc	a2,0x3
ffffffffc0201528:	3f460613          	addi	a2,a2,1012 # ffffffffc0204918 <commands+0x818>
ffffffffc020152c:	12600593          	li	a1,294
ffffffffc0201530:	00003517          	auipc	a0,0x3
ffffffffc0201534:	40050513          	addi	a0,a0,1024 # ffffffffc0204930 <commands+0x830>
ffffffffc0201538:	f23fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(total == nr_free_pages());
ffffffffc020153c:	00003697          	auipc	a3,0x3
ffffffffc0201540:	40c68693          	addi	a3,a3,1036 # ffffffffc0204948 <commands+0x848>
ffffffffc0201544:	00003617          	auipc	a2,0x3
ffffffffc0201548:	3d460613          	addi	a2,a2,980 # ffffffffc0204918 <commands+0x818>
ffffffffc020154c:	0f300593          	li	a1,243
ffffffffc0201550:	00003517          	auipc	a0,0x3
ffffffffc0201554:	3e050513          	addi	a0,a0,992 # ffffffffc0204930 <commands+0x830>
ffffffffc0201558:	f03fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020155c:	00003697          	auipc	a3,0x3
ffffffffc0201560:	42c68693          	addi	a3,a3,1068 # ffffffffc0204988 <commands+0x888>
ffffffffc0201564:	00003617          	auipc	a2,0x3
ffffffffc0201568:	3b460613          	addi	a2,a2,948 # ffffffffc0204918 <commands+0x818>
ffffffffc020156c:	0ba00593          	li	a1,186
ffffffffc0201570:	00003517          	auipc	a0,0x3
ffffffffc0201574:	3c050513          	addi	a0,a0,960 # ffffffffc0204930 <commands+0x830>
ffffffffc0201578:	ee3fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc020157c <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc020157c:	1141                	addi	sp,sp,-16
ffffffffc020157e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201580:	14058463          	beqz	a1,ffffffffc02016c8 <default_free_pages+0x14c>
    for (; p != base + n; p ++) {
ffffffffc0201584:	00659693          	slli	a3,a1,0x6
ffffffffc0201588:	96aa                	add	a3,a3,a0
ffffffffc020158a:	87aa                	mv	a5,a0
ffffffffc020158c:	02d50263          	beq	a0,a3,ffffffffc02015b0 <default_free_pages+0x34>
ffffffffc0201590:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201592:	8b05                	andi	a4,a4,1
ffffffffc0201594:	10071a63          	bnez	a4,ffffffffc02016a8 <default_free_pages+0x12c>
ffffffffc0201598:	6798                	ld	a4,8(a5)
ffffffffc020159a:	8b09                	andi	a4,a4,2
ffffffffc020159c:	10071663          	bnez	a4,ffffffffc02016a8 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc02015a0:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02015a4:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02015a8:	04078793          	addi	a5,a5,64
ffffffffc02015ac:	fed792e3          	bne	a5,a3,ffffffffc0201590 <default_free_pages+0x14>
    base->property = n;
ffffffffc02015b0:	2581                	sext.w	a1,a1
ffffffffc02015b2:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02015b4:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02015b8:	4789                	li	a5,2
ffffffffc02015ba:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02015be:	00008697          	auipc	a3,0x8
ffffffffc02015c2:	e7268693          	addi	a3,a3,-398 # ffffffffc0209430 <free_area>
ffffffffc02015c6:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02015c8:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02015ca:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02015ce:	9db9                	addw	a1,a1,a4
ffffffffc02015d0:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02015d2:	0ad78463          	beq	a5,a3,ffffffffc020167a <default_free_pages+0xfe>
            struct Page* page = le2page(le, page_link);
ffffffffc02015d6:	fe878713          	addi	a4,a5,-24
ffffffffc02015da:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02015de:	4581                	li	a1,0
            if (base < page) {
ffffffffc02015e0:	00e56a63          	bltu	a0,a4,ffffffffc02015f4 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02015e4:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02015e6:	04d70c63          	beq	a4,a3,ffffffffc020163e <default_free_pages+0xc2>
    for (; p != base + n; p ++) {
ffffffffc02015ea:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02015ec:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02015f0:	fee57ae3          	bgeu	a0,a4,ffffffffc02015e4 <default_free_pages+0x68>
ffffffffc02015f4:	c199                	beqz	a1,ffffffffc02015fa <default_free_pages+0x7e>
ffffffffc02015f6:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02015fa:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02015fc:	e390                	sd	a2,0(a5)
ffffffffc02015fe:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201600:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201602:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc0201604:	00d70d63          	beq	a4,a3,ffffffffc020161e <default_free_pages+0xa2>
        if (p + p->property == base) {
ffffffffc0201608:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc020160c:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base) {
ffffffffc0201610:	02059813          	slli	a6,a1,0x20
ffffffffc0201614:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201618:	97b2                	add	a5,a5,a2
ffffffffc020161a:	02f50c63          	beq	a0,a5,ffffffffc0201652 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc020161e:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc0201620:	00d78c63          	beq	a5,a3,ffffffffc0201638 <default_free_pages+0xbc>
        if (base + base->property == p) {
ffffffffc0201624:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201626:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p) {
ffffffffc020162a:	02061593          	slli	a1,a2,0x20
ffffffffc020162e:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201632:	972a                	add	a4,a4,a0
ffffffffc0201634:	04e68a63          	beq	a3,a4,ffffffffc0201688 <default_free_pages+0x10c>
}
ffffffffc0201638:	60a2                	ld	ra,8(sp)
ffffffffc020163a:	0141                	addi	sp,sp,16
ffffffffc020163c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020163e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201640:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201642:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201644:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201646:	02d70763          	beq	a4,a3,ffffffffc0201674 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc020164a:	8832                	mv	a6,a2
ffffffffc020164c:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc020164e:	87ba                	mv	a5,a4
ffffffffc0201650:	bf71                	j	ffffffffc02015ec <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201652:	491c                	lw	a5,16(a0)
ffffffffc0201654:	9dbd                	addw	a1,a1,a5
ffffffffc0201656:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020165a:	57f5                	li	a5,-3
ffffffffc020165c:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201660:	01853803          	ld	a6,24(a0)
ffffffffc0201664:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201666:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201668:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc020166c:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020166e:	0105b023          	sd	a6,0(a1)
ffffffffc0201672:	b77d                	j	ffffffffc0201620 <default_free_pages+0xa4>
ffffffffc0201674:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201676:	873e                	mv	a4,a5
ffffffffc0201678:	bf41                	j	ffffffffc0201608 <default_free_pages+0x8c>
}
ffffffffc020167a:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020167c:	e390                	sd	a2,0(a5)
ffffffffc020167e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201680:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201682:	ed1c                	sd	a5,24(a0)
ffffffffc0201684:	0141                	addi	sp,sp,16
ffffffffc0201686:	8082                	ret
            base->property += p->property;
ffffffffc0201688:	ff87a703          	lw	a4,-8(a5)
ffffffffc020168c:	ff078693          	addi	a3,a5,-16
ffffffffc0201690:	9e39                	addw	a2,a2,a4
ffffffffc0201692:	c910                	sw	a2,16(a0)
ffffffffc0201694:	5775                	li	a4,-3
ffffffffc0201696:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020169a:	6398                	ld	a4,0(a5)
ffffffffc020169c:	679c                	ld	a5,8(a5)
}
ffffffffc020169e:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02016a0:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02016a2:	e398                	sd	a4,0(a5)
ffffffffc02016a4:	0141                	addi	sp,sp,16
ffffffffc02016a6:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02016a8:	00003697          	auipc	a3,0x3
ffffffffc02016ac:	5d068693          	addi	a3,a3,1488 # ffffffffc0204c78 <commands+0xb78>
ffffffffc02016b0:	00003617          	auipc	a2,0x3
ffffffffc02016b4:	26860613          	addi	a2,a2,616 # ffffffffc0204918 <commands+0x818>
ffffffffc02016b8:	08300593          	li	a1,131
ffffffffc02016bc:	00003517          	auipc	a0,0x3
ffffffffc02016c0:	27450513          	addi	a0,a0,628 # ffffffffc0204930 <commands+0x830>
ffffffffc02016c4:	d97fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(n > 0);
ffffffffc02016c8:	00003697          	auipc	a3,0x3
ffffffffc02016cc:	5a868693          	addi	a3,a3,1448 # ffffffffc0204c70 <commands+0xb70>
ffffffffc02016d0:	00003617          	auipc	a2,0x3
ffffffffc02016d4:	24860613          	addi	a2,a2,584 # ffffffffc0204918 <commands+0x818>
ffffffffc02016d8:	08000593          	li	a1,128
ffffffffc02016dc:	00003517          	auipc	a0,0x3
ffffffffc02016e0:	25450513          	addi	a0,a0,596 # ffffffffc0204930 <commands+0x830>
ffffffffc02016e4:	d77fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc02016e8 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02016e8:	c941                	beqz	a0,ffffffffc0201778 <default_alloc_pages+0x90>
    if (n > nr_free) {
ffffffffc02016ea:	00008597          	auipc	a1,0x8
ffffffffc02016ee:	d4658593          	addi	a1,a1,-698 # ffffffffc0209430 <free_area>
ffffffffc02016f2:	0105a803          	lw	a6,16(a1)
ffffffffc02016f6:	872a                	mv	a4,a0
ffffffffc02016f8:	02081793          	slli	a5,a6,0x20
ffffffffc02016fc:	9381                	srli	a5,a5,0x20
ffffffffc02016fe:	00a7ee63          	bltu	a5,a0,ffffffffc020171a <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201702:	87ae                	mv	a5,a1
ffffffffc0201704:	a801                	j	ffffffffc0201714 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc0201706:	ff87a683          	lw	a3,-8(a5)
ffffffffc020170a:	02069613          	slli	a2,a3,0x20
ffffffffc020170e:	9201                	srli	a2,a2,0x20
ffffffffc0201710:	00e67763          	bgeu	a2,a4,ffffffffc020171e <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201714:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201716:	feb798e3          	bne	a5,a1,ffffffffc0201706 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc020171a:	4501                	li	a0,0
}
ffffffffc020171c:	8082                	ret
    return listelm->prev;
ffffffffc020171e:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201722:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201726:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc020172a:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc020172e:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0201732:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc0201736:	02c77863          	bgeu	a4,a2,ffffffffc0201766 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc020173a:	071a                	slli	a4,a4,0x6
ffffffffc020173c:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc020173e:	41c686bb          	subw	a3,a3,t3
ffffffffc0201742:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201744:	00870613          	addi	a2,a4,8
ffffffffc0201748:	4689                	li	a3,2
ffffffffc020174a:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc020174e:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0201752:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201756:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc020175a:	e290                	sd	a2,0(a3)
ffffffffc020175c:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0201760:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0201762:	01173c23          	sd	a7,24(a4)
ffffffffc0201766:	41c8083b          	subw	a6,a6,t3
ffffffffc020176a:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020176e:	5775                	li	a4,-3
ffffffffc0201770:	17c1                	addi	a5,a5,-16
ffffffffc0201772:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201776:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc0201778:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020177a:	00003697          	auipc	a3,0x3
ffffffffc020177e:	4f668693          	addi	a3,a3,1270 # ffffffffc0204c70 <commands+0xb70>
ffffffffc0201782:	00003617          	auipc	a2,0x3
ffffffffc0201786:	19660613          	addi	a2,a2,406 # ffffffffc0204918 <commands+0x818>
ffffffffc020178a:	06200593          	li	a1,98
ffffffffc020178e:	00003517          	auipc	a0,0x3
ffffffffc0201792:	1a250513          	addi	a0,a0,418 # ffffffffc0204930 <commands+0x830>
default_alloc_pages(size_t n) {
ffffffffc0201796:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201798:	cc3fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc020179c <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc020179c:	1141                	addi	sp,sp,-16
ffffffffc020179e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02017a0:	c5f1                	beqz	a1,ffffffffc020186c <default_init_memmap+0xd0>
    for (; p != base + n; p ++) {
ffffffffc02017a2:	00659693          	slli	a3,a1,0x6
ffffffffc02017a6:	96aa                	add	a3,a3,a0
ffffffffc02017a8:	87aa                	mv	a5,a0
ffffffffc02017aa:	00d50f63          	beq	a0,a3,ffffffffc02017c8 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02017ae:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02017b0:	8b05                	andi	a4,a4,1
ffffffffc02017b2:	cf49                	beqz	a4,ffffffffc020184c <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02017b4:	0007a823          	sw	zero,16(a5)
ffffffffc02017b8:	0007b423          	sd	zero,8(a5)
ffffffffc02017bc:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02017c0:	04078793          	addi	a5,a5,64
ffffffffc02017c4:	fed795e3          	bne	a5,a3,ffffffffc02017ae <default_init_memmap+0x12>
    base->property = n;
ffffffffc02017c8:	2581                	sext.w	a1,a1
ffffffffc02017ca:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017cc:	4789                	li	a5,2
ffffffffc02017ce:	00850713          	addi	a4,a0,8
ffffffffc02017d2:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02017d6:	00008697          	auipc	a3,0x8
ffffffffc02017da:	c5a68693          	addi	a3,a3,-934 # ffffffffc0209430 <free_area>
ffffffffc02017de:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02017e0:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02017e2:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02017e6:	9db9                	addw	a1,a1,a4
ffffffffc02017e8:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02017ea:	04d78a63          	beq	a5,a3,ffffffffc020183e <default_init_memmap+0xa2>
            struct Page* page = le2page(le, page_link);
ffffffffc02017ee:	fe878713          	addi	a4,a5,-24
ffffffffc02017f2:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02017f6:	4581                	li	a1,0
            if (base < page) {
ffffffffc02017f8:	00e56a63          	bltu	a0,a4,ffffffffc020180c <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02017fc:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02017fe:	02d70263          	beq	a4,a3,ffffffffc0201822 <default_init_memmap+0x86>
    for (; p != base + n; p ++) {
ffffffffc0201802:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201804:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201808:	fee57ae3          	bgeu	a0,a4,ffffffffc02017fc <default_init_memmap+0x60>
ffffffffc020180c:	c199                	beqz	a1,ffffffffc0201812 <default_init_memmap+0x76>
ffffffffc020180e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201812:	6398                	ld	a4,0(a5)
}
ffffffffc0201814:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201816:	e390                	sd	a2,0(a5)
ffffffffc0201818:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc020181a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020181c:	ed18                	sd	a4,24(a0)
ffffffffc020181e:	0141                	addi	sp,sp,16
ffffffffc0201820:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201822:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201824:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201826:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201828:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc020182a:	00d70663          	beq	a4,a3,ffffffffc0201836 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc020182e:	8832                	mv	a6,a2
ffffffffc0201830:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201832:	87ba                	mv	a5,a4
ffffffffc0201834:	bfc1                	j	ffffffffc0201804 <default_init_memmap+0x68>
}
ffffffffc0201836:	60a2                	ld	ra,8(sp)
ffffffffc0201838:	e290                	sd	a2,0(a3)
ffffffffc020183a:	0141                	addi	sp,sp,16
ffffffffc020183c:	8082                	ret
ffffffffc020183e:	60a2                	ld	ra,8(sp)
ffffffffc0201840:	e390                	sd	a2,0(a5)
ffffffffc0201842:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201844:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201846:	ed1c                	sd	a5,24(a0)
ffffffffc0201848:	0141                	addi	sp,sp,16
ffffffffc020184a:	8082                	ret
        assert(PageReserved(p));
ffffffffc020184c:	00003697          	auipc	a3,0x3
ffffffffc0201850:	45468693          	addi	a3,a3,1108 # ffffffffc0204ca0 <commands+0xba0>
ffffffffc0201854:	00003617          	auipc	a2,0x3
ffffffffc0201858:	0c460613          	addi	a2,a2,196 # ffffffffc0204918 <commands+0x818>
ffffffffc020185c:	04900593          	li	a1,73
ffffffffc0201860:	00003517          	auipc	a0,0x3
ffffffffc0201864:	0d050513          	addi	a0,a0,208 # ffffffffc0204930 <commands+0x830>
ffffffffc0201868:	bf3fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(n > 0);
ffffffffc020186c:	00003697          	auipc	a3,0x3
ffffffffc0201870:	40468693          	addi	a3,a3,1028 # ffffffffc0204c70 <commands+0xb70>
ffffffffc0201874:	00003617          	auipc	a2,0x3
ffffffffc0201878:	0a460613          	addi	a2,a2,164 # ffffffffc0204918 <commands+0x818>
ffffffffc020187c:	04600593          	li	a1,70
ffffffffc0201880:	00003517          	auipc	a0,0x3
ffffffffc0201884:	0b050513          	addi	a0,a0,176 # ffffffffc0204930 <commands+0x830>
ffffffffc0201888:	bd3fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc020188c <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc020188c:	c94d                	beqz	a0,ffffffffc020193e <slob_free+0xb2>
{
ffffffffc020188e:	1141                	addi	sp,sp,-16
ffffffffc0201890:	e022                	sd	s0,0(sp)
ffffffffc0201892:	e406                	sd	ra,8(sp)
ffffffffc0201894:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201896:	e9c1                	bnez	a1,ffffffffc0201926 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201898:	100027f3          	csrr	a5,sstatus
ffffffffc020189c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020189e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02018a0:	ebd9                	bnez	a5,ffffffffc0201936 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02018a2:	00007617          	auipc	a2,0x7
ffffffffc02018a6:	77e60613          	addi	a2,a2,1918 # ffffffffc0209020 <slobfree>
ffffffffc02018aa:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02018ac:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02018ae:	679c                	ld	a5,8(a5)
ffffffffc02018b0:	02877a63          	bgeu	a4,s0,ffffffffc02018e4 <slob_free+0x58>
ffffffffc02018b4:	00f46463          	bltu	s0,a5,ffffffffc02018bc <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02018b8:	fef76ae3          	bltu	a4,a5,ffffffffc02018ac <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc02018bc:	400c                	lw	a1,0(s0)
ffffffffc02018be:	00459693          	slli	a3,a1,0x4
ffffffffc02018c2:	96a2                	add	a3,a3,s0
ffffffffc02018c4:	02d78a63          	beq	a5,a3,ffffffffc02018f8 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc02018c8:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc02018ca:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc02018cc:	00469793          	slli	a5,a3,0x4
ffffffffc02018d0:	97ba                	add	a5,a5,a4
ffffffffc02018d2:	02f40e63          	beq	s0,a5,ffffffffc020190e <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc02018d6:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc02018d8:	e218                	sd	a4,0(a2)
    if (flag) {
ffffffffc02018da:	e129                	bnez	a0,ffffffffc020191c <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc02018dc:	60a2                	ld	ra,8(sp)
ffffffffc02018de:	6402                	ld	s0,0(sp)
ffffffffc02018e0:	0141                	addi	sp,sp,16
ffffffffc02018e2:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02018e4:	fcf764e3          	bltu	a4,a5,ffffffffc02018ac <slob_free+0x20>
ffffffffc02018e8:	fcf472e3          	bgeu	s0,a5,ffffffffc02018ac <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc02018ec:	400c                	lw	a1,0(s0)
ffffffffc02018ee:	00459693          	slli	a3,a1,0x4
ffffffffc02018f2:	96a2                	add	a3,a3,s0
ffffffffc02018f4:	fcd79ae3          	bne	a5,a3,ffffffffc02018c8 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc02018f8:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc02018fa:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc02018fc:	9db5                	addw	a1,a1,a3
ffffffffc02018fe:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201900:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201902:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201904:	00469793          	slli	a5,a3,0x4
ffffffffc0201908:	97ba                	add	a5,a5,a4
ffffffffc020190a:	fcf416e3          	bne	s0,a5,ffffffffc02018d6 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc020190e:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201910:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201912:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201914:	9ebd                	addw	a3,a3,a5
ffffffffc0201916:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201918:	e70c                	sd	a1,8(a4)
ffffffffc020191a:	d169                	beqz	a0,ffffffffc02018dc <slob_free+0x50>
}
ffffffffc020191c:	6402                	ld	s0,0(sp)
ffffffffc020191e:	60a2                	ld	ra,8(sp)
ffffffffc0201920:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201922:	808ff06f          	j	ffffffffc020092a <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201926:	25bd                	addiw	a1,a1,15
ffffffffc0201928:	8191                	srli	a1,a1,0x4
ffffffffc020192a:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020192c:	100027f3          	csrr	a5,sstatus
ffffffffc0201930:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201932:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201934:	d7bd                	beqz	a5,ffffffffc02018a2 <slob_free+0x16>
        intr_disable();
ffffffffc0201936:	ffbfe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        return 1;
ffffffffc020193a:	4505                	li	a0,1
ffffffffc020193c:	b79d                	j	ffffffffc02018a2 <slob_free+0x16>
ffffffffc020193e:	8082                	ret

ffffffffc0201940 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201940:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201942:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201944:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201948:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc020194a:	34e000ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
	if (!page)
ffffffffc020194e:	c91d                	beqz	a0,ffffffffc0201984 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201950:	0000c697          	auipc	a3,0xc
ffffffffc0201954:	b686b683          	ld	a3,-1176(a3) # ffffffffc020d4b8 <pages>
ffffffffc0201958:	8d15                	sub	a0,a0,a3
ffffffffc020195a:	8519                	srai	a0,a0,0x6
ffffffffc020195c:	00004697          	auipc	a3,0x4
ffffffffc0201960:	0846b683          	ld	a3,132(a3) # ffffffffc02059e0 <nbase>
ffffffffc0201964:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201966:	00c51793          	slli	a5,a0,0xc
ffffffffc020196a:	83b1                	srli	a5,a5,0xc
ffffffffc020196c:	0000c717          	auipc	a4,0xc
ffffffffc0201970:	b4473703          	ld	a4,-1212(a4) # ffffffffc020d4b0 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201974:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201976:	00e7fa63          	bgeu	a5,a4,ffffffffc020198a <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc020197a:	0000c697          	auipc	a3,0xc
ffffffffc020197e:	b4e6b683          	ld	a3,-1202(a3) # ffffffffc020d4c8 <va_pa_offset>
ffffffffc0201982:	9536                	add	a0,a0,a3
}
ffffffffc0201984:	60a2                	ld	ra,8(sp)
ffffffffc0201986:	0141                	addi	sp,sp,16
ffffffffc0201988:	8082                	ret
ffffffffc020198a:	86aa                	mv	a3,a0
ffffffffc020198c:	00003617          	auipc	a2,0x3
ffffffffc0201990:	37460613          	addi	a2,a2,884 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0201994:	07100593          	li	a1,113
ffffffffc0201998:	00003517          	auipc	a0,0x3
ffffffffc020199c:	39050513          	addi	a0,a0,912 # ffffffffc0204d28 <default_pmm_manager+0x60>
ffffffffc02019a0:	abbfe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc02019a4 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc02019a4:	1101                	addi	sp,sp,-32
ffffffffc02019a6:	ec06                	sd	ra,24(sp)
ffffffffc02019a8:	e822                	sd	s0,16(sp)
ffffffffc02019aa:	e426                	sd	s1,8(sp)
ffffffffc02019ac:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc02019ae:	01050713          	addi	a4,a0,16
ffffffffc02019b2:	6785                	lui	a5,0x1
ffffffffc02019b4:	0cf77363          	bgeu	a4,a5,ffffffffc0201a7a <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc02019b8:	00f50493          	addi	s1,a0,15
ffffffffc02019bc:	8091                	srli	s1,s1,0x4
ffffffffc02019be:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02019c0:	10002673          	csrr	a2,sstatus
ffffffffc02019c4:	8a09                	andi	a2,a2,2
ffffffffc02019c6:	e25d                	bnez	a2,ffffffffc0201a6c <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc02019c8:	00007917          	auipc	s2,0x7
ffffffffc02019cc:	65890913          	addi	s2,s2,1624 # ffffffffc0209020 <slobfree>
ffffffffc02019d0:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02019d4:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc02019d6:	4398                	lw	a4,0(a5)
ffffffffc02019d8:	08975e63          	bge	a4,s1,ffffffffc0201a74 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc02019dc:	00d78b63          	beq	a5,a3,ffffffffc02019f2 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02019e0:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc02019e2:	4018                	lw	a4,0(s0)
ffffffffc02019e4:	02975a63          	bge	a4,s1,ffffffffc0201a18 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc02019e8:	00093683          	ld	a3,0(s2)
ffffffffc02019ec:	87a2                	mv	a5,s0
ffffffffc02019ee:	fed799e3          	bne	a5,a3,ffffffffc02019e0 <slob_alloc.constprop.0+0x3c>
    if (flag) {
ffffffffc02019f2:	ee31                	bnez	a2,ffffffffc0201a4e <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc02019f4:	4501                	li	a0,0
ffffffffc02019f6:	f4bff0ef          	jal	ra,ffffffffc0201940 <__slob_get_free_pages.constprop.0>
ffffffffc02019fa:	842a                	mv	s0,a0
			if (!cur)
ffffffffc02019fc:	cd05                	beqz	a0,ffffffffc0201a34 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc02019fe:	6585                	lui	a1,0x1
ffffffffc0201a00:	e8dff0ef          	jal	ra,ffffffffc020188c <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201a04:	10002673          	csrr	a2,sstatus
ffffffffc0201a08:	8a09                	andi	a2,a2,2
ffffffffc0201a0a:	ee05                	bnez	a2,ffffffffc0201a42 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201a0c:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201a10:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201a12:	4018                	lw	a4,0(s0)
ffffffffc0201a14:	fc974ae3          	blt	a4,s1,ffffffffc02019e8 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201a18:	04e48763          	beq	s1,a4,ffffffffc0201a66 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201a1c:	00449693          	slli	a3,s1,0x4
ffffffffc0201a20:	96a2                	add	a3,a3,s0
ffffffffc0201a22:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201a24:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201a26:	9f05                	subw	a4,a4,s1
ffffffffc0201a28:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201a2a:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201a2c:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201a2e:	00f93023          	sd	a5,0(s2)
    if (flag) {
ffffffffc0201a32:	e20d                	bnez	a2,ffffffffc0201a54 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201a34:	60e2                	ld	ra,24(sp)
ffffffffc0201a36:	8522                	mv	a0,s0
ffffffffc0201a38:	6442                	ld	s0,16(sp)
ffffffffc0201a3a:	64a2                	ld	s1,8(sp)
ffffffffc0201a3c:	6902                	ld	s2,0(sp)
ffffffffc0201a3e:	6105                	addi	sp,sp,32
ffffffffc0201a40:	8082                	ret
        intr_disable();
ffffffffc0201a42:	eeffe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
			cur = slobfree;
ffffffffc0201a46:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201a4a:	4605                	li	a2,1
ffffffffc0201a4c:	b7d1                	j	ffffffffc0201a10 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201a4e:	eddfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201a52:	b74d                	j	ffffffffc02019f4 <slob_alloc.constprop.0+0x50>
ffffffffc0201a54:	ed7fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
}
ffffffffc0201a58:	60e2                	ld	ra,24(sp)
ffffffffc0201a5a:	8522                	mv	a0,s0
ffffffffc0201a5c:	6442                	ld	s0,16(sp)
ffffffffc0201a5e:	64a2                	ld	s1,8(sp)
ffffffffc0201a60:	6902                	ld	s2,0(sp)
ffffffffc0201a62:	6105                	addi	sp,sp,32
ffffffffc0201a64:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201a66:	6418                	ld	a4,8(s0)
ffffffffc0201a68:	e798                	sd	a4,8(a5)
ffffffffc0201a6a:	b7d1                	j	ffffffffc0201a2e <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201a6c:	ec5fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        return 1;
ffffffffc0201a70:	4605                	li	a2,1
ffffffffc0201a72:	bf99                	j	ffffffffc02019c8 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201a74:	843e                	mv	s0,a5
ffffffffc0201a76:	87b6                	mv	a5,a3
ffffffffc0201a78:	b745                	j	ffffffffc0201a18 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201a7a:	00003697          	auipc	a3,0x3
ffffffffc0201a7e:	2be68693          	addi	a3,a3,702 # ffffffffc0204d38 <default_pmm_manager+0x70>
ffffffffc0201a82:	00003617          	auipc	a2,0x3
ffffffffc0201a86:	e9660613          	addi	a2,a2,-362 # ffffffffc0204918 <commands+0x818>
ffffffffc0201a8a:	06300593          	li	a1,99
ffffffffc0201a8e:	00003517          	auipc	a0,0x3
ffffffffc0201a92:	2ca50513          	addi	a0,a0,714 # ffffffffc0204d58 <default_pmm_manager+0x90>
ffffffffc0201a96:	9c5fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201a9a <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201a9a:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201a9c:	00003517          	auipc	a0,0x3
ffffffffc0201aa0:	2d450513          	addi	a0,a0,724 # ffffffffc0204d70 <default_pmm_manager+0xa8>
{
ffffffffc0201aa4:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201aa6:	eeefe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201aaa:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201aac:	00003517          	auipc	a0,0x3
ffffffffc0201ab0:	2dc50513          	addi	a0,a0,732 # ffffffffc0204d88 <default_pmm_manager+0xc0>
}
ffffffffc0201ab4:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201ab6:	edefe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201aba <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201aba:	1101                	addi	sp,sp,-32
ffffffffc0201abc:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201abe:	6905                	lui	s2,0x1
{
ffffffffc0201ac0:	e822                	sd	s0,16(sp)
ffffffffc0201ac2:	ec06                	sd	ra,24(sp)
ffffffffc0201ac4:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201ac6:	fef90793          	addi	a5,s2,-17 # fef <kern_entry-0xffffffffc01ff011>
{
ffffffffc0201aca:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201acc:	04a7f963          	bgeu	a5,a0,ffffffffc0201b1e <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201ad0:	4561                	li	a0,24
ffffffffc0201ad2:	ed3ff0ef          	jal	ra,ffffffffc02019a4 <slob_alloc.constprop.0>
ffffffffc0201ad6:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201ad8:	c929                	beqz	a0,ffffffffc0201b2a <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201ada:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201ade:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201ae0:	00f95763          	bge	s2,a5,ffffffffc0201aee <kmalloc+0x34>
ffffffffc0201ae4:	6705                	lui	a4,0x1
ffffffffc0201ae6:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201ae8:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201aea:	fef74ee3          	blt	a4,a5,ffffffffc0201ae6 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201aee:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201af0:	e51ff0ef          	jal	ra,ffffffffc0201940 <__slob_get_free_pages.constprop.0>
ffffffffc0201af4:	e488                	sd	a0,8(s1)
ffffffffc0201af6:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201af8:	c525                	beqz	a0,ffffffffc0201b60 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201afa:	100027f3          	csrr	a5,sstatus
ffffffffc0201afe:	8b89                	andi	a5,a5,2
ffffffffc0201b00:	ef8d                	bnez	a5,ffffffffc0201b3a <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201b02:	0000c797          	auipc	a5,0xc
ffffffffc0201b06:	99678793          	addi	a5,a5,-1642 # ffffffffc020d498 <bigblocks>
ffffffffc0201b0a:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201b0c:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201b0e:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201b10:	60e2                	ld	ra,24(sp)
ffffffffc0201b12:	8522                	mv	a0,s0
ffffffffc0201b14:	6442                	ld	s0,16(sp)
ffffffffc0201b16:	64a2                	ld	s1,8(sp)
ffffffffc0201b18:	6902                	ld	s2,0(sp)
ffffffffc0201b1a:	6105                	addi	sp,sp,32
ffffffffc0201b1c:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201b1e:	0541                	addi	a0,a0,16
ffffffffc0201b20:	e85ff0ef          	jal	ra,ffffffffc02019a4 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201b24:	01050413          	addi	s0,a0,16
ffffffffc0201b28:	f565                	bnez	a0,ffffffffc0201b10 <kmalloc+0x56>
ffffffffc0201b2a:	4401                	li	s0,0
}
ffffffffc0201b2c:	60e2                	ld	ra,24(sp)
ffffffffc0201b2e:	8522                	mv	a0,s0
ffffffffc0201b30:	6442                	ld	s0,16(sp)
ffffffffc0201b32:	64a2                	ld	s1,8(sp)
ffffffffc0201b34:	6902                	ld	s2,0(sp)
ffffffffc0201b36:	6105                	addi	sp,sp,32
ffffffffc0201b38:	8082                	ret
        intr_disable();
ffffffffc0201b3a:	df7fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201b3e:	0000c797          	auipc	a5,0xc
ffffffffc0201b42:	95a78793          	addi	a5,a5,-1702 # ffffffffc020d498 <bigblocks>
ffffffffc0201b46:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201b48:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201b4a:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201b4c:	ddffe0ef          	jal	ra,ffffffffc020092a <intr_enable>
		return bb->pages;
ffffffffc0201b50:	6480                	ld	s0,8(s1)
}
ffffffffc0201b52:	60e2                	ld	ra,24(sp)
ffffffffc0201b54:	64a2                	ld	s1,8(sp)
ffffffffc0201b56:	8522                	mv	a0,s0
ffffffffc0201b58:	6442                	ld	s0,16(sp)
ffffffffc0201b5a:	6902                	ld	s2,0(sp)
ffffffffc0201b5c:	6105                	addi	sp,sp,32
ffffffffc0201b5e:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201b60:	45e1                	li	a1,24
ffffffffc0201b62:	8526                	mv	a0,s1
ffffffffc0201b64:	d29ff0ef          	jal	ra,ffffffffc020188c <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201b68:	b765                	j	ffffffffc0201b10 <kmalloc+0x56>

ffffffffc0201b6a <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201b6a:	c169                	beqz	a0,ffffffffc0201c2c <kfree+0xc2>
{
ffffffffc0201b6c:	1101                	addi	sp,sp,-32
ffffffffc0201b6e:	e822                	sd	s0,16(sp)
ffffffffc0201b70:	ec06                	sd	ra,24(sp)
ffffffffc0201b72:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201b74:	03451793          	slli	a5,a0,0x34
ffffffffc0201b78:	842a                	mv	s0,a0
ffffffffc0201b7a:	e3d9                	bnez	a5,ffffffffc0201c00 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201b7c:	100027f3          	csrr	a5,sstatus
ffffffffc0201b80:	8b89                	andi	a5,a5,2
ffffffffc0201b82:	e7d9                	bnez	a5,ffffffffc0201c10 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201b84:	0000c797          	auipc	a5,0xc
ffffffffc0201b88:	9147b783          	ld	a5,-1772(a5) # ffffffffc020d498 <bigblocks>
    return 0;
ffffffffc0201b8c:	4601                	li	a2,0
ffffffffc0201b8e:	cbad                	beqz	a5,ffffffffc0201c00 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201b90:	0000c697          	auipc	a3,0xc
ffffffffc0201b94:	90868693          	addi	a3,a3,-1784 # ffffffffc020d498 <bigblocks>
ffffffffc0201b98:	a021                	j	ffffffffc0201ba0 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201b9a:	01048693          	addi	a3,s1,16
ffffffffc0201b9e:	c3a5                	beqz	a5,ffffffffc0201bfe <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201ba0:	6798                	ld	a4,8(a5)
ffffffffc0201ba2:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201ba4:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201ba6:	fe871ae3          	bne	a4,s0,ffffffffc0201b9a <kfree+0x30>
				*last = bb->next;
ffffffffc0201baa:	e29c                	sd	a5,0(a3)
    if (flag) {
ffffffffc0201bac:	ee2d                	bnez	a2,ffffffffc0201c26 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201bae:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201bb2:	4098                	lw	a4,0(s1)
ffffffffc0201bb4:	08f46963          	bltu	s0,a5,ffffffffc0201c46 <kfree+0xdc>
ffffffffc0201bb8:	0000c697          	auipc	a3,0xc
ffffffffc0201bbc:	9106b683          	ld	a3,-1776(a3) # ffffffffc020d4c8 <va_pa_offset>
ffffffffc0201bc0:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201bc2:	8031                	srli	s0,s0,0xc
ffffffffc0201bc4:	0000c797          	auipc	a5,0xc
ffffffffc0201bc8:	8ec7b783          	ld	a5,-1812(a5) # ffffffffc020d4b0 <npage>
ffffffffc0201bcc:	06f47163          	bgeu	s0,a5,ffffffffc0201c2e <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201bd0:	00004517          	auipc	a0,0x4
ffffffffc0201bd4:	e1053503          	ld	a0,-496(a0) # ffffffffc02059e0 <nbase>
ffffffffc0201bd8:	8c09                	sub	s0,s0,a0
ffffffffc0201bda:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201bdc:	0000c517          	auipc	a0,0xc
ffffffffc0201be0:	8dc53503          	ld	a0,-1828(a0) # ffffffffc020d4b8 <pages>
ffffffffc0201be4:	4585                	li	a1,1
ffffffffc0201be6:	9522                	add	a0,a0,s0
ffffffffc0201be8:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201bec:	0ea000ef          	jal	ra,ffffffffc0201cd6 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201bf0:	6442                	ld	s0,16(sp)
ffffffffc0201bf2:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201bf4:	8526                	mv	a0,s1
}
ffffffffc0201bf6:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201bf8:	45e1                	li	a1,24
}
ffffffffc0201bfa:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201bfc:	b941                	j	ffffffffc020188c <slob_free>
ffffffffc0201bfe:	e20d                	bnez	a2,ffffffffc0201c20 <kfree+0xb6>
ffffffffc0201c00:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201c04:	6442                	ld	s0,16(sp)
ffffffffc0201c06:	60e2                	ld	ra,24(sp)
ffffffffc0201c08:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201c0a:	4581                	li	a1,0
}
ffffffffc0201c0c:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201c0e:	b9bd                	j	ffffffffc020188c <slob_free>
        intr_disable();
ffffffffc0201c10:	d21fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201c14:	0000c797          	auipc	a5,0xc
ffffffffc0201c18:	8847b783          	ld	a5,-1916(a5) # ffffffffc020d498 <bigblocks>
        return 1;
ffffffffc0201c1c:	4605                	li	a2,1
ffffffffc0201c1e:	fbad                	bnez	a5,ffffffffc0201b90 <kfree+0x26>
        intr_enable();
ffffffffc0201c20:	d0bfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201c24:	bff1                	j	ffffffffc0201c00 <kfree+0x96>
ffffffffc0201c26:	d05fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201c2a:	b751                	j	ffffffffc0201bae <kfree+0x44>
ffffffffc0201c2c:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201c2e:	00003617          	auipc	a2,0x3
ffffffffc0201c32:	1a260613          	addi	a2,a2,418 # ffffffffc0204dd0 <default_pmm_manager+0x108>
ffffffffc0201c36:	06900593          	li	a1,105
ffffffffc0201c3a:	00003517          	auipc	a0,0x3
ffffffffc0201c3e:	0ee50513          	addi	a0,a0,238 # ffffffffc0204d28 <default_pmm_manager+0x60>
ffffffffc0201c42:	819fe0ef          	jal	ra,ffffffffc020045a <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201c46:	86a2                	mv	a3,s0
ffffffffc0201c48:	00003617          	auipc	a2,0x3
ffffffffc0201c4c:	16060613          	addi	a2,a2,352 # ffffffffc0204da8 <default_pmm_manager+0xe0>
ffffffffc0201c50:	07700593          	li	a1,119
ffffffffc0201c54:	00003517          	auipc	a0,0x3
ffffffffc0201c58:	0d450513          	addi	a0,a0,212 # ffffffffc0204d28 <default_pmm_manager+0x60>
ffffffffc0201c5c:	ffefe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201c60 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201c60:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201c62:	00003617          	auipc	a2,0x3
ffffffffc0201c66:	16e60613          	addi	a2,a2,366 # ffffffffc0204dd0 <default_pmm_manager+0x108>
ffffffffc0201c6a:	06900593          	li	a1,105
ffffffffc0201c6e:	00003517          	auipc	a0,0x3
ffffffffc0201c72:	0ba50513          	addi	a0,a0,186 # ffffffffc0204d28 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201c76:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201c78:	fe2fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201c7c <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201c7c:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201c7e:	00003617          	auipc	a2,0x3
ffffffffc0201c82:	17260613          	addi	a2,a2,370 # ffffffffc0204df0 <default_pmm_manager+0x128>
ffffffffc0201c86:	07f00593          	li	a1,127
ffffffffc0201c8a:	00003517          	auipc	a0,0x3
ffffffffc0201c8e:	09e50513          	addi	a0,a0,158 # ffffffffc0204d28 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201c92:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201c94:	fc6fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201c98 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201c98:	100027f3          	csrr	a5,sstatus
ffffffffc0201c9c:	8b89                	andi	a5,a5,2
ffffffffc0201c9e:	e799                	bnez	a5,ffffffffc0201cac <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ca0:	0000c797          	auipc	a5,0xc
ffffffffc0201ca4:	8207b783          	ld	a5,-2016(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201ca8:	6f9c                	ld	a5,24(a5)
ffffffffc0201caa:	8782                	jr	a5
{
ffffffffc0201cac:	1141                	addi	sp,sp,-16
ffffffffc0201cae:	e406                	sd	ra,8(sp)
ffffffffc0201cb0:	e022                	sd	s0,0(sp)
ffffffffc0201cb2:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201cb4:	c7dfe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201cb8:	0000c797          	auipc	a5,0xc
ffffffffc0201cbc:	8087b783          	ld	a5,-2040(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201cc0:	6f9c                	ld	a5,24(a5)
ffffffffc0201cc2:	8522                	mv	a0,s0
ffffffffc0201cc4:	9782                	jalr	a5
ffffffffc0201cc6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201cc8:	c63fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201ccc:	60a2                	ld	ra,8(sp)
ffffffffc0201cce:	8522                	mv	a0,s0
ffffffffc0201cd0:	6402                	ld	s0,0(sp)
ffffffffc0201cd2:	0141                	addi	sp,sp,16
ffffffffc0201cd4:	8082                	ret

ffffffffc0201cd6 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201cd6:	100027f3          	csrr	a5,sstatus
ffffffffc0201cda:	8b89                	andi	a5,a5,2
ffffffffc0201cdc:	e799                	bnez	a5,ffffffffc0201cea <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201cde:	0000b797          	auipc	a5,0xb
ffffffffc0201ce2:	7e27b783          	ld	a5,2018(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201ce6:	739c                	ld	a5,32(a5)
ffffffffc0201ce8:	8782                	jr	a5
{
ffffffffc0201cea:	1101                	addi	sp,sp,-32
ffffffffc0201cec:	ec06                	sd	ra,24(sp)
ffffffffc0201cee:	e822                	sd	s0,16(sp)
ffffffffc0201cf0:	e426                	sd	s1,8(sp)
ffffffffc0201cf2:	842a                	mv	s0,a0
ffffffffc0201cf4:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201cf6:	c3bfe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201cfa:	0000b797          	auipc	a5,0xb
ffffffffc0201cfe:	7c67b783          	ld	a5,1990(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201d02:	739c                	ld	a5,32(a5)
ffffffffc0201d04:	85a6                	mv	a1,s1
ffffffffc0201d06:	8522                	mv	a0,s0
ffffffffc0201d08:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201d0a:	6442                	ld	s0,16(sp)
ffffffffc0201d0c:	60e2                	ld	ra,24(sp)
ffffffffc0201d0e:	64a2                	ld	s1,8(sp)
ffffffffc0201d10:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201d12:	c19fe06f          	j	ffffffffc020092a <intr_enable>

ffffffffc0201d16 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201d16:	100027f3          	csrr	a5,sstatus
ffffffffc0201d1a:	8b89                	andi	a5,a5,2
ffffffffc0201d1c:	e799                	bnez	a5,ffffffffc0201d2a <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201d1e:	0000b797          	auipc	a5,0xb
ffffffffc0201d22:	7a27b783          	ld	a5,1954(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201d26:	779c                	ld	a5,40(a5)
ffffffffc0201d28:	8782                	jr	a5
{
ffffffffc0201d2a:	1141                	addi	sp,sp,-16
ffffffffc0201d2c:	e406                	sd	ra,8(sp)
ffffffffc0201d2e:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201d30:	c01fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201d34:	0000b797          	auipc	a5,0xb
ffffffffc0201d38:	78c7b783          	ld	a5,1932(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201d3c:	779c                	ld	a5,40(a5)
ffffffffc0201d3e:	9782                	jalr	a5
ffffffffc0201d40:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201d42:	be9fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201d46:	60a2                	ld	ra,8(sp)
ffffffffc0201d48:	8522                	mv	a0,s0
ffffffffc0201d4a:	6402                	ld	s0,0(sp)
ffffffffc0201d4c:	0141                	addi	sp,sp,16
ffffffffc0201d4e:	8082                	ret

ffffffffc0201d50 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201d50:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201d54:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201d58:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201d5a:	078e                	slli	a5,a5,0x3
{
ffffffffc0201d5c:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201d5e:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201d62:	6094                	ld	a3,0(s1)
{
ffffffffc0201d64:	f04a                	sd	s2,32(sp)
ffffffffc0201d66:	ec4e                	sd	s3,24(sp)
ffffffffc0201d68:	e852                	sd	s4,16(sp)
ffffffffc0201d6a:	fc06                	sd	ra,56(sp)
ffffffffc0201d6c:	f822                	sd	s0,48(sp)
ffffffffc0201d6e:	e456                	sd	s5,8(sp)
ffffffffc0201d70:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201d72:	0016f793          	andi	a5,a3,1
{
ffffffffc0201d76:	892e                	mv	s2,a1
ffffffffc0201d78:	8a32                	mv	s4,a2
ffffffffc0201d7a:	0000b997          	auipc	s3,0xb
ffffffffc0201d7e:	73698993          	addi	s3,s3,1846 # ffffffffc020d4b0 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201d82:	efbd                	bnez	a5,ffffffffc0201e00 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201d84:	14060c63          	beqz	a2,ffffffffc0201edc <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201d88:	100027f3          	csrr	a5,sstatus
ffffffffc0201d8c:	8b89                	andi	a5,a5,2
ffffffffc0201d8e:	14079963          	bnez	a5,ffffffffc0201ee0 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201d92:	0000b797          	auipc	a5,0xb
ffffffffc0201d96:	72e7b783          	ld	a5,1838(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201d9a:	6f9c                	ld	a5,24(a5)
ffffffffc0201d9c:	4505                	li	a0,1
ffffffffc0201d9e:	9782                	jalr	a5
ffffffffc0201da0:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201da2:	12040d63          	beqz	s0,ffffffffc0201edc <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201da6:	0000bb17          	auipc	s6,0xb
ffffffffc0201daa:	712b0b13          	addi	s6,s6,1810 # ffffffffc020d4b8 <pages>
ffffffffc0201dae:	000b3503          	ld	a0,0(s6)
ffffffffc0201db2:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201db6:	0000b997          	auipc	s3,0xb
ffffffffc0201dba:	6fa98993          	addi	s3,s3,1786 # ffffffffc020d4b0 <npage>
ffffffffc0201dbe:	40a40533          	sub	a0,s0,a0
ffffffffc0201dc2:	8519                	srai	a0,a0,0x6
ffffffffc0201dc4:	9556                	add	a0,a0,s5
ffffffffc0201dc6:	0009b703          	ld	a4,0(s3)
ffffffffc0201dca:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201dce:	4685                	li	a3,1
ffffffffc0201dd0:	c014                	sw	a3,0(s0)
ffffffffc0201dd2:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201dd4:	0532                	slli	a0,a0,0xc
ffffffffc0201dd6:	16e7f763          	bgeu	a5,a4,ffffffffc0201f44 <get_pte+0x1f4>
ffffffffc0201dda:	0000b797          	auipc	a5,0xb
ffffffffc0201dde:	6ee7b783          	ld	a5,1774(a5) # ffffffffc020d4c8 <va_pa_offset>
ffffffffc0201de2:	6605                	lui	a2,0x1
ffffffffc0201de4:	4581                	li	a1,0
ffffffffc0201de6:	953e                	add	a0,a0,a5
ffffffffc0201de8:	05e020ef          	jal	ra,ffffffffc0203e46 <memset>
    return page - pages + nbase;
ffffffffc0201dec:	000b3683          	ld	a3,0(s6)
ffffffffc0201df0:	40d406b3          	sub	a3,s0,a3
ffffffffc0201df4:	8699                	srai	a3,a3,0x6
ffffffffc0201df6:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201df8:	06aa                	slli	a3,a3,0xa
ffffffffc0201dfa:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201dfe:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201e00:	77fd                	lui	a5,0xfffff
ffffffffc0201e02:	068a                	slli	a3,a3,0x2
ffffffffc0201e04:	0009b703          	ld	a4,0(s3)
ffffffffc0201e08:	8efd                	and	a3,a3,a5
ffffffffc0201e0a:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201e0e:	10e7ff63          	bgeu	a5,a4,ffffffffc0201f2c <get_pte+0x1dc>
ffffffffc0201e12:	0000ba97          	auipc	s5,0xb
ffffffffc0201e16:	6b6a8a93          	addi	s5,s5,1718 # ffffffffc020d4c8 <va_pa_offset>
ffffffffc0201e1a:	000ab403          	ld	s0,0(s5)
ffffffffc0201e1e:	01595793          	srli	a5,s2,0x15
ffffffffc0201e22:	1ff7f793          	andi	a5,a5,511
ffffffffc0201e26:	96a2                	add	a3,a3,s0
ffffffffc0201e28:	00379413          	slli	s0,a5,0x3
ffffffffc0201e2c:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0201e2e:	6014                	ld	a3,0(s0)
ffffffffc0201e30:	0016f793          	andi	a5,a3,1
ffffffffc0201e34:	ebad                	bnez	a5,ffffffffc0201ea6 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e36:	0a0a0363          	beqz	s4,ffffffffc0201edc <get_pte+0x18c>
ffffffffc0201e3a:	100027f3          	csrr	a5,sstatus
ffffffffc0201e3e:	8b89                	andi	a5,a5,2
ffffffffc0201e40:	efcd                	bnez	a5,ffffffffc0201efa <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201e42:	0000b797          	auipc	a5,0xb
ffffffffc0201e46:	67e7b783          	ld	a5,1662(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201e4a:	6f9c                	ld	a5,24(a5)
ffffffffc0201e4c:	4505                	li	a0,1
ffffffffc0201e4e:	9782                	jalr	a5
ffffffffc0201e50:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e52:	c4c9                	beqz	s1,ffffffffc0201edc <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201e54:	0000bb17          	auipc	s6,0xb
ffffffffc0201e58:	664b0b13          	addi	s6,s6,1636 # ffffffffc020d4b8 <pages>
ffffffffc0201e5c:	000b3503          	ld	a0,0(s6)
ffffffffc0201e60:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201e64:	0009b703          	ld	a4,0(s3)
ffffffffc0201e68:	40a48533          	sub	a0,s1,a0
ffffffffc0201e6c:	8519                	srai	a0,a0,0x6
ffffffffc0201e6e:	9552                	add	a0,a0,s4
ffffffffc0201e70:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201e74:	4685                	li	a3,1
ffffffffc0201e76:	c094                	sw	a3,0(s1)
ffffffffc0201e78:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201e7a:	0532                	slli	a0,a0,0xc
ffffffffc0201e7c:	0ee7f163          	bgeu	a5,a4,ffffffffc0201f5e <get_pte+0x20e>
ffffffffc0201e80:	000ab783          	ld	a5,0(s5)
ffffffffc0201e84:	6605                	lui	a2,0x1
ffffffffc0201e86:	4581                	li	a1,0
ffffffffc0201e88:	953e                	add	a0,a0,a5
ffffffffc0201e8a:	7bd010ef          	jal	ra,ffffffffc0203e46 <memset>
    return page - pages + nbase;
ffffffffc0201e8e:	000b3683          	ld	a3,0(s6)
ffffffffc0201e92:	40d486b3          	sub	a3,s1,a3
ffffffffc0201e96:	8699                	srai	a3,a3,0x6
ffffffffc0201e98:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201e9a:	06aa                	slli	a3,a3,0xa
ffffffffc0201e9c:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201ea0:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201ea2:	0009b703          	ld	a4,0(s3)
ffffffffc0201ea6:	068a                	slli	a3,a3,0x2
ffffffffc0201ea8:	757d                	lui	a0,0xfffff
ffffffffc0201eaa:	8ee9                	and	a3,a3,a0
ffffffffc0201eac:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201eb0:	06e7f263          	bgeu	a5,a4,ffffffffc0201f14 <get_pte+0x1c4>
ffffffffc0201eb4:	000ab503          	ld	a0,0(s5)
ffffffffc0201eb8:	00c95913          	srli	s2,s2,0xc
ffffffffc0201ebc:	1ff97913          	andi	s2,s2,511
ffffffffc0201ec0:	96aa                	add	a3,a3,a0
ffffffffc0201ec2:	00391513          	slli	a0,s2,0x3
ffffffffc0201ec6:	9536                	add	a0,a0,a3
}
ffffffffc0201ec8:	70e2                	ld	ra,56(sp)
ffffffffc0201eca:	7442                	ld	s0,48(sp)
ffffffffc0201ecc:	74a2                	ld	s1,40(sp)
ffffffffc0201ece:	7902                	ld	s2,32(sp)
ffffffffc0201ed0:	69e2                	ld	s3,24(sp)
ffffffffc0201ed2:	6a42                	ld	s4,16(sp)
ffffffffc0201ed4:	6aa2                	ld	s5,8(sp)
ffffffffc0201ed6:	6b02                	ld	s6,0(sp)
ffffffffc0201ed8:	6121                	addi	sp,sp,64
ffffffffc0201eda:	8082                	ret
            return NULL;
ffffffffc0201edc:	4501                	li	a0,0
ffffffffc0201ede:	b7ed                	j	ffffffffc0201ec8 <get_pte+0x178>
        intr_disable();
ffffffffc0201ee0:	a51fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ee4:	0000b797          	auipc	a5,0xb
ffffffffc0201ee8:	5dc7b783          	ld	a5,1500(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201eec:	6f9c                	ld	a5,24(a5)
ffffffffc0201eee:	4505                	li	a0,1
ffffffffc0201ef0:	9782                	jalr	a5
ffffffffc0201ef2:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201ef4:	a37fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201ef8:	b56d                	j	ffffffffc0201da2 <get_pte+0x52>
        intr_disable();
ffffffffc0201efa:	a37fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0201efe:	0000b797          	auipc	a5,0xb
ffffffffc0201f02:	5c27b783          	ld	a5,1474(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201f06:	6f9c                	ld	a5,24(a5)
ffffffffc0201f08:	4505                	li	a0,1
ffffffffc0201f0a:	9782                	jalr	a5
ffffffffc0201f0c:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc0201f0e:	a1dfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201f12:	b781                	j	ffffffffc0201e52 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f14:	00003617          	auipc	a2,0x3
ffffffffc0201f18:	dec60613          	addi	a2,a2,-532 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0201f1c:	0fb00593          	li	a1,251
ffffffffc0201f20:	00003517          	auipc	a0,0x3
ffffffffc0201f24:	ef850513          	addi	a0,a0,-264 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0201f28:	d32fe0ef          	jal	ra,ffffffffc020045a <__panic>
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201f2c:	00003617          	auipc	a2,0x3
ffffffffc0201f30:	dd460613          	addi	a2,a2,-556 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0201f34:	0ee00593          	li	a1,238
ffffffffc0201f38:	00003517          	auipc	a0,0x3
ffffffffc0201f3c:	ee050513          	addi	a0,a0,-288 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0201f40:	d1afe0ef          	jal	ra,ffffffffc020045a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f44:	86aa                	mv	a3,a0
ffffffffc0201f46:	00003617          	auipc	a2,0x3
ffffffffc0201f4a:	dba60613          	addi	a2,a2,-582 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0201f4e:	0eb00593          	li	a1,235
ffffffffc0201f52:	00003517          	auipc	a0,0x3
ffffffffc0201f56:	ec650513          	addi	a0,a0,-314 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0201f5a:	d00fe0ef          	jal	ra,ffffffffc020045a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f5e:	86aa                	mv	a3,a0
ffffffffc0201f60:	00003617          	auipc	a2,0x3
ffffffffc0201f64:	da060613          	addi	a2,a2,-608 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0201f68:	0f800593          	li	a1,248
ffffffffc0201f6c:	00003517          	auipc	a0,0x3
ffffffffc0201f70:	eac50513          	addi	a0,a0,-340 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0201f74:	ce6fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201f78 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0201f78:	1141                	addi	sp,sp,-16
ffffffffc0201f7a:	e022                	sd	s0,0(sp)
ffffffffc0201f7c:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201f7e:	4601                	li	a2,0
{
ffffffffc0201f80:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201f82:	dcfff0ef          	jal	ra,ffffffffc0201d50 <get_pte>
    if (ptep_store != NULL)
ffffffffc0201f86:	c011                	beqz	s0,ffffffffc0201f8a <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0201f88:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0201f8a:	c511                	beqz	a0,ffffffffc0201f96 <get_page+0x1e>
ffffffffc0201f8c:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0201f8e:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0201f90:	0017f713          	andi	a4,a5,1
ffffffffc0201f94:	e709                	bnez	a4,ffffffffc0201f9e <get_page+0x26>
}
ffffffffc0201f96:	60a2                	ld	ra,8(sp)
ffffffffc0201f98:	6402                	ld	s0,0(sp)
ffffffffc0201f9a:	0141                	addi	sp,sp,16
ffffffffc0201f9c:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201f9e:	078a                	slli	a5,a5,0x2
ffffffffc0201fa0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201fa2:	0000b717          	auipc	a4,0xb
ffffffffc0201fa6:	50e73703          	ld	a4,1294(a4) # ffffffffc020d4b0 <npage>
ffffffffc0201faa:	00e7ff63          	bgeu	a5,a4,ffffffffc0201fc8 <get_page+0x50>
ffffffffc0201fae:	60a2                	ld	ra,8(sp)
ffffffffc0201fb0:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc0201fb2:	fff80537          	lui	a0,0xfff80
ffffffffc0201fb6:	97aa                	add	a5,a5,a0
ffffffffc0201fb8:	079a                	slli	a5,a5,0x6
ffffffffc0201fba:	0000b517          	auipc	a0,0xb
ffffffffc0201fbe:	4fe53503          	ld	a0,1278(a0) # ffffffffc020d4b8 <pages>
ffffffffc0201fc2:	953e                	add	a0,a0,a5
ffffffffc0201fc4:	0141                	addi	sp,sp,16
ffffffffc0201fc6:	8082                	ret
ffffffffc0201fc8:	c99ff0ef          	jal	ra,ffffffffc0201c60 <pa2page.part.0>

ffffffffc0201fcc <page_remove>:
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
ffffffffc0201fcc:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201fce:	4601                	li	a2,0
{
ffffffffc0201fd0:	ec26                	sd	s1,24(sp)
ffffffffc0201fd2:	f406                	sd	ra,40(sp)
ffffffffc0201fd4:	f022                	sd	s0,32(sp)
ffffffffc0201fd6:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201fd8:	d79ff0ef          	jal	ra,ffffffffc0201d50 <get_pte>
    if (ptep != NULL)
ffffffffc0201fdc:	c511                	beqz	a0,ffffffffc0201fe8 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0201fde:	611c                	ld	a5,0(a0)
ffffffffc0201fe0:	842a                	mv	s0,a0
ffffffffc0201fe2:	0017f713          	andi	a4,a5,1
ffffffffc0201fe6:	e711                	bnez	a4,ffffffffc0201ff2 <page_remove+0x26>
    {
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0201fe8:	70a2                	ld	ra,40(sp)
ffffffffc0201fea:	7402                	ld	s0,32(sp)
ffffffffc0201fec:	64e2                	ld	s1,24(sp)
ffffffffc0201fee:	6145                	addi	sp,sp,48
ffffffffc0201ff0:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201ff2:	078a                	slli	a5,a5,0x2
ffffffffc0201ff4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201ff6:	0000b717          	auipc	a4,0xb
ffffffffc0201ffa:	4ba73703          	ld	a4,1210(a4) # ffffffffc020d4b0 <npage>
ffffffffc0201ffe:	06e7f363          	bgeu	a5,a4,ffffffffc0202064 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202002:	fff80537          	lui	a0,0xfff80
ffffffffc0202006:	97aa                	add	a5,a5,a0
ffffffffc0202008:	079a                	slli	a5,a5,0x6
ffffffffc020200a:	0000b517          	auipc	a0,0xb
ffffffffc020200e:	4ae53503          	ld	a0,1198(a0) # ffffffffc020d4b8 <pages>
ffffffffc0202012:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202014:	411c                	lw	a5,0(a0)
ffffffffc0202016:	fff7871b          	addiw	a4,a5,-1
ffffffffc020201a:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc020201c:	cb11                	beqz	a4,ffffffffc0202030 <page_remove+0x64>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc020201e:	00043023          	sd	zero,0(s0)
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    // flush_tlb();
    // The flush_tlb flush the entire TLB, is there any better way?
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202022:	12048073          	sfence.vma	s1
}
ffffffffc0202026:	70a2                	ld	ra,40(sp)
ffffffffc0202028:	7402                	ld	s0,32(sp)
ffffffffc020202a:	64e2                	ld	s1,24(sp)
ffffffffc020202c:	6145                	addi	sp,sp,48
ffffffffc020202e:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202030:	100027f3          	csrr	a5,sstatus
ffffffffc0202034:	8b89                	andi	a5,a5,2
ffffffffc0202036:	eb89                	bnez	a5,ffffffffc0202048 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc0202038:	0000b797          	auipc	a5,0xb
ffffffffc020203c:	4887b783          	ld	a5,1160(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0202040:	739c                	ld	a5,32(a5)
ffffffffc0202042:	4585                	li	a1,1
ffffffffc0202044:	9782                	jalr	a5
    if (flag) {
ffffffffc0202046:	bfe1                	j	ffffffffc020201e <page_remove+0x52>
        intr_disable();
ffffffffc0202048:	e42a                	sd	a0,8(sp)
ffffffffc020204a:	8e7fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020204e:	0000b797          	auipc	a5,0xb
ffffffffc0202052:	4727b783          	ld	a5,1138(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0202056:	739c                	ld	a5,32(a5)
ffffffffc0202058:	6522                	ld	a0,8(sp)
ffffffffc020205a:	4585                	li	a1,1
ffffffffc020205c:	9782                	jalr	a5
        intr_enable();
ffffffffc020205e:	8cdfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202062:	bf75                	j	ffffffffc020201e <page_remove+0x52>
ffffffffc0202064:	bfdff0ef          	jal	ra,ffffffffc0201c60 <pa2page.part.0>

ffffffffc0202068 <page_insert>:
{
ffffffffc0202068:	7139                	addi	sp,sp,-64
ffffffffc020206a:	e852                	sd	s4,16(sp)
ffffffffc020206c:	8a32                	mv	s4,a2
ffffffffc020206e:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202070:	4605                	li	a2,1
{
ffffffffc0202072:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202074:	85d2                	mv	a1,s4
{
ffffffffc0202076:	f426                	sd	s1,40(sp)
ffffffffc0202078:	fc06                	sd	ra,56(sp)
ffffffffc020207a:	f04a                	sd	s2,32(sp)
ffffffffc020207c:	ec4e                	sd	s3,24(sp)
ffffffffc020207e:	e456                	sd	s5,8(sp)
ffffffffc0202080:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202082:	ccfff0ef          	jal	ra,ffffffffc0201d50 <get_pte>
    if (ptep == NULL)
ffffffffc0202086:	c961                	beqz	a0,ffffffffc0202156 <page_insert+0xee>
    page->ref += 1;
ffffffffc0202088:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc020208a:	611c                	ld	a5,0(a0)
ffffffffc020208c:	89aa                	mv	s3,a0
ffffffffc020208e:	0016871b          	addiw	a4,a3,1
ffffffffc0202092:	c018                	sw	a4,0(s0)
ffffffffc0202094:	0017f713          	andi	a4,a5,1
ffffffffc0202098:	ef05                	bnez	a4,ffffffffc02020d0 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc020209a:	0000b717          	auipc	a4,0xb
ffffffffc020209e:	41e73703          	ld	a4,1054(a4) # ffffffffc020d4b8 <pages>
ffffffffc02020a2:	8c19                	sub	s0,s0,a4
ffffffffc02020a4:	000807b7          	lui	a5,0x80
ffffffffc02020a8:	8419                	srai	s0,s0,0x6
ffffffffc02020aa:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02020ac:	042a                	slli	s0,s0,0xa
ffffffffc02020ae:	8cc1                	or	s1,s1,s0
ffffffffc02020b0:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02020b4:	0099b023          	sd	s1,0(s3)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02020b8:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc02020bc:	4501                	li	a0,0
}
ffffffffc02020be:	70e2                	ld	ra,56(sp)
ffffffffc02020c0:	7442                	ld	s0,48(sp)
ffffffffc02020c2:	74a2                	ld	s1,40(sp)
ffffffffc02020c4:	7902                	ld	s2,32(sp)
ffffffffc02020c6:	69e2                	ld	s3,24(sp)
ffffffffc02020c8:	6a42                	ld	s4,16(sp)
ffffffffc02020ca:	6aa2                	ld	s5,8(sp)
ffffffffc02020cc:	6121                	addi	sp,sp,64
ffffffffc02020ce:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02020d0:	078a                	slli	a5,a5,0x2
ffffffffc02020d2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02020d4:	0000b717          	auipc	a4,0xb
ffffffffc02020d8:	3dc73703          	ld	a4,988(a4) # ffffffffc020d4b0 <npage>
ffffffffc02020dc:	06e7ff63          	bgeu	a5,a4,ffffffffc020215a <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02020e0:	0000ba97          	auipc	s5,0xb
ffffffffc02020e4:	3d8a8a93          	addi	s5,s5,984 # ffffffffc020d4b8 <pages>
ffffffffc02020e8:	000ab703          	ld	a4,0(s5)
ffffffffc02020ec:	fff80937          	lui	s2,0xfff80
ffffffffc02020f0:	993e                	add	s2,s2,a5
ffffffffc02020f2:	091a                	slli	s2,s2,0x6
ffffffffc02020f4:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc02020f6:	01240c63          	beq	s0,s2,ffffffffc020210e <page_insert+0xa6>
    page->ref -= 1;
ffffffffc02020fa:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fd72b14>
ffffffffc02020fe:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202102:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc0202106:	c691                	beqz	a3,ffffffffc0202112 <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202108:	120a0073          	sfence.vma	s4
}
ffffffffc020210c:	bf59                	j	ffffffffc02020a2 <page_insert+0x3a>
ffffffffc020210e:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202110:	bf49                	j	ffffffffc02020a2 <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202112:	100027f3          	csrr	a5,sstatus
ffffffffc0202116:	8b89                	andi	a5,a5,2
ffffffffc0202118:	ef91                	bnez	a5,ffffffffc0202134 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc020211a:	0000b797          	auipc	a5,0xb
ffffffffc020211e:	3a67b783          	ld	a5,934(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0202122:	739c                	ld	a5,32(a5)
ffffffffc0202124:	4585                	li	a1,1
ffffffffc0202126:	854a                	mv	a0,s2
ffffffffc0202128:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc020212a:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020212e:	120a0073          	sfence.vma	s4
ffffffffc0202132:	bf85                	j	ffffffffc02020a2 <page_insert+0x3a>
        intr_disable();
ffffffffc0202134:	ffcfe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202138:	0000b797          	auipc	a5,0xb
ffffffffc020213c:	3887b783          	ld	a5,904(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0202140:	739c                	ld	a5,32(a5)
ffffffffc0202142:	4585                	li	a1,1
ffffffffc0202144:	854a                	mv	a0,s2
ffffffffc0202146:	9782                	jalr	a5
        intr_enable();
ffffffffc0202148:	fe2fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020214c:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202150:	120a0073          	sfence.vma	s4
ffffffffc0202154:	b7b9                	j	ffffffffc02020a2 <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0202156:	5571                	li	a0,-4
ffffffffc0202158:	b79d                	j	ffffffffc02020be <page_insert+0x56>
ffffffffc020215a:	b07ff0ef          	jal	ra,ffffffffc0201c60 <pa2page.part.0>

ffffffffc020215e <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc020215e:	00003797          	auipc	a5,0x3
ffffffffc0202162:	b6a78793          	addi	a5,a5,-1174 # ffffffffc0204cc8 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202166:	638c                	ld	a1,0(a5)
{
ffffffffc0202168:	7159                	addi	sp,sp,-112
ffffffffc020216a:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020216c:	00003517          	auipc	a0,0x3
ffffffffc0202170:	cbc50513          	addi	a0,a0,-836 # ffffffffc0204e28 <default_pmm_manager+0x160>
    pmm_manager = &default_pmm_manager;
ffffffffc0202174:	0000bb17          	auipc	s6,0xb
ffffffffc0202178:	34cb0b13          	addi	s6,s6,844 # ffffffffc020d4c0 <pmm_manager>
{
ffffffffc020217c:	f486                	sd	ra,104(sp)
ffffffffc020217e:	e8ca                	sd	s2,80(sp)
ffffffffc0202180:	e4ce                	sd	s3,72(sp)
ffffffffc0202182:	f0a2                	sd	s0,96(sp)
ffffffffc0202184:	eca6                	sd	s1,88(sp)
ffffffffc0202186:	e0d2                	sd	s4,64(sp)
ffffffffc0202188:	fc56                	sd	s5,56(sp)
ffffffffc020218a:	f45e                	sd	s7,40(sp)
ffffffffc020218c:	f062                	sd	s8,32(sp)
ffffffffc020218e:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202190:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202194:	800fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc0202198:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020219c:	0000b997          	auipc	s3,0xb
ffffffffc02021a0:	32c98993          	addi	s3,s3,812 # ffffffffc020d4c8 <va_pa_offset>
    pmm_manager->init();
ffffffffc02021a4:	679c                	ld	a5,8(a5)
ffffffffc02021a6:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02021a8:	57f5                	li	a5,-3
ffffffffc02021aa:	07fa                	slli	a5,a5,0x1e
ffffffffc02021ac:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc02021b0:	f66fe0ef          	jal	ra,ffffffffc0200916 <get_memory_base>
ffffffffc02021b4:	892a                	mv	s2,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc02021b6:	f6afe0ef          	jal	ra,ffffffffc0200920 <get_memory_size>
    if (mem_size == 0) {
ffffffffc02021ba:	200505e3          	beqz	a0,ffffffffc0202bc4 <pmm_init+0xa66>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02021be:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc02021c0:	00003517          	auipc	a0,0x3
ffffffffc02021c4:	ca050513          	addi	a0,a0,-864 # ffffffffc0204e60 <default_pmm_manager+0x198>
ffffffffc02021c8:	fcdfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02021cc:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02021d0:	fff40693          	addi	a3,s0,-1
ffffffffc02021d4:	864a                	mv	a2,s2
ffffffffc02021d6:	85a6                	mv	a1,s1
ffffffffc02021d8:	00003517          	auipc	a0,0x3
ffffffffc02021dc:	ca050513          	addi	a0,a0,-864 # ffffffffc0204e78 <default_pmm_manager+0x1b0>
ffffffffc02021e0:	fb5fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02021e4:	c8000737          	lui	a4,0xc8000
ffffffffc02021e8:	87a2                	mv	a5,s0
ffffffffc02021ea:	54876163          	bltu	a4,s0,ffffffffc020272c <pmm_init+0x5ce>
ffffffffc02021ee:	757d                	lui	a0,0xfffff
ffffffffc02021f0:	0000c617          	auipc	a2,0xc
ffffffffc02021f4:	2fb60613          	addi	a2,a2,763 # ffffffffc020e4eb <end+0xfff>
ffffffffc02021f8:	8e69                	and	a2,a2,a0
ffffffffc02021fa:	0000b497          	auipc	s1,0xb
ffffffffc02021fe:	2b648493          	addi	s1,s1,694 # ffffffffc020d4b0 <npage>
ffffffffc0202202:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202206:	0000bb97          	auipc	s7,0xb
ffffffffc020220a:	2b2b8b93          	addi	s7,s7,690 # ffffffffc020d4b8 <pages>
    npage = maxpa / PGSIZE;
ffffffffc020220e:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202210:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202214:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202218:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020221a:	02f50863          	beq	a0,a5,ffffffffc020224a <pmm_init+0xec>
ffffffffc020221e:	4781                	li	a5,0
ffffffffc0202220:	4585                	li	a1,1
ffffffffc0202222:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202226:	00679513          	slli	a0,a5,0x6
ffffffffc020222a:	9532                	add	a0,a0,a2
ffffffffc020222c:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fdf1b1c>
ffffffffc0202230:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202234:	6088                	ld	a0,0(s1)
ffffffffc0202236:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202238:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020223c:	00d50733          	add	a4,a0,a3
ffffffffc0202240:	fee7e3e3          	bltu	a5,a4,ffffffffc0202226 <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202244:	071a                	slli	a4,a4,0x6
ffffffffc0202246:	00e606b3          	add	a3,a2,a4
ffffffffc020224a:	c02007b7          	lui	a5,0xc0200
ffffffffc020224e:	2ef6ece3          	bltu	a3,a5,ffffffffc0202d46 <pmm_init+0xbe8>
ffffffffc0202252:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202256:	77fd                	lui	a5,0xfffff
ffffffffc0202258:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020225a:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc020225c:	5086eb63          	bltu	a3,s0,ffffffffc0202772 <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202260:	00003517          	auipc	a0,0x3
ffffffffc0202264:	c4050513          	addi	a0,a0,-960 # ffffffffc0204ea0 <default_pmm_manager+0x1d8>
ffffffffc0202268:	f2dfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc020226c:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202270:	0000b917          	auipc	s2,0xb
ffffffffc0202274:	23890913          	addi	s2,s2,568 # ffffffffc020d4a8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202278:	7b9c                	ld	a5,48(a5)
ffffffffc020227a:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020227c:	00003517          	auipc	a0,0x3
ffffffffc0202280:	c3c50513          	addi	a0,a0,-964 # ffffffffc0204eb8 <default_pmm_manager+0x1f0>
ffffffffc0202284:	f11fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202288:	00006697          	auipc	a3,0x6
ffffffffc020228c:	d7868693          	addi	a3,a3,-648 # ffffffffc0208000 <boot_page_table_sv39>
ffffffffc0202290:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202294:	c02007b7          	lui	a5,0xc0200
ffffffffc0202298:	28f6ebe3          	bltu	a3,a5,ffffffffc0202d2e <pmm_init+0xbd0>
ffffffffc020229c:	0009b783          	ld	a5,0(s3)
ffffffffc02022a0:	8e9d                	sub	a3,a3,a5
ffffffffc02022a2:	0000b797          	auipc	a5,0xb
ffffffffc02022a6:	1ed7bf23          	sd	a3,510(a5) # ffffffffc020d4a0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02022aa:	100027f3          	csrr	a5,sstatus
ffffffffc02022ae:	8b89                	andi	a5,a5,2
ffffffffc02022b0:	4a079763          	bnez	a5,ffffffffc020275e <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc02022b4:	000b3783          	ld	a5,0(s6)
ffffffffc02022b8:	779c                	ld	a5,40(a5)
ffffffffc02022ba:	9782                	jalr	a5
ffffffffc02022bc:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02022be:	6098                	ld	a4,0(s1)
ffffffffc02022c0:	c80007b7          	lui	a5,0xc8000
ffffffffc02022c4:	83b1                	srli	a5,a5,0xc
ffffffffc02022c6:	66e7e363          	bltu	a5,a4,ffffffffc020292c <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02022ca:	00093503          	ld	a0,0(s2)
ffffffffc02022ce:	62050f63          	beqz	a0,ffffffffc020290c <pmm_init+0x7ae>
ffffffffc02022d2:	03451793          	slli	a5,a0,0x34
ffffffffc02022d6:	62079b63          	bnez	a5,ffffffffc020290c <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02022da:	4601                	li	a2,0
ffffffffc02022dc:	4581                	li	a1,0
ffffffffc02022de:	c9bff0ef          	jal	ra,ffffffffc0201f78 <get_page>
ffffffffc02022e2:	60051563          	bnez	a0,ffffffffc02028ec <pmm_init+0x78e>
ffffffffc02022e6:	100027f3          	csrr	a5,sstatus
ffffffffc02022ea:	8b89                	andi	a5,a5,2
ffffffffc02022ec:	44079e63          	bnez	a5,ffffffffc0202748 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc02022f0:	000b3783          	ld	a5,0(s6)
ffffffffc02022f4:	4505                	li	a0,1
ffffffffc02022f6:	6f9c                	ld	a5,24(a5)
ffffffffc02022f8:	9782                	jalr	a5
ffffffffc02022fa:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02022fc:	00093503          	ld	a0,0(s2)
ffffffffc0202300:	4681                	li	a3,0
ffffffffc0202302:	4601                	li	a2,0
ffffffffc0202304:	85d2                	mv	a1,s4
ffffffffc0202306:	d63ff0ef          	jal	ra,ffffffffc0202068 <page_insert>
ffffffffc020230a:	26051ae3          	bnez	a0,ffffffffc0202d7e <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc020230e:	00093503          	ld	a0,0(s2)
ffffffffc0202312:	4601                	li	a2,0
ffffffffc0202314:	4581                	li	a1,0
ffffffffc0202316:	a3bff0ef          	jal	ra,ffffffffc0201d50 <get_pte>
ffffffffc020231a:	240502e3          	beqz	a0,ffffffffc0202d5e <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc020231e:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202320:	0017f713          	andi	a4,a5,1
ffffffffc0202324:	5a070263          	beqz	a4,ffffffffc02028c8 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202328:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020232a:	078a                	slli	a5,a5,0x2
ffffffffc020232c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020232e:	58e7fb63          	bgeu	a5,a4,ffffffffc02028c4 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202332:	000bb683          	ld	a3,0(s7)
ffffffffc0202336:	fff80637          	lui	a2,0xfff80
ffffffffc020233a:	97b2                	add	a5,a5,a2
ffffffffc020233c:	079a                	slli	a5,a5,0x6
ffffffffc020233e:	97b6                	add	a5,a5,a3
ffffffffc0202340:	14fa17e3          	bne	s4,a5,ffffffffc0202c8e <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc0202344:	000a2683          	lw	a3,0(s4) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc0202348:	4785                	li	a5,1
ffffffffc020234a:	12f692e3          	bne	a3,a5,ffffffffc0202c6e <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020234e:	00093503          	ld	a0,0(s2)
ffffffffc0202352:	77fd                	lui	a5,0xfffff
ffffffffc0202354:	6114                	ld	a3,0(a0)
ffffffffc0202356:	068a                	slli	a3,a3,0x2
ffffffffc0202358:	8efd                	and	a3,a3,a5
ffffffffc020235a:	00c6d613          	srli	a2,a3,0xc
ffffffffc020235e:	0ee67ce3          	bgeu	a2,a4,ffffffffc0202c56 <pmm_init+0xaf8>
ffffffffc0202362:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202366:	96e2                	add	a3,a3,s8
ffffffffc0202368:	0006ba83          	ld	s5,0(a3)
ffffffffc020236c:	0a8a                	slli	s5,s5,0x2
ffffffffc020236e:	00fafab3          	and	s5,s5,a5
ffffffffc0202372:	00cad793          	srli	a5,s5,0xc
ffffffffc0202376:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0202c3c <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020237a:	4601                	li	a2,0
ffffffffc020237c:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020237e:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202380:	9d1ff0ef          	jal	ra,ffffffffc0201d50 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202384:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202386:	55551363          	bne	a0,s5,ffffffffc02028cc <pmm_init+0x76e>
ffffffffc020238a:	100027f3          	csrr	a5,sstatus
ffffffffc020238e:	8b89                	andi	a5,a5,2
ffffffffc0202390:	3a079163          	bnez	a5,ffffffffc0202732 <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202394:	000b3783          	ld	a5,0(s6)
ffffffffc0202398:	4505                	li	a0,1
ffffffffc020239a:	6f9c                	ld	a5,24(a5)
ffffffffc020239c:	9782                	jalr	a5
ffffffffc020239e:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02023a0:	00093503          	ld	a0,0(s2)
ffffffffc02023a4:	46d1                	li	a3,20
ffffffffc02023a6:	6605                	lui	a2,0x1
ffffffffc02023a8:	85e2                	mv	a1,s8
ffffffffc02023aa:	cbfff0ef          	jal	ra,ffffffffc0202068 <page_insert>
ffffffffc02023ae:	060517e3          	bnez	a0,ffffffffc0202c1c <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02023b2:	00093503          	ld	a0,0(s2)
ffffffffc02023b6:	4601                	li	a2,0
ffffffffc02023b8:	6585                	lui	a1,0x1
ffffffffc02023ba:	997ff0ef          	jal	ra,ffffffffc0201d50 <get_pte>
ffffffffc02023be:	02050fe3          	beqz	a0,ffffffffc0202bfc <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc02023c2:	611c                	ld	a5,0(a0)
ffffffffc02023c4:	0107f713          	andi	a4,a5,16
ffffffffc02023c8:	7c070e63          	beqz	a4,ffffffffc0202ba4 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc02023cc:	8b91                	andi	a5,a5,4
ffffffffc02023ce:	7a078b63          	beqz	a5,ffffffffc0202b84 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02023d2:	00093503          	ld	a0,0(s2)
ffffffffc02023d6:	611c                	ld	a5,0(a0)
ffffffffc02023d8:	8bc1                	andi	a5,a5,16
ffffffffc02023da:	78078563          	beqz	a5,ffffffffc0202b64 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc02023de:	000c2703          	lw	a4,0(s8) # ff0000 <kern_entry-0xffffffffbf210000>
ffffffffc02023e2:	4785                	li	a5,1
ffffffffc02023e4:	76f71063          	bne	a4,a5,ffffffffc0202b44 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02023e8:	4681                	li	a3,0
ffffffffc02023ea:	6605                	lui	a2,0x1
ffffffffc02023ec:	85d2                	mv	a1,s4
ffffffffc02023ee:	c7bff0ef          	jal	ra,ffffffffc0202068 <page_insert>
ffffffffc02023f2:	72051963          	bnez	a0,ffffffffc0202b24 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc02023f6:	000a2703          	lw	a4,0(s4)
ffffffffc02023fa:	4789                	li	a5,2
ffffffffc02023fc:	70f71463          	bne	a4,a5,ffffffffc0202b04 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc0202400:	000c2783          	lw	a5,0(s8)
ffffffffc0202404:	6e079063          	bnez	a5,ffffffffc0202ae4 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202408:	00093503          	ld	a0,0(s2)
ffffffffc020240c:	4601                	li	a2,0
ffffffffc020240e:	6585                	lui	a1,0x1
ffffffffc0202410:	941ff0ef          	jal	ra,ffffffffc0201d50 <get_pte>
ffffffffc0202414:	6a050863          	beqz	a0,ffffffffc0202ac4 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0202418:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc020241a:	00177793          	andi	a5,a4,1
ffffffffc020241e:	4a078563          	beqz	a5,ffffffffc02028c8 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202422:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202424:	00271793          	slli	a5,a4,0x2
ffffffffc0202428:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020242a:	48d7fd63          	bgeu	a5,a3,ffffffffc02028c4 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020242e:	000bb683          	ld	a3,0(s7)
ffffffffc0202432:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202436:	97d6                	add	a5,a5,s5
ffffffffc0202438:	079a                	slli	a5,a5,0x6
ffffffffc020243a:	97b6                	add	a5,a5,a3
ffffffffc020243c:	66fa1463          	bne	s4,a5,ffffffffc0202aa4 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202440:	8b41                	andi	a4,a4,16
ffffffffc0202442:	64071163          	bnez	a4,ffffffffc0202a84 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202446:	00093503          	ld	a0,0(s2)
ffffffffc020244a:	4581                	li	a1,0
ffffffffc020244c:	b81ff0ef          	jal	ra,ffffffffc0201fcc <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202450:	000a2c83          	lw	s9,0(s4)
ffffffffc0202454:	4785                	li	a5,1
ffffffffc0202456:	60fc9763          	bne	s9,a5,ffffffffc0202a64 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc020245a:	000c2783          	lw	a5,0(s8)
ffffffffc020245e:	5e079363          	bnez	a5,ffffffffc0202a44 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202462:	00093503          	ld	a0,0(s2)
ffffffffc0202466:	6585                	lui	a1,0x1
ffffffffc0202468:	b65ff0ef          	jal	ra,ffffffffc0201fcc <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc020246c:	000a2783          	lw	a5,0(s4)
ffffffffc0202470:	52079a63          	bnez	a5,ffffffffc02029a4 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202474:	000c2783          	lw	a5,0(s8)
ffffffffc0202478:	50079663          	bnez	a5,ffffffffc0202984 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc020247c:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202480:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202482:	000a3683          	ld	a3,0(s4)
ffffffffc0202486:	068a                	slli	a3,a3,0x2
ffffffffc0202488:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc020248a:	42b6fd63          	bgeu	a3,a1,ffffffffc02028c4 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020248e:	000bb503          	ld	a0,0(s7)
ffffffffc0202492:	96d6                	add	a3,a3,s5
ffffffffc0202494:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202496:	00d507b3          	add	a5,a0,a3
ffffffffc020249a:	439c                	lw	a5,0(a5)
ffffffffc020249c:	4d979463          	bne	a5,s9,ffffffffc0202964 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc02024a0:	8699                	srai	a3,a3,0x6
ffffffffc02024a2:	00080637          	lui	a2,0x80
ffffffffc02024a6:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02024a8:	00c69713          	slli	a4,a3,0xc
ffffffffc02024ac:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02024ae:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02024b0:	48b77e63          	bgeu	a4,a1,ffffffffc020294c <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc02024b4:	0009b703          	ld	a4,0(s3)
ffffffffc02024b8:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc02024ba:	629c                	ld	a5,0(a3)
ffffffffc02024bc:	078a                	slli	a5,a5,0x2
ffffffffc02024be:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024c0:	40b7f263          	bgeu	a5,a1,ffffffffc02028c4 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02024c4:	8f91                	sub	a5,a5,a2
ffffffffc02024c6:	079a                	slli	a5,a5,0x6
ffffffffc02024c8:	953e                	add	a0,a0,a5
ffffffffc02024ca:	100027f3          	csrr	a5,sstatus
ffffffffc02024ce:	8b89                	andi	a5,a5,2
ffffffffc02024d0:	30079963          	bnez	a5,ffffffffc02027e2 <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc02024d4:	000b3783          	ld	a5,0(s6)
ffffffffc02024d8:	4585                	li	a1,1
ffffffffc02024da:	739c                	ld	a5,32(a5)
ffffffffc02024dc:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02024de:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc02024e2:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02024e4:	078a                	slli	a5,a5,0x2
ffffffffc02024e6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024e8:	3ce7fe63          	bgeu	a5,a4,ffffffffc02028c4 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02024ec:	000bb503          	ld	a0,0(s7)
ffffffffc02024f0:	fff80737          	lui	a4,0xfff80
ffffffffc02024f4:	97ba                	add	a5,a5,a4
ffffffffc02024f6:	079a                	slli	a5,a5,0x6
ffffffffc02024f8:	953e                	add	a0,a0,a5
ffffffffc02024fa:	100027f3          	csrr	a5,sstatus
ffffffffc02024fe:	8b89                	andi	a5,a5,2
ffffffffc0202500:	2c079563          	bnez	a5,ffffffffc02027ca <pmm_init+0x66c>
ffffffffc0202504:	000b3783          	ld	a5,0(s6)
ffffffffc0202508:	4585                	li	a1,1
ffffffffc020250a:	739c                	ld	a5,32(a5)
ffffffffc020250c:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc020250e:	00093783          	ld	a5,0(s2)
ffffffffc0202512:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdf1b14>
    asm volatile("sfence.vma");
ffffffffc0202516:	12000073          	sfence.vma
ffffffffc020251a:	100027f3          	csrr	a5,sstatus
ffffffffc020251e:	8b89                	andi	a5,a5,2
ffffffffc0202520:	28079b63          	bnez	a5,ffffffffc02027b6 <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202524:	000b3783          	ld	a5,0(s6)
ffffffffc0202528:	779c                	ld	a5,40(a5)
ffffffffc020252a:	9782                	jalr	a5
ffffffffc020252c:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc020252e:	4b441b63          	bne	s0,s4,ffffffffc02029e4 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202532:	00003517          	auipc	a0,0x3
ffffffffc0202536:	cae50513          	addi	a0,a0,-850 # ffffffffc02051e0 <default_pmm_manager+0x518>
ffffffffc020253a:	c5bfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020253e:	100027f3          	csrr	a5,sstatus
ffffffffc0202542:	8b89                	andi	a5,a5,2
ffffffffc0202544:	24079f63          	bnez	a5,ffffffffc02027a2 <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202548:	000b3783          	ld	a5,0(s6)
ffffffffc020254c:	779c                	ld	a5,40(a5)
ffffffffc020254e:	9782                	jalr	a5
ffffffffc0202550:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202552:	6098                	ld	a4,0(s1)
ffffffffc0202554:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202558:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc020255a:	00c71793          	slli	a5,a4,0xc
ffffffffc020255e:	6a05                	lui	s4,0x1
ffffffffc0202560:	02f47c63          	bgeu	s0,a5,ffffffffc0202598 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202564:	00c45793          	srli	a5,s0,0xc
ffffffffc0202568:	00093503          	ld	a0,0(s2)
ffffffffc020256c:	2ee7ff63          	bgeu	a5,a4,ffffffffc020286a <pmm_init+0x70c>
ffffffffc0202570:	0009b583          	ld	a1,0(s3)
ffffffffc0202574:	4601                	li	a2,0
ffffffffc0202576:	95a2                	add	a1,a1,s0
ffffffffc0202578:	fd8ff0ef          	jal	ra,ffffffffc0201d50 <get_pte>
ffffffffc020257c:	32050463          	beqz	a0,ffffffffc02028a4 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202580:	611c                	ld	a5,0(a0)
ffffffffc0202582:	078a                	slli	a5,a5,0x2
ffffffffc0202584:	0157f7b3          	and	a5,a5,s5
ffffffffc0202588:	2e879e63          	bne	a5,s0,ffffffffc0202884 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc020258c:	6098                	ld	a4,0(s1)
ffffffffc020258e:	9452                	add	s0,s0,s4
ffffffffc0202590:	00c71793          	slli	a5,a4,0xc
ffffffffc0202594:	fcf468e3          	bltu	s0,a5,ffffffffc0202564 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202598:	00093783          	ld	a5,0(s2)
ffffffffc020259c:	639c                	ld	a5,0(a5)
ffffffffc020259e:	42079363          	bnez	a5,ffffffffc02029c4 <pmm_init+0x866>
ffffffffc02025a2:	100027f3          	csrr	a5,sstatus
ffffffffc02025a6:	8b89                	andi	a5,a5,2
ffffffffc02025a8:	24079963          	bnez	a5,ffffffffc02027fa <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc02025ac:	000b3783          	ld	a5,0(s6)
ffffffffc02025b0:	4505                	li	a0,1
ffffffffc02025b2:	6f9c                	ld	a5,24(a5)
ffffffffc02025b4:	9782                	jalr	a5
ffffffffc02025b6:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02025b8:	00093503          	ld	a0,0(s2)
ffffffffc02025bc:	4699                	li	a3,6
ffffffffc02025be:	10000613          	li	a2,256
ffffffffc02025c2:	85d2                	mv	a1,s4
ffffffffc02025c4:	aa5ff0ef          	jal	ra,ffffffffc0202068 <page_insert>
ffffffffc02025c8:	44051e63          	bnez	a0,ffffffffc0202a24 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc02025cc:	000a2703          	lw	a4,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc02025d0:	4785                	li	a5,1
ffffffffc02025d2:	42f71963          	bne	a4,a5,ffffffffc0202a04 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02025d6:	00093503          	ld	a0,0(s2)
ffffffffc02025da:	6405                	lui	s0,0x1
ffffffffc02025dc:	4699                	li	a3,6
ffffffffc02025de:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc02025e2:	85d2                	mv	a1,s4
ffffffffc02025e4:	a85ff0ef          	jal	ra,ffffffffc0202068 <page_insert>
ffffffffc02025e8:	72051363          	bnez	a0,ffffffffc0202d0e <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc02025ec:	000a2703          	lw	a4,0(s4)
ffffffffc02025f0:	4789                	li	a5,2
ffffffffc02025f2:	6ef71e63          	bne	a4,a5,ffffffffc0202cee <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc02025f6:	00003597          	auipc	a1,0x3
ffffffffc02025fa:	d3258593          	addi	a1,a1,-718 # ffffffffc0205328 <default_pmm_manager+0x660>
ffffffffc02025fe:	10000513          	li	a0,256
ffffffffc0202602:	7d8010ef          	jal	ra,ffffffffc0203dda <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202606:	10040593          	addi	a1,s0,256
ffffffffc020260a:	10000513          	li	a0,256
ffffffffc020260e:	7de010ef          	jal	ra,ffffffffc0203dec <strcmp>
ffffffffc0202612:	6a051e63          	bnez	a0,ffffffffc0202cce <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202616:	000bb683          	ld	a3,0(s7)
ffffffffc020261a:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc020261e:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202620:	40da06b3          	sub	a3,s4,a3
ffffffffc0202624:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202626:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202628:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc020262a:	8031                	srli	s0,s0,0xc
ffffffffc020262c:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202630:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202632:	30f77d63          	bgeu	a4,a5,ffffffffc020294c <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202636:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc020263a:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc020263e:	96be                	add	a3,a3,a5
ffffffffc0202640:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202644:	760010ef          	jal	ra,ffffffffc0203da4 <strlen>
ffffffffc0202648:	66051363          	bnez	a0,ffffffffc0202cae <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc020264c:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202650:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202652:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fdf1b14>
ffffffffc0202656:	068a                	slli	a3,a3,0x2
ffffffffc0202658:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc020265a:	26f6f563          	bgeu	a3,a5,ffffffffc02028c4 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc020265e:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202660:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202662:	2ef47563          	bgeu	s0,a5,ffffffffc020294c <pmm_init+0x7ee>
ffffffffc0202666:	0009b403          	ld	s0,0(s3)
ffffffffc020266a:	9436                	add	s0,s0,a3
ffffffffc020266c:	100027f3          	csrr	a5,sstatus
ffffffffc0202670:	8b89                	andi	a5,a5,2
ffffffffc0202672:	1e079163          	bnez	a5,ffffffffc0202854 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202676:	000b3783          	ld	a5,0(s6)
ffffffffc020267a:	4585                	li	a1,1
ffffffffc020267c:	8552                	mv	a0,s4
ffffffffc020267e:	739c                	ld	a5,32(a5)
ffffffffc0202680:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202682:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202684:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202686:	078a                	slli	a5,a5,0x2
ffffffffc0202688:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020268a:	22e7fd63          	bgeu	a5,a4,ffffffffc02028c4 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020268e:	000bb503          	ld	a0,0(s7)
ffffffffc0202692:	fff80737          	lui	a4,0xfff80
ffffffffc0202696:	97ba                	add	a5,a5,a4
ffffffffc0202698:	079a                	slli	a5,a5,0x6
ffffffffc020269a:	953e                	add	a0,a0,a5
ffffffffc020269c:	100027f3          	csrr	a5,sstatus
ffffffffc02026a0:	8b89                	andi	a5,a5,2
ffffffffc02026a2:	18079d63          	bnez	a5,ffffffffc020283c <pmm_init+0x6de>
ffffffffc02026a6:	000b3783          	ld	a5,0(s6)
ffffffffc02026aa:	4585                	li	a1,1
ffffffffc02026ac:	739c                	ld	a5,32(a5)
ffffffffc02026ae:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02026b0:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc02026b4:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02026b6:	078a                	slli	a5,a5,0x2
ffffffffc02026b8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02026ba:	20e7f563          	bgeu	a5,a4,ffffffffc02028c4 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02026be:	000bb503          	ld	a0,0(s7)
ffffffffc02026c2:	fff80737          	lui	a4,0xfff80
ffffffffc02026c6:	97ba                	add	a5,a5,a4
ffffffffc02026c8:	079a                	slli	a5,a5,0x6
ffffffffc02026ca:	953e                	add	a0,a0,a5
ffffffffc02026cc:	100027f3          	csrr	a5,sstatus
ffffffffc02026d0:	8b89                	andi	a5,a5,2
ffffffffc02026d2:	14079963          	bnez	a5,ffffffffc0202824 <pmm_init+0x6c6>
ffffffffc02026d6:	000b3783          	ld	a5,0(s6)
ffffffffc02026da:	4585                	li	a1,1
ffffffffc02026dc:	739c                	ld	a5,32(a5)
ffffffffc02026de:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc02026e0:	00093783          	ld	a5,0(s2)
ffffffffc02026e4:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc02026e8:	12000073          	sfence.vma
ffffffffc02026ec:	100027f3          	csrr	a5,sstatus
ffffffffc02026f0:	8b89                	andi	a5,a5,2
ffffffffc02026f2:	10079f63          	bnez	a5,ffffffffc0202810 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc02026f6:	000b3783          	ld	a5,0(s6)
ffffffffc02026fa:	779c                	ld	a5,40(a5)
ffffffffc02026fc:	9782                	jalr	a5
ffffffffc02026fe:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202700:	4c8c1e63          	bne	s8,s0,ffffffffc0202bdc <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202704:	00003517          	auipc	a0,0x3
ffffffffc0202708:	c9c50513          	addi	a0,a0,-868 # ffffffffc02053a0 <default_pmm_manager+0x6d8>
ffffffffc020270c:	a89fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0202710:	7406                	ld	s0,96(sp)
ffffffffc0202712:	70a6                	ld	ra,104(sp)
ffffffffc0202714:	64e6                	ld	s1,88(sp)
ffffffffc0202716:	6946                	ld	s2,80(sp)
ffffffffc0202718:	69a6                	ld	s3,72(sp)
ffffffffc020271a:	6a06                	ld	s4,64(sp)
ffffffffc020271c:	7ae2                	ld	s5,56(sp)
ffffffffc020271e:	7b42                	ld	s6,48(sp)
ffffffffc0202720:	7ba2                	ld	s7,40(sp)
ffffffffc0202722:	7c02                	ld	s8,32(sp)
ffffffffc0202724:	6ce2                	ld	s9,24(sp)
ffffffffc0202726:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202728:	b72ff06f          	j	ffffffffc0201a9a <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc020272c:	c80007b7          	lui	a5,0xc8000
ffffffffc0202730:	bc7d                	j	ffffffffc02021ee <pmm_init+0x90>
        intr_disable();
ffffffffc0202732:	9fefe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202736:	000b3783          	ld	a5,0(s6)
ffffffffc020273a:	4505                	li	a0,1
ffffffffc020273c:	6f9c                	ld	a5,24(a5)
ffffffffc020273e:	9782                	jalr	a5
ffffffffc0202740:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202742:	9e8fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202746:	b9a9                	j	ffffffffc02023a0 <pmm_init+0x242>
        intr_disable();
ffffffffc0202748:	9e8fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020274c:	000b3783          	ld	a5,0(s6)
ffffffffc0202750:	4505                	li	a0,1
ffffffffc0202752:	6f9c                	ld	a5,24(a5)
ffffffffc0202754:	9782                	jalr	a5
ffffffffc0202756:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202758:	9d2fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020275c:	b645                	j	ffffffffc02022fc <pmm_init+0x19e>
        intr_disable();
ffffffffc020275e:	9d2fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202762:	000b3783          	ld	a5,0(s6)
ffffffffc0202766:	779c                	ld	a5,40(a5)
ffffffffc0202768:	9782                	jalr	a5
ffffffffc020276a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020276c:	9befe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202770:	b6b9                	j	ffffffffc02022be <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202772:	6705                	lui	a4,0x1
ffffffffc0202774:	177d                	addi	a4,a4,-1
ffffffffc0202776:	96ba                	add	a3,a3,a4
ffffffffc0202778:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc020277a:	00c7d713          	srli	a4,a5,0xc
ffffffffc020277e:	14a77363          	bgeu	a4,a0,ffffffffc02028c4 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202782:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202786:	fff80537          	lui	a0,0xfff80
ffffffffc020278a:	972a                	add	a4,a4,a0
ffffffffc020278c:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020278e:	8c1d                	sub	s0,s0,a5
ffffffffc0202790:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202794:	00c45593          	srli	a1,s0,0xc
ffffffffc0202798:	9532                	add	a0,a0,a2
ffffffffc020279a:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc020279c:	0009b583          	ld	a1,0(s3)
}
ffffffffc02027a0:	b4c1                	j	ffffffffc0202260 <pmm_init+0x102>
        intr_disable();
ffffffffc02027a2:	98efe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02027a6:	000b3783          	ld	a5,0(s6)
ffffffffc02027aa:	779c                	ld	a5,40(a5)
ffffffffc02027ac:	9782                	jalr	a5
ffffffffc02027ae:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc02027b0:	97afe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02027b4:	bb79                	j	ffffffffc0202552 <pmm_init+0x3f4>
        intr_disable();
ffffffffc02027b6:	97afe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc02027ba:	000b3783          	ld	a5,0(s6)
ffffffffc02027be:	779c                	ld	a5,40(a5)
ffffffffc02027c0:	9782                	jalr	a5
ffffffffc02027c2:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc02027c4:	966fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02027c8:	b39d                	j	ffffffffc020252e <pmm_init+0x3d0>
ffffffffc02027ca:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02027cc:	964fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02027d0:	000b3783          	ld	a5,0(s6)
ffffffffc02027d4:	6522                	ld	a0,8(sp)
ffffffffc02027d6:	4585                	li	a1,1
ffffffffc02027d8:	739c                	ld	a5,32(a5)
ffffffffc02027da:	9782                	jalr	a5
        intr_enable();
ffffffffc02027dc:	94efe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02027e0:	b33d                	j	ffffffffc020250e <pmm_init+0x3b0>
ffffffffc02027e2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02027e4:	94cfe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc02027e8:	000b3783          	ld	a5,0(s6)
ffffffffc02027ec:	6522                	ld	a0,8(sp)
ffffffffc02027ee:	4585                	li	a1,1
ffffffffc02027f0:	739c                	ld	a5,32(a5)
ffffffffc02027f2:	9782                	jalr	a5
        intr_enable();
ffffffffc02027f4:	936fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02027f8:	b1dd                	j	ffffffffc02024de <pmm_init+0x380>
        intr_disable();
ffffffffc02027fa:	936fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02027fe:	000b3783          	ld	a5,0(s6)
ffffffffc0202802:	4505                	li	a0,1
ffffffffc0202804:	6f9c                	ld	a5,24(a5)
ffffffffc0202806:	9782                	jalr	a5
ffffffffc0202808:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc020280a:	920fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020280e:	b36d                	j	ffffffffc02025b8 <pmm_init+0x45a>
        intr_disable();
ffffffffc0202810:	920fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202814:	000b3783          	ld	a5,0(s6)
ffffffffc0202818:	779c                	ld	a5,40(a5)
ffffffffc020281a:	9782                	jalr	a5
ffffffffc020281c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020281e:	90cfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202822:	bdf9                	j	ffffffffc0202700 <pmm_init+0x5a2>
ffffffffc0202824:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202826:	90afe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020282a:	000b3783          	ld	a5,0(s6)
ffffffffc020282e:	6522                	ld	a0,8(sp)
ffffffffc0202830:	4585                	li	a1,1
ffffffffc0202832:	739c                	ld	a5,32(a5)
ffffffffc0202834:	9782                	jalr	a5
        intr_enable();
ffffffffc0202836:	8f4fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020283a:	b55d                	j	ffffffffc02026e0 <pmm_init+0x582>
ffffffffc020283c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020283e:	8f2fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0202842:	000b3783          	ld	a5,0(s6)
ffffffffc0202846:	6522                	ld	a0,8(sp)
ffffffffc0202848:	4585                	li	a1,1
ffffffffc020284a:	739c                	ld	a5,32(a5)
ffffffffc020284c:	9782                	jalr	a5
        intr_enable();
ffffffffc020284e:	8dcfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202852:	bdb9                	j	ffffffffc02026b0 <pmm_init+0x552>
        intr_disable();
ffffffffc0202854:	8dcfe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0202858:	000b3783          	ld	a5,0(s6)
ffffffffc020285c:	4585                	li	a1,1
ffffffffc020285e:	8552                	mv	a0,s4
ffffffffc0202860:	739c                	ld	a5,32(a5)
ffffffffc0202862:	9782                	jalr	a5
        intr_enable();
ffffffffc0202864:	8c6fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202868:	bd29                	j	ffffffffc0202682 <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020286a:	86a2                	mv	a3,s0
ffffffffc020286c:	00002617          	auipc	a2,0x2
ffffffffc0202870:	49460613          	addi	a2,a2,1172 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0202874:	1a400593          	li	a1,420
ffffffffc0202878:	00002517          	auipc	a0,0x2
ffffffffc020287c:	5a050513          	addi	a0,a0,1440 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202880:	bdbfd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202884:	00003697          	auipc	a3,0x3
ffffffffc0202888:	9bc68693          	addi	a3,a3,-1604 # ffffffffc0205240 <default_pmm_manager+0x578>
ffffffffc020288c:	00002617          	auipc	a2,0x2
ffffffffc0202890:	08c60613          	addi	a2,a2,140 # ffffffffc0204918 <commands+0x818>
ffffffffc0202894:	1a500593          	li	a1,421
ffffffffc0202898:	00002517          	auipc	a0,0x2
ffffffffc020289c:	58050513          	addi	a0,a0,1408 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc02028a0:	bbbfd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02028a4:	00003697          	auipc	a3,0x3
ffffffffc02028a8:	95c68693          	addi	a3,a3,-1700 # ffffffffc0205200 <default_pmm_manager+0x538>
ffffffffc02028ac:	00002617          	auipc	a2,0x2
ffffffffc02028b0:	06c60613          	addi	a2,a2,108 # ffffffffc0204918 <commands+0x818>
ffffffffc02028b4:	1a400593          	li	a1,420
ffffffffc02028b8:	00002517          	auipc	a0,0x2
ffffffffc02028bc:	56050513          	addi	a0,a0,1376 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc02028c0:	b9bfd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02028c4:	b9cff0ef          	jal	ra,ffffffffc0201c60 <pa2page.part.0>
ffffffffc02028c8:	bb4ff0ef          	jal	ra,ffffffffc0201c7c <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02028cc:	00002697          	auipc	a3,0x2
ffffffffc02028d0:	72c68693          	addi	a3,a3,1836 # ffffffffc0204ff8 <default_pmm_manager+0x330>
ffffffffc02028d4:	00002617          	auipc	a2,0x2
ffffffffc02028d8:	04460613          	addi	a2,a2,68 # ffffffffc0204918 <commands+0x818>
ffffffffc02028dc:	17400593          	li	a1,372
ffffffffc02028e0:	00002517          	auipc	a0,0x2
ffffffffc02028e4:	53850513          	addi	a0,a0,1336 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc02028e8:	b73fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02028ec:	00002697          	auipc	a3,0x2
ffffffffc02028f0:	64c68693          	addi	a3,a3,1612 # ffffffffc0204f38 <default_pmm_manager+0x270>
ffffffffc02028f4:	00002617          	auipc	a2,0x2
ffffffffc02028f8:	02460613          	addi	a2,a2,36 # ffffffffc0204918 <commands+0x818>
ffffffffc02028fc:	16700593          	li	a1,359
ffffffffc0202900:	00002517          	auipc	a0,0x2
ffffffffc0202904:	51850513          	addi	a0,a0,1304 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202908:	b53fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc020290c:	00002697          	auipc	a3,0x2
ffffffffc0202910:	5ec68693          	addi	a3,a3,1516 # ffffffffc0204ef8 <default_pmm_manager+0x230>
ffffffffc0202914:	00002617          	auipc	a2,0x2
ffffffffc0202918:	00460613          	addi	a2,a2,4 # ffffffffc0204918 <commands+0x818>
ffffffffc020291c:	16600593          	li	a1,358
ffffffffc0202920:	00002517          	auipc	a0,0x2
ffffffffc0202924:	4f850513          	addi	a0,a0,1272 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202928:	b33fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020292c:	00002697          	auipc	a3,0x2
ffffffffc0202930:	5ac68693          	addi	a3,a3,1452 # ffffffffc0204ed8 <default_pmm_manager+0x210>
ffffffffc0202934:	00002617          	auipc	a2,0x2
ffffffffc0202938:	fe460613          	addi	a2,a2,-28 # ffffffffc0204918 <commands+0x818>
ffffffffc020293c:	16500593          	li	a1,357
ffffffffc0202940:	00002517          	auipc	a0,0x2
ffffffffc0202944:	4d850513          	addi	a0,a0,1240 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202948:	b13fd0ef          	jal	ra,ffffffffc020045a <__panic>
    return KADDR(page2pa(page));
ffffffffc020294c:	00002617          	auipc	a2,0x2
ffffffffc0202950:	3b460613          	addi	a2,a2,948 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0202954:	07100593          	li	a1,113
ffffffffc0202958:	00002517          	auipc	a0,0x2
ffffffffc020295c:	3d050513          	addi	a0,a0,976 # ffffffffc0204d28 <default_pmm_manager+0x60>
ffffffffc0202960:	afbfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202964:	00003697          	auipc	a3,0x3
ffffffffc0202968:	82468693          	addi	a3,a3,-2012 # ffffffffc0205188 <default_pmm_manager+0x4c0>
ffffffffc020296c:	00002617          	auipc	a2,0x2
ffffffffc0202970:	fac60613          	addi	a2,a2,-84 # ffffffffc0204918 <commands+0x818>
ffffffffc0202974:	18d00593          	li	a1,397
ffffffffc0202978:	00002517          	auipc	a0,0x2
ffffffffc020297c:	4a050513          	addi	a0,a0,1184 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202980:	adbfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202984:	00002697          	auipc	a3,0x2
ffffffffc0202988:	7bc68693          	addi	a3,a3,1980 # ffffffffc0205140 <default_pmm_manager+0x478>
ffffffffc020298c:	00002617          	auipc	a2,0x2
ffffffffc0202990:	f8c60613          	addi	a2,a2,-116 # ffffffffc0204918 <commands+0x818>
ffffffffc0202994:	18b00593          	li	a1,395
ffffffffc0202998:	00002517          	auipc	a0,0x2
ffffffffc020299c:	48050513          	addi	a0,a0,1152 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc02029a0:	abbfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p1) == 0);
ffffffffc02029a4:	00002697          	auipc	a3,0x2
ffffffffc02029a8:	7cc68693          	addi	a3,a3,1996 # ffffffffc0205170 <default_pmm_manager+0x4a8>
ffffffffc02029ac:	00002617          	auipc	a2,0x2
ffffffffc02029b0:	f6c60613          	addi	a2,a2,-148 # ffffffffc0204918 <commands+0x818>
ffffffffc02029b4:	18a00593          	li	a1,394
ffffffffc02029b8:	00002517          	auipc	a0,0x2
ffffffffc02029bc:	46050513          	addi	a0,a0,1120 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc02029c0:	a9bfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc02029c4:	00003697          	auipc	a3,0x3
ffffffffc02029c8:	89468693          	addi	a3,a3,-1900 # ffffffffc0205258 <default_pmm_manager+0x590>
ffffffffc02029cc:	00002617          	auipc	a2,0x2
ffffffffc02029d0:	f4c60613          	addi	a2,a2,-180 # ffffffffc0204918 <commands+0x818>
ffffffffc02029d4:	1a800593          	li	a1,424
ffffffffc02029d8:	00002517          	auipc	a0,0x2
ffffffffc02029dc:	44050513          	addi	a0,a0,1088 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc02029e0:	a7bfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02029e4:	00002697          	auipc	a3,0x2
ffffffffc02029e8:	7d468693          	addi	a3,a3,2004 # ffffffffc02051b8 <default_pmm_manager+0x4f0>
ffffffffc02029ec:	00002617          	auipc	a2,0x2
ffffffffc02029f0:	f2c60613          	addi	a2,a2,-212 # ffffffffc0204918 <commands+0x818>
ffffffffc02029f4:	19500593          	li	a1,405
ffffffffc02029f8:	00002517          	auipc	a0,0x2
ffffffffc02029fc:	42050513          	addi	a0,a0,1056 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202a00:	a5bfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202a04:	00003697          	auipc	a3,0x3
ffffffffc0202a08:	8ac68693          	addi	a3,a3,-1876 # ffffffffc02052b0 <default_pmm_manager+0x5e8>
ffffffffc0202a0c:	00002617          	auipc	a2,0x2
ffffffffc0202a10:	f0c60613          	addi	a2,a2,-244 # ffffffffc0204918 <commands+0x818>
ffffffffc0202a14:	1ad00593          	li	a1,429
ffffffffc0202a18:	00002517          	auipc	a0,0x2
ffffffffc0202a1c:	40050513          	addi	a0,a0,1024 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202a20:	a3bfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202a24:	00003697          	auipc	a3,0x3
ffffffffc0202a28:	84c68693          	addi	a3,a3,-1972 # ffffffffc0205270 <default_pmm_manager+0x5a8>
ffffffffc0202a2c:	00002617          	auipc	a2,0x2
ffffffffc0202a30:	eec60613          	addi	a2,a2,-276 # ffffffffc0204918 <commands+0x818>
ffffffffc0202a34:	1ac00593          	li	a1,428
ffffffffc0202a38:	00002517          	auipc	a0,0x2
ffffffffc0202a3c:	3e050513          	addi	a0,a0,992 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202a40:	a1bfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202a44:	00002697          	auipc	a3,0x2
ffffffffc0202a48:	6fc68693          	addi	a3,a3,1788 # ffffffffc0205140 <default_pmm_manager+0x478>
ffffffffc0202a4c:	00002617          	auipc	a2,0x2
ffffffffc0202a50:	ecc60613          	addi	a2,a2,-308 # ffffffffc0204918 <commands+0x818>
ffffffffc0202a54:	18700593          	li	a1,391
ffffffffc0202a58:	00002517          	auipc	a0,0x2
ffffffffc0202a5c:	3c050513          	addi	a0,a0,960 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202a60:	9fbfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202a64:	00002697          	auipc	a3,0x2
ffffffffc0202a68:	57c68693          	addi	a3,a3,1404 # ffffffffc0204fe0 <default_pmm_manager+0x318>
ffffffffc0202a6c:	00002617          	auipc	a2,0x2
ffffffffc0202a70:	eac60613          	addi	a2,a2,-340 # ffffffffc0204918 <commands+0x818>
ffffffffc0202a74:	18600593          	li	a1,390
ffffffffc0202a78:	00002517          	auipc	a0,0x2
ffffffffc0202a7c:	3a050513          	addi	a0,a0,928 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202a80:	9dbfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202a84:	00002697          	auipc	a3,0x2
ffffffffc0202a88:	6d468693          	addi	a3,a3,1748 # ffffffffc0205158 <default_pmm_manager+0x490>
ffffffffc0202a8c:	00002617          	auipc	a2,0x2
ffffffffc0202a90:	e8c60613          	addi	a2,a2,-372 # ffffffffc0204918 <commands+0x818>
ffffffffc0202a94:	18300593          	li	a1,387
ffffffffc0202a98:	00002517          	auipc	a0,0x2
ffffffffc0202a9c:	38050513          	addi	a0,a0,896 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202aa0:	9bbfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202aa4:	00002697          	auipc	a3,0x2
ffffffffc0202aa8:	52468693          	addi	a3,a3,1316 # ffffffffc0204fc8 <default_pmm_manager+0x300>
ffffffffc0202aac:	00002617          	auipc	a2,0x2
ffffffffc0202ab0:	e6c60613          	addi	a2,a2,-404 # ffffffffc0204918 <commands+0x818>
ffffffffc0202ab4:	18200593          	li	a1,386
ffffffffc0202ab8:	00002517          	auipc	a0,0x2
ffffffffc0202abc:	36050513          	addi	a0,a0,864 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202ac0:	99bfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202ac4:	00002697          	auipc	a3,0x2
ffffffffc0202ac8:	5a468693          	addi	a3,a3,1444 # ffffffffc0205068 <default_pmm_manager+0x3a0>
ffffffffc0202acc:	00002617          	auipc	a2,0x2
ffffffffc0202ad0:	e4c60613          	addi	a2,a2,-436 # ffffffffc0204918 <commands+0x818>
ffffffffc0202ad4:	18100593          	li	a1,385
ffffffffc0202ad8:	00002517          	auipc	a0,0x2
ffffffffc0202adc:	34050513          	addi	a0,a0,832 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202ae0:	97bfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202ae4:	00002697          	auipc	a3,0x2
ffffffffc0202ae8:	65c68693          	addi	a3,a3,1628 # ffffffffc0205140 <default_pmm_manager+0x478>
ffffffffc0202aec:	00002617          	auipc	a2,0x2
ffffffffc0202af0:	e2c60613          	addi	a2,a2,-468 # ffffffffc0204918 <commands+0x818>
ffffffffc0202af4:	18000593          	li	a1,384
ffffffffc0202af8:	00002517          	auipc	a0,0x2
ffffffffc0202afc:	32050513          	addi	a0,a0,800 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202b00:	95bfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202b04:	00002697          	auipc	a3,0x2
ffffffffc0202b08:	62468693          	addi	a3,a3,1572 # ffffffffc0205128 <default_pmm_manager+0x460>
ffffffffc0202b0c:	00002617          	auipc	a2,0x2
ffffffffc0202b10:	e0c60613          	addi	a2,a2,-500 # ffffffffc0204918 <commands+0x818>
ffffffffc0202b14:	17f00593          	li	a1,383
ffffffffc0202b18:	00002517          	auipc	a0,0x2
ffffffffc0202b1c:	30050513          	addi	a0,a0,768 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202b20:	93bfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202b24:	00002697          	auipc	a3,0x2
ffffffffc0202b28:	5d468693          	addi	a3,a3,1492 # ffffffffc02050f8 <default_pmm_manager+0x430>
ffffffffc0202b2c:	00002617          	auipc	a2,0x2
ffffffffc0202b30:	dec60613          	addi	a2,a2,-532 # ffffffffc0204918 <commands+0x818>
ffffffffc0202b34:	17e00593          	li	a1,382
ffffffffc0202b38:	00002517          	auipc	a0,0x2
ffffffffc0202b3c:	2e050513          	addi	a0,a0,736 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202b40:	91bfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202b44:	00002697          	auipc	a3,0x2
ffffffffc0202b48:	59c68693          	addi	a3,a3,1436 # ffffffffc02050e0 <default_pmm_manager+0x418>
ffffffffc0202b4c:	00002617          	auipc	a2,0x2
ffffffffc0202b50:	dcc60613          	addi	a2,a2,-564 # ffffffffc0204918 <commands+0x818>
ffffffffc0202b54:	17c00593          	li	a1,380
ffffffffc0202b58:	00002517          	auipc	a0,0x2
ffffffffc0202b5c:	2c050513          	addi	a0,a0,704 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202b60:	8fbfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202b64:	00002697          	auipc	a3,0x2
ffffffffc0202b68:	55c68693          	addi	a3,a3,1372 # ffffffffc02050c0 <default_pmm_manager+0x3f8>
ffffffffc0202b6c:	00002617          	auipc	a2,0x2
ffffffffc0202b70:	dac60613          	addi	a2,a2,-596 # ffffffffc0204918 <commands+0x818>
ffffffffc0202b74:	17b00593          	li	a1,379
ffffffffc0202b78:	00002517          	auipc	a0,0x2
ffffffffc0202b7c:	2a050513          	addi	a0,a0,672 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202b80:	8dbfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(*ptep & PTE_W);
ffffffffc0202b84:	00002697          	auipc	a3,0x2
ffffffffc0202b88:	52c68693          	addi	a3,a3,1324 # ffffffffc02050b0 <default_pmm_manager+0x3e8>
ffffffffc0202b8c:	00002617          	auipc	a2,0x2
ffffffffc0202b90:	d8c60613          	addi	a2,a2,-628 # ffffffffc0204918 <commands+0x818>
ffffffffc0202b94:	17a00593          	li	a1,378
ffffffffc0202b98:	00002517          	auipc	a0,0x2
ffffffffc0202b9c:	28050513          	addi	a0,a0,640 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202ba0:	8bbfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(*ptep & PTE_U);
ffffffffc0202ba4:	00002697          	auipc	a3,0x2
ffffffffc0202ba8:	4fc68693          	addi	a3,a3,1276 # ffffffffc02050a0 <default_pmm_manager+0x3d8>
ffffffffc0202bac:	00002617          	auipc	a2,0x2
ffffffffc0202bb0:	d6c60613          	addi	a2,a2,-660 # ffffffffc0204918 <commands+0x818>
ffffffffc0202bb4:	17900593          	li	a1,377
ffffffffc0202bb8:	00002517          	auipc	a0,0x2
ffffffffc0202bbc:	26050513          	addi	a0,a0,608 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202bc0:	89bfd0ef          	jal	ra,ffffffffc020045a <__panic>
        panic("DTB memory info not available");
ffffffffc0202bc4:	00002617          	auipc	a2,0x2
ffffffffc0202bc8:	27c60613          	addi	a2,a2,636 # ffffffffc0204e40 <default_pmm_manager+0x178>
ffffffffc0202bcc:	06400593          	li	a1,100
ffffffffc0202bd0:	00002517          	auipc	a0,0x2
ffffffffc0202bd4:	24850513          	addi	a0,a0,584 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202bd8:	883fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202bdc:	00002697          	auipc	a3,0x2
ffffffffc0202be0:	5dc68693          	addi	a3,a3,1500 # ffffffffc02051b8 <default_pmm_manager+0x4f0>
ffffffffc0202be4:	00002617          	auipc	a2,0x2
ffffffffc0202be8:	d3460613          	addi	a2,a2,-716 # ffffffffc0204918 <commands+0x818>
ffffffffc0202bec:	1bf00593          	li	a1,447
ffffffffc0202bf0:	00002517          	auipc	a0,0x2
ffffffffc0202bf4:	22850513          	addi	a0,a0,552 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202bf8:	863fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202bfc:	00002697          	auipc	a3,0x2
ffffffffc0202c00:	46c68693          	addi	a3,a3,1132 # ffffffffc0205068 <default_pmm_manager+0x3a0>
ffffffffc0202c04:	00002617          	auipc	a2,0x2
ffffffffc0202c08:	d1460613          	addi	a2,a2,-748 # ffffffffc0204918 <commands+0x818>
ffffffffc0202c0c:	17800593          	li	a1,376
ffffffffc0202c10:	00002517          	auipc	a0,0x2
ffffffffc0202c14:	20850513          	addi	a0,a0,520 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202c18:	843fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202c1c:	00002697          	auipc	a3,0x2
ffffffffc0202c20:	40c68693          	addi	a3,a3,1036 # ffffffffc0205028 <default_pmm_manager+0x360>
ffffffffc0202c24:	00002617          	auipc	a2,0x2
ffffffffc0202c28:	cf460613          	addi	a2,a2,-780 # ffffffffc0204918 <commands+0x818>
ffffffffc0202c2c:	17700593          	li	a1,375
ffffffffc0202c30:	00002517          	auipc	a0,0x2
ffffffffc0202c34:	1e850513          	addi	a0,a0,488 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202c38:	823fd0ef          	jal	ra,ffffffffc020045a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202c3c:	86d6                	mv	a3,s5
ffffffffc0202c3e:	00002617          	auipc	a2,0x2
ffffffffc0202c42:	0c260613          	addi	a2,a2,194 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0202c46:	17300593          	li	a1,371
ffffffffc0202c4a:	00002517          	auipc	a0,0x2
ffffffffc0202c4e:	1ce50513          	addi	a0,a0,462 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202c52:	809fd0ef          	jal	ra,ffffffffc020045a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202c56:	00002617          	auipc	a2,0x2
ffffffffc0202c5a:	0aa60613          	addi	a2,a2,170 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc0202c5e:	17200593          	li	a1,370
ffffffffc0202c62:	00002517          	auipc	a0,0x2
ffffffffc0202c66:	1b650513          	addi	a0,a0,438 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202c6a:	ff0fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202c6e:	00002697          	auipc	a3,0x2
ffffffffc0202c72:	37268693          	addi	a3,a3,882 # ffffffffc0204fe0 <default_pmm_manager+0x318>
ffffffffc0202c76:	00002617          	auipc	a2,0x2
ffffffffc0202c7a:	ca260613          	addi	a2,a2,-862 # ffffffffc0204918 <commands+0x818>
ffffffffc0202c7e:	17000593          	li	a1,368
ffffffffc0202c82:	00002517          	auipc	a0,0x2
ffffffffc0202c86:	19650513          	addi	a0,a0,406 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202c8a:	fd0fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202c8e:	00002697          	auipc	a3,0x2
ffffffffc0202c92:	33a68693          	addi	a3,a3,826 # ffffffffc0204fc8 <default_pmm_manager+0x300>
ffffffffc0202c96:	00002617          	auipc	a2,0x2
ffffffffc0202c9a:	c8260613          	addi	a2,a2,-894 # ffffffffc0204918 <commands+0x818>
ffffffffc0202c9e:	16f00593          	li	a1,367
ffffffffc0202ca2:	00002517          	auipc	a0,0x2
ffffffffc0202ca6:	17650513          	addi	a0,a0,374 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202caa:	fb0fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202cae:	00002697          	auipc	a3,0x2
ffffffffc0202cb2:	6ca68693          	addi	a3,a3,1738 # ffffffffc0205378 <default_pmm_manager+0x6b0>
ffffffffc0202cb6:	00002617          	auipc	a2,0x2
ffffffffc0202cba:	c6260613          	addi	a2,a2,-926 # ffffffffc0204918 <commands+0x818>
ffffffffc0202cbe:	1b600593          	li	a1,438
ffffffffc0202cc2:	00002517          	auipc	a0,0x2
ffffffffc0202cc6:	15650513          	addi	a0,a0,342 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202cca:	f90fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202cce:	00002697          	auipc	a3,0x2
ffffffffc0202cd2:	67268693          	addi	a3,a3,1650 # ffffffffc0205340 <default_pmm_manager+0x678>
ffffffffc0202cd6:	00002617          	auipc	a2,0x2
ffffffffc0202cda:	c4260613          	addi	a2,a2,-958 # ffffffffc0204918 <commands+0x818>
ffffffffc0202cde:	1b300593          	li	a1,435
ffffffffc0202ce2:	00002517          	auipc	a0,0x2
ffffffffc0202ce6:	13650513          	addi	a0,a0,310 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202cea:	f70fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p) == 2);
ffffffffc0202cee:	00002697          	auipc	a3,0x2
ffffffffc0202cf2:	62268693          	addi	a3,a3,1570 # ffffffffc0205310 <default_pmm_manager+0x648>
ffffffffc0202cf6:	00002617          	auipc	a2,0x2
ffffffffc0202cfa:	c2260613          	addi	a2,a2,-990 # ffffffffc0204918 <commands+0x818>
ffffffffc0202cfe:	1af00593          	li	a1,431
ffffffffc0202d02:	00002517          	auipc	a0,0x2
ffffffffc0202d06:	11650513          	addi	a0,a0,278 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202d0a:	f50fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202d0e:	00002697          	auipc	a3,0x2
ffffffffc0202d12:	5ba68693          	addi	a3,a3,1466 # ffffffffc02052c8 <default_pmm_manager+0x600>
ffffffffc0202d16:	00002617          	auipc	a2,0x2
ffffffffc0202d1a:	c0260613          	addi	a2,a2,-1022 # ffffffffc0204918 <commands+0x818>
ffffffffc0202d1e:	1ae00593          	li	a1,430
ffffffffc0202d22:	00002517          	auipc	a0,0x2
ffffffffc0202d26:	0f650513          	addi	a0,a0,246 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202d2a:	f30fd0ef          	jal	ra,ffffffffc020045a <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202d2e:	00002617          	auipc	a2,0x2
ffffffffc0202d32:	07a60613          	addi	a2,a2,122 # ffffffffc0204da8 <default_pmm_manager+0xe0>
ffffffffc0202d36:	0cb00593          	li	a1,203
ffffffffc0202d3a:	00002517          	auipc	a0,0x2
ffffffffc0202d3e:	0de50513          	addi	a0,a0,222 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202d42:	f18fd0ef          	jal	ra,ffffffffc020045a <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202d46:	00002617          	auipc	a2,0x2
ffffffffc0202d4a:	06260613          	addi	a2,a2,98 # ffffffffc0204da8 <default_pmm_manager+0xe0>
ffffffffc0202d4e:	08000593          	li	a1,128
ffffffffc0202d52:	00002517          	auipc	a0,0x2
ffffffffc0202d56:	0c650513          	addi	a0,a0,198 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202d5a:	f00fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202d5e:	00002697          	auipc	a3,0x2
ffffffffc0202d62:	23a68693          	addi	a3,a3,570 # ffffffffc0204f98 <default_pmm_manager+0x2d0>
ffffffffc0202d66:	00002617          	auipc	a2,0x2
ffffffffc0202d6a:	bb260613          	addi	a2,a2,-1102 # ffffffffc0204918 <commands+0x818>
ffffffffc0202d6e:	16e00593          	li	a1,366
ffffffffc0202d72:	00002517          	auipc	a0,0x2
ffffffffc0202d76:	0a650513          	addi	a0,a0,166 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202d7a:	ee0fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202d7e:	00002697          	auipc	a3,0x2
ffffffffc0202d82:	1ea68693          	addi	a3,a3,490 # ffffffffc0204f68 <default_pmm_manager+0x2a0>
ffffffffc0202d86:	00002617          	auipc	a2,0x2
ffffffffc0202d8a:	b9260613          	addi	a2,a2,-1134 # ffffffffc0204918 <commands+0x818>
ffffffffc0202d8e:	16b00593          	li	a1,363
ffffffffc0202d92:	00002517          	auipc	a0,0x2
ffffffffc0202d96:	08650513          	addi	a0,a0,134 # ffffffffc0204e18 <default_pmm_manager+0x150>
ffffffffc0202d9a:	ec0fd0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0202d9e <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0202d9e:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0202da0:	00002697          	auipc	a3,0x2
ffffffffc0202da4:	62068693          	addi	a3,a3,1568 # ffffffffc02053c0 <default_pmm_manager+0x6f8>
ffffffffc0202da8:	00002617          	auipc	a2,0x2
ffffffffc0202dac:	b7060613          	addi	a2,a2,-1168 # ffffffffc0204918 <commands+0x818>
ffffffffc0202db0:	08800593          	li	a1,136
ffffffffc0202db4:	00002517          	auipc	a0,0x2
ffffffffc0202db8:	62c50513          	addi	a0,a0,1580 # ffffffffc02053e0 <default_pmm_manager+0x718>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0202dbc:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0202dbe:	e9cfd0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0202dc2 <find_vma>:
{
ffffffffc0202dc2:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0202dc4:	c505                	beqz	a0,ffffffffc0202dec <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0202dc6:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0202dc8:	c501                	beqz	a0,ffffffffc0202dd0 <find_vma+0xe>
ffffffffc0202dca:	651c                	ld	a5,8(a0)
ffffffffc0202dcc:	02f5f263          	bgeu	a1,a5,ffffffffc0202df0 <find_vma+0x2e>
    return listelm->next;
ffffffffc0202dd0:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0202dd2:	00f68d63          	beq	a3,a5,ffffffffc0202dec <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0202dd6:	fe87b703          	ld	a4,-24(a5) # ffffffffc7ffffe8 <end+0x7df2afc>
ffffffffc0202dda:	00e5e663          	bltu	a1,a4,ffffffffc0202de6 <find_vma+0x24>
ffffffffc0202dde:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202de2:	00e5ec63          	bltu	a1,a4,ffffffffc0202dfa <find_vma+0x38>
ffffffffc0202de6:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0202de8:	fef697e3          	bne	a3,a5,ffffffffc0202dd6 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0202dec:	4501                	li	a0,0
}
ffffffffc0202dee:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0202df0:	691c                	ld	a5,16(a0)
ffffffffc0202df2:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0202dd0 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0202df6:	ea88                	sd	a0,16(a3)
ffffffffc0202df8:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0202dfa:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0202dfe:	ea88                	sd	a0,16(a3)
ffffffffc0202e00:	8082                	ret

ffffffffc0202e02 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202e02:	6590                	ld	a2,8(a1)
ffffffffc0202e04:	0105b803          	ld	a6,16(a1)
{
ffffffffc0202e08:	1141                	addi	sp,sp,-16
ffffffffc0202e0a:	e406                	sd	ra,8(sp)
ffffffffc0202e0c:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202e0e:	01066763          	bltu	a2,a6,ffffffffc0202e1c <insert_vma_struct+0x1a>
ffffffffc0202e12:	a085                	j	ffffffffc0202e72 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0202e14:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202e18:	04e66863          	bltu	a2,a4,ffffffffc0202e68 <insert_vma_struct+0x66>
ffffffffc0202e1c:	86be                	mv	a3,a5
ffffffffc0202e1e:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0202e20:	fef51ae3          	bne	a0,a5,ffffffffc0202e14 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0202e24:	02a68463          	beq	a3,a0,ffffffffc0202e4c <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0202e28:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202e2c:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202e30:	08e8f163          	bgeu	a7,a4,ffffffffc0202eb2 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202e34:	04e66f63          	bltu	a2,a4,ffffffffc0202e92 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0202e38:	00f50a63          	beq	a0,a5,ffffffffc0202e4c <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0202e3c:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202e40:	05076963          	bltu	a4,a6,ffffffffc0202e92 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0202e44:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202e48:	02c77363          	bgeu	a4,a2,ffffffffc0202e6e <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0202e4c:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0202e4e:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0202e50:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0202e54:	e390                	sd	a2,0(a5)
ffffffffc0202e56:	e690                	sd	a2,8(a3)
}
ffffffffc0202e58:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0202e5a:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0202e5c:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0202e5e:	0017079b          	addiw	a5,a4,1
ffffffffc0202e62:	d11c                	sw	a5,32(a0)
}
ffffffffc0202e64:	0141                	addi	sp,sp,16
ffffffffc0202e66:	8082                	ret
    if (le_prev != list)
ffffffffc0202e68:	fca690e3          	bne	a3,a0,ffffffffc0202e28 <insert_vma_struct+0x26>
ffffffffc0202e6c:	bfd1                	j	ffffffffc0202e40 <insert_vma_struct+0x3e>
ffffffffc0202e6e:	f31ff0ef          	jal	ra,ffffffffc0202d9e <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202e72:	00002697          	auipc	a3,0x2
ffffffffc0202e76:	57e68693          	addi	a3,a3,1406 # ffffffffc02053f0 <default_pmm_manager+0x728>
ffffffffc0202e7a:	00002617          	auipc	a2,0x2
ffffffffc0202e7e:	a9e60613          	addi	a2,a2,-1378 # ffffffffc0204918 <commands+0x818>
ffffffffc0202e82:	08e00593          	li	a1,142
ffffffffc0202e86:	00002517          	auipc	a0,0x2
ffffffffc0202e8a:	55a50513          	addi	a0,a0,1370 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0202e8e:	dccfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202e92:	00002697          	auipc	a3,0x2
ffffffffc0202e96:	59e68693          	addi	a3,a3,1438 # ffffffffc0205430 <default_pmm_manager+0x768>
ffffffffc0202e9a:	00002617          	auipc	a2,0x2
ffffffffc0202e9e:	a7e60613          	addi	a2,a2,-1410 # ffffffffc0204918 <commands+0x818>
ffffffffc0202ea2:	08700593          	li	a1,135
ffffffffc0202ea6:	00002517          	auipc	a0,0x2
ffffffffc0202eaa:	53a50513          	addi	a0,a0,1338 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0202eae:	dacfd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202eb2:	00002697          	auipc	a3,0x2
ffffffffc0202eb6:	55e68693          	addi	a3,a3,1374 # ffffffffc0205410 <default_pmm_manager+0x748>
ffffffffc0202eba:	00002617          	auipc	a2,0x2
ffffffffc0202ebe:	a5e60613          	addi	a2,a2,-1442 # ffffffffc0204918 <commands+0x818>
ffffffffc0202ec2:	08600593          	li	a1,134
ffffffffc0202ec6:	00002517          	auipc	a0,0x2
ffffffffc0202eca:	51a50513          	addi	a0,a0,1306 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0202ece:	d8cfd0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0202ed2 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0202ed2:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202ed4:	03000513          	li	a0,48
{
ffffffffc0202ed8:	fc06                	sd	ra,56(sp)
ffffffffc0202eda:	f822                	sd	s0,48(sp)
ffffffffc0202edc:	f426                	sd	s1,40(sp)
ffffffffc0202ede:	f04a                	sd	s2,32(sp)
ffffffffc0202ee0:	ec4e                	sd	s3,24(sp)
ffffffffc0202ee2:	e852                	sd	s4,16(sp)
ffffffffc0202ee4:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202ee6:	bd5fe0ef          	jal	ra,ffffffffc0201aba <kmalloc>
    if (mm != NULL)
ffffffffc0202eea:	2e050f63          	beqz	a0,ffffffffc02031e8 <vmm_init+0x316>
ffffffffc0202eee:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0202ef0:	e508                	sd	a0,8(a0)
ffffffffc0202ef2:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0202ef4:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0202ef8:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0202efc:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0202f00:	02053423          	sd	zero,40(a0)
ffffffffc0202f04:	03200413          	li	s0,50
ffffffffc0202f08:	a811                	j	ffffffffc0202f1c <vmm_init+0x4a>
        vma->vm_start = vm_start;
ffffffffc0202f0a:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202f0c:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202f0e:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0202f12:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202f14:	8526                	mv	a0,s1
ffffffffc0202f16:	eedff0ef          	jal	ra,ffffffffc0202e02 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0202f1a:	c80d                	beqz	s0,ffffffffc0202f4c <vmm_init+0x7a>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202f1c:	03000513          	li	a0,48
ffffffffc0202f20:	b9bfe0ef          	jal	ra,ffffffffc0201aba <kmalloc>
ffffffffc0202f24:	85aa                	mv	a1,a0
ffffffffc0202f26:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0202f2a:	f165                	bnez	a0,ffffffffc0202f0a <vmm_init+0x38>
        assert(vma != NULL);
ffffffffc0202f2c:	00002697          	auipc	a3,0x2
ffffffffc0202f30:	69c68693          	addi	a3,a3,1692 # ffffffffc02055c8 <default_pmm_manager+0x900>
ffffffffc0202f34:	00002617          	auipc	a2,0x2
ffffffffc0202f38:	9e460613          	addi	a2,a2,-1564 # ffffffffc0204918 <commands+0x818>
ffffffffc0202f3c:	0da00593          	li	a1,218
ffffffffc0202f40:	00002517          	auipc	a0,0x2
ffffffffc0202f44:	4a050513          	addi	a0,a0,1184 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0202f48:	d12fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202f4c:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202f50:	1f900913          	li	s2,505
ffffffffc0202f54:	a819                	j	ffffffffc0202f6a <vmm_init+0x98>
        vma->vm_start = vm_start;
ffffffffc0202f56:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202f58:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202f5a:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202f5e:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202f60:	8526                	mv	a0,s1
ffffffffc0202f62:	ea1ff0ef          	jal	ra,ffffffffc0202e02 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202f66:	03240a63          	beq	s0,s2,ffffffffc0202f9a <vmm_init+0xc8>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202f6a:	03000513          	li	a0,48
ffffffffc0202f6e:	b4dfe0ef          	jal	ra,ffffffffc0201aba <kmalloc>
ffffffffc0202f72:	85aa                	mv	a1,a0
ffffffffc0202f74:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0202f78:	fd79                	bnez	a0,ffffffffc0202f56 <vmm_init+0x84>
        assert(vma != NULL);
ffffffffc0202f7a:	00002697          	auipc	a3,0x2
ffffffffc0202f7e:	64e68693          	addi	a3,a3,1614 # ffffffffc02055c8 <default_pmm_manager+0x900>
ffffffffc0202f82:	00002617          	auipc	a2,0x2
ffffffffc0202f86:	99660613          	addi	a2,a2,-1642 # ffffffffc0204918 <commands+0x818>
ffffffffc0202f8a:	0e100593          	li	a1,225
ffffffffc0202f8e:	00002517          	auipc	a0,0x2
ffffffffc0202f92:	45250513          	addi	a0,a0,1106 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0202f96:	cc4fd0ef          	jal	ra,ffffffffc020045a <__panic>
    return listelm->next;
ffffffffc0202f9a:	649c                	ld	a5,8(s1)
ffffffffc0202f9c:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0202f9e:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0202fa2:	18f48363          	beq	s1,a5,ffffffffc0203128 <vmm_init+0x256>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202fa6:	fe87b603          	ld	a2,-24(a5)
ffffffffc0202faa:	ffe70693          	addi	a3,a4,-2 # ffe <kern_entry-0xffffffffc01ff002>
ffffffffc0202fae:	10d61d63          	bne	a2,a3,ffffffffc02030c8 <vmm_init+0x1f6>
ffffffffc0202fb2:	ff07b683          	ld	a3,-16(a5)
ffffffffc0202fb6:	10e69963          	bne	a3,a4,ffffffffc02030c8 <vmm_init+0x1f6>
    for (i = 1; i <= step2; i++)
ffffffffc0202fba:	0715                	addi	a4,a4,5
ffffffffc0202fbc:	679c                	ld	a5,8(a5)
ffffffffc0202fbe:	feb712e3          	bne	a4,a1,ffffffffc0202fa2 <vmm_init+0xd0>
ffffffffc0202fc2:	4a1d                	li	s4,7
ffffffffc0202fc4:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0202fc6:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0202fca:	85a2                	mv	a1,s0
ffffffffc0202fcc:	8526                	mv	a0,s1
ffffffffc0202fce:	df5ff0ef          	jal	ra,ffffffffc0202dc2 <find_vma>
ffffffffc0202fd2:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0202fd4:	18050a63          	beqz	a0,ffffffffc0203168 <vmm_init+0x296>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0202fd8:	00140593          	addi	a1,s0,1
ffffffffc0202fdc:	8526                	mv	a0,s1
ffffffffc0202fde:	de5ff0ef          	jal	ra,ffffffffc0202dc2 <find_vma>
ffffffffc0202fe2:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0202fe4:	16050263          	beqz	a0,ffffffffc0203148 <vmm_init+0x276>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0202fe8:	85d2                	mv	a1,s4
ffffffffc0202fea:	8526                	mv	a0,s1
ffffffffc0202fec:	dd7ff0ef          	jal	ra,ffffffffc0202dc2 <find_vma>
        assert(vma3 == NULL);
ffffffffc0202ff0:	18051c63          	bnez	a0,ffffffffc0203188 <vmm_init+0x2b6>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0202ff4:	00340593          	addi	a1,s0,3
ffffffffc0202ff8:	8526                	mv	a0,s1
ffffffffc0202ffa:	dc9ff0ef          	jal	ra,ffffffffc0202dc2 <find_vma>
        assert(vma4 == NULL);
ffffffffc0202ffe:	1c051563          	bnez	a0,ffffffffc02031c8 <vmm_init+0x2f6>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203002:	00440593          	addi	a1,s0,4
ffffffffc0203006:	8526                	mv	a0,s1
ffffffffc0203008:	dbbff0ef          	jal	ra,ffffffffc0202dc2 <find_vma>
        assert(vma5 == NULL);
ffffffffc020300c:	18051e63          	bnez	a0,ffffffffc02031a8 <vmm_init+0x2d6>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203010:	00893783          	ld	a5,8(s2)
ffffffffc0203014:	0c879a63          	bne	a5,s0,ffffffffc02030e8 <vmm_init+0x216>
ffffffffc0203018:	01093783          	ld	a5,16(s2)
ffffffffc020301c:	0d479663          	bne	a5,s4,ffffffffc02030e8 <vmm_init+0x216>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203020:	0089b783          	ld	a5,8(s3)
ffffffffc0203024:	0e879263          	bne	a5,s0,ffffffffc0203108 <vmm_init+0x236>
ffffffffc0203028:	0109b783          	ld	a5,16(s3)
ffffffffc020302c:	0d479e63          	bne	a5,s4,ffffffffc0203108 <vmm_init+0x236>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203030:	0415                	addi	s0,s0,5
ffffffffc0203032:	0a15                	addi	s4,s4,5
ffffffffc0203034:	f9541be3          	bne	s0,s5,ffffffffc0202fca <vmm_init+0xf8>
ffffffffc0203038:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc020303a:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc020303c:	85a2                	mv	a1,s0
ffffffffc020303e:	8526                	mv	a0,s1
ffffffffc0203040:	d83ff0ef          	jal	ra,ffffffffc0202dc2 <find_vma>
ffffffffc0203044:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203048:	c90d                	beqz	a0,ffffffffc020307a <vmm_init+0x1a8>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc020304a:	6914                	ld	a3,16(a0)
ffffffffc020304c:	6510                	ld	a2,8(a0)
ffffffffc020304e:	00002517          	auipc	a0,0x2
ffffffffc0203052:	50250513          	addi	a0,a0,1282 # ffffffffc0205550 <default_pmm_manager+0x888>
ffffffffc0203056:	93efd0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc020305a:	00002697          	auipc	a3,0x2
ffffffffc020305e:	51e68693          	addi	a3,a3,1310 # ffffffffc0205578 <default_pmm_manager+0x8b0>
ffffffffc0203062:	00002617          	auipc	a2,0x2
ffffffffc0203066:	8b660613          	addi	a2,a2,-1866 # ffffffffc0204918 <commands+0x818>
ffffffffc020306a:	10700593          	li	a1,263
ffffffffc020306e:	00002517          	auipc	a0,0x2
ffffffffc0203072:	37250513          	addi	a0,a0,882 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0203076:	be4fd0ef          	jal	ra,ffffffffc020045a <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc020307a:	147d                	addi	s0,s0,-1
ffffffffc020307c:	fd2410e3          	bne	s0,s2,ffffffffc020303c <vmm_init+0x16a>
ffffffffc0203080:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list)
ffffffffc0203082:	00a48c63          	beq	s1,a0,ffffffffc020309a <vmm_init+0x1c8>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203086:	6118                	ld	a4,0(a0)
ffffffffc0203088:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc020308a:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc020308c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020308e:	e398                	sd	a4,0(a5)
ffffffffc0203090:	adbfe0ef          	jal	ra,ffffffffc0201b6a <kfree>
    return listelm->next;
ffffffffc0203094:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list)
ffffffffc0203096:	fea498e3          	bne	s1,a0,ffffffffc0203086 <vmm_init+0x1b4>
    kfree(mm); // kfree mm
ffffffffc020309a:	8526                	mv	a0,s1
ffffffffc020309c:	acffe0ef          	jal	ra,ffffffffc0201b6a <kfree>
    }

    mm_destroy(mm);

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc02030a0:	00002517          	auipc	a0,0x2
ffffffffc02030a4:	4f050513          	addi	a0,a0,1264 # ffffffffc0205590 <default_pmm_manager+0x8c8>
ffffffffc02030a8:	8ecfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc02030ac:	7442                	ld	s0,48(sp)
ffffffffc02030ae:	70e2                	ld	ra,56(sp)
ffffffffc02030b0:	74a2                	ld	s1,40(sp)
ffffffffc02030b2:	7902                	ld	s2,32(sp)
ffffffffc02030b4:	69e2                	ld	s3,24(sp)
ffffffffc02030b6:	6a42                	ld	s4,16(sp)
ffffffffc02030b8:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc02030ba:	00002517          	auipc	a0,0x2
ffffffffc02030be:	4f650513          	addi	a0,a0,1270 # ffffffffc02055b0 <default_pmm_manager+0x8e8>
}
ffffffffc02030c2:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc02030c4:	8d0fd06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc02030c8:	00002697          	auipc	a3,0x2
ffffffffc02030cc:	3a068693          	addi	a3,a3,928 # ffffffffc0205468 <default_pmm_manager+0x7a0>
ffffffffc02030d0:	00002617          	auipc	a2,0x2
ffffffffc02030d4:	84860613          	addi	a2,a2,-1976 # ffffffffc0204918 <commands+0x818>
ffffffffc02030d8:	0eb00593          	li	a1,235
ffffffffc02030dc:	00002517          	auipc	a0,0x2
ffffffffc02030e0:	30450513          	addi	a0,a0,772 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc02030e4:	b76fd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc02030e8:	00002697          	auipc	a3,0x2
ffffffffc02030ec:	40868693          	addi	a3,a3,1032 # ffffffffc02054f0 <default_pmm_manager+0x828>
ffffffffc02030f0:	00002617          	auipc	a2,0x2
ffffffffc02030f4:	82860613          	addi	a2,a2,-2008 # ffffffffc0204918 <commands+0x818>
ffffffffc02030f8:	0fc00593          	li	a1,252
ffffffffc02030fc:	00002517          	auipc	a0,0x2
ffffffffc0203100:	2e450513          	addi	a0,a0,740 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0203104:	b56fd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203108:	00002697          	auipc	a3,0x2
ffffffffc020310c:	41868693          	addi	a3,a3,1048 # ffffffffc0205520 <default_pmm_manager+0x858>
ffffffffc0203110:	00002617          	auipc	a2,0x2
ffffffffc0203114:	80860613          	addi	a2,a2,-2040 # ffffffffc0204918 <commands+0x818>
ffffffffc0203118:	0fd00593          	li	a1,253
ffffffffc020311c:	00002517          	auipc	a0,0x2
ffffffffc0203120:	2c450513          	addi	a0,a0,708 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0203124:	b36fd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203128:	00002697          	auipc	a3,0x2
ffffffffc020312c:	32868693          	addi	a3,a3,808 # ffffffffc0205450 <default_pmm_manager+0x788>
ffffffffc0203130:	00001617          	auipc	a2,0x1
ffffffffc0203134:	7e860613          	addi	a2,a2,2024 # ffffffffc0204918 <commands+0x818>
ffffffffc0203138:	0e900593          	li	a1,233
ffffffffc020313c:	00002517          	auipc	a0,0x2
ffffffffc0203140:	2a450513          	addi	a0,a0,676 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0203144:	b16fd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma2 != NULL);
ffffffffc0203148:	00002697          	auipc	a3,0x2
ffffffffc020314c:	36868693          	addi	a3,a3,872 # ffffffffc02054b0 <default_pmm_manager+0x7e8>
ffffffffc0203150:	00001617          	auipc	a2,0x1
ffffffffc0203154:	7c860613          	addi	a2,a2,1992 # ffffffffc0204918 <commands+0x818>
ffffffffc0203158:	0f400593          	li	a1,244
ffffffffc020315c:	00002517          	auipc	a0,0x2
ffffffffc0203160:	28450513          	addi	a0,a0,644 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0203164:	af6fd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma1 != NULL);
ffffffffc0203168:	00002697          	auipc	a3,0x2
ffffffffc020316c:	33868693          	addi	a3,a3,824 # ffffffffc02054a0 <default_pmm_manager+0x7d8>
ffffffffc0203170:	00001617          	auipc	a2,0x1
ffffffffc0203174:	7a860613          	addi	a2,a2,1960 # ffffffffc0204918 <commands+0x818>
ffffffffc0203178:	0f200593          	li	a1,242
ffffffffc020317c:	00002517          	auipc	a0,0x2
ffffffffc0203180:	26450513          	addi	a0,a0,612 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0203184:	ad6fd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma3 == NULL);
ffffffffc0203188:	00002697          	auipc	a3,0x2
ffffffffc020318c:	33868693          	addi	a3,a3,824 # ffffffffc02054c0 <default_pmm_manager+0x7f8>
ffffffffc0203190:	00001617          	auipc	a2,0x1
ffffffffc0203194:	78860613          	addi	a2,a2,1928 # ffffffffc0204918 <commands+0x818>
ffffffffc0203198:	0f600593          	li	a1,246
ffffffffc020319c:	00002517          	auipc	a0,0x2
ffffffffc02031a0:	24450513          	addi	a0,a0,580 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc02031a4:	ab6fd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma5 == NULL);
ffffffffc02031a8:	00002697          	auipc	a3,0x2
ffffffffc02031ac:	33868693          	addi	a3,a3,824 # ffffffffc02054e0 <default_pmm_manager+0x818>
ffffffffc02031b0:	00001617          	auipc	a2,0x1
ffffffffc02031b4:	76860613          	addi	a2,a2,1896 # ffffffffc0204918 <commands+0x818>
ffffffffc02031b8:	0fa00593          	li	a1,250
ffffffffc02031bc:	00002517          	auipc	a0,0x2
ffffffffc02031c0:	22450513          	addi	a0,a0,548 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc02031c4:	a96fd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma4 == NULL);
ffffffffc02031c8:	00002697          	auipc	a3,0x2
ffffffffc02031cc:	30868693          	addi	a3,a3,776 # ffffffffc02054d0 <default_pmm_manager+0x808>
ffffffffc02031d0:	00001617          	auipc	a2,0x1
ffffffffc02031d4:	74860613          	addi	a2,a2,1864 # ffffffffc0204918 <commands+0x818>
ffffffffc02031d8:	0f800593          	li	a1,248
ffffffffc02031dc:	00002517          	auipc	a0,0x2
ffffffffc02031e0:	20450513          	addi	a0,a0,516 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc02031e4:	a76fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(mm != NULL);
ffffffffc02031e8:	00002697          	auipc	a3,0x2
ffffffffc02031ec:	3f068693          	addi	a3,a3,1008 # ffffffffc02055d8 <default_pmm_manager+0x910>
ffffffffc02031f0:	00001617          	auipc	a2,0x1
ffffffffc02031f4:	72860613          	addi	a2,a2,1832 # ffffffffc0204918 <commands+0x818>
ffffffffc02031f8:	0d200593          	li	a1,210
ffffffffc02031fc:	00002517          	auipc	a0,0x2
ffffffffc0203200:	1e450513          	addi	a0,a0,484 # ffffffffc02053e0 <default_pmm_manager+0x718>
ffffffffc0203204:	a56fd0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0203208 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203208:	8526                	mv	a0,s1
	jalr s0
ffffffffc020320a:	9402                	jalr	s0

	jal do_exit
ffffffffc020320c:	3de000ef          	jal	ra,ffffffffc02035ea <do_exit>

ffffffffc0203210 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203210:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203212:	0e800513          	li	a0,232
{
ffffffffc0203216:	e022                	sd	s0,0(sp)
ffffffffc0203218:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020321a:	8a1fe0ef          	jal	ra,ffffffffc0201aba <kmalloc>
ffffffffc020321e:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203220:	c521                	beqz	a0,ffffffffc0203268 <alloc_proc+0x58>
         *       struct trapframe *tf;                       // Trap frame for current interrupt
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
        proc->state = PROC_UNINIT;
ffffffffc0203222:	57fd                	li	a5,-1
ffffffffc0203224:	1782                	slli	a5,a5,0x20
ffffffffc0203226:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203228:	07000613          	li	a2,112
ffffffffc020322c:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc020322e:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0203232:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203236:	00052c23          	sw	zero,24(a0)
        proc->parent = NULL;
ffffffffc020323a:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc020323e:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203242:	03050513          	addi	a0,a0,48
ffffffffc0203246:	401000ef          	jal	ra,ffffffffc0203e46 <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc020324a:	0000a797          	auipc	a5,0xa
ffffffffc020324e:	2567b783          	ld	a5,598(a5) # ffffffffc020d4a0 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc0203252:	0a043023          	sd	zero,160(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203256:	f45c                	sd	a5,168(s0)
        proc->flags = 0;
ffffffffc0203258:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN);
ffffffffc020325c:	463d                	li	a2,15
ffffffffc020325e:	4581                	li	a1,0
ffffffffc0203260:	0b440513          	addi	a0,s0,180
ffffffffc0203264:	3e3000ef          	jal	ra,ffffffffc0203e46 <memset>
    }
    return proc;
}
ffffffffc0203268:	60a2                	ld	ra,8(sp)
ffffffffc020326a:	8522                	mv	a0,s0
ffffffffc020326c:	6402                	ld	s0,0(sp)
ffffffffc020326e:	0141                	addi	sp,sp,16
ffffffffc0203270:	8082                	ret

ffffffffc0203272 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203272:	0000a797          	auipc	a5,0xa
ffffffffc0203276:	25e7b783          	ld	a5,606(a5) # ffffffffc020d4d0 <current>
ffffffffc020327a:	73c8                	ld	a0,160(a5)
ffffffffc020327c:	b5dfd06f          	j	ffffffffc0200dd8 <forkrets>

ffffffffc0203280 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0203280:	7179                	addi	sp,sp,-48
ffffffffc0203282:	ec26                	sd	s1,24(sp)
    memset(name, 0, sizeof(name));
ffffffffc0203284:	0000a497          	auipc	s1,0xa
ffffffffc0203288:	1c448493          	addi	s1,s1,452 # ffffffffc020d448 <name.2>
{
ffffffffc020328c:	f022                	sd	s0,32(sp)
ffffffffc020328e:	e84a                	sd	s2,16(sp)
ffffffffc0203290:	842a                	mv	s0,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0203292:	0000a917          	auipc	s2,0xa
ffffffffc0203296:	23e93903          	ld	s2,574(s2) # ffffffffc020d4d0 <current>
    memset(name, 0, sizeof(name));
ffffffffc020329a:	4641                	li	a2,16
ffffffffc020329c:	4581                	li	a1,0
ffffffffc020329e:	8526                	mv	a0,s1
{
ffffffffc02032a0:	f406                	sd	ra,40(sp)
ffffffffc02032a2:	e44e                	sd	s3,8(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc02032a4:	00492983          	lw	s3,4(s2)
    memset(name, 0, sizeof(name));
ffffffffc02032a8:	39f000ef          	jal	ra,ffffffffc0203e46 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc02032ac:	0b490593          	addi	a1,s2,180
ffffffffc02032b0:	463d                	li	a2,15
ffffffffc02032b2:	8526                	mv	a0,s1
ffffffffc02032b4:	3a5000ef          	jal	ra,ffffffffc0203e58 <memcpy>
ffffffffc02032b8:	862a                	mv	a2,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc02032ba:	85ce                	mv	a1,s3
ffffffffc02032bc:	00002517          	auipc	a0,0x2
ffffffffc02032c0:	32c50513          	addi	a0,a0,812 # ffffffffc02055e8 <default_pmm_manager+0x920>
ffffffffc02032c4:	ed1fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
ffffffffc02032c8:	85a2                	mv	a1,s0
ffffffffc02032ca:	00002517          	auipc	a0,0x2
ffffffffc02032ce:	34650513          	addi	a0,a0,838 # ffffffffc0205610 <default_pmm_manager+0x948>
ffffffffc02032d2:	ec3fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
ffffffffc02032d6:	00002517          	auipc	a0,0x2
ffffffffc02032da:	34a50513          	addi	a0,a0,842 # ffffffffc0205620 <default_pmm_manager+0x958>
ffffffffc02032de:	eb7fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc02032e2:	70a2                	ld	ra,40(sp)
ffffffffc02032e4:	7402                	ld	s0,32(sp)
ffffffffc02032e6:	64e2                	ld	s1,24(sp)
ffffffffc02032e8:	6942                	ld	s2,16(sp)
ffffffffc02032ea:	69a2                	ld	s3,8(sp)
ffffffffc02032ec:	4501                	li	a0,0
ffffffffc02032ee:	6145                	addi	sp,sp,48
ffffffffc02032f0:	8082                	ret

ffffffffc02032f2 <proc_run>:
{
ffffffffc02032f2:	7179                	addi	sp,sp,-48
ffffffffc02032f4:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc02032f6:	0000a917          	auipc	s2,0xa
ffffffffc02032fa:	1da90913          	addi	s2,s2,474 # ffffffffc020d4d0 <current>
{
ffffffffc02032fe:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203300:	00093483          	ld	s1,0(s2)
{
ffffffffc0203304:	f406                	sd	ra,40(sp)
ffffffffc0203306:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0203308:	02a48963          	beq	s1,a0,ffffffffc020333a <proc_run+0x48>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020330c:	100027f3          	csrr	a5,sstatus
ffffffffc0203310:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203312:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203314:	e3a1                	bnez	a5,ffffffffc0203354 <proc_run+0x62>
            lsatp(next->pgdir);
ffffffffc0203316:	755c                	ld	a5,168(a0)
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned int pgdir)
{
  write_csr(satp, SATP32_MODE | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203318:	80000737          	lui	a4,0x80000
            current = proc;
ffffffffc020331c:	00a93023          	sd	a0,0(s2)
ffffffffc0203320:	00c7d79b          	srliw	a5,a5,0xc
ffffffffc0203324:	8fd9                	or	a5,a5,a4
ffffffffc0203326:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(next->context));
ffffffffc020332a:	03050593          	addi	a1,a0,48
ffffffffc020332e:	03048513          	addi	a0,s1,48
ffffffffc0203332:	53e000ef          	jal	ra,ffffffffc0203870 <switch_to>
    if (flag) {
ffffffffc0203336:	00099863          	bnez	s3,ffffffffc0203346 <proc_run+0x54>
}
ffffffffc020333a:	70a2                	ld	ra,40(sp)
ffffffffc020333c:	7482                	ld	s1,32(sp)
ffffffffc020333e:	6962                	ld	s2,24(sp)
ffffffffc0203340:	69c2                	ld	s3,16(sp)
ffffffffc0203342:	6145                	addi	sp,sp,48
ffffffffc0203344:	8082                	ret
ffffffffc0203346:	70a2                	ld	ra,40(sp)
ffffffffc0203348:	7482                	ld	s1,32(sp)
ffffffffc020334a:	6962                	ld	s2,24(sp)
ffffffffc020334c:	69c2                	ld	s3,16(sp)
ffffffffc020334e:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0203350:	ddafd06f          	j	ffffffffc020092a <intr_enable>
ffffffffc0203354:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203356:	ddafd0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        return 1;
ffffffffc020335a:	6522                	ld	a0,8(sp)
ffffffffc020335c:	4985                	li	s3,1
ffffffffc020335e:	bf65                	j	ffffffffc0203316 <proc_run+0x24>

ffffffffc0203360 <do_fork>:
{
ffffffffc0203360:	7179                	addi	sp,sp,-48
ffffffffc0203362:	ec26                	sd	s1,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203364:	0000a497          	auipc	s1,0xa
ffffffffc0203368:	18448493          	addi	s1,s1,388 # ffffffffc020d4e8 <nr_process>
ffffffffc020336c:	4098                	lw	a4,0(s1)
{
ffffffffc020336e:	f406                	sd	ra,40(sp)
ffffffffc0203370:	f022                	sd	s0,32(sp)
ffffffffc0203372:	e84a                	sd	s2,16(sp)
ffffffffc0203374:	e44e                	sd	s3,8(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203376:	6785                	lui	a5,0x1
ffffffffc0203378:	1cf75e63          	bge	a4,a5,ffffffffc0203554 <do_fork+0x1f4>
ffffffffc020337c:	892e                	mv	s2,a1
ffffffffc020337e:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0203380:	e91ff0ef          	jal	ra,ffffffffc0203210 <alloc_proc>
ffffffffc0203384:	89aa                	mv	s3,a0
ffffffffc0203386:	1c050c63          	beqz	a0,ffffffffc020355e <do_fork+0x1fe>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020338a:	4509                	li	a0,2
ffffffffc020338c:	90dfe0ef          	jal	ra,ffffffffc0201c98 <alloc_pages>
    if (page != NULL)
ffffffffc0203390:	1a050d63          	beqz	a0,ffffffffc020354a <do_fork+0x1ea>
    return page - pages + nbase;
ffffffffc0203394:	0000a697          	auipc	a3,0xa
ffffffffc0203398:	1246b683          	ld	a3,292(a3) # ffffffffc020d4b8 <pages>
ffffffffc020339c:	40d506b3          	sub	a3,a0,a3
ffffffffc02033a0:	8699                	srai	a3,a3,0x6
ffffffffc02033a2:	00002517          	auipc	a0,0x2
ffffffffc02033a6:	63e53503          	ld	a0,1598(a0) # ffffffffc02059e0 <nbase>
ffffffffc02033aa:	96aa                	add	a3,a3,a0
    return KADDR(page2pa(page));
ffffffffc02033ac:	00c69793          	slli	a5,a3,0xc
ffffffffc02033b0:	83b1                	srli	a5,a5,0xc
ffffffffc02033b2:	0000a717          	auipc	a4,0xa
ffffffffc02033b6:	0fe73703          	ld	a4,254(a4) # ffffffffc020d4b0 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc02033ba:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02033bc:	1ce7f363          	bgeu	a5,a4,ffffffffc0203582 <do_fork+0x222>
    assert(current->mm == NULL);
ffffffffc02033c0:	0000a317          	auipc	t1,0xa
ffffffffc02033c4:	11033303          	ld	t1,272(t1) # ffffffffc020d4d0 <current>
ffffffffc02033c8:	02833783          	ld	a5,40(t1)
ffffffffc02033cc:	0000a717          	auipc	a4,0xa
ffffffffc02033d0:	0fc73703          	ld	a4,252(a4) # ffffffffc020d4c8 <va_pa_offset>
ffffffffc02033d4:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc02033d6:	00d9b823          	sd	a3,16(s3)
    assert(current->mm == NULL);
ffffffffc02033da:	18079463          	bnez	a5,ffffffffc0203562 <do_fork+0x202>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02033de:	6789                	lui	a5,0x2
ffffffffc02033e0:	ee078793          	addi	a5,a5,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc02033e4:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02033e6:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02033e8:	0ad9b023          	sd	a3,160(s3)
    *(proc->tf) = *tf;
ffffffffc02033ec:	87b6                	mv	a5,a3
ffffffffc02033ee:	12040893          	addi	a7,s0,288
ffffffffc02033f2:	00063803          	ld	a6,0(a2)
ffffffffc02033f6:	6608                	ld	a0,8(a2)
ffffffffc02033f8:	6a0c                	ld	a1,16(a2)
ffffffffc02033fa:	6e18                	ld	a4,24(a2)
ffffffffc02033fc:	0107b023          	sd	a6,0(a5)
ffffffffc0203400:	e788                	sd	a0,8(a5)
ffffffffc0203402:	eb8c                	sd	a1,16(a5)
ffffffffc0203404:	ef98                	sd	a4,24(a5)
ffffffffc0203406:	02060613          	addi	a2,a2,32
ffffffffc020340a:	02078793          	addi	a5,a5,32
ffffffffc020340e:	ff1612e3          	bne	a2,a7,ffffffffc02033f2 <do_fork+0x92>
    proc->tf->gpr.a0 = 0;
ffffffffc0203412:	0406b823          	sd	zero,80(a3)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203416:	10090e63          	beqz	s2,ffffffffc0203532 <do_fork+0x1d2>
    if (++last_pid >= MAX_PID)
ffffffffc020341a:	00006817          	auipc	a6,0x6
ffffffffc020341e:	c0e80813          	addi	a6,a6,-1010 # ffffffffc0209028 <last_pid.1>
ffffffffc0203422:	00082783          	lw	a5,0(a6)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203426:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020342a:	00000717          	auipc	a4,0x0
ffffffffc020342e:	e4870713          	addi	a4,a4,-440 # ffffffffc0203272 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc0203432:	0017851b          	addiw	a0,a5,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0203436:	02e9b823          	sd	a4,48(s3)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020343a:	02d9bc23          	sd	a3,56(s3)
    if (++last_pid >= MAX_PID)
ffffffffc020343e:	00a82023          	sw	a0,0(a6)
ffffffffc0203442:	6789                	lui	a5,0x2
ffffffffc0203444:	08f55063          	bge	a0,a5,ffffffffc02034c4 <do_fork+0x164>
    if (last_pid >= next_safe)
ffffffffc0203448:	00006e17          	auipc	t3,0x6
ffffffffc020344c:	be4e0e13          	addi	t3,t3,-1052 # ffffffffc020902c <next_safe.0>
ffffffffc0203450:	000e2783          	lw	a5,0(t3)
ffffffffc0203454:	0000a417          	auipc	s0,0xa
ffffffffc0203458:	00440413          	addi	s0,s0,4 # ffffffffc020d458 <proc_list>
ffffffffc020345c:	06f55c63          	bge	a0,a5,ffffffffc02034d4 <do_fork+0x174>
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0203460:	45a9                	li	a1,10
    proc->pid = get_pid();
ffffffffc0203462:	00a9a223          	sw	a0,4(s3)
    proc->parent = current;
ffffffffc0203466:	0269b023          	sd	t1,32(s3)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020346a:	2501                	sext.w	a0,a0
ffffffffc020346c:	534000ef          	jal	ra,ffffffffc02039a0 <hash32>
ffffffffc0203470:	02051793          	slli	a5,a0,0x20
ffffffffc0203474:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0203478:	00006797          	auipc	a5,0x6
ffffffffc020347c:	fd078793          	addi	a5,a5,-48 # ffffffffc0209448 <hash_list>
ffffffffc0203480:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0203482:	651c                	ld	a5,8(a0)
ffffffffc0203484:	0d898693          	addi	a3,s3,216
ffffffffc0203488:	6418                	ld	a4,8(s0)
    prev->next = next->prev = elm;
ffffffffc020348a:	e394                	sd	a3,0(a5)
ffffffffc020348c:	e514                	sd	a3,8(a0)
    elm->next = next;
ffffffffc020348e:	0ef9b023          	sd	a5,224(s3)
    elm->prev = prev;
ffffffffc0203492:	0ca9bc23          	sd	a0,216(s3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0203496:	0c898793          	addi	a5,s3,200
    prev->next = next->prev = elm;
ffffffffc020349a:	e31c                	sd	a5,0(a4)
    wakeup_proc(proc);
ffffffffc020349c:	854e                	mv	a0,s3
    elm->next = next;
ffffffffc020349e:	0ce9b823          	sd	a4,208(s3)
    elm->prev = prev;
ffffffffc02034a2:	0c89b423          	sd	s0,200(s3)
    prev->next = next->prev = elm;
ffffffffc02034a6:	e41c                	sd	a5,8(s0)
ffffffffc02034a8:	432000ef          	jal	ra,ffffffffc02038da <wakeup_proc>
    nr_process++;
ffffffffc02034ac:	409c                	lw	a5,0(s1)
    ret = proc->pid;
ffffffffc02034ae:	0049a503          	lw	a0,4(s3)
    nr_process++;
ffffffffc02034b2:	2785                	addiw	a5,a5,1
ffffffffc02034b4:	c09c                	sw	a5,0(s1)
}
ffffffffc02034b6:	70a2                	ld	ra,40(sp)
ffffffffc02034b8:	7402                	ld	s0,32(sp)
ffffffffc02034ba:	64e2                	ld	s1,24(sp)
ffffffffc02034bc:	6942                	ld	s2,16(sp)
ffffffffc02034be:	69a2                	ld	s3,8(sp)
ffffffffc02034c0:	6145                	addi	sp,sp,48
ffffffffc02034c2:	8082                	ret
        last_pid = 1;
ffffffffc02034c4:	4785                	li	a5,1
ffffffffc02034c6:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02034ca:	4505                	li	a0,1
ffffffffc02034cc:	00006e17          	auipc	t3,0x6
ffffffffc02034d0:	b60e0e13          	addi	t3,t3,-1184 # ffffffffc020902c <next_safe.0>
    return listelm->next;
ffffffffc02034d4:	0000a417          	auipc	s0,0xa
ffffffffc02034d8:	f8440413          	addi	s0,s0,-124 # ffffffffc020d458 <proc_list>
ffffffffc02034dc:	00843e83          	ld	t4,8(s0)
        next_safe = MAX_PID;
ffffffffc02034e0:	6789                	lui	a5,0x2
ffffffffc02034e2:	00fe2023          	sw	a5,0(t3)
ffffffffc02034e6:	86aa                	mv	a3,a0
ffffffffc02034e8:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02034ea:	6f09                	lui	t5,0x2
ffffffffc02034ec:	048e8a63          	beq	t4,s0,ffffffffc0203540 <do_fork+0x1e0>
ffffffffc02034f0:	88ae                	mv	a7,a1
ffffffffc02034f2:	87f6                	mv	a5,t4
ffffffffc02034f4:	6609                	lui	a2,0x2
ffffffffc02034f6:	a811                	j	ffffffffc020350a <do_fork+0x1aa>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02034f8:	00e6d663          	bge	a3,a4,ffffffffc0203504 <do_fork+0x1a4>
ffffffffc02034fc:	00c75463          	bge	a4,a2,ffffffffc0203504 <do_fork+0x1a4>
ffffffffc0203500:	863a                	mv	a2,a4
ffffffffc0203502:	4885                	li	a7,1
ffffffffc0203504:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0203506:	00878d63          	beq	a5,s0,ffffffffc0203520 <do_fork+0x1c0>
            if (proc->pid == last_pid)
ffffffffc020350a:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc020350e:	fed715e3          	bne	a4,a3,ffffffffc02034f8 <do_fork+0x198>
                if (++last_pid >= next_safe)
ffffffffc0203512:	2685                	addiw	a3,a3,1
ffffffffc0203514:	02c6d163          	bge	a3,a2,ffffffffc0203536 <do_fork+0x1d6>
ffffffffc0203518:	679c                	ld	a5,8(a5)
ffffffffc020351a:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc020351c:	fe8797e3          	bne	a5,s0,ffffffffc020350a <do_fork+0x1aa>
ffffffffc0203520:	c581                	beqz	a1,ffffffffc0203528 <do_fork+0x1c8>
ffffffffc0203522:	00d82023          	sw	a3,0(a6)
ffffffffc0203526:	8536                	mv	a0,a3
ffffffffc0203528:	f2088ce3          	beqz	a7,ffffffffc0203460 <do_fork+0x100>
ffffffffc020352c:	00ce2023          	sw	a2,0(t3)
ffffffffc0203530:	bf05                	j	ffffffffc0203460 <do_fork+0x100>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203532:	8936                	mv	s2,a3
ffffffffc0203534:	b5dd                	j	ffffffffc020341a <do_fork+0xba>
                    if (last_pid >= MAX_PID)
ffffffffc0203536:	01e6c363          	blt	a3,t5,ffffffffc020353c <do_fork+0x1dc>
                        last_pid = 1;
ffffffffc020353a:	4685                	li	a3,1
                    goto repeat;
ffffffffc020353c:	4585                	li	a1,1
ffffffffc020353e:	b77d                	j	ffffffffc02034ec <do_fork+0x18c>
ffffffffc0203540:	cd81                	beqz	a1,ffffffffc0203558 <do_fork+0x1f8>
ffffffffc0203542:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc0203546:	8536                	mv	a0,a3
ffffffffc0203548:	bf21                	j	ffffffffc0203460 <do_fork+0x100>
    kfree(proc);
ffffffffc020354a:	854e                	mv	a0,s3
ffffffffc020354c:	e1efe0ef          	jal	ra,ffffffffc0201b6a <kfree>
    ret = -E_NO_MEM;
ffffffffc0203550:	5571                	li	a0,-4
    goto fork_out;
ffffffffc0203552:	b795                	j	ffffffffc02034b6 <do_fork+0x156>
    int ret = -E_NO_FREE_PROC;
ffffffffc0203554:	556d                	li	a0,-5
ffffffffc0203556:	b785                	j	ffffffffc02034b6 <do_fork+0x156>
    return last_pid;
ffffffffc0203558:	00082503          	lw	a0,0(a6)
ffffffffc020355c:	b711                	j	ffffffffc0203460 <do_fork+0x100>
    ret = -E_NO_MEM;
ffffffffc020355e:	5571                	li	a0,-4
    return ret;
ffffffffc0203560:	bf99                	j	ffffffffc02034b6 <do_fork+0x156>
    assert(current->mm == NULL);
ffffffffc0203562:	00002697          	auipc	a3,0x2
ffffffffc0203566:	0de68693          	addi	a3,a3,222 # ffffffffc0205640 <default_pmm_manager+0x978>
ffffffffc020356a:	00001617          	auipc	a2,0x1
ffffffffc020356e:	3ae60613          	addi	a2,a2,942 # ffffffffc0204918 <commands+0x818>
ffffffffc0203572:	11d00593          	li	a1,285
ffffffffc0203576:	00002517          	auipc	a0,0x2
ffffffffc020357a:	0e250513          	addi	a0,a0,226 # ffffffffc0205658 <default_pmm_manager+0x990>
ffffffffc020357e:	eddfc0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0203582:	00001617          	auipc	a2,0x1
ffffffffc0203586:	77e60613          	addi	a2,a2,1918 # ffffffffc0204d00 <default_pmm_manager+0x38>
ffffffffc020358a:	07100593          	li	a1,113
ffffffffc020358e:	00001517          	auipc	a0,0x1
ffffffffc0203592:	79a50513          	addi	a0,a0,1946 # ffffffffc0204d28 <default_pmm_manager+0x60>
ffffffffc0203596:	ec5fc0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc020359a <kernel_thread>:
{
ffffffffc020359a:	7129                	addi	sp,sp,-320
ffffffffc020359c:	fa22                	sd	s0,304(sp)
ffffffffc020359e:	f626                	sd	s1,296(sp)
ffffffffc02035a0:	f24a                	sd	s2,288(sp)
ffffffffc02035a2:	84ae                	mv	s1,a1
ffffffffc02035a4:	892a                	mv	s2,a0
ffffffffc02035a6:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02035a8:	4581                	li	a1,0
ffffffffc02035aa:	12000613          	li	a2,288
ffffffffc02035ae:	850a                	mv	a0,sp
{
ffffffffc02035b0:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02035b2:	095000ef          	jal	ra,ffffffffc0203e46 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02035b6:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02035b8:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02035ba:	100027f3          	csrr	a5,sstatus
ffffffffc02035be:	edd7f793          	andi	a5,a5,-291
ffffffffc02035c2:	1207e793          	ori	a5,a5,288
ffffffffc02035c6:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02035c8:	860a                	mv	a2,sp
ffffffffc02035ca:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02035ce:	00000797          	auipc	a5,0x0
ffffffffc02035d2:	c3a78793          	addi	a5,a5,-966 # ffffffffc0203208 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02035d6:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02035d8:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02035da:	d87ff0ef          	jal	ra,ffffffffc0203360 <do_fork>
}
ffffffffc02035de:	70f2                	ld	ra,312(sp)
ffffffffc02035e0:	7452                	ld	s0,304(sp)
ffffffffc02035e2:	74b2                	ld	s1,296(sp)
ffffffffc02035e4:	7912                	ld	s2,288(sp)
ffffffffc02035e6:	6131                	addi	sp,sp,320
ffffffffc02035e8:	8082                	ret

ffffffffc02035ea <do_exit>:
{
ffffffffc02035ea:	1141                	addi	sp,sp,-16
    panic("process exit!!.\n");
ffffffffc02035ec:	00002617          	auipc	a2,0x2
ffffffffc02035f0:	08460613          	addi	a2,a2,132 # ffffffffc0205670 <default_pmm_manager+0x9a8>
ffffffffc02035f4:	18c00593          	li	a1,396
ffffffffc02035f8:	00002517          	auipc	a0,0x2
ffffffffc02035fc:	06050513          	addi	a0,a0,96 # ffffffffc0205658 <default_pmm_manager+0x990>
{
ffffffffc0203600:	e406                	sd	ra,8(sp)
    panic("process exit!!.\n");
ffffffffc0203602:	e59fc0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0203606 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0203606:	7179                	addi	sp,sp,-48
ffffffffc0203608:	ec26                	sd	s1,24(sp)
    elm->prev = elm->next = elm;
ffffffffc020360a:	0000a797          	auipc	a5,0xa
ffffffffc020360e:	e4e78793          	addi	a5,a5,-434 # ffffffffc020d458 <proc_list>
ffffffffc0203612:	f406                	sd	ra,40(sp)
ffffffffc0203614:	f022                	sd	s0,32(sp)
ffffffffc0203616:	e84a                	sd	s2,16(sp)
ffffffffc0203618:	e44e                	sd	s3,8(sp)
ffffffffc020361a:	00006497          	auipc	s1,0x6
ffffffffc020361e:	e2e48493          	addi	s1,s1,-466 # ffffffffc0209448 <hash_list>
ffffffffc0203622:	e79c                	sd	a5,8(a5)
ffffffffc0203624:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0203626:	0000a717          	auipc	a4,0xa
ffffffffc020362a:	e2270713          	addi	a4,a4,-478 # ffffffffc020d448 <name.2>
ffffffffc020362e:	87a6                	mv	a5,s1
ffffffffc0203630:	e79c                	sd	a5,8(a5)
ffffffffc0203632:	e39c                	sd	a5,0(a5)
ffffffffc0203634:	07c1                	addi	a5,a5,16
ffffffffc0203636:	fef71de3          	bne	a4,a5,ffffffffc0203630 <proc_init+0x2a>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc020363a:	bd7ff0ef          	jal	ra,ffffffffc0203210 <alloc_proc>
ffffffffc020363e:	0000a917          	auipc	s2,0xa
ffffffffc0203642:	e9a90913          	addi	s2,s2,-358 # ffffffffc020d4d8 <idleproc>
ffffffffc0203646:	00a93023          	sd	a0,0(s2)
ffffffffc020364a:	18050d63          	beqz	a0,ffffffffc02037e4 <proc_init+0x1de>
    {
        panic("cannot alloc idleproc.\n");
    }

    // check the proc structure
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc020364e:	07000513          	li	a0,112
ffffffffc0203652:	c68fe0ef          	jal	ra,ffffffffc0201aba <kmalloc>
    memset(context_mem, 0, sizeof(struct context));
ffffffffc0203656:	07000613          	li	a2,112
ffffffffc020365a:	4581                	li	a1,0
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc020365c:	842a                	mv	s0,a0
    memset(context_mem, 0, sizeof(struct context));
ffffffffc020365e:	7e8000ef          	jal	ra,ffffffffc0203e46 <memset>
    int context_init_flag = memcmp(&(idleproc->context), context_mem, sizeof(struct context));
ffffffffc0203662:	00093503          	ld	a0,0(s2)
ffffffffc0203666:	85a2                	mv	a1,s0
ffffffffc0203668:	07000613          	li	a2,112
ffffffffc020366c:	03050513          	addi	a0,a0,48
ffffffffc0203670:	001000ef          	jal	ra,ffffffffc0203e70 <memcmp>
ffffffffc0203674:	89aa                	mv	s3,a0

    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc0203676:	453d                	li	a0,15
ffffffffc0203678:	c42fe0ef          	jal	ra,ffffffffc0201aba <kmalloc>
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc020367c:	463d                	li	a2,15
ffffffffc020367e:	4581                	li	a1,0
    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc0203680:	842a                	mv	s0,a0
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc0203682:	7c4000ef          	jal	ra,ffffffffc0203e46 <memset>
    int proc_name_flag = memcmp(&(idleproc->name), proc_name_mem, PROC_NAME_LEN);
ffffffffc0203686:	00093503          	ld	a0,0(s2)
ffffffffc020368a:	463d                	li	a2,15
ffffffffc020368c:	85a2                	mv	a1,s0
ffffffffc020368e:	0b450513          	addi	a0,a0,180
ffffffffc0203692:	7de000ef          	jal	ra,ffffffffc0203e70 <memcmp>

    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc0203696:	00093783          	ld	a5,0(s2)
ffffffffc020369a:	0000a717          	auipc	a4,0xa
ffffffffc020369e:	e0673703          	ld	a4,-506(a4) # ffffffffc020d4a0 <boot_pgdir_pa>
ffffffffc02036a2:	77d4                	ld	a3,168(a5)
ffffffffc02036a4:	0ee68463          	beq	a3,a4,ffffffffc020378c <proc_init+0x186>
    {
        cprintf("alloc_proc() correct!\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc02036a8:	4709                	li	a4,2
ffffffffc02036aa:	e398                	sd	a4,0(a5)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02036ac:	00003717          	auipc	a4,0x3
ffffffffc02036b0:	95470713          	addi	a4,a4,-1708 # ffffffffc0206000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02036b4:	0b478413          	addi	s0,a5,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02036b8:	eb98                	sd	a4,16(a5)
    idleproc->need_resched = 1;
ffffffffc02036ba:	4705                	li	a4,1
ffffffffc02036bc:	cf98                	sw	a4,24(a5)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02036be:	4641                	li	a2,16
ffffffffc02036c0:	4581                	li	a1,0
ffffffffc02036c2:	8522                	mv	a0,s0
ffffffffc02036c4:	782000ef          	jal	ra,ffffffffc0203e46 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02036c8:	463d                	li	a2,15
ffffffffc02036ca:	00002597          	auipc	a1,0x2
ffffffffc02036ce:	fee58593          	addi	a1,a1,-18 # ffffffffc02056b8 <default_pmm_manager+0x9f0>
ffffffffc02036d2:	8522                	mv	a0,s0
ffffffffc02036d4:	784000ef          	jal	ra,ffffffffc0203e58 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc02036d8:	0000a717          	auipc	a4,0xa
ffffffffc02036dc:	e1070713          	addi	a4,a4,-496 # ffffffffc020d4e8 <nr_process>
ffffffffc02036e0:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc02036e2:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02036e6:	4601                	li	a2,0
    nr_process++;
ffffffffc02036e8:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02036ea:	00002597          	auipc	a1,0x2
ffffffffc02036ee:	fd658593          	addi	a1,a1,-42 # ffffffffc02056c0 <default_pmm_manager+0x9f8>
ffffffffc02036f2:	00000517          	auipc	a0,0x0
ffffffffc02036f6:	b8e50513          	addi	a0,a0,-1138 # ffffffffc0203280 <init_main>
    nr_process++;
ffffffffc02036fa:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc02036fc:	0000a797          	auipc	a5,0xa
ffffffffc0203700:	dcd7ba23          	sd	a3,-556(a5) # ffffffffc020d4d0 <current>
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc0203704:	e97ff0ef          	jal	ra,ffffffffc020359a <kernel_thread>
ffffffffc0203708:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc020370a:	0ea05963          	blez	a0,ffffffffc02037fc <proc_init+0x1f6>
    if (0 < pid && pid < MAX_PID)
ffffffffc020370e:	6789                	lui	a5,0x2
ffffffffc0203710:	fff5071b          	addiw	a4,a0,-1
ffffffffc0203714:	17f9                	addi	a5,a5,-2
ffffffffc0203716:	2501                	sext.w	a0,a0
ffffffffc0203718:	02e7e363          	bltu	a5,a4,ffffffffc020373e <proc_init+0x138>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020371c:	45a9                	li	a1,10
ffffffffc020371e:	282000ef          	jal	ra,ffffffffc02039a0 <hash32>
ffffffffc0203722:	02051793          	slli	a5,a0,0x20
ffffffffc0203726:	01c7d693          	srli	a3,a5,0x1c
ffffffffc020372a:	96a6                	add	a3,a3,s1
ffffffffc020372c:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc020372e:	a029                	j	ffffffffc0203738 <proc_init+0x132>
            if (proc->pid == pid)
ffffffffc0203730:	f2c7a703          	lw	a4,-212(a5) # 1f2c <kern_entry-0xffffffffc01fe0d4>
ffffffffc0203734:	0a870563          	beq	a4,s0,ffffffffc02037de <proc_init+0x1d8>
    return listelm->next;
ffffffffc0203738:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020373a:	fef69be3          	bne	a3,a5,ffffffffc0203730 <proc_init+0x12a>
    return NULL;
ffffffffc020373e:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203740:	0b478493          	addi	s1,a5,180
ffffffffc0203744:	4641                	li	a2,16
ffffffffc0203746:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0203748:	0000a417          	auipc	s0,0xa
ffffffffc020374c:	d9840413          	addi	s0,s0,-616 # ffffffffc020d4e0 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203750:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0203752:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203754:	6f2000ef          	jal	ra,ffffffffc0203e46 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0203758:	463d                	li	a2,15
ffffffffc020375a:	00002597          	auipc	a1,0x2
ffffffffc020375e:	f9658593          	addi	a1,a1,-106 # ffffffffc02056f0 <default_pmm_manager+0xa28>
ffffffffc0203762:	8526                	mv	a0,s1
ffffffffc0203764:	6f4000ef          	jal	ra,ffffffffc0203e58 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0203768:	00093783          	ld	a5,0(s2)
ffffffffc020376c:	c7e1                	beqz	a5,ffffffffc0203834 <proc_init+0x22e>
ffffffffc020376e:	43dc                	lw	a5,4(a5)
ffffffffc0203770:	e3f1                	bnez	a5,ffffffffc0203834 <proc_init+0x22e>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0203772:	601c                	ld	a5,0(s0)
ffffffffc0203774:	c3c5                	beqz	a5,ffffffffc0203814 <proc_init+0x20e>
ffffffffc0203776:	43d8                	lw	a4,4(a5)
ffffffffc0203778:	4785                	li	a5,1
ffffffffc020377a:	08f71d63          	bne	a4,a5,ffffffffc0203814 <proc_init+0x20e>
}
ffffffffc020377e:	70a2                	ld	ra,40(sp)
ffffffffc0203780:	7402                	ld	s0,32(sp)
ffffffffc0203782:	64e2                	ld	s1,24(sp)
ffffffffc0203784:	6942                	ld	s2,16(sp)
ffffffffc0203786:	69a2                	ld	s3,8(sp)
ffffffffc0203788:	6145                	addi	sp,sp,48
ffffffffc020378a:	8082                	ret
    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc020378c:	73d8                	ld	a4,160(a5)
ffffffffc020378e:	ff09                	bnez	a4,ffffffffc02036a8 <proc_init+0xa2>
ffffffffc0203790:	f0099ce3          	bnez	s3,ffffffffc02036a8 <proc_init+0xa2>
ffffffffc0203794:	6394                	ld	a3,0(a5)
ffffffffc0203796:	577d                	li	a4,-1
ffffffffc0203798:	1702                	slli	a4,a4,0x20
ffffffffc020379a:	f0e697e3          	bne	a3,a4,ffffffffc02036a8 <proc_init+0xa2>
ffffffffc020379e:	4798                	lw	a4,8(a5)
ffffffffc02037a0:	f00714e3          	bnez	a4,ffffffffc02036a8 <proc_init+0xa2>
ffffffffc02037a4:	6b98                	ld	a4,16(a5)
ffffffffc02037a6:	f00711e3          	bnez	a4,ffffffffc02036a8 <proc_init+0xa2>
ffffffffc02037aa:	4f98                	lw	a4,24(a5)
ffffffffc02037ac:	2701                	sext.w	a4,a4
ffffffffc02037ae:	ee071de3          	bnez	a4,ffffffffc02036a8 <proc_init+0xa2>
ffffffffc02037b2:	7398                	ld	a4,32(a5)
ffffffffc02037b4:	ee071ae3          	bnez	a4,ffffffffc02036a8 <proc_init+0xa2>
ffffffffc02037b8:	7798                	ld	a4,40(a5)
ffffffffc02037ba:	ee0717e3          	bnez	a4,ffffffffc02036a8 <proc_init+0xa2>
ffffffffc02037be:	0b07a703          	lw	a4,176(a5)
ffffffffc02037c2:	8d59                	or	a0,a0,a4
ffffffffc02037c4:	0005071b          	sext.w	a4,a0
ffffffffc02037c8:	ee0710e3          	bnez	a4,ffffffffc02036a8 <proc_init+0xa2>
        cprintf("alloc_proc() correct!\n");
ffffffffc02037cc:	00002517          	auipc	a0,0x2
ffffffffc02037d0:	ed450513          	addi	a0,a0,-300 # ffffffffc02056a0 <default_pmm_manager+0x9d8>
ffffffffc02037d4:	9c1fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    idleproc->pid = 0;
ffffffffc02037d8:	00093783          	ld	a5,0(s2)
ffffffffc02037dc:	b5f1                	j	ffffffffc02036a8 <proc_init+0xa2>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02037de:	f2878793          	addi	a5,a5,-216
ffffffffc02037e2:	bfb9                	j	ffffffffc0203740 <proc_init+0x13a>
        panic("cannot alloc idleproc.\n");
ffffffffc02037e4:	00002617          	auipc	a2,0x2
ffffffffc02037e8:	ea460613          	addi	a2,a2,-348 # ffffffffc0205688 <default_pmm_manager+0x9c0>
ffffffffc02037ec:	1a700593          	li	a1,423
ffffffffc02037f0:	00002517          	auipc	a0,0x2
ffffffffc02037f4:	e6850513          	addi	a0,a0,-408 # ffffffffc0205658 <default_pmm_manager+0x990>
ffffffffc02037f8:	c63fc0ef          	jal	ra,ffffffffc020045a <__panic>
        panic("create init_main failed.\n");
ffffffffc02037fc:	00002617          	auipc	a2,0x2
ffffffffc0203800:	ed460613          	addi	a2,a2,-300 # ffffffffc02056d0 <default_pmm_manager+0xa08>
ffffffffc0203804:	1c400593          	li	a1,452
ffffffffc0203808:	00002517          	auipc	a0,0x2
ffffffffc020380c:	e5050513          	addi	a0,a0,-432 # ffffffffc0205658 <default_pmm_manager+0x990>
ffffffffc0203810:	c4bfc0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0203814:	00002697          	auipc	a3,0x2
ffffffffc0203818:	f0c68693          	addi	a3,a3,-244 # ffffffffc0205720 <default_pmm_manager+0xa58>
ffffffffc020381c:	00001617          	auipc	a2,0x1
ffffffffc0203820:	0fc60613          	addi	a2,a2,252 # ffffffffc0204918 <commands+0x818>
ffffffffc0203824:	1cb00593          	li	a1,459
ffffffffc0203828:	00002517          	auipc	a0,0x2
ffffffffc020382c:	e3050513          	addi	a0,a0,-464 # ffffffffc0205658 <default_pmm_manager+0x990>
ffffffffc0203830:	c2bfc0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0203834:	00002697          	auipc	a3,0x2
ffffffffc0203838:	ec468693          	addi	a3,a3,-316 # ffffffffc02056f8 <default_pmm_manager+0xa30>
ffffffffc020383c:	00001617          	auipc	a2,0x1
ffffffffc0203840:	0dc60613          	addi	a2,a2,220 # ffffffffc0204918 <commands+0x818>
ffffffffc0203844:	1ca00593          	li	a1,458
ffffffffc0203848:	00002517          	auipc	a0,0x2
ffffffffc020384c:	e1050513          	addi	a0,a0,-496 # ffffffffc0205658 <default_pmm_manager+0x990>
ffffffffc0203850:	c0bfc0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0203854 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0203854:	1141                	addi	sp,sp,-16
ffffffffc0203856:	e022                	sd	s0,0(sp)
ffffffffc0203858:	e406                	sd	ra,8(sp)
ffffffffc020385a:	0000a417          	auipc	s0,0xa
ffffffffc020385e:	c7640413          	addi	s0,s0,-906 # ffffffffc020d4d0 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0203862:	6018                	ld	a4,0(s0)
ffffffffc0203864:	4f1c                	lw	a5,24(a4)
ffffffffc0203866:	2781                	sext.w	a5,a5
ffffffffc0203868:	dff5                	beqz	a5,ffffffffc0203864 <cpu_idle+0x10>
        {
            schedule();
ffffffffc020386a:	0a2000ef          	jal	ra,ffffffffc020390c <schedule>
ffffffffc020386e:	bfd5                	j	ffffffffc0203862 <cpu_idle+0xe>

ffffffffc0203870 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0203870:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0203874:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0203878:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc020387a:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc020387c:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0203880:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0203884:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0203888:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc020388c:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0203890:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0203894:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0203898:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc020389c:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc02038a0:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc02038a4:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc02038a8:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc02038ac:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc02038ae:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc02038b0:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc02038b4:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc02038b8:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc02038bc:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc02038c0:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc02038c4:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc02038c8:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc02038cc:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc02038d0:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc02038d4:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc02038d8:	8082                	ret

ffffffffc02038da <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02038da:	411c                	lw	a5,0(a0)
ffffffffc02038dc:	4705                	li	a4,1
ffffffffc02038de:	37f9                	addiw	a5,a5,-2
ffffffffc02038e0:	00f77563          	bgeu	a4,a5,ffffffffc02038ea <wakeup_proc+0x10>
    proc->state = PROC_RUNNABLE;
ffffffffc02038e4:	4789                	li	a5,2
ffffffffc02038e6:	c11c                	sw	a5,0(a0)
ffffffffc02038e8:	8082                	ret
wakeup_proc(struct proc_struct *proc) {
ffffffffc02038ea:	1141                	addi	sp,sp,-16
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02038ec:	00002697          	auipc	a3,0x2
ffffffffc02038f0:	e5c68693          	addi	a3,a3,-420 # ffffffffc0205748 <default_pmm_manager+0xa80>
ffffffffc02038f4:	00001617          	auipc	a2,0x1
ffffffffc02038f8:	02460613          	addi	a2,a2,36 # ffffffffc0204918 <commands+0x818>
ffffffffc02038fc:	45a5                	li	a1,9
ffffffffc02038fe:	00002517          	auipc	a0,0x2
ffffffffc0203902:	e8a50513          	addi	a0,a0,-374 # ffffffffc0205788 <default_pmm_manager+0xac0>
wakeup_proc(struct proc_struct *proc) {
ffffffffc0203906:	e406                	sd	ra,8(sp)
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc0203908:	b53fc0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc020390c <schedule>:
}

void
schedule(void) {
ffffffffc020390c:	1141                	addi	sp,sp,-16
ffffffffc020390e:	e406                	sd	ra,8(sp)
ffffffffc0203910:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203912:	100027f3          	csrr	a5,sstatus
ffffffffc0203916:	8b89                	andi	a5,a5,2
ffffffffc0203918:	4401                	li	s0,0
ffffffffc020391a:	efbd                	bnez	a5,ffffffffc0203998 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc020391c:	0000a897          	auipc	a7,0xa
ffffffffc0203920:	bb48b883          	ld	a7,-1100(a7) # ffffffffc020d4d0 <current>
ffffffffc0203924:	0008ac23          	sw	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203928:	0000a517          	auipc	a0,0xa
ffffffffc020392c:	bb053503          	ld	a0,-1104(a0) # ffffffffc020d4d8 <idleproc>
ffffffffc0203930:	04a88e63          	beq	a7,a0,ffffffffc020398c <schedule+0x80>
ffffffffc0203934:	0c888693          	addi	a3,a7,200
ffffffffc0203938:	0000a617          	auipc	a2,0xa
ffffffffc020393c:	b2060613          	addi	a2,a2,-1248 # ffffffffc020d458 <proc_list>
        le = last;
ffffffffc0203940:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0203942:	4581                	li	a1,0
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203944:	4809                	li	a6,2
ffffffffc0203946:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list) {
ffffffffc0203948:	00c78863          	beq	a5,a2,ffffffffc0203958 <schedule+0x4c>
                if (next->state == PROC_RUNNABLE) {
ffffffffc020394c:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0203950:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203954:	03070163          	beq	a4,a6,ffffffffc0203976 <schedule+0x6a>
                    break;
                }
            }
        } while (le != last);
ffffffffc0203958:	fef697e3          	bne	a3,a5,ffffffffc0203946 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc020395c:	ed89                	bnez	a1,ffffffffc0203976 <schedule+0x6a>
            next = idleproc;
        }
        next->runs ++;
ffffffffc020395e:	451c                	lw	a5,8(a0)
ffffffffc0203960:	2785                	addiw	a5,a5,1
ffffffffc0203962:	c51c                	sw	a5,8(a0)
        if (next != current) {
ffffffffc0203964:	00a88463          	beq	a7,a0,ffffffffc020396c <schedule+0x60>
            proc_run(next);
ffffffffc0203968:	98bff0ef          	jal	ra,ffffffffc02032f2 <proc_run>
    if (flag) {
ffffffffc020396c:	e819                	bnez	s0,ffffffffc0203982 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc020396e:	60a2                	ld	ra,8(sp)
ffffffffc0203970:	6402                	ld	s0,0(sp)
ffffffffc0203972:	0141                	addi	sp,sp,16
ffffffffc0203974:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0203976:	4198                	lw	a4,0(a1)
ffffffffc0203978:	4789                	li	a5,2
ffffffffc020397a:	fef712e3          	bne	a4,a5,ffffffffc020395e <schedule+0x52>
ffffffffc020397e:	852e                	mv	a0,a1
ffffffffc0203980:	bff9                	j	ffffffffc020395e <schedule+0x52>
}
ffffffffc0203982:	6402                	ld	s0,0(sp)
ffffffffc0203984:	60a2                	ld	ra,8(sp)
ffffffffc0203986:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0203988:	fa3fc06f          	j	ffffffffc020092a <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020398c:	0000a617          	auipc	a2,0xa
ffffffffc0203990:	acc60613          	addi	a2,a2,-1332 # ffffffffc020d458 <proc_list>
ffffffffc0203994:	86b2                	mv	a3,a2
ffffffffc0203996:	b76d                	j	ffffffffc0203940 <schedule+0x34>
        intr_disable();
ffffffffc0203998:	f99fc0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        return 1;
ffffffffc020399c:	4405                	li	s0,1
ffffffffc020399e:	bfbd                	j	ffffffffc020391c <schedule+0x10>

ffffffffc02039a0 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc02039a0:	9e3707b7          	lui	a5,0x9e370
ffffffffc02039a4:	2785                	addiw	a5,a5,1
ffffffffc02039a6:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc02039aa:	02000793          	li	a5,32
ffffffffc02039ae:	9f8d                	subw	a5,a5,a1
}
ffffffffc02039b0:	00f5553b          	srlw	a0,a0,a5
ffffffffc02039b4:	8082                	ret

ffffffffc02039b6 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02039b6:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02039ba:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02039bc:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02039c0:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02039c2:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02039c6:	f022                	sd	s0,32(sp)
ffffffffc02039c8:	ec26                	sd	s1,24(sp)
ffffffffc02039ca:	e84a                	sd	s2,16(sp)
ffffffffc02039cc:	f406                	sd	ra,40(sp)
ffffffffc02039ce:	e44e                	sd	s3,8(sp)
ffffffffc02039d0:	84aa                	mv	s1,a0
ffffffffc02039d2:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02039d4:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02039d8:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02039da:	03067e63          	bgeu	a2,a6,ffffffffc0203a16 <printnum+0x60>
ffffffffc02039de:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02039e0:	00805763          	blez	s0,ffffffffc02039ee <printnum+0x38>
ffffffffc02039e4:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02039e6:	85ca                	mv	a1,s2
ffffffffc02039e8:	854e                	mv	a0,s3
ffffffffc02039ea:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02039ec:	fc65                	bnez	s0,ffffffffc02039e4 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02039ee:	1a02                	slli	s4,s4,0x20
ffffffffc02039f0:	00002797          	auipc	a5,0x2
ffffffffc02039f4:	db078793          	addi	a5,a5,-592 # ffffffffc02057a0 <default_pmm_manager+0xad8>
ffffffffc02039f8:	020a5a13          	srli	s4,s4,0x20
ffffffffc02039fc:	9a3e                	add	s4,s4,a5
}
ffffffffc02039fe:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203a00:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0203a04:	70a2                	ld	ra,40(sp)
ffffffffc0203a06:	69a2                	ld	s3,8(sp)
ffffffffc0203a08:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203a0a:	85ca                	mv	a1,s2
ffffffffc0203a0c:	87a6                	mv	a5,s1
}
ffffffffc0203a0e:	6942                	ld	s2,16(sp)
ffffffffc0203a10:	64e2                	ld	s1,24(sp)
ffffffffc0203a12:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203a14:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0203a16:	03065633          	divu	a2,a2,a6
ffffffffc0203a1a:	8722                	mv	a4,s0
ffffffffc0203a1c:	f9bff0ef          	jal	ra,ffffffffc02039b6 <printnum>
ffffffffc0203a20:	b7f9                	j	ffffffffc02039ee <printnum+0x38>

ffffffffc0203a22 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0203a22:	7119                	addi	sp,sp,-128
ffffffffc0203a24:	f4a6                	sd	s1,104(sp)
ffffffffc0203a26:	f0ca                	sd	s2,96(sp)
ffffffffc0203a28:	ecce                	sd	s3,88(sp)
ffffffffc0203a2a:	e8d2                	sd	s4,80(sp)
ffffffffc0203a2c:	e4d6                	sd	s5,72(sp)
ffffffffc0203a2e:	e0da                	sd	s6,64(sp)
ffffffffc0203a30:	fc5e                	sd	s7,56(sp)
ffffffffc0203a32:	f06a                	sd	s10,32(sp)
ffffffffc0203a34:	fc86                	sd	ra,120(sp)
ffffffffc0203a36:	f8a2                	sd	s0,112(sp)
ffffffffc0203a38:	f862                	sd	s8,48(sp)
ffffffffc0203a3a:	f466                	sd	s9,40(sp)
ffffffffc0203a3c:	ec6e                	sd	s11,24(sp)
ffffffffc0203a3e:	892a                	mv	s2,a0
ffffffffc0203a40:	84ae                	mv	s1,a1
ffffffffc0203a42:	8d32                	mv	s10,a2
ffffffffc0203a44:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203a46:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0203a4a:	5b7d                	li	s6,-1
ffffffffc0203a4c:	00002a97          	auipc	s5,0x2
ffffffffc0203a50:	d80a8a93          	addi	s5,s5,-640 # ffffffffc02057cc <default_pmm_manager+0xb04>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203a54:	00002b97          	auipc	s7,0x2
ffffffffc0203a58:	f54b8b93          	addi	s7,s7,-172 # ffffffffc02059a8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203a5c:	000d4503          	lbu	a0,0(s10)
ffffffffc0203a60:	001d0413          	addi	s0,s10,1
ffffffffc0203a64:	01350a63          	beq	a0,s3,ffffffffc0203a78 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0203a68:	c121                	beqz	a0,ffffffffc0203aa8 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0203a6a:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203a6c:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0203a6e:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203a70:	fff44503          	lbu	a0,-1(s0)
ffffffffc0203a74:	ff351ae3          	bne	a0,s3,ffffffffc0203a68 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203a78:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0203a7c:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0203a80:	4c81                	li	s9,0
ffffffffc0203a82:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0203a84:	5c7d                	li	s8,-1
ffffffffc0203a86:	5dfd                	li	s11,-1
ffffffffc0203a88:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0203a8c:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203a8e:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203a92:	0ff5f593          	zext.b	a1,a1
ffffffffc0203a96:	00140d13          	addi	s10,s0,1
ffffffffc0203a9a:	04b56263          	bltu	a0,a1,ffffffffc0203ade <vprintfmt+0xbc>
ffffffffc0203a9e:	058a                	slli	a1,a1,0x2
ffffffffc0203aa0:	95d6                	add	a1,a1,s5
ffffffffc0203aa2:	4194                	lw	a3,0(a1)
ffffffffc0203aa4:	96d6                	add	a3,a3,s5
ffffffffc0203aa6:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0203aa8:	70e6                	ld	ra,120(sp)
ffffffffc0203aaa:	7446                	ld	s0,112(sp)
ffffffffc0203aac:	74a6                	ld	s1,104(sp)
ffffffffc0203aae:	7906                	ld	s2,96(sp)
ffffffffc0203ab0:	69e6                	ld	s3,88(sp)
ffffffffc0203ab2:	6a46                	ld	s4,80(sp)
ffffffffc0203ab4:	6aa6                	ld	s5,72(sp)
ffffffffc0203ab6:	6b06                	ld	s6,64(sp)
ffffffffc0203ab8:	7be2                	ld	s7,56(sp)
ffffffffc0203aba:	7c42                	ld	s8,48(sp)
ffffffffc0203abc:	7ca2                	ld	s9,40(sp)
ffffffffc0203abe:	7d02                	ld	s10,32(sp)
ffffffffc0203ac0:	6de2                	ld	s11,24(sp)
ffffffffc0203ac2:	6109                	addi	sp,sp,128
ffffffffc0203ac4:	8082                	ret
            padc = '0';
ffffffffc0203ac6:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0203ac8:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203acc:	846a                	mv	s0,s10
ffffffffc0203ace:	00140d13          	addi	s10,s0,1
ffffffffc0203ad2:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203ad6:	0ff5f593          	zext.b	a1,a1
ffffffffc0203ada:	fcb572e3          	bgeu	a0,a1,ffffffffc0203a9e <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0203ade:	85a6                	mv	a1,s1
ffffffffc0203ae0:	02500513          	li	a0,37
ffffffffc0203ae4:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0203ae6:	fff44783          	lbu	a5,-1(s0)
ffffffffc0203aea:	8d22                	mv	s10,s0
ffffffffc0203aec:	f73788e3          	beq	a5,s3,ffffffffc0203a5c <vprintfmt+0x3a>
ffffffffc0203af0:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0203af4:	1d7d                	addi	s10,s10,-1
ffffffffc0203af6:	ff379de3          	bne	a5,s3,ffffffffc0203af0 <vprintfmt+0xce>
ffffffffc0203afa:	b78d                	j	ffffffffc0203a5c <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0203afc:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0203b00:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b04:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0203b06:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0203b0a:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203b0e:	02d86463          	bltu	a6,a3,ffffffffc0203b36 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0203b12:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0203b16:	002c169b          	slliw	a3,s8,0x2
ffffffffc0203b1a:	0186873b          	addw	a4,a3,s8
ffffffffc0203b1e:	0017171b          	slliw	a4,a4,0x1
ffffffffc0203b22:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0203b24:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0203b28:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0203b2a:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0203b2e:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203b32:	fed870e3          	bgeu	a6,a3,ffffffffc0203b12 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0203b36:	f40ddce3          	bgez	s11,ffffffffc0203a8e <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0203b3a:	8de2                	mv	s11,s8
ffffffffc0203b3c:	5c7d                	li	s8,-1
ffffffffc0203b3e:	bf81                	j	ffffffffc0203a8e <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0203b40:	fffdc693          	not	a3,s11
ffffffffc0203b44:	96fd                	srai	a3,a3,0x3f
ffffffffc0203b46:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b4a:	00144603          	lbu	a2,1(s0)
ffffffffc0203b4e:	2d81                	sext.w	s11,s11
ffffffffc0203b50:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203b52:	bf35                	j	ffffffffc0203a8e <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0203b54:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b58:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0203b5c:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b5e:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0203b60:	bfd9                	j	ffffffffc0203b36 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0203b62:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203b64:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203b68:	01174463          	blt	a4,a7,ffffffffc0203b70 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0203b6c:	1a088e63          	beqz	a7,ffffffffc0203d28 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0203b70:	000a3603          	ld	a2,0(s4)
ffffffffc0203b74:	46c1                	li	a3,16
ffffffffc0203b76:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0203b78:	2781                	sext.w	a5,a5
ffffffffc0203b7a:	876e                	mv	a4,s11
ffffffffc0203b7c:	85a6                	mv	a1,s1
ffffffffc0203b7e:	854a                	mv	a0,s2
ffffffffc0203b80:	e37ff0ef          	jal	ra,ffffffffc02039b6 <printnum>
            break;
ffffffffc0203b84:	bde1                	j	ffffffffc0203a5c <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0203b86:	000a2503          	lw	a0,0(s4)
ffffffffc0203b8a:	85a6                	mv	a1,s1
ffffffffc0203b8c:	0a21                	addi	s4,s4,8
ffffffffc0203b8e:	9902                	jalr	s2
            break;
ffffffffc0203b90:	b5f1                	j	ffffffffc0203a5c <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0203b92:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203b94:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203b98:	01174463          	blt	a4,a7,ffffffffc0203ba0 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0203b9c:	18088163          	beqz	a7,ffffffffc0203d1e <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0203ba0:	000a3603          	ld	a2,0(s4)
ffffffffc0203ba4:	46a9                	li	a3,10
ffffffffc0203ba6:	8a2e                	mv	s4,a1
ffffffffc0203ba8:	bfc1                	j	ffffffffc0203b78 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203baa:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0203bae:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203bb0:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203bb2:	bdf1                	j	ffffffffc0203a8e <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0203bb4:	85a6                	mv	a1,s1
ffffffffc0203bb6:	02500513          	li	a0,37
ffffffffc0203bba:	9902                	jalr	s2
            break;
ffffffffc0203bbc:	b545                	j	ffffffffc0203a5c <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203bbe:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0203bc2:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203bc4:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203bc6:	b5e1                	j	ffffffffc0203a8e <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0203bc8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203bca:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203bce:	01174463          	blt	a4,a7,ffffffffc0203bd6 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0203bd2:	14088163          	beqz	a7,ffffffffc0203d14 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0203bd6:	000a3603          	ld	a2,0(s4)
ffffffffc0203bda:	46a1                	li	a3,8
ffffffffc0203bdc:	8a2e                	mv	s4,a1
ffffffffc0203bde:	bf69                	j	ffffffffc0203b78 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0203be0:	03000513          	li	a0,48
ffffffffc0203be4:	85a6                	mv	a1,s1
ffffffffc0203be6:	e03e                	sd	a5,0(sp)
ffffffffc0203be8:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0203bea:	85a6                	mv	a1,s1
ffffffffc0203bec:	07800513          	li	a0,120
ffffffffc0203bf0:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203bf2:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0203bf4:	6782                	ld	a5,0(sp)
ffffffffc0203bf6:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203bf8:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0203bfc:	bfb5                	j	ffffffffc0203b78 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203bfe:	000a3403          	ld	s0,0(s4)
ffffffffc0203c02:	008a0713          	addi	a4,s4,8
ffffffffc0203c06:	e03a                	sd	a4,0(sp)
ffffffffc0203c08:	14040263          	beqz	s0,ffffffffc0203d4c <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0203c0c:	0fb05763          	blez	s11,ffffffffc0203cfa <vprintfmt+0x2d8>
ffffffffc0203c10:	02d00693          	li	a3,45
ffffffffc0203c14:	0cd79163          	bne	a5,a3,ffffffffc0203cd6 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203c18:	00044783          	lbu	a5,0(s0)
ffffffffc0203c1c:	0007851b          	sext.w	a0,a5
ffffffffc0203c20:	cf85                	beqz	a5,ffffffffc0203c58 <vprintfmt+0x236>
ffffffffc0203c22:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203c26:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203c2a:	000c4563          	bltz	s8,ffffffffc0203c34 <vprintfmt+0x212>
ffffffffc0203c2e:	3c7d                	addiw	s8,s8,-1
ffffffffc0203c30:	036c0263          	beq	s8,s6,ffffffffc0203c54 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0203c34:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203c36:	0e0c8e63          	beqz	s9,ffffffffc0203d32 <vprintfmt+0x310>
ffffffffc0203c3a:	3781                	addiw	a5,a5,-32
ffffffffc0203c3c:	0ef47b63          	bgeu	s0,a5,ffffffffc0203d32 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0203c40:	03f00513          	li	a0,63
ffffffffc0203c44:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203c46:	000a4783          	lbu	a5,0(s4)
ffffffffc0203c4a:	3dfd                	addiw	s11,s11,-1
ffffffffc0203c4c:	0a05                	addi	s4,s4,1
ffffffffc0203c4e:	0007851b          	sext.w	a0,a5
ffffffffc0203c52:	ffe1                	bnez	a5,ffffffffc0203c2a <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0203c54:	01b05963          	blez	s11,ffffffffc0203c66 <vprintfmt+0x244>
ffffffffc0203c58:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0203c5a:	85a6                	mv	a1,s1
ffffffffc0203c5c:	02000513          	li	a0,32
ffffffffc0203c60:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0203c62:	fe0d9be3          	bnez	s11,ffffffffc0203c58 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203c66:	6a02                	ld	s4,0(sp)
ffffffffc0203c68:	bbd5                	j	ffffffffc0203a5c <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0203c6a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203c6c:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0203c70:	01174463          	blt	a4,a7,ffffffffc0203c78 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0203c74:	08088d63          	beqz	a7,ffffffffc0203d0e <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0203c78:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0203c7c:	0a044d63          	bltz	s0,ffffffffc0203d36 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0203c80:	8622                	mv	a2,s0
ffffffffc0203c82:	8a66                	mv	s4,s9
ffffffffc0203c84:	46a9                	li	a3,10
ffffffffc0203c86:	bdcd                	j	ffffffffc0203b78 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0203c88:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203c8c:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0203c8e:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0203c90:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0203c94:	8fb5                	xor	a5,a5,a3
ffffffffc0203c96:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203c9a:	02d74163          	blt	a4,a3,ffffffffc0203cbc <vprintfmt+0x29a>
ffffffffc0203c9e:	00369793          	slli	a5,a3,0x3
ffffffffc0203ca2:	97de                	add	a5,a5,s7
ffffffffc0203ca4:	639c                	ld	a5,0(a5)
ffffffffc0203ca6:	cb99                	beqz	a5,ffffffffc0203cbc <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0203ca8:	86be                	mv	a3,a5
ffffffffc0203caa:	00000617          	auipc	a2,0x0
ffffffffc0203cae:	21660613          	addi	a2,a2,534 # ffffffffc0203ec0 <etext+0x2c>
ffffffffc0203cb2:	85a6                	mv	a1,s1
ffffffffc0203cb4:	854a                	mv	a0,s2
ffffffffc0203cb6:	0ce000ef          	jal	ra,ffffffffc0203d84 <printfmt>
ffffffffc0203cba:	b34d                	j	ffffffffc0203a5c <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0203cbc:	00002617          	auipc	a2,0x2
ffffffffc0203cc0:	b0460613          	addi	a2,a2,-1276 # ffffffffc02057c0 <default_pmm_manager+0xaf8>
ffffffffc0203cc4:	85a6                	mv	a1,s1
ffffffffc0203cc6:	854a                	mv	a0,s2
ffffffffc0203cc8:	0bc000ef          	jal	ra,ffffffffc0203d84 <printfmt>
ffffffffc0203ccc:	bb41                	j	ffffffffc0203a5c <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0203cce:	00002417          	auipc	s0,0x2
ffffffffc0203cd2:	aea40413          	addi	s0,s0,-1302 # ffffffffc02057b8 <default_pmm_manager+0xaf0>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203cd6:	85e2                	mv	a1,s8
ffffffffc0203cd8:	8522                	mv	a0,s0
ffffffffc0203cda:	e43e                	sd	a5,8(sp)
ffffffffc0203cdc:	0e2000ef          	jal	ra,ffffffffc0203dbe <strnlen>
ffffffffc0203ce0:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0203ce4:	01b05b63          	blez	s11,ffffffffc0203cfa <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0203ce8:	67a2                	ld	a5,8(sp)
ffffffffc0203cea:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203cee:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0203cf0:	85a6                	mv	a1,s1
ffffffffc0203cf2:	8552                	mv	a0,s4
ffffffffc0203cf4:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203cf6:	fe0d9ce3          	bnez	s11,ffffffffc0203cee <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203cfa:	00044783          	lbu	a5,0(s0)
ffffffffc0203cfe:	00140a13          	addi	s4,s0,1
ffffffffc0203d02:	0007851b          	sext.w	a0,a5
ffffffffc0203d06:	d3a5                	beqz	a5,ffffffffc0203c66 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203d08:	05e00413          	li	s0,94
ffffffffc0203d0c:	bf39                	j	ffffffffc0203c2a <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0203d0e:	000a2403          	lw	s0,0(s4)
ffffffffc0203d12:	b7ad                	j	ffffffffc0203c7c <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0203d14:	000a6603          	lwu	a2,0(s4)
ffffffffc0203d18:	46a1                	li	a3,8
ffffffffc0203d1a:	8a2e                	mv	s4,a1
ffffffffc0203d1c:	bdb1                	j	ffffffffc0203b78 <vprintfmt+0x156>
ffffffffc0203d1e:	000a6603          	lwu	a2,0(s4)
ffffffffc0203d22:	46a9                	li	a3,10
ffffffffc0203d24:	8a2e                	mv	s4,a1
ffffffffc0203d26:	bd89                	j	ffffffffc0203b78 <vprintfmt+0x156>
ffffffffc0203d28:	000a6603          	lwu	a2,0(s4)
ffffffffc0203d2c:	46c1                	li	a3,16
ffffffffc0203d2e:	8a2e                	mv	s4,a1
ffffffffc0203d30:	b5a1                	j	ffffffffc0203b78 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0203d32:	9902                	jalr	s2
ffffffffc0203d34:	bf09                	j	ffffffffc0203c46 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0203d36:	85a6                	mv	a1,s1
ffffffffc0203d38:	02d00513          	li	a0,45
ffffffffc0203d3c:	e03e                	sd	a5,0(sp)
ffffffffc0203d3e:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0203d40:	6782                	ld	a5,0(sp)
ffffffffc0203d42:	8a66                	mv	s4,s9
ffffffffc0203d44:	40800633          	neg	a2,s0
ffffffffc0203d48:	46a9                	li	a3,10
ffffffffc0203d4a:	b53d                	j	ffffffffc0203b78 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0203d4c:	03b05163          	blez	s11,ffffffffc0203d6e <vprintfmt+0x34c>
ffffffffc0203d50:	02d00693          	li	a3,45
ffffffffc0203d54:	f6d79de3          	bne	a5,a3,ffffffffc0203cce <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0203d58:	00002417          	auipc	s0,0x2
ffffffffc0203d5c:	a6040413          	addi	s0,s0,-1440 # ffffffffc02057b8 <default_pmm_manager+0xaf0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203d60:	02800793          	li	a5,40
ffffffffc0203d64:	02800513          	li	a0,40
ffffffffc0203d68:	00140a13          	addi	s4,s0,1
ffffffffc0203d6c:	bd6d                	j	ffffffffc0203c26 <vprintfmt+0x204>
ffffffffc0203d6e:	00002a17          	auipc	s4,0x2
ffffffffc0203d72:	a4ba0a13          	addi	s4,s4,-1461 # ffffffffc02057b9 <default_pmm_manager+0xaf1>
ffffffffc0203d76:	02800513          	li	a0,40
ffffffffc0203d7a:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203d7e:	05e00413          	li	s0,94
ffffffffc0203d82:	b565                	j	ffffffffc0203c2a <vprintfmt+0x208>

ffffffffc0203d84 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203d84:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0203d86:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203d8a:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203d8c:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203d8e:	ec06                	sd	ra,24(sp)
ffffffffc0203d90:	f83a                	sd	a4,48(sp)
ffffffffc0203d92:	fc3e                	sd	a5,56(sp)
ffffffffc0203d94:	e0c2                	sd	a6,64(sp)
ffffffffc0203d96:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0203d98:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203d9a:	c89ff0ef          	jal	ra,ffffffffc0203a22 <vprintfmt>
}
ffffffffc0203d9e:	60e2                	ld	ra,24(sp)
ffffffffc0203da0:	6161                	addi	sp,sp,80
ffffffffc0203da2:	8082                	ret

ffffffffc0203da4 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0203da4:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0203da8:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0203daa:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0203dac:	cb81                	beqz	a5,ffffffffc0203dbc <strlen+0x18>
        cnt ++;
ffffffffc0203dae:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0203db0:	00a707b3          	add	a5,a4,a0
ffffffffc0203db4:	0007c783          	lbu	a5,0(a5)
ffffffffc0203db8:	fbfd                	bnez	a5,ffffffffc0203dae <strlen+0xa>
ffffffffc0203dba:	8082                	ret
    }
    return cnt;
}
ffffffffc0203dbc:	8082                	ret

ffffffffc0203dbe <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0203dbe:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203dc0:	e589                	bnez	a1,ffffffffc0203dca <strnlen+0xc>
ffffffffc0203dc2:	a811                	j	ffffffffc0203dd6 <strnlen+0x18>
        cnt ++;
ffffffffc0203dc4:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203dc6:	00f58863          	beq	a1,a5,ffffffffc0203dd6 <strnlen+0x18>
ffffffffc0203dca:	00f50733          	add	a4,a0,a5
ffffffffc0203dce:	00074703          	lbu	a4,0(a4)
ffffffffc0203dd2:	fb6d                	bnez	a4,ffffffffc0203dc4 <strnlen+0x6>
ffffffffc0203dd4:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0203dd6:	852e                	mv	a0,a1
ffffffffc0203dd8:	8082                	ret

ffffffffc0203dda <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0203dda:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0203ddc:	0005c703          	lbu	a4,0(a1)
ffffffffc0203de0:	0785                	addi	a5,a5,1
ffffffffc0203de2:	0585                	addi	a1,a1,1
ffffffffc0203de4:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203de8:	fb75                	bnez	a4,ffffffffc0203ddc <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0203dea:	8082                	ret

ffffffffc0203dec <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203dec:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203df0:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203df4:	cb89                	beqz	a5,ffffffffc0203e06 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0203df6:	0505                	addi	a0,a0,1
ffffffffc0203df8:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203dfa:	fee789e3          	beq	a5,a4,ffffffffc0203dec <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203dfe:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0203e02:	9d19                	subw	a0,a0,a4
ffffffffc0203e04:	8082                	ret
ffffffffc0203e06:	4501                	li	a0,0
ffffffffc0203e08:	bfed                	j	ffffffffc0203e02 <strcmp+0x16>

ffffffffc0203e0a <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203e0a:	c20d                	beqz	a2,ffffffffc0203e2c <strncmp+0x22>
ffffffffc0203e0c:	962e                	add	a2,a2,a1
ffffffffc0203e0e:	a031                	j	ffffffffc0203e1a <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0203e10:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203e12:	00e79a63          	bne	a5,a4,ffffffffc0203e26 <strncmp+0x1c>
ffffffffc0203e16:	00b60b63          	beq	a2,a1,ffffffffc0203e2c <strncmp+0x22>
ffffffffc0203e1a:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0203e1e:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203e20:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0203e24:	f7f5                	bnez	a5,ffffffffc0203e10 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203e26:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0203e2a:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203e2c:	4501                	li	a0,0
ffffffffc0203e2e:	8082                	ret

ffffffffc0203e30 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0203e30:	00054783          	lbu	a5,0(a0)
ffffffffc0203e34:	c799                	beqz	a5,ffffffffc0203e42 <strchr+0x12>
        if (*s == c) {
ffffffffc0203e36:	00f58763          	beq	a1,a5,ffffffffc0203e44 <strchr+0x14>
    while (*s != '\0') {
ffffffffc0203e3a:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0203e3e:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0203e40:	fbfd                	bnez	a5,ffffffffc0203e36 <strchr+0x6>
    }
    return NULL;
ffffffffc0203e42:	4501                	li	a0,0
}
ffffffffc0203e44:	8082                	ret

ffffffffc0203e46 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0203e46:	ca01                	beqz	a2,ffffffffc0203e56 <memset+0x10>
ffffffffc0203e48:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0203e4a:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0203e4c:	0785                	addi	a5,a5,1
ffffffffc0203e4e:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0203e52:	fec79de3          	bne	a5,a2,ffffffffc0203e4c <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0203e56:	8082                	ret

ffffffffc0203e58 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0203e58:	ca19                	beqz	a2,ffffffffc0203e6e <memcpy+0x16>
ffffffffc0203e5a:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0203e5c:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0203e5e:	0005c703          	lbu	a4,0(a1)
ffffffffc0203e62:	0585                	addi	a1,a1,1
ffffffffc0203e64:	0785                	addi	a5,a5,1
ffffffffc0203e66:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0203e6a:	fec59ae3          	bne	a1,a2,ffffffffc0203e5e <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0203e6e:	8082                	ret

ffffffffc0203e70 <memcmp>:
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
ffffffffc0203e70:	c205                	beqz	a2,ffffffffc0203e90 <memcmp+0x20>
ffffffffc0203e72:	962e                	add	a2,a2,a1
ffffffffc0203e74:	a019                	j	ffffffffc0203e7a <memcmp+0xa>
ffffffffc0203e76:	00c58d63          	beq	a1,a2,ffffffffc0203e90 <memcmp+0x20>
        if (*s1 != *s2) {
ffffffffc0203e7a:	00054783          	lbu	a5,0(a0)
ffffffffc0203e7e:	0005c703          	lbu	a4,0(a1)
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
ffffffffc0203e82:	0505                	addi	a0,a0,1
ffffffffc0203e84:	0585                	addi	a1,a1,1
        if (*s1 != *s2) {
ffffffffc0203e86:	fee788e3          	beq	a5,a4,ffffffffc0203e76 <memcmp+0x6>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203e8a:	40e7853b          	subw	a0,a5,a4
ffffffffc0203e8e:	8082                	ret
    }
    return 0;
ffffffffc0203e90:	4501                	li	a0,0
}
ffffffffc0203e92:	8082                	ret
