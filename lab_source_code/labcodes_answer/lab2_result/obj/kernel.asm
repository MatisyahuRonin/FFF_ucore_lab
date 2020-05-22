
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 28 af 11 c0       	mov    $0xc011af28,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 a0 11 c0 	movl   $0xc011a000,(%esp)
c010005d:	e8 6d 5d 00 00       	call   c0105dcf <memset>

    cons_init();                // init the console
c0100062:	e8 82 15 00 00       	call   c01015e9 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 60 5f 10 c0 	movl   $0xc0105f60,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 7c 5f 10 c0 	movl   $0xc0105f7c,(%esp)
c010007c:	e8 c7 02 00 00       	call   c0100348 <cprintf>

    print_kerninfo();
c0100081:	e8 f6 07 00 00       	call   c010087c <print_kerninfo>

    grade_backtrace();
c0100086:	e8 86 00 00 00       	call   c0100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 aa 42 00 00       	call   c010433a <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 bd 16 00 00       	call   c0101752 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 0f 18 00 00       	call   c01018a9 <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 00 0d 00 00       	call   c0100d9f <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 1c 16 00 00       	call   c01016c0 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	55                   	push   %ebp
c01000a7:	89 e5                	mov    %esp,%ebp
c01000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b3:	00 
c01000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bb:	00 
c01000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c3:	e8 f8 0b 00 00       	call   c0100cc0 <mon_backtrace>
}
c01000c8:	c9                   	leave  
c01000c9:	c3                   	ret    

c01000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000ca:	55                   	push   %ebp
c01000cb:	89 e5                	mov    %esp,%ebp
c01000cd:	53                   	push   %ebx
c01000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000d7:	8d 55 08             	lea    0x8(%ebp),%edx
c01000da:	8b 45 08             	mov    0x8(%ebp),%eax
c01000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000e9:	89 04 24             	mov    %eax,(%esp)
c01000ec:	e8 b5 ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000f1:	83 c4 14             	add    $0x14,%esp
c01000f4:	5b                   	pop    %ebx
c01000f5:	5d                   	pop    %ebp
c01000f6:	c3                   	ret    

c01000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f7:	55                   	push   %ebp
c01000f8:	89 e5                	mov    %esp,%ebp
c01000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0100100:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100104:	8b 45 08             	mov    0x8(%ebp),%eax
c0100107:	89 04 24             	mov    %eax,(%esp)
c010010a:	e8 bb ff ff ff       	call   c01000ca <grade_backtrace1>
}
c010010f:	c9                   	leave  
c0100110:	c3                   	ret    

c0100111 <grade_backtrace>:

void
grade_backtrace(void) {
c0100111:	55                   	push   %ebp
c0100112:	89 e5                	mov    %esp,%ebp
c0100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100117:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100123:	ff 
c0100124:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010012f:	e8 c3 ff ff ff       	call   c01000f7 <grade_backtrace0>
}
c0100134:	c9                   	leave  
c0100135:	c3                   	ret    

c0100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100136:	55                   	push   %ebp
c0100137:	89 e5                	mov    %esp,%ebp
c0100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014c:	0f b7 c0             	movzwl %ax,%eax
c010014f:	83 e0 03             	and    $0x3,%eax
c0100152:	89 c2                	mov    %eax,%edx
c0100154:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100159:	89 54 24 08          	mov    %edx,0x8(%esp)
c010015d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100161:	c7 04 24 81 5f 10 c0 	movl   $0xc0105f81,(%esp)
c0100168:	e8 db 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100171:	0f b7 d0             	movzwl %ax,%edx
c0100174:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100179:	89 54 24 08          	mov    %edx,0x8(%esp)
c010017d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100181:	c7 04 24 8f 5f 10 c0 	movl   $0xc0105f8f,(%esp)
c0100188:	e8 bb 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100191:	0f b7 d0             	movzwl %ax,%edx
c0100194:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100199:	89 54 24 08          	mov    %edx,0x8(%esp)
c010019d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a1:	c7 04 24 9d 5f 10 c0 	movl   $0xc0105f9d,(%esp)
c01001a8:	e8 9b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b1:	0f b7 d0             	movzwl %ax,%edx
c01001b4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c1:	c7 04 24 ab 5f 10 c0 	movl   $0xc0105fab,(%esp)
c01001c8:	e8 7b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d1:	0f b7 d0             	movzwl %ax,%edx
c01001d4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e1:	c7 04 24 b9 5f 10 c0 	movl   $0xc0105fb9,(%esp)
c01001e8:	e8 5b 01 00 00       	call   c0100348 <cprintf>
    round ++;
c01001ed:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001f2:	83 c0 01             	add    $0x1,%eax
c01001f5:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
}
c01001fa:	c9                   	leave  
c01001fb:	c3                   	ret    

c01001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001fc:	55                   	push   %ebp
c01001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001ff:	5d                   	pop    %ebp
c0100200:	c3                   	ret    

c0100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100201:	55                   	push   %ebp
c0100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100204:	5d                   	pop    %ebp
c0100205:	c3                   	ret    

c0100206 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100206:	55                   	push   %ebp
c0100207:	89 e5                	mov    %esp,%ebp
c0100209:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020c:	e8 25 ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100211:	c7 04 24 c8 5f 10 c0 	movl   $0xc0105fc8,(%esp)
c0100218:	e8 2b 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_user();
c010021d:	e8 da ff ff ff       	call   c01001fc <lab1_switch_to_user>
    lab1_print_cur_status();
c0100222:	e8 0f ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100227:	c7 04 24 e8 5f 10 c0 	movl   $0xc0105fe8,(%esp)
c010022e:	e8 15 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_kernel();
c0100233:	e8 c9 ff ff ff       	call   c0100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100238:	e8 f9 fe ff ff       	call   c0100136 <lab1_print_cur_status>
}
c010023d:	c9                   	leave  
c010023e:	c3                   	ret    

c010023f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010023f:	55                   	push   %ebp
c0100240:	89 e5                	mov    %esp,%ebp
c0100242:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100249:	74 13                	je     c010025e <readline+0x1f>
        cprintf("%s", prompt);
c010024b:	8b 45 08             	mov    0x8(%ebp),%eax
c010024e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100252:	c7 04 24 07 60 10 c0 	movl   $0xc0106007,(%esp)
c0100259:	e8 ea 00 00 00       	call   c0100348 <cprintf>
    }
    int i = 0, c;
c010025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100265:	e8 66 01 00 00       	call   c01003d0 <getchar>
c010026a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010026d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100271:	79 07                	jns    c010027a <readline+0x3b>
            return NULL;
c0100273:	b8 00 00 00 00       	mov    $0x0,%eax
c0100278:	eb 79                	jmp    c01002f3 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010027e:	7e 28                	jle    c01002a8 <readline+0x69>
c0100280:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100287:	7f 1f                	jg     c01002a8 <readline+0x69>
            cputchar(c);
c0100289:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028c:	89 04 24             	mov    %eax,(%esp)
c010028f:	e8 da 00 00 00       	call   c010036e <cputchar>
            buf[i ++] = c;
c0100294:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100297:	8d 50 01             	lea    0x1(%eax),%edx
c010029a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010029d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a0:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
c01002a6:	eb 46                	jmp    c01002ee <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002a8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002ac:	75 17                	jne    c01002c5 <readline+0x86>
c01002ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b2:	7e 11                	jle    c01002c5 <readline+0x86>
            cputchar(c);
c01002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b7:	89 04 24             	mov    %eax,(%esp)
c01002ba:	e8 af 00 00 00       	call   c010036e <cputchar>
            i --;
c01002bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c3:	eb 29                	jmp    c01002ee <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c9:	74 06                	je     c01002d1 <readline+0x92>
c01002cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002cf:	75 1d                	jne    c01002ee <readline+0xaf>
            cputchar(c);
c01002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d4:	89 04 24             	mov    %eax,(%esp)
c01002d7:	e8 92 00 00 00       	call   c010036e <cputchar>
            buf[i] = '\0';
c01002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002df:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01002e4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e7:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
c01002ec:	eb 05                	jmp    c01002f3 <readline+0xb4>
        }
    }
c01002ee:	e9 72 ff ff ff       	jmp    c0100265 <readline+0x26>
}
c01002f3:	c9                   	leave  
c01002f4:	c3                   	ret    

c01002f5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f5:	55                   	push   %ebp
c01002f6:	89 e5                	mov    %esp,%ebp
c01002f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fe:	89 04 24             	mov    %eax,(%esp)
c0100301:	e8 0f 13 00 00       	call   c0101615 <cons_putc>
    (*cnt) ++;
c0100306:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100309:	8b 00                	mov    (%eax),%eax
c010030b:	8d 50 01             	lea    0x1(%eax),%edx
c010030e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100311:	89 10                	mov    %edx,(%eax)
}
c0100313:	c9                   	leave  
c0100314:	c3                   	ret    

c0100315 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100315:	55                   	push   %ebp
c0100316:	89 e5                	mov    %esp,%ebp
c0100318:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100322:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100325:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100329:	8b 45 08             	mov    0x8(%ebp),%eax
c010032c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100330:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100333:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100337:	c7 04 24 f5 02 10 c0 	movl   $0xc01002f5,(%esp)
c010033e:	e8 a5 52 00 00       	call   c01055e8 <vprintfmt>
    return cnt;
c0100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100346:	c9                   	leave  
c0100347:	c3                   	ret    

c0100348 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100348:	55                   	push   %ebp
c0100349:	89 e5                	mov    %esp,%ebp
c010034b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010034e:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100354:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100357:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035b:	8b 45 08             	mov    0x8(%ebp),%eax
c010035e:	89 04 24             	mov    %eax,(%esp)
c0100361:	e8 af ff ff ff       	call   c0100315 <vcprintf>
c0100366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100369:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036c:	c9                   	leave  
c010036d:	c3                   	ret    

c010036e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010036e:	55                   	push   %ebp
c010036f:	89 e5                	mov    %esp,%ebp
c0100371:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100374:	8b 45 08             	mov    0x8(%ebp),%eax
c0100377:	89 04 24             	mov    %eax,(%esp)
c010037a:	e8 96 12 00 00       	call   c0101615 <cons_putc>
}
c010037f:	c9                   	leave  
c0100380:	c3                   	ret    

c0100381 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100381:	55                   	push   %ebp
c0100382:	89 e5                	mov    %esp,%ebp
c0100384:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038e:	eb 13                	jmp    c01003a3 <cputs+0x22>
        cputch(c, &cnt);
c0100390:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100397:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039b:	89 04 24             	mov    %eax,(%esp)
c010039e:	e8 52 ff ff ff       	call   c01002f5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a6:	8d 50 01             	lea    0x1(%eax),%edx
c01003a9:	89 55 08             	mov    %edx,0x8(%ebp)
c01003ac:	0f b6 00             	movzbl (%eax),%eax
c01003af:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b6:	75 d8                	jne    c0100390 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003bf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c6:	e8 2a ff ff ff       	call   c01002f5 <cputch>
    return cnt;
c01003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003ce:	c9                   	leave  
c01003cf:	c3                   	ret    

c01003d0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d0:	55                   	push   %ebp
c01003d1:	89 e5                	mov    %esp,%ebp
c01003d3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d6:	e8 76 12 00 00       	call   c0101651 <cons_getc>
c01003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e2:	74 f2                	je     c01003d6 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003e7:	c9                   	leave  
c01003e8:	c3                   	ret    

c01003e9 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003e9:	55                   	push   %ebp
c01003ea:	89 e5                	mov    %esp,%ebp
c01003ec:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f2:	8b 00                	mov    (%eax),%eax
c01003f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fa:	8b 00                	mov    (%eax),%eax
c01003fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100406:	e9 d2 00 00 00       	jmp    c01004dd <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010040e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100411:	01 d0                	add    %edx,%eax
c0100413:	89 c2                	mov    %eax,%edx
c0100415:	c1 ea 1f             	shr    $0x1f,%edx
c0100418:	01 d0                	add    %edx,%eax
c010041a:	d1 f8                	sar    %eax
c010041c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100422:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100425:	eb 04                	jmp    c010042b <stab_binsearch+0x42>
            m --;
c0100427:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010042e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100431:	7c 1f                	jl     c0100452 <stab_binsearch+0x69>
c0100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100436:	89 d0                	mov    %edx,%eax
c0100438:	01 c0                	add    %eax,%eax
c010043a:	01 d0                	add    %edx,%eax
c010043c:	c1 e0 02             	shl    $0x2,%eax
c010043f:	89 c2                	mov    %eax,%edx
c0100441:	8b 45 08             	mov    0x8(%ebp),%eax
c0100444:	01 d0                	add    %edx,%eax
c0100446:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044a:	0f b6 c0             	movzbl %al,%eax
c010044d:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100450:	75 d5                	jne    c0100427 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100452:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100455:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100458:	7d 0b                	jge    c0100465 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010045d:	83 c0 01             	add    $0x1,%eax
c0100460:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100463:	eb 78                	jmp    c01004dd <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100465:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010046f:	89 d0                	mov    %edx,%eax
c0100471:	01 c0                	add    %eax,%eax
c0100473:	01 d0                	add    %edx,%eax
c0100475:	c1 e0 02             	shl    $0x2,%eax
c0100478:	89 c2                	mov    %eax,%edx
c010047a:	8b 45 08             	mov    0x8(%ebp),%eax
c010047d:	01 d0                	add    %edx,%eax
c010047f:	8b 40 08             	mov    0x8(%eax),%eax
c0100482:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100485:	73 13                	jae    c010049a <stab_binsearch+0xb1>
            *region_left = m;
c0100487:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010048f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100492:	83 c0 01             	add    $0x1,%eax
c0100495:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100498:	eb 43                	jmp    c01004dd <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049d:	89 d0                	mov    %edx,%eax
c010049f:	01 c0                	add    %eax,%eax
c01004a1:	01 d0                	add    %edx,%eax
c01004a3:	c1 e0 02             	shl    $0x2,%eax
c01004a6:	89 c2                	mov    %eax,%edx
c01004a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ab:	01 d0                	add    %edx,%eax
c01004ad:	8b 40 08             	mov    0x8(%eax),%eax
c01004b0:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b3:	76 16                	jbe    c01004cb <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004be:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	83 e8 01             	sub    $0x1,%eax
c01004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c9:	eb 12                	jmp    c01004dd <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d1:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004d9:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e3:	0f 8e 22 ff ff ff    	jle    c010040b <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004ed:	75 0f                	jne    c01004fe <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f2:	8b 00                	mov    (%eax),%eax
c01004f4:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fa:	89 10                	mov    %edx,(%eax)
c01004fc:	eb 3f                	jmp    c010053d <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0100501:	8b 00                	mov    (%eax),%eax
c0100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100506:	eb 04                	jmp    c010050c <stab_binsearch+0x123>
c0100508:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050f:	8b 00                	mov    (%eax),%eax
c0100511:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100514:	7d 1f                	jge    c0100535 <stab_binsearch+0x14c>
c0100516:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100519:	89 d0                	mov    %edx,%eax
c010051b:	01 c0                	add    %eax,%eax
c010051d:	01 d0                	add    %edx,%eax
c010051f:	c1 e0 02             	shl    $0x2,%eax
c0100522:	89 c2                	mov    %eax,%edx
c0100524:	8b 45 08             	mov    0x8(%ebp),%eax
c0100527:	01 d0                	add    %edx,%eax
c0100529:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010052d:	0f b6 c0             	movzbl %al,%eax
c0100530:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100533:	75 d3                	jne    c0100508 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100535:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100538:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053b:	89 10                	mov    %edx,(%eax)
    }
}
c010053d:	c9                   	leave  
c010053e:	c3                   	ret    

c010053f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010053f:	55                   	push   %ebp
c0100540:	89 e5                	mov    %esp,%ebp
c0100542:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100545:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100548:	c7 00 0c 60 10 c0    	movl   $0xc010600c,(%eax)
    info->eip_line = 0;
c010054e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100558:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055b:	c7 40 08 0c 60 10 c0 	movl   $0xc010600c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100562:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100565:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100572:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100575:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100578:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010057f:	c7 45 f4 80 72 10 c0 	movl   $0xc0107280,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100586:	c7 45 f0 58 1e 11 c0 	movl   $0xc0111e58,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010058d:	c7 45 ec 59 1e 11 c0 	movl   $0xc0111e59,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100594:	c7 45 e8 81 48 11 c0 	movl   $0xc0114881,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a1:	76 0d                	jbe    c01005b0 <debuginfo_eip+0x71>
c01005a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a6:	83 e8 01             	sub    $0x1,%eax
c01005a9:	0f b6 00             	movzbl (%eax),%eax
c01005ac:	84 c0                	test   %al,%al
c01005ae:	74 0a                	je     c01005ba <debuginfo_eip+0x7b>
        return -1;
c01005b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b5:	e9 c0 02 00 00       	jmp    c010087a <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005c7:	29 c2                	sub    %eax,%edx
c01005c9:	89 d0                	mov    %edx,%eax
c01005cb:	c1 f8 02             	sar    $0x2,%eax
c01005ce:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d4:	83 e8 01             	sub    $0x1,%eax
c01005d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005da:	8b 45 08             	mov    0x8(%ebp),%eax
c01005dd:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005e8:	00 
c01005e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fa:	89 04 24             	mov    %eax,(%esp)
c01005fd:	e8 e7 fd ff ff       	call   c01003e9 <stab_binsearch>
    if (lfile == 0)
c0100602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100605:	85 c0                	test   %eax,%eax
c0100607:	75 0a                	jne    c0100613 <debuginfo_eip+0xd4>
        return -1;
c0100609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060e:	e9 67 02 00 00       	jmp    c010087a <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100616:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100619:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010061f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100622:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100626:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010062d:	00 
c010062e:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100631:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100635:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100638:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063f:	89 04 24             	mov    %eax,(%esp)
c0100642:	e8 a2 fd ff ff       	call   c01003e9 <stab_binsearch>

    if (lfun <= rfun) {
c0100647:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010064d:	39 c2                	cmp    %eax,%edx
c010064f:	7f 7c                	jg     c01006cd <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100651:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100654:	89 c2                	mov    %eax,%edx
c0100656:	89 d0                	mov    %edx,%eax
c0100658:	01 c0                	add    %eax,%eax
c010065a:	01 d0                	add    %edx,%eax
c010065c:	c1 e0 02             	shl    $0x2,%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100664:	01 d0                	add    %edx,%eax
c0100666:	8b 10                	mov    (%eax),%edx
c0100668:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066e:	29 c1                	sub    %eax,%ecx
c0100670:	89 c8                	mov    %ecx,%eax
c0100672:	39 c2                	cmp    %eax,%edx
c0100674:	73 22                	jae    c0100698 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100676:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100679:	89 c2                	mov    %eax,%edx
c010067b:	89 d0                	mov    %edx,%eax
c010067d:	01 c0                	add    %eax,%eax
c010067f:	01 d0                	add    %edx,%eax
c0100681:	c1 e0 02             	shl    $0x2,%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100689:	01 d0                	add    %edx,%eax
c010068b:	8b 10                	mov    (%eax),%edx
c010068d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100690:	01 c2                	add    %eax,%edx
c0100692:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100695:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100698:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069b:	89 c2                	mov    %eax,%edx
c010069d:	89 d0                	mov    %edx,%eax
c010069f:	01 c0                	add    %eax,%eax
c01006a1:	01 d0                	add    %edx,%eax
c01006a3:	c1 e0 02             	shl    $0x2,%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ab:	01 d0                	add    %edx,%eax
c01006ad:	8b 50 08             	mov    0x8(%eax),%edx
c01006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b9:	8b 40 10             	mov    0x10(%eax),%eax
c01006bc:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006cb:	eb 15                	jmp    c01006e2 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d0:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e5:	8b 40 08             	mov    0x8(%eax),%eax
c01006e8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006ef:	00 
c01006f0:	89 04 24             	mov    %eax,(%esp)
c01006f3:	e8 4b 55 00 00       	call   c0105c43 <strfind>
c01006f8:	89 c2                	mov    %eax,%edx
c01006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006fd:	8b 40 08             	mov    0x8(%eax),%eax
c0100700:	29 c2                	sub    %eax,%edx
c0100702:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100705:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100708:	8b 45 08             	mov    0x8(%ebp),%eax
c010070b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010070f:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100716:	00 
c0100717:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010071e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100721:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100728:	89 04 24             	mov    %eax,(%esp)
c010072b:	e8 b9 fc ff ff       	call   c01003e9 <stab_binsearch>
    if (lline <= rline) {
c0100730:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100733:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100736:	39 c2                	cmp    %eax,%edx
c0100738:	7f 24                	jg     c010075e <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073d:	89 c2                	mov    %eax,%edx
c010073f:	89 d0                	mov    %edx,%eax
c0100741:	01 c0                	add    %eax,%eax
c0100743:	01 d0                	add    %edx,%eax
c0100745:	c1 e0 02             	shl    $0x2,%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074d:	01 d0                	add    %edx,%eax
c010074f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100753:	0f b7 d0             	movzwl %ax,%edx
c0100756:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100759:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075c:	eb 13                	jmp    c0100771 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010075e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100763:	e9 12 01 00 00       	jmp    c010087a <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076b:	83 e8 01             	sub    $0x1,%eax
c010076e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100777:	39 c2                	cmp    %eax,%edx
c0100779:	7c 56                	jl     c01007d1 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077e:	89 c2                	mov    %eax,%edx
c0100780:	89 d0                	mov    %edx,%eax
c0100782:	01 c0                	add    %eax,%eax
c0100784:	01 d0                	add    %edx,%eax
c0100786:	c1 e0 02             	shl    $0x2,%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078e:	01 d0                	add    %edx,%eax
c0100790:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100794:	3c 84                	cmp    $0x84,%al
c0100796:	74 39                	je     c01007d1 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	89 d0                	mov    %edx,%eax
c010079f:	01 c0                	add    %eax,%eax
c01007a1:	01 d0                	add    %edx,%eax
c01007a3:	c1 e0 02             	shl    $0x2,%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ab:	01 d0                	add    %edx,%eax
c01007ad:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b1:	3c 64                	cmp    $0x64,%al
c01007b3:	75 b3                	jne    c0100768 <debuginfo_eip+0x229>
c01007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007b8:	89 c2                	mov    %eax,%edx
c01007ba:	89 d0                	mov    %edx,%eax
c01007bc:	01 c0                	add    %eax,%eax
c01007be:	01 d0                	add    %edx,%eax
c01007c0:	c1 e0 02             	shl    $0x2,%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c8:	01 d0                	add    %edx,%eax
c01007ca:	8b 40 08             	mov    0x8(%eax),%eax
c01007cd:	85 c0                	test   %eax,%eax
c01007cf:	74 97                	je     c0100768 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007d7:	39 c2                	cmp    %eax,%edx
c01007d9:	7c 46                	jl     c0100821 <debuginfo_eip+0x2e2>
c01007db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007de:	89 c2                	mov    %eax,%edx
c01007e0:	89 d0                	mov    %edx,%eax
c01007e2:	01 c0                	add    %eax,%eax
c01007e4:	01 d0                	add    %edx,%eax
c01007e6:	c1 e0 02             	shl    $0x2,%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ee:	01 d0                	add    %edx,%eax
c01007f0:	8b 10                	mov    (%eax),%edx
c01007f2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007f8:	29 c1                	sub    %eax,%ecx
c01007fa:	89 c8                	mov    %ecx,%eax
c01007fc:	39 c2                	cmp    %eax,%edx
c01007fe:	73 21                	jae    c0100821 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100803:	89 c2                	mov    %eax,%edx
c0100805:	89 d0                	mov    %edx,%eax
c0100807:	01 c0                	add    %eax,%eax
c0100809:	01 d0                	add    %edx,%eax
c010080b:	c1 e0 02             	shl    $0x2,%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100813:	01 d0                	add    %edx,%eax
c0100815:	8b 10                	mov    (%eax),%edx
c0100817:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081a:	01 c2                	add    %eax,%edx
c010081c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100821:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100824:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100827:	39 c2                	cmp    %eax,%edx
c0100829:	7d 4a                	jge    c0100875 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010082e:	83 c0 01             	add    $0x1,%eax
c0100831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100834:	eb 18                	jmp    c010084e <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100836:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100839:	8b 40 14             	mov    0x14(%eax),%eax
c010083c:	8d 50 01             	lea    0x1(%eax),%edx
c010083f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100842:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100848:	83 c0 01             	add    $0x1,%eax
c010084b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100851:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100854:	39 c2                	cmp    %eax,%edx
c0100856:	7d 1d                	jge    c0100875 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	89 d0                	mov    %edx,%eax
c010085f:	01 c0                	add    %eax,%eax
c0100861:	01 d0                	add    %edx,%eax
c0100863:	c1 e0 02             	shl    $0x2,%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086b:	01 d0                	add    %edx,%eax
c010086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100871:	3c a0                	cmp    $0xa0,%al
c0100873:	74 c1                	je     c0100836 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100875:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087a:	c9                   	leave  
c010087b:	c3                   	ret    

c010087c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087c:	55                   	push   %ebp
c010087d:	89 e5                	mov    %esp,%ebp
c010087f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100882:	c7 04 24 16 60 10 c0 	movl   $0xc0106016,(%esp)
c0100889:	e8 ba fa ff ff       	call   c0100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088e:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100895:	c0 
c0100896:	c7 04 24 2f 60 10 c0 	movl   $0xc010602f,(%esp)
c010089d:	e8 a6 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a2:	c7 44 24 04 58 5f 10 	movl   $0xc0105f58,0x4(%esp)
c01008a9:	c0 
c01008aa:	c7 04 24 47 60 10 c0 	movl   $0xc0106047,(%esp)
c01008b1:	e8 92 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b6:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c01008bd:	c0 
c01008be:	c7 04 24 5f 60 10 c0 	movl   $0xc010605f,(%esp)
c01008c5:	e8 7e fa ff ff       	call   c0100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008ca:	c7 44 24 04 28 af 11 	movl   $0xc011af28,0x4(%esp)
c01008d1:	c0 
c01008d2:	c7 04 24 77 60 10 c0 	movl   $0xc0106077,(%esp)
c01008d9:	e8 6a fa ff ff       	call   c0100348 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008de:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c01008e3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008e9:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01008ee:	29 c2                	sub    %eax,%edx
c01008f0:	89 d0                	mov    %edx,%eax
c01008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f8:	85 c0                	test   %eax,%eax
c01008fa:	0f 48 c2             	cmovs  %edx,%eax
c01008fd:	c1 f8 0a             	sar    $0xa,%eax
c0100900:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100904:	c7 04 24 90 60 10 c0 	movl   $0xc0106090,(%esp)
c010090b:	e8 38 fa ff ff       	call   c0100348 <cprintf>
}
c0100910:	c9                   	leave  
c0100911:	c3                   	ret    

c0100912 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100912:	55                   	push   %ebp
c0100913:	89 e5                	mov    %esp,%ebp
c0100915:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091b:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010091e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100922:	8b 45 08             	mov    0x8(%ebp),%eax
c0100925:	89 04 24             	mov    %eax,(%esp)
c0100928:	e8 12 fc ff ff       	call   c010053f <debuginfo_eip>
c010092d:	85 c0                	test   %eax,%eax
c010092f:	74 15                	je     c0100946 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100931:	8b 45 08             	mov    0x8(%ebp),%eax
c0100934:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100938:	c7 04 24 ba 60 10 c0 	movl   $0xc01060ba,(%esp)
c010093f:	e8 04 fa ff ff       	call   c0100348 <cprintf>
c0100944:	eb 6d                	jmp    c01009b3 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010094d:	eb 1c                	jmp    c010096b <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100955:	01 d0                	add    %edx,%eax
c0100957:	0f b6 00             	movzbl (%eax),%eax
c010095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100963:	01 ca                	add    %ecx,%edx
c0100965:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100971:	7f dc                	jg     c010094f <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097c:	01 d0                	add    %edx,%eax
c010097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100984:	8b 55 08             	mov    0x8(%ebp),%edx
c0100987:	89 d1                	mov    %edx,%ecx
c0100989:	29 c1                	sub    %eax,%ecx
c010098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010099f:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a7:	c7 04 24 d6 60 10 c0 	movl   $0xc01060d6,(%esp)
c01009ae:	e8 95 f9 ff ff       	call   c0100348 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b3:	c9                   	leave  
c01009b4:	c3                   	ret    

c01009b5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b5:	55                   	push   %ebp
c01009b6:	89 e5                	mov    %esp,%ebp
c01009b8:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009bb:	8b 45 04             	mov    0x4(%ebp),%eax
c01009be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c4:	c9                   	leave  
c01009c5:	c3                   	ret    

c01009c6 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c6:	55                   	push   %ebp
c01009c7:	89 e5                	mov    %esp,%ebp
c01009c9:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cc:	89 e8                	mov    %ebp,%eax
c01009ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009d7:	e8 d9 ff ff ff       	call   c01009b5 <read_eip>
c01009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e6:	e9 88 00 00 00       	jmp    c0100a73 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ee:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f9:	c7 04 24 e8 60 10 c0 	movl   $0xc01060e8,(%esp)
c0100a00:	e8 43 f9 ff ff       	call   c0100348 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a08:	83 c0 08             	add    $0x8,%eax
c0100a0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a0e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a15:	eb 25                	jmp    c0100a3c <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a24:	01 d0                	add    %edx,%eax
c0100a26:	8b 00                	mov    (%eax),%eax
c0100a28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2c:	c7 04 24 04 61 10 c0 	movl   $0xc0106104,(%esp)
c0100a33:	e8 10 f9 ff ff       	call   c0100348 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a38:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a3c:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a40:	7e d5                	jle    c0100a17 <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a42:	c7 04 24 0c 61 10 c0 	movl   $0xc010610c,(%esp)
c0100a49:	e8 fa f8 ff ff       	call   c0100348 <cprintf>
        print_debuginfo(eip - 1);
c0100a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a51:	83 e8 01             	sub    $0x1,%eax
c0100a54:	89 04 24             	mov    %eax,(%esp)
c0100a57:	e8 b6 fe ff ff       	call   c0100912 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5f:	83 c0 04             	add    $0x4,%eax
c0100a62:	8b 00                	mov    (%eax),%eax
c0100a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6a:	8b 00                	mov    (%eax),%eax
c0100a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a6f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a77:	74 0a                	je     c0100a83 <print_stackframe+0xbd>
c0100a79:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a7d:	0f 8e 68 ff ff ff    	jle    c01009eb <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a83:	c9                   	leave  
c0100a84:	c3                   	ret    

c0100a85 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a85:	55                   	push   %ebp
c0100a86:	89 e5                	mov    %esp,%ebp
c0100a88:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a92:	eb 0c                	jmp    c0100aa0 <parse+0x1b>
            *buf ++ = '\0';
c0100a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a97:	8d 50 01             	lea    0x1(%eax),%edx
c0100a9a:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a9d:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa3:	0f b6 00             	movzbl (%eax),%eax
c0100aa6:	84 c0                	test   %al,%al
c0100aa8:	74 1d                	je     c0100ac7 <parse+0x42>
c0100aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aad:	0f b6 00             	movzbl (%eax),%eax
c0100ab0:	0f be c0             	movsbl %al,%eax
c0100ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab7:	c7 04 24 90 61 10 c0 	movl   $0xc0106190,(%esp)
c0100abe:	e8 4d 51 00 00       	call   c0105c10 <strchr>
c0100ac3:	85 c0                	test   %eax,%eax
c0100ac5:	75 cd                	jne    c0100a94 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aca:	0f b6 00             	movzbl (%eax),%eax
c0100acd:	84 c0                	test   %al,%al
c0100acf:	75 02                	jne    c0100ad3 <parse+0x4e>
            break;
c0100ad1:	eb 67                	jmp    c0100b3a <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad7:	75 14                	jne    c0100aed <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad9:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ae0:	00 
c0100ae1:	c7 04 24 95 61 10 c0 	movl   $0xc0106195,(%esp)
c0100ae8:	e8 5b f8 ff ff       	call   c0100348 <cprintf>
        }
        argv[argc ++] = buf;
c0100aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af0:	8d 50 01             	lea    0x1(%eax),%edx
c0100af3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100afd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b00:	01 c2                	add    %eax,%edx
c0100b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b05:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b07:	eb 04                	jmp    c0100b0d <parse+0x88>
            buf ++;
c0100b09:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b10:	0f b6 00             	movzbl (%eax),%eax
c0100b13:	84 c0                	test   %al,%al
c0100b15:	74 1d                	je     c0100b34 <parse+0xaf>
c0100b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1a:	0f b6 00             	movzbl (%eax),%eax
c0100b1d:	0f be c0             	movsbl %al,%eax
c0100b20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b24:	c7 04 24 90 61 10 c0 	movl   $0xc0106190,(%esp)
c0100b2b:	e8 e0 50 00 00       	call   c0105c10 <strchr>
c0100b30:	85 c0                	test   %eax,%eax
c0100b32:	74 d5                	je     c0100b09 <parse+0x84>
            buf ++;
        }
    }
c0100b34:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b35:	e9 66 ff ff ff       	jmp    c0100aa0 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b3d:	c9                   	leave  
c0100b3e:	c3                   	ret    

c0100b3f <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3f:	55                   	push   %ebp
c0100b40:	89 e5                	mov    %esp,%ebp
c0100b42:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b45:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4f:	89 04 24             	mov    %eax,(%esp)
c0100b52:	e8 2e ff ff ff       	call   c0100a85 <parse>
c0100b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b5e:	75 0a                	jne    c0100b6a <runcmd+0x2b>
        return 0;
c0100b60:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b65:	e9 85 00 00 00       	jmp    c0100bef <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b71:	eb 5c                	jmp    c0100bcf <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b73:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b79:	89 d0                	mov    %edx,%eax
c0100b7b:	01 c0                	add    %eax,%eax
c0100b7d:	01 d0                	add    %edx,%eax
c0100b7f:	c1 e0 02             	shl    $0x2,%eax
c0100b82:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100b87:	8b 00                	mov    (%eax),%eax
c0100b89:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b8d:	89 04 24             	mov    %eax,(%esp)
c0100b90:	e8 dc 4f 00 00       	call   c0105b71 <strcmp>
c0100b95:	85 c0                	test   %eax,%eax
c0100b97:	75 32                	jne    c0100bcb <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9c:	89 d0                	mov    %edx,%eax
c0100b9e:	01 c0                	add    %eax,%eax
c0100ba0:	01 d0                	add    %edx,%eax
c0100ba2:	c1 e0 02             	shl    $0x2,%eax
c0100ba5:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100baa:	8b 40 08             	mov    0x8(%eax),%eax
c0100bad:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bb0:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb6:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bba:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bbd:	83 c2 04             	add    $0x4,%edx
c0100bc0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc4:	89 0c 24             	mov    %ecx,(%esp)
c0100bc7:	ff d0                	call   *%eax
c0100bc9:	eb 24                	jmp    c0100bef <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bcb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd2:	83 f8 02             	cmp    $0x2,%eax
c0100bd5:	76 9c                	jbe    c0100b73 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bde:	c7 04 24 b3 61 10 c0 	movl   $0xc01061b3,(%esp)
c0100be5:	e8 5e f7 ff ff       	call   c0100348 <cprintf>
    return 0;
c0100bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bef:	c9                   	leave  
c0100bf0:	c3                   	ret    

c0100bf1 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf1:	55                   	push   %ebp
c0100bf2:	89 e5                	mov    %esp,%ebp
c0100bf4:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf7:	c7 04 24 cc 61 10 c0 	movl   $0xc01061cc,(%esp)
c0100bfe:	e8 45 f7 ff ff       	call   c0100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c03:	c7 04 24 f4 61 10 c0 	movl   $0xc01061f4,(%esp)
c0100c0a:	e8 39 f7 ff ff       	call   c0100348 <cprintf>

    if (tf != NULL) {
c0100c0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c13:	74 0b                	je     c0100c20 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c18:	89 04 24             	mov    %eax,(%esp)
c0100c1b:	e8 c2 0d 00 00       	call   c01019e2 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c20:	c7 04 24 19 62 10 c0 	movl   $0xc0106219,(%esp)
c0100c27:	e8 13 f6 ff ff       	call   c010023f <readline>
c0100c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c33:	74 18                	je     c0100c4d <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c35:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c3f:	89 04 24             	mov    %eax,(%esp)
c0100c42:	e8 f8 fe ff ff       	call   c0100b3f <runcmd>
c0100c47:	85 c0                	test   %eax,%eax
c0100c49:	79 02                	jns    c0100c4d <kmonitor+0x5c>
                break;
c0100c4b:	eb 02                	jmp    c0100c4f <kmonitor+0x5e>
            }
        }
    }
c0100c4d:	eb d1                	jmp    c0100c20 <kmonitor+0x2f>
}
c0100c4f:	c9                   	leave  
c0100c50:	c3                   	ret    

c0100c51 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c51:	55                   	push   %ebp
c0100c52:	89 e5                	mov    %esp,%ebp
c0100c54:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c5e:	eb 3f                	jmp    c0100c9f <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c63:	89 d0                	mov    %edx,%eax
c0100c65:	01 c0                	add    %eax,%eax
c0100c67:	01 d0                	add    %edx,%eax
c0100c69:	c1 e0 02             	shl    $0x2,%eax
c0100c6c:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c71:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c77:	89 d0                	mov    %edx,%eax
c0100c79:	01 c0                	add    %eax,%eax
c0100c7b:	01 d0                	add    %edx,%eax
c0100c7d:	c1 e0 02             	shl    $0x2,%eax
c0100c80:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c85:	8b 00                	mov    (%eax),%eax
c0100c87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c8b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8f:	c7 04 24 1d 62 10 c0 	movl   $0xc010621d,(%esp)
c0100c96:	e8 ad f6 ff ff       	call   c0100348 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca2:	83 f8 02             	cmp    $0x2,%eax
c0100ca5:	76 b9                	jbe    c0100c60 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cac:	c9                   	leave  
c0100cad:	c3                   	ret    

c0100cae <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cae:	55                   	push   %ebp
c0100caf:	89 e5                	mov    %esp,%ebp
c0100cb1:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb4:	e8 c3 fb ff ff       	call   c010087c <print_kerninfo>
    return 0;
c0100cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbe:	c9                   	leave  
c0100cbf:	c3                   	ret    

c0100cc0 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cc0:	55                   	push   %ebp
c0100cc1:	89 e5                	mov    %esp,%ebp
c0100cc3:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc6:	e8 fb fc ff ff       	call   c01009c6 <print_stackframe>
    return 0;
c0100ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd0:	c9                   	leave  
c0100cd1:	c3                   	ret    

