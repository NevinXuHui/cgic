---
url: https://www.litreily.top/2021/01/15/mk-scan/
title: openwrt Makefile scan_mk 详解 _ LITREILY
date: 2023-03-28 14:07:52
tag: 
banner: "undefined"
banner_icon: 🔖
---
`openwrt` 中的 `include/scan.mk` 用于扫描项目 `package`, `target` 目录信息，并将扫描结果存入 `tmp` 目录。这个扫描过程几乎是 openwrt 所有目标生成的前提。也就是说，无论使用 `make` 编译 `openwrt` 哪个部分的代码，都会通过 `scan.mk` 生成必要的临时文件，这是编译其它目录的大前提。

举例说明，我们指定编译某个 `package` 时，如 `package/utils/demo`，`make` 根据层层 `Makefile` 会去寻找该 `package` 的路径，而这个路径信息就是通过 `scan.mk` 扫描后存入了 `tmp` 目录。这样有什么好处呢? 我完全可以手动执行 `make package/utils/demo/compile` 不是吗？

的确如此，但是我们不可能每次都去写长串的路径，通过 `tmp` 目录的信息，不管 `package` 对应目录在哪， `package/demo` 也好， `package/utils/demo` 也罢， `package/utils/test/demo` 也无所谓，我们都可以执行 `make package/demo/compile` 进行编译，`make` 会根据 `tmp` 目录里保存的映射关系自动查找到对应目录，非常方便。

`openwrt` 的 `Makefile` 体系非常庞大，通过首次生成 `package`、`target` 信息到 `tmp` 目录，可以简化编译流程，节省编译时间。这篇文章就来详细讲述一下 `scan.mk` 的扫描过程。

## [](#prepare-tmpinfo "prepare-tmpinfo")prepare-tmpinfo

在讲述 `scan.mk` 之前，我们需要知道 `scan.mk` 在哪里被调用到，答案是 `toplevel.mk` 的 `prepare-tmpinfo` 目标，这个目标几乎是 `toplevel.mk` 中其它目标都会包含的依赖项。`defconfig`, `oldconfig`, `menuconfig`, `prereq`, `config` 等都会依赖它。

顾名思义，`prepare-tmpinfo` 就是用来准备 `tmp` 信息的，它没有依赖项，`FORCE` 代表强制执行其指令。在它的指令中就会调用到 `scan.mk` 了。

```
prepare-tmpinfo: FORCE
    @+$(MAKE) -r -s staging_dir/host/.prereq-build $(PREP_MK)
    mkdir -p tmp/info
    $(_SINGLE)$(NO_TRACE_MAKE) -j1 -r -s -f include/scan.mk SCAN_TARGET="packageinfo" SCAN_DIR="package" SCAN_NAME="package" SCAN_DEPTH=5 SCAN_EXTRA=""
    $(_SINGLE)$(NO_TRACE_MAKE) -j1 -r -s -f include/scan.mk SCAN_TARGET="targetinfo" SCAN_DIR="target/linux" SCAN_NAME="target" SCAN_DEPTH=2 SCAN_EXTRA="" SCAN_MAKEOPTS="TARGET_BUILD=1"
    for type in package target; do \
        f=tmp/.$${type}info; t=tmp/.config-$${type}.in; \
        [ "$$t" -nt "$$f" ] || ./scripts/$${type}-metadata.pl $(_ignore) config "$$f" > "$$t" || { rm -f "$$t"; echo "Failed to build $$t"; false; break; }; \
    done
    [ tmp/.config-feeds.in -nt tmp/.packageauxvars ] || ./scripts/feeds feed_config > tmp/.config-feeds.in
    ./scripts/package-metadata.pl mk tmp/.packageinfo > tmp/.packagedeps || { rm -f tmp/.packagedeps; false; }
    ./scripts/package-metadata.pl pkgaux tmp/.packageinfo > tmp/.packageauxvars || { rm -f tmp/.packageauxvars; false; }
    ./scripts/package-metadata.pl usergroup tmp/.packageinfo > tmp/.packageusergroup || { rm -f tmp/.packageusergroup; false; }
    touch $(TOPDIR)/tmp/.build


```

其中有两行调用了 `scan.mk`.

```
    $(_SINGLE)$(NO_TRACE_MAKE) -j1 -r -s -f include/scan.mk SCAN_TARGET="packageinfo" SCAN_DIR="package" SCAN_NAME="package" SCAN_DEPTH=5 SCAN_EXTRA=""
    $(_SINGLE)$(NO_TRACE_MAKE) -j1 -r -s -f include/scan.mk SCAN_TARGET="targetinfo" SCAN_DIR="target/linux" SCAN_NAME="target" SCAN_DEPTH=2 SCAN_EXTRA="" SCAN_MAKEOPTS="TARGET_BUILD=1"


```

通过分析主 Makefile 和 include/verbose.mk 可以知道 `$(_SINGLE)$(NO_TRACE_MAKE)` 对应的是：

