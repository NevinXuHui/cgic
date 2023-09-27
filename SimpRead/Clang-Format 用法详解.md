---
url: https://zhuanlan.zhihu.com/p/641846308
title: Clang-Format 用法详解
date: 2023-08-15 12:24:37
tag: 
banner: "https://pic1.zhimg.com/v2-8d4cee6f097296c8994dff15f4525a4b_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
关注微信公众号：Linux 内核拾遗  
文章来源：[Clang-Format 用法详解](https://mp.weixin.qq.com/s/mwMsffSrouPaswzG9rgdmg)[Clang-Format 用法详解](https://mp.weixin.qq.com/s/mwMsffSrouPaswzG9rgdmg)

## **1 引言**

## **1.1 编码风格的重要性**

良好的编码风格是一种优化和改进软件开发过程的关键因素，对于构建可维护、可扩展和高质量的软件至关重要。一个良好的编码风格可以使代码更易于理解和阅读，减少阅读代码时的认知负担，提高团队合作的效率。通过一致的编码风格，可以减少代码冲突、合并和维护的难度，促进团队成员之间的无缝协作。此外，规范的编码风格有助于降低代码错误和潜在的漏洞，提高代码质量和可靠性。

## **1.2 clang-format 概述**

clang-format 是一个开源的代码格式化工具，它可以帮助程序员自动调整源代码的格式，以符合指定的编码风格规范。通过配置简单易懂的格式化选项，clang-format 可以在保持代码功能不变的情况下，自动处理缩进、空格、括号、逗号等细节，提高代码的可读性和一致性。无论是个人项目还是团队协作，clang-format 都是一个强大的工具，能够减轻代码审查和格式化的工作量，使代码维护更加高效。

## **2 clang-format 安装配置**

## **2.1 安装 clang-format**

对于 macOS 或者 Linux，可以在终端中使用相关的包管理器进行安装：

```
 # macOS上：
 brew install llvm
 # Linux上，以Ubuntu为例：
 apt install clang-format

```

安装完成后，你可以在命令行中运行`clang-format --version`来验证 clang-format 是否成功安装并查看版本信息。

## **2.2 配置 clang-format**

要配置 clang-format，你可以使用`.clang-format`文件或编辑器插件来定义格式化选项。

### **2.2.1 使用`.clang-format`文件**

1.  在项目根目录或源代码所在目录下创建一个名为`.clang-format`的文件。
2.  根据自己的编码风格偏好，在`.clang-format`文件中指定格式化选项，例如缩进、空格、括号风格等。
3.  可以使用官方文档中提供的样式选项或自定义选项来配置文件。
4.  保存`.clang-format`文件后，clang-format 会在格式化代码时自动读取这些选项。

### **2.2.2 使用编辑器插件**

以 VS Code 为例，搜索安装如下的插件（Extension），下载路径：[https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)。

![](https://pic4.zhimg.com/v2-443dbd7cdda7505f7158b27c45aecf43_r.jpg)

然后打开 “File -> Preferences -> Settings”，搜索 “format”，设置如图所示：

![](https://pic4.zhimg.com/v2-6cdcffb856a90d87bce2f4093383d9e7_r.jpg)

![](https://pic3.zhimg.com/v2-5d75b581db40e1566145d1d47ac246aa_r.jpg)

这样只要保存（Ctrl + S）就会调用 clang-format 程序去格式化代码了（当前目录或者更上级目录要存在 .clang-format）。

## **3 基本用法**

clang-format 可用于格式化（排版）多种不同语言的代码，其自带的排版格式主要有：LLVM, Google, Chromium, Mozilla, WebKit。但是自带的这几种排版格式可能并不满足个人编码习惯的全部要求，clang-format 也提供了使用自定义排版格式的功能。Ubuntu 上可以使用以下命令导出上述 5 种自带的排版格式，并且可以对其中某一个导出的文件进行修改，实现自定义格式化：

```
 clang-format -style=格式名 -dump-config > 文件名

```

其中，格式名的取值可以为 llvm, google, chromium, mozilla, webkit 中的任一种；文件名可以取任何名字，一般取. clang-format 或_clang-format，因为自定义的排版格式文件只有取这两种名字之一，才能被 clang-format 识别。

直接将修改后的文件放在和代码文件相同的文件夹中，并且设置格式化选项 - style=file，即可以使用自定义的排版格式。VS Code 只要将该文件放在和代码文件相同的（或者父级）文件夹中即可，不需要额外的设置。

一些使用示例如下：

```
 // 以LLVM代码风格格式化main.cpp, 结果输出到stdout
 clang-format -style=LLVM main.cpp
 // 以file中的代码风格格式化main.cpp, 结果直接写到main.cpp
 clang-format -style=file -i main.cpp
 // 当然也支持对指定行格式化，格式化main.cpp的第1，2行
 clang-format -lines=1:2 main.cpp

```

## **4 配置文件详解**

.clang-format 文件是用于配置 clang-format 的文件，采用基于 YAML 的格式。文件结构包括一系列的键值对，用于定义不同的格式化选项，其中格式化选项可以嵌套使用，形成层级结构。

.clang-format 配置文件的常用格式化选项含义如下：

```
 ---
 # 语言: None, Cpp, Java, JavaScript, ObjC, Proto, TableGen, TextProto
 Language:Cpp
 # BasedOnStyle:LLVM
 # 访问说明符(public、private等)的偏移
 AccessModifierOffset:-4
 # 开括号(开圆括号、开尖括号、开方括号)后的对齐: Align, DontAlign, AlwaysBreak(总是在开括号后换行)
 AlignAfterOpenBracket:Align
 # 连续赋值时，对齐所有等号
 AlignConsecutiveAssignments:true
 # 连续声明时，对齐所有声明的变量名
 AlignConsecutiveDeclarations:true
 # 左对齐逃脱换行(使用反斜杠换行)的反斜杠
 AlignEscapedNewlinesLeft:true
 # 水平对齐二元和三元表达式的操作数
 AlignOperands:true
 # 对齐连续的尾随的注释
 AlignTrailingComments:true
 # 允许函数声明的所有参数在放在下一行
 AllowAllParametersOfDeclarationOnNextLine:true
 # 允许短的块放在同一行
 AllowShortBlocksOnASingleLine:false
 # 允许短的case标签放在同一行
 AllowShortCaseLabelsOnASingleLine:false
 # 允许短的函数放在同一行: None, InlineOnly(定义在类中), Empty(空函数), Inline(定义在类中，空函数), All
 AllowShortFunctionsOnASingleLine:Empty
 # 允许短的if语句保持在同一行
 AllowShortIfStatementsOnASingleLine:false
 # 允许短的循环保持在同一行
 AllowShortLoopsOnASingleLine:false
 # 总是在定义返回类型后换行(deprecated)
 AlwaysBreakAfterDefinitionReturnType:None
 # 总是在返回类型后换行: None, All, TopLevel(顶级函数，不包括在类中的函数), 
 #   AllDefinitions(所有的定义，不包括声明), TopLevelDefinitions(所有的顶级函数的定义)
 AlwaysBreakAfterReturnType:None
 # 总是在多行string字面量前换行
 AlwaysBreakBeforeMultilineStrings:false
 # 总是在template声明后换行
 AlwaysBreakTemplateDeclarations:false
 # false表示函数实参要么都在同一行，要么都各自一行
 BinPackArguments:true
 # false表示所有形参要么都在同一行，要么都各自一行
 BinPackParameters:true
 # 大括号换行，只有当BreakBeforeBraces设置为Custom时才有效
 BraceWrapping:   
   # class定义后面
  AfterClass:false
   # 控制语句后面
  AfterControlStatement:false
   # enum定义后面
  AfterEnum:false
   # 函数定义后面
  AfterFunction:false
   # 命名空间定义后面
  AfterNamespace:false
   # ObjC定义后面
  AfterObjCDeclaration:false
   # struct定义后面
  AfterStruct:false
   # union定义后面
  AfterUnion:false
   # catch之前
  BeforeCatch:true
   # else之前
  BeforeElse:true
   # 缩进大括号
  IndentBraces:false
 # 在二元运算符前换行: None(在操作符后换行), NonAssignment(在非赋值的操作符前换行), All(在操作符前换行)
 BreakBeforeBinaryOperators:NonAssignment
 # 在大括号前换行: Attach(始终将大括号附加到周围的上下文), Linux(除函数、命名空间和类定义，与Attach类似), 
 #   Mozilla(除枚举、函数、记录定义，与Attach类似), Stroustrup(除函数定义、catch、else，与Attach类似), 
 #   Allman(总是在大括号前换行), GNU(总是在大括号前换行，并对于控制语句的大括号增加额外的缩进), WebKit(在函数前换行), Custom
 #   注：这里认为语句块也属于函数
 BreakBeforeBraces:Custom
 # 在三元运算符前换行
 BreakBeforeTernaryOperators:true
 # 在构造函数的初始化列表的逗号前换行
 BreakConstructorInitializersBeforeComma:false
 # 每行字符的限制，0表示没有限制
 ColumnLimit:200
 # 描述具有特殊意义的注释的正则表达式，它不应该被分割为多行或以其它方式改变
 CommentPragmas:'^ IWYU pragma:'
 # 构造函数的初始化列表要么都在同一行，要么都各自一行
 ConstructorInitializerAllOnOneLineOrOnePerLine:false
 # 构造函数的初始化列表的缩进宽度
 ConstructorInitializerIndentWidth:4
 # 延续的行的缩进宽度
 ContinuationIndentWidth:4
 # 去除C++11的列表初始化的大括号{后和}前的空格
 Cpp11BracedListStyle:false
 # 继承最常用的指针和引用的对齐方式
 DerivePointerAlignment:false
 # 关闭格式化
 DisableFormat:false
 # 自动检测函数的调用和定义是否被格式为每行一个参数(Experimental)
 ExperimentalAutoDetectBinPacking:false
 # 需要被解读为foreach循环而不是函数调用的宏
 ForEachMacros:[ foreach, Q_FOREACH, BOOST_FOREACH ]
 # 对#include进行排序，匹配了某正则表达式的#include拥有对应的优先级，匹配不到的则默认优先级为INT_MAX(优先级越小排序越靠前)，
 #   可以定义负数优先级从而保证某些#include永远在最前面
 IncludeCategories: 
   - Regex:'^"(llvm|llvm-c|clang|clang-c)/'
    Priority:2
   - Regex:'^(<|"(gtest|isl|json)/)'
    Priority:3
   - Regex:'.*'
    Priority:1
 # 缩进case标签
 IndentCaseLabels:false
 # 缩进宽度
 IndentWidth:4
 # 函数返回类型换行时，缩进函数声明或函数定义的函数名
 IndentWrappedFunctionNames:false
 # 保留在块开始处的空行
 KeepEmptyLinesAtTheStartOfBlocks:true
 # 开始一个块的宏的正则表达式
 MacroBlockBegin:''
 # 结束一个块的宏的正则表达式
 MacroBlockEnd:''
 # 连续空行的最大数量
 MaxEmptyLinesToKeep:1
 # 命名空间的缩进: None, Inner(缩进嵌套的命名空间中的内容), All
 NamespaceIndentation:Inner
 # 使用ObjC块时缩进宽度
 ObjCBlockIndentWidth:4
 # 在ObjC的@property后添加一个空格
 ObjCSpaceAfterProperty:false
 # 在ObjC的protocol列表前添加一个空格
 ObjCSpaceBeforeProtocolList:true
 # 在call(后对函数调用换行的penalty
 PenaltyBreakBeforeFirstCallParameter:19
 # 在一个注释中引入换行的penalty
 PenaltyBreakComment:300
 # 第一次在<<前换行的penalty
 PenaltyBreakFirstLessLess:120
 # 在一个字符串字面量中引入换行的penalty
 PenaltyBreakString:1000
 # 对于每个在行字符数限制之外的字符的penalty
 PenaltyExcessCharacter:1000000
 # 将函数的返回类型放到它自己的行的penalty
 PenaltyReturnTypeOnItsOwnLine:60
 # 指针和引用的对齐: Left, Right, Middle
 PointerAlignment:Left
 # 允许重新排版注释
 ReflowComments:true
 # 允许排序#include
 SortIncludes:true
 # 在C风格类型转换后添加空格
 SpaceAfterCStyleCast:false
 # 在赋值运算符之前添加空格
 SpaceBeforeAssignmentOperators:true
 # 开圆括号之前添加一个空格: Never, ControlStatements, Always
 SpaceBeforeParens:ControlStatements
 # 在空的圆括号中添加空格
 SpaceInEmptyParentheses:false
 # 在尾随的评论前添加的空格数(只适用于//)
 SpacesBeforeTrailingComments:2
 # 在尖括号的<后和>前添加空格
 SpacesInAngles:true
 # 在容器(ObjC和JavaScript的数组和字典等)字面量中添加空格
 SpacesInContainerLiterals:true
 # 在C风格类型转换的括号中添加空格
 SpacesInCStyleCastParentheses:true
 # 在圆括号的(后和)前添加空格
 SpacesInParentheses:true
 # 在方括号的[后和]前添加空格，lamda表达式和未指明大小的数组的声明不受影响
 SpacesInSquareBrackets:true
 # 标准: Cpp03, Cpp11, Auto
 Standard:Cpp11
 # tab宽度
 TabWidth:4
 # 使用tab字符: Never, ForIndentation, ForContinuationAndIndentation, Always
 UseTab:Never
 ...

```

如果不需要重新定义所有的规则，而是基于已有的代码风格模板进行修改，可以使用 BasedOnStyle 标识来进行部分格式规则的重定义：

```
 ---
 # We'll use defaults from the LLVM style, but with 4 columns indentation.
 BasedOnStyle: LLVM
 IndentWidth: 4
 ---
 Language: Cpp
 # Force pointers to the type for C++.
 DerivePointerAlignment: false
 PointerAlignment: Left
 ---
 Language: JavaScript
 # Use 100 columns for JS.
 ColumnLimit: 100
 ---
 Language: Proto
 # Don't format .proto files.
 DisableFormat: true
 ---
 Language: CSharp
 # Use 100 columns for C#.
 ColumnLimit: 100
 ...

```

如果代码文件中有部分代码不希望采用. clang-format 进行格式化，可以在这部分代码块的前后使用如下的注释进行标识：

```
 /* clang-format off */
 // 不需要.clang-format的代码块
 int a = 42;
 a++;
 ...
 /* clang-format on */

```

## **5 注意事项和常见问题**

## **5.1 注意事项和建议**

*   在配置`.clang-format`文件或编辑器插件时，请确保了解并遵循项目或团队的代码风格规范。
*   仔细选择和调整格式化选项，以满足项目需求和个人偏好，但也要保持一致性。
*   在使用 clang-format 进行代码格式化之前，请务必备份你的代码，以防止意外修改。
*   注意不要将`.clang-format`文件放在不必要的目录中，以免误影响其他代码库或文件。

## **5.2 常见问题解答**

1.  问：为什么我在使用 clang-format 之后，代码格式并没有按照预期的方式进行修改？  
    答：可能是由于未正确配置`.clang-format`文件或编辑器插件。请仔细检查配置文件的路径、格式和选项设置是否正确。
2.  问：我可以使用不同的格式化选项来针对不同的文件吗？  
    答：是的，你可以使用`.clang-format`文件放置在不同的文件夹中，或在编辑器插件中配置不同的格式化选项来实现针对不同文件的格式化。
3.  问：如何在 clang-format 中忽略特定的代码片段或文件？  
    答：可以使用特定的注释来告诉 clang-format 忽略特定的代码段或文件。例如，使用`// clang-format off`和`// clang-format on`注释来标识要忽略的代码片段。
4.  问：我在编辑器中配置了 clang-format 插件，但格式化操作没有任何反应。  
    答：请确保插件已正确安装并启用。还要检查你的编辑器中的快捷键、菜单项或命令是否正确配置为触发 clang-format 的操作。
5.  问：我可以将 clang-format 与其他代码格式化工具结合使用吗？  
    答：是的，你可以将 clang-format 与其他工具（如 Prettier、EditorConfig 等）结合使用，以实现更全面的代码格式化和规范化。

## **6 总结**

本文对 clang-format 进行了详细介绍，涵盖了使用方法、安装、配置、编辑器插件、配置文件详解、注意事项和常见问题等方面的内容。clang-format 是一个强大的代码格式化工具，可以帮助开发者自动化地统一和优化代码风格，提高代码可读性和维护性。通过命令行或编辑器插件的方式，可以方便地使用 clang-format 对代码进行格式化。

## **7 参考资料**

1.  ClangFormat：[https://clang.llvm.org/docs/ClangFormat.html](https://clang.llvm.org/docs/ClangFormat.html)
2.  Clang-Format 格式化选项介绍：[https://blog.csdn.net/softimite_zifeng/article/details/78357898](https://blog.csdn.net/softimite_zifeng/article/details/78357898)

关注微信公众号：Linux 内核拾遗  
文章来源：[Clang-Format 用法详解](https://mp.weixin.qq.com/s/mwMsffSrouPaswzG9rgdmg)[Clang-Format 用法详解](https://mp.weixin.qq.com/s/mwMsffSrouPaswzG9rgdmg)