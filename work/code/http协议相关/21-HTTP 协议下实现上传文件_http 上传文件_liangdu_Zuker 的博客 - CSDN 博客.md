---
banner: "http://img1.51cto.com/attachment/201301/183455866.png"
---
---
url: https://blog.csdn.net/u010833547/article/details/73912834
title: HTTP 协议下实现上传文件_http 上传文件_liangdu_Zuker 的博客 - CSDN 博客
date: 2023-04-04 14:43:17
tag: 
banner: "http://img1.51cto.com/attachment/201301/183455866.png"
banner_icon: 🔖
---
**本文出自 “[迷失的月亮](http://luecsc.blog.51cto.com/)” 博客，请务必保留此出处 [http://luecsc.blog.51cto.com/2219432/1113654](http://luecsc.blog.51cto.com/2219432/1113654)  
**

**一、HTTP 协议基础**

        1、HTTP 协议概念

         协议是指计算机通信网络中两台计算机之间进行通信所必须共同遵守的规定或规则，超文本传输协议 (HTTP) 是一种
         [通信协议](https://so.csdn.net/so/search?q=%E9%80%9A%E4%BF%A1%E5%8D%8F%E8%AE%AE&spm=1001.2101.3001.7020)，它允许将超文本标记语言 (HTML) 文档从 Web 服务器传送到客户端的浏览器。目前我们使用的是 HTTP/1.1 版本。 

        2、HTTP 消息
        HTTP 消息由从客户端到服务器的请求和服务端到客户端的响应组成，所以 HTTP 消息包括请求消息 (Request) 和响应消息(Response)。不管是请求消息还是响应消息，都由开始行（对于请求消息，开始行就是请求行，对于响应消息，开始行就是状态行），消息报头，空行（只有 CRLF 的行），消息正文组成。
        2.1、请求消息

![](1680590597280.png)

                                                  图 1、一次文件上传的请求消息

        如图 1 为上传一张图片文件的请求消息，第一行即为请求行，格式为：

 请求方法 + 空格 + 请求 URL + 空格 + HTTP 协议版本 + 回车换行。

        紧跟着为消息报头，请求消息报头中的各个字段使得客户可以向服务器传送有关请求的附加信息以及有关客户本身的信息。这些字段作为请求限定符，在语义上与程序设计语言中的方法调用参数相当。请求消息报头的字段分为近 20 种。每一个报头域都是由名字 +":"+ 值 组成，消息报头域的名字是大小写无关的, 域值前可以有任意个空格（但通常会在前面添加一个空格）, 可以允许多个相同的消息报头 。比如：

   Accept 请求报头域用于指定客户端接受哪些类型的信息 (例如：Accept：image/gif，表明客户端希望接受 GIF 图象格式的资源）。

   Accept-Language 请求报头域类似于 Accept，但是它是用于指定一种自然语言（例如：Accept-Language:zh-cn. 如果请求消息中没有设置这个报头域，服务器假定客户端对各种语言都可以接受）。

   User-Agent：主要包括客户端操作系统版本号、浏览器名称和版本和其他客户端信息。 

      最后是消息正文，消息正文包含了客户端向服务端发送的所有数据。

        2.2、重点关注

        在实现文件的上传或者下载时，在请求消息中，我们还要关注图 1 中蓝色标注的地方。

 Content-Type 表示客户端向服务端发送的消息正文的数据 (或者媒体) 的类型。

 boundary 即为分割线，用它来分割每个实体数据，分割线中的字符部分是随机生成的。在文件上传时，实体变得稍微复杂，就用 "--"+ 分割线来分割每个实体，这样可以更方便的读取每个实体的数据。

 Content-Length 则指明消息正文的长度。

        Range 为 GET 方法设定了一个条件，以获取资源中的一个或多个部分，而不是整个资源。  
 Range 字段是为了解决 HTTP 在传输文件的效率和速度这两个问题而设定的。  
            1)、任何一个资源，在作为消息的实体传输时都是一个 byte 序列。该序列可以分为若干部分（块）。例如：一个大小为 10KB 的文件，可以分为大小为 2KB 的 5 块：0-1999,2000-3999,4000-5999,6000-7999,8000-9999。  
            2)、客户在使用 GET 方法时，可以通过指定 Range 字段来实现获取指定资源中的一个或者多个部分。例如：“Range :bytes=4000-5999”表示获取文件中起始偏移为 4000bytes，大小为 2000bytes 的一块。而 “Range : bytes=8000-9999”、“Range : bytes=8000-” 以及 “Range : bytes=4000-5999” 均表示从文件中获取大小为 2000bytes 的最后一块。 

 说明：

 著名的网络下载工具 Netants，就是利用 Range 字段来实现 “断点续传” 和“多线程下载”的。  
            Range 字段是 HTTP/1.1 新引入的，HTTP/1.0 服务器不支持该字段；  
            若客户端过渡地使用 Range 字段来实现 "多线程下载"，会加重服务器的负担，因此有些服务器会对同一个客户能够同时打开的连接数目进行限制

        2.3、响应消息

![](1680590597427.png)

         一般情况下，服务器接收并处理客户端发过来的请求后会返回一个 HTTP 的响应消息。HTTP 的响应消息也是由三个部分组成，分别是：状态行、消息报头、响应正文。

        状态行格式如下：  
  HTTP-Version Status-Code Reason-Phrase (CRLF) 其中，HTTP-Version 表示服务器 HTTP 协议的版本, 例如 HTTP/1.1；Status-Code 表示服务器发回的响应状态代码, 例如 200；Reason-Phrase 表示状态代码的文本描述，例如 OK。一个典型的响应消息状态行：HTTP/1.1 200 OK

        响应消息很多地方与请求消息是相通，所以响应详细的消息报头、响应正文的内容这里就不再详细讲解。

        **二、文件上传实现代码**

        实现文件的上传，必须按照 Request 消息的结构来编写文件上传代码。首先编写一个实体类，用于描述要上传的文件，示例如下：

```
 
/**  
 * 上传文件  
 */ 
public class FormFile {  
    /* 上传文件的数据 */  
    private byte[] data;  
    private InputStream inStream;  
    private File file;  
    /* 文件名称 */  
    private String filname;  
    /* 请求参数名称*/  
    private String parameterName;  
    /* 内容类型 */ 
    private String contentType = "application/octet-stream";  
            
    public FormFile(String filname, byte[] data, String parameterName, String contentType) {  
        this.data = data;  
        this.filname = filname;  
        this.parameterName = parameterName;  
        if(contentType!=null) this.contentType = contentType;  
    }  
            
    public FormFile(File file, String parameterName, String contentType) {  
        this.filname = file.getName();  
        this.parameterName = parameterName;  
        this.file = file;  
        try {  
            this.inStream = new FileInputStream(file);  
        } catch (FileNotFoundException e) {  
            e.printStackTrace();  
        }  
        if(contentType!=null) this.contentType = contentType;  
    }  
    //getter and setter ...   
} 

```

        上传文件工具类代码 (上传方法)，示例如下：

```
 
/**  
     * 直接通过HTTP协议提交数据到服务器  
     * @param path 上传路径  
     * @param params 请求参数 key为参数名,value为参数值  
     * @param file 上传文件  
     */ 
    public static boolean post(String path, Map<String, String> params, FormFile[] files) throws Exception{       
        final String BOUNDARY = "---------------------------7da2137580612"; //数据分隔线  
        final String endline = "--" + BOUNDARY + "--\r\n";//数据结束标志  
              
        int fileDataLength = 0;  
        for(FormFile uploadFile : files){//得到文件类型数据的总长度  
            StringBuilder fileExplain = new StringBuilder();  
            fileExplain.append("--");  
            fileExplain.append(BOUNDARY);  
            fileExplain.append("\r\n");  
            fileExplain.append("Content-Disposition: form-data;name=\""+ uploadFile.getParameterName()+"\";filename=\""+ uploadFile.getFilname() + "\"\r\n");  
            fileExplain.append("Content-Type: "+ uploadFile.getContentType()+"\r\n\r\n");  
            fileDataLength += fileExplain.length();  
            if(uploadFile.getInStream()!=null){  
                fileDataLength += uploadFile.getFile().length();  
            }else{  
                fileDataLength += uploadFile.getData().length;  
            }  
            fileDataLength += "\r\n".length();  
        }  
        StringBuilder textEntity = new StringBuilder();  
        for (Map.Entry<String, String> entry : params.entrySet()) {//构造文本类型参数的实体数据  
            textEntity.append("--");  
            textEntity.append(BOUNDARY);  
            textEntity.append("\r\n");  
            textEntity.append("Content-Disposition: form-data; name=\""+ entry.getKey() + "\"\r\n\r\n");  
            textEntity.append(entry.getValue());  
            textEntity.append("\r\n");  
        }  
        //计算传输给服务器的实体数据总长度  
        int dataLength = textEntity.toString().getBytes().length + fileDataLength +  endline.getBytes().length;  
              
        URL url = new URL(path);  
        int port = url.getPort()==-1 ? 80 : url.getPort();  
        Socket socket = new Socket(InetAddress.getByName(url.getHost()), port);          
        OutputStream outStream = socket.getOutputStream();  
        //下面完成HTTP请求头的发送  
        String requestmethod = "POST "+ url.getPath()+" HTTP/1.1\r\n";  
        outStream.write(requestmethod.getBytes());  
        String accept = "Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*\r\n";  
        outStream.write(accept.getBytes());  
        String language = "Accept-Language: zh-CN\r\n";  
        outStream.write(language.getBytes());  
        String contenttype = "Content-Type: multipart/form-data; boundary="+ BOUNDARY+ "\r\n";  
        outStream.write(contenttype.getBytes());  
        String contentlength = "Content-Length: "+ dataLength + "\r\n";  
        outStream.write(contentlength.getBytes());  
        String alive = "Connection: Keep-Alive\r\n";  
        outStream.write(alive.getBytes());  
        String host = "Host: "+ url.getHost() +":"+ port +"\r\n";  
        outStream.write(host.getBytes());  
        //写完HTTP请求头后根据HTTP协议再写一个回车换行  
        outStream.write("\r\n".getBytes());  
        //把所有文本类型的实体数据发送出来  
        outStream.write(textEntity.toString().getBytes());           
        //把所有文件类型的实体数据发送出来  
        for(FormFile uploadFile : files){  
            StringBuilder fileEntity = new StringBuilder();  
            fileEntity.append("--");  
            fileEntity.append(BOUNDARY);  
            fileEntity.append("\r\n");  
            fileEntity.append("Content-Disposition: form-data;name=\""+ uploadFile.getParameterName()+"\";filename=\""+ uploadFile.getFilname() + "\"\r\n");  
            fileEntity.append("Content-Type: "+ uploadFile.getContentType()+"\r\n\r\n");  
            outStream.write(fileEntity.toString().getBytes());  
            if(uploadFile.getInStream()!=null){  
                byte[] buffer = new byte[1024];  
                int len = 0;  
                while((len = uploadFile.getInStream().read(buffer, 0, 1024))!=-1){  
                    outStream.write(buffer, 0, len);  
                }  
                uploadFile.getInStream().close();  
            }else{  
                outStream.write(uploadFile.getData(), 0, uploadFile.getData().length);  
            }  
            outStream.write("\r\n".getBytes());  
        }  
        //下面发送数据结束标志，表示数据已经结束  
        outStream.write(endline.getBytes());  
              
        BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));  
        if(reader.readLine().indexOf("200")==-1){//读取web服务器返回的数据，判断请求码是否为200，如果不是200，代表请求失败  
            return false;  
        }  
        outStream.flush();  
        outStream.close();  
        reader.close();  
        socket.close();  
        return true;  
    } 

```

        使用该工具，进行文件上传，示例代码：

```
 
public static boolean save(String title, String length, File uploadFile) {  
        String path = "http://192.168.0.168:8080/web/ManageServlet";  
        Map<String, String> params = new HashMap<String, String>();  
        params.put("title", title);  
        params.put("timelength", length);  
        FormFile formFile = new FormFile(uploadFile, "videofile", "image/gif");  
        try {  
            return SocketHttpRequester.post(path, params, formFile);  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
        return false;  
    } 

```