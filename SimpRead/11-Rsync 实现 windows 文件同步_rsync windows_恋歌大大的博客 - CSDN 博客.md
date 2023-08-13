---
url: https://blog.csdn.net/weixin_44530086/article/details/131190279
title: Rsync 实现 windows 文件同步_rsync windows_恋歌大大的博客 - CSDN 博客
date: 2023-08-02 22:43:26
tag: 
banner: "https://images.unsplash.com/photo-1689331885872-4203d611ebf3?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkwOTg3NDA3fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
## 将两台 windos 主机之前的某个目录进行同步，下面称为服务端和客户端

### 服务端：本机 ip:192.168.182.1

### 客户端：虚拟机 ip:192.168.182.130

### 安装 [rsync](https://so.csdn.net/so/search?q=rsync&spm=1001.2101.3001.7020)

下载地址：[https://gitee.com/buchengfeng/cwRsync?_from=gitee_search](https://gitee.com/buchengfeng/cwRsync?_from=gitee_search)

```
 git clone https://gitee.com/buchengfeng/cwRsync.git

```

### 下载内容如下

*   cwRsyncServer_4.0.5_Installer.zip 为服务端软件
*   cwRsync_4.0.5_Installer.zip 为客户端软件

### 服务端安装

一路 next，然后到安装目录中配置 conf 文件

#### 需要关注下面几点

*   port 服务端的端口
*   [test] 这个可以理解为一个模块名
*   path=/cygdrive/F/XXX/doc 这个里面的 / cygdrive 可以理解为 linux 中的 / 目录 后面的 F/XXX/doc 就是 F:/XXX/doc 这样的一个路径转换
*   read only 是否只读
*   模块中的 path 就是我们需要同步的目录

```
use chroot = false
strict modes = false
hosts allow = *
log file = rsyncd.log
port = 8173
uid = 0
gid = 0
Module definitions
Remember cygwin naming conventions : c:\work becomes /cygwin/c/work
[test]
path = /cygdrive/F/XXX/doc
read only = false
transfer logging = yes

```

#### 设置服务为自动启动 此电脑 - 右键 - 管理 - 服务

![](https://img-blog.csdnimg.cn/3edebe3db5ac4aa48f7584d968732051.png#pic_center)

#### 设置端口开放 控制面板 - Windows Defender 防火墙 - 高级设置 - 入站规则

![](https://img-blog.csdnimg.cn/d2684e716ee6497c87a30886a88bb4c8.png#pic_center)

#### 服务端安装完毕

### 客户端安装

*   直接一路安装完毕
*   进入 rsync 目录
*   地址栏输入 cmd

```
执行命令
rsync --port=8173 -vzrtopg --progress --delete 192.168.182.1::test /cygdrive/c/xxx/data

```

上面命令主要关注下面几个内容  
port = 服务端端口  
IP:: 模块名  
/cygdrive/c/xxx/data 等同于 c:/xxx/data

#### 同步效果

![](https://img-blog.csdnimg.cn/1995d1518ee34831ae26f44f92cc73e3.png#pic_center)