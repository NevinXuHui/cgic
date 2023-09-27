## [iptables](https://so.csdn.net/so/search?q=iptables&spm=1001.2101.3001.7020) 详解

**1. 什么是 iptables**
iptables 是 linux 系统中非常出名的防火墙软件，但是其实 iptables 并不是真正的防火墙，我们可以把它理解为一个代理程序，我们通过 iptables 这个代理程序，编写相应的规则，并将这些规则执行到 “安全框架” 中去，所以，这个安全框架才是真正的防火墙，linux 中这个安全框架叫“netfilter”,netfilter 工作在操作系统的内核空间，iptables 则工作在系统的用户空间。
netfilter/iptables 是 linux 平台下的 “包过滤型防火墙”，是免费的，它可以代替昂贵的商业防火墙解决方案，完成数据包的过滤，网络地址的转换（NAT）等功能。

**2. 什么是包过滤防火墙**
包过滤防火墙它在网络层截取网络数据包的包头（header）, 针对数据包的包头，根据事先定义好的防火墙过滤规则进行对比，根据对比结果，再执行不同的动作。
包过滤防火墙一般工作在网络层，所以也称为 “网络防火墙”，通过检查数据流中每一个数据包的源 ip 地址，目标 ip 地址, 源端口，目标端口，协议类型（tcp,udp,icmp 等），状态等信息来判断是否符合规则

**3. 包过滤防火墙如何实现**
包过滤防火墙是由 netfilter 来实现的，netfilter 是内核的一部分，所以，如果我们想要防火墙能够达到 "防火" 的目的，就需要在内核中设置好 “关卡”，所有进出的报文都要经过这些关卡，进行检查，将符合条件的放行，不符合条件的阻止，而这些关卡在 iptables 中被称为 “链”

**4.Iptables 中链的概念**
我们知道，防火墙的作用就在于对经过的数据报文进行 “规则” 匹配，然后执行规则对应的 “动作”，所以当报文经过这些关卡的时候，则必须匹配这个关卡上的规则，但是这个关卡上可能不止有一条规则，而是有很多条规则，当我们把这些规则串到一起的时候，就形成了“链”, 所以，每个经过这个“关卡” 的报文，都要被这条“链“上所有的规则匹配一遍，如果匹配到了某条规则，则执行相应的动作，如果没有匹配到则执行默认链的动作。

![](https://img-blog.csdnimg.cn/20210619112532401.png#pic_center)

**5.Iptable 中有哪些链**
iptables 由 5 条链，分别是：PREROUTING,INPUT,OUTPUT,FORWARD,POST_ROUTING

![](https://img-blog.csdnimg.cn/20210619162451989.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dhZ2hhaXBpbmc=,size_16,color_FFFFFF,t_70#pic_center)

**6.iptables 中表的概念**
什么是表？
表是具有相同功能的集合，iptables 中定义了四个表

![](https://img-blog.csdnimg.cn/20210619165354688.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dhZ2hhaXBpbmc=,size_16,color_FFFFFF,t_70#pic_center)

哪个表中包含什么链不必去硬背，记不住可以使用下面命令去查看一下就知道了
[root@dns ~]# iptables -t filter -L
Chain INPUT (policy ACCEPT)
target prot opt source destination

Chain FORWARD (policy ACCEPT)
target prot opt source destination

Chain OUTPUT (policy ACCEPT)
target prot opt source destination

**7. 表与链的关系**

![](https://img-blog.csdnimg.cn/20210619174710162.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dhZ2hhaXBpbmc=,size_16,color_FFFFFF,t_70#pic_center)

**8.iptables 规则管理**

```Plain Text
什么是规则？
数据包过滤基于规则，而规则由匹配条件+动作组成
规则操作时的考虑点：
1，要实现什么功能：判断添加到哪个表上
2，报文流经的录像：判断添加到哪个链上

```

![](https://img-blog.csdnimg.cn/20210619224354397.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dhZ2hhaXBpbmc=,size_16,color_FFFFFF,t_70)

如何查看规则：
（-L 查看详情，-n 不反解，-v 详细信息，–line-numbers 显示规则编号）
[root@dns ~]# iptables -t filter -L -n -v --line-numbers
Chain INPUT (policy ACCEPT 659 packets, 46526 bytes)
num pkts bytes target prot opt in out source destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
num pkts bytes target prot opt in out source destination

Chain OUTPUT (policy ACCEPT 452 packets, 27508 bytes)
num pkts bytes target prot opt in out source destination

如何添加规则：
例子: 允许所有主机 ping 本机
[root@dns ~]# iptables -t filter -I INPUT -p icmp -j ACCEPT
（-I 在指定链的最前面插入规则，-p 指点协议，-j 指定动作）

![](https://img-blog.csdnimg.cn/2021061922553840.png)

如何修改规则：

例子：将上面的规则改为不允许任何主机 ping 本机
[root@dns ~]# iptables -t filter -R INPUT 1 -p icmp -j DROP
(-R INPUT 1 替换 input 链上的第一条规则)

![](https://img-blog.csdnimg.cn/20210619225949163.png)

如何删除规则：
第一，根据规则的编号去删除
第二，根据具体的匹配条件和动作删除
例子：将上面设置的规则删除
[root@dns ~]# iptables -t filter -D INPUT 1
(-D INPUT 1 删除 input 链上的第 1 条规则，这是根据规则的编号进行删除的)

![](https://img-blog.csdnimg.cn/20210619230616920.png)

如何保存规则：

默认 iptables 编写的规则属于临时的，所以需要将编写的规则永久保存起来

[root@dns ~]# iptables-save > /etc/iptables.rules

```Plain Text
清空iptables所有的规则，然后用保存的规则恢复

```

[root@dns ~]# iptables -F
[root@dns ~]# iptables-restore < /etc/iptables.rules

