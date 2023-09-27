---
url: https://alvin.red/2021/11/06/archlinux-xrdp/
title: 配置 Xrdp - 通过 RDP 连接 Arch Linux KDE 远程桌面
date: 2023-08-25 13:05:37
tag: 
banner: "https://images.unsplash.com/photo-1692855676269-487641edd584?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkyOTM5OTM3fA&ixlib=rb-4.0.3&q=85&fit=crop&w=1882&max-h=540"
banner_icon: 🔖
---
* * *

Windows 的 RDP 远程桌面好用，清晰、低延迟、网络流量低、剪贴板文件同步。常年用 Linux 的我偶尔需要用一下 Windows 的时候，就用`Remmina`连一下我的另外一台 Windows 电脑。但是反过来呢？当我想连一下我的 Arch Linux 的时候该怎么办呢？`ssh`？可以解决大多数需求。`ssh -X`配合 MobaXterm，将就能用，很慢很卡，再说 iPad 也没有 MobaXterm。或者用`TeamViewer`，时不时的给你断一下（内网直连也不是很稳定），烦。

以前我也尝试过 Linux 下的 VNC 和 RDP 方案，问题太多基本没法用。最近又尝试了下，好用！

最早用 Ubuntu 8.04，简单，开箱即用。后来折腾了一段时间 Gentoo，可定制性极强，系统的方方面面都自己掌控，就是每次编译时间有点长。工作以后没时间折腾，又换回了 Ubuntu。什么？Windows？一边玩去，很久很久以前确实挺喜欢折腾 Windows 的，但是自从用了 Linux，再也不想碰 Windows。再后来，实在忍受不了 Ubuntu 自作聪明的 GPU Manager 和对上游软件包的乱改，加入了 Arch 邪教。不知不觉 Arch Linux 已经用了 3 年，再也没有重装过系统，随着自己对 Arch Linux 越來越熟悉，配置的越來越完善，可以养老了。最近又补足了一个短板，远程桌面。

截图是 Remmina 连接

![](https://alvin.red/assets/2021-11-06-archlinux-xrdp/remmina.png)

配置过程意想不到的简单。基本上参考 [ArchWiki](https://wiki.archlinux.org/title/xrdp)

```
# 安装必要的软件包，其中xorgxrdp-glamor可以硬件加速
yay -S xrdp xorgxrdp-glamor pulseaudio-module-xrdp
# 修改配置文件
echo "allowed_users=anybody" | sudo tee /etc/X11/Xwrapper.config
cp /etc/X11/xinit/xinitrc ~/.xinitrc
# 注释掉.xinitrc最后几行
# twm &
# xclock -geometry 50x50-1+1 &
# xterm -geometry 80x50+494+51 &
# xterm -geometry 80x20+494-0 &
# exec xterm -geometry 80x66+0+0 -name login
echo "xport DESKTOP_SESSION=plasma" >> ~/.xinitrc
echo "exec /usr/lib/plasma-dbus-run-session-if-needed startplasma-x11"  >> ~/.xinitrc

# /etc/pam.d/xrdp-sesman 加入kwallet5相关的配置
-auth   optional  pam_kwallet5.so
session         optional        pam_keyinit.so force revoke
-session  optional  pam_kwallet5.so auto_start

# /etc/polkit-1/rules.d/49-nopasswd_global.rules 需要添加一些配置
/* Allow members of the wheel group to execute any actions
 * without password authentication, similar to "sudo NOPASSWD:"
 */ 
polkit.addRule(function(action, subject) {
    if ((  action.id == "org.freedesktop.policykit.exec"
    || action.id == "org.fedoraproject.FirewallD1.all"
    || action.id == "org.fedoraproject.FirewallD1.config"
    || action.id == "org.freedesktop.NetworkManager.settings.modify.system") &&
      subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
# 如果还有权限问题
sudo systemctl edit polkit.service
# 打开调试
[Service]
Environment=G_MESSAGES_DEBUG=all
ExecStart=
ExecStart=/usr/lib/polkit-1/polkitd
# 然后把相应的权限添加到rules中

# 启用xrdp服务
sudo systemctl enable --now xray.service xrdp-sesman.service


```

然后就拿出 iPad，用微软的 RDP 客户端连 Arch Linux 吧。微软的 RDP 客户端有个问题，不能手动设置`Network connection type`。需要设置成`LAN`来开启压缩，不然网络流量会很惊人。iPad 上默认是对的，但是调高分辨率后，反而没有开启压缩了。

iPad + 键盘，连远程桌面写代码，这才是生产力！

* * *

## 相关文章