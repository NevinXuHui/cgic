---
url: https://blog.csdn.net/baidu_38661691/article/details/94732843
title: buildroot 详解和分析_Alex-wu 的博客 - CSDN 博客
date: 2023-04-04 15:11:25
tag: 
banner: "https://imgconvert.csdnimg.cn/aHR0cHM6Ly9pbWcyMDE4LmNuYmxvZ3MuY29tL2Jsb2cvMTA4MzcwMS8yMDE4MDkvMTA4MzcwMS0yMDE4MDkyNTA4MzA0NjQ4MS0yMDUyMzQyNjQ1LnBuZw"
banner_icon: 🔖
---
**buildroot 是 Linux 平台上一个构建嵌入式 Linux 系统的框架。**

**整个 Buildroot 是由 Makefile 脚本和 Kconfig 配置文件构成的。**

**可以和编译 Linux 内核一样，通过 buildroot 配置，menuconfig 修改，编译出一个完整的可以直接烧写到机器上运行的 Linux 系统软件 (包含 boot、kernel、rootfs 以及 rootfs 中的各种库和应用程序)。**

**buildboot 也可以单独通过配置和使用交叉编译链工具来实现制作一个 Linux 文件系统。**

### buildroot 准备工作

**下载地址**： [http://buildroot.uclibc.org/download.html（官网）](http://buildroot.uclibc.org/download.html%EF%BC%88%E5%AE%98%E7%BD%91%EF%BC%89) ，

[https://github.com/buildroot/buildroot（github）](https://github.com/buildroot/buildroot%EF%BC%88github%EF%BC%89) 。

**硬件支持**： Linux 系统的电脑或者装有 Linux 虚拟机的电脑 。

**解压过程**：

1.  选择好相应的目录，将下载的压缩包放置在其下
2.  解压：`tar -xzvf buildroot-2017.02.9.tar.gz`

**大致使用流程**：

1.  选择一个 defconfig；
2.  根据需要配置 buildroot；
3.  编译 buildroot；
4.  在目标板上运行 buildroot 构建的系统。

### buildroot 目录介绍

解压之后，我们可以看到以下的目录情况：

```
├── arch:   存放CPU架构相关的配置脚本，如arm/mips/x86,这些CPU相关的配置，在制作工具链时，编译uboot和kernel时很关键.
├── board   存放了一些默认开发板的配置补丁之类的
├── boot
├── CHANGES
├── Config.in
├── Config.in.legacy
├── configs:  放置开发板的一些配置参数. 
├── COPYING
├── DEVELOPERS
├── dl:       存放下载的源代码及应用软件的压缩包. 
├── docs:     存放相关的参考文档. 
├── fs:       放各种文件系统的源代码. 
├── linux:    存放着Linux kernel的自动构建脚本. 
├── Makefile
├── Makefile.legacy
├── output: 是编译出来的输出文件夹. 
│   ├── build: 存放解压后的各种软件包编译完成后的现场.
│   ├── host: 存放着制作好的编译工具链，如gcc、arm-linux-gcc等工具.
│   ├── images: 存放着编译好的uboot.bin, zImage, rootfs等镜像文件，可烧写到板子里, 让linux系统跑起来.
│   ├── staging
│   └── target: 用来制作rootfs文件系统，里面放着Linux系统基本的目录结构，以及编译好的应用库和bin可执行文件. (buildroot根据用户配置把.ko .so .bin文件安装到对应的目录下去，根据用户的配置安装指定位置)
├── package：下面放着应用软件的配置文件，每个应用软件的配置文件有Config.in和soft_name.mk，其中soft_name.mk(这种其实就Makefile脚本的自动构建脚本)文件可以去下载应用软件的包。
├── README
├── support
├── system
└── toolchain

```

### buildroot 配置

通过 make xxx_defconfig 来选择一个 defconfig，这个文件在 config 目录下。

然后通过 make menuconfig 进行配置：

```
Target options  --->选择目标板架构特性。
Build options  --->配置编译选项。
Toolchain  ---> 配置交叉工具链，使用buildroot工具链还是外部提供。
System configuration  --->  系统配置
Kernel  ---> 配置内核
Target packages  ---> 
Filesystem images  --->配置文件系统
Bootloaders  --->硬件启动程序
Host utilities  --->
Legacy config options  --->

```

### make 命令解析

通过 make help 可以看到 buildroot 下 make 的使用细节，包括对 package、uclibc、busybox、linux 以及文档生成等配置：

```
Cleaning:
  clean                  - delete all files created by build----------------------------------------清理
  distclean              - delete all non-source files (including .config)

Build:
  all                         - make world----------------------------------------------编译整个系统
  toolchain              - build toolchain------------------------------------------编译工具链

Configuration:
  menuconfig             - interactive curses-based configurator--------------------------------对整个buildroot进行配置
  savedefconfig          - Save current config to BR2_DEFCONFIG (minimal config)----------------保存menuconfig的配置

Package-specific:-------------------------------------------------------------------------------对package配置
  <pkg>                  - Build and install <pkg> and all its dependencies---------------------单独编译对应APP
  <pkg>-source           - Only download the source files for <pkg>
  <pkg>-extract          - Extract <pkg> sources
  <pkg>-patch            - Apply patches to <pkg>
  <pkg>-depends          - Build <pkg>'s dependencies
  <pkg>-configure        - Build <pkg> up to the configure step
  <pkg>-build            - Build <pkg> up to the build step
  <pkg>-show-depends     - List packages on which <pkg> depends
  <pkg>-show-rdepends    - List packages which have <pkg> as a dependency
  <pkg>-graph-depends    - Generate a graph of <pkg>'s dependencies
  <pkg>-graph-rdepends   - Generate a graph of <pkg>'s reverse dependencies
  <pkg>-dirclean         - Remove <pkg> build directory-----------------------------------------清除对应APP的编译目录
  <pkg>-reconfigure      - Restart the build from the configure step
  <pkg>-rebuild          - Restart the build from the build step--------------------------------单独重新编译对应APP

busybox:
  busybox-menuconfig     - Run BusyBox menuconfig

uclibc:
  uclibc-menuconfig      - Run uClibc menuconfig

linux:
  linux-menuconfig       - Run Linux kernel menuconfig-----------------------------------------配置Linux并保存设置
  linux-savedefconfig    - Run Linux kernel savedefconfig
  linux-update-defconfig - Save the Linux configuration to the path specified
                             by BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE

Documentation:
  manual                 - build manual in all formats
  manual-pdf             - build manual in PDF
  graph-build            - generate graphs of the build times----------------------------------对编译时间、编译依赖、文件系统大小生成图标
  graph-depends          - generate graph of the dependency tree
  graph-size             - generate stats of the filesystem size

```

### buildroot 工作原理

# **Buildroot 原则上是一个自动构建框架，虽然说 u-boot、**~linux kernel~ **这些经典的开源软件包的构建脚本，官方社区都在帮你实现了，但是有时候你还是需要加入你自己特有的 app_pkg 软件包，用以构建自己的应用。**

**buildroot 的编译流程是先从 dl/xxx.tar 下解压出源码到 output/build/xxx, 然后它利用本身的配置文件 (如果有的话) 覆盖 output/build/xxx 下的配置文件, 在开始编译连接完成后安装到 output / 相应文件夹下。**

Buildroot 提供了函数框架和变量命令框架，采用它的框架编写的 app_pkg.mk 这种 [Makefile](https://so.csdn.net/so/search?q=Makefile&spm=1001.2101.3001.7020) 格式的自动构建脚本，将被 package/pkg-generic.mk 这个核心脚本展开填充到 buildroot 主目录下的 Makefile 中去。最后 make all 执行 Buildroot 主目录下的 Makefile，生成你想要的 image。

package/pkg-generic.mk 中通过调用同目录下的 pkg-download.mk、pkg-utils.mk 文件，已经帮你自动实现了下载、解压、依赖包下载编译等一系列机械化的流程。你只要需要按照格式写 Makefile 脚 app_pkg.mk，填充下载地址，链接依赖库的名字等一些特有的构建细节即可。

总而言之，Buildroot 本身提供构建流程的框架，开发者按照格式写脚本，提供必要的构建细节，配置整个系统，最后自动构建出你的系统。

![](1680592285704.png)

**buildroot/packages 里面有丰富的应用软件的配置文件，可以通过 make menuconfig，出现图形化界面进行选择丰富的开源软件包的编译和构建。**

对 buildroot 的配置通过 Config.in 串联起来，起点在根目录 Config.in 中:配置选项 Config.in 位置 Target optionsarch/Config.inBuild options[Config.in](http://Config.in)Toolchaintoolchain/Config.inSystem configurationsystem/Config.inKernellinux/Config.inTarget packagespackage/Config.inTargetpackages->BusyboxFilesystem imagesfs/Config.inBootloadersboot/Config.inHost utilitiespackage/Config.in.hostLegacy config optionsConfig.in.legacy

### 配置 Kernel 内核

**对 Linux 内核的配置包括两部分：通过 make menuconfig 进入 Kernel 对内核进行选择，通过 make linux-menuconfig 对内核内部进行配置。**

#### 内核配置

进入 buildroot 目录，输入 make menuconfig，选然后选择 Kernel 进行配置, 如图：

*   ![](1680592286049.png)“Kernel version” 选择内核的版本；
*   “Defconfig name” 选择内核 config 文件；
*   “Kernel binary formant” 选择内核格式；
*   “Device tree source file names” 选择 DT 文件；
*   “Linux Kernel Tools” 中选择内核自带的工具，比如 perf；
*   可以选择 “Custom Git repository” 来指定自己的 Git 库，在 “Custom repository version” 中指定 branch 名称。
*   选择 “Using an in-tree defconfig file”，在“Defconfig name” 中输入 defconfig 名称，注意不需要末尾_defconfig。
*   选择 “Use a device tree present in the kernel”，在“Device Tree Source file names” 中输入 dts 名称，不需要. dts 扩展名。
*   “Kernel binary format” 可以选择 vmlinux 或者 uImage。
*   uImage 是 uboot 专用的映像文件，它是在 zImage 之前加上一个长度为 64 字节的 “头”，说明这个内核的版本、加载位置、生成时间、大小等信息；其 0x40 之后与 zImage 没区别。
*   zImage 是 ARM Linux 常用的一种压缩映像文件，uImage 是 U-boot 专用的映像文件，它是在 zImage 之前加上一个长度为 0x40 的 “头”，说明这个映像文件的类型、加载位置、生成时间、大小等信息。
*   vmlinux 编译出来的最原始的内核 elf 文件，未压缩。
*   zImage 是 vmlinux 经过 objcopy gzip 压缩后的文件， objcopy 实现由 vmlinux 的 elf 文件拷贝成纯二进制数据文件。
*   uImage 是 U-boot 专用的映像文件，它是在 zImage 之前加上一个长度为 0x40 的 tag。
*   选择 vmlinux 和 uImage 的区别在于：

```
   PATH="/bin..." 
   BR_BINARIES_DIR=/home/.../output/images /usr/bin/make -j9 
   HOSTCC="/usr/bin/gcc" 
   HOSTCFLAGS="" 
   ARCH=csky 
   INSTALL_MOD_PATH=/home/.../output/target 
   CROSS_COMPILE="/home/.../output/host/bin/csky-abiv2-linux-" 
   DEPMOD=/home/.../output/host/sbin/depmod 
   INSTALL_MOD_STRIP=1 -C /home/.../linux uImage

```

如果是 vmlinux，在结尾就是 vmlinux。

#### 内核内部配置

通过 make linux-menuconfig 可以对内核内部细节进行配置。

让 Linux 内核带符号表：

```
    CONFIG_COMPILE_TEST is not set
    CONFIG_DEBUG_INFO=y

```

### 配置文件系统

*   对目标板文件系统内容进行配置主要通过 make menuconfig 进入 Target packages 进行。
*   在 Filesystem images 中配置文件系统采用的格式，以及是否使用 RAM fs。

### 配置 Uboot

使用 uboot 作为 bootloader，需要进行一些配置。

在选中 U-boot 作为 bootloader 之后，会弹出一系列相关配置。

*   “U-Boot board name” 配置 configs 的 defconfig 名称。
*   “U-Boot Version”选择 Custom Git repository，然后在 “URL of custom repository” 中选择自己的 git 地址，并在 “Custom repository version” 中选择 git 的分支。
*   在 “U-Boot binary format” 中选择想要输出的 image 格式，比如 u-boot.img 或者 u-image.bin。
*   还可以选择 “Intall U-Boot SPL binary image”，选择合适的 SPL。
*   ![](1680592286215.png)