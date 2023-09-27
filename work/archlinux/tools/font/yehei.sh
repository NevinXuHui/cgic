#/bin/bash
###
 # @Author: xuhui 18867103881@139.com
 # @Date: 2023-06-09 21:24:14
 # @LastEditors: xuhui 18867103881@139.com
 # @LastEditTime: 2023-06-09 21:24:57
 # @FilePath: /obsidian/linux/archlinux/tools/font/yehei.sh
 # @Description: 
 # 
 # Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
### 

git clone https://gitee.com/hbk01/Windows-Fonts.git                     ## 使用git下载微软雅黑字体

cd Windows-Fonts && sudo cp -r ./* /usr/share/fonts                     ## 进入文件夹并全部复制到fonts字体文件夹内    

sudo mkfontscale && mkfontdir && fc-cache -fv 