

[显示行号](vim%E5%9F%BA%E6%9C%AC%E6%8C%87%E4%BB%A4%EF%BC%88%E4%B8%80%EF%BC%89_ChengZhou1%E7%9A%84%E5%8D%9A%E5%AE%A2-CSDN%E5%8D%9A%E5%AE%A2_vim%E5%91%BD%E4%BB%A4+2d4caae4-f479-4d61-ab81-e4a3256c099f/%E6%98%BE%E7%A4%BA%E8%A1%8C%E5%8F%B7%20fdd39663-0edd-4d63-bbb1-73bfd392d78b.md)

# vim基本指令（一）_ChengZhou1的博客-CSDN博客_vim命令

**目录**

[1、进入与退出vim:](https://blog.csdn.net/qq_47713364/article/details/118708515#1%E3%80%81%E8%BF%9B%E5%85%A5%E4%B8%8E%E9%80%80%E5%87%BAvim%3A)

[6、插入模式指令：](https://blog.csdn.net/qq_47713364/article/details/118708515#6%E3%80%81%E6%8F%92%E5%85%A5%E6%A8%A1%E5%BC%8F%E6%8C%87%E4%BB%A4%EF%BC%9A)

# **一、vi与vim**

Vi是linux系统下自带的文本编辑器，[vim](https://so.csdn.net/so/search?q=vim&spm=1001.2101.3001.7020)则是vi的升级版本，代码补完、编译及错误跳转等方便编程的功能特别丰富。

# **二、vim的安装**

在终端中输入 sudo apt-get install vim ,输入密码即可安装。因为我之前安装过，所以显示的不一样。

![20210713190832384.png](20210713190832384.png)

# **三、vim的使用**

## **1、进入与退出vim:**

进入：vi 文件名 （若该文件未被创建则自动创建）；

退出：在普通模式下输入“ : ”然后输入保存退出或退出指令:

w：保存；

q：退出；

wq：保存并退出；

q!：强制退出不保存（!起强制作用）；

输入“ : ”后光标会定位到最底行：

![20210713190832302.png](20210713190832302.png)

## **2、Vim的模式：**

Vim共有六种基本模式和五种派生模式，这里只讲解常用到的三种基本模式：普通模式、插入模式和可视模式。

普通模式：此模式下不能进行输入，键盘上的按键都有其相应的指令；

插入模式：此模式下用于编辑文件；

可视模式：此模式下用于选中某段文本，相当于windows下鼠标左键选中的功能。

## **3、模式间的切换：**

普通模式→插入模式: 输入插入指令即可（插入指令见下文）；

普通模式→可视模式：输入可视指令即可（v、V）；

插入/可视模式→普通模式：按键盘左上角ESC键即可；

## **4、光标的移动**

在vi中，光标的位置不像windows下用鼠标左键选择，而是通过键盘来移动。

键盘上h，j，k，l 分别对应左移、下移、上移、右移（方向键也可移动）；

## **5、motion——表示操作范围的指令**

该指令配合其他操作指令即可完成对特定范围文本的相应操作。

[Untitled](vim%E5%9F%BA%E6%9C%AC%E6%8C%87%E4%BB%A4%EF%BC%88%E4%B8%80%EF%BC%89_ChengZhou1%E7%9A%84%E5%8D%9A%E5%AE%A2-CSDN%E5%8D%9A%E5%AE%A2_vim%E5%91%BD%E4%BB%A4+2d4caae4-f479-4d61-ab81-e4a3256c099f/Untitled%20150e7d6e-69bd-40be-b096-c714c78fdac2.csv)

数字+motion = 重复多个motion。

## **6、插入模式指令：**

[Untitled](vim%E5%9F%BA%E6%9C%AC%E6%8C%87%E4%BB%A4%EF%BC%88%E4%B8%80%EF%BC%89_ChengZhou1%E7%9A%84%E5%8D%9A%E5%AE%A2-CSDN%E5%8D%9A%E5%AE%A2_vim%E5%91%BD%E4%BB%A4+2d4caae4-f479-4d61-ab81-e4a3256c099f/Untitled%20e77067aa-2618-4215-bb69-7ba5dc79c6bd.csv)

## **7、可视模式指令：**

例如：

v(小写)

![20210713193321690.png](20210713193321690.png)

V(大写)

![20210713193429997.png](20210713193429997.png)

## **8、删除命令d**

d+[motion] 可实现快速删除，如下

[Untitled](vim%E5%9F%BA%E6%9C%AC%E6%8C%87%E4%BB%A4%EF%BC%88%E4%B8%80%EF%BC%89_ChengZhou1%E7%9A%84%E5%8D%9A%E5%AE%A2-CSDN%E5%8D%9A%E5%AE%A2_vim%E5%91%BD%E4%BB%A4+2d4caae4-f479-4d61-ab81-e4a3256c099f/Untitled%202b3ed888-56b7-4909-a9fa-c8f58c6e1693.csv)

d + 数字 + motion = 删除多个motion范围。

例如输入d5h:

![20210713195210729.png](20210713195210729.png)

- ->

![20210713195305754.png](20210713195305754.png)

## 9、撤销命令

