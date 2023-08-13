#输入法切换 #im-select   #linux  #vscode
# im-select

Switch your input method from terminal. This project is a basic support for [VSCodeVim](https://github.com/VSCodeVim/Vim). It provides the command line program for VSCodeVim's autoSwitchIM function

# Installation
## macOS

### Homebrew

Run following command in your terminal:

```Shell
brew tap daipeihust/tap && brew install im-select
```

Then you can run following command to find your `im-select` path:

```Shell
which im-select
```

Normaly the result is `/usr/local/bin/im-select`.

Now, you can use im-select to print your current input method.

### Use script

Run following command in your terminal:

```Shell
curl -Ls https://raw.githubusercontent.com/daipeihust/im-select/master/install_mac.sh | sh
```

The im-select program will be downloaded to your `/usr/local/bin/` path.

### M1 Mac support

Click [here](https://github.com/daipeihust/im-select/blob/8080ad18f20218d1b6b5ef81d26cc5452d56b165/im-select-mac/out/apple/im-select) to download specific im-select program

## windows

### Manual download

Download the [im-select.exe](https://github.com/daipeihust/im-select/raw/master/im-select-win/out/x86/im-select.exe), and move it to the proper path.(If you need the 64 bit version, you can download [this one](https://github.com/daipeihust/im-select/raw/master/im-select-win/out/x64/im-select.exe).)

### Use Scoop package manager:

```Plain Text
scoop bucket add im-select https://github.com/daipeihust/im-select
scoop install im-select
```

## linux

You don't have to install this for linux. linux have tools to switch input methods

# Usage

## macOS

If your PATH contains `/usr/local/bin`, you can just use `im-select` instead of `/usr/local/bin/im-select`

### To get current input method key

```Shell
/usr/local/bin/im-select
```

### To switch current input method

```Shell
/usr/local/bin/im-select imkey
```

For example `/usr/local/bin/im-select com.apple.keylayout.US`

## linux

### ibus

[@mengbo](https://github.com/mengbo) provided this configuration for ibus

```Plain Text
"vim.autoSwitchInputMethod.enable": true,
"vim.autoSwitchInputMethod.defaultIM": "xkb:us::eng",
"vim.autoSwitchInputMethod.obtainIMCmd": "/usr/bin/ibus engine",
"vim.autoSwitchInputMethod.switchIMCmd": "/usr/bin/ibus engine {im}"
```

### xkb-switch

[@VEL4EG](https://github.com/VEL4EG) provided this configuration for xkb-switch

```Plain Text
"vim.autoSwitchInputMethod.enable": true,
"vim.autoSwitchInputMethod.defaultIM": "us",
"vim.autoSwitchInputMethod.obtainIMCmd": "/usr/local/bin/xkb-switch",
"vim.autoSwitchInputMethod.switchIMCmd": "/usr/local/bin/xkb-switch -s {im}"
```

### fcitx

[@yunhao94](https://github.com/yunhao94) provided this configuration for fcitx

```Plain Text
"vim.autoSwitchInputMethod.enable": true,
"vim.autoSwitchInputMethod.defaultIM": "1",
"vim.autoSwitchInputMethod.obtainIMCmd": "/usr/bin/fcitx-remote",
"vim.autoSwitchInputMethod.switchIMCmd": "/usr/bin/fcitx-remote -t {im}",
```

### fcitx5

## **当前直接无法使用命令方式  需要才用脚本方式** 

```Objective-C
"vim.autoSwitchInputMethod.enable": true,
"vim.autoSwitchInputMethod.defaultIM": "keyboard-us",
"vim.autoSwitchInputMethod.obtainIMCmd": "/usr/bin/fcitx5-remote.sh",
"vim.autoSwitchInputMethod.switchIMCmd": "/usr/bin/fcitx5-remote -s {im}",
```



## 使用注意
使用时候要注意以下几点

## 评论
- 20220615.0958 TODO e.g. 需要改进一下代码结构，关联的几个都需要重构

## 最近代码片段
```dataview
table
		语言,
 		框架,
		简述,
		file.cday AS "创建时间"
from #code_snippet and "pages"
where date(today) - file.ctime <=dur(7 days)
sort file.mtime desc
limit 10
```
```

[@cherrot](https://github.com/cherrot) provided this configuration for fcitx5, ugly but working (Suppose you want to switch between `keyboard-us` and `pinyin`.)

```Plain Text
"vim.autoSwitchInputMethod.enable": true,
"vim.autoSwitchInputMethod.defaultIM": "keyboard-us",
"vim.autoSwitchInputMethod.obtainIMCmd": "[[ `/usr/bin/fcitx5-remote` == 2 ]] && echo pinyin || echo keyboard-us",
"vim.autoSwitchInputMethod.switchIMCmd": "/usr/bin/fcitx5-remote -s {im}",
```

### gdbus

[@d-r-q](https://github.com/d-r-q)

Put `gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval "imports.ui.status.keyboard.getInputSourceManager().currentSource.index" | awk -F'[^0-9]*' '{print $2}'` into get-im.sh.

Put `gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval "imports.ui.status.keyboard.getInputSourceManager().inputSources[$1].activate()"` into set-im.sh.

```Plain Text
"vim.autoSwitchInputMethod.enable": true,
"vim.autoSwitchInputMethod.defaultIM": "0",
"vim.autoSwitchInputMethod.obtainIMCmd": "<path to get-im.sh>",
"vim.autoSwitchInputMethod.switchIMCmd": "<path to set-im.sh> {im}",
```

## windows

The im-select.exe is command line program, but it can't work in cmd or powershell. It's microsoft's fault, the keyboard API doesn't support in cmd and powershell. I recommend you git-bash.

> Note: The git-bash is not required. It's only used to get current input method key, which needed in VSCodeVim's configuration.

### To get current keyboard locale

```Shell
/path/to/im-select.exe
```

### To switch current keyboard locale

```Shell
/path/to/im-select.exe locale
```

> Note: The path in windows is like: C:\Users\path\to\file

# Contact

<div align="left">
    <img src="contact_me.jpeg" height="300">
</div>