c0100cd2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cd2:	55                   	push   %ebp
c0100cd3:	89 e5                	mov    %esp,%ebp
c0100cd5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd8:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c0100cdd:	85 c0                	test   %eax,%eax
c0100cdf:	74 02                	je     c0100ce3 <__panic+0x11>
        goto panic_dead;
c0100ce1:	eb 59                	jmp    c0100d3c <__panic+0x6a>
    }
    is_panic = 1;
c0100ce3:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
c0100cea:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ced:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf6:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d01:	c7 04 24 26 62 10 c0 	movl   $0xc0106226,(%esp)
c0100d08:	e8 3b f6 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d14:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d17:	89 04 24             	mov    %eax,(%esp)
c0100d1a:	e8 f6 f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d1f:	c7 04 24 42 62 10 c0 	movl   $0xc0106242,(%esp)
c0100d26:	e8 1d f6 ff ff       	call   c0100348 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d2b:	c7 04 24 44 62 10 c0 	movl   $0xc0106244,(%esp)
c0100d32:	e8 11 f6 ff ff       	call   c0100348 <cprintf>
    print_stackframe();
c0100d37:	e8 8a fc ff ff       	call   c01009c6 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d3c:	e8 85 09 00 00       	call   c01016c6 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d48:	e8 a4 fe ff ff       	call   c0100bf1 <kmonitor>
    }
c0100d4d:	eb f2                	jmp    c0100d41 <__panic+0x6f>

c0100d4f <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d4f:	55                   	push   %ebp
c0100d50:	89 e5                	mov    %esp,%ebp
c0100d52:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d55:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d5e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d62:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d69:	c7 04 24 56 62 10 c0 	movl   $0xc0106256,(%esp)
c0100d70:	e8 d3 f5 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d7c:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d7f:	89 04 24             	mov    %eax,(%esp)
c0100d82:	e8 8e f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d87:	c7 04 24 42 62 10 c0 	movl   $0xc0106242,(%esp)
c0100d8e:	e8 b5 f5 ff ff       	call   c0100348 <cprintf>
    va_end(ap);
}
c0100d93:	c9                   	leave  
c0100d94:	c3                   	ret    

c0100d95 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d95:	55                   	push   %ebp
c0100d96:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d98:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
}
c0100d9d:	5d                   	pop    %ebp
c0100d9e:	c3                   	ret    

c0100d9f <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d9f:	55                   	push   %ebp
c0100da0:	89 e5                	mov    %esp,%ebp
c0100da2:	83 ec 28             	sub    $0x28,%esp
c0100da5:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100dab:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100daf:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100db3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db7:	ee                   	out    %al,(%dx)
c0100db8:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dbe:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dc2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dc6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dca:	ee                   	out    %al,(%dx)
c0100dcb:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dd1:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dd5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ddd:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dde:	c7 05 0c af 11 c0 00 	movl   $0x0,0xc011af0c
c0100de5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de8:	c7 04 24 74 62 10 c0 	movl   $0xc0106274,(%esp)
c0100def:	e8 54 f5 ff ff       	call   c0100348 <cprintf>
    pic_enable(IRQ_TIMER);
c0100df4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dfb:	e8 24 09 00 00       	call   c0101724 <pic_enable>
}
c0100e00:	c9                   	leave  
c0100e01:	c3                   	ret    

c0100e02 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e02:	55                   	push   %ebp
c0100e03:	89 e5                	mov    %esp,%ebp
c0100e05:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e08:	9c                   	pushf  
c0100e09:	58                   	pop    %eax
c0100e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e10:	25 00 02 00 00       	and    $0x200,%eax
c0100e15:	85 c0                	test   %eax,%eax
c0100e17:	74 0c                	je     c0100e25 <__intr_save+0x23>
        intr_disable();
c0100e19:	e8 a8 08 00 00       	call   c01016c6 <intr_disable>
        return 1;
c0100e1e:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e23:	eb 05                	jmp    c0100e2a <__intr_save+0x28>
    }
    return 0;
c0100e25:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e2a:	c9                   	leave  
c0100e2b:	c3                   	ret    

c0100e2c <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e2c:	55                   	push   %ebp
c0100e2d:	89 e5                	mov    %esp,%ebp
c0100e2f:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e36:	74 05                	je     c0100e3d <__intr_restore+0x11>
        intr_enable();
c0100e38:	e8 83 08 00 00       	call   c01016c0 <intr_enable>
    }
}
c0100e3d:	c9                   	leave  
c0100e3e:	c3                   	ret    

c0100e3f <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e3f:	55                   	push   %ebp
c0100e40:	89 e5                	mov    %esp,%ebp
c0100e42:	83 ec 10             	sub    $0x10,%esp
c0100e45:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e4b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e4f:	89 c2                	mov    %eax,%edx
c0100e51:	ec                   	in     (%dx),%al
c0100e52:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e55:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e5b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e5f:	89 c2                	mov    %eax,%edx
c0100e61:	ec                   	in     (%dx),%al
c0100e62:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e65:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e6b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e6f:	89 c2                	mov    %eax,%edx
c0100e71:	ec                   	in     (%dx),%al
c0100e72:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e75:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e7b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e7f:	89 c2                	mov    %eax,%edx
c0100e81:	ec                   	in     (%dx),%al
c0100e82:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e85:	c9                   	leave  
c0100e86:	c3                   	ret    

c0100e87 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e87:	55                   	push   %ebp
c0100e88:	89 e5                	mov    %esp,%ebp
c0100e8a:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e8d:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e97:	0f b7 00             	movzwl (%eax),%eax
c0100e9a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea1:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea9:	0f b7 00             	movzwl (%eax),%eax
c0100eac:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100eb0:	74 12                	je     c0100ec4 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eb2:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eb9:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100ec0:	b4 03 
c0100ec2:	eb 13                	jmp    c0100ed7 <cga_init+0x50>
    } else {
        *cp = was;
c0100ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ecb:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ece:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100ed5:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed7:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ede:	0f b7 c0             	movzwl %ax,%eax
c0100ee1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ee5:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100eed:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ef1:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ef2:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ef9:	83 c0 01             	add    $0x1,%eax
c0100efc:	0f b7 c0             	movzwl %ax,%eax
c0100eff:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f03:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f07:	89 c2                	mov    %eax,%edx
c0100f09:	ec                   	in     (%dx),%al
c0100f0a:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f0d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f11:	0f b6 c0             	movzbl %al,%eax
c0100f14:	c1 e0 08             	shl    $0x8,%eax
c0100f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f1a:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f21:	0f b7 c0             	movzwl %ax,%eax
c0100f24:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f28:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f2c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f30:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f34:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f35:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f3c:	83 c0 01             	add    $0x1,%eax
c0100f3f:	0f b7 c0             	movzwl %ax,%eax
c0100f42:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f46:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f4a:	89 c2                	mov    %eax,%edx
c0100f4c:	ec                   	in     (%dx),%al
c0100f4d:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f50:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f54:	0f b6 c0             	movzbl %al,%eax
c0100f57:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f5d:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f65:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
}
c0100f6b:	c9                   	leave  
c0100f6c:	c3                   	ret    

c0100f6d <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f6d:	55                   	push   %ebp
c0100f6e:	89 e5                	mov    %esp,%ebp
c0100f70:	83 ec 48             	sub    $0x48,%esp
c0100f73:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f79:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f7d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f81:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f85:	ee                   	out    %al,(%dx)
c0100f86:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f8c:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f90:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f94:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f98:	ee                   	out    %al,(%dx)
c0100f99:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f9f:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fa3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fa7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fab:	ee                   	out    %al,(%dx)
c0100fac:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fb2:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fb6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fba:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fbe:	ee                   	out    %al,(%dx)
c0100fbf:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fc5:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fc9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fcd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fd1:	ee                   	out    %al,(%dx)
c0100fd2:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fd8:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fdc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fe0:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fe4:	ee                   	out    %al,(%dx)
c0100fe5:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100feb:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fef:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100ff3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff7:	ee                   	out    %al,(%dx)
c0100ff8:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ffe:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101002:	89 c2                	mov    %eax,%edx
c0101004:	ec                   	in     (%dx),%al
c0101005:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101008:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010100c:	3c ff                	cmp    $0xff,%al
c010100e:	0f 95 c0             	setne  %al
c0101011:	0f b6 c0             	movzbl %al,%eax
c0101014:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
c0101019:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010101f:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101023:	89 c2                	mov    %eax,%edx
c0101025:	ec                   	in     (%dx),%al
c0101026:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101029:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010102f:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101033:	89 c2                	mov    %eax,%edx
c0101035:	ec                   	in     (%dx),%al
c0101036:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101039:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010103e:	85 c0                	test   %eax,%eax
c0101040:	74 0c                	je     c010104e <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101042:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101049:	e8 d6 06 00 00       	call   c0101724 <pic_enable>
    }
}
c010104e:	c9                   	leave  
c010104f:	c3                   	ret    

c0101050 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101050:	55                   	push   %ebp
c0101051:	89 e5                	mov    %esp,%ebp
c0101053:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101056:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010105d:	eb 09                	jmp    c0101068 <lpt_putc_sub+0x18>
        delay();
c010105f:	e8 db fd ff ff       	call   c0100e3f <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101064:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101068:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010106e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101072:	89 c2                	mov    %eax,%edx
c0101074:	ec                   	in     (%dx),%al
c0101075:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101078:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010107c:	84 c0                	test   %al,%al
c010107e:	78 09                	js     c0101089 <lpt_putc_sub+0x39>
c0101080:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101087:	7e d6                	jle    c010105f <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101089:	8b 45 08             	mov    0x8(%ebp),%eax
c010108c:	0f b6 c0             	movzbl %al,%eax
c010108f:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101095:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101098:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010109c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010a0:	ee                   	out    %al,(%dx)
c01010a1:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010a7:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010ab:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010af:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010b3:	ee                   	out    %al,(%dx)
c01010b4:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010ba:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010be:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010c2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010c6:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010c7:	c9                   	leave  
c01010c8:	c3                   	ret    

c01010c9 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c9:	55                   	push   %ebp
c01010ca:	89 e5                	mov    %esp,%ebp
c01010cc:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010cf:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010d3:	74 0d                	je     c01010e2 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d8:	89 04 24             	mov    %eax,(%esp)
c01010db:	e8 70 ff ff ff       	call   c0101050 <lpt_putc_sub>
c01010e0:	eb 24                	jmp    c0101106 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010e2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e9:	e8 62 ff ff ff       	call   c0101050 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010ee:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010f5:	e8 56 ff ff ff       	call   c0101050 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010fa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101101:	e8 4a ff ff ff       	call   c0101050 <lpt_putc_sub>
    }
}
c0101106:	c9                   	leave  
c0101107:	c3                   	ret    

c0101108 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101108:	55                   	push   %ebp
c0101109:	89 e5                	mov    %esp,%ebp
c010110b:	53                   	push   %ebx
c010110c:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010110f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101112:	b0 00                	mov    $0x0,%al
c0101114:	85 c0                	test   %eax,%eax
c0101116:	75 07                	jne    c010111f <cga_putc+0x17>
        c |= 0x0700;
c0101118:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010111f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101122:	0f b6 c0             	movzbl %al,%eax
c0101125:	83 f8 0a             	cmp    $0xa,%eax
c0101128:	74 4c                	je     c0101176 <cga_putc+0x6e>
c010112a:	83 f8 0d             	cmp    $0xd,%eax
c010112d:	74 57                	je     c0101186 <cga_putc+0x7e>
c010112f:	83 f8 08             	cmp    $0x8,%eax
c0101132:	0f 85 88 00 00 00    	jne    c01011c0 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101138:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010113f:	66 85 c0             	test   %ax,%ax
c0101142:	74 30                	je     c0101174 <cga_putc+0x6c>
            crt_pos --;
c0101144:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010114b:	83 e8 01             	sub    $0x1,%eax
c010114e:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101154:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101159:	0f b7 15 44 a4 11 c0 	movzwl 0xc011a444,%edx
c0101160:	0f b7 d2             	movzwl %dx,%edx
c0101163:	01 d2                	add    %edx,%edx
c0101165:	01 c2                	add    %eax,%edx
c0101167:	8b 45 08             	mov    0x8(%ebp),%eax
c010116a:	b0 00                	mov    $0x0,%al
c010116c:	83 c8 20             	or     $0x20,%eax
c010116f:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101172:	eb 72                	jmp    c01011e6 <cga_putc+0xde>
c0101174:	eb 70                	jmp    c01011e6 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101176:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010117d:	83 c0 50             	add    $0x50,%eax
c0101180:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101186:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c010118d:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c0101194:	0f b7 c1             	movzwl %cx,%eax
c0101197:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010119d:	c1 e8 10             	shr    $0x10,%eax
c01011a0:	89 c2                	mov    %eax,%edx
c01011a2:	66 c1 ea 06          	shr    $0x6,%dx
c01011a6:	89 d0                	mov    %edx,%eax
c01011a8:	c1 e0 02             	shl    $0x2,%eax
c01011ab:	01 d0                	add    %edx,%eax
c01011ad:	c1 e0 04             	shl    $0x4,%eax
c01011b0:	29 c1                	sub    %eax,%ecx
c01011b2:	89 ca                	mov    %ecx,%edx
c01011b4:	89 d8                	mov    %ebx,%eax
c01011b6:	29 d0                	sub    %edx,%eax
c01011b8:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c01011be:	eb 26                	jmp    c01011e6 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011c0:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01011c6:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011cd:	8d 50 01             	lea    0x1(%eax),%edx
c01011d0:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
c01011d7:	0f b7 c0             	movzwl %ax,%eax
c01011da:	01 c0                	add    %eax,%eax
c01011dc:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011df:	8b 45 08             	mov    0x8(%ebp),%eax
c01011e2:	66 89 02             	mov    %ax,(%edx)
        break;
c01011e5:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011e6:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011ed:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011f1:	76 5b                	jbe    c010124e <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011f3:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c01011f8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011fe:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101203:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010120a:	00 
c010120b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010120f:	89 04 24             	mov    %eax,(%esp)
c0101212:	e8 f7 4b 00 00       	call   c0105e0e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101217:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010121e:	eb 15                	jmp    c0101235 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101220:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101225:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101228:	01 d2                	add    %edx,%edx
c010122a:	01 d0                	add    %edx,%eax
c010122c:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101231:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101235:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010123c:	7e e2                	jle    c0101220 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010123e:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101245:	83 e8 50             	sub    $0x50,%eax
c0101248:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010124e:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0101255:	0f b7 c0             	movzwl %ax,%eax
c0101258:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010125c:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101260:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101264:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101268:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101269:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101270:	66 c1 e8 08          	shr    $0x8,%ax
c0101274:	0f b6 c0             	movzbl %al,%eax
c0101277:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c010127e:	83 c2 01             	add    $0x1,%edx
c0101281:	0f b7 d2             	movzwl %dx,%edx
c0101284:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101288:	88 45 ed             	mov    %al,-0x13(%ebp)
c010128b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010128f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101293:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101294:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c010129b:	0f b7 c0             	movzwl %ax,%eax
c010129e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012a2:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012a6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012aa:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012ae:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012af:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01012b6:	0f b6 c0             	movzbl %al,%eax
c01012b9:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c01012c0:	83 c2 01             	add    $0x1,%edx
c01012c3:	0f b7 d2             	movzwl %dx,%edx
c01012c6:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ca:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012cd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012d1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012d5:	ee                   	out    %al,(%dx)
}
c01012d6:	83 c4 34             	add    $0x34,%esp
c01012d9:	5b                   	pop    %ebx
c01012da:	5d                   	pop    %ebp
c01012db:	c3                   	ret    

c01012dc <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012dc:	55                   	push   %ebp
c01012dd:	89 e5                	mov    %esp,%ebp
c01012df:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e9:	eb 09                	jmp    c01012f4 <serial_putc_sub+0x18>
        delay();
c01012eb:	e8 4f fb ff ff       	call   c0100e3f <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012f4:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012fa:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012fe:	89 c2                	mov    %eax,%edx
c0101300:	ec                   	in     (%dx),%al
c0101301:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101304:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101308:	0f b6 c0             	movzbl %al,%eax
c010130b:	83 e0 20             	and    $0x20,%eax
c010130e:	85 c0                	test   %eax,%eax
c0101310:	75 09                	jne    c010131b <serial_putc_sub+0x3f>
c0101312:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101319:	7e d0                	jle    c01012eb <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010131b:	8b 45 08             	mov    0x8(%ebp),%eax
c010131e:	0f b6 c0             	movzbl %al,%eax
c0101321:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101327:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010132a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010132e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101332:	ee                   	out    %al,(%dx)
}
c0101333:	c9                   	leave  
c0101334:	c3                   	ret    

c0101335 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101335:	55                   	push   %ebp
c0101336:	89 e5                	mov    %esp,%ebp
c0101338:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010133b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010133f:	74 0d                	je     c010134e <serial_putc+0x19>
        serial_putc_sub(c);
c0101341:	8b 45 08             	mov    0x8(%ebp),%eax
c0101344:	89 04 24             	mov    %eax,(%esp)
c0101347:	e8 90 ff ff ff       	call   c01012dc <serial_putc_sub>
c010134c:	eb 24                	jmp    c0101372 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010134e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101355:	e8 82 ff ff ff       	call   c01012dc <serial_putc_sub>
        serial_putc_sub(' ');
c010135a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101361:	e8 76 ff ff ff       	call   c01012dc <serial_putc_sub>
        serial_putc_sub('\b');
c0101366:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010136d:	e8 6a ff ff ff       	call   c01012dc <serial_putc_sub>
    }
}
c0101372:	c9                   	leave  
c0101373:	c3                   	ret    

c0101374 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101374:	55                   	push   %ebp
c0101375:	89 e5                	mov    %esp,%ebp
c0101377:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010137a:	eb 33                	jmp    c01013af <cons_intr+0x3b>
        if (c != 0) {
c010137c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101380:	74 2d                	je     c01013af <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101382:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101387:	8d 50 01             	lea    0x1(%eax),%edx
c010138a:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c0101390:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101393:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101399:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c010139e:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013a3:	75 0a                	jne    c01013af <cons_intr+0x3b>
                cons.wpos = 0;
c01013a5:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
c01013ac:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013af:	8b 45 08             	mov    0x8(%ebp),%eax
c01013b2:	ff d0                	call   *%eax
c01013b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013b7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013bb:	75 bf                	jne    c010137c <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013bd:	c9                   	leave  
c01013be:	c3                   	ret    

c01013bf <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013bf:	55                   	push   %ebp
c01013c0:	89 e5                	mov    %esp,%ebp
c01013c2:	83 ec 10             	sub    $0x10,%esp
c01013c5:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013cb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013cf:	89 c2                	mov    %eax,%edx
c01013d1:	ec                   	in     (%dx),%al
c01013d2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013d5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013d9:	0f b6 c0             	movzbl %al,%eax
c01013dc:	83 e0 01             	and    $0x1,%eax
c01013df:	85 c0                	test   %eax,%eax
c01013e1:	75 07                	jne    c01013ea <serial_proc_data+0x2b>
        return -1;
c01013e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013e8:	eb 2a                	jmp    c0101414 <serial_proc_data+0x55>
c01013ea:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013f0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013f4:	89 c2                	mov    %eax,%edx
c01013f6:	ec                   	in     (%dx),%al
c01013f7:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013fa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013fe:	0f b6 c0             	movzbl %al,%eax
c0101401:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101404:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101408:	75 07                	jne    c0101411 <serial_proc_data+0x52>
        c = '\b';
c010140a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101414:	c9                   	leave  
c0101415:	c3                   	ret    

c0101416 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101416:	55                   	push   %ebp
c0101417:	89 e5                	mov    %esp,%ebp
c0101419:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010141c:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101421:	85 c0                	test   %eax,%eax
c0101423:	74 0c                	je     c0101431 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101425:	c7 04 24 bf 13 10 c0 	movl   $0xc01013bf,(%esp)
c010142c:	e8 43 ff ff ff       	call   c0101374 <cons_intr>
    }
}
c0101431:	c9                   	leave  
c0101432:	c3                   	ret    

c0101433 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101433:	55                   	push   %ebp
c0101434:	89 e5                	mov    %esp,%ebp
c0101436:	83 ec 38             	sub    $0x38,%esp
c0101439:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010143f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101443:	89 c2                	mov    %eax,%edx
c0101445:	ec                   	in     (%dx),%al
c0101446:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101449:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010144d:	0f b6 c0             	movzbl %al,%eax
c0101450:	83 e0 01             	and    $0x1,%eax
c0101453:	85 c0                	test   %eax,%eax
c0101455:	75 0a                	jne    c0101461 <kbd_proc_data+0x2e>
        return -1;
c0101457:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010145c:	e9 59 01 00 00       	jmp    c01015ba <kbd_proc_data+0x187>
c0101461:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101467:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010146b:	89 c2                	mov    %eax,%edx
c010146d:	ec                   	in     (%dx),%al
c010146e:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101471:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101475:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101478:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010147c:	75 17                	jne    c0101495 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010147e:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101483:	83 c8 40             	or     $0x40,%eax
c0101486:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c010148b:	b8 00 00 00 00       	mov    $0x0,%eax
c0101490:	e9 25 01 00 00       	jmp    c01015ba <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	84 c0                	test   %al,%al
c010149b:	79 47                	jns    c01014e4 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010149d:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014a2:	83 e0 40             	and    $0x40,%eax
c01014a5:	85 c0                	test   %eax,%eax
c01014a7:	75 09                	jne    c01014b2 <kbd_proc_data+0x7f>
c01014a9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ad:	83 e0 7f             	and    $0x7f,%eax
c01014b0:	eb 04                	jmp    c01014b6 <kbd_proc_data+0x83>
c01014b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b6:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014bd:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014c4:	83 c8 40             	or     $0x40,%eax
c01014c7:	0f b6 c0             	movzbl %al,%eax
c01014ca:	f7 d0                	not    %eax
c01014cc:	89 c2                	mov    %eax,%edx
c01014ce:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014d3:	21 d0                	and    %edx,%eax
c01014d5:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014da:	b8 00 00 00 00       	mov    $0x0,%eax
c01014df:	e9 d6 00 00 00       	jmp    c01015ba <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014e4:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014e9:	83 e0 40             	and    $0x40,%eax
c01014ec:	85 c0                	test   %eax,%eax
c01014ee:	74 11                	je     c0101501 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014f0:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014f4:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014f9:	83 e0 bf             	and    $0xffffffbf,%eax
c01014fc:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c0101501:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101505:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c010150c:	0f b6 d0             	movzbl %al,%edx
c010150f:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101514:	09 d0                	or     %edx,%eax
c0101516:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c010151b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151f:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c0101526:	0f b6 d0             	movzbl %al,%edx
c0101529:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010152e:	31 d0                	xor    %edx,%eax
c0101530:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101535:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010153a:	83 e0 03             	and    $0x3,%eax
c010153d:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c0101544:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101548:	01 d0                	add    %edx,%eax
c010154a:	0f b6 00             	movzbl (%eax),%eax
c010154d:	0f b6 c0             	movzbl %al,%eax
c0101550:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101553:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101558:	83 e0 08             	and    $0x8,%eax
c010155b:	85 c0                	test   %eax,%eax
c010155d:	74 22                	je     c0101581 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010155f:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101563:	7e 0c                	jle    c0101571 <kbd_proc_data+0x13e>
c0101565:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101569:	7f 06                	jg     c0101571 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010156b:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010156f:	eb 10                	jmp    c0101581 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101571:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101575:	7e 0a                	jle    c0101581 <kbd_proc_data+0x14e>
c0101577:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010157b:	7f 04                	jg     c0101581 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010157d:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101581:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101586:	f7 d0                	not    %eax
c0101588:	83 e0 06             	and    $0x6,%eax
c010158b:	85 c0                	test   %eax,%eax
c010158d:	75 28                	jne    c01015b7 <kbd_proc_data+0x184>
c010158f:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101596:	75 1f                	jne    c01015b7 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101598:	c7 04 24 8f 62 10 c0 	movl   $0xc010628f,(%esp)
c010159f:	e8 a4 ed ff ff       	call   c0100348 <cprintf>
c01015a4:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015aa:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015ae:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015b2:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015b6:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ba:	c9                   	leave  
c01015bb:	c3                   	ret    

c01015bc <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015bc:	55                   	push   %ebp
c01015bd:	89 e5                	mov    %esp,%ebp
c01015bf:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015c2:	c7 04 24 33 14 10 c0 	movl   $0xc0101433,(%esp)
c01015c9:	e8 a6 fd ff ff       	call   c0101374 <cons_intr>
}
c01015ce:	c9                   	leave  
c01015cf:	c3                   	ret    

c01015d0 <kbd_init>:

static void
kbd_init(void) {
c01015d0:	55                   	push   %ebp
c01015d1:	89 e5                	mov    %esp,%ebp
c01015d3:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015d6:	e8 e1 ff ff ff       	call   c01015bc <kbd_intr>
    pic_enable(IRQ_KBD);
c01015db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015e2:	e8 3d 01 00 00       	call   c0101724 <pic_enable>
}
c01015e7:	c9                   	leave  
c01015e8:	c3                   	ret    

c01015e9 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e9:	55                   	push   %ebp
c01015ea:	89 e5                	mov    %esp,%ebp
c01015ec:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015ef:	e8 93 f8 ff ff       	call   c0100e87 <cga_init>
    serial_init();
c01015f4:	e8 74 f9 ff ff       	call   c0100f6d <serial_init>
    kbd_init();
c01015f9:	e8 d2 ff ff ff       	call   c01015d0 <kbd_init>
    if (!serial_exists) {
c01015fe:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101603:	85 c0                	test   %eax,%eax
c0101605:	75 0c                	jne    c0101613 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101607:	c7 04 24 9b 62 10 c0 	movl   $0xc010629b,(%esp)
c010160e:	e8 35 ed ff ff       	call   c0100348 <cprintf>
    }
}
c0101613:	c9                   	leave  
c0101614:	c3                   	ret    

c0101615 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101615:	55                   	push   %ebp
c0101616:	89 e5                	mov    %esp,%ebp
c0101618:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010161b:	e8 e2 f7 ff ff       	call   c0100e02 <__intr_save>
c0101620:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101623:	8b 45 08             	mov    0x8(%ebp),%eax
c0101626:	89 04 24             	mov    %eax,(%esp)
c0101629:	e8 9b fa ff ff       	call   c01010c9 <lpt_putc>
        cga_putc(c);
c010162e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101631:	89 04 24             	mov    %eax,(%esp)
c0101634:	e8 cf fa ff ff       	call   c0101108 <cga_putc>
        serial_putc(c);
c0101639:	8b 45 08             	mov    0x8(%ebp),%eax
c010163c:	89 04 24             	mov    %eax,(%esp)
c010163f:	e8 f1 fc ff ff       	call   c0101335 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101644:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101647:	89 04 24             	mov    %eax,(%esp)
c010164a:	e8 dd f7 ff ff       	call   c0100e2c <__intr_restore>
}
c010164f:	c9                   	leave  
c0101650:	c3                   	ret    

c0101651 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101651:	55                   	push   %ebp
c0101652:	89 e5                	mov    %esp,%ebp
c0101654:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101657:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010165e:	e8 9f f7 ff ff       	call   c0100e02 <__intr_save>
c0101663:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101666:	e8 ab fd ff ff       	call   c0101416 <serial_intr>
        kbd_intr();
c010166b:	e8 4c ff ff ff       	call   c01015bc <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101670:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c0101676:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c010167b:	39 c2                	cmp    %eax,%edx
c010167d:	74 31                	je     c01016b0 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010167f:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c0101684:	8d 50 01             	lea    0x1(%eax),%edx
c0101687:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c010168d:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c0101694:	0f b6 c0             	movzbl %al,%eax
c0101697:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010169a:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c010169f:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016a4:	75 0a                	jne    c01016b0 <cons_getc+0x5f>
                cons.rpos = 0;
c01016a6:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
c01016ad:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016b3:	89 04 24             	mov    %eax,(%esp)
c01016b6:	e8 71 f7 ff ff       	call   c0100e2c <__intr_restore>
    return c;
c01016bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016be:	c9                   	leave  
c01016bf:	c3                   	ret    

c01016c0 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016c0:	55                   	push   %ebp
c01016c1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016c3:	fb                   	sti    
    sti();
}
c01016c4:	5d                   	pop    %ebp
c01016c5:	c3                   	ret    

c01016c6 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016c6:	55                   	push   %ebp
c01016c7:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016c9:	fa                   	cli    
    cli();
}
c01016ca:	5d                   	pop    %ebp
c01016cb:	c3                   	ret    

c01016cc <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016cc:	55                   	push   %ebp
c01016cd:	89 e5                	mov    %esp,%ebp
c01016cf:	83 ec 14             	sub    $0x14,%esp
c01016d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01016d5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016d9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016dd:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c01016e3:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
c01016e8:	85 c0                	test   %eax,%eax
c01016ea:	74 36                	je     c0101722 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016ec:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f0:	0f b6 c0             	movzbl %al,%eax
c01016f3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016f9:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016fc:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101700:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101704:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101705:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101709:	66 c1 e8 08          	shr    $0x8,%ax
c010170d:	0f b6 c0             	movzbl %al,%eax
c0101710:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101716:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101719:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010171d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101721:	ee                   	out    %al,(%dx)
    }
}
c0101722:	c9                   	leave  
c0101723:	c3                   	ret    

c0101724 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101724:	55                   	push   %ebp
c0101725:	89 e5                	mov    %esp,%ebp
c0101727:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010172a:	8b 45 08             	mov    0x8(%ebp),%eax
c010172d:	ba 01 00 00 00       	mov    $0x1,%edx
c0101732:	89 c1                	mov    %eax,%ecx
c0101734:	d3 e2                	shl    %cl,%edx
c0101736:	89 d0                	mov    %edx,%eax
c0101738:	f7 d0                	not    %eax
c010173a:	89 c2                	mov    %eax,%edx
c010173c:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101743:	21 d0                	and    %edx,%eax
c0101745:	0f b7 c0             	movzwl %ax,%eax
c0101748:	89 04 24             	mov    %eax,(%esp)
c010174b:	e8 7c ff ff ff       	call   c01016cc <pic_setmask>
}
c0101750:	c9                   	leave  
c0101751:	c3                   	ret    

c0101752 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101752:	55                   	push   %ebp
c0101753:	89 e5                	mov    %esp,%ebp
c0101755:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101758:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
c010175f:	00 00 00 
c0101762:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101768:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010176c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101770:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101774:	ee                   	out    %al,(%dx)
c0101775:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010177b:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c010177f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101783:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101787:	ee                   	out    %al,(%dx)
c0101788:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010178e:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101792:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101796:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010179a:	ee                   	out    %al,(%dx)
c010179b:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01017a1:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01017a5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01017a9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017ad:	ee                   	out    %al,(%dx)
c01017ae:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017b4:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017b8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017bc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017c0:	ee                   	out    %al,(%dx)
c01017c1:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017c7:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017cb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017cf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017d3:	ee                   	out    %al,(%dx)
c01017d4:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017da:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017de:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017e2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017e6:	ee                   	out    %al,(%dx)
c01017e7:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017ed:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017f1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017f5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017f9:	ee                   	out    %al,(%dx)
c01017fa:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0101800:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0101804:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101808:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010180c:	ee                   	out    %al,(%dx)
c010180d:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101813:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101817:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010181b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010181f:	ee                   	out    %al,(%dx)
c0101820:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101826:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010182a:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010182e:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101832:	ee                   	out    %al,(%dx)
c0101833:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101839:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010183d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101841:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101845:	ee                   	out    %al,(%dx)
c0101846:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010184c:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101850:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101854:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101858:	ee                   	out    %al,(%dx)
c0101859:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010185f:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101863:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101867:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010186b:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010186c:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101873:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101877:	74 12                	je     c010188b <pic_init+0x139>
        pic_setmask(irq_mask);
c0101879:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101880:	0f b7 c0             	movzwl %ax,%eax
c0101883:	89 04 24             	mov    %eax,(%esp)
c0101886:	e8 41 fe ff ff       	call   c01016cc <pic_setmask>
    }
}
c010188b:	c9                   	leave  
c010188c:	c3                   	ret    

c010188d <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010188d:	55                   	push   %ebp
c010188e:	89 e5                	mov    %esp,%ebp
c0101890:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101893:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010189a:	00 
c010189b:	c7 04 24 c0 62 10 c0 	movl   $0xc01062c0,(%esp)
c01018a2:	e8 a1 ea ff ff       	call   c0100348 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01018a7:	c9                   	leave  
c01018a8:	c3                   	ret    

c01018a9 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018a9:	55                   	push   %ebp
c01018aa:	89 e5                	mov    %esp,%ebp
c01018ac:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018b6:	e9 c3 00 00 00       	jmp    c010197e <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018be:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01018c5:	89 c2                	mov    %eax,%edx
c01018c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ca:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c01018d1:	c0 
c01018d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d5:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c01018dc:	c0 08 00 
c01018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e2:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c01018e9:	c0 
c01018ea:	83 e2 e0             	and    $0xffffffe0,%edx
c01018ed:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c01018f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f7:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c01018fe:	c0 
c01018ff:	83 e2 1f             	and    $0x1f,%edx
c0101902:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101909:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010190c:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101913:	c0 
c0101914:	83 e2 f0             	and    $0xfffffff0,%edx
c0101917:	83 ca 0e             	or     $0xe,%edx
c010191a:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101921:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101924:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010192b:	c0 
c010192c:	83 e2 ef             	and    $0xffffffef,%edx
c010192f:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101936:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101939:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101940:	c0 
c0101941:	83 e2 9f             	and    $0xffffff9f,%edx
c0101944:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010194b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194e:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101955:	c0 
c0101956:	83 ca 80             	or     $0xffffff80,%edx
c0101959:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101960:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101963:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c010196a:	c1 e8 10             	shr    $0x10,%eax
c010196d:	89 c2                	mov    %eax,%edx
c010196f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101972:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c0101979:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010197a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010197e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101981:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101986:	0f 86 2f ff ff ff    	jbe    c01018bb <idt_init+0x12>
c010198c:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101993:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101996:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
c0101999:	c9                   	leave  
c010199a:	c3                   	ret    

c010199b <trapname>:

static const char *
trapname(int trapno) {
c010199b:	55                   	push   %ebp
c010199c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c010199e:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a1:	83 f8 13             	cmp    $0x13,%eax
c01019a4:	77 0c                	ja     c01019b2 <trapname+0x17>
        return excnames[trapno];
c01019a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a9:	8b 04 85 20 66 10 c0 	mov    -0x3fef99e0(,%eax,4),%eax
c01019b0:	eb 18                	jmp    c01019ca <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019b2:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019b6:	7e 0d                	jle    c01019c5 <trapname+0x2a>
c01019b8:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019bc:	7f 07                	jg     c01019c5 <trapname+0x2a>
        return "Hardware Interrupt";
c01019be:	b8 ca 62 10 c0       	mov    $0xc01062ca,%eax
c01019c3:	eb 05                	jmp    c01019ca <trapname+0x2f>
    }
    return "(unknown trap)";
c01019c5:	b8 dd 62 10 c0       	mov    $0xc01062dd,%eax
}
c01019ca:	5d                   	pop    %ebp
c01019cb:	c3                   	ret    

c01019cc <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019cc:	55                   	push   %ebp
c01019cd:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01019d2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019d6:	66 83 f8 08          	cmp    $0x8,%ax
c01019da:	0f 94 c0             	sete   %al
c01019dd:	0f b6 c0             	movzbl %al,%eax
}
c01019e0:	5d                   	pop    %ebp
c01019e1:	c3                   	ret    

c01019e2 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01019e2:	55                   	push   %ebp
c01019e3:	89 e5                	mov    %esp,%ebp
c01019e5:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01019e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01019eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019ef:	c7 04 24 1e 63 10 c0 	movl   $0xc010631e,(%esp)
c01019f6:	e8 4d e9 ff ff       	call   c0100348 <cprintf>
    print_regs(&tf->tf_regs);
c01019fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01019fe:	89 04 24             	mov    %eax,(%esp)
c0101a01:	e8 a1 01 00 00       	call   c0101ba7 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a09:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a0d:	0f b7 c0             	movzwl %ax,%eax
c0101a10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a14:	c7 04 24 2f 63 10 c0 	movl   $0xc010632f,(%esp)
c0101a1b:	e8 28 e9 ff ff       	call   c0100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a20:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a23:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a27:	0f b7 c0             	movzwl %ax,%eax
c0101a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a2e:	c7 04 24 42 63 10 c0 	movl   $0xc0106342,(%esp)
c0101a35:	e8 0e e9 ff ff       	call   c0100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a3d:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a41:	0f b7 c0             	movzwl %ax,%eax
c0101a44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a48:	c7 04 24 55 63 10 c0 	movl   $0xc0106355,(%esp)
c0101a4f:	e8 f4 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a57:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a5b:	0f b7 c0             	movzwl %ax,%eax
c0101a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a62:	c7 04 24 68 63 10 c0 	movl   $0xc0106368,(%esp)
c0101a69:	e8 da e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a71:	8b 40 30             	mov    0x30(%eax),%eax
c0101a74:	89 04 24             	mov    %eax,(%esp)
c0101a77:	e8 1f ff ff ff       	call   c010199b <trapname>
c0101a7c:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a7f:	8b 52 30             	mov    0x30(%edx),%edx
c0101a82:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101a86:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a8a:	c7 04 24 7b 63 10 c0 	movl   $0xc010637b,(%esp)
c0101a91:	e8 b2 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a99:	8b 40 34             	mov    0x34(%eax),%eax
c0101a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa0:	c7 04 24 8d 63 10 c0 	movl   $0xc010638d,(%esp)
c0101aa7:	e8 9c e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101aac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aaf:	8b 40 38             	mov    0x38(%eax),%eax
c0101ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab6:	c7 04 24 9c 63 10 c0 	movl   $0xc010639c,(%esp)
c0101abd:	e8 86 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ac9:	0f b7 c0             	movzwl %ax,%eax
c0101acc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad0:	c7 04 24 ab 63 10 c0 	movl   $0xc01063ab,(%esp)
c0101ad7:	e8 6c e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101adc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101adf:	8b 40 40             	mov    0x40(%eax),%eax
c0101ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae6:	c7 04 24 be 63 10 c0 	movl   $0xc01063be,(%esp)
c0101aed:	e8 56 e8 ff ff       	call   c0100348 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101af2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101af9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b00:	eb 3e                	jmp    c0101b40 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b05:	8b 50 40             	mov    0x40(%eax),%edx
c0101b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b0b:	21 d0                	and    %edx,%eax
c0101b0d:	85 c0                	test   %eax,%eax
c0101b0f:	74 28                	je     c0101b39 <print_trapframe+0x157>
c0101b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b14:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101b1b:	85 c0                	test   %eax,%eax
c0101b1d:	74 1a                	je     c0101b39 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b22:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101b29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b2d:	c7 04 24 cd 63 10 c0 	movl   $0xc01063cd,(%esp)
c0101b34:	e8 0f e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b3d:	d1 65 f0             	shll   -0x10(%ebp)
c0101b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b43:	83 f8 17             	cmp    $0x17,%eax
c0101b46:	76 ba                	jbe    c0101b02 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4b:	8b 40 40             	mov    0x40(%eax),%eax
c0101b4e:	25 00 30 00 00       	and    $0x3000,%eax
c0101b53:	c1 e8 0c             	shr    $0xc,%eax
c0101b56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5a:	c7 04 24 d1 63 10 c0 	movl   $0xc01063d1,(%esp)
c0101b61:	e8 e2 e7 ff ff       	call   c0100348 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b69:	89 04 24             	mov    %eax,(%esp)
c0101b6c:	e8 5b fe ff ff       	call   c01019cc <trap_in_kernel>
c0101b71:	85 c0                	test   %eax,%eax
c0101b73:	75 30                	jne    c0101ba5 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b78:	8b 40 44             	mov    0x44(%eax),%eax
c0101b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b7f:	c7 04 24 da 63 10 c0 	movl   $0xc01063da,(%esp)
c0101b86:	e8 bd e7 ff ff       	call   c0100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101b92:	0f b7 c0             	movzwl %ax,%eax
c0101b95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b99:	c7 04 24 e9 63 10 c0 	movl   $0xc01063e9,(%esp)
c0101ba0:	e8 a3 e7 ff ff       	call   c0100348 <cprintf>
    }
}
c0101ba5:	c9                   	leave  
c0101ba6:	c3                   	ret    

