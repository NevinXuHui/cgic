# XMind&Obsidian联用库

## 一、前言

众所周知，XMind已经成为思维导图的代名词，兼备思维导图的灵感发散和大纲的逻辑梳理优势，在电脑端和移动端均能快速编辑制图，还具备即时演示功能，是一款不可多得的生产力工具。Obsidian在Markdown类双链笔记中独占鳌头，在文件管理、新知与旧识建立联系，构建知识体系等方面具有独特优势。本文将介绍Springrain打造的XMind&Obsidian联用库，其利用Obsidian来进行导图管理、导图同步、导图复习和文章拼装，达到1+1＞2的效果。由于联用库使用技巧较为复杂，后续将在B站发布对应的操作视频。

## 二、导图绘制
### XMind快速编辑
作为一个使用思维导图工具近五年的忠实用户，在长期的使用体验中发现如在电脑端绘制导图，建议使用思维导图（Mind Map）视图编辑，并配置好快捷键，建议配置的快捷键如下图，利用左手键盘+右手鼠标协同，在ZEN模式里专注想法，可以获得心流体验。如是移动端，则可采用大纲（Outliner）视图编辑。
![](https://gcore.jsdelivr.net/gh/springrain1/image/img/XMind_4%E5%BF%AB%E6%8D%B7%E9%94%AE.png)

### 从Obsidian中导入
将在Obsidian中撰写Markdown格式的笔记，如下代码块所示的形式，可以直接导入到XMind软件中打开（菜单→文件→导入→Markdown）。
```
# 一级中心主题
一级中心主题-笔记内容
## 二级分支主题1
二级分支主题1-笔记内容
### 三级子主题1
三级子主题1-笔记内容
### 三级子主题2
三级子主题2-笔记内容
#### 四级子主题1
四级子主题1-笔记内容
```
效果如下图：
![](https://gcore.jsdelivr.net/gh/springrain1/image/img/20221106230432.png)

## 三、导图管理
### 使用规则
在XMind软件新建导图后，将文件保存至库中`obsidian_map\xmind`文件夹下。并遵循命名规则，可以在Obsidian电脑端或移动端中搜索关键词后直接点击跳转XMind软件打开其源文件，也可以使用Listary或Everthing等搜索工具快速找到对应的文件。
```
作品序列号（时间戳）=主题名 #导图类型 #制作工具(xmind-8 or xmind-zen)
20221003.1756=回音法 #学习方法 #xmind-8
20221003.1745=Obsidian_map #工具类 #xmind-zen
```
![|300](https://gcore.jsdelivr.net/gh/springrain1/image/img/20221106232115.png)
### XMind导入Obsidian管理
制作的导图文件一多，就特别不容易管理并且难以找到对应的文件来打开编辑迭代，我们这时候就可以在Obsidian中建立MOC来进行管理，筛选文件后复制搜索的结果`- [[中心主题]]`到对应的MOC文档中（如003 思维空间）。
同时，使用XMind导出Markdown或TextBundle格式文件至Obsidian库文件中（菜单→导出→Markdown或TextBundle，后者生成文件夹包含图片），在Obsidian中打开反向链接面板建立反向链接，来实现双向链接的建立。右键选择Regex Pipeline:XMind2OB#MD3正则格式化内容，自动在文档头部加入yaml，按下Alt+M键就可以在Obsidian呈现思维导图。
![](https://gcore.jsdelivr.net/gh/springrain1/image/img/20221107001138.png)

### XMind主题输出
我们在XMind中整理主题笔记时，可以选中主题按下快捷键Alt+Z通过url可以直接跳转Obsidian库中与此主题的同名的md文件，操作视频链接见：https://www.bilibili.com/video/BV1vY411T711/

## 四、导图同步
将XMind源文件嵌入到Obsidian库文件系统中，通过obsidian-remotely-save插件来实现联用库多端同步。插件可以选择同步到坚果云等网盘，这样在Obsidian手机端就可跳转XMind软件打开思维导图源文件编辑修改，电脑端也会同步更新修改内容，弥补XMind软件无自带云同步服务方面的缺陷。

## 五、导图复习
当制作完一个思维导图后，如果不及时复习，大概率就淹没在记忆尘埃中，无法进行迭代，也难以为下次所用。经过长期实践，这里总结出三种有效的复习方法：主动回想、间隔重复、漫游复习。

（1）主动回想。可以利用XMind软件的主题折叠展开功能，先选中中心主题，折叠所有子分支，然后一级一级展开式主动回忆，回忆不起来，进行Flag标记（为选中的主题添加标记），下次可筛选重点复习，强化记忆。
![|400](https://gcore.jsdelivr.net/gh/springrain1/image/img/20221107004846.png)

（2）间隔重复。主要利用obsidian-spaced-repetition插件，通过类SuperMemo算法来跟踪自己的学习进度，自动安排复习间隔，在最少的复习次数下，以保证对已绘制导图的清晰记忆。在Obsidian中按下快捷键Alt+X打开`02 - Map Review | 导图复习`工作区，
![](https://gcore.jsdelivr.net/gh/springrain1/image/img/20221106233510.png)
按照以下图格式，以`::`和`?`作为卡片问答分隔编辑好md文件，答案内容可以插入图片和XMind源文件链接。按下快捷键Alt+S以嵌入外部思维导图图片等内容，在行首加入`!`即调整为标准Markdown图片格式来显示。Obsidian文件列表中右键复制Obsidian链接，即可复制XMind源文件的Obsidian url跳转，修改为Markdown标准链接`[显示内容](链接地址)`。
![|300](https://gcore.jsdelivr.net/gh/springrain1/image/img/20221107011303.png)
打开命令面板，输入对应命令就可以进行导图复习。
![](https://gcore.jsdelivr.net/gh/springrain1/image/img/20221107011139.png)
（3）漫游复习。每天留有固定的时间，利用obsidian自带的漫游笔记功能（左侧边栏按钮：开始漫游笔记），通过回顾发现可能存在的联系并及时迭代思维导图笔记。

## 六、文章拼装
在obsidian-memos插件中积累卡片，简单有效，可以减少认知负荷，任意复用到需要撰写的文章中。

> 人类用卡片封装世界，卡片是人类给自己在洪水来临时造的诺亚方舟。——阳志平

卡片写作基本的流程可以参考如下：
1. 在XMind编辑好文章骨架，导出Markdown文件至Obsidian库文件中；
2. 按下Alt+X打开`04 - Assemble Writing | 卡片写作`工作区，如下图；
![](https://gcore.jsdelivr.net/gh/springrain1/image/img/20221106234234.png)
3. 分别检索Obsidian库、memos中的内容作为文章的血肉，可以直接拖拽到右侧的md文件中；
4. 文章润色修改，排版成文，右键选择Regex Pipeline:Quote&Tag#Del可以一键删除引用、标签等多余内容。

## 七、资源下载
- 后台回复：==联用库==，可获取本文介绍的XMind&Obsidian联用库（含分别适配Obsidian v0.14.6和v1.0.3的两个版本）
- 后台回复：==AHK==，可获取XMind&Obsidian联用库配套使用的脚本源文件及exe