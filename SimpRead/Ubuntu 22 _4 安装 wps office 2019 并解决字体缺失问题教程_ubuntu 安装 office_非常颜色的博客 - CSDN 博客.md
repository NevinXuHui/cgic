---
url: https://blog.csdn.net/feichangyanse/article/details/129029627
title: Ubuntu 22 _4 安装 wps office 2019 并解决字体缺失问题教程_ubuntu 安装 office_非常颜色的博客 - CSDN 博客
date: 2023-09-20 11:37:24
tag: 
banner: "https://img-blog.csdnimg.cn/9b7c5d882f5f4705963c08201e886b6b.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rGf5rmW5LiA5bCP6Jm-,size_20,color_FFFFFF,t_70,g_se,x_16"
banner_icon: 🔖
---
# Ubuntu 22 .4 安装 wps office 2019 并解决字体缺失问题教程

## 1. 访问 WPS 官网下载适用的 DEB 格式的安装包。

![](https://img-blog.csdnimg.cn/9b7c5d882f5f4705963c08201e886b6b.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rGf5rmW5LiA5bCP6Jm-,size_20,color_FFFFFF,t_70,g_se,x_16)

![](https://img-blog.csdnimg.cn/fac0eab53f854c1fbb4bd7411c00bdbd.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rGf5rmW5LiA5bCP6Jm-,size_20,color_FFFFFF,t_70,g_se,x_16)

## 2. 浏览器下载目录下找到下载的安装包，为了方便直接拖动到终端上，在终端上生成路径。

![](https://img-blog.csdnimg.cn/78f7354d9b7c4eabb6c298807f15901e.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rGf5rmW5LiA5bCP6Jm-,size_20,color_FFFFFF,t_70,g_se,x_16)

## 3. 在终端显示的路径前输入 sudo dpkg -i 执行安装。

```
sudo dpkg -i '/home/shenzhi/下载/wps-office_11.1.0.10920_amd64.deb' 

```

![](https://img-blog.csdnimg.cn/ce9452f05d3b4b99a183ba0cd768960b.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rGf5rmW5LiA5bCP6Jm-,size_20,color_FFFFFF,t_70,g_se,x_16)

## 4. 完成安装后，在桌面会生成名为 wps-office-prometheus.desktop 启动器文件。

## 

![](https://img-blog.csdnimg.cn/db736acb0ebb42c5913c6f90ccef1cb1.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rGf5rmW5LiA5bCP6Jm-,size_20,color_FFFFFF,t_70,g_se,x_16)

## 5. 给 wps-office-prometheus.desktop 文件赋予执行权限。

```
 sudo chmod +x wps-office-prometheus.desktop 

```

![](https://img-blog.csdnimg.cn/8b186e345b544682973b9f55e8e9820a.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rGf5rmW5LiA5bCP6Jm-,size_20,color_FFFFFF,t_70,g_se,x_16)

## 6. 右击桌面 wps-office-prometheus.desktop 文件，点击选择允许运行（截图软件无法捕捉鼠标右键生成的菜单栏，作者就不贴图了），生成启动器。

![](https://img-blog.csdnimg.cn/b009eab0bcc94f3e865c62d5d3fbdd04.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rGf5rmW5LiA5bCP6Jm-,size_11,color_FFFFFF,t_70,g_se,x_16)

字体包链接: https://pan.baidu.com/s/1qBhUgfbj-rcDMXX7Qva7aQ 提取码: g608

![](https://img-blog.csdnimg.cn/eabcef1cc0a0486ca5005ab1421a57f7.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rGf5rmW5LiA5bCP6Jm-,size_20,color_FFFFFF,t_70,g_se,x_16)

```
sudo unzip -d /usr/share/fonts/wps-office '/home/shenzhi/下载/wps-fonts.zip' 

```

![](https://img-blog.csdnimg.cn/8fcaf2022c494217acd7ddf2d07c239a.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rGf5rmW5LiA5bCP6Jm-,size_20,color_FFFFFF,t_70,g_se,x_16)