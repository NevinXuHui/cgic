---
url: https://zhuanlan.zhihu.com/p/112536524
title: 从零开始配置自己的 Arch Linux 桌面（极简）
date: 2023-04-11 13:25:50
tag: 
banner: "https://pic1.zhimg.com/v2-0b0904ae3d74e1976ca017c7c68eb3b3_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
## 写在前面

这篇文章主要介绍我们在安装好 Arch Linux 以后可以选择完成的一些操作，至于如何安装 Arch Linux，可以参考我在之前做好的攻略文章。

然后当前的这篇攻略文章只是教大家把软件装上而已，后续可能还可以通过一些设置实现更好的使用体验，铁子们可以看看当前专栏的导航文章，看看有没有更多的感兴趣的内容。

## 中文社区软件源（archlinuxcn）

`archlinuxcn`里头有许多中文用户常用的软件包，使用`vim`打开`/etc/pacman.conf`，在结尾上加上（需要管理员权限）：

```
[archlinuxcn]
Server =  https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch

```

刷新数据库`sudo pacman -Syy`后`sudo pacman -S archlinuxcn-keyring`导入 GPG key。

有时候这一步就会报错，提示时间不对，可能是因为我们在装系统的时候没有弄好时间，可以用下面的代码来重新设置时间，然后试着重新安装一下`archlinuxcn-keyring`确保安装到位。

```
# source: https://bbs.archlinux.org/viewtopic.php?id=201776
# enable ntp and ensure the time correct
sudo timedatectl set-ntp 1  # number 1, not character l
sudo stimedatectl status

sudo rm -fr /etc/pacman.d/gnupg

# create pacman master key
sudo pacman-key --init

# reload keys from keyring resources
sudo pacman-key --populate

```

## 版本管理工具（git）

如果没有`git`，我无法想象这个世界该要以何种方式继续运行下去。

```
sudo pacman -S git

```

## 图形界面（dwm）

强烈建议老铁移步到下面这个链接查看如何安装图形界面，我仅记录自己电脑上的安装过程

第一步、安装显卡驱动， 我的显卡是 amd 集成显卡，安装`xf86-video-amdgpu`。具体要安装哪个显卡驱动可以查看下面这个表格：

