---
url: https://sspai.com/post/68511#!
title: Openwrt 作为旁路网关（不是旁路由、单臂路由）的终极设置方法，破解迷思
date: 2023-04-04 15:32:35
tag: 
banner: "https://cdn.sspai.com/"
banner_icon: 🔖
---
副标题：以 x86、斐讯 N1、树莓派为例。旁路网关的性能到底重不重要？

先说结论：

旁路网关不会影响局域网性能，也不会影响广域网下行性能。因此，使用旁路网关的主要目的如果只是用来转发代理上网的流量，旁路网关的性能并不重要。测试可见文末。

破解迷思：

1.  旁路网关**不需要**取消 br-lan，**不需要**复用 eth0 添加 wan 口！
2.  旁路网关**不需要**打开防火墙的 lan->wan IP 动态伪装（POSTROUTING MASQUERADE）！

这两种做法都是网上常见错误设置方法，不是标准的 “旁路网关” 拓扑（那样做实际上是“单臂路由”），不能发挥局域网的最佳性能。具体设置方法可见文末。

**获取、编译 Openwrt 固件**

不要觉得困难，因为我已经帮你编译好了。

相比于官方镜像，我这个固件主要是定制和集成了一些内核模块、应用软件，更好兼容本文推荐的路由设备，更符合国内使用场景的需求。与其它一些第三方固件相比，最大的特点是：简洁。它只是为了做路由、网关而定制的固件，没有其它乱七八糟的非必须功能。

当然，如果你想加入其它软件，并且编译自己的版本，也是非常简单的。

利用 Github Actions 提供的免费集成功能，每周五会自动生成最新固件，提供下载和升级方法。

👇可以去我的软件仓库了解并获取固件👇

