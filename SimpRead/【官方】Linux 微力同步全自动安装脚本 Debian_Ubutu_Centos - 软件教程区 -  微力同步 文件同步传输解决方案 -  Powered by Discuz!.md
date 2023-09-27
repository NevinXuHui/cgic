---
url: https://forum.verysync.com/forum.php?mod=viewthread&tid=906
title: 【官方】Linux 微力同步全自动安装脚本 Debian_Ubutu_Centos - 软件教程区 -  微力同步 文件同步传输解决方案 -  Powered by Discuz!
date: 2023-08-05 17:44:25
tag: 
banner: "https://images.unsplash.com/photo-1688989680825-0790dc6488fa?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxMjI4NjY3fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
![](https://forum.verysync.com/uc_server/avatar.php?uid=1&size=middle)

admin 一直以来，微力在 Linux 上的安装方法是百花齐放，各有各的做法，给 Linux 新手用户也造成不少安装困惑，  
今天我们团队发布了 Linux 的完全自动化安装脚本，方便喜欢微力的用户快速安装，我们也使用该安装器在我们的服务器环境上做快速部署。  
快速安装  

1.  #(如果需要指定索引存放位置请在最后面添加 - d 路径 如 -d /data/verysync)  
    
2.  curl http://www.verysync.com/shell/verysync-linux-installer/go-installer.sh > go-installer.sh  
    
3.  chmod +x go-installer.sh  
    
4.  ./go-installer.sh

_复制代码_

安装完成后就可以用浏览器打开 http:// 你的 IP 地址: 8886  管理微力内容了  
参数说明  

1.  ./go-installer.sh [-h] [-c] [--remove] [-p proxy] [-f] [--version vx.y.z] [-l file] [-d index location]  
    
2.    -h, --help            显示帮助  
    
3.    -p, --proxy           指定代理服务器 -p socks5://127.0.0.1:1080 or -p http://127.0.0.1:3128 etc  
    
4.    -f, --force           强制安装  
    
5.        --version         安装特定版本 例如 --version v0.15.11-rc2  
    
6.    -l, --local           从本地下载好的文件安装 需要使用绝对路径如 -l /root/verysync-linux-amd64-v0.15.12-rc1.tar.gz  
    
7.        --remove          卸载微力同步  
    
8.    -c, --check           检查更新  
    
9.    -d  --home            指定微力索引存放位置, 默认 ~/.config/verysync

_复制代码_

  
此脚本会自动安装以下文件：  

1.  - /usr/bin/verysync/verysync: 微力主程序  
    
2.  - /usr/bin/verysync/start-stop-daemon: daemon 管理程序 centos 会使用预编译好的 i386 amd64 arm arm64 版本  
    
3.  安装器会配置自动运行脚本。自动运行脚本会在系统重启之后，自动运行 verysync。目前自动运行脚本只支持带有 Systemd, init.d 的系统，以及 Debian / Ubuntu 全系列

_复制代码_

运行脚本位于系统的以下位置：  

1.  - /etc/systemd/system/verysync.service: Systemd  
    
2.  - /etc/init.d/verysync: SysV

_复制代码_

经测试系统:  

1.  CentOS 6.5 init.d  
    
2.  CentOS 7.5 systemd  
    
3.  Debian 7.11 systemv  
    
4.  Debian 9.5 systemd

_复制代码_

**欢迎回帖告知您使用的系统版本是否正常。以方便我们补充测试通过列表。

![](https://forum.verysync.com/static/image/smiley/coolmonkey/07.gif)

**  
  
由于 Centos 默认仓库 没有 daemon 套件，所以本仓库自带了 i386 amd64 arm arm64 版本的 start-stop-daemon 程序，省去了系统编译安装. 如果使用其它架构的系统，需要自行编译 daemon 套件，方法 [https://gist.github.com/yuuichi-fujioka/c4388cc672a3c8188423](https://gist.github.com/yuuichi-fujioka/c4388cc672a3c8188423)  
![](https://forum.verysync.com/uc_server/avatar.php?uid=9739&size=middle)

flyhome 小米路由可以用这种方式安装吗？

![](https://forum.verysync.com/uc_server/avatar.php?uid=1&size=middle)

admin

[flyhome 发表于 2019-1-19 22:06](https://forum.verysync.com/forum.php?mod=redirect&goto=findpost&pid=4499&ptid=906)  
小米路由可以用这种方式安装吗？

不适合路由器的![](https://forum.verysync.com/uc_server/avatar.php?uid=7150&size=middle)

heartnn _本帖最后由 heartnn 于 2019-3-14 16:32 编辑_  
./go-installer.sh: 20: ./go-installer.sh: [[: not found  
./go-installer.sh: 26: ./go-installer.sh: [[: not found  
./go-installer.sh: 17: ./go-installer.sh: Bad substitution  
这个怎么办？  
==================  
发现自己有时候脑残，执行 bash go-installer.sh 就行了。。。  
![](https://forum.verysync.com/uc_server/avatar.php?uid=8056&size=middle)

elven 依据快速安装步骤完成安装后，使用浏览器打开微力管理页面无法打开, 提示链接超时。 系统是 centOS7![](https://forum.verysync.com/uc_server/avatar.php?uid=15420&size=middle)

quchao U-Nas 4.0 安裝成功，效果不錯。

![](https://forum.verysync.com/static/image/smiley/default/lol.gif)

![](https://forum.verysync.com/uc_server/avatar.php?uid=15946&size=middle)

359962991 CentOS release 6.10  
安装完毕之后，浏览器无法打开界面，提示无法访问

![](https://forum.verysync.com/uc_server/avatar.php?uid=1&size=middle)

admin

[359962991 发表于 2019-8-22 10:07](https://forum.verysync.com/forum.php?mod=redirect&goto=findpost&pid=5003&ptid=906)  
CentOS release 6.10  
安装完毕之后，浏览器无法打开界面，提示无法访问

防火墙 要开放 8886 22330![](https://forum.verysync.com/uc_server/avatar.php?uid=15974&size=middle)

xmdvcc _本帖最后由 xmdvcc 于 2019-8-23 12:15 编辑_  
今天在 CentOS 7.6 上刚刚首次安装，一切正常，有问题我再来反馈。  
![](https://forum.verysync.com/uc_server/avatar.php?uid=7220&size=middle)

valu CentOS7 安装成功，防火墙要开放 8886 和 22330，还是打不开。