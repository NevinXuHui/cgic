---
url: https://www.cnblogs.com/wuchaodzxx/p/8916009.html
title: CMake 系列之四：多个源文件 - 多个目录
date: 2023-08-13 19:00:04
tag: 
banner: "https://images.unsplash.com/photo-1690814033781-f369d45a8277?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxOTI0Mzk4fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
**目录**

1.  [多个源文件，多个目录](#H1_0)
2.  [CMakeLists.txt 编写](#H1_1)

# 多个源文件，多个目录

现在进一步将 MathFunctions.c 和 MathFunctions.h 文件移到 math 目录下：

./Demo3

　　|

　　+--- main.c

　　|

　　+--- math/

　　　　　|

　　　　　+--- MathFunctions.c

　　　　　|

　　　　　+--- MathFunctions.h

# CMakeLists.txt 编写

这种情况下，需要在根目录 Demo3 和子目录 math 下各写一个 CMakeLists.txt 文件。为了方便，可以将 math 目录的文件编译成静态库，再由 main 函数调用

根目录下的 CMakeLists.txt 文件如下：

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```
# CMake 最低版本号要求
cmake_minimum_required (VERSION 2.8)
# 项目信息
project (Demo3)
# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_SRCS 变量
aux_source_directory(. DIR_SRCS)
# 添加头文件路径
include_directories("${PROJECT_SOURCE_DIR}/math")
# 添加 math 子目录
add_subdirectory(math)
# 指定生成目标
add_executable(Demo main.c)
# 添加链接库
target_link_libraries(Demo MathFunctions)

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

该文件添加了下面的内容: 使用命令 include_directories 添加头文件路径。使用命令 add_subdirectory 指明本项目包含一个子目录 math，这样 math 目录下的 CMakeLists.txt 文件和源代码也会被处理 。使用命令 target_link_libraries 指明可执行文件 main 需要连接一个名为 MathFunctions 的链接库 。

子目录的 CMakeList.txt 如下：

```
# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_LIB_SRCS 变量
aux_source_directory(. DIR_LIB_SRCS)
# 生成链接库
add_library (MathFunctions ${DIR_LIB_SRCS})

```

在该文件中使用命令 add_library 将 src 目录中的源文件编译为静态链接库。在该文件中使用命令 add_library 将 src 目录中的源文件编译为静态链接库。