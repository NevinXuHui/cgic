---
url: https://zhuanlan.zhihu.com/p/100367053
title: cmake：交叉编译
date: 2023-09-22 17:53:02
tag: 
banner: "https://pic1.zhimg.com/v2-54b6fbe55723f99b90e670a7a5af0b7c_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
**概念**

我们在 PC 上进行开发时，需要使用编译器和链接器生成能够在我们机器上运行的可执行程序。但是当涉及到嵌入式开发时，情况就不同了。因为嵌入式设备的资源（CPU、RAM 等）无法和 PC 相比，在设备上构建编译系统很麻烦或者根本不可能构建。因此通常做法是在 PC 上使用**交叉编译工具链**生成能够在嵌入式设备运行的可执行程序，然后再将程序放到设备中去执行。

此为交叉编译。一般称 PC 为 **主机**，嵌入式设备为**目标机**。

### **编写脚本**

使用 `cmake` 进行交叉编译，只需几条命令即可。

```
set(CMAKE_SYSTEM_NAME Linux)
​
set(TOOLCHAIN_PATH /OPT/gcc-arm-linux-gnueabi)
set(CMAKE_C_COMPILER ${tools}/bin/arm-linux-gnueabi-gcc)
set(CMAKE_CXX_COMPILER ${tools}/bin/arm-linux-gnueabi-g++)

```

`set(CMAKE_SYSTEM_NAME Linux)`：**该指令必须存在**，其目的是设置目标机使用的操作系统名称，支持`Linux`，`QNX`，`WindowsCE`，`Android`等。如果没有操作系统，那么就写 `Generic`。执行该指令后，`cmake` 变量——`CMAKE_CROSSCOMPILING` 会自动被设置为 `TRUE`，此时 `cmake` 就会 “知道 “现在执行的是交叉编译；

由于 `cmake` 无法自动获取目标机器信息，因此需要显式指明编译工具。

`CMAKE_C_COMPILER`：设置 C 编译器；

`CMAKE_CXX_COMPILER`：设置 c++ 编译器

### **使用方式**

1.  将上述 4 条指令保存在 `xxx.cmake` 文件中，比如 `CrossCompile.cmake`；
2.  使用 `cmake -DCMAKE_TOOLCHAIN_FILE= path/CrossCompile.cmake src-path` 构建编译系统；
3.  执行 `make` 指令；

注意：**上述命令必须写入脚本中，使用 `-DCMAKE_TOOLCHAIN_FILE=xxx.cmake` 的方式使用。不能直接写入 `CMakeLists.txt` 或使用 `include(xx.cmake)` 。**

### **测试例程**

**目录结构：**

```
sdc@ubuntu:~/cross-compile$ tree .
.
├── build
├── CMakeLists.txt
├── CrossCompile.cmake
└── main.c
​
1 directory, 3 files

```

**结果：**

![](https://pic4.zhimg.com/v2-2951b9119eeb4c9308883e6ef7d83bcb_r.jpg)

**其他说明**

通常，我们在开发时，需要使用系统库或第三方库的功能，在生成可执行文件时，将其进行链接。`cmake` 提供了 `FIND_PROGRAM()`，`FIND_LIBRARY()`， `FIND_FILE()`， `FIND_PATH()` 和 `FIND_PACKAGE()` 实现相应的查找功能。如果我们在进行**交叉编译**时使用了上述指令，那么并不能生成可执行文件。因为默认情况下，上述指令查找的是**主机**上的相关文件，其并不适用于**目标机器**。还好，`cmake` 为我们提供了相应的变量：

`CMAKE_FIND_ROOT_PATH`：设置其值为一系列的目录（`set(CMAKE_FIND_ROOT_PATH path1 path2 path3 ...)`，这样在执行 `FIND_XXX()` 指令时就会从这一系列的目录中进行查找。

跟随该变量的有下述 3 个变量，它们的值为 `NEVER` 、 `ONLY` 或 `BOTH`：

`CMAKE_FIND_ROOT_PATH_MODE_PROGRAM`：如果设置为 `NEVER`，那么 `CMAKE_FIND_ROOT_PATH` 就不会对 `FIND_PROGRAM()` 产生影响， `FIND_PROGRAM()` 不会在 `CMAKE_FIND_ROOT_PATH` 指定的目录中寻找；如果设置为 `ONLY`，那么 `FIND_PROGRAM()` 只会从`CMAKE_FIND_ROOT_PATH` 指定的目录中寻找；如果设置为 `BOTH`，那么 `FIND_PROGRAM()` 会优先从 `CMAKE_FIND_ROOT_PATH` 指定的目录中寻找，再从默认的目录中寻找。

因为 `FIND_PROGRAM()` 大部分情况下用于寻找可执行程序，给后续的 `EXECUTE_PROCESS()` 或 `ADD_CUSTOM_COMMAND()` 指令使用。并且，只有**主机**在生成编译文件时使用该可执行程序。因此通常设置 `CMAKE_FIND_ROOT_PATH_MODE_PROGRAM` 为 `NEVER`（`set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER）`；

`CMAKE_FIND_ROOT_PATH_MODE_LIBRARY`：由于在进行交叉编译，所以只能使用 `FIND_LIBRARY()` 查找符合目标机器的库文件，因此设置该变量值为`ONLY`(`set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)`)，表示只从 `CMAKE_FIND_ROOT_PATH` 指定的目录中查找；

`CMAKE_FIND_ROOT_PATH_MODE_INCLUDE`：同上，将其值设置为 `ONLY`。

### **参考（请仔细阅读）**

[https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/CrossCompiling](https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/CrossCompiling)

[https://blog.kitware.com/cross-compiling-for-raspberry-pi/](https://blog.kitware.com/cross-compiling-for-raspberry-pi/)