---
url: https://zhuanlan.zhihu.com/p/40022680
title: Rsync 数据同步工具应用指南
date: 2023-06-20 13:03:14
tag: 
banner: "https://picx.zhimg.com/v2-6f26d816c7a3d517e75d8f4187d2c5b5_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
## Rsync 简介

Rsync 是一款开源的，快速的，多功能的，可实现全量及增量（差异化备份）的本地或远程数据同步备份的优秀工具。

Rsync 软件适用于 Unix、Linux、Windows 等多种操作系统。

1）可使本地和远程两台主机之间的数据快速复制同步镜像，远程备份的功能，这个功能类似 ssh 带 scp 命令，但又优于 scp 命令的功能，scp 每次都是全量拷贝，而 rsync 可以增量拷贝。

2）rsync 还可以在本地主机的不同分区或目录之间全量及增量的复制数据，

3）利用 rsync 还可以实现删除文件和目录的功能。相当于 rm

4）rsync 相当于 scp,cp.rm 但是还优于他们每一个命令。

在同步备份数据时，默认情况下 rsync 通过独特的 “quick check” 算法，它仅同步大小或者最后修改时间发生变化的文件或目录，当然也可以是根据权限，属主等属性的变化同步，但需要指定相应的参数，甚至可以实现只同步一个文件里有变化的内容部分，所以可以实现快速的同步备份数据。

```
CentOS 5 rsync2.x 比对方法，把所有的文件比对一遍，然后进行同步。
CentOS 6 rsync3.x 比对方法，一边比对差异，一边对差异的部分进行同步。

```

## Rsync 特性

```
1）支持拷贝特殊文件如链接文件，设备等。
2）可以有排除指定文件或目录同步的功能，相当于打包命令tar的排除功能。
3）可以做到保持源文件或目录的权限，时间，软硬链接，属主，组等属性均不改变 -p.
4）可以实现增量同步，即只同步发生变化的数据，因此数据传输的效率很高，tar -N.
5）可以使用rcp,rsh,ssh,等方式来配合传输文件（rsync本身不对数据加密）
6）可以通过soket（进程方式）传输文件和数据（服务端和客户端）*****
7）支持匿名的或认证的（无需系统用户）的进程模式传输，可实现方便安全的进程数据备份及镜像。

```

## 实时同步（解决存储服务器等单点问题）

利用 rsync 结合 inotify 的功能做实时的数据同步，根据存储服务器上目录的变化，把变化的数据通过 inotify 或 sersync 结合 rsync 命令，同步到备份服务器，还可以通过 drbd 方案以及双写的方案实现双机数据同步。

## Rsync 的工作方式

大致使用三种主要的传输数据的方式。

```
1）单个主机本地之间的数据传输（此时类似于cp命令的功能）
2）借助rcp,ssh等通道来传输数据（此时类似于scp命令的功能）
3）以守护进程（socket）的方式传输数据（这个是rsync自身的重要功能）

```

## 服务端与客户端安装 Rsync

修改主机名

```
hostname backup
vi /etc/sysconfig/network


```

安装 rsync 与 依赖

```
yum -y install rsync xinetd

vi /etc/xinetd.d/rsync
将yes 修改为no IPV6修改为IPV4

```

## rsync 命令同步参数详解

local（本地）模式的命令参数

```
-v --verbose 详细模式输出，传输时的进度等信息。
-z --compress 传输时进行压缩以提高传输效率,
--compress-level=NUM可按级别压缩

```

重要的命令

```
-a --archive 归档模式，表示以递归方式传输文件，并保持所有文件属性，等价于-rtopgDl
-r 对子目录以递归模式，即目录下的所有目录都同样传输，注意是小写的r.
-o 保持文件属性信息
-p 保持文件权限
-g 保持文件属组信息
-P 显示同步的过程及传输时的进度等信息
-D 保持设备文件信息
-l 保持软连接
-avzP 提示：这里的 相当于 -vzrtopgDlP(还多了Dl功能)生产环境常用 
-avz 定时任务就不用输出过程了可以-az


```

