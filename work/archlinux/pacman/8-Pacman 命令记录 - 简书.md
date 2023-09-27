---
url: https://www.jianshu.com/p/4bc71af50730/
title: Pacman 命令记录 - 简书
date: 2023-04-20 23:20:05
tag: 
banner: "undefined"
banner_icon: 🔖
---
记性比较差，找了一下 pacman 的命令参数，放在这儿方便查看

pacman -Sy abc #和源同步后安装名为 abc 的包

pacman -S abc #从本地数据库中得到 abc 的信息，下载安装 abc 包

pacman -Sf abc #强制安装包 abc

pacman -Ss abc #搜索有关 abc 信息的包

pacman -Si abc #从数据库中搜索包 abc 的信息

pacman -Q # 列出已经安装的软件包

pacman -Q abc # 检查 abc 软件包是否已经安装

pacman -Qi abc #列出已安装的包 abc 的详细信息

pacman -Ql abc # 列出 abc 软件包的所有文件

pacman -Qo /path/to/abc # 列出 abc 文件所属的软件包

pacman -Syu #同步源，并更新系统

pacman -Sy #仅同步源

pacman -Su #更新系统

pacman -R abc #删除 abc 包

pacman -Rd abc #强制删除被依赖的包

pacman -Rc abc #删除 abc 包和依赖 abc 的包

pacman -Rsc abc #删除 abc 包和 abc 依赖的包

pacman -Sc #清理 / var/cache/pacman/pkg 目录下的旧包

pacman -Scc #清除所有下载的包和数据库

pacman -U abc #安装下载的 abs 包，或新编译的 abc 包

pacman -Sd abc #忽略依赖性问题，安装包 abc

pacman -Su --ignore foo #升级时不升级包 foo

pacman -Sg abc #查询 abc 这个包组包含的软件包

清除无用的包

sudo pacman -R $(pacman -Qdtq)

转自[这儿](https://www.jianshu.com/p/dfa3b4a090a6)