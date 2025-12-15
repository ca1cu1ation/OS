
obj/__user_dirtycow.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
.text
.globl _start
_start:
    # call user-program function
    call umain
  800020:	0f0000ef          	jal	ra,800110 <umain>
1:  j 1b
  800024:	a001                	j	800024 <_start+0x4>

0000000000800026 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800026:	1141                	addi	sp,sp,-16
  800028:	e022                	sd	s0,0(sp)
  80002a:	e406                	sd	ra,8(sp)
  80002c:	842e                	mv	s0,a1
    sys_putc(c);
  80002e:	098000ef          	jal	ra,8000c6 <sys_putc>
    (*cnt) ++;
  800032:	401c                	lw	a5,0(s0)
}
  800034:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
  800036:	2785                	addiw	a5,a5,1
  800038:	c01c                	sw	a5,0(s0)
}
  80003a:	6402                	ld	s0,0(sp)
  80003c:	0141                	addi	sp,sp,16
  80003e:	8082                	ret

0000000000800040 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  800040:	711d                	addi	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  800042:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
  800046:	8e2a                	mv	t3,a0
  800048:	f42e                	sd	a1,40(sp)
  80004a:	f832                	sd	a2,48(sp)
  80004c:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80004e:	00000517          	auipc	a0,0x0
  800052:	fd850513          	addi	a0,a0,-40 # 800026 <cputch>
  800056:	004c                	addi	a1,sp,4
  800058:	869a                	mv	a3,t1
  80005a:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
  80005c:	ec06                	sd	ra,24(sp)
  80005e:	e0ba                	sd	a4,64(sp)
  800060:	e4be                	sd	a5,72(sp)
  800062:	e8c2                	sd	a6,80(sp)
  800064:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
  800066:	e41a                	sd	t1,8(sp)
    int cnt = 0;
  800068:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80006a:	11e000ef          	jal	ra,800188 <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  80006e:	60e2                	ld	ra,24(sp)
  800070:	4512                	lw	a0,4(sp)
  800072:	6125                	addi	sp,sp,96
  800074:	8082                	ret

0000000000800076 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  800076:	7175                	addi	sp,sp,-144
  800078:	f8ba                	sd	a4,112(sp)
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  80007a:	e0ba                	sd	a4,64(sp)
  80007c:	0118                	addi	a4,sp,128
syscall(int64_t num, ...) {
  80007e:	e42a                	sd	a0,8(sp)
  800080:	ecae                	sd	a1,88(sp)
  800082:	f0b2                	sd	a2,96(sp)
  800084:	f4b6                	sd	a3,104(sp)
  800086:	fcbe                	sd	a5,120(sp)
  800088:	e142                	sd	a6,128(sp)
  80008a:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  80008c:	f42e                	sd	a1,40(sp)
  80008e:	f832                	sd	a2,48(sp)
  800090:	fc36                	sd	a3,56(sp)
  800092:	f03a                	sd	a4,32(sp)
  800094:	e4be                	sd	a5,72(sp)
    }
    va_end(ap);

    asm volatile (
  800096:	6522                	ld	a0,8(sp)
  800098:	75a2                	ld	a1,40(sp)
  80009a:	7642                	ld	a2,48(sp)
  80009c:	76e2                	ld	a3,56(sp)
  80009e:	6706                	ld	a4,64(sp)
  8000a0:	67a6                	ld	a5,72(sp)
  8000a2:	00000073          	ecall
  8000a6:	00a13e23          	sd	a0,28(sp)
        "sd a0, %0"
        : "=m" (ret)
        : "m"(num), "m"(a[0]), "m"(a[1]), "m"(a[2]), "m"(a[3]), "m"(a[4])
        :"memory");
    return ret;
}
  8000aa:	4572                	lw	a0,28(sp)
  8000ac:	6149                	addi	sp,sp,144
  8000ae:	8082                	ret

00000000008000b0 <sys_exit>:

int
sys_exit(int64_t error_code) {
  8000b0:	85aa                	mv	a1,a0
    return syscall(SYS_exit, error_code);
  8000b2:	4505                	li	a0,1
  8000b4:	b7c9                	j	800076 <syscall>

00000000008000b6 <sys_fork>:
}

int
sys_fork(void) {
    return syscall(SYS_fork);
  8000b6:	4509                	li	a0,2
  8000b8:	bf7d                	j	800076 <syscall>

00000000008000ba <sys_wait>:
}

int
sys_wait(int64_t pid, int *store) {
  8000ba:	862e                	mv	a2,a1
    return syscall(SYS_wait, pid, store);
  8000bc:	85aa                	mv	a1,a0
  8000be:	450d                	li	a0,3
  8000c0:	bf5d                	j	800076 <syscall>

00000000008000c2 <sys_yield>:
}

