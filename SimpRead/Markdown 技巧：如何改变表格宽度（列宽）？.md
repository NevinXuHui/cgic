---
url: https://zhuanlan.zhihu.com/p/93239297
title: Markdown 技巧：如何改变表格宽度（列宽）？
date: 2023-08-25 23:11:29
tag: 
banner: "https://pic1.zhimg.com/v2-10a6e95c573eb948ba071b20f7cf4c5c_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
本文是个人学习笔记，文中技巧均来自 StackOverflow 相关问题中的回答

## 前言（废话区）

现在很多 Markdown 编辑器带的解析器都支持一些快捷插入表格的语法。比如 Typora，MWeb 等支持用如下语法插入表格：

```
第一格表头 | 第二格表头
--------- | -------------
内容单元格 第一列第一格 | 内容单元格第二列第一格
内容单元格 第一列第二格 多加文字 | 内容单元格第二列第二格

```

但是当表格内容稍微复杂的时候，这个基本语法可能就满足不了需求 (不过这也不能怪 Markdown，毕竟初衷就是要简单)。典型的，比如列宽，默认都是按照单元格内容自适应，或者整表列宽与行宽相同。内容一多，排版就比较混乱。下面就分享几个我刚学的，利用简单 html 语法调列宽的方法。

## Case 1: 预留宽度，用于打印后填写

一个比较简单粗暴的方法自然是加一段空格符 `&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;`

一个更加优雅的方法则是使用空的 `<img>` 标签。例如

```
| a | b | c |
|---|---|---|
| 1 |  <img width=200/> | 3 | 

```

![](https://pic3.zhimg.com/v2-3658b6b1fdd8f25ffa3f543f85900566_r.jpg)

## Case 2: 长文本需要指定列宽，控制换行

第一种方法可以使用 `<div style="width:[长度]">[单元格文本]</div>` 的形式，长度单位可以是 `pt` , `px`, `cm`等。比如：

```
**默认**

| a | b | d |
|---|---|---|
| 1 | very very very very very long long long long long text | 3 |

**使用后效果**

| a | b | d |
|---|---|---|
| 1 | <div>very very very very very lonng long long long long text</div>| 3 |

```

![](https://pic3.zhimg.com/v2-92e8b7d924837e5bed054cc9ca6ad80e_r.jpg)

第二种方法可以从外部定义一个 「Style」来指定各列的列宽

```
<style>
table th:first-of-type {
    width: 4cm;
}
table th:nth-of-type(2) {
    width: 150pt;
}
table th:nth-of-type(3) {
    width: 8em;
}
</style>

| a | b | c |
|---|---|---|
| 列宽 = 3 cm| 列宽 = 5 cm| 列宽 = 8em |

```

![](https://pic3.zhimg.com/v2-2f9eaecc0a32313a7935b8fb7e0f60fa_r.jpg)

当然你可以把单位改成 `%` 这样就相当于按照所占行宽的比例来分配列宽

```
<style>
table th:first-of-type {
    width: 20%;
}
table th:nth-of-type(2) {
    width: 30%;
}
table th:nth-of-type(3) {
    width: 50%;
}
</style>

| a | b | c |
|---|---|---|
| 列宽 = 10% 行宽| 列宽 = 30% 行宽 |列宽 = 60% 行宽 |

```

![](https://pic2.zhimg.com/v2-fd0f40f74a7565b0f6cf1183b67688fd_r.jpg)

需要指出的是，这种方法是全局起效的。如果你在一篇文章中，需要不同样式的表格，那么就需要额外的利用 css 语言定义不同种的表格类，这里不展开了。不是很推荐这样做，因为这样就失去 Markdwon 的核心价值了。

**一个问题：如果各列百分比加起来不是 100% 结果怎么样？自己去测试吧 ️**