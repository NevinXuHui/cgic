###  交叉编译出现的问题

1、需要32位的交叉编译环境支持
解决方案

```
sudo apt-get install libc6:i386  
sudo apt-get install lib32ncurses5  
sudo apt-get install lib32z1  
sudo apt-get install lib32stdc++6

```

2、json-c库相关函数需要更新


```
json_object_object_get  函数需要更新到  json_object_object_get_ext 
```



3、部分环境变量出现问题

终端公司的设备  编译链做了限制    需要将交叉编译链根文件目录设置为usr


```
TOOLCHAIN_DIR=/mine/AOS-NET/toolchain/uniweb/zhongduan
TOOLCHAIN_NAME=usr
TOOLCHAIN_PREFIX=arm-buildroot-linux-gnueabi-
```

4、ubuntu  编译 交叉编译 找不到 libmpfr.so.4问题

```
ln -s /交叉编译路径/lib/libmpfr.so.4   /usr/lib/x86_64-linux-gnu/libmpfr.so.4
```


