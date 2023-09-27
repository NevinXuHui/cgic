ubuntu22.04版本  安装vim后，一直很烦恼无法复制粘贴（+p/+y）系统的剪切板
ubuntu20.04 需要安装vim-gtk

亲测 2204正常

```Objective-C
sudo apt install vim-gtk
```

其他版本linux桌面，请尝试安装vim-x , vim-x11,vim-gnome

vim中复制

```shell
"+y
```


或在vimrc 中添加

```Objective-C
set clipboard=unnamedplus
```


安装完成后在vim命令行模式输入version
查看是否支持clipboard
+代表支持
-代表不支持

