![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=796160&size=middle)

gladys *本帖最后由 gladys 于 2022-9-24 03:09 编辑*

**目录**

1. 写在前面

2. 选择 Ubuntu 作为路由器的理由

3. 设置方法及注意事项
3.1 固定网卡名称
3.2 网卡 / 网桥的基本配置
3.3 PPPoE 配置
3.4 DNS 配置
3.5 DHCP 配置
3.6 路由功能配置
3.7 IPv6 适配

4. 自用路由功能管理工具（待补充）
4.1 基础路由功能
4.2 双上游健康度检查及故障秒级切换
4.3 基于 MAC 地址的端主机访问控制
4.4 基于动态 NAT 的 IPv6 适配

5. 功能和性能评估（待补充）
5.1 主备上游故障转移与恢复
5.2 IPv6 适配情况
5.3 访问外网测速
5.4 内网设备间互联测速

6. 写在最后

7. 网关折腾过的其它有趣的东西（待补充）
7.1 自用防火墙管理工具
7.2 NTP 服务器
7.3 透明代理
7.4 内网穿透 / 内网 Web 服务管理
7.5 基于 EC20 模块的短信网关 / 4G 上网实现
7.6 自用消息推送服务
7.7 DNS 分流
7.8 SSH 配置优化
7.9 DDNS
7.10 流量控制
7.11 系统配置 sysctl 优化

8 附件
**1. 写在前面**
折腾过不少路由系统，从一开始的老毛子，到后来的各家定制固件，再到官方固件、自己编译固件，发现可玩性都不够高。还好自己有一点点折腾服务器的经验，于是干脆一步到位，使用自己常用的 Linux 发行版 Ubuntu 作为底层系统，通过非侵入、最小化修改的方式实现一套路由器解决方案
整理的内容可能有疏漏，欢迎大家交流补充，在此提前谢各位大佬轻喷之恩。
**2. 选择 Ubuntu 作为路由器的理由
本节内容可能引起您的不适，请谨慎阅读。
2.1 足够稳定可靠，性能不差**
目前自己使用过的 x86 软路由，从 J1900 开始，到现在的 J4125，性能都严重过剩，跑个 Ubuntu 服务器版，顺带跑个千兆网络乃至 2.5G 都没有一点问题。Ubuntu 作为使用较为广泛的 Linux 发行版，除了预装些私货以外，在几年 VPS 的使用经历来看没有什么大问题，运行比较稳定。
**2.2 配置管理标准化**
这个需求可能有的人没法理解。自己手里很多服务器，包括虚拟或者实体的都以 Debian 系为主，很多系统和软件配置，也都是依据 Debian 系的系统和软件进行编写维护的。使用完全不同的 Linux 发行版不利于配置的精细化管理和重用，尤其是需要配置的软件超过 20 个、配置文件数量超过 100 项以后。目前个人的配置文件不得不使用 git 进行仓库化和版本管理，并通过自己写的配置管理工具进行配置项的同步分发。
举个简单的例子。在我用 OpenWRT 的时候，OpenWRT 的系统服务还是采用 init.d，而 Debian 系的服务配置全部使用 systemd。这就意味着就服务配置文件一项而言，就需要多维护 20 个适用于 init.d 的系统服务配置文件用于适配 OpenWRT，且对应的配置管理工具需要增加逻辑以适配 OpenWRT，无疑大大增加了工作量。然而这只是一项，还有例如 OpenSSH 与 DropBox，opkg 与 dpkg 等许多例子。如此种种让配置管理维护成本激增，于是最终决定将网关系统也改为 Debian 系的操作系统。
通过操作系统的统一，路由器就可作为具有路由功能的服务器所对待，无需针对不同操作系统进行配置的适配，大大降低配置的创建、分发和维护成本。其他服务器上运行良好的服务也可以最少的改动移植到路由器中。
**2.3 可定制性高**
有的人用 OpenWRT 可能只是习惯在 UI 上点点点，觉得每次系统重置就重新点一遍就行了，大不了再记一下笔记。有的人可能稍微有心一些，定期把配置下载备份。然而这些是建立在对程序深度定制没要求的用户，但凡需求高一些的用户，这些方法都是行不通的。
一个很明显的例子，开发者提供的很多默认配置选项或功能存在各种问题，要么存在缺陷、或是不符合自己的要求，或是和其它程序存在冲突的情况。例如同时对 iptables 修改出现冲突的问题，三年前我用 OpenClash 的时候，它搞崩 OpenWRT 的 iptables 导致没法上网的情况我已经数不清了。要么放弃 OpenClash，要么就要自己动手丰衣足食。当然，这也不全是 OpenClash 的锅，因为作者也不知道用户到底在用什么可能与 OpenClash 不兼容的程序。
假设你决定继续用 OpenClash，那么只能尝试修改 OpenClash 的某些默认配置（例如其内置的一些运行脚本），以保证它的运行同你现在使用的程序兼容。如果你运气好，发现了 OpenClash 的问题，添加了相关逻辑修复了问题，然后希望给作者发个 PR。结果作者可能会拒绝掉，理由是这个情况太小众。但对你不是啊，因为和它冲突的软件虽然大家不用，但你用的非常频繁。那 OpenClash 还要自动更新吗？如果要的话，你的修改可能会被覆盖掉；否则，没法及时获得最新的 bug 修复，可能会出现其他问题，而且手动更新也很麻烦。那只有自己在每次自动更新以后覆盖 patch 了。也许一两个程序、一两个文件的 patch 手动还能解决，但是如果 patch 文件太多呢？如果几个，甚至十几个软件都要这样呢？问题就很大了。
**3. 设置方法及注意事项
3.1 固定网卡名称
3.1.1 设置方法**
1）        将配置文件（custom-devices.rules）放置于 / etc/udev/rules.d / 目录下；
2）        ATTR{address} 后面的 MAC 地址修改为自己设备对应的网卡 MAC 地址（可通过 ifconfig -a 命令获得）‘’
3）        对应的 NAME 后面修改为自己喜欢的网卡别名；
4）        配置文件示例在下面给出。

