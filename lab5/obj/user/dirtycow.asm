
obj/__user_dirtycow.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
.text
.globl _start
_start:
    # call user-program function
    call umain
  800020:	0cc000ef          	jal	ra,8000ec <umain>
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
  80006a:	0fa000ef          	jal	ra,800164 <vprintfmt>
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

00000000008000cc <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000cc:	1141                	addi	sp,sp,-16
  8000ce:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000d0:	fe1ff0ef          	jal	ra,8000b0 <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000d4:	00000517          	auipc	a0,0x0
  8000d8:	6d450513          	addi	a0,a0,1748 # 8007a8 <main+0x64>
  8000dc:	f65ff0ef          	jal	ra,800040 <cprintf>
    while (1);
  8000e0:	a001                	j	8000e0 <exit+0x14>

00000000008000e2 <fork>:
}

int
fork(void) {
    return sys_fork();
  8000e2:	bfd1                	j	8000b6 <sys_fork>

00000000008000e4 <wait>:
}

int
wait(void) {
    return sys_wait(0, NULL);
  8000e4:	4581                	li	a1,0
  8000e6:	4501                	li	a0,0
  8000e8:	bfc9                	j	8000ba <sys_wait>

00000000008000ea <yield>:
    return sys_wait(pid, store);
}

void
yield(void) {
    sys_yield();
  8000ea:	bfe1                	j	8000c2 <sys_yield>

00000000008000ec <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8000ec:	1141                	addi	sp,sp,-16
  8000ee:	e406                	sd	ra,8(sp)
    int ret = main();
  8000f0:	654000ef          	jal	ra,800744 <main>
    exit(ret);
  8000f4:	fd9ff0ef          	jal	ra,8000cc <exit>

00000000008000f8 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  8000f8:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000fc:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
  8000fe:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800102:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  800104:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800108:	f022                	sd	s0,32(sp)
  80010a:	ec26                	sd	s1,24(sp)
  80010c:	e84a                	sd	s2,16(sp)
  80010e:	f406                	sd	ra,40(sp)
  800110:	e44e                	sd	s3,8(sp)
  800112:	84aa                	mv	s1,a0
  800114:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800116:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
  80011a:	2a01                	sext.w	s4,s4
    if (num >= base) {
  80011c:	03067e63          	bgeu	a2,a6,800158 <printnum+0x60>
  800120:	89be                	mv	s3,a5
        while (-- width > 0)
  800122:	00805763          	blez	s0,800130 <printnum+0x38>
  800126:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800128:	85ca                	mv	a1,s2
  80012a:	854e                	mv	a0,s3
  80012c:	9482                	jalr	s1
        while (-- width > 0)
  80012e:	fc65                	bnez	s0,800126 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  800130:	1a02                	slli	s4,s4,0x20
  800132:	00000797          	auipc	a5,0x0
  800136:	68e78793          	addi	a5,a5,1678 # 8007c0 <main+0x7c>
  80013a:	020a5a13          	srli	s4,s4,0x20
  80013e:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  800140:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  800142:	000a4503          	lbu	a0,0(s4)
}
  800146:	70a2                	ld	ra,40(sp)
  800148:	69a2                	ld	s3,8(sp)
  80014a:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  80014c:	85ca                	mv	a1,s2
  80014e:	87a6                	mv	a5,s1
}
  800150:	6942                	ld	s2,16(sp)
  800152:	64e2                	ld	s1,24(sp)
  800154:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  800156:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  800158:	03065633          	divu	a2,a2,a6
  80015c:	8722                	mv	a4,s0
  80015e:	f9bff0ef          	jal	ra,8000f8 <printnum>
  800162:	b7f9                	j	800130 <printnum+0x38>

