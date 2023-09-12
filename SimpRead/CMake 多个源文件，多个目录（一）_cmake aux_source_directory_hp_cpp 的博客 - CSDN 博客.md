---
url: https://blog.csdn.net/hp_cpp/article/details/110392878
title: CMake 多个源文件，多个目录（一）_cmake aux_source_directory_hp_cpp 的博客 - CSDN 博客
date: 2023-08-13 18:59:51
tag: 
banner: "https://images.unsplash.com/photo-1689571171604-888a8ed23110?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxOTI0Mzg2fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
目录结构：  

![](https://img-blog.csdnimg.cn/20201130171432700.png)

hello.h

```
#ifndef HELLO_H
#define HELLO_H
#include <iostream>

void hello();

#endif

```

hello.cpp

```
#include "hello.h"

void hello(){
    std::cout << "Hello " << std::endl;
}

```

world.h

```
#ifndef WORLD_H
#define WORLD_H
#include <iostream>

void world();

#endif

```

world.cpp

```
#include "world.h"

void world() {
    std::cout << "world\n" << std::endl;
}

```

main.cpp

```
#include "hello/hello.h"
#include "world/world.h"

int main(int argc, char *argv[])
{
   hello();
   world();
   return 0;
}

```

注意这里的头文件，引入相对路径，否则会报找不到该头文件。  
如果不想这样添加头文件，可以用这个方式 [CMake 系列之四：多个源文件 - 多个目录](https://www.cnblogs.com/wuchaodzxx/p/8916009.html)  
接下来我也会介绍这种方式。

CMakeLists.txt

```
# CMake 最低版本号要求
cmake_minimum_required(VERSION 3.5)

# 设置工程名
project (hello_cmake)

aux_source_directory(${PROJECT_SOURCE_DIR} DIR_MAIN_SRCS)

aux_source_directory(${PROJECT_SOURCE_DIR}/hello DIR_HELLO_SRCS)

aux_source_directory(${PROJECT_SOURCE_DIR}/world DIR_WORLD_SRCS)

# 指定生成目标
add_executable(hello_cmake ${DIR_MAIN_SRCS} ${DIR_HELLO_SRCS} ${DIR_WORLD_SRCS})


```

接着就是输入命令：

```
cd build
cmake ..
make

```

运行结果：  

![](https://img-blog.csdnimg.cn/20201130172323602.png)

参考：  
[CMake 入门 - 02-HelloWorld 扩展 (示例代码)](https://www.136.la/tech/show-1357467.html)

[CMake 系列之四：多个源文件 - 多个目录](https://www.cnblogs.com/wuchaodzxx/p/8916009.html)