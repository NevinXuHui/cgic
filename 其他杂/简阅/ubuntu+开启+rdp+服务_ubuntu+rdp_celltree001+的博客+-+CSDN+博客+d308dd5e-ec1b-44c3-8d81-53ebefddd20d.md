## 概要

ssh 登录用于终端，如果需要 GUI 的远程登陆 [ubuntu](https://so.csdn.net/so/search?q=ubuntu&spm=1001.2101.3001.7020) . 我了解到大概 3 中方案

- vnc

- xrdp

- 第三方软件, 向日葵 TeamViewer 之类的。

因为 vnc 我一直配置不好，所以试了一下 xrdp，这样 windows 上就自带客户端。
遇到了一些问题，记录之。

配置环境:
ubuntu 20.04
win10 21h1

## 安装方法

```Plain Text
sudo apt install xrdp
sudo adduser xrdp ssl-cert
sudo systemctl enable xrdp
sudo systemctl restart xrdp

```

**提示: 如果本机 GUI 登录了某个用户，则此用户就不能使用 xrdp 登录了。会显示黑屏**

## 卡顿优化

使用过程中发现有些卡顿。搜索到方案如下，个人使用效果一般，仅供参考
编辑 `/etc/xrdp/xrdp.ini`

```Plain Text
tcp_send_buffer_bytes=4194304
tcp_recv_buffer_bytes=6291456

```

编辑 `/etc/sysctl.conf`

```Plain Text
net.core.rmem_max = 12582912
net.core.wmem_max = 8388608

```

重启生效

```Plain Text
sudo sysctl -p
sudo systemctl restart xrdp

```

## 常见问题

1. 无法加载桌面的图标

暂时无解，有高手赐教不？

2. Authentication Required to Create Managed Color Device

- 方法 1：修改 policy 文件

编辑 / usr/share/polkit-1/actions/org.freedesktop.color.policy
把所有的`<allow_any>auth_admin</allow_any>` 改为`<allow_any>yes</allow_any>`
把所有的`<allow_inactive>no</allow_inactive>`改为`<allow_inactive>yes</allow_inactive>`
重启系统

- 方法 2：新增 conf 文件 需要版本大于 0.106 (`pkaction –version` 可以查看版本)

新建文件 /etc/polkit-1/localauthority.d.conf/02-allow-color.d.conf
输入以下内容

```Plain Text
polkit.addRule(function(action, subject) {
if ((action.id == “org.freedesktop.color-manager.create-device” ||
action.id == “org.freedesktop.color-manager.create-profile” ||
action.id == “org.freedesktop.color-manager.delete-device” ||
action.id == “org.freedesktop.color-manager.delete-profile” ||
action.id == “org.freedesktop.color-manager.modify-device” ||
action.id == “org.freedesktop.color-manager.modify-profile”) &&
subject.isInGroup(“{users}”)) {
return polkit.Result.YES;
}
});

```

- 方法 3: 新增 pkla 文件

新建文件 /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
输入以下内容

```Plain Text
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes

```

