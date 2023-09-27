---
url: https://zhuanlan.zhihu.com/p/89776195
title: Syncthing 中继服务器和发现服务器
date: 2023-08-04 15:32:57
tag: 
banner: "https://images.unsplash.com/photo-1689331885872-4203d611ebf3?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxMTM0Mzc0fA&ixlib=rb-4.0.3&q=85&fit=crop&w=1802&max-h=540"
banner_icon: 🔖
---
这篇文章是附属于我专栏的另一篇文章。

[寒三石：Syncthing - P2P 文件同步工具](https://zhuanlan.zhihu.com/p/69267020)

## 1. 中继服务器

**1.1 服务端部署**

此处以 Linux 为例（准确点说是 CentOS7），不过中继服务器也支持 Windows、macOS 和 BSD 系统。

```
# 下载中继服务器，根据不同的版本
wget https://github.com/syncthing/relaysrv/releases/download/v1.3.0/strelaysrv-linux-amd64-v1.3.0.tar.gz
# 解压压缩包
tar -zxvf strelaysrv-linux-amd64-v1.3.0.tar.gz
# 进入目录
cd strelaysrv-linux-amd64-v1.3.0
# 后台运行中继服务器并公开该中继服务器（就是其他人也可以用这个中继服务器），nohup表示后台运行
# 不想公开请使用下一行命令
nohup ./strelaysrv
# 如果不想公开该中继服务器，只给自己使用，请使用该行命令
nohup ./strelaysrv -pools="" 

```

注意你需要设置防火墙，打开 22067 端口。

如果需要全局限速，请运行时加入参数`-global-rate=<bytes/s>`

1.2 客户端配置

在服务端目录下（如果你是按教程来，那就 strelaysrv 所在目录）有一个 nohup.out，里面有如下内容

```
relay://0.0.0.0:22067/?id=6FFLRSA-UISS3GY-W5IZK36-7LANY3S-2MSQRC5-ZVWkkDE-DXNP2D4-6KX5WQX&pingInterval=1m0s&networkTimeout=2m0s&sessionLimitBps=0&globalLimitBps=0&statusAddr=:22070&providedBy=

```

我们复制 relay://0.0.0.0:22067/?id=6FFLRSA-UISS3GY-W5IZK36-7LANY3S-2MSQRC5-ZVWkkDE-DXNP2D4-6KX5WQX，将 0.0.0.0 替换服务器的 ip 地址或域名。

在客户端的**设置** -> **协议监听地址，**粘贴即可。

![](https://pic4.zhimg.com/v2-2b2bfbb94a755b78649f340076edca33_r.jpg)

## 2. 发现服务器

// 待续