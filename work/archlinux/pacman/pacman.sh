# 软件安装分为：(installed|reinstalled|removed|downgraded|upgraded)
###
 # @Author: xuhui 18867103881@139.com
 # @Date: 2023-06-09 17:34:51
 # @LastEditors: xuhui 18867103881@139.com
 # @LastEditTime: 2023-06-09 17:38:08
 # @FilePath: /obsidian/other/脚本命令/pacman.sh
 # @Description: 
 # 
 # Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
### 
# 1、查看安装的 cat /var/log/pacman.log | grep -E 
# installed 

# 2、查看再安装 cat /var/log/pacman.log | grep -E 

# reinstalled
# 3、查看删除的 cat /var/log/pacman.log | grep -E 

# removed
# 4、查看下载的 cat /var/log/pacman.log | grep -E 

# downgraded

# 5、查看升级的 cat /var/log/pacman.log | grep -E 
# upgraded

# 最好使用管道处理下：cat /var/log/pacman.log  | grep -E installed >>  ~/installed.txt
# 查看文件：vim ~/installed.txt


# 5、查看升级的 cat /var/log/pacman.log | grep -E 
# upgraded

# 最好使用管道处理下：cat /var/log/pacman.log  | grep -E installed >>  ~/installed.txt
# 查看文件：vim ~/installed.txt

Manjaro包管理常用命令
对整个系统进行更新
sudo pacman -Syu   
升级软件包
sudo pacman -Syu
安装或者升级单个软件包，或者一列软件包（包含依赖包），使用如下命令：
sudo pacman -S package_name1 package_name2 ...
与上面命令不同的是，该命令将在同步包数据库后再执行安装
sudo pacman -Sy package_name
安装本地包
sudo pacman -U local_package_name#其扩展名为pkg.tar.gz或pkg.tar.xz
安装一个远程包
sudo pacman -U url#不在 pacman 配置的源里面，例：pacman -U http://www.example.com/repo/example.pkg.tar.xz
在仓库中搜索含关键字的包
sudo pacman -Ss keyword
查看已安装软件
sudo pacman -Qs keyword     
删除单个软件包，保留其全部已经安装的依赖关系
sudo pacman -R package_name
删除指定软件包，及其所有没有被其他已安装软件包使用的依赖关系：
sudo pacman -Rs package_name#要删除软件包和所有依赖这个软件包的程序，警告: 此操作是递归的，请小心检查，可能会一次删除大量的软件包。
清理软件包缓存
sudo pacman -Sc
清理所有的缓存文件
sudo pacman -Scc
清除系统中无用的包
sudo pacman -R $(pacman -Qdtq)
从 AUR 安装软件包#yay 安装命令不需要加 sudo
yay -S package 
yay删除包
yay -Rns package 
升级所有已安装的包
yay -Syu
打印系统统计信息
yay -Ps
检查安装的版本
yay -Qi package