int
sys_yield(void) {
    return syscall(SYS_yield);
  8000c2:	4529                	li	a0,10
  8000c4:	bf4d                	j	800076 <syscall>

00000000008000c6 <sys_putc>:
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int64_t c) {
  8000c6:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000c8:	4579                	li	a0,30
  8000ca:	b775                	j	800076 <syscall>

00000000008000cc <sys_madvise>:
sys_pgdir(void) {
    return syscall(SYS_pgdir);
}

int
sys_madvise(uintptr_t addr, size_t len) {
  8000cc:	862e                	mv	a2,a1
    return syscall(SYS_madvise, addr, len);
  8000ce:	85aa                	mv	a1,a0
  8000d0:	02000513          	li	a0,32
  8000d4:	b74d                	j	800076 <syscall>

00000000008000d6 <sys_map_backing>:
}

uintptr_t
sys_map_backing(uintptr_t addr, size_t len) {
  8000d6:	1141                	addi	sp,sp,-16
  8000d8:	862e                	mv	a2,a1
    return (uintptr_t)syscall(SYS_map_backing, addr, len);
  8000da:	85aa                	mv	a1,a0
  8000dc:	02100513          	li	a0,33
sys_map_backing(uintptr_t addr, size_t len) {
  8000e0:	e406                	sd	ra,8(sp)
    return (uintptr_t)syscall(SYS_map_backing, addr, len);
  8000e2:	f95ff0ef          	jal	ra,800076 <syscall>
}
  8000e6:	60a2                	ld	ra,8(sp)
  8000e8:	0141                	addi	sp,sp,16
  8000ea:	8082                	ret

00000000008000ec <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000ec:	1141                	addi	sp,sp,-16
  8000ee:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000f0:	fc1ff0ef          	jal	ra,8000b0 <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000f4:	00000517          	auipc	a0,0x0
  8000f8:	7f450513          	addi	a0,a0,2036 # 8008e8 <main+0x6a>
  8000fc:	f45ff0ef          	jal	ra,800040 <cprintf>
    while (1);
  800100:	a001                	j	800100 <exit+0x14>

0000000000800102 <fork>:
}

int
fork(void) {
    return sys_fork();
  800102:	bf55                	j	8000b6 <sys_fork>

0000000000800104 <wait>:
}

int
wait(void) {
    return sys_wait(0, NULL);
  800104:	4581                	li	a1,0
  800106:	4501                	li	a0,0
  800108:	bf4d                	j	8000ba <sys_wait>

000000000080010a <yield>:
    return sys_wait(pid, store);
}

void
yield(void) {
    sys_yield();
  80010a:	bf65                	j	8000c2 <sys_yield>

000000000080010c <madvise_dontneed>:
    return sys_getpid();
}

int
madvise_dontneed(void *addr, size_t len) {
    return sys_madvise((uintptr_t)addr, len);
  80010c:	b7c1                	j	8000cc <sys_madvise>

000000000080010e <map_backing>:
}

void *
map_backing(void *addr, size_t len) {
    return (void *)sys_map_backing((uintptr_t)addr, len);
  80010e:	b7e1                	j	8000d6 <sys_map_backing>

0000000000800110 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  800110:	1141                	addi	sp,sp,-16
  800112:	e406                	sd	ra,8(sp)
    int ret = main();
  800114:	76a000ef          	jal	ra,80087e <main>
    exit(ret);
  800118:	fd5ff0ef          	jal	ra,8000ec <exit>

000000000080011c <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  80011c:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800120:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
  800122:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800126:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  800128:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  80012c:	f022                	sd	s0,32(sp)
  80012e:	ec26                	sd	s1,24(sp)
  800130:	e84a                	sd	s2,16(sp)
  800132:	f406                	sd	ra,40(sp)
  800134:	e44e                	sd	s3,8(sp)
  800136:	84aa                	mv	s1,a0
  800138:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  80013a:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
  80013e:	2a01                	sext.w	s4,s4
    if (num >= base) {
  800140:	03067e63          	bgeu	a2,a6,80017c <printnum+0x60>
  800144:	89be                	mv	s3,a5
        while (-- width > 0)
  800146:	00805763          	blez	s0,800154 <printnum+0x38>
  80014a:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  80014c:	85ca                	mv	a1,s2
  80014e:	854e                	mv	a0,s3
  800150:	9482                	jalr	s1
        while (-- width > 0)
  800152:	fc65                	bnez	s0,80014a <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  800154:	1a02                	slli	s4,s4,0x20
  800156:	00000797          	auipc	a5,0x0
  80015a:	7aa78793          	addi	a5,a5,1962 # 800900 <main+0x82>
  80015e:	020a5a13          	srli	s4,s4,0x20
  800162:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  800164:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  800166:	000a4503          	lbu	a0,0(s4)
}
  80016a:	70a2                	ld	ra,40(sp)
  80016c:	69a2                	ld	s3,8(sp)
  80016e:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  800170:	85ca                	mv	a1,s2
  800172:	87a6                	mv	a5,s1
}
  800174:	6942                	ld	s2,16(sp)
  800176:	64e2                	ld	s1,24(sp)
  800178:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  80017a:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  80017c:	03065633          	divu	a2,a2,a6
  800180:	8722                	mv	a4,s0
  800182:	f9bff0ef          	jal	ra,80011c <printnum>
  800186:	b7f9                	j	800154 <printnum+0x38>

0000000000800188 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  800188:	7119                	addi	sp,sp,-128
  80018a:	f4a6                	sd	s1,104(sp)
  80018c:	f0ca                	sd	s2,96(sp)
  80018e:	ecce                	sd	s3,88(sp)
  800190:	e8d2                	sd	s4,80(sp)
  800192:	e4d6                	sd	s5,72(sp)
  800194:	e0da                	sd	s6,64(sp)
  800196:	fc5e                	sd	s7,56(sp)
  800198:	f06a                	sd	s10,32(sp)
  80019a:	fc86                	sd	ra,120(sp)
  80019c:	f8a2                	sd	s0,112(sp)
  80019e:	f862                	sd	s8,48(sp)
  8001a0:	f466                	sd	s9,40(sp)
  8001a2:	ec6e                	sd	s11,24(sp)
  8001a4:	892a                	mv	s2,a0
  8001a6:	84ae                	mv	s1,a1
  8001a8:	8d32                	mv	s10,a2
  8001aa:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001ac:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  8001b0:	5b7d                	li	s6,-1
  8001b2:	00000a97          	auipc	s5,0x0
  8001b6:	782a8a93          	addi	s5,s5,1922 # 800934 <main+0xb6>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8001ba:	00001b97          	auipc	s7,0x1
  8001be:	996b8b93          	addi	s7,s7,-1642 # 800b50 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001c2:	000d4503          	lbu	a0,0(s10)
  8001c6:	001d0413          	addi	s0,s10,1
  8001ca:	01350a63          	beq	a0,s3,8001de <vprintfmt+0x56>
            if (ch == '\0') {
  8001ce:	c121                	beqz	a0,80020e <vprintfmt+0x86>
            putch(ch, putdat);
  8001d0:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001d2:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  8001d4:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001d6:	fff44503          	lbu	a0,-1(s0)
  8001da:	ff351ae3          	bne	a0,s3,8001ce <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
  8001de:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
  8001e2:	02000793          	li	a5,32
        lflag = altflag = 0;
  8001e6:	4c81                	li	s9,0
  8001e8:	4881                	li	a7,0
        width = precision = -1;
  8001ea:	5c7d                	li	s8,-1
  8001ec:	5dfd                	li	s11,-1
  8001ee:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
  8001f2:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
  8001f4:	fdd6059b          	addiw	a1,a2,-35
  8001f8:	0ff5f593          	zext.b	a1,a1
  8001fc:	00140d13          	addi	s10,s0,1
  800200:	04b56263          	bltu	a0,a1,800244 <vprintfmt+0xbc>
  800204:	058a                	slli	a1,a1,0x2
  800206:	95d6                	add	a1,a1,s5
  800208:	4194                	lw	a3,0(a1)
  80020a:	96d6                	add	a3,a3,s5
  80020c:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  80020e:	70e6                	ld	ra,120(sp)
  800210:	7446                	ld	s0,112(sp)
  800212:	74a6                	ld	s1,104(sp)
  800214:	7906                	ld	s2,96(sp)
  800216:	69e6                	ld	s3,88(sp)
  800218:	6a46                	ld	s4,80(sp)
  80021a:	6aa6                	ld	s5,72(sp)
  80021c:	6b06                	ld	s6,64(sp)
  80021e:	7be2                	ld	s7,56(sp)
  800220:	7c42                	ld	s8,48(sp)
  800222:	7ca2                	ld	s9,40(sp)
  800224:	7d02                	ld	s10,32(sp)
  800226:	6de2                	ld	s11,24(sp)
  800228:	6109                	addi	sp,sp,128
  80022a:	8082                	ret
            padc = '0';
  80022c:	87b2                	mv	a5,a2
            goto reswitch;
  80022e:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800232:	846a                	mv	s0,s10
  800234:	00140d13          	addi	s10,s0,1
  800238:	fdd6059b          	addiw	a1,a2,-35
  80023c:	0ff5f593          	zext.b	a1,a1
  800240:	fcb572e3          	bgeu	a0,a1,800204 <vprintfmt+0x7c>
            putch('%', putdat);
  800244:	85a6                	mv	a1,s1
  800246:	02500513          	li	a0,37
  80024a:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  80024c:	fff44783          	lbu	a5,-1(s0)
  800250:	8d22                	mv	s10,s0
  800252:	f73788e3          	beq	a5,s3,8001c2 <vprintfmt+0x3a>
  800256:	ffed4783          	lbu	a5,-2(s10)
  80025a:	1d7d                	addi	s10,s10,-1
  80025c:	ff379de3          	bne	a5,s3,800256 <vprintfmt+0xce>
  800260:	b78d                	j	8001c2 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  800262:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
  800266:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80026a:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
  80026c:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
  800270:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  800274:	02d86463          	bltu	a6,a3,80029c <vprintfmt+0x114>
                ch = *fmt;
  800278:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
  80027c:	002c169b          	slliw	a3,s8,0x2
  800280:	0186873b          	addw	a4,a3,s8
  800284:	0017171b          	slliw	a4,a4,0x1
  800288:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
  80028a:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
  80028e:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  800290:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  800294:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  800298:	fed870e3          	bgeu	a6,a3,800278 <vprintfmt+0xf0>
            if (width < 0)
  80029c:	f40ddce3          	bgez	s11,8001f4 <vprintfmt+0x6c>
                width = precision, precision = -1;
  8002a0:	8de2                	mv	s11,s8
  8002a2:	5c7d                	li	s8,-1
  8002a4:	bf81                	j	8001f4 <vprintfmt+0x6c>
            if (width < 0)
  8002a6:	fffdc693          	not	a3,s11
  8002aa:	96fd                	srai	a3,a3,0x3f
  8002ac:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
  8002b0:	00144603          	lbu	a2,1(s0)
  8002b4:	2d81                	sext.w	s11,s11
  8002b6:	846a                	mv	s0,s10
            goto reswitch;
  8002b8:	bf35                	j	8001f4 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  8002ba:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  8002be:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
  8002c2:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  8002c4:	846a                	mv	s0,s10
            goto process_precision;
  8002c6:	bfd9                	j	80029c <vprintfmt+0x114>
    if (lflag >= 2) {
  8002c8:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8002ca:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002ce:	01174463          	blt	a4,a7,8002d6 <vprintfmt+0x14e>
    else if (lflag) {
  8002d2:	1a088e63          	beqz	a7,80048e <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
  8002d6:	000a3603          	ld	a2,0(s4)
  8002da:	46c1                	li	a3,16
  8002dc:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
  8002de:	2781                	sext.w	a5,a5
  8002e0:	876e                	mv	a4,s11
  8002e2:	85a6                	mv	a1,s1
  8002e4:	854a                	mv	a0,s2
  8002e6:	e37ff0ef          	jal	ra,80011c <printnum>
            break;
  8002ea:	bde1                	j	8001c2 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8002ec:	000a2503          	lw	a0,0(s4)
  8002f0:	85a6                	mv	a1,s1
  8002f2:	0a21                	addi	s4,s4,8
  8002f4:	9902                	jalr	s2
            break;
  8002f6:	b5f1                	j	8001c2 <vprintfmt+0x3a>
    if (lflag >= 2) {
  8002f8:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8002fa:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002fe:	01174463          	blt	a4,a7,800306 <vprintfmt+0x17e>
    else if (lflag) {
  800302:	18088163          	beqz	a7,800484 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
  800306:	000a3603          	ld	a2,0(s4)
  80030a:	46a9                	li	a3,10
  80030c:	8a2e                	mv	s4,a1
  80030e:	bfc1                	j	8002de <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
  800310:	00144603          	lbu	a2,1(s0)
            altflag = 1;
  800314:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
  800316:	846a                	mv	s0,s10
            goto reswitch;
  800318:	bdf1                	j	8001f4 <vprintfmt+0x6c>
            putch(ch, putdat);
  80031a:	85a6                	mv	a1,s1
  80031c:	02500513          	li	a0,37
  800320:	9902                	jalr	s2
            break;
  800322:	b545                	j	8001c2 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  800324:	00144603          	lbu	a2,1(s0)
            lflag ++;
  800328:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
  80032a:	846a                	mv	s0,s10
            goto reswitch;
  80032c:	b5e1                	j	8001f4 <vprintfmt+0x6c>
    if (lflag >= 2) {
  80032e:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800330:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800334:	01174463          	blt	a4,a7,80033c <vprintfmt+0x1b4>
    else if (lflag) {
  800338:	14088163          	beqz	a7,80047a <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
  80033c:	000a3603          	ld	a2,0(s4)
  800340:	46a1                	li	a3,8
  800342:	8a2e                	mv	s4,a1
  800344:	bf69                	j	8002de <vprintfmt+0x156>
            putch('0', putdat);
  800346:	03000513          	li	a0,48
  80034a:	85a6                	mv	a1,s1
  80034c:	e03e                	sd	a5,0(sp)
  80034e:	9902                	jalr	s2
            putch('x', putdat);
  800350:	85a6                	mv	a1,s1
  800352:	07800513          	li	a0,120
  800356:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800358:	0a21                	addi	s4,s4,8
            goto number;
  80035a:	6782                	ld	a5,0(sp)
  80035c:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80035e:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  800362:	bfb5                	j	8002de <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
  800364:	000a3403          	ld	s0,0(s4)
  800368:	008a0713          	addi	a4,s4,8
  80036c:	e03a                	sd	a4,0(sp)
  80036e:	14040263          	beqz	s0,8004b2 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
  800372:	0fb05763          	blez	s11,800460 <vprintfmt+0x2d8>
  800376:	02d00693          	li	a3,45
  80037a:	0cd79163          	bne	a5,a3,80043c <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80037e:	00044783          	lbu	a5,0(s0)
  800382:	0007851b          	sext.w	a0,a5
  800386:	cf85                	beqz	a5,8003be <vprintfmt+0x236>
  800388:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
  80038c:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800390:	000c4563          	bltz	s8,80039a <vprintfmt+0x212>
  800394:	3c7d                	addiw	s8,s8,-1
  800396:	036c0263          	beq	s8,s6,8003ba <vprintfmt+0x232>
                    putch('?', putdat);
  80039a:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  80039c:	0e0c8e63          	beqz	s9,800498 <vprintfmt+0x310>
  8003a0:	3781                	addiw	a5,a5,-32
  8003a2:	0ef47b63          	bgeu	s0,a5,800498 <vprintfmt+0x310>
                    putch('?', putdat);
  8003a6:	03f00513          	li	a0,63
  8003aa:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003ac:	000a4783          	lbu	a5,0(s4)
  8003b0:	3dfd                	addiw	s11,s11,-1
  8003b2:	0a05                	addi	s4,s4,1
  8003b4:	0007851b          	sext.w	a0,a5
  8003b8:	ffe1                	bnez	a5,800390 <vprintfmt+0x208>
            for (; width > 0; width --) {
  8003ba:	01b05963          	blez	s11,8003cc <vprintfmt+0x244>
  8003be:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
  8003c0:	85a6                	mv	a1,s1
  8003c2:	02000513          	li	a0,32
  8003c6:	9902                	jalr	s2
            for (; width > 0; width --) {
  8003c8:	fe0d9be3          	bnez	s11,8003be <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
  8003cc:	6a02                	ld	s4,0(sp)
  8003ce:	bbd5                	j	8001c2 <vprintfmt+0x3a>
    if (lflag >= 2) {
  8003d0:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8003d2:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
  8003d6:	01174463          	blt	a4,a7,8003de <vprintfmt+0x256>
    else if (lflag) {
  8003da:	08088d63          	beqz	a7,800474 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
  8003de:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  8003e2:	0a044d63          	bltz	s0,80049c <vprintfmt+0x314>
            num = getint(&ap, lflag);
  8003e6:	8622                	mv	a2,s0
  8003e8:	8a66                	mv	s4,s9
  8003ea:	46a9                	li	a3,10
  8003ec:	bdcd                	j	8002de <vprintfmt+0x156>
            err = va_arg(ap, int);
  8003ee:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003f2:	4761                	li	a4,24
            err = va_arg(ap, int);
  8003f4:	0a21                	addi	s4,s4,8
            if (err < 0) {
  8003f6:	41f7d69b          	sraiw	a3,a5,0x1f
  8003fa:	8fb5                	xor	a5,a5,a3
  8003fc:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800400:	02d74163          	blt	a4,a3,800422 <vprintfmt+0x29a>
  800404:	00369793          	slli	a5,a3,0x3
  800408:	97de                	add	a5,a5,s7
  80040a:	639c                	ld	a5,0(a5)
  80040c:	cb99                	beqz	a5,800422 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
  80040e:	86be                	mv	a3,a5
  800410:	00000617          	auipc	a2,0x0
  800414:	52060613          	addi	a2,a2,1312 # 800930 <main+0xb2>
  800418:	85a6                	mv	a1,s1
  80041a:	854a                	mv	a0,s2
  80041c:	0ce000ef          	jal	ra,8004ea <printfmt>
  800420:	b34d                	j	8001c2 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  800422:	00000617          	auipc	a2,0x0
  800426:	4fe60613          	addi	a2,a2,1278 # 800920 <main+0xa2>
  80042a:	85a6                	mv	a1,s1
  80042c:	854a                	mv	a0,s2
  80042e:	0bc000ef          	jal	ra,8004ea <printfmt>
  800432:	bb41                	j	8001c2 <vprintfmt+0x3a>
                p = "(null)";
  800434:	00000417          	auipc	s0,0x0
  800438:	4e440413          	addi	s0,s0,1252 # 800918 <main+0x9a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  80043c:	85e2                	mv	a1,s8
  80043e:	8522                	mv	a0,s0
  800440:	e43e                	sd	a5,8(sp)
  800442:	0c8000ef          	jal	ra,80050a <strnlen>
  800446:	40ad8dbb          	subw	s11,s11,a0
  80044a:	01b05b63          	blez	s11,800460 <vprintfmt+0x2d8>
                    putch(padc, putdat);
  80044e:	67a2                	ld	a5,8(sp)
  800450:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
  800454:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
  800456:	85a6                	mv	a1,s1
  800458:	8552                	mv	a0,s4
  80045a:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  80045c:	fe0d9ce3          	bnez	s11,800454 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800460:	00044783          	lbu	a5,0(s0)
  800464:	00140a13          	addi	s4,s0,1
  800468:	0007851b          	sext.w	a0,a5
  80046c:	d3a5                	beqz	a5,8003cc <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
  80046e:	05e00413          	li	s0,94
  800472:	bf39                	j	800390 <vprintfmt+0x208>
        return va_arg(*ap, int);
  800474:	000a2403          	lw	s0,0(s4)
  800478:	b7ad                	j	8003e2 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
  80047a:	000a6603          	lwu	a2,0(s4)
  80047e:	46a1                	li	a3,8
  800480:	8a2e                	mv	s4,a1
  800482:	bdb1                	j	8002de <vprintfmt+0x156>
  800484:	000a6603          	lwu	a2,0(s4)
  800488:	46a9                	li	a3,10
  80048a:	8a2e                	mv	s4,a1
  80048c:	bd89                	j	8002de <vprintfmt+0x156>
  80048e:	000a6603          	lwu	a2,0(s4)
  800492:	46c1                	li	a3,16
  800494:	8a2e                	mv	s4,a1
  800496:	b5a1                	j	8002de <vprintfmt+0x156>
                    putch(ch, putdat);
  800498:	9902                	jalr	s2
  80049a:	bf09                	j	8003ac <vprintfmt+0x224>
                putch('-', putdat);
  80049c:	85a6                	mv	a1,s1
  80049e:	02d00513          	li	a0,45
  8004a2:	e03e                	sd	a5,0(sp)
  8004a4:	9902                	jalr	s2
                num = -(long long)num;
  8004a6:	6782                	ld	a5,0(sp)
  8004a8:	8a66                	mv	s4,s9
  8004aa:	40800633          	neg	a2,s0
  8004ae:	46a9                	li	a3,10
  8004b0:	b53d                	j	8002de <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
  8004b2:	03b05163          	blez	s11,8004d4 <vprintfmt+0x34c>
  8004b6:	02d00693          	li	a3,45
  8004ba:	f6d79de3          	bne	a5,a3,800434 <vprintfmt+0x2ac>
                p = "(null)";
  8004be:	00000417          	auipc	s0,0x0
  8004c2:	45a40413          	addi	s0,s0,1114 # 800918 <main+0x9a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004c6:	02800793          	li	a5,40
  8004ca:	02800513          	li	a0,40
  8004ce:	00140a13          	addi	s4,s0,1
  8004d2:	bd6d                	j	80038c <vprintfmt+0x204>
  8004d4:	00000a17          	auipc	s4,0x0
  8004d8:	445a0a13          	addi	s4,s4,1093 # 800919 <main+0x9b>
  8004dc:	02800513          	li	a0,40
  8004e0:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
  8004e4:	05e00413          	li	s0,94
  8004e8:	b565                	j	800390 <vprintfmt+0x208>

00000000008004ea <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004ea:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8004ec:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004f0:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004f2:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004f4:	ec06                	sd	ra,24(sp)
  8004f6:	f83a                	sd	a4,48(sp)
  8004f8:	fc3e                	sd	a5,56(sp)
  8004fa:	e0c2                	sd	a6,64(sp)
  8004fc:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8004fe:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800500:	c89ff0ef          	jal	ra,800188 <vprintfmt>
}
  800504:	60e2                	ld	ra,24(sp)
  800506:	6161                	addi	sp,sp,80
  800508:	8082                	ret

000000000080050a <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  80050a:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  80050c:	e589                	bnez	a1,800516 <strnlen+0xc>
  80050e:	a811                	j	800522 <strnlen+0x18>
        cnt ++;
  800510:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  800512:	00f58863          	beq	a1,a5,800522 <strnlen+0x18>
  800516:	00f50733          	add	a4,a0,a5
  80051a:	00074703          	lbu	a4,0(a4)
  80051e:	fb6d                	bnez	a4,800510 <strnlen+0x6>
  800520:	85be                	mv	a1,a5
    }
    return cnt;
}
  800522:	852e                	mv	a0,a1
  800524:	8082                	ret

0000000000800526 <test_vulnerable_cow_race>:
 * and shows how proper locking prevents it.
 */

// Simulate a vulnerable COW implementation (for demonstration)
void
test_vulnerable_cow_race(void) {
  800526:	1101                	addi	sp,sp,-32
    cprintf("=== Dirty COW Vulnerability Simulation ===\n");
  800528:	00000517          	auipc	a0,0x0
  80052c:	6f050513          	addi	a0,a0,1776 # 800c18 <error_string+0xc8>
test_vulnerable_cow_race(void) {
  800530:	ec06                	sd	ra,24(sp)
  800532:	e822                	sd	s0,16(sp)
  800534:	e426                	sd	s1,8(sp)
    cprintf("=== Dirty COW Vulnerability Simulation ===\n");
  800536:	b0bff0ef          	jal	ra,800040 <cprintf>
    cprintf("This demonstrates a race window in COW when fork marks pages writable\n");
  80053a:	00000517          	auipc	a0,0x0
  80053e:	70e50513          	addi	a0,a0,1806 # 800c48 <error_string+0xf8>
  800542:	affff0ef          	jal	ra,800040 <cprintf>
    cprintf("instead of RO+COW; write fault + madvise-like invalidation can race.\n\n");
  800546:	00000517          	auipc	a0,0x0
  80054a:	74a50513          	addi	a0,a0,1866 # 800c90 <error_string+0x140>
  80054e:	af3ff0ef          	jal	ra,800040 <cprintf>
    
    // Initialize as read-only data (simulating file content)
    for (int i = 0; i < PGSIZE; i++) {
  800552:	00003497          	auipc	s1,0x3
  800556:	aae48493          	addi	s1,s1,-1362 # 803000 <readonly_page>
        readonly_page[i] = 'R'; // 'R' for read-only
  80055a:	05200413          	li	s0,82
  80055e:	87a6                	mv	a5,s1
  800560:	00004717          	auipc	a4,0x4
  800564:	aa070713          	addi	a4,a4,-1376 # 804000 <shared_page>
  800568:	00878023          	sb	s0,0(a5)
    for (int i = 0; i < PGSIZE; i++) {
  80056c:	0785                	addi	a5,a5,1
  80056e:	fee79de3          	bne	a5,a4,800568 <test_vulnerable_cow_race+0x42>
    }
    cprintf("Simulated read-only file content initialized with 'R'\n");
  800572:	00000517          	auipc	a0,0x0
  800576:	76650513          	addi	a0,a0,1894 # 800cd8 <error_string+0x188>
  80057a:	ac7ff0ef          	jal	ra,800040 <cprintf>
    
    int pid = fork();
  80057e:	b85ff0ef          	jal	ra,800102 <fork>
    if (pid == 0) {
  800582:	cd39                	beqz	a0,8005e0 <test_vulnerable_cow_race+0xba>
        readonly_page[0] = 'W'; // If fork left it writable, this succeeds
        cprintf("Child: Value at position 0 observed as: %c\n", readonly_page[0]);
        exit(0);
    } else {
        // Parent process
        yield(); // let child race
  800584:	b87ff0ef          	jal	ra,80010a <yield>
        wait();
  800588:	b7dff0ef          	jal	ra,800104 <wait>
        cprintf("Parent: After child's attempt, value at position 0 is: %c\n",
  80058c:	0004c583          	lbu	a1,0(s1)
  800590:	00000517          	auipc	a0,0x0
  800594:	7f050513          	addi	a0,a0,2032 # 800d80 <error_string+0x230>
  800598:	aa9ff0ef          	jal	ra,800040 <cprintf>
                readonly_page[0]);

        if (readonly_page[0] == 'R') {
  80059c:	0004c783          	lbu	a5,0(s1)
  8005a0:	02878163          	beq	a5,s0,8005c2 <test_vulnerable_cow_race+0x9c>
            cprintf("SECURE (expected if kernel fixed Dirty COW): page stayed RO\n");
        } else {
            cprintf("VULNERABLE: child dirtied a read-only mapping via race!\n");
  8005a4:	00001517          	auipc	a0,0x1
  8005a8:	85c50513          	addi	a0,a0,-1956 # 800e00 <error_string+0x2b0>
  8005ac:	a95ff0ef          	jal	ra,800040 <cprintf>
        }
    }
    cprintf("\n");
}
  8005b0:	6442                	ld	s0,16(sp)
  8005b2:	60e2                	ld	ra,24(sp)
  8005b4:	64a2                	ld	s1,8(sp)
    cprintf("\n");
  8005b6:	00001517          	auipc	a0,0x1
  8005ba:	91a50513          	addi	a0,a0,-1766 # 800ed0 <error_string+0x380>
}
  8005be:	6105                	addi	sp,sp,32
    cprintf("\n");
  8005c0:	b441                	j	800040 <cprintf>
            cprintf("SECURE (expected if kernel fixed Dirty COW): page stayed RO\n");
  8005c2:	00000517          	auipc	a0,0x0
  8005c6:	7fe50513          	addi	a0,a0,2046 # 800dc0 <error_string+0x270>
  8005ca:	a77ff0ef          	jal	ra,800040 <cprintf>
}
  8005ce:	6442                	ld	s0,16(sp)
  8005d0:	60e2                	ld	ra,24(sp)
  8005d2:	64a2                	ld	s1,8(sp)
    cprintf("\n");
  8005d4:	00001517          	auipc	a0,0x1
  8005d8:	8fc50513          	addi	a0,a0,-1796 # 800ed0 <error_string+0x380>
}
  8005dc:	6105                	addi	sp,sp,32
    cprintf("\n");
  8005de:	b48d                	j	800040 <cprintf>
        cprintf("Child (attacker): Attempting to write to read-only page...\n");
  8005e0:	00000517          	auipc	a0,0x0
  8005e4:	73050513          	addi	a0,a0,1840 # 800d10 <error_string+0x1c0>
  8005e8:	a59ff0ef          	jal	ra,800040 <cprintf>
        readonly_page[0] = 'W'; // If fork left it writable, this succeeds
  8005ec:	05700793          	li	a5,87
        cprintf("Child: Value at position 0 observed as: %c\n", readonly_page[0]);
  8005f0:	05700593          	li	a1,87
  8005f4:	00000517          	auipc	a0,0x0
  8005f8:	75c50513          	addi	a0,a0,1884 # 800d50 <error_string+0x200>
        readonly_page[0] = 'W'; // If fork left it writable, this succeeds
  8005fc:	00f48023          	sb	a5,0(s1)
        cprintf("Child: Value at position 0 observed as: %c\n", readonly_page[0]);
  800600:	a41ff0ef          	jal	ra,800040 <cprintf>
        exit(0);
  800604:	4501                	li	a0,0
  800606:	ae7ff0ef          	jal	ra,8000ec <exit>

000000000080060a <test_secure_cow>:

// Demonstrate proper COW implementation with proper synchronization
void
test_secure_cow(void) {
  80060a:	1101                	addi	sp,sp,-32
    cprintf("=== Secure COW Implementation ===\n");
  80060c:	00001517          	auipc	a0,0x1
  800610:	83450513          	addi	a0,a0,-1996 # 800e40 <error_string+0x2f0>
test_secure_cow(void) {
  800614:	ec06                	sd	ra,24(sp)
  800616:	e822                	sd	s0,16(sp)
  800618:	e426                	sd	s1,8(sp)
    cprintf("=== Secure COW Implementation ===\n");
  80061a:	a27ff0ef          	jal	ra,800040 <cprintf>
    cprintf("Demonstrating COW with proper RO+COW fork, refcnt, and PTE updates\n\n");
  80061e:	00001517          	auipc	a0,0x1
  800622:	84a50513          	addi	a0,a0,-1974 # 800e68 <error_string+0x318>
  800626:	a1bff0ef          	jal	ra,800040 <cprintf>
    
    // Initialize shared page
    for (int i = 0; i < PGSIZE; i++) {
  80062a:	00004417          	auipc	s0,0x4
  80062e:	9d640413          	addi	s0,s0,-1578 # 804000 <shared_page>
  800632:	87a2                	mv	a5,s0
  800634:	00005697          	auipc	a3,0x5
  800638:	9cc68693          	addi	a3,a3,-1588 # 805000 <shared_page+0x1000>
        shared_page[i] = 'S'; // 'S' for shared
  80063c:	05300713          	li	a4,83
  800640:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++) {
  800644:	0785                	addi	a5,a5,1
  800646:	fed79de3          	bne	a5,a3,800640 <test_secure_cow+0x36>
    }
    cprintf("Shared page initialized with 'S'\n");
  80064a:	00001517          	auipc	a0,0x1
  80064e:	86650513          	addi	a0,a0,-1946 # 800eb0 <error_string+0x360>
  800652:	9efff0ef          	jal	ra,800040 <cprintf>
    
    int pid = fork();
  800656:	aadff0ef          	jal	ra,800102 <fork>
    if (pid == 0) {
  80065a:	c92d                	beqz	a0,8006cc <test_secure_cow+0xc2>
        shared_page[0] = 'C'; // 'C' for child
        cprintf("Child: Modified page, value at position 0: %c\n", shared_page[0]);
        exit(0);
    } else {
        // Parent: also modify the page (should trigger its own COW)
        yield();
  80065c:	aafff0ef          	jal	ra,80010a <yield>
        cprintf("Parent: Modifying shared page (should trigger COW)...\n");
  800660:	00001517          	auipc	a0,0x1
  800664:	8e050513          	addi	a0,a0,-1824 # 800f40 <error_string+0x3f0>
  800668:	9d9ff0ef          	jal	ra,800040 <cprintf>
        shared_page[0] = 'P'; // 'P' for parent
        cprintf("Parent: Modified page, value at position 0: %c\n", shared_page[0]);
  80066c:	05000593          	li	a1,80
        shared_page[0] = 'P'; // 'P' for parent
  800670:	05000493          	li	s1,80
        cprintf("Parent: Modified page, value at position 0: %c\n", shared_page[0]);
  800674:	00001517          	auipc	a0,0x1
  800678:	90450513          	addi	a0,a0,-1788 # 800f78 <error_string+0x428>
        shared_page[0] = 'P'; // 'P' for parent
  80067c:	00940023          	sb	s1,0(s0)
        cprintf("Parent: Modified page, value at position 0: %c\n", shared_page[0]);
  800680:	9c1ff0ef          	jal	ra,800040 <cprintf>
        
        wait();
  800684:	a81ff0ef          	jal	ra,800104 <wait>
        
        // Both should have their own copies
        if (shared_page[0] == 'P') {
  800688:	00044783          	lbu	a5,0(s0)
  80068c:	02978163          	beq	a5,s1,8006ae <test_secure_cow+0xa4>
            cprintf("SECURE: Parent has independent copy (COW worked correctly)\n");
        } else {
            cprintf("ERROR: Parent's page was modified by child!\n");
  800690:	00001517          	auipc	a0,0x1
  800694:	95850513          	addi	a0,a0,-1704 # 800fe8 <error_string+0x498>
  800698:	9a9ff0ef          	jal	ra,800040 <cprintf>
        }
    }
    cprintf("\n");
}
  80069c:	6442                	ld	s0,16(sp)
  80069e:	60e2                	ld	ra,24(sp)
  8006a0:	64a2                	ld	s1,8(sp)
    cprintf("\n");
  8006a2:	00001517          	auipc	a0,0x1
  8006a6:	82e50513          	addi	a0,a0,-2002 # 800ed0 <error_string+0x380>
}
  8006aa:	6105                	addi	sp,sp,32
    cprintf("\n");
  8006ac:	ba51                	j	800040 <cprintf>
            cprintf("SECURE: Parent has independent copy (COW worked correctly)\n");
  8006ae:	00001517          	auipc	a0,0x1
  8006b2:	8fa50513          	addi	a0,a0,-1798 # 800fa8 <error_string+0x458>
  8006b6:	98bff0ef          	jal	ra,800040 <cprintf>
}
  8006ba:	6442                	ld	s0,16(sp)
  8006bc:	60e2                	ld	ra,24(sp)
  8006be:	64a2                	ld	s1,8(sp)
    cprintf("\n");
  8006c0:	00001517          	auipc	a0,0x1
  8006c4:	81050513          	addi	a0,a0,-2032 # 800ed0 <error_string+0x380>
}
  8006c8:	6105                	addi	sp,sp,32
    cprintf("\n");
  8006ca:	ba9d                	j	800040 <cprintf>
        cprintf("Child: Modifying shared page (should trigger COW)...\n");
  8006cc:	00001517          	auipc	a0,0x1
  8006d0:	80c50513          	addi	a0,a0,-2036 # 800ed8 <error_string+0x388>
  8006d4:	96dff0ef          	jal	ra,800040 <cprintf>
        shared_page[0] = 'C'; // 'C' for child
  8006d8:	04300793          	li	a5,67
        cprintf("Child: Modified page, value at position 0: %c\n", shared_page[0]);
  8006dc:	04300593          	li	a1,67
  8006e0:	00001517          	auipc	a0,0x1
  8006e4:	83050513          	addi	a0,a0,-2000 # 800f10 <error_string+0x3c0>
        shared_page[0] = 'C'; // 'C' for child
  8006e8:	00f40023          	sb	a5,0(s0)
        cprintf("Child: Modified page, value at position 0: %c\n", shared_page[0]);
  8006ec:	955ff0ef          	jal	ra,800040 <cprintf>
        exit(0);
  8006f0:	4501                	li	a0,0
  8006f2:	9fbff0ef          	jal	ra,8000ec <exit>

00000000008006f6 <test_dirtycow_syscall_race>:

// Simulate Dirty COW style race using the new madvise_dontneed syscall
void
test_dirtycow_syscall_race(void) {
  8006f6:	7139                	addi	sp,sp,-64
    cprintf("=== Dirty COW syscall race (madvise_dontneed) ===\n");
  8006f8:	00001517          	auipc	a0,0x1
  8006fc:	92050513          	addi	a0,a0,-1760 # 801018 <error_string+0x4c8>
test_dirtycow_syscall_race(void) {
  800700:	fc06                	sd	ra,56(sp)
  800702:	f822                	sd	s0,48(sp)
  800704:	f426                	sd	s1,40(sp)
  800706:	f04a                	sd	s2,32(sp)
  800708:	ec4e                	sd	s3,24(sp)
  80070a:	e852                	sd	s4,16(sp)
    cprintf("=== Dirty COW syscall race (madvise_dontneed) ===\n");
  80070c:	935ff0ef          	jal	ra,800040 <cprintf>
    // request backing page; addr=0 lets kernel choose a fresh VMA
    cprintf("cow_page(bss)=%p aligned=%d\n", cow_page, ((uintptr_t)cow_page % PGSIZE) == 0);
  800710:	00002597          	auipc	a1,0x2
  800714:	8f058593          	addi	a1,a1,-1808 # 802000 <cow_page>
  800718:	4605                	li	a2,1
  80071a:	00001517          	auipc	a0,0x1
  80071e:	93650513          	addi	a0,a0,-1738 # 801050 <error_string+0x500>
  800722:	91fff0ef          	jal	ra,800040 <cprintf>
    // 一次申请 2 页：第 1 页用于写，第 2 页作为“别名”观测 backing page
    void *base = map_backing(NULL, 2 * PGSIZE);
  800726:	6589                	lui	a1,0x2
  800728:	4501                	li	a0,0
  80072a:	9e5ff0ef          	jal	ra,80010e <map_backing>
    void *back_rw = base;
    void *back_alias = (base == NULL) ? NULL : (void *)((char *)base + PGSIZE);
  80072e:	c921                	beqz	a0,80077e <test_dirtycow_syscall_race+0x88>
  800730:	6905                	lui	s2,0x1
  800732:	992a                	add	s2,s2,a0
    cprintf("map_backing base=%p rw=%p alias=%p\n", base, back_rw, back_alias);
  800734:	862a                	mv	a2,a0
  800736:	85aa                	mv	a1,a0
  800738:	86ca                	mv	a3,s2
  80073a:	84aa                	mv	s1,a0
  80073c:	00001517          	auipc	a0,0x1
  800740:	93450513          	addi	a0,a0,-1740 # 801070 <error_string+0x520>
  800744:	8fdff0ef          	jal	ra,800040 <cprintf>
    if (base == NULL || back_alias == NULL) {
        cprintf("map_backing failed, aborting dirtycow race test\n");
        return;
    }

    int pid = fork();
  800748:	9bbff0ef          	jal	ra,800102 <fork>
    }

    // Parent: repeatedly unmap the writable page to race with child's COW，
    // 然后在漏洞态通过 alias 观察 backing page 是否被写脏
    int corrupted = 0;
    for (int i = 0; i < RACE_ROUNDS; i++) {
  80074c:	4401                	li	s0,0
    if (pid == 0) {
  80074e:	c941                	beqz	a0,8007de <test_dirtycow_syscall_race+0xe8>
    for (int i = 0; i < RACE_ROUNDS; i++) {
  800750:	6995                	lui	s3,0x5
        madvise_dontneed(back_rw, PGSIZE);
        // 在漏洞态下：Touch alias to fault back in；若 alias 不再是初始 'P'，说明 backing 被写穿
#if !DIRTYCOW_FIXED
        if (((char *)back_alias)[0] != 'P') {
  800752:	05000a13          	li	s4,80
    for (int i = 0; i < RACE_ROUNDS; i++) {
  800756:	e2098993          	addi	s3,s3,-480 # 4e20 <_start-0x7fb200>
  80075a:	a021                	j	800762 <test_dirtycow_syscall_race+0x6c>
  80075c:	2405                	addiw	s0,s0,1
  80075e:	05340663          	beq	s0,s3,8007aa <test_dirtycow_syscall_race+0xb4>
        madvise_dontneed(back_rw, PGSIZE);
  800762:	6585                	lui	a1,0x1
  800764:	8526                	mv	a0,s1
  800766:	9a7ff0ef          	jal	ra,80010c <madvise_dontneed>
        if (((char *)back_alias)[0] != 'P') {
  80076a:	00094783          	lbu	a5,0(s2) # 1000 <_start-0x7ff020>
  80076e:	05479b63          	bne	a5,s4,8007c4 <test_dirtycow_syscall_race+0xce>
            corrupted = 1;
            break;
        }
#endif
        if ((i & 0x3FF) == 0) {
  800772:	3ff47793          	andi	a5,s0,1023
  800776:	f3fd                	bnez	a5,80075c <test_dirtycow_syscall_race+0x66>
            yield();
  800778:	993ff0ef          	jal	ra,80010a <yield>
  80077c:	b7c5                	j	80075c <test_dirtycow_syscall_race+0x66>
    cprintf("map_backing base=%p rw=%p alias=%p\n", base, back_rw, back_alias);
  80077e:	4681                	li	a3,0
  800780:	4601                	li	a2,0
  800782:	4581                	li	a1,0
  800784:	00001517          	auipc	a0,0x1
  800788:	8ec50513          	addi	a0,a0,-1812 # 801070 <error_string+0x520>
  80078c:	8b5ff0ef          	jal	ra,800040 <cprintf>
        cprintf("map_backing failed, aborting dirtycow race test\n");
  800790:	00001517          	auipc	a0,0x1
  800794:	90850513          	addi	a0,a0,-1784 # 801098 <error_string+0x548>
    } else {
        cprintf("No corruption observed in this run; try increasing RACE_ROUNDS.\n");
    }
#endif
    cprintf("\n");
}
  800798:	7442                	ld	s0,48(sp)
  80079a:	70e2                	ld	ra,56(sp)
  80079c:	74a2                	ld	s1,40(sp)
  80079e:	7902                	ld	s2,32(sp)
  8007a0:	69e2                	ld	s3,24(sp)
  8007a2:	6a42                	ld	s4,16(sp)
  8007a4:	6121                	addi	sp,sp,64
    cprintf("\n");
  8007a6:	89bff06f          	j	800040 <cprintf>
    wait();
  8007aa:	95bff0ef          	jal	ra,800104 <wait>
        cprintf("No corruption observed in this run; try increasing RACE_ROUNDS.\n");
  8007ae:	00001517          	auipc	a0,0x1
  8007b2:	96250513          	addi	a0,a0,-1694 # 801110 <error_string+0x5c0>
  8007b6:	88bff0ef          	jal	ra,800040 <cprintf>
    cprintf("\n");
  8007ba:	00000517          	auipc	a0,0x0
  8007be:	71650513          	addi	a0,a0,1814 # 800ed0 <error_string+0x380>
  8007c2:	bfd9                	j	800798 <test_dirtycow_syscall_race+0xa2>
    wait();
  8007c4:	941ff0ef          	jal	ra,800104 <wait>
        cprintf("VULNERABLE: parent observed child data via COW+madvise race!\n");
  8007c8:	00001517          	auipc	a0,0x1
  8007cc:	90850513          	addi	a0,a0,-1784 # 8010d0 <error_string+0x580>
  8007d0:	871ff0ef          	jal	ra,800040 <cprintf>
    cprintf("\n");
  8007d4:	00000517          	auipc	a0,0x0
  8007d8:	6fc50513          	addi	a0,a0,1788 # 800ed0 <error_string+0x380>
  8007dc:	bf75                	j	800798 <test_dirtycow_syscall_race+0xa2>
        for (int i = 0; i < RACE_ROUNDS; i++) {
  8007de:	6415                	lui	s0,0x5
            ((char *)back_rw)[0] = 'C';
  8007e0:	04300913          	li	s2,67
        for (int i = 0; i < RACE_ROUNDS; i++) {
  8007e4:	e2040413          	addi	s0,s0,-480 # 4e20 <_start-0x7fb200>
  8007e8:	a021                	j	8007f0 <test_dirtycow_syscall_race+0xfa>
  8007ea:	2505                	addiw	a0,a0,1
  8007ec:	00850c63          	beq	a0,s0,800804 <test_dirtycow_syscall_race+0x10e>
            ((char *)back_rw)[0] = 'C';
  8007f0:	01248023          	sb	s2,0(s1)
            if ((i & 0x3FF) == 0) {
  8007f4:	3ff57793          	andi	a5,a0,1023
  8007f8:	fbed                	bnez	a5,8007ea <test_dirtycow_syscall_race+0xf4>
  8007fa:	e42a                	sd	a0,8(sp)
                yield();
  8007fc:	90fff0ef          	jal	ra,80010a <yield>
  800800:	6522                	ld	a0,8(sp)
  800802:	b7e5                	j	8007ea <test_dirtycow_syscall_race+0xf4>
        exit(0);
  800804:	4501                	li	a0,0
  800806:	8e7ff0ef          	jal	ra,8000ec <exit>

000000000080080a <explain_dirtycow_fix>:

// Explain the fix
void
explain_dirtycow_fix(void) {
  80080a:	1141                	addi	sp,sp,-16
    cprintf("=== Dirty COW Fix Explanation ===\n");
  80080c:	00001517          	auipc	a0,0x1
  800810:	94c50513          	addi	a0,a0,-1716 # 801158 <error_string+0x608>
explain_dirtycow_fix(void) {
  800814:	e406                	sd	ra,8(sp)
    cprintf("=== Dirty COW Fix Explanation ===\n");
  800816:	82bff0ef          	jal	ra,800040 <cprintf>
    cprintf("Key points to prevent Dirty COW:\n");
  80081a:	00001517          	auipc	a0,0x1
  80081e:	96650513          	addi	a0,a0,-1690 # 801180 <error_string+0x630>
  800822:	81fff0ef          	jal	ra,800040 <cprintf>
    cprintf("- At fork: writable mappings become RO + PTE_COW; pure RO stays RO only.\n");
  800826:	00001517          	auipc	a0,0x1
  80082a:	98250513          	addi	a0,a0,-1662 # 8011a8 <error_string+0x658>
  80082e:	813ff0ef          	jal	ra,800040 <cprintf>
    cprintf("- Write fault path: only handle COW when (error_code & 0x2) != 0.\n");
  800832:	00001517          	auipc	a0,0x1
  800836:	9c650513          	addi	a0,a0,-1594 # 8011f8 <error_string+0x6a8>
  80083a:	807ff0ef          	jal	ra,800040 <cprintf>
    cprintf("- Allocate a new page, copy, then page_insert to flip PTE to writable\n");
  80083e:	00001517          	auipc	a0,0x1
  800842:	a0250513          	addi	a0,a0,-1534 # 801240 <error_string+0x6f0>
  800846:	ffaff0ef          	jal	ra,800040 <cprintf>
    cprintf("  and finally sfence.vma to keep TLB in sync.\n");
  80084a:	00001517          	auipc	a0,0x1
  80084e:	a3e50513          	addi	a0,a0,-1474 # 801288 <error_string+0x738>
  800852:	feeff0ef          	jal	ra,800040 <cprintf>
    cprintf("- Refcount: increment when sharing; page_insert will drop old mapping\n");
  800856:	00001517          	auipc	a0,0x1
  80085a:	a6250513          	addi	a0,a0,-1438 # 8012b8 <error_string+0x768>
  80085e:	fe2ff0ef          	jal	ra,800040 <cprintf>
    cprintf("  so pages aren't freed prematurely.\n");
  800862:	00001517          	auipc	a0,0x1
  800866:	a9e50513          	addi	a0,a0,-1378 # 801300 <error_string+0x7b0>
  80086a:	fd6ff0ef          	jal	ra,800040 <cprintf>
    cprintf("\n");
}
  80086e:	60a2                	ld	ra,8(sp)
    cprintf("\n");
  800870:	00000517          	auipc	a0,0x0
  800874:	66050513          	addi	a0,a0,1632 # 800ed0 <error_string+0x380>
}
  800878:	0141                	addi	sp,sp,16
    cprintf("\n");
  80087a:	fc6ff06f          	j	800040 <cprintf>

000000000080087e <main>:

int
main(void) {
  80087e:	1141                	addi	sp,sp,-16
    cprintf("========================================\n");
  800880:	00001517          	auipc	a0,0x1
  800884:	aa850513          	addi	a0,a0,-1368 # 801328 <error_string+0x7d8>
main(void) {
  800888:	e406                	sd	ra,8(sp)
    cprintf("========================================\n");
  80088a:	fb6ff0ef          	jal	ra,800040 <cprintf>
    cprintf("Dirty COW Vulnerability Demo and Fix\n");
  80088e:	00001517          	auipc	a0,0x1
  800892:	aca50513          	addi	a0,a0,-1334 # 801358 <error_string+0x808>
  800896:	faaff0ef          	jal	ra,800040 <cprintf>
    cprintf("========================================\n\n");
  80089a:	00001517          	auipc	a0,0x1
  80089e:	ae650513          	addi	a0,a0,-1306 # 801380 <error_string+0x830>
  8008a2:	f9eff0ef          	jal	ra,800040 <cprintf>
    
    test_vulnerable_cow_race();
  8008a6:	c81ff0ef          	jal	ra,800526 <test_vulnerable_cow_race>
    test_secure_cow();
  8008aa:	d61ff0ef          	jal	ra,80060a <test_secure_cow>
    test_dirtycow_syscall_race();
  8008ae:	e49ff0ef          	jal	ra,8006f6 <test_dirtycow_syscall_race>
    explain_dirtycow_fix();
  8008b2:	f59ff0ef          	jal	ra,80080a <explain_dirtycow_fix>
    
    cprintf("========================================\n");
  8008b6:	00001517          	auipc	a0,0x1
  8008ba:	a7250513          	addi	a0,a0,-1422 # 801328 <error_string+0x7d8>
  8008be:	f82ff0ef          	jal	ra,800040 <cprintf>
    cprintf("Dirty COW Demo Complete\n");
  8008c2:	00001517          	auipc	a0,0x1
  8008c6:	aee50513          	addi	a0,a0,-1298 # 8013b0 <error_string+0x860>
  8008ca:	f76ff0ef          	jal	ra,800040 <cprintf>
    cprintf("========================================\n");
  8008ce:	00001517          	auipc	a0,0x1
  8008d2:	a5a50513          	addi	a0,a0,-1446 # 801328 <error_string+0x7d8>
  8008d6:	f6aff0ef          	jal	ra,800040 <cprintf>
    return 0;
}
  8008da:	60a2                	ld	ra,8(sp)
  8008dc:	4501                	li	a0,0
  8008de:	0141                	addi	sp,sp,16
  8008e0:	8082                	ret
