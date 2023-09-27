---
url: https://blog.csdn.net/u011467621/article/details/79108980
title: gitignore 例子 只包含特定文件_gitignore 包含_刚搬完砖的博客 - CSDN 博客
date: 2023-08-13 10:17:21
tag: 
banner: "https://images.unsplash.com/photo-1689656966481-043a970b7c76?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxODkyNDk1fA&ixlib=rb-4.0.3&q=85&fit=crop&w=682&max-h=540"
banner_icon: 🔖
---
git 工程只上传必须的文件，所以需要在一个文件（跟目录. gitignore) 下面记录需要忽略的文件或文件夹。下面举例. gitignore, 该模版适合去除一些指定目录，并且仅仅包含其他目录下的特定结尾的文件:

*  
!/**/  
## 去除哪些路径  
/dirignore1/  
/dirignore2/  
## 只包含哪些结尾的文件  
!*.c  
!*.h  
!*.cpp  
!*.sh  
!*.xml  
!*.py  
!*.md  
!*.jar  
!.scala  
!.java  

1 * 代表忽略全部

2 /** 代表文件夹下的全部内容 （ A trailing "/**" matches everything inside. For example, "abc/**" matches all files inside directory "abc"）

为什么要写这句，因为不可能包含一个文件，如果他的文件夹都被忽略了 [It is not possible to re-include a file if a parent directory of that file is excluded.](https://stackoverflow.com/a/20652768/6309) (`*`)  

3 包含每个文件后，/dirignore1/, 在去除不需要的文件夹。（可以注意到. gitignore 是按照顺序读入规则的，顺序重要)

4 ! 在每行前加感叹号，表示需要包括后面的匹配文件或文件夹

5 /**, 连续两个 * 表示包含文件夹下的所有内容 (A trailing "/**" matches everything inside. For example, "abc/**" matches all files inside directory "abc")

6 (只有在没有 “/” 符号的前提下 , 才会作 wildcard 匹配， 所以模版中不能加 "/" 这种路径操作) If the pattern does not contain a slash /, Git treats it as a shell glob pattern and checks for a match against the pathname relative to the location of the .gitignore file

注意: 我查了半天，没查到如何只包含某个文件夹下的特定文件的功能

参考:

https://stackoverflow.com/questions/19023550/how-do-i-add-files-without-dots-in-them-all-extension-less-files-to-the-gitign

https://git-scm.com/docs/gitignore