---
url: https://zhuanlan.zhihu.com/p/514541589
title: 使用 clang-format 进行 C++ 代码风格管理
date: 2023-08-15 12:23:11
tag: 
banner: "https://pica.zhimg.com/v2-211e51f0c00754428e944215f689f348_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
本文使用 [Zhihu On VSCode](https://zhuanlan.zhihu.com/p/106057556) 创作并发布

## 目录

![](https://pic1.zhimg.com/v2-5bb2277a3f9ca080c28a34e01749c77c_r.jpg)

良好统一的代码风格在多人协同开发中至关重要，不统一的代码风格会在代码版本管理中引入由于格式修改而带来的代码变更，使版本维护变得困难且容易出错。

[clang-format](https://clang.llvm.org/docs/ClangFormat.html) 是 LLVM 开发的用于格式化 C/C++/Java/JavaScript/Objective-C/Objective-C++/Protobuf 等多种语言代码的工具，借助 clang-format 可以实现代码仓库的风格统一，提升开发效率，本文将阐述使用该工具进行代码风格管理的基本步骤。

## 1 操作步骤

## 1.1 安装 clang-format

clang-format 有诸多版本可供使用，目前最新版本为 clang-format 15。不同版本所支持的格式化选项不尽相同，但向后兼容。实际开发中，我们应统一所使用的 clang-format 版本，这里我们选择 clang-format 10。对于 Windows 平台，可以[下载](https://releases.llvm.org/)预编译的二进制文件进行安装；对于 Linux 平台（以 Ubuntu 为例），可以通过命令行直接安装：

```
sudo apt install clang-format-10

```

**⚠** 这里应注意，不能通过 `sudo apt install clang-format` 命令进行安装，因为对于不同的 Ubuntu 发行版而言，通过该命令安装得到的 clang-format 版本是不同的。

安装完成后，我们能够使用的命令名是 `clang-format-10`，我们将其提级为 `clang-format`：

```
sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-10 100

```

后面当我们使用 `clang-format` 命令时，指代的即为 `clang-format-10`。

通过 vscode 进行 C++ 开发时，我们一般会安装微软官方的 [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) 插件，打开该插件的安装目录我们会发现，该插件已经封装了一个内置的 clang-format：

![](https://pic4.zhimg.com/v2-eb912917ad7d624dc7a8089e2dfe74cb_b.png)

那为什么不直接使用这个 C/C++ 插件内置的 clang-format 呢？两个原因：

*   不同版本的 C/C++ 插件内置的 clang-format 版本往往不同，统一 clang-format 版本间接需要统一 C/C++ 插件版本；
*   C/C++ 插件内置的 clang-format 只能应用于 C/C++ 代码，而实际开发中，可能包含了其它语言代码，例如 Protobuf。

直接在系统中安装 clang-format 则可以避免这两个问题。

## 1.2 安装 vscode clang-format 插件

完成步骤 1.1 后，我们已经可以在终端中通过 `clang-format` 命令来对代码文件进行格式化：

```
clang-format -style=google -i demo.cpp

```

上面的命令表示：使用 Google 编码风格对 demo.cpp 文件进行格式化。但使用 vscode 进行 C++ 开发时，我们一般并不会使用终端去格式化代码，而是会在 vscode 设置中为 C++ 指定一个默认的 formatter，并开启设置中的 `autoSave` 选项和 `formatOnSave` 选项，实现代码修改后的自动格式化保存：

```
{
  "files.autoSave": "afterDelay",
  "editor.formatOnSave": true,
  "[cpp]": {
    "editor.defaultFormatter": "ms-vscode.cpptools"
  }
}

```

`"editor.defaultFormatter": "ms-vscode.cpptools"` 表示使用 C++ 插件作为默认的 formatter。为了使用步骤 1.1 中为系统安装的 clang-format，这里我们为 vscode 安装 [Clang-Format 插件](https://marketplace.visualstudio.com/items?itemName=xaver.clang-format)：

![](https://pic3.zhimg.com/v2-692debcc61b2c6b34dc7e8883540800a_r.jpg)

可以在插件商店中搜索 Clang-Format 并点击安装，或直接通过命令行进行安装（例如当我们要实现流程自动化时）：

```
code --install-extension xaver.clang-format

```

安装完成后将其指定为默认的 formatter：

```
{
  "files.autoSave": "afterDelay",
  "editor.formatOnSave": true,
  "[cpp]": {
    "editor.defaultFormatter": "xaver.clang-format"
  }
}

```

以后每次修改完代码保存时，vscode 的 clang-format 插件会调用系统中的 clang-format（默认从 `PATH` 环境变量中查找，也可以单独指定路径）对代码进行格式化。

## 1.3 编写 .clang-format 文件

完成步骤 1.2 后，每次对代码进行格式化时使用的将是 clang-format 默认的风格，clang-format 支持包括 LLVM、Google、Chromium、Mozilla、WebKit 等在内的多种风格。我们可以在已有风格的基础上自定义一个名为 `.clang-format` 的代码风格文件放在仓库根目录下，以后保存代码时 clang-format 将根据文件中定义的规则对代码进行格式化。

这里我们首先生成 Google 风格的 `.clang-format` 模板文件：

```
clang-format -style=google -dump-config > .clang-format

```

然后根据团队开发规范或个人喜好对生成的 `.clang-format` 进行自定义。下面是笔者常用的风格，注释掉的部分与 Google style 相同，其它部分经过了自定义：

```
---
BasedOnStyle: Google
---
Language: Cpp
AccessModifierOffset: -4
# AlignAfterOpenBracket: Align
# AlignConsecutiveMacros: false
# AlignConsecutiveAssignments: false
# AlignConsecutiveDeclarations: false
# AlignEscapedNewlines: Left
# AlignOperands: true
# AlignTrailingComments: true
# AllowAllArgumentsOnNextLine: true
AllowAllConstructorInitializersOnNextLine: false
# AllowAllParametersOfDeclarationOnNextLine: true
# AllowShortBlocksOnASingleLine: Never
AllowShortCaseLabelsOnASingleLine: true
# AllowShortFunctionsOnASingleLine: All
# AllowShortLambdasOnASingleLine: All
# AllowShortIfStatementsOnASingleLine: WithoutElse
# AllowShortLoopsOnASingleLine: true
# AlwaysBreakAfterDefinitionReturnType: None
# AlwaysBreakAfterReturnType: None
AlwaysBreakBeforeMultilineStrings: false
# AlwaysBreakTemplateDeclarations: Yes
# BinPackArguments: true
# BinPackParameters: true
BraceWrapping:
  # AfterCaseLabel: false
  AfterClass: true
  AfterControlStatement: Always
  AfterEnum: true
  AfterFunction: true
  # AfterNamespace: false
  # AfterObjCDeclaration: false
  AfterStruct: true
  AfterUnion: true
  AfterExternBlock: true
  BeforeCatch: true
  BeforeElse: true
  # IndentBraces: false
  # SplitEmptyFunction: true
  # SplitEmptyRecord: true
  # SplitEmptyNamespace: true
# BreakBeforeBinaryOperators: None
BreakBeforeBraces: Custom
# BreakBeforeInheritanceComma: false
# BreakInheritanceList: BeforeColon
# BreakBeforeTernaryOperators: true
# BreakConstructorInitializersBeforeComma: false
# BreakConstructorInitializers: BeforeColon
# BreakAfterJavaFieldAnnotations: false
# BreakStringLiterals: true
# ColumnLimit: 80
CommentPragmas: "^ NOLINT:"
# CompactNamespaces: false
# ConstructorInitializerAllOnOneLineOrOnePerLine: true
# ConstructorInitializerIndentWidth: 4
# ContinuationIndentWidth: 4
# Cpp11BracedListStyle: true
# DeriveLineEnding: true
# DerivePointerAlignment: true
# DisableFormat: false
# ExperimentalAutoDetectBinPacking: false
# FixNamespaceComments: true
# ForEachMacros:
#   - foreach
#   - Q_FOREACH
#   - BOOST_FOREACH
# IncludeBlocks: Regroup
# IncludeCategories:
#   - Regex: '^<ext/.*\.h>'
#     Priority: 2
#     SortPriority: 0
#   - Regex: '^<.*\.h>'
#     Priority: 1
#     SortPriority: 0
#   - Regex: "^<.*"
#     Priority: 2
#     SortPriority: 0
#   - Regex: ".*"
#     Priority: 3
#     SortPriority: 0
# IncludeIsMainRegex: "([-_](test|unittest))?$"
# IncludeIsMainSourceRegex: ""
# IndentCaseLabels: true
# IndentGotoLabels: true
# IndentPPDirectives: None
IndentWidth: 4
# IndentWrappedFunctionNames: false
# JavaScriptQuotes: Leave
# JavaScriptWrapImports: true
# KeepEmptyLinesAtTheStartOfBlocks: false
# MacroBlockBegin: ""
# MacroBlockEnd: ""
# MaxEmptyLinesToKeep: 1
# NamespaceIndentation: None
# ObjCBinPackProtocolList: Never
# ObjCBlockIndentWidth: 2
# ObjCSpaceAfterProperty: false
# ObjCSpaceBeforeProtocolList: true
# PenaltyBreakAssignment: 2
# PenaltyBreakBeforeFirstCallParameter: 1
# PenaltyBreakComment: 300
# PenaltyBreakFirstLessLess: 120
# PenaltyBreakString: 1000
# PenaltyBreakTemplateDeclaration: 10
# PenaltyExcessCharacter: 1000000
# PenaltyReturnTypeOnItsOwnLine: 200
PointerAlignment: Right
# RawStringFormats:
#   - Language: Cpp
#     Delimiters:
#       - cc
#       - CC
#       - cpp
#       - Cpp
#       - CPP
#       - "c++"
#       - "C++"
#     CanonicalDelimiter: ""
#     BasedOnStyle: google
#   - Language: TextProto
#     Delimiters:
#       - pb
#       - PB
#       - proto
#       - PROTO
#     EnclosingFunctions:
#       - EqualsProto
#       - EquivToProto
#       - PARSE_PARTIAL_TEXT_PROTO
#       - PARSE_TEST_PROTO
#       - PARSE_TEXT_PROTO
#       - ParseTextOrDie
#       - ParseTextProtoOrDie
#     CanonicalDelimiter: ""
#     BasedOnStyle: google
# ReflowComments: true
SortIncludes: false
SortUsingDeclarations: false
# SpaceAfterCStyleCast: false
# SpaceAfterLogicalNot: false
# SpaceAfterTemplateKeyword: true
# SpaceBeforeAssignmentOperators: true
# SpaceBeforeCpp11BracedList: false
# SpaceBeforeCtorInitializerColon: true
# SpaceBeforeInheritanceColon: true
# SpaceBeforeParens: ControlStatements
# SpaceBeforeRangeBasedForLoopColon: true
# SpaceInEmptyBlock: false
# SpaceInEmptyParentheses: false
SpacesBeforeTrailingComments: 1
# SpacesInAngles: false
# SpacesInConditionalStatement: false
SpacesInContainerLiterals: false
# SpacesInCStyleCastParentheses: false
# SpacesInParentheses: false
# SpacesInSquareBrackets: false
# SpaceBeforeSquareBrackets: false
Standard: Cpp11
# StatementMacros:
#   - Q_UNUSED
#   - QT_REQUIRE_VERSION
TabWidth: 4
# UseCRLF: false
# UseTab: Never

```

每个选项的具体含义可以在[官方文档](https://clang.llvm.org/docs/ClangFormatStyleOptions.html)中找到。

如果希望某个代码段不要参与格式化，可使用 `// clang-format off` 和 `// clang-format on` 注释对该代码段进行限定，像下面这样：

```
void test()
{
    // clang-format off
    Eigen::MatrixXd ref_mat = Eigen::MatrixXd::Zero(6, 6);
    ref_mat <<
         1,        0,        0,        0,        0,        0,
         1,      0.5,     0.25,    0.125,   0.0625,  0.03125,
         1,        1,        1,        1,        1,        1,
        -1,       -0,       -0,       -0,       -0,       -0,
        -1,     -0.5,    -0.25,   -0.125,  -0.0625, -0.03125,
        -1,       -1,       -1,       -1,       -1,       -1;
    // clang-format on
}


```

## 参考

1.  [ClangFormat](https://clang.llvm.org/docs/ClangFormat.html)
2.  [ClangFormatStyleOptions](https://clang.llvm.org/docs/ClangFormatStyleOptions.html)
3.  [ClangFormatConfig](https://github.com/Krantz-XRF/ClangFormatConfig/blob/master/.clang-format)
4.  [godot](https://github.com/godotengine/godot/blob/master/.clang-format)

如果觉得文章对你有所帮助的话，欢迎点赞 / 评论 / 收藏 / 关注，相互交流，共同进步~