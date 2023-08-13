---
url: https://blog.csdn.net/itworld123/article/details/127087610
title: cmake _ CMAKE_INSTALL_PREFIX_cmake cmake_install_prefix_Ruo_Xiao 的博客 - CSDN 博客
date: 2023-06-29 12:16:08
tag: 
banner: "undefined"
banner_icon: 🔖
---
CMAKE_INSTALL_PREFIX 为 cmake 内置变量，用于指定 cmake 执行 install 目标时，安装的路径前缀。使用方法如下：

1、在执行 cmake 时指定

`cmake -DCMAKE_INSTALL_PREFIX=<你想要安装的路径>`

2、设置 CMAKE_INSTALL_PREFIX 变量

`SET(CMAKE_INSTALL_PREFIX <install_path>)`

要加在 PROJECT(<project_name>) 之后。

在设置完 install 的安装目录之后，执行 install 时可以通过 DESTINATION 直接指定安装目录之下的目录。

栗子：

```
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/ ..
 
SET(CMAKE_INSTALL_PREFIX /usr/local)
INSTALL(TARGETS test DESTINATION bin) #将 test 安装到 /usr/local/bin 目录下
```

需要强调一下，上述的 install 函数是在 cmake 、make 之后，执行 make install 命令时才运行的。

（SAW：Game Over！）