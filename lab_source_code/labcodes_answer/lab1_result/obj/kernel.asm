
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fd 10 00       	mov    $0x10fd80,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 4b 32 00 00       	call   10326f <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 b8 14 00 00       	call   1014e4 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 00 34 10 00 	movl   $0x103400,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 1c 34 10 00       	push   $0x10341c
  10003e:	e8 be 02 00 00       	call   100301 <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 c2 07 00 00       	call   10080d <print_kerninfo>

    grade_backtrace();
  10004b:	e8 76 00 00 00       	call   1000c6 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 1a 29 00 00       	call   10296f <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 ce 15 00 00       	call   101628 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 0f 17 00 00       	call   10176e <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 cf 0c 00 00       	call   100d33 <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 35 15 00 00       	call   10159e <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100069:	e8 45 01 00 00       	call   1001b3 <lab1_switch_test>

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	83 ec 04             	sub    $0x4,%esp
  100079:	6a 00                	push   $0x0
  10007b:	6a 00                	push   $0x0
  10007d:	6a 00                	push   $0x0
  10007f:	e8 cb 0b 00 00       	call   100c4f <mon_backtrace>
  100084:	83 c4 10             	add    $0x10,%esp
}
  100087:	c9                   	leave  
  100088:	c3                   	ret    

00100089 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100089:	55                   	push   %ebp
  10008a:	89 e5                	mov    %esp,%ebp
  10008c:	53                   	push   %ebx
  10008d:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  100090:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  100093:	8b 55 0c             	mov    0xc(%ebp),%edx
  100096:	8d 5d 08             	lea    0x8(%ebp),%ebx
  100099:	8b 45 08             	mov    0x8(%ebp),%eax
  10009c:	51                   	push   %ecx
  10009d:	52                   	push   %edx
  10009e:	53                   	push   %ebx
  10009f:	50                   	push   %eax
  1000a0:	e8 cb ff ff ff       	call   100070 <grade_backtrace2>
  1000a5:	83 c4 10             	add    $0x10,%esp
}
  1000a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000ab:	c9                   	leave  
  1000ac:	c3                   	ret    

001000ad <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000ad:	55                   	push   %ebp
  1000ae:	89 e5                	mov    %esp,%ebp
  1000b0:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b3:	83 ec 08             	sub    $0x8,%esp
  1000b6:	ff 75 10             	pushl  0x10(%ebp)
  1000b9:	ff 75 08             	pushl  0x8(%ebp)
  1000bc:	e8 c8 ff ff ff       	call   100089 <grade_backtrace1>
  1000c1:	83 c4 10             	add    $0x10,%esp
}
  1000c4:	c9                   	leave  
  1000c5:	c3                   	ret    

001000c6 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c6:	55                   	push   %ebp
  1000c7:	89 e5                	mov    %esp,%ebp
  1000c9:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000cc:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000d1:	83 ec 04             	sub    $0x4,%esp
  1000d4:	68 00 00 ff ff       	push   $0xffff0000
  1000d9:	50                   	push   %eax
  1000da:	6a 00                	push   $0x0
  1000dc:	e8 cc ff ff ff       	call   1000ad <grade_backtrace0>
  1000e1:	83 c4 10             	add    $0x10,%esp
}
  1000e4:	c9                   	leave  
  1000e5:	c3                   	ret    

001000e6 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000e6:	55                   	push   %ebp
  1000e7:	89 e5                	mov    %esp,%ebp
  1000e9:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000ec:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000ef:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f2:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f5:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000f8:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  1000fc:	0f b7 c0             	movzwl %ax,%eax
  1000ff:	83 e0 03             	and    $0x3,%eax
  100102:	89 c2                	mov    %eax,%edx
  100104:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100109:	83 ec 04             	sub    $0x4,%esp
  10010c:	52                   	push   %edx
  10010d:	50                   	push   %eax
  10010e:	68 21 34 10 00       	push   $0x103421
  100113:	e8 e9 01 00 00       	call   100301 <cprintf>
  100118:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011b:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  10011f:	0f b7 d0             	movzwl %ax,%edx
  100122:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100127:	83 ec 04             	sub    $0x4,%esp
  10012a:	52                   	push   %edx
  10012b:	50                   	push   %eax
  10012c:	68 2f 34 10 00       	push   $0x10342f
  100131:	e8 cb 01 00 00       	call   100301 <cprintf>
  100136:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10013c:	0f b7 d0             	movzwl %ax,%edx
  10013f:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100144:	83 ec 04             	sub    $0x4,%esp
  100147:	52                   	push   %edx
  100148:	50                   	push   %eax
  100149:	68 3d 34 10 00       	push   $0x10343d
  10014e:	e8 ae 01 00 00       	call   100301 <cprintf>
  100153:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100156:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  10015a:	0f b7 d0             	movzwl %ax,%edx
  10015d:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100162:	83 ec 04             	sub    $0x4,%esp
  100165:	52                   	push   %edx
  100166:	50                   	push   %eax
  100167:	68 4b 34 10 00       	push   $0x10344b
  10016c:	e8 90 01 00 00       	call   100301 <cprintf>
  100171:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100177:	0f b7 d0             	movzwl %ax,%edx
  10017a:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10017f:	83 ec 04             	sub    $0x4,%esp
  100182:	52                   	push   %edx
  100183:	50                   	push   %eax
  100184:	68 59 34 10 00       	push   $0x103459
  100189:	e8 73 01 00 00       	call   100301 <cprintf>
  10018e:	83 c4 10             	add    $0x10,%esp
    round ++;
  100191:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100196:	40                   	inc    %eax
  100197:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  10019c:	c9                   	leave  
  10019d:	c3                   	ret    

0010019e <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  10019e:	55                   	push   %ebp
  10019f:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001a1:	83 ec 08             	sub    $0x8,%esp
  1001a4:	cd 78                	int    $0x78
  1001a6:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001a8:	5d                   	pop    %ebp
  1001a9:	c3                   	ret    

001001aa <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001aa:	55                   	push   %ebp
  1001ab:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001ad:	cd 79                	int    $0x79
  1001af:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001b1:	5d                   	pop    %ebp
  1001b2:	c3                   	ret    

001001b3 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001b3:	55                   	push   %ebp
  1001b4:	89 e5                	mov    %esp,%ebp
  1001b6:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001b9:	e8 28 ff ff ff       	call   1000e6 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001be:	83 ec 0c             	sub    $0xc,%esp
  1001c1:	68 68 34 10 00       	push   $0x103468
  1001c6:	e8 36 01 00 00       	call   100301 <cprintf>
  1001cb:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001ce:	e8 cb ff ff ff       	call   10019e <lab1_switch_to_user>
    lab1_print_cur_status();
  1001d3:	e8 0e ff ff ff       	call   1000e6 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001d8:	83 ec 0c             	sub    $0xc,%esp
  1001db:	68 88 34 10 00       	push   $0x103488
  1001e0:	e8 1c 01 00 00       	call   100301 <cprintf>
  1001e5:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001e8:	e8 bd ff ff ff       	call   1001aa <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001ed:	e8 f4 fe ff ff       	call   1000e6 <lab1_print_cur_status>
}
  1001f2:	c9                   	leave  
  1001f3:	c3                   	ret    

001001f4 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1001f4:	55                   	push   %ebp
  1001f5:	89 e5                	mov    %esp,%ebp
  1001f7:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1001fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1001fe:	74 13                	je     100213 <readline+0x1f>
        cprintf("%s", prompt);
  100200:	83 ec 08             	sub    $0x8,%esp
  100203:	ff 75 08             	pushl  0x8(%ebp)
  100206:	68 a7 34 10 00       	push   $0x1034a7
  10020b:	e8 f1 00 00 00       	call   100301 <cprintf>
  100210:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100213:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10021a:	e8 6b 01 00 00       	call   10038a <getchar>
  10021f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100222:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100226:	79 0a                	jns    100232 <readline+0x3e>
            return NULL;
  100228:	b8 00 00 00 00       	mov    $0x0,%eax
  10022d:	e9 81 00 00 00       	jmp    1002b3 <readline+0xbf>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100232:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100236:	7e 2b                	jle    100263 <readline+0x6f>
  100238:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10023f:	7f 22                	jg     100263 <readline+0x6f>
            cputchar(c);
  100241:	83 ec 0c             	sub    $0xc,%esp
  100244:	ff 75 f0             	pushl  -0x10(%ebp)
  100247:	e8 db 00 00 00       	call   100327 <cputchar>
  10024c:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10024f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100252:	8d 50 01             	lea    0x1(%eax),%edx
  100255:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100258:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10025b:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100261:	eb 4b                	jmp    1002ae <readline+0xba>
        }
        else if (c == '\b' && i > 0) {
  100263:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100267:	75 19                	jne    100282 <readline+0x8e>
  100269:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10026d:	7e 13                	jle    100282 <readline+0x8e>
            cputchar(c);
  10026f:	83 ec 0c             	sub    $0xc,%esp
  100272:	ff 75 f0             	pushl  -0x10(%ebp)
  100275:	e8 ad 00 00 00       	call   100327 <cputchar>
  10027a:	83 c4 10             	add    $0x10,%esp
            i --;
  10027d:	ff 4d f4             	decl   -0xc(%ebp)
  100280:	eb 2c                	jmp    1002ae <readline+0xba>
        }
        else if (c == '\n' || c == '\r') {
  100282:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100286:	74 06                	je     10028e <readline+0x9a>
  100288:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10028c:	75 20                	jne    1002ae <readline+0xba>
            cputchar(c);
  10028e:	83 ec 0c             	sub    $0xc,%esp
  100291:	ff 75 f0             	pushl  -0x10(%ebp)
  100294:	e8 8e 00 00 00       	call   100327 <cputchar>
  100299:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  10029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10029f:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002a4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002a7:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002ac:	eb 05                	jmp    1002b3 <readline+0xbf>
        }
    }
  1002ae:	e9 67 ff ff ff       	jmp    10021a <readline+0x26>
}
  1002b3:	c9                   	leave  
  1002b4:	c3                   	ret    

001002b5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002b5:	55                   	push   %ebp
  1002b6:	89 e5                	mov    %esp,%ebp
  1002b8:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1002bb:	83 ec 0c             	sub    $0xc,%esp
  1002be:	ff 75 08             	pushl  0x8(%ebp)
  1002c1:	e8 4e 12 00 00       	call   101514 <cons_putc>
  1002c6:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  1002c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002cc:	8b 00                	mov    (%eax),%eax
  1002ce:	8d 50 01             	lea    0x1(%eax),%edx
  1002d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d4:	89 10                	mov    %edx,(%eax)
}
  1002d6:	c9                   	leave  
  1002d7:	c3                   	ret    

001002d8 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002d8:	55                   	push   %ebp
  1002d9:	89 e5                	mov    %esp,%ebp
  1002db:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002e5:	ff 75 0c             	pushl  0xc(%ebp)
  1002e8:	ff 75 08             	pushl  0x8(%ebp)
  1002eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002ee:	50                   	push   %eax
  1002ef:	68 b5 02 10 00       	push   $0x1002b5
  1002f4:	e8 25 28 00 00       	call   102b1e <vprintfmt>
  1002f9:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ff:	c9                   	leave  
  100300:	c3                   	ret    

00100301 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100301:	55                   	push   %ebp
  100302:	89 e5                	mov    %esp,%ebp
  100304:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100307:	8d 45 0c             	lea    0xc(%ebp),%eax
  10030a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10030d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100310:	83 ec 08             	sub    $0x8,%esp
  100313:	50                   	push   %eax
  100314:	ff 75 08             	pushl  0x8(%ebp)
  100317:	e8 bc ff ff ff       	call   1002d8 <vcprintf>
  10031c:	83 c4 10             	add    $0x10,%esp
  10031f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100322:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100325:	c9                   	leave  
  100326:	c3                   	ret    

00100327 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100327:	55                   	push   %ebp
  100328:	89 e5                	mov    %esp,%ebp
  10032a:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  10032d:	83 ec 0c             	sub    $0xc,%esp
  100330:	ff 75 08             	pushl  0x8(%ebp)
  100333:	e8 dc 11 00 00       	call   101514 <cons_putc>
  100338:	83 c4 10             	add    $0x10,%esp
}
  10033b:	c9                   	leave  
  10033c:	c3                   	ret    

0010033d <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10033d:	55                   	push   %ebp
  10033e:	89 e5                	mov    %esp,%ebp
  100340:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100343:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10034a:	eb 14                	jmp    100360 <cputs+0x23>
        cputch(c, &cnt);
  10034c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100350:	83 ec 08             	sub    $0x8,%esp
  100353:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100356:	52                   	push   %edx
  100357:	50                   	push   %eax
  100358:	e8 58 ff ff ff       	call   1002b5 <cputch>
  10035d:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100360:	8b 45 08             	mov    0x8(%ebp),%eax
  100363:	8d 50 01             	lea    0x1(%eax),%edx
  100366:	89 55 08             	mov    %edx,0x8(%ebp)
  100369:	8a 00                	mov    (%eax),%al
  10036b:	88 45 f7             	mov    %al,-0x9(%ebp)
  10036e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100372:	75 d8                	jne    10034c <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100374:	83 ec 08             	sub    $0x8,%esp
  100377:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10037a:	50                   	push   %eax
  10037b:	6a 0a                	push   $0xa
  10037d:	e8 33 ff ff ff       	call   1002b5 <cputch>
  100382:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100385:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100388:	c9                   	leave  
  100389:	c3                   	ret    

0010038a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10038a:	55                   	push   %ebp
  10038b:	89 e5                	mov    %esp,%ebp
  10038d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100390:	e8 ae 11 00 00       	call   101543 <cons_getc>
  100395:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100398:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10039c:	74 f2                	je     100390 <getchar+0x6>
        /* do nothing */;
    return c;
  10039e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003a1:	c9                   	leave  
  1003a2:	c3                   	ret    

001003a3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003a3:	55                   	push   %ebp
  1003a4:	89 e5                	mov    %esp,%ebp
  1003a6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003ac:	8b 00                	mov    (%eax),%eax
  1003ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003b1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003b4:	8b 00                	mov    (%eax),%eax
  1003b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003c0:	e9 c9 00 00 00       	jmp    10048e <stab_binsearch+0xeb>
        int true_m = (l + r) / 2, m = true_m;
  1003c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003cb:	01 d0                	add    %edx,%eax
  1003cd:	89 c2                	mov    %eax,%edx
  1003cf:	c1 ea 1f             	shr    $0x1f,%edx
  1003d2:	01 d0                	add    %edx,%eax
  1003d4:	d1 f8                	sar    %eax
  1003d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003df:	eb 03                	jmp    1003e4 <stab_binsearch+0x41>
            m --;
  1003e1:	ff 4d f0             	decl   -0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003ea:	7c 1e                	jl     10040a <stab_binsearch+0x67>
  1003ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003ef:	89 d0                	mov    %edx,%eax
  1003f1:	01 c0                	add    %eax,%eax
  1003f3:	01 d0                	add    %edx,%eax
  1003f5:	c1 e0 02             	shl    $0x2,%eax
  1003f8:	89 c2                	mov    %eax,%edx
  1003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1003fd:	01 d0                	add    %edx,%eax
  1003ff:	8a 40 04             	mov    0x4(%eax),%al
  100402:	0f b6 c0             	movzbl %al,%eax
  100405:	3b 45 14             	cmp    0x14(%ebp),%eax
  100408:	75 d7                	jne    1003e1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10040a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10040d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100410:	7d 09                	jge    10041b <stab_binsearch+0x78>
            l = true_m + 1;
  100412:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100415:	40                   	inc    %eax
  100416:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100419:	eb 73                	jmp    10048e <stab_binsearch+0xeb>
        }

        // actual binary search
        any_matches = 1;
  10041b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100422:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100425:	89 d0                	mov    %edx,%eax
  100427:	01 c0                	add    %eax,%eax
  100429:	01 d0                	add    %edx,%eax
  10042b:	c1 e0 02             	shl    $0x2,%eax
  10042e:	89 c2                	mov    %eax,%edx
  100430:	8b 45 08             	mov    0x8(%ebp),%eax
  100433:	01 d0                	add    %edx,%eax
  100435:	8b 40 08             	mov    0x8(%eax),%eax
  100438:	3b 45 18             	cmp    0x18(%ebp),%eax
  10043b:	73 11                	jae    10044e <stab_binsearch+0xab>
            *region_left = m;
  10043d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100440:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100443:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100448:	40                   	inc    %eax
  100449:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10044c:	eb 40                	jmp    10048e <stab_binsearch+0xeb>
        } else if (stabs[m].n_value > addr) {
  10044e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100451:	89 d0                	mov    %edx,%eax
  100453:	01 c0                	add    %eax,%eax
  100455:	01 d0                	add    %edx,%eax
  100457:	c1 e0 02             	shl    $0x2,%eax
  10045a:	89 c2                	mov    %eax,%edx
  10045c:	8b 45 08             	mov    0x8(%ebp),%eax
  10045f:	01 d0                	add    %edx,%eax
  100461:	8b 40 08             	mov    0x8(%eax),%eax
  100464:	3b 45 18             	cmp    0x18(%ebp),%eax
  100467:	76 14                	jbe    10047d <stab_binsearch+0xda>
            *region_right = m - 1;
  100469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10046c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10046f:	8b 45 10             	mov    0x10(%ebp),%eax
  100472:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100477:	48                   	dec    %eax
  100478:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10047b:	eb 11                	jmp    10048e <stab_binsearch+0xeb>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10047d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100480:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100483:	89 10                	mov    %edx,(%eax)
            l = m;
  100485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100488:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10048b:	ff 45 18             	incl   0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  10048e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100491:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100494:	0f 8e 2b ff ff ff    	jle    1003c5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  10049a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10049e:	75 0f                	jne    1004af <stab_binsearch+0x10c>
        *region_right = *region_left - 1;
  1004a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a3:	8b 00                	mov    (%eax),%eax
  1004a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ab:	89 10                	mov    %edx,(%eax)
  1004ad:	eb 3d                	jmp    1004ec <stab_binsearch+0x149>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	8b 00                	mov    (%eax),%eax
  1004b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004b7:	eb 03                	jmp    1004bc <stab_binsearch+0x119>
  1004b9:	ff 4d fc             	decl   -0x4(%ebp)
  1004bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bf:	8b 00                	mov    (%eax),%eax
  1004c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004c4:	7d 1e                	jge    1004e4 <stab_binsearch+0x141>
  1004c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004c9:	89 d0                	mov    %edx,%eax
  1004cb:	01 c0                	add    %eax,%eax
  1004cd:	01 d0                	add    %edx,%eax
  1004cf:	c1 e0 02             	shl    $0x2,%eax
  1004d2:	89 c2                	mov    %eax,%edx
  1004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1004d7:	01 d0                	add    %edx,%eax
  1004d9:	8a 40 04             	mov    0x4(%eax),%al
  1004dc:	0f b6 c0             	movzbl %al,%eax
  1004df:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004e2:	75 d5                	jne    1004b9 <stab_binsearch+0x116>
            /* do nothing */;
        *region_left = l;
  1004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004ea:	89 10                	mov    %edx,(%eax)
    }
}
  1004ec:	c9                   	leave  
  1004ed:	c3                   	ret    

001004ee <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1004ee:	55                   	push   %ebp
  1004ef:	89 e5                	mov    %esp,%ebp
  1004f1:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f7:	c7 00 ac 34 10 00    	movl   $0x1034ac,(%eax)
    info->eip_line = 0;
  1004fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100500:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100507:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050a:	c7 40 08 ac 34 10 00 	movl   $0x1034ac,0x8(%eax)
    info->eip_fn_namelen = 9;
  100511:	8b 45 0c             	mov    0xc(%ebp),%eax
  100514:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051e:	8b 55 08             	mov    0x8(%ebp),%edx
  100521:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100524:	8b 45 0c             	mov    0xc(%ebp),%eax
  100527:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10052e:	c7 45 f4 0c 3d 10 00 	movl   $0x103d0c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100535:	c7 45 f0 74 b3 10 00 	movl   $0x10b374,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10053c:	c7 45 ec 75 b3 10 00 	movl   $0x10b375,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100543:	c7 45 e8 5f d3 10 00 	movl   $0x10d35f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10054a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10054d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100550:	76 0a                	jbe    10055c <debuginfo_eip+0x6e>
  100552:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100555:	48                   	dec    %eax
  100556:	8a 00                	mov    (%eax),%al
  100558:	84 c0                	test   %al,%al
  10055a:	74 0a                	je     100566 <debuginfo_eip+0x78>
        return -1;
  10055c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100561:	e9 a5 02 00 00       	jmp    10080b <debuginfo_eip+0x31d>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100566:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10056d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100573:	29 c2                	sub    %eax,%edx
  100575:	89 d0                	mov    %edx,%eax
  100577:	c1 f8 02             	sar    $0x2,%eax
  10057a:	89 c2                	mov    %eax,%edx
  10057c:	89 d0                	mov    %edx,%eax
  10057e:	c1 e0 02             	shl    $0x2,%eax
  100581:	01 d0                	add    %edx,%eax
  100583:	c1 e0 02             	shl    $0x2,%eax
  100586:	01 d0                	add    %edx,%eax
  100588:	c1 e0 02             	shl    $0x2,%eax
  10058b:	01 d0                	add    %edx,%eax
  10058d:	89 c1                	mov    %eax,%ecx
  10058f:	c1 e1 08             	shl    $0x8,%ecx
  100592:	01 c8                	add    %ecx,%eax
  100594:	89 c1                	mov    %eax,%ecx
  100596:	c1 e1 10             	shl    $0x10,%ecx
  100599:	01 c8                	add    %ecx,%eax
  10059b:	01 c0                	add    %eax,%eax
  10059d:	01 d0                	add    %edx,%eax
  10059f:	48                   	dec    %eax
  1005a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a3:	ff 75 08             	pushl  0x8(%ebp)
  1005a6:	6a 64                	push   $0x64
  1005a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005ab:	50                   	push   %eax
  1005ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005af:	50                   	push   %eax
  1005b0:	ff 75 f4             	pushl  -0xc(%ebp)
  1005b3:	e8 eb fd ff ff       	call   1003a3 <stab_binsearch>
  1005b8:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  1005bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005be:	85 c0                	test   %eax,%eax
  1005c0:	75 0a                	jne    1005cc <debuginfo_eip+0xde>
        return -1;
  1005c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005c7:	e9 3f 02 00 00       	jmp    10080b <debuginfo_eip+0x31d>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005d8:	ff 75 08             	pushl  0x8(%ebp)
  1005db:	6a 24                	push   $0x24
  1005dd:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005e0:	50                   	push   %eax
  1005e1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1005e4:	50                   	push   %eax
  1005e5:	ff 75 f4             	pushl  -0xc(%ebp)
  1005e8:	e8 b6 fd ff ff       	call   1003a3 <stab_binsearch>
  1005ed:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1005f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1005f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1005f6:	39 c2                	cmp    %eax,%edx
  1005f8:	7f 7c                	jg     100676 <debuginfo_eip+0x188>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1005fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1005fd:	89 c2                	mov    %eax,%edx
  1005ff:	89 d0                	mov    %edx,%eax
  100601:	01 c0                	add    %eax,%eax
  100603:	01 d0                	add    %edx,%eax
  100605:	c1 e0 02             	shl    $0x2,%eax
  100608:	89 c2                	mov    %eax,%edx
  10060a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10060d:	01 d0                	add    %edx,%eax
  10060f:	8b 00                	mov    (%eax),%eax
  100611:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100614:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100617:	29 d1                	sub    %edx,%ecx
  100619:	89 ca                	mov    %ecx,%edx
  10061b:	39 d0                	cmp    %edx,%eax
  10061d:	73 22                	jae    100641 <debuginfo_eip+0x153>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10061f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100622:	89 c2                	mov    %eax,%edx
  100624:	89 d0                	mov    %edx,%eax
  100626:	01 c0                	add    %eax,%eax
  100628:	01 d0                	add    %edx,%eax
  10062a:	c1 e0 02             	shl    $0x2,%eax
  10062d:	89 c2                	mov    %eax,%edx
  10062f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100632:	01 d0                	add    %edx,%eax
  100634:	8b 10                	mov    (%eax),%edx
  100636:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100639:	01 c2                	add    %eax,%edx
  10063b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063e:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100641:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100644:	89 c2                	mov    %eax,%edx
  100646:	89 d0                	mov    %edx,%eax
  100648:	01 c0                	add    %eax,%eax
  10064a:	01 d0                	add    %edx,%eax
  10064c:	c1 e0 02             	shl    $0x2,%eax
  10064f:	89 c2                	mov    %eax,%edx
  100651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100654:	01 d0                	add    %edx,%eax
  100656:	8b 50 08             	mov    0x8(%eax),%edx
  100659:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065c:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10065f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100662:	8b 40 10             	mov    0x10(%eax),%eax
  100665:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100668:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10066e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100671:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100674:	eb 15                	jmp    10068b <debuginfo_eip+0x19d>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100676:	8b 45 0c             	mov    0xc(%ebp),%eax
  100679:	8b 55 08             	mov    0x8(%ebp),%edx
  10067c:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10067f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100682:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100685:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100688:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10068b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10068e:	8b 40 08             	mov    0x8(%eax),%eax
  100691:	83 ec 08             	sub    $0x8,%esp
  100694:	6a 3a                	push   $0x3a
  100696:	50                   	push   %eax
  100697:	e8 61 2a 00 00       	call   1030fd <strfind>
  10069c:	83 c4 10             	add    $0x10,%esp
  10069f:	89 c2                	mov    %eax,%edx
  1006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a4:	8b 40 08             	mov    0x8(%eax),%eax
  1006a7:	29 c2                	sub    %eax,%edx
  1006a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ac:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006af:	83 ec 0c             	sub    $0xc,%esp
  1006b2:	ff 75 08             	pushl  0x8(%ebp)
  1006b5:	6a 44                	push   $0x44
  1006b7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006ba:	50                   	push   %eax
  1006bb:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006be:	50                   	push   %eax
  1006bf:	ff 75 f4             	pushl  -0xc(%ebp)
  1006c2:	e8 dc fc ff ff       	call   1003a3 <stab_binsearch>
  1006c7:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1006ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1006d0:	39 c2                	cmp    %eax,%edx
  1006d2:	7f 24                	jg     1006f8 <debuginfo_eip+0x20a>
        info->eip_line = stabs[rline].n_desc;
  1006d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1006d7:	89 c2                	mov    %eax,%edx
  1006d9:	89 d0                	mov    %edx,%eax
  1006db:	01 c0                	add    %eax,%eax
  1006dd:	01 d0                	add    %edx,%eax
  1006df:	c1 e0 02             	shl    $0x2,%eax
  1006e2:	89 c2                	mov    %eax,%edx
  1006e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e7:	01 d0                	add    %edx,%eax
  1006e9:	66 8b 40 06          	mov    0x6(%eax),%ax
  1006ed:	0f b7 d0             	movzwl %ax,%edx
  1006f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f3:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1006f6:	eb 11                	jmp    100709 <debuginfo_eip+0x21b>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1006f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006fd:	e9 09 01 00 00       	jmp    10080b <debuginfo_eip+0x31d>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100702:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100705:	48                   	dec    %eax
  100706:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100709:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10070c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10070f:	39 c2                	cmp    %eax,%edx
  100711:	7c 54                	jl     100767 <debuginfo_eip+0x279>
           && stabs[lline].n_type != N_SOL
  100713:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100716:	89 c2                	mov    %eax,%edx
  100718:	89 d0                	mov    %edx,%eax
  10071a:	01 c0                	add    %eax,%eax
  10071c:	01 d0                	add    %edx,%eax
  10071e:	c1 e0 02             	shl    $0x2,%eax
  100721:	89 c2                	mov    %eax,%edx
  100723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100726:	01 d0                	add    %edx,%eax
  100728:	8a 40 04             	mov    0x4(%eax),%al
  10072b:	3c 84                	cmp    $0x84,%al
  10072d:	74 38                	je     100767 <debuginfo_eip+0x279>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10072f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100732:	89 c2                	mov    %eax,%edx
  100734:	89 d0                	mov    %edx,%eax
  100736:	01 c0                	add    %eax,%eax
  100738:	01 d0                	add    %edx,%eax
  10073a:	c1 e0 02             	shl    $0x2,%eax
  10073d:	89 c2                	mov    %eax,%edx
  10073f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100742:	01 d0                	add    %edx,%eax
  100744:	8a 40 04             	mov    0x4(%eax),%al
  100747:	3c 64                	cmp    $0x64,%al
  100749:	75 b7                	jne    100702 <debuginfo_eip+0x214>
  10074b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10074e:	89 c2                	mov    %eax,%edx
  100750:	89 d0                	mov    %edx,%eax
  100752:	01 c0                	add    %eax,%eax
  100754:	01 d0                	add    %edx,%eax
  100756:	c1 e0 02             	shl    $0x2,%eax
  100759:	89 c2                	mov    %eax,%edx
  10075b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075e:	01 d0                	add    %edx,%eax
  100760:	8b 40 08             	mov    0x8(%eax),%eax
  100763:	85 c0                	test   %eax,%eax
  100765:	74 9b                	je     100702 <debuginfo_eip+0x214>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100767:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10076a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076d:	39 c2                	cmp    %eax,%edx
  10076f:	7c 46                	jl     1007b7 <debuginfo_eip+0x2c9>
  100771:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100774:	89 c2                	mov    %eax,%edx
  100776:	89 d0                	mov    %edx,%eax
  100778:	01 c0                	add    %eax,%eax
  10077a:	01 d0                	add    %edx,%eax
  10077c:	c1 e0 02             	shl    $0x2,%eax
  10077f:	89 c2                	mov    %eax,%edx
  100781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100784:	01 d0                	add    %edx,%eax
  100786:	8b 00                	mov    (%eax),%eax
  100788:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10078b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10078e:	29 d1                	sub    %edx,%ecx
  100790:	89 ca                	mov    %ecx,%edx
  100792:	39 d0                	cmp    %edx,%eax
  100794:	73 21                	jae    1007b7 <debuginfo_eip+0x2c9>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100796:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100799:	89 c2                	mov    %eax,%edx
  10079b:	89 d0                	mov    %edx,%eax
  10079d:	01 c0                	add    %eax,%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	c1 e0 02             	shl    $0x2,%eax
  1007a4:	89 c2                	mov    %eax,%edx
  1007a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a9:	01 d0                	add    %edx,%eax
  1007ab:	8b 10                	mov    (%eax),%edx
  1007ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007b0:	01 c2                	add    %eax,%edx
  1007b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b5:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007bd:	39 c2                	cmp    %eax,%edx
  1007bf:	7d 45                	jge    100806 <debuginfo_eip+0x318>
        for (lline = lfun + 1;
  1007c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007c4:	40                   	inc    %eax
  1007c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007c8:	eb 16                	jmp    1007e0 <debuginfo_eip+0x2f2>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1007ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cd:	8b 40 14             	mov    0x14(%eax),%eax
  1007d0:	8d 50 01             	lea    0x1(%eax),%edx
  1007d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d6:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1007d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007dc:	40                   	inc    %eax
  1007dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1007e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1007e6:	39 c2                	cmp    %eax,%edx
  1007e8:	7d 1c                	jge    100806 <debuginfo_eip+0x318>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1007ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ed:	89 c2                	mov    %eax,%edx
  1007ef:	89 d0                	mov    %edx,%eax
  1007f1:	01 c0                	add    %eax,%eax
  1007f3:	01 d0                	add    %edx,%eax
  1007f5:	c1 e0 02             	shl    $0x2,%eax
  1007f8:	89 c2                	mov    %eax,%edx
  1007fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	8a 40 04             	mov    0x4(%eax),%al
  100802:	3c a0                	cmp    $0xa0,%al
  100804:	74 c4                	je     1007ca <debuginfo_eip+0x2dc>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100806:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10080b:	c9                   	leave  
  10080c:	c3                   	ret    

0010080d <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10080d:	55                   	push   %ebp
  10080e:	89 e5                	mov    %esp,%ebp
  100810:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100813:	83 ec 0c             	sub    $0xc,%esp
  100816:	68 b6 34 10 00       	push   $0x1034b6
  10081b:	e8 e1 fa ff ff       	call   100301 <cprintf>
  100820:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100823:	83 ec 08             	sub    $0x8,%esp
  100826:	68 00 00 10 00       	push   $0x100000
  10082b:	68 cf 34 10 00       	push   $0x1034cf
  100830:	e8 cc fa ff ff       	call   100301 <cprintf>
  100835:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100838:	83 ec 08             	sub    $0x8,%esp
  10083b:	68 f3 33 10 00       	push   $0x1033f3
  100840:	68 e7 34 10 00       	push   $0x1034e7
  100845:	e8 b7 fa ff ff       	call   100301 <cprintf>
  10084a:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  10084d:	83 ec 08             	sub    $0x8,%esp
  100850:	68 16 ea 10 00       	push   $0x10ea16
  100855:	68 ff 34 10 00       	push   $0x1034ff
  10085a:	e8 a2 fa ff ff       	call   100301 <cprintf>
  10085f:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100862:	83 ec 08             	sub    $0x8,%esp
  100865:	68 80 fd 10 00       	push   $0x10fd80
  10086a:	68 17 35 10 00       	push   $0x103517
  10086f:	e8 8d fa ff ff       	call   100301 <cprintf>
  100874:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100877:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  10087c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100882:	b8 00 00 10 00       	mov    $0x100000,%eax
  100887:	29 c2                	sub    %eax,%edx
  100889:	89 d0                	mov    %edx,%eax
  10088b:	85 c0                	test   %eax,%eax
  10088d:	79 05                	jns    100894 <print_kerninfo+0x87>
  10088f:	05 ff 03 00 00       	add    $0x3ff,%eax
  100894:	c1 f8 0a             	sar    $0xa,%eax
  100897:	83 ec 08             	sub    $0x8,%esp
  10089a:	50                   	push   %eax
  10089b:	68 30 35 10 00       	push   $0x103530
  1008a0:	e8 5c fa ff ff       	call   100301 <cprintf>
  1008a5:	83 c4 10             	add    $0x10,%esp
}
  1008a8:	c9                   	leave  
  1008a9:	c3                   	ret    

