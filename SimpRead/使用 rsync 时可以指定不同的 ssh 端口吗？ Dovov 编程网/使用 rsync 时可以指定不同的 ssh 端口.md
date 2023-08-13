---
url: https://www.dovov.com/rsyncssh.html
title: 使用 rsync 时可以指定不同的 ssh 端口吗？ Dovov 编程网
date: 2023-06-17 12:13:30
tag: 
banner: "undefined"
banner_icon: 🔖
---
我一直在尝试下面的命令：

```
rsync -rvz --progress --remove-sent-files ./dir user@host:2222/path

```

SSH 在端口 2222 上运行，但 rsync 仍然尝试使用端口 22，然后抱怨没有 findpath，当然它不存在。

我想知道是否有可能 rsync 到一个非标准的 SSH 端口上的远程主机。



你的命令行应该是这样的：

```
rsync -rvz -e 'ssh -p 2222' --progress --remove-sent-files ./dir user@host:/path

```

这工作正常 – 我一直使用它，而不需要任何新的防火墙规则 – 只要注意 SSH 命令本身被引用引号。

另一种 select，在运行 rsync 的主机上，在 sshconfiguration 文件中设置端口，即：

```
cat ~/.ssh/config Host host Port 2222

```

然后 rsync 通过 ssh 将会通过端口 2222：

```
rsync -rvz --progress --remove-sent-files ./dir user@host:/path

```

当您需要通过特定的 SSH 端口发送文件时：

```
rsync -azP -e "ssh -p PORT_NUMBER" source destination

```

例

```
rsync -azP -e "ssh -p 2121" /path/to/files/source user@remoteip:/path/to/files/destination

```

使用 “rsh 选项”。 例如：

```
rsync -avz --rsh='ssh -p3382' root@remote_server_name:/opt/backups

```

请参考： http : //www.linuxquestions.org/questions/linux-software-2/rsync-ssh-on-different-port-448112/

有点偏离主题，但可能有助于某人。 如果你需要传递密码和端口，我 build 议使用`sshpass`包。 命令行命令如下所示： `sshpass -p "password" rsync -avzh -e 'ssh -p PORT312' root@192.xx.xxx.xxx:/dir_on_host/`

我在 Mike Hike Hostetler 的网站上 find 了这个解决 scheme，这个解决 scheme 非常适合我。

```
# rsync -avz -e "ssh -p $portNumber" user@remoteip:/path/to/files/ /local/path/

```

谢谢 Mike

我不能让 rsync 通过不同端口上的 ssh 进行连接，但我无法通过 iptables 将 ssh 连接 redirect 到我想要的计算机。 这不是我正在寻找的解决 scheme，但它解决了我的问题。

*   [rsync – mkstemp 失败：权限被拒绝（13）](https://www.dovov.com/rsync-mkstemp13.html "rsync  –  mkstemp失败：权限被拒绝（13）")
*   [RSync：如何在两个方向同步？](https://www.dovov.com/rsync-6.html "RSync：如何在两个方向同步？")
*   [rsync 仅使用 include 选项复制某些 types 的文件](https://www.dovov.com/rsyncincludetypes.html "rsync仅使用include选项复制某些types的文件")
*   [rsync 输出](https://www.dovov.com/rsync-7.html "rsync输出")
*   [rsync：我怎样才能 configuration 它在服务器上创 build 目标目录？](https://www.dovov.com/rsyncconfigurationbuild.html "rsync：我怎样才能configuration它在服务器上创build目标目录？")
*   [rsync 错误：无法在 “/ foo / bar” 上设置时间：操作不允许](https://www.dovov.com/rsync-foo-bar.html "rsync错误：无法在“/ foo / bar”上设置时间：操作不允许")
*   [rsync 根据. gitignore＆.hgignore＆svn 排除：忽略像–filter =：C](https://www.dovov.com/rsync-gitignore-hgignoresvn-filter-c.html "rsync根据.gitignore＆.hgignore＆svn排除：忽略像–filter =：C")
*   [rsync – 什么意思是 rsync 日志上的 f +++++++++？](https://www.dovov.com/rsync-rsyncf.html "rsync  – 什么意思是rsync日志上的f +++++++++？")
*   [Windows 上的 Rsync：创 build 目录的权限错误](https://www.dovov.com/windowsrsyncbuild.html "Windows上的Rsync：创build目录的权限错误")