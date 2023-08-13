前面发了一篇文章：[Ubuntu：修改网卡的 MAC 地址](http://www.blogjava.net/yeeyang/articles/ubuntu_changeMAC_1.html)，最后提到了重启后 MAC 地址会还原的问题，本文将介绍如何永久修改 MAC 地址（当然不能重装系统，也不是 “硬改” 网卡的 MAC 地址）。

方法一：

    1）编辑 “/etc/init.d/rc.local” 文件（sudo gedit /etc/init.d/rc.local）

    2）在此配置文件的最后面加上如（

[Ubuntu：修改网卡的 MAC 地址](http://www.blogjava.net/yeeyang/articles/ubuntu_changeMAC_1.html)）的修改命令：

## 修改 eth0 的 MAC 地址

         sudo ifconfig eth0 down
         sudo ifconfig eth0 hw ether AA:BB:CC:DD:EE:FF
         sudo ifconfig eth0 up

方法二：

    1）编辑 “/etc/network/interfaces” 文件（sudo gedit /etc/network/interfaces）

    2）在此配置文件中找到 “iface eth0 inet static” 行，在其后面加上 “hwaddress ether AA:BB:CC:DD:EE:FF”，如何没有这一行，则自己手动完整添加