8. 

9. 

  # Located in /etc/udev/rules.d/custom-devices.rules

10. 

  # Network Interface Card

11. 

  # 格式：SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="（替换为 MAC 地址）", ATTR{dev_id}=="0x0", ATTR{type}=="1", NAME="（替换的网卡名称）"

12. 

  # 举例：将 MAC 地址为 11:22:33:44:55:66:77 的网卡名称改为 eth1，每行设置一个网卡

13. SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="11:22:33:44:55:66:77", ATTR{dev_id}=="0x0", ATTR{type}=="1", NAME="eth1"

*复制代码*

**3.1.2 补充说明**
之前手里有一台 3965U，安装系统后 6 个网卡的名称出现了 enp*s0 和 eth * 混用的情况，因此通过 udev 将所有网卡统一名称。非必需步骤，强迫症患者福音。
**3.2 网卡 / 网桥的基本配置
3.2.1 设置方法**
1）        检查当前系统下是否存在 / etc/netplan / 目录。若无，需运行命令 apt install -y netplan.io 安装 netplan；
2）        将配置文件（00-installer-config.yaml.yaml）放置于 / etc/netplan / 目录下，若有同名文件，替换之；
3）        需要使用的网卡及名称根据实际情况进行替换，具体替换的方式通过配置文件内注释的方式予以说明；
4）        配置文件示例在下面给出。

14. 

15. 

  # Located in /etc/netplan/00-installer-config.yaml

16. 

  # To config network interfaces

17. 

  # Run "sudo netplan generate && sudo netplan apply" after editing

18. 

19. network:

20.   version: 2

21.   renderer: networkd

22.   ethernets:

23.     enp1s0: # 网卡 enp1s0，作为 LAN 使用

24.       dhcp4: false # 禁用 DHCPv4

25.       dhcp6: false # 禁用 DHCPv6

26.       optional: true # 设置为非必须，防止 Ubuntu 的网络检查造成系统启动延迟

27.     enp2s0: # 网卡 enp2s0，作为 LAN 使用，配置同网卡 enp1s0 一致

28.       dhcp4: false

29.       dhcp6: false

30.       optional: true

31.     enp4s0: # 网卡 enp4s0，作为 WAN 使用

32.       dhcp4: true # 启用 DHCPv4

33.       dhcp6: true # 启用 DHCPv6

