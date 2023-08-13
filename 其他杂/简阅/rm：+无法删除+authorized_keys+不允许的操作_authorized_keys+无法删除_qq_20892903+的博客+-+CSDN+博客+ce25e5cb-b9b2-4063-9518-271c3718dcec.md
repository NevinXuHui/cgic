***问题描述: root 用户在权限为 - rwxrwxrwx(读、写、执行) 时无法删除文件***

***文件名: authorized_keys***

***执行命令: rm -rf authorized_keys***

***提示:*** ***rm: 无法删除 "authorized_keys": 不允许的操作***

***如图所示:***

![](https://img-blog.csdnimg.cn/20200520220027163.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzIwODkyOTAz,size_16,color_FFFFFF,t_70)

# ***解决方案***

***执行命令：***

```Plain Text
chattr -i authorized_keys

```

***在进行删除***

```Plain Text
rm -rf authorized_keys

```

解释: 系统担心在 Linux 环境下会造成一定我误删除操作，会进行一定的加锁处理，具体 chattr 操作详情请见: [https://www.linuxcool.com/chattr](https://www.linuxcool.com/chattr)

