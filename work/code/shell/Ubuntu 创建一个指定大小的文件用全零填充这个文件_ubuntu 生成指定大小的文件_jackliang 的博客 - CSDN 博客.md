---
banner: "undefined"
---
---
url: https://blog.csdn.net/xiqingchun/article/details/42466247
title: (134 条消息) Ubuntu 创建一个指定大小的文件用全零填充这个文件_ubuntu 生成指定大小的文件_jackliang 的博客 - CSDN 博客
date: 2023-04-06 17:03:17
tag: 
banner: "undefined"
banner_icon: 🔖
---
## [Ubuntu](https://so.csdn.net/so/search?q=Ubuntu&spm=1001.2101.3001.7020) 创建一个指定大小的文件用全零填充这个文件

Ubuntu 创建一个指定大小的文件用全零填充这个文件，例如创建一个 12K 的全零文件 tempzero0606 命令：

~$    sudo    dd   if=/dev/zero    of=/home/tempzero0606   bs=1K    count=12

注：此命令需要在 root 权限下才能够执行

释义：

dd ：是 Linux/UNIX 下的一个非常有用的命令，作用是用指定大小的块拷贝一个文件，并在拷贝的同时进行指定的转换。

if = 文件名：输入文件名，缺省为标准输入，即指定源文件。<if=input file>

/dev/zero：是一个输入设备，你可你用它来初始化文件。该设备无穷尽地提供 0，可以使用任何你需要的数目——设备提供的要多的多。他可以用于向设备或文件写入字符串 0。

 of = 文件名：输出文件名，缺省为标准输出，即指定目的文件。<of=output file>

/home ：生成的文件所在的目录

tempzero0606   ：生成的文件名

bs：缓存大小，用来做创建文件的大小单位，可以是 1k，1M，1G，不要超过系统的缓存大小。

count：要创建的文件大小几个单位 bs

从中我们可以看出要创建的文件个数为一个，文件大小为：bs*count