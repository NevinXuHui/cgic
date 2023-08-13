---
url: https://blog.csdn.net/horses/article/details/108536784
title: Pandoc：一个超级强大的文档格式转换工具_pandoc 是什么软件_不剪发的 Tony 老师的博客 - CSDN 博客
date: 2023-08-08 09:29:13
tag: 
banner: "https://images.unsplash.com/photo-1689126494042-39f69fa4c8c5?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxNDU4MDUyfA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
banner_icon: 🔖
---
### 文章目录

*   *   [Pandoc 简介](#Pandoc__6)
    *   [下载安装](#_73)
    *   *   [Windows](#Windows_75)
        *   [macOS](#macOS_82)
        *   [Linux](#Linux_89)
    *   [初步使用](#_94)
    *   [Pandoc 集成](#Pandoc__194)
    *   [相关资源](#_199)
    *   [总结](#_206)

大家好，我是只谈技术不剪发的 Tony 老师。最近发现了一款免费的文档格式转换工具：Pandoc，堪称该领域的神器，介绍给大家。

## Pandoc 简介

[Pandoc](https://pandoc.org/) 是一个由 John MacFarlane 开发的通用文档转换工具，可以支持大量标记语言之间的格式转换，例如 Markdown 、Microsoft Word、PowerPoint、 [Jupyter](https://so.csdn.net/so/search?q=Jupyter&spm=1001.2101.3001.7020) Notebook、HTML、PDF、LaTeX、Wiki、EPUB 格式之间的相互转换。官方称之为该领域中的 “瑞士军刀”，并且给出了一个格式转换的示意图。

![](https://img-blog.csdnimg.cn/20200911092202741.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvcnNlcw==,size_16,color_FFFFFF,t_70#pic_center)

  
可以看出，Pandoc 支持非常多的格式；关键它还是一个开源免费的工具，源代码放在了 [GitHub](https://github.com/jgm/pandoc) 上，使用 Haskell 编程语言实现。具体来说，Pandoc 支持以下格式之间的转换（← 表示可以从该格式转换为其他格式； → 表示可以转换为该格式；↔︎ 表示支持该格式的双向转换）：

*   **轻量级标记格式**
    *   ↔︎ Markdown（包括 CommonMark 和 GitHub-flavored Markdown）
    *   ↔︎ reStructuredText
    *   → AsciiDoc
    *   ↔︎ Emacs Org-Mode
    *   ↔︎ Emacs Muse
    *   ↔︎ Textile
    *   ← txt2tags
*   **HTML 格式**
    *   ↔︎ (X)HTML 4
    *   ↔︎ HTML5
*   **Ebooks**
    *   ↔︎ EPUB 版本 2 或者版本 3
    *   ↔︎ FictionBook2
*   **文档格式**
    *   → GNU TexInfo
    *   ↔︎ Haddock markup
*   **Roff 格式**
    *   ↔︎ roff man
    *   → roff ms
*   **TeX 格式**
    *   ↔︎ LaTeX
    *   → ConTeXt
*   **XML 格式**
    *   ↔︎ DocBook 版本 4 或者版本 5
    *   ↔︎ JATS
    *   → TEI Simple
*   **大纲格式**
    *   ↔︎ OPML
*   **数据格式**
    *   ← CSV 表格
*   **文字处理格式**
    *   ↔︎ Microsoft Word docx
    *   ↔︎ OpenOffice/LibreOffice ODT
    *   → OpenDocument XML
    *   → Microsoft PowerPoint
*   **交互式笔记格式**
    *   ↔︎ Jupyter notebook (ipynb)
*   **页面布局格式**
    *   → InDesign ICML
*   **Wiki 标记语言格式**
    *   ↔︎ MediaWiki 标记语
    *   ↔︎ DokuWiki 标记语
    *   ← TikiWiki 标记语
    *   ← TWiki 标记语
    *   ← Vimwiki 标记语
    *   → XWiki 标记语
    *   → ZimWiki 标记语
    *   ↔︎ Jira wiki 标记语
*   **幻灯片放映格式**
    *   → LaTeX Beamer
    *   → Slidy
    *   → reveal.js
    *   → Slideous
    *   → S5
    *   → DZSlides
*   **自定义格式**
    *   → 支持使用 lua 编写自定义转换器
*   **PDF**
    *   → 通过 pdflatex、lualatex、xelatex、latexmk、tectonic、wkhtmltopdf、weasyprint、prince、context、pdfroff 插件或者工具转为为 PDF

## 下载安装

Pandoc 提供了一个 Haskell 代码库和命令行程序，支持 Windows、macOS、Linux、Chrome OS、BSD、Docker、GitHub Actions 以及源码编译等方式。最简单的安装方式就是[点击下载](https://github.com/jgm/pandoc/releases/latest)编译好的安装文件。

### Windows

Pandoc 为 Windows 系统提供了编译后的 msi 安装包，可以直接运行安装；或者直接下载免安装的 zip 文件解压即可。还有一种安装方法就是使用 Chocolatey 进行安装：

```
choco install pandoc

```

### macOS

Pandoc 为 macOS 系统提供了编译后的 pkg 安装包，可以直接运行安装；或者直接下载免安装的 zip 文件解压即可。还有一种安装方法就是使用 Homebrew 进行安装：

```
brew install pandoc

```

### Linux

对于 Debian、Ubuntu、Slackware、Arch、Fedora、NiXOS、openSUSE、gentoo 等主流 Linux 发行版，Pandoc 可以直接使用系统包管理器进行安装。同时 Pandoc 为 amd64 架构提供了二进制安装包。

其他操作系统和安装方式可以参考[官方文档](https://pandoc.org/installing.html)。

## 初步使用

下面我们介绍一下 Pandoc 命令行工具的简单使用。首先进入安装目录，运行 pandoc 或者 pandoc.exe：

```
d:\Software\pandoc-2.10.1>pandoc.exe --version
pandoc.exe 2.10.1
Compiled with pandoc-types 1.21, texmath 0.12.0.2, skylighting 0.8.5
Default user data directory: C:\Users\dongx\AppData\Roaming\pandoc
Copyright (C) 2006-2020 John MacFarlane
Web:  https://pandoc.org
This is free software; see the source for copying conditions.
There is no warranty, not even for merchantability or fitness
for a particular purpose.

```

以上命令返回了 Pandoc 的版本信息。

接下来我们测试一下文件格式转换，在当前目录中创建一个文本文件 test.md，输入以下内容：

```
---
title: Test
...

# Test!

This is a test of *pandoc*.

- list one
- list two

```

然后在命令行输入以下命令：

```
pandoc.exe test.md -f markdown -t html -s -o test.html

```

文件名 test.md 是要转换的源文件；-f 设置输入文件的格式；-t 设置输出文件的格式；-s 表示创建一个 “独立” 文件，将会生成文件  
页眉和页脚。默认的转换格式为 markdown 到 HTML，所以上面的命令也可以省略这两个选项。

执行之后在当前目录中生成了一个 test.html，内容如下：

```
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="" xml:lang="">
<head>
  <meta charset="utf-8" />
  <meta name="generator" content="pandoc" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes" />
  <title>Test</title>
  <style>
    code{white-space: pre-wrap;}
    span.smallcaps{font-variant: small-caps;}
    span.underline{text-decoration: underline;}
    div.column{display: inline-block; vertical-align: top; width: 50%;}
    div.hanging-indent{margin-left: 1.5em; text-indent: -1.5em;}
    ul.task-list{list-style: none;}
    .display.math{display: block; text-align: center; margin: 0.5rem auto;}
  </style>
  <!--[if lt IE 9]>
    <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv-printshiv.min.js"></script>
  <![endif]-->
</head>
<body>
<header id="title-block-header">
<h1 class="title">Test</h1>
</header>
<h1 id="test">Test!</h1>
<p>This is a test of <em>pandoc</em>.</p>
<ul>
<li>list one</li>
<li>list two</li>
</ul>
</body>
</html>

```

如果想要将该文件转换为 [LaTeX](https://so.csdn.net/so/search?q=LaTeX&spm=1001.2101.3001.7020) 格式，可以输入以下命令：

```
pandoc.exe test.md -f markdown -t latex -s -o test.tex

```

Pandoc 可以根据文件名扩展猜测出输入和输出文件的格式，例如以下命令可以将文件转换为 Word 文档格式：

```
pandoc.exe test.md -s -o test.docx

```

如果已经安装了 LaTeX，可以使用以下命令转换为 PDF 文件：

```
pandoc.exe test.md -f markdown -s -o test.pdf

```

输入 pandoc --help 命令可以查看工具的选项帮助，详细的使用介绍可以查看[用户手册](https://pandoc.org/MANUAL.html)。

另外，Pandoc 还提供了一个[在线格式转换工具](https://pandoc.org/try/)以及各种[格式转换示例](https://pandoc.org/demos.html)。

## Pandoc 集成

除了使用命令行方式之外，很多开发工具和软件都集成了 Pandoc，从而实现文件格式的转换。例如 Markdown 编辑器 PanWriter、Typora，文本编辑器 Atom、Sublime Text、Emacs、Vim，R Markdown，PanConvert、Manubot 等等。

更多集成了 Pandoc 的第三方软件列表可以[点此查看](https://github.com/jgm/pandoc/wiki/Pandoc-Extras)。

## 相关资源

*   Pandoc [官方网站](https://pandoc.org/)；
*   Pandoc [GitHub 源码](https://github.com/jgm/pandoc)；
*   Pandoc [WIKI](https://github.com/jgm/pandoc/wiki)；
*   Pandoc [用户手册](https://pandoc.org/MANUAL.html)；

## 总结

Pandoc 是一个免费开源的格式转换工具，可以用于各种标记格式文档之间的转换。Pandoc 被广泛用于书写工作和电子书籍出版流程。

如果觉得文章对你有用，欢迎关注❤️、评论📝、点赞👍！