```
export MAKEFLAGS= ;make V=ss


```

那么以上指令解析后就是：

```
export MAKEFLAGS= ;make V=ss -j1 -r -s -f include/scan.mk SCAN_TARGET="packageinfo" SCAN_DIR="package" SCAN_NAME="package" SCAN_DEPTH=5 SCAN_EXTRA=""
export MAKEFLAGS= ;make V=ss -j1 -r -s -f include/scan.mk SCAN_TARGET="targetinfo" SCAN_DIR="target/linux" SCAN_NAME="target" SCAN_DEPTH=2 SCAN_EXTRA="" SCAN_MAKEOPTS="TARGET_BUILD=1"


```

**说明：** make 的 `-s` 指令代表 silent， 会将所有输出都屏蔽掉，我们在分析的时候可以把 `-s` 去掉，并换成 `-d` ，这样可以看到更详细的 log.

好啦，现在知道 scan.mk 的入口啦，就是 `prepare-tmpinfo` 的指令之一。那么我们怎么触发这两条指令呢？很简单，因为只要执行 make 就会调用这个依赖，我们可以通过 `make defconfig` 触发，为了获取更详细的信息，可以使用以下指令：

```
make -d V=s DEBUG=dtlrv defconfig > log 2>&1
```

这样就将编译信息保存到文件 log 中了，方便分析执行过程。[make defconfig](https://www.litreily.top/2020/12/29/make-defconfig/) 的主要流程在之前已有文章单独讲述过，不再赘述，本文主要来分析

```
make V=ss -j1 -r -s -f include/scan.mk SCAN_TARGET="packageinfo" SCAN_DIR="package" SCAN_NAME="package" SCAN_DEPTH=5 SCAN_EXTRA=""
```

这条指令的执行过程，以深入理解 openwrt scan.mk 的扫描过程。

当然，我们也可以直接调用以上指令，而不用 `make defconfig`, 只不过需要添加两个全局变量  
-- `SCAN_COOKIE="123456"`  
-- `TOPDIR="/home/litreily/openwrt"`

```
make V=ss -j1 -r -d -f include/scan.mk SCAN_TARGET="packageinfo" SCAN_DIR="package" SCAN_NAME="package" SCAN_DEPTH=5 SCAN_EXTRA="" SCAN_COOKIE="123456" TOPDIR="/home/litreily/openwrt"
```

`scan.mk` 编译过程与使用 `make defconfig` 是类似的。

## [](#scan-mk "scan.mk")scan.mk

进入正题，先附上完整的 [scan.mk](https://github.com/openwrt/openwrt/blob/master/include/scan.mk) , 源自 GitHub openwrt.

```
include $(TOPDIR)/include/verbose.mk
TMP_DIR:=$(TOPDIR)/tmp

all: $(TMP_DIR)/.$(SCAN_TARGET)

SCAN_TARGET ?= packageinfo
SCAN_NAME ?= package
SCAN_DIR ?= package
TARGET_STAMP:=$(TMP_DIR)/info/.files-$(SCAN_TARGET).stamp
FILELIST:=$(TMP_DIR)/info/.files-$(SCAN_TARGET)-$(SCAN_COOKIE)
OVERRIDELIST:=$(TMP_DIR)/info/.overrides-$(SCAN_TARGET)-$(SCAN_COOKIE)

export PATH:=$(TOPDIR)/staging_dir/host/bin:$(PATH)

define feedname
$(if $(patsubst feeds/%,,$(1)),,$(word 2,$(subst /, ,$(1))))
endef

ifeq ($(SCAN_NAME),target)
  SCAN_DEPS=image/Makefile profiles/*.mk $(TOPDIR)/include/kernel*.mk $(TOPDIR)/include/target.mk image/*.mk
else
  SCAN_DEPS=$(TOPDIR)/include/package*.mk
ifneq ($(call feedname,$(SCAN_DIR)),)
  SCAN_DEPS += $(TOPDIR)/feeds/$(call feedname,$(SCAN_DIR))/*.mk
endif
endif

ifeq ($(IS_TTY),1)
  ifneq ($(strip $(NO_COLOR)),1)
    define progress
        printf "\033[M\r$(1)" >&2;
    endef
  else
    define progress
        printf "\r$(1)" >&2;
    endef
  endif
else
  define progress
        :;
  endef
endif

define PackageDir
  $(TMP_DIR)/.$(SCAN_TARGET): $(TMP_DIR)/info/.$(SCAN_TARGET)-$(1)
  $(TMP_DIR)/info/.$(SCAN_TARGET)-$(1): $(SCAN_DIR)/$(2)/Makefile $(foreach DEP,$(DEPS_$(SCAN_DIR)/$(2)/Makefile) $(SCAN_DEPS),$(wildcard $(if $(filter /%,$(DEP)),$(DEP),$(SCAN_DIR)/$(2)/$(DEP))))
        { \
                $$(call progress,Collecting $(SCAN_NAME) info: $(SCAN_DIR)/$(2)) \
                echo Source-Makefile: $(SCAN_DIR)/$(2)/Makefile; \
                $(if $(3),echo Override: $(3),true); \
                $(NO_TRACE_MAKE) --no-print-dir -r DUMP=1 FEED="$(call feedname,$(2))" -C $(SCAN_DIR)/$(2) $(SCAN_MAKEOPTS) 2>/dev/null || { \
                        mkdir -p "$(TOPDIR)/logs/$(SCAN_DIR)/$(2)"; \
                        $(NO_TRACE_MAKE) --no-print-dir -r DUMP=1 FEED="$(call feedname,$(2))" -C $(SCAN_DIR)/$(2) $(SCAN_MAKEOPTS) > $(TOPDIR)/logs/$(SCAN_DIR)/$(2)/dump.txt 2>&1; \
                        $$(call progress,ERROR: please fix $(SCAN_DIR)/$(2)/Makefile - see logs/$(SCAN_DIR)/$(2)/dump.txt for details\n) \
                        rm -f $$@; \
                }; \
                echo; \
        } > $$@.tmp
        mv $$@.tmp $$@
endef

$(OVERRIDELIST):
        rm -f $(TMP_DIR)/info/.overrides-$(SCAN_TARGET)-*
        touch $@

ifeq ($(SCAN_NAME),target)
  GREP_STRING=BuildTarget
else
  GREP_STRING=(Build/DefaultTargets|BuildPackage|KernelPackage)
endif

$(FILELIST): $(OVERRIDELIST)
        rm -f $(TMP_DIR)/info/.files-$(SCAN_TARGET)-*
        find -L $(SCAN_DIR) $(SCAN_EXTRA) -mindepth 1 $(if $(SCAN_DEPTH),-maxdepth $(SCAN_DEPTH)) -name Makefile | xargs grep -aHE 'call $(GREP_STRING)' | sed -e 's#^$(SCAN_DIR)/##' -e 's#/Makefile:.*##' | uniq | awk -v of=$(OVERRIDELIST) -f include/scan.awk > $@

$(TMP_DIR)/info/.files-$(SCAN_TARGET).mk: $(FILELIST)
        ( \
                cat $< | awk '{print "$(SCAN_DIR)/" $$0 "/Makefile" }' | xargs grep -HE '^ *SCAN_DEPS *= *' | awk -F: '{ gsub(/^.*DEPS *= */, "", $$2); print "DEPS_" $$1 "=" $$2 }'; \
                awk -F/ -v deps="$$DEPS" -v of="$(OVERRIDELIST)" ' \
                BEGIN { \
                        while (getline < (of)) \
                                override[$$NF]=$$0; \
                        close(of) \
                } \
                { \
                        info=$$0; \
                        gsub(/\//, "_", info); \
                        dir=$$0; \
                        pkg=""; \
                        if($$NF in override) \
                                pkg=override[$$NF]; \
                        print "$$(eval $$(call PackageDir," info "," dir "," pkg "))"; \
                } ' < $<; \
                true; \
        ) > $@.tmp
        mv $@.tmp $@

-include $(TMP_DIR)/info/.files-$(SCAN_TARGET).mk

$(TARGET_STAMP)::
        +( \
                $(NO_TRACE_MAKE) $(FILELIST); \
                MD5SUM=$$(cat $(FILELIST) $(OVERRIDELIST) | mkhash md5 | awk '{print $$1}'); \
                [ -f "$@.$$MD5SUM" ] || { \
                        rm -f $@.*; \
                        touch $@.$$MD5SUM; \
                        touch $@; \
                } \
        )

$(TMP_DIR)/.$(SCAN_TARGET): $(TARGET_STAMP)
        $(call progress,Collecting $(SCAN_NAME) info: merging...)
        -cat $(FILELIST) | awk '{gsub(/\//, "_", $$0);print "$(TMP_DIR)/info/.$(SCAN_TARGET)-" $$0}' | xargs cat > $@ 2>/dev/null
        $(call progress,Collecting $(SCAN_NAME) info: done)
        echo

FORCE:
.PHONY: FORCE
.NOTPARALLEL:


```

### [](#global-value "global value")global value

在分析全局变量之前，先来看下默认目标 `all`.

```
all: $(TMP_DIR)/.$(SCAN_TARGET)


```

`$(TMP_DIR)` 对应根目录下的 tmp 目录，`SCAN_TARGET` 在调用 make 的时候有定义，此处为 `packageinfo`, 因此 `all` 为：

```
all: /home/litreily/openwrt/tmp/.packageinfo


```

也就是说，扫描的目标文件是 tmp 目录的 `.packageinfo`. 但是在生成该目标之前，`make` 会先 `include` 其它文件，如果 `include` 的文件不存在，则会先生成该文件，此处具体指代的是后续讲述的 `.files-packageinfo.mk`.

ok, 编译目标知道了，再来看看全局变量有哪些。

```
TMP_DIR:=$(TOPDIR)/tmp

all: $(TMP_DIR)/.$(SCAN_TARGET)

SCAN_TARGET ?= packageinfo
SCAN_NAME ?= package
SCAN_DIR ?= package
TARGET_STAMP:=$(TMP_DIR)/info/.files-$(SCAN_TARGET).stamp
FILELIST:=$(TMP_DIR)/info/.files-$(SCAN_TARGET)-$(SCAN_COOKIE)
OVERRIDELIST:=$(TMP_DIR)/info/.overrides-$(SCAN_TARGET)-$(SCAN_COOKIE)


```

其中 `SCAN_COOKIE` 是在 `toplevel.mk` 通过 `$(shell echo $$$$)` 得到的一个随机数，这里为 `2109133`. 其它变量可以根据传入的参数解析出来：

```
TMP_DIR:=/home/litreily/openwrt/tmp

all: /home/litreily/openwrt/tmp/.packageinfo

SCAN_TARGET ?= packageinfo
SCAN_NAME ?= package
SCAN_DIR ?= package
TARGET_STAMP:=/home/litreily/openwrt/tmp/info/.files-packageinfo.stamp
FILELIST:=/home/litreily/openwrt/tmp/info/.files-packageinfo-2109133
OVERRIDELIST:=/home/litreily/openwrt/tmp/info/.overrides-packageinfo-2109133


```

其中，后面三个变量定义的是一些中间目标文件，是生成 `all` 目标必不可少的中间依赖文件。

### [](#files-packageinfo-mk ".files-packageinfo.mk").files-packageinfo.mk

ok, 全局变量及目标已经确定了，那么 make 执行过程究竟是怎样的呢，在启用调试信息的情况下，可以通过 log 很清晰的看到执行流程。

1.  include `include/verbose.mk`
2.  include `tmp/info/.files-packageinfo.mk`

在读取 `verbose.mk` 后，会根据 `scan.mk` 执行剩下的 `include` 指令

```
-include $(TMP_DIR)/info/.files-$(SCAN_TARGET).mk


```

导入 `tmp/info/.file-packageinfo.mk` 文件，该文件默认不存在，所以前面有个 `-` 符号以确保文件不存在时能够正常执行。

下一步就是将该文件作为目标文件，查找其依赖。

```
$(TMP_DIR)/info/.files-$(SCAN_TARGET).mk: $(FILELIST)
        ( \
                cat $< | awk '{print "$(SCAN_DIR)/" $$0 "/Makefile" }' | xargs grep -HE '^ *SCAN_DEPS *= *' | awk -F: '{ gsub(/^.*DEPS *= */, "", $$2); print "DEPS_" $$1 "=" $$2 }'; \
                awk -F/ -v deps="$$DEPS" -v of="$(OVERRIDELIST)" ' \
                BEGIN { \
                        while (getline < (of)) \
                                override[$$NF]=$$0; \
                        close(of) \
                } \
                { \
                        info=$$0; \
                        gsub(/\//, "_", info); \
                        dir=$$0; \
                        pkg=""; \
                        if($$NF in override) \
                                pkg=override[$$NF]; \
                        print "$$(eval $$(call PackageDir," info "," dir "," pkg "))"; \
                } ' < $<; \
                true; \
        ) > $@.tmp
        mv $@.tmp $@


```

其依赖是 `$(FILELIST)`, 也就是 `tmp/info/.files-packageinfo-2109133`. 那么接着来看 `$(FILELIST)` 的依赖及其指令。

```
$(FILELIST): $(OVERRIDELIST)
        rm -f $(TMP_DIR)/info/.files-$(SCAN_TARGET)-*
        find -L $(SCAN_DIR) $(SCAN_EXTRA) -mindepth 1 $(if $(SCAN_DEPTH),-maxdepth $(SCAN_DEPTH)) -name Makefile | xargs grep -aHE 'call $(GREP_STRING)' | sed -e 's#^$(SCAN_DIR)/##' -e 's#/Makefile:.*##' | uniq | awk -v of=$(OVERRIDELIST) -f include/scan.awk > $@


```

可知其依赖文件是 `$(OVERRIDELIST)`, 也就是 `/home/litreily/openwrt/tmp/info/.overrides-packageinfo-2109133`. 而 `$(OVERRIDELIST)` 规则如下：

```
$(OVERRIDELIST):
        rm -f $(TMP_DIR)/info/.overrides-$(SCAN_TARGET)-*
        touch $@


```

该规则很简单，也就是删除旧的 `tmp/info/.overrides-packageinfo-*` 文件，并 touch 新的文件 `tmp/info/.overrides-packageinfo-2109133`.

那么执行完以上两条指令后，解析 `$(FILELIST)` 后的格式为：

```
/home/litreily/openwrt/tmp/info/.files-packageinfo-2109133: /home/litreily/openwrt/tmp/info/.overrides-packageinfo-2109133
        rm -f /home/litreily/openwrt/tmp/info/.files-packageinfo-*
        find -L package  -mindepth 1 -maxdepth 5 -name Makefile | xargs grep -aHE 'call (Build/DefaultTargets|BuildPackage|KernelPackage)' | sed -e 's#^package/##' -e 's#/Makefile:.*##' | uniq | awk -v of=/home/litreily/openwrt/tmp/info/.overrides-packageinfo-2109133 -f include/scan.awk > /home/litreily/openwrt/tmp/info/.files-packageinfo-2109133


```

与 `$(OVERRIDELIST)` 类似，先把旧的 `tmp/info/.files-packageinfo-*` 删除，然后生成新的 `tmp/info/.files-packageinfo-2109133`. 生成文件用的就是上面的 `find` 指令了，该指令会查找 package 下 `1~5` 级目录内的所有 Makefile 文件

```
find -L package -mindepth 1 -maxdepth 5 -name Makefile


```

然后根据关键词正则过滤包含 `call (Build/DefaultTargets|BuildPackage|KernelPackage)` 信息的 Makefile, 并通过 uniq 去掉重复项，使用 awk 指令结合 awk 脚本 `scan.awk` 过滤 `feeds` 相关的 `Makefile`, 最终将过滤后的 packageinfo 存入 `tmp/info/.files-packageinfo-2109133`。

```
base-files
boot/arm-trusted-firmware-mvebu
boot/arm-trusted-firmware-rockchip
boot/arm-trusted-firmware-sunxi
boot/at91bootstrap
boot/fconfig

utils/ugps 
utils/usbmode
utils/util-linux


```

至此，`$(FILELIST)` 编译完成，依赖它的目标 `tmp/info/.file-packageinfo.mk` 可以继续执行对应的指令。把所有变量替换为具体的值，可以得到以下规则。

```
/home/litreily/openwrt/tmp/info/.file-packageinfo.mk: /home/litreily/openwrt/tmp/info/.files-packageinfo-2109133
        ( \
                cat /home/litreily/openwrt/tmp/info/.files-packageinfo-2109133 | awk '{print "package/" $0 "/Makefile" }' | xargs grep -HE '^ *SCAN_DEPS *= *' | awk -F: '{ gsub(/^.*DEPS *= */, "", $2); print "DEPS_" $1 "=" $2 }'; \
                awk -F/ -v deps="$DEPS" -v of="/home/litreily/openwrt/tmp/info/.overrides-packageinfo-2109133" ' \
                BEGIN { \
                        while (getline < (of)) \
                                override[$NF]=$0; \
                        close(of) \
                } \
                { \
                        info=$0; \
                        gsub(/\//, "_", info); \
                        dir=$0; \
                        pkg=""; \
                        if($NF in override) \
                                pkg=override[$NF]; \
                        print "$(eval $(call PackageDir," info "," dir "," pkg "))"; \
                } ' < /home/litreily/openwrt/tmp/info/.files-packageinfo-2109133; \
                true; \
        ) > /home/litreily/openwrt/tmp/info/.file-packageinfo.mk.tmp
        mv /home/litreily/openwrt/tmp/info/.file-packageinfo.mk.tmp /home/litreily/openwrt/tmp/info/.file-packageinfo.mk


```

以上一堆操作的目的都是为了根据前面生成的 `$(FILELIST)` 去生成 `tmp/info/.file-packageinfo.mk`.

```
cat /home/litreily/openwrt/tmp/info/.files-packageinfo-2109133 | awk '{print "package/" $0 "/Makefile" }' | xargs grep -HE '^ *SCAN_DEPS *= *' | awk -F: '{ gsub(/^.*DEPS *= */, "", $2); print "DEPS_" $1 "=" $2 }';


```

这一段脚本生成了 `tmp/info/.file-packageinfo.mk` 的前几行信息。

```
DEPS_package/firmware/linux-firmware/Makefile=*.mk
DEPS_package/kernel/linux/Makefile=modules/*.mk $(TOPDIR)/target/linux/*/modules.mk $(TOPDIR)/include/netfilter.mk


```

```
{ \
        info=$0; \
        gsub(/\//, "_", info); \
        dir=$0; \
        pkg=""; \
        if($NF in override) \
                pkg=override[$NF]; \
        print "$(eval $(call PackageDir," info "," dir "," pkg "))"; \
} ' < /home/litreily/openwrt/tmp/info/.files-packageinfo-2109133; 


```

以上这段脚本则是根据 package 列表生成 `PackageDir` 信息列表，以 `boot/fconfig` 为例。经过以上 awk 变换后变为：

```
$(eval $(call PackageDir,boot_fconfig,boot/fconfig,))


```

最终生成的完成的 `tmp/info/.files-packageinfo.mk` 如下：

```
DEPS_package/firmware/linux-firmware/Makefile=*.mk
DEPS_package/kernel/linux/Makefile=modules/*.mk $(TOPDIR)/target/linux/*/modules.mk $(TOPDIR)/include/netfilter.mk
$(eval $(call PackageDir,base-files,base-files,))
$(eval $(call PackageDir,boot_arm-trusted-firmware-mvebu,boot/arm-trusted-firmware-mvebu,))
$(eval $(call PackageDir,boot_arm-trusted-firmware-rockchip,boot/arm-trusted-firmware-rockchip,))
$(eval $(call PackageDir,boot_arm-trusted-firmware-sunxi,boot/arm-trusted-firmware-sunxi,))
$(eval $(call PackageDir,boot_at91bootstrap,boot/at91bootstrap,))
$(eval $(call PackageDir,boot_fconfig,boot/fconfig,))

$(eval $(call PackageDir,utils_ugps,utils/ugps,))
$(eval $(call PackageDir,utils_usbmode,utils/usbmode,))
$(eval $(call PackageDir,utils_util-linux,utils/util-linux,))


```

到此，`include $(TMP_DIR)/info/.files-$(SCAN_TARGET).mk` 就完成了. 该文件中每一项都调用了函数 `PackageDir`. 该函数是在 `scan.mk` 中定义的。

### [](#PackageDir "PackageDir")PackageDir

`PackageDir` 是 scan.mk 文件中的核心函数之一，用来生成 package, target 相关的编译规则。

```
define PackageDir
  $(TMP_DIR)/.$(SCAN_TARGET): $(TMP_DIR)/info/.$(SCAN_TARGET)-$(1)
  $(TMP_DIR)/info/.$(SCAN_TARGET)-$(1): $(SCAN_DIR)/$(2)/Makefile $(foreach DEP,$(DEPS_$(SCAN_DIR)/$(2)/Makefile) $(SCAN_DEPS),$(wildcard $(if $(filter /%,$(DEP)),$(DEP),$(SCAN_DIR)/$(2)/$(DEP))))
        { \
                $$(call progress,Collecting $(SCAN_NAME) info: $(SCAN_DIR)/$(2)) \
                echo Source-Makefile: $(SCAN_DIR)/$(2)/Makefile; \
                $(if $(3),echo Override: $(3),true); \
                $(NO_TRACE_MAKE) --no-print-dir -r DUMP=1 FEED="$(call feedname,$(2))" -C $(SCAN_DIR)/$(2) $(SCAN_MAKEOPTS) 2>/dev/null || { \
                        mkdir -p "$(TOPDIR)/logs/$(SCAN_DIR)/$(2)"; \
                        $(NO_TRACE_MAKE) --no-print-dir -r DUMP=1 FEED="$(call feedname,$(2))" -C $(SCAN_DIR)/$(2) $(SCAN_MAKEOPTS) > $(TOPDIR)/logs/$(SCAN_DIR)/$(2)/dump.txt 2>&1; \
                        $$(call progress,ERROR: please fix $(SCAN_DIR)/$(2)/Makefile - see logs/$(SCAN_DIR)/$(2)/dump.txt for details\n) \
                        rm -f $$@; \
                }; \
                echo; \
        } > $$@.tmp
        mv $$@.tmp $$@
endef


```

举例说明，下面的语句中 `$(1)` 和 `$(2)` 都是 `base-files`, `$(3)` 为空。

```
$(eval $(call PackageDir,base-files,base-files,))


```

将变量替换后得到 `PackageDir`:

```
define PackageDir
  /home/litreily/openwrt/tmp/.packageinfo: /home/litreily/openwrt/tmp/info/.packageinfo-base-files
  /home/litreily/openwrt/tmp/info/.packageinfo-base-files: package/base-files/Makefile $(foreach DEP,$(DEPS_package/base-files/Makefile) /home/litreily/openwrt/include/package*.mk,$(wildcard $(if $(filter /%,$(DEP)),$(DEP),package/base-files/$(DEP))))
        { \
                $(call progress,Collecting base-files info: package/base-files) \
                echo Source-Makefile: package/base-files/Makefile; \
                $(if ,echo Override: ,true); \
                $(NO_TRACE_MAKE) --no-print-dir -r DUMP=1 FEED="$(call feedname,base-files)" -C package/base-files $(SCAN_MAKEOPTS) 2>/dev/null || { \
                        mkdir -p "/home/litreily/openwrt/logs/package/base-files"; \
                        $(NO_TRACE_MAKE) --no-print-dir -r DUMP=1 FEED="$(call feedname,base-files)" -C package/base-files $(SCAN_MAKEOPTS) > /home/litreily/openwrt/logs/package/base-files/dump.txt 2>&1; \
                        $(call progress,ERROR: please fix package/base-files/Makefile - see logs/package/base-files/dump.txt for details\n) \
                        rm -f $@; \
                }; \
                echo; \
        } > $@.tmp
        mv $@.tmp $@
endef


```

注意到这里有定义两个目标。

1.  /home/litreily/openwrt/tmp/.packageinfo
2.  /home/litreily/openwrt/tmp/info/.packageinfo-base-files

**注意**: 其中第一个目标正好是 `all` 目标，并且其依赖是随之其后的 `.packageinfo-$(package)`. 所以目标 `all` 编译完成的前提之一就是所有 `.packageinfo-$(package)` 文件的生成。

以 `base-files` 为例， 通过进一步解析简化，可以得到 `tmp/info/.packageinfo-base-files` 的规则如下：

```
/home/litreily/openwrt/tmp/info/.packageinfo-base-files: package/base-files/Makefile /home/litreily/openwrt/include/package-*.mk
      { \
              $(call progress,Collecting base-files info: package/base-files) \
              echo Source-Makefile: package/base-files/Makefile; \
              make V=s --no-print-dir -r DUMP=1 FEED=" -C package/base-files 2>/dev/null \
      } > $@.tmp
      mv $@.tmp $@


```

其中包括打印 `Collecting base-files info: package/base-files` 这种 log，同时会执行 make 子进程

```
make V=s --no-print-dir -r DUMP=1 FEED=" -C package/base-files 2>/dev/null \


```

将信息写入 `tmp/info/.packageinfo-base-files`, 也就完成了目标的编译。

这个 make 子进程的重点是 `DUMP=1` , `package/base-files/Makefile` 会根据该变量打印 `base-files` 相关信息到指定文件。具体要看该 Makefile.

针对 `base-files`, dump 出来的信息如下：

```
Source-Makefile: package/base-files/Makefile
Build-Depends: usign/host ucert/host

Package: base-files
Version: 246-
Depends: +libc +USE_GLIBC:librt +USE_GLIBC:libpthread +netifd +jsonfilter +SIGNED_PACKAGES:usign +SIGNED_PACKAGES:openwrt-keyring +NAND_SUPPORT:ubi-utils +fstools +fwtool
Conflicts: 
Menu-Depends: 
Provides: 
Section: base
Category: Base system
Title: Base filesystem for OpenWrt
Maintainer: 
Source: 
License: GPL-2.0
Type: ipkg
Description:  This package contains a base filesystem and system scripts for OpenWrt.
http:

@@


```

说了这么多，`PackageDir` 函数何时调用呢？继续往后看。

### [](#make-all "make all")make all

`include` 相关依赖准备好后，make 开始解析默认目标 `all` 对应的依赖和指令，也就是 `tmp/.packageinfo` 目标。

```
$(TMP_DIR)/.$(SCAN_TARGET): $(TARGET_STAMP)
        $(call progress,Collecting $(SCAN_NAME) info: merging...)
        -cat $(FILELIST) | awk '{gsub(/\//, "_", $$0);print "$(TMP_DIR)/info/.$(SCAN_TARGET)-" $$0}' | xargs cat > $@ 2>/dev/null
        $(call progress,Collecting $(SCAN_NAME) info: done)
        echo


```

其依赖为 `$(TARGET_STAMP)`. 当然它的依赖不止这一个，前面 `PackageDir` 定义的规则中包含的目标也都是它的依赖。下面先来看看 `$(TARGET_STAMP)`.

#### [](#TARGET-STAMP "TARGET_STAMP")TARGET_STAMP

`$(TARGET_STAMP)` 对应值为 `/home/litreily/openwrt/tmp/info/.files-packageinfo.stamp`, 其对应指令如下：

```
$(TARGET_STAMP)::
        +( \
                $(NO_TRACE_MAKE) $(FILELIST); \
                MD5SUM=$$(cat $(FILELIST) $(OVERRIDELIST) | mkhash md5 | awk '{print $$1}'); \
                [ -f "$@.$$MD5SUM" ] || { \
                        rm -f $@.*; \
                        touch $@.$$MD5SUM; \
                        touch $@; \
                } \
        )


```

变量替换后为：

```
/home/litreily/openwrt/tmp/info/.files-packageinfo.stamp::
        +( \
                make V=ss /home/litreily/openwrt/tmp/info/.files-packageinfo-2109133; \
                MD5SUM=$(cat /home/litreily/openwrt/tmp/info/.files-packageinfo-2109133 /home/litreily/openwrt/tmp/info/.overrides-packageinfo-2109133 | mkhash md5 | awk '{print $1}'); \
                [ -f "/home/litreily/openwrt/tmp/info/.files-packageinfo.stamp.$MD5SUM" ] || { \
                        rm -f /home/litreily/openwrt/tmp/info/.files-packageinfo.stamp.*; \
                        touch /home/litreily/openwrt/tmp/info/.files-packageinfo.stamp.$MD5SUM; \
                        touch /home/litreily/openwrt/tmp/info/.files-packageinfo.stamp; \
                } \
        )


```

其中 `make V=ss /home/litreily/openwrt/tmp/info/.files-packageinfo-2109133` 又会启动一个新的子进程。

**说明：** 该子进程和 `make V=s` 一样，也会调用主 Makefile，并导入 `toplevel.mk` 等 Makefile，也就是说，如果缺少基本的编译工具或者依赖 (如 prepare-tmpinfo, .config 等)，这个子进程同样会和 `make V=s` 一样把所需依赖都生成一遍。但是不会完整编译项目。

`TARGET_STAMP` 目标主要是生成依赖工具和一个 MD5 文件。该子进程执行结束后，会计算生成一个 package 列表文件对应的 MD5 文件，并生成目标文件 `/home/litreily/openwrt/tmp/info/.files-packageinfo.stamp`.

#### [](#packageinfo-package ".packageinfo-$(package)").packageinfo-$(package)

`TARGET_STAMP` 生成结束后，就开始调用 `tmp/info/.files-packageinfo.mk` 逐个生成 `tmp/info/.packageinfo-$(package)` 文件。这里也就是调用上述 `PackageDir` 的地方。

所有相关文件都存储在 `tmp/info/` 目录，文件名为 `.packageinfo-$(package)`, 每个文件保存的信息由各自目录的 Makefile 决定，前面已经给出了 `base-files` 目录 dump 出来的信息，主要是描述信息、DEPENDs 信息等。

收集这些信息的时候，每个 package 都会打印一条 log。

```
Collecting package info: package/base-files
Collecting package info: package/boot/arm-trusted-firmware-mvebu
Collecting package info: package/boot/arm-trusted-firmware-rockchip
Collecting package info: package/boot/arm-trusted-firmware-sunxi



```

打印 log 使用的是 `progress` 函数，其定义如下：

```
ifeq ($(IS_TTY),1)
  ifneq ($(strip $(NO_COLOR)),1)
    define progress
    printf "\033[M\r$(1)" >&2;
    endef
  else
    define progress
    printf "\r$(1)" >&2;
    endef
  endif
else
  define progress
    :;
  endef
endif


```

实际上就是将 log 打印到 `stderr`, 也就是终端屏幕上，由于使用了 `\r` ，所以打印信息时会在同一行刷新，把它去掉就可以逐行打印了。

**说明：** 为什么 `TARGET_STAMP` 之后是生成 `.packageinfo-$(package)`? 这是因为在执行 `.packageinfo` 相关指令前，`scan.mk` 通过 include 导入了 `tmp/info/.files-packageinfo.mk` 文件, 该 Makefile 在导入的时候通过 `$(eval $(call PackageDir,base-files,base-files,))` 系列语句定义了 `.packageinfo` 的大量依赖，其依赖也就是这里提到的 `.packageinfo-$(package)`，所以，作为 `.packageinfo` 的依赖文件，当然要在执行目标指令前先生成。

#### [](#packageinfo ".packageinfo").packageinfo

目标 `all: tmp/.packageinfo` 的依赖文件都准备好后，继续来看目标 `all` 的编译规则：

```
/home/litreily/openwrt/tmp/.packageinfo: /home/litreily/openwrt/tmp/info/.files-packageinfo.stamp
        $(call progress,Collecting package info: merging...)
        -cat /home/litreily/openwrt/tmp/info/.files-packageinfo-2109133 | awk '{gsub(/\//, "_", $0);print "/home/litreily/openwrt/tmp/info/.packageinfo-" $0}' | xargs cat > /home/litreily/openwrt/tmp/.packageinfo 2>/dev/null
        $(call progress,Collecting package info: done)
        echo


```

以上指令其实很简单，就是将前面生成的 package 信息文件根据特定格式全部写入到目标文件 `.packageinfo` 中。同时使用 `progress` 函数打印相关信息。

```
Collecting package info: merging...
Collecting package info: done


```

言归正传，目标 `all` 在生成文件 `tmp/.packageinfo` 后就结束了，同样 `scan.mk` 的任务也完成了。

## [](#小结 "小结")小结

本文详细描述了 openwrt `scan.mk` 扫描过程，其目的是生成编译 package, target 所需的临时文件，将 package, target 相关的依赖信息、路径信息、描述信息存入文件，并保存在 tmp 目录。

`openwrt` 的 `Makefile` 非常复杂，许多复杂对象的依赖和指令可能相互嵌套和递归调用，所以无法完全讲述清楚，本文旨在根据 `Makefile` 梳理编译流程，某些细节可能无法避免被遗漏。

学习过程中用到了以下的小技巧，也在此总结一下：

1.  某些嵌套的 `make` 指令隐藏了调试信息，可以修改该指令，替换或添加 `-d DEBUG=vltrd`
2.  `openwrt` 的 `make` 大多调用了 `NO_TRACE_MAKE`, 所以可以直接在该变量定义处添加调试参数
3.  使用 `$(warning info)` 打印调试信息可以帮助理解
4.  include 指令前添加的 `-` 符号代表如果该文件暂时不存在可以继续执行，不必报错
5.  有时候可以手动执行某些内嵌的 `make` 指令, 不过记得加上必要的全局变量，比如 `TOPDIR`, `SCAN_COOKIE` 等