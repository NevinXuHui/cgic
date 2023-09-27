# 抽认卡
## 特征

🗃️带有**`# card`的简单抽认卡**  
🎴带有**`# card-reverse`**或**`#card /reverse`的反向抽认卡**  
📅带有**`# card-spaced`**或**`#card /spaced`的仅带空格的卡片**  
✍️**带有Question::Answer**的内联样式  
✍️内联样式与**Question:::Answer反转**  
📃使用**==Highlight==**或**{大括号}**或 **{2:Cloze}完成填空**  
🧠 **上下文感知**模式  
🏷️全局和本地**标签**

🔢支持**LaTeX**  
🖼️支持**图像**  
🎤支持**音频**  
🔗支持**黑曜石 URI**  
⚓支持**参考备注**  
📟支持**代码语法高亮**

有关其他功能，请查看[wiki](https://github.com/reuseman/flashcards-obsidian/wiki)。

案例：
```
# Computer Science

## Languages #card
Stuff

### OOP #card
Stuff

#### C++ #card
Stuff

#### Java #card
Answer

### Functional
Stuff
```

## 这个怎么运作？

下面是一个演示，其中显示了三个主要操作：

1.  **插入**卡片；
2.  **卡片更新**；
3.  **卡的删除**。

![演示图片](https://github.com/reuseman/flashcards-obsidian/raw/main/docs/demo.gif)
![](https://github.com/reuseman/flashcards-obsidian/blob/main/docs/demo.gif)

## 如何使用它？

wiki 详细解释了[如何使用它](https://github.com/reuseman/flashcards-obsidian/wiki)。

## 如何安装

1.  在 Obsidian 上安装此插件：
    
    -   打开设置 > 社区插件
    -   确保安全模式已关闭
    -   单击浏览社区插件
    -   搜索“**Flashcards**”
    -   点击安装
    -   安装后，关闭社区插件窗口并激活新安装的插件
2.  在 Anki 上安装[AnkiConnect](https://ankiweb.net/shared/info/2055492159)
    
    -   工具 > 附加组件 -> 获取附加组件...
    -   粘贴代码**2055492159** > 好的
    -   选择插件>配置>粘贴下面的配置
```
{
    "apiKey": null,
    "apiLogPath": null,
    "webBindAddress": "127.0.0.1",
    "webBindPort": 8765,
    "webCorsOrigin": "http://localhost",
    "webCorsOriginList": [
        "http://localhost",
        "app://obsidian.md"
    ]
}
```
3.  打开插件的设置，在打开 Anki 时按“**授予权限**”
## 在 Anki 上生成卡片

1.  在黑曜石中，打开您有抽认卡的文件
2.  然后插入/更新/删除只需在 Obsidian 中运行命令`Ctrl+p`并执行命令`Flashcards: generate for the current file`

### 插入

写卡片，然后运行上面的命令。插入操作会在 Anki 上添加卡片。同时，在黑曜石中，它会添加一个 ID 来跟踪它们。

### 更新

只需在 Obsidian 中编辑卡片，然后运行上面的命令。  
**注意：确保当您要更新 Anki 的浏览窗口时已关闭。** 不幸的是，这是一个我无法控制的错误，但这是与我正在使用的 Anki API 相关的问题。

### 删除

删除黑曜石中卡片的内容，但不删除ID。该插件会处理它。所以例如
```
## 这是要删除的卡片正面 #card
这是要删除的卡片背面。 
^1607361487244
```
这是你应该离开的：
```
^1607361487244
```
