---
url: https://blog.csdn.net/m0_54206076/article/details/123836683
title: 2022-03-30 VsCode 中使用 clangd 插件的各种设置_不停感叹的老林的博客 - CSDN 博客
date: 2023-08-14 23:00:10
tag: 
banner: "https://images.unsplash.com/photo-1689308271349-e685f6ec405a?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkyMDI1MjA1fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
最近尝试 [clang](https://so.csdn.net/so/search?q=clang&spm=1001.2101.3001.7020) 编译 c++，所以用了 clangd 插件代替 mscpp 插件，其中有不少问题，都是通过各种搜索，各种猜，才能完善，记录一下，以便广大同仁阅览。

第一步，设置 clang 工具链，我用 [msys2](https://so.csdn.net/so/search?q=msys2&spm=1001.2101.3001.7020) 构建的 clang64 工具链，这个搜一下，非常容易构建。

第二步，下载 [vscode 插件](https://so.csdn.net/so/search?q=vscode%E6%8F%92%E4%BB%B6&spm=1001.2101.3001.7020) clangd，这是官方插件，由于与 mscpp 插件冲突，需要将 mscpp 关闭。

第三步，设置 clangd 插件，这是最折腾的。

1.  设置 clangd 可执行文件的位置，一定要设置为你构建的 clang64 中的 clangd 可执行文件位置，切记。
    
    因为安装插件，本身也下载一个 clangd，但是那不能用，不能识别 clang 的标准库文件。
    
2.  设置 clangd 参数：编译器执行程序，提示风格，是否自动加头文件，启用 clang-tidy，当 c++ 构建文件不存在时搜索位置。
    
    ```
           "clangd.arguments": [
           "--query-driver=K:\\msys64\\clang64\\bin\\clang*",
           "--completion-style=detailed",
           "--header-insertion=never",
           "--clang-tidy",
           ],
           "clangd.fallbackFlags": [
           "-IK:\\msys64\\mingw64\\include\\"
           ],
    
    ```
    
3.  设置编辑器格式化风格。这个需要在项目文件夹下建立一个 “.clang-format” 文件，内容如下：我使用的时微软风格，没办法，习惯 mscpp 的 format 了。
    

```
---
Language:        Cpp
# BasedOnStyle:  Microsoft
AccessModifierOffset: -2
AlignAfterOpenBracket: Align
AlignArrayOfStructures: None
AlignConsecutiveMacros: None
AlignConsecutiveAssignments: None
AlignConsecutiveBitFields: None
AlignConsecutiveDeclarations: None
AlignEscapedNewlines: Right
AlignOperands:   Align
AlignTrailingComments: true
AllowAllArgumentsOnNextLine: true
AllowAllConstructorInitializersOnNextLine: true
AllowAllParametersOfDeclarationOnNextLine: true
AllowShortEnumsOnASingleLine: false
AllowShortBlocksOnASingleLine: Never
AllowShortCaseLabelsOnASingleLine: false
AllowShortFunctionsOnASingleLine: None
AllowShortLambdasOnASingleLine: All
AllowShortIfStatementsOnASingleLine: Never
AllowShortLoopsOnASingleLine: false
AlwaysBreakAfterDefinitionReturnType: None
AlwaysBreakAfterReturnType: None
AlwaysBreakBeforeMultilineStrings: false
AlwaysBreakTemplateDeclarations: MultiLine
AttributeMacros:
  - __capability
BinPackArguments: true
BinPackParameters: true
BraceWrapping:
  AfterCaseLabel:  false
  AfterClass:      true
  AfterControlStatement: Always
  AfterEnum:       true
  AfterFunction:   true
  AfterNamespace:  true
  AfterObjCDeclaration: true
  AfterStruct:     true
  AfterUnion:      false
  AfterExternBlock: true
  BeforeCatch:     true
  BeforeElse:      true
  BeforeLambdaBody: false
  BeforeWhile:     false
  IndentBraces:    false
  SplitEmptyFunction: true
  SplitEmptyRecord: true
  SplitEmptyNamespace: true
BreakBeforeBinaryOperators: None
BreakBeforeConceptDeclarations: true
BreakBeforeBraces: Custom
BreakBeforeInheritanceComma: false
BreakInheritanceList: BeforeColon
BreakBeforeTernaryOperators: true
BreakConstructorInitializersBeforeComma: false
BreakConstructorInitializers: BeforeColon
BreakAfterJavaFieldAnnotations: false
BreakStringLiterals: true
ColumnLimit:    80
CommentPragmas:  '^ IWYU pragma:'
CompactNamespaces: false
ConstructorInitializerAllOnOneLineOrOnePerLine: false
ConstructorInitializerIndentWidth: 4
ContinuationIndentWidth: 4
Cpp11BracedListStyle: true
DeriveLineEnding: true
DerivePointerAlignment: false
DisableFormat:   false
EmptyLineAfterAccessModifier: Never
EmptyLineBeforeAccessModifier: LogicalBlock
ExperimentalAutoDetectBinPacking: false
FixNamespaceComments: true
ForEachMacros:
  - foreach
  - Q_FOREACH
  - BOOST_FOREACH
IfMacros:
  - KJ_IF_MAYBE
IncludeBlocks:   Preserve
IncludeCategories:
  - Regex:           '^"(llvm|llvm-c|clang|clang-c)/'
    Priority:        2
    SortPriority:    0
    CaseSensitive:   false
  - Regex:           '^(<|"(gtest|gmock|isl|json)/)'
    Priority:        3
    SortPriority:    0
    CaseSensitive:   false
  - Regex:           '.*'
    Priority:        1
    SortPriority:    0
    CaseSensitive:   false
IncludeIsMainRegex: '(Test)?$'
IncludeIsMainSourceRegex: ''
IndentAccessModifiers: false
IndentCaseLabels: false
IndentCaseBlocks: false
IndentGotoLabels: true
IndentPPDirectives: None
IndentExternBlock: AfterExternBlock
IndentRequires:  false
IndentWidth:     4
IndentWrappedFunctionNames: false
InsertTrailingCommas: None
JavaScriptQuotes: Leave
JavaScriptWrapImports: true
KeepEmptyLinesAtTheStartOfBlocks: true
LambdaBodyIndentation: Signature
MacroBlockBegin: ''
MacroBlockEnd:   ''
MaxEmptyLinesToKeep: 1
NamespaceIndentation: None
ObjCBinPackProtocolList: Auto
ObjCBlockIndentWidth: 2
ObjCBreakBeforeNestedBlockParam: true
ObjCSpaceAfterProperty: false
ObjCSpaceBeforeProtocolList: true
PenaltyBreakAssignment: 2
PenaltyBreakBeforeFirstCallParameter: 19
PenaltyBreakComment: 300
PenaltyBreakFirstLessLess: 120
PenaltyBreakString: 1000
PenaltyBreakTemplateDeclaration: 10
PenaltyExcessCharacter: 1000000
PenaltyReturnTypeOnItsOwnLine: 1000
PenaltyIndentedWhitespace: 0
PointerAlignment: Right
PPIndentWidth:   -1
ReferenceAlignment: Pointer
ReflowComments:  true
ShortNamespaceLines: 1
SortIncludes:    CaseSensitive
SortJavaStaticImport: Before
SortUsingDeclarations: true
SpaceAfterCStyleCast: false
SpaceAfterLogicalNot: false
SpaceAfterTemplateKeyword: true
SpaceBeforeAssignmentOperators: true
SpaceBeforeCaseColon: false
SpaceBeforeCpp11BracedList: false
SpaceBeforeCtorInitializerColon: true
SpaceBeforeInheritanceColon: true
SpaceBeforeParens: ControlStatements
SpaceAroundPointerQualifiers: Default
SpaceBeforeRangeBasedForLoopColon: true
SpaceInEmptyBlock: false
SpaceInEmptyParentheses: false
SpacesBeforeTrailingComments: 1
SpacesInAngles:  Never
SpacesInConditionalStatement: false
SpacesInContainerLiterals: true
SpacesInCStyleCastParentheses: false
SpacesInLineCommentPrefix:
  Minimum:         1
  Maximum:         -1
SpacesInParentheses: false
SpacesInSquareBrackets: false
SpaceBeforeSquareBrackets: false
BitFieldColonSpacing: Both
Standard:        Latest
StatementAttributeLikeMacros:
  - Q_EMIT
StatementMacros:
  - Q_UNUSED
  - QT_REQUIRE_VERSION
TabWidth:        4
UseCRLF:         false
UseTab:          Never
WhitespaceSensitiveMacros:
  - STRINGIZE
  - PP_STRINGIZE
  - BOOST_PP_STRINGIZE
  - NS_SWIFT_NAME
  - CF_SWIFT_NAME
...


```

具体说明参见：[VS Code C++ 代码格式化方法 (clang-format)](https://blog.csdn.net/core571/article/details/82867932)

4.  设置 clangd tidy 规则，用于静态分析提示，需要在项目文件夹下建立 “.clang-tidy” 文件，内容如下：我设置的比较多，通常会导致各种提示问题，如果觉得烦，可以自主选择，需参考 clangd 官方文档。

```
---
Checks: "bugprone-*,\
google-*,\
misc-*,\
modernize-*,\
performance-*,\
readability-*,\
portability-*,\
"
HeaderFilterRegex: 'Source/cm[^/]*\.(h|hxx|cxx)$'
CheckOptions:
  - key:   modernize-use-default-member-init.UseAssignment
    value: '1'
  - key:   modernize-use-equals-default.IgnoreMacros
    value: '0'
  - key:   modernize-use-auto.MinTypeNameLength
    value: '80'
...


```

5.  设置模拟编译环境

根据官方文档，需要通过 cmake 为每个文件设置 compile_commands.json 文件，如果可以的话，请照做。这个不设置的话，对于只用系统库的编程，没有问题。

但涉及到非系统库头文件时候，就比较蛋疼。你无法指定文件位置，只能用第二条的 “clangd.fallbackFlags” 设置。然而所有头文件都会视为 C++ 文件标准，如果你编辑 C 头文件，会痛不欲生。对于我这样写袖珍程序的主儿，这个不能忍。

解决办法是在你的每个子项目文件夹里添加一个 “compile_flags.txt” 文件，内容很简单：设置代码类型：C 是 "-xc" , C++ 是 "-xc++"，不可混用。设置 C 或 C++ 的标准，一般 C++11 即可，版本太高，编译器不一定有实现。

```
-xc
-std=c11
-Wall
-Ik:/msys64/mingw64/include/
-Ik:/msys64/mingw64/include/cuda/

```

通过以上的设置，基本就可以比较愉快的使用 clangd 协助编程了。

2022/09/20 补充 clangd 插件补全选项：

如果在 setting 中把下面的选项更改为 false，clangd 会强制补全，也就是说，如果有 clangd 认为的应补全代码，按空格也会自动补全，导致有时候你不想补全，它乱补全的情况，我也是不知怎么就改了这个选项，一直是强制补全，写代码很不舒服。

```
    "clangd.serverCompletionRanking": true,

```

还有一个问题，就是 debug，把 mscpp 禁用的后果是无法 debug， 而 clang 的默认 debug 工具是 lldb，下载请认准：  
CodeLLDB Vadim Chugunov

补充一下 debug 的问题

这是 debug 时的 launch 文件，在 vscode 可以直接添加配置，基本就是这个样子，比 msCPP 的设置简化很多，只是 type 变成了 lldb，其余是一样的，Code LLDB 会完成剩下的 debug 问题。  
提醒一下，CodeLLDB 插件的默认配置不要轻易动，尤其涉及 lldb 路径的问题，一定要用插件自己下载的，不要用 Clang64 工具链中的，这个和 clangd 设置相反，切记。

```
        {
            "name": "clang",
            "type": "lldb",
            "request": "launch",
            "program": "${fileDirname}/${fileBasenameNoExtension}.exe",
            "args": [
            ],
            "cwd": "${workspaceFolder}",
            "sourceLanguages": [
                "C"
            ],
            "preLaunchTask": "clangBuild_C",
        },
        {
            "name": "clang++",
            "type": "lldb",
            "request": "launch",
            "program": "${fileDirname}/${fileBasenameNoExtension}.exe",
            "args": [
            ],
            "cwd": "${workspaceFolder}",
            "sourceLanguages": [
                "C++"
            ],
            "preLaunchTask": "clangBuild_C++"
        },

```

lldb 插件可以近乎完美解决 debug 问题，只有一个小问题，就是在终端显示的错误无法映射到 “问题” 窗口，原因比较简单，原先用于 gcc 的 problemmatcher 无法捕捉 clang 返回的问题，毕竟不是一种编译器。

估计由于只有百万级开发者使用 clang 在 vscode 中编程，未能引起 vscode 团队的重视。所以需要自己设置。

这个问题困扰了我很久，经过翻阅各种 issue，得到解决，这是在 tasks 中的完整实现：最难之处是多行正则匹配语法，见 problemMatcher 部分，可以解决一些问题。上边是 clang 用于编译 C 的，下边是用于 clang++ 用于编译 C++ 的。

```
{
            "type": "process",
            "label": "clangBuild_C",
            "command": "K:\\msys64\\clang64\\bin\\clang.exe",
            "args": [
                "-glldb",
                "-std=c11",
                "${fileBasenameNoExtension}*",
                "-o",
                "${fileDirname}\\${fileBasenameNoExtension}.exe",
            ],
            "options": {
                "cwd": "${fileDirname}"
            },
            "problemMatcher": {
                "owner": "lldb",
                "fileLocation": [
                    "relative",
                    "${fileDirname}"
                ],
                "pattern": [
                    {
                        "regexp": "^(ld.lld:.*)$",
                        "message": 1,
                    },
                    {
                        "regexp": ">>> referenced by (.*):(\\d+)",
                        "file": 1,
                        "line": 2,
                    },
                ]
            }
        },
        {
            "type": "process",
            "label": "clangBuild_C++",
            "command": "K:\\msys64\\clang64\\bin\\clang++.exe",
            "args": [
                "-glldb",
                "-std=c++11",
                "${fileBasename}",
                "-o",
                "${fileDirname}\\${fileBasenameNoExtension}.exe",
                "-Ik:/msys64/mingw64/include/",
            ],
            "options": {
                "cwd": "${fileDirname}"
            },
            "problemMatcher": {
                "owner": "lldb",
                "fileLocation": [
                    "relative",
                    "${fileDirname}"
                ],
                "pattern": {
                    "regexp": "^(.*\\.cpp):(\\d+):(\\d+): (.*)$",
                    "file": 1,
                    "line": 2,
                    "column": 3,
                    "message": 4
                },
            }
        }

```

我的. vscode\settings.json 文件中关于 lldb 插件设置：

```
{
    "lldb.consoleMode": "evaluate",    //调试控制台模式为终端命令模式，可调用lldb命令
    "lldb.launch.sourceLanguages": [   //调试语言
        "cpp",
        "c"
    ],
    "lldb.launch.expressions": "native",  //使用原生表达式
    "lldb.displayFormat": "auto",
    "lldb.dereferencePointers": false,
    "lldb.showDisassembly": "auto",
}

```

有以上设置，就可以进行常规的 lldb 的 debug 了，比如有个变量 temp，想要看他的值和地址，在调试控制台输入 `p a, `p &a 即可，和在终端进行 debug 是一样的。

这里记录一点私货，如何监视动态数组值，比如有一个 struct 指针 pf1，scores 是 pf1 中一个含有 5 个 double 数据的动态数组：请用 vscode 的 debug 监视输入：

(double(*)[5])pf1->scores

如果用控制台 `p (double(*)[5])pf1->scores 会返回一个指针。

再加一项，文件重定向：

在 vscode 中使用 lldb，是不可以直接用 args 方法的，如下设置不通。

```
            "args": [
                "(A*B|AC)D",
                "<",
                "E:\\clangC++\\suanfa\\data\\tinyL.txt",
            ],

```

lldb 插件有个自己的关键词设置：stdio

```
            "stdio": [
                "E:\\clangC++\\suanfa\\data\\tinyL.txt",
                "stu1.txt",
            ],

```

第一项是标准输入，第二项是标准输出，如果有第三项，是标准 err，请务必注意，这条它的官网有，但我没看，是自己试验出来的，虽然对初学者不常用，但对工程调试，没有这个大概会疯。

如有问题，请访问：[clangd 官方地址](https://clangd.llvm.org/installation.html)