001008aa <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008aa:	55                   	push   %ebp
  1008ab:	89 e5                	mov    %esp,%ebp
  1008ad:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008b3:	83 ec 08             	sub    $0x8,%esp
  1008b6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008b9:	50                   	push   %eax
  1008ba:	ff 75 08             	pushl  0x8(%ebp)
  1008bd:	e8 2c fc ff ff       	call   1004ee <debuginfo_eip>
  1008c2:	83 c4 10             	add    $0x10,%esp
  1008c5:	85 c0                	test   %eax,%eax
  1008c7:	74 15                	je     1008de <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008c9:	83 ec 08             	sub    $0x8,%esp
  1008cc:	ff 75 08             	pushl  0x8(%ebp)
  1008cf:	68 5a 35 10 00       	push   $0x10355a
  1008d4:	e8 28 fa ff ff       	call   100301 <cprintf>
  1008d9:	83 c4 10             	add    $0x10,%esp
  1008dc:	eb 63                	jmp    100941 <print_debuginfo+0x97>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1008de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1008e5:	eb 1a                	jmp    100901 <print_debuginfo+0x57>
            fnname[j] = info.eip_fn_name[j];
  1008e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1008ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ed:	01 d0                	add    %edx,%eax
  1008ef:	8a 00                	mov    (%eax),%al
  1008f1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1008f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1008fa:	01 ca                	add    %ecx,%edx
  1008fc:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1008fe:	ff 45 f4             	incl   -0xc(%ebp)
  100901:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100904:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100907:	7f de                	jg     1008e7 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100909:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10090f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100912:	01 d0                	add    %edx,%eax
  100914:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100917:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10091a:	8b 55 08             	mov    0x8(%ebp),%edx
  10091d:	89 d1                	mov    %edx,%ecx
  10091f:	29 c1                	sub    %eax,%ecx
  100921:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100924:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100927:	83 ec 0c             	sub    $0xc,%esp
  10092a:	51                   	push   %ecx
  10092b:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100931:	51                   	push   %ecx
  100932:	52                   	push   %edx
  100933:	50                   	push   %eax
  100934:	68 76 35 10 00       	push   $0x103576
  100939:	e8 c3 f9 ff ff       	call   100301 <cprintf>
  10093e:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100941:	c9                   	leave  
  100942:	c3                   	ret    

00100943 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100943:	55                   	push   %ebp
  100944:	89 e5                	mov    %esp,%ebp
  100946:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100949:	8b 45 04             	mov    0x4(%ebp),%eax
  10094c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10094f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100952:	c9                   	leave  
  100953:	c3                   	ret    

00100954 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100954:	55                   	push   %ebp
  100955:	89 e5                	mov    %esp,%ebp
  100957:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  10095a:	89 e8                	mov    %ebp,%eax
  10095c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10095f:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100962:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100965:	e8 d9 ff ff ff       	call   100943 <read_eip>
  10096a:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  10096d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100974:	e9 89 00 00 00       	jmp    100a02 <print_stackframe+0xae>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100979:	83 ec 04             	sub    $0x4,%esp
  10097c:	ff 75 f0             	pushl  -0x10(%ebp)
  10097f:	ff 75 f4             	pushl  -0xc(%ebp)
  100982:	68 88 35 10 00       	push   $0x103588
  100987:	e8 75 f9 ff ff       	call   100301 <cprintf>
  10098c:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
  10098f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100992:	83 c0 08             	add    $0x8,%eax
  100995:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100998:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  10099f:	eb 25                	jmp    1009c6 <print_stackframe+0x72>
            cprintf("0x%08x ", args[j]);
  1009a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009ae:	01 d0                	add    %edx,%eax
  1009b0:	8b 00                	mov    (%eax),%eax
  1009b2:	83 ec 08             	sub    $0x8,%esp
  1009b5:	50                   	push   %eax
  1009b6:	68 a4 35 10 00       	push   $0x1035a4
  1009bb:	e8 41 f9 ff ff       	call   100301 <cprintf>
  1009c0:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
  1009c3:	ff 45 e8             	incl   -0x18(%ebp)
  1009c6:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  1009ca:	7e d5                	jle    1009a1 <print_stackframe+0x4d>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  1009cc:	83 ec 0c             	sub    $0xc,%esp
  1009cf:	68 ac 35 10 00       	push   $0x1035ac
  1009d4:	e8 28 f9 ff ff       	call   100301 <cprintf>
  1009d9:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
  1009dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009df:	48                   	dec    %eax
  1009e0:	83 ec 0c             	sub    $0xc,%esp
  1009e3:	50                   	push   %eax
  1009e4:	e8 c1 fe ff ff       	call   1008aa <print_debuginfo>
  1009e9:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
  1009ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ef:	83 c0 04             	add    $0x4,%eax
  1009f2:	8b 00                	mov    (%eax),%eax
  1009f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  1009f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fa:	8b 00                	mov    (%eax),%eax
  1009fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009ff:	ff 45 ec             	incl   -0x14(%ebp)
  100a02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a06:	74 0a                	je     100a12 <print_stackframe+0xbe>
  100a08:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a0c:	0f 8e 67 ff ff ff    	jle    100979 <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
  100a12:	c9                   	leave  
  100a13:	c3                   	ret    

00100a14 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a14:	55                   	push   %ebp
  100a15:	89 e5                	mov    %esp,%ebp
  100a17:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100a1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a21:	eb 0c                	jmp    100a2f <parse+0x1b>
            *buf ++ = '\0';
  100a23:	8b 45 08             	mov    0x8(%ebp),%eax
  100a26:	8d 50 01             	lea    0x1(%eax),%edx
  100a29:	89 55 08             	mov    %edx,0x8(%ebp)
  100a2c:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a32:	8a 00                	mov    (%eax),%al
  100a34:	84 c0                	test   %al,%al
  100a36:	74 1d                	je     100a55 <parse+0x41>
  100a38:	8b 45 08             	mov    0x8(%ebp),%eax
  100a3b:	8a 00                	mov    (%eax),%al
  100a3d:	0f be c0             	movsbl %al,%eax
  100a40:	83 ec 08             	sub    $0x8,%esp
  100a43:	50                   	push   %eax
  100a44:	68 30 36 10 00       	push   $0x103630
  100a49:	e8 7f 26 00 00       	call   1030cd <strchr>
  100a4e:	83 c4 10             	add    $0x10,%esp
  100a51:	85 c0                	test   %eax,%eax
  100a53:	75 ce                	jne    100a23 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a55:	8b 45 08             	mov    0x8(%ebp),%eax
  100a58:	8a 00                	mov    (%eax),%al
  100a5a:	84 c0                	test   %al,%al
  100a5c:	75 02                	jne    100a60 <parse+0x4c>
            break;
  100a5e:	eb 62                	jmp    100ac2 <parse+0xae>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a60:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a64:	75 12                	jne    100a78 <parse+0x64>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a66:	83 ec 08             	sub    $0x8,%esp
  100a69:	6a 10                	push   $0x10
  100a6b:	68 35 36 10 00       	push   $0x103635
  100a70:	e8 8c f8 ff ff       	call   100301 <cprintf>
  100a75:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7b:	8d 50 01             	lea    0x1(%eax),%edx
  100a7e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a8b:	01 c2                	add    %eax,%edx
  100a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  100a90:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a92:	eb 03                	jmp    100a97 <parse+0x83>
            buf ++;
  100a94:	ff 45 08             	incl   0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a97:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9a:	8a 00                	mov    (%eax),%al
  100a9c:	84 c0                	test   %al,%al
  100a9e:	74 1d                	je     100abd <parse+0xa9>
  100aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa3:	8a 00                	mov    (%eax),%al
  100aa5:	0f be c0             	movsbl %al,%eax
  100aa8:	83 ec 08             	sub    $0x8,%esp
  100aab:	50                   	push   %eax
  100aac:	68 30 36 10 00       	push   $0x103630
  100ab1:	e8 17 26 00 00       	call   1030cd <strchr>
  100ab6:	83 c4 10             	add    $0x10,%esp
  100ab9:	85 c0                	test   %eax,%eax
  100abb:	74 d7                	je     100a94 <parse+0x80>
            buf ++;
        }
    }
  100abd:	e9 5f ff ff ff       	jmp    100a21 <parse+0xd>
    return argc;
  100ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100ac5:	c9                   	leave  
  100ac6:	c3                   	ret    

00100ac7 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ac7:	55                   	push   %ebp
  100ac8:	89 e5                	mov    %esp,%ebp
  100aca:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100acd:	83 ec 08             	sub    $0x8,%esp
  100ad0:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100ad3:	50                   	push   %eax
  100ad4:	ff 75 08             	pushl  0x8(%ebp)
  100ad7:	e8 38 ff ff ff       	call   100a14 <parse>
  100adc:	83 c4 10             	add    $0x10,%esp
  100adf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100ae2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100ae6:	75 0a                	jne    100af2 <runcmd+0x2b>
        return 0;
  100ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  100aed:	e9 81 00 00 00       	jmp    100b73 <runcmd+0xac>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100af2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100af9:	eb 57                	jmp    100b52 <runcmd+0x8b>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100afb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100afe:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b01:	89 c8                	mov    %ecx,%eax
  100b03:	01 c0                	add    %eax,%eax
  100b05:	01 c8                	add    %ecx,%eax
  100b07:	c1 e0 02             	shl    $0x2,%eax
  100b0a:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b0f:	8b 00                	mov    (%eax),%eax
  100b11:	83 ec 08             	sub    $0x8,%esp
  100b14:	52                   	push   %edx
  100b15:	50                   	push   %eax
  100b16:	e8 1a 25 00 00       	call   103035 <strcmp>
  100b1b:	83 c4 10             	add    $0x10,%esp
  100b1e:	85 c0                	test   %eax,%eax
  100b20:	75 2d                	jne    100b4f <runcmd+0x88>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b25:	89 d0                	mov    %edx,%eax
  100b27:	01 c0                	add    %eax,%eax
  100b29:	01 d0                	add    %edx,%eax
  100b2b:	c1 e0 02             	shl    $0x2,%eax
  100b2e:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b33:	8b 40 08             	mov    0x8(%eax),%eax
  100b36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b39:	4a                   	dec    %edx
  100b3a:	83 ec 04             	sub    $0x4,%esp
  100b3d:	ff 75 0c             	pushl  0xc(%ebp)
  100b40:	8d 4d b0             	lea    -0x50(%ebp),%ecx
  100b43:	83 c1 04             	add    $0x4,%ecx
  100b46:	51                   	push   %ecx
  100b47:	52                   	push   %edx
  100b48:	ff d0                	call   *%eax
  100b4a:	83 c4 10             	add    $0x10,%esp
  100b4d:	eb 24                	jmp    100b73 <runcmd+0xac>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b4f:	ff 45 f4             	incl   -0xc(%ebp)
  100b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b55:	83 f8 02             	cmp    $0x2,%eax
  100b58:	76 a1                	jbe    100afb <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b5a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b5d:	83 ec 08             	sub    $0x8,%esp
  100b60:	50                   	push   %eax
  100b61:	68 53 36 10 00       	push   $0x103653
  100b66:	e8 96 f7 ff ff       	call   100301 <cprintf>
  100b6b:	83 c4 10             	add    $0x10,%esp
    return 0;
  100b6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b73:	c9                   	leave  
  100b74:	c3                   	ret    

00100b75 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b75:	55                   	push   %ebp
  100b76:	89 e5                	mov    %esp,%ebp
  100b78:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b7b:	83 ec 0c             	sub    $0xc,%esp
  100b7e:	68 6c 36 10 00       	push   $0x10366c
  100b83:	e8 79 f7 ff ff       	call   100301 <cprintf>
  100b88:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100b8b:	83 ec 0c             	sub    $0xc,%esp
  100b8e:	68 94 36 10 00       	push   $0x103694
  100b93:	e8 69 f7 ff ff       	call   100301 <cprintf>
  100b98:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100b9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100b9f:	74 0e                	je     100baf <kmonitor+0x3a>
        print_trapframe(tf);
  100ba1:	83 ec 0c             	sub    $0xc,%esp
  100ba4:	ff 75 08             	pushl  0x8(%ebp)
  100ba7:	e8 63 0d 00 00       	call   10190f <print_trapframe>
  100bac:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100baf:	83 ec 0c             	sub    $0xc,%esp
  100bb2:	68 b9 36 10 00       	push   $0x1036b9
  100bb7:	e8 38 f6 ff ff       	call   1001f4 <readline>
  100bbc:	83 c4 10             	add    $0x10,%esp
  100bbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bc6:	74 17                	je     100bdf <kmonitor+0x6a>
            if (runcmd(buf, tf) < 0) {
  100bc8:	83 ec 08             	sub    $0x8,%esp
  100bcb:	ff 75 08             	pushl  0x8(%ebp)
  100bce:	ff 75 f4             	pushl  -0xc(%ebp)
  100bd1:	e8 f1 fe ff ff       	call   100ac7 <runcmd>
  100bd6:	83 c4 10             	add    $0x10,%esp
  100bd9:	85 c0                	test   %eax,%eax
  100bdb:	79 02                	jns    100bdf <kmonitor+0x6a>
                break;
  100bdd:	eb 02                	jmp    100be1 <kmonitor+0x6c>
            }
        }
    }
  100bdf:	eb ce                	jmp    100baf <kmonitor+0x3a>
}
  100be1:	c9                   	leave  
  100be2:	c3                   	ret    

00100be3 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100be3:	55                   	push   %ebp
  100be4:	89 e5                	mov    %esp,%ebp
  100be6:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100be9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bf0:	eb 3c                	jmp    100c2e <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100bf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bf5:	89 d0                	mov    %edx,%eax
  100bf7:	01 c0                	add    %eax,%eax
  100bf9:	01 d0                	add    %edx,%eax
  100bfb:	c1 e0 02             	shl    $0x2,%eax
  100bfe:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c03:	8b 50 04             	mov    0x4(%eax),%edx
  100c06:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c09:	89 c8                	mov    %ecx,%eax
  100c0b:	01 c0                	add    %eax,%eax
  100c0d:	01 c8                	add    %ecx,%eax
  100c0f:	c1 e0 02             	shl    $0x2,%eax
  100c12:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c17:	8b 00                	mov    (%eax),%eax
  100c19:	83 ec 04             	sub    $0x4,%esp
  100c1c:	52                   	push   %edx
  100c1d:	50                   	push   %eax
  100c1e:	68 bd 36 10 00       	push   $0x1036bd
  100c23:	e8 d9 f6 ff ff       	call   100301 <cprintf>
  100c28:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2b:	ff 45 f4             	incl   -0xc(%ebp)
  100c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c31:	83 f8 02             	cmp    $0x2,%eax
  100c34:	76 bc                	jbe    100bf2 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c3b:	c9                   	leave  
  100c3c:	c3                   	ret    

00100c3d <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c3d:	55                   	push   %ebp
  100c3e:	89 e5                	mov    %esp,%ebp
  100c40:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c43:	e8 c5 fb ff ff       	call   10080d <print_kerninfo>
    return 0;
  100c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c4d:	c9                   	leave  
  100c4e:	c3                   	ret    

00100c4f <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c4f:	55                   	push   %ebp
  100c50:	89 e5                	mov    %esp,%ebp
  100c52:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c55:	e8 fa fc ff ff       	call   100954 <print_stackframe>
    return 0;
  100c5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c5f:	c9                   	leave  
  100c60:	c3                   	ret    

00100c61 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c61:	55                   	push   %ebp
  100c62:	89 e5                	mov    %esp,%ebp
  100c64:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  100c67:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100c6c:	85 c0                	test   %eax,%eax
  100c6e:	74 02                	je     100c72 <__panic+0x11>
        goto panic_dead;
  100c70:	eb 5d                	jmp    100ccf <__panic+0x6e>
    }
    is_panic = 1;
  100c72:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100c79:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100c7c:	8d 45 14             	lea    0x14(%ebp),%eax
  100c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100c82:	83 ec 04             	sub    $0x4,%esp
  100c85:	ff 75 0c             	pushl  0xc(%ebp)
  100c88:	ff 75 08             	pushl  0x8(%ebp)
  100c8b:	68 c6 36 10 00       	push   $0x1036c6
  100c90:	e8 6c f6 ff ff       	call   100301 <cprintf>
  100c95:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9b:	83 ec 08             	sub    $0x8,%esp
  100c9e:	50                   	push   %eax
  100c9f:	ff 75 10             	pushl  0x10(%ebp)
  100ca2:	e8 31 f6 ff ff       	call   1002d8 <vcprintf>
  100ca7:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100caa:	83 ec 0c             	sub    $0xc,%esp
  100cad:	68 e2 36 10 00       	push   $0x1036e2
  100cb2:	e8 4a f6 ff ff       	call   100301 <cprintf>
  100cb7:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  100cba:	83 ec 0c             	sub    $0xc,%esp
  100cbd:	68 e4 36 10 00       	push   $0x1036e4
  100cc2:	e8 3a f6 ff ff       	call   100301 <cprintf>
  100cc7:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  100cca:	e8 85 fc ff ff       	call   100954 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100ccf:	e8 d0 08 00 00       	call   1015a4 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cd4:	83 ec 0c             	sub    $0xc,%esp
  100cd7:	6a 00                	push   $0x0
  100cd9:	e8 97 fe ff ff       	call   100b75 <kmonitor>
  100cde:	83 c4 10             	add    $0x10,%esp
    }
  100ce1:	eb f1                	jmp    100cd4 <__panic+0x73>

00100ce3 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100ce3:	55                   	push   %ebp
  100ce4:	89 e5                	mov    %esp,%ebp
  100ce6:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100ce9:	8d 45 14             	lea    0x14(%ebp),%eax
  100cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100cef:	83 ec 04             	sub    $0x4,%esp
  100cf2:	ff 75 0c             	pushl  0xc(%ebp)
  100cf5:	ff 75 08             	pushl  0x8(%ebp)
  100cf8:	68 f6 36 10 00       	push   $0x1036f6
  100cfd:	e8 ff f5 ff ff       	call   100301 <cprintf>
  100d02:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d08:	83 ec 08             	sub    $0x8,%esp
  100d0b:	50                   	push   %eax
  100d0c:	ff 75 10             	pushl  0x10(%ebp)
  100d0f:	e8 c4 f5 ff ff       	call   1002d8 <vcprintf>
  100d14:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100d17:	83 ec 0c             	sub    $0xc,%esp
  100d1a:	68 e2 36 10 00       	push   $0x1036e2
  100d1f:	e8 dd f5 ff ff       	call   100301 <cprintf>
  100d24:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100d27:	c9                   	leave  
  100d28:	c3                   	ret    

00100d29 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d29:	55                   	push   %ebp
  100d2a:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d2c:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d31:	5d                   	pop    %ebp
  100d32:	c3                   	ret    

00100d33 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d33:	55                   	push   %ebp
  100d34:	89 e5                	mov    %esp,%ebp
  100d36:	83 ec 18             	sub    $0x18,%esp
  100d39:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d3f:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d43:	8a 45 f5             	mov    -0xb(%ebp),%al
  100d46:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  100d4a:	ee                   	out    %al,(%dx)
  100d4b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d51:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d55:	8a 45 f1             	mov    -0xf(%ebp),%al
  100d58:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  100d5c:	ee                   	out    %al,(%dx)
  100d5d:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d63:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d67:	8a 45 ed             	mov    -0x13(%ebp),%al
  100d6a:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100d6e:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d6f:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d76:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d79:	83 ec 0c             	sub    $0xc,%esp
  100d7c:	68 14 37 10 00       	push   $0x103714
  100d81:	e8 7b f5 ff ff       	call   100301 <cprintf>
  100d86:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d89:	83 ec 0c             	sub    $0xc,%esp
  100d8c:	6a 00                	push   $0x0
  100d8e:	e8 6a 08 00 00       	call   1015fd <pic_enable>
  100d93:	83 c4 10             	add    $0x10,%esp
}
  100d96:	c9                   	leave  
  100d97:	c3                   	ret    

