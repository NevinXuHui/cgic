---
url: https://marvinsblog.net/post/2021-07-15-chezmoi-intro/
title: 使用 Chezmoi 管理配置文件 | Marvin's Blog【程式人生】
date: 2023-05-04 15:43:04
tag: 
banner: "undefined"
banner_icon: 🔖
---
[chezmoi](https://www.chezmoi.io/) 是一款基于模板的 dot 配置管理器，使用 go 语言编写，并使用 [https://pkg.go.dev/text/template](https://pkg.go.dev/text/template) 来对配置进行模板化以适应不同平台差异。

实际上，chezmoi 使用的是 sprig 扩展了的 go 语言的模板：[http://masterminds.github.io/sprig/](http://masterminds.github.io/sprig/)

chezmoi 的灵感来自于 [https://puppet.com/](https://puppet.com/)

## dot 配置管理器对比

[Comparison Guide #](https://www.chezmoi.io/docs/comparison/) 列举了其他几款管理器：

*   dotbot
*   rcm
*   homesick
*   yadm

这几款貌似都不支持 Windows。

## [chezmoi](https://www.chezmoi.io/) 上手

使用 scoop 安装：

```
scoop bucket add twpayne https://github.com/twpayne/scoop-bucket && scoop install chezmoi


```

`chezmoi init`会在`~/.local/share/chezmoi`创建一个 git 仓库。

最新版的 git 会提示把主分支改为 master 以外的名字，比如 main 或者 trunk，可以使用下面的配置

*   `git config --global init.defaultBranch <name>`
*   `git branch -m <name>`

使用`chezmoi edit ~/.bashrc`会使用默认编辑器来编辑 `~/.local/share/chezmoi/dot_bashrc`。使用`chezmoi -v apply`来将改动同步到`~/.bashrc`。

`chezmoi cd`可以开启一个新的 shell，进到`~/.local/share/chezmoi`。此处可以执行 git 命令来将配置存入 git 仓库。

也就是说 chezmoi 将 git 配置管理交给了用户，然后可以将 git 配置同步到 github, sr.ht 等 git 服务提供商。

如何将配置搬到其他机子上呢：

```
chezmoi init https://github.com/NevinXuHui/dotfiles.git
chezmoi apply


```

或者如果仓库命名方式就是 dotfiles，那么可以：

```
chezmoi init --apply username 


```

## [Templating Guide](https://www.chezmoi.io/docs/templating/)

模板文件要么以. tmpl 结尾，要么在. chezmoitemplates 目录。

使用`chezmoi data`来列举模板数据，数据来自：

*   .chezmoi
*   `.chezmoidata.<format>`，可以是 json, toml 或者 yaml
*   配置文件中的 data 片区

将配置文件添加为模板：`chezmoi add --template ~/.zshrc`

同上，并替换其中的模板数据：`chezmoi add --autotemplate ~/.zshrc`

将既有配置转化为模板：`chezmoi chattr +template ~/.zshrc`

手动创建模板文件：

```
chezmoi cd
$EDITOR dot_zshrc.tmpl


```

.chezmoitemplates 中的模板必须手动创建：

```
chezmoi cd
mkdir -p .chezmoitemplates
cd .chezmoitemplates
$EDITOR mytemplate


```

对模板进行测试：`chezmoi execute-template "{{ .chezmoi.hostname }}"`，其中`"{{ .chezmoi.hostname }}"`代表的是模板内容。

也可以这么来：`chezmoi execute-template < dot_zshrc.tmpl`。

**剩余略**

## [Manage machine-to-machine differences](https://www.chezmoi.io/docs/how-to/#manage-machine-to-machine-differences)

使用模板，在`~/.config/chezmoi/chezmoi.toml`中创建：

```
[data]
    email = "me@home.org"


```

*   保存私有数据的话，需要确保 chezmoi.toml 的访问权限为 0600
*   除了 toml 以外，还可以使用 json 或者 yaml，只要 [https://github.com/spf13/viper](https://github.com/spf13/viper) 支持即可
*   变量名以字母开头，可以包含数字和字母

使用`chezmoi add --autotemplate ~/.gitconfig`可以自动对添加的. gitconfig 中的配置自动进行模板变量检查。

`chezmoi re-add`可以重新添加某配置，只是不支持模板。也可以通过`chezmoi merge`来化解冲突。

使用`chezmoi data`可以列举出所有支持的模板变量。

## [Use KeePassXC](https://www.chezmoi.io/docs/how-to/#use-keepassxc)

需要在配置文件`~/.config/chezmoi/chezmoi.toml`中添加类似如下配置：

```
[keepassxc]
    database = "/home/user/Passwords.kdbx"


```

目前 Chezmoi 只能明文输入密码，参考 [ReadPassword](https://github.com/twpayne/chezmoi/blob/4191e4bf50202731e4aa0440f9ca30793a570685/internal/cmd/terminal.go#L47)

如何在 Go 中读取密码，参考 [getpasswd functionality in Go?](https://stackoverflow.com/questions/2137357/getpasswd-functionality-in-go)

## [Comparison Guide](https://www.chezmoi.io/docs/comparison/)

*   dotbot
*   rcm
*   homesick
*   yadm
*   gnu stow

## [Reference Manual](https://www.chezmoi.io/docs/reference/)

一些概念：

*   source state，可用于本机的配置文件
*   source directory，chezmoi 用于保存配置的 git 仓库：`~/.local/share/chezmoi`
*   target state，已用于本机的配置文件
*   destination directory，默认为 home 目录
*   target，目标配置文件，目录或者符号链接
*   destination state，默认为 home 目录里面的所有配置文件
*   config file，用于 chezmoi 自身的配置文件，默认为`~/.config/chezmoi/chezmoi.toml`。

## 其他

### 小贴士

*   使用`doskey cm=chezmoi $*`可以在 cmd.exe 里面起一个短名 cm 用来替代 chezmoi，参考 [Aliases in Windows command prompt](https://stackoverflow.com/questions/20530996/aliases-in-windows-command-prompt)
*   使用`chezmoi unmanaged`可以列举所有不归属 chezmoi 管理的文件。
*   可以通过 source state 中的`.chezmoiignore`来显示阻止某些文件添加到 chezmoi 管理。
*   可以通过`chezmoi doctor`来检查当前主机上 chezmoi 的配置状况

（未完待续）