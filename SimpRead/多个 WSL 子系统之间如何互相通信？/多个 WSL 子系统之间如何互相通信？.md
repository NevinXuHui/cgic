---
url: https://www.zhihu.com/question/611823467
title: 多个 WSL 子系统之间如何互相通信？
date: 2023-08-04 09:55:16
tag: 
banner: "https://images.unsplash.com/photo-1689089764982-3c081cc0089a?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxMTE0MTEwfA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
banner_icon: 🔖
---
![](<assets/1691114116285.png>)

Paco

相当于 localhost 的不同端口之间通信

![](<assets/1691114116355.png>)

Erik

WSL 子系统可以通过以下几种方式进行互相通信：

1. 使用 IP 地址进行通信：每个 WSL 子系统都有自己的 IP 地址，可以通过该 IP 地址进行通信。你可以在每个 WSL 子系统中使用 ```ifconfig``` 命令来获取 IP 地址，并使用该 IP 地址来访问其他 WSL 子系统。

2. 使用本地回环地址进行通信：可以使用 ```127.0.0.1``` 作为 IP 地址来访问同一台机器上的其他 WSL 子系统。

3. 使用 localhost 进行通信：可以使用 ```localhost``` 作为主机名来访问同一台机器上的其他 WSL 子系统。

4. 使用网络套接字进行通信：WSL 子系统支持套接字通信，可以通过套接字进行 WSL 子系统之间的进程间通信。

不管使用哪种方式，都需要确保 WSL 子系统之间的网络连接是正常的，且防火墙配置允许 WSL 子系统之间的通信。

![](<assets/1691114116421.png>)

巭孬

ip 相同，端口不同，netstat -p 查一下就知道了

![](<assets/1691114116476.png>)

MuelNova​

针对不同 IP 的问题：

WSL2 的话，可以用 Hyper-V Virtual Switch 创一个外部虚拟交换机然后设置桥接网络。

原来写过一下，但是只是讲了很表层的东西。

[利用 Hyper-V 创建 WSL2 桥接网络并支持 ipv6 | ネコのメモ帳](https://n.ova.moe/blog/%E5%88%A9%E7%94%A8-Hyper-V-%E5%88%9B%E5%BB%BA-WSL2-%E6%A1%A5%E6%8E%A5%E7%BD%91%E7%BB%9C)

简略而言就是在 `%USERPROFILE%/.wslconfig` 里设置

```
[wsl2]
... your config
networkingMode=bridged
vmSwitch=Your_Virtual_Switcher_Name

```

重启 WSL，正常情况下每个实例都会分别走 DHCP 拿到不同 IP。

* * *

为什么说是正常情况下呢？这个配置项并没有写在官方文档中，只在一个 Issue 中提到，所以这个功能并不能被证明为稳定。

在我的测试（一个 AX201 一个 AX210，分别对应我的 surface 和 台式机）下，连接不同的网络（主要是 BUPT 和 NUS 的校园网）都出现了错误，具体而言感觉像是拿不到 DHCP Server 以及 DNS Server。在手动设置 DHCP 服务器以及 DNS 服务器 / 手动设置 IP 后，能 Ping 通网关但是仍然没有办法上网。

所以在网络模式没有被正式支持前，还是推荐使用不同端口的解决方案。