00100d98 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d98:	55                   	push   %ebp
  100d99:	89 e5                	mov    %esp,%ebp
  100d9b:	83 ec 10             	sub    $0x10,%esp
  100d9e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100da4:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
  100da8:	89 c2                	mov    %eax,%edx
  100daa:	ec                   	in     (%dx),%al
  100dab:	88 45 fd             	mov    %al,-0x3(%ebp)
  100dae:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100db4:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100db8:	89 c2                	mov    %eax,%edx
  100dba:	ec                   	in     (%dx),%al
  100dbb:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dbe:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dc4:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  100dc8:	89 c2                	mov    %eax,%edx
  100dca:	ec                   	in     (%dx),%al
  100dcb:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dce:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100dd4:	66 8b 45 f2          	mov    -0xe(%ebp),%ax
  100dd8:	89 c2                	mov    %eax,%edx
  100dda:	ec                   	in     (%dx),%al
  100ddb:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dde:	c9                   	leave  
  100ddf:	c3                   	ret    

00100de0 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100de0:	55                   	push   %ebp
  100de1:	89 e5                	mov    %esp,%ebp
  100de3:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100de6:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100df0:	66 8b 00             	mov    (%eax),%ax
  100df3:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dfa:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100dff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e02:	66 8b 00             	mov    (%eax),%ax
  100e05:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e09:	74 12                	je     100e1d <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e0b:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e12:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e19:	b4 03 
  100e1b:	eb 13                	jmp    100e30 <cga_init+0x50>
    } else {
        *cp = was;
  100e1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100e20:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100e24:	66 89 02             	mov    %ax,(%edx)
        addr_6845 = CGA_BASE;
  100e27:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e2e:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e30:	66 a1 66 ee 10 00    	mov    0x10ee66,%ax
  100e36:	0f b7 c0             	movzwl %ax,%eax
  100e39:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e3d:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e41:	8a 45 f1             	mov    -0xf(%ebp),%al
  100e44:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  100e48:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e49:	66 a1 66 ee 10 00    	mov    0x10ee66,%ax
  100e4f:	40                   	inc    %eax
  100e50:	0f b7 c0             	movzwl %ax,%eax
  100e53:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e57:	66 8b 45 ee          	mov    -0x12(%ebp),%ax
  100e5b:	89 c2                	mov    %eax,%edx
  100e5d:	ec                   	in     (%dx),%al
  100e5e:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e61:	8a 45 ed             	mov    -0x13(%ebp),%al
  100e64:	0f b6 c0             	movzbl %al,%eax
  100e67:	c1 e0 08             	shl    $0x8,%eax
  100e6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e6d:	66 a1 66 ee 10 00    	mov    0x10ee66,%ax
  100e73:	0f b7 c0             	movzwl %ax,%eax
  100e76:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e7a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e7e:	8a 45 e9             	mov    -0x17(%ebp),%al
  100e81:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  100e85:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100e86:	66 a1 66 ee 10 00    	mov    0x10ee66,%ax
  100e8c:	40                   	inc    %eax
  100e8d:	0f b7 c0             	movzwl %ax,%eax
  100e90:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e94:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  100e98:	89 c2                	mov    %eax,%edx
  100e9a:	ec                   	in     (%dx),%al
  100e9b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100e9e:	8a 45 e5             	mov    -0x1b(%ebp),%al
  100ea1:	0f b6 c0             	movzbl %al,%eax
  100ea4:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaa:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100eb2:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100eb8:	c9                   	leave  
  100eb9:	c3                   	ret    

00100eba <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100eba:	55                   	push   %ebp
  100ebb:	89 e5                	mov    %esp,%ebp
  100ebd:	83 ec 38             	sub    $0x38,%esp
  100ec0:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ec6:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eca:	8a 45 f5             	mov    -0xb(%ebp),%al
  100ecd:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  100ed1:	ee                   	out    %al,(%dx)
  100ed2:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100ed8:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100edc:	8a 45 f1             	mov    -0xf(%ebp),%al
  100edf:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  100ee3:	ee                   	out    %al,(%dx)
  100ee4:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100eea:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100eee:	8a 45 ed             	mov    -0x13(%ebp),%al
  100ef1:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  100ef5:	ee                   	out    %al,(%dx)
  100ef6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100efc:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f00:	8a 45 e9             	mov    -0x17(%ebp),%al
  100f03:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  100f07:	ee                   	out    %al,(%dx)
  100f08:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f0e:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f12:	8a 45 e5             	mov    -0x1b(%ebp),%al
  100f15:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  100f19:	ee                   	out    %al,(%dx)
  100f1a:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f20:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f24:	8a 45 e1             	mov    -0x1f(%ebp),%al
  100f27:	66 8b 55 e2          	mov    -0x1e(%ebp),%dx
  100f2b:	ee                   	out    %al,(%dx)
  100f2c:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f32:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f36:	8a 45 dd             	mov    -0x23(%ebp),%al
  100f39:	66 8b 55 de          	mov    -0x22(%ebp),%dx
  100f3d:	ee                   	out    %al,(%dx)
  100f3e:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f44:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  100f48:	89 c2                	mov    %eax,%edx
  100f4a:	ec                   	in     (%dx),%al
  100f4b:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f4e:	8a 45 d9             	mov    -0x27(%ebp),%al
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f51:	3c ff                	cmp    $0xff,%al
  100f53:	0f 95 c0             	setne  %al
  100f56:	0f b6 c0             	movzbl %al,%eax
  100f59:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f5e:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f64:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  100f68:	89 c2                	mov    %eax,%edx
  100f6a:	ec                   	in     (%dx),%al
  100f6b:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100f6e:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100f74:	66 8b 45 d2          	mov    -0x2e(%ebp),%ax
  100f78:	89 c2                	mov    %eax,%edx
  100f7a:	ec                   	in     (%dx),%al
  100f7b:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f7e:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100f83:	85 c0                	test   %eax,%eax
  100f85:	74 0d                	je     100f94 <serial_init+0xda>
        pic_enable(IRQ_COM1);
  100f87:	83 ec 0c             	sub    $0xc,%esp
  100f8a:	6a 04                	push   $0x4
  100f8c:	e8 6c 06 00 00       	call   1015fd <pic_enable>
  100f91:	83 c4 10             	add    $0x10,%esp
    }
}
  100f94:	c9                   	leave  
  100f95:	c3                   	ret    

00100f96 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100f96:	55                   	push   %ebp
  100f97:	89 e5                	mov    %esp,%ebp
  100f99:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fa3:	eb 08                	jmp    100fad <lpt_putc_sub+0x17>
        delay();
  100fa5:	e8 ee fd ff ff       	call   100d98 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100faa:	ff 45 fc             	incl   -0x4(%ebp)
  100fad:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fb3:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  100fb7:	89 c2                	mov    %eax,%edx
  100fb9:	ec                   	in     (%dx),%al
  100fba:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fbd:	8a 45 f9             	mov    -0x7(%ebp),%al
  100fc0:	84 c0                	test   %al,%al
  100fc2:	78 09                	js     100fcd <lpt_putc_sub+0x37>
  100fc4:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fcb:	7e d8                	jle    100fa5 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  100fd0:	0f b6 c0             	movzbl %al,%eax
  100fd3:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  100fd9:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fdc:	8a 45 f5             	mov    -0xb(%ebp),%al
  100fdf:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  100fe3:	ee                   	out    %al,(%dx)
  100fe4:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  100fea:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100fee:	8a 45 f1             	mov    -0xf(%ebp),%al
  100ff1:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  100ff5:	ee                   	out    %al,(%dx)
  100ff6:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  100ffc:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101000:	8a 45 ed             	mov    -0x13(%ebp),%al
  101003:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  101007:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101008:	c9                   	leave  
  101009:	c3                   	ret    

0010100a <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10100a:	55                   	push   %ebp
  10100b:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10100d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101011:	74 0d                	je     101020 <lpt_putc+0x16>
        lpt_putc_sub(c);
  101013:	ff 75 08             	pushl  0x8(%ebp)
  101016:	e8 7b ff ff ff       	call   100f96 <lpt_putc_sub>
  10101b:	83 c4 04             	add    $0x4,%esp
  10101e:	eb 1e                	jmp    10103e <lpt_putc+0x34>
    }
    else {
        lpt_putc_sub('\b');
  101020:	6a 08                	push   $0x8
  101022:	e8 6f ff ff ff       	call   100f96 <lpt_putc_sub>
  101027:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  10102a:	6a 20                	push   $0x20
  10102c:	e8 65 ff ff ff       	call   100f96 <lpt_putc_sub>
  101031:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101034:	6a 08                	push   $0x8
  101036:	e8 5b ff ff ff       	call   100f96 <lpt_putc_sub>
  10103b:	83 c4 04             	add    $0x4,%esp
    }
}
  10103e:	c9                   	leave  
  10103f:	c3                   	ret    

00101040 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101040:	55                   	push   %ebp
  101041:	89 e5                	mov    %esp,%ebp
  101043:	53                   	push   %ebx
  101044:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101047:	8b 45 08             	mov    0x8(%ebp),%eax
  10104a:	b0 00                	mov    $0x0,%al
  10104c:	85 c0                	test   %eax,%eax
  10104e:	75 07                	jne    101057 <cga_putc+0x17>
        c |= 0x0700;
  101050:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101057:	8b 45 08             	mov    0x8(%ebp),%eax
  10105a:	0f b6 c0             	movzbl %al,%eax
  10105d:	83 f8 0a             	cmp    $0xa,%eax
  101060:	74 44                	je     1010a6 <cga_putc+0x66>
  101062:	83 f8 0d             	cmp    $0xd,%eax
  101065:	74 4e                	je     1010b5 <cga_putc+0x75>
  101067:	83 f8 08             	cmp    $0x8,%eax
  10106a:	75 71                	jne    1010dd <cga_putc+0x9d>
    case '\b':
        if (crt_pos > 0) {
  10106c:	66 a1 64 ee 10 00    	mov    0x10ee64,%ax
  101072:	66 85 c0             	test   %ax,%ax
  101075:	74 2d                	je     1010a4 <cga_putc+0x64>
            crt_pos --;
  101077:	66 a1 64 ee 10 00    	mov    0x10ee64,%ax
  10107d:	48                   	dec    %eax
  10107e:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101084:	8b 15 60 ee 10 00    	mov    0x10ee60,%edx
  10108a:	66 a1 64 ee 10 00    	mov    0x10ee64,%ax
  101090:	0f b7 c0             	movzwl %ax,%eax
  101093:	01 c0                	add    %eax,%eax
  101095:	01 c2                	add    %eax,%edx
  101097:	8b 45 08             	mov    0x8(%ebp),%eax
  10109a:	b0 00                	mov    $0x0,%al
  10109c:	83 c8 20             	or     $0x20,%eax
  10109f:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010a2:	eb 5e                	jmp    101102 <cga_putc+0xc2>
  1010a4:	eb 5c                	jmp    101102 <cga_putc+0xc2>
    case '\n':
        crt_pos += CRT_COLS;
  1010a6:	66 a1 64 ee 10 00    	mov    0x10ee64,%ax
  1010ac:	83 c0 50             	add    $0x50,%eax
  1010af:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010b5:	66 8b 0d 64 ee 10 00 	mov    0x10ee64,%cx
  1010bc:	66 a1 64 ee 10 00    	mov    0x10ee64,%ax
  1010c2:	bb 50 00 00 00       	mov    $0x50,%ebx
  1010c7:	ba 00 00 00 00       	mov    $0x0,%edx
  1010cc:	66 f7 f3             	div    %bx
  1010cf:	89 d0                	mov    %edx,%eax
  1010d1:	29 c1                	sub    %eax,%ecx
  1010d3:	89 c8                	mov    %ecx,%eax
  1010d5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  1010db:	eb 25                	jmp    101102 <cga_putc+0xc2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1010dd:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  1010e3:	66 a1 64 ee 10 00    	mov    0x10ee64,%ax
  1010e9:	8d 50 01             	lea    0x1(%eax),%edx
  1010ec:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  1010f3:	0f b7 c0             	movzwl %ax,%eax
  1010f6:	01 c0                	add    %eax,%eax
  1010f8:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fe:	66 89 02             	mov    %ax,(%edx)
        break;
  101101:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101102:	66 a1 64 ee 10 00    	mov    0x10ee64,%ax
  101108:	66 3d cf 07          	cmp    $0x7cf,%ax
  10110c:	76 58                	jbe    101166 <cga_putc+0x126>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10110e:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101113:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101119:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10111e:	83 ec 04             	sub    $0x4,%esp
  101121:	68 00 0f 00 00       	push   $0xf00
  101126:	52                   	push   %edx
  101127:	50                   	push   %eax
  101128:	e8 81 21 00 00       	call   1032ae <memmove>
  10112d:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101130:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101137:	eb 15                	jmp    10114e <cga_putc+0x10e>
            crt_buf[i] = 0x0700 | ' ';
  101139:	8b 15 60 ee 10 00    	mov    0x10ee60,%edx
  10113f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101142:	01 c0                	add    %eax,%eax
  101144:	01 d0                	add    %edx,%eax
  101146:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10114b:	ff 45 f4             	incl   -0xc(%ebp)
  10114e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101155:	7e e2                	jle    101139 <cga_putc+0xf9>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101157:	66 a1 64 ee 10 00    	mov    0x10ee64,%ax
  10115d:	83 e8 50             	sub    $0x50,%eax
  101160:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101166:	66 a1 66 ee 10 00    	mov    0x10ee66,%ax
  10116c:	0f b7 c0             	movzwl %ax,%eax
  10116f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101173:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101177:	8a 45 f1             	mov    -0xf(%ebp),%al
  10117a:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  10117e:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10117f:	66 a1 64 ee 10 00    	mov    0x10ee64,%ax
  101185:	66 c1 e8 08          	shr    $0x8,%ax
  101189:	0f b6 d0             	movzbl %al,%edx
  10118c:	66 a1 66 ee 10 00    	mov    0x10ee66,%ax
  101192:	40                   	inc    %eax
  101193:	0f b7 c0             	movzwl %ax,%eax
  101196:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10119a:	88 55 ed             	mov    %dl,-0x13(%ebp)
  10119d:	8a 45 ed             	mov    -0x13(%ebp),%al
  1011a0:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  1011a4:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011a5:	66 a1 66 ee 10 00    	mov    0x10ee66,%ax
  1011ab:	0f b7 c0             	movzwl %ax,%eax
  1011ae:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1011b2:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1011b6:	8a 45 e9             	mov    -0x17(%ebp),%al
  1011b9:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  1011bd:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1011be:	66 a1 64 ee 10 00    	mov    0x10ee64,%ax
  1011c4:	0f b6 d0             	movzbl %al,%edx
  1011c7:	66 a1 66 ee 10 00    	mov    0x10ee66,%ax
  1011cd:	40                   	inc    %eax
  1011ce:	0f b7 c0             	movzwl %ax,%eax
  1011d1:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011d5:	88 55 e5             	mov    %dl,-0x1b(%ebp)
  1011d8:	8a 45 e5             	mov    -0x1b(%ebp),%al
  1011db:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  1011df:	ee                   	out    %al,(%dx)
}
  1011e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1011e3:	c9                   	leave  
  1011e4:	c3                   	ret    

001011e5 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1011e5:	55                   	push   %ebp
  1011e6:	89 e5                	mov    %esp,%ebp
  1011e8:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1011eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1011f2:	eb 08                	jmp    1011fc <serial_putc_sub+0x17>
        delay();
  1011f4:	e8 9f fb ff ff       	call   100d98 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1011f9:	ff 45 fc             	incl   -0x4(%ebp)
  1011fc:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101202:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  101206:	89 c2                	mov    %eax,%edx
  101208:	ec                   	in     (%dx),%al
  101209:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10120c:	8a 45 f9             	mov    -0x7(%ebp),%al
  10120f:	0f b6 c0             	movzbl %al,%eax
  101212:	83 e0 20             	and    $0x20,%eax
  101215:	85 c0                	test   %eax,%eax
  101217:	75 09                	jne    101222 <serial_putc_sub+0x3d>
  101219:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101220:	7e d2                	jle    1011f4 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101222:	8b 45 08             	mov    0x8(%ebp),%eax
  101225:	0f b6 c0             	movzbl %al,%eax
  101228:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10122e:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101231:	8a 45 f5             	mov    -0xb(%ebp),%al
  101234:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  101238:	ee                   	out    %al,(%dx)
}
  101239:	c9                   	leave  
  10123a:	c3                   	ret    

0010123b <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10123b:	55                   	push   %ebp
  10123c:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10123e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101242:	74 0d                	je     101251 <serial_putc+0x16>
        serial_putc_sub(c);
  101244:	ff 75 08             	pushl  0x8(%ebp)
  101247:	e8 99 ff ff ff       	call   1011e5 <serial_putc_sub>
  10124c:	83 c4 04             	add    $0x4,%esp
  10124f:	eb 1e                	jmp    10126f <serial_putc+0x34>
    }
    else {
        serial_putc_sub('\b');
  101251:	6a 08                	push   $0x8
  101253:	e8 8d ff ff ff       	call   1011e5 <serial_putc_sub>
  101258:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  10125b:	6a 20                	push   $0x20
  10125d:	e8 83 ff ff ff       	call   1011e5 <serial_putc_sub>
  101262:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  101265:	6a 08                	push   $0x8
  101267:	e8 79 ff ff ff       	call   1011e5 <serial_putc_sub>
  10126c:	83 c4 04             	add    $0x4,%esp
    }
}
  10126f:	c9                   	leave  
  101270:	c3                   	ret    

00101271 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101271:	55                   	push   %ebp
  101272:	89 e5                	mov    %esp,%ebp
  101274:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101277:	eb 33                	jmp    1012ac <cons_intr+0x3b>
        if (c != 0) {
  101279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10127d:	74 2d                	je     1012ac <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10127f:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101284:	8d 50 01             	lea    0x1(%eax),%edx
  101287:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10128d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101290:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101296:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10129b:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012a0:	75 0a                	jne    1012ac <cons_intr+0x3b>
                cons.wpos = 0;
  1012a2:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  1012a9:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1012af:	ff d0                	call   *%eax
  1012b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1012b4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1012b8:	75 bf                	jne    101279 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1012ba:	c9                   	leave  
  1012bb:	c3                   	ret    

001012bc <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1012bc:	55                   	push   %ebp
  1012bd:	89 e5                	mov    %esp,%ebp
  1012bf:	83 ec 10             	sub    $0x10,%esp
  1012c2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012c8:	66 8b 45 fa          	mov    -0x6(%ebp),%ax
  1012cc:	89 c2                	mov    %eax,%edx
  1012ce:	ec                   	in     (%dx),%al
  1012cf:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012d2:	8a 45 f9             	mov    -0x7(%ebp),%al
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1012d5:	0f b6 c0             	movzbl %al,%eax
  1012d8:	83 e0 01             	and    $0x1,%eax
  1012db:	85 c0                	test   %eax,%eax
  1012dd:	75 07                	jne    1012e6 <serial_proc_data+0x2a>
        return -1;
  1012df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1012e4:	eb 29                	jmp    10130f <serial_proc_data+0x53>
  1012e6:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012ec:	66 8b 45 f6          	mov    -0xa(%ebp),%ax
  1012f0:	89 c2                	mov    %eax,%edx
  1012f2:	ec                   	in     (%dx),%al
  1012f3:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1012f6:	8a 45 f5             	mov    -0xb(%ebp),%al
    }
    int c = inb(COM1 + COM_RX);
  1012f9:	0f b6 c0             	movzbl %al,%eax
  1012fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1012ff:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101303:	75 07                	jne    10130c <serial_proc_data+0x50>
        c = '\b';
  101305:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10130c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10130f:	c9                   	leave  
  101310:	c3                   	ret    

00101311 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101311:	55                   	push   %ebp
  101312:	89 e5                	mov    %esp,%ebp
  101314:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  101317:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10131c:	85 c0                	test   %eax,%eax
  10131e:	74 10                	je     101330 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101320:	83 ec 0c             	sub    $0xc,%esp
  101323:	68 bc 12 10 00       	push   $0x1012bc
  101328:	e8 44 ff ff ff       	call   101271 <cons_intr>
  10132d:	83 c4 10             	add    $0x10,%esp
    }
}
  101330:	c9                   	leave  
  101331:	c3                   	ret    

00101332 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101332:	55                   	push   %ebp
  101333:	89 e5                	mov    %esp,%ebp
  101335:	83 ec 28             	sub    $0x28,%esp
  101338:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10133e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101341:	89 c2                	mov    %eax,%edx
  101343:	ec                   	in     (%dx),%al
  101344:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101347:	8a 45 ef             	mov    -0x11(%ebp),%al
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10134a:	0f b6 c0             	movzbl %al,%eax
  10134d:	83 e0 01             	and    $0x1,%eax
  101350:	85 c0                	test   %eax,%eax
  101352:	75 0a                	jne    10135e <kbd_proc_data+0x2c>
        return -1;
  101354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101359:	e9 52 01 00 00       	jmp    1014b0 <kbd_proc_data+0x17e>
  10135e:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101367:	89 c2                	mov    %eax,%edx
  101369:	ec                   	in     (%dx),%al
  10136a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10136d:	8a 45 eb             	mov    -0x15(%ebp),%al
    }

    data = inb(KBDATAP);
  101370:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101373:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101377:	75 17                	jne    101390 <kbd_proc_data+0x5e>
        // E0 escape character
        shift |= E0ESC;
  101379:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10137e:	83 c8 40             	or     $0x40,%eax
  101381:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101386:	b8 00 00 00 00       	mov    $0x0,%eax
  10138b:	e9 20 01 00 00       	jmp    1014b0 <kbd_proc_data+0x17e>
    } else if (data & 0x80) {
  101390:	8a 45 f3             	mov    -0xd(%ebp),%al
  101393:	84 c0                	test   %al,%al
  101395:	79 44                	jns    1013db <kbd_proc_data+0xa9>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101397:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10139c:	83 e0 40             	and    $0x40,%eax
  10139f:	85 c0                	test   %eax,%eax
  1013a1:	75 08                	jne    1013ab <kbd_proc_data+0x79>
  1013a3:	8a 45 f3             	mov    -0xd(%ebp),%al
  1013a6:	83 e0 7f             	and    $0x7f,%eax
  1013a9:	eb 03                	jmp    1013ae <kbd_proc_data+0x7c>
  1013ab:	8a 45 f3             	mov    -0xd(%ebp),%al
  1013ae:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1013b1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013b5:	8a 80 40 e0 10 00    	mov    0x10e040(%eax),%al
  1013bb:	83 c8 40             	or     $0x40,%eax
  1013be:	0f b6 c0             	movzbl %al,%eax
  1013c1:	f7 d0                	not    %eax
  1013c3:	89 c2                	mov    %eax,%edx
  1013c5:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013ca:	21 d0                	and    %edx,%eax
  1013cc:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013d1:	b8 00 00 00 00       	mov    $0x0,%eax
  1013d6:	e9 d5 00 00 00       	jmp    1014b0 <kbd_proc_data+0x17e>
    } else if (shift & E0ESC) {
  1013db:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013e0:	83 e0 40             	and    $0x40,%eax
  1013e3:	85 c0                	test   %eax,%eax
  1013e5:	74 11                	je     1013f8 <kbd_proc_data+0xc6>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1013e7:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1013eb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013f0:	83 e0 bf             	and    $0xffffffbf,%eax
  1013f3:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  1013f8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013fc:	8a 80 40 e0 10 00    	mov    0x10e040(%eax),%al
  101402:	0f b6 d0             	movzbl %al,%edx
  101405:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10140a:	09 d0                	or     %edx,%eax
  10140c:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101411:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101415:	8a 80 40 e1 10 00    	mov    0x10e140(%eax),%al
  10141b:	0f b6 d0             	movzbl %al,%edx
  10141e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101423:	31 d0                	xor    %edx,%eax
  101425:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  10142a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10142f:	83 e0 03             	and    $0x3,%eax
  101432:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  101439:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143d:	01 d0                	add    %edx,%eax
  10143f:	8a 00                	mov    (%eax),%al
  101441:	0f b6 c0             	movzbl %al,%eax
  101444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101447:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10144c:	83 e0 08             	and    $0x8,%eax
  10144f:	85 c0                	test   %eax,%eax
  101451:	74 22                	je     101475 <kbd_proc_data+0x143>
        if ('a' <= c && c <= 'z')
  101453:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101457:	7e 0c                	jle    101465 <kbd_proc_data+0x133>
  101459:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10145d:	7f 06                	jg     101465 <kbd_proc_data+0x133>
            c += 'A' - 'a';
  10145f:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101463:	eb 10                	jmp    101475 <kbd_proc_data+0x143>
        else if ('A' <= c && c <= 'Z')
  101465:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101469:	7e 0a                	jle    101475 <kbd_proc_data+0x143>
  10146b:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10146f:	7f 04                	jg     101475 <kbd_proc_data+0x143>
            c += 'a' - 'A';
  101471:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101475:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147a:	f7 d0                	not    %eax
  10147c:	83 e0 06             	and    $0x6,%eax
  10147f:	85 c0                	test   %eax,%eax
  101481:	75 2a                	jne    1014ad <kbd_proc_data+0x17b>
  101483:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10148a:	75 21                	jne    1014ad <kbd_proc_data+0x17b>
        cprintf("Rebooting!\n");
  10148c:	83 ec 0c             	sub    $0xc,%esp
  10148f:	68 2f 37 10 00       	push   $0x10372f
  101494:	e8 68 ee ff ff       	call   100301 <cprintf>
  101499:	83 c4 10             	add    $0x10,%esp
  10149c:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1014a2:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1014a6:	8a 45 e7             	mov    -0x19(%ebp),%al
  1014a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1014ac:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1014ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1014b0:	c9                   	leave  
  1014b1:	c3                   	ret    

001014b2 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1014b2:	55                   	push   %ebp
  1014b3:	89 e5                	mov    %esp,%ebp
  1014b5:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  1014b8:	83 ec 0c             	sub    $0xc,%esp
  1014bb:	68 32 13 10 00       	push   $0x101332
  1014c0:	e8 ac fd ff ff       	call   101271 <cons_intr>
  1014c5:	83 c4 10             	add    $0x10,%esp
}
  1014c8:	c9                   	leave  
  1014c9:	c3                   	ret    

001014ca <kbd_init>:

static void
kbd_init(void) {
  1014ca:	55                   	push   %ebp
  1014cb:	89 e5                	mov    %esp,%ebp
  1014cd:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  1014d0:	e8 dd ff ff ff       	call   1014b2 <kbd_intr>
    pic_enable(IRQ_KBD);
  1014d5:	83 ec 0c             	sub    $0xc,%esp
  1014d8:	6a 01                	push   $0x1
  1014da:	e8 1e 01 00 00       	call   1015fd <pic_enable>
  1014df:	83 c4 10             	add    $0x10,%esp
}
  1014e2:	c9                   	leave  
  1014e3:	c3                   	ret    

