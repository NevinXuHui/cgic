---
url: https://blog.csdn.net/God_Father_kao/article/details/124943858
title: WSL2 固定 Host 连接_wsl2 host_混世小萌羊的博客 - CSDN 博客
date: 2023-07-31 21:26:42
tag: 
banner: "https://images.unsplash.com/photo-1688854682321-62ad582df1fa?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkwODA5OTY1fA&ixlib=rb-4.0.3&q=85&fit=crop&w=682&max-h=540"
banner_icon: 🔖
---
## 说明

WSL2 启动时会自动变换 IP，IP 地址不可固定。使用 Localhost 有时候可以连接上去，有时候连接不上去。  
现在设置一个固定的 host 来配置 WSL2

### 1. 配置 Linux 获取 IP 启动脚本

```
cd /etc
touch initWsl.bash
chmod 775 initWsl.bash
vim initWsl.bash

```

initWsl.bash

```
#! /bin/sh

# 启动对应服务
service ssh ${1}
service docker ${1}

# 设置本地Wsl2域名，默认为wsl2host
ipaddr=$(ip -4 addr show dev eth0 | egrep 'inet ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})' | awk '{print $2}' | awk -F/ '{print $1}')
hostName='wsl2host'
sed -i '/wsl2host/d' /mnt/c/Windows/System32/drivers/etc/hosts
echo "${ipaddr} ${hostName}" >> /mnt/c/Windows/System32/drivers/etc/hosts

sed -i '/wsl2host/d' /etc/hosts
echo "${ipaddr} ${hostName}" >> /etc/hosts

```

```
./initWsl.bash start

```

### 2. 配置 Windows 启动运行脚本

1.  进入 C:\Users\hanli\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
2.  创建 Ubuntu.vbs

```
Set ws = CreateObject("Wscript.Shell")
ws.run "wsl -d Ubuntu -u root /etc/initWsl.bash start", vbhide

```

3.  执行 Ubuntu.vbs