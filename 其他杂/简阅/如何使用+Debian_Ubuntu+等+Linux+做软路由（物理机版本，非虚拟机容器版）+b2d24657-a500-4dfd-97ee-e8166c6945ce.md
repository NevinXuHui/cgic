使用原版的 Linux 做路由器可以更好的自我定制，挂各种服务脚本（支持任何语言，python，c++...etc），实现真正意义上的 ALL in one。这里会以 Ubuntu server 为例实例如何将最小化安装的 Linux 主机变身为路由器。

## 前置准备：

### 硬件要求：

- 最低：一台 x86 主机，至少 2 个网口，无需显卡（装系统要一下）

- 推荐配置：内存 >=1g，功耗越低越好，网口 2 个，其余配交换机，需要配置 vlan 的自行添加网口。

### OS：

- 使用 U 盘引导安装 Linux，此处以最简单的 Ubuntu server 20.04 为例。

- 知道一些最基本的 Linux 操作，知道如何远程 ssh 登录（win10 powershell 现在自带 ssh，不需要再用 putty 等软件）

## 配置过程：

### 一、更新系统

在装好系统后首先就是要更新源与系统，国内需要更换国内源，然后

```Plain Text
sudo apt update
sudo apt upgrade

```

### 二、配置网卡：

在更新完系统后查看自己的网卡名称：

```Plain Text
ip a

```

输入以上命令后会出现类似以下的输出：

```Plain Text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 5c:b9:01:97:8f:da brd ff:ff:ff:ff:ff:ff
    inet6 fe80::5eb9:1ff:fe97:8fda/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 5c:b9:01:97:8f:db brd ff:ff:ff:ff:ff:ff

```

其中 lo 不用管，2 和 3 分别代表你两个网口对应的网卡名称，如果有更多网卡的话会有更多出来。

本文假设网卡一为 eth0，网卡 2 为 eth1 进行配置，实际配置时根据自身情况更改名称。

修改网络配置文件，此处以 Ubuntu server 为例，Ubuntu 使用 netplan 进行网络管理，而 Debian 则稍有不同，Debian 请自行配置：

```Plain Text
sudo nano /etc/netplan/00-installer-config.yaml

```

其中 yaml 文件名称可能会有不同，自行替换即可。配置文件修改为以下：

```Plain Text
network:
    version: 2
    renderer: networkd
    ethernets:
        eth0:
            dhcp4: yes
            nameservers:
                addresses:
                - 114.114.114.114
                - 8.8.8.8
        eth1:
            dhcp4: no
            addresses:
            - 192.168.2.1/24
            dhcp4: false

```

注意匹配网卡名。也可根据自己的需求自定义配置。（其中 eth0 连光猫（wan 口），eth1 连内网设备或者交换机（lan 口）），CTRL+x -> y -> 回车保存。

修改完成后输入以下命令使其生效：

```Plain Text
sudo netplan apply

```

### 三、开启 ipv4 转发：

编辑以下配置文件：

```Plain Text
sudo nano /etc/sysctl.conf

```

找到这一行：

*#net.ipv4.ip_forward=1*

如果前面有 #号就把# 号去掉，如果 = 后面为 0 就修改为 1。改完应该如下：

*net.ipv4.ip_forward=1*

CTRL+x -> y -> 回车保存。

修改完成后输入以下命令使其生效：

```Plain Text
sudo sysctl -p

```

### 四、安装 dhcp 服务器：

输入以下命令安装 dhcp 服务：

```Plain Text
sudo apt install isc-dhcp-server -y

```

安装完成后配置以下配置文件：

```Plain Text
sudo nano /etc/default/isc-dhcp-server

```

找到以下行：

*INTERFACESv4="enp1s0f1"*

修改为：

INTERFACESv4="eth1"

注意匹配网卡名。

CTRL+x -> y -> 回车保存。

接下来修改以下配置文件：

```Plain Text
sudo nano /etc/dhcp/dhcpd.conf

```

为了方便起见我这里直接贴上修改好的配置文件，自己自行替换即可：

```Plain Text
# dhcpd.conf
#
# Sample configuration file for ISC dhcpd
#

# option definitions common to all supported networks...
# option domain-name "debian-router.net";
option domain-name-servers 114.114.114.114, 8.8.8.8;

default-lease-time 600;
max-lease-time 7200;

# The ddns-updates-style parameter controls whether or not the server will
# attempt to do a DNS update when a lease is confirmed. We default to the
# behavior of the version 2 packages ('none', since DHCP v2 didn't
# have support for DDNS.)
ddns-update-style none;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
#authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
#log-facility local7;

# No service will be given on this subnet, but declaring it helps the
# DHCP server to understand the network topology.

#subnet 10.152.187.0 netmask 255.255.255.0 {
#}

# This is a very basic subnet declaration.
option subnet-mask 255.255.255.0;
option broadcast-address 192.168.2.255;
subnet 192.168.2.0 netmask 255.255.255.0 {
  range 192.168.2.10 192.168.2.233;
  option routers 192.168.2.1;
}

```

