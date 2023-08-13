---
url: https://www.cnblogs.com/jason-wei/articles/15702461.html
title: 优化 VSCode：让你的 VSCode 变得好用又美观
date: 2023-05-04 11:42:40
tag: 
banner: "https://img2020.cnblogs.com/blog/1087845/202112/1087845-20211217144647217-881909707.png"
banner_icon: 🔖
---
**一、基本设置**

以下是 setting.json 的基本内容，可以优化 vscode 写代码体验，设置项的意义已经注释：

```
{
/*editor*/
"editor.cursorBlinking": "smooth",//使编辑器光标的闪烁平滑，有呼吸感
"editor.formatOnPaste": true,//在粘贴时格式化代码
"editor.formatOnType": true,//敲完一行代码自动格式化
"editor.smoothScrolling": true,//使编辑器滚动变平滑
"editor.tabCompletion": "on",//启用Tab补全
"editor.fontFamily": "'Jetbrains Mono', '思源黑体'",//字体设置，个人喜欢Jetbrains Mono作英文字体，思源黑体作中文字体
"editor.fontLigatures": true,//启用字体连字
"editor.detectIndentation": false,//不基于文件内容选择缩进用制表符还是空格
/*
因为有时候VSCode的判断是错误的
*/
"editor.insertSpaces": true,//敲下Tab键时插入4个空格而不是制表符
"editor.copyWithSyntaxHighlighting": false,//复制代码时复制纯文本而不是连语法高亮都复制了
"editor.suggest.snippetsPreventQuickSuggestions": false,//这个开不开效果好像都一样，据说是因为一个bug，建议关掉
"editor.stickyTabStops": true,//在缩进上移动光标时四个空格一组来移动，就仿佛它们是制表符(\t)一样
"editor.wordBasedSuggestions": false,//关闭基于文件中单词来联想的功能（语言自带的联想就够了，开了这个会导致用vscode写MarkDown时的中文引号异常联想）
"editor.linkedEditing": true,//html标签自动重命名（喜大普奔！终于不需要Auto Rename Tag插件了！）
"editor.wordWrap": "on",//在文件内容溢出vscode显示区域时自动折行
"editor.cursorSmoothCaretAnimation": true,//让光标移动、插入变得平滑
"editor.renderControlCharacters": true,//编辑器中显示不可见的控制字符
"editor.renderWhitespace": "boundary",//除了两个单词之间用于分隔单词的一个空格，以一个小灰点的样子使空格可见
/*terminal*/
"terminal.integrated.defaultProfile.windows": "Command Prompt",//将终端设为cmd，个人比较喜欢cmd作为终端
"terminal.integrated.cursorBlinking": true,//终端光标闪烁
"terminal.integrated.rightClickBehavior": "default",//在终端中右键时显示菜单而不是粘贴（个人喜好）
/*files*/
"files.autoGuessEncoding": true,//让VScode自动猜源代码文件的编码格式
"files.autoSave": "onFocusChange",//在编辑器失去焦点时自动保存，这使自动保存近乎达到“无感知”的体验
"files.exclude": {//隐藏一些碍眼的文件夹
"**/.git": true,
"**/.svn": true,
"**/.hg": true,
"**/CVS": true,
"**/.DS_Store": true,
"**/tmp": true,
"**/node_modules": true,
"**/bower_components": true
},
"files.watcherExclude": {//不索引一些不必要索引的大文件夹以减少内存和CPU消耗
"**/.git/objects/**": true,
"**/.git/subtree-cache/**": true,
"**/node_modules/**": true,
"**/tmp/**": true,
"**/bower_components/**": true,
"**/dist/**": true
},
/*workbench*/
"workbench.list.smoothScrolling": true,//使文件列表滚动变平滑
"workbench.editor.enablePreview": false,//打开文件时不是“预览”模式，即在编辑一个文件时打开编辑另一个文件不会覆盖当前编辑的文件而是新建一个标签页
"workbench.editor.wrapTabs": true,//编辑器标签页在空间不足时以多行显示
"workbench.editor.untitled.hint": "hidden",//隐藏新建无标题文件时的“选择语言？”提示（个人喜好，可以删掉此行然后Ctrl+N打开无标题新文件看看不hidden的效果）
/*explorer*/
"explorer.confirmDelete": false,//删除文件时不弹出确认弹窗（因为很烦）
"explorer.confirmDragAndDrop": false,//往左边文件资源管理器拖动东西来移动/复制时不显示确认窗口（因为很烦）
/*search*/
"search.followSymlinks": false,//据说可以减少vscode的CPU和内存占用
/*window*/
"window.menuBarVisibility": "visible",//在全屏模式下仍然显示窗口顶部菜单（没有菜单很难受）
"window.dialogStyle": "custom",//使用更具有VSCode的UI风格的弹窗提示（更美观）
/*debug*/
"debug.internalConsoleOptions": "openOnSessionStart",//每次调试都打开调试控制台，方便调试
"debug.showBreakpointsInOverviewRuler": true,//在滚动条标尺上显示断点的位置，便于查找断点的位置
"debug.toolBarLocation": "docked",//固定调试时工具条的位置，防止遮挡代码内容（个人喜好）
"debug.saveBeforeStart": "nonUntitledEditorsInActiveGroup",//在启动调试会话前保存除了无标题文档以外的文档（毕竟你创建了无标题文档就说明你根本没有想保存它的意思（至少我是这样的。））
"debug.onTaskErrors": "showErrors",//预启动任务出错后显示错误，并不启动调试
/*html*/
"html.format.indentHandlebars": true//在写包含形如{{xxx}}的标签的html文档时，也对标签进行缩进（更美观）
}

```

  
好用的插件及其相关设置  
以下列出了一些好用的插件及其相关设置，按使用情景分类。

