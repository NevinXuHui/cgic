---
url: https://www.jianshu.com/p/73299b8e3f58
title: Manjaro 修改主目录为英文 - 简书
date: 2023-05-26 15:52:40
tag: 
banner: "https://upload.jianshu.io/users/upload_avatars/4278813/b5c92678-8573-4c3a-9fef-8bcffb93aac4.png"
banner_icon: 🔖
---
由于经常在终端要操作家目录，中文切换输入法打字很浪费时间，于是把 HOME 目录改为英文很方便，在网上看了很多都是修改映射文件，但是会出错而且不生效，找到了下面的方法：

```
$ sudo pacman -S xdg-user-dirs-gtk
$ export LANG=en_US
$ xdg-user-dirs-gtk-update
$ #然后会有个窗口提示语言更改，更新名称即可
$ export LANG=zh_CN.UTF-8
$ #然后重启电脑如果提示语言更改，保留旧的名称即可


```