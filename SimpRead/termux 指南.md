---
url: https://zhuanlan.zhihu.com/p/612865403
title: termux 指南
date: 2023-06-26 12:46:48
tag: 
banner: "undefined"
banner_icon: 🔖
---
1.  **termux 简介**

Termux 是一款基于 Android 系统的终端模拟器应用程序，可以在 Android 设备上运行命令行界面和 Linux 软件包。它提供了一个完整的 Linux 环境，包括常用的命令行工具、编程语言和软件包管理器等。用户可以通过 Termux 在 Android 设备上进行开发、测试、编程和系统管理等任务，类似于在 Linux 或 MacOS 上使用终端。

除了基本的终端模拟器功能外，Termux 还支持一些高级功能，如 SSH、Vim 编辑器、Python 解释器等。用户可以通过软件包管理器 apt 安装其他 Linux 软件包，例如 gcc 编译器、OpenSSL 加密库、Node.js 运行时等。此外，Termux 还支持自定义快捷键、多窗口分屏、键盘快捷方式等，可以提高用户的操作效率和体验。

Termux 在开发和测试中也非常有用。用户可以在 Termux 中使用 Git 管理代码库，使用 Python 或 Ruby 编写脚本，使用 Node.js 开发 Web 应用程序。Termux 还支持安装和使用 Android SDK 和 NDK，以便用户进行 Android 应用程序开发和调试。通过 Termux，用户可以在 Android 设备上进行全面的命令行操作和开发任务，这对于那些需要在 Android 设备上进行开发或者需要在移动设备上处理命令行任务的用户来说非常方便。

**2.termux 发展历程**

2015 年，Termux 的第一个版本发布。该版本的功能比较简单，只包括一个轻量级的终端模拟器和一些基本的 Linux 命令和工具。

2016 年，Termux 逐渐发展成为一个支持更多功能和软件包的终端模拟器应用程序。该版本引入了更多的 Linux 工具和软件包，使得用户可以在 Android 设备上进行更加复杂的命令行操作和开发任务。

2017 年，Termux 的版本更新速度进一步加快，并增加了一些新的功能和改进。其中一个重要的改进是支持访问 Android 设备上的存储空间和文件系统，这使得用户可以更方便地在 Termux 中进行文件操作。

2018 年，Termux 增加了对 Python、Ruby 等编程语言的支持，并引入了一个新的软件包管理器，使得用户可以更轻松地安装和更新软件包。

2019 年，Termux 发布了一个重要的更新，包括对图形界面应用程序的支持，例如 VLC 媒体播放器和 Chromium 浏览器。这一更新使得 Termux 在 Android 设备上的应用场景更加广泛。

2020 年，Termux 发布了一系列更新，包括对 Android 10 的支持、更多的软件包、改进的键盘输入和修复了一些错误。

Termux 的开源代码托管在 GitHub 上，它是由开发者 Fredrik Fornwall 创建和维护的。自发布以来，Termux 得到了越来越多的用户和开发者的关注和支持，并且已经成为在 Android 设备上使用命令行和 Linux 软件包的流行选择之一。

**3. 安卓上如何安装 termux**

要在 Android 设备上安装 Termux，请按照以下步骤操作：

