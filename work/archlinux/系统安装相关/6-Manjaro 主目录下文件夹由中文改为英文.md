---
url: https://www.cnblogs.com/fb010001/p/12753400.html
title: Manjaro 主目录下文件夹由中文改为英文
date: 2023-05-16 14:41:56
tag: 
banner: "undefined"
banner_icon: 🔖
---
sudo pacman -S xdg-user-dirs-gtk  
export LANG=en_US  
xdg-user-dirs-gtk-update  
然后会有个窗口提示语言更改，更新名称即可

export LANG=zh_CN.UTF-8  
然后重启电脑如果提示语言更改，保留旧的名称即可

作者：thepoy  
链接：[https://www.jianshu.com/p/2f05a5583609](https://www.jianshu.com/p/2f05a5583609)  
来源：简书  
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。