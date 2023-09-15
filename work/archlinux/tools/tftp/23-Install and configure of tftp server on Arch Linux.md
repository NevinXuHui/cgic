---
banner: "https://k-2.space/images/AVT256.jpg"
---
---
url: https://k-2.space/2018/04/install-and-configure-of-tftp-server-on-arch-linux/
title: Install and configure of tftp server on Arch Linux
date: 2023-05-09 21:55:53
tag: 
banner: "https://k-2.space/images/AVT256.jpg"
banner_icon: 🔖
---
*   [About tftp](#about-tftp)
*   [Install of tftp server](#install-of-tftp-server)
*   [Configure](#configure)
*   [Start service](#start-service)
*   [Testing](#testing)

TFTP (Trivial File Transfer Protocol) - main usage is booting of OS for disk-less network devices or workstations.

But, this protocol is used to load a binary file of firmware to embedded devices very often too.

For example: tftp is used to initial flash of OpenWrt firmware to some models of routers.

Arch Linux is used on my PC, but there are no significant differences for installing and configuring of the tftp server on other Linux OS

There are some implementations of tftp server. tftp-hpa application is lightweight and quite simple for configuring.

_Install_

```
pacman -S tftp-hpa


```

To modify service parameters edit /etc/conf.d/tftpd. Configuration file has a simple KEY=VALUE format.

_Example of configuration file_

```
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="--secure /srv/tftp/"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="--secure"


```

Use option –create to allow new files to be created. By default, tftpd will only allow upload of files that already exist.

```
TFTP_OPTIONS="--secure --create"


```

There is possibility to set all parameters using one row

```
TFTPD_ARGS="--secure /srv/tftp/"


```

More information about parameters for tftp-hpa service [here](https://linux.die.net/man/8/tftpd)

```
sudo systemctl start tftpd


```

You can create a file in the tftp server directory and download it using any tftp client.

```
cd /srv/tftp/
sudo echo "TEST!!!" > test.test

cd ~
tftp 192.168.1.1 -c get test.txt


```

here 192.168.1.1 - ip of tftp server.

If you are using firewall, do not forget to open tftp port.