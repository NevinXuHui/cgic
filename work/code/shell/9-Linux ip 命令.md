---
url: https://www.runoob.com/linux/linux-comm-ip.html
title: Linux ip 命令
date: 2023-04-21 14:05:50
tag: 
banner: "https://www.runoob.com/images/up.gif"
banner_icon: 🔖
---
[Shell 文件包含](https://www.runoob.com/linux/linux-shell-include-file.html "Shell 文件包含") [Nginx 安装配置](https://www.runoob.com/linux/nginx-install-setup.html "Nginx 安装配置")

[![](https://www.runoob.com/images/up.gif)](linux-command-manual.html)

[Linux 命令大全](linux-command-manual.html)

Linux ip 命令与 [ifconfig](https://www.runoob.com/linux/linux-comm-ifconfig.html) 命令类似，但比 ifconfig 命令更加强大，主要功能是用于显示或设置网络设备。

ip 命令是 Linux 加强版的的网络配置工具，用于代替 ifconfig 命令。

### 语法

```
ip [ OPTIONS ] OBJECT { COMMAND | help }

```

OBJECT 为常用对象，值可以是以下几种：

```
 
OBJECT={ link | addr | addrlabel | route | rule | neigh | ntable | tunnel | maddr | mroute | mrule | monitor | xfrm | token }

```

常用对象的取值含义如下：

*   link：网络设备
*   address：设备上的协议（IP 或 IPv6）地址
*   addrlabel：协议地址选择的标签配置
*   route：路由表条目
*   rule：路由策略数据库中的规则

OPTIONS 为常用选项，值可以是以下几种：

```
OPTIONS={ -V[ersion] | -s[tatistics] | -d[etails] | -r[esolve] | -h[uman-readable] | -iec | -f[amily] { inet | inet6 | ipx | dnet | link } | -o[neline] | -t[imestamp] | -b[atch] [filename] | -rc[vbuf] [size] }

```

常用选项的取值含义如下：

*   -V：显示命令的版本信息；
*   -s：输出更详细的信息；
*   -f：强制使用指定的协议族；
*   -4：指定使用的网络层协议是 IPv4 协议；
*   -6：指定使用的网络层协议是 IPv6 协议；
*   -0：输出信息每条记录输出一行，即使内容较多也不换行显示；
*   -r：显示主机时，不使用 IP 地址，而使用主机的域名。
*   help 为该命令的帮助信息。
    
    ### 实例
    
    ```
    ip link show                     # 显示网络接口信息
    ip link set eth0 up             # 开启网卡
    ip link set eth0 down            # 关闭网卡
    ip link set eth0 promisc on      # 开启网卡的混合模式
    ip link set eth0 promisc offi    # 关闭网卡的混个模式
    ip link set eth0 txqueuelen 1200 # 设置网卡队列长度
    ip link set eth0 mtu 1400        # 设置网卡最大传输单元
    ip addr show     # 显示网卡IP信息
    ip addr add 192.168.0.1/24 dev eth0 # 设置eth0网卡IP地址192.168.0.1
    ip addr del 192.168.0.1/24 dev eth0 # 删除eth0网卡IP地址
    
    ip route show # 显示系统路由
    ip route add default via 192.168.1.254   # 设置系统默认路由
    ip route list                 # 查看路由信息
    ip route add 192.168.4.0/24  via  192.168.0.254 dev eth0 # 设置192.168.4.0网段的网关为192.168.0.254,数据走eth0接口
    ip route add default via  192.168.0.254  dev eth0        # 设置默认网关为192.168.0.254
    ip route del 192.168.4.0/24   # 删除192.168.4.0网段的网关
    ip route del default          # 删除默认路由
    ip route delete 192.168.1.0/24 dev eth0 # 删除路由
    
    ```
    
    用 ip 命令显示网络设备的运行状态：
    
    ```
    [root@localhost ~]# ip link list
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
        link/ether 00:16:3e:00:1e:51 brd ff:ff:ff:ff:ff:ff
    3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
        link/ether 00:16:3e:00:1e:52 brd ff:ff:ff:ff:ff:ff
    
    ```
    
    显示更加详细的设备信息：
    
    ```
    [root@localhost ~]# ip -s link list
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        RX: bytes  packets  errors  dropped overrun mcast   
        5082831    56145    0       0       0       0      
        TX: bytes  packets  errors  dropped carrier collsns
        5082831    56145    0       0       0       0      
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
        link/ether 00:16:3e:00:1e:51 brd ff:ff:ff:ff:ff:ff
        RX: bytes  packets  errors  dropped overrun mcast   
        3641655380 62027099 0       0       0       0      
        TX: bytes  packets  errors  dropped carrier collsns
        6155236    89160    0       0       0       0      
    3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
        link/ether 00:16:3e:00:1e:52 brd ff:ff:ff:ff:ff:ff
        RX: bytes  packets  errors  dropped overrun mcast   
        2562136822 488237847 0       0       0       0      
        TX: bytes  packets  errors  dropped carrier collsns
        3486617396 9691081  0       0       0       0    
    
    ```
    
    显示核心路由表：
    
    ```
    [root@localhost ~]# ip route list 
    112.124.12.0/22 dev eth1  proto kernel  scope link  src 112.124.15.130
    10.160.0.0/20 dev eth0  proto kernel  scope link  src 10.160.7.81
    192.168.0.0/16 via 10.160.15.247 dev eth0
    172.16.0.0/12 via 10.160.15.247 dev eth0
    10.0.0.0/8 via 10.160.15.247 dev eth0
    default via 112.124.15.247 dev eth1
    
    ```
    
    显示邻居表：
    
    ```
    [root@localhost ~]# ip neigh list
    112.124.15.247 dev eth1 lladdr 00:00:0c:9f:f3:88 REACHABLE
    10.160.15.247 dev eth0 lladdr 00:00:0c:9f:f2:c0 STALE
    
    ```
    
    获取主机所有网络接口：
    
    ```
    ip link | grep -E '^[0-9]' | awk -F: '{print $2}'
    
    ```
    
    [![](https://www.runoob.com/images/up.gif)](linux-command-manual.html)
    
    [Linux 命令大全](linux-command-manual.html)