c0101ba7 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101ba7:	55                   	push   %ebp
c0101ba8:	89 e5                	mov    %esp,%ebp
c0101baa:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb0:	8b 00                	mov    (%eax),%eax
c0101bb2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bb6:	c7 04 24 fc 63 10 c0 	movl   $0xc01063fc,(%esp)
c0101bbd:	e8 86 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc5:	8b 40 04             	mov    0x4(%eax),%eax
c0101bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bcc:	c7 04 24 0b 64 10 c0 	movl   $0xc010640b,(%esp)
c0101bd3:	e8 70 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101bd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bdb:	8b 40 08             	mov    0x8(%eax),%eax
c0101bde:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be2:	c7 04 24 1a 64 10 c0 	movl   $0xc010641a,(%esp)
c0101be9:	e8 5a e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101bee:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf1:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf8:	c7 04 24 29 64 10 c0 	movl   $0xc0106429,(%esp)
c0101bff:	e8 44 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c07:	8b 40 10             	mov    0x10(%eax),%eax
c0101c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0e:	c7 04 24 38 64 10 c0 	movl   $0xc0106438,(%esp)
c0101c15:	e8 2e e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1d:	8b 40 14             	mov    0x14(%eax),%eax
c0101c20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c24:	c7 04 24 47 64 10 c0 	movl   $0xc0106447,(%esp)
c0101c2b:	e8 18 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c33:	8b 40 18             	mov    0x18(%eax),%eax
c0101c36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3a:	c7 04 24 56 64 10 c0 	movl   $0xc0106456,(%esp)
c0101c41:	e8 02 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c46:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c49:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c50:	c7 04 24 65 64 10 c0 	movl   $0xc0106465,(%esp)
c0101c57:	e8 ec e6 ff ff       	call   c0100348 <cprintf>
}
c0101c5c:	c9                   	leave  
c0101c5d:	c3                   	ret    

c0101c5e <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c5e:	55                   	push   %ebp
c0101c5f:	89 e5                	mov    %esp,%ebp
c0101c61:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c67:	8b 40 30             	mov    0x30(%eax),%eax
c0101c6a:	83 f8 2f             	cmp    $0x2f,%eax
c0101c6d:	77 21                	ja     c0101c90 <trap_dispatch+0x32>
c0101c6f:	83 f8 2e             	cmp    $0x2e,%eax
c0101c72:	0f 83 04 01 00 00    	jae    c0101d7c <trap_dispatch+0x11e>
c0101c78:	83 f8 21             	cmp    $0x21,%eax
c0101c7b:	0f 84 81 00 00 00    	je     c0101d02 <trap_dispatch+0xa4>
c0101c81:	83 f8 24             	cmp    $0x24,%eax
c0101c84:	74 56                	je     c0101cdc <trap_dispatch+0x7e>
c0101c86:	83 f8 20             	cmp    $0x20,%eax
c0101c89:	74 16                	je     c0101ca1 <trap_dispatch+0x43>
c0101c8b:	e9 b4 00 00 00       	jmp    c0101d44 <trap_dispatch+0xe6>
c0101c90:	83 e8 78             	sub    $0x78,%eax
c0101c93:	83 f8 01             	cmp    $0x1,%eax
c0101c96:	0f 87 a8 00 00 00    	ja     c0101d44 <trap_dispatch+0xe6>
c0101c9c:	e9 87 00 00 00       	jmp    c0101d28 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101ca1:	a1 0c af 11 c0       	mov    0xc011af0c,%eax
c0101ca6:	83 c0 01             	add    $0x1,%eax
c0101ca9:	a3 0c af 11 c0       	mov    %eax,0xc011af0c
        if (ticks % TICK_NUM == 0) {
c0101cae:	8b 0d 0c af 11 c0    	mov    0xc011af0c,%ecx
c0101cb4:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101cb9:	89 c8                	mov    %ecx,%eax
c0101cbb:	f7 e2                	mul    %edx
c0101cbd:	89 d0                	mov    %edx,%eax
c0101cbf:	c1 e8 05             	shr    $0x5,%eax
c0101cc2:	6b c0 64             	imul   $0x64,%eax,%eax
c0101cc5:	29 c1                	sub    %eax,%ecx
c0101cc7:	89 c8                	mov    %ecx,%eax
c0101cc9:	85 c0                	test   %eax,%eax
c0101ccb:	75 0a                	jne    c0101cd7 <trap_dispatch+0x79>
            print_ticks();
c0101ccd:	e8 bb fb ff ff       	call   c010188d <print_ticks>
        }
        break;
c0101cd2:	e9 a6 00 00 00       	jmp    c0101d7d <trap_dispatch+0x11f>
c0101cd7:	e9 a1 00 00 00       	jmp    c0101d7d <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101cdc:	e8 70 f9 ff ff       	call   c0101651 <cons_getc>
c0101ce1:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ce4:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101ce8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101cec:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cf0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf4:	c7 04 24 74 64 10 c0 	movl   $0xc0106474,(%esp)
c0101cfb:	e8 48 e6 ff ff       	call   c0100348 <cprintf>
        break;
c0101d00:	eb 7b                	jmp    c0101d7d <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d02:	e8 4a f9 ff ff       	call   c0101651 <cons_getc>
c0101d07:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d0a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d0e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d12:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d16:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d1a:	c7 04 24 86 64 10 c0 	movl   $0xc0106486,(%esp)
c0101d21:	e8 22 e6 ff ff       	call   c0100348 <cprintf>
        break;
c0101d26:	eb 55                	jmp    c0101d7d <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d28:	c7 44 24 08 95 64 10 	movl   $0xc0106495,0x8(%esp)
c0101d2f:	c0 
c0101d30:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0101d37:	00 
c0101d38:	c7 04 24 a5 64 10 c0 	movl   $0xc01064a5,(%esp)
c0101d3f:	e8 8e ef ff ff       	call   c0100cd2 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d44:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d47:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d4b:	0f b7 c0             	movzwl %ax,%eax
c0101d4e:	83 e0 03             	and    $0x3,%eax
c0101d51:	85 c0                	test   %eax,%eax
c0101d53:	75 28                	jne    c0101d7d <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101d55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d58:	89 04 24             	mov    %eax,(%esp)
c0101d5b:	e8 82 fc ff ff       	call   c01019e2 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101d60:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0101d67:	c0 
c0101d68:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0101d6f:	00 
c0101d70:	c7 04 24 a5 64 10 c0 	movl   $0xc01064a5,(%esp)
c0101d77:	e8 56 ef ff ff       	call   c0100cd2 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101d7c:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101d7d:	c9                   	leave  
c0101d7e:	c3                   	ret    

c0101d7f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101d7f:	55                   	push   %ebp
c0101d80:	89 e5                	mov    %esp,%ebp
c0101d82:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101d85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d88:	89 04 24             	mov    %eax,(%esp)
c0101d8b:	e8 ce fe ff ff       	call   c0101c5e <trap_dispatch>
}
c0101d90:	c9                   	leave  
c0101d91:	c3                   	ret    

c0101d92 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101d92:	1e                   	push   %ds
    pushl %es
c0101d93:	06                   	push   %es
    pushl %fs
c0101d94:	0f a0                	push   %fs
    pushl %gs
c0101d96:	0f a8                	push   %gs
    pushal
c0101d98:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101d99:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101d9e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101da0:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101da2:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101da3:	e8 d7 ff ff ff       	call   c0101d7f <trap>

    # pop the pushed stack pointer
    popl %esp
c0101da8:	5c                   	pop    %esp

c0101da9 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101da9:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101daa:	0f a9                	pop    %gs
    popl %fs
c0101dac:	0f a1                	pop    %fs
    popl %es
c0101dae:	07                   	pop    %es
    popl %ds
c0101daf:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101db0:	83 c4 08             	add    $0x8,%esp
    iret
c0101db3:	cf                   	iret   

c0101db4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101db4:	6a 00                	push   $0x0
  pushl $0
c0101db6:	6a 00                	push   $0x0
  jmp __alltraps
c0101db8:	e9 d5 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101dbd <vector1>:
.globl vector1
vector1:
  pushl $0
c0101dbd:	6a 00                	push   $0x0
  pushl $1
c0101dbf:	6a 01                	push   $0x1
  jmp __alltraps
c0101dc1:	e9 cc ff ff ff       	jmp    c0101d92 <__alltraps>

c0101dc6 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101dc6:	6a 00                	push   $0x0
  pushl $2
c0101dc8:	6a 02                	push   $0x2
  jmp __alltraps
c0101dca:	e9 c3 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101dcf <vector3>:
.globl vector3
vector3:
  pushl $0
c0101dcf:	6a 00                	push   $0x0
  pushl $3
c0101dd1:	6a 03                	push   $0x3
  jmp __alltraps
c0101dd3:	e9 ba ff ff ff       	jmp    c0101d92 <__alltraps>

c0101dd8 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101dd8:	6a 00                	push   $0x0
  pushl $4
c0101dda:	6a 04                	push   $0x4
  jmp __alltraps
c0101ddc:	e9 b1 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101de1 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101de1:	6a 00                	push   $0x0
  pushl $5
c0101de3:	6a 05                	push   $0x5
  jmp __alltraps
c0101de5:	e9 a8 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101dea <vector6>:
.globl vector6
vector6:
  pushl $0
c0101dea:	6a 00                	push   $0x0
  pushl $6
c0101dec:	6a 06                	push   $0x6
  jmp __alltraps
c0101dee:	e9 9f ff ff ff       	jmp    c0101d92 <__alltraps>

c0101df3 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101df3:	6a 00                	push   $0x0
  pushl $7
c0101df5:	6a 07                	push   $0x7
  jmp __alltraps
c0101df7:	e9 96 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101dfc <vector8>:
.globl vector8
vector8:
  pushl $8
c0101dfc:	6a 08                	push   $0x8
  jmp __alltraps
c0101dfe:	e9 8f ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e03 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e03:	6a 09                	push   $0x9
  jmp __alltraps
c0101e05:	e9 88 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e0a <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e0a:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e0c:	e9 81 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e11 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e11:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e13:	e9 7a ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e18 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e18:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e1a:	e9 73 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e1f <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e1f:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e21:	e9 6c ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e26 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e26:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e28:	e9 65 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e2d <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e2d:	6a 00                	push   $0x0
  pushl $15
c0101e2f:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e31:	e9 5c ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e36 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e36:	6a 00                	push   $0x0
  pushl $16
c0101e38:	6a 10                	push   $0x10
  jmp __alltraps
c0101e3a:	e9 53 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e3f <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e3f:	6a 11                	push   $0x11
  jmp __alltraps
c0101e41:	e9 4c ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e46 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e46:	6a 00                	push   $0x0
  pushl $18
c0101e48:	6a 12                	push   $0x12
  jmp __alltraps
c0101e4a:	e9 43 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e4f <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e4f:	6a 00                	push   $0x0
  pushl $19
c0101e51:	6a 13                	push   $0x13
  jmp __alltraps
c0101e53:	e9 3a ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e58 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e58:	6a 00                	push   $0x0
  pushl $20
c0101e5a:	6a 14                	push   $0x14
  jmp __alltraps
c0101e5c:	e9 31 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e61 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e61:	6a 00                	push   $0x0
  pushl $21
c0101e63:	6a 15                	push   $0x15
  jmp __alltraps
c0101e65:	e9 28 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e6a <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e6a:	6a 00                	push   $0x0
  pushl $22
c0101e6c:	6a 16                	push   $0x16
  jmp __alltraps
c0101e6e:	e9 1f ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e73 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e73:	6a 00                	push   $0x0
  pushl $23
c0101e75:	6a 17                	push   $0x17
  jmp __alltraps
c0101e77:	e9 16 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e7c <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e7c:	6a 00                	push   $0x0
  pushl $24
c0101e7e:	6a 18                	push   $0x18
  jmp __alltraps
c0101e80:	e9 0d ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e85 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e85:	6a 00                	push   $0x0
  pushl $25
c0101e87:	6a 19                	push   $0x19
  jmp __alltraps
c0101e89:	e9 04 ff ff ff       	jmp    c0101d92 <__alltraps>

c0101e8e <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e8e:	6a 00                	push   $0x0
  pushl $26
c0101e90:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101e92:	e9 fb fe ff ff       	jmp    c0101d92 <__alltraps>

c0101e97 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101e97:	6a 00                	push   $0x0
  pushl $27
c0101e99:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101e9b:	e9 f2 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101ea0 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101ea0:	6a 00                	push   $0x0
  pushl $28
c0101ea2:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101ea4:	e9 e9 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101ea9 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101ea9:	6a 00                	push   $0x0
  pushl $29
c0101eab:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101ead:	e9 e0 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101eb2 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101eb2:	6a 00                	push   $0x0
  pushl $30
c0101eb4:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101eb6:	e9 d7 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101ebb <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ebb:	6a 00                	push   $0x0
  pushl $31
c0101ebd:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ebf:	e9 ce fe ff ff       	jmp    c0101d92 <__alltraps>

c0101ec4 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ec4:	6a 00                	push   $0x0
  pushl $32
c0101ec6:	6a 20                	push   $0x20
  jmp __alltraps
c0101ec8:	e9 c5 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101ecd <vector33>:
.globl vector33
vector33:
  pushl $0
c0101ecd:	6a 00                	push   $0x0
  pushl $33
c0101ecf:	6a 21                	push   $0x21
  jmp __alltraps
c0101ed1:	e9 bc fe ff ff       	jmp    c0101d92 <__alltraps>

c0101ed6 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101ed6:	6a 00                	push   $0x0
  pushl $34
c0101ed8:	6a 22                	push   $0x22
  jmp __alltraps
c0101eda:	e9 b3 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101edf <vector35>:
.globl vector35
vector35:
  pushl $0
c0101edf:	6a 00                	push   $0x0
  pushl $35
c0101ee1:	6a 23                	push   $0x23
  jmp __alltraps
c0101ee3:	e9 aa fe ff ff       	jmp    c0101d92 <__alltraps>

c0101ee8 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ee8:	6a 00                	push   $0x0
  pushl $36
c0101eea:	6a 24                	push   $0x24
  jmp __alltraps
c0101eec:	e9 a1 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101ef1 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101ef1:	6a 00                	push   $0x0
  pushl $37
c0101ef3:	6a 25                	push   $0x25
  jmp __alltraps
c0101ef5:	e9 98 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101efa <vector38>:
.globl vector38
vector38:
  pushl $0
c0101efa:	6a 00                	push   $0x0
  pushl $38
c0101efc:	6a 26                	push   $0x26
  jmp __alltraps
c0101efe:	e9 8f fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f03 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f03:	6a 00                	push   $0x0
  pushl $39
c0101f05:	6a 27                	push   $0x27
  jmp __alltraps
c0101f07:	e9 86 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f0c <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f0c:	6a 00                	push   $0x0
  pushl $40
c0101f0e:	6a 28                	push   $0x28
  jmp __alltraps
c0101f10:	e9 7d fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f15 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f15:	6a 00                	push   $0x0
  pushl $41
c0101f17:	6a 29                	push   $0x29
  jmp __alltraps
c0101f19:	e9 74 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f1e <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f1e:	6a 00                	push   $0x0
  pushl $42
c0101f20:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f22:	e9 6b fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f27 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f27:	6a 00                	push   $0x0
  pushl $43
c0101f29:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f2b:	e9 62 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f30 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f30:	6a 00                	push   $0x0
  pushl $44
c0101f32:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f34:	e9 59 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f39 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f39:	6a 00                	push   $0x0
  pushl $45
c0101f3b:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f3d:	e9 50 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f42 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f42:	6a 00                	push   $0x0
  pushl $46
c0101f44:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f46:	e9 47 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f4b <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f4b:	6a 00                	push   $0x0
  pushl $47
c0101f4d:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f4f:	e9 3e fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f54 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f54:	6a 00                	push   $0x0
  pushl $48
c0101f56:	6a 30                	push   $0x30
  jmp __alltraps
c0101f58:	e9 35 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f5d <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f5d:	6a 00                	push   $0x0
  pushl $49
c0101f5f:	6a 31                	push   $0x31
  jmp __alltraps
c0101f61:	e9 2c fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f66 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f66:	6a 00                	push   $0x0
  pushl $50
c0101f68:	6a 32                	push   $0x32
  jmp __alltraps
c0101f6a:	e9 23 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f6f <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f6f:	6a 00                	push   $0x0
  pushl $51
c0101f71:	6a 33                	push   $0x33
  jmp __alltraps
c0101f73:	e9 1a fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f78 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f78:	6a 00                	push   $0x0
  pushl $52
c0101f7a:	6a 34                	push   $0x34
  jmp __alltraps
c0101f7c:	e9 11 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f81 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f81:	6a 00                	push   $0x0
  pushl $53
c0101f83:	6a 35                	push   $0x35
  jmp __alltraps
c0101f85:	e9 08 fe ff ff       	jmp    c0101d92 <__alltraps>

c0101f8a <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f8a:	6a 00                	push   $0x0
  pushl $54
c0101f8c:	6a 36                	push   $0x36
  jmp __alltraps
c0101f8e:	e9 ff fd ff ff       	jmp    c0101d92 <__alltraps>

c0101f93 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101f93:	6a 00                	push   $0x0
  pushl $55
c0101f95:	6a 37                	push   $0x37
  jmp __alltraps
c0101f97:	e9 f6 fd ff ff       	jmp    c0101d92 <__alltraps>

c0101f9c <vector56>:
.globl vector56
vector56:
  pushl $0
c0101f9c:	6a 00                	push   $0x0
  pushl $56
c0101f9e:	6a 38                	push   $0x38
  jmp __alltraps
c0101fa0:	e9 ed fd ff ff       	jmp    c0101d92 <__alltraps>

c0101fa5 <vector57>:
.globl vector57
vector57:
  pushl $0
c0101fa5:	6a 00                	push   $0x0
  pushl $57
c0101fa7:	6a 39                	push   $0x39
  jmp __alltraps
c0101fa9:	e9 e4 fd ff ff       	jmp    c0101d92 <__alltraps>

c0101fae <vector58>:
.globl vector58
vector58:
  pushl $0
c0101fae:	6a 00                	push   $0x0
  pushl $58
c0101fb0:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101fb2:	e9 db fd ff ff       	jmp    c0101d92 <__alltraps>

c0101fb7 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101fb7:	6a 00                	push   $0x0
  pushl $59
c0101fb9:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fbb:	e9 d2 fd ff ff       	jmp    c0101d92 <__alltraps>

c0101fc0 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fc0:	6a 00                	push   $0x0
  pushl $60
c0101fc2:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fc4:	e9 c9 fd ff ff       	jmp    c0101d92 <__alltraps>

c0101fc9 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fc9:	6a 00                	push   $0x0
  pushl $61
c0101fcb:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fcd:	e9 c0 fd ff ff       	jmp    c0101d92 <__alltraps>

c0101fd2 <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fd2:	6a 00                	push   $0x0
  pushl $62
c0101fd4:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fd6:	e9 b7 fd ff ff       	jmp    c0101d92 <__alltraps>

c0101fdb <vector63>:
.globl vector63
vector63:
  pushl $0
c0101fdb:	6a 00                	push   $0x0
  pushl $63
c0101fdd:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fdf:	e9 ae fd ff ff       	jmp    c0101d92 <__alltraps>

c0101fe4 <vector64>:
.globl vector64
vector64:
  pushl $0
c0101fe4:	6a 00                	push   $0x0
  pushl $64
c0101fe6:	6a 40                	push   $0x40
  jmp __alltraps
c0101fe8:	e9 a5 fd ff ff       	jmp    c0101d92 <__alltraps>

c0101fed <vector65>:
.globl vector65
vector65:
  pushl $0
c0101fed:	6a 00                	push   $0x0
  pushl $65
c0101fef:	6a 41                	push   $0x41
  jmp __alltraps
c0101ff1:	e9 9c fd ff ff       	jmp    c0101d92 <__alltraps>

c0101ff6 <vector66>:
.globl vector66
vector66:
  pushl $0
c0101ff6:	6a 00                	push   $0x0
  pushl $66
c0101ff8:	6a 42                	push   $0x42
  jmp __alltraps
c0101ffa:	e9 93 fd ff ff       	jmp    c0101d92 <__alltraps>

c0101fff <vector67>:
.globl vector67
vector67:
  pushl $0
c0101fff:	6a 00                	push   $0x0
  pushl $67
c0102001:	6a 43                	push   $0x43
  jmp __alltraps
c0102003:	e9 8a fd ff ff       	jmp    c0101d92 <__alltraps>

c0102008 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102008:	6a 00                	push   $0x0
  pushl $68
c010200a:	6a 44                	push   $0x44
  jmp __alltraps
c010200c:	e9 81 fd ff ff       	jmp    c0101d92 <__alltraps>

c0102011 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102011:	6a 00                	push   $0x0
  pushl $69
c0102013:	6a 45                	push   $0x45
  jmp __alltraps
c0102015:	e9 78 fd ff ff       	jmp    c0101d92 <__alltraps>

c010201a <vector70>:
.globl vector70
vector70:
  pushl $0
c010201a:	6a 00                	push   $0x0
  pushl $70
c010201c:	6a 46                	push   $0x46
  jmp __alltraps
c010201e:	e9 6f fd ff ff       	jmp    c0101d92 <__alltraps>

c0102023 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102023:	6a 00                	push   $0x0
  pushl $71
c0102025:	6a 47                	push   $0x47
  jmp __alltraps
c0102027:	e9 66 fd ff ff       	jmp    c0101d92 <__alltraps>

c010202c <vector72>:
.globl vector72
vector72:
  pushl $0
c010202c:	6a 00                	push   $0x0
  pushl $72
c010202e:	6a 48                	push   $0x48
  jmp __alltraps
c0102030:	e9 5d fd ff ff       	jmp    c0101d92 <__alltraps>

c0102035 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102035:	6a 00                	push   $0x0
  pushl $73
c0102037:	6a 49                	push   $0x49
  jmp __alltraps
c0102039:	e9 54 fd ff ff       	jmp    c0101d92 <__alltraps>

c010203e <vector74>:
.globl vector74
vector74:
  pushl $0
c010203e:	6a 00                	push   $0x0
  pushl $74
c0102040:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102042:	e9 4b fd ff ff       	jmp    c0101d92 <__alltraps>

c0102047 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102047:	6a 00                	push   $0x0
  pushl $75
c0102049:	6a 4b                	push   $0x4b
  jmp __alltraps
c010204b:	e9 42 fd ff ff       	jmp    c0101d92 <__alltraps>

c0102050 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102050:	6a 00                	push   $0x0
  pushl $76
c0102052:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102054:	e9 39 fd ff ff       	jmp    c0101d92 <__alltraps>

c0102059 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102059:	6a 00                	push   $0x0
  pushl $77
c010205b:	6a 4d                	push   $0x4d
  jmp __alltraps
c010205d:	e9 30 fd ff ff       	jmp    c0101d92 <__alltraps>

c0102062 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102062:	6a 00                	push   $0x0
  pushl $78
c0102064:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102066:	e9 27 fd ff ff       	jmp    c0101d92 <__alltraps>

c010206b <vector79>:
.globl vector79
vector79:
  pushl $0
c010206b:	6a 00                	push   $0x0
  pushl $79
c010206d:	6a 4f                	push   $0x4f
  jmp __alltraps
c010206f:	e9 1e fd ff ff       	jmp    c0101d92 <__alltraps>

c0102074 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102074:	6a 00                	push   $0x0
  pushl $80
c0102076:	6a 50                	push   $0x50
  jmp __alltraps
c0102078:	e9 15 fd ff ff       	jmp    c0101d92 <__alltraps>

c010207d <vector81>:
.globl vector81
vector81:
  pushl $0
c010207d:	6a 00                	push   $0x0
  pushl $81
c010207f:	6a 51                	push   $0x51
  jmp __alltraps
c0102081:	e9 0c fd ff ff       	jmp    c0101d92 <__alltraps>

c0102086 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102086:	6a 00                	push   $0x0
  pushl $82
c0102088:	6a 52                	push   $0x52
  jmp __alltraps
c010208a:	e9 03 fd ff ff       	jmp    c0101d92 <__alltraps>

c010208f <vector83>:
.globl vector83
vector83:
  pushl $0
c010208f:	6a 00                	push   $0x0
  pushl $83
c0102091:	6a 53                	push   $0x53
  jmp __alltraps
c0102093:	e9 fa fc ff ff       	jmp    c0101d92 <__alltraps>

c0102098 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102098:	6a 00                	push   $0x0
  pushl $84
c010209a:	6a 54                	push   $0x54
  jmp __alltraps
c010209c:	e9 f1 fc ff ff       	jmp    c0101d92 <__alltraps>

c01020a1 <vector85>:
.globl vector85
vector85:
  pushl $0
c01020a1:	6a 00                	push   $0x0
  pushl $85
c01020a3:	6a 55                	push   $0x55
  jmp __alltraps
c01020a5:	e9 e8 fc ff ff       	jmp    c0101d92 <__alltraps>

c01020aa <vector86>:
.globl vector86
vector86:
  pushl $0
c01020aa:	6a 00                	push   $0x0
  pushl $86
c01020ac:	6a 56                	push   $0x56
  jmp __alltraps
c01020ae:	e9 df fc ff ff       	jmp    c0101d92 <__alltraps>

c01020b3 <vector87>:
.globl vector87
vector87:
  pushl $0
c01020b3:	6a 00                	push   $0x0
  pushl $87
c01020b5:	6a 57                	push   $0x57
  jmp __alltraps
c01020b7:	e9 d6 fc ff ff       	jmp    c0101d92 <__alltraps>

c01020bc <vector88>:
.globl vector88
vector88:
  pushl $0
c01020bc:	6a 00                	push   $0x0
  pushl $88
c01020be:	6a 58                	push   $0x58
  jmp __alltraps
c01020c0:	e9 cd fc ff ff       	jmp    c0101d92 <__alltraps>

c01020c5 <vector89>:
.globl vector89
vector89:
  pushl $0
c01020c5:	6a 00                	push   $0x0
  pushl $89
c01020c7:	6a 59                	push   $0x59
  jmp __alltraps
c01020c9:	e9 c4 fc ff ff       	jmp    c0101d92 <__alltraps>

c01020ce <vector90>:
.globl vector90
vector90:
  pushl $0
c01020ce:	6a 00                	push   $0x0
  pushl $90
c01020d0:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020d2:	e9 bb fc ff ff       	jmp    c0101d92 <__alltraps>

c01020d7 <vector91>:
.globl vector91
vector91:
  pushl $0
c01020d7:	6a 00                	push   $0x0
  pushl $91
c01020d9:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020db:	e9 b2 fc ff ff       	jmp    c0101d92 <__alltraps>

c01020e0 <vector92>:
.globl vector92
vector92:
  pushl $0
c01020e0:	6a 00                	push   $0x0
  pushl $92
c01020e2:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020e4:	e9 a9 fc ff ff       	jmp    c0101d92 <__alltraps>

c01020e9 <vector93>:
.globl vector93
vector93:
  pushl $0
c01020e9:	6a 00                	push   $0x0
  pushl $93
c01020eb:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020ed:	e9 a0 fc ff ff       	jmp    c0101d92 <__alltraps>

c01020f2 <vector94>:
.globl vector94
vector94:
  pushl $0
c01020f2:	6a 00                	push   $0x0
  pushl $94
c01020f4:	6a 5e                	push   $0x5e
  jmp __alltraps
c01020f6:	e9 97 fc ff ff       	jmp    c0101d92 <__alltraps>

c01020fb <vector95>:
.globl vector95
vector95:
  pushl $0
c01020fb:	6a 00                	push   $0x0
  pushl $95
c01020fd:	6a 5f                	push   $0x5f
  jmp __alltraps
c01020ff:	e9 8e fc ff ff       	jmp    c0101d92 <__alltraps>

c0102104 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102104:	6a 00                	push   $0x0
  pushl $96
c0102106:	6a 60                	push   $0x60
  jmp __alltraps
c0102108:	e9 85 fc ff ff       	jmp    c0101d92 <__alltraps>

c010210d <vector97>:
.globl vector97
vector97:
  pushl $0
c010210d:	6a 00                	push   $0x0
  pushl $97
c010210f:	6a 61                	push   $0x61
  jmp __alltraps
c0102111:	e9 7c fc ff ff       	jmp    c0101d92 <__alltraps>

c0102116 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102116:	6a 00                	push   $0x0
  pushl $98
c0102118:	6a 62                	push   $0x62
  jmp __alltraps
c010211a:	e9 73 fc ff ff       	jmp    c0101d92 <__alltraps>

c010211f <vector99>:
.globl vector99
vector99:
  pushl $0
c010211f:	6a 00                	push   $0x0
  pushl $99
c0102121:	6a 63                	push   $0x63
  jmp __alltraps
c0102123:	e9 6a fc ff ff       	jmp    c0101d92 <__alltraps>

c0102128 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102128:	6a 00                	push   $0x0
  pushl $100
c010212a:	6a 64                	push   $0x64
  jmp __alltraps
c010212c:	e9 61 fc ff ff       	jmp    c0101d92 <__alltraps>

c0102131 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102131:	6a 00                	push   $0x0
  pushl $101
c0102133:	6a 65                	push   $0x65
  jmp __alltraps
c0102135:	e9 58 fc ff ff       	jmp    c0101d92 <__alltraps>

c010213a <vector102>:
.globl vector102
vector102:
  pushl $0
c010213a:	6a 00                	push   $0x0
  pushl $102
c010213c:	6a 66                	push   $0x66
  jmp __alltraps
c010213e:	e9 4f fc ff ff       	jmp    c0101d92 <__alltraps>

c0102143 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102143:	6a 00                	push   $0x0
  pushl $103
c0102145:	6a 67                	push   $0x67
  jmp __alltraps
c0102147:	e9 46 fc ff ff       	jmp    c0101d92 <__alltraps>

c010214c <vector104>:
.globl vector104
vector104:
  pushl $0
c010214c:	6a 00                	push   $0x0
  pushl $104
c010214e:	6a 68                	push   $0x68
  jmp __alltraps
c0102150:	e9 3d fc ff ff       	jmp    c0101d92 <__alltraps>

c0102155 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102155:	6a 00                	push   $0x0
  pushl $105
c0102157:	6a 69                	push   $0x69
  jmp __alltraps
c0102159:	e9 34 fc ff ff       	jmp    c0101d92 <__alltraps>

c010215e <vector106>:
.globl vector106
vector106:
  pushl $0
c010215e:	6a 00                	push   $0x0
  pushl $106
c0102160:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102162:	e9 2b fc ff ff       	jmp    c0101d92 <__alltraps>

c0102167 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102167:	6a 00                	push   $0x0
  pushl $107
c0102169:	6a 6b                	push   $0x6b
  jmp __alltraps
c010216b:	e9 22 fc ff ff       	jmp    c0101d92 <__alltraps>

c0102170 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102170:	6a 00                	push   $0x0
  pushl $108
c0102172:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102174:	e9 19 fc ff ff       	jmp    c0101d92 <__alltraps>

c0102179 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102179:	6a 00                	push   $0x0
  pushl $109
c010217b:	6a 6d                	push   $0x6d
  jmp __alltraps
c010217d:	e9 10 fc ff ff       	jmp    c0101d92 <__alltraps>

c0102182 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102182:	6a 00                	push   $0x0
  pushl $110
c0102184:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102186:	e9 07 fc ff ff       	jmp    c0101d92 <__alltraps>

c010218b <vector111>:
.globl vector111
vector111:
  pushl $0
c010218b:	6a 00                	push   $0x0
  pushl $111
c010218d:	6a 6f                	push   $0x6f
  jmp __alltraps
c010218f:	e9 fe fb ff ff       	jmp    c0101d92 <__alltraps>

c0102194 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102194:	6a 00                	push   $0x0
  pushl $112
c0102196:	6a 70                	push   $0x70
  jmp __alltraps
c0102198:	e9 f5 fb ff ff       	jmp    c0101d92 <__alltraps>

c010219d <vector113>:
.globl vector113
vector113:
  pushl $0
c010219d:	6a 00                	push   $0x0
  pushl $113
c010219f:	6a 71                	push   $0x71
  jmp __alltraps
c01021a1:	e9 ec fb ff ff       	jmp    c0101d92 <__alltraps>

c01021a6 <vector114>:
.globl vector114
vector114:
  pushl $0
c01021a6:	6a 00                	push   $0x0
  pushl $114
c01021a8:	6a 72                	push   $0x72
  jmp __alltraps
c01021aa:	e9 e3 fb ff ff       	jmp    c0101d92 <__alltraps>

c01021af <vector115>:
.globl vector115
vector115:
  pushl $0
c01021af:	6a 00                	push   $0x0
  pushl $115
c01021b1:	6a 73                	push   $0x73
  jmp __alltraps
c01021b3:	e9 da fb ff ff       	jmp    c0101d92 <__alltraps>

c01021b8 <vector116>:
.globl vector116
vector116:
  pushl $0
c01021b8:	6a 00                	push   $0x0
  pushl $116
c01021ba:	6a 74                	push   $0x74
  jmp __alltraps
c01021bc:	e9 d1 fb ff ff       	jmp    c0101d92 <__alltraps>

c01021c1 <vector117>:
.globl vector117
vector117:
  pushl $0
c01021c1:	6a 00                	push   $0x0
  pushl $117
c01021c3:	6a 75                	push   $0x75
  jmp __alltraps
c01021c5:	e9 c8 fb ff ff       	jmp    c0101d92 <__alltraps>

c01021ca <vector118>:
.globl vector118
vector118:
  pushl $0
c01021ca:	6a 00                	push   $0x0
  pushl $118
c01021cc:	6a 76                	push   $0x76
  jmp __alltraps
c01021ce:	e9 bf fb ff ff       	jmp    c0101d92 <__alltraps>

c01021d3 <vector119>:
.globl vector119
vector119:
  pushl $0
c01021d3:	6a 00                	push   $0x0
  pushl $119
c01021d5:	6a 77                	push   $0x77
  jmp __alltraps
c01021d7:	e9 b6 fb ff ff       	jmp    c0101d92 <__alltraps>

c01021dc <vector120>:
.globl vector120
vector120:
  pushl $0
c01021dc:	6a 00                	push   $0x0
  pushl $120
c01021de:	6a 78                	push   $0x78
  jmp __alltraps
c01021e0:	e9 ad fb ff ff       	jmp    c0101d92 <__alltraps>

c01021e5 <vector121>:
.globl vector121
vector121:
  pushl $0
c01021e5:	6a 00                	push   $0x0
  pushl $121
c01021e7:	6a 79                	push   $0x79
  jmp __alltraps
c01021e9:	e9 a4 fb ff ff       	jmp    c0101d92 <__alltraps>

c01021ee <vector122>:
.globl vector122
vector122:
  pushl $0
c01021ee:	6a 00                	push   $0x0
  pushl $122
c01021f0:	6a 7a                	push   $0x7a
  jmp __alltraps
c01021f2:	e9 9b fb ff ff       	jmp    c0101d92 <__alltraps>

c01021f7 <vector123>:
.globl vector123
vector123:
  pushl $0
c01021f7:	6a 00                	push   $0x0
  pushl $123
c01021f9:	6a 7b                	push   $0x7b
  jmp __alltraps
c01021fb:	e9 92 fb ff ff       	jmp    c0101d92 <__alltraps>

c0102200 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102200:	6a 00                	push   $0x0
  pushl $124
c0102202:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102204:	e9 89 fb ff ff       	jmp    c0101d92 <__alltraps>

c0102209 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102209:	6a 00                	push   $0x0
  pushl $125
c010220b:	6a 7d                	push   $0x7d
  jmp __alltraps
c010220d:	e9 80 fb ff ff       	jmp    c0101d92 <__alltraps>

c0102212 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102212:	6a 00                	push   $0x0
  pushl $126
c0102214:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102216:	e9 77 fb ff ff       	jmp    c0101d92 <__alltraps>

c010221b <vector127>:
.globl vector127
vector127:
  pushl $0
c010221b:	6a 00                	push   $0x0
  pushl $127
c010221d:	6a 7f                	push   $0x7f
  jmp __alltraps
c010221f:	e9 6e fb ff ff       	jmp    c0101d92 <__alltraps>

c0102224 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102224:	6a 00                	push   $0x0
  pushl $128
c0102226:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010222b:	e9 62 fb ff ff       	jmp    c0101d92 <__alltraps>

c0102230 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102230:	6a 00                	push   $0x0
  pushl $129
c0102232:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102237:	e9 56 fb ff ff       	jmp    c0101d92 <__alltraps>

c010223c <vector130>:
.globl vector130
vector130:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $130
c010223e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102243:	e9 4a fb ff ff       	jmp    c0101d92 <__alltraps>

c0102248 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102248:	6a 00                	push   $0x0
  pushl $131
c010224a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010224f:	e9 3e fb ff ff       	jmp    c0101d92 <__alltraps>

