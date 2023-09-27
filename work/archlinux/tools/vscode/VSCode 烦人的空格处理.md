#vscode #空格
---
url: https://zhuanlan.zhihu.com/p/343307484
title: VSCode 烦人的空格处理
date: 2023-03-29 19:34:55
tag: 
banner: "https://pic1.zhimg.com/v2-3bb1510091b1e905e10505411a1220b3_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
对于有代码洁癖的人，空格和 tab 的处理，有着严格规范。一般来说上库代码不允许夹带 tab 和空格，tab 统一用 4 个空格替换。另外出现行末空格，空行空格等等也会影响代码格式，引入多余字符。  
VSCode 默认 Tab、空格其实很不友好，现在都 2021 年了，希望 VsCode 能智能些，不用每次下载 VSCode 都要重新设置下 Tab4 空格，保存文件删除行末空格，文本编辑器中显示空格、tab 符号等等。

*   settings.json 设置

```
"editor.detectIndentation": false,  //关闭检测第一个tab后面就tab
"editor.renderControlCharacters": true, //制表符显示->
"editor.renderWhitespace": "all", //空格显示...
"editor.tabSize": 4,//tab为四个空格
"editor.insertSpaces": true //转为空格

```

*   也可通过图形界面设置，点击左下角齿轮按钮，开启设置，之后搜索设置项，完成下文中的空格相关设置即可。

![](<assets/1680089695333.png>)

*   Tab 设置 4 空格

```
editor.tabSize

```

![](<assets/1680089695421.png>)

*   按下 tab 键时插入空格

```
"editor.insertSpaces": true
需把Detect Indentation关闭

```

![](<assets/1680089695513.png>)

*   **保存文件删除行末空格**

```
files.trimTrailingWhitespace

```

![](<assets/1680089695596.png>)

*   **编辑器中显示空格、tab 符号**

```
renderControlCharacters  显示tab

```

![](<assets/1680089695679.png>)

```
renderWhitespace,选择all,即可显示空格.

```

![](<assets/1680089695760.png>)

![](<assets/1680089695856.png>)