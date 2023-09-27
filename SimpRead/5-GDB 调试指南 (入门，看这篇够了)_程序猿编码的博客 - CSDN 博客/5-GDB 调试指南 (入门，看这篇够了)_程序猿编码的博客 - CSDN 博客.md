---
url: https://blog.csdn.net/chen1415886044/article/details/105094688
title: GDB 调试指南 (入门，看这篇够了)_程序猿编码的博客 - CSDN 博客
date: 2023-07-22 08:21:00
tag: 
banner: "https://images.unsplash.com/photo-1483519396903-1ef292f4974a?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjg5OTg0NzcyfA&ixlib=rb-4.0.3&q=85&fit=crop&w=671&max-h=540"
banner_icon: 🔖
---
写这篇文档的目的是对前面 GDB 的知识做一次总览，本文为 GDB 调试指南，参考 GDB 调试手册，目前已有的篇目：

启动调试  
断点设置  
查看源码  
单步调试  
查看变量

**前言**

GDB 是 Linux 下非常好用且强大的调试工具。GDB 可以调试 C、C++、Go、java、 objective-c、PHP 等语言。对于一名 Linux 下工作的 c/c++ 程序员，GDB 是必不可少的工具，本篇以 C 语言来调试。

**GDB 简介**

UNIX 及 UNIX-like 下的调试工具。虽然它是命令行模式的调试工具，但是它的功能强大到你无法想象，能够让用户在程序运行时观察程序的内部结构和内存的使用情况。

一般来说，GDB 主要帮助你完成下面四个方面的功能：

1、按照自定义的方式启动运行需要调试的程序。  
2、可以使用指定位置和条件表达式的方式来设置断点。  
3、程序暂停时的值的监视。  
4、动态改变程序的执行环境。

**基本命令的操作**

GDB 中的命令很多，但我们只需掌握其中十个左右的命令，就大致可以完成日常的基本的程序调试工作。

![](<assets/1689985260969.png>)

  
gdb 命令拥有较多内部命令。在 gdb 命令提示符 “(gdb)” 下输入 “help” 可以查看所有内部命令及使用说明。

![](<assets/1689985261195.png>)

  
**判断文件是否带有调试信息**

要调试 C/C++ 的程序，首先在编译时，要使用 gdb 调试程序，在使用 gcc 编译源代码时必须加上 “-g” 参数。保留调试信息，否则不能使用 GDB 进行调试。

有一种情况，有一个编译好的二进制文件，你不确定是不是带有 - g 参数，带有 GDB 调试，这个时候你可以使用如下的命令验证：

![](<assets/1689985261289.png>)

  
如果没有调试信息，则会出现：

Reading symbols from /home/minger/share/tencent/gdb/main…(no debugging symbols found)…done.

/home/minger/share/tencent/gdb/main 是程序的路径。

如果带有调试功能，下面会提示：

![](<assets/1689985261472.png>)

Reading symbols from /home/minger/share/tencent/gdb/main…done.

说明可以进行 GDB 调试。

还有使用命令 readlef 查看可执行文件是否带有调试功能

readelf -S main|grep debug

![](<assets/1689985261819.png>)

  
如果有 debug 说明有调试功能，如果没有 debug。说明没有带有调试功能，则不能被调试。

开始进入正题，GDB 启动调试。

**调试方式启动运行无参程序**

以下是 linux 下 GDB 调试的一个实例，先给出一个示例用的小程序，C 语言代码：  
main.c

```
#include <stdio.h>

void Print(int i){

	printf("hello,程序猿编码 %d\n", i);
}

int main(int argc, char const *argv[]){
	
	int i = 0;
	for (i = 1; i < 3; i++){
		Print(i);
	}
	return 0;
}
```

编译：

```
gcc -g main.c -o main


```

下面 “gdb” 命令启动 GDB，将首先显示 GDB 说明，不管它：

![](<assets/1689985261925.png>)

  
上面最后一行 “(gdb)” 为 GDB 内部命令引导符，等待用户输入 GDB 命令。

下面使用 “file” 命令载入被调试程序 main（这里的 main 即前面 gcc 编译输出的可执行文件）：

如果最后一行提示 Reading symbols from /home/minger/share/tencent/gdb/main…done. 表示已经加载成功。

下面使用 “r” 命令执行（Run）被调试文件，因为尚未设置任何断点，将直接执行到程序结束：

![](<assets/1689985262037.png>)

  
**调试启动带参程序**

假设有以下程序，启动时需要带参数：

```
#include <stdio.h>

int main(int argc, char const *argv[]){

	if (1 >= argc){
		printf("usage:hello name\n");
		return 0;
	}
	
	printf("hello,程序猿编码 %s\n", argv[1]);

	return 0;
}
```

编译：

```
gcc -g test.c -o test


```

