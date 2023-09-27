---
url: https://www.cnblogs.com/saneri/p/10819348.html
title: Linux expect 介绍和用法一
date: 2023-09-27 15:17:25
tag: 
banner: "https://common.cnblogs.com/logo_square.png"
banner_icon: 🔖
---
expect 是一个自动化交互套件，主要应用于执行命令和程序时，系统以交互形式要求输入指定字符串，实现交互通信。

expect 自动交互流程：

spawn 启动指定进程 ---expect 获取指定关键字 ---send 向指定程序发送指定字符 --- 执行完成退出.

注意该脚本能够执行的前提是安装了 expect

```
yum install -y expect

```

expect 常用命令总结:

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```
spawn               交互程序开始后面跟命令或者指定程序
expect              获取匹配信息匹配成功则执行expect后面的程序动作
send exp_send       用于发送指定的字符串信息
exp_continue        在expect中多次匹配就需要用到
send_user           用来打印输出 相当于shell中的echo
exit                退出expect脚本
eof                 expect执行结束 退出
set                 定义变量
puts                输出变量
set timeout         设置超时时间

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

**示例：**

1.ssh 登录远程主机执行命令, 执行方法 expect 1.sh 或者 ./1.sh

# vim 1.sh 

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```
#!/usr/bin/expect

spawn ssh saneri@192.168.56.103 df -Th
expect "*password"
send "123456\n"
expect eof

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

2. ssh 远程登录主机执行命令，在 shell 脚本中执行 expect 命令, 执行方法 sh 2.sh、bash 2.sh 或./2.sh 都可以执行.

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```
#!/bin/bash

passwd='123456'

/usr/bin/expect <<-EOF

set time 30
spawn ssh saneri@192.168.56.103 df -Th
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*password:" { send "$passwd\r" }
}
expect eof
EOF

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

3.expect 执行多条命令

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```
#!/usr/bin/expect -f

set timeout 10

spawn sudo su - root
expect "*password*"
send "123456\r"
expect "#*"
send "ls\r"
expect "#*"
send "df -Th\r"
send "exit\r"
expect eof

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

4. 创建 ssh key，将 id_rsa 和 id_rsa.pub 文件分发到各台主机上面。

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```
1.创建主机配置文件

[root@localhost script]# cat host 
192.168.1.10 root 123456
192.168.1.20 root 123456
192.168.1.30 root 123456

[root@localhost script]# ls
copykey.sh  hosts
2.编写copykey.sh脚本,自动生成密钥并分发key.
[root@localhost script]# vim copykey.sh

#!/bin/bash

# 判断id_rsa密钥文件是否存在
if [ ! -f ~/.ssh/id_rsa ];then
 ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
else
 echo "id_rsa has created ..."
fi

#分发到各个节点,这里分发到host文件中的主机中.
while read line
  do
    user=`echo $line | cut -d " " -f 2`
    ip=`echo $line | cut -d " " -f 1`
    passwd=`echo $line | cut -d " " -f 3`
    
    expect <<EOF
      set timeout 10
      spawn ssh-copy-id $user@$ip
      expect {
        "yes/no" { send "yes\n";exp_continue }
        "password" { send "$passwd\n" }
      }
     expect "password" { send "$passwd\n" }
EOF
  done <  hosts

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

 5. shell 调用 expect 执行多行命令.

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```
#!/bin/bash 
ip=$1  
user=$2 
password=$3 

expect <<EOF  
    set timeout 10 
    spawn ssh $user@$ip 
    expect { 
        "yes/no" { send "yes\n";exp_continue } 
        "password" { send "$password\n" }
    } 
    expect "]#" { send "useradd hehe\n" } 
    expect "]#" { send "touch /tmp/test.txt\n" } 
    expect "]#" { send "exit\n" } expect eof 
 EOF  
 #./ssh5.sh 192.168.1.10 root 123456 

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

 6. 使用普通用户登录远程主机，并通过 sudo 到 root 权限，通过 for 循环批量在远程主机执行命令.

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```
$ cat timeout_login.txt 
10.0.1.8
10.0.1.34
10.0.1.88
10.0.1.76
10.0.1.2
10.0.1.3

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```
#!/bin/bash

for i in `cat /home/admin/timeout_login.txt`
do

    /usr/bin/expect << EOF
    spawn /usr/bin/ssh -t -p 22022 admin@$i "sudo su -"

    expect {
        "yes/no" { send "yes\r" }
    }   

    expect {
        "password:" { send "xxo1#qaz\r" }
    }
    
    expect {
        "*password*:" { send "xx1#qaz\r" }
    }

    expect "*]#"
    send "df -Th\r"
    expect "*]#"
    send "exit\r"
    expect eof

EOF
done

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

 密码过期需要批量修改密码

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```
#!/bin/bash

for i in `cat /root/soft/ip.txt`
do

    /usr/bin/expect << EOF
    spawn /usr/bin/ssh root@$i

    expect {
        "UNIX password" { send "Huawei@123\r" }
    }
    
    expect {
        "New password:" { send "xxHuzzawexxi@1234#\r" }
    }

   expect {
        "Retype new password:" { send "xxHuzzawexxi@1234#\r" }
    }

    expect "*]#"
    send "echo Huawei@123|passwd --stdin root\r"
    expect "*]#"
    send "exit\r"
    expect eof
EOF
done

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

参考文档：[https://www.cnblogs.com/yxh168/p/9028122.html](https://www.cnblogs.com/yxh168/p/9028122.html)

　　　　    [https://www.cnblogs.com/lisenlin/p/9058557.html](https://www.cnblogs.com/lisenlin/p/9058557.html)