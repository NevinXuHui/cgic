---
url: https://blog.csdn.net/JUSTfFUN/article/details/122742474
title: ArchLinux 安装 deb 包_archlinux deb-CSDN 博客
date: 2023-05-05 18:42:22
tag: 
banner: "undefined"
banner_icon: 🔖
---
### Arch[Linux 安装](https://so.csdn.net/so/search?q=Linux%E5%AE%89%E8%A3%85&spm=1001.2101.3001.7020) deb 包

*   [方法一 ：使用 debtap](#_debtap_2)
*   [方法二 ： 使用 dpkg](#__dpkg_16)

# 方法一 ：使用 debtap

1.  安装 debtap
2.  更新 debtap 数据库
3.  使用 debtap 转换包
4.  sudo pacman -U 转换后的包名

```
yay -s debtap
sudo debtap -u
debtap .deb包名
sudo pacman -U 	转换后的包名

```

# 方法二 ： 使用 [dpkg](https://so.csdn.net/so/search?q=dpkg&spm=1001.2101.3001.7020)

1.  安装 dpkg
2.  使用 dpkg 安装 deb 包

```
yay -S dpkg
dpkg -i .deb包名

```