---
url: https://blog.csdn.net/le_17_4_6/article/details/92789993
title: _gitignore 配置语法完全版_gitignore 语法_衡与墨的博客 - CSDN 博客
date: 2023-08-13 19:01:19
tag: 
banner: "https://images.unsplash.com/photo-1689350098247-5e02f4106cad?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxOTI0NDc1fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
# 前言

.gitignore 用来忽略 git 项目中一些文件，使得这些文件不被 git 识别和跟踪；

简单的说就是在. gitignore 添加了某个文件之后，这个文件就不会上传到 github 上被别人看见；

# .gitignore 文件的格式规范如下：

*   所有空行或者以 ＃ 开头的行都会被 Git 忽略。
*   可以使用标准的 glob 模式匹配。
*   匹配模式可以以（/）开头防止递归。
*   匹配模式可以以（/）结尾指定目录。
*   要忽略指定模式以外的文件或目录，可以在模式前加上惊叹号（!）取反。

#### 所谓的 glob 模式是指 shell 所使用的简化了的正则表达式。

*   星号（*）匹配零个或多个任意字符；
*   [abc] 匹配任何一个列在方括号中的字符（这个例子要么匹配一个 a，要么匹配一个 b，要么匹配一个 c）；
*   问号（?）只匹配一个任意字符；
*   如果在方括号中使用短划线分隔两个字符，表示所有在这两个字符范围内的都可以匹配（比如 [0-9] 表示匹配所有 0 到 9 的数字）。
*   使用两个星号（`**`) 表示匹配任意中间目录，比如`a/**/z`可以匹配 a/z, a/b/z 或 a/b/c/z 等。

# 常用规则：

```
/mtk/              
#过滤整个mtk文件夹
*.zip               
#过滤所有.zip文件
/mtk/do.c        
#过滤/mtk/do.c文件

fd1/*　　　   
#忽略目录 fd1 下的全部内容

/fd1/*　　　　
#忽略根目录下的 /fd1/ 目录的全部内容；

!/fw/bin/
!/fw/sf/             
#不忽略 根目录下的 /fw/bin/ 和 /fw/sf/ 目录；

```

# Git 在添加. gitignore 之前就 push 了项目

（为避免冲突可以先同步下远程仓库 $ git pull）

1.  在本地项目目录下删除暂存区内容： $ git rm -r --cached .
    
2.  新建. gitignore 文件，并添加过滤规则（用文本编辑器如 Notepad++）
    
3.  再次 add 文件，添加到暂存区
    
4.  再次 commit 提交文件
    
5.  $ git commit -m “add .gitignore”
    
6.  最后 push 即可
    

# Git push 完文件后想要修改过滤规则使其生效（跟上一个差不多）

```
 修改完.gitignore 在本地项目目录下

    $ git rm -r --cached .
    $ git add .
    $ git commit -m".gitignore update"

```

# 注意事项

*   命令和注释别在同一行，如`*.txt #注释txt`这样会导致这一行无法被识别
*   git add . 之前如果有改动. gitignore 一定要 执行 git rm -r --cached .
*   合理使用. gitignore 可以避免无用文件的上传，也可以防止重要配置信息的泄露