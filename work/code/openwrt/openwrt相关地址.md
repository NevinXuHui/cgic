#openwrt相关地址

原始openwrt地址

[https://github.com/openwrt/openwrt](https://github.com/openwrt/openwrt)

git地址

```Plain Text
git clone https://github.com/openwrt/openwrt.git
```

lede相关地址

[https://github.com/coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)

```Plain Text
git clone https://github.com/coolsnowwolf/lede.git
```

[https://github.com/Lienol/openwrt](https://github.com/Lienol/openwrt)

git 地址

```Plain Text
git clone https://github.com/Lienol/openwrt.git
```



### 如果你使用 WSL/WSL2 进行编译

由于 WSL 的 PATH 中包含带有空格的 Windows 路径，有可能会导致编译失败，请在 `make` 前面加上：

```Plain Text
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