001014e4 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1014e4:	55                   	push   %ebp
  1014e5:	89 e5                	mov    %esp,%ebp
  1014e7:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  1014ea:	e8 f1 f8 ff ff       	call   100de0 <cga_init>
    serial_init();
  1014ef:	e8 c6 f9 ff ff       	call   100eba <serial_init>
    kbd_init();
  1014f4:	e8 d1 ff ff ff       	call   1014ca <kbd_init>
    if (!serial_exists) {
  1014f9:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1014fe:	85 c0                	test   %eax,%eax
  101500:	75 10                	jne    101512 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101502:	83 ec 0c             	sub    $0xc,%esp
  101505:	68 3b 37 10 00       	push   $0x10373b
  10150a:	e8 f2 ed ff ff       	call   100301 <cprintf>
  10150f:	83 c4 10             	add    $0x10,%esp
    }
}
  101512:	c9                   	leave  
  101513:	c3                   	ret    

00101514 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101514:	55                   	push   %ebp
  101515:	89 e5                	mov    %esp,%ebp
  101517:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  10151a:	ff 75 08             	pushl  0x8(%ebp)
  10151d:	e8 e8 fa ff ff       	call   10100a <lpt_putc>
  101522:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  101525:	83 ec 0c             	sub    $0xc,%esp
  101528:	ff 75 08             	pushl  0x8(%ebp)
  10152b:	e8 10 fb ff ff       	call   101040 <cga_putc>
  101530:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  101533:	83 ec 0c             	sub    $0xc,%esp
  101536:	ff 75 08             	pushl  0x8(%ebp)
  101539:	e8 fd fc ff ff       	call   10123b <serial_putc>
  10153e:	83 c4 10             	add    $0x10,%esp
}
  101541:	c9                   	leave  
  101542:	c3                   	ret    

00101543 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101543:	55                   	push   %ebp
  101544:	89 e5                	mov    %esp,%ebp
  101546:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101549:	e8 c3 fd ff ff       	call   101311 <serial_intr>
    kbd_intr();
  10154e:	e8 5f ff ff ff       	call   1014b2 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  101553:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  101559:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10155e:	39 c2                	cmp    %eax,%edx
  101560:	74 35                	je     101597 <cons_getc+0x54>
        c = cons.buf[cons.rpos ++];
  101562:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101567:	8d 50 01             	lea    0x1(%eax),%edx
  10156a:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101570:	8a 80 80 ee 10 00    	mov    0x10ee80(%eax),%al
  101576:	0f b6 c0             	movzbl %al,%eax
  101579:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  10157c:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101581:	3d 00 02 00 00       	cmp    $0x200,%eax
  101586:	75 0a                	jne    101592 <cons_getc+0x4f>
            cons.rpos = 0;
  101588:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10158f:	00 00 00 
        }
        return c;
  101592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101595:	eb 05                	jmp    10159c <cons_getc+0x59>
    }
    return 0;
  101597:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10159c:	c9                   	leave  
  10159d:	c3                   	ret    

0010159e <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10159e:	55                   	push   %ebp
  10159f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1015a1:	fb                   	sti    
    sti();
}
  1015a2:	5d                   	pop    %ebp
  1015a3:	c3                   	ret    

001015a4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1015a4:	55                   	push   %ebp
  1015a5:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1015a7:	fa                   	cli    
    cli();
}
  1015a8:	5d                   	pop    %ebp
  1015a9:	c3                   	ret    

001015aa <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1015aa:	55                   	push   %ebp
  1015ab:	89 e5                	mov    %esp,%ebp
  1015ad:	83 ec 14             	sub    $0x14,%esp
  1015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1015b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015ba:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  1015c0:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  1015c5:	85 c0                	test   %eax,%eax
  1015c7:	74 32                	je     1015fb <pic_setmask+0x51>
        outb(IO_PIC1 + 1, mask);
  1015c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015cc:	0f b6 c0             	movzbl %al,%eax
  1015cf:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1015d5:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015d8:	8a 45 fd             	mov    -0x3(%ebp),%al
  1015db:	66 8b 55 fe          	mov    -0x2(%ebp),%dx
  1015df:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1015e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015e3:	66 c1 e8 08          	shr    $0x8,%ax
  1015e7:	0f b6 c0             	movzbl %al,%eax
  1015ea:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1015f0:	88 45 f9             	mov    %al,-0x7(%ebp)
  1015f3:	8a 45 f9             	mov    -0x7(%ebp),%al
  1015f6:	66 8b 55 fa          	mov    -0x6(%ebp),%dx
  1015fa:	ee                   	out    %al,(%dx)
    }
}
  1015fb:	c9                   	leave  
  1015fc:	c3                   	ret    

001015fd <pic_enable>:

void
pic_enable(unsigned int irq) {
  1015fd:	55                   	push   %ebp
  1015fe:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101600:	8b 45 08             	mov    0x8(%ebp),%eax
  101603:	ba 01 00 00 00       	mov    $0x1,%edx
  101608:	88 c1                	mov    %al,%cl
  10160a:	d3 e2                	shl    %cl,%edx
  10160c:	89 d0                	mov    %edx,%eax
  10160e:	f7 d0                	not    %eax
  101610:	89 c2                	mov    %eax,%edx
  101612:	66 a1 50 e5 10 00    	mov    0x10e550,%ax
  101618:	21 d0                	and    %edx,%eax
  10161a:	0f b7 c0             	movzwl %ax,%eax
  10161d:	50                   	push   %eax
  10161e:	e8 87 ff ff ff       	call   1015aa <pic_setmask>
  101623:	83 c4 04             	add    $0x4,%esp
}
  101626:	c9                   	leave  
  101627:	c3                   	ret    

00101628 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101628:	55                   	push   %ebp
  101629:	89 e5                	mov    %esp,%ebp
  10162b:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  10162e:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  101635:	00 00 00 
  101638:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10163e:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101642:	8a 45 fd             	mov    -0x3(%ebp),%al
  101645:	66 8b 55 fe          	mov    -0x2(%ebp),%dx
  101649:	ee                   	out    %al,(%dx)
  10164a:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101650:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101654:	8a 45 f9             	mov    -0x7(%ebp),%al
  101657:	66 8b 55 fa          	mov    -0x6(%ebp),%dx
  10165b:	ee                   	out    %al,(%dx)
  10165c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101662:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101666:	8a 45 f5             	mov    -0xb(%ebp),%al
  101669:	66 8b 55 f6          	mov    -0xa(%ebp),%dx
  10166d:	ee                   	out    %al,(%dx)
  10166e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101674:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101678:	8a 45 f1             	mov    -0xf(%ebp),%al
  10167b:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
  10167f:	ee                   	out    %al,(%dx)
  101680:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101686:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10168a:	8a 45 ed             	mov    -0x13(%ebp),%al
  10168d:	66 8b 55 ee          	mov    -0x12(%ebp),%dx
  101691:	ee                   	out    %al,(%dx)
  101692:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101698:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  10169c:	8a 45 e9             	mov    -0x17(%ebp),%al
  10169f:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
  1016a3:	ee                   	out    %al,(%dx)
  1016a4:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1016aa:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1016ae:	8a 45 e5             	mov    -0x1b(%ebp),%al
  1016b1:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
  1016b5:	ee                   	out    %al,(%dx)
  1016b6:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1016bc:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1016c0:	8a 45 e1             	mov    -0x1f(%ebp),%al
  1016c3:	66 8b 55 e2          	mov    -0x1e(%ebp),%dx
  1016c7:	ee                   	out    %al,(%dx)
  1016c8:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1016ce:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1016d2:	8a 45 dd             	mov    -0x23(%ebp),%al
  1016d5:	66 8b 55 de          	mov    -0x22(%ebp),%dx
  1016d9:	ee                   	out    %al,(%dx)
  1016da:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1016e0:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1016e4:	8a 45 d9             	mov    -0x27(%ebp),%al
  1016e7:	66 8b 55 da          	mov    -0x26(%ebp),%dx
  1016eb:	ee                   	out    %al,(%dx)
  1016ec:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  1016f2:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  1016f6:	8a 45 d5             	mov    -0x2b(%ebp),%al
  1016f9:	66 8b 55 d6          	mov    -0x2a(%ebp),%dx
  1016fd:	ee                   	out    %al,(%dx)
  1016fe:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101704:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101708:	8a 45 d1             	mov    -0x2f(%ebp),%al
  10170b:	66 8b 55 d2          	mov    -0x2e(%ebp),%dx
  10170f:	ee                   	out    %al,(%dx)
  101710:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101716:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10171a:	8a 45 cd             	mov    -0x33(%ebp),%al
  10171d:	66 8b 55 ce          	mov    -0x32(%ebp),%dx
  101721:	ee                   	out    %al,(%dx)
  101722:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101728:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10172c:	8a 45 c9             	mov    -0x37(%ebp),%al
  10172f:	66 8b 55 ca          	mov    -0x36(%ebp),%dx
  101733:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101734:	66 a1 50 e5 10 00    	mov    0x10e550,%ax
  10173a:	66 83 f8 ff          	cmp    $0xffff,%ax
  10173e:	74 12                	je     101752 <pic_init+0x12a>
        pic_setmask(irq_mask);
  101740:	66 a1 50 e5 10 00    	mov    0x10e550,%ax
  101746:	0f b7 c0             	movzwl %ax,%eax
  101749:	50                   	push   %eax
  10174a:	e8 5b fe ff ff       	call   1015aa <pic_setmask>
  10174f:	83 c4 04             	add    $0x4,%esp
    }
}
  101752:	c9                   	leave  
  101753:	c3                   	ret    

00101754 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  101754:	55                   	push   %ebp
  101755:	89 e5                	mov    %esp,%ebp
  101757:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10175a:	83 ec 08             	sub    $0x8,%esp
  10175d:	6a 64                	push   $0x64
  10175f:	68 60 37 10 00       	push   $0x103760
  101764:	e8 98 eb ff ff       	call   100301 <cprintf>
  101769:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10176c:	c9                   	leave  
  10176d:	c3                   	ret    

0010176e <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10176e:	55                   	push   %ebp
  10176f:	89 e5                	mov    %esp,%ebp
  101771:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101774:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10177b:	e9 b8 00 00 00       	jmp    101838 <idt_init+0xca>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101780:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101783:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10178a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10178d:	66 89 04 d5 a0 f0 10 	mov    %ax,0x10f0a0(,%edx,8)
  101794:	00 
  101795:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101798:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10179f:	00 08 00 
  1017a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017a5:	8a 14 c5 a4 f0 10 00 	mov    0x10f0a4(,%eax,8),%dl
  1017ac:	83 e2 e0             	and    $0xffffffe0,%edx
  1017af:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1017b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017b9:	8a 14 c5 a4 f0 10 00 	mov    0x10f0a4(,%eax,8),%dl
  1017c0:	83 e2 1f             	and    $0x1f,%edx
  1017c3:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1017ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017cd:	8a 14 c5 a5 f0 10 00 	mov    0x10f0a5(,%eax,8),%dl
  1017d4:	83 e2 f0             	and    $0xfffffff0,%edx
  1017d7:	83 ca 0e             	or     $0xe,%edx
  1017da:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1017e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017e4:	8a 14 c5 a5 f0 10 00 	mov    0x10f0a5(,%eax,8),%dl
  1017eb:	83 e2 ef             	and    $0xffffffef,%edx
  1017ee:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1017f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017f8:	8a 14 c5 a5 f0 10 00 	mov    0x10f0a5(,%eax,8),%dl
  1017ff:	83 e2 9f             	and    $0xffffff9f,%edx
  101802:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101809:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10180c:	8a 14 c5 a5 f0 10 00 	mov    0x10f0a5(,%eax,8),%dl
  101813:	83 ca 80             	or     $0xffffff80,%edx
  101816:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10181d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101820:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101827:	c1 e8 10             	shr    $0x10,%eax
  10182a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10182d:	66 89 04 d5 a6 f0 10 	mov    %ax,0x10f0a6(,%edx,8)
  101834:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101835:	ff 45 fc             	incl   -0x4(%ebp)
  101838:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10183b:	3d ff 00 00 00       	cmp    $0xff,%eax
  101840:	0f 86 3a ff ff ff    	jbe    101780 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101846:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10184b:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101851:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101858:	08 00 
  10185a:	a0 6c f4 10 00       	mov    0x10f46c,%al
  10185f:	83 e0 e0             	and    $0xffffffe0,%eax
  101862:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101867:	a0 6c f4 10 00       	mov    0x10f46c,%al
  10186c:	83 e0 1f             	and    $0x1f,%eax
  10186f:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101874:	a0 6d f4 10 00       	mov    0x10f46d,%al
  101879:	83 e0 f0             	and    $0xfffffff0,%eax
  10187c:	83 c8 0e             	or     $0xe,%eax
  10187f:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101884:	a0 6d f4 10 00       	mov    0x10f46d,%al
  101889:	83 e0 ef             	and    $0xffffffef,%eax
  10188c:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101891:	a0 6d f4 10 00       	mov    0x10f46d,%al
  101896:	83 c8 60             	or     $0x60,%eax
  101899:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10189e:	a0 6d f4 10 00       	mov    0x10f46d,%al
  1018a3:	83 c8 80             	or     $0xffffff80,%eax
  1018a6:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1018ab:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1018b0:	c1 e8 10             	shr    $0x10,%eax
  1018b3:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  1018b9:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  1018c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018c3:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  1018c6:	c9                   	leave  
  1018c7:	c3                   	ret    

001018c8 <trapname>:

static const char *
trapname(int trapno) {
  1018c8:	55                   	push   %ebp
  1018c9:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1018ce:	83 f8 13             	cmp    $0x13,%eax
  1018d1:	77 0c                	ja     1018df <trapname+0x17>
        return excnames[trapno];
  1018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1018d6:	8b 04 85 c0 3a 10 00 	mov    0x103ac0(,%eax,4),%eax
  1018dd:	eb 18                	jmp    1018f7 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1018df:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1018e3:	7e 0d                	jle    1018f2 <trapname+0x2a>
  1018e5:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1018e9:	7f 07                	jg     1018f2 <trapname+0x2a>
        return "Hardware Interrupt";
  1018eb:	b8 6a 37 10 00       	mov    $0x10376a,%eax
  1018f0:	eb 05                	jmp    1018f7 <trapname+0x2f>
    }
    return "(unknown trap)";
  1018f2:	b8 7d 37 10 00       	mov    $0x10377d,%eax
}
  1018f7:	5d                   	pop    %ebp
  1018f8:	c3                   	ret    

001018f9 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1018f9:	55                   	push   %ebp
  1018fa:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1018ff:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101903:	66 83 f8 08          	cmp    $0x8,%ax
  101907:	0f 94 c0             	sete   %al
  10190a:	0f b6 c0             	movzbl %al,%eax
}
  10190d:	5d                   	pop    %ebp
  10190e:	c3                   	ret    

0010190f <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  10190f:	55                   	push   %ebp
  101910:	89 e5                	mov    %esp,%ebp
  101912:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101915:	83 ec 08             	sub    $0x8,%esp
  101918:	ff 75 08             	pushl  0x8(%ebp)
  10191b:	68 be 37 10 00       	push   $0x1037be
  101920:	e8 dc e9 ff ff       	call   100301 <cprintf>
  101925:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101928:	8b 45 08             	mov    0x8(%ebp),%eax
  10192b:	83 ec 0c             	sub    $0xc,%esp
  10192e:	50                   	push   %eax
  10192f:	e8 bb 01 00 00       	call   101aef <print_regs>
  101934:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101937:	8b 45 08             	mov    0x8(%ebp),%eax
  10193a:	66 8b 40 2c          	mov    0x2c(%eax),%ax
  10193e:	0f b7 c0             	movzwl %ax,%eax
  101941:	83 ec 08             	sub    $0x8,%esp
  101944:	50                   	push   %eax
  101945:	68 cf 37 10 00       	push   $0x1037cf
  10194a:	e8 b2 e9 ff ff       	call   100301 <cprintf>
  10194f:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101952:	8b 45 08             	mov    0x8(%ebp),%eax
  101955:	66 8b 40 28          	mov    0x28(%eax),%ax
  101959:	0f b7 c0             	movzwl %ax,%eax
  10195c:	83 ec 08             	sub    $0x8,%esp
  10195f:	50                   	push   %eax
  101960:	68 e2 37 10 00       	push   $0x1037e2
  101965:	e8 97 e9 ff ff       	call   100301 <cprintf>
  10196a:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  10196d:	8b 45 08             	mov    0x8(%ebp),%eax
  101970:	66 8b 40 24          	mov    0x24(%eax),%ax
  101974:	0f b7 c0             	movzwl %ax,%eax
  101977:	83 ec 08             	sub    $0x8,%esp
  10197a:	50                   	push   %eax
  10197b:	68 f5 37 10 00       	push   $0x1037f5
  101980:	e8 7c e9 ff ff       	call   100301 <cprintf>
  101985:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101988:	8b 45 08             	mov    0x8(%ebp),%eax
  10198b:	66 8b 40 20          	mov    0x20(%eax),%ax
  10198f:	0f b7 c0             	movzwl %ax,%eax
  101992:	83 ec 08             	sub    $0x8,%esp
  101995:	50                   	push   %eax
  101996:	68 08 38 10 00       	push   $0x103808
  10199b:	e8 61 e9 ff ff       	call   100301 <cprintf>
  1019a0:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a6:	8b 40 30             	mov    0x30(%eax),%eax
  1019a9:	83 ec 0c             	sub    $0xc,%esp
  1019ac:	50                   	push   %eax
  1019ad:	e8 16 ff ff ff       	call   1018c8 <trapname>
  1019b2:	83 c4 10             	add    $0x10,%esp
  1019b5:	89 c2                	mov    %eax,%edx
  1019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ba:	8b 40 30             	mov    0x30(%eax),%eax
  1019bd:	83 ec 04             	sub    $0x4,%esp
  1019c0:	52                   	push   %edx
  1019c1:	50                   	push   %eax
  1019c2:	68 1b 38 10 00       	push   $0x10381b
  1019c7:	e8 35 e9 ff ff       	call   100301 <cprintf>
  1019cc:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  1019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d2:	8b 40 34             	mov    0x34(%eax),%eax
  1019d5:	83 ec 08             	sub    $0x8,%esp
  1019d8:	50                   	push   %eax
  1019d9:	68 2d 38 10 00       	push   $0x10382d
  1019de:	e8 1e e9 ff ff       	call   100301 <cprintf>
  1019e3:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  1019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e9:	8b 40 38             	mov    0x38(%eax),%eax
  1019ec:	83 ec 08             	sub    $0x8,%esp
  1019ef:	50                   	push   %eax
  1019f0:	68 3c 38 10 00       	push   $0x10383c
  1019f5:	e8 07 e9 ff ff       	call   100301 <cprintf>
  1019fa:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  1019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101a00:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101a04:	0f b7 c0             	movzwl %ax,%eax
  101a07:	83 ec 08             	sub    $0x8,%esp
  101a0a:	50                   	push   %eax
  101a0b:	68 4b 38 10 00       	push   $0x10384b
  101a10:	e8 ec e8 ff ff       	call   100301 <cprintf>
  101a15:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a18:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1b:	8b 40 40             	mov    0x40(%eax),%eax
  101a1e:	83 ec 08             	sub    $0x8,%esp
  101a21:	50                   	push   %eax
  101a22:	68 5e 38 10 00       	push   $0x10385e
  101a27:	e8 d5 e8 ff ff       	call   100301 <cprintf>
  101a2c:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101a36:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101a3d:	eb 43                	jmp    101a82 <print_trapframe+0x173>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a42:	8b 50 40             	mov    0x40(%eax),%edx
  101a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a48:	21 d0                	and    %edx,%eax
  101a4a:	85 c0                	test   %eax,%eax
  101a4c:	74 29                	je     101a77 <print_trapframe+0x168>
  101a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a51:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101a58:	85 c0                	test   %eax,%eax
  101a5a:	74 1b                	je     101a77 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a5f:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101a66:	83 ec 08             	sub    $0x8,%esp
  101a69:	50                   	push   %eax
  101a6a:	68 6d 38 10 00       	push   $0x10386d
  101a6f:	e8 8d e8 ff ff       	call   100301 <cprintf>
  101a74:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a77:	ff 45 f4             	incl   -0xc(%ebp)
  101a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a7d:	01 c0                	add    %eax,%eax
  101a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a85:	83 f8 17             	cmp    $0x17,%eax
  101a88:	76 b5                	jbe    101a3f <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8d:	8b 40 40             	mov    0x40(%eax),%eax
  101a90:	25 00 30 00 00       	and    $0x3000,%eax
  101a95:	c1 e8 0c             	shr    $0xc,%eax
  101a98:	83 ec 08             	sub    $0x8,%esp
  101a9b:	50                   	push   %eax
  101a9c:	68 71 38 10 00       	push   $0x103871
  101aa1:	e8 5b e8 ff ff       	call   100301 <cprintf>
  101aa6:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101aa9:	83 ec 0c             	sub    $0xc,%esp
  101aac:	ff 75 08             	pushl  0x8(%ebp)
  101aaf:	e8 45 fe ff ff       	call   1018f9 <trap_in_kernel>
  101ab4:	83 c4 10             	add    $0x10,%esp
  101ab7:	85 c0                	test   %eax,%eax
  101ab9:	75 32                	jne    101aed <print_trapframe+0x1de>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101abb:	8b 45 08             	mov    0x8(%ebp),%eax
  101abe:	8b 40 44             	mov    0x44(%eax),%eax
  101ac1:	83 ec 08             	sub    $0x8,%esp
  101ac4:	50                   	push   %eax
  101ac5:	68 7a 38 10 00       	push   $0x10387a
  101aca:	e8 32 e8 ff ff       	call   100301 <cprintf>
  101acf:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad5:	66 8b 40 48          	mov    0x48(%eax),%ax
  101ad9:	0f b7 c0             	movzwl %ax,%eax
  101adc:	83 ec 08             	sub    $0x8,%esp
  101adf:	50                   	push   %eax
  101ae0:	68 89 38 10 00       	push   $0x103889
  101ae5:	e8 17 e8 ff ff       	call   100301 <cprintf>
  101aea:	83 c4 10             	add    $0x10,%esp
    }
}
  101aed:	c9                   	leave  
  101aee:	c3                   	ret    

00101aef <print_regs>:

void
print_regs(struct pushregs *regs) {
  101aef:	55                   	push   %ebp
  101af0:	89 e5                	mov    %esp,%ebp
  101af2:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101af5:	8b 45 08             	mov    0x8(%ebp),%eax
  101af8:	8b 00                	mov    (%eax),%eax
  101afa:	83 ec 08             	sub    $0x8,%esp
  101afd:	50                   	push   %eax
  101afe:	68 9c 38 10 00       	push   $0x10389c
  101b03:	e8 f9 e7 ff ff       	call   100301 <cprintf>
  101b08:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0e:	8b 40 04             	mov    0x4(%eax),%eax
  101b11:	83 ec 08             	sub    $0x8,%esp
  101b14:	50                   	push   %eax
  101b15:	68 ab 38 10 00       	push   $0x1038ab
  101b1a:	e8 e2 e7 ff ff       	call   100301 <cprintf>
  101b1f:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b22:	8b 45 08             	mov    0x8(%ebp),%eax
  101b25:	8b 40 08             	mov    0x8(%eax),%eax
  101b28:	83 ec 08             	sub    $0x8,%esp
  101b2b:	50                   	push   %eax
  101b2c:	68 ba 38 10 00       	push   $0x1038ba
  101b31:	e8 cb e7 ff ff       	call   100301 <cprintf>
  101b36:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101b39:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3c:	8b 40 0c             	mov    0xc(%eax),%eax
  101b3f:	83 ec 08             	sub    $0x8,%esp
  101b42:	50                   	push   %eax
  101b43:	68 c9 38 10 00       	push   $0x1038c9
  101b48:	e8 b4 e7 ff ff       	call   100301 <cprintf>
  101b4d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101b50:	8b 45 08             	mov    0x8(%ebp),%eax
  101b53:	8b 40 10             	mov    0x10(%eax),%eax
  101b56:	83 ec 08             	sub    $0x8,%esp
  101b59:	50                   	push   %eax
  101b5a:	68 d8 38 10 00       	push   $0x1038d8
  101b5f:	e8 9d e7 ff ff       	call   100301 <cprintf>
  101b64:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101b67:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6a:	8b 40 14             	mov    0x14(%eax),%eax
  101b6d:	83 ec 08             	sub    $0x8,%esp
  101b70:	50                   	push   %eax
  101b71:	68 e7 38 10 00       	push   $0x1038e7
  101b76:	e8 86 e7 ff ff       	call   100301 <cprintf>
  101b7b:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b81:	8b 40 18             	mov    0x18(%eax),%eax
  101b84:	83 ec 08             	sub    $0x8,%esp
  101b87:	50                   	push   %eax
  101b88:	68 f6 38 10 00       	push   $0x1038f6
  101b8d:	e8 6f e7 ff ff       	call   100301 <cprintf>
  101b92:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101b95:	8b 45 08             	mov    0x8(%ebp),%eax
  101b98:	8b 40 1c             	mov    0x1c(%eax),%eax
  101b9b:	83 ec 08             	sub    $0x8,%esp
  101b9e:	50                   	push   %eax
  101b9f:	68 05 39 10 00       	push   $0x103905
  101ba4:	e8 58 e7 ff ff       	call   100301 <cprintf>
  101ba9:	83 c4 10             	add    $0x10,%esp
}
  101bac:	c9                   	leave  
  101bad:	c3                   	ret    

