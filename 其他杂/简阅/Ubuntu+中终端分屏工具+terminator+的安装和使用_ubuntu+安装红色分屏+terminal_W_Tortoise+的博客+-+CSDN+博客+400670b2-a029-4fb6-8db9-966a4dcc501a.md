### 目录

- [1 有何不同](#1__1)

- [2 特性](#2__3)

- [3 安装](#3__16)

- [4 使用](#4__21)

- [5 快捷键](#5__28)

- [6 美化](#6__68)

- [7 切换回自带的终端](#7__111)

- [8 参考](#8__123)

# 1 有何不同

在 Linux 中，以一种非常灵活的方式在一个窗口中拥有多个 Gnome 终端。

# 2 特性

- 自动记录所有终端会话

- 文本和 URL 的拖放功能

- 支持水平滚动

- 查找，一种用于在终端内搜索任何特定文本的功能

- 支持 UTF-8

- 智能退出–它知道运行过程（如果有）

- 垂直滚动很方便

- 使用自由，通用公共许可证

- 支持基于选项卡的浏览

- 用 Python 编写的 Portal

- 平台–支持 GNU/Linux 平台

# 3 安装

打开终端，运行以下命令安装 terminator：

```Plain Text
sudo apt-get install terminator

```

# 4 使用

安装完成后，按`Ctrl+Alt+T`打开 terminator，默认界面如下：

![](https://img-blog.csdnimg.cn/20191016104756345.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xlYXJuaW5nX3RvcnRvc2ll,size_16,color_FFFFFF,t_70#pic_center)

在终端执行以下命令，也能打开 terminator。

```Plain Text
terminator

```

# 5 快捷键

水平拆分终端– `Ctrl+Shift+0`

![](https://img-blog.csdnimg.cn/20191016104805324.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xlYXJuaW5nX3RvcnRvc2ll,size_16,color_FFFFFF,t_70#pic_center)

垂直拆分终端– `Ctrl+Shift+E`

![](https://img-blog.csdnimg.cn/20191016104813593.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xlYXJuaW5nX3RvcnRvc2ll,size_16,color_FFFFFF,t_70#pic_center)

- Search for a Keyword – Ctrl+Shift+f（这个功能好赞啊）

- Move to Next Terminal – Ctrl+Shift+N or Ctrl+Tab

- Move Parent Dragbar Right – Ctrl+Shift+Right_Arrow_key

- Move Parent Dragbar Left – Ctrl+Shift+Left_Arrow_key

- Move Parent Dragbar Up – Ctrl+Shift+Up_Arrow_key

- Move Parent Dragbar Down – Ctrl+Shift+Down_Arrow_key

- Hide/Show Scrollbar – Ctrl+Shift+s

- Move to the Above Terminal – Alt+Up_Arrow_Key

- Move to the Below Terminal – Alt+Down_Arrow_Key

- Move to the Left Terminal – Alt+Left_Arrow_Key

- Move to the Right Terminal – Alt+Right_Arrow_Key

- Copy a text to clipboard – Ctrl+Shift+c

- Paste a text from Clipboard – Ctrl+Shift+v

- Close the Current Terminal – Ctrl+Shift+w

- Quit the Terminator – Ctrl+Shift+q

- Toggle Between Terminals（切换终端） – Ctrl+Shift+x

- Open New Tab – Ctrl+Shift+t

- Move to Next Tab – Ctrl+page_Down

- Move to Previous Tab – Ctrl+Page_up

- Increase Font size – Ctrl+(+)

- Decrease Font Size – Ctrl+(-)

- Reset Font Size to Original – Ctrl+0

- Toggle Full Screen Mode – F11

- Reset Terminal – Ctrl+Shift+R

- Reset Terminal and Clear Window – Ctrl+Shift+G

- Remove all the terminal grouping – Super+Shift+t

- Group all Terminal into one – Super+g

注意：`Super`是带有 Windows 徽标的键。

# 6 美化

在窗口点击右键，选择【首选项】，打开以下界面：

![](https://img-blog.csdnimg.cn/20191016104822335.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xlYXJuaW5nX3RvcnRvc2ll,size_16,color_FFFFFF,t_70#pic_center)

接下来进行自定义配置即可。

还可以打开配置文件：

```Plain Text
cd ~/.config/terminator/ 
gedit config

```

替换为以下文本：

```Plain Text
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

```

效果：

![](https://img-blog.csdnimg.cn/20191016104839933.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xlYXJuaW5nX3RvcnRvc2ll,size_16,color_FFFFFF,t_70#pic_center)

# 7 切换回自带的终端

对于 [Ubuntu](https://so.csdn.net/so/search?q=Ubuntu&spm=1001.2101.3001.7020) 系统，如果安装了 terminator，那么快捷键`Ctrl+Alt+T`将不会启动自带的 terminal，而是启动安装的 terminator。

如果想恢复回来，可以执行以下命令：

```Plain Text
sudo update-alternatives --config x-terminal-emulator

```

然后选择：

```Plain Text
gnome-terminal.wrapper

```

![](https://img-blog.csdnimg.cn/2019101610485184.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xlYXJuaW5nX3RvcnRvc2ll,size_16,color_FFFFFF,t_70#pic_center)

# 8 参考

[1] [https://www.tecmint.com/terminator-a-linux-terminal-emulator-to-manage-multiple-terminal-windows/](https://www.tecmint.com/terminator-a-linux-terminal-emulator-to-manage-multiple-terminal-windows/)

[2] [https://blog.csdn.net/weixin_39433020/article/details/97942173](https://blog.csdn.net/weixin_39433020/article/details/97942173)

[3] [https://www.cnblogs.com/drizzlewithwind/p/4868645.html](https://www.cnblogs.com/drizzlewithwind/p/4868645.html)

[4] [https://launchpad.net/terminator](https://launchpad.net/terminator)

