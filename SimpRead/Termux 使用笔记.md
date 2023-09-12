---
url: https://www.ngui.cc/zz/1985472.html?action=onClick
title: Termux 使用笔记
date: 2023-06-26 12:53:05
tag: 
banner: "https://img-blog.csdnimg.cn/678069e4c70e44f6b41f16cceaa60e99.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ2MDc5NDM5,size_16,color_FFFFFF,t_70"
banner_icon: 🔖
---
Termux 功能的强大之处在这里就不再说。

**

## 1、使用 MobaXterm 通过 SSH 直连 Android 的 Termux

**（1）使手机与电脑处于同一局域网下  
（2）获取手机的 ip 与用户名**

```
$ whoami
u0_a256$ ifconfig
lo: ...
wlan0: ...inet 192.168.1.101  netmask 255.255.255.0  broadcast 192.168.1.255...

```

**（3）设置密码**

```
$ passwd
New password:
Retype new password:
New password was successfully set.

```

**（4）安装 ssh**

```
$ pkg install openssh


```

**（5）打开 ssh**

```
$ sshd


```

**（6）打开 MobaXterm，设置主机（192.168.xx.xx）和端口号为 8022**  

![](<assets/1687755185044.png>)

  
（7）输入用户名和密码  

![](<assets/1687755185129.png>)

  
（8）完成登录！  

![](<assets/1687755185176.png>)

  
（9）开启内存访问

```
$ termux-setup-storage


```

（10）根据手机系统设置允许 Termux 在后台运行

## 2、Termux 更新下载源

（1）安装 vim 编辑器

```
$ apt install vim


```

（2）默认编辑器修改为 vim

```
$ export EDITOR=vim


```

（3）编辑下载源地址，把源网址替换为：http://mirrors.tuna.tsinghua.edu.cn/termux

```
$ apt edit-sources


```

![](<assets/1687755185252.png>)

  
然后保存。

## 3、安装 python

```
$ apt install python -yReading package lists... Done
Building dependency tree
Reading state information... Done
......
Successfully installed pip-21.1.3 setuptools-56.0.0
Setting up libxml2 (2.9.12) ...
Setting up pkg-config (0.29.2) ...
Setting up libllvm (12.0.1) ...
Setting up clang (12.0.1) ...


```

## 4、安装其他 Linux 系统

按顺序输入就好了

```
$ pkg install proot git python -y
$ git clone https://github.com/sqlsec/termux-install-linux
$ cd termux-install-linux
$ python termux-linux-install.py


```

```
  _____|_   _|__ _ __ _ __ ___  _   ___  __| |/ _ \ '__| '_ ` _ \| | | \ \/ /| |  __/ |  | | | | | | |_| |>  <|_|\___|_|  |_| |_| |_|\__,_/_/\_\Termux 高级终端安装使用配置教程
https://www.sqlsec.com/2018/05/termux.html1. 安装 Ubuntu       2. 卸载 Ubuntu3. 安装 Kali         4. 卸载 Kali5. 安装 Debian       6. 卸载 Debian7. 安装 CentOS       8. 卸载 CentOS9. 安装 Fedora      10. 卸载 Fedora
11. 查询已安装系统     12. 退出脚本请选择要执行的操作:


```

然后进入对应的目录运行（以 Ubuntu 为例）

```
$ cd ~/Termux-Linux/Ubuntu
$ ./start-ubuntu.sh


```

## 5、linux 之间的文件传输 scp 命令

.  
从本地到远程：

```
$ scp -P 8022 文件名 用户名@IP地址:/data/data/com.termux/files/home/storage示例：
$ scp -P 8022 project.rar u0_a256@192.168.1.101:/data/data/com.termux/files/home/storage


```

.  
从远程到本地.：

```
$ scp -P 8022  u0_a256@192.168.1.101:/data/data/com.termux/files/home/storage/project.rar ./


```

## 6、安装 wget 命令

```
$ pkg install wget -y


```

## 7、安装 rar 解压命令

（1）下载安装包

```
$ wget https://www.rarlab.com/rar/rarlinux-x64-6.0.1.tar.gz  (64位操作系统)
$ wget http://www.rarlab.com/rar/rarlinux-3.8.0.tar.gz  (32位操作系统)


```

（2）解压安装（好像 make 不了，后期再更新）

```
$ tar zxvf rarlinux-3.8.0.tar.gz
$ cd rar
$ make
$ make install 


```

（3）压缩解压

```
压缩为.rar 命令为：
$ rar a etc.rar /etc将etc.rar 解压 命令为：
$ rar x etc.rar 
$ unrar -e etc.tar


```

## 8、安装编译运行 C 语言程序

（1）安装 C 语言编译环境

```
$ pkg install clang


```

（2）写代码

```
$ vim test.c


```

测试代码：

```
#include <stdio.h>int main() {printf("Hello World!\n");return 0;
}


```

（3）gcc 编译

```
$ gcc -o test test.c


```

（4）运行程序

```
$ ./test


```

## 9、termux 设置开机自启动

```
$ echo “xxxx“  >> ~/.bashrc或者编辑 bashrc
$ vim ~/.bashrc


```

比如开机自启 sshd

```
$  echo "sshd" >> ~/.bashrc


```

本文来自互联网用户投稿，该文观点仅代表作者本人，不代表本站立场。本站仅提供信息存储空间服务，不拥有所有权，不承担相关法律责任。如若转载，请注明出处：[http://www.ngui.cc/zz/1985472.html](http://www.ngui.cc/zz/1985472.html) 如若内容造成侵权 / 违法违规 / 事实不符，请联系编程学习网邮箱：809451989@qq.com 进行投诉反馈，一经查实，立即删除！