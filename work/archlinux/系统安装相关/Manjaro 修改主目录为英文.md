<!--
 * @Author: xuhui 18867103881@139.com
 * @Date: 2023-06-09 18:46:21
 * @LastEditors: xuhui 18867103881@139.com
 * @LastEditTime: 2023-06-09 18:47:25
 * @FilePath: /obsidian/linux/archlinux/Manjaro 修改主目录为英文.md
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
-->

### 操作方式

```
sudo pacman -S xdg-user-dirs-gtk
export LANG=en_US
xdg-user-dirs-gtk-update
#然后会有个窗口提示语言更改，更新名称即可
export LANG=zh_CN.UTF-8
#然后重启电脑如果提示语言更改，保留旧的名称即可
```

