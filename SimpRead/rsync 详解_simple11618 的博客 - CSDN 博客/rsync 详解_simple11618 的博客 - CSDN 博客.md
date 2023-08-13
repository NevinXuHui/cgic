---
url: https://blog.csdn.net/wq1205750492/article/details/124497271
title: rsync 详解_simple11618 的博客 - CSDN 博客
date: 2023-06-23 19:23:41
tag: 
banner: "undefined"
banner_icon: 🔖
---
### 一、[rsync](https://so.csdn.net/so/search?q=rsync&spm=1001.2101.3001.7020) 介绍

#### 1、rsync 是什么

```
rsync（remote synchronize）是Liunx/Unix下的一个远程数据同步工具。
它可通过LAN/WAN快速同步多台主机间的文件和目录，并适当利用rsync算法（差分编码）以减少数据的传输。

rsync算法并不是每一次都整份传输，而是只传输两个文件的不同部分，因此其传输速度相当快。

除此之外，rsync可拷贝、显示目录属性，以及拷贝文件，并可选择性的压缩以及递归拷贝。

```

#### 2、rsync 的工作原理

```
a、客户端构造FileList，FileList包含了需要与服务器同步的所有文件信息对name->id
（id用来唯一表示文件例如MD5）

b、客户端将FileList发送到服务器。

c、服务器上rsync处理客户端发过来的FileList，构建新的NewFileList。
 其中根据MD5值比较，删除服务器上已经存在的文件信息对，只保留服务器上不存在或变化的文件。

d、客户端得到服务器发送过来的NewFileList，然后把NewFileList中的文件重新传输到服务器。

```

#### 3、rsync 优点

```
1）可以镜像保存整个目录树和文件系统。

2）可以很容易做到保持原来文件的权限、时间、软硬连接等。

3）无需特殊权限即可安装。

4）快速：第一次同步时rsync复制全部内容，但在下一次值传输修改过的内容

5）压缩传输：rysnc在传输的过程中可以实行压缩及解压缩操作，可以使用更少的带宽

6）安全：可以使用scp、ssh等方式来进行文件传输

7）支持匿名传输，以方便进行网站镜像

8）rsync不仅可以远程同步数据（类似于scp），而且可以本地同步数据（类似于cp），做差异同步

9）openssh 8.0已经把scp标记为过时不建议使用了。建议用sftp或者rsync替代scp


# 需要在Liunx/Unix服务器之间互传海量数据时，建议选择rsync进行传输

```

#### 4、rsync 认证方式

rsync 有两种常用的认证方式，一种是 rsync-daemon 方式，另外一种是 ssh 方式。

在平时使用过程，我们使用最多的是 rsync-daemon 方式。

**注意：在使用 rsync 时，服务器和客户端都必须安装 rsync 程序**。

**rsync-daemon 认证**

```
rsync在rsync-daemon认证方式下，默认监听TCP的873端口。

rsync-daemon认证方式是rsync的主要认证方式，这个也是我们经常使用的认证方式。
并且也只有在此种模式下，rsync才可以把密码写入到一个文件中。

注意：
	rsync-daemon认证方式，需要服务器和客户端都安装rsync服务
	并且只需要rsync服务器端启动rsync，同时配置rsync配置文件。
	客户端启动不启动rsync服务，都不影响同步的正常进行。

```

**ssh 认证**

```
rsync在ssh认证方式下，可通过系统用户进行认证，即在rsync上通过ssh隧道进行传输，类似于scp工具。
此时同步操作不在局限于rsync中定义的同步文件夹。

注意：
	ssh认证方式，不需要服务器和客户端配置rsync配置文件
	只需要双方都安装rsync服务，并且也不需要双方启动rsync。

# 若rsync服务端SSH为标准端口，此时rsync使用方式如下：

	rsync -avz /root/test root@10.10.10.10:/root/


# 若rsync服务端SSH为非标准端口，可通过rsync的-e参数进行端口指定。使用方式如下：

	rsync -avz /root/test -e 'ssh -p1234' root@10.10.10.10:/root/

```

### 二、安装 rsync

安装 rsync，我们可以分为两种方式：源码方式安装和 RPM 方式安装。

**注意：rsync 软件无论是服务器端还是客户端都是同一个软件包。**

#### 1、源码方式安装