00101bae <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101bae:	55                   	push   %ebp
  101baf:	89 e5                	mov    %esp,%ebp
  101bb1:	57                   	push   %edi
  101bb2:	56                   	push   %esi
  101bb3:	53                   	push   %ebx
  101bb4:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
  101bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bba:	8b 40 30             	mov    0x30(%eax),%eax
  101bbd:	83 f8 2f             	cmp    $0x2f,%eax
  101bc0:	77 1d                	ja     101bdf <trap_dispatch+0x31>
  101bc2:	83 f8 2e             	cmp    $0x2e,%eax
  101bc5:	0f 83 d1 01 00 00    	jae    101d9c <trap_dispatch+0x1ee>
  101bcb:	83 f8 21             	cmp    $0x21,%eax
  101bce:	74 7e                	je     101c4e <trap_dispatch+0xa0>
  101bd0:	83 f8 24             	cmp    $0x24,%eax
  101bd3:	74 52                	je     101c27 <trap_dispatch+0x79>
  101bd5:	83 f8 20             	cmp    $0x20,%eax
  101bd8:	74 1c                	je     101bf6 <trap_dispatch+0x48>
  101bda:	e9 87 01 00 00       	jmp    101d66 <trap_dispatch+0x1b8>
  101bdf:	83 f8 78             	cmp    $0x78,%eax
  101be2:	0f 84 8d 00 00 00    	je     101c75 <trap_dispatch+0xc7>
  101be8:	83 f8 79             	cmp    $0x79,%eax
  101beb:	0f 84 01 01 00 00    	je     101cf2 <trap_dispatch+0x144>
  101bf1:	e9 70 01 00 00       	jmp    101d66 <trap_dispatch+0x1b8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101bf6:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101bfb:	40                   	inc    %eax
  101bfc:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0) {
  101c01:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c06:	b9 64 00 00 00       	mov    $0x64,%ecx
  101c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  101c10:	f7 f1                	div    %ecx
  101c12:	89 d0                	mov    %edx,%eax
  101c14:	85 c0                	test   %eax,%eax
  101c16:	75 0a                	jne    101c22 <trap_dispatch+0x74>
            print_ticks();
  101c18:	e8 37 fb ff ff       	call   101754 <print_ticks>
        }
        break;
  101c1d:	e9 7b 01 00 00       	jmp    101d9d <trap_dispatch+0x1ef>
  101c22:	e9 76 01 00 00       	jmp    101d9d <trap_dispatch+0x1ef>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c27:	e8 17 f9 ff ff       	call   101543 <cons_getc>
  101c2c:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101c2f:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101c33:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101c37:	83 ec 04             	sub    $0x4,%esp
  101c3a:	52                   	push   %edx
  101c3b:	50                   	push   %eax
  101c3c:	68 14 39 10 00       	push   $0x103914
  101c41:	e8 bb e6 ff ff       	call   100301 <cprintf>
  101c46:	83 c4 10             	add    $0x10,%esp
        break;
  101c49:	e9 4f 01 00 00       	jmp    101d9d <trap_dispatch+0x1ef>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101c4e:	e8 f0 f8 ff ff       	call   101543 <cons_getc>
  101c53:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101c56:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101c5a:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101c5e:	83 ec 04             	sub    $0x4,%esp
  101c61:	52                   	push   %edx
  101c62:	50                   	push   %eax
  101c63:	68 26 39 10 00       	push   $0x103926
  101c68:	e8 94 e6 ff ff       	call   100301 <cprintf>
  101c6d:	83 c4 10             	add    $0x10,%esp
        break;
  101c70:	e9 28 01 00 00       	jmp    101d9d <trap_dispatch+0x1ef>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101c75:	8b 45 08             	mov    0x8(%ebp),%eax
  101c78:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101c7c:	66 83 f8 1b          	cmp    $0x1b,%ax
  101c80:	74 6b                	je     101ced <trap_dispatch+0x13f>
            switchk2u = *tf;
  101c82:	8b 45 08             	mov    0x8(%ebp),%eax
  101c85:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101c8a:	89 c3                	mov    %eax,%ebx
  101c8c:	b8 13 00 00 00       	mov    $0x13,%eax
  101c91:	89 d7                	mov    %edx,%edi
  101c93:	89 de                	mov    %ebx,%esi
  101c95:	89 c1                	mov    %eax,%ecx
  101c97:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101c99:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101ca0:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101ca2:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101ca9:	23 00 
  101cab:	66 a1 68 f9 10 00    	mov    0x10f968,%ax
  101cb1:	66 a3 48 f9 10 00    	mov    %ax,0x10f948
  101cb7:	66 a1 48 f9 10 00    	mov    0x10f948,%ax
  101cbd:	66 a3 4c f9 10 00    	mov    %ax,0x10f94c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc6:	83 c0 44             	add    $0x44,%eax
  101cc9:	a3 64 f9 10 00       	mov    %eax,0x10f964
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101cce:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101cd3:	80 cc 30             	or     $0x30,%ah
  101cd6:	a3 60 f9 10 00       	mov    %eax,0x10f960
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cde:	83 e8 04             	sub    $0x4,%eax
  101ce1:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101ce6:	89 10                	mov    %edx,(%eax)
        }
        break;
  101ce8:	e9 b0 00 00 00       	jmp    101d9d <trap_dispatch+0x1ef>
  101ced:	e9 ab 00 00 00       	jmp    101d9d <trap_dispatch+0x1ef>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf5:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101cf9:	66 83 f8 08          	cmp    $0x8,%ax
  101cfd:	74 65                	je     101d64 <trap_dispatch+0x1b6>
            tf->tf_cs = KERNEL_CS;
  101cff:	8b 45 08             	mov    0x8(%ebp),%eax
  101d02:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101d08:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0b:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101d11:	8b 45 08             	mov    0x8(%ebp),%eax
  101d14:	66 8b 40 28          	mov    0x28(%eax),%ax
  101d18:	8b 55 08             	mov    0x8(%ebp),%edx
  101d1b:	66 89 42 2c          	mov    %ax,0x2c(%edx)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d22:	8b 40 40             	mov    0x40(%eax),%eax
  101d25:	80 e4 cf             	and    $0xcf,%ah
  101d28:	89 c2                	mov    %eax,%edx
  101d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2d:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101d30:	8b 45 08             	mov    0x8(%ebp),%eax
  101d33:	8b 40 44             	mov    0x44(%eax),%eax
  101d36:	83 e8 44             	sub    $0x44,%eax
  101d39:	a3 6c f9 10 00       	mov    %eax,0x10f96c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101d3e:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101d43:	83 ec 04             	sub    $0x4,%esp
  101d46:	6a 44                	push   $0x44
  101d48:	ff 75 08             	pushl  0x8(%ebp)
  101d4b:	50                   	push   %eax
  101d4c:	e8 5d 15 00 00       	call   1032ae <memmove>
  101d51:	83 c4 10             	add    $0x10,%esp
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101d54:	8b 45 08             	mov    0x8(%ebp),%eax
  101d57:	83 e8 04             	sub    $0x4,%eax
  101d5a:	8b 15 6c f9 10 00    	mov    0x10f96c,%edx
  101d60:	89 10                	mov    %edx,(%eax)
        }
        break;
  101d62:	eb 39                	jmp    101d9d <trap_dispatch+0x1ef>
  101d64:	eb 37                	jmp    101d9d <trap_dispatch+0x1ef>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d66:	8b 45 08             	mov    0x8(%ebp),%eax
  101d69:	66 8b 40 3c          	mov    0x3c(%eax),%ax
  101d6d:	0f b7 c0             	movzwl %ax,%eax
  101d70:	83 e0 03             	and    $0x3,%eax
  101d73:	85 c0                	test   %eax,%eax
  101d75:	75 26                	jne    101d9d <trap_dispatch+0x1ef>
            print_trapframe(tf);
  101d77:	83 ec 0c             	sub    $0xc,%esp
  101d7a:	ff 75 08             	pushl  0x8(%ebp)
  101d7d:	e8 8d fb ff ff       	call   10190f <print_trapframe>
  101d82:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101d85:	83 ec 04             	sub    $0x4,%esp
  101d88:	68 35 39 10 00       	push   $0x103935
  101d8d:	68 d2 00 00 00       	push   $0xd2
  101d92:	68 51 39 10 00       	push   $0x103951
  101d97:	e8 c5 ee ff ff       	call   100c61 <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d9c:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101da0:	5b                   	pop    %ebx
  101da1:	5e                   	pop    %esi
  101da2:	5f                   	pop    %edi
  101da3:	5d                   	pop    %ebp
  101da4:	c3                   	ret    

00101da5 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101da5:	55                   	push   %ebp
  101da6:	89 e5                	mov    %esp,%ebp
  101da8:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101dab:	83 ec 0c             	sub    $0xc,%esp
  101dae:	ff 75 08             	pushl  0x8(%ebp)
  101db1:	e8 f8 fd ff ff       	call   101bae <trap_dispatch>
  101db6:	83 c4 10             	add    $0x10,%esp
}
  101db9:	c9                   	leave  
  101dba:	c3                   	ret    

00101dbb <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101dbb:	1e                   	push   %ds
    pushl %es
  101dbc:	06                   	push   %es
    pushl %fs
  101dbd:	0f a0                	push   %fs
    pushl %gs
  101dbf:	0f a8                	push   %gs
    pushal
  101dc1:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101dc2:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101dc7:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101dc9:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101dcb:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101dcc:	e8 d4 ff ff ff       	call   101da5 <trap>

    # pop the pushed stack pointer
    popl %esp
  101dd1:	5c                   	pop    %esp

00101dd2 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101dd2:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101dd3:	0f a9                	pop    %gs
    popl %fs
  101dd5:	0f a1                	pop    %fs
    popl %es
  101dd7:	07                   	pop    %es
    popl %ds
  101dd8:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101dd9:	83 c4 08             	add    $0x8,%esp
    iret
  101ddc:	cf                   	iret   

00101ddd <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ddd:	6a 00                	push   $0x0
  pushl $0
  101ddf:	6a 00                	push   $0x0
  jmp __alltraps
  101de1:	e9 d5 ff ff ff       	jmp    101dbb <__alltraps>

00101de6 <vector1>:
.globl vector1
vector1:
  pushl $0
  101de6:	6a 00                	push   $0x0
  pushl $1
  101de8:	6a 01                	push   $0x1
  jmp __alltraps
  101dea:	e9 cc ff ff ff       	jmp    101dbb <__alltraps>

00101def <vector2>:
.globl vector2
vector2:
  pushl $0
  101def:	6a 00                	push   $0x0
  pushl $2
  101df1:	6a 02                	push   $0x2
  jmp __alltraps
  101df3:	e9 c3 ff ff ff       	jmp    101dbb <__alltraps>

00101df8 <vector3>:
.globl vector3
vector3:
  pushl $0
  101df8:	6a 00                	push   $0x0
  pushl $3
  101dfa:	6a 03                	push   $0x3
  jmp __alltraps
  101dfc:	e9 ba ff ff ff       	jmp    101dbb <__alltraps>

00101e01 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e01:	6a 00                	push   $0x0
  pushl $4
  101e03:	6a 04                	push   $0x4
  jmp __alltraps
  101e05:	e9 b1 ff ff ff       	jmp    101dbb <__alltraps>

00101e0a <vector5>:
.globl vector5
vector5:
  pushl $0
  101e0a:	6a 00                	push   $0x0
  pushl $5
  101e0c:	6a 05                	push   $0x5
  jmp __alltraps
  101e0e:	e9 a8 ff ff ff       	jmp    101dbb <__alltraps>

00101e13 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e13:	6a 00                	push   $0x0
  pushl $6
  101e15:	6a 06                	push   $0x6
  jmp __alltraps
  101e17:	e9 9f ff ff ff       	jmp    101dbb <__alltraps>

00101e1c <vector7>:
.globl vector7
vector7:
  pushl $0
  101e1c:	6a 00                	push   $0x0
  pushl $7
  101e1e:	6a 07                	push   $0x7
  jmp __alltraps
  101e20:	e9 96 ff ff ff       	jmp    101dbb <__alltraps>

00101e25 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e25:	6a 08                	push   $0x8
  jmp __alltraps
  101e27:	e9 8f ff ff ff       	jmp    101dbb <__alltraps>

00101e2c <vector9>:
.globl vector9
vector9:
  pushl $9
  101e2c:	6a 09                	push   $0x9
  jmp __alltraps
  101e2e:	e9 88 ff ff ff       	jmp    101dbb <__alltraps>

00101e33 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e33:	6a 0a                	push   $0xa
  jmp __alltraps
  101e35:	e9 81 ff ff ff       	jmp    101dbb <__alltraps>

00101e3a <vector11>:
.globl vector11
vector11:
  pushl $11
  101e3a:	6a 0b                	push   $0xb
  jmp __alltraps
  101e3c:	e9 7a ff ff ff       	jmp    101dbb <__alltraps>

00101e41 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e41:	6a 0c                	push   $0xc
  jmp __alltraps
  101e43:	e9 73 ff ff ff       	jmp    101dbb <__alltraps>

00101e48 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e48:	6a 0d                	push   $0xd
  jmp __alltraps
  101e4a:	e9 6c ff ff ff       	jmp    101dbb <__alltraps>

00101e4f <vector14>:
.globl vector14
vector14:
  pushl $14
  101e4f:	6a 0e                	push   $0xe
  jmp __alltraps
  101e51:	e9 65 ff ff ff       	jmp    101dbb <__alltraps>

00101e56 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e56:	6a 00                	push   $0x0
  pushl $15
  101e58:	6a 0f                	push   $0xf
  jmp __alltraps
  101e5a:	e9 5c ff ff ff       	jmp    101dbb <__alltraps>

00101e5f <vector16>:
.globl vector16
vector16:
  pushl $0
  101e5f:	6a 00                	push   $0x0
  pushl $16
  101e61:	6a 10                	push   $0x10
  jmp __alltraps
  101e63:	e9 53 ff ff ff       	jmp    101dbb <__alltraps>

00101e68 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e68:	6a 11                	push   $0x11
  jmp __alltraps
  101e6a:	e9 4c ff ff ff       	jmp    101dbb <__alltraps>

00101e6f <vector18>:
.globl vector18
vector18:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $18
  101e71:	6a 12                	push   $0x12
  jmp __alltraps
  101e73:	e9 43 ff ff ff       	jmp    101dbb <__alltraps>

00101e78 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $19
  101e7a:	6a 13                	push   $0x13
  jmp __alltraps
  101e7c:	e9 3a ff ff ff       	jmp    101dbb <__alltraps>

00101e81 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $20
  101e83:	6a 14                	push   $0x14
  jmp __alltraps
  101e85:	e9 31 ff ff ff       	jmp    101dbb <__alltraps>

00101e8a <vector21>:
.globl vector21
vector21:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $21
  101e8c:	6a 15                	push   $0x15
  jmp __alltraps
  101e8e:	e9 28 ff ff ff       	jmp    101dbb <__alltraps>

00101e93 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $22
  101e95:	6a 16                	push   $0x16
  jmp __alltraps
  101e97:	e9 1f ff ff ff       	jmp    101dbb <__alltraps>

00101e9c <vector23>:
.globl vector23
vector23:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $23
  101e9e:	6a 17                	push   $0x17
  jmp __alltraps
  101ea0:	e9 16 ff ff ff       	jmp    101dbb <__alltraps>

00101ea5 <vector24>:
.globl vector24
vector24:
  pushl $0
  101ea5:	6a 00                	push   $0x0
  pushl $24
  101ea7:	6a 18                	push   $0x18
  jmp __alltraps
  101ea9:	e9 0d ff ff ff       	jmp    101dbb <__alltraps>

00101eae <vector25>:
.globl vector25
vector25:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $25
  101eb0:	6a 19                	push   $0x19
  jmp __alltraps
  101eb2:	e9 04 ff ff ff       	jmp    101dbb <__alltraps>

00101eb7 <vector26>:
.globl vector26
vector26:
  pushl $0
  101eb7:	6a 00                	push   $0x0
  pushl $26
  101eb9:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ebb:	e9 fb fe ff ff       	jmp    101dbb <__alltraps>

00101ec0 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $27
  101ec2:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ec4:	e9 f2 fe ff ff       	jmp    101dbb <__alltraps>

00101ec9 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ec9:	6a 00                	push   $0x0
  pushl $28
  101ecb:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ecd:	e9 e9 fe ff ff       	jmp    101dbb <__alltraps>

00101ed2 <vector29>:
.globl vector29
vector29:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $29
  101ed4:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ed6:	e9 e0 fe ff ff       	jmp    101dbb <__alltraps>

00101edb <vector30>:
.globl vector30
vector30:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $30
  101edd:	6a 1e                	push   $0x1e
  jmp __alltraps
  101edf:	e9 d7 fe ff ff       	jmp    101dbb <__alltraps>

00101ee4 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $31
  101ee6:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ee8:	e9 ce fe ff ff       	jmp    101dbb <__alltraps>

00101eed <vector32>:
.globl vector32
vector32:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $32
  101eef:	6a 20                	push   $0x20
  jmp __alltraps
  101ef1:	e9 c5 fe ff ff       	jmp    101dbb <__alltraps>

00101ef6 <vector33>:
.globl vector33
vector33:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $33
  101ef8:	6a 21                	push   $0x21
  jmp __alltraps
  101efa:	e9 bc fe ff ff       	jmp    101dbb <__alltraps>

00101eff <vector34>:
.globl vector34
vector34:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $34
  101f01:	6a 22                	push   $0x22
  jmp __alltraps
  101f03:	e9 b3 fe ff ff       	jmp    101dbb <__alltraps>

00101f08 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $35
  101f0a:	6a 23                	push   $0x23
  jmp __alltraps
  101f0c:	e9 aa fe ff ff       	jmp    101dbb <__alltraps>

00101f11 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $36
  101f13:	6a 24                	push   $0x24
  jmp __alltraps
  101f15:	e9 a1 fe ff ff       	jmp    101dbb <__alltraps>

00101f1a <vector37>:
.globl vector37
vector37:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $37
  101f1c:	6a 25                	push   $0x25
  jmp __alltraps
  101f1e:	e9 98 fe ff ff       	jmp    101dbb <__alltraps>

00101f23 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $38
  101f25:	6a 26                	push   $0x26
  jmp __alltraps
  101f27:	e9 8f fe ff ff       	jmp    101dbb <__alltraps>

00101f2c <vector39>:
.globl vector39
vector39:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $39
  101f2e:	6a 27                	push   $0x27
  jmp __alltraps
  101f30:	e9 86 fe ff ff       	jmp    101dbb <__alltraps>

00101f35 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $40
  101f37:	6a 28                	push   $0x28
  jmp __alltraps
  101f39:	e9 7d fe ff ff       	jmp    101dbb <__alltraps>

00101f3e <vector41>:
.globl vector41
vector41:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $41
  101f40:	6a 29                	push   $0x29
  jmp __alltraps
  101f42:	e9 74 fe ff ff       	jmp    101dbb <__alltraps>

00101f47 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $42
  101f49:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f4b:	e9 6b fe ff ff       	jmp    101dbb <__alltraps>

00101f50 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $43
  101f52:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f54:	e9 62 fe ff ff       	jmp    101dbb <__alltraps>

00101f59 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $44
  101f5b:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f5d:	e9 59 fe ff ff       	jmp    101dbb <__alltraps>

00101f62 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $45
  101f64:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f66:	e9 50 fe ff ff       	jmp    101dbb <__alltraps>

00101f6b <vector46>:
.globl vector46
vector46:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $46
  101f6d:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f6f:	e9 47 fe ff ff       	jmp    101dbb <__alltraps>

00101f74 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $47
  101f76:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f78:	e9 3e fe ff ff       	jmp    101dbb <__alltraps>

00101f7d <vector48>:
.globl vector48
vector48:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $48
  101f7f:	6a 30                	push   $0x30
  jmp __alltraps
  101f81:	e9 35 fe ff ff       	jmp    101dbb <__alltraps>

00101f86 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $49
  101f88:	6a 31                	push   $0x31
  jmp __alltraps
  101f8a:	e9 2c fe ff ff       	jmp    101dbb <__alltraps>

00101f8f <vector50>:
.globl vector50
vector50:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $50
  101f91:	6a 32                	push   $0x32
  jmp __alltraps
  101f93:	e9 23 fe ff ff       	jmp    101dbb <__alltraps>

00101f98 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $51
  101f9a:	6a 33                	push   $0x33
  jmp __alltraps
  101f9c:	e9 1a fe ff ff       	jmp    101dbb <__alltraps>

00101fa1 <vector52>:
.globl vector52
vector52:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $52
  101fa3:	6a 34                	push   $0x34
  jmp __alltraps
  101fa5:	e9 11 fe ff ff       	jmp    101dbb <__alltraps>

00101faa <vector53>:
.globl vector53
vector53:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $53
  101fac:	6a 35                	push   $0x35
  jmp __alltraps
  101fae:	e9 08 fe ff ff       	jmp    101dbb <__alltraps>

00101fb3 <vector54>:
.globl vector54
vector54:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $54
  101fb5:	6a 36                	push   $0x36
  jmp __alltraps
  101fb7:	e9 ff fd ff ff       	jmp    101dbb <__alltraps>

00101fbc <vector55>:
.globl vector55
vector55:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $55
  101fbe:	6a 37                	push   $0x37
  jmp __alltraps
  101fc0:	e9 f6 fd ff ff       	jmp    101dbb <__alltraps>

00101fc5 <vector56>:
.globl vector56
vector56:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $56
  101fc7:	6a 38                	push   $0x38
  jmp __alltraps
  101fc9:	e9 ed fd ff ff       	jmp    101dbb <__alltraps>

00101fce <vector57>:
.globl vector57
vector57:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $57
  101fd0:	6a 39                	push   $0x39
  jmp __alltraps
  101fd2:	e9 e4 fd ff ff       	jmp    101dbb <__alltraps>

00101fd7 <vector58>:
.globl vector58
vector58:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $58
  101fd9:	6a 3a                	push   $0x3a
  jmp __alltraps
  101fdb:	e9 db fd ff ff       	jmp    101dbb <__alltraps>

00101fe0 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $59
  101fe2:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fe4:	e9 d2 fd ff ff       	jmp    101dbb <__alltraps>

00101fe9 <vector60>:
.globl vector60
vector60:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $60
  101feb:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fed:	e9 c9 fd ff ff       	jmp    101dbb <__alltraps>

00101ff2 <vector61>:
.globl vector61
vector61:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $61
  101ff4:	6a 3d                	push   $0x3d
  jmp __alltraps
  101ff6:	e9 c0 fd ff ff       	jmp    101dbb <__alltraps>

00101ffb <vector62>:
.globl vector62
vector62:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $62
  101ffd:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fff:	e9 b7 fd ff ff       	jmp    101dbb <__alltraps>

00102004 <vector63>:
.globl vector63
vector63:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $63
  102006:	6a 3f                	push   $0x3f
  jmp __alltraps
  102008:	e9 ae fd ff ff       	jmp    101dbb <__alltraps>

0010200d <vector64>:
.globl vector64
vector64:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $64
  10200f:	6a 40                	push   $0x40
  jmp __alltraps
  102011:	e9 a5 fd ff ff       	jmp    101dbb <__alltraps>

00102016 <vector65>:
.globl vector65
vector65:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $65
  102018:	6a 41                	push   $0x41
  jmp __alltraps
  10201a:	e9 9c fd ff ff       	jmp    101dbb <__alltraps>

0010201f <vector66>:
.globl vector66
vector66:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $66
  102021:	6a 42                	push   $0x42
  jmp __alltraps
  102023:	e9 93 fd ff ff       	jmp    101dbb <__alltraps>

00102028 <vector67>:
.globl vector67
vector67:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $67
  10202a:	6a 43                	push   $0x43
  jmp __alltraps
  10202c:	e9 8a fd ff ff       	jmp    101dbb <__alltraps>

00102031 <vector68>:
.globl vector68
vector68:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $68
  102033:	6a 44                	push   $0x44
  jmp __alltraps
  102035:	e9 81 fd ff ff       	jmp    101dbb <__alltraps>

0010203a <vector69>:
.globl vector69
vector69:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $69
  10203c:	6a 45                	push   $0x45
  jmp __alltraps
  10203e:	e9 78 fd ff ff       	jmp    101dbb <__alltraps>

00102043 <vector70>:
.globl vector70
vector70:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $70
  102045:	6a 46                	push   $0x46
  jmp __alltraps
  102047:	e9 6f fd ff ff       	jmp    101dbb <__alltraps>

0010204c <vector71>:
.globl vector71
vector71:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $71
  10204e:	6a 47                	push   $0x47
  jmp __alltraps
  102050:	e9 66 fd ff ff       	jmp    101dbb <__alltraps>

00102055 <vector72>:
.globl vector72
vector72:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $72
  102057:	6a 48                	push   $0x48
  jmp __alltraps
  102059:	e9 5d fd ff ff       	jmp    101dbb <__alltraps>

0010205e <vector73>:
.globl vector73
vector73:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $73
  102060:	6a 49                	push   $0x49
  jmp __alltraps
  102062:	e9 54 fd ff ff       	jmp    101dbb <__alltraps>

00102067 <vector74>:
.globl vector74
vector74:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $74
  102069:	6a 4a                	push   $0x4a
  jmp __alltraps
  10206b:	e9 4b fd ff ff       	jmp    101dbb <__alltraps>

00102070 <vector75>:
.globl vector75
vector75:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $75
  102072:	6a 4b                	push   $0x4b
  jmp __alltraps
  102074:	e9 42 fd ff ff       	jmp    101dbb <__alltraps>

00102079 <vector76>:
.globl vector76
vector76:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $76
  10207b:	6a 4c                	push   $0x4c
  jmp __alltraps
  10207d:	e9 39 fd ff ff       	jmp    101dbb <__alltraps>

00102082 <vector77>:
.globl vector77
vector77:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $77
  102084:	6a 4d                	push   $0x4d
  jmp __alltraps
  102086:	e9 30 fd ff ff       	jmp    101dbb <__alltraps>

0010208b <vector78>:
.globl vector78
vector78:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $78
  10208d:	6a 4e                	push   $0x4e
  jmp __alltraps
  10208f:	e9 27 fd ff ff       	jmp    101dbb <__alltraps>

00102094 <vector79>:
.globl vector79
vector79:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $79
  102096:	6a 4f                	push   $0x4f
  jmp __alltraps
  102098:	e9 1e fd ff ff       	jmp    101dbb <__alltraps>

0010209d <vector80>:
.globl vector80
vector80:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $80
  10209f:	6a 50                	push   $0x50
  jmp __alltraps
  1020a1:	e9 15 fd ff ff       	jmp    101dbb <__alltraps>

001020a6 <vector81>:
.globl vector81
vector81:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $81
  1020a8:	6a 51                	push   $0x51
  jmp __alltraps
  1020aa:	e9 0c fd ff ff       	jmp    101dbb <__alltraps>

001020af <vector82>:
.globl vector82
vector82:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $82
  1020b1:	6a 52                	push   $0x52
  jmp __alltraps
  1020b3:	e9 03 fd ff ff       	jmp    101dbb <__alltraps>

001020b8 <vector83>:
.globl vector83
vector83:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $83
  1020ba:	6a 53                	push   $0x53
  jmp __alltraps
  1020bc:	e9 fa fc ff ff       	jmp    101dbb <__alltraps>

001020c1 <vector84>:
.globl vector84
vector84:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $84
  1020c3:	6a 54                	push   $0x54
  jmp __alltraps
  1020c5:	e9 f1 fc ff ff       	jmp    101dbb <__alltraps>

001020ca <vector85>:
.globl vector85
vector85:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $85
  1020cc:	6a 55                	push   $0x55
  jmp __alltraps
  1020ce:	e9 e8 fc ff ff       	jmp    101dbb <__alltraps>

001020d3 <vector86>:
.globl vector86
vector86:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $86
  1020d5:	6a 56                	push   $0x56
  jmp __alltraps
  1020d7:	e9 df fc ff ff       	jmp    101dbb <__alltraps>

001020dc <vector87>:
.globl vector87
vector87:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $87
  1020de:	6a 57                	push   $0x57
  jmp __alltraps
  1020e0:	e9 d6 fc ff ff       	jmp    101dbb <__alltraps>

001020e5 <vector88>:
.globl vector88
vector88:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $88
  1020e7:	6a 58                	push   $0x58
  jmp __alltraps
  1020e9:	e9 cd fc ff ff       	jmp    101dbb <__alltraps>