这种情况如何启动调试呢？只需要 r 的时候带上参数即可。

![](<assets/1689985262151.png>)

  
**调试 core 文件**

Core Dump：Core 的意思是内存，Dump 的意思是扔出来，堆出来（段错误）。开发和使用 Unix 程序时，有时程序莫名其妙的 down 了，却没有任何的提示 (有时候会提示 core dumped)，这时候可以查看一下有没有形如 core. 进程号的文件生成，这个文件便是操作系统把程序 down 掉时的内存内容扔出来生成的, 它可以做为调试程序的参考，能够很大程序帮助我们定位问题。那怎么生成 Core 文件呢？

**生成 Core 方法**

产生 coredump 的条件，首先需要确认当前会话的 ulimit –c，若为 0，则不会产生对应的 coredump，需要进行修改和设置。

![](<assets/1689985262288.png>)

  
即便程序 core dump 了也不会有 core 文件留下。我们需要让 core 文件能够产生, 设置 core 大小为无限:

```
ulimit -c unlimied


```

![](<assets/1689985262432.png>)

  
**更改 core dump 生成路径**

因为 core dump 默认会生成在程序的工作目录，但是有些程序存在切换目录的情况，导致 core dump 生成的路径没有规律，

所以最好是自己建立一个文件夹，存放生成的 core 文件。

我建立一个 /data/coredump 文件夹，在根目录 data 里的 coredump 文件夹。

![](<assets/1689985262535.png>)

  
调用如下命令：

```
echo /data/coredump/core.%e.%p> /proc/sys/kernel/core_pattern


```

将更改 core 文件生成路径，自动放在这个 / data/coredump 文件夹里。

%e 表示程序名， %p 表示进程 id

![](<assets/1689985262577.png>)

  
测试代码：

```
/*
#include <stdio.h>

int main(int argc, char const *argv[]){

	if (1 >= argc){
		printf("usage:hello name\n");
		return 0;
	}
	
	printf("hello,程序猿编码 %s\n", argv[1]);

	return 0;
}


*/

#include <stdio.h>

int main(int argc, char const *argv[])
{
	int i = 0;
	
	scanf("%d",i);
	printf("hello,程序猿编码 %d\n",i );
	return 0;
}



```

编译运行：

![](<assets/1689985262735.png>)

  
运行后结果显示段错误，该程序在主函数内部 scanf 的时候回崩溃，i 前面应该加上 &。

这个时候，进入 / data/coredump 文件夹可以查看生成的 core

![](<assets/1689985262803.png>)

  
然后用 gdb 调试该 core，命令为 gdb core.test.3591 , 显示如下

![](<assets/1689985262912.png>)

  
program terminated with signal 11 告诉我们信号中断了我们的程序，发生了段错误。

这个时候可以敲命令 backtrace(bt) 查看函数的调用的栈帧和层级关系。

这个一堆问号很多人遇到过，网上有些人说是没加载符号表，有人说是标准 glibc 版本不一致，不纠结这个问题。

可以通过如下命令调试：

gdb 可执行程序 exe  
进入 gdb 环境后  
core-file core 的名字  
敲命令 bt 可以查看准确信息。

gdb 可执行程序

![](<assets/1689985262978.png>)

  
进入 gdb 环境后，core-file core 的名字

![](<assets/1689985263040.png>)

  
敲 bt 命令，这是 gdb 查看 back trace 的命令，查看函数的调用的栈帧和层级关系。

![](<assets/1689985263139.png>)

  
可以看到最近的栈中存储的是调用了 IO 操作，可以看到 main 函数的 26 行出错。

到此为止，就是 core 文件配置生成和调试方法。

**总结**

至此，我们 GDB 启动调试方式完毕，和 core 文件配置生成和调试方法。后续接着讲断点设置、单步调试等。本人能力有限，欢迎留言补充。

**断点设置与查看源码**

**前言**

上篇 GDB 启动调试我们讲到了 GDB 启动调试的多种方式，在 Linux 环境软件开发中，GDB 是主要的调试工具，用来调试 C 和 C++ 程序。这一篇主要讲 GDB 的断点设置与查看源码。

**为什么要设置断点呢？**

当我们想查看变量内容，堆栈情况等等，可以指定断点。程序执行到断点处会暂停执行。break 命令用来设置断点，缩写形式为 b。设置断点后，以便我们更详细的跟踪断点附近程序的执行情况。

设置断点有很多方式。下面我们举例说明下常用的几种方式。

**通过行号设置断点**

格式：

break [行号]

break 行号，断点设置在该行开始处，注意：**该行代码未被执行**

如果你的程序是用 c 或者 c++ 写的，那么你可以使用 “文件名: 行号” 的形式设置断点。示例如下：