自行选择需要的安装。

**二、通用**

**1、Chinese (Simplified) Language Pack for Visual Studio Code：必不可少的中文插件**

![](1683171760042.png)

汉化你的 vscode！让界面、设置等都变成中文！

**配置**

无需配置，即装即用，记得装完后重启 vscode。

**2、驼峰翻译助手：不再让取变量名成为一件难事**

![](1683171760169.png)

英文不好 写代码起变量名时候 你是否一直这样干?

打开翻译软件  
输入中文  
复制翻译结果  
粘贴英文之后修改命名格式（比如小驼峰、大驼峰）  
现在你只需要按动图这样来就可以了：

![](1683171760312.png)

 选中输入按快捷键一键得到翻译结果 (悄悄告诉你 直接选择英文文本还可以跳过翻译快速改变命名格式)

选择你喜欢的命名格式（比如小驼峰、大驼峰）

  
快捷键

```
win: "Alt+shift+t" 
mac": "cmd+shift+t"

```

**3、Error Lens：在行内突出显示代码 ERROR/WARNING**

**![](1683171760440.png)**

配置

在 settings.json 中加入如下内容作为配置，设置项的意义已经注释：

```
"errorLens.gutterIconsEnabled": true,//在行号的左边显示小错误图标（个人喜好）
"errorLens.fontStyleItalic": true//使错误信息的字体为斜体（个人喜好）

```

**5、Bracket Pair Colorizer 2：美观的彩虹括号，让你不再为繁杂的括号烦恼**

  
使用前：

![](1683171760555.png)

 使用后：

![](1683171760689.png)

**配置**

无需配置，即装即用，记得装完后重启 vscode。

**6、Code Runner：以最简洁的方式运行任何代码**

![](1683171760856.png)

不需要繁琐的 “调试” 配置，Code Runner 可以快速地以最简洁的方式运行你的任何代码！

支持超过 40 种语言！

**一键运行**

安装好 Code Runner 插件之后，打开你所要运行的文件，有多种方式来快捷地运行你的代码：

键盘快捷键 Ctrl+Alt+N  
快捷键 F1 或 Ctrl+Shift+P 调出 命令面板, 然后输入 Run Code  
在编辑区右键选择 Run Code  
在侧边栏文件管理器中右键你要运行的文件，选择 Run Code  
右上角的运行小三角按钮  
这么多运行代码的方式，够便捷不？

**停止运行**

如果要停止代码运行，也有如下几种方式：

