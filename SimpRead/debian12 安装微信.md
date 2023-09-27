---
url: https://dev.leiyanhui.com/linux/debian-wechat/
title: debian12 安装微信
date: 2023-09-18 20:32:59
tag: 
banner: "https://images.unsplash.com/photo-1693575063301-8f71cde016ec?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjk1MDQwMzczfA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
banner_icon: 🔖
---
[wechat](https://dev.leiyanhui.com/categories/wechat/) [debian](https://dev.leiyanhui.com/categories/debian/)sr-annote { all: unset; }

sr-annote { all: unset; }

因为各个版本的 都存在封号情况，目前只有 deepin wine 版本 尚可

```
wget -O- https://deepin-wine.i-m.dev/setup.sh | sh
sudo apt install com.qq.weixin.deepin com.qq.im.deepin
## 如无法发送照片
sudo apt install libjpeg62:i386
```

启动命令

```
/opt/apps/com.qq.weixin.deepin/files/run.sh
```

在 i3 下有黑框影响观感，但是不影响使用。

[comments powered by Disqus](https://disqus.com/)