---
url: https://blog.csdn.net/fengbingchun/article/details/128292359
title: CMake 中 link_directories_target_link_directories 的使用_fengbingchun 的博客 - CSDN 博客
date: 2023-08-13 18:59:32
tag: 
banner: "https://images.unsplash.com/photo-1689615056295-7a1aff1b304d?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxOTI0MzY2fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
      CMake 中的 **link_directories 命令用于添加目录使链接器能在其查找库** (add directories in which the linker will look for libraries)，其格式如下：

```
link_directories([AFTER|BEFORE] directory1 [directory2 ...])

```

      添加路径使链接器应在其中搜索库。**提供给此命令的相对路径被解释为相对于当前源目录**。  
      **该命令只适用于在它被调用后创建的 target**。  
      **这些目录将添加到当前 CMakeLists.txt 文件的 LINK_DIRECTORIES 目录属性中**，并根据需要将相对路径转换为绝对路径。  
      默认情况下，指定的目录将追加到当前目录列表中。可以通过将 CMAKE_LINK_DIRECTORIES_BEFORE 设置为 ON 来更改此默认行为。通过显式使用 AFTER 或 BEFORE，你可以在追加和前置之间 (between appending and prepending) 进行选择，而与默认值无关。  
      link_directories 的参数可以使用语法为 "$<...>" 的 "生成器表达式"。  
      注意：**此命令很少是必需的，在有其它选择的情况下应避免使用**。在可能的情况下，最好将完整的绝对路径传递给库，因为这可确保始终链接正确的库。find_library 命令提供完整路径，通常可以直接用于调用 target_link_libraries 命令。可能需要库搜索路径的情况包括：  
      (1). 像 Xcode 这样的项目生成器 (project generators), 用户可以在构建时切换目标架构 (target architecture), 但不能使用库的完整路径, 因为它只提供一种架构 (即它不是通用的二进制文件)。  
      (2). 库本身可能还有其它通过 RPATH 机制找到的私有库依赖项，但是某些链接器无法完全解码这些路径 (例如，由于存在 $ORIGIN 之类的东西)。  
      如果必须提供库搜索路径，则最好**尽可能使用 target_link_directories 命令**，而不是 link_directories 命令来本地化效果。特定于 target 的命令还可以控制搜索目录如何传播到其它依赖 targets。

```
link_directories(/A)
link_directories(BEFORE /B)
set(CMAKE_LINK_DIRECTORIES_BEFORE ON)
link_directories(/C)
 
get_directory_property(result LINK_DIRECTORIES)
message("result: ${result}") # result: /C;/B;/A
 
add_executable(main EXCLUDE_FROM_ALL samples/sample_subtraction.cpp)
target_include_directories(main PUBLIC include)
 
add_library(subtraction SHARED source/subtraction.cpp)
target_include_directories(subtraction PUBLIC include)
 
target_link_libraries(main subtraction)
 
get_target_property(result2 main LINK_DIRECTORIES)
message("result2: ${result2}") # result2: /C;/B;/A
```

      CMake 中的 **target_link_directories 命令用于将链接目录添加到 target**，其格式如下：

```
target_link_directories(<target> [BEFORE]
  <INTERFACE|PUBLIC|PRIVATE> [items1...]
  [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])
```

      **指定链接器在链接给定 target 时应在其中搜索库的路径**。**每项 (each item) 可以是绝对路径或相对路径**, 后者被解释为相对于当前源目录。这些项将被添加到链接命令中。  
      **命名的 <target> 必须由诸如 add_executable 或 add_library 之类的命令创建**，并且不能为 ALIAS target。  
      需要 INTERFACE, PUBLIC 和 PRIVATE 关键字来指定它们后面的项的作用域 (scope).PRIVATE 和 PUBLIC 项将填充 < target > 的 LINK_DIRECTORIES 属性。PUBLIC 和 INTERFACE 项将填充 < target > 的 INTERFACE_LINK_DIRECTORIES 属性 (IMPORTED targets 仅支持 INTERFACE 项)。每个项指定一个链接目录，如有必要，在将其添加到相关属性之前，将转换为绝对路径。重复调用相同的 < target > 会按调用顺序追加项。  
      如果指定 BEFORE，则内容 (content) 将被添加到相关属性的前面，而不是被追加。  
      target_link_directories 的参数可以使用语法为 $<...> 的 "生成器表达式"。  
      注意：**此命令很少是必需的，在有其它选择的情况下应避免使用**。在可能的情况下，最好将完整的绝对路径传递给库，因为这可确保始终链接正确的库。find_library 命令提供完整路径，通常可以直接用于调用 target_link_libraries 命令。可能需要库搜索路径的情况包括：  
      (1). 像 Xcode 这样的项目生成器 (project generators), 用户可以在构建时切换目标架构 (target architecture), 但不能使用库的完整路径, 因为它只提供一种架构 (即它不是通用的二进制文件)。  
      (2). 库本身可能还有其它通过 RPATH 机制找到的私有库依赖项，但是某些链接器无法完全解码这些路径 (例如，由于存在 $ORIGIN 之类的东西)。

