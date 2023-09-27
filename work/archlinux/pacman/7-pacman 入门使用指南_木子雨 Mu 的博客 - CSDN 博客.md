---
url: https://blog.csdn.net/xuejian__/article/details/127448362
title: pacman 入门使用指南_木子雨 Mu 的博客 - CSDN 博客
date: 2023-04-20 23:19:38
tag: 
banner: "https://img-blog.csdnimg.cn/71ecd978db8c4c9d87cbf74560502372.png#pic_center"
banner_icon: 🔖
---
# [Pacman](https://so.csdn.net/so/search?q=Pacman&spm=1001.2101.3001.7020) 入门使用指南

## 前言

这篇博客只要是对 pacman 的使用做一个入门且较全面的教程

使用时建议先添加 Pacman [国内镜像源](https://so.csdn.net/so/search?q=%E5%9B%BD%E5%86%85%E9%95%9C%E5%83%8F%E6%BA%90&spm=1001.2101.3001.7020)，以提高访问速度，通过修改`/etc/pacman.d/mirrorlist`

一般来讲，pacman 后面会跟一个大写字母，有时候会跟一些小写字母来表示不同的选项，通过在大写字母后面直接跟小写字母可以选择不同的操作

可以使用`pacman -h`来查看提示  

![](https://img-blog.csdnimg.cn/71ecd978db8c4c9d87cbf74560502372.png#pic_center)

## pacman -S

`-S`选项与软件的更新和安装有关

例如，安装 [emacs](https://so.csdn.net/so/search?q=emacs&spm=1001.2101.3001.7020)，可以使用

```
sudo pacman -S emacs

```

![](https://img-blog.csdnimg.cn/c9fd79a1fd6a449dbe74b86b71e240ec.png#pic_center)

安装多个软件可以输入多个包名，用空格隔开，例

```
sudo pacman -S vim neovim

```

##### pacman -Sy

`-y`是 - S 下的一个子选项，可以同步软件包数据库，但是不会进行下载更新, 下面两种输入效果一样

```
sudo pacman -S -y
sudo pacman -Sy

```

![](https://img-blog.csdnimg.cn/188a5efd5a504adabff6c394945f10ed.png#pic_center)

效果相当于 ubuntu 或者 debian 里面的`sudo apt update`

##### pacman -Su

`-u`可以在本地已经同步的软件包数据库里面寻找可以更新的软件并进行更新

```
sudo pacman -Su

```

![](https://img-blog.csdnimg.cn/3b97b8f732a54b45bcce97b43be90a13.png#pic_center)

效果相当于 ubuntu 或者 debian 里的`sudo apt upgrade`

通常情况下，`-y`和`-u`选项会一起使用

```
sudo pacman -Syu

```

##### pacman -Ss

`-s`可以用来搜索软件，比如

```
sudo pacman -Ss emacs

```

![](https://img-blog.csdnimg.cn/dc65061af6874a8bba4d0e24dbf01fa9.png#pic_center)

同样，也可以使用正则表达式来搜索软件

##### pacman -Sw

`-w`可以只下载软件包但不进行安装，例如

```
sudo pacman -Sw emacs

```

![](https://img-blog.csdnimg.cn/4bcaeafc5a8041e3b73bdf52ca4e3078.png#pic_center)

## pacman -R

`-R`选项与软件的卸载和删除有关，可以使用下面的命令来卸载软件

```
sudo pacman -R emacs

```

![](https://img-blog.csdnimg.cn/d870b1b174e44da6bdef133112f56b5f.png#pic_center)

##### pacman -Rs

`-s`可以删除只有这个软件包依赖的其他软件包，通常情况下建议使用`-Rs`

```
sudo pacman -Rs emacs

```

![](https://img-blog.csdnimg.cn/0e8e35f39ef54e5ab46adead0f3ad4ab.png#pic_center)

可以看到，使用`Rs`时多删除了依赖

##### pacman -Rn

`-n`选项可以删除安装软件是添加的配置文件，但是安装完成后用户自己添加的配置文件不会被删除

```
sudo pacman -Rns emacs

```

## pacman -Q

`-Q`选项是在本机搜索程序，使用`sudo pacman -Q`会默认列出电脑里所有安装的软件  

![](https://img-blog.csdnimg.cn/2839b697b4bc4f3f952cdbf94ad194e1.png#pic_center)

##### pacman -Qe

`-Q`可以显示安装的所有软件，但是其中大部分是作为依赖被安装的，我们可以使用`-e`来显示用户自己安装的软件

```
sudo pacman -Qe

```

![](https://img-blog.csdnimg.cn/b62f4ba69d2c4fb4aeaa319227c4a84b.png#pic_center)

可以看到，使用`-Qe`输出的数量会少很多

##### pacman -Qq

`-q`可以只输出文件名，而忽略版本号或其他的一些信息

```
sudo pacman -Qq

```

也可以使用`sudo pacman -Qq >> package.txt`将输出保存在一个文件里，重装系统的时候就可以批量安装这些软件

##### Pacman -Qs

查找已经安装的程序，比如

```
sudo pacman -Qs neovim

```

![](https://img-blog.csdnimg.cn/ab1880259a204a4bb69758daedb45929.png#pic_center)

##### pacman -Qm

列出所有从 AUR 上获取的软件

##### pacman -Qdt

`sudo pacman -Qdt`可以列出本机已经不需要的依赖