---
url: https://zhuanlan.zhihu.com/p/555740616
title: 在 ubuntu 用 wine 安装微信 并解决无法输入文字的问题 ubuntu 完美安装微信（转载）
date: 2023-05-26 13:55:16
tag: 
banner: "undefined"
banner_icon: 🔖
---
Ubuntu 安装了优麒麟版 wine 微信，莫名其妙被查看好友，点赞广告短视频，不知道是否有后门。感谢原作者——CSDN 博主「地狱恶狼」提供原版微信安装方法，黑体部分是我安装过程中遇到的问题，一并进行完善。希望对需要的人有所帮助，版权归原作者所有。

sudo apt install wine

官网下载微信 [微信，是一个生活方式](https://weixin.qq.com/) 选择 windows 版本 cd 到下载目录

wine WeChatSetup.exe

微信已可以打开, 但无法输入文字。后面解决这个问题。

sudo apt install winetricks

下面这个命令可能会卡住, 别慌, 看后面。

winetricks riched20

winetricks 会试图下载 2 个文件, 但是在国内无法下载。

找到这一句话 Downloading [https://xxx/W2KSP4_EN.EXE](https://xxx/W2KSP4_EN.EXE) to xxx/.cache/winetricks/win2ksp4

---

下面我们会手动把 W2KSP4_EN.EXE 复制到 xxx/.cache/winetricks/win2ksp4

注意 xxx 需要按照你的实际情况替换 比如我的是 / root/.cache/winetricks/win2ksp4

路径一定不要搞错了

---

同理把 InstMsiW.exe 复制到 xxx/.cache/winetricks/msls31

这两个文件的分享路径我会放在文末 这俩文件在网上可不好找 (等等, 这篇文章不就是在网上吗)

---

关闭卡住的 winetricks riched20 并重新运行一次

**报错：INTEL-MESA: warning: Performance support disabled, consider sysctl dev.i915.perf_stream_paranoid=0**

**执行：**

**sudo sysctl dev.i915.perf_stream_paranoid=0**

**验证修改是否成功，执行：**

**sysctl -n dev.i915.perf_stream_paranoid**

**返回值是 0，证明修改成功。**

**重新执行微信安装，正常安装即可。**

wine ~/.wine/drive_c/Program Files (x86)/Tencent/WeChat/WeChat.exe

(请按照你的实际安装路径运行)

后面会用 python 写一个启动脚本, 以便方便快捷的后台运行 , 后面可以不看了, 但看完会变快捷

把微信安装目录挪到简单的位置 比如~/.wine/drive_c/WeChat 因为路径有空格 python 脚本识别不出来

新建 wecaht.py 脚本 下面 3 行是内容 第 1 行不可省略

#!/usr/bin/python3

import subprocess

subprocess.Popen('wine ~/.wine/drive_c/WeChat/WeChat.exe', shell=True, stdout=subprocess.PIPE)

脚本复制一份到搜索路径

sudo cp [wecaht.py](http://wecaht.py/) /usr/bin/wechat

给脚本加执行权限

sudo chmod a+x /usr/bin/wechat

命令行输入 wechat 运行微信 命令行可以放心关掉了

wechat

顺便也解决了 QQ 安装后无法输入的问题。但是 QQ 有 linux 版本的，没有折腾的紧迫性。

---

附: W2KSP4_EN.EXE 和 InstMsiW.exe 的案例云盘分享链接 (百度网盘狗都不用)

无密码永久分享 如果链接失效给我发邮件，一般我会立即收到

邮箱 631826964@qq.com

阿里云盘分享链接 [阿里云盘分享](https://www.aliyundrive.com/s/rAfzLoiQUX3)

————————————————

版权声明：本文为 CSDN 博主「地狱恶狼」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。

原文链接：[在 ubuntu 用 wine 安装微信 并解决无法输入文字的问题 ubuntu 完美安装微信](https://blog.csdn.net/qq_40878431/article/details/125869965)