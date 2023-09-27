---
url: https://blog.csdn.net/weixin_43572042/article/details/109307072
title: (135 条消息) umount 卸载磁盘提示 target is busy_ （目标忙） 的问题解决方案_Crazy_Hengji 的博客 - CSDN 博客
date: 2023-04-12 12:49:24
tag: 
banner: "undefined"
banner_icon: 🔖
---
### umount 卸载磁盘提示 target is busy. （目标忙） 的问题解决方案

*   *   [方法一（不推荐）：](#_16)
    *   [方法二（退出目录，这个最合适）：](#_22)
    *   *   [umount 挂载点 // 卸载方式 1 或 umount 设备路径 // 卸载方式 2](#umount___1__umount___2_28)

**使用 umount 卸载磁盘时报错，提示 target is busy：如下**

```
[root@Hengji ~]# cd /sdb1/
[root@Hengji sdb1]# umount /sdb1 
umount: /sdb1: target is busy.

```

有些情况下通过 lsof(8) 或 fuser(1) 可以找到有关使用该设备的进程的有用信息

```
[root@Hengji sdb1]# lsof /sdb1
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
bash    2371 root  cwd    DIR   8,17       20  128 /sdb1
lsof    2978 root  cwd    DIR   8,17       20  128 /sdb1
lsof    2979 root  cwd    DIR   8,17       20  128 /sdb1

```

## 方法一（不推荐）：

```
[root@Hengji sdb1]# kill -9 2371

```

## 方法二（退出目录，这个最合适）：

```
[root@Hengji sdb1]# cd 
[root@Hengji ~]# umount /dev/sdb1

```

### umount 挂载点 // 卸载方式 1 或 umount 设备路径 // 卸载方式 2