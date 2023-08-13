---
url: https://www.cnblogs.com/seifguo/p/7828257.html
title: archlinux 安装 tftp
date: 2023-05-09 21:55:23
tag: 
banner: "undefined"
banner_icon: 🔖
---
1. 安装

[guo@archlinux ~]$ sudo pacman -S tftp-hpa

2. 启用

[guo@archlinux ~]$ systemctl start tftpd.service

3. 查看 tftp 服务器目录权限

[guo@archlinux srv]$ ls -l

total 12

dr-xr-xr-x 2 root ftp  4096 Mar 27  2017 ftp

drwxr-xr-x 2 root root 4096 Mar 27  2017 http

drwxr-xr-x 2 root root 4096 Nov  7  2016 tftp

可以看到 tftp 权限是 755.

4. 测试

在 / srv/tftp 中新建一文件 1.txt. 并随便写点内容。

进入另外的文件夹下 (怕混淆)：

[guo@archlinux Downloads]$ ls

[guo@archlinux Downloads]$ sudo tftp 127.0.0.1

tftp> get 1.txt

tftp> q

[guo@archlinux Downloads]$ ls

1.txt

[guo@archlinux Downloads]$

可以看到在 Downloads 下多了一个 1.txt 文件。