键盘快捷键 Ctrl+Alt+M  
快捷键 F1 或 Ctrl+Shift+P 调出 命令面板, 然后输入 Stop Code Run  
**配置**

想要舒服的使用 Code Runner 插件，你需要进行一些配置。

提示：

事实上，通过控制台输入命令的方式能运行大部分代码，而 Code Runner 的原理就是帮你在控制台输入这些命令。

因此，Code Runner 并不能提供运行你的代码所需的环境或编译器，你仍需要下载安装这些环境或编译器。

在 settings.json 中加入如下内容作为配置，设置项的意义已经注释：

```
"code-runner.runInTerminal": true,//在控制台运行代码，防止乱码和不能输入
"code-runner.executorMap": {
"javascript": " cls && cd /d $dir && node $fullFileName && pause",
"python": " cls && cd /d $dir && \"$pythonPath\" -u $fullFileName && pause",
"bat": " cls && cd /d $dir && $fullFileName"
/*这是每种语言运行时所执行命令的对应表，因为笔者使用的语言有限，这里只列出了javascript、python和windows批处理的命令，其他语言的命令可自行添加*/
/*笔者其他博客中可能会有关于对此设置项的添加或删改的内容*/
},
"code-runner.saveFileBeforeRun": true, //运行前自动保存
"code-runner.customCommand": " cls",//这使Ctrl+Alt+K这个快捷键可以快速清空控制台内容
"code-runner.respectShebang": false//我是Windows系统所以不需要按shebang来运行
"code-runner.ignoreSelection": true,//禁用“运行选中部分的代码”功能（个人喜好，感觉这个功能很鸡肋）
//需要注意的是，所有命令前都有一个空格，用来“喂给”上一次运行结尾的“请按任意键继续. . .”

```

运行效果

运行 python：

![](1683171760991.png)

运行 javascript：

![](1683171761114.png)

运行 windows 批处理：

![](1683171761223.png)

**7、VS Code Counter：统计代码行数**

![](1683171761326.png)

统计你的项目中有多少行代码！以及各语言的占比！

用法

快捷键 F1 或 Ctrl+Shift+P 调出 命令面板, 然后输入 Count lines in directory 以开始统计。

统计完成会生成一个. VSCodeCounter 文件夹，并自动打开里面的报告：

例如：

![](1683171761495.png)

**三、前端开发**

  
**1、CSS Navigation：快速跳转到 CSS 的类定义**

![](1683171761643.png)

由于未知原因，笔者电脑上 CSS Peek 插件有时不起作用，遂采用更稳定的 CSS Navigation 作为替代品。

按住 Ctrl 键，鼠标移到 html 中的 CSS 类名上，可悬浮预览该类的 CSS 定义，此时按下鼠标左键，快速跳转到 CSS 定义处。

**效果**

![](1683171761790.png)

**缺点**

不能悬浮预览和跳转到 html 文件内 <style> 标签内的 CSS 类定义，只能悬浮预览和跳转到外部. css 文件的 CSS 类定义处。

**配置**

无需配置，即装即用，记得装完后重启 vscode。

**2、css-auto-prefix：写 CSS 时不再为浏览器前缀发愁**

![](1683171761897.png)

自动补全不同浏览器的 CSS3 前缀。

效果

![](1683171762014.png)

配置

无需配置，即装即用，记得装完后重启 vscode。

**2、Image Preview：快速预览 HTML 中的图片**

![](1683171762144.png)

功能

当鼠标移到 html 文档中的图片路径上时，悬浮预览图片，还可跳转到侧边栏文件管理器中或系统文件管理器中

效果

![](1683171762298.png)

配置

安装这个插件后默认还会在行号左边显示图片缩略图：

笔者不太喜欢，所以通过在 setting.json 中添加如下配置关掉了这个功能：

```
"gutterpreview.showImagePreviewOnGutter": false

```

**3、IntelliSense for CSS class names in HTML：自动补全 CSS 类名**

![](1683171762402.png)

自动补全 CSS 类名。

效果

![](1683171762526.png)

配置

无需配置，即装即用，记得装完后重启 vscode。

**4、JS-CSS-HTML Formatter：格式化 js、css、html 文件**