34.       optional: true # 设置为非必须，防止 Ubuntu 的网络检查造成系统启动延迟

35.       accept-ra: true # 接受 Router Advertisement，IPv6 适配相关的配置

36.   bridges:

37.     br_lan: # 将网卡 enp1s0 和网卡 enp2s0 组成网桥，网桥名称为 br_lan

38.       interfaces: # 包含的所有网卡名称

39.         - "enp1s0"

40.         - "enp2s0"

41.       addresses: # 固定网卡所拥有的内网 IP 地址段

42.         - 192.168.2.1/24

43.         - fc00:192:168:2::1/64

44.       dhcp4: false # 禁用 DHCPv4

45.       dhcp6: false # 禁用 DHCPv6

46.       nameservers: # 设置默认 DNS 服务器，非必须

47.         addresses:

48.           - 223.5.5.5

49.           - 119.29.29.29

50.           # - "2400:3200::1"

51.       parameters:

52.         stp: true # 启用生成树协议，防止环路

53.         forward-delay: 4

54.       optional: true # 设置为非必须，防止 Ubuntu 的网络检查造成系统启动延迟

*复制代码*

**3.2.2 补充说明**
这里使用 netplan 进行网卡配置，其通过 yaml 承载配置信息，清晰易读。一般而言，netplan 会预装至 Ubuntu 系统中；否则可通过命令 apt install -y netplan.io 安装（需联网）。netplan 配置文件放置于 / etc/netplan / 中，一般只需要替换默认的 00-installer-config.yaml 即可。本节所给出的 netplan 的配置示例中，底层的网络配置渲染器可采用 Systemd-networkd（networkd），也可采用 NetworkManager，具体可参考 netplan 的使用手册。示例配置中的其它内容将通过注释的形式予以说明。
需要注意的是，该配置作为路由器的基础配置，绝对不能出现错误，否则将可能无法通过 SSH 连接至路由器中。配置完成后通过命令：sudo netplan generate && sudo netplan apply 生成与应用网络配置。
当该配置完成后，你的路由器就具备了基础的网络功能。只要安装了 SSH，就可以在其他设备上对路由器进行操作，而不需要连接键盘和显示器至路由器中。SSH 的配置优化将在第 7 节予以介绍。
**3.3 PPPoE 配置
3.3.1 设置方法**
1）        通过运行命令 apt install -y ppp 以安装 ppp；
2）        将配置文件（pppoe_dial）放置于 / etc/ppp/peers 目录下；
3）        配置文件中，user "**" 和 password "**" 改成你的 PPPoE 上网账号和密码；
4）        将对应的系统服务配置文件 pppoe_dial.service 放置于 / etc/systemd/system 中；
5）        运行 systemctl daemon-reload 以注册服务；
6）        运行 systemctl enable pppoe_dial 即令服务开机启动（自动拨号）；
7）        运行 systemctl start pppoe_dial 立即拨号

55. 

56. 

  # Located in /etc/ppp/peers/pppoe_dial

57. 

  # Print debug info

58. #debug

59. logfile /var/log/pppoe_dial/run.log

60. 

61. 

  # interface name

62. ifname pppoe_dial # 虚拟网卡名称设置为 pppoe_dial

63. 

64. 

  # Keep pppd in terminal

65. nodetach

66. 

67. 

  # Set default route

68. defaultroute

69. 

70. 

  # Do not set PPP compression

71. ipcp-accept-local

72. ipcp-accept-remote

73. local

74. 

75. 

  # Set PPPoE used interface

76. plugin pppoe.so enp4s0

77. 

  # Username & password

78. user "******" # 你的上网用户名

79. password "******" # 你的上网密码

80. noauth

81. 

  # Hide password when print connect info

82. hide-password

83. 

84. 

  # 启用 IPv6

85. 

  # Use IPv6

86. +ipv6

87. ipv6cp-use-ipaddr

88. ipv6cp-accept-local

89. ipv6cp-accept-remote

90. ipv6cp-max-failure 100

91. ipv6cp-restart 2

92. 

93. 

  # Set default route v6

94. defaultroute6

95. 

96. usepeerdns

97. 

98. 

  # Conn check

