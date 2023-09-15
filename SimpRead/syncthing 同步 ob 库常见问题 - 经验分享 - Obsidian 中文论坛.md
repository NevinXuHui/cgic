---
url: https://forum-zh.obsidian.md/t/topic/980
title: syncthing 同步 ob 库常见问题 - 经验分享 - Obsidian 中文论坛
date: 2023-09-15 13:37:23
tag: 
banner: "https://forum-zh.obsidian.md/uploads/default/original/1X/bf119bd48f748f4fd2d65f2d1bb05d3c806883b5.png"
banner_icon: 🔖
---
![](https://forum-zh.obsidian.md/user_avatar/forum-zh.obsidian.md/shaosen/48/88_2.png)

syncthing 是安卓与其它平台同步的最好方式之一，但新手往往会遇到几个难题，导致不能顺利使用，现将新手常见问题总结如下。

### [](#h-1-folder-marker-missing-1)问题 1 folder marker missing

问题提示：  
`2020-01-12 09:56:21: Error on folder "story" (fej6a-snqqz): folder marker missing (this indicates potential data loss, search docs/forum to get information about how to proceed)`  
解决办法  
在文件夹内新建`.stfolder`文件夹即可。修复后，依然可能会提示此问题，点确认即可。

### [](#h-2-2)问题 2，初始同步慢

手机和电脑上分别取消向对方同步，再打开向对方分享即可。可以多重复几次。

### [](#h-3-3)问题 3，同步慢，发现设备慢

发现服务器位于境外，可能网络不畅，可以采用国内的发现服务器，推荐纯帅二代的发现服务器。（设置方法查找山鸡文档）

![](https://forum-zh.obsidian.md/user_avatar/forum-zh.obsidian.md/shaosen/48/88_2.png)

syncthing 的使用教程极多，可以在楼下分享链接。  
syncthing 的其它问题，大家可以继续讨论。

![](https://forum-zh.obsidian.md/user_avatar/forum-zh.obsidian.md/shaosen/48/88_2.png)

问题 2 示例与详细说明，文件夹显示同步完成，但右下角远程设备一直卡在某个百分比。

![](https://forum-zh.obsidian.md/uploads/default/optimized/2X/7/7684304fe7b514b1c683ede8d4d453e792b821e6_2_690x339.png)

解决办法  
①点击文件夹，打开选项  

[

![](https://forum-zh.obsidian.md/uploads/default/optimized/2X/4/4da780c0faa2590dbe6e3d2ea46f610b4a8aef81_2_300x190.png)

image1050×623 47.2 KB

](https://forum-zh.obsidian.md/uploads/default/original/2X/4/4da780c0faa2590dbe6e3d2ea46f610b4a8aef81.png "image")

②在共享设置页面，按下图位置，分别取消共享，保存（不是移除）  

![](https://forum-zh.obsidian.md/uploads/default/optimized/2X/8/8ea80ba4894b16bce8a2f5cc0d6c04ee626f7ebd_2_330x200.png)

③远程同步设备也取消共享。  
④再两端打开共享

多搞几次就好了。

![](https://forum-zh.obsidian.md/user_avatar/forum-zh.obsidian.md/benjieming/48/2637_2.png)

感谢大佬！已经弄好啦！

![](https://forum-zh.obsidian.md/images/emoji/twitter/grinning.png?v=12)

![](https://forum-zh.obsidian.md/images/emoji/twitter/smile.png?v=12)

![](https://forum-zh.obsidian.md/user_avatar/forum-zh.obsidian.md/shaosen/48/88_2.png)

多端同步 ob 库时，有些文件需要忽略同步，它们大多记录的是本机的一些状态，这些状态和笔记内容无关。没有同步的意义，只会产生大量无意义冲突文件。

我忽略了以下文件

```
.git
.obsidian-git-data
.obsidian\plugins\obsidian-git\data.json
.trash


```

设置方法如下

![](https://forum-zh.obsidian.md/uploads/default/optimized/2X/5/5a90073855d2101f5a0b22a68ca79e1847f81d2d_2_678x500.png)

因为每个人启用的插件不同，忽略的文件也可能不同。一个简单的办法是把易冲突的非笔记文件都忽略掉。

![](https://forum-zh.obsidian.md/letter_avatar_proxy/v4/letter/h/91b2a8/48.png)

大佬, 安卓端的 synthing, 只要不在软件界面, 就无法连接到, 有什么解决办法吗,

![](https://forum-zh.obsidian.md/user_avatar/forum-zh.obsidian.md/shaosen/48/88_2.png)

给权限就好了，后台保护，电池那里也设置下，不要杀后台。

![](https://forum-zh.obsidian.md/letter_avatar_proxy/v4/letter/%E9%99%88/ee7513/48.png)

大佬，求问连接断开是什么缘故，之前都好好的，突然就断开了，网络没有问题，文件夹也已经设置为一边只接受一边只分享了

![](https://forum-zh.obsidian.md/letter_avatar_proxy/v4/letter/h/91b2a8/48.png)

同一 wifi 下, 手机 app 打开, 应该很快就能连接上.

![](https://forum-zh.obsidian.md/user_avatar/forum-zh.obsidian.md/shaosen/48/88_2.png)

重新启动下试试。

![](https://forum-zh.obsidian.md/letter_avatar_proxy/v4/letter/%E9%99%88/ee7513/48.png)

已经试过了，现在可以了，但感觉没有超级好用，时灵时不灵，勉强用用

![](https://forum-zh.obsidian.md/user_avatar/forum-zh.obsidian.md/shaosen/48/88_2.png)

那可能是你的网络访问发现服务器不稳定，可以试试用国内的发现服务器。  
山鸡的文档里有提供。

![](https://forum-zh.obsidian.md/letter_avatar_proxy/v4/letter/%E9%99%88/ee7513/48.png)

好的，我去康康。

![](https://forum-zh.obsidian.md/letter_avatar_proxy/v4/letter/z/d6d6ee/48.png)

![](https://forum-zh.obsidian.md/user_avatar/forum-zh.obsidian.md/shaosen/48/88_2.png)

ShaoSen:

在文件夹内新建`.stfolder`文件夹即可。修复后，依然可能会提示此问题，点确认即可。

我以前同步的时候也经常出错，然后每次都要在手机里新建一个`.stfolder`文件夹，很麻烦。

我尝试更改里面的各种设置都没用，直到我把其中的忽略模式改为

```
/.obsidian/
/.trash/


```

同步就再没出过问题了