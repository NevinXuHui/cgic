---
url: https://zhuanlan.zhihu.com/p/625583037
title: Windows 安装 Zsh 终端
date: 2023-08-02 09:45:54
tag: 
banner: "https://images.unsplash.com/photo-1689126494042-39f69fa4c8c5?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkwOTQwNzQ4fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
### 前言

本文以 `Git Bash` 终端为基础，来安装 `Zsh`终端和 `powerlevel10k` 主题，轻松易上手。

本文以 `Windows Terminal` 为例，也就是 `Windows 11` 中的 `终端`，`Windows 10` 没有的话，可以去应用商店搜索并下载。但这并不是必须的，你使用 `Git Bash` 也是可以的。

本文所用到软件和字体文件，建议大家从文中提供的官网地址进行下载，以保证版本的时效性。由于网络原因，一些无法访问外网的小伙伴，笔者帮大家打包好了一份，方便大家下载（软件打包时间为 2023-04-26，请注意使用时间）：

[软件与字体打包下载地址](https://luwnto.lanzoum.com/b00wxp55g) 密码：4p54

### 安装 git bash

下载 [windows 版本 git](https://git-scm.com/download/win)，一般来说，下载 64 位版本：

![](<assets/1690940754810.png>)

在安装的过程中，记得勾选 `Add a Git Bash Profile to Windows Terminal` （如果你不习惯使用 `window` 终端，喜欢使用 `Git Bash`，那么下面这几步可以跳过），之后的安装一直下一步即可：

![](<assets/1690940754880.png>)

勾选是为了在 `Windows Terminal（终端）` 中能够使用 `Git Bash`，可以看一下，原本终端是没有 `Bit Bash` 选项的：

![](<assets/1690940754931.png>)

安装 `git` 之后，重新打开终端，在标签页选择项中就可以看到 `Git Bash` 的选择项了：

![](<assets/1690940754972.png>)

如果在安装 `Git` 的时候勾选了这个选项，但是没有出现 `Git Bash` 选项的话，可能是 `Windows Terminal` 版本过低，在应用商店中搜索 `Windows Terminal`，更新一下即可。

### 安装 zsh

下载 [zsh 安装包](https://packages.msys2.org/package/zsh?repo=msys&variant=x86_64)：

![](<assets/1690940755007.png>)

将 zsh 安装包解压到 git 的安装根目录下，可以使用 [7-Zip-zstd](https://github.com/mcmilk/7-Zip-zstd/releases) 解压：

![](<assets/1690940755033.png>)

需要解压两次，第一次解压，解压到当前目录即可，得到 `.tar`文件：

![](<assets/1690940755057.png>)

第二次解压 `.tar`文件到当前目录（直接解压到 git 安装目录可能会没有权限）：

![](<assets/1690940755082.png>)

移动解压后的文件到 `git` 安装目录即可，需要权限的话就授权，重名的话直接覆盖：

![](<assets/1690940755108.png>)

打开 `Git Bash` 标签页或者直接右键打开 `Git bash` 输入 `zsh`，出现下图则安装成功：

![](<assets/1690940755136.png>)

暂时先不进行其他设置，直接输入 `0` 结束并生成 `.zshrc` 配置文件即可。

由于现在没有安装 `zsh` 主题，可以这样区分 `bash` 和 `zsh`，`bash`的光标在第二行，`zsh`的光标在同一行：

![](<assets/1690940755169.png>)

### 设置默认启动

### 设置 Git Bash 默认使用 Zsh

每次打开 `Git Bash` 终端，你会发现默认还是 `Bash` 终端，而不是 `Zsh`，可以通过编辑 `Bash` 终端的配置文件 `.bashrc` 来实现默认使用 `Zsh`，在 `Git Bash` 终端中输入命令：

```
vim ~/.bashrc

```

![](<assets/1690940755194.png>)

`Vim` 默认是命令模式，你可以直接将配置内容粘贴进去，然后输入冒号 `:` 进入尾行模式，在尾行模式输入小写 `wq` 最后按回车键，保存退出：

```
if [ -t 1 ]; then
  exec zsh
fi

```

![](<assets/1690940755262.png>)

也可以在 vim 命令模式按小写 `i` 进入插入模式，之后粘贴或写入内容，按 `Esc` 退出插入模式，然后输入冒号 `:` 进入尾行模式，在尾行模式输入小写 `wq` 最后按回车键，保存退出

之后再打开 `Git Bash` 终端，默认就会使用 `Zsh` 了。第一次可能有一个警告：大概是找不到 `~/bash_profile` 等一些文件，可以忽略，以后不会再出现了。

### 设置 Windows Terminal 默认使用 Git Bash

每次打开 `Windows Terminal` 默认使用的是 `Windows PowerShell`，要改为默认使用 `Git Bash`，在设置里面进行设置即可。在更多选项中点击设置，或者右键标题栏空白处再点击设置，设置 `Git Bash` 为默认终端：

![](<assets/1690940755311.png>)

### 安装 Oh My Zsh

在安装好 `Zsh` 终端之后，看起来跟 `Bash` 终端并无太大的区别，我们也没有进行设置。而 `Oh My Zsh` 可以用于管理 `Zsh`配置。它捆绑了数千个有用的功能、助手、插件、主题等。

在命令行输入命令并按回车执行：

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

```

出现下图的内容就是安装成功了，如果出现错误，或长时间没有响应，多试几次即可：

![](<assets/1690940755346.png>)

最后一行的 `ERROR` 可以忽略

### 配置 zsh

`Zsh`的配置文件在用户的家目录，文件是 `.zshrc`，编辑配置文件，可以对 `Zsh`进行一些定制化配置：

```
vim ~/.zshrc

```

编辑并保存配置文件之后，并不会立即生效，可以关闭所有终端重新打开，或者使用命令让配置生效：

```
source ~/.zshrc

```

### 配置主题

`Oh My Zsh` 安装默之后，默认使用主题是 `robbyrussell`，可以修改 `.zshrc` 配置中的 `ZSH_THEME` 字段，所有可用主题可参考 [ohmyzsh 官方文档](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)，这里先配置一下我个人比较喜欢的主题：

![](<assets/1690940755391.png>)

### 配置插件

通过使用插件，可以让 `Zsh` 的功能更加强大，`Zsh` 和 `Oh My Zsh` 自带了一些实用的插件，也可以下载其他的插件。 如 `Zsh` 自带 `Git` 插件，可以在命令行显示 `Git` 相关的信息，并提供了一些操作 `Git` 的别名：

```
gaa = git add --all
gcmsg = git commit -m
ga = git add
gst = git status
gp = git push

```

![](<assets/1690940755417.png>)

### 自动补全

`zsh-autosuggestions` 插件，可以在你历史指令中找到与你当前输入指令匹配的记录，并高亮显示，如果想直接使用，可以直接通过右方向键补全。 安装插件，在终端分别执行下面两条命令：

```
cd ~/.oh-my-zsh/custom/plugins

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

```

插件下载完成之后，编辑 `~/.zshrc` 配置文件，修改插件相关配置项：

```
vim ~/.zshrc

```

![](<assets/1690940755446.png>)

保存退出之后，记得使用命令 `source ~/.zshrc` 重载配置。该插件生效之后，在使用命令的时候，就会匹配我们使用的命令，右键可以直接补全：

![](<assets/1690940755483.png>)

如果你不喜欢提示默认的浅灰色，可以在 `~/.zshrc` 中修改（没有配置项就添加），更多配置可以参考 [zsh-autosuggestions 官方文档](https://github.com/zsh-users/zsh-autosuggestions#suggestion-highlight-style)：

```
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#9fc5e8"

```

### 目录跳转

`Zsh` 自带有一个插件 `z`，可以让我们在访问过的目录中快速跳转，将该插件配置到 `~/.zshrc` 文件中即可使用：

![](<assets/1690940755518.png>)

保存退出之后，重载配置，随意进入一些目录，之后再使用命令 `z` 就可以实现快速跳转，支持模糊匹配：

![](<assets/1690940755601.png>)

或许相比于 `z`，更多人会选择使用 `autojump`，如果是 `Mac` 或者 `Linux` 没什么问题，`Windows` 就不太建议折腾了。

### 其他插件

`zsh-syntax-highlighting`：这个插件可以识别的 `shell` 命令并高亮显示，需下载 `sudo`：按两次 `ESC` 快速添加 `sudo` 前缀 `gitignore`：提供一条 `gi` 命令，用来查询 `gitignore` 模板

### 配置别名

`Zsh` 的 `alias` 配置项可以自定义命令别名，在使用一些比较复杂的命令时，使用别名可以提高效率，这里举例添加一个 `Git` 日志的别名：

```
alias gli="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

```

![](<assets/1690940755644.png>)

注意等号两边不要有空格

### 安装 Powerlevel10k 主题

经过前面的一些配置，基本能够满足大部分需求了，`Powerlevel10k` 并不是必须的，喜欢折腾的可以继续。 `Powerlevel10k` 是一个 zsh 主题，它使用 `power` 字体和一个引导配置向导，以一种简单的方式自定义主题。

### 安装并设置字体

首先下载官方推荐的字体 [字体下载](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)，根据自己的喜好下载一款字体即可，如果不使用 `Powerline` 字体，会导致很多图标无法显示。 下载完字体时候，右键字体，为所有用户安装：

![](<assets/1690940755722.png>)

为 `Windows Terminal` 设置字体，只改默认配置即可：

![](<assets/1690940755840.png>)

![](<assets/1690940755960.png>)

如果你更喜欢使用 `Git Bash` 终端，那就为 `Git Bash` 设置字体，右键 `Git Bash` 标题栏空白处，进入设置界面：

![](<assets/1690940756053.png>)

![](<assets/1690940756193.png>)

### 安装 Powerlevel10k

在终端执行命令安装：

```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

```

如果 `github` 无法访问，也可使用国内的地址：

```
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

```

安装完成后在 `~/.zshrc` 文件中设置 `ZSH_THEME`：

```
ZSH_THEME="powerlevel10k/powerlevel10k"

```

在终端执行命令更新 `.zshrc` 配置文件：

```
source ~/.zshrc

```

之后会显示可交互信息进行 `p10k` 配置，输入 `y` 之后按照自己的喜好进行配置即可，以后还想重新配置的话，可以执行命令 `p10k configure`，或修改 `p10k` 配置文件 `~/.p10k.zsh`：

![](<assets/1690940756278.png>)

![](<assets/1690940756371.png>)

会有很多配置项，有友好的示例，大家根据自己的喜好选择就行，如果图标没有正常显示，那就检查一下终端字体是否设置正确。到下面这一步的时候，注意选择 `off`即可：

![](<assets/1690940756455.png>)

最后一步输入 `y` ：

![](<assets/1690940756543.png>)

最终效果图：

![](<assets/1690940756649.png>)

更多配置，可以参考[官方 GitHub](https://github.com/romkatv/powerlevel10k)

End ~