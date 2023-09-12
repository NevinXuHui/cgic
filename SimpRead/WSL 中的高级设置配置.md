---
url: https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config#wslconfig
title: WSL 中的高级设置配置
date: 2023-08-02 12:32:48
tag: 
banner: "https://learn.microsoft.com/en-us/media/open-graph-image.png"
banner_icon: 🔖
---
[wsl.conf](#wslconf) 和 [.wslconfig](#wslconfig) 文件用于根据每个分发配置高级设置选项， (`wsl.conf`) 和全局跨所有 WSL 2 分发 (`.wslconfig`) 。 本指南将介绍每个设置选项、何时使用每种文件类型、存储文件的位置、示例设置文件和提示。

[](#what-is-the-difference-between-wslconf-and-wslconfig)

## wsl.conf 和 .wslconfig 之间的区别是什么？

可以通过以下两种方式配置已安装的 Linux 分发版的设置，这些设置将在每次启动 WSL 时自动应用：

*   **[.wslconfig](#wslconfig)** 用于在 WSL 2 上运行的所有已安装分发中 **全局** 配置设置。
*   **[wsl.conf](#wslconf)** 用于为在 WSL 1 或 WSL 2 上运行的 Linux 发行版配置 **每个发行版** 的设置。

这两种文件类型都用于配置 WSL 设置，但存储文件的位置、配置的范围以及运行分发的 WSL 版本都会影响要选择的文件类型。

正在运行的 WSL 版本将影响配置设置。 WSL 2 作为轻型虚拟机 (VM) 运行，因此使用虚拟化设置可以控制 (使用 Hyper-V 或 VirtualBox) 时可能熟悉的内存或处理器量。

[](#wslconf)

## wsl.conf

*   作为 unix 文件存储在 `/etc` 分发的目录中。
*   用于基于每个分发配置设置。 在此文件中配置的设置将仅应用于包含存储此文件的目录的特定 Linux 分发版。
*   可用于由版本、WSL 1 或 WSL 2 运行的分发版。
*   若要访问已安装的发行版的 `/etc` 目录，请使用发行版的命令行和 `cd /` 访问根目录，然后使用 `ls` 列出文件或使用 `explorer.exe .` 在 Windows 文件资源管理器中查看。 目录路径应类似于： `/etc/wsl.conf`。

[](#wslconfig)

## .wslconfig

*   存储在目录中 `%UserProfile%` 。
*   用于在作为 WSL 2 版本运行的所有已安装 Linux 发行版中全局配置设置。
*   **只能用于 WSL 2 运行的分发**。 作为 WSL 1 运行的分发版不受此配置的影响，因为它们未作为虚拟机运行。
*   要访问 `%UserProfile%` 目录，请在 PowerShell 中使用 `cd ~` 访问主目录（通常是用户配置文件 `C:\Users\<UserName>`），或者可以打开 Windows 文件资源管理器并在地址栏中输入 `%UserProfile%`。 目录路径应类似于： `C:\Users\<UserName>\.wslconfig`。

WSL 将检测这些文件是否存在、读取内容，并在每次启动 WSL 时自动应用配置设置。 如果文件缺失或格式错误 (标记格式不正确) ，WSL 将继续正常启动，而不应用配置设置。

[检查运行的 WSL 版本。](install#check-which-version-of-wsl-you-are-running)

使用 wsl.conf 文件调整每个发行版设置的功能仅适用于 Windows 版本 17093 及更高版本。

[](#the-8-second-rule)

### 8 秒规则

必须等到运行 Linux 分发版的子系统完全停止运行并重启，配置设置更新才会显示。 关闭分发 shell 的所有实例后，这通常需要大约 8 秒。

如果启动分发 (（例如 Ubuntu) ），请修改配置文件，关闭该分发，然后重新启动它，则可能假定配置更改已立即生效。 但当前情况并非如此，因为子系统可能仍在运行。 在重新启动之前，必须等待子系统停止，以便有足够的时间来提取更改。 可以通过使用 PowerShell 和以下命令来检查关闭 Linux 发行版 (shell) 后其是否仍在运行：`wsl --list --running`。 如果没有分发正在运行，则会收到响应：“没有正在运行的分发。现在可以重启分发，以查看配置更新已应用。

命令 `wsl --shutdown` 是重启 WSL 2 分发版的快速路径，但它会关闭所有正在运行的分发版，因此请明智地使用。

[](#configuration-settings-for-wslconf)

## wsl.conf 的配置设置

wsl.conf 文件根据每个分发配置设置。 _(有关 WSL 2 分发版的全局配置，请参阅 [.wslconfig](#wslconfig)) 。_

wsl.conf 文件支持四个部分： `automount`、 `network`、 `interop`和 `user`。 _(按照. ini 文件约定建模，密钥在节下声明，如 .gitconfig files.)_ 有关 [wsl.conf](#wslconf) 文件的存储位置的信息，请参阅 wsl.conf。

[](#systemd-support)

### systemd 支持

许多 Linux 分发版默认运行 “systemd”， (包括 Ubuntu) 和 WSL 最近添加了对此系统 / 服务管理器的支持，因此 WSL 更类似于在裸机计算机上使用你喜欢的 Linux 分发版。 需要 WSL 0.67.6+ 版本才能启用 systemd。 使用命令 `wsl --version`检查 WSL 版本。 如果需要更新，可以在 [Microsoft Store 中获取最新版本的 WSL](https://aka.ms/wslstorepage)。 有关详细信息，请参阅 [博客公告](https://devblogs.microsoft.com/commandline/a-preview-of-wsl-in-the-microsoft-store-is-now-available/)。

若要启用 systemd，请使用 管理员权限在文本编辑器中打开`wsl.conf`文件，并将以下行添加到 `/etc/wsl.conf`：`sudo`

```
[boot]
systemd=true


```

然后，需要使用 PowerShell 关闭 WSL 分发 `wsl.exe --shutdown` 以重启 WSL 实例。 分发重启后，systemd 应运行。 可以使用 命令进行确认： `systemctl list-unit-files --type=service`，该命令将显示服务的状态。

[](#automount-settings)

### 自动装载设置

节标签：`[automount]`

<table aria-label="表 1"><thead><tr><th>key</th><th>值</th><th>default</th><th>说明</th></tr></thead><tbody><tr><td>enabled</td><td>boolean</td><td>是</td><td><code>true</code> 导致固定驱动器（即 <code>C:/</code> 或 <code>D:/</code>）自动装载到 DrvFs 中的 <code>/mnt</code> 下。 <code>false</code> 表示驱动器不会自动装载，但你仍可以手动或通过 <code>fstab</code> 装载驱动器。</td></tr><tr><td>mountFsTab</td><td>boolean</td><td>是</td><td><code>true</code> 设置启动 WSL 时要处理的 <code>/etc/fstab</code>。 /etc/fstab 是可在其中声明其他文件系统的文件，类似于 SMB 共享。 因此，在启动时，可以在 WSL 中自动装载这些文件系统。</td></tr><tr><td>root</td><td>string</td><td><code>/mnt/</code></td><td>设置固定驱动器要自动装载到的目录。 默认情况下，此项设置为 <code>/mnt/</code>，因此 Windows 文件系统 C 驱动器装载到 <code>/mnt/c/</code>。 如果更改为 <code>/mnt/</code><code>/windir/</code>，应会看到固定的 C 驱动器已装载到 <code>/windir/c</code>。</td></tr><tr><td>选项</td><td>以逗号分隔的值列表，例如 uid、gid 等，请参阅下面的自动装载选项</td><td>空字符串</td><td>下面列出了自动装载选项值，并追加到默认 DrvFs 装载选项字符串中。 <strong>只能指定特定于 DrvFs 的选项。</strong></td></tr></tbody></table>

自动装载选项作为所有自动装载驱动器的装载选项应用。 若要仅更改特定驱动器的选项，请改用 `/etc/fstab` 文件。 通常由装载二进制文件分析成标志的选项不受支持。 如果要显式指定这些选项，则必须在 中包含 `/etc/fstab`要执行此操作的每个驱动器。

[](#automount-options)

#### 自动装载选项

为 Windows 驱动器 (DrvFs) 设置不同的装载选项可以控制为 Windows 文件计算文件权限的方式。 提供了以下选项：

<table aria-label="表 2"><thead><tr><th>密钥</th><th>说明</th><th>默认</th></tr></thead><tbody><tr><td>uid</td><td>用于所有文件的所有者的用户 ID</td><td>WSL 发行版的默认用户 ID 在首次安装时 (默认为 1000)</td></tr><tr><td>gid</td><td>用于所有文件的所有者的组 ID</td><td>WSL 发行版的默认组 ID 在首次安装时 (默认为 1000)</td></tr><tr><td>umask</td><td>要对所有文件和目录排除的权限的八进制掩码</td><td>022</td></tr><tr><td>fmask</td><td>要对所有文件排除的权限的八进制掩码</td><td>000</td></tr><tr><td>dmask</td><td>要对所有目录排除的权限的八进制掩码</td><td>000</td></tr><tr><td>metadata</td><td>是否将元数据添加到 Windows 文件以支持 Linux 系统权限</td><td>disabled</td></tr><tr><td>case</td><td>确定被视为区分大小写的目录以及使用 WSL 创建的新目录是否将设置标志。 有关选项的详细说明，请参阅<a href="case-sensitivity" data-linktype="relative-path">区分大小写</a>。 选项包括 <code>off</code>、 <code>dir</code>或 <code>force</code>。</td><td><code>off</code></td></tr></tbody></table>

默认情况下，WSL 将 uid 和 gid 设置为默认用户的值。 例如，在 Ubuntu 中，默认用户为 uid=1000，gid=1000。 如果此值用于指定不同的 gid 或 uid 选项，则默认用户值将被覆盖。 否则，将始终追加默认值。

用户文件创建模式掩码 (umask) 为新创建的文件设置权限。 默认值为 022，只有你可以写入数据，但任何人都可以读取数据。 可以更改值以反映不同的权限设置。 例如， `umask=077` 将权限更改为完全私有，其他用户无法读取或写入数据。 若要进一步指定权限，也可以使用 fmask (文件) 和 dmask (目录) 。

权限掩码在应用到文件或目录之前通过一个逻辑或操作进行设置。

[](#what-is-drvfs)

#### 什么是 DrvFs？

DrvFs 是 WSL 的文件系统插件，旨在支持 WSL 和 Windows 文件系统之间的互操作。 DrvFs 使 WSL 能够在 /mnt 下装载具有支持的文件系统的驱动器，例如 /mnt/c、/mnt/d 等。有关在装载 Windows 或 Linux 驱动器或目录时指定默认区分大小写行为的详细信息，请参阅 [区分大小写](case-sensitivity) 页。

[](#network-settings)

### 网络设置

节标签：`[network]`

<table aria-label="表 3"><thead><tr><th>key</th><th>值</th><th>default</th><th>说明</th></tr></thead><tbody><tr><td>generateHosts</td><td>boolean</td><td><code>true</code></td><td><code>true</code> 将 WSL 设置为生成 <code>/etc/hosts</code>。 <code>hosts</code> 文件包含主机名对应的 IP 地址的静态映射。</td></tr><tr><td>generateResolvConf</td><td>boolean</td><td><code>true</code></td><td><code>true</code> 将 WSL 设置为生成 <code>/etc/resolv.conf</code>。 <code>resolv.conf</code> 包含能够将给定主机名解析为其 IP 地址的 DNS 列表。</td></tr><tr><td>hostname</td><td>字符串</td><td>Windows 主机名</td><td>设置要用于 WSL 分发的主机名。</td></tr></tbody></table>

[](#interop-settings)

### 互操作设置

节标签：`[interop]`

这些选项在预览体验成员内部版本 17713 和更高版本中可用。

<table aria-label="表 4"><thead><tr><th>key</th><th>值</th><th>default</th><th>说明</th></tr></thead><tbody><tr><td>enabled</td><td>boolean</td><td><code>true</code></td><td>设置此键可确定 WSL 是否支持启动 Windows 进程。</td></tr><tr><td>appendWindowsPath</td><td>boolean</td><td><code>true</code></td><td>设置此键可确定 WSL 是否会将 Windows 路径元素添加到 $PATH 环境变量。</td></tr></tbody></table>

[](#user-settings)

### 用户设置

节标签：`[user]`

这些选项在版本 18980 及更高版本中可用。

<table aria-label="表 5"><thead><tr><th>key</th><th>值</th><th>default</th><th>说明</th></tr></thead><tbody><tr><td>default</td><td>字符串</td><td>首次运行时创建的初始用户名</td><td>设置此键指定在首次启动 WSL 会话时以哪个用户身份运行。</td></tr></tbody></table>

[](#boot-settings)

### 启动设置

启动设置仅在 Windows 11 和 Server 2022 上可用。

节标签：`[boot]`

<table aria-label="表 6"><thead><tr><th>key</th><th>值</th><th>default</th><th>说明</th></tr></thead><tbody><tr><td>命令</td><td>string</td><td>""</td><td>你希望在 WSL 实例启动时运行的命令字符串。 此命令以根用户身份运行。 例如： <code>service docker start</code>。</td></tr></tbody></table>

[](#example-wslconf-file)

### 示例 wsl.conf 文件

下面的示例 `wsl.conf` 文件演示了一些可用的配置选项。 在此示例中，分发版为 Ubuntu-20.04，文件路径为 `\\wsl.localhost\Ubuntu-20.04\etc\wsl.conf`。

```
# Automatically mount Windows drive when the distribution is launched
[automount]

# Set to true will automount fixed drives (C:/ or D:/) with DrvFs under the root directory set above. Set to false means drives won't be mounted automatically, but need to be mounted manually or with fstab.
enabled = true

# Sets the directory where fixed drives will be automatically mounted. This example changes the mount location, so your C-drive would be /c, rather than the default /mnt/c. 
root = /

# DrvFs-specific options can be specified.  
options = "metadata,uid=1003,gid=1003,umask=077,fmask=11,case=off"

# Sets the `/etc/fstab` file to be processed when a WSL distribution is launched.
mountFsTab = true

# Network host settings that enable the DNS server used by WSL 2. This example changes the hostname, sets generateHosts to false, preventing WSL from the default behavior of auto-generating /etc/hosts, and sets generateResolvConf to false, preventing WSL from auto-generating /etc/resolv.conf, so that you can create your own (ie. nameserver 1.1.1.1).
[network]
hostname = DemoHost
generateHosts = false
generateResolvConf = false

# Set whether WSL supports interop process like launching Windows apps and adding path variables. Setting these to false will block the launch of Windows processes and block adding $PATH environment variables.
[interop]
enabled = false
appendWindowsPath = false

# Set the user when launching a distribution with WSL.
[user]
default = DemoUser

# Set a command to run when a new WSL instance launches. This example starts the Docker container service.
[boot]
command = service docker start


```

[](#configuration-setting-for-wslconfig)

## .wslconfig 的配置设置

.wslconfig 文件为使用 WSL 2 运行的所有 Linux 分发全局配置设置。 _(有关按分发的配置，请参阅 [wsl.conf](#wslconf)) 。_

有关 [.wslconfig](#wslconfig) 文件的存储位置的信息，请参阅 .wslconfig。

具有 的 `.wslconfig` 全局配置选项仅适用于在 Windows 内部版本 19041 及更高版本中作为 WSL 2 运行的分发版。 请记住，可能需要运行 `wsl --shutdown` 来关闭 WSL 2 VM，然后重启 WSL 实例以使这些更改生效。

此文件可以包含以下选项，这些选项会影响为任何 WSL 2 分发提供支持的 VM：

节标签：`[wsl2]`

<table aria-label="表 7"><thead><tr><th>key</th><th>值</th><th>default</th><th>说明</th></tr></thead><tbody><tr><td>内核 (kernel)</td><td>path</td><td>Microsoft 内置内核提供的收件箱</td><td>自定义 Linux 内核的绝对 Windows 路径。</td></tr><tr><td>内存</td><td>大小</td><td>Windows 上总内存的 50% 或 8GB，以较小者为准；在 20175 之前的版本上：Windows 上总内存的 80%</td><td>要分配给 WSL 2 VM 的内存量。</td></tr><tr><td>处理器</td><td>数字</td><td>Windows 上相同数量的逻辑处理器</td><td>要分配给 WSL 2 VM 的逻辑处理器数。</td></tr><tr><td>localhostForwarding</td><td>boolean</td><td><code>true</code></td><td>一个布尔值，用于指定绑定到 WSL 2 VM 中的通配符或 localhost 的端口是否应可通过 <code>localhost:port</code> 从主机连接。</td></tr><tr><td>kernelCommandLine</td><td>字符串</td><td>空白</td><td>其他内核命令行参数。</td></tr><tr><td>safeMode</td><td>boolean</td><td><code>false</code></td><td>在 “安全模式” 中运行 WSL，这会禁用许多功能，并用于恢复处于错误状态的分发。 仅适用于 Windows 11 和 WSL 版本 0.66.2+。</td></tr><tr><td>swap</td><td>大小</td><td>Windows 上 25% 的内存大小四舍五入到最接近的 GB</td><td>要向 WSL 2 VM 添加的交换空间量，0 表示无交换文件。 交换存储是当内存需求超过硬件设备上的限制时使用的基于磁盘的 RAM。</td></tr><tr><td>swapFile</td><td>path</td><td><code>%USERPROFILE%\AppData\Local\Temp\swap.vhdx</code></td><td>交换虚拟硬盘的绝对 Windows 路径。</td></tr><tr><td>pageReporting</td><td>boolean</td><td><code>true</code></td><td>默认设置 <code>true</code> 使 Windows 能够回收分配给 WSL 2 虚拟机的未使用内存。</td></tr><tr><td>guiApplications</td><td>布尔 *</td><td><code>true</code></td><td>一个布尔值，用于在 WSL 中打开或关闭对 GUI 应用程序 (<a href="https://github.com/microsoft/wslg" data-linktype="external">WSLg</a>) 的支持。 仅适用于 Windows 11。</td></tr><tr><td>debugConsole</td><td>布尔 *</td><td><code>false</code></td><td>一个布尔值，用于在 WSL 2 发行版实例启动时打开显示 <code>dmesg</code> 内容的输出控制台窗口。 仅适用于 Windows 11。</td></tr><tr><td>nestedVirtualization</td><td>布尔 *</td><td><code>true</code></td><td>用于打开或关闭嵌套虚拟化的布尔值，使其他嵌套 VM 能够在 WSL 2 中运行。 仅适用于 Windows 11。</td></tr><tr><td>vmIdleTimeout</td><td>数量 *</td><td><code>60000</code></td><td>VM 在关闭之前处于空闲状态的毫秒数。 仅适用于 Windows 11。</td></tr></tbody></table>

具有 `path` 值的条目必须是带有转义反斜杠的 Windows 路径，例如：`C:\\Temp\\myCustomKernel`

具有 `size` 值的条目必须是后跟单位的大小，例如 `8GB` 或 `512MB`。

值类型后为 * 的条目仅在 Windows 11 可用。

[](#example-wslconfig-file)

## 示例 .wslconfig 文件

下面的示例 `.wslconfig` 文件演示了一些可用的配置选项。 在此示例中，文件路径为 `C:\Users\<UserName>\.wslconfig`。

```
# Settings apply across all Linux distros running on WSL 2
[wsl2]

# Limits VM memory to use no more than 4 GB, this can be set as whole numbers using GB or MB
memory=4GB 

# Sets the VM to use two virtual processors
processors=2

# Specify a custom Linux kernel to use with your installed distros. The default kernel used can be found at https://github.com/microsoft/WSL2-Linux-Kernel
kernel=C:\\temp\\myCustomKernel

# Sets additional kernel parameters, in this case enabling older Linux base images such as Centos 6
kernelCommandLine = vsyscall=emulate

# Sets amount of swap storage space to 8GB, default is 25% of available RAM
swap=8GB

# Sets swapfile path location, default is %USERPROFILE%\AppData\Local\Temp\swap.vhdx
swapfile=C:\\temp\\wsl-swap.vhdx

# Disable page reporting so WSL retains all allocated memory claimed from Windows and releases none back when free
pageReporting=false

# Turn off default connection to bind WSL 2 localhost to Windows localhost
localhostforwarding=true

# Disables nested virtualization
nestedVirtualization=false

# Turns on output console showing contents of dmesg when opening a WSL 2 distro for debugging
debugConsole=true


```

[](#additional-resources)

## 其他资源

*   [Windows 命令行博客：自动配置 WSL](https://devblogs.microsoft.com/commandline/automatically-configuring-wsl/)
*   [Windows 命令行博客：Chmod/Chown、DrvFs、文件元数据](https://devblogs.microsoft.com/commandline/chmod-chown-wsl-improvements/)