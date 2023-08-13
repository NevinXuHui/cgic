---
url: https://blog.csdn.net/lxyoucan/article/details/124952106
title: (135 条消息) archlinux telnet 客户端_ITKEY_的博客 - CSDN 博客
date: 2023-04-11 13:29:27
tag: 
banner: "undefined"
banner_icon: 🔖
---
简单介绍  
telnet 是一种基于 TCP 的传统[命令行](https://so.csdn.net/so/search?q=%E5%91%BD%E4%BB%A4%E8%A1%8C&spm=1001.2101.3001.7020)远程控制协议。telnet 使用非加密的通道，因此不太安全。现在主要用于链接一些旧设备。

下面这些介绍主要适用于在 Arch Linux 系统中配置一个 telnet 服务器。

# 安装

如果只使用 telnet 联接到别的机器，只需要安装 netkit-telnet 即可：

```
pacman -S inetutils

```

# 连接

命令格式：telnet `IP地址` `端口号`

示例：

```
telnet 127.0.0.1 8823

```