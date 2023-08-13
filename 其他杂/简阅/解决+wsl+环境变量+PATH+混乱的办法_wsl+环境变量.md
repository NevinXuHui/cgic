需要关闭 win 与 wsl 的交互，即不互相运行对方的程序或文件

1. 在`wsl`终端`/etc/`目录下新建`wsl.conf`文件

```Plain Text
touch /etc/wsl.conf

```

2. 编辑`wsl.conf`文件

```Plain Text
vim wsl.conf

```

3. 输入以下配置

```Plain Text
[interop]
enabled=false
appendWindowsPath=false

```

在 [powershell](https://so.csdn.net/so/search?q=powershell&spm=1001.2101.3001.7020)(以管理员身份运行) 中重启 wsl

```Plain Text
net stop LxssManager
net start LxssManager

```

