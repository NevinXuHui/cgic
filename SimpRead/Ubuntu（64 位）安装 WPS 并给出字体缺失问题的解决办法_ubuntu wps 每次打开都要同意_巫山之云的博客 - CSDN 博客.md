---
url: https://blog.csdn.net/weixin_43200997/article/details/106758071
title: Ubuntu（64 位）安装 WPS 并给出字体缺失问题的解决办法_ubuntu wps 每次打开都要同意_巫山之云的博客 - CSDN 博客
date: 2023-09-20 11:38:40
tag: 
banner: "https://img-blog.csdnimg.cn/20200615105310109.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIwMDk5Nw==,size_16,color_FFFFFF,t_70"
banner_icon: 🔖
---
_简注：记录自己在 Linux 系统中安装 WPS 的些许经验，以及针对安装成功之后出现的字体缺失问题给出具体的解决办法。  
如有描述不当的地方，欢迎大家纠正指出。如需转载或引用，请注明出处。谢谢！_

# WPS 安装

首先进入相应的[**官方页面**](https://www.wps.cn/product/wpslinux/)下载 deb 包。（点击**立即下载**，再点击 **For X64**，下载好的 deb 包在我的主文件夹下的下载文件夹中）  

![](https://img-blog.csdnimg.cn/20200615105310109.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIwMDk5Nw==,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/2020061512223071.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIwMDk5Nw==,size_16,color_FFFFFF,t_70#pic_center)

  

![](https://img-blog.csdnimg.cn/20200615105507113.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIwMDk5Nw==,size_16,color_FFFFFF,t_70#pic_center)

接下来，就是正式安装，打开**终端**，输入：

```
cd 下载
sudo dpkg -i wps-office_11.1.0.9522_amd64.deb

```

**注意：** wps-office_11.1.0.9522_amd64.deb 是你所下载的 deb 包的版本名，不同的版本对应不同的版本名（**sudo dpkg -i 版本名**）

# 解决字体缺失问题

安装完成后，桌面会出现 WPS 图标，你可以选择将其固定在启动器上便于使用。点击 **WPS 图标**，由于是首次使用所以需要同意它的用户协议，点击**接受**，终于成功进入 WPS。但是，不要着急，当你点击某个文件选择以 WPS 方式打开，会出现以下提示：  

![](https://img-blog.csdnimg.cn/2020061511165594.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIwMDk5Nw==,size_16,color_FFFFFF,t_70#pic_center)

出现提示的原因是因为 WPS For Linux 的字体版权问题，安装包内没有自带 Windows 的字体，用户只能在 Linux 系统中自己加载字体。  
具体的解决步骤如下：

1.  下载缺失的字体文件，下载地址：  
    链接: https://pan.baidu.com/s/1bFmSqWVDxc7Kc4kbJt3uEQ  
    提取码: m5jw
2.  下载后解压字体包，将解压后的文件直接复制到 Linux 系统中的 / usr/share/fonts 文件夹中，没有 fonts 文件夹的就直接建立一个，然后把文件复制进去。
3.  接着在终端中依次输入以下命令：
    
    ```
     $ cd 下载/usr/share/fonts/wps_symbol_fonts
     $ sudo cp mtextra.ttf  symbol.ttf  WEBDINGS.TTF  wingding.ttf  WINGDNG2.ttf  WINGDNG3.ttf  /usr/share/fonts
     $ sudo mkfontscale  
     $ sudo mkfontdir   
     $ sudo fc-cache   
    
    ```
    
    ![](https://img-blog.csdnimg.cn/20200615114512970.png#pic_center)
    
    4. 最后重启 WPS，字体缺失的提示不再出现，问题解决。  
    
    ![](https://img-blog.csdnimg.cn/20200615115232246.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIwMDk5Nw==,size_16,color_FFFFFF,t_70#pic_center)
    
      
    
    ![](https://img-blog.csdnimg.cn/20200615115451785.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIwMDk5Nw==,size_16,color_FFFFFF,t_70#pic_center)