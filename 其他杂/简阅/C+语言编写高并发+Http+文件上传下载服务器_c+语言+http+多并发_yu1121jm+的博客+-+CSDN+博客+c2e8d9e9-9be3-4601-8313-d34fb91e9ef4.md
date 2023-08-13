### C 语言编写高并发 Http 文件上传下载服务器

- 

  - [前言](#_2)

  - [项目效果图](#_8)

  - [项目介绍](#_14)

  - 

    - [环境介绍](#_16)

    - [程序结构之：event 相关](#event_21)

    - [程序结构之：http 相关](#http_163)

    - 

      - [第一种 客户端（浏览器）上传文件类 POST 请求](#__POST_165)

      - [第二种 获取文件列表类 GET 请求](#___GET_181)

      - [第三种 获取文件内容类 GET 请求](#___GET_189)

  - [源码地址：](#_201)

## 前言

前段时间学习 tinyhttpd 和 [libevent](https://so.csdn.net/so/search?q=libevent&spm=1001.2101.3001.7020) 开源库。
别人的代码写的再好终究是别人的，自以为看懂了，等到自己真正写的时候就会发现有各种问题。于是准备参考 libevent 里面最最最基础的功能（捡了芝麻丢了西瓜？），自己写一个 event，用于熟悉 libevent 的 I/O 多路复用思想。然后再加上 http。就有了这篇博客的 Http 高并发文件上传下载服务器（这里其实是**伪高并发**，下文会具体描述，原谅我的标题党，哈哈）。
共享代码给大家。希望可以帮助初学者熟悉 http 协议和 libevent 基础知识。如有问题，请大家不吝指出，谢谢！

## 项目效果图

1. 服务器启动

  ![](https://img-blog.csdn.net/20180928220009896?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3l1MTEyMWpt/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

2. 使用客户端（浏览器）访问效果，这里是 chrome

  ![](https://img-blog.csdn.net/20180928220133438?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3l1MTEyMWpt/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 项目介绍

这里只是简单介绍下，具体细节请大家看代码，文章最后贴有代码地址。

### 环境介绍

系统平台：windows
开发工具：vs2010
开发语言：C

### 程序结构之：event 相关

单线程，使用 I/O 多路复用实现并发。main 函数进来后直接调用 http_startup()。

```Plain Text
1
2
3
4
5
6
1
2
3
4
5
6

```

http_startup() 里面创建一个 socket 用于 listen，然后把这个 socket 扔到 event 里面，设置回调函数为 accept_callback，等待客户端（这里就是各种浏览器）连接。所贴代码为了逻辑清晰，去掉了一些代码。

```Plain Text
1
2
3
4
5
6
7
8
9
10
11
12
13
14
1
2
3
4
5
6
7
8
9
10
11
12
13
14

```

下面贴上 event 的核心，也就是 event_dispatch()
为了逻辑清晰，也去掉了一些代码。
这里就是所谓的伪高并发之一了（后面还有之二）：
由于是 windows 系统没有 epoll，为了简单使用了 select 模型。尽管重新定义了 FD_SETSIZE 为 1024，但是还是无关痛痒。1024 个连接就满了，而且 select 是轮询机制，效率受限。
开始准备使用 iocp，一来 api 的名字太难看了，就懒得研究了。二来我就是用来写个 demo 练练手，select 也能凑合着用。
伪高并发之二：
网络 I/O 使用的是阻塞 I/O，比如 recv，会阻塞。上传文件时每次读取 BUFFER_UNIT 个数据，测试时 log 打印发现还是会偶尔阻塞一会。把 BUFFER_UNIT 改小的可能会有所改善，但是也不是解决办法。应该改成非阻塞 I/O。这里也不讨论这个问题了。
#define BUFFER_UNIT 4096

```Plain Text
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47

```

再下面就是 event_add() 和 event_del()。这三个函数基本上就是 event 驱动模型的全部了，贴代码。老规矩，去掉部分空指针判断的代码。影响阅读代码逻辑

```Plain Text
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33

```

实际代码里面由于业务逻辑，这段代码与所贴不一致，哈哈

```Plain Text
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17

```

### 程序结构之：http 相关

本程序目前能支持的客户端请求有三种：

#### 第一种 客户端（浏览器）上传文件类 POST 请求

判断逻辑如下：uri 以 **/upload** 开头，
本来开始是没有后面的 **?path=**，后来发现服务器不知道保存到哪级目录下面，于是就加上了这个。
如下 url：

```Plain Text
1
2
1
2

```

使用 form 表单提交，html 上传代码如下：
html 代码都是服务端按逻辑生成的。

```Plain Text
1
2
3
4
1
2
3
4

```

#### 第二种 获取文件列表类 GET 请求

代码里面的 response_home_page() 函数。
判断逻辑如下：request 头里面的 uri 以 **/** 结尾，如下 url：

```Plain Text
1
2
3
1
2
3

```

#### 第三种 获取文件内容类 GET 请求

代码里面的 response_send_file_page() 函数。
判断逻辑如下：非以上两种情况，如下 url：

```Plain Text
1
2
3
1
2
3

```

先写这么多了，以后有时间再补充吧。（耐不住懒啊 ~）大家有问题请留言。

## 源码地址：

CSDN 下载： [https://download.csdn.net/download/yu1121jm/10695695
](https://download.csdn.net/download/yu1121jm/10695695)Github： [https://github.com/binbyu/httpd](https://github.com/binbyu/httpd)

