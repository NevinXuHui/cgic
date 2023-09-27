# neovim 使用系统剪贴板

## 1.vim 与 neovim 使用系统剪切板的不同

Nvim has no direct connection to the system clipboard. Instead it depends on
a provider which transparently uses shell commands to communicate with the
system clipboard or any other clipboard "backend".

## 2. 安装 xsel 或 xclip 程序。

```Plain Text
sudo apt install xclip
```

## 3. 修改配置文件

init.vim 中添加一行：

```Plain Text
set clipboard+=unnamedplus


```

在 neovim 中选中文本 `y` ，就可以 `Ctrl + V` 到处粘贴了

在别处 `Ctrl + C`，在 neovim 中 `"+p` 进行粘贴。

