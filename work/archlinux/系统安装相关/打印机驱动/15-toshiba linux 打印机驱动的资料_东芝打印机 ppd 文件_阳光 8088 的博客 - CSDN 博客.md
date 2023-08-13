---
url: https://blog.csdn.net/lenovo8088/article/details/111256736
title: toshiba linux 打印机驱动的资料_东芝打印机 ppd 文件_阳光 8088 的博客 - CSDN 博客
date: 2023-05-04 09:57:06
tag: 
banner: "undefined"
banner_icon: 🔖
---
驱动地址：www.toshibatec.eu

使用说明书：www.manualslib.com

开源开印机：[www.openprinting.org/printers](https://www.openprinting.org/printers)

cups 的用法：略

看了一下文件组成，有 shell ,pothon，perl , 还有已经编译的文件，没有完全开源。

文件说明：

解压缩两个文件 PPD，和 打印机管理命令，使用下面命令可以自行解压缩到文件目录下。 

TOSHIBA_ColorMFP_CUPS.tar

sudo tar -xvPf [linux](https://so.csdn.net/so/search?q=linux&spm=1001.2101.3001.7020).tar

文件分析

1、net_estbw（shell)

Printer interface program to send print files to an estbw printer

2、ppd 文件，PPD 文件格式说明有 501 503 两个版本，想看网上可下载。

PCFileName: "TSES8O_1.PPD"

=========================

下面感觉全是网络打印的东西。

3、estbwadd 

#    add an estbw printer description  
#  
#    Usage: estbwadd <queue name> <printer name or IP address>

4、estbwrm 

# estbwrm  
#    remove an estbw printer description  
#  
#    Usage: estbwrm <queue name>  
5、filter

awk '{print $0,"\r"}'

6、lpdsend lpdsend.el7.x86_64 未开源，

7、lpLinux.sh

8、modPrintcap printconf_import

删除打印队列用的。