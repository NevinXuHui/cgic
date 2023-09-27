---
url: https://www.litreily.top/2021/01/13/mk-subdir/
title: openwrt Makefile subdir_mk 详解 _ LITREILY
date: 2023-03-28 14:08:24
tag: 
banner: "undefined"
banner_icon: 🔖
banner_x: 0.5
---
之前讲述了 openwrt Makefile 的[整体框架](https://www.litreily.top/2020/12/30/openwrt-mkfile/)，主要包括主 Makefile 的描述，，最后简单描述了 `subdir.mk` , 本文就来详细剖析这个文件。

但是在解析 `subdir.mk` 之前，先来看两个 Makefile,

*   `debug.mk`: 这也是主 Makefile 引入的第一个 .mk 文件，这里定义的调试函数在 `subdir.mk` 中被调用
*   `target/Makefile`: 这是调用到 `subdir.mk` 的首个 Makefile, 本文将以此为例进行说明

## [](#debug-mk "debug.mk")debug.mk

`debug.mk` 定义了几个调试函数。

*   `debug`
*   `warn`
*   `debug_eval`
*   `warn_eval`

```
define debug
$$(findstring $(2),$$(if $$(DEBUG_SCOPE_DIR),$$(if $$(filter $$(DEBUG_SCOPE_DIR)%,$(1)),$(build_debug)),$(build_debug)))
endef

define warn
$$(if $(call debug,$(1),$(2)),$$(warning $(3)))
endef

define debug_eval
$$(if $(call debug,$(1),$(2)),$(3))
endef

define warn_eval
$(call warn,$(1),$(2),$(3)        $(4))
$(4)
endef


```

其中：

*   `DEBUG_SCOPE_DIR`: 默认没有定义, 可以在执行 `make` 时指定
*   `build_debug`: 对应的是 `$(DEBUG)` 的值，是 "dltvr" 字符串的子集

要使这几个函数生效，需要定义变量 `DEBUG`, 可以在执行 make 时定义.

```
make DEBUG=d V=s
```agtable
tableId: 230328020947

```
u


```

默认情况下，`DEBUG` 是没有定义的，通常不需要管，之所以在这拎出来，是因为 `subdir.mk` 有调用以上提及的调试函数。

## [](#target-Makefile "target/Makefile")target/Makefile

`target/Makefile` 与 `tools`, `toolchain`, `package` 目录的 `Makefile` 使用的是相同的结构，通过调用 `subdir.mk` 内定义的两个函数 `stampfile`, `subdir` 动态生成编译目标规则。

```
curdir:=target

$(curdir)/subtargets:=install
$(curdir)/builddirs:=linux sdk imagebuilder toolchain
$(curdir)/builddirs-default:=linux
$(curdir)/builddirs-install:=linux $(if $(CONFIG_SDK),sdk) $(if $(CONFIG_IB),imagebuilder) $(if $(CONFIG_MAKE_TOOLCHAIN),toolchain)

$(curdir)/sdk/install:=$(curdir)/linux/install
$(curdir)/imagebuilder/install:=$(curdir)/linux/install

$(eval $(call stampfile,$(curdir),target,prereq,.config))
$(eval $(call stampfile,$(curdir),target,compile,$(TMP_DIR)/.build))
$(eval $(call stampfile,$(curdir),target,install,$(TMP_DIR)/.build))

$($(curdir)/stamp-install): $($(curdir)/stamp-compile) 

$(eval $(call subdir,$(curdir)))


```

其中 `curdir` 代表当前目录. 该 `Makefile` 前半部分定义了一些变量，这些变量在后续的 `stampfile`, `subdir` 函数中被调用。`target`, `package` 等目录的 `Makefile` 都是先调用 `stampfile` 生成特定目标的依赖和指令，然后再调用 `subdir` 生成各个子目录下目标的编译规则。至于具体怎么生成，继续往后看。

## [](#subdir-mk "subdir.mk")subdir.mk

接下来看本文的主角 —— `subdir.mk`, 这是编译项目过程中 **非常重要** 的文件，它可以动态定义和生成编译子目录相关目标的规则，包括 `package`, `target`, `tools`, `toolchain` 等子目录相关目标的规则。 `subdir.mk` 也是编译生成 `world` 目标必不可少的文件，主 `Makefile` 在 `include subdir.mk` 之后会 `include` 以下 `Makefile`:

*   target/Makefile
*   package/Makefile
*   tools/Makefile
*   toolchain/Makefile

这些子目录的 `Makefile` 会调用 `subdir.mk` 定义的以下两个函数：

*   subdir
*   stampfile

这两个函数是配合起来一起用的，先通过 `stampfile` 生成 `stamp-$(target)` 相关规则，然后通过 `subddir` 生成各个子目录相关目标的规则（如 `target/linux/clean`）。

### [](#stampfile "stampfile")stampfile

先来看 `stampfile`.

```
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

首行注释了 `stampfile` 的参数列表，以 `target/Makefile` 首个 `stampfile` 调用为例。

```
$(eval $(call stampfile,$(curdir),target,prereq,.config))








```

为了方便调试，可以在该行前添加一行, 将 `eval` 改成 `warning`，这样就可以在编译 log 中看到解析后的编译规则啦。

```
$(warning $(call stampfile,$(curdir),target,prereq,.config))
$(eval $(call stampfile,$(curdir),target,prereq,.config))


```

ok, 接下来清除 **所有** 编译结果，然后重新编译 `defconfig`, 编译过程就会调用 `target/Makefile` 并执行以上语句。

```
make distclean
make -d DEBUG=vltdr defconfig > log 2>&1


```

截取 log 中打印以上 `warning` 信息的部分如下：

```
target/stamp-prereq:=/home/litreily/openwrt/staging_dir/target-_/stamp/.target_prereq
$(target/stamp-prereq): /home/litreily/openwrt/tmp/.build .config
        @+/home/litreily/openwrt/scripts/timestamp.pl -n $(target/stamp-prereq) target .config || make  $(target/flags-prereq) target/prereq
        @mkdir -p $$(dirname $(target/stamp-prereq))
        @touch $(target/stamp-prereq)

$(if $(findstring v,$(if $(DEBUG_SCOPE_DIR),$(if $(filter $(DEBUG_SCOPE_DIR)%,target),vltdr),vltdr)),,.SILENT: $(target/stamp-prereq))

.PRECIOUS: $(target/stamp-prereq) # work around a make bug

target//clean:=target/stamp-prereq/clean
target/stamp-prereq/clean: FORCE
        @rm -f $(target/stamp-prereq)


```

由于默认没有 `.config` 文件，所以解析出来的 `STAGING_DIR` 为 `target-_`, 如果是 `.config` 已存在的情况下，得到的结果更完整，当然这不是我们研究的重点。

从以上解析结果可以看出，`stampfile` 会生成 4 个目标规则：

*   `$(target/stamp-prereq)` : 依赖 `tmp/.build`, `.config`
*   `.SILENT`: 是在没有定义 DEBUG 参数时才会生成的目标，其依赖就是刚定义的 `$(target/stamp-prereq)`, 可以忽略
*   `.PRECIOUS`: 根据注释像是解决某个 bug 的 workaround, 可以忽略
*   `target/stamp-prereq/clean`: 用来删除目标 `$(target/stamp-prereq)` 的伪目标

根据分析，以上结果可以进一步简化。

```
target/stamp-prereq:=/home/litreily/openwrt/staging_dir/target-_/stamp/.target_prereq
$(target/stamp-prereq): /home/litreily/openwrt/tmp/.build .config
        @+/home/litreily/openwrt/scripts/timestamp.pl -n $(target/stamp-prereq) target .config || make  $(target/flags-prereq) target/prereq
        @mkdir -p $$(dirname $(target/stamp-prereq))
        @touch $(target/stamp-prereq)

target//clean:=target/stamp-prereq/clean
target/stamp-prereq/clean: FORCE
        @rm -f $(target/stamp-prereq)


```

同理也可以分析 `target/Makefile` 中剩余两个 `stampfile` 调用。

```
$(warning $(call stampfile,$(curdir),target,compile,$(TMP_DIR)/.build))
$(eval $(call stampfile,$(curdir),target,compile,$(TMP_DIR)/.build))
$(warning $(call stampfile,$(curdir),target,install,$(TMP_DIR)/.build))
$(eval $(call stampfile,$(curdir),target,install,$(TMP_DIR)/.build))


```

同样进行简化，得到编译目标及其规则：

```
target/stamp-compile:=/home/litreily/openwrt/staging_dir/target-mips_24kc_musl/stamp/.target_compile
$(target/stamp-compile): /home/litreily/openwrt/tmp/.build /home/litreily/openwrt/tmp/.build
        @+/home/litreily/openwrt/scripts/timestamp.pl -n $(target/stamp-compile) target /home/litreily/openwrt/tmp/.build || make  $(target/flags-compile) target/compile
        @mkdir -p $$(dirname $(target/stamp-compile))
        @touch $(target/stamp-compile)

target//clean:=target/stamp-compile/clean
target/stamp-compile/clean: FORCE
        @rm -f $(target/stamp-compile)


target/stamp-install:=/home/litreily/openwrt/staging_dir/target-mips_24kc_musl/stamp/.target_install
$(target/stamp-install): /home/litreily/openwrt/tmp/.build /home/litreily/openwrt/tmp/.build
        @+/home/litreily/openwrt/scripts/timestamp.pl -n $(target/stamp-install) target /home/litreily/openwrt/tmp/.build || make  $(target/flags-install) target/install
        @mkdir -p $$(dirname $(target/stamp-install))
        @touch $(target/stamp-install)

target//clean:=target/stamp-install/clean
target/stamp-install/clean: FORCE


```

**注意：** `$(target/stamp-compile)` 和 `$(target/stamp-install)` 的依赖包含两个重复的 `tmp/.build`, 看起来像是冗余的，或许可以将 `target/Makefile` 优化下。

分析到这一步，`stampfile` 对 target 目录生成的目标已经都解析出来了，就是下面这些.

```
$(target/stamp-prereq):
target/stamp-prereq/clean:
$(target/stamp-compile):
target/stamp-compile/clean:
$(target/stamp-install):
target/stamp-install/clean:


```

这些目标在主 Makefile 是作为其它目标的依赖，也是目标 `world` 编译过程中的中间依赖目标。

**注意：** 每个 `stampfile` 除了生成目标规则都，都定义了一个 `target//clean` 变量，这个在 `subdir` 中会调用到。

ok, `stampfile` 分析完了，接下来看下 `subdir` 要完成哪些工作。

### [](#subdir "subdir")subdir

```
define subdir
  $(call warn,$(1),d,D $(1))
  $(foreach bd,$($(1)/builddirs),
    $(call warn,$(1),d,BD $(1)/$(bd))
    $(foreach target,$(SUBTARGETS) $($(1)/subtargets),
      $(foreach btype,$(buildtypes-$(bd)),
        $(call warn_eval,$(1)/$(bd),t,T,$(1)/$(bd)/$(btype)/$(target): $(if $(NO_DEPS)$(QUILT),,$($(1)/$(bd)/$(btype)/$(target)) $(call $(1)//$(btype)/$(target),$(1)/$(bd)/$(btype))))
                $(call log_make,$(1)/$(bd),$(target),$(btype),$(filter-out __default,$(variant))) \
                        || $(call ERROR,$(2),   ERROR: $(1)/$(bd) [$(btype)] failed to build.,$(findstring $(bd),$($(1)/builddirs-ignore-$(btype)-$(target))))
        $(if $(call diralias,$(bd)),$(call warn_eval,$(1)/$(bd),l,T,$(1)/$(call diralias,$(bd))/$(btype)/$(target): $(1)/$(bd)/$(btype)/$(target)))
      )
      $(call warn_eval,$(1)/$(bd),t,T,$(1)/$(bd)/$(target): $(if $(NO_DEPS)$(QUILT),,$($(1)/$(bd)/$(target)) $(call $(1)//$(target),$(1)/$(bd))))
        $(foreach variant,$(if $(BUILD_VARIANT),$(BUILD_VARIANT),$(if $(strip $($(1)/$(bd)/variants)),$($(1)/$(bd)/variants),$(if $($(1)/$(bd)/default-variant),$($(1)/$(bd)/default-variant),__default))),
                $(if $(BUILD_LOG),@mkdir -p $(BUILD_LOG_DIR)/$(1)/$(bd)/$(filter-out __default,$(variant)))
                $(if $($(1)/autoremove),$(call rebuild_check,$(1)/$(bd),$(target),,$(filter-out __default,$(variant))))
                $(call log_make,$(1)/$(bd),$(target),,$(filter-out __default,$(variant))) \
                        || $(call ERROR,$(1),   ERROR: $(1)/$(bd) failed to build$(if $(filter-out __default,$(variant)), (build variant: $(variant))).,$(findstring $(bd),$($(1)/builddirs-ignore-$(target)))) 
        )
      $(if $(PREREQ_ONLY)$(DUMP_TARGET_DB),,
        # aliases
        $(if $(call diralias,$(bd)),$(call warn_eval,$(1)/$(bd),l,T,$(1)/$(call diralias,$(bd))/$(target): $(1)/$(bd)/$(target)))
          )
        )
  )
  $(foreach target,$(SUBTARGETS) $($(1)/subtargets),$(call subtarget,$(1),$(target)))
endef


```

别看这么复杂，其中很大一部分是 debug 信息，只有在 `DEBUG` 值不为空的情况下才会打印，否则就是空值。在编译的时候加上 `DEBUG=vltdr`, 可以看到以下详细的调试信息，也能方便理解。

```
target/Makefile:23: D target
target/Makefile:23: BD target/linux
target/Makefile:23: T    target/linux/clean:  target/stamp-install/clean
target/Makefile:23: T    target/linux/download:  
target/Makefile:23: T    target/linux/prepare:  
target/Makefile:23: T    target/linux/compile:  
target/Makefile:23: T    target/linux/update:  
target/Makefile:23: T    target/linux/refresh:  
target/Makefile:23: T    target/linux/prereq:  
target/Makefile:23: T    target/linux/dist:  
target/Makefile:23: T    target/linux/distcheck:  
target/Makefile:23: T    target/linux/configure:  
target/Makefile:23: T    target/linux/check:  
target/Makefile:23: T    target/linux/check-depends:  
target/Makefile:23: T    target/linux/install:  
target/Makefile:23: BD target/sdk
target/Makefile:23: T    target/sdk/clean:  target/stamp-install/clean
target/Makefile:23: T    target/sdk/download:  
target/Makefile:23: T    target/sdk/prepare:  
target/Makefile:23: T    target/sdk/compile:  
target/Makefile:23: T    target/sdk/update:  
target/Makefile:23: T    target/sdk/refresh:  
target/Makefile:23: T    target/sdk/prereq:  
target/Makefile:23: T    target/sdk/dist:  
target/Makefile:23: T    target/sdk/distcheck:  
target/Makefile:23: T    target/sdk/configure:  
target/Makefile:23: T    target/sdk/check:  
target/Makefile:23: T    target/sdk/check-depends:  
target/Makefile:23: T    target/sdk/install: target/linux/install 
target/Makefile:23: BD target/imagebuilder
target/Makefile:23: T    target/imagebuilder/clean:  target/stamp-install/clean
target/Makefile:23: T    target/imagebuilder/download:  
target/Makefile:23: T    target/imagebuilder/prepare:  
target/Makefile:23: T    target/imagebuilder/compile:  
target/Makefile:23: T    target/imagebuilder/update:  
target/Makefile:23: T    target/imagebuilder/refresh:  
target/Makefile:23: T    target/imagebuilder/prereq:  
target/Makefile:23: T    target/imagebuilder/dist:  
target/Makefile:23: T    target/imagebuilder/distcheck:  
target/Makefile:23: T    target/imagebuilder/configure:  
target/Makefile:23: T    target/imagebuilder/check:  
target/Makefile:23: T    target/imagebuilder/check-depends:  
target/Makefile:23: T    target/imagebuilder/install: target/linux/install 
target/Makefile:23: BD target/toolchain
target/Makefile:23: T    target/toolchain/clean:  target/stamp-install/clean
target/Makefile:23: T    target/toolchain/download:  
target/Makefile:23: T    target/toolchain/prepare:  
target/Makefile:23: T    target/toolchain/compile:  
target/Makefile:23: T    target/toolchain/update:  
target/Makefile:23: T    target/toolchain/refresh:  
target/Makefile:23: T    target/toolchain/prereq:  
target/Makefile:23: T    target/toolchain/dist:  
target/Makefile:23: T    target/toolchain/distcheck:  
target/Makefile:23: T    target/toolchain/configure:  
target/Makefile:23: T    target/toolchain/check:  
target/Makefile:23: T    target/toolchain/check-depends:  
target/Makefile:23: T    target/toolchain/install:  
target/Makefile:23: T    target/clean:  target/linux/clean
target/Makefile:23: T    target/download:  target/linux/download
target/Makefile:23: T    target/prepare:  target/linux/prepare
target/Makefile:23: T    target/compile:  target/linux/compile
target/Makefile:23: T    target/update:  target/linux/update
target/Makefile:23: T    target/refresh:  target/linux/refresh
target/Makefile:23: T    target/prereq:  target/linux/prereq
target/Makefile:23: T    target/dist:  target/linux/dist
target/Makefile:23: T    target/distcheck:  target/linux/distcheck
target/Makefile:23: T    target/configure:  target/linux/configure
target/Makefile:23: T    target/check:  target/linux/check
target/Makefile:23: T    target/check-depends:  target/linux/check-depends
target/Makefile:23: T    target/install:  target/linux/install


```

其中：

*   `D` : Directory, 当前目录
*   `BD` : builddirs, 在 `target/Makefile` 中定义的 `builddirs` 变量
*   `T` : subtargets, 具体的目标

结合以上调试信息可以更容易分析 `subdir` 的执行流程，函数内部主要通过 3 层 `foreach` 循环逐层遍历以下信息：

```
$(call warn,$(1),d,D $(1))

$(foreach bd,$($(1)/builddirs),
  $(call warn,$(1),d,BD $(1)/$(bd))
  
  $(foreach target,$(SUBTARGETS) $($(1)/subtargets),
     
     $(foreach btype,$(buildtypes-$(bd)),

  $(call warn_eval,$(1)/$(bd),t,T,$(1)/$(bd)/$(target): $(if $(NO_DEPS)$(QUILT),,$($(1)/$(bd)/$(target)) $(call $(1)//$(target),$(1)/$(bd))))
        
        $(foreach variant, ...
#...
$(foreach target,$(SUBTARGETS) $($(1)/subtargets),$(call subtarget,$(1),$(target)))


```

对其中的个别变量进行说明，`$(bd)` 对应 `target` 子目录 `linux`, `sdk` 等；`$(SUBTARGETS)` 是在 `rules.mk` 中定义的。

```
SUBTARGETS:=$(DEFAULT_SUBDIR_TARGETS)


DEFAULT_SUBDIR_TARGETS:=clean download prepare compile update refresh prereq dist distcheck configure check check-depends


```

遍历 target 的语句是 `$(foreach target, $(SUBTARGETS) $(1)/subtargets)`, 就是说，除了上面的默认 targets 之外，还要加上 `$(1)/subtargets` 的值，对应 `target/Makefile` 中的值是 `install`. 这与上面展示的 log 是相对应的。

整体结构清楚了，但是还是不好分析，那么先根据以下原则对 `subdir` 进行精简：

1.  忽略调试信息 `warn`
2.  解析变量
3.  解析 `if` 条件判断，仅留下有效分支

举例说明，

1.  `subdir` 中的 `buildtypes-$(bd)` 为空，所以其对应 `foreach` 可以直接删除;
2.  `BUILD_VARIANT` 未定义，对应 `if` 判断结果为 `__default`;
3.  `$(BUILD_LOG)` 未定义，对应 `if` 分支删除。
4.  `$($(1)/autoremove)` 未定义，对应 `if` 分支删除。

根据这些规则后简化的 `subdir` 如下：

```
define subdir
  $(foreach bd,$($(1)/builddirs),
    $(foreach target,$(SUBTARGETS) $($(1)/subtargets),
      $(call warn_eval,$(1)/$(bd),t,T,$(1)/$(bd)/$(target): $(call $(1)//$(target),$(1)/$(bd)))
        $(foreach variant,__default,
                $(call log_make,$(1)/$(bd),$(target),,$(filter-out __default,$(variant))) 
        )
        
        $(if $(call diralias,$(bd)),$(call warn_eval,$(1)/$(bd),l,T,$(1)/$(call diralias,$(bd))/$(target): $(1)/$(bd)/$(target)))
    )
  )
  $(foreach target,$(SUBTARGETS) $($(1)/subtargets),$(call subtarget,$(1),$(target)))
endef


```

### [](#example "example")example

以遍历 `$(bd)` 值为 `linux` 说明以上精简后的操作。

```
      $(call warn_eval,$(1)/$(bd),t,T,$(1)/$(bd)/$(target): $(call $(1)//$(target),$(1)/$(bd)))


```

在定义了 `DEBUG=vltdr` 的情况下，以上指令会打印 target 相关信息。

```
target/Makefile:23: T    target/linux/clean:  target/stamp-install/clean
target/Makefile:23: T    target/linux/download:  
target/Makefile:23: T    target/linux/prepare:  
target/Makefile:23: T    target/linux/compile:  
target/Makefile:23: T    target/linux/update:  
target/Makefile:23: T    target/linux/refresh:  
target/Makefile:23: T    target/linux/prereq:  
target/Makefile:23: T    target/linux/dist:  
target/Makefile:23: T    target/linux/distcheck:  
target/Makefile:23: T    target/linux/configure:  
target/Makefile:23: T    target/linux/check:  
target/Makefile:23: T    target/linux/check-depends:  
target/Makefile:23: T    target/linux/install:  


```

从前面 `warn_eval` 的定义可知，它除了打印 warning 信息外，还会将最后一个参数单独执行一遍。所以它包含两个功能，`warn` 和 `eval`, 且 `eval` 更重要。它实际上也定义了一组编译目标。也就是 `warn_eval` 的第 4 个参数:

```
$(1)/$(bd)/$(target): $(call $(1)//$(target),$(1)/$(bd))


```

将变量依次替换得到：

```
target/linux/clean: $(call target//clean,target/linux)


```

*   `$(target/linux)` : 变量没有定义
*   `$(target//clean)` : 前面 `stampfile` 定义的变量，其值为 `target/stamp-install/clean`

最终解析出来如下：

```
target/linux/clean: target/stamp-install/clean


```

该目标除了依赖之外，还有对应的指令，也就是紧随其后的 `foreach` 语句。

```
        $(foreach variant,__default,
                $(call log_make,$(1)/$(bd),$(target),,$(filter-out __default,$(variant))) 
        )


```

看到这应该明了了，就是这个 `log_make` 调用，顺藤摸瓜，来看下这个函数的定义。

```
subdir_make_opts = \
        -r -C $(1) \
                BUILD_SUBDIR="$(1)" \
                BUILD_VARIANT="$(4)"





log_make = \
        $(if $(call debug,$(1),v),,@)+ \
        $(if $(BUILD_LOG), \
                set -o pipefail; \
                mkdir -p $(BUILD_LOG_DIR)/$(1)$(if $(4),/$(4));) \
      $(SCRIPT_DIR)/time.pl "time: $(1)$(if $(4),/$(4))/$(if $(3),$(3)-)$(2)" \
      $$(SUBMAKE) $(subdir_make_opts) $(if $(3),$(3)-)$(2) \
                $(if $(BUILD_LOG),SILENT= 2>&1 | tee $(BUILD_LOG_DIR)/$(1)$(if $(4),/$(4))/$(if $(3),$(3)-)$(2).txt)



```

同样，先进行简化，`DEBUG`, `BUILD_LOG` 均未定义, 对应分支可删除；已知全局变量可以替换掉。

```
log_make = \
        @+ \
        scripts/time.pl "time: $(1)$(if $(4),/$(4))/$(if $(3),$(3)-)$(2)" \
        $$(SUBMAKE) -r -C $(1) BUILD_SUBDIR="$(1)" BUILD_VARIANT="$(4)" \
        $(if $(3),$(3)-)$(2)


```

接着回到 `subdir` 中的 `log_make` 的调用处：

```
$(call log_make,$(1)/$(bd),$(target),,$(filter-out __default,$(variant))) 


```

按照简化后的 `log_make` 代入参数解析以上指令。

```
+ scripts/time.pl "time: target/linux/clean" make -w -r -C target/linux BUILD_SUBDIR="target/linux" BUILD_VARIANT="" clean


```

将目标、依赖及其指令组合起来就是这样的：

```
target/linux/clean: target/stamp-install/clean
        + scripts/time.pl "time: target/linux/clean" make -w -r -C target/linux BUILD_SUBDIR="target/linux" BUILD_VARIANT="" clean


```

看看这个目标定义，依赖项 `target/stamp-install/clean` 的规则在 `stampfile` 中定义好了；其指令是通过 perl 脚本 `time.pl` 执行 `make` 指令并记录时间信息。

到此就完成了对 `subdir` 遍历 `subtargets` 之一 `target/linux/clean` 的解析，其它 `target` 也是类似的。

```
target/linux/clean: target/stamp-install/clean
        + scripts/time.pl "time: target/linux/clean" make -w -r -C target/linux BUILD_SUBDIR="target/linux" BUILD_VARIANT="" clean
target/linux/download: 
        + scripts/time.pl "time: target/linux/download" make -w -r -C target/linux BUILD_SUBDIR="target/linux" BUILD_VARIANT="" download
target/linux/prepare: 
        + scripts/time.pl "time: target/linux/download" make -w -r -C target/linux BUILD_SUBDIR="target/linux" BUILD_VARIANT="" prepare

target/linux/install: 
        + scripts/time.pl "time: target/linux/install" make -w -r -C target/linux BUILD_SUBDIR="target/linux" BUILD_VARIANT="" install


target/sdk/clean: target/stamp-install/clean
        + scripts/time.pl "time: target/sdk/clean" make -w -r -C target/sdk BUILD_SUBDIR="target/sdk" BUILD_VARIANT="" clean
target/sdk/download: 
        + scripts/time.pl "time: target/sdk/download" make -w -r -C target/sdk BUILD_SUBDIR="target/sdk" BUILD_VARIANT="" download

target/sdk/install: 
        + scripts/time.pl "time: target/sdk/install" make -w -r -C target/sdk BUILD_SUBDIR="target/sdk" BUILD_VARIANT="" install


target/imagebuilder/clean: target/stamp-install/clean
        + scripts/time.pl "time: target/imagebuilder/clean" make -w -r -C target/imagebuilder BUILD_SUBDIR="target/imagebuilder" BUILD_VARIANT="" clean
target/imagebuilder/download: 
        + scripts/time.pl "time: target/imagebuilder/download" make -w -r -C target/imagebuilder BUILD_SUBDIR="target/imagebuilder" BUILD_VARIANT="" download

target/imagebuilder/install: 
        + scripts/time.pl "time: target/imagebuilder/install" make -w -r -C target/imagebuilder BUILD_SUBDIR="target/imagebuilder" BUILD_VARIANT="" install


target/toolchain/clean: target/stamp-install/clean
        + scripts/time.pl "time: target/toolchain/clean" make -w -r -C target/toolchain BUILD_SUBDIR="target/toolchain" BUILD_VARIANT="" clean
target/toolchain/download: 
        + scripts/time.pl "time: target/toolchain/download" make -w -r -C target/toolchain BUILD_SUBDIR="target/toolchain" BUILD_VARIANT="" download

target/toolchain/install: 
        + scripts/time.pl "time: target/toolchain/install" make -w -r -C target/toolchain BUILD_SUBDIR="target/toolchain" BUILD_VARIANT="" install


```

### [](#in-the-end "in the end")in the end

最后，还有一个小尾巴没讲到。注意看前面给出 log 的最后一部分。

```
target/Makefile:23: T    target/clean:  target/linux/clean
target/Makefile:23: T    target/download:  target/linux/download
target/Makefile:23: T    target/prepare:  target/linux/prepare
target/Makefile:23: T    target/compile:  target/linux/compile
target/Makefile:23: T    target/update:  target/linux/update
target/Makefile:23: T    target/refresh:  target/linux/refresh
target/Makefile:23: T    target/prereq:  target/linux/prereq
target/Makefile:23: T    target/dist:  target/linux/dist
target/Makefile:23: T    target/distcheck:  target/linux/distcheck
target/Makefile:23: T    target/configure:  target/linux/configure
target/Makefile:23: T    target/check:  target/linux/check
target/Makefile:23: T    target/check-depends:  target/linux/check-depends
target/Makefile:23: T    target/install:  target/linux/install


```

这里打印的信息是哪里来的呢？其实也是 `subdir` 函数，是该函数最后一个 `foreach` 循环遍历出来的。

```
  $(foreach target,$(SUBTARGETS) $($(1)/subtargets),$(call subtarget,$(1),$(target)))


```

经过前面的推导，这部分简直是小 case, 无非是遍历所有 `target`, 然后使用函数 `subtarget` 去生成规则。

```
subtarget-default = $(filter-out ., \
        $(if $($(1)/builddirs-$(2)),$($(1)/builddirs-$(2)), \
        $(if $($(1)/builddirs-default),$($(1)/builddirs-default), \
        $($(1)/builddirs))))

define subtarget
  $(call warn_eval,$(1),t,T,$(1)/$(2): $($(1)/) $(foreach bd,$(call subtarget-default,$(1),$(2)),$(1)/$(bd)/$(2)))
endef


```

同样对其进行简化。

```
subtarget-default = $(filter-out ., $(if $($(1)/builddirs-$(2)),$($(1)/builddirs-$(2)), linux))

define subtarget
  $(1)/$(2): $($(1)/) $(foreach bd,$(call subtarget-default,$(1),$(2)),$(1)/$(bd)/$(2))
endef


```

然后代入参数 `$(1): target`, `$(2): clean`, 得到：

```
subtarget-default = linux

define subtarget
  target/clean: target/linux/clean
endef


```

这与 log 中的一致，其它 `target` 的规则也是类似，这里最主要的就是一个默认编译规则，相当于在不指定具体 `target` 哪个子目录时，根据默认值进行编译，`target/Makefile` 定义的 `$(builddirs-default)` 就是 `linux`, 也就是说，执行 `make target/clean` 与 `make target/linux/clean` 是一样的。

除 `target` 目录外，`package`, `tools`, `toolchain` 目录也是类似的。

到这，最后的小尾巴也讲完啦。

## [](#Tips "Tips")Tips

使用 makefile 的 `warning` 函数打印信息可以快速梳理 Makefile 的执行流程。

```
$(warning info)



$(warning $(call subdir,$(curdir)))


```

配合 `make -n V=s` 能够打印指令信息, 如果加上 `DEBUG` 可以显示更加详细的调试信息。

```
make -d V=s DEBUG=dltvr

make -d -n V=s DEBUG=dltvr


```

## [](#Reference "Reference")Reference

*   [OpenWRT 编译系统分析之 subdir 函数的用法](https://www.atfeng.com/post/2016/openwrt%E7%BC%96%E8%AF%91%E7%B3%BB%E7%BB%9F%E5%88%86%E6%9E%90%E4%B9%8Bsubdir%E5%87%BD%E6%95%B0%E7%9A%84%E7%94%A8%E6%B3%95/)