001020ee <vector89>:
.globl vector89
vector89:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $89
  1020f0:	6a 59                	push   $0x59
  jmp __alltraps
  1020f2:	e9 c4 fc ff ff       	jmp    101dbb <__alltraps>

001020f7 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $90
  1020f9:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020fb:	e9 bb fc ff ff       	jmp    101dbb <__alltraps>

00102100 <vector91>:
.globl vector91
vector91:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $91
  102102:	6a 5b                	push   $0x5b
  jmp __alltraps
  102104:	e9 b2 fc ff ff       	jmp    101dbb <__alltraps>

00102109 <vector92>:
.globl vector92
vector92:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $92
  10210b:	6a 5c                	push   $0x5c
  jmp __alltraps
  10210d:	e9 a9 fc ff ff       	jmp    101dbb <__alltraps>

00102112 <vector93>:
.globl vector93
vector93:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $93
  102114:	6a 5d                	push   $0x5d
  jmp __alltraps
  102116:	e9 a0 fc ff ff       	jmp    101dbb <__alltraps>

0010211b <vector94>:
.globl vector94
vector94:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $94
  10211d:	6a 5e                	push   $0x5e
  jmp __alltraps
  10211f:	e9 97 fc ff ff       	jmp    101dbb <__alltraps>

00102124 <vector95>:
.globl vector95
vector95:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $95
  102126:	6a 5f                	push   $0x5f
  jmp __alltraps
  102128:	e9 8e fc ff ff       	jmp    101dbb <__alltraps>

0010212d <vector96>:
.globl vector96
vector96:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $96
  10212f:	6a 60                	push   $0x60
  jmp __alltraps
  102131:	e9 85 fc ff ff       	jmp    101dbb <__alltraps>

00102136 <vector97>:
.globl vector97
vector97:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $97
  102138:	6a 61                	push   $0x61
  jmp __alltraps
  10213a:	e9 7c fc ff ff       	jmp    101dbb <__alltraps>

0010213f <vector98>:
.globl vector98
vector98:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $98
  102141:	6a 62                	push   $0x62
  jmp __alltraps
  102143:	e9 73 fc ff ff       	jmp    101dbb <__alltraps>

00102148 <vector99>:
.globl vector99
vector99:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $99
  10214a:	6a 63                	push   $0x63
  jmp __alltraps
  10214c:	e9 6a fc ff ff       	jmp    101dbb <__alltraps>

00102151 <vector100>:
.globl vector100
vector100:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $100
  102153:	6a 64                	push   $0x64
  jmp __alltraps
  102155:	e9 61 fc ff ff       	jmp    101dbb <__alltraps>

0010215a <vector101>:
.globl vector101
vector101:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $101
  10215c:	6a 65                	push   $0x65
  jmp __alltraps
  10215e:	e9 58 fc ff ff       	jmp    101dbb <__alltraps>

00102163 <vector102>:
.globl vector102
vector102:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $102
  102165:	6a 66                	push   $0x66
  jmp __alltraps
  102167:	e9 4f fc ff ff       	jmp    101dbb <__alltraps>

0010216c <vector103>:
.globl vector103
vector103:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $103
  10216e:	6a 67                	push   $0x67
  jmp __alltraps
  102170:	e9 46 fc ff ff       	jmp    101dbb <__alltraps>

00102175 <vector104>:
.globl vector104
vector104:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $104
  102177:	6a 68                	push   $0x68
  jmp __alltraps
  102179:	e9 3d fc ff ff       	jmp    101dbb <__alltraps>

0010217e <vector105>:
.globl vector105
vector105:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $105
  102180:	6a 69                	push   $0x69
  jmp __alltraps
  102182:	e9 34 fc ff ff       	jmp    101dbb <__alltraps>

00102187 <vector106>:
.globl vector106
vector106:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $106
  102189:	6a 6a                	push   $0x6a
  jmp __alltraps
  10218b:	e9 2b fc ff ff       	jmp    101dbb <__alltraps>

00102190 <vector107>:
.globl vector107
vector107:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $107
  102192:	6a 6b                	push   $0x6b
  jmp __alltraps
  102194:	e9 22 fc ff ff       	jmp    101dbb <__alltraps>

00102199 <vector108>:
.globl vector108
vector108:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $108
  10219b:	6a 6c                	push   $0x6c
  jmp __alltraps
  10219d:	e9 19 fc ff ff       	jmp    101dbb <__alltraps>

001021a2 <vector109>:
.globl vector109
vector109:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $109
  1021a4:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021a6:	e9 10 fc ff ff       	jmp    101dbb <__alltraps>

001021ab <vector110>:
.globl vector110
vector110:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $110
  1021ad:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021af:	e9 07 fc ff ff       	jmp    101dbb <__alltraps>

001021b4 <vector111>:
.globl vector111
vector111:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $111
  1021b6:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021b8:	e9 fe fb ff ff       	jmp    101dbb <__alltraps>

001021bd <vector112>:
.globl vector112
vector112:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $112
  1021bf:	6a 70                	push   $0x70
  jmp __alltraps
  1021c1:	e9 f5 fb ff ff       	jmp    101dbb <__alltraps>

001021c6 <vector113>:
.globl vector113
vector113:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $113
  1021c8:	6a 71                	push   $0x71
  jmp __alltraps
  1021ca:	e9 ec fb ff ff       	jmp    101dbb <__alltraps>

001021cf <vector114>:
.globl vector114
vector114:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $114
  1021d1:	6a 72                	push   $0x72
  jmp __alltraps
  1021d3:	e9 e3 fb ff ff       	jmp    101dbb <__alltraps>

001021d8 <vector115>:
.globl vector115
vector115:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $115
  1021da:	6a 73                	push   $0x73
  jmp __alltraps
  1021dc:	e9 da fb ff ff       	jmp    101dbb <__alltraps>

001021e1 <vector116>:
.globl vector116
vector116:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $116
  1021e3:	6a 74                	push   $0x74
  jmp __alltraps
  1021e5:	e9 d1 fb ff ff       	jmp    101dbb <__alltraps>

001021ea <vector117>:
.globl vector117
vector117:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $117
  1021ec:	6a 75                	push   $0x75
  jmp __alltraps
  1021ee:	e9 c8 fb ff ff       	jmp    101dbb <__alltraps>

001021f3 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $118
  1021f5:	6a 76                	push   $0x76
  jmp __alltraps
  1021f7:	e9 bf fb ff ff       	jmp    101dbb <__alltraps>

001021fc <vector119>:
.globl vector119
vector119:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $119
  1021fe:	6a 77                	push   $0x77
  jmp __alltraps
  102200:	e9 b6 fb ff ff       	jmp    101dbb <__alltraps>

00102205 <vector120>:
.globl vector120
vector120:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $120
  102207:	6a 78                	push   $0x78
  jmp __alltraps
  102209:	e9 ad fb ff ff       	jmp    101dbb <__alltraps>

0010220e <vector121>:
.globl vector121
vector121:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $121
  102210:	6a 79                	push   $0x79
  jmp __alltraps
  102212:	e9 a4 fb ff ff       	jmp    101dbb <__alltraps>

00102217 <vector122>:
.globl vector122
vector122:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $122
  102219:	6a 7a                	push   $0x7a
  jmp __alltraps
  10221b:	e9 9b fb ff ff       	jmp    101dbb <__alltraps>

00102220 <vector123>:
.globl vector123
vector123:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $123
  102222:	6a 7b                	push   $0x7b
  jmp __alltraps
  102224:	e9 92 fb ff ff       	jmp    101dbb <__alltraps>

00102229 <vector124>:
.globl vector124
vector124:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $124
  10222b:	6a 7c                	push   $0x7c
  jmp __alltraps
  10222d:	e9 89 fb ff ff       	jmp    101dbb <__alltraps>

00102232 <vector125>:
.globl vector125
vector125:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $125
  102234:	6a 7d                	push   $0x7d
  jmp __alltraps
  102236:	e9 80 fb ff ff       	jmp    101dbb <__alltraps>

0010223b <vector126>:
.globl vector126
vector126:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $126
  10223d:	6a 7e                	push   $0x7e
  jmp __alltraps
  10223f:	e9 77 fb ff ff       	jmp    101dbb <__alltraps>

00102244 <vector127>:
.globl vector127
vector127:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $127
  102246:	6a 7f                	push   $0x7f
  jmp __alltraps
  102248:	e9 6e fb ff ff       	jmp    101dbb <__alltraps>

0010224d <vector128>:
.globl vector128
vector128:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $128
  10224f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102254:	e9 62 fb ff ff       	jmp    101dbb <__alltraps>

00102259 <vector129>:
.globl vector129
vector129:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $129
  10225b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102260:	e9 56 fb ff ff       	jmp    101dbb <__alltraps>

00102265 <vector130>:
.globl vector130
vector130:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $130
  102267:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10226c:	e9 4a fb ff ff       	jmp    101dbb <__alltraps>

00102271 <vector131>:
.globl vector131
vector131:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $131
  102273:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102278:	e9 3e fb ff ff       	jmp    101dbb <__alltraps>

0010227d <vector132>:
.globl vector132
vector132:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $132
  10227f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102284:	e9 32 fb ff ff       	jmp    101dbb <__alltraps>

00102289 <vector133>:
.globl vector133
vector133:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $133
  10228b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102290:	e9 26 fb ff ff       	jmp    101dbb <__alltraps>

00102295 <vector134>:
.globl vector134
vector134:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $134
  102297:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10229c:	e9 1a fb ff ff       	jmp    101dbb <__alltraps>

001022a1 <vector135>:
.globl vector135
vector135:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $135
  1022a3:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022a8:	e9 0e fb ff ff       	jmp    101dbb <__alltraps>

001022ad <vector136>:
.globl vector136
vector136:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $136
  1022af:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022b4:	e9 02 fb ff ff       	jmp    101dbb <__alltraps>

001022b9 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $137
  1022bb:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022c0:	e9 f6 fa ff ff       	jmp    101dbb <__alltraps>

001022c5 <vector138>:
.globl vector138
vector138:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $138
  1022c7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022cc:	e9 ea fa ff ff       	jmp    101dbb <__alltraps>

001022d1 <vector139>:
.globl vector139
vector139:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $139
  1022d3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022d8:	e9 de fa ff ff       	jmp    101dbb <__alltraps>

001022dd <vector140>:
.globl vector140
vector140:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $140
  1022df:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022e4:	e9 d2 fa ff ff       	jmp    101dbb <__alltraps>

001022e9 <vector141>:
.globl vector141
vector141:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $141
  1022eb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022f0:	e9 c6 fa ff ff       	jmp    101dbb <__alltraps>

001022f5 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $142
  1022f7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022fc:	e9 ba fa ff ff       	jmp    101dbb <__alltraps>

00102301 <vector143>:
.globl vector143
vector143:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $143
  102303:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102308:	e9 ae fa ff ff       	jmp    101dbb <__alltraps>

0010230d <vector144>:
.globl vector144
vector144:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $144
  10230f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102314:	e9 a2 fa ff ff       	jmp    101dbb <__alltraps>

00102319 <vector145>:
.globl vector145
vector145:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $145
  10231b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102320:	e9 96 fa ff ff       	jmp    101dbb <__alltraps>

00102325 <vector146>:
.globl vector146
vector146:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $146
  102327:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10232c:	e9 8a fa ff ff       	jmp    101dbb <__alltraps>

00102331 <vector147>:
.globl vector147
vector147:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $147
  102333:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102338:	e9 7e fa ff ff       	jmp    101dbb <__alltraps>

0010233d <vector148>:
.globl vector148
vector148:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $148
  10233f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102344:	e9 72 fa ff ff       	jmp    101dbb <__alltraps>

00102349 <vector149>:
.globl vector149
vector149:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $149
  10234b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102350:	e9 66 fa ff ff       	jmp    101dbb <__alltraps>

00102355 <vector150>:
.globl vector150
vector150:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $150
  102357:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10235c:	e9 5a fa ff ff       	jmp    101dbb <__alltraps>

00102361 <vector151>:
.globl vector151
vector151:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $151
  102363:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102368:	e9 4e fa ff ff       	jmp    101dbb <__alltraps>

0010236d <vector152>:
.globl vector152
vector152:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $152
  10236f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102374:	e9 42 fa ff ff       	jmp    101dbb <__alltraps>

00102379 <vector153>:
.globl vector153
vector153:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $153
  10237b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102380:	e9 36 fa ff ff       	jmp    101dbb <__alltraps>

00102385 <vector154>:
.globl vector154
vector154:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $154
  102387:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10238c:	e9 2a fa ff ff       	jmp    101dbb <__alltraps>

00102391 <vector155>:
.globl vector155
vector155:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $155
  102393:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102398:	e9 1e fa ff ff       	jmp    101dbb <__alltraps>

0010239d <vector156>:
.globl vector156
vector156:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $156
  10239f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023a4:	e9 12 fa ff ff       	jmp    101dbb <__alltraps>

001023a9 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $157
  1023ab:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023b0:	e9 06 fa ff ff       	jmp    101dbb <__alltraps>

001023b5 <vector158>:
.globl vector158
vector158:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $158
  1023b7:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023bc:	e9 fa f9 ff ff       	jmp    101dbb <__alltraps>

001023c1 <vector159>:
.globl vector159
vector159:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $159
  1023c3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023c8:	e9 ee f9 ff ff       	jmp    101dbb <__alltraps>

001023cd <vector160>:
.globl vector160
vector160:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $160
  1023cf:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023d4:	e9 e2 f9 ff ff       	jmp    101dbb <__alltraps>

001023d9 <vector161>:
.globl vector161
vector161:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $161
  1023db:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023e0:	e9 d6 f9 ff ff       	jmp    101dbb <__alltraps>

001023e5 <vector162>:
.globl vector162
vector162:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $162
  1023e7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023ec:	e9 ca f9 ff ff       	jmp    101dbb <__alltraps>

001023f1 <vector163>:
.globl vector163
vector163:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $163
  1023f3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023f8:	e9 be f9 ff ff       	jmp    101dbb <__alltraps>

001023fd <vector164>:
.globl vector164
vector164:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $164
  1023ff:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102404:	e9 b2 f9 ff ff       	jmp    101dbb <__alltraps>

00102409 <vector165>:
.globl vector165
vector165:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $165
  10240b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102410:	e9 a6 f9 ff ff       	jmp    101dbb <__alltraps>

00102415 <vector166>:
.globl vector166
vector166:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $166
  102417:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10241c:	e9 9a f9 ff ff       	jmp    101dbb <__alltraps>

00102421 <vector167>:
.globl vector167
vector167:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $167
  102423:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102428:	e9 8e f9 ff ff       	jmp    101dbb <__alltraps>

0010242d <vector168>:
.globl vector168
vector168:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $168
  10242f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102434:	e9 82 f9 ff ff       	jmp    101dbb <__alltraps>

00102439 <vector169>:
.globl vector169
vector169:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $169
  10243b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102440:	e9 76 f9 ff ff       	jmp    101dbb <__alltraps>

00102445 <vector170>:
.globl vector170
vector170:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $170
  102447:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10244c:	e9 6a f9 ff ff       	jmp    101dbb <__alltraps>

00102451 <vector171>:
.globl vector171
vector171:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $171
  102453:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102458:	e9 5e f9 ff ff       	jmp    101dbb <__alltraps>

0010245d <vector172>:
.globl vector172
vector172:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $172
  10245f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102464:	e9 52 f9 ff ff       	jmp    101dbb <__alltraps>

00102469 <vector173>:
.globl vector173
vector173:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $173
  10246b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102470:	e9 46 f9 ff ff       	jmp    101dbb <__alltraps>

00102475 <vector174>:
.globl vector174
vector174:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $174
  102477:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10247c:	e9 3a f9 ff ff       	jmp    101dbb <__alltraps>

00102481 <vector175>:
.globl vector175
vector175:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $175
  102483:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102488:	e9 2e f9 ff ff       	jmp    101dbb <__alltraps>

0010248d <vector176>:
.globl vector176
vector176:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $176
  10248f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102494:	e9 22 f9 ff ff       	jmp    101dbb <__alltraps>

00102499 <vector177>:
.globl vector177
vector177:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $177
  10249b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024a0:	e9 16 f9 ff ff       	jmp    101dbb <__alltraps>

001024a5 <vector178>:
.globl vector178
vector178:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $178
  1024a7:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024ac:	e9 0a f9 ff ff       	jmp    101dbb <__alltraps>

001024b1 <vector179>:
.globl vector179
vector179:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $179
  1024b3:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024b8:	e9 fe f8 ff ff       	jmp    101dbb <__alltraps>

001024bd <vector180>:
.globl vector180
vector180:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $180
  1024bf:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024c4:	e9 f2 f8 ff ff       	jmp    101dbb <__alltraps>

001024c9 <vector181>:
.globl vector181
vector181:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $181
  1024cb:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024d0:	e9 e6 f8 ff ff       	jmp    101dbb <__alltraps>

001024d5 <vector182>:
.globl vector182
vector182:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $182
  1024d7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024dc:	e9 da f8 ff ff       	jmp    101dbb <__alltraps>

001024e1 <vector183>:
.globl vector183
vector183:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $183
  1024e3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024e8:	e9 ce f8 ff ff       	jmp    101dbb <__alltraps>

001024ed <vector184>:
.globl vector184
vector184:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $184
  1024ef:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024f4:	e9 c2 f8 ff ff       	jmp    101dbb <__alltraps>

001024f9 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $185
  1024fb:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102500:	e9 b6 f8 ff ff       	jmp    101dbb <__alltraps>

00102505 <vector186>:
.globl vector186
vector186:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $186
  102507:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10250c:	e9 aa f8 ff ff       	jmp    101dbb <__alltraps>

00102511 <vector187>:
.globl vector187
vector187:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $187
  102513:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102518:	e9 9e f8 ff ff       	jmp    101dbb <__alltraps>

0010251d <vector188>:
.globl vector188
vector188:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $188
  10251f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102524:	e9 92 f8 ff ff       	jmp    101dbb <__alltraps>

00102529 <vector189>:
.globl vector189
vector189:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $189
  10252b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102530:	e9 86 f8 ff ff       	jmp    101dbb <__alltraps>

00102535 <vector190>:
.globl vector190
vector190:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $190
  102537:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10253c:	e9 7a f8 ff ff       	jmp    101dbb <__alltraps>

00102541 <vector191>:
.globl vector191
vector191:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $191
  102543:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102548:	e9 6e f8 ff ff       	jmp    101dbb <__alltraps>

0010254d <vector192>:
.globl vector192
vector192:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $192
  10254f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102554:	e9 62 f8 ff ff       	jmp    101dbb <__alltraps>

00102559 <vector193>:
.globl vector193
vector193:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $193
  10255b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102560:	e9 56 f8 ff ff       	jmp    101dbb <__alltraps>

00102565 <vector194>:
.globl vector194
vector194:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $194
  102567:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10256c:	e9 4a f8 ff ff       	jmp    101dbb <__alltraps>

00102571 <vector195>:
.globl vector195
vector195:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $195
  102573:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102578:	e9 3e f8 ff ff       	jmp    101dbb <__alltraps>

0010257d <vector196>:
.globl vector196
vector196:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $196
  10257f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102584:	e9 32 f8 ff ff       	jmp    101dbb <__alltraps>

00102589 <vector197>:
.globl vector197
vector197:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $197
  10258b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102590:	e9 26 f8 ff ff       	jmp    101dbb <__alltraps>

00102595 <vector198>:
.globl vector198
vector198:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $198
  102597:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10259c:	e9 1a f8 ff ff       	jmp    101dbb <__alltraps>

001025a1 <vector199>:
.globl vector199
vector199:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $199
  1025a3:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025a8:	e9 0e f8 ff ff       	jmp    101dbb <__alltraps>

001025ad <vector200>:
.globl vector200
vector200:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $200
  1025af:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025b4:	e9 02 f8 ff ff       	jmp    101dbb <__alltraps>

001025b9 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $201
  1025bb:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025c0:	e9 f6 f7 ff ff       	jmp    101dbb <__alltraps>

001025c5 <vector202>:
.globl vector202
vector202:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $202
  1025c7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025cc:	e9 ea f7 ff ff       	jmp    101dbb <__alltraps>

001025d1 <vector203>:
.globl vector203
vector203:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $203
  1025d3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025d8:	e9 de f7 ff ff       	jmp    101dbb <__alltraps>

001025dd <vector204>:
.globl vector204
vector204:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $204
  1025df:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025e4:	e9 d2 f7 ff ff       	jmp    101dbb <__alltraps>

001025e9 <vector205>:
.globl vector205
vector205:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $205
  1025eb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025f0:	e9 c6 f7 ff ff       	jmp    101dbb <__alltraps>

001025f5 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $206
  1025f7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025fc:	e9 ba f7 ff ff       	jmp    101dbb <__alltraps>

00102601 <vector207>:
.globl vector207
vector207:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $207
  102603:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102608:	e9 ae f7 ff ff       	jmp    101dbb <__alltraps>

0010260d <vector208>:
.globl vector208
vector208:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $208
  10260f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102614:	e9 a2 f7 ff ff       	jmp    101dbb <__alltraps>

00102619 <vector209>:
.globl vector209
vector209:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $209
  10261b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102620:	e9 96 f7 ff ff       	jmp    101dbb <__alltraps>

00102625 <vector210>:
.globl vector210
vector210:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $210
  102627:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10262c:	e9 8a f7 ff ff       	jmp    101dbb <__alltraps>

00102631 <vector211>:
.globl vector211
vector211:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $211
  102633:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102638:	e9 7e f7 ff ff       	jmp    101dbb <__alltraps>

0010263d <vector212>:
.globl vector212
vector212:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $212
  10263f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102644:	e9 72 f7 ff ff       	jmp    101dbb <__alltraps>

00102649 <vector213>:
.globl vector213
vector213:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $213
  10264b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102650:	e9 66 f7 ff ff       	jmp    101dbb <__alltraps>

00102655 <vector214>:
.globl vector214
vector214:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $214
  102657:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10265c:	e9 5a f7 ff ff       	jmp    101dbb <__alltraps>

00102661 <vector215>:
.globl vector215
vector215:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $215
  102663:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102668:	e9 4e f7 ff ff       	jmp    101dbb <__alltraps>

0010266d <vector216>:
.globl vector216
vector216:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $216
  10266f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102674:	e9 42 f7 ff ff       	jmp    101dbb <__alltraps>

00102679 <vector217>:
.globl vector217
vector217:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $217
  10267b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102680:	e9 36 f7 ff ff       	jmp    101dbb <__alltraps>

00102685 <vector218>:
.globl vector218
vector218:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $218
  102687:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10268c:	e9 2a f7 ff ff       	jmp    101dbb <__alltraps>

00102691 <vector219>:
.globl vector219
vector219:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $219
  102693:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102698:	e9 1e f7 ff ff       	jmp    101dbb <__alltraps>

0010269d <vector220>:
.globl vector220
vector220:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $220
  10269f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026a4:	e9 12 f7 ff ff       	jmp    101dbb <__alltraps>

001026a9 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $221
  1026ab:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026b0:	e9 06 f7 ff ff       	jmp    101dbb <__alltraps>

001026b5 <vector222>:
.globl vector222
vector222:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $222
  1026b7:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026bc:	e9 fa f6 ff ff       	jmp    101dbb <__alltraps>

001026c1 <vector223>:
.globl vector223
vector223:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $223
  1026c3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026c8:	e9 ee f6 ff ff       	jmp    101dbb <__alltraps>

001026cd <vector224>:
.globl vector224
vector224:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $224
  1026cf:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026d4:	e9 e2 f6 ff ff       	jmp    101dbb <__alltraps>

001026d9 <vector225>:
.globl vector225
vector225:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $225
  1026db:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026e0:	e9 d6 f6 ff ff       	jmp    101dbb <__alltraps>

001026e5 <vector226>:
.globl vector226
vector226:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $226
  1026e7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026ec:	e9 ca f6 ff ff       	jmp    101dbb <__alltraps>

001026f1 <vector227>:
.globl vector227
vector227:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $227
  1026f3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026f8:	e9 be f6 ff ff       	jmp    101dbb <__alltraps>

001026fd <vector228>:
.globl vector228
vector228:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $228
  1026ff:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102704:	e9 b2 f6 ff ff       	jmp    101dbb <__alltraps>

00102709 <vector229>:
.globl vector229
vector229:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $229
  10270b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102710:	e9 a6 f6 ff ff       	jmp    101dbb <__alltraps>

00102715 <vector230>:
.globl vector230
vector230:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $230
  102717:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10271c:	e9 9a f6 ff ff       	jmp    101dbb <__alltraps>

00102721 <vector231>:
.globl vector231
vector231:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $231
  102723:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102728:	e9 8e f6 ff ff       	jmp    101dbb <__alltraps>

0010272d <vector232>:
.globl vector232
vector232:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $232
  10272f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102734:	e9 82 f6 ff ff       	jmp    101dbb <__alltraps>

00102739 <vector233>:
.globl vector233
vector233:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $233
  10273b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102740:	e9 76 f6 ff ff       	jmp    101dbb <__alltraps>

00102745 <vector234>:
.globl vector234
vector234:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $234
  102747:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10274c:	e9 6a f6 ff ff       	jmp    101dbb <__alltraps>

00102751 <vector235>:
.globl vector235
vector235:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $235
  102753:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102758:	e9 5e f6 ff ff       	jmp    101dbb <__alltraps>

0010275d <vector236>:
.globl vector236
vector236:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $236
  10275f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102764:	e9 52 f6 ff ff       	jmp    101dbb <__alltraps>

00102769 <vector237>:
.globl vector237
vector237:
  pushl $0
  102769:	6a 00                	push   $0x0
  pushl $237
  10276b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102770:	e9 46 f6 ff ff       	jmp    101dbb <__alltraps>

00102775 <vector238>:
.globl vector238
vector238:
  pushl $0
  102775:	6a 00                	push   $0x0
  pushl $238
  102777:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10277c:	e9 3a f6 ff ff       	jmp    101dbb <__alltraps>

00102781 <vector239>:
.globl vector239
vector239:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $239
  102783:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102788:	e9 2e f6 ff ff       	jmp    101dbb <__alltraps>

0010278d <vector240>:
.globl vector240
vector240:
  pushl $0
  10278d:	6a 00                	push   $0x0
  pushl $240
  10278f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102794:	e9 22 f6 ff ff       	jmp    101dbb <__alltraps>

00102799 <vector241>:
.globl vector241
vector241:
  pushl $0
  102799:	6a 00                	push   $0x0
  pushl $241
  10279b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027a0:	e9 16 f6 ff ff       	jmp    101dbb <__alltraps>

001027a5 <vector242>:
.globl vector242
vector242:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $242
  1027a7:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027ac:	e9 0a f6 ff ff       	jmp    101dbb <__alltraps>

001027b1 <vector243>:
.globl vector243
vector243:
  pushl $0
  1027b1:	6a 00                	push   $0x0
  pushl $243
  1027b3:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027b8:	e9 fe f5 ff ff       	jmp    101dbb <__alltraps>

