---
url: https://zhuanlan.zhihu.com/p/388400709
title: Archlinux 安装简记 Xfce + Btrfs 2021_07
date: 2023-04-20 08:49:39
tag: 
banner: "https://picx.zhimg.com/v2-74db36256161ffc8b88b9249f52be13b_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
## 一、开始安装

### 联网

```
iwctl                                           # 进入 iwd 命令行
[iwd#] device list                              # 查询网卡设备
[iwd#] station <devicename> scan
[iwd#] station <devicename> get-networks        # 扫描并显示可用 WiFi 热点
[iwd#] station <devicename> connect <wifi-ssid> # 连接 WiFi，如果有密码会提示输入
[iwd#] exit                                     # 退出 iwd
dhcpcd                                          # 获取 ip

```

### 更新系统时间

```
timedatectl set-ntp true
timedatectl status

```

### 磁盘分区及 Btrfs 子卷划分

首先查看待分区磁盘设备

```
fdisk -l

```

磁盘名通常为 `/dev/sdx` 或 `/dev/nvme0nx` ，以 `sda` 为例

```
fdisk /dev/sda

```

### 分区建议

*   `/dev/sda1` 512MB EFI 分区
*   `/dev/sda2` 2G 或与内存容量相等的 SWAP 分区
*   `/dev/sda3` 其余容量分给 Btrfs 主数据分区

### 格式化分区

```
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.btrfs -f /dev/sda3

```

### 初始化子卷

```
mount /dev/sda3 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
chattr +C /mnt/@var
umount /mnt

```

可以根据个人需求再划分几个子卷，推荐为 var 目录禁用写时复制

### 挂载文件系统

```
mount /dev/sda3 /mnt -o subvol=@
mkdir /mnt/boot
mkdir /mnt/home
mkdir /mnt/var
mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt/home -o subvol=@home
mount /dev/sda3 /mnt/var -o subvol=@var
swapon /dev/sda2
lsblk                     # 检查挂载情况

```

### 安装基本系统

目前 archiso 会自动运行 reflector 获取最快镜像源，完成后直接进行系统安装即可

```
pacstrap /mnt base base-devel linux linux-firmware nano btrfs-progs

```

Intel CPU 追加 `intel-ucode` ，AMD 则为 `amd-ucode` ，也可以之后再安装

生成 fstab

```
genfstab -U /mnt >> /mnt/etc/fstab

```

进入到安装的系统

```
arch-chroot /mnt

```

## 二、配置系统

### 时区

```
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

```

### 本地化

```
nano /etc/locale.gen            # 取消注释 en_US.UTF-8 和 zh_CN.UTF-8
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'myhostname' > /etc/hostname
nano /etc/hosts                 # 添加如下内容
  127.0.0.1  localhost
  ::1        localhost
  127.0.1.1  myhostname.localdomain myhostname

```

### 设置密码

记得别忘了

```
passwd

```

### 安装网络管理程序

```
pacman -S networkmanager
systemctl enable NetworkManager

```

### 配置 Btrfs

```
nano /etc/mkinitcpio.conf        # 在 MODULES=() 中添加 btrfs
mkinitcpio -P

```

### 安装引导程序

```
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg

```

基本安装到这里就结束了，可以重启检查一下安装成果，也可以直接继续配置

```
exit            # 退出 chroot
umount -R /mnt  # 卸载硬盘
reboot          # 重启

```

## 三、配置桌面环境

重启后可以使用 `nmcli device wifi connect <ssid> password <password>` 连接网络

继续配置系统

### 添加用户

```
useradd -m -G wheel 用户名
passwd 用户名
EDITOR=nano visudo  # 取消注释 %wheel ALL=(ALL) ALL

```

### 安装显卡驱动和图形加速支持

```
# 根据显卡选择，分别为 Intel, AMD, NVIDIA
pacman -S mesa xf86-video-intel intel-media-driver libva-intel-driver
pacman -S mesa xf86-video-amdgpu xf86-video-ati libva-mesa-driver mesa-vdpau
pacman -S mesa xf86-video-nouveau libva-mesa-driver mesa-vdpau

```

### 安装音频

```
pacman -S pipewire pipewire-alsa pipewire-jack pipewire-pulse pipewire-media-session gst-plugin-pipewire

```

### 安装桌面

```
pacman -S xorg
pacman -S xfce4 xfce4-goodies

```

以及登陆管理器

```
pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
systemctl enable lightdm

```

如果重启后 lightdm 加载失败，尝试修改 `/etc/lightdm/lightdm.conf`

```
[LightDM]
logind-check-graphical=true

```

安装常用服务

```
pacman -S accountsservice gvfs network-manager-applet ntfs-3g xdg-utils xdg-user-dirs gnome-keyring

```

安装浏览器

```
pacman -S firefox firefox-i18n-zh-cn

```

安装常用软件

```
pacman -S git wget htop zsh

```