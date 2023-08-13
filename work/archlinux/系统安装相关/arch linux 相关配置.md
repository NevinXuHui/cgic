<!--
 * @Author: xuhui xuhui@cmhi.chinamobile.com
 * @Date: 2023-04-11 10:40:14
 * @LastEditors: xuhui xuhui@cmhi.chinamobile.com
 * @LastEditTime: 2023-05-04 12:20:42
 * @FilePath: /obsidian/pages/arch linux 相关配置.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
#### 第一步：开启32位支持库和添加国内镜像源并更新系统
sudo vim /etc/pacman.conf                                               ## 编辑pacman配置文件

Server = https://mirrors.bfsu.edu.cn/archlinuxcn/$arch                  ## 添加国内镜像源
Include = /etc/pacman.d/mirrorlist                                      ## 开启32位支持库

sudo pacman -Syyu    

####  第三步：安装yay
sudo pacman -S yay                                                     ## 安装yay（社区用户软件仓库）

sudo pacman -S archlinuxcn-keyring                                     ## 安装社区密钥软件包

yay --aururl "https://aur.tuna.tsinghua.edu.cn"  --save                ## 通过命令行添加清华镜像社区源
yay --aururl "https://aur.archlinux.org/" --save

sudo vim /etc/pacman.conf
 在最后添加
[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch


yay -P -g  

#### 第四步：字体优化
git clone https://gitee.com/hbk01/Windows-Fonts.git                     ## 使用git下载微软雅黑字体

cd Windows-Fonts && sudo cp -r ./* /usr/share/fonts                     ## 进入文件夹并全部复制到fonts字体文件夹内    

sudo mkfontscale && mkfontdir && fc-cache -fv                           ## 刷新字体缓存

在设置里面找到 `字体 -> 调整所有字体 -> 微软雅黑 

#### 第六步：配置系统默认命令行编辑器（vim）

```text
vim /etc/profile                                              ## 编辑并配置文件

export EDITOR='vim'  
```

####  图形化引导程序（Grub Customizer）

```text
sudo pacman -S grub-customizer    
```

#### 安装paru
安装paru以后我们就可以在AUR里面下载软件了，意味着我们能够下载更多的软件了。添加完archlinuxcn源以后运行：

sudo pacman -S paru