99. lcp-echo-interval 60 # Ping sending interval

100. lcp-echo-failure 10 # Times of ping failure tolerance

101. 

102. 

  # Reconnect

103. persist

104. maxfail 10

105. holdoff 1

106. 

107. 

  # PPPoE compliant settings.

108. noaccomp

109. default-asyncmap

110. mtu 1452

*复制代码*

111. 

112. 

  # Located in /etc/systemd/system/pppoe_dial.service

113. [Unit]

114. Description=PPPoE auto dial

115. After=systemd-networkd.service

116. StartLimitBurst=5

117. StartLimitIntervalSec=120

118. 

119. [Service]

120. User=root

121. ExecStartPre=-/bin/sh -ec '\

122.     /usr/bin/mkdir -p /var/log/pppoe_dial'

123. ExecStart=pppd call pppoe_dial

124. ExecStop=poff pppoe_dial

125. Restart=always

126. RestartSec=10s

127. 

128. [Install]

129. WantedBy=multi-user.target

*复制代码*

**3.3.2 补充说明**
如果上网环境为 PPPoE 上网，那么需要进行这一步配置；如果你的上网环境为 DHCP，那么当插上网线至 WAN 口时即可正常上网，无需进行这一步配置。
**3.4 DNS 配置
3.4.1 配置示例**

130. 

131. bind-tcp [::]:53

132. 

133. 

  # 注意，当网卡上有多个 IP 地址时，绑定 UDP 套接字需要明确 IP，否则仅网卡第一个 IP 生效

134. bind 127.0.0.1:53

135. bind 192.168.2.1:53

136. bind [fc00:192:168:2::1]:53

137. 

138. tcp-idle-time 120

139. cache-size 4096

140. cache-persist yes

141. cache-file /tmp/smartdns.cache

142. prefetch-domain yes

143. serve-expired yes

144. serve-expired-ttl 1800

145. serve-expired-reply-ttl 1

146. speed-check-mode tcp:80,ping,tcp:443

147. dualstack-ip-selection yes

148. rr-ttl 300

149. rr-ttl-min 60

150. rr-ttl-max 86400

151. max-reply-ip-num 2

152. response-mode first-ping

153. log-level notice

154. log-file /var/log/smartdns.log

155. 

156. dnsmasq-lease-file /var/lib/misc/dnsmasq.leases

157. 

158. 

  # 就个人使用环境而言，DoT 比 DoH 稳不少

159. 

  # AliDNS

160. server-tls 223.5.5.5 -group bootstrap

161. server-tls 223.6.6.6 -group bootstrap

162. 

  # DNSPod

163. server-tls 1.12.12.12 -group bootstrap

164. server-tls 120.53.53.53 -group bootstrap

165. server-tls dot.pub

166. server-tls dns.alidns.com

167. 

168. domain-rules /dns.alidns.com/ -speed-check-mode none -nameserver bootstrap

169. domain-rules /doh.pub/ -speed-check-mode none -nameserver bootstrap

170. domain-rules /dot.pub/ -speed-check-mode none -nameserver bootstrap

*复制代码*

