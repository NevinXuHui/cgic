---
url: https://www.jianshu.com/p/4cdfe7b4c8ae
title: neovim 使用系统剪切板 - 简书
date: 2023-04-12 13:42:14
tag: 
banner: "https://upload.jianshu.io/users/upload_avatars/5788683/84ce7a17-268e-4474-a112-9e99f9e5b136.jpg"
banner_icon: 🔖
---
### 1.vim 与 neovim 使用系统剪切板的不同

vim 支持 clipboard 和 xterm_clipboard 的特性，并且用 "+" 和 "*" 这两个寄存器使用系统剪切板。而 nvim 并不支持这一特性。帮助文件中有如下叙述：

Nvim has no direct connection to the system clipboard. Instead it depends on  
a provider which transparently uses shell commands to communicate with the  
system clipboard or any other clipboard "backend".

### 2. 想要使用系统剪切板，最简单的方法就是安装 xsel 或 xclip 程序。

```
sudo apt install xclip


```

安装完后启动 nvim，复制一行 ('Y')，检查 register，可以看到在 **"** 和 **+** 寄存器里已经有这行内容了。在终端中，直接 **SHIFT+CTRL+V**， 就可以粘贴了。反过来，在系统中复制完之后，可以看到**'*'**和**'+'**寄存器中已经有复制的内容，在 nvim 中直接 **"*p** 或 **"+p** 就可以了。