---
banner: "https://picx.zhimg.com/v2-a3df6596cc0de94ff32c52e6aee448e6_720w.jpg?source=172ae18b"
---
---
url: https://zhuanlan.zhihu.com/p/37734809
title: zsh (+fish) _ 完美终端
date: 2023-04-26 12:37:09
tag: 
banner: "https://picx.zhimg.com/v2-a3df6596cc0de94ff32c52e6aee448e6_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
[欢迎关注](https://mp.weixin.qq.com/s?__biz=MzIwNjUxMTQyMA==&mid=2247484180&idx=1&sn=97a5638c4152ee651f82747e4e70bff9&chksm=9721cf47a0564651ab690832f2f9dc80adaa453767dc5a103adca4cf8945eb6e77174c8671b1#rd)

自从用了深度，有一个非常明显的变化就是终端的改变，实在是比 windows 的好用一百倍，尤其是使用一些工具。下面说说我现在的配置。

如下图，是我目前正在使用的终端，集成了 zsh 和 fish 的功能，目前用着最顺手的。

![](1682483829308.png)

[https://github.com/robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

## 安装 zsh

一般来说，直接运行`sudo apt-get install zsh`即可，当然也可以下载源 [Download zsh source](http://zsh.sourceforge.net/Arc/source.html)，使用 curl 安装`curl -L <https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh> | sh`

把`zsh`设置为默认终端`chsh -s $(which zsh)`

更多细节参考 [Installing ZSH](https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH)

先欣赏下`zsh`的效果。来自官网

![](1682483829483.png)

![](1682483829585.png)

![](1682483829699.png)

## 修改 zsh 主题

`vi ~/.zshrc`，然后找到`ZSH_THEME`，默认的是`ZSH_THEME=robbyrussell`，就像我这样，因为我这里用的是深度终端，而且也修改了终端主题

![](1682483829800.png)

当然，你可以来这里看看，选一个自己喜欢的主题 [Themes](https://github.com/robbyrussell/oh-my-zsh/wiki/themes)

![](1682483829902.png)

`agnoster`也很好看。

据说大神都用`random`，是真的吗？

## 安装 fish

有句话这样说

二逼青年用 bash，普通青年用 zsh，文艺青年用 [fish](http://fishshell.com/)

我最喜欢 `fish`的一点就是 **根据历史输入自动补全**，来看图，只要是历史有输入的，都会有记录有提示，对于一些很长的命令，简直超级爽，再也不用手动复制粘贴了。

![](1682483829990.png)

但是`fish`和`zsh`好像不能同时使用，但是有一个插件可以在`zsh`上达到和`fish`同样的效果。

地址在这里 **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)**

首先下载下来

`git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`

然后`vi ~/.zshrc`，添加`zsh-autosuggestions`到 plugins 中，`git`是默认就有的。然后新打开一个终端，就可以达到`fish`有的你是提示功能了。

![](1682483830070.png)

还可以安装语法高亮插件 [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)，安装方法和上面的一样，在 plugins 中添加`zsh-syntax-highlighting`即可。

这些是我目前发现的比较好用的插件和工具，跪求大佬推荐更好用的！！

想要安装深度系统的可以参考之前的文章 [体验 linux，双系统了解下](https://zhuanlan.zhihu.com/p/36764060)