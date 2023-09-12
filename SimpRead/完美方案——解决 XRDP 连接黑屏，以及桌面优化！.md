---
url: https://zhuanlan.zhihu.com/p/519648451
title: 完美方案——解决 XRDP 连接黑屏，以及桌面优化！
date: 2023-08-25 13:03:54
tag: 
banner: "https://images.unsplash.com/photo-1690369167940-173d3fefc53a?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkyOTM5ODMxfA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
banner_icon: 🔖
---
## 前言

直到今天，我终于完美的彻底的解决了远程桌面连接的所有的我不爽的障碍！

关于如何实现 Windows 于 Linux 之间的相互的远程桌面控制，我会在近期出分享，本文着重描述，XRDP 在 Ubuntu 上面临的两个问题：

1.  连接黑屏
2.  别扭的桌面

关于连接黑屏的方案，其实很简单，我早就解决了，但是桌面优化今天终于在外网发现了解决方案：

[(xRDP) Desktop looks different when connecting remotely](https://askubuntu.com/questions/1233088/xrdp-desktop-looks-different-when-connecting-remotely)

注意，Ubuntu 的版本是 20.04.

## 连接黑屏问题

这个问题，**主要是当你的本机没有注销的话，远程桌面就会黑屏**，最佳解决策略就是退出本地登录，也就是注销登录，这个方法一定没问题。与 windows 那种完美的远程控制不同，在 ubuntu 中，本地登录和远程登陆是隔离开的，远程登录了不注销，那么本地就会黑屏，反过来本地登陆了不注销，远程就会黑屏。所谓注销就是 logout，应该都懂，就是和关机、重启放在一起的那个选项。

或者使用网上的一些解决方案，但是这个放在在 Ubuntu 22 中会导致闪退。即，编辑 `/etc/xrdp/startwm.sh` 文件：

### 1. 打开文件

```
sudo vim /etc/xrdp/startwm.sh

```

### 2. 添加配置

```
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR

```

### 3. 重启 xrdp 服务

```
sudo systemctl restart xrdp.service

```

## 桌面优化

注意，一定要**先修改下面配置文件，再远程连接**，否则会黑屏，这个时候需要重启。

反正记住一句话，重启后不在本地登录，那么远程必不黑屏！

如果不做任何配置，启动之后的桌面是非常别扭的，因为是 Gnome 的原始桌面，没有左侧的任务栏，窗口也没有最小化按钮，等等一些列问题。解决方案也很简单：

### 1. 添加配置文件

```
vim ~/.xsessionrc

添加：

export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg

```

### 2. 重启 xrdp 服务

```
sudo systemctl restart xrdp.service

```

此时再连接，你将得到与原生桌面完全一样的效果！