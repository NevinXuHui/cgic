---
url: https://blog.csdn.net/weixin_43789722/article/details/103029397
title: 一、openwrt 结构分析_openwrt 系统架构_暴躁的河马的博客 - CSDN 博客
date: 2023-04-04 15:18:50
tag: 
banner: "https://img-blog.csdnimg.cn/20191112151318423.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzc4OTcyMg==,size_16,color_FFFFFF,t_70"
banner_icon: 🔖
---
# [openwrt](https://so.csdn.net/so/search?q=openwrt&spm=1001.2101.3001.7020) 系统宏观结构

## openwrt 目录结构

### 1. config 存着系统的配置文件

.in —> .config----> 编译脚本解析  
CONFIG_HAVE_DOT_CONFIG = y 等等  
作用：控制整个编译过程，是整个系统的配置文件，如果需要增加新的编译选  
项，需要按照 config.in 文件格式进行设计

```
Config-build.in  		 //单纯去编译的最基本的配置文件
config-devel.in			//用于开发的配置文件，基于源码开发
config-images.in		//基于生成某种镜像
config-kernel.in		//内核包括文件系统
所有的 .in文件会生成 .config 文件

```

*   **config-images.in**  
    
    ![](1680592730970.png)
    

```
/* 	镜像不等于编译，bulid后生成的 elf文件	*/
*镜像与编译的区别*
elf	-->	image

对elf文件进行压缩放进镜像体里，把压缩算法的实现放在
镜像头里，运行时，先用自定义格式的内容的镜像头来解
压缩 镜像体，解压后释放进内存里运行

```

*   config-bulid.in  
    用于管理各种文件，在以后安装模块时用

```
```bash
menu "Global build settings"

	config ALL_NONSHARED
		bool "Select all target specific packages by default"
		default ALL || BUILDBOT

	config ALL_KMODS
		bool "Select all kernel module packages by default"
		default ALL

	config ALL
		bool "Select all userspace packages by default"
		default n

	config BUILDBOT
		bool "Set build defaults for automatic builds (e.g. via buildbot)"
		default n
		help
		  This option changes several defaults to be more suitable for
		  automatic builds. This includes the following changes:
		  - Deleting build directories after compiling (to save space)
		  - Enabling per-device rootfs support

```

*   在 .config 文件中最关键的是 y 和 n 和其他关键字选项
*   脚本会使用它，# 代表注释

```
# CONFIG_TARGET_ar7 is not set
# CONFIG_TARGET_omap is not set
# CONFIG_TARGET_uml is not set
# CONFIG_TARGET_zynq is not set
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_generic=y
# CONFIG_TARGET_x86_legacy is not set
# CONFIG_TARGET_x86_geode is not set
# CONFIG_TARGET_x86_64 is not set
CONFIG_TARGET_x86_generic_Generic=y
CONFIG_HAS_SUBTARGETS=y
CONFIG_TARGET_BOARD="x86"
CONFIG_TARGET_SUBTARGET="generic"
CONFIG_TARGET_PROFILE="Generic"
CONFIG_TARGET_ARCH_PACKAGES="i386_pentium4"
CONFIG_DEFAULT_TARGET_OPTIMIZATION="-Os -pipe -march=pentium4"
CONFIG_CPU_TYPE="pentium4"
CONFIG_LINUX_4_4=y
CONFIG_DEFAULT_base-files=y
CONFIG_DEFAULT_busybox=y
CONFIG_DEFAULT_dnsmasq=y


```

*   比如我们可以自己设置选项 在 config-build.in 文件中

```
//设置选项 
menu "helloworld"

endmenu
menu "Global build settings"

	config ALL_NONSHARED
		bool "Select all target specific packages by default"
		default ALL || BUILDBOT

```

*   make menuconfig  
    
    ![](1680592731074.png)
    
      
    这里就会出现 helloworld 的 选项，至于它所属的子选项

```
menu "helloworld"
	config MY_TEST
	bool "Select all target specific packages by default"
	default n  //bool默认值
	help
		helloman 

endmenu

```

![](1680592731405.png)

  
此时有了子选项  

![](1680592731493.png)

  
选择 HELP 选项，出现下面的画面  

![](1680592731584.png)

### 2. include 文件

*   存放着 openwrt 的 makefile 的 头文件 是一个编译控制脚本
*   上层 makefile 可以包含下层 makefile
*   总 Makefile ----> 去执行 /include/.mk  
    (Makefile 脚本文件)
*   作用提供 makefile 的编译脚本，控制整个编译过程，解析. config 文件，生成部分变量，完成各个模块的编译  
    
    ![](1680592731670.png)
    
      
    这是个总的 MAKEFILE  
    
    ![](1680592731753.png)
    
*   总的 makefile 里包含大量的 .mk 文件

```
include文件里面定义了一个模块里的细节结构的构成

