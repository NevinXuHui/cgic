---
url: https://blog.csdn.net/qq_36835255/article/details/128112139
title: oh-my-zsh 为 ls 命令自定义颜色_zsh 颜色_兔帮大人的博客 - CSDN 博客
date: 2023-04-18 17:50:53
tag: 
banner: "https://img-blog.csdnimg.cn/25e2d7bdff2b4881b3e76789a9bfa07b.png#pic_center"
banner_icon: 🔖
---
ls 命令默认显示的颜色是：

白色： 表示普通文件  
蓝色： 表示目录  
绿色： 表示可执行文件  
红色： 表示压缩文件  
蓝绿色： 链接文件  
红色闪烁：表示链接的文件有问题  
黄色： 表示设备文件  
灰色： 表示其他文件

在 [oh-my-zsh](https://so.csdn.net/so/search?q=oh-my-zsh&spm=1001.2101.3001.7020) 主题下如何自定义这些颜色呢？

1.  任意目录下创建 .dircolors

```
touch /usr/local/etc/.dircolors

```

2.  利用管道将 dircolors 命令重定向到 .dircolors

```
dircolors -p > /usr/local/etc/.dircolors

```

3.  修改 .bashrc 配置，搜索 `enable color support of ls and also add handy aliases`  
    把 .dircolors 的路径更新为上面步骤建立的路径

![](https://img-blog.csdnimg.cn/25e2d7bdff2b4881b3e76789a9bfa07b.png#pic_center)

4.  保存后，更新 .bashrc

```
source .bashrc

```

到这一步，已经可以在 .dircolors 进行颜色的修改并显示出来，但 zsh 的配置文件没有关联 ls 文件类型颜色的逻辑， 所以需要将 .bashrc 关于 ls 文件类型颜色的逻辑，复制到 zsh 的配置文件。

5.  编辑 .zshrc

```
vi .zshrc

```

6.  将下面的部分，复制到 .zshrc 末尾

![](https://img-blog.csdnimg.cn/b595d880263e4bcdb58659e0a408bec0.png#pic_center)

验证一下，编辑 /usr/local/etc/.dircolors ，搜索 `DIR 01;34`，更改为 `DIR 01;33`，也就是将文件夹类型的颜色，由原来的蓝色更改为黄色。

保存后，更新 .zshrc

```
source .zshrc

```

可以看到颜色已经改变

![](https://img-blog.csdnimg.cn/6ee7d3c7d0f94099a8c367d132b5828e.png#pic_center)

  
`附录主要的颜色值`

样式：  
00 — Normal (no color, no bold)  
01 — Bold // 粗体  
文字颜色  
30 — Black // 黑色  
31 — Red // 红色  
32 — Green // 绿色  
33 — Yellow // 黄色  
34 — Blue // 蓝色  
35 — Magenta // 洋红色  
36 — Cyan // 蓝绿色  
37 — White // 白色  
背景颜色  
40 — Black  
41 — Red  
42 — Green  
43 — Yellow  
44 — Blue  
45 — Magenta  
46 — Cyan  
47 – White