**3.4.2 补充说明**
这里采用 SmartDNS 接管设备全局 DNS。这里仅给出 SmartDNS 的配置示例（smartdns.conf），不给出具体的安装方法。你可以使用自己喜欢的方式安装 SmartDNS，例如在 [https://github.com/pymumu/smartdns](https://github.com/pymumu/smartdns) 中使用作者所推荐的标准 Linux 系统的安装方式。关于程序手动安装与管理的方式，将在第 7 节中予以简要介绍。另外，关于 SmartDNS 配置的资料也较为丰富，你也可以使用一些其他网友提供的配置文件。
安装完成后，需要将本机 DNS 解析指向 SmartDNS，你可以使用 resolvconf 进行设置。这里提供一个取巧的方法：使用 root 删除 / etc/resolv.conf，重新新建该文件、修改内容（例如：nameserver 127.0.0.1）并保存，之后通过 chattr +i /etc/resolv.conf 命令使其成为不可修改文件。后续只要保证 SmartDNS 监听套接字不变（UDP 127.0.0.1:53）即可保证设备 DNS 服务正常运行。
需要提醒的是，这里 SmartDNS 作为基础的上游 DNS 服务，稳定可靠是第一要求。因此不推荐配置过于复杂的分流策略，建议仅配置可靠的上游以实现 IP 优选、解析加密等基本需求即可。复杂的功能可交给更为功能更丰富的 DNS 工具实现，例如 mosdns 等。
注意，若使用 SmartDNS 接管系统 DNS 解析，需禁用系统自带的 systmed-resolved，具体方法为：
运行命令 systemctl stop systemd-resolved && systemctl disable systemd-resolved
**3.5 DHCP 配置
3.5.1 设置方法**
1）        运行命令 apt install -y dnsmasq 以安装 dnsmasq；
2）        将配置文件（dhcp.conf）放置于 / etc/dnsmasq.d 目录下；
3）        内网 IPv4 和 IPv6 网段配置可根据实际需要修改，具体参考配置文件示例中的注释说明；
4）        配置文件示例在下面给出。

171. 

172. 

  # located in /etc/dnsmasq.d/dhcp.conf

173. 

  # Set the interface on which dnsmasq operates.

174. 

  # If not set, all the interfaces is used.

175. interface=br_lan

176. 

177. 

  # To disable dnsmasq's DNS server functionality.

178. port=0

179. 

180. 

  # To enable dnsmasq's DHCP server functionality.

181. 

  # 设置可分配的 IPv4 段为 192.168.2.1/24，其中 192.168.2.100 ~ 192.168.2.254 用于随机分配，其余 IP 用于静态分配

182. dhcp-range=192.168.2.100,192.168.2.254,255.255.255.0,24h

183. 

  # Set gateway as Router.

184. dhcp-option=3,192.168.2.1

185. 

  # Set DNS server as Router.

186. dhcp-option=6,192.168.2.1

187. 

  # Set NTP server as Router

188. dhcp-option=42,192.168.2.1

189. 

190. 

  # DHCPv6 config

191. 

  # 设置有状态分配的 IPv6 地址段为 fc00:192:168:2::1/120，同 IPv4 保持一致

192. dhcp-range=fc00:192:168:2::1,fc00:192:168:2::ff,24h

193. 

  # 设置无状态分配的 IPv6 地址段为 fc00:192:168:2::1/64，兼容大部分情况

194. dhcp-range=fc00:192:168:2::,slaac

195. dhcp-option=option6:dns-server,[fc00:192:168:2::1]

196. dhcp-option=option6:ntp-server,[fc00:192:168:2::1]

197. enable-ra

198. dhcp-authoritative

199. 

200. 

  # Set static IPs of other PCs and the Router.

201. 

  # 指定静态 IP 示例：

202. dhcp-host=00:11:22:33:44:55,ESXi,192.168.2.2,[fc00:192:168:2::2],infinite

203. 

204. 

  # Logging.

205. log-facility=/var/log/dnsmasq/dnsmasq.log   # logfile path.

206. log-async=25

207. log-queries # log queries.

208. log-dhcp    # log dhcp related messages.

*复制代码*

**3.5.2 补充说明**
这一步的目的在于实现路由器向局域网内设备下发 IP 地址的功能，包括网关、DNS 服务器、IP 范围、NTP 服务器、静态 IP 等的设置。
**3.6 路由功能配置
3.6.1 设置方法**
1）        将配置文件（99-forward.conf）放置于 / etc/sysctl.d 目录下；
2）        运行命令 sysctl -p /etc/sysctl.d/99-forward.conf，以启用路由器的转发功能；
3）        将配置文件（99-custom-modules.conf）放置于 / etc/modules-load.d / 目录下，
4）        运行命令 insmod nf_conntrack，以启用链接跟踪模块；
5）        运行命令 apt install -y iptables-persistent，安装防火墙配置持久化程序；
6）        运行 firewall-set.sh 中的命令以设置防火墙 NAT 转发，需以 root 身份运行该脚本；
7）        运行 netfilter-persistent save 以持久化步骤 6）中所设置的防火墙命令；
8）        上文中所提到的所有配置文件示例均在下面给出。

209. 

210. 

  # Located in /etc/sysctl.d/99-forward.conf

211. net.ipv4.ip_forward=1

212. net.ipv4.conf.all.forwarding=1

213. net.ipv4.conf.default.forwarding=1

214. net.ipv4.conf.all.route_localnet=1

215. 

216. net.ipv6.conf.all.forwarding=1

217. net.ipv6.conf.default.forwarding=1

*复制代码*

218. 

219. 

  # Located in /etc/modules-load.d/custom-modules.conf

220. nf_conntrack

*复制代码*

221. 

222. #!/bin/bash

223. 

  # firewall-set.sh

224. 

225. 

  # 根据你的 WAN 网卡名称对应修改！！！

226. WAN_NAME='pppoe_dial'

227. 

228. 

  # IPv4 设置

229. iptables -t nat -N mt_rtr_4_n_rtr

230. iptables -t nat -A POSTROUTING -j mt_rtr_4_n_rtr

231. iptables -t nat -A mt_rtr_4_n_rtr -o ${WAN_NAME} -j MASQUERADE # 添加路由到作为 WAN 的网卡的自动源地址转换规则

232. 

233. 

  # 添加 IPv4 转发优化规则

234. iptables -t mangle -N mt_rtr_4_m_rtr

235. iptables -t mangle -A FORWARD -j mt_rtr_4_m_rtr

236. iptables -t mangle -A mt_rtr_4_m_rtr -o ${WAN_NAME} -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu # 针对 PPPoE 链接的优化

237. iptables -t mangle -A mt_rtr_4_m_rtr -m state --state RELATED,ESTABLISHED -j ACCEPT # 允许已建立连接的数据包直接通过

238. iptables -t mangle -A mt_rtr_4_m_rtr -m conntrack --ctstate INVALID -j DROP

239. iptables -t mangle -A mt_rtr_4_m_rtr -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j DROP

240. iptables -t mangle -A mt_rtr_4_m_rtr -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP

241. iptables -t mangle -A mt_rtr_4_m_rtr -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP

242. iptables -t mangle -A mt_rtr_4_m_rtr -i br_lan -o ${WAN_NAME} -j ACCEPT

243. 

244. 

  # IPv6 NAT 设置，与 IPv4 基本一致

245. ip6tables -t nat -N mt_rtr_6_n_rtr

246. ip6tables -t nat -A POSTROUTING -j mt_rtr_6_n_rtr

247. ip6tables -t nat -A mt_rtr_6_n_rtr -o ${WAN_NAME} -j MASQUERADE # 添加路由到作为 WAN 的网卡的自动源地址转换规则

248. 

249. 

  # 添加 IPv6 转发优化规则

250. ip6tables -t mangle -N mt_rtr_6_m_rtr

251. ip6tables -t mangle -A FORWARD -j mt_rtr_6_m_rtr

252. ip6tables -t mangle -A mt_rtr_6_m_rtr -o ${WAN_NAME} -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

253. ip6tables -t mangle -A mt_rtr_6_m_rtr -m state --state RELATED,ESTABLISHED -j ACCEPT

254. ip6tables -t mangle -A mt_rtr_6_m_rtr -m conntrack --ctstate INVALID -j DROP

255. ip6tables -t mangle -A mt_rtr_6_m_rtr -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j DROP

256. ip6tables -t mangle -A mt_rtr_6_m_rtr -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP

257. ip6tables -t mangle -A mt_rtr_6_m_rtr -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP

258. ip6tables -t mangle -A mt_rtr_6_m_rtr -i br_lan -o ${WAN_NAME} -j ACCEPT

*复制代码*

**3.6.2 补充说明**
这里对路由的基本知识进行简要的介绍，以帮助读者理解每项防火墙配置的目的，**不想看可以跳过此部分**。基本知识介绍的内容纯靠回忆手敲，可能有些许错误，还望大神们轻喷。
路由动作究其根本，就是路由器从一个端口接收到数据包后，决定数据包应当转发至的端口过程。与交换动作不同，路由的转发动作的决定依据是路由表。系统内核网络栈通过将数据包的 IP 地址与路由表中 IP 段进行匹配（最长前缀匹配）以查找到最适合的路由表表项，进而决定数据包的转发出口。因此，路由表的配置是必须的，否则网络内设备无法通外网通信。而 Ubuntu 默认不开启路由转发功能，因此需通过 sysctl 开启系统的路由转发功能。
其次，路由器还有一个重要的功能：网络地址转换（NAT）。面对公网 IP 地址枯竭的问题，我们使用 NAT 技术以实现 IP 地址的有效利用。NAT 一般分为三种：静态 NAT、动态 NAT 和端口多路复用（PAT）。而我们常说的 NAT1~4 均为 PAT。
对于由 iptables 所实现的 NAT 来说，比较重要的概念有两项：SNAT 和 DNAT。SNAT 的含义为 “源地址转换”，指的是内网发出的、源地址为保留 IP 的数据包在路由匹配完成并进入网卡 A 时，将源地址替换为对应网卡 A 上的一个外部 IP 地址（不一定是公网 IP，想想看什么是 NAT444）；这样就实现了仅有保留 IP 同公网 IP 之间的通信。其中较为特殊的 MASQUERADE 功能含义在于，源 IP 地址（内网保留地址）所要被替换的外部 IP 地址由系统自动选择。DNAT 为 “目的地址转换”，其作用在于实现外网对不具有公网 IP 的内部设备的访问。在开放内部服务时较为有用，而不是本文所述路由器所必需的配置，故此处不做展开说明。
**3.7 IPv6 适配**
如果以上的配置全部成功，你的路由器下的设备应该能通过 NAT（PAT）的方式连接 IPv6 网络。如果你希望每个设备都有一个独立的 IPv6 地址，可通过 dhcp6c 与 dnsmasq 配合即可实现 IPv6 地址的分配。这里不详细展开说明的原因在于，本人采用了动态 NAT 的思路实现 IPv6 地址的分配，具体将在第 4 节进行介绍。
这里推荐一篇文章：[https://github.com/torhve/blag/b ... smasq-for-dhcpv6.md](https://github.com/torhve/blag/blob/master/using-dnsmasq-for-dhcpv6.md)。英文写的，但用翻译工具翻译后阅读也不会有障碍。它介绍了使用 dhcp6c 与 dnsmasq 配合实现 IPv6 地址下发的配置方式，仅供参考。
**4. 自用路由功能管理工具（待补充）**
在上文 3.6 节所述的防火墙设置虽然可以保证路由功能正常，但在实际的使用环境中肯定是不方便的，因此本人写了个小工具用来自动完成防火墙设置。具体包括四个基本功能，将在下文进行详细介绍。这个工具目前仅个人在使用，可能还会有很多 bug，不太推荐大家用（如果有不介意的可以试一试，后续会放出来）
4.1 基础路由功能
4.2 双上游健康度检查及故障秒级切换
4.3 基于 MAC 地址的端主机访问控制
4.4 基于动态 NAT 的 IPv6 适配
**5. 功能和性能评估（待补充）**
5.1 主备上游故障转移与恢复
5.2 IPv6 适配情况
5.3 访问外网测速
5.4 内网设备间互联测速
**6. 写在最后**
本文作为长久以来基于 Ubuntu 的路由器折腾记录的总结，希望能为有相关需求或部分需求的用户提供一点小小的参考。后续将视情况更新一些在 Ubuntu 路由器上折腾过的小东西。
**7. 网关折腾过的其它有趣的东西（待补充）**
7.1 自用防火墙管理工具
7.2 NTP 服务器
7.3 透明代理
7.4 内网穿透 / 内网 Web 服务管理
7.5 基于 EC20 模块的短信网关 / 4G 上网实现
7.6 自用消息推送服务
7.7 DNS 分流
7.8 SSH 配置优化
7.9 DDNS
7.10 流量控制
7.11 系统配置 sysctl 优化
**8. 附件**

259. 配置文件和脚本

#### 本帖隐藏的内容

![](https://www.right.com.cn/forum/static/image/filetype/zip.gif)

[1. 配置文件和脚本. zip](forum.php?mod=attachment&aid=NTc1MjUwfDc5Mzc0NGI1fDE2NzcyMDc3MjZ8Mjk5MDQxfDgyNTU0NDg%3D) *(6.64 KB, 下载次数: 34)*

2022-9-24 03:04 上传

点击文件名下载附件

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=64756&size=middle)

jackyxiongcn 看看有什么

jackyxiongcn 看看有什么

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=420172&size=middle)

runking 好文章，谢谢分享！

runking 好文章，谢谢分享！

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=40171&size=middle)

