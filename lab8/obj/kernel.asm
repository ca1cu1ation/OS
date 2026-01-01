
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00014297          	auipc	t0,0x14
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0214000 <boot_hartid>
ffffffffc020000c:	00014297          	auipc	t0,0x14
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0214008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02132b7          	lui	t0,0xc0213
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0213137          	lui	sp,0xc0213
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00091517          	auipc	a0,0x91
ffffffffc020004e:	01650513          	addi	a0,a0,22 # ffffffffc0291060 <buf>
ffffffffc0200052:	00097617          	auipc	a2,0x97
ffffffffc0200056:	8ce60613          	addi	a2,a2,-1842 # ffffffffc0296920 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	7840b0ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0200066:	52c000ef          	jal	ra,ffffffffc0200592 <cons_init>
ffffffffc020006a:	0000b597          	auipc	a1,0xb
ffffffffc020006e:	7e658593          	addi	a1,a1,2022 # ffffffffc020b850 <etext>
ffffffffc0200072:	0000b517          	auipc	a0,0xb
ffffffffc0200076:	7fe50513          	addi	a0,a0,2046 # ffffffffc020b870 <etext+0x20>
ffffffffc020007a:	12c000ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020007e:	1ae000ef          	jal	ra,ffffffffc020022c <print_kerninfo>
ffffffffc0200082:	62a000ef          	jal	ra,ffffffffc02006ac <dtb_init>
ffffffffc0200086:	495020ef          	jal	ra,ffffffffc0202d1a <pmm_init>
ffffffffc020008a:	3ef000ef          	jal	ra,ffffffffc0200c78 <pic_init>
ffffffffc020008e:	515000ef          	jal	ra,ffffffffc0200da2 <idt_init>
ffffffffc0200092:	150040ef          	jal	ra,ffffffffc02041e2 <vmm_init>
ffffffffc0200096:	4e4070ef          	jal	ra,ffffffffc020757a <sched_init>
ffffffffc020009a:	110070ef          	jal	ra,ffffffffc02071aa <proc_init>
ffffffffc020009e:	1bf000ef          	jal	ra,ffffffffc0200a5c <ide_init>
ffffffffc02000a2:	35a050ef          	jal	ra,ffffffffc02053fc <fs_init>
ffffffffc02000a6:	4a4000ef          	jal	ra,ffffffffc020054a <clock_init>
ffffffffc02000aa:	3c3000ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02000ae:	2c8070ef          	jal	ra,ffffffffc0207376 <cpu_idle>

ffffffffc02000b2 <readline>:
ffffffffc02000b2:	715d                	addi	sp,sp,-80
ffffffffc02000b4:	e486                	sd	ra,72(sp)
ffffffffc02000b6:	e0a6                	sd	s1,64(sp)
ffffffffc02000b8:	fc4a                	sd	s2,56(sp)
ffffffffc02000ba:	f84e                	sd	s3,48(sp)
ffffffffc02000bc:	f452                	sd	s4,40(sp)
ffffffffc02000be:	f056                	sd	s5,32(sp)
ffffffffc02000c0:	ec5a                	sd	s6,24(sp)
ffffffffc02000c2:	e85e                	sd	s7,16(sp)
ffffffffc02000c4:	c901                	beqz	a0,ffffffffc02000d4 <readline+0x22>
ffffffffc02000c6:	85aa                	mv	a1,a0
ffffffffc02000c8:	0000b517          	auipc	a0,0xb
ffffffffc02000cc:	7b050513          	addi	a0,a0,1968 # ffffffffc020b878 <etext+0x28>
ffffffffc02000d0:	0d6000ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02000d4:	4481                	li	s1,0
ffffffffc02000d6:	497d                	li	s2,31
ffffffffc02000d8:	49a1                	li	s3,8
ffffffffc02000da:	4aa9                	li	s5,10
ffffffffc02000dc:	4b35                	li	s6,13
ffffffffc02000de:	00091b97          	auipc	s7,0x91
ffffffffc02000e2:	f82b8b93          	addi	s7,s7,-126 # ffffffffc0291060 <buf>
ffffffffc02000e6:	3fe00a13          	li	s4,1022
ffffffffc02000ea:	0fa000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc02000ee:	00054a63          	bltz	a0,ffffffffc0200102 <readline+0x50>
ffffffffc02000f2:	00a95a63          	bge	s2,a0,ffffffffc0200106 <readline+0x54>
ffffffffc02000f6:	029a5263          	bge	s4,s1,ffffffffc020011a <readline+0x68>
ffffffffc02000fa:	0ea000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc02000fe:	fe055ae3          	bgez	a0,ffffffffc02000f2 <readline+0x40>
ffffffffc0200102:	4501                	li	a0,0
ffffffffc0200104:	a091                	j	ffffffffc0200148 <readline+0x96>
ffffffffc0200106:	03351463          	bne	a0,s3,ffffffffc020012e <readline+0x7c>
ffffffffc020010a:	e8a9                	bnez	s1,ffffffffc020015c <readline+0xaa>
ffffffffc020010c:	0d8000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc0200110:	fe0549e3          	bltz	a0,ffffffffc0200102 <readline+0x50>
ffffffffc0200114:	fea959e3          	bge	s2,a0,ffffffffc0200106 <readline+0x54>
ffffffffc0200118:	4481                	li	s1,0
ffffffffc020011a:	e42a                	sd	a0,8(sp)
ffffffffc020011c:	0c6000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0200120:	6522                	ld	a0,8(sp)
ffffffffc0200122:	009b87b3          	add	a5,s7,s1
ffffffffc0200126:	2485                	addiw	s1,s1,1
ffffffffc0200128:	00a78023          	sb	a0,0(a5)
ffffffffc020012c:	bf7d                	j	ffffffffc02000ea <readline+0x38>
ffffffffc020012e:	01550463          	beq	a0,s5,ffffffffc0200136 <readline+0x84>
ffffffffc0200132:	fb651ce3          	bne	a0,s6,ffffffffc02000ea <readline+0x38>
ffffffffc0200136:	0ac000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc020013a:	00091517          	auipc	a0,0x91
ffffffffc020013e:	f2650513          	addi	a0,a0,-218 # ffffffffc0291060 <buf>
ffffffffc0200142:	94aa                	add	s1,s1,a0
ffffffffc0200144:	00048023          	sb	zero,0(s1)
ffffffffc0200148:	60a6                	ld	ra,72(sp)
ffffffffc020014a:	6486                	ld	s1,64(sp)
ffffffffc020014c:	7962                	ld	s2,56(sp)
ffffffffc020014e:	79c2                	ld	s3,48(sp)
ffffffffc0200150:	7a22                	ld	s4,40(sp)
ffffffffc0200152:	7a82                	ld	s5,32(sp)
ffffffffc0200154:	6b62                	ld	s6,24(sp)
ffffffffc0200156:	6bc2                	ld	s7,16(sp)
ffffffffc0200158:	6161                	addi	sp,sp,80
ffffffffc020015a:	8082                	ret
ffffffffc020015c:	4521                	li	a0,8
ffffffffc020015e:	084000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0200162:	34fd                	addiw	s1,s1,-1
ffffffffc0200164:	b759                	j	ffffffffc02000ea <readline+0x38>

ffffffffc0200166 <cputch>:
ffffffffc0200166:	1141                	addi	sp,sp,-16
ffffffffc0200168:	e022                	sd	s0,0(sp)
ffffffffc020016a:	e406                	sd	ra,8(sp)
ffffffffc020016c:	842e                	mv	s0,a1
ffffffffc020016e:	432000ef          	jal	ra,ffffffffc02005a0 <cons_putc>
ffffffffc0200172:	401c                	lw	a5,0(s0)
ffffffffc0200174:	60a2                	ld	ra,8(sp)
ffffffffc0200176:	2785                	addiw	a5,a5,1
ffffffffc0200178:	c01c                	sw	a5,0(s0)
ffffffffc020017a:	6402                	ld	s0,0(sp)
ffffffffc020017c:	0141                	addi	sp,sp,16
ffffffffc020017e:	8082                	ret

ffffffffc0200180 <vcprintf>:
ffffffffc0200180:	1101                	addi	sp,sp,-32
ffffffffc0200182:	872e                	mv	a4,a1
ffffffffc0200184:	75dd                	lui	a1,0xffff7
ffffffffc0200186:	86aa                	mv	a3,a0
ffffffffc0200188:	0070                	addi	a2,sp,12
ffffffffc020018a:	00000517          	auipc	a0,0x0
ffffffffc020018e:	fdc50513          	addi	a0,a0,-36 # ffffffffc0200166 <cputch>
ffffffffc0200192:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601b9>
ffffffffc0200196:	ec06                	sd	ra,24(sp)
ffffffffc0200198:	c602                	sw	zero,12(sp)
ffffffffc020019a:	1be0b0ef          	jal	ra,ffffffffc020b358 <vprintfmt>
ffffffffc020019e:	60e2                	ld	ra,24(sp)
ffffffffc02001a0:	4532                	lw	a0,12(sp)
ffffffffc02001a2:	6105                	addi	sp,sp,32
ffffffffc02001a4:	8082                	ret

ffffffffc02001a6 <cprintf>:
ffffffffc02001a6:	711d                	addi	sp,sp,-96
ffffffffc02001a8:	02810313          	addi	t1,sp,40 # ffffffffc0213028 <boot_page_table_sv39+0x28>
ffffffffc02001ac:	8e2a                	mv	t3,a0
ffffffffc02001ae:	f42e                	sd	a1,40(sp)
ffffffffc02001b0:	75dd                	lui	a1,0xffff7
ffffffffc02001b2:	f832                	sd	a2,48(sp)
ffffffffc02001b4:	fc36                	sd	a3,56(sp)
ffffffffc02001b6:	e0ba                	sd	a4,64(sp)
ffffffffc02001b8:	00000517          	auipc	a0,0x0
ffffffffc02001bc:	fae50513          	addi	a0,a0,-82 # ffffffffc0200166 <cputch>
ffffffffc02001c0:	0050                	addi	a2,sp,4
ffffffffc02001c2:	871a                	mv	a4,t1
ffffffffc02001c4:	86f2                	mv	a3,t3
ffffffffc02001c6:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601b9>
ffffffffc02001ca:	ec06                	sd	ra,24(sp)
ffffffffc02001cc:	e4be                	sd	a5,72(sp)
ffffffffc02001ce:	e8c2                	sd	a6,80(sp)
ffffffffc02001d0:	ecc6                	sd	a7,88(sp)
ffffffffc02001d2:	e41a                	sd	t1,8(sp)
ffffffffc02001d4:	c202                	sw	zero,4(sp)
ffffffffc02001d6:	1820b0ef          	jal	ra,ffffffffc020b358 <vprintfmt>
ffffffffc02001da:	60e2                	ld	ra,24(sp)
ffffffffc02001dc:	4512                	lw	a0,4(sp)
ffffffffc02001de:	6125                	addi	sp,sp,96
ffffffffc02001e0:	8082                	ret

ffffffffc02001e2 <cputchar>:
ffffffffc02001e2:	ae7d                	j	ffffffffc02005a0 <cons_putc>

ffffffffc02001e4 <getchar>:
ffffffffc02001e4:	1141                	addi	sp,sp,-16
ffffffffc02001e6:	e406                	sd	ra,8(sp)
ffffffffc02001e8:	40c000ef          	jal	ra,ffffffffc02005f4 <cons_getc>
ffffffffc02001ec:	dd75                	beqz	a0,ffffffffc02001e8 <getchar+0x4>
ffffffffc02001ee:	60a2                	ld	ra,8(sp)
ffffffffc02001f0:	0141                	addi	sp,sp,16
ffffffffc02001f2:	8082                	ret

ffffffffc02001f4 <strdup>:
ffffffffc02001f4:	1101                	addi	sp,sp,-32
ffffffffc02001f6:	ec06                	sd	ra,24(sp)
ffffffffc02001f8:	e822                	sd	s0,16(sp)
ffffffffc02001fa:	e426                	sd	s1,8(sp)
ffffffffc02001fc:	e04a                	sd	s2,0(sp)
ffffffffc02001fe:	892a                	mv	s2,a0
ffffffffc0200200:	5440b0ef          	jal	ra,ffffffffc020b744 <strlen>
ffffffffc0200204:	842a                	mv	s0,a0
ffffffffc0200206:	0505                	addi	a0,a0,1
ffffffffc0200208:	60b010ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc020020c:	84aa                	mv	s1,a0
ffffffffc020020e:	c901                	beqz	a0,ffffffffc020021e <strdup+0x2a>
ffffffffc0200210:	8622                	mv	a2,s0
ffffffffc0200212:	85ca                	mv	a1,s2
ffffffffc0200214:	9426                	add	s0,s0,s1
ffffffffc0200216:	6220b0ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc020021a:	00040023          	sb	zero,0(s0)
ffffffffc020021e:	60e2                	ld	ra,24(sp)
ffffffffc0200220:	6442                	ld	s0,16(sp)
ffffffffc0200222:	6902                	ld	s2,0(sp)
ffffffffc0200224:	8526                	mv	a0,s1
ffffffffc0200226:	64a2                	ld	s1,8(sp)
ffffffffc0200228:	6105                	addi	sp,sp,32
ffffffffc020022a:	8082                	ret

ffffffffc020022c <print_kerninfo>:
ffffffffc020022c:	1141                	addi	sp,sp,-16
ffffffffc020022e:	0000b517          	auipc	a0,0xb
ffffffffc0200232:	65250513          	addi	a0,a0,1618 # ffffffffc020b880 <etext+0x30>
ffffffffc0200236:	e406                	sd	ra,8(sp)
ffffffffc0200238:	f6fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020023c:	00000597          	auipc	a1,0x0
ffffffffc0200240:	e0e58593          	addi	a1,a1,-498 # ffffffffc020004a <kern_init>
ffffffffc0200244:	0000b517          	auipc	a0,0xb
ffffffffc0200248:	65c50513          	addi	a0,a0,1628 # ffffffffc020b8a0 <etext+0x50>
ffffffffc020024c:	f5bff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200250:	0000b597          	auipc	a1,0xb
ffffffffc0200254:	60058593          	addi	a1,a1,1536 # ffffffffc020b850 <etext>
ffffffffc0200258:	0000b517          	auipc	a0,0xb
ffffffffc020025c:	66850513          	addi	a0,a0,1640 # ffffffffc020b8c0 <etext+0x70>
ffffffffc0200260:	f47ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200264:	00091597          	auipc	a1,0x91
ffffffffc0200268:	dfc58593          	addi	a1,a1,-516 # ffffffffc0291060 <buf>
ffffffffc020026c:	0000b517          	auipc	a0,0xb
ffffffffc0200270:	67450513          	addi	a0,a0,1652 # ffffffffc020b8e0 <etext+0x90>
ffffffffc0200274:	f33ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200278:	00096597          	auipc	a1,0x96
ffffffffc020027c:	6a858593          	addi	a1,a1,1704 # ffffffffc0296920 <end>
ffffffffc0200280:	0000b517          	auipc	a0,0xb
ffffffffc0200284:	68050513          	addi	a0,a0,1664 # ffffffffc020b900 <etext+0xb0>
ffffffffc0200288:	f1fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020028c:	00097597          	auipc	a1,0x97
ffffffffc0200290:	a9358593          	addi	a1,a1,-1389 # ffffffffc0296d1f <end+0x3ff>
ffffffffc0200294:	00000797          	auipc	a5,0x0
ffffffffc0200298:	db678793          	addi	a5,a5,-586 # ffffffffc020004a <kern_init>
ffffffffc020029c:	40f587b3          	sub	a5,a1,a5
ffffffffc02002a0:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02002a4:	60a2                	ld	ra,8(sp)
ffffffffc02002a6:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002aa:	95be                	add	a1,a1,a5
ffffffffc02002ac:	85a9                	srai	a1,a1,0xa
ffffffffc02002ae:	0000b517          	auipc	a0,0xb
ffffffffc02002b2:	67250513          	addi	a0,a0,1650 # ffffffffc020b920 <etext+0xd0>
ffffffffc02002b6:	0141                	addi	sp,sp,16
ffffffffc02002b8:	b5fd                	j	ffffffffc02001a6 <cprintf>

ffffffffc02002ba <print_stackframe>:
ffffffffc02002ba:	1141                	addi	sp,sp,-16
ffffffffc02002bc:	0000b617          	auipc	a2,0xb
ffffffffc02002c0:	69460613          	addi	a2,a2,1684 # ffffffffc020b950 <etext+0x100>
ffffffffc02002c4:	04e00593          	li	a1,78
ffffffffc02002c8:	0000b517          	auipc	a0,0xb
ffffffffc02002cc:	6a050513          	addi	a0,a0,1696 # ffffffffc020b968 <etext+0x118>
ffffffffc02002d0:	e406                	sd	ra,8(sp)
ffffffffc02002d2:	1cc000ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02002d6 <mon_help>:
ffffffffc02002d6:	1141                	addi	sp,sp,-16
ffffffffc02002d8:	0000b617          	auipc	a2,0xb
ffffffffc02002dc:	6a860613          	addi	a2,a2,1704 # ffffffffc020b980 <etext+0x130>
ffffffffc02002e0:	0000b597          	auipc	a1,0xb
ffffffffc02002e4:	6c058593          	addi	a1,a1,1728 # ffffffffc020b9a0 <etext+0x150>
ffffffffc02002e8:	0000b517          	auipc	a0,0xb
ffffffffc02002ec:	6c050513          	addi	a0,a0,1728 # ffffffffc020b9a8 <etext+0x158>
ffffffffc02002f0:	e406                	sd	ra,8(sp)
ffffffffc02002f2:	eb5ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02002f6:	0000b617          	auipc	a2,0xb
ffffffffc02002fa:	6c260613          	addi	a2,a2,1730 # ffffffffc020b9b8 <etext+0x168>
ffffffffc02002fe:	0000b597          	auipc	a1,0xb
ffffffffc0200302:	6e258593          	addi	a1,a1,1762 # ffffffffc020b9e0 <etext+0x190>
ffffffffc0200306:	0000b517          	auipc	a0,0xb
ffffffffc020030a:	6a250513          	addi	a0,a0,1698 # ffffffffc020b9a8 <etext+0x158>
ffffffffc020030e:	e99ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200312:	0000b617          	auipc	a2,0xb
ffffffffc0200316:	6de60613          	addi	a2,a2,1758 # ffffffffc020b9f0 <etext+0x1a0>
ffffffffc020031a:	0000b597          	auipc	a1,0xb
ffffffffc020031e:	6f658593          	addi	a1,a1,1782 # ffffffffc020ba10 <etext+0x1c0>
ffffffffc0200322:	0000b517          	auipc	a0,0xb
ffffffffc0200326:	68650513          	addi	a0,a0,1670 # ffffffffc020b9a8 <etext+0x158>
ffffffffc020032a:	e7dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020032e:	60a2                	ld	ra,8(sp)
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	0141                	addi	sp,sp,16
ffffffffc0200334:	8082                	ret

ffffffffc0200336 <mon_kerninfo>:
ffffffffc0200336:	1141                	addi	sp,sp,-16
ffffffffc0200338:	e406                	sd	ra,8(sp)
ffffffffc020033a:	ef3ff0ef          	jal	ra,ffffffffc020022c <print_kerninfo>
ffffffffc020033e:	60a2                	ld	ra,8(sp)
ffffffffc0200340:	4501                	li	a0,0
ffffffffc0200342:	0141                	addi	sp,sp,16
ffffffffc0200344:	8082                	ret

ffffffffc0200346 <mon_backtrace>:
ffffffffc0200346:	1141                	addi	sp,sp,-16
ffffffffc0200348:	e406                	sd	ra,8(sp)
ffffffffc020034a:	f71ff0ef          	jal	ra,ffffffffc02002ba <print_stackframe>
ffffffffc020034e:	60a2                	ld	ra,8(sp)
ffffffffc0200350:	4501                	li	a0,0
ffffffffc0200352:	0141                	addi	sp,sp,16
ffffffffc0200354:	8082                	ret

ffffffffc0200356 <kmonitor>:
ffffffffc0200356:	7115                	addi	sp,sp,-224
ffffffffc0200358:	ed5e                	sd	s7,152(sp)
ffffffffc020035a:	8baa                	mv	s7,a0
ffffffffc020035c:	0000b517          	auipc	a0,0xb
ffffffffc0200360:	6c450513          	addi	a0,a0,1732 # ffffffffc020ba20 <etext+0x1d0>
ffffffffc0200364:	ed86                	sd	ra,216(sp)
ffffffffc0200366:	e9a2                	sd	s0,208(sp)
ffffffffc0200368:	e5a6                	sd	s1,200(sp)
ffffffffc020036a:	e1ca                	sd	s2,192(sp)
ffffffffc020036c:	fd4e                	sd	s3,184(sp)
ffffffffc020036e:	f952                	sd	s4,176(sp)
ffffffffc0200370:	f556                	sd	s5,168(sp)
ffffffffc0200372:	f15a                	sd	s6,160(sp)
ffffffffc0200374:	e962                	sd	s8,144(sp)
ffffffffc0200376:	e566                	sd	s9,136(sp)
ffffffffc0200378:	e16a                	sd	s10,128(sp)
ffffffffc020037a:	e2dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020037e:	0000b517          	auipc	a0,0xb
ffffffffc0200382:	6ca50513          	addi	a0,a0,1738 # ffffffffc020ba48 <etext+0x1f8>
ffffffffc0200386:	e21ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020038a:	000b8563          	beqz	s7,ffffffffc0200394 <kmonitor+0x3e>
ffffffffc020038e:	855e                	mv	a0,s7
ffffffffc0200390:	3fb000ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc0200394:	0000bc17          	auipc	s8,0xb
ffffffffc0200398:	724c0c13          	addi	s8,s8,1828 # ffffffffc020bab8 <commands>
ffffffffc020039c:	0000b917          	auipc	s2,0xb
ffffffffc02003a0:	6d490913          	addi	s2,s2,1748 # ffffffffc020ba70 <etext+0x220>
ffffffffc02003a4:	0000b497          	auipc	s1,0xb
ffffffffc02003a8:	6d448493          	addi	s1,s1,1748 # ffffffffc020ba78 <etext+0x228>
ffffffffc02003ac:	49bd                	li	s3,15
ffffffffc02003ae:	0000bb17          	auipc	s6,0xb
ffffffffc02003b2:	6d2b0b13          	addi	s6,s6,1746 # ffffffffc020ba80 <etext+0x230>
ffffffffc02003b6:	0000ba17          	auipc	s4,0xb
ffffffffc02003ba:	5eaa0a13          	addi	s4,s4,1514 # ffffffffc020b9a0 <etext+0x150>
ffffffffc02003be:	4a8d                	li	s5,3
ffffffffc02003c0:	854a                	mv	a0,s2
ffffffffc02003c2:	cf1ff0ef          	jal	ra,ffffffffc02000b2 <readline>
ffffffffc02003c6:	842a                	mv	s0,a0
ffffffffc02003c8:	dd65                	beqz	a0,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc02003ca:	00054583          	lbu	a1,0(a0)
ffffffffc02003ce:	4c81                	li	s9,0
ffffffffc02003d0:	e1bd                	bnez	a1,ffffffffc0200436 <kmonitor+0xe0>
ffffffffc02003d2:	fe0c87e3          	beqz	s9,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc02003d6:	6582                	ld	a1,0(sp)
ffffffffc02003d8:	0000bd17          	auipc	s10,0xb
ffffffffc02003dc:	6e0d0d13          	addi	s10,s10,1760 # ffffffffc020bab8 <commands>
ffffffffc02003e0:	8552                	mv	a0,s4
ffffffffc02003e2:	4401                	li	s0,0
ffffffffc02003e4:	0d61                	addi	s10,s10,24
ffffffffc02003e6:	3a60b0ef          	jal	ra,ffffffffc020b78c <strcmp>
ffffffffc02003ea:	c919                	beqz	a0,ffffffffc0200400 <kmonitor+0xaa>
ffffffffc02003ec:	2405                	addiw	s0,s0,1
ffffffffc02003ee:	0b540063          	beq	s0,s5,ffffffffc020048e <kmonitor+0x138>
ffffffffc02003f2:	000d3503          	ld	a0,0(s10)
ffffffffc02003f6:	6582                	ld	a1,0(sp)
ffffffffc02003f8:	0d61                	addi	s10,s10,24
ffffffffc02003fa:	3920b0ef          	jal	ra,ffffffffc020b78c <strcmp>
ffffffffc02003fe:	f57d                	bnez	a0,ffffffffc02003ec <kmonitor+0x96>
ffffffffc0200400:	00141793          	slli	a5,s0,0x1
ffffffffc0200404:	97a2                	add	a5,a5,s0
ffffffffc0200406:	078e                	slli	a5,a5,0x3
ffffffffc0200408:	97e2                	add	a5,a5,s8
ffffffffc020040a:	6b9c                	ld	a5,16(a5)
ffffffffc020040c:	865e                	mv	a2,s7
ffffffffc020040e:	002c                	addi	a1,sp,8
ffffffffc0200410:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200414:	9782                	jalr	a5
ffffffffc0200416:	fa0555e3          	bgez	a0,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc020041a:	60ee                	ld	ra,216(sp)
ffffffffc020041c:	644e                	ld	s0,208(sp)
ffffffffc020041e:	64ae                	ld	s1,200(sp)
ffffffffc0200420:	690e                	ld	s2,192(sp)
ffffffffc0200422:	79ea                	ld	s3,184(sp)
ffffffffc0200424:	7a4a                	ld	s4,176(sp)
ffffffffc0200426:	7aaa                	ld	s5,168(sp)
ffffffffc0200428:	7b0a                	ld	s6,160(sp)
ffffffffc020042a:	6bea                	ld	s7,152(sp)
ffffffffc020042c:	6c4a                	ld	s8,144(sp)
ffffffffc020042e:	6caa                	ld	s9,136(sp)
ffffffffc0200430:	6d0a                	ld	s10,128(sp)
ffffffffc0200432:	612d                	addi	sp,sp,224
ffffffffc0200434:	8082                	ret
ffffffffc0200436:	8526                	mv	a0,s1
ffffffffc0200438:	3980b0ef          	jal	ra,ffffffffc020b7d0 <strchr>
ffffffffc020043c:	c901                	beqz	a0,ffffffffc020044c <kmonitor+0xf6>
ffffffffc020043e:	00144583          	lbu	a1,1(s0)
ffffffffc0200442:	00040023          	sb	zero,0(s0)
ffffffffc0200446:	0405                	addi	s0,s0,1
ffffffffc0200448:	d5c9                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc020044a:	b7f5                	j	ffffffffc0200436 <kmonitor+0xe0>
ffffffffc020044c:	00044783          	lbu	a5,0(s0)
ffffffffc0200450:	d3c9                	beqz	a5,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200452:	033c8963          	beq	s9,s3,ffffffffc0200484 <kmonitor+0x12e>
ffffffffc0200456:	003c9793          	slli	a5,s9,0x3
ffffffffc020045a:	0118                	addi	a4,sp,128
ffffffffc020045c:	97ba                	add	a5,a5,a4
ffffffffc020045e:	f887b023          	sd	s0,-128(a5)
ffffffffc0200462:	00044583          	lbu	a1,0(s0)
ffffffffc0200466:	2c85                	addiw	s9,s9,1
ffffffffc0200468:	e591                	bnez	a1,ffffffffc0200474 <kmonitor+0x11e>
ffffffffc020046a:	b7b5                	j	ffffffffc02003d6 <kmonitor+0x80>
ffffffffc020046c:	00144583          	lbu	a1,1(s0)
ffffffffc0200470:	0405                	addi	s0,s0,1
ffffffffc0200472:	d1a5                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200474:	8526                	mv	a0,s1
ffffffffc0200476:	35a0b0ef          	jal	ra,ffffffffc020b7d0 <strchr>
ffffffffc020047a:	d96d                	beqz	a0,ffffffffc020046c <kmonitor+0x116>
ffffffffc020047c:	00044583          	lbu	a1,0(s0)
ffffffffc0200480:	d9a9                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200482:	bf55                	j	ffffffffc0200436 <kmonitor+0xe0>
ffffffffc0200484:	45c1                	li	a1,16
ffffffffc0200486:	855a                	mv	a0,s6
ffffffffc0200488:	d1fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020048c:	b7e9                	j	ffffffffc0200456 <kmonitor+0x100>
ffffffffc020048e:	6582                	ld	a1,0(sp)
ffffffffc0200490:	0000b517          	auipc	a0,0xb
ffffffffc0200494:	61050513          	addi	a0,a0,1552 # ffffffffc020baa0 <etext+0x250>
ffffffffc0200498:	d0fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020049c:	b715                	j	ffffffffc02003c0 <kmonitor+0x6a>

ffffffffc020049e <__panic>:
ffffffffc020049e:	00096317          	auipc	t1,0x96
ffffffffc02004a2:	3ca30313          	addi	t1,t1,970 # ffffffffc0296868 <is_panic>
ffffffffc02004a6:	00033e03          	ld	t3,0(t1)
ffffffffc02004aa:	715d                	addi	sp,sp,-80
ffffffffc02004ac:	ec06                	sd	ra,24(sp)
ffffffffc02004ae:	e822                	sd	s0,16(sp)
ffffffffc02004b0:	f436                	sd	a3,40(sp)
ffffffffc02004b2:	f83a                	sd	a4,48(sp)
ffffffffc02004b4:	fc3e                	sd	a5,56(sp)
ffffffffc02004b6:	e0c2                	sd	a6,64(sp)
ffffffffc02004b8:	e4c6                	sd	a7,72(sp)
ffffffffc02004ba:	020e1a63          	bnez	t3,ffffffffc02004ee <__panic+0x50>
ffffffffc02004be:	4785                	li	a5,1
ffffffffc02004c0:	00f33023          	sd	a5,0(t1)
ffffffffc02004c4:	8432                	mv	s0,a2
ffffffffc02004c6:	103c                	addi	a5,sp,40
ffffffffc02004c8:	862e                	mv	a2,a1
ffffffffc02004ca:	85aa                	mv	a1,a0
ffffffffc02004cc:	0000b517          	auipc	a0,0xb
ffffffffc02004d0:	63450513          	addi	a0,a0,1588 # ffffffffc020bb00 <commands+0x48>
ffffffffc02004d4:	e43e                	sd	a5,8(sp)
ffffffffc02004d6:	cd1ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02004da:	65a2                	ld	a1,8(sp)
ffffffffc02004dc:	8522                	mv	a0,s0
ffffffffc02004de:	ca3ff0ef          	jal	ra,ffffffffc0200180 <vcprintf>
ffffffffc02004e2:	0000d517          	auipc	a0,0xd
ffffffffc02004e6:	90e50513          	addi	a0,a0,-1778 # ffffffffc020cdf0 <default_pmm_manager+0x620>
ffffffffc02004ea:	cbdff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02004ee:	4501                	li	a0,0
ffffffffc02004f0:	4581                	li	a1,0
ffffffffc02004f2:	4601                	li	a2,0
ffffffffc02004f4:	48a1                	li	a7,8
ffffffffc02004f6:	00000073          	ecall
ffffffffc02004fa:	778000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02004fe:	4501                	li	a0,0
ffffffffc0200500:	e57ff0ef          	jal	ra,ffffffffc0200356 <kmonitor>
ffffffffc0200504:	bfed                	j	ffffffffc02004fe <__panic+0x60>

ffffffffc0200506 <__warn>:
ffffffffc0200506:	715d                	addi	sp,sp,-80
ffffffffc0200508:	832e                	mv	t1,a1
ffffffffc020050a:	e822                	sd	s0,16(sp)
ffffffffc020050c:	85aa                	mv	a1,a0
ffffffffc020050e:	8432                	mv	s0,a2
ffffffffc0200510:	fc3e                	sd	a5,56(sp)
ffffffffc0200512:	861a                	mv	a2,t1
ffffffffc0200514:	103c                	addi	a5,sp,40
ffffffffc0200516:	0000b517          	auipc	a0,0xb
ffffffffc020051a:	60a50513          	addi	a0,a0,1546 # ffffffffc020bb20 <commands+0x68>
ffffffffc020051e:	ec06                	sd	ra,24(sp)
ffffffffc0200520:	f436                	sd	a3,40(sp)
ffffffffc0200522:	f83a                	sd	a4,48(sp)
ffffffffc0200524:	e0c2                	sd	a6,64(sp)
ffffffffc0200526:	e4c6                	sd	a7,72(sp)
ffffffffc0200528:	e43e                	sd	a5,8(sp)
ffffffffc020052a:	c7dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020052e:	65a2                	ld	a1,8(sp)
ffffffffc0200530:	8522                	mv	a0,s0
ffffffffc0200532:	c4fff0ef          	jal	ra,ffffffffc0200180 <vcprintf>
ffffffffc0200536:	0000d517          	auipc	a0,0xd
ffffffffc020053a:	8ba50513          	addi	a0,a0,-1862 # ffffffffc020cdf0 <default_pmm_manager+0x620>
ffffffffc020053e:	c69ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200542:	60e2                	ld	ra,24(sp)
ffffffffc0200544:	6442                	ld	s0,16(sp)
ffffffffc0200546:	6161                	addi	sp,sp,80
ffffffffc0200548:	8082                	ret

ffffffffc020054a <clock_init>:
ffffffffc020054a:	02000793          	li	a5,32
ffffffffc020054e:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200552:	c0102573          	rdtime	a0
ffffffffc0200556:	67e1                	lui	a5,0x18
ffffffffc0200558:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc020055c:	953e                	add	a0,a0,a5
ffffffffc020055e:	4581                	li	a1,0
ffffffffc0200560:	4601                	li	a2,0
ffffffffc0200562:	4881                	li	a7,0
ffffffffc0200564:	00000073          	ecall
ffffffffc0200568:	0000b517          	auipc	a0,0xb
ffffffffc020056c:	5d850513          	addi	a0,a0,1496 # ffffffffc020bb40 <commands+0x88>
ffffffffc0200570:	00096797          	auipc	a5,0x96
ffffffffc0200574:	3007b023          	sd	zero,768(a5) # ffffffffc0296870 <ticks>
ffffffffc0200578:	b13d                	j	ffffffffc02001a6 <cprintf>

ffffffffc020057a <clock_set_next_event>:
ffffffffc020057a:	c0102573          	rdtime	a0
ffffffffc020057e:	67e1                	lui	a5,0x18
ffffffffc0200580:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200584:	953e                	add	a0,a0,a5
ffffffffc0200586:	4581                	li	a1,0
ffffffffc0200588:	4601                	li	a2,0
ffffffffc020058a:	4881                	li	a7,0
ffffffffc020058c:	00000073          	ecall
ffffffffc0200590:	8082                	ret

ffffffffc0200592 <cons_init>:
ffffffffc0200592:	4501                	li	a0,0
ffffffffc0200594:	4581                	li	a1,0
ffffffffc0200596:	4601                	li	a2,0
ffffffffc0200598:	4889                	li	a7,2
ffffffffc020059a:	00000073          	ecall
ffffffffc020059e:	8082                	ret

ffffffffc02005a0 <cons_putc>:
ffffffffc02005a0:	1101                	addi	sp,sp,-32
ffffffffc02005a2:	ec06                	sd	ra,24(sp)
ffffffffc02005a4:	100027f3          	csrr	a5,sstatus
ffffffffc02005a8:	8b89                	andi	a5,a5,2
ffffffffc02005aa:	4701                	li	a4,0
ffffffffc02005ac:	ef95                	bnez	a5,ffffffffc02005e8 <cons_putc+0x48>
ffffffffc02005ae:	47a1                	li	a5,8
ffffffffc02005b0:	00f50b63          	beq	a0,a5,ffffffffc02005c6 <cons_putc+0x26>
ffffffffc02005b4:	4581                	li	a1,0
ffffffffc02005b6:	4601                	li	a2,0
ffffffffc02005b8:	4885                	li	a7,1
ffffffffc02005ba:	00000073          	ecall
ffffffffc02005be:	e315                	bnez	a4,ffffffffc02005e2 <cons_putc+0x42>
ffffffffc02005c0:	60e2                	ld	ra,24(sp)
ffffffffc02005c2:	6105                	addi	sp,sp,32
ffffffffc02005c4:	8082                	ret
ffffffffc02005c6:	4521                	li	a0,8
ffffffffc02005c8:	4581                	li	a1,0
ffffffffc02005ca:	4601                	li	a2,0
ffffffffc02005cc:	4885                	li	a7,1
ffffffffc02005ce:	00000073          	ecall
ffffffffc02005d2:	02000513          	li	a0,32
ffffffffc02005d6:	00000073          	ecall
ffffffffc02005da:	4521                	li	a0,8
ffffffffc02005dc:	00000073          	ecall
ffffffffc02005e0:	d365                	beqz	a4,ffffffffc02005c0 <cons_putc+0x20>
ffffffffc02005e2:	60e2                	ld	ra,24(sp)
ffffffffc02005e4:	6105                	addi	sp,sp,32
ffffffffc02005e6:	a559                	j	ffffffffc0200c6c <intr_enable>
ffffffffc02005e8:	e42a                	sd	a0,8(sp)
ffffffffc02005ea:	688000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02005ee:	6522                	ld	a0,8(sp)
ffffffffc02005f0:	4705                	li	a4,1
ffffffffc02005f2:	bf75                	j	ffffffffc02005ae <cons_putc+0xe>

ffffffffc02005f4 <cons_getc>:
ffffffffc02005f4:	1101                	addi	sp,sp,-32
ffffffffc02005f6:	ec06                	sd	ra,24(sp)
ffffffffc02005f8:	100027f3          	csrr	a5,sstatus
ffffffffc02005fc:	8b89                	andi	a5,a5,2
ffffffffc02005fe:	4801                	li	a6,0
ffffffffc0200600:	e3d5                	bnez	a5,ffffffffc02006a4 <cons_getc+0xb0>
ffffffffc0200602:	00091697          	auipc	a3,0x91
ffffffffc0200606:	e5e68693          	addi	a3,a3,-418 # ffffffffc0291460 <cons>
ffffffffc020060a:	07f00713          	li	a4,127
ffffffffc020060e:	20000313          	li	t1,512
ffffffffc0200612:	a021                	j	ffffffffc020061a <cons_getc+0x26>
ffffffffc0200614:	0ff57513          	zext.b	a0,a0
ffffffffc0200618:	ef91                	bnez	a5,ffffffffc0200634 <cons_getc+0x40>
ffffffffc020061a:	4501                	li	a0,0
ffffffffc020061c:	4581                	li	a1,0
ffffffffc020061e:	4601                	li	a2,0
ffffffffc0200620:	4889                	li	a7,2
ffffffffc0200622:	00000073          	ecall
ffffffffc0200626:	0005079b          	sext.w	a5,a0
ffffffffc020062a:	0207c763          	bltz	a5,ffffffffc0200658 <cons_getc+0x64>
ffffffffc020062e:	fee793e3          	bne	a5,a4,ffffffffc0200614 <cons_getc+0x20>
ffffffffc0200632:	4521                	li	a0,8
ffffffffc0200634:	2046a783          	lw	a5,516(a3)
ffffffffc0200638:	02079613          	slli	a2,a5,0x20
ffffffffc020063c:	9201                	srli	a2,a2,0x20
ffffffffc020063e:	2785                	addiw	a5,a5,1
ffffffffc0200640:	9636                	add	a2,a2,a3
ffffffffc0200642:	20f6a223          	sw	a5,516(a3)
ffffffffc0200646:	00a60023          	sb	a0,0(a2)
ffffffffc020064a:	fc6798e3          	bne	a5,t1,ffffffffc020061a <cons_getc+0x26>
ffffffffc020064e:	00091797          	auipc	a5,0x91
ffffffffc0200652:	0007ab23          	sw	zero,22(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc0200656:	b7d1                	j	ffffffffc020061a <cons_getc+0x26>
ffffffffc0200658:	2006a783          	lw	a5,512(a3)
ffffffffc020065c:	2046a703          	lw	a4,516(a3)
ffffffffc0200660:	4501                	li	a0,0
ffffffffc0200662:	00f70f63          	beq	a4,a5,ffffffffc0200680 <cons_getc+0x8c>
ffffffffc0200666:	0017861b          	addiw	a2,a5,1
ffffffffc020066a:	1782                	slli	a5,a5,0x20
ffffffffc020066c:	9381                	srli	a5,a5,0x20
ffffffffc020066e:	97b6                	add	a5,a5,a3
ffffffffc0200670:	20c6a023          	sw	a2,512(a3)
ffffffffc0200674:	20000713          	li	a4,512
ffffffffc0200678:	0007c503          	lbu	a0,0(a5)
ffffffffc020067c:	00e60763          	beq	a2,a4,ffffffffc020068a <cons_getc+0x96>
ffffffffc0200680:	00081b63          	bnez	a6,ffffffffc0200696 <cons_getc+0xa2>
ffffffffc0200684:	60e2                	ld	ra,24(sp)
ffffffffc0200686:	6105                	addi	sp,sp,32
ffffffffc0200688:	8082                	ret
ffffffffc020068a:	00091797          	auipc	a5,0x91
ffffffffc020068e:	fc07ab23          	sw	zero,-42(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc0200692:	fe0809e3          	beqz	a6,ffffffffc0200684 <cons_getc+0x90>
ffffffffc0200696:	e42a                	sd	a0,8(sp)
ffffffffc0200698:	5d4000ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020069c:	60e2                	ld	ra,24(sp)
ffffffffc020069e:	6522                	ld	a0,8(sp)
ffffffffc02006a0:	6105                	addi	sp,sp,32
ffffffffc02006a2:	8082                	ret
ffffffffc02006a4:	5ce000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02006a8:	4805                	li	a6,1
ffffffffc02006aa:	bfa1                	j	ffffffffc0200602 <cons_getc+0xe>

ffffffffc02006ac <dtb_init>:
ffffffffc02006ac:	7119                	addi	sp,sp,-128
ffffffffc02006ae:	0000b517          	auipc	a0,0xb
ffffffffc02006b2:	4b250513          	addi	a0,a0,1202 # ffffffffc020bb60 <commands+0xa8>
ffffffffc02006b6:	fc86                	sd	ra,120(sp)
ffffffffc02006b8:	f8a2                	sd	s0,112(sp)
ffffffffc02006ba:	e8d2                	sd	s4,80(sp)
ffffffffc02006bc:	f4a6                	sd	s1,104(sp)
ffffffffc02006be:	f0ca                	sd	s2,96(sp)
ffffffffc02006c0:	ecce                	sd	s3,88(sp)
ffffffffc02006c2:	e4d6                	sd	s5,72(sp)
ffffffffc02006c4:	e0da                	sd	s6,64(sp)
ffffffffc02006c6:	fc5e                	sd	s7,56(sp)
ffffffffc02006c8:	f862                	sd	s8,48(sp)
ffffffffc02006ca:	f466                	sd	s9,40(sp)
ffffffffc02006cc:	f06a                	sd	s10,32(sp)
ffffffffc02006ce:	ec6e                	sd	s11,24(sp)
ffffffffc02006d0:	ad7ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006d4:	00014597          	auipc	a1,0x14
ffffffffc02006d8:	92c5b583          	ld	a1,-1748(a1) # ffffffffc0214000 <boot_hartid>
ffffffffc02006dc:	0000b517          	auipc	a0,0xb
ffffffffc02006e0:	49450513          	addi	a0,a0,1172 # ffffffffc020bb70 <commands+0xb8>
ffffffffc02006e4:	ac3ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006e8:	00014417          	auipc	s0,0x14
ffffffffc02006ec:	92040413          	addi	s0,s0,-1760 # ffffffffc0214008 <boot_dtb>
ffffffffc02006f0:	600c                	ld	a1,0(s0)
ffffffffc02006f2:	0000b517          	auipc	a0,0xb
ffffffffc02006f6:	48e50513          	addi	a0,a0,1166 # ffffffffc020bb80 <commands+0xc8>
ffffffffc02006fa:	aadff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006fe:	00043a03          	ld	s4,0(s0)
ffffffffc0200702:	0000b517          	auipc	a0,0xb
ffffffffc0200706:	49650513          	addi	a0,a0,1174 # ffffffffc020bb98 <commands+0xe0>
ffffffffc020070a:	120a0463          	beqz	s4,ffffffffc0200832 <dtb_init+0x186>
ffffffffc020070e:	57f5                	li	a5,-3
ffffffffc0200710:	07fa                	slli	a5,a5,0x1e
ffffffffc0200712:	00fa0733          	add	a4,s4,a5
ffffffffc0200716:	431c                	lw	a5,0(a4)
ffffffffc0200718:	00ff0637          	lui	a2,0xff0
ffffffffc020071c:	6b41                	lui	s6,0x10
ffffffffc020071e:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200722:	0187969b          	slliw	a3,a5,0x18
ffffffffc0200726:	0187d51b          	srliw	a0,a5,0x18
ffffffffc020072a:	0105959b          	slliw	a1,a1,0x10
ffffffffc020072e:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200732:	8df1                	and	a1,a1,a2
ffffffffc0200734:	8ec9                	or	a3,a3,a0
ffffffffc0200736:	0087979b          	slliw	a5,a5,0x8
ffffffffc020073a:	1b7d                	addi	s6,s6,-1
ffffffffc020073c:	0167f7b3          	and	a5,a5,s6
ffffffffc0200740:	8dd5                	or	a1,a1,a3
ffffffffc0200742:	8ddd                	or	a1,a1,a5
ffffffffc0200744:	d00e07b7          	lui	a5,0xd00e0
ffffffffc0200748:	2581                	sext.w	a1,a1
ffffffffc020074a:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe495cd>
ffffffffc020074e:	10f59163          	bne	a1,a5,ffffffffc0200850 <dtb_init+0x1a4>
ffffffffc0200752:	471c                	lw	a5,8(a4)
ffffffffc0200754:	4754                	lw	a3,12(a4)
ffffffffc0200756:	4c81                	li	s9,0
ffffffffc0200758:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020075c:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200760:	0186941b          	slliw	s0,a3,0x18
ffffffffc0200764:	0186d89b          	srliw	a7,a3,0x18
ffffffffc0200768:	01879a1b          	slliw	s4,a5,0x18
ffffffffc020076c:	0187d81b          	srliw	a6,a5,0x18
ffffffffc0200770:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200774:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200778:	0105959b          	slliw	a1,a1,0x10
ffffffffc020077c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200780:	8d71                	and	a0,a0,a2
ffffffffc0200782:	01146433          	or	s0,s0,a7
ffffffffc0200786:	0086969b          	slliw	a3,a3,0x8
ffffffffc020078a:	010a6a33          	or	s4,s4,a6
ffffffffc020078e:	8e6d                	and	a2,a2,a1
ffffffffc0200790:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200794:	8c49                	or	s0,s0,a0
ffffffffc0200796:	0166f6b3          	and	a3,a3,s6
ffffffffc020079a:	00ca6a33          	or	s4,s4,a2
ffffffffc020079e:	0167f7b3          	and	a5,a5,s6
ffffffffc02007a2:	8c55                	or	s0,s0,a3
ffffffffc02007a4:	00fa6a33          	or	s4,s4,a5
ffffffffc02007a8:	1402                	slli	s0,s0,0x20
ffffffffc02007aa:	1a02                	slli	s4,s4,0x20
ffffffffc02007ac:	9001                	srli	s0,s0,0x20
ffffffffc02007ae:	020a5a13          	srli	s4,s4,0x20
ffffffffc02007b2:	943a                	add	s0,s0,a4
ffffffffc02007b4:	9a3a                	add	s4,s4,a4
ffffffffc02007b6:	00ff0c37          	lui	s8,0xff0
ffffffffc02007ba:	4b8d                	li	s7,3
ffffffffc02007bc:	0000b917          	auipc	s2,0xb
ffffffffc02007c0:	42c90913          	addi	s2,s2,1068 # ffffffffc020bbe8 <commands+0x130>
ffffffffc02007c4:	49bd                	li	s3,15
ffffffffc02007c6:	4d91                	li	s11,4
ffffffffc02007c8:	4d05                	li	s10,1
ffffffffc02007ca:	0000b497          	auipc	s1,0xb
ffffffffc02007ce:	41648493          	addi	s1,s1,1046 # ffffffffc020bbe0 <commands+0x128>
ffffffffc02007d2:	000a2703          	lw	a4,0(s4)
ffffffffc02007d6:	004a0a93          	addi	s5,s4,4
ffffffffc02007da:	0087569b          	srliw	a3,a4,0x8
ffffffffc02007de:	0187179b          	slliw	a5,a4,0x18
ffffffffc02007e2:	0187561b          	srliw	a2,a4,0x18
ffffffffc02007e6:	0106969b          	slliw	a3,a3,0x10
ffffffffc02007ea:	0107571b          	srliw	a4,a4,0x10
ffffffffc02007ee:	8fd1                	or	a5,a5,a2
ffffffffc02007f0:	0186f6b3          	and	a3,a3,s8
ffffffffc02007f4:	0087171b          	slliw	a4,a4,0x8
ffffffffc02007f8:	8fd5                	or	a5,a5,a3
ffffffffc02007fa:	00eb7733          	and	a4,s6,a4
ffffffffc02007fe:	8fd9                	or	a5,a5,a4
ffffffffc0200800:	2781                	sext.w	a5,a5
ffffffffc0200802:	09778c63          	beq	a5,s7,ffffffffc020089a <dtb_init+0x1ee>
ffffffffc0200806:	00fbea63          	bltu	s7,a5,ffffffffc020081a <dtb_init+0x16e>
ffffffffc020080a:	07a78663          	beq	a5,s10,ffffffffc0200876 <dtb_init+0x1ca>
ffffffffc020080e:	4709                	li	a4,2
ffffffffc0200810:	00e79763          	bne	a5,a4,ffffffffc020081e <dtb_init+0x172>
ffffffffc0200814:	4c81                	li	s9,0
ffffffffc0200816:	8a56                	mv	s4,s5
ffffffffc0200818:	bf6d                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc020081a:	ffb78ee3          	beq	a5,s11,ffffffffc0200816 <dtb_init+0x16a>
ffffffffc020081e:	0000b517          	auipc	a0,0xb
ffffffffc0200822:	44250513          	addi	a0,a0,1090 # ffffffffc020bc60 <commands+0x1a8>
ffffffffc0200826:	981ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020082a:	0000b517          	auipc	a0,0xb
ffffffffc020082e:	46e50513          	addi	a0,a0,1134 # ffffffffc020bc98 <commands+0x1e0>
ffffffffc0200832:	7446                	ld	s0,112(sp)
ffffffffc0200834:	70e6                	ld	ra,120(sp)
ffffffffc0200836:	74a6                	ld	s1,104(sp)
ffffffffc0200838:	7906                	ld	s2,96(sp)
ffffffffc020083a:	69e6                	ld	s3,88(sp)
ffffffffc020083c:	6a46                	ld	s4,80(sp)
ffffffffc020083e:	6aa6                	ld	s5,72(sp)
ffffffffc0200840:	6b06                	ld	s6,64(sp)
ffffffffc0200842:	7be2                	ld	s7,56(sp)
ffffffffc0200844:	7c42                	ld	s8,48(sp)
ffffffffc0200846:	7ca2                	ld	s9,40(sp)
ffffffffc0200848:	7d02                	ld	s10,32(sp)
ffffffffc020084a:	6de2                	ld	s11,24(sp)
ffffffffc020084c:	6109                	addi	sp,sp,128
ffffffffc020084e:	baa1                	j	ffffffffc02001a6 <cprintf>
ffffffffc0200850:	7446                	ld	s0,112(sp)
ffffffffc0200852:	70e6                	ld	ra,120(sp)
ffffffffc0200854:	74a6                	ld	s1,104(sp)
ffffffffc0200856:	7906                	ld	s2,96(sp)
ffffffffc0200858:	69e6                	ld	s3,88(sp)
ffffffffc020085a:	6a46                	ld	s4,80(sp)
ffffffffc020085c:	6aa6                	ld	s5,72(sp)
ffffffffc020085e:	6b06                	ld	s6,64(sp)
ffffffffc0200860:	7be2                	ld	s7,56(sp)
ffffffffc0200862:	7c42                	ld	s8,48(sp)
ffffffffc0200864:	7ca2                	ld	s9,40(sp)
ffffffffc0200866:	7d02                	ld	s10,32(sp)
ffffffffc0200868:	6de2                	ld	s11,24(sp)
ffffffffc020086a:	0000b517          	auipc	a0,0xb
ffffffffc020086e:	34e50513          	addi	a0,a0,846 # ffffffffc020bbb8 <commands+0x100>
ffffffffc0200872:	6109                	addi	sp,sp,128
ffffffffc0200874:	ba0d                	j	ffffffffc02001a6 <cprintf>
ffffffffc0200876:	8556                	mv	a0,s5
ffffffffc0200878:	6cd0a0ef          	jal	ra,ffffffffc020b744 <strlen>
ffffffffc020087c:	8a2a                	mv	s4,a0
ffffffffc020087e:	4619                	li	a2,6
ffffffffc0200880:	85a6                	mv	a1,s1
ffffffffc0200882:	8556                	mv	a0,s5
ffffffffc0200884:	2a01                	sext.w	s4,s4
ffffffffc0200886:	7250a0ef          	jal	ra,ffffffffc020b7aa <strncmp>
ffffffffc020088a:	e111                	bnez	a0,ffffffffc020088e <dtb_init+0x1e2>
ffffffffc020088c:	4c85                	li	s9,1
ffffffffc020088e:	0a91                	addi	s5,s5,4
ffffffffc0200890:	9ad2                	add	s5,s5,s4
ffffffffc0200892:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200896:	8a56                	mv	s4,s5
ffffffffc0200898:	bf2d                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc020089a:	004a2783          	lw	a5,4(s4)
ffffffffc020089e:	00ca0693          	addi	a3,s4,12
ffffffffc02008a2:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02008a6:	01879a9b          	slliw	s5,a5,0x18
ffffffffc02008aa:	0187d61b          	srliw	a2,a5,0x18
ffffffffc02008ae:	0107171b          	slliw	a4,a4,0x10
ffffffffc02008b2:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02008b6:	00caeab3          	or	s5,s5,a2
ffffffffc02008ba:	01877733          	and	a4,a4,s8
ffffffffc02008be:	0087979b          	slliw	a5,a5,0x8
ffffffffc02008c2:	00eaeab3          	or	s5,s5,a4
ffffffffc02008c6:	00fb77b3          	and	a5,s6,a5
ffffffffc02008ca:	00faeab3          	or	s5,s5,a5
ffffffffc02008ce:	2a81                	sext.w	s5,s5
ffffffffc02008d0:	000c9c63          	bnez	s9,ffffffffc02008e8 <dtb_init+0x23c>
ffffffffc02008d4:	1a82                	slli	s5,s5,0x20
ffffffffc02008d6:	00368793          	addi	a5,a3,3
ffffffffc02008da:	020ada93          	srli	s5,s5,0x20
ffffffffc02008de:	9abe                	add	s5,s5,a5
ffffffffc02008e0:	ffcafa93          	andi	s5,s5,-4
ffffffffc02008e4:	8a56                	mv	s4,s5
ffffffffc02008e6:	b5f5                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc02008e8:	008a2783          	lw	a5,8(s4)
ffffffffc02008ec:	85ca                	mv	a1,s2
ffffffffc02008ee:	e436                	sd	a3,8(sp)
ffffffffc02008f0:	0087d51b          	srliw	a0,a5,0x8
ffffffffc02008f4:	0187d61b          	srliw	a2,a5,0x18
ffffffffc02008f8:	0187971b          	slliw	a4,a5,0x18
ffffffffc02008fc:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200900:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200904:	8f51                	or	a4,a4,a2
ffffffffc0200906:	01857533          	and	a0,a0,s8
ffffffffc020090a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020090e:	8d59                	or	a0,a0,a4
ffffffffc0200910:	00fb77b3          	and	a5,s6,a5
ffffffffc0200914:	8d5d                	or	a0,a0,a5
ffffffffc0200916:	1502                	slli	a0,a0,0x20
ffffffffc0200918:	9101                	srli	a0,a0,0x20
ffffffffc020091a:	9522                	add	a0,a0,s0
ffffffffc020091c:	6710a0ef          	jal	ra,ffffffffc020b78c <strcmp>
ffffffffc0200920:	66a2                	ld	a3,8(sp)
ffffffffc0200922:	f94d                	bnez	a0,ffffffffc02008d4 <dtb_init+0x228>
ffffffffc0200924:	fb59f8e3          	bgeu	s3,s5,ffffffffc02008d4 <dtb_init+0x228>
ffffffffc0200928:	00ca3783          	ld	a5,12(s4)
ffffffffc020092c:	014a3703          	ld	a4,20(s4)
ffffffffc0200930:	0000b517          	auipc	a0,0xb
ffffffffc0200934:	2c050513          	addi	a0,a0,704 # ffffffffc020bbf0 <commands+0x138>
ffffffffc0200938:	4207d613          	srai	a2,a5,0x20
ffffffffc020093c:	0087d31b          	srliw	t1,a5,0x8
ffffffffc0200940:	42075593          	srai	a1,a4,0x20
ffffffffc0200944:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200948:	0186581b          	srliw	a6,a2,0x18
ffffffffc020094c:	0187941b          	slliw	s0,a5,0x18
ffffffffc0200950:	0107d89b          	srliw	a7,a5,0x10
ffffffffc0200954:	0187d693          	srli	a3,a5,0x18
ffffffffc0200958:	01861f1b          	slliw	t5,a2,0x18
ffffffffc020095c:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200960:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200964:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200968:	010f6f33          	or	t5,t5,a6
ffffffffc020096c:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200970:	0185df9b          	srliw	t6,a1,0x18
ffffffffc0200974:	01837333          	and	t1,t1,s8
ffffffffc0200978:	01c46433          	or	s0,s0,t3
ffffffffc020097c:	0186f6b3          	and	a3,a3,s8
ffffffffc0200980:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200984:	01871e9b          	slliw	t4,a4,0x18
ffffffffc0200988:	0107581b          	srliw	a6,a4,0x10
ffffffffc020098c:	0086161b          	slliw	a2,a2,0x8
ffffffffc0200990:	8361                	srli	a4,a4,0x18
ffffffffc0200992:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200996:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020099a:	01e6e6b3          	or	a3,a3,t5
ffffffffc020099e:	00cb7633          	and	a2,s6,a2
ffffffffc02009a2:	0088181b          	slliw	a6,a6,0x8
ffffffffc02009a6:	0085959b          	slliw	a1,a1,0x8
ffffffffc02009aa:	00646433          	or	s0,s0,t1
ffffffffc02009ae:	0187f7b3          	and	a5,a5,s8
ffffffffc02009b2:	01fe6333          	or	t1,t3,t6
ffffffffc02009b6:	01877c33          	and	s8,a4,s8
ffffffffc02009ba:	0088989b          	slliw	a7,a7,0x8
ffffffffc02009be:	011b78b3          	and	a7,s6,a7
ffffffffc02009c2:	005eeeb3          	or	t4,t4,t0
ffffffffc02009c6:	00c6e733          	or	a4,a3,a2
ffffffffc02009ca:	006c6c33          	or	s8,s8,t1
ffffffffc02009ce:	010b76b3          	and	a3,s6,a6
ffffffffc02009d2:	00bb7b33          	and	s6,s6,a1
ffffffffc02009d6:	01d7e7b3          	or	a5,a5,t4
ffffffffc02009da:	016c6b33          	or	s6,s8,s6
ffffffffc02009de:	01146433          	or	s0,s0,a7
ffffffffc02009e2:	8fd5                	or	a5,a5,a3
ffffffffc02009e4:	1702                	slli	a4,a4,0x20
ffffffffc02009e6:	1b02                	slli	s6,s6,0x20
ffffffffc02009e8:	1782                	slli	a5,a5,0x20
ffffffffc02009ea:	9301                	srli	a4,a4,0x20
ffffffffc02009ec:	1402                	slli	s0,s0,0x20
ffffffffc02009ee:	020b5b13          	srli	s6,s6,0x20
ffffffffc02009f2:	0167eb33          	or	s6,a5,s6
ffffffffc02009f6:	8c59                	or	s0,s0,a4
ffffffffc02009f8:	faeff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02009fc:	85a2                	mv	a1,s0
ffffffffc02009fe:	0000b517          	auipc	a0,0xb
ffffffffc0200a02:	21250513          	addi	a0,a0,530 # ffffffffc020bc10 <commands+0x158>
ffffffffc0200a06:	fa0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a0a:	014b5613          	srli	a2,s6,0x14
ffffffffc0200a0e:	85da                	mv	a1,s6
ffffffffc0200a10:	0000b517          	auipc	a0,0xb
ffffffffc0200a14:	21850513          	addi	a0,a0,536 # ffffffffc020bc28 <commands+0x170>
ffffffffc0200a18:	f8eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a1c:	008b05b3          	add	a1,s6,s0
ffffffffc0200a20:	15fd                	addi	a1,a1,-1
ffffffffc0200a22:	0000b517          	auipc	a0,0xb
ffffffffc0200a26:	22650513          	addi	a0,a0,550 # ffffffffc020bc48 <commands+0x190>
ffffffffc0200a2a:	f7cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a2e:	0000b517          	auipc	a0,0xb
ffffffffc0200a32:	26a50513          	addi	a0,a0,618 # ffffffffc020bc98 <commands+0x1e0>
ffffffffc0200a36:	00096797          	auipc	a5,0x96
ffffffffc0200a3a:	e487b123          	sd	s0,-446(a5) # ffffffffc0296878 <memory_base>
ffffffffc0200a3e:	00096797          	auipc	a5,0x96
ffffffffc0200a42:	e567b123          	sd	s6,-446(a5) # ffffffffc0296880 <memory_size>
ffffffffc0200a46:	b3f5                	j	ffffffffc0200832 <dtb_init+0x186>

ffffffffc0200a48 <get_memory_base>:
ffffffffc0200a48:	00096517          	auipc	a0,0x96
ffffffffc0200a4c:	e3053503          	ld	a0,-464(a0) # ffffffffc0296878 <memory_base>
ffffffffc0200a50:	8082                	ret

ffffffffc0200a52 <get_memory_size>:
ffffffffc0200a52:	00096517          	auipc	a0,0x96
ffffffffc0200a56:	e2e53503          	ld	a0,-466(a0) # ffffffffc0296880 <memory_size>
ffffffffc0200a5a:	8082                	ret

ffffffffc0200a5c <ide_init>:
ffffffffc0200a5c:	1141                	addi	sp,sp,-16
ffffffffc0200a5e:	00091597          	auipc	a1,0x91
ffffffffc0200a62:	c5a58593          	addi	a1,a1,-934 # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a66:	4505                	li	a0,1
ffffffffc0200a68:	e022                	sd	s0,0(sp)
ffffffffc0200a6a:	00091797          	auipc	a5,0x91
ffffffffc0200a6e:	be07af23          	sw	zero,-1026(a5) # ffffffffc0291668 <ide_devices>
ffffffffc0200a72:	00091797          	auipc	a5,0x91
ffffffffc0200a76:	c407a323          	sw	zero,-954(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a7a:	00091797          	auipc	a5,0x91
ffffffffc0200a7e:	c807a723          	sw	zero,-882(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a82:	00091797          	auipc	a5,0x91
ffffffffc0200a86:	cc07ab23          	sw	zero,-810(a5) # ffffffffc0291758 <ide_devices+0xf0>
ffffffffc0200a8a:	e406                	sd	ra,8(sp)
ffffffffc0200a8c:	00091417          	auipc	s0,0x91
ffffffffc0200a90:	bdc40413          	addi	s0,s0,-1060 # ffffffffc0291668 <ide_devices>
ffffffffc0200a94:	23a000ef          	jal	ra,ffffffffc0200cce <ramdisk_init>
ffffffffc0200a98:	483c                	lw	a5,80(s0)
ffffffffc0200a9a:	cf99                	beqz	a5,ffffffffc0200ab8 <ide_init+0x5c>
ffffffffc0200a9c:	00091597          	auipc	a1,0x91
ffffffffc0200aa0:	c6c58593          	addi	a1,a1,-916 # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200aa4:	4509                	li	a0,2
ffffffffc0200aa6:	228000ef          	jal	ra,ffffffffc0200cce <ramdisk_init>
ffffffffc0200aaa:	0a042783          	lw	a5,160(s0)
ffffffffc0200aae:	c785                	beqz	a5,ffffffffc0200ad6 <ide_init+0x7a>
ffffffffc0200ab0:	60a2                	ld	ra,8(sp)
ffffffffc0200ab2:	6402                	ld	s0,0(sp)
ffffffffc0200ab4:	0141                	addi	sp,sp,16
ffffffffc0200ab6:	8082                	ret
ffffffffc0200ab8:	0000b697          	auipc	a3,0xb
ffffffffc0200abc:	1f868693          	addi	a3,a3,504 # ffffffffc020bcb0 <commands+0x1f8>
ffffffffc0200ac0:	0000b617          	auipc	a2,0xb
ffffffffc0200ac4:	20860613          	addi	a2,a2,520 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0200ac8:	45c5                	li	a1,17
ffffffffc0200aca:	0000b517          	auipc	a0,0xb
ffffffffc0200ace:	21650513          	addi	a0,a0,534 # ffffffffc020bce0 <commands+0x228>
ffffffffc0200ad2:	9cdff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200ad6:	0000b697          	auipc	a3,0xb
ffffffffc0200ada:	22268693          	addi	a3,a3,546 # ffffffffc020bcf8 <commands+0x240>
ffffffffc0200ade:	0000b617          	auipc	a2,0xb
ffffffffc0200ae2:	1ea60613          	addi	a2,a2,490 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0200ae6:	45d1                	li	a1,20
ffffffffc0200ae8:	0000b517          	auipc	a0,0xb
ffffffffc0200aec:	1f850513          	addi	a0,a0,504 # ffffffffc020bce0 <commands+0x228>
ffffffffc0200af0:	9afff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200af4 <ide_device_valid>:
ffffffffc0200af4:	478d                	li	a5,3
ffffffffc0200af6:	00a7ef63          	bltu	a5,a0,ffffffffc0200b14 <ide_device_valid+0x20>
ffffffffc0200afa:	00251793          	slli	a5,a0,0x2
ffffffffc0200afe:	953e                	add	a0,a0,a5
ffffffffc0200b00:	0512                	slli	a0,a0,0x4
ffffffffc0200b02:	00091797          	auipc	a5,0x91
ffffffffc0200b06:	b6678793          	addi	a5,a5,-1178 # ffffffffc0291668 <ide_devices>
ffffffffc0200b0a:	953e                	add	a0,a0,a5
ffffffffc0200b0c:	4108                	lw	a0,0(a0)
ffffffffc0200b0e:	00a03533          	snez	a0,a0
ffffffffc0200b12:	8082                	ret
ffffffffc0200b14:	4501                	li	a0,0
ffffffffc0200b16:	8082                	ret

ffffffffc0200b18 <ide_device_size>:
ffffffffc0200b18:	478d                	li	a5,3
ffffffffc0200b1a:	02a7e163          	bltu	a5,a0,ffffffffc0200b3c <ide_device_size+0x24>
ffffffffc0200b1e:	00251793          	slli	a5,a0,0x2
ffffffffc0200b22:	953e                	add	a0,a0,a5
ffffffffc0200b24:	0512                	slli	a0,a0,0x4
ffffffffc0200b26:	00091797          	auipc	a5,0x91
ffffffffc0200b2a:	b4278793          	addi	a5,a5,-1214 # ffffffffc0291668 <ide_devices>
ffffffffc0200b2e:	97aa                	add	a5,a5,a0
ffffffffc0200b30:	4398                	lw	a4,0(a5)
ffffffffc0200b32:	4501                	li	a0,0
ffffffffc0200b34:	c709                	beqz	a4,ffffffffc0200b3e <ide_device_size+0x26>
ffffffffc0200b36:	0087e503          	lwu	a0,8(a5)
ffffffffc0200b3a:	8082                	ret
ffffffffc0200b3c:	4501                	li	a0,0
ffffffffc0200b3e:	8082                	ret

ffffffffc0200b40 <ide_read_secs>:
ffffffffc0200b40:	1141                	addi	sp,sp,-16
ffffffffc0200b42:	e406                	sd	ra,8(sp)
ffffffffc0200b44:	08000793          	li	a5,128
ffffffffc0200b48:	04d7e763          	bltu	a5,a3,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b4c:	478d                	li	a5,3
ffffffffc0200b4e:	0005081b          	sext.w	a6,a0
ffffffffc0200b52:	04a7e263          	bltu	a5,a0,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b56:	00281793          	slli	a5,a6,0x2
ffffffffc0200b5a:	97c2                	add	a5,a5,a6
ffffffffc0200b5c:	0792                	slli	a5,a5,0x4
ffffffffc0200b5e:	00091817          	auipc	a6,0x91
ffffffffc0200b62:	b0a80813          	addi	a6,a6,-1270 # ffffffffc0291668 <ide_devices>
ffffffffc0200b66:	97c2                	add	a5,a5,a6
ffffffffc0200b68:	0007a883          	lw	a7,0(a5)
ffffffffc0200b6c:	02088563          	beqz	a7,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b70:	100008b7          	lui	a7,0x10000
ffffffffc0200b74:	0515f163          	bgeu	a1,a7,ffffffffc0200bb6 <ide_read_secs+0x76>
ffffffffc0200b78:	1582                	slli	a1,a1,0x20
ffffffffc0200b7a:	9181                	srli	a1,a1,0x20
ffffffffc0200b7c:	00d58733          	add	a4,a1,a3
ffffffffc0200b80:	02e8eb63          	bltu	a7,a4,ffffffffc0200bb6 <ide_read_secs+0x76>
ffffffffc0200b84:	00251713          	slli	a4,a0,0x2
ffffffffc0200b88:	60a2                	ld	ra,8(sp)
ffffffffc0200b8a:	63bc                	ld	a5,64(a5)
ffffffffc0200b8c:	953a                	add	a0,a0,a4
ffffffffc0200b8e:	0512                	slli	a0,a0,0x4
ffffffffc0200b90:	9542                	add	a0,a0,a6
ffffffffc0200b92:	0141                	addi	sp,sp,16
ffffffffc0200b94:	8782                	jr	a5
ffffffffc0200b96:	0000b697          	auipc	a3,0xb
ffffffffc0200b9a:	17a68693          	addi	a3,a3,378 # ffffffffc020bd10 <commands+0x258>
ffffffffc0200b9e:	0000b617          	auipc	a2,0xb
ffffffffc0200ba2:	12a60613          	addi	a2,a2,298 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0200ba6:	02200593          	li	a1,34
ffffffffc0200baa:	0000b517          	auipc	a0,0xb
ffffffffc0200bae:	13650513          	addi	a0,a0,310 # ffffffffc020bce0 <commands+0x228>
ffffffffc0200bb2:	8edff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200bb6:	0000b697          	auipc	a3,0xb
ffffffffc0200bba:	18268693          	addi	a3,a3,386 # ffffffffc020bd38 <commands+0x280>
ffffffffc0200bbe:	0000b617          	auipc	a2,0xb
ffffffffc0200bc2:	10a60613          	addi	a2,a2,266 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0200bc6:	02300593          	li	a1,35
ffffffffc0200bca:	0000b517          	auipc	a0,0xb
ffffffffc0200bce:	11650513          	addi	a0,a0,278 # ffffffffc020bce0 <commands+0x228>
ffffffffc0200bd2:	8cdff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200bd6 <ide_write_secs>:
ffffffffc0200bd6:	1141                	addi	sp,sp,-16
ffffffffc0200bd8:	e406                	sd	ra,8(sp)
ffffffffc0200bda:	08000793          	li	a5,128
ffffffffc0200bde:	04d7e763          	bltu	a5,a3,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200be2:	478d                	li	a5,3
ffffffffc0200be4:	0005081b          	sext.w	a6,a0
ffffffffc0200be8:	04a7e263          	bltu	a5,a0,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200bec:	00281793          	slli	a5,a6,0x2
ffffffffc0200bf0:	97c2                	add	a5,a5,a6
ffffffffc0200bf2:	0792                	slli	a5,a5,0x4
ffffffffc0200bf4:	00091817          	auipc	a6,0x91
ffffffffc0200bf8:	a7480813          	addi	a6,a6,-1420 # ffffffffc0291668 <ide_devices>
ffffffffc0200bfc:	97c2                	add	a5,a5,a6
ffffffffc0200bfe:	0007a883          	lw	a7,0(a5)
ffffffffc0200c02:	02088563          	beqz	a7,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200c06:	100008b7          	lui	a7,0x10000
ffffffffc0200c0a:	0515f163          	bgeu	a1,a7,ffffffffc0200c4c <ide_write_secs+0x76>
ffffffffc0200c0e:	1582                	slli	a1,a1,0x20
ffffffffc0200c10:	9181                	srli	a1,a1,0x20
ffffffffc0200c12:	00d58733          	add	a4,a1,a3
ffffffffc0200c16:	02e8eb63          	bltu	a7,a4,ffffffffc0200c4c <ide_write_secs+0x76>
ffffffffc0200c1a:	00251713          	slli	a4,a0,0x2
ffffffffc0200c1e:	60a2                	ld	ra,8(sp)
ffffffffc0200c20:	67bc                	ld	a5,72(a5)
ffffffffc0200c22:	953a                	add	a0,a0,a4
ffffffffc0200c24:	0512                	slli	a0,a0,0x4
ffffffffc0200c26:	9542                	add	a0,a0,a6
ffffffffc0200c28:	0141                	addi	sp,sp,16
ffffffffc0200c2a:	8782                	jr	a5
ffffffffc0200c2c:	0000b697          	auipc	a3,0xb
ffffffffc0200c30:	0e468693          	addi	a3,a3,228 # ffffffffc020bd10 <commands+0x258>
ffffffffc0200c34:	0000b617          	auipc	a2,0xb
ffffffffc0200c38:	09460613          	addi	a2,a2,148 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0200c3c:	02900593          	li	a1,41
ffffffffc0200c40:	0000b517          	auipc	a0,0xb
ffffffffc0200c44:	0a050513          	addi	a0,a0,160 # ffffffffc020bce0 <commands+0x228>
ffffffffc0200c48:	857ff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200c4c:	0000b697          	auipc	a3,0xb
ffffffffc0200c50:	0ec68693          	addi	a3,a3,236 # ffffffffc020bd38 <commands+0x280>
ffffffffc0200c54:	0000b617          	auipc	a2,0xb
ffffffffc0200c58:	07460613          	addi	a2,a2,116 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0200c5c:	02a00593          	li	a1,42
ffffffffc0200c60:	0000b517          	auipc	a0,0xb
ffffffffc0200c64:	08050513          	addi	a0,a0,128 # ffffffffc020bce0 <commands+0x228>
ffffffffc0200c68:	837ff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200c6c <intr_enable>:
ffffffffc0200c6c:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200c70:	8082                	ret

ffffffffc0200c72 <intr_disable>:
ffffffffc0200c72:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200c76:	8082                	ret

ffffffffc0200c78 <pic_init>:
ffffffffc0200c78:	8082                	ret

ffffffffc0200c7a <ramdisk_write>:
ffffffffc0200c7a:	00856703          	lwu	a4,8(a0)
ffffffffc0200c7e:	1141                	addi	sp,sp,-16
ffffffffc0200c80:	e406                	sd	ra,8(sp)
ffffffffc0200c82:	8f0d                	sub	a4,a4,a1
ffffffffc0200c84:	87ae                	mv	a5,a1
ffffffffc0200c86:	85b2                	mv	a1,a2
ffffffffc0200c88:	00e6f363          	bgeu	a3,a4,ffffffffc0200c8e <ramdisk_write+0x14>
ffffffffc0200c8c:	8736                	mv	a4,a3
ffffffffc0200c8e:	6908                	ld	a0,16(a0)
ffffffffc0200c90:	07a6                	slli	a5,a5,0x9
ffffffffc0200c92:	00971613          	slli	a2,a4,0x9
ffffffffc0200c96:	953e                	add	a0,a0,a5
ffffffffc0200c98:	3a10a0ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc0200c9c:	60a2                	ld	ra,8(sp)
ffffffffc0200c9e:	4501                	li	a0,0
ffffffffc0200ca0:	0141                	addi	sp,sp,16
ffffffffc0200ca2:	8082                	ret

ffffffffc0200ca4 <ramdisk_read>:
ffffffffc0200ca4:	00856783          	lwu	a5,8(a0)
ffffffffc0200ca8:	1141                	addi	sp,sp,-16
ffffffffc0200caa:	e406                	sd	ra,8(sp)
ffffffffc0200cac:	8f8d                	sub	a5,a5,a1
ffffffffc0200cae:	872a                	mv	a4,a0
ffffffffc0200cb0:	8532                	mv	a0,a2
ffffffffc0200cb2:	00f6f363          	bgeu	a3,a5,ffffffffc0200cb8 <ramdisk_read+0x14>
ffffffffc0200cb6:	87b6                	mv	a5,a3
ffffffffc0200cb8:	6b18                	ld	a4,16(a4)
ffffffffc0200cba:	05a6                	slli	a1,a1,0x9
ffffffffc0200cbc:	00979613          	slli	a2,a5,0x9
ffffffffc0200cc0:	95ba                	add	a1,a1,a4
ffffffffc0200cc2:	3770a0ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc0200cc6:	60a2                	ld	ra,8(sp)
ffffffffc0200cc8:	4501                	li	a0,0
ffffffffc0200cca:	0141                	addi	sp,sp,16
ffffffffc0200ccc:	8082                	ret

ffffffffc0200cce <ramdisk_init>:
ffffffffc0200cce:	1101                	addi	sp,sp,-32
ffffffffc0200cd0:	e822                	sd	s0,16(sp)
ffffffffc0200cd2:	842e                	mv	s0,a1
ffffffffc0200cd4:	e426                	sd	s1,8(sp)
ffffffffc0200cd6:	05000613          	li	a2,80
ffffffffc0200cda:	84aa                	mv	s1,a0
ffffffffc0200cdc:	4581                	li	a1,0
ffffffffc0200cde:	8522                	mv	a0,s0
ffffffffc0200ce0:	ec06                	sd	ra,24(sp)
ffffffffc0200ce2:	e04a                	sd	s2,0(sp)
ffffffffc0200ce4:	3030a0ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0200ce8:	4785                	li	a5,1
ffffffffc0200cea:	06f48b63          	beq	s1,a5,ffffffffc0200d60 <ramdisk_init+0x92>
ffffffffc0200cee:	4789                	li	a5,2
ffffffffc0200cf0:	00090617          	auipc	a2,0x90
ffffffffc0200cf4:	32060613          	addi	a2,a2,800 # ffffffffc0291010 <arena>
ffffffffc0200cf8:	0001b917          	auipc	s2,0x1b
ffffffffc0200cfc:	01890913          	addi	s2,s2,24 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200d00:	08f49563          	bne	s1,a5,ffffffffc0200d8a <ramdisk_init+0xbc>
ffffffffc0200d04:	06c90863          	beq	s2,a2,ffffffffc0200d74 <ramdisk_init+0xa6>
ffffffffc0200d08:	412604b3          	sub	s1,a2,s2
ffffffffc0200d0c:	86a6                	mv	a3,s1
ffffffffc0200d0e:	85ca                	mv	a1,s2
ffffffffc0200d10:	167d                	addi	a2,a2,-1
ffffffffc0200d12:	0000b517          	auipc	a0,0xb
ffffffffc0200d16:	07e50513          	addi	a0,a0,126 # ffffffffc020bd90 <commands+0x2d8>
ffffffffc0200d1a:	c8cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200d1e:	57fd                	li	a5,-1
ffffffffc0200d20:	1782                	slli	a5,a5,0x20
ffffffffc0200d22:	0785                	addi	a5,a5,1
ffffffffc0200d24:	0094d49b          	srliw	s1,s1,0x9
ffffffffc0200d28:	e01c                	sd	a5,0(s0)
ffffffffc0200d2a:	c404                	sw	s1,8(s0)
ffffffffc0200d2c:	01243823          	sd	s2,16(s0)
ffffffffc0200d30:	02040513          	addi	a0,s0,32
ffffffffc0200d34:	0000b597          	auipc	a1,0xb
ffffffffc0200d38:	0b458593          	addi	a1,a1,180 # ffffffffc020bde8 <commands+0x330>
ffffffffc0200d3c:	23f0a0ef          	jal	ra,ffffffffc020b77a <strcpy>
ffffffffc0200d40:	00000797          	auipc	a5,0x0
ffffffffc0200d44:	f6478793          	addi	a5,a5,-156 # ffffffffc0200ca4 <ramdisk_read>
ffffffffc0200d48:	e03c                	sd	a5,64(s0)
ffffffffc0200d4a:	00000797          	auipc	a5,0x0
ffffffffc0200d4e:	f3078793          	addi	a5,a5,-208 # ffffffffc0200c7a <ramdisk_write>
ffffffffc0200d52:	60e2                	ld	ra,24(sp)
ffffffffc0200d54:	e43c                	sd	a5,72(s0)
ffffffffc0200d56:	6442                	ld	s0,16(sp)
ffffffffc0200d58:	64a2                	ld	s1,8(sp)
ffffffffc0200d5a:	6902                	ld	s2,0(sp)
ffffffffc0200d5c:	6105                	addi	sp,sp,32
ffffffffc0200d5e:	8082                	ret
ffffffffc0200d60:	0001b617          	auipc	a2,0x1b
ffffffffc0200d64:	fb060613          	addi	a2,a2,-80 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200d68:	00013917          	auipc	s2,0x13
ffffffffc0200d6c:	2a890913          	addi	s2,s2,680 # ffffffffc0214010 <_binary_bin_swap_img_start>
ffffffffc0200d70:	f8c91ce3          	bne	s2,a2,ffffffffc0200d08 <ramdisk_init+0x3a>
ffffffffc0200d74:	6442                	ld	s0,16(sp)
ffffffffc0200d76:	60e2                	ld	ra,24(sp)
ffffffffc0200d78:	64a2                	ld	s1,8(sp)
ffffffffc0200d7a:	6902                	ld	s2,0(sp)
ffffffffc0200d7c:	0000b517          	auipc	a0,0xb
ffffffffc0200d80:	ffc50513          	addi	a0,a0,-4 # ffffffffc020bd78 <commands+0x2c0>
ffffffffc0200d84:	6105                	addi	sp,sp,32
ffffffffc0200d86:	c20ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200d8a:	0000b617          	auipc	a2,0xb
ffffffffc0200d8e:	02e60613          	addi	a2,a2,46 # ffffffffc020bdb8 <commands+0x300>
ffffffffc0200d92:	03200593          	li	a1,50
ffffffffc0200d96:	0000b517          	auipc	a0,0xb
ffffffffc0200d9a:	03a50513          	addi	a0,a0,58 # ffffffffc020bdd0 <commands+0x318>
ffffffffc0200d9e:	f00ff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200da2 <idt_init>:
ffffffffc0200da2:	14005073          	csrwi	sscratch,0
ffffffffc0200da6:	00000797          	auipc	a5,0x0
ffffffffc0200daa:	4be78793          	addi	a5,a5,1214 # ffffffffc0201264 <__alltraps>
ffffffffc0200dae:	10579073          	csrw	stvec,a5
ffffffffc0200db2:	000407b7          	lui	a5,0x40
ffffffffc0200db6:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200dba:	8082                	ret

ffffffffc0200dbc <print_regs>:
ffffffffc0200dbc:	610c                	ld	a1,0(a0)
ffffffffc0200dbe:	1141                	addi	sp,sp,-16
ffffffffc0200dc0:	e022                	sd	s0,0(sp)
ffffffffc0200dc2:	842a                	mv	s0,a0
ffffffffc0200dc4:	0000b517          	auipc	a0,0xb
ffffffffc0200dc8:	03450513          	addi	a0,a0,52 # ffffffffc020bdf8 <commands+0x340>
ffffffffc0200dcc:	e406                	sd	ra,8(sp)
ffffffffc0200dce:	bd8ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dd2:	640c                	ld	a1,8(s0)
ffffffffc0200dd4:	0000b517          	auipc	a0,0xb
ffffffffc0200dd8:	03c50513          	addi	a0,a0,60 # ffffffffc020be10 <commands+0x358>
ffffffffc0200ddc:	bcaff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200de0:	680c                	ld	a1,16(s0)
ffffffffc0200de2:	0000b517          	auipc	a0,0xb
ffffffffc0200de6:	04650513          	addi	a0,a0,70 # ffffffffc020be28 <commands+0x370>
ffffffffc0200dea:	bbcff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dee:	6c0c                	ld	a1,24(s0)
ffffffffc0200df0:	0000b517          	auipc	a0,0xb
ffffffffc0200df4:	05050513          	addi	a0,a0,80 # ffffffffc020be40 <commands+0x388>
ffffffffc0200df8:	baeff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dfc:	700c                	ld	a1,32(s0)
ffffffffc0200dfe:	0000b517          	auipc	a0,0xb
ffffffffc0200e02:	05a50513          	addi	a0,a0,90 # ffffffffc020be58 <commands+0x3a0>
ffffffffc0200e06:	ba0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e0a:	740c                	ld	a1,40(s0)
ffffffffc0200e0c:	0000b517          	auipc	a0,0xb
ffffffffc0200e10:	06450513          	addi	a0,a0,100 # ffffffffc020be70 <commands+0x3b8>
ffffffffc0200e14:	b92ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e18:	780c                	ld	a1,48(s0)
ffffffffc0200e1a:	0000b517          	auipc	a0,0xb
ffffffffc0200e1e:	06e50513          	addi	a0,a0,110 # ffffffffc020be88 <commands+0x3d0>
ffffffffc0200e22:	b84ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e26:	7c0c                	ld	a1,56(s0)
ffffffffc0200e28:	0000b517          	auipc	a0,0xb
ffffffffc0200e2c:	07850513          	addi	a0,a0,120 # ffffffffc020bea0 <commands+0x3e8>
ffffffffc0200e30:	b76ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e34:	602c                	ld	a1,64(s0)
ffffffffc0200e36:	0000b517          	auipc	a0,0xb
ffffffffc0200e3a:	08250513          	addi	a0,a0,130 # ffffffffc020beb8 <commands+0x400>
ffffffffc0200e3e:	b68ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e42:	642c                	ld	a1,72(s0)
ffffffffc0200e44:	0000b517          	auipc	a0,0xb
ffffffffc0200e48:	08c50513          	addi	a0,a0,140 # ffffffffc020bed0 <commands+0x418>
ffffffffc0200e4c:	b5aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e50:	682c                	ld	a1,80(s0)
ffffffffc0200e52:	0000b517          	auipc	a0,0xb
ffffffffc0200e56:	09650513          	addi	a0,a0,150 # ffffffffc020bee8 <commands+0x430>
ffffffffc0200e5a:	b4cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e5e:	6c2c                	ld	a1,88(s0)
ffffffffc0200e60:	0000b517          	auipc	a0,0xb
ffffffffc0200e64:	0a050513          	addi	a0,a0,160 # ffffffffc020bf00 <commands+0x448>
ffffffffc0200e68:	b3eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e6c:	702c                	ld	a1,96(s0)
ffffffffc0200e6e:	0000b517          	auipc	a0,0xb
ffffffffc0200e72:	0aa50513          	addi	a0,a0,170 # ffffffffc020bf18 <commands+0x460>
ffffffffc0200e76:	b30ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e7a:	742c                	ld	a1,104(s0)
ffffffffc0200e7c:	0000b517          	auipc	a0,0xb
ffffffffc0200e80:	0b450513          	addi	a0,a0,180 # ffffffffc020bf30 <commands+0x478>
ffffffffc0200e84:	b22ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e88:	782c                	ld	a1,112(s0)
ffffffffc0200e8a:	0000b517          	auipc	a0,0xb
ffffffffc0200e8e:	0be50513          	addi	a0,a0,190 # ffffffffc020bf48 <commands+0x490>
ffffffffc0200e92:	b14ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e96:	7c2c                	ld	a1,120(s0)
ffffffffc0200e98:	0000b517          	auipc	a0,0xb
ffffffffc0200e9c:	0c850513          	addi	a0,a0,200 # ffffffffc020bf60 <commands+0x4a8>
ffffffffc0200ea0:	b06ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ea4:	604c                	ld	a1,128(s0)
ffffffffc0200ea6:	0000b517          	auipc	a0,0xb
ffffffffc0200eaa:	0d250513          	addi	a0,a0,210 # ffffffffc020bf78 <commands+0x4c0>
ffffffffc0200eae:	af8ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200eb2:	644c                	ld	a1,136(s0)
ffffffffc0200eb4:	0000b517          	auipc	a0,0xb
ffffffffc0200eb8:	0dc50513          	addi	a0,a0,220 # ffffffffc020bf90 <commands+0x4d8>
ffffffffc0200ebc:	aeaff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ec0:	684c                	ld	a1,144(s0)
ffffffffc0200ec2:	0000b517          	auipc	a0,0xb
ffffffffc0200ec6:	0e650513          	addi	a0,a0,230 # ffffffffc020bfa8 <commands+0x4f0>
ffffffffc0200eca:	adcff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ece:	6c4c                	ld	a1,152(s0)
ffffffffc0200ed0:	0000b517          	auipc	a0,0xb
ffffffffc0200ed4:	0f050513          	addi	a0,a0,240 # ffffffffc020bfc0 <commands+0x508>
ffffffffc0200ed8:	aceff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200edc:	704c                	ld	a1,160(s0)
ffffffffc0200ede:	0000b517          	auipc	a0,0xb
ffffffffc0200ee2:	0fa50513          	addi	a0,a0,250 # ffffffffc020bfd8 <commands+0x520>
ffffffffc0200ee6:	ac0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200eea:	744c                	ld	a1,168(s0)
ffffffffc0200eec:	0000b517          	auipc	a0,0xb
ffffffffc0200ef0:	10450513          	addi	a0,a0,260 # ffffffffc020bff0 <commands+0x538>
ffffffffc0200ef4:	ab2ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ef8:	784c                	ld	a1,176(s0)
ffffffffc0200efa:	0000b517          	auipc	a0,0xb
ffffffffc0200efe:	10e50513          	addi	a0,a0,270 # ffffffffc020c008 <commands+0x550>
ffffffffc0200f02:	aa4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f06:	7c4c                	ld	a1,184(s0)
ffffffffc0200f08:	0000b517          	auipc	a0,0xb
ffffffffc0200f0c:	11850513          	addi	a0,a0,280 # ffffffffc020c020 <commands+0x568>
ffffffffc0200f10:	a96ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f14:	606c                	ld	a1,192(s0)
ffffffffc0200f16:	0000b517          	auipc	a0,0xb
ffffffffc0200f1a:	12250513          	addi	a0,a0,290 # ffffffffc020c038 <commands+0x580>
ffffffffc0200f1e:	a88ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f22:	646c                	ld	a1,200(s0)
ffffffffc0200f24:	0000b517          	auipc	a0,0xb
ffffffffc0200f28:	12c50513          	addi	a0,a0,300 # ffffffffc020c050 <commands+0x598>
ffffffffc0200f2c:	a7aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f30:	686c                	ld	a1,208(s0)
ffffffffc0200f32:	0000b517          	auipc	a0,0xb
ffffffffc0200f36:	13650513          	addi	a0,a0,310 # ffffffffc020c068 <commands+0x5b0>
ffffffffc0200f3a:	a6cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f3e:	6c6c                	ld	a1,216(s0)
ffffffffc0200f40:	0000b517          	auipc	a0,0xb
ffffffffc0200f44:	14050513          	addi	a0,a0,320 # ffffffffc020c080 <commands+0x5c8>
ffffffffc0200f48:	a5eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f4c:	706c                	ld	a1,224(s0)
ffffffffc0200f4e:	0000b517          	auipc	a0,0xb
ffffffffc0200f52:	14a50513          	addi	a0,a0,330 # ffffffffc020c098 <commands+0x5e0>
ffffffffc0200f56:	a50ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f5a:	746c                	ld	a1,232(s0)
ffffffffc0200f5c:	0000b517          	auipc	a0,0xb
ffffffffc0200f60:	15450513          	addi	a0,a0,340 # ffffffffc020c0b0 <commands+0x5f8>
ffffffffc0200f64:	a42ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f68:	786c                	ld	a1,240(s0)
ffffffffc0200f6a:	0000b517          	auipc	a0,0xb
ffffffffc0200f6e:	15e50513          	addi	a0,a0,350 # ffffffffc020c0c8 <commands+0x610>
ffffffffc0200f72:	a34ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f76:	7c6c                	ld	a1,248(s0)
ffffffffc0200f78:	6402                	ld	s0,0(sp)
ffffffffc0200f7a:	60a2                	ld	ra,8(sp)
ffffffffc0200f7c:	0000b517          	auipc	a0,0xb
ffffffffc0200f80:	16450513          	addi	a0,a0,356 # ffffffffc020c0e0 <commands+0x628>
ffffffffc0200f84:	0141                	addi	sp,sp,16
ffffffffc0200f86:	a20ff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200f8a <print_trapframe>:
ffffffffc0200f8a:	1141                	addi	sp,sp,-16
ffffffffc0200f8c:	e022                	sd	s0,0(sp)
ffffffffc0200f8e:	85aa                	mv	a1,a0
ffffffffc0200f90:	842a                	mv	s0,a0
ffffffffc0200f92:	0000b517          	auipc	a0,0xb
ffffffffc0200f96:	16650513          	addi	a0,a0,358 # ffffffffc020c0f8 <commands+0x640>
ffffffffc0200f9a:	e406                	sd	ra,8(sp)
ffffffffc0200f9c:	a0aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fa0:	8522                	mv	a0,s0
ffffffffc0200fa2:	e1bff0ef          	jal	ra,ffffffffc0200dbc <print_regs>
ffffffffc0200fa6:	10043583          	ld	a1,256(s0)
ffffffffc0200faa:	0000b517          	auipc	a0,0xb
ffffffffc0200fae:	16650513          	addi	a0,a0,358 # ffffffffc020c110 <commands+0x658>
ffffffffc0200fb2:	9f4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fb6:	10843583          	ld	a1,264(s0)
ffffffffc0200fba:	0000b517          	auipc	a0,0xb
ffffffffc0200fbe:	16e50513          	addi	a0,a0,366 # ffffffffc020c128 <commands+0x670>
ffffffffc0200fc2:	9e4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fc6:	11043583          	ld	a1,272(s0)
ffffffffc0200fca:	0000b517          	auipc	a0,0xb
ffffffffc0200fce:	17650513          	addi	a0,a0,374 # ffffffffc020c140 <commands+0x688>
ffffffffc0200fd2:	9d4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fd6:	11843583          	ld	a1,280(s0)
ffffffffc0200fda:	6402                	ld	s0,0(sp)
ffffffffc0200fdc:	60a2                	ld	ra,8(sp)
ffffffffc0200fde:	0000b517          	auipc	a0,0xb
ffffffffc0200fe2:	17250513          	addi	a0,a0,370 # ffffffffc020c150 <commands+0x698>
ffffffffc0200fe6:	0141                	addi	sp,sp,16
ffffffffc0200fe8:	9beff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200fec <interrupt_handler>:
ffffffffc0200fec:	11853783          	ld	a5,280(a0)
ffffffffc0200ff0:	472d                	li	a4,11
ffffffffc0200ff2:	0786                	slli	a5,a5,0x1
ffffffffc0200ff4:	8385                	srli	a5,a5,0x1
ffffffffc0200ff6:	06f76c63          	bltu	a4,a5,ffffffffc020106e <interrupt_handler+0x82>
ffffffffc0200ffa:	0000b717          	auipc	a4,0xb
ffffffffc0200ffe:	20e70713          	addi	a4,a4,526 # ffffffffc020c208 <commands+0x750>
ffffffffc0201002:	078a                	slli	a5,a5,0x2
ffffffffc0201004:	97ba                	add	a5,a5,a4
ffffffffc0201006:	439c                	lw	a5,0(a5)
ffffffffc0201008:	97ba                	add	a5,a5,a4
ffffffffc020100a:	8782                	jr	a5
ffffffffc020100c:	0000b517          	auipc	a0,0xb
ffffffffc0201010:	1bc50513          	addi	a0,a0,444 # ffffffffc020c1c8 <commands+0x710>
ffffffffc0201014:	992ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201018:	0000b517          	auipc	a0,0xb
ffffffffc020101c:	19050513          	addi	a0,a0,400 # ffffffffc020c1a8 <commands+0x6f0>
ffffffffc0201020:	986ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201024:	0000b517          	auipc	a0,0xb
ffffffffc0201028:	14450513          	addi	a0,a0,324 # ffffffffc020c168 <commands+0x6b0>
ffffffffc020102c:	97aff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201030:	0000b517          	auipc	a0,0xb
ffffffffc0201034:	15850513          	addi	a0,a0,344 # ffffffffc020c188 <commands+0x6d0>
ffffffffc0201038:	96eff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020103c:	1141                	addi	sp,sp,-16
ffffffffc020103e:	e406                	sd	ra,8(sp)
ffffffffc0201040:	d3aff0ef          	jal	ra,ffffffffc020057a <clock_set_next_event>
ffffffffc0201044:	00096717          	auipc	a4,0x96
ffffffffc0201048:	82c70713          	addi	a4,a4,-2004 # ffffffffc0296870 <ticks>
ffffffffc020104c:	631c                	ld	a5,0(a4)
ffffffffc020104e:	0785                	addi	a5,a5,1
ffffffffc0201050:	e31c                	sd	a5,0(a4)
ffffffffc0201052:	039060ef          	jal	ra,ffffffffc020788a <run_timer_list>
ffffffffc0201056:	d9eff0ef          	jal	ra,ffffffffc02005f4 <cons_getc>
ffffffffc020105a:	60a2                	ld	ra,8(sp)
ffffffffc020105c:	0141                	addi	sp,sp,16
ffffffffc020105e:	6fd0706f          	j	ffffffffc0208f5a <dev_stdin_write>
ffffffffc0201062:	0000b517          	auipc	a0,0xb
ffffffffc0201066:	18650513          	addi	a0,a0,390 # ffffffffc020c1e8 <commands+0x730>
ffffffffc020106a:	93cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020106e:	bf31                	j	ffffffffc0200f8a <print_trapframe>

ffffffffc0201070 <exception_handler>:
ffffffffc0201070:	11853583          	ld	a1,280(a0)
ffffffffc0201074:	1101                	addi	sp,sp,-32
ffffffffc0201076:	e822                	sd	s0,16(sp)
ffffffffc0201078:	ec06                	sd	ra,24(sp)
ffffffffc020107a:	e426                	sd	s1,8(sp)
ffffffffc020107c:	e04a                	sd	s2,0(sp)
ffffffffc020107e:	47bd                	li	a5,15
ffffffffc0201080:	842a                	mv	s0,a0
ffffffffc0201082:	0cb7eb63          	bltu	a5,a1,ffffffffc0201158 <exception_handler+0xe8>
ffffffffc0201086:	0000b697          	auipc	a3,0xb
ffffffffc020108a:	36268693          	addi	a3,a3,866 # ffffffffc020c3e8 <commands+0x930>
ffffffffc020108e:	00259713          	slli	a4,a1,0x2
ffffffffc0201092:	9736                	add	a4,a4,a3
ffffffffc0201094:	431c                	lw	a5,0(a4)
ffffffffc0201096:	97b6                	add	a5,a5,a3
ffffffffc0201098:	8782                	jr	a5
ffffffffc020109a:	00096917          	auipc	s2,0x96
ffffffffc020109e:	83690913          	addi	s2,s2,-1994 # ffffffffc02968d0 <current>
ffffffffc02010a2:	00093783          	ld	a5,0(s2)
ffffffffc02010a6:	11053483          	ld	s1,272(a0)
ffffffffc02010aa:	cbf1                	beqz	a5,ffffffffc020117e <exception_handler+0x10e>
ffffffffc02010ac:	7788                	ld	a0,40(a5)
ffffffffc02010ae:	c961                	beqz	a0,ffffffffc020117e <exception_handler+0x10e>
ffffffffc02010b0:	15c5                	addi	a1,a1,-15
ffffffffc02010b2:	0015b593          	seqz	a1,a1
ffffffffc02010b6:	8626                	mv	a2,s1
ffffffffc02010b8:	0586                	slli	a1,a1,0x1
ffffffffc02010ba:	3c5020ef          	jal	ra,ffffffffc0203c7e <do_pgfault>
ffffffffc02010be:	0e051663          	bnez	a0,ffffffffc02011aa <exception_handler+0x13a>
ffffffffc02010c2:	60e2                	ld	ra,24(sp)
ffffffffc02010c4:	6442                	ld	s0,16(sp)
ffffffffc02010c6:	64a2                	ld	s1,8(sp)
ffffffffc02010c8:	6902                	ld	s2,0(sp)
ffffffffc02010ca:	6105                	addi	sp,sp,32
ffffffffc02010cc:	8082                	ret
ffffffffc02010ce:	0000b517          	auipc	a0,0xb
ffffffffc02010d2:	25250513          	addi	a0,a0,594 # ffffffffc020c320 <commands+0x868>
ffffffffc02010d6:	8d0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02010da:	10843783          	ld	a5,264(s0)
ffffffffc02010de:	60e2                	ld	ra,24(sp)
ffffffffc02010e0:	64a2                	ld	s1,8(sp)
ffffffffc02010e2:	0791                	addi	a5,a5,4
ffffffffc02010e4:	10f43423          	sd	a5,264(s0)
ffffffffc02010e8:	6442                	ld	s0,16(sp)
ffffffffc02010ea:	6902                	ld	s2,0(sp)
ffffffffc02010ec:	6105                	addi	sp,sp,32
ffffffffc02010ee:	1b30606f          	j	ffffffffc0207aa0 <syscall>
ffffffffc02010f2:	0000b517          	auipc	a0,0xb
ffffffffc02010f6:	14650513          	addi	a0,a0,326 # ffffffffc020c238 <commands+0x780>
ffffffffc02010fa:	6442                	ld	s0,16(sp)
ffffffffc02010fc:	60e2                	ld	ra,24(sp)
ffffffffc02010fe:	64a2                	ld	s1,8(sp)
ffffffffc0201100:	6902                	ld	s2,0(sp)
ffffffffc0201102:	6105                	addi	sp,sp,32
ffffffffc0201104:	8a2ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201108:	0000b517          	auipc	a0,0xb
ffffffffc020110c:	15050513          	addi	a0,a0,336 # ffffffffc020c258 <commands+0x7a0>
ffffffffc0201110:	b7ed                	j	ffffffffc02010fa <exception_handler+0x8a>
ffffffffc0201112:	0000b517          	auipc	a0,0xb
ffffffffc0201116:	16650513          	addi	a0,a0,358 # ffffffffc020c278 <commands+0x7c0>
ffffffffc020111a:	b7c5                	j	ffffffffc02010fa <exception_handler+0x8a>
ffffffffc020111c:	0000b517          	auipc	a0,0xb
ffffffffc0201120:	24450513          	addi	a0,a0,580 # ffffffffc020c360 <commands+0x8a8>
ffffffffc0201124:	bfd9                	j	ffffffffc02010fa <exception_handler+0x8a>
ffffffffc0201126:	0000b517          	auipc	a0,0xb
ffffffffc020112a:	21a50513          	addi	a0,a0,538 # ffffffffc020c340 <commands+0x888>
ffffffffc020112e:	b7f1                	j	ffffffffc02010fa <exception_handler+0x8a>
ffffffffc0201130:	0000b517          	auipc	a0,0xb
ffffffffc0201134:	1d850513          	addi	a0,a0,472 # ffffffffc020c308 <commands+0x850>
ffffffffc0201138:	b7c9                	j	ffffffffc02010fa <exception_handler+0x8a>
ffffffffc020113a:	0000b517          	auipc	a0,0xb
ffffffffc020113e:	15650513          	addi	a0,a0,342 # ffffffffc020c290 <commands+0x7d8>
ffffffffc0201142:	bf65                	j	ffffffffc02010fa <exception_handler+0x8a>
ffffffffc0201144:	0000b517          	auipc	a0,0xb
ffffffffc0201148:	15c50513          	addi	a0,a0,348 # ffffffffc020c2a0 <commands+0x7e8>
ffffffffc020114c:	b77d                	j	ffffffffc02010fa <exception_handler+0x8a>
ffffffffc020114e:	0000b517          	auipc	a0,0xb
ffffffffc0201152:	17250513          	addi	a0,a0,370 # ffffffffc020c2c0 <commands+0x808>
ffffffffc0201156:	b755                	j	ffffffffc02010fa <exception_handler+0x8a>
ffffffffc0201158:	8522                	mv	a0,s0
ffffffffc020115a:	6442                	ld	s0,16(sp)
ffffffffc020115c:	60e2                	ld	ra,24(sp)
ffffffffc020115e:	64a2                	ld	s1,8(sp)
ffffffffc0201160:	6902                	ld	s2,0(sp)
ffffffffc0201162:	6105                	addi	sp,sp,32
ffffffffc0201164:	b51d                	j	ffffffffc0200f8a <print_trapframe>
ffffffffc0201166:	0000b617          	auipc	a2,0xb
ffffffffc020116a:	17260613          	addi	a2,a2,370 # ffffffffc020c2d8 <commands+0x820>
ffffffffc020116e:	0b100593          	li	a1,177
ffffffffc0201172:	0000b517          	auipc	a0,0xb
ffffffffc0201176:	17e50513          	addi	a0,a0,382 # ffffffffc020c2f0 <commands+0x838>
ffffffffc020117a:	b24ff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020117e:	85a6                	mv	a1,s1
ffffffffc0201180:	0000b517          	auipc	a0,0xb
ffffffffc0201184:	20050513          	addi	a0,a0,512 # ffffffffc020c380 <commands+0x8c8>
ffffffffc0201188:	81eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020118c:	8522                	mv	a0,s0
ffffffffc020118e:	dfdff0ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc0201192:	0000b617          	auipc	a2,0xb
ffffffffc0201196:	23e60613          	addi	a2,a2,574 # ffffffffc020c3d0 <commands+0x918>
ffffffffc020119a:	0e900593          	li	a1,233
ffffffffc020119e:	0000b517          	auipc	a0,0xb
ffffffffc02011a2:	15250513          	addi	a0,a0,338 # ffffffffc020c2f0 <commands+0x838>
ffffffffc02011a6:	af8ff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02011aa:	862a                	mv	a2,a0
ffffffffc02011ac:	85a6                	mv	a1,s1
ffffffffc02011ae:	0000b517          	auipc	a0,0xb
ffffffffc02011b2:	20250513          	addi	a0,a0,514 # ffffffffc020c3b0 <commands+0x8f8>
ffffffffc02011b6:	ff1fe0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02011ba:	00093783          	ld	a5,0(s2)
ffffffffc02011be:	c791                	beqz	a5,ffffffffc02011ca <exception_handler+0x15a>
ffffffffc02011c0:	10043783          	ld	a5,256(s0)
ffffffffc02011c4:	1007f793          	andi	a5,a5,256
ffffffffc02011c8:	e781                	bnez	a5,ffffffffc02011d0 <exception_handler+0x160>
ffffffffc02011ca:	555d                	li	a0,-9
ffffffffc02011cc:	078050ef          	jal	ra,ffffffffc0206244 <do_exit>
ffffffffc02011d0:	8522                	mv	a0,s0
ffffffffc02011d2:	db9ff0ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc02011d6:	bf75                	j	ffffffffc0201192 <exception_handler+0x122>

ffffffffc02011d8 <trap>:
ffffffffc02011d8:	1101                	addi	sp,sp,-32
ffffffffc02011da:	e822                	sd	s0,16(sp)
ffffffffc02011dc:	00095417          	auipc	s0,0x95
ffffffffc02011e0:	6f440413          	addi	s0,s0,1780 # ffffffffc02968d0 <current>
ffffffffc02011e4:	6018                	ld	a4,0(s0)
ffffffffc02011e6:	ec06                	sd	ra,24(sp)
ffffffffc02011e8:	e426                	sd	s1,8(sp)
ffffffffc02011ea:	e04a                	sd	s2,0(sp)
ffffffffc02011ec:	11853683          	ld	a3,280(a0)
ffffffffc02011f0:	cf1d                	beqz	a4,ffffffffc020122e <trap+0x56>
ffffffffc02011f2:	10053483          	ld	s1,256(a0)
ffffffffc02011f6:	0a073903          	ld	s2,160(a4)
ffffffffc02011fa:	f348                	sd	a0,160(a4)
ffffffffc02011fc:	1004f493          	andi	s1,s1,256
ffffffffc0201200:	0206c463          	bltz	a3,ffffffffc0201228 <trap+0x50>
ffffffffc0201204:	e6dff0ef          	jal	ra,ffffffffc0201070 <exception_handler>
ffffffffc0201208:	601c                	ld	a5,0(s0)
ffffffffc020120a:	0b27b023          	sd	s2,160(a5) # 400a0 <_binary_bin_swap_img_size+0x383a0>
ffffffffc020120e:	e499                	bnez	s1,ffffffffc020121c <trap+0x44>
ffffffffc0201210:	0b07a703          	lw	a4,176(a5)
ffffffffc0201214:	8b05                	andi	a4,a4,1
ffffffffc0201216:	e329                	bnez	a4,ffffffffc0201258 <trap+0x80>
ffffffffc0201218:	6f9c                	ld	a5,24(a5)
ffffffffc020121a:	eb85                	bnez	a5,ffffffffc020124a <trap+0x72>
ffffffffc020121c:	60e2                	ld	ra,24(sp)
ffffffffc020121e:	6442                	ld	s0,16(sp)
ffffffffc0201220:	64a2                	ld	s1,8(sp)
ffffffffc0201222:	6902                	ld	s2,0(sp)
ffffffffc0201224:	6105                	addi	sp,sp,32
ffffffffc0201226:	8082                	ret
ffffffffc0201228:	dc5ff0ef          	jal	ra,ffffffffc0200fec <interrupt_handler>
ffffffffc020122c:	bff1                	j	ffffffffc0201208 <trap+0x30>
ffffffffc020122e:	0006c863          	bltz	a3,ffffffffc020123e <trap+0x66>
ffffffffc0201232:	6442                	ld	s0,16(sp)
ffffffffc0201234:	60e2                	ld	ra,24(sp)
ffffffffc0201236:	64a2                	ld	s1,8(sp)
ffffffffc0201238:	6902                	ld	s2,0(sp)
ffffffffc020123a:	6105                	addi	sp,sp,32
ffffffffc020123c:	bd15                	j	ffffffffc0201070 <exception_handler>
ffffffffc020123e:	6442                	ld	s0,16(sp)
ffffffffc0201240:	60e2                	ld	ra,24(sp)
ffffffffc0201242:	64a2                	ld	s1,8(sp)
ffffffffc0201244:	6902                	ld	s2,0(sp)
ffffffffc0201246:	6105                	addi	sp,sp,32
ffffffffc0201248:	b355                	j	ffffffffc0200fec <interrupt_handler>
ffffffffc020124a:	6442                	ld	s0,16(sp)
ffffffffc020124c:	60e2                	ld	ra,24(sp)
ffffffffc020124e:	64a2                	ld	s1,8(sp)
ffffffffc0201250:	6902                	ld	s2,0(sp)
ffffffffc0201252:	6105                	addi	sp,sp,32
ffffffffc0201254:	42a0606f          	j	ffffffffc020767e <schedule>
ffffffffc0201258:	555d                	li	a0,-9
ffffffffc020125a:	7eb040ef          	jal	ra,ffffffffc0206244 <do_exit>
ffffffffc020125e:	601c                	ld	a5,0(s0)
ffffffffc0201260:	bf65                	j	ffffffffc0201218 <trap+0x40>
	...

ffffffffc0201264 <__alltraps>:
ffffffffc0201264:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0201268:	00011463          	bnez	sp,ffffffffc0201270 <__alltraps+0xc>
ffffffffc020126c:	14002173          	csrr	sp,sscratch
ffffffffc0201270:	712d                	addi	sp,sp,-288
ffffffffc0201272:	e002                	sd	zero,0(sp)
ffffffffc0201274:	e406                	sd	ra,8(sp)
ffffffffc0201276:	ec0e                	sd	gp,24(sp)
ffffffffc0201278:	f012                	sd	tp,32(sp)
ffffffffc020127a:	f416                	sd	t0,40(sp)
ffffffffc020127c:	f81a                	sd	t1,48(sp)
ffffffffc020127e:	fc1e                	sd	t2,56(sp)
ffffffffc0201280:	e0a2                	sd	s0,64(sp)
ffffffffc0201282:	e4a6                	sd	s1,72(sp)
ffffffffc0201284:	e8aa                	sd	a0,80(sp)
ffffffffc0201286:	ecae                	sd	a1,88(sp)
ffffffffc0201288:	f0b2                	sd	a2,96(sp)
ffffffffc020128a:	f4b6                	sd	a3,104(sp)
ffffffffc020128c:	f8ba                	sd	a4,112(sp)
ffffffffc020128e:	fcbe                	sd	a5,120(sp)
ffffffffc0201290:	e142                	sd	a6,128(sp)
ffffffffc0201292:	e546                	sd	a7,136(sp)
ffffffffc0201294:	e94a                	sd	s2,144(sp)
ffffffffc0201296:	ed4e                	sd	s3,152(sp)
ffffffffc0201298:	f152                	sd	s4,160(sp)
ffffffffc020129a:	f556                	sd	s5,168(sp)
ffffffffc020129c:	f95a                	sd	s6,176(sp)
ffffffffc020129e:	fd5e                	sd	s7,184(sp)
ffffffffc02012a0:	e1e2                	sd	s8,192(sp)
ffffffffc02012a2:	e5e6                	sd	s9,200(sp)
ffffffffc02012a4:	e9ea                	sd	s10,208(sp)
ffffffffc02012a6:	edee                	sd	s11,216(sp)
ffffffffc02012a8:	f1f2                	sd	t3,224(sp)
ffffffffc02012aa:	f5f6                	sd	t4,232(sp)
ffffffffc02012ac:	f9fa                	sd	t5,240(sp)
ffffffffc02012ae:	fdfe                	sd	t6,248(sp)
ffffffffc02012b0:	14001473          	csrrw	s0,sscratch,zero
ffffffffc02012b4:	100024f3          	csrr	s1,sstatus
ffffffffc02012b8:	14102973          	csrr	s2,sepc
ffffffffc02012bc:	143029f3          	csrr	s3,stval
ffffffffc02012c0:	14202a73          	csrr	s4,scause
ffffffffc02012c4:	e822                	sd	s0,16(sp)
ffffffffc02012c6:	e226                	sd	s1,256(sp)
ffffffffc02012c8:	e64a                	sd	s2,264(sp)
ffffffffc02012ca:	ea4e                	sd	s3,272(sp)
ffffffffc02012cc:	ee52                	sd	s4,280(sp)
ffffffffc02012ce:	850a                	mv	a0,sp
ffffffffc02012d0:	f09ff0ef          	jal	ra,ffffffffc02011d8 <trap>

ffffffffc02012d4 <__trapret>:
ffffffffc02012d4:	6492                	ld	s1,256(sp)
ffffffffc02012d6:	6932                	ld	s2,264(sp)
ffffffffc02012d8:	1004f413          	andi	s0,s1,256
ffffffffc02012dc:	e401                	bnez	s0,ffffffffc02012e4 <__trapret+0x10>
ffffffffc02012de:	1200                	addi	s0,sp,288
ffffffffc02012e0:	14041073          	csrw	sscratch,s0
ffffffffc02012e4:	10049073          	csrw	sstatus,s1
ffffffffc02012e8:	14191073          	csrw	sepc,s2
ffffffffc02012ec:	60a2                	ld	ra,8(sp)
ffffffffc02012ee:	61e2                	ld	gp,24(sp)
ffffffffc02012f0:	7202                	ld	tp,32(sp)
ffffffffc02012f2:	72a2                	ld	t0,40(sp)
ffffffffc02012f4:	7342                	ld	t1,48(sp)
ffffffffc02012f6:	73e2                	ld	t2,56(sp)
ffffffffc02012f8:	6406                	ld	s0,64(sp)
ffffffffc02012fa:	64a6                	ld	s1,72(sp)
ffffffffc02012fc:	6546                	ld	a0,80(sp)
ffffffffc02012fe:	65e6                	ld	a1,88(sp)
ffffffffc0201300:	7606                	ld	a2,96(sp)
ffffffffc0201302:	76a6                	ld	a3,104(sp)
ffffffffc0201304:	7746                	ld	a4,112(sp)
ffffffffc0201306:	77e6                	ld	a5,120(sp)
ffffffffc0201308:	680a                	ld	a6,128(sp)
ffffffffc020130a:	68aa                	ld	a7,136(sp)
ffffffffc020130c:	694a                	ld	s2,144(sp)
ffffffffc020130e:	69ea                	ld	s3,152(sp)
ffffffffc0201310:	7a0a                	ld	s4,160(sp)
ffffffffc0201312:	7aaa                	ld	s5,168(sp)
ffffffffc0201314:	7b4a                	ld	s6,176(sp)
ffffffffc0201316:	7bea                	ld	s7,184(sp)
ffffffffc0201318:	6c0e                	ld	s8,192(sp)
ffffffffc020131a:	6cae                	ld	s9,200(sp)
ffffffffc020131c:	6d4e                	ld	s10,208(sp)
ffffffffc020131e:	6dee                	ld	s11,216(sp)
ffffffffc0201320:	7e0e                	ld	t3,224(sp)
ffffffffc0201322:	7eae                	ld	t4,232(sp)
ffffffffc0201324:	7f4e                	ld	t5,240(sp)
ffffffffc0201326:	7fee                	ld	t6,248(sp)
ffffffffc0201328:	6142                	ld	sp,16(sp)
ffffffffc020132a:	10200073          	sret

ffffffffc020132e <forkrets>:
ffffffffc020132e:	812a                	mv	sp,a0
ffffffffc0201330:	b755                	j	ffffffffc02012d4 <__trapret>

ffffffffc0201332 <default_init>:
ffffffffc0201332:	00090797          	auipc	a5,0x90
ffffffffc0201336:	47678793          	addi	a5,a5,1142 # ffffffffc02917a8 <free_area>
ffffffffc020133a:	e79c                	sd	a5,8(a5)
ffffffffc020133c:	e39c                	sd	a5,0(a5)
ffffffffc020133e:	0007a823          	sw	zero,16(a5)
ffffffffc0201342:	8082                	ret

ffffffffc0201344 <default_nr_free_pages>:
ffffffffc0201344:	00090517          	auipc	a0,0x90
ffffffffc0201348:	47456503          	lwu	a0,1140(a0) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020134c:	8082                	ret

ffffffffc020134e <default_check>:
ffffffffc020134e:	715d                	addi	sp,sp,-80
ffffffffc0201350:	e0a2                	sd	s0,64(sp)
ffffffffc0201352:	00090417          	auipc	s0,0x90
ffffffffc0201356:	45640413          	addi	s0,s0,1110 # ffffffffc02917a8 <free_area>
ffffffffc020135a:	641c                	ld	a5,8(s0)
ffffffffc020135c:	e486                	sd	ra,72(sp)
ffffffffc020135e:	fc26                	sd	s1,56(sp)
ffffffffc0201360:	f84a                	sd	s2,48(sp)
ffffffffc0201362:	f44e                	sd	s3,40(sp)
ffffffffc0201364:	f052                	sd	s4,32(sp)
ffffffffc0201366:	ec56                	sd	s5,24(sp)
ffffffffc0201368:	e85a                	sd	s6,16(sp)
ffffffffc020136a:	e45e                	sd	s7,8(sp)
ffffffffc020136c:	e062                	sd	s8,0(sp)
ffffffffc020136e:	2a878d63          	beq	a5,s0,ffffffffc0201628 <default_check+0x2da>
ffffffffc0201372:	4481                	li	s1,0
ffffffffc0201374:	4901                	li	s2,0
ffffffffc0201376:	ff07b703          	ld	a4,-16(a5)
ffffffffc020137a:	8b09                	andi	a4,a4,2
ffffffffc020137c:	2a070a63          	beqz	a4,ffffffffc0201630 <default_check+0x2e2>
ffffffffc0201380:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201384:	679c                	ld	a5,8(a5)
ffffffffc0201386:	2905                	addiw	s2,s2,1
ffffffffc0201388:	9cb9                	addw	s1,s1,a4
ffffffffc020138a:	fe8796e3          	bne	a5,s0,ffffffffc0201376 <default_check+0x28>
ffffffffc020138e:	89a6                	mv	s3,s1
ffffffffc0201390:	6df000ef          	jal	ra,ffffffffc020226e <nr_free_pages>
ffffffffc0201394:	6f351e63          	bne	a0,s3,ffffffffc0201a90 <default_check+0x742>
ffffffffc0201398:	4505                	li	a0,1
ffffffffc020139a:	657000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc020139e:	8aaa                	mv	s5,a0
ffffffffc02013a0:	42050863          	beqz	a0,ffffffffc02017d0 <default_check+0x482>
ffffffffc02013a4:	4505                	li	a0,1
ffffffffc02013a6:	64b000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc02013aa:	89aa                	mv	s3,a0
ffffffffc02013ac:	70050263          	beqz	a0,ffffffffc0201ab0 <default_check+0x762>
ffffffffc02013b0:	4505                	li	a0,1
ffffffffc02013b2:	63f000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc02013b6:	8a2a                	mv	s4,a0
ffffffffc02013b8:	48050c63          	beqz	a0,ffffffffc0201850 <default_check+0x502>
ffffffffc02013bc:	293a8a63          	beq	s5,s3,ffffffffc0201650 <default_check+0x302>
ffffffffc02013c0:	28aa8863          	beq	s5,a0,ffffffffc0201650 <default_check+0x302>
ffffffffc02013c4:	28a98663          	beq	s3,a0,ffffffffc0201650 <default_check+0x302>
ffffffffc02013c8:	000aa783          	lw	a5,0(s5)
ffffffffc02013cc:	2a079263          	bnez	a5,ffffffffc0201670 <default_check+0x322>
ffffffffc02013d0:	0009a783          	lw	a5,0(s3)
ffffffffc02013d4:	28079e63          	bnez	a5,ffffffffc0201670 <default_check+0x322>
ffffffffc02013d8:	411c                	lw	a5,0(a0)
ffffffffc02013da:	28079b63          	bnez	a5,ffffffffc0201670 <default_check+0x322>
ffffffffc02013de:	00095797          	auipc	a5,0x95
ffffffffc02013e2:	4ca7b783          	ld	a5,1226(a5) # ffffffffc02968a8 <pages>
ffffffffc02013e6:	40fa8733          	sub	a4,s5,a5
ffffffffc02013ea:	0000f617          	auipc	a2,0xf
ffffffffc02013ee:	94663603          	ld	a2,-1722(a2) # ffffffffc020fd30 <nbase>
ffffffffc02013f2:	8719                	srai	a4,a4,0x6
ffffffffc02013f4:	9732                	add	a4,a4,a2
ffffffffc02013f6:	00095697          	auipc	a3,0x95
ffffffffc02013fa:	4aa6b683          	ld	a3,1194(a3) # ffffffffc02968a0 <npage>
ffffffffc02013fe:	06b2                	slli	a3,a3,0xc
ffffffffc0201400:	0732                	slli	a4,a4,0xc
ffffffffc0201402:	28d77763          	bgeu	a4,a3,ffffffffc0201690 <default_check+0x342>
ffffffffc0201406:	40f98733          	sub	a4,s3,a5
ffffffffc020140a:	8719                	srai	a4,a4,0x6
ffffffffc020140c:	9732                	add	a4,a4,a2
ffffffffc020140e:	0732                	slli	a4,a4,0xc
ffffffffc0201410:	4cd77063          	bgeu	a4,a3,ffffffffc02018d0 <default_check+0x582>
ffffffffc0201414:	40f507b3          	sub	a5,a0,a5
ffffffffc0201418:	8799                	srai	a5,a5,0x6
ffffffffc020141a:	97b2                	add	a5,a5,a2
ffffffffc020141c:	07b2                	slli	a5,a5,0xc
ffffffffc020141e:	30d7f963          	bgeu	a5,a3,ffffffffc0201730 <default_check+0x3e2>
ffffffffc0201422:	4505                	li	a0,1
ffffffffc0201424:	00043c03          	ld	s8,0(s0)
ffffffffc0201428:	00843b83          	ld	s7,8(s0)
ffffffffc020142c:	01042b03          	lw	s6,16(s0)
ffffffffc0201430:	e400                	sd	s0,8(s0)
ffffffffc0201432:	e000                	sd	s0,0(s0)
ffffffffc0201434:	00090797          	auipc	a5,0x90
ffffffffc0201438:	3807a223          	sw	zero,900(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020143c:	5b5000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc0201440:	2c051863          	bnez	a0,ffffffffc0201710 <default_check+0x3c2>
ffffffffc0201444:	4585                	li	a1,1
ffffffffc0201446:	8556                	mv	a0,s5
ffffffffc0201448:	5e7000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc020144c:	4585                	li	a1,1
ffffffffc020144e:	854e                	mv	a0,s3
ffffffffc0201450:	5df000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc0201454:	4585                	li	a1,1
ffffffffc0201456:	8552                	mv	a0,s4
ffffffffc0201458:	5d7000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc020145c:	4818                	lw	a4,16(s0)
ffffffffc020145e:	478d                	li	a5,3
ffffffffc0201460:	28f71863          	bne	a4,a5,ffffffffc02016f0 <default_check+0x3a2>
ffffffffc0201464:	4505                	li	a0,1
ffffffffc0201466:	58b000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc020146a:	89aa                	mv	s3,a0
ffffffffc020146c:	26050263          	beqz	a0,ffffffffc02016d0 <default_check+0x382>
ffffffffc0201470:	4505                	li	a0,1
ffffffffc0201472:	57f000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc0201476:	8aaa                	mv	s5,a0
ffffffffc0201478:	3a050c63          	beqz	a0,ffffffffc0201830 <default_check+0x4e2>
ffffffffc020147c:	4505                	li	a0,1
ffffffffc020147e:	573000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc0201482:	8a2a                	mv	s4,a0
ffffffffc0201484:	38050663          	beqz	a0,ffffffffc0201810 <default_check+0x4c2>
ffffffffc0201488:	4505                	li	a0,1
ffffffffc020148a:	567000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc020148e:	36051163          	bnez	a0,ffffffffc02017f0 <default_check+0x4a2>
ffffffffc0201492:	4585                	li	a1,1
ffffffffc0201494:	854e                	mv	a0,s3
ffffffffc0201496:	599000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc020149a:	641c                	ld	a5,8(s0)
ffffffffc020149c:	20878a63          	beq	a5,s0,ffffffffc02016b0 <default_check+0x362>
ffffffffc02014a0:	4505                	li	a0,1
ffffffffc02014a2:	54f000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc02014a6:	30a99563          	bne	s3,a0,ffffffffc02017b0 <default_check+0x462>
ffffffffc02014aa:	4505                	li	a0,1
ffffffffc02014ac:	545000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc02014b0:	2e051063          	bnez	a0,ffffffffc0201790 <default_check+0x442>
ffffffffc02014b4:	481c                	lw	a5,16(s0)
ffffffffc02014b6:	2a079d63          	bnez	a5,ffffffffc0201770 <default_check+0x422>
ffffffffc02014ba:	854e                	mv	a0,s3
ffffffffc02014bc:	4585                	li	a1,1
ffffffffc02014be:	01843023          	sd	s8,0(s0)
ffffffffc02014c2:	01743423          	sd	s7,8(s0)
ffffffffc02014c6:	01642823          	sw	s6,16(s0)
ffffffffc02014ca:	565000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc02014ce:	4585                	li	a1,1
ffffffffc02014d0:	8556                	mv	a0,s5
ffffffffc02014d2:	55d000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc02014d6:	4585                	li	a1,1
ffffffffc02014d8:	8552                	mv	a0,s4
ffffffffc02014da:	555000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc02014de:	4515                	li	a0,5
ffffffffc02014e0:	511000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc02014e4:	89aa                	mv	s3,a0
ffffffffc02014e6:	26050563          	beqz	a0,ffffffffc0201750 <default_check+0x402>
ffffffffc02014ea:	651c                	ld	a5,8(a0)
ffffffffc02014ec:	8385                	srli	a5,a5,0x1
ffffffffc02014ee:	8b85                	andi	a5,a5,1
ffffffffc02014f0:	54079063          	bnez	a5,ffffffffc0201a30 <default_check+0x6e2>
ffffffffc02014f4:	4505                	li	a0,1
ffffffffc02014f6:	00043b03          	ld	s6,0(s0)
ffffffffc02014fa:	00843a83          	ld	s5,8(s0)
ffffffffc02014fe:	e000                	sd	s0,0(s0)
ffffffffc0201500:	e400                	sd	s0,8(s0)
ffffffffc0201502:	4ef000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc0201506:	50051563          	bnez	a0,ffffffffc0201a10 <default_check+0x6c2>
ffffffffc020150a:	08098a13          	addi	s4,s3,128
ffffffffc020150e:	8552                	mv	a0,s4
ffffffffc0201510:	458d                	li	a1,3
ffffffffc0201512:	01042b83          	lw	s7,16(s0)
ffffffffc0201516:	00090797          	auipc	a5,0x90
ffffffffc020151a:	2a07a123          	sw	zero,674(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020151e:	511000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc0201522:	4511                	li	a0,4
ffffffffc0201524:	4cd000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc0201528:	4c051463          	bnez	a0,ffffffffc02019f0 <default_check+0x6a2>
ffffffffc020152c:	0889b783          	ld	a5,136(s3)
ffffffffc0201530:	8385                	srli	a5,a5,0x1
ffffffffc0201532:	8b85                	andi	a5,a5,1
ffffffffc0201534:	48078e63          	beqz	a5,ffffffffc02019d0 <default_check+0x682>
ffffffffc0201538:	0909a703          	lw	a4,144(s3)
ffffffffc020153c:	478d                	li	a5,3
ffffffffc020153e:	48f71963          	bne	a4,a5,ffffffffc02019d0 <default_check+0x682>
ffffffffc0201542:	450d                	li	a0,3
ffffffffc0201544:	4ad000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc0201548:	8c2a                	mv	s8,a0
ffffffffc020154a:	46050363          	beqz	a0,ffffffffc02019b0 <default_check+0x662>
ffffffffc020154e:	4505                	li	a0,1
ffffffffc0201550:	4a1000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc0201554:	42051e63          	bnez	a0,ffffffffc0201990 <default_check+0x642>
ffffffffc0201558:	418a1c63          	bne	s4,s8,ffffffffc0201970 <default_check+0x622>
ffffffffc020155c:	4585                	li	a1,1
ffffffffc020155e:	854e                	mv	a0,s3
ffffffffc0201560:	4cf000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc0201564:	458d                	li	a1,3
ffffffffc0201566:	8552                	mv	a0,s4
ffffffffc0201568:	4c7000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc020156c:	0089b783          	ld	a5,8(s3)
ffffffffc0201570:	04098c13          	addi	s8,s3,64
ffffffffc0201574:	8385                	srli	a5,a5,0x1
ffffffffc0201576:	8b85                	andi	a5,a5,1
ffffffffc0201578:	3c078c63          	beqz	a5,ffffffffc0201950 <default_check+0x602>
ffffffffc020157c:	0109a703          	lw	a4,16(s3)
ffffffffc0201580:	4785                	li	a5,1
ffffffffc0201582:	3cf71763          	bne	a4,a5,ffffffffc0201950 <default_check+0x602>
ffffffffc0201586:	008a3783          	ld	a5,8(s4)
ffffffffc020158a:	8385                	srli	a5,a5,0x1
ffffffffc020158c:	8b85                	andi	a5,a5,1
ffffffffc020158e:	3a078163          	beqz	a5,ffffffffc0201930 <default_check+0x5e2>
ffffffffc0201592:	010a2703          	lw	a4,16(s4)
ffffffffc0201596:	478d                	li	a5,3
ffffffffc0201598:	38f71c63          	bne	a4,a5,ffffffffc0201930 <default_check+0x5e2>
ffffffffc020159c:	4505                	li	a0,1
ffffffffc020159e:	453000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc02015a2:	36a99763          	bne	s3,a0,ffffffffc0201910 <default_check+0x5c2>
ffffffffc02015a6:	4585                	li	a1,1
ffffffffc02015a8:	487000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc02015ac:	4509                	li	a0,2
ffffffffc02015ae:	443000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc02015b2:	32aa1f63          	bne	s4,a0,ffffffffc02018f0 <default_check+0x5a2>
ffffffffc02015b6:	4589                	li	a1,2
ffffffffc02015b8:	477000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc02015bc:	4585                	li	a1,1
ffffffffc02015be:	8562                	mv	a0,s8
ffffffffc02015c0:	46f000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc02015c4:	4515                	li	a0,5
ffffffffc02015c6:	42b000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc02015ca:	89aa                	mv	s3,a0
ffffffffc02015cc:	48050263          	beqz	a0,ffffffffc0201a50 <default_check+0x702>
ffffffffc02015d0:	4505                	li	a0,1
ffffffffc02015d2:	41f000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc02015d6:	2c051d63          	bnez	a0,ffffffffc02018b0 <default_check+0x562>
ffffffffc02015da:	481c                	lw	a5,16(s0)
ffffffffc02015dc:	2a079a63          	bnez	a5,ffffffffc0201890 <default_check+0x542>
ffffffffc02015e0:	4595                	li	a1,5
ffffffffc02015e2:	854e                	mv	a0,s3
ffffffffc02015e4:	01742823          	sw	s7,16(s0)
ffffffffc02015e8:	01643023          	sd	s6,0(s0)
ffffffffc02015ec:	01543423          	sd	s5,8(s0)
ffffffffc02015f0:	43f000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc02015f4:	641c                	ld	a5,8(s0)
ffffffffc02015f6:	00878963          	beq	a5,s0,ffffffffc0201608 <default_check+0x2ba>
ffffffffc02015fa:	ff87a703          	lw	a4,-8(a5)
ffffffffc02015fe:	679c                	ld	a5,8(a5)
ffffffffc0201600:	397d                	addiw	s2,s2,-1
ffffffffc0201602:	9c99                	subw	s1,s1,a4
ffffffffc0201604:	fe879be3          	bne	a5,s0,ffffffffc02015fa <default_check+0x2ac>
ffffffffc0201608:	26091463          	bnez	s2,ffffffffc0201870 <default_check+0x522>
ffffffffc020160c:	46049263          	bnez	s1,ffffffffc0201a70 <default_check+0x722>
ffffffffc0201610:	60a6                	ld	ra,72(sp)
ffffffffc0201612:	6406                	ld	s0,64(sp)
ffffffffc0201614:	74e2                	ld	s1,56(sp)
ffffffffc0201616:	7942                	ld	s2,48(sp)
ffffffffc0201618:	79a2                	ld	s3,40(sp)
ffffffffc020161a:	7a02                	ld	s4,32(sp)
ffffffffc020161c:	6ae2                	ld	s5,24(sp)
ffffffffc020161e:	6b42                	ld	s6,16(sp)
ffffffffc0201620:	6ba2                	ld	s7,8(sp)
ffffffffc0201622:	6c02                	ld	s8,0(sp)
ffffffffc0201624:	6161                	addi	sp,sp,80
ffffffffc0201626:	8082                	ret
ffffffffc0201628:	4981                	li	s3,0
ffffffffc020162a:	4481                	li	s1,0
ffffffffc020162c:	4901                	li	s2,0
ffffffffc020162e:	b38d                	j	ffffffffc0201390 <default_check+0x42>
ffffffffc0201630:	0000b697          	auipc	a3,0xb
ffffffffc0201634:	df868693          	addi	a3,a3,-520 # ffffffffc020c428 <commands+0x970>
ffffffffc0201638:	0000a617          	auipc	a2,0xa
ffffffffc020163c:	69060613          	addi	a2,a2,1680 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201640:	0ef00593          	li	a1,239
ffffffffc0201644:	0000b517          	auipc	a0,0xb
ffffffffc0201648:	df450513          	addi	a0,a0,-524 # ffffffffc020c438 <commands+0x980>
ffffffffc020164c:	e53fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201650:	0000b697          	auipc	a3,0xb
ffffffffc0201654:	e8068693          	addi	a3,a3,-384 # ffffffffc020c4d0 <commands+0xa18>
ffffffffc0201658:	0000a617          	auipc	a2,0xa
ffffffffc020165c:	67060613          	addi	a2,a2,1648 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201660:	0bc00593          	li	a1,188
ffffffffc0201664:	0000b517          	auipc	a0,0xb
ffffffffc0201668:	dd450513          	addi	a0,a0,-556 # ffffffffc020c438 <commands+0x980>
ffffffffc020166c:	e33fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201670:	0000b697          	auipc	a3,0xb
ffffffffc0201674:	e8868693          	addi	a3,a3,-376 # ffffffffc020c4f8 <commands+0xa40>
ffffffffc0201678:	0000a617          	auipc	a2,0xa
ffffffffc020167c:	65060613          	addi	a2,a2,1616 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201680:	0bd00593          	li	a1,189
ffffffffc0201684:	0000b517          	auipc	a0,0xb
ffffffffc0201688:	db450513          	addi	a0,a0,-588 # ffffffffc020c438 <commands+0x980>
ffffffffc020168c:	e13fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201690:	0000b697          	auipc	a3,0xb
ffffffffc0201694:	ea868693          	addi	a3,a3,-344 # ffffffffc020c538 <commands+0xa80>
ffffffffc0201698:	0000a617          	auipc	a2,0xa
ffffffffc020169c:	63060613          	addi	a2,a2,1584 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02016a0:	0bf00593          	li	a1,191
ffffffffc02016a4:	0000b517          	auipc	a0,0xb
ffffffffc02016a8:	d9450513          	addi	a0,a0,-620 # ffffffffc020c438 <commands+0x980>
ffffffffc02016ac:	df3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016b0:	0000b697          	auipc	a3,0xb
ffffffffc02016b4:	f1068693          	addi	a3,a3,-240 # ffffffffc020c5c0 <commands+0xb08>
ffffffffc02016b8:	0000a617          	auipc	a2,0xa
ffffffffc02016bc:	61060613          	addi	a2,a2,1552 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02016c0:	0d800593          	li	a1,216
ffffffffc02016c4:	0000b517          	auipc	a0,0xb
ffffffffc02016c8:	d7450513          	addi	a0,a0,-652 # ffffffffc020c438 <commands+0x980>
ffffffffc02016cc:	dd3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016d0:	0000b697          	auipc	a3,0xb
ffffffffc02016d4:	da068693          	addi	a3,a3,-608 # ffffffffc020c470 <commands+0x9b8>
ffffffffc02016d8:	0000a617          	auipc	a2,0xa
ffffffffc02016dc:	5f060613          	addi	a2,a2,1520 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02016e0:	0d100593          	li	a1,209
ffffffffc02016e4:	0000b517          	auipc	a0,0xb
ffffffffc02016e8:	d5450513          	addi	a0,a0,-684 # ffffffffc020c438 <commands+0x980>
ffffffffc02016ec:	db3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016f0:	0000b697          	auipc	a3,0xb
ffffffffc02016f4:	ec068693          	addi	a3,a3,-320 # ffffffffc020c5b0 <commands+0xaf8>
ffffffffc02016f8:	0000a617          	auipc	a2,0xa
ffffffffc02016fc:	5d060613          	addi	a2,a2,1488 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201700:	0cf00593          	li	a1,207
ffffffffc0201704:	0000b517          	auipc	a0,0xb
ffffffffc0201708:	d3450513          	addi	a0,a0,-716 # ffffffffc020c438 <commands+0x980>
ffffffffc020170c:	d93fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201710:	0000b697          	auipc	a3,0xb
ffffffffc0201714:	e8868693          	addi	a3,a3,-376 # ffffffffc020c598 <commands+0xae0>
ffffffffc0201718:	0000a617          	auipc	a2,0xa
ffffffffc020171c:	5b060613          	addi	a2,a2,1456 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201720:	0ca00593          	li	a1,202
ffffffffc0201724:	0000b517          	auipc	a0,0xb
ffffffffc0201728:	d1450513          	addi	a0,a0,-748 # ffffffffc020c438 <commands+0x980>
ffffffffc020172c:	d73fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201730:	0000b697          	auipc	a3,0xb
ffffffffc0201734:	e4868693          	addi	a3,a3,-440 # ffffffffc020c578 <commands+0xac0>
ffffffffc0201738:	0000a617          	auipc	a2,0xa
ffffffffc020173c:	59060613          	addi	a2,a2,1424 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201740:	0c100593          	li	a1,193
ffffffffc0201744:	0000b517          	auipc	a0,0xb
ffffffffc0201748:	cf450513          	addi	a0,a0,-780 # ffffffffc020c438 <commands+0x980>
ffffffffc020174c:	d53fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201750:	0000b697          	auipc	a3,0xb
ffffffffc0201754:	eb868693          	addi	a3,a3,-328 # ffffffffc020c608 <commands+0xb50>
ffffffffc0201758:	0000a617          	auipc	a2,0xa
ffffffffc020175c:	57060613          	addi	a2,a2,1392 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201760:	0f700593          	li	a1,247
ffffffffc0201764:	0000b517          	auipc	a0,0xb
ffffffffc0201768:	cd450513          	addi	a0,a0,-812 # ffffffffc020c438 <commands+0x980>
ffffffffc020176c:	d33fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201770:	0000b697          	auipc	a3,0xb
ffffffffc0201774:	e8868693          	addi	a3,a3,-376 # ffffffffc020c5f8 <commands+0xb40>
ffffffffc0201778:	0000a617          	auipc	a2,0xa
ffffffffc020177c:	55060613          	addi	a2,a2,1360 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201780:	0de00593          	li	a1,222
ffffffffc0201784:	0000b517          	auipc	a0,0xb
ffffffffc0201788:	cb450513          	addi	a0,a0,-844 # ffffffffc020c438 <commands+0x980>
ffffffffc020178c:	d13fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201790:	0000b697          	auipc	a3,0xb
ffffffffc0201794:	e0868693          	addi	a3,a3,-504 # ffffffffc020c598 <commands+0xae0>
ffffffffc0201798:	0000a617          	auipc	a2,0xa
ffffffffc020179c:	53060613          	addi	a2,a2,1328 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02017a0:	0dc00593          	li	a1,220
ffffffffc02017a4:	0000b517          	auipc	a0,0xb
ffffffffc02017a8:	c9450513          	addi	a0,a0,-876 # ffffffffc020c438 <commands+0x980>
ffffffffc02017ac:	cf3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017b0:	0000b697          	auipc	a3,0xb
ffffffffc02017b4:	e2868693          	addi	a3,a3,-472 # ffffffffc020c5d8 <commands+0xb20>
ffffffffc02017b8:	0000a617          	auipc	a2,0xa
ffffffffc02017bc:	51060613          	addi	a2,a2,1296 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02017c0:	0db00593          	li	a1,219
ffffffffc02017c4:	0000b517          	auipc	a0,0xb
ffffffffc02017c8:	c7450513          	addi	a0,a0,-908 # ffffffffc020c438 <commands+0x980>
ffffffffc02017cc:	cd3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017d0:	0000b697          	auipc	a3,0xb
ffffffffc02017d4:	ca068693          	addi	a3,a3,-864 # ffffffffc020c470 <commands+0x9b8>
ffffffffc02017d8:	0000a617          	auipc	a2,0xa
ffffffffc02017dc:	4f060613          	addi	a2,a2,1264 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02017e0:	0b800593          	li	a1,184
ffffffffc02017e4:	0000b517          	auipc	a0,0xb
ffffffffc02017e8:	c5450513          	addi	a0,a0,-940 # ffffffffc020c438 <commands+0x980>
ffffffffc02017ec:	cb3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017f0:	0000b697          	auipc	a3,0xb
ffffffffc02017f4:	da868693          	addi	a3,a3,-600 # ffffffffc020c598 <commands+0xae0>
ffffffffc02017f8:	0000a617          	auipc	a2,0xa
ffffffffc02017fc:	4d060613          	addi	a2,a2,1232 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201800:	0d500593          	li	a1,213
ffffffffc0201804:	0000b517          	auipc	a0,0xb
ffffffffc0201808:	c3450513          	addi	a0,a0,-972 # ffffffffc020c438 <commands+0x980>
ffffffffc020180c:	c93fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201810:	0000b697          	auipc	a3,0xb
ffffffffc0201814:	ca068693          	addi	a3,a3,-864 # ffffffffc020c4b0 <commands+0x9f8>
ffffffffc0201818:	0000a617          	auipc	a2,0xa
ffffffffc020181c:	4b060613          	addi	a2,a2,1200 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201820:	0d300593          	li	a1,211
ffffffffc0201824:	0000b517          	auipc	a0,0xb
ffffffffc0201828:	c1450513          	addi	a0,a0,-1004 # ffffffffc020c438 <commands+0x980>
ffffffffc020182c:	c73fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201830:	0000b697          	auipc	a3,0xb
ffffffffc0201834:	c6068693          	addi	a3,a3,-928 # ffffffffc020c490 <commands+0x9d8>
ffffffffc0201838:	0000a617          	auipc	a2,0xa
ffffffffc020183c:	49060613          	addi	a2,a2,1168 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201840:	0d200593          	li	a1,210
ffffffffc0201844:	0000b517          	auipc	a0,0xb
ffffffffc0201848:	bf450513          	addi	a0,a0,-1036 # ffffffffc020c438 <commands+0x980>
ffffffffc020184c:	c53fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201850:	0000b697          	auipc	a3,0xb
ffffffffc0201854:	c6068693          	addi	a3,a3,-928 # ffffffffc020c4b0 <commands+0x9f8>
ffffffffc0201858:	0000a617          	auipc	a2,0xa
ffffffffc020185c:	47060613          	addi	a2,a2,1136 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201860:	0ba00593          	li	a1,186
ffffffffc0201864:	0000b517          	auipc	a0,0xb
ffffffffc0201868:	bd450513          	addi	a0,a0,-1068 # ffffffffc020c438 <commands+0x980>
ffffffffc020186c:	c33fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201870:	0000b697          	auipc	a3,0xb
ffffffffc0201874:	ee868693          	addi	a3,a3,-280 # ffffffffc020c758 <commands+0xca0>
ffffffffc0201878:	0000a617          	auipc	a2,0xa
ffffffffc020187c:	45060613          	addi	a2,a2,1104 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201880:	12400593          	li	a1,292
ffffffffc0201884:	0000b517          	auipc	a0,0xb
ffffffffc0201888:	bb450513          	addi	a0,a0,-1100 # ffffffffc020c438 <commands+0x980>
ffffffffc020188c:	c13fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201890:	0000b697          	auipc	a3,0xb
ffffffffc0201894:	d6868693          	addi	a3,a3,-664 # ffffffffc020c5f8 <commands+0xb40>
ffffffffc0201898:	0000a617          	auipc	a2,0xa
ffffffffc020189c:	43060613          	addi	a2,a2,1072 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02018a0:	11900593          	li	a1,281
ffffffffc02018a4:	0000b517          	auipc	a0,0xb
ffffffffc02018a8:	b9450513          	addi	a0,a0,-1132 # ffffffffc020c438 <commands+0x980>
ffffffffc02018ac:	bf3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018b0:	0000b697          	auipc	a3,0xb
ffffffffc02018b4:	ce868693          	addi	a3,a3,-792 # ffffffffc020c598 <commands+0xae0>
ffffffffc02018b8:	0000a617          	auipc	a2,0xa
ffffffffc02018bc:	41060613          	addi	a2,a2,1040 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02018c0:	11700593          	li	a1,279
ffffffffc02018c4:	0000b517          	auipc	a0,0xb
ffffffffc02018c8:	b7450513          	addi	a0,a0,-1164 # ffffffffc020c438 <commands+0x980>
ffffffffc02018cc:	bd3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018d0:	0000b697          	auipc	a3,0xb
ffffffffc02018d4:	c8868693          	addi	a3,a3,-888 # ffffffffc020c558 <commands+0xaa0>
ffffffffc02018d8:	0000a617          	auipc	a2,0xa
ffffffffc02018dc:	3f060613          	addi	a2,a2,1008 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02018e0:	0c000593          	li	a1,192
ffffffffc02018e4:	0000b517          	auipc	a0,0xb
ffffffffc02018e8:	b5450513          	addi	a0,a0,-1196 # ffffffffc020c438 <commands+0x980>
ffffffffc02018ec:	bb3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018f0:	0000b697          	auipc	a3,0xb
ffffffffc02018f4:	e2868693          	addi	a3,a3,-472 # ffffffffc020c718 <commands+0xc60>
ffffffffc02018f8:	0000a617          	auipc	a2,0xa
ffffffffc02018fc:	3d060613          	addi	a2,a2,976 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201900:	11100593          	li	a1,273
ffffffffc0201904:	0000b517          	auipc	a0,0xb
ffffffffc0201908:	b3450513          	addi	a0,a0,-1228 # ffffffffc020c438 <commands+0x980>
ffffffffc020190c:	b93fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201910:	0000b697          	auipc	a3,0xb
ffffffffc0201914:	de868693          	addi	a3,a3,-536 # ffffffffc020c6f8 <commands+0xc40>
ffffffffc0201918:	0000a617          	auipc	a2,0xa
ffffffffc020191c:	3b060613          	addi	a2,a2,944 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201920:	10f00593          	li	a1,271
ffffffffc0201924:	0000b517          	auipc	a0,0xb
ffffffffc0201928:	b1450513          	addi	a0,a0,-1260 # ffffffffc020c438 <commands+0x980>
ffffffffc020192c:	b73fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201930:	0000b697          	auipc	a3,0xb
ffffffffc0201934:	da068693          	addi	a3,a3,-608 # ffffffffc020c6d0 <commands+0xc18>
ffffffffc0201938:	0000a617          	auipc	a2,0xa
ffffffffc020193c:	39060613          	addi	a2,a2,912 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201940:	10d00593          	li	a1,269
ffffffffc0201944:	0000b517          	auipc	a0,0xb
ffffffffc0201948:	af450513          	addi	a0,a0,-1292 # ffffffffc020c438 <commands+0x980>
ffffffffc020194c:	b53fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201950:	0000b697          	auipc	a3,0xb
ffffffffc0201954:	d5868693          	addi	a3,a3,-680 # ffffffffc020c6a8 <commands+0xbf0>
ffffffffc0201958:	0000a617          	auipc	a2,0xa
ffffffffc020195c:	37060613          	addi	a2,a2,880 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201960:	10c00593          	li	a1,268
ffffffffc0201964:	0000b517          	auipc	a0,0xb
ffffffffc0201968:	ad450513          	addi	a0,a0,-1324 # ffffffffc020c438 <commands+0x980>
ffffffffc020196c:	b33fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201970:	0000b697          	auipc	a3,0xb
ffffffffc0201974:	d2868693          	addi	a3,a3,-728 # ffffffffc020c698 <commands+0xbe0>
ffffffffc0201978:	0000a617          	auipc	a2,0xa
ffffffffc020197c:	35060613          	addi	a2,a2,848 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201980:	10700593          	li	a1,263
ffffffffc0201984:	0000b517          	auipc	a0,0xb
ffffffffc0201988:	ab450513          	addi	a0,a0,-1356 # ffffffffc020c438 <commands+0x980>
ffffffffc020198c:	b13fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201990:	0000b697          	auipc	a3,0xb
ffffffffc0201994:	c0868693          	addi	a3,a3,-1016 # ffffffffc020c598 <commands+0xae0>
ffffffffc0201998:	0000a617          	auipc	a2,0xa
ffffffffc020199c:	33060613          	addi	a2,a2,816 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02019a0:	10600593          	li	a1,262
ffffffffc02019a4:	0000b517          	auipc	a0,0xb
ffffffffc02019a8:	a9450513          	addi	a0,a0,-1388 # ffffffffc020c438 <commands+0x980>
ffffffffc02019ac:	af3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019b0:	0000b697          	auipc	a3,0xb
ffffffffc02019b4:	cc868693          	addi	a3,a3,-824 # ffffffffc020c678 <commands+0xbc0>
ffffffffc02019b8:	0000a617          	auipc	a2,0xa
ffffffffc02019bc:	31060613          	addi	a2,a2,784 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02019c0:	10500593          	li	a1,261
ffffffffc02019c4:	0000b517          	auipc	a0,0xb
ffffffffc02019c8:	a7450513          	addi	a0,a0,-1420 # ffffffffc020c438 <commands+0x980>
ffffffffc02019cc:	ad3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019d0:	0000b697          	auipc	a3,0xb
ffffffffc02019d4:	c7868693          	addi	a3,a3,-904 # ffffffffc020c648 <commands+0xb90>
ffffffffc02019d8:	0000a617          	auipc	a2,0xa
ffffffffc02019dc:	2f060613          	addi	a2,a2,752 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02019e0:	10400593          	li	a1,260
ffffffffc02019e4:	0000b517          	auipc	a0,0xb
ffffffffc02019e8:	a5450513          	addi	a0,a0,-1452 # ffffffffc020c438 <commands+0x980>
ffffffffc02019ec:	ab3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019f0:	0000b697          	auipc	a3,0xb
ffffffffc02019f4:	c4068693          	addi	a3,a3,-960 # ffffffffc020c630 <commands+0xb78>
ffffffffc02019f8:	0000a617          	auipc	a2,0xa
ffffffffc02019fc:	2d060613          	addi	a2,a2,720 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201a00:	10300593          	li	a1,259
ffffffffc0201a04:	0000b517          	auipc	a0,0xb
ffffffffc0201a08:	a3450513          	addi	a0,a0,-1484 # ffffffffc020c438 <commands+0x980>
ffffffffc0201a0c:	a93fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a10:	0000b697          	auipc	a3,0xb
ffffffffc0201a14:	b8868693          	addi	a3,a3,-1144 # ffffffffc020c598 <commands+0xae0>
ffffffffc0201a18:	0000a617          	auipc	a2,0xa
ffffffffc0201a1c:	2b060613          	addi	a2,a2,688 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201a20:	0fd00593          	li	a1,253
ffffffffc0201a24:	0000b517          	auipc	a0,0xb
ffffffffc0201a28:	a1450513          	addi	a0,a0,-1516 # ffffffffc020c438 <commands+0x980>
ffffffffc0201a2c:	a73fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a30:	0000b697          	auipc	a3,0xb
ffffffffc0201a34:	be868693          	addi	a3,a3,-1048 # ffffffffc020c618 <commands+0xb60>
ffffffffc0201a38:	0000a617          	auipc	a2,0xa
ffffffffc0201a3c:	29060613          	addi	a2,a2,656 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201a40:	0f800593          	li	a1,248
ffffffffc0201a44:	0000b517          	auipc	a0,0xb
ffffffffc0201a48:	9f450513          	addi	a0,a0,-1548 # ffffffffc020c438 <commands+0x980>
ffffffffc0201a4c:	a53fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a50:	0000b697          	auipc	a3,0xb
ffffffffc0201a54:	ce868693          	addi	a3,a3,-792 # ffffffffc020c738 <commands+0xc80>
ffffffffc0201a58:	0000a617          	auipc	a2,0xa
ffffffffc0201a5c:	27060613          	addi	a2,a2,624 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201a60:	11600593          	li	a1,278
ffffffffc0201a64:	0000b517          	auipc	a0,0xb
ffffffffc0201a68:	9d450513          	addi	a0,a0,-1580 # ffffffffc020c438 <commands+0x980>
ffffffffc0201a6c:	a33fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a70:	0000b697          	auipc	a3,0xb
ffffffffc0201a74:	cf868693          	addi	a3,a3,-776 # ffffffffc020c768 <commands+0xcb0>
ffffffffc0201a78:	0000a617          	auipc	a2,0xa
ffffffffc0201a7c:	25060613          	addi	a2,a2,592 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201a80:	12500593          	li	a1,293
ffffffffc0201a84:	0000b517          	auipc	a0,0xb
ffffffffc0201a88:	9b450513          	addi	a0,a0,-1612 # ffffffffc020c438 <commands+0x980>
ffffffffc0201a8c:	a13fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a90:	0000b697          	auipc	a3,0xb
ffffffffc0201a94:	9c068693          	addi	a3,a3,-1600 # ffffffffc020c450 <commands+0x998>
ffffffffc0201a98:	0000a617          	auipc	a2,0xa
ffffffffc0201a9c:	23060613          	addi	a2,a2,560 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201aa0:	0f200593          	li	a1,242
ffffffffc0201aa4:	0000b517          	auipc	a0,0xb
ffffffffc0201aa8:	99450513          	addi	a0,a0,-1644 # ffffffffc020c438 <commands+0x980>
ffffffffc0201aac:	9f3fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201ab0:	0000b697          	auipc	a3,0xb
ffffffffc0201ab4:	9e068693          	addi	a3,a3,-1568 # ffffffffc020c490 <commands+0x9d8>
ffffffffc0201ab8:	0000a617          	auipc	a2,0xa
ffffffffc0201abc:	21060613          	addi	a2,a2,528 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201ac0:	0b900593          	li	a1,185
ffffffffc0201ac4:	0000b517          	auipc	a0,0xb
ffffffffc0201ac8:	97450513          	addi	a0,a0,-1676 # ffffffffc020c438 <commands+0x980>
ffffffffc0201acc:	9d3fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201ad0 <default_free_pages>:
ffffffffc0201ad0:	1141                	addi	sp,sp,-16
ffffffffc0201ad2:	e406                	sd	ra,8(sp)
ffffffffc0201ad4:	14058463          	beqz	a1,ffffffffc0201c1c <default_free_pages+0x14c>
ffffffffc0201ad8:	00659693          	slli	a3,a1,0x6
ffffffffc0201adc:	96aa                	add	a3,a3,a0
ffffffffc0201ade:	87aa                	mv	a5,a0
ffffffffc0201ae0:	02d50263          	beq	a0,a3,ffffffffc0201b04 <default_free_pages+0x34>
ffffffffc0201ae4:	6798                	ld	a4,8(a5)
ffffffffc0201ae6:	8b05                	andi	a4,a4,1
ffffffffc0201ae8:	10071a63          	bnez	a4,ffffffffc0201bfc <default_free_pages+0x12c>
ffffffffc0201aec:	6798                	ld	a4,8(a5)
ffffffffc0201aee:	8b09                	andi	a4,a4,2
ffffffffc0201af0:	10071663          	bnez	a4,ffffffffc0201bfc <default_free_pages+0x12c>
ffffffffc0201af4:	0007b423          	sd	zero,8(a5)
ffffffffc0201af8:	0007a023          	sw	zero,0(a5)
ffffffffc0201afc:	04078793          	addi	a5,a5,64
ffffffffc0201b00:	fed792e3          	bne	a5,a3,ffffffffc0201ae4 <default_free_pages+0x14>
ffffffffc0201b04:	2581                	sext.w	a1,a1
ffffffffc0201b06:	c90c                	sw	a1,16(a0)
ffffffffc0201b08:	00850893          	addi	a7,a0,8
ffffffffc0201b0c:	4789                	li	a5,2
ffffffffc0201b0e:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0201b12:	00090697          	auipc	a3,0x90
ffffffffc0201b16:	c9668693          	addi	a3,a3,-874 # ffffffffc02917a8 <free_area>
ffffffffc0201b1a:	4a98                	lw	a4,16(a3)
ffffffffc0201b1c:	669c                	ld	a5,8(a3)
ffffffffc0201b1e:	01850613          	addi	a2,a0,24
ffffffffc0201b22:	9db9                	addw	a1,a1,a4
ffffffffc0201b24:	ca8c                	sw	a1,16(a3)
ffffffffc0201b26:	0ad78463          	beq	a5,a3,ffffffffc0201bce <default_free_pages+0xfe>
ffffffffc0201b2a:	fe878713          	addi	a4,a5,-24
ffffffffc0201b2e:	0006b803          	ld	a6,0(a3)
ffffffffc0201b32:	4581                	li	a1,0
ffffffffc0201b34:	00e56a63          	bltu	a0,a4,ffffffffc0201b48 <default_free_pages+0x78>
ffffffffc0201b38:	6798                	ld	a4,8(a5)
ffffffffc0201b3a:	04d70c63          	beq	a4,a3,ffffffffc0201b92 <default_free_pages+0xc2>
ffffffffc0201b3e:	87ba                	mv	a5,a4
ffffffffc0201b40:	fe878713          	addi	a4,a5,-24
ffffffffc0201b44:	fee57ae3          	bgeu	a0,a4,ffffffffc0201b38 <default_free_pages+0x68>
ffffffffc0201b48:	c199                	beqz	a1,ffffffffc0201b4e <default_free_pages+0x7e>
ffffffffc0201b4a:	0106b023          	sd	a6,0(a3)
ffffffffc0201b4e:	6398                	ld	a4,0(a5)
ffffffffc0201b50:	e390                	sd	a2,0(a5)
ffffffffc0201b52:	e710                	sd	a2,8(a4)
ffffffffc0201b54:	f11c                	sd	a5,32(a0)
ffffffffc0201b56:	ed18                	sd	a4,24(a0)
ffffffffc0201b58:	00d70d63          	beq	a4,a3,ffffffffc0201b72 <default_free_pages+0xa2>
ffffffffc0201b5c:	ff872583          	lw	a1,-8(a4)
ffffffffc0201b60:	fe870613          	addi	a2,a4,-24
ffffffffc0201b64:	02059813          	slli	a6,a1,0x20
ffffffffc0201b68:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201b6c:	97b2                	add	a5,a5,a2
ffffffffc0201b6e:	02f50c63          	beq	a0,a5,ffffffffc0201ba6 <default_free_pages+0xd6>
ffffffffc0201b72:	711c                	ld	a5,32(a0)
ffffffffc0201b74:	00d78c63          	beq	a5,a3,ffffffffc0201b8c <default_free_pages+0xbc>
ffffffffc0201b78:	4910                	lw	a2,16(a0)
ffffffffc0201b7a:	fe878693          	addi	a3,a5,-24
ffffffffc0201b7e:	02061593          	slli	a1,a2,0x20
ffffffffc0201b82:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201b86:	972a                	add	a4,a4,a0
ffffffffc0201b88:	04e68a63          	beq	a3,a4,ffffffffc0201bdc <default_free_pages+0x10c>
ffffffffc0201b8c:	60a2                	ld	ra,8(sp)
ffffffffc0201b8e:	0141                	addi	sp,sp,16
ffffffffc0201b90:	8082                	ret
ffffffffc0201b92:	e790                	sd	a2,8(a5)
ffffffffc0201b94:	f114                	sd	a3,32(a0)
ffffffffc0201b96:	6798                	ld	a4,8(a5)
ffffffffc0201b98:	ed1c                	sd	a5,24(a0)
ffffffffc0201b9a:	02d70763          	beq	a4,a3,ffffffffc0201bc8 <default_free_pages+0xf8>
ffffffffc0201b9e:	8832                	mv	a6,a2
ffffffffc0201ba0:	4585                	li	a1,1
ffffffffc0201ba2:	87ba                	mv	a5,a4
ffffffffc0201ba4:	bf71                	j	ffffffffc0201b40 <default_free_pages+0x70>
ffffffffc0201ba6:	491c                	lw	a5,16(a0)
ffffffffc0201ba8:	9dbd                	addw	a1,a1,a5
ffffffffc0201baa:	feb72c23          	sw	a1,-8(a4)
ffffffffc0201bae:	57f5                	li	a5,-3
ffffffffc0201bb0:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc0201bb4:	01853803          	ld	a6,24(a0)
ffffffffc0201bb8:	710c                	ld	a1,32(a0)
ffffffffc0201bba:	8532                	mv	a0,a2
ffffffffc0201bbc:	00b83423          	sd	a1,8(a6)
ffffffffc0201bc0:	671c                	ld	a5,8(a4)
ffffffffc0201bc2:	0105b023          	sd	a6,0(a1)
ffffffffc0201bc6:	b77d                	j	ffffffffc0201b74 <default_free_pages+0xa4>
ffffffffc0201bc8:	e290                	sd	a2,0(a3)
ffffffffc0201bca:	873e                	mv	a4,a5
ffffffffc0201bcc:	bf41                	j	ffffffffc0201b5c <default_free_pages+0x8c>
ffffffffc0201bce:	60a2                	ld	ra,8(sp)
ffffffffc0201bd0:	e390                	sd	a2,0(a5)
ffffffffc0201bd2:	e790                	sd	a2,8(a5)
ffffffffc0201bd4:	f11c                	sd	a5,32(a0)
ffffffffc0201bd6:	ed1c                	sd	a5,24(a0)
ffffffffc0201bd8:	0141                	addi	sp,sp,16
ffffffffc0201bda:	8082                	ret
ffffffffc0201bdc:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201be0:	ff078693          	addi	a3,a5,-16
ffffffffc0201be4:	9e39                	addw	a2,a2,a4
ffffffffc0201be6:	c910                	sw	a2,16(a0)
ffffffffc0201be8:	5775                	li	a4,-3
ffffffffc0201bea:	60e6b02f          	amoand.d	zero,a4,(a3)
ffffffffc0201bee:	6398                	ld	a4,0(a5)
ffffffffc0201bf0:	679c                	ld	a5,8(a5)
ffffffffc0201bf2:	60a2                	ld	ra,8(sp)
ffffffffc0201bf4:	e71c                	sd	a5,8(a4)
ffffffffc0201bf6:	e398                	sd	a4,0(a5)
ffffffffc0201bf8:	0141                	addi	sp,sp,16
ffffffffc0201bfa:	8082                	ret
ffffffffc0201bfc:	0000b697          	auipc	a3,0xb
ffffffffc0201c00:	b8468693          	addi	a3,a3,-1148 # ffffffffc020c780 <commands+0xcc8>
ffffffffc0201c04:	0000a617          	auipc	a2,0xa
ffffffffc0201c08:	0c460613          	addi	a2,a2,196 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201c0c:	08200593          	li	a1,130
ffffffffc0201c10:	0000b517          	auipc	a0,0xb
ffffffffc0201c14:	82850513          	addi	a0,a0,-2008 # ffffffffc020c438 <commands+0x980>
ffffffffc0201c18:	887fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201c1c:	0000b697          	auipc	a3,0xb
ffffffffc0201c20:	b5c68693          	addi	a3,a3,-1188 # ffffffffc020c778 <commands+0xcc0>
ffffffffc0201c24:	0000a617          	auipc	a2,0xa
ffffffffc0201c28:	0a460613          	addi	a2,a2,164 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201c2c:	07f00593          	li	a1,127
ffffffffc0201c30:	0000b517          	auipc	a0,0xb
ffffffffc0201c34:	80850513          	addi	a0,a0,-2040 # ffffffffc020c438 <commands+0x980>
ffffffffc0201c38:	867fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201c3c <default_alloc_pages>:
ffffffffc0201c3c:	c941                	beqz	a0,ffffffffc0201ccc <default_alloc_pages+0x90>
ffffffffc0201c3e:	00090597          	auipc	a1,0x90
ffffffffc0201c42:	b6a58593          	addi	a1,a1,-1174 # ffffffffc02917a8 <free_area>
ffffffffc0201c46:	0105a803          	lw	a6,16(a1)
ffffffffc0201c4a:	872a                	mv	a4,a0
ffffffffc0201c4c:	02081793          	slli	a5,a6,0x20
ffffffffc0201c50:	9381                	srli	a5,a5,0x20
ffffffffc0201c52:	00a7ee63          	bltu	a5,a0,ffffffffc0201c6e <default_alloc_pages+0x32>
ffffffffc0201c56:	87ae                	mv	a5,a1
ffffffffc0201c58:	a801                	j	ffffffffc0201c68 <default_alloc_pages+0x2c>
ffffffffc0201c5a:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201c5e:	02069613          	slli	a2,a3,0x20
ffffffffc0201c62:	9201                	srli	a2,a2,0x20
ffffffffc0201c64:	00e67763          	bgeu	a2,a4,ffffffffc0201c72 <default_alloc_pages+0x36>
ffffffffc0201c68:	679c                	ld	a5,8(a5)
ffffffffc0201c6a:	feb798e3          	bne	a5,a1,ffffffffc0201c5a <default_alloc_pages+0x1e>
ffffffffc0201c6e:	4501                	li	a0,0
ffffffffc0201c70:	8082                	ret
ffffffffc0201c72:	0007b883          	ld	a7,0(a5)
ffffffffc0201c76:	0087b303          	ld	t1,8(a5)
ffffffffc0201c7a:	fe878513          	addi	a0,a5,-24
ffffffffc0201c7e:	00070e1b          	sext.w	t3,a4
ffffffffc0201c82:	0068b423          	sd	t1,8(a7) # 10000008 <_binary_bin_sfs_img_size+0xff8ad08>
ffffffffc0201c86:	01133023          	sd	a7,0(t1)
ffffffffc0201c8a:	02c77863          	bgeu	a4,a2,ffffffffc0201cba <default_alloc_pages+0x7e>
ffffffffc0201c8e:	071a                	slli	a4,a4,0x6
ffffffffc0201c90:	972a                	add	a4,a4,a0
ffffffffc0201c92:	41c686bb          	subw	a3,a3,t3
ffffffffc0201c96:	cb14                	sw	a3,16(a4)
ffffffffc0201c98:	00870613          	addi	a2,a4,8
ffffffffc0201c9c:	4689                	li	a3,2
ffffffffc0201c9e:	40d6302f          	amoor.d	zero,a3,(a2)
ffffffffc0201ca2:	0088b683          	ld	a3,8(a7)
ffffffffc0201ca6:	01870613          	addi	a2,a4,24
ffffffffc0201caa:	0105a803          	lw	a6,16(a1)
ffffffffc0201cae:	e290                	sd	a2,0(a3)
ffffffffc0201cb0:	00c8b423          	sd	a2,8(a7)
ffffffffc0201cb4:	f314                	sd	a3,32(a4)
ffffffffc0201cb6:	01173c23          	sd	a7,24(a4)
ffffffffc0201cba:	41c8083b          	subw	a6,a6,t3
ffffffffc0201cbe:	0105a823          	sw	a6,16(a1)
ffffffffc0201cc2:	5775                	li	a4,-3
ffffffffc0201cc4:	17c1                	addi	a5,a5,-16
ffffffffc0201cc6:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0201cca:	8082                	ret
ffffffffc0201ccc:	1141                	addi	sp,sp,-16
ffffffffc0201cce:	0000b697          	auipc	a3,0xb
ffffffffc0201cd2:	aaa68693          	addi	a3,a3,-1366 # ffffffffc020c778 <commands+0xcc0>
ffffffffc0201cd6:	0000a617          	auipc	a2,0xa
ffffffffc0201cda:	ff260613          	addi	a2,a2,-14 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201cde:	06100593          	li	a1,97
ffffffffc0201ce2:	0000a517          	auipc	a0,0xa
ffffffffc0201ce6:	75650513          	addi	a0,a0,1878 # ffffffffc020c438 <commands+0x980>
ffffffffc0201cea:	e406                	sd	ra,8(sp)
ffffffffc0201cec:	fb2fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201cf0 <default_init_memmap>:
ffffffffc0201cf0:	1141                	addi	sp,sp,-16
ffffffffc0201cf2:	e406                	sd	ra,8(sp)
ffffffffc0201cf4:	c5f1                	beqz	a1,ffffffffc0201dc0 <default_init_memmap+0xd0>
ffffffffc0201cf6:	00659693          	slli	a3,a1,0x6
ffffffffc0201cfa:	96aa                	add	a3,a3,a0
ffffffffc0201cfc:	87aa                	mv	a5,a0
ffffffffc0201cfe:	00d50f63          	beq	a0,a3,ffffffffc0201d1c <default_init_memmap+0x2c>
ffffffffc0201d02:	6798                	ld	a4,8(a5)
ffffffffc0201d04:	8b05                	andi	a4,a4,1
ffffffffc0201d06:	cf49                	beqz	a4,ffffffffc0201da0 <default_init_memmap+0xb0>
ffffffffc0201d08:	0007a823          	sw	zero,16(a5)
ffffffffc0201d0c:	0007b423          	sd	zero,8(a5)
ffffffffc0201d10:	0007a023          	sw	zero,0(a5)
ffffffffc0201d14:	04078793          	addi	a5,a5,64
ffffffffc0201d18:	fed795e3          	bne	a5,a3,ffffffffc0201d02 <default_init_memmap+0x12>
ffffffffc0201d1c:	2581                	sext.w	a1,a1
ffffffffc0201d1e:	c90c                	sw	a1,16(a0)
ffffffffc0201d20:	4789                	li	a5,2
ffffffffc0201d22:	00850713          	addi	a4,a0,8
ffffffffc0201d26:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201d2a:	00090697          	auipc	a3,0x90
ffffffffc0201d2e:	a7e68693          	addi	a3,a3,-1410 # ffffffffc02917a8 <free_area>
ffffffffc0201d32:	4a98                	lw	a4,16(a3)
ffffffffc0201d34:	669c                	ld	a5,8(a3)
ffffffffc0201d36:	01850613          	addi	a2,a0,24
ffffffffc0201d3a:	9db9                	addw	a1,a1,a4
ffffffffc0201d3c:	ca8c                	sw	a1,16(a3)
ffffffffc0201d3e:	04d78a63          	beq	a5,a3,ffffffffc0201d92 <default_init_memmap+0xa2>
ffffffffc0201d42:	fe878713          	addi	a4,a5,-24
ffffffffc0201d46:	0006b803          	ld	a6,0(a3)
ffffffffc0201d4a:	4581                	li	a1,0
ffffffffc0201d4c:	00e56a63          	bltu	a0,a4,ffffffffc0201d60 <default_init_memmap+0x70>
ffffffffc0201d50:	6798                	ld	a4,8(a5)
ffffffffc0201d52:	02d70263          	beq	a4,a3,ffffffffc0201d76 <default_init_memmap+0x86>
ffffffffc0201d56:	87ba                	mv	a5,a4
ffffffffc0201d58:	fe878713          	addi	a4,a5,-24
ffffffffc0201d5c:	fee57ae3          	bgeu	a0,a4,ffffffffc0201d50 <default_init_memmap+0x60>
ffffffffc0201d60:	c199                	beqz	a1,ffffffffc0201d66 <default_init_memmap+0x76>
ffffffffc0201d62:	0106b023          	sd	a6,0(a3)
ffffffffc0201d66:	6398                	ld	a4,0(a5)
ffffffffc0201d68:	60a2                	ld	ra,8(sp)
ffffffffc0201d6a:	e390                	sd	a2,0(a5)
ffffffffc0201d6c:	e710                	sd	a2,8(a4)
ffffffffc0201d6e:	f11c                	sd	a5,32(a0)
ffffffffc0201d70:	ed18                	sd	a4,24(a0)
ffffffffc0201d72:	0141                	addi	sp,sp,16
ffffffffc0201d74:	8082                	ret
ffffffffc0201d76:	e790                	sd	a2,8(a5)
ffffffffc0201d78:	f114                	sd	a3,32(a0)
ffffffffc0201d7a:	6798                	ld	a4,8(a5)
ffffffffc0201d7c:	ed1c                	sd	a5,24(a0)
ffffffffc0201d7e:	00d70663          	beq	a4,a3,ffffffffc0201d8a <default_init_memmap+0x9a>
ffffffffc0201d82:	8832                	mv	a6,a2
ffffffffc0201d84:	4585                	li	a1,1
ffffffffc0201d86:	87ba                	mv	a5,a4
ffffffffc0201d88:	bfc1                	j	ffffffffc0201d58 <default_init_memmap+0x68>
ffffffffc0201d8a:	60a2                	ld	ra,8(sp)
ffffffffc0201d8c:	e290                	sd	a2,0(a3)
ffffffffc0201d8e:	0141                	addi	sp,sp,16
ffffffffc0201d90:	8082                	ret
ffffffffc0201d92:	60a2                	ld	ra,8(sp)
ffffffffc0201d94:	e390                	sd	a2,0(a5)
ffffffffc0201d96:	e790                	sd	a2,8(a5)
ffffffffc0201d98:	f11c                	sd	a5,32(a0)
ffffffffc0201d9a:	ed1c                	sd	a5,24(a0)
ffffffffc0201d9c:	0141                	addi	sp,sp,16
ffffffffc0201d9e:	8082                	ret
ffffffffc0201da0:	0000b697          	auipc	a3,0xb
ffffffffc0201da4:	a0868693          	addi	a3,a3,-1528 # ffffffffc020c7a8 <commands+0xcf0>
ffffffffc0201da8:	0000a617          	auipc	a2,0xa
ffffffffc0201dac:	f2060613          	addi	a2,a2,-224 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201db0:	04800593          	li	a1,72
ffffffffc0201db4:	0000a517          	auipc	a0,0xa
ffffffffc0201db8:	68450513          	addi	a0,a0,1668 # ffffffffc020c438 <commands+0x980>
ffffffffc0201dbc:	ee2fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201dc0:	0000b697          	auipc	a3,0xb
ffffffffc0201dc4:	9b868693          	addi	a3,a3,-1608 # ffffffffc020c778 <commands+0xcc0>
ffffffffc0201dc8:	0000a617          	auipc	a2,0xa
ffffffffc0201dcc:	f0060613          	addi	a2,a2,-256 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201dd0:	04500593          	li	a1,69
ffffffffc0201dd4:	0000a517          	auipc	a0,0xa
ffffffffc0201dd8:	66450513          	addi	a0,a0,1636 # ffffffffc020c438 <commands+0x980>
ffffffffc0201ddc:	ec2fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201de0 <slob_free>:
ffffffffc0201de0:	c94d                	beqz	a0,ffffffffc0201e92 <slob_free+0xb2>
ffffffffc0201de2:	1141                	addi	sp,sp,-16
ffffffffc0201de4:	e022                	sd	s0,0(sp)
ffffffffc0201de6:	e406                	sd	ra,8(sp)
ffffffffc0201de8:	842a                	mv	s0,a0
ffffffffc0201dea:	e9c1                	bnez	a1,ffffffffc0201e7a <slob_free+0x9a>
ffffffffc0201dec:	100027f3          	csrr	a5,sstatus
ffffffffc0201df0:	8b89                	andi	a5,a5,2
ffffffffc0201df2:	4501                	li	a0,0
ffffffffc0201df4:	ebd9                	bnez	a5,ffffffffc0201e8a <slob_free+0xaa>
ffffffffc0201df6:	0008f617          	auipc	a2,0x8f
ffffffffc0201dfa:	25a60613          	addi	a2,a2,602 # ffffffffc0291050 <slobfree>
ffffffffc0201dfe:	621c                	ld	a5,0(a2)
ffffffffc0201e00:	873e                	mv	a4,a5
ffffffffc0201e02:	679c                	ld	a5,8(a5)
ffffffffc0201e04:	02877a63          	bgeu	a4,s0,ffffffffc0201e38 <slob_free+0x58>
ffffffffc0201e08:	00f46463          	bltu	s0,a5,ffffffffc0201e10 <slob_free+0x30>
ffffffffc0201e0c:	fef76ae3          	bltu	a4,a5,ffffffffc0201e00 <slob_free+0x20>
ffffffffc0201e10:	400c                	lw	a1,0(s0)
ffffffffc0201e12:	00459693          	slli	a3,a1,0x4
ffffffffc0201e16:	96a2                	add	a3,a3,s0
ffffffffc0201e18:	02d78a63          	beq	a5,a3,ffffffffc0201e4c <slob_free+0x6c>
ffffffffc0201e1c:	4314                	lw	a3,0(a4)
ffffffffc0201e1e:	e41c                	sd	a5,8(s0)
ffffffffc0201e20:	00469793          	slli	a5,a3,0x4
ffffffffc0201e24:	97ba                	add	a5,a5,a4
ffffffffc0201e26:	02f40e63          	beq	s0,a5,ffffffffc0201e62 <slob_free+0x82>
ffffffffc0201e2a:	e700                	sd	s0,8(a4)
ffffffffc0201e2c:	e218                	sd	a4,0(a2)
ffffffffc0201e2e:	e129                	bnez	a0,ffffffffc0201e70 <slob_free+0x90>
ffffffffc0201e30:	60a2                	ld	ra,8(sp)
ffffffffc0201e32:	6402                	ld	s0,0(sp)
ffffffffc0201e34:	0141                	addi	sp,sp,16
ffffffffc0201e36:	8082                	ret
ffffffffc0201e38:	fcf764e3          	bltu	a4,a5,ffffffffc0201e00 <slob_free+0x20>
ffffffffc0201e3c:	fcf472e3          	bgeu	s0,a5,ffffffffc0201e00 <slob_free+0x20>
ffffffffc0201e40:	400c                	lw	a1,0(s0)
ffffffffc0201e42:	00459693          	slli	a3,a1,0x4
ffffffffc0201e46:	96a2                	add	a3,a3,s0
ffffffffc0201e48:	fcd79ae3          	bne	a5,a3,ffffffffc0201e1c <slob_free+0x3c>
ffffffffc0201e4c:	4394                	lw	a3,0(a5)
ffffffffc0201e4e:	679c                	ld	a5,8(a5)
ffffffffc0201e50:	9db5                	addw	a1,a1,a3
ffffffffc0201e52:	c00c                	sw	a1,0(s0)
ffffffffc0201e54:	4314                	lw	a3,0(a4)
ffffffffc0201e56:	e41c                	sd	a5,8(s0)
ffffffffc0201e58:	00469793          	slli	a5,a3,0x4
ffffffffc0201e5c:	97ba                	add	a5,a5,a4
ffffffffc0201e5e:	fcf416e3          	bne	s0,a5,ffffffffc0201e2a <slob_free+0x4a>
ffffffffc0201e62:	401c                	lw	a5,0(s0)
ffffffffc0201e64:	640c                	ld	a1,8(s0)
ffffffffc0201e66:	e218                	sd	a4,0(a2)
ffffffffc0201e68:	9ebd                	addw	a3,a3,a5
ffffffffc0201e6a:	c314                	sw	a3,0(a4)
ffffffffc0201e6c:	e70c                	sd	a1,8(a4)
ffffffffc0201e6e:	d169                	beqz	a0,ffffffffc0201e30 <slob_free+0x50>
ffffffffc0201e70:	6402                	ld	s0,0(sp)
ffffffffc0201e72:	60a2                	ld	ra,8(sp)
ffffffffc0201e74:	0141                	addi	sp,sp,16
ffffffffc0201e76:	df7fe06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0201e7a:	25bd                	addiw	a1,a1,15
ffffffffc0201e7c:	8191                	srli	a1,a1,0x4
ffffffffc0201e7e:	c10c                	sw	a1,0(a0)
ffffffffc0201e80:	100027f3          	csrr	a5,sstatus
ffffffffc0201e84:	8b89                	andi	a5,a5,2
ffffffffc0201e86:	4501                	li	a0,0
ffffffffc0201e88:	d7bd                	beqz	a5,ffffffffc0201df6 <slob_free+0x16>
ffffffffc0201e8a:	de9fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201e8e:	4505                	li	a0,1
ffffffffc0201e90:	b79d                	j	ffffffffc0201df6 <slob_free+0x16>
ffffffffc0201e92:	8082                	ret

ffffffffc0201e94 <__slob_get_free_pages.constprop.0>:
ffffffffc0201e94:	4785                	li	a5,1
ffffffffc0201e96:	1141                	addi	sp,sp,-16
ffffffffc0201e98:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201e9c:	e406                	sd	ra,8(sp)
ffffffffc0201e9e:	352000ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc0201ea2:	c91d                	beqz	a0,ffffffffc0201ed8 <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0201ea4:	00095697          	auipc	a3,0x95
ffffffffc0201ea8:	a046b683          	ld	a3,-1532(a3) # ffffffffc02968a8 <pages>
ffffffffc0201eac:	8d15                	sub	a0,a0,a3
ffffffffc0201eae:	8519                	srai	a0,a0,0x6
ffffffffc0201eb0:	0000e697          	auipc	a3,0xe
ffffffffc0201eb4:	e806b683          	ld	a3,-384(a3) # ffffffffc020fd30 <nbase>
ffffffffc0201eb8:	9536                	add	a0,a0,a3
ffffffffc0201eba:	00c51793          	slli	a5,a0,0xc
ffffffffc0201ebe:	83b1                	srli	a5,a5,0xc
ffffffffc0201ec0:	00095717          	auipc	a4,0x95
ffffffffc0201ec4:	9e073703          	ld	a4,-1568(a4) # ffffffffc02968a0 <npage>
ffffffffc0201ec8:	0532                	slli	a0,a0,0xc
ffffffffc0201eca:	00e7fa63          	bgeu	a5,a4,ffffffffc0201ede <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201ece:	00095697          	auipc	a3,0x95
ffffffffc0201ed2:	9ea6b683          	ld	a3,-1558(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0201ed6:	9536                	add	a0,a0,a3
ffffffffc0201ed8:	60a2                	ld	ra,8(sp)
ffffffffc0201eda:	0141                	addi	sp,sp,16
ffffffffc0201edc:	8082                	ret
ffffffffc0201ede:	86aa                	mv	a3,a0
ffffffffc0201ee0:	0000b617          	auipc	a2,0xb
ffffffffc0201ee4:	92860613          	addi	a2,a2,-1752 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc0201ee8:	07100593          	li	a1,113
ffffffffc0201eec:	0000b517          	auipc	a0,0xb
ffffffffc0201ef0:	94450513          	addi	a0,a0,-1724 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0201ef4:	daafe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201ef8 <slob_alloc.constprop.0>:
ffffffffc0201ef8:	1101                	addi	sp,sp,-32
ffffffffc0201efa:	ec06                	sd	ra,24(sp)
ffffffffc0201efc:	e822                	sd	s0,16(sp)
ffffffffc0201efe:	e426                	sd	s1,8(sp)
ffffffffc0201f00:	e04a                	sd	s2,0(sp)
ffffffffc0201f02:	01050713          	addi	a4,a0,16
ffffffffc0201f06:	6785                	lui	a5,0x1
ffffffffc0201f08:	0cf77363          	bgeu	a4,a5,ffffffffc0201fce <slob_alloc.constprop.0+0xd6>
ffffffffc0201f0c:	00f50493          	addi	s1,a0,15
ffffffffc0201f10:	8091                	srli	s1,s1,0x4
ffffffffc0201f12:	2481                	sext.w	s1,s1
ffffffffc0201f14:	10002673          	csrr	a2,sstatus
ffffffffc0201f18:	8a09                	andi	a2,a2,2
ffffffffc0201f1a:	e25d                	bnez	a2,ffffffffc0201fc0 <slob_alloc.constprop.0+0xc8>
ffffffffc0201f1c:	0008f917          	auipc	s2,0x8f
ffffffffc0201f20:	13490913          	addi	s2,s2,308 # ffffffffc0291050 <slobfree>
ffffffffc0201f24:	00093683          	ld	a3,0(s2)
ffffffffc0201f28:	669c                	ld	a5,8(a3)
ffffffffc0201f2a:	4398                	lw	a4,0(a5)
ffffffffc0201f2c:	08975e63          	bge	a4,s1,ffffffffc0201fc8 <slob_alloc.constprop.0+0xd0>
ffffffffc0201f30:	00f68b63          	beq	a3,a5,ffffffffc0201f46 <slob_alloc.constprop.0+0x4e>
ffffffffc0201f34:	6780                	ld	s0,8(a5)
ffffffffc0201f36:	4018                	lw	a4,0(s0)
ffffffffc0201f38:	02975a63          	bge	a4,s1,ffffffffc0201f6c <slob_alloc.constprop.0+0x74>
ffffffffc0201f3c:	00093683          	ld	a3,0(s2)
ffffffffc0201f40:	87a2                	mv	a5,s0
ffffffffc0201f42:	fef699e3          	bne	a3,a5,ffffffffc0201f34 <slob_alloc.constprop.0+0x3c>
ffffffffc0201f46:	ee31                	bnez	a2,ffffffffc0201fa2 <slob_alloc.constprop.0+0xaa>
ffffffffc0201f48:	4501                	li	a0,0
ffffffffc0201f4a:	f4bff0ef          	jal	ra,ffffffffc0201e94 <__slob_get_free_pages.constprop.0>
ffffffffc0201f4e:	842a                	mv	s0,a0
ffffffffc0201f50:	cd05                	beqz	a0,ffffffffc0201f88 <slob_alloc.constprop.0+0x90>
ffffffffc0201f52:	6585                	lui	a1,0x1
ffffffffc0201f54:	e8dff0ef          	jal	ra,ffffffffc0201de0 <slob_free>
ffffffffc0201f58:	10002673          	csrr	a2,sstatus
ffffffffc0201f5c:	8a09                	andi	a2,a2,2
ffffffffc0201f5e:	ee05                	bnez	a2,ffffffffc0201f96 <slob_alloc.constprop.0+0x9e>
ffffffffc0201f60:	00093783          	ld	a5,0(s2)
ffffffffc0201f64:	6780                	ld	s0,8(a5)
ffffffffc0201f66:	4018                	lw	a4,0(s0)
ffffffffc0201f68:	fc974ae3          	blt	a4,s1,ffffffffc0201f3c <slob_alloc.constprop.0+0x44>
ffffffffc0201f6c:	04e48763          	beq	s1,a4,ffffffffc0201fba <slob_alloc.constprop.0+0xc2>
ffffffffc0201f70:	00449693          	slli	a3,s1,0x4
ffffffffc0201f74:	96a2                	add	a3,a3,s0
ffffffffc0201f76:	e794                	sd	a3,8(a5)
ffffffffc0201f78:	640c                	ld	a1,8(s0)
ffffffffc0201f7a:	9f05                	subw	a4,a4,s1
ffffffffc0201f7c:	c298                	sw	a4,0(a3)
ffffffffc0201f7e:	e68c                	sd	a1,8(a3)
ffffffffc0201f80:	c004                	sw	s1,0(s0)
ffffffffc0201f82:	00f93023          	sd	a5,0(s2)
ffffffffc0201f86:	e20d                	bnez	a2,ffffffffc0201fa8 <slob_alloc.constprop.0+0xb0>
ffffffffc0201f88:	60e2                	ld	ra,24(sp)
ffffffffc0201f8a:	8522                	mv	a0,s0
ffffffffc0201f8c:	6442                	ld	s0,16(sp)
ffffffffc0201f8e:	64a2                	ld	s1,8(sp)
ffffffffc0201f90:	6902                	ld	s2,0(sp)
ffffffffc0201f92:	6105                	addi	sp,sp,32
ffffffffc0201f94:	8082                	ret
ffffffffc0201f96:	cddfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201f9a:	00093783          	ld	a5,0(s2)
ffffffffc0201f9e:	4605                	li	a2,1
ffffffffc0201fa0:	b7d1                	j	ffffffffc0201f64 <slob_alloc.constprop.0+0x6c>
ffffffffc0201fa2:	ccbfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0201fa6:	b74d                	j	ffffffffc0201f48 <slob_alloc.constprop.0+0x50>
ffffffffc0201fa8:	cc5fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0201fac:	60e2                	ld	ra,24(sp)
ffffffffc0201fae:	8522                	mv	a0,s0
ffffffffc0201fb0:	6442                	ld	s0,16(sp)
ffffffffc0201fb2:	64a2                	ld	s1,8(sp)
ffffffffc0201fb4:	6902                	ld	s2,0(sp)
ffffffffc0201fb6:	6105                	addi	sp,sp,32
ffffffffc0201fb8:	8082                	ret
ffffffffc0201fba:	6418                	ld	a4,8(s0)
ffffffffc0201fbc:	e798                	sd	a4,8(a5)
ffffffffc0201fbe:	b7d1                	j	ffffffffc0201f82 <slob_alloc.constprop.0+0x8a>
ffffffffc0201fc0:	cb3fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201fc4:	4605                	li	a2,1
ffffffffc0201fc6:	bf99                	j	ffffffffc0201f1c <slob_alloc.constprop.0+0x24>
ffffffffc0201fc8:	843e                	mv	s0,a5
ffffffffc0201fca:	87b6                	mv	a5,a3
ffffffffc0201fcc:	b745                	j	ffffffffc0201f6c <slob_alloc.constprop.0+0x74>
ffffffffc0201fce:	0000b697          	auipc	a3,0xb
ffffffffc0201fd2:	87268693          	addi	a3,a3,-1934 # ffffffffc020c840 <default_pmm_manager+0x70>
ffffffffc0201fd6:	0000a617          	auipc	a2,0xa
ffffffffc0201fda:	cf260613          	addi	a2,a2,-782 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0201fde:	06300593          	li	a1,99
ffffffffc0201fe2:	0000b517          	auipc	a0,0xb
ffffffffc0201fe6:	87e50513          	addi	a0,a0,-1922 # ffffffffc020c860 <default_pmm_manager+0x90>
ffffffffc0201fea:	cb4fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201fee <kmalloc_init>:
ffffffffc0201fee:	1141                	addi	sp,sp,-16
ffffffffc0201ff0:	0000b517          	auipc	a0,0xb
ffffffffc0201ff4:	88850513          	addi	a0,a0,-1912 # ffffffffc020c878 <default_pmm_manager+0xa8>
ffffffffc0201ff8:	e406                	sd	ra,8(sp)
ffffffffc0201ffa:	9acfe0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0201ffe:	60a2                	ld	ra,8(sp)
ffffffffc0202000:	0000b517          	auipc	a0,0xb
ffffffffc0202004:	89050513          	addi	a0,a0,-1904 # ffffffffc020c890 <default_pmm_manager+0xc0>
ffffffffc0202008:	0141                	addi	sp,sp,16
ffffffffc020200a:	99cfe06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc020200e <kallocated>:
ffffffffc020200e:	4501                	li	a0,0
ffffffffc0202010:	8082                	ret

ffffffffc0202012 <kmalloc>:
ffffffffc0202012:	1101                	addi	sp,sp,-32
ffffffffc0202014:	e04a                	sd	s2,0(sp)
ffffffffc0202016:	6905                	lui	s2,0x1
ffffffffc0202018:	e822                	sd	s0,16(sp)
ffffffffc020201a:	ec06                	sd	ra,24(sp)
ffffffffc020201c:	e426                	sd	s1,8(sp)
ffffffffc020201e:	fef90793          	addi	a5,s2,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc0202022:	842a                	mv	s0,a0
ffffffffc0202024:	04a7f963          	bgeu	a5,a0,ffffffffc0202076 <kmalloc+0x64>
ffffffffc0202028:	4561                	li	a0,24
ffffffffc020202a:	ecfff0ef          	jal	ra,ffffffffc0201ef8 <slob_alloc.constprop.0>
ffffffffc020202e:	84aa                	mv	s1,a0
ffffffffc0202030:	c929                	beqz	a0,ffffffffc0202082 <kmalloc+0x70>
ffffffffc0202032:	0004079b          	sext.w	a5,s0
ffffffffc0202036:	4501                	li	a0,0
ffffffffc0202038:	00f95763          	bge	s2,a5,ffffffffc0202046 <kmalloc+0x34>
ffffffffc020203c:	6705                	lui	a4,0x1
ffffffffc020203e:	8785                	srai	a5,a5,0x1
ffffffffc0202040:	2505                	addiw	a0,a0,1
ffffffffc0202042:	fef74ee3          	blt	a4,a5,ffffffffc020203e <kmalloc+0x2c>
ffffffffc0202046:	c088                	sw	a0,0(s1)
ffffffffc0202048:	e4dff0ef          	jal	ra,ffffffffc0201e94 <__slob_get_free_pages.constprop.0>
ffffffffc020204c:	e488                	sd	a0,8(s1)
ffffffffc020204e:	842a                	mv	s0,a0
ffffffffc0202050:	c525                	beqz	a0,ffffffffc02020b8 <kmalloc+0xa6>
ffffffffc0202052:	100027f3          	csrr	a5,sstatus
ffffffffc0202056:	8b89                	andi	a5,a5,2
ffffffffc0202058:	ef8d                	bnez	a5,ffffffffc0202092 <kmalloc+0x80>
ffffffffc020205a:	00095797          	auipc	a5,0x95
ffffffffc020205e:	82e78793          	addi	a5,a5,-2002 # ffffffffc0296888 <bigblocks>
ffffffffc0202062:	6398                	ld	a4,0(a5)
ffffffffc0202064:	e384                	sd	s1,0(a5)
ffffffffc0202066:	e898                	sd	a4,16(s1)
ffffffffc0202068:	60e2                	ld	ra,24(sp)
ffffffffc020206a:	8522                	mv	a0,s0
ffffffffc020206c:	6442                	ld	s0,16(sp)
ffffffffc020206e:	64a2                	ld	s1,8(sp)
ffffffffc0202070:	6902                	ld	s2,0(sp)
ffffffffc0202072:	6105                	addi	sp,sp,32
ffffffffc0202074:	8082                	ret
ffffffffc0202076:	0541                	addi	a0,a0,16
ffffffffc0202078:	e81ff0ef          	jal	ra,ffffffffc0201ef8 <slob_alloc.constprop.0>
ffffffffc020207c:	01050413          	addi	s0,a0,16
ffffffffc0202080:	f565                	bnez	a0,ffffffffc0202068 <kmalloc+0x56>
ffffffffc0202082:	4401                	li	s0,0
ffffffffc0202084:	60e2                	ld	ra,24(sp)
ffffffffc0202086:	8522                	mv	a0,s0
ffffffffc0202088:	6442                	ld	s0,16(sp)
ffffffffc020208a:	64a2                	ld	s1,8(sp)
ffffffffc020208c:	6902                	ld	s2,0(sp)
ffffffffc020208e:	6105                	addi	sp,sp,32
ffffffffc0202090:	8082                	ret
ffffffffc0202092:	be1fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202096:	00094797          	auipc	a5,0x94
ffffffffc020209a:	7f278793          	addi	a5,a5,2034 # ffffffffc0296888 <bigblocks>
ffffffffc020209e:	6398                	ld	a4,0(a5)
ffffffffc02020a0:	e384                	sd	s1,0(a5)
ffffffffc02020a2:	e898                	sd	a4,16(s1)
ffffffffc02020a4:	bc9fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02020a8:	6480                	ld	s0,8(s1)
ffffffffc02020aa:	60e2                	ld	ra,24(sp)
ffffffffc02020ac:	64a2                	ld	s1,8(sp)
ffffffffc02020ae:	8522                	mv	a0,s0
ffffffffc02020b0:	6442                	ld	s0,16(sp)
ffffffffc02020b2:	6902                	ld	s2,0(sp)
ffffffffc02020b4:	6105                	addi	sp,sp,32
ffffffffc02020b6:	8082                	ret
ffffffffc02020b8:	45e1                	li	a1,24
ffffffffc02020ba:	8526                	mv	a0,s1
ffffffffc02020bc:	d25ff0ef          	jal	ra,ffffffffc0201de0 <slob_free>
ffffffffc02020c0:	b765                	j	ffffffffc0202068 <kmalloc+0x56>

ffffffffc02020c2 <kfree>:
ffffffffc02020c2:	c169                	beqz	a0,ffffffffc0202184 <kfree+0xc2>
ffffffffc02020c4:	1101                	addi	sp,sp,-32
ffffffffc02020c6:	e822                	sd	s0,16(sp)
ffffffffc02020c8:	ec06                	sd	ra,24(sp)
ffffffffc02020ca:	e426                	sd	s1,8(sp)
ffffffffc02020cc:	03451793          	slli	a5,a0,0x34
ffffffffc02020d0:	842a                	mv	s0,a0
ffffffffc02020d2:	e3d9                	bnez	a5,ffffffffc0202158 <kfree+0x96>
ffffffffc02020d4:	100027f3          	csrr	a5,sstatus
ffffffffc02020d8:	8b89                	andi	a5,a5,2
ffffffffc02020da:	e7d9                	bnez	a5,ffffffffc0202168 <kfree+0xa6>
ffffffffc02020dc:	00094797          	auipc	a5,0x94
ffffffffc02020e0:	7ac7b783          	ld	a5,1964(a5) # ffffffffc0296888 <bigblocks>
ffffffffc02020e4:	4601                	li	a2,0
ffffffffc02020e6:	cbad                	beqz	a5,ffffffffc0202158 <kfree+0x96>
ffffffffc02020e8:	00094697          	auipc	a3,0x94
ffffffffc02020ec:	7a068693          	addi	a3,a3,1952 # ffffffffc0296888 <bigblocks>
ffffffffc02020f0:	a021                	j	ffffffffc02020f8 <kfree+0x36>
ffffffffc02020f2:	01048693          	addi	a3,s1,16
ffffffffc02020f6:	c3a5                	beqz	a5,ffffffffc0202156 <kfree+0x94>
ffffffffc02020f8:	6798                	ld	a4,8(a5)
ffffffffc02020fa:	84be                	mv	s1,a5
ffffffffc02020fc:	6b9c                	ld	a5,16(a5)
ffffffffc02020fe:	fe871ae3          	bne	a4,s0,ffffffffc02020f2 <kfree+0x30>
ffffffffc0202102:	e29c                	sd	a5,0(a3)
ffffffffc0202104:	ee2d                	bnez	a2,ffffffffc020217e <kfree+0xbc>
ffffffffc0202106:	c02007b7          	lui	a5,0xc0200
ffffffffc020210a:	4098                	lw	a4,0(s1)
ffffffffc020210c:	08f46963          	bltu	s0,a5,ffffffffc020219e <kfree+0xdc>
ffffffffc0202110:	00094697          	auipc	a3,0x94
ffffffffc0202114:	7a86b683          	ld	a3,1960(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202118:	8c15                	sub	s0,s0,a3
ffffffffc020211a:	8031                	srli	s0,s0,0xc
ffffffffc020211c:	00094797          	auipc	a5,0x94
ffffffffc0202120:	7847b783          	ld	a5,1924(a5) # ffffffffc02968a0 <npage>
ffffffffc0202124:	06f47163          	bgeu	s0,a5,ffffffffc0202186 <kfree+0xc4>
ffffffffc0202128:	0000e517          	auipc	a0,0xe
ffffffffc020212c:	c0853503          	ld	a0,-1016(a0) # ffffffffc020fd30 <nbase>
ffffffffc0202130:	8c09                	sub	s0,s0,a0
ffffffffc0202132:	041a                	slli	s0,s0,0x6
ffffffffc0202134:	00094517          	auipc	a0,0x94
ffffffffc0202138:	77453503          	ld	a0,1908(a0) # ffffffffc02968a8 <pages>
ffffffffc020213c:	4585                	li	a1,1
ffffffffc020213e:	9522                	add	a0,a0,s0
ffffffffc0202140:	00e595bb          	sllw	a1,a1,a4
ffffffffc0202144:	0ea000ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc0202148:	6442                	ld	s0,16(sp)
ffffffffc020214a:	60e2                	ld	ra,24(sp)
ffffffffc020214c:	8526                	mv	a0,s1
ffffffffc020214e:	64a2                	ld	s1,8(sp)
ffffffffc0202150:	45e1                	li	a1,24
ffffffffc0202152:	6105                	addi	sp,sp,32
ffffffffc0202154:	b171                	j	ffffffffc0201de0 <slob_free>
ffffffffc0202156:	e20d                	bnez	a2,ffffffffc0202178 <kfree+0xb6>
ffffffffc0202158:	ff040513          	addi	a0,s0,-16
ffffffffc020215c:	6442                	ld	s0,16(sp)
ffffffffc020215e:	60e2                	ld	ra,24(sp)
ffffffffc0202160:	64a2                	ld	s1,8(sp)
ffffffffc0202162:	4581                	li	a1,0
ffffffffc0202164:	6105                	addi	sp,sp,32
ffffffffc0202166:	b9ad                	j	ffffffffc0201de0 <slob_free>
ffffffffc0202168:	b0bfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020216c:	00094797          	auipc	a5,0x94
ffffffffc0202170:	71c7b783          	ld	a5,1820(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202174:	4605                	li	a2,1
ffffffffc0202176:	fbad                	bnez	a5,ffffffffc02020e8 <kfree+0x26>
ffffffffc0202178:	af5fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020217c:	bff1                	j	ffffffffc0202158 <kfree+0x96>
ffffffffc020217e:	aeffe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202182:	b751                	j	ffffffffc0202106 <kfree+0x44>
ffffffffc0202184:	8082                	ret
ffffffffc0202186:	0000a617          	auipc	a2,0xa
ffffffffc020218a:	75260613          	addi	a2,a2,1874 # ffffffffc020c8d8 <default_pmm_manager+0x108>
ffffffffc020218e:	06900593          	li	a1,105
ffffffffc0202192:	0000a517          	auipc	a0,0xa
ffffffffc0202196:	69e50513          	addi	a0,a0,1694 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc020219a:	b04fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020219e:	86a2                	mv	a3,s0
ffffffffc02021a0:	0000a617          	auipc	a2,0xa
ffffffffc02021a4:	71060613          	addi	a2,a2,1808 # ffffffffc020c8b0 <default_pmm_manager+0xe0>
ffffffffc02021a8:	07700593          	li	a1,119
ffffffffc02021ac:	0000a517          	auipc	a0,0xa
ffffffffc02021b0:	68450513          	addi	a0,a0,1668 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc02021b4:	aeafe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02021b8 <pa2page.part.0>:
ffffffffc02021b8:	1141                	addi	sp,sp,-16
ffffffffc02021ba:	0000a617          	auipc	a2,0xa
ffffffffc02021be:	71e60613          	addi	a2,a2,1822 # ffffffffc020c8d8 <default_pmm_manager+0x108>
ffffffffc02021c2:	06900593          	li	a1,105
ffffffffc02021c6:	0000a517          	auipc	a0,0xa
ffffffffc02021ca:	66a50513          	addi	a0,a0,1642 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc02021ce:	e406                	sd	ra,8(sp)
ffffffffc02021d0:	acefe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02021d4 <pte2page.part.0>:
ffffffffc02021d4:	1141                	addi	sp,sp,-16
ffffffffc02021d6:	0000a617          	auipc	a2,0xa
ffffffffc02021da:	72260613          	addi	a2,a2,1826 # ffffffffc020c8f8 <default_pmm_manager+0x128>
ffffffffc02021de:	07f00593          	li	a1,127
ffffffffc02021e2:	0000a517          	auipc	a0,0xa
ffffffffc02021e6:	64e50513          	addi	a0,a0,1614 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc02021ea:	e406                	sd	ra,8(sp)
ffffffffc02021ec:	ab2fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02021f0 <alloc_pages>:
ffffffffc02021f0:	100027f3          	csrr	a5,sstatus
ffffffffc02021f4:	8b89                	andi	a5,a5,2
ffffffffc02021f6:	e799                	bnez	a5,ffffffffc0202204 <alloc_pages+0x14>
ffffffffc02021f8:	00094797          	auipc	a5,0x94
ffffffffc02021fc:	6b87b783          	ld	a5,1720(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202200:	6f9c                	ld	a5,24(a5)
ffffffffc0202202:	8782                	jr	a5
ffffffffc0202204:	1141                	addi	sp,sp,-16
ffffffffc0202206:	e406                	sd	ra,8(sp)
ffffffffc0202208:	e022                	sd	s0,0(sp)
ffffffffc020220a:	842a                	mv	s0,a0
ffffffffc020220c:	a67fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202210:	00094797          	auipc	a5,0x94
ffffffffc0202214:	6a07b783          	ld	a5,1696(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202218:	6f9c                	ld	a5,24(a5)
ffffffffc020221a:	8522                	mv	a0,s0
ffffffffc020221c:	9782                	jalr	a5
ffffffffc020221e:	842a                	mv	s0,a0
ffffffffc0202220:	a4dfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202224:	60a2                	ld	ra,8(sp)
ffffffffc0202226:	8522                	mv	a0,s0
ffffffffc0202228:	6402                	ld	s0,0(sp)
ffffffffc020222a:	0141                	addi	sp,sp,16
ffffffffc020222c:	8082                	ret

ffffffffc020222e <free_pages>:
ffffffffc020222e:	100027f3          	csrr	a5,sstatus
ffffffffc0202232:	8b89                	andi	a5,a5,2
ffffffffc0202234:	e799                	bnez	a5,ffffffffc0202242 <free_pages+0x14>
ffffffffc0202236:	00094797          	auipc	a5,0x94
ffffffffc020223a:	67a7b783          	ld	a5,1658(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020223e:	739c                	ld	a5,32(a5)
ffffffffc0202240:	8782                	jr	a5
ffffffffc0202242:	1101                	addi	sp,sp,-32
ffffffffc0202244:	ec06                	sd	ra,24(sp)
ffffffffc0202246:	e822                	sd	s0,16(sp)
ffffffffc0202248:	e426                	sd	s1,8(sp)
ffffffffc020224a:	842a                	mv	s0,a0
ffffffffc020224c:	84ae                	mv	s1,a1
ffffffffc020224e:	a25fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202252:	00094797          	auipc	a5,0x94
ffffffffc0202256:	65e7b783          	ld	a5,1630(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020225a:	739c                	ld	a5,32(a5)
ffffffffc020225c:	85a6                	mv	a1,s1
ffffffffc020225e:	8522                	mv	a0,s0
ffffffffc0202260:	9782                	jalr	a5
ffffffffc0202262:	6442                	ld	s0,16(sp)
ffffffffc0202264:	60e2                	ld	ra,24(sp)
ffffffffc0202266:	64a2                	ld	s1,8(sp)
ffffffffc0202268:	6105                	addi	sp,sp,32
ffffffffc020226a:	a03fe06f          	j	ffffffffc0200c6c <intr_enable>

ffffffffc020226e <nr_free_pages>:
ffffffffc020226e:	100027f3          	csrr	a5,sstatus
ffffffffc0202272:	8b89                	andi	a5,a5,2
ffffffffc0202274:	e799                	bnez	a5,ffffffffc0202282 <nr_free_pages+0x14>
ffffffffc0202276:	00094797          	auipc	a5,0x94
ffffffffc020227a:	63a7b783          	ld	a5,1594(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020227e:	779c                	ld	a5,40(a5)
ffffffffc0202280:	8782                	jr	a5
ffffffffc0202282:	1141                	addi	sp,sp,-16
ffffffffc0202284:	e406                	sd	ra,8(sp)
ffffffffc0202286:	e022                	sd	s0,0(sp)
ffffffffc0202288:	9ebfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020228c:	00094797          	auipc	a5,0x94
ffffffffc0202290:	6247b783          	ld	a5,1572(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202294:	779c                	ld	a5,40(a5)
ffffffffc0202296:	9782                	jalr	a5
ffffffffc0202298:	842a                	mv	s0,a0
ffffffffc020229a:	9d3fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020229e:	60a2                	ld	ra,8(sp)
ffffffffc02022a0:	8522                	mv	a0,s0
ffffffffc02022a2:	6402                	ld	s0,0(sp)
ffffffffc02022a4:	0141                	addi	sp,sp,16
ffffffffc02022a6:	8082                	ret

ffffffffc02022a8 <get_pte>:
ffffffffc02022a8:	01e5d793          	srli	a5,a1,0x1e
ffffffffc02022ac:	1ff7f793          	andi	a5,a5,511
ffffffffc02022b0:	7139                	addi	sp,sp,-64
ffffffffc02022b2:	078e                	slli	a5,a5,0x3
ffffffffc02022b4:	f426                	sd	s1,40(sp)
ffffffffc02022b6:	00f504b3          	add	s1,a0,a5
ffffffffc02022ba:	6094                	ld	a3,0(s1)
ffffffffc02022bc:	f04a                	sd	s2,32(sp)
ffffffffc02022be:	ec4e                	sd	s3,24(sp)
ffffffffc02022c0:	e852                	sd	s4,16(sp)
ffffffffc02022c2:	fc06                	sd	ra,56(sp)
ffffffffc02022c4:	f822                	sd	s0,48(sp)
ffffffffc02022c6:	e456                	sd	s5,8(sp)
ffffffffc02022c8:	e05a                	sd	s6,0(sp)
ffffffffc02022ca:	0016f793          	andi	a5,a3,1
ffffffffc02022ce:	892e                	mv	s2,a1
ffffffffc02022d0:	8a32                	mv	s4,a2
ffffffffc02022d2:	00094997          	auipc	s3,0x94
ffffffffc02022d6:	5ce98993          	addi	s3,s3,1486 # ffffffffc02968a0 <npage>
ffffffffc02022da:	efbd                	bnez	a5,ffffffffc0202358 <get_pte+0xb0>
ffffffffc02022dc:	14060c63          	beqz	a2,ffffffffc0202434 <get_pte+0x18c>
ffffffffc02022e0:	100027f3          	csrr	a5,sstatus
ffffffffc02022e4:	8b89                	andi	a5,a5,2
ffffffffc02022e6:	14079963          	bnez	a5,ffffffffc0202438 <get_pte+0x190>
ffffffffc02022ea:	00094797          	auipc	a5,0x94
ffffffffc02022ee:	5c67b783          	ld	a5,1478(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02022f2:	6f9c                	ld	a5,24(a5)
ffffffffc02022f4:	4505                	li	a0,1
ffffffffc02022f6:	9782                	jalr	a5
ffffffffc02022f8:	842a                	mv	s0,a0
ffffffffc02022fa:	12040d63          	beqz	s0,ffffffffc0202434 <get_pte+0x18c>
ffffffffc02022fe:	00094b17          	auipc	s6,0x94
ffffffffc0202302:	5aab0b13          	addi	s6,s6,1450 # ffffffffc02968a8 <pages>
ffffffffc0202306:	000b3503          	ld	a0,0(s6)
ffffffffc020230a:	00080ab7          	lui	s5,0x80
ffffffffc020230e:	00094997          	auipc	s3,0x94
ffffffffc0202312:	59298993          	addi	s3,s3,1426 # ffffffffc02968a0 <npage>
ffffffffc0202316:	40a40533          	sub	a0,s0,a0
ffffffffc020231a:	8519                	srai	a0,a0,0x6
ffffffffc020231c:	9556                	add	a0,a0,s5
ffffffffc020231e:	0009b703          	ld	a4,0(s3)
ffffffffc0202322:	00c51793          	slli	a5,a0,0xc
ffffffffc0202326:	4685                	li	a3,1
ffffffffc0202328:	c014                	sw	a3,0(s0)
ffffffffc020232a:	83b1                	srli	a5,a5,0xc
ffffffffc020232c:	0532                	slli	a0,a0,0xc
ffffffffc020232e:	16e7f763          	bgeu	a5,a4,ffffffffc020249c <get_pte+0x1f4>
ffffffffc0202332:	00094797          	auipc	a5,0x94
ffffffffc0202336:	5867b783          	ld	a5,1414(a5) # ffffffffc02968b8 <va_pa_offset>
ffffffffc020233a:	6605                	lui	a2,0x1
ffffffffc020233c:	4581                	li	a1,0
ffffffffc020233e:	953e                	add	a0,a0,a5
ffffffffc0202340:	4a6090ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0202344:	000b3683          	ld	a3,0(s6)
ffffffffc0202348:	40d406b3          	sub	a3,s0,a3
ffffffffc020234c:	8699                	srai	a3,a3,0x6
ffffffffc020234e:	96d6                	add	a3,a3,s5
ffffffffc0202350:	06aa                	slli	a3,a3,0xa
ffffffffc0202352:	0116e693          	ori	a3,a3,17
ffffffffc0202356:	e094                	sd	a3,0(s1)
ffffffffc0202358:	77fd                	lui	a5,0xfffff
ffffffffc020235a:	068a                	slli	a3,a3,0x2
ffffffffc020235c:	0009b703          	ld	a4,0(s3)
ffffffffc0202360:	8efd                	and	a3,a3,a5
ffffffffc0202362:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202366:	10e7ff63          	bgeu	a5,a4,ffffffffc0202484 <get_pte+0x1dc>
ffffffffc020236a:	00094a97          	auipc	s5,0x94
ffffffffc020236e:	54ea8a93          	addi	s5,s5,1358 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202372:	000ab403          	ld	s0,0(s5)
ffffffffc0202376:	01595793          	srli	a5,s2,0x15
ffffffffc020237a:	1ff7f793          	andi	a5,a5,511
ffffffffc020237e:	96a2                	add	a3,a3,s0
ffffffffc0202380:	00379413          	slli	s0,a5,0x3
ffffffffc0202384:	9436                	add	s0,s0,a3
ffffffffc0202386:	6014                	ld	a3,0(s0)
ffffffffc0202388:	0016f793          	andi	a5,a3,1
ffffffffc020238c:	ebad                	bnez	a5,ffffffffc02023fe <get_pte+0x156>
ffffffffc020238e:	0a0a0363          	beqz	s4,ffffffffc0202434 <get_pte+0x18c>
ffffffffc0202392:	100027f3          	csrr	a5,sstatus
ffffffffc0202396:	8b89                	andi	a5,a5,2
ffffffffc0202398:	efcd                	bnez	a5,ffffffffc0202452 <get_pte+0x1aa>
ffffffffc020239a:	00094797          	auipc	a5,0x94
ffffffffc020239e:	5167b783          	ld	a5,1302(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02023a2:	6f9c                	ld	a5,24(a5)
ffffffffc02023a4:	4505                	li	a0,1
ffffffffc02023a6:	9782                	jalr	a5
ffffffffc02023a8:	84aa                	mv	s1,a0
ffffffffc02023aa:	c4c9                	beqz	s1,ffffffffc0202434 <get_pte+0x18c>
ffffffffc02023ac:	00094b17          	auipc	s6,0x94
ffffffffc02023b0:	4fcb0b13          	addi	s6,s6,1276 # ffffffffc02968a8 <pages>
ffffffffc02023b4:	000b3503          	ld	a0,0(s6)
ffffffffc02023b8:	00080a37          	lui	s4,0x80
ffffffffc02023bc:	0009b703          	ld	a4,0(s3)
ffffffffc02023c0:	40a48533          	sub	a0,s1,a0
ffffffffc02023c4:	8519                	srai	a0,a0,0x6
ffffffffc02023c6:	9552                	add	a0,a0,s4
ffffffffc02023c8:	00c51793          	slli	a5,a0,0xc
ffffffffc02023cc:	4685                	li	a3,1
ffffffffc02023ce:	c094                	sw	a3,0(s1)
ffffffffc02023d0:	83b1                	srli	a5,a5,0xc
ffffffffc02023d2:	0532                	slli	a0,a0,0xc
ffffffffc02023d4:	0ee7f163          	bgeu	a5,a4,ffffffffc02024b6 <get_pte+0x20e>
ffffffffc02023d8:	000ab783          	ld	a5,0(s5)
ffffffffc02023dc:	6605                	lui	a2,0x1
ffffffffc02023de:	4581                	li	a1,0
ffffffffc02023e0:	953e                	add	a0,a0,a5
ffffffffc02023e2:	404090ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc02023e6:	000b3683          	ld	a3,0(s6)
ffffffffc02023ea:	40d486b3          	sub	a3,s1,a3
ffffffffc02023ee:	8699                	srai	a3,a3,0x6
ffffffffc02023f0:	96d2                	add	a3,a3,s4
ffffffffc02023f2:	06aa                	slli	a3,a3,0xa
ffffffffc02023f4:	0116e693          	ori	a3,a3,17
ffffffffc02023f8:	e014                	sd	a3,0(s0)
ffffffffc02023fa:	0009b703          	ld	a4,0(s3)
ffffffffc02023fe:	068a                	slli	a3,a3,0x2
ffffffffc0202400:	757d                	lui	a0,0xfffff
ffffffffc0202402:	8ee9                	and	a3,a3,a0
ffffffffc0202404:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202408:	06e7f263          	bgeu	a5,a4,ffffffffc020246c <get_pte+0x1c4>
ffffffffc020240c:	000ab503          	ld	a0,0(s5)
ffffffffc0202410:	00c95913          	srli	s2,s2,0xc
ffffffffc0202414:	1ff97913          	andi	s2,s2,511
ffffffffc0202418:	96aa                	add	a3,a3,a0
ffffffffc020241a:	00391513          	slli	a0,s2,0x3
ffffffffc020241e:	9536                	add	a0,a0,a3
ffffffffc0202420:	70e2                	ld	ra,56(sp)
ffffffffc0202422:	7442                	ld	s0,48(sp)
ffffffffc0202424:	74a2                	ld	s1,40(sp)
ffffffffc0202426:	7902                	ld	s2,32(sp)
ffffffffc0202428:	69e2                	ld	s3,24(sp)
ffffffffc020242a:	6a42                	ld	s4,16(sp)
ffffffffc020242c:	6aa2                	ld	s5,8(sp)
ffffffffc020242e:	6b02                	ld	s6,0(sp)
ffffffffc0202430:	6121                	addi	sp,sp,64
ffffffffc0202432:	8082                	ret
ffffffffc0202434:	4501                	li	a0,0
ffffffffc0202436:	b7ed                	j	ffffffffc0202420 <get_pte+0x178>
ffffffffc0202438:	83bfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020243c:	00094797          	auipc	a5,0x94
ffffffffc0202440:	4747b783          	ld	a5,1140(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202444:	6f9c                	ld	a5,24(a5)
ffffffffc0202446:	4505                	li	a0,1
ffffffffc0202448:	9782                	jalr	a5
ffffffffc020244a:	842a                	mv	s0,a0
ffffffffc020244c:	821fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202450:	b56d                	j	ffffffffc02022fa <get_pte+0x52>
ffffffffc0202452:	821fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202456:	00094797          	auipc	a5,0x94
ffffffffc020245a:	45a7b783          	ld	a5,1114(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020245e:	6f9c                	ld	a5,24(a5)
ffffffffc0202460:	4505                	li	a0,1
ffffffffc0202462:	9782                	jalr	a5
ffffffffc0202464:	84aa                	mv	s1,a0
ffffffffc0202466:	807fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020246a:	b781                	j	ffffffffc02023aa <get_pte+0x102>
ffffffffc020246c:	0000a617          	auipc	a2,0xa
ffffffffc0202470:	39c60613          	addi	a2,a2,924 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc0202474:	13200593          	li	a1,306
ffffffffc0202478:	0000a517          	auipc	a0,0xa
ffffffffc020247c:	4a850513          	addi	a0,a0,1192 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0202480:	81efe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202484:	0000a617          	auipc	a2,0xa
ffffffffc0202488:	38460613          	addi	a2,a2,900 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc020248c:	12500593          	li	a1,293
ffffffffc0202490:	0000a517          	auipc	a0,0xa
ffffffffc0202494:	49050513          	addi	a0,a0,1168 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0202498:	806fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020249c:	86aa                	mv	a3,a0
ffffffffc020249e:	0000a617          	auipc	a2,0xa
ffffffffc02024a2:	36a60613          	addi	a2,a2,874 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc02024a6:	12100593          	li	a1,289
ffffffffc02024aa:	0000a517          	auipc	a0,0xa
ffffffffc02024ae:	47650513          	addi	a0,a0,1142 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02024b2:	fedfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02024b6:	86aa                	mv	a3,a0
ffffffffc02024b8:	0000a617          	auipc	a2,0xa
ffffffffc02024bc:	35060613          	addi	a2,a2,848 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc02024c0:	12f00593          	li	a1,303
ffffffffc02024c4:	0000a517          	auipc	a0,0xa
ffffffffc02024c8:	45c50513          	addi	a0,a0,1116 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02024cc:	fd3fd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02024d0 <boot_map_segment>:
ffffffffc02024d0:	6785                	lui	a5,0x1
ffffffffc02024d2:	7139                	addi	sp,sp,-64
ffffffffc02024d4:	00d5c833          	xor	a6,a1,a3
ffffffffc02024d8:	17fd                	addi	a5,a5,-1
ffffffffc02024da:	fc06                	sd	ra,56(sp)
ffffffffc02024dc:	f822                	sd	s0,48(sp)
ffffffffc02024de:	f426                	sd	s1,40(sp)
ffffffffc02024e0:	f04a                	sd	s2,32(sp)
ffffffffc02024e2:	ec4e                	sd	s3,24(sp)
ffffffffc02024e4:	e852                	sd	s4,16(sp)
ffffffffc02024e6:	e456                	sd	s5,8(sp)
ffffffffc02024e8:	00f87833          	and	a6,a6,a5
ffffffffc02024ec:	08081563          	bnez	a6,ffffffffc0202576 <boot_map_segment+0xa6>
ffffffffc02024f0:	00f5f4b3          	and	s1,a1,a5
ffffffffc02024f4:	963e                	add	a2,a2,a5
ffffffffc02024f6:	94b2                	add	s1,s1,a2
ffffffffc02024f8:	797d                	lui	s2,0xfffff
ffffffffc02024fa:	80b1                	srli	s1,s1,0xc
ffffffffc02024fc:	0125f5b3          	and	a1,a1,s2
ffffffffc0202500:	0126f6b3          	and	a3,a3,s2
ffffffffc0202504:	c0a1                	beqz	s1,ffffffffc0202544 <boot_map_segment+0x74>
ffffffffc0202506:	00176713          	ori	a4,a4,1
ffffffffc020250a:	04b2                	slli	s1,s1,0xc
ffffffffc020250c:	02071993          	slli	s3,a4,0x20
ffffffffc0202510:	8a2a                	mv	s4,a0
ffffffffc0202512:	842e                	mv	s0,a1
ffffffffc0202514:	94ae                	add	s1,s1,a1
ffffffffc0202516:	40b68933          	sub	s2,a3,a1
ffffffffc020251a:	0209d993          	srli	s3,s3,0x20
ffffffffc020251e:	6a85                	lui	s5,0x1
ffffffffc0202520:	4605                	li	a2,1
ffffffffc0202522:	85a2                	mv	a1,s0
ffffffffc0202524:	8552                	mv	a0,s4
ffffffffc0202526:	d83ff0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc020252a:	008907b3          	add	a5,s2,s0
ffffffffc020252e:	c505                	beqz	a0,ffffffffc0202556 <boot_map_segment+0x86>
ffffffffc0202530:	83b1                	srli	a5,a5,0xc
ffffffffc0202532:	07aa                	slli	a5,a5,0xa
ffffffffc0202534:	0137e7b3          	or	a5,a5,s3
ffffffffc0202538:	0017e793          	ori	a5,a5,1
ffffffffc020253c:	e11c                	sd	a5,0(a0)
ffffffffc020253e:	9456                	add	s0,s0,s5
ffffffffc0202540:	fe8490e3          	bne	s1,s0,ffffffffc0202520 <boot_map_segment+0x50>
ffffffffc0202544:	70e2                	ld	ra,56(sp)
ffffffffc0202546:	7442                	ld	s0,48(sp)
ffffffffc0202548:	74a2                	ld	s1,40(sp)
ffffffffc020254a:	7902                	ld	s2,32(sp)
ffffffffc020254c:	69e2                	ld	s3,24(sp)
ffffffffc020254e:	6a42                	ld	s4,16(sp)
ffffffffc0202550:	6aa2                	ld	s5,8(sp)
ffffffffc0202552:	6121                	addi	sp,sp,64
ffffffffc0202554:	8082                	ret
ffffffffc0202556:	0000a697          	auipc	a3,0xa
ffffffffc020255a:	3f268693          	addi	a3,a3,1010 # ffffffffc020c948 <default_pmm_manager+0x178>
ffffffffc020255e:	00009617          	auipc	a2,0x9
ffffffffc0202562:	76a60613          	addi	a2,a2,1898 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0202566:	09c00593          	li	a1,156
ffffffffc020256a:	0000a517          	auipc	a0,0xa
ffffffffc020256e:	3b650513          	addi	a0,a0,950 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0202572:	f2dfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202576:	0000a697          	auipc	a3,0xa
ffffffffc020257a:	3ba68693          	addi	a3,a3,954 # ffffffffc020c930 <default_pmm_manager+0x160>
ffffffffc020257e:	00009617          	auipc	a2,0x9
ffffffffc0202582:	74a60613          	addi	a2,a2,1866 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0202586:	09500593          	li	a1,149
ffffffffc020258a:	0000a517          	auipc	a0,0xa
ffffffffc020258e:	39650513          	addi	a0,a0,918 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0202592:	f0dfd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0202596 <get_page>:
ffffffffc0202596:	1141                	addi	sp,sp,-16
ffffffffc0202598:	e022                	sd	s0,0(sp)
ffffffffc020259a:	8432                	mv	s0,a2
ffffffffc020259c:	4601                	li	a2,0
ffffffffc020259e:	e406                	sd	ra,8(sp)
ffffffffc02025a0:	d09ff0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc02025a4:	c011                	beqz	s0,ffffffffc02025a8 <get_page+0x12>
ffffffffc02025a6:	e008                	sd	a0,0(s0)
ffffffffc02025a8:	c511                	beqz	a0,ffffffffc02025b4 <get_page+0x1e>
ffffffffc02025aa:	611c                	ld	a5,0(a0)
ffffffffc02025ac:	4501                	li	a0,0
ffffffffc02025ae:	0017f713          	andi	a4,a5,1
ffffffffc02025b2:	e709                	bnez	a4,ffffffffc02025bc <get_page+0x26>
ffffffffc02025b4:	60a2                	ld	ra,8(sp)
ffffffffc02025b6:	6402                	ld	s0,0(sp)
ffffffffc02025b8:	0141                	addi	sp,sp,16
ffffffffc02025ba:	8082                	ret
ffffffffc02025bc:	078a                	slli	a5,a5,0x2
ffffffffc02025be:	83b1                	srli	a5,a5,0xc
ffffffffc02025c0:	00094717          	auipc	a4,0x94
ffffffffc02025c4:	2e073703          	ld	a4,736(a4) # ffffffffc02968a0 <npage>
ffffffffc02025c8:	00e7ff63          	bgeu	a5,a4,ffffffffc02025e6 <get_page+0x50>
ffffffffc02025cc:	60a2                	ld	ra,8(sp)
ffffffffc02025ce:	6402                	ld	s0,0(sp)
ffffffffc02025d0:	fff80537          	lui	a0,0xfff80
ffffffffc02025d4:	97aa                	add	a5,a5,a0
ffffffffc02025d6:	079a                	slli	a5,a5,0x6
ffffffffc02025d8:	00094517          	auipc	a0,0x94
ffffffffc02025dc:	2d053503          	ld	a0,720(a0) # ffffffffc02968a8 <pages>
ffffffffc02025e0:	953e                	add	a0,a0,a5
ffffffffc02025e2:	0141                	addi	sp,sp,16
ffffffffc02025e4:	8082                	ret
ffffffffc02025e6:	bd3ff0ef          	jal	ra,ffffffffc02021b8 <pa2page.part.0>

ffffffffc02025ea <unmap_range>:
ffffffffc02025ea:	7159                	addi	sp,sp,-112
ffffffffc02025ec:	00c5e7b3          	or	a5,a1,a2
ffffffffc02025f0:	f486                	sd	ra,104(sp)
ffffffffc02025f2:	f0a2                	sd	s0,96(sp)
ffffffffc02025f4:	eca6                	sd	s1,88(sp)
ffffffffc02025f6:	e8ca                	sd	s2,80(sp)
ffffffffc02025f8:	e4ce                	sd	s3,72(sp)
ffffffffc02025fa:	e0d2                	sd	s4,64(sp)
ffffffffc02025fc:	fc56                	sd	s5,56(sp)
ffffffffc02025fe:	f85a                	sd	s6,48(sp)
ffffffffc0202600:	f45e                	sd	s7,40(sp)
ffffffffc0202602:	f062                	sd	s8,32(sp)
ffffffffc0202604:	ec66                	sd	s9,24(sp)
ffffffffc0202606:	e86a                	sd	s10,16(sp)
ffffffffc0202608:	17d2                	slli	a5,a5,0x34
ffffffffc020260a:	e3ed                	bnez	a5,ffffffffc02026ec <unmap_range+0x102>
ffffffffc020260c:	002007b7          	lui	a5,0x200
ffffffffc0202610:	842e                	mv	s0,a1
ffffffffc0202612:	0ef5ed63          	bltu	a1,a5,ffffffffc020270c <unmap_range+0x122>
ffffffffc0202616:	8932                	mv	s2,a2
ffffffffc0202618:	0ec5fa63          	bgeu	a1,a2,ffffffffc020270c <unmap_range+0x122>
ffffffffc020261c:	4785                	li	a5,1
ffffffffc020261e:	07fe                	slli	a5,a5,0x1f
ffffffffc0202620:	0ec7e663          	bltu	a5,a2,ffffffffc020270c <unmap_range+0x122>
ffffffffc0202624:	89aa                	mv	s3,a0
ffffffffc0202626:	6a05                	lui	s4,0x1
ffffffffc0202628:	00094c97          	auipc	s9,0x94
ffffffffc020262c:	278c8c93          	addi	s9,s9,632 # ffffffffc02968a0 <npage>
ffffffffc0202630:	00094c17          	auipc	s8,0x94
ffffffffc0202634:	278c0c13          	addi	s8,s8,632 # ffffffffc02968a8 <pages>
ffffffffc0202638:	fff80bb7          	lui	s7,0xfff80
ffffffffc020263c:	00094d17          	auipc	s10,0x94
ffffffffc0202640:	274d0d13          	addi	s10,s10,628 # ffffffffc02968b0 <pmm_manager>
ffffffffc0202644:	00200b37          	lui	s6,0x200
ffffffffc0202648:	ffe00ab7          	lui	s5,0xffe00
ffffffffc020264c:	4601                	li	a2,0
ffffffffc020264e:	85a2                	mv	a1,s0
ffffffffc0202650:	854e                	mv	a0,s3
ffffffffc0202652:	c57ff0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc0202656:	84aa                	mv	s1,a0
ffffffffc0202658:	cd29                	beqz	a0,ffffffffc02026b2 <unmap_range+0xc8>
ffffffffc020265a:	611c                	ld	a5,0(a0)
ffffffffc020265c:	e395                	bnez	a5,ffffffffc0202680 <unmap_range+0x96>
ffffffffc020265e:	9452                	add	s0,s0,s4
ffffffffc0202660:	ff2466e3          	bltu	s0,s2,ffffffffc020264c <unmap_range+0x62>
ffffffffc0202664:	70a6                	ld	ra,104(sp)
ffffffffc0202666:	7406                	ld	s0,96(sp)
ffffffffc0202668:	64e6                	ld	s1,88(sp)
ffffffffc020266a:	6946                	ld	s2,80(sp)
ffffffffc020266c:	69a6                	ld	s3,72(sp)
ffffffffc020266e:	6a06                	ld	s4,64(sp)
ffffffffc0202670:	7ae2                	ld	s5,56(sp)
ffffffffc0202672:	7b42                	ld	s6,48(sp)
ffffffffc0202674:	7ba2                	ld	s7,40(sp)
ffffffffc0202676:	7c02                	ld	s8,32(sp)
ffffffffc0202678:	6ce2                	ld	s9,24(sp)
ffffffffc020267a:	6d42                	ld	s10,16(sp)
ffffffffc020267c:	6165                	addi	sp,sp,112
ffffffffc020267e:	8082                	ret
ffffffffc0202680:	0017f713          	andi	a4,a5,1
ffffffffc0202684:	df69                	beqz	a4,ffffffffc020265e <unmap_range+0x74>
ffffffffc0202686:	000cb703          	ld	a4,0(s9)
ffffffffc020268a:	078a                	slli	a5,a5,0x2
ffffffffc020268c:	83b1                	srli	a5,a5,0xc
ffffffffc020268e:	08e7ff63          	bgeu	a5,a4,ffffffffc020272c <unmap_range+0x142>
ffffffffc0202692:	000c3503          	ld	a0,0(s8)
ffffffffc0202696:	97de                	add	a5,a5,s7
ffffffffc0202698:	079a                	slli	a5,a5,0x6
ffffffffc020269a:	953e                	add	a0,a0,a5
ffffffffc020269c:	411c                	lw	a5,0(a0)
ffffffffc020269e:	fff7871b          	addiw	a4,a5,-1
ffffffffc02026a2:	c118                	sw	a4,0(a0)
ffffffffc02026a4:	cf11                	beqz	a4,ffffffffc02026c0 <unmap_range+0xd6>
ffffffffc02026a6:	0004b023          	sd	zero,0(s1)
ffffffffc02026aa:	12040073          	sfence.vma	s0
ffffffffc02026ae:	9452                	add	s0,s0,s4
ffffffffc02026b0:	bf45                	j	ffffffffc0202660 <unmap_range+0x76>
ffffffffc02026b2:	945a                	add	s0,s0,s6
ffffffffc02026b4:	01547433          	and	s0,s0,s5
ffffffffc02026b8:	d455                	beqz	s0,ffffffffc0202664 <unmap_range+0x7a>
ffffffffc02026ba:	f92469e3          	bltu	s0,s2,ffffffffc020264c <unmap_range+0x62>
ffffffffc02026be:	b75d                	j	ffffffffc0202664 <unmap_range+0x7a>
ffffffffc02026c0:	100027f3          	csrr	a5,sstatus
ffffffffc02026c4:	8b89                	andi	a5,a5,2
ffffffffc02026c6:	e799                	bnez	a5,ffffffffc02026d4 <unmap_range+0xea>
ffffffffc02026c8:	000d3783          	ld	a5,0(s10)
ffffffffc02026cc:	4585                	li	a1,1
ffffffffc02026ce:	739c                	ld	a5,32(a5)
ffffffffc02026d0:	9782                	jalr	a5
ffffffffc02026d2:	bfd1                	j	ffffffffc02026a6 <unmap_range+0xbc>
ffffffffc02026d4:	e42a                	sd	a0,8(sp)
ffffffffc02026d6:	d9cfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02026da:	000d3783          	ld	a5,0(s10)
ffffffffc02026de:	6522                	ld	a0,8(sp)
ffffffffc02026e0:	4585                	li	a1,1
ffffffffc02026e2:	739c                	ld	a5,32(a5)
ffffffffc02026e4:	9782                	jalr	a5
ffffffffc02026e6:	d86fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02026ea:	bf75                	j	ffffffffc02026a6 <unmap_range+0xbc>
ffffffffc02026ec:	0000a697          	auipc	a3,0xa
ffffffffc02026f0:	26c68693          	addi	a3,a3,620 # ffffffffc020c958 <default_pmm_manager+0x188>
ffffffffc02026f4:	00009617          	auipc	a2,0x9
ffffffffc02026f8:	5d460613          	addi	a2,a2,1492 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02026fc:	15a00593          	li	a1,346
ffffffffc0202700:	0000a517          	auipc	a0,0xa
ffffffffc0202704:	22050513          	addi	a0,a0,544 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0202708:	d97fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020270c:	0000a697          	auipc	a3,0xa
ffffffffc0202710:	27c68693          	addi	a3,a3,636 # ffffffffc020c988 <default_pmm_manager+0x1b8>
ffffffffc0202714:	00009617          	auipc	a2,0x9
ffffffffc0202718:	5b460613          	addi	a2,a2,1460 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020271c:	15b00593          	li	a1,347
ffffffffc0202720:	0000a517          	auipc	a0,0xa
ffffffffc0202724:	20050513          	addi	a0,a0,512 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0202728:	d77fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020272c:	a8dff0ef          	jal	ra,ffffffffc02021b8 <pa2page.part.0>

ffffffffc0202730 <exit_range>:
ffffffffc0202730:	7119                	addi	sp,sp,-128
ffffffffc0202732:	00c5e7b3          	or	a5,a1,a2
ffffffffc0202736:	fc86                	sd	ra,120(sp)
ffffffffc0202738:	f8a2                	sd	s0,112(sp)
ffffffffc020273a:	f4a6                	sd	s1,104(sp)
ffffffffc020273c:	f0ca                	sd	s2,96(sp)
ffffffffc020273e:	ecce                	sd	s3,88(sp)
ffffffffc0202740:	e8d2                	sd	s4,80(sp)
ffffffffc0202742:	e4d6                	sd	s5,72(sp)
ffffffffc0202744:	e0da                	sd	s6,64(sp)
ffffffffc0202746:	fc5e                	sd	s7,56(sp)
ffffffffc0202748:	f862                	sd	s8,48(sp)
ffffffffc020274a:	f466                	sd	s9,40(sp)
ffffffffc020274c:	f06a                	sd	s10,32(sp)
ffffffffc020274e:	ec6e                	sd	s11,24(sp)
ffffffffc0202750:	17d2                	slli	a5,a5,0x34
ffffffffc0202752:	20079a63          	bnez	a5,ffffffffc0202966 <exit_range+0x236>
ffffffffc0202756:	002007b7          	lui	a5,0x200
ffffffffc020275a:	24f5e463          	bltu	a1,a5,ffffffffc02029a2 <exit_range+0x272>
ffffffffc020275e:	8ab2                	mv	s5,a2
ffffffffc0202760:	24c5f163          	bgeu	a1,a2,ffffffffc02029a2 <exit_range+0x272>
ffffffffc0202764:	4785                	li	a5,1
ffffffffc0202766:	07fe                	slli	a5,a5,0x1f
ffffffffc0202768:	22c7ed63          	bltu	a5,a2,ffffffffc02029a2 <exit_range+0x272>
ffffffffc020276c:	c00009b7          	lui	s3,0xc0000
ffffffffc0202770:	0135f9b3          	and	s3,a1,s3
ffffffffc0202774:	ffe00937          	lui	s2,0xffe00
ffffffffc0202778:	400007b7          	lui	a5,0x40000
ffffffffc020277c:	5cfd                	li	s9,-1
ffffffffc020277e:	8c2a                	mv	s8,a0
ffffffffc0202780:	0125f933          	and	s2,a1,s2
ffffffffc0202784:	99be                	add	s3,s3,a5
ffffffffc0202786:	00094d17          	auipc	s10,0x94
ffffffffc020278a:	11ad0d13          	addi	s10,s10,282 # ffffffffc02968a0 <npage>
ffffffffc020278e:	00ccdc93          	srli	s9,s9,0xc
ffffffffc0202792:	00094717          	auipc	a4,0x94
ffffffffc0202796:	11670713          	addi	a4,a4,278 # ffffffffc02968a8 <pages>
ffffffffc020279a:	00094d97          	auipc	s11,0x94
ffffffffc020279e:	116d8d93          	addi	s11,s11,278 # ffffffffc02968b0 <pmm_manager>
ffffffffc02027a2:	c0000437          	lui	s0,0xc0000
ffffffffc02027a6:	944e                	add	s0,s0,s3
ffffffffc02027a8:	8079                	srli	s0,s0,0x1e
ffffffffc02027aa:	1ff47413          	andi	s0,s0,511
ffffffffc02027ae:	040e                	slli	s0,s0,0x3
ffffffffc02027b0:	9462                	add	s0,s0,s8
ffffffffc02027b2:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc02027b6:	001a7793          	andi	a5,s4,1
ffffffffc02027ba:	eb99                	bnez	a5,ffffffffc02027d0 <exit_range+0xa0>
ffffffffc02027bc:	12098463          	beqz	s3,ffffffffc02028e4 <exit_range+0x1b4>
ffffffffc02027c0:	400007b7          	lui	a5,0x40000
ffffffffc02027c4:	97ce                	add	a5,a5,s3
ffffffffc02027c6:	894e                	mv	s2,s3
ffffffffc02027c8:	1159fe63          	bgeu	s3,s5,ffffffffc02028e4 <exit_range+0x1b4>
ffffffffc02027cc:	89be                	mv	s3,a5
ffffffffc02027ce:	bfd1                	j	ffffffffc02027a2 <exit_range+0x72>
ffffffffc02027d0:	000d3783          	ld	a5,0(s10)
ffffffffc02027d4:	0a0a                	slli	s4,s4,0x2
ffffffffc02027d6:	00ca5a13          	srli	s4,s4,0xc
ffffffffc02027da:	1cfa7263          	bgeu	s4,a5,ffffffffc020299e <exit_range+0x26e>
ffffffffc02027de:	fff80637          	lui	a2,0xfff80
ffffffffc02027e2:	9652                	add	a2,a2,s4
ffffffffc02027e4:	000806b7          	lui	a3,0x80
ffffffffc02027e8:	96b2                	add	a3,a3,a2
ffffffffc02027ea:	0196f5b3          	and	a1,a3,s9
ffffffffc02027ee:	061a                	slli	a2,a2,0x6
ffffffffc02027f0:	06b2                	slli	a3,a3,0xc
ffffffffc02027f2:	18f5fa63          	bgeu	a1,a5,ffffffffc0202986 <exit_range+0x256>
ffffffffc02027f6:	00094817          	auipc	a6,0x94
ffffffffc02027fa:	0c280813          	addi	a6,a6,194 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02027fe:	00083b03          	ld	s6,0(a6)
ffffffffc0202802:	4b85                	li	s7,1
ffffffffc0202804:	fff80e37          	lui	t3,0xfff80
ffffffffc0202808:	9b36                	add	s6,s6,a3
ffffffffc020280a:	00080337          	lui	t1,0x80
ffffffffc020280e:	6885                	lui	a7,0x1
ffffffffc0202810:	a819                	j	ffffffffc0202826 <exit_range+0xf6>
ffffffffc0202812:	4b81                	li	s7,0
ffffffffc0202814:	002007b7          	lui	a5,0x200
ffffffffc0202818:	993e                	add	s2,s2,a5
ffffffffc020281a:	08090c63          	beqz	s2,ffffffffc02028b2 <exit_range+0x182>
ffffffffc020281e:	09397a63          	bgeu	s2,s3,ffffffffc02028b2 <exit_range+0x182>
ffffffffc0202822:	0f597063          	bgeu	s2,s5,ffffffffc0202902 <exit_range+0x1d2>
ffffffffc0202826:	01595493          	srli	s1,s2,0x15
ffffffffc020282a:	1ff4f493          	andi	s1,s1,511
ffffffffc020282e:	048e                	slli	s1,s1,0x3
ffffffffc0202830:	94da                	add	s1,s1,s6
ffffffffc0202832:	609c                	ld	a5,0(s1)
ffffffffc0202834:	0017f693          	andi	a3,a5,1
ffffffffc0202838:	dee9                	beqz	a3,ffffffffc0202812 <exit_range+0xe2>
ffffffffc020283a:	000d3583          	ld	a1,0(s10)
ffffffffc020283e:	078a                	slli	a5,a5,0x2
ffffffffc0202840:	83b1                	srli	a5,a5,0xc
ffffffffc0202842:	14b7fe63          	bgeu	a5,a1,ffffffffc020299e <exit_range+0x26e>
ffffffffc0202846:	97f2                	add	a5,a5,t3
ffffffffc0202848:	006786b3          	add	a3,a5,t1
ffffffffc020284c:	0196feb3          	and	t4,a3,s9
ffffffffc0202850:	00679513          	slli	a0,a5,0x6
ffffffffc0202854:	06b2                	slli	a3,a3,0xc
ffffffffc0202856:	12bef863          	bgeu	t4,a1,ffffffffc0202986 <exit_range+0x256>
ffffffffc020285a:	00083783          	ld	a5,0(a6)
ffffffffc020285e:	96be                	add	a3,a3,a5
ffffffffc0202860:	011685b3          	add	a1,a3,a7
ffffffffc0202864:	629c                	ld	a5,0(a3)
ffffffffc0202866:	8b85                	andi	a5,a5,1
ffffffffc0202868:	f7d5                	bnez	a5,ffffffffc0202814 <exit_range+0xe4>
ffffffffc020286a:	06a1                	addi	a3,a3,8
ffffffffc020286c:	fed59ce3          	bne	a1,a3,ffffffffc0202864 <exit_range+0x134>
ffffffffc0202870:	631c                	ld	a5,0(a4)
ffffffffc0202872:	953e                	add	a0,a0,a5
ffffffffc0202874:	100027f3          	csrr	a5,sstatus
ffffffffc0202878:	8b89                	andi	a5,a5,2
ffffffffc020287a:	e7d9                	bnez	a5,ffffffffc0202908 <exit_range+0x1d8>
ffffffffc020287c:	000db783          	ld	a5,0(s11)
ffffffffc0202880:	4585                	li	a1,1
ffffffffc0202882:	e032                	sd	a2,0(sp)
ffffffffc0202884:	739c                	ld	a5,32(a5)
ffffffffc0202886:	9782                	jalr	a5
ffffffffc0202888:	6602                	ld	a2,0(sp)
ffffffffc020288a:	00094817          	auipc	a6,0x94
ffffffffc020288e:	02e80813          	addi	a6,a6,46 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202892:	fff80e37          	lui	t3,0xfff80
ffffffffc0202896:	00080337          	lui	t1,0x80
ffffffffc020289a:	6885                	lui	a7,0x1
ffffffffc020289c:	00094717          	auipc	a4,0x94
ffffffffc02028a0:	00c70713          	addi	a4,a4,12 # ffffffffc02968a8 <pages>
ffffffffc02028a4:	0004b023          	sd	zero,0(s1)
ffffffffc02028a8:	002007b7          	lui	a5,0x200
ffffffffc02028ac:	993e                	add	s2,s2,a5
ffffffffc02028ae:	f60918e3          	bnez	s2,ffffffffc020281e <exit_range+0xee>
ffffffffc02028b2:	f00b85e3          	beqz	s7,ffffffffc02027bc <exit_range+0x8c>
ffffffffc02028b6:	000d3783          	ld	a5,0(s10)
ffffffffc02028ba:	0efa7263          	bgeu	s4,a5,ffffffffc020299e <exit_range+0x26e>
ffffffffc02028be:	6308                	ld	a0,0(a4)
ffffffffc02028c0:	9532                	add	a0,a0,a2
ffffffffc02028c2:	100027f3          	csrr	a5,sstatus
ffffffffc02028c6:	8b89                	andi	a5,a5,2
ffffffffc02028c8:	efad                	bnez	a5,ffffffffc0202942 <exit_range+0x212>
ffffffffc02028ca:	000db783          	ld	a5,0(s11)
ffffffffc02028ce:	4585                	li	a1,1
ffffffffc02028d0:	739c                	ld	a5,32(a5)
ffffffffc02028d2:	9782                	jalr	a5
ffffffffc02028d4:	00094717          	auipc	a4,0x94
ffffffffc02028d8:	fd470713          	addi	a4,a4,-44 # ffffffffc02968a8 <pages>
ffffffffc02028dc:	00043023          	sd	zero,0(s0)
ffffffffc02028e0:	ee0990e3          	bnez	s3,ffffffffc02027c0 <exit_range+0x90>
ffffffffc02028e4:	70e6                	ld	ra,120(sp)
ffffffffc02028e6:	7446                	ld	s0,112(sp)
ffffffffc02028e8:	74a6                	ld	s1,104(sp)
ffffffffc02028ea:	7906                	ld	s2,96(sp)
ffffffffc02028ec:	69e6                	ld	s3,88(sp)
ffffffffc02028ee:	6a46                	ld	s4,80(sp)
ffffffffc02028f0:	6aa6                	ld	s5,72(sp)
ffffffffc02028f2:	6b06                	ld	s6,64(sp)
ffffffffc02028f4:	7be2                	ld	s7,56(sp)
ffffffffc02028f6:	7c42                	ld	s8,48(sp)
ffffffffc02028f8:	7ca2                	ld	s9,40(sp)
ffffffffc02028fa:	7d02                	ld	s10,32(sp)
ffffffffc02028fc:	6de2                	ld	s11,24(sp)
ffffffffc02028fe:	6109                	addi	sp,sp,128
ffffffffc0202900:	8082                	ret
ffffffffc0202902:	ea0b8fe3          	beqz	s7,ffffffffc02027c0 <exit_range+0x90>
ffffffffc0202906:	bf45                	j	ffffffffc02028b6 <exit_range+0x186>
ffffffffc0202908:	e032                	sd	a2,0(sp)
ffffffffc020290a:	e42a                	sd	a0,8(sp)
ffffffffc020290c:	b66fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202910:	000db783          	ld	a5,0(s11)
ffffffffc0202914:	6522                	ld	a0,8(sp)
ffffffffc0202916:	4585                	li	a1,1
ffffffffc0202918:	739c                	ld	a5,32(a5)
ffffffffc020291a:	9782                	jalr	a5
ffffffffc020291c:	b50fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202920:	6602                	ld	a2,0(sp)
ffffffffc0202922:	00094717          	auipc	a4,0x94
ffffffffc0202926:	f8670713          	addi	a4,a4,-122 # ffffffffc02968a8 <pages>
ffffffffc020292a:	6885                	lui	a7,0x1
ffffffffc020292c:	00080337          	lui	t1,0x80
ffffffffc0202930:	fff80e37          	lui	t3,0xfff80
ffffffffc0202934:	00094817          	auipc	a6,0x94
ffffffffc0202938:	f8480813          	addi	a6,a6,-124 # ffffffffc02968b8 <va_pa_offset>
ffffffffc020293c:	0004b023          	sd	zero,0(s1)
ffffffffc0202940:	b7a5                	j	ffffffffc02028a8 <exit_range+0x178>
ffffffffc0202942:	e02a                	sd	a0,0(sp)
ffffffffc0202944:	b2efe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202948:	000db783          	ld	a5,0(s11)
ffffffffc020294c:	6502                	ld	a0,0(sp)
ffffffffc020294e:	4585                	li	a1,1
ffffffffc0202950:	739c                	ld	a5,32(a5)
ffffffffc0202952:	9782                	jalr	a5
ffffffffc0202954:	b18fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202958:	00094717          	auipc	a4,0x94
ffffffffc020295c:	f5070713          	addi	a4,a4,-176 # ffffffffc02968a8 <pages>
ffffffffc0202960:	00043023          	sd	zero,0(s0)
ffffffffc0202964:	bfb5                	j	ffffffffc02028e0 <exit_range+0x1b0>
ffffffffc0202966:	0000a697          	auipc	a3,0xa
ffffffffc020296a:	ff268693          	addi	a3,a3,-14 # ffffffffc020c958 <default_pmm_manager+0x188>
ffffffffc020296e:	00009617          	auipc	a2,0x9
ffffffffc0202972:	35a60613          	addi	a2,a2,858 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0202976:	16f00593          	li	a1,367
ffffffffc020297a:	0000a517          	auipc	a0,0xa
ffffffffc020297e:	fa650513          	addi	a0,a0,-90 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0202982:	b1dfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202986:	0000a617          	auipc	a2,0xa
ffffffffc020298a:	e8260613          	addi	a2,a2,-382 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc020298e:	07100593          	li	a1,113
ffffffffc0202992:	0000a517          	auipc	a0,0xa
ffffffffc0202996:	e9e50513          	addi	a0,a0,-354 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc020299a:	b05fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020299e:	81bff0ef          	jal	ra,ffffffffc02021b8 <pa2page.part.0>
ffffffffc02029a2:	0000a697          	auipc	a3,0xa
ffffffffc02029a6:	fe668693          	addi	a3,a3,-26 # ffffffffc020c988 <default_pmm_manager+0x1b8>
ffffffffc02029aa:	00009617          	auipc	a2,0x9
ffffffffc02029ae:	31e60613          	addi	a2,a2,798 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02029b2:	17000593          	li	a1,368
ffffffffc02029b6:	0000a517          	auipc	a0,0xa
ffffffffc02029ba:	f6a50513          	addi	a0,a0,-150 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02029be:	ae1fd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02029c2 <copy_range>:
ffffffffc02029c2:	7159                	addi	sp,sp,-112
ffffffffc02029c4:	00d667b3          	or	a5,a2,a3
ffffffffc02029c8:	f486                	sd	ra,104(sp)
ffffffffc02029ca:	f0a2                	sd	s0,96(sp)
ffffffffc02029cc:	eca6                	sd	s1,88(sp)
ffffffffc02029ce:	e8ca                	sd	s2,80(sp)
ffffffffc02029d0:	e4ce                	sd	s3,72(sp)
ffffffffc02029d2:	e0d2                	sd	s4,64(sp)
ffffffffc02029d4:	fc56                	sd	s5,56(sp)
ffffffffc02029d6:	f85a                	sd	s6,48(sp)
ffffffffc02029d8:	f45e                	sd	s7,40(sp)
ffffffffc02029da:	f062                	sd	s8,32(sp)
ffffffffc02029dc:	ec66                	sd	s9,24(sp)
ffffffffc02029de:	e86a                	sd	s10,16(sp)
ffffffffc02029e0:	e46e                	sd	s11,8(sp)
ffffffffc02029e2:	17d2                	slli	a5,a5,0x34
ffffffffc02029e4:	18079263          	bnez	a5,ffffffffc0202b68 <copy_range+0x1a6>
ffffffffc02029e8:	002007b7          	lui	a5,0x200
ffffffffc02029ec:	8432                	mv	s0,a2
ffffffffc02029ee:	12f66163          	bltu	a2,a5,ffffffffc0202b10 <copy_range+0x14e>
ffffffffc02029f2:	84b6                	mv	s1,a3
ffffffffc02029f4:	10d67e63          	bgeu	a2,a3,ffffffffc0202b10 <copy_range+0x14e>
ffffffffc02029f8:	4785                	li	a5,1
ffffffffc02029fa:	07fe                	slli	a5,a5,0x1f
ffffffffc02029fc:	10d7ea63          	bltu	a5,a3,ffffffffc0202b10 <copy_range+0x14e>
ffffffffc0202a00:	8a2a                	mv	s4,a0
ffffffffc0202a02:	892e                	mv	s2,a1
ffffffffc0202a04:	8aba                	mv	s5,a4
ffffffffc0202a06:	6985                	lui	s3,0x1
ffffffffc0202a08:	00094c17          	auipc	s8,0x94
ffffffffc0202a0c:	e98c0c13          	addi	s8,s8,-360 # ffffffffc02968a0 <npage>
ffffffffc0202a10:	fff80bb7          	lui	s7,0xfff80
ffffffffc0202a14:	00094b17          	auipc	s6,0x94
ffffffffc0202a18:	e94b0b13          	addi	s6,s6,-364 # ffffffffc02968a8 <pages>
ffffffffc0202a1c:	00200d37          	lui	s10,0x200
ffffffffc0202a20:	ffe00cb7          	lui	s9,0xffe00
ffffffffc0202a24:	4601                	li	a2,0
ffffffffc0202a26:	85a2                	mv	a1,s0
ffffffffc0202a28:	854a                	mv	a0,s2
ffffffffc0202a2a:	87fff0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc0202a2e:	8daa                	mv	s11,a0
ffffffffc0202a30:	c92d                	beqz	a0,ffffffffc0202aa2 <copy_range+0xe0>
ffffffffc0202a32:	6118                	ld	a4,0(a0)
ffffffffc0202a34:	8b05                	andi	a4,a4,1
ffffffffc0202a36:	e705                	bnez	a4,ffffffffc0202a5e <copy_range+0x9c>
ffffffffc0202a38:	944e                	add	s0,s0,s3
ffffffffc0202a3a:	fe9465e3          	bltu	s0,s1,ffffffffc0202a24 <copy_range+0x62>
ffffffffc0202a3e:	4501                	li	a0,0
ffffffffc0202a40:	70a6                	ld	ra,104(sp)
ffffffffc0202a42:	7406                	ld	s0,96(sp)
ffffffffc0202a44:	64e6                	ld	s1,88(sp)
ffffffffc0202a46:	6946                	ld	s2,80(sp)
ffffffffc0202a48:	69a6                	ld	s3,72(sp)
ffffffffc0202a4a:	6a06                	ld	s4,64(sp)
ffffffffc0202a4c:	7ae2                	ld	s5,56(sp)
ffffffffc0202a4e:	7b42                	ld	s6,48(sp)
ffffffffc0202a50:	7ba2                	ld	s7,40(sp)
ffffffffc0202a52:	7c02                	ld	s8,32(sp)
ffffffffc0202a54:	6ce2                	ld	s9,24(sp)
ffffffffc0202a56:	6d42                	ld	s10,16(sp)
ffffffffc0202a58:	6da2                	ld	s11,8(sp)
ffffffffc0202a5a:	6165                	addi	sp,sp,112
ffffffffc0202a5c:	8082                	ret
ffffffffc0202a5e:	4605                	li	a2,1
ffffffffc0202a60:	85a2                	mv	a1,s0
ffffffffc0202a62:	8552                	mv	a0,s4
ffffffffc0202a64:	845ff0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc0202a68:	c551                	beqz	a0,ffffffffc0202af4 <copy_range+0x132>
ffffffffc0202a6a:	000db683          	ld	a3,0(s11)
ffffffffc0202a6e:	0016f713          	andi	a4,a3,1
ffffffffc0202a72:	c359                	beqz	a4,ffffffffc0202af8 <copy_range+0x136>
ffffffffc0202a74:	000c3603          	ld	a2,0(s8)
ffffffffc0202a78:	00269713          	slli	a4,a3,0x2
ffffffffc0202a7c:	8331                	srli	a4,a4,0xc
ffffffffc0202a7e:	0cc77963          	bgeu	a4,a2,ffffffffc0202b50 <copy_range+0x18e>
ffffffffc0202a82:	000b3603          	ld	a2,0(s6)
ffffffffc0202a86:	975e                	add	a4,a4,s7
ffffffffc0202a88:	071a                	slli	a4,a4,0x6
ffffffffc0202a8a:	963a                	add	a2,a2,a4
ffffffffc0202a8c:	c255                	beqz	a2,ffffffffc0202b30 <copy_range+0x16e>
ffffffffc0202a8e:	420c                	lw	a1,0(a2)
ffffffffc0202a90:	2585                	addiw	a1,a1,1
ffffffffc0202a92:	000a8f63          	beqz	s5,ffffffffc0202ab0 <copy_range+0xee>
ffffffffc0202a96:	c20c                	sw	a1,0(a2)
ffffffffc0202a98:	e114                	sd	a3,0(a0)
ffffffffc0202a9a:	12040073          	sfence.vma	s0
ffffffffc0202a9e:	944e                	add	s0,s0,s3
ffffffffc0202aa0:	bf69                	j	ffffffffc0202a3a <copy_range+0x78>
ffffffffc0202aa2:	946a                	add	s0,s0,s10
ffffffffc0202aa4:	01947433          	and	s0,s0,s9
ffffffffc0202aa8:	d859                	beqz	s0,ffffffffc0202a3e <copy_range+0x7c>
ffffffffc0202aaa:	f6946de3          	bltu	s0,s1,ffffffffc0202a24 <copy_range+0x62>
ffffffffc0202aae:	bf41                	j	ffffffffc0202a3e <copy_range+0x7c>
ffffffffc0202ab0:	8719                	srai	a4,a4,0x6
ffffffffc0202ab2:	000807b7          	lui	a5,0x80
ffffffffc0202ab6:	973e                	add	a4,a4,a5
ffffffffc0202ab8:	0046f813          	andi	a6,a3,4
ffffffffc0202abc:	072a                	slli	a4,a4,0xa
ffffffffc0202abe:	2681                	sext.w	a3,a3
ffffffffc0202ac0:	02080063          	beqz	a6,ffffffffc0202ae0 <copy_range+0x11e>
ffffffffc0202ac4:	8ae9                	andi	a3,a3,26
ffffffffc0202ac6:	8f55                	or	a4,a4,a3
ffffffffc0202ac8:	c20c                	sw	a1,0(a2)
ffffffffc0202aca:	20176713          	ori	a4,a4,513
ffffffffc0202ace:	e118                	sd	a4,0(a0)
ffffffffc0202ad0:	12040073          	sfence.vma	s0
ffffffffc0202ad4:	00edb023          	sd	a4,0(s11)
ffffffffc0202ad8:	12040073          	sfence.vma	s0
ffffffffc0202adc:	944e                	add	s0,s0,s3
ffffffffc0202ade:	bfb1                	j	ffffffffc0202a3a <copy_range+0x78>
ffffffffc0202ae0:	8af9                	andi	a3,a3,30
ffffffffc0202ae2:	8f55                	or	a4,a4,a3
ffffffffc0202ae4:	c20c                	sw	a1,0(a2)
ffffffffc0202ae6:	00176713          	ori	a4,a4,1
ffffffffc0202aea:	e118                	sd	a4,0(a0)
ffffffffc0202aec:	12040073          	sfence.vma	s0
ffffffffc0202af0:	944e                	add	s0,s0,s3
ffffffffc0202af2:	b7a1                	j	ffffffffc0202a3a <copy_range+0x78>
ffffffffc0202af4:	5571                	li	a0,-4
ffffffffc0202af6:	b7a9                	j	ffffffffc0202a40 <copy_range+0x7e>
ffffffffc0202af8:	0000a617          	auipc	a2,0xa
ffffffffc0202afc:	e0060613          	addi	a2,a2,-512 # ffffffffc020c8f8 <default_pmm_manager+0x128>
ffffffffc0202b00:	07f00593          	li	a1,127
ffffffffc0202b04:	0000a517          	auipc	a0,0xa
ffffffffc0202b08:	d2c50513          	addi	a0,a0,-724 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0202b0c:	993fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202b10:	0000a697          	auipc	a3,0xa
ffffffffc0202b14:	e7868693          	addi	a3,a3,-392 # ffffffffc020c988 <default_pmm_manager+0x1b8>
ffffffffc0202b18:	00009617          	auipc	a2,0x9
ffffffffc0202b1c:	1b060613          	addi	a2,a2,432 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0202b20:	1b600593          	li	a1,438
ffffffffc0202b24:	0000a517          	auipc	a0,0xa
ffffffffc0202b28:	dfc50513          	addi	a0,a0,-516 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0202b2c:	973fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202b30:	0000a697          	auipc	a3,0xa
ffffffffc0202b34:	e7068693          	addi	a3,a3,-400 # ffffffffc020c9a0 <default_pmm_manager+0x1d0>
ffffffffc0202b38:	00009617          	auipc	a2,0x9
ffffffffc0202b3c:	19060613          	addi	a2,a2,400 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0202b40:	1ce00593          	li	a1,462
ffffffffc0202b44:	0000a517          	auipc	a0,0xa
ffffffffc0202b48:	ddc50513          	addi	a0,a0,-548 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0202b4c:	953fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202b50:	0000a617          	auipc	a2,0xa
ffffffffc0202b54:	d8860613          	addi	a2,a2,-632 # ffffffffc020c8d8 <default_pmm_manager+0x108>
ffffffffc0202b58:	06900593          	li	a1,105
ffffffffc0202b5c:	0000a517          	auipc	a0,0xa
ffffffffc0202b60:	cd450513          	addi	a0,a0,-812 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0202b64:	93bfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202b68:	0000a697          	auipc	a3,0xa
ffffffffc0202b6c:	df068693          	addi	a3,a3,-528 # ffffffffc020c958 <default_pmm_manager+0x188>
ffffffffc0202b70:	00009617          	auipc	a2,0x9
ffffffffc0202b74:	15860613          	addi	a2,a2,344 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0202b78:	1b500593          	li	a1,437
ffffffffc0202b7c:	0000a517          	auipc	a0,0xa
ffffffffc0202b80:	da450513          	addi	a0,a0,-604 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0202b84:	91bfd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0202b88 <page_remove>:
ffffffffc0202b88:	7179                	addi	sp,sp,-48
ffffffffc0202b8a:	4601                	li	a2,0
ffffffffc0202b8c:	ec26                	sd	s1,24(sp)
ffffffffc0202b8e:	f406                	sd	ra,40(sp)
ffffffffc0202b90:	f022                	sd	s0,32(sp)
ffffffffc0202b92:	84ae                	mv	s1,a1
ffffffffc0202b94:	f14ff0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc0202b98:	c511                	beqz	a0,ffffffffc0202ba4 <page_remove+0x1c>
ffffffffc0202b9a:	611c                	ld	a5,0(a0)
ffffffffc0202b9c:	842a                	mv	s0,a0
ffffffffc0202b9e:	0017f713          	andi	a4,a5,1
ffffffffc0202ba2:	e711                	bnez	a4,ffffffffc0202bae <page_remove+0x26>
ffffffffc0202ba4:	70a2                	ld	ra,40(sp)
ffffffffc0202ba6:	7402                	ld	s0,32(sp)
ffffffffc0202ba8:	64e2                	ld	s1,24(sp)
ffffffffc0202baa:	6145                	addi	sp,sp,48
ffffffffc0202bac:	8082                	ret
ffffffffc0202bae:	078a                	slli	a5,a5,0x2
ffffffffc0202bb0:	83b1                	srli	a5,a5,0xc
ffffffffc0202bb2:	00094717          	auipc	a4,0x94
ffffffffc0202bb6:	cee73703          	ld	a4,-786(a4) # ffffffffc02968a0 <npage>
ffffffffc0202bba:	06e7f363          	bgeu	a5,a4,ffffffffc0202c20 <page_remove+0x98>
ffffffffc0202bbe:	fff80537          	lui	a0,0xfff80
ffffffffc0202bc2:	97aa                	add	a5,a5,a0
ffffffffc0202bc4:	079a                	slli	a5,a5,0x6
ffffffffc0202bc6:	00094517          	auipc	a0,0x94
ffffffffc0202bca:	ce253503          	ld	a0,-798(a0) # ffffffffc02968a8 <pages>
ffffffffc0202bce:	953e                	add	a0,a0,a5
ffffffffc0202bd0:	411c                	lw	a5,0(a0)
ffffffffc0202bd2:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202bd6:	c118                	sw	a4,0(a0)
ffffffffc0202bd8:	cb11                	beqz	a4,ffffffffc0202bec <page_remove+0x64>
ffffffffc0202bda:	00043023          	sd	zero,0(s0)
ffffffffc0202bde:	12048073          	sfence.vma	s1
ffffffffc0202be2:	70a2                	ld	ra,40(sp)
ffffffffc0202be4:	7402                	ld	s0,32(sp)
ffffffffc0202be6:	64e2                	ld	s1,24(sp)
ffffffffc0202be8:	6145                	addi	sp,sp,48
ffffffffc0202bea:	8082                	ret
ffffffffc0202bec:	100027f3          	csrr	a5,sstatus
ffffffffc0202bf0:	8b89                	andi	a5,a5,2
ffffffffc0202bf2:	eb89                	bnez	a5,ffffffffc0202c04 <page_remove+0x7c>
ffffffffc0202bf4:	00094797          	auipc	a5,0x94
ffffffffc0202bf8:	cbc7b783          	ld	a5,-836(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202bfc:	739c                	ld	a5,32(a5)
ffffffffc0202bfe:	4585                	li	a1,1
ffffffffc0202c00:	9782                	jalr	a5
ffffffffc0202c02:	bfe1                	j	ffffffffc0202bda <page_remove+0x52>
ffffffffc0202c04:	e42a                	sd	a0,8(sp)
ffffffffc0202c06:	86cfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202c0a:	00094797          	auipc	a5,0x94
ffffffffc0202c0e:	ca67b783          	ld	a5,-858(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202c12:	739c                	ld	a5,32(a5)
ffffffffc0202c14:	6522                	ld	a0,8(sp)
ffffffffc0202c16:	4585                	li	a1,1
ffffffffc0202c18:	9782                	jalr	a5
ffffffffc0202c1a:	852fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202c1e:	bf75                	j	ffffffffc0202bda <page_remove+0x52>
ffffffffc0202c20:	d98ff0ef          	jal	ra,ffffffffc02021b8 <pa2page.part.0>

ffffffffc0202c24 <page_insert>:
ffffffffc0202c24:	7139                	addi	sp,sp,-64
ffffffffc0202c26:	e852                	sd	s4,16(sp)
ffffffffc0202c28:	8a32                	mv	s4,a2
ffffffffc0202c2a:	f822                	sd	s0,48(sp)
ffffffffc0202c2c:	4605                	li	a2,1
ffffffffc0202c2e:	842e                	mv	s0,a1
ffffffffc0202c30:	85d2                	mv	a1,s4
ffffffffc0202c32:	f426                	sd	s1,40(sp)
ffffffffc0202c34:	fc06                	sd	ra,56(sp)
ffffffffc0202c36:	f04a                	sd	s2,32(sp)
ffffffffc0202c38:	ec4e                	sd	s3,24(sp)
ffffffffc0202c3a:	e456                	sd	s5,8(sp)
ffffffffc0202c3c:	84b6                	mv	s1,a3
ffffffffc0202c3e:	e6aff0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc0202c42:	c961                	beqz	a0,ffffffffc0202d12 <page_insert+0xee>
ffffffffc0202c44:	4014                	lw	a3,0(s0)
ffffffffc0202c46:	611c                	ld	a5,0(a0)
ffffffffc0202c48:	89aa                	mv	s3,a0
ffffffffc0202c4a:	0016871b          	addiw	a4,a3,1
ffffffffc0202c4e:	c018                	sw	a4,0(s0)
ffffffffc0202c50:	0017f713          	andi	a4,a5,1
ffffffffc0202c54:	ef05                	bnez	a4,ffffffffc0202c8c <page_insert+0x68>
ffffffffc0202c56:	00094717          	auipc	a4,0x94
ffffffffc0202c5a:	c5273703          	ld	a4,-942(a4) # ffffffffc02968a8 <pages>
ffffffffc0202c5e:	8c19                	sub	s0,s0,a4
ffffffffc0202c60:	000807b7          	lui	a5,0x80
ffffffffc0202c64:	8419                	srai	s0,s0,0x6
ffffffffc0202c66:	943e                	add	s0,s0,a5
ffffffffc0202c68:	042a                	slli	s0,s0,0xa
ffffffffc0202c6a:	8cc1                	or	s1,s1,s0
ffffffffc0202c6c:	0014e493          	ori	s1,s1,1
ffffffffc0202c70:	0099b023          	sd	s1,0(s3) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0202c74:	120a0073          	sfence.vma	s4
ffffffffc0202c78:	4501                	li	a0,0
ffffffffc0202c7a:	70e2                	ld	ra,56(sp)
ffffffffc0202c7c:	7442                	ld	s0,48(sp)
ffffffffc0202c7e:	74a2                	ld	s1,40(sp)
ffffffffc0202c80:	7902                	ld	s2,32(sp)
ffffffffc0202c82:	69e2                	ld	s3,24(sp)
ffffffffc0202c84:	6a42                	ld	s4,16(sp)
ffffffffc0202c86:	6aa2                	ld	s5,8(sp)
ffffffffc0202c88:	6121                	addi	sp,sp,64
ffffffffc0202c8a:	8082                	ret
ffffffffc0202c8c:	078a                	slli	a5,a5,0x2
ffffffffc0202c8e:	83b1                	srli	a5,a5,0xc
ffffffffc0202c90:	00094717          	auipc	a4,0x94
ffffffffc0202c94:	c1073703          	ld	a4,-1008(a4) # ffffffffc02968a0 <npage>
ffffffffc0202c98:	06e7ff63          	bgeu	a5,a4,ffffffffc0202d16 <page_insert+0xf2>
ffffffffc0202c9c:	00094a97          	auipc	s5,0x94
ffffffffc0202ca0:	c0ca8a93          	addi	s5,s5,-1012 # ffffffffc02968a8 <pages>
ffffffffc0202ca4:	000ab703          	ld	a4,0(s5)
ffffffffc0202ca8:	fff80937          	lui	s2,0xfff80
ffffffffc0202cac:	993e                	add	s2,s2,a5
ffffffffc0202cae:	091a                	slli	s2,s2,0x6
ffffffffc0202cb0:	993a                	add	s2,s2,a4
ffffffffc0202cb2:	01240c63          	beq	s0,s2,ffffffffc0202cca <page_insert+0xa6>
ffffffffc0202cb6:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fce96e0>
ffffffffc0202cba:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202cbe:	00d92023          	sw	a3,0(s2)
ffffffffc0202cc2:	c691                	beqz	a3,ffffffffc0202cce <page_insert+0xaa>
ffffffffc0202cc4:	120a0073          	sfence.vma	s4
ffffffffc0202cc8:	bf59                	j	ffffffffc0202c5e <page_insert+0x3a>
ffffffffc0202cca:	c014                	sw	a3,0(s0)
ffffffffc0202ccc:	bf49                	j	ffffffffc0202c5e <page_insert+0x3a>
ffffffffc0202cce:	100027f3          	csrr	a5,sstatus
ffffffffc0202cd2:	8b89                	andi	a5,a5,2
ffffffffc0202cd4:	ef91                	bnez	a5,ffffffffc0202cf0 <page_insert+0xcc>
ffffffffc0202cd6:	00094797          	auipc	a5,0x94
ffffffffc0202cda:	bda7b783          	ld	a5,-1062(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202cde:	739c                	ld	a5,32(a5)
ffffffffc0202ce0:	4585                	li	a1,1
ffffffffc0202ce2:	854a                	mv	a0,s2
ffffffffc0202ce4:	9782                	jalr	a5
ffffffffc0202ce6:	000ab703          	ld	a4,0(s5)
ffffffffc0202cea:	120a0073          	sfence.vma	s4
ffffffffc0202cee:	bf85                	j	ffffffffc0202c5e <page_insert+0x3a>
ffffffffc0202cf0:	f83fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202cf4:	00094797          	auipc	a5,0x94
ffffffffc0202cf8:	bbc7b783          	ld	a5,-1092(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202cfc:	739c                	ld	a5,32(a5)
ffffffffc0202cfe:	4585                	li	a1,1
ffffffffc0202d00:	854a                	mv	a0,s2
ffffffffc0202d02:	9782                	jalr	a5
ffffffffc0202d04:	f69fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202d08:	000ab703          	ld	a4,0(s5)
ffffffffc0202d0c:	120a0073          	sfence.vma	s4
ffffffffc0202d10:	b7b9                	j	ffffffffc0202c5e <page_insert+0x3a>
ffffffffc0202d12:	5571                	li	a0,-4
ffffffffc0202d14:	b79d                	j	ffffffffc0202c7a <page_insert+0x56>
ffffffffc0202d16:	ca2ff0ef          	jal	ra,ffffffffc02021b8 <pa2page.part.0>

ffffffffc0202d1a <pmm_init>:
ffffffffc0202d1a:	0000a797          	auipc	a5,0xa
ffffffffc0202d1e:	ab678793          	addi	a5,a5,-1354 # ffffffffc020c7d0 <default_pmm_manager>
ffffffffc0202d22:	638c                	ld	a1,0(a5)
ffffffffc0202d24:	7159                	addi	sp,sp,-112
ffffffffc0202d26:	f85a                	sd	s6,48(sp)
ffffffffc0202d28:	0000a517          	auipc	a0,0xa
ffffffffc0202d2c:	c8850513          	addi	a0,a0,-888 # ffffffffc020c9b0 <default_pmm_manager+0x1e0>
ffffffffc0202d30:	00094b17          	auipc	s6,0x94
ffffffffc0202d34:	b80b0b13          	addi	s6,s6,-1152 # ffffffffc02968b0 <pmm_manager>
ffffffffc0202d38:	f486                	sd	ra,104(sp)
ffffffffc0202d3a:	e8ca                	sd	s2,80(sp)
ffffffffc0202d3c:	e4ce                	sd	s3,72(sp)
ffffffffc0202d3e:	f0a2                	sd	s0,96(sp)
ffffffffc0202d40:	eca6                	sd	s1,88(sp)
ffffffffc0202d42:	e0d2                	sd	s4,64(sp)
ffffffffc0202d44:	fc56                	sd	s5,56(sp)
ffffffffc0202d46:	f45e                	sd	s7,40(sp)
ffffffffc0202d48:	f062                	sd	s8,32(sp)
ffffffffc0202d4a:	ec66                	sd	s9,24(sp)
ffffffffc0202d4c:	00fb3023          	sd	a5,0(s6)
ffffffffc0202d50:	c56fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202d54:	000b3783          	ld	a5,0(s6)
ffffffffc0202d58:	00094997          	auipc	s3,0x94
ffffffffc0202d5c:	b6098993          	addi	s3,s3,-1184 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202d60:	679c                	ld	a5,8(a5)
ffffffffc0202d62:	9782                	jalr	a5
ffffffffc0202d64:	57f5                	li	a5,-3
ffffffffc0202d66:	07fa                	slli	a5,a5,0x1e
ffffffffc0202d68:	00f9b023          	sd	a5,0(s3)
ffffffffc0202d6c:	cddfd0ef          	jal	ra,ffffffffc0200a48 <get_memory_base>
ffffffffc0202d70:	892a                	mv	s2,a0
ffffffffc0202d72:	ce1fd0ef          	jal	ra,ffffffffc0200a52 <get_memory_size>
ffffffffc0202d76:	280502e3          	beqz	a0,ffffffffc02037fa <pmm_init+0xae0>
ffffffffc0202d7a:	84aa                	mv	s1,a0
ffffffffc0202d7c:	0000a517          	auipc	a0,0xa
ffffffffc0202d80:	c6c50513          	addi	a0,a0,-916 # ffffffffc020c9e8 <default_pmm_manager+0x218>
ffffffffc0202d84:	c22fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202d88:	00990433          	add	s0,s2,s1
ffffffffc0202d8c:	fff40693          	addi	a3,s0,-1
ffffffffc0202d90:	864a                	mv	a2,s2
ffffffffc0202d92:	85a6                	mv	a1,s1
ffffffffc0202d94:	0000a517          	auipc	a0,0xa
ffffffffc0202d98:	c6c50513          	addi	a0,a0,-916 # ffffffffc020ca00 <default_pmm_manager+0x230>
ffffffffc0202d9c:	c0afd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202da0:	c8000737          	lui	a4,0xc8000
ffffffffc0202da4:	87a2                	mv	a5,s0
ffffffffc0202da6:	5e876e63          	bltu	a4,s0,ffffffffc02033a2 <pmm_init+0x688>
ffffffffc0202daa:	757d                	lui	a0,0xfffff
ffffffffc0202dac:	00095617          	auipc	a2,0x95
ffffffffc0202db0:	b7360613          	addi	a2,a2,-1165 # ffffffffc029791f <end+0xfff>
ffffffffc0202db4:	8e69                	and	a2,a2,a0
ffffffffc0202db6:	00094497          	auipc	s1,0x94
ffffffffc0202dba:	aea48493          	addi	s1,s1,-1302 # ffffffffc02968a0 <npage>
ffffffffc0202dbe:	00c7d513          	srli	a0,a5,0xc
ffffffffc0202dc2:	00094b97          	auipc	s7,0x94
ffffffffc0202dc6:	ae6b8b93          	addi	s7,s7,-1306 # ffffffffc02968a8 <pages>
ffffffffc0202dca:	e088                	sd	a0,0(s1)
ffffffffc0202dcc:	00cbb023          	sd	a2,0(s7)
ffffffffc0202dd0:	000807b7          	lui	a5,0x80
ffffffffc0202dd4:	86b2                	mv	a3,a2
ffffffffc0202dd6:	02f50863          	beq	a0,a5,ffffffffc0202e06 <pmm_init+0xec>
ffffffffc0202dda:	4781                	li	a5,0
ffffffffc0202ddc:	4585                	li	a1,1
ffffffffc0202dde:	fff806b7          	lui	a3,0xfff80
ffffffffc0202de2:	00679513          	slli	a0,a5,0x6
ffffffffc0202de6:	9532                	add	a0,a0,a2
ffffffffc0202de8:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd686e8>
ffffffffc0202dec:	40b7302f          	amoor.d	zero,a1,(a4)
ffffffffc0202df0:	6088                	ld	a0,0(s1)
ffffffffc0202df2:	0785                	addi	a5,a5,1
ffffffffc0202df4:	000bb603          	ld	a2,0(s7)
ffffffffc0202df8:	00d50733          	add	a4,a0,a3
ffffffffc0202dfc:	fee7e3e3          	bltu	a5,a4,ffffffffc0202de2 <pmm_init+0xc8>
ffffffffc0202e00:	071a                	slli	a4,a4,0x6
ffffffffc0202e02:	00e606b3          	add	a3,a2,a4
ffffffffc0202e06:	c02007b7          	lui	a5,0xc0200
ffffffffc0202e0a:	3af6eae3          	bltu	a3,a5,ffffffffc02039be <pmm_init+0xca4>
ffffffffc0202e0e:	0009b583          	ld	a1,0(s3)
ffffffffc0202e12:	77fd                	lui	a5,0xfffff
ffffffffc0202e14:	8c7d                	and	s0,s0,a5
ffffffffc0202e16:	8e8d                	sub	a3,a3,a1
ffffffffc0202e18:	5e86e363          	bltu	a3,s0,ffffffffc02033fe <pmm_init+0x6e4>
ffffffffc0202e1c:	0000a517          	auipc	a0,0xa
ffffffffc0202e20:	c0c50513          	addi	a0,a0,-1012 # ffffffffc020ca28 <default_pmm_manager+0x258>
ffffffffc0202e24:	b82fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202e28:	000b3783          	ld	a5,0(s6)
ffffffffc0202e2c:	7b9c                	ld	a5,48(a5)
ffffffffc0202e2e:	9782                	jalr	a5
ffffffffc0202e30:	0000a517          	auipc	a0,0xa
ffffffffc0202e34:	c1050513          	addi	a0,a0,-1008 # ffffffffc020ca40 <default_pmm_manager+0x270>
ffffffffc0202e38:	b6efd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202e3c:	100027f3          	csrr	a5,sstatus
ffffffffc0202e40:	8b89                	andi	a5,a5,2
ffffffffc0202e42:	5a079363          	bnez	a5,ffffffffc02033e8 <pmm_init+0x6ce>
ffffffffc0202e46:	000b3783          	ld	a5,0(s6)
ffffffffc0202e4a:	4505                	li	a0,1
ffffffffc0202e4c:	6f9c                	ld	a5,24(a5)
ffffffffc0202e4e:	9782                	jalr	a5
ffffffffc0202e50:	842a                	mv	s0,a0
ffffffffc0202e52:	180408e3          	beqz	s0,ffffffffc02037e2 <pmm_init+0xac8>
ffffffffc0202e56:	000bb683          	ld	a3,0(s7)
ffffffffc0202e5a:	5a7d                	li	s4,-1
ffffffffc0202e5c:	6098                	ld	a4,0(s1)
ffffffffc0202e5e:	40d406b3          	sub	a3,s0,a3
ffffffffc0202e62:	8699                	srai	a3,a3,0x6
ffffffffc0202e64:	00080437          	lui	s0,0x80
ffffffffc0202e68:	96a2                	add	a3,a3,s0
ffffffffc0202e6a:	00ca5793          	srli	a5,s4,0xc
ffffffffc0202e6e:	8ff5                	and	a5,a5,a3
ffffffffc0202e70:	06b2                	slli	a3,a3,0xc
ffffffffc0202e72:	30e7fde3          	bgeu	a5,a4,ffffffffc020398c <pmm_init+0xc72>
ffffffffc0202e76:	0009b403          	ld	s0,0(s3)
ffffffffc0202e7a:	6605                	lui	a2,0x1
ffffffffc0202e7c:	4581                	li	a1,0
ffffffffc0202e7e:	9436                	add	s0,s0,a3
ffffffffc0202e80:	8522                	mv	a0,s0
ffffffffc0202e82:	165080ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0202e86:	0009b683          	ld	a3,0(s3)
ffffffffc0202e8a:	77fd                	lui	a5,0xfffff
ffffffffc0202e8c:	0000a917          	auipc	s2,0xa
ffffffffc0202e90:	9c390913          	addi	s2,s2,-1597 # ffffffffc020c84f <default_pmm_manager+0x7f>
ffffffffc0202e94:	00f97933          	and	s2,s2,a5
ffffffffc0202e98:	c0200ab7          	lui	s5,0xc0200
ffffffffc0202e9c:	3fe00637          	lui	a2,0x3fe00
ffffffffc0202ea0:	964a                	add	a2,a2,s2
ffffffffc0202ea2:	4729                	li	a4,10
ffffffffc0202ea4:	40da86b3          	sub	a3,s5,a3
ffffffffc0202ea8:	c02005b7          	lui	a1,0xc0200
ffffffffc0202eac:	8522                	mv	a0,s0
ffffffffc0202eae:	e22ff0ef          	jal	ra,ffffffffc02024d0 <boot_map_segment>
ffffffffc0202eb2:	c8000637          	lui	a2,0xc8000
ffffffffc0202eb6:	41260633          	sub	a2,a2,s2
ffffffffc0202eba:	3f596ce3          	bltu	s2,s5,ffffffffc0203ab2 <pmm_init+0xd98>
ffffffffc0202ebe:	0009b683          	ld	a3,0(s3)
ffffffffc0202ec2:	85ca                	mv	a1,s2
ffffffffc0202ec4:	4719                	li	a4,6
ffffffffc0202ec6:	40d906b3          	sub	a3,s2,a3
ffffffffc0202eca:	8522                	mv	a0,s0
ffffffffc0202ecc:	00094917          	auipc	s2,0x94
ffffffffc0202ed0:	9cc90913          	addi	s2,s2,-1588 # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0202ed4:	dfcff0ef          	jal	ra,ffffffffc02024d0 <boot_map_segment>
ffffffffc0202ed8:	00893023          	sd	s0,0(s2)
ffffffffc0202edc:	2d5464e3          	bltu	s0,s5,ffffffffc02039a4 <pmm_init+0xc8a>
ffffffffc0202ee0:	0009b783          	ld	a5,0(s3)
ffffffffc0202ee4:	1a7e                	slli	s4,s4,0x3f
ffffffffc0202ee6:	8c1d                	sub	s0,s0,a5
ffffffffc0202ee8:	00c45793          	srli	a5,s0,0xc
ffffffffc0202eec:	00094717          	auipc	a4,0x94
ffffffffc0202ef0:	9a873223          	sd	s0,-1628(a4) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0202ef4:	0147ea33          	or	s4,a5,s4
ffffffffc0202ef8:	180a1073          	csrw	satp,s4
ffffffffc0202efc:	12000073          	sfence.vma
ffffffffc0202f00:	0000a517          	auipc	a0,0xa
ffffffffc0202f04:	b8050513          	addi	a0,a0,-1152 # ffffffffc020ca80 <default_pmm_manager+0x2b0>
ffffffffc0202f08:	a9efd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202f0c:	0000e717          	auipc	a4,0xe
ffffffffc0202f10:	0f470713          	addi	a4,a4,244 # ffffffffc0211000 <bootstack>
ffffffffc0202f14:	0000e797          	auipc	a5,0xe
ffffffffc0202f18:	0ec78793          	addi	a5,a5,236 # ffffffffc0211000 <bootstack>
ffffffffc0202f1c:	5cf70d63          	beq	a4,a5,ffffffffc02034f6 <pmm_init+0x7dc>
ffffffffc0202f20:	100027f3          	csrr	a5,sstatus
ffffffffc0202f24:	8b89                	andi	a5,a5,2
ffffffffc0202f26:	4a079763          	bnez	a5,ffffffffc02033d4 <pmm_init+0x6ba>
ffffffffc0202f2a:	000b3783          	ld	a5,0(s6)
ffffffffc0202f2e:	779c                	ld	a5,40(a5)
ffffffffc0202f30:	9782                	jalr	a5
ffffffffc0202f32:	842a                	mv	s0,a0
ffffffffc0202f34:	6098                	ld	a4,0(s1)
ffffffffc0202f36:	c80007b7          	lui	a5,0xc8000
ffffffffc0202f3a:	83b1                	srli	a5,a5,0xc
ffffffffc0202f3c:	08e7e3e3          	bltu	a5,a4,ffffffffc02037c2 <pmm_init+0xaa8>
ffffffffc0202f40:	00093503          	ld	a0,0(s2)
ffffffffc0202f44:	04050fe3          	beqz	a0,ffffffffc02037a2 <pmm_init+0xa88>
ffffffffc0202f48:	03451793          	slli	a5,a0,0x34
ffffffffc0202f4c:	04079be3          	bnez	a5,ffffffffc02037a2 <pmm_init+0xa88>
ffffffffc0202f50:	4601                	li	a2,0
ffffffffc0202f52:	4581                	li	a1,0
ffffffffc0202f54:	e42ff0ef          	jal	ra,ffffffffc0202596 <get_page>
ffffffffc0202f58:	2e0511e3          	bnez	a0,ffffffffc0203a3a <pmm_init+0xd20>
ffffffffc0202f5c:	100027f3          	csrr	a5,sstatus
ffffffffc0202f60:	8b89                	andi	a5,a5,2
ffffffffc0202f62:	44079e63          	bnez	a5,ffffffffc02033be <pmm_init+0x6a4>
ffffffffc0202f66:	000b3783          	ld	a5,0(s6)
ffffffffc0202f6a:	4505                	li	a0,1
ffffffffc0202f6c:	6f9c                	ld	a5,24(a5)
ffffffffc0202f6e:	9782                	jalr	a5
ffffffffc0202f70:	8a2a                	mv	s4,a0
ffffffffc0202f72:	00093503          	ld	a0,0(s2)
ffffffffc0202f76:	4681                	li	a3,0
ffffffffc0202f78:	4601                	li	a2,0
ffffffffc0202f7a:	85d2                	mv	a1,s4
ffffffffc0202f7c:	ca9ff0ef          	jal	ra,ffffffffc0202c24 <page_insert>
ffffffffc0202f80:	26051be3          	bnez	a0,ffffffffc02039f6 <pmm_init+0xcdc>
ffffffffc0202f84:	00093503          	ld	a0,0(s2)
ffffffffc0202f88:	4601                	li	a2,0
ffffffffc0202f8a:	4581                	li	a1,0
ffffffffc0202f8c:	b1cff0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc0202f90:	280505e3          	beqz	a0,ffffffffc0203a1a <pmm_init+0xd00>
ffffffffc0202f94:	611c                	ld	a5,0(a0)
ffffffffc0202f96:	0017f713          	andi	a4,a5,1
ffffffffc0202f9a:	26070ee3          	beqz	a4,ffffffffc0203a16 <pmm_init+0xcfc>
ffffffffc0202f9e:	6098                	ld	a4,0(s1)
ffffffffc0202fa0:	078a                	slli	a5,a5,0x2
ffffffffc0202fa2:	83b1                	srli	a5,a5,0xc
ffffffffc0202fa4:	62e7f363          	bgeu	a5,a4,ffffffffc02035ca <pmm_init+0x8b0>
ffffffffc0202fa8:	000bb683          	ld	a3,0(s7)
ffffffffc0202fac:	fff80637          	lui	a2,0xfff80
ffffffffc0202fb0:	97b2                	add	a5,a5,a2
ffffffffc0202fb2:	079a                	slli	a5,a5,0x6
ffffffffc0202fb4:	97b6                	add	a5,a5,a3
ffffffffc0202fb6:	2afa12e3          	bne	s4,a5,ffffffffc0203a5a <pmm_init+0xd40>
ffffffffc0202fba:	000a2683          	lw	a3,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0202fbe:	4785                	li	a5,1
ffffffffc0202fc0:	2cf699e3          	bne	a3,a5,ffffffffc0203a92 <pmm_init+0xd78>
ffffffffc0202fc4:	00093503          	ld	a0,0(s2)
ffffffffc0202fc8:	77fd                	lui	a5,0xfffff
ffffffffc0202fca:	6114                	ld	a3,0(a0)
ffffffffc0202fcc:	068a                	slli	a3,a3,0x2
ffffffffc0202fce:	8efd                	and	a3,a3,a5
ffffffffc0202fd0:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202fd4:	2ae673e3          	bgeu	a2,a4,ffffffffc0203a7a <pmm_init+0xd60>
ffffffffc0202fd8:	0009bc03          	ld	s8,0(s3)
ffffffffc0202fdc:	96e2                	add	a3,a3,s8
ffffffffc0202fde:	0006ba83          	ld	s5,0(a3) # fffffffffff80000 <end+0x3fce96e0>
ffffffffc0202fe2:	0a8a                	slli	s5,s5,0x2
ffffffffc0202fe4:	00fafab3          	and	s5,s5,a5
ffffffffc0202fe8:	00cad793          	srli	a5,s5,0xc
ffffffffc0202fec:	06e7f3e3          	bgeu	a5,a4,ffffffffc0203852 <pmm_init+0xb38>
ffffffffc0202ff0:	4601                	li	a2,0
ffffffffc0202ff2:	6585                	lui	a1,0x1
ffffffffc0202ff4:	9ae2                	add	s5,s5,s8
ffffffffc0202ff6:	ab2ff0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc0202ffa:	0aa1                	addi	s5,s5,8
ffffffffc0202ffc:	03551be3          	bne	a0,s5,ffffffffc0203832 <pmm_init+0xb18>
ffffffffc0203000:	100027f3          	csrr	a5,sstatus
ffffffffc0203004:	8b89                	andi	a5,a5,2
ffffffffc0203006:	3a079163          	bnez	a5,ffffffffc02033a8 <pmm_init+0x68e>
ffffffffc020300a:	000b3783          	ld	a5,0(s6)
ffffffffc020300e:	4505                	li	a0,1
ffffffffc0203010:	6f9c                	ld	a5,24(a5)
ffffffffc0203012:	9782                	jalr	a5
ffffffffc0203014:	8c2a                	mv	s8,a0
ffffffffc0203016:	00093503          	ld	a0,0(s2)
ffffffffc020301a:	46d1                	li	a3,20
ffffffffc020301c:	6605                	lui	a2,0x1
ffffffffc020301e:	85e2                	mv	a1,s8
ffffffffc0203020:	c05ff0ef          	jal	ra,ffffffffc0202c24 <page_insert>
ffffffffc0203024:	1a0519e3          	bnez	a0,ffffffffc02039d6 <pmm_init+0xcbc>
ffffffffc0203028:	00093503          	ld	a0,0(s2)
ffffffffc020302c:	4601                	li	a2,0
ffffffffc020302e:	6585                	lui	a1,0x1
ffffffffc0203030:	a78ff0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc0203034:	10050ce3          	beqz	a0,ffffffffc020394c <pmm_init+0xc32>
ffffffffc0203038:	611c                	ld	a5,0(a0)
ffffffffc020303a:	0107f713          	andi	a4,a5,16
ffffffffc020303e:	0e0707e3          	beqz	a4,ffffffffc020392c <pmm_init+0xc12>
ffffffffc0203042:	8b91                	andi	a5,a5,4
ffffffffc0203044:	0c0784e3          	beqz	a5,ffffffffc020390c <pmm_init+0xbf2>
ffffffffc0203048:	00093503          	ld	a0,0(s2)
ffffffffc020304c:	611c                	ld	a5,0(a0)
ffffffffc020304e:	8bc1                	andi	a5,a5,16
ffffffffc0203050:	08078ee3          	beqz	a5,ffffffffc02038ec <pmm_init+0xbd2>
ffffffffc0203054:	000c2703          	lw	a4,0(s8)
ffffffffc0203058:	4785                	li	a5,1
ffffffffc020305a:	06f719e3          	bne	a4,a5,ffffffffc02038cc <pmm_init+0xbb2>
ffffffffc020305e:	4681                	li	a3,0
ffffffffc0203060:	6605                	lui	a2,0x1
ffffffffc0203062:	85d2                	mv	a1,s4
ffffffffc0203064:	bc1ff0ef          	jal	ra,ffffffffc0202c24 <page_insert>
ffffffffc0203068:	040512e3          	bnez	a0,ffffffffc02038ac <pmm_init+0xb92>
ffffffffc020306c:	000a2703          	lw	a4,0(s4)
ffffffffc0203070:	4789                	li	a5,2
ffffffffc0203072:	00f71de3          	bne	a4,a5,ffffffffc020388c <pmm_init+0xb72>
ffffffffc0203076:	000c2783          	lw	a5,0(s8)
ffffffffc020307a:	7e079963          	bnez	a5,ffffffffc020386c <pmm_init+0xb52>
ffffffffc020307e:	00093503          	ld	a0,0(s2)
ffffffffc0203082:	4601                	li	a2,0
ffffffffc0203084:	6585                	lui	a1,0x1
ffffffffc0203086:	a22ff0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc020308a:	54050263          	beqz	a0,ffffffffc02035ce <pmm_init+0x8b4>
ffffffffc020308e:	6118                	ld	a4,0(a0)
ffffffffc0203090:	00177793          	andi	a5,a4,1
ffffffffc0203094:	180781e3          	beqz	a5,ffffffffc0203a16 <pmm_init+0xcfc>
ffffffffc0203098:	6094                	ld	a3,0(s1)
ffffffffc020309a:	00271793          	slli	a5,a4,0x2
ffffffffc020309e:	83b1                	srli	a5,a5,0xc
ffffffffc02030a0:	52d7f563          	bgeu	a5,a3,ffffffffc02035ca <pmm_init+0x8b0>
ffffffffc02030a4:	000bb683          	ld	a3,0(s7)
ffffffffc02030a8:	fff80ab7          	lui	s5,0xfff80
ffffffffc02030ac:	97d6                	add	a5,a5,s5
ffffffffc02030ae:	079a                	slli	a5,a5,0x6
ffffffffc02030b0:	97b6                	add	a5,a5,a3
ffffffffc02030b2:	58fa1e63          	bne	s4,a5,ffffffffc020364e <pmm_init+0x934>
ffffffffc02030b6:	8b41                	andi	a4,a4,16
ffffffffc02030b8:	56071b63          	bnez	a4,ffffffffc020362e <pmm_init+0x914>
ffffffffc02030bc:	00093503          	ld	a0,0(s2)
ffffffffc02030c0:	4581                	li	a1,0
ffffffffc02030c2:	ac7ff0ef          	jal	ra,ffffffffc0202b88 <page_remove>
ffffffffc02030c6:	000a2c83          	lw	s9,0(s4)
ffffffffc02030ca:	4785                	li	a5,1
ffffffffc02030cc:	5cfc9163          	bne	s9,a5,ffffffffc020368e <pmm_init+0x974>
ffffffffc02030d0:	000c2783          	lw	a5,0(s8)
ffffffffc02030d4:	58079d63          	bnez	a5,ffffffffc020366e <pmm_init+0x954>
ffffffffc02030d8:	00093503          	ld	a0,0(s2)
ffffffffc02030dc:	6585                	lui	a1,0x1
ffffffffc02030de:	aabff0ef          	jal	ra,ffffffffc0202b88 <page_remove>
ffffffffc02030e2:	000a2783          	lw	a5,0(s4)
ffffffffc02030e6:	200793e3          	bnez	a5,ffffffffc0203aec <pmm_init+0xdd2>
ffffffffc02030ea:	000c2783          	lw	a5,0(s8)
ffffffffc02030ee:	1c079fe3          	bnez	a5,ffffffffc0203acc <pmm_init+0xdb2>
ffffffffc02030f2:	00093a03          	ld	s4,0(s2)
ffffffffc02030f6:	608c                	ld	a1,0(s1)
ffffffffc02030f8:	000a3683          	ld	a3,0(s4)
ffffffffc02030fc:	068a                	slli	a3,a3,0x2
ffffffffc02030fe:	82b1                	srli	a3,a3,0xc
ffffffffc0203100:	4cb6f563          	bgeu	a3,a1,ffffffffc02035ca <pmm_init+0x8b0>
ffffffffc0203104:	000bb503          	ld	a0,0(s7)
ffffffffc0203108:	96d6                	add	a3,a3,s5
ffffffffc020310a:	069a                	slli	a3,a3,0x6
ffffffffc020310c:	00d507b3          	add	a5,a0,a3
ffffffffc0203110:	439c                	lw	a5,0(a5)
ffffffffc0203112:	4f979e63          	bne	a5,s9,ffffffffc020360e <pmm_init+0x8f4>
ffffffffc0203116:	8699                	srai	a3,a3,0x6
ffffffffc0203118:	00080637          	lui	a2,0x80
ffffffffc020311c:	96b2                	add	a3,a3,a2
ffffffffc020311e:	00c69713          	slli	a4,a3,0xc
ffffffffc0203122:	8331                	srli	a4,a4,0xc
ffffffffc0203124:	06b2                	slli	a3,a3,0xc
ffffffffc0203126:	06b773e3          	bgeu	a4,a1,ffffffffc020398c <pmm_init+0xc72>
ffffffffc020312a:	0009b703          	ld	a4,0(s3)
ffffffffc020312e:	96ba                	add	a3,a3,a4
ffffffffc0203130:	629c                	ld	a5,0(a3)
ffffffffc0203132:	078a                	slli	a5,a5,0x2
ffffffffc0203134:	83b1                	srli	a5,a5,0xc
ffffffffc0203136:	48b7fa63          	bgeu	a5,a1,ffffffffc02035ca <pmm_init+0x8b0>
ffffffffc020313a:	8f91                	sub	a5,a5,a2
ffffffffc020313c:	079a                	slli	a5,a5,0x6
ffffffffc020313e:	953e                	add	a0,a0,a5
ffffffffc0203140:	100027f3          	csrr	a5,sstatus
ffffffffc0203144:	8b89                	andi	a5,a5,2
ffffffffc0203146:	32079463          	bnez	a5,ffffffffc020346e <pmm_init+0x754>
ffffffffc020314a:	000b3783          	ld	a5,0(s6)
ffffffffc020314e:	4585                	li	a1,1
ffffffffc0203150:	739c                	ld	a5,32(a5)
ffffffffc0203152:	9782                	jalr	a5
ffffffffc0203154:	000a3783          	ld	a5,0(s4)
ffffffffc0203158:	6098                	ld	a4,0(s1)
ffffffffc020315a:	078a                	slli	a5,a5,0x2
ffffffffc020315c:	83b1                	srli	a5,a5,0xc
ffffffffc020315e:	46e7f663          	bgeu	a5,a4,ffffffffc02035ca <pmm_init+0x8b0>
ffffffffc0203162:	000bb503          	ld	a0,0(s7)
ffffffffc0203166:	fff80737          	lui	a4,0xfff80
ffffffffc020316a:	97ba                	add	a5,a5,a4
ffffffffc020316c:	079a                	slli	a5,a5,0x6
ffffffffc020316e:	953e                	add	a0,a0,a5
ffffffffc0203170:	100027f3          	csrr	a5,sstatus
ffffffffc0203174:	8b89                	andi	a5,a5,2
ffffffffc0203176:	2e079063          	bnez	a5,ffffffffc0203456 <pmm_init+0x73c>
ffffffffc020317a:	000b3783          	ld	a5,0(s6)
ffffffffc020317e:	4585                	li	a1,1
ffffffffc0203180:	739c                	ld	a5,32(a5)
ffffffffc0203182:	9782                	jalr	a5
ffffffffc0203184:	00093783          	ld	a5,0(s2)
ffffffffc0203188:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd686e0>
ffffffffc020318c:	12000073          	sfence.vma
ffffffffc0203190:	100027f3          	csrr	a5,sstatus
ffffffffc0203194:	8b89                	andi	a5,a5,2
ffffffffc0203196:	2a079663          	bnez	a5,ffffffffc0203442 <pmm_init+0x728>
ffffffffc020319a:	000b3783          	ld	a5,0(s6)
ffffffffc020319e:	779c                	ld	a5,40(a5)
ffffffffc02031a0:	9782                	jalr	a5
ffffffffc02031a2:	8a2a                	mv	s4,a0
ffffffffc02031a4:	7d441463          	bne	s0,s4,ffffffffc020396c <pmm_init+0xc52>
ffffffffc02031a8:	0000a517          	auipc	a0,0xa
ffffffffc02031ac:	c3050513          	addi	a0,a0,-976 # ffffffffc020cdd8 <default_pmm_manager+0x608>
ffffffffc02031b0:	ff7fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02031b4:	100027f3          	csrr	a5,sstatus
ffffffffc02031b8:	8b89                	andi	a5,a5,2
ffffffffc02031ba:	26079a63          	bnez	a5,ffffffffc020342e <pmm_init+0x714>
ffffffffc02031be:	000b3783          	ld	a5,0(s6)
ffffffffc02031c2:	779c                	ld	a5,40(a5)
ffffffffc02031c4:	9782                	jalr	a5
ffffffffc02031c6:	8c2a                	mv	s8,a0
ffffffffc02031c8:	6098                	ld	a4,0(s1)
ffffffffc02031ca:	c0200437          	lui	s0,0xc0200
ffffffffc02031ce:	7afd                	lui	s5,0xfffff
ffffffffc02031d0:	00c71793          	slli	a5,a4,0xc
ffffffffc02031d4:	6a05                	lui	s4,0x1
ffffffffc02031d6:	02f47c63          	bgeu	s0,a5,ffffffffc020320e <pmm_init+0x4f4>
ffffffffc02031da:	00c45793          	srli	a5,s0,0xc
ffffffffc02031de:	00093503          	ld	a0,0(s2)
ffffffffc02031e2:	3ae7f763          	bgeu	a5,a4,ffffffffc0203590 <pmm_init+0x876>
ffffffffc02031e6:	0009b583          	ld	a1,0(s3)
ffffffffc02031ea:	4601                	li	a2,0
ffffffffc02031ec:	95a2                	add	a1,a1,s0
ffffffffc02031ee:	8baff0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc02031f2:	36050f63          	beqz	a0,ffffffffc0203570 <pmm_init+0x856>
ffffffffc02031f6:	611c                	ld	a5,0(a0)
ffffffffc02031f8:	078a                	slli	a5,a5,0x2
ffffffffc02031fa:	0157f7b3          	and	a5,a5,s5
ffffffffc02031fe:	3a879663          	bne	a5,s0,ffffffffc02035aa <pmm_init+0x890>
ffffffffc0203202:	6098                	ld	a4,0(s1)
ffffffffc0203204:	9452                	add	s0,s0,s4
ffffffffc0203206:	00c71793          	slli	a5,a4,0xc
ffffffffc020320a:	fcf468e3          	bltu	s0,a5,ffffffffc02031da <pmm_init+0x4c0>
ffffffffc020320e:	00093783          	ld	a5,0(s2)
ffffffffc0203212:	639c                	ld	a5,0(a5)
ffffffffc0203214:	48079d63          	bnez	a5,ffffffffc02036ae <pmm_init+0x994>
ffffffffc0203218:	100027f3          	csrr	a5,sstatus
ffffffffc020321c:	8b89                	andi	a5,a5,2
ffffffffc020321e:	26079463          	bnez	a5,ffffffffc0203486 <pmm_init+0x76c>
ffffffffc0203222:	000b3783          	ld	a5,0(s6)
ffffffffc0203226:	4505                	li	a0,1
ffffffffc0203228:	6f9c                	ld	a5,24(a5)
ffffffffc020322a:	9782                	jalr	a5
ffffffffc020322c:	8a2a                	mv	s4,a0
ffffffffc020322e:	00093503          	ld	a0,0(s2)
ffffffffc0203232:	4699                	li	a3,6
ffffffffc0203234:	10000613          	li	a2,256
ffffffffc0203238:	85d2                	mv	a1,s4
ffffffffc020323a:	9ebff0ef          	jal	ra,ffffffffc0202c24 <page_insert>
ffffffffc020323e:	4a051863          	bnez	a0,ffffffffc02036ee <pmm_init+0x9d4>
ffffffffc0203242:	000a2703          	lw	a4,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0203246:	4785                	li	a5,1
ffffffffc0203248:	48f71363          	bne	a4,a5,ffffffffc02036ce <pmm_init+0x9b4>
ffffffffc020324c:	00093503          	ld	a0,0(s2)
ffffffffc0203250:	6405                	lui	s0,0x1
ffffffffc0203252:	4699                	li	a3,6
ffffffffc0203254:	10040613          	addi	a2,s0,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc0203258:	85d2                	mv	a1,s4
ffffffffc020325a:	9cbff0ef          	jal	ra,ffffffffc0202c24 <page_insert>
ffffffffc020325e:	38051863          	bnez	a0,ffffffffc02035ee <pmm_init+0x8d4>
ffffffffc0203262:	000a2703          	lw	a4,0(s4)
ffffffffc0203266:	4789                	li	a5,2
ffffffffc0203268:	4ef71363          	bne	a4,a5,ffffffffc020374e <pmm_init+0xa34>
ffffffffc020326c:	0000a597          	auipc	a1,0xa
ffffffffc0203270:	cb458593          	addi	a1,a1,-844 # ffffffffc020cf20 <default_pmm_manager+0x750>
ffffffffc0203274:	10000513          	li	a0,256
ffffffffc0203278:	502080ef          	jal	ra,ffffffffc020b77a <strcpy>
ffffffffc020327c:	10040593          	addi	a1,s0,256
ffffffffc0203280:	10000513          	li	a0,256
ffffffffc0203284:	508080ef          	jal	ra,ffffffffc020b78c <strcmp>
ffffffffc0203288:	4a051363          	bnez	a0,ffffffffc020372e <pmm_init+0xa14>
ffffffffc020328c:	000bb683          	ld	a3,0(s7)
ffffffffc0203290:	00080737          	lui	a4,0x80
ffffffffc0203294:	547d                	li	s0,-1
ffffffffc0203296:	40da06b3          	sub	a3,s4,a3
ffffffffc020329a:	8699                	srai	a3,a3,0x6
ffffffffc020329c:	609c                	ld	a5,0(s1)
ffffffffc020329e:	96ba                	add	a3,a3,a4
ffffffffc02032a0:	8031                	srli	s0,s0,0xc
ffffffffc02032a2:	0086f733          	and	a4,a3,s0
ffffffffc02032a6:	06b2                	slli	a3,a3,0xc
ffffffffc02032a8:	6ef77263          	bgeu	a4,a5,ffffffffc020398c <pmm_init+0xc72>
ffffffffc02032ac:	0009b783          	ld	a5,0(s3)
ffffffffc02032b0:	10000513          	li	a0,256
ffffffffc02032b4:	96be                	add	a3,a3,a5
ffffffffc02032b6:	10068023          	sb	zero,256(a3)
ffffffffc02032ba:	48a080ef          	jal	ra,ffffffffc020b744 <strlen>
ffffffffc02032be:	44051863          	bnez	a0,ffffffffc020370e <pmm_init+0x9f4>
ffffffffc02032c2:	00093a83          	ld	s5,0(s2)
ffffffffc02032c6:	609c                	ld	a5,0(s1)
ffffffffc02032c8:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd686e0>
ffffffffc02032cc:	068a                	slli	a3,a3,0x2
ffffffffc02032ce:	82b1                	srli	a3,a3,0xc
ffffffffc02032d0:	2ef6fd63          	bgeu	a3,a5,ffffffffc02035ca <pmm_init+0x8b0>
ffffffffc02032d4:	8c75                	and	s0,s0,a3
ffffffffc02032d6:	06b2                	slli	a3,a3,0xc
ffffffffc02032d8:	6af47a63          	bgeu	s0,a5,ffffffffc020398c <pmm_init+0xc72>
ffffffffc02032dc:	0009b403          	ld	s0,0(s3)
ffffffffc02032e0:	9436                	add	s0,s0,a3
ffffffffc02032e2:	100027f3          	csrr	a5,sstatus
ffffffffc02032e6:	8b89                	andi	a5,a5,2
ffffffffc02032e8:	1e079c63          	bnez	a5,ffffffffc02034e0 <pmm_init+0x7c6>
ffffffffc02032ec:	000b3783          	ld	a5,0(s6)
ffffffffc02032f0:	4585                	li	a1,1
ffffffffc02032f2:	8552                	mv	a0,s4
ffffffffc02032f4:	739c                	ld	a5,32(a5)
ffffffffc02032f6:	9782                	jalr	a5
ffffffffc02032f8:	601c                	ld	a5,0(s0)
ffffffffc02032fa:	6098                	ld	a4,0(s1)
ffffffffc02032fc:	078a                	slli	a5,a5,0x2
ffffffffc02032fe:	83b1                	srli	a5,a5,0xc
ffffffffc0203300:	2ce7f563          	bgeu	a5,a4,ffffffffc02035ca <pmm_init+0x8b0>
ffffffffc0203304:	000bb503          	ld	a0,0(s7)
ffffffffc0203308:	fff80737          	lui	a4,0xfff80
ffffffffc020330c:	97ba                	add	a5,a5,a4
ffffffffc020330e:	079a                	slli	a5,a5,0x6
ffffffffc0203310:	953e                	add	a0,a0,a5
ffffffffc0203312:	100027f3          	csrr	a5,sstatus
ffffffffc0203316:	8b89                	andi	a5,a5,2
ffffffffc0203318:	1a079863          	bnez	a5,ffffffffc02034c8 <pmm_init+0x7ae>
ffffffffc020331c:	000b3783          	ld	a5,0(s6)
ffffffffc0203320:	4585                	li	a1,1
ffffffffc0203322:	739c                	ld	a5,32(a5)
ffffffffc0203324:	9782                	jalr	a5
ffffffffc0203326:	000ab783          	ld	a5,0(s5)
ffffffffc020332a:	6098                	ld	a4,0(s1)
ffffffffc020332c:	078a                	slli	a5,a5,0x2
ffffffffc020332e:	83b1                	srli	a5,a5,0xc
ffffffffc0203330:	28e7fd63          	bgeu	a5,a4,ffffffffc02035ca <pmm_init+0x8b0>
ffffffffc0203334:	000bb503          	ld	a0,0(s7)
ffffffffc0203338:	fff80737          	lui	a4,0xfff80
ffffffffc020333c:	97ba                	add	a5,a5,a4
ffffffffc020333e:	079a                	slli	a5,a5,0x6
ffffffffc0203340:	953e                	add	a0,a0,a5
ffffffffc0203342:	100027f3          	csrr	a5,sstatus
ffffffffc0203346:	8b89                	andi	a5,a5,2
ffffffffc0203348:	16079463          	bnez	a5,ffffffffc02034b0 <pmm_init+0x796>
ffffffffc020334c:	000b3783          	ld	a5,0(s6)
ffffffffc0203350:	4585                	li	a1,1
ffffffffc0203352:	739c                	ld	a5,32(a5)
ffffffffc0203354:	9782                	jalr	a5
ffffffffc0203356:	00093783          	ld	a5,0(s2)
ffffffffc020335a:	0007b023          	sd	zero,0(a5)
ffffffffc020335e:	12000073          	sfence.vma
ffffffffc0203362:	100027f3          	csrr	a5,sstatus
ffffffffc0203366:	8b89                	andi	a5,a5,2
ffffffffc0203368:	12079a63          	bnez	a5,ffffffffc020349c <pmm_init+0x782>
ffffffffc020336c:	000b3783          	ld	a5,0(s6)
ffffffffc0203370:	779c                	ld	a5,40(a5)
ffffffffc0203372:	9782                	jalr	a5
ffffffffc0203374:	842a                	mv	s0,a0
ffffffffc0203376:	488c1e63          	bne	s8,s0,ffffffffc0203812 <pmm_init+0xaf8>
ffffffffc020337a:	0000a517          	auipc	a0,0xa
ffffffffc020337e:	c1e50513          	addi	a0,a0,-994 # ffffffffc020cf98 <default_pmm_manager+0x7c8>
ffffffffc0203382:	e25fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203386:	7406                	ld	s0,96(sp)
ffffffffc0203388:	70a6                	ld	ra,104(sp)
ffffffffc020338a:	64e6                	ld	s1,88(sp)
ffffffffc020338c:	6946                	ld	s2,80(sp)
ffffffffc020338e:	69a6                	ld	s3,72(sp)
ffffffffc0203390:	6a06                	ld	s4,64(sp)
ffffffffc0203392:	7ae2                	ld	s5,56(sp)
ffffffffc0203394:	7b42                	ld	s6,48(sp)
ffffffffc0203396:	7ba2                	ld	s7,40(sp)
ffffffffc0203398:	7c02                	ld	s8,32(sp)
ffffffffc020339a:	6ce2                	ld	s9,24(sp)
ffffffffc020339c:	6165                	addi	sp,sp,112
ffffffffc020339e:	c51fe06f          	j	ffffffffc0201fee <kmalloc_init>
ffffffffc02033a2:	c80007b7          	lui	a5,0xc8000
ffffffffc02033a6:	b411                	j	ffffffffc0202daa <pmm_init+0x90>
ffffffffc02033a8:	8cbfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02033ac:	000b3783          	ld	a5,0(s6)
ffffffffc02033b0:	4505                	li	a0,1
ffffffffc02033b2:	6f9c                	ld	a5,24(a5)
ffffffffc02033b4:	9782                	jalr	a5
ffffffffc02033b6:	8c2a                	mv	s8,a0
ffffffffc02033b8:	8b5fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02033bc:	b9a9                	j	ffffffffc0203016 <pmm_init+0x2fc>
ffffffffc02033be:	8b5fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02033c2:	000b3783          	ld	a5,0(s6)
ffffffffc02033c6:	4505                	li	a0,1
ffffffffc02033c8:	6f9c                	ld	a5,24(a5)
ffffffffc02033ca:	9782                	jalr	a5
ffffffffc02033cc:	8a2a                	mv	s4,a0
ffffffffc02033ce:	89ffd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02033d2:	b645                	j	ffffffffc0202f72 <pmm_init+0x258>
ffffffffc02033d4:	89ffd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02033d8:	000b3783          	ld	a5,0(s6)
ffffffffc02033dc:	779c                	ld	a5,40(a5)
ffffffffc02033de:	9782                	jalr	a5
ffffffffc02033e0:	842a                	mv	s0,a0
ffffffffc02033e2:	88bfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02033e6:	b6b9                	j	ffffffffc0202f34 <pmm_init+0x21a>
ffffffffc02033e8:	88bfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02033ec:	000b3783          	ld	a5,0(s6)
ffffffffc02033f0:	4505                	li	a0,1
ffffffffc02033f2:	6f9c                	ld	a5,24(a5)
ffffffffc02033f4:	9782                	jalr	a5
ffffffffc02033f6:	842a                	mv	s0,a0
ffffffffc02033f8:	875fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02033fc:	bc99                	j	ffffffffc0202e52 <pmm_init+0x138>
ffffffffc02033fe:	6705                	lui	a4,0x1
ffffffffc0203400:	177d                	addi	a4,a4,-1
ffffffffc0203402:	96ba                	add	a3,a3,a4
ffffffffc0203404:	8ff5                	and	a5,a5,a3
ffffffffc0203406:	00c7d713          	srli	a4,a5,0xc
ffffffffc020340a:	1ca77063          	bgeu	a4,a0,ffffffffc02035ca <pmm_init+0x8b0>
ffffffffc020340e:	000b3683          	ld	a3,0(s6)
ffffffffc0203412:	fff80537          	lui	a0,0xfff80
ffffffffc0203416:	972a                	add	a4,a4,a0
ffffffffc0203418:	6a94                	ld	a3,16(a3)
ffffffffc020341a:	8c1d                	sub	s0,s0,a5
ffffffffc020341c:	00671513          	slli	a0,a4,0x6
ffffffffc0203420:	00c45593          	srli	a1,s0,0xc
ffffffffc0203424:	9532                	add	a0,a0,a2
ffffffffc0203426:	9682                	jalr	a3
ffffffffc0203428:	0009b583          	ld	a1,0(s3)
ffffffffc020342c:	bac5                	j	ffffffffc0202e1c <pmm_init+0x102>
ffffffffc020342e:	845fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203432:	000b3783          	ld	a5,0(s6)
ffffffffc0203436:	779c                	ld	a5,40(a5)
ffffffffc0203438:	9782                	jalr	a5
ffffffffc020343a:	8c2a                	mv	s8,a0
ffffffffc020343c:	831fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203440:	b361                	j	ffffffffc02031c8 <pmm_init+0x4ae>
ffffffffc0203442:	831fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203446:	000b3783          	ld	a5,0(s6)
ffffffffc020344a:	779c                	ld	a5,40(a5)
ffffffffc020344c:	9782                	jalr	a5
ffffffffc020344e:	8a2a                	mv	s4,a0
ffffffffc0203450:	81dfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203454:	bb81                	j	ffffffffc02031a4 <pmm_init+0x48a>
ffffffffc0203456:	e42a                	sd	a0,8(sp)
ffffffffc0203458:	81bfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020345c:	000b3783          	ld	a5,0(s6)
ffffffffc0203460:	6522                	ld	a0,8(sp)
ffffffffc0203462:	4585                	li	a1,1
ffffffffc0203464:	739c                	ld	a5,32(a5)
ffffffffc0203466:	9782                	jalr	a5
ffffffffc0203468:	805fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020346c:	bb21                	j	ffffffffc0203184 <pmm_init+0x46a>
ffffffffc020346e:	e42a                	sd	a0,8(sp)
ffffffffc0203470:	803fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203474:	000b3783          	ld	a5,0(s6)
ffffffffc0203478:	6522                	ld	a0,8(sp)
ffffffffc020347a:	4585                	li	a1,1
ffffffffc020347c:	739c                	ld	a5,32(a5)
ffffffffc020347e:	9782                	jalr	a5
ffffffffc0203480:	fecfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203484:	b9c1                	j	ffffffffc0203154 <pmm_init+0x43a>
ffffffffc0203486:	fecfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020348a:	000b3783          	ld	a5,0(s6)
ffffffffc020348e:	4505                	li	a0,1
ffffffffc0203490:	6f9c                	ld	a5,24(a5)
ffffffffc0203492:	9782                	jalr	a5
ffffffffc0203494:	8a2a                	mv	s4,a0
ffffffffc0203496:	fd6fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020349a:	bb51                	j	ffffffffc020322e <pmm_init+0x514>
ffffffffc020349c:	fd6fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02034a0:	000b3783          	ld	a5,0(s6)
ffffffffc02034a4:	779c                	ld	a5,40(a5)
ffffffffc02034a6:	9782                	jalr	a5
ffffffffc02034a8:	842a                	mv	s0,a0
ffffffffc02034aa:	fc2fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02034ae:	b5e1                	j	ffffffffc0203376 <pmm_init+0x65c>
ffffffffc02034b0:	e42a                	sd	a0,8(sp)
ffffffffc02034b2:	fc0fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02034b6:	000b3783          	ld	a5,0(s6)
ffffffffc02034ba:	6522                	ld	a0,8(sp)
ffffffffc02034bc:	4585                	li	a1,1
ffffffffc02034be:	739c                	ld	a5,32(a5)
ffffffffc02034c0:	9782                	jalr	a5
ffffffffc02034c2:	faafd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02034c6:	bd41                	j	ffffffffc0203356 <pmm_init+0x63c>
ffffffffc02034c8:	e42a                	sd	a0,8(sp)
ffffffffc02034ca:	fa8fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02034ce:	000b3783          	ld	a5,0(s6)
ffffffffc02034d2:	6522                	ld	a0,8(sp)
ffffffffc02034d4:	4585                	li	a1,1
ffffffffc02034d6:	739c                	ld	a5,32(a5)
ffffffffc02034d8:	9782                	jalr	a5
ffffffffc02034da:	f92fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02034de:	b5a1                	j	ffffffffc0203326 <pmm_init+0x60c>
ffffffffc02034e0:	f92fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02034e4:	000b3783          	ld	a5,0(s6)
ffffffffc02034e8:	4585                	li	a1,1
ffffffffc02034ea:	8552                	mv	a0,s4
ffffffffc02034ec:	739c                	ld	a5,32(a5)
ffffffffc02034ee:	9782                	jalr	a5
ffffffffc02034f0:	f7cfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02034f4:	b511                	j	ffffffffc02032f8 <pmm_init+0x5de>
ffffffffc02034f6:	00010417          	auipc	s0,0x10
ffffffffc02034fa:	b0a40413          	addi	s0,s0,-1270 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc02034fe:	00010797          	auipc	a5,0x10
ffffffffc0203502:	b0278793          	addi	a5,a5,-1278 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc0203506:	a0f41de3          	bne	s0,a5,ffffffffc0202f20 <pmm_init+0x206>
ffffffffc020350a:	4581                	li	a1,0
ffffffffc020350c:	6605                	lui	a2,0x1
ffffffffc020350e:	8522                	mv	a0,s0
ffffffffc0203510:	2d6080ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0203514:	0000d597          	auipc	a1,0xd
ffffffffc0203518:	aec58593          	addi	a1,a1,-1300 # ffffffffc0210000 <bootstackguard>
ffffffffc020351c:	0000e797          	auipc	a5,0xe
ffffffffc0203520:	ae0781a3          	sb	zero,-1309(a5) # ffffffffc0210fff <bootstackguard+0xfff>
ffffffffc0203524:	0000d797          	auipc	a5,0xd
ffffffffc0203528:	ac078e23          	sb	zero,-1316(a5) # ffffffffc0210000 <bootstackguard>
ffffffffc020352c:	00093503          	ld	a0,0(s2)
ffffffffc0203530:	2555ec63          	bltu	a1,s5,ffffffffc0203788 <pmm_init+0xa6e>
ffffffffc0203534:	0009b683          	ld	a3,0(s3)
ffffffffc0203538:	4701                	li	a4,0
ffffffffc020353a:	6605                	lui	a2,0x1
ffffffffc020353c:	40d586b3          	sub	a3,a1,a3
ffffffffc0203540:	f91fe0ef          	jal	ra,ffffffffc02024d0 <boot_map_segment>
ffffffffc0203544:	00093503          	ld	a0,0(s2)
ffffffffc0203548:	23546363          	bltu	s0,s5,ffffffffc020376e <pmm_init+0xa54>
ffffffffc020354c:	0009b683          	ld	a3,0(s3)
ffffffffc0203550:	4701                	li	a4,0
ffffffffc0203552:	6605                	lui	a2,0x1
ffffffffc0203554:	40d406b3          	sub	a3,s0,a3
ffffffffc0203558:	85a2                	mv	a1,s0
ffffffffc020355a:	f77fe0ef          	jal	ra,ffffffffc02024d0 <boot_map_segment>
ffffffffc020355e:	12000073          	sfence.vma
ffffffffc0203562:	00009517          	auipc	a0,0x9
ffffffffc0203566:	54650513          	addi	a0,a0,1350 # ffffffffc020caa8 <default_pmm_manager+0x2d8>
ffffffffc020356a:	c3dfc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020356e:	ba4d                	j	ffffffffc0202f20 <pmm_init+0x206>
ffffffffc0203570:	0000a697          	auipc	a3,0xa
ffffffffc0203574:	88868693          	addi	a3,a3,-1912 # ffffffffc020cdf8 <default_pmm_manager+0x628>
ffffffffc0203578:	00008617          	auipc	a2,0x8
ffffffffc020357c:	75060613          	addi	a2,a2,1872 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203580:	2ab00593          	li	a1,683
ffffffffc0203584:	00009517          	auipc	a0,0x9
ffffffffc0203588:	39c50513          	addi	a0,a0,924 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020358c:	f13fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203590:	86a2                	mv	a3,s0
ffffffffc0203592:	00009617          	auipc	a2,0x9
ffffffffc0203596:	27660613          	addi	a2,a2,630 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc020359a:	2ab00593          	li	a1,683
ffffffffc020359e:	00009517          	auipc	a0,0x9
ffffffffc02035a2:	38250513          	addi	a0,a0,898 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02035a6:	ef9fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035aa:	0000a697          	auipc	a3,0xa
ffffffffc02035ae:	88e68693          	addi	a3,a3,-1906 # ffffffffc020ce38 <default_pmm_manager+0x668>
ffffffffc02035b2:	00008617          	auipc	a2,0x8
ffffffffc02035b6:	71660613          	addi	a2,a2,1814 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02035ba:	2ac00593          	li	a1,684
ffffffffc02035be:	00009517          	auipc	a0,0x9
ffffffffc02035c2:	36250513          	addi	a0,a0,866 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02035c6:	ed9fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035ca:	beffe0ef          	jal	ra,ffffffffc02021b8 <pa2page.part.0>
ffffffffc02035ce:	00009697          	auipc	a3,0x9
ffffffffc02035d2:	69268693          	addi	a3,a3,1682 # ffffffffc020cc60 <default_pmm_manager+0x490>
ffffffffc02035d6:	00008617          	auipc	a2,0x8
ffffffffc02035da:	6f260613          	addi	a2,a2,1778 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02035de:	28800593          	li	a1,648
ffffffffc02035e2:	00009517          	auipc	a0,0x9
ffffffffc02035e6:	33e50513          	addi	a0,a0,830 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02035ea:	eb5fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035ee:	0000a697          	auipc	a3,0xa
ffffffffc02035f2:	8d268693          	addi	a3,a3,-1838 # ffffffffc020cec0 <default_pmm_manager+0x6f0>
ffffffffc02035f6:	00008617          	auipc	a2,0x8
ffffffffc02035fa:	6d260613          	addi	a2,a2,1746 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02035fe:	2b500593          	li	a1,693
ffffffffc0203602:	00009517          	auipc	a0,0x9
ffffffffc0203606:	31e50513          	addi	a0,a0,798 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020360a:	e95fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020360e:	00009697          	auipc	a3,0x9
ffffffffc0203612:	77268693          	addi	a3,a3,1906 # ffffffffc020cd80 <default_pmm_manager+0x5b0>
ffffffffc0203616:	00008617          	auipc	a2,0x8
ffffffffc020361a:	6b260613          	addi	a2,a2,1714 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020361e:	29400593          	li	a1,660
ffffffffc0203622:	00009517          	auipc	a0,0x9
ffffffffc0203626:	2fe50513          	addi	a0,a0,766 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020362a:	e75fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020362e:	00009697          	auipc	a3,0x9
ffffffffc0203632:	72268693          	addi	a3,a3,1826 # ffffffffc020cd50 <default_pmm_manager+0x580>
ffffffffc0203636:	00008617          	auipc	a2,0x8
ffffffffc020363a:	69260613          	addi	a2,a2,1682 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020363e:	28a00593          	li	a1,650
ffffffffc0203642:	00009517          	auipc	a0,0x9
ffffffffc0203646:	2de50513          	addi	a0,a0,734 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020364a:	e55fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020364e:	00009697          	auipc	a3,0x9
ffffffffc0203652:	57268693          	addi	a3,a3,1394 # ffffffffc020cbc0 <default_pmm_manager+0x3f0>
ffffffffc0203656:	00008617          	auipc	a2,0x8
ffffffffc020365a:	67260613          	addi	a2,a2,1650 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020365e:	28900593          	li	a1,649
ffffffffc0203662:	00009517          	auipc	a0,0x9
ffffffffc0203666:	2be50513          	addi	a0,a0,702 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020366a:	e35fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020366e:	00009697          	auipc	a3,0x9
ffffffffc0203672:	6ca68693          	addi	a3,a3,1738 # ffffffffc020cd38 <default_pmm_manager+0x568>
ffffffffc0203676:	00008617          	auipc	a2,0x8
ffffffffc020367a:	65260613          	addi	a2,a2,1618 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020367e:	28e00593          	li	a1,654
ffffffffc0203682:	00009517          	auipc	a0,0x9
ffffffffc0203686:	29e50513          	addi	a0,a0,670 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020368a:	e15fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020368e:	00009697          	auipc	a3,0x9
ffffffffc0203692:	54a68693          	addi	a3,a3,1354 # ffffffffc020cbd8 <default_pmm_manager+0x408>
ffffffffc0203696:	00008617          	auipc	a2,0x8
ffffffffc020369a:	63260613          	addi	a2,a2,1586 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020369e:	28d00593          	li	a1,653
ffffffffc02036a2:	00009517          	auipc	a0,0x9
ffffffffc02036a6:	27e50513          	addi	a0,a0,638 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02036aa:	df5fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036ae:	00009697          	auipc	a3,0x9
ffffffffc02036b2:	7a268693          	addi	a3,a3,1954 # ffffffffc020ce50 <default_pmm_manager+0x680>
ffffffffc02036b6:	00008617          	auipc	a2,0x8
ffffffffc02036ba:	61260613          	addi	a2,a2,1554 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02036be:	2af00593          	li	a1,687
ffffffffc02036c2:	00009517          	auipc	a0,0x9
ffffffffc02036c6:	25e50513          	addi	a0,a0,606 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02036ca:	dd5fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036ce:	00009697          	auipc	a3,0x9
ffffffffc02036d2:	7da68693          	addi	a3,a3,2010 # ffffffffc020cea8 <default_pmm_manager+0x6d8>
ffffffffc02036d6:	00008617          	auipc	a2,0x8
ffffffffc02036da:	5f260613          	addi	a2,a2,1522 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02036de:	2b400593          	li	a1,692
ffffffffc02036e2:	00009517          	auipc	a0,0x9
ffffffffc02036e6:	23e50513          	addi	a0,a0,574 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02036ea:	db5fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036ee:	00009697          	auipc	a3,0x9
ffffffffc02036f2:	77a68693          	addi	a3,a3,1914 # ffffffffc020ce68 <default_pmm_manager+0x698>
ffffffffc02036f6:	00008617          	auipc	a2,0x8
ffffffffc02036fa:	5d260613          	addi	a2,a2,1490 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02036fe:	2b300593          	li	a1,691
ffffffffc0203702:	00009517          	auipc	a0,0x9
ffffffffc0203706:	21e50513          	addi	a0,a0,542 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020370a:	d95fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020370e:	0000a697          	auipc	a3,0xa
ffffffffc0203712:	86268693          	addi	a3,a3,-1950 # ffffffffc020cf70 <default_pmm_manager+0x7a0>
ffffffffc0203716:	00008617          	auipc	a2,0x8
ffffffffc020371a:	5b260613          	addi	a2,a2,1458 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020371e:	2bd00593          	li	a1,701
ffffffffc0203722:	00009517          	auipc	a0,0x9
ffffffffc0203726:	1fe50513          	addi	a0,a0,510 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020372a:	d75fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020372e:	0000a697          	auipc	a3,0xa
ffffffffc0203732:	80a68693          	addi	a3,a3,-2038 # ffffffffc020cf38 <default_pmm_manager+0x768>
ffffffffc0203736:	00008617          	auipc	a2,0x8
ffffffffc020373a:	59260613          	addi	a2,a2,1426 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020373e:	2ba00593          	li	a1,698
ffffffffc0203742:	00009517          	auipc	a0,0x9
ffffffffc0203746:	1de50513          	addi	a0,a0,478 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020374a:	d55fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020374e:	00009697          	auipc	a3,0x9
ffffffffc0203752:	7ba68693          	addi	a3,a3,1978 # ffffffffc020cf08 <default_pmm_manager+0x738>
ffffffffc0203756:	00008617          	auipc	a2,0x8
ffffffffc020375a:	57260613          	addi	a2,a2,1394 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020375e:	2b600593          	li	a1,694
ffffffffc0203762:	00009517          	auipc	a0,0x9
ffffffffc0203766:	1be50513          	addi	a0,a0,446 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020376a:	d35fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020376e:	86a2                	mv	a3,s0
ffffffffc0203770:	00009617          	auipc	a2,0x9
ffffffffc0203774:	14060613          	addi	a2,a2,320 # ffffffffc020c8b0 <default_pmm_manager+0xe0>
ffffffffc0203778:	0dc00593          	li	a1,220
ffffffffc020377c:	00009517          	auipc	a0,0x9
ffffffffc0203780:	1a450513          	addi	a0,a0,420 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203784:	d1bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203788:	86ae                	mv	a3,a1
ffffffffc020378a:	00009617          	auipc	a2,0x9
ffffffffc020378e:	12660613          	addi	a2,a2,294 # ffffffffc020c8b0 <default_pmm_manager+0xe0>
ffffffffc0203792:	0db00593          	li	a1,219
ffffffffc0203796:	00009517          	auipc	a0,0x9
ffffffffc020379a:	18a50513          	addi	a0,a0,394 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020379e:	d01fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037a2:	00009697          	auipc	a3,0x9
ffffffffc02037a6:	34e68693          	addi	a3,a3,846 # ffffffffc020caf0 <default_pmm_manager+0x320>
ffffffffc02037aa:	00008617          	auipc	a2,0x8
ffffffffc02037ae:	51e60613          	addi	a2,a2,1310 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02037b2:	26d00593          	li	a1,621
ffffffffc02037b6:	00009517          	auipc	a0,0x9
ffffffffc02037ba:	16a50513          	addi	a0,a0,362 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02037be:	ce1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037c2:	00009697          	auipc	a3,0x9
ffffffffc02037c6:	30e68693          	addi	a3,a3,782 # ffffffffc020cad0 <default_pmm_manager+0x300>
ffffffffc02037ca:	00008617          	auipc	a2,0x8
ffffffffc02037ce:	4fe60613          	addi	a2,a2,1278 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02037d2:	26c00593          	li	a1,620
ffffffffc02037d6:	00009517          	auipc	a0,0x9
ffffffffc02037da:	14a50513          	addi	a0,a0,330 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02037de:	cc1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037e2:	00009617          	auipc	a2,0x9
ffffffffc02037e6:	27e60613          	addi	a2,a2,638 # ffffffffc020ca60 <default_pmm_manager+0x290>
ffffffffc02037ea:	0aa00593          	li	a1,170
ffffffffc02037ee:	00009517          	auipc	a0,0x9
ffffffffc02037f2:	13250513          	addi	a0,a0,306 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02037f6:	ca9fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037fa:	00009617          	auipc	a2,0x9
ffffffffc02037fe:	1ce60613          	addi	a2,a2,462 # ffffffffc020c9c8 <default_pmm_manager+0x1f8>
ffffffffc0203802:	06500593          	li	a1,101
ffffffffc0203806:	00009517          	auipc	a0,0x9
ffffffffc020380a:	11a50513          	addi	a0,a0,282 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020380e:	c91fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203812:	00009697          	auipc	a3,0x9
ffffffffc0203816:	59e68693          	addi	a3,a3,1438 # ffffffffc020cdb0 <default_pmm_manager+0x5e0>
ffffffffc020381a:	00008617          	auipc	a2,0x8
ffffffffc020381e:	4ae60613          	addi	a2,a2,1198 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203822:	2c600593          	li	a1,710
ffffffffc0203826:	00009517          	auipc	a0,0x9
ffffffffc020382a:	0fa50513          	addi	a0,a0,250 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020382e:	c71fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203832:	00009697          	auipc	a3,0x9
ffffffffc0203836:	3be68693          	addi	a3,a3,958 # ffffffffc020cbf0 <default_pmm_manager+0x420>
ffffffffc020383a:	00008617          	auipc	a2,0x8
ffffffffc020383e:	48e60613          	addi	a2,a2,1166 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203842:	27b00593          	li	a1,635
ffffffffc0203846:	00009517          	auipc	a0,0x9
ffffffffc020384a:	0da50513          	addi	a0,a0,218 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc020384e:	c51fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203852:	86d6                	mv	a3,s5
ffffffffc0203854:	00009617          	auipc	a2,0x9
ffffffffc0203858:	fb460613          	addi	a2,a2,-76 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc020385c:	27a00593          	li	a1,634
ffffffffc0203860:	00009517          	auipc	a0,0x9
ffffffffc0203864:	0c050513          	addi	a0,a0,192 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203868:	c37fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020386c:	00009697          	auipc	a3,0x9
ffffffffc0203870:	4cc68693          	addi	a3,a3,1228 # ffffffffc020cd38 <default_pmm_manager+0x568>
ffffffffc0203874:	00008617          	auipc	a2,0x8
ffffffffc0203878:	45460613          	addi	a2,a2,1108 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020387c:	28700593          	li	a1,647
ffffffffc0203880:	00009517          	auipc	a0,0x9
ffffffffc0203884:	0a050513          	addi	a0,a0,160 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203888:	c17fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020388c:	00009697          	auipc	a3,0x9
ffffffffc0203890:	49468693          	addi	a3,a3,1172 # ffffffffc020cd20 <default_pmm_manager+0x550>
ffffffffc0203894:	00008617          	auipc	a2,0x8
ffffffffc0203898:	43460613          	addi	a2,a2,1076 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020389c:	28600593          	li	a1,646
ffffffffc02038a0:	00009517          	auipc	a0,0x9
ffffffffc02038a4:	08050513          	addi	a0,a0,128 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02038a8:	bf7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02038ac:	00009697          	auipc	a3,0x9
ffffffffc02038b0:	44468693          	addi	a3,a3,1092 # ffffffffc020ccf0 <default_pmm_manager+0x520>
ffffffffc02038b4:	00008617          	auipc	a2,0x8
ffffffffc02038b8:	41460613          	addi	a2,a2,1044 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02038bc:	28500593          	li	a1,645
ffffffffc02038c0:	00009517          	auipc	a0,0x9
ffffffffc02038c4:	06050513          	addi	a0,a0,96 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02038c8:	bd7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02038cc:	00009697          	auipc	a3,0x9
ffffffffc02038d0:	40c68693          	addi	a3,a3,1036 # ffffffffc020ccd8 <default_pmm_manager+0x508>
ffffffffc02038d4:	00008617          	auipc	a2,0x8
ffffffffc02038d8:	3f460613          	addi	a2,a2,1012 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02038dc:	28300593          	li	a1,643
ffffffffc02038e0:	00009517          	auipc	a0,0x9
ffffffffc02038e4:	04050513          	addi	a0,a0,64 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02038e8:	bb7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02038ec:	00009697          	auipc	a3,0x9
ffffffffc02038f0:	3cc68693          	addi	a3,a3,972 # ffffffffc020ccb8 <default_pmm_manager+0x4e8>
ffffffffc02038f4:	00008617          	auipc	a2,0x8
ffffffffc02038f8:	3d460613          	addi	a2,a2,980 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02038fc:	28200593          	li	a1,642
ffffffffc0203900:	00009517          	auipc	a0,0x9
ffffffffc0203904:	02050513          	addi	a0,a0,32 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203908:	b97fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020390c:	00009697          	auipc	a3,0x9
ffffffffc0203910:	39c68693          	addi	a3,a3,924 # ffffffffc020cca8 <default_pmm_manager+0x4d8>
ffffffffc0203914:	00008617          	auipc	a2,0x8
ffffffffc0203918:	3b460613          	addi	a2,a2,948 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020391c:	28100593          	li	a1,641
ffffffffc0203920:	00009517          	auipc	a0,0x9
ffffffffc0203924:	00050513          	mv	a0,a0
ffffffffc0203928:	b77fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020392c:	00009697          	auipc	a3,0x9
ffffffffc0203930:	36c68693          	addi	a3,a3,876 # ffffffffc020cc98 <default_pmm_manager+0x4c8>
ffffffffc0203934:	00008617          	auipc	a2,0x8
ffffffffc0203938:	39460613          	addi	a2,a2,916 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020393c:	28000593          	li	a1,640
ffffffffc0203940:	00009517          	auipc	a0,0x9
ffffffffc0203944:	fe050513          	addi	a0,a0,-32 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203948:	b57fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020394c:	00009697          	auipc	a3,0x9
ffffffffc0203950:	31468693          	addi	a3,a3,788 # ffffffffc020cc60 <default_pmm_manager+0x490>
ffffffffc0203954:	00008617          	auipc	a2,0x8
ffffffffc0203958:	37460613          	addi	a2,a2,884 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020395c:	27f00593          	li	a1,639
ffffffffc0203960:	00009517          	auipc	a0,0x9
ffffffffc0203964:	fc050513          	addi	a0,a0,-64 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203968:	b37fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020396c:	00009697          	auipc	a3,0x9
ffffffffc0203970:	44468693          	addi	a3,a3,1092 # ffffffffc020cdb0 <default_pmm_manager+0x5e0>
ffffffffc0203974:	00008617          	auipc	a2,0x8
ffffffffc0203978:	35460613          	addi	a2,a2,852 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020397c:	29c00593          	li	a1,668
ffffffffc0203980:	00009517          	auipc	a0,0x9
ffffffffc0203984:	fa050513          	addi	a0,a0,-96 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203988:	b17fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020398c:	00009617          	auipc	a2,0x9
ffffffffc0203990:	e7c60613          	addi	a2,a2,-388 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc0203994:	07100593          	li	a1,113
ffffffffc0203998:	00009517          	auipc	a0,0x9
ffffffffc020399c:	e9850513          	addi	a0,a0,-360 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc02039a0:	afffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02039a4:	86a2                	mv	a3,s0
ffffffffc02039a6:	00009617          	auipc	a2,0x9
ffffffffc02039aa:	f0a60613          	addi	a2,a2,-246 # ffffffffc020c8b0 <default_pmm_manager+0xe0>
ffffffffc02039ae:	0ca00593          	li	a1,202
ffffffffc02039b2:	00009517          	auipc	a0,0x9
ffffffffc02039b6:	f6e50513          	addi	a0,a0,-146 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02039ba:	ae5fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02039be:	00009617          	auipc	a2,0x9
ffffffffc02039c2:	ef260613          	addi	a2,a2,-270 # ffffffffc020c8b0 <default_pmm_manager+0xe0>
ffffffffc02039c6:	08100593          	li	a1,129
ffffffffc02039ca:	00009517          	auipc	a0,0x9
ffffffffc02039ce:	f5650513          	addi	a0,a0,-170 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02039d2:	acdfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02039d6:	00009697          	auipc	a3,0x9
ffffffffc02039da:	24a68693          	addi	a3,a3,586 # ffffffffc020cc20 <default_pmm_manager+0x450>
ffffffffc02039de:	00008617          	auipc	a2,0x8
ffffffffc02039e2:	2ea60613          	addi	a2,a2,746 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02039e6:	27e00593          	li	a1,638
ffffffffc02039ea:	00009517          	auipc	a0,0x9
ffffffffc02039ee:	f3650513          	addi	a0,a0,-202 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc02039f2:	aadfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02039f6:	00009697          	auipc	a3,0x9
ffffffffc02039fa:	16a68693          	addi	a3,a3,362 # ffffffffc020cb60 <default_pmm_manager+0x390>
ffffffffc02039fe:	00008617          	auipc	a2,0x8
ffffffffc0203a02:	2ca60613          	addi	a2,a2,714 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203a06:	27200593          	li	a1,626
ffffffffc0203a0a:	00009517          	auipc	a0,0x9
ffffffffc0203a0e:	f1650513          	addi	a0,a0,-234 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203a12:	a8dfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203a16:	fbefe0ef          	jal	ra,ffffffffc02021d4 <pte2page.part.0>
ffffffffc0203a1a:	00009697          	auipc	a3,0x9
ffffffffc0203a1e:	17668693          	addi	a3,a3,374 # ffffffffc020cb90 <default_pmm_manager+0x3c0>
ffffffffc0203a22:	00008617          	auipc	a2,0x8
ffffffffc0203a26:	2a660613          	addi	a2,a2,678 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203a2a:	27500593          	li	a1,629
ffffffffc0203a2e:	00009517          	auipc	a0,0x9
ffffffffc0203a32:	ef250513          	addi	a0,a0,-270 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203a36:	a69fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203a3a:	00009697          	auipc	a3,0x9
ffffffffc0203a3e:	0f668693          	addi	a3,a3,246 # ffffffffc020cb30 <default_pmm_manager+0x360>
ffffffffc0203a42:	00008617          	auipc	a2,0x8
ffffffffc0203a46:	28660613          	addi	a2,a2,646 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203a4a:	26e00593          	li	a1,622
ffffffffc0203a4e:	00009517          	auipc	a0,0x9
ffffffffc0203a52:	ed250513          	addi	a0,a0,-302 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203a56:	a49fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203a5a:	00009697          	auipc	a3,0x9
ffffffffc0203a5e:	16668693          	addi	a3,a3,358 # ffffffffc020cbc0 <default_pmm_manager+0x3f0>
ffffffffc0203a62:	00008617          	auipc	a2,0x8
ffffffffc0203a66:	26660613          	addi	a2,a2,614 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203a6a:	27600593          	li	a1,630
ffffffffc0203a6e:	00009517          	auipc	a0,0x9
ffffffffc0203a72:	eb250513          	addi	a0,a0,-334 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203a76:	a29fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203a7a:	00009617          	auipc	a2,0x9
ffffffffc0203a7e:	d8e60613          	addi	a2,a2,-626 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc0203a82:	27900593          	li	a1,633
ffffffffc0203a86:	00009517          	auipc	a0,0x9
ffffffffc0203a8a:	e9a50513          	addi	a0,a0,-358 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203a8e:	a11fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203a92:	00009697          	auipc	a3,0x9
ffffffffc0203a96:	14668693          	addi	a3,a3,326 # ffffffffc020cbd8 <default_pmm_manager+0x408>
ffffffffc0203a9a:	00008617          	auipc	a2,0x8
ffffffffc0203a9e:	22e60613          	addi	a2,a2,558 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203aa2:	27700593          	li	a1,631
ffffffffc0203aa6:	00009517          	auipc	a0,0x9
ffffffffc0203aaa:	e7a50513          	addi	a0,a0,-390 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203aae:	9f1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203ab2:	86ca                	mv	a3,s2
ffffffffc0203ab4:	00009617          	auipc	a2,0x9
ffffffffc0203ab8:	dfc60613          	addi	a2,a2,-516 # ffffffffc020c8b0 <default_pmm_manager+0xe0>
ffffffffc0203abc:	0c600593          	li	a1,198
ffffffffc0203ac0:	00009517          	auipc	a0,0x9
ffffffffc0203ac4:	e6050513          	addi	a0,a0,-416 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203ac8:	9d7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203acc:	00009697          	auipc	a3,0x9
ffffffffc0203ad0:	26c68693          	addi	a3,a3,620 # ffffffffc020cd38 <default_pmm_manager+0x568>
ffffffffc0203ad4:	00008617          	auipc	a2,0x8
ffffffffc0203ad8:	1f460613          	addi	a2,a2,500 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203adc:	29200593          	li	a1,658
ffffffffc0203ae0:	00009517          	auipc	a0,0x9
ffffffffc0203ae4:	e4050513          	addi	a0,a0,-448 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203ae8:	9b7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203aec:	00009697          	auipc	a3,0x9
ffffffffc0203af0:	27c68693          	addi	a3,a3,636 # ffffffffc020cd68 <default_pmm_manager+0x598>
ffffffffc0203af4:	00008617          	auipc	a2,0x8
ffffffffc0203af8:	1d460613          	addi	a2,a2,468 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203afc:	29100593          	li	a1,657
ffffffffc0203b00:	00009517          	auipc	a0,0x9
ffffffffc0203b04:	e2050513          	addi	a0,a0,-480 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203b08:	997fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203b0c <tlb_invalidate>:
ffffffffc0203b0c:	12058073          	sfence.vma	a1
ffffffffc0203b10:	8082                	ret

ffffffffc0203b12 <pgdir_alloc_page>:
ffffffffc0203b12:	7179                	addi	sp,sp,-48
ffffffffc0203b14:	ec26                	sd	s1,24(sp)
ffffffffc0203b16:	e84a                	sd	s2,16(sp)
ffffffffc0203b18:	e052                	sd	s4,0(sp)
ffffffffc0203b1a:	f406                	sd	ra,40(sp)
ffffffffc0203b1c:	f022                	sd	s0,32(sp)
ffffffffc0203b1e:	e44e                	sd	s3,8(sp)
ffffffffc0203b20:	8a2a                	mv	s4,a0
ffffffffc0203b22:	84ae                	mv	s1,a1
ffffffffc0203b24:	8932                	mv	s2,a2
ffffffffc0203b26:	100027f3          	csrr	a5,sstatus
ffffffffc0203b2a:	8b89                	andi	a5,a5,2
ffffffffc0203b2c:	00093997          	auipc	s3,0x93
ffffffffc0203b30:	d8498993          	addi	s3,s3,-636 # ffffffffc02968b0 <pmm_manager>
ffffffffc0203b34:	ef8d                	bnez	a5,ffffffffc0203b6e <pgdir_alloc_page+0x5c>
ffffffffc0203b36:	0009b783          	ld	a5,0(s3)
ffffffffc0203b3a:	4505                	li	a0,1
ffffffffc0203b3c:	6f9c                	ld	a5,24(a5)
ffffffffc0203b3e:	9782                	jalr	a5
ffffffffc0203b40:	842a                	mv	s0,a0
ffffffffc0203b42:	cc09                	beqz	s0,ffffffffc0203b5c <pgdir_alloc_page+0x4a>
ffffffffc0203b44:	86ca                	mv	a3,s2
ffffffffc0203b46:	8626                	mv	a2,s1
ffffffffc0203b48:	85a2                	mv	a1,s0
ffffffffc0203b4a:	8552                	mv	a0,s4
ffffffffc0203b4c:	8d8ff0ef          	jal	ra,ffffffffc0202c24 <page_insert>
ffffffffc0203b50:	e915                	bnez	a0,ffffffffc0203b84 <pgdir_alloc_page+0x72>
ffffffffc0203b52:	4018                	lw	a4,0(s0)
ffffffffc0203b54:	fc04                	sd	s1,56(s0)
ffffffffc0203b56:	4785                	li	a5,1
ffffffffc0203b58:	04f71e63          	bne	a4,a5,ffffffffc0203bb4 <pgdir_alloc_page+0xa2>
ffffffffc0203b5c:	70a2                	ld	ra,40(sp)
ffffffffc0203b5e:	8522                	mv	a0,s0
ffffffffc0203b60:	7402                	ld	s0,32(sp)
ffffffffc0203b62:	64e2                	ld	s1,24(sp)
ffffffffc0203b64:	6942                	ld	s2,16(sp)
ffffffffc0203b66:	69a2                	ld	s3,8(sp)
ffffffffc0203b68:	6a02                	ld	s4,0(sp)
ffffffffc0203b6a:	6145                	addi	sp,sp,48
ffffffffc0203b6c:	8082                	ret
ffffffffc0203b6e:	904fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203b72:	0009b783          	ld	a5,0(s3)
ffffffffc0203b76:	4505                	li	a0,1
ffffffffc0203b78:	6f9c                	ld	a5,24(a5)
ffffffffc0203b7a:	9782                	jalr	a5
ffffffffc0203b7c:	842a                	mv	s0,a0
ffffffffc0203b7e:	8eefd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203b82:	b7c1                	j	ffffffffc0203b42 <pgdir_alloc_page+0x30>
ffffffffc0203b84:	100027f3          	csrr	a5,sstatus
ffffffffc0203b88:	8b89                	andi	a5,a5,2
ffffffffc0203b8a:	eb89                	bnez	a5,ffffffffc0203b9c <pgdir_alloc_page+0x8a>
ffffffffc0203b8c:	0009b783          	ld	a5,0(s3)
ffffffffc0203b90:	8522                	mv	a0,s0
ffffffffc0203b92:	4585                	li	a1,1
ffffffffc0203b94:	739c                	ld	a5,32(a5)
ffffffffc0203b96:	4401                	li	s0,0
ffffffffc0203b98:	9782                	jalr	a5
ffffffffc0203b9a:	b7c9                	j	ffffffffc0203b5c <pgdir_alloc_page+0x4a>
ffffffffc0203b9c:	8d6fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203ba0:	0009b783          	ld	a5,0(s3)
ffffffffc0203ba4:	8522                	mv	a0,s0
ffffffffc0203ba6:	4585                	li	a1,1
ffffffffc0203ba8:	739c                	ld	a5,32(a5)
ffffffffc0203baa:	4401                	li	s0,0
ffffffffc0203bac:	9782                	jalr	a5
ffffffffc0203bae:	8befd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203bb2:	b76d                	j	ffffffffc0203b5c <pgdir_alloc_page+0x4a>
ffffffffc0203bb4:	00009697          	auipc	a3,0x9
ffffffffc0203bb8:	40468693          	addi	a3,a3,1028 # ffffffffc020cfb8 <default_pmm_manager+0x7e8>
ffffffffc0203bbc:	00008617          	auipc	a2,0x8
ffffffffc0203bc0:	10c60613          	addi	a2,a2,268 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203bc4:	25300593          	li	a1,595
ffffffffc0203bc8:	00009517          	auipc	a0,0x9
ffffffffc0203bcc:	d5850513          	addi	a0,a0,-680 # ffffffffc020c920 <default_pmm_manager+0x150>
ffffffffc0203bd0:	8cffc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203bd4 <check_vma_overlap.part.0>:
ffffffffc0203bd4:	1141                	addi	sp,sp,-16
ffffffffc0203bd6:	00009697          	auipc	a3,0x9
ffffffffc0203bda:	3fa68693          	addi	a3,a3,1018 # ffffffffc020cfd0 <default_pmm_manager+0x800>
ffffffffc0203bde:	00008617          	auipc	a2,0x8
ffffffffc0203be2:	0ea60613          	addi	a2,a2,234 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203be6:	13400593          	li	a1,308
ffffffffc0203bea:	00009517          	auipc	a0,0x9
ffffffffc0203bee:	40650513          	addi	a0,a0,1030 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc0203bf2:	e406                	sd	ra,8(sp)
ffffffffc0203bf4:	8abfc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203bf8 <mm_create>:
ffffffffc0203bf8:	1141                	addi	sp,sp,-16
ffffffffc0203bfa:	06800513          	li	a0,104
ffffffffc0203bfe:	e022                	sd	s0,0(sp)
ffffffffc0203c00:	e406                	sd	ra,8(sp)
ffffffffc0203c02:	c10fe0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0203c06:	842a                	mv	s0,a0
ffffffffc0203c08:	c515                	beqz	a0,ffffffffc0203c34 <mm_create+0x3c>
ffffffffc0203c0a:	e408                	sd	a0,8(s0)
ffffffffc0203c0c:	e008                	sd	a0,0(s0)
ffffffffc0203c0e:	00053823          	sd	zero,16(a0)
ffffffffc0203c12:	00053c23          	sd	zero,24(a0)
ffffffffc0203c16:	02052023          	sw	zero,32(a0)
ffffffffc0203c1a:	02053423          	sd	zero,40(a0)
ffffffffc0203c1e:	02052823          	sw	zero,48(a0)
ffffffffc0203c22:	4585                	li	a1,1
ffffffffc0203c24:	03850513          	addi	a0,a0,56
ffffffffc0203c28:	385000ef          	jal	ra,ffffffffc02047ac <sem_init>
ffffffffc0203c2c:	04043c23          	sd	zero,88(s0)
ffffffffc0203c30:	06043023          	sd	zero,96(s0)
ffffffffc0203c34:	60a2                	ld	ra,8(sp)
ffffffffc0203c36:	8522                	mv	a0,s0
ffffffffc0203c38:	6402                	ld	s0,0(sp)
ffffffffc0203c3a:	0141                	addi	sp,sp,16
ffffffffc0203c3c:	8082                	ret

ffffffffc0203c3e <find_vma>:
ffffffffc0203c3e:	86aa                	mv	a3,a0
ffffffffc0203c40:	c505                	beqz	a0,ffffffffc0203c68 <find_vma+0x2a>
ffffffffc0203c42:	6908                	ld	a0,16(a0)
ffffffffc0203c44:	c501                	beqz	a0,ffffffffc0203c4c <find_vma+0xe>
ffffffffc0203c46:	651c                	ld	a5,8(a0)
ffffffffc0203c48:	02f5f263          	bgeu	a1,a5,ffffffffc0203c6c <find_vma+0x2e>
ffffffffc0203c4c:	669c                	ld	a5,8(a3)
ffffffffc0203c4e:	00f68d63          	beq	a3,a5,ffffffffc0203c68 <find_vma+0x2a>
ffffffffc0203c52:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203c56:	00e5e663          	bltu	a1,a4,ffffffffc0203c62 <find_vma+0x24>
ffffffffc0203c5a:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203c5e:	00e5ec63          	bltu	a1,a4,ffffffffc0203c76 <find_vma+0x38>
ffffffffc0203c62:	679c                	ld	a5,8(a5)
ffffffffc0203c64:	fef697e3          	bne	a3,a5,ffffffffc0203c52 <find_vma+0x14>
ffffffffc0203c68:	4501                	li	a0,0
ffffffffc0203c6a:	8082                	ret
ffffffffc0203c6c:	691c                	ld	a5,16(a0)
ffffffffc0203c6e:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203c4c <find_vma+0xe>
ffffffffc0203c72:	ea88                	sd	a0,16(a3)
ffffffffc0203c74:	8082                	ret
ffffffffc0203c76:	fe078513          	addi	a0,a5,-32
ffffffffc0203c7a:	ea88                	sd	a0,16(a3)
ffffffffc0203c7c:	8082                	ret

ffffffffc0203c7e <do_pgfault>:
ffffffffc0203c7e:	7179                	addi	sp,sp,-48
ffffffffc0203c80:	e84a                	sd	s2,16(sp)
ffffffffc0203c82:	892e                	mv	s2,a1
ffffffffc0203c84:	85b2                	mv	a1,a2
ffffffffc0203c86:	f022                	sd	s0,32(sp)
ffffffffc0203c88:	ec26                	sd	s1,24(sp)
ffffffffc0203c8a:	f406                	sd	ra,40(sp)
ffffffffc0203c8c:	e44e                	sd	s3,8(sp)
ffffffffc0203c8e:	e052                	sd	s4,0(sp)
ffffffffc0203c90:	8432                	mv	s0,a2
ffffffffc0203c92:	84aa                	mv	s1,a0
ffffffffc0203c94:	fabff0ef          	jal	ra,ffffffffc0203c3e <find_vma>
ffffffffc0203c98:	00093797          	auipc	a5,0x93
ffffffffc0203c9c:	c307a783          	lw	a5,-976(a5) # ffffffffc02968c8 <pgfault_num>
ffffffffc0203ca0:	2785                	addiw	a5,a5,1
ffffffffc0203ca2:	00093717          	auipc	a4,0x93
ffffffffc0203ca6:	c2f72323          	sw	a5,-986(a4) # ffffffffc02968c8 <pgfault_num>
ffffffffc0203caa:	1c050563          	beqz	a0,ffffffffc0203e74 <do_pgfault+0x1f6>
ffffffffc0203cae:	651c                	ld	a5,8(a0)
ffffffffc0203cb0:	1cf46263          	bltu	s0,a5,ffffffffc0203e74 <do_pgfault+0x1f6>
ffffffffc0203cb4:	00397793          	andi	a5,s2,3
ffffffffc0203cb8:	cff9                	beqz	a5,ffffffffc0203d96 <do_pgfault+0x118>
ffffffffc0203cba:	4705                	li	a4,1
ffffffffc0203cbc:	0ae78063          	beq	a5,a4,ffffffffc0203d5c <do_pgfault+0xde>
ffffffffc0203cc0:	4d1c                	lw	a5,24(a0)
ffffffffc0203cc2:	8b89                	andi	a5,a5,2
ffffffffc0203cc4:	1c078163          	beqz	a5,ffffffffc0203e86 <do_pgfault+0x208>
ffffffffc0203cc8:	79fd                	lui	s3,0xfffff
ffffffffc0203cca:	00093597          	auipc	a1,0x93
ffffffffc0203cce:	bf65b583          	ld	a1,-1034(a1) # ffffffffc02968c0 <backing_page_global>
ffffffffc0203cd2:	013479b3          	and	s3,s0,s3
ffffffffc0203cd6:	c581                	beqz	a1,ffffffffc0203cde <do_pgfault+0x60>
ffffffffc0203cd8:	c099                	beqz	s1,ffffffffc0203cde <do_pgfault+0x60>
ffffffffc0203cda:	6cbc                	ld	a5,88(s1)
ffffffffc0203cdc:	ebe1                	bnez	a5,ffffffffc0203dac <do_pgfault+0x12e>
ffffffffc0203cde:	4d18                	lw	a4,24(a0)
ffffffffc0203ce0:	4a41                	li	s4,16
ffffffffc0203ce2:	00177793          	andi	a5,a4,1
ffffffffc0203ce6:	c391                	beqz	a5,ffffffffc0203cea <do_pgfault+0x6c>
ffffffffc0203ce8:	4a49                	li	s4,18
ffffffffc0203cea:	00277793          	andi	a5,a4,2
ffffffffc0203cee:	c391                	beqz	a5,ffffffffc0203cf2 <do_pgfault+0x74>
ffffffffc0203cf0:	4a59                	li	s4,22
ffffffffc0203cf2:	8b11                	andi	a4,a4,4
ffffffffc0203cf4:	c319                	beqz	a4,ffffffffc0203cfa <do_pgfault+0x7c>
ffffffffc0203cf6:	008a6a13          	ori	s4,s4,8
ffffffffc0203cfa:	6c88                	ld	a0,24(s1)
ffffffffc0203cfc:	4605                	li	a2,1
ffffffffc0203cfe:	85ce                	mv	a1,s3
ffffffffc0203d00:	da8fe0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc0203d04:	842a                	mv	s0,a0
ffffffffc0203d06:	18050863          	beqz	a0,ffffffffc0203e96 <do_pgfault+0x218>
ffffffffc0203d0a:	611c                	ld	a5,0(a0)
ffffffffc0203d0c:	c7bd                	beqz	a5,ffffffffc0203d7a <do_pgfault+0xfc>
ffffffffc0203d0e:	0017f713          	andi	a4,a5,1
ffffffffc0203d12:	c725                	beqz	a4,ffffffffc0203d7a <do_pgfault+0xfc>
ffffffffc0203d14:	2007f713          	andi	a4,a5,512
ffffffffc0203d18:	c709                	beqz	a4,ffffffffc0203d22 <do_pgfault+0xa4>
ffffffffc0203d1a:	00297913          	andi	s2,s2,2
ffffffffc0203d1e:	0a091f63          	bnez	s2,ffffffffc0203ddc <do_pgfault+0x15e>
ffffffffc0203d22:	4705                	li	a4,1
ffffffffc0203d24:	078a                	slli	a5,a5,0x2
ffffffffc0203d26:	172a                	slli	a4,a4,0x2a
ffffffffc0203d28:	8389                	srli	a5,a5,0x2
ffffffffc0203d2a:	c0070713          	addi	a4,a4,-1024
ffffffffc0203d2e:	8ff9                	and	a5,a5,a4
ffffffffc0203d30:	001a6a13          	ori	s4,s4,1
ffffffffc0203d34:	0147e7b3          	or	a5,a5,s4
ffffffffc0203d38:	1782                	slli	a5,a5,0x20
ffffffffc0203d3a:	6c88                	ld	a0,24(s1)
ffffffffc0203d3c:	9381                	srli	a5,a5,0x20
ffffffffc0203d3e:	0017e793          	ori	a5,a5,1
ffffffffc0203d42:	e01c                	sd	a5,0(s0)
ffffffffc0203d44:	85ce                	mv	a1,s3
ffffffffc0203d46:	dc7ff0ef          	jal	ra,ffffffffc0203b0c <tlb_invalidate>
ffffffffc0203d4a:	70a2                	ld	ra,40(sp)
ffffffffc0203d4c:	7402                	ld	s0,32(sp)
ffffffffc0203d4e:	64e2                	ld	s1,24(sp)
ffffffffc0203d50:	6942                	ld	s2,16(sp)
ffffffffc0203d52:	69a2                	ld	s3,8(sp)
ffffffffc0203d54:	6a02                	ld	s4,0(sp)
ffffffffc0203d56:	4501                	li	a0,0
ffffffffc0203d58:	6145                	addi	sp,sp,48
ffffffffc0203d5a:	8082                	ret
ffffffffc0203d5c:	00009517          	auipc	a0,0x9
ffffffffc0203d60:	33450513          	addi	a0,a0,820 # ffffffffc020d090 <default_pmm_manager+0x8c0>
ffffffffc0203d64:	c42fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203d68:	5575                	li	a0,-3
ffffffffc0203d6a:	70a2                	ld	ra,40(sp)
ffffffffc0203d6c:	7402                	ld	s0,32(sp)
ffffffffc0203d6e:	64e2                	ld	s1,24(sp)
ffffffffc0203d70:	6942                	ld	s2,16(sp)
ffffffffc0203d72:	69a2                	ld	s3,8(sp)
ffffffffc0203d74:	6a02                	ld	s4,0(sp)
ffffffffc0203d76:	6145                	addi	sp,sp,48
ffffffffc0203d78:	8082                	ret
ffffffffc0203d7a:	6c88                	ld	a0,24(s1)
ffffffffc0203d7c:	8652                	mv	a2,s4
ffffffffc0203d7e:	85ce                	mv	a1,s3
ffffffffc0203d80:	d93ff0ef          	jal	ra,ffffffffc0203b12 <pgdir_alloc_page>
ffffffffc0203d84:	f179                	bnez	a0,ffffffffc0203d4a <do_pgfault+0xcc>
ffffffffc0203d86:	00009517          	auipc	a0,0x9
ffffffffc0203d8a:	3e250513          	addi	a0,a0,994 # ffffffffc020d168 <default_pmm_manager+0x998>
ffffffffc0203d8e:	c18fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203d92:	5575                	li	a0,-3
ffffffffc0203d94:	bfd9                	j	ffffffffc0203d6a <do_pgfault+0xec>
ffffffffc0203d96:	4d1c                	lw	a5,24(a0)
ffffffffc0203d98:	8b95                	andi	a5,a5,5
ffffffffc0203d9a:	f79d                	bnez	a5,ffffffffc0203cc8 <do_pgfault+0x4a>
ffffffffc0203d9c:	00009517          	auipc	a0,0x9
ffffffffc0203da0:	32c50513          	addi	a0,a0,812 # ffffffffc020d0c8 <default_pmm_manager+0x8f8>
ffffffffc0203da4:	c02fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203da8:	5575                	li	a0,-3
ffffffffc0203daa:	b7c1                	j	ffffffffc0203d6a <do_pgfault+0xec>
ffffffffc0203dac:	f2f469e3          	bltu	s0,a5,ffffffffc0203cde <do_pgfault+0x60>
ffffffffc0203db0:	70bc                	ld	a5,96(s1)
ffffffffc0203db2:	f2f476e3          	bgeu	s0,a5,ffffffffc0203cde <do_pgfault+0x60>
ffffffffc0203db6:	00297913          	andi	s2,s2,2
ffffffffc0203dba:	46c9                	li	a3,18
ffffffffc0203dbc:	00090363          	beqz	s2,ffffffffc0203dc2 <do_pgfault+0x144>
ffffffffc0203dc0:	46d9                	li	a3,22
ffffffffc0203dc2:	6c88                	ld	a0,24(s1)
ffffffffc0203dc4:	864e                	mv	a2,s3
ffffffffc0203dc6:	e5ffe0ef          	jal	ra,ffffffffc0202c24 <page_insert>
ffffffffc0203dca:	d141                	beqz	a0,ffffffffc0203d4a <do_pgfault+0xcc>
ffffffffc0203dcc:	00009517          	auipc	a0,0x9
ffffffffc0203dd0:	36450513          	addi	a0,a0,868 # ffffffffc020d130 <default_pmm_manager+0x960>
ffffffffc0203dd4:	bd2fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203dd8:	5575                	li	a0,-3
ffffffffc0203dda:	bf41                	j	ffffffffc0203d6a <do_pgfault+0xec>
ffffffffc0203ddc:	4505                	li	a0,1
ffffffffc0203dde:	c12fe0ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc0203de2:	892a                	mv	s2,a0
ffffffffc0203de4:	c169                	beqz	a0,ffffffffc0203ea6 <do_pgfault+0x228>
ffffffffc0203de6:	601c                	ld	a5,0(s0)
ffffffffc0203de8:	0017f713          	andi	a4,a5,1
ffffffffc0203dec:	0e070263          	beqz	a4,ffffffffc0203ed0 <do_pgfault+0x252>
ffffffffc0203df0:	078a                	slli	a5,a5,0x2
ffffffffc0203df2:	83b1                	srli	a5,a5,0xc
ffffffffc0203df4:	00093617          	auipc	a2,0x93
ffffffffc0203df8:	aac63603          	ld	a2,-1364(a2) # ffffffffc02968a0 <npage>
ffffffffc0203dfc:	0ec7f663          	bgeu	a5,a2,ffffffffc0203ee8 <do_pgfault+0x26a>
ffffffffc0203e00:	0000c517          	auipc	a0,0xc
ffffffffc0203e04:	f3053503          	ld	a0,-208(a0) # ffffffffc020fd30 <nbase>
ffffffffc0203e08:	40a786b3          	sub	a3,a5,a0
ffffffffc0203e0c:	069a                	slli	a3,a3,0x6
ffffffffc0203e0e:	8699                	srai	a3,a3,0x6
ffffffffc0203e10:	577d                	li	a4,-1
ffffffffc0203e12:	96aa                	add	a3,a3,a0
ffffffffc0203e14:	8331                	srli	a4,a4,0xc
ffffffffc0203e16:	00e6f5b3          	and	a1,a3,a4
ffffffffc0203e1a:	00093797          	auipc	a5,0x93
ffffffffc0203e1e:	a8e7b783          	ld	a5,-1394(a5) # ffffffffc02968a8 <pages>
ffffffffc0203e22:	06b2                	slli	a3,a3,0xc
ffffffffc0203e24:	08c5fa63          	bgeu	a1,a2,ffffffffc0203eb8 <do_pgfault+0x23a>
ffffffffc0203e28:	40f907b3          	sub	a5,s2,a5
ffffffffc0203e2c:	8799                	srai	a5,a5,0x6
ffffffffc0203e2e:	97aa                	add	a5,a5,a0
ffffffffc0203e30:	8f7d                	and	a4,a4,a5
ffffffffc0203e32:	00093517          	auipc	a0,0x93
ffffffffc0203e36:	a8653503          	ld	a0,-1402(a0) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0203e3a:	00a685b3          	add	a1,a3,a0
ffffffffc0203e3e:	07b2                	slli	a5,a5,0xc
ffffffffc0203e40:	06c77b63          	bgeu	a4,a2,ffffffffc0203eb6 <do_pgfault+0x238>
ffffffffc0203e44:	6605                	lui	a2,0x1
ffffffffc0203e46:	953e                	add	a0,a0,a5
ffffffffc0203e48:	1f1070ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc0203e4c:	6c88                	ld	a0,24(s1)
ffffffffc0203e4e:	86d2                	mv	a3,s4
ffffffffc0203e50:	864e                	mv	a2,s3
ffffffffc0203e52:	85ca                	mv	a1,s2
ffffffffc0203e54:	dd1fe0ef          	jal	ra,ffffffffc0202c24 <page_insert>
ffffffffc0203e58:	ee0509e3          	beqz	a0,ffffffffc0203d4a <do_pgfault+0xcc>
ffffffffc0203e5c:	4585                	li	a1,1
ffffffffc0203e5e:	854a                	mv	a0,s2
ffffffffc0203e60:	bcefe0ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc0203e64:	00009517          	auipc	a0,0x9
ffffffffc0203e68:	36450513          	addi	a0,a0,868 # ffffffffc020d1c8 <default_pmm_manager+0x9f8>
ffffffffc0203e6c:	b3afc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203e70:	5575                	li	a0,-3
ffffffffc0203e72:	bde5                	j	ffffffffc0203d6a <do_pgfault+0xec>
ffffffffc0203e74:	85a2                	mv	a1,s0
ffffffffc0203e76:	00009517          	auipc	a0,0x9
ffffffffc0203e7a:	18a50513          	addi	a0,a0,394 # ffffffffc020d000 <default_pmm_manager+0x830>
ffffffffc0203e7e:	b28fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203e82:	5575                	li	a0,-3
ffffffffc0203e84:	b5dd                	j	ffffffffc0203d6a <do_pgfault+0xec>
ffffffffc0203e86:	00009517          	auipc	a0,0x9
ffffffffc0203e8a:	1aa50513          	addi	a0,a0,426 # ffffffffc020d030 <default_pmm_manager+0x860>
ffffffffc0203e8e:	b18fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203e92:	5575                	li	a0,-3
ffffffffc0203e94:	bdd9                	j	ffffffffc0203d6a <do_pgfault+0xec>
ffffffffc0203e96:	00009517          	auipc	a0,0x9
ffffffffc0203e9a:	2b250513          	addi	a0,a0,690 # ffffffffc020d148 <default_pmm_manager+0x978>
ffffffffc0203e9e:	b08fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203ea2:	5575                	li	a0,-3
ffffffffc0203ea4:	b5d9                	j	ffffffffc0203d6a <do_pgfault+0xec>
ffffffffc0203ea6:	00009517          	auipc	a0,0x9
ffffffffc0203eaa:	2ea50513          	addi	a0,a0,746 # ffffffffc020d190 <default_pmm_manager+0x9c0>
ffffffffc0203eae:	af8fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203eb2:	5575                	li	a0,-3
ffffffffc0203eb4:	bd5d                	j	ffffffffc0203d6a <do_pgfault+0xec>
ffffffffc0203eb6:	86be                	mv	a3,a5
ffffffffc0203eb8:	00009617          	auipc	a2,0x9
ffffffffc0203ebc:	95060613          	addi	a2,a2,-1712 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc0203ec0:	07100593          	li	a1,113
ffffffffc0203ec4:	00009517          	auipc	a0,0x9
ffffffffc0203ec8:	96c50513          	addi	a0,a0,-1684 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0203ecc:	dd2fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203ed0:	00009617          	auipc	a2,0x9
ffffffffc0203ed4:	a2860613          	addi	a2,a2,-1496 # ffffffffc020c8f8 <default_pmm_manager+0x128>
ffffffffc0203ed8:	07f00593          	li	a1,127
ffffffffc0203edc:	00009517          	auipc	a0,0x9
ffffffffc0203ee0:	95450513          	addi	a0,a0,-1708 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0203ee4:	dbafc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203ee8:	00009617          	auipc	a2,0x9
ffffffffc0203eec:	9f060613          	addi	a2,a2,-1552 # ffffffffc020c8d8 <default_pmm_manager+0x108>
ffffffffc0203ef0:	06900593          	li	a1,105
ffffffffc0203ef4:	00009517          	auipc	a0,0x9
ffffffffc0203ef8:	93c50513          	addi	a0,a0,-1732 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0203efc:	da2fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203f00 <insert_vma_struct>:
ffffffffc0203f00:	6590                	ld	a2,8(a1)
ffffffffc0203f02:	0105b803          	ld	a6,16(a1)
ffffffffc0203f06:	1141                	addi	sp,sp,-16
ffffffffc0203f08:	e406                	sd	ra,8(sp)
ffffffffc0203f0a:	87aa                	mv	a5,a0
ffffffffc0203f0c:	01066763          	bltu	a2,a6,ffffffffc0203f1a <insert_vma_struct+0x1a>
ffffffffc0203f10:	a085                	j	ffffffffc0203f70 <insert_vma_struct+0x70>
ffffffffc0203f12:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203f16:	04e66863          	bltu	a2,a4,ffffffffc0203f66 <insert_vma_struct+0x66>
ffffffffc0203f1a:	86be                	mv	a3,a5
ffffffffc0203f1c:	679c                	ld	a5,8(a5)
ffffffffc0203f1e:	fef51ae3          	bne	a0,a5,ffffffffc0203f12 <insert_vma_struct+0x12>
ffffffffc0203f22:	02a68463          	beq	a3,a0,ffffffffc0203f4a <insert_vma_struct+0x4a>
ffffffffc0203f26:	ff06b703          	ld	a4,-16(a3)
ffffffffc0203f2a:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203f2e:	08e8f163          	bgeu	a7,a4,ffffffffc0203fb0 <insert_vma_struct+0xb0>
ffffffffc0203f32:	04e66f63          	bltu	a2,a4,ffffffffc0203f90 <insert_vma_struct+0x90>
ffffffffc0203f36:	00f50a63          	beq	a0,a5,ffffffffc0203f4a <insert_vma_struct+0x4a>
ffffffffc0203f3a:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203f3e:	05076963          	bltu	a4,a6,ffffffffc0203f90 <insert_vma_struct+0x90>
ffffffffc0203f42:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203f46:	02c77363          	bgeu	a4,a2,ffffffffc0203f6c <insert_vma_struct+0x6c>
ffffffffc0203f4a:	5118                	lw	a4,32(a0)
ffffffffc0203f4c:	e188                	sd	a0,0(a1)
ffffffffc0203f4e:	02058613          	addi	a2,a1,32
ffffffffc0203f52:	e390                	sd	a2,0(a5)
ffffffffc0203f54:	e690                	sd	a2,8(a3)
ffffffffc0203f56:	60a2                	ld	ra,8(sp)
ffffffffc0203f58:	f59c                	sd	a5,40(a1)
ffffffffc0203f5a:	f194                	sd	a3,32(a1)
ffffffffc0203f5c:	0017079b          	addiw	a5,a4,1
ffffffffc0203f60:	d11c                	sw	a5,32(a0)
ffffffffc0203f62:	0141                	addi	sp,sp,16
ffffffffc0203f64:	8082                	ret
ffffffffc0203f66:	fca690e3          	bne	a3,a0,ffffffffc0203f26 <insert_vma_struct+0x26>
ffffffffc0203f6a:	bfd1                	j	ffffffffc0203f3e <insert_vma_struct+0x3e>
ffffffffc0203f6c:	c69ff0ef          	jal	ra,ffffffffc0203bd4 <check_vma_overlap.part.0>
ffffffffc0203f70:	00009697          	auipc	a3,0x9
ffffffffc0203f74:	28868693          	addi	a3,a3,648 # ffffffffc020d1f8 <default_pmm_manager+0xa28>
ffffffffc0203f78:	00008617          	auipc	a2,0x8
ffffffffc0203f7c:	d5060613          	addi	a2,a2,-688 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203f80:	13a00593          	li	a1,314
ffffffffc0203f84:	00009517          	auipc	a0,0x9
ffffffffc0203f88:	06c50513          	addi	a0,a0,108 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc0203f8c:	d12fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203f90:	00009697          	auipc	a3,0x9
ffffffffc0203f94:	2a868693          	addi	a3,a3,680 # ffffffffc020d238 <default_pmm_manager+0xa68>
ffffffffc0203f98:	00008617          	auipc	a2,0x8
ffffffffc0203f9c:	d3060613          	addi	a2,a2,-720 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203fa0:	13300593          	li	a1,307
ffffffffc0203fa4:	00009517          	auipc	a0,0x9
ffffffffc0203fa8:	04c50513          	addi	a0,a0,76 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc0203fac:	cf2fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203fb0:	00009697          	auipc	a3,0x9
ffffffffc0203fb4:	26868693          	addi	a3,a3,616 # ffffffffc020d218 <default_pmm_manager+0xa48>
ffffffffc0203fb8:	00008617          	auipc	a2,0x8
ffffffffc0203fbc:	d1060613          	addi	a2,a2,-752 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0203fc0:	13200593          	li	a1,306
ffffffffc0203fc4:	00009517          	auipc	a0,0x9
ffffffffc0203fc8:	02c50513          	addi	a0,a0,44 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc0203fcc:	cd2fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203fd0 <mm_destroy>:
ffffffffc0203fd0:	591c                	lw	a5,48(a0)
ffffffffc0203fd2:	1141                	addi	sp,sp,-16
ffffffffc0203fd4:	e406                	sd	ra,8(sp)
ffffffffc0203fd6:	e022                	sd	s0,0(sp)
ffffffffc0203fd8:	e78d                	bnez	a5,ffffffffc0204002 <mm_destroy+0x32>
ffffffffc0203fda:	842a                	mv	s0,a0
ffffffffc0203fdc:	6508                	ld	a0,8(a0)
ffffffffc0203fde:	00a40c63          	beq	s0,a0,ffffffffc0203ff6 <mm_destroy+0x26>
ffffffffc0203fe2:	6118                	ld	a4,0(a0)
ffffffffc0203fe4:	651c                	ld	a5,8(a0)
ffffffffc0203fe6:	1501                	addi	a0,a0,-32
ffffffffc0203fe8:	e71c                	sd	a5,8(a4)
ffffffffc0203fea:	e398                	sd	a4,0(a5)
ffffffffc0203fec:	8d6fe0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0203ff0:	6408                	ld	a0,8(s0)
ffffffffc0203ff2:	fea418e3          	bne	s0,a0,ffffffffc0203fe2 <mm_destroy+0x12>
ffffffffc0203ff6:	8522                	mv	a0,s0
ffffffffc0203ff8:	6402                	ld	s0,0(sp)
ffffffffc0203ffa:	60a2                	ld	ra,8(sp)
ffffffffc0203ffc:	0141                	addi	sp,sp,16
ffffffffc0203ffe:	8c4fe06f          	j	ffffffffc02020c2 <kfree>
ffffffffc0204002:	00009697          	auipc	a3,0x9
ffffffffc0204006:	25668693          	addi	a3,a3,598 # ffffffffc020d258 <default_pmm_manager+0xa88>
ffffffffc020400a:	00008617          	auipc	a2,0x8
ffffffffc020400e:	cbe60613          	addi	a2,a2,-834 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204012:	15e00593          	li	a1,350
ffffffffc0204016:	00009517          	auipc	a0,0x9
ffffffffc020401a:	fda50513          	addi	a0,a0,-38 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc020401e:	c80fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204022 <mm_map>:
ffffffffc0204022:	7139                	addi	sp,sp,-64
ffffffffc0204024:	f822                	sd	s0,48(sp)
ffffffffc0204026:	6405                	lui	s0,0x1
ffffffffc0204028:	147d                	addi	s0,s0,-1
ffffffffc020402a:	77fd                	lui	a5,0xfffff
ffffffffc020402c:	9622                	add	a2,a2,s0
ffffffffc020402e:	962e                	add	a2,a2,a1
ffffffffc0204030:	f426                	sd	s1,40(sp)
ffffffffc0204032:	fc06                	sd	ra,56(sp)
ffffffffc0204034:	00f5f4b3          	and	s1,a1,a5
ffffffffc0204038:	f04a                	sd	s2,32(sp)
ffffffffc020403a:	ec4e                	sd	s3,24(sp)
ffffffffc020403c:	e852                	sd	s4,16(sp)
ffffffffc020403e:	e456                	sd	s5,8(sp)
ffffffffc0204040:	002005b7          	lui	a1,0x200
ffffffffc0204044:	00f67433          	and	s0,a2,a5
ffffffffc0204048:	06b4e363          	bltu	s1,a1,ffffffffc02040ae <mm_map+0x8c>
ffffffffc020404c:	0684f163          	bgeu	s1,s0,ffffffffc02040ae <mm_map+0x8c>
ffffffffc0204050:	4785                	li	a5,1
ffffffffc0204052:	07fe                	slli	a5,a5,0x1f
ffffffffc0204054:	0487ed63          	bltu	a5,s0,ffffffffc02040ae <mm_map+0x8c>
ffffffffc0204058:	89aa                	mv	s3,a0
ffffffffc020405a:	cd21                	beqz	a0,ffffffffc02040b2 <mm_map+0x90>
ffffffffc020405c:	85a6                	mv	a1,s1
ffffffffc020405e:	8ab6                	mv	s5,a3
ffffffffc0204060:	8a3a                	mv	s4,a4
ffffffffc0204062:	bddff0ef          	jal	ra,ffffffffc0203c3e <find_vma>
ffffffffc0204066:	c501                	beqz	a0,ffffffffc020406e <mm_map+0x4c>
ffffffffc0204068:	651c                	ld	a5,8(a0)
ffffffffc020406a:	0487e263          	bltu	a5,s0,ffffffffc02040ae <mm_map+0x8c>
ffffffffc020406e:	03000513          	li	a0,48
ffffffffc0204072:	fa1fd0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0204076:	892a                	mv	s2,a0
ffffffffc0204078:	5571                	li	a0,-4
ffffffffc020407a:	02090163          	beqz	s2,ffffffffc020409c <mm_map+0x7a>
ffffffffc020407e:	854e                	mv	a0,s3
ffffffffc0204080:	00993423          	sd	s1,8(s2)
ffffffffc0204084:	00893823          	sd	s0,16(s2)
ffffffffc0204088:	01592c23          	sw	s5,24(s2)
ffffffffc020408c:	85ca                	mv	a1,s2
ffffffffc020408e:	e73ff0ef          	jal	ra,ffffffffc0203f00 <insert_vma_struct>
ffffffffc0204092:	4501                	li	a0,0
ffffffffc0204094:	000a0463          	beqz	s4,ffffffffc020409c <mm_map+0x7a>
ffffffffc0204098:	012a3023          	sd	s2,0(s4)
ffffffffc020409c:	70e2                	ld	ra,56(sp)
ffffffffc020409e:	7442                	ld	s0,48(sp)
ffffffffc02040a0:	74a2                	ld	s1,40(sp)
ffffffffc02040a2:	7902                	ld	s2,32(sp)
ffffffffc02040a4:	69e2                	ld	s3,24(sp)
ffffffffc02040a6:	6a42                	ld	s4,16(sp)
ffffffffc02040a8:	6aa2                	ld	s5,8(sp)
ffffffffc02040aa:	6121                	addi	sp,sp,64
ffffffffc02040ac:	8082                	ret
ffffffffc02040ae:	5575                	li	a0,-3
ffffffffc02040b0:	b7f5                	j	ffffffffc020409c <mm_map+0x7a>
ffffffffc02040b2:	00009697          	auipc	a3,0x9
ffffffffc02040b6:	1be68693          	addi	a3,a3,446 # ffffffffc020d270 <default_pmm_manager+0xaa0>
ffffffffc02040ba:	00008617          	auipc	a2,0x8
ffffffffc02040be:	c0e60613          	addi	a2,a2,-1010 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02040c2:	17300593          	li	a1,371
ffffffffc02040c6:	00009517          	auipc	a0,0x9
ffffffffc02040ca:	f2a50513          	addi	a0,a0,-214 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc02040ce:	bd0fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02040d2 <dup_mmap>:
ffffffffc02040d2:	7139                	addi	sp,sp,-64
ffffffffc02040d4:	fc06                	sd	ra,56(sp)
ffffffffc02040d6:	f822                	sd	s0,48(sp)
ffffffffc02040d8:	f426                	sd	s1,40(sp)
ffffffffc02040da:	f04a                	sd	s2,32(sp)
ffffffffc02040dc:	ec4e                	sd	s3,24(sp)
ffffffffc02040de:	e852                	sd	s4,16(sp)
ffffffffc02040e0:	e456                	sd	s5,8(sp)
ffffffffc02040e2:	c52d                	beqz	a0,ffffffffc020414c <dup_mmap+0x7a>
ffffffffc02040e4:	892a                	mv	s2,a0
ffffffffc02040e6:	84ae                	mv	s1,a1
ffffffffc02040e8:	842e                	mv	s0,a1
ffffffffc02040ea:	e595                	bnez	a1,ffffffffc0204116 <dup_mmap+0x44>
ffffffffc02040ec:	a085                	j	ffffffffc020414c <dup_mmap+0x7a>
ffffffffc02040ee:	854a                	mv	a0,s2
ffffffffc02040f0:	0155b423          	sd	s5,8(a1) # 200008 <_binary_bin_sfs_img_size+0x18ad08>
ffffffffc02040f4:	0145b823          	sd	s4,16(a1)
ffffffffc02040f8:	0135ac23          	sw	s3,24(a1)
ffffffffc02040fc:	e05ff0ef          	jal	ra,ffffffffc0203f00 <insert_vma_struct>
ffffffffc0204100:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_bin_swap_img_size-0x6d10>
ffffffffc0204104:	fe843603          	ld	a2,-24(s0)
ffffffffc0204108:	6c8c                	ld	a1,24(s1)
ffffffffc020410a:	01893503          	ld	a0,24(s2)
ffffffffc020410e:	4701                	li	a4,0
ffffffffc0204110:	8b3fe0ef          	jal	ra,ffffffffc02029c2 <copy_range>
ffffffffc0204114:	e105                	bnez	a0,ffffffffc0204134 <dup_mmap+0x62>
ffffffffc0204116:	6000                	ld	s0,0(s0)
ffffffffc0204118:	02848863          	beq	s1,s0,ffffffffc0204148 <dup_mmap+0x76>
ffffffffc020411c:	03000513          	li	a0,48
ffffffffc0204120:	fe843a83          	ld	s5,-24(s0)
ffffffffc0204124:	ff043a03          	ld	s4,-16(s0)
ffffffffc0204128:	ff842983          	lw	s3,-8(s0)
ffffffffc020412c:	ee7fd0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0204130:	85aa                	mv	a1,a0
ffffffffc0204132:	fd55                	bnez	a0,ffffffffc02040ee <dup_mmap+0x1c>
ffffffffc0204134:	5571                	li	a0,-4
ffffffffc0204136:	70e2                	ld	ra,56(sp)
ffffffffc0204138:	7442                	ld	s0,48(sp)
ffffffffc020413a:	74a2                	ld	s1,40(sp)
ffffffffc020413c:	7902                	ld	s2,32(sp)
ffffffffc020413e:	69e2                	ld	s3,24(sp)
ffffffffc0204140:	6a42                	ld	s4,16(sp)
ffffffffc0204142:	6aa2                	ld	s5,8(sp)
ffffffffc0204144:	6121                	addi	sp,sp,64
ffffffffc0204146:	8082                	ret
ffffffffc0204148:	4501                	li	a0,0
ffffffffc020414a:	b7f5                	j	ffffffffc0204136 <dup_mmap+0x64>
ffffffffc020414c:	00009697          	auipc	a3,0x9
ffffffffc0204150:	13468693          	addi	a3,a3,308 # ffffffffc020d280 <default_pmm_manager+0xab0>
ffffffffc0204154:	00008617          	auipc	a2,0x8
ffffffffc0204158:	b7460613          	addi	a2,a2,-1164 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020415c:	18f00593          	li	a1,399
ffffffffc0204160:	00009517          	auipc	a0,0x9
ffffffffc0204164:	e9050513          	addi	a0,a0,-368 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc0204168:	b36fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020416c <exit_mmap>:
ffffffffc020416c:	1101                	addi	sp,sp,-32
ffffffffc020416e:	ec06                	sd	ra,24(sp)
ffffffffc0204170:	e822                	sd	s0,16(sp)
ffffffffc0204172:	e426                	sd	s1,8(sp)
ffffffffc0204174:	e04a                	sd	s2,0(sp)
ffffffffc0204176:	c531                	beqz	a0,ffffffffc02041c2 <exit_mmap+0x56>
ffffffffc0204178:	591c                	lw	a5,48(a0)
ffffffffc020417a:	84aa                	mv	s1,a0
ffffffffc020417c:	e3b9                	bnez	a5,ffffffffc02041c2 <exit_mmap+0x56>
ffffffffc020417e:	6500                	ld	s0,8(a0)
ffffffffc0204180:	01853903          	ld	s2,24(a0)
ffffffffc0204184:	02850663          	beq	a0,s0,ffffffffc02041b0 <exit_mmap+0x44>
ffffffffc0204188:	ff043603          	ld	a2,-16(s0)
ffffffffc020418c:	fe843583          	ld	a1,-24(s0)
ffffffffc0204190:	854a                	mv	a0,s2
ffffffffc0204192:	c58fe0ef          	jal	ra,ffffffffc02025ea <unmap_range>
ffffffffc0204196:	6400                	ld	s0,8(s0)
ffffffffc0204198:	fe8498e3          	bne	s1,s0,ffffffffc0204188 <exit_mmap+0x1c>
ffffffffc020419c:	6400                	ld	s0,8(s0)
ffffffffc020419e:	00848c63          	beq	s1,s0,ffffffffc02041b6 <exit_mmap+0x4a>
ffffffffc02041a2:	ff043603          	ld	a2,-16(s0)
ffffffffc02041a6:	fe843583          	ld	a1,-24(s0)
ffffffffc02041aa:	854a                	mv	a0,s2
ffffffffc02041ac:	d84fe0ef          	jal	ra,ffffffffc0202730 <exit_range>
ffffffffc02041b0:	6400                	ld	s0,8(s0)
ffffffffc02041b2:	fe8498e3          	bne	s1,s0,ffffffffc02041a2 <exit_mmap+0x36>
ffffffffc02041b6:	60e2                	ld	ra,24(sp)
ffffffffc02041b8:	6442                	ld	s0,16(sp)
ffffffffc02041ba:	64a2                	ld	s1,8(sp)
ffffffffc02041bc:	6902                	ld	s2,0(sp)
ffffffffc02041be:	6105                	addi	sp,sp,32
ffffffffc02041c0:	8082                	ret
ffffffffc02041c2:	00009697          	auipc	a3,0x9
ffffffffc02041c6:	0de68693          	addi	a3,a3,222 # ffffffffc020d2a0 <default_pmm_manager+0xad0>
ffffffffc02041ca:	00008617          	auipc	a2,0x8
ffffffffc02041ce:	afe60613          	addi	a2,a2,-1282 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02041d2:	1a800593          	li	a1,424
ffffffffc02041d6:	00009517          	auipc	a0,0x9
ffffffffc02041da:	e1a50513          	addi	a0,a0,-486 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc02041de:	ac0fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02041e2 <vmm_init>:
ffffffffc02041e2:	7139                	addi	sp,sp,-64
ffffffffc02041e4:	f822                	sd	s0,48(sp)
ffffffffc02041e6:	f426                	sd	s1,40(sp)
ffffffffc02041e8:	fc06                	sd	ra,56(sp)
ffffffffc02041ea:	f04a                	sd	s2,32(sp)
ffffffffc02041ec:	ec4e                	sd	s3,24(sp)
ffffffffc02041ee:	e852                	sd	s4,16(sp)
ffffffffc02041f0:	e456                	sd	s5,8(sp)
ffffffffc02041f2:	a07ff0ef          	jal	ra,ffffffffc0203bf8 <mm_create>
ffffffffc02041f6:	84aa                	mv	s1,a0
ffffffffc02041f8:	03200413          	li	s0,50
ffffffffc02041fc:	e919                	bnez	a0,ffffffffc0204212 <vmm_init+0x30>
ffffffffc02041fe:	a4d9                	j	ffffffffc02044c4 <vmm_init+0x2e2>
ffffffffc0204200:	e500                	sd	s0,8(a0)
ffffffffc0204202:	e91c                	sd	a5,16(a0)
ffffffffc0204204:	00052c23          	sw	zero,24(a0)
ffffffffc0204208:	146d                	addi	s0,s0,-5
ffffffffc020420a:	8526                	mv	a0,s1
ffffffffc020420c:	cf5ff0ef          	jal	ra,ffffffffc0203f00 <insert_vma_struct>
ffffffffc0204210:	c80d                	beqz	s0,ffffffffc0204242 <vmm_init+0x60>
ffffffffc0204212:	03000513          	li	a0,48
ffffffffc0204216:	dfdfd0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc020421a:	85aa                	mv	a1,a0
ffffffffc020421c:	00240793          	addi	a5,s0,2
ffffffffc0204220:	f165                	bnez	a0,ffffffffc0204200 <vmm_init+0x1e>
ffffffffc0204222:	00009697          	auipc	a3,0x9
ffffffffc0204226:	21668693          	addi	a3,a3,534 # ffffffffc020d438 <default_pmm_manager+0xc68>
ffffffffc020422a:	00008617          	auipc	a2,0x8
ffffffffc020422e:	a9e60613          	addi	a2,a2,-1378 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204232:	1ec00593          	li	a1,492
ffffffffc0204236:	00009517          	auipc	a0,0x9
ffffffffc020423a:	dba50513          	addi	a0,a0,-582 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc020423e:	a60fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204242:	03700413          	li	s0,55
ffffffffc0204246:	1f900913          	li	s2,505
ffffffffc020424a:	a819                	j	ffffffffc0204260 <vmm_init+0x7e>
ffffffffc020424c:	e500                	sd	s0,8(a0)
ffffffffc020424e:	e91c                	sd	a5,16(a0)
ffffffffc0204250:	00052c23          	sw	zero,24(a0)
ffffffffc0204254:	0415                	addi	s0,s0,5
ffffffffc0204256:	8526                	mv	a0,s1
ffffffffc0204258:	ca9ff0ef          	jal	ra,ffffffffc0203f00 <insert_vma_struct>
ffffffffc020425c:	03240a63          	beq	s0,s2,ffffffffc0204290 <vmm_init+0xae>
ffffffffc0204260:	03000513          	li	a0,48
ffffffffc0204264:	daffd0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0204268:	85aa                	mv	a1,a0
ffffffffc020426a:	00240793          	addi	a5,s0,2
ffffffffc020426e:	fd79                	bnez	a0,ffffffffc020424c <vmm_init+0x6a>
ffffffffc0204270:	00009697          	auipc	a3,0x9
ffffffffc0204274:	1c868693          	addi	a3,a3,456 # ffffffffc020d438 <default_pmm_manager+0xc68>
ffffffffc0204278:	00008617          	auipc	a2,0x8
ffffffffc020427c:	a5060613          	addi	a2,a2,-1456 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204280:	1f300593          	li	a1,499
ffffffffc0204284:	00009517          	auipc	a0,0x9
ffffffffc0204288:	d6c50513          	addi	a0,a0,-660 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc020428c:	a12fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204290:	649c                	ld	a5,8(s1)
ffffffffc0204292:	471d                	li	a4,7
ffffffffc0204294:	1fb00593          	li	a1,507
ffffffffc0204298:	16f48663          	beq	s1,a5,ffffffffc0204404 <vmm_init+0x222>
ffffffffc020429c:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd686c8>
ffffffffc02042a0:	ffe70693          	addi	a3,a4,-2
ffffffffc02042a4:	10d61063          	bne	a2,a3,ffffffffc02043a4 <vmm_init+0x1c2>
ffffffffc02042a8:	ff07b683          	ld	a3,-16(a5)
ffffffffc02042ac:	0ee69c63          	bne	a3,a4,ffffffffc02043a4 <vmm_init+0x1c2>
ffffffffc02042b0:	0715                	addi	a4,a4,5
ffffffffc02042b2:	679c                	ld	a5,8(a5)
ffffffffc02042b4:	feb712e3          	bne	a4,a1,ffffffffc0204298 <vmm_init+0xb6>
ffffffffc02042b8:	4a1d                	li	s4,7
ffffffffc02042ba:	4415                	li	s0,5
ffffffffc02042bc:	1f900a93          	li	s5,505
ffffffffc02042c0:	85a2                	mv	a1,s0
ffffffffc02042c2:	8526                	mv	a0,s1
ffffffffc02042c4:	97bff0ef          	jal	ra,ffffffffc0203c3e <find_vma>
ffffffffc02042c8:	892a                	mv	s2,a0
ffffffffc02042ca:	16050d63          	beqz	a0,ffffffffc0204444 <vmm_init+0x262>
ffffffffc02042ce:	00140593          	addi	a1,s0,1
ffffffffc02042d2:	8526                	mv	a0,s1
ffffffffc02042d4:	96bff0ef          	jal	ra,ffffffffc0203c3e <find_vma>
ffffffffc02042d8:	89aa                	mv	s3,a0
ffffffffc02042da:	14050563          	beqz	a0,ffffffffc0204424 <vmm_init+0x242>
ffffffffc02042de:	85d2                	mv	a1,s4
ffffffffc02042e0:	8526                	mv	a0,s1
ffffffffc02042e2:	95dff0ef          	jal	ra,ffffffffc0203c3e <find_vma>
ffffffffc02042e6:	16051f63          	bnez	a0,ffffffffc0204464 <vmm_init+0x282>
ffffffffc02042ea:	00340593          	addi	a1,s0,3
ffffffffc02042ee:	8526                	mv	a0,s1
ffffffffc02042f0:	94fff0ef          	jal	ra,ffffffffc0203c3e <find_vma>
ffffffffc02042f4:	1a051863          	bnez	a0,ffffffffc02044a4 <vmm_init+0x2c2>
ffffffffc02042f8:	00440593          	addi	a1,s0,4
ffffffffc02042fc:	8526                	mv	a0,s1
ffffffffc02042fe:	941ff0ef          	jal	ra,ffffffffc0203c3e <find_vma>
ffffffffc0204302:	18051163          	bnez	a0,ffffffffc0204484 <vmm_init+0x2a2>
ffffffffc0204306:	00893783          	ld	a5,8(s2)
ffffffffc020430a:	0af41d63          	bne	s0,a5,ffffffffc02043c4 <vmm_init+0x1e2>
ffffffffc020430e:	01093783          	ld	a5,16(s2)
ffffffffc0204312:	0b479963          	bne	a5,s4,ffffffffc02043c4 <vmm_init+0x1e2>
ffffffffc0204316:	0089b783          	ld	a5,8(s3) # fffffffffffff008 <end+0x3fd686e8>
ffffffffc020431a:	0cf41563          	bne	s0,a5,ffffffffc02043e4 <vmm_init+0x202>
ffffffffc020431e:	0109b783          	ld	a5,16(s3)
ffffffffc0204322:	0d479163          	bne	a5,s4,ffffffffc02043e4 <vmm_init+0x202>
ffffffffc0204326:	0415                	addi	s0,s0,5
ffffffffc0204328:	0a15                	addi	s4,s4,5
ffffffffc020432a:	f9541be3          	bne	s0,s5,ffffffffc02042c0 <vmm_init+0xde>
ffffffffc020432e:	4411                	li	s0,4
ffffffffc0204330:	597d                	li	s2,-1
ffffffffc0204332:	85a2                	mv	a1,s0
ffffffffc0204334:	8526                	mv	a0,s1
ffffffffc0204336:	909ff0ef          	jal	ra,ffffffffc0203c3e <find_vma>
ffffffffc020433a:	0004059b          	sext.w	a1,s0
ffffffffc020433e:	c90d                	beqz	a0,ffffffffc0204370 <vmm_init+0x18e>
ffffffffc0204340:	6914                	ld	a3,16(a0)
ffffffffc0204342:	6510                	ld	a2,8(a0)
ffffffffc0204344:	00009517          	auipc	a0,0x9
ffffffffc0204348:	07c50513          	addi	a0,a0,124 # ffffffffc020d3c0 <default_pmm_manager+0xbf0>
ffffffffc020434c:	e5bfb0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0204350:	00009697          	auipc	a3,0x9
ffffffffc0204354:	09868693          	addi	a3,a3,152 # ffffffffc020d3e8 <default_pmm_manager+0xc18>
ffffffffc0204358:	00008617          	auipc	a2,0x8
ffffffffc020435c:	97060613          	addi	a2,a2,-1680 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204360:	21900593          	li	a1,537
ffffffffc0204364:	00009517          	auipc	a0,0x9
ffffffffc0204368:	c8c50513          	addi	a0,a0,-884 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc020436c:	932fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204370:	147d                	addi	s0,s0,-1
ffffffffc0204372:	fd2410e3          	bne	s0,s2,ffffffffc0204332 <vmm_init+0x150>
ffffffffc0204376:	8526                	mv	a0,s1
ffffffffc0204378:	c59ff0ef          	jal	ra,ffffffffc0203fd0 <mm_destroy>
ffffffffc020437c:	00009517          	auipc	a0,0x9
ffffffffc0204380:	08450513          	addi	a0,a0,132 # ffffffffc020d400 <default_pmm_manager+0xc30>
ffffffffc0204384:	e23fb0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0204388:	7442                	ld	s0,48(sp)
ffffffffc020438a:	70e2                	ld	ra,56(sp)
ffffffffc020438c:	74a2                	ld	s1,40(sp)
ffffffffc020438e:	7902                	ld	s2,32(sp)
ffffffffc0204390:	69e2                	ld	s3,24(sp)
ffffffffc0204392:	6a42                	ld	s4,16(sp)
ffffffffc0204394:	6aa2                	ld	s5,8(sp)
ffffffffc0204396:	00009517          	auipc	a0,0x9
ffffffffc020439a:	08a50513          	addi	a0,a0,138 # ffffffffc020d420 <default_pmm_manager+0xc50>
ffffffffc020439e:	6121                	addi	sp,sp,64
ffffffffc02043a0:	e07fb06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02043a4:	00009697          	auipc	a3,0x9
ffffffffc02043a8:	f3468693          	addi	a3,a3,-204 # ffffffffc020d2d8 <default_pmm_manager+0xb08>
ffffffffc02043ac:	00008617          	auipc	a2,0x8
ffffffffc02043b0:	91c60613          	addi	a2,a2,-1764 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02043b4:	1fd00593          	li	a1,509
ffffffffc02043b8:	00009517          	auipc	a0,0x9
ffffffffc02043bc:	c3850513          	addi	a0,a0,-968 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc02043c0:	8defc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02043c4:	00009697          	auipc	a3,0x9
ffffffffc02043c8:	f9c68693          	addi	a3,a3,-100 # ffffffffc020d360 <default_pmm_manager+0xb90>
ffffffffc02043cc:	00008617          	auipc	a2,0x8
ffffffffc02043d0:	8fc60613          	addi	a2,a2,-1796 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02043d4:	20e00593          	li	a1,526
ffffffffc02043d8:	00009517          	auipc	a0,0x9
ffffffffc02043dc:	c1850513          	addi	a0,a0,-1000 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc02043e0:	8befc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02043e4:	00009697          	auipc	a3,0x9
ffffffffc02043e8:	fac68693          	addi	a3,a3,-84 # ffffffffc020d390 <default_pmm_manager+0xbc0>
ffffffffc02043ec:	00008617          	auipc	a2,0x8
ffffffffc02043f0:	8dc60613          	addi	a2,a2,-1828 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02043f4:	20f00593          	li	a1,527
ffffffffc02043f8:	00009517          	auipc	a0,0x9
ffffffffc02043fc:	bf850513          	addi	a0,a0,-1032 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc0204400:	89efc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204404:	00009697          	auipc	a3,0x9
ffffffffc0204408:	ebc68693          	addi	a3,a3,-324 # ffffffffc020d2c0 <default_pmm_manager+0xaf0>
ffffffffc020440c:	00008617          	auipc	a2,0x8
ffffffffc0204410:	8bc60613          	addi	a2,a2,-1860 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204414:	1fb00593          	li	a1,507
ffffffffc0204418:	00009517          	auipc	a0,0x9
ffffffffc020441c:	bd850513          	addi	a0,a0,-1064 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc0204420:	87efc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204424:	00009697          	auipc	a3,0x9
ffffffffc0204428:	efc68693          	addi	a3,a3,-260 # ffffffffc020d320 <default_pmm_manager+0xb50>
ffffffffc020442c:	00008617          	auipc	a2,0x8
ffffffffc0204430:	89c60613          	addi	a2,a2,-1892 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204434:	20600593          	li	a1,518
ffffffffc0204438:	00009517          	auipc	a0,0x9
ffffffffc020443c:	bb850513          	addi	a0,a0,-1096 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc0204440:	85efc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204444:	00009697          	auipc	a3,0x9
ffffffffc0204448:	ecc68693          	addi	a3,a3,-308 # ffffffffc020d310 <default_pmm_manager+0xb40>
ffffffffc020444c:	00008617          	auipc	a2,0x8
ffffffffc0204450:	87c60613          	addi	a2,a2,-1924 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204454:	20400593          	li	a1,516
ffffffffc0204458:	00009517          	auipc	a0,0x9
ffffffffc020445c:	b9850513          	addi	a0,a0,-1128 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc0204460:	83efc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204464:	00009697          	auipc	a3,0x9
ffffffffc0204468:	ecc68693          	addi	a3,a3,-308 # ffffffffc020d330 <default_pmm_manager+0xb60>
ffffffffc020446c:	00008617          	auipc	a2,0x8
ffffffffc0204470:	85c60613          	addi	a2,a2,-1956 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204474:	20800593          	li	a1,520
ffffffffc0204478:	00009517          	auipc	a0,0x9
ffffffffc020447c:	b7850513          	addi	a0,a0,-1160 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc0204480:	81efc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204484:	00009697          	auipc	a3,0x9
ffffffffc0204488:	ecc68693          	addi	a3,a3,-308 # ffffffffc020d350 <default_pmm_manager+0xb80>
ffffffffc020448c:	00008617          	auipc	a2,0x8
ffffffffc0204490:	83c60613          	addi	a2,a2,-1988 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204494:	20c00593          	li	a1,524
ffffffffc0204498:	00009517          	auipc	a0,0x9
ffffffffc020449c:	b5850513          	addi	a0,a0,-1192 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc02044a0:	ffffb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02044a4:	00009697          	auipc	a3,0x9
ffffffffc02044a8:	e9c68693          	addi	a3,a3,-356 # ffffffffc020d340 <default_pmm_manager+0xb70>
ffffffffc02044ac:	00008617          	auipc	a2,0x8
ffffffffc02044b0:	81c60613          	addi	a2,a2,-2020 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02044b4:	20a00593          	li	a1,522
ffffffffc02044b8:	00009517          	auipc	a0,0x9
ffffffffc02044bc:	b3850513          	addi	a0,a0,-1224 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc02044c0:	fdffb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02044c4:	00009697          	auipc	a3,0x9
ffffffffc02044c8:	dac68693          	addi	a3,a3,-596 # ffffffffc020d270 <default_pmm_manager+0xaa0>
ffffffffc02044cc:	00007617          	auipc	a2,0x7
ffffffffc02044d0:	7fc60613          	addi	a2,a2,2044 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02044d4:	1e400593          	li	a1,484
ffffffffc02044d8:	00009517          	auipc	a0,0x9
ffffffffc02044dc:	b1850513          	addi	a0,a0,-1256 # ffffffffc020cff0 <default_pmm_manager+0x820>
ffffffffc02044e0:	fbffb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02044e4 <user_mem_check>:
ffffffffc02044e4:	7179                	addi	sp,sp,-48
ffffffffc02044e6:	f022                	sd	s0,32(sp)
ffffffffc02044e8:	f406                	sd	ra,40(sp)
ffffffffc02044ea:	ec26                	sd	s1,24(sp)
ffffffffc02044ec:	e84a                	sd	s2,16(sp)
ffffffffc02044ee:	e44e                	sd	s3,8(sp)
ffffffffc02044f0:	e052                	sd	s4,0(sp)
ffffffffc02044f2:	842e                	mv	s0,a1
ffffffffc02044f4:	c135                	beqz	a0,ffffffffc0204558 <user_mem_check+0x74>
ffffffffc02044f6:	002007b7          	lui	a5,0x200
ffffffffc02044fa:	04f5e663          	bltu	a1,a5,ffffffffc0204546 <user_mem_check+0x62>
ffffffffc02044fe:	00c584b3          	add	s1,a1,a2
ffffffffc0204502:	0495f263          	bgeu	a1,s1,ffffffffc0204546 <user_mem_check+0x62>
ffffffffc0204506:	4785                	li	a5,1
ffffffffc0204508:	07fe                	slli	a5,a5,0x1f
ffffffffc020450a:	0297ee63          	bltu	a5,s1,ffffffffc0204546 <user_mem_check+0x62>
ffffffffc020450e:	892a                	mv	s2,a0
ffffffffc0204510:	89b6                	mv	s3,a3
ffffffffc0204512:	6a05                	lui	s4,0x1
ffffffffc0204514:	a821                	j	ffffffffc020452c <user_mem_check+0x48>
ffffffffc0204516:	0027f693          	andi	a3,a5,2
ffffffffc020451a:	9752                	add	a4,a4,s4
ffffffffc020451c:	8ba1                	andi	a5,a5,8
ffffffffc020451e:	c685                	beqz	a3,ffffffffc0204546 <user_mem_check+0x62>
ffffffffc0204520:	c399                	beqz	a5,ffffffffc0204526 <user_mem_check+0x42>
ffffffffc0204522:	02e46263          	bltu	s0,a4,ffffffffc0204546 <user_mem_check+0x62>
ffffffffc0204526:	6900                	ld	s0,16(a0)
ffffffffc0204528:	04947663          	bgeu	s0,s1,ffffffffc0204574 <user_mem_check+0x90>
ffffffffc020452c:	85a2                	mv	a1,s0
ffffffffc020452e:	854a                	mv	a0,s2
ffffffffc0204530:	f0eff0ef          	jal	ra,ffffffffc0203c3e <find_vma>
ffffffffc0204534:	c909                	beqz	a0,ffffffffc0204546 <user_mem_check+0x62>
ffffffffc0204536:	6518                	ld	a4,8(a0)
ffffffffc0204538:	00e46763          	bltu	s0,a4,ffffffffc0204546 <user_mem_check+0x62>
ffffffffc020453c:	4d1c                	lw	a5,24(a0)
ffffffffc020453e:	fc099ce3          	bnez	s3,ffffffffc0204516 <user_mem_check+0x32>
ffffffffc0204542:	8b85                	andi	a5,a5,1
ffffffffc0204544:	f3ed                	bnez	a5,ffffffffc0204526 <user_mem_check+0x42>
ffffffffc0204546:	4501                	li	a0,0
ffffffffc0204548:	70a2                	ld	ra,40(sp)
ffffffffc020454a:	7402                	ld	s0,32(sp)
ffffffffc020454c:	64e2                	ld	s1,24(sp)
ffffffffc020454e:	6942                	ld	s2,16(sp)
ffffffffc0204550:	69a2                	ld	s3,8(sp)
ffffffffc0204552:	6a02                	ld	s4,0(sp)
ffffffffc0204554:	6145                	addi	sp,sp,48
ffffffffc0204556:	8082                	ret
ffffffffc0204558:	c02007b7          	lui	a5,0xc0200
ffffffffc020455c:	4501                	li	a0,0
ffffffffc020455e:	fef5e5e3          	bltu	a1,a5,ffffffffc0204548 <user_mem_check+0x64>
ffffffffc0204562:	962e                	add	a2,a2,a1
ffffffffc0204564:	fec5f2e3          	bgeu	a1,a2,ffffffffc0204548 <user_mem_check+0x64>
ffffffffc0204568:	c8000537          	lui	a0,0xc8000
ffffffffc020456c:	0505                	addi	a0,a0,1
ffffffffc020456e:	00a63533          	sltu	a0,a2,a0
ffffffffc0204572:	bfd9                	j	ffffffffc0204548 <user_mem_check+0x64>
ffffffffc0204574:	4505                	li	a0,1
ffffffffc0204576:	bfc9                	j	ffffffffc0204548 <user_mem_check+0x64>

ffffffffc0204578 <copy_from_user>:
ffffffffc0204578:	1101                	addi	sp,sp,-32
ffffffffc020457a:	e822                	sd	s0,16(sp)
ffffffffc020457c:	e426                	sd	s1,8(sp)
ffffffffc020457e:	8432                	mv	s0,a2
ffffffffc0204580:	84b6                	mv	s1,a3
ffffffffc0204582:	e04a                	sd	s2,0(sp)
ffffffffc0204584:	86ba                	mv	a3,a4
ffffffffc0204586:	892e                	mv	s2,a1
ffffffffc0204588:	8626                	mv	a2,s1
ffffffffc020458a:	85a2                	mv	a1,s0
ffffffffc020458c:	ec06                	sd	ra,24(sp)
ffffffffc020458e:	f57ff0ef          	jal	ra,ffffffffc02044e4 <user_mem_check>
ffffffffc0204592:	c519                	beqz	a0,ffffffffc02045a0 <copy_from_user+0x28>
ffffffffc0204594:	8626                	mv	a2,s1
ffffffffc0204596:	85a2                	mv	a1,s0
ffffffffc0204598:	854a                	mv	a0,s2
ffffffffc020459a:	29e070ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc020459e:	4505                	li	a0,1
ffffffffc02045a0:	60e2                	ld	ra,24(sp)
ffffffffc02045a2:	6442                	ld	s0,16(sp)
ffffffffc02045a4:	64a2                	ld	s1,8(sp)
ffffffffc02045a6:	6902                	ld	s2,0(sp)
ffffffffc02045a8:	6105                	addi	sp,sp,32
ffffffffc02045aa:	8082                	ret

ffffffffc02045ac <copy_to_user>:
ffffffffc02045ac:	1101                	addi	sp,sp,-32
ffffffffc02045ae:	e822                	sd	s0,16(sp)
ffffffffc02045b0:	8436                	mv	s0,a3
ffffffffc02045b2:	e04a                	sd	s2,0(sp)
ffffffffc02045b4:	4685                	li	a3,1
ffffffffc02045b6:	8932                	mv	s2,a2
ffffffffc02045b8:	8622                	mv	a2,s0
ffffffffc02045ba:	e426                	sd	s1,8(sp)
ffffffffc02045bc:	ec06                	sd	ra,24(sp)
ffffffffc02045be:	84ae                	mv	s1,a1
ffffffffc02045c0:	f25ff0ef          	jal	ra,ffffffffc02044e4 <user_mem_check>
ffffffffc02045c4:	c519                	beqz	a0,ffffffffc02045d2 <copy_to_user+0x26>
ffffffffc02045c6:	8622                	mv	a2,s0
ffffffffc02045c8:	85ca                	mv	a1,s2
ffffffffc02045ca:	8526                	mv	a0,s1
ffffffffc02045cc:	26c070ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc02045d0:	4505                	li	a0,1
ffffffffc02045d2:	60e2                	ld	ra,24(sp)
ffffffffc02045d4:	6442                	ld	s0,16(sp)
ffffffffc02045d6:	64a2                	ld	s1,8(sp)
ffffffffc02045d8:	6902                	ld	s2,0(sp)
ffffffffc02045da:	6105                	addi	sp,sp,32
ffffffffc02045dc:	8082                	ret

ffffffffc02045de <copy_string>:
ffffffffc02045de:	7139                	addi	sp,sp,-64
ffffffffc02045e0:	ec4e                	sd	s3,24(sp)
ffffffffc02045e2:	6985                	lui	s3,0x1
ffffffffc02045e4:	99b2                	add	s3,s3,a2
ffffffffc02045e6:	77fd                	lui	a5,0xfffff
ffffffffc02045e8:	00f9f9b3          	and	s3,s3,a5
ffffffffc02045ec:	f426                	sd	s1,40(sp)
ffffffffc02045ee:	f04a                	sd	s2,32(sp)
ffffffffc02045f0:	e852                	sd	s4,16(sp)
ffffffffc02045f2:	e456                	sd	s5,8(sp)
ffffffffc02045f4:	fc06                	sd	ra,56(sp)
ffffffffc02045f6:	f822                	sd	s0,48(sp)
ffffffffc02045f8:	84b2                	mv	s1,a2
ffffffffc02045fa:	8aaa                	mv	s5,a0
ffffffffc02045fc:	8a2e                	mv	s4,a1
ffffffffc02045fe:	8936                	mv	s2,a3
ffffffffc0204600:	40c989b3          	sub	s3,s3,a2
ffffffffc0204604:	a015                	j	ffffffffc0204628 <copy_string+0x4a>
ffffffffc0204606:	158070ef          	jal	ra,ffffffffc020b75e <strnlen>
ffffffffc020460a:	87aa                	mv	a5,a0
ffffffffc020460c:	85a6                	mv	a1,s1
ffffffffc020460e:	8552                	mv	a0,s4
ffffffffc0204610:	8622                	mv	a2,s0
ffffffffc0204612:	0487e363          	bltu	a5,s0,ffffffffc0204658 <copy_string+0x7a>
ffffffffc0204616:	0329f763          	bgeu	s3,s2,ffffffffc0204644 <copy_string+0x66>
ffffffffc020461a:	21e070ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc020461e:	9a22                	add	s4,s4,s0
ffffffffc0204620:	94a2                	add	s1,s1,s0
ffffffffc0204622:	40890933          	sub	s2,s2,s0
ffffffffc0204626:	6985                	lui	s3,0x1
ffffffffc0204628:	4681                	li	a3,0
ffffffffc020462a:	85a6                	mv	a1,s1
ffffffffc020462c:	8556                	mv	a0,s5
ffffffffc020462e:	844a                	mv	s0,s2
ffffffffc0204630:	0129f363          	bgeu	s3,s2,ffffffffc0204636 <copy_string+0x58>
ffffffffc0204634:	844e                	mv	s0,s3
ffffffffc0204636:	8622                	mv	a2,s0
ffffffffc0204638:	eadff0ef          	jal	ra,ffffffffc02044e4 <user_mem_check>
ffffffffc020463c:	87aa                	mv	a5,a0
ffffffffc020463e:	85a2                	mv	a1,s0
ffffffffc0204640:	8526                	mv	a0,s1
ffffffffc0204642:	f3f1                	bnez	a5,ffffffffc0204606 <copy_string+0x28>
ffffffffc0204644:	4501                	li	a0,0
ffffffffc0204646:	70e2                	ld	ra,56(sp)
ffffffffc0204648:	7442                	ld	s0,48(sp)
ffffffffc020464a:	74a2                	ld	s1,40(sp)
ffffffffc020464c:	7902                	ld	s2,32(sp)
ffffffffc020464e:	69e2                	ld	s3,24(sp)
ffffffffc0204650:	6a42                	ld	s4,16(sp)
ffffffffc0204652:	6aa2                	ld	s5,8(sp)
ffffffffc0204654:	6121                	addi	sp,sp,64
ffffffffc0204656:	8082                	ret
ffffffffc0204658:	00178613          	addi	a2,a5,1 # fffffffffffff001 <end+0x3fd686e1>
ffffffffc020465c:	1dc070ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc0204660:	4505                	li	a0,1
ffffffffc0204662:	b7d5                	j	ffffffffc0204646 <copy_string+0x68>

ffffffffc0204664 <__down.constprop.0>:
ffffffffc0204664:	715d                	addi	sp,sp,-80
ffffffffc0204666:	e0a2                	sd	s0,64(sp)
ffffffffc0204668:	e486                	sd	ra,72(sp)
ffffffffc020466a:	fc26                	sd	s1,56(sp)
ffffffffc020466c:	842a                	mv	s0,a0
ffffffffc020466e:	100027f3          	csrr	a5,sstatus
ffffffffc0204672:	8b89                	andi	a5,a5,2
ffffffffc0204674:	ebb1                	bnez	a5,ffffffffc02046c8 <__down.constprop.0+0x64>
ffffffffc0204676:	411c                	lw	a5,0(a0)
ffffffffc0204678:	00f05a63          	blez	a5,ffffffffc020468c <__down.constprop.0+0x28>
ffffffffc020467c:	37fd                	addiw	a5,a5,-1
ffffffffc020467e:	c11c                	sw	a5,0(a0)
ffffffffc0204680:	4501                	li	a0,0
ffffffffc0204682:	60a6                	ld	ra,72(sp)
ffffffffc0204684:	6406                	ld	s0,64(sp)
ffffffffc0204686:	74e2                	ld	s1,56(sp)
ffffffffc0204688:	6161                	addi	sp,sp,80
ffffffffc020468a:	8082                	ret
ffffffffc020468c:	00850413          	addi	s0,a0,8 # ffffffffc8000008 <end+0x7d696e8>
ffffffffc0204690:	0024                	addi	s1,sp,8
ffffffffc0204692:	10000613          	li	a2,256
ffffffffc0204696:	85a6                	mv	a1,s1
ffffffffc0204698:	8522                	mv	a0,s0
ffffffffc020469a:	2d8000ef          	jal	ra,ffffffffc0204972 <wait_current_set>
ffffffffc020469e:	7e1020ef          	jal	ra,ffffffffc020767e <schedule>
ffffffffc02046a2:	100027f3          	csrr	a5,sstatus
ffffffffc02046a6:	8b89                	andi	a5,a5,2
ffffffffc02046a8:	efb9                	bnez	a5,ffffffffc0204706 <__down.constprop.0+0xa2>
ffffffffc02046aa:	8526                	mv	a0,s1
ffffffffc02046ac:	19c000ef          	jal	ra,ffffffffc0204848 <wait_in_queue>
ffffffffc02046b0:	e531                	bnez	a0,ffffffffc02046fc <__down.constprop.0+0x98>
ffffffffc02046b2:	4542                	lw	a0,16(sp)
ffffffffc02046b4:	10000793          	li	a5,256
ffffffffc02046b8:	fcf515e3          	bne	a0,a5,ffffffffc0204682 <__down.constprop.0+0x1e>
ffffffffc02046bc:	60a6                	ld	ra,72(sp)
ffffffffc02046be:	6406                	ld	s0,64(sp)
ffffffffc02046c0:	74e2                	ld	s1,56(sp)
ffffffffc02046c2:	4501                	li	a0,0
ffffffffc02046c4:	6161                	addi	sp,sp,80
ffffffffc02046c6:	8082                	ret
ffffffffc02046c8:	daafc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02046cc:	401c                	lw	a5,0(s0)
ffffffffc02046ce:	00f05c63          	blez	a5,ffffffffc02046e6 <__down.constprop.0+0x82>
ffffffffc02046d2:	37fd                	addiw	a5,a5,-1
ffffffffc02046d4:	c01c                	sw	a5,0(s0)
ffffffffc02046d6:	d96fc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02046da:	60a6                	ld	ra,72(sp)
ffffffffc02046dc:	6406                	ld	s0,64(sp)
ffffffffc02046de:	74e2                	ld	s1,56(sp)
ffffffffc02046e0:	4501                	li	a0,0
ffffffffc02046e2:	6161                	addi	sp,sp,80
ffffffffc02046e4:	8082                	ret
ffffffffc02046e6:	0421                	addi	s0,s0,8
ffffffffc02046e8:	0024                	addi	s1,sp,8
ffffffffc02046ea:	10000613          	li	a2,256
ffffffffc02046ee:	85a6                	mv	a1,s1
ffffffffc02046f0:	8522                	mv	a0,s0
ffffffffc02046f2:	280000ef          	jal	ra,ffffffffc0204972 <wait_current_set>
ffffffffc02046f6:	d76fc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02046fa:	b755                	j	ffffffffc020469e <__down.constprop.0+0x3a>
ffffffffc02046fc:	85a6                	mv	a1,s1
ffffffffc02046fe:	8522                	mv	a0,s0
ffffffffc0204700:	0ee000ef          	jal	ra,ffffffffc02047ee <wait_queue_del>
ffffffffc0204704:	b77d                	j	ffffffffc02046b2 <__down.constprop.0+0x4e>
ffffffffc0204706:	d6cfc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020470a:	8526                	mv	a0,s1
ffffffffc020470c:	13c000ef          	jal	ra,ffffffffc0204848 <wait_in_queue>
ffffffffc0204710:	e501                	bnez	a0,ffffffffc0204718 <__down.constprop.0+0xb4>
ffffffffc0204712:	d5afc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0204716:	bf71                	j	ffffffffc02046b2 <__down.constprop.0+0x4e>
ffffffffc0204718:	85a6                	mv	a1,s1
ffffffffc020471a:	8522                	mv	a0,s0
ffffffffc020471c:	0d2000ef          	jal	ra,ffffffffc02047ee <wait_queue_del>
ffffffffc0204720:	bfcd                	j	ffffffffc0204712 <__down.constprop.0+0xae>

ffffffffc0204722 <__up.constprop.0>:
ffffffffc0204722:	1101                	addi	sp,sp,-32
ffffffffc0204724:	e822                	sd	s0,16(sp)
ffffffffc0204726:	ec06                	sd	ra,24(sp)
ffffffffc0204728:	e426                	sd	s1,8(sp)
ffffffffc020472a:	e04a                	sd	s2,0(sp)
ffffffffc020472c:	842a                	mv	s0,a0
ffffffffc020472e:	100027f3          	csrr	a5,sstatus
ffffffffc0204732:	8b89                	andi	a5,a5,2
ffffffffc0204734:	4901                	li	s2,0
ffffffffc0204736:	eba1                	bnez	a5,ffffffffc0204786 <__up.constprop.0+0x64>
ffffffffc0204738:	00840493          	addi	s1,s0,8
ffffffffc020473c:	8526                	mv	a0,s1
ffffffffc020473e:	0ee000ef          	jal	ra,ffffffffc020482c <wait_queue_first>
ffffffffc0204742:	85aa                	mv	a1,a0
ffffffffc0204744:	cd0d                	beqz	a0,ffffffffc020477e <__up.constprop.0+0x5c>
ffffffffc0204746:	6118                	ld	a4,0(a0)
ffffffffc0204748:	10000793          	li	a5,256
ffffffffc020474c:	0ec72703          	lw	a4,236(a4)
ffffffffc0204750:	02f71f63          	bne	a4,a5,ffffffffc020478e <__up.constprop.0+0x6c>
ffffffffc0204754:	4685                	li	a3,1
ffffffffc0204756:	10000613          	li	a2,256
ffffffffc020475a:	8526                	mv	a0,s1
ffffffffc020475c:	0fa000ef          	jal	ra,ffffffffc0204856 <wakeup_wait>
ffffffffc0204760:	00091863          	bnez	s2,ffffffffc0204770 <__up.constprop.0+0x4e>
ffffffffc0204764:	60e2                	ld	ra,24(sp)
ffffffffc0204766:	6442                	ld	s0,16(sp)
ffffffffc0204768:	64a2                	ld	s1,8(sp)
ffffffffc020476a:	6902                	ld	s2,0(sp)
ffffffffc020476c:	6105                	addi	sp,sp,32
ffffffffc020476e:	8082                	ret
ffffffffc0204770:	6442                	ld	s0,16(sp)
ffffffffc0204772:	60e2                	ld	ra,24(sp)
ffffffffc0204774:	64a2                	ld	s1,8(sp)
ffffffffc0204776:	6902                	ld	s2,0(sp)
ffffffffc0204778:	6105                	addi	sp,sp,32
ffffffffc020477a:	cf2fc06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc020477e:	401c                	lw	a5,0(s0)
ffffffffc0204780:	2785                	addiw	a5,a5,1
ffffffffc0204782:	c01c                	sw	a5,0(s0)
ffffffffc0204784:	bff1                	j	ffffffffc0204760 <__up.constprop.0+0x3e>
ffffffffc0204786:	cecfc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020478a:	4905                	li	s2,1
ffffffffc020478c:	b775                	j	ffffffffc0204738 <__up.constprop.0+0x16>
ffffffffc020478e:	00009697          	auipc	a3,0x9
ffffffffc0204792:	cba68693          	addi	a3,a3,-838 # ffffffffc020d448 <default_pmm_manager+0xc78>
ffffffffc0204796:	00007617          	auipc	a2,0x7
ffffffffc020479a:	53260613          	addi	a2,a2,1330 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020479e:	45e5                	li	a1,25
ffffffffc02047a0:	00009517          	auipc	a0,0x9
ffffffffc02047a4:	cd050513          	addi	a0,a0,-816 # ffffffffc020d470 <default_pmm_manager+0xca0>
ffffffffc02047a8:	cf7fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02047ac <sem_init>:
ffffffffc02047ac:	c10c                	sw	a1,0(a0)
ffffffffc02047ae:	0521                	addi	a0,a0,8
ffffffffc02047b0:	a825                	j	ffffffffc02047e8 <wait_queue_init>

ffffffffc02047b2 <up>:
ffffffffc02047b2:	f71ff06f          	j	ffffffffc0204722 <__up.constprop.0>

ffffffffc02047b6 <down>:
ffffffffc02047b6:	1141                	addi	sp,sp,-16
ffffffffc02047b8:	e406                	sd	ra,8(sp)
ffffffffc02047ba:	eabff0ef          	jal	ra,ffffffffc0204664 <__down.constprop.0>
ffffffffc02047be:	2501                	sext.w	a0,a0
ffffffffc02047c0:	e501                	bnez	a0,ffffffffc02047c8 <down+0x12>
ffffffffc02047c2:	60a2                	ld	ra,8(sp)
ffffffffc02047c4:	0141                	addi	sp,sp,16
ffffffffc02047c6:	8082                	ret
ffffffffc02047c8:	00009697          	auipc	a3,0x9
ffffffffc02047cc:	cb868693          	addi	a3,a3,-840 # ffffffffc020d480 <default_pmm_manager+0xcb0>
ffffffffc02047d0:	00007617          	auipc	a2,0x7
ffffffffc02047d4:	4f860613          	addi	a2,a2,1272 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02047d8:	04000593          	li	a1,64
ffffffffc02047dc:	00009517          	auipc	a0,0x9
ffffffffc02047e0:	c9450513          	addi	a0,a0,-876 # ffffffffc020d470 <default_pmm_manager+0xca0>
ffffffffc02047e4:	cbbfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02047e8 <wait_queue_init>:
ffffffffc02047e8:	e508                	sd	a0,8(a0)
ffffffffc02047ea:	e108                	sd	a0,0(a0)
ffffffffc02047ec:	8082                	ret

ffffffffc02047ee <wait_queue_del>:
ffffffffc02047ee:	7198                	ld	a4,32(a1)
ffffffffc02047f0:	01858793          	addi	a5,a1,24
ffffffffc02047f4:	00e78b63          	beq	a5,a4,ffffffffc020480a <wait_queue_del+0x1c>
ffffffffc02047f8:	6994                	ld	a3,16(a1)
ffffffffc02047fa:	00a69863          	bne	a3,a0,ffffffffc020480a <wait_queue_del+0x1c>
ffffffffc02047fe:	6d94                	ld	a3,24(a1)
ffffffffc0204800:	e698                	sd	a4,8(a3)
ffffffffc0204802:	e314                	sd	a3,0(a4)
ffffffffc0204804:	f19c                	sd	a5,32(a1)
ffffffffc0204806:	ed9c                	sd	a5,24(a1)
ffffffffc0204808:	8082                	ret
ffffffffc020480a:	1141                	addi	sp,sp,-16
ffffffffc020480c:	00009697          	auipc	a3,0x9
ffffffffc0204810:	cd468693          	addi	a3,a3,-812 # ffffffffc020d4e0 <default_pmm_manager+0xd10>
ffffffffc0204814:	00007617          	auipc	a2,0x7
ffffffffc0204818:	4b460613          	addi	a2,a2,1204 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020481c:	45f1                	li	a1,28
ffffffffc020481e:	00009517          	auipc	a0,0x9
ffffffffc0204822:	caa50513          	addi	a0,a0,-854 # ffffffffc020d4c8 <default_pmm_manager+0xcf8>
ffffffffc0204826:	e406                	sd	ra,8(sp)
ffffffffc0204828:	c77fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020482c <wait_queue_first>:
ffffffffc020482c:	651c                	ld	a5,8(a0)
ffffffffc020482e:	00f50563          	beq	a0,a5,ffffffffc0204838 <wait_queue_first+0xc>
ffffffffc0204832:	fe878513          	addi	a0,a5,-24
ffffffffc0204836:	8082                	ret
ffffffffc0204838:	4501                	li	a0,0
ffffffffc020483a:	8082                	ret

ffffffffc020483c <wait_queue_empty>:
ffffffffc020483c:	651c                	ld	a5,8(a0)
ffffffffc020483e:	40a78533          	sub	a0,a5,a0
ffffffffc0204842:	00153513          	seqz	a0,a0
ffffffffc0204846:	8082                	ret

ffffffffc0204848 <wait_in_queue>:
ffffffffc0204848:	711c                	ld	a5,32(a0)
ffffffffc020484a:	0561                	addi	a0,a0,24
ffffffffc020484c:	40a78533          	sub	a0,a5,a0
ffffffffc0204850:	00a03533          	snez	a0,a0
ffffffffc0204854:	8082                	ret

ffffffffc0204856 <wakeup_wait>:
ffffffffc0204856:	e689                	bnez	a3,ffffffffc0204860 <wakeup_wait+0xa>
ffffffffc0204858:	6188                	ld	a0,0(a1)
ffffffffc020485a:	c590                	sw	a2,8(a1)
ffffffffc020485c:	5710206f          	j	ffffffffc02075cc <wakeup_proc>
ffffffffc0204860:	7198                	ld	a4,32(a1)
ffffffffc0204862:	01858793          	addi	a5,a1,24
ffffffffc0204866:	00e78e63          	beq	a5,a4,ffffffffc0204882 <wakeup_wait+0x2c>
ffffffffc020486a:	6994                	ld	a3,16(a1)
ffffffffc020486c:	00d51b63          	bne	a0,a3,ffffffffc0204882 <wakeup_wait+0x2c>
ffffffffc0204870:	6d94                	ld	a3,24(a1)
ffffffffc0204872:	6188                	ld	a0,0(a1)
ffffffffc0204874:	e698                	sd	a4,8(a3)
ffffffffc0204876:	e314                	sd	a3,0(a4)
ffffffffc0204878:	f19c                	sd	a5,32(a1)
ffffffffc020487a:	ed9c                	sd	a5,24(a1)
ffffffffc020487c:	c590                	sw	a2,8(a1)
ffffffffc020487e:	54f0206f          	j	ffffffffc02075cc <wakeup_proc>
ffffffffc0204882:	1141                	addi	sp,sp,-16
ffffffffc0204884:	00009697          	auipc	a3,0x9
ffffffffc0204888:	c5c68693          	addi	a3,a3,-932 # ffffffffc020d4e0 <default_pmm_manager+0xd10>
ffffffffc020488c:	00007617          	auipc	a2,0x7
ffffffffc0204890:	43c60613          	addi	a2,a2,1084 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204894:	45f1                	li	a1,28
ffffffffc0204896:	00009517          	auipc	a0,0x9
ffffffffc020489a:	c3250513          	addi	a0,a0,-974 # ffffffffc020d4c8 <default_pmm_manager+0xcf8>
ffffffffc020489e:	e406                	sd	ra,8(sp)
ffffffffc02048a0:	bfffb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02048a4 <wakeup_queue>:
ffffffffc02048a4:	651c                	ld	a5,8(a0)
ffffffffc02048a6:	0ca78563          	beq	a5,a0,ffffffffc0204970 <wakeup_queue+0xcc>
ffffffffc02048aa:	1101                	addi	sp,sp,-32
ffffffffc02048ac:	e822                	sd	s0,16(sp)
ffffffffc02048ae:	e426                	sd	s1,8(sp)
ffffffffc02048b0:	e04a                	sd	s2,0(sp)
ffffffffc02048b2:	ec06                	sd	ra,24(sp)
ffffffffc02048b4:	84aa                	mv	s1,a0
ffffffffc02048b6:	892e                	mv	s2,a1
ffffffffc02048b8:	fe878413          	addi	s0,a5,-24
ffffffffc02048bc:	e23d                	bnez	a2,ffffffffc0204922 <wakeup_queue+0x7e>
ffffffffc02048be:	6008                	ld	a0,0(s0)
ffffffffc02048c0:	01242423          	sw	s2,8(s0)
ffffffffc02048c4:	509020ef          	jal	ra,ffffffffc02075cc <wakeup_proc>
ffffffffc02048c8:	701c                	ld	a5,32(s0)
ffffffffc02048ca:	01840713          	addi	a4,s0,24
ffffffffc02048ce:	02e78463          	beq	a5,a4,ffffffffc02048f6 <wakeup_queue+0x52>
ffffffffc02048d2:	6818                	ld	a4,16(s0)
ffffffffc02048d4:	02e49163          	bne	s1,a4,ffffffffc02048f6 <wakeup_queue+0x52>
ffffffffc02048d8:	02f48f63          	beq	s1,a5,ffffffffc0204916 <wakeup_queue+0x72>
ffffffffc02048dc:	fe87b503          	ld	a0,-24(a5)
ffffffffc02048e0:	ff27a823          	sw	s2,-16(a5)
ffffffffc02048e4:	fe878413          	addi	s0,a5,-24
ffffffffc02048e8:	4e5020ef          	jal	ra,ffffffffc02075cc <wakeup_proc>
ffffffffc02048ec:	701c                	ld	a5,32(s0)
ffffffffc02048ee:	01840713          	addi	a4,s0,24
ffffffffc02048f2:	fee790e3          	bne	a5,a4,ffffffffc02048d2 <wakeup_queue+0x2e>
ffffffffc02048f6:	00009697          	auipc	a3,0x9
ffffffffc02048fa:	bea68693          	addi	a3,a3,-1046 # ffffffffc020d4e0 <default_pmm_manager+0xd10>
ffffffffc02048fe:	00007617          	auipc	a2,0x7
ffffffffc0204902:	3ca60613          	addi	a2,a2,970 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204906:	02200593          	li	a1,34
ffffffffc020490a:	00009517          	auipc	a0,0x9
ffffffffc020490e:	bbe50513          	addi	a0,a0,-1090 # ffffffffc020d4c8 <default_pmm_manager+0xcf8>
ffffffffc0204912:	b8dfb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204916:	60e2                	ld	ra,24(sp)
ffffffffc0204918:	6442                	ld	s0,16(sp)
ffffffffc020491a:	64a2                	ld	s1,8(sp)
ffffffffc020491c:	6902                	ld	s2,0(sp)
ffffffffc020491e:	6105                	addi	sp,sp,32
ffffffffc0204920:	8082                	ret
ffffffffc0204922:	6798                	ld	a4,8(a5)
ffffffffc0204924:	02f70763          	beq	a4,a5,ffffffffc0204952 <wakeup_queue+0xae>
ffffffffc0204928:	6814                	ld	a3,16(s0)
ffffffffc020492a:	02d49463          	bne	s1,a3,ffffffffc0204952 <wakeup_queue+0xae>
ffffffffc020492e:	6c14                	ld	a3,24(s0)
ffffffffc0204930:	6008                	ld	a0,0(s0)
ffffffffc0204932:	e698                	sd	a4,8(a3)
ffffffffc0204934:	e314                	sd	a3,0(a4)
ffffffffc0204936:	f01c                	sd	a5,32(s0)
ffffffffc0204938:	ec1c                	sd	a5,24(s0)
ffffffffc020493a:	01242423          	sw	s2,8(s0)
ffffffffc020493e:	48f020ef          	jal	ra,ffffffffc02075cc <wakeup_proc>
ffffffffc0204942:	6480                	ld	s0,8(s1)
ffffffffc0204944:	fc8489e3          	beq	s1,s0,ffffffffc0204916 <wakeup_queue+0x72>
ffffffffc0204948:	6418                	ld	a4,8(s0)
ffffffffc020494a:	87a2                	mv	a5,s0
ffffffffc020494c:	1421                	addi	s0,s0,-24
ffffffffc020494e:	fce79de3          	bne	a5,a4,ffffffffc0204928 <wakeup_queue+0x84>
ffffffffc0204952:	00009697          	auipc	a3,0x9
ffffffffc0204956:	b8e68693          	addi	a3,a3,-1138 # ffffffffc020d4e0 <default_pmm_manager+0xd10>
ffffffffc020495a:	00007617          	auipc	a2,0x7
ffffffffc020495e:	36e60613          	addi	a2,a2,878 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204962:	45f1                	li	a1,28
ffffffffc0204964:	00009517          	auipc	a0,0x9
ffffffffc0204968:	b6450513          	addi	a0,a0,-1180 # ffffffffc020d4c8 <default_pmm_manager+0xcf8>
ffffffffc020496c:	b33fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204970:	8082                	ret

ffffffffc0204972 <wait_current_set>:
ffffffffc0204972:	00092797          	auipc	a5,0x92
ffffffffc0204976:	f5e7b783          	ld	a5,-162(a5) # ffffffffc02968d0 <current>
ffffffffc020497a:	c39d                	beqz	a5,ffffffffc02049a0 <wait_current_set+0x2e>
ffffffffc020497c:	01858713          	addi	a4,a1,24
ffffffffc0204980:	800006b7          	lui	a3,0x80000
ffffffffc0204984:	ed98                	sd	a4,24(a1)
ffffffffc0204986:	e19c                	sd	a5,0(a1)
ffffffffc0204988:	c594                	sw	a3,8(a1)
ffffffffc020498a:	4685                	li	a3,1
ffffffffc020498c:	c394                	sw	a3,0(a5)
ffffffffc020498e:	0ec7a623          	sw	a2,236(a5)
ffffffffc0204992:	611c                	ld	a5,0(a0)
ffffffffc0204994:	e988                	sd	a0,16(a1)
ffffffffc0204996:	e118                	sd	a4,0(a0)
ffffffffc0204998:	e798                	sd	a4,8(a5)
ffffffffc020499a:	f188                	sd	a0,32(a1)
ffffffffc020499c:	ed9c                	sd	a5,24(a1)
ffffffffc020499e:	8082                	ret
ffffffffc02049a0:	1141                	addi	sp,sp,-16
ffffffffc02049a2:	00009697          	auipc	a3,0x9
ffffffffc02049a6:	b7e68693          	addi	a3,a3,-1154 # ffffffffc020d520 <default_pmm_manager+0xd50>
ffffffffc02049aa:	00007617          	auipc	a2,0x7
ffffffffc02049ae:	31e60613          	addi	a2,a2,798 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02049b2:	07400593          	li	a1,116
ffffffffc02049b6:	00009517          	auipc	a0,0x9
ffffffffc02049ba:	b1250513          	addi	a0,a0,-1262 # ffffffffc020d4c8 <default_pmm_manager+0xcf8>
ffffffffc02049be:	e406                	sd	ra,8(sp)
ffffffffc02049c0:	adffb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02049c4 <get_fd_array.part.0>:
ffffffffc02049c4:	1141                	addi	sp,sp,-16
ffffffffc02049c6:	00009697          	auipc	a3,0x9
ffffffffc02049ca:	b6a68693          	addi	a3,a3,-1174 # ffffffffc020d530 <default_pmm_manager+0xd60>
ffffffffc02049ce:	00007617          	auipc	a2,0x7
ffffffffc02049d2:	2fa60613          	addi	a2,a2,762 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02049d6:	45d1                	li	a1,20
ffffffffc02049d8:	00009517          	auipc	a0,0x9
ffffffffc02049dc:	b8850513          	addi	a0,a0,-1144 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc02049e0:	e406                	sd	ra,8(sp)
ffffffffc02049e2:	abdfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02049e6 <fd_array_alloc>:
ffffffffc02049e6:	00092797          	auipc	a5,0x92
ffffffffc02049ea:	eea7b783          	ld	a5,-278(a5) # ffffffffc02968d0 <current>
ffffffffc02049ee:	1487b783          	ld	a5,328(a5)
ffffffffc02049f2:	1141                	addi	sp,sp,-16
ffffffffc02049f4:	e406                	sd	ra,8(sp)
ffffffffc02049f6:	c3a5                	beqz	a5,ffffffffc0204a56 <fd_array_alloc+0x70>
ffffffffc02049f8:	4b98                	lw	a4,16(a5)
ffffffffc02049fa:	04e05e63          	blez	a4,ffffffffc0204a56 <fd_array_alloc+0x70>
ffffffffc02049fe:	775d                	lui	a4,0xffff7
ffffffffc0204a00:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd601b9>
ffffffffc0204a04:	679c                	ld	a5,8(a5)
ffffffffc0204a06:	02e50863          	beq	a0,a4,ffffffffc0204a36 <fd_array_alloc+0x50>
ffffffffc0204a0a:	04700713          	li	a4,71
ffffffffc0204a0e:	04a76263          	bltu	a4,a0,ffffffffc0204a52 <fd_array_alloc+0x6c>
ffffffffc0204a12:	00351713          	slli	a4,a0,0x3
ffffffffc0204a16:	40a70533          	sub	a0,a4,a0
ffffffffc0204a1a:	050e                	slli	a0,a0,0x3
ffffffffc0204a1c:	97aa                	add	a5,a5,a0
ffffffffc0204a1e:	4398                	lw	a4,0(a5)
ffffffffc0204a20:	e71d                	bnez	a4,ffffffffc0204a4e <fd_array_alloc+0x68>
ffffffffc0204a22:	5b88                	lw	a0,48(a5)
ffffffffc0204a24:	e91d                	bnez	a0,ffffffffc0204a5a <fd_array_alloc+0x74>
ffffffffc0204a26:	4705                	li	a4,1
ffffffffc0204a28:	c398                	sw	a4,0(a5)
ffffffffc0204a2a:	0207b423          	sd	zero,40(a5)
ffffffffc0204a2e:	e19c                	sd	a5,0(a1)
ffffffffc0204a30:	60a2                	ld	ra,8(sp)
ffffffffc0204a32:	0141                	addi	sp,sp,16
ffffffffc0204a34:	8082                	ret
ffffffffc0204a36:	6685                	lui	a3,0x1
ffffffffc0204a38:	fc068693          	addi	a3,a3,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0204a3c:	96be                	add	a3,a3,a5
ffffffffc0204a3e:	4398                	lw	a4,0(a5)
ffffffffc0204a40:	d36d                	beqz	a4,ffffffffc0204a22 <fd_array_alloc+0x3c>
ffffffffc0204a42:	03878793          	addi	a5,a5,56
ffffffffc0204a46:	fef69ce3          	bne	a3,a5,ffffffffc0204a3e <fd_array_alloc+0x58>
ffffffffc0204a4a:	5529                	li	a0,-22
ffffffffc0204a4c:	b7d5                	j	ffffffffc0204a30 <fd_array_alloc+0x4a>
ffffffffc0204a4e:	5545                	li	a0,-15
ffffffffc0204a50:	b7c5                	j	ffffffffc0204a30 <fd_array_alloc+0x4a>
ffffffffc0204a52:	5575                	li	a0,-3
ffffffffc0204a54:	bff1                	j	ffffffffc0204a30 <fd_array_alloc+0x4a>
ffffffffc0204a56:	f6fff0ef          	jal	ra,ffffffffc02049c4 <get_fd_array.part.0>
ffffffffc0204a5a:	00009697          	auipc	a3,0x9
ffffffffc0204a5e:	b1668693          	addi	a3,a3,-1258 # ffffffffc020d570 <default_pmm_manager+0xda0>
ffffffffc0204a62:	00007617          	auipc	a2,0x7
ffffffffc0204a66:	26660613          	addi	a2,a2,614 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204a6a:	03b00593          	li	a1,59
ffffffffc0204a6e:	00009517          	auipc	a0,0x9
ffffffffc0204a72:	af250513          	addi	a0,a0,-1294 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0204a76:	a29fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204a7a <fd_array_free>:
ffffffffc0204a7a:	411c                	lw	a5,0(a0)
ffffffffc0204a7c:	1141                	addi	sp,sp,-16
ffffffffc0204a7e:	e022                	sd	s0,0(sp)
ffffffffc0204a80:	e406                	sd	ra,8(sp)
ffffffffc0204a82:	4705                	li	a4,1
ffffffffc0204a84:	842a                	mv	s0,a0
ffffffffc0204a86:	04e78063          	beq	a5,a4,ffffffffc0204ac6 <fd_array_free+0x4c>
ffffffffc0204a8a:	470d                	li	a4,3
ffffffffc0204a8c:	04e79563          	bne	a5,a4,ffffffffc0204ad6 <fd_array_free+0x5c>
ffffffffc0204a90:	591c                	lw	a5,48(a0)
ffffffffc0204a92:	c38d                	beqz	a5,ffffffffc0204ab4 <fd_array_free+0x3a>
ffffffffc0204a94:	00009697          	auipc	a3,0x9
ffffffffc0204a98:	adc68693          	addi	a3,a3,-1316 # ffffffffc020d570 <default_pmm_manager+0xda0>
ffffffffc0204a9c:	00007617          	auipc	a2,0x7
ffffffffc0204aa0:	22c60613          	addi	a2,a2,556 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204aa4:	04500593          	li	a1,69
ffffffffc0204aa8:	00009517          	auipc	a0,0x9
ffffffffc0204aac:	ab850513          	addi	a0,a0,-1352 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0204ab0:	9effb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204ab4:	7408                	ld	a0,40(s0)
ffffffffc0204ab6:	18d030ef          	jal	ra,ffffffffc0208442 <vfs_close>
ffffffffc0204aba:	60a2                	ld	ra,8(sp)
ffffffffc0204abc:	00042023          	sw	zero,0(s0)
ffffffffc0204ac0:	6402                	ld	s0,0(sp)
ffffffffc0204ac2:	0141                	addi	sp,sp,16
ffffffffc0204ac4:	8082                	ret
ffffffffc0204ac6:	591c                	lw	a5,48(a0)
ffffffffc0204ac8:	f7f1                	bnez	a5,ffffffffc0204a94 <fd_array_free+0x1a>
ffffffffc0204aca:	60a2                	ld	ra,8(sp)
ffffffffc0204acc:	00042023          	sw	zero,0(s0)
ffffffffc0204ad0:	6402                	ld	s0,0(sp)
ffffffffc0204ad2:	0141                	addi	sp,sp,16
ffffffffc0204ad4:	8082                	ret
ffffffffc0204ad6:	00009697          	auipc	a3,0x9
ffffffffc0204ada:	ad268693          	addi	a3,a3,-1326 # ffffffffc020d5a8 <default_pmm_manager+0xdd8>
ffffffffc0204ade:	00007617          	auipc	a2,0x7
ffffffffc0204ae2:	1ea60613          	addi	a2,a2,490 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204ae6:	04400593          	li	a1,68
ffffffffc0204aea:	00009517          	auipc	a0,0x9
ffffffffc0204aee:	a7650513          	addi	a0,a0,-1418 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0204af2:	9adfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204af6 <fd_array_release>:
ffffffffc0204af6:	4118                	lw	a4,0(a0)
ffffffffc0204af8:	1141                	addi	sp,sp,-16
ffffffffc0204afa:	e406                	sd	ra,8(sp)
ffffffffc0204afc:	4685                	li	a3,1
ffffffffc0204afe:	3779                	addiw	a4,a4,-2
ffffffffc0204b00:	04e6e063          	bltu	a3,a4,ffffffffc0204b40 <fd_array_release+0x4a>
ffffffffc0204b04:	5918                	lw	a4,48(a0)
ffffffffc0204b06:	00e05d63          	blez	a4,ffffffffc0204b20 <fd_array_release+0x2a>
ffffffffc0204b0a:	fff7069b          	addiw	a3,a4,-1
ffffffffc0204b0e:	d914                	sw	a3,48(a0)
ffffffffc0204b10:	c681                	beqz	a3,ffffffffc0204b18 <fd_array_release+0x22>
ffffffffc0204b12:	60a2                	ld	ra,8(sp)
ffffffffc0204b14:	0141                	addi	sp,sp,16
ffffffffc0204b16:	8082                	ret
ffffffffc0204b18:	60a2                	ld	ra,8(sp)
ffffffffc0204b1a:	0141                	addi	sp,sp,16
ffffffffc0204b1c:	f5fff06f          	j	ffffffffc0204a7a <fd_array_free>
ffffffffc0204b20:	00009697          	auipc	a3,0x9
ffffffffc0204b24:	af868693          	addi	a3,a3,-1288 # ffffffffc020d618 <default_pmm_manager+0xe48>
ffffffffc0204b28:	00007617          	auipc	a2,0x7
ffffffffc0204b2c:	1a060613          	addi	a2,a2,416 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204b30:	05600593          	li	a1,86
ffffffffc0204b34:	00009517          	auipc	a0,0x9
ffffffffc0204b38:	a2c50513          	addi	a0,a0,-1492 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0204b3c:	963fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204b40:	00009697          	auipc	a3,0x9
ffffffffc0204b44:	aa068693          	addi	a3,a3,-1376 # ffffffffc020d5e0 <default_pmm_manager+0xe10>
ffffffffc0204b48:	00007617          	auipc	a2,0x7
ffffffffc0204b4c:	18060613          	addi	a2,a2,384 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204b50:	05500593          	li	a1,85
ffffffffc0204b54:	00009517          	auipc	a0,0x9
ffffffffc0204b58:	a0c50513          	addi	a0,a0,-1524 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0204b5c:	943fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204b60 <fd_array_open.part.0>:
ffffffffc0204b60:	1141                	addi	sp,sp,-16
ffffffffc0204b62:	00009697          	auipc	a3,0x9
ffffffffc0204b66:	ace68693          	addi	a3,a3,-1330 # ffffffffc020d630 <default_pmm_manager+0xe60>
ffffffffc0204b6a:	00007617          	auipc	a2,0x7
ffffffffc0204b6e:	15e60613          	addi	a2,a2,350 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204b72:	05f00593          	li	a1,95
ffffffffc0204b76:	00009517          	auipc	a0,0x9
ffffffffc0204b7a:	9ea50513          	addi	a0,a0,-1558 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0204b7e:	e406                	sd	ra,8(sp)
ffffffffc0204b80:	91ffb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204b84 <fd_array_init>:
ffffffffc0204b84:	4781                	li	a5,0
ffffffffc0204b86:	04800713          	li	a4,72
ffffffffc0204b8a:	cd1c                	sw	a5,24(a0)
ffffffffc0204b8c:	02052823          	sw	zero,48(a0)
ffffffffc0204b90:	00052023          	sw	zero,0(a0)
ffffffffc0204b94:	2785                	addiw	a5,a5,1
ffffffffc0204b96:	03850513          	addi	a0,a0,56
ffffffffc0204b9a:	fee798e3          	bne	a5,a4,ffffffffc0204b8a <fd_array_init+0x6>
ffffffffc0204b9e:	8082                	ret

ffffffffc0204ba0 <fd_array_close>:
ffffffffc0204ba0:	4118                	lw	a4,0(a0)
ffffffffc0204ba2:	1141                	addi	sp,sp,-16
ffffffffc0204ba4:	e406                	sd	ra,8(sp)
ffffffffc0204ba6:	e022                	sd	s0,0(sp)
ffffffffc0204ba8:	4789                	li	a5,2
ffffffffc0204baa:	04f71a63          	bne	a4,a5,ffffffffc0204bfe <fd_array_close+0x5e>
ffffffffc0204bae:	591c                	lw	a5,48(a0)
ffffffffc0204bb0:	842a                	mv	s0,a0
ffffffffc0204bb2:	02f05663          	blez	a5,ffffffffc0204bde <fd_array_close+0x3e>
ffffffffc0204bb6:	37fd                	addiw	a5,a5,-1
ffffffffc0204bb8:	470d                	li	a4,3
ffffffffc0204bba:	c118                	sw	a4,0(a0)
ffffffffc0204bbc:	d91c                	sw	a5,48(a0)
ffffffffc0204bbe:	0007871b          	sext.w	a4,a5
ffffffffc0204bc2:	c709                	beqz	a4,ffffffffc0204bcc <fd_array_close+0x2c>
ffffffffc0204bc4:	60a2                	ld	ra,8(sp)
ffffffffc0204bc6:	6402                	ld	s0,0(sp)
ffffffffc0204bc8:	0141                	addi	sp,sp,16
ffffffffc0204bca:	8082                	ret
ffffffffc0204bcc:	7508                	ld	a0,40(a0)
ffffffffc0204bce:	075030ef          	jal	ra,ffffffffc0208442 <vfs_close>
ffffffffc0204bd2:	60a2                	ld	ra,8(sp)
ffffffffc0204bd4:	00042023          	sw	zero,0(s0)
ffffffffc0204bd8:	6402                	ld	s0,0(sp)
ffffffffc0204bda:	0141                	addi	sp,sp,16
ffffffffc0204bdc:	8082                	ret
ffffffffc0204bde:	00009697          	auipc	a3,0x9
ffffffffc0204be2:	a3a68693          	addi	a3,a3,-1478 # ffffffffc020d618 <default_pmm_manager+0xe48>
ffffffffc0204be6:	00007617          	auipc	a2,0x7
ffffffffc0204bea:	0e260613          	addi	a2,a2,226 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204bee:	06800593          	li	a1,104
ffffffffc0204bf2:	00009517          	auipc	a0,0x9
ffffffffc0204bf6:	96e50513          	addi	a0,a0,-1682 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0204bfa:	8a5fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204bfe:	00009697          	auipc	a3,0x9
ffffffffc0204c02:	98a68693          	addi	a3,a3,-1654 # ffffffffc020d588 <default_pmm_manager+0xdb8>
ffffffffc0204c06:	00007617          	auipc	a2,0x7
ffffffffc0204c0a:	0c260613          	addi	a2,a2,194 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204c0e:	06700593          	li	a1,103
ffffffffc0204c12:	00009517          	auipc	a0,0x9
ffffffffc0204c16:	94e50513          	addi	a0,a0,-1714 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0204c1a:	885fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204c1e <fd_array_dup>:
ffffffffc0204c1e:	7179                	addi	sp,sp,-48
ffffffffc0204c20:	e84a                	sd	s2,16(sp)
ffffffffc0204c22:	00052903          	lw	s2,0(a0)
ffffffffc0204c26:	f406                	sd	ra,40(sp)
ffffffffc0204c28:	f022                	sd	s0,32(sp)
ffffffffc0204c2a:	ec26                	sd	s1,24(sp)
ffffffffc0204c2c:	e44e                	sd	s3,8(sp)
ffffffffc0204c2e:	4785                	li	a5,1
ffffffffc0204c30:	04f91663          	bne	s2,a5,ffffffffc0204c7c <fd_array_dup+0x5e>
ffffffffc0204c34:	0005a983          	lw	s3,0(a1)
ffffffffc0204c38:	4789                	li	a5,2
ffffffffc0204c3a:	04f99163          	bne	s3,a5,ffffffffc0204c7c <fd_array_dup+0x5e>
ffffffffc0204c3e:	7584                	ld	s1,40(a1)
ffffffffc0204c40:	699c                	ld	a5,16(a1)
ffffffffc0204c42:	7194                	ld	a3,32(a1)
ffffffffc0204c44:	6598                	ld	a4,8(a1)
ffffffffc0204c46:	842a                	mv	s0,a0
ffffffffc0204c48:	e91c                	sd	a5,16(a0)
ffffffffc0204c4a:	f114                	sd	a3,32(a0)
ffffffffc0204c4c:	e518                	sd	a4,8(a0)
ffffffffc0204c4e:	8526                	mv	a0,s1
ffffffffc0204c50:	751020ef          	jal	ra,ffffffffc0207ba0 <inode_ref_inc>
ffffffffc0204c54:	8526                	mv	a0,s1
ffffffffc0204c56:	757020ef          	jal	ra,ffffffffc0207bac <inode_open_inc>
ffffffffc0204c5a:	401c                	lw	a5,0(s0)
ffffffffc0204c5c:	f404                	sd	s1,40(s0)
ffffffffc0204c5e:	03279f63          	bne	a5,s2,ffffffffc0204c9c <fd_array_dup+0x7e>
ffffffffc0204c62:	cc8d                	beqz	s1,ffffffffc0204c9c <fd_array_dup+0x7e>
ffffffffc0204c64:	581c                	lw	a5,48(s0)
ffffffffc0204c66:	01342023          	sw	s3,0(s0)
ffffffffc0204c6a:	70a2                	ld	ra,40(sp)
ffffffffc0204c6c:	2785                	addiw	a5,a5,1
ffffffffc0204c6e:	d81c                	sw	a5,48(s0)
ffffffffc0204c70:	7402                	ld	s0,32(sp)
ffffffffc0204c72:	64e2                	ld	s1,24(sp)
ffffffffc0204c74:	6942                	ld	s2,16(sp)
ffffffffc0204c76:	69a2                	ld	s3,8(sp)
ffffffffc0204c78:	6145                	addi	sp,sp,48
ffffffffc0204c7a:	8082                	ret
ffffffffc0204c7c:	00009697          	auipc	a3,0x9
ffffffffc0204c80:	9e468693          	addi	a3,a3,-1564 # ffffffffc020d660 <default_pmm_manager+0xe90>
ffffffffc0204c84:	00007617          	auipc	a2,0x7
ffffffffc0204c88:	04460613          	addi	a2,a2,68 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204c8c:	07300593          	li	a1,115
ffffffffc0204c90:	00009517          	auipc	a0,0x9
ffffffffc0204c94:	8d050513          	addi	a0,a0,-1840 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0204c98:	807fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204c9c:	ec5ff0ef          	jal	ra,ffffffffc0204b60 <fd_array_open.part.0>

ffffffffc0204ca0 <file_testfd>:
ffffffffc0204ca0:	04700793          	li	a5,71
ffffffffc0204ca4:	04a7e263          	bltu	a5,a0,ffffffffc0204ce8 <file_testfd+0x48>
ffffffffc0204ca8:	00092797          	auipc	a5,0x92
ffffffffc0204cac:	c287b783          	ld	a5,-984(a5) # ffffffffc02968d0 <current>
ffffffffc0204cb0:	1487b783          	ld	a5,328(a5)
ffffffffc0204cb4:	cf85                	beqz	a5,ffffffffc0204cec <file_testfd+0x4c>
ffffffffc0204cb6:	4b98                	lw	a4,16(a5)
ffffffffc0204cb8:	02e05a63          	blez	a4,ffffffffc0204cec <file_testfd+0x4c>
ffffffffc0204cbc:	6798                	ld	a4,8(a5)
ffffffffc0204cbe:	00351793          	slli	a5,a0,0x3
ffffffffc0204cc2:	8f89                	sub	a5,a5,a0
ffffffffc0204cc4:	078e                	slli	a5,a5,0x3
ffffffffc0204cc6:	97ba                	add	a5,a5,a4
ffffffffc0204cc8:	4394                	lw	a3,0(a5)
ffffffffc0204cca:	4709                	li	a4,2
ffffffffc0204ccc:	00e69e63          	bne	a3,a4,ffffffffc0204ce8 <file_testfd+0x48>
ffffffffc0204cd0:	4f98                	lw	a4,24(a5)
ffffffffc0204cd2:	00a71b63          	bne	a4,a0,ffffffffc0204ce8 <file_testfd+0x48>
ffffffffc0204cd6:	c199                	beqz	a1,ffffffffc0204cdc <file_testfd+0x3c>
ffffffffc0204cd8:	6788                	ld	a0,8(a5)
ffffffffc0204cda:	c901                	beqz	a0,ffffffffc0204cea <file_testfd+0x4a>
ffffffffc0204cdc:	4505                	li	a0,1
ffffffffc0204cde:	c611                	beqz	a2,ffffffffc0204cea <file_testfd+0x4a>
ffffffffc0204ce0:	6b88                	ld	a0,16(a5)
ffffffffc0204ce2:	00a03533          	snez	a0,a0
ffffffffc0204ce6:	8082                	ret
ffffffffc0204ce8:	4501                	li	a0,0
ffffffffc0204cea:	8082                	ret
ffffffffc0204cec:	1141                	addi	sp,sp,-16
ffffffffc0204cee:	e406                	sd	ra,8(sp)
ffffffffc0204cf0:	cd5ff0ef          	jal	ra,ffffffffc02049c4 <get_fd_array.part.0>

ffffffffc0204cf4 <file_open>:
ffffffffc0204cf4:	711d                	addi	sp,sp,-96
ffffffffc0204cf6:	ec86                	sd	ra,88(sp)
ffffffffc0204cf8:	e8a2                	sd	s0,80(sp)
ffffffffc0204cfa:	e4a6                	sd	s1,72(sp)
ffffffffc0204cfc:	e0ca                	sd	s2,64(sp)
ffffffffc0204cfe:	fc4e                	sd	s3,56(sp)
ffffffffc0204d00:	f852                	sd	s4,48(sp)
ffffffffc0204d02:	0035f793          	andi	a5,a1,3
ffffffffc0204d06:	470d                	li	a4,3
ffffffffc0204d08:	0ce78163          	beq	a5,a4,ffffffffc0204dca <file_open+0xd6>
ffffffffc0204d0c:	078e                	slli	a5,a5,0x3
ffffffffc0204d0e:	00009717          	auipc	a4,0x9
ffffffffc0204d12:	bc270713          	addi	a4,a4,-1086 # ffffffffc020d8d0 <CSWTCH.79>
ffffffffc0204d16:	892a                	mv	s2,a0
ffffffffc0204d18:	00009697          	auipc	a3,0x9
ffffffffc0204d1c:	ba068693          	addi	a3,a3,-1120 # ffffffffc020d8b8 <CSWTCH.78>
ffffffffc0204d20:	755d                	lui	a0,0xffff7
ffffffffc0204d22:	96be                	add	a3,a3,a5
ffffffffc0204d24:	84ae                	mv	s1,a1
ffffffffc0204d26:	97ba                	add	a5,a5,a4
ffffffffc0204d28:	858a                	mv	a1,sp
ffffffffc0204d2a:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd601b9>
ffffffffc0204d2e:	0006ba03          	ld	s4,0(a3)
ffffffffc0204d32:	0007b983          	ld	s3,0(a5)
ffffffffc0204d36:	cb1ff0ef          	jal	ra,ffffffffc02049e6 <fd_array_alloc>
ffffffffc0204d3a:	842a                	mv	s0,a0
ffffffffc0204d3c:	c911                	beqz	a0,ffffffffc0204d50 <file_open+0x5c>
ffffffffc0204d3e:	60e6                	ld	ra,88(sp)
ffffffffc0204d40:	8522                	mv	a0,s0
ffffffffc0204d42:	6446                	ld	s0,80(sp)
ffffffffc0204d44:	64a6                	ld	s1,72(sp)
ffffffffc0204d46:	6906                	ld	s2,64(sp)
ffffffffc0204d48:	79e2                	ld	s3,56(sp)
ffffffffc0204d4a:	7a42                	ld	s4,48(sp)
ffffffffc0204d4c:	6125                	addi	sp,sp,96
ffffffffc0204d4e:	8082                	ret
ffffffffc0204d50:	0030                	addi	a2,sp,8
ffffffffc0204d52:	85a6                	mv	a1,s1
ffffffffc0204d54:	854a                	mv	a0,s2
ffffffffc0204d56:	546030ef          	jal	ra,ffffffffc020829c <vfs_open>
ffffffffc0204d5a:	842a                	mv	s0,a0
ffffffffc0204d5c:	e13d                	bnez	a0,ffffffffc0204dc2 <file_open+0xce>
ffffffffc0204d5e:	6782                	ld	a5,0(sp)
ffffffffc0204d60:	0204f493          	andi	s1,s1,32
ffffffffc0204d64:	6422                	ld	s0,8(sp)
ffffffffc0204d66:	0207b023          	sd	zero,32(a5)
ffffffffc0204d6a:	c885                	beqz	s1,ffffffffc0204d9a <file_open+0xa6>
ffffffffc0204d6c:	c03d                	beqz	s0,ffffffffc0204dd2 <file_open+0xde>
ffffffffc0204d6e:	783c                	ld	a5,112(s0)
ffffffffc0204d70:	c3ad                	beqz	a5,ffffffffc0204dd2 <file_open+0xde>
ffffffffc0204d72:	779c                	ld	a5,40(a5)
ffffffffc0204d74:	cfb9                	beqz	a5,ffffffffc0204dd2 <file_open+0xde>
ffffffffc0204d76:	8522                	mv	a0,s0
ffffffffc0204d78:	00009597          	auipc	a1,0x9
ffffffffc0204d7c:	97058593          	addi	a1,a1,-1680 # ffffffffc020d6e8 <default_pmm_manager+0xf18>
ffffffffc0204d80:	639020ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0204d84:	783c                	ld	a5,112(s0)
ffffffffc0204d86:	6522                	ld	a0,8(sp)
ffffffffc0204d88:	080c                	addi	a1,sp,16
ffffffffc0204d8a:	779c                	ld	a5,40(a5)
ffffffffc0204d8c:	9782                	jalr	a5
ffffffffc0204d8e:	842a                	mv	s0,a0
ffffffffc0204d90:	e515                	bnez	a0,ffffffffc0204dbc <file_open+0xc8>
ffffffffc0204d92:	6782                	ld	a5,0(sp)
ffffffffc0204d94:	7722                	ld	a4,40(sp)
ffffffffc0204d96:	6422                	ld	s0,8(sp)
ffffffffc0204d98:	f398                	sd	a4,32(a5)
ffffffffc0204d9a:	4394                	lw	a3,0(a5)
ffffffffc0204d9c:	f780                	sd	s0,40(a5)
ffffffffc0204d9e:	0147b423          	sd	s4,8(a5)
ffffffffc0204da2:	0137b823          	sd	s3,16(a5)
ffffffffc0204da6:	4705                	li	a4,1
ffffffffc0204da8:	02e69363          	bne	a3,a4,ffffffffc0204dce <file_open+0xda>
ffffffffc0204dac:	c00d                	beqz	s0,ffffffffc0204dce <file_open+0xda>
ffffffffc0204dae:	5b98                	lw	a4,48(a5)
ffffffffc0204db0:	4689                	li	a3,2
ffffffffc0204db2:	4f80                	lw	s0,24(a5)
ffffffffc0204db4:	2705                	addiw	a4,a4,1
ffffffffc0204db6:	c394                	sw	a3,0(a5)
ffffffffc0204db8:	db98                	sw	a4,48(a5)
ffffffffc0204dba:	b751                	j	ffffffffc0204d3e <file_open+0x4a>
ffffffffc0204dbc:	6522                	ld	a0,8(sp)
ffffffffc0204dbe:	684030ef          	jal	ra,ffffffffc0208442 <vfs_close>
ffffffffc0204dc2:	6502                	ld	a0,0(sp)
ffffffffc0204dc4:	cb7ff0ef          	jal	ra,ffffffffc0204a7a <fd_array_free>
ffffffffc0204dc8:	bf9d                	j	ffffffffc0204d3e <file_open+0x4a>
ffffffffc0204dca:	5475                	li	s0,-3
ffffffffc0204dcc:	bf8d                	j	ffffffffc0204d3e <file_open+0x4a>
ffffffffc0204dce:	d93ff0ef          	jal	ra,ffffffffc0204b60 <fd_array_open.part.0>
ffffffffc0204dd2:	00009697          	auipc	a3,0x9
ffffffffc0204dd6:	8c668693          	addi	a3,a3,-1850 # ffffffffc020d698 <default_pmm_manager+0xec8>
ffffffffc0204dda:	00007617          	auipc	a2,0x7
ffffffffc0204dde:	eee60613          	addi	a2,a2,-274 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204de2:	0b500593          	li	a1,181
ffffffffc0204de6:	00008517          	auipc	a0,0x8
ffffffffc0204dea:	77a50513          	addi	a0,a0,1914 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0204dee:	eb0fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204df2 <file_close>:
ffffffffc0204df2:	04700713          	li	a4,71
ffffffffc0204df6:	04a76563          	bltu	a4,a0,ffffffffc0204e40 <file_close+0x4e>
ffffffffc0204dfa:	00092717          	auipc	a4,0x92
ffffffffc0204dfe:	ad673703          	ld	a4,-1322(a4) # ffffffffc02968d0 <current>
ffffffffc0204e02:	14873703          	ld	a4,328(a4)
ffffffffc0204e06:	1141                	addi	sp,sp,-16
ffffffffc0204e08:	e406                	sd	ra,8(sp)
ffffffffc0204e0a:	cf0d                	beqz	a4,ffffffffc0204e44 <file_close+0x52>
ffffffffc0204e0c:	4b14                	lw	a3,16(a4)
ffffffffc0204e0e:	02d05b63          	blez	a3,ffffffffc0204e44 <file_close+0x52>
ffffffffc0204e12:	6718                	ld	a4,8(a4)
ffffffffc0204e14:	87aa                	mv	a5,a0
ffffffffc0204e16:	050e                	slli	a0,a0,0x3
ffffffffc0204e18:	8d1d                	sub	a0,a0,a5
ffffffffc0204e1a:	050e                	slli	a0,a0,0x3
ffffffffc0204e1c:	953a                	add	a0,a0,a4
ffffffffc0204e1e:	4114                	lw	a3,0(a0)
ffffffffc0204e20:	4709                	li	a4,2
ffffffffc0204e22:	00e69b63          	bne	a3,a4,ffffffffc0204e38 <file_close+0x46>
ffffffffc0204e26:	4d18                	lw	a4,24(a0)
ffffffffc0204e28:	00f71863          	bne	a4,a5,ffffffffc0204e38 <file_close+0x46>
ffffffffc0204e2c:	d75ff0ef          	jal	ra,ffffffffc0204ba0 <fd_array_close>
ffffffffc0204e30:	60a2                	ld	ra,8(sp)
ffffffffc0204e32:	4501                	li	a0,0
ffffffffc0204e34:	0141                	addi	sp,sp,16
ffffffffc0204e36:	8082                	ret
ffffffffc0204e38:	60a2                	ld	ra,8(sp)
ffffffffc0204e3a:	5575                	li	a0,-3
ffffffffc0204e3c:	0141                	addi	sp,sp,16
ffffffffc0204e3e:	8082                	ret
ffffffffc0204e40:	5575                	li	a0,-3
ffffffffc0204e42:	8082                	ret
ffffffffc0204e44:	b81ff0ef          	jal	ra,ffffffffc02049c4 <get_fd_array.part.0>

ffffffffc0204e48 <file_read>:
ffffffffc0204e48:	715d                	addi	sp,sp,-80
ffffffffc0204e4a:	e486                	sd	ra,72(sp)
ffffffffc0204e4c:	e0a2                	sd	s0,64(sp)
ffffffffc0204e4e:	fc26                	sd	s1,56(sp)
ffffffffc0204e50:	f84a                	sd	s2,48(sp)
ffffffffc0204e52:	f44e                	sd	s3,40(sp)
ffffffffc0204e54:	f052                	sd	s4,32(sp)
ffffffffc0204e56:	0006b023          	sd	zero,0(a3)
ffffffffc0204e5a:	04700793          	li	a5,71
ffffffffc0204e5e:	0aa7e463          	bltu	a5,a0,ffffffffc0204f06 <file_read+0xbe>
ffffffffc0204e62:	00092797          	auipc	a5,0x92
ffffffffc0204e66:	a6e7b783          	ld	a5,-1426(a5) # ffffffffc02968d0 <current>
ffffffffc0204e6a:	1487b783          	ld	a5,328(a5)
ffffffffc0204e6e:	cfd1                	beqz	a5,ffffffffc0204f0a <file_read+0xc2>
ffffffffc0204e70:	4b98                	lw	a4,16(a5)
ffffffffc0204e72:	08e05c63          	blez	a4,ffffffffc0204f0a <file_read+0xc2>
ffffffffc0204e76:	6780                	ld	s0,8(a5)
ffffffffc0204e78:	00351793          	slli	a5,a0,0x3
ffffffffc0204e7c:	8f89                	sub	a5,a5,a0
ffffffffc0204e7e:	078e                	slli	a5,a5,0x3
ffffffffc0204e80:	943e                	add	s0,s0,a5
ffffffffc0204e82:	00042983          	lw	s3,0(s0)
ffffffffc0204e86:	4789                	li	a5,2
ffffffffc0204e88:	06f99f63          	bne	s3,a5,ffffffffc0204f06 <file_read+0xbe>
ffffffffc0204e8c:	4c1c                	lw	a5,24(s0)
ffffffffc0204e8e:	06a79c63          	bne	a5,a0,ffffffffc0204f06 <file_read+0xbe>
ffffffffc0204e92:	641c                	ld	a5,8(s0)
ffffffffc0204e94:	cbad                	beqz	a5,ffffffffc0204f06 <file_read+0xbe>
ffffffffc0204e96:	581c                	lw	a5,48(s0)
ffffffffc0204e98:	8a36                	mv	s4,a3
ffffffffc0204e9a:	7014                	ld	a3,32(s0)
ffffffffc0204e9c:	2785                	addiw	a5,a5,1
ffffffffc0204e9e:	850a                	mv	a0,sp
ffffffffc0204ea0:	d81c                	sw	a5,48(s0)
ffffffffc0204ea2:	792000ef          	jal	ra,ffffffffc0205634 <iobuf_init>
ffffffffc0204ea6:	02843903          	ld	s2,40(s0)
ffffffffc0204eaa:	84aa                	mv	s1,a0
ffffffffc0204eac:	06090163          	beqz	s2,ffffffffc0204f0e <file_read+0xc6>
ffffffffc0204eb0:	07093783          	ld	a5,112(s2)
ffffffffc0204eb4:	cfa9                	beqz	a5,ffffffffc0204f0e <file_read+0xc6>
ffffffffc0204eb6:	6f9c                	ld	a5,24(a5)
ffffffffc0204eb8:	cbb9                	beqz	a5,ffffffffc0204f0e <file_read+0xc6>
ffffffffc0204eba:	00009597          	auipc	a1,0x9
ffffffffc0204ebe:	88658593          	addi	a1,a1,-1914 # ffffffffc020d740 <default_pmm_manager+0xf70>
ffffffffc0204ec2:	854a                	mv	a0,s2
ffffffffc0204ec4:	4f5020ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0204ec8:	07093783          	ld	a5,112(s2)
ffffffffc0204ecc:	7408                	ld	a0,40(s0)
ffffffffc0204ece:	85a6                	mv	a1,s1
ffffffffc0204ed0:	6f9c                	ld	a5,24(a5)
ffffffffc0204ed2:	9782                	jalr	a5
ffffffffc0204ed4:	689c                	ld	a5,16(s1)
ffffffffc0204ed6:	6c94                	ld	a3,24(s1)
ffffffffc0204ed8:	4018                	lw	a4,0(s0)
ffffffffc0204eda:	84aa                	mv	s1,a0
ffffffffc0204edc:	8f95                	sub	a5,a5,a3
ffffffffc0204ede:	03370063          	beq	a4,s3,ffffffffc0204efe <file_read+0xb6>
ffffffffc0204ee2:	00fa3023          	sd	a5,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0204ee6:	8522                	mv	a0,s0
ffffffffc0204ee8:	c0fff0ef          	jal	ra,ffffffffc0204af6 <fd_array_release>
ffffffffc0204eec:	60a6                	ld	ra,72(sp)
ffffffffc0204eee:	6406                	ld	s0,64(sp)
ffffffffc0204ef0:	7942                	ld	s2,48(sp)
ffffffffc0204ef2:	79a2                	ld	s3,40(sp)
ffffffffc0204ef4:	7a02                	ld	s4,32(sp)
ffffffffc0204ef6:	8526                	mv	a0,s1
ffffffffc0204ef8:	74e2                	ld	s1,56(sp)
ffffffffc0204efa:	6161                	addi	sp,sp,80
ffffffffc0204efc:	8082                	ret
ffffffffc0204efe:	7018                	ld	a4,32(s0)
ffffffffc0204f00:	973e                	add	a4,a4,a5
ffffffffc0204f02:	f018                	sd	a4,32(s0)
ffffffffc0204f04:	bff9                	j	ffffffffc0204ee2 <file_read+0x9a>
ffffffffc0204f06:	54f5                	li	s1,-3
ffffffffc0204f08:	b7d5                	j	ffffffffc0204eec <file_read+0xa4>
ffffffffc0204f0a:	abbff0ef          	jal	ra,ffffffffc02049c4 <get_fd_array.part.0>
ffffffffc0204f0e:	00008697          	auipc	a3,0x8
ffffffffc0204f12:	7e268693          	addi	a3,a3,2018 # ffffffffc020d6f0 <default_pmm_manager+0xf20>
ffffffffc0204f16:	00007617          	auipc	a2,0x7
ffffffffc0204f1a:	db260613          	addi	a2,a2,-590 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0204f1e:	0de00593          	li	a1,222
ffffffffc0204f22:	00008517          	auipc	a0,0x8
ffffffffc0204f26:	63e50513          	addi	a0,a0,1598 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0204f2a:	d74fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204f2e <file_write>:
ffffffffc0204f2e:	715d                	addi	sp,sp,-80
ffffffffc0204f30:	e486                	sd	ra,72(sp)
ffffffffc0204f32:	e0a2                	sd	s0,64(sp)
ffffffffc0204f34:	fc26                	sd	s1,56(sp)
ffffffffc0204f36:	f84a                	sd	s2,48(sp)
ffffffffc0204f38:	f44e                	sd	s3,40(sp)
ffffffffc0204f3a:	f052                	sd	s4,32(sp)
ffffffffc0204f3c:	0006b023          	sd	zero,0(a3)
ffffffffc0204f40:	04700793          	li	a5,71
ffffffffc0204f44:	0aa7e463          	bltu	a5,a0,ffffffffc0204fec <file_write+0xbe>
ffffffffc0204f48:	00092797          	auipc	a5,0x92
ffffffffc0204f4c:	9887b783          	ld	a5,-1656(a5) # ffffffffc02968d0 <current>
ffffffffc0204f50:	1487b783          	ld	a5,328(a5)
ffffffffc0204f54:	cfd1                	beqz	a5,ffffffffc0204ff0 <file_write+0xc2>
ffffffffc0204f56:	4b98                	lw	a4,16(a5)
ffffffffc0204f58:	08e05c63          	blez	a4,ffffffffc0204ff0 <file_write+0xc2>
ffffffffc0204f5c:	6780                	ld	s0,8(a5)
ffffffffc0204f5e:	00351793          	slli	a5,a0,0x3
ffffffffc0204f62:	8f89                	sub	a5,a5,a0
ffffffffc0204f64:	078e                	slli	a5,a5,0x3
ffffffffc0204f66:	943e                	add	s0,s0,a5
ffffffffc0204f68:	00042983          	lw	s3,0(s0)
ffffffffc0204f6c:	4789                	li	a5,2
ffffffffc0204f6e:	06f99f63          	bne	s3,a5,ffffffffc0204fec <file_write+0xbe>
ffffffffc0204f72:	4c1c                	lw	a5,24(s0)
ffffffffc0204f74:	06a79c63          	bne	a5,a0,ffffffffc0204fec <file_write+0xbe>
ffffffffc0204f78:	681c                	ld	a5,16(s0)
ffffffffc0204f7a:	cbad                	beqz	a5,ffffffffc0204fec <file_write+0xbe>
ffffffffc0204f7c:	581c                	lw	a5,48(s0)
ffffffffc0204f7e:	8a36                	mv	s4,a3
ffffffffc0204f80:	7014                	ld	a3,32(s0)
ffffffffc0204f82:	2785                	addiw	a5,a5,1
ffffffffc0204f84:	850a                	mv	a0,sp
ffffffffc0204f86:	d81c                	sw	a5,48(s0)
ffffffffc0204f88:	6ac000ef          	jal	ra,ffffffffc0205634 <iobuf_init>
ffffffffc0204f8c:	02843903          	ld	s2,40(s0)
ffffffffc0204f90:	84aa                	mv	s1,a0
ffffffffc0204f92:	06090163          	beqz	s2,ffffffffc0204ff4 <file_write+0xc6>
ffffffffc0204f96:	07093783          	ld	a5,112(s2)
ffffffffc0204f9a:	cfa9                	beqz	a5,ffffffffc0204ff4 <file_write+0xc6>
ffffffffc0204f9c:	739c                	ld	a5,32(a5)
ffffffffc0204f9e:	cbb9                	beqz	a5,ffffffffc0204ff4 <file_write+0xc6>
ffffffffc0204fa0:	00008597          	auipc	a1,0x8
ffffffffc0204fa4:	7f858593          	addi	a1,a1,2040 # ffffffffc020d798 <default_pmm_manager+0xfc8>
ffffffffc0204fa8:	854a                	mv	a0,s2
ffffffffc0204faa:	40f020ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0204fae:	07093783          	ld	a5,112(s2)
ffffffffc0204fb2:	7408                	ld	a0,40(s0)
ffffffffc0204fb4:	85a6                	mv	a1,s1
ffffffffc0204fb6:	739c                	ld	a5,32(a5)
ffffffffc0204fb8:	9782                	jalr	a5
ffffffffc0204fba:	689c                	ld	a5,16(s1)
ffffffffc0204fbc:	6c94                	ld	a3,24(s1)
ffffffffc0204fbe:	4018                	lw	a4,0(s0)
ffffffffc0204fc0:	84aa                	mv	s1,a0
ffffffffc0204fc2:	8f95                	sub	a5,a5,a3
ffffffffc0204fc4:	03370063          	beq	a4,s3,ffffffffc0204fe4 <file_write+0xb6>
ffffffffc0204fc8:	00fa3023          	sd	a5,0(s4)
ffffffffc0204fcc:	8522                	mv	a0,s0
ffffffffc0204fce:	b29ff0ef          	jal	ra,ffffffffc0204af6 <fd_array_release>
ffffffffc0204fd2:	60a6                	ld	ra,72(sp)
ffffffffc0204fd4:	6406                	ld	s0,64(sp)
ffffffffc0204fd6:	7942                	ld	s2,48(sp)
ffffffffc0204fd8:	79a2                	ld	s3,40(sp)
ffffffffc0204fda:	7a02                	ld	s4,32(sp)
ffffffffc0204fdc:	8526                	mv	a0,s1
ffffffffc0204fde:	74e2                	ld	s1,56(sp)
ffffffffc0204fe0:	6161                	addi	sp,sp,80
ffffffffc0204fe2:	8082                	ret
ffffffffc0204fe4:	7018                	ld	a4,32(s0)
ffffffffc0204fe6:	973e                	add	a4,a4,a5
ffffffffc0204fe8:	f018                	sd	a4,32(s0)
ffffffffc0204fea:	bff9                	j	ffffffffc0204fc8 <file_write+0x9a>
ffffffffc0204fec:	54f5                	li	s1,-3
ffffffffc0204fee:	b7d5                	j	ffffffffc0204fd2 <file_write+0xa4>
ffffffffc0204ff0:	9d5ff0ef          	jal	ra,ffffffffc02049c4 <get_fd_array.part.0>
ffffffffc0204ff4:	00008697          	auipc	a3,0x8
ffffffffc0204ff8:	75468693          	addi	a3,a3,1876 # ffffffffc020d748 <default_pmm_manager+0xf78>
ffffffffc0204ffc:	00007617          	auipc	a2,0x7
ffffffffc0205000:	ccc60613          	addi	a2,a2,-820 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0205004:	0f800593          	li	a1,248
ffffffffc0205008:	00008517          	auipc	a0,0x8
ffffffffc020500c:	55850513          	addi	a0,a0,1368 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0205010:	c8efb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205014 <file_seek>:
ffffffffc0205014:	7139                	addi	sp,sp,-64
ffffffffc0205016:	fc06                	sd	ra,56(sp)
ffffffffc0205018:	f822                	sd	s0,48(sp)
ffffffffc020501a:	f426                	sd	s1,40(sp)
ffffffffc020501c:	f04a                	sd	s2,32(sp)
ffffffffc020501e:	04700793          	li	a5,71
ffffffffc0205022:	08a7e863          	bltu	a5,a0,ffffffffc02050b2 <file_seek+0x9e>
ffffffffc0205026:	00092797          	auipc	a5,0x92
ffffffffc020502a:	8aa7b783          	ld	a5,-1878(a5) # ffffffffc02968d0 <current>
ffffffffc020502e:	1487b783          	ld	a5,328(a5)
ffffffffc0205032:	cfdd                	beqz	a5,ffffffffc02050f0 <file_seek+0xdc>
ffffffffc0205034:	4b98                	lw	a4,16(a5)
ffffffffc0205036:	0ae05d63          	blez	a4,ffffffffc02050f0 <file_seek+0xdc>
ffffffffc020503a:	6780                	ld	s0,8(a5)
ffffffffc020503c:	00351793          	slli	a5,a0,0x3
ffffffffc0205040:	8f89                	sub	a5,a5,a0
ffffffffc0205042:	078e                	slli	a5,a5,0x3
ffffffffc0205044:	943e                	add	s0,s0,a5
ffffffffc0205046:	4018                	lw	a4,0(s0)
ffffffffc0205048:	4789                	li	a5,2
ffffffffc020504a:	06f71463          	bne	a4,a5,ffffffffc02050b2 <file_seek+0x9e>
ffffffffc020504e:	4c1c                	lw	a5,24(s0)
ffffffffc0205050:	06a79163          	bne	a5,a0,ffffffffc02050b2 <file_seek+0x9e>
ffffffffc0205054:	581c                	lw	a5,48(s0)
ffffffffc0205056:	4685                	li	a3,1
ffffffffc0205058:	892e                	mv	s2,a1
ffffffffc020505a:	2785                	addiw	a5,a5,1
ffffffffc020505c:	d81c                	sw	a5,48(s0)
ffffffffc020505e:	02d60063          	beq	a2,a3,ffffffffc020507e <file_seek+0x6a>
ffffffffc0205062:	06e60063          	beq	a2,a4,ffffffffc02050c2 <file_seek+0xae>
ffffffffc0205066:	54f5                	li	s1,-3
ffffffffc0205068:	ce11                	beqz	a2,ffffffffc0205084 <file_seek+0x70>
ffffffffc020506a:	8522                	mv	a0,s0
ffffffffc020506c:	a8bff0ef          	jal	ra,ffffffffc0204af6 <fd_array_release>
ffffffffc0205070:	70e2                	ld	ra,56(sp)
ffffffffc0205072:	7442                	ld	s0,48(sp)
ffffffffc0205074:	7902                	ld	s2,32(sp)
ffffffffc0205076:	8526                	mv	a0,s1
ffffffffc0205078:	74a2                	ld	s1,40(sp)
ffffffffc020507a:	6121                	addi	sp,sp,64
ffffffffc020507c:	8082                	ret
ffffffffc020507e:	701c                	ld	a5,32(s0)
ffffffffc0205080:	00f58933          	add	s2,a1,a5
ffffffffc0205084:	7404                	ld	s1,40(s0)
ffffffffc0205086:	c4bd                	beqz	s1,ffffffffc02050f4 <file_seek+0xe0>
ffffffffc0205088:	78bc                	ld	a5,112(s1)
ffffffffc020508a:	c7ad                	beqz	a5,ffffffffc02050f4 <file_seek+0xe0>
ffffffffc020508c:	6fbc                	ld	a5,88(a5)
ffffffffc020508e:	c3bd                	beqz	a5,ffffffffc02050f4 <file_seek+0xe0>
ffffffffc0205090:	8526                	mv	a0,s1
ffffffffc0205092:	00008597          	auipc	a1,0x8
ffffffffc0205096:	75e58593          	addi	a1,a1,1886 # ffffffffc020d7f0 <default_pmm_manager+0x1020>
ffffffffc020509a:	31f020ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc020509e:	78bc                	ld	a5,112(s1)
ffffffffc02050a0:	7408                	ld	a0,40(s0)
ffffffffc02050a2:	85ca                	mv	a1,s2
ffffffffc02050a4:	6fbc                	ld	a5,88(a5)
ffffffffc02050a6:	9782                	jalr	a5
ffffffffc02050a8:	84aa                	mv	s1,a0
ffffffffc02050aa:	f161                	bnez	a0,ffffffffc020506a <file_seek+0x56>
ffffffffc02050ac:	03243023          	sd	s2,32(s0)
ffffffffc02050b0:	bf6d                	j	ffffffffc020506a <file_seek+0x56>
ffffffffc02050b2:	70e2                	ld	ra,56(sp)
ffffffffc02050b4:	7442                	ld	s0,48(sp)
ffffffffc02050b6:	54f5                	li	s1,-3
ffffffffc02050b8:	7902                	ld	s2,32(sp)
ffffffffc02050ba:	8526                	mv	a0,s1
ffffffffc02050bc:	74a2                	ld	s1,40(sp)
ffffffffc02050be:	6121                	addi	sp,sp,64
ffffffffc02050c0:	8082                	ret
ffffffffc02050c2:	7404                	ld	s1,40(s0)
ffffffffc02050c4:	c8a1                	beqz	s1,ffffffffc0205114 <file_seek+0x100>
ffffffffc02050c6:	78bc                	ld	a5,112(s1)
ffffffffc02050c8:	c7b1                	beqz	a5,ffffffffc0205114 <file_seek+0x100>
ffffffffc02050ca:	779c                	ld	a5,40(a5)
ffffffffc02050cc:	c7a1                	beqz	a5,ffffffffc0205114 <file_seek+0x100>
ffffffffc02050ce:	8526                	mv	a0,s1
ffffffffc02050d0:	00008597          	auipc	a1,0x8
ffffffffc02050d4:	61858593          	addi	a1,a1,1560 # ffffffffc020d6e8 <default_pmm_manager+0xf18>
ffffffffc02050d8:	2e1020ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc02050dc:	78bc                	ld	a5,112(s1)
ffffffffc02050de:	7408                	ld	a0,40(s0)
ffffffffc02050e0:	858a                	mv	a1,sp
ffffffffc02050e2:	779c                	ld	a5,40(a5)
ffffffffc02050e4:	9782                	jalr	a5
ffffffffc02050e6:	84aa                	mv	s1,a0
ffffffffc02050e8:	f149                	bnez	a0,ffffffffc020506a <file_seek+0x56>
ffffffffc02050ea:	67e2                	ld	a5,24(sp)
ffffffffc02050ec:	993e                	add	s2,s2,a5
ffffffffc02050ee:	bf59                	j	ffffffffc0205084 <file_seek+0x70>
ffffffffc02050f0:	8d5ff0ef          	jal	ra,ffffffffc02049c4 <get_fd_array.part.0>
ffffffffc02050f4:	00008697          	auipc	a3,0x8
ffffffffc02050f8:	6ac68693          	addi	a3,a3,1708 # ffffffffc020d7a0 <default_pmm_manager+0xfd0>
ffffffffc02050fc:	00007617          	auipc	a2,0x7
ffffffffc0205100:	bcc60613          	addi	a2,a2,-1076 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0205104:	11a00593          	li	a1,282
ffffffffc0205108:	00008517          	auipc	a0,0x8
ffffffffc020510c:	45850513          	addi	a0,a0,1112 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0205110:	b8efb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205114:	00008697          	auipc	a3,0x8
ffffffffc0205118:	58468693          	addi	a3,a3,1412 # ffffffffc020d698 <default_pmm_manager+0xec8>
ffffffffc020511c:	00007617          	auipc	a2,0x7
ffffffffc0205120:	bac60613          	addi	a2,a2,-1108 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0205124:	11200593          	li	a1,274
ffffffffc0205128:	00008517          	auipc	a0,0x8
ffffffffc020512c:	43850513          	addi	a0,a0,1080 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0205130:	b6efb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205134 <file_fstat>:
ffffffffc0205134:	1101                	addi	sp,sp,-32
ffffffffc0205136:	ec06                	sd	ra,24(sp)
ffffffffc0205138:	e822                	sd	s0,16(sp)
ffffffffc020513a:	e426                	sd	s1,8(sp)
ffffffffc020513c:	e04a                	sd	s2,0(sp)
ffffffffc020513e:	04700793          	li	a5,71
ffffffffc0205142:	06a7ef63          	bltu	a5,a0,ffffffffc02051c0 <file_fstat+0x8c>
ffffffffc0205146:	00091797          	auipc	a5,0x91
ffffffffc020514a:	78a7b783          	ld	a5,1930(a5) # ffffffffc02968d0 <current>
ffffffffc020514e:	1487b783          	ld	a5,328(a5)
ffffffffc0205152:	cfd9                	beqz	a5,ffffffffc02051f0 <file_fstat+0xbc>
ffffffffc0205154:	4b98                	lw	a4,16(a5)
ffffffffc0205156:	08e05d63          	blez	a4,ffffffffc02051f0 <file_fstat+0xbc>
ffffffffc020515a:	6780                	ld	s0,8(a5)
ffffffffc020515c:	00351793          	slli	a5,a0,0x3
ffffffffc0205160:	8f89                	sub	a5,a5,a0
ffffffffc0205162:	078e                	slli	a5,a5,0x3
ffffffffc0205164:	943e                	add	s0,s0,a5
ffffffffc0205166:	4018                	lw	a4,0(s0)
ffffffffc0205168:	4789                	li	a5,2
ffffffffc020516a:	04f71b63          	bne	a4,a5,ffffffffc02051c0 <file_fstat+0x8c>
ffffffffc020516e:	4c1c                	lw	a5,24(s0)
ffffffffc0205170:	04a79863          	bne	a5,a0,ffffffffc02051c0 <file_fstat+0x8c>
ffffffffc0205174:	581c                	lw	a5,48(s0)
ffffffffc0205176:	02843903          	ld	s2,40(s0)
ffffffffc020517a:	2785                	addiw	a5,a5,1
ffffffffc020517c:	d81c                	sw	a5,48(s0)
ffffffffc020517e:	04090963          	beqz	s2,ffffffffc02051d0 <file_fstat+0x9c>
ffffffffc0205182:	07093783          	ld	a5,112(s2)
ffffffffc0205186:	c7a9                	beqz	a5,ffffffffc02051d0 <file_fstat+0x9c>
ffffffffc0205188:	779c                	ld	a5,40(a5)
ffffffffc020518a:	c3b9                	beqz	a5,ffffffffc02051d0 <file_fstat+0x9c>
ffffffffc020518c:	84ae                	mv	s1,a1
ffffffffc020518e:	854a                	mv	a0,s2
ffffffffc0205190:	00008597          	auipc	a1,0x8
ffffffffc0205194:	55858593          	addi	a1,a1,1368 # ffffffffc020d6e8 <default_pmm_manager+0xf18>
ffffffffc0205198:	221020ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc020519c:	07093783          	ld	a5,112(s2)
ffffffffc02051a0:	7408                	ld	a0,40(s0)
ffffffffc02051a2:	85a6                	mv	a1,s1
ffffffffc02051a4:	779c                	ld	a5,40(a5)
ffffffffc02051a6:	9782                	jalr	a5
ffffffffc02051a8:	87aa                	mv	a5,a0
ffffffffc02051aa:	8522                	mv	a0,s0
ffffffffc02051ac:	843e                	mv	s0,a5
ffffffffc02051ae:	949ff0ef          	jal	ra,ffffffffc0204af6 <fd_array_release>
ffffffffc02051b2:	60e2                	ld	ra,24(sp)
ffffffffc02051b4:	8522                	mv	a0,s0
ffffffffc02051b6:	6442                	ld	s0,16(sp)
ffffffffc02051b8:	64a2                	ld	s1,8(sp)
ffffffffc02051ba:	6902                	ld	s2,0(sp)
ffffffffc02051bc:	6105                	addi	sp,sp,32
ffffffffc02051be:	8082                	ret
ffffffffc02051c0:	5475                	li	s0,-3
ffffffffc02051c2:	60e2                	ld	ra,24(sp)
ffffffffc02051c4:	8522                	mv	a0,s0
ffffffffc02051c6:	6442                	ld	s0,16(sp)
ffffffffc02051c8:	64a2                	ld	s1,8(sp)
ffffffffc02051ca:	6902                	ld	s2,0(sp)
ffffffffc02051cc:	6105                	addi	sp,sp,32
ffffffffc02051ce:	8082                	ret
ffffffffc02051d0:	00008697          	auipc	a3,0x8
ffffffffc02051d4:	4c868693          	addi	a3,a3,1224 # ffffffffc020d698 <default_pmm_manager+0xec8>
ffffffffc02051d8:	00007617          	auipc	a2,0x7
ffffffffc02051dc:	af060613          	addi	a2,a2,-1296 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02051e0:	12c00593          	li	a1,300
ffffffffc02051e4:	00008517          	auipc	a0,0x8
ffffffffc02051e8:	37c50513          	addi	a0,a0,892 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc02051ec:	ab2fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02051f0:	fd4ff0ef          	jal	ra,ffffffffc02049c4 <get_fd_array.part.0>

ffffffffc02051f4 <file_fsync>:
ffffffffc02051f4:	1101                	addi	sp,sp,-32
ffffffffc02051f6:	ec06                	sd	ra,24(sp)
ffffffffc02051f8:	e822                	sd	s0,16(sp)
ffffffffc02051fa:	e426                	sd	s1,8(sp)
ffffffffc02051fc:	04700793          	li	a5,71
ffffffffc0205200:	06a7e863          	bltu	a5,a0,ffffffffc0205270 <file_fsync+0x7c>
ffffffffc0205204:	00091797          	auipc	a5,0x91
ffffffffc0205208:	6cc7b783          	ld	a5,1740(a5) # ffffffffc02968d0 <current>
ffffffffc020520c:	1487b783          	ld	a5,328(a5)
ffffffffc0205210:	c7d9                	beqz	a5,ffffffffc020529e <file_fsync+0xaa>
ffffffffc0205212:	4b98                	lw	a4,16(a5)
ffffffffc0205214:	08e05563          	blez	a4,ffffffffc020529e <file_fsync+0xaa>
ffffffffc0205218:	6780                	ld	s0,8(a5)
ffffffffc020521a:	00351793          	slli	a5,a0,0x3
ffffffffc020521e:	8f89                	sub	a5,a5,a0
ffffffffc0205220:	078e                	slli	a5,a5,0x3
ffffffffc0205222:	943e                	add	s0,s0,a5
ffffffffc0205224:	4018                	lw	a4,0(s0)
ffffffffc0205226:	4789                	li	a5,2
ffffffffc0205228:	04f71463          	bne	a4,a5,ffffffffc0205270 <file_fsync+0x7c>
ffffffffc020522c:	4c1c                	lw	a5,24(s0)
ffffffffc020522e:	04a79163          	bne	a5,a0,ffffffffc0205270 <file_fsync+0x7c>
ffffffffc0205232:	581c                	lw	a5,48(s0)
ffffffffc0205234:	7404                	ld	s1,40(s0)
ffffffffc0205236:	2785                	addiw	a5,a5,1
ffffffffc0205238:	d81c                	sw	a5,48(s0)
ffffffffc020523a:	c0b1                	beqz	s1,ffffffffc020527e <file_fsync+0x8a>
ffffffffc020523c:	78bc                	ld	a5,112(s1)
ffffffffc020523e:	c3a1                	beqz	a5,ffffffffc020527e <file_fsync+0x8a>
ffffffffc0205240:	7b9c                	ld	a5,48(a5)
ffffffffc0205242:	cf95                	beqz	a5,ffffffffc020527e <file_fsync+0x8a>
ffffffffc0205244:	00008597          	auipc	a1,0x8
ffffffffc0205248:	60458593          	addi	a1,a1,1540 # ffffffffc020d848 <default_pmm_manager+0x1078>
ffffffffc020524c:	8526                	mv	a0,s1
ffffffffc020524e:	16b020ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0205252:	78bc                	ld	a5,112(s1)
ffffffffc0205254:	7408                	ld	a0,40(s0)
ffffffffc0205256:	7b9c                	ld	a5,48(a5)
ffffffffc0205258:	9782                	jalr	a5
ffffffffc020525a:	87aa                	mv	a5,a0
ffffffffc020525c:	8522                	mv	a0,s0
ffffffffc020525e:	843e                	mv	s0,a5
ffffffffc0205260:	897ff0ef          	jal	ra,ffffffffc0204af6 <fd_array_release>
ffffffffc0205264:	60e2                	ld	ra,24(sp)
ffffffffc0205266:	8522                	mv	a0,s0
ffffffffc0205268:	6442                	ld	s0,16(sp)
ffffffffc020526a:	64a2                	ld	s1,8(sp)
ffffffffc020526c:	6105                	addi	sp,sp,32
ffffffffc020526e:	8082                	ret
ffffffffc0205270:	5475                	li	s0,-3
ffffffffc0205272:	60e2                	ld	ra,24(sp)
ffffffffc0205274:	8522                	mv	a0,s0
ffffffffc0205276:	6442                	ld	s0,16(sp)
ffffffffc0205278:	64a2                	ld	s1,8(sp)
ffffffffc020527a:	6105                	addi	sp,sp,32
ffffffffc020527c:	8082                	ret
ffffffffc020527e:	00008697          	auipc	a3,0x8
ffffffffc0205282:	57a68693          	addi	a3,a3,1402 # ffffffffc020d7f8 <default_pmm_manager+0x1028>
ffffffffc0205286:	00007617          	auipc	a2,0x7
ffffffffc020528a:	a4260613          	addi	a2,a2,-1470 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020528e:	13a00593          	li	a1,314
ffffffffc0205292:	00008517          	auipc	a0,0x8
ffffffffc0205296:	2ce50513          	addi	a0,a0,718 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc020529a:	a04fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020529e:	f26ff0ef          	jal	ra,ffffffffc02049c4 <get_fd_array.part.0>

ffffffffc02052a2 <file_getdirentry>:
ffffffffc02052a2:	715d                	addi	sp,sp,-80
ffffffffc02052a4:	e486                	sd	ra,72(sp)
ffffffffc02052a6:	e0a2                	sd	s0,64(sp)
ffffffffc02052a8:	fc26                	sd	s1,56(sp)
ffffffffc02052aa:	f84a                	sd	s2,48(sp)
ffffffffc02052ac:	f44e                	sd	s3,40(sp)
ffffffffc02052ae:	04700793          	li	a5,71
ffffffffc02052b2:	0aa7e063          	bltu	a5,a0,ffffffffc0205352 <file_getdirentry+0xb0>
ffffffffc02052b6:	00091797          	auipc	a5,0x91
ffffffffc02052ba:	61a7b783          	ld	a5,1562(a5) # ffffffffc02968d0 <current>
ffffffffc02052be:	1487b783          	ld	a5,328(a5)
ffffffffc02052c2:	c3e9                	beqz	a5,ffffffffc0205384 <file_getdirentry+0xe2>
ffffffffc02052c4:	4b98                	lw	a4,16(a5)
ffffffffc02052c6:	0ae05f63          	blez	a4,ffffffffc0205384 <file_getdirentry+0xe2>
ffffffffc02052ca:	6780                	ld	s0,8(a5)
ffffffffc02052cc:	00351793          	slli	a5,a0,0x3
ffffffffc02052d0:	8f89                	sub	a5,a5,a0
ffffffffc02052d2:	078e                	slli	a5,a5,0x3
ffffffffc02052d4:	943e                	add	s0,s0,a5
ffffffffc02052d6:	4018                	lw	a4,0(s0)
ffffffffc02052d8:	4789                	li	a5,2
ffffffffc02052da:	06f71c63          	bne	a4,a5,ffffffffc0205352 <file_getdirentry+0xb0>
ffffffffc02052de:	4c1c                	lw	a5,24(s0)
ffffffffc02052e0:	06a79963          	bne	a5,a0,ffffffffc0205352 <file_getdirentry+0xb0>
ffffffffc02052e4:	581c                	lw	a5,48(s0)
ffffffffc02052e6:	6194                	ld	a3,0(a1)
ffffffffc02052e8:	84ae                	mv	s1,a1
ffffffffc02052ea:	2785                	addiw	a5,a5,1
ffffffffc02052ec:	10000613          	li	a2,256
ffffffffc02052f0:	d81c                	sw	a5,48(s0)
ffffffffc02052f2:	05a1                	addi	a1,a1,8
ffffffffc02052f4:	850a                	mv	a0,sp
ffffffffc02052f6:	33e000ef          	jal	ra,ffffffffc0205634 <iobuf_init>
ffffffffc02052fa:	02843983          	ld	s3,40(s0)
ffffffffc02052fe:	892a                	mv	s2,a0
ffffffffc0205300:	06098263          	beqz	s3,ffffffffc0205364 <file_getdirentry+0xc2>
ffffffffc0205304:	0709b783          	ld	a5,112(s3) # 1070 <_binary_bin_swap_img_size-0x6c90>
ffffffffc0205308:	cfb1                	beqz	a5,ffffffffc0205364 <file_getdirentry+0xc2>
ffffffffc020530a:	63bc                	ld	a5,64(a5)
ffffffffc020530c:	cfa1                	beqz	a5,ffffffffc0205364 <file_getdirentry+0xc2>
ffffffffc020530e:	854e                	mv	a0,s3
ffffffffc0205310:	00008597          	auipc	a1,0x8
ffffffffc0205314:	59858593          	addi	a1,a1,1432 # ffffffffc020d8a8 <default_pmm_manager+0x10d8>
ffffffffc0205318:	0a1020ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc020531c:	0709b783          	ld	a5,112(s3)
ffffffffc0205320:	7408                	ld	a0,40(s0)
ffffffffc0205322:	85ca                	mv	a1,s2
ffffffffc0205324:	63bc                	ld	a5,64(a5)
ffffffffc0205326:	9782                	jalr	a5
ffffffffc0205328:	89aa                	mv	s3,a0
ffffffffc020532a:	e909                	bnez	a0,ffffffffc020533c <file_getdirentry+0x9a>
ffffffffc020532c:	609c                	ld	a5,0(s1)
ffffffffc020532e:	01093683          	ld	a3,16(s2)
ffffffffc0205332:	01893703          	ld	a4,24(s2)
ffffffffc0205336:	97b6                	add	a5,a5,a3
ffffffffc0205338:	8f99                	sub	a5,a5,a4
ffffffffc020533a:	e09c                	sd	a5,0(s1)
ffffffffc020533c:	8522                	mv	a0,s0
ffffffffc020533e:	fb8ff0ef          	jal	ra,ffffffffc0204af6 <fd_array_release>
ffffffffc0205342:	60a6                	ld	ra,72(sp)
ffffffffc0205344:	6406                	ld	s0,64(sp)
ffffffffc0205346:	74e2                	ld	s1,56(sp)
ffffffffc0205348:	7942                	ld	s2,48(sp)
ffffffffc020534a:	854e                	mv	a0,s3
ffffffffc020534c:	79a2                	ld	s3,40(sp)
ffffffffc020534e:	6161                	addi	sp,sp,80
ffffffffc0205350:	8082                	ret
ffffffffc0205352:	60a6                	ld	ra,72(sp)
ffffffffc0205354:	6406                	ld	s0,64(sp)
ffffffffc0205356:	59f5                	li	s3,-3
ffffffffc0205358:	74e2                	ld	s1,56(sp)
ffffffffc020535a:	7942                	ld	s2,48(sp)
ffffffffc020535c:	854e                	mv	a0,s3
ffffffffc020535e:	79a2                	ld	s3,40(sp)
ffffffffc0205360:	6161                	addi	sp,sp,80
ffffffffc0205362:	8082                	ret
ffffffffc0205364:	00008697          	auipc	a3,0x8
ffffffffc0205368:	4ec68693          	addi	a3,a3,1260 # ffffffffc020d850 <default_pmm_manager+0x1080>
ffffffffc020536c:	00007617          	auipc	a2,0x7
ffffffffc0205370:	95c60613          	addi	a2,a2,-1700 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0205374:	14a00593          	li	a1,330
ffffffffc0205378:	00008517          	auipc	a0,0x8
ffffffffc020537c:	1e850513          	addi	a0,a0,488 # ffffffffc020d560 <default_pmm_manager+0xd90>
ffffffffc0205380:	91efb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205384:	e40ff0ef          	jal	ra,ffffffffc02049c4 <get_fd_array.part.0>

ffffffffc0205388 <file_dup>:
ffffffffc0205388:	04700713          	li	a4,71
ffffffffc020538c:	06a76463          	bltu	a4,a0,ffffffffc02053f4 <file_dup+0x6c>
ffffffffc0205390:	00091717          	auipc	a4,0x91
ffffffffc0205394:	54073703          	ld	a4,1344(a4) # ffffffffc02968d0 <current>
ffffffffc0205398:	14873703          	ld	a4,328(a4)
ffffffffc020539c:	1101                	addi	sp,sp,-32
ffffffffc020539e:	ec06                	sd	ra,24(sp)
ffffffffc02053a0:	e822                	sd	s0,16(sp)
ffffffffc02053a2:	cb39                	beqz	a4,ffffffffc02053f8 <file_dup+0x70>
ffffffffc02053a4:	4b14                	lw	a3,16(a4)
ffffffffc02053a6:	04d05963          	blez	a3,ffffffffc02053f8 <file_dup+0x70>
ffffffffc02053aa:	6700                	ld	s0,8(a4)
ffffffffc02053ac:	00351713          	slli	a4,a0,0x3
ffffffffc02053b0:	8f09                	sub	a4,a4,a0
ffffffffc02053b2:	070e                	slli	a4,a4,0x3
ffffffffc02053b4:	943a                	add	s0,s0,a4
ffffffffc02053b6:	4014                	lw	a3,0(s0)
ffffffffc02053b8:	4709                	li	a4,2
ffffffffc02053ba:	02e69863          	bne	a3,a4,ffffffffc02053ea <file_dup+0x62>
ffffffffc02053be:	4c18                	lw	a4,24(s0)
ffffffffc02053c0:	02a71563          	bne	a4,a0,ffffffffc02053ea <file_dup+0x62>
ffffffffc02053c4:	852e                	mv	a0,a1
ffffffffc02053c6:	002c                	addi	a1,sp,8
ffffffffc02053c8:	e1eff0ef          	jal	ra,ffffffffc02049e6 <fd_array_alloc>
ffffffffc02053cc:	c509                	beqz	a0,ffffffffc02053d6 <file_dup+0x4e>
ffffffffc02053ce:	60e2                	ld	ra,24(sp)
ffffffffc02053d0:	6442                	ld	s0,16(sp)
ffffffffc02053d2:	6105                	addi	sp,sp,32
ffffffffc02053d4:	8082                	ret
ffffffffc02053d6:	6522                	ld	a0,8(sp)
ffffffffc02053d8:	85a2                	mv	a1,s0
ffffffffc02053da:	845ff0ef          	jal	ra,ffffffffc0204c1e <fd_array_dup>
ffffffffc02053de:	67a2                	ld	a5,8(sp)
ffffffffc02053e0:	60e2                	ld	ra,24(sp)
ffffffffc02053e2:	6442                	ld	s0,16(sp)
ffffffffc02053e4:	4f88                	lw	a0,24(a5)
ffffffffc02053e6:	6105                	addi	sp,sp,32
ffffffffc02053e8:	8082                	ret
ffffffffc02053ea:	60e2                	ld	ra,24(sp)
ffffffffc02053ec:	6442                	ld	s0,16(sp)
ffffffffc02053ee:	5575                	li	a0,-3
ffffffffc02053f0:	6105                	addi	sp,sp,32
ffffffffc02053f2:	8082                	ret
ffffffffc02053f4:	5575                	li	a0,-3
ffffffffc02053f6:	8082                	ret
ffffffffc02053f8:	dccff0ef          	jal	ra,ffffffffc02049c4 <get_fd_array.part.0>

ffffffffc02053fc <fs_init>:
ffffffffc02053fc:	1141                	addi	sp,sp,-16
ffffffffc02053fe:	e406                	sd	ra,8(sp)
ffffffffc0205400:	1d7020ef          	jal	ra,ffffffffc0207dd6 <vfs_init>
ffffffffc0205404:	6ae030ef          	jal	ra,ffffffffc0208ab2 <dev_init>
ffffffffc0205408:	60a2                	ld	ra,8(sp)
ffffffffc020540a:	0141                	addi	sp,sp,16
ffffffffc020540c:	7ff0306f          	j	ffffffffc020940a <sfs_init>

ffffffffc0205410 <fs_cleanup>:
ffffffffc0205410:	4190206f          	j	ffffffffc0208028 <vfs_cleanup>

ffffffffc0205414 <lock_files>:
ffffffffc0205414:	0561                	addi	a0,a0,24
ffffffffc0205416:	ba0ff06f          	j	ffffffffc02047b6 <down>

ffffffffc020541a <unlock_files>:
ffffffffc020541a:	0561                	addi	a0,a0,24
ffffffffc020541c:	b96ff06f          	j	ffffffffc02047b2 <up>

ffffffffc0205420 <files_create>:
ffffffffc0205420:	1141                	addi	sp,sp,-16
ffffffffc0205422:	6505                	lui	a0,0x1
ffffffffc0205424:	e022                	sd	s0,0(sp)
ffffffffc0205426:	e406                	sd	ra,8(sp)
ffffffffc0205428:	bebfc0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc020542c:	842a                	mv	s0,a0
ffffffffc020542e:	cd19                	beqz	a0,ffffffffc020544c <files_create+0x2c>
ffffffffc0205430:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc0205434:	00043023          	sd	zero,0(s0)
ffffffffc0205438:	0561                	addi	a0,a0,24
ffffffffc020543a:	e41c                	sd	a5,8(s0)
ffffffffc020543c:	00042823          	sw	zero,16(s0)
ffffffffc0205440:	4585                	li	a1,1
ffffffffc0205442:	b6aff0ef          	jal	ra,ffffffffc02047ac <sem_init>
ffffffffc0205446:	6408                	ld	a0,8(s0)
ffffffffc0205448:	f3cff0ef          	jal	ra,ffffffffc0204b84 <fd_array_init>
ffffffffc020544c:	60a2                	ld	ra,8(sp)
ffffffffc020544e:	8522                	mv	a0,s0
ffffffffc0205450:	6402                	ld	s0,0(sp)
ffffffffc0205452:	0141                	addi	sp,sp,16
ffffffffc0205454:	8082                	ret

ffffffffc0205456 <files_destroy>:
ffffffffc0205456:	7179                	addi	sp,sp,-48
ffffffffc0205458:	f406                	sd	ra,40(sp)
ffffffffc020545a:	f022                	sd	s0,32(sp)
ffffffffc020545c:	ec26                	sd	s1,24(sp)
ffffffffc020545e:	e84a                	sd	s2,16(sp)
ffffffffc0205460:	e44e                	sd	s3,8(sp)
ffffffffc0205462:	c52d                	beqz	a0,ffffffffc02054cc <files_destroy+0x76>
ffffffffc0205464:	491c                	lw	a5,16(a0)
ffffffffc0205466:	89aa                	mv	s3,a0
ffffffffc0205468:	e3b5                	bnez	a5,ffffffffc02054cc <files_destroy+0x76>
ffffffffc020546a:	6108                	ld	a0,0(a0)
ffffffffc020546c:	c119                	beqz	a0,ffffffffc0205472 <files_destroy+0x1c>
ffffffffc020546e:	001020ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc0205472:	0089b403          	ld	s0,8(s3)
ffffffffc0205476:	6485                	lui	s1,0x1
ffffffffc0205478:	fc048493          	addi	s1,s1,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc020547c:	94a2                	add	s1,s1,s0
ffffffffc020547e:	4909                	li	s2,2
ffffffffc0205480:	401c                	lw	a5,0(s0)
ffffffffc0205482:	03278063          	beq	a5,s2,ffffffffc02054a2 <files_destroy+0x4c>
ffffffffc0205486:	e39d                	bnez	a5,ffffffffc02054ac <files_destroy+0x56>
ffffffffc0205488:	03840413          	addi	s0,s0,56
ffffffffc020548c:	fe849ae3          	bne	s1,s0,ffffffffc0205480 <files_destroy+0x2a>
ffffffffc0205490:	7402                	ld	s0,32(sp)
ffffffffc0205492:	70a2                	ld	ra,40(sp)
ffffffffc0205494:	64e2                	ld	s1,24(sp)
ffffffffc0205496:	6942                	ld	s2,16(sp)
ffffffffc0205498:	854e                	mv	a0,s3
ffffffffc020549a:	69a2                	ld	s3,8(sp)
ffffffffc020549c:	6145                	addi	sp,sp,48
ffffffffc020549e:	c25fc06f          	j	ffffffffc02020c2 <kfree>
ffffffffc02054a2:	8522                	mv	a0,s0
ffffffffc02054a4:	efcff0ef          	jal	ra,ffffffffc0204ba0 <fd_array_close>
ffffffffc02054a8:	401c                	lw	a5,0(s0)
ffffffffc02054aa:	bff1                	j	ffffffffc0205486 <files_destroy+0x30>
ffffffffc02054ac:	00008697          	auipc	a3,0x8
ffffffffc02054b0:	47c68693          	addi	a3,a3,1148 # ffffffffc020d928 <CSWTCH.79+0x58>
ffffffffc02054b4:	00007617          	auipc	a2,0x7
ffffffffc02054b8:	81460613          	addi	a2,a2,-2028 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02054bc:	03d00593          	li	a1,61
ffffffffc02054c0:	00008517          	auipc	a0,0x8
ffffffffc02054c4:	45850513          	addi	a0,a0,1112 # ffffffffc020d918 <CSWTCH.79+0x48>
ffffffffc02054c8:	fd7fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02054cc:	00008697          	auipc	a3,0x8
ffffffffc02054d0:	41c68693          	addi	a3,a3,1052 # ffffffffc020d8e8 <CSWTCH.79+0x18>
ffffffffc02054d4:	00006617          	auipc	a2,0x6
ffffffffc02054d8:	7f460613          	addi	a2,a2,2036 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02054dc:	03300593          	li	a1,51
ffffffffc02054e0:	00008517          	auipc	a0,0x8
ffffffffc02054e4:	43850513          	addi	a0,a0,1080 # ffffffffc020d918 <CSWTCH.79+0x48>
ffffffffc02054e8:	fb7fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02054ec <files_closeall>:
ffffffffc02054ec:	1101                	addi	sp,sp,-32
ffffffffc02054ee:	ec06                	sd	ra,24(sp)
ffffffffc02054f0:	e822                	sd	s0,16(sp)
ffffffffc02054f2:	e426                	sd	s1,8(sp)
ffffffffc02054f4:	e04a                	sd	s2,0(sp)
ffffffffc02054f6:	c129                	beqz	a0,ffffffffc0205538 <files_closeall+0x4c>
ffffffffc02054f8:	491c                	lw	a5,16(a0)
ffffffffc02054fa:	02f05f63          	blez	a5,ffffffffc0205538 <files_closeall+0x4c>
ffffffffc02054fe:	6504                	ld	s1,8(a0)
ffffffffc0205500:	6785                	lui	a5,0x1
ffffffffc0205502:	fc078793          	addi	a5,a5,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0205506:	07048413          	addi	s0,s1,112
ffffffffc020550a:	4909                	li	s2,2
ffffffffc020550c:	94be                	add	s1,s1,a5
ffffffffc020550e:	a029                	j	ffffffffc0205518 <files_closeall+0x2c>
ffffffffc0205510:	03840413          	addi	s0,s0,56
ffffffffc0205514:	00848c63          	beq	s1,s0,ffffffffc020552c <files_closeall+0x40>
ffffffffc0205518:	401c                	lw	a5,0(s0)
ffffffffc020551a:	ff279be3          	bne	a5,s2,ffffffffc0205510 <files_closeall+0x24>
ffffffffc020551e:	8522                	mv	a0,s0
ffffffffc0205520:	03840413          	addi	s0,s0,56
ffffffffc0205524:	e7cff0ef          	jal	ra,ffffffffc0204ba0 <fd_array_close>
ffffffffc0205528:	fe8498e3          	bne	s1,s0,ffffffffc0205518 <files_closeall+0x2c>
ffffffffc020552c:	60e2                	ld	ra,24(sp)
ffffffffc020552e:	6442                	ld	s0,16(sp)
ffffffffc0205530:	64a2                	ld	s1,8(sp)
ffffffffc0205532:	6902                	ld	s2,0(sp)
ffffffffc0205534:	6105                	addi	sp,sp,32
ffffffffc0205536:	8082                	ret
ffffffffc0205538:	00008697          	auipc	a3,0x8
ffffffffc020553c:	ff868693          	addi	a3,a3,-8 # ffffffffc020d530 <default_pmm_manager+0xd60>
ffffffffc0205540:	00006617          	auipc	a2,0x6
ffffffffc0205544:	78860613          	addi	a2,a2,1928 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0205548:	04500593          	li	a1,69
ffffffffc020554c:	00008517          	auipc	a0,0x8
ffffffffc0205550:	3cc50513          	addi	a0,a0,972 # ffffffffc020d918 <CSWTCH.79+0x48>
ffffffffc0205554:	f4bfa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205558 <dup_files>:
ffffffffc0205558:	7179                	addi	sp,sp,-48
ffffffffc020555a:	f406                	sd	ra,40(sp)
ffffffffc020555c:	f022                	sd	s0,32(sp)
ffffffffc020555e:	ec26                	sd	s1,24(sp)
ffffffffc0205560:	e84a                	sd	s2,16(sp)
ffffffffc0205562:	e44e                	sd	s3,8(sp)
ffffffffc0205564:	e052                	sd	s4,0(sp)
ffffffffc0205566:	c52d                	beqz	a0,ffffffffc02055d0 <dup_files+0x78>
ffffffffc0205568:	842e                	mv	s0,a1
ffffffffc020556a:	c1bd                	beqz	a1,ffffffffc02055d0 <dup_files+0x78>
ffffffffc020556c:	491c                	lw	a5,16(a0)
ffffffffc020556e:	84aa                	mv	s1,a0
ffffffffc0205570:	e3c1                	bnez	a5,ffffffffc02055f0 <dup_files+0x98>
ffffffffc0205572:	499c                	lw	a5,16(a1)
ffffffffc0205574:	06f05e63          	blez	a5,ffffffffc02055f0 <dup_files+0x98>
ffffffffc0205578:	6188                	ld	a0,0(a1)
ffffffffc020557a:	e088                	sd	a0,0(s1)
ffffffffc020557c:	c119                	beqz	a0,ffffffffc0205582 <dup_files+0x2a>
ffffffffc020557e:	622020ef          	jal	ra,ffffffffc0207ba0 <inode_ref_inc>
ffffffffc0205582:	6400                	ld	s0,8(s0)
ffffffffc0205584:	6905                	lui	s2,0x1
ffffffffc0205586:	fc090913          	addi	s2,s2,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc020558a:	6484                	ld	s1,8(s1)
ffffffffc020558c:	9922                	add	s2,s2,s0
ffffffffc020558e:	4989                	li	s3,2
ffffffffc0205590:	4a05                	li	s4,1
ffffffffc0205592:	a039                	j	ffffffffc02055a0 <dup_files+0x48>
ffffffffc0205594:	03840413          	addi	s0,s0,56
ffffffffc0205598:	03848493          	addi	s1,s1,56
ffffffffc020559c:	02890163          	beq	s2,s0,ffffffffc02055be <dup_files+0x66>
ffffffffc02055a0:	401c                	lw	a5,0(s0)
ffffffffc02055a2:	ff3799e3          	bne	a5,s3,ffffffffc0205594 <dup_files+0x3c>
ffffffffc02055a6:	0144a023          	sw	s4,0(s1)
ffffffffc02055aa:	85a2                	mv	a1,s0
ffffffffc02055ac:	8526                	mv	a0,s1
ffffffffc02055ae:	03840413          	addi	s0,s0,56
ffffffffc02055b2:	e6cff0ef          	jal	ra,ffffffffc0204c1e <fd_array_dup>
ffffffffc02055b6:	03848493          	addi	s1,s1,56
ffffffffc02055ba:	fe8913e3          	bne	s2,s0,ffffffffc02055a0 <dup_files+0x48>
ffffffffc02055be:	70a2                	ld	ra,40(sp)
ffffffffc02055c0:	7402                	ld	s0,32(sp)
ffffffffc02055c2:	64e2                	ld	s1,24(sp)
ffffffffc02055c4:	6942                	ld	s2,16(sp)
ffffffffc02055c6:	69a2                	ld	s3,8(sp)
ffffffffc02055c8:	6a02                	ld	s4,0(sp)
ffffffffc02055ca:	4501                	li	a0,0
ffffffffc02055cc:	6145                	addi	sp,sp,48
ffffffffc02055ce:	8082                	ret
ffffffffc02055d0:	00008697          	auipc	a3,0x8
ffffffffc02055d4:	cb068693          	addi	a3,a3,-848 # ffffffffc020d280 <default_pmm_manager+0xab0>
ffffffffc02055d8:	00006617          	auipc	a2,0x6
ffffffffc02055dc:	6f060613          	addi	a2,a2,1776 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02055e0:	05300593          	li	a1,83
ffffffffc02055e4:	00008517          	auipc	a0,0x8
ffffffffc02055e8:	33450513          	addi	a0,a0,820 # ffffffffc020d918 <CSWTCH.79+0x48>
ffffffffc02055ec:	eb3fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02055f0:	00008697          	auipc	a3,0x8
ffffffffc02055f4:	35068693          	addi	a3,a3,848 # ffffffffc020d940 <CSWTCH.79+0x70>
ffffffffc02055f8:	00006617          	auipc	a2,0x6
ffffffffc02055fc:	6d060613          	addi	a2,a2,1744 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0205600:	05400593          	li	a1,84
ffffffffc0205604:	00008517          	auipc	a0,0x8
ffffffffc0205608:	31450513          	addi	a0,a0,788 # ffffffffc020d918 <CSWTCH.79+0x48>
ffffffffc020560c:	e93fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205610 <iobuf_skip.part.0>:
ffffffffc0205610:	1141                	addi	sp,sp,-16
ffffffffc0205612:	00008697          	auipc	a3,0x8
ffffffffc0205616:	35e68693          	addi	a3,a3,862 # ffffffffc020d970 <CSWTCH.79+0xa0>
ffffffffc020561a:	00006617          	auipc	a2,0x6
ffffffffc020561e:	6ae60613          	addi	a2,a2,1710 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0205622:	04a00593          	li	a1,74
ffffffffc0205626:	00008517          	auipc	a0,0x8
ffffffffc020562a:	36250513          	addi	a0,a0,866 # ffffffffc020d988 <CSWTCH.79+0xb8>
ffffffffc020562e:	e406                	sd	ra,8(sp)
ffffffffc0205630:	e6ffa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205634 <iobuf_init>:
ffffffffc0205634:	e10c                	sd	a1,0(a0)
ffffffffc0205636:	e514                	sd	a3,8(a0)
ffffffffc0205638:	ed10                	sd	a2,24(a0)
ffffffffc020563a:	e910                	sd	a2,16(a0)
ffffffffc020563c:	8082                	ret

ffffffffc020563e <iobuf_move>:
ffffffffc020563e:	7179                	addi	sp,sp,-48
ffffffffc0205640:	ec26                	sd	s1,24(sp)
ffffffffc0205642:	6d04                	ld	s1,24(a0)
ffffffffc0205644:	f022                	sd	s0,32(sp)
ffffffffc0205646:	e84a                	sd	s2,16(sp)
ffffffffc0205648:	e44e                	sd	s3,8(sp)
ffffffffc020564a:	f406                	sd	ra,40(sp)
ffffffffc020564c:	842a                	mv	s0,a0
ffffffffc020564e:	8932                	mv	s2,a2
ffffffffc0205650:	852e                	mv	a0,a1
ffffffffc0205652:	89ba                	mv	s3,a4
ffffffffc0205654:	00967363          	bgeu	a2,s1,ffffffffc020565a <iobuf_move+0x1c>
ffffffffc0205658:	84b2                	mv	s1,a2
ffffffffc020565a:	c495                	beqz	s1,ffffffffc0205686 <iobuf_move+0x48>
ffffffffc020565c:	600c                	ld	a1,0(s0)
ffffffffc020565e:	c681                	beqz	a3,ffffffffc0205666 <iobuf_move+0x28>
ffffffffc0205660:	87ae                	mv	a5,a1
ffffffffc0205662:	85aa                	mv	a1,a0
ffffffffc0205664:	853e                	mv	a0,a5
ffffffffc0205666:	8626                	mv	a2,s1
ffffffffc0205668:	190060ef          	jal	ra,ffffffffc020b7f8 <memmove>
ffffffffc020566c:	6c1c                	ld	a5,24(s0)
ffffffffc020566e:	0297ea63          	bltu	a5,s1,ffffffffc02056a2 <iobuf_move+0x64>
ffffffffc0205672:	6014                	ld	a3,0(s0)
ffffffffc0205674:	6418                	ld	a4,8(s0)
ffffffffc0205676:	8f85                	sub	a5,a5,s1
ffffffffc0205678:	96a6                	add	a3,a3,s1
ffffffffc020567a:	9726                	add	a4,a4,s1
ffffffffc020567c:	e014                	sd	a3,0(s0)
ffffffffc020567e:	e418                	sd	a4,8(s0)
ffffffffc0205680:	ec1c                	sd	a5,24(s0)
ffffffffc0205682:	40990933          	sub	s2,s2,s1
ffffffffc0205686:	00098463          	beqz	s3,ffffffffc020568e <iobuf_move+0x50>
ffffffffc020568a:	0099b023          	sd	s1,0(s3)
ffffffffc020568e:	4501                	li	a0,0
ffffffffc0205690:	00091b63          	bnez	s2,ffffffffc02056a6 <iobuf_move+0x68>
ffffffffc0205694:	70a2                	ld	ra,40(sp)
ffffffffc0205696:	7402                	ld	s0,32(sp)
ffffffffc0205698:	64e2                	ld	s1,24(sp)
ffffffffc020569a:	6942                	ld	s2,16(sp)
ffffffffc020569c:	69a2                	ld	s3,8(sp)
ffffffffc020569e:	6145                	addi	sp,sp,48
ffffffffc02056a0:	8082                	ret
ffffffffc02056a2:	f6fff0ef          	jal	ra,ffffffffc0205610 <iobuf_skip.part.0>
ffffffffc02056a6:	5571                	li	a0,-4
ffffffffc02056a8:	b7f5                	j	ffffffffc0205694 <iobuf_move+0x56>

ffffffffc02056aa <iobuf_skip>:
ffffffffc02056aa:	6d1c                	ld	a5,24(a0)
ffffffffc02056ac:	00b7eb63          	bltu	a5,a1,ffffffffc02056c2 <iobuf_skip+0x18>
ffffffffc02056b0:	6114                	ld	a3,0(a0)
ffffffffc02056b2:	6518                	ld	a4,8(a0)
ffffffffc02056b4:	8f8d                	sub	a5,a5,a1
ffffffffc02056b6:	96ae                	add	a3,a3,a1
ffffffffc02056b8:	95ba                	add	a1,a1,a4
ffffffffc02056ba:	e114                	sd	a3,0(a0)
ffffffffc02056bc:	e50c                	sd	a1,8(a0)
ffffffffc02056be:	ed1c                	sd	a5,24(a0)
ffffffffc02056c0:	8082                	ret
ffffffffc02056c2:	1141                	addi	sp,sp,-16
ffffffffc02056c4:	e406                	sd	ra,8(sp)
ffffffffc02056c6:	f4bff0ef          	jal	ra,ffffffffc0205610 <iobuf_skip.part.0>

ffffffffc02056ca <copy_path>:
ffffffffc02056ca:	7139                	addi	sp,sp,-64
ffffffffc02056cc:	f04a                	sd	s2,32(sp)
ffffffffc02056ce:	00091917          	auipc	s2,0x91
ffffffffc02056d2:	20290913          	addi	s2,s2,514 # ffffffffc02968d0 <current>
ffffffffc02056d6:	00093703          	ld	a4,0(s2)
ffffffffc02056da:	ec4e                	sd	s3,24(sp)
ffffffffc02056dc:	89aa                	mv	s3,a0
ffffffffc02056de:	6505                	lui	a0,0x1
ffffffffc02056e0:	f426                	sd	s1,40(sp)
ffffffffc02056e2:	e852                	sd	s4,16(sp)
ffffffffc02056e4:	fc06                	sd	ra,56(sp)
ffffffffc02056e6:	f822                	sd	s0,48(sp)
ffffffffc02056e8:	e456                	sd	s5,8(sp)
ffffffffc02056ea:	02873a03          	ld	s4,40(a4)
ffffffffc02056ee:	84ae                	mv	s1,a1
ffffffffc02056f0:	923fc0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc02056f4:	c141                	beqz	a0,ffffffffc0205774 <copy_path+0xaa>
ffffffffc02056f6:	842a                	mv	s0,a0
ffffffffc02056f8:	040a0563          	beqz	s4,ffffffffc0205742 <copy_path+0x78>
ffffffffc02056fc:	038a0a93          	addi	s5,s4,56
ffffffffc0205700:	8556                	mv	a0,s5
ffffffffc0205702:	8b4ff0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc0205706:	00093783          	ld	a5,0(s2)
ffffffffc020570a:	cba1                	beqz	a5,ffffffffc020575a <copy_path+0x90>
ffffffffc020570c:	43dc                	lw	a5,4(a5)
ffffffffc020570e:	6685                	lui	a3,0x1
ffffffffc0205710:	8626                	mv	a2,s1
ffffffffc0205712:	04fa2823          	sw	a5,80(s4)
ffffffffc0205716:	85a2                	mv	a1,s0
ffffffffc0205718:	8552                	mv	a0,s4
ffffffffc020571a:	ec5fe0ef          	jal	ra,ffffffffc02045de <copy_string>
ffffffffc020571e:	c529                	beqz	a0,ffffffffc0205768 <copy_path+0x9e>
ffffffffc0205720:	8556                	mv	a0,s5
ffffffffc0205722:	890ff0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0205726:	040a2823          	sw	zero,80(s4)
ffffffffc020572a:	0089b023          	sd	s0,0(s3)
ffffffffc020572e:	4501                	li	a0,0
ffffffffc0205730:	70e2                	ld	ra,56(sp)
ffffffffc0205732:	7442                	ld	s0,48(sp)
ffffffffc0205734:	74a2                	ld	s1,40(sp)
ffffffffc0205736:	7902                	ld	s2,32(sp)
ffffffffc0205738:	69e2                	ld	s3,24(sp)
ffffffffc020573a:	6a42                	ld	s4,16(sp)
ffffffffc020573c:	6aa2                	ld	s5,8(sp)
ffffffffc020573e:	6121                	addi	sp,sp,64
ffffffffc0205740:	8082                	ret
ffffffffc0205742:	85aa                	mv	a1,a0
ffffffffc0205744:	6685                	lui	a3,0x1
ffffffffc0205746:	8626                	mv	a2,s1
ffffffffc0205748:	4501                	li	a0,0
ffffffffc020574a:	e95fe0ef          	jal	ra,ffffffffc02045de <copy_string>
ffffffffc020574e:	fd71                	bnez	a0,ffffffffc020572a <copy_path+0x60>
ffffffffc0205750:	8522                	mv	a0,s0
ffffffffc0205752:	971fc0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0205756:	5575                	li	a0,-3
ffffffffc0205758:	bfe1                	j	ffffffffc0205730 <copy_path+0x66>
ffffffffc020575a:	6685                	lui	a3,0x1
ffffffffc020575c:	8626                	mv	a2,s1
ffffffffc020575e:	85a2                	mv	a1,s0
ffffffffc0205760:	8552                	mv	a0,s4
ffffffffc0205762:	e7dfe0ef          	jal	ra,ffffffffc02045de <copy_string>
ffffffffc0205766:	fd4d                	bnez	a0,ffffffffc0205720 <copy_path+0x56>
ffffffffc0205768:	8556                	mv	a0,s5
ffffffffc020576a:	848ff0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020576e:	040a2823          	sw	zero,80(s4)
ffffffffc0205772:	bff9                	j	ffffffffc0205750 <copy_path+0x86>
ffffffffc0205774:	5571                	li	a0,-4
ffffffffc0205776:	bf6d                	j	ffffffffc0205730 <copy_path+0x66>

ffffffffc0205778 <sysfile_open>:
ffffffffc0205778:	7179                	addi	sp,sp,-48
ffffffffc020577a:	872a                	mv	a4,a0
ffffffffc020577c:	ec26                	sd	s1,24(sp)
ffffffffc020577e:	0028                	addi	a0,sp,8
ffffffffc0205780:	84ae                	mv	s1,a1
ffffffffc0205782:	85ba                	mv	a1,a4
ffffffffc0205784:	f022                	sd	s0,32(sp)
ffffffffc0205786:	f406                	sd	ra,40(sp)
ffffffffc0205788:	f43ff0ef          	jal	ra,ffffffffc02056ca <copy_path>
ffffffffc020578c:	842a                	mv	s0,a0
ffffffffc020578e:	e909                	bnez	a0,ffffffffc02057a0 <sysfile_open+0x28>
ffffffffc0205790:	6522                	ld	a0,8(sp)
ffffffffc0205792:	85a6                	mv	a1,s1
ffffffffc0205794:	d60ff0ef          	jal	ra,ffffffffc0204cf4 <file_open>
ffffffffc0205798:	842a                	mv	s0,a0
ffffffffc020579a:	6522                	ld	a0,8(sp)
ffffffffc020579c:	927fc0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc02057a0:	70a2                	ld	ra,40(sp)
ffffffffc02057a2:	8522                	mv	a0,s0
ffffffffc02057a4:	7402                	ld	s0,32(sp)
ffffffffc02057a6:	64e2                	ld	s1,24(sp)
ffffffffc02057a8:	6145                	addi	sp,sp,48
ffffffffc02057aa:	8082                	ret

ffffffffc02057ac <sysfile_close>:
ffffffffc02057ac:	e46ff06f          	j	ffffffffc0204df2 <file_close>

ffffffffc02057b0 <sysfile_read>:
ffffffffc02057b0:	7159                	addi	sp,sp,-112
ffffffffc02057b2:	f0a2                	sd	s0,96(sp)
ffffffffc02057b4:	f486                	sd	ra,104(sp)
ffffffffc02057b6:	eca6                	sd	s1,88(sp)
ffffffffc02057b8:	e8ca                	sd	s2,80(sp)
ffffffffc02057ba:	e4ce                	sd	s3,72(sp)
ffffffffc02057bc:	e0d2                	sd	s4,64(sp)
ffffffffc02057be:	fc56                	sd	s5,56(sp)
ffffffffc02057c0:	f85a                	sd	s6,48(sp)
ffffffffc02057c2:	f45e                	sd	s7,40(sp)
ffffffffc02057c4:	f062                	sd	s8,32(sp)
ffffffffc02057c6:	ec66                	sd	s9,24(sp)
ffffffffc02057c8:	4401                	li	s0,0
ffffffffc02057ca:	ee19                	bnez	a2,ffffffffc02057e8 <sysfile_read+0x38>
ffffffffc02057cc:	70a6                	ld	ra,104(sp)
ffffffffc02057ce:	8522                	mv	a0,s0
ffffffffc02057d0:	7406                	ld	s0,96(sp)
ffffffffc02057d2:	64e6                	ld	s1,88(sp)
ffffffffc02057d4:	6946                	ld	s2,80(sp)
ffffffffc02057d6:	69a6                	ld	s3,72(sp)
ffffffffc02057d8:	6a06                	ld	s4,64(sp)
ffffffffc02057da:	7ae2                	ld	s5,56(sp)
ffffffffc02057dc:	7b42                	ld	s6,48(sp)
ffffffffc02057de:	7ba2                	ld	s7,40(sp)
ffffffffc02057e0:	7c02                	ld	s8,32(sp)
ffffffffc02057e2:	6ce2                	ld	s9,24(sp)
ffffffffc02057e4:	6165                	addi	sp,sp,112
ffffffffc02057e6:	8082                	ret
ffffffffc02057e8:	00091c97          	auipc	s9,0x91
ffffffffc02057ec:	0e8c8c93          	addi	s9,s9,232 # ffffffffc02968d0 <current>
ffffffffc02057f0:	000cb783          	ld	a5,0(s9)
ffffffffc02057f4:	84b2                	mv	s1,a2
ffffffffc02057f6:	8b2e                	mv	s6,a1
ffffffffc02057f8:	4601                	li	a2,0
ffffffffc02057fa:	4585                	li	a1,1
ffffffffc02057fc:	0287b903          	ld	s2,40(a5)
ffffffffc0205800:	8aaa                	mv	s5,a0
ffffffffc0205802:	c9eff0ef          	jal	ra,ffffffffc0204ca0 <file_testfd>
ffffffffc0205806:	c959                	beqz	a0,ffffffffc020589c <sysfile_read+0xec>
ffffffffc0205808:	6505                	lui	a0,0x1
ffffffffc020580a:	809fc0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc020580e:	89aa                	mv	s3,a0
ffffffffc0205810:	c941                	beqz	a0,ffffffffc02058a0 <sysfile_read+0xf0>
ffffffffc0205812:	4b81                	li	s7,0
ffffffffc0205814:	6a05                	lui	s4,0x1
ffffffffc0205816:	03890c13          	addi	s8,s2,56
ffffffffc020581a:	0744ec63          	bltu	s1,s4,ffffffffc0205892 <sysfile_read+0xe2>
ffffffffc020581e:	e452                	sd	s4,8(sp)
ffffffffc0205820:	6605                	lui	a2,0x1
ffffffffc0205822:	0034                	addi	a3,sp,8
ffffffffc0205824:	85ce                	mv	a1,s3
ffffffffc0205826:	8556                	mv	a0,s5
ffffffffc0205828:	e20ff0ef          	jal	ra,ffffffffc0204e48 <file_read>
ffffffffc020582c:	66a2                	ld	a3,8(sp)
ffffffffc020582e:	842a                	mv	s0,a0
ffffffffc0205830:	ca9d                	beqz	a3,ffffffffc0205866 <sysfile_read+0xb6>
ffffffffc0205832:	00090c63          	beqz	s2,ffffffffc020584a <sysfile_read+0x9a>
ffffffffc0205836:	8562                	mv	a0,s8
ffffffffc0205838:	f7ffe0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc020583c:	000cb783          	ld	a5,0(s9)
ffffffffc0205840:	cfa1                	beqz	a5,ffffffffc0205898 <sysfile_read+0xe8>
ffffffffc0205842:	43dc                	lw	a5,4(a5)
ffffffffc0205844:	66a2                	ld	a3,8(sp)
ffffffffc0205846:	04f92823          	sw	a5,80(s2)
ffffffffc020584a:	864e                	mv	a2,s3
ffffffffc020584c:	85da                	mv	a1,s6
ffffffffc020584e:	854a                	mv	a0,s2
ffffffffc0205850:	d5dfe0ef          	jal	ra,ffffffffc02045ac <copy_to_user>
ffffffffc0205854:	c50d                	beqz	a0,ffffffffc020587e <sysfile_read+0xce>
ffffffffc0205856:	67a2                	ld	a5,8(sp)
ffffffffc0205858:	04f4e663          	bltu	s1,a5,ffffffffc02058a4 <sysfile_read+0xf4>
ffffffffc020585c:	9b3e                	add	s6,s6,a5
ffffffffc020585e:	8c9d                	sub	s1,s1,a5
ffffffffc0205860:	9bbe                	add	s7,s7,a5
ffffffffc0205862:	02091263          	bnez	s2,ffffffffc0205886 <sysfile_read+0xd6>
ffffffffc0205866:	e401                	bnez	s0,ffffffffc020586e <sysfile_read+0xbe>
ffffffffc0205868:	67a2                	ld	a5,8(sp)
ffffffffc020586a:	c391                	beqz	a5,ffffffffc020586e <sysfile_read+0xbe>
ffffffffc020586c:	f4dd                	bnez	s1,ffffffffc020581a <sysfile_read+0x6a>
ffffffffc020586e:	854e                	mv	a0,s3
ffffffffc0205870:	853fc0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0205874:	f40b8ce3          	beqz	s7,ffffffffc02057cc <sysfile_read+0x1c>
ffffffffc0205878:	000b841b          	sext.w	s0,s7
ffffffffc020587c:	bf81                	j	ffffffffc02057cc <sysfile_read+0x1c>
ffffffffc020587e:	e011                	bnez	s0,ffffffffc0205882 <sysfile_read+0xd2>
ffffffffc0205880:	5475                	li	s0,-3
ffffffffc0205882:	fe0906e3          	beqz	s2,ffffffffc020586e <sysfile_read+0xbe>
ffffffffc0205886:	8562                	mv	a0,s8
ffffffffc0205888:	f2bfe0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020588c:	04092823          	sw	zero,80(s2)
ffffffffc0205890:	bfd9                	j	ffffffffc0205866 <sysfile_read+0xb6>
ffffffffc0205892:	e426                	sd	s1,8(sp)
ffffffffc0205894:	8626                	mv	a2,s1
ffffffffc0205896:	b771                	j	ffffffffc0205822 <sysfile_read+0x72>
ffffffffc0205898:	66a2                	ld	a3,8(sp)
ffffffffc020589a:	bf45                	j	ffffffffc020584a <sysfile_read+0x9a>
ffffffffc020589c:	5475                	li	s0,-3
ffffffffc020589e:	b73d                	j	ffffffffc02057cc <sysfile_read+0x1c>
ffffffffc02058a0:	5471                	li	s0,-4
ffffffffc02058a2:	b72d                	j	ffffffffc02057cc <sysfile_read+0x1c>
ffffffffc02058a4:	00008697          	auipc	a3,0x8
ffffffffc02058a8:	0f468693          	addi	a3,a3,244 # ffffffffc020d998 <CSWTCH.79+0xc8>
ffffffffc02058ac:	00006617          	auipc	a2,0x6
ffffffffc02058b0:	41c60613          	addi	a2,a2,1052 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02058b4:	05500593          	li	a1,85
ffffffffc02058b8:	00008517          	auipc	a0,0x8
ffffffffc02058bc:	0f050513          	addi	a0,a0,240 # ffffffffc020d9a8 <CSWTCH.79+0xd8>
ffffffffc02058c0:	bdffa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02058c4 <sysfile_write>:
ffffffffc02058c4:	7159                	addi	sp,sp,-112
ffffffffc02058c6:	e8ca                	sd	s2,80(sp)
ffffffffc02058c8:	f486                	sd	ra,104(sp)
ffffffffc02058ca:	f0a2                	sd	s0,96(sp)
ffffffffc02058cc:	eca6                	sd	s1,88(sp)
ffffffffc02058ce:	e4ce                	sd	s3,72(sp)
ffffffffc02058d0:	e0d2                	sd	s4,64(sp)
ffffffffc02058d2:	fc56                	sd	s5,56(sp)
ffffffffc02058d4:	f85a                	sd	s6,48(sp)
ffffffffc02058d6:	f45e                	sd	s7,40(sp)
ffffffffc02058d8:	f062                	sd	s8,32(sp)
ffffffffc02058da:	ec66                	sd	s9,24(sp)
ffffffffc02058dc:	4901                	li	s2,0
ffffffffc02058de:	ee19                	bnez	a2,ffffffffc02058fc <sysfile_write+0x38>
ffffffffc02058e0:	70a6                	ld	ra,104(sp)
ffffffffc02058e2:	7406                	ld	s0,96(sp)
ffffffffc02058e4:	64e6                	ld	s1,88(sp)
ffffffffc02058e6:	69a6                	ld	s3,72(sp)
ffffffffc02058e8:	6a06                	ld	s4,64(sp)
ffffffffc02058ea:	7ae2                	ld	s5,56(sp)
ffffffffc02058ec:	7b42                	ld	s6,48(sp)
ffffffffc02058ee:	7ba2                	ld	s7,40(sp)
ffffffffc02058f0:	7c02                	ld	s8,32(sp)
ffffffffc02058f2:	6ce2                	ld	s9,24(sp)
ffffffffc02058f4:	854a                	mv	a0,s2
ffffffffc02058f6:	6946                	ld	s2,80(sp)
ffffffffc02058f8:	6165                	addi	sp,sp,112
ffffffffc02058fa:	8082                	ret
ffffffffc02058fc:	00091c17          	auipc	s8,0x91
ffffffffc0205900:	fd4c0c13          	addi	s8,s8,-44 # ffffffffc02968d0 <current>
ffffffffc0205904:	000c3783          	ld	a5,0(s8)
ffffffffc0205908:	8432                	mv	s0,a2
ffffffffc020590a:	89ae                	mv	s3,a1
ffffffffc020590c:	4605                	li	a2,1
ffffffffc020590e:	4581                	li	a1,0
ffffffffc0205910:	7784                	ld	s1,40(a5)
ffffffffc0205912:	8baa                	mv	s7,a0
ffffffffc0205914:	b8cff0ef          	jal	ra,ffffffffc0204ca0 <file_testfd>
ffffffffc0205918:	cd59                	beqz	a0,ffffffffc02059b6 <sysfile_write+0xf2>
ffffffffc020591a:	6505                	lui	a0,0x1
ffffffffc020591c:	ef6fc0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0205920:	8a2a                	mv	s4,a0
ffffffffc0205922:	cd41                	beqz	a0,ffffffffc02059ba <sysfile_write+0xf6>
ffffffffc0205924:	4c81                	li	s9,0
ffffffffc0205926:	6a85                	lui	s5,0x1
ffffffffc0205928:	03848b13          	addi	s6,s1,56
ffffffffc020592c:	05546a63          	bltu	s0,s5,ffffffffc0205980 <sysfile_write+0xbc>
ffffffffc0205930:	e456                	sd	s5,8(sp)
ffffffffc0205932:	c8a9                	beqz	s1,ffffffffc0205984 <sysfile_write+0xc0>
ffffffffc0205934:	855a                	mv	a0,s6
ffffffffc0205936:	e81fe0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc020593a:	000c3783          	ld	a5,0(s8)
ffffffffc020593e:	c399                	beqz	a5,ffffffffc0205944 <sysfile_write+0x80>
ffffffffc0205940:	43dc                	lw	a5,4(a5)
ffffffffc0205942:	c8bc                	sw	a5,80(s1)
ffffffffc0205944:	66a2                	ld	a3,8(sp)
ffffffffc0205946:	4701                	li	a4,0
ffffffffc0205948:	864e                	mv	a2,s3
ffffffffc020594a:	85d2                	mv	a1,s4
ffffffffc020594c:	8526                	mv	a0,s1
ffffffffc020594e:	c2bfe0ef          	jal	ra,ffffffffc0204578 <copy_from_user>
ffffffffc0205952:	c139                	beqz	a0,ffffffffc0205998 <sysfile_write+0xd4>
ffffffffc0205954:	855a                	mv	a0,s6
ffffffffc0205956:	e5dfe0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020595a:	0404a823          	sw	zero,80(s1)
ffffffffc020595e:	6622                	ld	a2,8(sp)
ffffffffc0205960:	0034                	addi	a3,sp,8
ffffffffc0205962:	85d2                	mv	a1,s4
ffffffffc0205964:	855e                	mv	a0,s7
ffffffffc0205966:	dc8ff0ef          	jal	ra,ffffffffc0204f2e <file_write>
ffffffffc020596a:	67a2                	ld	a5,8(sp)
ffffffffc020596c:	892a                	mv	s2,a0
ffffffffc020596e:	ef85                	bnez	a5,ffffffffc02059a6 <sysfile_write+0xe2>
ffffffffc0205970:	8552                	mv	a0,s4
ffffffffc0205972:	f50fc0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0205976:	f60c85e3          	beqz	s9,ffffffffc02058e0 <sysfile_write+0x1c>
ffffffffc020597a:	000c891b          	sext.w	s2,s9
ffffffffc020597e:	b78d                	j	ffffffffc02058e0 <sysfile_write+0x1c>
ffffffffc0205980:	e422                	sd	s0,8(sp)
ffffffffc0205982:	f8cd                	bnez	s1,ffffffffc0205934 <sysfile_write+0x70>
ffffffffc0205984:	66a2                	ld	a3,8(sp)
ffffffffc0205986:	4701                	li	a4,0
ffffffffc0205988:	864e                	mv	a2,s3
ffffffffc020598a:	85d2                	mv	a1,s4
ffffffffc020598c:	4501                	li	a0,0
ffffffffc020598e:	bebfe0ef          	jal	ra,ffffffffc0204578 <copy_from_user>
ffffffffc0205992:	f571                	bnez	a0,ffffffffc020595e <sysfile_write+0x9a>
ffffffffc0205994:	5975                	li	s2,-3
ffffffffc0205996:	bfe9                	j	ffffffffc0205970 <sysfile_write+0xac>
ffffffffc0205998:	855a                	mv	a0,s6
ffffffffc020599a:	e19fe0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020599e:	5975                	li	s2,-3
ffffffffc02059a0:	0404a823          	sw	zero,80(s1)
ffffffffc02059a4:	b7f1                	j	ffffffffc0205970 <sysfile_write+0xac>
ffffffffc02059a6:	00f46c63          	bltu	s0,a5,ffffffffc02059be <sysfile_write+0xfa>
ffffffffc02059aa:	99be                	add	s3,s3,a5
ffffffffc02059ac:	8c1d                	sub	s0,s0,a5
ffffffffc02059ae:	9cbe                	add	s9,s9,a5
ffffffffc02059b0:	f161                	bnez	a0,ffffffffc0205970 <sysfile_write+0xac>
ffffffffc02059b2:	fc2d                	bnez	s0,ffffffffc020592c <sysfile_write+0x68>
ffffffffc02059b4:	bf75                	j	ffffffffc0205970 <sysfile_write+0xac>
ffffffffc02059b6:	5975                	li	s2,-3
ffffffffc02059b8:	b725                	j	ffffffffc02058e0 <sysfile_write+0x1c>
ffffffffc02059ba:	5971                	li	s2,-4
ffffffffc02059bc:	b715                	j	ffffffffc02058e0 <sysfile_write+0x1c>
ffffffffc02059be:	00008697          	auipc	a3,0x8
ffffffffc02059c2:	fda68693          	addi	a3,a3,-38 # ffffffffc020d998 <CSWTCH.79+0xc8>
ffffffffc02059c6:	00006617          	auipc	a2,0x6
ffffffffc02059ca:	30260613          	addi	a2,a2,770 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02059ce:	08a00593          	li	a1,138
ffffffffc02059d2:	00008517          	auipc	a0,0x8
ffffffffc02059d6:	fd650513          	addi	a0,a0,-42 # ffffffffc020d9a8 <CSWTCH.79+0xd8>
ffffffffc02059da:	ac5fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02059de <sysfile_seek>:
ffffffffc02059de:	e36ff06f          	j	ffffffffc0205014 <file_seek>

ffffffffc02059e2 <sysfile_fstat>:
ffffffffc02059e2:	715d                	addi	sp,sp,-80
ffffffffc02059e4:	f44e                	sd	s3,40(sp)
ffffffffc02059e6:	00091997          	auipc	s3,0x91
ffffffffc02059ea:	eea98993          	addi	s3,s3,-278 # ffffffffc02968d0 <current>
ffffffffc02059ee:	0009b703          	ld	a4,0(s3)
ffffffffc02059f2:	fc26                	sd	s1,56(sp)
ffffffffc02059f4:	84ae                	mv	s1,a1
ffffffffc02059f6:	858a                	mv	a1,sp
ffffffffc02059f8:	e0a2                	sd	s0,64(sp)
ffffffffc02059fa:	f84a                	sd	s2,48(sp)
ffffffffc02059fc:	e486                	sd	ra,72(sp)
ffffffffc02059fe:	02873903          	ld	s2,40(a4)
ffffffffc0205a02:	f052                	sd	s4,32(sp)
ffffffffc0205a04:	f30ff0ef          	jal	ra,ffffffffc0205134 <file_fstat>
ffffffffc0205a08:	842a                	mv	s0,a0
ffffffffc0205a0a:	e91d                	bnez	a0,ffffffffc0205a40 <sysfile_fstat+0x5e>
ffffffffc0205a0c:	04090363          	beqz	s2,ffffffffc0205a52 <sysfile_fstat+0x70>
ffffffffc0205a10:	03890a13          	addi	s4,s2,56
ffffffffc0205a14:	8552                	mv	a0,s4
ffffffffc0205a16:	da1fe0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc0205a1a:	0009b783          	ld	a5,0(s3)
ffffffffc0205a1e:	c3b9                	beqz	a5,ffffffffc0205a64 <sysfile_fstat+0x82>
ffffffffc0205a20:	43dc                	lw	a5,4(a5)
ffffffffc0205a22:	02000693          	li	a3,32
ffffffffc0205a26:	860a                	mv	a2,sp
ffffffffc0205a28:	04f92823          	sw	a5,80(s2)
ffffffffc0205a2c:	85a6                	mv	a1,s1
ffffffffc0205a2e:	854a                	mv	a0,s2
ffffffffc0205a30:	b7dfe0ef          	jal	ra,ffffffffc02045ac <copy_to_user>
ffffffffc0205a34:	c121                	beqz	a0,ffffffffc0205a74 <sysfile_fstat+0x92>
ffffffffc0205a36:	8552                	mv	a0,s4
ffffffffc0205a38:	d7bfe0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0205a3c:	04092823          	sw	zero,80(s2)
ffffffffc0205a40:	60a6                	ld	ra,72(sp)
ffffffffc0205a42:	8522                	mv	a0,s0
ffffffffc0205a44:	6406                	ld	s0,64(sp)
ffffffffc0205a46:	74e2                	ld	s1,56(sp)
ffffffffc0205a48:	7942                	ld	s2,48(sp)
ffffffffc0205a4a:	79a2                	ld	s3,40(sp)
ffffffffc0205a4c:	7a02                	ld	s4,32(sp)
ffffffffc0205a4e:	6161                	addi	sp,sp,80
ffffffffc0205a50:	8082                	ret
ffffffffc0205a52:	02000693          	li	a3,32
ffffffffc0205a56:	860a                	mv	a2,sp
ffffffffc0205a58:	85a6                	mv	a1,s1
ffffffffc0205a5a:	b53fe0ef          	jal	ra,ffffffffc02045ac <copy_to_user>
ffffffffc0205a5e:	f16d                	bnez	a0,ffffffffc0205a40 <sysfile_fstat+0x5e>
ffffffffc0205a60:	5475                	li	s0,-3
ffffffffc0205a62:	bff9                	j	ffffffffc0205a40 <sysfile_fstat+0x5e>
ffffffffc0205a64:	02000693          	li	a3,32
ffffffffc0205a68:	860a                	mv	a2,sp
ffffffffc0205a6a:	85a6                	mv	a1,s1
ffffffffc0205a6c:	854a                	mv	a0,s2
ffffffffc0205a6e:	b3ffe0ef          	jal	ra,ffffffffc02045ac <copy_to_user>
ffffffffc0205a72:	f171                	bnez	a0,ffffffffc0205a36 <sysfile_fstat+0x54>
ffffffffc0205a74:	8552                	mv	a0,s4
ffffffffc0205a76:	d3dfe0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0205a7a:	5475                	li	s0,-3
ffffffffc0205a7c:	04092823          	sw	zero,80(s2)
ffffffffc0205a80:	b7c1                	j	ffffffffc0205a40 <sysfile_fstat+0x5e>

ffffffffc0205a82 <sysfile_fsync>:
ffffffffc0205a82:	f72ff06f          	j	ffffffffc02051f4 <file_fsync>

ffffffffc0205a86 <sysfile_getcwd>:
ffffffffc0205a86:	715d                	addi	sp,sp,-80
ffffffffc0205a88:	f44e                	sd	s3,40(sp)
ffffffffc0205a8a:	00091997          	auipc	s3,0x91
ffffffffc0205a8e:	e4698993          	addi	s3,s3,-442 # ffffffffc02968d0 <current>
ffffffffc0205a92:	0009b783          	ld	a5,0(s3)
ffffffffc0205a96:	f84a                	sd	s2,48(sp)
ffffffffc0205a98:	e486                	sd	ra,72(sp)
ffffffffc0205a9a:	e0a2                	sd	s0,64(sp)
ffffffffc0205a9c:	fc26                	sd	s1,56(sp)
ffffffffc0205a9e:	f052                	sd	s4,32(sp)
ffffffffc0205aa0:	0287b903          	ld	s2,40(a5)
ffffffffc0205aa4:	cda9                	beqz	a1,ffffffffc0205afe <sysfile_getcwd+0x78>
ffffffffc0205aa6:	842e                	mv	s0,a1
ffffffffc0205aa8:	84aa                	mv	s1,a0
ffffffffc0205aaa:	04090363          	beqz	s2,ffffffffc0205af0 <sysfile_getcwd+0x6a>
ffffffffc0205aae:	03890a13          	addi	s4,s2,56
ffffffffc0205ab2:	8552                	mv	a0,s4
ffffffffc0205ab4:	d03fe0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc0205ab8:	0009b783          	ld	a5,0(s3)
ffffffffc0205abc:	c781                	beqz	a5,ffffffffc0205ac4 <sysfile_getcwd+0x3e>
ffffffffc0205abe:	43dc                	lw	a5,4(a5)
ffffffffc0205ac0:	04f92823          	sw	a5,80(s2)
ffffffffc0205ac4:	4685                	li	a3,1
ffffffffc0205ac6:	8622                	mv	a2,s0
ffffffffc0205ac8:	85a6                	mv	a1,s1
ffffffffc0205aca:	854a                	mv	a0,s2
ffffffffc0205acc:	a19fe0ef          	jal	ra,ffffffffc02044e4 <user_mem_check>
ffffffffc0205ad0:	e90d                	bnez	a0,ffffffffc0205b02 <sysfile_getcwd+0x7c>
ffffffffc0205ad2:	5475                	li	s0,-3
ffffffffc0205ad4:	8552                	mv	a0,s4
ffffffffc0205ad6:	cddfe0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0205ada:	04092823          	sw	zero,80(s2)
ffffffffc0205ade:	60a6                	ld	ra,72(sp)
ffffffffc0205ae0:	8522                	mv	a0,s0
ffffffffc0205ae2:	6406                	ld	s0,64(sp)
ffffffffc0205ae4:	74e2                	ld	s1,56(sp)
ffffffffc0205ae6:	7942                	ld	s2,48(sp)
ffffffffc0205ae8:	79a2                	ld	s3,40(sp)
ffffffffc0205aea:	7a02                	ld	s4,32(sp)
ffffffffc0205aec:	6161                	addi	sp,sp,80
ffffffffc0205aee:	8082                	ret
ffffffffc0205af0:	862e                	mv	a2,a1
ffffffffc0205af2:	4685                	li	a3,1
ffffffffc0205af4:	85aa                	mv	a1,a0
ffffffffc0205af6:	4501                	li	a0,0
ffffffffc0205af8:	9edfe0ef          	jal	ra,ffffffffc02044e4 <user_mem_check>
ffffffffc0205afc:	ed09                	bnez	a0,ffffffffc0205b16 <sysfile_getcwd+0x90>
ffffffffc0205afe:	5475                	li	s0,-3
ffffffffc0205b00:	bff9                	j	ffffffffc0205ade <sysfile_getcwd+0x58>
ffffffffc0205b02:	8622                	mv	a2,s0
ffffffffc0205b04:	4681                	li	a3,0
ffffffffc0205b06:	85a6                	mv	a1,s1
ffffffffc0205b08:	850a                	mv	a0,sp
ffffffffc0205b0a:	b2bff0ef          	jal	ra,ffffffffc0205634 <iobuf_init>
ffffffffc0205b0e:	451020ef          	jal	ra,ffffffffc020875e <vfs_getcwd>
ffffffffc0205b12:	842a                	mv	s0,a0
ffffffffc0205b14:	b7c1                	j	ffffffffc0205ad4 <sysfile_getcwd+0x4e>
ffffffffc0205b16:	8622                	mv	a2,s0
ffffffffc0205b18:	4681                	li	a3,0
ffffffffc0205b1a:	85a6                	mv	a1,s1
ffffffffc0205b1c:	850a                	mv	a0,sp
ffffffffc0205b1e:	b17ff0ef          	jal	ra,ffffffffc0205634 <iobuf_init>
ffffffffc0205b22:	43d020ef          	jal	ra,ffffffffc020875e <vfs_getcwd>
ffffffffc0205b26:	842a                	mv	s0,a0
ffffffffc0205b28:	bf5d                	j	ffffffffc0205ade <sysfile_getcwd+0x58>

ffffffffc0205b2a <sysfile_getdirentry>:
ffffffffc0205b2a:	7139                	addi	sp,sp,-64
ffffffffc0205b2c:	e852                	sd	s4,16(sp)
ffffffffc0205b2e:	00091a17          	auipc	s4,0x91
ffffffffc0205b32:	da2a0a13          	addi	s4,s4,-606 # ffffffffc02968d0 <current>
ffffffffc0205b36:	000a3703          	ld	a4,0(s4)
ffffffffc0205b3a:	ec4e                	sd	s3,24(sp)
ffffffffc0205b3c:	89aa                	mv	s3,a0
ffffffffc0205b3e:	10800513          	li	a0,264
ffffffffc0205b42:	f426                	sd	s1,40(sp)
ffffffffc0205b44:	f04a                	sd	s2,32(sp)
ffffffffc0205b46:	fc06                	sd	ra,56(sp)
ffffffffc0205b48:	f822                	sd	s0,48(sp)
ffffffffc0205b4a:	e456                	sd	s5,8(sp)
ffffffffc0205b4c:	7704                	ld	s1,40(a4)
ffffffffc0205b4e:	892e                	mv	s2,a1
ffffffffc0205b50:	cc2fc0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0205b54:	c169                	beqz	a0,ffffffffc0205c16 <sysfile_getdirentry+0xec>
ffffffffc0205b56:	842a                	mv	s0,a0
ffffffffc0205b58:	c8c1                	beqz	s1,ffffffffc0205be8 <sysfile_getdirentry+0xbe>
ffffffffc0205b5a:	03848a93          	addi	s5,s1,56
ffffffffc0205b5e:	8556                	mv	a0,s5
ffffffffc0205b60:	c57fe0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc0205b64:	000a3783          	ld	a5,0(s4)
ffffffffc0205b68:	c399                	beqz	a5,ffffffffc0205b6e <sysfile_getdirentry+0x44>
ffffffffc0205b6a:	43dc                	lw	a5,4(a5)
ffffffffc0205b6c:	c8bc                	sw	a5,80(s1)
ffffffffc0205b6e:	4705                	li	a4,1
ffffffffc0205b70:	46a1                	li	a3,8
ffffffffc0205b72:	864a                	mv	a2,s2
ffffffffc0205b74:	85a2                	mv	a1,s0
ffffffffc0205b76:	8526                	mv	a0,s1
ffffffffc0205b78:	a01fe0ef          	jal	ra,ffffffffc0204578 <copy_from_user>
ffffffffc0205b7c:	e505                	bnez	a0,ffffffffc0205ba4 <sysfile_getdirentry+0x7a>
ffffffffc0205b7e:	8556                	mv	a0,s5
ffffffffc0205b80:	c33fe0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0205b84:	59f5                	li	s3,-3
ffffffffc0205b86:	0404a823          	sw	zero,80(s1)
ffffffffc0205b8a:	8522                	mv	a0,s0
ffffffffc0205b8c:	d36fc0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0205b90:	70e2                	ld	ra,56(sp)
ffffffffc0205b92:	7442                	ld	s0,48(sp)
ffffffffc0205b94:	74a2                	ld	s1,40(sp)
ffffffffc0205b96:	7902                	ld	s2,32(sp)
ffffffffc0205b98:	6a42                	ld	s4,16(sp)
ffffffffc0205b9a:	6aa2                	ld	s5,8(sp)
ffffffffc0205b9c:	854e                	mv	a0,s3
ffffffffc0205b9e:	69e2                	ld	s3,24(sp)
ffffffffc0205ba0:	6121                	addi	sp,sp,64
ffffffffc0205ba2:	8082                	ret
ffffffffc0205ba4:	8556                	mv	a0,s5
ffffffffc0205ba6:	c0dfe0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0205baa:	854e                	mv	a0,s3
ffffffffc0205bac:	85a2                	mv	a1,s0
ffffffffc0205bae:	0404a823          	sw	zero,80(s1)
ffffffffc0205bb2:	ef0ff0ef          	jal	ra,ffffffffc02052a2 <file_getdirentry>
ffffffffc0205bb6:	89aa                	mv	s3,a0
ffffffffc0205bb8:	f969                	bnez	a0,ffffffffc0205b8a <sysfile_getdirentry+0x60>
ffffffffc0205bba:	8556                	mv	a0,s5
ffffffffc0205bbc:	bfbfe0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc0205bc0:	000a3783          	ld	a5,0(s4)
ffffffffc0205bc4:	c399                	beqz	a5,ffffffffc0205bca <sysfile_getdirentry+0xa0>
ffffffffc0205bc6:	43dc                	lw	a5,4(a5)
ffffffffc0205bc8:	c8bc                	sw	a5,80(s1)
ffffffffc0205bca:	10800693          	li	a3,264
ffffffffc0205bce:	8622                	mv	a2,s0
ffffffffc0205bd0:	85ca                	mv	a1,s2
ffffffffc0205bd2:	8526                	mv	a0,s1
ffffffffc0205bd4:	9d9fe0ef          	jal	ra,ffffffffc02045ac <copy_to_user>
ffffffffc0205bd8:	e111                	bnez	a0,ffffffffc0205bdc <sysfile_getdirentry+0xb2>
ffffffffc0205bda:	59f5                	li	s3,-3
ffffffffc0205bdc:	8556                	mv	a0,s5
ffffffffc0205bde:	bd5fe0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0205be2:	0404a823          	sw	zero,80(s1)
ffffffffc0205be6:	b755                	j	ffffffffc0205b8a <sysfile_getdirentry+0x60>
ffffffffc0205be8:	85aa                	mv	a1,a0
ffffffffc0205bea:	4705                	li	a4,1
ffffffffc0205bec:	46a1                	li	a3,8
ffffffffc0205bee:	864a                	mv	a2,s2
ffffffffc0205bf0:	4501                	li	a0,0
ffffffffc0205bf2:	987fe0ef          	jal	ra,ffffffffc0204578 <copy_from_user>
ffffffffc0205bf6:	cd11                	beqz	a0,ffffffffc0205c12 <sysfile_getdirentry+0xe8>
ffffffffc0205bf8:	854e                	mv	a0,s3
ffffffffc0205bfa:	85a2                	mv	a1,s0
ffffffffc0205bfc:	ea6ff0ef          	jal	ra,ffffffffc02052a2 <file_getdirentry>
ffffffffc0205c00:	89aa                	mv	s3,a0
ffffffffc0205c02:	f541                	bnez	a0,ffffffffc0205b8a <sysfile_getdirentry+0x60>
ffffffffc0205c04:	10800693          	li	a3,264
ffffffffc0205c08:	8622                	mv	a2,s0
ffffffffc0205c0a:	85ca                	mv	a1,s2
ffffffffc0205c0c:	9a1fe0ef          	jal	ra,ffffffffc02045ac <copy_to_user>
ffffffffc0205c10:	fd2d                	bnez	a0,ffffffffc0205b8a <sysfile_getdirentry+0x60>
ffffffffc0205c12:	59f5                	li	s3,-3
ffffffffc0205c14:	bf9d                	j	ffffffffc0205b8a <sysfile_getdirentry+0x60>
ffffffffc0205c16:	59f1                	li	s3,-4
ffffffffc0205c18:	bfa5                	j	ffffffffc0205b90 <sysfile_getdirentry+0x66>

ffffffffc0205c1a <sysfile_dup>:
ffffffffc0205c1a:	f6eff06f          	j	ffffffffc0205388 <file_dup>

ffffffffc0205c1e <kernel_thread_entry>:
ffffffffc0205c1e:	8526                	mv	a0,s1
ffffffffc0205c20:	9402                	jalr	s0
ffffffffc0205c22:	622000ef          	jal	ra,ffffffffc0206244 <do_exit>

ffffffffc0205c26 <alloc_proc>:
ffffffffc0205c26:	1141                	addi	sp,sp,-16
ffffffffc0205c28:	15000513          	li	a0,336
ffffffffc0205c2c:	e022                	sd	s0,0(sp)
ffffffffc0205c2e:	e406                	sd	ra,8(sp)
ffffffffc0205c30:	be2fc0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0205c34:	842a                	mv	s0,a0
ffffffffc0205c36:	c141                	beqz	a0,ffffffffc0205cb6 <alloc_proc+0x90>
ffffffffc0205c38:	57fd                	li	a5,-1
ffffffffc0205c3a:	1782                	slli	a5,a5,0x20
ffffffffc0205c3c:	e11c                	sd	a5,0(a0)
ffffffffc0205c3e:	07000613          	li	a2,112
ffffffffc0205c42:	4581                	li	a1,0
ffffffffc0205c44:	14053423          	sd	zero,328(a0)
ffffffffc0205c48:	00052423          	sw	zero,8(a0)
ffffffffc0205c4c:	00053823          	sd	zero,16(a0)
ffffffffc0205c50:	00053c23          	sd	zero,24(a0)
ffffffffc0205c54:	02053023          	sd	zero,32(a0)
ffffffffc0205c58:	02053423          	sd	zero,40(a0)
ffffffffc0205c5c:	03050513          	addi	a0,a0,48
ffffffffc0205c60:	387050ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0205c64:	00091797          	auipc	a5,0x91
ffffffffc0205c68:	c2c7b783          	ld	a5,-980(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0205c6c:	f45c                	sd	a5,168(s0)
ffffffffc0205c6e:	0a043023          	sd	zero,160(s0)
ffffffffc0205c72:	0a042823          	sw	zero,176(s0)
ffffffffc0205c76:	463d                	li	a2,15
ffffffffc0205c78:	4581                	li	a1,0
ffffffffc0205c7a:	0b440513          	addi	a0,s0,180
ffffffffc0205c7e:	369050ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0205c82:	11040793          	addi	a5,s0,272
ffffffffc0205c86:	0e042623          	sw	zero,236(s0)
ffffffffc0205c8a:	0e043c23          	sd	zero,248(s0)
ffffffffc0205c8e:	10043023          	sd	zero,256(s0)
ffffffffc0205c92:	0e043823          	sd	zero,240(s0)
ffffffffc0205c96:	10043423          	sd	zero,264(s0)
ffffffffc0205c9a:	10f43c23          	sd	a5,280(s0)
ffffffffc0205c9e:	10f43823          	sd	a5,272(s0)
ffffffffc0205ca2:	12042023          	sw	zero,288(s0)
ffffffffc0205ca6:	12043423          	sd	zero,296(s0)
ffffffffc0205caa:	12043823          	sd	zero,304(s0)
ffffffffc0205cae:	12043c23          	sd	zero,312(s0)
ffffffffc0205cb2:	14043023          	sd	zero,320(s0)
ffffffffc0205cb6:	60a2                	ld	ra,8(sp)
ffffffffc0205cb8:	8522                	mv	a0,s0
ffffffffc0205cba:	6402                	ld	s0,0(sp)
ffffffffc0205cbc:	0141                	addi	sp,sp,16
ffffffffc0205cbe:	8082                	ret

ffffffffc0205cc0 <forkret>:
ffffffffc0205cc0:	00091797          	auipc	a5,0x91
ffffffffc0205cc4:	c107b783          	ld	a5,-1008(a5) # ffffffffc02968d0 <current>
ffffffffc0205cc8:	73c8                	ld	a0,160(a5)
ffffffffc0205cca:	e64fb06f          	j	ffffffffc020132e <forkrets>

ffffffffc0205cce <pa2page.part.0>:
ffffffffc0205cce:	1141                	addi	sp,sp,-16
ffffffffc0205cd0:	00007617          	auipc	a2,0x7
ffffffffc0205cd4:	c0860613          	addi	a2,a2,-1016 # ffffffffc020c8d8 <default_pmm_manager+0x108>
ffffffffc0205cd8:	06900593          	li	a1,105
ffffffffc0205cdc:	00007517          	auipc	a0,0x7
ffffffffc0205ce0:	b5450513          	addi	a0,a0,-1196 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0205ce4:	e406                	sd	ra,8(sp)
ffffffffc0205ce6:	fb8fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205cea <pte2page.part.0>:
ffffffffc0205cea:	1141                	addi	sp,sp,-16
ffffffffc0205cec:	00007617          	auipc	a2,0x7
ffffffffc0205cf0:	c0c60613          	addi	a2,a2,-1012 # ffffffffc020c8f8 <default_pmm_manager+0x128>
ffffffffc0205cf4:	07f00593          	li	a1,127
ffffffffc0205cf8:	00007517          	auipc	a0,0x7
ffffffffc0205cfc:	b3850513          	addi	a0,a0,-1224 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0205d00:	e406                	sd	ra,8(sp)
ffffffffc0205d02:	f9cfa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205d06 <put_pgdir.isra.0>:
ffffffffc0205d06:	1141                	addi	sp,sp,-16
ffffffffc0205d08:	e406                	sd	ra,8(sp)
ffffffffc0205d0a:	c02007b7          	lui	a5,0xc0200
ffffffffc0205d0e:	02f56e63          	bltu	a0,a5,ffffffffc0205d4a <put_pgdir.isra.0+0x44>
ffffffffc0205d12:	00091697          	auipc	a3,0x91
ffffffffc0205d16:	ba66b683          	ld	a3,-1114(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205d1a:	8d15                	sub	a0,a0,a3
ffffffffc0205d1c:	8131                	srli	a0,a0,0xc
ffffffffc0205d1e:	00091797          	auipc	a5,0x91
ffffffffc0205d22:	b827b783          	ld	a5,-1150(a5) # ffffffffc02968a0 <npage>
ffffffffc0205d26:	02f57f63          	bgeu	a0,a5,ffffffffc0205d64 <put_pgdir.isra.0+0x5e>
ffffffffc0205d2a:	0000a697          	auipc	a3,0xa
ffffffffc0205d2e:	0066b683          	ld	a3,6(a3) # ffffffffc020fd30 <nbase>
ffffffffc0205d32:	60a2                	ld	ra,8(sp)
ffffffffc0205d34:	8d15                	sub	a0,a0,a3
ffffffffc0205d36:	00091797          	auipc	a5,0x91
ffffffffc0205d3a:	b727b783          	ld	a5,-1166(a5) # ffffffffc02968a8 <pages>
ffffffffc0205d3e:	051a                	slli	a0,a0,0x6
ffffffffc0205d40:	4585                	li	a1,1
ffffffffc0205d42:	953e                	add	a0,a0,a5
ffffffffc0205d44:	0141                	addi	sp,sp,16
ffffffffc0205d46:	ce8fc06f          	j	ffffffffc020222e <free_pages>
ffffffffc0205d4a:	86aa                	mv	a3,a0
ffffffffc0205d4c:	00007617          	auipc	a2,0x7
ffffffffc0205d50:	b6460613          	addi	a2,a2,-1180 # ffffffffc020c8b0 <default_pmm_manager+0xe0>
ffffffffc0205d54:	07700593          	li	a1,119
ffffffffc0205d58:	00007517          	auipc	a0,0x7
ffffffffc0205d5c:	ad850513          	addi	a0,a0,-1320 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0205d60:	f3efa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205d64:	f6bff0ef          	jal	ra,ffffffffc0205cce <pa2page.part.0>

ffffffffc0205d68 <proc_run>:
ffffffffc0205d68:	7179                	addi	sp,sp,-48
ffffffffc0205d6a:	ec4a                	sd	s2,24(sp)
ffffffffc0205d6c:	00091917          	auipc	s2,0x91
ffffffffc0205d70:	b6490913          	addi	s2,s2,-1180 # ffffffffc02968d0 <current>
ffffffffc0205d74:	f026                	sd	s1,32(sp)
ffffffffc0205d76:	00093483          	ld	s1,0(s2)
ffffffffc0205d7a:	f406                	sd	ra,40(sp)
ffffffffc0205d7c:	e84e                	sd	s3,16(sp)
ffffffffc0205d7e:	02a48a63          	beq	s1,a0,ffffffffc0205db2 <proc_run+0x4a>
ffffffffc0205d82:	100027f3          	csrr	a5,sstatus
ffffffffc0205d86:	8b89                	andi	a5,a5,2
ffffffffc0205d88:	4981                	li	s3,0
ffffffffc0205d8a:	e3a9                	bnez	a5,ffffffffc0205dcc <proc_run+0x64>
ffffffffc0205d8c:	755c                	ld	a5,168(a0)
ffffffffc0205d8e:	577d                	li	a4,-1
ffffffffc0205d90:	177e                	slli	a4,a4,0x3f
ffffffffc0205d92:	83b1                	srli	a5,a5,0xc
ffffffffc0205d94:	00a93023          	sd	a0,0(s2)
ffffffffc0205d98:	8fd9                	or	a5,a5,a4
ffffffffc0205d9a:	18079073          	csrw	satp,a5
ffffffffc0205d9e:	12000073          	sfence.vma
ffffffffc0205da2:	03050593          	addi	a1,a0,48
ffffffffc0205da6:	03048513          	addi	a0,s1,48
ffffffffc0205daa:	6a4010ef          	jal	ra,ffffffffc020744e <switch_to>
ffffffffc0205dae:	00099863          	bnez	s3,ffffffffc0205dbe <proc_run+0x56>
ffffffffc0205db2:	70a2                	ld	ra,40(sp)
ffffffffc0205db4:	7482                	ld	s1,32(sp)
ffffffffc0205db6:	6962                	ld	s2,24(sp)
ffffffffc0205db8:	69c2                	ld	s3,16(sp)
ffffffffc0205dba:	6145                	addi	sp,sp,48
ffffffffc0205dbc:	8082                	ret
ffffffffc0205dbe:	70a2                	ld	ra,40(sp)
ffffffffc0205dc0:	7482                	ld	s1,32(sp)
ffffffffc0205dc2:	6962                	ld	s2,24(sp)
ffffffffc0205dc4:	69c2                	ld	s3,16(sp)
ffffffffc0205dc6:	6145                	addi	sp,sp,48
ffffffffc0205dc8:	ea5fa06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0205dcc:	e42a                	sd	a0,8(sp)
ffffffffc0205dce:	ea5fa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0205dd2:	6522                	ld	a0,8(sp)
ffffffffc0205dd4:	4985                	li	s3,1
ffffffffc0205dd6:	bf5d                	j	ffffffffc0205d8c <proc_run+0x24>

ffffffffc0205dd8 <do_fork>:
ffffffffc0205dd8:	7119                	addi	sp,sp,-128
ffffffffc0205dda:	ecce                	sd	s3,88(sp)
ffffffffc0205ddc:	00091997          	auipc	s3,0x91
ffffffffc0205de0:	b0c98993          	addi	s3,s3,-1268 # ffffffffc02968e8 <nr_process>
ffffffffc0205de4:	0009a703          	lw	a4,0(s3)
ffffffffc0205de8:	fc86                	sd	ra,120(sp)
ffffffffc0205dea:	f8a2                	sd	s0,112(sp)
ffffffffc0205dec:	f4a6                	sd	s1,104(sp)
ffffffffc0205dee:	f0ca                	sd	s2,96(sp)
ffffffffc0205df0:	e8d2                	sd	s4,80(sp)
ffffffffc0205df2:	e4d6                	sd	s5,72(sp)
ffffffffc0205df4:	e0da                	sd	s6,64(sp)
ffffffffc0205df6:	fc5e                	sd	s7,56(sp)
ffffffffc0205df8:	f862                	sd	s8,48(sp)
ffffffffc0205dfa:	f466                	sd	s9,40(sp)
ffffffffc0205dfc:	f06a                	sd	s10,32(sp)
ffffffffc0205dfe:	ec6e                	sd	s11,24(sp)
ffffffffc0205e00:	6785                	lui	a5,0x1
ffffffffc0205e02:	34f75263          	bge	a4,a5,ffffffffc0206146 <do_fork+0x36e>
ffffffffc0205e06:	892a                	mv	s2,a0
ffffffffc0205e08:	8a2e                	mv	s4,a1
ffffffffc0205e0a:	8432                	mv	s0,a2
ffffffffc0205e0c:	e1bff0ef          	jal	ra,ffffffffc0205c26 <alloc_proc>
ffffffffc0205e10:	84aa                	mv	s1,a0
ffffffffc0205e12:	28050363          	beqz	a0,ffffffffc0206098 <do_fork+0x2c0>
ffffffffc0205e16:	00091d97          	auipc	s11,0x91
ffffffffc0205e1a:	abad8d93          	addi	s11,s11,-1350 # ffffffffc02968d0 <current>
ffffffffc0205e1e:	000db783          	ld	a5,0(s11)
ffffffffc0205e22:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_bin_swap_img_size-0x6c14>
ffffffffc0205e26:	f11c                	sd	a5,32(a0)
ffffffffc0205e28:	3a071663          	bnez	a4,ffffffffc02061d4 <do_fork+0x3fc>
ffffffffc0205e2c:	4509                	li	a0,2
ffffffffc0205e2e:	bc2fc0ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc0205e32:	26050063          	beqz	a0,ffffffffc0206092 <do_fork+0x2ba>
ffffffffc0205e36:	00091b17          	auipc	s6,0x91
ffffffffc0205e3a:	a72b0b13          	addi	s6,s6,-1422 # ffffffffc02968a8 <pages>
ffffffffc0205e3e:	000b3683          	ld	a3,0(s6)
ffffffffc0205e42:	00091b97          	auipc	s7,0x91
ffffffffc0205e46:	a5eb8b93          	addi	s7,s7,-1442 # ffffffffc02968a0 <npage>
ffffffffc0205e4a:	0000aa97          	auipc	s5,0xa
ffffffffc0205e4e:	ee6aba83          	ld	s5,-282(s5) # ffffffffc020fd30 <nbase>
ffffffffc0205e52:	40d506b3          	sub	a3,a0,a3
ffffffffc0205e56:	8699                	srai	a3,a3,0x6
ffffffffc0205e58:	5cfd                	li	s9,-1
ffffffffc0205e5a:	000bb783          	ld	a5,0(s7)
ffffffffc0205e5e:	96d6                	add	a3,a3,s5
ffffffffc0205e60:	00ccdc93          	srli	s9,s9,0xc
ffffffffc0205e64:	0196f733          	and	a4,a3,s9
ffffffffc0205e68:	06b2                	slli	a3,a3,0xc
ffffffffc0205e6a:	30f77c63          	bgeu	a4,a5,ffffffffc0206182 <do_fork+0x3aa>
ffffffffc0205e6e:	000db883          	ld	a7,0(s11)
ffffffffc0205e72:	00091c17          	auipc	s8,0x91
ffffffffc0205e76:	a46c0c13          	addi	s8,s8,-1466 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205e7a:	000c3703          	ld	a4,0(s8)
ffffffffc0205e7e:	0288bd03          	ld	s10,40(a7) # 1028 <_binary_bin_swap_img_size-0x6cd8>
ffffffffc0205e82:	96ba                	add	a3,a3,a4
ffffffffc0205e84:	e894                	sd	a3,16(s1)
ffffffffc0205e86:	020d0a63          	beqz	s10,ffffffffc0205eba <do_fork+0xe2>
ffffffffc0205e8a:	10097713          	andi	a4,s2,256
ffffffffc0205e8e:	20070763          	beqz	a4,ffffffffc020609c <do_fork+0x2c4>
ffffffffc0205e92:	030d2683          	lw	a3,48(s10) # 200030 <_binary_bin_sfs_img_size+0x18ad30>
ffffffffc0205e96:	018d3703          	ld	a4,24(s10)
ffffffffc0205e9a:	c0200637          	lui	a2,0xc0200
ffffffffc0205e9e:	2685                	addiw	a3,a3,1
ffffffffc0205ea0:	02dd2823          	sw	a3,48(s10)
ffffffffc0205ea4:	03a4b423          	sd	s10,40(s1)
ffffffffc0205ea8:	2ec76963          	bltu	a4,a2,ffffffffc020619a <do_fork+0x3c2>
ffffffffc0205eac:	000c3783          	ld	a5,0(s8)
ffffffffc0205eb0:	000db883          	ld	a7,0(s11)
ffffffffc0205eb4:	6894                	ld	a3,16(s1)
ffffffffc0205eb6:	8f1d                	sub	a4,a4,a5
ffffffffc0205eb8:	f4d8                	sd	a4,168(s1)
ffffffffc0205eba:	6789                	lui	a5,0x2
ffffffffc0205ebc:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205ec0:	96be                	add	a3,a3,a5
ffffffffc0205ec2:	f0d4                	sd	a3,160(s1)
ffffffffc0205ec4:	87b6                	mv	a5,a3
ffffffffc0205ec6:	12040813          	addi	a6,s0,288
ffffffffc0205eca:	6008                	ld	a0,0(s0)
ffffffffc0205ecc:	640c                	ld	a1,8(s0)
ffffffffc0205ece:	6810                	ld	a2,16(s0)
ffffffffc0205ed0:	6c18                	ld	a4,24(s0)
ffffffffc0205ed2:	e388                	sd	a0,0(a5)
ffffffffc0205ed4:	e78c                	sd	a1,8(a5)
ffffffffc0205ed6:	eb90                	sd	a2,16(a5)
ffffffffc0205ed8:	ef98                	sd	a4,24(a5)
ffffffffc0205eda:	02040413          	addi	s0,s0,32
ffffffffc0205ede:	02078793          	addi	a5,a5,32
ffffffffc0205ee2:	ff0414e3          	bne	s0,a6,ffffffffc0205eca <do_fork+0xf2>
ffffffffc0205ee6:	0406b823          	sd	zero,80(a3)
ffffffffc0205eea:	140a0e63          	beqz	s4,ffffffffc0206046 <do_fork+0x26e>
ffffffffc0205eee:	1488b403          	ld	s0,328(a7)
ffffffffc0205ef2:	00000797          	auipc	a5,0x0
ffffffffc0205ef6:	dce78793          	addi	a5,a5,-562 # ffffffffc0205cc0 <forkret>
ffffffffc0205efa:	0146b823          	sd	s4,16(a3)
ffffffffc0205efe:	f89c                	sd	a5,48(s1)
ffffffffc0205f00:	fc94                	sd	a3,56(s1)
ffffffffc0205f02:	2a040963          	beqz	s0,ffffffffc02061b4 <do_fork+0x3dc>
ffffffffc0205f06:	00b95913          	srli	s2,s2,0xb
ffffffffc0205f0a:	00197913          	andi	s2,s2,1
ffffffffc0205f0e:	12090e63          	beqz	s2,ffffffffc020604a <do_fork+0x272>
ffffffffc0205f12:	481c                	lw	a5,16(s0)
ffffffffc0205f14:	2785                	addiw	a5,a5,1
ffffffffc0205f16:	c81c                	sw	a5,16(s0)
ffffffffc0205f18:	1484b423          	sd	s0,328(s1)
ffffffffc0205f1c:	100027f3          	csrr	a5,sstatus
ffffffffc0205f20:	8b89                	andi	a5,a5,2
ffffffffc0205f22:	4901                	li	s2,0
ffffffffc0205f24:	20079863          	bnez	a5,ffffffffc0206134 <do_fork+0x35c>
ffffffffc0205f28:	0008b817          	auipc	a6,0x8b
ffffffffc0205f2c:	13080813          	addi	a6,a6,304 # ffffffffc0291058 <last_pid.1>
ffffffffc0205f30:	00082783          	lw	a5,0(a6)
ffffffffc0205f34:	6709                	lui	a4,0x2
ffffffffc0205f36:	0017851b          	addiw	a0,a5,1
ffffffffc0205f3a:	00a82023          	sw	a0,0(a6)
ffffffffc0205f3e:	08e55d63          	bge	a0,a4,ffffffffc0205fd8 <do_fork+0x200>
ffffffffc0205f42:	0008b317          	auipc	t1,0x8b
ffffffffc0205f46:	11a30313          	addi	t1,t1,282 # ffffffffc029105c <next_safe.0>
ffffffffc0205f4a:	00032783          	lw	a5,0(t1)
ffffffffc0205f4e:	00090417          	auipc	s0,0x90
ffffffffc0205f52:	87240413          	addi	s0,s0,-1934 # ffffffffc02957c0 <proc_list>
ffffffffc0205f56:	08f55963          	bge	a0,a5,ffffffffc0205fe8 <do_fork+0x210>
ffffffffc0205f5a:	c0c8                	sw	a0,4(s1)
ffffffffc0205f5c:	45a9                	li	a1,10
ffffffffc0205f5e:	2501                	sext.w	a0,a0
ffffffffc0205f60:	352050ef          	jal	ra,ffffffffc020b2b2 <hash32>
ffffffffc0205f64:	02051793          	slli	a5,a0,0x20
ffffffffc0205f68:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205f6c:	0008c797          	auipc	a5,0x8c
ffffffffc0205f70:	85478793          	addi	a5,a5,-1964 # ffffffffc02917c0 <hash_list>
ffffffffc0205f74:	953e                	add	a0,a0,a5
ffffffffc0205f76:	650c                	ld	a1,8(a0)
ffffffffc0205f78:	7094                	ld	a3,32(s1)
ffffffffc0205f7a:	0d848793          	addi	a5,s1,216
ffffffffc0205f7e:	e19c                	sd	a5,0(a1)
ffffffffc0205f80:	6410                	ld	a2,8(s0)
ffffffffc0205f82:	e51c                	sd	a5,8(a0)
ffffffffc0205f84:	7af8                	ld	a4,240(a3)
ffffffffc0205f86:	0c848793          	addi	a5,s1,200
ffffffffc0205f8a:	f0ec                	sd	a1,224(s1)
ffffffffc0205f8c:	ece8                	sd	a0,216(s1)
ffffffffc0205f8e:	e21c                	sd	a5,0(a2)
ffffffffc0205f90:	e41c                	sd	a5,8(s0)
ffffffffc0205f92:	e8f0                	sd	a2,208(s1)
ffffffffc0205f94:	e4e0                	sd	s0,200(s1)
ffffffffc0205f96:	0e04bc23          	sd	zero,248(s1)
ffffffffc0205f9a:	10e4b023          	sd	a4,256(s1)
ffffffffc0205f9e:	c311                	beqz	a4,ffffffffc0205fa2 <do_fork+0x1ca>
ffffffffc0205fa0:	ff64                	sd	s1,248(a4)
ffffffffc0205fa2:	0009a783          	lw	a5,0(s3)
ffffffffc0205fa6:	fae4                	sd	s1,240(a3)
ffffffffc0205fa8:	2785                	addiw	a5,a5,1
ffffffffc0205faa:	00f9a023          	sw	a5,0(s3)
ffffffffc0205fae:	16091763          	bnez	s2,ffffffffc020611c <do_fork+0x344>
ffffffffc0205fb2:	8526                	mv	a0,s1
ffffffffc0205fb4:	618010ef          	jal	ra,ffffffffc02075cc <wakeup_proc>
ffffffffc0205fb8:	40c8                	lw	a0,4(s1)
ffffffffc0205fba:	70e6                	ld	ra,120(sp)
ffffffffc0205fbc:	7446                	ld	s0,112(sp)
ffffffffc0205fbe:	74a6                	ld	s1,104(sp)
ffffffffc0205fc0:	7906                	ld	s2,96(sp)
ffffffffc0205fc2:	69e6                	ld	s3,88(sp)
ffffffffc0205fc4:	6a46                	ld	s4,80(sp)
ffffffffc0205fc6:	6aa6                	ld	s5,72(sp)
ffffffffc0205fc8:	6b06                	ld	s6,64(sp)
ffffffffc0205fca:	7be2                	ld	s7,56(sp)
ffffffffc0205fcc:	7c42                	ld	s8,48(sp)
ffffffffc0205fce:	7ca2                	ld	s9,40(sp)
ffffffffc0205fd0:	7d02                	ld	s10,32(sp)
ffffffffc0205fd2:	6de2                	ld	s11,24(sp)
ffffffffc0205fd4:	6109                	addi	sp,sp,128
ffffffffc0205fd6:	8082                	ret
ffffffffc0205fd8:	4785                	li	a5,1
ffffffffc0205fda:	00f82023          	sw	a5,0(a6)
ffffffffc0205fde:	4505                	li	a0,1
ffffffffc0205fe0:	0008b317          	auipc	t1,0x8b
ffffffffc0205fe4:	07c30313          	addi	t1,t1,124 # ffffffffc029105c <next_safe.0>
ffffffffc0205fe8:	0008f417          	auipc	s0,0x8f
ffffffffc0205fec:	7d840413          	addi	s0,s0,2008 # ffffffffc02957c0 <proc_list>
ffffffffc0205ff0:	00843e03          	ld	t3,8(s0)
ffffffffc0205ff4:	6789                	lui	a5,0x2
ffffffffc0205ff6:	00f32023          	sw	a5,0(t1)
ffffffffc0205ffa:	86aa                	mv	a3,a0
ffffffffc0205ffc:	4581                	li	a1,0
ffffffffc0205ffe:	6e89                	lui	t4,0x2
ffffffffc0206000:	128e0e63          	beq	t3,s0,ffffffffc020613c <do_fork+0x364>
ffffffffc0206004:	88ae                	mv	a7,a1
ffffffffc0206006:	87f2                	mv	a5,t3
ffffffffc0206008:	6609                	lui	a2,0x2
ffffffffc020600a:	a811                	j	ffffffffc020601e <do_fork+0x246>
ffffffffc020600c:	00e6d663          	bge	a3,a4,ffffffffc0206018 <do_fork+0x240>
ffffffffc0206010:	00c75463          	bge	a4,a2,ffffffffc0206018 <do_fork+0x240>
ffffffffc0206014:	863a                	mv	a2,a4
ffffffffc0206016:	4885                	li	a7,1
ffffffffc0206018:	679c                	ld	a5,8(a5)
ffffffffc020601a:	00878d63          	beq	a5,s0,ffffffffc0206034 <do_fork+0x25c>
ffffffffc020601e:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0206022:	fed715e3          	bne	a4,a3,ffffffffc020600c <do_fork+0x234>
ffffffffc0206026:	2685                	addiw	a3,a3,1
ffffffffc0206028:	0ec6dd63          	bge	a3,a2,ffffffffc0206122 <do_fork+0x34a>
ffffffffc020602c:	679c                	ld	a5,8(a5)
ffffffffc020602e:	4585                	li	a1,1
ffffffffc0206030:	fe8797e3          	bne	a5,s0,ffffffffc020601e <do_fork+0x246>
ffffffffc0206034:	c581                	beqz	a1,ffffffffc020603c <do_fork+0x264>
ffffffffc0206036:	00d82023          	sw	a3,0(a6)
ffffffffc020603a:	8536                	mv	a0,a3
ffffffffc020603c:	f0088fe3          	beqz	a7,ffffffffc0205f5a <do_fork+0x182>
ffffffffc0206040:	00c32023          	sw	a2,0(t1)
ffffffffc0206044:	bf19                	j	ffffffffc0205f5a <do_fork+0x182>
ffffffffc0206046:	8a36                	mv	s4,a3
ffffffffc0206048:	b55d                	j	ffffffffc0205eee <do_fork+0x116>
ffffffffc020604a:	bd6ff0ef          	jal	ra,ffffffffc0205420 <files_create>
ffffffffc020604e:	892a                	mv	s2,a0
ffffffffc0206050:	c911                	beqz	a0,ffffffffc0206064 <do_fork+0x28c>
ffffffffc0206052:	85a2                	mv	a1,s0
ffffffffc0206054:	d04ff0ef          	jal	ra,ffffffffc0205558 <dup_files>
ffffffffc0206058:	844a                	mv	s0,s2
ffffffffc020605a:	ea050ce3          	beqz	a0,ffffffffc0205f12 <do_fork+0x13a>
ffffffffc020605e:	854a                	mv	a0,s2
ffffffffc0206060:	bf6ff0ef          	jal	ra,ffffffffc0205456 <files_destroy>
ffffffffc0206064:	6894                	ld	a3,16(s1)
ffffffffc0206066:	c02007b7          	lui	a5,0xc0200
ffffffffc020606a:	0ef6ee63          	bltu	a3,a5,ffffffffc0206166 <do_fork+0x38e>
ffffffffc020606e:	000c3783          	ld	a5,0(s8)
ffffffffc0206072:	000bb703          	ld	a4,0(s7)
ffffffffc0206076:	40f687b3          	sub	a5,a3,a5
ffffffffc020607a:	83b1                	srli	a5,a5,0xc
ffffffffc020607c:	10e7f163          	bgeu	a5,a4,ffffffffc020617e <do_fork+0x3a6>
ffffffffc0206080:	000b3503          	ld	a0,0(s6)
ffffffffc0206084:	415787b3          	sub	a5,a5,s5
ffffffffc0206088:	079a                	slli	a5,a5,0x6
ffffffffc020608a:	4589                	li	a1,2
ffffffffc020608c:	953e                	add	a0,a0,a5
ffffffffc020608e:	9a0fc0ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc0206092:	8526                	mv	a0,s1
ffffffffc0206094:	82efc0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0206098:	5571                	li	a0,-4
ffffffffc020609a:	b705                	j	ffffffffc0205fba <do_fork+0x1e2>
ffffffffc020609c:	b5dfd0ef          	jal	ra,ffffffffc0203bf8 <mm_create>
ffffffffc02060a0:	e02a                	sd	a0,0(sp)
ffffffffc02060a2:	d169                	beqz	a0,ffffffffc0206064 <do_fork+0x28c>
ffffffffc02060a4:	4505                	li	a0,1
ffffffffc02060a6:	94afc0ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc02060aa:	c149                	beqz	a0,ffffffffc020612c <do_fork+0x354>
ffffffffc02060ac:	000b3683          	ld	a3,0(s6)
ffffffffc02060b0:	000bb703          	ld	a4,0(s7)
ffffffffc02060b4:	40d506b3          	sub	a3,a0,a3
ffffffffc02060b8:	8699                	srai	a3,a3,0x6
ffffffffc02060ba:	96d6                	add	a3,a3,s5
ffffffffc02060bc:	0196fcb3          	and	s9,a3,s9
ffffffffc02060c0:	06b2                	slli	a3,a3,0xc
ffffffffc02060c2:	0cecf063          	bgeu	s9,a4,ffffffffc0206182 <do_fork+0x3aa>
ffffffffc02060c6:	000c3c83          	ld	s9,0(s8)
ffffffffc02060ca:	6605                	lui	a2,0x1
ffffffffc02060cc:	00090597          	auipc	a1,0x90
ffffffffc02060d0:	7cc5b583          	ld	a1,1996(a1) # ffffffffc0296898 <boot_pgdir_va>
ffffffffc02060d4:	9cb6                	add	s9,s9,a3
ffffffffc02060d6:	8566                	mv	a0,s9
ffffffffc02060d8:	760050ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc02060dc:	6782                	ld	a5,0(sp)
ffffffffc02060de:	038d0713          	addi	a4,s10,56
ffffffffc02060e2:	853a                	mv	a0,a4
ffffffffc02060e4:	0197bc23          	sd	s9,24(a5) # ffffffffc0200018 <kern_entry+0x18>
ffffffffc02060e8:	e43a                	sd	a4,8(sp)
ffffffffc02060ea:	eccfe0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc02060ee:	000db683          	ld	a3,0(s11)
ffffffffc02060f2:	6722                	ld	a4,8(sp)
ffffffffc02060f4:	c681                	beqz	a3,ffffffffc02060fc <do_fork+0x324>
ffffffffc02060f6:	42d4                	lw	a3,4(a3)
ffffffffc02060f8:	04dd2823          	sw	a3,80(s10)
ffffffffc02060fc:	6502                	ld	a0,0(sp)
ffffffffc02060fe:	85ea                	mv	a1,s10
ffffffffc0206100:	e43a                	sd	a4,8(sp)
ffffffffc0206102:	fd1fd0ef          	jal	ra,ffffffffc02040d2 <dup_mmap>
ffffffffc0206106:	6722                	ld	a4,8(sp)
ffffffffc0206108:	8caa                	mv	s9,a0
ffffffffc020610a:	853a                	mv	a0,a4
ffffffffc020610c:	ea6fe0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0206110:	040d2823          	sw	zero,80(s10)
ffffffffc0206114:	020c9e63          	bnez	s9,ffffffffc0206150 <do_fork+0x378>
ffffffffc0206118:	6d02                	ld	s10,0(sp)
ffffffffc020611a:	bba5                	j	ffffffffc0205e92 <do_fork+0xba>
ffffffffc020611c:	b51fa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0206120:	bd49                	j	ffffffffc0205fb2 <do_fork+0x1da>
ffffffffc0206122:	01d6c363          	blt	a3,t4,ffffffffc0206128 <do_fork+0x350>
ffffffffc0206126:	4685                	li	a3,1
ffffffffc0206128:	4585                	li	a1,1
ffffffffc020612a:	bdd9                	j	ffffffffc0206000 <do_fork+0x228>
ffffffffc020612c:	6502                	ld	a0,0(sp)
ffffffffc020612e:	ea3fd0ef          	jal	ra,ffffffffc0203fd0 <mm_destroy>
ffffffffc0206132:	bf0d                	j	ffffffffc0206064 <do_fork+0x28c>
ffffffffc0206134:	b3ffa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0206138:	4905                	li	s2,1
ffffffffc020613a:	b3fd                	j	ffffffffc0205f28 <do_fork+0x150>
ffffffffc020613c:	c599                	beqz	a1,ffffffffc020614a <do_fork+0x372>
ffffffffc020613e:	00d82023          	sw	a3,0(a6)
ffffffffc0206142:	8536                	mv	a0,a3
ffffffffc0206144:	bd19                	j	ffffffffc0205f5a <do_fork+0x182>
ffffffffc0206146:	556d                	li	a0,-5
ffffffffc0206148:	bd8d                	j	ffffffffc0205fba <do_fork+0x1e2>
ffffffffc020614a:	00082503          	lw	a0,0(a6)
ffffffffc020614e:	b531                	j	ffffffffc0205f5a <do_fork+0x182>
ffffffffc0206150:	6402                	ld	s0,0(sp)
ffffffffc0206152:	8522                	mv	a0,s0
ffffffffc0206154:	818fe0ef          	jal	ra,ffffffffc020416c <exit_mmap>
ffffffffc0206158:	6c08                	ld	a0,24(s0)
ffffffffc020615a:	badff0ef          	jal	ra,ffffffffc0205d06 <put_pgdir.isra.0>
ffffffffc020615e:	8522                	mv	a0,s0
ffffffffc0206160:	e71fd0ef          	jal	ra,ffffffffc0203fd0 <mm_destroy>
ffffffffc0206164:	b701                	j	ffffffffc0206064 <do_fork+0x28c>
ffffffffc0206166:	00006617          	auipc	a2,0x6
ffffffffc020616a:	74a60613          	addi	a2,a2,1866 # ffffffffc020c8b0 <default_pmm_manager+0xe0>
ffffffffc020616e:	07700593          	li	a1,119
ffffffffc0206172:	00006517          	auipc	a0,0x6
ffffffffc0206176:	6be50513          	addi	a0,a0,1726 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc020617a:	b24fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020617e:	b51ff0ef          	jal	ra,ffffffffc0205cce <pa2page.part.0>
ffffffffc0206182:	00006617          	auipc	a2,0x6
ffffffffc0206186:	68660613          	addi	a2,a2,1670 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc020618a:	07100593          	li	a1,113
ffffffffc020618e:	00006517          	auipc	a0,0x6
ffffffffc0206192:	6a250513          	addi	a0,a0,1698 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0206196:	b08fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020619a:	86ba                	mv	a3,a4
ffffffffc020619c:	00006617          	auipc	a2,0x6
ffffffffc02061a0:	71460613          	addi	a2,a2,1812 # ffffffffc020c8b0 <default_pmm_manager+0xe0>
ffffffffc02061a4:	1ad00593          	li	a1,429
ffffffffc02061a8:	00008517          	auipc	a0,0x8
ffffffffc02061ac:	83850513          	addi	a0,a0,-1992 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc02061b0:	aeefa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02061b4:	00008697          	auipc	a3,0x8
ffffffffc02061b8:	84468693          	addi	a3,a3,-1980 # ffffffffc020d9f8 <CSWTCH.79+0x128>
ffffffffc02061bc:	00006617          	auipc	a2,0x6
ffffffffc02061c0:	b0c60613          	addi	a2,a2,-1268 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02061c4:	1cd00593          	li	a1,461
ffffffffc02061c8:	00008517          	auipc	a0,0x8
ffffffffc02061cc:	81850513          	addi	a0,a0,-2024 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc02061d0:	acefa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02061d4:	00007697          	auipc	a3,0x7
ffffffffc02061d8:	7ec68693          	addi	a3,a3,2028 # ffffffffc020d9c0 <CSWTCH.79+0xf0>
ffffffffc02061dc:	00006617          	auipc	a2,0x6
ffffffffc02061e0:	aec60613          	addi	a2,a2,-1300 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02061e4:	22d00593          	li	a1,557
ffffffffc02061e8:	00007517          	auipc	a0,0x7
ffffffffc02061ec:	7f850513          	addi	a0,a0,2040 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc02061f0:	aaefa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02061f4 <kernel_thread>:
ffffffffc02061f4:	7129                	addi	sp,sp,-320
ffffffffc02061f6:	fa22                	sd	s0,304(sp)
ffffffffc02061f8:	f626                	sd	s1,296(sp)
ffffffffc02061fa:	f24a                	sd	s2,288(sp)
ffffffffc02061fc:	84ae                	mv	s1,a1
ffffffffc02061fe:	892a                	mv	s2,a0
ffffffffc0206200:	8432                	mv	s0,a2
ffffffffc0206202:	4581                	li	a1,0
ffffffffc0206204:	12000613          	li	a2,288
ffffffffc0206208:	850a                	mv	a0,sp
ffffffffc020620a:	fe06                	sd	ra,312(sp)
ffffffffc020620c:	5da050ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0206210:	e0ca                	sd	s2,64(sp)
ffffffffc0206212:	e4a6                	sd	s1,72(sp)
ffffffffc0206214:	100027f3          	csrr	a5,sstatus
ffffffffc0206218:	edd7f793          	andi	a5,a5,-291
ffffffffc020621c:	1207e793          	ori	a5,a5,288
ffffffffc0206220:	e23e                	sd	a5,256(sp)
ffffffffc0206222:	860a                	mv	a2,sp
ffffffffc0206224:	10046513          	ori	a0,s0,256
ffffffffc0206228:	00000797          	auipc	a5,0x0
ffffffffc020622c:	9f678793          	addi	a5,a5,-1546 # ffffffffc0205c1e <kernel_thread_entry>
ffffffffc0206230:	4581                	li	a1,0
ffffffffc0206232:	e63e                	sd	a5,264(sp)
ffffffffc0206234:	ba5ff0ef          	jal	ra,ffffffffc0205dd8 <do_fork>
ffffffffc0206238:	70f2                	ld	ra,312(sp)
ffffffffc020623a:	7452                	ld	s0,304(sp)
ffffffffc020623c:	74b2                	ld	s1,296(sp)
ffffffffc020623e:	7912                	ld	s2,288(sp)
ffffffffc0206240:	6131                	addi	sp,sp,320
ffffffffc0206242:	8082                	ret

ffffffffc0206244 <do_exit>:
ffffffffc0206244:	7179                	addi	sp,sp,-48
ffffffffc0206246:	f022                	sd	s0,32(sp)
ffffffffc0206248:	00090417          	auipc	s0,0x90
ffffffffc020624c:	68840413          	addi	s0,s0,1672 # ffffffffc02968d0 <current>
ffffffffc0206250:	601c                	ld	a5,0(s0)
ffffffffc0206252:	f406                	sd	ra,40(sp)
ffffffffc0206254:	ec26                	sd	s1,24(sp)
ffffffffc0206256:	e84a                	sd	s2,16(sp)
ffffffffc0206258:	e44e                	sd	s3,8(sp)
ffffffffc020625a:	e052                	sd	s4,0(sp)
ffffffffc020625c:	00090717          	auipc	a4,0x90
ffffffffc0206260:	67c73703          	ld	a4,1660(a4) # ffffffffc02968d8 <idleproc>
ffffffffc0206264:	0ee78763          	beq	a5,a4,ffffffffc0206352 <do_exit+0x10e>
ffffffffc0206268:	00090497          	auipc	s1,0x90
ffffffffc020626c:	67848493          	addi	s1,s1,1656 # ffffffffc02968e0 <initproc>
ffffffffc0206270:	6098                	ld	a4,0(s1)
ffffffffc0206272:	10e78763          	beq	a5,a4,ffffffffc0206380 <do_exit+0x13c>
ffffffffc0206276:	0287b983          	ld	s3,40(a5)
ffffffffc020627a:	892a                	mv	s2,a0
ffffffffc020627c:	02098e63          	beqz	s3,ffffffffc02062b8 <do_exit+0x74>
ffffffffc0206280:	00090797          	auipc	a5,0x90
ffffffffc0206284:	6107b783          	ld	a5,1552(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0206288:	577d                	li	a4,-1
ffffffffc020628a:	177e                	slli	a4,a4,0x3f
ffffffffc020628c:	83b1                	srli	a5,a5,0xc
ffffffffc020628e:	8fd9                	or	a5,a5,a4
ffffffffc0206290:	18079073          	csrw	satp,a5
ffffffffc0206294:	0309a783          	lw	a5,48(s3)
ffffffffc0206298:	fff7871b          	addiw	a4,a5,-1
ffffffffc020629c:	02e9a823          	sw	a4,48(s3)
ffffffffc02062a0:	c769                	beqz	a4,ffffffffc020636a <do_exit+0x126>
ffffffffc02062a2:	601c                	ld	a5,0(s0)
ffffffffc02062a4:	1487b503          	ld	a0,328(a5)
ffffffffc02062a8:	0207b423          	sd	zero,40(a5)
ffffffffc02062ac:	c511                	beqz	a0,ffffffffc02062b8 <do_exit+0x74>
ffffffffc02062ae:	491c                	lw	a5,16(a0)
ffffffffc02062b0:	fff7871b          	addiw	a4,a5,-1
ffffffffc02062b4:	c918                	sw	a4,16(a0)
ffffffffc02062b6:	cb59                	beqz	a4,ffffffffc020634c <do_exit+0x108>
ffffffffc02062b8:	601c                	ld	a5,0(s0)
ffffffffc02062ba:	470d                	li	a4,3
ffffffffc02062bc:	c398                	sw	a4,0(a5)
ffffffffc02062be:	0f27a423          	sw	s2,232(a5)
ffffffffc02062c2:	100027f3          	csrr	a5,sstatus
ffffffffc02062c6:	8b89                	andi	a5,a5,2
ffffffffc02062c8:	4a01                	li	s4,0
ffffffffc02062ca:	e7f9                	bnez	a5,ffffffffc0206398 <do_exit+0x154>
ffffffffc02062cc:	6018                	ld	a4,0(s0)
ffffffffc02062ce:	800007b7          	lui	a5,0x80000
ffffffffc02062d2:	0785                	addi	a5,a5,1
ffffffffc02062d4:	7308                	ld	a0,32(a4)
ffffffffc02062d6:	0ec52703          	lw	a4,236(a0)
ffffffffc02062da:	0cf70363          	beq	a4,a5,ffffffffc02063a0 <do_exit+0x15c>
ffffffffc02062de:	6018                	ld	a4,0(s0)
ffffffffc02062e0:	7b7c                	ld	a5,240(a4)
ffffffffc02062e2:	c3a1                	beqz	a5,ffffffffc0206322 <do_exit+0xde>
ffffffffc02062e4:	800009b7          	lui	s3,0x80000
ffffffffc02062e8:	490d                	li	s2,3
ffffffffc02062ea:	0985                	addi	s3,s3,1
ffffffffc02062ec:	a021                	j	ffffffffc02062f4 <do_exit+0xb0>
ffffffffc02062ee:	6018                	ld	a4,0(s0)
ffffffffc02062f0:	7b7c                	ld	a5,240(a4)
ffffffffc02062f2:	cb85                	beqz	a5,ffffffffc0206322 <do_exit+0xde>
ffffffffc02062f4:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_bin_sfs_img_size+0xffffffff7ff8ae00>
ffffffffc02062f8:	6088                	ld	a0,0(s1)
ffffffffc02062fa:	fb74                	sd	a3,240(a4)
ffffffffc02062fc:	7978                	ld	a4,240(a0)
ffffffffc02062fe:	0e07bc23          	sd	zero,248(a5)
ffffffffc0206302:	10e7b023          	sd	a4,256(a5)
ffffffffc0206306:	c311                	beqz	a4,ffffffffc020630a <do_exit+0xc6>
ffffffffc0206308:	ff7c                	sd	a5,248(a4)
ffffffffc020630a:	4398                	lw	a4,0(a5)
ffffffffc020630c:	f388                	sd	a0,32(a5)
ffffffffc020630e:	f97c                	sd	a5,240(a0)
ffffffffc0206310:	fd271fe3          	bne	a4,s2,ffffffffc02062ee <do_exit+0xaa>
ffffffffc0206314:	0ec52783          	lw	a5,236(a0)
ffffffffc0206318:	fd379be3          	bne	a5,s3,ffffffffc02062ee <do_exit+0xaa>
ffffffffc020631c:	2b0010ef          	jal	ra,ffffffffc02075cc <wakeup_proc>
ffffffffc0206320:	b7f9                	j	ffffffffc02062ee <do_exit+0xaa>
ffffffffc0206322:	020a1263          	bnez	s4,ffffffffc0206346 <do_exit+0x102>
ffffffffc0206326:	358010ef          	jal	ra,ffffffffc020767e <schedule>
ffffffffc020632a:	601c                	ld	a5,0(s0)
ffffffffc020632c:	00007617          	auipc	a2,0x7
ffffffffc0206330:	70460613          	addi	a2,a2,1796 # ffffffffc020da30 <CSWTCH.79+0x160>
ffffffffc0206334:	29400593          	li	a1,660
ffffffffc0206338:	43d4                	lw	a3,4(a5)
ffffffffc020633a:	00007517          	auipc	a0,0x7
ffffffffc020633e:	6a650513          	addi	a0,a0,1702 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0206342:	95cfa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206346:	927fa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020634a:	bff1                	j	ffffffffc0206326 <do_exit+0xe2>
ffffffffc020634c:	90aff0ef          	jal	ra,ffffffffc0205456 <files_destroy>
ffffffffc0206350:	b7a5                	j	ffffffffc02062b8 <do_exit+0x74>
ffffffffc0206352:	00007617          	auipc	a2,0x7
ffffffffc0206356:	6be60613          	addi	a2,a2,1726 # ffffffffc020da10 <CSWTCH.79+0x140>
ffffffffc020635a:	25f00593          	li	a1,607
ffffffffc020635e:	00007517          	auipc	a0,0x7
ffffffffc0206362:	68250513          	addi	a0,a0,1666 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0206366:	938fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020636a:	854e                	mv	a0,s3
ffffffffc020636c:	e01fd0ef          	jal	ra,ffffffffc020416c <exit_mmap>
ffffffffc0206370:	0189b503          	ld	a0,24(s3) # ffffffff80000018 <_binary_bin_sfs_img_size+0xffffffff7ff8ad18>
ffffffffc0206374:	993ff0ef          	jal	ra,ffffffffc0205d06 <put_pgdir.isra.0>
ffffffffc0206378:	854e                	mv	a0,s3
ffffffffc020637a:	c57fd0ef          	jal	ra,ffffffffc0203fd0 <mm_destroy>
ffffffffc020637e:	b715                	j	ffffffffc02062a2 <do_exit+0x5e>
ffffffffc0206380:	00007617          	auipc	a2,0x7
ffffffffc0206384:	6a060613          	addi	a2,a2,1696 # ffffffffc020da20 <CSWTCH.79+0x150>
ffffffffc0206388:	26300593          	li	a1,611
ffffffffc020638c:	00007517          	auipc	a0,0x7
ffffffffc0206390:	65450513          	addi	a0,a0,1620 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0206394:	90afa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206398:	8dbfa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020639c:	4a05                	li	s4,1
ffffffffc020639e:	b73d                	j	ffffffffc02062cc <do_exit+0x88>
ffffffffc02063a0:	22c010ef          	jal	ra,ffffffffc02075cc <wakeup_proc>
ffffffffc02063a4:	bf2d                	j	ffffffffc02062de <do_exit+0x9a>

ffffffffc02063a6 <do_wait.part.0>:
ffffffffc02063a6:	715d                	addi	sp,sp,-80
ffffffffc02063a8:	f84a                	sd	s2,48(sp)
ffffffffc02063aa:	f44e                	sd	s3,40(sp)
ffffffffc02063ac:	80000937          	lui	s2,0x80000
ffffffffc02063b0:	6989                	lui	s3,0x2
ffffffffc02063b2:	fc26                	sd	s1,56(sp)
ffffffffc02063b4:	f052                	sd	s4,32(sp)
ffffffffc02063b6:	ec56                	sd	s5,24(sp)
ffffffffc02063b8:	e85a                	sd	s6,16(sp)
ffffffffc02063ba:	e45e                	sd	s7,8(sp)
ffffffffc02063bc:	e486                	sd	ra,72(sp)
ffffffffc02063be:	e0a2                	sd	s0,64(sp)
ffffffffc02063c0:	84aa                	mv	s1,a0
ffffffffc02063c2:	8a2e                	mv	s4,a1
ffffffffc02063c4:	00090b97          	auipc	s7,0x90
ffffffffc02063c8:	50cb8b93          	addi	s7,s7,1292 # ffffffffc02968d0 <current>
ffffffffc02063cc:	00050b1b          	sext.w	s6,a0
ffffffffc02063d0:	fff50a9b          	addiw	s5,a0,-1
ffffffffc02063d4:	19f9                	addi	s3,s3,-2
ffffffffc02063d6:	0905                	addi	s2,s2,1
ffffffffc02063d8:	ccbd                	beqz	s1,ffffffffc0206456 <do_wait.part.0+0xb0>
ffffffffc02063da:	0359e863          	bltu	s3,s5,ffffffffc020640a <do_wait.part.0+0x64>
ffffffffc02063de:	45a9                	li	a1,10
ffffffffc02063e0:	855a                	mv	a0,s6
ffffffffc02063e2:	6d1040ef          	jal	ra,ffffffffc020b2b2 <hash32>
ffffffffc02063e6:	02051793          	slli	a5,a0,0x20
ffffffffc02063ea:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02063ee:	0008b797          	auipc	a5,0x8b
ffffffffc02063f2:	3d278793          	addi	a5,a5,978 # ffffffffc02917c0 <hash_list>
ffffffffc02063f6:	953e                	add	a0,a0,a5
ffffffffc02063f8:	842a                	mv	s0,a0
ffffffffc02063fa:	a029                	j	ffffffffc0206404 <do_wait.part.0+0x5e>
ffffffffc02063fc:	f2c42783          	lw	a5,-212(s0)
ffffffffc0206400:	02978163          	beq	a5,s1,ffffffffc0206422 <do_wait.part.0+0x7c>
ffffffffc0206404:	6400                	ld	s0,8(s0)
ffffffffc0206406:	fe851be3          	bne	a0,s0,ffffffffc02063fc <do_wait.part.0+0x56>
ffffffffc020640a:	5579                	li	a0,-2
ffffffffc020640c:	60a6                	ld	ra,72(sp)
ffffffffc020640e:	6406                	ld	s0,64(sp)
ffffffffc0206410:	74e2                	ld	s1,56(sp)
ffffffffc0206412:	7942                	ld	s2,48(sp)
ffffffffc0206414:	79a2                	ld	s3,40(sp)
ffffffffc0206416:	7a02                	ld	s4,32(sp)
ffffffffc0206418:	6ae2                	ld	s5,24(sp)
ffffffffc020641a:	6b42                	ld	s6,16(sp)
ffffffffc020641c:	6ba2                	ld	s7,8(sp)
ffffffffc020641e:	6161                	addi	sp,sp,80
ffffffffc0206420:	8082                	ret
ffffffffc0206422:	000bb683          	ld	a3,0(s7)
ffffffffc0206426:	f4843783          	ld	a5,-184(s0)
ffffffffc020642a:	fed790e3          	bne	a5,a3,ffffffffc020640a <do_wait.part.0+0x64>
ffffffffc020642e:	f2842703          	lw	a4,-216(s0)
ffffffffc0206432:	478d                	li	a5,3
ffffffffc0206434:	0ef70b63          	beq	a4,a5,ffffffffc020652a <do_wait.part.0+0x184>
ffffffffc0206438:	4785                	li	a5,1
ffffffffc020643a:	c29c                	sw	a5,0(a3)
ffffffffc020643c:	0f26a623          	sw	s2,236(a3)
ffffffffc0206440:	23e010ef          	jal	ra,ffffffffc020767e <schedule>
ffffffffc0206444:	000bb783          	ld	a5,0(s7)
ffffffffc0206448:	0b07a783          	lw	a5,176(a5)
ffffffffc020644c:	8b85                	andi	a5,a5,1
ffffffffc020644e:	d7c9                	beqz	a5,ffffffffc02063d8 <do_wait.part.0+0x32>
ffffffffc0206450:	555d                	li	a0,-9
ffffffffc0206452:	df3ff0ef          	jal	ra,ffffffffc0206244 <do_exit>
ffffffffc0206456:	000bb683          	ld	a3,0(s7)
ffffffffc020645a:	7ae0                	ld	s0,240(a3)
ffffffffc020645c:	d45d                	beqz	s0,ffffffffc020640a <do_wait.part.0+0x64>
ffffffffc020645e:	470d                	li	a4,3
ffffffffc0206460:	a021                	j	ffffffffc0206468 <do_wait.part.0+0xc2>
ffffffffc0206462:	10043403          	ld	s0,256(s0)
ffffffffc0206466:	d869                	beqz	s0,ffffffffc0206438 <do_wait.part.0+0x92>
ffffffffc0206468:	401c                	lw	a5,0(s0)
ffffffffc020646a:	fee79ce3          	bne	a5,a4,ffffffffc0206462 <do_wait.part.0+0xbc>
ffffffffc020646e:	00090797          	auipc	a5,0x90
ffffffffc0206472:	46a7b783          	ld	a5,1130(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0206476:	0c878963          	beq	a5,s0,ffffffffc0206548 <do_wait.part.0+0x1a2>
ffffffffc020647a:	00090797          	auipc	a5,0x90
ffffffffc020647e:	4667b783          	ld	a5,1126(a5) # ffffffffc02968e0 <initproc>
ffffffffc0206482:	0cf40363          	beq	s0,a5,ffffffffc0206548 <do_wait.part.0+0x1a2>
ffffffffc0206486:	000a0663          	beqz	s4,ffffffffc0206492 <do_wait.part.0+0xec>
ffffffffc020648a:	0e842783          	lw	a5,232(s0)
ffffffffc020648e:	00fa2023          	sw	a5,0(s4)
ffffffffc0206492:	100027f3          	csrr	a5,sstatus
ffffffffc0206496:	8b89                	andi	a5,a5,2
ffffffffc0206498:	4581                	li	a1,0
ffffffffc020649a:	e7c1                	bnez	a5,ffffffffc0206522 <do_wait.part.0+0x17c>
ffffffffc020649c:	6c70                	ld	a2,216(s0)
ffffffffc020649e:	7074                	ld	a3,224(s0)
ffffffffc02064a0:	10043703          	ld	a4,256(s0)
ffffffffc02064a4:	7c7c                	ld	a5,248(s0)
ffffffffc02064a6:	e614                	sd	a3,8(a2)
ffffffffc02064a8:	e290                	sd	a2,0(a3)
ffffffffc02064aa:	6470                	ld	a2,200(s0)
ffffffffc02064ac:	6874                	ld	a3,208(s0)
ffffffffc02064ae:	e614                	sd	a3,8(a2)
ffffffffc02064b0:	e290                	sd	a2,0(a3)
ffffffffc02064b2:	c319                	beqz	a4,ffffffffc02064b8 <do_wait.part.0+0x112>
ffffffffc02064b4:	ff7c                	sd	a5,248(a4)
ffffffffc02064b6:	7c7c                	ld	a5,248(s0)
ffffffffc02064b8:	c3b5                	beqz	a5,ffffffffc020651c <do_wait.part.0+0x176>
ffffffffc02064ba:	10e7b023          	sd	a4,256(a5)
ffffffffc02064be:	00090717          	auipc	a4,0x90
ffffffffc02064c2:	42a70713          	addi	a4,a4,1066 # ffffffffc02968e8 <nr_process>
ffffffffc02064c6:	431c                	lw	a5,0(a4)
ffffffffc02064c8:	37fd                	addiw	a5,a5,-1
ffffffffc02064ca:	c31c                	sw	a5,0(a4)
ffffffffc02064cc:	e5a9                	bnez	a1,ffffffffc0206516 <do_wait.part.0+0x170>
ffffffffc02064ce:	6814                	ld	a3,16(s0)
ffffffffc02064d0:	c02007b7          	lui	a5,0xc0200
ffffffffc02064d4:	04f6ee63          	bltu	a3,a5,ffffffffc0206530 <do_wait.part.0+0x18a>
ffffffffc02064d8:	00090797          	auipc	a5,0x90
ffffffffc02064dc:	3e07b783          	ld	a5,992(a5) # ffffffffc02968b8 <va_pa_offset>
ffffffffc02064e0:	8e9d                	sub	a3,a3,a5
ffffffffc02064e2:	82b1                	srli	a3,a3,0xc
ffffffffc02064e4:	00090797          	auipc	a5,0x90
ffffffffc02064e8:	3bc7b783          	ld	a5,956(a5) # ffffffffc02968a0 <npage>
ffffffffc02064ec:	06f6fa63          	bgeu	a3,a5,ffffffffc0206560 <do_wait.part.0+0x1ba>
ffffffffc02064f0:	0000a517          	auipc	a0,0xa
ffffffffc02064f4:	84053503          	ld	a0,-1984(a0) # ffffffffc020fd30 <nbase>
ffffffffc02064f8:	8e89                	sub	a3,a3,a0
ffffffffc02064fa:	069a                	slli	a3,a3,0x6
ffffffffc02064fc:	00090517          	auipc	a0,0x90
ffffffffc0206500:	3ac53503          	ld	a0,940(a0) # ffffffffc02968a8 <pages>
ffffffffc0206504:	9536                	add	a0,a0,a3
ffffffffc0206506:	4589                	li	a1,2
ffffffffc0206508:	d27fb0ef          	jal	ra,ffffffffc020222e <free_pages>
ffffffffc020650c:	8522                	mv	a0,s0
ffffffffc020650e:	bb5fb0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0206512:	4501                	li	a0,0
ffffffffc0206514:	bde5                	j	ffffffffc020640c <do_wait.part.0+0x66>
ffffffffc0206516:	f56fa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020651a:	bf55                	j	ffffffffc02064ce <do_wait.part.0+0x128>
ffffffffc020651c:	701c                	ld	a5,32(s0)
ffffffffc020651e:	fbf8                	sd	a4,240(a5)
ffffffffc0206520:	bf79                	j	ffffffffc02064be <do_wait.part.0+0x118>
ffffffffc0206522:	f50fa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0206526:	4585                	li	a1,1
ffffffffc0206528:	bf95                	j	ffffffffc020649c <do_wait.part.0+0xf6>
ffffffffc020652a:	f2840413          	addi	s0,s0,-216
ffffffffc020652e:	b781                	j	ffffffffc020646e <do_wait.part.0+0xc8>
ffffffffc0206530:	00006617          	auipc	a2,0x6
ffffffffc0206534:	38060613          	addi	a2,a2,896 # ffffffffc020c8b0 <default_pmm_manager+0xe0>
ffffffffc0206538:	07700593          	li	a1,119
ffffffffc020653c:	00006517          	auipc	a0,0x6
ffffffffc0206540:	2f450513          	addi	a0,a0,756 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0206544:	f5bf90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206548:	00007617          	auipc	a2,0x7
ffffffffc020654c:	50860613          	addi	a2,a2,1288 # ffffffffc020da50 <CSWTCH.79+0x180>
ffffffffc0206550:	42e00593          	li	a1,1070
ffffffffc0206554:	00007517          	auipc	a0,0x7
ffffffffc0206558:	48c50513          	addi	a0,a0,1164 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc020655c:	f43f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206560:	f6eff0ef          	jal	ra,ffffffffc0205cce <pa2page.part.0>

ffffffffc0206564 <init_main>:
ffffffffc0206564:	1141                	addi	sp,sp,-16
ffffffffc0206566:	00007517          	auipc	a0,0x7
ffffffffc020656a:	50a50513          	addi	a0,a0,1290 # ffffffffc020da70 <CSWTCH.79+0x1a0>
ffffffffc020656e:	e406                	sd	ra,8(sp)
ffffffffc0206570:	07f010ef          	jal	ra,ffffffffc0207dee <vfs_set_bootfs>
ffffffffc0206574:	e179                	bnez	a0,ffffffffc020663a <init_main+0xd6>
ffffffffc0206576:	cf9fb0ef          	jal	ra,ffffffffc020226e <nr_free_pages>
ffffffffc020657a:	a95fb0ef          	jal	ra,ffffffffc020200e <kallocated>
ffffffffc020657e:	4601                	li	a2,0
ffffffffc0206580:	4581                	li	a1,0
ffffffffc0206582:	00001517          	auipc	a0,0x1
ffffffffc0206586:	aca50513          	addi	a0,a0,-1334 # ffffffffc020704c <user_main>
ffffffffc020658a:	c6bff0ef          	jal	ra,ffffffffc02061f4 <kernel_thread>
ffffffffc020658e:	00a04563          	bgtz	a0,ffffffffc0206598 <init_main+0x34>
ffffffffc0206592:	a841                	j	ffffffffc0206622 <init_main+0xbe>
ffffffffc0206594:	0ea010ef          	jal	ra,ffffffffc020767e <schedule>
ffffffffc0206598:	4581                	li	a1,0
ffffffffc020659a:	4501                	li	a0,0
ffffffffc020659c:	e0bff0ef          	jal	ra,ffffffffc02063a6 <do_wait.part.0>
ffffffffc02065a0:	d975                	beqz	a0,ffffffffc0206594 <init_main+0x30>
ffffffffc02065a2:	e6ffe0ef          	jal	ra,ffffffffc0205410 <fs_cleanup>
ffffffffc02065a6:	00007517          	auipc	a0,0x7
ffffffffc02065aa:	51250513          	addi	a0,a0,1298 # ffffffffc020dab8 <CSWTCH.79+0x1e8>
ffffffffc02065ae:	bf9f90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02065b2:	00090797          	auipc	a5,0x90
ffffffffc02065b6:	32e7b783          	ld	a5,814(a5) # ffffffffc02968e0 <initproc>
ffffffffc02065ba:	7bf8                	ld	a4,240(a5)
ffffffffc02065bc:	e339                	bnez	a4,ffffffffc0206602 <init_main+0x9e>
ffffffffc02065be:	7ff8                	ld	a4,248(a5)
ffffffffc02065c0:	e329                	bnez	a4,ffffffffc0206602 <init_main+0x9e>
ffffffffc02065c2:	1007b703          	ld	a4,256(a5)
ffffffffc02065c6:	ef15                	bnez	a4,ffffffffc0206602 <init_main+0x9e>
ffffffffc02065c8:	00090697          	auipc	a3,0x90
ffffffffc02065cc:	3206a683          	lw	a3,800(a3) # ffffffffc02968e8 <nr_process>
ffffffffc02065d0:	4709                	li	a4,2
ffffffffc02065d2:	0ce69163          	bne	a3,a4,ffffffffc0206694 <init_main+0x130>
ffffffffc02065d6:	0008f717          	auipc	a4,0x8f
ffffffffc02065da:	1ea70713          	addi	a4,a4,490 # ffffffffc02957c0 <proc_list>
ffffffffc02065de:	6714                	ld	a3,8(a4)
ffffffffc02065e0:	0c878793          	addi	a5,a5,200
ffffffffc02065e4:	08d79863          	bne	a5,a3,ffffffffc0206674 <init_main+0x110>
ffffffffc02065e8:	6318                	ld	a4,0(a4)
ffffffffc02065ea:	06e79563          	bne	a5,a4,ffffffffc0206654 <init_main+0xf0>
ffffffffc02065ee:	00007517          	auipc	a0,0x7
ffffffffc02065f2:	5b250513          	addi	a0,a0,1458 # ffffffffc020dba0 <CSWTCH.79+0x2d0>
ffffffffc02065f6:	bb1f90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02065fa:	60a2                	ld	ra,8(sp)
ffffffffc02065fc:	4501                	li	a0,0
ffffffffc02065fe:	0141                	addi	sp,sp,16
ffffffffc0206600:	8082                	ret
ffffffffc0206602:	00007697          	auipc	a3,0x7
ffffffffc0206606:	4de68693          	addi	a3,a3,1246 # ffffffffc020dae0 <CSWTCH.79+0x210>
ffffffffc020660a:	00005617          	auipc	a2,0x5
ffffffffc020660e:	6be60613          	addi	a2,a2,1726 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0206612:	4a400593          	li	a1,1188
ffffffffc0206616:	00007517          	auipc	a0,0x7
ffffffffc020661a:	3ca50513          	addi	a0,a0,970 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc020661e:	e81f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206622:	00007617          	auipc	a2,0x7
ffffffffc0206626:	47660613          	addi	a2,a2,1142 # ffffffffc020da98 <CSWTCH.79+0x1c8>
ffffffffc020662a:	49700593          	li	a1,1175
ffffffffc020662e:	00007517          	auipc	a0,0x7
ffffffffc0206632:	3b250513          	addi	a0,a0,946 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0206636:	e69f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020663a:	86aa                	mv	a3,a0
ffffffffc020663c:	00007617          	auipc	a2,0x7
ffffffffc0206640:	43c60613          	addi	a2,a2,1084 # ffffffffc020da78 <CSWTCH.79+0x1a8>
ffffffffc0206644:	48f00593          	li	a1,1167
ffffffffc0206648:	00007517          	auipc	a0,0x7
ffffffffc020664c:	39850513          	addi	a0,a0,920 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0206650:	e4ff90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206654:	00007697          	auipc	a3,0x7
ffffffffc0206658:	51c68693          	addi	a3,a3,1308 # ffffffffc020db70 <CSWTCH.79+0x2a0>
ffffffffc020665c:	00005617          	auipc	a2,0x5
ffffffffc0206660:	66c60613          	addi	a2,a2,1644 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0206664:	4a700593          	li	a1,1191
ffffffffc0206668:	00007517          	auipc	a0,0x7
ffffffffc020666c:	37850513          	addi	a0,a0,888 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0206670:	e2ff90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206674:	00007697          	auipc	a3,0x7
ffffffffc0206678:	4cc68693          	addi	a3,a3,1228 # ffffffffc020db40 <CSWTCH.79+0x270>
ffffffffc020667c:	00005617          	auipc	a2,0x5
ffffffffc0206680:	64c60613          	addi	a2,a2,1612 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0206684:	4a600593          	li	a1,1190
ffffffffc0206688:	00007517          	auipc	a0,0x7
ffffffffc020668c:	35850513          	addi	a0,a0,856 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0206690:	e0ff90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206694:	00007697          	auipc	a3,0x7
ffffffffc0206698:	49c68693          	addi	a3,a3,1180 # ffffffffc020db30 <CSWTCH.79+0x260>
ffffffffc020669c:	00005617          	auipc	a2,0x5
ffffffffc02066a0:	62c60613          	addi	a2,a2,1580 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02066a4:	4a500593          	li	a1,1189
ffffffffc02066a8:	00007517          	auipc	a0,0x7
ffffffffc02066ac:	33850513          	addi	a0,a0,824 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc02066b0:	deff90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02066b4 <do_execve>:
ffffffffc02066b4:	c9010113          	addi	sp,sp,-880
ffffffffc02066b8:	35413023          	sd	s4,832(sp)
ffffffffc02066bc:	00090a17          	auipc	s4,0x90
ffffffffc02066c0:	214a0a13          	addi	s4,s4,532 # ffffffffc02968d0 <current>
ffffffffc02066c4:	000a3683          	ld	a3,0(s4)
ffffffffc02066c8:	fff5871b          	addiw	a4,a1,-1
ffffffffc02066cc:	33513c23          	sd	s5,824(sp)
ffffffffc02066d0:	36113423          	sd	ra,872(sp)
ffffffffc02066d4:	36813023          	sd	s0,864(sp)
ffffffffc02066d8:	34913c23          	sd	s1,856(sp)
ffffffffc02066dc:	35213823          	sd	s2,848(sp)
ffffffffc02066e0:	35313423          	sd	s3,840(sp)
ffffffffc02066e4:	33613823          	sd	s6,816(sp)
ffffffffc02066e8:	33713423          	sd	s7,808(sp)
ffffffffc02066ec:	33813023          	sd	s8,800(sp)
ffffffffc02066f0:	31913c23          	sd	s9,792(sp)
ffffffffc02066f4:	31a13823          	sd	s10,784(sp)
ffffffffc02066f8:	31b13423          	sd	s11,776(sp)
ffffffffc02066fc:	dc3a                	sw	a4,56(sp)
ffffffffc02066fe:	47fd                	li	a5,31
ffffffffc0206700:	0286ba83          	ld	s5,40(a3)
ffffffffc0206704:	72e7e263          	bltu	a5,a4,ffffffffc0206e28 <do_execve+0x774>
ffffffffc0206708:	842e                	mv	s0,a1
ffffffffc020670a:	84aa                	mv	s1,a0
ffffffffc020670c:	8bb2                	mv	s7,a2
ffffffffc020670e:	4581                	li	a1,0
ffffffffc0206710:	4641                	li	a2,16
ffffffffc0206712:	18a8                	addi	a0,sp,120
ffffffffc0206714:	0d2050ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0206718:	000a8c63          	beqz	s5,ffffffffc0206730 <do_execve+0x7c>
ffffffffc020671c:	038a8513          	addi	a0,s5,56
ffffffffc0206720:	896fe0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc0206724:	000a3783          	ld	a5,0(s4)
ffffffffc0206728:	c781                	beqz	a5,ffffffffc0206730 <do_execve+0x7c>
ffffffffc020672a:	43dc                	lw	a5,4(a5)
ffffffffc020672c:	04faa823          	sw	a5,80(s5)
ffffffffc0206730:	24048263          	beqz	s1,ffffffffc0206974 <do_execve+0x2c0>
ffffffffc0206734:	46c1                	li	a3,16
ffffffffc0206736:	8626                	mv	a2,s1
ffffffffc0206738:	18ac                	addi	a1,sp,120
ffffffffc020673a:	8556                	mv	a0,s5
ffffffffc020673c:	ea3fd0ef          	jal	ra,ffffffffc02045de <copy_string>
ffffffffc0206740:	6e050c63          	beqz	a0,ffffffffc0206e38 <do_execve+0x784>
ffffffffc0206744:	00341793          	slli	a5,s0,0x3
ffffffffc0206748:	4681                	li	a3,0
ffffffffc020674a:	863e                	mv	a2,a5
ffffffffc020674c:	85de                	mv	a1,s7
ffffffffc020674e:	8556                	mv	a0,s5
ffffffffc0206750:	e0be                	sd	a5,64(sp)
ffffffffc0206752:	d93fd0ef          	jal	ra,ffffffffc02044e4 <user_mem_check>
ffffffffc0206756:	89de                	mv	s3,s7
ffffffffc0206758:	6c050c63          	beqz	a0,ffffffffc0206e30 <do_execve+0x77c>
ffffffffc020675c:	10010b13          	addi	s6,sp,256
ffffffffc0206760:	4481                	li	s1,0
ffffffffc0206762:	a011                	j	ffffffffc0206766 <do_execve+0xb2>
ffffffffc0206764:	84be                	mv	s1,a5
ffffffffc0206766:	6505                	lui	a0,0x1
ffffffffc0206768:	8abfb0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc020676c:	892a                	mv	s2,a0
ffffffffc020676e:	18050063          	beqz	a0,ffffffffc02068ee <do_execve+0x23a>
ffffffffc0206772:	0009b603          	ld	a2,0(s3) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc0206776:	85aa                	mv	a1,a0
ffffffffc0206778:	6685                	lui	a3,0x1
ffffffffc020677a:	8556                	mv	a0,s5
ffffffffc020677c:	e63fd0ef          	jal	ra,ffffffffc02045de <copy_string>
ffffffffc0206780:	1e050563          	beqz	a0,ffffffffc020696a <do_execve+0x2b6>
ffffffffc0206784:	012b3023          	sd	s2,0(s6)
ffffffffc0206788:	0014879b          	addiw	a5,s1,1
ffffffffc020678c:	0b21                	addi	s6,s6,8
ffffffffc020678e:	09a1                	addi	s3,s3,8
ffffffffc0206790:	fcf41ae3          	bne	s0,a5,ffffffffc0206764 <do_execve+0xb0>
ffffffffc0206794:	000bb903          	ld	s2,0(s7)
ffffffffc0206798:	100a8863          	beqz	s5,ffffffffc02068a8 <do_execve+0x1f4>
ffffffffc020679c:	038a8513          	addi	a0,s5,56
ffffffffc02067a0:	812fe0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc02067a4:	000a3783          	ld	a5,0(s4)
ffffffffc02067a8:	040aa823          	sw	zero,80(s5)
ffffffffc02067ac:	1487b503          	ld	a0,328(a5)
ffffffffc02067b0:	d3dfe0ef          	jal	ra,ffffffffc02054ec <files_closeall>
ffffffffc02067b4:	4581                	li	a1,0
ffffffffc02067b6:	854a                	mv	a0,s2
ffffffffc02067b8:	fc1fe0ef          	jal	ra,ffffffffc0205778 <sysfile_open>
ffffffffc02067bc:	8baa                	mv	s7,a0
ffffffffc02067be:	020549e3          	bltz	a0,ffffffffc0206ff0 <do_execve+0x93c>
ffffffffc02067c2:	00090797          	auipc	a5,0x90
ffffffffc02067c6:	0ce7b783          	ld	a5,206(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc02067ca:	577d                	li	a4,-1
ffffffffc02067cc:	177e                	slli	a4,a4,0x3f
ffffffffc02067ce:	83b1                	srli	a5,a5,0xc
ffffffffc02067d0:	8fd9                	or	a5,a5,a4
ffffffffc02067d2:	18079073          	csrw	satp,a5
ffffffffc02067d6:	030aa783          	lw	a5,48(s5)
ffffffffc02067da:	fff7871b          	addiw	a4,a5,-1
ffffffffc02067de:	02eaa823          	sw	a4,48(s5)
ffffffffc02067e2:	48070b63          	beqz	a4,ffffffffc0206c78 <do_execve+0x5c4>
ffffffffc02067e6:	000a3783          	ld	a5,0(s4)
ffffffffc02067ea:	0207b423          	sd	zero,40(a5)
ffffffffc02067ee:	c0afd0ef          	jal	ra,ffffffffc0203bf8 <mm_create>
ffffffffc02067f2:	89aa                	mv	s3,a0
ffffffffc02067f4:	0e050b63          	beqz	a0,ffffffffc02068ea <do_execve+0x236>
ffffffffc02067f8:	4505                	li	a0,1
ffffffffc02067fa:	9f7fb0ef          	jal	ra,ffffffffc02021f0 <alloc_pages>
ffffffffc02067fe:	0e050363          	beqz	a0,ffffffffc02068e4 <do_execve+0x230>
ffffffffc0206802:	00090d97          	auipc	s11,0x90
ffffffffc0206806:	0a6d8d93          	addi	s11,s11,166 # ffffffffc02968a8 <pages>
ffffffffc020680a:	000db683          	ld	a3,0(s11)
ffffffffc020680e:	00009797          	auipc	a5,0x9
ffffffffc0206812:	52278793          	addi	a5,a5,1314 # ffffffffc020fd30 <nbase>
ffffffffc0206816:	6398                	ld	a4,0(a5)
ffffffffc0206818:	40d506b3          	sub	a3,a0,a3
ffffffffc020681c:	00090b17          	auipc	s6,0x90
ffffffffc0206820:	084b0b13          	addi	s6,s6,132 # ffffffffc02968a0 <npage>
ffffffffc0206824:	8699                	srai	a3,a3,0x6
ffffffffc0206826:	96ba                	add	a3,a3,a4
ffffffffc0206828:	f03a                	sd	a4,32(sp)
ffffffffc020682a:	000b3783          	ld	a5,0(s6)
ffffffffc020682e:	577d                	li	a4,-1
ffffffffc0206830:	8331                	srli	a4,a4,0xc
ffffffffc0206832:	ec3a                	sd	a4,24(sp)
ffffffffc0206834:	8f75                	and	a4,a4,a3
ffffffffc0206836:	06b2                	slli	a3,a3,0xc
ffffffffc0206838:	72f77963          	bgeu	a4,a5,ffffffffc0206f6a <do_execve+0x8b6>
ffffffffc020683c:	00090d17          	auipc	s10,0x90
ffffffffc0206840:	07cd0d13          	addi	s10,s10,124 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206844:	000d3903          	ld	s2,0(s10)
ffffffffc0206848:	6605                	lui	a2,0x1
ffffffffc020684a:	00090597          	auipc	a1,0x90
ffffffffc020684e:	04e5b583          	ld	a1,78(a1) # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0206852:	9936                	add	s2,s2,a3
ffffffffc0206854:	854a                	mv	a0,s2
ffffffffc0206856:	7e3040ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc020685a:	4601                	li	a2,0
ffffffffc020685c:	0129bc23          	sd	s2,24(s3)
ffffffffc0206860:	4581                	li	a1,0
ffffffffc0206862:	855e                	mv	a0,s7
ffffffffc0206864:	97aff0ef          	jal	ra,ffffffffc02059de <sysfile_seek>
ffffffffc0206868:	892a                	mv	s2,a0
ffffffffc020686a:	12050163          	beqz	a0,ffffffffc020698c <do_execve+0x2d8>
ffffffffc020686e:	0189b503          	ld	a0,24(s3)
ffffffffc0206872:	c94ff0ef          	jal	ra,ffffffffc0205d06 <put_pgdir.isra.0>
ffffffffc0206876:	854e                	mv	a0,s3
ffffffffc0206878:	f58fd0ef          	jal	ra,ffffffffc0203fd0 <mm_destroy>
ffffffffc020687c:	6786                	ld	a5,64(sp)
ffffffffc020687e:	1984                	addi	s1,sp,240
ffffffffc0206880:	147d                	addi	s0,s0,-1
ffffffffc0206882:	94be                	add	s1,s1,a5
ffffffffc0206884:	77e2                	ld	a5,56(sp)
ffffffffc0206886:	040e                	slli	s0,s0,0x3
ffffffffc0206888:	02079713          	slli	a4,a5,0x20
ffffffffc020688c:	01d75793          	srli	a5,a4,0x1d
ffffffffc0206890:	0218                	addi	a4,sp,256
ffffffffc0206892:	943a                	add	s0,s0,a4
ffffffffc0206894:	8c9d                	sub	s1,s1,a5
ffffffffc0206896:	6008                	ld	a0,0(s0)
ffffffffc0206898:	1461                	addi	s0,s0,-8
ffffffffc020689a:	829fb0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc020689e:	fe941ce3          	bne	s0,s1,ffffffffc0206896 <do_execve+0x1e2>
ffffffffc02068a2:	854a                	mv	a0,s2
ffffffffc02068a4:	9a1ff0ef          	jal	ra,ffffffffc0206244 <do_exit>
ffffffffc02068a8:	000a3783          	ld	a5,0(s4)
ffffffffc02068ac:	1487b503          	ld	a0,328(a5)
ffffffffc02068b0:	c3dfe0ef          	jal	ra,ffffffffc02054ec <files_closeall>
ffffffffc02068b4:	4581                	li	a1,0
ffffffffc02068b6:	854a                	mv	a0,s2
ffffffffc02068b8:	ec1fe0ef          	jal	ra,ffffffffc0205778 <sysfile_open>
ffffffffc02068bc:	8baa                	mv	s7,a0
ffffffffc02068be:	6c054263          	bltz	a0,ffffffffc0206f82 <do_execve+0x8ce>
ffffffffc02068c2:	000a3783          	ld	a5,0(s4)
ffffffffc02068c6:	779c                	ld	a5,40(a5)
ffffffffc02068c8:	f20783e3          	beqz	a5,ffffffffc02067ee <do_execve+0x13a>
ffffffffc02068cc:	00007617          	auipc	a2,0x7
ffffffffc02068d0:	30460613          	addi	a2,a2,772 # ffffffffc020dbd0 <CSWTCH.79+0x300>
ffffffffc02068d4:	2c700593          	li	a1,711
ffffffffc02068d8:	00007517          	auipc	a0,0x7
ffffffffc02068dc:	10850513          	addi	a0,a0,264 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc02068e0:	bbff90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02068e4:	854e                	mv	a0,s3
ffffffffc02068e6:	eeafd0ef          	jal	ra,ffffffffc0203fd0 <mm_destroy>
ffffffffc02068ea:	5971                	li	s2,-4
ffffffffc02068ec:	bf41                	j	ffffffffc020687c <do_execve+0x1c8>
ffffffffc02068ee:	5971                	li	s2,-4
ffffffffc02068f0:	c49d                	beqz	s1,ffffffffc020691e <do_execve+0x26a>
ffffffffc02068f2:	00349713          	slli	a4,s1,0x3
ffffffffc02068f6:	fff48413          	addi	s0,s1,-1
ffffffffc02068fa:	199c                	addi	a5,sp,240
ffffffffc02068fc:	34fd                	addiw	s1,s1,-1
ffffffffc02068fe:	97ba                	add	a5,a5,a4
ffffffffc0206900:	02049713          	slli	a4,s1,0x20
ffffffffc0206904:	01d75493          	srli	s1,a4,0x1d
ffffffffc0206908:	040e                	slli	s0,s0,0x3
ffffffffc020690a:	0218                	addi	a4,sp,256
ffffffffc020690c:	943a                	add	s0,s0,a4
ffffffffc020690e:	409784b3          	sub	s1,a5,s1
ffffffffc0206912:	6008                	ld	a0,0(s0)
ffffffffc0206914:	1461                	addi	s0,s0,-8
ffffffffc0206916:	facfb0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc020691a:	fe849ce3          	bne	s1,s0,ffffffffc0206912 <do_execve+0x25e>
ffffffffc020691e:	000a8863          	beqz	s5,ffffffffc020692e <do_execve+0x27a>
ffffffffc0206922:	038a8513          	addi	a0,s5,56
ffffffffc0206926:	e8dfd0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020692a:	040aa823          	sw	zero,80(s5)
ffffffffc020692e:	36813083          	ld	ra,872(sp)
ffffffffc0206932:	36013403          	ld	s0,864(sp)
ffffffffc0206936:	35813483          	ld	s1,856(sp)
ffffffffc020693a:	34813983          	ld	s3,840(sp)
ffffffffc020693e:	34013a03          	ld	s4,832(sp)
ffffffffc0206942:	33813a83          	ld	s5,824(sp)
ffffffffc0206946:	33013b03          	ld	s6,816(sp)
ffffffffc020694a:	32813b83          	ld	s7,808(sp)
ffffffffc020694e:	32013c03          	ld	s8,800(sp)
ffffffffc0206952:	31813c83          	ld	s9,792(sp)
ffffffffc0206956:	31013d03          	ld	s10,784(sp)
ffffffffc020695a:	30813d83          	ld	s11,776(sp)
ffffffffc020695e:	854a                	mv	a0,s2
ffffffffc0206960:	35013903          	ld	s2,848(sp)
ffffffffc0206964:	37010113          	addi	sp,sp,880
ffffffffc0206968:	8082                	ret
ffffffffc020696a:	854a                	mv	a0,s2
ffffffffc020696c:	f56fb0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0206970:	5975                	li	s2,-3
ffffffffc0206972:	bfbd                	j	ffffffffc02068f0 <do_execve+0x23c>
ffffffffc0206974:	000a3783          	ld	a5,0(s4)
ffffffffc0206978:	00007617          	auipc	a2,0x7
ffffffffc020697c:	24860613          	addi	a2,a2,584 # ffffffffc020dbc0 <CSWTCH.79+0x2f0>
ffffffffc0206980:	45c1                	li	a1,16
ffffffffc0206982:	43d4                	lw	a3,4(a5)
ffffffffc0206984:	18a8                	addi	a0,sp,120
ffffffffc0206986:	571040ef          	jal	ra,ffffffffc020b6f6 <snprintf>
ffffffffc020698a:	bb6d                	j	ffffffffc0206744 <do_execve+0x90>
ffffffffc020698c:	04000613          	li	a2,64
ffffffffc0206990:	018c                	addi	a1,sp,192
ffffffffc0206992:	855e                	mv	a0,s7
ffffffffc0206994:	e1dfe0ef          	jal	ra,ffffffffc02057b0 <sysfile_read>
ffffffffc0206998:	04000793          	li	a5,64
ffffffffc020699c:	00f50863          	beq	a0,a5,ffffffffc02069ac <do_execve+0x2f8>
ffffffffc02069a0:	0005091b          	sext.w	s2,a0
ffffffffc02069a4:	ec0545e3          	bltz	a0,ffffffffc020686e <do_execve+0x1ba>
ffffffffc02069a8:	597d                	li	s2,-1
ffffffffc02069aa:	b5d1                	j	ffffffffc020686e <do_execve+0x1ba>
ffffffffc02069ac:	470e                	lw	a4,192(sp)
ffffffffc02069ae:	464c47b7          	lui	a5,0x464c4
ffffffffc02069b2:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc02069b6:	30f71563          	bne	a4,a5,ffffffffc0206cc0 <do_execve+0x60c>
ffffffffc02069ba:	0f815783          	lhu	a5,248(sp)
ffffffffc02069be:	ec82                	sd	zero,88(sp)
ffffffffc02069c0:	e882                	sd	zero,80(sp)
ffffffffc02069c2:	16078063          	beqz	a5,ffffffffc0206b22 <do_execve+0x46e>
ffffffffc02069c6:	e04e                	sd	s3,0(sp)
ffffffffc02069c8:	f4a6                	sd	s1,104(sp)
ffffffffc02069ca:	f0ca                	sd	s2,96(sp)
ffffffffc02069cc:	e4a2                	sd	s0,72(sp)
ffffffffc02069ce:	758e                	ld	a1,224(sp)
ffffffffc02069d0:	67c6                	ld	a5,80(sp)
ffffffffc02069d2:	4601                	li	a2,0
ffffffffc02069d4:	855e                	mv	a0,s7
ffffffffc02069d6:	95be                	add	a1,a1,a5
ffffffffc02069d8:	806ff0ef          	jal	ra,ffffffffc02059de <sysfile_seek>
ffffffffc02069dc:	e42a                	sd	a0,8(sp)
ffffffffc02069de:	10051c63          	bnez	a0,ffffffffc0206af6 <do_execve+0x442>
ffffffffc02069e2:	03800613          	li	a2,56
ffffffffc02069e6:	012c                	addi	a1,sp,136
ffffffffc02069e8:	855e                	mv	a0,s7
ffffffffc02069ea:	dc7fe0ef          	jal	ra,ffffffffc02057b0 <sysfile_read>
ffffffffc02069ee:	03800793          	li	a5,56
ffffffffc02069f2:	10f50563          	beq	a0,a5,ffffffffc0206afc <do_execve+0x448>
ffffffffc02069f6:	6982                	ld	s3,0(sp)
ffffffffc02069f8:	6426                	ld	s0,72(sp)
ffffffffc02069fa:	0005079b          	sext.w	a5,a0
ffffffffc02069fe:	00054363          	bltz	a0,ffffffffc0206a04 <do_execve+0x350>
ffffffffc0206a02:	57fd                	li	a5,-1
ffffffffc0206a04:	e43e                	sd	a5,8(sp)
ffffffffc0206a06:	854e                	mv	a0,s3
ffffffffc0206a08:	f64fd0ef          	jal	ra,ffffffffc020416c <exit_mmap>
ffffffffc0206a0c:	0189b503          	ld	a0,24(s3)
ffffffffc0206a10:	6922                	ld	s2,8(sp)
ffffffffc0206a12:	af4ff0ef          	jal	ra,ffffffffc0205d06 <put_pgdir.isra.0>
ffffffffc0206a16:	854e                	mv	a0,s3
ffffffffc0206a18:	db8fd0ef          	jal	ra,ffffffffc0203fd0 <mm_destroy>
ffffffffc0206a1c:	b585                	j	ffffffffc020687c <do_execve+0x1c8>
ffffffffc0206a1e:	2a070a63          	beqz	a4,ffffffffc0206cd2 <do_execve+0x61e>
ffffffffc0206a22:	8536                	mv	a0,a3
ffffffffc0206a24:	00156693          	ori	a3,a0,1
ffffffffc0206a28:	2681                	sext.w	a3,a3
ffffffffc0206a2a:	00457593          	andi	a1,a0,4
ffffffffc0206a2e:	4555                	li	a0,21
ffffffffc0206a30:	0026f713          	andi	a4,a3,2
ffffffffc0206a34:	f82a                	sd	a0,48(sp)
ffffffffc0206a36:	e319                	bnez	a4,ffffffffc0206a3c <do_execve+0x388>
ffffffffc0206a38:	4745                	li	a4,17
ffffffffc0206a3a:	f83a                	sd	a4,48(sp)
ffffffffc0206a3c:	c589                	beqz	a1,ffffffffc0206a46 <do_execve+0x392>
ffffffffc0206a3e:	7742                	ld	a4,48(sp)
ffffffffc0206a40:	00876713          	ori	a4,a4,8
ffffffffc0206a44:	f83a                	sd	a4,48(sp)
ffffffffc0206a46:	c789                	beqz	a5,ffffffffc0206a50 <do_execve+0x39c>
ffffffffc0206a48:	77c2                	ld	a5,48(sp)
ffffffffc0206a4a:	0027e793          	ori	a5,a5,2
ffffffffc0206a4e:	f83e                	sd	a5,48(sp)
ffffffffc0206a50:	65ea                	ld	a1,152(sp)
ffffffffc0206a52:	6502                	ld	a0,0(sp)
ffffffffc0206a54:	4701                	li	a4,0
ffffffffc0206a56:	dccfd0ef          	jal	ra,ffffffffc0204022 <mm_map>
ffffffffc0206a5a:	e42a                	sd	a0,8(sp)
ffffffffc0206a5c:	ed49                	bnez	a0,ffffffffc0206af6 <do_execve+0x442>
ffffffffc0206a5e:	6cea                	ld	s9,152(sp)
ffffffffc0206a60:	77fd                	lui	a5,0xfffff
ffffffffc0206a62:	6c4a                	ld	s8,144(sp)
ffffffffc0206a64:	00fcf4b3          	and	s1,s9,a5
ffffffffc0206a68:	77aa                	ld	a5,168(sp)
ffffffffc0206a6a:	97e6                	add	a5,a5,s9
ffffffffc0206a6c:	e83e                	sd	a5,16(sp)
ffffffffc0206a6e:	4efcf463          	bgeu	s9,a5,ffffffffc0206f56 <do_execve+0x8a2>
ffffffffc0206a72:	57f1                	li	a5,-4
ffffffffc0206a74:	e43e                	sd	a5,8(sp)
ffffffffc0206a76:	89a6                	mv	s3,s1
ffffffffc0206a78:	a015                	j	ffffffffc0206a9c <do_execve+0x3e8>
ffffffffc0206a7a:	77a2                	ld	a5,40(sp)
ffffffffc0206a7c:	413c85b3          	sub	a1,s9,s3
ffffffffc0206a80:	864a                	mv	a2,s2
ffffffffc0206a82:	97d6                	add	a5,a5,s5
ffffffffc0206a84:	95be                	add	a1,a1,a5
ffffffffc0206a86:	855e                	mv	a0,s7
ffffffffc0206a88:	d29fe0ef          	jal	ra,ffffffffc02057b0 <sysfile_read>
ffffffffc0206a8c:	f6a915e3          	bne	s2,a0,ffffffffc02069f6 <do_execve+0x342>
ffffffffc0206a90:	67c2                	ld	a5,16(sp)
ffffffffc0206a92:	9cca                	add	s9,s9,s2
ffffffffc0206a94:	9c4a                	add	s8,s8,s2
ffffffffc0206a96:	2afcf363          	bgeu	s9,a5,ffffffffc0206d3c <do_execve+0x688>
ffffffffc0206a9a:	89a2                	mv	s3,s0
ffffffffc0206a9c:	6782                	ld	a5,0(sp)
ffffffffc0206a9e:	7642                	ld	a2,48(sp)
ffffffffc0206aa0:	85ce                	mv	a1,s3
ffffffffc0206aa2:	6f88                	ld	a0,24(a5)
ffffffffc0206aa4:	86efd0ef          	jal	ra,ffffffffc0203b12 <pgdir_alloc_page>
ffffffffc0206aa8:	84aa                	mv	s1,a0
ffffffffc0206aaa:	22050863          	beqz	a0,ffffffffc0206cda <do_execve+0x626>
ffffffffc0206aae:	6785                	lui	a5,0x1
ffffffffc0206ab0:	00f98433          	add	s0,s3,a5
ffffffffc0206ab4:	67c2                	ld	a5,16(sp)
ffffffffc0206ab6:	41940933          	sub	s2,s0,s9
ffffffffc0206aba:	0087f463          	bgeu	a5,s0,ffffffffc0206ac2 <do_execve+0x40e>
ffffffffc0206abe:	41978933          	sub	s2,a5,s9
ffffffffc0206ac2:	000dba83          	ld	s5,0(s11)
ffffffffc0206ac6:	7782                	ld	a5,32(sp)
ffffffffc0206ac8:	000b3603          	ld	a2,0(s6)
ffffffffc0206acc:	41548ab3          	sub	s5,s1,s5
ffffffffc0206ad0:	406ada93          	srai	s5,s5,0x6
ffffffffc0206ad4:	9abe                	add	s5,s5,a5
ffffffffc0206ad6:	67e2                	ld	a5,24(sp)
ffffffffc0206ad8:	00faf5b3          	and	a1,s5,a5
ffffffffc0206adc:	0ab2                	slli	s5,s5,0xc
ffffffffc0206ade:	48c5f563          	bgeu	a1,a2,ffffffffc0206f68 <do_execve+0x8b4>
ffffffffc0206ae2:	000d3783          	ld	a5,0(s10)
ffffffffc0206ae6:	4601                	li	a2,0
ffffffffc0206ae8:	85e2                	mv	a1,s8
ffffffffc0206aea:	855e                	mv	a0,s7
ffffffffc0206aec:	f43e                	sd	a5,40(sp)
ffffffffc0206aee:	ef1fe0ef          	jal	ra,ffffffffc02059de <sysfile_seek>
ffffffffc0206af2:	e42a                	sd	a0,8(sp)
ffffffffc0206af4:	d159                	beqz	a0,ffffffffc0206a7a <do_execve+0x3c6>
ffffffffc0206af6:	6982                	ld	s3,0(sp)
ffffffffc0206af8:	6426                	ld	s0,72(sp)
ffffffffc0206afa:	b731                	j	ffffffffc0206a06 <do_execve+0x352>
ffffffffc0206afc:	47aa                	lw	a5,136(sp)
ffffffffc0206afe:	4705                	li	a4,1
ffffffffc0206b00:	18e78763          	beq	a5,a4,ffffffffc0206c8e <do_execve+0x5da>
ffffffffc0206b04:	6766                	ld	a4,88(sp)
ffffffffc0206b06:	66c6                	ld	a3,80(sp)
ffffffffc0206b08:	0f815783          	lhu	a5,248(sp)
ffffffffc0206b0c:	2705                	addiw	a4,a4,1
ffffffffc0206b0e:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc0206b12:	ecba                	sd	a4,88(sp)
ffffffffc0206b14:	e8b6                	sd	a3,80(sp)
ffffffffc0206b16:	eaf74ce3          	blt	a4,a5,ffffffffc02069ce <do_execve+0x31a>
ffffffffc0206b1a:	6982                	ld	s3,0(sp)
ffffffffc0206b1c:	74a6                	ld	s1,104(sp)
ffffffffc0206b1e:	7906                	ld	s2,96(sp)
ffffffffc0206b20:	6426                	ld	s0,72(sp)
ffffffffc0206b22:	4701                	li	a4,0
ffffffffc0206b24:	46ad                	li	a3,11
ffffffffc0206b26:	00100637          	lui	a2,0x100
ffffffffc0206b2a:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0206b2e:	854e                	mv	a0,s3
ffffffffc0206b30:	cf2fd0ef          	jal	ra,ffffffffc0204022 <mm_map>
ffffffffc0206b34:	e42a                	sd	a0,8(sp)
ffffffffc0206b36:	ec0518e3          	bnez	a0,ffffffffc0206a06 <do_execve+0x352>
ffffffffc0206b3a:	0189b503          	ld	a0,24(s3)
ffffffffc0206b3e:	465d                	li	a2,23
ffffffffc0206b40:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0206b44:	fcffc0ef          	jal	ra,ffffffffc0203b12 <pgdir_alloc_page>
ffffffffc0206b48:	44050163          	beqz	a0,ffffffffc0206f8a <do_execve+0x8d6>
ffffffffc0206b4c:	0189b503          	ld	a0,24(s3)
ffffffffc0206b50:	465d                	li	a2,23
ffffffffc0206b52:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0206b56:	fbdfc0ef          	jal	ra,ffffffffc0203b12 <pgdir_alloc_page>
ffffffffc0206b5a:	46050863          	beqz	a0,ffffffffc0206fca <do_execve+0x916>
ffffffffc0206b5e:	0189b503          	ld	a0,24(s3)
ffffffffc0206b62:	465d                	li	a2,23
ffffffffc0206b64:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0206b68:	fabfc0ef          	jal	ra,ffffffffc0203b12 <pgdir_alloc_page>
ffffffffc0206b6c:	42050f63          	beqz	a0,ffffffffc0206faa <do_execve+0x8f6>
ffffffffc0206b70:	0189b503          	ld	a0,24(s3)
ffffffffc0206b74:	465d                	li	a2,23
ffffffffc0206b76:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0206b7a:	f99fc0ef          	jal	ra,ffffffffc0203b12 <pgdir_alloc_page>
ffffffffc0206b7e:	48050863          	beqz	a0,ffffffffc020700e <do_execve+0x95a>
ffffffffc0206b82:	0309a783          	lw	a5,48(s3)
ffffffffc0206b86:	000a3703          	ld	a4,0(s4)
ffffffffc0206b8a:	0189b683          	ld	a3,24(s3)
ffffffffc0206b8e:	2785                	addiw	a5,a5,1
ffffffffc0206b90:	02f9a823          	sw	a5,48(s3)
ffffffffc0206b94:	03373423          	sd	s3,40(a4)
ffffffffc0206b98:	c02007b7          	lui	a5,0xc0200
ffffffffc0206b9c:	44f6ed63          	bltu	a3,a5,ffffffffc0206ff6 <do_execve+0x942>
ffffffffc0206ba0:	000d3783          	ld	a5,0(s10)
ffffffffc0206ba4:	55fd                	li	a1,-1
ffffffffc0206ba6:	03f59613          	slli	a2,a1,0x3f
ffffffffc0206baa:	8e9d                	sub	a3,a3,a5
ffffffffc0206bac:	00c6d793          	srli	a5,a3,0xc
ffffffffc0206bb0:	f754                	sd	a3,168(a4)
ffffffffc0206bb2:	8fd1                	or	a5,a5,a2
ffffffffc0206bb4:	18079073          	csrw	satp,a5
ffffffffc0206bb8:	12000073          	sfence.vma
ffffffffc0206bbc:	4c85                	li	s9,1
ffffffffc0206bbe:	041c                	addi	a5,sp,512
ffffffffc0206bc0:	00c5d713          	srli	a4,a1,0xc
ffffffffc0206bc4:	01fc9c13          	slli	s8,s9,0x1f
ffffffffc0206bc8:	6b85                	lui	s7,0x1
ffffffffc0206bca:	10010d93          	addi	s11,sp,256
ffffffffc0206bce:	e03a                	sd	a4,0(sp)
ffffffffc0206bd0:	8cbe                	mv	s9,a5
ffffffffc0206bd2:	e826                	sd	s1,16(sp)
ffffffffc0206bd4:	ec4a                	sd	s2,24(sp)
ffffffffc0206bd6:	f022                	sd	s0,32(sp)
ffffffffc0206bd8:	000dba83          	ld	s5,0(s11)
ffffffffc0206bdc:	8556                	mv	a0,s5
ffffffffc0206bde:	367040ef          	jal	ra,ffffffffc020b744 <strlen>
ffffffffc0206be2:	00150913          	addi	s2,a0,1
ffffffffc0206be6:	412c0c33          	sub	s8,s8,s2
ffffffffc0206bea:	84e2                	mv	s1,s8
ffffffffc0206bec:	06090a63          	beqz	s2,ffffffffc0206c60 <do_execve+0x5ac>
ffffffffc0206bf0:	0189b503          	ld	a0,24(s3)
ffffffffc0206bf4:	4601                	li	a2,0
ffffffffc0206bf6:	85a6                	mv	a1,s1
ffffffffc0206bf8:	eb0fb0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc0206bfc:	6118                	ld	a4,0(a0)
ffffffffc0206bfe:	00177793          	andi	a5,a4,1
ffffffffc0206c02:	42078663          	beqz	a5,ffffffffc020702e <do_execve+0x97a>
ffffffffc0206c06:	000b3583          	ld	a1,0(s6)
ffffffffc0206c0a:	070a                	slli	a4,a4,0x2
ffffffffc0206c0c:	8331                	srli	a4,a4,0xc
ffffffffc0206c0e:	36b77c63          	bgeu	a4,a1,ffffffffc0206f86 <do_execve+0x8d2>
ffffffffc0206c12:	6785                	lui	a5,0x1
ffffffffc0206c14:	17fd                	addi	a5,a5,-1
ffffffffc0206c16:	00f4f533          	and	a0,s1,a5
ffffffffc0206c1a:	40ab8433          	sub	s0,s7,a0
ffffffffc0206c1e:	00009797          	auipc	a5,0x9
ffffffffc0206c22:	11278793          	addi	a5,a5,274 # ffffffffc020fd30 <nbase>
ffffffffc0206c26:	0007b883          	ld	a7,0(a5)
ffffffffc0206c2a:	00897363          	bgeu	s2,s0,ffffffffc0206c30 <do_execve+0x57c>
ffffffffc0206c2e:	844a                	mv	s0,s2
ffffffffc0206c30:	411707b3          	sub	a5,a4,a7
ffffffffc0206c34:	079a                	slli	a5,a5,0x6
ffffffffc0206c36:	6702                	ld	a4,0(sp)
ffffffffc0206c38:	8799                	srai	a5,a5,0x6
ffffffffc0206c3a:	97c6                	add	a5,a5,a7
ffffffffc0206c3c:	8f7d                	and	a4,a4,a5
ffffffffc0206c3e:	07b2                	slli	a5,a5,0xc
ffffffffc0206c40:	3eb77963          	bgeu	a4,a1,ffffffffc0207032 <do_execve+0x97e>
ffffffffc0206c44:	000d3703          	ld	a4,0(s10)
ffffffffc0206c48:	85d6                	mv	a1,s5
ffffffffc0206c4a:	8622                	mv	a2,s0
ffffffffc0206c4c:	97ba                	add	a5,a5,a4
ffffffffc0206c4e:	953e                	add	a0,a0,a5
ffffffffc0206c50:	40890933          	sub	s2,s2,s0
ffffffffc0206c54:	3e5040ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc0206c58:	94a2                	add	s1,s1,s0
ffffffffc0206c5a:	9aa2                	add	s5,s5,s0
ffffffffc0206c5c:	f8091ae3          	bnez	s2,ffffffffc0206bf0 <do_execve+0x53c>
ffffffffc0206c60:	6722                	ld	a4,8(sp)
ffffffffc0206c62:	66c2                	ld	a3,16(sp)
ffffffffc0206c64:	018cb023          	sd	s8,0(s9)
ffffffffc0206c68:	0017079b          	addiw	a5,a4,1
ffffffffc0206c6c:	0da1                	addi	s11,s11,8
ffffffffc0206c6e:	0ca1                	addi	s9,s9,8
ffffffffc0206c70:	1cd75e63          	bge	a4,a3,ffffffffc0206e4c <do_execve+0x798>
ffffffffc0206c74:	e43e                	sd	a5,8(sp)
ffffffffc0206c76:	b78d                	j	ffffffffc0206bd8 <do_execve+0x524>
ffffffffc0206c78:	8556                	mv	a0,s5
ffffffffc0206c7a:	cf2fd0ef          	jal	ra,ffffffffc020416c <exit_mmap>
ffffffffc0206c7e:	018ab503          	ld	a0,24(s5)
ffffffffc0206c82:	884ff0ef          	jal	ra,ffffffffc0205d06 <put_pgdir.isra.0>
ffffffffc0206c86:	8556                	mv	a0,s5
ffffffffc0206c88:	b48fd0ef          	jal	ra,ffffffffc0203fd0 <mm_destroy>
ffffffffc0206c8c:	bea9                	j	ffffffffc02067e6 <do_execve+0x132>
ffffffffc0206c8e:	764a                	ld	a2,176(sp)
ffffffffc0206c90:	772a                	ld	a4,168(sp)
ffffffffc0206c92:	2ce66763          	bltu	a2,a4,ffffffffc0206f60 <do_execve+0x8ac>
ffffffffc0206c96:	473a                	lw	a4,140(sp)
ffffffffc0206c98:	00177693          	andi	a3,a4,1
ffffffffc0206c9c:	c291                	beqz	a3,ffffffffc0206ca0 <do_execve+0x5ec>
ffffffffc0206c9e:	4691                	li	a3,4
ffffffffc0206ca0:	00277593          	andi	a1,a4,2
ffffffffc0206ca4:	8b11                	andi	a4,a4,4
ffffffffc0206ca6:	d6058ce3          	beqz	a1,ffffffffc0206a1e <do_execve+0x36a>
ffffffffc0206caa:	0026e513          	ori	a0,a3,2
ffffffffc0206cae:	d6071be3          	bnez	a4,ffffffffc0206a24 <do_execve+0x370>
ffffffffc0206cb2:	4755                	li	a4,21
ffffffffc0206cb4:	0016f793          	andi	a5,a3,1
ffffffffc0206cb8:	85b6                	mv	a1,a3
ffffffffc0206cba:	f83a                	sd	a4,48(sp)
ffffffffc0206cbc:	86aa                	mv	a3,a0
ffffffffc0206cbe:	bbbd                	j	ffffffffc0206a3c <do_execve+0x388>
ffffffffc0206cc0:	0189b503          	ld	a0,24(s3)
ffffffffc0206cc4:	5961                	li	s2,-8
ffffffffc0206cc6:	840ff0ef          	jal	ra,ffffffffc0205d06 <put_pgdir.isra.0>
ffffffffc0206cca:	854e                	mv	a0,s3
ffffffffc0206ccc:	b04fd0ef          	jal	ra,ffffffffc0203fd0 <mm_destroy>
ffffffffc0206cd0:	b675                	j	ffffffffc020687c <do_execve+0x1c8>
ffffffffc0206cd2:	0016f793          	andi	a5,a3,1
ffffffffc0206cd6:	85b6                	mv	a1,a3
ffffffffc0206cd8:	bb99                	j	ffffffffc0206a2e <do_execve+0x37a>
ffffffffc0206cda:	6982                	ld	s3,0(sp)
ffffffffc0206cdc:	7906                	ld	s2,96(sp)
ffffffffc0206cde:	6426                	ld	s0,72(sp)
ffffffffc0206ce0:	854e                	mv	a0,s3
ffffffffc0206ce2:	c8afd0ef          	jal	ra,ffffffffc020416c <exit_mmap>
ffffffffc0206ce6:	0189b503          	ld	a0,24(s3)
ffffffffc0206cea:	81cff0ef          	jal	ra,ffffffffc0205d06 <put_pgdir.isra.0>
ffffffffc0206cee:	854e                	mv	a0,s3
ffffffffc0206cf0:	ae0fd0ef          	jal	ra,ffffffffc0203fd0 <mm_destroy>
ffffffffc0206cf4:	67a2                	ld	a5,8(sp)
ffffffffc0206cf6:	2e079a63          	bnez	a5,ffffffffc0206fea <do_execve+0x936>
ffffffffc0206cfa:	03816a83          	lwu	s5,56(sp)
ffffffffc0206cfe:	6786                	ld	a5,64(sp)
ffffffffc0206d00:	147d                	addi	s0,s0,-1
ffffffffc0206d02:	1984                	addi	s1,sp,240
ffffffffc0206d04:	94be                	add	s1,s1,a5
ffffffffc0206d06:	040e                	slli	s0,s0,0x3
ffffffffc0206d08:	0a8e                	slli	s5,s5,0x3
ffffffffc0206d0a:	021c                	addi	a5,sp,256
ffffffffc0206d0c:	943e                	add	s0,s0,a5
ffffffffc0206d0e:	415484b3          	sub	s1,s1,s5
ffffffffc0206d12:	6008                	ld	a0,0(s0)
ffffffffc0206d14:	1461                	addi	s0,s0,-8
ffffffffc0206d16:	bacfb0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0206d1a:	fe941ce3          	bne	s0,s1,ffffffffc0206d12 <do_execve+0x65e>
ffffffffc0206d1e:	000a3403          	ld	s0,0(s4)
ffffffffc0206d22:	4641                	li	a2,16
ffffffffc0206d24:	4581                	li	a1,0
ffffffffc0206d26:	0b440413          	addi	s0,s0,180
ffffffffc0206d2a:	8522                	mv	a0,s0
ffffffffc0206d2c:	2bb040ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0206d30:	463d                	li	a2,15
ffffffffc0206d32:	18ac                	addi	a1,sp,120
ffffffffc0206d34:	8522                	mv	a0,s0
ffffffffc0206d36:	303040ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc0206d3a:	bed5                	j	ffffffffc020692e <do_execve+0x27a>
ffffffffc0206d3c:	67ea                	ld	a5,152(sp)
ffffffffc0206d3e:	f426                	sd	s1,40(sp)
ffffffffc0206d40:	76ca                	ld	a3,176(sp)
ffffffffc0206d42:	00d784b3          	add	s1,a5,a3
ffffffffc0206d46:	068cff63          	bgeu	s9,s0,ffffffffc0206dc4 <do_execve+0x710>
ffffffffc0206d4a:	da9c8de3          	beq	s9,s1,ffffffffc0206b04 <do_execve+0x450>
ffffffffc0206d4e:	6785                	lui	a5,0x1
ffffffffc0206d50:	00fc8533          	add	a0,s9,a5
ffffffffc0206d54:	8d01                	sub	a0,a0,s0
ffffffffc0206d56:	41948ab3          	sub	s5,s1,s9
ffffffffc0206d5a:	0084e463          	bltu	s1,s0,ffffffffc0206d62 <do_execve+0x6ae>
ffffffffc0206d5e:	41940ab3          	sub	s5,s0,s9
ffffffffc0206d62:	77a2                	ld	a5,40(sp)
ffffffffc0206d64:	000db683          	ld	a3,0(s11)
ffffffffc0206d68:	000b3603          	ld	a2,0(s6)
ffffffffc0206d6c:	40d786b3          	sub	a3,a5,a3
ffffffffc0206d70:	7782                	ld	a5,32(sp)
ffffffffc0206d72:	8699                	srai	a3,a3,0x6
ffffffffc0206d74:	96be                	add	a3,a3,a5
ffffffffc0206d76:	67e2                	ld	a5,24(sp)
ffffffffc0206d78:	00f6f5b3          	and	a1,a3,a5
ffffffffc0206d7c:	06b2                	slli	a3,a3,0xc
ffffffffc0206d7e:	1ec5f663          	bgeu	a1,a2,ffffffffc0206f6a <do_execve+0x8b6>
ffffffffc0206d82:	000d3803          	ld	a6,0(s10)
ffffffffc0206d86:	8656                	mv	a2,s5
ffffffffc0206d88:	4581                	li	a1,0
ffffffffc0206d8a:	96c2                	add	a3,a3,a6
ffffffffc0206d8c:	9536                	add	a0,a0,a3
ffffffffc0206d8e:	259040ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0206d92:	015c87b3          	add	a5,s9,s5
ffffffffc0206d96:	0284f463          	bgeu	s1,s0,ffffffffc0206dbe <do_execve+0x70a>
ffffffffc0206d9a:	d6f485e3          	beq	s1,a5,ffffffffc0206b04 <do_execve+0x450>
ffffffffc0206d9e:	00007697          	auipc	a3,0x7
ffffffffc0206da2:	e5a68693          	addi	a3,a3,-422 # ffffffffc020dbf8 <CSWTCH.79+0x328>
ffffffffc0206da6:	00005617          	auipc	a2,0x5
ffffffffc0206daa:	f2260613          	addi	a2,a2,-222 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0206dae:	32300593          	li	a1,803
ffffffffc0206db2:	00007517          	auipc	a0,0x7
ffffffffc0206db6:	c2e50513          	addi	a0,a0,-978 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0206dba:	ee4f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206dbe:	fe8790e3          	bne	a5,s0,ffffffffc0206d9e <do_execve+0x6ea>
ffffffffc0206dc2:	8ca2                	mv	s9,s0
ffffffffc0206dc4:	d49cf0e3          	bgeu	s9,s1,ffffffffc0206b04 <do_execve+0x450>
ffffffffc0206dc8:	6982                	ld	s3,0(sp)
ffffffffc0206dca:	7ac2                	ld	s5,48(sp)
ffffffffc0206dcc:	7c02                	ld	s8,32(sp)
ffffffffc0206dce:	a091                	j	ffffffffc0206e12 <do_execve+0x75e>
ffffffffc0206dd0:	6785                	lui	a5,0x1
ffffffffc0206dd2:	408c8533          	sub	a0,s9,s0
ffffffffc0206dd6:	943e                	add	s0,s0,a5
ffffffffc0206dd8:	41940633          	sub	a2,s0,s9
ffffffffc0206ddc:	0084f463          	bgeu	s1,s0,ffffffffc0206de4 <do_execve+0x730>
ffffffffc0206de0:	41948633          	sub	a2,s1,s9
ffffffffc0206de4:	000db783          	ld	a5,0(s11)
ffffffffc0206de8:	66e2                	ld	a3,24(sp)
ffffffffc0206dea:	000b3703          	ld	a4,0(s6)
ffffffffc0206dee:	40f907b3          	sub	a5,s2,a5
ffffffffc0206df2:	8799                	srai	a5,a5,0x6
ffffffffc0206df4:	97e2                	add	a5,a5,s8
ffffffffc0206df6:	8efd                	and	a3,a3,a5
ffffffffc0206df8:	07b2                	slli	a5,a5,0xc
ffffffffc0206dfa:	22e6fc63          	bgeu	a3,a4,ffffffffc0207032 <do_execve+0x97e>
ffffffffc0206dfe:	000d3703          	ld	a4,0(s10)
ffffffffc0206e02:	9cb2                	add	s9,s9,a2
ffffffffc0206e04:	4581                	li	a1,0
ffffffffc0206e06:	97ba                	add	a5,a5,a4
ffffffffc0206e08:	953e                	add	a0,a0,a5
ffffffffc0206e0a:	1dd040ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0206e0e:	009cff63          	bgeu	s9,s1,ffffffffc0206e2c <do_execve+0x778>
ffffffffc0206e12:	0189b503          	ld	a0,24(s3)
ffffffffc0206e16:	8656                	mv	a2,s5
ffffffffc0206e18:	85a2                	mv	a1,s0
ffffffffc0206e1a:	cf9fc0ef          	jal	ra,ffffffffc0203b12 <pgdir_alloc_page>
ffffffffc0206e1e:	892a                	mv	s2,a0
ffffffffc0206e20:	f945                	bnez	a0,ffffffffc0206dd0 <do_execve+0x71c>
ffffffffc0206e22:	7906                	ld	s2,96(sp)
ffffffffc0206e24:	6426                	ld	s0,72(sp)
ffffffffc0206e26:	bd6d                	j	ffffffffc0206ce0 <do_execve+0x62c>
ffffffffc0206e28:	5975                	li	s2,-3
ffffffffc0206e2a:	b611                	j	ffffffffc020692e <do_execve+0x27a>
ffffffffc0206e2c:	f44a                	sd	s2,40(sp)
ffffffffc0206e2e:	b9d9                	j	ffffffffc0206b04 <do_execve+0x450>
ffffffffc0206e30:	5975                	li	s2,-3
ffffffffc0206e32:	ae0a98e3          	bnez	s5,ffffffffc0206922 <do_execve+0x26e>
ffffffffc0206e36:	bce5                	j	ffffffffc020692e <do_execve+0x27a>
ffffffffc0206e38:	fe0a88e3          	beqz	s5,ffffffffc0206e28 <do_execve+0x774>
ffffffffc0206e3c:	038a8513          	addi	a0,s5,56
ffffffffc0206e40:	973fd0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0206e44:	5975                	li	s2,-3
ffffffffc0206e46:	040aa823          	sw	zero,80(s5)
ffffffffc0206e4a:	b4d5                	j	ffffffffc020692e <do_execve+0x27a>
ffffffffc0206e4c:	0189b503          	ld	a0,24(s3)
ffffffffc0206e50:	ff8c7493          	andi	s1,s8,-8
ffffffffc0206e54:	ff848c93          	addi	s9,s1,-8
ffffffffc0206e58:	4601                	li	a2,0
ffffffffc0206e5a:	85e6                	mv	a1,s9
ffffffffc0206e5c:	6962                	ld	s2,24(sp)
ffffffffc0206e5e:	7402                	ld	s0,32(sp)
ffffffffc0206e60:	c48fb0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc0206e64:	611c                	ld	a5,0(a0)
ffffffffc0206e66:	0017f713          	andi	a4,a5,1
ffffffffc0206e6a:	1c070263          	beqz	a4,ffffffffc020702e <do_execve+0x97a>
ffffffffc0206e6e:	000b3703          	ld	a4,0(s6)
ffffffffc0206e72:	078a                	slli	a5,a5,0x2
ffffffffc0206e74:	83b1                	srli	a5,a5,0xc
ffffffffc0206e76:	10e7f863          	bgeu	a5,a4,ffffffffc0206f86 <do_execve+0x8d2>
ffffffffc0206e7a:	00009697          	auipc	a3,0x9
ffffffffc0206e7e:	eb668693          	addi	a3,a3,-330 # ffffffffc020fd30 <nbase>
ffffffffc0206e82:	0006bd83          	ld	s11,0(a3)
ffffffffc0206e86:	5bfd                	li	s7,-1
ffffffffc0206e88:	00cbdb93          	srli	s7,s7,0xc
ffffffffc0206e8c:	41b786b3          	sub	a3,a5,s11
ffffffffc0206e90:	069a                	slli	a3,a3,0x6
ffffffffc0206e92:	8699                	srai	a3,a3,0x6
ffffffffc0206e94:	96ee                	add	a3,a3,s11
ffffffffc0206e96:	0176f7b3          	and	a5,a3,s7
ffffffffc0206e9a:	06b2                	slli	a3,a3,0xc
ffffffffc0206e9c:	0ce7f763          	bgeu	a5,a4,ffffffffc0206f6a <do_execve+0x8b6>
ffffffffc0206ea0:	6785                	lui	a5,0x1
ffffffffc0206ea2:	000d3703          	ld	a4,0(s10)
ffffffffc0206ea6:	17fd                	addi	a5,a5,-1
ffffffffc0206ea8:	e03e                	sd	a5,0(sp)
ffffffffc0206eaa:	00fcf7b3          	and	a5,s9,a5
ffffffffc0206eae:	03816a83          	lwu	s5,56(sp)
ffffffffc0206eb2:	97b6                	add	a5,a5,a3
ffffffffc0206eb4:	97ba                	add	a5,a5,a4
ffffffffc0206eb6:	0007b023          	sd	zero,0(a5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0206eba:	6786                	ld	a5,64(sp)
ffffffffc0206ebc:	003a9c13          	slli	s8,s5,0x3
ffffffffc0206ec0:	41848c33          	sub	s8,s1,s8
ffffffffc0206ec4:	1c41                	addi	s8,s8,-16
ffffffffc0206ec6:	409784b3          	sub	s1,a5,s1
ffffffffc0206eca:	0189b503          	ld	a0,24(s3)
ffffffffc0206ece:	1ce1                	addi	s9,s9,-8
ffffffffc0206ed0:	4601                	li	a2,0
ffffffffc0206ed2:	85e6                	mv	a1,s9
ffffffffc0206ed4:	bd4fb0ef          	jal	ra,ffffffffc02022a8 <get_pte>
ffffffffc0206ed8:	611c                	ld	a5,0(a0)
ffffffffc0206eda:	0017f713          	andi	a4,a5,1
ffffffffc0206ede:	14070863          	beqz	a4,ffffffffc020702e <do_execve+0x97a>
ffffffffc0206ee2:	000b3703          	ld	a4,0(s6)
ffffffffc0206ee6:	078a                	slli	a5,a5,0x2
ffffffffc0206ee8:	83b1                	srli	a5,a5,0xc
ffffffffc0206eea:	08e7fe63          	bgeu	a5,a4,ffffffffc0206f86 <do_execve+0x8d2>
ffffffffc0206eee:	41b787b3          	sub	a5,a5,s11
ffffffffc0206ef2:	079a                	slli	a5,a5,0x6
ffffffffc0206ef4:	8799                	srai	a5,a5,0x6
ffffffffc0206ef6:	97ee                	add	a5,a5,s11
ffffffffc0206ef8:	0177f633          	and	a2,a5,s7
ffffffffc0206efc:	00c79693          	slli	a3,a5,0xc
ffffffffc0206f00:	06e67563          	bgeu	a2,a4,ffffffffc0206f6a <do_execve+0x8b6>
ffffffffc0206f04:	0418                	addi	a4,sp,512
ffffffffc0206f06:	019487b3          	add	a5,s1,s9
ffffffffc0206f0a:	97ba                	add	a5,a5,a4
ffffffffc0206f0c:	6798                	ld	a4,8(a5)
ffffffffc0206f0e:	6782                	ld	a5,0(sp)
ffffffffc0206f10:	000d3603          	ld	a2,0(s10)
ffffffffc0206f14:	00fcf7b3          	and	a5,s9,a5
ffffffffc0206f18:	97b6                	add	a5,a5,a3
ffffffffc0206f1a:	97b2                	add	a5,a5,a2
ffffffffc0206f1c:	e398                	sd	a4,0(a5)
ffffffffc0206f1e:	fb8c96e3          	bne	s9,s8,ffffffffc0206eca <do_execve+0x816>
ffffffffc0206f22:	000a3783          	ld	a5,0(s4)
ffffffffc0206f26:	12000613          	li	a2,288
ffffffffc0206f2a:	4581                	li	a1,0
ffffffffc0206f2c:	73c4                	ld	s1,160(a5)
ffffffffc0206f2e:	8526                	mv	a0,s1
ffffffffc0206f30:	0b7040ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0206f34:	67ee                	ld	a5,216(sp)
ffffffffc0206f36:	0194b823          	sd	s9,16(s1)
ffffffffc0206f3a:	10f4b423          	sd	a5,264(s1)
ffffffffc0206f3e:	100027f3          	csrr	a5,sstatus
ffffffffc0206f42:	eff7f793          	andi	a5,a5,-257
ffffffffc0206f46:	0207e793          	ori	a5,a5,32
ffffffffc0206f4a:	10f4b023          	sd	a5,256(s1)
ffffffffc0206f4e:	e8a0                	sd	s0,80(s1)
ffffffffc0206f50:	0594bc23          	sd	s9,88(s1)
ffffffffc0206f54:	b36d                	j	ffffffffc0206cfe <do_execve+0x64a>
ffffffffc0206f56:	5771                	li	a4,-4
ffffffffc0206f58:	87e6                	mv	a5,s9
ffffffffc0206f5a:	8426                	mv	s0,s1
ffffffffc0206f5c:	e43a                	sd	a4,8(sp)
ffffffffc0206f5e:	b3cd                	j	ffffffffc0206d40 <do_execve+0x68c>
ffffffffc0206f60:	6982                	ld	s3,0(sp)
ffffffffc0206f62:	6426                	ld	s0,72(sp)
ffffffffc0206f64:	57e1                	li	a5,-8
ffffffffc0206f66:	bc79                	j	ffffffffc0206a04 <do_execve+0x350>
ffffffffc0206f68:	86d6                	mv	a3,s5
ffffffffc0206f6a:	00006617          	auipc	a2,0x6
ffffffffc0206f6e:	89e60613          	addi	a2,a2,-1890 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc0206f72:	07100593          	li	a1,113
ffffffffc0206f76:	00006517          	auipc	a0,0x6
ffffffffc0206f7a:	8ba50513          	addi	a0,a0,-1862 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0206f7e:	d20f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206f82:	892a                	mv	s2,a0
ffffffffc0206f84:	b8e5                	j	ffffffffc020687c <do_execve+0x1c8>
ffffffffc0206f86:	d49fe0ef          	jal	ra,ffffffffc0205cce <pa2page.part.0>
ffffffffc0206f8a:	00007697          	auipc	a3,0x7
ffffffffc0206f8e:	cae68693          	addi	a3,a3,-850 # ffffffffc020dc38 <CSWTCH.79+0x368>
ffffffffc0206f92:	00005617          	auipc	a2,0x5
ffffffffc0206f96:	d3660613          	addi	a2,a2,-714 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0206f9a:	33600593          	li	a1,822
ffffffffc0206f9e:	00007517          	auipc	a0,0x7
ffffffffc0206fa2:	a4250513          	addi	a0,a0,-1470 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0206fa6:	cf8f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206faa:	00007697          	auipc	a3,0x7
ffffffffc0206fae:	d3e68693          	addi	a3,a3,-706 # ffffffffc020dce8 <CSWTCH.79+0x418>
ffffffffc0206fb2:	00005617          	auipc	a2,0x5
ffffffffc0206fb6:	d1660613          	addi	a2,a2,-746 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0206fba:	33800593          	li	a1,824
ffffffffc0206fbe:	00007517          	auipc	a0,0x7
ffffffffc0206fc2:	a2250513          	addi	a0,a0,-1502 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0206fc6:	cd8f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206fca:	00007697          	auipc	a3,0x7
ffffffffc0206fce:	cc668693          	addi	a3,a3,-826 # ffffffffc020dc90 <CSWTCH.79+0x3c0>
ffffffffc0206fd2:	00005617          	auipc	a2,0x5
ffffffffc0206fd6:	cf660613          	addi	a2,a2,-778 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0206fda:	33700593          	li	a1,823
ffffffffc0206fde:	00007517          	auipc	a0,0x7
ffffffffc0206fe2:	a0250513          	addi	a0,a0,-1534 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0206fe6:	cb8f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206fea:	6922                	ld	s2,8(sp)
ffffffffc0206fec:	891ff06f          	j	ffffffffc020687c <do_execve+0x1c8>
ffffffffc0206ff0:	892a                	mv	s2,a0
ffffffffc0206ff2:	88bff06f          	j	ffffffffc020687c <do_execve+0x1c8>
ffffffffc0206ff6:	00006617          	auipc	a2,0x6
ffffffffc0206ffa:	8ba60613          	addi	a2,a2,-1862 # ffffffffc020c8b0 <default_pmm_manager+0xe0>
ffffffffc0206ffe:	33d00593          	li	a1,829
ffffffffc0207002:	00007517          	auipc	a0,0x7
ffffffffc0207006:	9de50513          	addi	a0,a0,-1570 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc020700a:	c94f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020700e:	00007697          	auipc	a3,0x7
ffffffffc0207012:	d3268693          	addi	a3,a3,-718 # ffffffffc020dd40 <CSWTCH.79+0x470>
ffffffffc0207016:	00005617          	auipc	a2,0x5
ffffffffc020701a:	cb260613          	addi	a2,a2,-846 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020701e:	33900593          	li	a1,825
ffffffffc0207022:	00007517          	auipc	a0,0x7
ffffffffc0207026:	9be50513          	addi	a0,a0,-1602 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc020702a:	c74f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020702e:	cbdfe0ef          	jal	ra,ffffffffc0205cea <pte2page.part.0>
ffffffffc0207032:	86be                	mv	a3,a5
ffffffffc0207034:	00005617          	auipc	a2,0x5
ffffffffc0207038:	7d460613          	addi	a2,a2,2004 # ffffffffc020c808 <default_pmm_manager+0x38>
ffffffffc020703c:	07100593          	li	a1,113
ffffffffc0207040:	00005517          	auipc	a0,0x5
ffffffffc0207044:	7f050513          	addi	a0,a0,2032 # ffffffffc020c830 <default_pmm_manager+0x60>
ffffffffc0207048:	c56f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020704c <user_main>:
ffffffffc020704c:	7179                	addi	sp,sp,-48
ffffffffc020704e:	e84a                	sd	s2,16(sp)
ffffffffc0207050:	00090917          	auipc	s2,0x90
ffffffffc0207054:	88090913          	addi	s2,s2,-1920 # ffffffffc02968d0 <current>
ffffffffc0207058:	00093783          	ld	a5,0(s2)
ffffffffc020705c:	00007617          	auipc	a2,0x7
ffffffffc0207060:	d3c60613          	addi	a2,a2,-708 # ffffffffc020dd98 <CSWTCH.79+0x4c8>
ffffffffc0207064:	00007517          	auipc	a0,0x7
ffffffffc0207068:	d3c50513          	addi	a0,a0,-708 # ffffffffc020dda0 <CSWTCH.79+0x4d0>
ffffffffc020706c:	43cc                	lw	a1,4(a5)
ffffffffc020706e:	f406                	sd	ra,40(sp)
ffffffffc0207070:	f022                	sd	s0,32(sp)
ffffffffc0207072:	ec26                	sd	s1,24(sp)
ffffffffc0207074:	e032                	sd	a2,0(sp)
ffffffffc0207076:	e402                	sd	zero,8(sp)
ffffffffc0207078:	92ef90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020707c:	6782                	ld	a5,0(sp)
ffffffffc020707e:	cfb9                	beqz	a5,ffffffffc02070dc <user_main+0x90>
ffffffffc0207080:	003c                	addi	a5,sp,8
ffffffffc0207082:	4401                	li	s0,0
ffffffffc0207084:	6398                	ld	a4,0(a5)
ffffffffc0207086:	0405                	addi	s0,s0,1
ffffffffc0207088:	07a1                	addi	a5,a5,8
ffffffffc020708a:	ff6d                	bnez	a4,ffffffffc0207084 <user_main+0x38>
ffffffffc020708c:	00093783          	ld	a5,0(s2)
ffffffffc0207090:	12000613          	li	a2,288
ffffffffc0207094:	6b84                	ld	s1,16(a5)
ffffffffc0207096:	73cc                	ld	a1,160(a5)
ffffffffc0207098:	6789                	lui	a5,0x2
ffffffffc020709a:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc020709e:	94be                	add	s1,s1,a5
ffffffffc02070a0:	8526                	mv	a0,s1
ffffffffc02070a2:	796040ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc02070a6:	00093783          	ld	a5,0(s2)
ffffffffc02070aa:	860a                	mv	a2,sp
ffffffffc02070ac:	0004059b          	sext.w	a1,s0
ffffffffc02070b0:	f3c4                	sd	s1,160(a5)
ffffffffc02070b2:	00007517          	auipc	a0,0x7
ffffffffc02070b6:	ce650513          	addi	a0,a0,-794 # ffffffffc020dd98 <CSWTCH.79+0x4c8>
ffffffffc02070ba:	dfaff0ef          	jal	ra,ffffffffc02066b4 <do_execve>
ffffffffc02070be:	8126                	mv	sp,s1
ffffffffc02070c0:	a14fa06f          	j	ffffffffc02012d4 <__trapret>
ffffffffc02070c4:	00007617          	auipc	a2,0x7
ffffffffc02070c8:	d0460613          	addi	a2,a2,-764 # ffffffffc020ddc8 <CSWTCH.79+0x4f8>
ffffffffc02070cc:	48500593          	li	a1,1157
ffffffffc02070d0:	00007517          	auipc	a0,0x7
ffffffffc02070d4:	91050513          	addi	a0,a0,-1776 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc02070d8:	bc6f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02070dc:	4401                	li	s0,0
ffffffffc02070de:	b77d                	j	ffffffffc020708c <user_main+0x40>

ffffffffc02070e0 <do_yield>:
ffffffffc02070e0:	0008f797          	auipc	a5,0x8f
ffffffffc02070e4:	7f07b783          	ld	a5,2032(a5) # ffffffffc02968d0 <current>
ffffffffc02070e8:	4705                	li	a4,1
ffffffffc02070ea:	ef98                	sd	a4,24(a5)
ffffffffc02070ec:	4501                	li	a0,0
ffffffffc02070ee:	8082                	ret

ffffffffc02070f0 <do_wait>:
ffffffffc02070f0:	1101                	addi	sp,sp,-32
ffffffffc02070f2:	e822                	sd	s0,16(sp)
ffffffffc02070f4:	e426                	sd	s1,8(sp)
ffffffffc02070f6:	ec06                	sd	ra,24(sp)
ffffffffc02070f8:	842e                	mv	s0,a1
ffffffffc02070fa:	84aa                	mv	s1,a0
ffffffffc02070fc:	c999                	beqz	a1,ffffffffc0207112 <do_wait+0x22>
ffffffffc02070fe:	0008f797          	auipc	a5,0x8f
ffffffffc0207102:	7d27b783          	ld	a5,2002(a5) # ffffffffc02968d0 <current>
ffffffffc0207106:	7788                	ld	a0,40(a5)
ffffffffc0207108:	4685                	li	a3,1
ffffffffc020710a:	4611                	li	a2,4
ffffffffc020710c:	bd8fd0ef          	jal	ra,ffffffffc02044e4 <user_mem_check>
ffffffffc0207110:	c909                	beqz	a0,ffffffffc0207122 <do_wait+0x32>
ffffffffc0207112:	85a2                	mv	a1,s0
ffffffffc0207114:	6442                	ld	s0,16(sp)
ffffffffc0207116:	60e2                	ld	ra,24(sp)
ffffffffc0207118:	8526                	mv	a0,s1
ffffffffc020711a:	64a2                	ld	s1,8(sp)
ffffffffc020711c:	6105                	addi	sp,sp,32
ffffffffc020711e:	a88ff06f          	j	ffffffffc02063a6 <do_wait.part.0>
ffffffffc0207122:	60e2                	ld	ra,24(sp)
ffffffffc0207124:	6442                	ld	s0,16(sp)
ffffffffc0207126:	64a2                	ld	s1,8(sp)
ffffffffc0207128:	5575                	li	a0,-3
ffffffffc020712a:	6105                	addi	sp,sp,32
ffffffffc020712c:	8082                	ret

ffffffffc020712e <do_kill>:
ffffffffc020712e:	1141                	addi	sp,sp,-16
ffffffffc0207130:	6789                	lui	a5,0x2
ffffffffc0207132:	e406                	sd	ra,8(sp)
ffffffffc0207134:	e022                	sd	s0,0(sp)
ffffffffc0207136:	fff5071b          	addiw	a4,a0,-1
ffffffffc020713a:	17f9                	addi	a5,a5,-2
ffffffffc020713c:	02e7e963          	bltu	a5,a4,ffffffffc020716e <do_kill+0x40>
ffffffffc0207140:	842a                	mv	s0,a0
ffffffffc0207142:	45a9                	li	a1,10
ffffffffc0207144:	2501                	sext.w	a0,a0
ffffffffc0207146:	16c040ef          	jal	ra,ffffffffc020b2b2 <hash32>
ffffffffc020714a:	02051793          	slli	a5,a0,0x20
ffffffffc020714e:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0207152:	0008a797          	auipc	a5,0x8a
ffffffffc0207156:	66e78793          	addi	a5,a5,1646 # ffffffffc02917c0 <hash_list>
ffffffffc020715a:	953e                	add	a0,a0,a5
ffffffffc020715c:	87aa                	mv	a5,a0
ffffffffc020715e:	a029                	j	ffffffffc0207168 <do_kill+0x3a>
ffffffffc0207160:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0207164:	00870b63          	beq	a4,s0,ffffffffc020717a <do_kill+0x4c>
ffffffffc0207168:	679c                	ld	a5,8(a5)
ffffffffc020716a:	fef51be3          	bne	a0,a5,ffffffffc0207160 <do_kill+0x32>
ffffffffc020716e:	5475                	li	s0,-3
ffffffffc0207170:	60a2                	ld	ra,8(sp)
ffffffffc0207172:	8522                	mv	a0,s0
ffffffffc0207174:	6402                	ld	s0,0(sp)
ffffffffc0207176:	0141                	addi	sp,sp,16
ffffffffc0207178:	8082                	ret
ffffffffc020717a:	fd87a703          	lw	a4,-40(a5)
ffffffffc020717e:	00177693          	andi	a3,a4,1
ffffffffc0207182:	e295                	bnez	a3,ffffffffc02071a6 <do_kill+0x78>
ffffffffc0207184:	4bd4                	lw	a3,20(a5)
ffffffffc0207186:	00176713          	ori	a4,a4,1
ffffffffc020718a:	fce7ac23          	sw	a4,-40(a5)
ffffffffc020718e:	4401                	li	s0,0
ffffffffc0207190:	fe06d0e3          	bgez	a3,ffffffffc0207170 <do_kill+0x42>
ffffffffc0207194:	f2878513          	addi	a0,a5,-216
ffffffffc0207198:	434000ef          	jal	ra,ffffffffc02075cc <wakeup_proc>
ffffffffc020719c:	60a2                	ld	ra,8(sp)
ffffffffc020719e:	8522                	mv	a0,s0
ffffffffc02071a0:	6402                	ld	s0,0(sp)
ffffffffc02071a2:	0141                	addi	sp,sp,16
ffffffffc02071a4:	8082                	ret
ffffffffc02071a6:	545d                	li	s0,-9
ffffffffc02071a8:	b7e1                	j	ffffffffc0207170 <do_kill+0x42>

ffffffffc02071aa <proc_init>:
ffffffffc02071aa:	1101                	addi	sp,sp,-32
ffffffffc02071ac:	e426                	sd	s1,8(sp)
ffffffffc02071ae:	0008e797          	auipc	a5,0x8e
ffffffffc02071b2:	61278793          	addi	a5,a5,1554 # ffffffffc02957c0 <proc_list>
ffffffffc02071b6:	ec06                	sd	ra,24(sp)
ffffffffc02071b8:	e822                	sd	s0,16(sp)
ffffffffc02071ba:	e04a                	sd	s2,0(sp)
ffffffffc02071bc:	0008a497          	auipc	s1,0x8a
ffffffffc02071c0:	60448493          	addi	s1,s1,1540 # ffffffffc02917c0 <hash_list>
ffffffffc02071c4:	e79c                	sd	a5,8(a5)
ffffffffc02071c6:	e39c                	sd	a5,0(a5)
ffffffffc02071c8:	0008e717          	auipc	a4,0x8e
ffffffffc02071cc:	5f870713          	addi	a4,a4,1528 # ffffffffc02957c0 <proc_list>
ffffffffc02071d0:	87a6                	mv	a5,s1
ffffffffc02071d2:	e79c                	sd	a5,8(a5)
ffffffffc02071d4:	e39c                	sd	a5,0(a5)
ffffffffc02071d6:	07c1                	addi	a5,a5,16
ffffffffc02071d8:	fef71de3          	bne	a4,a5,ffffffffc02071d2 <proc_init+0x28>
ffffffffc02071dc:	a4bfe0ef          	jal	ra,ffffffffc0205c26 <alloc_proc>
ffffffffc02071e0:	0008f917          	auipc	s2,0x8f
ffffffffc02071e4:	6f890913          	addi	s2,s2,1784 # ffffffffc02968d8 <idleproc>
ffffffffc02071e8:	00a93023          	sd	a0,0(s2)
ffffffffc02071ec:	842a                	mv	s0,a0
ffffffffc02071ee:	12050863          	beqz	a0,ffffffffc020731e <proc_init+0x174>
ffffffffc02071f2:	4789                	li	a5,2
ffffffffc02071f4:	e11c                	sd	a5,0(a0)
ffffffffc02071f6:	0000a797          	auipc	a5,0xa
ffffffffc02071fa:	e0a78793          	addi	a5,a5,-502 # ffffffffc0211000 <bootstack>
ffffffffc02071fe:	e91c                	sd	a5,16(a0)
ffffffffc0207200:	4785                	li	a5,1
ffffffffc0207202:	ed1c                	sd	a5,24(a0)
ffffffffc0207204:	a1cfe0ef          	jal	ra,ffffffffc0205420 <files_create>
ffffffffc0207208:	14a43423          	sd	a0,328(s0)
ffffffffc020720c:	0e050d63          	beqz	a0,ffffffffc0207306 <proc_init+0x15c>
ffffffffc0207210:	00093403          	ld	s0,0(s2)
ffffffffc0207214:	4641                	li	a2,16
ffffffffc0207216:	4581                	li	a1,0
ffffffffc0207218:	14843703          	ld	a4,328(s0)
ffffffffc020721c:	0b440413          	addi	s0,s0,180
ffffffffc0207220:	8522                	mv	a0,s0
ffffffffc0207222:	4b1c                	lw	a5,16(a4)
ffffffffc0207224:	2785                	addiw	a5,a5,1
ffffffffc0207226:	cb1c                	sw	a5,16(a4)
ffffffffc0207228:	5be040ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc020722c:	463d                	li	a2,15
ffffffffc020722e:	00007597          	auipc	a1,0x7
ffffffffc0207232:	bfa58593          	addi	a1,a1,-1030 # ffffffffc020de28 <CSWTCH.79+0x558>
ffffffffc0207236:	8522                	mv	a0,s0
ffffffffc0207238:	600040ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc020723c:	0008f717          	auipc	a4,0x8f
ffffffffc0207240:	6ac70713          	addi	a4,a4,1708 # ffffffffc02968e8 <nr_process>
ffffffffc0207244:	431c                	lw	a5,0(a4)
ffffffffc0207246:	00093683          	ld	a3,0(s2)
ffffffffc020724a:	4601                	li	a2,0
ffffffffc020724c:	2785                	addiw	a5,a5,1
ffffffffc020724e:	4581                	li	a1,0
ffffffffc0207250:	fffff517          	auipc	a0,0xfffff
ffffffffc0207254:	31450513          	addi	a0,a0,788 # ffffffffc0206564 <init_main>
ffffffffc0207258:	c31c                	sw	a5,0(a4)
ffffffffc020725a:	0008f797          	auipc	a5,0x8f
ffffffffc020725e:	66d7bb23          	sd	a3,1654(a5) # ffffffffc02968d0 <current>
ffffffffc0207262:	f93fe0ef          	jal	ra,ffffffffc02061f4 <kernel_thread>
ffffffffc0207266:	842a                	mv	s0,a0
ffffffffc0207268:	08a05363          	blez	a0,ffffffffc02072ee <proc_init+0x144>
ffffffffc020726c:	6789                	lui	a5,0x2
ffffffffc020726e:	fff5071b          	addiw	a4,a0,-1
ffffffffc0207272:	17f9                	addi	a5,a5,-2
ffffffffc0207274:	2501                	sext.w	a0,a0
ffffffffc0207276:	02e7e363          	bltu	a5,a4,ffffffffc020729c <proc_init+0xf2>
ffffffffc020727a:	45a9                	li	a1,10
ffffffffc020727c:	036040ef          	jal	ra,ffffffffc020b2b2 <hash32>
ffffffffc0207280:	02051793          	slli	a5,a0,0x20
ffffffffc0207284:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0207288:	96a6                	add	a3,a3,s1
ffffffffc020728a:	87b6                	mv	a5,a3
ffffffffc020728c:	a029                	j	ffffffffc0207296 <proc_init+0xec>
ffffffffc020728e:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_bin_swap_img_size-0x5dd4>
ffffffffc0207292:	04870b63          	beq	a4,s0,ffffffffc02072e8 <proc_init+0x13e>
ffffffffc0207296:	679c                	ld	a5,8(a5)
ffffffffc0207298:	fef69be3          	bne	a3,a5,ffffffffc020728e <proc_init+0xe4>
ffffffffc020729c:	4781                	li	a5,0
ffffffffc020729e:	0b478493          	addi	s1,a5,180
ffffffffc02072a2:	4641                	li	a2,16
ffffffffc02072a4:	4581                	li	a1,0
ffffffffc02072a6:	0008f417          	auipc	s0,0x8f
ffffffffc02072aa:	63a40413          	addi	s0,s0,1594 # ffffffffc02968e0 <initproc>
ffffffffc02072ae:	8526                	mv	a0,s1
ffffffffc02072b0:	e01c                	sd	a5,0(s0)
ffffffffc02072b2:	534040ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc02072b6:	463d                	li	a2,15
ffffffffc02072b8:	00007597          	auipc	a1,0x7
ffffffffc02072bc:	b9858593          	addi	a1,a1,-1128 # ffffffffc020de50 <CSWTCH.79+0x580>
ffffffffc02072c0:	8526                	mv	a0,s1
ffffffffc02072c2:	576040ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc02072c6:	00093783          	ld	a5,0(s2)
ffffffffc02072ca:	c7d1                	beqz	a5,ffffffffc0207356 <proc_init+0x1ac>
ffffffffc02072cc:	43dc                	lw	a5,4(a5)
ffffffffc02072ce:	e7c1                	bnez	a5,ffffffffc0207356 <proc_init+0x1ac>
ffffffffc02072d0:	601c                	ld	a5,0(s0)
ffffffffc02072d2:	c3b5                	beqz	a5,ffffffffc0207336 <proc_init+0x18c>
ffffffffc02072d4:	43d8                	lw	a4,4(a5)
ffffffffc02072d6:	4785                	li	a5,1
ffffffffc02072d8:	04f71f63          	bne	a4,a5,ffffffffc0207336 <proc_init+0x18c>
ffffffffc02072dc:	60e2                	ld	ra,24(sp)
ffffffffc02072de:	6442                	ld	s0,16(sp)
ffffffffc02072e0:	64a2                	ld	s1,8(sp)
ffffffffc02072e2:	6902                	ld	s2,0(sp)
ffffffffc02072e4:	6105                	addi	sp,sp,32
ffffffffc02072e6:	8082                	ret
ffffffffc02072e8:	f2878793          	addi	a5,a5,-216
ffffffffc02072ec:	bf4d                	j	ffffffffc020729e <proc_init+0xf4>
ffffffffc02072ee:	00007617          	auipc	a2,0x7
ffffffffc02072f2:	b4260613          	addi	a2,a2,-1214 # ffffffffc020de30 <CSWTCH.79+0x560>
ffffffffc02072f6:	4d100593          	li	a1,1233
ffffffffc02072fa:	00006517          	auipc	a0,0x6
ffffffffc02072fe:	6e650513          	addi	a0,a0,1766 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0207302:	99cf90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207306:	00007617          	auipc	a2,0x7
ffffffffc020730a:	afa60613          	addi	a2,a2,-1286 # ffffffffc020de00 <CSWTCH.79+0x530>
ffffffffc020730e:	4c500593          	li	a1,1221
ffffffffc0207312:	00006517          	auipc	a0,0x6
ffffffffc0207316:	6ce50513          	addi	a0,a0,1742 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc020731a:	984f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020731e:	00007617          	auipc	a2,0x7
ffffffffc0207322:	aca60613          	addi	a2,a2,-1334 # ffffffffc020dde8 <CSWTCH.79+0x518>
ffffffffc0207326:	4bb00593          	li	a1,1211
ffffffffc020732a:	00006517          	auipc	a0,0x6
ffffffffc020732e:	6b650513          	addi	a0,a0,1718 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0207332:	96cf90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207336:	00007697          	auipc	a3,0x7
ffffffffc020733a:	b4a68693          	addi	a3,a3,-1206 # ffffffffc020de80 <CSWTCH.79+0x5b0>
ffffffffc020733e:	00005617          	auipc	a2,0x5
ffffffffc0207342:	98a60613          	addi	a2,a2,-1654 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207346:	4d800593          	li	a1,1240
ffffffffc020734a:	00006517          	auipc	a0,0x6
ffffffffc020734e:	69650513          	addi	a0,a0,1686 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0207352:	94cf90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207356:	00007697          	auipc	a3,0x7
ffffffffc020735a:	b0268693          	addi	a3,a3,-1278 # ffffffffc020de58 <CSWTCH.79+0x588>
ffffffffc020735e:	00005617          	auipc	a2,0x5
ffffffffc0207362:	96a60613          	addi	a2,a2,-1686 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207366:	4d700593          	li	a1,1239
ffffffffc020736a:	00006517          	auipc	a0,0x6
ffffffffc020736e:	67650513          	addi	a0,a0,1654 # ffffffffc020d9e0 <CSWTCH.79+0x110>
ffffffffc0207372:	92cf90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207376 <cpu_idle>:
ffffffffc0207376:	1141                	addi	sp,sp,-16
ffffffffc0207378:	e022                	sd	s0,0(sp)
ffffffffc020737a:	e406                	sd	ra,8(sp)
ffffffffc020737c:	0008f417          	auipc	s0,0x8f
ffffffffc0207380:	55440413          	addi	s0,s0,1364 # ffffffffc02968d0 <current>
ffffffffc0207384:	6018                	ld	a4,0(s0)
ffffffffc0207386:	6f1c                	ld	a5,24(a4)
ffffffffc0207388:	dffd                	beqz	a5,ffffffffc0207386 <cpu_idle+0x10>
ffffffffc020738a:	2f4000ef          	jal	ra,ffffffffc020767e <schedule>
ffffffffc020738e:	bfdd                	j	ffffffffc0207384 <cpu_idle+0xe>

ffffffffc0207390 <lab6_set_priority>:
ffffffffc0207390:	1141                	addi	sp,sp,-16
ffffffffc0207392:	e022                	sd	s0,0(sp)
ffffffffc0207394:	85aa                	mv	a1,a0
ffffffffc0207396:	842a                	mv	s0,a0
ffffffffc0207398:	00007517          	auipc	a0,0x7
ffffffffc020739c:	b1050513          	addi	a0,a0,-1264 # ffffffffc020dea8 <CSWTCH.79+0x5d8>
ffffffffc02073a0:	e406                	sd	ra,8(sp)
ffffffffc02073a2:	e05f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02073a6:	0008f797          	auipc	a5,0x8f
ffffffffc02073aa:	52a7b783          	ld	a5,1322(a5) # ffffffffc02968d0 <current>
ffffffffc02073ae:	e801                	bnez	s0,ffffffffc02073be <lab6_set_priority+0x2e>
ffffffffc02073b0:	60a2                	ld	ra,8(sp)
ffffffffc02073b2:	6402                	ld	s0,0(sp)
ffffffffc02073b4:	4705                	li	a4,1
ffffffffc02073b6:	14e7a223          	sw	a4,324(a5)
ffffffffc02073ba:	0141                	addi	sp,sp,16
ffffffffc02073bc:	8082                	ret
ffffffffc02073be:	60a2                	ld	ra,8(sp)
ffffffffc02073c0:	1487a223          	sw	s0,324(a5)
ffffffffc02073c4:	6402                	ld	s0,0(sp)
ffffffffc02073c6:	0141                	addi	sp,sp,16
ffffffffc02073c8:	8082                	ret

ffffffffc02073ca <do_sleep>:
ffffffffc02073ca:	c539                	beqz	a0,ffffffffc0207418 <do_sleep+0x4e>
ffffffffc02073cc:	7179                	addi	sp,sp,-48
ffffffffc02073ce:	f022                	sd	s0,32(sp)
ffffffffc02073d0:	f406                	sd	ra,40(sp)
ffffffffc02073d2:	842a                	mv	s0,a0
ffffffffc02073d4:	100027f3          	csrr	a5,sstatus
ffffffffc02073d8:	8b89                	andi	a5,a5,2
ffffffffc02073da:	e3a9                	bnez	a5,ffffffffc020741c <do_sleep+0x52>
ffffffffc02073dc:	0008f797          	auipc	a5,0x8f
ffffffffc02073e0:	4f47b783          	ld	a5,1268(a5) # ffffffffc02968d0 <current>
ffffffffc02073e4:	0818                	addi	a4,sp,16
ffffffffc02073e6:	c02a                	sw	a0,0(sp)
ffffffffc02073e8:	ec3a                	sd	a4,24(sp)
ffffffffc02073ea:	e83a                	sd	a4,16(sp)
ffffffffc02073ec:	e43e                	sd	a5,8(sp)
ffffffffc02073ee:	4705                	li	a4,1
ffffffffc02073f0:	c398                	sw	a4,0(a5)
ffffffffc02073f2:	80000737          	lui	a4,0x80000
ffffffffc02073f6:	840a                	mv	s0,sp
ffffffffc02073f8:	0709                	addi	a4,a4,2
ffffffffc02073fa:	0ee7a623          	sw	a4,236(a5)
ffffffffc02073fe:	8522                	mv	a0,s0
ffffffffc0207400:	33e000ef          	jal	ra,ffffffffc020773e <add_timer>
ffffffffc0207404:	27a000ef          	jal	ra,ffffffffc020767e <schedule>
ffffffffc0207408:	8522                	mv	a0,s0
ffffffffc020740a:	3fc000ef          	jal	ra,ffffffffc0207806 <del_timer>
ffffffffc020740e:	70a2                	ld	ra,40(sp)
ffffffffc0207410:	7402                	ld	s0,32(sp)
ffffffffc0207412:	4501                	li	a0,0
ffffffffc0207414:	6145                	addi	sp,sp,48
ffffffffc0207416:	8082                	ret
ffffffffc0207418:	4501                	li	a0,0
ffffffffc020741a:	8082                	ret
ffffffffc020741c:	857f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207420:	0008f797          	auipc	a5,0x8f
ffffffffc0207424:	4b07b783          	ld	a5,1200(a5) # ffffffffc02968d0 <current>
ffffffffc0207428:	0818                	addi	a4,sp,16
ffffffffc020742a:	c022                	sw	s0,0(sp)
ffffffffc020742c:	e43e                	sd	a5,8(sp)
ffffffffc020742e:	ec3a                	sd	a4,24(sp)
ffffffffc0207430:	e83a                	sd	a4,16(sp)
ffffffffc0207432:	4705                	li	a4,1
ffffffffc0207434:	c398                	sw	a4,0(a5)
ffffffffc0207436:	80000737          	lui	a4,0x80000
ffffffffc020743a:	0709                	addi	a4,a4,2
ffffffffc020743c:	840a                	mv	s0,sp
ffffffffc020743e:	8522                	mv	a0,s0
ffffffffc0207440:	0ee7a623          	sw	a4,236(a5)
ffffffffc0207444:	2fa000ef          	jal	ra,ffffffffc020773e <add_timer>
ffffffffc0207448:	825f90ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020744c:	bf65                	j	ffffffffc0207404 <do_sleep+0x3a>

ffffffffc020744e <switch_to>:
ffffffffc020744e:	00153023          	sd	ra,0(a0)
ffffffffc0207452:	00253423          	sd	sp,8(a0)
ffffffffc0207456:	e900                	sd	s0,16(a0)
ffffffffc0207458:	ed04                	sd	s1,24(a0)
ffffffffc020745a:	03253023          	sd	s2,32(a0)
ffffffffc020745e:	03353423          	sd	s3,40(a0)
ffffffffc0207462:	03453823          	sd	s4,48(a0)
ffffffffc0207466:	03553c23          	sd	s5,56(a0)
ffffffffc020746a:	05653023          	sd	s6,64(a0)
ffffffffc020746e:	05753423          	sd	s7,72(a0)
ffffffffc0207472:	05853823          	sd	s8,80(a0)
ffffffffc0207476:	05953c23          	sd	s9,88(a0)
ffffffffc020747a:	07a53023          	sd	s10,96(a0)
ffffffffc020747e:	07b53423          	sd	s11,104(a0)
ffffffffc0207482:	0005b083          	ld	ra,0(a1)
ffffffffc0207486:	0085b103          	ld	sp,8(a1)
ffffffffc020748a:	6980                	ld	s0,16(a1)
ffffffffc020748c:	6d84                	ld	s1,24(a1)
ffffffffc020748e:	0205b903          	ld	s2,32(a1)
ffffffffc0207492:	0285b983          	ld	s3,40(a1)
ffffffffc0207496:	0305ba03          	ld	s4,48(a1)
ffffffffc020749a:	0385ba83          	ld	s5,56(a1)
ffffffffc020749e:	0405bb03          	ld	s6,64(a1)
ffffffffc02074a2:	0485bb83          	ld	s7,72(a1)
ffffffffc02074a6:	0505bc03          	ld	s8,80(a1)
ffffffffc02074aa:	0585bc83          	ld	s9,88(a1)
ffffffffc02074ae:	0605bd03          	ld	s10,96(a1)
ffffffffc02074b2:	0685bd83          	ld	s11,104(a1)
ffffffffc02074b6:	8082                	ret

ffffffffc02074b8 <RR_init>:
ffffffffc02074b8:	e508                	sd	a0,8(a0)
ffffffffc02074ba:	e108                	sd	a0,0(a0)
ffffffffc02074bc:	00052823          	sw	zero,16(a0)
ffffffffc02074c0:	00053c23          	sd	zero,24(a0)
ffffffffc02074c4:	8082                	ret

ffffffffc02074c6 <RR_pick_next>:
ffffffffc02074c6:	651c                	ld	a5,8(a0)
ffffffffc02074c8:	00f50563          	beq	a0,a5,ffffffffc02074d2 <RR_pick_next+0xc>
ffffffffc02074cc:	ef078513          	addi	a0,a5,-272
ffffffffc02074d0:	8082                	ret
ffffffffc02074d2:	4501                	li	a0,0
ffffffffc02074d4:	8082                	ret

ffffffffc02074d6 <RR_proc_tick>:
ffffffffc02074d6:	1205a783          	lw	a5,288(a1)
ffffffffc02074da:	00f05863          	blez	a5,ffffffffc02074ea <RR_proc_tick+0x14>
ffffffffc02074de:	fff7871b          	addiw	a4,a5,-1
ffffffffc02074e2:	12e5a023          	sw	a4,288(a1)
ffffffffc02074e6:	c311                	beqz	a4,ffffffffc02074ea <RR_proc_tick+0x14>
ffffffffc02074e8:	8082                	ret
ffffffffc02074ea:	4785                	li	a5,1
ffffffffc02074ec:	ed9c                	sd	a5,24(a1)
ffffffffc02074ee:	8082                	ret

ffffffffc02074f0 <RR_dequeue>:
ffffffffc02074f0:	1085b783          	ld	a5,264(a1)
ffffffffc02074f4:	00a78363          	beq	a5,a0,ffffffffc02074fa <RR_dequeue+0xa>
ffffffffc02074f8:	8082                	ret
ffffffffc02074fa:	1105b503          	ld	a0,272(a1)
ffffffffc02074fe:	1185b603          	ld	a2,280(a1)
ffffffffc0207502:	4b98                	lw	a4,16(a5)
ffffffffc0207504:	11058693          	addi	a3,a1,272
ffffffffc0207508:	e510                	sd	a2,8(a0)
ffffffffc020750a:	e208                	sd	a0,0(a2)
ffffffffc020750c:	10d5bc23          	sd	a3,280(a1)
ffffffffc0207510:	10d5b823          	sd	a3,272(a1)
ffffffffc0207514:	1005b423          	sd	zero,264(a1)
ffffffffc0207518:	d365                	beqz	a4,ffffffffc02074f8 <RR_dequeue+0x8>
ffffffffc020751a:	377d                	addiw	a4,a4,-1
ffffffffc020751c:	cb98                	sw	a4,16(a5)
ffffffffc020751e:	8082                	ret

ffffffffc0207520 <RR_enqueue>:
ffffffffc0207520:	1085b783          	ld	a5,264(a1)
ffffffffc0207524:	eb8d                	bnez	a5,ffffffffc0207556 <RR_enqueue+0x36>
ffffffffc0207526:	1205a783          	lw	a5,288(a1)
ffffffffc020752a:	4958                	lw	a4,20(a0)
ffffffffc020752c:	00f05463          	blez	a5,ffffffffc0207534 <RR_enqueue+0x14>
ffffffffc0207530:	00f75463          	bge	a4,a5,ffffffffc0207538 <RR_enqueue+0x18>
ffffffffc0207534:	12e5a023          	sw	a4,288(a1)
ffffffffc0207538:	6118                	ld	a4,0(a0)
ffffffffc020753a:	491c                	lw	a5,16(a0)
ffffffffc020753c:	11058693          	addi	a3,a1,272
ffffffffc0207540:	e114                	sd	a3,0(a0)
ffffffffc0207542:	e714                	sd	a3,8(a4)
ffffffffc0207544:	10a5bc23          	sd	a0,280(a1)
ffffffffc0207548:	10e5b823          	sd	a4,272(a1)
ffffffffc020754c:	10a5b423          	sd	a0,264(a1)
ffffffffc0207550:	2785                	addiw	a5,a5,1
ffffffffc0207552:	c91c                	sw	a5,16(a0)
ffffffffc0207554:	8082                	ret
ffffffffc0207556:	1141                	addi	sp,sp,-16
ffffffffc0207558:	00007697          	auipc	a3,0x7
ffffffffc020755c:	96868693          	addi	a3,a3,-1688 # ffffffffc020dec0 <CSWTCH.79+0x5f0>
ffffffffc0207560:	00004617          	auipc	a2,0x4
ffffffffc0207564:	76860613          	addi	a2,a2,1896 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207568:	02900593          	li	a1,41
ffffffffc020756c:	00007517          	auipc	a0,0x7
ffffffffc0207570:	96c50513          	addi	a0,a0,-1684 # ffffffffc020ded8 <CSWTCH.79+0x608>
ffffffffc0207574:	e406                	sd	ra,8(sp)
ffffffffc0207576:	f29f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020757a <sched_init>:
ffffffffc020757a:	1141                	addi	sp,sp,-16
ffffffffc020757c:	0008a717          	auipc	a4,0x8a
ffffffffc0207580:	aa470713          	addi	a4,a4,-1372 # ffffffffc0291020 <default_sched_class>
ffffffffc0207584:	e022                	sd	s0,0(sp)
ffffffffc0207586:	e406                	sd	ra,8(sp)
ffffffffc0207588:	0008e797          	auipc	a5,0x8e
ffffffffc020758c:	26878793          	addi	a5,a5,616 # ffffffffc02957f0 <timer_list>
ffffffffc0207590:	6714                	ld	a3,8(a4)
ffffffffc0207592:	0008e517          	auipc	a0,0x8e
ffffffffc0207596:	23e50513          	addi	a0,a0,574 # ffffffffc02957d0 <__rq>
ffffffffc020759a:	e79c                	sd	a5,8(a5)
ffffffffc020759c:	e39c                	sd	a5,0(a5)
ffffffffc020759e:	4795                	li	a5,5
ffffffffc02075a0:	c95c                	sw	a5,20(a0)
ffffffffc02075a2:	0008f417          	auipc	s0,0x8f
ffffffffc02075a6:	35640413          	addi	s0,s0,854 # ffffffffc02968f8 <sched_class>
ffffffffc02075aa:	0008f797          	auipc	a5,0x8f
ffffffffc02075ae:	34a7b323          	sd	a0,838(a5) # ffffffffc02968f0 <rq>
ffffffffc02075b2:	e018                	sd	a4,0(s0)
ffffffffc02075b4:	9682                	jalr	a3
ffffffffc02075b6:	601c                	ld	a5,0(s0)
ffffffffc02075b8:	6402                	ld	s0,0(sp)
ffffffffc02075ba:	60a2                	ld	ra,8(sp)
ffffffffc02075bc:	638c                	ld	a1,0(a5)
ffffffffc02075be:	00007517          	auipc	a0,0x7
ffffffffc02075c2:	94a50513          	addi	a0,a0,-1718 # ffffffffc020df08 <CSWTCH.79+0x638>
ffffffffc02075c6:	0141                	addi	sp,sp,16
ffffffffc02075c8:	bdff806f          	j	ffffffffc02001a6 <cprintf>

ffffffffc02075cc <wakeup_proc>:
ffffffffc02075cc:	4118                	lw	a4,0(a0)
ffffffffc02075ce:	1101                	addi	sp,sp,-32
ffffffffc02075d0:	ec06                	sd	ra,24(sp)
ffffffffc02075d2:	e822                	sd	s0,16(sp)
ffffffffc02075d4:	e426                	sd	s1,8(sp)
ffffffffc02075d6:	478d                	li	a5,3
ffffffffc02075d8:	08f70363          	beq	a4,a5,ffffffffc020765e <wakeup_proc+0x92>
ffffffffc02075dc:	842a                	mv	s0,a0
ffffffffc02075de:	100027f3          	csrr	a5,sstatus
ffffffffc02075e2:	8b89                	andi	a5,a5,2
ffffffffc02075e4:	4481                	li	s1,0
ffffffffc02075e6:	e7bd                	bnez	a5,ffffffffc0207654 <wakeup_proc+0x88>
ffffffffc02075e8:	4789                	li	a5,2
ffffffffc02075ea:	04f70863          	beq	a4,a5,ffffffffc020763a <wakeup_proc+0x6e>
ffffffffc02075ee:	c01c                	sw	a5,0(s0)
ffffffffc02075f0:	0e042623          	sw	zero,236(s0)
ffffffffc02075f4:	0008f797          	auipc	a5,0x8f
ffffffffc02075f8:	2dc7b783          	ld	a5,732(a5) # ffffffffc02968d0 <current>
ffffffffc02075fc:	02878363          	beq	a5,s0,ffffffffc0207622 <wakeup_proc+0x56>
ffffffffc0207600:	0008f797          	auipc	a5,0x8f
ffffffffc0207604:	2d87b783          	ld	a5,728(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207608:	00f40d63          	beq	s0,a5,ffffffffc0207622 <wakeup_proc+0x56>
ffffffffc020760c:	0008f797          	auipc	a5,0x8f
ffffffffc0207610:	2ec7b783          	ld	a5,748(a5) # ffffffffc02968f8 <sched_class>
ffffffffc0207614:	6b9c                	ld	a5,16(a5)
ffffffffc0207616:	85a2                	mv	a1,s0
ffffffffc0207618:	0008f517          	auipc	a0,0x8f
ffffffffc020761c:	2d853503          	ld	a0,728(a0) # ffffffffc02968f0 <rq>
ffffffffc0207620:	9782                	jalr	a5
ffffffffc0207622:	e491                	bnez	s1,ffffffffc020762e <wakeup_proc+0x62>
ffffffffc0207624:	60e2                	ld	ra,24(sp)
ffffffffc0207626:	6442                	ld	s0,16(sp)
ffffffffc0207628:	64a2                	ld	s1,8(sp)
ffffffffc020762a:	6105                	addi	sp,sp,32
ffffffffc020762c:	8082                	ret
ffffffffc020762e:	6442                	ld	s0,16(sp)
ffffffffc0207630:	60e2                	ld	ra,24(sp)
ffffffffc0207632:	64a2                	ld	s1,8(sp)
ffffffffc0207634:	6105                	addi	sp,sp,32
ffffffffc0207636:	e36f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc020763a:	00007617          	auipc	a2,0x7
ffffffffc020763e:	91e60613          	addi	a2,a2,-1762 # ffffffffc020df58 <CSWTCH.79+0x688>
ffffffffc0207642:	05200593          	li	a1,82
ffffffffc0207646:	00007517          	auipc	a0,0x7
ffffffffc020764a:	8fa50513          	addi	a0,a0,-1798 # ffffffffc020df40 <CSWTCH.79+0x670>
ffffffffc020764e:	eb9f80ef          	jal	ra,ffffffffc0200506 <__warn>
ffffffffc0207652:	bfc1                	j	ffffffffc0207622 <wakeup_proc+0x56>
ffffffffc0207654:	e1ef90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207658:	4018                	lw	a4,0(s0)
ffffffffc020765a:	4485                	li	s1,1
ffffffffc020765c:	b771                	j	ffffffffc02075e8 <wakeup_proc+0x1c>
ffffffffc020765e:	00007697          	auipc	a3,0x7
ffffffffc0207662:	8c268693          	addi	a3,a3,-1854 # ffffffffc020df20 <CSWTCH.79+0x650>
ffffffffc0207666:	00004617          	auipc	a2,0x4
ffffffffc020766a:	66260613          	addi	a2,a2,1634 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020766e:	04300593          	li	a1,67
ffffffffc0207672:	00007517          	auipc	a0,0x7
ffffffffc0207676:	8ce50513          	addi	a0,a0,-1842 # ffffffffc020df40 <CSWTCH.79+0x670>
ffffffffc020767a:	e25f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020767e <schedule>:
ffffffffc020767e:	7179                	addi	sp,sp,-48
ffffffffc0207680:	f406                	sd	ra,40(sp)
ffffffffc0207682:	f022                	sd	s0,32(sp)
ffffffffc0207684:	ec26                	sd	s1,24(sp)
ffffffffc0207686:	e84a                	sd	s2,16(sp)
ffffffffc0207688:	e44e                	sd	s3,8(sp)
ffffffffc020768a:	e052                	sd	s4,0(sp)
ffffffffc020768c:	100027f3          	csrr	a5,sstatus
ffffffffc0207690:	8b89                	andi	a5,a5,2
ffffffffc0207692:	4a01                	li	s4,0
ffffffffc0207694:	e3cd                	bnez	a5,ffffffffc0207736 <schedule+0xb8>
ffffffffc0207696:	0008f497          	auipc	s1,0x8f
ffffffffc020769a:	23a48493          	addi	s1,s1,570 # ffffffffc02968d0 <current>
ffffffffc020769e:	608c                	ld	a1,0(s1)
ffffffffc02076a0:	0008f997          	auipc	s3,0x8f
ffffffffc02076a4:	25898993          	addi	s3,s3,600 # ffffffffc02968f8 <sched_class>
ffffffffc02076a8:	0008f917          	auipc	s2,0x8f
ffffffffc02076ac:	24890913          	addi	s2,s2,584 # ffffffffc02968f0 <rq>
ffffffffc02076b0:	4194                	lw	a3,0(a1)
ffffffffc02076b2:	0005bc23          	sd	zero,24(a1)
ffffffffc02076b6:	4709                	li	a4,2
ffffffffc02076b8:	0009b783          	ld	a5,0(s3)
ffffffffc02076bc:	00093503          	ld	a0,0(s2)
ffffffffc02076c0:	04e68e63          	beq	a3,a4,ffffffffc020771c <schedule+0x9e>
ffffffffc02076c4:	739c                	ld	a5,32(a5)
ffffffffc02076c6:	9782                	jalr	a5
ffffffffc02076c8:	842a                	mv	s0,a0
ffffffffc02076ca:	c521                	beqz	a0,ffffffffc0207712 <schedule+0x94>
ffffffffc02076cc:	0009b783          	ld	a5,0(s3)
ffffffffc02076d0:	00093503          	ld	a0,0(s2)
ffffffffc02076d4:	85a2                	mv	a1,s0
ffffffffc02076d6:	6f9c                	ld	a5,24(a5)
ffffffffc02076d8:	9782                	jalr	a5
ffffffffc02076da:	441c                	lw	a5,8(s0)
ffffffffc02076dc:	6098                	ld	a4,0(s1)
ffffffffc02076de:	2785                	addiw	a5,a5,1
ffffffffc02076e0:	c41c                	sw	a5,8(s0)
ffffffffc02076e2:	00870563          	beq	a4,s0,ffffffffc02076ec <schedule+0x6e>
ffffffffc02076e6:	8522                	mv	a0,s0
ffffffffc02076e8:	e80fe0ef          	jal	ra,ffffffffc0205d68 <proc_run>
ffffffffc02076ec:	000a1a63          	bnez	s4,ffffffffc0207700 <schedule+0x82>
ffffffffc02076f0:	70a2                	ld	ra,40(sp)
ffffffffc02076f2:	7402                	ld	s0,32(sp)
ffffffffc02076f4:	64e2                	ld	s1,24(sp)
ffffffffc02076f6:	6942                	ld	s2,16(sp)
ffffffffc02076f8:	69a2                	ld	s3,8(sp)
ffffffffc02076fa:	6a02                	ld	s4,0(sp)
ffffffffc02076fc:	6145                	addi	sp,sp,48
ffffffffc02076fe:	8082                	ret
ffffffffc0207700:	7402                	ld	s0,32(sp)
ffffffffc0207702:	70a2                	ld	ra,40(sp)
ffffffffc0207704:	64e2                	ld	s1,24(sp)
ffffffffc0207706:	6942                	ld	s2,16(sp)
ffffffffc0207708:	69a2                	ld	s3,8(sp)
ffffffffc020770a:	6a02                	ld	s4,0(sp)
ffffffffc020770c:	6145                	addi	sp,sp,48
ffffffffc020770e:	d5ef906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0207712:	0008f417          	auipc	s0,0x8f
ffffffffc0207716:	1c643403          	ld	s0,454(s0) # ffffffffc02968d8 <idleproc>
ffffffffc020771a:	b7c1                	j	ffffffffc02076da <schedule+0x5c>
ffffffffc020771c:	0008f717          	auipc	a4,0x8f
ffffffffc0207720:	1bc73703          	ld	a4,444(a4) # ffffffffc02968d8 <idleproc>
ffffffffc0207724:	fae580e3          	beq	a1,a4,ffffffffc02076c4 <schedule+0x46>
ffffffffc0207728:	6b9c                	ld	a5,16(a5)
ffffffffc020772a:	9782                	jalr	a5
ffffffffc020772c:	0009b783          	ld	a5,0(s3)
ffffffffc0207730:	00093503          	ld	a0,0(s2)
ffffffffc0207734:	bf41                	j	ffffffffc02076c4 <schedule+0x46>
ffffffffc0207736:	d3cf90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020773a:	4a05                	li	s4,1
ffffffffc020773c:	bfa9                	j	ffffffffc0207696 <schedule+0x18>

ffffffffc020773e <add_timer>:
ffffffffc020773e:	1141                	addi	sp,sp,-16
ffffffffc0207740:	e022                	sd	s0,0(sp)
ffffffffc0207742:	e406                	sd	ra,8(sp)
ffffffffc0207744:	842a                	mv	s0,a0
ffffffffc0207746:	100027f3          	csrr	a5,sstatus
ffffffffc020774a:	8b89                	andi	a5,a5,2
ffffffffc020774c:	4501                	li	a0,0
ffffffffc020774e:	eba5                	bnez	a5,ffffffffc02077be <add_timer+0x80>
ffffffffc0207750:	401c                	lw	a5,0(s0)
ffffffffc0207752:	cbb5                	beqz	a5,ffffffffc02077c6 <add_timer+0x88>
ffffffffc0207754:	6418                	ld	a4,8(s0)
ffffffffc0207756:	cb25                	beqz	a4,ffffffffc02077c6 <add_timer+0x88>
ffffffffc0207758:	6c18                	ld	a4,24(s0)
ffffffffc020775a:	01040593          	addi	a1,s0,16
ffffffffc020775e:	08e59463          	bne	a1,a4,ffffffffc02077e6 <add_timer+0xa8>
ffffffffc0207762:	0008e617          	auipc	a2,0x8e
ffffffffc0207766:	08e60613          	addi	a2,a2,142 # ffffffffc02957f0 <timer_list>
ffffffffc020776a:	6618                	ld	a4,8(a2)
ffffffffc020776c:	00c71863          	bne	a4,a2,ffffffffc020777c <add_timer+0x3e>
ffffffffc0207770:	a80d                	j	ffffffffc02077a2 <add_timer+0x64>
ffffffffc0207772:	6718                	ld	a4,8(a4)
ffffffffc0207774:	9f95                	subw	a5,a5,a3
ffffffffc0207776:	c01c                	sw	a5,0(s0)
ffffffffc0207778:	02c70563          	beq	a4,a2,ffffffffc02077a2 <add_timer+0x64>
ffffffffc020777c:	ff072683          	lw	a3,-16(a4)
ffffffffc0207780:	fed7f9e3          	bgeu	a5,a3,ffffffffc0207772 <add_timer+0x34>
ffffffffc0207784:	40f687bb          	subw	a5,a3,a5
ffffffffc0207788:	fef72823          	sw	a5,-16(a4)
ffffffffc020778c:	631c                	ld	a5,0(a4)
ffffffffc020778e:	e30c                	sd	a1,0(a4)
ffffffffc0207790:	e78c                	sd	a1,8(a5)
ffffffffc0207792:	ec18                	sd	a4,24(s0)
ffffffffc0207794:	e81c                	sd	a5,16(s0)
ffffffffc0207796:	c105                	beqz	a0,ffffffffc02077b6 <add_timer+0x78>
ffffffffc0207798:	6402                	ld	s0,0(sp)
ffffffffc020779a:	60a2                	ld	ra,8(sp)
ffffffffc020779c:	0141                	addi	sp,sp,16
ffffffffc020779e:	ccef906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc02077a2:	0008e717          	auipc	a4,0x8e
ffffffffc02077a6:	04e70713          	addi	a4,a4,78 # ffffffffc02957f0 <timer_list>
ffffffffc02077aa:	631c                	ld	a5,0(a4)
ffffffffc02077ac:	e30c                	sd	a1,0(a4)
ffffffffc02077ae:	e78c                	sd	a1,8(a5)
ffffffffc02077b0:	ec18                	sd	a4,24(s0)
ffffffffc02077b2:	e81c                	sd	a5,16(s0)
ffffffffc02077b4:	f175                	bnez	a0,ffffffffc0207798 <add_timer+0x5a>
ffffffffc02077b6:	60a2                	ld	ra,8(sp)
ffffffffc02077b8:	6402                	ld	s0,0(sp)
ffffffffc02077ba:	0141                	addi	sp,sp,16
ffffffffc02077bc:	8082                	ret
ffffffffc02077be:	cb4f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02077c2:	4505                	li	a0,1
ffffffffc02077c4:	b771                	j	ffffffffc0207750 <add_timer+0x12>
ffffffffc02077c6:	00006697          	auipc	a3,0x6
ffffffffc02077ca:	7b268693          	addi	a3,a3,1970 # ffffffffc020df78 <CSWTCH.79+0x6a8>
ffffffffc02077ce:	00004617          	auipc	a2,0x4
ffffffffc02077d2:	4fa60613          	addi	a2,a2,1274 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02077d6:	07a00593          	li	a1,122
ffffffffc02077da:	00006517          	auipc	a0,0x6
ffffffffc02077de:	76650513          	addi	a0,a0,1894 # ffffffffc020df40 <CSWTCH.79+0x670>
ffffffffc02077e2:	cbdf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02077e6:	00006697          	auipc	a3,0x6
ffffffffc02077ea:	7c268693          	addi	a3,a3,1986 # ffffffffc020dfa8 <CSWTCH.79+0x6d8>
ffffffffc02077ee:	00004617          	auipc	a2,0x4
ffffffffc02077f2:	4da60613          	addi	a2,a2,1242 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02077f6:	07b00593          	li	a1,123
ffffffffc02077fa:	00006517          	auipc	a0,0x6
ffffffffc02077fe:	74650513          	addi	a0,a0,1862 # ffffffffc020df40 <CSWTCH.79+0x670>
ffffffffc0207802:	c9df80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207806 <del_timer>:
ffffffffc0207806:	1101                	addi	sp,sp,-32
ffffffffc0207808:	e822                	sd	s0,16(sp)
ffffffffc020780a:	ec06                	sd	ra,24(sp)
ffffffffc020780c:	e426                	sd	s1,8(sp)
ffffffffc020780e:	842a                	mv	s0,a0
ffffffffc0207810:	100027f3          	csrr	a5,sstatus
ffffffffc0207814:	8b89                	andi	a5,a5,2
ffffffffc0207816:	01050493          	addi	s1,a0,16
ffffffffc020781a:	eb9d                	bnez	a5,ffffffffc0207850 <del_timer+0x4a>
ffffffffc020781c:	6d1c                	ld	a5,24(a0)
ffffffffc020781e:	02978463          	beq	a5,s1,ffffffffc0207846 <del_timer+0x40>
ffffffffc0207822:	4114                	lw	a3,0(a0)
ffffffffc0207824:	6918                	ld	a4,16(a0)
ffffffffc0207826:	ce81                	beqz	a3,ffffffffc020783e <del_timer+0x38>
ffffffffc0207828:	0008e617          	auipc	a2,0x8e
ffffffffc020782c:	fc860613          	addi	a2,a2,-56 # ffffffffc02957f0 <timer_list>
ffffffffc0207830:	00c78763          	beq	a5,a2,ffffffffc020783e <del_timer+0x38>
ffffffffc0207834:	ff07a603          	lw	a2,-16(a5)
ffffffffc0207838:	9eb1                	addw	a3,a3,a2
ffffffffc020783a:	fed7a823          	sw	a3,-16(a5)
ffffffffc020783e:	e71c                	sd	a5,8(a4)
ffffffffc0207840:	e398                	sd	a4,0(a5)
ffffffffc0207842:	ec04                	sd	s1,24(s0)
ffffffffc0207844:	e804                	sd	s1,16(s0)
ffffffffc0207846:	60e2                	ld	ra,24(sp)
ffffffffc0207848:	6442                	ld	s0,16(sp)
ffffffffc020784a:	64a2                	ld	s1,8(sp)
ffffffffc020784c:	6105                	addi	sp,sp,32
ffffffffc020784e:	8082                	ret
ffffffffc0207850:	c22f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207854:	6c1c                	ld	a5,24(s0)
ffffffffc0207856:	02978463          	beq	a5,s1,ffffffffc020787e <del_timer+0x78>
ffffffffc020785a:	4014                	lw	a3,0(s0)
ffffffffc020785c:	6818                	ld	a4,16(s0)
ffffffffc020785e:	ce81                	beqz	a3,ffffffffc0207876 <del_timer+0x70>
ffffffffc0207860:	0008e617          	auipc	a2,0x8e
ffffffffc0207864:	f9060613          	addi	a2,a2,-112 # ffffffffc02957f0 <timer_list>
ffffffffc0207868:	00c78763          	beq	a5,a2,ffffffffc0207876 <del_timer+0x70>
ffffffffc020786c:	ff07a603          	lw	a2,-16(a5)
ffffffffc0207870:	9eb1                	addw	a3,a3,a2
ffffffffc0207872:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207876:	e71c                	sd	a5,8(a4)
ffffffffc0207878:	e398                	sd	a4,0(a5)
ffffffffc020787a:	ec04                	sd	s1,24(s0)
ffffffffc020787c:	e804                	sd	s1,16(s0)
ffffffffc020787e:	6442                	ld	s0,16(sp)
ffffffffc0207880:	60e2                	ld	ra,24(sp)
ffffffffc0207882:	64a2                	ld	s1,8(sp)
ffffffffc0207884:	6105                	addi	sp,sp,32
ffffffffc0207886:	be6f906f          	j	ffffffffc0200c6c <intr_enable>

ffffffffc020788a <run_timer_list>:
ffffffffc020788a:	7139                	addi	sp,sp,-64
ffffffffc020788c:	fc06                	sd	ra,56(sp)
ffffffffc020788e:	f822                	sd	s0,48(sp)
ffffffffc0207890:	f426                	sd	s1,40(sp)
ffffffffc0207892:	f04a                	sd	s2,32(sp)
ffffffffc0207894:	ec4e                	sd	s3,24(sp)
ffffffffc0207896:	e852                	sd	s4,16(sp)
ffffffffc0207898:	e456                	sd	s5,8(sp)
ffffffffc020789a:	e05a                	sd	s6,0(sp)
ffffffffc020789c:	100027f3          	csrr	a5,sstatus
ffffffffc02078a0:	8b89                	andi	a5,a5,2
ffffffffc02078a2:	4b01                	li	s6,0
ffffffffc02078a4:	efe9                	bnez	a5,ffffffffc020797e <run_timer_list+0xf4>
ffffffffc02078a6:	0008e997          	auipc	s3,0x8e
ffffffffc02078aa:	f4a98993          	addi	s3,s3,-182 # ffffffffc02957f0 <timer_list>
ffffffffc02078ae:	0089b403          	ld	s0,8(s3)
ffffffffc02078b2:	07340a63          	beq	s0,s3,ffffffffc0207926 <run_timer_list+0x9c>
ffffffffc02078b6:	ff042783          	lw	a5,-16(s0)
ffffffffc02078ba:	ff040913          	addi	s2,s0,-16
ffffffffc02078be:	0e078763          	beqz	a5,ffffffffc02079ac <run_timer_list+0x122>
ffffffffc02078c2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02078c6:	fee42823          	sw	a4,-16(s0)
ffffffffc02078ca:	ef31                	bnez	a4,ffffffffc0207926 <run_timer_list+0x9c>
ffffffffc02078cc:	00006a97          	auipc	s5,0x6
ffffffffc02078d0:	744a8a93          	addi	s5,s5,1860 # ffffffffc020e010 <CSWTCH.79+0x740>
ffffffffc02078d4:	00006a17          	auipc	s4,0x6
ffffffffc02078d8:	66ca0a13          	addi	s4,s4,1644 # ffffffffc020df40 <CSWTCH.79+0x670>
ffffffffc02078dc:	a005                	j	ffffffffc02078fc <run_timer_list+0x72>
ffffffffc02078de:	0a07d763          	bgez	a5,ffffffffc020798c <run_timer_list+0x102>
ffffffffc02078e2:	8526                	mv	a0,s1
ffffffffc02078e4:	ce9ff0ef          	jal	ra,ffffffffc02075cc <wakeup_proc>
ffffffffc02078e8:	854a                	mv	a0,s2
ffffffffc02078ea:	f1dff0ef          	jal	ra,ffffffffc0207806 <del_timer>
ffffffffc02078ee:	03340c63          	beq	s0,s3,ffffffffc0207926 <run_timer_list+0x9c>
ffffffffc02078f2:	ff042783          	lw	a5,-16(s0)
ffffffffc02078f6:	ff040913          	addi	s2,s0,-16
ffffffffc02078fa:	e795                	bnez	a5,ffffffffc0207926 <run_timer_list+0x9c>
ffffffffc02078fc:	00893483          	ld	s1,8(s2)
ffffffffc0207900:	6400                	ld	s0,8(s0)
ffffffffc0207902:	0ec4a783          	lw	a5,236(s1)
ffffffffc0207906:	ffe1                	bnez	a5,ffffffffc02078de <run_timer_list+0x54>
ffffffffc0207908:	40d4                	lw	a3,4(s1)
ffffffffc020790a:	8656                	mv	a2,s5
ffffffffc020790c:	0ba00593          	li	a1,186
ffffffffc0207910:	8552                	mv	a0,s4
ffffffffc0207912:	bf5f80ef          	jal	ra,ffffffffc0200506 <__warn>
ffffffffc0207916:	8526                	mv	a0,s1
ffffffffc0207918:	cb5ff0ef          	jal	ra,ffffffffc02075cc <wakeup_proc>
ffffffffc020791c:	854a                	mv	a0,s2
ffffffffc020791e:	ee9ff0ef          	jal	ra,ffffffffc0207806 <del_timer>
ffffffffc0207922:	fd3418e3          	bne	s0,s3,ffffffffc02078f2 <run_timer_list+0x68>
ffffffffc0207926:	0008f597          	auipc	a1,0x8f
ffffffffc020792a:	faa5b583          	ld	a1,-86(a1) # ffffffffc02968d0 <current>
ffffffffc020792e:	c18d                	beqz	a1,ffffffffc0207950 <run_timer_list+0xc6>
ffffffffc0207930:	0008f797          	auipc	a5,0x8f
ffffffffc0207934:	fa87b783          	ld	a5,-88(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207938:	04f58763          	beq	a1,a5,ffffffffc0207986 <run_timer_list+0xfc>
ffffffffc020793c:	0008f797          	auipc	a5,0x8f
ffffffffc0207940:	fbc7b783          	ld	a5,-68(a5) # ffffffffc02968f8 <sched_class>
ffffffffc0207944:	779c                	ld	a5,40(a5)
ffffffffc0207946:	0008f517          	auipc	a0,0x8f
ffffffffc020794a:	faa53503          	ld	a0,-86(a0) # ffffffffc02968f0 <rq>
ffffffffc020794e:	9782                	jalr	a5
ffffffffc0207950:	000b1c63          	bnez	s6,ffffffffc0207968 <run_timer_list+0xde>
ffffffffc0207954:	70e2                	ld	ra,56(sp)
ffffffffc0207956:	7442                	ld	s0,48(sp)
ffffffffc0207958:	74a2                	ld	s1,40(sp)
ffffffffc020795a:	7902                	ld	s2,32(sp)
ffffffffc020795c:	69e2                	ld	s3,24(sp)
ffffffffc020795e:	6a42                	ld	s4,16(sp)
ffffffffc0207960:	6aa2                	ld	s5,8(sp)
ffffffffc0207962:	6b02                	ld	s6,0(sp)
ffffffffc0207964:	6121                	addi	sp,sp,64
ffffffffc0207966:	8082                	ret
ffffffffc0207968:	7442                	ld	s0,48(sp)
ffffffffc020796a:	70e2                	ld	ra,56(sp)
ffffffffc020796c:	74a2                	ld	s1,40(sp)
ffffffffc020796e:	7902                	ld	s2,32(sp)
ffffffffc0207970:	69e2                	ld	s3,24(sp)
ffffffffc0207972:	6a42                	ld	s4,16(sp)
ffffffffc0207974:	6aa2                	ld	s5,8(sp)
ffffffffc0207976:	6b02                	ld	s6,0(sp)
ffffffffc0207978:	6121                	addi	sp,sp,64
ffffffffc020797a:	af2f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc020797e:	af4f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207982:	4b05                	li	s6,1
ffffffffc0207984:	b70d                	j	ffffffffc02078a6 <run_timer_list+0x1c>
ffffffffc0207986:	4785                	li	a5,1
ffffffffc0207988:	ed9c                	sd	a5,24(a1)
ffffffffc020798a:	b7d9                	j	ffffffffc0207950 <run_timer_list+0xc6>
ffffffffc020798c:	00006697          	auipc	a3,0x6
ffffffffc0207990:	65c68693          	addi	a3,a3,1628 # ffffffffc020dfe8 <CSWTCH.79+0x718>
ffffffffc0207994:	00004617          	auipc	a2,0x4
ffffffffc0207998:	33460613          	addi	a2,a2,820 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020799c:	0b600593          	li	a1,182
ffffffffc02079a0:	00006517          	auipc	a0,0x6
ffffffffc02079a4:	5a050513          	addi	a0,a0,1440 # ffffffffc020df40 <CSWTCH.79+0x670>
ffffffffc02079a8:	af7f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02079ac:	00006697          	auipc	a3,0x6
ffffffffc02079b0:	62468693          	addi	a3,a3,1572 # ffffffffc020dfd0 <CSWTCH.79+0x700>
ffffffffc02079b4:	00004617          	auipc	a2,0x4
ffffffffc02079b8:	31460613          	addi	a2,a2,788 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02079bc:	0ae00593          	li	a1,174
ffffffffc02079c0:	00006517          	auipc	a0,0x6
ffffffffc02079c4:	58050513          	addi	a0,a0,1408 # ffffffffc020df40 <CSWTCH.79+0x670>
ffffffffc02079c8:	ad7f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02079cc <sys_getpid>:
ffffffffc02079cc:	0008f797          	auipc	a5,0x8f
ffffffffc02079d0:	f047b783          	ld	a5,-252(a5) # ffffffffc02968d0 <current>
ffffffffc02079d4:	43c8                	lw	a0,4(a5)
ffffffffc02079d6:	8082                	ret

ffffffffc02079d8 <sys_pgdir>:
ffffffffc02079d8:	4501                	li	a0,0
ffffffffc02079da:	8082                	ret

ffffffffc02079dc <sys_gettime>:
ffffffffc02079dc:	0008f797          	auipc	a5,0x8f
ffffffffc02079e0:	e947b783          	ld	a5,-364(a5) # ffffffffc0296870 <ticks>
ffffffffc02079e4:	0027951b          	slliw	a0,a5,0x2
ffffffffc02079e8:	9d3d                	addw	a0,a0,a5
ffffffffc02079ea:	0015151b          	slliw	a0,a0,0x1
ffffffffc02079ee:	8082                	ret

ffffffffc02079f0 <sys_lab6_set_priority>:
ffffffffc02079f0:	4108                	lw	a0,0(a0)
ffffffffc02079f2:	1141                	addi	sp,sp,-16
ffffffffc02079f4:	e406                	sd	ra,8(sp)
ffffffffc02079f6:	99bff0ef          	jal	ra,ffffffffc0207390 <lab6_set_priority>
ffffffffc02079fa:	60a2                	ld	ra,8(sp)
ffffffffc02079fc:	4501                	li	a0,0
ffffffffc02079fe:	0141                	addi	sp,sp,16
ffffffffc0207a00:	8082                	ret

ffffffffc0207a02 <sys_dup>:
ffffffffc0207a02:	450c                	lw	a1,8(a0)
ffffffffc0207a04:	4108                	lw	a0,0(a0)
ffffffffc0207a06:	a14fe06f          	j	ffffffffc0205c1a <sysfile_dup>

ffffffffc0207a0a <sys_getdirentry>:
ffffffffc0207a0a:	650c                	ld	a1,8(a0)
ffffffffc0207a0c:	4108                	lw	a0,0(a0)
ffffffffc0207a0e:	91cfe06f          	j	ffffffffc0205b2a <sysfile_getdirentry>

ffffffffc0207a12 <sys_getcwd>:
ffffffffc0207a12:	650c                	ld	a1,8(a0)
ffffffffc0207a14:	6108                	ld	a0,0(a0)
ffffffffc0207a16:	870fe06f          	j	ffffffffc0205a86 <sysfile_getcwd>

ffffffffc0207a1a <sys_fsync>:
ffffffffc0207a1a:	4108                	lw	a0,0(a0)
ffffffffc0207a1c:	866fe06f          	j	ffffffffc0205a82 <sysfile_fsync>

ffffffffc0207a20 <sys_fstat>:
ffffffffc0207a20:	650c                	ld	a1,8(a0)
ffffffffc0207a22:	4108                	lw	a0,0(a0)
ffffffffc0207a24:	fbffd06f          	j	ffffffffc02059e2 <sysfile_fstat>

ffffffffc0207a28 <sys_seek>:
ffffffffc0207a28:	4910                	lw	a2,16(a0)
ffffffffc0207a2a:	650c                	ld	a1,8(a0)
ffffffffc0207a2c:	4108                	lw	a0,0(a0)
ffffffffc0207a2e:	fb1fd06f          	j	ffffffffc02059de <sysfile_seek>

ffffffffc0207a32 <sys_write>:
ffffffffc0207a32:	6910                	ld	a2,16(a0)
ffffffffc0207a34:	650c                	ld	a1,8(a0)
ffffffffc0207a36:	4108                	lw	a0,0(a0)
ffffffffc0207a38:	e8dfd06f          	j	ffffffffc02058c4 <sysfile_write>

ffffffffc0207a3c <sys_read>:
ffffffffc0207a3c:	6910                	ld	a2,16(a0)
ffffffffc0207a3e:	650c                	ld	a1,8(a0)
ffffffffc0207a40:	4108                	lw	a0,0(a0)
ffffffffc0207a42:	d6ffd06f          	j	ffffffffc02057b0 <sysfile_read>

ffffffffc0207a46 <sys_close>:
ffffffffc0207a46:	4108                	lw	a0,0(a0)
ffffffffc0207a48:	d65fd06f          	j	ffffffffc02057ac <sysfile_close>

ffffffffc0207a4c <sys_open>:
ffffffffc0207a4c:	450c                	lw	a1,8(a0)
ffffffffc0207a4e:	6108                	ld	a0,0(a0)
ffffffffc0207a50:	d29fd06f          	j	ffffffffc0205778 <sysfile_open>

ffffffffc0207a54 <sys_putc>:
ffffffffc0207a54:	4108                	lw	a0,0(a0)
ffffffffc0207a56:	1141                	addi	sp,sp,-16
ffffffffc0207a58:	e406                	sd	ra,8(sp)
ffffffffc0207a5a:	f88f80ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0207a5e:	60a2                	ld	ra,8(sp)
ffffffffc0207a60:	4501                	li	a0,0
ffffffffc0207a62:	0141                	addi	sp,sp,16
ffffffffc0207a64:	8082                	ret

ffffffffc0207a66 <sys_kill>:
ffffffffc0207a66:	4108                	lw	a0,0(a0)
ffffffffc0207a68:	ec6ff06f          	j	ffffffffc020712e <do_kill>

ffffffffc0207a6c <sys_sleep>:
ffffffffc0207a6c:	4108                	lw	a0,0(a0)
ffffffffc0207a6e:	95dff06f          	j	ffffffffc02073ca <do_sleep>

ffffffffc0207a72 <sys_yield>:
ffffffffc0207a72:	e6eff06f          	j	ffffffffc02070e0 <do_yield>

ffffffffc0207a76 <sys_exec>:
ffffffffc0207a76:	6910                	ld	a2,16(a0)
ffffffffc0207a78:	450c                	lw	a1,8(a0)
ffffffffc0207a7a:	6108                	ld	a0,0(a0)
ffffffffc0207a7c:	c39fe06f          	j	ffffffffc02066b4 <do_execve>

ffffffffc0207a80 <sys_wait>:
ffffffffc0207a80:	650c                	ld	a1,8(a0)
ffffffffc0207a82:	4108                	lw	a0,0(a0)
ffffffffc0207a84:	e6cff06f          	j	ffffffffc02070f0 <do_wait>

ffffffffc0207a88 <sys_fork>:
ffffffffc0207a88:	0008f797          	auipc	a5,0x8f
ffffffffc0207a8c:	e487b783          	ld	a5,-440(a5) # ffffffffc02968d0 <current>
ffffffffc0207a90:	73d0                	ld	a2,160(a5)
ffffffffc0207a92:	4501                	li	a0,0
ffffffffc0207a94:	6a0c                	ld	a1,16(a2)
ffffffffc0207a96:	b42fe06f          	j	ffffffffc0205dd8 <do_fork>

ffffffffc0207a9a <sys_exit>:
ffffffffc0207a9a:	4108                	lw	a0,0(a0)
ffffffffc0207a9c:	fa8fe06f          	j	ffffffffc0206244 <do_exit>

ffffffffc0207aa0 <syscall>:
ffffffffc0207aa0:	715d                	addi	sp,sp,-80
ffffffffc0207aa2:	fc26                	sd	s1,56(sp)
ffffffffc0207aa4:	0008f497          	auipc	s1,0x8f
ffffffffc0207aa8:	e2c48493          	addi	s1,s1,-468 # ffffffffc02968d0 <current>
ffffffffc0207aac:	6098                	ld	a4,0(s1)
ffffffffc0207aae:	e0a2                	sd	s0,64(sp)
ffffffffc0207ab0:	f84a                	sd	s2,48(sp)
ffffffffc0207ab2:	7340                	ld	s0,160(a4)
ffffffffc0207ab4:	e486                	sd	ra,72(sp)
ffffffffc0207ab6:	0ff00793          	li	a5,255
ffffffffc0207aba:	05042903          	lw	s2,80(s0)
ffffffffc0207abe:	0327ee63          	bltu	a5,s2,ffffffffc0207afa <syscall+0x5a>
ffffffffc0207ac2:	00391713          	slli	a4,s2,0x3
ffffffffc0207ac6:	00006797          	auipc	a5,0x6
ffffffffc0207aca:	5b278793          	addi	a5,a5,1458 # ffffffffc020e078 <syscalls>
ffffffffc0207ace:	97ba                	add	a5,a5,a4
ffffffffc0207ad0:	639c                	ld	a5,0(a5)
ffffffffc0207ad2:	c785                	beqz	a5,ffffffffc0207afa <syscall+0x5a>
ffffffffc0207ad4:	6c28                	ld	a0,88(s0)
ffffffffc0207ad6:	702c                	ld	a1,96(s0)
ffffffffc0207ad8:	7430                	ld	a2,104(s0)
ffffffffc0207ada:	7834                	ld	a3,112(s0)
ffffffffc0207adc:	7c38                	ld	a4,120(s0)
ffffffffc0207ade:	e42a                	sd	a0,8(sp)
ffffffffc0207ae0:	e82e                	sd	a1,16(sp)
ffffffffc0207ae2:	ec32                	sd	a2,24(sp)
ffffffffc0207ae4:	f036                	sd	a3,32(sp)
ffffffffc0207ae6:	f43a                	sd	a4,40(sp)
ffffffffc0207ae8:	0028                	addi	a0,sp,8
ffffffffc0207aea:	9782                	jalr	a5
ffffffffc0207aec:	60a6                	ld	ra,72(sp)
ffffffffc0207aee:	e828                	sd	a0,80(s0)
ffffffffc0207af0:	6406                	ld	s0,64(sp)
ffffffffc0207af2:	74e2                	ld	s1,56(sp)
ffffffffc0207af4:	7942                	ld	s2,48(sp)
ffffffffc0207af6:	6161                	addi	sp,sp,80
ffffffffc0207af8:	8082                	ret
ffffffffc0207afa:	8522                	mv	a0,s0
ffffffffc0207afc:	c8ef90ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc0207b00:	609c                	ld	a5,0(s1)
ffffffffc0207b02:	86ca                	mv	a3,s2
ffffffffc0207b04:	00006617          	auipc	a2,0x6
ffffffffc0207b08:	52c60613          	addi	a2,a2,1324 # ffffffffc020e030 <CSWTCH.79+0x760>
ffffffffc0207b0c:	43d8                	lw	a4,4(a5)
ffffffffc0207b0e:	0d800593          	li	a1,216
ffffffffc0207b12:	0b478793          	addi	a5,a5,180
ffffffffc0207b16:	00006517          	auipc	a0,0x6
ffffffffc0207b1a:	54a50513          	addi	a0,a0,1354 # ffffffffc020e060 <CSWTCH.79+0x790>
ffffffffc0207b1e:	981f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207b22 <__alloc_inode>:
ffffffffc0207b22:	1141                	addi	sp,sp,-16
ffffffffc0207b24:	e022                	sd	s0,0(sp)
ffffffffc0207b26:	842a                	mv	s0,a0
ffffffffc0207b28:	07800513          	li	a0,120
ffffffffc0207b2c:	e406                	sd	ra,8(sp)
ffffffffc0207b2e:	ce4fa0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0207b32:	c111                	beqz	a0,ffffffffc0207b36 <__alloc_inode+0x14>
ffffffffc0207b34:	cd20                	sw	s0,88(a0)
ffffffffc0207b36:	60a2                	ld	ra,8(sp)
ffffffffc0207b38:	6402                	ld	s0,0(sp)
ffffffffc0207b3a:	0141                	addi	sp,sp,16
ffffffffc0207b3c:	8082                	ret

ffffffffc0207b3e <inode_init>:
ffffffffc0207b3e:	4785                	li	a5,1
ffffffffc0207b40:	06052023          	sw	zero,96(a0)
ffffffffc0207b44:	f92c                	sd	a1,112(a0)
ffffffffc0207b46:	f530                	sd	a2,104(a0)
ffffffffc0207b48:	cd7c                	sw	a5,92(a0)
ffffffffc0207b4a:	8082                	ret

ffffffffc0207b4c <inode_kill>:
ffffffffc0207b4c:	4d78                	lw	a4,92(a0)
ffffffffc0207b4e:	1141                	addi	sp,sp,-16
ffffffffc0207b50:	e406                	sd	ra,8(sp)
ffffffffc0207b52:	e719                	bnez	a4,ffffffffc0207b60 <inode_kill+0x14>
ffffffffc0207b54:	513c                	lw	a5,96(a0)
ffffffffc0207b56:	e78d                	bnez	a5,ffffffffc0207b80 <inode_kill+0x34>
ffffffffc0207b58:	60a2                	ld	ra,8(sp)
ffffffffc0207b5a:	0141                	addi	sp,sp,16
ffffffffc0207b5c:	d66fa06f          	j	ffffffffc02020c2 <kfree>
ffffffffc0207b60:	00007697          	auipc	a3,0x7
ffffffffc0207b64:	d1868693          	addi	a3,a3,-744 # ffffffffc020e878 <syscalls+0x800>
ffffffffc0207b68:	00004617          	auipc	a2,0x4
ffffffffc0207b6c:	16060613          	addi	a2,a2,352 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207b70:	02900593          	li	a1,41
ffffffffc0207b74:	00007517          	auipc	a0,0x7
ffffffffc0207b78:	d2450513          	addi	a0,a0,-732 # ffffffffc020e898 <syscalls+0x820>
ffffffffc0207b7c:	923f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207b80:	00007697          	auipc	a3,0x7
ffffffffc0207b84:	d3068693          	addi	a3,a3,-720 # ffffffffc020e8b0 <syscalls+0x838>
ffffffffc0207b88:	00004617          	auipc	a2,0x4
ffffffffc0207b8c:	14060613          	addi	a2,a2,320 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207b90:	02a00593          	li	a1,42
ffffffffc0207b94:	00007517          	auipc	a0,0x7
ffffffffc0207b98:	d0450513          	addi	a0,a0,-764 # ffffffffc020e898 <syscalls+0x820>
ffffffffc0207b9c:	903f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207ba0 <inode_ref_inc>:
ffffffffc0207ba0:	4d7c                	lw	a5,92(a0)
ffffffffc0207ba2:	2785                	addiw	a5,a5,1
ffffffffc0207ba4:	cd7c                	sw	a5,92(a0)
ffffffffc0207ba6:	0007851b          	sext.w	a0,a5
ffffffffc0207baa:	8082                	ret

ffffffffc0207bac <inode_open_inc>:
ffffffffc0207bac:	513c                	lw	a5,96(a0)
ffffffffc0207bae:	2785                	addiw	a5,a5,1
ffffffffc0207bb0:	d13c                	sw	a5,96(a0)
ffffffffc0207bb2:	0007851b          	sext.w	a0,a5
ffffffffc0207bb6:	8082                	ret

ffffffffc0207bb8 <inode_check>:
ffffffffc0207bb8:	1141                	addi	sp,sp,-16
ffffffffc0207bba:	e406                	sd	ra,8(sp)
ffffffffc0207bbc:	c90d                	beqz	a0,ffffffffc0207bee <inode_check+0x36>
ffffffffc0207bbe:	793c                	ld	a5,112(a0)
ffffffffc0207bc0:	c79d                	beqz	a5,ffffffffc0207bee <inode_check+0x36>
ffffffffc0207bc2:	6398                	ld	a4,0(a5)
ffffffffc0207bc4:	4625d7b7          	lui	a5,0x4625d
ffffffffc0207bc8:	0786                	slli	a5,a5,0x1
ffffffffc0207bca:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc0207bce:	08f71063          	bne	a4,a5,ffffffffc0207c4e <inode_check+0x96>
ffffffffc0207bd2:	4d78                	lw	a4,92(a0)
ffffffffc0207bd4:	513c                	lw	a5,96(a0)
ffffffffc0207bd6:	04f74c63          	blt	a4,a5,ffffffffc0207c2e <inode_check+0x76>
ffffffffc0207bda:	0407ca63          	bltz	a5,ffffffffc0207c2e <inode_check+0x76>
ffffffffc0207bde:	66c1                	lui	a3,0x10
ffffffffc0207be0:	02d75763          	bge	a4,a3,ffffffffc0207c0e <inode_check+0x56>
ffffffffc0207be4:	02d7d563          	bge	a5,a3,ffffffffc0207c0e <inode_check+0x56>
ffffffffc0207be8:	60a2                	ld	ra,8(sp)
ffffffffc0207bea:	0141                	addi	sp,sp,16
ffffffffc0207bec:	8082                	ret
ffffffffc0207bee:	00007697          	auipc	a3,0x7
ffffffffc0207bf2:	ce268693          	addi	a3,a3,-798 # ffffffffc020e8d0 <syscalls+0x858>
ffffffffc0207bf6:	00004617          	auipc	a2,0x4
ffffffffc0207bfa:	0d260613          	addi	a2,a2,210 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207bfe:	06e00593          	li	a1,110
ffffffffc0207c02:	00007517          	auipc	a0,0x7
ffffffffc0207c06:	c9650513          	addi	a0,a0,-874 # ffffffffc020e898 <syscalls+0x820>
ffffffffc0207c0a:	895f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207c0e:	00007697          	auipc	a3,0x7
ffffffffc0207c12:	d4268693          	addi	a3,a3,-702 # ffffffffc020e950 <syscalls+0x8d8>
ffffffffc0207c16:	00004617          	auipc	a2,0x4
ffffffffc0207c1a:	0b260613          	addi	a2,a2,178 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207c1e:	07200593          	li	a1,114
ffffffffc0207c22:	00007517          	auipc	a0,0x7
ffffffffc0207c26:	c7650513          	addi	a0,a0,-906 # ffffffffc020e898 <syscalls+0x820>
ffffffffc0207c2a:	875f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207c2e:	00007697          	auipc	a3,0x7
ffffffffc0207c32:	cf268693          	addi	a3,a3,-782 # ffffffffc020e920 <syscalls+0x8a8>
ffffffffc0207c36:	00004617          	auipc	a2,0x4
ffffffffc0207c3a:	09260613          	addi	a2,a2,146 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207c3e:	07100593          	li	a1,113
ffffffffc0207c42:	00007517          	auipc	a0,0x7
ffffffffc0207c46:	c5650513          	addi	a0,a0,-938 # ffffffffc020e898 <syscalls+0x820>
ffffffffc0207c4a:	855f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207c4e:	00007697          	auipc	a3,0x7
ffffffffc0207c52:	caa68693          	addi	a3,a3,-854 # ffffffffc020e8f8 <syscalls+0x880>
ffffffffc0207c56:	00004617          	auipc	a2,0x4
ffffffffc0207c5a:	07260613          	addi	a2,a2,114 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207c5e:	06f00593          	li	a1,111
ffffffffc0207c62:	00007517          	auipc	a0,0x7
ffffffffc0207c66:	c3650513          	addi	a0,a0,-970 # ffffffffc020e898 <syscalls+0x820>
ffffffffc0207c6a:	835f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207c6e <inode_ref_dec>:
ffffffffc0207c6e:	4d7c                	lw	a5,92(a0)
ffffffffc0207c70:	1101                	addi	sp,sp,-32
ffffffffc0207c72:	ec06                	sd	ra,24(sp)
ffffffffc0207c74:	e822                	sd	s0,16(sp)
ffffffffc0207c76:	e426                	sd	s1,8(sp)
ffffffffc0207c78:	e04a                	sd	s2,0(sp)
ffffffffc0207c7a:	06f05e63          	blez	a5,ffffffffc0207cf6 <inode_ref_dec+0x88>
ffffffffc0207c7e:	fff7849b          	addiw	s1,a5,-1
ffffffffc0207c82:	cd64                	sw	s1,92(a0)
ffffffffc0207c84:	842a                	mv	s0,a0
ffffffffc0207c86:	e09d                	bnez	s1,ffffffffc0207cac <inode_ref_dec+0x3e>
ffffffffc0207c88:	793c                	ld	a5,112(a0)
ffffffffc0207c8a:	c7b1                	beqz	a5,ffffffffc0207cd6 <inode_ref_dec+0x68>
ffffffffc0207c8c:	0487b903          	ld	s2,72(a5)
ffffffffc0207c90:	04090363          	beqz	s2,ffffffffc0207cd6 <inode_ref_dec+0x68>
ffffffffc0207c94:	00007597          	auipc	a1,0x7
ffffffffc0207c98:	d6c58593          	addi	a1,a1,-660 # ffffffffc020ea00 <syscalls+0x988>
ffffffffc0207c9c:	f1dff0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0207ca0:	8522                	mv	a0,s0
ffffffffc0207ca2:	9902                	jalr	s2
ffffffffc0207ca4:	c501                	beqz	a0,ffffffffc0207cac <inode_ref_dec+0x3e>
ffffffffc0207ca6:	57c5                	li	a5,-15
ffffffffc0207ca8:	00f51963          	bne	a0,a5,ffffffffc0207cba <inode_ref_dec+0x4c>
ffffffffc0207cac:	60e2                	ld	ra,24(sp)
ffffffffc0207cae:	6442                	ld	s0,16(sp)
ffffffffc0207cb0:	6902                	ld	s2,0(sp)
ffffffffc0207cb2:	8526                	mv	a0,s1
ffffffffc0207cb4:	64a2                	ld	s1,8(sp)
ffffffffc0207cb6:	6105                	addi	sp,sp,32
ffffffffc0207cb8:	8082                	ret
ffffffffc0207cba:	85aa                	mv	a1,a0
ffffffffc0207cbc:	00007517          	auipc	a0,0x7
ffffffffc0207cc0:	d4c50513          	addi	a0,a0,-692 # ffffffffc020ea08 <syscalls+0x990>
ffffffffc0207cc4:	ce2f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207cc8:	60e2                	ld	ra,24(sp)
ffffffffc0207cca:	6442                	ld	s0,16(sp)
ffffffffc0207ccc:	6902                	ld	s2,0(sp)
ffffffffc0207cce:	8526                	mv	a0,s1
ffffffffc0207cd0:	64a2                	ld	s1,8(sp)
ffffffffc0207cd2:	6105                	addi	sp,sp,32
ffffffffc0207cd4:	8082                	ret
ffffffffc0207cd6:	00007697          	auipc	a3,0x7
ffffffffc0207cda:	cda68693          	addi	a3,a3,-806 # ffffffffc020e9b0 <syscalls+0x938>
ffffffffc0207cde:	00004617          	auipc	a2,0x4
ffffffffc0207ce2:	fea60613          	addi	a2,a2,-22 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207ce6:	04400593          	li	a1,68
ffffffffc0207cea:	00007517          	auipc	a0,0x7
ffffffffc0207cee:	bae50513          	addi	a0,a0,-1106 # ffffffffc020e898 <syscalls+0x820>
ffffffffc0207cf2:	facf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207cf6:	00007697          	auipc	a3,0x7
ffffffffc0207cfa:	c9a68693          	addi	a3,a3,-870 # ffffffffc020e990 <syscalls+0x918>
ffffffffc0207cfe:	00004617          	auipc	a2,0x4
ffffffffc0207d02:	fca60613          	addi	a2,a2,-54 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207d06:	03f00593          	li	a1,63
ffffffffc0207d0a:	00007517          	auipc	a0,0x7
ffffffffc0207d0e:	b8e50513          	addi	a0,a0,-1138 # ffffffffc020e898 <syscalls+0x820>
ffffffffc0207d12:	f8cf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207d16 <inode_open_dec>:
ffffffffc0207d16:	513c                	lw	a5,96(a0)
ffffffffc0207d18:	1101                	addi	sp,sp,-32
ffffffffc0207d1a:	ec06                	sd	ra,24(sp)
ffffffffc0207d1c:	e822                	sd	s0,16(sp)
ffffffffc0207d1e:	e426                	sd	s1,8(sp)
ffffffffc0207d20:	e04a                	sd	s2,0(sp)
ffffffffc0207d22:	06f05b63          	blez	a5,ffffffffc0207d98 <inode_open_dec+0x82>
ffffffffc0207d26:	fff7849b          	addiw	s1,a5,-1
ffffffffc0207d2a:	d124                	sw	s1,96(a0)
ffffffffc0207d2c:	842a                	mv	s0,a0
ffffffffc0207d2e:	e085                	bnez	s1,ffffffffc0207d4e <inode_open_dec+0x38>
ffffffffc0207d30:	793c                	ld	a5,112(a0)
ffffffffc0207d32:	c3b9                	beqz	a5,ffffffffc0207d78 <inode_open_dec+0x62>
ffffffffc0207d34:	0107b903          	ld	s2,16(a5)
ffffffffc0207d38:	04090063          	beqz	s2,ffffffffc0207d78 <inode_open_dec+0x62>
ffffffffc0207d3c:	00007597          	auipc	a1,0x7
ffffffffc0207d40:	d5c58593          	addi	a1,a1,-676 # ffffffffc020ea98 <syscalls+0xa20>
ffffffffc0207d44:	e75ff0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0207d48:	8522                	mv	a0,s0
ffffffffc0207d4a:	9902                	jalr	s2
ffffffffc0207d4c:	e901                	bnez	a0,ffffffffc0207d5c <inode_open_dec+0x46>
ffffffffc0207d4e:	60e2                	ld	ra,24(sp)
ffffffffc0207d50:	6442                	ld	s0,16(sp)
ffffffffc0207d52:	6902                	ld	s2,0(sp)
ffffffffc0207d54:	8526                	mv	a0,s1
ffffffffc0207d56:	64a2                	ld	s1,8(sp)
ffffffffc0207d58:	6105                	addi	sp,sp,32
ffffffffc0207d5a:	8082                	ret
ffffffffc0207d5c:	85aa                	mv	a1,a0
ffffffffc0207d5e:	00007517          	auipc	a0,0x7
ffffffffc0207d62:	d4250513          	addi	a0,a0,-702 # ffffffffc020eaa0 <syscalls+0xa28>
ffffffffc0207d66:	c40f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207d6a:	60e2                	ld	ra,24(sp)
ffffffffc0207d6c:	6442                	ld	s0,16(sp)
ffffffffc0207d6e:	6902                	ld	s2,0(sp)
ffffffffc0207d70:	8526                	mv	a0,s1
ffffffffc0207d72:	64a2                	ld	s1,8(sp)
ffffffffc0207d74:	6105                	addi	sp,sp,32
ffffffffc0207d76:	8082                	ret
ffffffffc0207d78:	00007697          	auipc	a3,0x7
ffffffffc0207d7c:	cd068693          	addi	a3,a3,-816 # ffffffffc020ea48 <syscalls+0x9d0>
ffffffffc0207d80:	00004617          	auipc	a2,0x4
ffffffffc0207d84:	f4860613          	addi	a2,a2,-184 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207d88:	06100593          	li	a1,97
ffffffffc0207d8c:	00007517          	auipc	a0,0x7
ffffffffc0207d90:	b0c50513          	addi	a0,a0,-1268 # ffffffffc020e898 <syscalls+0x820>
ffffffffc0207d94:	f0af80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207d98:	00007697          	auipc	a3,0x7
ffffffffc0207d9c:	c9068693          	addi	a3,a3,-880 # ffffffffc020ea28 <syscalls+0x9b0>
ffffffffc0207da0:	00004617          	auipc	a2,0x4
ffffffffc0207da4:	f2860613          	addi	a2,a2,-216 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207da8:	05c00593          	li	a1,92
ffffffffc0207dac:	00007517          	auipc	a0,0x7
ffffffffc0207db0:	aec50513          	addi	a0,a0,-1300 # ffffffffc020e898 <syscalls+0x820>
ffffffffc0207db4:	eeaf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207db8 <__alloc_fs>:
ffffffffc0207db8:	1141                	addi	sp,sp,-16
ffffffffc0207dba:	e022                	sd	s0,0(sp)
ffffffffc0207dbc:	842a                	mv	s0,a0
ffffffffc0207dbe:	0d800513          	li	a0,216
ffffffffc0207dc2:	e406                	sd	ra,8(sp)
ffffffffc0207dc4:	a4efa0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0207dc8:	c119                	beqz	a0,ffffffffc0207dce <__alloc_fs+0x16>
ffffffffc0207dca:	0a852823          	sw	s0,176(a0)
ffffffffc0207dce:	60a2                	ld	ra,8(sp)
ffffffffc0207dd0:	6402                	ld	s0,0(sp)
ffffffffc0207dd2:	0141                	addi	sp,sp,16
ffffffffc0207dd4:	8082                	ret

ffffffffc0207dd6 <vfs_init>:
ffffffffc0207dd6:	1141                	addi	sp,sp,-16
ffffffffc0207dd8:	4585                	li	a1,1
ffffffffc0207dda:	0008e517          	auipc	a0,0x8e
ffffffffc0207dde:	a2650513          	addi	a0,a0,-1498 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207de2:	e406                	sd	ra,8(sp)
ffffffffc0207de4:	9c9fc0ef          	jal	ra,ffffffffc02047ac <sem_init>
ffffffffc0207de8:	60a2                	ld	ra,8(sp)
ffffffffc0207dea:	0141                	addi	sp,sp,16
ffffffffc0207dec:	a40d                	j	ffffffffc020800e <vfs_devlist_init>

ffffffffc0207dee <vfs_set_bootfs>:
ffffffffc0207dee:	7179                	addi	sp,sp,-48
ffffffffc0207df0:	f022                	sd	s0,32(sp)
ffffffffc0207df2:	f406                	sd	ra,40(sp)
ffffffffc0207df4:	ec26                	sd	s1,24(sp)
ffffffffc0207df6:	e402                	sd	zero,8(sp)
ffffffffc0207df8:	842a                	mv	s0,a0
ffffffffc0207dfa:	c915                	beqz	a0,ffffffffc0207e2e <vfs_set_bootfs+0x40>
ffffffffc0207dfc:	03a00593          	li	a1,58
ffffffffc0207e00:	1d1030ef          	jal	ra,ffffffffc020b7d0 <strchr>
ffffffffc0207e04:	c135                	beqz	a0,ffffffffc0207e68 <vfs_set_bootfs+0x7a>
ffffffffc0207e06:	00154783          	lbu	a5,1(a0)
ffffffffc0207e0a:	efb9                	bnez	a5,ffffffffc0207e68 <vfs_set_bootfs+0x7a>
ffffffffc0207e0c:	8522                	mv	a0,s0
ffffffffc0207e0e:	11f000ef          	jal	ra,ffffffffc020872c <vfs_chdir>
ffffffffc0207e12:	842a                	mv	s0,a0
ffffffffc0207e14:	c519                	beqz	a0,ffffffffc0207e22 <vfs_set_bootfs+0x34>
ffffffffc0207e16:	70a2                	ld	ra,40(sp)
ffffffffc0207e18:	8522                	mv	a0,s0
ffffffffc0207e1a:	7402                	ld	s0,32(sp)
ffffffffc0207e1c:	64e2                	ld	s1,24(sp)
ffffffffc0207e1e:	6145                	addi	sp,sp,48
ffffffffc0207e20:	8082                	ret
ffffffffc0207e22:	0028                	addi	a0,sp,8
ffffffffc0207e24:	013000ef          	jal	ra,ffffffffc0208636 <vfs_get_curdir>
ffffffffc0207e28:	842a                	mv	s0,a0
ffffffffc0207e2a:	f575                	bnez	a0,ffffffffc0207e16 <vfs_set_bootfs+0x28>
ffffffffc0207e2c:	6422                	ld	s0,8(sp)
ffffffffc0207e2e:	0008e517          	auipc	a0,0x8e
ffffffffc0207e32:	9d250513          	addi	a0,a0,-1582 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207e36:	981fc0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc0207e3a:	0008f797          	auipc	a5,0x8f
ffffffffc0207e3e:	ac678793          	addi	a5,a5,-1338 # ffffffffc0296900 <bootfs_node>
ffffffffc0207e42:	6384                	ld	s1,0(a5)
ffffffffc0207e44:	0008e517          	auipc	a0,0x8e
ffffffffc0207e48:	9bc50513          	addi	a0,a0,-1604 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207e4c:	e380                	sd	s0,0(a5)
ffffffffc0207e4e:	4401                	li	s0,0
ffffffffc0207e50:	963fc0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0207e54:	d0e9                	beqz	s1,ffffffffc0207e16 <vfs_set_bootfs+0x28>
ffffffffc0207e56:	8526                	mv	a0,s1
ffffffffc0207e58:	e17ff0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc0207e5c:	70a2                	ld	ra,40(sp)
ffffffffc0207e5e:	8522                	mv	a0,s0
ffffffffc0207e60:	7402                	ld	s0,32(sp)
ffffffffc0207e62:	64e2                	ld	s1,24(sp)
ffffffffc0207e64:	6145                	addi	sp,sp,48
ffffffffc0207e66:	8082                	ret
ffffffffc0207e68:	5475                	li	s0,-3
ffffffffc0207e6a:	b775                	j	ffffffffc0207e16 <vfs_set_bootfs+0x28>

ffffffffc0207e6c <vfs_get_bootfs>:
ffffffffc0207e6c:	1101                	addi	sp,sp,-32
ffffffffc0207e6e:	e426                	sd	s1,8(sp)
ffffffffc0207e70:	0008f497          	auipc	s1,0x8f
ffffffffc0207e74:	a9048493          	addi	s1,s1,-1392 # ffffffffc0296900 <bootfs_node>
ffffffffc0207e78:	609c                	ld	a5,0(s1)
ffffffffc0207e7a:	ec06                	sd	ra,24(sp)
ffffffffc0207e7c:	e822                	sd	s0,16(sp)
ffffffffc0207e7e:	c3a1                	beqz	a5,ffffffffc0207ebe <vfs_get_bootfs+0x52>
ffffffffc0207e80:	842a                	mv	s0,a0
ffffffffc0207e82:	0008e517          	auipc	a0,0x8e
ffffffffc0207e86:	97e50513          	addi	a0,a0,-1666 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207e8a:	92dfc0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc0207e8e:	6084                	ld	s1,0(s1)
ffffffffc0207e90:	c08d                	beqz	s1,ffffffffc0207eb2 <vfs_get_bootfs+0x46>
ffffffffc0207e92:	8526                	mv	a0,s1
ffffffffc0207e94:	d0dff0ef          	jal	ra,ffffffffc0207ba0 <inode_ref_inc>
ffffffffc0207e98:	0008e517          	auipc	a0,0x8e
ffffffffc0207e9c:	96850513          	addi	a0,a0,-1688 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207ea0:	913fc0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0207ea4:	4501                	li	a0,0
ffffffffc0207ea6:	e004                	sd	s1,0(s0)
ffffffffc0207ea8:	60e2                	ld	ra,24(sp)
ffffffffc0207eaa:	6442                	ld	s0,16(sp)
ffffffffc0207eac:	64a2                	ld	s1,8(sp)
ffffffffc0207eae:	6105                	addi	sp,sp,32
ffffffffc0207eb0:	8082                	ret
ffffffffc0207eb2:	0008e517          	auipc	a0,0x8e
ffffffffc0207eb6:	94e50513          	addi	a0,a0,-1714 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207eba:	8f9fc0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0207ebe:	5541                	li	a0,-16
ffffffffc0207ec0:	b7e5                	j	ffffffffc0207ea8 <vfs_get_bootfs+0x3c>

ffffffffc0207ec2 <vfs_do_add>:
ffffffffc0207ec2:	7139                	addi	sp,sp,-64
ffffffffc0207ec4:	fc06                	sd	ra,56(sp)
ffffffffc0207ec6:	f822                	sd	s0,48(sp)
ffffffffc0207ec8:	f426                	sd	s1,40(sp)
ffffffffc0207eca:	f04a                	sd	s2,32(sp)
ffffffffc0207ecc:	ec4e                	sd	s3,24(sp)
ffffffffc0207ece:	e852                	sd	s4,16(sp)
ffffffffc0207ed0:	e456                	sd	s5,8(sp)
ffffffffc0207ed2:	e05a                	sd	s6,0(sp)
ffffffffc0207ed4:	0e050b63          	beqz	a0,ffffffffc0207fca <vfs_do_add+0x108>
ffffffffc0207ed8:	842a                	mv	s0,a0
ffffffffc0207eda:	8a2e                	mv	s4,a1
ffffffffc0207edc:	8b32                	mv	s6,a2
ffffffffc0207ede:	8ab6                	mv	s5,a3
ffffffffc0207ee0:	c5cd                	beqz	a1,ffffffffc0207f8a <vfs_do_add+0xc8>
ffffffffc0207ee2:	4db8                	lw	a4,88(a1)
ffffffffc0207ee4:	6785                	lui	a5,0x1
ffffffffc0207ee6:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207eea:	0af71163          	bne	a4,a5,ffffffffc0207f8c <vfs_do_add+0xca>
ffffffffc0207eee:	8522                	mv	a0,s0
ffffffffc0207ef0:	055030ef          	jal	ra,ffffffffc020b744 <strlen>
ffffffffc0207ef4:	47fd                	li	a5,31
ffffffffc0207ef6:	0ca7e663          	bltu	a5,a0,ffffffffc0207fc2 <vfs_do_add+0x100>
ffffffffc0207efa:	8522                	mv	a0,s0
ffffffffc0207efc:	af8f80ef          	jal	ra,ffffffffc02001f4 <strdup>
ffffffffc0207f00:	84aa                	mv	s1,a0
ffffffffc0207f02:	c171                	beqz	a0,ffffffffc0207fc6 <vfs_do_add+0x104>
ffffffffc0207f04:	03000513          	li	a0,48
ffffffffc0207f08:	90afa0ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0207f0c:	89aa                	mv	s3,a0
ffffffffc0207f0e:	c92d                	beqz	a0,ffffffffc0207f80 <vfs_do_add+0xbe>
ffffffffc0207f10:	0008e517          	auipc	a0,0x8e
ffffffffc0207f14:	91850513          	addi	a0,a0,-1768 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207f18:	0008e917          	auipc	s2,0x8e
ffffffffc0207f1c:	90090913          	addi	s2,s2,-1792 # ffffffffc0295818 <vdev_list>
ffffffffc0207f20:	897fc0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc0207f24:	844a                	mv	s0,s2
ffffffffc0207f26:	a039                	j	ffffffffc0207f34 <vfs_do_add+0x72>
ffffffffc0207f28:	fe043503          	ld	a0,-32(s0)
ffffffffc0207f2c:	85a6                	mv	a1,s1
ffffffffc0207f2e:	05f030ef          	jal	ra,ffffffffc020b78c <strcmp>
ffffffffc0207f32:	cd2d                	beqz	a0,ffffffffc0207fac <vfs_do_add+0xea>
ffffffffc0207f34:	6400                	ld	s0,8(s0)
ffffffffc0207f36:	ff2419e3          	bne	s0,s2,ffffffffc0207f28 <vfs_do_add+0x66>
ffffffffc0207f3a:	6418                	ld	a4,8(s0)
ffffffffc0207f3c:	02098793          	addi	a5,s3,32
ffffffffc0207f40:	0099b023          	sd	s1,0(s3)
ffffffffc0207f44:	0149b423          	sd	s4,8(s3)
ffffffffc0207f48:	0159bc23          	sd	s5,24(s3)
ffffffffc0207f4c:	0169b823          	sd	s6,16(s3)
ffffffffc0207f50:	e31c                	sd	a5,0(a4)
ffffffffc0207f52:	0289b023          	sd	s0,32(s3)
ffffffffc0207f56:	02e9b423          	sd	a4,40(s3)
ffffffffc0207f5a:	0008e517          	auipc	a0,0x8e
ffffffffc0207f5e:	8ce50513          	addi	a0,a0,-1842 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207f62:	e41c                	sd	a5,8(s0)
ffffffffc0207f64:	4401                	li	s0,0
ffffffffc0207f66:	84dfc0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0207f6a:	70e2                	ld	ra,56(sp)
ffffffffc0207f6c:	8522                	mv	a0,s0
ffffffffc0207f6e:	7442                	ld	s0,48(sp)
ffffffffc0207f70:	74a2                	ld	s1,40(sp)
ffffffffc0207f72:	7902                	ld	s2,32(sp)
ffffffffc0207f74:	69e2                	ld	s3,24(sp)
ffffffffc0207f76:	6a42                	ld	s4,16(sp)
ffffffffc0207f78:	6aa2                	ld	s5,8(sp)
ffffffffc0207f7a:	6b02                	ld	s6,0(sp)
ffffffffc0207f7c:	6121                	addi	sp,sp,64
ffffffffc0207f7e:	8082                	ret
ffffffffc0207f80:	5471                	li	s0,-4
ffffffffc0207f82:	8526                	mv	a0,s1
ffffffffc0207f84:	93efa0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0207f88:	b7cd                	j	ffffffffc0207f6a <vfs_do_add+0xa8>
ffffffffc0207f8a:	d2b5                	beqz	a3,ffffffffc0207eee <vfs_do_add+0x2c>
ffffffffc0207f8c:	00007697          	auipc	a3,0x7
ffffffffc0207f90:	b5c68693          	addi	a3,a3,-1188 # ffffffffc020eae8 <syscalls+0xa70>
ffffffffc0207f94:	00004617          	auipc	a2,0x4
ffffffffc0207f98:	d3460613          	addi	a2,a2,-716 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207f9c:	08f00593          	li	a1,143
ffffffffc0207fa0:	00007517          	auipc	a0,0x7
ffffffffc0207fa4:	b3050513          	addi	a0,a0,-1232 # ffffffffc020ead0 <syscalls+0xa58>
ffffffffc0207fa8:	cf6f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207fac:	0008e517          	auipc	a0,0x8e
ffffffffc0207fb0:	87c50513          	addi	a0,a0,-1924 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207fb4:	ffefc0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0207fb8:	854e                	mv	a0,s3
ffffffffc0207fba:	908fa0ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0207fbe:	5425                	li	s0,-23
ffffffffc0207fc0:	b7c9                	j	ffffffffc0207f82 <vfs_do_add+0xc0>
ffffffffc0207fc2:	5451                	li	s0,-12
ffffffffc0207fc4:	b75d                	j	ffffffffc0207f6a <vfs_do_add+0xa8>
ffffffffc0207fc6:	5471                	li	s0,-4
ffffffffc0207fc8:	b74d                	j	ffffffffc0207f6a <vfs_do_add+0xa8>
ffffffffc0207fca:	00007697          	auipc	a3,0x7
ffffffffc0207fce:	af668693          	addi	a3,a3,-1290 # ffffffffc020eac0 <syscalls+0xa48>
ffffffffc0207fd2:	00004617          	auipc	a2,0x4
ffffffffc0207fd6:	cf660613          	addi	a2,a2,-778 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207fda:	08e00593          	li	a1,142
ffffffffc0207fde:	00007517          	auipc	a0,0x7
ffffffffc0207fe2:	af250513          	addi	a0,a0,-1294 # ffffffffc020ead0 <syscalls+0xa58>
ffffffffc0207fe6:	cb8f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207fea <find_mount.part.0>:
ffffffffc0207fea:	1141                	addi	sp,sp,-16
ffffffffc0207fec:	00007697          	auipc	a3,0x7
ffffffffc0207ff0:	ad468693          	addi	a3,a3,-1324 # ffffffffc020eac0 <syscalls+0xa48>
ffffffffc0207ff4:	00004617          	auipc	a2,0x4
ffffffffc0207ff8:	cd460613          	addi	a2,a2,-812 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0207ffc:	0cd00593          	li	a1,205
ffffffffc0208000:	00007517          	auipc	a0,0x7
ffffffffc0208004:	ad050513          	addi	a0,a0,-1328 # ffffffffc020ead0 <syscalls+0xa58>
ffffffffc0208008:	e406                	sd	ra,8(sp)
ffffffffc020800a:	c94f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020800e <vfs_devlist_init>:
ffffffffc020800e:	0008e797          	auipc	a5,0x8e
ffffffffc0208012:	80a78793          	addi	a5,a5,-2038 # ffffffffc0295818 <vdev_list>
ffffffffc0208016:	4585                	li	a1,1
ffffffffc0208018:	0008e517          	auipc	a0,0x8e
ffffffffc020801c:	81050513          	addi	a0,a0,-2032 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0208020:	e79c                	sd	a5,8(a5)
ffffffffc0208022:	e39c                	sd	a5,0(a5)
ffffffffc0208024:	f88fc06f          	j	ffffffffc02047ac <sem_init>

ffffffffc0208028 <vfs_cleanup>:
ffffffffc0208028:	1101                	addi	sp,sp,-32
ffffffffc020802a:	e426                	sd	s1,8(sp)
ffffffffc020802c:	0008d497          	auipc	s1,0x8d
ffffffffc0208030:	7ec48493          	addi	s1,s1,2028 # ffffffffc0295818 <vdev_list>
ffffffffc0208034:	649c                	ld	a5,8(s1)
ffffffffc0208036:	ec06                	sd	ra,24(sp)
ffffffffc0208038:	e822                	sd	s0,16(sp)
ffffffffc020803a:	02978e63          	beq	a5,s1,ffffffffc0208076 <vfs_cleanup+0x4e>
ffffffffc020803e:	0008d517          	auipc	a0,0x8d
ffffffffc0208042:	7ea50513          	addi	a0,a0,2026 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0208046:	f70fc0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc020804a:	6480                	ld	s0,8(s1)
ffffffffc020804c:	00940b63          	beq	s0,s1,ffffffffc0208062 <vfs_cleanup+0x3a>
ffffffffc0208050:	ff043783          	ld	a5,-16(s0)
ffffffffc0208054:	853e                	mv	a0,a5
ffffffffc0208056:	c399                	beqz	a5,ffffffffc020805c <vfs_cleanup+0x34>
ffffffffc0208058:	6bfc                	ld	a5,208(a5)
ffffffffc020805a:	9782                	jalr	a5
ffffffffc020805c:	6400                	ld	s0,8(s0)
ffffffffc020805e:	fe9419e3          	bne	s0,s1,ffffffffc0208050 <vfs_cleanup+0x28>
ffffffffc0208062:	6442                	ld	s0,16(sp)
ffffffffc0208064:	60e2                	ld	ra,24(sp)
ffffffffc0208066:	64a2                	ld	s1,8(sp)
ffffffffc0208068:	0008d517          	auipc	a0,0x8d
ffffffffc020806c:	7c050513          	addi	a0,a0,1984 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0208070:	6105                	addi	sp,sp,32
ffffffffc0208072:	f40fc06f          	j	ffffffffc02047b2 <up>
ffffffffc0208076:	60e2                	ld	ra,24(sp)
ffffffffc0208078:	6442                	ld	s0,16(sp)
ffffffffc020807a:	64a2                	ld	s1,8(sp)
ffffffffc020807c:	6105                	addi	sp,sp,32
ffffffffc020807e:	8082                	ret

ffffffffc0208080 <vfs_get_root>:
ffffffffc0208080:	7179                	addi	sp,sp,-48
ffffffffc0208082:	f406                	sd	ra,40(sp)
ffffffffc0208084:	f022                	sd	s0,32(sp)
ffffffffc0208086:	ec26                	sd	s1,24(sp)
ffffffffc0208088:	e84a                	sd	s2,16(sp)
ffffffffc020808a:	e44e                	sd	s3,8(sp)
ffffffffc020808c:	e052                	sd	s4,0(sp)
ffffffffc020808e:	c541                	beqz	a0,ffffffffc0208116 <vfs_get_root+0x96>
ffffffffc0208090:	0008d917          	auipc	s2,0x8d
ffffffffc0208094:	78890913          	addi	s2,s2,1928 # ffffffffc0295818 <vdev_list>
ffffffffc0208098:	00893783          	ld	a5,8(s2)
ffffffffc020809c:	07278b63          	beq	a5,s2,ffffffffc0208112 <vfs_get_root+0x92>
ffffffffc02080a0:	89aa                	mv	s3,a0
ffffffffc02080a2:	0008d517          	auipc	a0,0x8d
ffffffffc02080a6:	78650513          	addi	a0,a0,1926 # ffffffffc0295828 <vdev_list_sem>
ffffffffc02080aa:	8a2e                	mv	s4,a1
ffffffffc02080ac:	844a                	mv	s0,s2
ffffffffc02080ae:	f08fc0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc02080b2:	a801                	j	ffffffffc02080c2 <vfs_get_root+0x42>
ffffffffc02080b4:	fe043583          	ld	a1,-32(s0)
ffffffffc02080b8:	854e                	mv	a0,s3
ffffffffc02080ba:	6d2030ef          	jal	ra,ffffffffc020b78c <strcmp>
ffffffffc02080be:	84aa                	mv	s1,a0
ffffffffc02080c0:	c505                	beqz	a0,ffffffffc02080e8 <vfs_get_root+0x68>
ffffffffc02080c2:	6400                	ld	s0,8(s0)
ffffffffc02080c4:	ff2418e3          	bne	s0,s2,ffffffffc02080b4 <vfs_get_root+0x34>
ffffffffc02080c8:	54cd                	li	s1,-13
ffffffffc02080ca:	0008d517          	auipc	a0,0x8d
ffffffffc02080ce:	75e50513          	addi	a0,a0,1886 # ffffffffc0295828 <vdev_list_sem>
ffffffffc02080d2:	ee0fc0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc02080d6:	70a2                	ld	ra,40(sp)
ffffffffc02080d8:	7402                	ld	s0,32(sp)
ffffffffc02080da:	6942                	ld	s2,16(sp)
ffffffffc02080dc:	69a2                	ld	s3,8(sp)
ffffffffc02080de:	6a02                	ld	s4,0(sp)
ffffffffc02080e0:	8526                	mv	a0,s1
ffffffffc02080e2:	64e2                	ld	s1,24(sp)
ffffffffc02080e4:	6145                	addi	sp,sp,48
ffffffffc02080e6:	8082                	ret
ffffffffc02080e8:	ff043503          	ld	a0,-16(s0)
ffffffffc02080ec:	c519                	beqz	a0,ffffffffc02080fa <vfs_get_root+0x7a>
ffffffffc02080ee:	617c                	ld	a5,192(a0)
ffffffffc02080f0:	9782                	jalr	a5
ffffffffc02080f2:	c519                	beqz	a0,ffffffffc0208100 <vfs_get_root+0x80>
ffffffffc02080f4:	00aa3023          	sd	a0,0(s4)
ffffffffc02080f8:	bfc9                	j	ffffffffc02080ca <vfs_get_root+0x4a>
ffffffffc02080fa:	ff843783          	ld	a5,-8(s0)
ffffffffc02080fe:	c399                	beqz	a5,ffffffffc0208104 <vfs_get_root+0x84>
ffffffffc0208100:	54c9                	li	s1,-14
ffffffffc0208102:	b7e1                	j	ffffffffc02080ca <vfs_get_root+0x4a>
ffffffffc0208104:	fe843503          	ld	a0,-24(s0)
ffffffffc0208108:	a99ff0ef          	jal	ra,ffffffffc0207ba0 <inode_ref_inc>
ffffffffc020810c:	fe843503          	ld	a0,-24(s0)
ffffffffc0208110:	b7cd                	j	ffffffffc02080f2 <vfs_get_root+0x72>
ffffffffc0208112:	54cd                	li	s1,-13
ffffffffc0208114:	b7c9                	j	ffffffffc02080d6 <vfs_get_root+0x56>
ffffffffc0208116:	00007697          	auipc	a3,0x7
ffffffffc020811a:	9aa68693          	addi	a3,a3,-1622 # ffffffffc020eac0 <syscalls+0xa48>
ffffffffc020811e:	00004617          	auipc	a2,0x4
ffffffffc0208122:	baa60613          	addi	a2,a2,-1110 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208126:	04500593          	li	a1,69
ffffffffc020812a:	00007517          	auipc	a0,0x7
ffffffffc020812e:	9a650513          	addi	a0,a0,-1626 # ffffffffc020ead0 <syscalls+0xa58>
ffffffffc0208132:	b6cf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208136 <vfs_get_devname>:
ffffffffc0208136:	0008d697          	auipc	a3,0x8d
ffffffffc020813a:	6e268693          	addi	a3,a3,1762 # ffffffffc0295818 <vdev_list>
ffffffffc020813e:	87b6                	mv	a5,a3
ffffffffc0208140:	e511                	bnez	a0,ffffffffc020814c <vfs_get_devname+0x16>
ffffffffc0208142:	a829                	j	ffffffffc020815c <vfs_get_devname+0x26>
ffffffffc0208144:	ff07b703          	ld	a4,-16(a5)
ffffffffc0208148:	00a70763          	beq	a4,a0,ffffffffc0208156 <vfs_get_devname+0x20>
ffffffffc020814c:	679c                	ld	a5,8(a5)
ffffffffc020814e:	fed79be3          	bne	a5,a3,ffffffffc0208144 <vfs_get_devname+0xe>
ffffffffc0208152:	4501                	li	a0,0
ffffffffc0208154:	8082                	ret
ffffffffc0208156:	fe07b503          	ld	a0,-32(a5)
ffffffffc020815a:	8082                	ret
ffffffffc020815c:	1141                	addi	sp,sp,-16
ffffffffc020815e:	00007697          	auipc	a3,0x7
ffffffffc0208162:	9ea68693          	addi	a3,a3,-1558 # ffffffffc020eb48 <syscalls+0xad0>
ffffffffc0208166:	00004617          	auipc	a2,0x4
ffffffffc020816a:	b6260613          	addi	a2,a2,-1182 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020816e:	06a00593          	li	a1,106
ffffffffc0208172:	00007517          	auipc	a0,0x7
ffffffffc0208176:	95e50513          	addi	a0,a0,-1698 # ffffffffc020ead0 <syscalls+0xa58>
ffffffffc020817a:	e406                	sd	ra,8(sp)
ffffffffc020817c:	b22f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208180 <vfs_add_dev>:
ffffffffc0208180:	86b2                	mv	a3,a2
ffffffffc0208182:	4601                	li	a2,0
ffffffffc0208184:	d3fff06f          	j	ffffffffc0207ec2 <vfs_do_add>

ffffffffc0208188 <vfs_mount>:
ffffffffc0208188:	7179                	addi	sp,sp,-48
ffffffffc020818a:	e84a                	sd	s2,16(sp)
ffffffffc020818c:	892a                	mv	s2,a0
ffffffffc020818e:	0008d517          	auipc	a0,0x8d
ffffffffc0208192:	69a50513          	addi	a0,a0,1690 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0208196:	e44e                	sd	s3,8(sp)
ffffffffc0208198:	f406                	sd	ra,40(sp)
ffffffffc020819a:	f022                	sd	s0,32(sp)
ffffffffc020819c:	ec26                	sd	s1,24(sp)
ffffffffc020819e:	89ae                	mv	s3,a1
ffffffffc02081a0:	e16fc0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc02081a4:	08090a63          	beqz	s2,ffffffffc0208238 <vfs_mount+0xb0>
ffffffffc02081a8:	0008d497          	auipc	s1,0x8d
ffffffffc02081ac:	67048493          	addi	s1,s1,1648 # ffffffffc0295818 <vdev_list>
ffffffffc02081b0:	6480                	ld	s0,8(s1)
ffffffffc02081b2:	00941663          	bne	s0,s1,ffffffffc02081be <vfs_mount+0x36>
ffffffffc02081b6:	a8ad                	j	ffffffffc0208230 <vfs_mount+0xa8>
ffffffffc02081b8:	6400                	ld	s0,8(s0)
ffffffffc02081ba:	06940b63          	beq	s0,s1,ffffffffc0208230 <vfs_mount+0xa8>
ffffffffc02081be:	ff843783          	ld	a5,-8(s0)
ffffffffc02081c2:	dbfd                	beqz	a5,ffffffffc02081b8 <vfs_mount+0x30>
ffffffffc02081c4:	fe043503          	ld	a0,-32(s0)
ffffffffc02081c8:	85ca                	mv	a1,s2
ffffffffc02081ca:	5c2030ef          	jal	ra,ffffffffc020b78c <strcmp>
ffffffffc02081ce:	f56d                	bnez	a0,ffffffffc02081b8 <vfs_mount+0x30>
ffffffffc02081d0:	ff043783          	ld	a5,-16(s0)
ffffffffc02081d4:	e3a5                	bnez	a5,ffffffffc0208234 <vfs_mount+0xac>
ffffffffc02081d6:	fe043783          	ld	a5,-32(s0)
ffffffffc02081da:	c3c9                	beqz	a5,ffffffffc020825c <vfs_mount+0xd4>
ffffffffc02081dc:	ff843783          	ld	a5,-8(s0)
ffffffffc02081e0:	cfb5                	beqz	a5,ffffffffc020825c <vfs_mount+0xd4>
ffffffffc02081e2:	fe843503          	ld	a0,-24(s0)
ffffffffc02081e6:	c939                	beqz	a0,ffffffffc020823c <vfs_mount+0xb4>
ffffffffc02081e8:	4d38                	lw	a4,88(a0)
ffffffffc02081ea:	6785                	lui	a5,0x1
ffffffffc02081ec:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02081f0:	04f71663          	bne	a4,a5,ffffffffc020823c <vfs_mount+0xb4>
ffffffffc02081f4:	ff040593          	addi	a1,s0,-16
ffffffffc02081f8:	9982                	jalr	s3
ffffffffc02081fa:	84aa                	mv	s1,a0
ffffffffc02081fc:	ed01                	bnez	a0,ffffffffc0208214 <vfs_mount+0x8c>
ffffffffc02081fe:	ff043783          	ld	a5,-16(s0)
ffffffffc0208202:	cfad                	beqz	a5,ffffffffc020827c <vfs_mount+0xf4>
ffffffffc0208204:	fe043583          	ld	a1,-32(s0)
ffffffffc0208208:	00007517          	auipc	a0,0x7
ffffffffc020820c:	9d050513          	addi	a0,a0,-1584 # ffffffffc020ebd8 <syscalls+0xb60>
ffffffffc0208210:	f97f70ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0208214:	0008d517          	auipc	a0,0x8d
ffffffffc0208218:	61450513          	addi	a0,a0,1556 # ffffffffc0295828 <vdev_list_sem>
ffffffffc020821c:	d96fc0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0208220:	70a2                	ld	ra,40(sp)
ffffffffc0208222:	7402                	ld	s0,32(sp)
ffffffffc0208224:	6942                	ld	s2,16(sp)
ffffffffc0208226:	69a2                	ld	s3,8(sp)
ffffffffc0208228:	8526                	mv	a0,s1
ffffffffc020822a:	64e2                	ld	s1,24(sp)
ffffffffc020822c:	6145                	addi	sp,sp,48
ffffffffc020822e:	8082                	ret
ffffffffc0208230:	54cd                	li	s1,-13
ffffffffc0208232:	b7cd                	j	ffffffffc0208214 <vfs_mount+0x8c>
ffffffffc0208234:	54c5                	li	s1,-15
ffffffffc0208236:	bff9                	j	ffffffffc0208214 <vfs_mount+0x8c>
ffffffffc0208238:	db3ff0ef          	jal	ra,ffffffffc0207fea <find_mount.part.0>
ffffffffc020823c:	00007697          	auipc	a3,0x7
ffffffffc0208240:	94c68693          	addi	a3,a3,-1716 # ffffffffc020eb88 <syscalls+0xb10>
ffffffffc0208244:	00004617          	auipc	a2,0x4
ffffffffc0208248:	a8460613          	addi	a2,a2,-1404 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020824c:	0ed00593          	li	a1,237
ffffffffc0208250:	00007517          	auipc	a0,0x7
ffffffffc0208254:	88050513          	addi	a0,a0,-1920 # ffffffffc020ead0 <syscalls+0xa58>
ffffffffc0208258:	a46f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020825c:	00007697          	auipc	a3,0x7
ffffffffc0208260:	8fc68693          	addi	a3,a3,-1796 # ffffffffc020eb58 <syscalls+0xae0>
ffffffffc0208264:	00004617          	auipc	a2,0x4
ffffffffc0208268:	a6460613          	addi	a2,a2,-1436 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020826c:	0eb00593          	li	a1,235
ffffffffc0208270:	00007517          	auipc	a0,0x7
ffffffffc0208274:	86050513          	addi	a0,a0,-1952 # ffffffffc020ead0 <syscalls+0xa58>
ffffffffc0208278:	a26f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020827c:	00007697          	auipc	a3,0x7
ffffffffc0208280:	94468693          	addi	a3,a3,-1724 # ffffffffc020ebc0 <syscalls+0xb48>
ffffffffc0208284:	00004617          	auipc	a2,0x4
ffffffffc0208288:	a4460613          	addi	a2,a2,-1468 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020828c:	0ef00593          	li	a1,239
ffffffffc0208290:	00007517          	auipc	a0,0x7
ffffffffc0208294:	84050513          	addi	a0,a0,-1984 # ffffffffc020ead0 <syscalls+0xa58>
ffffffffc0208298:	a06f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020829c <vfs_open>:
ffffffffc020829c:	711d                	addi	sp,sp,-96
ffffffffc020829e:	e4a6                	sd	s1,72(sp)
ffffffffc02082a0:	e0ca                	sd	s2,64(sp)
ffffffffc02082a2:	fc4e                	sd	s3,56(sp)
ffffffffc02082a4:	ec86                	sd	ra,88(sp)
ffffffffc02082a6:	e8a2                	sd	s0,80(sp)
ffffffffc02082a8:	f852                	sd	s4,48(sp)
ffffffffc02082aa:	f456                	sd	s5,40(sp)
ffffffffc02082ac:	0035f793          	andi	a5,a1,3
ffffffffc02082b0:	84ae                	mv	s1,a1
ffffffffc02082b2:	892a                	mv	s2,a0
ffffffffc02082b4:	89b2                	mv	s3,a2
ffffffffc02082b6:	0e078663          	beqz	a5,ffffffffc02083a2 <vfs_open+0x106>
ffffffffc02082ba:	470d                	li	a4,3
ffffffffc02082bc:	0105fa93          	andi	s5,a1,16
ffffffffc02082c0:	0ce78f63          	beq	a5,a4,ffffffffc020839e <vfs_open+0x102>
ffffffffc02082c4:	002c                	addi	a1,sp,8
ffffffffc02082c6:	854a                	mv	a0,s2
ffffffffc02082c8:	2ae000ef          	jal	ra,ffffffffc0208576 <vfs_lookup>
ffffffffc02082cc:	842a                	mv	s0,a0
ffffffffc02082ce:	0044fa13          	andi	s4,s1,4
ffffffffc02082d2:	e159                	bnez	a0,ffffffffc0208358 <vfs_open+0xbc>
ffffffffc02082d4:	00c4f793          	andi	a5,s1,12
ffffffffc02082d8:	4731                	li	a4,12
ffffffffc02082da:	0ee78263          	beq	a5,a4,ffffffffc02083be <vfs_open+0x122>
ffffffffc02082de:	6422                	ld	s0,8(sp)
ffffffffc02082e0:	12040163          	beqz	s0,ffffffffc0208402 <vfs_open+0x166>
ffffffffc02082e4:	783c                	ld	a5,112(s0)
ffffffffc02082e6:	cff1                	beqz	a5,ffffffffc02083c2 <vfs_open+0x126>
ffffffffc02082e8:	679c                	ld	a5,8(a5)
ffffffffc02082ea:	cfe1                	beqz	a5,ffffffffc02083c2 <vfs_open+0x126>
ffffffffc02082ec:	8522                	mv	a0,s0
ffffffffc02082ee:	00007597          	auipc	a1,0x7
ffffffffc02082f2:	9ca58593          	addi	a1,a1,-1590 # ffffffffc020ecb8 <syscalls+0xc40>
ffffffffc02082f6:	8c3ff0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc02082fa:	783c                	ld	a5,112(s0)
ffffffffc02082fc:	6522                	ld	a0,8(sp)
ffffffffc02082fe:	85a6                	mv	a1,s1
ffffffffc0208300:	679c                	ld	a5,8(a5)
ffffffffc0208302:	9782                	jalr	a5
ffffffffc0208304:	842a                	mv	s0,a0
ffffffffc0208306:	6522                	ld	a0,8(sp)
ffffffffc0208308:	e845                	bnez	s0,ffffffffc02083b8 <vfs_open+0x11c>
ffffffffc020830a:	015a6a33          	or	s4,s4,s5
ffffffffc020830e:	89fff0ef          	jal	ra,ffffffffc0207bac <inode_open_inc>
ffffffffc0208312:	020a0663          	beqz	s4,ffffffffc020833e <vfs_open+0xa2>
ffffffffc0208316:	64a2                	ld	s1,8(sp)
ffffffffc0208318:	c4e9                	beqz	s1,ffffffffc02083e2 <vfs_open+0x146>
ffffffffc020831a:	78bc                	ld	a5,112(s1)
ffffffffc020831c:	c3f9                	beqz	a5,ffffffffc02083e2 <vfs_open+0x146>
ffffffffc020831e:	73bc                	ld	a5,96(a5)
ffffffffc0208320:	c3e9                	beqz	a5,ffffffffc02083e2 <vfs_open+0x146>
ffffffffc0208322:	00007597          	auipc	a1,0x7
ffffffffc0208326:	9f658593          	addi	a1,a1,-1546 # ffffffffc020ed18 <syscalls+0xca0>
ffffffffc020832a:	8526                	mv	a0,s1
ffffffffc020832c:	88dff0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0208330:	78bc                	ld	a5,112(s1)
ffffffffc0208332:	6522                	ld	a0,8(sp)
ffffffffc0208334:	4581                	li	a1,0
ffffffffc0208336:	73bc                	ld	a5,96(a5)
ffffffffc0208338:	9782                	jalr	a5
ffffffffc020833a:	87aa                	mv	a5,a0
ffffffffc020833c:	e92d                	bnez	a0,ffffffffc02083ae <vfs_open+0x112>
ffffffffc020833e:	67a2                	ld	a5,8(sp)
ffffffffc0208340:	00f9b023          	sd	a5,0(s3)
ffffffffc0208344:	60e6                	ld	ra,88(sp)
ffffffffc0208346:	8522                	mv	a0,s0
ffffffffc0208348:	6446                	ld	s0,80(sp)
ffffffffc020834a:	64a6                	ld	s1,72(sp)
ffffffffc020834c:	6906                	ld	s2,64(sp)
ffffffffc020834e:	79e2                	ld	s3,56(sp)
ffffffffc0208350:	7a42                	ld	s4,48(sp)
ffffffffc0208352:	7aa2                	ld	s5,40(sp)
ffffffffc0208354:	6125                	addi	sp,sp,96
ffffffffc0208356:	8082                	ret
ffffffffc0208358:	57c1                	li	a5,-16
ffffffffc020835a:	fef515e3          	bne	a0,a5,ffffffffc0208344 <vfs_open+0xa8>
ffffffffc020835e:	fe0a03e3          	beqz	s4,ffffffffc0208344 <vfs_open+0xa8>
ffffffffc0208362:	0810                	addi	a2,sp,16
ffffffffc0208364:	082c                	addi	a1,sp,24
ffffffffc0208366:	854a                	mv	a0,s2
ffffffffc0208368:	2a4000ef          	jal	ra,ffffffffc020860c <vfs_lookup_parent>
ffffffffc020836c:	842a                	mv	s0,a0
ffffffffc020836e:	f979                	bnez	a0,ffffffffc0208344 <vfs_open+0xa8>
ffffffffc0208370:	6462                	ld	s0,24(sp)
ffffffffc0208372:	c845                	beqz	s0,ffffffffc0208422 <vfs_open+0x186>
ffffffffc0208374:	783c                	ld	a5,112(s0)
ffffffffc0208376:	c7d5                	beqz	a5,ffffffffc0208422 <vfs_open+0x186>
ffffffffc0208378:	77bc                	ld	a5,104(a5)
ffffffffc020837a:	c7c5                	beqz	a5,ffffffffc0208422 <vfs_open+0x186>
ffffffffc020837c:	8522                	mv	a0,s0
ffffffffc020837e:	00007597          	auipc	a1,0x7
ffffffffc0208382:	8d258593          	addi	a1,a1,-1838 # ffffffffc020ec50 <syscalls+0xbd8>
ffffffffc0208386:	833ff0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc020838a:	783c                	ld	a5,112(s0)
ffffffffc020838c:	65c2                	ld	a1,16(sp)
ffffffffc020838e:	6562                	ld	a0,24(sp)
ffffffffc0208390:	77bc                	ld	a5,104(a5)
ffffffffc0208392:	4034d613          	srai	a2,s1,0x3
ffffffffc0208396:	0034                	addi	a3,sp,8
ffffffffc0208398:	8a05                	andi	a2,a2,1
ffffffffc020839a:	9782                	jalr	a5
ffffffffc020839c:	b789                	j	ffffffffc02082de <vfs_open+0x42>
ffffffffc020839e:	5475                	li	s0,-3
ffffffffc02083a0:	b755                	j	ffffffffc0208344 <vfs_open+0xa8>
ffffffffc02083a2:	0105fa93          	andi	s5,a1,16
ffffffffc02083a6:	5475                	li	s0,-3
ffffffffc02083a8:	f80a9ee3          	bnez	s5,ffffffffc0208344 <vfs_open+0xa8>
ffffffffc02083ac:	bf21                	j	ffffffffc02082c4 <vfs_open+0x28>
ffffffffc02083ae:	6522                	ld	a0,8(sp)
ffffffffc02083b0:	843e                	mv	s0,a5
ffffffffc02083b2:	965ff0ef          	jal	ra,ffffffffc0207d16 <inode_open_dec>
ffffffffc02083b6:	6522                	ld	a0,8(sp)
ffffffffc02083b8:	8b7ff0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc02083bc:	b761                	j	ffffffffc0208344 <vfs_open+0xa8>
ffffffffc02083be:	5425                	li	s0,-23
ffffffffc02083c0:	b751                	j	ffffffffc0208344 <vfs_open+0xa8>
ffffffffc02083c2:	00007697          	auipc	a3,0x7
ffffffffc02083c6:	8a668693          	addi	a3,a3,-1882 # ffffffffc020ec68 <syscalls+0xbf0>
ffffffffc02083ca:	00004617          	auipc	a2,0x4
ffffffffc02083ce:	8fe60613          	addi	a2,a2,-1794 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02083d2:	03300593          	li	a1,51
ffffffffc02083d6:	00007517          	auipc	a0,0x7
ffffffffc02083da:	86250513          	addi	a0,a0,-1950 # ffffffffc020ec38 <syscalls+0xbc0>
ffffffffc02083de:	8c0f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02083e2:	00007697          	auipc	a3,0x7
ffffffffc02083e6:	8de68693          	addi	a3,a3,-1826 # ffffffffc020ecc0 <syscalls+0xc48>
ffffffffc02083ea:	00004617          	auipc	a2,0x4
ffffffffc02083ee:	8de60613          	addi	a2,a2,-1826 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02083f2:	03a00593          	li	a1,58
ffffffffc02083f6:	00007517          	auipc	a0,0x7
ffffffffc02083fa:	84250513          	addi	a0,a0,-1982 # ffffffffc020ec38 <syscalls+0xbc0>
ffffffffc02083fe:	8a0f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208402:	00007697          	auipc	a3,0x7
ffffffffc0208406:	85668693          	addi	a3,a3,-1962 # ffffffffc020ec58 <syscalls+0xbe0>
ffffffffc020840a:	00004617          	auipc	a2,0x4
ffffffffc020840e:	8be60613          	addi	a2,a2,-1858 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208412:	03100593          	li	a1,49
ffffffffc0208416:	00007517          	auipc	a0,0x7
ffffffffc020841a:	82250513          	addi	a0,a0,-2014 # ffffffffc020ec38 <syscalls+0xbc0>
ffffffffc020841e:	880f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208422:	00006697          	auipc	a3,0x6
ffffffffc0208426:	7c668693          	addi	a3,a3,1990 # ffffffffc020ebe8 <syscalls+0xb70>
ffffffffc020842a:	00004617          	auipc	a2,0x4
ffffffffc020842e:	89e60613          	addi	a2,a2,-1890 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208432:	02c00593          	li	a1,44
ffffffffc0208436:	00007517          	auipc	a0,0x7
ffffffffc020843a:	80250513          	addi	a0,a0,-2046 # ffffffffc020ec38 <syscalls+0xbc0>
ffffffffc020843e:	860f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208442 <vfs_close>:
ffffffffc0208442:	1141                	addi	sp,sp,-16
ffffffffc0208444:	e406                	sd	ra,8(sp)
ffffffffc0208446:	e022                	sd	s0,0(sp)
ffffffffc0208448:	842a                	mv	s0,a0
ffffffffc020844a:	8cdff0ef          	jal	ra,ffffffffc0207d16 <inode_open_dec>
ffffffffc020844e:	8522                	mv	a0,s0
ffffffffc0208450:	81fff0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc0208454:	60a2                	ld	ra,8(sp)
ffffffffc0208456:	6402                	ld	s0,0(sp)
ffffffffc0208458:	4501                	li	a0,0
ffffffffc020845a:	0141                	addi	sp,sp,16
ffffffffc020845c:	8082                	ret

ffffffffc020845e <get_device>:
ffffffffc020845e:	7179                	addi	sp,sp,-48
ffffffffc0208460:	ec26                	sd	s1,24(sp)
ffffffffc0208462:	e84a                	sd	s2,16(sp)
ffffffffc0208464:	f406                	sd	ra,40(sp)
ffffffffc0208466:	f022                	sd	s0,32(sp)
ffffffffc0208468:	00054303          	lbu	t1,0(a0)
ffffffffc020846c:	892e                	mv	s2,a1
ffffffffc020846e:	84b2                	mv	s1,a2
ffffffffc0208470:	02030463          	beqz	t1,ffffffffc0208498 <get_device+0x3a>
ffffffffc0208474:	00150413          	addi	s0,a0,1
ffffffffc0208478:	86a2                	mv	a3,s0
ffffffffc020847a:	879a                	mv	a5,t1
ffffffffc020847c:	4701                	li	a4,0
ffffffffc020847e:	03a00813          	li	a6,58
ffffffffc0208482:	02f00893          	li	a7,47
ffffffffc0208486:	03078263          	beq	a5,a6,ffffffffc02084aa <get_device+0x4c>
ffffffffc020848a:	05178963          	beq	a5,a7,ffffffffc02084dc <get_device+0x7e>
ffffffffc020848e:	0006c783          	lbu	a5,0(a3)
ffffffffc0208492:	2705                	addiw	a4,a4,1
ffffffffc0208494:	0685                	addi	a3,a3,1
ffffffffc0208496:	fbe5                	bnez	a5,ffffffffc0208486 <get_device+0x28>
ffffffffc0208498:	7402                	ld	s0,32(sp)
ffffffffc020849a:	00a93023          	sd	a0,0(s2)
ffffffffc020849e:	70a2                	ld	ra,40(sp)
ffffffffc02084a0:	6942                	ld	s2,16(sp)
ffffffffc02084a2:	8526                	mv	a0,s1
ffffffffc02084a4:	64e2                	ld	s1,24(sp)
ffffffffc02084a6:	6145                	addi	sp,sp,48
ffffffffc02084a8:	a279                	j	ffffffffc0208636 <vfs_get_curdir>
ffffffffc02084aa:	cb15                	beqz	a4,ffffffffc02084de <get_device+0x80>
ffffffffc02084ac:	00e507b3          	add	a5,a0,a4
ffffffffc02084b0:	0705                	addi	a4,a4,1
ffffffffc02084b2:	00078023          	sb	zero,0(a5)
ffffffffc02084b6:	972a                	add	a4,a4,a0
ffffffffc02084b8:	02f00613          	li	a2,47
ffffffffc02084bc:	00074783          	lbu	a5,0(a4)
ffffffffc02084c0:	86ba                	mv	a3,a4
ffffffffc02084c2:	0705                	addi	a4,a4,1
ffffffffc02084c4:	fec78ce3          	beq	a5,a2,ffffffffc02084bc <get_device+0x5e>
ffffffffc02084c8:	7402                	ld	s0,32(sp)
ffffffffc02084ca:	70a2                	ld	ra,40(sp)
ffffffffc02084cc:	00d93023          	sd	a3,0(s2)
ffffffffc02084d0:	85a6                	mv	a1,s1
ffffffffc02084d2:	6942                	ld	s2,16(sp)
ffffffffc02084d4:	64e2                	ld	s1,24(sp)
ffffffffc02084d6:	6145                	addi	sp,sp,48
ffffffffc02084d8:	ba9ff06f          	j	ffffffffc0208080 <vfs_get_root>
ffffffffc02084dc:	ff55                	bnez	a4,ffffffffc0208498 <get_device+0x3a>
ffffffffc02084de:	02f00793          	li	a5,47
ffffffffc02084e2:	04f30563          	beq	t1,a5,ffffffffc020852c <get_device+0xce>
ffffffffc02084e6:	03a00793          	li	a5,58
ffffffffc02084ea:	06f31663          	bne	t1,a5,ffffffffc0208556 <get_device+0xf8>
ffffffffc02084ee:	0028                	addi	a0,sp,8
ffffffffc02084f0:	146000ef          	jal	ra,ffffffffc0208636 <vfs_get_curdir>
ffffffffc02084f4:	e515                	bnez	a0,ffffffffc0208520 <get_device+0xc2>
ffffffffc02084f6:	67a2                	ld	a5,8(sp)
ffffffffc02084f8:	77a8                	ld	a0,104(a5)
ffffffffc02084fa:	cd15                	beqz	a0,ffffffffc0208536 <get_device+0xd8>
ffffffffc02084fc:	617c                	ld	a5,192(a0)
ffffffffc02084fe:	9782                	jalr	a5
ffffffffc0208500:	87aa                	mv	a5,a0
ffffffffc0208502:	6522                	ld	a0,8(sp)
ffffffffc0208504:	e09c                	sd	a5,0(s1)
ffffffffc0208506:	f68ff0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc020850a:	02f00713          	li	a4,47
ffffffffc020850e:	a011                	j	ffffffffc0208512 <get_device+0xb4>
ffffffffc0208510:	0405                	addi	s0,s0,1
ffffffffc0208512:	00044783          	lbu	a5,0(s0)
ffffffffc0208516:	fee78de3          	beq	a5,a4,ffffffffc0208510 <get_device+0xb2>
ffffffffc020851a:	00893023          	sd	s0,0(s2)
ffffffffc020851e:	4501                	li	a0,0
ffffffffc0208520:	70a2                	ld	ra,40(sp)
ffffffffc0208522:	7402                	ld	s0,32(sp)
ffffffffc0208524:	64e2                	ld	s1,24(sp)
ffffffffc0208526:	6942                	ld	s2,16(sp)
ffffffffc0208528:	6145                	addi	sp,sp,48
ffffffffc020852a:	8082                	ret
ffffffffc020852c:	8526                	mv	a0,s1
ffffffffc020852e:	93fff0ef          	jal	ra,ffffffffc0207e6c <vfs_get_bootfs>
ffffffffc0208532:	dd61                	beqz	a0,ffffffffc020850a <get_device+0xac>
ffffffffc0208534:	b7f5                	j	ffffffffc0208520 <get_device+0xc2>
ffffffffc0208536:	00007697          	auipc	a3,0x7
ffffffffc020853a:	81a68693          	addi	a3,a3,-2022 # ffffffffc020ed50 <syscalls+0xcd8>
ffffffffc020853e:	00003617          	auipc	a2,0x3
ffffffffc0208542:	78a60613          	addi	a2,a2,1930 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208546:	03900593          	li	a1,57
ffffffffc020854a:	00006517          	auipc	a0,0x6
ffffffffc020854e:	7ee50513          	addi	a0,a0,2030 # ffffffffc020ed38 <syscalls+0xcc0>
ffffffffc0208552:	f4df70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208556:	00006697          	auipc	a3,0x6
ffffffffc020855a:	7d268693          	addi	a3,a3,2002 # ffffffffc020ed28 <syscalls+0xcb0>
ffffffffc020855e:	00003617          	auipc	a2,0x3
ffffffffc0208562:	76a60613          	addi	a2,a2,1898 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208566:	03300593          	li	a1,51
ffffffffc020856a:	00006517          	auipc	a0,0x6
ffffffffc020856e:	7ce50513          	addi	a0,a0,1998 # ffffffffc020ed38 <syscalls+0xcc0>
ffffffffc0208572:	f2df70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208576 <vfs_lookup>:
ffffffffc0208576:	7139                	addi	sp,sp,-64
ffffffffc0208578:	f426                	sd	s1,40(sp)
ffffffffc020857a:	0830                	addi	a2,sp,24
ffffffffc020857c:	84ae                	mv	s1,a1
ffffffffc020857e:	002c                	addi	a1,sp,8
ffffffffc0208580:	f822                	sd	s0,48(sp)
ffffffffc0208582:	fc06                	sd	ra,56(sp)
ffffffffc0208584:	f04a                	sd	s2,32(sp)
ffffffffc0208586:	e42a                	sd	a0,8(sp)
ffffffffc0208588:	ed7ff0ef          	jal	ra,ffffffffc020845e <get_device>
ffffffffc020858c:	842a                	mv	s0,a0
ffffffffc020858e:	ed1d                	bnez	a0,ffffffffc02085cc <vfs_lookup+0x56>
ffffffffc0208590:	67a2                	ld	a5,8(sp)
ffffffffc0208592:	6962                	ld	s2,24(sp)
ffffffffc0208594:	0007c783          	lbu	a5,0(a5)
ffffffffc0208598:	c3a9                	beqz	a5,ffffffffc02085da <vfs_lookup+0x64>
ffffffffc020859a:	04090963          	beqz	s2,ffffffffc02085ec <vfs_lookup+0x76>
ffffffffc020859e:	07093783          	ld	a5,112(s2)
ffffffffc02085a2:	c7a9                	beqz	a5,ffffffffc02085ec <vfs_lookup+0x76>
ffffffffc02085a4:	7bbc                	ld	a5,112(a5)
ffffffffc02085a6:	c3b9                	beqz	a5,ffffffffc02085ec <vfs_lookup+0x76>
ffffffffc02085a8:	854a                	mv	a0,s2
ffffffffc02085aa:	00007597          	auipc	a1,0x7
ffffffffc02085ae:	80e58593          	addi	a1,a1,-2034 # ffffffffc020edb8 <syscalls+0xd40>
ffffffffc02085b2:	e06ff0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc02085b6:	07093783          	ld	a5,112(s2)
ffffffffc02085ba:	65a2                	ld	a1,8(sp)
ffffffffc02085bc:	6562                	ld	a0,24(sp)
ffffffffc02085be:	7bbc                	ld	a5,112(a5)
ffffffffc02085c0:	8626                	mv	a2,s1
ffffffffc02085c2:	9782                	jalr	a5
ffffffffc02085c4:	842a                	mv	s0,a0
ffffffffc02085c6:	6562                	ld	a0,24(sp)
ffffffffc02085c8:	ea6ff0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc02085cc:	70e2                	ld	ra,56(sp)
ffffffffc02085ce:	8522                	mv	a0,s0
ffffffffc02085d0:	7442                	ld	s0,48(sp)
ffffffffc02085d2:	74a2                	ld	s1,40(sp)
ffffffffc02085d4:	7902                	ld	s2,32(sp)
ffffffffc02085d6:	6121                	addi	sp,sp,64
ffffffffc02085d8:	8082                	ret
ffffffffc02085da:	70e2                	ld	ra,56(sp)
ffffffffc02085dc:	8522                	mv	a0,s0
ffffffffc02085de:	7442                	ld	s0,48(sp)
ffffffffc02085e0:	0124b023          	sd	s2,0(s1)
ffffffffc02085e4:	74a2                	ld	s1,40(sp)
ffffffffc02085e6:	7902                	ld	s2,32(sp)
ffffffffc02085e8:	6121                	addi	sp,sp,64
ffffffffc02085ea:	8082                	ret
ffffffffc02085ec:	00006697          	auipc	a3,0x6
ffffffffc02085f0:	77c68693          	addi	a3,a3,1916 # ffffffffc020ed68 <syscalls+0xcf0>
ffffffffc02085f4:	00003617          	auipc	a2,0x3
ffffffffc02085f8:	6d460613          	addi	a2,a2,1748 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02085fc:	04f00593          	li	a1,79
ffffffffc0208600:	00006517          	auipc	a0,0x6
ffffffffc0208604:	73850513          	addi	a0,a0,1848 # ffffffffc020ed38 <syscalls+0xcc0>
ffffffffc0208608:	e97f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020860c <vfs_lookup_parent>:
ffffffffc020860c:	7139                	addi	sp,sp,-64
ffffffffc020860e:	f822                	sd	s0,48(sp)
ffffffffc0208610:	f426                	sd	s1,40(sp)
ffffffffc0208612:	842e                	mv	s0,a1
ffffffffc0208614:	84b2                	mv	s1,a2
ffffffffc0208616:	002c                	addi	a1,sp,8
ffffffffc0208618:	0830                	addi	a2,sp,24
ffffffffc020861a:	fc06                	sd	ra,56(sp)
ffffffffc020861c:	e42a                	sd	a0,8(sp)
ffffffffc020861e:	e41ff0ef          	jal	ra,ffffffffc020845e <get_device>
ffffffffc0208622:	e509                	bnez	a0,ffffffffc020862c <vfs_lookup_parent+0x20>
ffffffffc0208624:	67a2                	ld	a5,8(sp)
ffffffffc0208626:	e09c                	sd	a5,0(s1)
ffffffffc0208628:	67e2                	ld	a5,24(sp)
ffffffffc020862a:	e01c                	sd	a5,0(s0)
ffffffffc020862c:	70e2                	ld	ra,56(sp)
ffffffffc020862e:	7442                	ld	s0,48(sp)
ffffffffc0208630:	74a2                	ld	s1,40(sp)
ffffffffc0208632:	6121                	addi	sp,sp,64
ffffffffc0208634:	8082                	ret

ffffffffc0208636 <vfs_get_curdir>:
ffffffffc0208636:	0008e797          	auipc	a5,0x8e
ffffffffc020863a:	29a7b783          	ld	a5,666(a5) # ffffffffc02968d0 <current>
ffffffffc020863e:	1487b783          	ld	a5,328(a5)
ffffffffc0208642:	1101                	addi	sp,sp,-32
ffffffffc0208644:	e426                	sd	s1,8(sp)
ffffffffc0208646:	6384                	ld	s1,0(a5)
ffffffffc0208648:	ec06                	sd	ra,24(sp)
ffffffffc020864a:	e822                	sd	s0,16(sp)
ffffffffc020864c:	cc81                	beqz	s1,ffffffffc0208664 <vfs_get_curdir+0x2e>
ffffffffc020864e:	842a                	mv	s0,a0
ffffffffc0208650:	8526                	mv	a0,s1
ffffffffc0208652:	d4eff0ef          	jal	ra,ffffffffc0207ba0 <inode_ref_inc>
ffffffffc0208656:	4501                	li	a0,0
ffffffffc0208658:	e004                	sd	s1,0(s0)
ffffffffc020865a:	60e2                	ld	ra,24(sp)
ffffffffc020865c:	6442                	ld	s0,16(sp)
ffffffffc020865e:	64a2                	ld	s1,8(sp)
ffffffffc0208660:	6105                	addi	sp,sp,32
ffffffffc0208662:	8082                	ret
ffffffffc0208664:	5541                	li	a0,-16
ffffffffc0208666:	bfd5                	j	ffffffffc020865a <vfs_get_curdir+0x24>

ffffffffc0208668 <vfs_set_curdir>:
ffffffffc0208668:	7139                	addi	sp,sp,-64
ffffffffc020866a:	f04a                	sd	s2,32(sp)
ffffffffc020866c:	0008e917          	auipc	s2,0x8e
ffffffffc0208670:	26490913          	addi	s2,s2,612 # ffffffffc02968d0 <current>
ffffffffc0208674:	00093783          	ld	a5,0(s2)
ffffffffc0208678:	f822                	sd	s0,48(sp)
ffffffffc020867a:	842a                	mv	s0,a0
ffffffffc020867c:	1487b503          	ld	a0,328(a5)
ffffffffc0208680:	ec4e                	sd	s3,24(sp)
ffffffffc0208682:	fc06                	sd	ra,56(sp)
ffffffffc0208684:	f426                	sd	s1,40(sp)
ffffffffc0208686:	d8ffc0ef          	jal	ra,ffffffffc0205414 <lock_files>
ffffffffc020868a:	00093783          	ld	a5,0(s2)
ffffffffc020868e:	1487b503          	ld	a0,328(a5)
ffffffffc0208692:	00053983          	ld	s3,0(a0)
ffffffffc0208696:	07340963          	beq	s0,s3,ffffffffc0208708 <vfs_set_curdir+0xa0>
ffffffffc020869a:	cc39                	beqz	s0,ffffffffc02086f8 <vfs_set_curdir+0x90>
ffffffffc020869c:	783c                	ld	a5,112(s0)
ffffffffc020869e:	c7bd                	beqz	a5,ffffffffc020870c <vfs_set_curdir+0xa4>
ffffffffc02086a0:	6bbc                	ld	a5,80(a5)
ffffffffc02086a2:	c7ad                	beqz	a5,ffffffffc020870c <vfs_set_curdir+0xa4>
ffffffffc02086a4:	00006597          	auipc	a1,0x6
ffffffffc02086a8:	78458593          	addi	a1,a1,1924 # ffffffffc020ee28 <syscalls+0xdb0>
ffffffffc02086ac:	8522                	mv	a0,s0
ffffffffc02086ae:	d0aff0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc02086b2:	783c                	ld	a5,112(s0)
ffffffffc02086b4:	006c                	addi	a1,sp,12
ffffffffc02086b6:	8522                	mv	a0,s0
ffffffffc02086b8:	6bbc                	ld	a5,80(a5)
ffffffffc02086ba:	9782                	jalr	a5
ffffffffc02086bc:	84aa                	mv	s1,a0
ffffffffc02086be:	e901                	bnez	a0,ffffffffc02086ce <vfs_set_curdir+0x66>
ffffffffc02086c0:	47b2                	lw	a5,12(sp)
ffffffffc02086c2:	669d                	lui	a3,0x7
ffffffffc02086c4:	6709                	lui	a4,0x2
ffffffffc02086c6:	8ff5                	and	a5,a5,a3
ffffffffc02086c8:	54b9                	li	s1,-18
ffffffffc02086ca:	02e78063          	beq	a5,a4,ffffffffc02086ea <vfs_set_curdir+0x82>
ffffffffc02086ce:	00093783          	ld	a5,0(s2)
ffffffffc02086d2:	1487b503          	ld	a0,328(a5)
ffffffffc02086d6:	d45fc0ef          	jal	ra,ffffffffc020541a <unlock_files>
ffffffffc02086da:	70e2                	ld	ra,56(sp)
ffffffffc02086dc:	7442                	ld	s0,48(sp)
ffffffffc02086de:	7902                	ld	s2,32(sp)
ffffffffc02086e0:	69e2                	ld	s3,24(sp)
ffffffffc02086e2:	8526                	mv	a0,s1
ffffffffc02086e4:	74a2                	ld	s1,40(sp)
ffffffffc02086e6:	6121                	addi	sp,sp,64
ffffffffc02086e8:	8082                	ret
ffffffffc02086ea:	8522                	mv	a0,s0
ffffffffc02086ec:	cb4ff0ef          	jal	ra,ffffffffc0207ba0 <inode_ref_inc>
ffffffffc02086f0:	00093783          	ld	a5,0(s2)
ffffffffc02086f4:	1487b503          	ld	a0,328(a5)
ffffffffc02086f8:	e100                	sd	s0,0(a0)
ffffffffc02086fa:	4481                	li	s1,0
ffffffffc02086fc:	fc098de3          	beqz	s3,ffffffffc02086d6 <vfs_set_curdir+0x6e>
ffffffffc0208700:	854e                	mv	a0,s3
ffffffffc0208702:	d6cff0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc0208706:	b7e1                	j	ffffffffc02086ce <vfs_set_curdir+0x66>
ffffffffc0208708:	4481                	li	s1,0
ffffffffc020870a:	b7f1                	j	ffffffffc02086d6 <vfs_set_curdir+0x6e>
ffffffffc020870c:	00006697          	auipc	a3,0x6
ffffffffc0208710:	6b468693          	addi	a3,a3,1716 # ffffffffc020edc0 <syscalls+0xd48>
ffffffffc0208714:	00003617          	auipc	a2,0x3
ffffffffc0208718:	5b460613          	addi	a2,a2,1460 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020871c:	04300593          	li	a1,67
ffffffffc0208720:	00006517          	auipc	a0,0x6
ffffffffc0208724:	6f050513          	addi	a0,a0,1776 # ffffffffc020ee10 <syscalls+0xd98>
ffffffffc0208728:	d77f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020872c <vfs_chdir>:
ffffffffc020872c:	1101                	addi	sp,sp,-32
ffffffffc020872e:	002c                	addi	a1,sp,8
ffffffffc0208730:	e822                	sd	s0,16(sp)
ffffffffc0208732:	ec06                	sd	ra,24(sp)
ffffffffc0208734:	e43ff0ef          	jal	ra,ffffffffc0208576 <vfs_lookup>
ffffffffc0208738:	842a                	mv	s0,a0
ffffffffc020873a:	c511                	beqz	a0,ffffffffc0208746 <vfs_chdir+0x1a>
ffffffffc020873c:	60e2                	ld	ra,24(sp)
ffffffffc020873e:	8522                	mv	a0,s0
ffffffffc0208740:	6442                	ld	s0,16(sp)
ffffffffc0208742:	6105                	addi	sp,sp,32
ffffffffc0208744:	8082                	ret
ffffffffc0208746:	6522                	ld	a0,8(sp)
ffffffffc0208748:	f21ff0ef          	jal	ra,ffffffffc0208668 <vfs_set_curdir>
ffffffffc020874c:	842a                	mv	s0,a0
ffffffffc020874e:	6522                	ld	a0,8(sp)
ffffffffc0208750:	d1eff0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc0208754:	60e2                	ld	ra,24(sp)
ffffffffc0208756:	8522                	mv	a0,s0
ffffffffc0208758:	6442                	ld	s0,16(sp)
ffffffffc020875a:	6105                	addi	sp,sp,32
ffffffffc020875c:	8082                	ret

ffffffffc020875e <vfs_getcwd>:
ffffffffc020875e:	0008e797          	auipc	a5,0x8e
ffffffffc0208762:	1727b783          	ld	a5,370(a5) # ffffffffc02968d0 <current>
ffffffffc0208766:	1487b783          	ld	a5,328(a5)
ffffffffc020876a:	7179                	addi	sp,sp,-48
ffffffffc020876c:	ec26                	sd	s1,24(sp)
ffffffffc020876e:	6384                	ld	s1,0(a5)
ffffffffc0208770:	f406                	sd	ra,40(sp)
ffffffffc0208772:	f022                	sd	s0,32(sp)
ffffffffc0208774:	e84a                	sd	s2,16(sp)
ffffffffc0208776:	ccbd                	beqz	s1,ffffffffc02087f4 <vfs_getcwd+0x96>
ffffffffc0208778:	892a                	mv	s2,a0
ffffffffc020877a:	8526                	mv	a0,s1
ffffffffc020877c:	c24ff0ef          	jal	ra,ffffffffc0207ba0 <inode_ref_inc>
ffffffffc0208780:	74a8                	ld	a0,104(s1)
ffffffffc0208782:	c93d                	beqz	a0,ffffffffc02087f8 <vfs_getcwd+0x9a>
ffffffffc0208784:	9b3ff0ef          	jal	ra,ffffffffc0208136 <vfs_get_devname>
ffffffffc0208788:	842a                	mv	s0,a0
ffffffffc020878a:	7bb020ef          	jal	ra,ffffffffc020b744 <strlen>
ffffffffc020878e:	862a                	mv	a2,a0
ffffffffc0208790:	85a2                	mv	a1,s0
ffffffffc0208792:	4701                	li	a4,0
ffffffffc0208794:	4685                	li	a3,1
ffffffffc0208796:	854a                	mv	a0,s2
ffffffffc0208798:	ea7fc0ef          	jal	ra,ffffffffc020563e <iobuf_move>
ffffffffc020879c:	842a                	mv	s0,a0
ffffffffc020879e:	c919                	beqz	a0,ffffffffc02087b4 <vfs_getcwd+0x56>
ffffffffc02087a0:	8526                	mv	a0,s1
ffffffffc02087a2:	cccff0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc02087a6:	70a2                	ld	ra,40(sp)
ffffffffc02087a8:	8522                	mv	a0,s0
ffffffffc02087aa:	7402                	ld	s0,32(sp)
ffffffffc02087ac:	64e2                	ld	s1,24(sp)
ffffffffc02087ae:	6942                	ld	s2,16(sp)
ffffffffc02087b0:	6145                	addi	sp,sp,48
ffffffffc02087b2:	8082                	ret
ffffffffc02087b4:	03a00793          	li	a5,58
ffffffffc02087b8:	4701                	li	a4,0
ffffffffc02087ba:	4685                	li	a3,1
ffffffffc02087bc:	4605                	li	a2,1
ffffffffc02087be:	00f10593          	addi	a1,sp,15
ffffffffc02087c2:	854a                	mv	a0,s2
ffffffffc02087c4:	00f107a3          	sb	a5,15(sp)
ffffffffc02087c8:	e77fc0ef          	jal	ra,ffffffffc020563e <iobuf_move>
ffffffffc02087cc:	842a                	mv	s0,a0
ffffffffc02087ce:	f969                	bnez	a0,ffffffffc02087a0 <vfs_getcwd+0x42>
ffffffffc02087d0:	78bc                	ld	a5,112(s1)
ffffffffc02087d2:	c3b9                	beqz	a5,ffffffffc0208818 <vfs_getcwd+0xba>
ffffffffc02087d4:	7f9c                	ld	a5,56(a5)
ffffffffc02087d6:	c3a9                	beqz	a5,ffffffffc0208818 <vfs_getcwd+0xba>
ffffffffc02087d8:	00006597          	auipc	a1,0x6
ffffffffc02087dc:	6b058593          	addi	a1,a1,1712 # ffffffffc020ee88 <syscalls+0xe10>
ffffffffc02087e0:	8526                	mv	a0,s1
ffffffffc02087e2:	bd6ff0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc02087e6:	78bc                	ld	a5,112(s1)
ffffffffc02087e8:	85ca                	mv	a1,s2
ffffffffc02087ea:	8526                	mv	a0,s1
ffffffffc02087ec:	7f9c                	ld	a5,56(a5)
ffffffffc02087ee:	9782                	jalr	a5
ffffffffc02087f0:	842a                	mv	s0,a0
ffffffffc02087f2:	b77d                	j	ffffffffc02087a0 <vfs_getcwd+0x42>
ffffffffc02087f4:	5441                	li	s0,-16
ffffffffc02087f6:	bf45                	j	ffffffffc02087a6 <vfs_getcwd+0x48>
ffffffffc02087f8:	00006697          	auipc	a3,0x6
ffffffffc02087fc:	55868693          	addi	a3,a3,1368 # ffffffffc020ed50 <syscalls+0xcd8>
ffffffffc0208800:	00003617          	auipc	a2,0x3
ffffffffc0208804:	4c860613          	addi	a2,a2,1224 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208808:	06e00593          	li	a1,110
ffffffffc020880c:	00006517          	auipc	a0,0x6
ffffffffc0208810:	60450513          	addi	a0,a0,1540 # ffffffffc020ee10 <syscalls+0xd98>
ffffffffc0208814:	c8bf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208818:	00006697          	auipc	a3,0x6
ffffffffc020881c:	61868693          	addi	a3,a3,1560 # ffffffffc020ee30 <syscalls+0xdb8>
ffffffffc0208820:	00003617          	auipc	a2,0x3
ffffffffc0208824:	4a860613          	addi	a2,a2,1192 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208828:	07800593          	li	a1,120
ffffffffc020882c:	00006517          	auipc	a0,0x6
ffffffffc0208830:	5e450513          	addi	a0,a0,1508 # ffffffffc020ee10 <syscalls+0xd98>
ffffffffc0208834:	c6bf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208838 <dev_lookup>:
ffffffffc0208838:	0005c783          	lbu	a5,0(a1)
ffffffffc020883c:	e385                	bnez	a5,ffffffffc020885c <dev_lookup+0x24>
ffffffffc020883e:	1101                	addi	sp,sp,-32
ffffffffc0208840:	e822                	sd	s0,16(sp)
ffffffffc0208842:	e426                	sd	s1,8(sp)
ffffffffc0208844:	ec06                	sd	ra,24(sp)
ffffffffc0208846:	84aa                	mv	s1,a0
ffffffffc0208848:	8432                	mv	s0,a2
ffffffffc020884a:	b56ff0ef          	jal	ra,ffffffffc0207ba0 <inode_ref_inc>
ffffffffc020884e:	60e2                	ld	ra,24(sp)
ffffffffc0208850:	e004                	sd	s1,0(s0)
ffffffffc0208852:	6442                	ld	s0,16(sp)
ffffffffc0208854:	64a2                	ld	s1,8(sp)
ffffffffc0208856:	4501                	li	a0,0
ffffffffc0208858:	6105                	addi	sp,sp,32
ffffffffc020885a:	8082                	ret
ffffffffc020885c:	5541                	li	a0,-16
ffffffffc020885e:	8082                	ret

ffffffffc0208860 <dev_fstat>:
ffffffffc0208860:	1101                	addi	sp,sp,-32
ffffffffc0208862:	e426                	sd	s1,8(sp)
ffffffffc0208864:	84ae                	mv	s1,a1
ffffffffc0208866:	e822                	sd	s0,16(sp)
ffffffffc0208868:	02000613          	li	a2,32
ffffffffc020886c:	842a                	mv	s0,a0
ffffffffc020886e:	4581                	li	a1,0
ffffffffc0208870:	8526                	mv	a0,s1
ffffffffc0208872:	ec06                	sd	ra,24(sp)
ffffffffc0208874:	773020ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0208878:	c429                	beqz	s0,ffffffffc02088c2 <dev_fstat+0x62>
ffffffffc020887a:	783c                	ld	a5,112(s0)
ffffffffc020887c:	c3b9                	beqz	a5,ffffffffc02088c2 <dev_fstat+0x62>
ffffffffc020887e:	6bbc                	ld	a5,80(a5)
ffffffffc0208880:	c3a9                	beqz	a5,ffffffffc02088c2 <dev_fstat+0x62>
ffffffffc0208882:	00006597          	auipc	a1,0x6
ffffffffc0208886:	5a658593          	addi	a1,a1,1446 # ffffffffc020ee28 <syscalls+0xdb0>
ffffffffc020888a:	8522                	mv	a0,s0
ffffffffc020888c:	b2cff0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0208890:	783c                	ld	a5,112(s0)
ffffffffc0208892:	85a6                	mv	a1,s1
ffffffffc0208894:	8522                	mv	a0,s0
ffffffffc0208896:	6bbc                	ld	a5,80(a5)
ffffffffc0208898:	9782                	jalr	a5
ffffffffc020889a:	ed19                	bnez	a0,ffffffffc02088b8 <dev_fstat+0x58>
ffffffffc020889c:	4c38                	lw	a4,88(s0)
ffffffffc020889e:	6785                	lui	a5,0x1
ffffffffc02088a0:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02088a4:	02f71f63          	bne	a4,a5,ffffffffc02088e2 <dev_fstat+0x82>
ffffffffc02088a8:	6018                	ld	a4,0(s0)
ffffffffc02088aa:	641c                	ld	a5,8(s0)
ffffffffc02088ac:	4685                	li	a3,1
ffffffffc02088ae:	e494                	sd	a3,8(s1)
ffffffffc02088b0:	02e787b3          	mul	a5,a5,a4
ffffffffc02088b4:	e898                	sd	a4,16(s1)
ffffffffc02088b6:	ec9c                	sd	a5,24(s1)
ffffffffc02088b8:	60e2                	ld	ra,24(sp)
ffffffffc02088ba:	6442                	ld	s0,16(sp)
ffffffffc02088bc:	64a2                	ld	s1,8(sp)
ffffffffc02088be:	6105                	addi	sp,sp,32
ffffffffc02088c0:	8082                	ret
ffffffffc02088c2:	00006697          	auipc	a3,0x6
ffffffffc02088c6:	4fe68693          	addi	a3,a3,1278 # ffffffffc020edc0 <syscalls+0xd48>
ffffffffc02088ca:	00003617          	auipc	a2,0x3
ffffffffc02088ce:	3fe60613          	addi	a2,a2,1022 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02088d2:	04200593          	li	a1,66
ffffffffc02088d6:	00006517          	auipc	a0,0x6
ffffffffc02088da:	5c250513          	addi	a0,a0,1474 # ffffffffc020ee98 <syscalls+0xe20>
ffffffffc02088de:	bc1f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02088e2:	00006697          	auipc	a3,0x6
ffffffffc02088e6:	2a668693          	addi	a3,a3,678 # ffffffffc020eb88 <syscalls+0xb10>
ffffffffc02088ea:	00003617          	auipc	a2,0x3
ffffffffc02088ee:	3de60613          	addi	a2,a2,990 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02088f2:	04500593          	li	a1,69
ffffffffc02088f6:	00006517          	auipc	a0,0x6
ffffffffc02088fa:	5a250513          	addi	a0,a0,1442 # ffffffffc020ee98 <syscalls+0xe20>
ffffffffc02088fe:	ba1f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208902 <dev_ioctl>:
ffffffffc0208902:	c909                	beqz	a0,ffffffffc0208914 <dev_ioctl+0x12>
ffffffffc0208904:	4d34                	lw	a3,88(a0)
ffffffffc0208906:	6705                	lui	a4,0x1
ffffffffc0208908:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020890c:	00e69463          	bne	a3,a4,ffffffffc0208914 <dev_ioctl+0x12>
ffffffffc0208910:	751c                	ld	a5,40(a0)
ffffffffc0208912:	8782                	jr	a5
ffffffffc0208914:	1141                	addi	sp,sp,-16
ffffffffc0208916:	00006697          	auipc	a3,0x6
ffffffffc020891a:	27268693          	addi	a3,a3,626 # ffffffffc020eb88 <syscalls+0xb10>
ffffffffc020891e:	00003617          	auipc	a2,0x3
ffffffffc0208922:	3aa60613          	addi	a2,a2,938 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208926:	03500593          	li	a1,53
ffffffffc020892a:	00006517          	auipc	a0,0x6
ffffffffc020892e:	56e50513          	addi	a0,a0,1390 # ffffffffc020ee98 <syscalls+0xe20>
ffffffffc0208932:	e406                	sd	ra,8(sp)
ffffffffc0208934:	b6bf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208938 <dev_tryseek>:
ffffffffc0208938:	c51d                	beqz	a0,ffffffffc0208966 <dev_tryseek+0x2e>
ffffffffc020893a:	4d38                	lw	a4,88(a0)
ffffffffc020893c:	6785                	lui	a5,0x1
ffffffffc020893e:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208942:	02f71263          	bne	a4,a5,ffffffffc0208966 <dev_tryseek+0x2e>
ffffffffc0208946:	611c                	ld	a5,0(a0)
ffffffffc0208948:	cf89                	beqz	a5,ffffffffc0208962 <dev_tryseek+0x2a>
ffffffffc020894a:	6518                	ld	a4,8(a0)
ffffffffc020894c:	02e5f6b3          	remu	a3,a1,a4
ffffffffc0208950:	ea89                	bnez	a3,ffffffffc0208962 <dev_tryseek+0x2a>
ffffffffc0208952:	0005c863          	bltz	a1,ffffffffc0208962 <dev_tryseek+0x2a>
ffffffffc0208956:	02e787b3          	mul	a5,a5,a4
ffffffffc020895a:	00f5f463          	bgeu	a1,a5,ffffffffc0208962 <dev_tryseek+0x2a>
ffffffffc020895e:	4501                	li	a0,0
ffffffffc0208960:	8082                	ret
ffffffffc0208962:	5575                	li	a0,-3
ffffffffc0208964:	8082                	ret
ffffffffc0208966:	1141                	addi	sp,sp,-16
ffffffffc0208968:	00006697          	auipc	a3,0x6
ffffffffc020896c:	22068693          	addi	a3,a3,544 # ffffffffc020eb88 <syscalls+0xb10>
ffffffffc0208970:	00003617          	auipc	a2,0x3
ffffffffc0208974:	35860613          	addi	a2,a2,856 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208978:	05f00593          	li	a1,95
ffffffffc020897c:	00006517          	auipc	a0,0x6
ffffffffc0208980:	51c50513          	addi	a0,a0,1308 # ffffffffc020ee98 <syscalls+0xe20>
ffffffffc0208984:	e406                	sd	ra,8(sp)
ffffffffc0208986:	b19f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020898a <dev_gettype>:
ffffffffc020898a:	c10d                	beqz	a0,ffffffffc02089ac <dev_gettype+0x22>
ffffffffc020898c:	4d38                	lw	a4,88(a0)
ffffffffc020898e:	6785                	lui	a5,0x1
ffffffffc0208990:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208994:	00f71c63          	bne	a4,a5,ffffffffc02089ac <dev_gettype+0x22>
ffffffffc0208998:	6118                	ld	a4,0(a0)
ffffffffc020899a:	6795                	lui	a5,0x5
ffffffffc020899c:	c701                	beqz	a4,ffffffffc02089a4 <dev_gettype+0x1a>
ffffffffc020899e:	c19c                	sw	a5,0(a1)
ffffffffc02089a0:	4501                	li	a0,0
ffffffffc02089a2:	8082                	ret
ffffffffc02089a4:	6791                	lui	a5,0x4
ffffffffc02089a6:	c19c                	sw	a5,0(a1)
ffffffffc02089a8:	4501                	li	a0,0
ffffffffc02089aa:	8082                	ret
ffffffffc02089ac:	1141                	addi	sp,sp,-16
ffffffffc02089ae:	00006697          	auipc	a3,0x6
ffffffffc02089b2:	1da68693          	addi	a3,a3,474 # ffffffffc020eb88 <syscalls+0xb10>
ffffffffc02089b6:	00003617          	auipc	a2,0x3
ffffffffc02089ba:	31260613          	addi	a2,a2,786 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02089be:	05300593          	li	a1,83
ffffffffc02089c2:	00006517          	auipc	a0,0x6
ffffffffc02089c6:	4d650513          	addi	a0,a0,1238 # ffffffffc020ee98 <syscalls+0xe20>
ffffffffc02089ca:	e406                	sd	ra,8(sp)
ffffffffc02089cc:	ad3f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02089d0 <dev_write>:
ffffffffc02089d0:	c911                	beqz	a0,ffffffffc02089e4 <dev_write+0x14>
ffffffffc02089d2:	4d34                	lw	a3,88(a0)
ffffffffc02089d4:	6705                	lui	a4,0x1
ffffffffc02089d6:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02089da:	00e69563          	bne	a3,a4,ffffffffc02089e4 <dev_write+0x14>
ffffffffc02089de:	711c                	ld	a5,32(a0)
ffffffffc02089e0:	4605                	li	a2,1
ffffffffc02089e2:	8782                	jr	a5
ffffffffc02089e4:	1141                	addi	sp,sp,-16
ffffffffc02089e6:	00006697          	auipc	a3,0x6
ffffffffc02089ea:	1a268693          	addi	a3,a3,418 # ffffffffc020eb88 <syscalls+0xb10>
ffffffffc02089ee:	00003617          	auipc	a2,0x3
ffffffffc02089f2:	2da60613          	addi	a2,a2,730 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02089f6:	02c00593          	li	a1,44
ffffffffc02089fa:	00006517          	auipc	a0,0x6
ffffffffc02089fe:	49e50513          	addi	a0,a0,1182 # ffffffffc020ee98 <syscalls+0xe20>
ffffffffc0208a02:	e406                	sd	ra,8(sp)
ffffffffc0208a04:	a9bf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208a08 <dev_read>:
ffffffffc0208a08:	c911                	beqz	a0,ffffffffc0208a1c <dev_read+0x14>
ffffffffc0208a0a:	4d34                	lw	a3,88(a0)
ffffffffc0208a0c:	6705                	lui	a4,0x1
ffffffffc0208a0e:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208a12:	00e69563          	bne	a3,a4,ffffffffc0208a1c <dev_read+0x14>
ffffffffc0208a16:	711c                	ld	a5,32(a0)
ffffffffc0208a18:	4601                	li	a2,0
ffffffffc0208a1a:	8782                	jr	a5
ffffffffc0208a1c:	1141                	addi	sp,sp,-16
ffffffffc0208a1e:	00006697          	auipc	a3,0x6
ffffffffc0208a22:	16a68693          	addi	a3,a3,362 # ffffffffc020eb88 <syscalls+0xb10>
ffffffffc0208a26:	00003617          	auipc	a2,0x3
ffffffffc0208a2a:	2a260613          	addi	a2,a2,674 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208a2e:	02300593          	li	a1,35
ffffffffc0208a32:	00006517          	auipc	a0,0x6
ffffffffc0208a36:	46650513          	addi	a0,a0,1126 # ffffffffc020ee98 <syscalls+0xe20>
ffffffffc0208a3a:	e406                	sd	ra,8(sp)
ffffffffc0208a3c:	a63f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208a40 <dev_close>:
ffffffffc0208a40:	c909                	beqz	a0,ffffffffc0208a52 <dev_close+0x12>
ffffffffc0208a42:	4d34                	lw	a3,88(a0)
ffffffffc0208a44:	6705                	lui	a4,0x1
ffffffffc0208a46:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208a4a:	00e69463          	bne	a3,a4,ffffffffc0208a52 <dev_close+0x12>
ffffffffc0208a4e:	6d1c                	ld	a5,24(a0)
ffffffffc0208a50:	8782                	jr	a5
ffffffffc0208a52:	1141                	addi	sp,sp,-16
ffffffffc0208a54:	00006697          	auipc	a3,0x6
ffffffffc0208a58:	13468693          	addi	a3,a3,308 # ffffffffc020eb88 <syscalls+0xb10>
ffffffffc0208a5c:	00003617          	auipc	a2,0x3
ffffffffc0208a60:	26c60613          	addi	a2,a2,620 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208a64:	45e9                	li	a1,26
ffffffffc0208a66:	00006517          	auipc	a0,0x6
ffffffffc0208a6a:	43250513          	addi	a0,a0,1074 # ffffffffc020ee98 <syscalls+0xe20>
ffffffffc0208a6e:	e406                	sd	ra,8(sp)
ffffffffc0208a70:	a2ff70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208a74 <dev_open>:
ffffffffc0208a74:	03c5f713          	andi	a4,a1,60
ffffffffc0208a78:	eb11                	bnez	a4,ffffffffc0208a8c <dev_open+0x18>
ffffffffc0208a7a:	c919                	beqz	a0,ffffffffc0208a90 <dev_open+0x1c>
ffffffffc0208a7c:	4d34                	lw	a3,88(a0)
ffffffffc0208a7e:	6705                	lui	a4,0x1
ffffffffc0208a80:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208a84:	00e69663          	bne	a3,a4,ffffffffc0208a90 <dev_open+0x1c>
ffffffffc0208a88:	691c                	ld	a5,16(a0)
ffffffffc0208a8a:	8782                	jr	a5
ffffffffc0208a8c:	5575                	li	a0,-3
ffffffffc0208a8e:	8082                	ret
ffffffffc0208a90:	1141                	addi	sp,sp,-16
ffffffffc0208a92:	00006697          	auipc	a3,0x6
ffffffffc0208a96:	0f668693          	addi	a3,a3,246 # ffffffffc020eb88 <syscalls+0xb10>
ffffffffc0208a9a:	00003617          	auipc	a2,0x3
ffffffffc0208a9e:	22e60613          	addi	a2,a2,558 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208aa2:	45c5                	li	a1,17
ffffffffc0208aa4:	00006517          	auipc	a0,0x6
ffffffffc0208aa8:	3f450513          	addi	a0,a0,1012 # ffffffffc020ee98 <syscalls+0xe20>
ffffffffc0208aac:	e406                	sd	ra,8(sp)
ffffffffc0208aae:	9f1f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208ab2 <dev_init>:
ffffffffc0208ab2:	1141                	addi	sp,sp,-16
ffffffffc0208ab4:	e406                	sd	ra,8(sp)
ffffffffc0208ab6:	542000ef          	jal	ra,ffffffffc0208ff8 <dev_init_stdin>
ffffffffc0208aba:	65a000ef          	jal	ra,ffffffffc0209114 <dev_init_stdout>
ffffffffc0208abe:	60a2                	ld	ra,8(sp)
ffffffffc0208ac0:	0141                	addi	sp,sp,16
ffffffffc0208ac2:	a439                	j	ffffffffc0208cd0 <dev_init_disk0>

ffffffffc0208ac4 <dev_create_inode>:
ffffffffc0208ac4:	6505                	lui	a0,0x1
ffffffffc0208ac6:	1141                	addi	sp,sp,-16
ffffffffc0208ac8:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208acc:	e022                	sd	s0,0(sp)
ffffffffc0208ace:	e406                	sd	ra,8(sp)
ffffffffc0208ad0:	852ff0ef          	jal	ra,ffffffffc0207b22 <__alloc_inode>
ffffffffc0208ad4:	842a                	mv	s0,a0
ffffffffc0208ad6:	c901                	beqz	a0,ffffffffc0208ae6 <dev_create_inode+0x22>
ffffffffc0208ad8:	4601                	li	a2,0
ffffffffc0208ada:	00006597          	auipc	a1,0x6
ffffffffc0208ade:	3d658593          	addi	a1,a1,982 # ffffffffc020eeb0 <dev_node_ops>
ffffffffc0208ae2:	85cff0ef          	jal	ra,ffffffffc0207b3e <inode_init>
ffffffffc0208ae6:	60a2                	ld	ra,8(sp)
ffffffffc0208ae8:	8522                	mv	a0,s0
ffffffffc0208aea:	6402                	ld	s0,0(sp)
ffffffffc0208aec:	0141                	addi	sp,sp,16
ffffffffc0208aee:	8082                	ret

ffffffffc0208af0 <disk0_open>:
ffffffffc0208af0:	4501                	li	a0,0
ffffffffc0208af2:	8082                	ret

ffffffffc0208af4 <disk0_close>:
ffffffffc0208af4:	4501                	li	a0,0
ffffffffc0208af6:	8082                	ret

ffffffffc0208af8 <disk0_ioctl>:
ffffffffc0208af8:	5531                	li	a0,-20
ffffffffc0208afa:	8082                	ret

ffffffffc0208afc <disk0_io>:
ffffffffc0208afc:	659c                	ld	a5,8(a1)
ffffffffc0208afe:	7159                	addi	sp,sp,-112
ffffffffc0208b00:	eca6                	sd	s1,88(sp)
ffffffffc0208b02:	f45e                	sd	s7,40(sp)
ffffffffc0208b04:	6d84                	ld	s1,24(a1)
ffffffffc0208b06:	6b85                	lui	s7,0x1
ffffffffc0208b08:	1bfd                	addi	s7,s7,-1
ffffffffc0208b0a:	e4ce                	sd	s3,72(sp)
ffffffffc0208b0c:	43f7d993          	srai	s3,a5,0x3f
ffffffffc0208b10:	0179f9b3          	and	s3,s3,s7
ffffffffc0208b14:	99be                	add	s3,s3,a5
ffffffffc0208b16:	8fc5                	or	a5,a5,s1
ffffffffc0208b18:	f486                	sd	ra,104(sp)
ffffffffc0208b1a:	f0a2                	sd	s0,96(sp)
ffffffffc0208b1c:	e8ca                	sd	s2,80(sp)
ffffffffc0208b1e:	e0d2                	sd	s4,64(sp)
ffffffffc0208b20:	fc56                	sd	s5,56(sp)
ffffffffc0208b22:	f85a                	sd	s6,48(sp)
ffffffffc0208b24:	f062                	sd	s8,32(sp)
ffffffffc0208b26:	ec66                	sd	s9,24(sp)
ffffffffc0208b28:	e86a                	sd	s10,16(sp)
ffffffffc0208b2a:	0177f7b3          	and	a5,a5,s7
ffffffffc0208b2e:	10079d63          	bnez	a5,ffffffffc0208c48 <disk0_io+0x14c>
ffffffffc0208b32:	40c9d993          	srai	s3,s3,0xc
ffffffffc0208b36:	00c4d713          	srli	a4,s1,0xc
ffffffffc0208b3a:	2981                	sext.w	s3,s3
ffffffffc0208b3c:	2701                	sext.w	a4,a4
ffffffffc0208b3e:	00e987bb          	addw	a5,s3,a4
ffffffffc0208b42:	6114                	ld	a3,0(a0)
ffffffffc0208b44:	1782                	slli	a5,a5,0x20
ffffffffc0208b46:	9381                	srli	a5,a5,0x20
ffffffffc0208b48:	10f6e063          	bltu	a3,a5,ffffffffc0208c48 <disk0_io+0x14c>
ffffffffc0208b4c:	4501                	li	a0,0
ffffffffc0208b4e:	ef19                	bnez	a4,ffffffffc0208b6c <disk0_io+0x70>
ffffffffc0208b50:	70a6                	ld	ra,104(sp)
ffffffffc0208b52:	7406                	ld	s0,96(sp)
ffffffffc0208b54:	64e6                	ld	s1,88(sp)
ffffffffc0208b56:	6946                	ld	s2,80(sp)
ffffffffc0208b58:	69a6                	ld	s3,72(sp)
ffffffffc0208b5a:	6a06                	ld	s4,64(sp)
ffffffffc0208b5c:	7ae2                	ld	s5,56(sp)
ffffffffc0208b5e:	7b42                	ld	s6,48(sp)
ffffffffc0208b60:	7ba2                	ld	s7,40(sp)
ffffffffc0208b62:	7c02                	ld	s8,32(sp)
ffffffffc0208b64:	6ce2                	ld	s9,24(sp)
ffffffffc0208b66:	6d42                	ld	s10,16(sp)
ffffffffc0208b68:	6165                	addi	sp,sp,112
ffffffffc0208b6a:	8082                	ret
ffffffffc0208b6c:	0008d517          	auipc	a0,0x8d
ffffffffc0208b70:	cd450513          	addi	a0,a0,-812 # ffffffffc0295840 <disk0_sem>
ffffffffc0208b74:	8b2e                	mv	s6,a1
ffffffffc0208b76:	8c32                	mv	s8,a2
ffffffffc0208b78:	0008ea97          	auipc	s5,0x8e
ffffffffc0208b7c:	d90a8a93          	addi	s5,s5,-624 # ffffffffc0296908 <disk0_buffer>
ffffffffc0208b80:	c37fb0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc0208b84:	6c91                	lui	s9,0x4
ffffffffc0208b86:	e4b9                	bnez	s1,ffffffffc0208bd4 <disk0_io+0xd8>
ffffffffc0208b88:	a845                	j	ffffffffc0208c38 <disk0_io+0x13c>
ffffffffc0208b8a:	00c4d413          	srli	s0,s1,0xc
ffffffffc0208b8e:	0034169b          	slliw	a3,s0,0x3
ffffffffc0208b92:	00068d1b          	sext.w	s10,a3
ffffffffc0208b96:	1682                	slli	a3,a3,0x20
ffffffffc0208b98:	2401                	sext.w	s0,s0
ffffffffc0208b9a:	9281                	srli	a3,a3,0x20
ffffffffc0208b9c:	8926                	mv	s2,s1
ffffffffc0208b9e:	00399a1b          	slliw	s4,s3,0x3
ffffffffc0208ba2:	862e                	mv	a2,a1
ffffffffc0208ba4:	4509                	li	a0,2
ffffffffc0208ba6:	85d2                	mv	a1,s4
ffffffffc0208ba8:	f99f70ef          	jal	ra,ffffffffc0200b40 <ide_read_secs>
ffffffffc0208bac:	e165                	bnez	a0,ffffffffc0208c8c <disk0_io+0x190>
ffffffffc0208bae:	000ab583          	ld	a1,0(s5)
ffffffffc0208bb2:	0038                	addi	a4,sp,8
ffffffffc0208bb4:	4685                	li	a3,1
ffffffffc0208bb6:	864a                	mv	a2,s2
ffffffffc0208bb8:	855a                	mv	a0,s6
ffffffffc0208bba:	a85fc0ef          	jal	ra,ffffffffc020563e <iobuf_move>
ffffffffc0208bbe:	67a2                	ld	a5,8(sp)
ffffffffc0208bc0:	09279663          	bne	a5,s2,ffffffffc0208c4c <disk0_io+0x150>
ffffffffc0208bc4:	017977b3          	and	a5,s2,s7
ffffffffc0208bc8:	e3d1                	bnez	a5,ffffffffc0208c4c <disk0_io+0x150>
ffffffffc0208bca:	412484b3          	sub	s1,s1,s2
ffffffffc0208bce:	013409bb          	addw	s3,s0,s3
ffffffffc0208bd2:	c0bd                	beqz	s1,ffffffffc0208c38 <disk0_io+0x13c>
ffffffffc0208bd4:	000ab583          	ld	a1,0(s5)
ffffffffc0208bd8:	000c1b63          	bnez	s8,ffffffffc0208bee <disk0_io+0xf2>
ffffffffc0208bdc:	fb94e7e3          	bltu	s1,s9,ffffffffc0208b8a <disk0_io+0x8e>
ffffffffc0208be0:	02000693          	li	a3,32
ffffffffc0208be4:	02000d13          	li	s10,32
ffffffffc0208be8:	4411                	li	s0,4
ffffffffc0208bea:	6911                	lui	s2,0x4
ffffffffc0208bec:	bf4d                	j	ffffffffc0208b9e <disk0_io+0xa2>
ffffffffc0208bee:	0038                	addi	a4,sp,8
ffffffffc0208bf0:	4681                	li	a3,0
ffffffffc0208bf2:	6611                	lui	a2,0x4
ffffffffc0208bf4:	855a                	mv	a0,s6
ffffffffc0208bf6:	a49fc0ef          	jal	ra,ffffffffc020563e <iobuf_move>
ffffffffc0208bfa:	6422                	ld	s0,8(sp)
ffffffffc0208bfc:	c825                	beqz	s0,ffffffffc0208c6c <disk0_io+0x170>
ffffffffc0208bfe:	0684e763          	bltu	s1,s0,ffffffffc0208c6c <disk0_io+0x170>
ffffffffc0208c02:	017477b3          	and	a5,s0,s7
ffffffffc0208c06:	e3bd                	bnez	a5,ffffffffc0208c6c <disk0_io+0x170>
ffffffffc0208c08:	8031                	srli	s0,s0,0xc
ffffffffc0208c0a:	0034179b          	slliw	a5,s0,0x3
ffffffffc0208c0e:	000ab603          	ld	a2,0(s5)
ffffffffc0208c12:	0039991b          	slliw	s2,s3,0x3
ffffffffc0208c16:	02079693          	slli	a3,a5,0x20
ffffffffc0208c1a:	9281                	srli	a3,a3,0x20
ffffffffc0208c1c:	85ca                	mv	a1,s2
ffffffffc0208c1e:	4509                	li	a0,2
ffffffffc0208c20:	2401                	sext.w	s0,s0
ffffffffc0208c22:	00078a1b          	sext.w	s4,a5
ffffffffc0208c26:	fb1f70ef          	jal	ra,ffffffffc0200bd6 <ide_write_secs>
ffffffffc0208c2a:	e151                	bnez	a0,ffffffffc0208cae <disk0_io+0x1b2>
ffffffffc0208c2c:	6922                	ld	s2,8(sp)
ffffffffc0208c2e:	013409bb          	addw	s3,s0,s3
ffffffffc0208c32:	412484b3          	sub	s1,s1,s2
ffffffffc0208c36:	fcd9                	bnez	s1,ffffffffc0208bd4 <disk0_io+0xd8>
ffffffffc0208c38:	0008d517          	auipc	a0,0x8d
ffffffffc0208c3c:	c0850513          	addi	a0,a0,-1016 # ffffffffc0295840 <disk0_sem>
ffffffffc0208c40:	b73fb0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0208c44:	4501                	li	a0,0
ffffffffc0208c46:	b729                	j	ffffffffc0208b50 <disk0_io+0x54>
ffffffffc0208c48:	5575                	li	a0,-3
ffffffffc0208c4a:	b719                	j	ffffffffc0208b50 <disk0_io+0x54>
ffffffffc0208c4c:	00006697          	auipc	a3,0x6
ffffffffc0208c50:	3dc68693          	addi	a3,a3,988 # ffffffffc020f028 <dev_node_ops+0x178>
ffffffffc0208c54:	00003617          	auipc	a2,0x3
ffffffffc0208c58:	07460613          	addi	a2,a2,116 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208c5c:	06200593          	li	a1,98
ffffffffc0208c60:	00006517          	auipc	a0,0x6
ffffffffc0208c64:	31050513          	addi	a0,a0,784 # ffffffffc020ef70 <dev_node_ops+0xc0>
ffffffffc0208c68:	837f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208c6c:	00006697          	auipc	a3,0x6
ffffffffc0208c70:	2c468693          	addi	a3,a3,708 # ffffffffc020ef30 <dev_node_ops+0x80>
ffffffffc0208c74:	00003617          	auipc	a2,0x3
ffffffffc0208c78:	05460613          	addi	a2,a2,84 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208c7c:	05700593          	li	a1,87
ffffffffc0208c80:	00006517          	auipc	a0,0x6
ffffffffc0208c84:	2f050513          	addi	a0,a0,752 # ffffffffc020ef70 <dev_node_ops+0xc0>
ffffffffc0208c88:	817f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208c8c:	88aa                	mv	a7,a0
ffffffffc0208c8e:	886a                	mv	a6,s10
ffffffffc0208c90:	87a2                	mv	a5,s0
ffffffffc0208c92:	8752                	mv	a4,s4
ffffffffc0208c94:	86ce                	mv	a3,s3
ffffffffc0208c96:	00006617          	auipc	a2,0x6
ffffffffc0208c9a:	34a60613          	addi	a2,a2,842 # ffffffffc020efe0 <dev_node_ops+0x130>
ffffffffc0208c9e:	02d00593          	li	a1,45
ffffffffc0208ca2:	00006517          	auipc	a0,0x6
ffffffffc0208ca6:	2ce50513          	addi	a0,a0,718 # ffffffffc020ef70 <dev_node_ops+0xc0>
ffffffffc0208caa:	ff4f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208cae:	88aa                	mv	a7,a0
ffffffffc0208cb0:	8852                	mv	a6,s4
ffffffffc0208cb2:	87a2                	mv	a5,s0
ffffffffc0208cb4:	874a                	mv	a4,s2
ffffffffc0208cb6:	86ce                	mv	a3,s3
ffffffffc0208cb8:	00006617          	auipc	a2,0x6
ffffffffc0208cbc:	2d860613          	addi	a2,a2,728 # ffffffffc020ef90 <dev_node_ops+0xe0>
ffffffffc0208cc0:	03700593          	li	a1,55
ffffffffc0208cc4:	00006517          	auipc	a0,0x6
ffffffffc0208cc8:	2ac50513          	addi	a0,a0,684 # ffffffffc020ef70 <dev_node_ops+0xc0>
ffffffffc0208ccc:	fd2f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208cd0 <dev_init_disk0>:
ffffffffc0208cd0:	1101                	addi	sp,sp,-32
ffffffffc0208cd2:	ec06                	sd	ra,24(sp)
ffffffffc0208cd4:	e822                	sd	s0,16(sp)
ffffffffc0208cd6:	e426                	sd	s1,8(sp)
ffffffffc0208cd8:	dedff0ef          	jal	ra,ffffffffc0208ac4 <dev_create_inode>
ffffffffc0208cdc:	c541                	beqz	a0,ffffffffc0208d64 <dev_init_disk0+0x94>
ffffffffc0208cde:	4d38                	lw	a4,88(a0)
ffffffffc0208ce0:	6485                	lui	s1,0x1
ffffffffc0208ce2:	23448793          	addi	a5,s1,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208ce6:	842a                	mv	s0,a0
ffffffffc0208ce8:	0cf71f63          	bne	a4,a5,ffffffffc0208dc6 <dev_init_disk0+0xf6>
ffffffffc0208cec:	4509                	li	a0,2
ffffffffc0208cee:	e07f70ef          	jal	ra,ffffffffc0200af4 <ide_device_valid>
ffffffffc0208cf2:	cd55                	beqz	a0,ffffffffc0208dae <dev_init_disk0+0xde>
ffffffffc0208cf4:	4509                	li	a0,2
ffffffffc0208cf6:	e23f70ef          	jal	ra,ffffffffc0200b18 <ide_device_size>
ffffffffc0208cfa:	00355793          	srli	a5,a0,0x3
ffffffffc0208cfe:	e01c                	sd	a5,0(s0)
ffffffffc0208d00:	00000797          	auipc	a5,0x0
ffffffffc0208d04:	df078793          	addi	a5,a5,-528 # ffffffffc0208af0 <disk0_open>
ffffffffc0208d08:	e81c                	sd	a5,16(s0)
ffffffffc0208d0a:	00000797          	auipc	a5,0x0
ffffffffc0208d0e:	dea78793          	addi	a5,a5,-534 # ffffffffc0208af4 <disk0_close>
ffffffffc0208d12:	ec1c                	sd	a5,24(s0)
ffffffffc0208d14:	00000797          	auipc	a5,0x0
ffffffffc0208d18:	de878793          	addi	a5,a5,-536 # ffffffffc0208afc <disk0_io>
ffffffffc0208d1c:	f01c                	sd	a5,32(s0)
ffffffffc0208d1e:	00000797          	auipc	a5,0x0
ffffffffc0208d22:	dda78793          	addi	a5,a5,-550 # ffffffffc0208af8 <disk0_ioctl>
ffffffffc0208d26:	f41c                	sd	a5,40(s0)
ffffffffc0208d28:	4585                	li	a1,1
ffffffffc0208d2a:	0008d517          	auipc	a0,0x8d
ffffffffc0208d2e:	b1650513          	addi	a0,a0,-1258 # ffffffffc0295840 <disk0_sem>
ffffffffc0208d32:	e404                	sd	s1,8(s0)
ffffffffc0208d34:	a79fb0ef          	jal	ra,ffffffffc02047ac <sem_init>
ffffffffc0208d38:	6511                	lui	a0,0x4
ffffffffc0208d3a:	ad8f90ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0208d3e:	0008e797          	auipc	a5,0x8e
ffffffffc0208d42:	bca7b523          	sd	a0,-1078(a5) # ffffffffc0296908 <disk0_buffer>
ffffffffc0208d46:	c921                	beqz	a0,ffffffffc0208d96 <dev_init_disk0+0xc6>
ffffffffc0208d48:	4605                	li	a2,1
ffffffffc0208d4a:	85a2                	mv	a1,s0
ffffffffc0208d4c:	00006517          	auipc	a0,0x6
ffffffffc0208d50:	36c50513          	addi	a0,a0,876 # ffffffffc020f0b8 <dev_node_ops+0x208>
ffffffffc0208d54:	c2cff0ef          	jal	ra,ffffffffc0208180 <vfs_add_dev>
ffffffffc0208d58:	e115                	bnez	a0,ffffffffc0208d7c <dev_init_disk0+0xac>
ffffffffc0208d5a:	60e2                	ld	ra,24(sp)
ffffffffc0208d5c:	6442                	ld	s0,16(sp)
ffffffffc0208d5e:	64a2                	ld	s1,8(sp)
ffffffffc0208d60:	6105                	addi	sp,sp,32
ffffffffc0208d62:	8082                	ret
ffffffffc0208d64:	00006617          	auipc	a2,0x6
ffffffffc0208d68:	2f460613          	addi	a2,a2,756 # ffffffffc020f058 <dev_node_ops+0x1a8>
ffffffffc0208d6c:	08700593          	li	a1,135
ffffffffc0208d70:	00006517          	auipc	a0,0x6
ffffffffc0208d74:	20050513          	addi	a0,a0,512 # ffffffffc020ef70 <dev_node_ops+0xc0>
ffffffffc0208d78:	f26f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208d7c:	86aa                	mv	a3,a0
ffffffffc0208d7e:	00006617          	auipc	a2,0x6
ffffffffc0208d82:	34260613          	addi	a2,a2,834 # ffffffffc020f0c0 <dev_node_ops+0x210>
ffffffffc0208d86:	08d00593          	li	a1,141
ffffffffc0208d8a:	00006517          	auipc	a0,0x6
ffffffffc0208d8e:	1e650513          	addi	a0,a0,486 # ffffffffc020ef70 <dev_node_ops+0xc0>
ffffffffc0208d92:	f0cf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208d96:	00006617          	auipc	a2,0x6
ffffffffc0208d9a:	30260613          	addi	a2,a2,770 # ffffffffc020f098 <dev_node_ops+0x1e8>
ffffffffc0208d9e:	07f00593          	li	a1,127
ffffffffc0208da2:	00006517          	auipc	a0,0x6
ffffffffc0208da6:	1ce50513          	addi	a0,a0,462 # ffffffffc020ef70 <dev_node_ops+0xc0>
ffffffffc0208daa:	ef4f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208dae:	00006617          	auipc	a2,0x6
ffffffffc0208db2:	2ca60613          	addi	a2,a2,714 # ffffffffc020f078 <dev_node_ops+0x1c8>
ffffffffc0208db6:	07300593          	li	a1,115
ffffffffc0208dba:	00006517          	auipc	a0,0x6
ffffffffc0208dbe:	1b650513          	addi	a0,a0,438 # ffffffffc020ef70 <dev_node_ops+0xc0>
ffffffffc0208dc2:	edcf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208dc6:	00006697          	auipc	a3,0x6
ffffffffc0208dca:	dc268693          	addi	a3,a3,-574 # ffffffffc020eb88 <syscalls+0xb10>
ffffffffc0208dce:	00003617          	auipc	a2,0x3
ffffffffc0208dd2:	efa60613          	addi	a2,a2,-262 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0208dd6:	08900593          	li	a1,137
ffffffffc0208dda:	00006517          	auipc	a0,0x6
ffffffffc0208dde:	19650513          	addi	a0,a0,406 # ffffffffc020ef70 <dev_node_ops+0xc0>
ffffffffc0208de2:	ebcf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208de6 <stdin_open>:
ffffffffc0208de6:	4501                	li	a0,0
ffffffffc0208de8:	e191                	bnez	a1,ffffffffc0208dec <stdin_open+0x6>
ffffffffc0208dea:	8082                	ret
ffffffffc0208dec:	5575                	li	a0,-3
ffffffffc0208dee:	8082                	ret

ffffffffc0208df0 <stdin_close>:
ffffffffc0208df0:	4501                	li	a0,0
ffffffffc0208df2:	8082                	ret

ffffffffc0208df4 <stdin_ioctl>:
ffffffffc0208df4:	5575                	li	a0,-3
ffffffffc0208df6:	8082                	ret

ffffffffc0208df8 <stdin_io>:
ffffffffc0208df8:	7135                	addi	sp,sp,-160
ffffffffc0208dfa:	ed06                	sd	ra,152(sp)
ffffffffc0208dfc:	e922                	sd	s0,144(sp)
ffffffffc0208dfe:	e526                	sd	s1,136(sp)
ffffffffc0208e00:	e14a                	sd	s2,128(sp)
ffffffffc0208e02:	fcce                	sd	s3,120(sp)
ffffffffc0208e04:	f8d2                	sd	s4,112(sp)
ffffffffc0208e06:	f4d6                	sd	s5,104(sp)
ffffffffc0208e08:	f0da                	sd	s6,96(sp)
ffffffffc0208e0a:	ecde                	sd	s7,88(sp)
ffffffffc0208e0c:	e8e2                	sd	s8,80(sp)
ffffffffc0208e0e:	e4e6                	sd	s9,72(sp)
ffffffffc0208e10:	e0ea                	sd	s10,64(sp)
ffffffffc0208e12:	fc6e                	sd	s11,56(sp)
ffffffffc0208e14:	14061163          	bnez	a2,ffffffffc0208f56 <stdin_io+0x15e>
ffffffffc0208e18:	0005bd83          	ld	s11,0(a1)
ffffffffc0208e1c:	0185bd03          	ld	s10,24(a1)
ffffffffc0208e20:	8b2e                	mv	s6,a1
ffffffffc0208e22:	100027f3          	csrr	a5,sstatus
ffffffffc0208e26:	8b89                	andi	a5,a5,2
ffffffffc0208e28:	10079e63          	bnez	a5,ffffffffc0208f44 <stdin_io+0x14c>
ffffffffc0208e2c:	4401                	li	s0,0
ffffffffc0208e2e:	100d0963          	beqz	s10,ffffffffc0208f40 <stdin_io+0x148>
ffffffffc0208e32:	0008e997          	auipc	s3,0x8e
ffffffffc0208e36:	ade98993          	addi	s3,s3,-1314 # ffffffffc0296910 <p_rpos>
ffffffffc0208e3a:	0009b783          	ld	a5,0(s3)
ffffffffc0208e3e:	800004b7          	lui	s1,0x80000
ffffffffc0208e42:	6c85                	lui	s9,0x1
ffffffffc0208e44:	4a81                	li	s5,0
ffffffffc0208e46:	0008ea17          	auipc	s4,0x8e
ffffffffc0208e4a:	ad2a0a13          	addi	s4,s4,-1326 # ffffffffc0296918 <p_wpos>
ffffffffc0208e4e:	0491                	addi	s1,s1,4
ffffffffc0208e50:	0008d917          	auipc	s2,0x8d
ffffffffc0208e54:	a0890913          	addi	s2,s2,-1528 # ffffffffc0295858 <__wait_queue>
ffffffffc0208e58:	1cfd                	addi	s9,s9,-1
ffffffffc0208e5a:	000a3703          	ld	a4,0(s4)
ffffffffc0208e5e:	000a8c1b          	sext.w	s8,s5
ffffffffc0208e62:	8be2                	mv	s7,s8
ffffffffc0208e64:	02e7d763          	bge	a5,a4,ffffffffc0208e92 <stdin_io+0x9a>
ffffffffc0208e68:	a859                	j	ffffffffc0208efe <stdin_io+0x106>
ffffffffc0208e6a:	815fe0ef          	jal	ra,ffffffffc020767e <schedule>
ffffffffc0208e6e:	100027f3          	csrr	a5,sstatus
ffffffffc0208e72:	8b89                	andi	a5,a5,2
ffffffffc0208e74:	4401                	li	s0,0
ffffffffc0208e76:	ef8d                	bnez	a5,ffffffffc0208eb0 <stdin_io+0xb8>
ffffffffc0208e78:	0028                	addi	a0,sp,8
ffffffffc0208e7a:	9cffb0ef          	jal	ra,ffffffffc0204848 <wait_in_queue>
ffffffffc0208e7e:	e121                	bnez	a0,ffffffffc0208ebe <stdin_io+0xc6>
ffffffffc0208e80:	47c2                	lw	a5,16(sp)
ffffffffc0208e82:	04979563          	bne	a5,s1,ffffffffc0208ecc <stdin_io+0xd4>
ffffffffc0208e86:	0009b783          	ld	a5,0(s3)
ffffffffc0208e8a:	000a3703          	ld	a4,0(s4)
ffffffffc0208e8e:	06e7c863          	blt	a5,a4,ffffffffc0208efe <stdin_io+0x106>
ffffffffc0208e92:	8626                	mv	a2,s1
ffffffffc0208e94:	002c                	addi	a1,sp,8
ffffffffc0208e96:	854a                	mv	a0,s2
ffffffffc0208e98:	adbfb0ef          	jal	ra,ffffffffc0204972 <wait_current_set>
ffffffffc0208e9c:	d479                	beqz	s0,ffffffffc0208e6a <stdin_io+0x72>
ffffffffc0208e9e:	dcff70ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208ea2:	fdcfe0ef          	jal	ra,ffffffffc020767e <schedule>
ffffffffc0208ea6:	100027f3          	csrr	a5,sstatus
ffffffffc0208eaa:	8b89                	andi	a5,a5,2
ffffffffc0208eac:	4401                	li	s0,0
ffffffffc0208eae:	d7e9                	beqz	a5,ffffffffc0208e78 <stdin_io+0x80>
ffffffffc0208eb0:	dc3f70ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208eb4:	0028                	addi	a0,sp,8
ffffffffc0208eb6:	4405                	li	s0,1
ffffffffc0208eb8:	991fb0ef          	jal	ra,ffffffffc0204848 <wait_in_queue>
ffffffffc0208ebc:	d171                	beqz	a0,ffffffffc0208e80 <stdin_io+0x88>
ffffffffc0208ebe:	002c                	addi	a1,sp,8
ffffffffc0208ec0:	854a                	mv	a0,s2
ffffffffc0208ec2:	92dfb0ef          	jal	ra,ffffffffc02047ee <wait_queue_del>
ffffffffc0208ec6:	47c2                	lw	a5,16(sp)
ffffffffc0208ec8:	fa978fe3          	beq	a5,s1,ffffffffc0208e86 <stdin_io+0x8e>
ffffffffc0208ecc:	e435                	bnez	s0,ffffffffc0208f38 <stdin_io+0x140>
ffffffffc0208ece:	060b8963          	beqz	s7,ffffffffc0208f40 <stdin_io+0x148>
ffffffffc0208ed2:	018b3783          	ld	a5,24(s6)
ffffffffc0208ed6:	41578ab3          	sub	s5,a5,s5
ffffffffc0208eda:	015b3c23          	sd	s5,24(s6)
ffffffffc0208ede:	60ea                	ld	ra,152(sp)
ffffffffc0208ee0:	644a                	ld	s0,144(sp)
ffffffffc0208ee2:	64aa                	ld	s1,136(sp)
ffffffffc0208ee4:	690a                	ld	s2,128(sp)
ffffffffc0208ee6:	79e6                	ld	s3,120(sp)
ffffffffc0208ee8:	7a46                	ld	s4,112(sp)
ffffffffc0208eea:	7aa6                	ld	s5,104(sp)
ffffffffc0208eec:	7b06                	ld	s6,96(sp)
ffffffffc0208eee:	6c46                	ld	s8,80(sp)
ffffffffc0208ef0:	6ca6                	ld	s9,72(sp)
ffffffffc0208ef2:	6d06                	ld	s10,64(sp)
ffffffffc0208ef4:	7de2                	ld	s11,56(sp)
ffffffffc0208ef6:	855e                	mv	a0,s7
ffffffffc0208ef8:	6be6                	ld	s7,88(sp)
ffffffffc0208efa:	610d                	addi	sp,sp,160
ffffffffc0208efc:	8082                	ret
ffffffffc0208efe:	43f7d713          	srai	a4,a5,0x3f
ffffffffc0208f02:	03475693          	srli	a3,a4,0x34
ffffffffc0208f06:	00d78733          	add	a4,a5,a3
ffffffffc0208f0a:	01977733          	and	a4,a4,s9
ffffffffc0208f0e:	8f15                	sub	a4,a4,a3
ffffffffc0208f10:	0008d697          	auipc	a3,0x8d
ffffffffc0208f14:	95868693          	addi	a3,a3,-1704 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208f18:	9736                	add	a4,a4,a3
ffffffffc0208f1a:	00074683          	lbu	a3,0(a4)
ffffffffc0208f1e:	0785                	addi	a5,a5,1
ffffffffc0208f20:	015d8733          	add	a4,s11,s5
ffffffffc0208f24:	00d70023          	sb	a3,0(a4)
ffffffffc0208f28:	00f9b023          	sd	a5,0(s3)
ffffffffc0208f2c:	0a85                	addi	s5,s5,1
ffffffffc0208f2e:	001c0b9b          	addiw	s7,s8,1
ffffffffc0208f32:	f3aae4e3          	bltu	s5,s10,ffffffffc0208e5a <stdin_io+0x62>
ffffffffc0208f36:	dc51                	beqz	s0,ffffffffc0208ed2 <stdin_io+0xda>
ffffffffc0208f38:	d35f70ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208f3c:	f80b9be3          	bnez	s7,ffffffffc0208ed2 <stdin_io+0xda>
ffffffffc0208f40:	4b81                	li	s7,0
ffffffffc0208f42:	bf71                	j	ffffffffc0208ede <stdin_io+0xe6>
ffffffffc0208f44:	d2ff70ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208f48:	4405                	li	s0,1
ffffffffc0208f4a:	ee0d14e3          	bnez	s10,ffffffffc0208e32 <stdin_io+0x3a>
ffffffffc0208f4e:	d1ff70ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208f52:	4b81                	li	s7,0
ffffffffc0208f54:	b769                	j	ffffffffc0208ede <stdin_io+0xe6>
ffffffffc0208f56:	5bf5                	li	s7,-3
ffffffffc0208f58:	b759                	j	ffffffffc0208ede <stdin_io+0xe6>

ffffffffc0208f5a <dev_stdin_write>:
ffffffffc0208f5a:	e111                	bnez	a0,ffffffffc0208f5e <dev_stdin_write+0x4>
ffffffffc0208f5c:	8082                	ret
ffffffffc0208f5e:	1101                	addi	sp,sp,-32
ffffffffc0208f60:	e822                	sd	s0,16(sp)
ffffffffc0208f62:	ec06                	sd	ra,24(sp)
ffffffffc0208f64:	e426                	sd	s1,8(sp)
ffffffffc0208f66:	842a                	mv	s0,a0
ffffffffc0208f68:	100027f3          	csrr	a5,sstatus
ffffffffc0208f6c:	8b89                	andi	a5,a5,2
ffffffffc0208f6e:	4481                	li	s1,0
ffffffffc0208f70:	e3c1                	bnez	a5,ffffffffc0208ff0 <dev_stdin_write+0x96>
ffffffffc0208f72:	0008e597          	auipc	a1,0x8e
ffffffffc0208f76:	9a658593          	addi	a1,a1,-1626 # ffffffffc0296918 <p_wpos>
ffffffffc0208f7a:	6198                	ld	a4,0(a1)
ffffffffc0208f7c:	6605                	lui	a2,0x1
ffffffffc0208f7e:	fff60513          	addi	a0,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208f82:	43f75693          	srai	a3,a4,0x3f
ffffffffc0208f86:	92d1                	srli	a3,a3,0x34
ffffffffc0208f88:	00d707b3          	add	a5,a4,a3
ffffffffc0208f8c:	8fe9                	and	a5,a5,a0
ffffffffc0208f8e:	8f95                	sub	a5,a5,a3
ffffffffc0208f90:	0008d697          	auipc	a3,0x8d
ffffffffc0208f94:	8d868693          	addi	a3,a3,-1832 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208f98:	97b6                	add	a5,a5,a3
ffffffffc0208f9a:	00878023          	sb	s0,0(a5)
ffffffffc0208f9e:	0008e797          	auipc	a5,0x8e
ffffffffc0208fa2:	9727b783          	ld	a5,-1678(a5) # ffffffffc0296910 <p_rpos>
ffffffffc0208fa6:	40f707b3          	sub	a5,a4,a5
ffffffffc0208faa:	00c7d463          	bge	a5,a2,ffffffffc0208fb2 <dev_stdin_write+0x58>
ffffffffc0208fae:	0705                	addi	a4,a4,1
ffffffffc0208fb0:	e198                	sd	a4,0(a1)
ffffffffc0208fb2:	0008d517          	auipc	a0,0x8d
ffffffffc0208fb6:	8a650513          	addi	a0,a0,-1882 # ffffffffc0295858 <__wait_queue>
ffffffffc0208fba:	883fb0ef          	jal	ra,ffffffffc020483c <wait_queue_empty>
ffffffffc0208fbe:	cd09                	beqz	a0,ffffffffc0208fd8 <dev_stdin_write+0x7e>
ffffffffc0208fc0:	e491                	bnez	s1,ffffffffc0208fcc <dev_stdin_write+0x72>
ffffffffc0208fc2:	60e2                	ld	ra,24(sp)
ffffffffc0208fc4:	6442                	ld	s0,16(sp)
ffffffffc0208fc6:	64a2                	ld	s1,8(sp)
ffffffffc0208fc8:	6105                	addi	sp,sp,32
ffffffffc0208fca:	8082                	ret
ffffffffc0208fcc:	6442                	ld	s0,16(sp)
ffffffffc0208fce:	60e2                	ld	ra,24(sp)
ffffffffc0208fd0:	64a2                	ld	s1,8(sp)
ffffffffc0208fd2:	6105                	addi	sp,sp,32
ffffffffc0208fd4:	c99f706f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0208fd8:	800005b7          	lui	a1,0x80000
ffffffffc0208fdc:	4605                	li	a2,1
ffffffffc0208fde:	0591                	addi	a1,a1,4
ffffffffc0208fe0:	0008d517          	auipc	a0,0x8d
ffffffffc0208fe4:	87850513          	addi	a0,a0,-1928 # ffffffffc0295858 <__wait_queue>
ffffffffc0208fe8:	8bdfb0ef          	jal	ra,ffffffffc02048a4 <wakeup_queue>
ffffffffc0208fec:	d8f9                	beqz	s1,ffffffffc0208fc2 <dev_stdin_write+0x68>
ffffffffc0208fee:	bff9                	j	ffffffffc0208fcc <dev_stdin_write+0x72>
ffffffffc0208ff0:	c83f70ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208ff4:	4485                	li	s1,1
ffffffffc0208ff6:	bfb5                	j	ffffffffc0208f72 <dev_stdin_write+0x18>

ffffffffc0208ff8 <dev_init_stdin>:
ffffffffc0208ff8:	1141                	addi	sp,sp,-16
ffffffffc0208ffa:	e406                	sd	ra,8(sp)
ffffffffc0208ffc:	e022                	sd	s0,0(sp)
ffffffffc0208ffe:	ac7ff0ef          	jal	ra,ffffffffc0208ac4 <dev_create_inode>
ffffffffc0209002:	c93d                	beqz	a0,ffffffffc0209078 <dev_init_stdin+0x80>
ffffffffc0209004:	4d38                	lw	a4,88(a0)
ffffffffc0209006:	6785                	lui	a5,0x1
ffffffffc0209008:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020900c:	842a                	mv	s0,a0
ffffffffc020900e:	08f71e63          	bne	a4,a5,ffffffffc02090aa <dev_init_stdin+0xb2>
ffffffffc0209012:	4785                	li	a5,1
ffffffffc0209014:	e41c                	sd	a5,8(s0)
ffffffffc0209016:	00000797          	auipc	a5,0x0
ffffffffc020901a:	dd078793          	addi	a5,a5,-560 # ffffffffc0208de6 <stdin_open>
ffffffffc020901e:	e81c                	sd	a5,16(s0)
ffffffffc0209020:	00000797          	auipc	a5,0x0
ffffffffc0209024:	dd078793          	addi	a5,a5,-560 # ffffffffc0208df0 <stdin_close>
ffffffffc0209028:	ec1c                	sd	a5,24(s0)
ffffffffc020902a:	00000797          	auipc	a5,0x0
ffffffffc020902e:	dce78793          	addi	a5,a5,-562 # ffffffffc0208df8 <stdin_io>
ffffffffc0209032:	f01c                	sd	a5,32(s0)
ffffffffc0209034:	00000797          	auipc	a5,0x0
ffffffffc0209038:	dc078793          	addi	a5,a5,-576 # ffffffffc0208df4 <stdin_ioctl>
ffffffffc020903c:	f41c                	sd	a5,40(s0)
ffffffffc020903e:	0008d517          	auipc	a0,0x8d
ffffffffc0209042:	81a50513          	addi	a0,a0,-2022 # ffffffffc0295858 <__wait_queue>
ffffffffc0209046:	00043023          	sd	zero,0(s0)
ffffffffc020904a:	0008e797          	auipc	a5,0x8e
ffffffffc020904e:	8c07b723          	sd	zero,-1842(a5) # ffffffffc0296918 <p_wpos>
ffffffffc0209052:	0008e797          	auipc	a5,0x8e
ffffffffc0209056:	8a07bf23          	sd	zero,-1858(a5) # ffffffffc0296910 <p_rpos>
ffffffffc020905a:	f8efb0ef          	jal	ra,ffffffffc02047e8 <wait_queue_init>
ffffffffc020905e:	4601                	li	a2,0
ffffffffc0209060:	85a2                	mv	a1,s0
ffffffffc0209062:	00006517          	auipc	a0,0x6
ffffffffc0209066:	0be50513          	addi	a0,a0,190 # ffffffffc020f120 <dev_node_ops+0x270>
ffffffffc020906a:	916ff0ef          	jal	ra,ffffffffc0208180 <vfs_add_dev>
ffffffffc020906e:	e10d                	bnez	a0,ffffffffc0209090 <dev_init_stdin+0x98>
ffffffffc0209070:	60a2                	ld	ra,8(sp)
ffffffffc0209072:	6402                	ld	s0,0(sp)
ffffffffc0209074:	0141                	addi	sp,sp,16
ffffffffc0209076:	8082                	ret
ffffffffc0209078:	00006617          	auipc	a2,0x6
ffffffffc020907c:	06860613          	addi	a2,a2,104 # ffffffffc020f0e0 <dev_node_ops+0x230>
ffffffffc0209080:	07500593          	li	a1,117
ffffffffc0209084:	00006517          	auipc	a0,0x6
ffffffffc0209088:	07c50513          	addi	a0,a0,124 # ffffffffc020f100 <dev_node_ops+0x250>
ffffffffc020908c:	c12f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209090:	86aa                	mv	a3,a0
ffffffffc0209092:	00006617          	auipc	a2,0x6
ffffffffc0209096:	09660613          	addi	a2,a2,150 # ffffffffc020f128 <dev_node_ops+0x278>
ffffffffc020909a:	07b00593          	li	a1,123
ffffffffc020909e:	00006517          	auipc	a0,0x6
ffffffffc02090a2:	06250513          	addi	a0,a0,98 # ffffffffc020f100 <dev_node_ops+0x250>
ffffffffc02090a6:	bf8f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02090aa:	00006697          	auipc	a3,0x6
ffffffffc02090ae:	ade68693          	addi	a3,a3,-1314 # ffffffffc020eb88 <syscalls+0xb10>
ffffffffc02090b2:	00003617          	auipc	a2,0x3
ffffffffc02090b6:	c1660613          	addi	a2,a2,-1002 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02090ba:	07700593          	li	a1,119
ffffffffc02090be:	00006517          	auipc	a0,0x6
ffffffffc02090c2:	04250513          	addi	a0,a0,66 # ffffffffc020f100 <dev_node_ops+0x250>
ffffffffc02090c6:	bd8f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02090ca <stdout_open>:
ffffffffc02090ca:	4785                	li	a5,1
ffffffffc02090cc:	4501                	li	a0,0
ffffffffc02090ce:	00f59363          	bne	a1,a5,ffffffffc02090d4 <stdout_open+0xa>
ffffffffc02090d2:	8082                	ret
ffffffffc02090d4:	5575                	li	a0,-3
ffffffffc02090d6:	8082                	ret

ffffffffc02090d8 <stdout_close>:
ffffffffc02090d8:	4501                	li	a0,0
ffffffffc02090da:	8082                	ret

ffffffffc02090dc <stdout_ioctl>:
ffffffffc02090dc:	5575                	li	a0,-3
ffffffffc02090de:	8082                	ret

ffffffffc02090e0 <stdout_io>:
ffffffffc02090e0:	ca05                	beqz	a2,ffffffffc0209110 <stdout_io+0x30>
ffffffffc02090e2:	6d9c                	ld	a5,24(a1)
ffffffffc02090e4:	1101                	addi	sp,sp,-32
ffffffffc02090e6:	e822                	sd	s0,16(sp)
ffffffffc02090e8:	e426                	sd	s1,8(sp)
ffffffffc02090ea:	ec06                	sd	ra,24(sp)
ffffffffc02090ec:	6180                	ld	s0,0(a1)
ffffffffc02090ee:	84ae                	mv	s1,a1
ffffffffc02090f0:	cb91                	beqz	a5,ffffffffc0209104 <stdout_io+0x24>
ffffffffc02090f2:	00044503          	lbu	a0,0(s0)
ffffffffc02090f6:	0405                	addi	s0,s0,1
ffffffffc02090f8:	8eaf70ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc02090fc:	6c9c                	ld	a5,24(s1)
ffffffffc02090fe:	17fd                	addi	a5,a5,-1
ffffffffc0209100:	ec9c                	sd	a5,24(s1)
ffffffffc0209102:	fbe5                	bnez	a5,ffffffffc02090f2 <stdout_io+0x12>
ffffffffc0209104:	60e2                	ld	ra,24(sp)
ffffffffc0209106:	6442                	ld	s0,16(sp)
ffffffffc0209108:	64a2                	ld	s1,8(sp)
ffffffffc020910a:	4501                	li	a0,0
ffffffffc020910c:	6105                	addi	sp,sp,32
ffffffffc020910e:	8082                	ret
ffffffffc0209110:	5575                	li	a0,-3
ffffffffc0209112:	8082                	ret

ffffffffc0209114 <dev_init_stdout>:
ffffffffc0209114:	1141                	addi	sp,sp,-16
ffffffffc0209116:	e406                	sd	ra,8(sp)
ffffffffc0209118:	9adff0ef          	jal	ra,ffffffffc0208ac4 <dev_create_inode>
ffffffffc020911c:	c939                	beqz	a0,ffffffffc0209172 <dev_init_stdout+0x5e>
ffffffffc020911e:	4d38                	lw	a4,88(a0)
ffffffffc0209120:	6785                	lui	a5,0x1
ffffffffc0209122:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0209126:	85aa                	mv	a1,a0
ffffffffc0209128:	06f71e63          	bne	a4,a5,ffffffffc02091a4 <dev_init_stdout+0x90>
ffffffffc020912c:	4785                	li	a5,1
ffffffffc020912e:	e51c                	sd	a5,8(a0)
ffffffffc0209130:	00000797          	auipc	a5,0x0
ffffffffc0209134:	f9a78793          	addi	a5,a5,-102 # ffffffffc02090ca <stdout_open>
ffffffffc0209138:	e91c                	sd	a5,16(a0)
ffffffffc020913a:	00000797          	auipc	a5,0x0
ffffffffc020913e:	f9e78793          	addi	a5,a5,-98 # ffffffffc02090d8 <stdout_close>
ffffffffc0209142:	ed1c                	sd	a5,24(a0)
ffffffffc0209144:	00000797          	auipc	a5,0x0
ffffffffc0209148:	f9c78793          	addi	a5,a5,-100 # ffffffffc02090e0 <stdout_io>
ffffffffc020914c:	f11c                	sd	a5,32(a0)
ffffffffc020914e:	00000797          	auipc	a5,0x0
ffffffffc0209152:	f8e78793          	addi	a5,a5,-114 # ffffffffc02090dc <stdout_ioctl>
ffffffffc0209156:	00053023          	sd	zero,0(a0)
ffffffffc020915a:	f51c                	sd	a5,40(a0)
ffffffffc020915c:	4601                	li	a2,0
ffffffffc020915e:	00006517          	auipc	a0,0x6
ffffffffc0209162:	02a50513          	addi	a0,a0,42 # ffffffffc020f188 <dev_node_ops+0x2d8>
ffffffffc0209166:	81aff0ef          	jal	ra,ffffffffc0208180 <vfs_add_dev>
ffffffffc020916a:	e105                	bnez	a0,ffffffffc020918a <dev_init_stdout+0x76>
ffffffffc020916c:	60a2                	ld	ra,8(sp)
ffffffffc020916e:	0141                	addi	sp,sp,16
ffffffffc0209170:	8082                	ret
ffffffffc0209172:	00006617          	auipc	a2,0x6
ffffffffc0209176:	fd660613          	addi	a2,a2,-42 # ffffffffc020f148 <dev_node_ops+0x298>
ffffffffc020917a:	03700593          	li	a1,55
ffffffffc020917e:	00006517          	auipc	a0,0x6
ffffffffc0209182:	fea50513          	addi	a0,a0,-22 # ffffffffc020f168 <dev_node_ops+0x2b8>
ffffffffc0209186:	b18f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020918a:	86aa                	mv	a3,a0
ffffffffc020918c:	00006617          	auipc	a2,0x6
ffffffffc0209190:	00460613          	addi	a2,a2,4 # ffffffffc020f190 <dev_node_ops+0x2e0>
ffffffffc0209194:	03d00593          	li	a1,61
ffffffffc0209198:	00006517          	auipc	a0,0x6
ffffffffc020919c:	fd050513          	addi	a0,a0,-48 # ffffffffc020f168 <dev_node_ops+0x2b8>
ffffffffc02091a0:	afef70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02091a4:	00006697          	auipc	a3,0x6
ffffffffc02091a8:	9e468693          	addi	a3,a3,-1564 # ffffffffc020eb88 <syscalls+0xb10>
ffffffffc02091ac:	00003617          	auipc	a2,0x3
ffffffffc02091b0:	b1c60613          	addi	a2,a2,-1252 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02091b4:	03900593          	li	a1,57
ffffffffc02091b8:	00006517          	auipc	a0,0x6
ffffffffc02091bc:	fb050513          	addi	a0,a0,-80 # ffffffffc020f168 <dev_node_ops+0x2b8>
ffffffffc02091c0:	adef70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02091c4 <bitmap_translate.part.0>:
ffffffffc02091c4:	1141                	addi	sp,sp,-16
ffffffffc02091c6:	00006697          	auipc	a3,0x6
ffffffffc02091ca:	fea68693          	addi	a3,a3,-22 # ffffffffc020f1b0 <dev_node_ops+0x300>
ffffffffc02091ce:	00003617          	auipc	a2,0x3
ffffffffc02091d2:	afa60613          	addi	a2,a2,-1286 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02091d6:	04c00593          	li	a1,76
ffffffffc02091da:	00006517          	auipc	a0,0x6
ffffffffc02091de:	fee50513          	addi	a0,a0,-18 # ffffffffc020f1c8 <dev_node_ops+0x318>
ffffffffc02091e2:	e406                	sd	ra,8(sp)
ffffffffc02091e4:	abaf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02091e8 <bitmap_create>:
ffffffffc02091e8:	7139                	addi	sp,sp,-64
ffffffffc02091ea:	fc06                	sd	ra,56(sp)
ffffffffc02091ec:	f822                	sd	s0,48(sp)
ffffffffc02091ee:	f426                	sd	s1,40(sp)
ffffffffc02091f0:	f04a                	sd	s2,32(sp)
ffffffffc02091f2:	ec4e                	sd	s3,24(sp)
ffffffffc02091f4:	e852                	sd	s4,16(sp)
ffffffffc02091f6:	e456                	sd	s5,8(sp)
ffffffffc02091f8:	c14d                	beqz	a0,ffffffffc020929a <bitmap_create+0xb2>
ffffffffc02091fa:	842a                	mv	s0,a0
ffffffffc02091fc:	4541                	li	a0,16
ffffffffc02091fe:	e15f80ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0209202:	84aa                	mv	s1,a0
ffffffffc0209204:	cd25                	beqz	a0,ffffffffc020927c <bitmap_create+0x94>
ffffffffc0209206:	02041a13          	slli	s4,s0,0x20
ffffffffc020920a:	020a5a13          	srli	s4,s4,0x20
ffffffffc020920e:	01fa0793          	addi	a5,s4,31
ffffffffc0209212:	0057d993          	srli	s3,a5,0x5
ffffffffc0209216:	00299a93          	slli	s5,s3,0x2
ffffffffc020921a:	8556                	mv	a0,s5
ffffffffc020921c:	894e                	mv	s2,s3
ffffffffc020921e:	df5f80ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0209222:	c53d                	beqz	a0,ffffffffc0209290 <bitmap_create+0xa8>
ffffffffc0209224:	0134a223          	sw	s3,4(s1) # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0209228:	c080                	sw	s0,0(s1)
ffffffffc020922a:	8656                	mv	a2,s5
ffffffffc020922c:	0ff00593          	li	a1,255
ffffffffc0209230:	5b6020ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0209234:	e488                	sd	a0,8(s1)
ffffffffc0209236:	0996                	slli	s3,s3,0x5
ffffffffc0209238:	053a0263          	beq	s4,s3,ffffffffc020927c <bitmap_create+0x94>
ffffffffc020923c:	fff9079b          	addiw	a5,s2,-1
ffffffffc0209240:	0057969b          	slliw	a3,a5,0x5
ffffffffc0209244:	0054561b          	srliw	a2,s0,0x5
ffffffffc0209248:	40d4073b          	subw	a4,s0,a3
ffffffffc020924c:	0054541b          	srliw	s0,s0,0x5
ffffffffc0209250:	08f61463          	bne	a2,a5,ffffffffc02092d8 <bitmap_create+0xf0>
ffffffffc0209254:	fff7069b          	addiw	a3,a4,-1
ffffffffc0209258:	47f9                	li	a5,30
ffffffffc020925a:	04d7ef63          	bltu	a5,a3,ffffffffc02092b8 <bitmap_create+0xd0>
ffffffffc020925e:	1402                	slli	s0,s0,0x20
ffffffffc0209260:	8079                	srli	s0,s0,0x1e
ffffffffc0209262:	9522                	add	a0,a0,s0
ffffffffc0209264:	411c                	lw	a5,0(a0)
ffffffffc0209266:	4585                	li	a1,1
ffffffffc0209268:	02000613          	li	a2,32
ffffffffc020926c:	00e596bb          	sllw	a3,a1,a4
ffffffffc0209270:	8fb5                	xor	a5,a5,a3
ffffffffc0209272:	2705                	addiw	a4,a4,1
ffffffffc0209274:	2781                	sext.w	a5,a5
ffffffffc0209276:	fec71be3          	bne	a4,a2,ffffffffc020926c <bitmap_create+0x84>
ffffffffc020927a:	c11c                	sw	a5,0(a0)
ffffffffc020927c:	70e2                	ld	ra,56(sp)
ffffffffc020927e:	7442                	ld	s0,48(sp)
ffffffffc0209280:	7902                	ld	s2,32(sp)
ffffffffc0209282:	69e2                	ld	s3,24(sp)
ffffffffc0209284:	6a42                	ld	s4,16(sp)
ffffffffc0209286:	6aa2                	ld	s5,8(sp)
ffffffffc0209288:	8526                	mv	a0,s1
ffffffffc020928a:	74a2                	ld	s1,40(sp)
ffffffffc020928c:	6121                	addi	sp,sp,64
ffffffffc020928e:	8082                	ret
ffffffffc0209290:	8526                	mv	a0,s1
ffffffffc0209292:	e31f80ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0209296:	4481                	li	s1,0
ffffffffc0209298:	b7d5                	j	ffffffffc020927c <bitmap_create+0x94>
ffffffffc020929a:	00006697          	auipc	a3,0x6
ffffffffc020929e:	f4668693          	addi	a3,a3,-186 # ffffffffc020f1e0 <dev_node_ops+0x330>
ffffffffc02092a2:	00003617          	auipc	a2,0x3
ffffffffc02092a6:	a2660613          	addi	a2,a2,-1498 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02092aa:	45d5                	li	a1,21
ffffffffc02092ac:	00006517          	auipc	a0,0x6
ffffffffc02092b0:	f1c50513          	addi	a0,a0,-228 # ffffffffc020f1c8 <dev_node_ops+0x318>
ffffffffc02092b4:	9eaf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02092b8:	00006697          	auipc	a3,0x6
ffffffffc02092bc:	f6868693          	addi	a3,a3,-152 # ffffffffc020f220 <dev_node_ops+0x370>
ffffffffc02092c0:	00003617          	auipc	a2,0x3
ffffffffc02092c4:	a0860613          	addi	a2,a2,-1528 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02092c8:	02b00593          	li	a1,43
ffffffffc02092cc:	00006517          	auipc	a0,0x6
ffffffffc02092d0:	efc50513          	addi	a0,a0,-260 # ffffffffc020f1c8 <dev_node_ops+0x318>
ffffffffc02092d4:	9caf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02092d8:	00006697          	auipc	a3,0x6
ffffffffc02092dc:	f3068693          	addi	a3,a3,-208 # ffffffffc020f208 <dev_node_ops+0x358>
ffffffffc02092e0:	00003617          	auipc	a2,0x3
ffffffffc02092e4:	9e860613          	addi	a2,a2,-1560 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02092e8:	02a00593          	li	a1,42
ffffffffc02092ec:	00006517          	auipc	a0,0x6
ffffffffc02092f0:	edc50513          	addi	a0,a0,-292 # ffffffffc020f1c8 <dev_node_ops+0x318>
ffffffffc02092f4:	9aaf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02092f8 <bitmap_alloc>:
ffffffffc02092f8:	4150                	lw	a2,4(a0)
ffffffffc02092fa:	651c                	ld	a5,8(a0)
ffffffffc02092fc:	c231                	beqz	a2,ffffffffc0209340 <bitmap_alloc+0x48>
ffffffffc02092fe:	4701                	li	a4,0
ffffffffc0209300:	a029                	j	ffffffffc020930a <bitmap_alloc+0x12>
ffffffffc0209302:	2705                	addiw	a4,a4,1
ffffffffc0209304:	0791                	addi	a5,a5,4
ffffffffc0209306:	02e60d63          	beq	a2,a4,ffffffffc0209340 <bitmap_alloc+0x48>
ffffffffc020930a:	4394                	lw	a3,0(a5)
ffffffffc020930c:	dafd                	beqz	a3,ffffffffc0209302 <bitmap_alloc+0xa>
ffffffffc020930e:	4501                	li	a0,0
ffffffffc0209310:	4885                	li	a7,1
ffffffffc0209312:	8e36                	mv	t3,a3
ffffffffc0209314:	02000313          	li	t1,32
ffffffffc0209318:	a021                	j	ffffffffc0209320 <bitmap_alloc+0x28>
ffffffffc020931a:	2505                	addiw	a0,a0,1
ffffffffc020931c:	02650463          	beq	a0,t1,ffffffffc0209344 <bitmap_alloc+0x4c>
ffffffffc0209320:	00a8983b          	sllw	a6,a7,a0
ffffffffc0209324:	0106f633          	and	a2,a3,a6
ffffffffc0209328:	2601                	sext.w	a2,a2
ffffffffc020932a:	da65                	beqz	a2,ffffffffc020931a <bitmap_alloc+0x22>
ffffffffc020932c:	010e4833          	xor	a6,t3,a6
ffffffffc0209330:	0057171b          	slliw	a4,a4,0x5
ffffffffc0209334:	9f29                	addw	a4,a4,a0
ffffffffc0209336:	0107a023          	sw	a6,0(a5)
ffffffffc020933a:	c198                	sw	a4,0(a1)
ffffffffc020933c:	4501                	li	a0,0
ffffffffc020933e:	8082                	ret
ffffffffc0209340:	5571                	li	a0,-4
ffffffffc0209342:	8082                	ret
ffffffffc0209344:	1141                	addi	sp,sp,-16
ffffffffc0209346:	00004697          	auipc	a3,0x4
ffffffffc020934a:	a3268693          	addi	a3,a3,-1486 # ffffffffc020cd78 <default_pmm_manager+0x5a8>
ffffffffc020934e:	00003617          	auipc	a2,0x3
ffffffffc0209352:	97a60613          	addi	a2,a2,-1670 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209356:	04300593          	li	a1,67
ffffffffc020935a:	00006517          	auipc	a0,0x6
ffffffffc020935e:	e6e50513          	addi	a0,a0,-402 # ffffffffc020f1c8 <dev_node_ops+0x318>
ffffffffc0209362:	e406                	sd	ra,8(sp)
ffffffffc0209364:	93af70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209368 <bitmap_test>:
ffffffffc0209368:	411c                	lw	a5,0(a0)
ffffffffc020936a:	00f5ff63          	bgeu	a1,a5,ffffffffc0209388 <bitmap_test+0x20>
ffffffffc020936e:	651c                	ld	a5,8(a0)
ffffffffc0209370:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0209374:	070a                	slli	a4,a4,0x2
ffffffffc0209376:	97ba                	add	a5,a5,a4
ffffffffc0209378:	4388                	lw	a0,0(a5)
ffffffffc020937a:	4785                	li	a5,1
ffffffffc020937c:	00b795bb          	sllw	a1,a5,a1
ffffffffc0209380:	8d6d                	and	a0,a0,a1
ffffffffc0209382:	1502                	slli	a0,a0,0x20
ffffffffc0209384:	9101                	srli	a0,a0,0x20
ffffffffc0209386:	8082                	ret
ffffffffc0209388:	1141                	addi	sp,sp,-16
ffffffffc020938a:	e406                	sd	ra,8(sp)
ffffffffc020938c:	e39ff0ef          	jal	ra,ffffffffc02091c4 <bitmap_translate.part.0>

ffffffffc0209390 <bitmap_free>:
ffffffffc0209390:	411c                	lw	a5,0(a0)
ffffffffc0209392:	1141                	addi	sp,sp,-16
ffffffffc0209394:	e406                	sd	ra,8(sp)
ffffffffc0209396:	02f5f463          	bgeu	a1,a5,ffffffffc02093be <bitmap_free+0x2e>
ffffffffc020939a:	651c                	ld	a5,8(a0)
ffffffffc020939c:	0055d71b          	srliw	a4,a1,0x5
ffffffffc02093a0:	070a                	slli	a4,a4,0x2
ffffffffc02093a2:	97ba                	add	a5,a5,a4
ffffffffc02093a4:	4398                	lw	a4,0(a5)
ffffffffc02093a6:	4685                	li	a3,1
ffffffffc02093a8:	00b695bb          	sllw	a1,a3,a1
ffffffffc02093ac:	00b776b3          	and	a3,a4,a1
ffffffffc02093b0:	2681                	sext.w	a3,a3
ffffffffc02093b2:	ea81                	bnez	a3,ffffffffc02093c2 <bitmap_free+0x32>
ffffffffc02093b4:	60a2                	ld	ra,8(sp)
ffffffffc02093b6:	8f4d                	or	a4,a4,a1
ffffffffc02093b8:	c398                	sw	a4,0(a5)
ffffffffc02093ba:	0141                	addi	sp,sp,16
ffffffffc02093bc:	8082                	ret
ffffffffc02093be:	e07ff0ef          	jal	ra,ffffffffc02091c4 <bitmap_translate.part.0>
ffffffffc02093c2:	00006697          	auipc	a3,0x6
ffffffffc02093c6:	e8668693          	addi	a3,a3,-378 # ffffffffc020f248 <dev_node_ops+0x398>
ffffffffc02093ca:	00003617          	auipc	a2,0x3
ffffffffc02093ce:	8fe60613          	addi	a2,a2,-1794 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02093d2:	05f00593          	li	a1,95
ffffffffc02093d6:	00006517          	auipc	a0,0x6
ffffffffc02093da:	df250513          	addi	a0,a0,-526 # ffffffffc020f1c8 <dev_node_ops+0x318>
ffffffffc02093de:	8c0f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02093e2 <bitmap_destroy>:
ffffffffc02093e2:	1141                	addi	sp,sp,-16
ffffffffc02093e4:	e022                	sd	s0,0(sp)
ffffffffc02093e6:	842a                	mv	s0,a0
ffffffffc02093e8:	6508                	ld	a0,8(a0)
ffffffffc02093ea:	e406                	sd	ra,8(sp)
ffffffffc02093ec:	cd7f80ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc02093f0:	8522                	mv	a0,s0
ffffffffc02093f2:	6402                	ld	s0,0(sp)
ffffffffc02093f4:	60a2                	ld	ra,8(sp)
ffffffffc02093f6:	0141                	addi	sp,sp,16
ffffffffc02093f8:	ccbf806f          	j	ffffffffc02020c2 <kfree>

ffffffffc02093fc <bitmap_getdata>:
ffffffffc02093fc:	c589                	beqz	a1,ffffffffc0209406 <bitmap_getdata+0xa>
ffffffffc02093fe:	00456783          	lwu	a5,4(a0)
ffffffffc0209402:	078a                	slli	a5,a5,0x2
ffffffffc0209404:	e19c                	sd	a5,0(a1)
ffffffffc0209406:	6508                	ld	a0,8(a0)
ffffffffc0209408:	8082                	ret

ffffffffc020940a <sfs_init>:
ffffffffc020940a:	1141                	addi	sp,sp,-16
ffffffffc020940c:	00006517          	auipc	a0,0x6
ffffffffc0209410:	cac50513          	addi	a0,a0,-852 # ffffffffc020f0b8 <dev_node_ops+0x208>
ffffffffc0209414:	e406                	sd	ra,8(sp)
ffffffffc0209416:	554000ef          	jal	ra,ffffffffc020996a <sfs_mount>
ffffffffc020941a:	e501                	bnez	a0,ffffffffc0209422 <sfs_init+0x18>
ffffffffc020941c:	60a2                	ld	ra,8(sp)
ffffffffc020941e:	0141                	addi	sp,sp,16
ffffffffc0209420:	8082                	ret
ffffffffc0209422:	86aa                	mv	a3,a0
ffffffffc0209424:	00006617          	auipc	a2,0x6
ffffffffc0209428:	e3460613          	addi	a2,a2,-460 # ffffffffc020f258 <dev_node_ops+0x3a8>
ffffffffc020942c:	45c1                	li	a1,16
ffffffffc020942e:	00006517          	auipc	a0,0x6
ffffffffc0209432:	e4a50513          	addi	a0,a0,-438 # ffffffffc020f278 <dev_node_ops+0x3c8>
ffffffffc0209436:	868f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020943a <sfs_unmount>:
ffffffffc020943a:	1141                	addi	sp,sp,-16
ffffffffc020943c:	e406                	sd	ra,8(sp)
ffffffffc020943e:	e022                	sd	s0,0(sp)
ffffffffc0209440:	cd1d                	beqz	a0,ffffffffc020947e <sfs_unmount+0x44>
ffffffffc0209442:	0b052783          	lw	a5,176(a0)
ffffffffc0209446:	842a                	mv	s0,a0
ffffffffc0209448:	eb9d                	bnez	a5,ffffffffc020947e <sfs_unmount+0x44>
ffffffffc020944a:	7158                	ld	a4,160(a0)
ffffffffc020944c:	09850793          	addi	a5,a0,152
ffffffffc0209450:	02f71563          	bne	a4,a5,ffffffffc020947a <sfs_unmount+0x40>
ffffffffc0209454:	613c                	ld	a5,64(a0)
ffffffffc0209456:	e7a1                	bnez	a5,ffffffffc020949e <sfs_unmount+0x64>
ffffffffc0209458:	7d08                	ld	a0,56(a0)
ffffffffc020945a:	f89ff0ef          	jal	ra,ffffffffc02093e2 <bitmap_destroy>
ffffffffc020945e:	6428                	ld	a0,72(s0)
ffffffffc0209460:	c63f80ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0209464:	7448                	ld	a0,168(s0)
ffffffffc0209466:	c5df80ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc020946a:	8522                	mv	a0,s0
ffffffffc020946c:	c57f80ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0209470:	4501                	li	a0,0
ffffffffc0209472:	60a2                	ld	ra,8(sp)
ffffffffc0209474:	6402                	ld	s0,0(sp)
ffffffffc0209476:	0141                	addi	sp,sp,16
ffffffffc0209478:	8082                	ret
ffffffffc020947a:	5545                	li	a0,-15
ffffffffc020947c:	bfdd                	j	ffffffffc0209472 <sfs_unmount+0x38>
ffffffffc020947e:	00006697          	auipc	a3,0x6
ffffffffc0209482:	e1268693          	addi	a3,a3,-494 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc0209486:	00003617          	auipc	a2,0x3
ffffffffc020948a:	84260613          	addi	a2,a2,-1982 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020948e:	04100593          	li	a1,65
ffffffffc0209492:	00006517          	auipc	a0,0x6
ffffffffc0209496:	e2e50513          	addi	a0,a0,-466 # ffffffffc020f2c0 <dev_node_ops+0x410>
ffffffffc020949a:	804f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020949e:	00006697          	auipc	a3,0x6
ffffffffc02094a2:	e3a68693          	addi	a3,a3,-454 # ffffffffc020f2d8 <dev_node_ops+0x428>
ffffffffc02094a6:	00003617          	auipc	a2,0x3
ffffffffc02094aa:	82260613          	addi	a2,a2,-2014 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02094ae:	04500593          	li	a1,69
ffffffffc02094b2:	00006517          	auipc	a0,0x6
ffffffffc02094b6:	e0e50513          	addi	a0,a0,-498 # ffffffffc020f2c0 <dev_node_ops+0x410>
ffffffffc02094ba:	fe5f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02094be <sfs_cleanup>:
ffffffffc02094be:	1101                	addi	sp,sp,-32
ffffffffc02094c0:	ec06                	sd	ra,24(sp)
ffffffffc02094c2:	e822                	sd	s0,16(sp)
ffffffffc02094c4:	e426                	sd	s1,8(sp)
ffffffffc02094c6:	e04a                	sd	s2,0(sp)
ffffffffc02094c8:	c525                	beqz	a0,ffffffffc0209530 <sfs_cleanup+0x72>
ffffffffc02094ca:	0b052783          	lw	a5,176(a0)
ffffffffc02094ce:	84aa                	mv	s1,a0
ffffffffc02094d0:	e3a5                	bnez	a5,ffffffffc0209530 <sfs_cleanup+0x72>
ffffffffc02094d2:	4158                	lw	a4,4(a0)
ffffffffc02094d4:	4514                	lw	a3,8(a0)
ffffffffc02094d6:	00c50913          	addi	s2,a0,12
ffffffffc02094da:	85ca                	mv	a1,s2
ffffffffc02094dc:	40d7063b          	subw	a2,a4,a3
ffffffffc02094e0:	00006517          	auipc	a0,0x6
ffffffffc02094e4:	e1050513          	addi	a0,a0,-496 # ffffffffc020f2f0 <dev_node_ops+0x440>
ffffffffc02094e8:	cbff60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02094ec:	02000413          	li	s0,32
ffffffffc02094f0:	a019                	j	ffffffffc02094f6 <sfs_cleanup+0x38>
ffffffffc02094f2:	347d                	addiw	s0,s0,-1
ffffffffc02094f4:	c819                	beqz	s0,ffffffffc020950a <sfs_cleanup+0x4c>
ffffffffc02094f6:	7cdc                	ld	a5,184(s1)
ffffffffc02094f8:	8526                	mv	a0,s1
ffffffffc02094fa:	9782                	jalr	a5
ffffffffc02094fc:	f97d                	bnez	a0,ffffffffc02094f2 <sfs_cleanup+0x34>
ffffffffc02094fe:	60e2                	ld	ra,24(sp)
ffffffffc0209500:	6442                	ld	s0,16(sp)
ffffffffc0209502:	64a2                	ld	s1,8(sp)
ffffffffc0209504:	6902                	ld	s2,0(sp)
ffffffffc0209506:	6105                	addi	sp,sp,32
ffffffffc0209508:	8082                	ret
ffffffffc020950a:	6442                	ld	s0,16(sp)
ffffffffc020950c:	60e2                	ld	ra,24(sp)
ffffffffc020950e:	64a2                	ld	s1,8(sp)
ffffffffc0209510:	86ca                	mv	a3,s2
ffffffffc0209512:	6902                	ld	s2,0(sp)
ffffffffc0209514:	872a                	mv	a4,a0
ffffffffc0209516:	00006617          	auipc	a2,0x6
ffffffffc020951a:	dfa60613          	addi	a2,a2,-518 # ffffffffc020f310 <dev_node_ops+0x460>
ffffffffc020951e:	05f00593          	li	a1,95
ffffffffc0209522:	00006517          	auipc	a0,0x6
ffffffffc0209526:	d9e50513          	addi	a0,a0,-610 # ffffffffc020f2c0 <dev_node_ops+0x410>
ffffffffc020952a:	6105                	addi	sp,sp,32
ffffffffc020952c:	fdbf606f          	j	ffffffffc0200506 <__warn>
ffffffffc0209530:	00006697          	auipc	a3,0x6
ffffffffc0209534:	d6068693          	addi	a3,a3,-672 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc0209538:	00002617          	auipc	a2,0x2
ffffffffc020953c:	79060613          	addi	a2,a2,1936 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209540:	05400593          	li	a1,84
ffffffffc0209544:	00006517          	auipc	a0,0x6
ffffffffc0209548:	d7c50513          	addi	a0,a0,-644 # ffffffffc020f2c0 <dev_node_ops+0x410>
ffffffffc020954c:	f53f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209550 <sfs_sync>:
ffffffffc0209550:	7179                	addi	sp,sp,-48
ffffffffc0209552:	f406                	sd	ra,40(sp)
ffffffffc0209554:	f022                	sd	s0,32(sp)
ffffffffc0209556:	ec26                	sd	s1,24(sp)
ffffffffc0209558:	e84a                	sd	s2,16(sp)
ffffffffc020955a:	e44e                	sd	s3,8(sp)
ffffffffc020955c:	e052                	sd	s4,0(sp)
ffffffffc020955e:	cd4d                	beqz	a0,ffffffffc0209618 <sfs_sync+0xc8>
ffffffffc0209560:	0b052783          	lw	a5,176(a0)
ffffffffc0209564:	8a2a                	mv	s4,a0
ffffffffc0209566:	ebcd                	bnez	a5,ffffffffc0209618 <sfs_sync+0xc8>
ffffffffc0209568:	52b010ef          	jal	ra,ffffffffc020b292 <lock_sfs_fs>
ffffffffc020956c:	0a0a3403          	ld	s0,160(s4)
ffffffffc0209570:	098a0913          	addi	s2,s4,152
ffffffffc0209574:	02890763          	beq	s2,s0,ffffffffc02095a2 <sfs_sync+0x52>
ffffffffc0209578:	00004997          	auipc	s3,0x4
ffffffffc020957c:	2d098993          	addi	s3,s3,720 # ffffffffc020d848 <default_pmm_manager+0x1078>
ffffffffc0209580:	7c1c                	ld	a5,56(s0)
ffffffffc0209582:	fc840493          	addi	s1,s0,-56
ffffffffc0209586:	cbb5                	beqz	a5,ffffffffc02095fa <sfs_sync+0xaa>
ffffffffc0209588:	7b9c                	ld	a5,48(a5)
ffffffffc020958a:	cba5                	beqz	a5,ffffffffc02095fa <sfs_sync+0xaa>
ffffffffc020958c:	85ce                	mv	a1,s3
ffffffffc020958e:	8526                	mv	a0,s1
ffffffffc0209590:	e28fe0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0209594:	7c1c                	ld	a5,56(s0)
ffffffffc0209596:	8526                	mv	a0,s1
ffffffffc0209598:	7b9c                	ld	a5,48(a5)
ffffffffc020959a:	9782                	jalr	a5
ffffffffc020959c:	6400                	ld	s0,8(s0)
ffffffffc020959e:	fe8911e3          	bne	s2,s0,ffffffffc0209580 <sfs_sync+0x30>
ffffffffc02095a2:	8552                	mv	a0,s4
ffffffffc02095a4:	4ff010ef          	jal	ra,ffffffffc020b2a2 <unlock_sfs_fs>
ffffffffc02095a8:	040a3783          	ld	a5,64(s4)
ffffffffc02095ac:	4501                	li	a0,0
ffffffffc02095ae:	eb89                	bnez	a5,ffffffffc02095c0 <sfs_sync+0x70>
ffffffffc02095b0:	70a2                	ld	ra,40(sp)
ffffffffc02095b2:	7402                	ld	s0,32(sp)
ffffffffc02095b4:	64e2                	ld	s1,24(sp)
ffffffffc02095b6:	6942                	ld	s2,16(sp)
ffffffffc02095b8:	69a2                	ld	s3,8(sp)
ffffffffc02095ba:	6a02                	ld	s4,0(sp)
ffffffffc02095bc:	6145                	addi	sp,sp,48
ffffffffc02095be:	8082                	ret
ffffffffc02095c0:	040a3023          	sd	zero,64(s4)
ffffffffc02095c4:	8552                	mv	a0,s4
ffffffffc02095c6:	3b1010ef          	jal	ra,ffffffffc020b176 <sfs_sync_super>
ffffffffc02095ca:	cd01                	beqz	a0,ffffffffc02095e2 <sfs_sync+0x92>
ffffffffc02095cc:	70a2                	ld	ra,40(sp)
ffffffffc02095ce:	7402                	ld	s0,32(sp)
ffffffffc02095d0:	4785                	li	a5,1
ffffffffc02095d2:	04fa3023          	sd	a5,64(s4)
ffffffffc02095d6:	64e2                	ld	s1,24(sp)
ffffffffc02095d8:	6942                	ld	s2,16(sp)
ffffffffc02095da:	69a2                	ld	s3,8(sp)
ffffffffc02095dc:	6a02                	ld	s4,0(sp)
ffffffffc02095de:	6145                	addi	sp,sp,48
ffffffffc02095e0:	8082                	ret
ffffffffc02095e2:	8552                	mv	a0,s4
ffffffffc02095e4:	3d9010ef          	jal	ra,ffffffffc020b1bc <sfs_sync_freemap>
ffffffffc02095e8:	f175                	bnez	a0,ffffffffc02095cc <sfs_sync+0x7c>
ffffffffc02095ea:	70a2                	ld	ra,40(sp)
ffffffffc02095ec:	7402                	ld	s0,32(sp)
ffffffffc02095ee:	64e2                	ld	s1,24(sp)
ffffffffc02095f0:	6942                	ld	s2,16(sp)
ffffffffc02095f2:	69a2                	ld	s3,8(sp)
ffffffffc02095f4:	6a02                	ld	s4,0(sp)
ffffffffc02095f6:	6145                	addi	sp,sp,48
ffffffffc02095f8:	8082                	ret
ffffffffc02095fa:	00004697          	auipc	a3,0x4
ffffffffc02095fe:	1fe68693          	addi	a3,a3,510 # ffffffffc020d7f8 <default_pmm_manager+0x1028>
ffffffffc0209602:	00002617          	auipc	a2,0x2
ffffffffc0209606:	6c660613          	addi	a2,a2,1734 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020960a:	45ed                	li	a1,27
ffffffffc020960c:	00006517          	auipc	a0,0x6
ffffffffc0209610:	cb450513          	addi	a0,a0,-844 # ffffffffc020f2c0 <dev_node_ops+0x410>
ffffffffc0209614:	e8bf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209618:	00006697          	auipc	a3,0x6
ffffffffc020961c:	c7868693          	addi	a3,a3,-904 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc0209620:	00002617          	auipc	a2,0x2
ffffffffc0209624:	6a860613          	addi	a2,a2,1704 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209628:	45d5                	li	a1,21
ffffffffc020962a:	00006517          	auipc	a0,0x6
ffffffffc020962e:	c9650513          	addi	a0,a0,-874 # ffffffffc020f2c0 <dev_node_ops+0x410>
ffffffffc0209632:	e6df60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209636 <sfs_get_root>:
ffffffffc0209636:	1101                	addi	sp,sp,-32
ffffffffc0209638:	ec06                	sd	ra,24(sp)
ffffffffc020963a:	cd09                	beqz	a0,ffffffffc0209654 <sfs_get_root+0x1e>
ffffffffc020963c:	0b052783          	lw	a5,176(a0)
ffffffffc0209640:	eb91                	bnez	a5,ffffffffc0209654 <sfs_get_root+0x1e>
ffffffffc0209642:	4605                	li	a2,1
ffffffffc0209644:	002c                	addi	a1,sp,8
ffffffffc0209646:	362010ef          	jal	ra,ffffffffc020a9a8 <sfs_load_inode>
ffffffffc020964a:	e50d                	bnez	a0,ffffffffc0209674 <sfs_get_root+0x3e>
ffffffffc020964c:	60e2                	ld	ra,24(sp)
ffffffffc020964e:	6522                	ld	a0,8(sp)
ffffffffc0209650:	6105                	addi	sp,sp,32
ffffffffc0209652:	8082                	ret
ffffffffc0209654:	00006697          	auipc	a3,0x6
ffffffffc0209658:	c3c68693          	addi	a3,a3,-964 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc020965c:	00002617          	auipc	a2,0x2
ffffffffc0209660:	66c60613          	addi	a2,a2,1644 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209664:	03600593          	li	a1,54
ffffffffc0209668:	00006517          	auipc	a0,0x6
ffffffffc020966c:	c5850513          	addi	a0,a0,-936 # ffffffffc020f2c0 <dev_node_ops+0x410>
ffffffffc0209670:	e2ff60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209674:	86aa                	mv	a3,a0
ffffffffc0209676:	00006617          	auipc	a2,0x6
ffffffffc020967a:	cba60613          	addi	a2,a2,-838 # ffffffffc020f330 <dev_node_ops+0x480>
ffffffffc020967e:	03700593          	li	a1,55
ffffffffc0209682:	00006517          	auipc	a0,0x6
ffffffffc0209686:	c3e50513          	addi	a0,a0,-962 # ffffffffc020f2c0 <dev_node_ops+0x410>
ffffffffc020968a:	e15f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020968e <sfs_do_mount>:
ffffffffc020968e:	6518                	ld	a4,8(a0)
ffffffffc0209690:	7171                	addi	sp,sp,-176
ffffffffc0209692:	f506                	sd	ra,168(sp)
ffffffffc0209694:	f122                	sd	s0,160(sp)
ffffffffc0209696:	ed26                	sd	s1,152(sp)
ffffffffc0209698:	e94a                	sd	s2,144(sp)
ffffffffc020969a:	e54e                	sd	s3,136(sp)
ffffffffc020969c:	e152                	sd	s4,128(sp)
ffffffffc020969e:	fcd6                	sd	s5,120(sp)
ffffffffc02096a0:	f8da                	sd	s6,112(sp)
ffffffffc02096a2:	f4de                	sd	s7,104(sp)
ffffffffc02096a4:	f0e2                	sd	s8,96(sp)
ffffffffc02096a6:	ece6                	sd	s9,88(sp)
ffffffffc02096a8:	e8ea                	sd	s10,80(sp)
ffffffffc02096aa:	e4ee                	sd	s11,72(sp)
ffffffffc02096ac:	6785                	lui	a5,0x1
ffffffffc02096ae:	24f71663          	bne	a4,a5,ffffffffc02098fa <sfs_do_mount+0x26c>
ffffffffc02096b2:	892a                	mv	s2,a0
ffffffffc02096b4:	4501                	li	a0,0
ffffffffc02096b6:	8aae                	mv	s5,a1
ffffffffc02096b8:	f00fe0ef          	jal	ra,ffffffffc0207db8 <__alloc_fs>
ffffffffc02096bc:	842a                	mv	s0,a0
ffffffffc02096be:	24050463          	beqz	a0,ffffffffc0209906 <sfs_do_mount+0x278>
ffffffffc02096c2:	0b052b03          	lw	s6,176(a0)
ffffffffc02096c6:	260b1263          	bnez	s6,ffffffffc020992a <sfs_do_mount+0x29c>
ffffffffc02096ca:	03253823          	sd	s2,48(a0)
ffffffffc02096ce:	6505                	lui	a0,0x1
ffffffffc02096d0:	943f80ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc02096d4:	e428                	sd	a0,72(s0)
ffffffffc02096d6:	84aa                	mv	s1,a0
ffffffffc02096d8:	16050363          	beqz	a0,ffffffffc020983e <sfs_do_mount+0x1b0>
ffffffffc02096dc:	85aa                	mv	a1,a0
ffffffffc02096de:	4681                	li	a3,0
ffffffffc02096e0:	6605                	lui	a2,0x1
ffffffffc02096e2:	1008                	addi	a0,sp,32
ffffffffc02096e4:	f51fb0ef          	jal	ra,ffffffffc0205634 <iobuf_init>
ffffffffc02096e8:	02093783          	ld	a5,32(s2)
ffffffffc02096ec:	85aa                	mv	a1,a0
ffffffffc02096ee:	4601                	li	a2,0
ffffffffc02096f0:	854a                	mv	a0,s2
ffffffffc02096f2:	9782                	jalr	a5
ffffffffc02096f4:	8a2a                	mv	s4,a0
ffffffffc02096f6:	10051e63          	bnez	a0,ffffffffc0209812 <sfs_do_mount+0x184>
ffffffffc02096fa:	408c                	lw	a1,0(s1)
ffffffffc02096fc:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc0209700:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc0209704:	14c59863          	bne	a1,a2,ffffffffc0209854 <sfs_do_mount+0x1c6>
ffffffffc0209708:	40dc                	lw	a5,4(s1)
ffffffffc020970a:	00093603          	ld	a2,0(s2)
ffffffffc020970e:	02079713          	slli	a4,a5,0x20
ffffffffc0209712:	9301                	srli	a4,a4,0x20
ffffffffc0209714:	12e66763          	bltu	a2,a4,ffffffffc0209842 <sfs_do_mount+0x1b4>
ffffffffc0209718:	020485a3          	sb	zero,43(s1)
ffffffffc020971c:	0084af03          	lw	t5,8(s1)
ffffffffc0209720:	00c4ae83          	lw	t4,12(s1)
ffffffffc0209724:	0104ae03          	lw	t3,16(s1)
ffffffffc0209728:	0144a303          	lw	t1,20(s1)
ffffffffc020972c:	0184a883          	lw	a7,24(s1)
ffffffffc0209730:	01c4a803          	lw	a6,28(s1)
ffffffffc0209734:	5090                	lw	a2,32(s1)
ffffffffc0209736:	50d4                	lw	a3,36(s1)
ffffffffc0209738:	5498                	lw	a4,40(s1)
ffffffffc020973a:	6511                	lui	a0,0x4
ffffffffc020973c:	c00c                	sw	a1,0(s0)
ffffffffc020973e:	c05c                	sw	a5,4(s0)
ffffffffc0209740:	01e42423          	sw	t5,8(s0)
ffffffffc0209744:	01d42623          	sw	t4,12(s0)
ffffffffc0209748:	01c42823          	sw	t3,16(s0)
ffffffffc020974c:	00642a23          	sw	t1,20(s0)
ffffffffc0209750:	01142c23          	sw	a7,24(s0)
ffffffffc0209754:	01042e23          	sw	a6,28(s0)
ffffffffc0209758:	d010                	sw	a2,32(s0)
ffffffffc020975a:	d054                	sw	a3,36(s0)
ffffffffc020975c:	d418                	sw	a4,40(s0)
ffffffffc020975e:	8b5f80ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc0209762:	f448                	sd	a0,168(s0)
ffffffffc0209764:	8c2a                	mv	s8,a0
ffffffffc0209766:	18050c63          	beqz	a0,ffffffffc02098fe <sfs_do_mount+0x270>
ffffffffc020976a:	6711                	lui	a4,0x4
ffffffffc020976c:	87aa                	mv	a5,a0
ffffffffc020976e:	972a                	add	a4,a4,a0
ffffffffc0209770:	e79c                	sd	a5,8(a5)
ffffffffc0209772:	e39c                	sd	a5,0(a5)
ffffffffc0209774:	07c1                	addi	a5,a5,16
ffffffffc0209776:	fee79de3          	bne	a5,a4,ffffffffc0209770 <sfs_do_mount+0xe2>
ffffffffc020977a:	0044eb83          	lwu	s7,4(s1)
ffffffffc020977e:	67a1                	lui	a5,0x8
ffffffffc0209780:	fff78993          	addi	s3,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc0209784:	9bce                	add	s7,s7,s3
ffffffffc0209786:	77e1                	lui	a5,0xffff8
ffffffffc0209788:	00fbfbb3          	and	s7,s7,a5
ffffffffc020978c:	2b81                	sext.w	s7,s7
ffffffffc020978e:	855e                	mv	a0,s7
ffffffffc0209790:	a59ff0ef          	jal	ra,ffffffffc02091e8 <bitmap_create>
ffffffffc0209794:	fc08                	sd	a0,56(s0)
ffffffffc0209796:	8d2a                	mv	s10,a0
ffffffffc0209798:	14050f63          	beqz	a0,ffffffffc02098f6 <sfs_do_mount+0x268>
ffffffffc020979c:	0044e783          	lwu	a5,4(s1)
ffffffffc02097a0:	082c                	addi	a1,sp,24
ffffffffc02097a2:	97ce                	add	a5,a5,s3
ffffffffc02097a4:	00f7d713          	srli	a4,a5,0xf
ffffffffc02097a8:	e43a                	sd	a4,8(sp)
ffffffffc02097aa:	40f7d993          	srai	s3,a5,0xf
ffffffffc02097ae:	c4fff0ef          	jal	ra,ffffffffc02093fc <bitmap_getdata>
ffffffffc02097b2:	14050c63          	beqz	a0,ffffffffc020990a <sfs_do_mount+0x27c>
ffffffffc02097b6:	00c9979b          	slliw	a5,s3,0xc
ffffffffc02097ba:	66e2                	ld	a3,24(sp)
ffffffffc02097bc:	1782                	slli	a5,a5,0x20
ffffffffc02097be:	9381                	srli	a5,a5,0x20
ffffffffc02097c0:	14d79563          	bne	a5,a3,ffffffffc020990a <sfs_do_mount+0x27c>
ffffffffc02097c4:	6722                	ld	a4,8(sp)
ffffffffc02097c6:	6d89                	lui	s11,0x2
ffffffffc02097c8:	89aa                	mv	s3,a0
ffffffffc02097ca:	00c71c93          	slli	s9,a4,0xc
ffffffffc02097ce:	9caa                	add	s9,s9,a0
ffffffffc02097d0:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02097d4:	e711                	bnez	a4,ffffffffc02097e0 <sfs_do_mount+0x152>
ffffffffc02097d6:	a079                	j	ffffffffc0209864 <sfs_do_mount+0x1d6>
ffffffffc02097d8:	6785                	lui	a5,0x1
ffffffffc02097da:	99be                	add	s3,s3,a5
ffffffffc02097dc:	093c8463          	beq	s9,s3,ffffffffc0209864 <sfs_do_mount+0x1d6>
ffffffffc02097e0:	013d86bb          	addw	a3,s11,s3
ffffffffc02097e4:	1682                	slli	a3,a3,0x20
ffffffffc02097e6:	6605                	lui	a2,0x1
ffffffffc02097e8:	85ce                	mv	a1,s3
ffffffffc02097ea:	9281                	srli	a3,a3,0x20
ffffffffc02097ec:	1008                	addi	a0,sp,32
ffffffffc02097ee:	e47fb0ef          	jal	ra,ffffffffc0205634 <iobuf_init>
ffffffffc02097f2:	02093783          	ld	a5,32(s2)
ffffffffc02097f6:	85aa                	mv	a1,a0
ffffffffc02097f8:	4601                	li	a2,0
ffffffffc02097fa:	854a                	mv	a0,s2
ffffffffc02097fc:	9782                	jalr	a5
ffffffffc02097fe:	dd69                	beqz	a0,ffffffffc02097d8 <sfs_do_mount+0x14a>
ffffffffc0209800:	e42a                	sd	a0,8(sp)
ffffffffc0209802:	856a                	mv	a0,s10
ffffffffc0209804:	bdfff0ef          	jal	ra,ffffffffc02093e2 <bitmap_destroy>
ffffffffc0209808:	67a2                	ld	a5,8(sp)
ffffffffc020980a:	8a3e                	mv	s4,a5
ffffffffc020980c:	8562                	mv	a0,s8
ffffffffc020980e:	8b5f80ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0209812:	8526                	mv	a0,s1
ffffffffc0209814:	8aff80ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0209818:	8522                	mv	a0,s0
ffffffffc020981a:	8a9f80ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc020981e:	70aa                	ld	ra,168(sp)
ffffffffc0209820:	740a                	ld	s0,160(sp)
ffffffffc0209822:	64ea                	ld	s1,152(sp)
ffffffffc0209824:	694a                	ld	s2,144(sp)
ffffffffc0209826:	69aa                	ld	s3,136(sp)
ffffffffc0209828:	7ae6                	ld	s5,120(sp)
ffffffffc020982a:	7b46                	ld	s6,112(sp)
ffffffffc020982c:	7ba6                	ld	s7,104(sp)
ffffffffc020982e:	7c06                	ld	s8,96(sp)
ffffffffc0209830:	6ce6                	ld	s9,88(sp)
ffffffffc0209832:	6d46                	ld	s10,80(sp)
ffffffffc0209834:	6da6                	ld	s11,72(sp)
ffffffffc0209836:	8552                	mv	a0,s4
ffffffffc0209838:	6a0a                	ld	s4,128(sp)
ffffffffc020983a:	614d                	addi	sp,sp,176
ffffffffc020983c:	8082                	ret
ffffffffc020983e:	5a71                	li	s4,-4
ffffffffc0209840:	bfe1                	j	ffffffffc0209818 <sfs_do_mount+0x18a>
ffffffffc0209842:	85be                	mv	a1,a5
ffffffffc0209844:	00006517          	auipc	a0,0x6
ffffffffc0209848:	b4450513          	addi	a0,a0,-1212 # ffffffffc020f388 <dev_node_ops+0x4d8>
ffffffffc020984c:	95bf60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0209850:	5a75                	li	s4,-3
ffffffffc0209852:	b7c1                	j	ffffffffc0209812 <sfs_do_mount+0x184>
ffffffffc0209854:	00006517          	auipc	a0,0x6
ffffffffc0209858:	afc50513          	addi	a0,a0,-1284 # ffffffffc020f350 <dev_node_ops+0x4a0>
ffffffffc020985c:	94bf60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0209860:	5a75                	li	s4,-3
ffffffffc0209862:	bf45                	j	ffffffffc0209812 <sfs_do_mount+0x184>
ffffffffc0209864:	00442903          	lw	s2,4(s0)
ffffffffc0209868:	4481                	li	s1,0
ffffffffc020986a:	080b8c63          	beqz	s7,ffffffffc0209902 <sfs_do_mount+0x274>
ffffffffc020986e:	85a6                	mv	a1,s1
ffffffffc0209870:	856a                	mv	a0,s10
ffffffffc0209872:	af7ff0ef          	jal	ra,ffffffffc0209368 <bitmap_test>
ffffffffc0209876:	c111                	beqz	a0,ffffffffc020987a <sfs_do_mount+0x1ec>
ffffffffc0209878:	2b05                	addiw	s6,s6,1
ffffffffc020987a:	2485                	addiw	s1,s1,1
ffffffffc020987c:	fe9b99e3          	bne	s7,s1,ffffffffc020986e <sfs_do_mount+0x1e0>
ffffffffc0209880:	441c                	lw	a5,8(s0)
ffffffffc0209882:	0d679463          	bne	a5,s6,ffffffffc020994a <sfs_do_mount+0x2bc>
ffffffffc0209886:	4585                	li	a1,1
ffffffffc0209888:	05040513          	addi	a0,s0,80
ffffffffc020988c:	04043023          	sd	zero,64(s0)
ffffffffc0209890:	f1dfa0ef          	jal	ra,ffffffffc02047ac <sem_init>
ffffffffc0209894:	4585                	li	a1,1
ffffffffc0209896:	06840513          	addi	a0,s0,104
ffffffffc020989a:	f13fa0ef          	jal	ra,ffffffffc02047ac <sem_init>
ffffffffc020989e:	4585                	li	a1,1
ffffffffc02098a0:	08040513          	addi	a0,s0,128
ffffffffc02098a4:	f09fa0ef          	jal	ra,ffffffffc02047ac <sem_init>
ffffffffc02098a8:	09840793          	addi	a5,s0,152
ffffffffc02098ac:	f05c                	sd	a5,160(s0)
ffffffffc02098ae:	ec5c                	sd	a5,152(s0)
ffffffffc02098b0:	874a                	mv	a4,s2
ffffffffc02098b2:	86da                	mv	a3,s6
ffffffffc02098b4:	4169063b          	subw	a2,s2,s6
ffffffffc02098b8:	00c40593          	addi	a1,s0,12
ffffffffc02098bc:	00006517          	auipc	a0,0x6
ffffffffc02098c0:	b5c50513          	addi	a0,a0,-1188 # ffffffffc020f418 <dev_node_ops+0x568>
ffffffffc02098c4:	8e3f60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02098c8:	00000797          	auipc	a5,0x0
ffffffffc02098cc:	c8878793          	addi	a5,a5,-888 # ffffffffc0209550 <sfs_sync>
ffffffffc02098d0:	fc5c                	sd	a5,184(s0)
ffffffffc02098d2:	00000797          	auipc	a5,0x0
ffffffffc02098d6:	d6478793          	addi	a5,a5,-668 # ffffffffc0209636 <sfs_get_root>
ffffffffc02098da:	e07c                	sd	a5,192(s0)
ffffffffc02098dc:	00000797          	auipc	a5,0x0
ffffffffc02098e0:	b5e78793          	addi	a5,a5,-1186 # ffffffffc020943a <sfs_unmount>
ffffffffc02098e4:	e47c                	sd	a5,200(s0)
ffffffffc02098e6:	00000797          	auipc	a5,0x0
ffffffffc02098ea:	bd878793          	addi	a5,a5,-1064 # ffffffffc02094be <sfs_cleanup>
ffffffffc02098ee:	e87c                	sd	a5,208(s0)
ffffffffc02098f0:	008ab023          	sd	s0,0(s5)
ffffffffc02098f4:	b72d                	j	ffffffffc020981e <sfs_do_mount+0x190>
ffffffffc02098f6:	5a71                	li	s4,-4
ffffffffc02098f8:	bf11                	j	ffffffffc020980c <sfs_do_mount+0x17e>
ffffffffc02098fa:	5a49                	li	s4,-14
ffffffffc02098fc:	b70d                	j	ffffffffc020981e <sfs_do_mount+0x190>
ffffffffc02098fe:	5a71                	li	s4,-4
ffffffffc0209900:	bf09                	j	ffffffffc0209812 <sfs_do_mount+0x184>
ffffffffc0209902:	4b01                	li	s6,0
ffffffffc0209904:	bfb5                	j	ffffffffc0209880 <sfs_do_mount+0x1f2>
ffffffffc0209906:	5a71                	li	s4,-4
ffffffffc0209908:	bf19                	j	ffffffffc020981e <sfs_do_mount+0x190>
ffffffffc020990a:	00006697          	auipc	a3,0x6
ffffffffc020990e:	aae68693          	addi	a3,a3,-1362 # ffffffffc020f3b8 <dev_node_ops+0x508>
ffffffffc0209912:	00002617          	auipc	a2,0x2
ffffffffc0209916:	3b660613          	addi	a2,a2,950 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020991a:	08300593          	li	a1,131
ffffffffc020991e:	00006517          	auipc	a0,0x6
ffffffffc0209922:	9a250513          	addi	a0,a0,-1630 # ffffffffc020f2c0 <dev_node_ops+0x410>
ffffffffc0209926:	b79f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020992a:	00006697          	auipc	a3,0x6
ffffffffc020992e:	96668693          	addi	a3,a3,-1690 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc0209932:	00002617          	auipc	a2,0x2
ffffffffc0209936:	39660613          	addi	a2,a2,918 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020993a:	0a300593          	li	a1,163
ffffffffc020993e:	00006517          	auipc	a0,0x6
ffffffffc0209942:	98250513          	addi	a0,a0,-1662 # ffffffffc020f2c0 <dev_node_ops+0x410>
ffffffffc0209946:	b59f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020994a:	00006697          	auipc	a3,0x6
ffffffffc020994e:	a9e68693          	addi	a3,a3,-1378 # ffffffffc020f3e8 <dev_node_ops+0x538>
ffffffffc0209952:	00002617          	auipc	a2,0x2
ffffffffc0209956:	37660613          	addi	a2,a2,886 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020995a:	0e000593          	li	a1,224
ffffffffc020995e:	00006517          	auipc	a0,0x6
ffffffffc0209962:	96250513          	addi	a0,a0,-1694 # ffffffffc020f2c0 <dev_node_ops+0x410>
ffffffffc0209966:	b39f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020996a <sfs_mount>:
ffffffffc020996a:	00000597          	auipc	a1,0x0
ffffffffc020996e:	d2458593          	addi	a1,a1,-732 # ffffffffc020968e <sfs_do_mount>
ffffffffc0209972:	817fe06f          	j	ffffffffc0208188 <vfs_mount>

ffffffffc0209976 <sfs_opendir>:
ffffffffc0209976:	0235f593          	andi	a1,a1,35
ffffffffc020997a:	4501                	li	a0,0
ffffffffc020997c:	e191                	bnez	a1,ffffffffc0209980 <sfs_opendir+0xa>
ffffffffc020997e:	8082                	ret
ffffffffc0209980:	553d                	li	a0,-17
ffffffffc0209982:	8082                	ret

ffffffffc0209984 <sfs_openfile>:
ffffffffc0209984:	4501                	li	a0,0
ffffffffc0209986:	8082                	ret

ffffffffc0209988 <sfs_gettype>:
ffffffffc0209988:	1141                	addi	sp,sp,-16
ffffffffc020998a:	e406                	sd	ra,8(sp)
ffffffffc020998c:	c939                	beqz	a0,ffffffffc02099e2 <sfs_gettype+0x5a>
ffffffffc020998e:	4d34                	lw	a3,88(a0)
ffffffffc0209990:	6785                	lui	a5,0x1
ffffffffc0209992:	23578713          	addi	a4,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209996:	04e69663          	bne	a3,a4,ffffffffc02099e2 <sfs_gettype+0x5a>
ffffffffc020999a:	6114                	ld	a3,0(a0)
ffffffffc020999c:	4709                	li	a4,2
ffffffffc020999e:	0046d683          	lhu	a3,4(a3)
ffffffffc02099a2:	02e68a63          	beq	a3,a4,ffffffffc02099d6 <sfs_gettype+0x4e>
ffffffffc02099a6:	470d                	li	a4,3
ffffffffc02099a8:	02e68163          	beq	a3,a4,ffffffffc02099ca <sfs_gettype+0x42>
ffffffffc02099ac:	4705                	li	a4,1
ffffffffc02099ae:	00e68f63          	beq	a3,a4,ffffffffc02099cc <sfs_gettype+0x44>
ffffffffc02099b2:	00006617          	auipc	a2,0x6
ffffffffc02099b6:	ad660613          	addi	a2,a2,-1322 # ffffffffc020f488 <dev_node_ops+0x5d8>
ffffffffc02099ba:	39300593          	li	a1,915
ffffffffc02099be:	00006517          	auipc	a0,0x6
ffffffffc02099c2:	ab250513          	addi	a0,a0,-1358 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc02099c6:	ad9f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02099ca:	678d                	lui	a5,0x3
ffffffffc02099cc:	60a2                	ld	ra,8(sp)
ffffffffc02099ce:	c19c                	sw	a5,0(a1)
ffffffffc02099d0:	4501                	li	a0,0
ffffffffc02099d2:	0141                	addi	sp,sp,16
ffffffffc02099d4:	8082                	ret
ffffffffc02099d6:	60a2                	ld	ra,8(sp)
ffffffffc02099d8:	6789                	lui	a5,0x2
ffffffffc02099da:	c19c                	sw	a5,0(a1)
ffffffffc02099dc:	4501                	li	a0,0
ffffffffc02099de:	0141                	addi	sp,sp,16
ffffffffc02099e0:	8082                	ret
ffffffffc02099e2:	00006697          	auipc	a3,0x6
ffffffffc02099e6:	a5668693          	addi	a3,a3,-1450 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc02099ea:	00002617          	auipc	a2,0x2
ffffffffc02099ee:	2de60613          	addi	a2,a2,734 # ffffffffc020bcc8 <commands+0x210>
ffffffffc02099f2:	38700593          	li	a1,903
ffffffffc02099f6:	00006517          	auipc	a0,0x6
ffffffffc02099fa:	a7a50513          	addi	a0,a0,-1414 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc02099fe:	aa1f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209a02 <sfs_fsync>:
ffffffffc0209a02:	7179                	addi	sp,sp,-48
ffffffffc0209a04:	ec26                	sd	s1,24(sp)
ffffffffc0209a06:	7524                	ld	s1,104(a0)
ffffffffc0209a08:	f406                	sd	ra,40(sp)
ffffffffc0209a0a:	f022                	sd	s0,32(sp)
ffffffffc0209a0c:	e84a                	sd	s2,16(sp)
ffffffffc0209a0e:	e44e                	sd	s3,8(sp)
ffffffffc0209a10:	c4bd                	beqz	s1,ffffffffc0209a7e <sfs_fsync+0x7c>
ffffffffc0209a12:	0b04a783          	lw	a5,176(s1)
ffffffffc0209a16:	e7a5                	bnez	a5,ffffffffc0209a7e <sfs_fsync+0x7c>
ffffffffc0209a18:	4d38                	lw	a4,88(a0)
ffffffffc0209a1a:	6785                	lui	a5,0x1
ffffffffc0209a1c:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209a20:	842a                	mv	s0,a0
ffffffffc0209a22:	06f71e63          	bne	a4,a5,ffffffffc0209a9e <sfs_fsync+0x9c>
ffffffffc0209a26:	691c                	ld	a5,16(a0)
ffffffffc0209a28:	4901                	li	s2,0
ffffffffc0209a2a:	eb89                	bnez	a5,ffffffffc0209a3c <sfs_fsync+0x3a>
ffffffffc0209a2c:	70a2                	ld	ra,40(sp)
ffffffffc0209a2e:	7402                	ld	s0,32(sp)
ffffffffc0209a30:	64e2                	ld	s1,24(sp)
ffffffffc0209a32:	69a2                	ld	s3,8(sp)
ffffffffc0209a34:	854a                	mv	a0,s2
ffffffffc0209a36:	6942                	ld	s2,16(sp)
ffffffffc0209a38:	6145                	addi	sp,sp,48
ffffffffc0209a3a:	8082                	ret
ffffffffc0209a3c:	02050993          	addi	s3,a0,32
ffffffffc0209a40:	854e                	mv	a0,s3
ffffffffc0209a42:	d75fa0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc0209a46:	681c                	ld	a5,16(s0)
ffffffffc0209a48:	ef81                	bnez	a5,ffffffffc0209a60 <sfs_fsync+0x5e>
ffffffffc0209a4a:	854e                	mv	a0,s3
ffffffffc0209a4c:	d67fa0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc0209a50:	70a2                	ld	ra,40(sp)
ffffffffc0209a52:	7402                	ld	s0,32(sp)
ffffffffc0209a54:	64e2                	ld	s1,24(sp)
ffffffffc0209a56:	69a2                	ld	s3,8(sp)
ffffffffc0209a58:	854a                	mv	a0,s2
ffffffffc0209a5a:	6942                	ld	s2,16(sp)
ffffffffc0209a5c:	6145                	addi	sp,sp,48
ffffffffc0209a5e:	8082                	ret
ffffffffc0209a60:	4414                	lw	a3,8(s0)
ffffffffc0209a62:	600c                	ld	a1,0(s0)
ffffffffc0209a64:	00043823          	sd	zero,16(s0)
ffffffffc0209a68:	4701                	li	a4,0
ffffffffc0209a6a:	04000613          	li	a2,64
ffffffffc0209a6e:	8526                	mv	a0,s1
ffffffffc0209a70:	672010ef          	jal	ra,ffffffffc020b0e2 <sfs_wbuf>
ffffffffc0209a74:	892a                	mv	s2,a0
ffffffffc0209a76:	d971                	beqz	a0,ffffffffc0209a4a <sfs_fsync+0x48>
ffffffffc0209a78:	4785                	li	a5,1
ffffffffc0209a7a:	e81c                	sd	a5,16(s0)
ffffffffc0209a7c:	b7f9                	j	ffffffffc0209a4a <sfs_fsync+0x48>
ffffffffc0209a7e:	00006697          	auipc	a3,0x6
ffffffffc0209a82:	81268693          	addi	a3,a3,-2030 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc0209a86:	00002617          	auipc	a2,0x2
ffffffffc0209a8a:	24260613          	addi	a2,a2,578 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209a8e:	2cb00593          	li	a1,715
ffffffffc0209a92:	00006517          	auipc	a0,0x6
ffffffffc0209a96:	9de50513          	addi	a0,a0,-1570 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209a9a:	a05f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209a9e:	00006697          	auipc	a3,0x6
ffffffffc0209aa2:	99a68693          	addi	a3,a3,-1638 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc0209aa6:	00002617          	auipc	a2,0x2
ffffffffc0209aaa:	22260613          	addi	a2,a2,546 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209aae:	2cc00593          	li	a1,716
ffffffffc0209ab2:	00006517          	auipc	a0,0x6
ffffffffc0209ab6:	9be50513          	addi	a0,a0,-1602 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209aba:	9e5f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209abe <sfs_fstat>:
ffffffffc0209abe:	1101                	addi	sp,sp,-32
ffffffffc0209ac0:	e426                	sd	s1,8(sp)
ffffffffc0209ac2:	84ae                	mv	s1,a1
ffffffffc0209ac4:	e822                	sd	s0,16(sp)
ffffffffc0209ac6:	02000613          	li	a2,32
ffffffffc0209aca:	842a                	mv	s0,a0
ffffffffc0209acc:	4581                	li	a1,0
ffffffffc0209ace:	8526                	mv	a0,s1
ffffffffc0209ad0:	ec06                	sd	ra,24(sp)
ffffffffc0209ad2:	515010ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc0209ad6:	c439                	beqz	s0,ffffffffc0209b24 <sfs_fstat+0x66>
ffffffffc0209ad8:	783c                	ld	a5,112(s0)
ffffffffc0209ada:	c7a9                	beqz	a5,ffffffffc0209b24 <sfs_fstat+0x66>
ffffffffc0209adc:	6bbc                	ld	a5,80(a5)
ffffffffc0209ade:	c3b9                	beqz	a5,ffffffffc0209b24 <sfs_fstat+0x66>
ffffffffc0209ae0:	00005597          	auipc	a1,0x5
ffffffffc0209ae4:	34858593          	addi	a1,a1,840 # ffffffffc020ee28 <syscalls+0xdb0>
ffffffffc0209ae8:	8522                	mv	a0,s0
ffffffffc0209aea:	8cefe0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0209aee:	783c                	ld	a5,112(s0)
ffffffffc0209af0:	85a6                	mv	a1,s1
ffffffffc0209af2:	8522                	mv	a0,s0
ffffffffc0209af4:	6bbc                	ld	a5,80(a5)
ffffffffc0209af6:	9782                	jalr	a5
ffffffffc0209af8:	e10d                	bnez	a0,ffffffffc0209b1a <sfs_fstat+0x5c>
ffffffffc0209afa:	4c38                	lw	a4,88(s0)
ffffffffc0209afc:	6785                	lui	a5,0x1
ffffffffc0209afe:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209b02:	04f71163          	bne	a4,a5,ffffffffc0209b44 <sfs_fstat+0x86>
ffffffffc0209b06:	601c                	ld	a5,0(s0)
ffffffffc0209b08:	0067d683          	lhu	a3,6(a5)
ffffffffc0209b0c:	0087e703          	lwu	a4,8(a5)
ffffffffc0209b10:	0007e783          	lwu	a5,0(a5)
ffffffffc0209b14:	e494                	sd	a3,8(s1)
ffffffffc0209b16:	e898                	sd	a4,16(s1)
ffffffffc0209b18:	ec9c                	sd	a5,24(s1)
ffffffffc0209b1a:	60e2                	ld	ra,24(sp)
ffffffffc0209b1c:	6442                	ld	s0,16(sp)
ffffffffc0209b1e:	64a2                	ld	s1,8(sp)
ffffffffc0209b20:	6105                	addi	sp,sp,32
ffffffffc0209b22:	8082                	ret
ffffffffc0209b24:	00005697          	auipc	a3,0x5
ffffffffc0209b28:	29c68693          	addi	a3,a3,668 # ffffffffc020edc0 <syscalls+0xd48>
ffffffffc0209b2c:	00002617          	auipc	a2,0x2
ffffffffc0209b30:	19c60613          	addi	a2,a2,412 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209b34:	2bc00593          	li	a1,700
ffffffffc0209b38:	00006517          	auipc	a0,0x6
ffffffffc0209b3c:	93850513          	addi	a0,a0,-1736 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209b40:	95ff60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209b44:	00006697          	auipc	a3,0x6
ffffffffc0209b48:	8f468693          	addi	a3,a3,-1804 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc0209b4c:	00002617          	auipc	a2,0x2
ffffffffc0209b50:	17c60613          	addi	a2,a2,380 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209b54:	2bf00593          	li	a1,703
ffffffffc0209b58:	00006517          	auipc	a0,0x6
ffffffffc0209b5c:	91850513          	addi	a0,a0,-1768 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209b60:	93ff60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209b64 <sfs_tryseek>:
ffffffffc0209b64:	080007b7          	lui	a5,0x8000
ffffffffc0209b68:	04f5fd63          	bgeu	a1,a5,ffffffffc0209bc2 <sfs_tryseek+0x5e>
ffffffffc0209b6c:	1101                	addi	sp,sp,-32
ffffffffc0209b6e:	e822                	sd	s0,16(sp)
ffffffffc0209b70:	ec06                	sd	ra,24(sp)
ffffffffc0209b72:	e426                	sd	s1,8(sp)
ffffffffc0209b74:	842a                	mv	s0,a0
ffffffffc0209b76:	c921                	beqz	a0,ffffffffc0209bc6 <sfs_tryseek+0x62>
ffffffffc0209b78:	4d38                	lw	a4,88(a0)
ffffffffc0209b7a:	6785                	lui	a5,0x1
ffffffffc0209b7c:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209b80:	04f71363          	bne	a4,a5,ffffffffc0209bc6 <sfs_tryseek+0x62>
ffffffffc0209b84:	611c                	ld	a5,0(a0)
ffffffffc0209b86:	84ae                	mv	s1,a1
ffffffffc0209b88:	0007e783          	lwu	a5,0(a5)
ffffffffc0209b8c:	02b7d563          	bge	a5,a1,ffffffffc0209bb6 <sfs_tryseek+0x52>
ffffffffc0209b90:	793c                	ld	a5,112(a0)
ffffffffc0209b92:	cbb1                	beqz	a5,ffffffffc0209be6 <sfs_tryseek+0x82>
ffffffffc0209b94:	73bc                	ld	a5,96(a5)
ffffffffc0209b96:	cba1                	beqz	a5,ffffffffc0209be6 <sfs_tryseek+0x82>
ffffffffc0209b98:	00005597          	auipc	a1,0x5
ffffffffc0209b9c:	18058593          	addi	a1,a1,384 # ffffffffc020ed18 <syscalls+0xca0>
ffffffffc0209ba0:	818fe0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0209ba4:	783c                	ld	a5,112(s0)
ffffffffc0209ba6:	8522                	mv	a0,s0
ffffffffc0209ba8:	6442                	ld	s0,16(sp)
ffffffffc0209baa:	60e2                	ld	ra,24(sp)
ffffffffc0209bac:	73bc                	ld	a5,96(a5)
ffffffffc0209bae:	85a6                	mv	a1,s1
ffffffffc0209bb0:	64a2                	ld	s1,8(sp)
ffffffffc0209bb2:	6105                	addi	sp,sp,32
ffffffffc0209bb4:	8782                	jr	a5
ffffffffc0209bb6:	60e2                	ld	ra,24(sp)
ffffffffc0209bb8:	6442                	ld	s0,16(sp)
ffffffffc0209bba:	64a2                	ld	s1,8(sp)
ffffffffc0209bbc:	4501                	li	a0,0
ffffffffc0209bbe:	6105                	addi	sp,sp,32
ffffffffc0209bc0:	8082                	ret
ffffffffc0209bc2:	5575                	li	a0,-3
ffffffffc0209bc4:	8082                	ret
ffffffffc0209bc6:	00006697          	auipc	a3,0x6
ffffffffc0209bca:	87268693          	addi	a3,a3,-1934 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc0209bce:	00002617          	auipc	a2,0x2
ffffffffc0209bd2:	0fa60613          	addi	a2,a2,250 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209bd6:	39e00593          	li	a1,926
ffffffffc0209bda:	00006517          	auipc	a0,0x6
ffffffffc0209bde:	89650513          	addi	a0,a0,-1898 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209be2:	8bdf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209be6:	00005697          	auipc	a3,0x5
ffffffffc0209bea:	0da68693          	addi	a3,a3,218 # ffffffffc020ecc0 <syscalls+0xc48>
ffffffffc0209bee:	00002617          	auipc	a2,0x2
ffffffffc0209bf2:	0da60613          	addi	a2,a2,218 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209bf6:	3a000593          	li	a1,928
ffffffffc0209bfa:	00006517          	auipc	a0,0x6
ffffffffc0209bfe:	87650513          	addi	a0,a0,-1930 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209c02:	89df60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209c06 <sfs_close>:
ffffffffc0209c06:	1141                	addi	sp,sp,-16
ffffffffc0209c08:	e406                	sd	ra,8(sp)
ffffffffc0209c0a:	e022                	sd	s0,0(sp)
ffffffffc0209c0c:	c11d                	beqz	a0,ffffffffc0209c32 <sfs_close+0x2c>
ffffffffc0209c0e:	793c                	ld	a5,112(a0)
ffffffffc0209c10:	842a                	mv	s0,a0
ffffffffc0209c12:	c385                	beqz	a5,ffffffffc0209c32 <sfs_close+0x2c>
ffffffffc0209c14:	7b9c                	ld	a5,48(a5)
ffffffffc0209c16:	cf91                	beqz	a5,ffffffffc0209c32 <sfs_close+0x2c>
ffffffffc0209c18:	00004597          	auipc	a1,0x4
ffffffffc0209c1c:	c3058593          	addi	a1,a1,-976 # ffffffffc020d848 <default_pmm_manager+0x1078>
ffffffffc0209c20:	f99fd0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0209c24:	783c                	ld	a5,112(s0)
ffffffffc0209c26:	8522                	mv	a0,s0
ffffffffc0209c28:	6402                	ld	s0,0(sp)
ffffffffc0209c2a:	60a2                	ld	ra,8(sp)
ffffffffc0209c2c:	7b9c                	ld	a5,48(a5)
ffffffffc0209c2e:	0141                	addi	sp,sp,16
ffffffffc0209c30:	8782                	jr	a5
ffffffffc0209c32:	00004697          	auipc	a3,0x4
ffffffffc0209c36:	bc668693          	addi	a3,a3,-1082 # ffffffffc020d7f8 <default_pmm_manager+0x1028>
ffffffffc0209c3a:	00002617          	auipc	a2,0x2
ffffffffc0209c3e:	08e60613          	addi	a2,a2,142 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209c42:	21c00593          	li	a1,540
ffffffffc0209c46:	00006517          	auipc	a0,0x6
ffffffffc0209c4a:	82a50513          	addi	a0,a0,-2006 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209c4e:	851f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209c52 <sfs_io.part.0>:
ffffffffc0209c52:	1141                	addi	sp,sp,-16
ffffffffc0209c54:	00005697          	auipc	a3,0x5
ffffffffc0209c58:	7e468693          	addi	a3,a3,2020 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc0209c5c:	00002617          	auipc	a2,0x2
ffffffffc0209c60:	06c60613          	addi	a2,a2,108 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209c64:	29b00593          	li	a1,667
ffffffffc0209c68:	00006517          	auipc	a0,0x6
ffffffffc0209c6c:	80850513          	addi	a0,a0,-2040 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209c70:	e406                	sd	ra,8(sp)
ffffffffc0209c72:	82df60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209c76 <sfs_block_free>:
ffffffffc0209c76:	1101                	addi	sp,sp,-32
ffffffffc0209c78:	e426                	sd	s1,8(sp)
ffffffffc0209c7a:	ec06                	sd	ra,24(sp)
ffffffffc0209c7c:	e822                	sd	s0,16(sp)
ffffffffc0209c7e:	4154                	lw	a3,4(a0)
ffffffffc0209c80:	84ae                	mv	s1,a1
ffffffffc0209c82:	c595                	beqz	a1,ffffffffc0209cae <sfs_block_free+0x38>
ffffffffc0209c84:	02d5f563          	bgeu	a1,a3,ffffffffc0209cae <sfs_block_free+0x38>
ffffffffc0209c88:	842a                	mv	s0,a0
ffffffffc0209c8a:	7d08                	ld	a0,56(a0)
ffffffffc0209c8c:	edcff0ef          	jal	ra,ffffffffc0209368 <bitmap_test>
ffffffffc0209c90:	ed05                	bnez	a0,ffffffffc0209cc8 <sfs_block_free+0x52>
ffffffffc0209c92:	7c08                	ld	a0,56(s0)
ffffffffc0209c94:	85a6                	mv	a1,s1
ffffffffc0209c96:	efaff0ef          	jal	ra,ffffffffc0209390 <bitmap_free>
ffffffffc0209c9a:	441c                	lw	a5,8(s0)
ffffffffc0209c9c:	4705                	li	a4,1
ffffffffc0209c9e:	60e2                	ld	ra,24(sp)
ffffffffc0209ca0:	2785                	addiw	a5,a5,1
ffffffffc0209ca2:	e038                	sd	a4,64(s0)
ffffffffc0209ca4:	c41c                	sw	a5,8(s0)
ffffffffc0209ca6:	6442                	ld	s0,16(sp)
ffffffffc0209ca8:	64a2                	ld	s1,8(sp)
ffffffffc0209caa:	6105                	addi	sp,sp,32
ffffffffc0209cac:	8082                	ret
ffffffffc0209cae:	8726                	mv	a4,s1
ffffffffc0209cb0:	00005617          	auipc	a2,0x5
ffffffffc0209cb4:	7f060613          	addi	a2,a2,2032 # ffffffffc020f4a0 <dev_node_ops+0x5f0>
ffffffffc0209cb8:	05300593          	li	a1,83
ffffffffc0209cbc:	00005517          	auipc	a0,0x5
ffffffffc0209cc0:	7b450513          	addi	a0,a0,1972 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209cc4:	fdaf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209cc8:	00006697          	auipc	a3,0x6
ffffffffc0209ccc:	81068693          	addi	a3,a3,-2032 # ffffffffc020f4d8 <dev_node_ops+0x628>
ffffffffc0209cd0:	00002617          	auipc	a2,0x2
ffffffffc0209cd4:	ff860613          	addi	a2,a2,-8 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209cd8:	06a00593          	li	a1,106
ffffffffc0209cdc:	00005517          	auipc	a0,0x5
ffffffffc0209ce0:	79450513          	addi	a0,a0,1940 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209ce4:	fbaf60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209ce8 <sfs_reclaim>:
ffffffffc0209ce8:	1101                	addi	sp,sp,-32
ffffffffc0209cea:	e426                	sd	s1,8(sp)
ffffffffc0209cec:	7524                	ld	s1,104(a0)
ffffffffc0209cee:	ec06                	sd	ra,24(sp)
ffffffffc0209cf0:	e822                	sd	s0,16(sp)
ffffffffc0209cf2:	e04a                	sd	s2,0(sp)
ffffffffc0209cf4:	0e048a63          	beqz	s1,ffffffffc0209de8 <sfs_reclaim+0x100>
ffffffffc0209cf8:	0b04a783          	lw	a5,176(s1)
ffffffffc0209cfc:	0e079663          	bnez	a5,ffffffffc0209de8 <sfs_reclaim+0x100>
ffffffffc0209d00:	4d38                	lw	a4,88(a0)
ffffffffc0209d02:	6785                	lui	a5,0x1
ffffffffc0209d04:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209d08:	842a                	mv	s0,a0
ffffffffc0209d0a:	10f71f63          	bne	a4,a5,ffffffffc0209e28 <sfs_reclaim+0x140>
ffffffffc0209d0e:	8526                	mv	a0,s1
ffffffffc0209d10:	582010ef          	jal	ra,ffffffffc020b292 <lock_sfs_fs>
ffffffffc0209d14:	4c1c                	lw	a5,24(s0)
ffffffffc0209d16:	0ef05963          	blez	a5,ffffffffc0209e08 <sfs_reclaim+0x120>
ffffffffc0209d1a:	fff7871b          	addiw	a4,a5,-1
ffffffffc0209d1e:	cc18                	sw	a4,24(s0)
ffffffffc0209d20:	eb59                	bnez	a4,ffffffffc0209db6 <sfs_reclaim+0xce>
ffffffffc0209d22:	05c42903          	lw	s2,92(s0)
ffffffffc0209d26:	08091863          	bnez	s2,ffffffffc0209db6 <sfs_reclaim+0xce>
ffffffffc0209d2a:	601c                	ld	a5,0(s0)
ffffffffc0209d2c:	0067d783          	lhu	a5,6(a5)
ffffffffc0209d30:	e785                	bnez	a5,ffffffffc0209d58 <sfs_reclaim+0x70>
ffffffffc0209d32:	783c                	ld	a5,112(s0)
ffffffffc0209d34:	10078a63          	beqz	a5,ffffffffc0209e48 <sfs_reclaim+0x160>
ffffffffc0209d38:	73bc                	ld	a5,96(a5)
ffffffffc0209d3a:	10078763          	beqz	a5,ffffffffc0209e48 <sfs_reclaim+0x160>
ffffffffc0209d3e:	00005597          	auipc	a1,0x5
ffffffffc0209d42:	fda58593          	addi	a1,a1,-38 # ffffffffc020ed18 <syscalls+0xca0>
ffffffffc0209d46:	8522                	mv	a0,s0
ffffffffc0209d48:	e71fd0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0209d4c:	783c                	ld	a5,112(s0)
ffffffffc0209d4e:	4581                	li	a1,0
ffffffffc0209d50:	8522                	mv	a0,s0
ffffffffc0209d52:	73bc                	ld	a5,96(a5)
ffffffffc0209d54:	9782                	jalr	a5
ffffffffc0209d56:	e559                	bnez	a0,ffffffffc0209de4 <sfs_reclaim+0xfc>
ffffffffc0209d58:	681c                	ld	a5,16(s0)
ffffffffc0209d5a:	c39d                	beqz	a5,ffffffffc0209d80 <sfs_reclaim+0x98>
ffffffffc0209d5c:	783c                	ld	a5,112(s0)
ffffffffc0209d5e:	10078563          	beqz	a5,ffffffffc0209e68 <sfs_reclaim+0x180>
ffffffffc0209d62:	7b9c                	ld	a5,48(a5)
ffffffffc0209d64:	10078263          	beqz	a5,ffffffffc0209e68 <sfs_reclaim+0x180>
ffffffffc0209d68:	8522                	mv	a0,s0
ffffffffc0209d6a:	00004597          	auipc	a1,0x4
ffffffffc0209d6e:	ade58593          	addi	a1,a1,-1314 # ffffffffc020d848 <default_pmm_manager+0x1078>
ffffffffc0209d72:	e47fd0ef          	jal	ra,ffffffffc0207bb8 <inode_check>
ffffffffc0209d76:	783c                	ld	a5,112(s0)
ffffffffc0209d78:	8522                	mv	a0,s0
ffffffffc0209d7a:	7b9c                	ld	a5,48(a5)
ffffffffc0209d7c:	9782                	jalr	a5
ffffffffc0209d7e:	e13d                	bnez	a0,ffffffffc0209de4 <sfs_reclaim+0xfc>
ffffffffc0209d80:	7c18                	ld	a4,56(s0)
ffffffffc0209d82:	603c                	ld	a5,64(s0)
ffffffffc0209d84:	8526                	mv	a0,s1
ffffffffc0209d86:	e71c                	sd	a5,8(a4)
ffffffffc0209d88:	e398                	sd	a4,0(a5)
ffffffffc0209d8a:	6438                	ld	a4,72(s0)
ffffffffc0209d8c:	683c                	ld	a5,80(s0)
ffffffffc0209d8e:	e71c                	sd	a5,8(a4)
ffffffffc0209d90:	e398                	sd	a4,0(a5)
ffffffffc0209d92:	510010ef          	jal	ra,ffffffffc020b2a2 <unlock_sfs_fs>
ffffffffc0209d96:	6008                	ld	a0,0(s0)
ffffffffc0209d98:	00655783          	lhu	a5,6(a0)
ffffffffc0209d9c:	cb85                	beqz	a5,ffffffffc0209dcc <sfs_reclaim+0xe4>
ffffffffc0209d9e:	b24f80ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc0209da2:	8522                	mv	a0,s0
ffffffffc0209da4:	da9fd0ef          	jal	ra,ffffffffc0207b4c <inode_kill>
ffffffffc0209da8:	60e2                	ld	ra,24(sp)
ffffffffc0209daa:	6442                	ld	s0,16(sp)
ffffffffc0209dac:	64a2                	ld	s1,8(sp)
ffffffffc0209dae:	854a                	mv	a0,s2
ffffffffc0209db0:	6902                	ld	s2,0(sp)
ffffffffc0209db2:	6105                	addi	sp,sp,32
ffffffffc0209db4:	8082                	ret
ffffffffc0209db6:	5945                	li	s2,-15
ffffffffc0209db8:	8526                	mv	a0,s1
ffffffffc0209dba:	4e8010ef          	jal	ra,ffffffffc020b2a2 <unlock_sfs_fs>
ffffffffc0209dbe:	60e2                	ld	ra,24(sp)
ffffffffc0209dc0:	6442                	ld	s0,16(sp)
ffffffffc0209dc2:	64a2                	ld	s1,8(sp)
ffffffffc0209dc4:	854a                	mv	a0,s2
ffffffffc0209dc6:	6902                	ld	s2,0(sp)
ffffffffc0209dc8:	6105                	addi	sp,sp,32
ffffffffc0209dca:	8082                	ret
ffffffffc0209dcc:	440c                	lw	a1,8(s0)
ffffffffc0209dce:	8526                	mv	a0,s1
ffffffffc0209dd0:	ea7ff0ef          	jal	ra,ffffffffc0209c76 <sfs_block_free>
ffffffffc0209dd4:	6008                	ld	a0,0(s0)
ffffffffc0209dd6:	5d4c                	lw	a1,60(a0)
ffffffffc0209dd8:	d1f9                	beqz	a1,ffffffffc0209d9e <sfs_reclaim+0xb6>
ffffffffc0209dda:	8526                	mv	a0,s1
ffffffffc0209ddc:	e9bff0ef          	jal	ra,ffffffffc0209c76 <sfs_block_free>
ffffffffc0209de0:	6008                	ld	a0,0(s0)
ffffffffc0209de2:	bf75                	j	ffffffffc0209d9e <sfs_reclaim+0xb6>
ffffffffc0209de4:	892a                	mv	s2,a0
ffffffffc0209de6:	bfc9                	j	ffffffffc0209db8 <sfs_reclaim+0xd0>
ffffffffc0209de8:	00005697          	auipc	a3,0x5
ffffffffc0209dec:	4a868693          	addi	a3,a3,1192 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc0209df0:	00002617          	auipc	a2,0x2
ffffffffc0209df4:	ed860613          	addi	a2,a2,-296 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209df8:	35c00593          	li	a1,860
ffffffffc0209dfc:	00005517          	auipc	a0,0x5
ffffffffc0209e00:	67450513          	addi	a0,a0,1652 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209e04:	e9af60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209e08:	00005697          	auipc	a3,0x5
ffffffffc0209e0c:	6f068693          	addi	a3,a3,1776 # ffffffffc020f4f8 <dev_node_ops+0x648>
ffffffffc0209e10:	00002617          	auipc	a2,0x2
ffffffffc0209e14:	eb860613          	addi	a2,a2,-328 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209e18:	36200593          	li	a1,866
ffffffffc0209e1c:	00005517          	auipc	a0,0x5
ffffffffc0209e20:	65450513          	addi	a0,a0,1620 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209e24:	e7af60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209e28:	00005697          	auipc	a3,0x5
ffffffffc0209e2c:	61068693          	addi	a3,a3,1552 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc0209e30:	00002617          	auipc	a2,0x2
ffffffffc0209e34:	e9860613          	addi	a2,a2,-360 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209e38:	35d00593          	li	a1,861
ffffffffc0209e3c:	00005517          	auipc	a0,0x5
ffffffffc0209e40:	63450513          	addi	a0,a0,1588 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209e44:	e5af60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209e48:	00005697          	auipc	a3,0x5
ffffffffc0209e4c:	e7868693          	addi	a3,a3,-392 # ffffffffc020ecc0 <syscalls+0xc48>
ffffffffc0209e50:	00002617          	auipc	a2,0x2
ffffffffc0209e54:	e7860613          	addi	a2,a2,-392 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209e58:	36700593          	li	a1,871
ffffffffc0209e5c:	00005517          	auipc	a0,0x5
ffffffffc0209e60:	61450513          	addi	a0,a0,1556 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209e64:	e3af60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209e68:	00004697          	auipc	a3,0x4
ffffffffc0209e6c:	99068693          	addi	a3,a3,-1648 # ffffffffc020d7f8 <default_pmm_manager+0x1028>
ffffffffc0209e70:	00002617          	auipc	a2,0x2
ffffffffc0209e74:	e5860613          	addi	a2,a2,-424 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209e78:	36c00593          	li	a1,876
ffffffffc0209e7c:	00005517          	auipc	a0,0x5
ffffffffc0209e80:	5f450513          	addi	a0,a0,1524 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209e84:	e1af60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209e88 <sfs_block_alloc>:
ffffffffc0209e88:	1101                	addi	sp,sp,-32
ffffffffc0209e8a:	e822                	sd	s0,16(sp)
ffffffffc0209e8c:	842a                	mv	s0,a0
ffffffffc0209e8e:	7d08                	ld	a0,56(a0)
ffffffffc0209e90:	e426                	sd	s1,8(sp)
ffffffffc0209e92:	ec06                	sd	ra,24(sp)
ffffffffc0209e94:	84ae                	mv	s1,a1
ffffffffc0209e96:	c62ff0ef          	jal	ra,ffffffffc02092f8 <bitmap_alloc>
ffffffffc0209e9a:	e90d                	bnez	a0,ffffffffc0209ecc <sfs_block_alloc+0x44>
ffffffffc0209e9c:	441c                	lw	a5,8(s0)
ffffffffc0209e9e:	cbad                	beqz	a5,ffffffffc0209f10 <sfs_block_alloc+0x88>
ffffffffc0209ea0:	37fd                	addiw	a5,a5,-1
ffffffffc0209ea2:	c41c                	sw	a5,8(s0)
ffffffffc0209ea4:	408c                	lw	a1,0(s1)
ffffffffc0209ea6:	4785                	li	a5,1
ffffffffc0209ea8:	e03c                	sd	a5,64(s0)
ffffffffc0209eaa:	4054                	lw	a3,4(s0)
ffffffffc0209eac:	c58d                	beqz	a1,ffffffffc0209ed6 <sfs_block_alloc+0x4e>
ffffffffc0209eae:	02d5f463          	bgeu	a1,a3,ffffffffc0209ed6 <sfs_block_alloc+0x4e>
ffffffffc0209eb2:	7c08                	ld	a0,56(s0)
ffffffffc0209eb4:	cb4ff0ef          	jal	ra,ffffffffc0209368 <bitmap_test>
ffffffffc0209eb8:	ed05                	bnez	a0,ffffffffc0209ef0 <sfs_block_alloc+0x68>
ffffffffc0209eba:	8522                	mv	a0,s0
ffffffffc0209ebc:	6442                	ld	s0,16(sp)
ffffffffc0209ebe:	408c                	lw	a1,0(s1)
ffffffffc0209ec0:	60e2                	ld	ra,24(sp)
ffffffffc0209ec2:	64a2                	ld	s1,8(sp)
ffffffffc0209ec4:	4605                	li	a2,1
ffffffffc0209ec6:	6105                	addi	sp,sp,32
ffffffffc0209ec8:	36a0106f          	j	ffffffffc020b232 <sfs_clear_block>
ffffffffc0209ecc:	60e2                	ld	ra,24(sp)
ffffffffc0209ece:	6442                	ld	s0,16(sp)
ffffffffc0209ed0:	64a2                	ld	s1,8(sp)
ffffffffc0209ed2:	6105                	addi	sp,sp,32
ffffffffc0209ed4:	8082                	ret
ffffffffc0209ed6:	872e                	mv	a4,a1
ffffffffc0209ed8:	00005617          	auipc	a2,0x5
ffffffffc0209edc:	5c860613          	addi	a2,a2,1480 # ffffffffc020f4a0 <dev_node_ops+0x5f0>
ffffffffc0209ee0:	05300593          	li	a1,83
ffffffffc0209ee4:	00005517          	auipc	a0,0x5
ffffffffc0209ee8:	58c50513          	addi	a0,a0,1420 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209eec:	db2f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209ef0:	00005697          	auipc	a3,0x5
ffffffffc0209ef4:	64068693          	addi	a3,a3,1600 # ffffffffc020f530 <dev_node_ops+0x680>
ffffffffc0209ef8:	00002617          	auipc	a2,0x2
ffffffffc0209efc:	dd060613          	addi	a2,a2,-560 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209f00:	06100593          	li	a1,97
ffffffffc0209f04:	00005517          	auipc	a0,0x5
ffffffffc0209f08:	56c50513          	addi	a0,a0,1388 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209f0c:	d92f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209f10:	00005697          	auipc	a3,0x5
ffffffffc0209f14:	60068693          	addi	a3,a3,1536 # ffffffffc020f510 <dev_node_ops+0x660>
ffffffffc0209f18:	00002617          	auipc	a2,0x2
ffffffffc0209f1c:	db060613          	addi	a2,a2,-592 # ffffffffc020bcc8 <commands+0x210>
ffffffffc0209f20:	05f00593          	li	a1,95
ffffffffc0209f24:	00005517          	auipc	a0,0x5
ffffffffc0209f28:	54c50513          	addi	a0,a0,1356 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209f2c:	d72f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209f30 <sfs_bmap_load_nolock>:
ffffffffc0209f30:	7159                	addi	sp,sp,-112
ffffffffc0209f32:	f85a                	sd	s6,48(sp)
ffffffffc0209f34:	0005bb03          	ld	s6,0(a1)
ffffffffc0209f38:	f45e                	sd	s7,40(sp)
ffffffffc0209f3a:	f486                	sd	ra,104(sp)
ffffffffc0209f3c:	008b2b83          	lw	s7,8(s6)
ffffffffc0209f40:	f0a2                	sd	s0,96(sp)
ffffffffc0209f42:	eca6                	sd	s1,88(sp)
ffffffffc0209f44:	e8ca                	sd	s2,80(sp)
ffffffffc0209f46:	e4ce                	sd	s3,72(sp)
ffffffffc0209f48:	e0d2                	sd	s4,64(sp)
ffffffffc0209f4a:	fc56                	sd	s5,56(sp)
ffffffffc0209f4c:	f062                	sd	s8,32(sp)
ffffffffc0209f4e:	ec66                	sd	s9,24(sp)
ffffffffc0209f50:	18cbe363          	bltu	s7,a2,ffffffffc020a0d6 <sfs_bmap_load_nolock+0x1a6>
ffffffffc0209f54:	47ad                	li	a5,11
ffffffffc0209f56:	8aae                	mv	s5,a1
ffffffffc0209f58:	8432                	mv	s0,a2
ffffffffc0209f5a:	84aa                	mv	s1,a0
ffffffffc0209f5c:	89b6                	mv	s3,a3
ffffffffc0209f5e:	04c7f563          	bgeu	a5,a2,ffffffffc0209fa8 <sfs_bmap_load_nolock+0x78>
ffffffffc0209f62:	ff46071b          	addiw	a4,a2,-12
ffffffffc0209f66:	0007069b          	sext.w	a3,a4
ffffffffc0209f6a:	3ff00793          	li	a5,1023
ffffffffc0209f6e:	1ad7e163          	bltu	a5,a3,ffffffffc020a110 <sfs_bmap_load_nolock+0x1e0>
ffffffffc0209f72:	03cb2a03          	lw	s4,60(s6)
ffffffffc0209f76:	02071793          	slli	a5,a4,0x20
ffffffffc0209f7a:	c602                	sw	zero,12(sp)
ffffffffc0209f7c:	c452                	sw	s4,8(sp)
ffffffffc0209f7e:	01e7dc13          	srli	s8,a5,0x1e
ffffffffc0209f82:	0e0a1e63          	bnez	s4,ffffffffc020a07e <sfs_bmap_load_nolock+0x14e>
ffffffffc0209f86:	0acb8663          	beq	s7,a2,ffffffffc020a032 <sfs_bmap_load_nolock+0x102>
ffffffffc0209f8a:	4a01                	li	s4,0
ffffffffc0209f8c:	40d4                	lw	a3,4(s1)
ffffffffc0209f8e:	8752                	mv	a4,s4
ffffffffc0209f90:	00005617          	auipc	a2,0x5
ffffffffc0209f94:	51060613          	addi	a2,a2,1296 # ffffffffc020f4a0 <dev_node_ops+0x5f0>
ffffffffc0209f98:	05300593          	li	a1,83
ffffffffc0209f9c:	00005517          	auipc	a0,0x5
ffffffffc0209fa0:	4d450513          	addi	a0,a0,1236 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc0209fa4:	cfaf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209fa8:	02061793          	slli	a5,a2,0x20
ffffffffc0209fac:	01e7da13          	srli	s4,a5,0x1e
ffffffffc0209fb0:	9a5a                	add	s4,s4,s6
ffffffffc0209fb2:	00ca2583          	lw	a1,12(s4)
ffffffffc0209fb6:	c22e                	sw	a1,4(sp)
ffffffffc0209fb8:	ed99                	bnez	a1,ffffffffc0209fd6 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209fba:	fccb98e3          	bne	s7,a2,ffffffffc0209f8a <sfs_bmap_load_nolock+0x5a>
ffffffffc0209fbe:	004c                	addi	a1,sp,4
ffffffffc0209fc0:	ec9ff0ef          	jal	ra,ffffffffc0209e88 <sfs_block_alloc>
ffffffffc0209fc4:	892a                	mv	s2,a0
ffffffffc0209fc6:	e921                	bnez	a0,ffffffffc020a016 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209fc8:	4592                	lw	a1,4(sp)
ffffffffc0209fca:	4705                	li	a4,1
ffffffffc0209fcc:	00ba2623          	sw	a1,12(s4)
ffffffffc0209fd0:	00eab823          	sd	a4,16(s5)
ffffffffc0209fd4:	d9dd                	beqz	a1,ffffffffc0209f8a <sfs_bmap_load_nolock+0x5a>
ffffffffc0209fd6:	40d4                	lw	a3,4(s1)
ffffffffc0209fd8:	10d5ff63          	bgeu	a1,a3,ffffffffc020a0f6 <sfs_bmap_load_nolock+0x1c6>
ffffffffc0209fdc:	7c88                	ld	a0,56(s1)
ffffffffc0209fde:	b8aff0ef          	jal	ra,ffffffffc0209368 <bitmap_test>
ffffffffc0209fe2:	18051363          	bnez	a0,ffffffffc020a168 <sfs_bmap_load_nolock+0x238>
ffffffffc0209fe6:	4a12                	lw	s4,4(sp)
ffffffffc0209fe8:	fa0a02e3          	beqz	s4,ffffffffc0209f8c <sfs_bmap_load_nolock+0x5c>
ffffffffc0209fec:	40dc                	lw	a5,4(s1)
ffffffffc0209fee:	f8fa7fe3          	bgeu	s4,a5,ffffffffc0209f8c <sfs_bmap_load_nolock+0x5c>
ffffffffc0209ff2:	7c88                	ld	a0,56(s1)
ffffffffc0209ff4:	85d2                	mv	a1,s4
ffffffffc0209ff6:	b72ff0ef          	jal	ra,ffffffffc0209368 <bitmap_test>
ffffffffc0209ffa:	12051763          	bnez	a0,ffffffffc020a128 <sfs_bmap_load_nolock+0x1f8>
ffffffffc0209ffe:	008b9763          	bne	s7,s0,ffffffffc020a00c <sfs_bmap_load_nolock+0xdc>
ffffffffc020a002:	008b2783          	lw	a5,8(s6)
ffffffffc020a006:	2785                	addiw	a5,a5,1
ffffffffc020a008:	00fb2423          	sw	a5,8(s6)
ffffffffc020a00c:	4901                	li	s2,0
ffffffffc020a00e:	00098463          	beqz	s3,ffffffffc020a016 <sfs_bmap_load_nolock+0xe6>
ffffffffc020a012:	0149a023          	sw	s4,0(s3)
ffffffffc020a016:	70a6                	ld	ra,104(sp)
ffffffffc020a018:	7406                	ld	s0,96(sp)
ffffffffc020a01a:	64e6                	ld	s1,88(sp)
ffffffffc020a01c:	69a6                	ld	s3,72(sp)
ffffffffc020a01e:	6a06                	ld	s4,64(sp)
ffffffffc020a020:	7ae2                	ld	s5,56(sp)
ffffffffc020a022:	7b42                	ld	s6,48(sp)
ffffffffc020a024:	7ba2                	ld	s7,40(sp)
ffffffffc020a026:	7c02                	ld	s8,32(sp)
ffffffffc020a028:	6ce2                	ld	s9,24(sp)
ffffffffc020a02a:	854a                	mv	a0,s2
ffffffffc020a02c:	6946                	ld	s2,80(sp)
ffffffffc020a02e:	6165                	addi	sp,sp,112
ffffffffc020a030:	8082                	ret
ffffffffc020a032:	002c                	addi	a1,sp,8
ffffffffc020a034:	e55ff0ef          	jal	ra,ffffffffc0209e88 <sfs_block_alloc>
ffffffffc020a038:	892a                	mv	s2,a0
ffffffffc020a03a:	00c10c93          	addi	s9,sp,12
ffffffffc020a03e:	fd61                	bnez	a0,ffffffffc020a016 <sfs_bmap_load_nolock+0xe6>
ffffffffc020a040:	85e6                	mv	a1,s9
ffffffffc020a042:	8526                	mv	a0,s1
ffffffffc020a044:	e45ff0ef          	jal	ra,ffffffffc0209e88 <sfs_block_alloc>
ffffffffc020a048:	892a                	mv	s2,a0
ffffffffc020a04a:	e925                	bnez	a0,ffffffffc020a0ba <sfs_bmap_load_nolock+0x18a>
ffffffffc020a04c:	46a2                	lw	a3,8(sp)
ffffffffc020a04e:	85e6                	mv	a1,s9
ffffffffc020a050:	8762                	mv	a4,s8
ffffffffc020a052:	4611                	li	a2,4
ffffffffc020a054:	8526                	mv	a0,s1
ffffffffc020a056:	08c010ef          	jal	ra,ffffffffc020b0e2 <sfs_wbuf>
ffffffffc020a05a:	45b2                	lw	a1,12(sp)
ffffffffc020a05c:	892a                	mv	s2,a0
ffffffffc020a05e:	e939                	bnez	a0,ffffffffc020a0b4 <sfs_bmap_load_nolock+0x184>
ffffffffc020a060:	03cb2683          	lw	a3,60(s6)
ffffffffc020a064:	4722                	lw	a4,8(sp)
ffffffffc020a066:	c22e                	sw	a1,4(sp)
ffffffffc020a068:	f6d706e3          	beq	a4,a3,ffffffffc0209fd4 <sfs_bmap_load_nolock+0xa4>
ffffffffc020a06c:	eef1                	bnez	a3,ffffffffc020a148 <sfs_bmap_load_nolock+0x218>
ffffffffc020a06e:	02eb2e23          	sw	a4,60(s6)
ffffffffc020a072:	4705                	li	a4,1
ffffffffc020a074:	00eab823          	sd	a4,16(s5)
ffffffffc020a078:	f00589e3          	beqz	a1,ffffffffc0209f8a <sfs_bmap_load_nolock+0x5a>
ffffffffc020a07c:	bfa9                	j	ffffffffc0209fd6 <sfs_bmap_load_nolock+0xa6>
ffffffffc020a07e:	00c10c93          	addi	s9,sp,12
ffffffffc020a082:	8762                	mv	a4,s8
ffffffffc020a084:	86d2                	mv	a3,s4
ffffffffc020a086:	4611                	li	a2,4
ffffffffc020a088:	85e6                	mv	a1,s9
ffffffffc020a08a:	7d9000ef          	jal	ra,ffffffffc020b062 <sfs_rbuf>
ffffffffc020a08e:	892a                	mv	s2,a0
ffffffffc020a090:	f159                	bnez	a0,ffffffffc020a016 <sfs_bmap_load_nolock+0xe6>
ffffffffc020a092:	45b2                	lw	a1,12(sp)
ffffffffc020a094:	e995                	bnez	a1,ffffffffc020a0c8 <sfs_bmap_load_nolock+0x198>
ffffffffc020a096:	fa8b85e3          	beq	s7,s0,ffffffffc020a040 <sfs_bmap_load_nolock+0x110>
ffffffffc020a09a:	03cb2703          	lw	a4,60(s6)
ffffffffc020a09e:	47a2                	lw	a5,8(sp)
ffffffffc020a0a0:	c202                	sw	zero,4(sp)
ffffffffc020a0a2:	eee784e3          	beq	a5,a4,ffffffffc0209f8a <sfs_bmap_load_nolock+0x5a>
ffffffffc020a0a6:	e34d                	bnez	a4,ffffffffc020a148 <sfs_bmap_load_nolock+0x218>
ffffffffc020a0a8:	02fb2e23          	sw	a5,60(s6)
ffffffffc020a0ac:	4785                	li	a5,1
ffffffffc020a0ae:	00fab823          	sd	a5,16(s5)
ffffffffc020a0b2:	bde1                	j	ffffffffc0209f8a <sfs_bmap_load_nolock+0x5a>
ffffffffc020a0b4:	8526                	mv	a0,s1
ffffffffc020a0b6:	bc1ff0ef          	jal	ra,ffffffffc0209c76 <sfs_block_free>
ffffffffc020a0ba:	45a2                	lw	a1,8(sp)
ffffffffc020a0bc:	f4ba0de3          	beq	s4,a1,ffffffffc020a016 <sfs_bmap_load_nolock+0xe6>
ffffffffc020a0c0:	8526                	mv	a0,s1
ffffffffc020a0c2:	bb5ff0ef          	jal	ra,ffffffffc0209c76 <sfs_block_free>
ffffffffc020a0c6:	bf81                	j	ffffffffc020a016 <sfs_bmap_load_nolock+0xe6>
ffffffffc020a0c8:	03cb2683          	lw	a3,60(s6)
ffffffffc020a0cc:	4722                	lw	a4,8(sp)
ffffffffc020a0ce:	c22e                	sw	a1,4(sp)
ffffffffc020a0d0:	f8e69ee3          	bne	a3,a4,ffffffffc020a06c <sfs_bmap_load_nolock+0x13c>
ffffffffc020a0d4:	b709                	j	ffffffffc0209fd6 <sfs_bmap_load_nolock+0xa6>
ffffffffc020a0d6:	00005697          	auipc	a3,0x5
ffffffffc020a0da:	48268693          	addi	a3,a3,1154 # ffffffffc020f558 <dev_node_ops+0x6a8>
ffffffffc020a0de:	00002617          	auipc	a2,0x2
ffffffffc020a0e2:	bea60613          	addi	a2,a2,-1046 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a0e6:	16400593          	li	a1,356
ffffffffc020a0ea:	00005517          	auipc	a0,0x5
ffffffffc020a0ee:	38650513          	addi	a0,a0,902 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a0f2:	bacf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a0f6:	872e                	mv	a4,a1
ffffffffc020a0f8:	00005617          	auipc	a2,0x5
ffffffffc020a0fc:	3a860613          	addi	a2,a2,936 # ffffffffc020f4a0 <dev_node_ops+0x5f0>
ffffffffc020a100:	05300593          	li	a1,83
ffffffffc020a104:	00005517          	auipc	a0,0x5
ffffffffc020a108:	36c50513          	addi	a0,a0,876 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a10c:	b92f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a110:	00005617          	auipc	a2,0x5
ffffffffc020a114:	47860613          	addi	a2,a2,1144 # ffffffffc020f588 <dev_node_ops+0x6d8>
ffffffffc020a118:	11e00593          	li	a1,286
ffffffffc020a11c:	00005517          	auipc	a0,0x5
ffffffffc020a120:	35450513          	addi	a0,a0,852 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a124:	b7af60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a128:	00005697          	auipc	a3,0x5
ffffffffc020a12c:	3b068693          	addi	a3,a3,944 # ffffffffc020f4d8 <dev_node_ops+0x628>
ffffffffc020a130:	00002617          	auipc	a2,0x2
ffffffffc020a134:	b9860613          	addi	a2,a2,-1128 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a138:	16b00593          	li	a1,363
ffffffffc020a13c:	00005517          	auipc	a0,0x5
ffffffffc020a140:	33450513          	addi	a0,a0,820 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a144:	b5af60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a148:	00005697          	auipc	a3,0x5
ffffffffc020a14c:	42868693          	addi	a3,a3,1064 # ffffffffc020f570 <dev_node_ops+0x6c0>
ffffffffc020a150:	00002617          	auipc	a2,0x2
ffffffffc020a154:	b7860613          	addi	a2,a2,-1160 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a158:	11800593          	li	a1,280
ffffffffc020a15c:	00005517          	auipc	a0,0x5
ffffffffc020a160:	31450513          	addi	a0,a0,788 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a164:	b3af60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a168:	00005697          	auipc	a3,0x5
ffffffffc020a16c:	45068693          	addi	a3,a3,1104 # ffffffffc020f5b8 <dev_node_ops+0x708>
ffffffffc020a170:	00002617          	auipc	a2,0x2
ffffffffc020a174:	b5860613          	addi	a2,a2,-1192 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a178:	12100593          	li	a1,289
ffffffffc020a17c:	00005517          	auipc	a0,0x5
ffffffffc020a180:	2f450513          	addi	a0,a0,756 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a184:	b1af60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a188 <sfs_io_nolock>:
ffffffffc020a188:	7175                	addi	sp,sp,-144
ffffffffc020a18a:	f8ca                	sd	s2,112(sp)
ffffffffc020a18c:	892e                	mv	s2,a1
ffffffffc020a18e:	618c                	ld	a1,0(a1)
ffffffffc020a190:	e506                	sd	ra,136(sp)
ffffffffc020a192:	e122                	sd	s0,128(sp)
ffffffffc020a194:	0045d883          	lhu	a7,4(a1)
ffffffffc020a198:	fca6                	sd	s1,120(sp)
ffffffffc020a19a:	f4ce                	sd	s3,104(sp)
ffffffffc020a19c:	f0d2                	sd	s4,96(sp)
ffffffffc020a19e:	ecd6                	sd	s5,88(sp)
ffffffffc020a1a0:	e8da                	sd	s6,80(sp)
ffffffffc020a1a2:	e4de                	sd	s7,72(sp)
ffffffffc020a1a4:	e0e2                	sd	s8,64(sp)
ffffffffc020a1a6:	fc66                	sd	s9,56(sp)
ffffffffc020a1a8:	f86a                	sd	s10,48(sp)
ffffffffc020a1aa:	f46e                	sd	s11,40(sp)
ffffffffc020a1ac:	4809                	li	a6,2
ffffffffc020a1ae:	19088563          	beq	a7,a6,ffffffffc020a338 <sfs_io_nolock+0x1b0>
ffffffffc020a1b2:	00073a03          	ld	s4,0(a4) # 4000 <_binary_bin_swap_img_size-0x3d00>
ffffffffc020a1b6:	8bbe                	mv	s7,a5
ffffffffc020a1b8:	00073023          	sd	zero,0(a4)
ffffffffc020a1bc:	080007b7          	lui	a5,0x8000
ffffffffc020a1c0:	89b6                	mv	s3,a3
ffffffffc020a1c2:	8b3a                	mv	s6,a4
ffffffffc020a1c4:	9a36                	add	s4,s4,a3
ffffffffc020a1c6:	16f6f763          	bgeu	a3,a5,ffffffffc020a334 <sfs_io_nolock+0x1ac>
ffffffffc020a1ca:	16da4563          	blt	s4,a3,ffffffffc020a334 <sfs_io_nolock+0x1ac>
ffffffffc020a1ce:	842a                	mv	s0,a0
ffffffffc020a1d0:	4501                	li	a0,0
ffffffffc020a1d2:	0d468c63          	beq	a3,s4,ffffffffc020a2aa <sfs_io_nolock+0x122>
ffffffffc020a1d6:	8db2                	mv	s11,a2
ffffffffc020a1d8:	0147f463          	bgeu	a5,s4,ffffffffc020a1e0 <sfs_io_nolock+0x58>
ffffffffc020a1dc:	08000a37          	lui	s4,0x8000
ffffffffc020a1e0:	0e0b8463          	beqz	s7,ffffffffc020a2c8 <sfs_io_nolock+0x140>
ffffffffc020a1e4:	00001c97          	auipc	s9,0x1
ffffffffc020a1e8:	e1ec8c93          	addi	s9,s9,-482 # ffffffffc020b002 <sfs_wblock>
ffffffffc020a1ec:	00001c17          	auipc	s8,0x1
ffffffffc020a1f0:	ef6c0c13          	addi	s8,s8,-266 # ffffffffc020b0e2 <sfs_wbuf>
ffffffffc020a1f4:	6685                	lui	a3,0x1
ffffffffc020a1f6:	40c9dd13          	srai	s10,s3,0xc
ffffffffc020a1fa:	40ca5a93          	srai	s5,s4,0xc
ffffffffc020a1fe:	fff68713          	addi	a4,a3,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020a202:	41aa87bb          	subw	a5,s5,s10
ffffffffc020a206:	00e9f733          	and	a4,s3,a4
ffffffffc020a20a:	8abe                	mv	s5,a5
ffffffffc020a20c:	2d01                	sext.w	s10,s10
ffffffffc020a20e:	84ba                	mv	s1,a4
ffffffffc020a210:	cb15                	beqz	a4,ffffffffc020a244 <sfs_io_nolock+0xbc>
ffffffffc020a212:	413a04b3          	sub	s1,s4,s3
ffffffffc020a216:	ebe9                	bnez	a5,ffffffffc020a2e8 <sfs_io_nolock+0x160>
ffffffffc020a218:	0874                	addi	a3,sp,28
ffffffffc020a21a:	866a                	mv	a2,s10
ffffffffc020a21c:	85ca                	mv	a1,s2
ffffffffc020a21e:	8522                	mv	a0,s0
ffffffffc020a220:	e03a                	sd	a4,0(sp)
ffffffffc020a222:	e43e                	sd	a5,8(sp)
ffffffffc020a224:	d0dff0ef          	jal	ra,ffffffffc0209f30 <sfs_bmap_load_nolock>
ffffffffc020a228:	ed69                	bnez	a0,ffffffffc020a302 <sfs_io_nolock+0x17a>
ffffffffc020a22a:	46f2                	lw	a3,28(sp)
ffffffffc020a22c:	6702                	ld	a4,0(sp)
ffffffffc020a22e:	8626                	mv	a2,s1
ffffffffc020a230:	85ee                	mv	a1,s11
ffffffffc020a232:	8522                	mv	a0,s0
ffffffffc020a234:	9c02                	jalr	s8
ffffffffc020a236:	e571                	bnez	a0,ffffffffc020a302 <sfs_io_nolock+0x17a>
ffffffffc020a238:	67a2                	ld	a5,8(sp)
ffffffffc020a23a:	c7b1                	beqz	a5,ffffffffc020a286 <sfs_io_nolock+0xfe>
ffffffffc020a23c:	9da6                	add	s11,s11,s1
ffffffffc020a23e:	2d05                	addiw	s10,s10,1
ffffffffc020a240:	fffa879b          	addiw	a5,s5,-1
ffffffffc020a244:	c3e9                	beqz	a5,ffffffffc020a306 <sfs_io_nolock+0x17e>
ffffffffc020a246:	01a78abb          	addw	s5,a5,s10
ffffffffc020a24a:	a831                	j	ffffffffc020a266 <sfs_io_nolock+0xde>
ffffffffc020a24c:	86b2                	mv	a3,a2
ffffffffc020a24e:	4701                	li	a4,0
ffffffffc020a250:	6605                	lui	a2,0x1
ffffffffc020a252:	85ee                	mv	a1,s11
ffffffffc020a254:	8522                	mv	a0,s0
ffffffffc020a256:	9c02                	jalr	s8
ffffffffc020a258:	e51d                	bnez	a0,ffffffffc020a286 <sfs_io_nolock+0xfe>
ffffffffc020a25a:	6785                	lui	a5,0x1
ffffffffc020a25c:	2d05                	addiw	s10,s10,1
ffffffffc020a25e:	94be                	add	s1,s1,a5
ffffffffc020a260:	9dbe                	add	s11,s11,a5
ffffffffc020a262:	0baa8363          	beq	s5,s10,ffffffffc020a308 <sfs_io_nolock+0x180>
ffffffffc020a266:	0874                	addi	a3,sp,28
ffffffffc020a268:	866a                	mv	a2,s10
ffffffffc020a26a:	85ca                	mv	a1,s2
ffffffffc020a26c:	8522                	mv	a0,s0
ffffffffc020a26e:	cc3ff0ef          	jal	ra,ffffffffc0209f30 <sfs_bmap_load_nolock>
ffffffffc020a272:	e911                	bnez	a0,ffffffffc020a286 <sfs_io_nolock+0xfe>
ffffffffc020a274:	003df793          	andi	a5,s11,3
ffffffffc020a278:	4672                	lw	a2,28(sp)
ffffffffc020a27a:	fbe9                	bnez	a5,ffffffffc020a24c <sfs_io_nolock+0xc4>
ffffffffc020a27c:	4685                	li	a3,1
ffffffffc020a27e:	85ee                	mv	a1,s11
ffffffffc020a280:	8522                	mv	a0,s0
ffffffffc020a282:	9c82                	jalr	s9
ffffffffc020a284:	d979                	beqz	a0,ffffffffc020a25a <sfs_io_nolock+0xd2>
ffffffffc020a286:	009b3023          	sd	s1,0(s6)
ffffffffc020a28a:	020b8063          	beqz	s7,ffffffffc020a2aa <sfs_io_nolock+0x122>
ffffffffc020a28e:	00093703          	ld	a4,0(s2)
ffffffffc020a292:	009987b3          	add	a5,s3,s1
ffffffffc020a296:	00076683          	lwu	a3,0(a4)
ffffffffc020a29a:	00f6f863          	bgeu	a3,a5,ffffffffc020a2aa <sfs_io_nolock+0x122>
ffffffffc020a29e:	009984bb          	addw	s1,s3,s1
ffffffffc020a2a2:	c304                	sw	s1,0(a4)
ffffffffc020a2a4:	4785                	li	a5,1
ffffffffc020a2a6:	00f93823          	sd	a5,16(s2)
ffffffffc020a2aa:	60aa                	ld	ra,136(sp)
ffffffffc020a2ac:	640a                	ld	s0,128(sp)
ffffffffc020a2ae:	74e6                	ld	s1,120(sp)
ffffffffc020a2b0:	7946                	ld	s2,112(sp)
ffffffffc020a2b2:	79a6                	ld	s3,104(sp)
ffffffffc020a2b4:	7a06                	ld	s4,96(sp)
ffffffffc020a2b6:	6ae6                	ld	s5,88(sp)
ffffffffc020a2b8:	6b46                	ld	s6,80(sp)
ffffffffc020a2ba:	6ba6                	ld	s7,72(sp)
ffffffffc020a2bc:	6c06                	ld	s8,64(sp)
ffffffffc020a2be:	7ce2                	ld	s9,56(sp)
ffffffffc020a2c0:	7d42                	ld	s10,48(sp)
ffffffffc020a2c2:	7da2                	ld	s11,40(sp)
ffffffffc020a2c4:	6149                	addi	sp,sp,144
ffffffffc020a2c6:	8082                	ret
ffffffffc020a2c8:	0005e783          	lwu	a5,0(a1)
ffffffffc020a2cc:	4501                	li	a0,0
ffffffffc020a2ce:	fcf9dee3          	bge	s3,a5,ffffffffc020a2aa <sfs_io_nolock+0x122>
ffffffffc020a2d2:	0147ce63          	blt	a5,s4,ffffffffc020a2ee <sfs_io_nolock+0x166>
ffffffffc020a2d6:	00001c97          	auipc	s9,0x1
ffffffffc020a2da:	cccc8c93          	addi	s9,s9,-820 # ffffffffc020afa2 <sfs_rblock>
ffffffffc020a2de:	00001c17          	auipc	s8,0x1
ffffffffc020a2e2:	d84c0c13          	addi	s8,s8,-636 # ffffffffc020b062 <sfs_rbuf>
ffffffffc020a2e6:	b739                	j	ffffffffc020a1f4 <sfs_io_nolock+0x6c>
ffffffffc020a2e8:	40e684b3          	sub	s1,a3,a4
ffffffffc020a2ec:	b735                	j	ffffffffc020a218 <sfs_io_nolock+0x90>
ffffffffc020a2ee:	8a3e                	mv	s4,a5
ffffffffc020a2f0:	00001c97          	auipc	s9,0x1
ffffffffc020a2f4:	cb2c8c93          	addi	s9,s9,-846 # ffffffffc020afa2 <sfs_rblock>
ffffffffc020a2f8:	00001c17          	auipc	s8,0x1
ffffffffc020a2fc:	d6ac0c13          	addi	s8,s8,-662 # ffffffffc020b062 <sfs_rbuf>
ffffffffc020a300:	bdd5                	j	ffffffffc020a1f4 <sfs_io_nolock+0x6c>
ffffffffc020a302:	4481                	li	s1,0
ffffffffc020a304:	b749                	j	ffffffffc020a286 <sfs_io_nolock+0xfe>
ffffffffc020a306:	8aea                	mv	s5,s10
ffffffffc020a308:	1a52                	slli	s4,s4,0x34
ffffffffc020a30a:	034a5c93          	srli	s9,s4,0x34
ffffffffc020a30e:	4501                	li	a0,0
ffffffffc020a310:	f60a0be3          	beqz	s4,ffffffffc020a286 <sfs_io_nolock+0xfe>
ffffffffc020a314:	0874                	addi	a3,sp,28
ffffffffc020a316:	8656                	mv	a2,s5
ffffffffc020a318:	85ca                	mv	a1,s2
ffffffffc020a31a:	8522                	mv	a0,s0
ffffffffc020a31c:	c15ff0ef          	jal	ra,ffffffffc0209f30 <sfs_bmap_load_nolock>
ffffffffc020a320:	f13d                	bnez	a0,ffffffffc020a286 <sfs_io_nolock+0xfe>
ffffffffc020a322:	46f2                	lw	a3,28(sp)
ffffffffc020a324:	4701                	li	a4,0
ffffffffc020a326:	8666                	mv	a2,s9
ffffffffc020a328:	85ee                	mv	a1,s11
ffffffffc020a32a:	8522                	mv	a0,s0
ffffffffc020a32c:	9c02                	jalr	s8
ffffffffc020a32e:	fd21                	bnez	a0,ffffffffc020a286 <sfs_io_nolock+0xfe>
ffffffffc020a330:	94e6                	add	s1,s1,s9
ffffffffc020a332:	bf91                	j	ffffffffc020a286 <sfs_io_nolock+0xfe>
ffffffffc020a334:	5575                	li	a0,-3
ffffffffc020a336:	bf95                	j	ffffffffc020a2aa <sfs_io_nolock+0x122>
ffffffffc020a338:	00005697          	auipc	a3,0x5
ffffffffc020a33c:	2a868693          	addi	a3,a3,680 # ffffffffc020f5e0 <dev_node_ops+0x730>
ffffffffc020a340:	00002617          	auipc	a2,0x2
ffffffffc020a344:	98860613          	addi	a2,a2,-1656 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a348:	22b00593          	li	a1,555
ffffffffc020a34c:	00005517          	auipc	a0,0x5
ffffffffc020a350:	12450513          	addi	a0,a0,292 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a354:	94af60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a358 <sfs_read>:
ffffffffc020a358:	7139                	addi	sp,sp,-64
ffffffffc020a35a:	f04a                	sd	s2,32(sp)
ffffffffc020a35c:	06853903          	ld	s2,104(a0)
ffffffffc020a360:	fc06                	sd	ra,56(sp)
ffffffffc020a362:	f822                	sd	s0,48(sp)
ffffffffc020a364:	f426                	sd	s1,40(sp)
ffffffffc020a366:	ec4e                	sd	s3,24(sp)
ffffffffc020a368:	04090f63          	beqz	s2,ffffffffc020a3c6 <sfs_read+0x6e>
ffffffffc020a36c:	0b092783          	lw	a5,176(s2)
ffffffffc020a370:	ebb9                	bnez	a5,ffffffffc020a3c6 <sfs_read+0x6e>
ffffffffc020a372:	4d38                	lw	a4,88(a0)
ffffffffc020a374:	6785                	lui	a5,0x1
ffffffffc020a376:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a37a:	842a                	mv	s0,a0
ffffffffc020a37c:	06f71563          	bne	a4,a5,ffffffffc020a3e6 <sfs_read+0x8e>
ffffffffc020a380:	02050993          	addi	s3,a0,32
ffffffffc020a384:	854e                	mv	a0,s3
ffffffffc020a386:	84ae                	mv	s1,a1
ffffffffc020a388:	c2efa0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc020a38c:	0184b803          	ld	a6,24(s1)
ffffffffc020a390:	6494                	ld	a3,8(s1)
ffffffffc020a392:	6090                	ld	a2,0(s1)
ffffffffc020a394:	85a2                	mv	a1,s0
ffffffffc020a396:	4781                	li	a5,0
ffffffffc020a398:	0038                	addi	a4,sp,8
ffffffffc020a39a:	854a                	mv	a0,s2
ffffffffc020a39c:	e442                	sd	a6,8(sp)
ffffffffc020a39e:	debff0ef          	jal	ra,ffffffffc020a188 <sfs_io_nolock>
ffffffffc020a3a2:	65a2                	ld	a1,8(sp)
ffffffffc020a3a4:	842a                	mv	s0,a0
ffffffffc020a3a6:	ed81                	bnez	a1,ffffffffc020a3be <sfs_read+0x66>
ffffffffc020a3a8:	854e                	mv	a0,s3
ffffffffc020a3aa:	c08fa0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020a3ae:	70e2                	ld	ra,56(sp)
ffffffffc020a3b0:	8522                	mv	a0,s0
ffffffffc020a3b2:	7442                	ld	s0,48(sp)
ffffffffc020a3b4:	74a2                	ld	s1,40(sp)
ffffffffc020a3b6:	7902                	ld	s2,32(sp)
ffffffffc020a3b8:	69e2                	ld	s3,24(sp)
ffffffffc020a3ba:	6121                	addi	sp,sp,64
ffffffffc020a3bc:	8082                	ret
ffffffffc020a3be:	8526                	mv	a0,s1
ffffffffc020a3c0:	aeafb0ef          	jal	ra,ffffffffc02056aa <iobuf_skip>
ffffffffc020a3c4:	b7d5                	j	ffffffffc020a3a8 <sfs_read+0x50>
ffffffffc020a3c6:	00005697          	auipc	a3,0x5
ffffffffc020a3ca:	eca68693          	addi	a3,a3,-310 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc020a3ce:	00002617          	auipc	a2,0x2
ffffffffc020a3d2:	8fa60613          	addi	a2,a2,-1798 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a3d6:	29a00593          	li	a1,666
ffffffffc020a3da:	00005517          	auipc	a0,0x5
ffffffffc020a3de:	09650513          	addi	a0,a0,150 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a3e2:	8bcf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a3e6:	86dff0ef          	jal	ra,ffffffffc0209c52 <sfs_io.part.0>

ffffffffc020a3ea <sfs_write>:
ffffffffc020a3ea:	7139                	addi	sp,sp,-64
ffffffffc020a3ec:	f04a                	sd	s2,32(sp)
ffffffffc020a3ee:	06853903          	ld	s2,104(a0)
ffffffffc020a3f2:	fc06                	sd	ra,56(sp)
ffffffffc020a3f4:	f822                	sd	s0,48(sp)
ffffffffc020a3f6:	f426                	sd	s1,40(sp)
ffffffffc020a3f8:	ec4e                	sd	s3,24(sp)
ffffffffc020a3fa:	04090f63          	beqz	s2,ffffffffc020a458 <sfs_write+0x6e>
ffffffffc020a3fe:	0b092783          	lw	a5,176(s2)
ffffffffc020a402:	ebb9                	bnez	a5,ffffffffc020a458 <sfs_write+0x6e>
ffffffffc020a404:	4d38                	lw	a4,88(a0)
ffffffffc020a406:	6785                	lui	a5,0x1
ffffffffc020a408:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a40c:	842a                	mv	s0,a0
ffffffffc020a40e:	06f71563          	bne	a4,a5,ffffffffc020a478 <sfs_write+0x8e>
ffffffffc020a412:	02050993          	addi	s3,a0,32
ffffffffc020a416:	854e                	mv	a0,s3
ffffffffc020a418:	84ae                	mv	s1,a1
ffffffffc020a41a:	b9cfa0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc020a41e:	0184b803          	ld	a6,24(s1)
ffffffffc020a422:	6494                	ld	a3,8(s1)
ffffffffc020a424:	6090                	ld	a2,0(s1)
ffffffffc020a426:	85a2                	mv	a1,s0
ffffffffc020a428:	4785                	li	a5,1
ffffffffc020a42a:	0038                	addi	a4,sp,8
ffffffffc020a42c:	854a                	mv	a0,s2
ffffffffc020a42e:	e442                	sd	a6,8(sp)
ffffffffc020a430:	d59ff0ef          	jal	ra,ffffffffc020a188 <sfs_io_nolock>
ffffffffc020a434:	65a2                	ld	a1,8(sp)
ffffffffc020a436:	842a                	mv	s0,a0
ffffffffc020a438:	ed81                	bnez	a1,ffffffffc020a450 <sfs_write+0x66>
ffffffffc020a43a:	854e                	mv	a0,s3
ffffffffc020a43c:	b76fa0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020a440:	70e2                	ld	ra,56(sp)
ffffffffc020a442:	8522                	mv	a0,s0
ffffffffc020a444:	7442                	ld	s0,48(sp)
ffffffffc020a446:	74a2                	ld	s1,40(sp)
ffffffffc020a448:	7902                	ld	s2,32(sp)
ffffffffc020a44a:	69e2                	ld	s3,24(sp)
ffffffffc020a44c:	6121                	addi	sp,sp,64
ffffffffc020a44e:	8082                	ret
ffffffffc020a450:	8526                	mv	a0,s1
ffffffffc020a452:	a58fb0ef          	jal	ra,ffffffffc02056aa <iobuf_skip>
ffffffffc020a456:	b7d5                	j	ffffffffc020a43a <sfs_write+0x50>
ffffffffc020a458:	00005697          	auipc	a3,0x5
ffffffffc020a45c:	e3868693          	addi	a3,a3,-456 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc020a460:	00002617          	auipc	a2,0x2
ffffffffc020a464:	86860613          	addi	a2,a2,-1944 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a468:	29a00593          	li	a1,666
ffffffffc020a46c:	00005517          	auipc	a0,0x5
ffffffffc020a470:	00450513          	addi	a0,a0,4 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a474:	82af60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a478:	fdaff0ef          	jal	ra,ffffffffc0209c52 <sfs_io.part.0>

ffffffffc020a47c <sfs_dirent_read_nolock>:
ffffffffc020a47c:	6198                	ld	a4,0(a1)
ffffffffc020a47e:	7179                	addi	sp,sp,-48
ffffffffc020a480:	f406                	sd	ra,40(sp)
ffffffffc020a482:	00475883          	lhu	a7,4(a4)
ffffffffc020a486:	f022                	sd	s0,32(sp)
ffffffffc020a488:	ec26                	sd	s1,24(sp)
ffffffffc020a48a:	4809                	li	a6,2
ffffffffc020a48c:	05089b63          	bne	a7,a6,ffffffffc020a4e2 <sfs_dirent_read_nolock+0x66>
ffffffffc020a490:	4718                	lw	a4,8(a4)
ffffffffc020a492:	87b2                	mv	a5,a2
ffffffffc020a494:	2601                	sext.w	a2,a2
ffffffffc020a496:	04e7f663          	bgeu	a5,a4,ffffffffc020a4e2 <sfs_dirent_read_nolock+0x66>
ffffffffc020a49a:	84b6                	mv	s1,a3
ffffffffc020a49c:	0074                	addi	a3,sp,12
ffffffffc020a49e:	842a                	mv	s0,a0
ffffffffc020a4a0:	a91ff0ef          	jal	ra,ffffffffc0209f30 <sfs_bmap_load_nolock>
ffffffffc020a4a4:	c511                	beqz	a0,ffffffffc020a4b0 <sfs_dirent_read_nolock+0x34>
ffffffffc020a4a6:	70a2                	ld	ra,40(sp)
ffffffffc020a4a8:	7402                	ld	s0,32(sp)
ffffffffc020a4aa:	64e2                	ld	s1,24(sp)
ffffffffc020a4ac:	6145                	addi	sp,sp,48
ffffffffc020a4ae:	8082                	ret
ffffffffc020a4b0:	45b2                	lw	a1,12(sp)
ffffffffc020a4b2:	4054                	lw	a3,4(s0)
ffffffffc020a4b4:	c5b9                	beqz	a1,ffffffffc020a502 <sfs_dirent_read_nolock+0x86>
ffffffffc020a4b6:	04d5f663          	bgeu	a1,a3,ffffffffc020a502 <sfs_dirent_read_nolock+0x86>
ffffffffc020a4ba:	7c08                	ld	a0,56(s0)
ffffffffc020a4bc:	eadfe0ef          	jal	ra,ffffffffc0209368 <bitmap_test>
ffffffffc020a4c0:	ed31                	bnez	a0,ffffffffc020a51c <sfs_dirent_read_nolock+0xa0>
ffffffffc020a4c2:	46b2                	lw	a3,12(sp)
ffffffffc020a4c4:	4701                	li	a4,0
ffffffffc020a4c6:	10400613          	li	a2,260
ffffffffc020a4ca:	85a6                	mv	a1,s1
ffffffffc020a4cc:	8522                	mv	a0,s0
ffffffffc020a4ce:	395000ef          	jal	ra,ffffffffc020b062 <sfs_rbuf>
ffffffffc020a4d2:	f971                	bnez	a0,ffffffffc020a4a6 <sfs_dirent_read_nolock+0x2a>
ffffffffc020a4d4:	100481a3          	sb	zero,259(s1)
ffffffffc020a4d8:	70a2                	ld	ra,40(sp)
ffffffffc020a4da:	7402                	ld	s0,32(sp)
ffffffffc020a4dc:	64e2                	ld	s1,24(sp)
ffffffffc020a4de:	6145                	addi	sp,sp,48
ffffffffc020a4e0:	8082                	ret
ffffffffc020a4e2:	00005697          	auipc	a3,0x5
ffffffffc020a4e6:	11e68693          	addi	a3,a3,286 # ffffffffc020f600 <dev_node_ops+0x750>
ffffffffc020a4ea:	00001617          	auipc	a2,0x1
ffffffffc020a4ee:	7de60613          	addi	a2,a2,2014 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a4f2:	18e00593          	li	a1,398
ffffffffc020a4f6:	00005517          	auipc	a0,0x5
ffffffffc020a4fa:	f7a50513          	addi	a0,a0,-134 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a4fe:	fa1f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a502:	872e                	mv	a4,a1
ffffffffc020a504:	00005617          	auipc	a2,0x5
ffffffffc020a508:	f9c60613          	addi	a2,a2,-100 # ffffffffc020f4a0 <dev_node_ops+0x5f0>
ffffffffc020a50c:	05300593          	li	a1,83
ffffffffc020a510:	00005517          	auipc	a0,0x5
ffffffffc020a514:	f6050513          	addi	a0,a0,-160 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a518:	f87f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a51c:	00005697          	auipc	a3,0x5
ffffffffc020a520:	fbc68693          	addi	a3,a3,-68 # ffffffffc020f4d8 <dev_node_ops+0x628>
ffffffffc020a524:	00001617          	auipc	a2,0x1
ffffffffc020a528:	7a460613          	addi	a2,a2,1956 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a52c:	19500593          	li	a1,405
ffffffffc020a530:	00005517          	auipc	a0,0x5
ffffffffc020a534:	f4050513          	addi	a0,a0,-192 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a538:	f67f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a53c <sfs_getdirentry>:
ffffffffc020a53c:	715d                	addi	sp,sp,-80
ffffffffc020a53e:	ec56                	sd	s5,24(sp)
ffffffffc020a540:	8aaa                	mv	s5,a0
ffffffffc020a542:	10400513          	li	a0,260
ffffffffc020a546:	e85a                	sd	s6,16(sp)
ffffffffc020a548:	e486                	sd	ra,72(sp)
ffffffffc020a54a:	e0a2                	sd	s0,64(sp)
ffffffffc020a54c:	fc26                	sd	s1,56(sp)
ffffffffc020a54e:	f84a                	sd	s2,48(sp)
ffffffffc020a550:	f44e                	sd	s3,40(sp)
ffffffffc020a552:	f052                	sd	s4,32(sp)
ffffffffc020a554:	e45e                	sd	s7,8(sp)
ffffffffc020a556:	e062                	sd	s8,0(sp)
ffffffffc020a558:	8b2e                	mv	s6,a1
ffffffffc020a55a:	ab9f70ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc020a55e:	cd61                	beqz	a0,ffffffffc020a636 <sfs_getdirentry+0xfa>
ffffffffc020a560:	068abb83          	ld	s7,104(s5)
ffffffffc020a564:	0c0b8b63          	beqz	s7,ffffffffc020a63a <sfs_getdirentry+0xfe>
ffffffffc020a568:	0b0ba783          	lw	a5,176(s7) # 10b0 <_binary_bin_swap_img_size-0x6c50>
ffffffffc020a56c:	e7f9                	bnez	a5,ffffffffc020a63a <sfs_getdirentry+0xfe>
ffffffffc020a56e:	058aa703          	lw	a4,88(s5)
ffffffffc020a572:	6785                	lui	a5,0x1
ffffffffc020a574:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a578:	0ef71163          	bne	a4,a5,ffffffffc020a65a <sfs_getdirentry+0x11e>
ffffffffc020a57c:	008b3983          	ld	s3,8(s6)
ffffffffc020a580:	892a                	mv	s2,a0
ffffffffc020a582:	0a09c163          	bltz	s3,ffffffffc020a624 <sfs_getdirentry+0xe8>
ffffffffc020a586:	0ff9f793          	zext.b	a5,s3
ffffffffc020a58a:	efc9                	bnez	a5,ffffffffc020a624 <sfs_getdirentry+0xe8>
ffffffffc020a58c:	000ab783          	ld	a5,0(s5)
ffffffffc020a590:	0089d993          	srli	s3,s3,0x8
ffffffffc020a594:	2981                	sext.w	s3,s3
ffffffffc020a596:	479c                	lw	a5,8(a5)
ffffffffc020a598:	0937eb63          	bltu	a5,s3,ffffffffc020a62e <sfs_getdirentry+0xf2>
ffffffffc020a59c:	020a8c13          	addi	s8,s5,32
ffffffffc020a5a0:	8562                	mv	a0,s8
ffffffffc020a5a2:	a14fa0ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc020a5a6:	000ab783          	ld	a5,0(s5)
ffffffffc020a5aa:	0087aa03          	lw	s4,8(a5)
ffffffffc020a5ae:	07405663          	blez	s4,ffffffffc020a61a <sfs_getdirentry+0xde>
ffffffffc020a5b2:	4481                	li	s1,0
ffffffffc020a5b4:	a811                	j	ffffffffc020a5c8 <sfs_getdirentry+0x8c>
ffffffffc020a5b6:	00092783          	lw	a5,0(s2)
ffffffffc020a5ba:	c781                	beqz	a5,ffffffffc020a5c2 <sfs_getdirentry+0x86>
ffffffffc020a5bc:	02098263          	beqz	s3,ffffffffc020a5e0 <sfs_getdirentry+0xa4>
ffffffffc020a5c0:	39fd                	addiw	s3,s3,-1
ffffffffc020a5c2:	2485                	addiw	s1,s1,1
ffffffffc020a5c4:	049a0b63          	beq	s4,s1,ffffffffc020a61a <sfs_getdirentry+0xde>
ffffffffc020a5c8:	86ca                	mv	a3,s2
ffffffffc020a5ca:	8626                	mv	a2,s1
ffffffffc020a5cc:	85d6                	mv	a1,s5
ffffffffc020a5ce:	855e                	mv	a0,s7
ffffffffc020a5d0:	eadff0ef          	jal	ra,ffffffffc020a47c <sfs_dirent_read_nolock>
ffffffffc020a5d4:	842a                	mv	s0,a0
ffffffffc020a5d6:	d165                	beqz	a0,ffffffffc020a5b6 <sfs_getdirentry+0x7a>
ffffffffc020a5d8:	8562                	mv	a0,s8
ffffffffc020a5da:	9d8fa0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020a5de:	a831                	j	ffffffffc020a5fa <sfs_getdirentry+0xbe>
ffffffffc020a5e0:	8562                	mv	a0,s8
ffffffffc020a5e2:	9d0fa0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020a5e6:	4701                	li	a4,0
ffffffffc020a5e8:	4685                	li	a3,1
ffffffffc020a5ea:	10000613          	li	a2,256
ffffffffc020a5ee:	00490593          	addi	a1,s2,4
ffffffffc020a5f2:	855a                	mv	a0,s6
ffffffffc020a5f4:	84afb0ef          	jal	ra,ffffffffc020563e <iobuf_move>
ffffffffc020a5f8:	842a                	mv	s0,a0
ffffffffc020a5fa:	854a                	mv	a0,s2
ffffffffc020a5fc:	ac7f70ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc020a600:	60a6                	ld	ra,72(sp)
ffffffffc020a602:	8522                	mv	a0,s0
ffffffffc020a604:	6406                	ld	s0,64(sp)
ffffffffc020a606:	74e2                	ld	s1,56(sp)
ffffffffc020a608:	7942                	ld	s2,48(sp)
ffffffffc020a60a:	79a2                	ld	s3,40(sp)
ffffffffc020a60c:	7a02                	ld	s4,32(sp)
ffffffffc020a60e:	6ae2                	ld	s5,24(sp)
ffffffffc020a610:	6b42                	ld	s6,16(sp)
ffffffffc020a612:	6ba2                	ld	s7,8(sp)
ffffffffc020a614:	6c02                	ld	s8,0(sp)
ffffffffc020a616:	6161                	addi	sp,sp,80
ffffffffc020a618:	8082                	ret
ffffffffc020a61a:	8562                	mv	a0,s8
ffffffffc020a61c:	5441                	li	s0,-16
ffffffffc020a61e:	994fa0ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020a622:	bfe1                	j	ffffffffc020a5fa <sfs_getdirentry+0xbe>
ffffffffc020a624:	854a                	mv	a0,s2
ffffffffc020a626:	a9df70ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc020a62a:	5475                	li	s0,-3
ffffffffc020a62c:	bfd1                	j	ffffffffc020a600 <sfs_getdirentry+0xc4>
ffffffffc020a62e:	a95f70ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc020a632:	5441                	li	s0,-16
ffffffffc020a634:	b7f1                	j	ffffffffc020a600 <sfs_getdirentry+0xc4>
ffffffffc020a636:	5471                	li	s0,-4
ffffffffc020a638:	b7e1                	j	ffffffffc020a600 <sfs_getdirentry+0xc4>
ffffffffc020a63a:	00005697          	auipc	a3,0x5
ffffffffc020a63e:	c5668693          	addi	a3,a3,-938 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc020a642:	00001617          	auipc	a2,0x1
ffffffffc020a646:	68660613          	addi	a2,a2,1670 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a64a:	33e00593          	li	a1,830
ffffffffc020a64e:	00005517          	auipc	a0,0x5
ffffffffc020a652:	e2250513          	addi	a0,a0,-478 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a656:	e49f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a65a:	00005697          	auipc	a3,0x5
ffffffffc020a65e:	dde68693          	addi	a3,a3,-546 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc020a662:	00001617          	auipc	a2,0x1
ffffffffc020a666:	66660613          	addi	a2,a2,1638 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a66a:	33f00593          	li	a1,831
ffffffffc020a66e:	00005517          	auipc	a0,0x5
ffffffffc020a672:	e0250513          	addi	a0,a0,-510 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a676:	e29f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a67a <sfs_dirent_search_nolock.constprop.0>:
ffffffffc020a67a:	715d                	addi	sp,sp,-80
ffffffffc020a67c:	f052                	sd	s4,32(sp)
ffffffffc020a67e:	8a2a                	mv	s4,a0
ffffffffc020a680:	8532                	mv	a0,a2
ffffffffc020a682:	f44e                	sd	s3,40(sp)
ffffffffc020a684:	e85a                	sd	s6,16(sp)
ffffffffc020a686:	e45e                	sd	s7,8(sp)
ffffffffc020a688:	e486                	sd	ra,72(sp)
ffffffffc020a68a:	e0a2                	sd	s0,64(sp)
ffffffffc020a68c:	fc26                	sd	s1,56(sp)
ffffffffc020a68e:	f84a                	sd	s2,48(sp)
ffffffffc020a690:	ec56                	sd	s5,24(sp)
ffffffffc020a692:	e062                	sd	s8,0(sp)
ffffffffc020a694:	8b32                	mv	s6,a2
ffffffffc020a696:	89ae                	mv	s3,a1
ffffffffc020a698:	8bb6                	mv	s7,a3
ffffffffc020a69a:	0aa010ef          	jal	ra,ffffffffc020b744 <strlen>
ffffffffc020a69e:	0ff00793          	li	a5,255
ffffffffc020a6a2:	06a7ef63          	bltu	a5,a0,ffffffffc020a720 <sfs_dirent_search_nolock.constprop.0+0xa6>
ffffffffc020a6a6:	10400513          	li	a0,260
ffffffffc020a6aa:	969f70ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc020a6ae:	892a                	mv	s2,a0
ffffffffc020a6b0:	c535                	beqz	a0,ffffffffc020a71c <sfs_dirent_search_nolock.constprop.0+0xa2>
ffffffffc020a6b2:	0009b783          	ld	a5,0(s3)
ffffffffc020a6b6:	0087aa83          	lw	s5,8(a5)
ffffffffc020a6ba:	05505a63          	blez	s5,ffffffffc020a70e <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a6be:	4481                	li	s1,0
ffffffffc020a6c0:	00450c13          	addi	s8,a0,4
ffffffffc020a6c4:	a829                	j	ffffffffc020a6de <sfs_dirent_search_nolock.constprop.0+0x64>
ffffffffc020a6c6:	00092783          	lw	a5,0(s2)
ffffffffc020a6ca:	c799                	beqz	a5,ffffffffc020a6d8 <sfs_dirent_search_nolock.constprop.0+0x5e>
ffffffffc020a6cc:	85e2                	mv	a1,s8
ffffffffc020a6ce:	855a                	mv	a0,s6
ffffffffc020a6d0:	0bc010ef          	jal	ra,ffffffffc020b78c <strcmp>
ffffffffc020a6d4:	842a                	mv	s0,a0
ffffffffc020a6d6:	cd15                	beqz	a0,ffffffffc020a712 <sfs_dirent_search_nolock.constprop.0+0x98>
ffffffffc020a6d8:	2485                	addiw	s1,s1,1
ffffffffc020a6da:	029a8a63          	beq	s5,s1,ffffffffc020a70e <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a6de:	86ca                	mv	a3,s2
ffffffffc020a6e0:	8626                	mv	a2,s1
ffffffffc020a6e2:	85ce                	mv	a1,s3
ffffffffc020a6e4:	8552                	mv	a0,s4
ffffffffc020a6e6:	d97ff0ef          	jal	ra,ffffffffc020a47c <sfs_dirent_read_nolock>
ffffffffc020a6ea:	842a                	mv	s0,a0
ffffffffc020a6ec:	dd69                	beqz	a0,ffffffffc020a6c6 <sfs_dirent_search_nolock.constprop.0+0x4c>
ffffffffc020a6ee:	854a                	mv	a0,s2
ffffffffc020a6f0:	9d3f70ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc020a6f4:	60a6                	ld	ra,72(sp)
ffffffffc020a6f6:	8522                	mv	a0,s0
ffffffffc020a6f8:	6406                	ld	s0,64(sp)
ffffffffc020a6fa:	74e2                	ld	s1,56(sp)
ffffffffc020a6fc:	7942                	ld	s2,48(sp)
ffffffffc020a6fe:	79a2                	ld	s3,40(sp)
ffffffffc020a700:	7a02                	ld	s4,32(sp)
ffffffffc020a702:	6ae2                	ld	s5,24(sp)
ffffffffc020a704:	6b42                	ld	s6,16(sp)
ffffffffc020a706:	6ba2                	ld	s7,8(sp)
ffffffffc020a708:	6c02                	ld	s8,0(sp)
ffffffffc020a70a:	6161                	addi	sp,sp,80
ffffffffc020a70c:	8082                	ret
ffffffffc020a70e:	5441                	li	s0,-16
ffffffffc020a710:	bff9                	j	ffffffffc020a6ee <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a712:	00092783          	lw	a5,0(s2)
ffffffffc020a716:	00fba023          	sw	a5,0(s7)
ffffffffc020a71a:	bfd1                	j	ffffffffc020a6ee <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a71c:	5471                	li	s0,-4
ffffffffc020a71e:	bfd9                	j	ffffffffc020a6f4 <sfs_dirent_search_nolock.constprop.0+0x7a>
ffffffffc020a720:	00005697          	auipc	a3,0x5
ffffffffc020a724:	f3068693          	addi	a3,a3,-208 # ffffffffc020f650 <dev_node_ops+0x7a0>
ffffffffc020a728:	00001617          	auipc	a2,0x1
ffffffffc020a72c:	5a060613          	addi	a2,a2,1440 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a730:	1ba00593          	li	a1,442
ffffffffc020a734:	00005517          	auipc	a0,0x5
ffffffffc020a738:	d3c50513          	addi	a0,a0,-708 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a73c:	d63f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a740 <sfs_truncfile>:
ffffffffc020a740:	7175                	addi	sp,sp,-144
ffffffffc020a742:	e506                	sd	ra,136(sp)
ffffffffc020a744:	e122                	sd	s0,128(sp)
ffffffffc020a746:	fca6                	sd	s1,120(sp)
ffffffffc020a748:	f8ca                	sd	s2,112(sp)
ffffffffc020a74a:	f4ce                	sd	s3,104(sp)
ffffffffc020a74c:	f0d2                	sd	s4,96(sp)
ffffffffc020a74e:	ecd6                	sd	s5,88(sp)
ffffffffc020a750:	e8da                	sd	s6,80(sp)
ffffffffc020a752:	e4de                	sd	s7,72(sp)
ffffffffc020a754:	e0e2                	sd	s8,64(sp)
ffffffffc020a756:	fc66                	sd	s9,56(sp)
ffffffffc020a758:	f86a                	sd	s10,48(sp)
ffffffffc020a75a:	f46e                	sd	s11,40(sp)
ffffffffc020a75c:	080007b7          	lui	a5,0x8000
ffffffffc020a760:	16b7e463          	bltu	a5,a1,ffffffffc020a8c8 <sfs_truncfile+0x188>
ffffffffc020a764:	06853c83          	ld	s9,104(a0)
ffffffffc020a768:	89aa                	mv	s3,a0
ffffffffc020a76a:	160c8163          	beqz	s9,ffffffffc020a8cc <sfs_truncfile+0x18c>
ffffffffc020a76e:	0b0ca783          	lw	a5,176(s9)
ffffffffc020a772:	14079d63          	bnez	a5,ffffffffc020a8cc <sfs_truncfile+0x18c>
ffffffffc020a776:	4d38                	lw	a4,88(a0)
ffffffffc020a778:	6405                	lui	s0,0x1
ffffffffc020a77a:	23540793          	addi	a5,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a77e:	16f71763          	bne	a4,a5,ffffffffc020a8ec <sfs_truncfile+0x1ac>
ffffffffc020a782:	00053a83          	ld	s5,0(a0)
ffffffffc020a786:	147d                	addi	s0,s0,-1
ffffffffc020a788:	942e                	add	s0,s0,a1
ffffffffc020a78a:	000ae783          	lwu	a5,0(s5)
ffffffffc020a78e:	8031                	srli	s0,s0,0xc
ffffffffc020a790:	8a2e                	mv	s4,a1
ffffffffc020a792:	2401                	sext.w	s0,s0
ffffffffc020a794:	02b79763          	bne	a5,a1,ffffffffc020a7c2 <sfs_truncfile+0x82>
ffffffffc020a798:	008aa783          	lw	a5,8(s5)
ffffffffc020a79c:	4901                	li	s2,0
ffffffffc020a79e:	18879763          	bne	a5,s0,ffffffffc020a92c <sfs_truncfile+0x1ec>
ffffffffc020a7a2:	60aa                	ld	ra,136(sp)
ffffffffc020a7a4:	640a                	ld	s0,128(sp)
ffffffffc020a7a6:	74e6                	ld	s1,120(sp)
ffffffffc020a7a8:	79a6                	ld	s3,104(sp)
ffffffffc020a7aa:	7a06                	ld	s4,96(sp)
ffffffffc020a7ac:	6ae6                	ld	s5,88(sp)
ffffffffc020a7ae:	6b46                	ld	s6,80(sp)
ffffffffc020a7b0:	6ba6                	ld	s7,72(sp)
ffffffffc020a7b2:	6c06                	ld	s8,64(sp)
ffffffffc020a7b4:	7ce2                	ld	s9,56(sp)
ffffffffc020a7b6:	7d42                	ld	s10,48(sp)
ffffffffc020a7b8:	7da2                	ld	s11,40(sp)
ffffffffc020a7ba:	854a                	mv	a0,s2
ffffffffc020a7bc:	7946                	ld	s2,112(sp)
ffffffffc020a7be:	6149                	addi	sp,sp,144
ffffffffc020a7c0:	8082                	ret
ffffffffc020a7c2:	02050b13          	addi	s6,a0,32
ffffffffc020a7c6:	855a                	mv	a0,s6
ffffffffc020a7c8:	feff90ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc020a7cc:	008aa483          	lw	s1,8(s5)
ffffffffc020a7d0:	0a84e663          	bltu	s1,s0,ffffffffc020a87c <sfs_truncfile+0x13c>
ffffffffc020a7d4:	0c947163          	bgeu	s0,s1,ffffffffc020a896 <sfs_truncfile+0x156>
ffffffffc020a7d8:	4dad                	li	s11,11
ffffffffc020a7da:	4b85                	li	s7,1
ffffffffc020a7dc:	a09d                	j	ffffffffc020a842 <sfs_truncfile+0x102>
ffffffffc020a7de:	ff37091b          	addiw	s2,a4,-13
ffffffffc020a7e2:	0009079b          	sext.w	a5,s2
ffffffffc020a7e6:	3ff00713          	li	a4,1023
ffffffffc020a7ea:	04f76563          	bltu	a4,a5,ffffffffc020a834 <sfs_truncfile+0xf4>
ffffffffc020a7ee:	03cd2c03          	lw	s8,60(s10)
ffffffffc020a7f2:	040c0163          	beqz	s8,ffffffffc020a834 <sfs_truncfile+0xf4>
ffffffffc020a7f6:	004ca783          	lw	a5,4(s9)
ffffffffc020a7fa:	18fc7963          	bgeu	s8,a5,ffffffffc020a98c <sfs_truncfile+0x24c>
ffffffffc020a7fe:	038cb503          	ld	a0,56(s9)
ffffffffc020a802:	85e2                	mv	a1,s8
ffffffffc020a804:	b65fe0ef          	jal	ra,ffffffffc0209368 <bitmap_test>
ffffffffc020a808:	16051263          	bnez	a0,ffffffffc020a96c <sfs_truncfile+0x22c>
ffffffffc020a80c:	02091793          	slli	a5,s2,0x20
ffffffffc020a810:	01e7d713          	srli	a4,a5,0x1e
ffffffffc020a814:	86e2                	mv	a3,s8
ffffffffc020a816:	4611                	li	a2,4
ffffffffc020a818:	082c                	addi	a1,sp,24
ffffffffc020a81a:	8566                	mv	a0,s9
ffffffffc020a81c:	e43a                	sd	a4,8(sp)
ffffffffc020a81e:	ce02                	sw	zero,28(sp)
ffffffffc020a820:	043000ef          	jal	ra,ffffffffc020b062 <sfs_rbuf>
ffffffffc020a824:	892a                	mv	s2,a0
ffffffffc020a826:	e141                	bnez	a0,ffffffffc020a8a6 <sfs_truncfile+0x166>
ffffffffc020a828:	47e2                	lw	a5,24(sp)
ffffffffc020a82a:	6722                	ld	a4,8(sp)
ffffffffc020a82c:	e3c9                	bnez	a5,ffffffffc020a8ae <sfs_truncfile+0x16e>
ffffffffc020a82e:	008d2603          	lw	a2,8(s10)
ffffffffc020a832:	367d                	addiw	a2,a2,-1
ffffffffc020a834:	00cd2423          	sw	a2,8(s10)
ffffffffc020a838:	0179b823          	sd	s7,16(s3)
ffffffffc020a83c:	34fd                	addiw	s1,s1,-1
ffffffffc020a83e:	04940a63          	beq	s0,s1,ffffffffc020a892 <sfs_truncfile+0x152>
ffffffffc020a842:	0009bd03          	ld	s10,0(s3)
ffffffffc020a846:	008d2703          	lw	a4,8(s10)
ffffffffc020a84a:	c369                	beqz	a4,ffffffffc020a90c <sfs_truncfile+0x1cc>
ffffffffc020a84c:	fff7079b          	addiw	a5,a4,-1
ffffffffc020a850:	0007861b          	sext.w	a2,a5
ffffffffc020a854:	f8cde5e3          	bltu	s11,a2,ffffffffc020a7de <sfs_truncfile+0x9e>
ffffffffc020a858:	02079713          	slli	a4,a5,0x20
ffffffffc020a85c:	01e75793          	srli	a5,a4,0x1e
ffffffffc020a860:	00fd0933          	add	s2,s10,a5
ffffffffc020a864:	00c92583          	lw	a1,12(s2)
ffffffffc020a868:	d5f1                	beqz	a1,ffffffffc020a834 <sfs_truncfile+0xf4>
ffffffffc020a86a:	8566                	mv	a0,s9
ffffffffc020a86c:	c0aff0ef          	jal	ra,ffffffffc0209c76 <sfs_block_free>
ffffffffc020a870:	00092623          	sw	zero,12(s2)
ffffffffc020a874:	008d2603          	lw	a2,8(s10)
ffffffffc020a878:	367d                	addiw	a2,a2,-1
ffffffffc020a87a:	bf6d                	j	ffffffffc020a834 <sfs_truncfile+0xf4>
ffffffffc020a87c:	4681                	li	a3,0
ffffffffc020a87e:	8626                	mv	a2,s1
ffffffffc020a880:	85ce                	mv	a1,s3
ffffffffc020a882:	8566                	mv	a0,s9
ffffffffc020a884:	eacff0ef          	jal	ra,ffffffffc0209f30 <sfs_bmap_load_nolock>
ffffffffc020a888:	892a                	mv	s2,a0
ffffffffc020a88a:	ed11                	bnez	a0,ffffffffc020a8a6 <sfs_truncfile+0x166>
ffffffffc020a88c:	2485                	addiw	s1,s1,1
ffffffffc020a88e:	fe9417e3          	bne	s0,s1,ffffffffc020a87c <sfs_truncfile+0x13c>
ffffffffc020a892:	008aa483          	lw	s1,8(s5)
ffffffffc020a896:	0a941b63          	bne	s0,s1,ffffffffc020a94c <sfs_truncfile+0x20c>
ffffffffc020a89a:	014aa023          	sw	s4,0(s5)
ffffffffc020a89e:	4785                	li	a5,1
ffffffffc020a8a0:	00f9b823          	sd	a5,16(s3)
ffffffffc020a8a4:	4901                	li	s2,0
ffffffffc020a8a6:	855a                	mv	a0,s6
ffffffffc020a8a8:	f0bf90ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020a8ac:	bddd                	j	ffffffffc020a7a2 <sfs_truncfile+0x62>
ffffffffc020a8ae:	86e2                	mv	a3,s8
ffffffffc020a8b0:	4611                	li	a2,4
ffffffffc020a8b2:	086c                	addi	a1,sp,28
ffffffffc020a8b4:	8566                	mv	a0,s9
ffffffffc020a8b6:	02d000ef          	jal	ra,ffffffffc020b0e2 <sfs_wbuf>
ffffffffc020a8ba:	892a                	mv	s2,a0
ffffffffc020a8bc:	f56d                	bnez	a0,ffffffffc020a8a6 <sfs_truncfile+0x166>
ffffffffc020a8be:	45e2                	lw	a1,24(sp)
ffffffffc020a8c0:	8566                	mv	a0,s9
ffffffffc020a8c2:	bb4ff0ef          	jal	ra,ffffffffc0209c76 <sfs_block_free>
ffffffffc020a8c6:	b7a5                	j	ffffffffc020a82e <sfs_truncfile+0xee>
ffffffffc020a8c8:	5975                	li	s2,-3
ffffffffc020a8ca:	bde1                	j	ffffffffc020a7a2 <sfs_truncfile+0x62>
ffffffffc020a8cc:	00005697          	auipc	a3,0x5
ffffffffc020a8d0:	9c468693          	addi	a3,a3,-1596 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc020a8d4:	00001617          	auipc	a2,0x1
ffffffffc020a8d8:	3f460613          	addi	a2,a2,1012 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a8dc:	3ad00593          	li	a1,941
ffffffffc020a8e0:	00005517          	auipc	a0,0x5
ffffffffc020a8e4:	b9050513          	addi	a0,a0,-1136 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a8e8:	bb7f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a8ec:	00005697          	auipc	a3,0x5
ffffffffc020a8f0:	b4c68693          	addi	a3,a3,-1204 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc020a8f4:	00001617          	auipc	a2,0x1
ffffffffc020a8f8:	3d460613          	addi	a2,a2,980 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a8fc:	3ae00593          	li	a1,942
ffffffffc020a900:	00005517          	auipc	a0,0x5
ffffffffc020a904:	b7050513          	addi	a0,a0,-1168 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a908:	b97f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a90c:	00005697          	auipc	a3,0x5
ffffffffc020a910:	d8468693          	addi	a3,a3,-636 # ffffffffc020f690 <dev_node_ops+0x7e0>
ffffffffc020a914:	00001617          	auipc	a2,0x1
ffffffffc020a918:	3b460613          	addi	a2,a2,948 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a91c:	17b00593          	li	a1,379
ffffffffc020a920:	00005517          	auipc	a0,0x5
ffffffffc020a924:	b5050513          	addi	a0,a0,-1200 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a928:	b77f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a92c:	00005697          	auipc	a3,0x5
ffffffffc020a930:	d4c68693          	addi	a3,a3,-692 # ffffffffc020f678 <dev_node_ops+0x7c8>
ffffffffc020a934:	00001617          	auipc	a2,0x1
ffffffffc020a938:	39460613          	addi	a2,a2,916 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a93c:	3b500593          	li	a1,949
ffffffffc020a940:	00005517          	auipc	a0,0x5
ffffffffc020a944:	b3050513          	addi	a0,a0,-1232 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a948:	b57f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a94c:	00005697          	auipc	a3,0x5
ffffffffc020a950:	d9468693          	addi	a3,a3,-620 # ffffffffc020f6e0 <dev_node_ops+0x830>
ffffffffc020a954:	00001617          	auipc	a2,0x1
ffffffffc020a958:	37460613          	addi	a2,a2,884 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a95c:	3ce00593          	li	a1,974
ffffffffc020a960:	00005517          	auipc	a0,0x5
ffffffffc020a964:	b1050513          	addi	a0,a0,-1264 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a968:	b37f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a96c:	00005697          	auipc	a3,0x5
ffffffffc020a970:	d3c68693          	addi	a3,a3,-708 # ffffffffc020f6a8 <dev_node_ops+0x7f8>
ffffffffc020a974:	00001617          	auipc	a2,0x1
ffffffffc020a978:	35460613          	addi	a2,a2,852 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020a97c:	12b00593          	li	a1,299
ffffffffc020a980:	00005517          	auipc	a0,0x5
ffffffffc020a984:	af050513          	addi	a0,a0,-1296 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a988:	b17f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a98c:	8762                	mv	a4,s8
ffffffffc020a98e:	86be                	mv	a3,a5
ffffffffc020a990:	00005617          	auipc	a2,0x5
ffffffffc020a994:	b1060613          	addi	a2,a2,-1264 # ffffffffc020f4a0 <dev_node_ops+0x5f0>
ffffffffc020a998:	05300593          	li	a1,83
ffffffffc020a99c:	00005517          	auipc	a0,0x5
ffffffffc020a9a0:	ad450513          	addi	a0,a0,-1324 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020a9a4:	afbf50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a9a8 <sfs_load_inode>:
ffffffffc020a9a8:	7139                	addi	sp,sp,-64
ffffffffc020a9aa:	fc06                	sd	ra,56(sp)
ffffffffc020a9ac:	f822                	sd	s0,48(sp)
ffffffffc020a9ae:	f426                	sd	s1,40(sp)
ffffffffc020a9b0:	f04a                	sd	s2,32(sp)
ffffffffc020a9b2:	84b2                	mv	s1,a2
ffffffffc020a9b4:	892a                	mv	s2,a0
ffffffffc020a9b6:	ec4e                	sd	s3,24(sp)
ffffffffc020a9b8:	e852                	sd	s4,16(sp)
ffffffffc020a9ba:	89ae                	mv	s3,a1
ffffffffc020a9bc:	e456                	sd	s5,8(sp)
ffffffffc020a9be:	0d5000ef          	jal	ra,ffffffffc020b292 <lock_sfs_fs>
ffffffffc020a9c2:	45a9                	li	a1,10
ffffffffc020a9c4:	8526                	mv	a0,s1
ffffffffc020a9c6:	0a893403          	ld	s0,168(s2)
ffffffffc020a9ca:	0e9000ef          	jal	ra,ffffffffc020b2b2 <hash32>
ffffffffc020a9ce:	02051793          	slli	a5,a0,0x20
ffffffffc020a9d2:	01c7d713          	srli	a4,a5,0x1c
ffffffffc020a9d6:	9722                	add	a4,a4,s0
ffffffffc020a9d8:	843a                	mv	s0,a4
ffffffffc020a9da:	a029                	j	ffffffffc020a9e4 <sfs_load_inode+0x3c>
ffffffffc020a9dc:	fc042783          	lw	a5,-64(s0)
ffffffffc020a9e0:	10978863          	beq	a5,s1,ffffffffc020aaf0 <sfs_load_inode+0x148>
ffffffffc020a9e4:	6400                	ld	s0,8(s0)
ffffffffc020a9e6:	fe871be3          	bne	a4,s0,ffffffffc020a9dc <sfs_load_inode+0x34>
ffffffffc020a9ea:	04000513          	li	a0,64
ffffffffc020a9ee:	e24f70ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc020a9f2:	8aaa                	mv	s5,a0
ffffffffc020a9f4:	16050563          	beqz	a0,ffffffffc020ab5e <sfs_load_inode+0x1b6>
ffffffffc020a9f8:	00492683          	lw	a3,4(s2)
ffffffffc020a9fc:	18048363          	beqz	s1,ffffffffc020ab82 <sfs_load_inode+0x1da>
ffffffffc020aa00:	18d4f163          	bgeu	s1,a3,ffffffffc020ab82 <sfs_load_inode+0x1da>
ffffffffc020aa04:	03893503          	ld	a0,56(s2)
ffffffffc020aa08:	85a6                	mv	a1,s1
ffffffffc020aa0a:	95ffe0ef          	jal	ra,ffffffffc0209368 <bitmap_test>
ffffffffc020aa0e:	18051763          	bnez	a0,ffffffffc020ab9c <sfs_load_inode+0x1f4>
ffffffffc020aa12:	4701                	li	a4,0
ffffffffc020aa14:	86a6                	mv	a3,s1
ffffffffc020aa16:	04000613          	li	a2,64
ffffffffc020aa1a:	85d6                	mv	a1,s5
ffffffffc020aa1c:	854a                	mv	a0,s2
ffffffffc020aa1e:	644000ef          	jal	ra,ffffffffc020b062 <sfs_rbuf>
ffffffffc020aa22:	842a                	mv	s0,a0
ffffffffc020aa24:	0e051563          	bnez	a0,ffffffffc020ab0e <sfs_load_inode+0x166>
ffffffffc020aa28:	006ad783          	lhu	a5,6(s5)
ffffffffc020aa2c:	12078b63          	beqz	a5,ffffffffc020ab62 <sfs_load_inode+0x1ba>
ffffffffc020aa30:	6405                	lui	s0,0x1
ffffffffc020aa32:	23540513          	addi	a0,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020aa36:	8ecfd0ef          	jal	ra,ffffffffc0207b22 <__alloc_inode>
ffffffffc020aa3a:	8a2a                	mv	s4,a0
ffffffffc020aa3c:	c961                	beqz	a0,ffffffffc020ab0c <sfs_load_inode+0x164>
ffffffffc020aa3e:	004ad683          	lhu	a3,4(s5)
ffffffffc020aa42:	4785                	li	a5,1
ffffffffc020aa44:	0cf69c63          	bne	a3,a5,ffffffffc020ab1c <sfs_load_inode+0x174>
ffffffffc020aa48:	864a                	mv	a2,s2
ffffffffc020aa4a:	00005597          	auipc	a1,0x5
ffffffffc020aa4e:	da658593          	addi	a1,a1,-602 # ffffffffc020f7f0 <sfs_node_fileops>
ffffffffc020aa52:	8ecfd0ef          	jal	ra,ffffffffc0207b3e <inode_init>
ffffffffc020aa56:	058a2783          	lw	a5,88(s4) # 8000058 <_binary_bin_sfs_img_size+0x7f8ad58>
ffffffffc020aa5a:	23540413          	addi	s0,s0,565
ffffffffc020aa5e:	0e879063          	bne	a5,s0,ffffffffc020ab3e <sfs_load_inode+0x196>
ffffffffc020aa62:	4785                	li	a5,1
ffffffffc020aa64:	00fa2c23          	sw	a5,24(s4)
ffffffffc020aa68:	015a3023          	sd	s5,0(s4)
ffffffffc020aa6c:	009a2423          	sw	s1,8(s4)
ffffffffc020aa70:	000a3823          	sd	zero,16(s4)
ffffffffc020aa74:	4585                	li	a1,1
ffffffffc020aa76:	020a0513          	addi	a0,s4,32
ffffffffc020aa7a:	d33f90ef          	jal	ra,ffffffffc02047ac <sem_init>
ffffffffc020aa7e:	058a2703          	lw	a4,88(s4)
ffffffffc020aa82:	6785                	lui	a5,0x1
ffffffffc020aa84:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020aa88:	14f71663          	bne	a4,a5,ffffffffc020abd4 <sfs_load_inode+0x22c>
ffffffffc020aa8c:	0a093703          	ld	a4,160(s2)
ffffffffc020aa90:	038a0793          	addi	a5,s4,56
ffffffffc020aa94:	008a2503          	lw	a0,8(s4)
ffffffffc020aa98:	e31c                	sd	a5,0(a4)
ffffffffc020aa9a:	0af93023          	sd	a5,160(s2)
ffffffffc020aa9e:	09890793          	addi	a5,s2,152
ffffffffc020aaa2:	0a893403          	ld	s0,168(s2)
ffffffffc020aaa6:	45a9                	li	a1,10
ffffffffc020aaa8:	04ea3023          	sd	a4,64(s4)
ffffffffc020aaac:	02fa3c23          	sd	a5,56(s4)
ffffffffc020aab0:	003000ef          	jal	ra,ffffffffc020b2b2 <hash32>
ffffffffc020aab4:	02051713          	slli	a4,a0,0x20
ffffffffc020aab8:	01c75793          	srli	a5,a4,0x1c
ffffffffc020aabc:	97a2                	add	a5,a5,s0
ffffffffc020aabe:	6798                	ld	a4,8(a5)
ffffffffc020aac0:	048a0693          	addi	a3,s4,72
ffffffffc020aac4:	e314                	sd	a3,0(a4)
ffffffffc020aac6:	e794                	sd	a3,8(a5)
ffffffffc020aac8:	04ea3823          	sd	a4,80(s4)
ffffffffc020aacc:	04fa3423          	sd	a5,72(s4)
ffffffffc020aad0:	854a                	mv	a0,s2
ffffffffc020aad2:	7d0000ef          	jal	ra,ffffffffc020b2a2 <unlock_sfs_fs>
ffffffffc020aad6:	4401                	li	s0,0
ffffffffc020aad8:	0149b023          	sd	s4,0(s3)
ffffffffc020aadc:	70e2                	ld	ra,56(sp)
ffffffffc020aade:	8522                	mv	a0,s0
ffffffffc020aae0:	7442                	ld	s0,48(sp)
ffffffffc020aae2:	74a2                	ld	s1,40(sp)
ffffffffc020aae4:	7902                	ld	s2,32(sp)
ffffffffc020aae6:	69e2                	ld	s3,24(sp)
ffffffffc020aae8:	6a42                	ld	s4,16(sp)
ffffffffc020aaea:	6aa2                	ld	s5,8(sp)
ffffffffc020aaec:	6121                	addi	sp,sp,64
ffffffffc020aaee:	8082                	ret
ffffffffc020aaf0:	fb840a13          	addi	s4,s0,-72
ffffffffc020aaf4:	8552                	mv	a0,s4
ffffffffc020aaf6:	8aafd0ef          	jal	ra,ffffffffc0207ba0 <inode_ref_inc>
ffffffffc020aafa:	4785                	li	a5,1
ffffffffc020aafc:	fcf51ae3          	bne	a0,a5,ffffffffc020aad0 <sfs_load_inode+0x128>
ffffffffc020ab00:	fd042783          	lw	a5,-48(s0)
ffffffffc020ab04:	2785                	addiw	a5,a5,1
ffffffffc020ab06:	fcf42823          	sw	a5,-48(s0)
ffffffffc020ab0a:	b7d9                	j	ffffffffc020aad0 <sfs_load_inode+0x128>
ffffffffc020ab0c:	5471                	li	s0,-4
ffffffffc020ab0e:	8556                	mv	a0,s5
ffffffffc020ab10:	db2f70ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc020ab14:	854a                	mv	a0,s2
ffffffffc020ab16:	78c000ef          	jal	ra,ffffffffc020b2a2 <unlock_sfs_fs>
ffffffffc020ab1a:	b7c9                	j	ffffffffc020aadc <sfs_load_inode+0x134>
ffffffffc020ab1c:	4789                	li	a5,2
ffffffffc020ab1e:	08f69f63          	bne	a3,a5,ffffffffc020abbc <sfs_load_inode+0x214>
ffffffffc020ab22:	864a                	mv	a2,s2
ffffffffc020ab24:	00005597          	auipc	a1,0x5
ffffffffc020ab28:	c4c58593          	addi	a1,a1,-948 # ffffffffc020f770 <sfs_node_dirops>
ffffffffc020ab2c:	812fd0ef          	jal	ra,ffffffffc0207b3e <inode_init>
ffffffffc020ab30:	058a2703          	lw	a4,88(s4)
ffffffffc020ab34:	6785                	lui	a5,0x1
ffffffffc020ab36:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020ab3a:	f2f704e3          	beq	a4,a5,ffffffffc020aa62 <sfs_load_inode+0xba>
ffffffffc020ab3e:	00005697          	auipc	a3,0x5
ffffffffc020ab42:	8fa68693          	addi	a3,a3,-1798 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc020ab46:	00001617          	auipc	a2,0x1
ffffffffc020ab4a:	18260613          	addi	a2,a2,386 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020ab4e:	07700593          	li	a1,119
ffffffffc020ab52:	00005517          	auipc	a0,0x5
ffffffffc020ab56:	91e50513          	addi	a0,a0,-1762 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020ab5a:	945f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020ab5e:	5471                	li	s0,-4
ffffffffc020ab60:	bf55                	j	ffffffffc020ab14 <sfs_load_inode+0x16c>
ffffffffc020ab62:	00005697          	auipc	a3,0x5
ffffffffc020ab66:	b9668693          	addi	a3,a3,-1130 # ffffffffc020f6f8 <dev_node_ops+0x848>
ffffffffc020ab6a:	00001617          	auipc	a2,0x1
ffffffffc020ab6e:	15e60613          	addi	a2,a2,350 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020ab72:	0ad00593          	li	a1,173
ffffffffc020ab76:	00005517          	auipc	a0,0x5
ffffffffc020ab7a:	8fa50513          	addi	a0,a0,-1798 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020ab7e:	921f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020ab82:	8726                	mv	a4,s1
ffffffffc020ab84:	00005617          	auipc	a2,0x5
ffffffffc020ab88:	91c60613          	addi	a2,a2,-1764 # ffffffffc020f4a0 <dev_node_ops+0x5f0>
ffffffffc020ab8c:	05300593          	li	a1,83
ffffffffc020ab90:	00005517          	auipc	a0,0x5
ffffffffc020ab94:	8e050513          	addi	a0,a0,-1824 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020ab98:	907f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020ab9c:	00005697          	auipc	a3,0x5
ffffffffc020aba0:	93c68693          	addi	a3,a3,-1732 # ffffffffc020f4d8 <dev_node_ops+0x628>
ffffffffc020aba4:	00001617          	auipc	a2,0x1
ffffffffc020aba8:	12460613          	addi	a2,a2,292 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020abac:	0a800593          	li	a1,168
ffffffffc020abb0:	00005517          	auipc	a0,0x5
ffffffffc020abb4:	8c050513          	addi	a0,a0,-1856 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020abb8:	8e7f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020abbc:	00005617          	auipc	a2,0x5
ffffffffc020abc0:	8cc60613          	addi	a2,a2,-1844 # ffffffffc020f488 <dev_node_ops+0x5d8>
ffffffffc020abc4:	02e00593          	li	a1,46
ffffffffc020abc8:	00005517          	auipc	a0,0x5
ffffffffc020abcc:	8a850513          	addi	a0,a0,-1880 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020abd0:	8cff50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020abd4:	00005697          	auipc	a3,0x5
ffffffffc020abd8:	86468693          	addi	a3,a3,-1948 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc020abdc:	00001617          	auipc	a2,0x1
ffffffffc020abe0:	0ec60613          	addi	a2,a2,236 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020abe4:	0b100593          	li	a1,177
ffffffffc020abe8:	00005517          	auipc	a0,0x5
ffffffffc020abec:	88850513          	addi	a0,a0,-1912 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020abf0:	8aff50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020abf4 <sfs_lookup>:
ffffffffc020abf4:	7139                	addi	sp,sp,-64
ffffffffc020abf6:	ec4e                	sd	s3,24(sp)
ffffffffc020abf8:	06853983          	ld	s3,104(a0)
ffffffffc020abfc:	fc06                	sd	ra,56(sp)
ffffffffc020abfe:	f822                	sd	s0,48(sp)
ffffffffc020ac00:	f426                	sd	s1,40(sp)
ffffffffc020ac02:	f04a                	sd	s2,32(sp)
ffffffffc020ac04:	e852                	sd	s4,16(sp)
ffffffffc020ac06:	0a098c63          	beqz	s3,ffffffffc020acbe <sfs_lookup+0xca>
ffffffffc020ac0a:	0b09a783          	lw	a5,176(s3)
ffffffffc020ac0e:	ebc5                	bnez	a5,ffffffffc020acbe <sfs_lookup+0xca>
ffffffffc020ac10:	0005c783          	lbu	a5,0(a1)
ffffffffc020ac14:	84ae                	mv	s1,a1
ffffffffc020ac16:	c7c1                	beqz	a5,ffffffffc020ac9e <sfs_lookup+0xaa>
ffffffffc020ac18:	02f00713          	li	a4,47
ffffffffc020ac1c:	08e78163          	beq	a5,a4,ffffffffc020ac9e <sfs_lookup+0xaa>
ffffffffc020ac20:	842a                	mv	s0,a0
ffffffffc020ac22:	8a32                	mv	s4,a2
ffffffffc020ac24:	f7dfc0ef          	jal	ra,ffffffffc0207ba0 <inode_ref_inc>
ffffffffc020ac28:	4c38                	lw	a4,88(s0)
ffffffffc020ac2a:	6785                	lui	a5,0x1
ffffffffc020ac2c:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020ac30:	0af71763          	bne	a4,a5,ffffffffc020acde <sfs_lookup+0xea>
ffffffffc020ac34:	6018                	ld	a4,0(s0)
ffffffffc020ac36:	4789                	li	a5,2
ffffffffc020ac38:	00475703          	lhu	a4,4(a4)
ffffffffc020ac3c:	04f71c63          	bne	a4,a5,ffffffffc020ac94 <sfs_lookup+0xa0>
ffffffffc020ac40:	02040913          	addi	s2,s0,32
ffffffffc020ac44:	854a                	mv	a0,s2
ffffffffc020ac46:	b71f90ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc020ac4a:	8626                	mv	a2,s1
ffffffffc020ac4c:	0054                	addi	a3,sp,4
ffffffffc020ac4e:	85a2                	mv	a1,s0
ffffffffc020ac50:	854e                	mv	a0,s3
ffffffffc020ac52:	a29ff0ef          	jal	ra,ffffffffc020a67a <sfs_dirent_search_nolock.constprop.0>
ffffffffc020ac56:	84aa                	mv	s1,a0
ffffffffc020ac58:	854a                	mv	a0,s2
ffffffffc020ac5a:	b59f90ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020ac5e:	cc89                	beqz	s1,ffffffffc020ac78 <sfs_lookup+0x84>
ffffffffc020ac60:	8522                	mv	a0,s0
ffffffffc020ac62:	80cfd0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc020ac66:	70e2                	ld	ra,56(sp)
ffffffffc020ac68:	7442                	ld	s0,48(sp)
ffffffffc020ac6a:	7902                	ld	s2,32(sp)
ffffffffc020ac6c:	69e2                	ld	s3,24(sp)
ffffffffc020ac6e:	6a42                	ld	s4,16(sp)
ffffffffc020ac70:	8526                	mv	a0,s1
ffffffffc020ac72:	74a2                	ld	s1,40(sp)
ffffffffc020ac74:	6121                	addi	sp,sp,64
ffffffffc020ac76:	8082                	ret
ffffffffc020ac78:	4612                	lw	a2,4(sp)
ffffffffc020ac7a:	002c                	addi	a1,sp,8
ffffffffc020ac7c:	854e                	mv	a0,s3
ffffffffc020ac7e:	d2bff0ef          	jal	ra,ffffffffc020a9a8 <sfs_load_inode>
ffffffffc020ac82:	84aa                	mv	s1,a0
ffffffffc020ac84:	8522                	mv	a0,s0
ffffffffc020ac86:	fe9fc0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc020ac8a:	fcf1                	bnez	s1,ffffffffc020ac66 <sfs_lookup+0x72>
ffffffffc020ac8c:	67a2                	ld	a5,8(sp)
ffffffffc020ac8e:	00fa3023          	sd	a5,0(s4)
ffffffffc020ac92:	bfd1                	j	ffffffffc020ac66 <sfs_lookup+0x72>
ffffffffc020ac94:	8522                	mv	a0,s0
ffffffffc020ac96:	fd9fc0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc020ac9a:	54b9                	li	s1,-18
ffffffffc020ac9c:	b7e9                	j	ffffffffc020ac66 <sfs_lookup+0x72>
ffffffffc020ac9e:	00005697          	auipc	a3,0x5
ffffffffc020aca2:	a7268693          	addi	a3,a3,-1422 # ffffffffc020f710 <dev_node_ops+0x860>
ffffffffc020aca6:	00001617          	auipc	a2,0x1
ffffffffc020acaa:	02260613          	addi	a2,a2,34 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020acae:	3df00593          	li	a1,991
ffffffffc020acb2:	00004517          	auipc	a0,0x4
ffffffffc020acb6:	7be50513          	addi	a0,a0,1982 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020acba:	fe4f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020acbe:	00004697          	auipc	a3,0x4
ffffffffc020acc2:	5d268693          	addi	a3,a3,1490 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc020acc6:	00001617          	auipc	a2,0x1
ffffffffc020acca:	00260613          	addi	a2,a2,2 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020acce:	3de00593          	li	a1,990
ffffffffc020acd2:	00004517          	auipc	a0,0x4
ffffffffc020acd6:	79e50513          	addi	a0,a0,1950 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020acda:	fc4f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020acde:	00004697          	auipc	a3,0x4
ffffffffc020ace2:	75a68693          	addi	a3,a3,1882 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc020ace6:	00001617          	auipc	a2,0x1
ffffffffc020acea:	fe260613          	addi	a2,a2,-30 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020acee:	3e100593          	li	a1,993
ffffffffc020acf2:	00004517          	auipc	a0,0x4
ffffffffc020acf6:	77e50513          	addi	a0,a0,1918 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020acfa:	fa4f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020acfe <sfs_namefile>:
ffffffffc020acfe:	6d98                	ld	a4,24(a1)
ffffffffc020ad00:	7175                	addi	sp,sp,-144
ffffffffc020ad02:	e506                	sd	ra,136(sp)
ffffffffc020ad04:	e122                	sd	s0,128(sp)
ffffffffc020ad06:	fca6                	sd	s1,120(sp)
ffffffffc020ad08:	f8ca                	sd	s2,112(sp)
ffffffffc020ad0a:	f4ce                	sd	s3,104(sp)
ffffffffc020ad0c:	f0d2                	sd	s4,96(sp)
ffffffffc020ad0e:	ecd6                	sd	s5,88(sp)
ffffffffc020ad10:	e8da                	sd	s6,80(sp)
ffffffffc020ad12:	e4de                	sd	s7,72(sp)
ffffffffc020ad14:	e0e2                	sd	s8,64(sp)
ffffffffc020ad16:	fc66                	sd	s9,56(sp)
ffffffffc020ad18:	f86a                	sd	s10,48(sp)
ffffffffc020ad1a:	f46e                	sd	s11,40(sp)
ffffffffc020ad1c:	e42e                	sd	a1,8(sp)
ffffffffc020ad1e:	4789                	li	a5,2
ffffffffc020ad20:	1ae7f363          	bgeu	a5,a4,ffffffffc020aec6 <sfs_namefile+0x1c8>
ffffffffc020ad24:	89aa                	mv	s3,a0
ffffffffc020ad26:	10400513          	li	a0,260
ffffffffc020ad2a:	ae8f70ef          	jal	ra,ffffffffc0202012 <kmalloc>
ffffffffc020ad2e:	842a                	mv	s0,a0
ffffffffc020ad30:	18050b63          	beqz	a0,ffffffffc020aec6 <sfs_namefile+0x1c8>
ffffffffc020ad34:	0689b483          	ld	s1,104(s3)
ffffffffc020ad38:	1e048963          	beqz	s1,ffffffffc020af2a <sfs_namefile+0x22c>
ffffffffc020ad3c:	0b04a783          	lw	a5,176(s1)
ffffffffc020ad40:	1e079563          	bnez	a5,ffffffffc020af2a <sfs_namefile+0x22c>
ffffffffc020ad44:	0589ac83          	lw	s9,88(s3)
ffffffffc020ad48:	6785                	lui	a5,0x1
ffffffffc020ad4a:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020ad4e:	1afc9e63          	bne	s9,a5,ffffffffc020af0a <sfs_namefile+0x20c>
ffffffffc020ad52:	6722                	ld	a4,8(sp)
ffffffffc020ad54:	854e                	mv	a0,s3
ffffffffc020ad56:	8ace                	mv	s5,s3
ffffffffc020ad58:	6f1c                	ld	a5,24(a4)
ffffffffc020ad5a:	00073b03          	ld	s6,0(a4)
ffffffffc020ad5e:	02098a13          	addi	s4,s3,32
ffffffffc020ad62:	ffe78b93          	addi	s7,a5,-2
ffffffffc020ad66:	9b3e                	add	s6,s6,a5
ffffffffc020ad68:	00005d17          	auipc	s10,0x5
ffffffffc020ad6c:	9c8d0d13          	addi	s10,s10,-1592 # ffffffffc020f730 <dev_node_ops+0x880>
ffffffffc020ad70:	e31fc0ef          	jal	ra,ffffffffc0207ba0 <inode_ref_inc>
ffffffffc020ad74:	00440c13          	addi	s8,s0,4
ffffffffc020ad78:	e066                	sd	s9,0(sp)
ffffffffc020ad7a:	8552                	mv	a0,s4
ffffffffc020ad7c:	a3bf90ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc020ad80:	0854                	addi	a3,sp,20
ffffffffc020ad82:	866a                	mv	a2,s10
ffffffffc020ad84:	85d6                	mv	a1,s5
ffffffffc020ad86:	8526                	mv	a0,s1
ffffffffc020ad88:	8f3ff0ef          	jal	ra,ffffffffc020a67a <sfs_dirent_search_nolock.constprop.0>
ffffffffc020ad8c:	8daa                	mv	s11,a0
ffffffffc020ad8e:	8552                	mv	a0,s4
ffffffffc020ad90:	a23f90ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020ad94:	020d8863          	beqz	s11,ffffffffc020adc4 <sfs_namefile+0xc6>
ffffffffc020ad98:	854e                	mv	a0,s3
ffffffffc020ad9a:	ed5fc0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc020ad9e:	8522                	mv	a0,s0
ffffffffc020ada0:	b22f70ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc020ada4:	60aa                	ld	ra,136(sp)
ffffffffc020ada6:	640a                	ld	s0,128(sp)
ffffffffc020ada8:	74e6                	ld	s1,120(sp)
ffffffffc020adaa:	7946                	ld	s2,112(sp)
ffffffffc020adac:	79a6                	ld	s3,104(sp)
ffffffffc020adae:	7a06                	ld	s4,96(sp)
ffffffffc020adb0:	6ae6                	ld	s5,88(sp)
ffffffffc020adb2:	6b46                	ld	s6,80(sp)
ffffffffc020adb4:	6ba6                	ld	s7,72(sp)
ffffffffc020adb6:	6c06                	ld	s8,64(sp)
ffffffffc020adb8:	7ce2                	ld	s9,56(sp)
ffffffffc020adba:	7d42                	ld	s10,48(sp)
ffffffffc020adbc:	856e                	mv	a0,s11
ffffffffc020adbe:	7da2                	ld	s11,40(sp)
ffffffffc020adc0:	6149                	addi	sp,sp,144
ffffffffc020adc2:	8082                	ret
ffffffffc020adc4:	4652                	lw	a2,20(sp)
ffffffffc020adc6:	082c                	addi	a1,sp,24
ffffffffc020adc8:	8526                	mv	a0,s1
ffffffffc020adca:	bdfff0ef          	jal	ra,ffffffffc020a9a8 <sfs_load_inode>
ffffffffc020adce:	8daa                	mv	s11,a0
ffffffffc020add0:	f561                	bnez	a0,ffffffffc020ad98 <sfs_namefile+0x9a>
ffffffffc020add2:	854e                	mv	a0,s3
ffffffffc020add4:	008aa903          	lw	s2,8(s5)
ffffffffc020add8:	e97fc0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc020addc:	6ce2                	ld	s9,24(sp)
ffffffffc020adde:	0b3c8463          	beq	s9,s3,ffffffffc020ae86 <sfs_namefile+0x188>
ffffffffc020ade2:	100c8463          	beqz	s9,ffffffffc020aeea <sfs_namefile+0x1ec>
ffffffffc020ade6:	058ca703          	lw	a4,88(s9)
ffffffffc020adea:	6782                	ld	a5,0(sp)
ffffffffc020adec:	0ef71f63          	bne	a4,a5,ffffffffc020aeea <sfs_namefile+0x1ec>
ffffffffc020adf0:	008ca703          	lw	a4,8(s9)
ffffffffc020adf4:	8ae6                	mv	s5,s9
ffffffffc020adf6:	0d270a63          	beq	a4,s2,ffffffffc020aeca <sfs_namefile+0x1cc>
ffffffffc020adfa:	000cb703          	ld	a4,0(s9)
ffffffffc020adfe:	4789                	li	a5,2
ffffffffc020ae00:	00475703          	lhu	a4,4(a4)
ffffffffc020ae04:	0cf71363          	bne	a4,a5,ffffffffc020aeca <sfs_namefile+0x1cc>
ffffffffc020ae08:	020c8a13          	addi	s4,s9,32
ffffffffc020ae0c:	8552                	mv	a0,s4
ffffffffc020ae0e:	9a9f90ef          	jal	ra,ffffffffc02047b6 <down>
ffffffffc020ae12:	000cb703          	ld	a4,0(s9)
ffffffffc020ae16:	00872983          	lw	s3,8(a4)
ffffffffc020ae1a:	01304963          	bgtz	s3,ffffffffc020ae2c <sfs_namefile+0x12e>
ffffffffc020ae1e:	a899                	j	ffffffffc020ae74 <sfs_namefile+0x176>
ffffffffc020ae20:	4018                	lw	a4,0(s0)
ffffffffc020ae22:	01270e63          	beq	a4,s2,ffffffffc020ae3e <sfs_namefile+0x140>
ffffffffc020ae26:	2d85                	addiw	s11,s11,1
ffffffffc020ae28:	05b98663          	beq	s3,s11,ffffffffc020ae74 <sfs_namefile+0x176>
ffffffffc020ae2c:	86a2                	mv	a3,s0
ffffffffc020ae2e:	866e                	mv	a2,s11
ffffffffc020ae30:	85e6                	mv	a1,s9
ffffffffc020ae32:	8526                	mv	a0,s1
ffffffffc020ae34:	e48ff0ef          	jal	ra,ffffffffc020a47c <sfs_dirent_read_nolock>
ffffffffc020ae38:	872a                	mv	a4,a0
ffffffffc020ae3a:	d17d                	beqz	a0,ffffffffc020ae20 <sfs_namefile+0x122>
ffffffffc020ae3c:	a82d                	j	ffffffffc020ae76 <sfs_namefile+0x178>
ffffffffc020ae3e:	8552                	mv	a0,s4
ffffffffc020ae40:	973f90ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020ae44:	8562                	mv	a0,s8
ffffffffc020ae46:	0ff000ef          	jal	ra,ffffffffc020b744 <strlen>
ffffffffc020ae4a:	00150793          	addi	a5,a0,1
ffffffffc020ae4e:	862a                	mv	a2,a0
ffffffffc020ae50:	06fbe863          	bltu	s7,a5,ffffffffc020aec0 <sfs_namefile+0x1c2>
ffffffffc020ae54:	fff64913          	not	s2,a2
ffffffffc020ae58:	995a                	add	s2,s2,s6
ffffffffc020ae5a:	85e2                	mv	a1,s8
ffffffffc020ae5c:	854a                	mv	a0,s2
ffffffffc020ae5e:	40fb8bb3          	sub	s7,s7,a5
ffffffffc020ae62:	1d7000ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc020ae66:	02f00793          	li	a5,47
ffffffffc020ae6a:	fefb0fa3          	sb	a5,-1(s6)
ffffffffc020ae6e:	89e6                	mv	s3,s9
ffffffffc020ae70:	8b4a                	mv	s6,s2
ffffffffc020ae72:	b721                	j	ffffffffc020ad7a <sfs_namefile+0x7c>
ffffffffc020ae74:	5741                	li	a4,-16
ffffffffc020ae76:	8552                	mv	a0,s4
ffffffffc020ae78:	e03a                	sd	a4,0(sp)
ffffffffc020ae7a:	939f90ef          	jal	ra,ffffffffc02047b2 <up>
ffffffffc020ae7e:	6702                	ld	a4,0(sp)
ffffffffc020ae80:	89e6                	mv	s3,s9
ffffffffc020ae82:	8dba                	mv	s11,a4
ffffffffc020ae84:	bf11                	j	ffffffffc020ad98 <sfs_namefile+0x9a>
ffffffffc020ae86:	854e                	mv	a0,s3
ffffffffc020ae88:	de7fc0ef          	jal	ra,ffffffffc0207c6e <inode_ref_dec>
ffffffffc020ae8c:	64a2                	ld	s1,8(sp)
ffffffffc020ae8e:	85da                	mv	a1,s6
ffffffffc020ae90:	6c98                	ld	a4,24(s1)
ffffffffc020ae92:	6088                	ld	a0,0(s1)
ffffffffc020ae94:	1779                	addi	a4,a4,-2
ffffffffc020ae96:	41770bb3          	sub	s7,a4,s7
ffffffffc020ae9a:	865e                	mv	a2,s7
ffffffffc020ae9c:	0505                	addi	a0,a0,1
ffffffffc020ae9e:	15b000ef          	jal	ra,ffffffffc020b7f8 <memmove>
ffffffffc020aea2:	02f00713          	li	a4,47
ffffffffc020aea6:	fee50fa3          	sb	a4,-1(a0)
ffffffffc020aeaa:	955e                	add	a0,a0,s7
ffffffffc020aeac:	00050023          	sb	zero,0(a0)
ffffffffc020aeb0:	85de                	mv	a1,s7
ffffffffc020aeb2:	8526                	mv	a0,s1
ffffffffc020aeb4:	ff6fa0ef          	jal	ra,ffffffffc02056aa <iobuf_skip>
ffffffffc020aeb8:	8522                	mv	a0,s0
ffffffffc020aeba:	a08f70ef          	jal	ra,ffffffffc02020c2 <kfree>
ffffffffc020aebe:	b5dd                	j	ffffffffc020ada4 <sfs_namefile+0xa6>
ffffffffc020aec0:	89e6                	mv	s3,s9
ffffffffc020aec2:	5df1                	li	s11,-4
ffffffffc020aec4:	bdd1                	j	ffffffffc020ad98 <sfs_namefile+0x9a>
ffffffffc020aec6:	5df1                	li	s11,-4
ffffffffc020aec8:	bdf1                	j	ffffffffc020ada4 <sfs_namefile+0xa6>
ffffffffc020aeca:	00005697          	auipc	a3,0x5
ffffffffc020aece:	86e68693          	addi	a3,a3,-1938 # ffffffffc020f738 <dev_node_ops+0x888>
ffffffffc020aed2:	00001617          	auipc	a2,0x1
ffffffffc020aed6:	df660613          	addi	a2,a2,-522 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020aeda:	2fd00593          	li	a1,765
ffffffffc020aede:	00004517          	auipc	a0,0x4
ffffffffc020aee2:	59250513          	addi	a0,a0,1426 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020aee6:	db8f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020aeea:	00004697          	auipc	a3,0x4
ffffffffc020aeee:	54e68693          	addi	a3,a3,1358 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc020aef2:	00001617          	auipc	a2,0x1
ffffffffc020aef6:	dd660613          	addi	a2,a2,-554 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020aefa:	2fc00593          	li	a1,764
ffffffffc020aefe:	00004517          	auipc	a0,0x4
ffffffffc020af02:	57250513          	addi	a0,a0,1394 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020af06:	d98f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020af0a:	00004697          	auipc	a3,0x4
ffffffffc020af0e:	52e68693          	addi	a3,a3,1326 # ffffffffc020f438 <dev_node_ops+0x588>
ffffffffc020af12:	00001617          	auipc	a2,0x1
ffffffffc020af16:	db660613          	addi	a2,a2,-586 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020af1a:	2e900593          	li	a1,745
ffffffffc020af1e:	00004517          	auipc	a0,0x4
ffffffffc020af22:	55250513          	addi	a0,a0,1362 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020af26:	d78f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020af2a:	00004697          	auipc	a3,0x4
ffffffffc020af2e:	36668693          	addi	a3,a3,870 # ffffffffc020f290 <dev_node_ops+0x3e0>
ffffffffc020af32:	00001617          	auipc	a2,0x1
ffffffffc020af36:	d9660613          	addi	a2,a2,-618 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020af3a:	2e800593          	li	a1,744
ffffffffc020af3e:	00004517          	auipc	a0,0x4
ffffffffc020af42:	53250513          	addi	a0,a0,1330 # ffffffffc020f470 <dev_node_ops+0x5c0>
ffffffffc020af46:	d58f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020af4a <sfs_rwblock_nolock>:
ffffffffc020af4a:	7139                	addi	sp,sp,-64
ffffffffc020af4c:	f822                	sd	s0,48(sp)
ffffffffc020af4e:	f426                	sd	s1,40(sp)
ffffffffc020af50:	fc06                	sd	ra,56(sp)
ffffffffc020af52:	842a                	mv	s0,a0
ffffffffc020af54:	84b6                	mv	s1,a3
ffffffffc020af56:	e211                	bnez	a2,ffffffffc020af5a <sfs_rwblock_nolock+0x10>
ffffffffc020af58:	e715                	bnez	a4,ffffffffc020af84 <sfs_rwblock_nolock+0x3a>
ffffffffc020af5a:	405c                	lw	a5,4(s0)
ffffffffc020af5c:	02f67463          	bgeu	a2,a5,ffffffffc020af84 <sfs_rwblock_nolock+0x3a>
ffffffffc020af60:	00c6169b          	slliw	a3,a2,0xc
ffffffffc020af64:	1682                	slli	a3,a3,0x20
ffffffffc020af66:	6605                	lui	a2,0x1
ffffffffc020af68:	9281                	srli	a3,a3,0x20
ffffffffc020af6a:	850a                	mv	a0,sp
ffffffffc020af6c:	ec8fa0ef          	jal	ra,ffffffffc0205634 <iobuf_init>
ffffffffc020af70:	85aa                	mv	a1,a0
ffffffffc020af72:	7808                	ld	a0,48(s0)
ffffffffc020af74:	8626                	mv	a2,s1
ffffffffc020af76:	7118                	ld	a4,32(a0)
ffffffffc020af78:	9702                	jalr	a4
ffffffffc020af7a:	70e2                	ld	ra,56(sp)
ffffffffc020af7c:	7442                	ld	s0,48(sp)
ffffffffc020af7e:	74a2                	ld	s1,40(sp)
ffffffffc020af80:	6121                	addi	sp,sp,64
ffffffffc020af82:	8082                	ret
ffffffffc020af84:	00005697          	auipc	a3,0x5
ffffffffc020af88:	8ec68693          	addi	a3,a3,-1812 # ffffffffc020f870 <sfs_node_fileops+0x80>
ffffffffc020af8c:	00001617          	auipc	a2,0x1
ffffffffc020af90:	d3c60613          	addi	a2,a2,-708 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020af94:	45d5                	li	a1,21
ffffffffc020af96:	00005517          	auipc	a0,0x5
ffffffffc020af9a:	91250513          	addi	a0,a0,-1774 # ffffffffc020f8a8 <sfs_node_fileops+0xb8>
ffffffffc020af9e:	d00f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020afa2 <sfs_rblock>:
ffffffffc020afa2:	7139                	addi	sp,sp,-64
ffffffffc020afa4:	ec4e                	sd	s3,24(sp)
ffffffffc020afa6:	89b6                	mv	s3,a3
ffffffffc020afa8:	f822                	sd	s0,48(sp)
ffffffffc020afaa:	f04a                	sd	s2,32(sp)
ffffffffc020afac:	e852                	sd	s4,16(sp)
ffffffffc020afae:	fc06                	sd	ra,56(sp)
ffffffffc020afb0:	f426                	sd	s1,40(sp)
ffffffffc020afb2:	e456                	sd	s5,8(sp)
ffffffffc020afb4:	8a2a                	mv	s4,a0
ffffffffc020afb6:	892e                	mv	s2,a1
ffffffffc020afb8:	8432                	mv	s0,a2
ffffffffc020afba:	2e0000ef          	jal	ra,ffffffffc020b29a <lock_sfs_io>
ffffffffc020afbe:	04098063          	beqz	s3,ffffffffc020affe <sfs_rblock+0x5c>
ffffffffc020afc2:	013409bb          	addw	s3,s0,s3
ffffffffc020afc6:	6a85                	lui	s5,0x1
ffffffffc020afc8:	a021                	j	ffffffffc020afd0 <sfs_rblock+0x2e>
ffffffffc020afca:	9956                	add	s2,s2,s5
ffffffffc020afcc:	02898963          	beq	s3,s0,ffffffffc020affe <sfs_rblock+0x5c>
ffffffffc020afd0:	8622                	mv	a2,s0
ffffffffc020afd2:	85ca                	mv	a1,s2
ffffffffc020afd4:	4705                	li	a4,1
ffffffffc020afd6:	4681                	li	a3,0
ffffffffc020afd8:	8552                	mv	a0,s4
ffffffffc020afda:	f71ff0ef          	jal	ra,ffffffffc020af4a <sfs_rwblock_nolock>
ffffffffc020afde:	84aa                	mv	s1,a0
ffffffffc020afe0:	2405                	addiw	s0,s0,1
ffffffffc020afe2:	d565                	beqz	a0,ffffffffc020afca <sfs_rblock+0x28>
ffffffffc020afe4:	8552                	mv	a0,s4
ffffffffc020afe6:	2c4000ef          	jal	ra,ffffffffc020b2aa <unlock_sfs_io>
ffffffffc020afea:	70e2                	ld	ra,56(sp)
ffffffffc020afec:	7442                	ld	s0,48(sp)
ffffffffc020afee:	7902                	ld	s2,32(sp)
ffffffffc020aff0:	69e2                	ld	s3,24(sp)
ffffffffc020aff2:	6a42                	ld	s4,16(sp)
ffffffffc020aff4:	6aa2                	ld	s5,8(sp)
ffffffffc020aff6:	8526                	mv	a0,s1
ffffffffc020aff8:	74a2                	ld	s1,40(sp)
ffffffffc020affa:	6121                	addi	sp,sp,64
ffffffffc020affc:	8082                	ret
ffffffffc020affe:	4481                	li	s1,0
ffffffffc020b000:	b7d5                	j	ffffffffc020afe4 <sfs_rblock+0x42>

ffffffffc020b002 <sfs_wblock>:
ffffffffc020b002:	7139                	addi	sp,sp,-64
ffffffffc020b004:	ec4e                	sd	s3,24(sp)
ffffffffc020b006:	89b6                	mv	s3,a3
ffffffffc020b008:	f822                	sd	s0,48(sp)
ffffffffc020b00a:	f04a                	sd	s2,32(sp)
ffffffffc020b00c:	e852                	sd	s4,16(sp)
ffffffffc020b00e:	fc06                	sd	ra,56(sp)
ffffffffc020b010:	f426                	sd	s1,40(sp)
ffffffffc020b012:	e456                	sd	s5,8(sp)
ffffffffc020b014:	8a2a                	mv	s4,a0
ffffffffc020b016:	892e                	mv	s2,a1
ffffffffc020b018:	8432                	mv	s0,a2
ffffffffc020b01a:	280000ef          	jal	ra,ffffffffc020b29a <lock_sfs_io>
ffffffffc020b01e:	04098063          	beqz	s3,ffffffffc020b05e <sfs_wblock+0x5c>
ffffffffc020b022:	013409bb          	addw	s3,s0,s3
ffffffffc020b026:	6a85                	lui	s5,0x1
ffffffffc020b028:	a021                	j	ffffffffc020b030 <sfs_wblock+0x2e>
ffffffffc020b02a:	9956                	add	s2,s2,s5
ffffffffc020b02c:	02898963          	beq	s3,s0,ffffffffc020b05e <sfs_wblock+0x5c>
ffffffffc020b030:	8622                	mv	a2,s0
ffffffffc020b032:	85ca                	mv	a1,s2
ffffffffc020b034:	4705                	li	a4,1
ffffffffc020b036:	4685                	li	a3,1
ffffffffc020b038:	8552                	mv	a0,s4
ffffffffc020b03a:	f11ff0ef          	jal	ra,ffffffffc020af4a <sfs_rwblock_nolock>
ffffffffc020b03e:	84aa                	mv	s1,a0
ffffffffc020b040:	2405                	addiw	s0,s0,1
ffffffffc020b042:	d565                	beqz	a0,ffffffffc020b02a <sfs_wblock+0x28>
ffffffffc020b044:	8552                	mv	a0,s4
ffffffffc020b046:	264000ef          	jal	ra,ffffffffc020b2aa <unlock_sfs_io>
ffffffffc020b04a:	70e2                	ld	ra,56(sp)
ffffffffc020b04c:	7442                	ld	s0,48(sp)
ffffffffc020b04e:	7902                	ld	s2,32(sp)
ffffffffc020b050:	69e2                	ld	s3,24(sp)
ffffffffc020b052:	6a42                	ld	s4,16(sp)
ffffffffc020b054:	6aa2                	ld	s5,8(sp)
ffffffffc020b056:	8526                	mv	a0,s1
ffffffffc020b058:	74a2                	ld	s1,40(sp)
ffffffffc020b05a:	6121                	addi	sp,sp,64
ffffffffc020b05c:	8082                	ret
ffffffffc020b05e:	4481                	li	s1,0
ffffffffc020b060:	b7d5                	j	ffffffffc020b044 <sfs_wblock+0x42>

ffffffffc020b062 <sfs_rbuf>:
ffffffffc020b062:	7179                	addi	sp,sp,-48
ffffffffc020b064:	f406                	sd	ra,40(sp)
ffffffffc020b066:	f022                	sd	s0,32(sp)
ffffffffc020b068:	ec26                	sd	s1,24(sp)
ffffffffc020b06a:	e84a                	sd	s2,16(sp)
ffffffffc020b06c:	e44e                	sd	s3,8(sp)
ffffffffc020b06e:	e052                	sd	s4,0(sp)
ffffffffc020b070:	6785                	lui	a5,0x1
ffffffffc020b072:	04f77863          	bgeu	a4,a5,ffffffffc020b0c2 <sfs_rbuf+0x60>
ffffffffc020b076:	84ba                	mv	s1,a4
ffffffffc020b078:	9732                	add	a4,a4,a2
ffffffffc020b07a:	89b2                	mv	s3,a2
ffffffffc020b07c:	04e7e363          	bltu	a5,a4,ffffffffc020b0c2 <sfs_rbuf+0x60>
ffffffffc020b080:	8936                	mv	s2,a3
ffffffffc020b082:	842a                	mv	s0,a0
ffffffffc020b084:	8a2e                	mv	s4,a1
ffffffffc020b086:	214000ef          	jal	ra,ffffffffc020b29a <lock_sfs_io>
ffffffffc020b08a:	642c                	ld	a1,72(s0)
ffffffffc020b08c:	864a                	mv	a2,s2
ffffffffc020b08e:	4705                	li	a4,1
ffffffffc020b090:	4681                	li	a3,0
ffffffffc020b092:	8522                	mv	a0,s0
ffffffffc020b094:	eb7ff0ef          	jal	ra,ffffffffc020af4a <sfs_rwblock_nolock>
ffffffffc020b098:	892a                	mv	s2,a0
ffffffffc020b09a:	cd09                	beqz	a0,ffffffffc020b0b4 <sfs_rbuf+0x52>
ffffffffc020b09c:	8522                	mv	a0,s0
ffffffffc020b09e:	20c000ef          	jal	ra,ffffffffc020b2aa <unlock_sfs_io>
ffffffffc020b0a2:	70a2                	ld	ra,40(sp)
ffffffffc020b0a4:	7402                	ld	s0,32(sp)
ffffffffc020b0a6:	64e2                	ld	s1,24(sp)
ffffffffc020b0a8:	69a2                	ld	s3,8(sp)
ffffffffc020b0aa:	6a02                	ld	s4,0(sp)
ffffffffc020b0ac:	854a                	mv	a0,s2
ffffffffc020b0ae:	6942                	ld	s2,16(sp)
ffffffffc020b0b0:	6145                	addi	sp,sp,48
ffffffffc020b0b2:	8082                	ret
ffffffffc020b0b4:	642c                	ld	a1,72(s0)
ffffffffc020b0b6:	864e                	mv	a2,s3
ffffffffc020b0b8:	8552                	mv	a0,s4
ffffffffc020b0ba:	95a6                	add	a1,a1,s1
ffffffffc020b0bc:	77c000ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc020b0c0:	bff1                	j	ffffffffc020b09c <sfs_rbuf+0x3a>
ffffffffc020b0c2:	00004697          	auipc	a3,0x4
ffffffffc020b0c6:	7fe68693          	addi	a3,a3,2046 # ffffffffc020f8c0 <sfs_node_fileops+0xd0>
ffffffffc020b0ca:	00001617          	auipc	a2,0x1
ffffffffc020b0ce:	bfe60613          	addi	a2,a2,-1026 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020b0d2:	05500593          	li	a1,85
ffffffffc020b0d6:	00004517          	auipc	a0,0x4
ffffffffc020b0da:	7d250513          	addi	a0,a0,2002 # ffffffffc020f8a8 <sfs_node_fileops+0xb8>
ffffffffc020b0de:	bc0f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020b0e2 <sfs_wbuf>:
ffffffffc020b0e2:	7139                	addi	sp,sp,-64
ffffffffc020b0e4:	fc06                	sd	ra,56(sp)
ffffffffc020b0e6:	f822                	sd	s0,48(sp)
ffffffffc020b0e8:	f426                	sd	s1,40(sp)
ffffffffc020b0ea:	f04a                	sd	s2,32(sp)
ffffffffc020b0ec:	ec4e                	sd	s3,24(sp)
ffffffffc020b0ee:	e852                	sd	s4,16(sp)
ffffffffc020b0f0:	e456                	sd	s5,8(sp)
ffffffffc020b0f2:	6785                	lui	a5,0x1
ffffffffc020b0f4:	06f77163          	bgeu	a4,a5,ffffffffc020b156 <sfs_wbuf+0x74>
ffffffffc020b0f8:	893a                	mv	s2,a4
ffffffffc020b0fa:	9732                	add	a4,a4,a2
ffffffffc020b0fc:	8a32                	mv	s4,a2
ffffffffc020b0fe:	04e7ec63          	bltu	a5,a4,ffffffffc020b156 <sfs_wbuf+0x74>
ffffffffc020b102:	842a                	mv	s0,a0
ffffffffc020b104:	89b6                	mv	s3,a3
ffffffffc020b106:	8aae                	mv	s5,a1
ffffffffc020b108:	192000ef          	jal	ra,ffffffffc020b29a <lock_sfs_io>
ffffffffc020b10c:	642c                	ld	a1,72(s0)
ffffffffc020b10e:	4705                	li	a4,1
ffffffffc020b110:	4681                	li	a3,0
ffffffffc020b112:	864e                	mv	a2,s3
ffffffffc020b114:	8522                	mv	a0,s0
ffffffffc020b116:	e35ff0ef          	jal	ra,ffffffffc020af4a <sfs_rwblock_nolock>
ffffffffc020b11a:	84aa                	mv	s1,a0
ffffffffc020b11c:	cd11                	beqz	a0,ffffffffc020b138 <sfs_wbuf+0x56>
ffffffffc020b11e:	8522                	mv	a0,s0
ffffffffc020b120:	18a000ef          	jal	ra,ffffffffc020b2aa <unlock_sfs_io>
ffffffffc020b124:	70e2                	ld	ra,56(sp)
ffffffffc020b126:	7442                	ld	s0,48(sp)
ffffffffc020b128:	7902                	ld	s2,32(sp)
ffffffffc020b12a:	69e2                	ld	s3,24(sp)
ffffffffc020b12c:	6a42                	ld	s4,16(sp)
ffffffffc020b12e:	6aa2                	ld	s5,8(sp)
ffffffffc020b130:	8526                	mv	a0,s1
ffffffffc020b132:	74a2                	ld	s1,40(sp)
ffffffffc020b134:	6121                	addi	sp,sp,64
ffffffffc020b136:	8082                	ret
ffffffffc020b138:	6428                	ld	a0,72(s0)
ffffffffc020b13a:	8652                	mv	a2,s4
ffffffffc020b13c:	85d6                	mv	a1,s5
ffffffffc020b13e:	954a                	add	a0,a0,s2
ffffffffc020b140:	6f8000ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc020b144:	642c                	ld	a1,72(s0)
ffffffffc020b146:	4705                	li	a4,1
ffffffffc020b148:	4685                	li	a3,1
ffffffffc020b14a:	864e                	mv	a2,s3
ffffffffc020b14c:	8522                	mv	a0,s0
ffffffffc020b14e:	dfdff0ef          	jal	ra,ffffffffc020af4a <sfs_rwblock_nolock>
ffffffffc020b152:	84aa                	mv	s1,a0
ffffffffc020b154:	b7e9                	j	ffffffffc020b11e <sfs_wbuf+0x3c>
ffffffffc020b156:	00004697          	auipc	a3,0x4
ffffffffc020b15a:	76a68693          	addi	a3,a3,1898 # ffffffffc020f8c0 <sfs_node_fileops+0xd0>
ffffffffc020b15e:	00001617          	auipc	a2,0x1
ffffffffc020b162:	b6a60613          	addi	a2,a2,-1174 # ffffffffc020bcc8 <commands+0x210>
ffffffffc020b166:	06b00593          	li	a1,107
ffffffffc020b16a:	00004517          	auipc	a0,0x4
ffffffffc020b16e:	73e50513          	addi	a0,a0,1854 # ffffffffc020f8a8 <sfs_node_fileops+0xb8>
ffffffffc020b172:	b2cf50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020b176 <sfs_sync_super>:
ffffffffc020b176:	1101                	addi	sp,sp,-32
ffffffffc020b178:	ec06                	sd	ra,24(sp)
ffffffffc020b17a:	e822                	sd	s0,16(sp)
ffffffffc020b17c:	e426                	sd	s1,8(sp)
ffffffffc020b17e:	842a                	mv	s0,a0
ffffffffc020b180:	11a000ef          	jal	ra,ffffffffc020b29a <lock_sfs_io>
ffffffffc020b184:	6428                	ld	a0,72(s0)
ffffffffc020b186:	6605                	lui	a2,0x1
ffffffffc020b188:	4581                	li	a1,0
ffffffffc020b18a:	65c000ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc020b18e:	6428                	ld	a0,72(s0)
ffffffffc020b190:	85a2                	mv	a1,s0
ffffffffc020b192:	02c00613          	li	a2,44
ffffffffc020b196:	6a2000ef          	jal	ra,ffffffffc020b838 <memcpy>
ffffffffc020b19a:	642c                	ld	a1,72(s0)
ffffffffc020b19c:	4701                	li	a4,0
ffffffffc020b19e:	4685                	li	a3,1
ffffffffc020b1a0:	4601                	li	a2,0
ffffffffc020b1a2:	8522                	mv	a0,s0
ffffffffc020b1a4:	da7ff0ef          	jal	ra,ffffffffc020af4a <sfs_rwblock_nolock>
ffffffffc020b1a8:	84aa                	mv	s1,a0
ffffffffc020b1aa:	8522                	mv	a0,s0
ffffffffc020b1ac:	0fe000ef          	jal	ra,ffffffffc020b2aa <unlock_sfs_io>
ffffffffc020b1b0:	60e2                	ld	ra,24(sp)
ffffffffc020b1b2:	6442                	ld	s0,16(sp)
ffffffffc020b1b4:	8526                	mv	a0,s1
ffffffffc020b1b6:	64a2                	ld	s1,8(sp)
ffffffffc020b1b8:	6105                	addi	sp,sp,32
ffffffffc020b1ba:	8082                	ret

ffffffffc020b1bc <sfs_sync_freemap>:
ffffffffc020b1bc:	7139                	addi	sp,sp,-64
ffffffffc020b1be:	ec4e                	sd	s3,24(sp)
ffffffffc020b1c0:	e852                	sd	s4,16(sp)
ffffffffc020b1c2:	00456983          	lwu	s3,4(a0)
ffffffffc020b1c6:	8a2a                	mv	s4,a0
ffffffffc020b1c8:	7d08                	ld	a0,56(a0)
ffffffffc020b1ca:	67a1                	lui	a5,0x8
ffffffffc020b1cc:	17fd                	addi	a5,a5,-1
ffffffffc020b1ce:	4581                	li	a1,0
ffffffffc020b1d0:	f822                	sd	s0,48(sp)
ffffffffc020b1d2:	fc06                	sd	ra,56(sp)
ffffffffc020b1d4:	f426                	sd	s1,40(sp)
ffffffffc020b1d6:	f04a                	sd	s2,32(sp)
ffffffffc020b1d8:	e456                	sd	s5,8(sp)
ffffffffc020b1da:	99be                	add	s3,s3,a5
ffffffffc020b1dc:	a20fe0ef          	jal	ra,ffffffffc02093fc <bitmap_getdata>
ffffffffc020b1e0:	00f9d993          	srli	s3,s3,0xf
ffffffffc020b1e4:	842a                	mv	s0,a0
ffffffffc020b1e6:	8552                	mv	a0,s4
ffffffffc020b1e8:	0b2000ef          	jal	ra,ffffffffc020b29a <lock_sfs_io>
ffffffffc020b1ec:	04098163          	beqz	s3,ffffffffc020b22e <sfs_sync_freemap+0x72>
ffffffffc020b1f0:	09b2                	slli	s3,s3,0xc
ffffffffc020b1f2:	99a2                	add	s3,s3,s0
ffffffffc020b1f4:	4909                	li	s2,2
ffffffffc020b1f6:	6a85                	lui	s5,0x1
ffffffffc020b1f8:	a021                	j	ffffffffc020b200 <sfs_sync_freemap+0x44>
ffffffffc020b1fa:	2905                	addiw	s2,s2,1
ffffffffc020b1fc:	02898963          	beq	s3,s0,ffffffffc020b22e <sfs_sync_freemap+0x72>
ffffffffc020b200:	85a2                	mv	a1,s0
ffffffffc020b202:	864a                	mv	a2,s2
ffffffffc020b204:	4705                	li	a4,1
ffffffffc020b206:	4685                	li	a3,1
ffffffffc020b208:	8552                	mv	a0,s4
ffffffffc020b20a:	d41ff0ef          	jal	ra,ffffffffc020af4a <sfs_rwblock_nolock>
ffffffffc020b20e:	84aa                	mv	s1,a0
ffffffffc020b210:	9456                	add	s0,s0,s5
ffffffffc020b212:	d565                	beqz	a0,ffffffffc020b1fa <sfs_sync_freemap+0x3e>
ffffffffc020b214:	8552                	mv	a0,s4
ffffffffc020b216:	094000ef          	jal	ra,ffffffffc020b2aa <unlock_sfs_io>
ffffffffc020b21a:	70e2                	ld	ra,56(sp)
ffffffffc020b21c:	7442                	ld	s0,48(sp)
ffffffffc020b21e:	7902                	ld	s2,32(sp)
ffffffffc020b220:	69e2                	ld	s3,24(sp)
ffffffffc020b222:	6a42                	ld	s4,16(sp)
ffffffffc020b224:	6aa2                	ld	s5,8(sp)
ffffffffc020b226:	8526                	mv	a0,s1
ffffffffc020b228:	74a2                	ld	s1,40(sp)
ffffffffc020b22a:	6121                	addi	sp,sp,64
ffffffffc020b22c:	8082                	ret
ffffffffc020b22e:	4481                	li	s1,0
ffffffffc020b230:	b7d5                	j	ffffffffc020b214 <sfs_sync_freemap+0x58>

ffffffffc020b232 <sfs_clear_block>:
ffffffffc020b232:	7179                	addi	sp,sp,-48
ffffffffc020b234:	f022                	sd	s0,32(sp)
ffffffffc020b236:	e84a                	sd	s2,16(sp)
ffffffffc020b238:	e44e                	sd	s3,8(sp)
ffffffffc020b23a:	f406                	sd	ra,40(sp)
ffffffffc020b23c:	89b2                	mv	s3,a2
ffffffffc020b23e:	ec26                	sd	s1,24(sp)
ffffffffc020b240:	892a                	mv	s2,a0
ffffffffc020b242:	842e                	mv	s0,a1
ffffffffc020b244:	056000ef          	jal	ra,ffffffffc020b29a <lock_sfs_io>
ffffffffc020b248:	04893503          	ld	a0,72(s2)
ffffffffc020b24c:	6605                	lui	a2,0x1
ffffffffc020b24e:	4581                	li	a1,0
ffffffffc020b250:	596000ef          	jal	ra,ffffffffc020b7e6 <memset>
ffffffffc020b254:	02098d63          	beqz	s3,ffffffffc020b28e <sfs_clear_block+0x5c>
ffffffffc020b258:	013409bb          	addw	s3,s0,s3
ffffffffc020b25c:	a019                	j	ffffffffc020b262 <sfs_clear_block+0x30>
ffffffffc020b25e:	02898863          	beq	s3,s0,ffffffffc020b28e <sfs_clear_block+0x5c>
ffffffffc020b262:	04893583          	ld	a1,72(s2)
ffffffffc020b266:	8622                	mv	a2,s0
ffffffffc020b268:	4705                	li	a4,1
ffffffffc020b26a:	4685                	li	a3,1
ffffffffc020b26c:	854a                	mv	a0,s2
ffffffffc020b26e:	cddff0ef          	jal	ra,ffffffffc020af4a <sfs_rwblock_nolock>
ffffffffc020b272:	84aa                	mv	s1,a0
ffffffffc020b274:	2405                	addiw	s0,s0,1
ffffffffc020b276:	d565                	beqz	a0,ffffffffc020b25e <sfs_clear_block+0x2c>
ffffffffc020b278:	854a                	mv	a0,s2
ffffffffc020b27a:	030000ef          	jal	ra,ffffffffc020b2aa <unlock_sfs_io>
ffffffffc020b27e:	70a2                	ld	ra,40(sp)
ffffffffc020b280:	7402                	ld	s0,32(sp)
ffffffffc020b282:	6942                	ld	s2,16(sp)
ffffffffc020b284:	69a2                	ld	s3,8(sp)
ffffffffc020b286:	8526                	mv	a0,s1
ffffffffc020b288:	64e2                	ld	s1,24(sp)
ffffffffc020b28a:	6145                	addi	sp,sp,48
ffffffffc020b28c:	8082                	ret
ffffffffc020b28e:	4481                	li	s1,0
ffffffffc020b290:	b7e5                	j	ffffffffc020b278 <sfs_clear_block+0x46>

ffffffffc020b292 <lock_sfs_fs>:
ffffffffc020b292:	05050513          	addi	a0,a0,80
ffffffffc020b296:	d20f906f          	j	ffffffffc02047b6 <down>

ffffffffc020b29a <lock_sfs_io>:
ffffffffc020b29a:	06850513          	addi	a0,a0,104
ffffffffc020b29e:	d18f906f          	j	ffffffffc02047b6 <down>

ffffffffc020b2a2 <unlock_sfs_fs>:
ffffffffc020b2a2:	05050513          	addi	a0,a0,80
ffffffffc020b2a6:	d0cf906f          	j	ffffffffc02047b2 <up>

ffffffffc020b2aa <unlock_sfs_io>:
ffffffffc020b2aa:	06850513          	addi	a0,a0,104
ffffffffc020b2ae:	d04f906f          	j	ffffffffc02047b2 <up>

ffffffffc020b2b2 <hash32>:
ffffffffc020b2b2:	9e3707b7          	lui	a5,0x9e370
ffffffffc020b2b6:	2785                	addiw	a5,a5,1
ffffffffc020b2b8:	02a7853b          	mulw	a0,a5,a0
ffffffffc020b2bc:	02000793          	li	a5,32
ffffffffc020b2c0:	9f8d                	subw	a5,a5,a1
ffffffffc020b2c2:	00f5553b          	srlw	a0,a0,a5
ffffffffc020b2c6:	8082                	ret

ffffffffc020b2c8 <printnum>:
ffffffffc020b2c8:	02071893          	slli	a7,a4,0x20
ffffffffc020b2cc:	7139                	addi	sp,sp,-64
ffffffffc020b2ce:	0208d893          	srli	a7,a7,0x20
ffffffffc020b2d2:	e456                	sd	s5,8(sp)
ffffffffc020b2d4:	0316fab3          	remu	s5,a3,a7
ffffffffc020b2d8:	f822                	sd	s0,48(sp)
ffffffffc020b2da:	f426                	sd	s1,40(sp)
ffffffffc020b2dc:	f04a                	sd	s2,32(sp)
ffffffffc020b2de:	ec4e                	sd	s3,24(sp)
ffffffffc020b2e0:	fc06                	sd	ra,56(sp)
ffffffffc020b2e2:	e852                	sd	s4,16(sp)
ffffffffc020b2e4:	84aa                	mv	s1,a0
ffffffffc020b2e6:	89ae                	mv	s3,a1
ffffffffc020b2e8:	8932                	mv	s2,a2
ffffffffc020b2ea:	fff7841b          	addiw	s0,a5,-1
ffffffffc020b2ee:	2a81                	sext.w	s5,s5
ffffffffc020b2f0:	0516f163          	bgeu	a3,a7,ffffffffc020b332 <printnum+0x6a>
ffffffffc020b2f4:	8a42                	mv	s4,a6
ffffffffc020b2f6:	00805863          	blez	s0,ffffffffc020b306 <printnum+0x3e>
ffffffffc020b2fa:	347d                	addiw	s0,s0,-1
ffffffffc020b2fc:	864e                	mv	a2,s3
ffffffffc020b2fe:	85ca                	mv	a1,s2
ffffffffc020b300:	8552                	mv	a0,s4
ffffffffc020b302:	9482                	jalr	s1
ffffffffc020b304:	f87d                	bnez	s0,ffffffffc020b2fa <printnum+0x32>
ffffffffc020b306:	1a82                	slli	s5,s5,0x20
ffffffffc020b308:	00004797          	auipc	a5,0x4
ffffffffc020b30c:	60078793          	addi	a5,a5,1536 # ffffffffc020f908 <sfs_node_fileops+0x118>
ffffffffc020b310:	020ada93          	srli	s5,s5,0x20
ffffffffc020b314:	9abe                	add	s5,s5,a5
ffffffffc020b316:	7442                	ld	s0,48(sp)
ffffffffc020b318:	000ac503          	lbu	a0,0(s5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc020b31c:	70e2                	ld	ra,56(sp)
ffffffffc020b31e:	6a42                	ld	s4,16(sp)
ffffffffc020b320:	6aa2                	ld	s5,8(sp)
ffffffffc020b322:	864e                	mv	a2,s3
ffffffffc020b324:	85ca                	mv	a1,s2
ffffffffc020b326:	69e2                	ld	s3,24(sp)
ffffffffc020b328:	7902                	ld	s2,32(sp)
ffffffffc020b32a:	87a6                	mv	a5,s1
ffffffffc020b32c:	74a2                	ld	s1,40(sp)
ffffffffc020b32e:	6121                	addi	sp,sp,64
ffffffffc020b330:	8782                	jr	a5
ffffffffc020b332:	0316d6b3          	divu	a3,a3,a7
ffffffffc020b336:	87a2                	mv	a5,s0
ffffffffc020b338:	f91ff0ef          	jal	ra,ffffffffc020b2c8 <printnum>
ffffffffc020b33c:	b7e9                	j	ffffffffc020b306 <printnum+0x3e>

ffffffffc020b33e <sprintputch>:
ffffffffc020b33e:	499c                	lw	a5,16(a1)
ffffffffc020b340:	6198                	ld	a4,0(a1)
ffffffffc020b342:	6594                	ld	a3,8(a1)
ffffffffc020b344:	2785                	addiw	a5,a5,1
ffffffffc020b346:	c99c                	sw	a5,16(a1)
ffffffffc020b348:	00d77763          	bgeu	a4,a3,ffffffffc020b356 <sprintputch+0x18>
ffffffffc020b34c:	00170793          	addi	a5,a4,1
ffffffffc020b350:	e19c                	sd	a5,0(a1)
ffffffffc020b352:	00a70023          	sb	a0,0(a4)
ffffffffc020b356:	8082                	ret

ffffffffc020b358 <vprintfmt>:
ffffffffc020b358:	7119                	addi	sp,sp,-128
ffffffffc020b35a:	f4a6                	sd	s1,104(sp)
ffffffffc020b35c:	f0ca                	sd	s2,96(sp)
ffffffffc020b35e:	ecce                	sd	s3,88(sp)
ffffffffc020b360:	e8d2                	sd	s4,80(sp)
ffffffffc020b362:	e4d6                	sd	s5,72(sp)
ffffffffc020b364:	e0da                	sd	s6,64(sp)
ffffffffc020b366:	fc5e                	sd	s7,56(sp)
ffffffffc020b368:	ec6e                	sd	s11,24(sp)
ffffffffc020b36a:	fc86                	sd	ra,120(sp)
ffffffffc020b36c:	f8a2                	sd	s0,112(sp)
ffffffffc020b36e:	f862                	sd	s8,48(sp)
ffffffffc020b370:	f466                	sd	s9,40(sp)
ffffffffc020b372:	f06a                	sd	s10,32(sp)
ffffffffc020b374:	89aa                	mv	s3,a0
ffffffffc020b376:	892e                	mv	s2,a1
ffffffffc020b378:	84b2                	mv	s1,a2
ffffffffc020b37a:	8db6                	mv	s11,a3
ffffffffc020b37c:	8aba                	mv	s5,a4
ffffffffc020b37e:	02500a13          	li	s4,37
ffffffffc020b382:	5bfd                	li	s7,-1
ffffffffc020b384:	00004b17          	auipc	s6,0x4
ffffffffc020b388:	5b0b0b13          	addi	s6,s6,1456 # ffffffffc020f934 <sfs_node_fileops+0x144>
ffffffffc020b38c:	000dc503          	lbu	a0,0(s11) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc020b390:	001d8413          	addi	s0,s11,1
ffffffffc020b394:	01450b63          	beq	a0,s4,ffffffffc020b3aa <vprintfmt+0x52>
ffffffffc020b398:	c129                	beqz	a0,ffffffffc020b3da <vprintfmt+0x82>
ffffffffc020b39a:	864a                	mv	a2,s2
ffffffffc020b39c:	85a6                	mv	a1,s1
ffffffffc020b39e:	0405                	addi	s0,s0,1
ffffffffc020b3a0:	9982                	jalr	s3
ffffffffc020b3a2:	fff44503          	lbu	a0,-1(s0)
ffffffffc020b3a6:	ff4519e3          	bne	a0,s4,ffffffffc020b398 <vprintfmt+0x40>
ffffffffc020b3aa:	00044583          	lbu	a1,0(s0)
ffffffffc020b3ae:	02000813          	li	a6,32
ffffffffc020b3b2:	4d01                	li	s10,0
ffffffffc020b3b4:	4301                	li	t1,0
ffffffffc020b3b6:	5cfd                	li	s9,-1
ffffffffc020b3b8:	5c7d                	li	s8,-1
ffffffffc020b3ba:	05500513          	li	a0,85
ffffffffc020b3be:	48a5                	li	a7,9
ffffffffc020b3c0:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b3c4:	0ff67613          	zext.b	a2,a2
ffffffffc020b3c8:	00140d93          	addi	s11,s0,1
ffffffffc020b3cc:	04c56263          	bltu	a0,a2,ffffffffc020b410 <vprintfmt+0xb8>
ffffffffc020b3d0:	060a                	slli	a2,a2,0x2
ffffffffc020b3d2:	965a                	add	a2,a2,s6
ffffffffc020b3d4:	4214                	lw	a3,0(a2)
ffffffffc020b3d6:	96da                	add	a3,a3,s6
ffffffffc020b3d8:	8682                	jr	a3
ffffffffc020b3da:	70e6                	ld	ra,120(sp)
ffffffffc020b3dc:	7446                	ld	s0,112(sp)
ffffffffc020b3de:	74a6                	ld	s1,104(sp)
ffffffffc020b3e0:	7906                	ld	s2,96(sp)
ffffffffc020b3e2:	69e6                	ld	s3,88(sp)
ffffffffc020b3e4:	6a46                	ld	s4,80(sp)
ffffffffc020b3e6:	6aa6                	ld	s5,72(sp)
ffffffffc020b3e8:	6b06                	ld	s6,64(sp)
ffffffffc020b3ea:	7be2                	ld	s7,56(sp)
ffffffffc020b3ec:	7c42                	ld	s8,48(sp)
ffffffffc020b3ee:	7ca2                	ld	s9,40(sp)
ffffffffc020b3f0:	7d02                	ld	s10,32(sp)
ffffffffc020b3f2:	6de2                	ld	s11,24(sp)
ffffffffc020b3f4:	6109                	addi	sp,sp,128
ffffffffc020b3f6:	8082                	ret
ffffffffc020b3f8:	882e                	mv	a6,a1
ffffffffc020b3fa:	00144583          	lbu	a1,1(s0)
ffffffffc020b3fe:	846e                	mv	s0,s11
ffffffffc020b400:	00140d93          	addi	s11,s0,1
ffffffffc020b404:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b408:	0ff67613          	zext.b	a2,a2
ffffffffc020b40c:	fcc572e3          	bgeu	a0,a2,ffffffffc020b3d0 <vprintfmt+0x78>
ffffffffc020b410:	864a                	mv	a2,s2
ffffffffc020b412:	85a6                	mv	a1,s1
ffffffffc020b414:	02500513          	li	a0,37
ffffffffc020b418:	9982                	jalr	s3
ffffffffc020b41a:	fff44783          	lbu	a5,-1(s0)
ffffffffc020b41e:	8da2                	mv	s11,s0
ffffffffc020b420:	f74786e3          	beq	a5,s4,ffffffffc020b38c <vprintfmt+0x34>
ffffffffc020b424:	ffedc783          	lbu	a5,-2(s11)
ffffffffc020b428:	1dfd                	addi	s11,s11,-1
ffffffffc020b42a:	ff479de3          	bne	a5,s4,ffffffffc020b424 <vprintfmt+0xcc>
ffffffffc020b42e:	bfb9                	j	ffffffffc020b38c <vprintfmt+0x34>
ffffffffc020b430:	fd058c9b          	addiw	s9,a1,-48
ffffffffc020b434:	00144583          	lbu	a1,1(s0)
ffffffffc020b438:	846e                	mv	s0,s11
ffffffffc020b43a:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b43e:	0005861b          	sext.w	a2,a1
ffffffffc020b442:	02d8e463          	bltu	a7,a3,ffffffffc020b46a <vprintfmt+0x112>
ffffffffc020b446:	00144583          	lbu	a1,1(s0)
ffffffffc020b44a:	002c969b          	slliw	a3,s9,0x2
ffffffffc020b44e:	0196873b          	addw	a4,a3,s9
ffffffffc020b452:	0017171b          	slliw	a4,a4,0x1
ffffffffc020b456:	9f31                	addw	a4,a4,a2
ffffffffc020b458:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b45c:	0405                	addi	s0,s0,1
ffffffffc020b45e:	fd070c9b          	addiw	s9,a4,-48
ffffffffc020b462:	0005861b          	sext.w	a2,a1
ffffffffc020b466:	fed8f0e3          	bgeu	a7,a3,ffffffffc020b446 <vprintfmt+0xee>
ffffffffc020b46a:	f40c5be3          	bgez	s8,ffffffffc020b3c0 <vprintfmt+0x68>
ffffffffc020b46e:	8c66                	mv	s8,s9
ffffffffc020b470:	5cfd                	li	s9,-1
ffffffffc020b472:	b7b9                	j	ffffffffc020b3c0 <vprintfmt+0x68>
ffffffffc020b474:	fffc4693          	not	a3,s8
ffffffffc020b478:	96fd                	srai	a3,a3,0x3f
ffffffffc020b47a:	00dc77b3          	and	a5,s8,a3
ffffffffc020b47e:	00144583          	lbu	a1,1(s0)
ffffffffc020b482:	00078c1b          	sext.w	s8,a5
ffffffffc020b486:	846e                	mv	s0,s11
ffffffffc020b488:	bf25                	j	ffffffffc020b3c0 <vprintfmt+0x68>
ffffffffc020b48a:	000aac83          	lw	s9,0(s5)
ffffffffc020b48e:	00144583          	lbu	a1,1(s0)
ffffffffc020b492:	0aa1                	addi	s5,s5,8
ffffffffc020b494:	846e                	mv	s0,s11
ffffffffc020b496:	bfd1                	j	ffffffffc020b46a <vprintfmt+0x112>
ffffffffc020b498:	4705                	li	a4,1
ffffffffc020b49a:	008a8613          	addi	a2,s5,8
ffffffffc020b49e:	00674463          	blt	a4,t1,ffffffffc020b4a6 <vprintfmt+0x14e>
ffffffffc020b4a2:	1c030c63          	beqz	t1,ffffffffc020b67a <vprintfmt+0x322>
ffffffffc020b4a6:	000ab683          	ld	a3,0(s5)
ffffffffc020b4aa:	4741                	li	a4,16
ffffffffc020b4ac:	8ab2                	mv	s5,a2
ffffffffc020b4ae:	2801                	sext.w	a6,a6
ffffffffc020b4b0:	87e2                	mv	a5,s8
ffffffffc020b4b2:	8626                	mv	a2,s1
ffffffffc020b4b4:	85ca                	mv	a1,s2
ffffffffc020b4b6:	854e                	mv	a0,s3
ffffffffc020b4b8:	e11ff0ef          	jal	ra,ffffffffc020b2c8 <printnum>
ffffffffc020b4bc:	bdc1                	j	ffffffffc020b38c <vprintfmt+0x34>
ffffffffc020b4be:	000aa503          	lw	a0,0(s5)
ffffffffc020b4c2:	864a                	mv	a2,s2
ffffffffc020b4c4:	85a6                	mv	a1,s1
ffffffffc020b4c6:	0aa1                	addi	s5,s5,8
ffffffffc020b4c8:	9982                	jalr	s3
ffffffffc020b4ca:	b5c9                	j	ffffffffc020b38c <vprintfmt+0x34>
ffffffffc020b4cc:	4705                	li	a4,1
ffffffffc020b4ce:	008a8613          	addi	a2,s5,8
ffffffffc020b4d2:	00674463          	blt	a4,t1,ffffffffc020b4da <vprintfmt+0x182>
ffffffffc020b4d6:	18030d63          	beqz	t1,ffffffffc020b670 <vprintfmt+0x318>
ffffffffc020b4da:	000ab683          	ld	a3,0(s5)
ffffffffc020b4de:	4729                	li	a4,10
ffffffffc020b4e0:	8ab2                	mv	s5,a2
ffffffffc020b4e2:	b7f1                	j	ffffffffc020b4ae <vprintfmt+0x156>
ffffffffc020b4e4:	00144583          	lbu	a1,1(s0)
ffffffffc020b4e8:	4d05                	li	s10,1
ffffffffc020b4ea:	846e                	mv	s0,s11
ffffffffc020b4ec:	bdd1                	j	ffffffffc020b3c0 <vprintfmt+0x68>
ffffffffc020b4ee:	864a                	mv	a2,s2
ffffffffc020b4f0:	85a6                	mv	a1,s1
ffffffffc020b4f2:	02500513          	li	a0,37
ffffffffc020b4f6:	9982                	jalr	s3
ffffffffc020b4f8:	bd51                	j	ffffffffc020b38c <vprintfmt+0x34>
ffffffffc020b4fa:	00144583          	lbu	a1,1(s0)
ffffffffc020b4fe:	2305                	addiw	t1,t1,1
ffffffffc020b500:	846e                	mv	s0,s11
ffffffffc020b502:	bd7d                	j	ffffffffc020b3c0 <vprintfmt+0x68>
ffffffffc020b504:	4705                	li	a4,1
ffffffffc020b506:	008a8613          	addi	a2,s5,8
ffffffffc020b50a:	00674463          	blt	a4,t1,ffffffffc020b512 <vprintfmt+0x1ba>
ffffffffc020b50e:	14030c63          	beqz	t1,ffffffffc020b666 <vprintfmt+0x30e>
ffffffffc020b512:	000ab683          	ld	a3,0(s5)
ffffffffc020b516:	4721                	li	a4,8
ffffffffc020b518:	8ab2                	mv	s5,a2
ffffffffc020b51a:	bf51                	j	ffffffffc020b4ae <vprintfmt+0x156>
ffffffffc020b51c:	03000513          	li	a0,48
ffffffffc020b520:	864a                	mv	a2,s2
ffffffffc020b522:	85a6                	mv	a1,s1
ffffffffc020b524:	e042                	sd	a6,0(sp)
ffffffffc020b526:	9982                	jalr	s3
ffffffffc020b528:	864a                	mv	a2,s2
ffffffffc020b52a:	85a6                	mv	a1,s1
ffffffffc020b52c:	07800513          	li	a0,120
ffffffffc020b530:	9982                	jalr	s3
ffffffffc020b532:	0aa1                	addi	s5,s5,8
ffffffffc020b534:	6802                	ld	a6,0(sp)
ffffffffc020b536:	4741                	li	a4,16
ffffffffc020b538:	ff8ab683          	ld	a3,-8(s5)
ffffffffc020b53c:	bf8d                	j	ffffffffc020b4ae <vprintfmt+0x156>
ffffffffc020b53e:	000ab403          	ld	s0,0(s5)
ffffffffc020b542:	008a8793          	addi	a5,s5,8
ffffffffc020b546:	e03e                	sd	a5,0(sp)
ffffffffc020b548:	14040c63          	beqz	s0,ffffffffc020b6a0 <vprintfmt+0x348>
ffffffffc020b54c:	11805063          	blez	s8,ffffffffc020b64c <vprintfmt+0x2f4>
ffffffffc020b550:	02d00693          	li	a3,45
ffffffffc020b554:	0cd81963          	bne	a6,a3,ffffffffc020b626 <vprintfmt+0x2ce>
ffffffffc020b558:	00044683          	lbu	a3,0(s0)
ffffffffc020b55c:	0006851b          	sext.w	a0,a3
ffffffffc020b560:	ce8d                	beqz	a3,ffffffffc020b59a <vprintfmt+0x242>
ffffffffc020b562:	00140a93          	addi	s5,s0,1
ffffffffc020b566:	05e00413          	li	s0,94
ffffffffc020b56a:	000cc563          	bltz	s9,ffffffffc020b574 <vprintfmt+0x21c>
ffffffffc020b56e:	3cfd                	addiw	s9,s9,-1
ffffffffc020b570:	037c8363          	beq	s9,s7,ffffffffc020b596 <vprintfmt+0x23e>
ffffffffc020b574:	864a                	mv	a2,s2
ffffffffc020b576:	85a6                	mv	a1,s1
ffffffffc020b578:	100d0663          	beqz	s10,ffffffffc020b684 <vprintfmt+0x32c>
ffffffffc020b57c:	3681                	addiw	a3,a3,-32
ffffffffc020b57e:	10d47363          	bgeu	s0,a3,ffffffffc020b684 <vprintfmt+0x32c>
ffffffffc020b582:	03f00513          	li	a0,63
ffffffffc020b586:	9982                	jalr	s3
ffffffffc020b588:	000ac683          	lbu	a3,0(s5)
ffffffffc020b58c:	3c7d                	addiw	s8,s8,-1
ffffffffc020b58e:	0a85                	addi	s5,s5,1
ffffffffc020b590:	0006851b          	sext.w	a0,a3
ffffffffc020b594:	faf9                	bnez	a3,ffffffffc020b56a <vprintfmt+0x212>
ffffffffc020b596:	01805a63          	blez	s8,ffffffffc020b5aa <vprintfmt+0x252>
ffffffffc020b59a:	3c7d                	addiw	s8,s8,-1
ffffffffc020b59c:	864a                	mv	a2,s2
ffffffffc020b59e:	85a6                	mv	a1,s1
ffffffffc020b5a0:	02000513          	li	a0,32
ffffffffc020b5a4:	9982                	jalr	s3
ffffffffc020b5a6:	fe0c1ae3          	bnez	s8,ffffffffc020b59a <vprintfmt+0x242>
ffffffffc020b5aa:	6a82                	ld	s5,0(sp)
ffffffffc020b5ac:	b3c5                	j	ffffffffc020b38c <vprintfmt+0x34>
ffffffffc020b5ae:	4705                	li	a4,1
ffffffffc020b5b0:	008a8d13          	addi	s10,s5,8
ffffffffc020b5b4:	00674463          	blt	a4,t1,ffffffffc020b5bc <vprintfmt+0x264>
ffffffffc020b5b8:	0a030463          	beqz	t1,ffffffffc020b660 <vprintfmt+0x308>
ffffffffc020b5bc:	000ab403          	ld	s0,0(s5)
ffffffffc020b5c0:	0c044463          	bltz	s0,ffffffffc020b688 <vprintfmt+0x330>
ffffffffc020b5c4:	86a2                	mv	a3,s0
ffffffffc020b5c6:	8aea                	mv	s5,s10
ffffffffc020b5c8:	4729                	li	a4,10
ffffffffc020b5ca:	b5d5                	j	ffffffffc020b4ae <vprintfmt+0x156>
ffffffffc020b5cc:	000aa783          	lw	a5,0(s5)
ffffffffc020b5d0:	46e1                	li	a3,24
ffffffffc020b5d2:	0aa1                	addi	s5,s5,8
ffffffffc020b5d4:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020b5d8:	8fb9                	xor	a5,a5,a4
ffffffffc020b5da:	40e7873b          	subw	a4,a5,a4
ffffffffc020b5de:	02e6c663          	blt	a3,a4,ffffffffc020b60a <vprintfmt+0x2b2>
ffffffffc020b5e2:	00371793          	slli	a5,a4,0x3
ffffffffc020b5e6:	00004697          	auipc	a3,0x4
ffffffffc020b5ea:	68268693          	addi	a3,a3,1666 # ffffffffc020fc68 <error_string>
ffffffffc020b5ee:	97b6                	add	a5,a5,a3
ffffffffc020b5f0:	639c                	ld	a5,0(a5)
ffffffffc020b5f2:	cf81                	beqz	a5,ffffffffc020b60a <vprintfmt+0x2b2>
ffffffffc020b5f4:	873e                	mv	a4,a5
ffffffffc020b5f6:	00000697          	auipc	a3,0x0
ffffffffc020b5fa:	28268693          	addi	a3,a3,642 # ffffffffc020b878 <etext+0x28>
ffffffffc020b5fe:	8626                	mv	a2,s1
ffffffffc020b600:	85ca                	mv	a1,s2
ffffffffc020b602:	854e                	mv	a0,s3
ffffffffc020b604:	0d4000ef          	jal	ra,ffffffffc020b6d8 <printfmt>
ffffffffc020b608:	b351                	j	ffffffffc020b38c <vprintfmt+0x34>
ffffffffc020b60a:	00004697          	auipc	a3,0x4
ffffffffc020b60e:	31e68693          	addi	a3,a3,798 # ffffffffc020f928 <sfs_node_fileops+0x138>
ffffffffc020b612:	8626                	mv	a2,s1
ffffffffc020b614:	85ca                	mv	a1,s2
ffffffffc020b616:	854e                	mv	a0,s3
ffffffffc020b618:	0c0000ef          	jal	ra,ffffffffc020b6d8 <printfmt>
ffffffffc020b61c:	bb85                	j	ffffffffc020b38c <vprintfmt+0x34>
ffffffffc020b61e:	00004417          	auipc	s0,0x4
ffffffffc020b622:	30240413          	addi	s0,s0,770 # ffffffffc020f920 <sfs_node_fileops+0x130>
ffffffffc020b626:	85e6                	mv	a1,s9
ffffffffc020b628:	8522                	mv	a0,s0
ffffffffc020b62a:	e442                	sd	a6,8(sp)
ffffffffc020b62c:	132000ef          	jal	ra,ffffffffc020b75e <strnlen>
ffffffffc020b630:	40ac0c3b          	subw	s8,s8,a0
ffffffffc020b634:	01805c63          	blez	s8,ffffffffc020b64c <vprintfmt+0x2f4>
ffffffffc020b638:	6822                	ld	a6,8(sp)
ffffffffc020b63a:	00080a9b          	sext.w	s5,a6
ffffffffc020b63e:	3c7d                	addiw	s8,s8,-1
ffffffffc020b640:	864a                	mv	a2,s2
ffffffffc020b642:	85a6                	mv	a1,s1
ffffffffc020b644:	8556                	mv	a0,s5
ffffffffc020b646:	9982                	jalr	s3
ffffffffc020b648:	fe0c1be3          	bnez	s8,ffffffffc020b63e <vprintfmt+0x2e6>
ffffffffc020b64c:	00044683          	lbu	a3,0(s0)
ffffffffc020b650:	00140a93          	addi	s5,s0,1
ffffffffc020b654:	0006851b          	sext.w	a0,a3
ffffffffc020b658:	daa9                	beqz	a3,ffffffffc020b5aa <vprintfmt+0x252>
ffffffffc020b65a:	05e00413          	li	s0,94
ffffffffc020b65e:	b731                	j	ffffffffc020b56a <vprintfmt+0x212>
ffffffffc020b660:	000aa403          	lw	s0,0(s5)
ffffffffc020b664:	bfb1                	j	ffffffffc020b5c0 <vprintfmt+0x268>
ffffffffc020b666:	000ae683          	lwu	a3,0(s5)
ffffffffc020b66a:	4721                	li	a4,8
ffffffffc020b66c:	8ab2                	mv	s5,a2
ffffffffc020b66e:	b581                	j	ffffffffc020b4ae <vprintfmt+0x156>
ffffffffc020b670:	000ae683          	lwu	a3,0(s5)
ffffffffc020b674:	4729                	li	a4,10
ffffffffc020b676:	8ab2                	mv	s5,a2
ffffffffc020b678:	bd1d                	j	ffffffffc020b4ae <vprintfmt+0x156>
ffffffffc020b67a:	000ae683          	lwu	a3,0(s5)
ffffffffc020b67e:	4741                	li	a4,16
ffffffffc020b680:	8ab2                	mv	s5,a2
ffffffffc020b682:	b535                	j	ffffffffc020b4ae <vprintfmt+0x156>
ffffffffc020b684:	9982                	jalr	s3
ffffffffc020b686:	b709                	j	ffffffffc020b588 <vprintfmt+0x230>
ffffffffc020b688:	864a                	mv	a2,s2
ffffffffc020b68a:	85a6                	mv	a1,s1
ffffffffc020b68c:	02d00513          	li	a0,45
ffffffffc020b690:	e042                	sd	a6,0(sp)
ffffffffc020b692:	9982                	jalr	s3
ffffffffc020b694:	6802                	ld	a6,0(sp)
ffffffffc020b696:	8aea                	mv	s5,s10
ffffffffc020b698:	408006b3          	neg	a3,s0
ffffffffc020b69c:	4729                	li	a4,10
ffffffffc020b69e:	bd01                	j	ffffffffc020b4ae <vprintfmt+0x156>
ffffffffc020b6a0:	03805163          	blez	s8,ffffffffc020b6c2 <vprintfmt+0x36a>
ffffffffc020b6a4:	02d00693          	li	a3,45
ffffffffc020b6a8:	f6d81be3          	bne	a6,a3,ffffffffc020b61e <vprintfmt+0x2c6>
ffffffffc020b6ac:	00004417          	auipc	s0,0x4
ffffffffc020b6b0:	27440413          	addi	s0,s0,628 # ffffffffc020f920 <sfs_node_fileops+0x130>
ffffffffc020b6b4:	02800693          	li	a3,40
ffffffffc020b6b8:	02800513          	li	a0,40
ffffffffc020b6bc:	00140a93          	addi	s5,s0,1
ffffffffc020b6c0:	b55d                	j	ffffffffc020b566 <vprintfmt+0x20e>
ffffffffc020b6c2:	00004a97          	auipc	s5,0x4
ffffffffc020b6c6:	25fa8a93          	addi	s5,s5,607 # ffffffffc020f921 <sfs_node_fileops+0x131>
ffffffffc020b6ca:	02800513          	li	a0,40
ffffffffc020b6ce:	02800693          	li	a3,40
ffffffffc020b6d2:	05e00413          	li	s0,94
ffffffffc020b6d6:	bd51                	j	ffffffffc020b56a <vprintfmt+0x212>

ffffffffc020b6d8 <printfmt>:
ffffffffc020b6d8:	7139                	addi	sp,sp,-64
ffffffffc020b6da:	02010313          	addi	t1,sp,32
ffffffffc020b6de:	f03a                	sd	a4,32(sp)
ffffffffc020b6e0:	871a                	mv	a4,t1
ffffffffc020b6e2:	ec06                	sd	ra,24(sp)
ffffffffc020b6e4:	f43e                	sd	a5,40(sp)
ffffffffc020b6e6:	f842                	sd	a6,48(sp)
ffffffffc020b6e8:	fc46                	sd	a7,56(sp)
ffffffffc020b6ea:	e41a                	sd	t1,8(sp)
ffffffffc020b6ec:	c6dff0ef          	jal	ra,ffffffffc020b358 <vprintfmt>
ffffffffc020b6f0:	60e2                	ld	ra,24(sp)
ffffffffc020b6f2:	6121                	addi	sp,sp,64
ffffffffc020b6f4:	8082                	ret

ffffffffc020b6f6 <snprintf>:
ffffffffc020b6f6:	711d                	addi	sp,sp,-96
ffffffffc020b6f8:	15fd                	addi	a1,a1,-1
ffffffffc020b6fa:	03810313          	addi	t1,sp,56
ffffffffc020b6fe:	95aa                	add	a1,a1,a0
ffffffffc020b700:	f406                	sd	ra,40(sp)
ffffffffc020b702:	fc36                	sd	a3,56(sp)
ffffffffc020b704:	e0ba                	sd	a4,64(sp)
ffffffffc020b706:	e4be                	sd	a5,72(sp)
ffffffffc020b708:	e8c2                	sd	a6,80(sp)
ffffffffc020b70a:	ecc6                	sd	a7,88(sp)
ffffffffc020b70c:	e01a                	sd	t1,0(sp)
ffffffffc020b70e:	e42a                	sd	a0,8(sp)
ffffffffc020b710:	e82e                	sd	a1,16(sp)
ffffffffc020b712:	cc02                	sw	zero,24(sp)
ffffffffc020b714:	c515                	beqz	a0,ffffffffc020b740 <snprintf+0x4a>
ffffffffc020b716:	02a5e563          	bltu	a1,a0,ffffffffc020b740 <snprintf+0x4a>
ffffffffc020b71a:	75dd                	lui	a1,0xffff7
ffffffffc020b71c:	86b2                	mv	a3,a2
ffffffffc020b71e:	00000517          	auipc	a0,0x0
ffffffffc020b722:	c2050513          	addi	a0,a0,-992 # ffffffffc020b33e <sprintputch>
ffffffffc020b726:	871a                	mv	a4,t1
ffffffffc020b728:	0030                	addi	a2,sp,8
ffffffffc020b72a:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601b9>
ffffffffc020b72e:	c2bff0ef          	jal	ra,ffffffffc020b358 <vprintfmt>
ffffffffc020b732:	67a2                	ld	a5,8(sp)
ffffffffc020b734:	00078023          	sb	zero,0(a5)
ffffffffc020b738:	4562                	lw	a0,24(sp)
ffffffffc020b73a:	70a2                	ld	ra,40(sp)
ffffffffc020b73c:	6125                	addi	sp,sp,96
ffffffffc020b73e:	8082                	ret
ffffffffc020b740:	5575                	li	a0,-3
ffffffffc020b742:	bfe5                	j	ffffffffc020b73a <snprintf+0x44>

ffffffffc020b744 <strlen>:
ffffffffc020b744:	00054783          	lbu	a5,0(a0)
ffffffffc020b748:	872a                	mv	a4,a0
ffffffffc020b74a:	4501                	li	a0,0
ffffffffc020b74c:	cb81                	beqz	a5,ffffffffc020b75c <strlen+0x18>
ffffffffc020b74e:	0505                	addi	a0,a0,1
ffffffffc020b750:	00a707b3          	add	a5,a4,a0
ffffffffc020b754:	0007c783          	lbu	a5,0(a5)
ffffffffc020b758:	fbfd                	bnez	a5,ffffffffc020b74e <strlen+0xa>
ffffffffc020b75a:	8082                	ret
ffffffffc020b75c:	8082                	ret

ffffffffc020b75e <strnlen>:
ffffffffc020b75e:	4781                	li	a5,0
ffffffffc020b760:	e589                	bnez	a1,ffffffffc020b76a <strnlen+0xc>
ffffffffc020b762:	a811                	j	ffffffffc020b776 <strnlen+0x18>
ffffffffc020b764:	0785                	addi	a5,a5,1
ffffffffc020b766:	00f58863          	beq	a1,a5,ffffffffc020b776 <strnlen+0x18>
ffffffffc020b76a:	00f50733          	add	a4,a0,a5
ffffffffc020b76e:	00074703          	lbu	a4,0(a4)
ffffffffc020b772:	fb6d                	bnez	a4,ffffffffc020b764 <strnlen+0x6>
ffffffffc020b774:	85be                	mv	a1,a5
ffffffffc020b776:	852e                	mv	a0,a1
ffffffffc020b778:	8082                	ret

ffffffffc020b77a <strcpy>:
ffffffffc020b77a:	87aa                	mv	a5,a0
ffffffffc020b77c:	0005c703          	lbu	a4,0(a1)
ffffffffc020b780:	0785                	addi	a5,a5,1
ffffffffc020b782:	0585                	addi	a1,a1,1
ffffffffc020b784:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b788:	fb75                	bnez	a4,ffffffffc020b77c <strcpy+0x2>
ffffffffc020b78a:	8082                	ret

ffffffffc020b78c <strcmp>:
ffffffffc020b78c:	00054783          	lbu	a5,0(a0)
ffffffffc020b790:	0005c703          	lbu	a4,0(a1)
ffffffffc020b794:	cb89                	beqz	a5,ffffffffc020b7a6 <strcmp+0x1a>
ffffffffc020b796:	0505                	addi	a0,a0,1
ffffffffc020b798:	0585                	addi	a1,a1,1
ffffffffc020b79a:	fee789e3          	beq	a5,a4,ffffffffc020b78c <strcmp>
ffffffffc020b79e:	0007851b          	sext.w	a0,a5
ffffffffc020b7a2:	9d19                	subw	a0,a0,a4
ffffffffc020b7a4:	8082                	ret
ffffffffc020b7a6:	4501                	li	a0,0
ffffffffc020b7a8:	bfed                	j	ffffffffc020b7a2 <strcmp+0x16>

ffffffffc020b7aa <strncmp>:
ffffffffc020b7aa:	c20d                	beqz	a2,ffffffffc020b7cc <strncmp+0x22>
ffffffffc020b7ac:	962e                	add	a2,a2,a1
ffffffffc020b7ae:	a031                	j	ffffffffc020b7ba <strncmp+0x10>
ffffffffc020b7b0:	0505                	addi	a0,a0,1
ffffffffc020b7b2:	00e79a63          	bne	a5,a4,ffffffffc020b7c6 <strncmp+0x1c>
ffffffffc020b7b6:	00b60b63          	beq	a2,a1,ffffffffc020b7cc <strncmp+0x22>
ffffffffc020b7ba:	00054783          	lbu	a5,0(a0)
ffffffffc020b7be:	0585                	addi	a1,a1,1
ffffffffc020b7c0:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020b7c4:	f7f5                	bnez	a5,ffffffffc020b7b0 <strncmp+0x6>
ffffffffc020b7c6:	40e7853b          	subw	a0,a5,a4
ffffffffc020b7ca:	8082                	ret
ffffffffc020b7cc:	4501                	li	a0,0
ffffffffc020b7ce:	8082                	ret

ffffffffc020b7d0 <strchr>:
ffffffffc020b7d0:	00054783          	lbu	a5,0(a0)
ffffffffc020b7d4:	c799                	beqz	a5,ffffffffc020b7e2 <strchr+0x12>
ffffffffc020b7d6:	00f58763          	beq	a1,a5,ffffffffc020b7e4 <strchr+0x14>
ffffffffc020b7da:	00154783          	lbu	a5,1(a0)
ffffffffc020b7de:	0505                	addi	a0,a0,1
ffffffffc020b7e0:	fbfd                	bnez	a5,ffffffffc020b7d6 <strchr+0x6>
ffffffffc020b7e2:	4501                	li	a0,0
ffffffffc020b7e4:	8082                	ret

ffffffffc020b7e6 <memset>:
ffffffffc020b7e6:	ca01                	beqz	a2,ffffffffc020b7f6 <memset+0x10>
ffffffffc020b7e8:	962a                	add	a2,a2,a0
ffffffffc020b7ea:	87aa                	mv	a5,a0
ffffffffc020b7ec:	0785                	addi	a5,a5,1
ffffffffc020b7ee:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020b7f2:	fec79de3          	bne	a5,a2,ffffffffc020b7ec <memset+0x6>
ffffffffc020b7f6:	8082                	ret

ffffffffc020b7f8 <memmove>:
ffffffffc020b7f8:	02a5f263          	bgeu	a1,a0,ffffffffc020b81c <memmove+0x24>
ffffffffc020b7fc:	00c587b3          	add	a5,a1,a2
ffffffffc020b800:	00f57e63          	bgeu	a0,a5,ffffffffc020b81c <memmove+0x24>
ffffffffc020b804:	00c50733          	add	a4,a0,a2
ffffffffc020b808:	c615                	beqz	a2,ffffffffc020b834 <memmove+0x3c>
ffffffffc020b80a:	fff7c683          	lbu	a3,-1(a5)
ffffffffc020b80e:	17fd                	addi	a5,a5,-1
ffffffffc020b810:	177d                	addi	a4,a4,-1
ffffffffc020b812:	00d70023          	sb	a3,0(a4)
ffffffffc020b816:	fef59ae3          	bne	a1,a5,ffffffffc020b80a <memmove+0x12>
ffffffffc020b81a:	8082                	ret
ffffffffc020b81c:	00c586b3          	add	a3,a1,a2
ffffffffc020b820:	87aa                	mv	a5,a0
ffffffffc020b822:	ca11                	beqz	a2,ffffffffc020b836 <memmove+0x3e>
ffffffffc020b824:	0005c703          	lbu	a4,0(a1)
ffffffffc020b828:	0585                	addi	a1,a1,1
ffffffffc020b82a:	0785                	addi	a5,a5,1
ffffffffc020b82c:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b830:	fed59ae3          	bne	a1,a3,ffffffffc020b824 <memmove+0x2c>
ffffffffc020b834:	8082                	ret
ffffffffc020b836:	8082                	ret

ffffffffc020b838 <memcpy>:
ffffffffc020b838:	ca19                	beqz	a2,ffffffffc020b84e <memcpy+0x16>
ffffffffc020b83a:	962e                	add	a2,a2,a1
ffffffffc020b83c:	87aa                	mv	a5,a0
ffffffffc020b83e:	0005c703          	lbu	a4,0(a1)
ffffffffc020b842:	0585                	addi	a1,a1,1
ffffffffc020b844:	0785                	addi	a5,a5,1
ffffffffc020b846:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b84a:	fec59ae3          	bne	a1,a2,ffffffffc020b83e <memcpy+0x6>
ffffffffc020b84e:	8082                	ret
