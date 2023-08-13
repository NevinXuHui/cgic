---
url: https://cloud.tencent.com/developer/article/1515208
title: Linux 系统设置 ： dircolors 命令详解 - 腾讯云开发者社区 - 腾讯云
date: 2023-04-24 20:49:14
tag: 
banner: "undefined"
banner_icon: 🔖
---
dircolors 命令设置 ls 命令在显示目录或文件时所用的色彩。dircolors 可根据 [色彩配置文件] 来设置 LS_COLORS 环境变量或是显示设置 LS_COLORS 环境变量的命令。

### 语法

### 选项

```
-b或--sh或--bourne-shell：显示在Boume shell中，将LS_COLORS设为目前预设置的shell指令；

-c或--csh或--c-shell：显示在C shell中，将LS_COLORS设为目前预设置的shell指令；

-p或--print-database：显示预设置；

-help：显示帮助；

-version：显示版本信息。


```

如果知道了不同颜色分别代表的含义，那么对于我们查看目录下文件信息方便了很多，所以就搜索了一下相关文章，找到一篇，如下所示：

```
# Attribute codes: 字符属性
# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
#00无 01粗体 04下划线 05闪烁 07反转 08隐藏
# Text color codes: 字符颜色
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
#30黑 31红 32绿 33黄 34蓝 35粉红 36淡蓝 37白
# Background color codes: 字符背景色
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
#40黑 41红 42绿 43黄 44蓝 45粉红 46淡蓝 47白
NORMAL 00 # global default, although everything should be something. 普通文件 终端默认颜色
FILE 00 # normal file 普通文件 终端默认颜色
DIR 01;34 # directory 目录 粗体-蓝字
LINK 01;36 # symbolic link. (If you set this to ‘target’ instead of a 符号链接 粗体-淡蓝字
# numerical value, the color is as for the file pointed to.)
FIFO 40;33 # pipe 管道API 黑底-黄字
SOCK 01;35 # socket 套接字API 粗体-粉红字
DOOR 01;35 # door 门API 粗体-粉红字
BLK 40;33;01 # block device driver 块设备驱动 粗体-黑底-黄字
CHR 40;33;01 # character device driver 字符设备驱动 粗体-黑底-黄字
ORPHAN 40;31;01 # symlink to nonexistent file 指向文件不存在的符号链接 粗体-黑底-红字
SETUID 37;41 # file that is setuid (u+s) 指定UID的文件 红底-白字
SETGID 30;43 # file that is setgid (g+s) 指定GID的文件 黄底-黑字
STICKY_OTHER_WRITABLE 30;42 # dir that is sticky and other-writable (+t,o+w) +t,o+w权限的文件 绿底-黑字(不常用)
OTHER_WRITABLE 34;42 # dir that is other-writable (o+w) and not sticky -t,o+w权限的文件 绿底-蓝字(不常用)
STICKY 37;44 # dir with the sticky bit set (+t) and not other-writable +t,o-w权限的文件 蓝底-白字(不常用)
# This is for files with execute permission:
EXEC 01;32 有执行权限的文件 粗体-绿字
# List any file extensions like ‘.gz’ or ‘.tar’ that you would like ls
# to colorize below. Put the extension, a space, and the color init string.
# (and any comments you want to add after a ‘#’)
# If you use DOS-style suffixes, you may want to uncomment the following:
#.cmd 01;32 # executables (bright green) .cmd可执行文件 粗体-绿字(亮)
#.exe 01;32 .exe文件 粗体-绿字
#.com 01;32 .com文件 粗体-绿字
#.btm 01;32 .btm文件 粗体-绿字
#.bat 01;32 .bat文件 粗体-绿字
.tar 01;31 # archives or compressed (bright red) .tar压缩文件 粗体-红字(亮)
.tgz 01;31 .tgz文件 粗体-红字
.arj 01;31 .arj文件 粗体-红字
.taz 01;31 .taz文件 粗体-红字
.lzh 01;31 .lzh文件 粗体-红字
.zip 01;31 .zip文件 粗体-红字
.z 01;31 .z文件 粗体-红字
.Z 01;31 .Z文件 粗体-红字
.gz 01;31 .gz文件 粗体-红字
.bz2 01;31 .bz2文件 粗体-红字
.deb 01;31 .deb文件 粗体-红字
.rpm 01;31 .rpm文件 粗体-红字
.jar 01;31 .jar文件 粗体-红字
# image formats
.jpg 01;35 .jpg图片 粗体-粉红字
.jpeg 01;35 .jpeg图片 粗体-粉红字
.gif 01;35 .gif图片 粗体-粉红字
.bmp 01;35 .bmp图片 粗体-粉红字
.pbm 01;35 .pbm 图片 粗体-粉红字
.pgm 01;35 .pgm图片 粗体-粉红字
.ppm 01;35 .ppm图片 粗体-粉红字
.tga 01;35 .tga图片 粗体-粉红字
.xbm 01;35 .xbm图片 粗体-粉红字
.xpm 01;35 .xpm图片 粗体-粉红字
.tif 01;35 .tif图片 粗体-粉红字
.tiff 01;35 .tiff图片 粗体-粉红字
.png 01;35 .png 图片 粗体-粉红字
.mov 01;35 .mov视频 粗体-粉红字
.mpg 01;35 .mpg视频 粗体-粉红字
.mpeg 01;35 .mpeg视频 粗体-粉红字
.avi 01;35 .avi视频 粗体-粉红字
.fli 01;35 .fli视频 粗体-粉红字
.gl 01;35 .gl视频 粗体-粉红字
.dl 01;35 .dl视频 粗体-粉红字
.xcf 01;35 .xcf视频 粗体-粉红字
.xwd 01;35 .xwd视频 粗体-粉红字
# audio formats
.flac 01;35 .flac音频 粗体-粉红字
.mp3 01;35 .mp3音频 粗体-粉红字
.mpc 01;35 .mpc音频 粗体-粉红字
.ogg 01;35 .ogg音频 粗体-粉红字
.wav 01;35 .wav音频 粗体-粉红字

PS: 文件可执行权限的颜色显示优先于文件可读写权限


```

颜色着实不少，可以记几个常用的，保存起来留着以后查阅使用。

其实呢，使用 dircolor 命令就可以显示文件名颜色设置了 (dircolor -p)(它还可以设置)。

关于如何修改，同样找到下面一篇文章：

1. 利用 dircolors 命令，查看我们的系统当前的文件名称显示颜色的值，然后利用管道重定向到用户目录下的任意一个文件（这里我们创建了一个. dir_colors 文件）

命令 1：cd ~

命令 2：dircolors -p > .dir_colors

2. 用 vim 打开. dir_colors 文件，然后找到 “DIR 01;34” // 这里的 01 表示高亮度显示，34 表示蓝色，33 表示黄色

修改为 “DIR 01;33”，保存退出

3. 为了将修改之后的配置文件导入到 dircolors 中，我们采取如下的方案

打开用户目录下的. bashrc 文件，找到类似 “eval ‘dircolors -b ‘”（如果没有自行添加），

修改为 eval ‘dircolors -b .dir_colors’ 保存退出 // 这里的. dir_colors 就是我们前面自己创建的文件

4. 为了让修改生效 source ~/.bashrc