---
url: https://blog.wangshuai.app/2022-10-22-Syncthing%20%E5%A4%B1%E5%8E%BB%E5%90%8C%E6%AD%A5%20Out%20of%20Sync/
title: Syncthing 失去同步 Out of Sync - 王帅的博客
date: 2023-08-31 14:05:10
tag: 
banner: "http://blog.wangshuai.app/img/syncthing_out_of_sync.png"
banner_icon: 🔖
---
### [](#引言)[](#引言 "引言")引言

最近刚开始尝试自建文件备份服务, 尝试了 [Syncthing](https://syncthing.net/); 用它来同步手机相册到黑群的外接硬盘上; 一天下来体感很不错, 于是准备将手机相册备份一份到我的电脑上.

在同步之后遇到一个错误 `Syncthing 失去同步`

![](https://blog.wangshuai.app/img/syncthing_out_of_sync.png)

image-20221022154214554

### [](#解决方案)[](#解决方案 "解决方案")解决方案

这里的问题是同步遇到问题, 导致同步不能继续了;

点击`失去同步`就能看到有一个失败的项目, 点开即可知道此处为 qq 创建的某一个文件名不被 windows 支持

![](https://blog.wangshuai.app/img/syncthing_error_item.png)

image-20221022154610577

因此只要把这个目录忽略即可.

点击`选项`在`忽略模式`中输入有问题的文件夹名称`.qqpim_guid`, 点击保存即可看到`同步完成状态`, 并且本地状态显示`已由忽略模式缩减`

![](https://blog.wangshuai.app/img/syncthing_ignore_folder.png)

image-20221022160533608

### [](#参考资料)[](#参考资料 "参考资料")参考资料

*   ​ [https://docs.syncthing.net/v1.22.0/users/ignoring](https://docs.syncthing.net/v1.22.0/users/ignoring)