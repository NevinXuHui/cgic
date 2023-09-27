---
url: https://blog.csdn.net/qq_36910634/article/details/122790888
title: Termux 的安装、换源、基本库安装_termux 换源_安藤青司的博客 - CSDN 博客
date: 2023-06-26 12:54:02
tag: 
banner: "https://img-blog.csdnimg.cn/img_convert/3980a74cdabfa14a284428456a353e0d.png"
banner_icon: 🔖
---
# 安卓 5.0 以上 7.0 以下使用 Termux

最近想弄点小服务玩玩，试试装个 homeassistant。树莓派之类的稍微有点贵，就把目光投向了家里闲置的老旧[安卓手机](https://www.smzdm.com/fenlei/androidshouji/ "安卓手机")。本身以为安装 termux 之后就可以使用，结果遇到了一些小坑，百度后并没有搜到填坑方法。自己解决后，在这里做个记录。

## 1. 安装准备

Termux 支持 5.0 以上的安卓系统。

Termux7.3 版本之后，仅支持 7.0 以上的安卓系统。

根据手机系统准备安装包。7.3 以后的版本网上可以搜到安装方法，这里按下不表。7.3 的安装包可以在百度上搜索，或者在[酷](https://pinpai.smzdm.com/136359/ "酷")安上找到。截止今日，酷安上的 termux 版本为 7.3。

## 2. 安装与设置

安装完 termux 之后，进入 app，等待 installing 结束之后即可看到命令行界面。

![](<assets/1687755242137.png>)

此时 pkg update、安装组件都会报错（403）

![](<assets/1687755242166.png>)

### 报错（请勿执行此操作）

搜索后更改为清华的镜像，再次运行 pkg update，pkg upgrade 之后，命令行报错，无法运行。此时发现清华的镜像后面有警告。

![](<assets/1687755242195.png>)

### 解决

```
sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://termux.com/game-packages-21-bin games stable@' $PREFIX/etc/apt/sources.list.d/game.list
 
sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://termux.com/science-packages-21-bin science stable@' $PREFIX/etc/apt/sources.list.d/science.list
```

**手动修改：**

编辑 $PREFIX/etc/apt/sources.list.d/science.list 修改为如下内容

原

deb https://dl.bintray.com/grimler/science-packages-21 science stable

后

deb https://termux.com/science-packages-21-bin science stable

编辑 $PREFIX/etc/apt/sources.list.d/game.list 修改为如下内容

原

deb https://dl.bintray.com/grimler/game-packages-21 games stable

后

deb https://termux.com/game-packages-21-bin games stable

$PREFIX/etc/apt/sources.list 内容保持不变

deb [https://termux.net](https://termux.net/ "https://termux.net") stable main

此时执行 apt update && apt upgrade 发现可以正常执行。

### 打开 ssh

在手机上操作实在是难受，安装 ssh 后远程连上进行操作。

执行安装

pkg install openssh

设置密码

passwd

运行 ssh

sshd

此时可以用 ssh 工具连接上，端口为 8022。登录用户名我是 Linux，如果不确定使用 uname 命令查看。

![](<assets/1687755242246.png>)

## 补充

安装 termux-services，设置 SSH 自启动

pkg install termux-services

sv-enable sshd  
 

# 启动

sv up sshd

# 停止

sv down sshd

# 开机启动

sv-enable sshd

# 禁止开机启动

sv-disable sshd

利用 proot 模拟 root

pkg install proot

termux-chroot // 进入 root

exit // 退出

如果出现某些命令突然无法使用的错误（如遇到过无法使用 ls），可以在安卓后台关闭 termux，重新开启。 

## 在 Termux 安装 Ubuntu 并启动

在 AnLinux 转到 Termux 的时候会初始化，下左图。此时必须联网，因为要下载相应的文件。在安装 Ubuntu 之前需要执行两个操作：

申请读写权限，

```
termux-setup-storage

```

更新一下，

```
apt update

```

更新之后即可执行 AnLinux 复制过来的指令，如下

```
pkg install wget openssl-tool proot -y && hash -r && wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Ubuntu/ubuntu.sh && bash ubuntu.sh

```

在 Termux 执行的结果如下，这个过程可能执行时间教程，如果有科学上网最好开启。完成之后会输入【ls】指令可以看到如下，下右图。

![](<assets/1687755242298.png>)

。

打开 Ubuntu

```
./start-ubuntu.sh

```

在下面看到 root@localhost 就知道进入 Ubuntu 了，这样就可以愉快的玩耍啦~

# 部署 Spring Boot 应用

下载 jdk：jdk-8u111-linux-arm64-vfp-hflt.tar.gz

**注意：这里下载 jdk 的时候要根据手机的 CPU 型号进行选择，我这里选择了和骁龙处理器匹配的 arm64 架构版本，不知道选择 CPU 对应指令可自行百度，实在查不到可以选择和我一样的 arm64**

这里提供一个 jdk 下载的[地址](http://www.codebaoku.com/jdk/jdk-oracle-jdk1-8.html "地址")，基本所有的版本都能在上面找到，官网的下载速度实在太慢，还需要 oracle 账户登录，非常心累

![](<assets/1687755242333.png>)

上传至目录：/data/data/com.termux/files/home/ubuntu-fs/root/

解压：

```
tar -xzvf jdk-8u111-linux-arm64-vfp-hflt.tar.gz

```

### spring boot 应用打包

![](<assets/1687755242358.png>)

### 运行

```
java -jar demo-0.0.1-SNAPSHOT.jar

```

# 安装 MySQL

首先，输入下列命令确保你的仓库已经被更新：

```
sudo apt update

```

现在，安装 MySQL 5.7，简单输入下列命令：

```
sudo apt install mysql-server -y

```

笔者在这遇到了问题，无法通过局域网 ip 远程连上 mysql，查阅相关资料后得以解决

### 1、网络检测

1)ping 主机可以；  
2)telnet 主机 3306 端口不可以；  
     telnet 主机 22 端口可以；  
   说明与本机网络没有关系；

### 端口检测

1)netstat -ntpl |grep 3306  
    tcp        0      0 :::3306                     :::*                        LISTEN      -   
2)netstat -ntpl |grep 22  
    tcp        0      0 0.0.0.0:22                  0.0.0.0:*                   LISTEN      -     
   可以看出 22 端口监听所有地址，而 3306 只监听本机地址（绑定了到了本地），所以远程无法访问。修改 my.cnf 中 bind-address=0.0.0.0  
   对于端口只允许本机访问，有两个地方启用，一个是防火墙启用 3306，一个就是 mysql 配置绑定本机地址。

# 修改访问权限

修改文件 etc/mysql/mysql.conf.d/mysqld.cnf，将如下图所示：

 将 bind-address=0.0.0.0 注释或者删除

![](<assets/1687755242387.png>)

重启 mysql：service mysql restart，连接成功