在 Google Play 商店中搜索 “Termux”，或者在 Termux 官方网站上下载 apk 文件（[https://termux.com/download.html）](https://termux.com/download.html%EF%BC%89%E3%80%82)

点击 “安装” 按钮，等待应用程序下载和安装完成。

打开 Termux 应用程序，您将看到一个命令行终端窗口。在窗口中，您可以输入各种 Linux 命令和操作，就像在 Linux 终端上一样。

如果您需要安装其他软件包或工具，请使用 apt 软件包管理器来安装。例如，要安装 Python，请在 Termux 终端中输入以下命令：

```
apt update
apt install python


```

这将更新软件包列表并安装 Python 软件包。

使用 Termux 进行命令行操作和开发任务，例如编写脚本、使用 Git 进行版本控制、开发 Android 应用程序等。

需要注意的是，Termux 需要 Android 5.0 或更高版本才能运行。同时，Termux 在默认情况下无法访问 Android 设备上的存储空间和文件系统，用户需要在 Termux 中手动授权才能访问。

**4.termux 界面的操作办法**

Termux 界面的操作方式类似于在 Linux 或 MacOS 上使用终端，以下是一些常用的操作方法：

打开 Termux 应用程序后，您将看到一个命令行终端窗口。在窗口中，您可以输入各种 Linux 命令和操作，例如查看当前目录下的文件列表、创建目录、执行脚本等。

您可以使用虚拟键盘或连接外部物理键盘来输入命令和字符。

如果您需要查看以前执行的命令，可以使用 “上箭头” 和“下箭头”键来浏览历史命令。

Termux 支持多窗口分屏功能。您可以通过点击屏幕左下角的 “+” 图标来打开新的终端窗口，并在不同的窗口中执行不同的命令和操作。

您可以通过在 Termux 中使用 “Ctrl” 和“C”组合键来中止正在运行的命令或程序。

如果您需要在 Termux 中粘贴文本或命令，请按住屏幕，然后选择 “粘贴”。

您可以使用 “exit” 命令来退出 Termux 终端窗口。

**5.termux 如何更换安装源**

Termux 使用 apt 软件包管理器来安装和管理软件包。默认情况下，Termux 使用官方的软件包源（[https://termux.com/pkg/pkgrepo.html），但用户可以更改软件包源，以便下载和安装其他软件包或更新。](https://termux.com/pkg/pkgrepo.html%EF%BC%89%EF%BC%8C%E4%BD%86%E7%94%A8%E6%88%B7%E5%8F%AF%E4%BB%A5%E6%9B%B4%E6%94%B9%E8%BD%AF%E4%BB%B6%E5%8C%85%E6%BA%90%EF%BC%8C%E4%BB%A5%E4%BE%BF%E4%B8%8B%E8%BD%BD%E5%92%8C%E5%AE%89%E8%A3%85%E5%85%B6%E4%BB%96%E8%BD%AF%E4%BB%B6%E5%8C%85%E6%88%96%E6%9B%B4%E6%96%B0%E3%80%82)

以下是更换 Termux 安装源的步骤：

*   打开 Termux 终端窗口，输入以下命令，更新软件包列表：

```
apt update


```

*   输入以下命令，安装 “termux-change-repo” 软件包：

```
apt install termux-change-repo


```

*   输入以下命令，查看当前软件包源：

```
termux-change-repo


```

输入数字 “1” 选择使用官方的软件包源，或输入数字 “2” 选择使用第三方软件包源。如果选择第三方软件包源，请输入其 URL 地址。例如，如果要使用清华大学的软件包源（[https://mirrors.tuna.tsinghua.edu.cn/help/termux/），则输入以下命令：](https://mirrors.tuna.tsinghua.edu.cn/help/termux/%EF%BC%89%EF%BC%8C%E5%88%99%E8%BE%93%E5%85%A5%E4%BB%A5%E4%B8%8B%E5%91%BD%E4%BB%A4%EF%BC%9A)

```
termux-change-repo -r https://mirrors.tuna.tsinghua.edu.cn/termux/stable


```

输入 “Y” 确认更改软件包源，Termux 将下载并更新软件包列表。

需要注意的是，更改软件包源可能会导致某些软件包无法正常安装或更新。建议仅在必要时更改软件包源，并在更改后仔细测试软件包的兼容性和稳定性。

**6.termux 如何访问本机存储**

在默认情况下，Termux 无法访问 Android 设备上的存储空间和文件系统。如果您需要在 Termux 中访问本机存储，需要手动授权 Termux 访问存储权限。

以下是在 Termux 中访问本机存储的步骤：

*   打开 Termux 终端窗口，输入以下命令，授予 Termux 存储访问权限：

```
termux-setup-storage


```

*   系统会弹出一个权限请求框，询问您是否允许 Termux 访问存储。点击 “允许” 按钮，即可授权 Termux 访问存储。
*   授权后，您可以在 Termux 中使用 cd 命令切换到存储目录，并使用 ls 命令查看存储目录下的文件和文件夹。

需要注意的是，Android 的存储空间在 Termux 中是挂载为 “/sdcard” 的目录。因此，如果您需要访问本机存储，可以使用以下命令：

```
cd /sdcard/


```

此外，需要注意的是，在 Termux 中操作本机存储时，要小心不要删除或更改任何关键文件，以免对系统造成损害。

**7.termux 怎么用 proot**

Proot 是一个用户空间的轻量级 Linux 环境模拟器，可以在不需要 root 权限的情况下在 Termux 中运行其他 Linux 发行版的命令和软件包。使用 Proot，您可以在 Termux 中运行 Debian、Ubuntu、Arch Linux 等发行版的命令和软件包，而无需切换到其他应用程序或切换到 root 用户。

以下是使用 Proot 在 Termux 中运行其他 Linux 发行版的步骤：

*   在 Termux 中安装 Proot 软件包。在 Termux 终端中输入以下命令：

```
pkg install proot


```

*   在 Termux 中下载并安装其他 Linux 发行版的文件系统。例如，要安装 Ubuntu，您可以在 Termux 中输入以下命令：

```
proot-distro install ubuntu


```

这将自动下载并安装 Ubuntu 的文件系统和基本软件包。

*   运行其他 Linux 发行版。在 Termux 终端中输入以下命令：

```
proot-distro login ubuntu


```

这将启动 Ubuntu 文件系统的 shell，您可以在其中运行各种命令和操作。

需要注意的是，使用 Proot 可能会导致某些软件包和操作出现兼容性和性能问题。建议仅在必要时使用 Proot，并在使用前仔细测试软件包的兼容性和稳定性。同时，Proot 在默认情况下可能会受到安全限制，例如无法访问 Android 设备上的存储空间。如果需要访问存储空间等权限，可以通过在 Proot 中运行 su 命令切换到超级管理员身份来解决。

**8. 如何在 Termux 开启 SSH**

在 Termux 中开启 SSH 服务可以使其他设备通过 SSH 协议连接到您的 Android 设备，从而在移动设备上执行各种命令和操作。这也是大多数用户启用 Termux 的正确动作，笔记本可能不随身携带，但手机几乎是肯定的，terumx 为什么越来越受欢迎可能正是基于这一点（开发环境随身随时携带）。以下是在 Termux 中开启 SSH 服务的步骤：

*   在 Termux 中安装 openssh 软件包。在 Termux 终端中输入以下命令：

```
pkg install openssh


```

*   启动 SSH 服务。在 Termux 终端中输入以下命令：

```
sshd


```

*   在其他设备上使用 SSH 协议连接到您的 Android 设备。例如，在 Linux 或 MacOS 终端中，您可以使用以下命令连接到 Android 设备：

```
ssh <用户名>@<Android设备IP地址> -p 8022


```

其中，<用户名>为在 Android 设备上的用户名（默认为 “u0_aXXX”），<Android 设备 IP 地址> 为 Android 设备在局域网中的 IP 地址。您可以在 Termux 中输入 “ifconfig” 命令来查看 Android 设备的 IP 地址。因为低位的端口默认情况下 termux 是无法利用的，所以这里用的默认端口是 8022.

*   连接成功后，您可以在 SSH 终端中执行各种命令和操作，就像在 Android 设备上使用 Termux 一样。如果需要退出 SSH 连接，请在 SSH 终端中输入 “exit” 命令。

需要注意的是，开启 SSH 服务可能会带来一定的安全风险，因此建议仅在必要时开启，并在使用前仔细测试和配置安全策略。同时，如果您的 Android 设备处于公共网络中，则应特别小心，并通过配置 SSH 服务密码和访问限制等安全措施来保护您的设备和数据。