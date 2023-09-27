---
url: https://blog.csdn.net/qq_38744125/article/details/113668087
title: Archlinux 启用休眠。亲测可用。参考 archlinux wiki 整理而来。休眠到交换分区_archlinux 休眠_MIC_SAMA 的博客 - CSDN 博客
date: 2023-04-28 08:57:06
tag: 
banner: "undefined"
banner_icon: 🔖
---
首先介绍一下三种挂起方式 。我是用的是第二种方式。目的是为了不用每次开机都重新打开很多软件再排布成我需要的样子。毕竟写项目经常就是开 2 个 nvim 编辑代码，2 个 chrome，ssh 远程控制服务器，mycli 处理 mysql 数据库等等。虽然休眠到硬盘可能会稍微影响到硬盘的寿命，但是一切都是可以接受的，硬盘是买来用的。以上。

*   suspend 挂起, 待机, 暂停 (str: suspend to RAM) 保存到内存 通电 低功耗
*   hibernate 休眠, 冬眠 (std: suspend to disk) 保存至硬盘 swap 断电 关机
*   HybridSleep 混合睡眠 (strd:suspend to both) 保存到内存和硬盘 通电 低功耗

### .

1.  在 bootloader 中增加 resume 内核参数，编辑`/etc/default/grub`文件，在`GRUB_CMDLINE_LINUX_DEFAULT`中添加`resume=swap_drvice`  
    swap_drvice 用你的 swap 设备代替。我是这样的：

```
更改前：GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"
更改后：GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet resume=/dev/sda6"
更新grub： $ sudo grub-mkconfig -o /boot/grub/grub.cfg

```

2.  添加 resume 钩子 编辑 /etc/mkinitcpio.conf ，在 HOOKS 行中添加 resume 钩子：

```
注意: 如果使用lvm分区，需要将resume放在lvm后面
lvm分区: HOOKS=(base udev autodetect modconf block lvm2 resume filesystems keyboard fsck)
我的情况：
原本是: HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)
添加后: HOOKS=(base udev resume autodetect modconf block filesystems keyboard fsck)

再重新生成mkinitcpio   
$ sudo mkinitcpio -p linux-zen
(我使用的内核是linux-zen,如果你们是普通内核就换成linux，否则换成自己的内核)
可以用 ls /etc/mkinitcpio.d/ 查询自己的能用内核

```

以下内容参考如下：  
https://github.com/levinit/itnotes/blob/master/linux/laptop 笔记本相关. md

编辑 `/etc/systemd/logind.conf` 根据自己的需求进行修改，取消注释。  
#NAutoVTs=6  
#ReserveVT=6  
#KillUserProcesses=no  
#KillOnlyUsers=  
#KillExcludeUsers=root  
#InhibitDelayMaxSec=5  
#HandlePowerKey=poweroff #按下电源键  
#HandleSuspendKey=suspend #按下挂起键 HandleSleepKey  
#HandleHibernateKey=[hibernate](https://so.csdn.net/so/search?q=hibernate&spm=1001.2101.3001.7020) #按下休眠键  
#HandleLidSwitch=suspend #合上笔记本盖  
#HandleLidSwitchExternalPower=suspend  
#HandleLidSwitchDocked=ignore #插上扩展坞或者连接外部显示器情况下合上笔记本盖子  
#PowerKeyIgnoreInhibited=no  
#SuspendKeyIgnoreInhibited=no  
#HibernateKeyIgnoreInhibited=no  
#LidSwitchIgnoreInhibited=yes  
#HoldoffTimeoutSec=30s  
#IdleAction=ignore  
#IdleActionSec=30min  
#RuntimeDirectorySize=10%  
#RemoveIPC=yes  
#InhibitorsMax=8192  
#SessionsMax=8192

poweroff 和 halt 均是关机（具体实现有区别）  
supspend 是挂起（暂停），设备通电，内容保存在内存中  
hybernate 是休眠，设备断电（同关机状态），内容保存在硬盘中  
hybridSleep 是混合睡眠，设备通电，内容保存在硬盘和内存中  
lock 是锁屏  
kexec 是从当前正在运行的内核直接引导到一个新内核（多用于升级了内核的情况下）  
ignore 是忽略该动作，即不进行任何电源事件响应