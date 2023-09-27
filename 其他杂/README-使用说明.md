## 引言
本Obsidian&Logseq开箱即用库由Springrain（微信公众号：及时春雨）建立，参考了由Cuman建立的[Examples库](https://github.com/cumany/Blue-topaz-examples)、TYuuuChen博主的[时间管理开箱即用库-OB 工具箱](https://www.jianguoyun.com/p/DejxOSUQkdv8Bhjrja8E)。

本库是一个包含Obsidian基本功能的入门及进阶库，并内置了Obsidian的常用插件。并且也可以使用Logseq打开进行编辑文献笔记，两者相得益彰，助力工作流的建立。

需要用[Obsidian](https://obsidian.md/)软件（由于插件版本适配问题，建议使用Obsidian v1.1.16版本，并在设置中点击关于，关闭自动更新）或Logseq客户端、[Logseq网页版](https://logseq.com/#/)打开本库即可。

当安装v1.1.16版本后，若重启发现被自动更新为当前最新版，可以删除如下图中的文件（以v1.0.3举例），进行版本回退：
  ![](https://gcore.jsdelivr.net/gh/springrain1/image/img/20221105175113.png)
#
**八大工作区的基本用法如下：**![[工作区使用详解.canvas]]
后续会出本库详细的使用教程，敬请期待！

## 文件夹说明
- .obsidian：obsidian配置文件
- .obsidian@mobile：obsidian手机端配置文件
  （设置→关于→切换配置文件夹，输入`.obsidian@mobile`后，点击重新启动应用）
- assets：各类附件
- canvas：白板文件
- cubox：剪藏的文档存放
- journals：每日日记&闪念笔记
- logseq：logseq配置文件
- pages：文献笔记&永久笔记

## OB快捷键
- ![[Obsidian快捷键规划]]

## OB内置的插件
==说明==：本库精选了50个Obsidian的常用插件（手机端支持18个），满足笔记软件常见场景使用。其中：（1）obsidian-image-auto-upload-plugin需要搭配联用Picgo软件使用（图床），若只需要使用本地图片，建议关闭此插件！（在[[FastStart-Plugins-LongDelay]]中屏蔽此插件ID，见第3行行首加入`//`，重启OB即可）；（2）booknote插件的配置需要根据你解压本库的路径做相应修改，如下图所示：
 ![](https://gcore.jsdelivr.net/gh/springrain1/image/img/20220308194222.png)
==补充==：如遇到booknote插件无法打开阅读，可能是端口占用问题，建议重启电脑。

| 序号   | 插件名称                          | 解释                               |
|----|----|----|
| 1    | 增强编辑                           | 提供大量格式排版相关快捷操作                   |
| 2    | templater-obsidian                | Ob模板插件                           |
| 3    | remember-cursor-position          | 记住光标位置                           |
| 4    | recent-files-obsidian             | 最近文件列表                           |
| 5    | quickadd                          | 快速添加命令和动作                        |
| 6    | obsidian-style-settings           | 主题设置插件，必备                        |
| 7    | obsidian-outliner                 | 类似幕布大纲操作插件                       |
| 8    | obsidian-kanban                   | 看板                               |
| 9    | dataview                          | 数据查询插件                           |
| 10   | cMenu魔改版 by cuman               | 快捷工具栏，需要依赖增强编辑插件               |
| 11   | calendar                          | 日历插件                             |
| 12   | obsidian-floating-toc-plugin      | 编辑模式浮动大纲                         |
| 13   | obsidian-memos by bon             | 流水账的方式记录日记，依赖日记插件                |
| 14   | booknote                          | pdf查看和标注插件                       |
| 15   | obsidian-advanced-uri             | 外部高级URL支持                        |
| 16   | Commander(cmdr)                   | 在各工具栏/bar添加命令按钮                             |
| 17   | obsidian-zoom                     | 类似幕布大纲操作插件-聚焦                    |
| 18   | obsidian-dynamic-highlights       | Memos动态时钟                        |
| 19   | flashcards-obsidian               | 联用Anki，闪卡制作                      |
| 20   | obsidian-enhancing-mindmap        | 联用XMind，思维导图                     |
| 21   | obsidian-image-auto-upload-plugin | 联用Picgo，图床插件                     |
| 22   | obsidian-image-toolkit            | 图片全屏显示                           |
| 23   | mx-bili-plugin                    | B站视频时间戳                          |
| 24   | media-extended                    | 本地视频时间戳                          |
| 25   | obsidian-hover-editor             | 任意页面实现悬浮/悬停                      |
| 26   | persistent-graph                  | 图谱节点位置保存与恢复                      |
| 27   | obsidian-admonition               | 添加突出显示栏                          |
| 28   | obsidian-agtable                  | 在实时预览下编辑表格                       |
| 29   | obsidian-regex-pipeline           | 正则表达式格式化内容                       |
| 30   | obsidian-excalidraw-plugin        | 手绘绘图插件                           |
| 31   | obsidian-weread-plugin            | 微信读书插件,导出笔记至ob |
| 32   | obsidian-spaced-repetition        | 间隔复习插件，类似Anki                    |
| 33   | obsidian-checklist-plugin         | 不同md文件中的任务汇总                     |
| 34   | tag-wrangler                      | 标签批量修改                           |
| 35   | omnisearch                        | 文本内容快速检索（移动端检索神器）                |
| 36   | remotely-save                     | 电脑端与手机端同步                        |
| 37   | nldates-obsidian                  | Memos配套时间检索插件                    |
| 38   | obsidian-projects                 | 项目管理插件                            |
| 39   | metaedit                          | 文件管理插件                           |
| 40   | big calendar                      | 大日历插件，日周月及日程视图，搭配Memos使用         |
|41|various-complements|自动补全插件|
|42|obsidian-pandoc|多格式导出文档|
|43|obsidian-view-mode-by-frontmatter|通过yaml设置文档默认打开是预览还是编辑模式|
|44|obsidian-version-history-diff|文档修改历史恢复插件|
|45|obsidian-language-learner|LingQ英语学习插件|
|46|drawio-obsidian|drawio绘图插件|
|47|surfing|ob浏览器插件|
|48|canvas-css-class|canvas白板背景颜色修改及同色高亮显示插件|
|49|extract-highlights-plugin|文本高亮提取|
|50|obsidian-file-link|外部文件链接（附件管理）|
## OB使用补充及辅助增强
- **基本概念**
	- 双链建立的4种方法
		- 选中关键词在英文输入法下按 `[[`
		- 选中关键词在中文输入法下按`alt+[`
		- 在文档编辑的时候，中文输入法下直接输入两个`【`，会自动转化为双链括号
		- 反向链接面板将提到的关键词转为链接
	- 反向链接面板
		- 提到当前文件名：还有哪篇文档提到过此主题词
	- 出链面板
		- 当前笔记中的链接：提到过哪些主题词
		- 当前笔记中潜在的链接：将提到的关键词转为链接，主动去建立双链，完善局部关系图
	- 页面及关系图谱的锁定：此页面不会消失，点击并排打开页面
- **开箱即用库多端同步**
	- 可选方法：使用remotely-save插件 + 坚果云的Webdav（免费）同步，配置如下图：<对于安卓手机，由于需要开启CORS，建议使用onedrive来代替坚果云>
		- 坚果云中获取对应的信息
		  ![](https://gcore.jsdelivr.net/gh/springrain1/image/img/20220620203502.png)
		- remotely-save插件进行设置（电脑端和手机端都需要配置）
		  ![](https://gcore.jsdelivr.net/gh/springrain1/image/img/20220620203548.png)
- **AHK脚本**
	- *Obsidian加速脚本V1.4@Springrain，详细见B站教程及对应的公众号文章*
	- win+1：打开Obsidian_data库，并在库中检索选中的文字
	- win+2：打开Obsidian_mobile库，并在库中检索选中的文字
	- win+3：任意位置摘录内容
	- win+4：输入标题，保存剪贴板内容至pages

## OB基础使用
- Markdown语法学习案例：[[example]]
- 一些技巧汇总如下图：![[Tips.canvas]]

## Logseq基础使用
- B站视频：[Logseq从入门到精通](https://www.bilibili.com/video/BV1144y14764?from=search&seid=13676223703276319938&spm_id_from=333.337.0.0)
- 文档：[[Logseq从入门到精通]]
- B站视频：[如何使用双链笔记工具Logseq践行「卡片大法」？](https://www.bilibili.com/video/BV14q4y1V7Zp?spm_id_from=333.999.0.0)
- 文档：[[卡片大法]]
- 进阶用法参考：[[Logseq和它的五种用法]]

## 可参考阅读的文献
### 入门
- [[软通达对obsidian新手的建议（2022版本）]]
- [[我的Obsidian入门之旅]]
- [[Obsidian优质内容合集]]
- [[Obsidian-插件推荐]]

### 笔记方法论
- [[回归OB的纯与真]]
- [[如何构建个人知识管理系统]]
- [[如何用 obsidian 和 flomo 搭建知识体系]]
- [[看到了一个很有参考意义的工作流]]
- [[盘活读书笔记，记得住，用得上]]
- [[贪多求快为什么不能改善学习？]]

### 其它
本库是我在工作之余，历时几个多月结合自己的实践经验和道法术器的理念打造而成，并定期维护一年多，保持与新版的适配，创作不易，如果对您有帮助，不妨请我喝一杯茶颜悦色，谢谢！如需一对一私教，也可通过微信公众号后台联系。
![[及时春雨up赞赏码.jpg|300]]