```

![](1680592732103.png)

### 3. package 软件包

*   用来放置各种安装的软件包，要更新的软件全放在这里

类型目录—功能目录—软件目录

第三方软件的 Makefile 模板  
作用：提供了第三方软件的版本、下载地址、编译方法、安装地址，具有标准模板，第三方软件需要按照标准模板，自行添加软件编译脚本

*   如果本地没有的安装包，它会提供 URL 镜像地址下载  
    
    ![](1680592732185.png)
    
*   根据下载的包的类型来进行解压  
    
    ![](1680592732266.png)
    
*   根据包的依赖来不同下载的依赖下载安装  
    
    ![](1680592732348.png)
    
      
    
    ![](1680592732436.png)
    

### 4. scripts

存放一些脚本，如 python，JavaScript 等  
所有在编译过程中使用的脚本都会存放在此目录  
批量更新或安装的包

### 5. target

存放用于编译各类 cpu 的平台使用的二进制文件，定义了各类平台的编译固件和内核的具体过程

### 6. tools

通用的编译工具

### 7. toolchain

嵌入式交叉编译工具

### 8. Makefile

顶层 Makefile 不怎么需要改

### 9. rules_mk

定义了系统 Makefile 使用的各类变量和函数

### 10. feeds.conf.deafult

feeds.conf.default  
由脚本文件 feeds 使用的配置文件，配置文件中定义了大量第三方软件包的下载地址

### 11. dl 文件夹

1.1 在编译过程中，各类编译工具下载包都保存在这个目录下  
1.2 当编译过程卡在了某个包下载问题时，可以手动下载并存放在  
dl 包中  
1.3 当下载的包特别慢的时候，可以修改的镜像下载地址  

![](1680592732783.png)

# Example

```
1.开发一个第三方的应用程序，只需要实现helloworld
	1.1 在package目录下创建专属的文件夹
	1.2 在专属文件夹下进行Makefile创建，以及源码的添加
	1.3 利用make menuconfig 进行相关包的选择
	1.4 开始系统编译
	1.5 bin/package找到对应第三方的（.ipk）包
	1.6 使用软件安装程序进行ipk包的安装

```

### 12. feeds

1.1 编译过程产生的  
1.2 系统的软件管理包，所有的第三方应用软件包，所有下载的软件包（openwrt 系统自用）

```
		./sripts/feeds update -a     更新包
 		./sripts/feeds install -a    去安装这个包

```

### 13. build_dir

![](1680592733154.png)

在编译过程中产生的工具，交叉编译工具，最终的目标文件等都会存在此目录

```
> host ： tools文件中各类工具编译链的结果存在host中
> target-xxxx：编译完成的目录文件，包含系统的各类软件包，
  内核，文件系统等
> toolchain-xxx：tools_chain交叉编译工具最终编译的结果
  文件

```

### 14. bin

编译完成后，所有的 ipk 包，所有的内核镜像文件都会在此  
编译成对应的指令集  
x86 gcc  
arm arm-linux-gcc  
mips mips-linux-gcc  

![](1680592733244.png)

### 15. staging_dl

1.1 存放 build_dir 文件中各类编译成功的软件，所以和 build_dir 中的目录 结构相同，最终编译存放编译结果的地方  
、、  
1.2 各类系统库，头文件等都在该文件下，在自行开发 ipk 时，编译过程中头文件，链接动态库，链接的静态库都会保存在该子文件下

### 16. tmp

编译过程的大量临时文件都会在此

### 17. logs

报错日志，提醒编译过程中产生的错误

# Openwrt 系统微观结构

```
1. feeds.config.deafult
2. 	feed支持的类型：
		src-git		通过git的方式从后面的链接进行下载
		src-cpy		通过path进行拷贝（通过U盘更新，本地镜像站）
		src-bzr		通过bzr的方式从后面的链接进行下载
		src-link	创建一个数据源path的symlink
		src-svn		通过svn的方式从后面的链接进行下载

```

```
	标准语法：
src-git packages https://git.lede-project.org/feed/packages.git^cd5c448758f30868770b9ebf8b656c1a4211a240
src-git luci https://git.lede-project.org/project/luci.git^d3f0685d63c1291359dc5dd089c82fa1e150e0c6
src-git routing https://git.lede-project.org/feed/routing.git^d11075cd40a88602bf4ba2b275f72100ddcb4767
src-git telephony https://git.lede-project.org/feed/telephony.git^ac6415e61f147a6892fd2785337aec93ddc68fa9

```

```
1. main Makefile
	world:
		1. 在执行make时，如果不指定任何目标，则默认目标是world
		2. 如果在MAKE时不指定OPENWRT_BUILD参数时，进入第一个逻
			辑，如果进行make OPENWRT_BUILD=1 则进入第二个逻辑
			make V=s -j4 不会指定OPENWRT_BUILD的变量
	第一个逻辑：
		make V=s
			include $(TOPDIR)/include/debug.mk  在编译过程中各个错误
			include $(TOPDIR)/include/depends.mk 检查当前系统在编译内核阶段所有需要依赖的包是否安装
			include $(TOPDIR)/include/toplevel.mk  解析编译的	

```

.

*   当按下 make V=s -j4 时，会执行下面 toplevel.mk 文件

```
prereq:: perpare-tmpinfo .config
	@make -r -s tmp/.prereq-build
	@make V=ss -r -s
prereq %:
	@make 	V=ss -r -s
	@make  -w -r world
目的为了生成prereq 和 world 这两个目标

```