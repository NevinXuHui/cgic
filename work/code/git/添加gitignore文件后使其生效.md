#git 

#### 遇到的问题

我们发现在添加`.gitignore`文件后，当我们想push文件的时候，我们声明的忽略文件还是会出现在push的目录中

#### 原因分析

某些文件已经被纳入版本管理中，就算是在`.gitignore`中已经声明也不会起作用

#### 解决方案

我们应该先把本地的缓存删除，然后再进行push，操作步骤如下

```git
git rm -r --cached . // 删除本地缓存
git add . // 添加要提交的文件
git commit -m 'update .gitignore' // 更新本地的缓存
```

来自 <[https://www.cnblogs.com/AliliWl/p/7880243.html](https://www.cnblogs.com/AliliWl/p/7880243.html)>
