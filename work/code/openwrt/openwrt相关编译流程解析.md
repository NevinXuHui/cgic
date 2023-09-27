> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [dongshao.blog.csdn.net](https://dongshao.blog.csdn.net/article/details/102509299)

> 此篇使用的源码来自于文章：[https://blog.csdn.net/qq_41453285/article/details/102499225](https://blog.csdn.net/qq_41453285/article/details/102499225) OpenWrt的原始代码有7个原始的顶层目录，编辑时会生成7个临时目录 一、顶层目录目 录 含 义 config 编译选项配置文件，包含全局编译设置、开发人员编译设置、目标文件格式设置和内核 编译设置等 4 部分...

最新推荐文章于 2022-07-03 22:22:41 发布

![https://csdnimg.cn/release/blogv2/dist/pc/img/original.png](https://csdnimg.cn/release/blogv2/dist/pc/img/original.png)

版权声明：本文为博主原创文章，遵循 [CC 4.0 BY-SA](http://creativecommons.org/licenses/by-sa/4.0/) 版权协议，转载请附上原文出处链接和本声明。

- **此篇使用的源码来自于文章：**[https://blog.csdn.net/qq_41453285/article/details/102499225](https://blog.csdn.net/qq_41453285/article/details/102499225)。

- **OpenWrt 的原始代码有 7 个原始的顶层目录，编辑时会生成 7 个临时目录。**

![https://img-blog.csdnimg.cn/20191011223104301.png](https://img-blog.csdnimg.cn/20191011223104301.png)

<table><tbody><tr><td><strong>目 录</strong></td><td><strong>含 义</strong></td></tr><tr><td><strong>config</strong></td><td>编译选项配置文件，包含全局编译设置、开发人员编译设置、目标文件格式设置和内核 编译设置等 4 部分</td></tr><tr><td><strong>include</strong></td><td>包含准备环境脚本、下载补丁脚本、编译 Makefile 以及编译指令等</td></tr><tr><td><strong>package</strong></td><td>各种功能的软件包，软件包仅包含 Makefile 和修改补丁及配置文件。其中 Makefile 包含 源代码真正的地址及 MD5 值。OpenWrt 社区的修改代码以补丁包形式管理，package 只 保存一些常用的软件包</td></tr><tr><td><strong>scripts</strong></td><td>包含准备环境脚本、下载补丁脚本、编译 Makefile 以及编译指令等</td></tr><tr><td><strong>target</strong></td><td>指的是嵌入式平台，包括特定嵌入式平台的内容</td></tr><tr><td><strong>toolchain</strong></td><td>编译器和 C 库等（交叉编译工具），例如包含编译工具 gcc 和 glibc 库</td></tr><tr><td><strong>tools</strong></td><td>通用命令 / 工具，用来生成固件的辅助工具，如打补丁工具 patch、编译工具 make 及 squashfs 等</td></tr></tbody></table>

- 目录下存放的是编译配置文件，是 OpenWrt 15.05 的新增目录，是将一些编译选项配置文件放在此处，包含全局编译设置、开发人员编译设置、目标文件格式设置和内核编译设置等 4 部分。

- 编译源码时，输入 “make defconfig” 命令，这个目录下的配置文件会被集中读取并生成一个 “.config” 配置文件，该文件在下面会介绍。

> 

  - Config-build.in：最基本的配置文件（全局编译）。

  - Config-devel.in：用于开发的编译配置文件。

  - Config-images.in：目标文件格式设置（生成某种镜像的配置文件）。

  - Config-kernel.in：关于内核编译的配置文件。

### 包含文件

![https://img-blog.csdnimg.cn/20191011222922127.png](https://img-blog.csdnimg.cn/20191011222922127.png)

> 

  - 下面我们以 “Config-build.in” 格式为例。

  - **menu：**我们在目录下输入 “make menuconfig” 之后显示的主菜单项，例如上面我们的 menu 为 “Global build settings”，在主菜单项中可以看到一个选项为“Global build settings” 的内容。（备注：menu 以 endmenu 结尾）。

  - **config：**config 下的 bool 的内容为我们回车进入某一个菜单项之中显示的子项。但是如果一个 config 的上一级没有 menu 项，那么 config 下的 bool 内容直接显示在主菜单项中（例如下面的 "Advanced configuration options (for developers)" 项上一级不是 menu，那么其直接显示在主菜单中）。

  - **default：**代表默认值，如果为 y 代表是默认选择的，如果为 n 代表默认不选择。

  - **help：**这个选项的帮助解释说明。

  - 例如下面我们有一个 "Compile with support for patented functionality" 子选项，其 default 为 y，所以前面有 “*” 号为默认选择。当我们在下面选择 “help” 然后回车，可以看到此子选项的注释。

### .in 配置文件的内容与格式

![https://img-blog.csdnimg.cn/20191011223235807.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011223235807.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

![https://img-blog.csdnimg.cn/20191011205111342.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011205111342.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

![https://img-blog.csdnimg.cn/20191011210050246.png](https://img-blog.csdnimg.cn/20191011210050246.png)

![https://img-blog.csdnimg.cn/20191011210121313.png](https://img-blog.csdnimg.cn/20191011210121313.png)

![https://img-blog.csdnimg.cn/20191011205446812.png](https://img-blog.csdnimg.cn/20191011205446812.png)

![https://img-blog.csdnimg.cn/20191011205452998.png](https://img-blog.csdnimg.cn/20191011205452998.png)

![https://img-blog.csdnimg.cn/20191011205653660.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011205653660.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

> 

  - 根据. in 文件的格式，我们也可以自己设置菜单项和内容，然后在编译时使用。

  - 例如：下面我们在 target/Config-buidl.in 配置文件中加上下面内容（一个 “TEST” 主选项，一个 “This is my test” 子选项，子选项默认值为“y”，帮助内容为“dongshao CSDN url: [https://me.csdn.net/qq_41453285”）。](https://me.csdn.net/qq_41453285”）。)

  - 接着来到来到顶级目录下，输入 “make menuconfig” 进入配置工具选项菜单，可以看到我们修改的内容。

  - 进入 “TEST” 选项。

  - 选择下方的 Help 查看帮助信息。

### 增加自定义模块

![https://img-blog.csdnimg.cn/20191013102133774.png](https://img-blog.csdnimg.cn/20191013102133774.png)

![https://img-blog.csdnimg.cn/20191013103639167.png](https://img-blog.csdnimg.cn/20191013103639167.png)

![https://img-blog.csdnimg.cn/2019101310332770.png](https://img-blog.csdnimg.cn/2019101310332770.png)

![https://img-blog.csdnimg.cn/2019101310333289.png](https://img-blog.csdnimg.cn/2019101310333289.png)

![https://img-blog.csdnimg.cn/20191013103343671.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191013103343671.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

- 保存各种 makefile 文件：

![https://img-blog.csdnimg.cn/20191011222954285.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011222954285.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

> 

  - 在顶层目录下有一个 “Makefile” 脚本，当我们在编译源码时，输入 make 命令，“Makefile”脚本被执行，紧接着. mk 脚本会被顶级目录下的 Makefile 调用，然后这些. mk 脚本会解析 “.config” 文件（.config 文件下面有介绍），并且根据 “.config” 文件的内容来编译相关的内容（例如下载、编译安装 packages 目录下的第三方软件等）。

### .mk 脚本在编译时的作用

![https://img-blog.csdnimg.cn/20191011223353442.png](https://img-blog.csdnimg.cn/20191011223353442.png)

![https://img-blog.csdnimg.cn/2019101122341072.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/2019101122341072.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

![https://img-blog.csdnimg.cn/20191011223046188.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011223046188.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

- 存放各种必要的软件包，可以供二次开放使用。

- 当我们在顶级目录下输入 “./script/feeds update -a、./script/feeds install -a” 命令时更新和下载的就是这个目录下的软件。

- **特性：**我们可以根据自己的需求，在这个目录下新建目录（根据软件类型存放在对应的目录下），然后编写程序和 Makefile 脚本，这样就可以编译生成自己想要的软件了。

![https://img-blog.csdnimg.cn/20191011222943488.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011222943488.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

> 

  - 目录结构分为：**功能目录 --> 软件目录**。例如下面以 “devel” 这个功能模块为例，其目录下有 “gdb、perf、strace” 这些软件。

### 目录结构

![https://img-blog.csdnimg.cn/20191011213918159.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011213918159.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

![https://img-blog.csdnimg.cn/20191011213926613.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011213926613.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

> 

  - 在每一个软件的目录下，都有一个 Makefile 文件。这个 Makefile 脚本会在编译源码时被执行（何时执行？include 目录下的. mk 脚本执行时，.mk 脚本解析. config 脚本，.config 脚本中记录着软件的名称以及是否要安装 “y/n”，如果某个软件选项为 “y”，那么软件的 Makefile 脚本会被执行，于是这个软件就会被下载安装；如果为 “n”，那么就不会被安装）。

  - 小面我们以 gdb 这个软件为例，其目录下有一个 Makefile 文件，Makefile 内有软件的名称、软件版本、要下载的包文件名、下载的软件的名称、软件包的 HASH 算法，软件的名称下载地址。

### Makefile 脚本

![https://img-blog.csdnimg.cn/20191011214020319.png](https://img-blog.csdnimg.cn/20191011214020319.png)

![https://img-blog.csdnimg.cn/20191011215829484.png](https://img-blog.csdnimg.cn/20191011215829484.png)

![https://img-blog.csdnimg.cn/20191011215907522.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011215907522.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

- 目录 scripts 为编译工具脚本文件。

> 

  - 例如 patch-kernel.sh 封装了 patch 命令，在编译时，首先将 patches 目录下的所有补丁文件打上，并且判断如果打补丁失败将退出编译过程。

  - download.pl 为下载源代码的工具脚本，封装下载工具 wget 的选项以及设置从哪里下载。

  - 简述如下：

### 一些比较重要的脚本及功能

<table><tbody><tr><td><strong>脚 本 文 件</strong></td><td><strong>含 义</strong></td></tr><tr><td><strong>scripts/download.pl</strong></td><td>下载编译软件包源代码</td></tr><tr><td><strong>scripts/patch-kernel.sh</strong></td><td>打补丁脚本，并且判断如果打补丁失败将退出编译过程</td></tr><tr><td><strong>scripts/feeds</strong></td><td>收集扩展软件包的工具，用于下载和安装编译扩展软件包工具</td></tr><tr><td><strong>scripts/diffconfig.sh</strong></td><td>收集和默认配置不同之处的工具</td></tr><tr><td><strong>scripts/kconfig.pl</strong></td><td>处理内核配置</td></tr><tr><td><strong>scripts/deptest.sh</strong></td><td>自动 OpenWrt 的软件包依赖项检查</td></tr><tr><td><strong>scripts/metadata.pl</strong></td><td>检查 metadata</td></tr><tr><td><strong>scritps/rstrp.sh</strong></td><td>丢弃目标文件中的符号，这样就将执行文件和动态库变小</td></tr><tr><td><strong>scripts/timestamp.pl</strong></td><td>生成文件的时间戳</td></tr><tr><td><strong>scripts/ipkg-make-index.sh</strong></td><td>生成软件包的 ipkg 索引，在使用 opkg 安装软件时使用</td></tr><tr><td><strong>scripts/ext-toolchain.sh</strong></td><td>工具链</td></tr><tr><td><strong>scripts/strip-kmod.sh</strong></td><td>删除内核模块的符号信息，使文件变小</td></tr></tbody></table>

- 存放用于编译各类平台使用的二进制文件，定义了各类平台编译固件和内核的具体过程。

- 是指目标嵌入式设备，针对不同的平台有不同的特性代码。

![https://img-blog.csdnimg.cn/2019101122071939.png](https://img-blog.csdnimg.cn/2019101122071939.png)

- 例如下面的 “target/linux” 目录是对 Linux 系统的划分，目录下包括 Linux 系统针对于各种平台标准内核的不订及特殊配置（如 ar7、arm 系统）。

![https://img-blog.csdnimg.cn/20191011220727343.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011220727343.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

> 

  - 是一些通用命令 / 工具，用来生成固件的辅助工具，如打补丁工具 patch、编译工具 make 及 squashfs 等。

  - 与 package 目录结构类似，每个工具占一个目录，工具目录下都有该工具下载所对应的 Makefile。

### tools 目录

![https://img-blog.csdnimg.cn/20191011220742532.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011220742532.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

![https://img-blog.csdnimg.cn/20191011220747123.png](https://img-blog.csdnimg.cn/20191011220747123.png)

> 

  - 与 tools 差不多，也是一些工具，编译器和 C 库等（交叉编译工具），例如包含编译工具 gcc 和 glibc 库，在嵌入式交叉编译时有用。

  - 与 package 目录结构类似，每个工具占一个目录，工具目录下都有该工具下载所对应的 Makefile。

### toolchain 目录

![https://img-blog.csdnimg.cn/20191015230410193.png](https://img-blog.csdnimg.cn/20191015230410193.png)

- 进行编译的总体工作。

- 自己开发时，这个 Makefile 不需要改动，因此这个 Makefile 对我们也不重要，只需要大致了解一下即可。

> 

  - 执行 make 时，如果不指定任何目标，因为 world 目标处于第一位，所以默认执行 world。

  - 在 make 时不指定 OPENWRT_BUILD 参数时，进入 ifneq 语句，如果编译时 make OPENWRT_BUILD=1 则进入 else。

  - **进入 ifneq 语句：**

    - 重写 OPENWRT_BUILD 变量并 export 导出 OPENWRT_BUILD 变量。

    - 包含仅顶级目录下 include 目录下的 debug.mk、depends.mk、toplevel.mk。

    - debug.mk：在编译过程中各类信息的输出 （V=s 参数用到）。

    - depends.m：检查当前系统在编译内核阶段所有需要依赖的包是否安装。

    - toplevel.mk：解析编译 world 目标的规则。

  - **toplevel.mk：**主要为了生成下面两个目标（prereq 和 world），在 toplevel.mk180 行开始。

### Makefile 的 world 目标

![https://img-blog.csdnimg.cn/20191015230640648.png](https://img-blog.csdnimg.cn/20191015230640648.png)

![https://img-blog.csdnimg.cn/20191015231318818.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191015231318818.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

![https://img-blog.csdnimg.cn/20191015231409773.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191015231409773.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

```Plain Text
:: prepare-tmpinfo .config

	@make -r -s tmp/.prereq-build 
```

> 

  - “make clean”：删除编译目录。

  - “make dirclean”：除了删除编译目录之外还删除编译工具目录。

  - “make printdb”：输出所有的编译变量定义。

### Makefile 其他目标

![https://img-blog.csdnimg.cn/20191015232000178.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191015232000178.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

![https://img-blog.csdnimg.cn/20191015232219509.png](https://img-blog.csdnimg.cn/20191015232219509.png)

- 这两个是我们自己添加进去的文件。

- script/feeds 脚本文件会调用这两个配置文件，配置文件中定义了大量第三方软件包的下载地址（使用了国内的镜像源，下载速度更快），下图是 script/feeds 脚本文件，可以看到其调用了这两个配置文件。

![https://img-blog.csdnimg.cn/20191016141345115.png](https://img-blog.csdnimg.cn/20191016141345115.png)

> 

  - src-git：通过 git 的方式从后面的链接进行下载。

  - src-cpy：通过 path 进行拷贝 (通过 U 盘更新等)。

  - src-bzr：通过 bzr 的方式从后面的链接进行下载 。

  - src-link：创建一个数据源 path 的 symlink。

  - src-svn：通过 svn 的方式从后面的链接进行下载。

### 配置文件支持的语法：

```Plain Text
-git telephony https://git.lede-project.org/feed/telephony.git^ac6415e61f147a6892fd2785337aec93ddc68fa9
```

- 编译工具链、目标平台的软件包等需要下载的文件都放在 dl 目录下。目标平台和软件包两部分都需要 “build_dir/” 作为编译的临时目录，并且会将目录 staging_dir 作为编译的临时安装目录，最终的生成文件保存在目录 bin 下。

<table><tbody><tr><td><strong>目 录</strong></td><td><strong>含 义</strong></td></tr><tr><td><strong>dl</strong></td><td>下载软件代码包临时目录。编译前，将原始的软件代码包下载到该目录</td></tr><tr><td><strong>feeds</strong></td><td>扩展软件包目录。将一些不常用的软件包放在其他代码库中，通过 feed 机制可以自定义下载及配置</td></tr><tr><td><strong>bin</strong></td><td>编译完成后的最终成果目录。例如安装映像文件及 ipk 安装包</td></tr><tr><td><strong>build_dir</strong></td><td>编译中间文件目录。例如生成的. o 文件</td></tr><tr><td><strong>staging_dir</strong></td><td>编译安装目录。文件安装到这里，并由这里的文件生成最终的编译成果</td></tr><tr><td><strong>log</strong></td><td>如果打开了针对开发人员 log 选项，则将编译 log 保存在这个目录下，否则该目录并不会创建</td></tr><tr><td><strong>tmp</strong></td><td>编译过程的大量临时文件都会在此</td></tr></tbody></table>

- 在 OpenWrt 固件中，几乎所有东西都是**软件包（package）**，可以编译为以 “.ipk” 结尾的安装包，这样就可以很方便地安装、升级和卸载了。注意，扩展软件包不是在主分支中维护的，但是可以使用**软件包编译扩展机制（feeds）来进行扩展安装**。这些包能够扩展基本系统的功能，只需要将它们链接进入主干。之后，这些软件包将会显示在编译配置菜单中。

- 目录 feeds 用于保存扩展软件包，可以使用软件包编译扩展机制来进行扩展安装。这些包能够扩展基本系统的功能，只需要将它们链接进入编译主目录的 package 目录下。 之后，这些**软件包将会显示在配置菜单中。**

- ./sripts/feeds install -a 时，feeds 目录就产生了，安装的软件就存放在这个目录下了。

![https://img-blog.csdnimg.cn/20191016132638669.png](https://img-blog.csdnimg.cn/20191016132638669.png)

- 编译工具链、目标平台的软件包等需要下载的文件都放在 dl 目录下。

- 在编译过程中，各类需要下载的包都保存在这个目录下 (编译过程中用的工具)。

- 当编译的过程中，如果出错，出错的原因是某个软件包下载错误或丢失，可以手动下载对应的软件包（压缩文件形式），并放在这个目录下，之后重新编译。

![https://img-blog.csdnimg.cn/20191016132700705.png](https://img-blog.csdnimg.cn/20191016132700705.png)

> 

  - dl 中存放的是编译过程中需要用到的工具，而 feeds 中存放的是系统编译好之后在系统中需要用的软件。

### dl 目录与 feeds 目录的区别

![https://img-blog.csdnimg.cn/20191016125337302.png](https://img-blog.csdnimg.cn/20191016125337302.png)

- 交叉编译工具的编译中间文件目录。例如生成的. o 文件

> 

  - “build_dir/host” 是一个临时目录，用来储存不依赖于目标平台的工具。

  - tools 目录中各类工具编译的结果存放在 host 中，因此可以看到这些目录的名称与 tools 下的工具名称相同。例如进入一个软件目录，看到其编译结果如下：

### “build_dir/host” 目录

![https://img-blog.csdnimg.cn/20191016140254285.png](https://img-blog.csdnimg.cn/20191016140254285.png)

![https://img-blog.csdnimg.cn/20191016140454603.png](https://img-blog.csdnimg.cn/20191016140454603.png)

> 

  - 用来储存依赖于指定平台的编译工具链。

  - tools-chain 目录交叉编译工具最终编译的结果文件。

### “build_dir/toolchain-*” 目录

> 

  - 目标平台和软件包两部分都需要 “build_dir/” 作为编译的临时目录。

### “build_dir/<arch>” 目录

![https://img-blog.csdnimg.cn/20191016140541237.png](https://img-blog.csdnimg.cn/20191016140541237.png)

![https://img-blog.csdnimg.cn/2019101613293825.png](https://img-blog.csdnimg.cn/2019101613293825.png)

- staging_dir 作为编译的临时安装目录

> 

  - 是编译工具链的最终安装位置。

  - 通常我们不需要改动编译链目录下的任何东西，除非要更新编译工具版本等。

### “staging_dir/toolchain-*” 目录

![https://img-blog.csdnimg.cn/20191016140759285.png](https://img-blog.csdnimg.cn/20191016140759285.png)

> 

  - tools、toolchain 目录中的编译中间文件存放在 buidl_dir 目录下。例如生成的. o 文件等。

  - buidl_dir 目录存放的软件编译文件，最终安装在 staging_dir 目录下，因此 staging_dir 目录为编译安装目录，文件安装到 staging_dir 目录，并由 staging_dir 目录的文件生成最终的编译成果。

  - **所以：****流程是：tools、toolchain==> 编译到 build_dir 中 ==> 安装到 staging_dir 中。**

### tools、toolchain、build_dir、staging_dir 四者的关系

- 编译完成后的最终成果目录。例如安装映像文件及 ipk 安装包。

![https://img-blog.csdnimg.cn/20191016172532810.png](https://img-blog.csdnimg.cn/20191016172532810.png)

> 

  - 这个目录下主要保存我们编译生成的系统软件包（.ipk）。

  - 我们进入 packages 目录。

  - 在进入 i386_pentium4 目录，可以看到有软件包的分类目录。

  - 进入 base 软件包目录（一些系统基础的软件），进入之后可以看到很多我们在编译时选择的很多软件生成的软件包。

  - 进入 luci 软件包目录，我们在编译时选择了生成 luci 软件，可以看到目录下一些的 luci 软件包。

  - 进入 packages 目录，其中也有一些文件。

### packages 目录

![https://img-blog.csdnimg.cn/20191016172552818.png](https://img-blog.csdnimg.cn/20191016172552818.png)

![https://img-blog.csdnimg.cn/20191016172559482.png](https://img-blog.csdnimg.cn/20191016172559482.png)

![https://img-blog.csdnimg.cn/20191016172706407.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191016172706407.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

![https://img-blog.csdnimg.cn/20191016172720718.png](https://img-blog.csdnimg.cn/20191016172720718.png)

![https://img-blog.csdnimg.cn/20191016172857452.png](https://img-blog.csdnimg.cn/20191016172857452.png)

> 

  - 这个目录保存我们的系统镜像文件（按照系统的类别分类）。

  - 我们在 make menuconfig 时选择了 x86 平台，就进入 targets 目录之后就可以看到一个属于 x86 平台的目录。

  - 进入 x86 平台的目录，其中有一个 generic 目录，再进入 generic 目录，可以看到其中有一系列我们可以使用的 openwrt 系统的镜像文件（备注：不同的镜像文件特点是什么见文章：[https://blog.csdn.net/qq_41453285/article/details/101223847](https://blog.csdn.net/qq_41453285/article/details/101223847)）。

### targets 目录

![https://img-blog.csdnimg.cn/20191016172952933.png](https://img-blog.csdnimg.cn/20191016172952933.png)

![https://img-blog.csdnimg.cn/20191016173005524.png](https://img-blog.csdnimg.cn/20191016173005524.png)

![https://img-blog.csdnimg.cn/20191016125903642.png](https://img-blog.csdnimg.cn/20191016125903642.png)

- 如果打开了针对开发人员 log 选项，则将编译 log 保存在这个目录下，否则该目录并不会创建。

- 编译过程的大量临时文件都会在此。

![https://img-blog.csdnimg.cn/20191016135819401.png](https://img-blog.csdnimg.cn/20191016135819401.png)

> 

  - 编译源码时，输入 “make defconfig” 之后会生成一个 “.config” 文件，内容大致如下：

  - **文件的内容是什么，从何处来？**这个. config 会读取 config 目录下的 4 个配置文件（Config-build.in、Config-devel.in、Config-images.in、Config-kernel.in），根据. in 文件中的设置生成对应的 “选项” 与选项对应的“内容 / 值”。

  - 例如上面图中我们. config 文件读取的 “Config-Images.in” 文件的内容中，“CONFIG_TARGET_ROOTFS_EXT4FS”设置为 “y”，“CONFIG_TARGET_EXT4_RESERVED_PCT” 被设置为 “0”，都是读取“Config-Images.in” 文件获取的（下图是 Config-Images.in 的内容）。

  - **该文件何时被用到？**当我们在编译源码时，输入 “make menuconfig” 进入配置工具选项菜单，此时就会读取这个 “.config” 文件，并根据 “.config” 文件的内容设置选项的默认值。例如上面的 “.config” 文件中 “ext4” 选项默认为 “y”，配置选项菜单时“ext4” 前面默认有个 “*” 号就代表被选中；“ext4”选项的子选项 "Percentage of reserved blocks in root filesystem" 默认值为“0”，可以看到其默认值就为“0”。

  - **.config 内容的修改：**上面说过配置工具选项菜单会读取. config 的内容，因此在配置工具选项菜单中修改的内容保存也是在这个配置文件中。例如上面将上面的那个 “ext4” 选项取消，可以看到在右侧的 “.config” 文件中 “Root filesystem images” 下方的那 3 个选项消失了。

### .config 配置文件

![https://img-blog.csdnimg.cn/20191013094504588.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191013094504588.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

![https://img-blog.csdnimg.cn/20191013095636719.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191013095636719.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

![https://img-blog.csdnimg.cn/20191013095724997.png](https://img-blog.csdnimg.cn/20191013095724997.png)

![https://img-blog.csdnimg.cn/20191013095731154.png](https://img-blog.csdnimg.cn/20191013095731154.png)

![https://img-blog.csdnimg.cn/20191013100531969.png](https://img-blog.csdnimg.cn/20191013100531969.png)

![https://img-blog.csdnimg.cn/20191013100451440.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191013100451440.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

> 

  - OpenWrt 在构建时首先下载代码，就是使用 scripts/download.pl 脚本进行下载。

  - 这个下载功能最重要的接口是我们可以通过 “scripts/localmirrors” 文件自定义软件包 下载地址，方便开发人员进行设置。

  - 最近有很多 iPhone/Android 编译工具爆出后门问题，就是因为使用其他第三方镜像地 址文件来下载编译工具，但没有对下载的软件内容进行 MD5 值对比，从而导致编译的应 用程序感染后门。OpenWrt 的下载检查机制从源头上解决了这类问题。在我开发 OpenWrt 时也发现了下载的一些内容被感染的问题，但检查机制丢弃了不正确的内容，从下一个的 镜像网站上继续下载。

  - <target dir>：为下载之后的保存位置，下载代码通常均保存在 dl 目录下。

  - <filename>：待下载的文件名。

  - <md5sum>：下载内容的 MD5，用于校验下载文件是否正确。

  - <mirror>：为可选的参数，是下载文件的镜像地址，可以有多个地址，优先选择第一个， 如果下载失败则顺序选择后面的地址。

  - 该程序由 Perl 语言开发出来，代码并不复杂。代码首先进行初始条件检查，判断参数 是否足够，至少需要 3 个参数分别为下载文件保存位置、下载文件名及下载内容 MD5 值。

  - 接着从命令行参数中顺序读取数据，并赋值给局部变量，最后判断 md5sum 或 md5 工具是否存在，如果不存在提示工具不存在后退出。

  - 紧接着调用 localmirrors()函数读取本地的源码镜像地址，我们可以在企业内部创建自 己的代码镜像服务器，然后将镜像地址放在 “scripts/localmirrors” 文件中，这样我们就不 用每次编译时都从互联网上去下载了。例如我这里修改如下：

  - 紧接着遍历命令行并将代码中的镜像地址加到备选镜像中。

  - 最后使用 while 循环进行下载，如果下载完成就对下载文件的 MD5 进行对比，如果 MD5 值一致则退出循环，否则 进入下一个镜像地址进行下载。下载成功后调用 cleanup() 函数来清理临时变量。

### “scripts/download.pl” 下载工具

**使用方法如下：**

```Plain Text
./download.pl <target dir> <filename> <md5sum> [<mirror> ...]

```

**代码解析：**

![https://img-blog.csdnimg.cn/20191011225721112.png](https://img-blog.csdnimg.cn/20191011225721112.png)

```Plain Text
://192.168.1.106:8080/openwrt/

://mirror.bjtu.edu.cn/gnu/
```

![https://img-blog.csdnimg.cn/20191011225930635.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011225930635.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

![https://img-blog.csdnimg.cn/20191011230021329.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011230021329.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

![https://img-blog.csdnimg.cn/20191011230110223.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20191011230110223.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

> 

  - OpenWrt 的代码包中大多均有 patches 目录。下载代码包完成后进行打补丁，采用的 就是 patck-kernel.sh 脚本。

  - 脚本的第一个参数为编译代码目录，第二个为补丁目录。

  1. **调用脚本形式举例如下：**

  - **上述命令执行流程如下：**

    - ①首先进行参数赋值，第一个参数为代码目录，第二个参数为补丁目录

    - ②第二步判定代码目录和补丁目录是否存在，如果不存在则提示错误并退出。

    - ③遍历补丁文件，根据后缀判断补丁文件类型。

    - ④调用 patch 命令应用补丁

    - ⑤检查补丁应用是否正确，如果存在 “*.rej” 文件表示出现错误，返回 “1” 并退出。

    - ⑥最后检查如果存在应用补丁后的备份文件，则删除备份文件

### “patch-kernel.sh” 脚本

```Plain Text
../scripts/patch-kernel.sh iproute2-3.3.0 ../package/iproute2/patches/

```

> 

  - 传统的 Linux 操作系统在编译某一个软件的时候，会检查其依赖软件及头文件是否存在，如果没有安装，则会报缺少头文件或缺少链接库等错误，编译将退出。这种机制使得 开发者在编译一个软件之前，需要查找该软件所需的依赖库及头文件，并手动去安装这些 软件。有时候碰到比较娇贵的软件时，嵌套式的安装依赖文件，会使得开发者头昏脑胀。 OpenWrt 通过引入 feeds 机制，很好地解决了这个问题。

  - feeds 是 OpenWrt 开发所需要的软件包套件的工具及更新地址集合，这些软件包通过 一个统一的接口地址进行访问。这样用户可以不用关心扩展包的存储位置，可以减少扩展 软件包和核心代码部分的耦合。它由两部分组成，即扩展包位置配置文件 feeds.conf.default 和脚本工具 feeds。

  - ‘LuCI’OpenWrt 默认的 Web 浏览器图形用户接口。

  - ‘routing’一些额外的基础路由器特性软件，包含动态路由 Quagga 等。

  - ‘telephony’IP 电话相关的软件包，例如 freeswitch 和 Asterisk 等。

  - ‘management’TR069 等各种管理软件包。

  - 上述操作，就是利用 feeds 提供的接口将 OpenWrt 所需的全部扩展软件包进行下载并 安装。在更新时，需要能够访问互联网。在下载之前可以通过查看 “feeds.conf.default” 文 件，来检查哪些文件需要包含在编译环境中。

  - **update：**下载在 feeds.conf 或 feeds.conf.default 文件中的软件包列表并创建索引。-a 表 示更新所有的软件包。只有更新后才能进行后面的操作

  - **list：**从创建的索引文件 “feed.index” 中读取列表并显示。只有进行更新之后才能查 看列表

  - **install：**安装软件包以及它所依赖的软件包，从 feeds 目录安装到 package 目录，即在 “package/feeds” 目录创建软件包的软链接。只有安装之后，在后面执行 “make menuconfig” 时，才可以对相关软件包是否编译进行选择

  - **search：**按照给定的字符串来查找软件包，需要传入一个字符串参数。

  - **uninstall：**卸载软件包，但它没有处理依赖关系，仅仅删除本软件包的软链接。

  - **clean：**删除 update 命令下载和生成的索引文件，但不会删除 install 创建的链接。

  - 这个命令首先读取并解析 feeds.conf 配置文件，然 后执行相应的命令，例如 install 时，将安装应用程序包和它所有直接或间接依赖的所有软件包。安装时将创建一个符号链接，从 packages/feeds/$feed_name/$package_name 指 feeds/$feed_name/$package_name， 这样在 “make menuconfig” 时，feeds 的软件包就可 以被处理到，就可以选择编译了。

  - 例如 “luci-app-firewall” 指向“feeds/luci/applications/luciapp-firewall”：

  - 用一句话来说，编译扩展安装过程就是将 feeds 目录下的软件包链接到 packages/feeds 对应目录下。可使用的 feeds 列表配置为 feeds.conf 或者 feeds.conf.default。优先选择 feeds.conf 文件，这个文件包含了扩展安装源列表，每一行由 3 部分组成，包含 feed 方法、 feed 名字和 feed 源。

  - 下面是一个扩展安装源配置文件的例子：

  - 我们可以修改该文件使编译时从自己指定的位置进行下载。主要支持 feed 方法的类型有以下 3 种：

    - src-cpy：通过从数据源路径复制数据。

    - src-git：通过使用 Git 从代码仓库地址下载代码数据。

    - src-svn：通过使用 SVN 从代码仓库地址下载代码数据。

### 编译扩展机制 feeds

**目前在配置文件中保存最重要的扩展软件包集合有以下 4 个：**

**在前面编译 OpenWrt 源码之前，我们做了如下的操作：**

```Plain Text
./scripts/feeds update –a

./scripts/feeds install -a
```

**feeds 工具用法如下：**

```Plain Text
./scripts/feeds install luci-app-firewall
```

**feeds 代码处理流程：**

```Plain Text
kage/feeds/luci/luci-app-firewall -alht

```

**相关配置文件：**

```Plain Text
-git luci https://github.com/openwrt/luci.git;for-15.05

-git routing https://github.com/openwrt-routing/packages.git;for15.05

-git telephony https://github.com/openwrt/telephony.git;for-15.05

-gitmanagement https://github.com/openwrt-management/packages.git;for-15.05
```

---

- 我是小董，V 公众点击 "笔记白嫖" 解锁更多 OpenWrt 资料内容。

![https://img-blog.csdnimg.cn/20210405083343721.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70](https://img-blog.csdnimg.cn/20210405083343721.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

