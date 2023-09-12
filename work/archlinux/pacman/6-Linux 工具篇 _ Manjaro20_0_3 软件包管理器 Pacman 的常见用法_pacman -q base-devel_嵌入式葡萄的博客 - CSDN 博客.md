---
url: https://blog.csdn.net/Neutionwei/article/details/108456141
title: Linux 工具篇 _ Manjaro20_0_3 软件包管理器 Pacman 的常见用法_pacman -q base-devel_嵌入式葡萄的博客 - CSDN 博客
date: 2023-06-09 17:39:37
tag: 
banner: "undefined"
banner_icon: 🔖
---
# 一、Pacman 软件包管理器

**Pacman 软件包管理器是 Arch Linux 的一大亮点。它将一个简单的二进制包格式和易用的构建系统结合了起来。不管软件包是来自官方的 Arch 库还是用户自己创建，pacman 都能方便地管理。**

**pacman 通过和主服务器同步软件包列表来进行系统更新。这种服务器 / 客户端模式可以使用一条命令就下载或安装软件包，同时安装必需的依赖包。**

**pacman 用 C 语言编写，使用 tar 打包格式。**

# 二、Pacman 常见用法

## （1）-S 指令

### 安装：

```
sudo pacman -S <pkg_name>  #安装软件
sudo pacman -Sy  #获取最新软件情况，如果已经是最新了，直接会提示已经更新到最新。
sudo pacman -Syy #强行更新你的应用的软件库（源）
sudo pacman -Su  #更新所有软件
sudo pacman -Syu #更新软件源，并更新所有软件
sudo pacman -Syyu #强行更新一遍，再更新所有软件
```

### 查询一个软件：

```
sudo pacman -Ss <pkg_name> #查询所有软件名里面带有<pkg_name>相关的软件，并且查询名支持正则表达

```

### 删除软件 / var 目录下的缓存：

```
sudo pacman -Sc

```

## （2）-R 指令

```
sudo pacman -R <pkg_name>   #删除软件
sudo pacman -Rs <pkg_name>  #删除软件，并删除<pkg>所有的依赖包
sudo pacman -Rns <pkg_name> #删除软件，并删除<pkg>所有的依赖，并删掉<pkg>的全局配置文件。 推荐！！
sudo pacman -R $(sudo pacman -Qdtq) #查询孤儿软件并删除
```

## （3）-Q 指令

```
sudo pacman -Q   #显示出所有软件 sudo pacman -Q | wc -l 查询数量
sudo pacman -Qe  #查询所有自己安装的软件
sudo pacman -Qeq #查询所有自己安装的软件，只显示包名，不显示版本号等
sudo pacman -Qs <pkg_name> #查询本地安装的所有带<pkg_name>的软件
sudo pacman -Qdt #查询所有孤儿软件，不再被需要的。
sudo pacman -Qdtq #查询所有不再被依赖的包名
```

# 三、案例

## （1）查看远程库有 GCC 关键字的软件包：

```
$ pacman -Sl | grep gcc
core gcc 10.2.0-1 [installed: 10.1.0-2]
core gcc-ada 10.2.0-1
core gcc-d 10.2.0-1
core gcc-fortran 10.2.0-1
core gcc-go 10.2.0-1
core gcc-libs 10.2.0-1 [installed: 10.1.0-2]
core gcc-objc 10.2.0-1
core lib32-gcc-libs 10.2.0-1 [installed: 10.1.0-2]
community aarch64-linux-gnu-gcc 10.2.0-1
community arm-none-eabi-gcc 10.2.0-1
community avr-gcc 10.2.0-1
community colorgcc 1.4.5-2
community gcc8 8.4.0-1
community gcc8-fortran 8.4.0-1
community gcc8-libs 8.4.0-1
community gcc9 9.3.0-3
community gcc9-fortran 9.3.0-3
community gcc9-libs 9.3.0-3
community ghdl-gcc 0.37-9
community gnome-shell-extension-dash-to-panel v38+9+gcc75702-1
community hsd-git 1.0.0.beta.15.856.gcc1ef7ab-1
community lm32-elf-gcc 10.1.0-1
community mingw-w64-gcc 10.2.0-1
community nds32le-elf-gcc 10.1.0-1
community or1k-elf-gcc 10.1.0-1
community riscv64-elf-gcc 10.1.0-1
community riscv64-linux-gnu-gcc 10.1.0-1
archlinuxcn arm-linux-gnueabihf-gcc 9.1.0-2
archlinuxcn arm-linux-gnueabihf-gcc-fortran 9.1.0-2
archlinuxcn arm-linux-gnueabihf-gcc-libs 9.1.0-2
archlinuxcn arm-linux-gnueabihf-gcc-objc 9.1.0-2
archlinuxcn libgccjit 10.1.0-4
archlinuxcn mingw-w64-gcc-base 10.1.0-1
```

 **另外也可以使用一下命令：**

```
pacman -Ss gcc

```

## （2）查看远程库软件包的详细信息（以 GCC 为例）：

