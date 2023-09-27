---
url: https://blog.csdn.net/github_37687123/article/details/110915573
title: c 语言实现 http 下载功能_c 语言 下载 http 文件_Ya 土豆儿~ 的博客 - CSDN 博客
date: 2023-06-30 13:14:55
tag: 
banner: "https://img-blog.csdnimg.cn/20201209091948192.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpdGh1Yl8zNzY4NzEyMw==,size_16,color_FFFFFF,t_70"
banner_icon: 🔖
---
**目录**

[HTTP 请求方法](#HTTP%20%E8%AF%B7%E6%B1%82%E6%96%B9%E6%B3%95)

[HTTP 响应头信息](#HTTP%20%E5%93%8D%E5%BA%94%E5%A4%B4%E4%BF%A1%E6%81%AF)

[HTTP 状态码](#HTTP%E7%8A%B6%E6%80%81%E7%A0%81)

[HTTP 状态码分类](#HTTP%E7%8A%B6%E6%80%81%E7%A0%81%E5%88%86%E7%B1%BB)

[代码实现](#%E4%BB%A3%E7%A0%81%E5%AE%9E%E7%8E%B0)

[运行效果](#%E8%BF%90%E8%A1%8C%E6%95%88%E6%9E%9C)

HTTP 协议（HyperText Transfer Protocol，超文本传输协议）是因特网上应用最为广泛的一种网络传输协议，所有的 WWW 文件都必须遵守这个标准。

HTTP 是一个基于 TCP/IP [通信协议](https://so.csdn.net/so/search?q=%E9%80%9A%E4%BF%A1%E5%8D%8F%E8%AE%AE&spm=1001.2101.3001.7020)来传递数据（HTML 文件, 图片文件, 查询结果等）。

# HTTP 请求方法

根据 HTTP 标准，HTTP 请求可以使用多种请求方法。

HTTP1.0 定义了三种请求方法： GET, POST 和 HEAD 方法。

HTTP1.1 新增了六种请求方法：OPTIONS、PUT、PATCH、DELETE、TRACE 和 CONNECT 方法。

<table><tbody><tr><th>序号</th><th>方法</th><th>描述</th></tr><tr><td>1</td><td>GET</td><td>请求指定的页面信息，并返回实体主体。</td></tr><tr><td>2</td><td>HEAD</td><td>类似于 GET 请求，只不过返回的响应中没有具体的内容，用于获取报头</td></tr><tr><td>3</td><td>POST</td><td>向指定资源提交数据进行处理请求（例如提交表单或者上传文件）。数据被包含在请求体中。POST 请求可能会导致新的资源的建立和 / 或已有资源的修改。</td></tr><tr><td>4</td><td>PUT</td><td>从客户端向服务器传送的数据取代指定的文档的内容。</td></tr><tr><td>5</td><td>DELETE</td><td>请求服务器删除指定的页面。</td></tr><tr><td>6</td><td>CONNECT</td><td>HTTP/1.1 协议中预留给能够将连接改为管道方式的代理服务器。</td></tr><tr><td>7</td><td>OPTIONS</td><td>允许客户端查看服务器的性能。</td></tr><tr><td>8</td><td>TRACE</td><td>回显服务器收到的请求，主要用于测试或诊断。</td></tr><tr><td>9</td><td>PATCH</td><td>是对 PUT 方法的补充，用来对已知资源进行局部更新 。</td></tr></tbody></table>

# HTTP 响应头信息

HTTP 请求头提供了关于请求，响应或者其他的发送实体的信息。

在本章节中我们将具体来介绍 HTTP 响应头信息。

<table><tbody><tr><th>应答头</th><th>说明</th></tr><tr><td>Allow</td><td><p>服务器支持哪些请求方法（如 GET、POST 等）。</p></td></tr><tr><td>Content-Encoding</td><td><p>文档的编码（Encode）方法。只有在解码之后才可以得到 Content-Type 头指定的内容类型。利用 gzip 压缩文档能够显著地减少 HTML 文档的下载时间。Java 的 GZIPOutputStream 可以很方便地进行 gzip 压缩，但只有 Unix 上的 Netscape 和 Windows 上的 IE 4、IE 5 才支持它。因此，Servlet 应该通过查看 Accept-Encoding 头（即 request.getHeader("Accept-Encoding")）检查浏览器是否支持 gzip，为支持 gzip 的浏览器返回经 gzip 压缩的 HTML 页面，为其他浏览器返回普通页面。</p></td></tr><tr><td>Content-Length</td><td><p>表示内容长度。只有当浏览器使用持久 HTTP 连接时才需要这个数据。如果你想要利用持久连接的优势，可以把输出文档写入 ByteArrayOutputStream，完成后查看其大小，然后把该值放入 Content-Length 头，最后通过 byteArrayStream.writeTo(response.getOutputStream() 发送内容。</p></td></tr><tr><td>Content-Type</td><td><p>表示后面的文档属于什么 MIME 类型。Servlet 默认为 text/plain，但通常需要显式地指定为 text/html。由于经常要设置 Content-Type，因此 HttpServletResponse 提供了一个专用的方法 setContentType。</p></td></tr><tr><td>Date</td><td><p>当前的 GMT 时间。你可以用 setDateHeader 来设置这个头以避免转换时间格式的麻烦。</p></td></tr><tr><td>Expires</td><td><p>应该在什么时候认为文档已经过期，从而不再缓存它？</p></td></tr><tr><td>Last-Modified</td><td><p>文档的最后改动时间。客户可以通过 If-Modified-Since 请求头提供一个日期，该请求将被视为一个条件 GET，只有改动时间迟于指定时间的文档才会返回，否则返回一个 304（Not Modified）状态。Last-Modified 也可用 setDateHeader 方法来设置。</p></td></tr><tr><td>Location</td><td><p>表示客户应当到哪里去提取文档。Location 通常不是直接设置的，而是通过 HttpServletResponse 的 sendRedirect 方法，该方法同时设置状态代码为 302。</p></td></tr><tr><td>Refresh</td><td><p>表示浏览器应该在多少时间之后刷新文档，以秒计。除了刷新当前文档之外，你还可以通过 setHeader("Refresh", "5; URL=http://host/path") 让浏览器读取指定的页面。<br>注意这种功能通常是通过设置 HTML 页面 HEAD 区的＜META HTTP-EQUIV="Refresh" CONTENT="5;URL=http://host/path"＞实现，这是因为，自动刷新或重定向对于那些不能使用 CGI 或 Servlet 的 HTML 编写者十分重要。但是，对于 Servlet 来说，直接设置 Refresh 头更加方便。<br>注意 Refresh 的意义是 "N 秒之后刷新本页面或访问指定页面"，而不是 "每隔 N 秒刷新本页面或访问指定页面"。因此，连续刷新要求每次都发送一个 Refresh 头，而发送 204 状态代码则可以阻止浏览器继续刷新，不管是使用 Refresh 头还是＜META HTTP-EQUIV="Refresh" ...＞。<br>注意 Refresh 头不属于 HTTP 1.1 正式规范的一部分，而是一个扩展，但 Netscape 和 IE 都支持它。</p></td></tr><tr><td>Server</td><td><p>服务器名字。Servlet 一般不设置这个值，而是由 Web 服务器自己设置。</p></td></tr><tr><td>Set-Cookie</td><td><p>设置和页面关联的 Cookie。Servlet 不应使用 response.setHeader("Set-Cookie", ...)，而是应使用 HttpServletResponse 提供的专用方法 addCookie。参见下文有关 Cookie 设置的讨论。</p></td></tr><tr><td>WWW-Authenticate</td><td><p>客户应该在 Authorization 头中提供什么类型的授权信息？在包含 401（Unauthorized）状态行的应答中这个头是必需的。例如，response.setHeader("WWW-Authenticate", "BASIC realm=＼"executives＼"")。<br>注意 Servlet 一般不进行这方面的处理，而是让 Web 服务器的专门机制来控制受密码保护页面的访问（例如. htaccess）。</p></td></tr></tbody></table>

# HTTP [状态码](https://so.csdn.net/so/search?q=%E7%8A%B6%E6%80%81%E7%A0%81&spm=1001.2101.3001.7020)

当浏览者访问一个网页时，浏览者的浏览器会向网页所在服务器发出请求。当浏览器接收并显示网页前，此网页所在的服务器会返回一个包含 HTTP 状态码的信息头（server header）用以响应浏览器的请求。

HTTP 状态码的英文为 HTTP Status Code。

下面是常见的 HTTP 状态码：

*   200 - 请求成功
*   301 - 资源（网页等）被永久转移到其它 URL
*   404 - 请求的资源（网页等）不存在
*   500 - 内部服务器错误

# HTTP 状态码分类

HTTP 状态码由三个十进制数字组成，第一个十进制数字定义了状态码的类型，后两个数字没有分类的作用。HTTP 状态码共分为 5 种类型：

<table><caption>HTTP 状态码分类</caption><tbody><tr><th>分类</th><th>分类描述</th></tr><tr><td>1**</td><td>信息，服务器收到请求，需要请求者继续执行操作</td></tr><tr><td>2**</td><td>成功，操作被成功接收并处理</td></tr><tr><td>3**</td><td>重定向，需要进一步的操作以完成请求</td></tr><tr><td>4**</td><td>客户端错误，请求包含语法错误或无法完成请求</td></tr><tr><td>5**</td><td>服务器错误，服务器在处理请求的过程中发生了错误</td></tr></tbody></table>

HTTP 状态码列表:

<table><caption>HTTP 状态码列表</caption><tbody><tr><th>状态码</th><th>状态码英文名称</th><th>中文描述</th></tr><tr><td>100</td><td>Continue</td><td>继续。<a href="http://www.dreamdu.com/webbuild/client_vs_server/" target="_blank">客户端</a>应继续其请求</td></tr><tr><td>101</td><td>Switching Protocols</td><td>切换协议。服务器根据客户端的请求切换协议。只能切换到更高级的协议，例如，切换到 HTTP 的新版本协议</td></tr><tr><td colspan="3">&nbsp;</td></tr><tr><td>200</td><td>OK</td><td>请求成功。一般用于 GET 与 POST 请求</td></tr><tr><td>201</td><td>Created</td><td>已创建。成功请求并创建了新的资源</td></tr><tr><td>202</td><td>Accepted</td><td>已接受。已经接受请求，但未处理完成</td></tr><tr><td>203</td><td>Non-Authoritative Information</td><td>非授权信息。请求成功。但返回的 meta 信息不在原始的服务器，而是一个副本</td></tr><tr><td>204</td><td>No Content</td><td>无内容。服务器成功处理，但未返回内容。在未更新网页的情况下，可确保浏览器继续显示当前文档</td></tr><tr><td>205</td><td>Reset Content</td><td>重置内容。服务器处理成功，用户终端（例如：浏览器）应重置文档视图。可通过此返回码清除浏览器的表单域</td></tr><tr><td>206</td><td>Partial Content</td><td>部分内容。服务器成功处理了部分 GET 请求</td></tr><tr><td colspan="3">&nbsp;</td></tr><tr><td>300</td><td>Multiple Choices</td><td>多种选择。请求的资源可包括多个位置，相应可返回一个资源特征与地址的列表用于用户终端（例如：浏览器）选择</td></tr><tr><td>301</td><td>Moved Permanently</td><td>永久移动。请求的资源已被永久的移动到新 URI，返回信息会包括新的 URI，浏览器会自动定向到新 URI。今后任何新的请求都应使用新的 URI 代替</td></tr><tr><td>302</td><td>Found</td><td>临时移动。与 301 类似。但资源只是临时被移动。客户端应继续使用原有 URI</td></tr><tr><td>303</td><td>See Other</td><td>查看其它地址。与 301 类似。使用 GET 和 POST 请求查看</td></tr><tr><td>304</td><td>Not Modified</td><td>未修改。所请求的资源未修改，服务器返回此状态码时，不会返回任何资源。客户端通常会缓存访问过的资源，通过提供一个头信息指出客户端希望只返回在指定日期之后修改的资源</td></tr><tr><td>305</td><td>Use Proxy</td><td>使用代理。所请求的资源必须通过代理访问</td></tr><tr><td>306</td><td>Unused</td><td>已经被废弃的 HTTP 状态码</td></tr><tr><td>307</td><td>Temporary Redirect</td><td>临时重定向。与 302 类似。使用 GET 请求重定向</td></tr><tr><td colspan="3">&nbsp;</td></tr><tr><td>400</td><td>Bad Request</td><td>客户端请求的语法错误，服务器无法理解</td></tr><tr><td>401</td><td>Unauthorized</td><td>请求要求用户的身份认证</td></tr><tr><td>402</td><td>Payment Required</td><td>保留，将来使用</td></tr><tr><td>403</td><td>Forbidden</td><td>服务器理解请求客户端的请求，但是拒绝执行此请求</td></tr><tr><td>404</td><td>Not Found</td><td>服务器无法根据客户端的请求找到资源（网页）。通过此代码，网站设计人员可设置 "您所请求的资源无法找到" 的个性页面</td></tr><tr><td>405</td><td>Method Not Allowed</td><td>客户端请求中的方法被禁止</td></tr><tr><td>406</td><td>Not Acceptable</td><td>服务器无法根据客户端请求的内容特性完成请求</td></tr><tr><td>407</td><td>Proxy Authentication Required</td><td>请求要求代理的身份认证，与 401 类似，但请求者应当使用代理进行授权</td></tr><tr><td>408</td><td>Request Time-out</td><td>服务器等待客户端发送的请求时间过长，超时</td></tr><tr><td>409</td><td>Conflict</td><td>服务器完成客户端的 PUT 请求时可能返回此代码，服务器处理请求时发生了冲突</td></tr><tr><td>410</td><td>Gone</td><td>客户端请求的资源已经不存在。410 不同于 404，如果资源以前有现在被永久删除了可使用 410 代码，网站设计人员可通过 301 代码指定资源的新位置</td></tr><tr><td>411</td><td>Length Required</td><td>服务器无法处理客户端发送的不带 Content-Length 的请求信息</td></tr><tr><td>412</td><td>Precondition Failed</td><td>客户端请求信息的先决条件错误</td></tr><tr><td>413</td><td>Request Entity Too Large</td><td>由于请求的实体过大，服务器无法处理，因此拒绝请求。为防止客户端的连续请求，服务器可能会关闭连接。如果只是服务器暂时无法处理，则会包含一个 Retry-After 的响应信息</td></tr><tr><td>414</td><td>Request-URI Too Large</td><td>请求的 URI 过长（URI 通常为网址），服务器无法处理</td></tr><tr><td>415</td><td>Unsupported Media Type</td><td>服务器无法处理请求附带的媒体格式</td></tr><tr><td>416</td><td>Requested range not satisfiable</td><td>客户端请求的范围无效</td></tr><tr><td>417</td><td>Expectation Failed</td><td>服务器无法满足 Expect 的请求头信息</td></tr><tr><td colspan="3">&nbsp;</td></tr><tr><td>500</td><td>Internal Server Error</td><td>服务器内部错误，无法完成请求</td></tr><tr><td>501</td><td>Not Implemented</td><td>服务器不支持请求的功能，无法完成请求</td></tr><tr><td>502</td><td>Bad Gateway</td><td>作为网关或者代理工作的服务器尝试执行请求时，从远程服务器接收到了一个无效的响应</td></tr><tr><td>503</td><td>Service Unavailable</td><td>由于超载或系统维护，服务器暂时的无法处理客户端的请求。延时的长度可包含在服务器的 Retry-After 头信息中</td></tr><tr><td>504</td><td>Gateway Time-out</td><td>充当网关或代理的服务器，未及时从远端服务器获取请求</td></tr><tr><td>505</td><td>HTTP Version not supported</td><td>服务器不支持请求的 HTTP 协议的版本，无法完成处理</td></tr></tbody></table>

# 代码实现

```
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <unistd.h>
#include <netdb.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <pthread.h>
#include <sys/time.h>
 
struct resp_header//保持相应头信息
{
    int status_code;//HTTP/1.1 '200' OK
    char content_type[128];//Content-Type: application/gzip
    long content_length;//Content-Length: 11683079
    char file_name[256];
};
 
struct resp_header resp;//全剧变量以便在多个进程中使用
 
void parse_url(const char *url, char *domain, int *port, char *file_name)
{
    /*通过url解析出域名, 端口, 以及文件名*/
    int j = 0,i=0;
    int start = 0;
    *port = 80;
    char *patterns[] = {"http://", "https://", NULL};
 
    for ( i = 0; patterns[i]; i++)
        if (strncmp(url, patterns[i], strlen(patterns[i])) == 0)
            start = strlen(patterns[i]);
 
    //解析域名, 这里处理时域名后面的端口号会保留
    for ( i = start; url[i] != '/' && url[i] != '\0'; i++, j++)
        domain[j] = url[i];
    domain[j] = '\0';
 
    //解析端口号, 如果没有, 那么设置端口为80
    char *pos = strstr(domain, ":");
    if (pos)
        sscanf(pos, ":%d", port);
 
    //删除域名端口号
 
    for (i = 0; i < (int)strlen(domain); i++)
    {
        if (domain[i] == ':')
        {
            domain[i] = '\0';
            break;
        }
    }
 
    //获取下载文件名
    j = 0;
    for (i = start; url[i] != '\0'; i++)
    {
        if (url[i] == '/')
        {
            if (i !=  strlen(url) - 1)
                j = 0;
            continue;
        }
        else
            file_name[j++] = url[i];
    }
    file_name[j] = '\0';
}
 
struct resp_header get_resp_header(const char *response)
{
    /*获取响应头的信息*/
    struct resp_header resp;
 
    char *pos = strstr(response, "HTTP/");
    if (pos)
        sscanf(pos, "%*s %d", &resp.status_code);//返回状态码
 
    pos = strstr(response, "Content-Type:");//返回内容类型
    if (pos)
        sscanf(pos, "%*s %s", resp.content_type);
 
    pos = strstr(response, "Content-Length:");//内容的长度(字节)
    if (pos)
        sscanf(pos, "%*s %ld", &resp.content_length);
 
    return resp;
}
 
void get_ip_addr(char *domain, char *ip_addr)
{
     int i=0;
    /*通过域名得到相应的ip地址*/
    struct hostent *host = gethostbyname(domain);
    if (!host)
    {
        ip_addr = NULL;
        return;
    }
 
    for (i = 0; host->h_addr_list[i]; i++)
    {
        strcpy(ip_addr, inet_ntoa( * (struct in_addr*) host->h_addr_list[i]));
        break;
    }
}
 
 
void progressBar(long cur_size, long total_size)
{
    /*用于显示下载进度条*/
    float percent = (float) cur_size / total_size;
    const int numTotal = 50;
    int numShow = (int)(numTotal * percent);
 
    if (numShow == 0)
        numShow = 1;
 
    if (numShow > numTotal)
        numShow = numTotal;
 
    char sign[51] = {0};
    memset(sign, '=', numTotal);
 
 
    printf("\r%.2f%%\t[%-*.*s] %.2f/%.2fMB", percent * 100, numTotal, numShow, sign, cur_size / 1024.0 / 1024.0, total_size / 1024.0 / 1024.0);
    fflush(stdout);
 
    if (numShow == numTotal)
        printf("\n");
}
 
void * download(void * socket_d)
{
    /*下载文件函数, 放在线程中执行*/
    int client_socket = *(int *) socket_d;
    int length = 0;
    int mem_size = 4096;//mem_size might be enlarge, so reset it
    int buf_len = mem_size;//read 4k each time
    int len;
 
    //创建文件描述符
    int fd = open(resp.file_name, O_CREAT | O_WRONLY, S_IRWXG | S_IRWXO | S_IRWXU);
    if (fd < 0)
    {
        printf("Create file failed\n");
        exit(0);
    }
 
    char *buf = (char *) malloc(mem_size * sizeof(char));
 
    //从套接字中读取文件流
    while ((len = read(client_socket, buf, buf_len)) != 0 && length < resp.content_length)
    {
        write(fd, buf, len);
        length += len;
        progressBar(length, resp.content_length);
    }
 
    if (length == resp.content_length)
        printf("Download successful ^_^\n\n");
}
 
int main(int argc, char const *argv[])
{
    char url[2048] = "127.0.0.1";
    char domain[64] = {0};
    char ip_addr[16] = {0};
    int port = 80;
    char file_name[256] = {0};
 
    if (argc == 1)
    {
        printf("Input a valid URL please\n");
        exit(0);
    }
    else
        strcpy(url, argv[1]);
 
    parse_url(url, domain, &port, file_name);
 
    if (argc == 3)
        strcpy(file_name, argv[2]);
 
    get_ip_addr(domain, ip_addr);
    if (strlen(ip_addr) == 0)
    {
        printf("can not get ip address\n");
        return 0;
    }
 
    puts("\n>>>>Detail<<<<");
    //设置http请求头信息
    char header[2048] = {0};
    sprintf(header, \
            "GET %s HTTP/1.1\r\n"\
            "Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\n"\
            "User-Agent:Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537(KHTML, like Gecko) Chrome/47.0.2526Safari/537.36\r\n"\
            "Host:%s\r\n"\
            "Connection:close\r\n"\
            "\r\n"\
        ,url, domain);
  printf("\n>>>>GET header:<<<<\n%s", header);
 
    //创建套接字
    int client_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (client_socket < 0)
    {
        printf("invalid socket descriptor: %d\n", client_socket);
        exit(-1);
    }
 
    //创建地址结构体
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr(ip_addr);
    addr.sin_port = htons(port);
 
    //连接服务器
    int res = connect(client_socket, (struct sockaddr *) &addr, sizeof(addr));
    if (res == -1)
    {
        printf("connect failed, return: %d\n", res);
        exit(-1);
    }
 
    write(client_socket, header, strlen(header));
    int mem_size = 4096;
    int length = 0;
    int len;
    char *buf = (char *) malloc(mem_size * sizeof(char));
    char *response = (char *) malloc(mem_size * sizeof(char));
 
    //每次单个字符读取响应头信息, 仅仅读取的是响应部分的头部, 后面单独开线程下载
    while ((len = read(client_socket, buf, 1)) != 0)
    {
        if (length + len > mem_size)
        {
            //动态内存申请, 因为无法确定响应头内容长度
            mem_size *= 2;
            char * temp = (char *) realloc(response, sizeof(char) * mem_size);
            if (temp == NULL)
            {
                printf("realloc failed\n");
                exit(-1);
            }
            response = temp;
        }
 
        buf[len] = '\0';
        strcat(response, buf);
 
        //找到响应头的头部信息, 两个"\n\r"为分割点
        int flag = 0;
	int i=0;
        for (i = strlen(response) - 1; response[i] == '\n' || response[i] == '\r'; i--, flag++);
        if (flag == 4)
            break;
 
        length += len;
    }
 
    printf("\n>>>>Response header:<<<<\n%s", response);
    resp = get_resp_header(response);
    strcpy(resp.file_name, file_name);
 
    /*开新的线程下载文件*/
    pthread_t download_thread;
    pthread_create(&download_thread, NULL, download, (void *) &client_socket);
    pthread_join(download_thread, NULL);
    return 0;
}
```

# 运行效果

```
./http  http://downloads.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-debugsymbols-3.6.20.tgz

```

![](<assets/1688102095280.png>)