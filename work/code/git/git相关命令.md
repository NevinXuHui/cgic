

```JavaScript
git config --global --add safe.directory /opt/lede_K3/lede
```

# 回退到特定版本

**git log：该命令显示从最近到最远的提交日志。**

commit e620a6ff0940a8dff91e0d252f30e4d138ec37be Author: TangShengqin [15527733782@163.com](mailto:15527733782@163.com) Date:   Wed Jan 3 10:35:44 2018 +0800     练习版本回退，假设这是版本3 commit 33342d9870f104719d351539a15e74a1382407ea Author: TangShengqin [15527733782@163.com](mailto:15527733782@163.com) Date:   Wed Jan 3 10:34:03 2018 +0800     练习版本回退，假设这是版本2

来自 <[https://blog.csdn.net/weixin_35770067/article/details/121537509](https://blog.csdn.net/weixin_35770067/article/details/121537509)>

088928c343ee1d0dc6b1e7f1198b761251cb3c3e

d035ab452682ac6b817eaed55c3e8a2a5401d51d

一、在本地退回到到相应版本

git reset --hard <版本号> // 注意使用 --hard 参数会抛弃当前工作区的修改 // 使用 --soft 参数的话会回退到之前的版本，但是保留当前工作区的修改，可以重新提交

来自 <[https://www.cnblogs.com/Mr-Rshare/p/15904622.html](https://www.cnblogs.com/Mr-Rshare/p/15904622.html)>

二、推到远程

```JavaScript
git push origin <分支名> --force
```

来自 <[https://www.cnblogs.com/Mr-Rshare/p/15904622.html](https://www.cnblogs.com/Mr-Rshare/p/15904622.html)>

**九、自定义git**

```JavaScript
$ git config --global color.ui true
```

//让git显示颜色

来自 <[https://blog.csdn.net/weixin_49851451/article/details/123944431](https://blog.csdn.net/weixin_49851451/article/details/123944431)>

7.git如何放弃本地文件修改？

1.未使用git add 缓存代码

1） 放弃某一个本地文件命令： git checkout -- filename

2） 放弃所有文件修改命令：  git checkout .

2. 已使用git add 缓存代码，未使用git commit

1）放弃某一个本地文件命令回到git add .之前 ：  git reset HEAD filename

2）放弃所有文件修改命令回到git add .之前：    git reset HEAD

3. 已经用 git commit 提交了代码

1）回退到上一次commit的状态： git reset --hard HEAD^

2）或者回退到任意版本git reset --hard commit id ，使用git log命令查看git提交历史和commit id  ：  git reset --hard commit id



git config --global user.name "username"

git config --global user.email "email"

*ssh-keygen -t rsa -C "[your_email@youremail.com](mailto:your_email@youremail.com)"  输入你的邮箱*

最后有个public key要注意，这个待会儿会用到。

$ git add .

$ git commit -m "提交信息"

$ git remote add origin '远程仓库url'

$ git push -u origin 对应远程分支名

git push -u origin  master

获取branch

git  branch

下一次就不用这么麻烦了，直接;

$ git add .

$ git commit -m "提交信息"

$ git push

来自 <[https://zhuanlan.zhihu.com/p/92598182](https://zhuanlan.zhihu.com/p/92598182)>

[git pull 重新拉取覆盖本地代码](https://www.cnblogs.com/fangniunanhai/p/14039124.html)

git fetch --all

git reset --hard

origin/master git pull

来自 <[https://www.cnblogs.com/fangniunanhai/p/14039124.html](https://www.cnblogs.com/fangniunanhai/p/14039124.html)>

配置

git config --global [user.name](http://user.name/) NevinXu

git config --global [user.email](http://user.email/) [xuhui@cmhi.chinamobile.com](mailto:xuhui@cmhi.chinamobile.com)

# [git中忽略文件权限的改变](https://www.cnblogs.com/pengdonglin137/articles/15067188.html)

文件权限变更git也会检测到并提交。

```Plain Text
git config --global --unset-all core.filemode
git config --unset-all core.filemode
git config core.filemode false
```

// 当前版本库


```JavaScript
git config core.filemode false 
```

// 所有版本库  // 所有版本库

```JavaScript
git config --global core.filemode false 
```

git config --global --unset-all core.filemode 

git config --unset-all core.filemode 

git config core.filemode false

来自 <[https://www.lmlphp.com/user/151062/article/item/3614215/](https://www.lmlphp.com/user/151062/article/item/3614215/)>

**[[Git]多平台协作 忽略WhiteSpace](https://blog.csdn.net/aa1358075776/article/details/81156648)**

2018-07-22 17:35:30

1. git config --global core.autocrlf true

2. git config --global core.safecrlf true

来自 <[https://www.csdn.net/tags/Ntjacg0sODY4NTEtYmxvZwO0O0OO0O0O.html](https://www.csdn.net/tags/Ntjacg0sODY4NTEtYmxvZwO0O0OO0O0O.html)>

配置

```JavaScript
git config —global [user.name](http://user.name) NevinXu
```

```JavaScript
git config —global [user.email](http://user.email) xuhui@cmhi.chinamobile.com
```

# **[git中忽略文件权限的改变](https://www.cnblogs.com/pengdonglin137/articles/15067188.html)**

文件权限变更git也会检测到并提交。

```JavaScript
git config core.filemode false 
```

// 当前版本库

```JavaScript
git config --global core.fileMode false 
```

// 所有版本库

```JavaScript
git commit --amend   覆盖上次的提交 
```

```JavaScript
git push -u origin master  上传变更
```

(?i:^\s*((OCT[\s\S].m*)|((Mod|Fix|Add)\s+[A-Za-z]+-\d+\s+[\s\S].m*)|(Merge[\s\S]*)))

