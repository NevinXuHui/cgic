---
url: https://blog.csdn.net/whstudio123/article/details/120811616#%E9%80%9A%E8%BF%87%20Http%20%E8%AE%BF%E9%97%AE%20Ubus%EF%BC%88%E4%B8%8D%E7%BB%86%E8%AF%B4%EF%BC%89
title: Openwrt 从小白到专家：ubus 总线和 uci_whstudio123 的博客 - CSDN 博客
date: 2023-08-13 11:44:01
tag: 
banner: "https://images.unsplash.com/photo-1689714321677-a914620d6b76?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxODk4MjM1fA&ixlib=rb-4.0.3&q=85&fit=crop&w=682&max-h=540"
banner_icon: 🔖
---
### [Openwrt](https://so.csdn.net/so/search?q=Openwrt&spm=1001.2101.3001.7020) 从小白到专家：ubus 总线

*   [ubus（OpenWrt 微总线架构）](#ubusOpenWrt__1)
*   [命令行中使用 ubus 工具](#_ubus__12)
*   *   [help](#help_18)
    *   [list](#list_39)
    *   [call](#call_89)
    *   [listen](#listen_157)
    *   [send](#send_171)
*   [通过 HTTP 访问 ubus（不细说）](#_HTTP__ubus_179)
*   [使用 ubus 配置系统的几个实例：](#_ubus__191)
*   [ubus 在 Ubuntu 上安装](#ubus__Ubuntu__232)
*   [uci](#uci_266)

# ubus（OpenWrt 微总线架构）

为了在 OpenWrt 中提供各种守护进程和 app 之间的进程间通信，openWrt 开发了一个名为 ubus 的项目。它由守护进程、库和一些额外的 helper 组成。

这个项目的核心是 ubusd 守护进程。它为其他守护进程提供用来注册自己和发送消息的接口，这个接口是使用 Unix 套接字实现的，它使用 TLV（类型 - 长度 - 值）消息。

为了方便调用 ubus 的 app 开发，我们又建立了 libubus 库。

每个守护进程在特定的命名空间下注册一组路径。每个路径都可以提供具有任意数量参数的多个过程。程序可以用消息回复。

该代码是在 LGPL 2.1 许可下发布的，可以通过 git 在 https://git.openwrt.org/project/ubus.git 找到。

# 命令行中使用 ubus 工具

ubus 命令行工具能够与 ubusd 服务器交互（与所有注册的服务进行交互）。它对于调查 / 调试注册的 namespace 以及编写 shell 脚本很有用。

为了方便调用和返回值，它使用用户友好的 JSON 格式（译者注：这其实是一种 JSON-RPC 的方式，无状态，轻量级，方便不同语言和平台绑定）。下面是对其命令的解释。

## help

```
root@OpenWrt:~# ubus
用法：ubus [<options>] <command> [arguments...]
选项：
 -s <socket>：设置要连接的unix域套接字
 -t <timeout>：设置命令完成的超时时间（以秒为单位）
 -S：使用简化的输出（用于脚本）
 -v：更详细的输出
 -m <type>：（用于监视器）：包含特定的消息类型
			（可以多次使用）
 -M <r|t> (for monitor): 只捕获接收或传输的流量

命令：
 - list [<path>] 列出对象
 - call <path> <method> [<message>] 调用一个对象方法
 - listen [<path>...] 监听事件
 - send <type> [<message>] 发送事件
 - wait_for <object> [<object>...] 等待多个对象出现在 ubus 上
 - 监控 监控 ubus 流量

```

## list

我们可以使用 ubus list 命令列出当前在总线上运行的服务，Example：

```
root@OpenWrt:~# ubus list
dhcp
dnsmasq
file
iwinfo
log
luci
luci-rpc
network
network.device
network.interface
network.interface.lan
network.interface.loopback
network.interface.wan
network.interface.wan6
network.rrdns
network.wireless
service
session
system
uci

```

我们可以通过指定服务路径来过滤列表，Example：

```
root@OpenWrt:~# ubus list network.interface.*
network.interface.lan
network.interface.loopback
network.interface.wan
network.interface.wan6

```

列出特定服务的方法及其参数名，加个参数 -v：

```
root@OpenWrt:~# ubus -v list network.interface.lan
'network.interface.lan' @099f0c8b
	"up": {  }
	"down": {  }
	"status": {  }
	"prepare": {  }
	"add_device": { "name": "String" }
	"remove_device": { "name": "String" }
	"notify_proto": {  }
	"remove": {  }
	"set_data": {  }

```

## call

用法：call + 服务名 + 函数名 + 输入的 json(如果有参数的话)，example：

```
root@OpenWrt:~# ubus call network.interface.wan status
{
	"up": true,
	"pending": false,
	"available": true,
	"autostart": true,
	"uptime": 86017,
	"l3_device": "eth1",
	"device": "eth1",
	"address": [
		{
			"address": "178.25.65.236",
			"mask": 21
		}
	],
	"route": [
		{
			"target": "0.0.0.0",
			"mask": 0,
			"nexthop": "178.25.71.254"
		}
	],
	"data": {

	}
}

```

注意：参数必须是一个完整的 json，键值得按照函数的要求来。example：

```
root@OpenWrt:~# ubus call network.device status '{ "name": "eth0" }'
{
	"type": "Network device",
	"up": true,
	"link": true,
	"mtu": 1500,
	"macaddr": "c6:3d:c7:90:aa:da",
	"txqueuelen": 1000,
	"statistics": {
		"collisions": 0,
		"rx_frame_errors": 0,
		"tx_compressed": 0,
		"multicast": 0,
		"rx_length_errors": 0,
		"tx_dropped": 0,
		"rx_bytes": 0,
		"rx_missed_errors": 0,
		"tx_errors": 0,
		"rx_compressed": 0,
		"rx_over_errors": 0,
		"tx_fifo_errors": 0,
		"rx_crc_errors": 0,
		"rx_packets": 0,
		"tx_heartbeat_errors": 0,
		"rx_dropped": 0,
		"tx_aborted_errors": 0,
		"tx_packets": 184546,
		"rx_errors": 0,
		"tx_bytes": 17409452,
		"tx_window_errors": 0,
		"rx_fifo_errors": 0,
		"tx_carrier_errors": 0
	}
}

```

## listen

设置监听套接字并观察事件：

```
root@OpenWrt:~# ubus listen &
root@OpenWrt:~# ubus call network.interface.wan down
{ "network.interface": { "action": "ifdown", "interface": "wan" } }
root@OpenWrt:~# ubus call network.interface.wan up
{ "network.interface": { "action": "ifup", "interface": "wan" } }
{ "network.interface": { "action": "ifdown", "interface": "he" } }
{ "network.interface": { "action": "ifdown", "interface": "v6" } }
{ "network.interface": { "action": "ifup", "interface": "he" } }
{ "network.interface": { "action": "ifup", "interface": "v6" } }

```

## send

发送一个 Event：  
root@OpenWrt:~# ubus listen &

```
root@OpenWrt:~# ubus send foo '{ "bar": "baz" }'
{ "foo": { "bar": "baz" } }

```

# 通过 HTTP 访问 ubus（不细说）

uhttpd-mod-ubus 是 uhttpd 插件，允许使用 HTTP 协议控制 ubus。  
例如，uhttpd 就在 LuCI2 中使用。必须使用 post 方法将请求发送到 / ubus URL（URL 可以通过 ubus_prefix 更改）。此接口使用 jsonrpc v2.0。

如果安装了 uhttpd-mod-ubus，uhttpd 会自动配置并启用它，默认情况下在 /ubus，但您可以配置它。  
如果您想直接从 Web 客户端使用 / ubus，则需要指定 ubus_cors=1 选项。

如果您使用的是 Nginx，可以尝试 nginx-ubus-module

请参阅 Postman 集合，其中包含一些通过 HTTP 调用 UBUS 的示例

# 使用 ubus 配置系统的几个实例：

查询类：  
查询所有网卡状态：

```
ubus call network.device status

```

查询 eth0 网卡状态：

```
ubus call network.device status '{ "name": "eth0" }'

```

设置类：

控制 wan 是否接通：

```
ubus call network.interface.wan down
ubus call network.interface.wan up

```

控制 lan 是否接通：

```
ubus call network.interface.lan down
ubus call network.interface.lan up

```

获得防火墙所有 zone 规则：

```
ubus call uci get '{ "config": "firewall", "type": "zone" }'

```

获得防火墙所有 rule 规则：

```
ubus call uci get '{ "config": "firewall", "type": "rule" }'

```

获得防火墙 rule 规则的第 0 条：

```
ubus call uci get '{ "config": "firewall", "section": "@rule[0]" }'

```

有关 uci 操作, 详情请看：https://openwrt.org/docs/guide-developer/ubus/uci

# ubus 在 Ubuntu 上安装

按照这篇文章走:

ubuntu 编译 ubus 及相关依赖库  
https://blog.csdn.net/a29562268/article/details/89054122

安装完 ubus 后，也可以去安装一下 uci，就差一步了：  
https://blog.csdn.net/rainforest_c/article/details/70142987

安装好 ubus 后一开始用会有这个报错：  

![](https://img-blog.csdnimg.cn/12f00813559a4bae9e198e87c36fbc1e.png)

  
关于 ubuntu 添加共享库路径：

1.  将绝对路径写入 /etc/ld.so.conf
2.  sudo ldconfig

```
/usr/local/lib

```

![](https://img-blog.csdnimg.cn/41f625d423cb4ce8aa62708f4c07f586.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAd2hzdHVkaW8xMjM=,size_20,color_FFFFFF,t_70,g_se,x_16)

  
重启计算机或者重启终端就好使了。  

![](https://img-blog.csdnimg.cn/96fb454dc627480b9b42588960d76001.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAd2hzdHVkaW8xMjM=,size_20,color_FFFFFF,t_70,g_se,x_16)

  
先要启动 ubusd，ubus 才能工作：

ubus 启动 :

```
sudo ubusd

```

ubus traffic 监控:

```
sudo ubus monitor

```

# uci

```
root@Hiwooya:~# uci -h
uci: unrecognized option: h
Usage: uci [<options>] <command> [<arguments>]

Commands:
        batch
        export     [<config>]
        import     [<config>]
        changes    [<config>]
        commit     [<config>]
        add        <config> <section-type>
        add_list   <config>.<section>.<option>=<string>
        del_list   <config>.<section>.<option>=<string>
        show       [<config>[.<section>[.<option>]]]
        get        <config>.<section>[.<option>]
        set        <config>.<section>[.<option>]=<value>
        delete     <config>[.<section>[[.<option>][=<id>]]]
        rename     <config>.<section>[.<option>]=<name>
        revert     <config>[.<section>[.<option>]]
        reorder    <config>.<section>=<position>

Options:
        -c <path>  set the search path for config files (default: /etc/config)
        -d <str>   set the delimiter for list values in uci show
        -f <file>  use <file> as input instead of stdin
        -m         when importing, merge data into an existing package
        -n         name unnamed sections on export (default)
        -N         don't name unnamed sections
        -p <path>  add a search path for config change files
        -P <path>  add a search path for config change files and use as default
        -q         quiet mode (don't print error messages)
        -s         force strict mode (stop on parser errors, default)
        -S         disable strict mode
        -X         do not use extended syntax on 'show'

```

UCI 的配置文件全部存储在 / etc/config 目录下。

需要记住。使用 uci 设置后，必须调用, xxx 为 config 文件名

```
uci commit xxxx

```

例如：我们要让自己能 ping 到别人。但是让别人 ping 不通自己  
对于 ping 这个协议，进来的为 8（ping），出去的为 0(响应).  
由于 openwrt 的防火墙默认是全堵我们为了达到目的，需要禁止 8 进来  
所以我们需要在 firewall 文件中新增加这样的一条规则：

```
config rule 'myrule'
        option name 'ping'
        option proto 'icmp'
        option dest_port '8'
        option src '*'
        option target 'REJECT'

```

使用 uci 命令，则应当做如下操作

```
#增加节点
uci set firewall.myrule=rule
uci set firewall.myrule.name=ping
uci set firewall.myrule.proto=icmp
uci set firewall.myrule.dest_port=8
uci set firewall.myrule.target=REJECT
uci set firewall.myrule.src=*
uci commit firewall
/etc/init.d/firewall restart

```

例如：新增一个 wan 域设备 5g 到防火墙中：

```
config zone
        option name 'lan'
        list network 'lan'
        option input 'ACCEPT'
        option output 'ACCEPT'
        option forward 'ACCEPT'

config zone
        option name 'wan'
        option input 'REJECT'
        option output 'ACCEPT'
        option forward 'REJECT'
        option masq '1'
        option mtu_fix '1'
        list network 'wan'
        list network 'wan6'
        list network '4g'

```

```
root@Hiwooya:~# uci get firewall.@zone[1].network
wan wan6 4g
root@Hiwooya:~# uci add_list firewall.@zone[1].network=5g
root@Hiwooya:~# uci get firewall.@zone[1].network
wan wan6 4g 5g
#这里是想说明delete删不了list的值，需要用del_list
root@Hiwooya:~# uci delete firewall.@zone[1].network=5g
root@Hiwooya:~# uci get firewall.@zone[1].network
wan wan6 4g 5g
root@Hiwooya:~# uci del_list firewall.@zone[1].network=5g
root@Hiwooya:~# uci get firewall.@zone[1].network
wan wan6 4g

```

![](https://img-blog.csdnimg.cn/b3c9b4a30a00449687546676421ed8dc.png)