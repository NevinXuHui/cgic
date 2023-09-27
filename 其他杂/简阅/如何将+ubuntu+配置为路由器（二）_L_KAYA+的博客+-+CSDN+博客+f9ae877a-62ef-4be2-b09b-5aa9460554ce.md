上次文章链接：[如何将 ubuntu 配置为路由器](https://blog.csdn.net/qq_31847339/article/details/101471828)

上次说到将具有六个独立网卡的软交换机通过 NAT 的方式实现了一个网卡与另一个网卡跨网段上网功能，那么有没有一种方法，能让其中一个口作为 wan 口，其他网口作为 lan 口且全在同一局域网下？

您好，有的。

答案就是 linux 的 bridge（桥接）功能。

## Bridge 网桥

关于 bridge 的简介可以参考这篇文章，我认为讲得简单易懂  [Linux Bridge 简介](https://blog.csdn.net/chengqiuming/article/details/79840590)。总结概括如下：

- bridge 是虚拟网络设备

- bridge 依赖于实际物理网卡，其 MAC 地址即为其依赖物理网卡的 mac 地址

- 所有挂在 bridge 下的网卡都在同一个子网且没有 ip（或者可以认为 ip 为 0.0.0.0）

其实说白了 bridge 就是实现了交换机的功能，然后通过 NAT 将 bridge 与 WAN 口网卡连接起来，就可以实现开头说的功能，接下来就是实际操作了。

## 网桥管理工具

首先需要安装一个 bridge 管理工具

```Plain Text
sudo apt-get install bridge-utile

```

## 网桥配置脚本

然后依次输入新建一个. sh 脚本文件

```Plain Text
# 新建一个bridge, 名字为br0
sudo ip link add name br0 type bridge
 
# 向网桥添加网卡设备（虚拟网卡设备也可以）, bridge的MAC与第一个添加的设备相同
sudo brctl addif br0 eht1
sudo brctl addif br0 eht2
sudo brctl addif br0 eht3
sudo brctl addif br0 eht4
 
# 停止网卡设备（其实不停也无所谓）
sudo ifconfig eht1 down
sudo ifconfig eht2 down
sudo ifconfig eht3 down
sudo ifconfig eht4 down
 
# 将上述网卡设备ip设为0.0.0.0 并启动网络设备
sudo ifconfig eht1 0.0.0.0 up
sudo ifconfig eht2 0.0.0.0 up
sudo ifconfig eht3 0.0.0.0 up
sudo ifconfig eht4 0.0.0.0 up
 
# 网桥ip设为192.168.1.1(网关), 子网掩码255.255.255.0 并启动网桥
sudo ifconfig br0 192.168.1.1 netmask 255.255.255.0 up
 
# 添加路由
sudo route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1 br0
 
# 开启WAN口网卡与br0网桥的转发功能
sudo iptables -A FORWARD -i eth0 -o br0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o br0 -j ACCEPT
 
# NAT
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
```

其中第一个指令新建网桥也可以用这个

```Plain Text
sudo brctl addbr br0

```

## 完成

运行脚本文件，现在 eth1~~eth4 都连接到了 br0 网桥，即 eth1~~eth4+br0 都处于 192.168.1.0 这个网段下且 br0 网桥为网关，其他设备连接到 eth1~~eth4 上，修改 ip 到 192.168.1.0 网段即可上网，通过 ifconfig 命令可以看到网络设备多了个 br0，其 mac 地址与 eth1 相同，且 eth1~~eth4 没有 ip 地址。

