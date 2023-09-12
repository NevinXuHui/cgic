---
banner: "https://images.unsplash.com/photo-1691962898718-4dfecbf3c0f2?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkyOTM5ODIxfA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
---
---
url: https://blog.csdn.net/qq_43586061/article/details/119813085
title: 一次 ArchLinux 的 xrdp 安装过程（闪退及黑屏【蓝屏】）_xrdp-sesman_三十的南瓜饭的博客 - CSDN 博客
date: 2023-08-25 13:03:42
tag: 
banner: "https://images.unsplash.com/photo-1691962898718-4dfecbf3c0f2?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkyOTM5ODIxfA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
banner_icon: 🔖
---
## 安装 xrdp

Archlinux 安装软件的安装方式还是 arch wiki 相关软件界面：https://wiki.archlinux.org/title/Xrdp， 也有中文界面：https://wiki.archlinux.org/title/Xrdp_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)。

根据 wiki 的说明，首先需要安装软件包：

Install the xrdpAUR [package](https://so.csdn.net/so/search?q=package&spm=1001.2101.3001.7020) (or alternatively xrdp-gitAUR for the development version). This only supports Xvnc as the backend.

![](https://img-blog.csdnimg.cn/e7828cc2da134673b2845cf5fd5aa264.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNTg2MDYx,size_16,color_FFFFFF,t_70)

点击进去之后是这个界面：  

![](https://img-blog.csdnimg.cn/1eab064509184395b98115c2de36265c.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNTg2MDYx,size_16,color_FFFFFF,t_70)

这个用法和 git 用法一样，可以使用 `git clone` 克隆到本地，然后进行编译安装。

具体的安装方法这里就不赘述了，网上有很多关于 archlinux aur 软件包的安装方法。

## 闪退

当 xrdp 安装好并且设置开机自启之后，从 window 端连过去会有闪退的问题，在 archlinux xrdp 的 wiki 里面没有找到，在国内各大论坛也没有找到相关的解决方法，这个问题让我 archlinx 安装了一个月之后依然在用 windows（双系统）。

今天重新打开 [archwiki（中文）](https://wiki.archlinux.org/title/Xrdp_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29) 关于 xrdp 的页面，看到了这么一条：

在启动 xrdp 和 xrdp-sesman 服务后，你应当能够使用 RDP 客户端通过默认的 RDP 端口 (3389) 连接到主机。 如果成功，你将看到一个 xrdp 会话管理器窗口，你可以在其中选择 Xorg 或 Xvnc 会话并提供输入用于用户验证。 会话管理器界面可通过修改 /etc/xrdp/xrdp.ini 进行高度定制。

然后使用查看 xrdp-sesman 的运行情况：

```
systemctl status xrdp-sesman.service

```

发现了这样一条信息：

Falling back to non-systemd startup procedure due to error:

然后结合 xrdp 搜索相关的信息，找到了 archlinux 的 bbs 论坛的一篇帖子：https://bbs.archlinux.org/viewtopic.php?id=258936，发现是自己的 .xinitrc 文件设置错了。

关于 .xinitrc:

```
# 旧版的设置
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
exec gnome-session

```

新版设置：

```
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
exec dbus-launch gnome-session

```

同时该文件还有另外几个相关链接，有兴趣可以仔细看看。

如果 .xinitrc 文件是空的的话，可能会出现 xrdp 进去不能显示的情况（显示背景色，勉勉强强算蓝色吧），也可以试试通过设置这个文件解决（设置内容一样的）。刚刚提到的背景色：  
[外链图片转存失败, 源站可能有防盗链机制, 建议将图片保存下来直接上传 (img-LARIUrO5-1629385502853)(:/c0938879c17f4d27ab02c309538a3bac)]