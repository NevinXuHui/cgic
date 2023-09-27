---
url: https://blog.csdn.net/LutingWang/article/details/123515698
title: Powerline 字体安装 for Windows _ Mac _ Ubuntu_powerline 字体_LutingWang 的博客 - CSDN 博客
date: 2023-03-31 12:57:45
tag: 
banner: "https://img-blog.csdnimg.cn/20210424161954583.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0x1dGluZ1dhbmc=,size_16,color_FFFFFF,t_70"
banner_icon: 🔖
---
### 文章目录

*   [系统字体安装](#_2)
*   [设置终端字体](#_20)
*   *   [VS Code](#VS_Code_24)
    *   [PuTTY](#PuTTY_35)
    *   [cmd](#cmd_41)
    *   [MacOS Terminal](#MacOS_Terminal_47)

# 系统字体安装

```
# refer to https://github.com/powerline/fonts
cd
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh

```

Windows 用户可能无法执行 `./install.sh` 。需要先按 Windows + x 调出 WinX 菜单，然后按 a 以管理员权限运行 [PowerShell](https://so.csdn.net/so/search?q=PowerShell&spm=1001.2101.3001.7020) ，修改执行策略并执行 `install.ps1`

```
set-executionpolicy bypass
./install.ps1
set-executionpolicy default

```

# 设置终端字体

在不同的终端上设置字体的方法也不同。

## VS Code

修改 `settings.json`

```
{
    "terminal.integrated.fontFamily": "Meslo LG S for powerline",
    "terminal.integrated.defaultProfile.linux": "zsh"
}

```

## PuTTY

设置字体为 `DejaVu Sans Mono for Powerline`

![](1680238665266.png)

## cmd

设置字体为 `DejaVu Sans Mono for Powerline`

![](1680238665357.png)

## MacOS Terminal

设置字体为 `Meslo LG S for powerline`

![](1680238665536.png)