```
//test.c
#include <stdio.h>
 
void judge_sd(int num){

	if ((num & 1) == 0){
		printf("%d is even\n",num);
		return;
	}else{
		printf("%d is odd\n",num);
		return;
	}
}
 
int main(int argc, char const *argv[]){
	

	judge_sd(0);
	judge_sd(1);
	judge_sd(4);

	return 0;
}



```

编译：

```
gcc -g test.c -o test


```

![](<assets/1689985263225.png>)

  
gdb test

![](<assets/1689985263282.png>)

break 文件名 : 行号，适用于有多个源文件的情况。

示例中的 (gdb) b test.c:18 是设置了断点。断点的位置是 test.c 文件的 18 行。使用 r 命令执行脚本时，当运行到 18 行时就会暂停。注意：该行代码未被执行

**通过函数设置断点**

格式：

break [函数名]

break 函数名，断点设置在该函数的开始处，断点所在行未被执行：

同样可以将断点设置在函数处：

b judge_sd

![](<assets/1689985263424.png>)

  
**设置条件断点**

如果按上面的方法设置断点后，每次执行到断点位置都会暂停。有时候非常讨厌。我们只想在指定条件下才暂停。这时候根据条件设置断点就有了用武之地。设置条件断点的形式，就是在设置断点的基本形式后面增加 if 条件。示例如下：

```
break test.c:6 if num>0


```

![](<assets/1689985263502.png>)

  
当在 num>0 时，程序将会在第 6 行断住。

**查看断点**

语法：

info breakpoints

可以使用 info breakpoints 查看断点的情况。包含都设置了那些断点，断点被命中的次数等信息。示例如下：

![](<assets/1689985263631.png>)

  
它将会列出所有已设置的断点，每一个断点都有一个标号，用来代表这个断点。

**删除断点**

语法：

delete breakpoint

对于无用的断点我们可以删除。删除的命令格式为 delete breakpoint 断点编号。info breakpoint 命令显示结果中的 num 列就是编号。删除断点的示例如下：

![](<assets/1689985263698.png>)

  
**查看源码**

断点设置完后，当程序运行到断点处就会暂停。暂停的时候，我们可以查看断点附近的代码。查看代码的子命令是 list，缩写形式为 l。

![](<assets/1689985263814.png>)

  
**指定行号查看代码**

语法：

list first,last

例如，要列出 6 到 21 行之间的源码：  

![](<assets/1689985263881.png>)

  
**列出指定文件的源码**

前面执行 l 命令时，默认列出 test.c 的源码，如果想要看指定文件的源码呢？可以

list 【文件名加行号或函数名】

![](<assets/1689985263930.png>)

  
**总结**

本文介绍了 GDB 调试中的断点设置、源码查看。断点设置可以便于我们后期观察变量，堆栈等信息，为进一步的定位与调试做准备。源码查看可以通过指定行号或者方法名来查看相关代码。

**单步调试与查看变量**

**前言**

前面两篇已经对 GDB 启动调试, GDB 调试断点设置与查看源码我们已经了解了 GDB 基本的启动调试，设置断点，查看源码等，如果这些内容你还不知道，建议先回顾一下前面的内容。

断点附近的代码你了解后，这时候你就可以使用单步执行一条一条语句的去执行。可以随时查看执行后的结果。接下来你可能会想知道程序运行的一些情况，就需要查看变量的值。下面介绍单步调试与设置变量。

**单步调试**

居然是调试代码，还是老规矩，先上代码：

```
//test.c
#include <stdio.h>
 
void judge_sd(int num){

	if ((num & 1) == 0){
		printf("%d is even\n",num);
		return;
	}else{
		printf("%d is odd\n",num);
		return;
	}
}
 
int main(int argc, char const *argv[]){
	

	judge_sd(0);
	judge_sd(1);
	judge_sd(4);

	return 0;
}



```

编译：

```
gcc -g test.c -o test


```

程序的功能比较简单，这里不多做解释。断点附近的代码你了解后，这时候你就可以使用单步执行一条一条语句的去执行。可以随时查看执行后的结果。单步执行有两个命令，分别是 step 和 next。我们可能打了多处断点，或者断点打在循环内，这个时候，可以使用 continue 命令。这三个命令的区别在于：

```
1、next命令（可简写为n）用于在程序断住后，继续执行下一条语句。
2、step命令（可简写为s），它可以单步跟踪到函数内部。
3、continue命令（可简写为c）或者fg，它会继续执行程序，直到再次遇到断点处。


```

**单步进入 - step**

step 一条语句一条语句的执行。它有一个别名，s。它可以单步跟踪到函数内部。

先用 list（可简写为 l）将源码列出来，例如：

![](<assets/1689985264040.png>)

先启动调试，然后把源码列出来。