c0102254 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102254:	6a 00                	push   $0x0
  pushl $132
c0102256:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010225b:	e9 32 fb ff ff       	jmp    c0101d92 <__alltraps>

c0102260 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $133
c0102262:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102267:	e9 26 fb ff ff       	jmp    c0101d92 <__alltraps>

c010226c <vector134>:
.globl vector134
vector134:
  pushl $0
c010226c:	6a 00                	push   $0x0
  pushl $134
c010226e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102273:	e9 1a fb ff ff       	jmp    c0101d92 <__alltraps>

c0102278 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102278:	6a 00                	push   $0x0
  pushl $135
c010227a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010227f:	e9 0e fb ff ff       	jmp    c0101d92 <__alltraps>

c0102284 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102284:	6a 00                	push   $0x0
  pushl $136
c0102286:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010228b:	e9 02 fb ff ff       	jmp    c0101d92 <__alltraps>

c0102290 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102290:	6a 00                	push   $0x0
  pushl $137
c0102292:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102297:	e9 f6 fa ff ff       	jmp    c0101d92 <__alltraps>

c010229c <vector138>:
.globl vector138
vector138:
  pushl $0
c010229c:	6a 00                	push   $0x0
  pushl $138
c010229e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022a3:	e9 ea fa ff ff       	jmp    c0101d92 <__alltraps>

c01022a8 <vector139>:
.globl vector139
vector139:
  pushl $0
c01022a8:	6a 00                	push   $0x0
  pushl $139
c01022aa:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022af:	e9 de fa ff ff       	jmp    c0101d92 <__alltraps>

c01022b4 <vector140>:
.globl vector140
vector140:
  pushl $0
c01022b4:	6a 00                	push   $0x0
  pushl $140
c01022b6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022bb:	e9 d2 fa ff ff       	jmp    c0101d92 <__alltraps>

c01022c0 <vector141>:
.globl vector141
vector141:
  pushl $0
c01022c0:	6a 00                	push   $0x0
  pushl $141
c01022c2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022c7:	e9 c6 fa ff ff       	jmp    c0101d92 <__alltraps>

c01022cc <vector142>:
.globl vector142
vector142:
  pushl $0
c01022cc:	6a 00                	push   $0x0
  pushl $142
c01022ce:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022d3:	e9 ba fa ff ff       	jmp    c0101d92 <__alltraps>

c01022d8 <vector143>:
.globl vector143
vector143:
  pushl $0
c01022d8:	6a 00                	push   $0x0
  pushl $143
c01022da:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022df:	e9 ae fa ff ff       	jmp    c0101d92 <__alltraps>

c01022e4 <vector144>:
.globl vector144
vector144:
  pushl $0
c01022e4:	6a 00                	push   $0x0
  pushl $144
c01022e6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022eb:	e9 a2 fa ff ff       	jmp    c0101d92 <__alltraps>

c01022f0 <vector145>:
.globl vector145
vector145:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $145
c01022f2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01022f7:	e9 96 fa ff ff       	jmp    c0101d92 <__alltraps>

c01022fc <vector146>:
.globl vector146
vector146:
  pushl $0
c01022fc:	6a 00                	push   $0x0
  pushl $146
c01022fe:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102303:	e9 8a fa ff ff       	jmp    c0101d92 <__alltraps>

c0102308 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102308:	6a 00                	push   $0x0
  pushl $147
c010230a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010230f:	e9 7e fa ff ff       	jmp    c0101d92 <__alltraps>

c0102314 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $148
c0102316:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010231b:	e9 72 fa ff ff       	jmp    c0101d92 <__alltraps>

c0102320 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102320:	6a 00                	push   $0x0
  pushl $149
c0102322:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102327:	e9 66 fa ff ff       	jmp    c0101d92 <__alltraps>

c010232c <vector150>:
.globl vector150
vector150:
  pushl $0
c010232c:	6a 00                	push   $0x0
  pushl $150
c010232e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102333:	e9 5a fa ff ff       	jmp    c0101d92 <__alltraps>

c0102338 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102338:	6a 00                	push   $0x0
  pushl $151
c010233a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010233f:	e9 4e fa ff ff       	jmp    c0101d92 <__alltraps>

c0102344 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102344:	6a 00                	push   $0x0
  pushl $152
c0102346:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010234b:	e9 42 fa ff ff       	jmp    c0101d92 <__alltraps>

c0102350 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102350:	6a 00                	push   $0x0
  pushl $153
c0102352:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102357:	e9 36 fa ff ff       	jmp    c0101d92 <__alltraps>

c010235c <vector154>:
.globl vector154
vector154:
  pushl $0
c010235c:	6a 00                	push   $0x0
  pushl $154
c010235e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102363:	e9 2a fa ff ff       	jmp    c0101d92 <__alltraps>

c0102368 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102368:	6a 00                	push   $0x0
  pushl $155
c010236a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010236f:	e9 1e fa ff ff       	jmp    c0101d92 <__alltraps>

c0102374 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102374:	6a 00                	push   $0x0
  pushl $156
c0102376:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010237b:	e9 12 fa ff ff       	jmp    c0101d92 <__alltraps>

c0102380 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102380:	6a 00                	push   $0x0
  pushl $157
c0102382:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102387:	e9 06 fa ff ff       	jmp    c0101d92 <__alltraps>

c010238c <vector158>:
.globl vector158
vector158:
  pushl $0
c010238c:	6a 00                	push   $0x0
  pushl $158
c010238e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102393:	e9 fa f9 ff ff       	jmp    c0101d92 <__alltraps>

c0102398 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102398:	6a 00                	push   $0x0
  pushl $159
c010239a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010239f:	e9 ee f9 ff ff       	jmp    c0101d92 <__alltraps>

c01023a4 <vector160>:
.globl vector160
vector160:
  pushl $0
c01023a4:	6a 00                	push   $0x0
  pushl $160
c01023a6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023ab:	e9 e2 f9 ff ff       	jmp    c0101d92 <__alltraps>

c01023b0 <vector161>:
.globl vector161
vector161:
  pushl $0
c01023b0:	6a 00                	push   $0x0
  pushl $161
c01023b2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023b7:	e9 d6 f9 ff ff       	jmp    c0101d92 <__alltraps>

c01023bc <vector162>:
.globl vector162
vector162:
  pushl $0
c01023bc:	6a 00                	push   $0x0
  pushl $162
c01023be:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023c3:	e9 ca f9 ff ff       	jmp    c0101d92 <__alltraps>

c01023c8 <vector163>:
.globl vector163
vector163:
  pushl $0
c01023c8:	6a 00                	push   $0x0
  pushl $163
c01023ca:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023cf:	e9 be f9 ff ff       	jmp    c0101d92 <__alltraps>

c01023d4 <vector164>:
.globl vector164
vector164:
  pushl $0
c01023d4:	6a 00                	push   $0x0
  pushl $164
c01023d6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023db:	e9 b2 f9 ff ff       	jmp    c0101d92 <__alltraps>

c01023e0 <vector165>:
.globl vector165
vector165:
  pushl $0
c01023e0:	6a 00                	push   $0x0
  pushl $165
c01023e2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023e7:	e9 a6 f9 ff ff       	jmp    c0101d92 <__alltraps>

c01023ec <vector166>:
.globl vector166
vector166:
  pushl $0
c01023ec:	6a 00                	push   $0x0
  pushl $166
c01023ee:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01023f3:	e9 9a f9 ff ff       	jmp    c0101d92 <__alltraps>

c01023f8 <vector167>:
.globl vector167
vector167:
  pushl $0
c01023f8:	6a 00                	push   $0x0
  pushl $167
c01023fa:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01023ff:	e9 8e f9 ff ff       	jmp    c0101d92 <__alltraps>

c0102404 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102404:	6a 00                	push   $0x0
  pushl $168
c0102406:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010240b:	e9 82 f9 ff ff       	jmp    c0101d92 <__alltraps>

c0102410 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102410:	6a 00                	push   $0x0
  pushl $169
c0102412:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102417:	e9 76 f9 ff ff       	jmp    c0101d92 <__alltraps>

c010241c <vector170>:
.globl vector170
vector170:
  pushl $0
c010241c:	6a 00                	push   $0x0
  pushl $170
c010241e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102423:	e9 6a f9 ff ff       	jmp    c0101d92 <__alltraps>

c0102428 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $171
c010242a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010242f:	e9 5e f9 ff ff       	jmp    c0101d92 <__alltraps>

c0102434 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102434:	6a 00                	push   $0x0
  pushl $172
c0102436:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010243b:	e9 52 f9 ff ff       	jmp    c0101d92 <__alltraps>

c0102440 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102440:	6a 00                	push   $0x0
  pushl $173
c0102442:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102447:	e9 46 f9 ff ff       	jmp    c0101d92 <__alltraps>

c010244c <vector174>:
.globl vector174
vector174:
  pushl $0
c010244c:	6a 00                	push   $0x0
  pushl $174
c010244e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102453:	e9 3a f9 ff ff       	jmp    c0101d92 <__alltraps>

c0102458 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102458:	6a 00                	push   $0x0
  pushl $175
c010245a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010245f:	e9 2e f9 ff ff       	jmp    c0101d92 <__alltraps>

c0102464 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102464:	6a 00                	push   $0x0
  pushl $176
c0102466:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010246b:	e9 22 f9 ff ff       	jmp    c0101d92 <__alltraps>

c0102470 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102470:	6a 00                	push   $0x0
  pushl $177
c0102472:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102477:	e9 16 f9 ff ff       	jmp    c0101d92 <__alltraps>

c010247c <vector178>:
.globl vector178
vector178:
  pushl $0
c010247c:	6a 00                	push   $0x0
  pushl $178
c010247e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102483:	e9 0a f9 ff ff       	jmp    c0101d92 <__alltraps>

c0102488 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102488:	6a 00                	push   $0x0
  pushl $179
c010248a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010248f:	e9 fe f8 ff ff       	jmp    c0101d92 <__alltraps>

c0102494 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102494:	6a 00                	push   $0x0
  pushl $180
c0102496:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010249b:	e9 f2 f8 ff ff       	jmp    c0101d92 <__alltraps>

c01024a0 <vector181>:
.globl vector181
vector181:
  pushl $0
c01024a0:	6a 00                	push   $0x0
  pushl $181
c01024a2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024a7:	e9 e6 f8 ff ff       	jmp    c0101d92 <__alltraps>

c01024ac <vector182>:
.globl vector182
vector182:
  pushl $0
c01024ac:	6a 00                	push   $0x0
  pushl $182
c01024ae:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01024b3:	e9 da f8 ff ff       	jmp    c0101d92 <__alltraps>

c01024b8 <vector183>:
.globl vector183
vector183:
  pushl $0
c01024b8:	6a 00                	push   $0x0
  pushl $183
c01024ba:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024bf:	e9 ce f8 ff ff       	jmp    c0101d92 <__alltraps>

c01024c4 <vector184>:
.globl vector184
vector184:
  pushl $0
c01024c4:	6a 00                	push   $0x0
  pushl $184
c01024c6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024cb:	e9 c2 f8 ff ff       	jmp    c0101d92 <__alltraps>

c01024d0 <vector185>:
.globl vector185
vector185:
  pushl $0
c01024d0:	6a 00                	push   $0x0
  pushl $185
c01024d2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024d7:	e9 b6 f8 ff ff       	jmp    c0101d92 <__alltraps>

c01024dc <vector186>:
.globl vector186
vector186:
  pushl $0
c01024dc:	6a 00                	push   $0x0
  pushl $186
c01024de:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024e3:	e9 aa f8 ff ff       	jmp    c0101d92 <__alltraps>

c01024e8 <vector187>:
.globl vector187
vector187:
  pushl $0
c01024e8:	6a 00                	push   $0x0
  pushl $187
c01024ea:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024ef:	e9 9e f8 ff ff       	jmp    c0101d92 <__alltraps>

c01024f4 <vector188>:
.globl vector188
vector188:
  pushl $0
c01024f4:	6a 00                	push   $0x0
  pushl $188
c01024f6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01024fb:	e9 92 f8 ff ff       	jmp    c0101d92 <__alltraps>

c0102500 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102500:	6a 00                	push   $0x0
  pushl $189
c0102502:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102507:	e9 86 f8 ff ff       	jmp    c0101d92 <__alltraps>

c010250c <vector190>:
.globl vector190
vector190:
  pushl $0
c010250c:	6a 00                	push   $0x0
  pushl $190
c010250e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102513:	e9 7a f8 ff ff       	jmp    c0101d92 <__alltraps>

c0102518 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102518:	6a 00                	push   $0x0
  pushl $191
c010251a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010251f:	e9 6e f8 ff ff       	jmp    c0101d92 <__alltraps>

c0102524 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102524:	6a 00                	push   $0x0
  pushl $192
c0102526:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010252b:	e9 62 f8 ff ff       	jmp    c0101d92 <__alltraps>

c0102530 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102530:	6a 00                	push   $0x0
  pushl $193
c0102532:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102537:	e9 56 f8 ff ff       	jmp    c0101d92 <__alltraps>

c010253c <vector194>:
.globl vector194
vector194:
  pushl $0
c010253c:	6a 00                	push   $0x0
  pushl $194
c010253e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102543:	e9 4a f8 ff ff       	jmp    c0101d92 <__alltraps>

c0102548 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102548:	6a 00                	push   $0x0
  pushl $195
c010254a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010254f:	e9 3e f8 ff ff       	jmp    c0101d92 <__alltraps>

c0102554 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102554:	6a 00                	push   $0x0
  pushl $196
c0102556:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010255b:	e9 32 f8 ff ff       	jmp    c0101d92 <__alltraps>

c0102560 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102560:	6a 00                	push   $0x0
  pushl $197
c0102562:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102567:	e9 26 f8 ff ff       	jmp    c0101d92 <__alltraps>

c010256c <vector198>:
.globl vector198
vector198:
  pushl $0
c010256c:	6a 00                	push   $0x0
  pushl $198
c010256e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102573:	e9 1a f8 ff ff       	jmp    c0101d92 <__alltraps>

c0102578 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102578:	6a 00                	push   $0x0
  pushl $199
c010257a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010257f:	e9 0e f8 ff ff       	jmp    c0101d92 <__alltraps>

c0102584 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102584:	6a 00                	push   $0x0
  pushl $200
c0102586:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010258b:	e9 02 f8 ff ff       	jmp    c0101d92 <__alltraps>

c0102590 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102590:	6a 00                	push   $0x0
  pushl $201
c0102592:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102597:	e9 f6 f7 ff ff       	jmp    c0101d92 <__alltraps>

c010259c <vector202>:
.globl vector202
vector202:
  pushl $0
c010259c:	6a 00                	push   $0x0
  pushl $202
c010259e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025a3:	e9 ea f7 ff ff       	jmp    c0101d92 <__alltraps>

c01025a8 <vector203>:
.globl vector203
vector203:
  pushl $0
c01025a8:	6a 00                	push   $0x0
  pushl $203
c01025aa:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025af:	e9 de f7 ff ff       	jmp    c0101d92 <__alltraps>

c01025b4 <vector204>:
.globl vector204
vector204:
  pushl $0
c01025b4:	6a 00                	push   $0x0
  pushl $204
c01025b6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025bb:	e9 d2 f7 ff ff       	jmp    c0101d92 <__alltraps>

c01025c0 <vector205>:
.globl vector205
vector205:
  pushl $0
c01025c0:	6a 00                	push   $0x0
  pushl $205
c01025c2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025c7:	e9 c6 f7 ff ff       	jmp    c0101d92 <__alltraps>

c01025cc <vector206>:
.globl vector206
vector206:
  pushl $0
c01025cc:	6a 00                	push   $0x0
  pushl $206
c01025ce:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025d3:	e9 ba f7 ff ff       	jmp    c0101d92 <__alltraps>

c01025d8 <vector207>:
.globl vector207
vector207:
  pushl $0
c01025d8:	6a 00                	push   $0x0
  pushl $207
c01025da:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025df:	e9 ae f7 ff ff       	jmp    c0101d92 <__alltraps>

c01025e4 <vector208>:
.globl vector208
vector208:
  pushl $0
c01025e4:	6a 00                	push   $0x0
  pushl $208
c01025e6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025eb:	e9 a2 f7 ff ff       	jmp    c0101d92 <__alltraps>

c01025f0 <vector209>:
.globl vector209
vector209:
  pushl $0
c01025f0:	6a 00                	push   $0x0
  pushl $209
c01025f2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01025f7:	e9 96 f7 ff ff       	jmp    c0101d92 <__alltraps>

c01025fc <vector210>:
.globl vector210
vector210:
  pushl $0
c01025fc:	6a 00                	push   $0x0
  pushl $210
c01025fe:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102603:	e9 8a f7 ff ff       	jmp    c0101d92 <__alltraps>

c0102608 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102608:	6a 00                	push   $0x0
  pushl $211
c010260a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010260f:	e9 7e f7 ff ff       	jmp    c0101d92 <__alltraps>

c0102614 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102614:	6a 00                	push   $0x0
  pushl $212
c0102616:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010261b:	e9 72 f7 ff ff       	jmp    c0101d92 <__alltraps>

c0102620 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102620:	6a 00                	push   $0x0
  pushl $213
c0102622:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102627:	e9 66 f7 ff ff       	jmp    c0101d92 <__alltraps>

c010262c <vector214>:
.globl vector214
vector214:
  pushl $0
c010262c:	6a 00                	push   $0x0
  pushl $214
c010262e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102633:	e9 5a f7 ff ff       	jmp    c0101d92 <__alltraps>

c0102638 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102638:	6a 00                	push   $0x0
  pushl $215
c010263a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010263f:	e9 4e f7 ff ff       	jmp    c0101d92 <__alltraps>

c0102644 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102644:	6a 00                	push   $0x0
  pushl $216
c0102646:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010264b:	e9 42 f7 ff ff       	jmp    c0101d92 <__alltraps>

c0102650 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102650:	6a 00                	push   $0x0
  pushl $217
c0102652:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102657:	e9 36 f7 ff ff       	jmp    c0101d92 <__alltraps>

c010265c <vector218>:
.globl vector218
vector218:
  pushl $0
c010265c:	6a 00                	push   $0x0
  pushl $218
c010265e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102663:	e9 2a f7 ff ff       	jmp    c0101d92 <__alltraps>

c0102668 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102668:	6a 00                	push   $0x0
  pushl $219
c010266a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010266f:	e9 1e f7 ff ff       	jmp    c0101d92 <__alltraps>

c0102674 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102674:	6a 00                	push   $0x0
  pushl $220
c0102676:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010267b:	e9 12 f7 ff ff       	jmp    c0101d92 <__alltraps>

c0102680 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102680:	6a 00                	push   $0x0
  pushl $221
c0102682:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102687:	e9 06 f7 ff ff       	jmp    c0101d92 <__alltraps>

c010268c <vector222>:
.globl vector222
vector222:
  pushl $0
c010268c:	6a 00                	push   $0x0
  pushl $222
c010268e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102693:	e9 fa f6 ff ff       	jmp    c0101d92 <__alltraps>

c0102698 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102698:	6a 00                	push   $0x0
  pushl $223
c010269a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010269f:	e9 ee f6 ff ff       	jmp    c0101d92 <__alltraps>

c01026a4 <vector224>:
.globl vector224
vector224:
  pushl $0
c01026a4:	6a 00                	push   $0x0
  pushl $224
c01026a6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026ab:	e9 e2 f6 ff ff       	jmp    c0101d92 <__alltraps>

c01026b0 <vector225>:
.globl vector225
vector225:
  pushl $0
c01026b0:	6a 00                	push   $0x0
  pushl $225
c01026b2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026b7:	e9 d6 f6 ff ff       	jmp    c0101d92 <__alltraps>

c01026bc <vector226>:
.globl vector226
vector226:
  pushl $0
c01026bc:	6a 00                	push   $0x0
  pushl $226
c01026be:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026c3:	e9 ca f6 ff ff       	jmp    c0101d92 <__alltraps>

c01026c8 <vector227>:
.globl vector227
vector227:
  pushl $0
c01026c8:	6a 00                	push   $0x0
  pushl $227
c01026ca:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026cf:	e9 be f6 ff ff       	jmp    c0101d92 <__alltraps>

c01026d4 <vector228>:
.globl vector228
vector228:
  pushl $0
c01026d4:	6a 00                	push   $0x0
  pushl $228
c01026d6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026db:	e9 b2 f6 ff ff       	jmp    c0101d92 <__alltraps>

c01026e0 <vector229>:
.globl vector229
vector229:
  pushl $0
c01026e0:	6a 00                	push   $0x0
  pushl $229
c01026e2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026e7:	e9 a6 f6 ff ff       	jmp    c0101d92 <__alltraps>

c01026ec <vector230>:
.globl vector230
vector230:
  pushl $0
c01026ec:	6a 00                	push   $0x0
  pushl $230
c01026ee:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01026f3:	e9 9a f6 ff ff       	jmp    c0101d92 <__alltraps>

c01026f8 <vector231>:
.globl vector231
vector231:
  pushl $0
c01026f8:	6a 00                	push   $0x0
  pushl $231
c01026fa:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01026ff:	e9 8e f6 ff ff       	jmp    c0101d92 <__alltraps>

c0102704 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102704:	6a 00                	push   $0x0
  pushl $232
c0102706:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010270b:	e9 82 f6 ff ff       	jmp    c0101d92 <__alltraps>

c0102710 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102710:	6a 00                	push   $0x0
  pushl $233
c0102712:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102717:	e9 76 f6 ff ff       	jmp    c0101d92 <__alltraps>

c010271c <vector234>:
.globl vector234
vector234:
  pushl $0
c010271c:	6a 00                	push   $0x0
  pushl $234
c010271e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102723:	e9 6a f6 ff ff       	jmp    c0101d92 <__alltraps>

c0102728 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102728:	6a 00                	push   $0x0
  pushl $235
c010272a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010272f:	e9 5e f6 ff ff       	jmp    c0101d92 <__alltraps>

c0102734 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102734:	6a 00                	push   $0x0
  pushl $236
c0102736:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010273b:	e9 52 f6 ff ff       	jmp    c0101d92 <__alltraps>

c0102740 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102740:	6a 00                	push   $0x0
  pushl $237
c0102742:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102747:	e9 46 f6 ff ff       	jmp    c0101d92 <__alltraps>

c010274c <vector238>:
.globl vector238
vector238:
  pushl $0
c010274c:	6a 00                	push   $0x0
  pushl $238
c010274e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102753:	e9 3a f6 ff ff       	jmp    c0101d92 <__alltraps>

c0102758 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102758:	6a 00                	push   $0x0
  pushl $239
c010275a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010275f:	e9 2e f6 ff ff       	jmp    c0101d92 <__alltraps>

c0102764 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102764:	6a 00                	push   $0x0
  pushl $240
c0102766:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010276b:	e9 22 f6 ff ff       	jmp    c0101d92 <__alltraps>

c0102770 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102770:	6a 00                	push   $0x0
  pushl $241
c0102772:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102777:	e9 16 f6 ff ff       	jmp    c0101d92 <__alltraps>

c010277c <vector242>:
.globl vector242
vector242:
  pushl $0
c010277c:	6a 00                	push   $0x0
  pushl $242
c010277e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102783:	e9 0a f6 ff ff       	jmp    c0101d92 <__alltraps>

c0102788 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102788:	6a 00                	push   $0x0
  pushl $243
c010278a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010278f:	e9 fe f5 ff ff       	jmp    c0101d92 <__alltraps>

c0102794 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102794:	6a 00                	push   $0x0
  pushl $244
c0102796:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010279b:	e9 f2 f5 ff ff       	jmp    c0101d92 <__alltraps>

c01027a0 <vector245>:
.globl vector245
vector245:
  pushl $0
c01027a0:	6a 00                	push   $0x0
  pushl $245
c01027a2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027a7:	e9 e6 f5 ff ff       	jmp    c0101d92 <__alltraps>

c01027ac <vector246>:
.globl vector246
vector246:
  pushl $0
c01027ac:	6a 00                	push   $0x0
  pushl $246
c01027ae:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01027b3:	e9 da f5 ff ff       	jmp    c0101d92 <__alltraps>

c01027b8 <vector247>:
.globl vector247
vector247:
  pushl $0
c01027b8:	6a 00                	push   $0x0
  pushl $247
c01027ba:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027bf:	e9 ce f5 ff ff       	jmp    c0101d92 <__alltraps>

c01027c4 <vector248>:
.globl vector248
vector248:
  pushl $0
c01027c4:	6a 00                	push   $0x0
  pushl $248
c01027c6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027cb:	e9 c2 f5 ff ff       	jmp    c0101d92 <__alltraps>

c01027d0 <vector249>:
.globl vector249
vector249:
  pushl $0
c01027d0:	6a 00                	push   $0x0
  pushl $249
c01027d2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027d7:	e9 b6 f5 ff ff       	jmp    c0101d92 <__alltraps>

c01027dc <vector250>:
.globl vector250
vector250:
  pushl $0
c01027dc:	6a 00                	push   $0x0
  pushl $250
c01027de:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027e3:	e9 aa f5 ff ff       	jmp    c0101d92 <__alltraps>

c01027e8 <vector251>:
.globl vector251
vector251:
  pushl $0
c01027e8:	6a 00                	push   $0x0
  pushl $251
c01027ea:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027ef:	e9 9e f5 ff ff       	jmp    c0101d92 <__alltraps>

c01027f4 <vector252>:
.globl vector252
vector252:
  pushl $0
c01027f4:	6a 00                	push   $0x0
  pushl $252
c01027f6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01027fb:	e9 92 f5 ff ff       	jmp    c0101d92 <__alltraps>

c0102800 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102800:	6a 00                	push   $0x0
  pushl $253
c0102802:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102807:	e9 86 f5 ff ff       	jmp    c0101d92 <__alltraps>

c010280c <vector254>:
.globl vector254
vector254:
  pushl $0
c010280c:	6a 00                	push   $0x0
  pushl $254
c010280e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102813:	e9 7a f5 ff ff       	jmp    c0101d92 <__alltraps>

c0102818 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102818:	6a 00                	push   $0x0
  pushl $255
c010281a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010281f:	e9 6e f5 ff ff       	jmp    c0101d92 <__alltraps>

c0102824 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102824:	55                   	push   %ebp
c0102825:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102827:	8b 55 08             	mov    0x8(%ebp),%edx
c010282a:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c010282f:	29 c2                	sub    %eax,%edx
c0102831:	89 d0                	mov    %edx,%eax
c0102833:	c1 f8 02             	sar    $0x2,%eax
c0102836:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010283c:	5d                   	pop    %ebp
c010283d:	c3                   	ret    

c010283e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010283e:	55                   	push   %ebp
c010283f:	89 e5                	mov    %esp,%ebp
c0102841:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102844:	8b 45 08             	mov    0x8(%ebp),%eax
c0102847:	89 04 24             	mov    %eax,(%esp)
c010284a:	e8 d5 ff ff ff       	call   c0102824 <page2ppn>
c010284f:	c1 e0 0c             	shl    $0xc,%eax
}
c0102852:	c9                   	leave  
c0102853:	c3                   	ret    

c0102854 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102854:	55                   	push   %ebp
c0102855:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102857:	8b 45 08             	mov    0x8(%ebp),%eax
c010285a:	8b 00                	mov    (%eax),%eax
}
c010285c:	5d                   	pop    %ebp
c010285d:	c3                   	ret    

c010285e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010285e:	55                   	push   %ebp
c010285f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102861:	8b 45 08             	mov    0x8(%ebp),%eax
c0102864:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102867:	89 10                	mov    %edx,(%eax)
}
c0102869:	5d                   	pop    %ebp
c010286a:	c3                   	ret    

c010286b <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010286b:	55                   	push   %ebp
c010286c:	89 e5                	mov    %esp,%ebp
c010286e:	83 ec 10             	sub    $0x10,%esp
c0102871:	c7 45 fc 10 af 11 c0 	movl   $0xc011af10,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102878:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010287b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010287e:	89 50 04             	mov    %edx,0x4(%eax)
c0102881:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102884:	8b 50 04             	mov    0x4(%eax),%edx
c0102887:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010288a:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010288c:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c0102893:	00 00 00 
}
c0102896:	c9                   	leave  
c0102897:	c3                   	ret    

c0102898 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102898:	55                   	push   %ebp
c0102899:	89 e5                	mov    %esp,%ebp
c010289b:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c010289e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01028a2:	75 24                	jne    c01028c8 <default_init_memmap+0x30>
c01028a4:	c7 44 24 0c 70 66 10 	movl   $0xc0106670,0xc(%esp)
c01028ab:	c0 
c01028ac:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01028b3:	c0 
c01028b4:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01028bb:	00 
c01028bc:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01028c3:	e8 0a e4 ff ff       	call   c0100cd2 <__panic>
    struct Page *p = base;
c01028c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01028cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01028ce:	eb 7d                	jmp    c010294d <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028d3:	83 c0 04             	add    $0x4,%eax
c01028d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01028dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01028e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01028e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01028e6:	0f a3 10             	bt     %edx,(%eax)
c01028e9:	19 c0                	sbb    %eax,%eax
c01028eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01028ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01028f2:	0f 95 c0             	setne  %al
c01028f5:	0f b6 c0             	movzbl %al,%eax
c01028f8:	85 c0                	test   %eax,%eax
c01028fa:	75 24                	jne    c0102920 <default_init_memmap+0x88>
c01028fc:	c7 44 24 0c a1 66 10 	movl   $0xc01066a1,0xc(%esp)
c0102903:	c0 
c0102904:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c010290b:	c0 
c010290c:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0102913:	00 
c0102914:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c010291b:	e8 b2 e3 ff ff       	call   c0100cd2 <__panic>
        p->flags = p->property = 0;
c0102920:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102923:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010292d:	8b 50 08             	mov    0x8(%eax),%edx
c0102930:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102933:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0102936:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010293d:	00 
c010293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102941:	89 04 24             	mov    %eax,(%esp)
c0102944:	e8 15 ff ff ff       	call   c010285e <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102949:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010294d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102950:	89 d0                	mov    %edx,%eax
c0102952:	c1 e0 02             	shl    $0x2,%eax
c0102955:	01 d0                	add    %edx,%eax
c0102957:	c1 e0 02             	shl    $0x2,%eax
c010295a:	89 c2                	mov    %eax,%edx
c010295c:	8b 45 08             	mov    0x8(%ebp),%eax
c010295f:	01 d0                	add    %edx,%eax
c0102961:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102964:	0f 85 66 ff ff ff    	jne    c01028d0 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c010296a:	8b 45 08             	mov    0x8(%ebp),%eax
c010296d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102970:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102973:	8b 45 08             	mov    0x8(%ebp),%eax
c0102976:	83 c0 04             	add    $0x4,%eax
c0102979:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102980:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102983:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102986:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102989:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c010298c:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102992:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102995:	01 d0                	add    %edx,%eax
c0102997:	a3 18 af 11 c0       	mov    %eax,0xc011af18
    list_add_before(&free_list, &(base->page_link));
c010299c:	8b 45 08             	mov    0x8(%ebp),%eax
c010299f:	83 c0 0c             	add    $0xc,%eax
c01029a2:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
c01029a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01029ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029af:	8b 00                	mov    (%eax),%eax
c01029b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01029b4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01029b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01029ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029bd:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01029c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01029c6:	89 10                	mov    %edx,(%eax)
c01029c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029cb:	8b 10                	mov    (%eax),%edx
c01029cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01029d0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01029d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029d6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01029d9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01029dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029df:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01029e2:	89 10                	mov    %edx,(%eax)
}
c01029e4:	c9                   	leave  
c01029e5:	c3                   	ret    

c01029e6 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01029e6:	55                   	push   %ebp
c01029e7:	89 e5                	mov    %esp,%ebp
c01029e9:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01029ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01029f0:	75 24                	jne    c0102a16 <default_alloc_pages+0x30>
c01029f2:	c7 44 24 0c 70 66 10 	movl   $0xc0106670,0xc(%esp)
c01029f9:	c0 
c01029fa:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0102a01:	c0 
c0102a02:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0102a09:	00 
c0102a0a:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0102a11:	e8 bc e2 ff ff       	call   c0100cd2 <__panic>
    if (n > nr_free) {
c0102a16:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102a1b:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a1e:	73 0a                	jae    c0102a2a <default_alloc_pages+0x44>
        return NULL;
c0102a20:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a25:	e9 3d 01 00 00       	jmp    c0102b67 <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
c0102a2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102a31:	c7 45 f0 10 af 11 c0 	movl   $0xc011af10,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c0102a38:	eb 1c                	jmp    c0102a56 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a3d:	83 e8 0c             	sub    $0xc,%eax
c0102a40:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102a43:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a46:	8b 40 08             	mov    0x8(%eax),%eax
c0102a49:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a4c:	72 08                	jb     c0102a56 <default_alloc_pages+0x70>
            page = p;
c0102a4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102a54:	eb 18                	jmp    c0102a6e <default_alloc_pages+0x88>
c0102a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a5f:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c0102a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a65:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102a6c:	75 cc                	jne    c0102a3a <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102a6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102a72:	0f 84 ec 00 00 00    	je     c0102b64 <default_alloc_pages+0x17e>
        if (page->property > n) {
c0102a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a7b:	8b 40 08             	mov    0x8(%eax),%eax
c0102a7e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a81:	0f 86 8c 00 00 00    	jbe    c0102b13 <default_alloc_pages+0x12d>
            struct Page *p = page + n;
c0102a87:	8b 55 08             	mov    0x8(%ebp),%edx
c0102a8a:	89 d0                	mov    %edx,%eax
c0102a8c:	c1 e0 02             	shl    $0x2,%eax
c0102a8f:	01 d0                	add    %edx,%eax
c0102a91:	c1 e0 02             	shl    $0x2,%eax
c0102a94:	89 c2                	mov    %eax,%edx
c0102a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a99:	01 d0                	add    %edx,%eax
c0102a9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aa1:	8b 40 08             	mov    0x8(%eax),%eax
c0102aa4:	2b 45 08             	sub    0x8(%ebp),%eax
c0102aa7:	89 c2                	mov    %eax,%edx
c0102aa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102aac:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0102aaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ab2:	83 c0 04             	add    $0x4,%eax
c0102ab5:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102abc:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102abf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ac2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102ac5:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0102ac8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102acb:	83 c0 0c             	add    $0xc,%eax
c0102ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102ad1:	83 c2 0c             	add    $0xc,%edx
c0102ad4:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102ad7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102ada:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102add:	8b 40 04             	mov    0x4(%eax),%eax
c0102ae0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ae3:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102ae6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102ae9:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102aec:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102aef:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102af2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102af5:	89 10                	mov    %edx,(%eax)
c0102af7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102afa:	8b 10                	mov    (%eax),%edx
c0102afc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102aff:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b02:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b05:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b08:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b0b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b0e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b11:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0102b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b16:	83 c0 0c             	add    $0xc,%eax
c0102b19:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b1f:	8b 40 04             	mov    0x4(%eax),%eax
c0102b22:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b25:	8b 12                	mov    (%edx),%edx
c0102b27:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102b2a:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b2d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b30:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b33:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b36:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b39:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b3c:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0102b3e:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102b43:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b46:	a3 18 af 11 c0       	mov    %eax,0xc011af18
        ClearPageProperty(page);
c0102b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b4e:	83 c0 04             	add    $0x4,%eax
c0102b51:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102b58:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b5b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b5e:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b61:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102b67:	c9                   	leave  
c0102b68:	c3                   	ret    

c0102b69 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102b69:	55                   	push   %ebp
c0102b6a:	89 e5                	mov    %esp,%ebp
c0102b6c:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102b76:	75 24                	jne    c0102b9c <default_free_pages+0x33>
c0102b78:	c7 44 24 0c 70 66 10 	movl   $0xc0106670,0xc(%esp)
c0102b7f:	c0 
c0102b80:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0102b87:	c0 
c0102b88:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0102b8f:	00 
c0102b90:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0102b97:	e8 36 e1 ff ff       	call   c0100cd2 <__panic>
    struct Page *p = base;
c0102b9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102ba2:	e9 9d 00 00 00       	jmp    c0102c44 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102baa:	83 c0 04             	add    $0x4,%eax
c0102bad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102bb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102bb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bba:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102bbd:	0f a3 10             	bt     %edx,(%eax)
c0102bc0:	19 c0                	sbb    %eax,%eax
c0102bc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102bc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102bc9:	0f 95 c0             	setne  %al
c0102bcc:	0f b6 c0             	movzbl %al,%eax
c0102bcf:	85 c0                	test   %eax,%eax
c0102bd1:	75 2c                	jne    c0102bff <default_free_pages+0x96>
c0102bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bd6:	83 c0 04             	add    $0x4,%eax
c0102bd9:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102be0:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102be3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102be6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102be9:	0f a3 10             	bt     %edx,(%eax)
c0102bec:	19 c0                	sbb    %eax,%eax
c0102bee:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102bf1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102bf5:	0f 95 c0             	setne  %al
c0102bf8:	0f b6 c0             	movzbl %al,%eax
c0102bfb:	85 c0                	test   %eax,%eax
c0102bfd:	74 24                	je     c0102c23 <default_free_pages+0xba>
c0102bff:	c7 44 24 0c b4 66 10 	movl   $0xc01066b4,0xc(%esp)
c0102c06:	c0 
c0102c07:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0102c0e:	c0 
c0102c0f:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0102c16:	00 
c0102c17:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0102c1e:	e8 af e0 ff ff       	call   c0100cd2 <__panic>
        p->flags = 0;
c0102c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102c2d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c34:	00 
c0102c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c38:	89 04 24             	mov    %eax,(%esp)
c0102c3b:	e8 1e fc ff ff       	call   c010285e <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102c40:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c44:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c47:	89 d0                	mov    %edx,%eax
c0102c49:	c1 e0 02             	shl    $0x2,%eax
c0102c4c:	01 d0                	add    %edx,%eax
c0102c4e:	c1 e0 02             	shl    $0x2,%eax
c0102c51:	89 c2                	mov    %eax,%edx
c0102c53:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c56:	01 d0                	add    %edx,%eax
c0102c58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102c5b:	0f 85 46 ff ff ff    	jne    c0102ba7 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102c61:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c64:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c67:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102c6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c6d:	83 c0 04             	add    $0x4,%eax
c0102c70:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102c77:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c7d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c80:	0f ab 10             	bts    %edx,(%eax)
c0102c83:	c7 45 cc 10 af 11 c0 	movl   $0xc011af10,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102c8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c8d:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102c93:	e9 08 01 00 00       	jmp    c0102da0 <default_free_pages+0x237>
        p = le2page(le, page_link);
c0102c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c9b:	83 e8 0c             	sub    $0xc,%eax
c0102c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ca4:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102ca7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102caa:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cb3:	8b 50 08             	mov    0x8(%eax),%edx
c0102cb6:	89 d0                	mov    %edx,%eax
c0102cb8:	c1 e0 02             	shl    $0x2,%eax
c0102cbb:	01 d0                	add    %edx,%eax
c0102cbd:	c1 e0 02             	shl    $0x2,%eax
c0102cc0:	89 c2                	mov    %eax,%edx
c0102cc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cc5:	01 d0                	add    %edx,%eax
c0102cc7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cca:	75 5a                	jne    c0102d26 <default_free_pages+0x1bd>
            base->property += p->property;
c0102ccc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ccf:	8b 50 08             	mov    0x8(%eax),%edx
c0102cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cd5:	8b 40 08             	mov    0x8(%eax),%eax
c0102cd8:	01 c2                	add    %eax,%edx
c0102cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cdd:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ce3:	83 c0 04             	add    $0x4,%eax
c0102ce6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102ced:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cf0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102cf3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102cf6:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cfc:	83 c0 0c             	add    $0xc,%eax
c0102cff:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102d02:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d05:	8b 40 04             	mov    0x4(%eax),%eax
c0102d08:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d0b:	8b 12                	mov    (%edx),%edx
c0102d0d:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102d10:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d13:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d16:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d19:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d1c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d1f:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d22:	89 10                	mov    %edx,(%eax)
c0102d24:	eb 7a                	jmp    c0102da0 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0102d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d29:	8b 50 08             	mov    0x8(%eax),%edx
c0102d2c:	89 d0                	mov    %edx,%eax
c0102d2e:	c1 e0 02             	shl    $0x2,%eax
c0102d31:	01 d0                	add    %edx,%eax
c0102d33:	c1 e0 02             	shl    $0x2,%eax
c0102d36:	89 c2                	mov    %eax,%edx
c0102d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d3b:	01 d0                	add    %edx,%eax
c0102d3d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d40:	75 5e                	jne    c0102da0 <default_free_pages+0x237>
            p->property += base->property;
c0102d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d45:	8b 50 08             	mov    0x8(%eax),%edx
c0102d48:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d4b:	8b 40 08             	mov    0x8(%eax),%eax
c0102d4e:	01 c2                	add    %eax,%edx
c0102d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d53:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102d56:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d59:	83 c0 04             	add    $0x4,%eax
c0102d5c:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102d63:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102d66:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102d69:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102d6c:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d72:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d78:	83 c0 0c             	add    $0xc,%eax
c0102d7b:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102d7e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102d81:	8b 40 04             	mov    0x4(%eax),%eax
c0102d84:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102d87:	8b 12                	mov    (%edx),%edx
c0102d89:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102d8c:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d8f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102d92:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102d95:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d98:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102d9b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102d9e:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102da0:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102da7:	0f 85 eb fe ff ff    	jne    c0102c98 <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0102dad:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102db3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102db6:	01 d0                	add    %edx,%eax
c0102db8:	a3 18 af 11 c0       	mov    %eax,0xc011af18
c0102dbd:	c7 45 9c 10 af 11 c0 	movl   $0xc011af10,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102dc4:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102dc7:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0102dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102dcd:	eb 76                	jmp    c0102e45 <default_free_pages+0x2dc>
        p = le2page(le, page_link);
c0102dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dd2:	83 e8 0c             	sub    $0xc,%eax
c0102dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0102dd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ddb:	8b 50 08             	mov    0x8(%eax),%edx
c0102dde:	89 d0                	mov    %edx,%eax
c0102de0:	c1 e0 02             	shl    $0x2,%eax
c0102de3:	01 d0                	add    %edx,%eax
c0102de5:	c1 e0 02             	shl    $0x2,%eax
c0102de8:	89 c2                	mov    %eax,%edx
c0102dea:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ded:	01 d0                	add    %edx,%eax
c0102def:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102df2:	77 42                	ja     c0102e36 <default_free_pages+0x2cd>
            assert(base + base->property != p);
c0102df4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102df7:	8b 50 08             	mov    0x8(%eax),%edx
c0102dfa:	89 d0                	mov    %edx,%eax
c0102dfc:	c1 e0 02             	shl    $0x2,%eax
c0102dff:	01 d0                	add    %edx,%eax
c0102e01:	c1 e0 02             	shl    $0x2,%eax
c0102e04:	89 c2                	mov    %eax,%edx
c0102e06:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e09:	01 d0                	add    %edx,%eax
c0102e0b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e0e:	75 24                	jne    c0102e34 <default_free_pages+0x2cb>
c0102e10:	c7 44 24 0c d9 66 10 	movl   $0xc01066d9,0xc(%esp)
c0102e17:	c0 
c0102e18:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0102e1f:	c0 
c0102e20:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0102e27:	00 
c0102e28:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0102e2f:	e8 9e de ff ff       	call   c0100cd2 <__panic>
            break;
c0102e34:	eb 18                	jmp    c0102e4e <default_free_pages+0x2e5>
c0102e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e39:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102e3c:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e3f:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c0102e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
    le = list_next(&free_list);
    while (le != &free_list) {
c0102e45:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102e4c:	75 81                	jne    c0102dcf <default_free_pages+0x266>
            assert(base + base->property != p);
            break;
        }
        le = list_next(le);
    }
    list_add_before(le, &(base->page_link));
c0102e4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e51:	8d 50 0c             	lea    0xc(%eax),%edx
c0102e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e57:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102e5a:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102e5d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e60:	8b 00                	mov    (%eax),%eax
c0102e62:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e65:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102e68:	89 45 88             	mov    %eax,-0x78(%ebp)
c0102e6b:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e6e:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102e71:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e74:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102e77:	89 10                	mov    %edx,(%eax)
c0102e79:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e7c:	8b 10                	mov    (%eax),%edx
c0102e7e:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102e81:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102e84:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e87:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102e8a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102e8d:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e90:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102e93:	89 10                	mov    %edx,(%eax)
}
c0102e95:	c9                   	leave  
c0102e96:	c3                   	ret    

