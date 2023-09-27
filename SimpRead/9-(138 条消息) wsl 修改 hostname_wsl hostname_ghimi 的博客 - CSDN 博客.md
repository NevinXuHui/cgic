---
url: https://blog.csdn.net/qq_19922839/article/details/120697210
title: (138 条消息) wsl 修改 hostname_wsl hostname_ghimi 的博客 - CSDN 博客
date: 2023-07-31 21:26:26
tag: 
banner: "https://images.unsplash.com/photo-1688232542797-c3e762c7e3c3?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkwODA5OTgzfA&ixlib=rb-4.0.3&q=85&fit=crop&w=682&max-h=540"
banner_icon: 🔖
---
我在使用 Windows 的 wsl 功能的时候发现在默认情况下 wsl 的 hostname 是和当前 windows 系统的主机名称保持一致的。当我尝试使用 `hostname` 修改主机名时，发现并不能完全修改，在重新进入后又会恢复成原来的样子。经过不停的查找，终于找到了能够修改 hostname 的方法。

### 步骤一

首先打开控制台进入 wsl：  

![](https://img-blog.csdnimg.cn/18c2111ec6ce4193abd7bc9442130225.png)

  
进入 `/etc` 目录 , 编辑 `wsl.conf`，如果没有该文件就创建一个：

```
vim /etc/wsl.conf

```

输入以下参数：

```
[network]
hostname = node01
generateHosts = false

```

在 `network`配置组下面添加以下配置：

<table><thead><tr><th>配置</th><th>说明</th></tr></thead><tbody><tr><td><code onclick="mdcp.copyCode(event)">hostname</code></td><td>设置当前 <code onclick="mdcp.copyCode(event)">wsl</code> 的主机名称</td></tr><tr><td><code onclick="mdcp.copyCode(event)">generateHosts</code></td><td>是否自动生成 <code onclick="mdcp.copyCode(event)">hosts</code> 文件</td></tr></tbody></table>

在设置完成后退出 `wsl`。  
注意在直接退出`wsl` 之后配置并没有直接生效，而是在`wsl` 重启之后才会生效，所以我们可以使用命令使`wsl` 先关闭，然后再重新进入就会发现`hostname`已经修改过来了。

```
wsl --list --running
wsl --shutdown
wsl --list --running
wsl

```

![](https://img-blog.csdnimg.cn/8cf13ae624ad4475b19ea162265d7476.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAZ2hpbWk=,size_20,color_FFFFFF,t_70,g_se,x_16)

### wsl 修改默认用户的方法

通常我们可以通过以下命令来指定进入 wsl 的时候使用的用户：

```
# wsl -u <Username>,wsl --user <Username>
wsl -u root

```

如果希望修改默认用户的话，则需要进行设置，比如我这里使用的 wsl 是 Ubuntu2004 版本，则需要进行如下设置：

```
# <DistributionName> config --default-user <Username>
ubuntu2004.exe config --default-user root

```

![](https://img-blog.csdnimg.cn/6ba1b46bf51b4a458577b7d08af315c8.png)

或者使用上面的 `wsl.conf` 进行配置，进入 wsl ，编辑 `wsl.conf` 配置文件：

```
[user]
default = root

```

![](https://img-blog.csdnimg.cn/b028929a578a4c74b8fd4f322c375db5.png)

  
保存配置并退出，同样在关闭 wsl 之后重新进入，便会发现默认用户已经修改了。需要注意的是 `wsl.conf` 配置优先级要高于`Ubuntu2004.exe config --default-user`, 因此如果两个都配置了的话，会以 `wsl.conf` 中的配置优先。

### 参考资料

[WSL 不修改 Windows 主机名设置 hostname 的方法](https://blog.csdn.net/hxlawf/article/details/119750183)  
[WSL 设置 hostname，不修改 Windows 主机名](https://www.cnblogs.com/stellae/p/14969599.html)  
[How to change hostname on Ubuntu running on Windows WSL](https://www.srccodes.com/change-hostname-ubuntu-microsoft-windows-subsystem-for-linux-wsl-wsl2-wsl-conf-unable-resolve-hosts-name-service-not-known-list-running-shutdown-vm-srccodes/)  
[Configure Linux distributions](https://docs.microsoft.com/en-us/windows/wsl/wsl-config)