```
$ pacman -Si gcc
Repository      : core
Name            : gcc
Version         : 10.2.0-1
Description     : The GNU Compiler Collection - C and C++ frontends
Architecture    : x86_64
URL             : https://gcc.gnu.org
Licenses        : GPL  LGPL  FDL  custom
Groups          : base-devel
Provides        : gcc-multilib
Depends On      : gcc-libs=10.2.0-1  binutils>=2.28  libmpc
Optional Deps   : lib32-gcc-libs: for generating code for 32-bit ABI
Conflicts With  : None
Replaces        : gcc-multilib
Download Size   : 31.53 MiB
Installed Size  : 147.32 MiB
Packager        : Bartłomiej Piotrowski <bpiotrowski@archlinux.org>
Build Date      : 2020年08月09日 星期日 18时56分38秒
Validated By    : MD5 Sum  SHA-256 Sum  Signature
```

## （3）查看软件包安装的详细路径（以谷歌拼音为例）：

```
$ pacman -Ql fcitx-googlepinyin
fcitx-googlepinyin /usr/
fcitx-googlepinyin /usr/lib/
fcitx-googlepinyin /usr/lib/fcitx/
fcitx-googlepinyin /usr/lib/fcitx/fcitx-googlepinyin.so
fcitx-googlepinyin /usr/share/
fcitx-googlepinyin /usr/share/fcitx/
fcitx-googlepinyin /usr/share/fcitx/addon/
fcitx-googlepinyin /usr/share/fcitx/addon/fcitx-googlepinyin.conf
fcitx-googlepinyin /usr/share/fcitx/imicon/
fcitx-googlepinyin /usr/share/fcitx/imicon/googlepinyin.png
fcitx-googlepinyin /usr/share/fcitx/inputmethod/
fcitx-googlepinyin /usr/share/fcitx/inputmethod/googlepinyin.conf
fcitx-googlepinyin /usr/share/fcitx/skin/
fcitx-googlepinyin /usr/share/fcitx/skin/classic/
fcitx-googlepinyin /usr/share/fcitx/skin/classic/googlepinyin.png
fcitx-googlepinyin /usr/share/fcitx/skin/default/
fcitx-googlepinyin /usr/share/fcitx/skin/default/googlepinyin.png
fcitx-googlepinyin /usr/share/icons/
fcitx-googlepinyin /usr/share/icons/hicolor/
fcitx-googlepinyin /usr/share/icons/hicolor/16x16/
fcitx-googlepinyin /usr/share/icons/hicolor/16x16/apps/
fcitx-googlepinyin /usr/share/icons/hicolor/16x16/apps/fcitx-googlepinyin.png
fcitx-googlepinyin /usr/share/icons/hicolor/48x48/
fcitx-googlepinyin /usr/share/icons/hicolor/48x48/apps/
fcitx-googlepinyin /usr/share/icons/hicolor/48x48/apps/fcitx-googlepinyin.png
fcitx-googlepinyin /usr/share/locale/
fcitx-googlepinyin /usr/share/locale/zh_CN/
fcitx-googlepinyin /usr/share/locale/zh_CN/LC_MESSAGES/
fcitx-googlepinyin /usr/share/locale/zh_CN/LC_MESSAGES/fcitx-googlepinyin.mo
fcitx-googlepinyin /usr/share/locale/zh_TW/
fcitx-googlepinyin /usr/share/locale/zh_TW/LC_MESSAGES/
fcitx-googlepinyin /usr/share/locale/zh_TW/LC_MESSAGES/fcitx-googlepinyin.mo
```

## （4）查看本地软件包的详细介绍（以谷歌拼音为例）:

```
$ pacman -Qi fcitx-googlepinyin
Name            : fcitx-googlepinyin
Version         : 0.1.6-7
Description     : Fcitx Wrapper for googlepinyin
Architecture    : x86_64
URL             : https://github.com/fcitx/fcitx-googlepinyin
Licenses        : GPL
Groups          : None
Provides        : None
Depends On      : fcitx  libgooglepinyin
Optional Deps   : None
Required By     : None
Optional For    : None
Conflicts With  : None
Replaces        : None
Installed Size  : 28.77 KiB
Packager        : Felix Yan <felixonmars@archlinux.org>
Build Date      : 2020年07月07日 星期二 21时41分36秒
Install Date    : 2020年09月09日 星期三 06时54分13秒
Install Reason  : Explicitly installed
Install Script  : No
Validated By    : Signature
 
```

## （5）查看本地所有的软件包:

```
$ pacman -Qs
local/a52dec 0.7.4-11
    A free library for decoding ATSC A/52 streams
local/aalib 1.4rc5-14
    A portable ASCII art graphic library
local/accountsservice 0.6.55-2
    D-Bus interface for user account query and manipulation
......
```

## （6）安装本地软件包（以谷歌拼音为例）：

```
sudo pacman -U fcitx-googlepinyin-0.1.6-7-x86_64.pkg.tar.zst

```

## （7）总结：

**-S 特指远程库，-Q 特指本地库，更详细命令解释参考：[Manjaro - Pacman 命令详解_写虫师的博客 - CSDN 博客_manjaro pacman](https://blog.csdn.net/nangy2514/article/details/93194184 "Manjaro - Pacman命令详解_写虫师的博客-CSDN博客_manjaro pacman")**