c0102e97 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e97:	55                   	push   %ebp
c0102e98:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e9a:	a1 18 af 11 c0       	mov    0xc011af18,%eax
}
c0102e9f:	5d                   	pop    %ebp
c0102ea0:	c3                   	ret    

c0102ea1 <basic_check>:

static void
basic_check(void) {
c0102ea1:	55                   	push   %ebp
c0102ea2:	89 e5                	mov    %esp,%ebp
c0102ea4:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102ea7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102eb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102eba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ec1:	e8 9d 0e 00 00       	call   c0103d63 <alloc_pages>
c0102ec6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102ec9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102ecd:	75 24                	jne    c0102ef3 <basic_check+0x52>
c0102ecf:	c7 44 24 0c f4 66 10 	movl   $0xc01066f4,0xc(%esp)
c0102ed6:	c0 
c0102ed7:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0102ede:	c0 
c0102edf:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0102ee6:	00 
c0102ee7:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0102eee:	e8 df dd ff ff       	call   c0100cd2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102ef3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102efa:	e8 64 0e 00 00       	call   c0103d63 <alloc_pages>
c0102eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102f06:	75 24                	jne    c0102f2c <basic_check+0x8b>
c0102f08:	c7 44 24 0c 10 67 10 	movl   $0xc0106710,0xc(%esp)
c0102f0f:	c0 
c0102f10:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0102f17:	c0 
c0102f18:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0102f1f:	00 
c0102f20:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0102f27:	e8 a6 dd ff ff       	call   c0100cd2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102f2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f33:	e8 2b 0e 00 00       	call   c0103d63 <alloc_pages>
c0102f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f3f:	75 24                	jne    c0102f65 <basic_check+0xc4>
c0102f41:	c7 44 24 0c 2c 67 10 	movl   $0xc010672c,0xc(%esp)
c0102f48:	c0 
c0102f49:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0102f50:	c0 
c0102f51:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0102f58:	00 
c0102f59:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0102f60:	e8 6d dd ff ff       	call   c0100cd2 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f68:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f6b:	74 10                	je     c0102f7d <basic_check+0xdc>
c0102f6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f70:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f73:	74 08                	je     c0102f7d <basic_check+0xdc>
c0102f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f78:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f7b:	75 24                	jne    c0102fa1 <basic_check+0x100>
c0102f7d:	c7 44 24 0c 48 67 10 	movl   $0xc0106748,0xc(%esp)
c0102f84:	c0 
c0102f85:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0102f8c:	c0 
c0102f8d:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0102f94:	00 
c0102f95:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0102f9c:	e8 31 dd ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fa4:	89 04 24             	mov    %eax,(%esp)
c0102fa7:	e8 a8 f8 ff ff       	call   c0102854 <page_ref>
c0102fac:	85 c0                	test   %eax,%eax
c0102fae:	75 1e                	jne    c0102fce <basic_check+0x12d>
c0102fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fb3:	89 04 24             	mov    %eax,(%esp)
c0102fb6:	e8 99 f8 ff ff       	call   c0102854 <page_ref>
c0102fbb:	85 c0                	test   %eax,%eax
c0102fbd:	75 0f                	jne    c0102fce <basic_check+0x12d>
c0102fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fc2:	89 04 24             	mov    %eax,(%esp)
c0102fc5:	e8 8a f8 ff ff       	call   c0102854 <page_ref>
c0102fca:	85 c0                	test   %eax,%eax
c0102fcc:	74 24                	je     c0102ff2 <basic_check+0x151>
c0102fce:	c7 44 24 0c 6c 67 10 	movl   $0xc010676c,0xc(%esp)
c0102fd5:	c0 
c0102fd6:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0102fdd:	c0 
c0102fde:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0102fe5:	00 
c0102fe6:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0102fed:	e8 e0 dc ff ff       	call   c0100cd2 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ff5:	89 04 24             	mov    %eax,(%esp)
c0102ff8:	e8 41 f8 ff ff       	call   c010283e <page2pa>
c0102ffd:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0103003:	c1 e2 0c             	shl    $0xc,%edx
c0103006:	39 d0                	cmp    %edx,%eax
c0103008:	72 24                	jb     c010302e <basic_check+0x18d>
c010300a:	c7 44 24 0c a8 67 10 	movl   $0xc01067a8,0xc(%esp)
c0103011:	c0 
c0103012:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103019:	c0 
c010301a:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103021:	00 
c0103022:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103029:	e8 a4 dc ff ff       	call   c0100cd2 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010302e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103031:	89 04 24             	mov    %eax,(%esp)
c0103034:	e8 05 f8 ff ff       	call   c010283e <page2pa>
c0103039:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c010303f:	c1 e2 0c             	shl    $0xc,%edx
c0103042:	39 d0                	cmp    %edx,%eax
c0103044:	72 24                	jb     c010306a <basic_check+0x1c9>
c0103046:	c7 44 24 0c c5 67 10 	movl   $0xc01067c5,0xc(%esp)
c010304d:	c0 
c010304e:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103055:	c0 
c0103056:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c010305d:	00 
c010305e:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103065:	e8 68 dc ff ff       	call   c0100cd2 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010306d:	89 04 24             	mov    %eax,(%esp)
c0103070:	e8 c9 f7 ff ff       	call   c010283e <page2pa>
c0103075:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c010307b:	c1 e2 0c             	shl    $0xc,%edx
c010307e:	39 d0                	cmp    %edx,%eax
c0103080:	72 24                	jb     c01030a6 <basic_check+0x205>
c0103082:	c7 44 24 0c e2 67 10 	movl   $0xc01067e2,0xc(%esp)
c0103089:	c0 
c010308a:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103091:	c0 
c0103092:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103099:	00 
c010309a:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01030a1:	e8 2c dc ff ff       	call   c0100cd2 <__panic>

    list_entry_t free_list_store = free_list;
c01030a6:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c01030ab:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c01030b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030b4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01030b7:	c7 45 e0 10 af 11 c0 	movl   $0xc011af10,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01030be:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01030c4:	89 50 04             	mov    %edx,0x4(%eax)
c01030c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030ca:	8b 50 04             	mov    0x4(%eax),%edx
c01030cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030d0:	89 10                	mov    %edx,(%eax)
c01030d2:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01030d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01030dc:	8b 40 04             	mov    0x4(%eax),%eax
c01030df:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01030e2:	0f 94 c0             	sete   %al
c01030e5:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01030e8:	85 c0                	test   %eax,%eax
c01030ea:	75 24                	jne    c0103110 <basic_check+0x26f>
c01030ec:	c7 44 24 0c ff 67 10 	movl   $0xc01067ff,0xc(%esp)
c01030f3:	c0 
c01030f4:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01030fb:	c0 
c01030fc:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103103:	00 
c0103104:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c010310b:	e8 c2 db ff ff       	call   c0100cd2 <__panic>

    unsigned int nr_free_store = nr_free;
c0103110:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103115:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103118:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c010311f:	00 00 00 

    assert(alloc_page() == NULL);
c0103122:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103129:	e8 35 0c 00 00       	call   c0103d63 <alloc_pages>
c010312e:	85 c0                	test   %eax,%eax
c0103130:	74 24                	je     c0103156 <basic_check+0x2b5>
c0103132:	c7 44 24 0c 16 68 10 	movl   $0xc0106816,0xc(%esp)
c0103139:	c0 
c010313a:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103141:	c0 
c0103142:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103149:	00 
c010314a:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103151:	e8 7c db ff ff       	call   c0100cd2 <__panic>

    free_page(p0);
c0103156:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010315d:	00 
c010315e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103161:	89 04 24             	mov    %eax,(%esp)
c0103164:	e8 32 0c 00 00       	call   c0103d9b <free_pages>
    free_page(p1);
c0103169:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103170:	00 
c0103171:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103174:	89 04 24             	mov    %eax,(%esp)
c0103177:	e8 1f 0c 00 00       	call   c0103d9b <free_pages>
    free_page(p2);
c010317c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103183:	00 
c0103184:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103187:	89 04 24             	mov    %eax,(%esp)
c010318a:	e8 0c 0c 00 00       	call   c0103d9b <free_pages>
    assert(nr_free == 3);
c010318f:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103194:	83 f8 03             	cmp    $0x3,%eax
c0103197:	74 24                	je     c01031bd <basic_check+0x31c>
c0103199:	c7 44 24 0c 2b 68 10 	movl   $0xc010682b,0xc(%esp)
c01031a0:	c0 
c01031a1:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01031a8:	c0 
c01031a9:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01031b0:	00 
c01031b1:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01031b8:	e8 15 db ff ff       	call   c0100cd2 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01031bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031c4:	e8 9a 0b 00 00       	call   c0103d63 <alloc_pages>
c01031c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01031d0:	75 24                	jne    c01031f6 <basic_check+0x355>
c01031d2:	c7 44 24 0c f4 66 10 	movl   $0xc01066f4,0xc(%esp)
c01031d9:	c0 
c01031da:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01031e1:	c0 
c01031e2:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01031e9:	00 
c01031ea:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01031f1:	e8 dc da ff ff       	call   c0100cd2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01031f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031fd:	e8 61 0b 00 00       	call   c0103d63 <alloc_pages>
c0103202:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103205:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103209:	75 24                	jne    c010322f <basic_check+0x38e>
c010320b:	c7 44 24 0c 10 67 10 	movl   $0xc0106710,0xc(%esp)
c0103212:	c0 
c0103213:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c010321a:	c0 
c010321b:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103222:	00 
c0103223:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c010322a:	e8 a3 da ff ff       	call   c0100cd2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010322f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103236:	e8 28 0b 00 00       	call   c0103d63 <alloc_pages>
c010323b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010323e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103242:	75 24                	jne    c0103268 <basic_check+0x3c7>
c0103244:	c7 44 24 0c 2c 67 10 	movl   $0xc010672c,0xc(%esp)
c010324b:	c0 
c010324c:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103253:	c0 
c0103254:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c010325b:	00 
c010325c:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103263:	e8 6a da ff ff       	call   c0100cd2 <__panic>

    assert(alloc_page() == NULL);
c0103268:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010326f:	e8 ef 0a 00 00       	call   c0103d63 <alloc_pages>
c0103274:	85 c0                	test   %eax,%eax
c0103276:	74 24                	je     c010329c <basic_check+0x3fb>
c0103278:	c7 44 24 0c 16 68 10 	movl   $0xc0106816,0xc(%esp)
c010327f:	c0 
c0103280:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103287:	c0 
c0103288:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c010328f:	00 
c0103290:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103297:	e8 36 da ff ff       	call   c0100cd2 <__panic>

    free_page(p0);
c010329c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032a3:	00 
c01032a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032a7:	89 04 24             	mov    %eax,(%esp)
c01032aa:	e8 ec 0a 00 00       	call   c0103d9b <free_pages>
c01032af:	c7 45 d8 10 af 11 c0 	movl   $0xc011af10,-0x28(%ebp)
c01032b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01032b9:	8b 40 04             	mov    0x4(%eax),%eax
c01032bc:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01032bf:	0f 94 c0             	sete   %al
c01032c2:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01032c5:	85 c0                	test   %eax,%eax
c01032c7:	74 24                	je     c01032ed <basic_check+0x44c>
c01032c9:	c7 44 24 0c 38 68 10 	movl   $0xc0106838,0xc(%esp)
c01032d0:	c0 
c01032d1:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01032d8:	c0 
c01032d9:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c01032e0:	00 
c01032e1:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01032e8:	e8 e5 d9 ff ff       	call   c0100cd2 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01032ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032f4:	e8 6a 0a 00 00       	call   c0103d63 <alloc_pages>
c01032f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01032fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032ff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103302:	74 24                	je     c0103328 <basic_check+0x487>
c0103304:	c7 44 24 0c 50 68 10 	movl   $0xc0106850,0xc(%esp)
c010330b:	c0 
c010330c:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103313:	c0 
c0103314:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c010331b:	00 
c010331c:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103323:	e8 aa d9 ff ff       	call   c0100cd2 <__panic>
    assert(alloc_page() == NULL);
c0103328:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010332f:	e8 2f 0a 00 00       	call   c0103d63 <alloc_pages>
c0103334:	85 c0                	test   %eax,%eax
c0103336:	74 24                	je     c010335c <basic_check+0x4bb>
c0103338:	c7 44 24 0c 16 68 10 	movl   $0xc0106816,0xc(%esp)
c010333f:	c0 
c0103340:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103347:	c0 
c0103348:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c010334f:	00 
c0103350:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103357:	e8 76 d9 ff ff       	call   c0100cd2 <__panic>

    assert(nr_free == 0);
c010335c:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103361:	85 c0                	test   %eax,%eax
c0103363:	74 24                	je     c0103389 <basic_check+0x4e8>
c0103365:	c7 44 24 0c 69 68 10 	movl   $0xc0106869,0xc(%esp)
c010336c:	c0 
c010336d:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103374:	c0 
c0103375:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c010337c:	00 
c010337d:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103384:	e8 49 d9 ff ff       	call   c0100cd2 <__panic>
    free_list = free_list_store;
c0103389:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010338c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010338f:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c0103394:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    nr_free = nr_free_store;
c010339a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010339d:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_page(p);
c01033a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033a9:	00 
c01033aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033ad:	89 04 24             	mov    %eax,(%esp)
c01033b0:	e8 e6 09 00 00       	call   c0103d9b <free_pages>
    free_page(p1);
c01033b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033bc:	00 
c01033bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033c0:	89 04 24             	mov    %eax,(%esp)
c01033c3:	e8 d3 09 00 00       	call   c0103d9b <free_pages>
    free_page(p2);
c01033c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033cf:	00 
c01033d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033d3:	89 04 24             	mov    %eax,(%esp)
c01033d6:	e8 c0 09 00 00       	call   c0103d9b <free_pages>
}
c01033db:	c9                   	leave  
c01033dc:	c3                   	ret    

c01033dd <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01033dd:	55                   	push   %ebp
c01033de:	89 e5                	mov    %esp,%ebp
c01033e0:	53                   	push   %ebx
c01033e1:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01033e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01033ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01033f5:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01033fc:	eb 6b                	jmp    c0103469 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01033fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103401:	83 e8 0c             	sub    $0xc,%eax
c0103404:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103407:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010340a:	83 c0 04             	add    $0x4,%eax
c010340d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103414:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103417:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010341a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010341d:	0f a3 10             	bt     %edx,(%eax)
c0103420:	19 c0                	sbb    %eax,%eax
c0103422:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103425:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103429:	0f 95 c0             	setne  %al
c010342c:	0f b6 c0             	movzbl %al,%eax
c010342f:	85 c0                	test   %eax,%eax
c0103431:	75 24                	jne    c0103457 <default_check+0x7a>
c0103433:	c7 44 24 0c 76 68 10 	movl   $0xc0106876,0xc(%esp)
c010343a:	c0 
c010343b:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103442:	c0 
c0103443:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c010344a:	00 
c010344b:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103452:	e8 7b d8 ff ff       	call   c0100cd2 <__panic>
        count ++, total += p->property;
c0103457:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010345b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010345e:	8b 50 08             	mov    0x8(%eax),%edx
c0103461:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103464:	01 d0                	add    %edx,%eax
c0103466:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103469:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010346c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010346f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103472:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103475:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103478:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c010347f:	0f 85 79 ff ff ff    	jne    c01033fe <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103485:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103488:	e8 40 09 00 00       	call   c0103dcd <nr_free_pages>
c010348d:	39 c3                	cmp    %eax,%ebx
c010348f:	74 24                	je     c01034b5 <default_check+0xd8>
c0103491:	c7 44 24 0c 86 68 10 	movl   $0xc0106886,0xc(%esp)
c0103498:	c0 
c0103499:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01034a0:	c0 
c01034a1:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01034a8:	00 
c01034a9:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01034b0:	e8 1d d8 ff ff       	call   c0100cd2 <__panic>

    basic_check();
c01034b5:	e8 e7 f9 ff ff       	call   c0102ea1 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01034ba:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01034c1:	e8 9d 08 00 00       	call   c0103d63 <alloc_pages>
c01034c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01034c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01034cd:	75 24                	jne    c01034f3 <default_check+0x116>
c01034cf:	c7 44 24 0c 9f 68 10 	movl   $0xc010689f,0xc(%esp)
c01034d6:	c0 
c01034d7:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01034de:	c0 
c01034df:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c01034e6:	00 
c01034e7:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01034ee:	e8 df d7 ff ff       	call   c0100cd2 <__panic>
    assert(!PageProperty(p0));
c01034f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034f6:	83 c0 04             	add    $0x4,%eax
c01034f9:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103500:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103503:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103506:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103509:	0f a3 10             	bt     %edx,(%eax)
c010350c:	19 c0                	sbb    %eax,%eax
c010350e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103511:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103515:	0f 95 c0             	setne  %al
c0103518:	0f b6 c0             	movzbl %al,%eax
c010351b:	85 c0                	test   %eax,%eax
c010351d:	74 24                	je     c0103543 <default_check+0x166>
c010351f:	c7 44 24 0c aa 68 10 	movl   $0xc01068aa,0xc(%esp)
c0103526:	c0 
c0103527:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c010352e:	c0 
c010352f:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0103536:	00 
c0103537:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c010353e:	e8 8f d7 ff ff       	call   c0100cd2 <__panic>

    list_entry_t free_list_store = free_list;
c0103543:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0103548:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c010354e:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103551:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103554:	c7 45 b4 10 af 11 c0 	movl   $0xc011af10,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010355b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010355e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103561:	89 50 04             	mov    %edx,0x4(%eax)
c0103564:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103567:	8b 50 04             	mov    0x4(%eax),%edx
c010356a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010356d:	89 10                	mov    %edx,(%eax)
c010356f:	c7 45 b0 10 af 11 c0 	movl   $0xc011af10,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103576:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103579:	8b 40 04             	mov    0x4(%eax),%eax
c010357c:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c010357f:	0f 94 c0             	sete   %al
c0103582:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103585:	85 c0                	test   %eax,%eax
c0103587:	75 24                	jne    c01035ad <default_check+0x1d0>
c0103589:	c7 44 24 0c ff 67 10 	movl   $0xc01067ff,0xc(%esp)
c0103590:	c0 
c0103591:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103598:	c0 
c0103599:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01035a0:	00 
c01035a1:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01035a8:	e8 25 d7 ff ff       	call   c0100cd2 <__panic>
    assert(alloc_page() == NULL);
c01035ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035b4:	e8 aa 07 00 00       	call   c0103d63 <alloc_pages>
c01035b9:	85 c0                	test   %eax,%eax
c01035bb:	74 24                	je     c01035e1 <default_check+0x204>
c01035bd:	c7 44 24 0c 16 68 10 	movl   $0xc0106816,0xc(%esp)
c01035c4:	c0 
c01035c5:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01035cc:	c0 
c01035cd:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01035d4:	00 
c01035d5:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01035dc:	e8 f1 d6 ff ff       	call   c0100cd2 <__panic>

    unsigned int nr_free_store = nr_free;
c01035e1:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c01035e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01035e9:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c01035f0:	00 00 00 

    free_pages(p0 + 2, 3);
c01035f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035f6:	83 c0 28             	add    $0x28,%eax
c01035f9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103600:	00 
c0103601:	89 04 24             	mov    %eax,(%esp)
c0103604:	e8 92 07 00 00       	call   c0103d9b <free_pages>
    assert(alloc_pages(4) == NULL);
c0103609:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103610:	e8 4e 07 00 00       	call   c0103d63 <alloc_pages>
c0103615:	85 c0                	test   %eax,%eax
c0103617:	74 24                	je     c010363d <default_check+0x260>
c0103619:	c7 44 24 0c bc 68 10 	movl   $0xc01068bc,0xc(%esp)
c0103620:	c0 
c0103621:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103628:	c0 
c0103629:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0103630:	00 
c0103631:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103638:	e8 95 d6 ff ff       	call   c0100cd2 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010363d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103640:	83 c0 28             	add    $0x28,%eax
c0103643:	83 c0 04             	add    $0x4,%eax
c0103646:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010364d:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103650:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103653:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103656:	0f a3 10             	bt     %edx,(%eax)
c0103659:	19 c0                	sbb    %eax,%eax
c010365b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010365e:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103662:	0f 95 c0             	setne  %al
c0103665:	0f b6 c0             	movzbl %al,%eax
c0103668:	85 c0                	test   %eax,%eax
c010366a:	74 0e                	je     c010367a <default_check+0x29d>
c010366c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010366f:	83 c0 28             	add    $0x28,%eax
c0103672:	8b 40 08             	mov    0x8(%eax),%eax
c0103675:	83 f8 03             	cmp    $0x3,%eax
c0103678:	74 24                	je     c010369e <default_check+0x2c1>
c010367a:	c7 44 24 0c d4 68 10 	movl   $0xc01068d4,0xc(%esp)
c0103681:	c0 
c0103682:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103689:	c0 
c010368a:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0103691:	00 
c0103692:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103699:	e8 34 d6 ff ff       	call   c0100cd2 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010369e:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01036a5:	e8 b9 06 00 00       	call   c0103d63 <alloc_pages>
c01036aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01036ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01036b1:	75 24                	jne    c01036d7 <default_check+0x2fa>
c01036b3:	c7 44 24 0c 00 69 10 	movl   $0xc0106900,0xc(%esp)
c01036ba:	c0 
c01036bb:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01036c2:	c0 
c01036c3:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c01036ca:	00 
c01036cb:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01036d2:	e8 fb d5 ff ff       	call   c0100cd2 <__panic>
    assert(alloc_page() == NULL);
c01036d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036de:	e8 80 06 00 00       	call   c0103d63 <alloc_pages>
c01036e3:	85 c0                	test   %eax,%eax
c01036e5:	74 24                	je     c010370b <default_check+0x32e>
c01036e7:	c7 44 24 0c 16 68 10 	movl   $0xc0106816,0xc(%esp)
c01036ee:	c0 
c01036ef:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01036f6:	c0 
c01036f7:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01036fe:	00 
c01036ff:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103706:	e8 c7 d5 ff ff       	call   c0100cd2 <__panic>
    assert(p0 + 2 == p1);
c010370b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010370e:	83 c0 28             	add    $0x28,%eax
c0103711:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103714:	74 24                	je     c010373a <default_check+0x35d>
c0103716:	c7 44 24 0c 1e 69 10 	movl   $0xc010691e,0xc(%esp)
c010371d:	c0 
c010371e:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103725:	c0 
c0103726:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c010372d:	00 
c010372e:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103735:	e8 98 d5 ff ff       	call   c0100cd2 <__panic>

    p2 = p0 + 1;
c010373a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010373d:	83 c0 14             	add    $0x14,%eax
c0103740:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103743:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010374a:	00 
c010374b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010374e:	89 04 24             	mov    %eax,(%esp)
c0103751:	e8 45 06 00 00       	call   c0103d9b <free_pages>
    free_pages(p1, 3);
c0103756:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010375d:	00 
c010375e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103761:	89 04 24             	mov    %eax,(%esp)
c0103764:	e8 32 06 00 00       	call   c0103d9b <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010376c:	83 c0 04             	add    $0x4,%eax
c010376f:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103776:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103779:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010377c:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010377f:	0f a3 10             	bt     %edx,(%eax)
c0103782:	19 c0                	sbb    %eax,%eax
c0103784:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103787:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010378b:	0f 95 c0             	setne  %al
c010378e:	0f b6 c0             	movzbl %al,%eax
c0103791:	85 c0                	test   %eax,%eax
c0103793:	74 0b                	je     c01037a0 <default_check+0x3c3>
c0103795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103798:	8b 40 08             	mov    0x8(%eax),%eax
c010379b:	83 f8 01             	cmp    $0x1,%eax
c010379e:	74 24                	je     c01037c4 <default_check+0x3e7>
c01037a0:	c7 44 24 0c 2c 69 10 	movl   $0xc010692c,0xc(%esp)
c01037a7:	c0 
c01037a8:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01037af:	c0 
c01037b0:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c01037b7:	00 
c01037b8:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01037bf:	e8 0e d5 ff ff       	call   c0100cd2 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01037c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037c7:	83 c0 04             	add    $0x4,%eax
c01037ca:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01037d1:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037d4:	8b 45 90             	mov    -0x70(%ebp),%eax
c01037d7:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01037da:	0f a3 10             	bt     %edx,(%eax)
c01037dd:	19 c0                	sbb    %eax,%eax
c01037df:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01037e2:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01037e6:	0f 95 c0             	setne  %al
c01037e9:	0f b6 c0             	movzbl %al,%eax
c01037ec:	85 c0                	test   %eax,%eax
c01037ee:	74 0b                	je     c01037fb <default_check+0x41e>
c01037f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037f3:	8b 40 08             	mov    0x8(%eax),%eax
c01037f6:	83 f8 03             	cmp    $0x3,%eax
c01037f9:	74 24                	je     c010381f <default_check+0x442>
c01037fb:	c7 44 24 0c 54 69 10 	movl   $0xc0106954,0xc(%esp)
c0103802:	c0 
c0103803:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c010380a:	c0 
c010380b:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0103812:	00 
c0103813:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c010381a:	e8 b3 d4 ff ff       	call   c0100cd2 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010381f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103826:	e8 38 05 00 00       	call   c0103d63 <alloc_pages>
c010382b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010382e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103831:	83 e8 14             	sub    $0x14,%eax
c0103834:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103837:	74 24                	je     c010385d <default_check+0x480>
c0103839:	c7 44 24 0c 7a 69 10 	movl   $0xc010697a,0xc(%esp)
c0103840:	c0 
c0103841:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103848:	c0 
c0103849:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0103850:	00 
c0103851:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103858:	e8 75 d4 ff ff       	call   c0100cd2 <__panic>
    free_page(p0);
c010385d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103864:	00 
c0103865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103868:	89 04 24             	mov    %eax,(%esp)
c010386b:	e8 2b 05 00 00       	call   c0103d9b <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103870:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103877:	e8 e7 04 00 00       	call   c0103d63 <alloc_pages>
c010387c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010387f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103882:	83 c0 14             	add    $0x14,%eax
c0103885:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103888:	74 24                	je     c01038ae <default_check+0x4d1>
c010388a:	c7 44 24 0c 98 69 10 	movl   $0xc0106998,0xc(%esp)
c0103891:	c0 
c0103892:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103899:	c0 
c010389a:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01038a1:	00 
c01038a2:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01038a9:	e8 24 d4 ff ff       	call   c0100cd2 <__panic>

    free_pages(p0, 2);
c01038ae:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01038b5:	00 
c01038b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038b9:	89 04 24             	mov    %eax,(%esp)
c01038bc:	e8 da 04 00 00       	call   c0103d9b <free_pages>
    free_page(p2);
c01038c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038c8:	00 
c01038c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038cc:	89 04 24             	mov    %eax,(%esp)
c01038cf:	e8 c7 04 00 00       	call   c0103d9b <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01038d4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01038db:	e8 83 04 00 00       	call   c0103d63 <alloc_pages>
c01038e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01038e7:	75 24                	jne    c010390d <default_check+0x530>
c01038e9:	c7 44 24 0c b8 69 10 	movl   $0xc01069b8,0xc(%esp)
c01038f0:	c0 
c01038f1:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01038f8:	c0 
c01038f9:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0103900:	00 
c0103901:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103908:	e8 c5 d3 ff ff       	call   c0100cd2 <__panic>
    assert(alloc_page() == NULL);
c010390d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103914:	e8 4a 04 00 00       	call   c0103d63 <alloc_pages>
c0103919:	85 c0                	test   %eax,%eax
c010391b:	74 24                	je     c0103941 <default_check+0x564>
c010391d:	c7 44 24 0c 16 68 10 	movl   $0xc0106816,0xc(%esp)
c0103924:	c0 
c0103925:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c010392c:	c0 
c010392d:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c0103934:	00 
c0103935:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c010393c:	e8 91 d3 ff ff       	call   c0100cd2 <__panic>

    assert(nr_free == 0);
c0103941:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103946:	85 c0                	test   %eax,%eax
c0103948:	74 24                	je     c010396e <default_check+0x591>
c010394a:	c7 44 24 0c 69 68 10 	movl   $0xc0106869,0xc(%esp)
c0103951:	c0 
c0103952:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103959:	c0 
c010395a:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c0103961:	00 
c0103962:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103969:	e8 64 d3 ff ff       	call   c0100cd2 <__panic>
    nr_free = nr_free_store;
c010396e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103971:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_list = free_list_store;
c0103976:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103979:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010397c:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c0103981:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    free_pages(p0, 5);
c0103987:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010398e:	00 
c010398f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103992:	89 04 24             	mov    %eax,(%esp)
c0103995:	e8 01 04 00 00       	call   c0103d9b <free_pages>

    le = &free_list;
c010399a:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01039a1:	eb 1d                	jmp    c01039c0 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01039a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039a6:	83 e8 0c             	sub    $0xc,%eax
c01039a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01039ac:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01039b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01039b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01039b6:	8b 40 08             	mov    0x8(%eax),%eax
c01039b9:	29 c2                	sub    %eax,%edx
c01039bb:	89 d0                	mov    %edx,%eax
c01039bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039c3:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01039c6:	8b 45 88             	mov    -0x78(%ebp),%eax
c01039c9:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01039cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039cf:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c01039d6:	75 cb                	jne    c01039a3 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01039d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039dc:	74 24                	je     c0103a02 <default_check+0x625>
c01039de:	c7 44 24 0c d6 69 10 	movl   $0xc01069d6,0xc(%esp)
c01039e5:	c0 
c01039e6:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c01039ed:	c0 
c01039ee:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c01039f5:	00 
c01039f6:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c01039fd:	e8 d0 d2 ff ff       	call   c0100cd2 <__panic>
    assert(total == 0);
c0103a02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a06:	74 24                	je     c0103a2c <default_check+0x64f>
c0103a08:	c7 44 24 0c e1 69 10 	movl   $0xc01069e1,0xc(%esp)
c0103a0f:	c0 
c0103a10:	c7 44 24 08 76 66 10 	movl   $0xc0106676,0x8(%esp)
c0103a17:	c0 
c0103a18:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c0103a1f:	00 
c0103a20:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0103a27:	e8 a6 d2 ff ff       	call   c0100cd2 <__panic>
}
c0103a2c:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103a32:	5b                   	pop    %ebx
c0103a33:	5d                   	pop    %ebp
c0103a34:	c3                   	ret    

c0103a35 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103a35:	55                   	push   %ebp
c0103a36:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103a38:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a3b:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0103a40:	29 c2                	sub    %eax,%edx
c0103a42:	89 d0                	mov    %edx,%eax
c0103a44:	c1 f8 02             	sar    $0x2,%eax
c0103a47:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103a4d:	5d                   	pop    %ebp
c0103a4e:	c3                   	ret    

c0103a4f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103a4f:	55                   	push   %ebp
c0103a50:	89 e5                	mov    %esp,%ebp
c0103a52:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103a55:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a58:	89 04 24             	mov    %eax,(%esp)
c0103a5b:	e8 d5 ff ff ff       	call   c0103a35 <page2ppn>
c0103a60:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a63:	c9                   	leave  
c0103a64:	c3                   	ret    

c0103a65 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a65:	55                   	push   %ebp
c0103a66:	89 e5                	mov    %esp,%ebp
c0103a68:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a6e:	c1 e8 0c             	shr    $0xc,%eax
c0103a71:	89 c2                	mov    %eax,%edx
c0103a73:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103a78:	39 c2                	cmp    %eax,%edx
c0103a7a:	72 1c                	jb     c0103a98 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103a7c:	c7 44 24 08 1c 6a 10 	movl   $0xc0106a1c,0x8(%esp)
c0103a83:	c0 
c0103a84:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103a8b:	00 
c0103a8c:	c7 04 24 3b 6a 10 c0 	movl   $0xc0106a3b,(%esp)
c0103a93:	e8 3a d2 ff ff       	call   c0100cd2 <__panic>
    }
    return &pages[PPN(pa)];
c0103a98:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c0103a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aa1:	c1 e8 0c             	shr    $0xc,%eax
c0103aa4:	89 c2                	mov    %eax,%edx
c0103aa6:	89 d0                	mov    %edx,%eax
c0103aa8:	c1 e0 02             	shl    $0x2,%eax
c0103aab:	01 d0                	add    %edx,%eax
c0103aad:	c1 e0 02             	shl    $0x2,%eax
c0103ab0:	01 c8                	add    %ecx,%eax
}
c0103ab2:	c9                   	leave  
c0103ab3:	c3                   	ret    

