---
url: https://blog.csdn.net/ZauberC/article/details/126889352
title: bypy 安装和使用_bypy 使用_CV 矿工的博客 - CSDN 博客
date: 2023-06-17 11:53:16
tag: 
banner: "undefined"
banner_icon: 🔖
---
# bypy

与百度网盘互通，默认互通文件夹为 百度网盘 / 应用文件 / bypy

# 安装

```
pip3 install bypy

```

# 使用

**第一次用先认证**

```
bypy info

```

然后复制那个网址到浏览器认证，复制认证码粘贴回去

**上传** xxx

加 -v 会显示进度详情。  
添加 - d 会显示一些调试信息  
添加 -ddd 会显示 http 通讯信息

```
bypy syncup xxx
# 或者
bypy upload xxx

```

不加 xxx 时，则上传当前目录

**下载**  
下载单个文件 xxx

```
bypy downfile xxx

```

把[云盘](https://so.csdn.net/so/search?q=%E4%BA%91%E7%9B%98&spm=1001.2101.3001.7020)内容下载到本地来

```
bypy syncdown
# 或者
bypy downdir /

```

bypy downdir /aaa/bbb 可以选择文件夹，下载 百度网盘 / 应用文件 / bypy/aaa/bbb 文件夹的内容到本地

**取消授权**

```
bypy -c

```

**更多命令和使用帮助**

```
bypy

```

个人习惯

```
vim ~/.bashrc

```

添加

```
alias bdup='bypy upload'
alias bddown='bypy downloadfile'

```