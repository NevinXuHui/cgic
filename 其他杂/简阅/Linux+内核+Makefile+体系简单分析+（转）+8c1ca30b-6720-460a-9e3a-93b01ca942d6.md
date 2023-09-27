转载自 [mz_linux 的 ChinaUnix 博客](http://blog.chinaunix.net/uid/26806098.html) ：[http://blog.chinaunix.net/uid-26806098-id-3141136.html](http://blog.chinaunix.net/uid-26806098-id-3141136.html)

众所周知，Linux 内核是使用 make 命令来配置并编译的，那必然少不了 Makefile。在内核目录树中我们可以看到内核编译系统的顶层 Makefile 文件。但是如此复杂、庞大的内核源码绝不可能使用一个或几个 Makefile 文件来完成配置编译，而是需要一套同样复杂、庞大，且为 Linux 内核定制的 Makefile 系统。她可以说是内核的一个子系统，是内核中比较特殊的一部分，几乎都是应用层的程序和脚本，但又和生成的内核二进制文件息息相关。编译不仅涉及本地编译，还涉及各个平台之间的交叉编译以及二进制文件格式处理等等。她是对 Makefile 在功能上的扩充，使其在配置编译 Linux 内核的时候更加灵活、高效和简洁。

尽管她是一个复杂的系统，但对绝大部分内核开发者来说只需要知道如何使用，而无需了解其中的细节。她对绝大部分内核开发者基本上是透明的，隐藏了大部分实现细节，有效地降低了开发者的负担，能使其能专注于内核开发，而不至于花费时间和精力在编译过程上。

以下我们就来简要的了解一下内核 Makefile 体系。

一、  内核 Makefile 体系概述

其实内核 Makefile 体系的包含了 Kconfig 和 Kbuild 两个系统。她曾经的维护人是 Sam Ravnborg <[sam@ravnborg.org](mailto:sam@ravnborg.org)>，现在的暂时没有查到。参考资料：

[kbuild 更换维护者](http://blog.chinaunix.net/link.php?url=http://wangcong.org%2Fblog%2Farchives%2F862) 作者：[王聪](http://blog.chinaunix.net/link.php?url=http://wangcong.org%2Fblog%2F) （西邮神人，崇拜下）

Kconfig 对应的是内核配置阶段，如你使用命令：make menuconfig，就是在使用 Kconfig 系统。Kconfig 由以下三部分组成：

|||
|-|-|
|scripts/kconfig/*|Kconfig 文件解析程序|
|kconfig  |各个内核源代码目录中的 kconfig 文件|
|arch/$(ARCH)/configs/*_defconfig|各个平台的缺省配置文件|

当 Kconfig 系统生成. config 后，Kbuild 会依据. config 编译指定的目标。后面我会简单地对 make %config 的流程进行情景分析，这里不必赘述。

Kbuild 是内核 Makefile 体系重点，对应内核编译阶段，由 5 个部分组成：

|||
|-|-|
|顶层 Makefile|根据不同的平台，对各类 target 分类并调用相应的规则 Makefile 生成目标|
|.config|内核配置文件|
|arch/$(ARCH)/Makefile|具体平台相关的 Makefile|
|scripts/Makefile.*|通用规则文件，面向所有的 Kbuild Makefiles，所起的作用可以从后缀名中得知。|
|各子目录下的 Makefile 文件|由其上层目录的 Makefile 调用，执行其上层传递下来的命令|

而其中 scripts 目录下的编译规则文件和其目录下的 C 程序在整个编译过程起着重要的作用。列举如下：

|||
|-|-|
|文件名|作用|
|Kbuild.include|共用的定义文件，被许多独立的 Makefile.* 规则文件和顶层 Makefile 包含|
|Makefile.build|提供编译 built-in.o, lib.a 等的规则|
|Makefile.lib|负责归类分析 obj-y、obj-m 和其中的目录 subdir-ym 所使用的规则|
|Makefile.host|本机编译工具（hostprog-y）的编译规则|
|Makefile.clean|内核源码目录清理规则|
|Makefile.headerinst|内核头文件安装时使用的规则|
|Makefile.modinst|内核模块安装规则|
|Makefile.modpost|模块编译的第二阶段, 由. o 和. mod 生成. ko 时使用的规则|

**顶层 Makefile 主要是负责完成 vmlinux(内核文件) 与 .ko(内核模块文件)* **的编译。顶层** **Makefile 读取. config 文件，并根据. config 文件确定访问哪些子目录，并通过递归向下访问子目录的形式完成。顶层 Makefile 同时根据. config 文件原封不动的包含一个具体架构的 Makefile，其名字类似于 arch/$(ARCH)/Makefile。该架构 Makefile 向顶层 Makefile 提供其架构的特别信息。**

**每一个子目录都有一个 Makefile 文件，用来执行从其上层目录传递下来的命令。子目录的 Makefile 也从. config 文件中提取信息，生成内核编译所需的文件列表。**

二、 内核 Makefile 导读与情景分析

**1、概述**

上面简要介绍了内核 Makefile 的总体结构，但当我们打开顶层 Makefile 文件时还是因为她的复杂而觉得无从下手。但是内核 Makefile 就是 Makefile，和最简单的 Makefile 遵循着同样的规则。所以只要我们静下心来分析, 还是可以理解的。当然，在阅读内核的 Makefile 前，你必须对 Makefile 和 shell 脚本有一定的基础。

1. **推荐参考资料：**

2. **《[GNU make 中文手册](http://blog.chinaunix.net/link.php?url=http://www.linuxsir.org%2Fmain%2Fdoc%2Fgnumake%2FGNUmake_v3.80-zh_CN_html%2Findex.html)》 翻译整理：[徐海兵](http://blog.chinaunix.net/link.php?url=http://blog.chinaunix.net%2Fuid%2F103125.html) [PDF 文档](http://blog.chinaunix.net/link.php?url=http://blog.chinaunix.net%2Fuid-103125-id-2964151.html)**

3. **《[高级 Bash 脚本编程指南](http://blog.chinaunix.net/link.php?url=http://www.tsnc.edu.cn%2Fdefault%2Ftsnc_wgrj%2Fdoc%2Fabs-3.9.1_cn%2Fhtml%2F)》翻译：杨春敏 黄毅**

根据 Makefile 的执行规则，在分析 Makefile 时，首先必须确定一个目标 ，然后才能确定所有的依赖关系 ，最后根据更新情况决定是否执行相应的命令。所以要看懂内核 Makefile 的大致框架，我们首先要了解她里面所定义的目标。而内核 Makefile 所定义的目标基本上可以通过 make help 打印出来（因为 help 本身就是顶层 Makefile 的一个目标，里面是打印帮助信息的 “echo” 命令）。

这些目标可以分为以下几个大类：

|||||
|-|-|-|-|
|目标|常用目标举例||作用|
|配置|%config|config|启动 Kconfig，以不同界面来配置内核。|
|||menuconfig||
|||xconfig||
|编译|all||编译 vmlinux 内核映像和内核模块|
||vmlinux||编译 vmlinux 内核映像|
||modules||编译内核模块|
|安装|headers_install||安装内核头文件 / 模块|
||modules_install|||
|源码浏览|tags||生成代码浏览工具所需要的文件|
||TAGS|||
||cscope|||
|静态分析|checkstack||检查并分析内核代码|
||namespacecheck|||
||headers_check|||
|内核打包|%pkg||以不同的安装格式编译内核|
|文档转换|%doc||把 kernel 文档转成不同格式|
|构架相关（以 arm 为例）|zImage||生成压缩的内核映像|
||uImage||生成压缩的 u-boot 可引导的内核映像|
||install||安装内核映像|

其中的构架相关目标在顶层 Makefile 上并未出现，而是被包含在平台相关的 Makefile（arch/$(ARCH)/Makefile）中。

**2、情景分析**

以下我们就来分析一个简单的目标 (menuconfig)，作为情景分析范例来演示一下内核 Makefile 的分析方法。

首先当我们在内核源码的根目录下执行 make menuconfig 命令时，根据规则，make 程序读取顶层 Makefile 文件及其包含的 Makefile 文件，内建所有的变量、明确规则和隐含规则，并建立所有目标和依赖之间的依赖关系结构链表。make 程序最终会调用规则：

||
|-|
|config %config: scripts_basic outputmakefile FORCE       $(Q)mkdir -p include/linux include/config       $(Q)$(MAKE) $(build)=scripts/kconfig $@|

调用的原因是我们指定的目标 “menuconfig” 匹配了“%config”。

她的依赖目标是 scripts_basic 和 outputmakefile，以及 FORCE。也就是说在完成了这 3 个依赖目标后，下面的两个命令才会执行以完成我们指定的目标 “menuconfig”。

所以我们来看看这三个依赖目标实现的简要过程：

**（1）scripts_basic**

make 程序会调用规则：

||
|-|
|scripts_basic:       $(Q)$(MAKE) $(build)=scripts/basic|

他没有依赖目标，所以直接执行了以下的指令，只要将指令展开，我们就知道 make 做了什么操作。其中比较不好展开的是 $(build)，她的定义在 scripts/Kbuild.include 中：

||
|-|
|build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj|

所以展开后是：

||
|-|
|make -f scripts/Makefile.build obj= scripts/basic|

也就是 make 解析执行 scripts/Makefile.build 文件，且参数 obj= scripts/basic。而在解析执行 scripts/Makefile.build 文件的时候，scripts/Makefile.build 又会通过解析传入参数来包含对应文件夹下的 Makefile 文件（scripts/basic/Makefile），从中获得需要编译的目标。

在确定这个目标以后，通过目标的类别来继续包含一些 scripts/Makefile.* 文件。例如 scripts/basic/Makefile 中内容如下：

||
|-|
|hostprogs-y := fixdep docproc hashalways      := $(hostprogs-y)# fixdep is needed to compile other host programs$(addprefix $(obj)/,$(filter-out fixdep,$(always))): $(obj)/fixdep|

所以 scripts/Makefile.build 会包含 scripts/Makefile.host。相应的语句如下：

||
|-|
|# Do not include host rules unless neededifneq ($(hostprogs-y)$(hostprogs-m),)include scripts/Makefile.hostendif|

此外 scripts/Makefile.build 会包含 include scripts/Makefile.lib 等必须的规则定义文件，在这些文件的共同作用下完成对 scripts/basic/Makefile 中指定的程序编译。

由于 Makefile.build 的解析执行牵涉了多个 Makefile.* 文件，过程较为复杂，碍于篇幅无法一条一条指令的分析，兴趣的读者可以自行分析。

1. **推荐两篇经典的分析文档：**

2. **《[kbuild 实现分析](http://blog.chinaunix.net/link.php?url=http://blog.chinaunix.net%2Fspace.php%3Fuid%3D22184779%26amp%3Bdo%3Dblog%26amp%3Bid%3D1786288)》 作者：[x.yin@hotmail.com](http://blog.chinaunix.net/link.php?url=http://blog.chinaunix.net%2Fspace.php%3Fuid%3D22184779%26amp%3Bdo%3Dblog%26amp%3Bid%3D1786288)**

3. **《Kbuild 系统原理分析》  作者未知，网上有 PDF 文档**

**（2）outputmakefile**

make 程序会调用规则：

||
|-|
|PHONY += outputmakefile# outputmakefile generates a Makefile in the output directory, if using a# separate output directory. This allows convenient use of make in the# output directory.outputmakefile:ifneq ($(KBUILD_SRC),)    $(Q)ln -fsn $(srctree) source    $(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \        $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)endif|

从这里我们可以看出：outputmakefile 是当 KBUILD_SRC 不为空 (指定 O=dir，编译输出目录和源代码目录分开) 时，在输出目录建立 Makefile 时才执行命令的，

如果我们在源码根目录下执行 make menuconfig 命令时，这个目标是空的，什么都不做。

如果我们指定了 O=dir 时，就会执行源码目录下的 scripts/mkmakefile，用于在指定的目录下产生一个 Makefile，并可以在指定的目录下开始编译。

**（3）FORCE**

这是一个在内核 Makefile 中随处可见的伪目标，她的定义在顶层 Makefile 的最后：

||
|-|
|PHONY += FORCEFORCE:|

是个完全的空目标，但是为什么要定义一个这样的空目标，并让许多目标将其作为依赖目标呢？原因如下：

正因为 FORCE 是一个没有命令或者依赖目标，不可能生成相应文件的伪目标。当 make 执行此规则时，总会认为 FORCE 不存在，必须完成这个目标，所以她是一个强制目标。也就是说：规则一旦被执行，make 就认为它的目标已经被执行并更新过了。当她作为一个规则的依赖时，由于依赖总被认为被更新过的，因此作为依赖所在的规则中定义的命令总会被执行。所以可以这么说：只要执行依赖包含 FORCE 的目标，其目标下的命令必被执行。

**在 make 完成了以上 3 个目标之后，就开始执行下面的命令的，首先是**

||
|-|
|$(Q)mkdir -p include/linux include/config|

这个很好理解，就是建立两个必须的文件夹。然后

||
|-|
|$(Q)$(MAKE) $(build)=scripts/kconfig $@|

这和我们上面分析的 $(Q)$(MAKE) $(build)= 结构相同，将其展开得到：

||
|-|
|make -f scripts/Makefile.build obj=scripts/kconfigmenuconfig|

所以这个指令的效果是使 make 解析执行 scripts/Makefile.build 文件，且参数 obj=scripts/kconfig menuconfig。这样 Makefile.build 会包含对应文件夹下的 Makefile 文件（scripts/kconfig /Makefile），并完成 scripts/kconfig /Makefile 下的目标：

||
|-|
|menuconfig: $(obj)/mconf            $<$(Kconfig)|

这个目标的依赖条件是 $(obj)/mconf，通过分析可知她其实是对应以下规则：

||
|-|
|mconf-objs  := mconf.o zconf.tab.o $(lxdialog)……ifeq ($(MAKECMDGOALS),menuconfig)    hostprogs-y += mconfendif|

也就是编译生成本机使用的 mconf 程序。完成依赖目标后，通过 scripts/kconfig /Makefile 中对 Kconfig 的定义可知，最后执行：

||
|-|
|mconf arch/$(SRCARCH)/Kconfig|

而对于 conf 和 xconf 等都有类似的过程，所以总结起来：当 make %config 时，内核根目录的顶层 Makefile 会临时编译出 scripts/kconfig 中的工具程序 conf/mconf/qconf 等负责对 arch/$(SRCARCH)/Kconfig 文件进行解析。这个 Kconfig 又通过 source 标记调用各个目录下的 Kconfig 文件构建出一个 Kconfig 树，使得工具程序构建出整个内核的配置界面。在配置结束后，工具程序就会生成我们常见的. config 文件。

**三、在内核中添加自己的模块**

虽然内核 Makefile 体系很是复杂，但是这种复杂带来的确是开发时的便利。其实内核 Makefile 体系之所以复杂，其中的一个原因就是为了方便扩展。对于一个开发者来要在内核中添加自己的一个驱动代码是非常简单的事情。

一般来说，对于一个新驱动代码的添加，驱动工程师只需要在内核源码的 drivers 目录的相应子目录下添加新设备驱动源码，并增加或修改该目录下的 Kconfig 和 Makefile 文件即可。

比如你已经写好了一个针对 TI 的 AM33XX 芯片的 LED 的驱动程序，名为 am33xx_led.c。

（1）       将驱动源码 am33xx_led.c 等文件复制到 linux-X.Y.Z/drivers/char 目录。

（2）       在该目录下的 Kconfig 文件中添加 LED 驱动的配置选项：

||
|-|
|config AM33XX_LED       bool "Support for am33xx led drivers"       depends on  SOC_OMAPAM33XX       default n       ---help---          Say Y here if you want to support for AM33XX LED drivers.|

（3）     在该目录下的 Makefile 文件中添加对 LED 驱动的编译：

||
|-|
|obj-$(CONFIG_AM33XX_LED)   +=  am33xx_led.o|

这样你就可以在 make menuconfig 的时候看到这个配置选项，并进行配置了。

当然，**上面的例子只是一个意思，对于 Kconfig 文件和 Makefile 的详细语法，请参考内核文档：Documentation/kbuild/makefile.txt**

**四 、在内核 Makefile 上对读者的建议**

这个复杂的 Makefile 体系体现了很多优秀程序共有的设计思想，对于我们今后的程序设计上有很多值得借鉴的地方。比如：模块化设计、简化编程接口，使得自行添加模块更加的简洁。阅读分析这样复杂的 Makefile 对于学习和编写 Makefile 和 shell 脚本有很好的参考价值。如果你正在学习 Makefile 的编写和阅读，那你可以耐心的分析一下内核的 Makefile 体系，只要你认真分析了一两个目标的实现，你会发现当你在阅读一些小软件的 Makefile 时已经是轻车熟路了。特别是现在很多芯片的开发包都是以 SDK 包的形式发布的，而这些软件包都是通过 Makefile 体系来实现自动编译和配置的，所以熟悉 Makefile 是每个 Linux 开发者都需要做到的。

