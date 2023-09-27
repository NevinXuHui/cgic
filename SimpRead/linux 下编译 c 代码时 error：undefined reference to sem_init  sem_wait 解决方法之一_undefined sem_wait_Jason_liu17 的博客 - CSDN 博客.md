---
url: https://blog.csdn.net/loosen17/article/details/50524743
title: linux 下编译 c 代码时 error：undefined reference to sem_init  sem_wait 解决方法之一_undefined sem_wait_Jason_liu17 的博客 - CSDN 博客
date: 2023-09-18 11:12:05
tag: 
banner: "https://images.unsplash.com/photo-1694344862077-4d683f1a58e5?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjk1MDA2NzIwfA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
banner_icon: 🔖
---
最近写生产者消费者的代码遇到如下问题：

  

当我在终端输入如下：

gcc -o consumer.out consumer.c

  

就会出现下面的错误：

consumer.c:(.text+0xc9): undefined reference to `sem_post'

/tmp/ccvFyPLL.o: In function `consumer':

consumer.c:(.text+0x108): undefined reference to `sem_wait'

consumer.c:(.text+0x1c6): undefined reference to `sem_post'

/tmp/ccvFyPLL.o: In function `main':

consumer.c:(.text+0x1fe): undefined reference to `sem_init'

consumer.c:(.text+0x21a): undefined reference to `sem_init'

consumer.c:(.text+0x23f): undefined reference to `pthread_create'

consumer.c:(.text+0x264): undefined reference to `pthread_create'

consumer.c:(.text+0x278): undefined reference to `pthread_join'

consumer.c:(.text+0x28c): undefined reference to `pthread_join'

  

  

这个是因为 pthread 并非 Linux 系统的默认库，编译时注意加上 - lpthread 参数，以调用链接库

  

我们再一次在终端输入：gcc -o consumer.out consumer.c -lpthread

  

此时编译正确

  

执行：在终端输入：./consumer.out