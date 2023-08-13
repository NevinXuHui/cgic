---
url: https://zhuanlan.zhihu.com/p/492337804
title: word 文档转 markdown 格式【pandoc 的使用方法】
date: 2023-08-08 12:52:20
tag: 
banner: "https://images.unsplash.com/photo-1689656966481-043a970b7c76?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxNDcwMzM4fA&ixlib=rb-4.0.3&q=85&fit=crop&w=1238&max-h=540"
banner_icon: 🔖
---
半糖学前端，职业前端人

word 文档转 md 格式有多种方法，这里推荐的是 pandoc，官网 [https://www.pandoc.org/](https://www.pandoc.org/) 。 下载下来不需要安装，我们主要使用的是 pandoc.exe 这个程序。

以下的语法格式为将一篇 word 文档转换为 markdown 格式，有图片的话生成的图片在.\images\media 这个文件夹目录下。

需要执行的命令就是

```
pandoc -f docx -t markdown --extract-media ./images -o aaa.md aaa.docx

```

aaa 就是文件的名字

需要注意的是转的文档需要和 pandoc.exe 在同一层级，否则路径错误执行是不会成功的

示例如下

![](https://pic2.zhimg.com/v2-bd80dd7a0d8dacacab9f094fbc9e5f05_r.jpg)

我是半糖学前端, 职业前端人