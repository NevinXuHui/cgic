---
url: https://zhuanlan.zhihu.com/p/435918702
title: 神仙 GDB 调试工具 gdb-dashboard
date: 2023-07-22 14:05:02
tag: 
banner: "https://pica.zhimg.com/v2-4efbce271834df216427f73be8bba2f5_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
## 最近在调试代码的过程中找到了一个国外的开源项目 gdb-dashboard，有些相见恨晚的感觉，是我一直想要的工具

在嵌入式调试开发中，尤其是做一些低层的开发，比如前些日子用汇编代码编写任务切换过程、可能要监控到代码的指令执行过程，观察堆栈、寄存器的变化等等

常见的调试架构，使用 qemu 调试时，qemu 会提供一个 socket 端口，我们使用 GDB 连接到该端口就可以进行调试了。

![](<assets/1690005902753.png>)

目前在 linux 下基于 GDB 我总结出来有三种程序调试方式：

*   vscode + gdb

vscode 调试优点是可以查看变量、寄存器、单步执行代码、设置断点等  
但是 vscode 存在几个明显的缺点 如不能单步执行汇编指令，有些问题定位不太方便 不能查看内存的数据

*   eclipse + gdb

eclipse 可以很好的解决 vscode 不支持单步调试指令的问题，以及查看内存地址数据的功能、基本上所以需要的调试功能都有  
但是我平时习惯使用 vscode 开发编辑代码，调试时需要额外打开 eclipse 工具，不够原生 不够方便

*   gdb 命令行

我们也可以直接使用 GDB 命令行来调试  
上面工具的全部功能都是基于 GDB 来开发的，所以 GDB 原生的命令行支持所以的功能  
GDB 命令行优点就是你想要的功能他都有  
但是缺点也比较明显，就是使用起来不够友好 所有的功能都依赖于手打命令  
调试界面显示的内容比较少，想要查看什么内容都需要通过敲命令查看

**上面的各个工具都有自己的优点和一些缺点，无法让我感到完美！！！**

### **直到今天，我发现了 gdb-dashboard 工具之后，我可能找到了一个最完美的解决方案**

gdb-dashboard 使用 python 配置了 gdb 调试界面，完全可以自己写代码去定义整个调试界面

可以说是堪比 IDE，显示也非常好看，完全基于终端

等我在学会了熟练使用 vim，抛弃 ide 指日可待，以后只用终端手敲命令就好了

展示一下他的炫酷界面

![](<assets/1690005902978.png>)

![](<assets/1690005903120.png>)

显示的内容太多太长，需要拖动滚动条才能看到全部界面（此时想拿一个长方形竖放的显示器看一下效果了）。

默认显示了全部的组件：

*   assembly 显示当前执行汇编指令上下文
*   breakpoints 断点信息、可以显示配置的断点
*   expressions 可以定义一些变量或表达式，在这里显示变量的值
*   history
*   memory 内存信息（查看指定内存地址的数据）
*   registers 体系结构的通用寄存器信息，和具体的处理器架构相关
*   source 当前执行的源代码
*   stack 栈帧信息
*   threads 多核或多线程调试
*   variables

_**下面分享下如何安装配置和使用 gdb-dashboard 工具，帮助大家在 linux 环境下调试代码**_

## **1. 安装 gdb-dashboard**

