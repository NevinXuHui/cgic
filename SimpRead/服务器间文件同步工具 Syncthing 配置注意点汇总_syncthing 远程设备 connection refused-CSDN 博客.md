---
url: https://blog.csdn.net/XiaoXiao_RenHe/article/details/104616001
title: 服务器间文件同步工具 Syncthing 配置注意点汇总_syncthing 远程设备 connection refused-CSDN 博客
date: 2023-09-15 08:56:15
tag: 
banner: "https://images.unsplash.com/photo-1692637879502-fd033368130c?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjk0NzM5Mjk1fA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
banner_icon: 🔖
---
1、备份服务器视图说明

![](https://img-blog.csdnimg.cn/20200310095650202.jpeg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

2、本地服务器配置

![](https://img-blog.csdnimg.cn/20200302173845140.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

如上图所示，点击右上角操作中的设置，如下图进行设置。

![](https://img-blog.csdnimg.cn/20200302181024791.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

如下图所示，点击 “添加文件夹”，设置需要备份的本机文件夹。

![](https://img-blog.csdnimg.cn/20200302174101506.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

新增示例如下，“文件夹 ID”在本机器和远程机器必须一致，“文件夹标签”可以起别名用于说明文件存放的东西，“文件夹路径”默认会自动按照 “文件夹标签” 新建立目录（如果没有相同目录的话），“文件夹路径”可以和 “文件夹标签” 不同，也可以和 “文件夹 ID” 不同。

![](https://img-blog.csdnimg.cn/20200302174530360.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

实际应用示例：

![](https://img-blog.csdnimg.cn/20200302174853170.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20200302175036892.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

如下图所示，完整扫描间隔单位是 秒（86400 秒是 24 小时）。

![](https://img-blog.csdnimg.cn/20200302175114428.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

3、远程服务器配置

![](https://img-blog.csdnimg.cn/20200303192353637.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20200303192423655.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20200303192454773.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20200303192526986.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20200303192550100.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1hpYW9YaWFvX1Jlbkhl,size_16,color_FFFFFF,t_70)

4、遇到的问题：

之前安装过一次 syncthing，磁盘格式化后，同一位置重新安装后，启动后立即又停止了，最后发现 C 盘有临时文件，C:\Windows\system32\config\systemprofile\AppData\Local\Syncthing\

解决方法，将如上位置的 Syncthing 文件夹删除后，重启启动，即可运行正常。

注意：这个文件夹是更新同步日志记录，会定时进行清理（每天？重启？）。