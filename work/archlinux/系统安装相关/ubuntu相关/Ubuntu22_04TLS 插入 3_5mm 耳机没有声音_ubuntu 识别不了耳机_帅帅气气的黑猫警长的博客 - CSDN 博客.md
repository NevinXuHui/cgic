---
url: https://blog.csdn.net/Hao_ge_666/article/details/124898030
title: (133 条消息) Ubuntu22_04TLS 插入 3_5mm 耳机没有声音_ubuntu 识别不了耳机_帅帅气气的黑猫警长的博客 - CSDN 博客
date: 2023-03-29 12:51:55
tag: 
banner: "https://img-blog.csdnimg.cn/aa941c266fab4c48bdb3ec107ab44b29.png"
banner_icon: 🔖
---
**系统：**Ubuntu22.04LTS

**设备：**联想 ThinkCenter 台式机，3.5mm 耳机

**问题：**安装 [NVIDIA](https://so.csdn.net/so/search?q=NVIDIA&spm=1001.2101.3001.7020) 显卡驱动之后，在主机前面板插入耳机没有声音。

**解决办法：**

**1、安装 pavucontrol**

```
sudo apt install pavucontrol

```

**2、运行 pavucontrol**

```
pavucontrol

```

出现如下界面

![](1680065515800.png)

        可以看到有两个输出设备，HDMI 输出和内置音频输出。这里我们是接到了主机前面板，所以选择内置音频输出。可以在配置选项，把 HDMI 选项关闭。

![](1680065515933.png)

        这样再调整内置音频声音，这样就有声音了。

![](1680065516033.png)

        也可以根据自己的实际情况选择输出设备。

**可能遇到的问题:**

1、pavucontrol 卡在 “正在建立与 PulseAudio 的连接。请稍候...”

解决办法：

端口依次运行（注意登录身份，root 用户登录无法使用第二个命令，但不影响操作）

```
pulseaudio --check
pulseaudio -D
```