001027bd <vector244>:
.globl vector244
vector244:
  pushl $0
  1027bd:	6a 00                	push   $0x0
  pushl $244
  1027bf:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027c4:	e9 f2 f5 ff ff       	jmp    101dbb <__alltraps>

001027c9 <vector245>:
.globl vector245
vector245:
  pushl $0
  1027c9:	6a 00                	push   $0x0
  pushl $245
  1027cb:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027d0:	e9 e6 f5 ff ff       	jmp    101dbb <__alltraps>

001027d5 <vector246>:
.globl vector246
vector246:
  pushl $0
  1027d5:	6a 00                	push   $0x0
  pushl $246
  1027d7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027dc:	e9 da f5 ff ff       	jmp    101dbb <__alltraps>

001027e1 <vector247>:
.globl vector247
vector247:
  pushl $0
  1027e1:	6a 00                	push   $0x0
  pushl $247
  1027e3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027e8:	e9 ce f5 ff ff       	jmp    101dbb <__alltraps>

001027ed <vector248>:
.globl vector248
vector248:
  pushl $0
  1027ed:	6a 00                	push   $0x0
  pushl $248
  1027ef:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027f4:	e9 c2 f5 ff ff       	jmp    101dbb <__alltraps>

001027f9 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027f9:	6a 00                	push   $0x0
  pushl $249
  1027fb:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102800:	e9 b6 f5 ff ff       	jmp    101dbb <__alltraps>

00102805 <vector250>:
.globl vector250
vector250:
  pushl $0
  102805:	6a 00                	push   $0x0
  pushl $250
  102807:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10280c:	e9 aa f5 ff ff       	jmp    101dbb <__alltraps>

00102811 <vector251>:
.globl vector251
vector251:
  pushl $0
  102811:	6a 00                	push   $0x0
  pushl $251
  102813:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102818:	e9 9e f5 ff ff       	jmp    101dbb <__alltraps>

0010281d <vector252>:
.globl vector252
vector252:
  pushl $0
  10281d:	6a 00                	push   $0x0
  pushl $252
  10281f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102824:	e9 92 f5 ff ff       	jmp    101dbb <__alltraps>

00102829 <vector253>:
.globl vector253
vector253:
  pushl $0
  102829:	6a 00                	push   $0x0
  pushl $253
  10282b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102830:	e9 86 f5 ff ff       	jmp    101dbb <__alltraps>

00102835 <vector254>:
.globl vector254
vector254:
  pushl $0
  102835:	6a 00                	push   $0x0
  pushl $254
  102837:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10283c:	e9 7a f5 ff ff       	jmp    101dbb <__alltraps>

00102841 <vector255>:
.globl vector255
vector255:
  pushl $0
  102841:	6a 00                	push   $0x0
  pushl $255
  102843:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102848:	e9 6e f5 ff ff       	jmp    101dbb <__alltraps>

0010284d <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10284d:	55                   	push   %ebp
  10284e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102850:	8b 45 08             	mov    0x8(%ebp),%eax
  102853:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102856:	b8 23 00 00 00       	mov    $0x23,%eax
  10285b:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10285d:	b8 23 00 00 00       	mov    $0x23,%eax
  102862:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102864:	b8 10 00 00 00       	mov    $0x10,%eax
  102869:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10286b:	b8 10 00 00 00       	mov    $0x10,%eax
  102870:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102872:	b8 10 00 00 00       	mov    $0x10,%eax
  102877:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102879:	ea 80 28 10 00 08 00 	ljmp   $0x8,$0x102880
}
  102880:	5d                   	pop    %ebp
  102881:	c3                   	ret    

00102882 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102882:	55                   	push   %ebp
  102883:	89 e5                	mov    %esp,%ebp
  102885:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102888:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  10288d:	05 00 04 00 00       	add    $0x400,%eax
  102892:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102897:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  10289e:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1028a0:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1028a7:	68 00 
  1028a9:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028ae:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1028b4:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028b9:	c1 e8 10             	shr    $0x10,%eax
  1028bc:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1028c1:	a0 0d ea 10 00       	mov    0x10ea0d,%al
  1028c6:	83 e0 f0             	and    $0xfffffff0,%eax
  1028c9:	83 c8 09             	or     $0x9,%eax
  1028cc:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028d1:	a0 0d ea 10 00       	mov    0x10ea0d,%al
  1028d6:	83 c8 10             	or     $0x10,%eax
  1028d9:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028de:	a0 0d ea 10 00       	mov    0x10ea0d,%al
  1028e3:	83 e0 9f             	and    $0xffffff9f,%eax
  1028e6:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028eb:	a0 0d ea 10 00       	mov    0x10ea0d,%al
  1028f0:	83 c8 80             	or     $0xffffff80,%eax
  1028f3:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028f8:	a0 0e ea 10 00       	mov    0x10ea0e,%al
  1028fd:	83 e0 f0             	and    $0xfffffff0,%eax
  102900:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102905:	a0 0e ea 10 00       	mov    0x10ea0e,%al
  10290a:	83 e0 ef             	and    $0xffffffef,%eax
  10290d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102912:	a0 0e ea 10 00       	mov    0x10ea0e,%al
  102917:	83 e0 df             	and    $0xffffffdf,%eax
  10291a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10291f:	a0 0e ea 10 00       	mov    0x10ea0e,%al
  102924:	83 c8 40             	or     $0x40,%eax
  102927:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10292c:	a0 0e ea 10 00       	mov    0x10ea0e,%al
  102931:	83 e0 7f             	and    $0x7f,%eax
  102934:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102939:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10293e:	c1 e8 18             	shr    $0x18,%eax
  102941:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102946:	a0 0d ea 10 00       	mov    0x10ea0d,%al
  10294b:	83 e0 ef             	and    $0xffffffef,%eax
  10294e:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102953:	68 10 ea 10 00       	push   $0x10ea10
  102958:	e8 f0 fe ff ff       	call   10284d <lgdt>
  10295d:	83 c4 04             	add    $0x4,%esp
  102960:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102966:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
  10296a:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10296d:	c9                   	leave  
  10296e:	c3                   	ret    

0010296f <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10296f:	55                   	push   %ebp
  102970:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102972:	e8 0b ff ff ff       	call   102882 <gdt_init>
}
  102977:	5d                   	pop    %ebp
  102978:	c3                   	ret    

00102979 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102979:	55                   	push   %ebp
  10297a:	89 e5                	mov    %esp,%ebp
  10297c:	83 ec 38             	sub    $0x38,%esp
  10297f:	8b 45 10             	mov    0x10(%ebp),%eax
  102982:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102985:	8b 45 14             	mov    0x14(%ebp),%eax
  102988:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10298b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10298e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102991:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102994:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102997:	8b 45 18             	mov    0x18(%ebp),%eax
  10299a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10299d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029a6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1029b3:	74 1c                	je     1029d1 <printnum+0x58>
  1029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029b8:	ba 00 00 00 00       	mov    $0x0,%edx
  1029bd:	f7 75 e4             	divl   -0x1c(%ebp)
  1029c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1029c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029c6:	ba 00 00 00 00       	mov    $0x0,%edx
  1029cb:	f7 75 e4             	divl   -0x1c(%ebp)
  1029ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1029d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1029d7:	f7 75 e4             	divl   -0x1c(%ebp)
  1029da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1029e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029e9:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1029ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029ef:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1029f2:	8b 45 18             	mov    0x18(%ebp),%eax
  1029f5:	ba 00 00 00 00       	mov    $0x0,%edx
  1029fa:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029fd:	77 3f                	ja     102a3e <printnum+0xc5>
  1029ff:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102a02:	72 05                	jb     102a09 <printnum+0x90>
  102a04:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102a07:	77 35                	ja     102a3e <printnum+0xc5>
        printnum(putch, putdat, result, base, width - 1, padc);
  102a09:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102a0c:	48                   	dec    %eax
  102a0d:	83 ec 04             	sub    $0x4,%esp
  102a10:	ff 75 20             	pushl  0x20(%ebp)
  102a13:	50                   	push   %eax
  102a14:	ff 75 18             	pushl  0x18(%ebp)
  102a17:	ff 75 ec             	pushl  -0x14(%ebp)
  102a1a:	ff 75 e8             	pushl  -0x18(%ebp)
  102a1d:	ff 75 0c             	pushl  0xc(%ebp)
  102a20:	ff 75 08             	pushl  0x8(%ebp)
  102a23:	e8 51 ff ff ff       	call   102979 <printnum>
  102a28:	83 c4 20             	add    $0x20,%esp
  102a2b:	eb 1a                	jmp    102a47 <printnum+0xce>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102a2d:	83 ec 08             	sub    $0x8,%esp
  102a30:	ff 75 0c             	pushl  0xc(%ebp)
  102a33:	ff 75 20             	pushl  0x20(%ebp)
  102a36:	8b 45 08             	mov    0x8(%ebp),%eax
  102a39:	ff d0                	call   *%eax
  102a3b:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102a3e:	ff 4d 1c             	decl   0x1c(%ebp)
  102a41:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a45:	7f e6                	jg     102a2d <printnum+0xb4>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a4a:	05 90 3b 10 00       	add    $0x103b90,%eax
  102a4f:	8a 00                	mov    (%eax),%al
  102a51:	0f be c0             	movsbl %al,%eax
  102a54:	83 ec 08             	sub    $0x8,%esp
  102a57:	ff 75 0c             	pushl  0xc(%ebp)
  102a5a:	50                   	push   %eax
  102a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5e:	ff d0                	call   *%eax
  102a60:	83 c4 10             	add    $0x10,%esp
}
  102a63:	c9                   	leave  
  102a64:	c3                   	ret    

00102a65 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a65:	55                   	push   %ebp
  102a66:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a68:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a6c:	7e 14                	jle    102a82 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a71:	8b 00                	mov    (%eax),%eax
  102a73:	8d 48 08             	lea    0x8(%eax),%ecx
  102a76:	8b 55 08             	mov    0x8(%ebp),%edx
  102a79:	89 0a                	mov    %ecx,(%edx)
  102a7b:	8b 50 04             	mov    0x4(%eax),%edx
  102a7e:	8b 00                	mov    (%eax),%eax
  102a80:	eb 30                	jmp    102ab2 <getuint+0x4d>
    }
    else if (lflag) {
  102a82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a86:	74 16                	je     102a9e <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102a88:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8b:	8b 00                	mov    (%eax),%eax
  102a8d:	8d 48 04             	lea    0x4(%eax),%ecx
  102a90:	8b 55 08             	mov    0x8(%ebp),%edx
  102a93:	89 0a                	mov    %ecx,(%edx)
  102a95:	8b 00                	mov    (%eax),%eax
  102a97:	ba 00 00 00 00       	mov    $0x0,%edx
  102a9c:	eb 14                	jmp    102ab2 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa1:	8b 00                	mov    (%eax),%eax
  102aa3:	8d 48 04             	lea    0x4(%eax),%ecx
  102aa6:	8b 55 08             	mov    0x8(%ebp),%edx
  102aa9:	89 0a                	mov    %ecx,(%edx)
  102aab:	8b 00                	mov    (%eax),%eax
  102aad:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102ab2:	5d                   	pop    %ebp
  102ab3:	c3                   	ret    

00102ab4 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102ab4:	55                   	push   %ebp
  102ab5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102ab7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102abb:	7e 14                	jle    102ad1 <getint+0x1d>
        return va_arg(*ap, long long);
  102abd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac0:	8b 00                	mov    (%eax),%eax
  102ac2:	8d 48 08             	lea    0x8(%eax),%ecx
  102ac5:	8b 55 08             	mov    0x8(%ebp),%edx
  102ac8:	89 0a                	mov    %ecx,(%edx)
  102aca:	8b 50 04             	mov    0x4(%eax),%edx
  102acd:	8b 00                	mov    (%eax),%eax
  102acf:	eb 28                	jmp    102af9 <getint+0x45>
    }
    else if (lflag) {
  102ad1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ad5:	74 12                	je     102ae9 <getint+0x35>
        return va_arg(*ap, long);
  102ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  102ada:	8b 00                	mov    (%eax),%eax
  102adc:	8d 48 04             	lea    0x4(%eax),%ecx
  102adf:	8b 55 08             	mov    0x8(%ebp),%edx
  102ae2:	89 0a                	mov    %ecx,(%edx)
  102ae4:	8b 00                	mov    (%eax),%eax
  102ae6:	99                   	cltd   
  102ae7:	eb 10                	jmp    102af9 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  102aec:	8b 00                	mov    (%eax),%eax
  102aee:	8d 48 04             	lea    0x4(%eax),%ecx
  102af1:	8b 55 08             	mov    0x8(%ebp),%edx
  102af4:	89 0a                	mov    %ecx,(%edx)
  102af6:	8b 00                	mov    (%eax),%eax
  102af8:	99                   	cltd   
    }
}
  102af9:	5d                   	pop    %ebp
  102afa:	c3                   	ret    

00102afb <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102afb:	55                   	push   %ebp
  102afc:	89 e5                	mov    %esp,%ebp
  102afe:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  102b01:	8d 45 14             	lea    0x14(%ebp),%eax
  102b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b0a:	50                   	push   %eax
  102b0b:	ff 75 10             	pushl  0x10(%ebp)
  102b0e:	ff 75 0c             	pushl  0xc(%ebp)
  102b11:	ff 75 08             	pushl  0x8(%ebp)
  102b14:	e8 05 00 00 00       	call   102b1e <vprintfmt>
  102b19:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  102b1c:	c9                   	leave  
  102b1d:	c3                   	ret    

00102b1e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102b1e:	55                   	push   %ebp
  102b1f:	89 e5                	mov    %esp,%ebp
  102b21:	56                   	push   %esi
  102b22:	53                   	push   %ebx
  102b23:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b26:	eb 18                	jmp    102b40 <vprintfmt+0x22>
            if (ch == '\0') {
  102b28:	85 db                	test   %ebx,%ebx
  102b2a:	75 05                	jne    102b31 <vprintfmt+0x13>
                return;
  102b2c:	e9 7c 03 00 00       	jmp    102ead <vprintfmt+0x38f>
            }
            putch(ch, putdat);
  102b31:	83 ec 08             	sub    $0x8,%esp
  102b34:	ff 75 0c             	pushl  0xc(%ebp)
  102b37:	53                   	push   %ebx
  102b38:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3b:	ff d0                	call   *%eax
  102b3d:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b40:	8b 45 10             	mov    0x10(%ebp),%eax
  102b43:	8d 50 01             	lea    0x1(%eax),%edx
  102b46:	89 55 10             	mov    %edx,0x10(%ebp)
  102b49:	8a 00                	mov    (%eax),%al
  102b4b:	0f b6 d8             	movzbl %al,%ebx
  102b4e:	83 fb 25             	cmp    $0x25,%ebx
  102b51:	75 d5                	jne    102b28 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b53:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b57:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b61:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b64:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b6e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b71:	8b 45 10             	mov    0x10(%ebp),%eax
  102b74:	8d 50 01             	lea    0x1(%eax),%edx
  102b77:	89 55 10             	mov    %edx,0x10(%ebp)
  102b7a:	8a 00                	mov    (%eax),%al
  102b7c:	0f b6 d8             	movzbl %al,%ebx
  102b7f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102b82:	83 f8 55             	cmp    $0x55,%eax
  102b85:	0f 87 fa 02 00 00    	ja     102e85 <vprintfmt+0x367>
  102b8b:	8b 04 85 b4 3b 10 00 	mov    0x103bb4(,%eax,4),%eax
  102b92:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102b94:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102b98:	eb d7                	jmp    102b71 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102b9a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102b9e:	eb d1                	jmp    102b71 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102ba0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102ba7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102baa:	89 d0                	mov    %edx,%eax
  102bac:	c1 e0 02             	shl    $0x2,%eax
  102baf:	01 d0                	add    %edx,%eax
  102bb1:	01 c0                	add    %eax,%eax
  102bb3:	01 d8                	add    %ebx,%eax
  102bb5:	83 e8 30             	sub    $0x30,%eax
  102bb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102bbb:	8b 45 10             	mov    0x10(%ebp),%eax
  102bbe:	8a 00                	mov    (%eax),%al
  102bc0:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102bc3:	83 fb 2f             	cmp    $0x2f,%ebx
  102bc6:	7e 0a                	jle    102bd2 <vprintfmt+0xb4>
  102bc8:	83 fb 39             	cmp    $0x39,%ebx
  102bcb:	7f 05                	jg     102bd2 <vprintfmt+0xb4>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bcd:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102bd0:	eb d5                	jmp    102ba7 <vprintfmt+0x89>
            goto process_precision;
  102bd2:	eb 2e                	jmp    102c02 <vprintfmt+0xe4>

        case '*':
            precision = va_arg(ap, int);
  102bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  102bd7:	8d 50 04             	lea    0x4(%eax),%edx
  102bda:	89 55 14             	mov    %edx,0x14(%ebp)
  102bdd:	8b 00                	mov    (%eax),%eax
  102bdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102be2:	eb 1e                	jmp    102c02 <vprintfmt+0xe4>

        case '.':
            if (width < 0)
  102be4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102be8:	79 07                	jns    102bf1 <vprintfmt+0xd3>
                width = 0;
  102bea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102bf1:	e9 7b ff ff ff       	jmp    102b71 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102bf6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102bfd:	e9 6f ff ff ff       	jmp    102b71 <vprintfmt+0x53>

        process_precision:
            if (width < 0)
  102c02:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c06:	79 0d                	jns    102c15 <vprintfmt+0xf7>
                width = precision, precision = -1;
  102c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c0e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102c15:	e9 57 ff ff ff       	jmp    102b71 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102c1a:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102c1d:	e9 4f ff ff ff       	jmp    102b71 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c22:	8b 45 14             	mov    0x14(%ebp),%eax
  102c25:	8d 50 04             	lea    0x4(%eax),%edx
  102c28:	89 55 14             	mov    %edx,0x14(%ebp)
  102c2b:	8b 00                	mov    (%eax),%eax
  102c2d:	83 ec 08             	sub    $0x8,%esp
  102c30:	ff 75 0c             	pushl  0xc(%ebp)
  102c33:	50                   	push   %eax
  102c34:	8b 45 08             	mov    0x8(%ebp),%eax
  102c37:	ff d0                	call   *%eax
  102c39:	83 c4 10             	add    $0x10,%esp
            break;
  102c3c:	e9 67 02 00 00       	jmp    102ea8 <vprintfmt+0x38a>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c41:	8b 45 14             	mov    0x14(%ebp),%eax
  102c44:	8d 50 04             	lea    0x4(%eax),%edx
  102c47:	89 55 14             	mov    %edx,0x14(%ebp)
  102c4a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c4c:	85 db                	test   %ebx,%ebx
  102c4e:	79 02                	jns    102c52 <vprintfmt+0x134>
                err = -err;
  102c50:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c52:	83 fb 06             	cmp    $0x6,%ebx
  102c55:	7f 0b                	jg     102c62 <vprintfmt+0x144>
  102c57:	8b 34 9d 74 3b 10 00 	mov    0x103b74(,%ebx,4),%esi
  102c5e:	85 f6                	test   %esi,%esi
  102c60:	75 19                	jne    102c7b <vprintfmt+0x15d>
                printfmt(putch, putdat, "error %d", err);
  102c62:	53                   	push   %ebx
  102c63:	68 a1 3b 10 00       	push   $0x103ba1
  102c68:	ff 75 0c             	pushl  0xc(%ebp)
  102c6b:	ff 75 08             	pushl  0x8(%ebp)
  102c6e:	e8 88 fe ff ff       	call   102afb <printfmt>
  102c73:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102c76:	e9 2d 02 00 00       	jmp    102ea8 <vprintfmt+0x38a>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102c7b:	56                   	push   %esi
  102c7c:	68 aa 3b 10 00       	push   $0x103baa
  102c81:	ff 75 0c             	pushl  0xc(%ebp)
  102c84:	ff 75 08             	pushl  0x8(%ebp)
  102c87:	e8 6f fe ff ff       	call   102afb <printfmt>
  102c8c:	83 c4 10             	add    $0x10,%esp
            }
            break;
  102c8f:	e9 14 02 00 00       	jmp    102ea8 <vprintfmt+0x38a>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102c94:	8b 45 14             	mov    0x14(%ebp),%eax
  102c97:	8d 50 04             	lea    0x4(%eax),%edx
  102c9a:	89 55 14             	mov    %edx,0x14(%ebp)
  102c9d:	8b 30                	mov    (%eax),%esi
  102c9f:	85 f6                	test   %esi,%esi
  102ca1:	75 05                	jne    102ca8 <vprintfmt+0x18a>
                p = "(null)";
  102ca3:	be ad 3b 10 00       	mov    $0x103bad,%esi
            }
            if (width > 0 && padc != '-') {
  102ca8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cac:	7e 3e                	jle    102cec <vprintfmt+0x1ce>
  102cae:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102cb2:	74 38                	je     102cec <vprintfmt+0x1ce>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cb7:	83 ec 08             	sub    $0x8,%esp
  102cba:	50                   	push   %eax
  102cbb:	56                   	push   %esi
  102cbc:	e8 d1 02 00 00       	call   102f92 <strnlen>
  102cc1:	83 c4 10             	add    $0x10,%esp
  102cc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102cc7:	29 c2                	sub    %eax,%edx
  102cc9:	89 d0                	mov    %edx,%eax
  102ccb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102cce:	eb 16                	jmp    102ce6 <vprintfmt+0x1c8>
                    putch(padc, putdat);
  102cd0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102cd4:	83 ec 08             	sub    $0x8,%esp
  102cd7:	ff 75 0c             	pushl  0xc(%ebp)
  102cda:	50                   	push   %eax
  102cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cde:	ff d0                	call   *%eax
  102ce0:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ce3:	ff 4d e8             	decl   -0x18(%ebp)
  102ce6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cea:	7f e4                	jg     102cd0 <vprintfmt+0x1b2>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102cec:	eb 34                	jmp    102d22 <vprintfmt+0x204>
                if (altflag && (ch < ' ' || ch > '~')) {
  102cee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102cf2:	74 1c                	je     102d10 <vprintfmt+0x1f2>
  102cf4:	83 fb 1f             	cmp    $0x1f,%ebx
  102cf7:	7e 05                	jle    102cfe <vprintfmt+0x1e0>
  102cf9:	83 fb 7e             	cmp    $0x7e,%ebx
  102cfc:	7e 12                	jle    102d10 <vprintfmt+0x1f2>
                    putch('?', putdat);
  102cfe:	83 ec 08             	sub    $0x8,%esp
  102d01:	ff 75 0c             	pushl  0xc(%ebp)
  102d04:	6a 3f                	push   $0x3f
  102d06:	8b 45 08             	mov    0x8(%ebp),%eax
  102d09:	ff d0                	call   *%eax
  102d0b:	83 c4 10             	add    $0x10,%esp
  102d0e:	eb 0f                	jmp    102d1f <vprintfmt+0x201>
                }
                else {
                    putch(ch, putdat);
  102d10:	83 ec 08             	sub    $0x8,%esp
  102d13:	ff 75 0c             	pushl  0xc(%ebp)
  102d16:	53                   	push   %ebx
  102d17:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1a:	ff d0                	call   *%eax
  102d1c:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d1f:	ff 4d e8             	decl   -0x18(%ebp)
  102d22:	89 f0                	mov    %esi,%eax
  102d24:	8d 70 01             	lea    0x1(%eax),%esi
  102d27:	8a 00                	mov    (%eax),%al
  102d29:	0f be d8             	movsbl %al,%ebx
  102d2c:	85 db                	test   %ebx,%ebx
  102d2e:	74 0f                	je     102d3f <vprintfmt+0x221>
  102d30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d34:	78 b8                	js     102cee <vprintfmt+0x1d0>
  102d36:	ff 4d e4             	decl   -0x1c(%ebp)
  102d39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d3d:	79 af                	jns    102cee <vprintfmt+0x1d0>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d3f:	eb 13                	jmp    102d54 <vprintfmt+0x236>
                putch(' ', putdat);
  102d41:	83 ec 08             	sub    $0x8,%esp
  102d44:	ff 75 0c             	pushl  0xc(%ebp)
  102d47:	6a 20                	push   $0x20
  102d49:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4c:	ff d0                	call   *%eax
  102d4e:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d51:	ff 4d e8             	decl   -0x18(%ebp)
  102d54:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d58:	7f e7                	jg     102d41 <vprintfmt+0x223>
                putch(' ', putdat);
            }
            break;
  102d5a:	e9 49 01 00 00       	jmp    102ea8 <vprintfmt+0x38a>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102d5f:	83 ec 08             	sub    $0x8,%esp
  102d62:	ff 75 e0             	pushl  -0x20(%ebp)
  102d65:	8d 45 14             	lea    0x14(%ebp),%eax
  102d68:	50                   	push   %eax
  102d69:	e8 46 fd ff ff       	call   102ab4 <getint>
  102d6e:	83 c4 10             	add    $0x10,%esp
  102d71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d74:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d7d:	85 d2                	test   %edx,%edx
  102d7f:	79 23                	jns    102da4 <vprintfmt+0x286>
                putch('-', putdat);
  102d81:	83 ec 08             	sub    $0x8,%esp
  102d84:	ff 75 0c             	pushl  0xc(%ebp)
  102d87:	6a 2d                	push   $0x2d
  102d89:	8b 45 08             	mov    0x8(%ebp),%eax
  102d8c:	ff d0                	call   *%eax
  102d8e:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  102d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d97:	f7 d8                	neg    %eax
  102d99:	83 d2 00             	adc    $0x0,%edx
  102d9c:	f7 da                	neg    %edx
  102d9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102da1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102da4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dab:	e9 9f 00 00 00       	jmp    102e4f <vprintfmt+0x331>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102db0:	83 ec 08             	sub    $0x8,%esp
  102db3:	ff 75 e0             	pushl  -0x20(%ebp)
  102db6:	8d 45 14             	lea    0x14(%ebp),%eax
  102db9:	50                   	push   %eax
  102dba:	e8 a6 fc ff ff       	call   102a65 <getuint>
  102dbf:	83 c4 10             	add    $0x10,%esp
  102dc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dc5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102dc8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dcf:	eb 7e                	jmp    102e4f <vprintfmt+0x331>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102dd1:	83 ec 08             	sub    $0x8,%esp
  102dd4:	ff 75 e0             	pushl  -0x20(%ebp)
  102dd7:	8d 45 14             	lea    0x14(%ebp),%eax
  102dda:	50                   	push   %eax
  102ddb:	e8 85 fc ff ff       	call   102a65 <getuint>
  102de0:	83 c4 10             	add    $0x10,%esp
  102de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102de6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102de9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102df0:	eb 5d                	jmp    102e4f <vprintfmt+0x331>

        // pointer
        case 'p':
            putch('0', putdat);
  102df2:	83 ec 08             	sub    $0x8,%esp
  102df5:	ff 75 0c             	pushl  0xc(%ebp)
  102df8:	6a 30                	push   $0x30
  102dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfd:	ff d0                	call   *%eax
  102dff:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  102e02:	83 ec 08             	sub    $0x8,%esp
  102e05:	ff 75 0c             	pushl  0xc(%ebp)
  102e08:	6a 78                	push   $0x78
  102e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0d:	ff d0                	call   *%eax
  102e0f:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e12:	8b 45 14             	mov    0x14(%ebp),%eax
  102e15:	8d 50 04             	lea    0x4(%eax),%edx
  102e18:	89 55 14             	mov    %edx,0x14(%ebp)
  102e1b:	8b 00                	mov    (%eax),%eax
  102e1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e27:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e2e:	eb 1f                	jmp    102e4f <vprintfmt+0x331>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e30:	83 ec 08             	sub    $0x8,%esp
  102e33:	ff 75 e0             	pushl  -0x20(%ebp)
  102e36:	8d 45 14             	lea    0x14(%ebp),%eax
  102e39:	50                   	push   %eax
  102e3a:	e8 26 fc ff ff       	call   102a65 <getuint>
  102e3f:	83 c4 10             	add    $0x10,%esp
  102e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e45:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e48:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102e4f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102e53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e56:	83 ec 04             	sub    $0x4,%esp
  102e59:	52                   	push   %edx
  102e5a:	ff 75 e8             	pushl  -0x18(%ebp)
  102e5d:	50                   	push   %eax
  102e5e:	ff 75 f4             	pushl  -0xc(%ebp)
  102e61:	ff 75 f0             	pushl  -0x10(%ebp)
  102e64:	ff 75 0c             	pushl  0xc(%ebp)
  102e67:	ff 75 08             	pushl  0x8(%ebp)
  102e6a:	e8 0a fb ff ff       	call   102979 <printnum>
  102e6f:	83 c4 20             	add    $0x20,%esp
            break;
  102e72:	eb 34                	jmp    102ea8 <vprintfmt+0x38a>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102e74:	83 ec 08             	sub    $0x8,%esp
  102e77:	ff 75 0c             	pushl  0xc(%ebp)
  102e7a:	53                   	push   %ebx
  102e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7e:	ff d0                	call   *%eax
  102e80:	83 c4 10             	add    $0x10,%esp
            break;
  102e83:	eb 23                	jmp    102ea8 <vprintfmt+0x38a>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102e85:	83 ec 08             	sub    $0x8,%esp
  102e88:	ff 75 0c             	pushl  0xc(%ebp)
  102e8b:	6a 25                	push   $0x25
  102e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e90:	ff d0                	call   *%eax
  102e92:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  102e95:	ff 4d 10             	decl   0x10(%ebp)
  102e98:	eb 03                	jmp    102e9d <vprintfmt+0x37f>
  102e9a:	ff 4d 10             	decl   0x10(%ebp)
  102e9d:	8b 45 10             	mov    0x10(%ebp),%eax
  102ea0:	48                   	dec    %eax
  102ea1:	8a 00                	mov    (%eax),%al
  102ea3:	3c 25                	cmp    $0x25,%al
  102ea5:	75 f3                	jne    102e9a <vprintfmt+0x37c>
                /* do nothing */;
            break;
  102ea7:	90                   	nop
        }
    }
  102ea8:	e9 79 fc ff ff       	jmp    102b26 <vprintfmt+0x8>
}
  102ead:	8d 65 f8             	lea    -0x8(%ebp),%esp
  102eb0:	5b                   	pop    %ebx
  102eb1:	5e                   	pop    %esi
  102eb2:	5d                   	pop    %ebp
  102eb3:	c3                   	ret    