c0103ab4 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103ab4:	55                   	push   %ebp
c0103ab5:	89 e5                	mov    %esp,%ebp
c0103ab7:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103aba:	8b 45 08             	mov    0x8(%ebp),%eax
c0103abd:	89 04 24             	mov    %eax,(%esp)
c0103ac0:	e8 8a ff ff ff       	call   c0103a4f <page2pa>
c0103ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103acb:	c1 e8 0c             	shr    $0xc,%eax
c0103ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ad1:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103ad6:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103ad9:	72 23                	jb     c0103afe <page2kva+0x4a>
c0103adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ade:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ae2:	c7 44 24 08 4c 6a 10 	movl   $0xc0106a4c,0x8(%esp)
c0103ae9:	c0 
c0103aea:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103af1:	00 
c0103af2:	c7 04 24 3b 6a 10 c0 	movl   $0xc0106a3b,(%esp)
c0103af9:	e8 d4 d1 ff ff       	call   c0100cd2 <__panic>
c0103afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b01:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103b06:	c9                   	leave  
c0103b07:	c3                   	ret    

c0103b08 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103b08:	55                   	push   %ebp
c0103b09:	89 e5                	mov    %esp,%ebp
c0103b0b:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103b0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b11:	83 e0 01             	and    $0x1,%eax
c0103b14:	85 c0                	test   %eax,%eax
c0103b16:	75 1c                	jne    c0103b34 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103b18:	c7 44 24 08 70 6a 10 	movl   $0xc0106a70,0x8(%esp)
c0103b1f:	c0 
c0103b20:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103b27:	00 
c0103b28:	c7 04 24 3b 6a 10 c0 	movl   $0xc0106a3b,(%esp)
c0103b2f:	e8 9e d1 ff ff       	call   c0100cd2 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b3c:	89 04 24             	mov    %eax,(%esp)
c0103b3f:	e8 21 ff ff ff       	call   c0103a65 <pa2page>
}
c0103b44:	c9                   	leave  
c0103b45:	c3                   	ret    

c0103b46 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103b46:	55                   	push   %ebp
c0103b47:	89 e5                	mov    %esp,%ebp
c0103b49:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b54:	89 04 24             	mov    %eax,(%esp)
c0103b57:	e8 09 ff ff ff       	call   c0103a65 <pa2page>
}
c0103b5c:	c9                   	leave  
c0103b5d:	c3                   	ret    

c0103b5e <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103b5e:	55                   	push   %ebp
c0103b5f:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b61:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b64:	8b 00                	mov    (%eax),%eax
}
c0103b66:	5d                   	pop    %ebp
c0103b67:	c3                   	ret    

c0103b68 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103b68:	55                   	push   %ebp
c0103b69:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b71:	89 10                	mov    %edx,(%eax)
}
c0103b73:	5d                   	pop    %ebp
c0103b74:	c3                   	ret    

c0103b75 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103b75:	55                   	push   %ebp
c0103b76:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b78:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b7b:	8b 00                	mov    (%eax),%eax
c0103b7d:	8d 50 01             	lea    0x1(%eax),%edx
c0103b80:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b83:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b85:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b88:	8b 00                	mov    (%eax),%eax
}
c0103b8a:	5d                   	pop    %ebp
c0103b8b:	c3                   	ret    

c0103b8c <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103b8c:	55                   	push   %ebp
c0103b8d:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103b8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b92:	8b 00                	mov    (%eax),%eax
c0103b94:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103b97:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b9a:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b9f:	8b 00                	mov    (%eax),%eax
}
c0103ba1:	5d                   	pop    %ebp
c0103ba2:	c3                   	ret    

c0103ba3 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103ba3:	55                   	push   %ebp
c0103ba4:	89 e5                	mov    %esp,%ebp
c0103ba6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103ba9:	9c                   	pushf  
c0103baa:	58                   	pop    %eax
c0103bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103bb1:	25 00 02 00 00       	and    $0x200,%eax
c0103bb6:	85 c0                	test   %eax,%eax
c0103bb8:	74 0c                	je     c0103bc6 <__intr_save+0x23>
        intr_disable();
c0103bba:	e8 07 db ff ff       	call   c01016c6 <intr_disable>
        return 1;
c0103bbf:	b8 01 00 00 00       	mov    $0x1,%eax
c0103bc4:	eb 05                	jmp    c0103bcb <__intr_save+0x28>
    }
    return 0;
c0103bc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103bcb:	c9                   	leave  
c0103bcc:	c3                   	ret    

c0103bcd <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103bcd:	55                   	push   %ebp
c0103bce:	89 e5                	mov    %esp,%ebp
c0103bd0:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103bd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103bd7:	74 05                	je     c0103bde <__intr_restore+0x11>
        intr_enable();
c0103bd9:	e8 e2 da ff ff       	call   c01016c0 <intr_enable>
    }
}
c0103bde:	c9                   	leave  
c0103bdf:	c3                   	ret    

c0103be0 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103be0:	55                   	push   %ebp
c0103be1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103be3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103be6:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103be9:	b8 23 00 00 00       	mov    $0x23,%eax
c0103bee:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103bf0:	b8 23 00 00 00       	mov    $0x23,%eax
c0103bf5:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103bf7:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bfc:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103bfe:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c03:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103c05:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c0a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103c0c:	ea 13 3c 10 c0 08 00 	ljmp   $0x8,$0xc0103c13
}
c0103c13:	5d                   	pop    %ebp
c0103c14:	c3                   	ret    

c0103c15 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103c15:	55                   	push   %ebp
c0103c16:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c1b:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c0103c20:	5d                   	pop    %ebp
c0103c21:	c3                   	ret    

c0103c22 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103c22:	55                   	push   %ebp
c0103c23:	89 e5                	mov    %esp,%ebp
c0103c25:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103c28:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103c2d:	89 04 24             	mov    %eax,(%esp)
c0103c30:	e8 e0 ff ff ff       	call   c0103c15 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103c35:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c0103c3c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103c3e:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103c45:	68 00 
c0103c47:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103c4c:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103c52:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103c57:	c1 e8 10             	shr    $0x10,%eax
c0103c5a:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103c5f:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c66:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c69:	83 c8 09             	or     $0x9,%eax
c0103c6c:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c71:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c78:	83 e0 ef             	and    $0xffffffef,%eax
c0103c7b:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c80:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c87:	83 e0 9f             	and    $0xffffff9f,%eax
c0103c8a:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c8f:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c96:	83 c8 80             	or     $0xffffff80,%eax
c0103c99:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c9e:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103ca5:	83 e0 f0             	and    $0xfffffff0,%eax
c0103ca8:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cad:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cb4:	83 e0 ef             	and    $0xffffffef,%eax
c0103cb7:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cbc:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cc3:	83 e0 df             	and    $0xffffffdf,%eax
c0103cc6:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ccb:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cd2:	83 c8 40             	or     $0x40,%eax
c0103cd5:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cda:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103ce1:	83 e0 7f             	and    $0x7f,%eax
c0103ce4:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ce9:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103cee:	c1 e8 18             	shr    $0x18,%eax
c0103cf1:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103cf6:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103cfd:	e8 de fe ff ff       	call   c0103be0 <lgdt>
c0103d02:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103d08:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103d0c:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103d0f:	c9                   	leave  
c0103d10:	c3                   	ret    

c0103d11 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103d11:	55                   	push   %ebp
c0103d12:	89 e5                	mov    %esp,%ebp
c0103d14:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103d17:	c7 05 1c af 11 c0 00 	movl   $0xc0106a00,0xc011af1c
c0103d1e:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103d21:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d26:	8b 00                	mov    (%eax),%eax
c0103d28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d2c:	c7 04 24 9c 6a 10 c0 	movl   $0xc0106a9c,(%esp)
c0103d33:	e8 10 c6 ff ff       	call   c0100348 <cprintf>
    pmm_manager->init();
c0103d38:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d3d:	8b 40 04             	mov    0x4(%eax),%eax
c0103d40:	ff d0                	call   *%eax
}
c0103d42:	c9                   	leave  
c0103d43:	c3                   	ret    

c0103d44 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103d44:	55                   	push   %ebp
c0103d45:	89 e5                	mov    %esp,%ebp
c0103d47:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103d4a:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d4f:	8b 40 08             	mov    0x8(%eax),%eax
c0103d52:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d55:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d59:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d5c:	89 14 24             	mov    %edx,(%esp)
c0103d5f:	ff d0                	call   *%eax
}
c0103d61:	c9                   	leave  
c0103d62:	c3                   	ret    

c0103d63 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103d63:	55                   	push   %ebp
c0103d64:	89 e5                	mov    %esp,%ebp
c0103d66:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103d69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d70:	e8 2e fe ff ff       	call   c0103ba3 <__intr_save>
c0103d75:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d78:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d7d:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d80:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d83:	89 14 24             	mov    %edx,(%esp)
c0103d86:	ff d0                	call   *%eax
c0103d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d8e:	89 04 24             	mov    %eax,(%esp)
c0103d91:	e8 37 fe ff ff       	call   c0103bcd <__intr_restore>
    return page;
c0103d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103d99:	c9                   	leave  
c0103d9a:	c3                   	ret    

c0103d9b <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103d9b:	55                   	push   %ebp
c0103d9c:	89 e5                	mov    %esp,%ebp
c0103d9e:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103da1:	e8 fd fd ff ff       	call   c0103ba3 <__intr_save>
c0103da6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103da9:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103dae:	8b 40 10             	mov    0x10(%eax),%eax
c0103db1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103db4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103db8:	8b 55 08             	mov    0x8(%ebp),%edx
c0103dbb:	89 14 24             	mov    %edx,(%esp)
c0103dbe:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dc3:	89 04 24             	mov    %eax,(%esp)
c0103dc6:	e8 02 fe ff ff       	call   c0103bcd <__intr_restore>
}
c0103dcb:	c9                   	leave  
c0103dcc:	c3                   	ret    

c0103dcd <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103dcd:	55                   	push   %ebp
c0103dce:	89 e5                	mov    %esp,%ebp
c0103dd0:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103dd3:	e8 cb fd ff ff       	call   c0103ba3 <__intr_save>
c0103dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103ddb:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103de0:	8b 40 14             	mov    0x14(%eax),%eax
c0103de3:	ff d0                	call   *%eax
c0103de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103deb:	89 04 24             	mov    %eax,(%esp)
c0103dee:	e8 da fd ff ff       	call   c0103bcd <__intr_restore>
    return ret;
c0103df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103df6:	c9                   	leave  
c0103df7:	c3                   	ret    

c0103df8 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103df8:	55                   	push   %ebp
c0103df9:	89 e5                	mov    %esp,%ebp
c0103dfb:	57                   	push   %edi
c0103dfc:	56                   	push   %esi
c0103dfd:	53                   	push   %ebx
c0103dfe:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103e04:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103e0b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103e12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103e19:	c7 04 24 b3 6a 10 c0 	movl   $0xc0106ab3,(%esp)
c0103e20:	e8 23 c5 ff ff       	call   c0100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e2c:	e9 15 01 00 00       	jmp    c0103f46 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103e31:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e34:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e37:	89 d0                	mov    %edx,%eax
c0103e39:	c1 e0 02             	shl    $0x2,%eax
c0103e3c:	01 d0                	add    %edx,%eax
c0103e3e:	c1 e0 02             	shl    $0x2,%eax
c0103e41:	01 c8                	add    %ecx,%eax
c0103e43:	8b 50 08             	mov    0x8(%eax),%edx
c0103e46:	8b 40 04             	mov    0x4(%eax),%eax
c0103e49:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e4c:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103e4f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e52:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e55:	89 d0                	mov    %edx,%eax
c0103e57:	c1 e0 02             	shl    $0x2,%eax
c0103e5a:	01 d0                	add    %edx,%eax
c0103e5c:	c1 e0 02             	shl    $0x2,%eax
c0103e5f:	01 c8                	add    %ecx,%eax
c0103e61:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e64:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e67:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e6a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e6d:	01 c8                	add    %ecx,%eax
c0103e6f:	11 da                	adc    %ebx,%edx
c0103e71:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103e74:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103e77:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e7a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e7d:	89 d0                	mov    %edx,%eax
c0103e7f:	c1 e0 02             	shl    $0x2,%eax
c0103e82:	01 d0                	add    %edx,%eax
c0103e84:	c1 e0 02             	shl    $0x2,%eax
c0103e87:	01 c8                	add    %ecx,%eax
c0103e89:	83 c0 14             	add    $0x14,%eax
c0103e8c:	8b 00                	mov    (%eax),%eax
c0103e8e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103e94:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e97:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e9a:	83 c0 ff             	add    $0xffffffff,%eax
c0103e9d:	83 d2 ff             	adc    $0xffffffff,%edx
c0103ea0:	89 c6                	mov    %eax,%esi
c0103ea2:	89 d7                	mov    %edx,%edi
c0103ea4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ea7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103eaa:	89 d0                	mov    %edx,%eax
c0103eac:	c1 e0 02             	shl    $0x2,%eax
c0103eaf:	01 d0                	add    %edx,%eax
c0103eb1:	c1 e0 02             	shl    $0x2,%eax
c0103eb4:	01 c8                	add    %ecx,%eax
c0103eb6:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103eb9:	8b 58 10             	mov    0x10(%eax),%ebx
c0103ebc:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103ec2:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103ec6:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103eca:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103ece:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ed1:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103ed4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ed8:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103edc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103ee0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103ee4:	c7 04 24 c0 6a 10 c0 	movl   $0xc0106ac0,(%esp)
c0103eeb:	e8 58 c4 ff ff       	call   c0100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103ef0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ef3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ef6:	89 d0                	mov    %edx,%eax
c0103ef8:	c1 e0 02             	shl    $0x2,%eax
c0103efb:	01 d0                	add    %edx,%eax
c0103efd:	c1 e0 02             	shl    $0x2,%eax
c0103f00:	01 c8                	add    %ecx,%eax
c0103f02:	83 c0 14             	add    $0x14,%eax
c0103f05:	8b 00                	mov    (%eax),%eax
c0103f07:	83 f8 01             	cmp    $0x1,%eax
c0103f0a:	75 36                	jne    c0103f42 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103f0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f12:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f15:	77 2b                	ja     c0103f42 <page_init+0x14a>
c0103f17:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f1a:	72 05                	jb     c0103f21 <page_init+0x129>
c0103f1c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103f1f:	73 21                	jae    c0103f42 <page_init+0x14a>
c0103f21:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f25:	77 1b                	ja     c0103f42 <page_init+0x14a>
c0103f27:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f2b:	72 09                	jb     c0103f36 <page_init+0x13e>
c0103f2d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103f34:	77 0c                	ja     c0103f42 <page_init+0x14a>
                maxpa = end;
c0103f36:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f39:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103f3f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103f42:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f49:	8b 00                	mov    (%eax),%eax
c0103f4b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f4e:	0f 8f dd fe ff ff    	jg     c0103e31 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103f54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f58:	72 1d                	jb     c0103f77 <page_init+0x17f>
c0103f5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f5e:	77 09                	ja     c0103f69 <page_init+0x171>
c0103f60:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f67:	76 0e                	jbe    c0103f77 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103f69:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103f70:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103f77:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f7d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103f81:	c1 ea 0c             	shr    $0xc,%edx
c0103f84:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103f89:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103f90:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c0103f95:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103f98:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f9b:	01 d0                	add    %edx,%eax
c0103f9d:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103fa0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103fa3:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fa8:	f7 75 ac             	divl   -0x54(%ebp)
c0103fab:	89 d0                	mov    %edx,%eax
c0103fad:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103fb0:	29 c2                	sub    %eax,%edx
c0103fb2:	89 d0                	mov    %edx,%eax
c0103fb4:	a3 24 af 11 c0       	mov    %eax,0xc011af24

    for (i = 0; i < npage; i ++) {
c0103fb9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fc0:	eb 2f                	jmp    c0103ff1 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103fc2:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c0103fc8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fcb:	89 d0                	mov    %edx,%eax
c0103fcd:	c1 e0 02             	shl    $0x2,%eax
c0103fd0:	01 d0                	add    %edx,%eax
c0103fd2:	c1 e0 02             	shl    $0x2,%eax
c0103fd5:	01 c8                	add    %ecx,%eax
c0103fd7:	83 c0 04             	add    $0x4,%eax
c0103fda:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103fe1:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103fe4:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103fe7:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103fea:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103fed:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103ff1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ff4:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103ff9:	39 c2                	cmp    %eax,%edx
c0103ffb:	72 c5                	jb     c0103fc2 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103ffd:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0104003:	89 d0                	mov    %edx,%eax
c0104005:	c1 e0 02             	shl    $0x2,%eax
c0104008:	01 d0                	add    %edx,%eax
c010400a:	c1 e0 02             	shl    $0x2,%eax
c010400d:	89 c2                	mov    %eax,%edx
c010400f:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104014:	01 d0                	add    %edx,%eax
c0104016:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104019:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104020:	77 23                	ja     c0104045 <page_init+0x24d>
c0104022:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104025:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104029:	c7 44 24 08 f0 6a 10 	movl   $0xc0106af0,0x8(%esp)
c0104030:	c0 
c0104031:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0104038:	00 
c0104039:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104040:	e8 8d cc ff ff       	call   c0100cd2 <__panic>
c0104045:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104048:	05 00 00 00 40       	add    $0x40000000,%eax
c010404d:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104050:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104057:	e9 74 01 00 00       	jmp    c01041d0 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010405c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010405f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104062:	89 d0                	mov    %edx,%eax
c0104064:	c1 e0 02             	shl    $0x2,%eax
c0104067:	01 d0                	add    %edx,%eax
c0104069:	c1 e0 02             	shl    $0x2,%eax
c010406c:	01 c8                	add    %ecx,%eax
c010406e:	8b 50 08             	mov    0x8(%eax),%edx
c0104071:	8b 40 04             	mov    0x4(%eax),%eax
c0104074:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104077:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010407a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010407d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104080:	89 d0                	mov    %edx,%eax
c0104082:	c1 e0 02             	shl    $0x2,%eax
c0104085:	01 d0                	add    %edx,%eax
c0104087:	c1 e0 02             	shl    $0x2,%eax
c010408a:	01 c8                	add    %ecx,%eax
c010408c:	8b 48 0c             	mov    0xc(%eax),%ecx
c010408f:	8b 58 10             	mov    0x10(%eax),%ebx
c0104092:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104095:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104098:	01 c8                	add    %ecx,%eax
c010409a:	11 da                	adc    %ebx,%edx
c010409c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010409f:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01040a2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040a8:	89 d0                	mov    %edx,%eax
c01040aa:	c1 e0 02             	shl    $0x2,%eax
c01040ad:	01 d0                	add    %edx,%eax
c01040af:	c1 e0 02             	shl    $0x2,%eax
c01040b2:	01 c8                	add    %ecx,%eax
c01040b4:	83 c0 14             	add    $0x14,%eax
c01040b7:	8b 00                	mov    (%eax),%eax
c01040b9:	83 f8 01             	cmp    $0x1,%eax
c01040bc:	0f 85 0a 01 00 00    	jne    c01041cc <page_init+0x3d4>
            if (begin < freemem) {
c01040c2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040c5:	ba 00 00 00 00       	mov    $0x0,%edx
c01040ca:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01040cd:	72 17                	jb     c01040e6 <page_init+0x2ee>
c01040cf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01040d2:	77 05                	ja     c01040d9 <page_init+0x2e1>
c01040d4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01040d7:	76 0d                	jbe    c01040e6 <page_init+0x2ee>
                begin = freemem;
c01040d9:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040df:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01040e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040ea:	72 1d                	jb     c0104109 <page_init+0x311>
c01040ec:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040f0:	77 09                	ja     c01040fb <page_init+0x303>
c01040f2:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01040f9:	76 0e                	jbe    c0104109 <page_init+0x311>
                end = KMEMSIZE;
c01040fb:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104102:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104109:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010410c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010410f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104112:	0f 87 b4 00 00 00    	ja     c01041cc <page_init+0x3d4>
c0104118:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010411b:	72 09                	jb     c0104126 <page_init+0x32e>
c010411d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104120:	0f 83 a6 00 00 00    	jae    c01041cc <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104126:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010412d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104130:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104133:	01 d0                	add    %edx,%eax
c0104135:	83 e8 01             	sub    $0x1,%eax
c0104138:	89 45 98             	mov    %eax,-0x68(%ebp)
c010413b:	8b 45 98             	mov    -0x68(%ebp),%eax
c010413e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104143:	f7 75 9c             	divl   -0x64(%ebp)
c0104146:	89 d0                	mov    %edx,%eax
c0104148:	8b 55 98             	mov    -0x68(%ebp),%edx
c010414b:	29 c2                	sub    %eax,%edx
c010414d:	89 d0                	mov    %edx,%eax
c010414f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104154:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104157:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010415a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010415d:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104160:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104163:	ba 00 00 00 00       	mov    $0x0,%edx
c0104168:	89 c7                	mov    %eax,%edi
c010416a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104170:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104173:	89 d0                	mov    %edx,%eax
c0104175:	83 e0 00             	and    $0x0,%eax
c0104178:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010417b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010417e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104181:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104184:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104187:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010418a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010418d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104190:	77 3a                	ja     c01041cc <page_init+0x3d4>
c0104192:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104195:	72 05                	jb     c010419c <page_init+0x3a4>
c0104197:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010419a:	73 30                	jae    c01041cc <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010419c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010419f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01041a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01041a5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01041a8:	29 c8                	sub    %ecx,%eax
c01041aa:	19 da                	sbb    %ebx,%edx
c01041ac:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01041b0:	c1 ea 0c             	shr    $0xc,%edx
c01041b3:	89 c3                	mov    %eax,%ebx
c01041b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041b8:	89 04 24             	mov    %eax,(%esp)
c01041bb:	e8 a5 f8 ff ff       	call   c0103a65 <pa2page>
c01041c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01041c4:	89 04 24             	mov    %eax,(%esp)
c01041c7:	e8 78 fb ff ff       	call   c0103d44 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01041cc:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01041d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01041d3:	8b 00                	mov    (%eax),%eax
c01041d5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01041d8:	0f 8f 7e fe ff ff    	jg     c010405c <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01041de:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01041e4:	5b                   	pop    %ebx
c01041e5:	5e                   	pop    %esi
c01041e6:	5f                   	pop    %edi
c01041e7:	5d                   	pop    %ebp
c01041e8:	c3                   	ret    

c01041e9 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01041e9:	55                   	push   %ebp
c01041ea:	89 e5                	mov    %esp,%ebp
c01041ec:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01041ef:	8b 45 14             	mov    0x14(%ebp),%eax
c01041f2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041f5:	31 d0                	xor    %edx,%eax
c01041f7:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041fc:	85 c0                	test   %eax,%eax
c01041fe:	74 24                	je     c0104224 <boot_map_segment+0x3b>
c0104200:	c7 44 24 0c 22 6b 10 	movl   $0xc0106b22,0xc(%esp)
c0104207:	c0 
c0104208:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c010420f:	c0 
c0104210:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104217:	00 
c0104218:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c010421f:	e8 ae ca ff ff       	call   c0100cd2 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104224:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010422b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010422e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104233:	89 c2                	mov    %eax,%edx
c0104235:	8b 45 10             	mov    0x10(%ebp),%eax
c0104238:	01 c2                	add    %eax,%edx
c010423a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010423d:	01 d0                	add    %edx,%eax
c010423f:	83 e8 01             	sub    $0x1,%eax
c0104242:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104245:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104248:	ba 00 00 00 00       	mov    $0x0,%edx
c010424d:	f7 75 f0             	divl   -0x10(%ebp)
c0104250:	89 d0                	mov    %edx,%eax
c0104252:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104255:	29 c2                	sub    %eax,%edx
c0104257:	89 d0                	mov    %edx,%eax
c0104259:	c1 e8 0c             	shr    $0xc,%eax
c010425c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010425f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104262:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104265:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104268:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010426d:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104270:	8b 45 14             	mov    0x14(%ebp),%eax
c0104273:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104276:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104279:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010427e:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104281:	eb 6b                	jmp    c01042ee <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104283:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010428a:	00 
c010428b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010428e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104292:	8b 45 08             	mov    0x8(%ebp),%eax
c0104295:	89 04 24             	mov    %eax,(%esp)
c0104298:	e8 82 01 00 00       	call   c010441f <get_pte>
c010429d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01042a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01042a4:	75 24                	jne    c01042ca <boot_map_segment+0xe1>
c01042a6:	c7 44 24 0c 4e 6b 10 	movl   $0xc0106b4e,0xc(%esp)
c01042ad:	c0 
c01042ae:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c01042b5:	c0 
c01042b6:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01042bd:	00 
c01042be:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c01042c5:	e8 08 ca ff ff       	call   c0100cd2 <__panic>
        *ptep = pa | PTE_P | perm;
c01042ca:	8b 45 18             	mov    0x18(%ebp),%eax
c01042cd:	8b 55 14             	mov    0x14(%ebp),%edx
c01042d0:	09 d0                	or     %edx,%eax
c01042d2:	83 c8 01             	or     $0x1,%eax
c01042d5:	89 c2                	mov    %eax,%edx
c01042d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042da:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042dc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01042e0:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01042e7:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01042ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042f2:	75 8f                	jne    c0104283 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01042f4:	c9                   	leave  
c01042f5:	c3                   	ret    

c01042f6 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01042f6:	55                   	push   %ebp
c01042f7:	89 e5                	mov    %esp,%ebp
c01042f9:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01042fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104303:	e8 5b fa ff ff       	call   c0103d63 <alloc_pages>
c0104308:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010430b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010430f:	75 1c                	jne    c010432d <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104311:	c7 44 24 08 5b 6b 10 	movl   $0xc0106b5b,0x8(%esp)
c0104318:	c0 
c0104319:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104320:	00 
c0104321:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104328:	e8 a5 c9 ff ff       	call   c0100cd2 <__panic>
    }
    return page2kva(p);
c010432d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104330:	89 04 24             	mov    %eax,(%esp)
c0104333:	e8 7c f7 ff ff       	call   c0103ab4 <page2kva>
}
c0104338:	c9                   	leave  
c0104339:	c3                   	ret    

c010433a <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010433a:	55                   	push   %ebp
c010433b:	89 e5                	mov    %esp,%ebp
c010433d:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104340:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104345:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104348:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010434f:	77 23                	ja     c0104374 <pmm_init+0x3a>
c0104351:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104354:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104358:	c7 44 24 08 f0 6a 10 	movl   $0xc0106af0,0x8(%esp)
c010435f:	c0 
c0104360:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104367:	00 
c0104368:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c010436f:	e8 5e c9 ff ff       	call   c0100cd2 <__panic>
c0104374:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104377:	05 00 00 00 40       	add    $0x40000000,%eax
c010437c:	a3 20 af 11 c0       	mov    %eax,0xc011af20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104381:	e8 8b f9 ff ff       	call   c0103d11 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104386:	e8 6d fa ff ff       	call   c0103df8 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010438b:	e8 db 03 00 00       	call   c010476b <check_alloc_page>

    check_pgdir();
c0104390:	e8 f4 03 00 00       	call   c0104789 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104395:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010439a:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01043a0:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01043a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043a8:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01043af:	77 23                	ja     c01043d4 <pmm_init+0x9a>
c01043b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043b4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043b8:	c7 44 24 08 f0 6a 10 	movl   $0xc0106af0,0x8(%esp)
c01043bf:	c0 
c01043c0:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01043c7:	00 
c01043c8:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c01043cf:	e8 fe c8 ff ff       	call   c0100cd2 <__panic>
c01043d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043d7:	05 00 00 00 40       	add    $0x40000000,%eax
c01043dc:	83 c8 03             	or     $0x3,%eax
c01043df:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01043e1:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01043e6:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01043ed:	00 
c01043ee:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01043f5:	00 
c01043f6:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01043fd:	38 
c01043fe:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104405:	c0 
c0104406:	89 04 24             	mov    %eax,(%esp)
c0104409:	e8 db fd ff ff       	call   c01041e9 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010440e:	e8 0f f8 ff ff       	call   c0103c22 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104413:	e8 0c 0a 00 00       	call   c0104e24 <check_boot_pgdir>

    print_pgdir();
c0104418:	e8 94 0e 00 00       	call   c01052b1 <print_pgdir>

}
c010441d:	c9                   	leave  
c010441e:	c3                   	ret    

c010441f <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010441f:	55                   	push   %ebp
c0104420:	89 e5                	mov    %esp,%ebp
c0104422:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0104425:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104428:	c1 e8 16             	shr    $0x16,%eax
c010442b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104432:	8b 45 08             	mov    0x8(%ebp),%eax
c0104435:	01 d0                	add    %edx,%eax
c0104437:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c010443a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010443d:	8b 00                	mov    (%eax),%eax
c010443f:	83 e0 01             	and    $0x1,%eax
c0104442:	85 c0                	test   %eax,%eax
c0104444:	0f 85 af 00 00 00    	jne    c01044f9 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c010444a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010444e:	74 15                	je     c0104465 <get_pte+0x46>
c0104450:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104457:	e8 07 f9 ff ff       	call   c0103d63 <alloc_pages>
c010445c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010445f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104463:	75 0a                	jne    c010446f <get_pte+0x50>
            return NULL;
c0104465:	b8 00 00 00 00       	mov    $0x0,%eax
c010446a:	e9 e6 00 00 00       	jmp    c0104555 <get_pte+0x136>
        }
        set_page_ref(page, 1);
c010446f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104476:	00 
c0104477:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010447a:	89 04 24             	mov    %eax,(%esp)
c010447d:	e8 e6 f6 ff ff       	call   c0103b68 <set_page_ref>
        uintptr_t pa = page2pa(page);
c0104482:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104485:	89 04 24             	mov    %eax,(%esp)
c0104488:	e8 c2 f5 ff ff       	call   c0103a4f <page2pa>
c010448d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0104490:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104493:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104496:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104499:	c1 e8 0c             	shr    $0xc,%eax
c010449c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010449f:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01044a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01044a7:	72 23                	jb     c01044cc <get_pte+0xad>
c01044a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044b0:	c7 44 24 08 4c 6a 10 	movl   $0xc0106a4c,0x8(%esp)
c01044b7:	c0 
c01044b8:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
c01044bf:	00 
c01044c0:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c01044c7:	e8 06 c8 ff ff       	call   c0100cd2 <__panic>
c01044cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044cf:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01044d4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01044db:	00 
c01044dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01044e3:	00 
c01044e4:	89 04 24             	mov    %eax,(%esp)
c01044e7:	e8 e3 18 00 00       	call   c0105dcf <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c01044ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044ef:	83 c8 07             	or     $0x7,%eax
c01044f2:	89 c2                	mov    %eax,%edx
c01044f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044f7:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01044f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044fc:	8b 00                	mov    (%eax),%eax
c01044fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104503:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104506:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104509:	c1 e8 0c             	shr    $0xc,%eax
c010450c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010450f:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104514:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104517:	72 23                	jb     c010453c <get_pte+0x11d>
c0104519:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010451c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104520:	c7 44 24 08 4c 6a 10 	movl   $0xc0106a4c,0x8(%esp)
c0104527:	c0 
c0104528:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
c010452f:	00 
c0104530:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104537:	e8 96 c7 ff ff       	call   c0100cd2 <__panic>
c010453c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010453f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104544:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104547:	c1 ea 0c             	shr    $0xc,%edx
c010454a:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104550:	c1 e2 02             	shl    $0x2,%edx
c0104553:	01 d0                	add    %edx,%eax
}
c0104555:	c9                   	leave  
c0104556:	c3                   	ret    

c0104557 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104557:	55                   	push   %ebp
c0104558:	89 e5                	mov    %esp,%ebp
c010455a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010455d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104564:	00 
c0104565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104568:	89 44 24 04          	mov    %eax,0x4(%esp)
c010456c:	8b 45 08             	mov    0x8(%ebp),%eax
c010456f:	89 04 24             	mov    %eax,(%esp)
c0104572:	e8 a8 fe ff ff       	call   c010441f <get_pte>
c0104577:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010457a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010457e:	74 08                	je     c0104588 <get_page+0x31>
        *ptep_store = ptep;
c0104580:	8b 45 10             	mov    0x10(%ebp),%eax
c0104583:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104586:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010458c:	74 1b                	je     c01045a9 <get_page+0x52>
c010458e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104591:	8b 00                	mov    (%eax),%eax
c0104593:	83 e0 01             	and    $0x1,%eax
c0104596:	85 c0                	test   %eax,%eax
c0104598:	74 0f                	je     c01045a9 <get_page+0x52>
        return pte2page(*ptep);
c010459a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010459d:	8b 00                	mov    (%eax),%eax
c010459f:	89 04 24             	mov    %eax,(%esp)
c01045a2:	e8 61 f5 ff ff       	call   c0103b08 <pte2page>
c01045a7:	eb 05                	jmp    c01045ae <get_page+0x57>
    }
    return NULL;
c01045a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045ae:	c9                   	leave  
c01045af:	c3                   	ret    

c01045b0 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01045b0:	55                   	push   %ebp
c01045b1:	89 e5                	mov    %esp,%ebp
c01045b3:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c01045b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01045b9:	8b 00                	mov    (%eax),%eax
c01045bb:	83 e0 01             	and    $0x1,%eax
c01045be:	85 c0                	test   %eax,%eax
c01045c0:	74 4d                	je     c010460f <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c01045c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01045c5:	8b 00                	mov    (%eax),%eax
c01045c7:	89 04 24             	mov    %eax,(%esp)
c01045ca:	e8 39 f5 ff ff       	call   c0103b08 <pte2page>
c01045cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c01045d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045d5:	89 04 24             	mov    %eax,(%esp)
c01045d8:	e8 af f5 ff ff       	call   c0103b8c <page_ref_dec>
c01045dd:	85 c0                	test   %eax,%eax
c01045df:	75 13                	jne    c01045f4 <page_remove_pte+0x44>
            free_page(page);
c01045e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01045e8:	00 
c01045e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ec:	89 04 24             	mov    %eax,(%esp)
c01045ef:	e8 a7 f7 ff ff       	call   c0103d9b <free_pages>
        }
        *ptep = 0;
c01045f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01045f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01045fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104600:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104604:	8b 45 08             	mov    0x8(%ebp),%eax
c0104607:	89 04 24             	mov    %eax,(%esp)
c010460a:	e8 ff 00 00 00       	call   c010470e <tlb_invalidate>
    }
}
c010460f:	c9                   	leave  
c0104610:	c3                   	ret    

c0104611 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104611:	55                   	push   %ebp
c0104612:	89 e5                	mov    %esp,%ebp
c0104614:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104617:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010461e:	00 
c010461f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104622:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104626:	8b 45 08             	mov    0x8(%ebp),%eax
c0104629:	89 04 24             	mov    %eax,(%esp)
c010462c:	e8 ee fd ff ff       	call   c010441f <get_pte>
c0104631:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104634:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104638:	74 19                	je     c0104653 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010463a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010463d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104641:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104644:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104648:	8b 45 08             	mov    0x8(%ebp),%eax
c010464b:	89 04 24             	mov    %eax,(%esp)
c010464e:	e8 5d ff ff ff       	call   c01045b0 <page_remove_pte>
    }
}
c0104653:	c9                   	leave  
c0104654:	c3                   	ret    

c0104655 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104655:	55                   	push   %ebp
c0104656:	89 e5                	mov    %esp,%ebp
c0104658:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010465b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104662:	00 
c0104663:	8b 45 10             	mov    0x10(%ebp),%eax
c0104666:	89 44 24 04          	mov    %eax,0x4(%esp)
c010466a:	8b 45 08             	mov    0x8(%ebp),%eax
c010466d:	89 04 24             	mov    %eax,(%esp)
c0104670:	e8 aa fd ff ff       	call   c010441f <get_pte>
c0104675:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010467c:	75 0a                	jne    c0104688 <page_insert+0x33>
        return -E_NO_MEM;
c010467e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104683:	e9 84 00 00 00       	jmp    c010470c <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104688:	8b 45 0c             	mov    0xc(%ebp),%eax
c010468b:	89 04 24             	mov    %eax,(%esp)
c010468e:	e8 e2 f4 ff ff       	call   c0103b75 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104693:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104696:	8b 00                	mov    (%eax),%eax
c0104698:	83 e0 01             	and    $0x1,%eax
c010469b:	85 c0                	test   %eax,%eax
c010469d:	74 3e                	je     c01046dd <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010469f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a2:	8b 00                	mov    (%eax),%eax
c01046a4:	89 04 24             	mov    %eax,(%esp)
c01046a7:	e8 5c f4 ff ff       	call   c0103b08 <pte2page>
c01046ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01046af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01046b5:	75 0d                	jne    c01046c4 <page_insert+0x6f>
            page_ref_dec(page);
c01046b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046ba:	89 04 24             	mov    %eax,(%esp)
c01046bd:	e8 ca f4 ff ff       	call   c0103b8c <page_ref_dec>
c01046c2:	eb 19                	jmp    c01046dd <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01046c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046cb:	8b 45 10             	mov    0x10(%ebp),%eax
c01046ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01046d5:	89 04 24             	mov    %eax,(%esp)
c01046d8:	e8 d3 fe ff ff       	call   c01045b0 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01046dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046e0:	89 04 24             	mov    %eax,(%esp)
c01046e3:	e8 67 f3 ff ff       	call   c0103a4f <page2pa>
c01046e8:	0b 45 14             	or     0x14(%ebp),%eax
c01046eb:	83 c8 01             	or     $0x1,%eax
c01046ee:	89 c2                	mov    %eax,%edx
c01046f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046f3:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01046f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01046f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ff:	89 04 24             	mov    %eax,(%esp)
c0104702:	e8 07 00 00 00       	call   c010470e <tlb_invalidate>
    return 0;
c0104707:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010470c:	c9                   	leave  
c010470d:	c3                   	ret    

c010470e <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010470e:	55                   	push   %ebp
c010470f:	89 e5                	mov    %esp,%ebp
c0104711:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104714:	0f 20 d8             	mov    %cr3,%eax
c0104717:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010471a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c010471d:	89 c2                	mov    %eax,%edx
c010471f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104722:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104725:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010472c:	77 23                	ja     c0104751 <tlb_invalidate+0x43>
c010472e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104731:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104735:	c7 44 24 08 f0 6a 10 	movl   $0xc0106af0,0x8(%esp)
c010473c:	c0 
c010473d:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
c0104744:	00 
c0104745:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c010474c:	e8 81 c5 ff ff       	call   c0100cd2 <__panic>
c0104751:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104754:	05 00 00 00 40       	add    $0x40000000,%eax
c0104759:	39 c2                	cmp    %eax,%edx
c010475b:	75 0c                	jne    c0104769 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010475d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104760:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104763:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104766:	0f 01 38             	invlpg (%eax)
    }
}
c0104769:	c9                   	leave  
c010476a:	c3                   	ret    

c010476b <check_alloc_page>:

