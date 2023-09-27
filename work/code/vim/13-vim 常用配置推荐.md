---
url: https://zhuanlan.zhihu.com/p/619695156
title: vim 常用配置推荐
date: 2023-04-20 08:52:58
tag: 
banner: "https://pic1.zhimg.com/v2-6c189b5afac817e63614a20e87723a2c_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
今年刚从 vscode 环境 + vim 插件，转入纯 vim 环境。刚入手 vim 时，并没有立刻体验到传说中的 “如丝般顺滑”。哈哈，还是我操作不熟练的缘故吧。入手 vim 前建议先去看一看《Pratical Vim》，也许能帮你少走一些弯路。

## 插件目录

1.  插件管理工具 ['junegunn/vim-plug'](https://github.com/junegunn/vim-plug)
2.  代码跳转 ['universal-ctags/ctags'](https://github.com/universal-ctags/ctags)
3.  大纲概览[‘preservim/tagbar’](https://github.com/preservim/tagbar)
4.  模糊文件搜索 ['kien/ctrlp.vim'](https://github.com/kien/ctrlp.vim)
5.  代码自动格式化 [‘google/vim-codefmt’](https://github.com/google/vim-codefmt)
6.  代码片段补全 ['SirVer/ultisnips'](https://github.com/SirVer/ultisnips)
7.  关键字搜索 ['mileszs/ack.vim'](https://github.com/mileszs/ack.vim)
8.  文件目录树 ['preservim/nerdtree'](https://github.com/preservim/nerdtree)
9.  代码自动补全 ['neoclide/coc.nvim'](https://github.com/neoclide/coc.nvim)
10.  代码注释 ['tomtom/tcomment_vim'](https://github.com/tomtom/tcomment_vim)
11.  c++ 语法高亮 '[octol/vim-cpp-enhanced-highlight](https://github.com/octol/vim-cpp-enhanced-highlight)'

## 插件介绍

### 插件管理工具

vim 的插件管理工具有很多，比如 vundle、vim-plug 等。我用的是 vim-plug，安装也很简单。如果是第一次安装插件管理工具，需要在 home 目录下新建 .vimrc 文件，并将 vim-plug github 主页面的代码粘贴即可。每次加入插件后，需要打开 vim，在命令模式下输入: PlugInstall 即可安装插件。

![](https://pic1.zhimg.com/v2-9069da134985dce9111d8c922b6d53f0_r.jpg)

### 代码跳转

代码跳转对于不熟悉项目的程序猿就好比是开了 “氮气加速”。

Step1：安装 Universal Ctags 插件。

```
Plug 'universal-ctags/ctags'

```

Step2：在工程目录下生成 tags 文件。

```
$cd $WORKSPACE
$ctags -R *

```

Step3：在 .vimrc 中设置 tags 文件路径。

```
set tags+=$WORKSPACE/tags

```

Step4：在 vim 下通过 "Ctrl + ]" 命令可实现跳转。

(Optional)Step5：没找对，咋整？

在命令模式先输入 ":tselect<CR>" 可选择其他定义。

![](https://pic3.zhimg.com/v2-55a62d646821353d1e5d42eb214dc4fa_r.jpg)

### 大纲概览

根据生成的 tags 文件，对打开文件中的函数名、变量名等进行显示，支持跳转到定义。

```
“ Add to your ~/.vimrc file.
Plug 'preservim/tagbar'

```

![](https://pic3.zhimg.com/v2-8eac71b52268b9202f043bae8e3a4a56_r.jpg)

### 模糊文件搜索

ctrl + p 对文件进行模糊搜索，和 vscode 的操作比较类似。

```
“ Add to your ~/.vimrc file.
Plug 'kien/ctrlp.vim'

```

![](https://pic3.zhimg.com/v2-c8ba153c95f084991d7cbae1fb394546_r.jpg)

### 代码自动格式化

按照官网将配置完成后，保存编写的代码即可自动对代码进行格式化。

```
“ Add to your ~/.vimrc file.
Plug 'google/vim-codefmt'

```

![](https://pic1.zhimg.com/v2-356e7f516b6b228cf73ed2ad99e89124_r.jpg)

### 代码片段补全

尽可能不要重复操作。将平时应用频率较高的代码写成 xxx.snippets 文件并加入到 UltiSnips 可检索到的目录中（~/.vim/plugged/vim-snippets/UltiSnips/*），UltiSnips 就可以根据代码片段对代码进行补全。

```
“ Add to your ~/.vimrc file.
Plug 'SirVer/ultisnips'

```

![](https://pic4.zhimg.com/v2-0f4cb6acbc5e6bf65a8b4ecacf3c6e63_r.jpg)

### 关键字搜索

这个插件本质上是让用户可以在 vim 中运用 ack 工具进行搜索，并在独立的窗口中对搜索结果进行展现，支持跳转到搜索结果处。

```
“ Add to your ~/.vimrc file.
Plug 'mileszs/ack.vim'

```

![](https://pic2.zhimg.com/v2-d5daca3b1c59d917f8b0464dde3c5aa1_r.jpg)

### 文件目录树

将文件名以目录树的形式进行展现，可以帮助快速浏览代码文件结构。

```
“ Add to your ~/.vimrc file.
Plug 'preservim/nerdtree'

```

![](https://pic2.zhimg.com/v2-e57f5a242ca26203664511521138b0d1_r.jpg)

### 代码自动补全

关于 coc.nvim 可以参考插件原作者[赵启明](https://zhuanlan.zhihu.com/p/65524706)大佬的介绍。

```
“ Add to your ~/.vimrc file.
Plug 'neoclide/coc.nvim', {'branch': 'release'}

```

![](https://pic1.zhimg.com/v2-07e287452e5a9ea0817239c0deffe870_r.jpg)

### 代码注释

选中要注释掉的代码，输入 gcc 即可进行注释，再次选中代码，输入 gcc 即可取消注释。

```
“ Add to your ~/.vimrc file.
Plug 'tomtom/tcomment_vim'

```

![](https://pic1.zhimg.com/v2-e954d6509293cffecf0ce3659daa4de8_r.jpg)

### C++ 语法高亮

根据 c++ 语法对代码进行高亮，更好区分不同类型的代码。

```
“ Add to your ~/.vimrc file.
Plug 'octol/vim-cpp-enhanced-highlight'

```

![](https://pic1.zhimg.com/v2-eb5fdf42e3db8006f847a5f758ff4724_r.jpg)