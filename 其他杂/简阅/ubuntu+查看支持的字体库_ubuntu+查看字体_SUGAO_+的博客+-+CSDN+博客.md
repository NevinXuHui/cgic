##1. 背景

```Plain Text
sugao@msos:~/mscore/src$ uname -a
Linux msos 4.4.0-75-generic #96-Ubuntu SMP Thu Apr 20 09:56:33 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

```

##2. 命令
fc-list 查看所有的字体
fc-list :lang=zh 查看所有的中文字体

##3. 增加字体
默认字体文件放在 / usr/share/fonts/opentype/noto / 目录中，可以从其他电脑拷贝字体库文件到该目录中;

dpkg-reconfigure fontconfig
fc-cache -vf

