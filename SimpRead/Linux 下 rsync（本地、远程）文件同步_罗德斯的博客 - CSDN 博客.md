---
url: https://blog.csdn.net/u014270566/article/details/107299120
title: Linux 下 rsync（本地、远程）文件同步_罗德斯的博客 - CSDN 博客
date: 2023-06-20 13:01:58
tag: 
banner: "undefined"
banner_icon: 🔖
---
## rsync 介绍：

sync 同步：刷新文件系统缓存，强制将修改过的数据块写入磁盘，并且更新超级快。`一般重启系统前执行sync命令`  
async：将数据先缓存在缓冲区，再周期性（一般是 30s）的去同步到磁盘 。性能好，但是不能保证数据的安全性  
rsync：远程同步，remote synchronous

## rsync 特点：

1. 可以镜像保存整个目录树和文件系统  
2. 可以保留原有的权限，owner，group，时间，软硬链接，文件属性等信息  
3. 传输效率高，只比较变化的  
4. 支持匿名传输，也可以做验证，加强安全  
2.4 选项说明和示例

## rsync 的选项说明。

-v：显示 rsync 过程中详细信息。可以使用 "-vvvv" 获取更详细信息。  
-P：显示文件传输的进度信息。(实际上 "-P"="–partial --progress"，其中的 "–progress" 才是显示进度信息的)。  
-n --dry-run ：仅测试传输，而不实际传输。常和 "-vvvv" 配合使用来查看 rsync 是如何工作的。  
-a --archive ：归档模式，表示递归传输并保持文件属性。等同于 "-rtopgDl"。  
-r --recursive：递归到目录中去。  
-t --times：保持 mtime 属性。强烈建议任何时候都加上 "-t"，否则目标文件 mtime 会设置为系统时间，导致下次更新  
：检查出 mtime 不同从而导致增量传输无效。  
-o --owner：保持 owner 属性 (属主)。  
-g --group：保持 group 属性 (属组)。  
-p --perms：保持 perms 属性 (权限，不包括特殊权限)。  
-D ：是 "–device --specials" 选项的组合，即也拷贝设备文件和特殊文件。  
-l --links：如果文件是软链接文件，则拷贝软链接本身而非软链接所指向的对象。  
-z ：传输时进行压缩提高效率。  
-R --relative：使用相对路径。意味着将命令行中指定的全路径而非路径最尾部的文件名发送给服务端，包括它们的属性。用法见下文示例。  
–size-only ：默认算法是检查文件大小和 mtime 不同的文件，使用此选项将只检查文件大小。  
-u --update ：仅在源 mtime 比目标已存在文件的 mtime 新时才拷贝。注意，该选项是接收端判断的，不会影响删除行为。  
-d --dirs ：以不递归的方式拷贝目录本身。默认递归时，如果源为 "dir1/file1"，则不会拷贝 dir1 目录，使用该选项将拷贝 dir1 但不拷贝 file1。  
–max-size ：限制 rsync 传输的最大文件大小。可以使用单位后缀，还可以是一个小数值 (例如："–max-size=1.5m")  
–min-size ：限制 rsync 传输的最小文件大小。这可以用于禁止传输小文件或那些垃圾文件。  
–exclude ：指定排除规则来排除不需要传输的文件。  
–delete ：以 SRC 为主，对 DEST 进行同步。多则删之，少则补之。注意 "–delete" 是在接收端执行的，所以它是在  
：exclude/include 规则生效之后才执行的。  
-b --backup ：对目标上已存在的文件做一个备份，备份的文件名后默认使用 "~“做后缀。  
–backup-dir：指定备份文件的保存路径。不指定时默认和待备份文件保存在同一目录下。  
-e ：指定所要使用的远程 shell 程序，默认为 ssh。  
–port ：连接 daemon 时使用的端口号，默认为 873 端口。  
–password-file：daemon 模式时的密码文件，可以从中读取密码实现非交互式。注意，这不是远程 shell 认证的密码，而是 rsync 模块认证的密码。  
-W --whole-file：rsync 将不再使用增量传输，而是全量传输。在网络带宽高于磁盘带宽时，该选项比增量传输更高效。  
–existing ：要求只更新目标端已存在的文件，目标端还不存在的文件不传输。注意，使用相对路径时如果上层目录不存在也不会传输。  
–ignore-existing：要求只更新目标端不存在的文件。和”–existing" 结合使用有特殊功能，见下文示例。  
–remove-source-files：要求删除源端已经成功传输的文件。

## 用法：

**1. 本地同步：**

```
rsync -a 源目录或文件 目标目录或文件
例如：
rsync -a /dir1/ /dir2/     #dir1下所有文件同步到dir2下

```

**2. 远程同步：**

```
rsync -av root@192.168.1.77:/etc/hosts /dir1/     #j将192.168.1.77服务器/etc/hosts文件拷贝到本地/dir1文件夹下

```

默认是需要输入密码才能同步，因为 rsync 基于 ssh 服务  
_**注：免密登录，这只密钥对**_

**3. 将 rsync 作为服务，进行同步 (远程服务器端进行如下配置）**

创建配置文件：`touch /etc/rsyncd.conf`  
编辑`/etc/rsyncd.conf`

```
[ava]             #ava为模块名
log file = /var/log/rsync.log
path=/dir1        #path为同步目录
uid = root       不设置uid和gid的话会报错：有部分文件同步失败，提示：`permission denied`      
gid = root

```

启动：`rsync --daemon`  
验证是否启动：

```
netstat -nltup | grep rsync   #可以看到端口号是873

```

**`手动`进行备份操作：本地端执行同步，从 192.168.1.77 同步模块名为`ava`的文件到本地`/tmp/`目录下：**

```
rsync -av root@192.168.1.77::ava /tmp/


```

上述命令是手动实现备份功能，如需自动备份看下：  
**`自动`备份**：  
1. 编写脚本

```
vim rsync_ava.sh

```

脚本内容：

```
#!/bin/bash
rsync -av root@192.168.1.77::ava /tmp/ &>/dev/null

```

给脚本添加可执行权限

```
chmod +x rsync_ava.sh

```

2. 执行定时任务  
编写计划

```
crontab -e

```

```
03 01 * * * 脚本路径      #每天1时3分执行备份脚本

```

查询定时计划：

```
crontab -l

```

## 拓展：

**实时同步备份（服务端有文件改变就备份）：rsync+inotify**  
1. 安装 inotify 软件

```
tar xf inotify-tools-3.13.tar.gz -C /usr/src/
cd /usr/src/inotify-tools-3.13/
./configure
make
make install

```

安装后会产生两条命令：

```
/usr/local/bin/inotifywait        #等待
/usr/local/bin/inotifywatch     #看守

```

2. 编写脚本实现同步

```
#!/bin/bash
/usr/local/bin/inotifywait -mrq -e modify,delete,create,attrib,move /dir1
| while read events
			do
				rsync -a --delete /dir1 /dir2/
				echo "'date +%F\ %T'出现事件$events"  >> /var/log/rsync.log
2>&1
		done

```