gdb-dashboard 开源项目地址：[https://github.com/cyrus-and/gdb-dashboard](https://github.com/cyrus-and/gdb-dashboard)

项目完全是使用 Python 脚本编写，可以直接下载脚本到工程目录

```
wget -P ~ https://git.io/.gdbinit

```

.gdbinit 文件在 Linux 系统下是隐藏文件，如果查看要使用命令`ls -al`

当在当前目录下执行`gdb`或者是`aarch64-none-elf-gdb`命令时，gdb 工具会自动查找当前目录下是否有 `.gdbinit` 文件，如果找到相应的文件，会自动去执行相关的脚本内容

我们只需要把上面的调试脚本下载到工程根目录就可以使用了

![](<assets/1690005903250.png>)

## **2. 使用与配置**

gdb-dashboard 脚本提供了一些配置选项，可以添加一些自定义的配置

### **2.1 配置脚本**

gdb-dashboard 会从下面几个目录查找配置文件并执行相关配置完成一些初始化的工作：

*   `/etc/gdb-dashboard/`;
*   `$XDG_CONFIG_HOME/gdb-dashboard/` (defaulting to `~/.config/gdb-dashboard/`);
*   `~/Library/Preferences/gdb-dashboard/`;
*   `~/.gdbinit.d/`.

在 dashboard 启动时会去加载和执行上面目录存放的一些初始化配置文件，一般建议在`~/.gdbinit.d/`目录下添加我们自己的配置

在 `~/.gdbinit.d/` 目录创建一个配置文件 `~/.gdbinit.d/init`

```
mkdir ~/.gdbinit.d/
touch ~/.gdbinit.d/init

```

在配置文件中加入如下内容（后续可根据自己的需要去定义跟多配置）：

```
set breakpoint pending on
set confirm off

```

### **2.2 定义显示的模块或者组件**

比如默认显示的模块太多、屏幕放不下了，有个别模块我们目前用不到，可以通过修改配置关闭一些模块的显示

dashboard 目前支持的全部组件如下：

```
assembly breakpoints expressions history memory registers source stack threads variables

```

我们可以在配置文件中定义启动后显示的组件

使用`-layout`指令来定义需要显示的内容和隐藏的内容

比如我们只显示 `register` , `assembly`, `stack`

`dashboard -layout registers assembly source !variables stack`

这个定义顺序也表示模组的展示顺序，从上到下

`!`叹号表示默认不显示该模组，当我们输入命令 `dashboart variables`命令时候，可以在对应的位置插入显示

![](<assets/1690005903345.png>)

### **2.3 使用多个终端显示**

除了设置某些组件不显示之外，我们还可以设置让某个组件在其他终端显示输出

整个 gdb-dashboard 的显示内容或者是单个模块组件的显示内容都可可以单独独立的在不同的终端输出显示

比如我们打开了 2 个终端 可以将源码组件在 A 终端输出显示，其他的组件在 B 终端显示

使用`-output` 命令用来将输出内容重定向到其他的界面或设备，可以实现上面的目标

1.  重定向全部输出到 `/dev/pts/1`

```
dashboard -output /dev/pts/1

```

1.  重定向 `assembly` 组件到 `/det/pts/3`

```
dashboard assembly -output /dev/pts/1

```

1.  重定向 `source`组件输出到 `/dev/pts/3`

```
dashboard source -output /dev/pts/2

```

`/dev/pts/x` 表示一个终端界面，如何获取我们的某个终端的序号是什么呢？

在终端输入`tty`命令就可以查看当前终端的序号

```
jhb@jhb-pc:~/rtos/armv8_os$ tty
/dev/pts/2

```

![](<assets/1690005903446.png>)

### **2.4 显示高度设置**

将组件重定向到其他窗口以后，可以使用下面的命令使得组件全屏显示

```
dashboard assembly -style height 0
dashboard source -style height 0

```

效果如下：

![](<assets/1690005903619.png>)

## **3. 使用 gdb-dashboard 调试**

### **3.1 开始调试**

1.  进入到工程目录  
    `cd armv8_os`
2.  下载 gdb init 调试脚本  
    `wget -P ~ https://git.io/.gdbinit`
3.  启动 gdb 服务  
    `make qemu_gdb`
4.  新建一个窗口 打开 gdb 调试器  
    `aarch64-none-elf-gdb`
5.  连接到 gdb 服务  
    `target remote localhost:1234`  
    连接完成以后就可以看到 dashboard 界面，默认显示了全部组件，需要拖动滚动条才能看到上面的内容
6.  加载程序文件  
    file app  
    load

### **3.2 GDB 常用调试命令**

**设置断点给某个函数**

```
break func

```

**执行单个指令**

`si`

**全速运行**

`continue`

### **3.3 dashboard 常用命令**

### **3.3.1 查看内存区域**

```
//把memory重定向到一个新的窗口
dashboard memory -output /dev/pts/2
​
//查看地址 0x40000000 长度为0x1000 看上去现在只能显示单个字节，可以研究下不同的显示格式 提交一下代码给作者
dashboard memory watch 0x40000000 0x1000

```

![](<assets/1690005903703.png>)

### **3.3.2 查看变量**

```
dashboard expressions -output /dev/pts/2
​
dashboard expressions watch g_systic

```

添加变量时候还可以自动补全（非常强大）

![](<assets/1690005903844.png>)

![](<assets/1690005904012.png>)

**gdb-dashboard 工具，完全可以由程序员自己去定制调试界面的内容，定制调试命令等等**

**我很喜欢这种需要什么工具就自己实现的感觉**

**通过上面的介绍，有没有兴趣尝试下这个神仙工具**

我正在开发的操作系统项目 [https://github.com/jhbdream/armv8_os](https://github.com/jhbdream/armv8_os)  
可以通过点击阅读原文打开  
所有代码都会在该仓库同步更新

**欢迎大家持续关注，作为一个小白，我会一步步去实现一些操作系统的基本功能，逐渐丰富**

**在学习过程中，也会参考一些现成的 RTOS 或者操作系统的相关实现，比如 rtthread 等，可以提供一些灵感**

**我们没有创造操作系统的能力，但是可以通过借鉴成熟的系统，以简单的实现方式去实现同样的功能**

**以此来达到了解复杂操作系统、用好操作系统的目的**

**在开发过程中的学到的一些经验、好用工具我也会分享出来**

**代码在 github 同步开源开发，如果无法浏览 github 代码，可以关注后在后台联系，提供获取方式**

**在学习中遇到问题欢迎私信一起交流探讨**

**如果你觉得文章的内容比较有价值，也可以帮我点一下点赞、再看**

**让更多的人看到**

dashboard 开源项目地址：[https://github.com/cyrus-and/gdb-dashboard](https://github.com/cyrus-and/gdb-dashboard)