```
add_executable(main EXCLUDE_FROM_ALL samples/sample_subtraction.cpp)
target_include_directories(main PUBLIC include)
 
add_library(subtraction SHARED EXCLUDE_FROM_ALL source/subtraction.cpp)
target_include_directories(subtraction PUBLIC include)
 
target_link_libraries(main subtraction)
 
target_link_directories(main PRIVATE /private/dir INTERFACE /interface/dir)
get_target_property(result main LINK_DIRECTORIES)
message("result: ${result}") # result: /private/dir
get_target_property(result main INTERFACE_LINK_DIRECTORIES)
message("result: ${result}") # result: /interface/dir
 
target_link_directories(subtraction PUBLIC /public/dir INTERFACE /interface/dir)
get_target_property(result subtraction LINK_DIRECTORIES)
message("reuslt: ${result}") # reuslt: /public/dir
 
# test no items
target_link_directories(main PRIVATE)
```

      **执行测试代码需要多个文件**：

      build.sh 内容如下：

```
#! /bin/bash
 
# supported input parameters(cmake commands)
params=(function macro cmake_parse_arguments \
		find_library find_path find_file find_program find_package \
		cmake_policy cmake_minimum_required project include \
		string list set foreach message option if while return \
		math file configure_file \
		include_directories add_executable add_library target_link_libraries install \
		target_sources add_custom_command add_custom_target \
		add_subdirectory aux_source_directory \
		set_property set_target_properties define_property \
		add_definitions target_compile_definitions target_compile_features \
		add_compile_options target_include_directories link_directories)
 
usage()
{
	echo "Error: $0 needs to have an input parameter"
 
	echo "supported input parameters:"
	for param in ${params[@]}; do
		echo "  $0 ${param}"
	done
 
	exit -1
}
 
if [ $# != 1 ]; then
	usage
fi
 
flag=0
for param in ${params[@]}; do
	if [ $1 == ${param} ]; then
		flag=1
		break
	fi
done
 
if [ ${flag} == 0 ]; then
	echo "Error: parameter \"$1\" is not supported"
	usage
	exit -1
fi
 
if [[ ! -d "build" ]]; then
	mkdir build
	cd build
else
	cd build
fi
 
echo "==== test $1 ===="
 
# test_set.cmake: cmake -DTEST_CMAKE_FEATURE=$1 --log-level=verbose ..
# test_option.cmake: cmake -DTEST_CMAKE_FEATURE=$1 -DBUILD_PYTORCH=ON ..
cmake -DTEST_CMAKE_FEATURE=$1 ..
# It can be executed directly on the terminal, no need to execute build.sh, for example: cmake -P test_set.cmake
make
# make install # only used in cmake files with install command
```

      主 [CMakeLists](https://so.csdn.net/so/search?q=CMakeLists&spm=1001.2101.3001.7020).txt 内容如下：

```
cmake_minimum_required(VERSION 3.22)
project(cmake_feature_usage)
 
message("#### current cmake version: ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}")
include(test_${TEST_CMAKE_FEATURE}.cmake)
message("==== test finish ====")
```

      test_link_directories.cmake 内容为上面的所有测试代码段

      另外还包括三个目录：include,source,samples, 它们都是非常简单的实现，仅用于测试，如下：

![](https://img-blog.csdnimg.cn/30d18fe69c9846e1a08f70d8066d70a4.png)

      可能的执行结果如下图所示:

![](https://img-blog.csdnimg.cn/4b41a16498eb4536a64aac09aa04b121.png)

 

      **GitHub**： [https://github.com/fengbingchun/Linux_Code_Test](https://github.com/fengbingchun/Linux_Code_Test "https://github.com/fengbingchun/Linux_Code_Test")