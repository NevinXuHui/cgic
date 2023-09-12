---
url: https://blog.csdn.net/GeomasterYi/article/details/131216841
title: vscode 配置 clangd 和 clang-format_clangd vscode_geocat 的博客 - CSDN 博客
date: 2023-08-14 23:08:31
tag: 
banner: "https://images.unsplash.com/photo-1690382285917-73dfd2a22d07?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkyMDI1NzA2fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
# vscode 安装和配置

如何安装和配置 vscode 以搭建 c++ 开发环境，可以查看我的另一篇博客：[Windows 上最轻量的 vscode-C++ 开发环境搭建](https://blog.csdn.net/GeomasterYi/article/details/123146294)。

在这篇博客中，详细介绍了如何[安装 vscode](https://so.csdn.net/so/search?q=%E5%AE%89%E8%A3%85vscode&spm=1001.2101.3001.7020) 以及应该安装哪些插件。这里不再赘述。

vscode 中想使用 clangd 来作为语言服务器、clang-format 来作为代码格式化工具，还需要额外安装以下两个插件：

![](https://img-blog.csdnimg.cn/2ec7bf584c2245c8981d581e946681e5.png)

  

clangd 插件

![](https://img-blog.csdnimg.cn/ec5b41c7d9c34a029a57a8c358a7b56d.png)

  

clang-format 插件

关于什么是 clangd，什么是 clang-format，这里做一下总结性说明：

`clangd` : 代码服务器，提供基础的代码跳转、代码补全等功能；

`clang-format`: 代码格式化器，当我们使用编辑器对代码进行格式化时，需要提供一个代码格式化器，用来对我们的代码进行格式化。

```
格式化的意思是：该缩进的地方缩进，该对齐的地方对齐，以使我们的代码看起来更加整洁和干净。

``` 

# clangd 配置

想要使用`clangd`作为语言服务器，一些必要的配置是少不了的。本文中，假设`工作空间`文件夹是`my_project`，文件目录结构如下：

```
my_project
    |-- include
        |-- a.h
        |-- b.h
        |-- c.hpp
    |-- source
        |-- a.cpp
        |-- b.cpp
        |-- d.cpp
    |-- CMakeLists.txt

```

这是一个最简单的基于 cmake 构建系统的 c++ 工程结构。其中，`include`文件夹是项目的头文件目录；`source`文件夹是项目的源文件目录；`CMakeLists.txt`是 cmake 构建的入口文件。

## 1. clangd 可执行文件下载

在使用`clangd`之前，需要先下载`clangd`的可执行文件。

1.  如果是在 linux 上，直接运行以下命令进行安装：

```
  sudo apt install clangd

```

2.  如果是在 windows 上，则在[这里](https://github.com/clangd/clangd/releases)下载。

![](https://img-blog.csdnimg.cn/3a1551d9acc7473f9770132dbde4ce70.png)

  

clangd 下载页

## 2. vscode 配置 clangd 插件

在上面的示例工程下，新建`.vscode/settings.json`文件，或者按下`F1`并输入`settings`，选择`首选项：打开工作区设置(json)`，如下图所示：

![](https://img-blog.csdnimg.cn/756bba1310214648ab1f70d056fe224b.png)

  

就会在当前工作目录下创建当前工作区的设置文件，这个文件是专门针对当前工作区的设置文件，里面的设置项会取代全局的设置项，从而只在当前工作区生效。

vscode 的`clangd`插件有如下配置项：

1.  `clangd.fallbackFlags`: 设置头文件搜索路径
    
2.  `clangd.path`: clangd 的可执行文件路径
    
3.  `clangd.arguments`: clangd 服务运行时传递给可执行文件的参数
    
4.  `clangd.detectExtensionConflicts`: 设置 clangd 是否检测扩展的冲突
    
5.  `clangd.serverCompletionRanking`: 设置是否在键入时，对补全结果进行排序。
    

clangd 的其他选项没有那么重要，这里就不一一列举。

一个稍显完整的 clangd 配置如下：

```
{
    "clangd.fallbackFlags": [
        "-I${workspaceFolder}/include"
    ],
    // "clangd.path": "the/path/to/clangd/executable/on/windows",
    "clangd.detectExtensionConflicts": true,
    "clangd.arguments": [
        // 在后台自动分析文件（基于complie_commands)
        "--background-index",
        // 标记compelie_commands.json文件的目录位置
        "--compile-commands-dir=build",
        // 同时开启的任务数量
        "-j=12",
        // 告诉clangd用那个clang进行编译，路径参考which clang++的路径
        // "--query-driver=/usr/bin/clang++",
        // clang-tidy功能
        "--clang-tidy",
        "--clang-tidy-checks=performance-*,bugprone-*",
        // 全局补全（会自动补充头文件）
        "--all-scopes-completion",
        // 更详细的补全内容
        "--completion-style=detailed",
        // 补充头文件的形式
        "--header-insertion=iwyu",
        // pch优化的位置
        "--pch-storage=disk"
    ],
    "clangd.serverCompletionRanking": true,
}

```

以上`clangd`的配置中有两个地方需要注意：

1.  fallbackFlags 数组中，每一项前面都需要加上`-I`;
    
2.  arguments 数组中，compile-commands-dir 选项的值，一般为 cmake 的构建目录。cmake 在构建时可以选择输出 compile-commands.json，具体如何开启不在本文的范围内，可自行百度。
    

clangd 的具体参数解释，可以在命令行输入`clangd --help`进行查看。

# clang-format 配置

`clang-format`是`llvm`提供的代码格式化工具，使用该工具，可以按照设定的`规则`来进行代码的格式化，比如：

花括号后是否回车？

指针和引用的符号，是居中对齐？[左对齐](https://so.csdn.net/so/search?q=%E5%B7%A6%E5%AF%B9%E9%BD%90&spm=1001.2101.3001.7020)？还是右对齐？

…

通过配置 clang-format 的格式化规则，可以以各种各样的风格来格式化代码。同时，clang-format 提供了对`C/C++/Java/JavaScript/JSON/Objective-C/Protobuf/C#`等代码的格式化功能。

clang-format 默认提供了 7 中风格的格式化，分别为：`LLVM`、`GNU`、`Google`、`Chromium`、`Microsoft`、`Mozilla`、`Webkit`。令行里通过`clang-format --help`，可以看到`--style`的说明。

clang-format 的官方文档地址为：[clang-format 官方文档](https://clang.llvm.org/docs/ClangFormat.html)。

## 1. .clang-format

.clang-format 文件，是 clang-format 格式化器所使用的格式化配置文件，当使用 vscode 进行当前工作目录的代码格式化时，这个文件的配置就是我们格式化的依据。

clang-format 程序，提供了一种快速生成. clang-format 文件的命令，命令如下：

```
clang-format -style=llvm -dump-config > .clang-format

```

这条命令会在当前目录下生成一个. clang-format 文件，其中的`-style=llvm`的意思是，生成的. clang-format 文件，是 [llvm](https://so.csdn.net/so/search?q=llvm&spm=1001.2101.3001.7020) 风格的。

clang-format 的`-style`选项支持两种方式：`=file`和`=llvm之类`，其中`=file`需要将`.clang-format`文件或者`_clang-format`文件放到工程目录下。.clang-format 文件使用`YAML`格式，如下所示：

```
key1 : value1
key2 : value2
# 注释

```

配置文件可以使用`language:`参数表示不同的编程语言的配置区间，每一个`language：`参数都将配置文件分割为各自编程语言的配置。多语言配置的. clang-format 文件的示例如下：

```
---
# 表示当前配置文件是基于llvm风格的
BasedOnStyle: LLVM
# 默认的缩进宽度是4个空格
IndentWidth: 4
---
# 当前配置语言的区段是c++
Language: Cpp
DerivePointerAlignment: false
# 指针的对齐方式为左对齐
PointerAlignment: Left
---
# 当前配置语言为JS
Language: JavaScript
# 代码列数的最大值为100
ColumnLimit: 100
---
# 当前配置语言为protobuf
Language: Proto
# 表示不格式化protobuf代码
DisableFormat: true
---
# 表示当前语言为 c#
Language: CSharp
# 表示c#代码的单行字符限制为100
ColumnLimit: 100
...

```

选项的官方文档地址为：[.clang-format 选项的官方文档地址](https://clang.llvm.org/docs/ClangFormatStyleOptions.html)。

一个配置好的 C++ 的格式化配置文件如下：

以下配置文件，是从网上下载后，经过自己修改过的配置。具体编码规范，还是要根据自己公司的来，不要生搬硬套。

```
---
# 语言: None, Cpp, Java, JavaScript, ObjC, Proto, TableGen, TextProto
Language: Cpp
BasedOnStyle: LLVM
# 访问说明符(public、private等)的偏移
AccessModifierOffset: -4
# 开括号(开圆括号、开尖括号、开方括号)后的对齐: Align, DontAlign, AlwaysBreak(总是在开括号后换行)
AlignAfterOpenBracket: AlwaysBreak
# 连续赋值时，对齐所有等号
AlignConsecutiveAssignments: true
# 连续声明时，对齐所有声明的变量名
AlignConsecutiveDeclarations: true
 
AlignEscapedNewlines: Right
 
# 左对齐逃脱换行(使用反斜杠换行)的反斜杠
AlignEscapedNewlinesLeft: false
# 水平对齐二元和三元表达式的操作数
AlignOperands: true
# 对齐连续的尾随的注释
AlignTrailingComments: true
 
# 允许函数声明的所有参数在放在下一行
AllowAllParametersOfDeclarationOnNextLine: true
# 允许短的块放在同一行
AllowShortBlocksOnASingleLine: false
# 允许短的case标签放在同一行
AllowShortCaseLabelsOnASingleLine: false
# 允许短的函数放在同一行: None, InlineOnly(定义在类中), Empty(空函数), Inline(定义在类中，空函数), All
AllowShortFunctionsOnASingleLine: All
# 允许短的if语句保持在同一行
AllowShortIfStatementsOnASingleLine: false
# 允许短的循环保持在同一行
AllowShortLoopsOnASingleLine: false
 
# 总是在定义返回类型后换行(deprecated)
AlwaysBreakAfterDefinitionReturnType: None
# 总是在返回类型后换行: None, All, TopLevel(顶级函数，不包括在类中的函数), 
#   AllDefinitions(所有的定义，不包括声明), TopLevelDefinitions(所有的顶级函数的定义)
AlwaysBreakAfterReturnType: None
# 总是在多行string字面量前换行
AlwaysBreakBeforeMultilineStrings: false
# 总是在template声明后换行
AlwaysBreakTemplateDeclarations: true
# false表示函数实参要么都在同一行，要么都各自一行
BinPackArguments: true
# false表示所有形参要么都在同一行，要么都各自一行
BinPackParameters: false
# 大括号换行，只有当BreakBeforeBraces设置为Custom时才有效
BraceWrapping:   
  # class定义后面
  AfterClass: true
  # 控制语句后面
  AfterControlStatement: false
  # enum定义后面
  AfterEnum: true
  # 函数定义后面
  AfterFunction: true
  # 命名空间定义后面
  AfterNamespace: false
  # ObjC定义后面
  AfterObjCDeclaration: false
  # struct定义后面
  AfterStruct: true
  # union定义后面
  AfterUnion: true
 
  AfterExternBlock: false
  # catch之前
  BeforeCatch: true
  # else之前
  BeforeElse: true
  # 缩进大括号
  IndentBraces: false
  SplitEmptyFunction: true
  SplitEmptyRecord: true
  SplitEmptyNamespace: true
 
# 在二元运算符前换行: None(在操作符后换行), NonAssignment(在非赋值的操作符前换行), All(在操作符前换行)
BreakBeforeBinaryOperators: None
# 在大括号前换行: Attach(始终将大括号附加到周围的上下文), Linux(除函数、命名空间和类定义，与Attach类似), 
#   Mozilla(除枚举、函数、记录定义，与Attach类似), Stroustrup(除函数定义、catch、else，与Attach类似), 
#   Allman(总是在大括号前换行), GNU(总是在大括号前换行，并对于控制语句的大括号增加额外的缩进), WebKit(在函数前换行), Custom
#   注：这里认为语句块也属于函数
BreakBeforeBraces: Custom
# 在三元运算符前换行
BreakBeforeTernaryOperators: false
 
# 在构造函数的初始化列表的逗号前换行
BreakConstructorInitializersBeforeComma: true
BreakConstructorInitializers: BeforeColon
# 每行字符的限制，0表示没有限制
ColumnLimit: 0
# 描述具有特殊意义的注释的正则表达式，它不应该被分割为多行或以其它方式改变
CommentPragmas: '^ IWYU pragma:'
CompactNamespaces: false
# 构造函数的初始化列表要么都在同一行，要么都各自一行
ConstructorInitializerAllOnOneLineOrOnePerLine: true
# 构造函数的初始化列表的缩进宽度
ConstructorInitializerIndentWidth: 4
# 延续的行的缩进宽度
ContinuationIndentWidth: 4
# 去除C++11的列表初始化的大括号{后和}前的空格
Cpp11BracedListStyle: false
# 继承最常用的指针和引用的对齐方式
DerivePointerAlignment: false
# 关闭格式化
DisableFormat: false
# 自动检测函数的调用和定义是否被格式为每行一个参数(Experimental)
ExperimentalAutoDetectBinPacking: false
# 需要被解读为foreach循环而不是函数调用的宏
ForEachMacros: [ foreach, Q_FOREACH, BOOST_FOREACH ]
# 对#include进行排序，匹配了某正则表达式的#include拥有对应的优先级，匹配不到的则默认优先级为INT_MAX(优先级越小排序越靠前)，
#   可以定义负数优先级从而保证某些#include永远在最前面
IncludeCategories: 
  - Regex: '^"(llvm|llvm-c|clang|clang-c)/'
    Priority: 2
  - Regex: '^(<|"(gtest|isl|json)/)'
    Priority: 3
  - Regex: '.*'
    Priority: 1
# 缩进case标签
IndentCaseLabels: true
 
IndentPPDirectives:  AfterHash
# 缩进宽度
IndentWidth: 4
# 函数返回类型换行时，缩进函数声明或函数定义的函数名
IndentWrappedFunctionNames: false
# 保留在块开始处的空行
KeepEmptyLinesAtTheStartOfBlocks: false
# 开始一个块的宏的正则表达式
MacroBlockBegin: ''
# 结束一个块的宏的正则表达式
MacroBlockEnd: ''
# 连续空行的最大数量
MaxEmptyLinesToKeep: 1
# 命名空间的缩进: None, Inner(缩进嵌套的命名空间中的内容), All
NamespaceIndentation: None
# 使用ObjC块时缩进宽度
ObjCBlockIndentWidth: 4
# 在ObjC的@property后添加一个空格
ObjCSpaceAfterProperty: false
# 在ObjC的protocol列表前添加一个空格
ObjCSpaceBeforeProtocolList: true
 
 
# 在call(后对函数调用换行的penalty
PenaltyBreakBeforeFirstCallParameter: 19
# 在一个注释中引入换行的penalty
PenaltyBreakComment: 300
# 第一次在<<前换行的penalty
PenaltyBreakFirstLessLess: 120
# 在一个字符串字面量中引入换行的penalty
PenaltyBreakString: 1000
# 对于每个在行字符数限制之外的字符的penalty
PenaltyExcessCharacter: 1000000
# 将函数的返回类型放到它自己的行的penalty
PenaltyReturnTypeOnItsOwnLine: 60
 
# 指针和引用的对齐: Left, Right, Middle
PointerAlignment: Left
# 允许重新排版注释
ReflowComments: true
# 允许排序#include
SortIncludes: true
 
# 在C风格类型转换后添加空格
SpaceAfterCStyleCast: false
 
SpaceAfterTemplateKeyword: true
 
# 在赋值运算符之前添加空格
SpaceBeforeAssignmentOperators: true
# 开圆括号之前添加一个空格: Never, ControlStatements, Always
SpaceBeforeParens: ControlStatements
# 在空的圆括号中添加空格
SpaceInEmptyParentheses: false
# 在尾随的评论前添加的空格数(只适用于//)
SpacesBeforeTrailingComments: 2
# 在尖括号的<后和>前添加空格
SpacesInAngles: false
# 在容器(ObjC和JavaScript的数组和字典等)字面量中添加空格
SpacesInContainerLiterals: false
# 在C风格类型转换的括号中添加空格
SpacesInCStyleCastParentheses: false
# 在圆括号的(后和)前添加空格
SpacesInParentheses: false
# 在方括号的[后和]前添加空格，lamda表达式和未指明大小的数组的声明不受影响
SpacesInSquareBrackets: false
# 标准: Cpp03, Cpp11, Auto
Standard: Cpp11
# tab宽度
TabWidth: 4
# 使用tab字符: Never, ForIndentation, ForContinuationAndIndentation, Always
UseTab: Never

```

## 2. vscode 关于 clang-format 的设置

首先当然是要下载 clang-format 的可执行文件：

1.  linux 上直接使用`sudo apt install clang-format`进行下载
    
2.  windows 上，可以通过 msys2 下载 llvm 编译器（具体操作不做赘述），也可以在 llvm 的 [github 仓库](https://hub.njuu.cf/llvm/llvm-project/releases/tag/llvmorg-16.0.6)里下载。下载内容如下：
    

![](https://img-blog.csdnimg.cn/0d50c41507014ec38c5301f0670bf236.png)

  

llvm 下载内容

下载完 llvm 的 windows 安装包之后，在 bin 目录下，有`clang-format.exe`文件。然后在工程目录下的`.vscode/settings.json`文件中，指定 clang-format.exe 的绝对路径即可。配置如下所示：

```
{
    "clang-format.executable": "E:\\LLVM\\bin\\clang-format.exe"
}

```

但是只有上述内容还不够，除了上面一节提到的 clang-format 的配置文件`.clang-format`之外，还需要在工作目录的设置文件中，添加一下内容：

```
{
    "[cpp]": {
        // 在cpp文件中，编辑器在保存的时候进行格式化
        "editor.formatOnSave": true,
        // 在cpp文件中，编辑器在打字的时候进行格式化
        "editor.formatOnType": true,
        // 在cpp文件中，编辑器在粘贴的时候进行格式化
        "editor.formatOnPaste": true,
        // 在cpp文件中，编辑器的默认格式化器为 "xaver.clang-format"
        // 这里的"xaver.clang-format"就是我们安装的clang-format
        // vscode插件
        "editor.defaultFormatter": "xaver.clang-format"
    }
}

```

有了以上内容，我们在写 c++ 代码时，就可以享受到 clangd 作为语言服务器的快速跳转和自动补全的功能，以及 clang-format 的代码格式化功能。

# 总结

经过上述操作，我们最终的工作目录，应该有以下内容：

```
my_project
    |-- .vscode
        |-- settings.json
    |-- include
        |-- a.h
        |-- b.h
        |-- c.hpp
    |-- source
        |-- a.cpp
        |-- b.cpp
        |-- d.cpp
    |-- CMakeLists.txt
    |-- .clang-format

```

一个较为完整的 vscode 工作区设置文件，里面关于 clangd 和 clang-format 的设置应该有以下内容：

```
{
    // 使用clangd作为语言服务器是，会与微软的智能感知引擎产生冲突
    // 想使用clangd，就需要禁用微软的只能感知引擎。
    "C_Cpp.intelliSenseEngine": "disabled",
    "[cpp]": {
        "editor.formatOnSave": true,
        "editor.formatOnType": true,
        "editor.formatOnPaste": true,
        "editor.defaultFormatter": "xaver.clang-format"
    },
    "clangd.fallbackFlags": [
        // 工作区的头文件包含路径的数组
        "-I${workspaceFolder}/include"
    ],
    "clangd.path": "clangd/executable/path",
    "clangd.detectExtensionConflicts": true,
    "clangd.arguments": [
        // 在后台自动分析文件（基于complie_commands)
        "--background-index",
        // 标记compelie_commands.json文件的目录位置
        "--compile-commands-dir=build",
        // 同时开启的任务数量
        "-j=12",
        // clang-tidy功能
        "--clang-tidy",
        "--clang-tidy-checks=performance-*,bugprone-*",
        // 全局补全（会自动补充头文件）
        "--all-scopes-completion",
        // 更详细的补全内容
        "--completion-style=detailed",
        // 补充头文件的形式
        "--header-insertion=iwyu",
        // pch优化的位置
        "--pch-storage=disk"
    ],
    "clangd.serverCompletionRanking": true,
    "clang-format.executable": "path/to/clang-foramt/executable"
}

```

clangd 作为语言服务器，其在代码跳转上，比微软出的 c/c++ 插件速度快得多。同时，使用 clang-format 进行代码格式化，可以根据我们自己公司的代码规范进行配置，使我们可以更加专注于业务功能的开发，而不必在代码格式的细节上花费过多时间。