[Build Openwrt Firmware](https://sspai.com/link?target=https%3A%2F%2Fgithub.com%2Friverscn%2Fbuild-openwrt-firmware)

![](1680593555122.png)

Bootstrap 主题

![](1680593555390.png)

Argon 主题

**常见路由设备刷写 / 升级 Openwrt 固件**

Openwrt 固件通常是一个镜像文件，以 img 或 img.gz 为后缀。

主要刷写方式如下：

<table><thead><tr><th>&nbsp;</th><th>可从外部存储启动</th><th>不可从外部存储启动</th></tr></thead><tbody><tr><td><strong>没有内部存储</strong></td><td>直接将固件写入存储设备</td><td>（不存在这样的机器）</td></tr><tr><td><strong>内部存储可拆卸</strong></td><td>拆下内部存储，直接将固件写入</td><td>拆下内部存储，直接将固件写入</td></tr><tr><td><strong>内部存储不可拆卸</strong></td><td>通过外部存储启动，再将固件写入内部存储</td><td>通过原厂系统刷入 factory 固件转换，或其它刷机方式</td></tr></tbody></table>

将镜像写入可移动存储设备的工具：[Etcher](https://sspai.com/link?target=https%3A%2F%2Fwww.balena.io%2Fetcher%2F)

## **X86**

X86 是最简单的，[官方有详细说明](https://sspai.com/link?target=https%3A%2F%2Fopenwrt.org%2Fdocs%2Fguide-user%2Finstallation%2Fopenwrt_x86)。

简单来说，先把设备的内置存储设备拆下来，通过 USB 转接的方式连接到你的电脑上。然后使用 [Etcher](https://sspai.com/link?target=https%3A%2F%2Fwww.balena.io%2Fetcher%2F) 写入镜像文件，再把存储设备装回去，就能启动了。

也有其它方式，比如先用一个 Ubuntu Live U 盘在要安装 Openwrt 的设备上启动，在设备上将解压后的 img 镜像写入内置存储。命令是 `dd if=openwrt-18.06.1-x86-64-generic-ext4-combined.img of=/dev/xxx` 。

后续升级可以通过 Openwrt 内置的系统 / 升级功能进行。

网上有售 x86“工控机”，具备多个网口，很适合作为路由器。在 2021 年，我建议你购买 J4125 CPU 的机器作为软路由，售价大约 1000 元左右。性能是 NAS 级的，你想用它跑任何家庭网络服务压力都不大。

也可以考虑购买 “迷你主机”，和工控机并没有本质区别。对于 X86 电脑来说，网口不够用也没关系，通过 USB3.0 可以扩展 USB 网卡，1Gbps 或 2.5Gbps 网卡都没问题。

你甚至可以用虚拟机跑 Openwrt 来作为路由设备，复用你现有的电脑。

## **单片机：以树莓派为例**

树莓派也非常简单，因为它是通过 SD 卡启动的。使用 [Etcher](https://sspai.com/link?target=https%3A%2F%2Fwww.balena.io%2Fetcher%2F) 向 SD 卡写入镜像文件，插卡就能启动了。[官方有详细说明](https://sspai.com/link?target=https%3A%2F%2Fopenwrt.org%2Ftoh%2Fraspberry_pi_foundation%2Fraspberry_pi)。

后续升级可以通过 Openwrt 内置的系统 / 升级功能进行。

其它型号的单片机，包括像 NanoPi [R2S](https://sspai.com/link?target=https%3A%2F%2Fwiki.friendlyarm.com%2Fwiki%2Findex.php%2FNanoPi_R2S%2Fzh)/[R2C](https://sspai.com/link?target=http%3A%2F%2Fwiki.friendlyarm.com%2Fwiki%2Findex.php%2FNanoPi_R2C%2Fzh)/[R4S](https://sspai.com/link?target=https%3A%2F%2Fwiki.friendlyarm.com%2Fwiki%2Findex.php%2FNanoPi_R4S%2Fzh)，已获得 Openwrt 官方支持，获取固件和刷写也非常容易。

在全球芯片短缺的 2021 年，曾经 250 元左右一片的 2G 树莓派 4B，卖到了近 500 元。树莓派 4 的性能作为路由器非常合适，本来这是一个值得考虑的选项，但现在，显得非常鸡肋了。建议等 芯片供应正常再购买。

还有很火的 NanoPi R 系列，价格也涨了近一倍…… 建议观望，玩 ARM 单片机，本来就是图的便宜好玩，太贵了不如玩 x86。

树莓派 4B 包含了两个 USB3.0 接口，因此可以用它来扩展 USB 网卡。而树莓派 3B 的网络接口连千兆都跑不满，不推荐使用比 4B 性能更差的型号来作为路由设备。

## **其它 “电视盒子”：以斐讯 N1 为例**

斐讯 N1 可能需要降级并刷写改版固件，然后从 U 盘启动，再通过安装脚本来安装。该方式由 webpad 提供，可[参考其帖子](https://sspai.com/link?target=https%3A%2F%2Fwww.right.com.cn%2Fforum%2Fthread-340279-1-1.html)进行操作。

如果嫌麻烦，建议你买个刷好的二手。

降级后的 N1 可以通过刷入 Openwrt 固件的 U 盘启动，并将其刷入内置 EMMC 存储。在[我提供的固件](https://sspai.com/link?target=https%3A%2F%2Fgithub.com%2Friverscn%2Fbuild-openwrt-firmware)中，其刷写命令为 `/root/install-to-emmc.sh` ，脚本由 flippy 提供。

斐讯 N1 以及一些外贸盒子，都是可能在闲鱼捡到便宜货的。我手里的 N1 是在斐讯倒闭前，闲鱼新品甩卖时，80 元的价格购买的，非常香。而现在，它可能要买接近 200 元，不那么香了……

这些电视盒子刷入 Openwrt 固件的方法，可能需要你在网上参考一下别人的经验。

在所有这些盒子中，性能的排序参考 flippy 的总结：amliogic s922x(代表产品：GT-King、GT-King Pro，目前性能最强的 arm 盒子) > rockchip rk3399 > amlogic s905x3（代表产品：X96Max+，Hk1Box,H96 Max x3) > amlogic s912(代表产品：章鱼星球， 单核与 N1 差不多，但核数更多） > amlogic s905x2（代表产品：X96Max) = allwinner h6(代表产品：微加云）> s905x 或 s905d(代表产品：N1) > rk3328(代表产品：我家云、贝壳云)

## **给 “硬路由” 刷 Openwrt**

本文不涉及硬路由刷 Openwrt。其方式往往是通过先刷入 “factory” 版 Openwrt 镜像，往后再用 “sysupgrade” 版镜像，来实现转为 Openwrt 启动的。[官方有详细说明](https://sspai.com/link?target=https%3A%2F%2Fopenwrt.org%2Fdocs%2Fguide-user%2Finstallation%2Fstart)。

非常不推荐给成品无线路由（硬路由）刷 Openwrt，基本上都会影响无线性能和稳定性。建议你把它设置成 AP 模式，用原厂固件，安安静静提供无线接入点就好。Openwrt 还是要买个软路由来跑。

**主路由 vs 旁路网关**

要实现最佳体验，需要注意根据以下情况进行选择：

<table><thead><tr><th>条件</th><th>主路由模式</th><th>旁路网关模式</th></tr></thead><tbody><tr><td>需要替换现有的主路由</td><td>需要</td><td>不需要</td></tr><tr><td>运行 Openwrt 的设备具有较高性能</td><td>需要</td><td>不需要</td></tr><tr><td>运行 Openwrt 的设备具备多个物理网络接口，且带宽足够</td><td>需要</td><td>不需要</td></tr></tbody></table>

如果不能满足任意其一，建议选择旁路网关模式。

不过世上哪有那么好的事，旁路网关虽然需要满足的条件较少，但也有其劣势，可参考文末的测试。

## **把 Openwrt 作为主路由**

这是常用模式，该模式下，所有设备的网关指向主路由 IP，并且主路由作为 DHCP 服务器、DNS 服务器。

![](1680593555563.png)

主路由模式

如果运行 Openwrt 的设备有 2 个及以上的物理网络接口，推荐该模式。这是标准的局域网拓扑结构，所有的设备都能获得全双工的传输速率，所有流量都不会 “走弯路”。

安装方式也很简单，用 Openwrt 路由器作为主路由就行了。

## **把 Openwrt 作为旁路网关**

但有时候，Openwrt 设备可能只有 1 个物理网络接口，但又想利用 Openwrt 扩展现有网络的功能，就可以用 “旁路网关” 的方式实现。

旁路网关的好处是不需要修改现有网络基础设施，只需要在标准的局域网拓扑结构中，增加一个网关设备就行了。网关设备和一个普通的局域网设备在结构上是同等地位。所以也适用于不太好替换现有主路由的情况。

![](1680593555954.png)

旁路网关模式

旁路官关有两种利用方式：

1.  按需手动设置，只让指定的设备通过旁路网关访问 Internet。
2.  接管局域网的所有上网流量。

方式 1 不需要修改主路由配置，但需要修改客户端设备的网络设置。

方式 2 需要修改主路由配置，不需要修改客户端设备的网络设置。

两种方式均不影响局域网内的流量路径，局域网设备互访都是直通的（不会经过路由器或网关）。

**基本设置**

## **作为主路由的设置方法**

作为主路由是 Openwrt 的默认设置，这里不必多讲。

Openwrt 可以实现诸多高级特性，诸如多 WAN、[IPTV 融合](https://sspai.com/link?target=https%3A%2F%2Fblog.lishun.me%2Fiptvhelper-guide)等。这些都是做旁路网关时无法实现的功能。

## **作为旁路网关的设置方法**

### 旁路网关自身的基础设置

刷好固件的新 Openwrt 网关，一般默认的 IP 地址是 192.169.1.1。你可以通过 WiFi 或网线，**确保电脑只连接了它**，就可以访问该管理地址了。

1.  在 “网络”-“接口” 的“常规设置”中给 Openwrt 的 LAN 网络接口设置一个和现有局域网同网段的静态 IP 地址，注意不要和现有设备的 IP 地址冲突。然后应用设置。
2.  将 LAN 网络接口的 “默认网关” 设为主路由的 IP 地址。
3.  在 “高级设置” 中找到 “使用自定义的 DNS 服务器” 设为主路由的 IP 地址。
4.  在 “DHCP 服务器” 中勾选“忽略此接口”。
5.  在 “DHCP 服务器”-“IPv6 设置” 中禁用所有 IPv6 服务。
6.  点击 “保存” 以及“保存并应用”。
7.  在 “网络”-“防火墙” 中，关闭“SYN-flood 防御”，点击“保存并应用”。
8.  建议重启一次。

![](1680593556093.png)

如果你是通过 WiFi 接入点访问的，现在可以插上网线，通过有线局域网来访问它了。记得**删除 WiFi 接入点**以降低路由器的温度。

至此，它已经是一个合格的旁路网关了。

接下来有两种使用方式，根据偏好选择。

### 方式一：指定的设备才使用旁路网关

在指定的设备上，手动设置 IP 地址，将其 “网关” 和“首选 DNS”改为旁路网关的 IP 地址。

![](1680593556269.png)

### 方式二：所有设备都使用旁路网关

**重要的事说三遍：在主路由上设置，在主路由上设置，在主路由上设置**

如果**主路由**是 Openwrt 固件，找到 br-lan 网络接口，在 “DHCP 服务器” 的“高级设置”中添加两个选项：

*   3, 你的网关 IP
*   6, 你的网关 IP

![](1680593556417.png)

注意，这是主路由的设置，不是旁路网关！

如果是其它固件的主路由，或者成品路由器，找到类似 “DHCP 服务器” 的设置，在其中指定**默认网关**和**默认 DNS 服务器**是你的网关 IP 就行。

**性能测试，旁路网关的性能到底重不重要？**

## **测试局域网传输性能**

通过 ssh 命令 `ssh root@你的路由器ip` 进入到路由器的命令行界面。

`opkg update && opkg install iperf3` 安装 iperf3 测试软件。

`iperf3 -s` 运行测试。

在局域网的另一台机器上，同样安装 [iperf3](https://sspai.com/link?target=https%3A%2F%2Fiperf.fr%2Fiperf-download.php) 软件。

```
iperf3 -c 你的路由器ip
iperf3 -c 你的路由器ip -R

```

运行测试。先是测试的路由器从测试机下载数据的性能，再测试的是反过来的性能。

这是我测试的自己的树莓派 4B 的性能：

```
$ iperf3 -c 192.168.1.3
[ ID] Interval           Transfer     Bandwidth
[  4]   0.00-10.00  sec  1.10 GBytes   949 Mbits/sec                  sender
[  4]   0.00-10.00  sec  1.10 GBytes   949 Mbits/sec                  receiver

$ iperf3 -c 192.168.1.3 -R
Reverse mode, remote host 192.168.1.3 is sending
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-10.00  sec  1.10 GBytes   944 Mbits/sec    0             sender
[  4]   0.00-10.00  sec  1.10 GBytes   944 Mbits/sec                  receiver

```

## **通过 netdata 软件监控性能状况**

在路由器中运行 `opkg update && opkg install netdata` 安装 netdata 监控软件。或者在 “系统 / 软件包” 菜单中安装。

然后在浏览器上访问 `http://路由器ip:19999` 就可以了

## **测试广域网转发性能、代理转发性能**

在 netdata 中点击右上角 Settings， 关闭 On Focus。

同时启动一个测速软件，例如 Speedtest.net，跑一跑，看看性能如何？

我们来验证一下，上文所说的，各种流量情况下，主路由和旁路网关的负载情况？

（我家的宽带标称 500M，上行标称 100M）

### 1. 广域网下行流量

主路由负责转发流量，旁路网关围观。

![](1680593556580.png)

测试设备：树莓派 4B（下面的仪表盘）

旁路网关真的在围观吗？我想了个办法，在树莓派上跑 iperf3，把它的出站流量占满，同时开始广域网下行。

![](1680593556725.png)

测试设备：树莓派 4B

我们再来看看斐讯 N1 的表现。N1 的网卡没有硬件流控功能，所以可能会引起问题，而软件流控损失性能。在运行 flippy 的固件安装脚本时，会问你选择是否用`*-thresh.dtb`开启软件流控，默认不采用。

我们来实测一下。N1 有一个 USB2.0 接口，接上网卡，对网速进行物理封印！便于观察网关是否真的不影响下行流量。

![](1680593556894.png)

斐讯 N1+USB2.0 网卡，物理封印网速

我在另一台电脑上不停地 iperf3 占满 N1 的网络带宽，同时在旁路网关的客户端电脑上测速。

![](1680593557110.png)

测试设备：斐讯 N1+USB2.0 网卡

神奇的事情发生了！网关并没有完全在围观，它的 iperf3 传输速度显然受到了影响。但客户端并没有受到影响，测速显然已经突破 USB2.0 的速率限制了。

结论：

*   广域网下行流量速率不受旁路网关性能的影响
*   N1 在关闭软件流控时，因为没有硬件流控功能，所以可能会被局域网中的其它流量干扰。会有一定影响自身性能，但不影响局域网其它设备的性能。作为旁路网关，在这一点上，树莓派完胜。

### 2. 广域网上行流量

主路由和旁路网关同时在转发流量。

![](1680593557258.png)

测试设备：树莓派 4B（下面的仪表盘）

### 3. 代理转发流量

![](1680593557424.png)

我使用的是 Xray VLESS XTLS

只测试下行就好，上行肯定会经过旁路网关的。

![](1680593558200.png)

测试设备：树莓派 4B（下面的仪表盘）

看这个测试结果，难道说，代理转发的下行流量并不需要经过旁路网关的转发吗？想想并不可能啊。

换 fast.com 再试试…… 可以发现，代理转发流量经过了 N1。

![](1680593558387.png)

测试设备：N1

所以破案了！原来 speedtest.net 不知为何并没有经过代理，不要相信它！所以不要用它做代理速度测试了，可能是不准的。

至此，通过实践证实了以下结论：

<table><thead><tr><th>优劣对比</th><th>主路由模式</th><th>旁路网关模式</th></tr></thead><tbody><tr><td>局域网流量</td><td>不影响性能</td><td>不影响性能</td></tr><tr><td>广域网下行流量</td><td>受限于主路由 NAT 转发性能</td><td>受限于主路由 NAT 转发性能</td></tr><tr><td>广域网上行流量</td><td>受限于主路由 NAT 转发性能</td><td>同时受限于主路由和旁路网关 NAT 转发性能</td></tr><tr><td>代理上网转发流量</td><td>外加受限于主路由 CPU 性能</td><td>同时受限于主路由和旁路网关 NAT 转发性能，外加旁路网关 CPU 性能</td></tr></tbody></table>

最后，可以有理有据地得出如何选择旁路网关的结论：

1.  旁路网关的网卡带宽只要不低于你的上传带宽，就不会对普通流量造成瓶颈。考虑到国内的上行带宽通常非常小，所以基本不会造成影响
2.  旁路网关作为代理上网的转发网关，性能下限是由其 CPU 性能和网卡带宽中最低的部分决定的

所以旁路网关的性能，并不那么重要。忽悠你买高性能旁路网关的，肯定是奸商。

但旁路网关无法负责 NAT 部分的功能，如果你需要多 WAN、IPTV 等功能，还是需要一个功能灵活的主路由。但如果你仅仅只是为了转发代理上网流量，实现透明代理，那么旁路网关是个非常经济、简单的选择。

好了，以上就是我这些年来玩 Openwrt 作为家庭网络的路由系统的终极经验了。

工作桌面纪念照：

![](1680593558657.png)

[原文](https://sspai.com/link?target=https%3A%2F%2Fblog.lishun.me%2Fopenwrt-mega-post)发布在我的博客上。