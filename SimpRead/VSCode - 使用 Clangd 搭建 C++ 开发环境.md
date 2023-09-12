---
url: https://zhuanlan.zhihu.com/p/583201222
title: VSCode - 使用 Clangd 搭建 C++ 开发环境
date: 2023-08-15 10:29:29
tag: 
banner: "https://images.unsplash.com/photo-1682417844651-ddb5c832f5bd?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkyMDY2NTEwfA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
banner_icon: 🔖
---
一直使用的是微软出品的 **_C/C++_** 插件，但是时不时就会出现代码提示失效，跳转失败的问题。在 **c_cpp_properties.json** 配置了 **compileCommands** 后，效果也不理想。 尝试使用了 **_Clion_** 被代码提示和跳转功能惊艳了，了解到 **_Clion_** 使用的是 **_Clangd_** 来进行代码解析的。而 **_VSCODE_** 也有 **_Clangd_** 插件，所以尝试使用 **_Clangd_** 替代 **_C/C++_** 插件。

打开 **_VSCode_** 插件市场搜索 **_Clangd_** 安装；

![](https://pic3.zhimg.com/v2-70a0c665d4f87aea23aa0f2b8a59430e_r.jpg)

如果之前有安装过 **_C/C++_** 插件，那么 **_Clangd_** 会提示 **_Intelli Scense_** 冲突，然后可以在弹出的提示框选择禁用 **_C/C++_** 的 **_Intelli Scense_** ，但是考虑到我用不到 **_C/C++_** 的调试功能，所以选择了直接卸载。

将如下配置，粘贴到 **_VSCODE_** 用户配置文件 **_Settings.josn_** 的最后。

```
/// clangd
"clangd.checkUpdates": true,
"clangd.arguments": [
   "--background-index",            /// 在后台自动分析文件（基于complie_commands)
   "--compile-commands-dir=${workspaceFolder}/gcc/build",                 /// 标记compelie_commands.json文件的目录位置
   "-j=12",                         /// 同时开启的任务数量
   "--query-driver=C:/~Arm_Development_Toolchains/LLVM/bin/clang++.exe",  /// clang 路径，使用命令 which clang++ 获取的的路径
   "--clang-tidy",                  /// clang-tidy功能
   "--clang-tidy-checks=performance-*,bugprone-*",
   "--all-scopes-completion",       /// 全局补全（会自动补充头文件）
   "--completion-style=detailed",   /// 更详细的补全内容
   "--header-insertion=iwyu",       /// 补充头文件的形式
   "--pch-storage=disk",            /// pch优化的位置
],

```

**_compelie_commands.json_** 文件 在 **_CMakeLists_** 文件增加 **_set(CMAKE_EXPORT_COMPILE_COMMANDS True)_**，运行 **_CMake_** 后会在输出目录自动创建 **_compelie_commands.json_** 文件。 通过 **_compelie_commands.json_** 你可以获得良好的代码跳转、错误提示、代码补全等功能。

安装 **_LSP_** 在 **_VSCODE_** 中，**_ctrl+shift+p_** 打开命令窗口，输入 **_Clangd_** 然后在命令列表里面找到 **_clangd: Download language server_** , 点击安装语言服务器； 安装完成后会提示 重新加载。

重启后，可以试试效果了。

在实际使用的时候，有可能出现即使重新编译了，但是代码提示和跳转依旧存在问题，那么可以尝试重启 **_clangd_**。具体做法是 **_ctrl+shift+p_** ，输入 **_Clangd_** 然后找到 **_clangd: Restart language server_**，点击后会重新执行索引。