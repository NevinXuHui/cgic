---
url: https://www.jianshu.com/p/6ebf1a2d11a7
title: Git 的奇技淫巧 - 简书
date: 2023-06-11 16:48:29
tag: 
banner: "https://upload.jianshu.io/users/upload_avatars/9596322/e1e2bf13-7492-43c0-b9ac-1194a88f5a50"
banner_icon: 🔖
---
Git 是一个 “分布式版本管理工具”，简单的理解版本管理工具：大家在写东西的时候都用过 “回撤” 这个功能，但是回撤只能回撤几步，假如想要找回我三天之前的修改，光用 “回撤” 是找不回来的。而 “版本管理工具” 能记录每次的修改，只要提交到版本仓库，你就可以找到之前任何时刻的状态（文本状态）。

### 回到远程仓库的状态

```
//抛弃本地所有的修改，回到远程仓库的状态。
git fetch --all && git reset --hard origin/master
```

### 重设第一个 commit

也就是把所有的改动都重新放回工作区，并`清空所有`的 `commit`，这样就可以重新提交第一个 `commit`了

```
git update-ref -d HEAD
```

### 查看冲突文件列表

展示工作区的冲突文件列表

```
git diff --name-only --diff-filter=U

```

### 展示工作区和暂存区的不同

输出`工作区`和`暂存区`的 different (不同)。

```
git diff
```

还可以展示本地仓库中任意两个 commit 之间的文件变动：

```
git diff <commit-id> <commit-id>
```

### 展示暂存区和最近版本的不同

输出暂存区和本地最近的版本 (commit) 的 different (不同)。

```
git diff --cached
```

### 展示暂存区、工作区和最近版本的不同

输出工作区、暂存区 和本地最近的版本 (commit) 的 different (不同)。

```
git diff HEAD
```

### 快速切换到上一个分支

```
git checkout -
```

### 删除已经合并到 master 的分支

```
git branch --merged master | grep -v '^\*\|  master' | xargs -n 1 git branch -d
```

### 展示本地分支关联远程仓库的情况

```
git branch -vv
```

### 关联远程分支

关联之后，git branch -vv 就可以展示关联的远程分支名了，同时推送到远程仓库直接：git push，不需要指定远程仓库了。

```
git branch -u origin/mybranch
```

或者在 push 时加上 -u 参数

```
git push origin/mybranch -u
```

### 列出所有远程分支

-r 参数相当于：remote

```
git branch -r
```

### 列出本地和远程分支

-a 参数相当于：all

```
git branch -a
```

### 查看远程分支和本地分支的对应关系

```
git remote show origin
```

### 远程删除了分支本地也想删除

```
git remote prune origin
```

### 创建并切换到本地分支

```
git checkout -b <branch-name>
```

### 从远程分支中创建并切换到本地分支

```
git checkout -b <branch-name> origin/<branch-name>
```

### 删除本地分支

```
git branch -d <local-branchname>
```

### 删除远程分支

```
git push origin --delete <remote-branchname>
//或者
git push origin :<remote-branchname>
```

### 重命名本地分支

```
git branch -m <new-branch-name>
```

### 放弃工作区的修改

```
git checkout <file-name>
```

放弃所有修改：

```
git checkout .
```

### 恢复删除的文件

```
git rev-list -n 1 HEAD -- <file_path> #得到 deleting_commit

git checkout <deleting_commit>^ -- <file_path> #回到删除文件 deleting_commit 之前的状态
```

### 以新增一个 commit 的方式还原某一个 commit 的修改

```
git revert <commit-id>


```

### 回到某个 commit 的状态，并删除后面的 commit

和 revert 的区别：reset 命令会抹去某个 commit id 之后的所有 commit

```
git reset <commit-id>  #默认就是-mixed参数。

git reset --mixed HEAD^  #回退至上个版本，它将重置HEAD到另外一个commit,并且重置暂存区以便和HEAD相匹配，但是也到此为止。工作区不会被更改。

git reset --soft HEAD~3  #回退至三个版本之前，只回退了commit的信息，暂存区和工作区与回退之前保持一致。如果还要提交，直接commit即可  

git reset --hard <commit-id>  #彻底回退到指定commit-id的状态，暂存区和工作区也会变为指定commit-id版本的内容


```

### 修改上一个 commit 的描述

如果暂存区有改动，同时也会将暂存区的改动提交到上一个 commit

```
git commit --amend


```

### 查看 commit 历史

```
git log


```

### 查看某段代码是谁写的

blame 的意思为‘责怪’，你懂的。

```
git blame <file-name>


```

### 显示本地更新过 HEAD 的 git 命令记录

每次更新了 HEAD 的 git 命令比如 commit、amend、cherry-pick、reset、revert 等都会被记录下来（不限分支），就像 shell 的 history 一样。 这样你可以 reset 到任何一次更新了 HEAD 的操作之后，而不仅仅是回到当前分支下的某个 commit 之后的状态。

```
git reflog


```

### 修改作者名

```
git commit --amend --author='Author Name <email@address.com>'


```

### 修改远程仓库的 url

```
git remote set-url origin <URL>


```

### 增加远程仓库

```
git remote add origin <remote-url>


```

### 列出所有远程仓库

```
git remote


```

### 查看两个星期内的改动

```
git whatchanged --since='2 weeks ago'


```

### 把 A 分支的某一个 commit，放到 B 分支上

这个过程需要 `cherry-pick` 命令，[参考](https://links.jianshu.com/go?to=http%3A%2F%2Fsg552.iteye.com%2Fblog%2F1300713%23bc2367928)

```
git checkout <branch-name> && git cherry-pick <commit-id>


```

### clone 下来指定的单一分支

```
git clone -b <branch-name> --single-branch https://github.com/user/repo.git


```