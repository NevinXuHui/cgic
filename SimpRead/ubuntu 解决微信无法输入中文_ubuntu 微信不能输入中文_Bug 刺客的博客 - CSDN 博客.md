---
url: https://blog.csdn.net/qq_18649781/article/details/87476043
title: ubuntu 解决微信无法输入中文_ubuntu 微信不能输入中文_Bug 刺客的博客 - CSDN 博客
date: 2023-09-19 09:04:27
tag: 
banner: "https://images.unsplash.com/photo-1691951171253-128bde131aaa?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjk1MDg1NDE3fA&ixlib=rb-4.0.3&q=85&fit=crop&w=1398&max-h=540"
banner_icon: 🔖
---
### 1. 安装 deepin-wine 环境

上 [https://gitee.com/wszqkzqk/deepin-wine-for-ubuntu](https://gitee.com/wszqkzqk/deepin-wine-for-ubuntu) 页面下载 zip 包，解压到本地文件夹，在文件夹中打开终端，输入 sudo sh ./install.sh 一键安装。或用 git 方式克隆，如下：

```
git clone https://gitee.com/wszqkzqk/deepin-wine-for-ubuntu.git
cd deepin-wine-for-ubuntu
./install.sh

```

### 2. 下载并安装所需要的 deepin-wine 容器 （建议在终端下使用 dpkg -i 安装）或者直接双击. deb 包直接进行安装（比较慢）

下载链接：[http://mirrors.aliyun.com/deepin/pool/non-free/d/](http://mirrors.aliyun.com/deepin/pool/non-free/d/)

微信：[http://mirrors.aliyun.com/deepin/pool/non-free/d/deepin.com.wechat](http://mirrors.aliyun.com/deepin/pool/non-free/d/deepin.com.wechat)

### 3. 安装好后按 win 键，搜索 wechat，点击打开：

![](https://img-blog.csdnimg.cn/20190216214736157.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzE4NjQ5Nzgx,size_16,color_FFFFFF,t_70)

### 4. 会发现输入法无法输入中文的问题

解决方法：export 环境变量，加载输入法。  
具体如下：  
打开终端 cd 进入 deepin-wine 的运行脚本目录

```
cd /opt/deepinwine/tools/
sudo chmod 777 run.sh  #文件默认为只读，修改权限
vim run.sh   #编辑脚本

```

![](https://img-blog.csdnimg.cn/20190216215327163.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzE4NjQ5Nzgx,size_16,color_FFFFFF,t_70)

  
加入以下内容：

```
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx" 
export XMODIFIERS="@im=fcitx"

```

重启微信，切换为系统自带的 fcitx 输入法即可输入中文。