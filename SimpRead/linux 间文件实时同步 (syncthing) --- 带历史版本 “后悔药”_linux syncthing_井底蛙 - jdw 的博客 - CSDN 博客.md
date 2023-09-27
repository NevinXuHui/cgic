---
url: https://blog.csdn.net/qq_41355314/article/details/116694273
title: linux 间文件实时同步 (syncthing) --- 带历史版本 “后悔药”_linux syncthing_井底蛙 - jdw 的博客 - CSDN 博客
date: 2023-08-04 11:00:35
tag: 
banner: "https://images.unsplash.com/photo-1689154345860-fa9dab2f92c4?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxMTE4MDMyfA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
banner_icon: 🔖
---
# 一、概念简介

*   ## **syncthing**
    

一款开源免费的数据同步工具，基于 P2P 的跨平台文件同步工具，通过 tcp 建立设备连接，再通过 TLS 进行数据安全传输，支持公网与局域网搭建、支持单双向同步与历史版本控制 --“后悔药”**(备份机未感染情况下，历史版本理论上可以防止勒索病毒的，可惜没实战测试过)**、支持`Android`、`Linux`、`Windows`、`Mac`等系统，且服务器资源占用小。

本文以两台 [centos7](https://so.csdn.net/so/search?q=centos7&spm=1001.2101.3001.7020).8 系统配置 syncthing-1.16.1 为例，搭建局域网单向的文件实时同步机制（syncthing 并非真正意义的实时，不像 Inotify 通过监控触发，而是通过高频定时任务触发），具体配置实例如下：

<table><tbody><tr><td><p>服务器名称</p></td><td><p>IP 地址</p></td><td><p>安装工具</p></td><td><p>系统版本</p></td><td><p>同步操作目录</p></td><td><p>历史版本目录</p></td></tr><tr><td><p>源服务器</p></td><td><p>172.16.42.53</p></td><td><p>syncthing-1.16.1</p></td><td><p>centos7.8</p></td><td><p>/root/source/file</p></td><td><p>无</p></td></tr><tr><td><p>备份服务器</p></td><td><p>172.16.42.65</p></td><td><p>syncthing-1.16.1</p></td><td>centos7.8</td><td><p>/root/backup/file</p></td><td><p>/root/history/version</p></td></tr></tbody></table>

# 二、配置操作

## **1）syncthing 下载安装与启动** 

*   ### **开启** 8384 、22000 **端口防火墙 (源服务器与备份服务器)**
    

#检测防火墙状态    
systemctl status firewalld  
#开启防火墙 8384 、22000 tcp 端口若防火墙禁用的请略过命令）  
firewall-cmd --permanent --add-port=8384/tcp --zone=public  
firewall-cmd --permanent --add-port=22000/tcp --zone=public

#开启防火墙 21027、44647、37269 udp 端口  
firewall-cmd --zone=public --add-port=21027/udp --permanent  
firewall-cmd --zone=public --add-port=44647/udp --permanent  
firewall-cmd --zone=public --add-port=37269/udp --permanent

#重启防火墙  
firewall-cmd --reload

**端口说明:**

              8384 (TCP) 是 Web 访问控制端口

              22000 (TCP) 是节点访问端口

              21027 (UDP) 关于本地发现的端口

              44647 (UDP)

              37269 (UDP)

*   ### **syncthing 下载、安装 (源服务器与备份服务器)**
    

`Syncthing`官网：**[点击进入](https://syncthing.net/)**

#df -hl 查看磁盘分区空间，确定好备份存放目录（本文为演示，备份文件与历史版本文件都存放在 root 分区下）

df -hl 

#新建 syncthing 目录  
mkdir ./syncthing  
cd ./syncthing  
#下载 syncthing  
wget https://github.com/syncthing/syncthing/releases/download/v1.16.1/syncthing-linux-amd64-v1.16.1.tar.gz  
#解压缩  
tar -zxvf syncthing-linux-amd64-v1.16.1.tar.gz  
cd ./syncthing-linux-amd64-v1.16.1

*   ### **初次启动 syncthing (源服务器与备份服务器)**
    

#初次运行 syncthing  
./syncthing  
# 初次运行成功后，ctrl + c 停止运行 syncthing  
ctrl + c

结果如下，代表启动成功

![](https://img-blog.csdnimg.cn/20210512155506364.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

*   ### **修改 syncthing 配置文件  (源服务器与备份服务器)**
    

此时 syncthing 会生成默认配置文件，默认存放路径 /root/.config/syncthing/（我是 root 用户登录）

![](https://img-blog.csdnimg.cn/20210512160324943.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

#修改 syncthing 配置文件放开 ip 访问限制，syncthing 默认仅支持本机访问 web 管理端  
vi /root/.config/syncthing/config.xml  
#找到以下位置，将 127.0.0.1:8384 改成 [指定 ip]:8384 或 0.0.0.0:8384，建议指定 ip 更安全

![](https://img-blog.csdnimg.cn/20210512161647673.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

*   ### **再次启动 syncthing 并后台运行 (源服务器与备份服务器)**
    

# 后台方式运行 syncthing  
nohup syncthing &> /dev/null &

*   ### **设置 syncthing 服务开机自启 (源服务器与备份服务器)**
    

这里采用的 systemd 服务方式设置开机自启

#检测机器是否能用 systemd 服务，命令 ps aux  
#查看 pid=1 的进程是否是 / usr/lib/systemd/systemd --switched-root --system --deserialize 22  
ps aux  
#syncthing 自带有 syncthing@.service 文件  
#重名 syncthing@.service 为 syncthing@root.service（@后面改为当前系统登录的用户名，笔者是 root 用户登录, 注意你的 syncthing 安装路径）  
mv /root/syncthing/syncthing-linux-amd64-v1.16.1/etc/linux-systemd/system/syncthing@.service syncthing@root.service  
#复制 syncthing@root.service 至 / etc/systemd/system 下  
cp /root/syncthing/syncthing-linux-amd64-v1.16.1/etc/linux-systemd/system/syncthing@root.service /etc/systemd/system/  
#编辑 auto_start.service，修改 ExecStart=/usr/bin/syncthing serve --no-browser --no-restart --logflags=0 为 ExecStart= /root/syncthing/syncthing-linux-amd64-v1.16.1/syncthing serve --no-browser --no-restart --logflags=0  
vi /etc/systemd/system/syncthing@root.service

![](https://img-blog.csdnimg.cn/20210514115233108.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)


#### 这个我修改的流程：
在ubuntu下需要修改   
`mv /usr/lib/systemd/user/syncthing.service /usr/lib/systemd/user/syncthing@root.service
`

在继续systemctl  enable  syncthing@root.service


# 重启 systemd 服务, 并将 syncthing@root.service 设置开机自启动  
systemctl daemon-reload  
systemctl enable /etc/systemd/system/syncthing@root.service

## **2) syncthing 后台管理端配置文件实时同步**

*   ### **进入 web 管理端并配置用户名 / 密码  (源服务器与备份服务器)**
    

① 在浏览器输入 http:// 服务器 IP:8384 进行访问，初入 web 控制端界面如下

![](https://img-blog.csdnimg.cn/20210512203325463.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

② web 管理端默认是不做身份验证的，因此会弹出安全提示框，接下来为 web 管理端**备注设备名、配置用户名 / 密码、配置局域网本地访问模式**

![](https://img-blog.csdnimg.cn/20210512205939751.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

③ 备注设备名

![](https://img-blog.csdnimg.cn/2021051222470750.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

④ 配置用户名 / 密码

![](https://img-blog.csdnimg.cn/20210512230146172.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

⑤ 配置局域网本地发现模式

![](https://img-blog.csdnimg.cn/20210512230319323.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

⑥ 完成源服务器与备份服务器的配置后，刷新地址栏，输入刚刚配置的用户名 / 密码，界面瞬间清新

![](https://img-blog.csdnimg.cn/20210512225006481.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

*   ### ****源服务器添加备份服务器的远程设备****
    

① 查看备份服务器的设备标识 ID(记住它）

![](https://img-blog.csdnimg.cn/20210512230511398.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20210512230601867.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

② 源服务器 web 端 “**添加远程设备**”，并选中备份服务器的设备标识 ID(若没有自动刷新出来，直接拷贝进去)

![](https://img-blog.csdnimg.cn/20210512213944937.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20210512231855447.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

③ 稍等片刻后，备份服务器上会收到添加设备的请求确认弹框，点击添加并保存

![](https://img-blog.csdnimg.cn/202105122321224.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20210512232237664.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

*   ### ****配置实时同步共享文件夹****
    

① 源服务器中添加共享文件夹，并配置共享文件夹的路径

![](https://img-blog.csdnimg.cn/20210512232503769.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

## 

![](https://img-blog.csdnimg.cn/20210513104405795.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

② 再选择共享的远程设备

![](https://img-blog.csdnimg.cn/20210513104727740.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

③ 最后进行高级配置并保存：配置单向同步（仅发送）、配置实时监控扫描（默认启用）、配置完整扫描间隔（单位秒，默认 1h）

![](https://img-blog.csdnimg.cn/20210513110746446.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

④ 稍等片刻后，备份服务器会收到添加共享文件夹的请求确认框，点击添加

![](https://img-blog.csdnimg.cn/20210513110854328.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

⑤ 配置共享同步文件夹的存放路径

![](https://img-blog.csdnimg.cn/20210513111136132.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

⑥ 配置版本控制：选择简易版本控制，配置历史版本存放路径，配置同一文件历史版本的保留数量，再配置历史版本的清除间隔，本文设置的 1 年

![](https://img-blog.csdnimg.cn/20210513111258732.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20210513111836674.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

⑦ 最后进行高级配置并保存：取消实时监控（备份服务器不需要监控更改）、写大完整扫描间隔（备份机不需要完整扫描）、选择仅接收模式

![](https://img-blog.csdnimg.cn/20210513113148804.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

**综合上述完成了源服务器与备份服务器的相关配置：局域网、添加远程设备、添加同步共享文件夹、配置单向同步、配置历史版本**

![](https://img-blog.csdnimg.cn/20210513113503290.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

              

![](https://img-blog.csdnimg.cn/20210513113537799.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

# 3）测试同步效果

**本文教程演示环境，测得的同步时延大概在 10s 左右。（以下历史版本测得结果：针对的文件进行版本备份，空文件夹无版本备份）**

① 测试添加文件夹、文本（测得结果：新增数据无历史版本）

![](https://img-blog.csdnimg.cn/2021051313020840.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

② 测试删除空文件夹、文本（测得结果：空文件夹无历史版本）

![](https://img-blog.csdnimg.cn/20210513130640420.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

③ 测试重命名空文件夹、文本（测得结果：空文件夹无历史版本）

![](https://img-blog.csdnimg.cn/20210513134338765.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

④ 测试更改文本内容

![](https://img-blog.csdnimg.cn/20210513134545738.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

⑤ 测试重命名多层级含文本的文件夹（测得结果：含文本的文件夹，历史版本备份整个旧文件夹）

![](https://img-blog.csdnimg.cn/20210513132228540.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20210513131917833.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMzU1MzE0,size_16,color_FFFFFF,t_70)