幽灵道人 谢谢分享。。。。。。。。。。

幽灵道人 谢谢分享。。。。。。。。。。

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=637995&size=middle)

wmf1029 好文章，谢谢分享！

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=19666&size=middle)

cjf 感觉好高大上的样子，问下这个还能当系统用吗？能再加个 NAS 功能吗？

cjf 感觉好高大上的样子，问下这个还能当系统用吗？能再加个 NAS 功能吗？

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=737065&size=middle)

nmgmax 学习学习！！！

nmgmax 学习学习！！！

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=691981&size=middle)

Moto88 谢谢分享

Moto88 谢谢分享

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=763004&size=middle)

798388 感谢大礼分享

798388 感谢大礼分享

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=589099&size=middle)

jwpia 谢谢楼主的分享

![](https://www.right.com.cn/forum/static/image/smiley/default/lol.gif)

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=593357&size=middle)

tzmag 谢谢分享

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=362007&size=middle)

a5276815 大神都是这么的秀。。。。

a5276815 大神都是这么的秀。。。。

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=659889&size=middle)

yz8303 谢谢分享。。。。。。。。。。

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=796160&size=middle)

gladys

[cjf 发表于 2022-9-24 15:33
](https://www.right.com.cn/forum/forum.php?mod=redirect&goto=findpost&pid=17529110&ptid=8255448)感觉好高大上的样子，问下这个还能当系统用吗？能再加个 NAS 功能吗？

可以，最基本 NAS 功能用 Samba server 就可以实现（[https://ubuntu.com/tutorials/ins ... re-samba#1-overview](https://ubuntu.com/tutorials/install-and-configure-samba#1-overview)），高级一点可以搞 ZFS（实现安全文件系统），BT 下载之类的拉个 Docker 就可以（[https://hub.docker.com/r/linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission)）

可以，最基本 NAS 功能用 Samba server 就可以实现（[https://ubuntu.com/tutorials/ins ... re-samba#1-overview](https://ubuntu.com/tutorials/install-and-configure-samba#1-overview)），高级一点可以搞 ZFS（实现安全文件系统），BT 下载之类的拉个 Docker 就可以（[https://hub.docker.com/r/linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission)）

可以，最基本 NAS 功能用 Samba server 就可以实现（[https://ubuntu.com/tutorials/ins ... re-samba#1-overview](https://ubuntu.com/tutorials/install-and-configure-samba#1-overview)），高级一点可以搞 ZFS（实现安全文件系统），BT 下载之类的拉个 Docker 就可以（[https://hub.docker.com/r/linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission)）

可以，最基本 NAS 功能用 Samba server 就可以实现（[https://ubuntu.com/tutorials/ins ... re-samba#1-overview](https://ubuntu.com/tutorials/install-and-configure-samba#1-overview)），高级一点可以搞 ZFS（实现安全文件系统），BT 下载之类的拉个 Docker 就可以（[https://hub.docker.com/r/linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission)）

可以，最基本 NAS 功能用 Samba server 就可以实现（[https://ubuntu.com/tutorials/ins ... re-samba#1-overview](https://ubuntu.com/tutorials/install-and-configure-samba#1-overview)），高级一点可以搞 ZFS（实现安全文件系统），BT 下载之类的拉个 Docker 就可以（[https://hub.docker.com/r/linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission)）

可以，最基本 NAS 功能用 Samba server 就可以实现（[https://ubuntu.com/tutorials/ins ... re-samba#1-overview](https://ubuntu.com/tutorials/install-and-configure-samba#1-overview)），高级一点可以搞 ZFS（实现安全文件系统），BT 下载之类的拉个 Docker 就可以（[https://hub.docker.com/r/linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission)）

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=704702&size=middle)

雪韵凌寒 谢谢楼主热心分享

雪韵凌寒 谢谢楼主热心分享

![](https://www.right.com.cn/forum/uc_server/avatar.php?uid=299041&size=middle&ts=1)

z055795694 RE: Ubuntu 软路由全套折腾指南（持续更新） [修改]

