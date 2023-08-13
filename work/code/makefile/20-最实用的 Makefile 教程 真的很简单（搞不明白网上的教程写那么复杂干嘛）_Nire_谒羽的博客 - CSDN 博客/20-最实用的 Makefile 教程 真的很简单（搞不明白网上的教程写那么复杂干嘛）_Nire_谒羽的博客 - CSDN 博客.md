---
url: https://blog.csdn.net/Nire_Yeyu/article/details/106373974
title: 最实用的 Makefile 教程 真的很简单（搞不明白网上的教程写那么复杂干嘛）_Nire_谒羽的博客 - CSDN 博客
date: 2023-05-07 19:50:14
tag: 
banner: "https://img-blog.csdnimg.cn/20200527104016770.gif"
banner_icon: 🔖
---
![](1683460214360.png)

# 前言

其实我的要求不高，我就是想要写个 [Makefile](https://so.csdn.net/so/search?q=Makefile&spm=1001.2101.3001.7020)，把我那些需要反复编译的文件处理一下就可以了，所以我当时就拼命地在网上找关于 Makefile 的教程，结果看到的教程都是啰里啰嗦一大堆，看得我云里雾里。

大家要知道，在一些大公司里面，有一个职业是专门写 Makefile 的，可是我就想用 Makefile 完成那么一点基础的工作，你给我整那么多乱七八糟的东西干嘛。

在经受网上各种教程的毒打之后，我实在是忍不住了，我自己写一个教程算了。大家看这篇文章的时候，如果你也和我一样，一开始只是想解决最基础的问题，你就只要看第一个章节就可以了，后面的大家视情况而定。

![](1683460214442.png)

# 一、Makefile 的显式规则

首先，在 Makefile 中，# 代表着注释，这个是不会被编译进去的。

其次，Makefile 的基本语法是：  
目标文件：依赖文件  
[TAB] 指令

大家注意，在 Makefile 里，有一个很反人类的规定，指令前必须打一个 [Tab] 键，按四下空格会报错。

越是接近目标文件的命令，就越是要写在前面。因为程序是按照递归的方式进行依赖文件查找的，看到第一行有一个没见过的依赖文件，就往下一行进行查找，以此类推。

但是有些同学反映，不按照这个顺序来写好像也不会报错，我觉得这可能是和版本有关系，不过保险起见，我建议大家还是按照规范来写 Makefile。

举个例子：

```
hello:hello.o
	gcc hello.o -o hello
	
hello.o:hello.S
	gcc -c hello.S -o hello.o
	
hello.S:hello.i
	gcc -S hello.i -o hello.S
	
hello.i:hello.c
	gcc -E hello.c -o hello.i

```

假设当前文件夹中有 hello.c 和 Makefile 两个文件，当我们在终端输入 make 指令的时候，就会自动编译出 hello.o，hello.S，hello.i 以及 hello 可执行文件。

可是，我们又不想要这些不相关的文件，想对这些文件做一些操作，我们把这样的操作叫做伪目标，标志位. PHONY:

在上述代码的最后面加上：

```
.PHONY:
clear:
	rm hello.o hello.S hello.i

```

.PHONY: 这是固定格式，不能变的，但是下面的 clear 是自己取的名字，你随便取什么名字都可以，但是 clear 比较直观。

这样，当我们执行 make clear 指令后，将只剩下 hello.c 和 hello 可执行文件。

再来个复杂一点的例子：

```
# 目标文件：test
# 现有文件：program1.c program1.h program2.c program2.h main.c main.h

test:program1.o program2.o main.o
	gcc program1.o program2.o main.o -o test

program1.o:program1.c
	gcc -c program1.c -o program1.o

program2.o:program2.c
	gcc -c program2.c -o program2.o

main.o:main.c
	gcc -c main.c -o main.o

.PHONY:
clean_all:
	rm program1.o program2.o main.o

```

到这里，Makefile 就学会了，就可以用来做事情了，就是这么简单。

后面的内容无所谓你看不看了，放学了。。。  

![](1683460214534.png)

# 二、变量

<table><thead><tr><th>符号</th><th>含义</th></tr></thead><tbody><tr><td>=</td><td>替换</td></tr><tr><td>+=</td><td>追加</td></tr><tr><td>:=</td><td>恒等于</td></tr></tbody></table>

如果我们写 TAR = test，就表示下面的代码中，我们可以用 TAR 代表 test 文件。  
如果再写 TAR += test1，就表示 TAR 代表 test 和 test1。

CC := gcc 就表示下面写 gcc 的地方全部可以用 CC 代替，因为 gcc 这个是不会变的，是常量，所以可以用恒等于替换，这个不能用 +=。

当我们要调用这些变量的时候，就直接使用 $(变量) 的方式进行调用。

举个例子，对比上面那一段代码，可以修改成下面的样子：

```
TAR = test
OBJ = program1.o program2.o main.o
CC := gcc

$(TAR):$(OBJ)
	$(CC) $(OBJ) -o $(TAR)

program1.o:program1.c
	$(CC) -c program1.c -o program1.o

program2.o:program2.c
	$(CC) -c program2.c -o program2.o

main.o:main.c
	$(CC) -c main.c -o mian.o

.PHONY:
clean_all:
	rm $(OBJ)

```

![](1683460214637.png)

# 三、隐含规则

<table><thead><tr><th>符号</th><th>含义</th></tr></thead><tbody><tr><td>%.o</td><td>任意的. o 文件</td></tr><tr><td>*.o</td><td>所有的. o 文件</td></tr></tbody></table>

于是，我们又可以把上面的代码简化一下：

```
TAR = test
OBJ = program1.o program2.o main.o
CC := gcc

$(TAR):$(OBJ)
	$(CC) $(OBJ) -o $(TAR)

%.o:%.c
	$(CC) -c %.c -o %.o

.PHONY:
clean_all:
	rm $(OBJ)

```

![](1683460214685.png)

# 四、通配符

<table><thead><tr><th>符号</th><th>含义</th></tr></thead><tbody><tr><td>$^</td><td>所有依赖文件</td></tr><tr><td>$@</td><td>所有目标文件</td></tr><tr><td>$&lt;</td><td>所有依赖文件的第一个文件</td></tr></tbody></table>

所以，上诉代码还可以简化成下面这个样子：

```
TAR = test
OBJ = program1.o cube.o main.o
CC := gcc
RMRF := rm 

$(TAR):$(OBJ)
	$(CC) $^ -o $@
%.o:%.c
	$(CC) -c $^ -o $@

.PHONY:
cleanall:
	$(RMRF) $(OBJ)

```

嗯，基本上我一下子就想到这么多了。

![](1683460214820.png)