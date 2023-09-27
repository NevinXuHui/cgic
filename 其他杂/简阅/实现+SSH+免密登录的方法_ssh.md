SSH 密钥登录比密码登录安全，主要是因为他使用了非对称加密，登录过程中需要用到密钥对。整个登录流程如下：

- 远程服务器持有公钥，当有用户进行登录，服务器就会随机生成一串字符串，然后发送给正在进行登录的用户。

- 用户收到远程服务器发来的字符串，使用与远程服务器公钥配对的私钥对字符串进行加密，再发送给远程服务器。

- 服务器使用公钥对用户发来的加密字符串进行解密，得到的解密字符串如果与第一步中发送给客户端的随机字符串一样，那么判断为登录成功。

**serverB 实现免密登录 serverA 有两种方向：**

1. serverB 生成秘钥对，将 serverB 密钥对中的公钥给 serverA

2. serverA 生成秘钥对，将 serverA 密钥对中的私钥给 serverB

**方式一：**
在 serverB：

1、产生公私密钥对：# ssh-keygen

2、把公钥上传到 serverA 的./ssh/authorized_keys 文件内

在 serverA：

1、serverA 的 sshd_config 文件配置

2、登录 # ssh root@serverA

**方式二：**
在 serverA：
1、产生公私密钥对：# ssh-keygen

2、将公钥导入已验证密钥：# cat /root/.ssh/id_rsa_pub  >> /root/.ssh/authorized_keys

或：# ssh-copy-id root@Aip

注意 authorized_keys 文件是可以保存多个公钥信息的，每个公钥以换行分开。

3、将私钥导出给 serverB：# scp /root/.ssh/id_rsa root@Bip:/root/.ssh/id_rsa_serverB 

4、配置 / etc/ssh/sshd_config 文件：

RSAAuthentication yes

PubkeyAuthentication yes

AuthorizedKeysFile    .ssh/authorized_keys

PasswordAuthentication no #最好先设置为 yes，等密钥登录成功后，再设置为 no

5、保存重启 sshd 服务：# systemctl restart shd

- 为了安全起见，删除刚才产生的密钥对

在 serverB:

登录到 A：# ssh -i /root/.ssh/id_rsa.serverA root@serverA

客户端工具也可以先配置好使用公钥登录
 

参考文章：

[ssh 免密登录_jiecy 的博客 - CSDN 博客_ssh 免密登录](https://blog.csdn.net/jiecy/article/details/121597189)

[SSH 三步解决免密登录_jeikerxiao 的博客 - CSDN 博客_ssh 免密](https://blog.csdn.net/jeikerxiao/article/details/84105529?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~CTRLIST~Rate-1-84105529-blog-121597189.pc_relevant_multi_platform_featuressortv2dupreplace&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~CTRLIST~Rate-1-84105529-blog-121597189.pc_relevant_multi_platform_featuressortv2dupreplace&utm_relevant_index=1)

[SSH 的免密登录详细步骤（注释 + 命令 + 图）_艳阳如一的博客 - CSDN 博客_ssh 免密登录](https://blog.csdn.net/SXY16044314/article/details/90605069?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-1-90605069-blog-121597189.pc_relevant_multi_platform_featuressortv2dupreplace&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-1-90605069-blog-121597189.pc_relevant_multi_platform_featuressortv2dupreplace&utm_relevant_index=2)