static void
check_alloc_page(void) {
c010476b:	55                   	push   %ebp
c010476c:	89 e5                	mov    %esp,%ebp
c010476e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104771:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0104776:	8b 40 18             	mov    0x18(%eax),%eax
c0104779:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010477b:	c7 04 24 74 6b 10 c0 	movl   $0xc0106b74,(%esp)
c0104782:	e8 c1 bb ff ff       	call   c0100348 <cprintf>
}
c0104787:	c9                   	leave  
c0104788:	c3                   	ret    

c0104789 <check_pgdir>:

static void
check_pgdir(void) {
c0104789:	55                   	push   %ebp
c010478a:	89 e5                	mov    %esp,%ebp
c010478c:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010478f:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104794:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104799:	76 24                	jbe    c01047bf <check_pgdir+0x36>
c010479b:	c7 44 24 0c 93 6b 10 	movl   $0xc0106b93,0xc(%esp)
c01047a2:	c0 
c01047a3:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c01047aa:	c0 
c01047ab:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c01047b2:	00 
c01047b3:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c01047ba:	e8 13 c5 ff ff       	call   c0100cd2 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01047bf:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01047c4:	85 c0                	test   %eax,%eax
c01047c6:	74 0e                	je     c01047d6 <check_pgdir+0x4d>
c01047c8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01047cd:	25 ff 0f 00 00       	and    $0xfff,%eax
c01047d2:	85 c0                	test   %eax,%eax
c01047d4:	74 24                	je     c01047fa <check_pgdir+0x71>
c01047d6:	c7 44 24 0c b0 6b 10 	movl   $0xc0106bb0,0xc(%esp)
c01047dd:	c0 
c01047de:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c01047e5:	c0 
c01047e6:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c01047ed:	00 
c01047ee:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c01047f5:	e8 d8 c4 ff ff       	call   c0100cd2 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01047fa:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01047ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104806:	00 
c0104807:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010480e:	00 
c010480f:	89 04 24             	mov    %eax,(%esp)
c0104812:	e8 40 fd ff ff       	call   c0104557 <get_page>
c0104817:	85 c0                	test   %eax,%eax
c0104819:	74 24                	je     c010483f <check_pgdir+0xb6>
c010481b:	c7 44 24 0c e8 6b 10 	movl   $0xc0106be8,0xc(%esp)
c0104822:	c0 
c0104823:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c010482a:	c0 
c010482b:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104832:	00 
c0104833:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c010483a:	e8 93 c4 ff ff       	call   c0100cd2 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010483f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104846:	e8 18 f5 ff ff       	call   c0103d63 <alloc_pages>
c010484b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010484e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104853:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010485a:	00 
c010485b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104862:	00 
c0104863:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104866:	89 54 24 04          	mov    %edx,0x4(%esp)
c010486a:	89 04 24             	mov    %eax,(%esp)
c010486d:	e8 e3 fd ff ff       	call   c0104655 <page_insert>
c0104872:	85 c0                	test   %eax,%eax
c0104874:	74 24                	je     c010489a <check_pgdir+0x111>
c0104876:	c7 44 24 0c 10 6c 10 	movl   $0xc0106c10,0xc(%esp)
c010487d:	c0 
c010487e:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104885:	c0 
c0104886:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c010488d:	00 
c010488e:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104895:	e8 38 c4 ff ff       	call   c0100cd2 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010489a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010489f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048a6:	00 
c01048a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048ae:	00 
c01048af:	89 04 24             	mov    %eax,(%esp)
c01048b2:	e8 68 fb ff ff       	call   c010441f <get_pte>
c01048b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048be:	75 24                	jne    c01048e4 <check_pgdir+0x15b>
c01048c0:	c7 44 24 0c 3c 6c 10 	movl   $0xc0106c3c,0xc(%esp)
c01048c7:	c0 
c01048c8:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c01048cf:	c0 
c01048d0:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c01048d7:	00 
c01048d8:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c01048df:	e8 ee c3 ff ff       	call   c0100cd2 <__panic>
    assert(pte2page(*ptep) == p1);
c01048e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048e7:	8b 00                	mov    (%eax),%eax
c01048e9:	89 04 24             	mov    %eax,(%esp)
c01048ec:	e8 17 f2 ff ff       	call   c0103b08 <pte2page>
c01048f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01048f4:	74 24                	je     c010491a <check_pgdir+0x191>
c01048f6:	c7 44 24 0c 69 6c 10 	movl   $0xc0106c69,0xc(%esp)
c01048fd:	c0 
c01048fe:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104905:	c0 
c0104906:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c010490d:	00 
c010490e:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104915:	e8 b8 c3 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p1) == 1);
c010491a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010491d:	89 04 24             	mov    %eax,(%esp)
c0104920:	e8 39 f2 ff ff       	call   c0103b5e <page_ref>
c0104925:	83 f8 01             	cmp    $0x1,%eax
c0104928:	74 24                	je     c010494e <check_pgdir+0x1c5>
c010492a:	c7 44 24 0c 7f 6c 10 	movl   $0xc0106c7f,0xc(%esp)
c0104931:	c0 
c0104932:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104939:	c0 
c010493a:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0104941:	00 
c0104942:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104949:	e8 84 c3 ff ff       	call   c0100cd2 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010494e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104953:	8b 00                	mov    (%eax),%eax
c0104955:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010495a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010495d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104960:	c1 e8 0c             	shr    $0xc,%eax
c0104963:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104966:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010496b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010496e:	72 23                	jb     c0104993 <check_pgdir+0x20a>
c0104970:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104973:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104977:	c7 44 24 08 4c 6a 10 	movl   $0xc0106a4c,0x8(%esp)
c010497e:	c0 
c010497f:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104986:	00 
c0104987:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c010498e:	e8 3f c3 ff ff       	call   c0100cd2 <__panic>
c0104993:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104996:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010499b:	83 c0 04             	add    $0x4,%eax
c010499e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01049a1:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01049a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049ad:	00 
c01049ae:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049b5:	00 
c01049b6:	89 04 24             	mov    %eax,(%esp)
c01049b9:	e8 61 fa ff ff       	call   c010441f <get_pte>
c01049be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049c1:	74 24                	je     c01049e7 <check_pgdir+0x25e>
c01049c3:	c7 44 24 0c 94 6c 10 	movl   $0xc0106c94,0xc(%esp)
c01049ca:	c0 
c01049cb:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c01049d2:	c0 
c01049d3:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c01049da:	00 
c01049db:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c01049e2:	e8 eb c2 ff ff       	call   c0100cd2 <__panic>

    p2 = alloc_page();
c01049e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01049ee:	e8 70 f3 ff ff       	call   c0103d63 <alloc_pages>
c01049f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01049f6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01049fb:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a02:	00 
c0104a03:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a0a:	00 
c0104a0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a0e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a12:	89 04 24             	mov    %eax,(%esp)
c0104a15:	e8 3b fc ff ff       	call   c0104655 <page_insert>
c0104a1a:	85 c0                	test   %eax,%eax
c0104a1c:	74 24                	je     c0104a42 <check_pgdir+0x2b9>
c0104a1e:	c7 44 24 0c bc 6c 10 	movl   $0xc0106cbc,0xc(%esp)
c0104a25:	c0 
c0104a26:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104a2d:	c0 
c0104a2e:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0104a35:	00 
c0104a36:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104a3d:	e8 90 c2 ff ff       	call   c0100cd2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a42:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104a47:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a4e:	00 
c0104a4f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a56:	00 
c0104a57:	89 04 24             	mov    %eax,(%esp)
c0104a5a:	e8 c0 f9 ff ff       	call   c010441f <get_pte>
c0104a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a66:	75 24                	jne    c0104a8c <check_pgdir+0x303>
c0104a68:	c7 44 24 0c f4 6c 10 	movl   $0xc0106cf4,0xc(%esp)
c0104a6f:	c0 
c0104a70:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104a77:	c0 
c0104a78:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104a7f:	00 
c0104a80:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104a87:	e8 46 c2 ff ff       	call   c0100cd2 <__panic>
    assert(*ptep & PTE_U);
c0104a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a8f:	8b 00                	mov    (%eax),%eax
c0104a91:	83 e0 04             	and    $0x4,%eax
c0104a94:	85 c0                	test   %eax,%eax
c0104a96:	75 24                	jne    c0104abc <check_pgdir+0x333>
c0104a98:	c7 44 24 0c 24 6d 10 	movl   $0xc0106d24,0xc(%esp)
c0104a9f:	c0 
c0104aa0:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104aa7:	c0 
c0104aa8:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104aaf:	00 
c0104ab0:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104ab7:	e8 16 c2 ff ff       	call   c0100cd2 <__panic>
    assert(*ptep & PTE_W);
c0104abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104abf:	8b 00                	mov    (%eax),%eax
c0104ac1:	83 e0 02             	and    $0x2,%eax
c0104ac4:	85 c0                	test   %eax,%eax
c0104ac6:	75 24                	jne    c0104aec <check_pgdir+0x363>
c0104ac8:	c7 44 24 0c 32 6d 10 	movl   $0xc0106d32,0xc(%esp)
c0104acf:	c0 
c0104ad0:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104ad7:	c0 
c0104ad8:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0104adf:	00 
c0104ae0:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104ae7:	e8 e6 c1 ff ff       	call   c0100cd2 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104aec:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104af1:	8b 00                	mov    (%eax),%eax
c0104af3:	83 e0 04             	and    $0x4,%eax
c0104af6:	85 c0                	test   %eax,%eax
c0104af8:	75 24                	jne    c0104b1e <check_pgdir+0x395>
c0104afa:	c7 44 24 0c 40 6d 10 	movl   $0xc0106d40,0xc(%esp)
c0104b01:	c0 
c0104b02:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104b09:	c0 
c0104b0a:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0104b11:	00 
c0104b12:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104b19:	e8 b4 c1 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p2) == 1);
c0104b1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b21:	89 04 24             	mov    %eax,(%esp)
c0104b24:	e8 35 f0 ff ff       	call   c0103b5e <page_ref>
c0104b29:	83 f8 01             	cmp    $0x1,%eax
c0104b2c:	74 24                	je     c0104b52 <check_pgdir+0x3c9>
c0104b2e:	c7 44 24 0c 56 6d 10 	movl   $0xc0106d56,0xc(%esp)
c0104b35:	c0 
c0104b36:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104b3d:	c0 
c0104b3e:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0104b45:	00 
c0104b46:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104b4d:	e8 80 c1 ff ff       	call   c0100cd2 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104b52:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104b57:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104b5e:	00 
c0104b5f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104b66:	00 
c0104b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b6a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b6e:	89 04 24             	mov    %eax,(%esp)
c0104b71:	e8 df fa ff ff       	call   c0104655 <page_insert>
c0104b76:	85 c0                	test   %eax,%eax
c0104b78:	74 24                	je     c0104b9e <check_pgdir+0x415>
c0104b7a:	c7 44 24 0c 68 6d 10 	movl   $0xc0106d68,0xc(%esp)
c0104b81:	c0 
c0104b82:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104b89:	c0 
c0104b8a:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0104b91:	00 
c0104b92:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104b99:	e8 34 c1 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p1) == 2);
c0104b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ba1:	89 04 24             	mov    %eax,(%esp)
c0104ba4:	e8 b5 ef ff ff       	call   c0103b5e <page_ref>
c0104ba9:	83 f8 02             	cmp    $0x2,%eax
c0104bac:	74 24                	je     c0104bd2 <check_pgdir+0x449>
c0104bae:	c7 44 24 0c 94 6d 10 	movl   $0xc0106d94,0xc(%esp)
c0104bb5:	c0 
c0104bb6:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104bbd:	c0 
c0104bbe:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0104bc5:	00 
c0104bc6:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104bcd:	e8 00 c1 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p2) == 0);
c0104bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bd5:	89 04 24             	mov    %eax,(%esp)
c0104bd8:	e8 81 ef ff ff       	call   c0103b5e <page_ref>
c0104bdd:	85 c0                	test   %eax,%eax
c0104bdf:	74 24                	je     c0104c05 <check_pgdir+0x47c>
c0104be1:	c7 44 24 0c a6 6d 10 	movl   $0xc0106da6,0xc(%esp)
c0104be8:	c0 
c0104be9:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104bf0:	c0 
c0104bf1:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104bf8:	00 
c0104bf9:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104c00:	e8 cd c0 ff ff       	call   c0100cd2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c05:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104c0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c11:	00 
c0104c12:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c19:	00 
c0104c1a:	89 04 24             	mov    %eax,(%esp)
c0104c1d:	e8 fd f7 ff ff       	call   c010441f <get_pte>
c0104c22:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c29:	75 24                	jne    c0104c4f <check_pgdir+0x4c6>
c0104c2b:	c7 44 24 0c f4 6c 10 	movl   $0xc0106cf4,0xc(%esp)
c0104c32:	c0 
c0104c33:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104c3a:	c0 
c0104c3b:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104c42:	00 
c0104c43:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104c4a:	e8 83 c0 ff ff       	call   c0100cd2 <__panic>
    assert(pte2page(*ptep) == p1);
c0104c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c52:	8b 00                	mov    (%eax),%eax
c0104c54:	89 04 24             	mov    %eax,(%esp)
c0104c57:	e8 ac ee ff ff       	call   c0103b08 <pte2page>
c0104c5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104c5f:	74 24                	je     c0104c85 <check_pgdir+0x4fc>
c0104c61:	c7 44 24 0c 69 6c 10 	movl   $0xc0106c69,0xc(%esp)
c0104c68:	c0 
c0104c69:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104c70:	c0 
c0104c71:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104c78:	00 
c0104c79:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104c80:	e8 4d c0 ff ff       	call   c0100cd2 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c88:	8b 00                	mov    (%eax),%eax
c0104c8a:	83 e0 04             	and    $0x4,%eax
c0104c8d:	85 c0                	test   %eax,%eax
c0104c8f:	74 24                	je     c0104cb5 <check_pgdir+0x52c>
c0104c91:	c7 44 24 0c b8 6d 10 	movl   $0xc0106db8,0xc(%esp)
c0104c98:	c0 
c0104c99:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104ca0:	c0 
c0104ca1:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104ca8:	00 
c0104ca9:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104cb0:	e8 1d c0 ff ff       	call   c0100cd2 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104cb5:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104cba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104cc1:	00 
c0104cc2:	89 04 24             	mov    %eax,(%esp)
c0104cc5:	e8 47 f9 ff ff       	call   c0104611 <page_remove>
    assert(page_ref(p1) == 1);
c0104cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ccd:	89 04 24             	mov    %eax,(%esp)
c0104cd0:	e8 89 ee ff ff       	call   c0103b5e <page_ref>
c0104cd5:	83 f8 01             	cmp    $0x1,%eax
c0104cd8:	74 24                	je     c0104cfe <check_pgdir+0x575>
c0104cda:	c7 44 24 0c 7f 6c 10 	movl   $0xc0106c7f,0xc(%esp)
c0104ce1:	c0 
c0104ce2:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104ce9:	c0 
c0104cea:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104cf1:	00 
c0104cf2:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104cf9:	e8 d4 bf ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p2) == 0);
c0104cfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d01:	89 04 24             	mov    %eax,(%esp)
c0104d04:	e8 55 ee ff ff       	call   c0103b5e <page_ref>
c0104d09:	85 c0                	test   %eax,%eax
c0104d0b:	74 24                	je     c0104d31 <check_pgdir+0x5a8>
c0104d0d:	c7 44 24 0c a6 6d 10 	movl   $0xc0106da6,0xc(%esp)
c0104d14:	c0 
c0104d15:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104d1c:	c0 
c0104d1d:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104d24:	00 
c0104d25:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104d2c:	e8 a1 bf ff ff       	call   c0100cd2 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d31:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104d36:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d3d:	00 
c0104d3e:	89 04 24             	mov    %eax,(%esp)
c0104d41:	e8 cb f8 ff ff       	call   c0104611 <page_remove>
    assert(page_ref(p1) == 0);
c0104d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d49:	89 04 24             	mov    %eax,(%esp)
c0104d4c:	e8 0d ee ff ff       	call   c0103b5e <page_ref>
c0104d51:	85 c0                	test   %eax,%eax
c0104d53:	74 24                	je     c0104d79 <check_pgdir+0x5f0>
c0104d55:	c7 44 24 0c cd 6d 10 	movl   $0xc0106dcd,0xc(%esp)
c0104d5c:	c0 
c0104d5d:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104d64:	c0 
c0104d65:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104d6c:	00 
c0104d6d:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104d74:	e8 59 bf ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p2) == 0);
c0104d79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d7c:	89 04 24             	mov    %eax,(%esp)
c0104d7f:	e8 da ed ff ff       	call   c0103b5e <page_ref>
c0104d84:	85 c0                	test   %eax,%eax
c0104d86:	74 24                	je     c0104dac <check_pgdir+0x623>
c0104d88:	c7 44 24 0c a6 6d 10 	movl   $0xc0106da6,0xc(%esp)
c0104d8f:	c0 
c0104d90:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104d97:	c0 
c0104d98:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104d9f:	00 
c0104da0:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104da7:	e8 26 bf ff ff       	call   c0100cd2 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104dac:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104db1:	8b 00                	mov    (%eax),%eax
c0104db3:	89 04 24             	mov    %eax,(%esp)
c0104db6:	e8 8b ed ff ff       	call   c0103b46 <pde2page>
c0104dbb:	89 04 24             	mov    %eax,(%esp)
c0104dbe:	e8 9b ed ff ff       	call   c0103b5e <page_ref>
c0104dc3:	83 f8 01             	cmp    $0x1,%eax
c0104dc6:	74 24                	je     c0104dec <check_pgdir+0x663>
c0104dc8:	c7 44 24 0c e0 6d 10 	movl   $0xc0106de0,0xc(%esp)
c0104dcf:	c0 
c0104dd0:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104dd7:	c0 
c0104dd8:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104ddf:	00 
c0104de0:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104de7:	e8 e6 be ff ff       	call   c0100cd2 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104dec:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104df1:	8b 00                	mov    (%eax),%eax
c0104df3:	89 04 24             	mov    %eax,(%esp)
c0104df6:	e8 4b ed ff ff       	call   c0103b46 <pde2page>
c0104dfb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e02:	00 
c0104e03:	89 04 24             	mov    %eax,(%esp)
c0104e06:	e8 90 ef ff ff       	call   c0103d9b <free_pages>
    boot_pgdir[0] = 0;
c0104e0b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104e16:	c7 04 24 07 6e 10 c0 	movl   $0xc0106e07,(%esp)
c0104e1d:	e8 26 b5 ff ff       	call   c0100348 <cprintf>
}
c0104e22:	c9                   	leave  
c0104e23:	c3                   	ret    

c0104e24 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e24:	55                   	push   %ebp
c0104e25:	89 e5                	mov    %esp,%ebp
c0104e27:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e31:	e9 ca 00 00 00       	jmp    c0104f00 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e3f:	c1 e8 0c             	shr    $0xc,%eax
c0104e42:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e45:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104e4a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104e4d:	72 23                	jb     c0104e72 <check_boot_pgdir+0x4e>
c0104e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e52:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e56:	c7 44 24 08 4c 6a 10 	movl   $0xc0106a4c,0x8(%esp)
c0104e5d:	c0 
c0104e5e:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104e65:	00 
c0104e66:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104e6d:	e8 60 be ff ff       	call   c0100cd2 <__panic>
c0104e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e75:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e7a:	89 c2                	mov    %eax,%edx
c0104e7c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e81:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e88:	00 
c0104e89:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e8d:	89 04 24             	mov    %eax,(%esp)
c0104e90:	e8 8a f5 ff ff       	call   c010441f <get_pte>
c0104e95:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e98:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104e9c:	75 24                	jne    c0104ec2 <check_boot_pgdir+0x9e>
c0104e9e:	c7 44 24 0c 24 6e 10 	movl   $0xc0106e24,0xc(%esp)
c0104ea5:	c0 
c0104ea6:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104ead:	c0 
c0104eae:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104eb5:	00 
c0104eb6:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104ebd:	e8 10 be ff ff       	call   c0100cd2 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104ec2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ec5:	8b 00                	mov    (%eax),%eax
c0104ec7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ecc:	89 c2                	mov    %eax,%edx
c0104ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed1:	39 c2                	cmp    %eax,%edx
c0104ed3:	74 24                	je     c0104ef9 <check_boot_pgdir+0xd5>
c0104ed5:	c7 44 24 0c 61 6e 10 	movl   $0xc0106e61,0xc(%esp)
c0104edc:	c0 
c0104edd:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104ee4:	c0 
c0104ee5:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104eec:	00 
c0104eed:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104ef4:	e8 d9 bd ff ff       	call   c0100cd2 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104ef9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f00:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f03:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104f08:	39 c2                	cmp    %eax,%edx
c0104f0a:	0f 82 26 ff ff ff    	jb     c0104e36 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104f10:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104f15:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f1a:	8b 00                	mov    (%eax),%eax
c0104f1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f21:	89 c2                	mov    %eax,%edx
c0104f23:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104f28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f2b:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104f32:	77 23                	ja     c0104f57 <check_boot_pgdir+0x133>
c0104f34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f37:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f3b:	c7 44 24 08 f0 6a 10 	movl   $0xc0106af0,0x8(%esp)
c0104f42:	c0 
c0104f43:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104f4a:	00 
c0104f4b:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104f52:	e8 7b bd ff ff       	call   c0100cd2 <__panic>
c0104f57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f5a:	05 00 00 00 40       	add    $0x40000000,%eax
c0104f5f:	39 c2                	cmp    %eax,%edx
c0104f61:	74 24                	je     c0104f87 <check_boot_pgdir+0x163>
c0104f63:	c7 44 24 0c 78 6e 10 	movl   $0xc0106e78,0xc(%esp)
c0104f6a:	c0 
c0104f6b:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104f72:	c0 
c0104f73:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104f7a:	00 
c0104f7b:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104f82:	e8 4b bd ff ff       	call   c0100cd2 <__panic>

    assert(boot_pgdir[0] == 0);
c0104f87:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104f8c:	8b 00                	mov    (%eax),%eax
c0104f8e:	85 c0                	test   %eax,%eax
c0104f90:	74 24                	je     c0104fb6 <check_boot_pgdir+0x192>
c0104f92:	c7 44 24 0c ac 6e 10 	movl   $0xc0106eac,0xc(%esp)
c0104f99:	c0 
c0104f9a:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104fa1:	c0 
c0104fa2:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104fa9:	00 
c0104faa:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104fb1:	e8 1c bd ff ff       	call   c0100cd2 <__panic>

    struct Page *p;
    p = alloc_page();
c0104fb6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104fbd:	e8 a1 ed ff ff       	call   c0103d63 <alloc_pages>
c0104fc2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104fc5:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104fca:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104fd1:	00 
c0104fd2:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104fd9:	00 
c0104fda:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104fdd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104fe1:	89 04 24             	mov    %eax,(%esp)
c0104fe4:	e8 6c f6 ff ff       	call   c0104655 <page_insert>
c0104fe9:	85 c0                	test   %eax,%eax
c0104feb:	74 24                	je     c0105011 <check_boot_pgdir+0x1ed>
c0104fed:	c7 44 24 0c c0 6e 10 	movl   $0xc0106ec0,0xc(%esp)
c0104ff4:	c0 
c0104ff5:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0104ffc:	c0 
c0104ffd:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0105004:	00 
c0105005:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c010500c:	e8 c1 bc ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p) == 1);
c0105011:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105014:	89 04 24             	mov    %eax,(%esp)
c0105017:	e8 42 eb ff ff       	call   c0103b5e <page_ref>
c010501c:	83 f8 01             	cmp    $0x1,%eax
c010501f:	74 24                	je     c0105045 <check_boot_pgdir+0x221>
c0105021:	c7 44 24 0c ee 6e 10 	movl   $0xc0106eee,0xc(%esp)
c0105028:	c0 
c0105029:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0105030:	c0 
c0105031:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0105038:	00 
c0105039:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0105040:	e8 8d bc ff ff       	call   c0100cd2 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105045:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010504a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105051:	00 
c0105052:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105059:	00 
c010505a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010505d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105061:	89 04 24             	mov    %eax,(%esp)
c0105064:	e8 ec f5 ff ff       	call   c0104655 <page_insert>
c0105069:	85 c0                	test   %eax,%eax
c010506b:	74 24                	je     c0105091 <check_boot_pgdir+0x26d>
c010506d:	c7 44 24 0c 00 6f 10 	movl   $0xc0106f00,0xc(%esp)
c0105074:	c0 
c0105075:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c010507c:	c0 
c010507d:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0105084:	00 
c0105085:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c010508c:	e8 41 bc ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p) == 2);
c0105091:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105094:	89 04 24             	mov    %eax,(%esp)
c0105097:	e8 c2 ea ff ff       	call   c0103b5e <page_ref>
c010509c:	83 f8 02             	cmp    $0x2,%eax
c010509f:	74 24                	je     c01050c5 <check_boot_pgdir+0x2a1>
c01050a1:	c7 44 24 0c 37 6f 10 	movl   $0xc0106f37,0xc(%esp)
c01050a8:	c0 
c01050a9:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c01050b0:	c0 
c01050b1:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c01050b8:	00 
c01050b9:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c01050c0:	e8 0d bc ff ff       	call   c0100cd2 <__panic>

    const char *str = "ucore: Hello world!!";
c01050c5:	c7 45 dc 48 6f 10 c0 	movl   $0xc0106f48,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01050cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050d3:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050da:	e8 19 0a 00 00       	call   c0105af8 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01050df:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01050e6:	00 
c01050e7:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050ee:	e8 7e 0a 00 00       	call   c0105b71 <strcmp>
c01050f3:	85 c0                	test   %eax,%eax
c01050f5:	74 24                	je     c010511b <check_boot_pgdir+0x2f7>
c01050f7:	c7 44 24 0c 60 6f 10 	movl   $0xc0106f60,0xc(%esp)
c01050fe:	c0 
c01050ff:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c0105106:	c0 
c0105107:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c010510e:	00 
c010510f:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0105116:	e8 b7 bb ff ff       	call   c0100cd2 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010511b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010511e:	89 04 24             	mov    %eax,(%esp)
c0105121:	e8 8e e9 ff ff       	call   c0103ab4 <page2kva>
c0105126:	05 00 01 00 00       	add    $0x100,%eax
c010512b:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010512e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105135:	e8 66 09 00 00       	call   c0105aa0 <strlen>
c010513a:	85 c0                	test   %eax,%eax
c010513c:	74 24                	je     c0105162 <check_boot_pgdir+0x33e>
c010513e:	c7 44 24 0c 98 6f 10 	movl   $0xc0106f98,0xc(%esp)
c0105145:	c0 
c0105146:	c7 44 24 08 39 6b 10 	movl   $0xc0106b39,0x8(%esp)
c010514d:	c0 
c010514e:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105155:	00 
c0105156:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c010515d:	e8 70 bb ff ff       	call   c0100cd2 <__panic>

    free_page(p);
c0105162:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105169:	00 
c010516a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010516d:	89 04 24             	mov    %eax,(%esp)
c0105170:	e8 26 ec ff ff       	call   c0103d9b <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105175:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010517a:	8b 00                	mov    (%eax),%eax
c010517c:	89 04 24             	mov    %eax,(%esp)
c010517f:	e8 c2 e9 ff ff       	call   c0103b46 <pde2page>
c0105184:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010518b:	00 
c010518c:	89 04 24             	mov    %eax,(%esp)
c010518f:	e8 07 ec ff ff       	call   c0103d9b <free_pages>
    boot_pgdir[0] = 0;
c0105194:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0105199:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010519f:	c7 04 24 bc 6f 10 c0 	movl   $0xc0106fbc,(%esp)
c01051a6:	e8 9d b1 ff ff       	call   c0100348 <cprintf>
}
c01051ab:	c9                   	leave  
c01051ac:	c3                   	ret    

c01051ad <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01051ad:	55                   	push   %ebp
c01051ae:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01051b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01051b3:	83 e0 04             	and    $0x4,%eax
c01051b6:	85 c0                	test   %eax,%eax
c01051b8:	74 07                	je     c01051c1 <perm2str+0x14>
c01051ba:	b8 75 00 00 00       	mov    $0x75,%eax
c01051bf:	eb 05                	jmp    c01051c6 <perm2str+0x19>
c01051c1:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051c6:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c01051cb:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01051d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01051d5:	83 e0 02             	and    $0x2,%eax
c01051d8:	85 c0                	test   %eax,%eax
c01051da:	74 07                	je     c01051e3 <perm2str+0x36>
c01051dc:	b8 77 00 00 00       	mov    $0x77,%eax
c01051e1:	eb 05                	jmp    c01051e8 <perm2str+0x3b>
c01051e3:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051e8:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c01051ed:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c01051f4:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c01051f9:	5d                   	pop    %ebp
c01051fa:	c3                   	ret    

c01051fb <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01051fb:	55                   	push   %ebp
c01051fc:	89 e5                	mov    %esp,%ebp
c01051fe:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105201:	8b 45 10             	mov    0x10(%ebp),%eax
c0105204:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105207:	72 0a                	jb     c0105213 <get_pgtable_items+0x18>
        return 0;
c0105209:	b8 00 00 00 00       	mov    $0x0,%eax
c010520e:	e9 9c 00 00 00       	jmp    c01052af <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105213:	eb 04                	jmp    c0105219 <get_pgtable_items+0x1e>
        start ++;
c0105215:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105219:	8b 45 10             	mov    0x10(%ebp),%eax
c010521c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010521f:	73 18                	jae    c0105239 <get_pgtable_items+0x3e>
c0105221:	8b 45 10             	mov    0x10(%ebp),%eax
c0105224:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010522b:	8b 45 14             	mov    0x14(%ebp),%eax
c010522e:	01 d0                	add    %edx,%eax
c0105230:	8b 00                	mov    (%eax),%eax
c0105232:	83 e0 01             	and    $0x1,%eax
c0105235:	85 c0                	test   %eax,%eax
c0105237:	74 dc                	je     c0105215 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105239:	8b 45 10             	mov    0x10(%ebp),%eax
c010523c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010523f:	73 69                	jae    c01052aa <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105241:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105245:	74 08                	je     c010524f <get_pgtable_items+0x54>
            *left_store = start;
c0105247:	8b 45 18             	mov    0x18(%ebp),%eax
c010524a:	8b 55 10             	mov    0x10(%ebp),%edx
c010524d:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010524f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105252:	8d 50 01             	lea    0x1(%eax),%edx
c0105255:	89 55 10             	mov    %edx,0x10(%ebp)
c0105258:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010525f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105262:	01 d0                	add    %edx,%eax
c0105264:	8b 00                	mov    (%eax),%eax
c0105266:	83 e0 07             	and    $0x7,%eax
c0105269:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010526c:	eb 04                	jmp    c0105272 <get_pgtable_items+0x77>
            start ++;
c010526e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105272:	8b 45 10             	mov    0x10(%ebp),%eax
c0105275:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105278:	73 1d                	jae    c0105297 <get_pgtable_items+0x9c>
c010527a:	8b 45 10             	mov    0x10(%ebp),%eax
c010527d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105284:	8b 45 14             	mov    0x14(%ebp),%eax
c0105287:	01 d0                	add    %edx,%eax
c0105289:	8b 00                	mov    (%eax),%eax
c010528b:	83 e0 07             	and    $0x7,%eax
c010528e:	89 c2                	mov    %eax,%edx
c0105290:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105293:	39 c2                	cmp    %eax,%edx
c0105295:	74 d7                	je     c010526e <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105297:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010529b:	74 08                	je     c01052a5 <get_pgtable_items+0xaa>
            *right_store = start;
c010529d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01052a0:	8b 55 10             	mov    0x10(%ebp),%edx
c01052a3:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01052a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052a8:	eb 05                	jmp    c01052af <get_pgtable_items+0xb4>
    }
    return 0;
c01052aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052af:	c9                   	leave  
c01052b0:	c3                   	ret    

c01052b1 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01052b1:	55                   	push   %ebp
c01052b2:	89 e5                	mov    %esp,%ebp
c01052b4:	57                   	push   %edi
c01052b5:	56                   	push   %esi
c01052b6:	53                   	push   %ebx
c01052b7:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01052ba:	c7 04 24 dc 6f 10 c0 	movl   $0xc0106fdc,(%esp)
c01052c1:	e8 82 b0 ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
c01052c6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01052cd:	e9 fa 00 00 00       	jmp    c01053cc <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01052d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052d5:	89 04 24             	mov    %eax,(%esp)
c01052d8:	e8 d0 fe ff ff       	call   c01051ad <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01052dd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01052e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052e3:	29 d1                	sub    %edx,%ecx
c01052e5:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01052e7:	89 d6                	mov    %edx,%esi
c01052e9:	c1 e6 16             	shl    $0x16,%esi
c01052ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052ef:	89 d3                	mov    %edx,%ebx
c01052f1:	c1 e3 16             	shl    $0x16,%ebx
c01052f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052f7:	89 d1                	mov    %edx,%ecx
c01052f9:	c1 e1 16             	shl    $0x16,%ecx
c01052fc:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01052ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105302:	29 d7                	sub    %edx,%edi
c0105304:	89 fa                	mov    %edi,%edx
c0105306:	89 44 24 14          	mov    %eax,0x14(%esp)
c010530a:	89 74 24 10          	mov    %esi,0x10(%esp)
c010530e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105312:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105316:	89 54 24 04          	mov    %edx,0x4(%esp)
c010531a:	c7 04 24 0d 70 10 c0 	movl   $0xc010700d,(%esp)
c0105321:	e8 22 b0 ff ff       	call   c0100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105326:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105329:	c1 e0 0a             	shl    $0xa,%eax
c010532c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010532f:	eb 54                	jmp    c0105385 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105331:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105334:	89 04 24             	mov    %eax,(%esp)
c0105337:	e8 71 fe ff ff       	call   c01051ad <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010533c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010533f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105342:	29 d1                	sub    %edx,%ecx
c0105344:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105346:	89 d6                	mov    %edx,%esi
c0105348:	c1 e6 0c             	shl    $0xc,%esi
c010534b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010534e:	89 d3                	mov    %edx,%ebx
c0105350:	c1 e3 0c             	shl    $0xc,%ebx
c0105353:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105356:	c1 e2 0c             	shl    $0xc,%edx
c0105359:	89 d1                	mov    %edx,%ecx
c010535b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010535e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105361:	29 d7                	sub    %edx,%edi
c0105363:	89 fa                	mov    %edi,%edx
c0105365:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105369:	89 74 24 10          	mov    %esi,0x10(%esp)
c010536d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105371:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105375:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105379:	c7 04 24 2c 70 10 c0 	movl   $0xc010702c,(%esp)
c0105380:	e8 c3 af ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105385:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010538a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010538d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105390:	89 ce                	mov    %ecx,%esi
c0105392:	c1 e6 0a             	shl    $0xa,%esi
c0105395:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105398:	89 cb                	mov    %ecx,%ebx
c010539a:	c1 e3 0a             	shl    $0xa,%ebx
c010539d:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01053a0:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053a4:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01053a7:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01053ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053af:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053b3:	89 74 24 04          	mov    %esi,0x4(%esp)
c01053b7:	89 1c 24             	mov    %ebx,(%esp)
c01053ba:	e8 3c fe ff ff       	call   c01051fb <get_pgtable_items>
c01053bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053c6:	0f 85 65 ff ff ff    	jne    c0105331 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01053cc:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01053d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053d4:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01053d7:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053db:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01053de:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01053e2:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053e6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053ea:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01053f1:	00 
c01053f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01053f9:	e8 fd fd ff ff       	call   c01051fb <get_pgtable_items>
c01053fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105401:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105405:	0f 85 c7 fe ff ff    	jne    c01052d2 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010540b:	c7 04 24 50 70 10 c0 	movl   $0xc0107050,(%esp)
c0105412:	e8 31 af ff ff       	call   c0100348 <cprintf>
}
c0105417:	83 c4 4c             	add    $0x4c,%esp
c010541a:	5b                   	pop    %ebx
c010541b:	5e                   	pop    %esi
c010541c:	5f                   	pop    %edi
c010541d:	5d                   	pop    %ebp
c010541e:	c3                   	ret    

c010541f <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010541f:	55                   	push   %ebp
c0105420:	89 e5                	mov    %esp,%ebp
c0105422:	83 ec 58             	sub    $0x58,%esp
c0105425:	8b 45 10             	mov    0x10(%ebp),%eax
c0105428:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010542b:	8b 45 14             	mov    0x14(%ebp),%eax
c010542e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105431:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105434:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105437:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010543a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010543d:	8b 45 18             	mov    0x18(%ebp),%eax
c0105440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105443:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105446:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105449:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010544c:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010544f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105452:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105455:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105459:	74 1c                	je     c0105477 <printnum+0x58>
c010545b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010545e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105463:	f7 75 e4             	divl   -0x1c(%ebp)
c0105466:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105469:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010546c:	ba 00 00 00 00       	mov    $0x0,%edx
c0105471:	f7 75 e4             	divl   -0x1c(%ebp)
c0105474:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105477:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010547a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010547d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105480:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105483:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105486:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105489:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010548c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010548f:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105492:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105495:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105498:	8b 45 18             	mov    0x18(%ebp),%eax
c010549b:	ba 00 00 00 00       	mov    $0x0,%edx
c01054a0:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054a3:	77 56                	ja     c01054fb <printnum+0xdc>
c01054a5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054a8:	72 05                	jb     c01054af <printnum+0x90>
c01054aa:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01054ad:	77 4c                	ja     c01054fb <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01054af:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054b2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054b5:	8b 45 20             	mov    0x20(%ebp),%eax
c01054b8:	89 44 24 18          	mov    %eax,0x18(%esp)
c01054bc:	89 54 24 14          	mov    %edx,0x14(%esp)
c01054c0:	8b 45 18             	mov    0x18(%ebp),%eax
c01054c3:	89 44 24 10          	mov    %eax,0x10(%esp)
c01054c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054cd:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01054d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01054df:	89 04 24             	mov    %eax,(%esp)
c01054e2:	e8 38 ff ff ff       	call   c010541f <printnum>
c01054e7:	eb 1c                	jmp    c0105505 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01054e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054f0:	8b 45 20             	mov    0x20(%ebp),%eax
c01054f3:	89 04 24             	mov    %eax,(%esp)
c01054f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01054f9:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01054fb:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01054ff:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105503:	7f e4                	jg     c01054e9 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105505:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105508:	05 04 71 10 c0       	add    $0xc0107104,%eax
c010550d:	0f b6 00             	movzbl (%eax),%eax
c0105510:	0f be c0             	movsbl %al,%eax
c0105513:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105516:	89 54 24 04          	mov    %edx,0x4(%esp)
c010551a:	89 04 24             	mov    %eax,(%esp)
c010551d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105520:	ff d0                	call   *%eax
}
c0105522:	c9                   	leave  
c0105523:	c3                   	ret    

