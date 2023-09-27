---
url: https://zhuanlan.zhihu.com/p/558203490
title: 给 OpenWrt 配置 WebDAV 和 Syncthing
date: 2023-09-04 12:32:48
tag: 
banner: "https://images.unsplash.com/photo-1691228398858-0dd821501aed?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkzODAxOTYzfA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
banner_icon: 🔖
---
前几年，我在因为机缘巧合下，入手了一台 Google Pixel 一代，因为后来换了手机，这台手机就一直吃灰，直到我发现这台手机是可以免费无限量的以原图备份照片到 Google Photo 之后...

通过参考少数派的这篇文章：[Google 相册取消无限容量备份，你还有这些优质选择 - 少数派](https://sspai.com/post/63653)

咱在这台手机上整了个 Syncthing，用来同步照片到这台手机上

![](https://pic4.zhimg.com/v2-6eea7f552a3089bd9ec4c064113abf87_r.jpg)

这台手机也就整天插着电源，就近安置在插座旁边

![](

但采用 Syncthing 用来同步照片也有问题，比如 iOS 设备，就没办法很方便的用 Syncthing 来同步

于是，我就用了一种曲线救国的方案：用一台 VPS 来作为备份照片的临时中转

用 VPS 局限性还是挺大的，比如上传带宽就 1M（）

于是乎，我就把目光投向了我的软路由（软路由：瑟瑟发抖）

我采用的方法是在软路由上同时安装 Syncthing 和 WebDAV，默认情况下，OpenWrt 所安装的 Syncthing 似乎无法正确的用 procd 来启动，所以我简单的小 (chong) 改(xie)了一个启动项来实现开机自启动

## Syncthing

相关网站：[Syncthing | Downloads](https://syncthing.net/downloads/)

其实对于 Syncthing 没什么好说的，OpenWrt 的官方源里面就已经包含这个软件包了

因此只需要

```
opkg update
opkg install syncthing

```

然后运行 Syncthing 一次，来生成配置

然后编辑配置文件

```
nano ~/.config/syncthing/config.xml

```

通过搜索关键词 `<gui`，修改其中的 IP 为软路由的局域网 IP（不怕被公网攻击的话可以试试 `0.0.0.0`），端口可以按需要设置其他的，或者保持不变

![](https://pic4.zhimg.com/v2-9413916785aa6add71862ca96935e537_r.jpg)

然后再运行一次，访问软路由的 IP 和端口，例如 [http://192.168.1.1:8384](http://192.168.1.1:8384)

如果能正常加载，就说明正常了，可以按照自己的需求修改其他功能了

如果此时以 root 用户来运行，则配置文件在  
`/root/.config/syncthing`

### 持久化的运行 / 开机自启

通过 opkg 安装的 Syncthing 似乎不能持久化运行，通过 procd 启动总是无法正常启动

root@OpenWrt:~# /etc/init.d/syncthing status  
active with no instances

用谷歌搜了一圈也找不出个所以然来，索性就自己写一个 procd 配置出来，正巧前段时间学习了 procd 的写法，学以致用了属于是（

此处贴一个我的配置：[syncthing](http://blog.ascn.site/post/20220821003750/syncthing)

在我的配置中，默认会认为二进制文件在

```
/usr/bin/syncthing

```

配置目录在

```
/root/.config/syncthing

```

如果需要修改二进制，请修改第八行

![](https://pic2.zhimg.com/v2-4574a7880f7cb2b32558821abbd67529_b.jpg)

如果需要修改配置文件，请修改第十三行

![](https://pic2.zhimg.com/v2-c600db591f1a8a24c5d376963387468d_r.jpg)

顺带一提，Linux 下的换行和 Windows 不太一样，因此可能需要用 `dos2unix` 来转换下

```
dos2unix syncthing

```

修改完毕后，将其复制到 `/etc/init.d/` 下就可以

打开软路由的管理界面

![](https://pic3.zhimg.com/v2-1399559d492835ff831057fa877a0daa_r.jpg)

在 `系统` - `启动项` 下，将 `syncthing` 设置为 `已启用` ，然后启动

![](https://pic3.zhimg.com/v2-c839b21945bb3dd387ac9a02d14dd56e_r.jpg)

如果访问其 GUI 能正常进入，那么就说明正常了

## WebDAV

插句题外话，其实本文最初是用的 Syncthing+Samba 方案的

![](https://pic3.zhimg.com/v2-0b806a1b45c27f6bf5bc2ab807f5caa2_r.jpg)

但后来发现 Samba 在 OpenWrt 的体验算不上多好，外加上有外网访问需求，因此就用 WebDAV 来代替 Samba 了

相关网站：[GitHub - hacdias/webdav: Simple Go WebDAV server.](https://github.com/hacdias/webdav)

从这个项目的 releases 里下载编译好的二进制，按需求下载

**建议先创建一个文件夹，以免解压出过多文件（**

```
mkdir webdav

```

例如我软路由的架构是 64 位的，那么就下载 `linux-amd64-webdav.tar.gz`

![](https://pic3.zhimg.com/v2-7031c0d3f699201273be8e0242993cb2_b.jpg)

下载后解压

```
tar -zxvf linux-amd64-webdav.tar.gz

```

然后创建一个配置文件

```
nano conf.yml

```

具体配置建议参考项目 `README` 里的 `Usage`

![](https://pic2.zhimg.com/v2-a95dbdd296498ac5117cb796f5b0aabd_r.jpg)

因为对于我来说，需求并不算很多，因此我只写了一小部分的配置

```
address: 0.0.0.0 #监听地址，不想外网访问请设置为软路由 IP
port: 8089 #监听端口
auth: true #是否开启验证
tls: false #是否开启 TLS 加密
cert: cert.pem #TLS 的证书
key: key.pem #TLS 的密钥
prefix: / #前缀，"/" 即代表访问地址为 http(s)://监听地址:建听端口/
debug: false #查错模式，日常使用请关掉

scope: . #监听目录，"." 即代表在当前目录下
modify: true #修改权限，建议打开
rules: [] #规则，不懂，建议不写（

cors: #跨域资源共享，不是很懂，建议关掉（
  enabled: false

users: #如果 "auth" 为 "true"，则需要填写用户来鉴权
  - username: user #用户名
    password: password #用户密码
    scope: /root/webdav/syncthing/ #目录

```

当然，如果不想要注释，可以查看这个文件 [example.conf.yml](http://blog.ascn.site/post/20220821003750/example.conf.yml)

写完之后，测试一下

```
./webdav -c conf.yml

```

如果没有报错，通过 WebDAV 也可以正常看到文件的话，说明运行正常了，可以做持久化运行了

### 持久化的运行 / 开机自启

直接放文件了 [webdav](http://blog.ascn.site/post/20220821003750/webdav)

默认认为二进制文件在

```
/root/webdav/webdav

```

配置文件在

```
/root/webdav/conf.yml

```

如果需要修改二进制文件的位置，请修改第八行

![](https://pic2.zhimg.com/v2-5dd8f62004f89a4109d8d0f23f910dcd_b.jpg)

如果需要修改配置文件的位置，请修改第十三行位于 `-c` 后的部分

![](https://pic3.zhimg.com/v2-f3d9359cb5e42e4516796f0f292b1576_r.jpg)

之后的操作跟上面 Syncthing 的持久化就大差不差了，就不赘述了

## 后记

插个题外话，在上篇文章中我说到要整 WebP，这篇文章中就直接实现了

这篇文章中的所有图片均采用了 WebP 格式

![](https://pic1.zhimg.com/v2-ff85e2810a3d1de60116df853979fa10_r.jpg)

压缩率那叫一个高啊（笑

![](https://pic1.zhimg.com/v2-ba7594251788cbcf1bccd1a48f3591f4_r.jpg)

效果显著. webp

有时间再写篇文章讲讲实现方法，先把坑挖了（

本文部分格式受限于知乎的 Markdown 语法实现，直接删掉了。

原文发布于我的博客

[给 OpenWrt 配置 WebDAV 和 Syncthing](http://blog.ascn.site/post/20220821003750/)

原文发布时间 2022-08-21