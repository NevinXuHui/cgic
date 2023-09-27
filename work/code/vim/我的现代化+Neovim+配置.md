之前 vim 和 emacs 都折腾过不少时间，也用这俩写过几个小项目，最后终于还是在 nvim 安家了。

需要说明一下，vim 和 neovim 不是同一个软件，具体的区别可以自行 Google，推荐一篇文章：

[Vim 还是 Neovim？为什么你应该使用后者？ - 掘金](https://juejin.cn/post/7090094882588459045)

目前仓库提供了对 0.7 和 0.8 两个版本的支持，如果没有非要使用 0.7 版本的理由，建议使用 0.8 版本，相关的问题也会得到更快的解决。

因为仓库目前除了我之外还有另外两个维护者，所以更新比较频繁，处理 issue 的速度也比较快。

[ayamir/nvimdots](https://github.com/ayamir/nvimdots)

目前我的 git 仓库状态：

|分支|插件管理|补全方案|性能|实用性|扩展性|上手难度|
|-|-|-|-|-|-|-|
|main|lazy.nvim|nvim-cmp|高|高|高|高|
|0.7|packer|nvim-cmp|高|高|高|高|

仓库使用纯 lua 进行配置，启动速度、运行性能、扩展性等都是第一流的水平。

唯一的难点可能是需要一定时间熟悉，所以我已经做了大量的配置来尽可能做到不折腾开箱即用。

于我自身而言，neovim 相比于 vscode 的优势主要体现在这几个地方：

1. nvim 聚焦于终端和键盘操作，更加优雅方便。

2. nvim-lsp, treesitter 实现了不同语言配置的大一统。

3. nvim 比 vscode 轻便快速得多。

4. nvim 的配置更加灵活随性，可定制性远高于 vscode。

5. 基于 lua 的众多 nvim 的新插件功能都相当不错且符合直觉。

因为主要阵地在 Github，所以知乎这边的更新可能比较慢，一切以 Github 的更新为准。

## 1. 展示成品

![](https://pic1.zhimg.com/v2-00ad741e6fea5dd1227857515d6f99c8_r.jpg)

![](https://pic1.zhimg.com/v2-9febc3ab0eabbd51b50e7cf8a3d96020_r.jpg)

![](https://pic4.zhimg.com/v2-889132c00923b6ea48fd6b1cd62eddd7_r.jpg)

![](https://pic4.zhimg.com/v2-325b9914e36b38b9aee77c19d7cff06b_r.jpg)

![](https://pic4.zhimg.com/v2-f91ecb351e4e1ce9f92feaeaad24c5d7_r.jpg)

![](https://pic1.zhimg.com/v2-ebc3a4c0fff468b7776c56fb3f965c10_r.jpg)

![](https://pic1.zhimg.com/v2-ec4f7ac265599adf934fe6bfc7d239d0_r.jpg)

![](https://pic3.zhimg.com/v2-d6a624e31e962fc72976ee8961d3eb8e_r.jpg)

![](https://pic1.zhimg.com/v2-37dfdb723bc9cf8d84df3f0038a8e534_r.jpg)

![](https://pic3.zhimg.com/v2-ae111fc6a423ea9cc70cc430141a66ba_r.jpg)

![](https://pic1.zhimg.com/v2-1ea37c7f91c296947779c4eb8f551424_r.jpg)

![](https://pic1.zhimg.com/v2-ca0f6d380d3d76e088e2e5081fad2120_r.jpg)

![](https://pic1.zhimg.com/v2-3b528385f464050f5b7282d0ed0f2ddc_r.jpg)

![](https://pic3.zhimg.com/v2-f169c6152c26e2d2aca93e61ddae61a2_r.jpg)

![](https://pic4.zhimg.com/v2-d81ff9860101f4dc7a8e24b56d710c17_r.jpg)

![](https://pic2.zhimg.com/v2-66e7f4780d8db50caef52650a9269fc9_r.jpg)

![](https://pic1.zhimg.com/v2-818c72a99b61f9ded5ce43d3f10e89cc_r.jpg)

![](https://pic1.zhimg.com/v2-c2976f94773bf28972504b4304315b8c_r.jpg)

![](https://pic4.zhimg.com/v2-a939e2a3c84430548aec71704c503d53_r.jpg)

![](https://pic3.zhimg.com/v2-ec1e43e11659a1ec1300df2c512bfc72_r.jpg)

![](https://pic4.zhimg.com/v2-296f6881193e72728e6436d82a1abf93_r.jpg)

![](https://pic1.zhimg.com/v2-86098ca2881af4414ccff53cb851cc84_r.jpg)

除了展示的这些功能之外：

6. 支持依托于 LSP 的保存时代码异步 format 与 lint；

7. 支持按照格式自定义代码补全片段；

8. 部分语言支持依托于 DAP 的 debug；

9. 支持依托于 Treesitter 的代码块可视化选择；

10. 支持平滑滚动与滚动条滚动；

11. 用 vim-fugitve 和 lazygit 集成了常用的 Git 操作；

总之就是你想到的想不到的功能我都配置好了，并且尽可能保证高效快速。

默认保存时格式化，可以使用命令`:FormatToggle`来切换启用或禁用此功能。

## 2. 配置 github 的 ssh key（如果使用 http 可以不配置）

由于众所周知的原因，大陆用户访问 github 会受到限制，经过测试之后发现使用 ssh 完全不会受到影响（比我使用代理还要快，几乎是瞬间就能完成插件或者 treesitter parser 的更新）

2.1 添加 github 的 ssh key

Linux/MacOS 用户：

先安装 openssh（以 archlinux 为例，其他发行版应该也是要装 openssh 这个包）：

```Plain Text
sudo pacman -S openssh

```

Windows 用户：

手动下载

[Git](https://git-scm.com/)

安装过程一路默认选项 Next 即可，安装完成之后启动 Git 窗口，配置以下用户设置

```Plain Text
git config --global user.name "你的github账户名"
git config --global user.email "你的github账户默认的邮箱地址"

```

这里以后的设置三种系统都一样，Linux/MacOS 在终端输入命令操作，Windows 在 Git 窗口中操作即可

之后生成你的 ssh-key

```Plain Text
ssh-keygen -t rsa -b 4096 -C "你的github账户默认的邮箱地址"

```

过程中会要求输入 passphrase 做进一步的加密保护，自行输入，直接回车表示没有 passphrase。

假设你刚刚生成的 sshkey 的路径为~/.ssh/id_rsa（windows 的路径形如 / c/Users/ayamir/.ssh/id_rsa）

拷贝~/.ssh/id_rsa.pub 的输入到剪切板（即拷贝公钥内容）

```Plain Text
cat ~/.ssh/id_rsa.pub

```

选中输出并复制到系统剪切板

2.2 配置 github 的 ssh key

浏览器打开这个网址：[https://github.com/settings/keys](https://github.com/settings/keys)

点击 **New SSH key**，之后将拷贝的公钥内容粘贴到 key 那个输入框中，tile 框中的内容可以输入这个 key 的描述性文字，以我为例输入的是 archlinux ssh

之后点击 **Add SSH key**，最后输入你的 github 密码确认即可

## 3. 安装

目前仓库已经支持 Windows/*nix 多个平台：

Windows 平台使用具有**管理员权限**的 [Powershell 7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3) 以上的版本执行：

```Plain Text
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ayamir/nvimdots/HEAD/scripts/install.ps1'))

```

![](https://pic4.zhimg.com/v2-8d146c480722d45850198f74c2dafb0b_r.jpg)

安装脚本支持 chocolatey 和 scoop 这两种包管理器，下载相应的安装包时会检测系统代理，因为大多是从 github 下载，所以最好开启系统代理。

*nix 平台执行：

```Plain Text
if command -v curl >/dev/null 2>&1; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ayamir/nvimdots/HEAD/scripts/install.sh)"
else
    bash -c "$(wget -O- https://raw.githubusercontent.com/ayamir/nvimdots/HEAD/scripts/install.sh)"
fi

```

安装之后输入

```Plain Text
nvim --version

```

之后的结果应该是这样

![](https://pic1.zhimg.com/v2-96139c3042743f5bf553e1c423b31ad8_r.jpg)

之后只需要执行`nvim`即可，结果应该像这样：

![](https://pic3.zhimg.com/v2-e77154de6c4501741b7e933948e5197e_r.jpg)

![](https://pic4.zhimg.com/v2-a9b2d5695b8ba3069583b611a44224b7_r.jpg)

![](https://pic4.zhimg.com/v2-561cde97941712a7f5cc3c3302537ea7_r.jpg)

这时就可以使用 telescope 打开文件开始编辑，默认的`<leader>`键为空格。

## 4. 具体介绍

Github 的介绍永远是最新的，直接看 [Wiki](https://github.com/ayamir/nvimdots/wiki) 即可，具体的问题最好去 Github 开 Issue 问。

## 5. 常见问题

12. 为什么图标是乱码？

因为你需要把你的终端字体改成 Nerd Font 字体。

13. 推荐的终端？

跨平台：

[https://github.com/wez/wezterm](https://github.com/wez/wezterm)

Windows 平台专用：

[https://github.com/microsoft/terminal](https://github.com/microsoft/terminal)

*nix 平台专用：

[https://github.com/kovidgoyal/kitty](https://github.com/kovidgoyal/kitty)

14. 为什么有些插件安装不了或者更新不了？

首先检查你的网络状况：

- 如果你使用 https 来安装插件，首先保证你能正常流畅的访问到 github；

- 如果你使用 ssh，那么检查 ssh 相应的配置是否正确。

检查完成之后，进入`nvim`之后按下`<leader>ps`就能同步所有插件。

如果更新很多次，总有插件没法安装或者更新，首先检查对应的插件是否已经被下载到本机，插件实际的安装路径在

```Plain Text
~/.local/share/nvim/site/lazy

```

![](https://pic4.zhimg.com/v2-3efca4f0efe459db74eb14d6a9a1a26f_r.jpg)

删除对应目录重新执行上面的操作即可。

如果还是出现问题，那就在 Sync 之后将光标移动到安装失败那一行，按下回车看看相应的错误日志，根据日志再去 github 开 issue。

15. 怎么设置默认不在保存时进行格式化？

![](https://pic1.zhimg.com/v2-b494e5a1ed97fec19c78b2c9eb167ca8_r.jpg)

修改`lua/core/settings.lua` 中的`format_on_save`这一行的`true`为`false`之后重新打开`nvim`。

16. 怎么在当前项目目录下全局搜索某个符号？

当前的项目路径会在`lualine`中实时显示，

![](https://pic3.zhimg.com/v2-7d300859bc56de9c65a7efb1135a753e_r.jpg)

按下快捷键`<leader> fw` 并输入你想要搜索的符号即可

![](https://pic4.zhimg.com/v2-e0114f8c50af17989167dc2d60c72a1f_r.jpg)

搜索功能基于`ripgrep`，并支持其命令行的参数，详细可以自己去了解一下`ripgrep`怎么使用：

[https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md)

17. 怎么知道哪些 lsp 在运行？

执行`<leader>li>`可以打开`LspInfo`窗口：

![](https://pic2.zhimg.com/v2-39ee2052cc2c81ac7b8a9a35d6c669f5_r.jpg)