![](https://pic1.zhimg.com/v2-edd6c451b37e82af32ada902d4e9c2d8_r.jpg)

```
sudo pacman -S xf86-video-amdgpu

```

第二步、安装 Xorg 桌面服务：

```
sudo pacman -S xorg xorg-server xorg-xinit

```

第三步、下载 dwm 源代码：

```
git clone https://git.suckless.org/dwm --depth=1  ## 浅层复制，节约带宽和硬盘空间
cd dwm

```

第四步、修改`config.mk`文件：

```
X11INC = /usr/X11R6/include   ---修改为---> X11INC = /usr/include/X11
X11LIB = /usr/X11R6/lib       ---修改为---> X11INC = /usr/include/X11

```

第五步、编译并安装：

```
sudo make clean install

```

第六步、配置`startx`，让 X 窗口服务启动时自动运行 dwm 窗口管理器：

```
echo exec dwm >> ~/.xinitrc

```

如果除了`dwm`以外，如果以前还有别的桌面系统，记得把`exec`注释掉。比如我以前用过 lxde 桌面，`~/.xinitrc`里面会有一句`exec startlxde`，把它注释掉就好了。此时我们使用`startx`就可以进入图形界面了，使用`shift+alt+q`快捷键可以退出图形界面。

第四步、设置登录后自动进入图形环境。如果不设置这一步，就需要每一次登录都手动输入一次`startx`。使用 vim 打开`~/.bash_profile`，在文件最后补上如下内容：

```
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx
fi

```

到了这一步，图形界面就安装完毕了，以后只要成功登录就会自动打开桌面环境。可以使用快捷键`shift+alt+enter`打开一个新的终端（如果你有终端模拟器的话，比如我现在就没有终端模拟器，所以我按这个快捷键是一点反应都没有）。

## 终端模拟器（st）

第一步，下载 st 源代码

```
git clone https://git.suckless.org/st --depth=1
cd st

```

第二步，修改`config.mk`文件

```
X11INC = /usr/X11R6/include   ---修改为---> X11INC = /usr/include/X11
X11LIB = /usr/X11R6/lib       ---修改为---> X11INC = /usr/include/X11

```

第三步，编译并安装

```
sudo make clean install

```

安装好`st`以后就可以使用`startx`进入图形界面，然后使用`shift+alt+enter`打开终端了，不过这个时候的`st`没有经过任何配置，长得特别丑。

## 程序启动器（dmenu）

dwm 这个窗口管理器没有提供任何一个按钮给大家点，只能在终端中通过键入程序名的方式启动程序。但是这种启动方式会有一个终端窗口停留在屏幕上，关掉这个终端窗口还会造成程序的立即退出。所以推荐大家使用`dmenu`，使用`Alt+p`可以在 dwm 当中打开 dmenu，然后通过键入程序名称可以启动相应的程序，但不会产生终端窗口，非常好哈。

```
sudo pacman -S dmenu

```

## 代码编辑器（Vim）

等等，我不是已经安装了 Vim 嘛，为啥还要再安装一次？这是因为 Arch Linux 上直接使用`pacman`安装的 vim 居然是`-clipboard`，无法使用系统剪贴板，都要哭出声来了。解决办法就是用`gvim`顶掉 vim，不过不用担心，安装了`gvim`后还是可以在命令行里使用 vim 的，只不过这个 vim 就有`+clipboard`了。

```
sudo pacman -S gvim 

```

## 文件管理器（ranger）

终端版文件管理器，好不好用另说，反正你就说是不是极简吧。

```
sudo pacman -S ranger

```

`ranger`有一个实用功能是图片预览，就是当我们当前选择的项目如果是图片的话，它会自动在屏幕的最右侧打开这张图片，非常方便我们选择图片。

```
# 复制默认的配置文件到家目录下
ranger --copy-config=all

# 切换到配置文件夹当中
cd ~/.config/ranger

```

我们需要修改`rc.conf`这个文件，首先找到`set preview_images false`这一行，把`false`改为`true`打开图片预览的选项 ，然后找到`set preview_images_method w3m`这一行，把默认的`w3m`改为`ueberzug`。最后，我们把`ueberzug`这个命令安装上就可以完成工作了。

```
sudo pacman -S ueberzug

```

这边之所以会选择使用`ueberzug`来预览图片，而不是默认的`w3m`，是因为这个在我的电脑上无法完成工作，如果老铁们可以用`w3m`预览图片的话，那自然是不需要调整预览方式的。当然了，选择`w3m`就要把它安装到系统当中了哈：

```
sudo pacman -S w3m

```

## 网络代理（QV2ray）

```
sudo pacman -S v2ray qv2ray

```

使用`qv2ray`设置好代理以后，如果想让终端使用代理，可以直接在终端里面写上 (地址和端口写上自己设置好的)：

```
export all_proxy=http://127.0.0.1:8889

```

这样的设置只是让当前终端临时可用系统代理，比较好的做法是在`~/.bashrc`里面写上：

```
alias proxy_up='export all_proxy=http://127.0.0.1:8889'
alias proxy_down='unset all_proxy'

```

然后在自己想用代理的时候就用上`proxy_up`，想要关掉代理的时候就用`proxy_down`。 可以使用`curl httpbin.org/get`来查看自己的 ip，如果 ip 确实发生了改变，那应该就是成功地设置代理了。

## 网上冲浪（火狐浏览器）

```
sudo pacman -S firefox

```

当然啦，火狐浏览器不是大多数人的第一选择，比如我现在用的就是新版 Edge 浏览器。但是火狐浏览器是在官方仓库里面的，别的浏览器都不在官方仓库里面，先安装一个火狐浏览器上上网先，回头再安装别的浏览器。比如之前你需要用另一台电脑或手机看这个攻略贴，有了火狐浏览器，你就可以直接在电脑上看这个攻略贴了，复制命令什么的方便多了呢。

顺便提一句，在终端模拟器里面粘贴内容请使用`Shift+Ctrl+V`，简单的`Ctrl+V`是没有用的。

因为这个还没有安装中文字体嘛，所以打开网页的时候，我们看到的中文文字可能都是方块乱码，这个时候我们需要安装上一些中文字体，然后再重启火狐浏览器就可以了。

## 中文字体

**Chinese Fonts is Here! Chinese Fonts is Here! Chinese Fonts is Here! Chinese Fonts is Here!**

速速把所有能整上的免费字体都给整上

```
sudo pacman -S noto-fonts-cjk wqy-microhei wqy-microhei-lite wqy-bitmapfont
sudo pacman -S wqy-zenhei ttf-arphic-ukai ttf-arphic-uming adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts

```

**Chinese Fonts is Here! Chinese Fonts is Here! Chinese Fonts is Here! Chinese Fonts is Here!**

## 声音输出（alsa-utils）

```
sudo pacman -S alsa-utils pulseaudio-alsa

```

如果电脑没有发出声音来，可能是因为声卡在默认情况下被静音了，可以使用`alsamixer`打开声音，然后还可以在这个程序里面调节音量。如果还是没有声音，那就重启一下电脑，还是没有声音的话...... 重复上述步骤，多试试吧。

如果老铁们不知道在哪里可以找到能放出声音的应用的话，你可以选择播放我的 B 站视频。

## 电源管理器（mate-power-manager）

啥桌面系统？连电源管理器都没有？？？没错，它连壁纸都没有呢....

```
sudo pacman -S mate-power-manager

```

可以用电源管理器来调节屏幕亮度，设置开机键功能和合盖后的电脑反应等。有的屏幕的亮度不能通过软件调节，那么调节屏幕亮度的功能就是废的。对于台式机来说，因为它没有电池和盖子，所以与这些硬件相关的功能也是直接没有提供的。

## 触摸板驱动

```
sudo pacman -S xf86-input-libinput

```

台式机就不用装所谓的触摸板驱动了哈。

这个触摸板驱动是看菜下饭的，如果我们笔记本的触摸板是像苹果电脑那种没有物理按键的，他会自动给我们打开轻触点击，然后或许会有一些手势可以用吧（毕竟是没有测试过，只能靠猜）。但如果我们的触摸板是带物理按键的，就比如我现在的设备 ThinkPad X201i，那么它默认是不会打开轻触点击这个功能的。这个时候，我们就需要参考 [ArchLinux 维基](https://link.zhihu.com/?target=https%3A//wiki.archlinux.org/title/Libinput)上面的内容，做一些基本的配置了。

首先，把`libinput`库提供的模板配置文件链接到它会发挥作用的地方：

```
sudo ln -s /usr/share/X11/xorg.conf.d/40-libinput.conf /etc/X11/xorg.conf.d/40-libinput.conf

```

然后，编辑前面那个模板文件，找到合适的地方，给触摸板打开轻触点击功能：

```
Section "InputClass"
    Identifier "libinput touchpad catchall"
        ......是靠这些东西定位，不是让你敲着些哈......
    Driver "libinput"
        ......到EndSection的前面输入下面的文字打开相应的选项......
    Option "Tapping" "on"
EndSection

```

最后，重启桌面系统。我们就可以惊奇地发现，触摸板现在支持轻点单击的功能了，还是挺方便的哈。

## 壁纸（feh）

```
sudo pacman -S feh

```

可以打开浏览器访问[必应首页](https://link.zhihu.com/?target=https%3A//www.bing.com/)，把它的每日一图下载下来当壁纸。图片下载完成以后，进入图片下载目录，使用`feh --bg-fill <filename>`将该图片设置为壁纸。下次登录的时候，设置好的壁纸又会失效，需要在`~/.xinitrc`当中添加一行，使其在启动图形界面后自动设置壁纸。

```
~/.fehbg &

```

## 中文输入法（fcitx5）

```
sudo pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-qt fcitx5-gtk

```

使用 vim 打开`~/.bash_profile`，在最后添上：

```
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
export SDL_IM_MODULE=fcitx

```

然后在`~/.xinitrc`当中的`exec dwm`的前面加上：

```
fcitx5 -d &

```

加上了这句，才会在启动 X 窗口时在后台运行`fcitx5`。

打开`fcitx5-configtool`，将`Pinyin`添加到输入法列表当中，可能需要去除仅显示当前语言的勾选项（Only Show Current Language）。然后还可以调整激活输入法、切换输入法的快捷方式等等。

获取更多词库和颜色主题，词库会自动应用，但是颜色主题需要在`fcitx5-configtool`当中配置一下才会生效：

```
sudo pacman -S fcitx5-pinyin-zhwiki fcitx5-material-color fcitx5-nord

```

## PDF 阅读器（Zathura）

支持 Vim 键位的 pdf 阅读器，还是挺不错的说。

```
sudo pacman -S zathura

```

## 安装 paru

安装`paru`以后我们就可以在 AUR 里面下载软件了，意味着我们能够下载更多的软件了。添加完 archlinuxcn 源以后运行：

```
sudo pacman -S paru

```

可以通过`paru --help`查看`paru`的使用帮助，下面简单介绍几个它的常见用法：

*   `paru`刷新软件仓库缓存并更新整个系统；
*   `paru <package name>`在 AUR 上检索`package name`相关的软件包，可以在检索结果中选择特定的软件包进行安装，这在我们只知道软件包的部分名称，或计划安装某一族软件包的时候特别好用；
*   `paru -S <package name>`跳过检索过程，直接快进到安装软件；
*   `paru -R <package name>`删除某个已经安装好的软件包；
*   `paru -Scc`清空缓存、删除没有用的软件安装包。

## Edge 浏览器

Edge 浏览器是我的主力浏览器，我可以在登陆以后自动填充各种网站的密码，所以即便前面已经下载了一个能够用来浏览网页的火狐浏览器，我依然需要下载一个 Edge 浏览器。

```
paru -S microsoft-edge-stable

```

## 办公软件（WPS）

```
paru -S ttf-wps-fonts wps-office-cn wps-office-mui-zh-cn wps-office-mime-cn ttf-ms-fonts cups

```

上述软件存在大量的可配置项，欢迎老铁们持续关注当前专栏，日后可能会更新一些更加具体一点的配置教程。