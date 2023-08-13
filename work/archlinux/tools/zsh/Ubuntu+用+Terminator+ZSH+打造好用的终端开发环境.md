```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
```
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

```
plugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    git
    autojump
    extract
    vi-mode
    rsync
    sudo
)
```
```
git config --global oh-my-zsh.hide-status 1 
git config --global oh-my-zsh.hide-dirty 1
```

国内源
```
wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
```

## **二 SHELL 的选择：ZSH**

早期的 shell 是`sh`，由 Steve Bourne 编写（名为 Bourne shell），目前很多 Linux 版本的系统默认 shell 为`bash`，由 Brain Fox 编写（名为 Bourne Again Shell），它是对 sh 的增强改进版本。**bash 更加符合 posix 标准，因此 bash 更适合做脚本解释器。**

而从交互式终端的角度来讲，专为交互而设计的 zsh 更为强大，它包含其他 shell(bash/ksh/csh) 的优秀特性；所以笔者在使用终端的时候选择 zsh，但是在写脚本的时候，声明的解释器往往是 bash。

zsh 被称为终极 shell，它非常强大，最为实用的功能有几点：

6. 色彩高亮 **不同的颜色表明当前命令的类型**，并且**路径有无下划线表示路径是否存在**；这可以快速帮助我们发现错误。

7. 命令提示 / 补全 提示和补全有不同实现机制，好用之处在于补全，输入命令会根据输入的历史自动补全，并且随着输入不断修正，如果补全是你期望的结果，按下右方向键接受，再回车即可。

8. 智能补全 在使用 cd 切换路径时，按下 tab 会列出当前目录下的目录和文件，如果是 bash，它会提示你手动输入，但是 zsh 中你可以继续按一下 tab 进入**选择模式**，继续使用 tab 选择，或者使用方向键选择目标目录而不需手动输入。

以上几个功能便足以说服笔者使用 zsh 替换 bash。下面是一个简单的示例：

