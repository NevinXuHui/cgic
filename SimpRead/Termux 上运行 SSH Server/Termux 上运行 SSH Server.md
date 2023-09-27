---
url: https://zhuanlan.zhihu.com/p/226393968
title: Termux 上运行 SSH Server
date: 2023-06-26 08:57:41
tag: 
banner: "https://picx.zhimg.com/v2-73450548f435f30ab30ed75538cd5f29_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
[Termux](https://github.com/termux/termux-app) 是一个 Android 下一个高级的终端模拟器, 开源且不需要 root，支持 apt(pkg) 管理软件包，安装软件包十分方便。

有了 Termux，手机（平板）就变成了便携的 Linux 电脑，如果还嫌不过瘾的，推荐安装 AnLinux。

Termux 的理想输入法是 Hack's Keyboard，但更好用的还是电脑的键盘，远程通过 SSH 访问 Termux。

上代码，

```
#安装OpenSSH
$ pkg install openssh

#运行SSH Server
$ sshd

#设置密码
$ passwd 

#获得Android IP
$ ifconfig

#客户端运行
 $ ssh android_ip -p 8022

```

![](<assets/1687741061432.png>)