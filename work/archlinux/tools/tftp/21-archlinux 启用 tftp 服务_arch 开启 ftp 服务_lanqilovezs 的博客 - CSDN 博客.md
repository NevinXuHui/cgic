---
url: https://blog.csdn.net/lanqilovezs/article/details/12144829
title: archlinux 启用 tftp 服务_arch 开启 ftp 服务_lanqilovezs 的博客 - CSDN 博客
date: 2023-05-09 21:55:03
tag: 
banner: "undefined"
banner_icon: 🔖
---
好像跟 2410 移植的问题颇多，还是先把刚完成的 TFTP 主机服务端的配置的过程写下来把, 虽然配置起来很简单！

主机 OS：  archlinux 应该有升级到最新 （这里吐个槽, 不的不说 arch 确实很适合我这种人，前期稍微花点时间配置下，后期使用起来无比的顺手啊，并且是滚动更新，不用每次重装，一劳永逸啊 ^_^）

服务：tftp 服务

目的：用于从主机下载内核到目标版的 SDRAM 中，省去了每次跟新了内核的都要烧写 NAND FLASH 的烦恼。

 

安装步骤：

1. 安装 tftp 服务端

yaourt -S tftp-hpa 

2. 编辑 / etc/hosts.allow

添加

 

 tftpd:ALL  
   in.tftpd:ALL

  
3. 修改默认的 tftp 的目录，

sudo vim /etc/conf.d/tftpd    
  
TFTPD_ARGS="-l -s /home/shenhao/kernel.git/arch/arm/boot/"   
  
为我将要下载的 uImage 编译后所在的路径  
  
4. 修改 tftp 的跟目录的权限  
  

sudo chmod 755 /home/shenhao/kernel.git/arch/arm/boot -R

  
  
5. 启动

tftp 服务   
  
sudo /etc/rc.d/tftpd start 

6. 测试

  

[shenhao@myhost u-boot-1.2.0]$ tftp 127.0.0.1  
tftp> get uImage  
tftp> quit  
[shenhao@myhost ~]$ ls -l uImage  
-rw-r--r-- 1 shenhao users 1671288  5 月 11 13:54 uImage  
[shenhao@myhost ~]$   
  
总的来说 tftp 还是很简单的，不过却很实用