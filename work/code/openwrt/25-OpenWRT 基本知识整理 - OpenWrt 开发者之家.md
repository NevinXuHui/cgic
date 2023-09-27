---
url: https://www.openwrt.pro/post-170.html
title: OpenWRT 基本知识整理 - OpenWrt 开发者之家
date: 2023-04-04 15:25:40
tag: 
banner: "undefined"
banner_icon: 🔖
---
目录：

[1.OpenWRT 虚拟系统准备… 3](#_Toc426631143)

[1.1. 编译 openwrt 虚拟机系统… 3](#_Toc426631144)

[1.1.1 准备源码… 3](#_Toc426631145)

[1.1.2 准备源码包… 3](#_Toc426631146)

[1.1.3 编译配置… 4](#_Toc426631147)

[1.1.4 编译… 4](#_Toc426631148)

[1.2. 安装虚拟机… 5](#_Toc426631149)

[1.2.1. 新建虚拟机… 5](#_Toc426631150)

[1.2.2. 修改虚拟机配置文件：… 11](#_Toc426631151)

[2. 配置使用… 12](#_Toc426631152)

[2.1. 设置 root 密码… 12](#_Toc426631153)

[2.2. 网络配置… 12](#_Toc426631154)

[2.3. 关于 ssh. 13](#_Toc426631155)

[3. 软件安装方法… 13](#_Toc426631156)

[3.1. 本地安装 ipk 软件包… 13](#_Toc426631157)

[3.2. 在线安装软件及设置… 13](#_Toc426631158)

[3.2.1. 设置软件源… 13](#_Toc426631159)

[3.2.2. 安装软件… 14](#_Toc426631160)

[3.2.3. 直接安装… 14](#_Toc426631161)

[3.3. 使用本地服务器做软件源以安装自定义软件… 14](#_Toc426631162)

[3.3.1. 在编译服务器上配置 vsftp 服务器… 14](#_Toc426631163)

[3.3.2. 修改 openwrt 在线安装软件源… 15](#_Toc426631164)

[3.3.3 更新 opkg. 16](#_Toc426631165)

[3.3.3. 通过命令安装 ipk 软件… 16](#_Toc426631166)

[4. 模块开发方法… 16](#_Toc426631167)

[4.1.SDK 准备… 16](#_Toc426631168)

[4.2. 添加模块代码… 16](#_Toc426631169)

[4.3. 模块程序源代码… 16](#_Toc426631170)

[4.4. 源码编译 Makefile. 16](#_Toc426631171)

[4.5.ipK 包制作规则 Makefile. 17](#_Toc426631172)

[4.6. 编译模块… 18](#_Toc426631173)

[4.7.ipk 包制作… 18](#_Toc426631174)

[4.8. 安装测试… 18](#_Toc426631175)

[5.openwrt SDK 源码目录结构… 18](#_Toc426631176)

[5.1. 源码下载… 18](#_Toc426631177)

[5.2.OpenWRT 的 feeds. 19](#_Toc426631178)

[5.3.OpenWrt 源码目录结构… 19](#_Toc426631179)

[6.Openwrt 模块驱动开发… 20](#_Toc426631180)

[6.1. 建立工作目录… 20](#_Toc426631181)

[6.2. 进入 example 目录，创建 Makefile 文件和代码路径… 20](#_Toc426631182)

[6.3. 进入 src 目录，创建代码路径和相关源文件… 21](#_Toc426631183)

[6.4. 回到 OpenWrt 源码根目录下… 21](#_Toc426631184)

[6.5. 在 OpenWrt 系统里面就可以用 opkg 下载使用了。… 22](#_Toc426631185)

[7.openwrt Makefile 框架分析… 22](#_Toc426631186)

[7.1.openwrt 目录结构… 22](#_Toc426631187)

[7.2.main Makefile. 23](#_Toc426631188)

[第一个逻辑… 24](#_Toc426631189)

[第二逻辑… 24](#_Toc426631190)

[stampfile. 25](#_Toc426631191)

[目录变量… 26](#_Toc426631192)

[7.3.kernel 编译：… 26](#_Toc426631193)

[7.4. 生成 firmware. 27](#_Toc426631194)

[处理 vmlinux: Image/BuildKernel 28](#_Toc426631195)

[lzma 压缩内核… 28](#_Toc426631196)

[MkImage. 29](#_Toc426631197)

[copy. 29](#_Toc426631198)

[7.5. 制作 squashfs，生成. bin: $(call Image/mkfs/squashfs). 29](#_Toc426631199)

[7.6.Openwrt_SDK 中 Makefile 相关总结… 31](#_Toc426631200)

[7.6.1CURDIR 变量… 31](#_Toc426631201)

[7.6.2 空格的表示方法：… 31](#_Toc426631202)

[7.6.3 调用 makefile 中的函数… 31](#_Toc426631203)

[7.6.4. 其他相关内容… 32](#_Toc426631204)

[8. 软件包 Makefile 解析… 35](#_Toc426631205)

[include $(TOPDIR)/rules.mk. 36](#_Toc426631206)

[自定义 PKG_XXXX 变量… 37](#_Toc426631207)

[include $(INCLUDE_DIR)/package.mk. 38](#_Toc426631208)

[（1）它会配置默认的变量… 38](#_Toc426631209)

[（2）推导其它变量… 39](#_Toc426631210)

[（3）包含其它 mk 文件… 40](#_Toc426631211)

[（4）定义默认宏… 40](#_Toc426631212)

[（5）BuildPackage 宏… 41](#_Toc426631213)

[自定义宏… 42](#_Toc426631214)

[必须定义的宏… 42](#_Toc426631215)

[可选定义的宏… 43](#_Toc426631216)

[使之生效… 46](#_Toc426631217)

[参考资料… 46](#_Toc426631218)

环境：

编译服务器：Ubuntu-14.04-desktop

虚拟机软件：VMWare-10.0

编译环境准备：apt-get install subversion build-essential libncurses5-dev zlib1g-dev gawk git ccache gettext libssl-dev xsltproc flex gcc-multilib

## 1.1. 编译 openwrt 虚拟机系统

### 1.1.1 准备源码

#cd /home/nickli/

#mkdir openwrt_SDK

#cd openwrt_SDK

#svn checkout

svn://svn.openwrt.org/openwrt/branches/barrier_breaker

### 1.1.2 准备源码包

#cd barrier_breaker

#mkdir dl

#cp -r /home/public/openwrt_dl/* ./dl/

之前已经将几乎所有的编译时需要下载的源码包下载到了 / home/public/openwrt_dl 目录下，所以为减少编译时间直接将该目录链接到新的 SDK 中。

### 1.1.3 编译配置

#make defconfig

#make prereq

#make menuconfig   // 配置系统编译选单时需注意以下几点：

*   系统目标平台选择为 x86
    
*   目标文件为虚拟机文件 ***.vmdk
    
*   选择 c 库 (uClibc/eglibc/glibc……)
    
*   配置系统所需的基本配置比如 adduser/addgroup/su 等命令（basesystem/busybox）
    

退出配置单并保存。

### 1.1.4 编译

#make V=99

完成以后镜像文件 “openwrt-x86-generic-combined-squashfs.vmdk” 存在于 bin/x86 / 目录下, 将该文件拷贝到 windows 下如 F:/template / 下。

## 1.2. 安装虚拟机

### 1.2.1. 新建虚拟机

下一步

选择稍后安装操作系统

客户及操作系统选择 Linux，版本选择 “其他 Linux 2.6.x 内核”

为虚拟机命名，并选择之前镜像存放的路径作为虚拟机存放路径

点击继续

Cpu/memory 等信息保持默认，点击下一步即可：

内存选择 512 足够了：

选择桥接：

保持默认，点击下一步

选择硬盘类型为 IDE:

创建新磁盘：

设置磁盘大小 10G：

然后一路默认，点击 “下一步” 直到结束。

### 1.2.2. 修改虚拟机配置文件：

进入以上放置虚拟机的目录，并找后缀为 vmx 的文件，使用记事本打开，将以下途中表示的虚拟机名字修改成第一步中编译出来，保存在本地的那个系统镜像名称：

修改完成后保存退出。

在 vmware 中启动刚刚新建的虚拟机 “smartRouter_4x4”

## 2.1. 设置 root 密码

#passwd

两次输入密码即可

重启系统即可

## 2.2. 网络配置

#vi /etc/config/network

保存退出，后重启网络：

#/etc/init.d/network restart

#ifconfig  br-lan

以上红色标注处显示修改成功。

## 2.3. 关于 ssh

OpenWrt 中默认自带的 SSH 服务端和客户端是 Dropbear

使用 ssh 代理方法，实现自动登录 ssh，类似于 convirt 节点管理方法：

http://talk.withme.me/?p=210#codesyntax_1

## 3.1. 本地安装 ipk 软件包

使用命令: opkg install softwall.ipk

例如：安装 sftp

首先下载软件：

#cd /root

#wget [http://downloads.openwrt.org/backfire/10.03.1/x86_generic/packages/openssh-sftp-server_5.8p2-2_x86.ipk](http://downloads.openwrt.org/backfire/10.03.1/x86_generic/packages/openssh-sftp-server_5.8p2-2_x86.ipk)

# opkg install openssh-sftp-server_5.8p2-2_x86.ipk

Installing openssh-sftp-server (5.8p2-2) to root…

Configuring openssh-sftp-server.

## 3.2. 在线安装软件及设置

### 3.2.1. 设置软件源

#vim /etc/opkg.conf

内容如下：

dest root /

dest ram /tmp

lists_dir ext /var/opkg-lists

option overlay_root /overlay

src/gz barrier_breaker_base [http://downloads.openwrt.org/barrier_breaker/14.07/x86/generic/packages/base](http://downloads.openwrt.org/barrier_breaker/14.07/x86/generic/packages/base)

最后一行 url 为实际可以下载到 ipk 的地址，配置好后才能使用在线安装功能。

### 3.2.2. 安装软件

更新可用 ipk 软件包列表：

#opkg update

查看所有 ipk 包列表：

#opkg list

#opkg install software.ipkg

安装软件：

#opkg install software.ipk

### 3.2.3. 直接安装

在 3.1 节中，描述的安装本地软件，实际上是先 wget 下载一个软件到本地，然后再执行本地安装，实际上可以直接使用 opkg install URL 的方式在线安装。如下：

#opkg install [http://downloads.openwrt.org/backfire/10.03.1/x86_generic/packages/openssh-sftp-server_5.8p2-2_x86.ipk](http://downloads.openwrt.org/backfire/10.03.1/x86_generic/packages/openssh-sftp-server_5.8p2-2_x86.ipk)

## 3.3. 使用本地服务器做软件源以安装自定义软件

安装本地软件有两种方法：一种是将本地软件 scp 到 openwrt 系统中，通过 opkg 安装即可；第二种就是在本地服务器上搭建一个 ftp 服务器， 然后在 openwrt 系统软件源中添加该服务器的 url，然后通过在线安装的方式安装本地服务器上制作的 Ipk 包。现就第二种方式做介绍。

### 3.3.1. 在编译服务器上配置 vsftp 服务器

2.11 安装 ftp 服务器

#sudo apt-get install vsftpd

# sudo gedit /etc/vsftpd.conf

原文件中不少指令被注释，只要启用部分即可，一下是启用的命令（配置文件中对每一条都有具体说明）

listen=YES       # 服务器监听

anonymous_enable=YES       # 匿名访问允许

local_enable=YES    # 本地主机访问允许

write_enable=YES    # 写允许

anon_upload_enable=YES

# 匿名上传允许，默认是 NO，嫌麻烦的可以开起来。出了问题我不负责～

anon_mkdir_write_enable=YES  # 匿名创建文件夹允许

dirmessage_enable=YES  # 进入文件夹允许

xferlog_enable=YES   #  ftp 日志记录允许

connect_from_port_20=YES     # 允许使用 20 号端口作为数据传送的端口

secure_chroot_dir=/var/run/vsftpd/empty

pam_service_name=vsftpd

rsa_cert_file=/etc/ssl/private/vsftpd.pem

保存。

创建匿名访问目录以供 openwrt 访问

#mkdir /srv/ftp

修改 ftp 目录权限：

#chmod 755 /srv/ftp

创建 upload download 目录

#mkdir –p –m 777 /srv/ftp/upload

#mkdir –p –m 755 /srv/ftp/download

重启 vsftpd

#service vsftpd restart

然后将 / home/nickli/openwrt_SDK/barrier_breaker/bin/x86/packages 目录下所有的内容都拷贝到 / srv/ftp/download 目录下：

#scp -r /home/nickli/openwrt_SDK/barrier_breaker/bin/x86/packages /srv/ftp/download/

默认情况下，每个用户的家目录会自动做为 vsftp 服务的根目录。也就是说使用用户 A 的权限来访问该 ftp 服务器时，其登录到的 ftp 根目录就是该用户 A 在该 ftp 服务器寄存的这台主机上自己的 home 目录。

本文档制作时服务器 IP 为 10.8.3.50 的 ubuntu-14.04 系统，OpenWRT 的 SDK 在 / home/nickli /openwrt_SDK/barrier_breaker 目录下。编译出来的所有成果在该目录的 bin 目录下。我们将使用编译出的 packages 作为 最终的软件源。

### 3.3.2. 修改 openwrt 在线安装软件源

openwrt 端修改 opkg.conf，添加 ftp 服务器 ipk 包存在地址，注释掉系统默认的 url 地址如下红色标注，并添加绿色标注的文字：

src/gz barrier_breaker_base [ftp://10.8.3.50/download/packages/base](ftp://10.8.3.50/download/packages/base)

(或者 src/gz packages ftp://10.8.3.50/download/packages/base)

dest root /

dest ram /tmp

lists_dir ext /var/opkg-lists

option overlay_root /overlay

#src/gz barrier_breaker_base http://downloads.openwrt.org/barrier_breaker/14.07/x86/generic/packages/base

### 3.3.3 更新 opkg

#opkg update

若无错误提示，则表示可以正常使用 opkg 从 ftp 下载 ipk 包了。

### 3.3.3. 通过命令安装 ipk 软件

#opkg install software.ipk

## 4.1. 源码下载

OpenWrt 的源代码管理默认用的是 SVN 下载：

svn co svn://svn.openwrt.org/openwrt/trunk/ .

还可以用 Git 下载：

git clone git://git.openwrt.org/openwrt.git

git clone git://git.openwrt.org/packages.git

参考方法：[https://dev.openwrt.org/wiki/GetSource](https://dev.openwrt.org/wiki/GetSource)

## 4.2.OpenWRT 的 feeds

包括：

packages – 提供众多库, 工具等基本功能. 也是其他 feed 所依赖的软件源, 因此在安装其他 feed 前一定要先安装 packages!

luci – OpenWrt 默认的 GUI(WEB 管理界面).

xwrt – 另一种可替换 LuCI 的 GUI

qpe – DreamBox 维护的基于 Qt 的图形界面, 包含 Qt2, Qt4, Qtopia, OPIE, SMPlayer 等众多图形界面.

device – DreamBox 维护与硬件密切相关的软件, 如 uboot, qemu 等.

dreambox_packages – DreamBox 维护的国内常用网络工具, 如 oh3c, njit8021xclient 等.

desktop – OpenWrt 用于桌面的一些软件包.

xfce – 基于 Xorg 的著名轻量级桌面环境. Xfce 建基在 GTK+2.x 之上, 它使用 Xfwm 作为窗口管理器.

efl – 针对 enlightenment.

phone - 针对 fso, paroli.

trunk 中默认的 feeds 下载有 packages、xwrt、luci、routing、telephony。如要下载其他的软件包，需打开源码根目录下面的 feeds.conf.default 文件，去掉相应软件包前面的 #号，然后更新源:

./scripts/feeds update -a

安装下载好的包:

./scripts/feeds install -a

## 4.3.OpenWrt 源码目录结构

**tools** 和 **toolchain** 目录：包含了一些通用命令, 用来生成固件, 编译器, 和 C 库.

**build dir/host** 目录：是一个临时目录, 用来储存不依赖于目标平台的工具.

**build dir/toolchain**- 目录：用来储存依赖于指定平台的编译链. 只是编译文件存放目录无需修改.

**build dir/target**- 目录：用来储存依赖于指定平台的软件包的编译文件, 其中包括 linux 内核, u-boot, packages, 只是编译文件存放目录无需修改.

**staging_dir** 目录：是编译目标的最终安装位置, 其中包括 rootfs, package, toolchain.

**package** 目录：软件包的下载编译规则, 在 OpenWrt 固件中, 几乎所有东西都是. ipk, 这样就可以很方便的安装和卸载.

**target** 目录：目标系统指嵌入式设备, 针对不同的平台有不同的特性, 针对这些特性, “target/linux” 目录下按照平台进行目录划分, 里面包括了针对标准内核的补丁, 特殊配置等.

**bin** 目录：编译完 OpenWrt 的二进制文件生成目录, 其中包括 sdk, uImage, u-boot, dts, rootfs 构建一个嵌入式系统完整的二进制文件.

**config** 目录：存放着整个系统的的配置文件.

**docs** 目录：里面不断包含了整个宿主机的文件源码的介绍, 里面还有 Makefile 为目标系统生成 docs.

**include** 目录：里面包括了整个系统的编译需要的头文件, 但是是以 Make 进行连接的.

**feeds** 目录：扩展软件包索引目录.

**scripts** 目录：组织编译整个 OpenWrt 的规则.

**tmp** 目录：编译文件夹, 一般情况为空.

**dl** 目录：所有软件的下载目录, 包括 u-boot, kernel.

**logs** 目录：如果编译出错, 可以在这里找到编译出错的 log.

## 4.4. 基本命令介绍

#./scripts/feeds update -a

#./scripts/feeds install -a

#make prereq // 该命令可以检查 SDK 中 target 内是否有存在错误的 Makefile。

#make defconfig

#make menuconfig

#make kernel_config

#make V=99

#make package/pacakge_name/{clean,prepare,compile,install} V=99

## 5.1.SDK 准备

请参考：4.1 小节内容。

## 5.2. 添加模块代码

例如添加模块名字加 hello，其目录树如下：

hello

├── files     ———————–文件夹：存放文件如：服务配置文件 / 启动脚本等

├── Makefile ————————文件：打包相关的 Makefile

└── src      ———————–文件夹：存放模块源码文件

├── hello.c ———————文件：源代码

└── Makefile ——————文件：源码编译用的 Makefile

## 5.3. 模块程序源代码

#include<stdio.h>

int main ()

{

printf(“hello world!\n”);

return 0;

}

## 5.4. 源码编译 Makefile

hello:hello.o

$(CC) -o $@ $^

hello.o:hello.c

$(CC) -c $<

clean:

rm -rf *.o hello

## 5.5.ipK 包制作规则 Makefile

#

# Copyright (C) 2006-2010 OpenWrt.org

#

# This is free software, licensed under the GNU General Public License v2.

# See /LICENSE for more information.

#

include $(TOPDIR)/rules.mk

PKG_NAME:=hello

PKG_VERSION:=1.0

PKG_RELEASE:=1.0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/hello

SECTION:=libs

CATEGORY:=Libraries

TITLE:=hello

endef

define Build/Prepare

mkdir -p $(PKG_BUILD_DIR)

$(CP) ./src/* $(PKG_BUILD_DIR)/

endef

define Package/hello/description

the hello is the base utils of the skysoft’s smartrouter

endef

define Package/hello/install

$(INSTALL_DIR)  $(1)/usr/lib/

$(CP) $(PKG_BUILD_DIR)/hello.so* $(1)/usr/lib/

endef

$(eval $(call BuildPackage,hello))

**注意以上红色标注部分文字须保持一致。**

## 5.6. 编译模块

$ make package/libs/hello/compile V=99

$ make package/libs/hello/clean

$ make package/skysoft_web_admin/{clean,prepare,compile} V=99

## 5.7.ipk 包制作

加入 install 后会将编译结果打包安装到 SDK 目录下 bin 目录下相应位置。

$ make package/skysoft_web_admin/{clean,prepare,compile,install} V=99

## 5.8. 安装测试

编译完成后在 SDK 目录下的 / bin/x86/package/base 文件夹下回有 hello*.ipk 文件，将 bin/x86/package 整个目录拷贝到 ftp 下载目录 / srv/ftp/download / 下，采用在 openwrt 在线安装的方式，或者直接远程拷贝到目标 openwrt 系统 中安装。

OpenWrt 开发内核驱动有多种方式，前面讲到的制作内核补丁也是一种开发方法。这里介绍直接在 OpenWrt 系统上开发内核驱动，把内核驱动做成 ipk 软件包的形式。

## 6.1. 建立工作目录

**$cd  openwrt/trunk/package**

**$mkdir example**

## 6.2. 进入 example 目录，创建 Makefile 文件和代码路径

**$cd example**

**$mkdir src**

**$vim Makefile**

**文件内容如下：**

**# Kernel module example**

**include $(TOPDIR)/rules.mk**

**include $(INCLUDE_DIR)/kernel.mk**

**PKG_NAME:=example**

**PKG_RELEASE:=1**

**include $(INCLUDE_DIR)/package.mk**

**define KernelPackage/example**

 **SUBMENU:=Other modules**

 **DEPENDS:=@TARGET_octeon**

 **TITLE:=Support Module for example**

 **AUTOLOAD:=$(call AutoLoad,81,example)**

 **FILES:=$(PKG_BUILD_DIR)/example/example.$(LINUX_KMOD_SUFFIX)**

**endef**

**define Build/Prepare**

 **mkdir -p $(PKG_BUILD_DIR)**

 **$(CP) -R ./src/* $(PKG_BUILD_DIR)/**

**endef**

**define Build/Compile**

 **$(MAKE) -C “$(LINUX_DIR)” \**

 **CROSS_COMPILE=”$(TARGET_CROSS)” \**

 **ARCH=”$(LINUX_KARCH)” \**

 **SUBDIRS=”$(PKG_BUILD_DIR)/example” \**

 **EXTRA_CFLAGS=”-g $(BUILDFLAGS)” \**

 **modules**

**endef**

**$(eval $(call KernelPackage,example))**

注释：AUTOLOAD：定义了内核模块开机自动挂载的动作，$(call AutoLoad,81,example)，表示当系统启动时名叫 “example” 的内核模块会在顺序为第 81 的位置加载到系统中，不必每次启动系统后 手动的去 insmod 加载模块。如果正常，本模块 ipk 包制作好并安装到目标系统中后，会在目标系统的 / etc/modules.d / 目录下创建一份名叫 81-example 的加载序列文件，其内容为 example。而本 ipk 安装后会在 / lib/moudules/$(KERNEL-VERSION) / 目录下放置 example.ko 文件。而如果本软件包包含了多个内核模块文件，比如多个 “.ko” 文件，那么在这个位置就要加入多个模块名，模块名之间 以 “空格” 隔开，如下例： 

**define KernelPackage/exfat**

 **SUBMENU:=Other modules**

 **TITLE:=exfat driver**

 **DEPENDS:=+kmod-nls-base @BUILD_PATENTED**

 **FILES:=$(PKG_BUILD_DIR)/*.$(LINUX_KMOD_SUFFIX)**

 **AUTOLOAD:=$(call AutoLoad,82,exfat_core exfat_fs)**

 **KCONFIG:=**

**endef**

定义的模块名称为 exfat，其内部有两个内核文件需要添加，分别为 exfat_core.ko,exfat_fs.ko。

## 6.3. 进入 src 目录，创建代码路径和相关源文件

**$cd src**

**$mkdir example**

**$cd example**

**$vim example.c**

**编辑内容如下：**

**#include <linux/init.h>**

**#include <linux/module.h>**

**#include <linux/kernel.h>**

**/* hello_init —-** **初始化函数，当模块装载时被调用，如果成功装载返回 0** **否则返回非 0** **值 */**

**static int __init hello_init(void)**

**{**

 **printk(“I bear a charmed life.\n”);**

 **return 0;**

**}**

**/ * hello_exit —-** **退出函数，当模块卸载时被调用 */**

**static void __exit hello_exit(void)**

**{**

 **printk(“Out, out, brief candle\n”);**

**}**

**module_init(hello_init);**

**module_exit(hello_exit);**

**MODULE_LICENSE(“GPL”);**

**MODULE_AUTHOR(“Pillar_zuo”);**

**vim Kconfig**

**config EXAMPLE**

 **tristate “Just a example”**

 **default n**

 **help**

 **This is a example, for debugging kernel model.**

 **If unsure, say N.**

**保存并退出。**

**增加源码编译 Makefile****：**

**$vim Makefile**

**内容如下：**

**obj-m := example.o**

## 6.4. 回到 OpenWrt 源码根目录下

**$make menuconfig**

 **Kernel modules —>**

 **Other modules —>**

 **kmod-example**

选项设置为 M，保存退出

然后编译该模块：

**$make package/example/compile**

**$make package/index**

## 6.5. 在 OpenWrt 系统里面就可以用 opkg 下载使用了。

方法参考第三节内容。

本节原文地址：[http://www.cnblogs.com/sammei/p/3968916.html](http://www.cnblogs.com/sammei/p/3968916.html)

本篇的主要目的是想通过分析 Makefile，了解 openwrt 编译过程。着重关注以下几点：

*   **openwrt** **目录结构**
    
*   **主 Makefile** **的解析过程，各子目录的目标生成**
    
*   **kernel** **编译过程**
    
*   **firmware** **的生成过程**
    
*   **软件包的编译过程**
    

## 7.1.openwrt 目录结构

官方源下载速度太慢，我从 github 上 clone 了 openwrt 的代码仓库。

git clone https://github.com/openwrt-mirror/openwrt.git

openwrt 目录结构

上图是 openwrt 目录结构，其中第一行是原始目录，第二行是编译过程中生成的目录。各目录的作用是：

**tools** – 编译时需要一些工具， tools 里包含了获取和编译这些工具的命令。里面是一些 Makefile，有的可能还有 patch。每个 Makefile 里都有一句 $(eval $(call HostBuild))，表示编译这个工具是为了在主机上使用的。

**toolchain** – 包含一些命令去获取 kernel headers, C library, bin-utils, compiler, debugger

**target** – 各平台在这个目录里定义了 firmware 和 kernel 的编译过程。

**package** – 包含针对各个软件包的 Makefile。openwrt 定义了一套 Makefile 模板，各软件参照这个模板定义了自己的信息，如软件包的版本、下载地址、编译方式、安装地址等。

**include** – openwrt 的 Makefile 都存放在这里。

**scripts** – 一些 perl 脚本，用于软件包管理。

**dl** – 软件包下载后都放到这个目录里

**build_dir** – 软件包都解压到 build_dir / 里，然后在此编译

**staging_dir** – 最终安装目录。tools, toolchain 被安装到这里，rootfs 也会放到这里。例如 puma_SDK 中文件系统目录为：

/home/nickli/2015-Router_N01-PUMA_4x4/trunk/02.DevelopementRepository/04.Coding/qualcomm_sdk/qsdk/staging_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/root-ipq806x

**feeds** – 扩展软件包索引目录。

**bin** – 编译完成之后，firmware 和各 ipk 会放到此目录下。

**推荐阅读官方资料**：[OpenWrt Development Guide](http://www.ccs.neu.edu/home/noubir/Courses/CS6710/S12/material/OpenWrt_Dev_Tutorial.pdf)

[OpenWrt_Dev_Tutorial](http://www.liwangmeng.com/wp-content/uploads/2016/01/OpenWrt_Dev_Tutorial.pdf)

## 7.2.main Makefile

openwrt 根目录下的 Makefile 是执行 make 命令时的入口。从这里开始分析。

world:

ifndef ($(OPENWRT_BUILD),1)

# 第一个逻辑

…

else

# 第二个逻辑

…

endif

上面这段是主 Makefile 的结构，可以得知：

执行 make 时，若无任何目标指定，则默认目标是 world

执行 make 时，无参数指定，则会进入第一个逻辑。如果执行命令 make OPENWRT_BUILD=1，则直接进入第二个逻辑。

编译时一般直接使用 make V=s -j5 这样的命令，不会指定 OPENWRT_BUILD 变量

### 第一个逻辑

override OPENWRT_BUILD=1

export OPENWRT_BUILD

更改了 OPENWRT_BUILD 变量的值。这里起到的作用是下次执行 make 时，会进入到第二逻辑中。

toplevel.mk 中的 %:: 解释 world 目标的规则。

prereq:: prepare-tmpinfo .config

@+$(MAKE) -r -s tmp/.prereq-build $(PREP_MK)

@+$(NO_TRACE_MAKE) -r -s $@

%::

@+$(PREP_MK) $(NO_TRACE_MAKE) -r -s prereq

@( \

cp .config tmp/.config; \

./scripts/config/conf –defconfig=tmp/.config -w tmp/.config Config.in > /dev/null 2>&1; \

if ./scripts/kconfig.pl ‘>’ .config tmp/.config | grep -q CONFIG; then \

printf “$(_R)WARNING: your configuration is out of sync. Please run make menuconfig, oldconfig or defconfig!$(_N)\n” >&2; \

fi \

)

@+$(ULIMIT_FIX) $(SUBMAKE) -r $@

执行 make V=s 时，上面这段规则简化为：

prereq:: prepare-tmpinfo .config

@make -r -s tmp/.prereq-build

@make V=ss -r -s prereq

%::

@make V=s -r -s prereq

@make -w -r world

可见其中最终又执行了 prereq 和 world 目标，这两个目标都会进入到第二逻辑中。

### 第二逻辑

首先就引入了 target, package, tools, toolchain 这四个关键目录里的 Makefile 文件

include target/Makefile

include package/Makefile

include tools/Makefile

include toolchain/Makefile

这些子目录里的 Makefile 使用 include/subdir.mk 里定义的两个函数来动态生成规则，这两个函数是 subdir 和 stampfile

### stampfile

拿 target/Makefile 举例：

(eval(call stampfile,$(curdir),target,prereq,.config))

会生成规则：

target/stamp-prereq:=$(STAGING_DIR)/stamp/.target_prereq

$$(target/stamp-prereq): $(TMP_DIR)/.build .config

@+$(SCRIPT_DIR)/timestamp.pl -n $$(target/stamp-prereq) target .config || \

make $$(target/flags-prereq) target/prereq

@mkdir -p $$$$(dirname $$(target/stamp-prereq))

@touch $$(target/stamp-prereq)

$$(if $(call debug,target,v),,.SILENT: $$(target/stamp-prereq))

.PRECIOUS: $$(target/stamp-prereq) # work around a make bug

target//clean:=target/stamp-prereq/clean

target/stamp-prereq/clean: FORCE

@rm -f $$(target/stamp-prereq)

所以可以简单的看作： (eval(call stampfile,(curdir),target,prereq,.config)) 生成了目标 (target/stamp-prereq)

对于 target 分别生成了：(target/stamp−preq)，(target/stamp-copile)， $(target/stamp-install)

toolchain : $(toolchain/stamp-install)

package : (package/stamp−preq),(package/stamp-cleanup), (package/stamp−compile),(package/stamp-install)

tools : $(tools/stamp-install)

OpenWrt 的主 Makefile 工作过程

subdir

subdir 这个函数写了一大堆东西，看起来很复杂 。

$(call subdir, target) 会遍历下的子目录，执行 make -C 操作。这样就切入子目录中去了。

### 目录变量

几个重要的目录路径：

**KERNEL_BUILD_DIR**

build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7620a/linux-3.14.18

**LINUX_DIR**

build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7620a/linux-3.14.18

**KDIR**

build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7620a

**BIN_DIR**

bin/ramips

Makefile 中包含了 rules.mk, target.mk 等. mk 文件，这些文件中定义了许多变量，有些是路径相关的，有些是软件相关的。这些变量在整个 Makefile 工程中经常被用到，

**TARGET_ROOTFS_DIR**

build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2

**BUILD_DIR**

build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2

**STAGING_DIR_HOST**

staging_dir/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2

**TARGET_DIR**

build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/root-ramips

## 7.3.kernel 编译：

target/linux/ramips/Makefile: $(eval $(call BuildTarget))

target/linux/Makefile : export TARGET_BUILD=1

include/target.mk:

ifeq ($(TARGET_BUILD),1)

include $(INCLUDE_DIR)/kernel-build.mk

BuildTarget?=$(BuildKernel)

endif

BuildKernel 是 include/kernel-build.mk 定义的一个多行变量，其中描述了如何编译内核, 主要关注其中 install 规则的依赖链：

$(KERNEL_BUILD_DIR)/symtab.h: FORCE

rm -f $(KERNEL_BUILD_DIR)/symtab.h

touch $(KERNEL_BUILD_DIR)/symtab.h

+$(MAKE) $(KERNEL_MAKEOPTS) vmlinux

…

$(LINUX_DIR)/.image: $(STAMP_CONFIGURED) $(if $(CONFIG_STRIP_KERNEL_EXPORTS),$(KERNEL_BUILD_DIR)/symtab.h) FORCE

$(Kernel/CompileImage)

$(Kernel/CollectDebug)

touch $$@

install: $(LINUX_DIR)/.image

+$(MAKE) -C image compile install TARGET_BUILD=

1.  触发 make vmlinux 命令生成 vmlinux： install –> $(LINUX_DIR)/.image –> $(KERNEL_BUILD_DIR)/symtab.h –> `$(MAKE) $(KERNEL_MAKEOPTS) vmlinux`
    

2.  对 vmlinux 做 objcopy, strip 操作: $(LINUX_DIR)/.image –> $(Kernel/CompileImage) –> $(call Kernel/CompileImage/Default) –> $(call Kernel/CompileImage/Default)
    

$(KERNEL_CROSS)objcopy -O binary $(OBJCOPY_STRIP) -S $(LINUX_DIR)/vmlinux $(LINUX_KERNEL)$(1)

–> build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7620a/vmlinux

$(KERNEL_CROSS)objcopy $(OBJCOPY_STRIP) -S $(LINUX_DIR)/vmlinux $(KERNEL_BUILD_DIR)/vmlinux$(1).elf

–> build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7620a/vmlinux.elf

$(CP) $(LINUX_DIR)/vmlinux $(KERNEL_BUILD_DIR)/vmlinux.debug

–> build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7620a/vmlinux.debug

## 7.4. 生成 firmware

firmware 由 kernel 和 rootfs 两个部分组成，要对两个部分先分别处理，然后再合并成一个. bin 文件。先看一下这个流程。

“target/linux/ramips/image/Makefile” 文件中的最后一句：$(eval $(call BuildImage))，将 BuildImage 展开在这里。BuildImage 定义在 include/image.mk 文件中，其中定义了数个目标的规则。

define BuildImage

compile: compile-targets FORCE

**$(call Build/Compile)**

install: compile install-targets FORCE

…

$(call Image/BuildKernel) ## 处理 vmlinux

…

$(call Image/mkfs/squashfs) ## 生成 squashfs，并与 vmlinux 合并成一个. bin 文件

…

endef

### 处理 vmlinux: Image/BuildKernel

target/linux/ramips/image/Makefile:

define Image/BuildKernel

cp $(KDIR)/vmlinux.elf $(BIN_DIR)/$(VMLINUX).elf

cp $(KDIR)/vmlinux $(BIN_DIR)/$(VMLINUX).bin

$(call CompressLzma,$(KDIR)/vmlinux,$(KDIR)/vmlinux.bin.lzma)

$(call MkImage,lzma,$(KDIR)/vmlinux.bin.lzma,$(KDIR)/uImage.lzma)

cp $(KDIR)/uImage.lzma $(BIN_DIR)/$(UIMAGE).bin

ifneq ($(CONFIG_TARGET_ROOTFS_INITRAMFS),)

cp $(KDIR)/vmlinux-initramfs.elf $(BIN_DIR)/$(VMLINUX)-initramfs.elf

cp $(KDIR)/vmlinux-initramfs $(BIN_DIR)/$(VMLINUX)-initramfs.bin

$(call CompressLzma,$(KDIR)/vmlinux-initramfs,$(KDIR)/vmlinux-initramfs.bin.lzma)

$(call MkImage,lzma,$(KDIR)/vmlinux-initramfs.bin.lzma,$(KDIR)/uImage-initramfs.lzma)

cp $(KDIR)/uImage-initramfs.lzma $(BIN_DIR)/$(UIMAGE)-initramfs.bin

endif

$(call Image/Build/Initramfs)

endef

### lzma 压缩内核

build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7620a/ 目录中:

lzma e vmlinux -lc1 -lp2 -pb2 vmlinux.bin.lzma

### MkImage

build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7620a/ 目录中：

mkimage -A mips -O linux -T  kernel -C lzma -a 0x80000000 -e 0x80000000 -n “MIPS OpenWrt Linux-3.14.18” -d vmlinux.bin.lzma uImage.lzma

### copy

VMLINUX:=$(IMG_PREFIX)-vmlinux –> openwrt-ramips-mt7620a-vmlinux

UIMAGE:=$(IMG_PREFIX)-uImage –> openwrt-ramips-mt7620a-uImage

cp $(KDIR)/uImage.lzma $(BIN_DIR)/$(UIMAGE).bin

把 uImage.lzma 复制到 bin/ramips / 目录下：

cp $(KDIR)/uImage.lzma bin/ramips/openwrt-ramips-mt7620a-uImage

## 7.5. 制作 squashfs，生成. bin: $(call Image/mkfs/squashfs)

define Image/mkfs/squashfs

@mkdir -p $(TARGET_DIR)/overlay

$(STAGING_DIR_HOST)/bin/mksquashfs4 $(TARGET_DIR) $(KDIR)/root.squashfs -nopad -noappend -root-owned -comp $(SQUASHFSCOMP) $(SQUASHFSOPT) -processors $(if $(CONFIG_PKG_BUILD_JOBS),$(CONFIG_PKG_BUILD_JOBS),1)

$(call Image/Build,squashfs)

endif

mkdir -p $(TARGET_DIR)/overlay

mkdir -p build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/root-ramips/overlay

mksquashfs4

$(STAGING_DIR_HOST)/bin/mksquashfs4 $(TARGET_DIR) $(KDIR)/root.squashfs -nopad -noappend -root-owned -comp $(SQUASHFSCOMP) $(SQUASHFSOPT) -processors $(if $(CONFIG_PKG_BUILD_JOBS),$(CONFIG_PKG_BUILD_JOBS),1)

制作 squashfs 文件系统，生成 root.squashfs:

mksquashfs4 root-ramips root.squashfs -nopad -noappend -root-owned -comp gzip -b 256k -p ‘/dev d 755 0 0’ -p ‘/dev/console c 600 0 0 5 1’ -processors 1

$(call Image/Build,squashfs)

在 target/linux/ramips/image/Makefile 中：

define Image/Build

$(call Image/Build/$(1))

dd if=$(KDIR)/root.$(1) of=$(BIN_DIR)/$(IMG_PREFIX)-root.$(1) bs=128k conv=sync

$(call Image/Build/Profile/$(PROFILE),$(1))

endef

dd if=(KDIR)/root.squashfsof=(BIN_DIR)/$(IMG_PREFIX)-root.squashfs bs=128k conv=sync

dd if=build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7620a/root.squashfs of=bin/ramips/openwrt-ramips-mt7620-root.squashfs bs=128k conv=sync

(callImage/Build/Profile/(PROFILE),squashfs)

target/linux/ramips/mt7620a/profiles/00-default.mk, 中调用 Profile 函数：$(eval $(call Profile,Default))

include/target.mk 中定义了 Profile 函数， 其中令 PROFILE=Default

define Image/Build/Profile/Default

$(call Image/Build/Profile/MT7620a,$(1))

…

endef

规则依赖序列如下：

$(call Image/Build/Profile/$(PROFILE),squashfs)

–> $(call BuildFirmware/Default8M/squashfs,squashfs,mt7620a,MT7620a)

–> $(call BuildFirmware/OF,squashfs,mt7620a,MT7620a,8060928)

–> $(call MkImageLzmaDtb,mt7620a,MT7620a)

–> $(call PatchKernelLzmaDtb,mt7620a,MT7620a)

–> $(call MkImage,lzma,$(KDIR)/vmlinux-mt7620a.bin.lzma,$(KDIR)/vmlinux-mt7620a.uImage)

–> $(call MkImageSysupgrade/squashfs,squashfs,mt7620a,8060928)

其中的主要步骤：

复制： cp (KDIR)/vmlinux(KDIR)/vmlinux-mt7620a

生成 dtb 文件： (LINUXDIR)/scripts/dtc/dtc−Odtb−o(KDIR)/MT7620a.dtb ../dts/MT7620a.dts

将内核与 dtb 文件合并：(STAGINGDIRHOST)/bin/patch−dtb(KDIR)/vmlinux-mt7620a $(KDIR)/MT7620a.dtb

使用 lzma 压缩：(callCompressLzma,(KDIR)/vmlinux-mt7620a,$(KDIR)/vmlinux-mt7620a.bin.lzma)

将 lzma 压缩后的文件经过 mkimage 工具处理，即在头部添加 uboot 可识别的信息。

接下来就是合并生成 firmware 固件了：

MkImageSysupgrade/squashfs, squashfs, mt7620a,8060928

cat vmlinux-mt7620a.uImage root.squashfs > openwrt-ramips-mt7620-mt7620a-squashfs-sysupgrade.bin

–> 制作 squashfs bin 文档, 并确认它的大小 < 8060928 才是有效的，否则报错。

总结： 整个流程下来，其实最烦索的还是对内核生成文件 vmlinux 的操作，经过了 objcopy, patch-dtb, lzma, mkimage 等过程生成一个 uImage，再与 mksquashfs 工具制作的文件系统 rootfs.squashfs 合并。

## 7.6.Openwrt_SDK 中 Makefile 相关总结

### 7.6.1CURDIR 变量

在 makefile 中表示当前目录，效果等同于 shell 命令 pwd.

### 7.6.2 空格的表示方法：

empty:=

space:=$(empty) $(empty)

在 openwrtSDK 中该变量用以检查 SDK 目录是否含有空格，要求所有路径中不得有含空格的文件夹

### 7.6.3 调用 makefile 中的函数

if 判断函数，用法：

$(if <condition>,<then-part>)

或者：

$(if <condition>,<then-part>,<else-part>)

findstring 查找字符串函数，用法：

$(findstring <find>,<in>) 在字串 < in > 中查找 < find > 字串

error 控制 makefile 运行的函数，用法：

### 7.6.4. 其他相关内容

#### 2.1make 的参数

-i 或者”–ignore-errors”: 忽略 Makefile 中所有的命令错误；

-k 或者 “–keep-going“：终止出错命令，但继续执行其他命令；

-w 或者”–print-directory“：嵌套执行 make 时，会输出当前工作目录信息，该选项的反作用项是”-s“；

#### 2.2 嵌套执行 make

我们有一个子目录叫 subdir，这个目录下有个 Makefile 文件，来指明了这个目录下文件的编译规则。那么我们总控的 Makefile 可以这样书写：

subsystem:

cd subdir && $(MAKE)

其等价于：

subsystem:

$(MAKE) -C subdir

定义 $(MAKE)宏变量的意思是，也许我们的 make 需要一些参数，所以定义成一个变量比较利于维护。这两个例子的意思都是先进入 “subdir” 目录，然后执行 make 命令。

我们把这个 Makefile 叫做 “总控 Makefile”，总控 Makefile 的变量可以传递到下级的 Makefile 中（如果你显示的声明），但是不会覆盖下层的 Makefile 中所定义的变量，除非指定了“-e” 参数。

如果你要传递变量到下级 Makefile 中，那么你可以使用这样的声明：

export <variable …>

如果你不想让某些变量传递到下级 Makefile 中，那么你可以这样声明：

unexport <variable …>

#### 2. 在 package 目录中的 Makefile:

#####     2.1.call 函数

call 函数是唯一一个可以用来创建新的参数化的函数。你可以写一个非常复杂的表达式，这个表达式中，你可以定义许多参数，然后你可以用 call 函数来向这个表达式传递参数。其语法是：

$(call <expression>,<parm1>,<parm2>,<parm3>…)

当 make 执行这个函数时，<expression> 参数中的变量，如 $(1)，$(2)，$(3) 等，会被参 数 < parm1>，<parm2>，<parm3 > 依次取代。而 < expression > 的返回值就是 call 函数的返回值。

#####     2.2.eval 函数

函数 “eval” 是一个比较特殊的函数。使用它可以在 Makefile 中构造一个可变的规则结构关系（依赖关系链），其中可以使用其它变量和函数。

函数 “eval” 对它的参数进行展开，展开的结果作为 Makefile 的一部分，make 可以对展开内容进行语法解析。展开的结果可以包含一个新变量、目标、隐含规则或者是明确规则等。也就是说此函数的功能主要是：根据其参数的关系、结构，对它们进行替换展开。

Ø        **返回值：**函数 “eval” 的返回值是空，也可以说没有返回值。

Ø        **函数说明：**“eval” 函数执行时会对它的参数进行两次展开。第一次展开过程发是由函数本身完成的，第二次是函数展开后的结果被作为 Makefile 内容时由 make 解析时展开 的。明确这一过程对于使用 “eval” 函数非常重要。理解了函数 “eval” 二次展开的过程后。实际使用时，如果在函数的展开结果中存在引用（格式 为：$(x)），那么在函数的参数中应该使用 “$$” 来代替 “$”。因为这一点，所以通常它的参数中会使用函数“value” 来取一个变量的文本值。

我们看一个例子。例子看起来似乎非常复杂，因为它综合了其它的一些概念和函数。不过我们可以考虑两点：其一，通常实际一个模板的定义可能比例子中的 更为复杂；其二，我们可以实现一个复杂通用的模板，在所有 Makefile 中包含它，亦可作到一劳永逸。相信这一点可能是大多数程序员所推崇的。

示例：

**_# sample Makefile_**

**_PROGRAMS    = server client_**

 **_server_OBJS = server.o server_priv.o server_access.o_**

**_server_LIBS = priv protocol_**

**_client_OBJS = client.o client_api.o client_mem.o_**

**_client_LIBS = protocol_**

 **_# Everything after this is generic_**

**_.PHONY: all_**

**_all: $(PROGRAMS)_**

 **_define PROGRAM_template_**

**_$(1): $$($(1)_OBJ) $$($(1)_LIBS:%=-l%)_**

 **_ALL_OBJS   += $$($(1)_OBJS)_**

**_endef_**

 **_$(foreach prog,$(PROGRAMS),$(eval $(call PROGRAM_template,$(prog))))_**

 **_$(PROGRAMS):_**

 **_$(LINK.o) $^ $(LDLIBS) -o $@_**

 **_clean:_**

 **_rm -f $(ALL_OBJS) $(PROGRAMS)_**

来看一下这个例子：它实现的功能是完成 “PROGRAMS” 的编译链接。例子中 “$(LINK.o)” 为“$(CC) $(LDFLAGS)”，意思是对所有的. o 文件和指定的库文件进行链接。

 **_“$(foreach prog,$(PROGRAM),$(eval $(call PROGRAM_template,$(prog))))”_** 展开为：

 **_server : $(server_OBJS) –l$(server_LIBS)_**

 **_client : $(client_OBJS) –l$(client_LIBS)_**

上面一篇博文中，博主尝试创建一个非常简单的 helloworld 包，过程详见博文：[http://my.oschina.net/hevakelcj/blog/410633](http://my.oschina.net/hevakelcj/blog/410633)

本文将带大家一起深入地学习一下 OpenWrt 包的 Makefile。我们不仅要知其然，还要知其所以然。在上篇博文里，包里的 Makefile 内容如下：

include $(TOPDIR)/rules.mk

PKG_NAME:=helloworld

PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/helloworld

SECTION:=utils

CATEGORY:=Utilities

TITLE:=Helloworld — prints a snarky message

endef

define Package/helloworld/description

It’s my first package demo.

endef

define Build/Prepare

echo “Here is Package/Prepare”

mkdir -p $(PKG_BUILD_DIR)

$(CP) ./src/* $(PKG_BUILD_DIR)/

endef

define Package/helloworld/install

echo “Here is Package/install”

$(INSTALL_DIR) $(1)/bin

$(INSTALL_BIN) $(PKG_BUILD_DIR)/helloworld $(1)/bin/

endef

$(eval $(call BuildPackage,helloworld))

大概我们可以将简代为如下的结构：

include $(TOPDIR)/rules.mk

# 这里定义一系列的 PKG_XX

include $(INCLUDE_DIR)/package.mk

# 定义各种 Package, Build 宏

$(eval $(call BuildPackage, 包名))

下面，我们来一一拆解。

## 8.1.include $(TOPDIR)/rules.mk

首先，include $(TOPDIR)/rules.mk，也就是将 SDK/rules.mk 文件中的内容导入进来。

TOPDIR 就是 SDK 的路径。

在 SDK/rules.mk 文件中，定义了许多变量。

我们可以看出，在 Makefile 中，赋值是用 := ，而不是等号。

比如上面的 BUILD_DIR, INCLUDE_DIR 等，都在这里定义。还有：

还有关于 TARGET_CC, TARGET_CXX 等非常有用的变量定义。

还有 TAR， FIND， INSTALL_BIN, INSTALL_DIR, INSTALL_DATA 等等非常重要的变量定义。

## 8.2. 自定义 PKG_XXXX 变量

官网上指定有如下变量需要设置：

PKG_NAME        – The name of the package, as seen via menuconfig and ipkg

PKG_VERSION     – The upstream version number that we’re downloading

PKG_RELEASE     – The version of this package Makefile

PKG_LICENSE     – The license(s) the package is available under, SPDX form.

PKG_LICENSE_FILE- file containing the license text

PKG_BUILD_DIR   – Where to compile the package

PKG_SOURCE      – The filename of the original sources

PKG_SOURCE_URL- Where to download the sources from (directory)

PKG_MD5SUM      – A checksum to validate the download

PKG_CAT         – How to decompress the sources (zcat, bzcat, unzip)

PKG_BUILD_DEPENDS – Packages that need to be built before this package, but are not required at runtime. Uses the same syntax as DEPENDS below.

PKG_INSTALL     – Setting it to “1” will call the package’s original “make install” with prefix set to PKG_INSTALL_DIR

PKG_INSTALL_DIR – Where “make install” copies the compiled files

PKG_FIXUP       – ???

PKG_SOURCE_PROTO – the protocol to use for fetching the sources (git, svn)

PKG_REV         – the svn revision to use, must be specified if proto is “svn”

PKG_SOURCE_SUBDIR – must be specified if proto is “svn” or “git”, e.g. “PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)”

PKG_SOURCE_VERSION – must be specified if proto is “git”, the commit hash to check out

PKG_CONFIG_DEPENDS – specifies which config options depend on this package being selected

## 8.3.include $(INCLUDE_DIR)/package.mk

跟上面的 include $(TOPDIR)/rules.mk 是一样的。就是把这个文件包含进来。

INCLUDE_DIR 这个变量在 rules.mk 里已经定义了：

那就是 SDK/include/package.mk 文件了，打开看看。

主要有以下几个功能：

### （1）它会配置默认的变量

如果某个变量我们没有在上一部分里定义，那里在这个文件里，它就会被指定为默认值，比如：

上面的用 ?= 来表示给未定义的变量赋默认值。比如，如果没有指定 PKG_MD5SUM，那么就默认为 unknow。

### （2）推导其它变量

根据上部分用户自定义的 PKG_XXXX 变量推导出更多相关的变量。

比如：

虽然我没有看过相关的手册，根据多年的从业经验也能看出上面的意思来。

#如果定义了宏，就…

ifdef 宏名

…

endif

#如果宏相等

ifeq (宏 1, 宏 2)

…

endif

strip $ 宏名     # 将宏对应的值去除前后的空白字符

VAR += xxxx    # 在变量 VAR 后面追加 xxxx

我猜大概就是这样，如果不对请指正。

再比如如下：

就这样，它为我们提供了大量有价值的变量。

### （3）包含其它 mk 文件

### （4）定义默认宏

在 Makefile 中，宏的定义格式是：

define XXX/xxxx

<宏的实体…>

endef

package.mk 会把大部分需要的宏都定义好。理想情况下，用户只需要定义好了 PKG_XXX 之后，不需要再自定义宏，默认的宏就可以满足需求。

比如 Build/Prepare/Default 的定义：

Build/Prepare 宏是在编译前进行的，是准备工作。

可以看出，它分了两种情况：

A，定义了 USE_GIT_TREE，则按 git 的方式定义。

B，定义了 USB_SOURCE_DIR，则按源码在本地的方案定义。

### （5）BuildPackage 宏

最重要的一个宏是 BuildPackage。它会在 Makefile 的最后一行被引用。它的实现也就是在 package.mk 文件里。如下为其源码：

define BuildPackage

$(Build/IncludeOverlay)

$(eval $(Package/Default))    # 定义在 package-defaults.mk 文件里

$(eval $(Package/$(1)))       # 调用用户自定义的 Package/< 包名 > 宏

ifdef DESCRIPTION

$$(error DESCRIPTION:= is obsolete, use Package/PKG_NAME/description)

endif

#检查有没有定义 Package/<包名>/description 宏，如果没有定义，则以 TITLE 默认定义一个

ifndef Package/$(1)/description

define Package/$(1)/description

$(TITLE)

endef

endif

BUILD_PACKAGES += $(1)

$(STAMP_PREPARED): $$(if $(QUILT)$(DUMP),,$(call find_library_dependencies,$(DEPENDS)))

#检查 TITLE, CATEGORY, SECTION, VERSION 是否定义，如果没有定义则报错

$(foreach FIELD, TITLE CATEGORY SECTION VERSION,

ifeq ($($(FIELD)),)

$$(error Package/$(1) is missing the $(FIELD) field)

endif

)

#如果有定义 DUMP，那就引入 Dumpinfo/Package 宏的内部。

#如果没有，那么就引用 Packaget/<包名>/targets 里面的每一个 target，如果没有定义 Packaget/< 包名 >/targets 宏，那么将 PKG_TARGETS 里的每个 target 取出来，

#如果也没有定义 PKG_TARGETS，那就默认 ipkg 作为 target。将每一个 target，引用 BuildTarget/$(target)。

$(if $(DUMP), \

$(Dumpinfo/Package), \

$(foreach target, \

$(if $(Package/$(1)/targets),$(Package/$(1)/targets), \

$(if $(PKG_TARGETS),$(PKG_TARGETS), ipkg) \

), $(BuildTarget/$(target)) \

) \

)

$(if $(PKG_HOST_ONLY)$(DUMP),,$(call Build/DefaultTargets,$(1)))

endef

总结一下语法：

$() 表示要执行的一条语句

$(if 条件, 成立执行, 失败执行)        if 条件分支

$(foreach 变量, 成员列表, 执行体)   成员遍历语句

可以看出，语句是可以嵌套使用的。

$(N)  表示第 N 个参数

## 8.4. 自定义宏

### 必须定义的宏

我定要为我们的 package 定义特定的宏：

Package/<包名>    # 包的参数

在 Package/<包名> 宏中定义与包相关的信息。

如 Package/helloworld 宏：

<table><tbody><tr><td>1<p>2</p><p>3</p><p>4</p><p>5</p></td><td>define&nbsp;Package/helloworld<p>SECTION:=utils</p><p>CATEGORY:=Utilities</p><p>TITLE:=Helloworld&nbsp;—&nbsp;prints&nbsp;a&nbsp;snarky&nbsp;message</p><p>endef</p></td></tr></tbody></table>

除了上面所列的 SECTION，CATEGORY，TITLE 变量外，还可以定义：

SECTION     – 包的种类

CATEGORY    – 显示在 menuconfig 的哪个目录下

TITLE       –  简单的介绍

DESCRIPTION – (deprecated) 对包详细的介绍

URL – 源码所在的网络路径

MAINTAINER  – (required for new packages) 维护者是谁（出错了联系谁）

DEPENDS     – (optional) 需要依事的包，See [below](http://wiki.openwrt.org/doc/devel/packages#dependencytypes) for the syntax.

USERID      – (optional) a username:groupname pair to create at package installation time.

【PKG_VERSION 宏缺失时报错】：

OpenWrt Developers Team <openwrt-devel@openwrt.org>

@@

Makefile:53: *** Package/exfat is missing the VERSION field.  Stop.

### 可选定义的宏

其它的宏可以选择性地定义，通常没必要自己重写。但有些情况，package.mk 中默认的宏不能满足我们的需求。这时，我们就需要自己重定义宏。

比如，我们在为 helloworld 写 Makefile 时，我们要求在编译之前，将 SDK/package/helloworld/src/ 路径下的文件复制到 PKG_BUILD_DIR 所指定的目录下。

于是我们重新定义 Build/Prepare 宏：

[?](http://my.oschina.net/hevakelcj/blog/411942)

<table><tbody><tr><td>1<p>2</p><p>3</p><p>4</p></td><td>define&nbsp;Build/Prepare<p>mkdir&nbsp;-p&nbsp;$(PKG_BUILD_DIR)</p><p>$(CP)&nbsp;./src/*&nbsp;$(PKG_BUILD_DIR)/</p><p>endef</p></td></tr></tbody></table>

如此以来，在我们 make V=s 时，make 工具会在编译之前执行 Build/Prepare 宏里的命令。

再比如，我们要指定包的安装方法：

[?](http://my.oschina.net/hevakelcj/blog/411942)

<table><tbody><tr><td>1<p>2</p><p>3</p><p>4</p></td><td>define&nbsp;Package/helloworld/install<p>$(INSTALL_DIR)&nbsp;$(1)/bin</p><p>$(INSTALL_BIN)&nbsp;$(PKG_BUILD_DIR)/helloworld&nbsp;$(1)/bin/</p><p>endef</p></td></tr></tbody></table>

上面的这个宏就是指定了包的安装过程。其中 INSTALL_DIR 定义在 rules.mk 文件里。

INSTALL_DIR = install -d -m0755

INSTALL_BIN = install -m0755

$(1) 为第一个参数是./configure 时的–prefix 参数，通常为””

展开之后就是：

define Package/helloworld/install

install -d -m0755 /bin

install -m0755 $(PKG_BUILD_DIR)/helloworld /bin/

endef

它的意思就一目了然了。

除了上面所列举的这两个宏外，在官网上也说明了其它可选的宏：

##### Package/conffiles (optional)

由该包安装的配置文件的列表，一行一个文件。

##### Package/description

对包描述的纯文本

##### Build/Prepare (optional)

A set of commands to unpack and patch the sources. You may safely leave this undefined.

##### Build/Configure (optional)

You can leave this undefined if the source doesn’t use configure or has a normal config script, otherwise you can put your own commands here or use “$(call Build/Configure/Default,)” as above to pass in additional arguments for a standard configure script.

##### Build/Compile (optional)

How to compile the source; in most cases you should leave this undefined, because then the default is used, which calls make. If you want to pass special arguments to make, use e.g. “$(call Build/Compile/Default,FOO=bar)

##### Build/Install (optional)

How to install the compiled source. The default is to call make install. Again, to pass special arguments or targets, use $(call Build/Install/Default,install install-foo) Note that you need put all the needed make arguments here. If you just need to add something to the “install” argument, don’t forget the ‘install’ itself.

##### Build/InstallDev (optional)

For things needed to compile packages against it (static libs, header files), but that are of no use on the target device.

##### Package/install

A set of commands to copy files into the ipkg which is represented by the $(1) directory. As source you can use relative paths which will install from the unpacked and compiled source, or $(PKG_INSTALL_DIR) which is where the files in the Build/Install step above end up.

##### Package/preinst

The actual text of the script which is to be executed before installation. Dont forget to include the #!/bin/sh. If you need to abort installation have the script return false.

##### Package/postinst

The actual text of the script which is to be executed after installation. Dont forget to include the #!/bin/sh.

##### Package/prerm

The actual text of the script which is to be executed before removal. Dont forget to include the #!/bin/sh. If you need to abort removal have the script return false.

##### Package/postrm

The actual text of the script which is to be executed after removal. Dont forget to include the #!/bin/sh.

之所以有些宏是以”Package/” 开头，有的又以”Build/”，是因为在一个 Makefile 里生成多个包。OpenWrt 默认认为一个 Makefile 里定义一个包，但我们也可以根据需要将其拆分成多个。所以说，如果我们只希望编译一次，那么只要有一系列的”Build/” 的宏定义就可 以了。但是，我们也可以通过添加多个”Package/” 宏定义，并调用 BuildPackage，来创建多个包。

## 8.5. 使之生效

在 Makefile 的最后一行是：

$(eval $(call BuildPackage,helloworld))

最重要的 BuildPackage 定义在 package.mk 文件里。见上面 BuildPackage 宏定义。

## 8.6. 添加新编译选项

比如 dibbler 软件包的编译，需要编译 C++ 代码，需要使用 - Istdc++ 选项，可以在 dibbler 编译 Makefile 中添加 TAGET_CXXFLAGS +=-Istdc++ 即可。

其他相关参考：[http://blog.csdn.net/suiyuan19840208/article/details/25737323/](http://blog.csdn.net/suiyuan19840208/article/details/25737323/)

原文地址：[http://www.right.com.cn/forum/thread-73443-1-1.html](http://www.right.com.cn/forum/thread-73443-1-1.html)

本文是本人对 OpenWrt 的 Makefile 的理解，并非转载。  
OpenWrt 是一个典型的嵌入式 Linux 工程，了解 OpenWrt 的 Makefile 的工作过程对提高嵌入式 Linux 工程的开发能力有极其重要意义。  
OpenWrt 的主 Makefile 文件只有 100 行，可以简单分为三部分，1~17 行为前导部分，19~31 为首次执行部分，33~101 为再次执行部分。  
前导部分  
CURDIR 为 make 默认变量，默认值为当前目录。  
前导部分主要把变量 TOPDIR 赋值为当前目录，把变量 LC_ALL、LANG 赋值为 C，并使用变量延伸指示符 export，把上述三个变量延伸到下层 Makefile。  
使用文件使用指示符 include 引入 $(TOPDIR)/include/host.mk。在 OpenWrt 的主 Makefile 文件使用了多次 include 指示符，说明主 Makefile 文件被拆分成多个文件，被拆分的文件放在不同的目录。拆分的目的是明确各部分的功能，而且增加其灵活性。  
在前导部分比较费解的是使用 world 目标，在 makefile 中基本规则为：  
TARGETS : PREREQUISITES  
COMMAND  
…  
即 makefile 规则由目标、依赖、命令三部分组成，在 OpenWrt 的主 Makefile 文件的第一个目标 world 没有依赖和命令。它主要起到指示 当 make 命令不带目标时所要执行的目标，没有设定依赖和命令部分表明此目标在此后将会有其他依赖关系或命令。world 目标的命令需要进一步参 考 $(TOPDIR)/include/toplevel.mk 和主 Makefile 文件的再次执行部分。  
首次执行部分  
OPENWRT_BUILD 是区分首次执行与再次执行的变量。在首次执行时使用强制赋值指示符 override 把 OPENWRT_BUILD 赋值为 1，并 使用变量延伸指示符 export 把 OPENWRT_BUILD 延伸。在 OPENWRT_BUILD 使用强制赋值指示符 override 意味着 make 命令 行可能引入 OPENWRT_BUILD 参数。  
引入 $(TOPDIR)/include/debug.mk、$(TOPDIR)/include/depends.mk、$(TOPDIR) /include/toplevel.mk 三个文件，由于 TOPDIR 是固定的，所以三个文件也是固定的。其中 $(TOPDIR)/include /toplevel.mk 的 135 行 %:: 有效解释首次执行时 world 目标的规则。  
再次执行部分  
引入 rules.mk、$(INCLUDE_DIR)/depends.mk、$(INCLUDE_DIR)/subdir.mk、target /Makefile、package/Makefile、tools/Makefile、toolchain/Makefile 七个文 件，rules.mk 没有目录名，即引入与主 Makefile 文件目录相同的 rules.mk。在 rules.mk 定义了 INCLUDE_DIR 为 $(TOPDIR)/include，所以 $(INCLUDE_DIR)/depends.mk 实际上与首次执行时引入的 $(TOPDIR) /include/depends.mk 是同一个文件。  
四个子目录下的 Makefile 实际上是不能独立执行。主要利用 $(INCLUDE_DIR)/subdir.mk 动态建立规则，诸 如 $(toolchain/stamp-install) 目标是靠 $(INCLUDE_DIR)/subdir.mk 的 stampfile 函数动态建立。 在 package/Makefile 动态建立了 $(package/ stamp-prereq)、$(package/ stamp-cleanup)、$(package/ stamp-compile)、$(package/ stamp-install)、$(package/ stamp-rootfs-prepare) 目标。  
定义一些使用变量命名的目标，其变量的赋值位置在 $(INCLUDE_DIR)/subdir.mk 的 stampfile 函数中。目标只有依赖关系，可能 说明其工作顺序，在 $(INCLUDE_DIR)/subdir.mk 的 stampfile 函数中有进一步说明其目标执行的命令，并为目标建立一个空文 件，即使用变量命名的目标为真实的文件。  
定义一些使用固定的目标规则。  
其中：clean 是清除编译结果的目标，清除 $(BUILD_DIR) $(BIN_DIR) $(BUILD_LOG_DIR) 三个目录的用意是十分明确。暂时不知道为什么执行 make target/linux/clean。  
dirclean 是删除所有编译过程产生的目录和文件的目标，执行 dirclean 目标依赖于 clean，因此将执行 clean 目标所执行的命令，然后删 除 $(STAGING_DIR) $(STAGING_DIR_HOST) $(STAGING_DIR_TOOLCHAIN) $(TOOLCHAIN_DIR) $(BUILD_DIR_HOST) $(BUILD_DIR_TOOLCHAIN) 目录，以及删除 $(TMP_DIR) 目录。上述目录的变量均在 rules.mk 定义。好像删除 staging_dir 目录就意味着删除 staging_dir 目录下的所有子目录，不知道为什么要强调删除 $(STAGING_DIR_HOST) $(STAGING_DIR_TOOLCHAIN) $(TOOLCHAIN_DIR) 目录。同样删除 builde_dir 目录就意味着删除 builde_dir 目录下的所有子目录，不知道为什么要强调删 除 $(BUILD_DIR_TOOLCHAIN) 目录。  
tmp/.prereq_packages 目标是对所需软件包的预处理。目标依赖于. config，即执行 make menuconfig 后将会进行一次所需软件包的预处理。不知什么原因在编译前删除 tmp 目录，执行时无法建立 tmp/.prereq_packages 文件。  
prereq 应该是预请求目标，在 OpenWrt 执行 Makefile 时好像都要先执行 prereq 目标。  
prepare 应该是准备目标，是 world 依赖的一个伪目标。依赖于文件. config 和 $(tools/stamp-install) $(toolchain/stamp-install) 目标。  
world 就是编译的目标。依赖于 prepare 为目标和前面提到的变量命名目标。采用取消隐含规则方式执行 package/index 目标。package/index 目标在 package/Makefile 的 92 行定义。  
package/symlinks 和 package/symlinks-install 是更新或安装软件包来源的目标，使用 $(SCRIPT_DIR)/feeds 脚本文件完成。  
package/symlinks-clean 是清除软件包来源的目标，也是使用 $(SCRIPT_DIR)/feeds 脚本文件完成。  
最后使用伪目标. PHONY 说明 clean dirclean prereq prepare world package/symlinks package/symlinks-install package/symlinks-clean 属于伪目标。通过伪目标说明可以知道可以执行的目标。

Openwrt 官网 [http://wiki.openwrt.org/start](http://wiki.openwrt.org/start)

软件包相关：[https://dev.openwrt.org/browser/branches/packages_10.03.2?order=name](https://dev.openwrt.org/browser/branches/packages_10.03.2?order=name)

关于包的依赖问题：[http://wiki.openwrt.org/doc/devel/dependencies](http://wiki.openwrt.org/doc/devel/dependencies)

## （1）【close】在移植 exfat 驱动到 openwrt 时遇到如下问题：

nickli@NewRouterDev:qsdk$ make package/exfat/{clean,prepare,compile,install} V=99

Collecting package info: done

make[1]: Entering directory `/home/nickli/puma_sdk/qualcomm_sdk/qsdk’

make[2]: Entering directory `/home/nickli/puma_sdk/qualcomm_sdk/qsdk/package/exfat’

Makefile:56: warning: overriding commands for target `/home/nickli/puma_sdk/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/exfat’

Makefile:56: warning: ignoring old commands for target `/home/nickli/puma_sdk/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/exfat’

Makefile:56: warning: overriding commands for target `/home/nickli/puma_sdk/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/exfat’

Makefile:56: warning: ignoring old commands for target `/home/nickli/puma_sdk/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/exfat’

rm -f /home/nickli/puma_sdk/qualcomm_sdk/qsdk/staging_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/stamp/.exfat _installed

bash: line 2: [: packages/exfat: binary operator expected

rm -f /home/nickli/puma_sdk/qualcomm_sdk/qsdk/bin/ipq806x/packages/exfat_*

rm -f /home/nickli/puma_sdk/qualcomm_sdk/qsdk/staging_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/packages/exfat .list /home/nickli/puma_sdk/qualcomm_sdk/qsdk/staging_dir/host/packages/exfat .list

rm -rf /home/nickli/puma_sdk/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/exfat

make[2]: Leaving directory `/home/nickli/puma_sdk/qualcomm_sdk/qsdk/package/exfat’

make[1]: Leaving directory `/home/nickli/puma_sdk/qualcomm_sdk/qsdk’

make[1]: Entering directory `/home/nickli/puma_sdk/qualcomm_sdk/qsdk’

make[2]: Entering directory `/home/nickli/puma_sdk/qualcomm_sdk/qsdk/package/exfat’

Makefile:56: *** target file `/home/nickli/puma_sdk/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/exfat’ has both : and :: entries.  Stop.

make[2]: Leaving directory `/home/nickli/puma_sdk/qualcomm_sdk/qsdk/package/exfat’

make[1]: *** [package/exfat/prepare] Error 2

make[1]: Leaving directory `/home/nickli/puma_sdk/qualcomm_sdk/qsdk’

make: *** [package/exfat/prepare] Error 2

问题原因：在 Makefile 中版本号变量后面多了个空格。

PKG_NAME:=exfat

PKG_VERSION:=0.9.5$space_char

PKG_RELEASE:=1

解决方法：将版本号后面的空格去掉

结果：问题解决。

参考：[https://forum.openwrt.org/viewtopic.php?id=20353](https://forum.openwrt.org/viewtopic.php?id=20353)

## （2）【close】SDK 修改目录名称后无法继续编译问题解决

问题现象：check 了一份 openwrt 的 SDK，执行编译之后又重新修改了该 SDK 的名称，导致后续再编译时无法编译。

原因：有些编译器是动态编译生成的，但是 make clean 之后编译器不会重新编译，其路径与绝对路径有关，修改名称后无法找到相关编译器。

解决方法：进入 SDK 根目录执行 make distclean，将所有编译记录完整清除即可。

结果：问题解决（应该有更加优化的方法，即删除其中交叉编译链相关内容，后续有时间再解决）

## （3）【close】编译单个模块软件时，提示缺少 C 库

编译单个模块软件时，在最后一步执行打包操作时提示缺少 libc.so.6 而无法打包，信息如下：

Package skysoft_net6scan is missing dependencies for the following libraries:

libc.so.6

原因：编译单个模块时，缺少目标平台相同的 libc.so.6 文件。

解决方法：

参考：[http://my.oschina.net/hevakelcj/blog/411944](http://my.oschina.net/hevakelcj/blog/411944)

真正解决问题的参考：[http://www.cnblogs.com/liushannet/p/3895092.html](http://www.cnblogs.com/liushannet/p/3895092.html)

查看依赖文件：

nickli@NewRouterDev:qsdk$ readelf -d build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/skysoft_net6scan/net6scan

Dynamic section at offset 0x2e28 contains 24 entries:

Tag        Type                         Name/Value

0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]

0x000000000000000c (INIT)               0x400c28

0x000000000000000d (FINI)               0x401ad0

0x0000000000000019 (INIT_ARRAY)         0x602e10

0x000000000000001b (INIT_ARRAYSZ)       8 (bytes)

0x000000000000001a (FINI_ARRAY)         0x602e18

0x000000000000001c (FINI_ARRAYSZ)       8 (bytes)

0x000000006ffffef5 (GNU_HASH)           0x400298

实际解决方法：

先检查系统里面有没有这个库存在, 如果没有, 安装 (在 / lib /lib64 等目录找)  
之后添加库 openwrt 的编译环境  
修改 libc.provides 平台不同, 可能目录不同, find ./stagging_dir -name libc.provides 下  
一般在 stagging_dir/target-mipsel_r2_uClibc-0.9.33.2/pkginfo/libc.provides  
底部添加  
libc.so.6  
或其他需要的库, 编译时候会把这个 so 转为 openwrt 平台的库

相关命令：

1332  find /lib* -name “libc.so.6”

1333  find ./staging_dir/ -name libc.provides

1334  vim ./staging_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/pkginfo/libc.provides

在该文件末尾添加 libc.so.6 后保存并退出，之后执行编译：

1335  make package/skysoft_net6scan/{clean,prepare,compile,install} V=99

能正常打包了！

结果：问题解决。

## （4）【close】编译的模块无法在 opentwr 系统中运行

root@rt4230w:~# /sbin/net6scan

/sbin/net6scan: line 1: syntax error: unexpected “(”

问题原因：在编译的模块 Makefile 中将编译器写死成了 gcc，而实际上目标平台为 arm 需要使用交叉编译器。

解决方法：修改源码内的 makefile，将 gcc 改成 $(CC)，结果如下：

CFLAGS += -Wall -D_GNU_SOURCE

net6scan : main.o func.o

$(CC) $(CFLAGS) -o net6scan main.o func.o

main.o : main.c

$(CC) $(CFLAGS) -c main.c

func.o : func.c

$(CC) $(CFLAGS) -c func.c

clean:

rm -rf ip6scan *.o

结果：问题解决

## （5）【close】在原 odhcp6c 源码中增加了 log.c log.h 文件后，编译时出现如下问题：

make[3]: Entering directory `/home/nickli/cascade_sdk_new_platform/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/odhcp6c-2015-07-13′

make[4]: Entering directory `/home/nickli/cascade_sdk_new_platform/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/odhcp6c-2015-07-13′

make[5]: Entering directory `/home/nickli/cascade_sdk_new_platform/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/odhcp6c-2015-07-13′

make[5]: Leaving directory `/home/nickli/cascade_sdk_new_platform/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/odhcp6c-2015-07-13′

make[5]: Entering directory `/home/nickli/cascade_sdk_new_platform/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/odhcp6c-2015-07-13′

[16%] Building C object CMakeFiles/odhcp6c.dir/src/odhcp6c.c.o

[33%] Building C object CMakeFiles/odhcp6c.dir/src/log.c.o

/home/nickli/cascade_sdk_new_platform/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/odhcp6c-2015-07-13/src/log.c: In function ‘_get_time’:

/home/nickli/cascade_sdk_new_platform/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/odhcp6c-2015-07-13/src/log.c:117:9: error: missing initializer [-Werror=missing-field-initializers]

/home/nickli/cascade_sdk_new_platform/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/odhcp6c-2015-07-13/src/log.c:117:9: error: (near initialization for ‘tv.tv_usec’) [-Werror=missing-field-initializers]

/home/nickli/cascade_sdk_new_platform/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/odhcp6c-2015-07-13/src/log.c:118:9: error: missing initializer [-Werror=missing-field-initializers]

/home/nickli/cascade_sdk_new_platform/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/odhcp6c-2015-07-13/src/log.c:118:9: error: (near initialization for ‘time_value.tm_min’) [-Werror=missing-field-initializers]

/home/nickli/cascade_sdk_new_platform/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/odhcp6c-2015-07-13/src/log.c: In function ‘debug_log_print’:

/home/nickli/cascade_sdk_new_platform/qualcomm_sdk/qsdk/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/odhcp6c-2015-07-13/src/log.c:140:51: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]

cc1: all warnings being treated as errors

分析：error: missing initializer [-Werror=missing-field-initializers]，应该是编译程序时将警告当错误了，提示这里需要初始化，而实际上一时间没有 看出哪儿来执行正确的初始化，所以从取消掉这种警告机制着手解决。

解决办法：修改编译目录内的 (build_dirvim) CMakeLists.txt 文件，将 - Werror 改为 - Wno-missing-field-initializers，如下：

8 #add_definitions(-D_GNU_SOURCE -Wall -Werror -Wextra -pedantic)

9 add_definitions(-D_GNU_SOURCE -Wall –Wno-missing-field-initializers -Wextra -pedantic)

结果：问题解决。

小结：

（1）-Werror 选线会将警告升级为错误来报告

（2）odhcp6c 源码编译采用了 Cmake 而没有使用我们一般使用的方式——在 src 目录内写一份 Makefile 文件来编译文件，所以其规则文件都在和 src 目录同级的 CMakeLists.txt 文件中。可以学习了解一下 CMake 机制。

本文章由作者：

[佐须之男](https://www.openwrt.pro/author/1)

整理编辑，原文地址:

OpenWRT 基本知识整理

本站的文章和资源来自互联网或者站长的原创，按照 CC BY -NC -SA 3.0 CN 协议发布和共享，转载或引用本站文章应遵循相同协议。如果有侵犯版权的资 源请尽快联系站长，我们会在 24h 内删除有争议的资源。欢迎大家多多交流，期待共同学习进步。

<div class="action-share bdsharebuttonbox"> 分享到：<a class="bds_qzone" data-cmd="qzone"></a><a class="bds_tsina" data-cmd="tsina"></a><a class="bds_weixin" data-cmd="weixin"></a><a class="bds_tqq" data-cmd="tqq"></a><a class="bds_sqq" data-cmd="sqq"></a><a class="bds_copy" data-cmd="copy"></a><a class="bds_more" data-cmd="more"> 更多 </a></div>