我选择第2种方法，具体操作如下：

1、按 Win + R 组合键，打开运行，在运行窗口中输入：compmgmt.msc 命令，确定或回车，打开磁盘管理器；

2、打开存储\磁盘管理，右键点击”磁盘管理“，选择”创建VHD“，位置选择D盘，虚拟硬盘格式选择”VHDX“，其他自己设置，然后点”确定“；

3、通过DiskGenius5.4等工具，把虚拟磁盘格式化成ext4文件系统；

4、打开PowerShell，输入wmic diskdrive list brief，找到刚才创建的”Microsoft 虚拟磁盘“的DeviceID，我的是”\\.\PHYSICALDRIVE1“；

5、在PowerShell中，输入wsl --mount \\.\PHYSICALDRIVE1 --partition 1；

6、在PowerShell中，输入 wsl --user root，进入linux。我们的虚拟磁盘就可以通过路径/mnt/wsl/PHYSICALDRIVE1p1/访访问了。

重新把开发代码部署在/mnt/wsl/PHYSICALDRIVE1p1/路径下，经过性能比较，比在windows下单独部署开发环境的速度还要快，问题解决。

启动wsl2+Ubuntu20.04+vscode+docker开发环境批处理文件内容，通过此批处理，可以方便快速访问开发环境，包括网卡配置，注意需要以管理员权限运行：


```
@echo off 
setlocal enabledelayedexpansion
wsl --mount  \\.\PHYSICALDRIVE1 --partition 1
wsl -u root service docker start | findstr "Starting Docker" > nul
if !errorlevel! equ 0 ( 
   echo docker start success  
   rem set wsl2 ip   
   wsl -u root ip addr | findstr "192.168.2.2" > nul
   if !errorlevel! equ 0 (  
      echo wsl ip has set    
   ) else ( 
        wsl -u root ip addr add 192.168.2.2/28 broadcast 192.168.2.15 dev eth0 label eth0:1 
       echo set wsl ip success: 192.168.2.2
    )    
    rem set windows ip
    ipconfig | findstr "192.168.2.1" > nul
    if !errorlevel! equ 0 (
       echo windows ip has set
    ) else ( 
        netsh interface ip add address "vEthernet (WSL)" 192.168.2.1 255.255.255.240
        echo set windows ip success: 192.168.2.1
    )
    rem start docker's command
    wsl -u root docker exec -d containername /root/auto.sh
)
pause
```
