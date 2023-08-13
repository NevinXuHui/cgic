---
url: https://www.jianshu.com/p/4a62c38bec7e
title: Linux 下快速搜索文件（类似 Everything） - 简书
date: 2023-04-25 10:09:34
tag: 
banner: "http://upload-images.jianshu.io/upload_images/137499-2dd6615aaba82316.png"
banner_icon: 🔖
---
Linux 下一直没有类似 Everything 的软件已经不是什么新鲜事了。不信你去百度 “linux everything”，结果一大堆，但最后的体验结果都是不尽人意。主要是索引速度上不能满足大家。

Linux 下的软件在不断诞生完善，我也再一次整理了有关文件快速搜索的工具，希望对你有帮助咯。

# 老将们

#### locate

因为不怎么好用，但是比较简单而且古老，所以放在前面。

```
sudo apt install locate


```

然后更新索引：

```
updatedb


```

最后你就可以使用这个命令搜索文件了：

```
$ locate -b -i "*lamport*pdf*"


```

有一个对这个命令封装的 Python 脚本：  
[https://github.com/liancheng/found/blob/master/found](https://link.jianshu.com?t=https://github.com/liancheng/found/blob/master/found)

#### Catfish

这个也是老将。Catfish 已被大多数流行的 Linux 发行版所收录，因此，你只需通过所用发行版的包管理工具即可安装。如果你对 Catfish 的源代码感兴趣，那么也可从作者的[网站](https://link.jianshu.com?t=http://software.twotoasts.de/index.php?/pages/catfish_summary.html)获取。  
但本质上 Catfish 搜索文件也只是调用 find、locate、slocate 等命令。Catfish 可设定不同的搜索条件，如精确匹配、搜索隐藏文件、全文搜索、限制搜索结果数量等。此外，也可选择要执行搜索的目录，并对搜索结果执行相应操作。

#### Tracker

一个 Gnome 下的项目，不单纯是个搜索工具，它要做的是搜索引擎、搜索工具和元数据存储系统，数据组织、存储、分类的一站式解决方案。  
地址：[https://wiki.gnome.org/Projects/Tracker/](https://link.jianshu.com?t=https://wiki.gnome.org/Projects/Tracker/)

#### Beagle

没用过，别人推荐的，依赖 Java，太大不想装（30MB）。  
官网：[http://beagle-project.org/](https://link.jianshu.com?t=http://beagle-project.org/)

#### Fasd

可能用过几次。  
地址：[https://github.com/clvv/fasd](https://link.jianshu.com?t=https://github.com/clvv/fasd)

# 新将们

#### 深度文件管理器（1.4 版本 +）

深度最近发布了 15.4 RC，文件管理器更新到 1.4 版本，加入了快速搜索文件的功能。  
下面 GIF 图片展示了新建一个文件夹后迅速搜索，以检测深度文件搜索的效率：

![](http://upload-images.jianshu.io/upload_images/137499-5cf43e5568aaad62.gif)

深度实时文件搜索

可以看到即使是刚创建的文件，深度文件管理器也可以快速搜索出来。  
不足之处在于对于 root 用户（整个硬盘环境搜索）来说，效率就不是那么好了。也不能搜索其他挂载盘，除非你进入到该磁盘再搜索。

PS：这次更新界面还不错。很多地方有了调整。系统全局的半透明磨砂处理很舒服。

![](http://upload-images.jianshu.io/upload_images/137499-2dd6615aaba82316.png)

Deepin

#### FSearch

官网：[http://www.fsearch.org/](https://link.jianshu.com?t=http://www.fsearch.org/)

![](http://upload-images.jianshu.io/upload_images/137499-1c8db474fab3bbe2.png)

FSearch

速度很快，作者自称在 windows 下是 everything 的粉，对 Linux 下各种搜索引擎都不满意（作者说试用过 ANGRYsearch、Tracker、CatFish、regain、fzf 等），于是用 C 和 GTK3 做了一个。

软件可以选择使用白名单索引，而且每次打开程序时自动增量更新索引

安装没什么好说的：  
[https://github.com/cboxdoerfer/fsearch#download](https://link.jianshu.com?t=https://github.com/cboxdoerfer/fsearch#download)

#### ANGRYsearch

地址：[https://github.com/DoTheEvo/ANGRYsearch](https://link.jianshu.com?t=https://github.com/DoTheEvo/ANGRYsearch)

号称要做 Linux 版的 Everything，用 QT5 做的。与 FSearch 一样界面和操作都类似 everything，作者也提及了 FSearch。速度也不错，不过相比上面那个可能功能有些差异（不是差距）。

软件可以自动更新索引，适合使用 QT 编写的桌面环境。

![](http://upload-images.jianshu.io/upload_images/137499-874e0305441f61b0.png)

ANGRYsearch

#### fzf

地址：[https://github.com/junegunn/fzf](https://link.jianshu.com?t=https://github.com/junegunn/fzf)  
一个命令行的模糊搜索工具，FSearch 作者也推荐使用。速度还不错，即打即出结果，几乎没有延迟（当然得花一段时间索引）。

![](http://upload-images.jianshu.io/upload_images/137499-8eb2c3f879536a3f.gif)

支持 vim

因为是 Go 写的，所以跨平台（不过 Windows 下都有 Everything 了吧）。

#### Albert

地址：[https://github.com/albertlauncher/albert](https://link.jianshu.com?t=https://github.com/albertlauncher/albert)

吐槽一句 README 的 GIF 图片居然有 9MB 那么大，打开一下没了 10MB 流量，心疼。

下面是自己录制的 GIF，一个演示。

![](http://upload-images.jianshu.io/upload_images/137499-be1dd378c891bd45.gif)

快速搜索