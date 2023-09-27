**目录**

[🦄1. 了解 HTTP](#%F0%9F%A6%841.%20%E4%BA%86%E8%A7%A3HTTP)

[🦄2. 抓包](#%F0%9F%A6%842.%20%E6%8A%93%E5%8C%85%C2%A0)

[🦄3. http 协议格式](#%F0%9F%A6%843.%20http%E5%8D%8F%E8%AE%AE%E6%A0%BC%E5%BC%8F)

[🐲3.1 完整的 HTTP 请求格式](#%F0%9F%90%B23.1%20%E5%AE%8C%E6%95%B4%E7%9A%84HTTP%E8%AF%B7%E6%B1%82%E6%A0%BC%E5%BC%8F)

[🐲3.2 完整的 HTTP 响应的格式](#%F0%9F%90%B23.2%20%E5%AE%8C%E6%95%B4%E7%9A%84HTTP%E5%93%8D%E5%BA%94%E7%9A%84%E6%A0%BC%E5%BC%8F)

[HTTP 请求](#HTTP%E8%AF%B7%E6%B1%82%C2%A0%C2%A0)

[🦄4. 认识 URL](#%F0%9F%A6%844.%20%E8%AE%A4%E8%AF%86URL)

[🦄5. http 中的” 方法”](#%F0%9F%A6%845.%20http%E4%B8%AD%E7%9A%84%22%E6%96%B9%E6%B3%95%22)

[🐲5.1 get 是最常用的 HTTP 请求方法](#%F0%9F%90%B25.1%C2%A0get%20%E6%98%AF%E6%9C%80%E5%B8%B8%E7%94%A8%E7%9A%84HTTP%E8%AF%B7%E6%B1%82%E6%96%B9%E6%B3%95)

[🐲5.2. post 产生的途径](#%F0%9F%90%B25.2.%20post%20%E4%BA%A7%E7%94%9F%E7%9A%84%E9%80%94%E5%BE%84)

[面试题: get 和 post 的区别](#%E9%9D%A2%E8%AF%95%E9%A2%98%3A%20get%20%E5%92%8C%20post%20%E7%9A%84%E5%8C%BA%E5%88%AB)

[“post” 和 “get” 安全性问题](#%22post%22%20%E5%92%8C%20%22get%22%20%E5%AE%89%E5%85%A8%E6%80%A7%E9%97%AE%E9%A2%98%C2%A0)

[🐲6.1 Host: 表示服务器主机的地址和接口](#%F0%9F%90%B26.1%20Host%3A%E8%A1%A8%E7%A4%BA%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%BB%E6%9C%BA%E7%9A%84%E5%9C%B0%E5%9D%80%E5%92%8C%E6%8E%A5%E5%8F%A3)

[🐲6.2 Content-Length](#%F0%9F%90%B26.2%C2%A0Content-Length)

[🐲6.3 Content-Type](#%F0%9F%90%B26.3%C2%A0Content-Type)

[🐲6.4 User-Agent(UA)](#%F0%9F%90%B26.4%20User-Agent%28UA%29)

[🐲6.5 Referer](#%F0%9F%90%B26.5%20Referer)

[🐲6.6 Cookie](#%F0%9F%90%B26.6%20Cookie)

[🦄7. 认识请求正文 body](#%F0%9F%A6%847.%20%E8%AE%A4%E8%AF%86%E8%AF%B7%E6%B1%82%E6%AD%A3%E6%96%87body)

[HTTP 响应](#HTTP%E5%93%8D%E5%BA%94)

[🦄8. 状态码 (status code)](#%F0%9F%A6%848.%20%E7%8A%B6%E6%80%81%E7%A0%81%28status%20code%29)

[🦄9. 响应报头 header 和响应正文 body](#%F0%9F%A6%849.%20%E5%93%8D%E5%BA%94%E6%8A%A5%E5%A4%B4header%E5%92%8C%E5%93%8D%E5%BA%94%E6%AD%A3%E6%96%87body)

[🦄10. 构造 http 请求](#%F0%9F%A6%8410.%20%E6%9E%84%E9%80%A0http%E8%AF%B7%E6%B1%82)

[🐲10.1 通过 form 表单发送 GET 请求 和 POST 请求](#%F0%9F%90%B210.1%20%E9%80%9A%E8%BF%87form%E8%A1%A8%E5%8D%95%E5%8F%91%E9%80%81GET%E8%AF%B7%E6%B1%82%20%E5%92%8C%20POST%E8%AF%B7%E6%B1%82)

[同步异步的理解 (*)](#%E5%90%8C%E6%AD%A5%E5%BC%82%E6%AD%A5%E7%9A%84%E7%90%86%E8%A7%A3%28*%29)

[🐲10.2 通过 ajax 构造 http 请求](#%F0%9F%90%B210.2%20%E9%80%9A%E8%BF%87ajax%E6%9E%84%E9%80%A0http%E8%AF%B7%E6%B1%82)

[🐲10.3 通过 postman 构造 http 请求](#%F0%9F%90%B210.3%20%E9%80%9A%E8%BF%87postman%E6%9E%84%E9%80%A0http%E8%AF%B7%E6%B1%82)

**HTTP 协议, 前后端交互的桥梁**

**Tomcat [java](https://www.bmabk.com/) 中最主流的 HTTP 服务器之一, 写后端的代码, 很多都是基于 Tomcat 的二次开发**

**Servlet Tomcat 给后端程序员提供的开发服务器程序的 API 合集**

**[linux](https://www.bmabk.com/) 使用云服务器来部署写好的程序**

在网络技术中, 最核心的概念就是” 协议”

在应用层中, 有很多协议, 而 HTTP 就是应用层典型的协议,

应用层很多时候需要程序员自定义应用层协议, 也有一些现成的协议来让我们使用

**而 HTTP 就是其中最常使用的**

**(1) 浏览器和服务器的交互 (打开网页), 大可能性是 HTTP 协议**

**(2) 手机 APP 和服务器之间的交互, 也大可能性是 HTTP 协议**

目前 HTTP 版本最新是 3.0 了, 但最常见的还是 HTTP 1.1 版本

**🟧比如说在浏览器中打开一个网址, 这个过程就是通过 HTTP 和服务器进行了通信**

![](https://img-blog.csdnimg.cn/de5a9fe839ae48b4919d627d728596ed.png)

 HTTP 这个协议, 是属于最典型的” 一问一答” 模型的协议

**学习 HTTP 协议, 最关键的就是 HTTP 报文格式**

**报文格式就描述了 HTTP 请求是啥样的, 响应是啥样的**

**这就需要使用** **“抓包工具”** **来捕获请求交互的详细情况**

**抓包工具, 是个特殊的软件, 相当于一个” 代理程序”, 浏览器给服务器发的请求就会经过这个代理程序, 进一步的就能分析出请求和响应的结果如何**

![](https://img-blog.csdnimg.cn/db8adde3cea24523a0232eda24b275ea.png)

**正向代理** (给客户端提供服务的, 和客户端关系紧密) **站在服务器的角度,**

正向代理把真实的客户端给隐藏起来了, 服务器不知道真实的客户端是啥

**反向代理** (给服务器提供服务器的, 和服务器关系紧密)

**站在客户端的角度**, 反向代理把真实的服务器给隐藏起来了, 客户端不知道真实的服务器是啥

**使用抓包工具, 来分析 HTTP 协议的工作过程 (抓包工具很多,** **这里使用 fiddler****)**

[Fiddler | Web Debugging Proxy and Troubleshooting Solutions (telerik.com)](https://www.telerik.com/fiddler)

![](https://img-blog.csdnimg.cn/aef6b61035764bf2b8a3b047ee7c3612.png)

也可以直接点这个链接下载

**链接：[https://pan.baidu.com/s/1Ay95pOUzKDyCDE1OOa0u7w?pwd=xemc 
](https://pan.baidu.com/s/1Ay95pOUzKDyCDE1OOa0u7w?pwd=xemc )提取码：xemc**

需要注意的是, 现在单纯的 HTTP 很少了, 更多的是 HTTPS

HTTPS 可以理解为升级版本的 HTTP, 也就是在 HTTP 的基础上, 加了个加密层

所以, 这个要是直接抓的, 不一定能抓取到多个请求

**这就需要开启 fiddler, 抓取 HTTPS 的功能**

![](https://img-blog.csdnimg.cn/474862113ad54a3490bcbf1dfd6197c4.png)

![](https://img-blog.csdnimg.cn/184f5fddfe274f9a9e834ab1af2710dc.png)

如果开启了上面 HTTPS 也安装了根证书, 还是抓不到,

就要检查是否你的电脑上安装了其他的**代理程序 / 代理作用**的浏览器插件

 (这里的代理程序 / 代理作用比如: fq 工具 / 游戏加速器 / steam++, 本质上都是代理, 这些程序都会和 fiddler 发生冲突, 就是不可以同时运行. 所以使用 fiddler 时就要把其他的代理程序关闭 / 禁用)

**🟥下面来看一下 fiddler 的各区域的作用**

![](https://img-blog.csdnimg.cn/f52591ef421a4184af9779510ad27555.png)

![](https://img-blog.csdnimg.cn/e85e117db6e747c4a1c6432b155c7ca3.png)

**🟧 http 协议请求, 可以点击 view in Notepad, 用记事本打开**

![](https://img-blog.csdnimg.cn/de7c20056c864e3187651e5114c75815.png)

## 🐲3.1 完整的 HTTP 请求格式

**构造一个 HTTP 请求, 本质上就是往一个 TCP socket 中, 按照下列格式来写入数据即可**

![](https://img-blog.csdnimg.cn/0f54490efa5748009e7b537f0305a26e.png)

**小技巧: 清空 fiddler 中已经抓到的报文**

**先选中一个 ctrl+a 选中所有, 然后 delete 清空所有**

## 🐲3.2 完整的 HTTP 响应的格式

![](https://img-blog.csdnimg.cn/305811e9392d4c69892fbb8ab85a42ca.png)

**URL 唯一资源定位符** (用这个来找到网络上的资源)       

**URI 唯一资源标识符** (用这个来区分一个网络上的资源)

![](https://img-blog.csdnimg.cn/32b3ae7cf05c416aafdc06624dad3295.png)

**URL 里面是啥样子, 是有”****RFC 标准文档** **“来进行描述的**

RFC 标准文档, 描述了很多, 网络中的协议标准包括 IP TCP UDP HTTP …. 

![](https://img-blog.csdnimg.cn/c0f614ad622148a2b6b525c510c87e17.png)

(1) 协议方案名: URL 并非是 HTTP 独有的, 是给很多协议都能使用的, 比如 jdbc:mysql://

(2) 登录信息: 现在这种写法基本上没了, 都是单独写一个登录页面, 在输入框进行输入

**(3) 服务器地址**: 也就是服务器的 IP 地址, 也可以是域名 (域名和 IP 效果一样, DNS 域名解析系统, 能够帮我们自动的把域名转换为 IP 地址)

**(4) 服务器端口号**: 标识了要访问目标服务器的哪个进程 (将进程和端口号进行绑定, 在浏览器中的 URL 里面端口号经常会省略不写, 省略的时候使用的是当前协议的默认端口)

**(5) 带层次的文件路径**: 服务器进程可能会提供出很多的资源 (比如一些 html 文件或者 css 文件, 图片), 这些资源 又会放到一些具体的目录中(在 URL 中写的路径, 不一定就真的对应到服务器上的某个硬盘上的目录, 服务器上提供的资源, 可能是一个真实存在的文件, 也可能是一个” 虚拟出来的文件”)

访问静态资源: 硬盘上真实存在的资源

访问动态资源: 在应用程序代码中, 根据请求构造出来的一个 html 片段, 这种并不是硬盘上真实存在的文件, 但是也可以是一个标准的 html

**(6) 查询字符串:** ? 后面的也是 键值对 结构. 称为查询字符串, 相当于浏览器给服务器传递的一些必要的参数 (URL 中, 查询字符串, 键值对完全是自定义的)

(7) 片段标识符: 用来区分一个网页中的哪个部分, 可以借助于片段标识符快速跳转到网页的某个部分

把原始的字符 (按字节为单位转义), 转成转义符 (比如汉字) —–> URL encode(编码)

把转义后的字符还原成原始的字符 —-> URL decode(解码)

这里的” 方法” 可以理解为 **你这个请求想干啥**

|方法|说明|支持的 HTTP 协议版本|
|-|-|-|
|**get**|**获取资源**|**1.0  1.1**|
|**post**|**传输实体主体**|**1.0  1.1**|
|put|传输文件|1.0  1.1|
|head|获得报文首部|1.0  1.1|
|delete|删除文件|1.0  1.1|
|options|询问支持的方法|1.1|
|trace|追踪路径|1.1|
|connect|要求用隧道协议连接代理|1.1|
|link|建立和资源之间的联系|1.0|
|unlink|断开连接关系|1.0|

## **🐲5.1 get 是最常用的 HTTP 请求方法**

(1) 浏览器地址栏直接输入 URL, 此时就会触发 get

(2) html 里面的 link, a, img, script 也会触发 get 请求 (href/src 都会引用一个外部的资源, 本质上就是浏览器会重新发送一个 get 请求, 来从服务器拿到对应的数据)

(3) form 表单 html 里的 form 标签, 可以构造出 get 请求

(4) ajax

**get 请求的特点:**

(1) 首行第一部分为 get

(2) URL 的 query string 可以为空, 也可以不为空 (如果需要给服务器传递一些参数, 这些参数通常就是通过 querystring 来传过去的)

(3) header 部分有若干个键值对结构

(4) body 部分为空

## **🐲5.2. post 产生的途径**

(1) form

(2) ajax

**post 请求的特点**

(1) 方法叫做 post

(2) URL 通常是没有 query string 的

(3) 也是有若干 header, 键值对的形式

(4) body 这里通常是有的, post 在传递信息给服务器的时候, 通常就会把信息放到 body 中

## **面试题: get 和 post 的区别**

首先明确,
**get 和 post 没有本质上的区别**

这个” 没有本质上的区别” 是指,
**使用 get 实现的场景, 基本都可以使用 post 来代替**

使用 post 实现的场景, 也可以用 get 来代替

其次, 再来看
**细节上的区别**

**1) get 的语义, 是 “从服务器获取数据”, post 的语义, 是 “往服务器上提交数据”**

(虽说 http 当时设计是这样来规定的, 但是实际中, 程序员并没有遵守这个, 因为它那个设计是建议你采取这样的语义, 并不是说必须)

1. 使用习惯上,
**给服务器传递的消息, get 通常是放在 url 的 query string 中**

**post 通常是放在 body 中**

(但是 get 也是可以把数据放在 body 中的, 只不过很少见 ; post 也是可以把数据放在 query string 中的, 也很少见)

2. 

**get 请求建议实现成 “幂等” 的, post 一般则不要求实现成 “幂等”**

(幂等: 输入确定, 输出结果也就是确定的)

比如  设计服务器的时候, 就需要提供一些 “接口 / api”

api 传入的参数, 就视为是输入

api 返回的结果, 就视为是输出

基于 get 的 api 一般会建议设计成幂等的

基于 post 的 api 则无要求

**4) 在幂等的基础上, get 的请求结果是可以被缓存的 (浏览器默认的行为), post 则一般不会缓存**

如果当前 get 确实是幂等的, 就不必处理, 就让浏览器缓存, 没问题

如果当前 get 不是幂等的, 就需要提供特殊技巧避免浏览器产生缓存 (典型的技巧是, 让每次 get 请求的 url 都不相同, 通过特殊的 query string 来保证 url 不同)

## **“post” 和 “get” 安全性问题** 

**有一种说法是, get 把参数放到 url 中, 如果实现登录页面, 点击登录后, 你的用户名和密码就直接以 query string 的形式放到 url 中了, 就直接显示到浏览器地址栏中了, 会被别人看到, 所以就不安全**

**而 post 是把参数放到 body 中, body 不会显示到浏览器界面上, 所以就不会直接显示出来就更安全**

**需要注意的是, 虽然把用户名和密码放到 url 中不好, 但是放到 post 的 body 中也并没有说更加的安全,**

**不能说 “不在用户界面上显示” 就是安全 (比如说我如果这里拿抓包工具也可以查看到用户名和密码, 所以这种安全也太没价值了吧)**

**安全, 应该就是比如数据被人截获后, 不会对你的数据造成泄露这样的影响, 所以只要没给代码进行加密, 就根本谈不上” 安全”**

http 是没有加密功能的, 而 https 是有一定的加密功能的,

但相对来说实际中, 主要还是通过业务上的代码来实现加密

header 也是” 键值对” 的结构, 这里都是标准规定的, 有特定含义的, 也可以放一些自定义的键值对

## **🐲6.1 Host: 表示服务器主机的地址和接口**

Host:gia.jd.com   放的就是 ip + 端口

这里的端口可以省略, 省略则表示默认值

HTTP 的默认值是 80    HTTPS 的默认值是 443

![](https://img-blog.csdnimg.cn/582f3caa43e046c28388ac90b59c0898.png)

可以看到 URL 里面也有这个服务器主机的 IP 和端口, 那为啥还要搞一个 Host

这是因为, **实际上 URL 中的 IP 和端口, 和 Host 中的 IP 和端口不一定完全一样**

(当请求经过代理来访问的时候, 是可能会不一样的)

![](https://img-blog.csdnimg.cn/05adfac16d11477b92fe626fa363864d.png)

## **🐲6.2 Content-Length**

**Content-Length(表示 body 中的数据长度)**

**Content-Length   Content-Type   这两个字段, 不一定有, 但如果有肯定是同时出现的**

如果请求没有 body(GET) 就没有这两个字段

如果请有 body(POST) 一定有这两个字段

**HTTP 协议, 在传输层是基于 TCP(至少在 HTTP3.0 之前是这样的, 在 3.0 就变为了 UDP)**

**TCP 是面向字节流的, 这就会有粘包问题** (关于这个可以看我这篇博客 [http://t.csdn.cn/buEsA](http://t.csdn.cn/buEsA))

当时是这样解释的

![](https://img-blog.csdnimg.cn/3f1e845f1cd1410a92131e6c3b827723.png)

 **而 TCP 接收缓冲区是这样的**

![](https://img-blog.csdnimg.cn/969e7a64b764469cb1bb22c1b8dbd632.png)

**所以这就需要 Content-Length 来表示 body 中的数据长度,** **来解决粘包问题**

Content-Length 不需要我们自己手动设置, 一般都是浏览器和 HTTP 服务器自己计算好的

## **🐲6.3 Content-Type**

**Content-Type(表示请求的 body 中的数据格式)**

Content-Type:body 中的数据可以存放很多种格式, 而这对于接收方来说, 解析方式是截然不同的 

常见选项

**(1) application/x-www-form-urlencoded: form 表单构造的请求,** 就是这个 Content-Type

**body 的格式**

```Plain Text
title=test&content=hello

```

这个格式就是和 query string 是一样的, 里面可以放多个键值对, 键值对之间使用 & 来分割

键和值之间使用 = 来分割 (并且这里也是需要 urlencode 的)

**(2) multipart/form-data: 这个格式主要是在上传文件的时候会出现**

```Plain Text
Content-Type:multipart/form-data; boundary=----
WebKitFormBoundaryrGKCBY7qhFd3TrwA 
------WebKitFormBoundaryrGKCBY7qhFd3TrwA 
Content-Disposition: form-data; name="text" 
title 
------WebKitFormBoundaryrGKCBY7qhFd3TrwA 
Content-Disposition: form-data; name="file"; filename="chrome.png" 
Content-Type: image/png 
PNG ... content of chrome.png ... 
------WebKitFormBoundaryrGKCBY7qhFd3TrwA--

```

**(3) application/json   数据为 json 格式**

body 格式比如: 

```Plain Text
{"username":"123456789","password":"xxxx","code":"jw7l","uuid":"d110a05ccde64b16
a861fa2bddfdcd15"}

```

## 🐲6.4 User-Agent(UA)

**UA 主要包含的信息, 就是 操作系统信息 和 浏览器信息**

**描述了用户在使用啥样的设备来上网**

![](https://img-blog.csdnimg.cn/fb2c8f1b93244c319a578a22dd59877a.png)

 以前的浏览器, 是支持文字,–> 开始支持图片 —> 能够支持 js  —> 能够支持音频视频

浏览器就是这样慢慢来发展的

这样的情况, 就会导致同一个时间段内, 可以存在好多种浏览器

**此时就会有一些问题**

**1, 实现一个纯文字的页面, 可以让所以人都能打开, 但这也太老了**

**2. 实现一个支持音频视频 + js 的网站, 就会让一些浏览器打不开**

所以为了解决这个问题就可以,

**通过 UA 来收集到浏览器 / 操作系统的信息, 进一步的就知道浏览器 / 系统支持啥样的页面**

如果是一个比较老的浏览器, 那就返回一个老的页面

如果是一个比较新版本的浏览器, 那就返回一个功能更丰富的页面

**而慢慢发展到今天, 浏览器基本上都一样了, 开发人员也就不用考虑这么多版本兼容问题了**

**UA 这块的作用可以说是结束了**

但 **UA 还有其他的作用**

现在存在的几种主流上网设备, PC, 平板, 手机, 屏幕的大小都是不同的, 打开浏览器页面的大小也是不同的

所以这个时候 **UA 就可以, 来识别出 PC / 手机 / 平板 (来开发出不同版本的页面了)**

这里就有个技术叫” 响应式页面” 通过特殊的 CSS 和 JS, 来感知当前浏览器窗口的尺寸, 根据不同的尺寸来进行重新页面布局排列, 这样一个页面就可以兼容多个设备了

## **🐲6.5 Referer**

**表示这个页面是从哪个页面跳转过来的, 所以可能会有的没有, 有的有**

**如果直接在浏览器中输入 URL, 或者直接通过收藏夹访问页面时是没有 Referer 的.**

## **🐲6.6 Cookie**

**也是请求头中的一个重要字段, 是浏览器在本地存储数据 (存到硬盘上) 的一种机制**

![](https://img-blog.csdnimg.cn/e7df43c15cb34f8aaa133bf469c6f071.png)

 为了解决这个问题, 浏览器就专门提供了特殊的 API 来给网页使用, 可以让网页存储一些简单的数据

**浏览器提供的持久化存储方法有好几种**

**Cookie 是最经典的一种方案 (最老)**

LocalStorage 是一种比较新的方案

indexDB 是更新的方法

![](https://img-blog.csdnimg.cn/25fbb7664f384406a1cefc3d208352f6.png)

**1. cookie** 不是缓存 (缓存中的数据不一定持久化, 也可以在内存里缓存, 缓存中的数据时用来” 提高访问速度的”),

**是持久化存储数据 (保存在硬盘) 的手段**

**2. cookie 和 get 没直接关系, 其他的 post, put … 的也都有 cookie**

**3. cookie 这里的键值对 都是简单的字符串**

**使用 cookie 作为保存数据的手段, 只能存一些简单的键值对信息, 简单的字符串**

如果想让 cookie 存图片 / 视频 / flash… 它是做不到的

比如, 可以使用 cookie 存 (具体存什么, 程序员自定义)

**(1) 上次访问页面的时间**

**(2) 当前网页的访问次数**

**(3) 当前访问页面的身份信息 (身份标识, id)**

**1. cookie 从哪里来**

cookie 是存在浏览器的, **来源是服务器**

![](https://img-blog.csdnimg.cn/3a080a670cd94607a7ce739765affa29.png)

在服务器返回的响应报文中, 可以在响应 header 中包含一个 / 多个 Set-Cookie (键值对) 这样的资源 (程序员在服务器代码中构造出来的)

浏览器看到 Set-Cookie 就会把这样的数据给保存在浏览器本地

**2. cookie 到哪里去**

来自于服务器, **存储于浏览器,**

当浏览器保存了 cookie 之后, 下次浏览器访问同一个网站, 就会**把之前本地存储的 cookie 再通过 http 请求 header 中的 cookie 给带过去**

为啥数据要这样转一圈

服务器要服务的客户端是很多的, 这些不同的客户端应该要有不同的数据

**cookie 最典型的应用**

**最常用的场景就是在客户端维持登录状态**

在某个网站上登录成功之后, 浏览器就会记住当前登录用户的身份信息

然后接下来访问该网站的其他页面, 服务器也能知道现在是谁在登录

下面来看一下, 这个过程 

![](https://img-blog.csdnimg.cn/53e76f676d1943ab8f4839cd2114863a.png)

很多网站都是上面这一套步骤来实现的 (主流方式)

但现在一些比较新的网站, 就不这样用 cookie 来进行本地存储了

而是使用 localStorage 之类的方法来保存

正文中的内容格式和 header 中的 Content-Type 密切相关

有三种常见的情况

**1) application/x-www-form-urlencoded**

**2) multipart/form-data**

**3) application/json**

状态码是一个数字, 这个数字描述了当前这次请求的 “状态”(成功 / 失败 / 其他一些状态)

[HTTP 状态码大全 (常见 HTTP Status Code 含义查询) – 桔子 SEO (juziseo.com)](https://seo.juziseo.com/doc/http_code/)

这里介绍几种常见的状态码

**(1) 200 表示访问成功 (平时正常打开网站, 都是这个状态)**

打开 Fiddler 可以看到这一列的状态都是 200

![](https://img-blog.csdnimg.cn/63d9cdd0724145b2a37dd6c132e0b4f7.png)

 **(2)404 Not found(后面学习后端开发, 会经常见到这个错误)**

**请求的内容未找到或已删除 (就是请求路径写错了)**

请求里 -> url -> 路径 (表示你要访问的服务器上的资源)

如果你想访问的资源, 服务器上没有, 此时就会返回 404

**可以看到我这里再 bing.com 中随便进一个页面, 找不到就会给我返回一个 404 的状态**

![](https://img-blog.csdnimg.cn/8c497fec35bf4c21addd0ea7186727e2.png)

还有一种情况是这样的, 比如我在 B 站上随便输入一个页面, 找不到就会返回一个 404 页面

但是这个 404 的相当于一个有” 皮肤” 的 404 (打开 Fiddler 可以看到还是 404 的页面)

![](https://img-blog.csdnimg.cn/f1bf9d80737f41cfb69a9bf76a6242c9.png)

**(3) 403 Forbidden 访问被拒绝 (没有权限)**

404 和 403 本质上都是客户端这里出了问题,

**4XX 都是客户端出现错误状态**

**(4) 500 Internal Server Error   服务器内部错误**

服务器代码执行过中, 出现异常了

**(5) 504 Gateway Timeout  访问超时了**

一般就是服务器请求量很大的时候, 对于服务器的负荷就比较重, 导致一些请求来不及响应就会超时 5

**5XX 是服务器错误信息状态**

**(6) 302 重定向**

**访问一个旧的 URL 自动转移到新的 URL 上, 这个很常见**

a. 服务器的地址迁移      (比如一个服务器的域名更换了, 防止有人还访问旧的域名, 那么此时给这个搞一个重定向, 就可以在访问旧域名时, 自动进行跳转到新的域名, 来进行一个过渡)

b. 搜索引擎点击跳转

![](https://img-blog.csdnimg.cn/66a133b2110a400a9474d347827074af.png)

响应报头的基本格式和请求报头格式基本一致

类似于 Content-Type , Content-Length 等属性的含义也和请求中的含义一致

**Content-Type**

text/html
: body
数据格式是
HTML

text/css
: body
数据格式是
CSS

application/**[javascript
](https://www.bmabk.com/)**: body
数据格式是
JavaScript

application/json
: body
数据格式是
JSON

**正文的具体格式取决于 Content-Type**

## **🐲10.1 通过 form 表单发送 GET 请求 和 POST 请求**

如何构造 http 请求, 浏览器自己构造的 (地址栏中写 url, 构造出 get 请求, 点击 a 标签, 也会构造 get 请求 img,link,script, 也会构造 get 请求)

**form (表单) 是 HTML 中的一个常用标签. 也可以用于给服务器发送 GET 或者 POST 请求**

**form 最关键的作用, 就是给服务器传键值对**

**get 是直接在 url 中可以看到,  post 可以在 body 中看到**

![](https://img-blog.csdnimg.cn/c78c0321a6314f3db2e0633212eeeec7.png)

**此时这个键值对就出现在了 URL 中**

![](https://img-blog.csdnimg.cn/27ae1fbb8b5042a59d0bbe807d382703.png)

 借助这些标签来给请求构造数据, 键值对结构的数据

**每个 input 就对应一个键值对, input 的 name 属性就是 “键”,input 里用户输入的内容就是” 值”**

**如果方法是 get, 那么键值对就会出现在 url 的 query string 中**

**如果方法是 post, 那么键值对就会放到 body 中**

如果此时把 method 修改为 post 

![](https://img-blog.csdnimg.cn/af1ed21caab942acb7cf58130df9df61.png)

![](https://img-blog.csdnimg.cn/b10fce45320949e4be84b6fa5af7b8c4.png)

**使用 Fiddler 抓这个包, 可以看到在 body 中**

![](https://img-blog.csdnimg.cn/34fbb8a6c4b64e2687573a54c71585d9.png)

之前学习 java 多线程时, 加锁时的关键字 synchronized 这个意思是同步的

而现在学习 ajax 它的全称是 **A**synchronous **J**avascript

asynchronized 异步的 (给同步的前面加个 a)

同步这个词有多种含义 (彼此之间没有联系)

在多线程中的同步, 指的就是” 互斥”

在网络通信 / IO 操作的时候, 也涉及到同步

表示的含义是, 谁发起的请求, 谁负责接收结果

(去饭店吃饭, 我点的单, 我自己取餐端走)

而异步是和上面的同步相对的

表示的是, 发起请求的主体, 不负责接收结果, 而是由别人主动推送过来 (ajax 就是这个)

(去饭店吃饭, 我点的单, 服务员把餐取走)

## 🐲10.2 通过 ajax 构造 http 请求

form 只能构造 post 和 get 请求, 而 **ajax 比 form 更好, 可以各种 http 方法都能构造**

**ajax 还有一个特点是**

**form 构造的 http 请求, 一定会触发页面跳转**

**ajax 默认发起的请求不会引起跳转, 也可以手动控制跳转**

使用 ajax 不去触发跳转, 就可以达到” 局部刷新” 的效果 (这个大大提高了页面的加载效率)

在代码中使用 ajax 构造 http 请求

ajax api 是属于浏览器元素自带的, 但原生的 api 不太好用

所以, 可以使用第三方库, 封装好的 api, 来代替原生的 api

**ajax 构造 http 请求, 使用第三方库 jquery, 可以直接通过网络地址, 把 jquery 引入到代码中**

(搜索 jquery cdn) 

![](https://img-blog.csdnimg.cn/d31ff9c235b040e68090d584df2cded9.png)

需要明白的是, 不论哪个编程语言, 只要可以操作网络 (能够进行 socket 编程) 就一定可以构造 http 请求(往一个 tcp socket 里写一个符合 http 协议格式的字符串)

## 🐲10.3 通过 postman 构造 http 请求

**postman 就属于一个专门用来构造 HTTP 请求的第三方工具, 主要用来帮助我们进行 接口测试**

接口测试: 后端写好了服务器之后, 需要提供一些 HTTP 的接口 (可以接收一些 HTTP 请求, 返回不同的响应), 程序员就要验证下接口对不对, 就可以使用前面说的这些办法来发 (浏览器地址栏, a 标签, form,ajax)

**这里就有一个专门用来构造 HTTP 请求的工具 (postman), 更方便的来构造 http 请求了**

postwoman: 也是用来构造 http 请求

[可以点这里进行下载    Postman](https://www.postman.com/)

![](https://img-blog.csdnimg.cn/d2187a910abb45dab76c34171fd3c813.png)