00102eb4 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102eb4:	55                   	push   %ebp
  102eb5:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eba:	8b 40 08             	mov    0x8(%eax),%eax
  102ebd:	8d 50 01             	lea    0x1(%eax),%edx
  102ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec3:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec9:	8b 10                	mov    (%eax),%edx
  102ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ece:	8b 40 04             	mov    0x4(%eax),%eax
  102ed1:	39 c2                	cmp    %eax,%edx
  102ed3:	73 12                	jae    102ee7 <sprintputch+0x33>
        *b->buf ++ = ch;
  102ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ed8:	8b 00                	mov    (%eax),%eax
  102eda:	8d 48 01             	lea    0x1(%eax),%ecx
  102edd:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ee0:	89 0a                	mov    %ecx,(%edx)
  102ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  102ee5:	88 10                	mov    %dl,(%eax)
    }
}
  102ee7:	5d                   	pop    %ebp
  102ee8:	c3                   	ret    

00102ee9 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102ee9:	55                   	push   %ebp
  102eea:	89 e5                	mov    %esp,%ebp
  102eec:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102eef:	8d 45 14             	lea    0x14(%ebp),%eax
  102ef2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ef8:	50                   	push   %eax
  102ef9:	ff 75 10             	pushl  0x10(%ebp)
  102efc:	ff 75 0c             	pushl  0xc(%ebp)
  102eff:	ff 75 08             	pushl  0x8(%ebp)
  102f02:	e8 0b 00 00 00       	call   102f12 <vsnprintf>
  102f07:	83 c4 10             	add    $0x10,%esp
  102f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f10:	c9                   	leave  
  102f11:	c3                   	ret    

00102f12 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f12:	55                   	push   %ebp
  102f13:	89 e5                	mov    %esp,%ebp
  102f15:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f18:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f21:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f24:	8b 45 08             	mov    0x8(%ebp),%eax
  102f27:	01 d0                	add    %edx,%eax
  102f29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102f33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f37:	74 0a                	je     102f43 <vsnprintf+0x31>
  102f39:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f3f:	39 c2                	cmp    %eax,%edx
  102f41:	76 07                	jbe    102f4a <vsnprintf+0x38>
        return -E_INVAL;
  102f43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102f48:	eb 20                	jmp    102f6a <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102f4a:	ff 75 14             	pushl  0x14(%ebp)
  102f4d:	ff 75 10             	pushl  0x10(%ebp)
  102f50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102f53:	50                   	push   %eax
  102f54:	68 b4 2e 10 00       	push   $0x102eb4
  102f59:	e8 c0 fb ff ff       	call   102b1e <vprintfmt>
  102f5e:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  102f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f64:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f6a:	c9                   	leave  
  102f6b:	c3                   	ret    

00102f6c <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102f6c:	55                   	push   %ebp
  102f6d:	89 e5                	mov    %esp,%ebp
  102f6f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102f72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102f79:	eb 03                	jmp    102f7e <strlen+0x12>
        cnt ++;
  102f7b:	ff 45 fc             	incl   -0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f81:	8d 50 01             	lea    0x1(%eax),%edx
  102f84:	89 55 08             	mov    %edx,0x8(%ebp)
  102f87:	8a 00                	mov    (%eax),%al
  102f89:	84 c0                	test   %al,%al
  102f8b:	75 ee                	jne    102f7b <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102f8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102f90:	c9                   	leave  
  102f91:	c3                   	ret    

00102f92 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102f92:	55                   	push   %ebp
  102f93:	89 e5                	mov    %esp,%ebp
  102f95:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102f98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102f9f:	eb 03                	jmp    102fa4 <strnlen+0x12>
        cnt ++;
  102fa1:	ff 45 fc             	incl   -0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102fa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102fa7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102faa:	73 0f                	jae    102fbb <strnlen+0x29>
  102fac:	8b 45 08             	mov    0x8(%ebp),%eax
  102faf:	8d 50 01             	lea    0x1(%eax),%edx
  102fb2:	89 55 08             	mov    %edx,0x8(%ebp)
  102fb5:	8a 00                	mov    (%eax),%al
  102fb7:	84 c0                	test   %al,%al
  102fb9:	75 e6                	jne    102fa1 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102fbe:	c9                   	leave  
  102fbf:	c3                   	ret    

00102fc0 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102fc0:	55                   	push   %ebp
  102fc1:	89 e5                	mov    %esp,%ebp
  102fc3:	57                   	push   %edi
  102fc4:	56                   	push   %esi
  102fc5:	83 ec 20             	sub    $0x20,%esp
  102fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  102fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102fd4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fda:	89 d1                	mov    %edx,%ecx
  102fdc:	89 c2                	mov    %eax,%edx
  102fde:	89 ce                	mov    %ecx,%esi
  102fe0:	89 d7                	mov    %edx,%edi
  102fe2:	ac                   	lods   %ds:(%esi),%al
  102fe3:	aa                   	stos   %al,%es:(%edi)
  102fe4:	84 c0                	test   %al,%al
  102fe6:	75 fa                	jne    102fe2 <strcpy+0x22>
  102fe8:	89 fa                	mov    %edi,%edx
  102fea:	89 f1                	mov    %esi,%ecx
  102fec:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102fef:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102ff2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102ff8:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102ff9:	83 c4 20             	add    $0x20,%esp
  102ffc:	5e                   	pop    %esi
  102ffd:	5f                   	pop    %edi
  102ffe:	5d                   	pop    %ebp
  102fff:	c3                   	ret    

00103000 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103000:	55                   	push   %ebp
  103001:	89 e5                	mov    %esp,%ebp
  103003:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103006:	8b 45 08             	mov    0x8(%ebp),%eax
  103009:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10300c:	eb 1c                	jmp    10302a <strncpy+0x2a>
        if ((*p = *src) != '\0') {
  10300e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103011:	8a 10                	mov    (%eax),%dl
  103013:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103016:	88 10                	mov    %dl,(%eax)
  103018:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10301b:	8a 00                	mov    (%eax),%al
  10301d:	84 c0                	test   %al,%al
  10301f:	74 03                	je     103024 <strncpy+0x24>
            src ++;
  103021:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  103024:	ff 45 fc             	incl   -0x4(%ebp)
  103027:	ff 4d 10             	decl   0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10302a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10302e:	75 de                	jne    10300e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103030:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103033:	c9                   	leave  
  103034:	c3                   	ret    

00103035 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103035:	55                   	push   %ebp
  103036:	89 e5                	mov    %esp,%ebp
  103038:	57                   	push   %edi
  103039:	56                   	push   %esi
  10303a:	83 ec 20             	sub    $0x20,%esp
  10303d:	8b 45 08             	mov    0x8(%ebp),%eax
  103040:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103043:	8b 45 0c             	mov    0xc(%ebp),%eax
  103046:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  103049:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10304c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10304f:	89 d1                	mov    %edx,%ecx
  103051:	89 c2                	mov    %eax,%edx
  103053:	89 ce                	mov    %ecx,%esi
  103055:	89 d7                	mov    %edx,%edi
  103057:	ac                   	lods   %ds:(%esi),%al
  103058:	ae                   	scas   %es:(%edi),%al
  103059:	75 08                	jne    103063 <strcmp+0x2e>
  10305b:	84 c0                	test   %al,%al
  10305d:	75 f8                	jne    103057 <strcmp+0x22>
  10305f:	31 c0                	xor    %eax,%eax
  103061:	eb 04                	jmp    103067 <strcmp+0x32>
  103063:	19 c0                	sbb    %eax,%eax
  103065:	0c 01                	or     $0x1,%al
  103067:	89 fa                	mov    %edi,%edx
  103069:	89 f1                	mov    %esi,%ecx
  10306b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10306e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103071:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  103074:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  103077:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103078:	83 c4 20             	add    $0x20,%esp
  10307b:	5e                   	pop    %esi
  10307c:	5f                   	pop    %edi
  10307d:	5d                   	pop    %ebp
  10307e:	c3                   	ret    

0010307f <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10307f:	55                   	push   %ebp
  103080:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103082:	eb 09                	jmp    10308d <strncmp+0xe>
        n --, s1 ++, s2 ++;
  103084:	ff 4d 10             	decl   0x10(%ebp)
  103087:	ff 45 08             	incl   0x8(%ebp)
  10308a:	ff 45 0c             	incl   0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10308d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103091:	74 17                	je     1030aa <strncmp+0x2b>
  103093:	8b 45 08             	mov    0x8(%ebp),%eax
  103096:	8a 00                	mov    (%eax),%al
  103098:	84 c0                	test   %al,%al
  10309a:	74 0e                	je     1030aa <strncmp+0x2b>
  10309c:	8b 45 08             	mov    0x8(%ebp),%eax
  10309f:	8a 10                	mov    (%eax),%dl
  1030a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a4:	8a 00                	mov    (%eax),%al
  1030a6:	38 c2                	cmp    %al,%dl
  1030a8:	74 da                	je     103084 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1030aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030ae:	74 16                	je     1030c6 <strncmp+0x47>
  1030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b3:	8a 00                	mov    (%eax),%al
  1030b5:	0f b6 d0             	movzbl %al,%edx
  1030b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030bb:	8a 00                	mov    (%eax),%al
  1030bd:	0f b6 c0             	movzbl %al,%eax
  1030c0:	29 c2                	sub    %eax,%edx
  1030c2:	89 d0                	mov    %edx,%eax
  1030c4:	eb 05                	jmp    1030cb <strncmp+0x4c>
  1030c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030cb:	5d                   	pop    %ebp
  1030cc:	c3                   	ret    

001030cd <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1030cd:	55                   	push   %ebp
  1030ce:	89 e5                	mov    %esp,%ebp
  1030d0:	83 ec 04             	sub    $0x4,%esp
  1030d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030d6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1030d9:	eb 12                	jmp    1030ed <strchr+0x20>
        if (*s == c) {
  1030db:	8b 45 08             	mov    0x8(%ebp),%eax
  1030de:	8a 00                	mov    (%eax),%al
  1030e0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1030e3:	75 05                	jne    1030ea <strchr+0x1d>
            return (char *)s;
  1030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e8:	eb 11                	jmp    1030fb <strchr+0x2e>
        }
        s ++;
  1030ea:	ff 45 08             	incl   0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  1030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f0:	8a 00                	mov    (%eax),%al
  1030f2:	84 c0                	test   %al,%al
  1030f4:	75 e5                	jne    1030db <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  1030f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030fb:	c9                   	leave  
  1030fc:	c3                   	ret    

001030fd <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1030fd:	55                   	push   %ebp
  1030fe:	89 e5                	mov    %esp,%ebp
  103100:	83 ec 04             	sub    $0x4,%esp
  103103:	8b 45 0c             	mov    0xc(%ebp),%eax
  103106:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103109:	eb 0f                	jmp    10311a <strfind+0x1d>
        if (*s == c) {
  10310b:	8b 45 08             	mov    0x8(%ebp),%eax
  10310e:	8a 00                	mov    (%eax),%al
  103110:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103113:	75 02                	jne    103117 <strfind+0x1a>
            break;
  103115:	eb 0c                	jmp    103123 <strfind+0x26>
        }
        s ++;
  103117:	ff 45 08             	incl   0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  10311a:	8b 45 08             	mov    0x8(%ebp),%eax
  10311d:	8a 00                	mov    (%eax),%al
  10311f:	84 c0                	test   %al,%al
  103121:	75 e8                	jne    10310b <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103123:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103126:	c9                   	leave  
  103127:	c3                   	ret    

00103128 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103128:	55                   	push   %ebp
  103129:	89 e5                	mov    %esp,%ebp
  10312b:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10312e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103135:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10313c:	eb 03                	jmp    103141 <strtol+0x19>
        s ++;
  10313e:	ff 45 08             	incl   0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103141:	8b 45 08             	mov    0x8(%ebp),%eax
  103144:	8a 00                	mov    (%eax),%al
  103146:	3c 20                	cmp    $0x20,%al
  103148:	74 f4                	je     10313e <strtol+0x16>
  10314a:	8b 45 08             	mov    0x8(%ebp),%eax
  10314d:	8a 00                	mov    (%eax),%al
  10314f:	3c 09                	cmp    $0x9,%al
  103151:	74 eb                	je     10313e <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  103153:	8b 45 08             	mov    0x8(%ebp),%eax
  103156:	8a 00                	mov    (%eax),%al
  103158:	3c 2b                	cmp    $0x2b,%al
  10315a:	75 05                	jne    103161 <strtol+0x39>
        s ++;
  10315c:	ff 45 08             	incl   0x8(%ebp)
  10315f:	eb 13                	jmp    103174 <strtol+0x4c>
    }
    else if (*s == '-') {
  103161:	8b 45 08             	mov    0x8(%ebp),%eax
  103164:	8a 00                	mov    (%eax),%al
  103166:	3c 2d                	cmp    $0x2d,%al
  103168:	75 0a                	jne    103174 <strtol+0x4c>
        s ++, neg = 1;
  10316a:	ff 45 08             	incl   0x8(%ebp)
  10316d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103178:	74 06                	je     103180 <strtol+0x58>
  10317a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10317e:	75 20                	jne    1031a0 <strtol+0x78>
  103180:	8b 45 08             	mov    0x8(%ebp),%eax
  103183:	8a 00                	mov    (%eax),%al
  103185:	3c 30                	cmp    $0x30,%al
  103187:	75 17                	jne    1031a0 <strtol+0x78>
  103189:	8b 45 08             	mov    0x8(%ebp),%eax
  10318c:	40                   	inc    %eax
  10318d:	8a 00                	mov    (%eax),%al
  10318f:	3c 78                	cmp    $0x78,%al
  103191:	75 0d                	jne    1031a0 <strtol+0x78>
        s += 2, base = 16;
  103193:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103197:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10319e:	eb 28                	jmp    1031c8 <strtol+0xa0>
    }
    else if (base == 0 && s[0] == '0') {
  1031a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031a4:	75 15                	jne    1031bb <strtol+0x93>
  1031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a9:	8a 00                	mov    (%eax),%al
  1031ab:	3c 30                	cmp    $0x30,%al
  1031ad:	75 0c                	jne    1031bb <strtol+0x93>
        s ++, base = 8;
  1031af:	ff 45 08             	incl   0x8(%ebp)
  1031b2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1031b9:	eb 0d                	jmp    1031c8 <strtol+0xa0>
    }
    else if (base == 0) {
  1031bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031bf:	75 07                	jne    1031c8 <strtol+0xa0>
        base = 10;
  1031c1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1031cb:	8a 00                	mov    (%eax),%al
  1031cd:	3c 2f                	cmp    $0x2f,%al
  1031cf:	7e 19                	jle    1031ea <strtol+0xc2>
  1031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d4:	8a 00                	mov    (%eax),%al
  1031d6:	3c 39                	cmp    $0x39,%al
  1031d8:	7f 10                	jg     1031ea <strtol+0xc2>
            dig = *s - '0';
  1031da:	8b 45 08             	mov    0x8(%ebp),%eax
  1031dd:	8a 00                	mov    (%eax),%al
  1031df:	0f be c0             	movsbl %al,%eax
  1031e2:	83 e8 30             	sub    $0x30,%eax
  1031e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031e8:	eb 42                	jmp    10322c <strtol+0x104>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ed:	8a 00                	mov    (%eax),%al
  1031ef:	3c 60                	cmp    $0x60,%al
  1031f1:	7e 19                	jle    10320c <strtol+0xe4>
  1031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f6:	8a 00                	mov    (%eax),%al
  1031f8:	3c 7a                	cmp    $0x7a,%al
  1031fa:	7f 10                	jg     10320c <strtol+0xe4>
            dig = *s - 'a' + 10;
  1031fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ff:	8a 00                	mov    (%eax),%al
  103201:	0f be c0             	movsbl %al,%eax
  103204:	83 e8 57             	sub    $0x57,%eax
  103207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10320a:	eb 20                	jmp    10322c <strtol+0x104>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10320c:	8b 45 08             	mov    0x8(%ebp),%eax
  10320f:	8a 00                	mov    (%eax),%al
  103211:	3c 40                	cmp    $0x40,%al
  103213:	7e 3a                	jle    10324f <strtol+0x127>
  103215:	8b 45 08             	mov    0x8(%ebp),%eax
  103218:	8a 00                	mov    (%eax),%al
  10321a:	3c 5a                	cmp    $0x5a,%al
  10321c:	7f 31                	jg     10324f <strtol+0x127>
            dig = *s - 'A' + 10;
  10321e:	8b 45 08             	mov    0x8(%ebp),%eax
  103221:	8a 00                	mov    (%eax),%al
  103223:	0f be c0             	movsbl %al,%eax
  103226:	83 e8 37             	sub    $0x37,%eax
  103229:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10322c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10322f:	3b 45 10             	cmp    0x10(%ebp),%eax
  103232:	7c 02                	jl     103236 <strtol+0x10e>
            break;
  103234:	eb 19                	jmp    10324f <strtol+0x127>
        }
        s ++, val = (val * base) + dig;
  103236:	ff 45 08             	incl   0x8(%ebp)
  103239:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10323c:	0f af 45 10          	imul   0x10(%ebp),%eax
  103240:	89 c2                	mov    %eax,%edx
  103242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103245:	01 d0                	add    %edx,%eax
  103247:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10324a:	e9 79 ff ff ff       	jmp    1031c8 <strtol+0xa0>

    if (endptr) {
  10324f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103253:	74 08                	je     10325d <strtol+0x135>
        *endptr = (char *) s;
  103255:	8b 45 0c             	mov    0xc(%ebp),%eax
  103258:	8b 55 08             	mov    0x8(%ebp),%edx
  10325b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10325d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103261:	74 07                	je     10326a <strtol+0x142>
  103263:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103266:	f7 d8                	neg    %eax
  103268:	eb 03                	jmp    10326d <strtol+0x145>
  10326a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10326d:	c9                   	leave  
  10326e:	c3                   	ret    

0010326f <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10326f:	55                   	push   %ebp
  103270:	89 e5                	mov    %esp,%ebp
  103272:	57                   	push   %edi
  103273:	83 ec 24             	sub    $0x24,%esp
  103276:	8b 45 0c             	mov    0xc(%ebp),%eax
  103279:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10327c:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103280:	8b 55 08             	mov    0x8(%ebp),%edx
  103283:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103286:	88 45 f7             	mov    %al,-0x9(%ebp)
  103289:	8b 45 10             	mov    0x10(%ebp),%eax
  10328c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10328f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103292:	8a 45 f7             	mov    -0x9(%ebp),%al
  103295:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103298:	89 d7                	mov    %edx,%edi
  10329a:	f3 aa                	rep stos %al,%es:(%edi)
  10329c:	89 fa                	mov    %edi,%edx
  10329e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1032a1:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1032a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032a7:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1032a8:	83 c4 24             	add    $0x24,%esp
  1032ab:	5f                   	pop    %edi
  1032ac:	5d                   	pop    %ebp
  1032ad:	c3                   	ret    

001032ae <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1032ae:	55                   	push   %ebp
  1032af:	89 e5                	mov    %esp,%ebp
  1032b1:	57                   	push   %edi
  1032b2:	56                   	push   %esi
  1032b3:	53                   	push   %ebx
  1032b4:	83 ec 30             	sub    $0x30,%esp
  1032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032c3:	8b 45 10             	mov    0x10(%ebp),%eax
  1032c6:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1032c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1032cf:	73 42                	jae    103313 <memmove+0x65>
  1032d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1032dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1032e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1032e6:	c1 e8 02             	shr    $0x2,%eax
  1032e9:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1032eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1032ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032f1:	89 d7                	mov    %edx,%edi
  1032f3:	89 c6                	mov    %eax,%esi
  1032f5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1032f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1032fa:	83 e1 03             	and    $0x3,%ecx
  1032fd:	74 02                	je     103301 <memmove+0x53>
  1032ff:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103301:	89 f0                	mov    %esi,%eax
  103303:	89 fa                	mov    %edi,%edx
  103305:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103308:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10330b:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  10330e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  103311:	eb 36                	jmp    103349 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103316:	8d 50 ff             	lea    -0x1(%eax),%edx
  103319:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10331c:	01 c2                	add    %eax,%edx
  10331e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103321:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103327:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  10332a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10332d:	89 c1                	mov    %eax,%ecx
  10332f:	89 d8                	mov    %ebx,%eax
  103331:	89 d6                	mov    %edx,%esi
  103333:	89 c7                	mov    %eax,%edi
  103335:	fd                   	std    
  103336:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103338:	fc                   	cld    
  103339:	89 f8                	mov    %edi,%eax
  10333b:	89 f2                	mov    %esi,%edx
  10333d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103340:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103343:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  103346:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103349:	83 c4 30             	add    $0x30,%esp
  10334c:	5b                   	pop    %ebx
  10334d:	5e                   	pop    %esi
  10334e:	5f                   	pop    %edi
  10334f:	5d                   	pop    %ebp
  103350:	c3                   	ret    

00103351 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103351:	55                   	push   %ebp
  103352:	89 e5                	mov    %esp,%ebp
  103354:	57                   	push   %edi
  103355:	56                   	push   %esi
  103356:	83 ec 20             	sub    $0x20,%esp
  103359:	8b 45 08             	mov    0x8(%ebp),%eax
  10335c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10335f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103362:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103365:	8b 45 10             	mov    0x10(%ebp),%eax
  103368:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10336b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10336e:	c1 e8 02             	shr    $0x2,%eax
  103371:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103379:	89 d7                	mov    %edx,%edi
  10337b:	89 c6                	mov    %eax,%esi
  10337d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10337f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103382:	83 e1 03             	and    $0x3,%ecx
  103385:	74 02                	je     103389 <memcpy+0x38>
  103387:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103389:	89 f0                	mov    %esi,%eax
  10338b:	89 fa                	mov    %edi,%edx
  10338d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103390:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103393:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103396:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  103399:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10339a:	83 c4 20             	add    $0x20,%esp
  10339d:	5e                   	pop    %esi
  10339e:	5f                   	pop    %edi
  10339f:	5d                   	pop    %ebp
  1033a0:	c3                   	ret    

001033a1 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1033a1:	55                   	push   %ebp
  1033a2:	89 e5                	mov    %esp,%ebp
  1033a4:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1033a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1033aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1033ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1033b3:	eb 2a                	jmp    1033df <memcmp+0x3e>
        if (*s1 != *s2) {
  1033b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1033b8:	8a 10                	mov    (%eax),%dl
  1033ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033bd:	8a 00                	mov    (%eax),%al
  1033bf:	38 c2                	cmp    %al,%dl
  1033c1:	74 16                	je     1033d9 <memcmp+0x38>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1033c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1033c6:	8a 00                	mov    (%eax),%al
  1033c8:	0f b6 d0             	movzbl %al,%edx
  1033cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033ce:	8a 00                	mov    (%eax),%al
  1033d0:	0f b6 c0             	movzbl %al,%eax
  1033d3:	29 c2                	sub    %eax,%edx
  1033d5:	89 d0                	mov    %edx,%eax
  1033d7:	eb 18                	jmp    1033f1 <memcmp+0x50>
        }
        s1 ++, s2 ++;
  1033d9:	ff 45 fc             	incl   -0x4(%ebp)
  1033dc:	ff 45 f8             	incl   -0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1033df:	8b 45 10             	mov    0x10(%ebp),%eax
  1033e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033e5:	89 55 10             	mov    %edx,0x10(%ebp)
  1033e8:	85 c0                	test   %eax,%eax
  1033ea:	75 c9                	jne    1033b5 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1033ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1033f1:	c9                   	leave  
  1033f2:	c3                   	ret    
