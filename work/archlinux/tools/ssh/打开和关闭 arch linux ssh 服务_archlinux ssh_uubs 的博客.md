---
url: https://blog.csdn.net/weixin_38204874/article/details/123429270
title: (135 条消息) 【ssh】打开和关闭 arch linux ssh 服务_archlinux ssh_uubs 的博客 - CSDN 博客
date: 2023-04-11 13:29:45
tag: 
banner: "undefined"
banner_icon: 🔖
---
### 【ssh】打开和关闭 Linux ssh 服务

*   [配置 ssh](#ssh_1)
*   *   [安装 openssh](#openssh_2)
    *   [查看 sshd 状态](#sshd_6)
    *   [启动 sshd 服务](#sshd_10)
    *   [ssh 远程连接](#ssh_21)

# 配置 ssh

## 安装 openssh

```
pacman -S openssh

```

## 查看 sshd 状态

```
systemctl status sshd.service

```

## 启动 sshd 服务

如果未开启的话，需要启动 sshd 命令，执行命令

```
systemctl start sshd

```

如果想要将 sshd 命令开机启动的话，同样需要 root 权限执行

```
systemctl enable sshd.service

```

## ssh 远程连接

```
ssh user@ip

```