需了解的命令

```
-e 使用的信道协议，指定替代rsh的shell程序，例如：ssh
--exclude=PATTERN 指定排除不需要传输的文件模式（和tar参数一样）--exclude=file（文件名所在的目录文件）（和tar参数一样）--delete 让目标目录SRC和源目录数据DST一致。

```

注意：/tmp/ rsync 如果 tmp/ 加上斜线的话就表示只选中斜线后的文件，不包含 tmp。

如果不加上斜线 tmp 那么就是包含目录本身和目录之下的文件。

## 做数据同步容易将带宽占满，导致网站无法访问

```
rsync scp ftp 都有限速功能解决：man rsync里面有一个限速的参数。我之前刚做运维的时候，在备份数据时，没考虑业务低谷时间点，将带宽占满了，导致网站无法正常访问。发现问题之后，我立即停止数据备份，然后man 了一下，才发现rsync有限速参数。尽量不要在业务高并发的时候做备份，要在业务低谷时间段进行，限速备份。当然，scp,ftp都有限速的功能。

```

## 借助 ssh 通道在不同主机之间传输数据

man rsyncd.conf

```
使用-e参数，利用ssh隧道进行文件传输
[root@backup ~]# rsync -avz /etc/hosts -e 'ssh -p 22' root@10.0.0.31:/mnt
可以使用ssh key 免密钥登录，然后可以做定时任务。

```

## 优化 ssh （让连接服务器进行 rsync 更快）

```
[root@backup ~]# vim /etc/ssh/sshd_config 
GSSAPIAuthentication no   （把这个的注释去掉，也就是打开）
#GSSAPIAuthentication yes（把这个注释掉，也就是关闭）UseDNS no (改成no)

```

## 以守护进程（socket）的方式传输数据

## rsync 命令使用用法

rsync - 参数 用户名 @同步服务器的 IP::rsyncd.conf 中那个方括号里的内容（配置文件中的模块名） 本地存放路径。

