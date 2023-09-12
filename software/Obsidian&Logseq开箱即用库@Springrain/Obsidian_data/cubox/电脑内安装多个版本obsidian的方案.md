# 电脑内安装多个版本obsidian的方案

参考[zhuanlan.zhihu.com](https://zhuanlan.zhihu.com/p/597253956)宏沉一笑

## **说明**

说明::ob默认只能安装一个版本的。 这个方法，就是对于想要安装多个版本的人，提供的方案。

## **内容**

## **1、创建目录**
```
obsidian
	├─obsidian-v0.14.6
	│  │  run-ob.bat
	│  │
	│  ├─data
	│  └─Obsidian
	└─obsidian-v1.1.9
		│  run-ob.bat
		│
		├─data
		└─Obsidian
```

## **2、安装obsidian**

安装obsidian v0.14.6 版本

## **3、拷贝obsidian目录**
打开 `C:\Users\Administrator\AppData\Local\obsidian` ，为obsidian安装目录
将内部的所有文件，复制到
```
obsidian
	├─obsidian-v0.14.6
	│  ├─data
	│  └─Obsidian # 这个目录中
```

打开 `C:\Users\Administrator\AppData\Roaming\obsidian` ，为obsidian数据目录
将内部的所有文件，复制到
```
obsidian
	├─obsidian-v0.14.6
	│  ├─data  # 这个目录中
	│  └─Obsidian
```

## **4、卸载obsidian**

将obsidian进行卸载，避免版本之间有影响。

## **5、安装其他的obsidian 版本**

按照2、3、4的步骤进行安装。

## **6、清除安装的缓存**

obsidian安装目录：`C:\Users\Administrator\AppData\Local\obsidian`
obsidian数据目录：`C:\Users\Administrator\AppData\Roaming\Obsidian`
将这两个目录都删除

## **7、建立挂载脚本**

按照目录结构，建立 `run-ob.bat` 脚本
```bat
::obsidian多版本挂载程序

::挂载obsidian应用程序
rmdir %HOMEDRIVE%%HOMEPATH%\AppData\Local\Obsidian
mklink /J %HOMEDRIVE%%HOMEPATH%\AppData\Local\Obsidian %cd%\Obsidian

::挂载obsidian数据
rmdir %APPDATA%\obsidian
mklink /J %APPDATA%\obsidian %cd%\data

:: 启动obsidian
::C:\Users\Administrator\AppData\Local\Obsidian\Obsidian.exe

::pause
```

## **使用**

当想要使用 obsidian v0.14.6 的时候，打开obsidian-v0.14.6的目录，运行下面的 `run-ob.bat` 脚本后，点击obsidian图标就可打开0.14.6版本的ob。