![](1683171762627.png)

  
用于格式化 js、css、html 文件（其实主要是用来格式 css 文件，因为前两者 vscode 有内置格式化引擎）

配置

需要在 setting.json 中加入如下内容作为配置：

```
"[html]": {
"editor.defaultFormatter": "lonefy.vscode-JS-CSS-HTML-formatter"
},
"[javascript]": {
"editor.defaultFormatter": "lonefy.vscode-JS-CSS-HTML-formatter"
}
"[json]": {
"editor.defaultFormatter": "vscode.json-language-features"
},

```

用于把 html 和 js 的格式化也交给这个插件负责的同时不要把 json 的格式化交给它负责。

**5、Live Server：实时地使用浏览器预览你的前端页面**

![](1683171762742.png)

 还在浏览器里频繁地刷新来预览前端页面？忍受不了写一会代码就要刷新一下来预览页面？试试 Live Server！

用法

在侧边栏 **文件资源管理器** 中**右键** 文件 选择 **Open with Live Server** 启动：

或打开编辑 html 文件时点击 vscode 下方 **状态栏右边** 的 **Go Live** 启动：

此时 Live Server 启动了一个服务器来实现实时预览前端页面。

保存文件时浏览器便会实时更新页面。

效果

![](1683171762891.png)

停止

快捷键 F1 或 Ctrl+Shift+P 调出 命令面板, 然后输入 Stop Live Server 以 停止 Live Server 服务器。

也可以点击 vscode 下方状态栏右边的图标停止 Live Server 服务器。

注意：关闭浏览器并不会停止 Live Server 服务器，但关闭 vscode 可以停止 Live Server 服务器。

配置

默认使用系统默认浏览器访问服务器，通过在 setting.json 中添加如下配置可以改变访问服务器所用的浏览器：

```
"liveServer.settings.CustomBrowser": 浏览器名

```

浏览器名 的取值如下（默认为 null）：

![](1683171762991.png)

**6、open in browser：从 vscode 打开浏览器以预览前端页面**

![](1683171763120.png)

在 vscode 中打开浏览器以预览前端页面

用法

在侧边栏**文件资源管理器**中**右键 html 文件** 选择 **Open In Default Browser** 从浏览器打开以预览页面：

![](1683171763249.png)

如果要在其他浏览器打开可以选择 **Open In Other Browsers**。

配置

无需配置，即装即用，记得装完后重启 vscode。

**7、Path Intellisense：智能补全路径**

![](1683171763390.png)

 智能补全 html 文件中的文件路径。

效果

![](1683171763502.png)

 配置

无需配置，即装即用，记得装完后重启 vscode。

**四、摸鱼**

**1、epub reader：摸鱼必备！vscode 看小说！支持 epub！**

![](1683171763617.png)

功能

支持字体大小，字体颜色自定义  
阅读进度显示以及自动记录  
支持目录跳转  
书架编辑  
添加书本

在 **C:\Users \ 你的用户名 \.vscode\extensions\renkun.reader-1.1.6\book** 路径下增删书本文件（须为. epub 文件类型）

用法

按 **Ctrl+3** 进入小说阅读界面，鼠标移到书本目录下方可自定义字体大小颜色（记得点 save 哦）。

点击要阅读的书本，进入后左右有按钮可翻页，鼠标移到小说阅读界面上方可返回或进行章节跳转。

**2、Markdown All in One：书写 Markdown 利器**

![](1683171763740.png)

从”All in One“的名字可以看出该插件含有很多功能，可以增强 Markdown 写作体验。

具体有哪些功能，大家可以自己探索，笔者不多介绍了。

配置

无需配置，即装即用，记得装完后重启 vscode。

**五、主题**  

笔者所用的主题叫做 Gruvbox Material Dark。

由该插件提供：

![](1683171763849.png)

看起来像这样：

![](1683171763960.png)

**配置**

下载安装该插件后须在 setting.json 中加入如下内容作为配置，设置项的意义已经注释：

```
"gruvboxMaterial.italicKeywords": true,//关键字为斜体
"gruvboxMaterial.darkContrast": "hard"//加深对比度（默认的太浅了）

```