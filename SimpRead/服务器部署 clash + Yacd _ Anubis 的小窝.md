---
url: https://anubis.cafe/44568f9.html
title: 服务器部署 clash + Yacd _ Anubis 的小窝
date: 2023-09-08 12:19:44
tag: 
banner: "https://images.unsplash.com/photo-1691228397653-41d0662abeb6?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjk0MTQ2Nzc3fA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
banner_icon: 🔖
---
## [](#命令行版 "命令行版")命令行版

这是为了没有 gui 界面的 linux 服务器所写的教程，因此全部使用命令行。

### [](#源码安装 "源码安装")源码安装

#### [](#安装 "安装")安装

#### [](#选择版本 "选择版本")选择版本

使用 `uname -m` 在 [https://github.com/Dreamacro/clash/releases](https://github.com/Dreamacro/clash/releases) 中选择查看对应的服务器版本

如

![](https://img.anubis.cafe/202302111538232.webp)

![](https://img.anubis.cafe/202302111538851.webp)

根据系统架构选择合适的版本下载，自己改链接

bash

```
wget https://github.com/Dreamacro/clash/releases/download/v1.13.0/clash-linux-armv7-v1.13.0.gz

```

建议挂个镜像加速链接，可以就用 [gitclone](https://www.gitclone.com/)

安装 clash

bash

```
//注意自己改文件名
sudo gzip -d clash-linux-armv7-v1.13.0
sudo mkdir /opt/clash
sudo mv clash-linux-armv7-v1.13.0 /opt/clash/clash
cd /opt/clash
chmod +x /opt/clash/clash

```

bash

```
//下载配置信息
sudo mkdir -p ~/.config/clash && cd ~/.config/clash
sudo wget -O config.yaml [订阅链接]
sudo wget -O Country.mmdb http://www.sub-speeder.com/client-download/Country.mmdb

```

clash 的配置文件在`~/.config/clash/config.yaml`，打开后添加基本配置（如果有就不用添加了）

none

```
port: 7890
socks-port: 7891
allow-lan: true
mode: Rule
log-level: info
secert: 123456 // 增加这一行, 如果你希望你的clash web要密码访问可以在这块配置密码, 如果不需要直接注释掉即可
#此处必须是0.0.0.0 才可以通过局域网访问，也就是说要想通过web管理，必须填0.0.0.0
external-controller: 0.0.0.0:9090

```

启动

none

```
cd /opt/clash
./clash -d ~/.config/clash .

```

在本地测试服务器端口是否可达，如果访问不通，排查云主机是否开放了端口。

如果在配置文件中使用的是 `mixed-port`，则 socks5 和 http 代理共用 7980 端口，代理地址都为

none

```
username:passwd@[服务器IP]:7890

```

#### [](#设置系统代理 "设置系统代理")设置系统代理

bash

```
sudo nano /etc/environment

```

加入以下三行

bash

```
export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"
export no_proxy="localhost, 127.0.0.1"

```

修改 sudo 文件

在此处加入

![](https://img.anubis.cafe/202301170106743.webp)

bash

```
Defaults env_keep+="http_proxy https_proxy no_proxy"

```

重启

#### [](#设置clash开机启动 "设置clash开机启动")设置 clash 开机启动

将配置文件移动到 / etc

bash

```
sudo mv ~/.config/clash /etc

```

添加启动信息

bash

```
sudo nano /etc/systemd/system/clash.service

```

输入以下内容，clash -d 的意思是指定配置文件路径，这里已经改成了 / etc/clash

text

```
[Unit]
Description=clash daemon

[Service]
Type=simple
User=root
ExecStart=/opt/clash/clash -d /etc/clash/
Restart=on-failure

[Install]
WantedBy=multi-user.target

```

重新加载 systemctl daemon

bash

```
sudo systemctl daemon-reload

```

启动 Clash

bash

```
sudo systemctl start clash.service

```

设置 Clash 开机自启动

bash

```
sudo systemctl enable clash.service

```

#### [](#Clash相关的管理命令 "Clash相关的管理命令")Clash 相关的管理命令

bash

```
sudo systemctl start clash.service

sudo systemctl restart clash.service

sudo systemctl status clash.service

unset http_proxy
unset https_proxy

cd

```

**配置定时更新订阅：**

先撸个脚本，别忘了设可执行权限

text

```
#!/bin/bash

# 设置clash路径
clash_path="/opt/clash"

# 停止clash
systemctl stop clash.service

# 取消代理
unset https_proxy

# 如果配置文件存在，备份后下载，如果不存在，直接下载
if [ -e $clash_path/config.yaml ]; then
	mv $clash_path/config.yaml $clash_path/configbackup.yaml
	wget -O $clash_path/config.yaml "[你的订阅链接]"
else
	wget -O $clash_path/config.yaml "[你的订阅链接]"
fi

# 重启clash
systemctl restart clash.service

# 重设代理
export https_proxy="http://127.0.0.1:7890"

```

设置定时任务：

填入以下内容

text

```
//每月1号和15号的4点30分开始更新
30 4 1,15 * * sh [脚本目录]/[脚本名称]

```

重启 crontab，使配置生效

text

```
sudo systemctl restart cron.service

```

查看代理是否正常工作：

### [](#Cash-Web-面板（Yacd） "Cash Web 面板（Yacd）")Cash Web 面板（Yacd）

当然这个有在线版，其实在线版就够用了 [http://clash.razord.top/#/proxies](http://clash.razord.top/#/proxies)

Yach 是 Clash Web 版的面板，可以查看服务状态，上传下载的流量统计信息。

bash

```
sudo docker run -p 1234:80 -d --name yacd ghcr.io/haishanh/yacd:master
sudo ufw allow 7890

```

访问 `http://[服务器IP]:1234` 进入页面，填写 Clash 地址，本例为 `http://[服务器IP]:9090`，secret 填写 `config.yaml` 中配置的 secret 值，添加后点击新增的链接进入页面。

![](https://images.yasking.org/technology/1671017959/04.jpg)

**yacd panel**

clash 及 yacd 的部署使用到这里就记录完成了。

### [](#ShellClash "ShellClash")ShellClash

#### [](#功能简介： "功能简介：")功能简介：

*   通过管理脚本在 Shell 环境下便捷使用 [Clash](https://github.com/Dreamacro/clash)
*   支持在 Shell 环境下管理 [Clash 各种功能](https://lancellc.gitbook.io/clash)
*   支持在线导入 [Clash](https://github.com/Dreamacro/clash) 支持的分享、订阅及配置链接
*   支持配置定时任务，支持配置文件定时更新
*   支持在线安装及使用本地网页面板管理内置规则
*   支持路由模式、本机模式等多种模式切换
*   支持在线更新

#### [](#在线安装： "在线安装：")在线安装：

（**如无法连接或出现 SSL 连接错误，请尝试更换各种不同的安装源！**）

~ **标准 Linux 设备安装：**

none

```
sudo -i #切换到root用户，如果需要密码，请输入密码
bash #如已处于bash环境可跳过
export url='https://fastly.jsdelivr.net/gh/juewuy/ShellClash@master' && wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh  && bash /tmp/install.sh && source /etc/profile &> /dev/null

```

或者

none

```
sudo -i #切换到root用户，如果需要密码，请输入密码
bash #如已处于bash环境可跳过
export url='https://gh.jwsc.eu.org/master' && bash -c "$(curl -kfsSl $url/install.sh)" && source /etc/profile &> /dev/null

```

~ **路由设备使用 curl 安装**：

none

```
#GitHub源(可能需要代理)
export url='https://raw.githubusercontent.com/juewuy/ShellClash/master' && sh -c "$(curl -kfsSl $url/install.sh)" && source /etc/profile &> /dev/null

```

或者

none

```
#jsDelivrCDN源
export url='https://fastly.jsdelivr.net/gh/juewuy/ShellClash@master' && sh -c "$(curl -kfsSl $url/install.sh)" && source /etc/profile &> /dev/null

```

或者

none

```
#作者私人源
export url='https://gh.jwsc.eu.org/master' && sh -c "$(curl -kfsSl $url/install.sh)" && source /etc/profile &> /dev/null

```

~ **路由设备使用 wget 安装**：

none

```
#GitHub源(可能需要代理)
export url='https://raw.githubusercontent.com/juewuy/ShellClash/master' && wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh  && sh /tmp/install.sh && source /etc/profile &> /dev/null

```

或者

none

```
#jsDelivrCDN源
export url='https://fastly.jsdelivr.net/gh/juewuy/ShellClash@master' && wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh  && sh /tmp/install.sh && source /etc/profile &> /dev/null

```

~ **老旧设备使用低版本 wge 安装**：

none

```
#作者私人http内测源
export url='http://t.jwsc.eu.org' && wget -q -O /tmp/install.sh $url/install.sh  && sh /tmp/install.sh && source /etc/profile &> /dev/null

```

~**DOCKER 环境下安装：**

请参考 [ShellClash_docker 一键脚本和镜像](https://github.com/echvoyager/shellclash_docker)

#### [](#本地安装： "本地安装：")**本地安装：**

如使用在线安装出现问题，请参考：[本地安装 ShellClash 的教程 | Juewuy’s Blog](https://juewuy.github.io/bdaz) 使用本地安装！

#### [](#使用脚本： "使用脚本：")使用脚本：

安装完成管理脚本后，执行如下命令使用~

none

```
clash 		#进入对话脚本
clash -h 	#脚本帮助及说明
clash -u 	#卸载脚本
clash -t 	#测试模式运行
clash -s start 	#启动服务
clash -s stop 	#停止服务

```

#### [](#运行时的额外依赖： "运行时的额外依赖：")**运行时的额外依赖**：

大部分的设备 / 系统都已经预装了以下的大部分依赖，使用时如无影响可以无视之

none

```
curl/wget		必须		全部缺少时无法在线安装及更新，无法使用节点保存功能
iptables/nftables	重要		缺少时只能使用纯净模式
crontab			较低		缺少时无法启用定时任务功能
net-tools		极低		缺少时无法正常检测端口占用
ubus/iproute-doc	极低		缺少时无法正常获取本机host地址

```

## [](#GUI-版本 "GUI 版本")GUI 版本

安装 clash for windows（其实应该叫 Clash GUI 的）

[https://github.com/Fndroid/clash_for_windows_pkg/releases/](https://github.com/Fndroid/clash_for_windows_pkg/releases/)

![](https://img.anubis.cafe/202305120047572.webp)

下载 Linux 版本的压缩包

bash

```
wget https://github.com/Fndroid/clash_for_windows_pkg/releases/download/0.20.22/Clash.for.Windows-0.20.22-x64-linux.tar.gz

```

解压压缩包

bash

```
//文件名自己换
tar -xvf Clash.for.Windows-0.20.22-x64-linux.tar.gz

```

重命名与移动

bash

```
mv Clash\ for\ Windows-0.20.22-x64-linux clash
sudo mv clash /opt
cd /opt/clash

```

## [](#恰饭广告 "恰饭广告")恰饭广告

虽然也没恰多少，[bkcloud](https://bkcloud.cloud/)，有兴趣可以看看。

## [](#参考资料 "参考资料")参考资料

*   [https://parrotsec-cn.org/t/linux-clash-dashboard/5169](https://parrotsec-cn.org/t/linux-clash-dashboard/5169)
*   [https://zhuanlan.zhihu.com/p/396272999](https://zhuanlan.zhihu.com/p/396272999)