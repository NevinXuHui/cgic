---
url: https://blog.csdn.net/lxy___/article/details/105144982
title: killall： command not found（最详细版）_橙子❦的博客 - CSDN 博客
date: 2023-09-08 11:16:53
tag: 
banner: "https://images.unsplash.com/photo-1692994078114-ef5bf4ee4ff6?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjk0MTQyOTUzfA&ixlib=rb-4.0.3&q=85&fit=crop&w=979&max-h=540"
banner_icon: 🔖
---
## killall: command not found

执行 killall 命令时提示：-bash: killall: command not found 没  
解决 centos、ubuntu 系统下：

**1.ubuntu**

```
apt-get install  psmisc

```

**2.centos 或 redhat**

```
yum -y  install psmisc

```