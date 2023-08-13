最近开始整 5G CPE 项目，系统基于 [OpenWrt](https://so.csdn.net/so/search?q=OpenWrt&spm=1001.2101.3001.7020) 系统移植裁剪，打算详细研究了一下整个工程的构建过程，记录一下：

## Openwrt 编译过程概述

编译的总体过程如下:

1. 编译 host 工具

2. 编译交叉工具链

3. 编译内核模块

4. 编译 ipk

5. 安装 ipk 到文件系统

6. 编译内核

7. 将内核和文件系统组合成最终的固件

### 1. 编译 host 工具

虽然我们在开始编译前已经安装了一些必要的工具，但编译过程中还需要其他一些主机工具。这部分工具将首先编译。

### 2. 编译交叉工具链

`openwrt`自带[交叉编译](https://so.csdn.net/so/search?q=%E4%BA%A4%E5%8F%89%E7%BC%96%E8%AF%91&spm=1001.2101.3001.7020)链，当然在编译目标平台软件前，需要先编译。

### 3. 编译内核模块

因为部分内核模块将会生成独立的 ipk，所以内核模块需要首先编译。

### 4. 编译 ipk

这里将编译`package`目录下的各个软件包，这也是和我们最为息息相关的。

### 5. 安装 ipk

将生成的 ipk 安装到文件系统之中 (比如 build_dir/target-XXX/root-ramips 目录)。

### 6. 编译内核

在完成 ipk 编译之后, 将会编译内核, 压缩内核. 同时使用 mkimage 工具，在内核前面生成一个用于 uboot 识别的头部。

### 7. 合成

在最后一步, 将文件系统和内核连接在一起, 即生成了目标二进制镜像文件。

## 顶层 Makefile 结构分析

我们以**`19.07`**的代码为例，整个编译的入口是在源码根目录下的 Makefile。编译的各种命令都应该在源码根目录下键入。
整个主 Makefile 的结构如下：

```Plain Text
world:
 
DISTRO_PKG_CONFIG:=$(shell command -pv pkg-config | grep -E '\/usr' | head -n 1)
export PATH:=$(TOPDIR)/staging_dir/host/bin:$(PATH)
 
ifneq ($(OPENWRT_BUILD),1)
  _SINGLE=export MAKEFLAGS=$(space);
 
  override OPENWRT_BUILD=1
  export OPENWRT_BUILD
  GREP_OPTIONS=
  export GREP_OPTIONS
  CDPATH=
  export CDPATH
  include $(TOPDIR)/include/debug.mk
  include $(TOPDIR)/include/depends.mk
  include $(TOPDIR)/include/toplevel.mk
else
  include rules.mk
  include $(INCLUDE_DIR)/depends.mk
  include $(INCLUDE_DIR)/subdir.mk
  include target/Makefile
  include package/Makefile
  include tools/Makefile
  include toolchain/Makefile
```

开始部分是一些注释和变量定义及路径检查。
根据 **Makefile 的规则**, 在没有指定编译目标的时候, Makefile 中的第一个目标将作为默认目标。
换句话说, 当我们执行`make V=s`时，这个时候编译的目标就是`world`. 和我们执行`make world V=s`效果是一样的。

### 第一层

通常在编译时, 我们不会定义变量`OPENWRT_BUILD`的值, 所以通常我们是会走到顶层的。 
顶层代码如下：

```Plain Text
  _SINGLE=export MAKEFLAGS=$(space);
 
  override OPENWRT_BUILD=1
  export OPENWRT_BUILD
  GREP_OPTIONS=
  export GREP_OPTIONS
  include $(TOPDIR)/include/debug.mk
  include $(TOPDIR)/include/depends.mk
  include $(TOPDIR)/include/toplevel.mk
```

这里我们看到变量`OPENWRT_BUILD`被置为 1，然后包含了 3 个`.mk`文件。
这里稍微解释下`.mk`文件，它们一般没有什么执行动作，都是一些变量的定义还有依赖关系的说明，可以类比于 C 语言的头文件来理解。

debug.mk：

可以通过定义 DEBUG 的值来控制编译过程。

depends.mk：

主要定义了 rdep 这个变量。

toplevel.mk：

这个是我们跟踪编译过程的重要的文件，这个文件在源码根目录下的`include`文件夹下。

核心代码如下：

```Plain Text
%::
	@+$(PREP_MK) $(NO_TRACE_MAKE) -r -s prereq
	@( \
		cp .config tmp/.config; \
		./scripts/config/conf $(KCONF_FLAGS) --defconfig=tmp/.config -w tmp/.config Config.in > /dev/null 2>&1; \
		if ./scripts/kconfig.pl '>' .config tmp/.config | grep -q CONFIG; then \
			printf "$(_R)WARNING: your configuration is out of sync. Please run make menuconfig, oldconfig or defconfig!$(_N)\n" >&2; \
		fi \
	)
	@+$(ULIMIT_FIX) $(SUBMAKE) -r $@ $(if $(WARN_PARALLEL_ERROR), || { \
		printf "$(_R)Build failed - please re-run with -j1 to see the real error message$(_N)\n" >&2; \
		false; \
	} )
```

除了少数在 toplevel 中被定义的目标外，其他编译目标都会走到这里，将之简化后 (执行命令为： make V=s)：

```Plain Text
%::
    @make V=s -r -s prereq
    @make -w -r world
```

首先执行`prereq`，然后再执行我们指定的目标或者默认目标`world`。

_prereq 整理后的依赖关系如下：
_

![](https://img-blog.csdnimg.cn/img_convert/9b9906711c0b894d7969c25fb2cb6609.png)

*其中，staging_dir/host/.prereq-build：*

将会执行一系列主机检查，是否安装了必要的软件。

prepare-tmpinfo：

根据 scan.mk，扫描`target/linux`和`package`目录，生成 packageinfo 和 targetinfo。

总之，顶层完成一系列必要的准备工作. 对于绝大多数的目标而言，顶层是必经之路。当然，在`toplevel.mk`中，我们也可以看到目标`menuconfig`。也就是说对于目标`menuconfig`而言，将不会执行到第二层的逻辑。

### 第二层

在上面执行完`make prereq`之后，将执行`make world。`
还记得我们进入顶层后修改了变量`OPENWRT_BUILD`么? 当再次执行`make world`的时候，由于条件不满足，我们将直接进入第二层来执行。

```Plain Text
  include rules.mk
  include $(INCLUDE_DIR)/depends.mk
  include $(INCLUDE_DIR)/subdir.mk
  include target/Makefile
  include package/Makefile
  include tools/Makefile
  include toolchain/Makefile
```

rules.mk：

很重要的一个 mk 文件，其中规定了很多有用的变量，包括各种目录路径的定义，交叉编译器等等。其中：

```Plain Text
ifeq ($(DUMP),)
  -include $(TOPDIR)/.config
endif
```

就是包含了我们的配置文件。对于`Makefile`而言，`.config`文件就是一大串变量的定义，Makefile 可以直接读取这些定义，从而控制编译过程。

subdir.mk：

这个是读懂我们整个编译过程的关键所在，其中主要定义了两个函数：*subdir* 和 *stampfile*，我们稍后加以解释。

接下来，包含了 4 个 Makefile 文件。我们以`target/Makefile`为例. 该文件位于`target`目录下。 
核心部分为：

```Plain Text
$(eval $(call stampfile,$(curdir),target,prereq,.config))
$(eval $(call stampfile,$(curdir),target,compile,$(TMP_DIR)/.build))
$(eval $(call stampfile,$(curdir),target,install,$(TMP_DIR)/.build))
 
$(eval $(call subdir,$(curdir)))
```

这里调用了`subdir.mk`中定义的`stampfile`函数。将会生成`target/stamp-prereq`,`target/stamp-compile`,`target/stamp-install`三个变量。
以`target/stamp-prereq`为例，执行部分为`make target/prereq`。同理`target/stamp-compile`, 执行部分为`make target/compile`。

最后又调用了`sbudir`函数，这个函数规定了目标和各子文件夹之间的依赖关系。如果有一定的 Makefile 基础可以去读读`subdir.mk`文件。
举例而言就是：

当执行目标为`target/compile`，这个目标将依赖于`target/linux/compile`。 
当执行目标为`package/compile`，这个目标将依赖于`package`目录下各子文件夹的`compile`。

下面就是规定了一系列的依赖关系，我已经将他们梳理了出来，如下图：

![](https://img-blog.csdnimg.cn/img_convert/7ecbd3c353dd239a609ac1d0d4e7a478.png)

编译过程中的一些变量可能会造成一些困扰，这里将它们的真实值记录下来，以执行 make V=s 为例：

![](https://img-blog.csdnimg.cn/img_convert/48304ba5e6f9fe08f3fa1abda7d326ab.png)

```Plain Text
1 $(PREP_MK) => OPENWRT_BUILD= QUIET=0
2 
3 $(NO_TRACE_MAKE) => make V=ss
4 
5 $(_SINGLE) => export MAKEFLAGS= ;
6 
7 $(ULIMIT_FIX) => _limit=1024; [  = unlimited -o  -ge 1024 ] || ulimit -n 1024;
```