0000000000800164 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  800164:	7119                	addi	sp,sp,-128
  800166:	f4a6                	sd	s1,104(sp)
  800168:	f0ca                	sd	s2,96(sp)
  80016a:	ecce                	sd	s3,88(sp)
  80016c:	e8d2                	sd	s4,80(sp)
  80016e:	e4d6                	sd	s5,72(sp)
  800170:	e0da                	sd	s6,64(sp)
  800172:	fc5e                	sd	s7,56(sp)
  800174:	f06a                	sd	s10,32(sp)
  800176:	fc86                	sd	ra,120(sp)
  800178:	f8a2                	sd	s0,112(sp)
  80017a:	f862                	sd	s8,48(sp)
  80017c:	f466                	sd	s9,40(sp)
  80017e:	ec6e                	sd	s11,24(sp)
  800180:	892a                	mv	s2,a0
  800182:	84ae                	mv	s1,a1
  800184:	8d32                	mv	s10,a2
  800186:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800188:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  80018c:	5b7d                	li	s6,-1
  80018e:	00000a97          	auipc	s5,0x0
  800192:	666a8a93          	addi	s5,s5,1638 # 8007f4 <main+0xb0>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800196:	00001b97          	auipc	s7,0x1
  80019a:	87ab8b93          	addi	s7,s7,-1926 # 800a10 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80019e:	000d4503          	lbu	a0,0(s10)
  8001a2:	001d0413          	addi	s0,s10,1
  8001a6:	01350a63          	beq	a0,s3,8001ba <vprintfmt+0x56>
            if (ch == '\0') {
  8001aa:	c121                	beqz	a0,8001ea <vprintfmt+0x86>
            putch(ch, putdat);
  8001ac:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001ae:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  8001b0:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001b2:	fff44503          	lbu	a0,-1(s0)
  8001b6:	ff351ae3          	bne	a0,s3,8001aa <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
  8001ba:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
  8001be:	02000793          	li	a5,32
        lflag = altflag = 0;
  8001c2:	4c81                	li	s9,0
  8001c4:	4881                	li	a7,0
        width = precision = -1;
  8001c6:	5c7d                	li	s8,-1
  8001c8:	5dfd                	li	s11,-1
  8001ca:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
  8001ce:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
  8001d0:	fdd6059b          	addiw	a1,a2,-35
  8001d4:	0ff5f593          	zext.b	a1,a1
  8001d8:	00140d13          	addi	s10,s0,1
  8001dc:	04b56263          	bltu	a0,a1,800220 <vprintfmt+0xbc>
  8001e0:	058a                	slli	a1,a1,0x2
  8001e2:	95d6                	add	a1,a1,s5
  8001e4:	4194                	lw	a3,0(a1)
  8001e6:	96d6                	add	a3,a3,s5
  8001e8:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8001ea:	70e6                	ld	ra,120(sp)
  8001ec:	7446                	ld	s0,112(sp)
  8001ee:	74a6                	ld	s1,104(sp)
  8001f0:	7906                	ld	s2,96(sp)
  8001f2:	69e6                	ld	s3,88(sp)
  8001f4:	6a46                	ld	s4,80(sp)
  8001f6:	6aa6                	ld	s5,72(sp)
  8001f8:	6b06                	ld	s6,64(sp)
  8001fa:	7be2                	ld	s7,56(sp)
  8001fc:	7c42                	ld	s8,48(sp)
  8001fe:	7ca2                	ld	s9,40(sp)
  800200:	7d02                	ld	s10,32(sp)
  800202:	6de2                	ld	s11,24(sp)
  800204:	6109                	addi	sp,sp,128
  800206:	8082                	ret
            padc = '0';
  800208:	87b2                	mv	a5,a2
            goto reswitch;
  80020a:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80020e:	846a                	mv	s0,s10
  800210:	00140d13          	addi	s10,s0,1
  800214:	fdd6059b          	addiw	a1,a2,-35
  800218:	0ff5f593          	zext.b	a1,a1
  80021c:	fcb572e3          	bgeu	a0,a1,8001e0 <vprintfmt+0x7c>
            putch('%', putdat);
  800220:	85a6                	mv	a1,s1
  800222:	02500513          	li	a0,37
  800226:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800228:	fff44783          	lbu	a5,-1(s0)
  80022c:	8d22                	mv	s10,s0
  80022e:	f73788e3          	beq	a5,s3,80019e <vprintfmt+0x3a>
  800232:	ffed4783          	lbu	a5,-2(s10)
  800236:	1d7d                	addi	s10,s10,-1
  800238:	ff379de3          	bne	a5,s3,800232 <vprintfmt+0xce>
  80023c:	b78d                	j	80019e <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  80023e:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
  800242:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800246:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
  800248:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
  80024c:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  800250:	02d86463          	bltu	a6,a3,800278 <vprintfmt+0x114>
                ch = *fmt;
  800254:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
  800258:	002c169b          	slliw	a3,s8,0x2
  80025c:	0186873b          	addw	a4,a3,s8
  800260:	0017171b          	slliw	a4,a4,0x1
  800264:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
  800266:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
  80026a:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  80026c:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  800270:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  800274:	fed870e3          	bgeu	a6,a3,800254 <vprintfmt+0xf0>
            if (width < 0)
  800278:	f40ddce3          	bgez	s11,8001d0 <vprintfmt+0x6c>
                width = precision, precision = -1;
  80027c:	8de2                	mv	s11,s8
  80027e:	5c7d                	li	s8,-1
  800280:	bf81                	j	8001d0 <vprintfmt+0x6c>
            if (width < 0)
  800282:	fffdc693          	not	a3,s11
  800286:	96fd                	srai	a3,a3,0x3f
  800288:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
  80028c:	00144603          	lbu	a2,1(s0)
  800290:	2d81                	sext.w	s11,s11
  800292:	846a                	mv	s0,s10
            goto reswitch;
  800294:	bf35                	j	8001d0 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  800296:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  80029a:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
  80029e:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  8002a0:	846a                	mv	s0,s10
            goto process_precision;
  8002a2:	bfd9                	j	800278 <vprintfmt+0x114>
    if (lflag >= 2) {
  8002a4:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8002a6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002aa:	01174463          	blt	a4,a7,8002b2 <vprintfmt+0x14e>
    else if (lflag) {
  8002ae:	1a088e63          	beqz	a7,80046a <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
  8002b2:	000a3603          	ld	a2,0(s4)
  8002b6:	46c1                	li	a3,16
  8002b8:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
  8002ba:	2781                	sext.w	a5,a5
  8002bc:	876e                	mv	a4,s11
  8002be:	85a6                	mv	a1,s1
  8002c0:	854a                	mv	a0,s2
  8002c2:	e37ff0ef          	jal	ra,8000f8 <printnum>
            break;
  8002c6:	bde1                	j	80019e <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8002c8:	000a2503          	lw	a0,0(s4)
  8002cc:	85a6                	mv	a1,s1
  8002ce:	0a21                	addi	s4,s4,8
  8002d0:	9902                	jalr	s2
            break;
  8002d2:	b5f1                	j	80019e <vprintfmt+0x3a>
    if (lflag >= 2) {
  8002d4:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8002d6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002da:	01174463          	blt	a4,a7,8002e2 <vprintfmt+0x17e>
    else if (lflag) {
  8002de:	18088163          	beqz	a7,800460 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
  8002e2:	000a3603          	ld	a2,0(s4)
  8002e6:	46a9                	li	a3,10
  8002e8:	8a2e                	mv	s4,a1
  8002ea:	bfc1                	j	8002ba <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
  8002ec:	00144603          	lbu	a2,1(s0)
            altflag = 1;
  8002f0:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
  8002f2:	846a                	mv	s0,s10
            goto reswitch;
  8002f4:	bdf1                	j	8001d0 <vprintfmt+0x6c>
            putch(ch, putdat);
  8002f6:	85a6                	mv	a1,s1
  8002f8:	02500513          	li	a0,37
  8002fc:	9902                	jalr	s2
            break;
  8002fe:	b545                	j	80019e <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  800300:	00144603          	lbu	a2,1(s0)
            lflag ++;
  800304:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
  800306:	846a                	mv	s0,s10
            goto reswitch;
  800308:	b5e1                	j	8001d0 <vprintfmt+0x6c>
    if (lflag >= 2) {
  80030a:	4705                	li	a4,1
            precision = va_arg(ap, int);
  80030c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800310:	01174463          	blt	a4,a7,800318 <vprintfmt+0x1b4>
    else if (lflag) {
  800314:	14088163          	beqz	a7,800456 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
  800318:	000a3603          	ld	a2,0(s4)
  80031c:	46a1                	li	a3,8
  80031e:	8a2e                	mv	s4,a1
  800320:	bf69                	j	8002ba <vprintfmt+0x156>
            putch('0', putdat);
  800322:	03000513          	li	a0,48
  800326:	85a6                	mv	a1,s1
  800328:	e03e                	sd	a5,0(sp)
  80032a:	9902                	jalr	s2
            putch('x', putdat);
  80032c:	85a6                	mv	a1,s1
  80032e:	07800513          	li	a0,120
  800332:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800334:	0a21                	addi	s4,s4,8
            goto number;
  800336:	6782                	ld	a5,0(sp)
  800338:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80033a:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  80033e:	bfb5                	j	8002ba <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
  800340:	000a3403          	ld	s0,0(s4)
  800344:	008a0713          	addi	a4,s4,8
  800348:	e03a                	sd	a4,0(sp)
  80034a:	14040263          	beqz	s0,80048e <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
  80034e:	0fb05763          	blez	s11,80043c <vprintfmt+0x2d8>
  800352:	02d00693          	li	a3,45
  800356:	0cd79163          	bne	a5,a3,800418 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80035a:	00044783          	lbu	a5,0(s0)
  80035e:	0007851b          	sext.w	a0,a5
  800362:	cf85                	beqz	a5,80039a <vprintfmt+0x236>
  800364:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
  800368:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80036c:	000c4563          	bltz	s8,800376 <vprintfmt+0x212>
  800370:	3c7d                	addiw	s8,s8,-1
  800372:	036c0263          	beq	s8,s6,800396 <vprintfmt+0x232>
                    putch('?', putdat);
  800376:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800378:	0e0c8e63          	beqz	s9,800474 <vprintfmt+0x310>
  80037c:	3781                	addiw	a5,a5,-32
  80037e:	0ef47b63          	bgeu	s0,a5,800474 <vprintfmt+0x310>
                    putch('?', putdat);
  800382:	03f00513          	li	a0,63
  800386:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800388:	000a4783          	lbu	a5,0(s4)
  80038c:	3dfd                	addiw	s11,s11,-1
  80038e:	0a05                	addi	s4,s4,1
  800390:	0007851b          	sext.w	a0,a5
  800394:	ffe1                	bnez	a5,80036c <vprintfmt+0x208>
            for (; width > 0; width --) {
  800396:	01b05963          	blez	s11,8003a8 <vprintfmt+0x244>
  80039a:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
  80039c:	85a6                	mv	a1,s1
  80039e:	02000513          	li	a0,32
  8003a2:	9902                	jalr	s2
            for (; width > 0; width --) {
  8003a4:	fe0d9be3          	bnez	s11,80039a <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
  8003a8:	6a02                	ld	s4,0(sp)
  8003aa:	bbd5                	j	80019e <vprintfmt+0x3a>
    if (lflag >= 2) {
  8003ac:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8003ae:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
  8003b2:	01174463          	blt	a4,a7,8003ba <vprintfmt+0x256>
    else if (lflag) {
  8003b6:	08088d63          	beqz	a7,800450 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
  8003ba:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  8003be:	0a044d63          	bltz	s0,800478 <vprintfmt+0x314>
            num = getint(&ap, lflag);
  8003c2:	8622                	mv	a2,s0
  8003c4:	8a66                	mv	s4,s9
  8003c6:	46a9                	li	a3,10
  8003c8:	bdcd                	j	8002ba <vprintfmt+0x156>
            err = va_arg(ap, int);
  8003ca:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003ce:	4761                	li	a4,24
            err = va_arg(ap, int);
  8003d0:	0a21                	addi	s4,s4,8
            if (err < 0) {
  8003d2:	41f7d69b          	sraiw	a3,a5,0x1f
  8003d6:	8fb5                	xor	a5,a5,a3
  8003d8:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003dc:	02d74163          	blt	a4,a3,8003fe <vprintfmt+0x29a>
  8003e0:	00369793          	slli	a5,a3,0x3
  8003e4:	97de                	add	a5,a5,s7
  8003e6:	639c                	ld	a5,0(a5)
  8003e8:	cb99                	beqz	a5,8003fe <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
  8003ea:	86be                	mv	a3,a5
  8003ec:	00000617          	auipc	a2,0x0
  8003f0:	40460613          	addi	a2,a2,1028 # 8007f0 <main+0xac>
  8003f4:	85a6                	mv	a1,s1
  8003f6:	854a                	mv	a0,s2
  8003f8:	0ce000ef          	jal	ra,8004c6 <printfmt>
  8003fc:	b34d                	j	80019e <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  8003fe:	00000617          	auipc	a2,0x0
  800402:	3e260613          	addi	a2,a2,994 # 8007e0 <main+0x9c>
  800406:	85a6                	mv	a1,s1
  800408:	854a                	mv	a0,s2
  80040a:	0bc000ef          	jal	ra,8004c6 <printfmt>
  80040e:	bb41                	j	80019e <vprintfmt+0x3a>
                p = "(null)";
  800410:	00000417          	auipc	s0,0x0
  800414:	3c840413          	addi	s0,s0,968 # 8007d8 <main+0x94>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800418:	85e2                	mv	a1,s8
  80041a:	8522                	mv	a0,s0
  80041c:	e43e                	sd	a5,8(sp)
  80041e:	0c8000ef          	jal	ra,8004e6 <strnlen>
  800422:	40ad8dbb          	subw	s11,s11,a0
  800426:	01b05b63          	blez	s11,80043c <vprintfmt+0x2d8>
                    putch(padc, putdat);
  80042a:	67a2                	ld	a5,8(sp)
  80042c:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
  800430:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
  800432:	85a6                	mv	a1,s1
  800434:	8552                	mv	a0,s4
  800436:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  800438:	fe0d9ce3          	bnez	s11,800430 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80043c:	00044783          	lbu	a5,0(s0)
  800440:	00140a13          	addi	s4,s0,1
  800444:	0007851b          	sext.w	a0,a5
  800448:	d3a5                	beqz	a5,8003a8 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
  80044a:	05e00413          	li	s0,94
  80044e:	bf39                	j	80036c <vprintfmt+0x208>
        return va_arg(*ap, int);
  800450:	000a2403          	lw	s0,0(s4)
  800454:	b7ad                	j	8003be <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
  800456:	000a6603          	lwu	a2,0(s4)
  80045a:	46a1                	li	a3,8
  80045c:	8a2e                	mv	s4,a1
  80045e:	bdb1                	j	8002ba <vprintfmt+0x156>
  800460:	000a6603          	lwu	a2,0(s4)
  800464:	46a9                	li	a3,10
  800466:	8a2e                	mv	s4,a1
  800468:	bd89                	j	8002ba <vprintfmt+0x156>
  80046a:	000a6603          	lwu	a2,0(s4)
  80046e:	46c1                	li	a3,16
  800470:	8a2e                	mv	s4,a1
  800472:	b5a1                	j	8002ba <vprintfmt+0x156>
                    putch(ch, putdat);
  800474:	9902                	jalr	s2
  800476:	bf09                	j	800388 <vprintfmt+0x224>
                putch('-', putdat);
  800478:	85a6                	mv	a1,s1
  80047a:	02d00513          	li	a0,45
  80047e:	e03e                	sd	a5,0(sp)
  800480:	9902                	jalr	s2
                num = -(long long)num;
  800482:	6782                	ld	a5,0(sp)
  800484:	8a66                	mv	s4,s9
  800486:	40800633          	neg	a2,s0
  80048a:	46a9                	li	a3,10
  80048c:	b53d                	j	8002ba <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
  80048e:	03b05163          	blez	s11,8004b0 <vprintfmt+0x34c>
  800492:	02d00693          	li	a3,45
  800496:	f6d79de3          	bne	a5,a3,800410 <vprintfmt+0x2ac>
                p = "(null)";
  80049a:	00000417          	auipc	s0,0x0
  80049e:	33e40413          	addi	s0,s0,830 # 8007d8 <main+0x94>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004a2:	02800793          	li	a5,40
  8004a6:	02800513          	li	a0,40
  8004aa:	00140a13          	addi	s4,s0,1
  8004ae:	bd6d                	j	800368 <vprintfmt+0x204>
  8004b0:	00000a17          	auipc	s4,0x0
  8004b4:	329a0a13          	addi	s4,s4,809 # 8007d9 <main+0x95>
  8004b8:	02800513          	li	a0,40
  8004bc:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
  8004c0:	05e00413          	li	s0,94
  8004c4:	b565                	j	80036c <vprintfmt+0x208>

00000000008004c6 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004c6:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8004c8:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004cc:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004ce:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004d0:	ec06                	sd	ra,24(sp)
  8004d2:	f83a                	sd	a4,48(sp)
  8004d4:	fc3e                	sd	a5,56(sp)
  8004d6:	e0c2                	sd	a6,64(sp)
  8004d8:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8004da:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004dc:	c89ff0ef          	jal	ra,800164 <vprintfmt>
}
  8004e0:	60e2                	ld	ra,24(sp)
  8004e2:	6161                	addi	sp,sp,80
  8004e4:	8082                	ret

00000000008004e6 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8004e6:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8004e8:	e589                	bnez	a1,8004f2 <strnlen+0xc>
  8004ea:	a811                	j	8004fe <strnlen+0x18>
        cnt ++;
  8004ec:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8004ee:	00f58863          	beq	a1,a5,8004fe <strnlen+0x18>
  8004f2:	00f50733          	add	a4,a0,a5
  8004f6:	00074703          	lbu	a4,0(a4)
  8004fa:	fb6d                	bnez	a4,8004ec <strnlen+0x6>
  8004fc:	85be                	mv	a1,a5
    }
    return cnt;
}
  8004fe:	852e                	mv	a0,a1
  800500:	8082                	ret

0000000000800502 <test_vulnerable_cow_race>:
 * and shows how proper locking prevents it.
 */

// Simulate a vulnerable COW implementation (for demonstration)
void
test_vulnerable_cow_race(void) {
  800502:	1101                	addi	sp,sp,-32
    cprintf("=== Dirty COW Vulnerability Simulation ===\n");
  800504:	00000517          	auipc	a0,0x0
  800508:	5d450513          	addi	a0,a0,1492 # 800ad8 <error_string+0xc8>
test_vulnerable_cow_race(void) {
  80050c:	ec06                	sd	ra,24(sp)
  80050e:	e822                	sd	s0,16(sp)
  800510:	e426                	sd	s1,8(sp)
    cprintf("=== Dirty COW Vulnerability Simulation ===\n");
  800512:	b2fff0ef          	jal	ra,800040 <cprintf>
    cprintf("This demonstrates a race window in COW when fork marks pages writable\n");
  800516:	00000517          	auipc	a0,0x0
  80051a:	5f250513          	addi	a0,a0,1522 # 800b08 <error_string+0xf8>
  80051e:	b23ff0ef          	jal	ra,800040 <cprintf>
    cprintf("instead of RO+COW; write fault + madvise-like invalidation can race.\n\n");
  800522:	00000517          	auipc	a0,0x0
  800526:	62e50513          	addi	a0,a0,1582 # 800b50 <error_string+0x140>
  80052a:	b17ff0ef          	jal	ra,800040 <cprintf>
    
    // Initialize as read-only data (simulating file content)
    for (int i = 0; i < PGSIZE; i++) {
  80052e:	00002497          	auipc	s1,0x2
  800532:	ad248493          	addi	s1,s1,-1326 # 802000 <readonly_page>
        readonly_page[i] = 'R'; // 'R' for read-only
  800536:	05200413          	li	s0,82
  80053a:	87a6                	mv	a5,s1
  80053c:	00003717          	auipc	a4,0x3
  800540:	ac470713          	addi	a4,a4,-1340 # 803000 <shared_page>
  800544:	00878023          	sb	s0,0(a5)
    for (int i = 0; i < PGSIZE; i++) {
  800548:	0785                	addi	a5,a5,1
  80054a:	fee79de3          	bne	a5,a4,800544 <test_vulnerable_cow_race+0x42>
    }
    cprintf("Simulated read-only file content initialized with 'R'\n");
  80054e:	00000517          	auipc	a0,0x0
  800552:	64a50513          	addi	a0,a0,1610 # 800b98 <error_string+0x188>
  800556:	aebff0ef          	jal	ra,800040 <cprintf>
    
    int pid = fork();
  80055a:	b89ff0ef          	jal	ra,8000e2 <fork>
    if (pid == 0) {
  80055e:	cd39                	beqz	a0,8005bc <test_vulnerable_cow_race+0xba>
        readonly_page[0] = 'W'; // If fork left it writable, this succeeds
        cprintf("Child: Value at position 0 observed as: %c\n", readonly_page[0]);
        exit(0);
    } else {
        // Parent process
        yield(); // let child race
  800560:	b8bff0ef          	jal	ra,8000ea <yield>
        wait();
  800564:	b81ff0ef          	jal	ra,8000e4 <wait>
        cprintf("Parent: After child's attempt, value at position 0 is: %c\n",
  800568:	0004c583          	lbu	a1,0(s1)
  80056c:	00000517          	auipc	a0,0x0
  800570:	6d450513          	addi	a0,a0,1748 # 800c40 <error_string+0x230>
  800574:	acdff0ef          	jal	ra,800040 <cprintf>
                readonly_page[0]);

        if (readonly_page[0] == 'R') {
  800578:	0004c783          	lbu	a5,0(s1)
  80057c:	02878163          	beq	a5,s0,80059e <test_vulnerable_cow_race+0x9c>
            cprintf("SECURE (expected if kernel fixed Dirty COW): page stayed RO\n");
        } else {
            cprintf("VULNERABLE: child dirtied a read-only mapping via race!\n");
  800580:	00000517          	auipc	a0,0x0
  800584:	74050513          	addi	a0,a0,1856 # 800cc0 <error_string+0x2b0>
  800588:	ab9ff0ef          	jal	ra,800040 <cprintf>
        }
    }
    cprintf("\n");
}
  80058c:	6442                	ld	s0,16(sp)
  80058e:	60e2                	ld	ra,24(sp)
  800590:	64a2                	ld	s1,8(sp)
    cprintf("\n");
  800592:	00000517          	auipc	a0,0x0
  800596:	7fe50513          	addi	a0,a0,2046 # 800d90 <error_string+0x380>
}
  80059a:	6105                	addi	sp,sp,32
    cprintf("\n");
  80059c:	b455                	j	800040 <cprintf>
            cprintf("SECURE (expected if kernel fixed Dirty COW): page stayed RO\n");
  80059e:	00000517          	auipc	a0,0x0
  8005a2:	6e250513          	addi	a0,a0,1762 # 800c80 <error_string+0x270>
  8005a6:	a9bff0ef          	jal	ra,800040 <cprintf>
}
  8005aa:	6442                	ld	s0,16(sp)
  8005ac:	60e2                	ld	ra,24(sp)
  8005ae:	64a2                	ld	s1,8(sp)
    cprintf("\n");
  8005b0:	00000517          	auipc	a0,0x0
  8005b4:	7e050513          	addi	a0,a0,2016 # 800d90 <error_string+0x380>
}
  8005b8:	6105                	addi	sp,sp,32
    cprintf("\n");
  8005ba:	b459                	j	800040 <cprintf>
        cprintf("Child (attacker): Attempting to write to read-only page...\n");
  8005bc:	00000517          	auipc	a0,0x0
  8005c0:	61450513          	addi	a0,a0,1556 # 800bd0 <error_string+0x1c0>
  8005c4:	a7dff0ef          	jal	ra,800040 <cprintf>
        readonly_page[0] = 'W'; // If fork left it writable, this succeeds
  8005c8:	05700793          	li	a5,87
        cprintf("Child: Value at position 0 observed as: %c\n", readonly_page[0]);
  8005cc:	05700593          	li	a1,87
  8005d0:	00000517          	auipc	a0,0x0
  8005d4:	64050513          	addi	a0,a0,1600 # 800c10 <error_string+0x200>
        readonly_page[0] = 'W'; // If fork left it writable, this succeeds
  8005d8:	00f48023          	sb	a5,0(s1)
        cprintf("Child: Value at position 0 observed as: %c\n", readonly_page[0]);
  8005dc:	a65ff0ef          	jal	ra,800040 <cprintf>
        exit(0);
  8005e0:	4501                	li	a0,0
  8005e2:	aebff0ef          	jal	ra,8000cc <exit>

00000000008005e6 <test_secure_cow>:

// Demonstrate proper COW implementation with proper synchronization
void
test_secure_cow(void) {
  8005e6:	1101                	addi	sp,sp,-32
    cprintf("=== Secure COW Implementation ===\n");
  8005e8:	00000517          	auipc	a0,0x0
  8005ec:	71850513          	addi	a0,a0,1816 # 800d00 <error_string+0x2f0>
test_secure_cow(void) {
  8005f0:	ec06                	sd	ra,24(sp)
  8005f2:	e822                	sd	s0,16(sp)
  8005f4:	e426                	sd	s1,8(sp)
    cprintf("=== Secure COW Implementation ===\n");
  8005f6:	a4bff0ef          	jal	ra,800040 <cprintf>
    cprintf("Demonstrating COW with proper RO+COW fork, refcnt, and PTE updates\n\n");
  8005fa:	00000517          	auipc	a0,0x0
  8005fe:	72e50513          	addi	a0,a0,1838 # 800d28 <error_string+0x318>
  800602:	a3fff0ef          	jal	ra,800040 <cprintf>
    
    // Initialize shared page
    for (int i = 0; i < PGSIZE; i++) {
  800606:	00003417          	auipc	s0,0x3
  80060a:	9fa40413          	addi	s0,s0,-1542 # 803000 <shared_page>
  80060e:	87a2                	mv	a5,s0
  800610:	00004697          	auipc	a3,0x4
  800614:	9f068693          	addi	a3,a3,-1552 # 804000 <shared_page+0x1000>
        shared_page[i] = 'S'; // 'S' for shared
  800618:	05300713          	li	a4,83
  80061c:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++) {
  800620:	0785                	addi	a5,a5,1
  800622:	fed79de3          	bne	a5,a3,80061c <test_secure_cow+0x36>
    }
    cprintf("Shared page initialized with 'S'\n");
  800626:	00000517          	auipc	a0,0x0
  80062a:	74a50513          	addi	a0,a0,1866 # 800d70 <error_string+0x360>
  80062e:	a13ff0ef          	jal	ra,800040 <cprintf>
    
    int pid = fork();
  800632:	ab1ff0ef          	jal	ra,8000e2 <fork>
    if (pid == 0) {
  800636:	c92d                	beqz	a0,8006a8 <test_secure_cow+0xc2>
        shared_page[0] = 'C'; // 'C' for child
        cprintf("Child: Modified page, value at position 0: %c\n", shared_page[0]);
        exit(0);
    } else {
        // Parent: also modify the page (should trigger its own COW)
        yield();
  800638:	ab3ff0ef          	jal	ra,8000ea <yield>
        cprintf("Parent: Modifying shared page (should trigger COW)...\n");
  80063c:	00000517          	auipc	a0,0x0
  800640:	7c450513          	addi	a0,a0,1988 # 800e00 <error_string+0x3f0>
  800644:	9fdff0ef          	jal	ra,800040 <cprintf>
        shared_page[0] = 'P'; // 'P' for parent
        cprintf("Parent: Modified page, value at position 0: %c\n", shared_page[0]);
  800648:	05000593          	li	a1,80
        shared_page[0] = 'P'; // 'P' for parent
  80064c:	05000493          	li	s1,80
        cprintf("Parent: Modified page, value at position 0: %c\n", shared_page[0]);
  800650:	00000517          	auipc	a0,0x0
  800654:	7e850513          	addi	a0,a0,2024 # 800e38 <error_string+0x428>
        shared_page[0] = 'P'; // 'P' for parent
  800658:	00940023          	sb	s1,0(s0)
        cprintf("Parent: Modified page, value at position 0: %c\n", shared_page[0]);
  80065c:	9e5ff0ef          	jal	ra,800040 <cprintf>
        
        wait();
  800660:	a85ff0ef          	jal	ra,8000e4 <wait>
        
        // Both should have their own copies
        if (shared_page[0] == 'P') {
  800664:	00044783          	lbu	a5,0(s0)
  800668:	02978163          	beq	a5,s1,80068a <test_secure_cow+0xa4>
            cprintf("SECURE: Parent has independent copy (COW worked correctly)\n");
        } else {
            cprintf("ERROR: Parent's page was modified by child!\n");
  80066c:	00001517          	auipc	a0,0x1
  800670:	83c50513          	addi	a0,a0,-1988 # 800ea8 <error_string+0x498>
  800674:	9cdff0ef          	jal	ra,800040 <cprintf>
        }
    }
    cprintf("\n");
}
  800678:	6442                	ld	s0,16(sp)
  80067a:	60e2                	ld	ra,24(sp)
  80067c:	64a2                	ld	s1,8(sp)
    cprintf("\n");
  80067e:	00000517          	auipc	a0,0x0
  800682:	71250513          	addi	a0,a0,1810 # 800d90 <error_string+0x380>
}
  800686:	6105                	addi	sp,sp,32
    cprintf("\n");
  800688:	ba65                	j	800040 <cprintf>
            cprintf("SECURE: Parent has independent copy (COW worked correctly)\n");
  80068a:	00000517          	auipc	a0,0x0
  80068e:	7de50513          	addi	a0,a0,2014 # 800e68 <error_string+0x458>
  800692:	9afff0ef          	jal	ra,800040 <cprintf>
}
  800696:	6442                	ld	s0,16(sp)
  800698:	60e2                	ld	ra,24(sp)
  80069a:	64a2                	ld	s1,8(sp)
    cprintf("\n");
  80069c:	00000517          	auipc	a0,0x0
  8006a0:	6f450513          	addi	a0,a0,1780 # 800d90 <error_string+0x380>
}
  8006a4:	6105                	addi	sp,sp,32
    cprintf("\n");
  8006a6:	ba69                	j	800040 <cprintf>
        cprintf("Child: Modifying shared page (should trigger COW)...\n");
  8006a8:	00000517          	auipc	a0,0x0
  8006ac:	6f050513          	addi	a0,a0,1776 # 800d98 <error_string+0x388>
  8006b0:	991ff0ef          	jal	ra,800040 <cprintf>
        shared_page[0] = 'C'; // 'C' for child
  8006b4:	04300793          	li	a5,67
        cprintf("Child: Modified page, value at position 0: %c\n", shared_page[0]);
  8006b8:	04300593          	li	a1,67
  8006bc:	00000517          	auipc	a0,0x0
  8006c0:	71450513          	addi	a0,a0,1812 # 800dd0 <error_string+0x3c0>
        shared_page[0] = 'C'; // 'C' for child
  8006c4:	00f40023          	sb	a5,0(s0)
        cprintf("Child: Modified page, value at position 0: %c\n", shared_page[0]);
  8006c8:	979ff0ef          	jal	ra,800040 <cprintf>
        exit(0);
  8006cc:	4501                	li	a0,0
  8006ce:	9ffff0ef          	jal	ra,8000cc <exit>

00000000008006d2 <explain_dirtycow_fix>:

// Explain the fix
void
explain_dirtycow_fix(void) {
  8006d2:	1141                	addi	sp,sp,-16
    cprintf("=== Dirty COW Fix Explanation ===\n");
  8006d4:	00001517          	auipc	a0,0x1
  8006d8:	80450513          	addi	a0,a0,-2044 # 800ed8 <error_string+0x4c8>
explain_dirtycow_fix(void) {
  8006dc:	e406                	sd	ra,8(sp)
    cprintf("=== Dirty COW Fix Explanation ===\n");
  8006de:	963ff0ef          	jal	ra,800040 <cprintf>
    cprintf("Key points to prevent Dirty COW:\n");
  8006e2:	00001517          	auipc	a0,0x1
  8006e6:	81e50513          	addi	a0,a0,-2018 # 800f00 <error_string+0x4f0>
  8006ea:	957ff0ef          	jal	ra,800040 <cprintf>
    cprintf("- At fork: writable mappings become RO + PTE_COW; pure RO stays RO only.\n");
  8006ee:	00001517          	auipc	a0,0x1
  8006f2:	83a50513          	addi	a0,a0,-1990 # 800f28 <error_string+0x518>
  8006f6:	94bff0ef          	jal	ra,800040 <cprintf>
    cprintf("- Write fault path: only handle COW when (error_code & 0x2) != 0.\n");
  8006fa:	00001517          	auipc	a0,0x1
  8006fe:	87e50513          	addi	a0,a0,-1922 # 800f78 <error_string+0x568>
  800702:	93fff0ef          	jal	ra,800040 <cprintf>
    cprintf("- Allocate a new page, copy, then page_insert to flip PTE to writable\n");
  800706:	00001517          	auipc	a0,0x1
  80070a:	8ba50513          	addi	a0,a0,-1862 # 800fc0 <error_string+0x5b0>
  80070e:	933ff0ef          	jal	ra,800040 <cprintf>
    cprintf("  and finally sfence.vma to keep TLB in sync.\n");
  800712:	00001517          	auipc	a0,0x1
  800716:	8f650513          	addi	a0,a0,-1802 # 801008 <error_string+0x5f8>
  80071a:	927ff0ef          	jal	ra,800040 <cprintf>
    cprintf("- Refcount: increment when sharing; page_insert will drop old mapping\n");
  80071e:	00001517          	auipc	a0,0x1
  800722:	91a50513          	addi	a0,a0,-1766 # 801038 <error_string+0x628>
  800726:	91bff0ef          	jal	ra,800040 <cprintf>
    cprintf("  so pages aren't freed prematurely.\n");
  80072a:	00001517          	auipc	a0,0x1
  80072e:	95650513          	addi	a0,a0,-1706 # 801080 <error_string+0x670>
  800732:	90fff0ef          	jal	ra,800040 <cprintf>
    cprintf("\n");
}
  800736:	60a2                	ld	ra,8(sp)
    cprintf("\n");
  800738:	00000517          	auipc	a0,0x0
  80073c:	65850513          	addi	a0,a0,1624 # 800d90 <error_string+0x380>
}
  800740:	0141                	addi	sp,sp,16
    cprintf("\n");
  800742:	b8fd                	j	800040 <cprintf>

0000000000800744 <main>:

int
main(void) {
  800744:	1141                	addi	sp,sp,-16
    cprintf("========================================\n");
  800746:	00001517          	auipc	a0,0x1
  80074a:	96250513          	addi	a0,a0,-1694 # 8010a8 <error_string+0x698>
main(void) {
  80074e:	e406                	sd	ra,8(sp)
    cprintf("========================================\n");
  800750:	8f1ff0ef          	jal	ra,800040 <cprintf>
    cprintf("Dirty COW Vulnerability Demo and Fix\n");
  800754:	00001517          	auipc	a0,0x1
  800758:	98450513          	addi	a0,a0,-1660 # 8010d8 <error_string+0x6c8>
  80075c:	8e5ff0ef          	jal	ra,800040 <cprintf>
    cprintf("========================================\n\n");
  800760:	00001517          	auipc	a0,0x1
  800764:	9a050513          	addi	a0,a0,-1632 # 801100 <error_string+0x6f0>
  800768:	8d9ff0ef          	jal	ra,800040 <cprintf>
    
    test_vulnerable_cow_race();
  80076c:	d97ff0ef          	jal	ra,800502 <test_vulnerable_cow_race>
    test_secure_cow();
  800770:	e77ff0ef          	jal	ra,8005e6 <test_secure_cow>
    explain_dirtycow_fix();
  800774:	f5fff0ef          	jal	ra,8006d2 <explain_dirtycow_fix>
    
    cprintf("========================================\n");
  800778:	00001517          	auipc	a0,0x1
  80077c:	93050513          	addi	a0,a0,-1744 # 8010a8 <error_string+0x698>
  800780:	8c1ff0ef          	jal	ra,800040 <cprintf>
    cprintf("Dirty COW Demo Complete\n");
  800784:	00001517          	auipc	a0,0x1
  800788:	9ac50513          	addi	a0,a0,-1620 # 801130 <error_string+0x720>
  80078c:	8b5ff0ef          	jal	ra,800040 <cprintf>
    cprintf("========================================\n");
  800790:	00001517          	auipc	a0,0x1
  800794:	91850513          	addi	a0,a0,-1768 # 8010a8 <error_string+0x698>
  800798:	8a9ff0ef          	jal	ra,800040 <cprintf>
    return 0;
}
  80079c:	60a2                	ld	ra,8(sp)
  80079e:	4501                	li	a0,0
  8007a0:	0141                	addi	sp,sp,16
  8007a2:	8082                	ret
