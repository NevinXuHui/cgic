## 问题描述

在 afl 的 qemu_mode 目录下，执行./build_qemu_support.sh，报错`libtool not found, please install first`。
执行`sudo apt-get install libtool`提示 libtool 已经安装好了。但是执行`which libtool`没有信息输出。

## 解决方案

libtool 是安装了，但是 libtool-bin 未安装。于是执行`sudo apt-get install libtool-bin`。安装完毕之后执行`which libtool`，输出 / usr/bin/libtool。再次执行之前的命令，顺利完成。

