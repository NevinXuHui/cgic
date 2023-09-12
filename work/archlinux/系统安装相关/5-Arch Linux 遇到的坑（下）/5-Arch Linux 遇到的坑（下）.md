---
url: https://zhuanlan.zhihu.com/p/466284397
title: Arch Linux 遇到的坑（下）
date: 2023-04-16 17:57:13
tag: 
banner: "https://pic1.zhimg.com/v2-1024b795f4494c7c2029b2dea6a223a5_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
![](1681639033860.png)

明天就要开学，赶忙又熟悉了新环境的用法，现在已经基本满足了日常需求，再记录一些坑～。

## **电脑没有声音**

因为上次离奇的自己好了，我就没有再管了，但是后来使用 chrome 的时候还是没有声音，我就用了图形化界面 pavucontrol，设置了播放的声道就好了。

![](1681639033958.png)

## **截图工具**

我对截图工具的需求主要是快捷键截完图之后可以复制到剪贴板中，然后我直接粘贴到 markdown 文档中，试了几个软件后发现 deepin-screen-recorder 和 flameshot（使用`flameshot gui`命令截图）比较符合我的需求。

## **给 dwm 打 patch**

参照[知乎博客 入坑 dwm——原来窗口管理器还可以这样用？！](https://zhuanlan.zhihu.com/p/183861786)给自己的 dwm 打上了下面两个 patch

```
actualfullscreen      #让程序开启全屏时做到“真正的”全屏显示
​
alpha    #alpha补丁使dwm的菜单栏变透明，与美化有关；

```

由于补丁文件问题，打 alpha 补丁的时候失败了，结果类似于下面的提示

```
Hunk #1 FAILED at 202.
1 out of 1 hunk FAILED -- saving rejects to file drw.c.rej

```

这时候就需要进入 diff 文件进行手动修改。

为了令 dwm 右上角显示时间（最基本需求），我参照了 wiki 给自己的. xinitrc 添加了下面的句子

```
fcitx5 &
~/.fehbg &
picom -b
​
while true
do
        VOL=$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')
        LOCALTIME=$(date +%Z\="%Y-%m-%d %H:%M")
        #OTHERTIME=$(TZ=Europe/London date +%Z\=%H:%M)
        IP=$(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1) # can get confused if you use vmware
        TEMP="$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))C"
    if acpi -a | grep off-line > /dev/null
    then
            BAT="Bat. $(acpi -b | awk '{ print $4 " " $5 }' | tr -d ',')"
            xsetroot -name "$IP $BAT $VOL $TEMP $LOCALTIME "
    else
            xsetroot -name "$IP $VOL $TEMP $LOCALTIME "
    fi
    sleep 20s
done &
​
exec dwm

```

效果如下

![](1681639034048.png)

## **设置桌面**

设置桌面使用参照 [wiki](https://link.zhihu.com/?target=https%3A//wiki.archlinux.org/title/feh) 下载 feh 进行设置，然后通过下面命令设置桌面背景

```
$ feh --bg-scale /path/to/image.file

```

为了每次 startx 自己设置，记得将下面的语句加入. xinitrc 文件中

```
~/.fehbg &

```

## **设置一些快捷键**

快捷键的设置主要修改 dwm 的 config.def.h，主要是将命令行参数写成下面 cmd 结尾的字符串数组，然后在 keys 中定义对应的快捷键即可，这里主要设置了几个常用的快捷键。修改完毕后在 dwm 目录下删除 config.def.h，重新`sudo make clean install`即可

![](1681639034121.png)

## **st 半透明**

st 半透明一般需要 picom 的支持，安装 picom 之后，输入命令 picom -b 在后台运行 picom，修改. config/picom/picom.conf 配置文件中的 opacity-rule，添加 "80:name ='st'"，令终端透明即可（我不是很喜欢其他页面也透明）

![](1681639034197.png)

## **ranger 简单配置**

### **预览图片和 pdf**

我对 ranger 还不是很熟悉，就简单修改了一下预览功能。

首先输入命令

```
ranger --copy-config=all

```

把 ranger 配置文件拷贝到. config 下

这个时候 ranger 就会生成配置文件目录~/.config/ranger，下面主要有这样几个文件：

```
rc.conf     - 选项设置和快捷键
commands.py - 能通过 : 执行的命令
rifle.conf  - 指定不同类型的文件的默认打开程序。
scope.sh    - 用于指定预览程序的文件

```

根据 [wiki](https://link.zhihu.com/?target=https%3A//github.com/ranger/ranger/wiki/Image-Previews) 中选择 w3m 进行预览图片，但显示有问题，于是安装了 ueberzug，可以正常显示图像了。（记得根据 wiki 修改 rc.conf，在末尾添加下面两行）

```
set preview_images true
set preview_images_method ueberzug

```

pdf 预览需要取消 scope.sh 中下面几行

![](1681639034265.png)

然后安装 pdftoppm

```
pacman -S poppler

```

### **默认打开软件**

参照[知乎博客 ranger 的配置与使用](https://zhuanlan.zhihu.com/p/105731111)，为了用 wps 默认打开 doc、pdf 和 xlsx，我在 rifle.conf 中添加了下面四行，这样按下 enter 键便可以直接用 wps 打开文件。

```
ext md, has typora,     X, flag f = typora "$@"
ext pdf, has wpspdf,     X, flag f = wpspdf "$@"
ext docx?, has wps,       terminal = wps -- "$@" | "$PAGER"
ext pptx?|od[dfgpst]|docx?|sxc|xlsx?|xlt|xlw|gnm|gnumeric, has wpp,     X, flag f = wpp "$@"


```

### **快捷键配置**

在 rc.conf 文件后面添加

```
map DD shell trash %s

```

即可实现用”DD” 将当前所选文件放到 trash-bin 中去.

## **切换显示位置**

由于我有两个显示屏，但 dwm 识别的时候识别反了，导致我在不同显示屏中移动鼠标时有些反直觉，所以，可以用下面 xrandr 命令查看屏幕输出

```
$ xrandr
Screen 0: minimum 320 x 200, current 3840 x 1080, maximum 16384 x 16384
eDP-1 connected primary 1920x1080+1920+0 (normal left inverted right x axis y axis) 344mm x 194mm
   1920x1080     60.00*+  59.97    59.96    59.93
   1680x1050     59.95    59.88
   1400x1050     59.98
   1600x900      59.99    59.94    59.95    59.82
   1280x1024     60.02
   1400x900      59.96    59.88
   1280x960      60.00
   1440x810      60.00    59.97
   1368x768      59.88    59.85
   1280x800      59.99    59.97    59.81    59.91
   1280x720      60.00    59.99    59.86    59.74
   1024x768      60.04    60.00
   960x720       60.00
   928x696       60.05
   896x672       60.01
   1024x576      59.95    59.96    59.90    59.82
   960x600       59.93    60.00
   960x540       59.96    59.99    59.63    59.82
   800x600       60.00    60.32    56.25
   840x525       60.01    59.88
   864x486       59.92    59.57
   700x525       59.98
   800x450       59.95    59.82
   640x512       60.02
   700x450       59.96    59.88
   640x480       60.00    59.94
   720x405       59.51    58.99
   684x384       59.88    59.85
   640x400       59.88    59.98
   640x360       59.86    59.83    59.84    59.32
   512x384       60.00
   512x288       60.00    59.92
   480x270       59.63    59.82
   400x300       60.32    56.34
   432x243       59.92    59.57
   320x240       60.05
   360x202       59.51    59.13
   320x180       59.84    59.32
HDMI-1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 527mm x 296mm
   1920x1080     60.00*+  50.00    59.94
   1920x1080i    60.00    50.00    59.94
   1680x1050     59.88
   1280x1024     75.02    60.02
   1440x900      59.90
   1280x960      60.00
   1280x720      60.00    50.00    59.94
   1024x768      75.03    70.07    60.00
   832x624       74.55
   800x600       72.19    75.00    60.32    56.25
   720x576       50.00
   720x480       60.00    59.94
   640x480       75.00    72.81    66.67    60.00    59.94
   720x400       70.08
DP-1 disconnected (normal left inverted right x axis y axis)
DP-2 disconnected (normal left inverted right x axis y axis)
​

```

可以看到我一个是 eDP-1，另一个是 HDMI-1，我想要 HDMI-1 识别到 eDP-1 的左边，用下面命令即可

```
xrandr --output HDMI-1 --auto --left-of eDP-1

```