---
url: https://blog.csdn.net/u011598193/article/details/126992964
title: gitignore 匹配规则_gitignore ! 取反_JAYL_的博客 - CSDN 博客
date: 2023-08-13 19:01:03
tag: 
banner: "https://images.unsplash.com/photo-1689718107045-513b35f1a356?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxOTI0NDU5fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
### 文章目录

*   *   [匹配模式](#_4)
    *   [glob 模式](#glob_12)
    *   [Examples](#Examples_20)

## 匹配模式

*   空行或以`#`开头的行会被忽略；
*   支持标准的 glob 模式；
*   以`/`开头的模式可以用于禁止递归匹配
*   以`/`结尾的模式表示目录；
*   以`!`开始的模式表示取反；

## [glob](https://so.csdn.net/so/search?q=glob&spm=1001.2101.3001.7020) 模式

类似于 shell 使用的简化版正则表达式：

*   `*`匹配 0 个或多个字符；
*   `[abc]`匹配方括号内的任意字符；
*   `?`匹配任意单个字符；
*   `**`匹配嵌套目录

## Examples

<table><thead><tr><th align="left">模式</th><th align="left">description</th></tr></thead><tbody><tr><td align="left">*.[oa]</td><td align="left">忽略以. o 或以. a 结尾的文件</td></tr><tr><td align="left">!lib.a</td><td align="left">任然跟踪 lib.a 文件， 即使上一行指令要忽略. a 类型的文件 <code onclick="mdcp.copyCode(event)">取反</code></td></tr><tr><td align="left">/TODO</td><td align="left">只忽略当前目录下的 TODO 文件，而不忽略子目录下的 TODO 文件 <code onclick="mdcp.copyCode(event)">禁止递归</code></td></tr><tr><td align="left">build/</td><td align="left">忽略 build / 目录下的所有文件 <code onclick="mdcp.copyCode(event)">目录</code></td></tr><tr><td align="left">doc/*.txt</td><td align="left">忽略 doc/notes.txt，而不忽略 doc/server/notes.txt</td></tr><tr><td align="left">doc/**/*.pdf</td><td align="left">忽略 doc / 目录下所有的. pdf 文件 <code onclick="mdcp.copyCode(event)">嵌套目录</code></td></tr></tbody></table>