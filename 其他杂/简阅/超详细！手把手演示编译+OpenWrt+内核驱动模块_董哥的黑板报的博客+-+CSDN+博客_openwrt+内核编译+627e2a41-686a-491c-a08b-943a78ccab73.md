# 一、前言

- 构建自己的内核驱动模块，相关知识可以参考 OpenWrt 软件编译构建系统文章：[https://dongshao.blog.csdn.net/article/details/102545618](https://dongshao.blog.csdn.net/article/details/102545618)。

- 下面我们自己以一个自己设计的 hello-kernel 内核驱动模块为例，一步一步地构建出自己的驱动模块。

# 二、目录结构

- **通常新增一 个内核驱动模块的主要步骤如下：**

  - 在 OPenWrt 源码的 package/kernel 目录下增加一个目录（例如 hello-kernel）。

  - 在 hello 目录下添加 src 目录，src 目录存放模块源码和源码编译 Makefile 和配置文件 Kconfig。

  - 在 hello-kernel 顶层目录下增加 Makefile。此 Makefile 中包含编译脚本和安装脚本。

- **我们软件的目录为名为 hello-kernel**，放置在 OpenWrt 源码的 package/kernel 目录下：

![](https://img-blog.csdnimg.cn/20191026195933800.png)

![](https://img-blog.csdnimg.cn/20191026195624220.png)

# 三、src 目录设计

- 这个目录下存放着驱动模块的源代码 hello-kernel.c、hello-kernel.c 的 Makefile 文件、配置文件 Kconfig。

![](https://img-blog.csdnimg.cn/20191026195900319.png)

### Makefile 文件

- 这个 Makefile 文件的格式都是固定的，不论是编译什么内核模块都是一样。只需要写入 obj-${CONFIG_HELLO-KERNEL}，然后再后面 += 驱动模块名称的. o 文件名即可。

- 此处我们的驱动模块 Makefile 如下所示：

![](https://img-blog.csdnimg.cn/20191026200035712.png)

### Kconfig 文件

- 这个配置文件是必须有的。

```Plain Text
config HELLO-KERNEL
    tristate "Test kernel driver"
    help
        This is an Kernel Driver Test
        if unsure ,delete it ,just for fun
```

### hello-kernel.c 代码设计

- 此处我们只是来演示如何编译一个 OpenWrt 的内核驱动模块，所以驱动模块没有太多功能。单纯的知识在加载驱动模块和卸载驱动模块的时候打印一下信息，代码如下：

```Plain Text
#include <linux/init.h>
#include <linux/module.h>
 
static int __init hello_init(void)
{
	printk(KERN_INFO "Hello World enter\n");
	return 0;
}
module_init(hello_init);
 
static void __exit hello_exit(void)
{
	printk(KERN_INFO "Hello World exit\n ");
}
module_exit(hello_exit);
 
MODULE_AUTHOR("dongshao-CSDN");
MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("A simple Hello World Module");
MODULE_ALIAS("a simplest module");
```

# 四、顶级 Makefile 设计

```Plain Text
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
 
PKG_NAME:=hello-kernel 
PKG_RELEASE:=1
 
include $(INCLUDE_DIR)/package.mk
 
EXTRA_CFLAGS:= \
    $(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=m,%,$(filter %=m,$(EXTRA_KCONFIG)))) \
    $(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=y,%,$(filter %=y,$(EXTRA_KCONFIG))))  \
 
MAKE_OPTS:=ARCH="$(LINUX_KARCH)" \
    CROSS_COMPILE="$(TARGET_CROSS)" \
    SUBDIRS="$(PKG_BUILD_DIR)" \
    EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
    $(EXTRA_KCONFIG)
 
define KernelPackage/hello-kernel
    SUBMENU:=Other modules
    TITLE:=Hello kernel drive 
    FILES:=$(PKG_BUILD_DIR)/hello-kernel.ko
    AUTOLOAD:=$(call AutoProbe,81,hello-kernel)
endef
 
define Build/Prepare
    mkdir -p $(PKG_BUILD_DIR)/
    $(CP) -R ./src/*  $(PKG_BUILD_DIR)/
endef
 
define Build/Compile
    $(MAKE) -C "$(LINUX_DIR)" \
        $(MAKE_OPTS) CONFIG_HELLO-KERNEL=m \
        modules
endef
$(eval $(call KernelPackage,hello-kernel))
```

### Makefile 解析

- **第一步：**首先包含 rules.mk 和 kernel.mk 文件。接着将驱动模块的名称定义为 “hello-kernel”，并设置版本编号为 “1”。

![](https://img-blog.csdnimg.cn/20191026201419412.png)

- **第二步：**接着是编译时的一些选项，保持默认即可。

![](https://img-blog.csdnimg.cn/20191026202415395.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

- **第三步：**在软件包定义中的一些变量赋值：

  - SUBMENU：我们内核模块放置于 “Other modules”。我们在 make menuconfig 时，可以在 Kernel modules/other modules 菜单下找到这个模块。

  - TITLE：标题，驱动模块的简短描述。

  - FILES：生成的驱动模块的存放位置。此处为设置为在编译目录下（就是编译过程中的临时目录 **build_dir**）。

  - AUTOLOAD：代表是否在系统启动时自动装载到内核中，后面括号内有 3 个参数（参数 1 不变，参数 2 为驱动模块的装载顺序 (可以省略这个参数，省略后系统自动分配状态顺序)，参数 3 代表驱动模块名称）。

  - DEPENDS：如果驱动模块还需要依赖，则此变量设置为依赖文件名（此处没有依赖所以就未设置）。

![](https://img-blog.csdnimg.cn/20191026201638901.png)

- **第四步：**“Build/Prepare” 定义了如何准备编译本软件包，这里创建了编译目录（OKG_BUILD_DIR 就是编译过程中的临时目录 **build_dir**），然后将 src 目录下的所有文件复制到编译目录下

![](https://img-blog.csdnimg.cn/20191026202601567.png)

- **第五步：**编译源代码选项，在大多数情况下应该不用定义而使用默认值，下面我们加入了 “CONFIG_HELLO-KERNEL=m” 这一选项，MAKE_OPTS 变量就是第二步图中定义的变量。

![](https://img-blog.csdnimg.cn/20191026202747877.png)

- 最后 KernelPackage，将驱动模块的名称作为参数传递给 KernelPackage。

![](https://img-blog.csdnimg.cn/20191026203152206.png)

# 五、编译驱动模块

- **第一步：**打开 Ubuntu，将我们的 hello-kernel 目录放入 OpenWrt 源码目录的 package/kernel 目录下。

![](https://img-blog.csdnimg.cn/20191026204158999.png)

- **第二步：**输入 “make menuconfig” 进入选项菜单。

![](https://img-blog.csdnimg.cn/20191026204514425.png)

![](https://img-blog.csdnimg.cn/20191026204535269.png)

![](https://img-blog.csdnimg.cn/20191026204559389.png)

![](https://img-blog.csdnimg.cn/2019102620462015.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

- **第三步：**在 OpenWrt 源码顶级目录下输入下面的命令编译驱动模块。

```Plain Text
make package/kernel/hello-kernel/compile V=s

```

- **第四步：** 编译完成之后会在下面的目录中看到我们的内核模块（因为我们的 OpenWrt 内核是 4.4.92 版本的，所以在这个目录下）。

### 

![](https://img-blog.csdnimg.cn/201910262114038.png)

### 附加知识

- 内核的模块必须要与模块内核版本相同的系统中才可以运行，此处我们的 OpenWrt 源码为 4.4.92 版本，所以在编译完成之后生成的. ko 文件也只能在 4.4.92 内核版本的 OpenWrt 中运行。

- 下面可以输入下面的命令来查看我们的 OpenWr 的内核版本，可以看到为 4.4.92。

![](https://img-blog.csdnimg.cn/20191026212603962.png)

# 六、内核模块的使用

- **第一步：**将我们的内核模块. ko 文件发送到 OpenWrt 系统中。

![](https://img-blog.csdnimg.cn/20191026212806311.png)

- **第二步：**输入 insmod 命令加载我们的内核模块，然后使用 dmesg -c 命令打印一下内核的输出信息。

![](https://img-blog.csdnimg.cn/2019102621324569.png)

- **第三步：**输入下面命令将我们的内核模块卸载。

![](https://img-blog.csdnimg.cn/20191026213358883.png)

# 七、编译过程中出现的问题

### 问题一

- 出现下面的问题，是因为 Makefile 没有涉及好（空格、缩进没有做好）。

![](https://img-blog.csdnimg.cn/20191026205307892.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

- 解决办法，将文件设置为在 Unix 环境下书写，并且每一行的末尾不能有多余的空格。

![](https://img-blog.csdnimg.cn/20191018102517525.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

- 我是小董，V 公众点击 "笔记白嫖" 解锁更多 OpenWrt 资料内容。

![](https://img-blog.csdnimg.cn/20210405083343721.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxNDUzMjg1,size_16,color_FFFFFF,t_70)