```
# 源码方式安装rsync，需要到其官网下载对应的安装包。rsync官网：rsync.samba.org 

1)、下载
wget https://download.samba.org/pub/rsync/src/rsync-3.2.3.tar.gz

2)、解压并安装
tar -xvf rsync-3.2.3.tar.gz

3)、编译安装
# 源码安装rsync时，其编译时所需要的gcc库文件尽量提前安装完毕
# 默认安装到/usr/local/目录下
./configure
make &&make install

4)、设置开机启动
echo “/usr/local/bin/rsync --daemon -config=/etc/rsyncd.conf” >>/etc/profile

```

#### 2、 yum 方式安装

```
yum -y install  rsync

#设置开机启动
echo “/usr/local/bin/rsync --daemon -config=/etc/rsyncd.conf” >>/etc/profile

```

### 三、配置 rsync daemon

rsync 的配置分为服务器端和客户端

使用 rsync 协议，需要服务端启动[守护进程](https://so.csdn.net/so/search?q=%E5%AE%88%E6%8A%A4%E8%BF%9B%E7%A8%8B&spm=1001.2101.3001.7020)

**1、服务端配置**

*   **准备 rsync 配置文件**

```
# 以 rsync 用户启动进程
uid = rsync
gid = rsync

 # 无需让rsync以root身份运行，允许接收文件的完整属性
fake super = yes       

# 禁锢推送的数据至某个目录, 不允许跳出该目录
use chroot = no                

max connections = 200          # 最大连接数
timeout = 600                  # 超时时间
ignore errors                  # 忽略错误信息

read only = false              # 对备份数据可读写

list = false                   # 不允许查看模块信息

# 定义虚拟用户，作为连接认证用户
auth users = myuser 

# 定义rsync服务用户连接认证密码文件路径
secrets file = /etc/rsync.passwd

#### 定义模块信息
[backup]                
comment = commit        # 模块注释信息
path = /backup          # 定义接收备份数据目录

# 只允许10.10.10段ip连接
hosts allow = 10.10.10.0/24

```

*   **配置并启动守护进程**

```
# 需要一个rsync进程运行时使用的普通用户 rsync
useradd rsync -M -s /sbin/nologin

# 服务端需要定义一个客户端连接    虚拟用户名和密码
# 密码文件形式  user:passwd
echo "myuser:password" > /etc/rsync.passwd
chmod 600 /etc/rsync.passwd

# 准备模块定义好的目录,客户端的数据都存放在该目录下
mkdir /backup
chown -R rsync.rsync /backup

# 启动服务
rsync --daemon

# 查看服务
ps aux | grep rsync
netstat -lntp|grep 873

```

**2、客户端使用**

```
# 在客户端安装完毕rsync服务后，是不需要启动rsync服务的。
# 我们只需要在客户端创建连接rsync服务器时，验证码用户所需要的密码文件即可。
# 该密码文件中的密码要与rsync服务器上的密码文件中的密码对应
# 并且也要与rsync服务器rsyncd.conf配置文件中的认证模块中的用户匹配。

echo “password”>>/etc/rsync.passwd

chmod 600 /etc/rsync.passwd


# 查看 rsync 守护程序分配的所有 module 列表，可以执行下面命令。
rsync rsync://10.10.10.10


# 具体写法是服务器与目标目录之间使用双冒号分隔`::`
# 地址中的module并不是实际路径名，而是 rsync 守护程序指定的模块名

# 把本地的文件同步到远程服务器
# rsync [OPTION]… [SRC]… [USER@]HOST::DEST
# rsync [选项] [--port=]  [--password-file=] [/local/path] [用户名]@服务端IP::[模块名]

rsync -av --password-file=/etc/rsync.passwd local/ myuser@10.10.10.10::backup

# 把远程机器的文件同步到本地
# rsync [OPTION]… [USER@]HOST::SRC [DEST]
# rsync [选项] [--port=] [--password-file=] [用户名@]服务端IP::[模块名]  [/local/path]

rsync -av --password-file=/etc/rsync.passwd myuser@10.10.10.10::backup local/


```

### 四、rsync 使用

#### 1、同步模式模式

##### 1.1 本地同步

```
##本地  rsync   选项       源      目标
Local:  rsync [OPTION...] SRC... [DEST]

#将/etc目录备份到/opt目录下，和cp的区别在于会自动增量备份
rsync -avz /etc /opt


```

##### 1.2 远程同步

###### **ssh 协议**

```
# 默认使用 SSH 进行远程登录和数据传输
# 不需要做任何配置，需要都安装rsync，操作上类似scp

#将远端文件拉（下载）到本地
Pull: rsync [OPTION...] [USER@]HOST:SRC... [DEST]
         
#将本地文件推送（上传）到远端
Push: rsync [OPTION...] SRC... [USER@]HOST:DEST
 
#将etc推送到10.10.10.10下的自定义文件夹下
rsync -az /etc/ 10.10.10.10:/opt/etc-$(hostname)-$(date +%F)

```

###### rsync 协议

使用 rsync 协议，需要服务端启动守护进程

操作参考 [配置 rsync daemon](#jump)

#### 2、命令参数

常用参数

```
-v, –verbose详细模式输出。

-a, –archive归档模式，表示以递归方式传输文件，并保持所有文件属性不变。

-z, –compress对备份的文件在传输时进行压缩处理。

–delete：删除那些DST中存在而在SRC中没有的文件。

```

所有参数

```
-a：–archive archive mode 权限保存模式，相当于 -rlptgoD 参数，存档，递归，保持属性等。
-r：–recursive 复制所有下面的资料，递归处理。
-p：–perms 保留档案权限，文件原有属性。
-t：–times 保留时间点，文件原有时间。
-g：–group 保留原有属组。
-o：–owner 保留档案所有者(root only)。
-D：–devices 保留device资讯(root only)。
-l：–links 复制所有的连接，拷贝连接文件。
-z：–compress 压缩模式，当资料在传送到目的端进行档案压缩。
-H：–hard-links 保留硬链接文件。
-A：–acls 保留ACL属性文件，需要配合–perms。
-P：-P参数和 --partial --progress 相同，只是为了把参数简单化，表示传进度。
--version：输出rsync版本。
-v：–verbose 复杂的输出信息。
-u：–update 仅仅进行更新，也就是跳过已经存在的目标位置，并且文件时间要晚于要备份的文件，不覆盖新的文件。
--port=PORT：定义rsyncd(daemon)要运行的port(预设为tcp 873)。

--delete：删除那些目标位置有的文件而备份源没有的文件。

--delete-before: 接收者在传输之前进行删除操作

--password-file=FILE ：从 指定密码文件中获取密码。
--bwlimit=KBPS：限制 I/O 带宽。
--filter “-filename”：需要过滤的文件。
--exclude=filname：需要过滤的文件。
--progress：显示备份过程。

```

### 五、示例

#### 1、常用示例

```
# 将当前目录下所有文件同步到远端
rsync -avzP ./* myuser@10.10.10.15::backup 

# 从服务端同步数据到本地
rsync -avzP  myuser@10.10.10.15::backup .

# 保持服务端于客户端上数据完全一致，服务端有则同步给客户端，服务端没有，客户端有的则从客户端删除
# –delete 选项，表示客户端上的数据要与服务器端完全一致,多则删之，少则补之
# 用的时候要小心点，最好不要把已经有重要数所据的目录，当做本地更新目录，否则会把你的数据全部删除
rsync -avzP  --delete myuser@10.10.10.15::backup  /tmp/test/

# 下面的 rsync 命令将10.10.10.10主机上的 /www 目录（不包含 /www/logs 和 /www/conf子目录）复制到本地的 /backup/www/ 
rsync -avzP --delete --exclude "logs/" --exclude "conf/"  \
10.10.10.10:/www/ /backup/www/


```

#### 2、快速删除大量数据

**1、在`need_delete` 目录下建立 30 万个文件**

```
time for i in $(seq 1 300000)
do
echo test >>$i.txt
done

# 执行时间
real	0m42.267s
user	0m6.756s
sys	0m33.973s


```

**2、测试 rsync 删除**

```
# 先创建一个空目录new_dir

# 然后执行 
time rsync -a --delete-before new_dir/ need_delete/

# 只需要几秒钟，速度非常快
real	0m8.146s
user	0m0.216s
sys	0m7.127s

```

**3、测试 rm -rf 删除**

```
time rm -rf need_delete/

real	0m9.639s
user	0m0.143s
sys	0m8.250s


```

### 六、rsyncd.conf 详解

#### 1、全局参数

```
# 在独立运行时，用于指定的服务器运行的 IP 地址
address = IP

# 监听端口
port = 873 

# rsync 的守护进程将其 PID 写入指定的文件
pid file = /var/run/rsyncd.pid

# 指定支持 max connections 参数的锁文件
lock file = /var/run/rsync.lock

# 指定 rsync 守护进程的日志文件，而不将日志发送给 syslog
log file = /var/log/rsyncd.log

#========== 控制参数 =============#
 # 以指定的 UID 传输文件
uid = rsync        

# 指定该模块以指定的 GID 传输文件。
gid = rsync                     

# 禁锢推送的数据至某个目录, 不允许跳出该目录,
# 默认为 yes，则 rsync 在传输文件之前首先 chroot 到 path 参数所指定的目录下
# 这样做的原因是实现额外的安全防护，但是缺点是需要 root 权限
# 并且不能备份指向 path 外部的符号连接所指向的目录文件
use chroot = no                

# 无需让rsync以root身份运行，允许接收文件的完整属性
fake super = yes                

# 大并发连接数量以保护服务器，超过限制的连接请求将被告知随后再试
# 默认为0 （没有限制）
max connections = 200

# 超时时间
timeout = 600                  

# 指定在 rsync 服务器上运行 delete 操作时是否忽略 I/O 错误。
# 一般来说 rsync 在出现 I/O 错误时将将跳过 –delete 操作
# 以防止因为暂时的资源不足或其它 I/O 错误导致的严重问题。
ignore errors 

# 指定是否允许客户上传文件。
# 默认为true，不允许用户上传文件，
# 若为 false 并且服务器目录也具有读写权限则允许上传。
read only = false 

# 指定当客户请求列出可以使用的模块列表时，该模块是否应该被列出。
# 默认为 true，如果设置该选项为 false，可以创建隐藏的模块
list = false                  

```

#### 2、模块参数

模块参数主要用于定义 rsync 服务器哪个目录要被同步。

模块声明的格式必须为 **[module]** 形式，这个名字就是在 rsync 客户端看到的名字，类似于 Samba 服务器提供的共享名。

而服务器真正同步的数据是通过 path 来指定的。可以根据自己的需要，来指定多个模块，模块中可以定义以下参数：

*   基本模块参数

```
# 指定模块名
[backup]

# 指定当前模块在 rsync 服务器上的同步路径，该参数是必须指定的
path = /backup  	

# 给模块指定一个描述，该描述连同模块名在客户连接得到模块列表时显示给客户
comment = commit	

```

*   模块文件筛选参数

```
# 指定多个由空格隔开的多个文件或目录(相对路径)
# 并将其添加到 exclude 列表中。这等同于在客户端命令中使用 –exclude 来指定模式。
exclude = exclude_file

# 指定一个包含 exclude 规则定义的文件名，服务器从该文件中读取 exclude 列表定义
exclude from = exclude-file.txt

# 指定多个由空格隔开的多个文件或目录(相对路径)，并将其添加到 include 列表中。
# 这等同于在客户端命令中使用 –include 来指定模式 。
include = include-file.txt

# 指定一个包含 include 规则定义的文件名，服务器从该文件中读取 include 列表定义
include from = exclude-file.txt

# 一个模块只能指定一个exclude 参数、一个include 参数
# 结合 include 和 exclude 可以定义复杂的exclude/include 规则
# 这几个参数分别与相应的rsync 客户命令选项等价，唯一不同的是它们作用在服务器端



```

*   模块用户认证参数

```
# rsync 默认匿名方式传输
# 若只配置匿名访问的 rsync 服务器，则无需设置下述参数

# 指定由空格或逗号分隔的用户名列表，只有这些用户才允许连接该模块。
# 这里的用户和系统用户没有任何关系。用户名和口令以明文方式存放在 secrets file 参数指定的文件中
auth users = user_name

# 指定一个 rsync 认证口令文件。只有在 auth users 被定义时，该文件才起作用
secrets file = /etc/rsync.passwd

# rsync 认证口令文件的权限一定是 600，否则客户端将不能连接服务器。
# rsync 认证口令文件中每一行指定一个 用户名:口令 对，格式为：
# username:passwd

# 一般来说口令最好不要超过8个字符

# 一个rsync配置文件中可以包含多个认证模块，同时一个密码文件中也可以存放多个用户和其对应的密码。
# 其中每一个认证模块可以对应不同的客户端。


```