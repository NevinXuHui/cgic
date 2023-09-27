#端口映射  #wsl
---
url: https://blog.csdn.net/keyiis_sh/article/details/113819244
title: wsl2 设置端口映射_wsl 端口映射_压码路的博客 - CSDN 博客
date: 2023-03-30 16:36:32
tag: 
banner: "https://img-blog.csdnimg.cn/20210215204552315.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2tleWlpc19zaA==,size_16,color_FFFFFF,t_70"
banner_icon: 🔖
---
在 [powershell](https://so.csdn.net/so/search?q=powershell&spm=1001.2101.3001.7020) 中执行，获取虚拟机内 ubuntu 的 ip 地址

```
wsl -- ifconfig eth0

```

![](<assets/1680165392766.png>)

将 ip 地址的对应的[端口映射](https://so.csdn.net/so/search?q=%E7%AB%AF%E5%8F%A3%E6%98%A0%E5%B0%84&spm=1001.2101.3001.7020)到宿主 win10 对应的端口

```
# netsh interface portproxy add v4tov4 listenport=[win10端口] listenaddress=0.0.0.0 connectport=[虚拟机的端口] connectaddress=[虚拟机的ip]
netsh interface portproxy add v4tov4 listenport=5683 listenaddress=0.0.0.0 connectport=5683 connectaddress=wsl2host
```

检测是否设置成功

```
netsh interface portproxy show all

```

![](<assets/1680165392882.png>)