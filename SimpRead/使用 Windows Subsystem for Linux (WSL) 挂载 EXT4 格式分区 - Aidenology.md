---
url: https://blog.aidenli.net/2022/11/29/guides/guide-mount-ext4-with-wsl/
title: 使用 Windows Subsystem for Linux (WSL) 挂载 EXT4 格式分区 - Aidenology
date: 2023-08-16 12:28:50
tag: 
banner: "https://assets.aidenli.net/blog/2022/wsl-ext4/assets/wmic.png"
banner_icon: 🔖
---
Windows 不支持直接挂载 EXT4 格式分区，但这可以通过 WSL2 实现。

## [](#通过-wmicexe-查看硬盘与分区信息)通过 `wmic.exe` 查看硬盘与分区信息

通过 `wmic` 分别列举本机 Disk Drive 与 Partition 的信息：

```
wmic diskdrive list brief
wmic partition list brief
```

输出如图：

![](https://assets.aidenli.net/blog/2022/wsl-ext4/assets/wmic.png)

根据信息找到需要挂载的分区，主要确定硬盘的 `DeviceID`。

## [](#连接并挂载硬盘到-wsl)连接并挂载硬盘到 WSL

以 `\\.\PHYSICALDRIVE2` 分区 `1` 为例，将该分区挂载到 WSL（需要管理员权限）：

```
wsl --mount \\.\PHYSICALDRIVE2 --bare
```

特别地，我们使用 `--bare` 表示希望仅仅将分区连接（attach）到 WSL，在 WSL 内部完成挂载。

登录 WSL，执行 `lsblk`，可以看到新的硬盘被挂载，此例中挂载到了 `/dev/sdc`：

![](https://assets.aidenli.net/blog/2022/wsl-ext4/assets/lsblk.png)

使用 `mount` 挂载分区。例如，若要将 `/dev/sdc2` 挂载到 `/mnt/nvme`：

```
mount /dev/sdc2 /mnt/nvme
```

此时硬盘已成功挂载：

![](https://assets.aidenli.net/blog/2022/wsl-ext4/assets/mount.png)

## [](#从-windows-资源管理器访问)从 Windows 资源管理器访问

当 WSL 启动时，可以通过 Windows 资源管理器访问 WSL 目录，从而访问该 EXT4 分区：

![](https://assets.aidenli.net/blog/2022/wsl-ext4/assets/explorer.png)

## [](#卸载硬盘)卸载硬盘

完成挂载后，在 WSL 中将挂载的分区 umount：

```
umount /dev/sdc2
```

然后在 Windows 中将该硬盘卸载（需要管理员权限）：

```
wsl --unmount \\.\PHYSICALDRIVE2
```