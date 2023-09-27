# Ubuntu22.04Server 版用 netplan 设置静态 IP 的 [yaml](https://so.csdn.net/so/search?q=yaml&spm=1001.2101.3001.7020) 模板 /etc/netplan/*.yaml

Server 版 和 Desklop 版 都可以用 `netplan` 配置网络, 但下层是不一样的

- Server 版用 `netplan` 配置 `systemd-networkd`

  ```Plain Text
systemctl status systemd-networkd

```

- Desktop 版用 `netplan` 配置 `NetworkManager`

  ```Plain Text
systemctl status NetworkManager

```

Server 版默认配置文件 `/etc/netplan/00-installer-config.yaml`
查看

```Plain Text
sudo cat /etc/netplan/00-installer-config.yaml

```

因为只有一个文件, 还可以用 `*.yaml` 或 `*` 查看

```Plain Text
sudo cat /etc/netplan/*.yaml

```

```Plain Text
sudo cat /etc/netplan/*

```

一些配置模板
[VMware](https://so.csdn.net/so/search?q=VMware&spm=1001.2101.3001.7020) 环境下用的, 网卡接口 ens33

```Plain Text
network:
  ethernets:
    eno1:
      addresses:
      - 192.168.11.34/24
      # gateway4: 192.168.11.100  # 以前的网关 , 可用,但会提示不赞成
      routes:
        - to: default # default 等效 0.0.0.0/0 等效 0/0   # could be 0/0 or 0.0.0.0/0 optionally
          via: 192.168.11.100  # 网关
      nameservers:
        addresses: # DNS的ip
        - 192.168.11.100 # 本地
        - 8.8.8.8 # 谷歌
        - 8.8.4.4 # 谷歌
        - 1.1.1.1
        - 223.6.6.6 # 阿里
        - 114.114.114.114
        - 180.76.76.76 # 百度
        - 119.29.29.29 # 腾讯
        - 101.226.4.6
        - 123.125.81.6
        search:
        - 192.168.168.2 # 本地
        - 8.8.8.8 # 谷歌
        - 8.8.4.4
        - 1.1.1.1
        - 223.6.6.6 # 阿里
        - 114.114.114.114
        - 180.76.76.76 # 百度
        - 119.29.29.29 # 腾讯
        - 101.226.4.6
        - 123.125.81.6
  version: 2

```

search 可以不要, 暂时也没搞懂用途

```Plain Text
network:
  ethernets:
    ens33:
      addresses:
      - 192.168.168.204/24
      # gateway4: 192.168.168.2  # 以前的网关 , 可用,但会提示不赞成
      routes:
        - to: default # default 等效 0.0.0.0/0 等效 0/0   # could be 0/0 or 0.0.0.0/0 optionally
          via: 192.168.168.2  # 网关
      nameservers:
        addresses: # DNS的ip
        - 192.168.168.2 # 本地
        - 8.8.8.8 # 谷歌
        - 8.8.4.4 # 谷歌
        - 1.1.1.1
        - 223.6.6.6 # 阿里
        - 114.114.114.114
        - 180.76.76.76 # 百度
        - 119.29.29.29 # 腾讯
        - 101.226.4.6
        - 123.125.81.6
  version: 2

```

调整一些 DNS 顺序

```Plain Text
network:
  ethernets:
    ens33:
      addresses:
      - 192.168.168.204/24
      # gateway4: 192.168.168.2  # 以前的网关 , 可用,但会提示不赞成
      routes:
        - to: default # default 等效 0.0.0.0/0 等效 0/0   # could be 0/0 or 0.0.0.0/0 optionally
          via: 192.168.168.2  # 网关
      nameservers:
        addresses: # DNS的ip
        - 192.168.168.2 # 本地
        - 8.8.4.4 # 谷歌
        - 223.6.6.6 # 阿里
        - 114.114.114.114
        - 180.76.76.76 # 百度
        - 119.29.29.29 # 腾讯
        - 8.8.8.8 # 谷歌
        - 101.226.4.6
        - 123.125.81.6
        - 1.1.1.1
  version: 2

```

也可以写成这样

```Plain Text
network:
  ethernets:
    ens33:
      addresses: [192.168.168.204/24]
      routes:
        - to: default # default 等效 0.0.0.0/0 等效 0/0   # could be 0/0 or 0.0.0.0/0 optionally
          via: 192.168.168.2  # 网关
      nameservers:
        addresses: # DNS的ip
         [ 192.168.168.2 , 8.8.4.4 , 223.6.6.6 , 114.114.114.114, 180.76.76.76 , 119.29.29.29 , 8.8.8.8 , 101.226.4.6, 123.125.81.6, 1.1.1.1]
  version: 2

```

```Plain Text
network:
  version: 2
  ethernets:
    ens33:
      addresses: [192.168.168.204/24]
      routes:
        - to: default # default 等效 0.0.0.0/0 等效 0/0   # could be 0/0 or 0.0.0.0/0 optionally
          via: 192.168.168.2  # 网关
      nameservers:
        addresses: # DNS的ip
         [ 192.168.168.2 , 8.8.4.4 , 223.6.6.6 , 114.114.114.114, 180.76.76.76 , 119.29.29.29 , 8.8.8.8 , 101.226.4.6, 123.125.81.6, 1.1.1.1]
        search: 
         [ 192.168.168.2 , 8.8.4.4 , 223.6.6.6 , 114.114.114.114, 180.76.76.76 , 119.29.29.29 , 8.8.8.8 , 101.226.4.6, 123.125.81.6, 1.1.1.1]

```

#### 一些 `netplan` 命令

`netplan generate` ：生成与后端管理工具对应的配置；
`netplan apply` ：应用配置，必要时重启管理工具；
`netplan try` ：在配置得到确认之后才应用，如果配置存在错误，则回滚；
`netplan get`：获取当前 netplan 配置；
`netplan set`：修改当前 netplan 的配置。

```Plain Text
sudo netplan generate # 生成与后端管理工具对应的配置；

```

```Plain Text
sudo netplan apply # 应用配置，必要时重启管理工具；

```

```Plain Text
sudo netplan --debug apply # 调试,返回错误信息；

```

```Plain Text
sudo netplan try # 在配置得到确认之后才应用，如果配置存在错误，则回滚，类似test；

```

```Plain Text
sudo netplan get # 获取当前 netplan 配置；

```

```Plain Text
sudo netplan set # 修改当前 netplan 的配置。

```