rsync -avzP [nemo@192.168.10.1](http://mailto:nemo@192.168.10.1/)::nemo /backup

## 服务器端的配置过程

## 安装 rysnc

```
yum -y install rsync xinetd

vi /etc/xinetd.d/rsync
将yes 修改为no IPV6修改为IPV4

```

## 1、查看 rsync 安装包

```
[root@backup ~]# rpm -qa rsync

```

## 2、添加 rsync 服务的用户，管理本地目录

```
[root@backup ~]# useradd rsync -s /sbin/nologin -M
[root@backup ~]# tail -1 /etc/passwdrsync:x:501:501::/home/rsync:/sbin/nologin

```

## 3、生成 rsyncd.conf 配置文件

查看 rsyncd.conf

```
[root@backup backup]# cat /etc/rsyncd.conf 
config_______________start
#15:01 2007-6-5
#rsyncd.conf start##
uid = rsync
gid = rsync
use chroot = no
max connections = 200
timeout = 300
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
[backup]
path = /backup
ignore errors
read only = false
list = false
hosts allow = 172.16.1.0/24
hosts deny = 0.0.0.0/32
auth users = rsync_backup
secrets file = /etc/rsync.password
#rsync_config____________end



```

配置 rsyncd.conf

```
[root@backup ~]# vim /etc/rsyncd.conf 
#rsync_config_______________start
#15:01 2018-6-5
#rsyncd.conf start##
uid = rsync #用户远端的命令使用rsync访问共享目录
gid = rsync #用户组
use chroot = no #安全相关
max connections = 200 #最大连接数
timeout = 300 #超时时间（单位/秒）
pid file = /var/run/rsyncd.pid  #（进程号对应的进程号文件）
lock file = /var/run/rsync.lock #锁文件，防止文件不一致
log file = /var/log/rsyncd.log  #日志文件
[backup]  #模块名称
path = /backup  #服务器端提供访问的目录
ignore errors #忽略错误
read only = false #可写
list = false  #不让列表（相当于ls)
hosts allow = 172.16.1.0/24 #允许的网段
hosts deny = 0.0.0.0/32  #拒绝的网段
auth users = rsync_backup #连接的虚拟用户，非系统用户
secrets file = /etc/rsync.password #虚拟用户的账号密码文件
#rsync_config____________end


```

## 4、rsyncd.conf 的 auth users 配置账户，远程连接

并根据 secrets file 参数生成密码文件

```
法一
echo "rsync_backup:cloudbility" >/etc/rsync.password
cat /etc/rsync.password

法二
[root@backup ~]# vim  /etc/rsync.password
rsync_backup:cloudbility

[root@backup ~]# cat /etc/rsync.password
rsync_backup:cloudbility

```

## 5、为密码文件配置权限

```
chmod 600 /etc/rsync.password
ls -l /etc/rsync.password

```

## 6、创建共享的目录并授权 rsync 服务管理

```
法一：
[root@backup ~]# mkdir /backup

[root@backup ~]# ls -ld /backup/
drwxr-xr-x 2 root root 4096 1月  16 20:08 /backup/
(如果不修改权限的话，远程访问过来是用rsync但是这个目录的属组和属主都收root 就无法把远方的数据推送过来，没有写权限。)

[root@backup ~]# chown rsync.rsync /backup/
（更改属组和属主）

[root@backup ~]# ls -ld /backup/
drwxr-xr-x 2 rsync rsync 4096 1月  16 20:08 /backup/

法二：
mkdir /backup -p
chown -R rsync.rsync /backup
如果没有/backup目录，就会chdir failed.(失败的)


```

## 7、启动 rsync 服务并检查

```
[root@backup ~]# rsync --daemon  
开启rsync服务

[root@backup ~]# ps -ef|grep rsync|grep -v grep
root       5116   5100  0 19:14 pts/0    00:00:00 vim /etc/rsyncd.conf
root       5193      1  0 20:05 ?        00:00:00 rsync --daemon
（为什么是root在运行呢？因为远程访问的用户才会使用rsync来使用，上面配置文件有写）

查看运行端口
[root@backup ~]# lsof -i :873
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
rsync   5193 root    3u  IPv4  19935      0t0  TCP *:rsync (LISTEN)
rsync   5193 root    5u  IPv6  19936      0t0  TCP *:rsync (LISTEN)

[root@backup ~]# netstat -lntup|grep 873
tcp        0      0 0.0.0.0:873                 0.0.0.0:*                   LISTEN      5193/rsync          
tcp        0      0 :::873                      :::*                        LISTEN      5193/rsync

```

## 8、加入开机自启动

```
[root@backup ~]# echo "/usr/bin/rsync --damon" >>/etc/rc.local

[root@backup ~]# tail -1 /etc/rc.local
/usr/bin/rsync --damon

```

## 排错过程

## 1、输出结果

## 2、日志 tail /var/log/rsyncd.log

## 3、熟练部署过程（原理）

## rsync 客户端操作方法

## 1、生成连接服务器的密码文件

```
法一：
echo "cloudbility" >/etc/rsync.password

法二：
[root@nfs01 ~]# vim /etc/rsync.password

[root@nfs01 ~]# cat /etc/rsync.password
cloudbility2、为密码文件配置权限
[root@nfs01 ~]# chmod 600 /etc/rsync.password
[root@nfs01 ~]# ll /etc/rsync.password-rw------- 1 root root 7 1月  16 20:58 /etc/rsync.password

```

## 2、为密码文件配置权限

```
[root@nfs01 ~]# chmod 600 /etc/rsync.password

[root@nfs01 ~]# ll /etc/rsync.password
-rw------- 1 root root 7 1月  16 20:58 /etc/rsync.password

```

## 3、同步文件

## 创建样本

```
[root@nfs01 ~]# mkdir /backup -p

[root@nfs01 ~]# cd /backup/


[root@nfs01 backup]# touch stu{01..100}

[root@nfs01 backup]# ls
stu001  stu010  stu02   stu029  stu038  stu047  stu056  stu065  stu074  stu083  stu092
stu002  stu011  stu020  stu03   stu039  stu048  stu057  stu066  stu075  stu084  stu093推送到backup server：
法一：需要密码[root@nfs01 backup]# rsync -avz /backup/ rsync_backup@172.16.1.41::backup/（模块名）法二：无需密码[root@nfs01 backup]# rsync -avz /backup/ rsync_backup@172.16.1.41::backup/（模块名） --password-file=/etc/rsync.password法三：无需密码[root@nfs01 backup]# rsync -avz /backup/ rsync://rsync_backup@172.16.1.41/backup/（模块名） --password-file=/etc/rsync.password

```

## 推送到 backup server：

```
法一：需要密码
[root@nfs01 backup]# rsync -avz /backup/ rsync_backup@172.16.1.41::backup/（模块名）

法二：无需密码
[root@nfs01 backup]# rsync -avz /backup/ rsync_backup@172.16.1.41::backup/（模块名） --password-file=/etc/rsync.password

法三：无需密码
[root@nfs01 backup]# rsync -avz /backup/ rsync://rsync_backup@172.16.1.41/backup/（模块名） --password-file=/etc/rsync.password排除同步：

```

## 从 backup server 拉取 / backup 下的文件到本地 / backup 下。

```
法一：需要密码
[root@nfs01 backup]# rsync -avz rsync_backup@172.16.1.41::backup（模块名） /backup/ 

法二：免密
[root@nfs01 backup]# rsync -avz rsync_backup@172.16.1.41::backup（模块名） /backup/ --password-file=/etc/rsync.password  

法三：免密
[root@nfs01 backup]# rsync -avz rsync://rsync_backup@172.16.1.41/backup/（模块名） /backup/ --password-file=/etc/rsync.password

提示上述的backup为模块名，不是路径


```

## 增加模块

```
[root@backup backup]# vim /etc/rsyncd.conf
#15:01 2018-6-5
#rsyncd.conf start##
uid = rsync
gid = rsync
use chroot = no
max connections = 200
timeout = 300
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
ignore errors
read only = false
list = false
hosts allow = 172.16.1.0/24
hosts deny = 0.0.0.0/32
auth users = rsync_backup
secrets file = /etc/rsync.password
[backup]
path = /backup
[cloudbility]
path = /cloudbility
##rsync_config____________end

```

## 排除同步：

## 排除推送

## 排除单个文件：

```
--exclude=a  （排除a）
 
[root@nfs01 backup]# rsync -avz --exclude=a /backup/ rsync_backup@172.16.1.41::backup/ --password-file=/etc/rsync.password
sending incremental file list
./bcdefg

```

## 排除多个文件：

```
1)
排除a 和b 
[root@nfs01 backup]# rsync -avz --exclude={a,b} /backup/ rsync_backup@172.16.1.41::backup/ --password-file=/etc/rsync.password
sending incremental file list
./cdefg

2)
排除连续的a-f
[root@nfs01 backup]# rsync -avz --exclude={a..f} /backup/ rsync_backup@172.16.1.41::backup/ --password-file=/etc/rsync.password
sending incremental file list
./g

sent 75 bytes  received 30 bytes  210.00 bytes/sec
total size is 0  speedup is 0.00


```

1）拉取和推送都可以排除。

2）也可以服务端排除，配置文件里参数。

3）exclude=a b c d

## 完全同步：无差异同步 --delete

```
[root@nfs01 backup]# rsync -avz --delete /backup/ rsync_backup@172.16.1.41::backup/ --password-file=/etc/rsync.password
sending incremental file list

abcdef

```

## rsync 三种工作模式

```
1）local(本地模式)：（cd,rm）

2）通道模式：
 rsync -avzP -e 'ssh -p 22' /etc root@10.0.0.41:/tmp/
 一般配合ssh key免密钥传输，结合定时任务。
 
 3）daemon模式
内网不需要加密，加密性能有损失。

如果要外网的话使用vpn(PPTP。openVPN，ipsec)

```

## rsync 服务模式故障常见问题解答

## 1）小 BUG

```
[root@backup backup]# vim /etc/rsyncd.conf
#hosts deny = 0.0.0.0/32
把 hosts deny（拒绝的ip段）注释掉，因为当

hosts allow = 172.16.1.0/24
#hosts deny = 0.0.0.0/32
这两个在一起的时候，发现10段的ip 也能把数据推送到backup server。所以必须注释掉
hosts deny。

提示：更改配置文件之后要重启服务，因为每次Linux都是把配置文件放到内存。
先杀死进程，然后检查
[root@backup backup]# pkill rsync
[root@backup backup]# lsof -i :873

重启再检查看看
[root@backup backup]# rsync --daemon
[root@backup backup]# lsof -i :873
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
rsync   7718 root    4u  IPv4  33811      0t0  TCP *:rsync (LISTEN)
rsync   7718 root    5u  IPv6  33812      0t0  TCP *:rsync (LISTEN)

```

## 2）服务端没有这个目录

提示报错信息

```
[root@nfs01 backup]# rsync -avz /backup/ rsync_backup@172.16.1.41::backup/ --password-file=/etc/rsync.password 
@ERROR: chdir failed


解决方法：
服务端创建目录
[root@backup backup]# mkdir /backup
[root@backup backup]# ll -d /backup/
drwxr-xr-x 2 root root 4096 Jan 17 15:52 /backup/

[root@backup backup]# chown -R rsync.rsync /backup/ 
（/etc/rsyncd.conf配置文件里的uid和gid）

```

## 3）权限不够

提示报错信息

```
[root@nfs01 backup]# rsync -avz /backup/ rsync_backup@172.16.1.41::backup/ --password-file=/etc/rsync.password sending incremental file list./
rsync: failed to set times on "." (in backup): Operation not permitted (1)
stu1
stu10
stu2
stu3
stu4
stu5
stu6
stu7
stu8
stu9
rsync: mkstemp ".stu1.oraZ3Y" (in backup) failed: Permission denied (13)
rsync: mkstemp ".stu10.n1jKm7" (in backup) failed: Permission denied (13)
rsync: mkstemp ".stu2.dLFwFf" (in backup) failed: Permission denied (13)
rsync: mkstemp ".stu3.LKKjYn" (in backup) failed: Permission denied (13)
rsync: mkstemp ".stu4.nSI7gw" (in backup) failed: Permission denied (13)
rsync: mkstemp ".stu5.p4CWzE" (in backup) failed: Permission denied (13)
rsync: mkstemp ".stu6.HE5OSM" (in backup) failed: Permission denied (13)
rsync: mkstemp ".stu7.jGRIbV" (in backup) failed: Permission denied (13)
rsync: mkstemp ".stu8.p4cDu3" (in backup) failed: Permission denied (13)
rsync: mkstemp ".stu9.EZbyNb" (in backup) failed: Permission denied (13)

sent 467 bytes  received 201 bytes  1336.00 bytes/sec
total size is 0  speedup is 0.00rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1039) [sender=3.0.6]
解决方法[root@backup backup]# ll -d /backup/
drwxr-xr-x 2 root root 4096 Jan 17 15:52 /backup/

[root@backup backup]# chown -R rsync.rsync /backup/ （/etc/rsyncd.conf配置文件里的uid和gid）

```

## 4）没有创建 uid

提示错误信息

```
[root@nfs01 backup]# rsync -avz /backup/ rsync_backup@172.16.1.41::backup/ --password-file=/etc/rsync.password 
@ERROR: invalid uid rsync


解决方法：
[root@backup backup]# useradd rsync -s /sbin/nologin -M


```

## 5）客户端 / etc/rsync.password 配置文件里的密码错误（注意空格）

```
[root@nfs01 backup]# rsync -avz /backup/ rsync_backup@172.16.1.41::backup/ --password-file=/etc/rsync.password 
@ERROR: auth failed on module backup

解决：
查看服务端的日志配置文件的报错信息。
[root@backup backup]# cat /var/log/rsyncd.log  
2017/01/17 16:04:36 [7813] auth failed on module backup from unknown (172.16.1.31): password mismatch

提示我们密码错误：
查看服务器端的配置文件和密码，然后，再看客户端的。
[root@backup backup]# vim /etc/rsync.password 
rsync_backup:cloudbility


```

## 6）连接被拒绝

提示信息

```
[root@nfs01 backup]# rsync -avz /backup/ test@172.16.1.41::cloudbility/
rsync: failed to connect to 172.16.1.41: Connection refused (111)

解决，
1)服务端防火墙是否关闭iptables

2)873端口是否开放。
重启rsync服务。
[root@backup cloudbility]# rsync --daemon
[root@backup cloudbility]# lsof -i :873

```

## rsync 守护进程 (daemon) 服务传输数据排错思路：

## rsync 服务端排错思路

1）查看 rsync 服务配置文件路径是否正确，正确的默认路径为：/etc/rsyncd.conf

2）查看配置文件里的 host allow.host deny 允许的网段是否允许客户端访问的 IP 网段。

3）查看配置文件中 path 参数里的路径是否存在，权限是否正确（正常应为位置文件中的 UID 参数对应的属主和组）

4）查看 rsync 服务是否启动，查看命令为：ps -ef|grep rsync. 端口是否存在 netstat -lnt|grep 873.

5）查看 iptables 防火墙和 SELinux 是否开启允许 rsync 服务通过，也可以考虑关闭。

6）查看服务端 rsync 配置的密码文件权限是否是 600；密码文件格式是否正确。 正确格式为 用户名：密码 。文件路径和配置文件里的 secrect files 参数对应。

7）如果是推送数据，要查看下，配置 rsyncd.conf 文件中用户是否对模块下的目录有可读写权限

## rsync 客户端排除思路

```
1）查看客户端rsync配置的密码文件是否为600权限，密码文件格式是否正确。
注意，仅西药有密码，并且和服务端的密码一致。

2）用telnet连接rsync服务器IP地址873端口，查看服务是否启动
（可测试服务端防火墙是都阻挡）。 telnet 10.0.0.41 873

3）客户端执行命令时rsync -avzP rsync_backup@10.0.0.41::cloudbility/test/test --password-file=/etc/rsync.password
此命令的细节要记清楚，尤其是10.0.0.41::cloudbility/test/处的双冒号及随其后的cloudbility
的模块名称；

```

## rsync 优缺点：

rsync 优点：

```
1）增量备份，支持socket（daemon守护进程），集中备份（支持推拉，都是以客户端为参照物）；
2）远程SEHLL通道模式还可以加密（SSH）传输，socket（daemon守护进程）需要加密传输，可以利用VPN服务或ipsec服务；

```

rsync 缺点：

```
1）大量小文件同步的时候，比对时间较长，有的时候，rsync进程可能会停止。
2）同步大文件，10G这样的大文件有时也会出现问题，中断。未完整同步之前,是隐藏文件.可以通过续传等参数实现传输，一次性远程拷贝可以用scp;

```

（完）  

  
行云管家官网：  

[行云管家【官网】- 领先的云计算管理平台 - 云安全，堡垒机，自动化运维](https://www.cloudbility.com/?refid=Zhihu_OpsRoad_Rsync20180718_0)

运维之路社区：  

[Rsync 数据同步工具应用指南](http://www.opsroad.com/908.html)