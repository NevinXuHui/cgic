[openwrt Makefile 框架分析 | LITREILY](https://www.litreily.top/2020/12/30/openwrt-mkfile/)

openwrt repo: [https://github.com/openwrt/openwrt](https://github.com/openwrt/openwrt)

## [#整体框架](#整体框架)整体框架

![](https://www.litreily.top/assets/openwrt/openwrt_arch.png)

- 首行为 buildroot 默认目录

  - config: 配置文件

  - include: openwrt 的 Makefile 文件

  - package: 各个软件包的 Makefile, patches 等文件

  - scripts: openwrt 包管理相关的 perl 脚本

  - target: 用于编译 kernel 和 firmware 的相关文件

  - toolchain: 包含用于获取 kernel headers, C lib, bin-utils, compiler, debugger 的指令

  - tools: 包含编译时所需的一些工具，如 automake, autoconf, sed, cmake...

- 第二行为编译后新增目录

  - bin: 存放编译后的 firmware 和 ipk 文件

  - build_dir: 编译目录，软件包解压存放路径

  - dl: 软件包下载路径

  - feeds:

  - staging_dir: 存放编译后的交叉编译工具等

  - tmp: 存放临时文件, 如 Collecting package, target info

## [#常用变量](#常用变量)常用变量

在整个 Makefile 框架里，使用到了相当多的变量，其中常用的几个变量如下表所示：

|Makefile|Variable|Value|Description|
|-|-|-|-|
|all|CURDIR|shell pwd|当前编译目录|
|all|TOPDIR|$(CURDIR)|buildroot 根目录|
|all|TMP_DIR|$(TOPDIR)/tmp|tmp 目录|
|all|MAKE|make||
|all|_SINGLE|export MAKEFLAGS=$(space);||
|all|NO_TRACE_MAKE|make V=s$(OPENWRT_VERBOSE)||
|include/image.mk|MAKE|$(_SINGLE)$(SUBMAKE)||
|include/image.mk|NO_TRACE_MAKE|$(_SINGLE)$(NO_TRACE_MAKE)||
|include/verbose.mk|SUBMAKE|make or cmd() {...} or make -w||
|include/toplevel.mk|SUBMAKE|umask 022; $(SUBMAKE)||
|include/package.mk|SUBMAKE|$(NO_TRACE_MAKE)||

## [#主Makefile](#主Makefile)主 Makefile

主 Makefile 位于 buildroot 的根目录，是执行 make 时访问的首个 Makefile.

### [#全局变量](#全局变量)全局变量

```Plain Text
TOPDIR:=${CURDIR}
LC_ALL:=C
LANG:=C
TZ:=UTC
export TOPDIR LC_ALL LANG TZ

empty:=
space:= $(empty) $(empty)
$(if $(findstring $(space),$(TOPDIR)),$(error ERROR: The path to the OpenWrt directory must not include any spaces))


```

`${CURDIR}` 是 make 指令的内嵌变量，在执行 make 指令时，获取当前 Makefile 所在目录设为其值。相当于

```Plain Text
CURDIR=$(pwd)


```

`${TOPDIR}` 就是 buildroot 根目录，export 之后在其它 Makefile 中也可以使用。

`empty` 是个空值，用于设置默认值，`space`是个空格，通常也用于设置初始值、或者判断空格。

```Plain Text
$(if $(findstring $(space),$(TOPDIR)),$(error ERROR: The path to the OpenWrt directory must not include any spaces))


```

以上语句用于判断 buildroot 根目录是否包含空格，如果包含空格将会提示错误。

### [#world-目标](#world-目标)world 目标

主 Makefile 的首个目标是 `world`, 所以执行 `make V=s` 的目标就是 `world`.

但是在主 Makefile 中，一开始并没有给出依赖文件和执行指令。

```Plain Text
world:


```

注意看主 Makefile 的逻辑.

```Plain Text
world:

DISTRO_PKG_CONFIG:=$(shell which -a pkg-config | grep -E '\/usr' | head -n 1)
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

$(toolchain/stamp-compile): $(tools/stamp-compile)
$(target/stamp-compile): $(toolchain/stamp-compile) $(tools/stamp-compile) $(BUILD_DIR)/.prepared
$(package/stamp-compile): $(target/stamp-compile) $(package/stamp-cleanup)
$(package/stamp-install): $(package/stamp-compile)
$(target/stamp-install): $(package/stamp-compile) $(package/stamp-install)
check: $(tools/stamp-check) $(toolchain/stamp-check) $(package/stamp-check)

endif


```

简化下：

```Plain Text
world:

ifneq ($(OPENWRT_BUILD),1)
  override OPENWRT_BUILD=1
  export OPENWRT_BUILD

else

endif


```

那么 world 是怎么编译完成的呢？下面详细探讨下。

### [#编译流程](#编译流程)编译流程

首次执行 make 时，进入第一条逻辑，并将第二条逻辑所需的变量 `OPENWRT_BUILD` 置为 1, 所以在执行第二个 make 时，就会进入第二条逻辑。那么问题来了。

1. 通常我们只执行一条指令 `make V=s` , 那是如何进入第二条逻辑的？

2. 第二条逻辑一定会执行到吗？

3. 第二次执行 `make` 指令一定是进入第二条逻辑吗？

ok, 针对这三个问题，首先我们要知道一点：

执行 make 指令后，可以根据 Makefile 中某些目标指令执行新的 make 指令，也就是说，**make 是可以嵌套的, Makefile 是可以重入的**

知道这个了，也就知道了 Makefile 文件是可以多次引用的，而且下一次引用可以携带之前的变量，如以上的 `OPENWRT_BUILD`。

下面来解释第一个问题，执行 `make V=s` 如何进入第二条逻辑？首先 make 后进入第一条逻辑，并引入以下 Makefile.

```Plain Text
  include $(TOPDIR)/include/debug.mk
  include $(TOPDIR)/include/depends.mk
  include $(TOPDIR)/include/toplevel.mk


```

在引入的 `toplevel.mk` 中，有对目标 `world` 重新执行 `make` 操作，就是下面的 `%::` ，这个双冒号目标就会对 `world` 目标进行重写，对于双冒号目标，如果没有依赖项，其所属指令必定会执行。

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

以上新的指令中 `$@` 对应的就是 `world`, 通过打印 log 可以验证这一点。其中的 `SUBMAKE` 需要结合 verbose.mk, toplevel.mk 推导出来。当然最简单的是使用 `make V=s -n` 打印 log。

```Plain Text
SUBMAKE=$(MAKE) -w


SUBMAKE:=umask 022; $(SUBMAKE)


```

推导出 `$(SUBMAKE)` 就是 `umask 022; make -w`, 然后根据 `%::` 指令推出详细指令为：

```Plain Text
_limit=`ulimit -n`; [ "$_limit" = "unlimited" -o "$_limit" -ge 1024 ] || ulimit -n 1024; umask 022; make -w -r world


```

执行这里的 `make` 指令时，由于之前已经将 `OPENWRT_BUILD` 设为 1 了，所以会进入上面提及的第二条逻辑。这也就解释了第一个问题，执行 `make V=s` 后，在 `toplevel.mk` 中针对目标 world 重新执行 make 指令，进入了第二条逻辑。

对于第二个问题，**第二条逻辑一定会执行到吗？** 答案是否定的，比如执行 `make oldconfig` 等指令时，在 toplevel.mk 就结束了，所以不会进入第二条逻辑。

对于第三个问题，**第二次执行 `make` 指令一定是进入第二条逻辑吗？** 答案也是否定的，某些指令同样会嵌套执行 make 指令，但是并不会进入第二条逻辑，这是怎么做到的呢？其实很简单，就是重新将 `OPENWRT_BUILD` 赋值为空就行。以上出现的变量 `PREP_MK` 就是这个作用。

```Plain Text
PREP_MK= OPENWRT_BUILD= QUIET=0


```

小结下，`make V=s` 会将 world 作为编译目标，首次访问主 Makefile 时，没有对目标设定规则，而是先设置 `OPENWRT_BUILD=1`, 然后执行某些初始化检查，最后重新执行新的 make 指令，并重入主 Makefile，根据新的 `OPENWRT_BUILD` 进入第二条逻辑。

### [#world-编译规则](#world-编译规则)world 编译规则

接下来看下第二条逻辑，这条逻辑中引入了新的 `.mk` 文件，并设置了 `world` 目标规则及其依赖项规则。

```Plain Text
  include rules.mk
  include $(INCLUDE_DIR)/depends.mk
  include $(INCLUDE_DIR)/subdir.mk
  include target/Makefile
  include package/Makefile
  include tools/Makefile
  include toolchain/Makefile

$(toolchain/stamp-compile): $(tools/stamp-compile)
$(target/stamp-compile): $(toolchain/stamp-compile) $(tools/stamp-compile) $(BUILD_DIR)/.prepared
$(package/stamp-compile): $(target/stamp-compile) $(package/stamp-cleanup)
$(package/stamp-install): $(package/stamp-compile)
$(target/stamp-install): $(package/stamp-compile) $(package/stamp-install)
check: $(tools/stamp-check) $(toolchain/stamp-check) $(package/stamp-check)



prepare: $(target/stamp-compile)



prepare: .config $(tools/stamp-compile) $(toolchain/stamp-compile)
  $(_SINGLE)$(SUBMAKE) -r buildinfo 



world: prepare $(target/stamp-compile) $(package/stamp-compile) $(package/stamp-install) $(target/stamp-install) FORCE
  $(_SINGLE)$(SUBMAKE) -r package/index
  $(_SINGLE)$(SUBMAKE) -r json_overview_image_info
  $(_SINGLE)$(SUBMAKE) -r checksum
ifneq ($(CONFIG_CCACHE),)
  $(STAGING_DIR_HOST)/bin/ccache -s
endif


```

从 `world` 的依赖中可以看到 target, package 相关的 compile, install 目标。每个依赖项都有其递归的目标编译规则和各自的依赖项，不同目标的依赖项可能会有重复。

## [#subdir](#subdir)subdir

注意到以上主 Makefile 定义了很多 `$(NAME):` 的目标，说明这些目标的实际名称需要通过具体的变量获得，以 `$(target/stamp-compile)` 为例，在主 Makefile 中声明了对应的依赖信息，

```Plain Text
$(target/stamp-compile): $(toolchain/stamp-compile) $(tools/stamp-compile) $(BUILD_DIR)/.prepared


```

而且其依赖信息也包含大量变量引用，那么这些变量的具体值在哪呢? 答案是 `include/subdir.mk` ，这个文件在定义以上目标之前就引入了，前面已有提及。而 `subdir.mk` 并不是直接定义好了每个变量名，而是通过函数 `stampfile` 动态生成，这个函数会在对应子目录中被调用。

举例说明，`$(target/stamp-compile)` 通过 `target/Makefile` 中的以下指令生成。

```Plain Text
$(eval $(call stampfile,$(curdir),target,compile,$(TMP_DIR)/.build))


```

`stampfile` 函数根据子目录名称 `target` 和目标 `compile` 生成 `target/stamp-compile` 的编译规则。

```Plain Text
define stampfile
  $(1)/stamp-$(3):=$(if $(6),$(6),$(STAGING_DIR))/stamp/.$(2)_$(3)$(5)
  $$($(1)/stamp-$(3)): $(TMP_DIR)/.build $(4)
      @+$(SCRIPT_DIR)/timestamp.pl -n $$($(1)/stamp-$(3)) $(1) $(4) || \
          $(MAKE) $(if $(QUIET),--no-print-directory) $$($(1)/flags-$(3)) $(1)/$(3)
      @mkdir -p $$$$(dirname $$($(1)/stamp-$(3)))
      @touch $$($(1)/stamp-$(3))

  $$(if $(call debug,$(1),v),,.SILENT: $$($(1)/stamp-$(3)))

  .PRECIOUS: $$($(1)/stamp-$(3)) 

  $(1)//clean:=$(1)/stamp-$(3)/clean
  $(1)/stamp-$(3)/clean: FORCE
      @rm -f $$($(1)/stamp-$(3))

endef


```

其中 `$(1)/stamp-$(3)` 对应的就是主 Makefile 声明的 `target/stamp-compile`, 而且紧随其后的就是对应该目标文件的依赖和指令。

ok, 到此就比较明了了，主 Makefile 中类似变量都是通过这种方式定义的。关于 subdir.mk 更详细的内容将在下一篇介绍。

## [#小结](#小结)小结

4. openwrt 主 Makefile 导入了许多 include 目录和其它子目录的 Makefile

5. Makefile 的指令中可以包含 make 指令以实现嵌套编译

6. 同一个 Makefile 可以多次重入，但是环境变量可能会有所改变

7. make 指令不指定目标时，其默认目标为 `world`

8. `world` 目标依赖了大量子目录对应目标，且目标名称及其依赖、指令可以通过 subdir.mk 中的 stampfile 函数动态生成

9. 编译 `world` 时，至少会调用两次主 Makefile

  10. 首次通过 toplevel.mk 检查和编译必要的工具和文件，如 scripts/config/conf, .config, tmp/* 等

  11. 第二次通过 OPENWRT_BUILD=1 编译 world 目标

12. 使用 make 指令的 `-n` 或 `-d` 参数可以更加清楚的打印编译信息，方便理解编译过程

## [#参考](#参考)参考

- [Makefile 目标类型大汇总](http://c.biancheng.net/view/7129.html)

