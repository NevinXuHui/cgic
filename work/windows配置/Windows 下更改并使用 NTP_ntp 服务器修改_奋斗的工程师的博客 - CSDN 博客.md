#NTP #windows 


---
url: https://blog.csdn.net/weixin_53641036/article/details/126613090
title: Windows 下更改并使用 NTP_ntp 服务器修改_奋斗的工程师的博客 - CSDN 博客
date: 2023-03-30 13:53:33
tag: 
banner: "https://img-blog.csdnimg.cn/img_convert/afc76035875d433ed9a88364884320e4.jpeg"
banner_icon: 🔖

---


# Windows 下更改并使用 NTP（时间同步服务器）服务器同步电脑时间

Windows 自带的`time.windows.com`没法同步，只能自己更改 [NTP 服务器](https://so.csdn.net/so/search?q=NTP%E6%9C%8D%E5%8A%A1%E5%99%A8&spm=1001.2101.3001.7020)。 该方法在 Windows 10 中测试通过，Windows 7 应该也没问题，Windows 11 据说要取消控制面板不确定。

我是在购买的 3A 平台购买的服务器进行测试。

### 更改 NTP / 时间同步服务器

#### 选择 NTP 服务器

到[全球可用的 NTP 服务器列表](http://www.ntp.org.cn/pool)选择一个自己喜欢的 NTP 服务器。 例如我选择的是`cn.ntp.org.cn`。

#### 更改 NTP 服务器

更改选项藏在控制面板中。 依次点击`开始菜单` > `Windows系统` > `控制面板`，也可以直接搜索`控制面板`。 进入`控制面板`后，点击`时钟和区域` > `日期和时间`。 在弹出的`日期和时间`窗口的上栏中选择`Internet时间`，点击`更改设置`。

再在弹出的`Internet时间设置`窗口中，将上面选择的 NTP 服务器填入`服务器(E)`输入框中，点击`立即更新` > `确认`。
![](<assets/1680155613714.png>)
### 同步时间

在控制面板中、设置中都可以找到同步 / 更新按钮。 直接对准任务栏中的时间项右键，选择`调整日期/时间(A)`可以直接转跳到设置中，点击`立即同步`进行同步。

![kkk](<assets/1680155613883.png>)