---
url: https://blog.csdn.net/blueicex2017/article/details/104207946
title: Linux——systemctl 添加自定义服务_blueicex2020 的博客 - CSDN 博客
date: 2023-08-04 09:41:56
tag: 
banner: "https://images.unsplash.com/photo-1688399014730-86300f19fbb3?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxMTEzMjg0fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
systemctl 是 RHEL 7 的服务管理工具中主要的工具，它融合之前 service 和 chkconfig 的功能于一体。可以使用它永久性或只在当前会话中启用 / 禁用服务。

### 一、server 文件位置

systemd 有系统和用户区分；系统（/user/lib/systemd/system/）、用户（/etc/lib/systemd/user/），一般系统管理员手工创建的单元文件建议存放在 / etc/systemd/system / 目录下面。

### 二、服务文件示例

```
[root@master ~]# man systemd.service
man systemd.unit 

```

##### 1. 示例 1

nginx.service

```
vim /user/lib/systemd/system/npc.service
```

[Unit]

```
Description=npc
Documentation=
After=network.target
[Service]
Type=forking
PIDFile=
ExecStartPre=
ExecStart=/mine/code/npc/npc -server=121.5.141.199:8024 -vkey=cdfx47kitpjn1zz1 -type=tcp
ExecReload=
ExecStop=
PrivateTmp=true
[Install]
WantedBy=multi-user.target
```

##### 2. 示例 2

httpd.service

```
[root@master ~]# vim /usr/lib/systemd/system/httpd.service
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:/usr/local/httpd24/sbin/httpd(8)
Documentation=man:/usr/local/httpd24/sbin/apachectl(8)
[Service]
Type=forking
EnvironmentFile=/usr/local/httpd24/etc/sysconfig/httpd
ExecStart=/usr/local/httpd24/sbin/httpd $OPTIONS -k start
ExecReload=/usr/local/httpd24/sbin/httpd $OPTIONS -k graceful
ExecStop=/usr/local/httpd24/sbin/httpd $OPTIONS -k stop
KillSignal=SIGCONT
PrivateTmp=true
[Install]
WantedBy=multi-user.target

```

##### 3. 示例 3

在 centos7 上使用最简单的方法把 php 脚本做成服务，随开机启动运行

###### 3.1 服务文件

```
[root@master ~]# vim customservice.service
# copy to /usr/lib/systemd/system
# systemctl enable customservice.service
[Unit]
Description=customservice Service

[Service]
Type=forking
User=root
ExecStart=/etc/init.d/customservice.sh

[Install]
WantedBy=multi-user.target

```

###### 3.2 脚本文件

```
[root@master ~]#vim customservice.sh
#!/bin/bash
nohup /usr/bin/php /myproject/customservice.php >> /myproject/logs/customservice.log 2>&1 &

```

###### 3.3 拷贝文件

```
[root@master ~]# cp customservice.sh /etc/init.d

```

### 三、服务文件描述

##### 1.[Unit]

Description : 服务的简单描述  
Documentation ： 服务文档  
Before、After: 定义启动顺序。Before=xxx.service, 代表本服务在 xxx.service 启动之前启动。After=xxx.service, 代表本服务在 xxx.service 之后启动。  
Requires：这个单元启动了，它需要的单元也会被启动；它需要的单元被停止了，这个单元也停止了。  
Wants：推荐使用。这个单元启动了，它需要的单元也会被启动；它需要的单元被停止了，对本单元没有影响。

##### 2.[Service]

Type=simple（默认值）：systemd 认为该服务将立即启动。服务进程不会 fork。如果该服务要启动其他服务，不要使用此类型启动，除非该服务是 socket 激活型。  
Type=forking：systemd 认为当该服务进程 fork，且父进程退出后服务启动成功。对于常规的守护进程（daemon），除非你确定此启动方式无法满足需求，使用此类型启动即可。使用此启动类型应同时指定 PIDFile=，以便 systemd 能够跟踪服务的主进程。  
Type=oneshot：这一选项适用于只执行一项任务、随后立即退出的服务。可能需要同时设置 RemainAfterExit=yes 使得 systemd 在服务进程退出之后仍然认为服务处于激活状态。  
Type=notify：与 Type=simple 相同，但约定服务会在就绪后向 systemd 发送一个信号。这一通知的实现由 libsystemd-daemon.so 提供。  
Type=dbus：若以此方式启动，当指定的 BusName 出现在 DBus 系统总线上时，systemd 认为服务就绪。  
Type=idle: systemd 会等待所有任务 (Jobs) 处理完成后，才开始执行 idle 类型的单元。除此之外，其他行为和 Type=simple 类似。  
PIDFile：pid 文件路径  
ExecStart：指定启动单元的命令或者脚本，ExecStartPre 和 ExecStartPost 节指定在 ExecStart 之前或者之后用户自定义执行的脚本。Type=oneshot 允许指定多个希望顺序执行的用户自定义命令。  
ExecReload：指定单元停止时执行的命令或者脚本。  
ExecStop：指定单元停止时执行的命令或者脚本。  
PrivateTmp：True 表示给服务分配独立的临时空间  
Restart：这个选项如果被允许，服务重启的时候进程会退出，会通过 systemctl 命令执行清除并重启的操作。  
RemainAfterExit：如果设置这个选择为真，服务会被认为是在激活状态，即使所以的进程已经退出，默认的为假，这个选项只有在 Type=oneshot 时需要被配置。

##### 3.[Install]

Alias：为单元提供一个空间分离的附加名字。  
RequiredBy：单元被允许运行需要的一系列依赖单元，RequiredBy 列表从 Require 获得依赖信息。  
WantBy：单元被允许运行需要的弱依赖性单元，Wantby 从 Want 列表获得依赖信息。  
Also：指出和单元一起安装或者被协助的单元。  
DefaultInstance：实例单元的限制，这个选项指定如果单元被允许运行默认的实例。

### 四、相关命令

```
[root@master ~]# systemctl is
is-active          is-enabled         is-failed          isolate            is-system-running
[root@master ~]# systemctl st
start   status  stop    

```

重载服务  
journalctl -f 服务名  
刚刚配置的服务需要让 systemctl 能识别，就必须刷新配置  
systemctl daemon-reload  
查看已启动的服务列表：systemctl list-unit-files|grep enabled  
查看启动失败的服务列表：systemctl --failed

_**————Blueicex 2020/2/7 12:28 blueice1980@126.com**_