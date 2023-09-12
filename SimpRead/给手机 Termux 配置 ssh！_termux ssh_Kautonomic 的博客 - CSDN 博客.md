---
url: https://blog.csdn.net/KeeYNgveKOn/article/details/127939823
title: 给手机 Termux 配置 ssh！_termux ssh_Kautonomic 的博客 - CSDN 博客
date: 2023-06-26 12:53:39
tag: 
banner: "https://img-blog.csdnimg.cn/3f5e0d83ef3e4df384f154418c70361c.jpeg"
banner_icon: 🔖
---
就是想在手机远程操控机载电脑啦  
就是想跟《watch dogs》一样手机码代码啦  
超酷的！  
安装 Termux，打开后的界面就是这样啦  

![](<assets/1687755219057.png>)

  
这个时候他很干净啦  
需要下载 tsu 才能使用 sudo 指令（而且前提是手机 root 了）

```
pkg install tsu

```

因为可能 install 比较慢可能得需要修改源，所以先下载 vim（也可以选别的）

```
pkg install vim

```

修改默认编辑器

```
export EDITOR=vim

```

然后

```
apt edit-sources

```

将源替换成 deb https://mirrors.tuna.tsinghua.edu.cn/termux stable main 保存并退出，但是这里会出问题  
清华源可能没有官方源全 所以之后不论 update 还是 upgrade 又或者是 install 都会有可能报错  
例如：  
E: Failed to fetch https://mirrors.tuna.tsinghua.edu.cn/termux/pool/main/o/openssh/openssh_9.1p1_aarch64.deb 404  
E: Aborting install.  
或者是  
upgrade or --fix-missing  
又或者是  
Unable to locate package  
所以非必要的话还是用官方源 deb https://grimler.se/termux-packages-24/ stable main 稳妥虽然可能要魔法  
完成后 这里以我的 pi 为例啦 首先检查他自己有没有安装 [ssh](https://so.csdn.net/so/search?q=ssh&spm=1001.2101.3001.7020)

```
dpkg -l | grep ssh

```

出现  

![](<assets/1687755219120.png>)

  
证明安装好啦  
然后在 termux 上

```
dkg install openssh

```

安装好后输入 passwd 输入两遍密码  
需要作为服务端的话就输入 sshd 和 nmap（ip 地址）来开启服务安装 nmap 就是 pkg install nmap  
开启了的可能就会显示  
sshd re-exec requires execution with an absolute path  
开启途中可能得需要输入 yes  
要作为客户端就用语句

```
ssh pi@192.168.6.223 //这里以pi为例 pi是服务端名 然后@ip地址

```

ok 成功！！！  

![](<assets/1687755219142.png>)

  
需要关闭的时候 ctrl+D  
that‘s all！