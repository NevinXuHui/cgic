
#vim    #SpaceVim  #使用文档  #手册 
---
url: https://spacevim.org/cn/documentation/#%E8%87%AA%E8%BA%AB%E6%9B%B4%E6%96%B0
title: 使用文档 _ SpaceVim
date: 2023-03-29 15:50:19
tag: 
banner: "https://user-images.githubusercontent.com/13142418/176910121-8e7ca78f-8434-4ac7-9b02-08c4d15f8ad9.png"
banner_icon: 🔖
---
SpaceVim

*   [核心思想](#核心思想)
*   [显著特性](#显著特性)
*   [运行截图](#运行截图)
*   [基本概念](#基本概念)
*   [适用人群](#适用人群)
*   [更新回滚](#更新回滚)
    *   [自身更新](#自身更新)
    *   [更新插件](#更新插件)
    *   [重新安装插件](#重新安装插件)
    *   [获取日志](#获取日志)
*   [用户配置](#用户配置)
    *   [启动函数](#启动函数)
    *   [Vim 兼容模式](#vim-兼容模式)
    *   [私有模块](#私有模块)
    *   [调试上游插件](#调试上游插件)
*   [界面元素](#界面元素)
    *   [颜色主题](#颜色主题)
    *   [字体](#字体)
*   [鼠标](#鼠标)
    *   [滚动条](#滚动条)
    *   [界面元素切换](#界面元素切换)
    *   [状态栏](#状态栏)
    *   [标签栏](#标签栏)
    *   [文件树](#文件树)
        *   [文件树中的常用操作](#文件树中的常用操作)
        *   [文件树中打开文件](#文件树中打开文件)
        *   [修改文件树默认快捷键](#修改文件树默认快捷键)
*   [基本操作](#基本操作)
    *   [原生功能](#原生功能)
    *   [命令行模式快捷键](#命令行模式快捷键)
    *   [快捷键导航](#快捷键导航)
    *   [基本编辑操作](#基本编辑操作)
        *   [移动文本块](#移动文本块)
        *   [代码缩进](#代码缩进)
        *   [文本操作命令](#文本操作命令)
        *   [文本插入命令](#文本插入命令)
        *   [增加或减小数字](#增加或减小数字)
        *   [复制粘贴](#复制粘贴)
        *   [增删注释](#增删注释)
        *   [编辑历史](#编辑历史)
        *   [文本编码格式](#文本编码格式)
    *   [窗口管理](#窗口管理)
        *   [常用编辑器窗口](#常用编辑器窗口)
        *   [窗口操作常用快捷键](#窗口操作常用快捷键)
    *   [缓冲区管理](#缓冲区管理)
        *   [缓冲区操作](#缓冲区操作)
        *   [新建空白 buffer](#新建空白-buffer)
        *   [特殊 buffer](#特殊-buffer)
        *   [文件操作相关快捷键](#文件操作相关快捷键)
        *   [Vim 和 SpaceVim 相关文件](#vim-和-spacevim-相关文件)
    *   [模块管理](#模块管理)
    *   [模糊搜索](#模糊搜索)
        *   [配置搜索工具](#配置搜索工具)
        *   [常用按键绑定](#常用按键绑定)
        *   [在当前文件中进行搜索](#在当前文件中进行搜索)
        *   [搜索当前文件所在的文件夹](#搜索当前文件所在的文件夹)
        *   [在所有打开的缓冲区中进行搜索](#在所有打开的缓冲区中进行搜索)
        *   [在任意目录中进行搜索](#在任意目录中进行搜索)
        *   [在工程中进行搜索](#在工程中进行搜索)
        *   [后台进行工程搜索](#后台进行工程搜索)
        *   [在网上进行搜索](#在网上进行搜索)
        *   [实时代码检索](#实时代码检索)
        *   [保持高亮](#保持高亮)
        *   [获取帮助信息](#获取帮助信息)
    *   [常用的成对快捷键](#常用的成对快捷键)
    *   [跳转，合并，拆分](#跳转合并拆分)
        *   [跳转](#跳转)
        *   [合并，拆分](#合并拆分)
    *   [其他快捷键](#其他快捷键)
        *   [以 `g` 为前缀的快捷键](#以-g-为前缀的快捷键)
        *   [以 `z` 开头的命令](#以-z-开头的命令)
*   [进阶使用](#进阶使用)
    *   [工程管理](#工程管理)
        *   [在工程中搜索文件](#在工程中搜索文件)
        *   [自定义跳转文件](#自定义跳转文件)
    *   [标签管理](#标签管理)
    *   [任务管理](#任务管理)
        *   [自定义任务](#自定义任务)
        *   [任务自动识别](#任务自动识别)
        *   [任务提供源](#任务提供源)
    *   [代办事项管理器](#代办事项管理器)
    *   [Iedit 多光标编辑](#iedit-多光标编辑)
        *   [Iedit 快捷键](#iedit-快捷键)
    *   [高亮光标下变量](#高亮光标下变量)
    *   [异步运行器和交互式编程](#异步运行器和交互式编程)
    *   [错误处理](#错误处理)
    *   [格式规范](#格式规范)
    *   [后台服务](#后台服务)

## 核心思想

四大核心思想：记忆辅助、可视化交互、一致性、社区驱动。

如果违背了以上四大核心思想，我们将会尽力修复。

**记忆辅助**

所有快捷键，根据其功能的不同分为不同的组， 以相应的按键作为前缀，例如 `b` 为 buffer 相关快捷键前缀， `p` 为 project 相关快捷键前缀，`s` 为 search 相关快捷键前缀， `h` 为 help 相关快捷键前缀。

**可视化交互**

创新的实时快捷键辅助系统，以及查询系统， 方便快捷查询到可用的模块、插件以及其它更多信息。

**一致性**

相似的功能使用同样的快捷键，这在 SpaceVim 中随处可见。 这得益于明确的约定。其它模块的文档都以此为基础。

**社区驱动**

社区驱动，保证了 bug 修复的速度，以及新特性更新的速度。

## 显著特性

*   **详细的文档：** 在 SpaceVim 中通过 `:h SpaceVim` 来访问 SpaceVim 帮助文档。
*   **优雅简洁的界面：** 你将会喜欢这样的优雅而实用的界面。
*   **确保手指不离开主键盘区域：** 使用空格键（`SPC`）作为前缀键，合理组织快捷键，确保手指不离开主键盘区域。
*   **快捷键辅助系统：** 所有快捷键无需记忆，当输入出现停顿，会实时提示可用按键及其功能。
*   **更快的启动时间：** 得益于 dein.vim, 90% 的插件都是按需载入的。
*   **更少的肌肉损伤：** 频繁使用空格键，取代 `ctrl`，`shift` 等按键，大大减少了手指的肌肉损伤。
*   **更易扩展：** 依照一些[约定](https://spacevim.org/cn/development/)，很容易将现有的插件集成到 SpaceVim 中来。
*   **完美支持 Neovim:** 得益于 Neovim 的 remote 插件以及异步 API，运行在 Neovim 下将有更加完美的体验。

## 运行截图

**欢迎页面**

![](<assets/1680076219861.png>)

**工作界面**

![](<assets/1680076220339.png>)

Neovim 运行在 iTerm2 上，采用 SpaceVim，配色为：_base16-solarized-dark_

展示了一个通用的前端开发界面，用于开发：JavaScript (jQuery), SASS, 和 PHP buffers。

图中包含了一个 Neovim 的终端，一个语法树窗口，一个文件树窗口以及一个 TernJS 定义窗口

## 基本概念

**临时快捷键菜单**

SpaceVim 根据需要定义了很多临时快捷键， 这可以避免需要重复某些操作时过多按下 `SPC` 前缀键。 当临时快捷键启用时，会在窗口下方打开一个快捷键介绍窗口， 提示每一临时快捷键的功能。此外一些额外的辅助信息也将会显示出来。

文本移动临时快捷键：

![](<assets/1680076220655.png>)

## 适用人群

之所以开发 SpaceVim 这一项目，目的在于维护一个模块化、开箱即用、稳定的 Vim 开发环境， 尽最大可能地处理好各种插件以及工具之间的依赖关系，为 SpaceVim 用户节省搜索、配置、 学习插件的时间。

因此，SpaceVim 适合于：

*   初级 Vim 用户
*   追求优雅界面
*   尽可能减少[肌肉损伤](https://en.wikipedia.org/wiki/Repetitive_strain_injury)
*   追求简单但是可高度配置系统的 Vim 用户
*   追求统一的编程环境

## 更新回滚

### 自身更新

可通过很多种方式来更新 SpaceVim 的核心文件。 建议在更新 SpaceVim 之前，更新一下所有的插件。具体内容如下：

**自动更新**

注意：默认，这一特性是禁用的，因为自动更新将会增加 SpaceVim 的启动时间， 影响用户体验。如果你需要这一特性，可以将如下加入到用户配置文件中：

```
[options]
    automatic_update = true
```

启用这一特性后，SpaceVim 将会在每次启动时候检测是否有新版本。 更新后需重启 SpaceVim。

**通过插件管理器更新**

使用 `:SPUpdate SpaceVim` 这一命令，将会打开 SpaceVim 的插件管理器，更新 SpaceVim，具体进度会在插件管理器 buffer 中展示。

**通过 git 进行更新**

可通过在 SpaceVim 目录中手动执行 `git pull`， SpaceVim 默认安装的位置为 `~/.SpaceVim`, 因此可以再命令行使用如下命令进行手动更新：

### 更新插件

使用 `:SPUpdate` 这一命令将会更新所有插件，包括 SpaceVim 自身。 当然这一命令也支持参数，参数为插件名称，可同时添加多个插件名称作为参数， 同时可以使用 `Tab` 键来补全插件名称。

### 重新安装插件

在插件安装、更新过程中，如果发现某个插件损坏了， 可以使用 `:SPReinstall` 命令进行重新安装插件。 类似于 `:SPUpdate`，需要添加一个插件名称参数， 可以使用 `Tab` 键来补全插件名称。比如：

### 获取日志

使用 `:SPDebugInfo!` 这一命令可以获取 SpaceVim 运行时日志， 同时，可以使用 `SPC h I` 使用打开问题模板。 可在这个模板中编辑问题，并提交。

## 用户配置

初次启动时，SpaceVim 弹出一个选择目录（`basic` 模式、 `dark_powerd` 模式），用户需要选择合适自己的配置模板。 此时，SpaceVim 将自动在 `$HOME` 目录生成 `~/.SpaceVim.d/init.toml`。 所有用户配置文件都可以存储在 `~/.SpaceVim.d/`。

这一文件夹将被加入 Vim 的运行时路径 `&runtimepath`。

也可以通过 `SPACEVIMDIR` 这一环境变量， 指定用户配置目录的具体位置。也可以通过软链接来改变目录位置， 以便配置备份。

同时，还支持项目本地配置，配置初始文件为，项目根目录下的 `.SpaceVim.d/init.toml` 文件。同时根目录下的 `.SpaceVim.d/` 也将被加入到 Vim 运行时路径。

所有的 SpaceVim 选项可以使用 `:h SpaceVim-options` 来查看。 选项名称为原先 Vim 脚本中使用的变量名称去除 `g:spacevim_` 前缀。

完整的内置文档可以通过 `:h SpaceVim` 进行查阅。 也可以通过按键 `SPC h SPC` 模糊搜索， 该快捷键需要载入一个模糊搜索模块。

**添加自定义插件**

如果你需要添加 github 上的插件，只需要在 SpaceVim 配置文件中添加 `[[custom_plugins]]` 片段：

```
[[custom_plugins]]
    repo = 'lilydjwg/colorizer'
    # `on_cmd` option means this plugin will be loaded
    # only when the specific commands are called.
    # for example, when `:ColorHighlight` or `:ColorToggle`
    # commands are called.
    on_cmd = ['ColorHighlight', 'ColorToggle']
    # `on_func` option means this plugin will be loaded
    # only when the specific functions are called.
    # for example, when `colorizer#ColorToggle()` function is called.
    on_func = 'colorizer#ColorToggle'
    # `merged` option is used for merging plugins directory.
    # When `merged` is `true`, all files in this custom plugin
    # will be merged into `~/.cache/vimfiles/.cache/init.vim/`
    # for neovim or `~/.cache/vimfiles/.cache/vimrc/` for vim.
    merged = false
    # For more options see `:h dein-options`.
```

也可以使用仓库克隆的地址，比如：

```
[[custom_plugins]]
    repo = "https://gitlab.com/code-stats/code-stats-vim.git"
    merged = false
```

`on_cmd` 选项使得这个插件延迟加载。 该插件会在第一次执行 `ColorHighlight` 或者 `ColorToggle` 命令时被加载。

`merged` 选项用于设定是否合并该插件的文件夹，如果 `merged` 是 `true`，那么，这一插件内的文件将被合并到： `~/.cache/vimfiles/.cache/init.vim/` 或者 `~/.cache/vimfiles/.cache/vimrc/`， 这依据当前使用的是 Neovim 还是 Vim。

除了 `on_cmd` 以外，还有一些其它的选项，可以通过 `:h dein-options` 查阅。

如果需要添加多个自定义插件，可以参考如下设置：

```
[[custom_plugins]]
    repo = 'lilydjwg/colorizer'
    merged = false

[[custom_plugins]]
    repo = 'joshdick/onedark.vim'
    merged = false
```

**禁用插件**

SpaceVim 默认安装了一些插件，如果需要禁用某个插件，可以通过 `~/.SpaceVim.d/init.toml` 的 `[options]` 片段中的 `disabled_plugins` 这一选项来操作：

```
[options]
    # 请注意，该值为一个 List，每一个选项为插件的名称，而非 github 仓库地址。
    disabled_plugins = ["clighter", "clighter8"]


```

### 启动函数

由于 toml 配置的局限性，SpaceVim 提供了两种启动函数 `bootstrap_before` 和 `bootstrap_after`，在该函数内可以使用 Vim script。 可通过 `~/.SpaceVim.d/init.toml` 的 `[options]` 片段中的这两个选项 `bootstrap_before` 和 `bootstrap_after` 来指定函数名称，例如：

```
[options]
    bootstrap_before = "myspacevim#before"
    bootstrap_after  = "myspacevim#after"


```

这两种启动函数的区别在于，`bootstrap_before`函数是在载入用户配置时候执行的， 而`bootstrap_after`函数是在触发`VimEnter`事件时执行的。

启动函数文件应放置在 Vim &runtimepath 的 autoload 文件夹内。例如：

文件名：`~/.SpaceVim.d/autoload/myspacevim.vim`

```
function! myspacevim#before() abort
    let g:neomake_c_enabled_makers = ['clang']
    nnoremap jk <esc>
endfunction

function! myspacevim#after() abort
    iunmap jk
endfunction


```

在启动函数中，可以使用`:lua` 命令对 SpaceVim 进行配置，比如：

```
function! myspacevim#before() abort
    lua << EOF
    local opt = requires('spacevim.opt')
    opt.enable_projects_cache = false
    opt.enable_statusline_mode = true
EOF
endfunction


```

函数 `bootstrap_before` 将在读取用户配置后执行，而函数 `bootstrap_after` 将在 VimEnter autocmd 之后执行。

如果你需要添加自定义以 `SPC` 为前缀的快捷键，你需要使用 bootstrap function， 在其中加入以下代码（注意你定义的按键必须是 SpaceVim 没有使用的）：

```
function! myspacevim#before() abort
    call SpaceVim#custom#SPCGroupName(['G'], '+TestGroup')
    call SpaceVim#custom#SPC('nore', ['G', 't'], 'echom 1', 'echomessage 1', 1)
endfunction


```

同样地，如果你需要定义语言相关的功能，可以使用以下函数定义：

```
function! myspacevim#before() abort
    call SpaceVim#custom#LangSPCGroupName('python', ['G'], '+TestGroup')
    call SpaceVim#custom#LangSPC('python', 'nore', ['G', 't'], 'echom 1', 'echomessage 1', 1)
endfunction


```

这些按键绑定以语言相关的前缀键开头，默认的前缀键是 `,` 。 同样，你为特定语言定义的按键必须是 SpaceVim 没有使用的。

### Vim 兼容模式

以下为 SpaceVim 中与 Vim 默认情况下的一些差异。

*   按键 `s` 是删除光标下的字符，但是在 SpaceVim 中， 它是 **Normal** 模式窗口快捷键的前缀，这一功能可以使用选项 `windows_leader` 来修改，默认是 `s`。 如果需要使用按键 `s` 的原生功能，可以将该选项设置为空。
    
    ```
    [options]
        windows_leader = ''
    
    
    ```
    
*   按键 `,` 是重复上一次的搜索 `f`、`F`、`t` 和 `T` ，但在 SpaceVim 中默认被用作为语言专用的前缀键。如果需要禁用此选项， 可设置 `enable_language_specific_leader = false`。
    
    ```
    [options]
        enable_language_specific_leader = false
    
    
    ```
    
*   按键 `q` 是录制宏，但是在 SpaceVim 中被设置为了智能关闭窗口，设置该功能的选项是 `windows_smartclose`，默认值是 `q`， 可以通过将该选项设置成空字符串来禁用该功能，同时也可以设置成其他按键。
    
    ```
    [options]
        windows_smartclose = ''
    
    
    ```
    
*   命令行模式下 `Ctrl-a` 按键在 SpaceVim 中被修改为了移动光标至命令行行首。
*   命令行模式下 `Ctrl-b` 按键被映射为方向键 `<Left>`, 用以向左移动光标。
*   命令行模式下 `Ctrl-f` 按键被映射为方向键 `<Right>`, 用以向右移动光标。

可以通过设置 `vimcompatible = true` 来启用 Vim 兼容模式，而在兼容模式下，以上所有差异将不存在。 当然，也可通过对应的选项禁用某一个差异。例如，恢复逗号 `,` 的原始功能，可以通过禁用语言专用的前缀键：

```
[options]
    enable_language_specific_leader = false


```

如果发现有其它区别，可以[提交 PR](https://spacevim.org/development/)。

### 私有模块

这一部分简单介绍了模块的组成，更多关于新建模块的内容可以阅读 SpaceVim 的[模块首页](https://spacevim.org/cn/layers/)。

**目的**

使用模块的方式来组织和管理插件，将相关功能的插件组织成一个模块，启用 / 禁用效率更加高。同时也节省了很多寻找插件和配置插件的时间。

**结构**

在 SpaceVim 中，一个模块是一个单个的 Vim 文件，例如，`autocomplete` 模块存储在 `autoload/SpaceVim/layers/autocomplete.vim`，在这个文件内有以下几个公共函数：

*   `SpaceVim#layers#autocomplete#plugins()`: 返回该模块插件列表
*   `SpaceVim#layers#autocomplete#config()`: 模块相关设置
*   `SpaceVim#layers#autocomplete#set_variable()`: 模块选项设置函数
*   `SpaceVim#layers#autocomplete#get_options()`: 返回模块选项列表

### 调试上游插件

当发现某个内置上游插件存在问题，需要修改并调试上游插件时，可以依照以下步骤操作：

1.  禁用内置上游插件 比如，调试内置语法检查插件 neomake.vim

```
[options]
    disabled_plugins = ["neomake.vim"]


```

1.  添加自己 fork 的插件 修改配置文件 `init.toml`，加入以下部分，来添加自己 fork 的版本：

```
[[custom_plugins]]
   repo = 'wsdjeg/neomake.vim'
   # note: you need to disable merged feature
   merged = false


```

或者添加本地克隆版本 使用 `bootstrap_before` 函数来添加本地路径：

```
function! myspacevim#before() abort
    set rtp+=~/path/to/your/localplugin
endfunction


```

## 界面元素

SpaceVim 集成了多种实用的 UI 插件，如常用的文件树、语法树等插件，配色主题默认采用的是 gruvbox。

### 颜色主题

默认的颜色主题采用的是 [gruvbox](https://github.com/morhetz/gruvbox)。这一主题有深色和浅色两种。关于这一主题一些详细的配置可以阅读 `:h gruvbox`。

如果需要修改 SpaceVim 的主题，可以在 `~/.SpaceVim.d/init.toml` 的 `[options]` 片段中修改 `colorscheme` 选项。例如，使用 Vim 自带的内置主题 `desert`：

```
[options]
    colorscheme = "desert"
    colorscheme_bg = "dark"


```

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC T n</code></td><td>切换至下一个随机主题，需要载入<a href="https://spacevim.org/cn/layers/colorscheme/">主题模块</a></td></tr><tr><td><code>SPC T s</code></td><td>通过<a href="#模糊搜索">模糊搜索模块</a>选择主题</td></tr></tbody></table>

可以在[主题模块](https://spacevim.org/cn/layers/colorscheme/)中查看 SpaceVim 支持的所有主题。

**注意**：

SpaceVim 在终端下默认使用了真色，因此使用之前需要确认下你的终端是否支持真色。 可以阅读 [Colours in terminal](https://gist.github.com/XVilka/8346728) 了解根多关于真色的信息。

如果你的终端不支持真色，可以在 `~/.SpaceVim.d/init.toml` 的 `[options]` 片段中禁用真色支持：

```
[options]
    enable_guicolors = false


```

### 字体

在 SpaceVim 中默认的字体是 [SourceCodePro Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip)。 如果你也喜欢这一字体，建议将这一字体安装到系统中。 如果需要修改 SpaceVim 的字体，可以在 `~/.SpaceVim.d/init.toml` 的 `[options]`片段中修改选项 `guifont`，默认值为：

```
[options]
    guifont = "SourceCodePro Nerd Font Mono:h11"


```

如果指定的字体不存在，将会使用系统默认的字体，此外，这一选项在终端下是无效的，终端下修改字体，需要修改终端自身配置。

## 鼠标

默认情况下，在 `Normal` 模式和 `Visual` 模式下启用鼠标。 如果需要修改这个默认值，可以使用启动函数：

例如：禁用鼠标：

```
function! myspacevim#before() abort
    set mouse=
endfunction


```

更多信息可以阅读 `:h 'mouse'`。

### 滚动条

窗口右侧的滚动条默认是关闭的，如果需要启动滚动条，需要修改 [ui 模块](https://spacevim.org/cn/layers/ui/)的 `enable_scrollbar` 选项：

```
[[layers]]
  name = "ui"
  enable_scrollbar = true


```

### 界面元素切换

所有的界面元素切换快捷键都以 `[SPC] t` 或 `[SPC] T` 开头，你可以在快捷键导航中查阅所有快捷键。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC t 8</code></td><td>高亮所有超过 80 列的字符</td></tr><tr><td><code>SPC t f</code></td><td>高亮临界列，默认 <code>max_column</code> 是第 120 列</td></tr><tr><td><code>SPC t h h</code></td><td>高亮当前行</td></tr><tr><td><code>SPC t h i</code></td><td>高亮代码对齐线</td></tr><tr><td><code>SPC t h c</code></td><td>高亮光标所在列</td></tr><tr><td><code>SPC t h s</code></td><td>启用 / 禁用语法高亮</td></tr><tr><td><code>SPC t i</code></td><td>切换显示当前对齐 (TODO)</td></tr><tr><td><code>SPC t n</code></td><td>显示 / 隐藏行号</td></tr><tr><td><code>SPC t b</code></td><td>切换背景色</td></tr><tr><td><code>SPC t c</code></td><td>切换 conceal 模式</td></tr><tr><td><code>SPC t p</code></td><td>切换 paste 模式</td></tr><tr><td><code>SPC t P</code></td><td>切换 auto parens 模式</td></tr><tr><td><code>SPC t t</code></td><td>打开 Tab 管理器</td></tr><tr><td><code>SPC T ~</code></td><td>显示 / 隐藏 Buffer 结尾空行行首的 <code>~</code></td></tr><tr><td><code>SPC T F</code></td><td>切换全屏 (TODO)</td></tr><tr><td><code>SPC T f</code></td><td>显示 / 隐藏 Vim 边框 (GUI)</td></tr><tr><td><code>SPC T m</code></td><td>显示 / 隐藏菜单栏</td></tr><tr><td><code>SPC T t</code></td><td>显示 / 隐藏工具栏</td></tr></tbody></table>

### 状态栏

`core#statusline` 模块提供了一个高度定制的状态栏，提供如下特性，这一模块的灵感来自于 spacemacs 的状态栏。

*   展示窗口序列号
*   通过不同颜色展示当前模式
*   展示搜索结果序列号
*   显示 / 隐藏语法检查信息
*   显示 / 隐藏电池信息
*   显示 / 隐藏 SpaceVim 功能启用状态
*   显示版本控制信息（需要 `git` 和 `VersionControl` 模块）

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC [1-9]</code></td><td>跳至指定序号的窗口</td></tr></tbody></table>

默认主题 gruvbox 的状态栏颜色和模式对照表：

<table><thead><tr><th>模式</th><th>颜色</th></tr></thead><tbody><tr><td>Normal</td><td>灰色</td></tr><tr><td>Insert</td><td>蓝色</td></tr><tr><td>Visual</td><td>橙色</td></tr><tr><td>Replace</td><td>浅绿色</td></tr></tbody></table>

以上的这几种模式所对应的颜色取决于不同的主题模式。

一些状态栏元素可以进行动态的切换：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC t m b</code></td><td>显示 / 隐藏电池状态 (需要安装 acpi)</td></tr><tr><td><code>SPC t m c</code></td><td>toggle the org task clock (available in org layer)(TODO)</td></tr><tr><td><code>SPC t m i</code></td><td>显示 / 隐藏输入法</td></tr><tr><td><code>SPC t m m</code></td><td>显示 / 隐藏 SpaceVim 已启用功能</td></tr><tr><td><code>SPC t m M</code></td><td>显示 / 隐藏文件类型</td></tr><tr><td><code>SPC t m n</code></td><td>toggle the cat! (if colors layer is declared in your dotfile)(TODO)</td></tr><tr><td><code>SPC t m p</code></td><td>显示 / 隐藏光标位置信息</td></tr><tr><td><code>SPC t m t</code></td><td>显示 / 隐藏时间</td></tr><tr><td><code>SPC t m d</code></td><td>显示 / 隐藏日期</td></tr><tr><td><code>SPC t m T</code></td><td>显示 / 隐藏状态栏</td></tr><tr><td><code>SPC t m v</code></td><td>显示 / 隐藏版本控制信息</td></tr></tbody></table>

**nerd 字体安装：**

SpaceVim 默认使用 `nerd fonts`，可参阅其安装指南进行安装。

**语法检查信息：**

状态栏中语法检查信息元素如果被启用了，当语法检查结束后，会在状态栏中展示当前语法错误和警告的数量。

**搜索结果信息：**

当使用 `/` 或 `?` 进行搜索时，或当按下 `n` 或 `N` 后，搜索结果序号将被展示在状态栏中，使用类似于 `20/22` 这样的分数显示搜索结果的当前序号以及结果总数。具体的效果图如下：

![](<assets/1680076220919.png>)

搜索结果展示由`incsearch`模块提供，可以在配置中启用该模块：

```
[layers]
    name = "incsearch"


```

**电池状态信息：**

_acpi_ 可展示电池电量剩余百分比。

使用不同颜色展示不同的电池状态：

<table><thead><tr><th>电池状态</th><th>颜色</th></tr></thead><tbody><tr><td>75% - 100%</td><td>绿色</td></tr><tr><td>30% - 75%</td><td>黄色</td></tr><tr><td>0% - 30%</td><td>红色</td></tr></tbody></table>

所有的颜色都取决于不同的主题。

**状态栏分割符：**

可通过使用 `statusline_separator` 来定制状态栏分割符，例如使用常用的方向箭头作为状态栏分割符：

```
    statusline_separator = 'arrow'


```

SpaceVim 所支持的分割符以及截图如下：

<table><thead><tr><th>分割符</th><th>截图</th></tr></thead><tbody><tr><td><code>arrow</code></td><td><div class="sr-rd-content-center"><img class="" src="https://cloud.githubusercontent.com/assets/13142418/26234639/b28bdc04-3c98-11e7-937e-641c9d85c493.png" style="max-height: 400px;"></div></td></tr><tr><td><code>curve</code></td><td><div class="sr-rd-content-center"><img class="" src="https://cloud.githubusercontent.com/assets/13142418/26248272/42bbf6e8-3cd4-11e7-8792-665447040f49.png" style="max-height: 400px;"></div></td></tr><tr><td><code>slant</code></td><td><div class="sr-rd-content-center"><img class="" src="https://cloud.githubusercontent.com/assets/13142418/26248515/53a65ea2-3cd5-11e7-8758-d079c5a9c2d6.png" style="max-height: 400px;"></div></td></tr><tr><td><code>nil</code></td><td><div class="sr-rd-content-center"><img class="" src="https://cloud.githubusercontent.com/assets/13142418/26249776/645a5a96-3cda-11e7-9655-0aa1f76714f4.png" style="max-height: 400px;"></div></td></tr><tr><td><code>fire</code></td><td><div class="sr-rd-content-center"><img class="" src="https://cloud.githubusercontent.com/assets/13142418/26274142/434cdd10-3d75-11e7-811b-e44cebfdca58.png" style="max-height: 400px;"></div></td></tr></tbody></table>

**SpaceVim 功能模块：**

功能模块可以通过 `SPC t m m` 快捷键显示或者隐藏。默认使用 Unicode 字符，可通过设置 `statusline_unicode = false` 来启用 ASCII 字符。(或许在终端中无法设置合适的字体时，可使用这一选项)。

状态栏中功能模块内的字符显示与否，同如下快捷键功能保持一致：

<table><thead><tr><th>快捷键</th><th>Unicode</th><th>ASCII</th><th>功能</th></tr></thead><tbody><tr><td><code>SPC t 8</code></td><td>⑧</td><td>8</td><td>高亮指定列后所有字符</td></tr><tr><td><code>SPC t f</code></td><td>ⓕ</td><td>f</td><td>高亮指定列字符</td></tr><tr><td><code>SPC t s</code></td><td>ⓢ</td><td>s</td><td>语法检查</td></tr><tr><td><code>SPC t S</code></td><td>Ⓢ</td><td>S</td><td>拼写检查</td></tr><tr><td><code>SPC t w</code></td><td>ⓦ</td><td>w</td><td>行尾空格检查</td></tr></tbody></table>

**状态栏的颜色**

SpaceVim 默认为 [colorcheme 模块](https://spacevim.org/cn/layers/colorscheme/)所包含的主题颜色提供了状态栏主题，若需要使用其它颜色主题， 需要自行设置状态栏主题。若未设置，则使用 gruvbox 的主题。

可以参考以下模板来设置：

```
" the theme colors should be
" [
"    \ [ a_guifg,  a_guibg,  a_ctermfg,  a_ctermbg],
"    \ [ b_guifg,  b_guibg,  b_ctermfg,  b_ctermbg],
"    \ [ c_guifg,  c_guibg,  c_ctermfg,  c_ctermbg],
"    \ [ z_guibg,  z_ctermbg],
"    \ [ i_guifg,  i_guibg,  i_ctermfg,  i_ctermbg],
"    \ [ v_guifg,  v_guibg,  v_ctermfg,  v_ctermbg],
"    \ [ r_guifg,  r_guibg,  r_ctermfg,  r_ctermbg],
"    \ [ ii_guifg, ii_guibg, ii_ctermfg, ii_ctermbg],
"    \ [ in_guifg, in_guibg, in_ctermfg, in_ctermbg],
" \ ]
" group_a: window id
" group_b/group_c: stausline sections
" group_z: empty area
" group_i: window id in insert mode
" group_v: window id in visual mode
" group_r: window id in select mode
" group_ii: window id in iedit-insert mode
" group_in: windows id in iedit-normal mode
function! SpaceVim#mapping#guide#theme#gruvbox#palette() abort
    return [
                \ ['#282828', '#a89984', 246, 235],
                \ ['#a89984', '#504945', 239, 246],
                \ ['#a89984', '#3c3836', 237, 246],
                \ ['#665c54', 241],
                \ ['#282828', '#83a598', 235, 109],
                \ ['#282828', '#fe8019', 235, 208],
                \ ['#282828', '#8ec07c', 235, 108],
                \ ['#282828', '#689d6a', 235, 72],
                \ ['#282828', '#8f3f71', 235, 132],
                \ ]
endfunction


```

这一模板是 gruvbox 主题的，当你需要在切换主题时，状态栏都使用同一种颜色主题， 可以设置 `custom_color_palette`：

```
[options]
    custom_color_palette = [
        ["#282828", "#a89984", 246, 235],
        ["#a89984", "#504945", 239, 246],
        ["#a89984", "#3c3836", 237, 246],
        ["#665c54", 241],
        ["#282828", "#83a598", 235, 109],
        ["#282828", "#fe8019", 235, 208],
        ["#282828", "#8ec07c", 235, 108],
        ["#282828", "#689d6a", 235, 72],
        ["#282828", "#8f3f71", 235, 132],
    ]


```

**自定义板块**

可以使用启动函数添加自定板块，比如：

```
function! s:test_section() abort
  return 'ok'
endfunction
call SpaceVim#layers#core#statusline#register_sections('test', function('s:test_section'))


```

之后就可以在配置文件中添加 `test` 板块，比如，在状态栏右侧最后添加：

```
[options]
    statusline_right_sections = ['cursorpos', 'percentage', 'test']


```

### 标签栏

如果只有一个 Tab, Buffers 将被罗列在标签栏上，每一个包含：序号、文件类型图标、文件名。如果有不止一个 Tab, 那么所有 Tab 将被罗列在标签栏上。标签栏上每一个 Tab 或者 Buffer 可通过快捷键 `<Leader> number` 进行快速访问，默认的 `<Leader>` 是 `\`。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>&lt;Leader&gt; 1</code></td><td>跳至标签栏序号 1</td></tr><tr><td><code>&lt;Leader&gt; 2</code></td><td>跳至标签栏序号 2</td></tr><tr><td><code>&lt;Leader&gt; 3</code></td><td>跳至标签栏序号 3</td></tr><tr><td><code>&lt;Leader&gt; 4</code></td><td>跳至标签栏序号 4</td></tr><tr><td><code>&lt;Leader&gt; 5</code></td><td>跳至标签栏序号 5</td></tr><tr><td><code>&lt;Leader&gt; 6</code></td><td>跳至标签栏序号 6</td></tr><tr><td><code>&lt;Leader&gt; 7</code></td><td>跳至标签栏序号 7</td></tr><tr><td><code>&lt;Leader&gt; 8</code></td><td>跳至标签栏序号 8</td></tr><tr><td><code>&lt;Leader&gt; 9</code></td><td>跳至标签栏序号 9</td></tr><tr><td><code>g r</code></td><td>跳至前一个 Tab，常用于两个 Tab 来回切换</td></tr></tbody></table>

**注意:** 两个缓冲区来回切换的快捷键是 `SPC Tab`， 可阅读[缓冲区管理](#缓冲区管理)部分内容，了解更多缓冲区相关的快捷键。

标签栏上也支持鼠标操作，左键可以快速切换至该标签，中键删除该标签。该特性只支持 Neovim，并且需要 `has('tablineat')` 特性。

**注意:** 这一特性仅限于 Neovim 并且 `has('tablineat')` 返回 `true`。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>&lt;Mouse-left&gt;</code></td><td>切换至该标签</td></tr><tr><td><code>&lt;Mouse-middle&gt;</code></td><td>删除该标签</td></tr></tbody></table>

**标签管理器**

可使用 `SPC t t` 打开内置的标签管理器，标签管理器内的快捷键如下：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>o</code></td><td>展开或关闭标签目录</td></tr><tr><td><code>r</code></td><td>重命名光标下的标签页</td></tr><tr><td><code>n</code></td><td>在光标位置下新建命名标签页</td></tr><tr><td><code>N</code></td><td>在光标位置下新建匿名标签页</td></tr><tr><td><code>x</code></td><td>删除光标下的标签页</td></tr><tr><td><code>Ctrl-S-&lt;Up&gt;</code></td><td>向上移动光标下的标签页</td></tr><tr><td><code>Ctrl-S-&lt;Down&gt;</code></td><td>向下移动光标下的标签页</td></tr><tr><td><code>&lt;Enter&gt;</code></td><td>跳至光标所对应的标签窗口</td></tr></tbody></table>

### 文件树

SpaceVim 使用 nerdtree 作为默认的文件树插件，默认的快捷键是 `F3`, SpaceVim 也提供了另外一组快捷键 `SPC f t` 和 `SPC f T` 来打开文件树。 如果需要修改默认文件树插件，需要在 `~/.SpaceVim.d/init.toml` 的 `[options]` 片段中修改选项 `filemanager`：

```
[options]
    # 文件树插件可选值包括：
    # - nerdtree （默认）
    # - vimfiler: 需要编译 vimproc.vim, 在目录 bundle/vimproc.vim 下
    # - defx: 需要 +py3 支持
    filemanager = "nerdtree"


```

SpaceVim 的文件树提供了版本控制信息的接口，但是这一特性需要分析文件夹内容， 会使得文件树插件比较慢，因此默认没有打开，如果需要使用这一特性， 可向配置文件中加入 `enable_filetree_gitstatus = true`，启用后的截图如下：

![](<assets/1680076222156.png>)

默认情况下文件树是打开的，如果需要设置文件树默认关闭，需要修改 `enable_vimfiler_welcome` 选项。

```
[options]
    enable_vimfiler_welcome = false


```

默认情况下文件树是在窗口的右边打开，如果需要设置文件树默认在左边，需要修改 `filetree_direction` 选项。 需要注意的是，当设置文件树在左边时，函数列表 tagbar 将会在右边。

```
[options]
    filetree_direction = "left"


```

#### 文件树中的常用操作

文件树中主要以 `hjkl` 为核心，这类似于 [vifm](https://github.com/vifm) 中常用的快捷键：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>&lt;F3&gt;</code> / <code>SPC f t</code></td><td>切换文件树</td></tr><tr><td><strong>文件树内的快捷键</strong></td><td>&nbsp;</td></tr><tr><td><code>&lt;Left&gt;</code> / <code>h</code></td><td>移至父目录，并关闭文件夹</td></tr><tr><td><code>&lt;Down&gt;</code> / <code>j</code></td><td>向下移动光标</td></tr><tr><td><code>&lt;Up&gt;</code> / <code>k</code></td><td>向上移动光标</td></tr><tr><td><code>&lt;Right&gt;</code> / <code>l</code></td><td>展开目录，或打开文件</td></tr><tr><td><code>&lt;Enter&gt;</code></td><td>切换目录，或打开文件</td></tr><tr><td><code>N</code></td><td>在光标位置新建文件</td></tr><tr><td><code>y y</code></td><td>复制光标下文件路径至系统剪切板</td></tr><tr><td><code>y Y</code></td><td>复制光标下文件至系统剪切板</td></tr><tr><td><code>P</code></td><td>在光标位置黏贴文件</td></tr><tr><td><code>.</code></td><td>切换显示隐藏文件</td></tr><tr><td><code>s v</code></td><td>分屏编辑该文件</td></tr><tr><td><code>s g</code></td><td>垂直分屏编辑该文件</td></tr><tr><td><code>p</code></td><td>预览文件</td></tr><tr><td><code>i</code></td><td>切换至文件夹历史</td></tr><tr><td><code>v</code></td><td>快速查看</td></tr><tr><td><code>&gt;</code></td><td>放大文件树窗口宽度</td></tr><tr><td><code>&lt;</code></td><td>缩小文件树窗口宽度</td></tr><tr><td><code>g x</code></td><td>使用相关程序执行该文件</td></tr><tr><td><code>'</code></td><td>标记光标下的文件（夹）</td></tr><tr><td><code>V</code></td><td>清除所有标记</td></tr><tr><td><code>Ctrl</code>+<code>r</code></td><td>刷新页面</td></tr></tbody></table>

#### 文件树中打开文件

如果只有一个可编辑窗口，则在该窗口中打开选择的文件，否则则需要指定窗口来打开文件：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>l</code> / <code>&lt;Enter&gt;</code></td><td>打开文件</td></tr><tr><td><code>sg</code></td><td>分屏打开文件</td></tr><tr><td><code>sv</code></td><td>垂直分屏打开文件</td></tr></tbody></table>

#### 修改文件树默认快捷键

如果想要修改文件树内的默认快捷键，需要再启动函数里面调用用户自定义的自动命令，比如：

```
function! myspacevim#before() abort
    autocmd User NerdTreeInit
        \ nnoremap <silent><buffer> <CR> :<C-u>call
        \ g:NERDTreeKeyMap.Invoke('o')<CR>
endfunction


```

以下是不同文件时所对应的自动命令名称：

*   nerdtree: `User NerdTreeInit`
*   defx: `User DefxInit`
*   vimfiler: `User VimfilerInit`

## 基本操作

以下列出了最常用的移动光标以及滚屏的快捷键：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>h</code></td><td>向左移动光标</td></tr><tr><td><code>j</code></td><td>向下移动光标</td></tr><tr><td><code>k</code></td><td>向上移动光标</td></tr><tr><td><code>l</code></td><td>向右移动光标</td></tr><tr><td><code>&lt;Up&gt;</code></td><td>向上移动光标，不跳过折行</td></tr><tr><td><code>&lt;Down&gt;</code></td><td>向下移动光标，不跳过折行</td></tr><tr><td><code>H</code></td><td>移动光标至屏幕顶部</td></tr><tr><td><code>L</code></td><td>移动光标至屏幕底部</td></tr><tr><td><code>&lt;</code></td><td>向左移动文本</td></tr><tr><td><code>&gt;</code></td><td>向右移动文本</td></tr><tr><td><code>}</code></td><td>向前移动一个段落</td></tr><tr><td><code>{</code></td><td>向后移动一个段落</td></tr><tr><td><code>Ctrl-f</code> / <code>Shift-Down</code> / <code>&lt;PageDown&gt;</code></td><td>向下翻页</td></tr><tr><td><code>Ctrl-b</code> / <code>Shift-Up</code> / <code>&lt;PageUp&gt;</code></td><td>向上翻页</td></tr><tr><td><code>Ctrl-d</code></td><td>向下滚屏</td></tr><tr><td><code>Ctrl-u</code></td><td>向上滚屏</td></tr><tr><td><code>Ctrl-e</code></td><td>向下滚屏 (<code>3 Ctrl-e/j</code>)</td></tr><tr><td><code>Ctrl-y</code></td><td>向上滚屏 (<code>3Ctrl-y/k</code>)</td></tr><tr><td><code>Ctrl-Shift-Up</code></td><td>向上移动当前行</td></tr><tr><td><code>Ctrl-Shift-Down</code></td><td>向下移动当前行</td></tr></tbody></table>

### 原生功能

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>&lt;leader&gt; q r</code></td><td>原生 <code>q</code> 快捷键</td></tr><tr><td><code>&lt;leader&gt; q r/</code></td><td>原生 <code>q /</code> 快捷键，打开命令行窗口</td></tr><tr><td><code>&lt;leader&gt; q r?</code></td><td>原生 <code>q ?</code> 快捷键，打开命令行窗口</td></tr><tr><td><code>&lt;leader&gt; q r:</code></td><td>原生 <code>q :</code> 快捷键，打开命令行窗口</td></tr></tbody></table>

### 命令行模式快捷键

常规模式下按下 `:` 键后，可进入命令行模式，再次可以是下可以编辑 Vim 的命令并执行， 以下列出了命令行模式下一些常用的移动光标、删减字符的快捷键：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>Ctrl-a</code></td><td>移动光标至行首</td></tr><tr><td><code>Ctrl-b</code></td><td>向左移动光标</td></tr><tr><td><code>Ctrl-f</code></td><td>向右移动光标</td></tr><tr><td><code>Ctrl-w</code></td><td>删除光标前词</td></tr><tr><td><code>Ctrl-u</code></td><td>移除光标前所有字符</td></tr><tr><td><code>Ctrl-k</code></td><td>移除光标后所有字符</td></tr><tr><td><code>Ctrl-c</code>/<code>Esc</code></td><td>离开命令行模式</td></tr><tr><td><code>Tab</code></td><td>选择下一个匹配</td></tr><tr><td><code>Shift-Tab</code></td><td>选择上一个匹配</td></tr></tbody></table>

### 快捷键导航

当 Normal 模式下按下前缀键后出现输入延迟， 则会在屏幕下方打开一个快捷键导航窗口， 提示当前可用的快捷键及其功能描述， 目前支持的前缀键有：`[SPC]`、`[Window]`、`<Leader>`、`g`、`z`。

这些前缀的按键为：

<table><thead><tr><th>前缀名称</th><th>用户选项以及默认值</th><th>功能描述</th></tr></thead><tbody><tr><td><code>[SPC]</code></td><td>空格键</td><td>SpaceVim 默认前缀键</td></tr><tr><td><code>[Window]</code></td><td><code>windows_leader</code> / <code>s</code></td><td>SpaceVim 默认窗口前缀键</td></tr><tr><td><code>&lt;leader&gt;</code></td><td>默认的 Vim leader 键</td><td>Vim/Neovim 默认前缀键</td></tr></tbody></table>

默认的 `<Leader>` 键是 `\`, 如果需要修改 `<Leader>` 键则需要使用启动函数修改 `g:mapleader` 的值， 比如使用逗号 `,` 作为 `<Leader>` 按键。

```
function! myspacevim#before() abort
    let g:mapleader = ','
endfunction


```

**注意：** 在函数中修改 `g:mapleader` 的值，不可以省略前缀 `g:`， 因为函数中的变量默认作用域是 `l:`，这与 Vim 的帮助 `:h mapleader` 有些许不一样。

默认情况下，快捷键导航将在输入延迟超过 1000ms 后打开，你可以通过修改 Vim 的 `'timeoutlen'` 选项来修改成适合自己的延迟时间长度。

例如，Normal 模式下按下空格键，你将会看到：

![](<assets/1680076222406.png>)

这一导航窗口将提示所有以空格键为前缀的快捷键，并且根据功能将这些快捷键进行了分组，例如 buffer 相关的快捷键都是 `b`，工程相关的快捷键都是 `p`。在代码导航窗口内，按下 `Ctrl-h` 键，可以获取一些帮助信息，这些信息将被显示在状态栏上，提示的是一些翻页和撤销按键的快捷键。

<table><thead><tr><th>按键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>u</code></td><td>撤销按键</td></tr><tr><td><code>n</code></td><td>向下翻页</td></tr><tr><td><code>p</code></td><td>向上翻页</td></tr></tbody></table>

如果要自定义以 `[SPC]` 为前缀的快捷键，可以使用 `SpaceVim#custom#SPC()`，示例如下：

```
call SpaceVim#custom#SPC('nnoremap', ['f', 't'], 'echom "hello world"', 'test custom SPC', 1)


```

第一个参数设定快捷键的类型， 可以是 `nnoremap` 或者 `nmap`，第二个参数是一个按键列表， 第三个参数是一个 ex 命令或者按键，这基于最后一个参数是否为`true`。第四个参数是一个简短的描述。

**模糊搜索快捷键**

可以通过 `SPC ?` 将当前快捷键罗列出来。然后可以输入快捷键按键字母或者描述，可以模糊匹配并展示结果。

![](<assets/1680076222640.png>)

使用 `<Tab>` 键或者上下方向键选择你需要的快捷键，回车将执行这一快捷键。

### 基本编辑操作

#### 移动文本块

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>&lt;</code> / <code>Shift-Tab</code></td><td>向左移动文本</td></tr><tr><td><code>&gt;</code> / <code>Tab</code></td><td>向右移动文本</td></tr><tr><td><code>Ctrl-Shift-Up</code></td><td>向上移动选中行</td></tr><tr><td><code>Ctrl-Shift-Down</code></td><td>向下移动选中行</td></tr></tbody></table>

#### 代码缩进

默认的代码缩进值是 2，缩进的大小由选项 `default_indent` 设置， 如果希望使用 4 个空格作为缩进，只需要在 SpaceVim 配置文件中加入如下内容：

```
[options]
    default_indent = 4


```

`default_indent` 这一选项的值，将被赋值到 Vim 的选项：`&tabstop`、`&softtabstop` 和 `&shiftwidth`。默认情况下，输入的 `<Tab>` 会被自动展开成对应缩进数量的空格， 可通过设置选项 `expand_tab` 的值为 `false` 来禁用这一特性：

```
[options]
    default_indent = 4
    expand_tab = true


```

#### 文本操作命令

文本相关的命令 (以 `x` 开头)：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC x a #</code></td><td>基于分隔符 # 进行文本对齐</td></tr><tr><td><code>SPC x a %</code></td><td>基于分隔符 % 进行文本对齐</td></tr><tr><td><code>SPC x a &amp;</code></td><td>基于分隔符 &amp; 进行文本对齐</td></tr><tr><td><code>SPC x a (</code></td><td>基于分隔符 ( 进行文本对齐</td></tr><tr><td><code>SPC x a )</code></td><td>基于分隔符 ) 进行文本对齐</td></tr><tr><td><code>SPC x a [</code></td><td>基于分隔符 [ 进行文本对齐</td></tr><tr><td><code>SPC x a ]</code></td><td>基于分隔符 ] 进行文本对齐</td></tr><tr><td><code>SPC x a {</code></td><td>基于分隔符 { 进行文本对齐</td></tr><tr><td><code>SPC x a }</code></td><td>基于分隔符 } 进行文本对齐</td></tr><tr><td><code>SPC x a ,</code></td><td>基于分隔符 , 进行文本对齐</td></tr><tr><td><code>SPC x a .</code></td><td>基于分隔符 . 进行文本对齐 (for numeric tables)</td></tr><tr><td><code>SPC x a :</code></td><td>基于分隔符 : 进行文本对齐</td></tr><tr><td><code>SPC x a ;</code></td><td>基于分隔符 ; 进行文本对齐</td></tr><tr><td><code>SPC x a =</code></td><td>基于分隔符 = 进行文本对齐</td></tr><tr><td><code>SPC x a ¦</code></td><td>基于分隔符 ¦ 进行文本对齐</td></tr><tr><td><code>SPC x a &lt;bar&gt;</code></td><td>基于分隔符 | 进行文本对齐</td></tr><tr><td><code>SPC x a SPC</code></td><td>基于分隔符 <space>进行文本对齐</space></td></tr><tr><td><code>SPC x a a</code></td><td>align region (or guessed section) using default rules (TODO)</td></tr><tr><td><code>SPC x a c</code></td><td>align current indentation region using default rules (TODO)</td></tr><tr><td><code>SPC x a l</code></td><td>left-align with evil-lion (TODO)</td></tr><tr><td><code>SPC x a L</code></td><td>right-align with evil-lion (TODO)</td></tr><tr><td><code>SPC x a r</code></td><td>基于用户自定义正则表达式进行文本对齐</td></tr><tr><td><code>SPC x a o</code></td><td>对齐算术运算符 <code>+-*/</code></td></tr><tr><td><code>SPC x c</code></td><td>统计选中区域的字符 / 单词 / 行数</td></tr><tr><td><code>SPC x d w</code></td><td>删除行尾空白字符</td></tr><tr><td><code>SPC x d SPC</code></td><td>Delete all spaces and tabs around point, leaving one space</td></tr><tr><td><code>SPC x g l</code></td><td>set lanuages used by translate commands (TODO)</td></tr><tr><td><code>SPC x g t</code></td><td>使用 Google Translate 翻译当前单词</td></tr><tr><td><code>SPC x g T</code></td><td>reverse source and target languages (TODO)</td></tr><tr><td><code>SPC x i c</code></td><td>change symbol style to <code>lowerCamelCase</code></td></tr><tr><td><code>SPC x i C</code></td><td>change symbol style to <code>UpperCamelCase</code></td></tr><tr><td><code>SPC x i i</code></td><td>cycle symbol naming styles (i to keep cycling)</td></tr><tr><td><code>SPC x i -</code></td><td>change symbol style to <code>kebab-case</code></td></tr><tr><td><code>SPC x i k</code></td><td>change symbol style to <code>kebab-case</code></td></tr><tr><td><code>SPC x i _</code></td><td>change symbol style to <code>under_score</code></td></tr><tr><td><code>SPC x i u</code></td><td>change symbol style to <code>under_score</code></td></tr><tr><td><code>SPC x i U</code></td><td>change symbol style to <code>UP_CASE</code></td></tr><tr><td><code>SPC x j c</code></td><td>居中对齐当前段落</td></tr><tr><td><code>SPC x j f</code></td><td>set the justification to full (TODO)</td></tr><tr><td><code>SPC x j l</code></td><td>左对齐当前段落</td></tr><tr><td><code>SPC x j n</code></td><td>set the justification to none (TODO)</td></tr><tr><td><code>SPC x j r</code></td><td>右对齐当前段落</td></tr><tr><td><code>SPC x J</code></td><td>将当前行向下移动一行并进入临时快捷键状态</td></tr><tr><td><code>SPC x K</code></td><td>将当前行向上移动一行并进入临时快捷键状态</td></tr><tr><td><code>SPC x l d</code></td><td>重复当前行或区域</td></tr><tr><td><code>SPC x l r</code></td><td>逆序化多行文档</td></tr><tr><td><code>SPC x l s</code></td><td>排序多行文档 (忽略大小写)</td></tr><tr><td><code>SPC x l S</code></td><td>排序多行文档 (大小写敏感)</td></tr><tr><td><code>SPC x l u</code></td><td>去除重复的行 (忽略大小写)</td></tr><tr><td><code>SPC x l U</code></td><td>去除重复的行 (大小写敏感)</td></tr><tr><td><code>SPC x o</code></td><td>use avy to select a link in the frame and open it (TODO)</td></tr><tr><td><code>SPC x O</code></td><td>use avy to select multiple links in the frame and open them (TODO)</td></tr><tr><td><code>SPC x t c</code></td><td>交换当前字符和前一个字符的位置</td></tr><tr><td><code>SPC x t C</code></td><td>交换当前字符和后一个字符的位置</td></tr><tr><td><code>SPC x t w</code></td><td>交换当前单词和前一个单词的位置</td></tr><tr><td><code>SPC x t W</code></td><td>交换当前单词和后一个单词的位置</td></tr><tr><td><code>SPC x t l</code></td><td>交换当前行和前一行的位置</td></tr><tr><td><code>SPC x t L</code></td><td>交换当前行和后一行的位置</td></tr><tr><td><code>SPC x u</code></td><td>将字符转为小写</td></tr><tr><td><code>SPC x U</code></td><td>将字符转为大写</td></tr><tr><td><code>SPC x ~</code></td><td>切换字符的大小写</td></tr><tr><td><code>SPC x w c</code></td><td>统计选中区域的单词数</td></tr><tr><td><code>SPC x w d</code></td><td>show dictionary entry of word from wordnik.com (TODO)</td></tr><tr><td><code>SPC x &lt;Tab&gt;</code></td><td>indent or dedent a region rigidly (TODO)</td></tr></tbody></table>

#### 文本插入命令

文本插入相关命令（以 `i` 开头）：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC i l l</code></td><td>insert lorem-ipsum list</td></tr><tr><td><code>SPC i l p</code></td><td>insert lorem-ipsum paragraph</td></tr><tr><td><code>SPC i l s</code></td><td>insert lorem-ipsum sentence</td></tr><tr><td><code>SPC i p 1</code></td><td>insert simple password</td></tr><tr><td><code>SPC i p 2</code></td><td>insert stronger password</td></tr><tr><td><code>SPC i p 3</code></td><td>insert password for paranoids</td></tr><tr><td><code>SPC i p p</code></td><td>insert a phonetically easy password</td></tr><tr><td><code>SPC i p n</code></td><td>insert a numerical password</td></tr><tr><td><code>SPC i u</code></td><td>Search for Unicode characters and insert them into the active buffer.</td></tr><tr><td><code>SPC i U 1</code></td><td>insert UUIDv1 (use universal argument to insert with CID format)</td></tr><tr><td><code>SPC i U 4</code></td><td>insert UUIDv4 (use universal argument to insert with CID format)</td></tr><tr><td><code>SPC i U U</code></td><td>insert UUIDv4 (use universal argument to insert with CID format)</td></tr></tbody></table>

**提示：** 您可以使用前缀参数指定密码字符的数量，（例如，`10 SPC i p 1` 将生成 `10` 个简单密码字符）

#### 增加或减小数字

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC n +</code></td><td>为光标下的数字加 1 并进入 临时快捷键状态</td></tr><tr><td><code>SPC n -</code></td><td>为光标下的数字减 1 并进入 临时快捷键状态</td></tr></tbody></table>

在临时快捷键模式下：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>+</code></td><td>为光标下的数字加 1</td></tr><tr><td><code>-</code></td><td>为光标下的数字减 1</td></tr><tr><td>其它任意键</td><td>离开临时快捷键状态</td></tr></tbody></table>

**提示：** 如果你想为光标下的数字所增加的值大于 `1`，你可以使用前缀参数。例如：`10 SPC n +` 将为光标下的数字加 `10`。

#### 复制粘贴

如果 `has('unnamedplus')` 返回 `1`，那么快捷键 `<Leader> y` 使用的寄存器是 `+`， 否则，这个快捷键使用的寄存器是 `*`， 可以阅读 `:h registers` 获取更多关于寄存器相关的内容。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>&lt;Leader&gt; y</code></td><td>复制已选中的文本至系统剪切板</td></tr><tr><td><code>&lt;Leader&gt; p</code></td><td>粘贴系统剪切板文字至当前位置之后</td></tr><tr><td><code>&lt;Leader&gt; P</code></td><td>粘贴系统剪切板文字至当前位置之前</td></tr><tr><td><code>&lt;Leader&gt; Y</code></td><td>复制已选中的文本至 pastebin</td></tr></tbody></table>

快捷键 `<Leader> Y` 将把选中的文本复制到 pastebin 服务器，并且将返回的链接复制到系统剪切板。 使用该功能，需要系统里有 `curl` 可执行程序（Windows 系统下，Neovim 自带 `curl`）。

按下快捷键 `<Leader> Y` 后，实际执行的命令为：

```
curl -s -F "content=<-" http://dpaste.com/api/v2/


```

该命令将读取标准输入（`stdin`），并且把输入的内容复制到 dpaste 服务器，等同于：

```
echo "selected text" | curl -s -F "content=<-" http://dpaste.com/api/v2/


```

#### 增删注释

注释的增删是通过插件 [nerdcommenter](https://github.com/preservim/nerdcommenter) 来实现的， 以下为注释相关的常用快捷键：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC ;</code></td><td>进入注释操作模式</td></tr><tr><td><code>SPC c h</code></td><td>隐藏 / 显示注释</td></tr><tr><td><code>SPC c l</code></td><td>注释 / 反注释当前行</td></tr><tr><td><code>SPC c L</code></td><td>注释行</td></tr><tr><td><code>SPC c u</code></td><td>反注释行</td></tr><tr><td><code>SPC c p</code></td><td>注释 / 反注释段落</td></tr><tr><td><code>SPC c P</code></td><td>注释段落</td></tr><tr><td><code>SPC c s</code></td><td>使用完美格式注释</td></tr><tr><td><code>SPC c t</code></td><td>注释 / 反注释到行</td></tr><tr><td><code>SPC c T</code></td><td>注释到行</td></tr><tr><td><code>SPC c y</code></td><td>注释 / 反注释同时复制</td></tr><tr><td><code>SPC c Y</code></td><td>复制到未命名寄存器后注释</td></tr><tr><td><code>SPC c $</code></td><td>从光标位置开始注释当前行</td></tr></tbody></table>

小提示：

用 `SPC ;` 可以启动一个注释操作符模式，在该模式下，可以使用移动命令确认注释的范围， 比如 `SPC ; 4 j`，这个组合键会注释当前行以及下方的 4 行。这个数字即为相对行号，可在左侧看到。

#### 编辑历史

当前文件的编辑历史，可以使用快捷键 `F7` 查看，默认会在左侧打开一个编辑历史可视化窗口。 若当前编辑器支持 `+python` 或者 `+python3`，则会使用 mundo 作为默认插件，否则则使用 undotree。

在编辑历史窗口内的快捷键如下：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>G</code></td><td>move_bottom</td></tr><tr><td><code>J</code></td><td>move_older_write</td></tr><tr><td><code>K</code></td><td>move_newer_write</td></tr><tr><td><code>N</code></td><td>previous_match</td></tr><tr><td><code>P</code></td><td>play_to</td></tr><tr><td><code>&lt;2-LeftMouse&gt;</code></td><td>mouse_click</td></tr><tr><td><code>/</code></td><td>search</td></tr><tr><td><code>&lt;CR&gt;</code></td><td>preview</td></tr><tr><td><code>d</code></td><td>diff</td></tr><tr><td><code>&lt;down&gt;</code></td><td>move_older</td></tr><tr><td><code>&lt;up&gt;</code></td><td>move_newer</td></tr><tr><td><code>i</code></td><td>toggle_inline</td></tr><tr><td><code>j</code></td><td>move_older</td></tr><tr><td><code>k</code></td><td>move_newer</td></tr><tr><td><code>n</code></td><td>next_match</td></tr><tr><td><code>o</code></td><td>preview</td></tr><tr><td><code>p</code></td><td>diff_current_buffer</td></tr><tr><td><code>q</code></td><td>quit</td></tr><tr><td><code>r</code></td><td>diff</td></tr><tr><td><code>gg</code></td><td>move_top</td></tr><tr><td><code>?</code></td><td>toggle_help</td></tr></tbody></table>

#### 文本编码格式

SpaceVim 默认使用 `utf-8` 码进行编码。下面是 `utf-8` 编码的四个设置：

*   fileencodings (fencs) : ucs-bom, utf-8, default, latin1
*   fileencoding (fenc) : utf-8
*   encoding (enc) : utf-8
*   termencoding (tenc) : utf-8 (only supported in Vim)

修复混乱的显示：`SPC e a` 是自动选择文件编码的按键映射。在选择好文件编码方式后，你可以运行下面的代码来修复编码：

### 窗口管理

常用的窗口管理快捷键有一个统一的前缀，默认的前缀 `[Window]` 是按键 `s`，可以在配置文件中通过修改 SpaceVim 选项 `window_leader` 的值来设为其它按键：

```
[options]
    windows_leader = "s"


```

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>q</code></td><td>智能关闭当前窗口</td></tr><tr><td><code>[Window] v</code></td><td>水平分屏</td></tr><tr><td><code>[Window] V</code></td><td>水平分屏，并编辑上一个文件</td></tr><tr><td><code>[Window] g</code></td><td>垂直分屏</td></tr><tr><td><code>[Window] G</code></td><td>垂直分屏，并编辑上一个文件</td></tr><tr><td><code>[Window] t</code></td><td>新建新的标签页</td></tr><tr><td><code>[Window] o</code></td><td>关闭其他窗口</td></tr><tr><td><code>[Window] x</code></td><td>关闭当前缓冲区，并保留新的空白缓冲区</td></tr><tr><td><code>[Window] q</code></td><td>关闭当前缓冲区</td></tr><tr><td><code>[Window] Q</code></td><td>关闭当前窗口</td></tr><tr><td><code>Shift-&lt;Tab&gt;</code></td><td>切换至前一窗口</td></tr></tbody></table>

常规模式下的按键 `q` 被用来快速关闭窗口，其原生的功能可以使用 `<Leader> q r` 来代替。

#### 常用编辑器窗口

<table><thead><tr><th>按键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>&lt;F2&gt;</code></td><td>打开、关闭语法树</td></tr><tr><td><code>&lt;F3&gt;</code></td><td>打开、关闭文件树</td></tr><tr><td><code>Ctrl-&lt;Down&gt;</code></td><td>切换至下方窗口</td></tr><tr><td><code>Ctrl-&lt;Up&gt;</code></td><td>切换至上方窗口</td></tr><tr><td><code>Ctrl-&lt;Left&gt;</code></td><td>切换至左边窗口</td></tr><tr><td><code>Ctrl-&lt;Right&gt;</code></td><td>切换至右边窗口</td></tr></tbody></table>

#### 窗口操作常用快捷键

每一个窗口都有一个编号，该编号显示在状态栏的最前端，可通过 `SPC 编号` 进行快速窗口跳转。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC 1</code></td><td>跳至窗口 1</td></tr><tr><td><code>SPC 2</code></td><td>跳至窗口 2</td></tr><tr><td><code>SPC 3</code></td><td>跳至窗口 3</td></tr><tr><td><code>SPC 4</code></td><td>跳至窗口 4</td></tr><tr><td><code>SPC 5</code></td><td>跳至窗口 5</td></tr><tr><td><code>SPC 6</code></td><td>跳至窗口 6</td></tr><tr><td><code>SPC 7</code></td><td>跳至窗口 7</td></tr><tr><td><code>SPC 8</code></td><td>跳至窗口 8</td></tr><tr><td><code>SPC 9</code></td><td>跳至窗口 9</td></tr></tbody></table>

窗口操作相关快捷键（以 `SPC w` 为前缀)：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC w .</code></td><td>启用窗口临时快捷键</td></tr><tr><td><code>SPC w &lt;Tab&gt;</code></td><td>在同一标签内进行窗口切换</td></tr><tr><td><code>SPC w =</code></td><td>对齐分离的窗口</td></tr><tr><td><code>SPC w c</code></td><td>进入阅读模式，浏览当前窗口 (需要 tools 模块)</td></tr><tr><td><code>SPC w C</code></td><td>选择某一个窗口，并且进入阅读模式 (需要 tools 模块)</td></tr><tr><td><code>SPC w d</code></td><td>删除一个窗口</td></tr><tr><td><code>SPC w D</code></td><td>选择一个窗口并关闭</td></tr><tr><td><code>SPC w f</code></td><td>切换同步滚屏</td></tr><tr><td><code>SPC w F</code></td><td>新建一个新的标签页</td></tr><tr><td><code>SPC w h</code></td><td>移至左边窗口</td></tr><tr><td><code>SPC w H</code></td><td>将窗口向左移动</td></tr><tr><td><code>SPC w j</code></td><td>移至下方窗口</td></tr><tr><td><code>SPC w J</code></td><td>将窗口向下移动</td></tr><tr><td><code>SPC w k</code></td><td>移至上方窗口</td></tr><tr><td><code>SPC w K</code></td><td>将窗口向上移动</td></tr><tr><td><code>SPC w l</code></td><td>移至右方窗口</td></tr><tr><td><code>SPC w L</code></td><td>将窗口向右移动</td></tr><tr><td><code>SPC w m</code></td><td>最大化 / 最小化窗口（最大化相当于关闭其它窗口）</td></tr><tr><td><code>SPC w M</code></td><td>选择窗口进行替换</td></tr><tr><td><code>SPC w o</code></td><td>按序切换标签页</td></tr><tr><td><code>SPC w p m</code></td><td>使用弹窗打开消息</td></tr><tr><td><code>SPC w p p</code></td><td>关闭当前弹窗窗口</td></tr><tr><td><code>SPC w r</code></td><td>顺序切换窗口</td></tr><tr><td><code>SPC w R</code></td><td>逆序切换窗口</td></tr><tr><td><code>SPC w s/-</code></td><td>水平分割窗口</td></tr><tr><td><code>SPC w S</code></td><td>水平分割窗口，并切换至新窗口</td></tr><tr><td><code>SPC w u</code></td><td>恢复窗口布局</td></tr><tr><td><code>SPC w U</code></td><td>撤销恢复窗口布局</td></tr><tr><td><code>SPC w v//</code></td><td>垂直分离窗口</td></tr><tr><td><code>SPC w V</code></td><td>垂直分离窗口，并切换至新窗口</td></tr><tr><td><code>SPC w w</code></td><td>切换至前一窗口</td></tr><tr><td><code>SPC w W</code></td><td>选择一个窗口</td></tr><tr><td><code>SPC w x</code></td><td>切换窗口文件</td></tr></tbody></table>

### 缓冲区管理

#### 缓冲区操作

缓冲区（Buffer）操作相关快捷键都是以 `SPC b` 为前缀的，以下为常用的缓冲区操作快捷键， 主要包括了缓冲区的切换和删除等操作：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC &lt;Tab&gt;</code></td><td>切换至前一缓冲区，常用于两个缓冲区来回切换</td></tr><tr><td><code>SPC b .</code></td><td>启用缓冲区临时快捷键</td></tr><tr><td><code>SPC b b</code></td><td>通过模糊搜索工具进行缓冲区切换，需要启用一个模糊搜索工具模块</td></tr><tr><td><code>SPC b d</code></td><td>删除当前缓冲区，但保留编辑窗口</td></tr><tr><td><code>SPC u SPC b d</code></td><td>kill the current buffer and window (does not delete the visited file) (TODO)</td></tr><tr><td><code>SPC b D</code></td><td>选择一个窗口，并删除其缓冲区</td></tr><tr><td><code>SPC u SPC b D</code></td><td>kill a visible buffer and its window using ace-window(TODO)</td></tr><tr><td><code>SPC b c</code></td><td>删除其它已保存的缓冲区</td></tr><tr><td><code>SPC b Ctrl-d</code></td><td>删除其它所有缓冲区</td></tr><tr><td><code>SPC b Ctrl-Shift-d</code></td><td>删除名称匹配指定正则表达式的缓冲区</td></tr><tr><td><code>SPC b e</code></td><td>清除当前缓冲区内容，需要手动确认</td></tr><tr><td><code>SPC b h</code></td><td>打开欢迎界面, 等同于快捷键 <code>SPC a s</code></td></tr><tr><td><code>SPC b n</code></td><td>切换至下一个缓冲区，排除特殊插件的缓冲区</td></tr><tr><td><code>SPC b m</code></td><td>打开消息缓冲区</td></tr><tr><td><code>SPC b o</code></td><td>关闭所有窗口和已保存的缓冲区</td></tr><tr><td><code>SPC b p</code></td><td>切换至前一个缓冲区，排除特殊插件的缓冲区</td></tr><tr><td><code>SPC b P</code></td><td>使用系统剪切板内容替换当前缓冲区</td></tr><tr><td><code>SPC b R</code></td><td>从磁盘重新读取当前缓冲区所对应的文件</td></tr><tr><td><code>SPC b s</code></td><td>switch to the <em>scratch</em> buffer (create it if needed) (TODO)</td></tr><tr><td><code>SPC b w</code></td><td>切换只读权限</td></tr><tr><td><code>SPC b Y</code></td><td>将整个缓冲区复制到系统剪切板</td></tr><tr><td><code>z f</code></td><td>Make current function or comments visible in buffer as much as possible (TODO)</td></tr></tbody></table>

#### 新建空白 buffer

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC b N h</code></td><td>在左侧新建一个窗口，并在其中新建空白 buffer</td></tr><tr><td><code>SPC b N j</code></td><td>在下方新建一个窗口，并在其中新建空白 buffer</td></tr><tr><td><code>SPC b N k</code></td><td>在上方新建一个窗口，并在其中新建空白 buffer</td></tr><tr><td><code>SPC b N l</code></td><td>在右侧新建一个窗口，并在其中新建空白 buffer</td></tr><tr><td><code>SPC b N n</code></td><td>在当前窗口新建一个空白 buffer</td></tr></tbody></table>

#### 特殊 buffer

在 SpaceVim 中，有很多特殊的 buffer，这些 buffer 是由插件或者 SpaceVim 自身建立的，并不会被列出。

#### 文件操作相关快捷键

文件操作相关的快捷键都是以 `SPC f` 为前缀的：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC f /</code></td><td>使用 <code>find</code> 或者 <code>fd</code> 命令查找文件，支持参数提示</td></tr><tr><td><code>SPC f b</code></td><td>跳至文件书签</td></tr><tr><td><code>SPC f c</code></td><td>copy current file to a different location(TODO)</td></tr><tr><td><code>SPC f C d</code></td><td>修改文件编码 unix -&gt; dos</td></tr><tr><td><code>SPC f C u</code></td><td>修改文件编码 dos -&gt; unix</td></tr><tr><td><code>SPC f D</code></td><td>删除文件以及 buffer，需要手动确认</td></tr><tr><td><code>SPC f E</code></td><td>open a file with elevated privileges (sudo edit)(TODO)</td></tr><tr><td><code>SPC f f</code></td><td>在当前文件所在文件夹搜索文件</td></tr><tr><td><code>SPC f F</code></td><td>在当前文件所在的文件夹搜索光标下的文件</td></tr><tr><td><code>SPC f o</code></td><td>打开文件树，并定位到当前文件</td></tr><tr><td><code>SPC f R</code></td><td>重命名当前文件</td></tr><tr><td><code>SPC f s</code> / <code>Ctrl-s</code></td><td>保存文件 (:w)</td></tr><tr><td><code>SPC f a</code></td><td>另存为新的文件</td></tr><tr><td><code>SPC f W</code></td><td>使用管理员模式保存</td></tr><tr><td><code>SPC f S</code></td><td>保存所有文件</td></tr><tr><td><code>SPC f r</code></td><td>打开文件历史</td></tr><tr><td><code>SPC f t</code></td><td>切换侧栏文件树</td></tr><tr><td><code>SPC f T</code></td><td>打开文件树侧栏</td></tr><tr><td><code>SPC f d</code></td><td>Windows 下显示 / 隐藏磁盘管理器</td></tr><tr><td><code>SPC f y</code></td><td>复制并显示当前文件的绝对路径</td></tr><tr><td><code>SPC f Y</code></td><td>复制并显示当前文件的远程路径</td></tr></tbody></table>

**注意：** 如果你使用的是 Window 系统，那么你需要额外 [findutils](https://www.gnu.org/software/findutils/) 或者 [fd](https://github.com/sharkdp/fd)。 如果是使用 [scoop](https://github.com/lukesampson/scoop) 安装的这些工具，系统默认的 `C:\WINDOWS\system32` 中的命令会覆盖掉用户定义的 `$PATH`， 解决方案是将 scoop 默认的可执行文件所在的文件夹放置在系统环境变量 `$PATH` 内 `C:\WINDOWS\system32` 的前方。

按下 `SPC f /` 快捷键之后，会弹出搜索输入窗口，输入内容后回车，异步执行 `find` 或者 `fd` 命令， 默认使用的是 `find` 命令，可以使用快捷键 `ctrl-e` 在不同工具之间切换。

![](<assets/1680076222881.png>)

#### Vim 和 SpaceVim 相关文件

SpaceVim 相关的快捷键均以 `SPC f v` 为前缀，这便于快速访问 SpaceVim 的配置文件：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC f v v</code></td><td>复制并显示当前 SpaceVim 的版本</td></tr><tr><td><code>SPC f v d</code></td><td>打开 SpaceVim 的用户配置文件</td></tr></tbody></table>

### 模块管理

所有可用模块可以通过命令 `:SPLayer -l` 或者快捷键 `SPC h l` 来展示。

**可用的插件**

可通过快捷键 `<Leader> f p` 列出所有已安装的插件，支持模糊搜索，回车将使用浏览器打开该插件的官网。

### 模糊搜索

目前一共有五种模糊搜索的模块，分别对应不同的工具：

*   denite
*   unite
*   leaderf
*   ctrlp
*   fzf

这些模块都提供了非常类似的快捷键，包括文件搜索、跳转历史搜索等功能， 具体快捷键列表如下：

**快捷键**

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>&lt;Leader&gt; f &lt;Space&gt;</code></td><td>模糊查找快捷键，并执行该快捷键</td></tr><tr><td><code>&lt;Leader&gt; f e</code></td><td>模糊搜索寄存器</td></tr><tr><td><code>&lt;Leader&gt; f h</code></td><td>模糊搜索 history/yank</td></tr><tr><td><code>&lt;Leader&gt; f j</code></td><td>模糊搜索 jump, change</td></tr><tr><td><code>&lt;Leader&gt; f l</code></td><td>模糊搜索 location list</td></tr><tr><td><code>&lt;Leader&gt; f m</code></td><td>模糊搜索 output messages</td></tr><tr><td><code>&lt;Leader&gt; f o</code></td><td>模糊搜索函数列表</td></tr><tr><td><code>&lt;Leader&gt; f q</code></td><td>模糊搜索 quickfix list</td></tr><tr><td><code>&lt;Leader&gt; f r</code></td><td>重置上次搜索窗口</td></tr></tbody></table>

但是由于不同工具的局限性，有些模块还不能完全提供上述功能，目前仅有 denite 和 unite 模块可以提供完整的功能。

<table><thead><tr><th>功能特性</th><th>unite</th><th>denite</th><th>leaderf</th><th>ctrlp</th><th>fzf</th></tr></thead><tbody><tr><td>模糊查找快捷键，并执行该快捷键</td><td>yes</td><td>yes</td><td>no</td><td>no</td><td>no</td></tr><tr><td>模块搜索寄存器</td><td>yes</td><td>yes</td><td>no</td><td>yes</td><td>yes</td></tr><tr><td>模糊搜索文件</td><td>yes</td><td>yes</td><td>yes</td><td>yes</td><td>yes</td></tr><tr><td>模糊搜索复制历史</td><td>yes</td><td>yes</td><td>no</td><td>no</td><td>yes</td></tr><tr><td>模糊搜索跳转历史</td><td>yes</td><td>yes</td><td>no</td><td>yes</td><td>yes</td></tr><tr><td>模糊搜索位置列表</td><td>yes</td><td>yes</td><td>no</td><td>no</td><td>yes</td></tr><tr><td>模糊搜索语法树</td><td>yes</td><td>yes</td><td>yes</td><td>yes</td><td>yes</td></tr><tr><td>模糊搜索消息</td><td>yes</td><td>yes</td><td>no</td><td>no</td><td>yes</td></tr><tr><td>模糊搜索全局位置列表</td><td>yes</td><td>yes</td><td>no</td><td>yes</td><td>yes</td></tr><tr><td>重置上次搜索窗口</td><td>yes</td><td>yes</td><td>no</td><td>no</td><td>no</td></tr></tbody></table>

**模糊搜索窗口内的快捷键：**

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>&lt;Tab&gt;</code> / <code>Ctrl-j</code></td><td>下一个选项</td></tr><tr><td><code>Shift-&lt;Tab&gt;</code> / <code>Ctrl-k</code></td><td>上一个选项</td></tr><tr><td><code>jk</code></td><td>离开输入模式（仅支持 denite 和 unite 模块）</td></tr><tr><td><code>Ctrl-w</code></td><td>删除光标前词语</td></tr><tr><td><code>&lt;Enter&gt;</code></td><td>执行默认动作</td></tr><tr><td><code>Ctrl-s</code></td><td>在分割窗口内打开</td></tr><tr><td><code>Ctrl-v</code></td><td>在垂直分割窗口内打开</td></tr><tr><td><code>Ctrl-t</code></td><td>在新的标签页里打开</td></tr><tr><td><code>Ctrl-g</code></td><td>推出模糊搜索插件</td></tr></tbody></table>

**Denite 或 Unite 模块可视模式下快捷键：**

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>Ctrl</code>+<code>h/k/l/r</code></td><td>未定义</td></tr><tr><td><code>Ctrl</code>+<code>l</code></td><td>刷新窗口</td></tr><tr><td><code>&lt;Tab&gt;</code></td><td>选择即将执行的动作</td></tr><tr><td><code>Space</code></td><td>切换标记当前选项</td></tr><tr><td><code>r</code></td><td>替换或者重命名</td></tr><tr><td><code>Ctrl</code>+<code>z</code></td><td>切换窗口分割方式</td></tr></tbody></table>

以上这些快捷键仅仅是模糊搜索模块的部分快捷键，其他快捷键信息可查阅对应模块文档。

#### 配置搜索工具

SpaceVim 像下面那样调用不同搜索工具的搜索接口：

*   [rg - ripgrep](https://github.com/BurntSushi/ripgrep)
*   [ag - the silver searcher](https://github.com/ggreer/the_silver_searcher)
*   [pt - the platinum searcher](https://github.com/monochromegane/the_platinum_searcher)
*   [ack](https://beyondgrep.com/)
*   grep

SpaceVim 中的搜索命令以 `SPC s` 为前缀，前一个键是使用的工具，后一个键是范围。 例如 `SPC s a b` 将使用 `ag` 在当前所有已经打开的缓冲区中进行搜索。

如果最后一个键（决定范围）是大写字母，那么就会对当前光标下的单词进行搜索。 举个例子 `SPC s a B` 将会搜索当前光标下的单词。

如果工具键被省略了，那么会用默认的搜索工具进行搜索。默认的搜索工具对应在 `search_tools` 列表中的第一个工具。列表中的工具默认的顺序为：`rg`, `ag`, `pt`, `ack`, `grep`。 举个例子：如果 `rg` 和 `ag` 没有在系统中找到，那么 `SPC s b` 会使用 `pt` 进行搜索。

下表是全部的工具键：

<table><thead><tr><th>工具</th><th>键</th></tr></thead><tbody><tr><td>ag</td><td>a</td></tr><tr><td>grep</td><td>g</td></tr><tr><td>git grep</td><td>G</td></tr><tr><td>ack</td><td>k</td></tr><tr><td>rg</td><td>r</td></tr><tr><td>pt</td><td>t</td></tr></tbody></table>

应当避免的范围和对应按键为：

<table><thead><tr><th>范围</th><th>键</th></tr></thead><tbody><tr><td>打开的缓冲区</td><td>b</td></tr><tr><td>给定目录的文件</td><td>f</td></tr><tr><td>当前工程</td><td>p</td></tr></tbody></table>

可以双击按键序列中的第二个键来在当前文件中进行搜索。举个例子：`SPC s a a` 会使用 `ag` 在当前文件中进行搜索。

注意：

*   如果使用源代码管理的话 `rg`, `ag` 和 `pt` 都会被忽略掉，但是他们可以在任意目录中正常运行。
*   也可以通过将它们标记在联合缓冲区来一次搜索多个目录。 **注意** 如果你使用 `pt`, [TCL parser tools](https://core.tcl.tk/tcllib/doc/trunk/embedded/www/tcllib/files/apps/pt.html) 同时也需要安装一个名叫 `pt` 的命令行工具。

若需要修改默认搜索工具的选项，可以使用启动函数，在启动函数中配置各种搜索工具的默认选项。 下面是一个修改 `rg` 默认搜索选项的配置示例：

```
function! myspacevim#before() abort
    let profile = SpaceVim#mapping#search#getprofile('rg')
    let default_opt = profile.default_opts + ['--no-ignore-vcs']
    call SpaceVim#mapping#search#profile({'rg' : {'default_opts' : default_opt}})
endfunction


```

搜索工具配置结构为：

```
" { 'ag' : {
"   'namespace' : '',         " a single char a-z
"   'command' : '',           " executable
"   'default_opts' : [],      " default options
"   'recursive_opt' : [],     " default recursive options
"   'expr_opt' : '',          " option for enable expr mode
"   'fixed_string_opt' : '',  " option for enable fixed string mode
"   'ignore_case' : '',       " option for enable ignore case mode
"   'smart_case' : '',        " option for enable smart case mode
"   }
"  }


```

#### 常用按键绑定

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC r l</code></td><td>恢复上一次搜索历史</td></tr></tbody></table>

#### 在当前文件中进行搜索

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC s s</code></td><td>使用默认的搜索工具进行搜索</td></tr><tr><td><code>SPC s S</code></td><td>使用默认的搜索工具进行搜索光标下的词</td></tr><tr><td><code>SPC s a a</code></td><td>使用 ag 进行搜索</td></tr><tr><td><code>SPC s a A</code></td><td>使用 ag 进行搜索光标下的词</td></tr><tr><td><code>SPC s g g</code></td><td>使用 grep 进行搜索</td></tr><tr><td><code>SPC s g G</code></td><td>使用 grep 进行搜索光标下的词</td></tr><tr><td><code>SPC s r r</code></td><td>使用 rg 进行搜索</td></tr><tr><td><code>SPC s r R</code></td><td>使用 rg 进行搜索光标下的词</td></tr></tbody></table>

#### 搜索当前文件所在的文件夹

以下快捷键为搜索当前文件所在的文件夹，比如，当正在编辑文件`src/util/help.c`时， 以下这些快捷键搜索的位置为`src/util/`文件夹内的内容。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC s d</code></td><td>使用默认的搜索工具进行搜索</td></tr><tr><td><code>SPC s D</code></td><td>使用默认的搜索工具搜索光标下的词</td></tr><tr><td><code>SPC s a d</code></td><td>使用<code>ag</code>进行搜索</td></tr><tr><td><code>SPC s a D</code></td><td>使用<code>ag</code>搜索光标下的词</td></tr><tr><td><code>SPC s g d</code></td><td>使用<code>grep</code>进行搜索</td></tr><tr><td><code>SPC s g D</code></td><td>使用<code>grep</code>搜索光标下的词</td></tr><tr><td><code>SPC s k d</code></td><td>使用<code>ack</code>进行搜索</td></tr><tr><td><code>SPC s k D</code></td><td>使用<code>ack</code>搜索光标下的词</td></tr><tr><td><code>SPC s r d</code></td><td>使用<code>rg</code>进行搜索</td></tr><tr><td><code>SPC s r D</code></td><td>使用<code>rg</code>搜索光标下的词</td></tr><tr><td><code>SPC s t d</code></td><td>使用<code>pt</code>进行搜索</td></tr><tr><td><code>SPC s t D</code></td><td>使用<code>pt</code>搜索光标下的词</td></tr></tbody></table>

#### 在所有打开的缓冲区中进行搜索

以下快捷键为搜索已经打开的文件列表，搜索的目标位置仅限于已经在 Vim 中打开的文件列表。 在 Vim 中，可以使用命令`:ls`查看已经打开的文件列表。

如若已经载入了模糊搜索的模块，则可以使用快捷键`SPC b b`查看已打开的文件。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC s b</code></td><td>使用默认的搜索工具进行搜索</td></tr><tr><td><code>SPC s B</code></td><td>使用默认的搜索工具搜索光标下的词</td></tr><tr><td><code>SPC s a b</code></td><td>使用<code>ag</code>进行搜索</td></tr><tr><td><code>SPC s a B</code></td><td>使用<code>ag</code>搜索光标下的词</td></tr><tr><td><code>SPC s g b</code></td><td>使用<code>grep</code>进行搜索</td></tr><tr><td><code>SPC s g B</code></td><td>使用<code>grep</code>搜索光标下的词</td></tr><tr><td><code>SPC s k b</code></td><td>使用<code>ack</code>进行搜索</td></tr><tr><td><code>SPC s k B</code></td><td>使用<code>ack</code>搜索光标下的词</td></tr><tr><td><code>SPC s r b</code></td><td>使用<code>rg</code>进行搜索</td></tr><tr><td><code>SPC s r B</code></td><td>使用<code>rg</code>搜索光标下的词</td></tr><tr><td><code>SPC s t b</code></td><td>使用<code>pt</code>进行搜索</td></tr><tr><td><code>SPC s t B</code></td><td>使用<code>pt</code>搜索光标下的词</td></tr></tbody></table>

#### 在任意目录中进行搜索

以下快捷用于指定搜索目录具体文件夹位置，比如需要去搜索非当前项目下的一些文件。 按下快捷键后，首先提示的是输入搜索词，之后提示输入搜索的目录地址。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC s f</code></td><td>使用默认的搜索工具进行搜索</td></tr><tr><td><code>SPC s F</code></td><td>使用默认的搜索工具搜索光标下的词</td></tr><tr><td><code>SPC s a f</code></td><td>使用<code>ag</code>进行搜索</td></tr><tr><td><code>SPC s a F</code></td><td>使用<code>ag</code>搜索光标下的词</td></tr><tr><td><code>SPC s g f</code></td><td>使用<code>grep</code>进行搜索</td></tr><tr><td><code>SPC s g F</code></td><td>使用<code>grep</code>搜索光标下的词</td></tr><tr><td><code>SPC s k f</code></td><td>使用<code>ack</code>进行搜索</td></tr><tr><td><code>SPC s k F</code></td><td>使用<code>ack</code>搜索光标下的词</td></tr><tr><td><code>SPC s r f</code></td><td>使用<code>rg</code>进行搜索</td></tr><tr><td><code>SPC s r F</code></td><td>使用<code>rg</code>搜索光标下的词</td></tr><tr><td><code>SPC s t f</code></td><td>使用<code>pt</code>进行搜索</td></tr><tr><td><code>SPC s t F</code></td><td>使用<code>pt</code>搜索光标下的词</td></tr></tbody></table>

#### 在工程中进行搜索

以下这些快捷键是用于搜索整个工程目录的，搜索的文件夹位置为当前文件所在的项目根目录。 项目的根目录默认会自动检测识别，主要是依据`project_rooter_patterns`选项设定。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC s p</code></td><td>使用默认的搜索工具进行搜索</td></tr><tr><td><code>SPC s P</code></td><td>使用默认的搜索工具搜索光标下的词</td></tr><tr><td><code>SPC s a p</code></td><td>使用<code>ag</code>进行搜索</td></tr><tr><td><code>SPC s a P</code></td><td>使用<code>ag</code>搜索光标下的词</td></tr><tr><td><code>SPC s g p</code></td><td>使用<code>grep</code>进行搜索</td></tr><tr><td><code>SPC s g P</code></td><td>使用<code>grep</code>搜索光标下的词</td></tr><tr><td><code>SPC s k p</code></td><td>使用<code>ack</code>进行搜索</td></tr><tr><td><code>SPC s k P</code></td><td>使用<code>ack</code>搜索光标下的词</td></tr><tr><td><code>SPC s r p</code></td><td>使用<code>rg</code>进行搜索</td></tr><tr><td><code>SPC s r P</code></td><td>使用<code>rg</code>搜索光标下的词</td></tr><tr><td><code>SPC s t p</code></td><td>使用<code>pt</code>进行搜索</td></tr><tr><td><code>SPC s t P</code></td><td>使用<code>pt</code>搜索光标下的词</td></tr></tbody></table>

**提示**: 在工程中进行搜索的话，无需提前打开文件。在工程保存目录中使用 `SPC p p` 和　`C-s`，就比如 `SPC s p`。(TODO)

#### 后台进行工程搜索

在工程中进行后台搜索时，当搜索完成时，会在状态栏上进行显示．

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC s j</code></td><td>使用默认搜索工具，后台检索输入的正则表达式</td></tr><tr><td><code>SPC s J</code></td><td>使用默认搜索工具，后台检索光标下的词语</td></tr><tr><td><code>SPC s l</code></td><td>使用 quickfix 窗口列出搜索结果</td></tr><tr><td><code>SPC s a j</code></td><td>使用 <code>ag</code> 后台检索输入的正则表达式</td></tr><tr><td><code>SPC s a J</code></td><td>使用 <code>ag</code> 后台检索光标下的词语</td></tr><tr><td><code>SPC s g j</code></td><td>使用 <code>grep</code> 后台检索输入的正则表达式</td></tr><tr><td><code>SPC s g J</code></td><td>使用 <code>grep</code> 后台检索光标下的词语</td></tr><tr><td><code>SPC s k j</code></td><td>使用 <code>ack</code> 后台检索输入的正则表达式</td></tr><tr><td><code>SPC s k J</code></td><td>使用 <code>ack</code> 后台检索光标下的词语</td></tr><tr><td><code>SPC s t j</code></td><td>使用 <code>pt</code> 后台检索输入的正则表达式</td></tr><tr><td><code>SPC s t J</code></td><td>使用 <code>pt</code> 后台检索光标下的词语</td></tr><tr><td><code>SPC s r j</code></td><td>使用 <code>rg</code> 后台检索输入的正则表达式</td></tr><tr><td><code>SPC s r J</code></td><td>使用 <code>rg</code> 后台检索光标下的词语</td></tr></tbody></table>

#### 在网上进行搜索

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC s w g</code></td><td>Get Google suggestions in Vim. Opens Google results in Browser.</td></tr><tr><td><code>SPC s w w</code></td><td>Get Wikipedia suggestions in Vim. Opens Wikipedia page in Browser.(TODO)</td></tr></tbody></table>

**注意**: 为了在 Vim 中使用谷歌 suggestions，需要在 `~/.SpaceVim.d/init.toml` 的 `[options]` 片段中加入如下配置：

```
[options]
    enable_googlesuggest = true


```

#### 实时代码检索

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC s /</code></td><td>在工程中使用默认工具实时检索代码</td></tr></tbody></table>

Flygrep 搜索窗口结果窗口内的常用快捷键：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>&lt;Esc&gt;</code></td><td>关闭搜索窗口</td></tr><tr><td><code>&lt;Enter&gt;</code></td><td>打开当前选中的文件位置</td></tr><tr><td><code>Ctrl-t</code></td><td>在新标签栏打开选中项</td></tr><tr><td><code>Ctrl-s</code></td><td>在分屏打开选中项</td></tr><tr><td><code>Ctrl-v</code></td><td>在垂直分屏打开选中项</td></tr><tr><td><code>Ctrl-q</code></td><td>将搜索结果转移至 quickfix</td></tr><tr><td><code>&lt;Tab&gt;</code></td><td>选中下一行文件位置</td></tr><tr><td><code>Shift-&lt;Tab&gt;</code></td><td>选中上一行文件位置</td></tr><tr><td><code>&lt;Backspace&gt;</code></td><td>删除上一个输入字符</td></tr><tr><td><code>Ctrl-w</code></td><td>删除光标前的单词</td></tr><tr><td><code>Ctrl-u</code></td><td>删除光标前所有内容</td></tr><tr><td><code>Ctrl-k</code></td><td>删除光标后所有内容</td></tr><tr><td><code>Ctrl-a</code> / <code>&lt;Home&gt;</code></td><td>将光标移至行首</td></tr><tr><td><code>Ctrl-e</code> / <code>&lt;End&gt;</code></td><td>将光标移至行尾</td></tr></tbody></table>

#### 保持高亮

SpaceVim 使用 `search_highlight_persist` 保持当前搜索结果的高亮状态到下一次搜索。 同样可以通过 `SPC s c` 或者运行 命令 `:nohlsearch` 来取消搜索结果的高亮表示。

#### 获取帮助信息

模糊搜索模块是一个强大的信息筛选浏览器，这类似于 Emacs 中的 [Helm](https://github.com/emacs-helm/helm)。 以下这些快捷键将帮助你快速获取需要的帮助信息：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC h SPC</code></td><td>使用模糊搜索模块展示 SpaceVim 帮助文档章节目录</td></tr><tr><td><code>SPC h i</code></td><td>使用模糊搜索模块获取光标下单词的帮助信息</td></tr><tr><td><code>SPC h g</code></td><td>异步执行<code>:helpgrep</code></td></tr><tr><td><code>SPC h G</code></td><td>异步执行<code>:helpgrep</code>，并搜索光标下的词</td></tr><tr><td><code>SPC h k</code></td><td>使用快捷键导航，展示 SpaceVim 所支持的前缀键</td></tr><tr><td><code>SPC h m</code></td><td>使用模糊搜索模块浏览所有 man 文档</td></tr></tbody></table>

注意：`SPC h i` 和 `SPC h m` 需要载入一个模糊搜索模块。

报告一个问题：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC h I</code></td><td>根据模板展示 Issue 所必须的信息</td></tr></tbody></table>

### 常用的成对快捷键

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>[ SPC</code></td><td>在当前行或已选区域上方添加空行</td></tr><tr><td><code>] SPC</code></td><td>在当前行或已选区域下方添加空行</td></tr><tr><td><code>[ b</code></td><td>跳至前一 buffer</td></tr><tr><td><code>] b</code></td><td>跳至下一 buffer</td></tr><tr><td><code>[ n</code></td><td>跳至前一冲突位置</td></tr><tr><td><code>] n</code></td><td>跳至下一冲突位置</td></tr><tr><td><code>[ f</code></td><td>跳至文件夹中的前一个文件</td></tr><tr><td><code>] f</code></td><td>跳至文件夹中的下一个文件</td></tr><tr><td><code>[ l</code></td><td>跳至前一个错误处</td></tr><tr><td><code>] l</code></td><td>跳至下一个错误处</td></tr><tr><td><code>[ c</code></td><td>跳至前一个 vcs hunk (需要 VersionControl 模块)</td></tr><tr><td><code>] c</code></td><td>跳至下一个 vcs hunk (需要 VersionControl 模块)</td></tr><tr><td><code>[ q</code></td><td>跳至前一个错误</td></tr><tr><td><code>] q</code></td><td>跳至下一个错误</td></tr><tr><td><code>[ t</code></td><td>跳至前一个标签页</td></tr><tr><td><code>] t</code></td><td>跳至下一个标签页</td></tr><tr><td><code>[ w</code></td><td>跳至前一个窗口</td></tr><tr><td><code>] w</code></td><td>跳至下一个窗口</td></tr><tr><td><code>[ e</code></td><td>向上移动当前行或者已选择行</td></tr><tr><td><code>] e</code></td><td>向下移动当前行或者已选择行</td></tr><tr><td><code>[ p</code></td><td>粘贴至当前行上方</td></tr><tr><td><code>] p</code></td><td>粘贴至当前行下方</td></tr><tr><td><code>g p</code></td><td>选择粘贴的区域</td></tr></tbody></table>

### 跳转，合并，拆分

以 `SPC j` 为前缀的快捷键主要用作：跳转（jumping），合并（joining），拆分（splitting）。

#### 跳转

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC j $</code></td><td>跳至行尾，并且在原始位置留下标签，以便跳回</td></tr><tr><td><code>SPC j 0</code></td><td>跳至行首，并且在原始位置留下标签，以便跳回</td></tr><tr><td><code>SPC j b</code></td><td>向后回跳</td></tr><tr><td><code>SPC j c</code></td><td>跳至前一个修改位置</td></tr><tr><td><code>SPC j D</code></td><td>跳至当前目录某个文件夹（在另外窗口展示文件列表）</td></tr><tr><td><code>SPC j d</code></td><td>跳至当前目录某个文件夹</td></tr><tr><td><code>SPC j f</code></td><td>向前跳</td></tr><tr><td><code>SPC j i</code></td><td>跳至当前文件的某个函数，使用 Denite 打开语法树</td></tr><tr><td><code>SPC j I</code></td><td>跳至所有 Buffer 的语法树（TODO）</td></tr><tr><td><code>SPC j J</code></td><td>跳至当前窗口的某两个字符的组合 (easymotion)</td></tr><tr><td><code>SPC j j</code></td><td>跳至当前窗口的某个字符 (easymotion)</td></tr><tr><td><code>SPC j k</code></td><td>跳至下一行，并且对齐下一行</td></tr><tr><td><code>SPC j l</code></td><td>跳至某一行 (easymotion)</td></tr><tr><td><code>SPC j q</code></td><td>show the dumb-jump quick look tooltip (TODO)</td></tr><tr><td><code>SPC j u</code></td><td>跳至窗口某个 URL (TODO)</td></tr><tr><td><code>SPC j v</code></td><td>跳至某个 Vim 函数的定义处 (TODO)</td></tr><tr><td><code>SPC j w</code></td><td>跳至 Buffer 中某个单词 (easymotion)</td></tr></tbody></table>

#### 合并，拆分

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>J</code></td><td>合并当前行和下一行</td></tr><tr><td><code>SPC j k</code></td><td>跳至下一行，并且对齐该行</td></tr><tr><td><code>SPC j n</code></td><td>从光标处断开当前行，并且插入空行以及进行对齐</td></tr><tr><td><code>SPC j o</code></td><td>从光标处拆分该行，光标停留在当前行行尾</td></tr><tr><td><code>SPC j s</code></td><td>从光标处拆分 String</td></tr><tr><td><code>SPC j S</code></td><td>从光标处使用换行符拆分 String，并自动缩进新行</td></tr></tbody></table>

### 其他快捷键

#### 以 `g` 为前缀的快捷键

在 Normal 模式下按下 `g` 之后，如果你不记得快捷键出现按键延迟，那么快捷键导航将会提示你所有以 `g` 为前缀的快捷键。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>g #</code></td><td>反向搜索光标下的词</td></tr><tr><td><code>g $</code></td><td>跳向本行最右侧字符</td></tr><tr><td><code>g &amp;</code></td><td>针对所有行重复执行上一次 “:s” 命令</td></tr><tr><td><code>g '</code></td><td>跳至标签</td></tr><tr><td><code>g *</code></td><td>正向搜索光标下的词</td></tr><tr><td><code>g +</code></td><td>newer text state</td></tr><tr><td><code>g ,</code></td><td>newer position in change list</td></tr><tr><td><code>g -</code></td><td>older text state</td></tr><tr><td><code>g /</code></td><td>stay incsearch</td></tr><tr><td><code>g 0</code></td><td>go to leftmost character</td></tr><tr><td><code>g ;</code></td><td>older position in change list</td></tr><tr><td><code>g &lt;</code></td><td>last page of previous command output</td></tr><tr><td><code>g &lt;Home&gt;</code></td><td>go to leftmost character</td></tr><tr><td><code>g E</code></td><td>end of previous word</td></tr><tr><td><code>g F</code></td><td>edit file under cursor(jump to line after name)</td></tr><tr><td><code>g H</code></td><td>select line mode</td></tr><tr><td><code>g I</code></td><td>insert text in column 1</td></tr><tr><td><code>g J</code></td><td>join lines without space</td></tr><tr><td><code>g N</code></td><td>visually select previous match</td></tr><tr><td><code>g Q</code></td><td>switch to Ex mode</td></tr><tr><td><code>g R</code></td><td>enter VREPLACE mode</td></tr><tr><td><code>g T</code></td><td>previous tag page</td></tr><tr><td><code>g U</code></td><td>make motion text uppercase</td></tr><tr><td><code>g ]</code></td><td>tselect cursor tag</td></tr><tr><td><code>g ^</code></td><td>go to leftmost no-white character</td></tr><tr><td><code>g _</code></td><td>go to last char</td></tr><tr><td><code>g `</code></td><td>跳至标签，等同于 <code>g'</code></td></tr><tr><td><code>g a</code></td><td>打印光标字符的 ascii 值</td></tr><tr><td><code>g d</code></td><td>跳至定义处</td></tr><tr><td><code>g e</code></td><td>go to end of previous word</td></tr><tr><td><code>g f</code></td><td>edit file under cursor</td></tr><tr><td><code>g g</code></td><td>go to line N</td></tr><tr><td><code>g h</code></td><td>select mode</td></tr><tr><td><code>g i</code></td><td>insert text after ‘^ mark</td></tr><tr><td><code>g j</code></td><td>move cursor down screen line</td></tr><tr><td><code>g k</code></td><td>move cursor up screen line</td></tr><tr><td><code>g m</code></td><td>go to middle of screenline</td></tr><tr><td><code>g n</code></td><td>visually select next match</td></tr><tr><td><code>g o</code></td><td>goto byte N in the buffer</td></tr><tr><td><code>g s</code></td><td>sleep N seconds</td></tr><tr><td><code>g t</code></td><td>next tag page</td></tr><tr><td><code>g u</code></td><td>make motion text lowercase</td></tr><tr><td><code>g ~</code></td><td>swap case for Nmove text</td></tr><tr><td><code>g &lt;End&gt;</code></td><td>跳至本行最右侧字符，等同于 <code>g$</code></td></tr><tr><td><code>g Ctrl-G</code></td><td>显示光标信息</td></tr></tbody></table>

#### 以 `z` 开头的命令

当你不记得按键映射时，你可以在普通模式下输入前缀 `z`, 然后你会看到所有以 `z` 为前缀的函数映射。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>z &lt;Right&gt;</code></td><td>scroll screen N characters to left</td></tr><tr><td><code>z +</code></td><td>cursor to screen top line N</td></tr><tr><td><code>z -</code></td><td>cursor to screen bottom line N</td></tr><tr><td><code>z .</code></td><td>cursor line to center</td></tr><tr><td><code>z &lt;Cr&gt;</code></td><td>cursor line to top</td></tr><tr><td><code>z =</code></td><td>spelling suggestions</td></tr><tr><td><code>z A</code></td><td>toggle folds recursively</td></tr><tr><td><code>z C</code></td><td>close folds recursively</td></tr><tr><td><code>z D</code></td><td>delete folds recursively</td></tr><tr><td><code>z E</code></td><td>eliminate all folds</td></tr><tr><td><code>z F</code></td><td>create a fold for N lines</td></tr><tr><td><code>z G</code></td><td>mark good spelled(update internal-wordlist)</td></tr><tr><td><code>z H</code></td><td>scroll half a screenwidth to the right</td></tr><tr><td><code>z L</code></td><td>scroll half a screenwidth to the left</td></tr><tr><td><code>z M</code></td><td>set <code>foldlevel</code> to zero</td></tr><tr><td><code>z N</code></td><td>set <code>foldenable</code></td></tr><tr><td><code>z O</code></td><td>open folds recursively</td></tr><tr><td><code>z R</code></td><td>set <code>foldlevel</code> to deepest fold</td></tr><tr><td><code>z W</code></td><td>mark wrong spelled</td></tr><tr><td><code>z X</code></td><td>re-apply <code>foldlevel</code></td></tr><tr><td><code>z ^</code></td><td>cursor to screen bottom line N</td></tr><tr><td><code>z a</code></td><td>toggle a fold</td></tr><tr><td><code>z b</code></td><td>redraw, cursor line at bottom</td></tr><tr><td><code>z c</code></td><td>close a fold</td></tr><tr><td><code>z d</code></td><td>delete a fold</td></tr><tr><td><code>z e</code></td><td>right scroll horizontally to cursor position</td></tr><tr><td><code>z f</code></td><td>create a fold for motion</td></tr><tr><td><code>z g</code></td><td>mark good spelled</td></tr><tr><td><code>z h</code></td><td>scroll screen N characters to right</td></tr><tr><td><code>z i</code></td><td>toggle foldenable</td></tr><tr><td><code>z j</code></td><td>mode to start of next fold</td></tr><tr><td><code>z k</code></td><td>mode to end of previous fold</td></tr><tr><td><code>z l</code></td><td>scroll screen N characters to left</td></tr><tr><td><code>z m</code></td><td>subtract one from <code>foldlevel</code></td></tr><tr><td><code>z n</code></td><td>reset <code>foldenable</code></td></tr><tr><td><code>z o</code></td><td>open fold</td></tr><tr><td><code>z r</code></td><td>add one to <code>foldlevel</code></td></tr><tr><td><code>z s</code></td><td>left scroll horizontally to cursor position</td></tr><tr><td><code>z t</code></td><td>cursor line at top of window</td></tr><tr><td><code>z v</code></td><td>open enough folds to view cursor line</td></tr><tr><td><code>z x</code></td><td>re-apply foldlevel and do “zV”</td></tr><tr><td><code>z z</code></td><td>smart scroll</td></tr><tr><td><code>z &lt;Left&gt;</code></td><td>scroll screen N characters to right</td></tr></tbody></table>

## 进阶使用

### 工程管理

当打开一个文件时，SpaceVim 会自动切换当前目录至包含该文件的项目根目录， 项目根目录的检测依据 `project_rooter_patterns` 这一选项，其默认值为：

```
[options]
    project_rooter_patterns = ['.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']


```

项目管理器默认自动检测最外层的项目根目录，如果需要自动检测最内层的项目根目录， 可将选项 `project_rooter_outermost` 选项改为 `false`。

```
[options]
    project_rooter_patterns = ['.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
    project_rooter_outermost = false


```

在自动检测项目根目录时，有时候我们需要忽略掉一些目录，可以表达式前面添加 `!`， 比如，忽略掉 `node_packages/` 文件夹：

```
[options]
    project_rooter_patterns = ['.git/', '_darcs/', '.hg/', '.bzr/', '.svn/', '!node_packages/']
    project_rooter_outermost = false


```

工程管理的命令以 `p` 开头：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC p '</code></td><td>在当前工程的根目录打开 shell（需要 shell 模块）</td></tr></tbody></table>

#### 在工程中搜索文件

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC p f</code></td><td>在当前工程中查找文件</td></tr><tr><td><code>SPC p F</code></td><td>在当前工程中查找光标下的文件</td></tr><tr><td><code>SPC p /</code></td><td>在当前工程中搜索文本内容</td></tr><tr><td><code>SPC p k</code></td><td>关闭当前工程的所有缓冲区</td></tr><tr><td><code>SPC p p</code></td><td>显示所有工程</td></tr></tbody></table>

`SPC p p` 将会列出最近使用的项目清单，默认会显示最多 20 个， 这一数量可以使用 `projects_cache_num` 来修改。

为了可以夸 Vim 进程读取历史打开的项目信息，这一功能使用了缓存机制。 如果需要禁用这一缓存功能，可以将 `enable_projects_cache` 设为 `false`。

```
[options]
    enable_projects_cache = true
    projects_cache_num = 20


```

#### 自定义跳转文件

若要实现自定义文件跳转功能，需要在项目根目录新建一个 `.project_alt.json` 文件， 并在此文件内指定文件跳转的规则。此后可以使用名`:A`跳转到相关文件， 同时可以加上参数指定跳转类型，比如 `:A doc`。与此同时，可以在命令后加入感叹号 `:A!`， 强制根据配置文件重新分析项目跳转文件结构。若未指定跳转类型，默认的类型为 `alternate`。

配置文件示例：

```
{
  "autoload/SpaceVim/layers/lang/*.vim": {
    "doc": "docs/layers/lang/{}.md",
    "test": "test/layer/lang/{}.vader"
  }
}


```

除了使用 `.project_alt.json` 文件以外，还可以在启动函数中设置 `b:alternate_file_config`， 例如：

```
augroup myspacevim
    autocmd!
    autocmd BufNewFile,BufEnter *.c let b:alternate_file_config = {
        \ "src/*.c" : {
            \ "doc" : "docs/{}.md",
            \ "alternate" : "include/{}.h",
            \ }
        \ }
    autocmd BufNewFile,BufEnter *.h let b:alternate_file_config = {
        \ "include/*.h" : {
            \ "alternate" : "scr/{}.c",
            \ }
        \ }
augroup END


```

### 标签管理

在浏览代码时，通常需要给指定位置添加标签，方便快速跳转，在 SpaceVim 中可以使用如下快捷键来管理标签。 这一功能需要载入 tools 模块：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>m a</code></td><td>显示书签列表</td></tr><tr><td><code>m c</code></td><td>清除所有书签</td></tr><tr><td><code>m m</code></td><td>切换当前行标签状态</td></tr><tr><td><code>m n</code></td><td>跳至下一个书签</td></tr><tr><td><code>m p</code></td><td>跳至前一个书签</td></tr><tr><td><code>m i</code></td><td>给当前行标签添加说明</td></tr></tbody></table>

正因为占用了以上几个快捷键，以下几个寄存器无法用来记忆当前位置了：`a`, `c`, `m`, `n`, `p`, `i`。 当然，也可以在启动函数里将 `<Leader> m` 映射为 `m` 键，如此便可使用 `<Leader> m a` 来代替 `m a`。

```
function! myspacevim#before() abort
    nnoremap <silent><Leader>m m
endfunction


```

### 任务管理

通过内置的任务管理系统，可以快速集成外部命令工具，类似于 vscode 的任务管理系统， 在 SpaceVim 中，目前支持的任务配置文件包括两种：

*   `~/.SpaceVim.d/tasks.toml`：全局配置文件
*   `.SpaceVim.d/tasks.toml`：项目局部配置文件

全局配置中定义的任务，默认会被项目局部配置文件中定义的任务覆盖掉。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC p t e</code></td><td>编辑任务配置文件</td></tr><tr><td><code>SPC p t r</code></td><td>选定任务并执行</td></tr><tr><td><code>SPC p t l</code></td><td>列出所有任务</td></tr></tbody></table>

![](<assets/1680076224557.png>)

#### 自定义任务

以下为一个简单的任务配置示例，异步运行 `echo hello world`，并将结果打印至输出窗口。

```
[my-task]
    command = 'echo'
    args = ['hello world']


```

![](<assets/1680076225841.png>)

对于不需要打印输出结果，后台运行的任务，可以设置 `isBackground` 为 `true`:

```
[my-task]
    command = 'echo'
    args = ['hello world']
    isBackground = true


```

任务的配置，可以设置如下关键字：

*   **command**: 需要运行的命令。
*   **args**: 传递给命令的参数，值为字符串数组
*   **options**: 设置命令运行的一些选项，比如 `cwd`,`env` 或者 `shell`。
*   **isBackground**: 可设定的值为 `true` 或者 `false`， 默认是 `false`， 设置是否需要后台运行任务
*   **description**: 关于该任务的一段简短介绍

当启动一个任务时，默认会关闭前一个任务，如果需要让任务一直保持后台运行， 可以将 `isBackground` 设为 `true`。

在编辑任务配置文件时，可以使用一些预设定的变量，以下列出目前已经支持的预设定变量：

*   **${workspaceFolder}**: - 当前项目的根目录；
*   **${workspaceFolderBasename}**: - 当前项目根目录所在父目录的文件夹名称；
*   **${file}**: - 当前文件的绝对路径；
*   **${relativeFile}**: - 当前文件相对项目根目录的相对路径；
*   **${relativeFileDirname}**: - 当前文件所在的文件夹相对项目根目录的相对路径；
*   **${fileBasename}**: - 当前文件的文件名
*   **${fileBasenameNoExtension}**: - 当前文件的文件名，不包括后缀名
*   **${fileDirname}**: - 当前文件所在的目录的绝对路径
*   **${fileExtname}**: - 当前文件的后缀名
*   **${lineNumber}**: - 光标所在行号

例如：假定目前正在编辑文件 `/home/your-username/your-project/folder/file.ext` ，光标位于第十行； 该文件所在的项目根目录为 `/home/your-username/your-project`，那么任务系统的预设定变量的值为：

*   **${workspaceFolder}**: - `/home/your-username/your-project/`
*   **${workspaceFolderBasename}**: - `your-project`
*   **${file}**: - `/home/your-username/your-project/folder/file.ext`
*   **${relativeFile}**: - `folder/file.ext`
*   **${relativeFileDirname}**: - `folder/`
*   **${fileBasename}**: - `file.ext`
*   **${fileBasenameNoExtension}**: - `file`
*   **${fileDirname}**: - `/home/your-username/your-project/folder/`
*   **${fileExtname}**: - `.ext`
*   **${lineNumber}**: - `10`

#### 任务自动识别

SpaceVim 目前支持自动识别以下构建系统的任务：npm。 任务管理插件将自动读取并分析 npm 系统的文件`package.json`。 比如，克隆示例项目 [eslint-starter](https://github.com/spicydonuts/eslint-starter)， 编辑其中的任意文件，然后按下快捷键`SPC p t r`，将会显示如下任务列表：

![](<assets/1680076226073.png>)

#### 任务提供源

任务提供源可以自动检测并新建任务。例如，一个任务提供源可以自动检测是否存在项目构建文件，比如：`package.json`， 如果存在则根据其内容创建 npm 的构建任务。

在 SpaceVim 里，如果需要新建任务提供源，需要使用启动函数，任务提供源是一个 Vim 函数，该函数返回一系列任务对象。

以下为一个简单的示例：

```
function! s:make_tasks() abort
    if filereadable('Makefile')
        let subcmds = filter(readfile('Makefile', ''), "v:val=~#'^.PHONY'")
        let conf = {}
        for subcmd in subcmds
            let commands = split(subcmd)[1:]
            for cmd in commands
                call extend(conf, {
                            \ cmd : {
                            \ 'command': 'make',
                            \ 'args' : [cmd],
                            \ 'isDetected' : 1,
                            \ 'detectedName' : 'make:'
                            \ }
                            \ })
            endfor
        endfor
        return conf
    else
        return {}
    endif
endfunction
call SpaceVim#plugins#tasks#reg_provider(funcref('s:make_tasks'))


```

将以上内容加入启动函数，在 SpceVim 仓库内按下 `SPC p t r` 快捷键，将会展示如下任务：

![](<assets/1680076226584.png>)

### 代办事项管理器

待办事项管理插件将异步执行`rg`命令，结果会展示在底部待办事项窗口。 默认的快捷键是 `SPC a o`，默认的标签前缀是 `@`， 默认的标签包含：`['fixme', 'question', 'todo', 'idea']`.

配置示例：

```
[options]
   todo_labels = ['fixme', 'question', 'todo', 'idea']
   todo_prefix = '@'


```

![](<assets/1680076226855.png>)

### Iedit 多光标编辑

SpaceVim 内置了 iedit 多光标模式，可快速进行多光标编辑。这一功能引入了两个新的模式：`iedit-Normal` 模式和 `iedit-Insert`。

`iedit` 模式默认的颜色是 `red`/`green`，但它也基于当前的主题。

#### Iedit 快捷键

**模式转换:**

前面提到 Iedit 引入了两个新的模式，在这两个新的模式以及 Vim 自身模式之间转换的快捷键如下：

<table><thead><tr><th>快捷键</th><th>From</th><th>to</th></tr></thead><tbody><tr><td><code>SPC s e</code></td><td>Normal/Visual</td><td>iedit-Normal</td></tr><tr><td><code>&lt;Esc&gt;</code></td><td>iedit-Normal</td><td>Normal</td></tr></tbody></table>

**在 iedit-Normal 模式中：**

`iedit-Normal` 模式继承自 Vim 的 Normal 模式, 下面所列举的是 `iedit-Normal` 模式专属的快捷键。

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>&lt;Esc&gt;</code></td><td>切换回 Normal 模式</td></tr><tr><td><code>i</code></td><td>切换至 <code>iedit-Insert</code> 模式，类似于一般模式下的 <code>i</code></td></tr><tr><td><code>a</code></td><td>切换至 <code>iedit-Insert</code> 模式，类似于一般模式下的 <code>a</code></td></tr><tr><td><code>I</code></td><td>跳至当前 occurrence 并进入 <code>iedit-Insert</code> 模式，类似于一般模式下的 <code>I</code></td></tr><tr><td><code>A</code></td><td>跳至当前 occurrence 并进入 <code>iedit-Insert</code> 模式，类似于一般模式下的 <code>A</code></td></tr><tr><td><code>&lt;Left&gt;</code> / <code>h</code></td><td>左移光标，类似于一般模式下的 <code>h</code></td></tr><tr><td><code>&lt;Right&gt;</code> / <code>l</code></td><td>右移光标，类似于一般模式下的 <code>l</code></td></tr><tr><td><code>0</code> / <code>&lt;Home&gt;</code></td><td>跳至当前 occurrence 的开头，类似于一般模式下的 <code>0</code></td></tr><tr><td><code>$</code> / <code>&lt;End&gt;</code></td><td>跳至当前 occurrence 的结尾，类似于一般模式下的 <code>$</code></td></tr><tr><td><code>C</code></td><td>删除所有 occurrences 中从光标位置开始到 occurrences 结尾的字符，类似于一般模式下的 <code>C</code></td></tr><tr><td><code>D</code></td><td>删除所有 occurrences 类似于一般模式下的 <code>D</code></td></tr><tr><td><code>s</code></td><td>删除所有 occurrences 中光标下的字符并进入 <code>iedit-Insert</code> 模式，类似于一般模式下的 <code>s</code></td></tr><tr><td><code>S</code></td><td>删除所有 occurrences 并进入 <code>iedit-Insert</code> 模式，类似于一般模式下的 <code>S</code></td></tr><tr><td><code>x</code></td><td>删除所有 occurrences 中光标下的字符，类似于一般模式下的 <code>x</code></td></tr><tr><td><code>X</code></td><td>删除所有 occurrences 中光标前的字符，类似于一般模式下的 <code>X</code></td></tr><tr><td><code>gg</code></td><td>跳至第一个 occurrence，类似于一般模式下的 <code>gg</code></td></tr><tr><td><code>G</code></td><td>跳至最后一个 occurrence，类似于一般模式下的 <code>G</code></td></tr><tr><td><code>f{char}</code></td><td>向右移动光标至字符 <code>{char}</code> 首次出现的位置</td></tr><tr><td><code>n</code></td><td>跳至下一个 occurrence</td></tr><tr><td><code>N</code></td><td>跳至上一个 occurrence</td></tr><tr><td><code>p</code></td><td>替换所有 occurrences 为最后复制的文本</td></tr><tr><td><code>&lt;Tab&gt;</code></td><td>toggle current occurrence</td></tr></tbody></table>

**In iedit-Insert mode:**

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>Ctrl-g</code> / <code>&lt;Esc&gt;</code></td><td>回到 <code>iedit-Normal</code> 模式</td></tr><tr><td><code>Ctrl-b</code> / <code>&lt;Left&gt;</code></td><td>左移光标</td></tr><tr><td><code>Ctrl-f</code> / <code>&lt;Right&gt;</code></td><td>右移光标</td></tr><tr><td><code>Ctrl-a</code> / <code>&lt;Home&gt;</code></td><td>跳至当前 occurrence 的开头</td></tr><tr><td><code>Ctrl-e</code> / <code>&lt;End&gt;</code></td><td>跳至当前 occurrence 的结尾</td></tr><tr><td><code>Ctrl-w</code></td><td>删除光标前的词</td></tr><tr><td><code>Ctrl-k</code></td><td>删除光标后的词</td></tr><tr><td><code>Ctrl-u</code></td><td>删除光标前所有字符</td></tr><tr><td><code>Ctrl-h</code> / <code>&lt;BackSpace&gt;</code></td><td>删除光标前字符</td></tr><tr><td><code>&lt;Delete&gt;</code></td><td>删除光标后字符</td></tr></tbody></table>

### 高亮光标下变量

SpaceVim 支持高亮当前光标下的变量，并且启动一个临时快捷键窗口， 提示可以通过快捷键进行修改高亮范围，以及下一步的操作。

目前支持的高亮范围包括：

*   整个缓冲区（buffer）
*   当前函数内（function）
*   可见区域（visible area）

使用快捷键 `SPC s h` 来高亮光标下的符号。

可使用如下快捷键在已高亮的变量间跳转：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>*</code></td><td>在当前缓冲区正向搜索光标下变量</td></tr><tr><td><code>#</code></td><td>在当前缓冲区逆向搜索光标下变量</td></tr><tr><td><code>SPC s e</code></td><td>启动 iedit 模式，编辑光标下变量</td></tr><tr><td><code>SPC s h</code></td><td>使用默认的的范围高亮光标下的变量</td></tr><tr><td><code>SPC s H</code></td><td>高亮当前缓冲区下所有的光标下变量</td></tr></tbody></table>

在高亮临时快捷键模式下可使用如下快捷键:

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>e</code></td><td>启动 iedit 模式</td></tr><tr><td><code>n</code></td><td>跳至下一个匹配处</td></tr><tr><td><code>N</code> / <code>p</code></td><td>跳至上一个匹配处</td></tr><tr><td><code>b</code></td><td>在整个缓冲区内高亮该匹配</td></tr><tr><td><code>/</code></td><td>在整个工程内检索当前匹配</td></tr><tr><td><code>&lt;Tab&gt;</code></td><td>切换当前匹配高亮状态</td></tr><tr><td><code>r</code></td><td>切换匹配的范围</td></tr><tr><td><code>R</code></td><td>重置匹配的范围</td></tr><tr><td>Any other key</td><td>退出该临时快捷键模式</td></tr></tbody></table>

### 异步运行器和交互式编程

SpaceVim 提供了一个异步执行命令和交互式编程的插件， 在大多数语言模块中，已经为该语言定义了默认的执行命令，通常快捷键为 `SPC l r`。 如果需要添加额外的命令，可以使用启动函数。比如：添加使用 F5 按键异步编译当前项目。

```
nnoremap <silent> <F5> :call SpaceVim#plugins#runner#open('make')


```

目前，SpaceVim 支持如下特性：

*   使用默认命令一键运行当前文件
*   使用系统文件管理器选择文件并执行
*   根据文件顶部标识，选择合适解析器
*   中断代码运行
*   底部窗口异步展示运行结果
*   设置默认的运行语言
*   选择指定语言来运行
*   支持交互式编程
*   运行选择的代码片段

### 错误处理

SpaceVim 通过默认通过 [checkers](https://spacevim.org/cn/layers/checkers/) 模块来进行文件语法检查，默认在保存文件时进行错误检查。

错误管理导航键 (以 `e` 开头)：

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>SPC t s</code></td><td>切换语法检查器</td></tr><tr><td><code>SPC e c</code></td><td>清除所有错误</td></tr><tr><td><code>SPC e h</code></td><td>describe a syntax checker</td></tr><tr><td><code>SPC e l</code></td><td>切换显示错误 / 警告列表</td></tr><tr><td><code>SPC e n</code></td><td>跳至下一错误</td></tr><tr><td><code>SPC e p</code></td><td>跳至上一个错误</td></tr><tr><td><code>SPC e v</code></td><td>verify syntax checker setup (useful to debug 3rd party tools configuration)</td></tr><tr><td><code>SPC e .</code></td><td>错误暂态（error transient state)</td></tr></tbody></table>

下一个 / 上一个错误导航键和错误暂态 (error transinet state) 可用于浏览语法检查器和位置列表缓冲区的错误， 甚至可检查 Vim 位置列表的所有错误。这包括下面的例子：在已被保存的位置列表缓冲区进行搜索。 默认提示符：

<table><thead><tr><th>提示符</th><th>描述</th><th>自定义选项</th></tr></thead><tbody><tr><td><code>✖</code></td><td>Error</td><td><code>error_symbol</code></td></tr><tr><td><code>➤</code></td><td>warning</td><td><code>warning_symbol</code></td></tr><tr><td><code>ⓘ</code></td><td>Info</td><td><code>info_symbol</code></td></tr></tbody></table>

**quickfix 列表移动：**

<table><thead><tr><th>快捷键</th><th>功能描述</th></tr></thead><tbody><tr><td><code>&lt;Leader&gt; q l</code></td><td>打开 quickfix 列表窗口</td></tr><tr><td><code>&lt;Leader&gt; q c</code></td><td>清除 quickfix 列表</td></tr><tr><td><code>&lt;Leader&gt; q n</code></td><td>跳到 quickfix 列表中下一个位置</td></tr><tr><td><code>&lt;Leader&gt; q p</code></td><td>跳到 quickfix 列表中上一个位置</td></tr></tbody></table>

### 格式规范

SpaceVim 添加了 [EditorConfig](https://editorconfig.org/) 支持，通过一个配置文件来为不同的文件格式设置对应的代码格式规范， 这一工具兼容多种文本编辑器和集成开发环境。

更多配置方式，可以阅读其官方文档：[editorconfig-vim package’s documentation](https://github.com/editorconfig/editorconfig-vim/blob/master/README.md).

### 后台服务

SpaceVim 在启动时启动了一个后台服务。无论何时，当你关闭了 Vim 窗口，该服务器就会被关闭。

**连接到 Vim 服务器**

如果你使用 Neovim, 你需要安装 [neovim-remote](https://github.com/mhinz/neovim-remote)，然后增加如下配置到你的 bashrc。

```
export PATH=$PATH:$HOME/.SpaceVim/bin


```

使用命令 `svc` 在一个已存在的 Vim 服务器上打开文件，使用命令 `nsvc` 在一个已存在的 Neovim 服务器上打开文件。

![](<assets/1680076227126.png>)



#vim    #SpaceVim 


