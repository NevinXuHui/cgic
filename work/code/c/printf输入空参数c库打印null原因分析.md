

# 1) 举例

```
#include <stdio.h>
#include <string.h>
int main(int argc, char** argv) {
	printf("%s %s\n", "abcd",0);
	return 0;
}
```

gcc -g testprintf -o testprintf

执行结果：

abcd (null)

(null)是怎么出来的？下面分析一下

# 2) 分析

## 2.1)write函数设置断点

strace -o ./out.log ./testprintf

cat out.log

得到输出调用的是write函数

write(1, "abcd (null)\n", 12) = 12

所以跟踪write函数

b write

Breakpoint 2, __GI___libc_write (fd=1, buf=0x405260, nbytes=12) at ../sysdeps/unix/sysv/linux/write.c:26

26 ../sysdeps/unix/sysv/linux/write.c: 没有那个文件或目录.

(gdb) p (char*)buf

$1 = 0x405260 "abcd (null)\n"

(gdb) bt

#0 __GI___libc_write (fd=1, buf=0x405260, nbytes=12) at ../sysdeps/unix/sysv/linux/write.c:26

#1 0x00007ffff7e5a4ed in _IO_new_file_write (f=0x7ffff7f9b760 <_IO_2_1_stdout_>, data=0x405260, n=12) at fileops.c:1183

#2 0x00007ffff7e5988f in new_do_write (fp=0x7ffff7f9b760 <_IO_2_1_stdout_>, data=0x405260 "abcd (null)\n", to_do=to_do@entry=12) at libioP.h:839

#3 0x00007ffff7e5b639 in _IO_new_do_write (to_do=12, data=<optimized out>, fp=<optimized out>) at fileops.c:430

#4 _IO_new_do_write (fp=<optimized out>, data=<optimized out>, to_do=12) at fileops.c:430

#5 0x00007ffff7e5abbf in _IO_new_file_xsputn (n=1, data=<optimized out>, f=0x7ffff7f9b760 <_IO_2_1_stdout_>) at libioP.h:839

#6 _IO_new_file_xsputn (f=0x7ffff7f9b760 <_IO_2_1_stdout_>, data=<optimized out>, n=1) at fileops.c:1204

#7 0x00007ffff7e2f242 in _IO_vfprintf_internal (s=0x7ffff7f9b760 <_IO_2_1_stdout_>, format=0x402009 "%s %s\n", ap=ap@entry=0x7fffffffca30) at ../libio/libioP.h:839

#8 0x00007ffff7e37736 in __printf (format=<optimized out>) at printf.c:33

#9 0x000000000040114a in main (argc=1, argv=0x7fffffffcc08) at testprintf.c:4

结论：

null空字符串来自buf, 下一步跟踪buf中的值从哪儿来。

直接跟踪比较慢，可以看看buf这个地址是不是每次调试时都保持不变，如果不变，那么就用watch来跟踪给buf赋值得堆栈。

经过测试，发现buf的地址不变，每次都是0x405260

## 2.2)watch方式跟踪0x405268地址的写入

调试发现，当运行到printf函数时，0x405260地址还无法访问，因为还没有申请它的内存空间，此时得到的信息如下：

(gdb) p (char*)0x405260

$3 = 0x405260 <error: Cannot access memory at address 0x405260>

解决方案：

b _IO_new_file_xsputn

display (char*)0x405260

当display显示0x405260这个地址可以读时再设置观察点

当第三次断下来时看到如下信息：

Breakpoint 3, _IO_new_file_xsputn (f=0x7ffff7f9b760 <_IO_2_1_stdout_>, data=0x40200b, n=1) at fileops.c:1211

1211 in fileops.c

1: (char*)0x405260 = 0x405260 "abcd"

这表示0x405260地址对应的内存空间已经申请了，可以watch了。

watch *0x405268

当0x405268的地址被修改时，得到如下信息

Old value = 0

New value = 2714732

__memmove_avx_unaligned_erms () at ../sysdeps/x86_64/multiarch/memmove-vec-unaligned-erms.S:322

322 ../sysdeps/x86_64/multiarch/memmove-vec-unaligned-erms.S: 没有那个文件或目录.

1: (char*)0x405260 = 0x405260 "abcd "

(gdb) bt

#0 __memmove_avx_unaligned_erms () at ../sysdeps/x86_64/multiarch/memmove-vec-unaligned-erms.S:322

#1 0x00007ffff7e5ab15 in _IO_new_file_xsputn (n=6, data=0x7ffff7f605ec <null>, f=0x7ffff7f9b760 <_IO_2_1_stdout_>) at fileops.c:1243

#2 _IO_new_file_xsputn (f=0x7ffff7f9b760 <_IO_2_1_stdout_>, data=0x7ffff7f605ec <null>, n=6) at fileops.c:1204

#3 0x00007ffff7e2f32b in _IO_vfprintf_internal (s=0x7ffff7f9b760 <_IO_2_1_stdout_>, format=0x402009 "%s %s\n", ap=ap@entry=0x7fffffffca30) at ../libio/libioP.h:839

#4 0x00007ffff7e37736 in __printf (format=<optimized out>) at printf.c:33

#5 0x000000000040114a in main (argc=1, argv=0x7fffffffcc08) at testprintf.c:4

p /x 2714732

0x296c6c

它们刚好对于"ll)"字符串，具体如下（字符串有大小端，int类型可忽略）

(gdb) p /x 2714732

$4 = 0x296c6c

(gdb) call malloc(8)

$5 = (void *) 0x7ffff7fa1f40

(gdb) p ((char*)$5)[0]=0x29

$6 = 41 ')'

(gdb) p ((char*)$5)[1]=0x6c

$7 = 108 'l'

(gdb) p ((char*)$5)[2]=0x6c

$8 = 108 'l'

(gdb) p (char*)$4

$9 = 0x296c6c <error: Cannot access memory at address 0x296c6c>

(gdb) p (char*)$4

$10 = 0x296c6c <error: Cannot access memory at address 0x296c6c>

(gdb) p (char*)$5

$11 = 0x7ffff7fa1f40 ")ll"

(gdb) p ((int*)$5)[0]=0x296c6c

$12 = 2714732

(gdb) p ((char*)$5)

$13 = 0x7ffff7fa1f40 "ll)"

(gdb) p ((char*)$5)

$14 = 0x7ffff7fa1f40 "ll)"

(gdb) p 0x7ffff7f605ec

$15 = 140737353483756

(gdb) p (char*)0x7ffff7f605ec

$16 = 0x7ffff7f605ec <null> "(null)"

(gdb) p (char*)0x7ffff7f605ec

$16 = 0x7ffff7f605ec <null> "(null)"

结论：

从上面的堆栈可以看到，"(null)"来自0x7ffff7f605ec这个地址的值，进一步看看这个地址的值从俺儿来的。

## 2.3)查看0x7ffff7f605ec地址的值

基于maps信息查看这个地址是栈、堆还是某个动态库的地址空间

she cat /proc/30556/maps|grep 7ffff

结果如下：

7ffff7f49000-7ffff7f95000 r--p 0016a000 103:03 399404 /usr/lib/x86_64-linux-gnu/libc-2.28.so

所以这个地址属于c库的只读数据段空间。

所以可以猜测这个变量是c库的一个字符串常量，基于stirngs快速确认

strings /usr/lib/x86_64-linux-gnu/libc-2.28.so|grep null

_null_auth

/dev/null

(null)

parameter null or not set

结论：

(null)是c库的一个字符串常量，c库打印函数printf打印过程中如果发现空指针以字符串格式打印时，处理了这种异常，用内置好的"(null)"字符串来替换填充。