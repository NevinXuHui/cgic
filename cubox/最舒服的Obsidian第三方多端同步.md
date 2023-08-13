# 最舒服的Obsidian第三方多端同步

[mp.weixin.qq.com](https://mp.weixin.qq.com/s/Y54UBtS46OxyQ-WhBb7U7A)赵传文 维客笔记

> 关于ob的多端同步，永远有讨论不完的话题，今天终于体验到了最舒服的Obsidian第三方同步，开心~

使用到的同步设备是windows和ios

同步插件是remotely save，此插件支持利用以下几个网盘来同步，个人觉得onedrive 5Gb的空间挺大的，就选用这个了

![](https://cubox.pro/c/filters:no_upscale()?imageUrl=https%3A%2F%2Fmmbiz.qpic.cn%2Fmmbiz_png%2FPR2BLDgtAWSfVnficFD1tOv241fiaia0cciappCWKfpVbjibCFmI3m9ZeZdGRpicUzF2BvdRW0UaLtbDaQBeVMsEQgpQ%2F640%3Fwx_fmt%3Dpng)

具体方法见中文社区中[这个帖子](https://forum-zh.obsidian.md/t/topic/5291)
内容如下：

---

# Obsidian Remotely Save 插件实现电脑和移动端同步

[forum-zh.obsidian.md](https://forum-zh.obsidian.md/t/topic/5291)

前几天看到论坛有人提到这个 Remotely Save 插件支持了删除文件的同步后，我今天试用了一下其使用 OneDrive 方式进行多端同步。我这里是 windows 和 iphone 进行同步。感觉方法简单且效果不错，所以写了这篇文档分享给大家。

## 1. 电脑端安装和设置

首先，需要在 Obsidian 插件社区下载这款插件，然后启用。

在插件设置面板选择按下图进行设置，此处以 onedrive 为例

[![](https://cubox.pro/c/filters:no_upscale()?imageUrl=https%3A%2F%2Fforum-zh.obsidian.md%2Fuploads%2Fdefault%2Foptimized%2F2X%2F8%2F87204084ab8567dd9e5305d97e29fc1ae6d4cc91_2_690x259.png)

Onedrive 进行同步第一步，`choose service` 下拉选项中选择 `OneDrive for personal (alpha)`。

然后点击第二步的 Auth，这是让 Remotely Save 插件获取你的 OneDrive 的一些权限。他会弹出如下提示窗口，只需要点击蓝色的链接，就可以跳转到浏览器

[![](https://cubox.pro/c/filters:no_upscale()?imageUrl=https%3A%2F%2Fforum-zh.obsidian.md%2Fuploads%2Fdefault%2Foptimized%2F2X%2F5%2F5106b253371ae31f9b4bde4d36d2b35a8f698a48_2_690x192.png)

浏览器会让你登录微软 OneDrive 账号，登录后会出现如下窗口，点击 Continue

![](https://image.cubox.pro/article/2022030911510131519/68852.jpg)

浏览器会弹出一个弹窗，要跳转到 Obsidian，点击打开即可。

![](https://cubox.pro/c/filters:no_upscale()?imageUrl=https%3A%2F%2Fforum-zh.obsidian.md%2Fuploads%2Fdefault%2Foriginal%2F2X%2Ff%2Ff68a043f09027dd3141c7c26e8e7ac19493267ed.png)

点击打开后，系统会自动跳转到 Obsidian 窗口，并弹出下面的小窗口，这是 Remotely Save 在连接 OneDrive。不要关闭这个窗口，等待一会儿它连接成功后就会自动关闭。

![](https://image.cubox.pro/article/2022030911510098578/72493.jpg)

然后插件设置面板变成如下图所示即设置成功，该插件会在 OneDrive 云盘创建 (同步) 文件夹 `/Apps/remotely-save/你的库名称`。

[![](https://cubox.pro/c/filters:no_upscale()?imageUrl=https%3A%2F%2Fforum-zh.obsidian.md%2Fuploads%2Fdefault%2Foptimized%2F2X%2F6%2F6c124eb5233c61bcd2dc4ae35456d1ac7c5e53b4_2_690x214.png)

这样设置就算完成了。设置这里还有个 check 按钮可以测试连接是否成功。（我自己点击后插件显示连接不上，但是实际使用却没有问题）

## 2. 使用 Remotely Save 同步

### 2.1 手动同步

创建、删除或者修改笔记。然后按 `Ctrl+P` 调出命令，搜索 Remotely Save: start sync，回车。（如下图，我这里将该命令固定到了第一个）

[![](https://image.cubox.pro/article/2022030911510186862/42179.jpg)

右上角会有信息提示同步的进度，如下所示

![](https://image.cubox.pro/article/2022030911510186991/35764.jpg)

![](https://image.cubox.pro/article/2022030911510164912/66017.jpg)

最后看到提示 `8/8 Remotely Save finish` 即同步成功。

* * *

除了命令的方式，也可以在 Obsidian 最左边的按钮列里面找到 Remotely Save 的按钮，如下图-
![](https://cubox.pro/c/filters:no_upscale()?imageUrl=https%3A%2F%2Fforum-zh.obsidian.md%2Fuploads%2Fdefault%2Foriginal%2F2X%2Fe%2Fe2004c2df276eac112aae91df551b41d401fa493.png)-
按一下按钮即可，效果和上面的调用命令的方式相同。

### 2.2 设置自动同步

在插件设置面板，可以设置自动多少分钟同步一次，也可以设置软件启动后自动同步一次。

[![](https://cubox.pro/c/filters:no_upscale()?imageUrl=https%3A%2F%2Fforum-zh.obsidian.md%2Fuploads%2Fdefault%2Foptimized%2F2X%2Fe%2Febcb8f22af52aff8c9f69317a7fa37a9f0d3f1b6_2_690x259.png)

## 3. 移动端安装和设置

移动端（或者其他平台）想要同步，需要先创建一个库文件夹，然后用 Obsidian 打开，安装 Remotely Save 插件，插件的设置和上面的一样。

注意的是**创建的笔记库的名称要和想要同步的库的名称一样**。

> 所有以 `.` 或者 `_` 开头的文件或文件夹，这些内容会被视为隐藏文件，不会被同步。

这意味着主题文件和插件都不会被同步！需要在移动端重新安装社区插件和主题。

## 4. 多平台同步流程

在以上所有设置完成之后。

比如在 PC 端修改、编辑文档后， `Ctrl+P` 调出命令，搜索使用 `Remotely Save: start sync` 手动同步。然后在手机端查看，先手动同步，完成后，可以在上面进行编辑和改动，改动后再次手动同步一下。

> 原则就是，修改笔记前，需要把云端最新内容同步到当前设备，修改笔记后，需要把当前修改同步到云端。这样就可以安全地无冲突地达到同步的效果。

我只是初步尝试了下这个插件，我个人比较倾向于自己手动进行同步管理，因为自动同步在后台运行的时候，即使失败了也不会有提示，这样很可能导致自己的某些修改没有同步到云端，而此时另一个设备同步后，会丢失这些修改。再次编辑后，可能会产生冲突。而该插件本身不处理文件的内容冲突，只是每次都选择修改时间最新的文件。

### 4.1 我的个人流程

个人是 windows + iphone + ipad。移动端都只是用来查看笔记的。

在 windows 端设置好后，在 iphone 的 Obsidian 创建新库，同样配置同步。在创建新库的时候选择保存到 icloud。

这样 ipad 端无需设置，直接打开就可以用了，因为内容都由 icloud 同步好了。

在移动端上使用 Things 皮肤，体验非常不错！

## 5. 使用体验

个人测试，我电脑上修改了一篇文档（就是这篇…），同步到 OneDrive 大概 12 秒左右。手机端同步云端内容到本地（也是这篇文档），大概 7 秒左右。这应该和网速有关。

我自己是 windows 和 iphone 进行同步。之前也尝试过其他方法，但是这个插件是最省心简单的，而且速度和体验都还不错，推荐使用！

---

我第一时间试用感觉很完美，很方便，很舒服

下图是通过remotely save插件同步到onedrive中的情况

![](https://cubox.pro/c/filters:no_upscale()?imageUrl=https%3A%2F%2Fmmbiz.qpic.cn%2Fmmbiz_png%2FPR2BLDgtAWSfVnficFD1tOv241fiaia0cciax8PpTD8icRibOajOYL89qhQlSHiboZBBIbibgdVBQ6RIfXgazfy9j38VJg%2F640%3Fwx_fmt%3Dpng)

下图是手机端的情况

![](https://cubox.pro/c/filters:no_upscale()?imageUrl=https%3A%2F%2Fmmbiz.qpic.cn%2Fmmbiz_jpg%2FPR2BLDgtAWSfVnficFD1tOv241fiaia0cciawS9CzKBfDDEBmMuINlRUZkGsHVgzeprE4SYm99ajkXVKEupO1muoBg%2F640%3Fwx_fmt%3Djpeg)

## 额外补充

为了更方便的使用，我对上述方案做了进一步的改进，手动同步**各端只需各点一次按钮**即可

PC端，我特别喜欢cMenu插件[Obsidian插件介绍一](http://mp.weixin.qq.com/s?__biz=MzU4MzgxNjczMA==&mid=2247484614&idx=1&sn=58b577813d0e71e087b0586b265a23e8&chksm=fda207b3cad58ea5bac6160714c2a50ad1306d393684997f207794b68b23900abf19b58c7349&scene=21#wechat_redirect)，我们可将Remotely Save: start sync命令添加cMenu工具栏，需要同步时顺手点一下。

![](https://cubox.pro/c/filters:no_upscale()?imageUrl=https%3A%2F%2Fmmbiz.qpic.cn%2Fmmbiz_png%2FPR2BLDgtAWSfVnficFD1tOv241fiaia0cciah6gK6c2m6icickluPUX5pG6v0nkyVh1scnvSzkQjsB1M962mEB5T00gQ%2F640%3Fwx_fmt%3Dpng)

移动端，我们点击移动工具栏，然后设置快捷命令，这里将Remotely Save: start sync设置为快捷命令![](https://cubox.pro/c/filters:no_upscale()?imageUrl=https%3A%2F%2Fmmbiz.qpic.cn%2Fmmbiz_jpg%2FPR2BLDgtAWSfVnficFD1tOv241fiaia0cciavC2xxwqPFHUHNwoQh1J0gFs9Jm3Kfg9DVuORP3unAB6iaPQnOdzcM7A%2F640%3Fwx_fmt%3Djpeg)

看一下效果，下图左上角即为同步按钮，需要同步时点一下，十分便捷。

![](https://cubox.pro/c/filters:no_upscale()?imageUrl=https%3A%2F%2Fmmbiz.qpic.cn%2Fmmbiz_jpg%2FPR2BLDgtAWSfVnficFD1tOv241fiaia0cciaCr87b8cstaJlw1glWy1TaLZCxmo1iclTdVK4kWlOsjQlQ9rLt7NibicHg%2F640%3Fwx_fmt%3Djpeg)

