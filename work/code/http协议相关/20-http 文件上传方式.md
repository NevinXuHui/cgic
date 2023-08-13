---
url: https://zhuanlan.zhihu.com/p/373881533
title: http 文件上传方式
date: 2023-04-04 14:40:02
tag: 
banner: "https://pic1.zhimg.com/v2-4eb83efd43727e66080753564aa7bcbc_r.jpg"
banner_icon: 🔖
---
## 一、http 的四种请求参数

http 四种请求参数方式：即 form-data、x-www-form-urlencoded、raw、binary

1，form-data

　　http 请求中的 multipart/form-data, 它会将表单的数据处理为一条消息，以标签为单元，用分隔符分开。既可以上传键值对，也可以上传文件。当上传的字段是文件时，会有 Content-Type 来说明文件类型；content-disposition，用来说明字段的一些信息；由于有 boundary 隔离，所以 multipart/form-data 既可以上传文件，也可以上传键值对，它采用了键值对的方式，所以可以上传多个文件。

2，x-www-form-urlencoded

　　就是 application/x-www-from-urlencoded, 会将表单内的数据转换为键值对，比如, name=java&age = 23

3，raw

　　可以上传任意格式的文本，可以上传 text、json、xml、html 等

4，binary

　　相当于 Content-Type:application/octet-stream, 从字面意思得知，只可以上传二进制数据，通常用来上传文件，由于没有键值，所以，一次只能上传一个文件。如果想要同时传文件名，可以借用请求头 “Content-Disposition”，设置文件名。

## 二、http 三种上传方式

http 三种上传方式：根据上述四种参数请求方式，其中 urlencoded 只能传输文本，因此 http 只有三种文件上传方式，form-data、raw、binary

1，针对 form-data 上传，springMVC 后端接收写法

```
@RequestMapping(value="/upload", method = RequestMethod.POST)
public ResponseObject<?> upload(@RequestParam(value="file", required = true)MultipartFile file,HttpServletRequest request){
    String destination = "/filePath/"  + multipartFile.getOriginalFilename();
    File file = new File(destination);
    multipartFile.transferTo(file);
}

```

2，针对 raw 与 binary 方式上传，servlet 后端接收写法

```
@RequestMapping(value = "/upload", method = RequestMethod.POST)
public ResponseObject<?> upload(MultipartFile multipartFile, HttpServletRequest request) {
    try {
        InputStream in = request.getInputStream();
        String disposition = request.getHeader("Content-Disposition");
        String fileName = null;
        if (disposition != null && disposition.length() > 0) {
            fileName = disposition.replaceFirst("(?i)^.*filename=\"?([^\"]+)\"?.*$", "$1");
        }
        if (fileName == null || fileName.length() <= 0)
            fileName = new String("d:\\abcdef.xed");
        FileOutputStream fos = new FileOutputStream(fileName);
        byte[] b = new byte[1024];
        int length;
        while ((length = in.read(b)) > 0) {
            fos.write(b, 0, length);
        }
        in.close();
        fos.close();
    } catch (Exception e) {
        logger.error("file upload error", e);
    }
}

```

![](1680590402347.png)