CTRL+x -> y -> 回车保存。

重启 dhcp 服务使配置生效：

```Plain Text
sudo service isc-dhcp-server restart

```

### 五、配置 iptables：

**由于一些高版本的 Linux 默认使用 nftables，所以需要先卸载 nftables 再安装 iptables，要是你会配置 nftables 也可以用 nftables 进行路由配置，如果本身就是 iptables 可以略去这一步。**

**卸载 nftables 并安装 iptables：**

```Plain Text
sudo apt remove --auto-remove nftables
sudo apt purge nftables
sudo apt install iptables

```

以上根据自身情况来，接下来配置 iptables：

```Plain Text
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

```

注意匹配网卡名。

安装 iptables-persistent 保存配置（一路 yes 即可）：

```Plain Text
apt install iptables-persistent -y

```

### 六、配置 pppoe 拨号上网：

安装 ppoeconf：

```Plain Text
sudo apt install pppoeconf -y

```

安装完成后输入

```Plain Text
pppoeconf

```

进行配置，根据提示输入运营商的账号密码即可（配置过程中 eth0 记得要连接在光猫上，不然扫描不到网络）。

配置成功后再次输入

```Plain Text
ip a

```

应该可以看到一个 ppp0 的网卡，下面有运营商的 ip 即成功联网：

```Plain Text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp1s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 5c:b9:01:97:8f:da brd ff:ff:ff:ff:ff:ff
    inet6 fe80::5eb9:1ff:fe97:8fda/64 scope link
       valid_lft forever preferred_lft forever
3: enp1s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 5c:b9:01:97:8f:db brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.1/24 brd 192.168.2.255 scope global enp1s0f1
       valid_lft forever preferred_lft forever
    inet6 fe80::5eb9:1ff:fe97:8fdb/64 scope link
       valid_lft forever preferred_lft forever
4: ppp0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1492 qdisc pfifo_fast state UNKNOWN group default qlen 3
    link/ppp
    inet 180.112.120.136 peer 180.112.120.1/32 scope global ppp0
       valid_lft forever preferred_lft forever
    inet6 240e:3a0:1402:5070:7892:1f4d:70f1:ec86/64 scope global dynamic mngtmpaddr
       valid_lft 258127sec preferred_lft 171727sec
    inet6 fe80::7892:1f4d:70f1:ec86 peer fe80::4ef9:5dff:fe85:f063/128 scope link
       valid_lft forever preferred_lft forever

```

最后重启机器使所有配置生效：

```Plain Text
sudo reboot

```

至此基本功能全部配置完成。

如果需要配置防火墙推荐 iptables 或者 nftables 直接配置，这里不推荐 ufw，因为不稳定。

## 可选（进行以下操作之前请务必明白自己在干什么）：

### Debian 需配置 / etc/network/interfaces 而不是 netplan：

```Plain Text
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp1s0f0
iface enp1sf0 inet dhcp
        dns-nameservers 114.114.114.114

auto enp1s0f1
iface enp1s0f1 inet static
address        192.168.2.1
netmask        255.255.255.0
broadcast      192.168.2.255
network        192.168.2.0

auto dsl-provider
iface dsl-provider inet ppp
pre-up /bin/ip link set enp1s0f0 up # line maintained by pppoeconf
provider dsl-provider

#auto enp1s0f0
#iface enp1s0f0 inet manual
#iface enp1s0f0 inet manual
iface enp1s0f0 inet manual

```

### iptables 内网端口映射：

```Plain Text
iptables -t nat -A PREROUTING -p tcp -i enp1s0f0 --dport 4454 -j DNAT --to-destination 192.168.2.x:x

```

注意网卡对应

### iptables 内网多端口映射：

```Plain Text
iptables -t nat -A PREROUTING -p tcp -i enp1s0f0 --dport 4454:4480 -j DNAT --to-destination 192.168.2.x:4454-4480

```

注意网卡对应

### samba 文件服务器：

```Plain Text
sudo apt install samba -y

```

### ddns 服务：

```Plain Text
sudo apt install ddclient -y

```

### INPUT 链防火墙筛选与端口阻断：

```Plain Text
iptables -A INPUT -i ppp0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i enp1s0f1 -p tcp -j ACCEPT
iptables -P INPUT DROP

```

### 显示 nat 表规则：

```Plain Text
iptables -t nat -L -v

```

### 显示 INPUT 链规则：

```Plain Text
iptables -L INPUT -v

```

### 安装 bt 服务：

```Plain Text
sudo apt install transmission-daemon -y

```

### 启用 cockpit 监控系统状态

### 其他待补充...

