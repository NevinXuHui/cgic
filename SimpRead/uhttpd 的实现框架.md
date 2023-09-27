---
url: https://www.cnblogs.com/zmkeil/archive/2013/05/14/3078766.html
title: uhttpd 的实现框架
date: 2023-09-19 20:58:24
tag: 
banner: "https://images0.cnblogs.com/blog/517910/201305/14215754-b6fd3ac6631a44c698524ac3763cae57.png"
banner_icon: 🔖
---
    uhttpd 是一个简单的 web 服务器程序，以前没怎么接触过，所以这里主要是对 web 服务器设计的一些学习总结。Openwrt 系统中，真正用到的（需要了解的），其实不多，主要就是 cgi 的处理，包括与 cgi 程序的信息交互等，最后一节详细描述一下。

## 1.HTTP 协议概述

    HTTP 协议是目前互联网使用最广泛的应用层协议。其协议框架很简单，在一个 TCP 连接中，以一问一答的方式进行信息交互。具体讲，就是客户端（如常见的浏览器）connect 服务端的知名端口（通常是 80），建立一个 TCP 连接，然后发送一个 request；服务器端对该 request 解析后，发回相应的 response 应答，并关闭 TCP 连接。这就是一次交互，之后客户端再有请求，则重复上面的过程。

    交互报文格式如下图所示：

![](http://images0.cnblogs.com/blog/517910/201305/14215754-b6fd3ac6631a44c698524ac3763cae57.png)

Request 报文首行为 request-line，其中 type 有 GET、POST、HEAD 三种方式，然后最重要的是 url，它告诉服务器所请求的资源。Response 报文首行为 response-line，其中最重要的是 code，它告知客户端响应情况（found、redirect、error 等），然后跟一个简单的可读的短语。

两种报文后面具体的内容格式差不多，都是一些 headers（其中冒号前的 str 指明 header 类型），然后以一个空行标识 header 结束，后面是数据。对于 request，只有 POST 类型的请求需要提交数据，其它类型的是没有数据的。Response 报文的数据就是 url 所指定的资源文件（html、doc、gif 等）。

## 2. 服务器架构

    Uhttpd 作为一个简单的 web 服务器，其代码量并不多，而且组织结构比较清楚。和其它网络服务器差不多，其 main 函数进行一些初始化（首先 parse config-file，然后 parse argv），然后进入一个循环，不断地监听，每当有一个客户请求到达时，则对它进行处理。

    对于 web 服务器，所要做的处理主要就是分析 url，判断出是 file-request、cgi-request 或 lua-request，这主要是根据 url 的最前面的字符串（称为前缀 prefix）得出的；然后就用相应的形式进行处理。如下图所示：

![](http://images0.cnblogs.com/blog/517910/201305/14215754-41f4ee1e509044dd802ce73d21d8f182.png)

## 3.cig-response 流程

    前面已提到，openwrt 系统中使用的 uhttpd 服务，主要是用 cgi 方式来回应客户请求的，下面就对这种方式详细阐述。

### 3.1url 解析

    由上图红色字所示，uh_cgi_request 需要两个二外的参数 pathinfo 和 interpreter，其中 pin 是一个 struct，包含了路径中各种有用信息；ipr 指明所用的 cgi 程序，因为一个服务器中可以有多个 cgi 程序。

![](http://images0.cnblogs.com/blog/517910/201305/14215754-7fa1440ace4b4b80a3fd25a321c8ec6f.png)

    如图所示，docroot 是服务器的资源目录，是为了 os 准确定位资源位置，由 uhttpd 的 config 文件设定，如 openwrt 中为 / www。后面的是 client 传来的 url，开头的为 cgi-prefix，也是有 uhttpd 的 config 文件设定的，它指明 serv 端采用 cgi 处理方式，如 openwrt 中的为 / www/cgi-bin；紧接着的是 cgi 的程序名，它指明了使用哪个 cgi 程序；再后面就是实际的 path 信息了，在 cgi 方式中，它会被当成参数供 cgi 程序使用。

### 3.2cgi 处理框架

    要运行 cgi 程序，首先意味着需 fork 出一个子进程，并通过 execl 函数替换进程空间为 cgi 程序；其次，数据传递，子进程替换了进程空间后，怎么获得原信息，有怎么把回馈数据传输给父进程（即 uhttpd），父进程又怎么接收这些数据。

![](http://images0.cnblogs.com/blog/517910/201305/14215755-d05c087037cd43f2a85c34562e3209dd.png)

    首先创建了两个 pipe，这实际上是利用 AF_UNIX 协议域，创建两个相连的 socket_unix，那么它们映射的文件描述符（即这里的 fd[0]、fd[1]）就构成了一个 pipe，且这种关系即使 fork 后也仍然存在，因为 fork 仅是增加文件的引用次数，而 os 维护的 file 结构和 socket 结构都没变，这就是父子进程间传递数据的方式。然后 fork 出一个子进程。

    子进程中首先把两个管道的一端 close，注意这仅是使得文件引用次数变为 1。由于子进程待会要 excel 替换，替换后 rfd、wfd 就不存在了，因此先把它们 dup2 给知名的 stdin、stdout，这样即使 execl 替换后，ipt->extu 程序可以以此来和父进程传递数据。另外，execl 替换后，cgi 程序仍需要之前的一些参数信息，如 PATH_INFO 等，这种情况下，最简单的办法就是 setenv，把需要的参数设为环境变量。

    为什么要两个 pipe，因为子进程向父进程传递回馈数据需要一个 out-pipe，而若有 post 数据，子进程还需要一个 in-pipe，从父进程读取 post 数据。

    父进程中首先也是 close，同上所述。若有 post 数据，先从 httprequest-header 中得到 content-length，为后面传递给子进程做准备。然后进入一个循环（为什么要循环，什么时候退出，后面讲），通过 select 轮询 io，超时、中断的情况就不看了，轮询的 io 一个是 reader，即从子进程读取回馈数据，而若有 post 数据的话，还要另一个 io，writer，向子进程写 post 数据。主要的处理就是上图中红色字所示，具体如下：

![](http://images0.cnblogs.com/blog/517910/201305/14215755-90169cb221824ef0a636a7a6a73c825d.png)