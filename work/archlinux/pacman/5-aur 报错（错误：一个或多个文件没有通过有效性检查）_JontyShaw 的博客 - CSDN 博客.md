---
url: https://blog.csdn.net/qq_37284020/article/details/103991649
title: aur 报错（错误：一个或多个文件没有通过有效性检查）_JontyShaw 的博客 - CSDN 博客
date: 2023-05-15 09:02:26
tag: 
banner: "https://img-blog.csdnimg.cn/20200115164040398.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM3Mjg0MDIw,size_16,color_FFFFFF,t_70"
banner_icon: 🔖
---
当我们从 aur 里安装软件时，有时会出现这种报错（如安装 deepin-wine-wechat）

```
==> 错误： 一个或多个文件没有通过有效性检查！
Error downloading sources: deepin-wine-wechat

```

我们从 yay 或者 pamac 等 aur 助手里安装某个软件常常会因为签名检查验证无法通过而安装失败，这种情况也常常出现，尤其是 deepin-wine-wechat 以及 deepin-wine-tim，很有可能因为官方的客户端升级了，不是之前的那个版本，验证就无法通过。

出现了这种情况，要么我们跳过验证进行安装，要么就不用他。[linux](https://so.csdn.net/so/search?q=linux&spm=1001.2101.3001.7020) 里没有 tim 总感觉少了什么，必须安装上

## 解决方法

```
1.编辑pkgbuild文件（可以用pamac里搜索对应的aur软件进入软件详情界面，点击构建文件，直接修改）
2.找到对应的验证部分，把里面的验证的码修改为SKIP，SKIP一定要是大写（md5sums sha1sums sha256sums sha224sums, sha384sums, sha512sums b2sums）
3.点击构建就能够成功了

```

（下面附上图片）  

![](https://img-blog.csdnimg.cn/20200115164040398.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM3Mjg0MDIw,size_16,color_FFFFFF,t_70)

  
`