c0105524 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105524:	55                   	push   %ebp
c0105525:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105527:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010552b:	7e 14                	jle    c0105541 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010552d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105530:	8b 00                	mov    (%eax),%eax
c0105532:	8d 48 08             	lea    0x8(%eax),%ecx
c0105535:	8b 55 08             	mov    0x8(%ebp),%edx
c0105538:	89 0a                	mov    %ecx,(%edx)
c010553a:	8b 50 04             	mov    0x4(%eax),%edx
c010553d:	8b 00                	mov    (%eax),%eax
c010553f:	eb 30                	jmp    c0105571 <getuint+0x4d>
    }
    else if (lflag) {
c0105541:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105545:	74 16                	je     c010555d <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105547:	8b 45 08             	mov    0x8(%ebp),%eax
c010554a:	8b 00                	mov    (%eax),%eax
c010554c:	8d 48 04             	lea    0x4(%eax),%ecx
c010554f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105552:	89 0a                	mov    %ecx,(%edx)
c0105554:	8b 00                	mov    (%eax),%eax
c0105556:	ba 00 00 00 00       	mov    $0x0,%edx
c010555b:	eb 14                	jmp    c0105571 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010555d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105560:	8b 00                	mov    (%eax),%eax
c0105562:	8d 48 04             	lea    0x4(%eax),%ecx
c0105565:	8b 55 08             	mov    0x8(%ebp),%edx
c0105568:	89 0a                	mov    %ecx,(%edx)
c010556a:	8b 00                	mov    (%eax),%eax
c010556c:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105571:	5d                   	pop    %ebp
c0105572:	c3                   	ret    

c0105573 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105573:	55                   	push   %ebp
c0105574:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105576:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010557a:	7e 14                	jle    c0105590 <getint+0x1d>
        return va_arg(*ap, long long);
c010557c:	8b 45 08             	mov    0x8(%ebp),%eax
c010557f:	8b 00                	mov    (%eax),%eax
c0105581:	8d 48 08             	lea    0x8(%eax),%ecx
c0105584:	8b 55 08             	mov    0x8(%ebp),%edx
c0105587:	89 0a                	mov    %ecx,(%edx)
c0105589:	8b 50 04             	mov    0x4(%eax),%edx
c010558c:	8b 00                	mov    (%eax),%eax
c010558e:	eb 28                	jmp    c01055b8 <getint+0x45>
    }
    else if (lflag) {
c0105590:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105594:	74 12                	je     c01055a8 <getint+0x35>
        return va_arg(*ap, long);
c0105596:	8b 45 08             	mov    0x8(%ebp),%eax
c0105599:	8b 00                	mov    (%eax),%eax
c010559b:	8d 48 04             	lea    0x4(%eax),%ecx
c010559e:	8b 55 08             	mov    0x8(%ebp),%edx
c01055a1:	89 0a                	mov    %ecx,(%edx)
c01055a3:	8b 00                	mov    (%eax),%eax
c01055a5:	99                   	cltd   
c01055a6:	eb 10                	jmp    c01055b8 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ab:	8b 00                	mov    (%eax),%eax
c01055ad:	8d 48 04             	lea    0x4(%eax),%ecx
c01055b0:	8b 55 08             	mov    0x8(%ebp),%edx
c01055b3:	89 0a                	mov    %ecx,(%edx)
c01055b5:	8b 00                	mov    (%eax),%eax
c01055b7:	99                   	cltd   
    }
}
c01055b8:	5d                   	pop    %ebp
c01055b9:	c3                   	ret    

c01055ba <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01055ba:	55                   	push   %ebp
c01055bb:	89 e5                	mov    %esp,%ebp
c01055bd:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01055c0:	8d 45 14             	lea    0x14(%ebp),%eax
c01055c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01055c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01055d0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055db:	8b 45 08             	mov    0x8(%ebp),%eax
c01055de:	89 04 24             	mov    %eax,(%esp)
c01055e1:	e8 02 00 00 00       	call   c01055e8 <vprintfmt>
    va_end(ap);
}
c01055e6:	c9                   	leave  
c01055e7:	c3                   	ret    

c01055e8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01055e8:	55                   	push   %ebp
c01055e9:	89 e5                	mov    %esp,%ebp
c01055eb:	56                   	push   %esi
c01055ec:	53                   	push   %ebx
c01055ed:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01055f0:	eb 18                	jmp    c010560a <vprintfmt+0x22>
            if (ch == '\0') {
c01055f2:	85 db                	test   %ebx,%ebx
c01055f4:	75 05                	jne    c01055fb <vprintfmt+0x13>
                return;
c01055f6:	e9 d1 03 00 00       	jmp    c01059cc <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01055fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105602:	89 1c 24             	mov    %ebx,(%esp)
c0105605:	8b 45 08             	mov    0x8(%ebp),%eax
c0105608:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010560a:	8b 45 10             	mov    0x10(%ebp),%eax
c010560d:	8d 50 01             	lea    0x1(%eax),%edx
c0105610:	89 55 10             	mov    %edx,0x10(%ebp)
c0105613:	0f b6 00             	movzbl (%eax),%eax
c0105616:	0f b6 d8             	movzbl %al,%ebx
c0105619:	83 fb 25             	cmp    $0x25,%ebx
c010561c:	75 d4                	jne    c01055f2 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010561e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105622:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010562c:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010562f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105636:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105639:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010563c:	8b 45 10             	mov    0x10(%ebp),%eax
c010563f:	8d 50 01             	lea    0x1(%eax),%edx
c0105642:	89 55 10             	mov    %edx,0x10(%ebp)
c0105645:	0f b6 00             	movzbl (%eax),%eax
c0105648:	0f b6 d8             	movzbl %al,%ebx
c010564b:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010564e:	83 f8 55             	cmp    $0x55,%eax
c0105651:	0f 87 44 03 00 00    	ja     c010599b <vprintfmt+0x3b3>
c0105657:	8b 04 85 28 71 10 c0 	mov    -0x3fef8ed8(,%eax,4),%eax
c010565e:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105660:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105664:	eb d6                	jmp    c010563c <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105666:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010566a:	eb d0                	jmp    c010563c <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010566c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105673:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105676:	89 d0                	mov    %edx,%eax
c0105678:	c1 e0 02             	shl    $0x2,%eax
c010567b:	01 d0                	add    %edx,%eax
c010567d:	01 c0                	add    %eax,%eax
c010567f:	01 d8                	add    %ebx,%eax
c0105681:	83 e8 30             	sub    $0x30,%eax
c0105684:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105687:	8b 45 10             	mov    0x10(%ebp),%eax
c010568a:	0f b6 00             	movzbl (%eax),%eax
c010568d:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105690:	83 fb 2f             	cmp    $0x2f,%ebx
c0105693:	7e 0b                	jle    c01056a0 <vprintfmt+0xb8>
c0105695:	83 fb 39             	cmp    $0x39,%ebx
c0105698:	7f 06                	jg     c01056a0 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010569a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010569e:	eb d3                	jmp    c0105673 <vprintfmt+0x8b>
            goto process_precision;
c01056a0:	eb 33                	jmp    c01056d5 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01056a2:	8b 45 14             	mov    0x14(%ebp),%eax
c01056a5:	8d 50 04             	lea    0x4(%eax),%edx
c01056a8:	89 55 14             	mov    %edx,0x14(%ebp)
c01056ab:	8b 00                	mov    (%eax),%eax
c01056ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056b0:	eb 23                	jmp    c01056d5 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01056b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056b6:	79 0c                	jns    c01056c4 <vprintfmt+0xdc>
                width = 0;
c01056b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056bf:	e9 78 ff ff ff       	jmp    c010563c <vprintfmt+0x54>
c01056c4:	e9 73 ff ff ff       	jmp    c010563c <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01056c9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01056d0:	e9 67 ff ff ff       	jmp    c010563c <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01056d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056d9:	79 12                	jns    c01056ed <vprintfmt+0x105>
                width = precision, precision = -1;
c01056db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056de:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056e1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01056e8:	e9 4f ff ff ff       	jmp    c010563c <vprintfmt+0x54>
c01056ed:	e9 4a ff ff ff       	jmp    c010563c <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01056f2:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01056f6:	e9 41 ff ff ff       	jmp    c010563c <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01056fb:	8b 45 14             	mov    0x14(%ebp),%eax
c01056fe:	8d 50 04             	lea    0x4(%eax),%edx
c0105701:	89 55 14             	mov    %edx,0x14(%ebp)
c0105704:	8b 00                	mov    (%eax),%eax
c0105706:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105709:	89 54 24 04          	mov    %edx,0x4(%esp)
c010570d:	89 04 24             	mov    %eax,(%esp)
c0105710:	8b 45 08             	mov    0x8(%ebp),%eax
c0105713:	ff d0                	call   *%eax
            break;
c0105715:	e9 ac 02 00 00       	jmp    c01059c6 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010571a:	8b 45 14             	mov    0x14(%ebp),%eax
c010571d:	8d 50 04             	lea    0x4(%eax),%edx
c0105720:	89 55 14             	mov    %edx,0x14(%ebp)
c0105723:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105725:	85 db                	test   %ebx,%ebx
c0105727:	79 02                	jns    c010572b <vprintfmt+0x143>
                err = -err;
c0105729:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010572b:	83 fb 06             	cmp    $0x6,%ebx
c010572e:	7f 0b                	jg     c010573b <vprintfmt+0x153>
c0105730:	8b 34 9d e8 70 10 c0 	mov    -0x3fef8f18(,%ebx,4),%esi
c0105737:	85 f6                	test   %esi,%esi
c0105739:	75 23                	jne    c010575e <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010573b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010573f:	c7 44 24 08 15 71 10 	movl   $0xc0107115,0x8(%esp)
c0105746:	c0 
c0105747:	8b 45 0c             	mov    0xc(%ebp),%eax
c010574a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010574e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105751:	89 04 24             	mov    %eax,(%esp)
c0105754:	e8 61 fe ff ff       	call   c01055ba <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105759:	e9 68 02 00 00       	jmp    c01059c6 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010575e:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105762:	c7 44 24 08 1e 71 10 	movl   $0xc010711e,0x8(%esp)
c0105769:	c0 
c010576a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010576d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105771:	8b 45 08             	mov    0x8(%ebp),%eax
c0105774:	89 04 24             	mov    %eax,(%esp)
c0105777:	e8 3e fe ff ff       	call   c01055ba <printfmt>
            }
            break;
c010577c:	e9 45 02 00 00       	jmp    c01059c6 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105781:	8b 45 14             	mov    0x14(%ebp),%eax
c0105784:	8d 50 04             	lea    0x4(%eax),%edx
c0105787:	89 55 14             	mov    %edx,0x14(%ebp)
c010578a:	8b 30                	mov    (%eax),%esi
c010578c:	85 f6                	test   %esi,%esi
c010578e:	75 05                	jne    c0105795 <vprintfmt+0x1ad>
                p = "(null)";
c0105790:	be 21 71 10 c0       	mov    $0xc0107121,%esi
            }
            if (width > 0 && padc != '-') {
c0105795:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105799:	7e 3e                	jle    c01057d9 <vprintfmt+0x1f1>
c010579b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010579f:	74 38                	je     c01057d9 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057a1:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01057a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057a7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ab:	89 34 24             	mov    %esi,(%esp)
c01057ae:	e8 15 03 00 00       	call   c0105ac8 <strnlen>
c01057b3:	29 c3                	sub    %eax,%ebx
c01057b5:	89 d8                	mov    %ebx,%eax
c01057b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057ba:	eb 17                	jmp    c01057d3 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01057bc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057c0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057c3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057c7:	89 04 24             	mov    %eax,(%esp)
c01057ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01057cd:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057cf:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057d7:	7f e3                	jg     c01057bc <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057d9:	eb 38                	jmp    c0105813 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01057db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01057df:	74 1f                	je     c0105800 <vprintfmt+0x218>
c01057e1:	83 fb 1f             	cmp    $0x1f,%ebx
c01057e4:	7e 05                	jle    c01057eb <vprintfmt+0x203>
c01057e6:	83 fb 7e             	cmp    $0x7e,%ebx
c01057e9:	7e 15                	jle    c0105800 <vprintfmt+0x218>
                    putch('?', putdat);
c01057eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057f2:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01057f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01057fc:	ff d0                	call   *%eax
c01057fe:	eb 0f                	jmp    c010580f <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105800:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105803:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105807:	89 1c 24             	mov    %ebx,(%esp)
c010580a:	8b 45 08             	mov    0x8(%ebp),%eax
c010580d:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010580f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105813:	89 f0                	mov    %esi,%eax
c0105815:	8d 70 01             	lea    0x1(%eax),%esi
c0105818:	0f b6 00             	movzbl (%eax),%eax
c010581b:	0f be d8             	movsbl %al,%ebx
c010581e:	85 db                	test   %ebx,%ebx
c0105820:	74 10                	je     c0105832 <vprintfmt+0x24a>
c0105822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105826:	78 b3                	js     c01057db <vprintfmt+0x1f3>
c0105828:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010582c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105830:	79 a9                	jns    c01057db <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105832:	eb 17                	jmp    c010584b <vprintfmt+0x263>
                putch(' ', putdat);
c0105834:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105837:	89 44 24 04          	mov    %eax,0x4(%esp)
c010583b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105842:	8b 45 08             	mov    0x8(%ebp),%eax
c0105845:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105847:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010584b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010584f:	7f e3                	jg     c0105834 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105851:	e9 70 01 00 00       	jmp    c01059c6 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105856:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105859:	89 44 24 04          	mov    %eax,0x4(%esp)
c010585d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105860:	89 04 24             	mov    %eax,(%esp)
c0105863:	e8 0b fd ff ff       	call   c0105573 <getint>
c0105868:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010586b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010586e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105871:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105874:	85 d2                	test   %edx,%edx
c0105876:	79 26                	jns    c010589e <vprintfmt+0x2b6>
                putch('-', putdat);
c0105878:	8b 45 0c             	mov    0xc(%ebp),%eax
c010587b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010587f:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105886:	8b 45 08             	mov    0x8(%ebp),%eax
c0105889:	ff d0                	call   *%eax
                num = -(long long)num;
c010588b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010588e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105891:	f7 d8                	neg    %eax
c0105893:	83 d2 00             	adc    $0x0,%edx
c0105896:	f7 da                	neg    %edx
c0105898:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010589b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010589e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058a5:	e9 a8 00 00 00       	jmp    c0105952 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058b1:	8d 45 14             	lea    0x14(%ebp),%eax
c01058b4:	89 04 24             	mov    %eax,(%esp)
c01058b7:	e8 68 fc ff ff       	call   c0105524 <getuint>
c01058bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058c2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058c9:	e9 84 00 00 00       	jmp    c0105952 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058d5:	8d 45 14             	lea    0x14(%ebp),%eax
c01058d8:	89 04 24             	mov    %eax,(%esp)
c01058db:	e8 44 fc ff ff       	call   c0105524 <getuint>
c01058e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01058e6:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01058ed:	eb 63                	jmp    c0105952 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01058ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01058fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105900:	ff d0                	call   *%eax
            putch('x', putdat);
c0105902:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105905:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105909:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105910:	8b 45 08             	mov    0x8(%ebp),%eax
c0105913:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105915:	8b 45 14             	mov    0x14(%ebp),%eax
c0105918:	8d 50 04             	lea    0x4(%eax),%edx
c010591b:	89 55 14             	mov    %edx,0x14(%ebp)
c010591e:	8b 00                	mov    (%eax),%eax
c0105920:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105923:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010592a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105931:	eb 1f                	jmp    c0105952 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105933:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105936:	89 44 24 04          	mov    %eax,0x4(%esp)
c010593a:	8d 45 14             	lea    0x14(%ebp),%eax
c010593d:	89 04 24             	mov    %eax,(%esp)
c0105940:	e8 df fb ff ff       	call   c0105524 <getuint>
c0105945:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105948:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010594b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105952:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105956:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105959:	89 54 24 18          	mov    %edx,0x18(%esp)
c010595d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105960:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105964:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105968:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010596b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010596e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105972:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105976:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105979:	89 44 24 04          	mov    %eax,0x4(%esp)
c010597d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105980:	89 04 24             	mov    %eax,(%esp)
c0105983:	e8 97 fa ff ff       	call   c010541f <printnum>
            break;
c0105988:	eb 3c                	jmp    c01059c6 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010598a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010598d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105991:	89 1c 24             	mov    %ebx,(%esp)
c0105994:	8b 45 08             	mov    0x8(%ebp),%eax
c0105997:	ff d0                	call   *%eax
            break;
c0105999:	eb 2b                	jmp    c01059c6 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010599b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010599e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059a2:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01059a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ac:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01059ae:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059b2:	eb 04                	jmp    c01059b8 <vprintfmt+0x3d0>
c01059b4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059b8:	8b 45 10             	mov    0x10(%ebp),%eax
c01059bb:	83 e8 01             	sub    $0x1,%eax
c01059be:	0f b6 00             	movzbl (%eax),%eax
c01059c1:	3c 25                	cmp    $0x25,%al
c01059c3:	75 ef                	jne    c01059b4 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01059c5:	90                   	nop
        }
    }
c01059c6:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01059c7:	e9 3e fc ff ff       	jmp    c010560a <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01059cc:	83 c4 40             	add    $0x40,%esp
c01059cf:	5b                   	pop    %ebx
c01059d0:	5e                   	pop    %esi
c01059d1:	5d                   	pop    %ebp
c01059d2:	c3                   	ret    

c01059d3 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01059d3:	55                   	push   %ebp
c01059d4:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01059d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059d9:	8b 40 08             	mov    0x8(%eax),%eax
c01059dc:	8d 50 01             	lea    0x1(%eax),%edx
c01059df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e2:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01059e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e8:	8b 10                	mov    (%eax),%edx
c01059ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ed:	8b 40 04             	mov    0x4(%eax),%eax
c01059f0:	39 c2                	cmp    %eax,%edx
c01059f2:	73 12                	jae    c0105a06 <sprintputch+0x33>
        *b->buf ++ = ch;
c01059f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f7:	8b 00                	mov    (%eax),%eax
c01059f9:	8d 48 01             	lea    0x1(%eax),%ecx
c01059fc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059ff:	89 0a                	mov    %ecx,(%edx)
c0105a01:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a04:	88 10                	mov    %dl,(%eax)
    }
}
c0105a06:	5d                   	pop    %ebp
c0105a07:	c3                   	ret    

c0105a08 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a08:	55                   	push   %ebp
c0105a09:	89 e5                	mov    %esp,%ebp
c0105a0b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a0e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a17:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a1b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a1e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a2c:	89 04 24             	mov    %eax,(%esp)
c0105a2f:	e8 08 00 00 00       	call   c0105a3c <vsnprintf>
c0105a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a3a:	c9                   	leave  
c0105a3b:	c3                   	ret    

c0105a3c <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a3c:	55                   	push   %ebp
c0105a3d:	89 e5                	mov    %esp,%ebp
c0105a3f:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a42:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a45:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a4b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a51:	01 d0                	add    %edx,%eax
c0105a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a61:	74 0a                	je     c0105a6d <vsnprintf+0x31>
c0105a63:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a69:	39 c2                	cmp    %eax,%edx
c0105a6b:	76 07                	jbe    c0105a74 <vsnprintf+0x38>
        return -E_INVAL;
c0105a6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a72:	eb 2a                	jmp    c0105a9e <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105a74:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a77:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a7b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a7e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a82:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105a85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a89:	c7 04 24 d3 59 10 c0 	movl   $0xc01059d3,(%esp)
c0105a90:	e8 53 fb ff ff       	call   c01055e8 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a98:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a9e:	c9                   	leave  
c0105a9f:	c3                   	ret    

c0105aa0 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105aa0:	55                   	push   %ebp
c0105aa1:	89 e5                	mov    %esp,%ebp
c0105aa3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105aa6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105aad:	eb 04                	jmp    c0105ab3 <strlen+0x13>
        cnt ++;
c0105aaf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab6:	8d 50 01             	lea    0x1(%eax),%edx
c0105ab9:	89 55 08             	mov    %edx,0x8(%ebp)
c0105abc:	0f b6 00             	movzbl (%eax),%eax
c0105abf:	84 c0                	test   %al,%al
c0105ac1:	75 ec                	jne    c0105aaf <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105ac3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105ac6:	c9                   	leave  
c0105ac7:	c3                   	ret    

c0105ac8 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105ac8:	55                   	push   %ebp
c0105ac9:	89 e5                	mov    %esp,%ebp
c0105acb:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ace:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105ad5:	eb 04                	jmp    c0105adb <strnlen+0x13>
        cnt ++;
c0105ad7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105adb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ade:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ae1:	73 10                	jae    c0105af3 <strnlen+0x2b>
c0105ae3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae6:	8d 50 01             	lea    0x1(%eax),%edx
c0105ae9:	89 55 08             	mov    %edx,0x8(%ebp)
c0105aec:	0f b6 00             	movzbl (%eax),%eax
c0105aef:	84 c0                	test   %al,%al
c0105af1:	75 e4                	jne    c0105ad7 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105af3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105af6:	c9                   	leave  
c0105af7:	c3                   	ret    

c0105af8 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105af8:	55                   	push   %ebp
c0105af9:	89 e5                	mov    %esp,%ebp
c0105afb:	57                   	push   %edi
c0105afc:	56                   	push   %esi
c0105afd:	83 ec 20             	sub    $0x20,%esp
c0105b00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b06:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105b0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b12:	89 d1                	mov    %edx,%ecx
c0105b14:	89 c2                	mov    %eax,%edx
c0105b16:	89 ce                	mov    %ecx,%esi
c0105b18:	89 d7                	mov    %edx,%edi
c0105b1a:	ac                   	lods   %ds:(%esi),%al
c0105b1b:	aa                   	stos   %al,%es:(%edi)
c0105b1c:	84 c0                	test   %al,%al
c0105b1e:	75 fa                	jne    c0105b1a <strcpy+0x22>
c0105b20:	89 fa                	mov    %edi,%edx
c0105b22:	89 f1                	mov    %esi,%ecx
c0105b24:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b27:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105b30:	83 c4 20             	add    $0x20,%esp
c0105b33:	5e                   	pop    %esi
c0105b34:	5f                   	pop    %edi
c0105b35:	5d                   	pop    %ebp
c0105b36:	c3                   	ret    

c0105b37 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105b37:	55                   	push   %ebp
c0105b38:	89 e5                	mov    %esp,%ebp
c0105b3a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b40:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105b43:	eb 21                	jmp    c0105b66 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105b45:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b48:	0f b6 10             	movzbl (%eax),%edx
c0105b4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b4e:	88 10                	mov    %dl,(%eax)
c0105b50:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b53:	0f b6 00             	movzbl (%eax),%eax
c0105b56:	84 c0                	test   %al,%al
c0105b58:	74 04                	je     c0105b5e <strncpy+0x27>
            src ++;
c0105b5a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105b5e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105b62:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105b66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b6a:	75 d9                	jne    c0105b45 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105b6c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b6f:	c9                   	leave  
c0105b70:	c3                   	ret    

c0105b71 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105b71:	55                   	push   %ebp
c0105b72:	89 e5                	mov    %esp,%ebp
c0105b74:	57                   	push   %edi
c0105b75:	56                   	push   %esi
c0105b76:	83 ec 20             	sub    $0x20,%esp
c0105b79:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b8b:	89 d1                	mov    %edx,%ecx
c0105b8d:	89 c2                	mov    %eax,%edx
c0105b8f:	89 ce                	mov    %ecx,%esi
c0105b91:	89 d7                	mov    %edx,%edi
c0105b93:	ac                   	lods   %ds:(%esi),%al
c0105b94:	ae                   	scas   %es:(%edi),%al
c0105b95:	75 08                	jne    c0105b9f <strcmp+0x2e>
c0105b97:	84 c0                	test   %al,%al
c0105b99:	75 f8                	jne    c0105b93 <strcmp+0x22>
c0105b9b:	31 c0                	xor    %eax,%eax
c0105b9d:	eb 04                	jmp    c0105ba3 <strcmp+0x32>
c0105b9f:	19 c0                	sbb    %eax,%eax
c0105ba1:	0c 01                	or     $0x1,%al
c0105ba3:	89 fa                	mov    %edi,%edx
c0105ba5:	89 f1                	mov    %esi,%ecx
c0105ba7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105baa:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105bad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105bb3:	83 c4 20             	add    $0x20,%esp
c0105bb6:	5e                   	pop    %esi
c0105bb7:	5f                   	pop    %edi
c0105bb8:	5d                   	pop    %ebp
c0105bb9:	c3                   	ret    

c0105bba <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105bba:	55                   	push   %ebp
c0105bbb:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bbd:	eb 0c                	jmp    c0105bcb <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105bbf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105bc3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bc7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bcf:	74 1a                	je     c0105beb <strncmp+0x31>
c0105bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd4:	0f b6 00             	movzbl (%eax),%eax
c0105bd7:	84 c0                	test   %al,%al
c0105bd9:	74 10                	je     c0105beb <strncmp+0x31>
c0105bdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bde:	0f b6 10             	movzbl (%eax),%edx
c0105be1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105be4:	0f b6 00             	movzbl (%eax),%eax
c0105be7:	38 c2                	cmp    %al,%dl
c0105be9:	74 d4                	je     c0105bbf <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105beb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bef:	74 18                	je     c0105c09 <strncmp+0x4f>
c0105bf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf4:	0f b6 00             	movzbl (%eax),%eax
c0105bf7:	0f b6 d0             	movzbl %al,%edx
c0105bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bfd:	0f b6 00             	movzbl (%eax),%eax
c0105c00:	0f b6 c0             	movzbl %al,%eax
c0105c03:	29 c2                	sub    %eax,%edx
c0105c05:	89 d0                	mov    %edx,%eax
c0105c07:	eb 05                	jmp    c0105c0e <strncmp+0x54>
c0105c09:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c0e:	5d                   	pop    %ebp
c0105c0f:	c3                   	ret    

c0105c10 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105c10:	55                   	push   %ebp
c0105c11:	89 e5                	mov    %esp,%ebp
c0105c13:	83 ec 04             	sub    $0x4,%esp
c0105c16:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c19:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c1c:	eb 14                	jmp    c0105c32 <strchr+0x22>
        if (*s == c) {
c0105c1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c21:	0f b6 00             	movzbl (%eax),%eax
c0105c24:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c27:	75 05                	jne    c0105c2e <strchr+0x1e>
            return (char *)s;
c0105c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c2c:	eb 13                	jmp    c0105c41 <strchr+0x31>
        }
        s ++;
c0105c2e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c35:	0f b6 00             	movzbl (%eax),%eax
c0105c38:	84 c0                	test   %al,%al
c0105c3a:	75 e2                	jne    c0105c1e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105c3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c41:	c9                   	leave  
c0105c42:	c3                   	ret    

c0105c43 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105c43:	55                   	push   %ebp
c0105c44:	89 e5                	mov    %esp,%ebp
c0105c46:	83 ec 04             	sub    $0x4,%esp
c0105c49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c4c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c4f:	eb 11                	jmp    c0105c62 <strfind+0x1f>
        if (*s == c) {
c0105c51:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c54:	0f b6 00             	movzbl (%eax),%eax
c0105c57:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c5a:	75 02                	jne    c0105c5e <strfind+0x1b>
            break;
c0105c5c:	eb 0e                	jmp    c0105c6c <strfind+0x29>
        }
        s ++;
c0105c5e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105c62:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c65:	0f b6 00             	movzbl (%eax),%eax
c0105c68:	84 c0                	test   %al,%al
c0105c6a:	75 e5                	jne    c0105c51 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105c6c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c6f:	c9                   	leave  
c0105c70:	c3                   	ret    

c0105c71 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105c71:	55                   	push   %ebp
c0105c72:	89 e5                	mov    %esp,%ebp
c0105c74:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105c77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105c7e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c85:	eb 04                	jmp    c0105c8b <strtol+0x1a>
        s ++;
c0105c87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c8e:	0f b6 00             	movzbl (%eax),%eax
c0105c91:	3c 20                	cmp    $0x20,%al
c0105c93:	74 f2                	je     c0105c87 <strtol+0x16>
c0105c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c98:	0f b6 00             	movzbl (%eax),%eax
c0105c9b:	3c 09                	cmp    $0x9,%al
c0105c9d:	74 e8                	je     c0105c87 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca2:	0f b6 00             	movzbl (%eax),%eax
c0105ca5:	3c 2b                	cmp    $0x2b,%al
c0105ca7:	75 06                	jne    c0105caf <strtol+0x3e>
        s ++;
c0105ca9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cad:	eb 15                	jmp    c0105cc4 <strtol+0x53>
    }
    else if (*s == '-') {
c0105caf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb2:	0f b6 00             	movzbl (%eax),%eax
c0105cb5:	3c 2d                	cmp    $0x2d,%al
c0105cb7:	75 0b                	jne    c0105cc4 <strtol+0x53>
        s ++, neg = 1;
c0105cb9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cbd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105cc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cc8:	74 06                	je     c0105cd0 <strtol+0x5f>
c0105cca:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105cce:	75 24                	jne    c0105cf4 <strtol+0x83>
c0105cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd3:	0f b6 00             	movzbl (%eax),%eax
c0105cd6:	3c 30                	cmp    $0x30,%al
c0105cd8:	75 1a                	jne    c0105cf4 <strtol+0x83>
c0105cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cdd:	83 c0 01             	add    $0x1,%eax
c0105ce0:	0f b6 00             	movzbl (%eax),%eax
c0105ce3:	3c 78                	cmp    $0x78,%al
c0105ce5:	75 0d                	jne    c0105cf4 <strtol+0x83>
        s += 2, base = 16;
c0105ce7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105ceb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105cf2:	eb 2a                	jmp    c0105d1e <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105cf4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cf8:	75 17                	jne    c0105d11 <strtol+0xa0>
c0105cfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cfd:	0f b6 00             	movzbl (%eax),%eax
c0105d00:	3c 30                	cmp    $0x30,%al
c0105d02:	75 0d                	jne    c0105d11 <strtol+0xa0>
        s ++, base = 8;
c0105d04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d08:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d0f:	eb 0d                	jmp    c0105d1e <strtol+0xad>
    }
    else if (base == 0) {
c0105d11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d15:	75 07                	jne    c0105d1e <strtol+0xad>
        base = 10;
c0105d17:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d21:	0f b6 00             	movzbl (%eax),%eax
c0105d24:	3c 2f                	cmp    $0x2f,%al
c0105d26:	7e 1b                	jle    c0105d43 <strtol+0xd2>
c0105d28:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d2b:	0f b6 00             	movzbl (%eax),%eax
c0105d2e:	3c 39                	cmp    $0x39,%al
c0105d30:	7f 11                	jg     c0105d43 <strtol+0xd2>
            dig = *s - '0';
c0105d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d35:	0f b6 00             	movzbl (%eax),%eax
c0105d38:	0f be c0             	movsbl %al,%eax
c0105d3b:	83 e8 30             	sub    $0x30,%eax
c0105d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d41:	eb 48                	jmp    c0105d8b <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105d43:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d46:	0f b6 00             	movzbl (%eax),%eax
c0105d49:	3c 60                	cmp    $0x60,%al
c0105d4b:	7e 1b                	jle    c0105d68 <strtol+0xf7>
c0105d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d50:	0f b6 00             	movzbl (%eax),%eax
c0105d53:	3c 7a                	cmp    $0x7a,%al
c0105d55:	7f 11                	jg     c0105d68 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105d57:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5a:	0f b6 00             	movzbl (%eax),%eax
c0105d5d:	0f be c0             	movsbl %al,%eax
c0105d60:	83 e8 57             	sub    $0x57,%eax
c0105d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d66:	eb 23                	jmp    c0105d8b <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105d68:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d6b:	0f b6 00             	movzbl (%eax),%eax
c0105d6e:	3c 40                	cmp    $0x40,%al
c0105d70:	7e 3d                	jle    c0105daf <strtol+0x13e>
c0105d72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d75:	0f b6 00             	movzbl (%eax),%eax
c0105d78:	3c 5a                	cmp    $0x5a,%al
c0105d7a:	7f 33                	jg     c0105daf <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105d7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d7f:	0f b6 00             	movzbl (%eax),%eax
c0105d82:	0f be c0             	movsbl %al,%eax
c0105d85:	83 e8 37             	sub    $0x37,%eax
c0105d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d8e:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105d91:	7c 02                	jl     c0105d95 <strtol+0x124>
            break;
c0105d93:	eb 1a                	jmp    c0105daf <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105d95:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d99:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d9c:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105da0:	89 c2                	mov    %eax,%edx
c0105da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105da5:	01 d0                	add    %edx,%eax
c0105da7:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105daa:	e9 6f ff ff ff       	jmp    c0105d1e <strtol+0xad>

    if (endptr) {
c0105daf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105db3:	74 08                	je     c0105dbd <strtol+0x14c>
        *endptr = (char *) s;
c0105db5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105db8:	8b 55 08             	mov    0x8(%ebp),%edx
c0105dbb:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105dbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105dc1:	74 07                	je     c0105dca <strtol+0x159>
c0105dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dc6:	f7 d8                	neg    %eax
c0105dc8:	eb 03                	jmp    c0105dcd <strtol+0x15c>
c0105dca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105dcd:	c9                   	leave  
c0105dce:	c3                   	ret    

c0105dcf <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105dcf:	55                   	push   %ebp
c0105dd0:	89 e5                	mov    %esp,%ebp
c0105dd2:	57                   	push   %edi
c0105dd3:	83 ec 24             	sub    $0x24,%esp
c0105dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dd9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105ddc:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105de0:	8b 55 08             	mov    0x8(%ebp),%edx
c0105de3:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105de6:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105de9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105def:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105df2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105df6:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105df9:	89 d7                	mov    %edx,%edi
c0105dfb:	f3 aa                	rep stos %al,%es:(%edi)
c0105dfd:	89 fa                	mov    %edi,%edx
c0105dff:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e02:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105e05:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e08:	83 c4 24             	add    $0x24,%esp
c0105e0b:	5f                   	pop    %edi
c0105e0c:	5d                   	pop    %ebp
c0105e0d:	c3                   	ret    

c0105e0e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105e0e:	55                   	push   %ebp
c0105e0f:	89 e5                	mov    %esp,%ebp
c0105e11:	57                   	push   %edi
c0105e12:	56                   	push   %esi
c0105e13:	53                   	push   %ebx
c0105e14:	83 ec 30             	sub    $0x30,%esp
c0105e17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e20:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e23:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e26:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e2c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105e2f:	73 42                	jae    c0105e73 <memmove+0x65>
c0105e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e40:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e43:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e46:	c1 e8 02             	shr    $0x2,%eax
c0105e49:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e4b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e51:	89 d7                	mov    %edx,%edi
c0105e53:	89 c6                	mov    %eax,%esi
c0105e55:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e57:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e5a:	83 e1 03             	and    $0x3,%ecx
c0105e5d:	74 02                	je     c0105e61 <memmove+0x53>
c0105e5f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e61:	89 f0                	mov    %esi,%eax
c0105e63:	89 fa                	mov    %edi,%edx
c0105e65:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105e68:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105e6b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e71:	eb 36                	jmp    c0105ea9 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105e73:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e76:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e79:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e7c:	01 c2                	add    %eax,%edx
c0105e7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e81:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e87:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e8d:	89 c1                	mov    %eax,%ecx
c0105e8f:	89 d8                	mov    %ebx,%eax
c0105e91:	89 d6                	mov    %edx,%esi
c0105e93:	89 c7                	mov    %eax,%edi
c0105e95:	fd                   	std    
c0105e96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e98:	fc                   	cld    
c0105e99:	89 f8                	mov    %edi,%eax
c0105e9b:	89 f2                	mov    %esi,%edx
c0105e9d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105ea0:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105ea3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105ea9:	83 c4 30             	add    $0x30,%esp
c0105eac:	5b                   	pop    %ebx
c0105ead:	5e                   	pop    %esi
c0105eae:	5f                   	pop    %edi
c0105eaf:	5d                   	pop    %ebp
c0105eb0:	c3                   	ret    

c0105eb1 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105eb1:	55                   	push   %ebp
c0105eb2:	89 e5                	mov    %esp,%ebp
c0105eb4:	57                   	push   %edi
c0105eb5:	56                   	push   %esi
c0105eb6:	83 ec 20             	sub    $0x20,%esp
c0105eb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ebc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ec5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ec8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ece:	c1 e8 02             	shr    $0x2,%eax
c0105ed1:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105ed3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ed9:	89 d7                	mov    %edx,%edi
c0105edb:	89 c6                	mov    %eax,%esi
c0105edd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105edf:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105ee2:	83 e1 03             	and    $0x3,%ecx
c0105ee5:	74 02                	je     c0105ee9 <memcpy+0x38>
c0105ee7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ee9:	89 f0                	mov    %esi,%eax
c0105eeb:	89 fa                	mov    %edi,%edx
c0105eed:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105ef0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105ef3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105ef9:	83 c4 20             	add    $0x20,%esp
c0105efc:	5e                   	pop    %esi
c0105efd:	5f                   	pop    %edi
c0105efe:	5d                   	pop    %ebp
c0105eff:	c3                   	ret    

c0105f00 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105f00:	55                   	push   %ebp
c0105f01:	89 e5                	mov    %esp,%ebp
c0105f03:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f06:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f09:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105f12:	eb 30                	jmp    c0105f44 <memcmp+0x44>
        if (*s1 != *s2) {
c0105f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f17:	0f b6 10             	movzbl (%eax),%edx
c0105f1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f1d:	0f b6 00             	movzbl (%eax),%eax
c0105f20:	38 c2                	cmp    %al,%dl
c0105f22:	74 18                	je     c0105f3c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f24:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f27:	0f b6 00             	movzbl (%eax),%eax
c0105f2a:	0f b6 d0             	movzbl %al,%edx
c0105f2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f30:	0f b6 00             	movzbl (%eax),%eax
c0105f33:	0f b6 c0             	movzbl %al,%eax
c0105f36:	29 c2                	sub    %eax,%edx
c0105f38:	89 d0                	mov    %edx,%eax
c0105f3a:	eb 1a                	jmp    c0105f56 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105f3c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105f40:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105f44:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f47:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f4a:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f4d:	85 c0                	test   %eax,%eax
c0105f4f:	75 c3                	jne    c0105f14 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105f51:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f56:	c9                   	leave  
c0105f57:	c3                   	ret    