![](<assets/1689985264110.png>)

  
从上面的过程可以看到，在 5 行设置断点，运行程序，可见，step 命令进入到了被调用函数中 judge_sd。使用 step 命令也会在这个方法中一行一行的单步执行。但是如果没有该函数源码，需要跳过该函数执行，可使用 finish 命令，继续后面的执行。

**单步执行 - next**

next 命令示例：

![](<assets/1689985264177.png>)

  
next 命令（可简写为 n）用于在程序断住后，继续执行下一条语句。上面的信息在 5 行处打断点，然后运行到 6 行，然后输入 运行 n 2，则会单步执行两行。可见，使用 next 命令只会在本方法中单步执行。

**继续执行到下一个断点 - continue**

我们可能打了多处断点，或者断点打在循环内，这个时候，想跳过这个断点，甚至跳过多次断点继续执行该怎么做呢？可以使用 continue 命令。它的作用就是从暂停处继续执行。命令的简写形式为 c。继续执行过程中遇到断点或者观察点变化依然会暂停。示例代码如下：

![](<assets/1689985264297.png>)

**跳过执行–skip**

![](<assets/1689985264361.png>)

  
根据上面的信息可以看到，使用 skip 之后，将不会进入 judge_sd 函数。好处就是 skip 可以在 step 时跳过一些不想关注的函数或者某个文件。

如果想删除 skip，使用 skip delete [num] 。

**查看变量**

现在你已经会设置断点，查看断点附近的代码，并可以单步执行和继续执行。接下来你可能会想知道程序运行的一些情况，如查看变量的值。print 命令正好满足了你的需求。以帮助我们进一步定位问题。

格式：

print[变量名]

print（可简写为 p）打印变量内容。示例代码如下：

```
//test.c
#include <stdio.h>
#include <stdlib.h> //malloc,free,rand

int main(int argc, char const *argv[])
{
	
	int input;
	int i ;

	printf("Please enter the length of the string:");

    scanf("%d",&input);

    char *buf = (char *) malloc(input + 1);//字符最后包含'\0'
    if (buf == NULL)
    {
    	printf("malloc failed!\n");
    	return -1;
    }

	//随机生成字符串

	for ( i = 0; i < input; i++)
	{
		buf[i] = rand()%26 +'a';
	}

	buf[i] = '\0';

	printf("A randomly generated string： %s\n",buf);
	free(buf);

	return 0;
}


```

编译：

```
gcc -g test.c -o test

```

先用 list（可简写为 l）将源码列出来，例如：

![](<assets/1689985264486.png>)

  
print 命令的简写形式为 p，使用它打印出变量的值。

![](<assets/1689985264561.png>)

打印出的变量 i 的值为 80。

当然，多个函数或者多个文件会有同一个变量名，这个时候可以在前面加上文件名或者函数名来区分：

```
p 'testfile.c'::i
p 'sum'::i

```

在看看指针。

![](<assets/1689985264672.png>)

  
注意到了没有，如果使用上面的方式打印指针指向的内容，那么打印出来的只是指针地址而已。那怎么打印出指针指向的内容呢？

需要解引用，如下：

![](<assets/1689985264768.png>)

  
仅仅使用 * 只能打印第一个值，如果要打印多个值，后面跟上 @并加上要打印的长度。  
或者 @后面跟上变量值：如下：

![](<assets/1689985264808.png>)

  
另外值得一提的是，$ 可表示上一个变量，在调试链表时时经常会用到的，它有 next 成员代表下一个节点，则可使用下面方式不断打印链表内容，举例：

```
p *linkNode  #这里显示linkNode节点内容
p *$.next #这里显示linkNode节点下一个节点的内容

```

**设置变量**

使用 print 命令查看了变量的值，如果感觉这个值不符合预期，想修改下这个值，再看下执行效果。这种情况下，我们该怎么办呢？通常情况下，我们会修改代码，再重新执行代码。使用 gdb 的 set 命令，一切将变得更简单。

set 命令可以直接修改变量的值。

**设置观察点**

设置观察点的作用就是：当被观察的变量发生变化后，程序就会暂停执行，并把变量的原值 (Old) 和新值 (New) 都会显示出来。设置观察点的命令是 watch。

```
watch num

```

这个时候，让程序继续运行，如果 num 的值发生变化，则会打印相关内容，如：

Hardware watchpoint 3: num  
Old value = 1  
New value = 10

**总结**

通过上面的例子演示，我相信读者已经对于通过 GDB 调试 C/C++ 程序有了基本的理解，如果你想获取更多的调试技巧请参考官方网站的 GDB 调试手册，还有 GDB 官方网站的手册。

**参考**：GDB TutorialA Walkthrough with Examples

![](<assets/1689985264916.png>)

  
欢迎关注公众号【**程序猿编码**】，添加**本人微信号** (17865354792)，回复：**领取学习资料**，网盘资料有如下：

![](<assets/1689985264981.png>)