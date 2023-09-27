## **起因**

由于目前市面上很多模拟器诸如夜神, 网易 MUMU, 基本上使用的是 x86 的架构, 虽然运行 ARM 程序没有问题, 但是如果想使用`gdb`对 ARM 程序进行调试的话, 就显得力不从心了, 各种问题层出不穷,

当然调试 x86 程序是没有问题的，

如果非要对 ARM 程序进行`gdb`调试的话，可以采用 Android Studio 原生的模拟器（原生 ARM 太卡），但是考虑到很多人并不是从事安卓开发，加上 Studio 中的模拟器本就基于 QEMU, 那么为了方便，我们直接搭建 QEMU 的环境

## **实验环境**

- Windows 宿主平台

- QEMU 安装包（这里使用的是 20201124 的版本）：[https://qemu.weilnetz.de/w64/](https://qemu.weilnetz.de/w64/)

- 树莓派系统镜像：[http://downloads.raspberrypi.org/raspbian/images/raspbian-2020-02-14/](http://downloads.raspberrypi.org/raspbian/images/raspbian-2020-02-14/) 树莓派是基于 Debian 的 Linux 系统

## **操作步骤**

QEMU 下载安装完毕后, 其安装目录会包含很多不同架构的执行文件, 这里我们选择`qemu-system-arm.exe`, 打开命令窗口:

```Plain Text
qemu-system-arm.exe -machine versatilepb -L  -m 128  -hda 2020-02-13-raspbian-buster.img

```

**相关指令选项介绍:**

- **-M** : 指定机器

- **-name**：给虚拟系统起个名称

- **-cpu**: 指定 cpu 型号

- **-smp** : 指定 cpu 的个数 比如`-smp 2`

- **-m**: 指定内存大小单位 MB

- **-vga** : 指定显卡 比如 `-vga vmware`

- **-hda**: 指定硬盘镜像

- **-initrd**: 指定 RAM 磁盘镜像

- **-fda** : 指定软盘镜像

- **-L**:bios 位置

- **-cdrom**: 光盘镜像

- **-no-reboot:** 不重启退出

- **-kernel** : 指定内核文件

- **-serial** : 设置串口 比如:`-serial stdio` 表示 重定向 Guest 的串口到 Host 的标准输入输出

- **-boot** : 启动模式 一共有三种 , 分别为`floppy(a), hard disk(c), CD-ROM(d)`

上面这条指令显然无法启动系统，因为还缺少了相应`kernel-qemu`文件和配置：

**kernel-qemu 下载**：

GitHub - dhruvvyas90/qemu-rpi-kernel: Qemu kernel for emulating Rpi on QEMU

我们选择里面的`versatile-pb-buster.dtb` 和`kernel-qemu-5.4.51-buster` 这两个文件进行下载，这是和系统版本一一对应的。下载后最好放在 qemu 的安装目录

然后输入以下指令：

```Plain Text
qemu-system-arm -M versatilepb -cpu arm1176 -m 256 -drive "file=系统镜像路径,if=none,index=0,media=disk,format=raw,id=disk0" -device "virtio-blk-pci,drive=disk0,disable-modern=on,disable-legacy=off" -net "user,hostfwd=tcp::5022-:22" -dtb versatile-pb-buster.dtb -kernel kernel-qemu-5.4.51-buster -append "root=/dev/vda2 panic=1" -no-reboot -net nic

```

注意：需要按照以上指令运行，否则有可能出现系统启动不起来的情况 `-net nic` 可开启网络 方便远程连接 `-net "user,hostfwd=tcp::5022-:22"` 表示设置端口映射

系统安装完毕后，直接进入树莓派桌面，在弹出的设置窗口中可以更改系统语言为中文, 还可以设置系统密码

至此`ARM+Linux`环境搭建完毕

## **准备开发**

接下来我们通过`ssh`连接树莓派终端, 打开`cmd`命令窗口, 输入:

回车后会提示输入密码, 这里输入之前设置的系统密码

此时就进入树莓派的`Linux`终端, 为什么不直接使用`qemu`中的 LX 终端? 还不是因为模拟器延迟卡顿

如果想往树莓派中传输文件, 可以直接使用`ftp`工具, 比如`FileZilla`或者 `SecureCRT` 选择`sftp`或者`ssh2`模式, 其登陆参数如下:

- **主机**:127.0.0.1

- **用户名**:pi

- **端口**:5022,

- **密码同上**

## **程序调试**

紧接着使用`gdb+gdbserver`对 C 程序进行调试

首先利用`ftp`工具将已经编译好的可执行文件和 GCC 包下`arm-none-linux-gnueabi\libc\usr\bin`目录中的`gdbserver`传送到模拟器中

然后执行以下命令:

开始监听端口, 但是问题来了, 该模拟器的`ip`不在局域网段上, 导致[宿主机](https://cloud.tencent.com/product/cdh?from=10680)连接不上, 如果你也出现同样的问题, 可以采用端口映射的办法来替代, 方法很简单, 只需要在模拟器启动时多追加加上一行参数`hostfwd=tcp::22349-:22349`, 具体启动指令修改如下:

```Plain Text
qemu-system-arm -M versatilepb -cpu arm1176 -m 256 -drive "file=2020-02-13-raspbian-buster.img,if=none,index=0,media=disk,format=raw,id=disk0" -device "virtio-blk-pci,drive=disk0,disable-modern=on,disable-legacy=off" -net "user,hostfwd=tcp::5022-:22,hostfwd=tcp::22349-:22349" -dtb versatile-pb-buster.dtb -kernel kernel-qemu-5.4.51-buster -append "root=/dev/vda2 panic=1" -no-reboot  -net nic

```

如此一来就可以在宿主`gdb`调试窗口中直接使用以下指令进行连接:

```Plain Text
(gdb) target remote 127.0.0.1:22349

```

连接成功了, 通过以上这种方式, 我们只需要将模拟器启动使其后台运行, 我们通过 ssh 进行登录连接, 这样速度快了很多, 而且相比一些安卓模拟器, QEMU 占用系统资源也不高

另外我们发现，还存在**声卡缺失，同时运行有延迟卡顿**现象，我们接下来对这两方面进行优化

## **小问题**

如果是 raw 格式, 可能会有些风险警告, 可以通过`-drive format=raw`进行指定处理:

```Plain Text
qemu-system-arm.exe  -machine raspi2b -drive file=2020-02-13-raspbian-buster.img,format=raw,index=0,media=disk

```

## **附加内容**

**查看 cpu 信息:**

**查看系统和内核版本:**

### **镜像备份模式**

随着我们对系统的频繁操作我们发现系统镜像文件在不断增大，此时想要回到原来的状态，只能重新下载镜像安装了，如果你不想遭受重新下载的痛苦，那么建议你使用备份镜像的模式进行系统的安装

这时`qemu-img.exe`派上了用场，它不仅可以帮助你创建空镜像文件，而且还可以对已有的镜像文件进行格式转换，QEMU 支持的镜像有以下：

|||
|-|-|
|VMDK (VMware)|vmdk|
|QCOW2 (KVM, Xen)|qcow2|
|VHD (Hyper-V)|vpc|
|VHDX (Hyper-V)|vhdx|
|RAW|raw|
|VDI (VirtualBox)|vdi|

`qemu-img` 支持非常多种的文件格式，可以通过 `qemu-img -h` 查看. 其中 `raw` 和 `qcow2` 是比较常用的两种， `raw` 是 `qemu-img` 命令默认的，`qcow2` 是 `qemu` 目前推荐的镜像格式，是功能最多的格式

**创建空镜像文件：**

```Plain Text
qemu-img create -f qcow2 test.qcow2 10G

```

- `-f` 选项用于指定镜像的格式，

- `qcow2` 格式是 QEMU 最常用的镜像格式，采用来写时复制技术来优化性能。

- `test.qcow2` 是镜像文件的名字，

- 10G 是镜像文件最大值

**镜像转换:**

```Plain Text
qemu-img.exe  convert -f raw system.img -O vmdk  system.vmdk

```

表示将原始格式的镜像文件转换成`vmdk`格式

**使用备份镜像的方式启动镜像示例：**

```Plain Text
qemu-system-x86_64 -m 2048 -enable-kvm test.qcow2 -cdrom Centos-Desktop-x86_64-20-1.iso

```

## **附加镜像**

- openwrt:[https://archive.openwrt.org/chaos_calmer/](https://archive.openwrt.org/chaos_calmer/)

- Debian 系统镜像：[https://people.debian.org/~aurel32/qemu/](https://people.debian.org/~aurel32/qemu/)

- 谷歌安卓原生镜像：[https://developers.google.cn/android/images](https://developers.google.cn/android/images)

- 树莓派 x86 镜像: [https://www.raspberrypi.org/downloads/raspberry-pi-desktop/](https://www.raspberrypi.org/downloads/raspberry-pi-desktop/)