![](https://pic4.zhimg.com/v2-6ab7c942d1f45ef646a40ee91a71796b_r.jpg)

可以看到：

9. 对于不存在的命令，显示为红色，输入时就可以发现；

10. 在输出到文件时，没有下划线说明会新建此文件，如果文件存在，我们可能就需要把写入（>）改为追加（>>）；

11. 如果是复制到不存在的目录，自然是会报错的；

12. 一直按 tab，可以进入**选择模式**，无需手动输入文件夹名，输入速度更快。

### **1 安装**

通过下面的命令可以查看系统安装了的 shell 以及当前的 shell：

```Plain Text
-> cat /etc/shells
# /etc/shells: valid login shells
/bin/sh
/bin/bash
/bin/rbash
/bin/dash
/bin/zsh
/usr/bin/zsh
-> echo $SHELL          
/usr/bin/zsh

```

如果列出的 shell 中没有 zsh，通过以下命令安装：

```Plain Text
sudo apt update
sudo apt install zsh -y

```

### **2 设置 zsh 为默认 shell**

通过命令设置：

```Plain Text
chsh -s /bin/zsh

```

## **三 配置 zsh**

配置 zsh 略微复杂，可以直接使用 [Oh-My-Zsh](https://ohmyz.sh/) 进行配置。

### **1 安装**

根据 Oh-My-Zsh Gitlab 仓库 WiKi 或者官网 [https://ohmyz.sh/](https://ohmyz.sh/) 的命令进行安装：

```Plain Text
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

```

github 在国内访问可能会很慢，清华有对应的镜像，可以参考： [ohmyzsh.git | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/ohmyzsh.git/)。

安装完后，我们只需要简单设置自己喜欢的主题和常用的插件即可。

有的主题必须使用 powerline 字体，通过以下命令安装：

```Plain Text
sudo apt install powerline fonts-powerline

```

安装之后设置终端的字体，就可以正常使用主题了。 推荐使用`Source Code Pro for Powerline Regular`或者`Ubuntu mono derivative Powerline Regular`，后者像是前者的微胖版本。

Vscode里设置字体名称如下

```Plain Text
https://github.com/powerline/fonts
```

|||||
|-|-|-|-|
|Ubuntu Mono derivative Powerline|Ubuntu Mono|Ubuntu Font License, Version 1.0||
|Space Mono for Powerline|Space Mono|SIL Open Font License, Version 1.1||

如果遇到主题乱码问题，请保持耐心，可以换一个字体库，确保字体安装对，没有那么难。
上述命令安装字体如果有问题，可以 clone 仓库：[https://github.com/powerline/fonts](https://github.com/powerline/fonts)，执行项目根目录的 install.sh 安装字体。

### **2 主题**

Oh-My-Zsh 默认安装了很多主题，位于目录`.oh-my-zsh/themes`下。 通过 zsh 配置文件`~/.zshrc`中的主题设置为自己喜欢的主题名字即可：

```Plain Text
ZSH_THEME="robbyrussell"

```

推荐主题：agnoster / agnosterzak。 agnoster 默认安装，agnosterzak 需要手动安装：

```Plain Text
cd ~/.oh-my-zsh/themes
wget https://raw.githubusercontent.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme

```

这两个是带有 git prompt 的主题，安装后进入 git 仓库目录，效果如下：

![](https://pic3.zhimg.com/v2-f063ebdbb7b0d52d3b5be142f7d494f2_r.jpg)

笔者选择它的原因在于可以直观看到当前的分支名称，可以看到仓库的状态：有几个文件没有追踪，添加了几个文件，改动了几个文件。

如果是很大的项目，在进入项目时会比较费时，这时可以禁止 oh-my-zsh 读取 git status：`git config --add oh-my-zsh.hide-status 1`
使用工具的目的是提高效率，**如果给我们的效率带来损耗，也要毫不犹豫地禁用**。

如果设置 ZSH_THEME="random"，那么每次打开新的终端窗口时会随机选择一个主题使用，`echo $RANDOM_THEME`可获取当前主题名称。

如果想从限定的主题列表中随机选择，那么同时设置`ZSH_THEME_RANDOM_CANDIDATES`即可，例如：`ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )`。

### **3 推荐插件**

默认安装的插件位于路径`.oh-my-zsh/plugins/`。 插件配置通过 zsh 配置文件`~/.zshrc`中的`plugins`即可：

```Plain Text
plugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    git
    autojump
    extract
    vi-mode
    rsync
    sudo
)

```

### **命名高亮：zsh-syntax-highlighting**

zsh 语法高亮就是通过这个插件实现的，默认应该是安装的，如果没有使用下面的命令安装：

```Plain Text
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

```

### **命令补全：zsh-autosuggestions**

如图所示，输入命令时可提示自动补全（灰色部分），然后**右方向键**即可补全：

![](https://pic2.zhimg.com/v2-cf44870ff4a6776e6c210af582249c61_r.jpg)

同样应该是默认安装，如果没有使用命令：

```Plain Text
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

```

### **git 操作加速：git**

主要是提供了很多 alias，很多常用的 git 命令的简写。通过命令`alias | grep git`查看。 熟记常用命令的缩写对于提高效率不言而喻。以下是笔者常用的 git 命令：

```Plain Text
g=git
ga='git add'
gaa='git add --all'
gb='git branch'
gbD='git branch -D'
gcb='git checkout -b'
gd='git diff'
gl='git pull'
glog='git log --oneline --decorate --graph'
gp='git push'
gpf='git push --force-with-lease'
grb='git rebase'
grba='git rebase --abort'
grbc='git rebase --continue'

```

同时笔者也给 git 的子命令也设置了 alias，通过`git alias`，或者修改配置文件`~/.gitconfig`：

```Plain Text
[alias]
 st = status
 co = checkout
 ci = commit
 br = branch
 last = log -1

```

通过以上配置，使用 git 的时候便可提速几倍。

### **目录跳转：autojump**

这个插件会自动统计我们经常 cd 的目录，不同目录会有不同的权重。在我们想要进入某个目录时，使用`j <dir-name>`即可以帮助我们快速跳转到目标目录；

即使我们给出的目录不准确，它也会启动模糊匹配，根据权重，往往也能跳转到我们想要进入的目录；如果进入的不对，执行同样的命令它会继续搜索。

使用包管理器直接安装即可：

```Plain Text
sudo apt-get install autojump

```

默认安装的 z 插件也是类似的功能，应该是也不错的。只是笔者习惯是使用 autojump，这就如人饮水，冷暖自知喽。

和前面提到的一样，对于大型的 git 仓库，因为 oh-my-zsh 进入 git 目录会检查 git 的各种状态，所以在跳转的时候会明显变慢，可以使用下面的命令配置关闭检查功能（在特定 git 仓库内）：

```Plain Text
git config --add oh-my-zsh.hide-status 1
git config --add oh-my-zsh.hide-dirty 1

```

上面的命令是针对特定 git 仓库，如果要全局设置，则使用：

```Plain Text
git config --global oh-my-zsh.hide-status 1 
git config --global oh-my-zsh.hide-dirty 1

```

### **文件解压：extract**

刚开始使用 Linux 系统，想必大家都会有一点苦恼，对于不同类型的压缩格式：.tar、.tar.gz、.tar.bz2、.tar.xz、.rar、.zip，解压的时候到底用啥命令呢？

有了这个插件就不用纠结了，一律使用`x <archived file>`。

以上是笔者最常使用的几个插件，针对前端、后端开发，还有不同的其他插件，例如 mvn，npm，npx，aws 等等，大家可以按照自己的需要按需添加。

按最小需求安装即可，毕竟插件太多，也会影响工具的性能。

等宽字体


键盘相对于鼠标是高效的，可以多使用。
好用的终端环境不仅要好看，更加要高效，键盘虽然是高效的，但是还是要减少手指的移动和敲击。

## **一 终端的选择：Terminator**

在 ubuntu 下，相比于系统自带的终端，更加好用的终端应该是`Terminator`，它具备一些好用的特性可以提高我们的开发效率。下面开始介绍。

### **1 安装**

通过 Ubuntu 包管理工具`apt`安装即可：

```Plain Text
sudo add-apt-repository ppa:gnome-terminator
sudo apt update
sudo apt install terminator

```

### **2 设置为默认终端**

安装完成后我们设置其为默认终端，通过快捷键`Ctrl+Alt+T`即可唤起。 网上有不同的配置方法，推荐使用以下方法：

```Plain Text
gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/terminator
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"

```

如果想换回默认的设置 (感谢

[@蒋 Andy](//www.zhihu.com/people/80624348bc538bacda263874b99dc1e5)

帮忙指正)：

```Plain Text
gsettings reset org.gnome.desktop.default-applications.terminal exec
gsettings reset org.gnome.desktop.default-applications.terminal exec-arg

```

修改系统设置的时候，了解如何恢复、给默认配置备份都是极好的习惯。

通过以上设置之后，通过终端启动快捷键打开的就是`Terminator`了。

但是在文件夹内右键选择在终端打开，还是会使用系统默认的终端，这是因为: [nautilus-open-terminal uses GAppInfo to launch the terminal process, which uses a hard coded list of terminal emulator](https://git.gnome.org/browse/glib/tree/gio/gdesktopappinfo.c#n1106)

### **3 推荐配置**

快捷键启动 Terminator，右键选择**首选项设置**打开设置界面进行配置。

### **在 Preferences->Profiles->General 中**

修改字体为等宽字体，推荐`DejaVu Sans Mono`和`Hack`（没有则安装即可），也可以按自己的需修改。

勾选开启：**选中时复制 (Copy on Selection)**，这样选择想要复制的内容再也无需其他操作，粘贴的时候按鼠标中键即可粘贴，这要比右键复制粘贴岂不快上几倍！

笔者一开始也只会用右键复制，再右键粘贴；然后是使用快捷键`Ctrl+Shift+C`复制，`Ctrl+Shift+V`粘贴；直到现在是选择即复制，中键粘贴。 这种高频操作，不要小看省下的几秒钟，提升效率也在细微之处。

### **在 Preferences->Profiles->Colors 中**

可以选择自己喜欢的背景颜色和终端颜色 schemes，原则是**对眼睛友好**。不同的元素的颜色分明，比如通过`ls -al`列出文件时，不同类型的文件一目了然。笔者使用的是：

- 前景背景色：Solarized Dark

- 调色板 (Color palette)：Ambience

### **在 Preferences->Profiles->Background 中**

笔者喜欢将背景设置为半透明，数值为`0.85-0.9`最佳。

为什么？在终端输入命令时，如果要参照网页，与其切换窗口，不如透过终端直接看到后面网页上的命令:)。

### **4 选择、复制、粘贴**

再强调一遍：**选中即复制，鼠标中键粘贴**。对于单词，双击即可选中，三击选中一行。

### **5 快捷键**

1. 新建窗口：`Ctrl+Shift+T`

2. 关闭窗口：`Ctrl_Shift+W`

3. 水平划分窗口：`Ctrl+Shift+O`

4. 垂直划分窗口：`Ctrl+Shift+E`

5. 窗口切换：`Ctrl+Tab`或者`Alt+方向键`

可以修改快捷键为自己熟悉的，比如关闭 tab 窗口，浏览器和 IDE 通常都是`Ctrl+W`，为了保持习惯一致，可以将其修改为`Ctrl+W`。

Terminator 多窗口示例如下：

![](https://pic2.zhimg.com/v2-7b721f00ccb3bf1a443b39b308b735c9_r.jpg)

要在窗口上方显示路径，可以右键配置文件首选项 -> 设置 -> 一般设定 -> 勾选显示标题栏



[global_config]
[keybindings]
[profiles]
[[default]]
use_system_font = False # 是否启用系统字体
login_shell = True
background_darkness = 0.92 # 背景颜色
background_type = transparent
background_image = None
cursor_color = "#3036ec" # 光标颜色
foreground_color = "#00ff00"
show_titlebar = False # 不显示标题栏，也就是 terminator 中那个默认的红色的标题栏
custom_command = tmux
font = Ubuntu Mono 15  # 字体设置，后面的数字表示字体大小
[layouts]
[[default]]
[[[child1]]]
type = Terminal
parent = window0
[[[window0]]]
type = Window
parent = ""
[plugins]
