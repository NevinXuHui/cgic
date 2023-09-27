# 修改 [Linux](https://so.csdn.net/so/search?q=Linux&spm=1001.2101.3001.7020) 启动界面停留时间

## 方式一

### 直接修改 / boot/grub2/grub.cfg 配置文件 (不推荐)

- 切换至 root 用户：

```Plain Text
su root

```

- 编辑 /boot/grub2/grub.cfg 配置文件

```Plain Text
# 这个命令是打开图形化界面的文本编辑器进行编辑
gedit /boot/grub2/grub.cfg

# 使用 vim 编辑器
vi /boot/grub2/grub.cfg

```

- 修改内容 (如图)

![](https://imgconvert.csdnimg.cn/aHR0cDovL2J1Y2tldGJsb2cub3NzLWNuLXNoZW56aGVuLmFsaXl1bmNzLmNvbS9ibG9nL3BpYzIwMjAvMDMvbW9kaWZ5X2dydWJfY2ZnLnBuZw?x-oss-process=image/format,png)

- 重启系统 , 查看效果

```Plain Text
shutdown -r now

```

![](https://imgconvert.csdnimg.cn/aHR0cDovL2J1Y2tldGJsb2cub3NzLWNuLXNoZW56aGVuLmFsaXl1bmNzLmNvbS9ibG9nL3BpYzIwMjAvMDMvc3VyZWZhY2U0c3RhcnR1cC5wbmc?x-oss-process=image/format,png)

第一个选项是正常启动，也是默认启动项。第二个急救模式启动 (系统出现问题不能正常启动时使用并修复系统)

## 方式二

### 修改 / etc/default/grub 配置文件 (推荐方式)

- 编辑 /etc/default/grub 配置文件

```Plain Text
# 这个命令是打开图形化界面的文本编辑器进行编辑
gedit /etc/default/grub

# 使用 vim 编辑器
vi /etc/default/grub

```

- 修改 / etc/default/grub 文件中的 **GRUB_TIMEOUT=5** 这一参数值， 且保存退出

- 重新编译生成 grub 文件

```Plain Text
grub2-mkconfig –o /etc/grub2.cfg

```

- 重启系统，查看效果

```Plain Text
shutdown -r now

```

人若无名，专心练剑~！

