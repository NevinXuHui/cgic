SourceURL:file:///ntfs-data/work/linux内核/基于内核BuildKernel函数找到编译内核的依赖机制.wps

# **理解内核****KerneBuild****函数****的编译流程**

# **引言**

总结完《openwrt编译内核流程理解》后，知道内openwrt的编译从内核会调用KernelBuild函数。

本文继续基于该函数分析了首次编译内核的流程、什么都不修改编译内核的流程、修改补丁编译内核的流程。

理清了决定内核是否需要重新编译的依赖文件STAMP_PREPARED和.dep_files文件。

# 1) **kerne-build.mk****理解**

## **整个内核的编译代码从****include/kernel-build.mk****的****B****uildKernel****开始，**

## **1.1****)****理解****STAMP_PREPARED**

STAMP_PREPARED的定义如下：

STAMP_PREPARED=$(LINUX_DIR)/.prepared$(if $(QUILT)$(DUMP),,

_$(shell $(call $(if $(CONFIG_AUTOREMOVE),find_md5_reproducible,find_md5),$(KERNEL_FILE_DEPENDS),)))

LINUX_DIR指向linux的目录，如：

/home/zhoupeng/mtk/openwrt-21.02-orig/build_dir/target-aarch64_cortex-a53_musl/linux-mediatek_mt7981/linux-5.4.230

QUILT、DUMP的值都为空, 因此执行shell后面的命令

openwrt根目录下面的.config（专门配置openwrt的）中没有定义:

CONFIG_AUTOREMOVE，因此执行find_md5, 传入的参数是:

$(KERNEL_FILE_DEPENDS)

## **1.2)****理解****KERNEL_FILE_DEPENDS**

./include/kernel-build.mk:12:KERNEL_FILE_DEPENDS=$(GENERIC_BACKPORT_DIR) $(GENERIC_PATCH_DIR) $(GENERIC_HACK_DIR) $(PATCH_DIR) $(GENERIC_FILES_DIR) $(FILES_DIR)

展开后它的值是：

ERNEL_FILE_DEPENDS=/home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/backport-5.4 /home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/pending-5.4 /home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/hack-5.4 /home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/mediatek/patches-5.4 "/home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/files" "/home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/files-5.4" "/home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/mediatek/files-5.4".

## **1.3)****最后生成的****STAMP_PREPARED**

已知find_md5的实现代码如下：

find_md5=find $(wildcard $(1)) -type f $(patsubst -x,-and -not -path,$(DEP_FINDPARAMS) $(2)) -printf "%p%T@\n" | sort | mkhash md5

此时传入的第一个参数就是上面的KERNEL_FILE_DEPENDS, 它的原理就是将补丁文件全部取出来，然后给这些文件加上最后的修改时间(上面的%p%T完成文件名和修改时间的拼接)形成新的文件名， 最后基于这些新的文件名生成md5值。

最后STAMP_PREPARED就是$(LINUX_DIR)/.prepared_STAMP

所以STAMP就是包含了时间戳后的md5值。

如我的本地最后生成的STAMP_PREPARED值就是：

/home/zhoupeng/mtk/openwrt-21.02-orig/build_dir/target-aarch64_cortex-a53_musl/linux-mediatek_mt7981/linux-5.4.230/.prepared_732fecae0dd165932b681641a3bff86b

红色的是linux目录。

绿色表示这个文件的目标，如为prepared目标准备的，也就是编译工程提前准备的, 它表示一个准备型的文件；

紫色的表示加上时间戳信息后的md5值。

# 2) **BuildKernel****理解**

## **2.1)****执行流程理解**

从《openwrt编译内核流程理解》得知，进入BuildKernel后首先找compile目标，因此该函数也从该目标开始分析

### **2.1.1)compile****目标定义**

156   compile: $(LINUX_DIR)/.modules

157     $(MAKE) -C image compile TARGET_BUILD=

结论：

compile依赖.modules, 进一步查看.moudles的依赖实现

### **2.1****.2).modules****目标定义**

133   $(LINUX_DIR)/.modules: export STAGING_PREFIX=$$(STAGING_DIR_HOST)

134   $(LINUX_DIR)/.modules: export PKG_CONFIG_PATH=$$(STAGING_DIR_HOST)/lib/pkgconfig

135   $(LINUX_DIR)/.modules: export PKG_CONFIG_LIBDIR=$$(STAGING_DIR_HOST)/lib/pkgconfig

136   $(LINUX_DIR)/.modules: $(STAMP_CONFIGURED) $(LINUX_DIR)/.config FORCE

137     $(Kernel/CompileModules)

138     touch $$@

前三行的目标都是文件依赖，都已经存在，如果不存在则会下载。

STAMP_CONFIGURED的定义如下：

14 STAMP_CONFIGURED:=$(LINUX_DIR)/.configured

这个文件已经存在，但需要看看它的依赖。

总结：

继续查看.configured和.config目录的依赖

### **2.1.3).configured****目标定义**

129   $(STAMP_CONFIGURED): $(STAMP_PREPARED) $(LINUX_KCONFIG_LIST) $(TOPDIR)/.config FORCE

130     $(Kernel/Configure)

131     touch $$@

Kernel/Configure完成内核相关的配置，然后调用touch创建完目标文件，表示.configured这个目标已经执行过了，可以避免重复执行。

这儿最重要的是$(STAMP_PREPARED)这个目标的依赖，它就是签名看到的时间戳文件。

所以继续看的目标依赖

### **2.1.4)** **时间戳文件****STAMP_PREPARED****目标的定义**

 77     define Kernel/Autoclean

 79       $(PKG_BUILD_DIR)/.dep_files:$(STAMP_PREPARED)

 80       $(call rdep,$(KERNEL_FILE_DEPENDS),$(STAMP_PREPARED),$(PKG_BUILD_DIR)/.dep_files,-x "*/.    dep_*")

 81     endef

79行的.dep_files文件依赖STAMP_PREPARED文件，所以继续查看下面的rdep函数对STAMP_PREPARED目标的定义

rdep函数实现如下：

$(2)=$(STAMP_PREPARED), 也就是前面看到的时间戳文件

$(3)=$(PKG_BUILD_DIR)/.dep_files, 这个文件的内容就是基于每个补丁文件生成名加上这些文件的修改时间生成的一个md5值。所以对于内核(估计其它开源代码也一样)，触发它增量编译只会看补丁文件，如果想自己修改内核快速调试，那么就需要将编译的命令抠出来然后自己手动执行来编译了。

 17 define rdep

 18   .PRECIOUS: $(2)

 19   .SILENT: $(2)_check

 20

 21   $(2): $(2)_check

 22   check-depends: $(2)_check

 23

 24 ifneq ($(wildcard $(2)),)

 25   $(2)_check::

 26     $(if $(3), \

 27         $(call find_md5,$(1),$(4)) > $(3).1; \

 28         { [ \! -f "$(3)" ] || diff $(3) $(3).1 >/dev/null; } && \

 29     ) \

 30     { \

 31         [ -f "$(2)_check.1" ] && mv "$(2)_check.1"; \

 33         $(TOPDIR)/scripts/timestamp.pl $(DEP_FINDPARAMS) $(4) -n $(2) $(1) && { \

 34             $(call debug_eval,$(SUBDIR),r,echo "No need to rebuild $(2)";) \

 35             touch -r "$(2)" "$(2)_check"; \

 36         } \

 37     } || { \

 39         $(call debug_eval,$(SUBDIR),r,echo "Need to rebuild $(2)";) \

 40         touch "$(2)_check"; \

 41     }

 42     $(if $(3), mv $(3).1 $(3))

 43 else

 44   $(2)_check::

 45     $(if $(3), rm -f $(3) $(3).1)

 46     $(call debug_eval,$(SUBDIR),r,echo "Target $(2) not built")

 47 endif

 49 endef

a)首先时间戳文件这个目标转换成了继续依赖时间戳_check这个目标，也就是上面的21行处的代码：

$(2):$(2)_check

b)24行的代码决定了代码的走向，它通过wildcard判断时间戳文件是否存在，如果不存在，表示之前没有编译过，此时进入下面的else分支。

进入else 分支后，如果发现.dep_files文件存在就删除它，然后就什么都不做了。

c)如果时间戳文件存在，进入if分支，此时重新生存时间戳文件.dep_files.1, 然后比较.dep_files和.dep_files.1, 如果内容一样，即补丁文件没有发生改变，此时运行31-35行的代码，此时最重要的代码是35行的代码，创建stamp_check文件，且这个时间戳文件和stamp的文件的创建时间一致，这个通过touch的-r参数搞定。

最后用.dep_files.1文件覆盖.dep_files文件，不过内容是否一样都覆盖了，可以猜测该文件不决定是否重新编译，仅仅是用来判断stamp_check的文件生成。

d)总结：

d.1)stamp文件存在时，即之前编译过了，如果补丁更新了，那么创建新的stamp_check文件。.dep_files文件更新为最新的。

d.2)stamp文件存在时，如果补丁没有更新，虽然也创建了stamp_check文件，但是它的时间和stamp文件的时间是一样的。.dep_files文件更新为最新的。

d.3)stamp文件不存在时，直接删除.dep_files文件，也不创建stamp_check文件

# 3) **主动触发修改**

主动在下面的目录主动增加一个文件，去理解一下为什么就触发了内核的编译

/home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/backport-5.4

第一次修改

162   compile: stopme $(LINUX_DIR)/.modules

执行结果：

先运行到stopme, 而不是给内核打patch

第二次修改

136   $(LINUX_DIR)/.modules: stopme1 $(STAMP_CONFIGURED)  $(LINUX_DIR)/.config FORCE

137     $(Kernel/CompileModules)

138     openwrt-block $$@ after-kernel-compilemodule

139     touch $$@

执行结果：

先运行到stopme1, 而不是给内核打patch

第三次修改

136   $(LINUX_DIR)/.modules: $(STAMP_CONFIGURED) stopme $(LINUX_DIR)/.config FORCE

137     $(Kernel/CompileModules)

138     openwrt-block $$@ after-kernel-compilemodule

139     touch $$@

执行结果：

先删除linux-mediatek_mt7981文件夹 

rm -rf /home/zhoupeng/mtk/openwrt-21.02-orig/build_dir/target-aarch64_cortex-a53_mus     l/linux-mediatek_mt7981

然后创建新的linux-mediatek_mt7981文件夹

mkdir -p /home/zhoupeng/mtk/openwrt-21.02-orig/build_dir/target-aarch64_cortex-a53_m     usl/linux-mediatek_mt7981

解析内核到linux-mediatek_mt7981

xzcat /home/zhoupeng/mtk/openwrt-21.02-orig/dl/linux-5.4.230.tar.xz | tar -C /home/z     houpeng/mtk/openwrt-21.02-orig/build_dir/target-aarch64_cortex-a53_musl/linux-mediatek_mt7981 -xf -

copy 源代码

 cp -fpR "/home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/files"/. "/home/     zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/files-5.4"/. "/home/zhoupeng/mt     k/openwrt-21.02-orig/target/linux/mediatek/files-5.4"/. /home/zhoupeng/mtk/openwrt-2     1.02-orig/build_dir/target-aarch64_cortex-a53_musl/linux-mediatek_mt7981/linux-5.4.230/

删除.reg和.orig结尾的文件

find /home/zhoupeng/mtk/openwrt-21.02-orig/build_dir/target-aarch64_cortex-a53_musl/     linux-mediatek_mt7981/linux-5.4.230/ -name \*.rej -or -name \*.orig | xargs -r rm -f

判断/home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/patches目录，如果存在则报错

if [ -d /home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/patches ]; then echo "generic patches directory is present. please move your patches to the pending directory" ; exit 1; fi

开始打补丁

Applying /home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/backport-5.4/010     -Kbuild-don-t-hardcode-path-to-awk-in-scripts-ld-vers.patch using plaintext:

结论：

linux的解压以及打补丁都是在STAMP_CONFIGURED目标中完成的

## **3.2)stamp_configured****与****stamp_prepared****的关系理解**

已知代码如下：

133   $(STAMP_CONFIGURED): $(STAMP_PREPARED)  $(LINUX_KCONFIG_LIST)  $(TOPDIR)/.config  FORCE

135     $(Kernel/Configure)

137     touch $$@

已知这两个变量的值如下：

STAMP_CONFIGURED=/home/zhoupeng/mtk/openwrt-21.02-orig/build_dir/target-aarch64_cortex-a53_musl/linux-mediatek_mt7981/linux-5.4.230/.configured

STAMP_PREPARED=/home/zhoupeng/mtk/openwrt-21.02-orig/build_dir/target-aarch64_cortex-a53_musl/linux-mediatek_mt7981/linux-5.4.230/.prepared_4fb9fc06f4348d788cf7b3d4ce6a422e

当首次编译时，这两个文件都不存在。

首先rdep函数生成了stamp文件， 由于confiugred也不存在，所以自然会去执行Kernel/Confiugre函数

所以首次编译比较好理解

## **3.3)** **修改内核补丁文件**

### **3.3.1)****修改补丁触发的重新编译**

STAMP_PREPARED目标被STAMP_CONFIGURED目标触发，对于的代码如下：

133   $(STAMP_CONFIGURED):  $(STAMP_PREPARED) $(LINUX_KCONFIG_LIST)  $(TOPDIR)/.config  FORCE

135     $(Kernel/Configure)

137     touch $$@

接下来需要重点看的就是STAMP_PREPARED目标的执行

BuildKernel函数中有如下代码：

 95   $(STAMP_PREPARED):  $(if $(LINUX_SITE),$(DL_DIR)/$(LINUX_SOURCE))  

 97     -rm -rf $(KERNEL_BUILD_DIR)

 98     -mkdir -p $(KERNEL_BUILD_DIR)

 99     $(Kernel/Prepare)

rdep生成的函数中有如下代码：

 21   $(2):  $(2)_check

 43 else

 44   $(2)_check::

 46     $(if $(3), rm -f $(3) $(3).1)

 47     $(call debug_eval,$(SUBDIR),r,echo "Target $(2) not built")

 48 endif

a)STAMP_PREPARED值变化

当补丁文件发送了变化时，STAMP_PREPARED的值会发生变化，假设之前的值为：

.prepared_4fb9fc06f4348d788cf7b3d4ce6a422e

.prepared_4fb9fc06f4348d788cf7b3d4ce6a422e_check

/home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/backport-5.4下面touch一个文件

touch zptest

新的STAMP_PREPARED值为.prepared_3be8e76519b2d76b25e58135c7df8e5e

STAMP_PREPARED=/home/zhoupeng/mtk/openwrt-21.02-orig/build_dir/target-aarch64_cortex-a53_musl/linux-mediatek_mt7981/linux-5.4.230/.prepared_3be8e76519b2d76b25e58135c7df8e5e

b)执行rdep函数的else分支

因为STAMP_PREPARED发生了变化，所以会进入上面的else分支代码，也就是46, 47行的代码。

这两行代码也就是删除了.dep_files, .dep_files.1文件。

c)执行BuildKernel函数的STAMP_PREPARED目标

也就是上面的97至99行的代码

此时能执行97~99行代码的原因是因为STAMP_PREPARED这个新生成的文件还不存在，即目标还不存在，所以自然就会去执行这些规则代码，这些规则代码先删除就的linux目录，然后开始解压，打补丁了。

**总结：**

到这儿为止，最大的一个收获就是开源代码是否重新编译是由动态生成的STAMP_PREPARED文件来决定的，当文件的时间发送变化或者是新增了文件，那么就会重新解压、打包并编译

### **3.3.2)****STAMP_PREPARED****已经存在的****再次编译**

如果STAMP_PREPARED已经存在了，但是被ctrl+c了，但补丁文件没有修改过，也没有在那几个动态扫描的目录新增任何文件、删除任何文件，那么再次编译又是什么情况呢？

rdep函数的if分支代码如下：

 24 ifneq ($(wildcard $(2)),)

 25   $(2)_check::

 26     $(if $(3), \

 27         $(call find_md5,$(1),$(4)) > $(3).1; \

 28         { [ \! -f "$(3)" ] || diff $(3) $(3).1 >/dev/null; } && \

 29     ) \

 30     { \

 31         [ -f "$(2)_check.1" ] && mv "$(2)_check.1"; \

 33         $(TOPDIR)/scripts/timestamp.pl $(DEP_FINDPARAMS) $(4) -n $(2) $(1) && { \

 34             $(call debug_eval,$(SUBDIR),r,echo "No need to rebuild $(2)";) \

 35             touch -r "$(2)" "$(2)_check"; \

 36         } \

 37     } || { \

 39         $(call debug_eval,$(SUBDIR),r,echo "Need to rebuild $(2)";) \

 40         touch "$(2)_check"; \

 41     }

 42     $(if $(3), mv $(3).1 $(3))

a) 进入if分支运行

$(2)是STAMP_PREPARED文件，因为什么文件都没有修改，所以这些文件对于的修改时间也没有变，因此md5值也就没有变，所以进入if分支了。

如果.dep_files不存在，即$(3)为空，那么直接运行31～35行的代码

b)根据STAMP_PREPARED生成同时间的STAMP_PREPARED_check文件

31行的不成立，因为不存在这样的文件，如果真的存在，那么运行就会出现问题，因为mv只带了一个参数。

33～34行的代码仅仅是调试打印

35行的代码是重点，生成STAMP_PREPARED_check文件，且生成的时间借用的是STAMP_PREPAERD文件的

c)处理.dep_files.1文件

处理的代码是42行的代码，mv .dep_files.1 .dep_files

d)处理STAMP_CONFIGURED

133   $(STAMP_CONFIGURED):  $(STAMP_PREPARED)   $(LINUX_KCONFIG_LIST)  $(TOPDIR)/.config  FORCE

135     $(Kernel/Configure)

137     touch $$@

执行Kernel/Configure函数, 完成内核编译之前的相关配置，安装内核头文件

$(KERNEL_MAKE) INSTALL_HDR_PATH=$(LINUX_DIR)/user_headers headers_install

然后touch STAMP_CONFIGURED文件

总结：

到这儿为止，最大的收获就是STAMP_PREPARED没有发生变化时，新增了STAMP_PREPARED_check文件，它表示没有去重新编译，但走了一遍编译流程，生成这个_check文件证明走了一遍编译流程。

无条件更新了.dep_files文件

### **3.3****.3)****重复编译的处理流程**

 24 ifneq ($(wildcard $(2)),)

 25   $(2)_check::

 26     $(if $(3), \

 27         $(call find_md5,$(1),$(4)) > $(3).1; \

 28         { [ \! -f "$(3)" ] || diff $(3) $(3).1 >/dev/null; } && \

 29     ) \

 30     { \

 31         [ -f "$(2)_check.1" ] && mv "$(2)_check.1"; \

 32         touch no-need-to-rebuild; \

 33         $(TOPDIR)/scripts/timestamp.pl $(DEP_FINDPARAMS) $(4) -n $(2) $(1) && { \

 34             $(call debug_eval,$(SUBDIR),r,echo "No need to rebuild $(2)";) \

 35             touch -r "$(2)" "$(2)_check"; \

 36         } \

 37     } || { \

 38         openwrt-block need-to-rebuild; \

 39         $(call debug_eval,$(SUBDIR),r,echo "Need to rebuild $(2)";) \

 40         touch "$(2)_check"; \

 41     }

 42     $(if $(3), mv $(3).1 $(3))

a)仅仅是.dep_files的时间发生了更新

由于补丁文件没有更新所以STAMP_PREPARED没有发生变化，进入rdep的if分支。

$(3)=.dep_files, 由于它已经存在，所以重新生成.dep_files.1文件。

由于补丁文件没有发生变化，.dep_files和.dep_files.1内容比较一致，所以进入”No need to rebuild”代码，重新基于STAMP_PREPARED更新了一下STAMP_PREPARED_check文件

最后用.dep_files.1更新了.dep_files

到这儿为止看到的变化就是.dep_files的时间更新了，但是内容没有变化。

b)重新运行Kernel/Configure函数

  $(STAMP_CONFIGURED):  $(STAMP_PREPARED)   $(LINUX_KCONFIG_LIST)  $(TOPDIR)/.config  FORCE

    $(Kernel/Configure)

touch $$@

虽然目标STAMP_CONFIGURED比这些依赖的时间都新了，但是由于FORCE目标的存在，还是会重新执行Kernel/Configure函数，并再次更新STAMP_CONFIGURE文件的时间

c)无条件执行Kernel/CompileModules函数

  $(LINUX_DIR)/.modules:  $(STAMP_CONFIGURED)  $(LINUX_DIR)/.config FORCE

    $(Kernel/CompileModules)

    touch $$@

由于FORCE目标的存在，会无条件执行Kernel/CompileModules函数去编译内核modules模块，即ko模块

编译命令如下

make -C /home/zhoupeng/mtk/openwrt-21.02-orig/build_dir/target-aarch64_cortex-a53_musl/linux-mediatek_mt7981/linux-5.4.230 KCFLAGS="-fmacro-prefix-map=/home/zhoupeng/mtk/openwrt-21.02-orig/build_dir/target-aarch64_cortex-a53_musl=target-aarch64_cortex-a53_musl -fno-caller-saves " HOSTCFLAGS="-O2 -I/home/zhoupeng/mtk/openwrt-21.02-orig/staging_dir/host/include  -Wall -Wmissing-prototypes -Wstrict-prototypes" CROSS_COMPILE="aarch64-openwrt-linux-musl-" ARCH="arm64" KBUILD_HAVE_NLS=no KBUILD_BUILD_USER="" KBUILD_BUILD_HOST="" KBUILD_BUILD_TIMESTAMP="Wed Feb  8 08:40:05 2023" KBUILD_BUILD_VERSION="0" HOST_LOADLIBES="-L/home/zhoupeng/mtk/openwrt-21.02-orig/staging_dir/host/lib" KBUILD_HOSTLDLIBS="-L/home/zhoupeng/mtk/openwrt-21.02-orig/staging_dir/host/lib" CONFIG_SHELL="bash" V=''  cmd_syscalls=  KERNELRELEASE=5.4.230 CC="aarch64-openwrt-linux-musl-gcc" modules

### **3.3.4)STAMP_PREPARED****和****.dep_files****的区别**

已知两个函数如下：

 14 find_md5=find $(wildcard $(1)) -type f $(patsubst -x,-and -not -path,$(DEP_FINDPARAMS) $(2)) -printf     "%p%T@\n" | sort | mkhash md5

 15 find_md5_reproducible=find $(wildcard $(1)) -type f $(patsubst -x,-and -not -path,$(DEP_FINDPARAMS)     $(2)) -print0 | xargs -0 mkhash md5 | sort | mkhash md5

find_md5因为”%p%T@\n”中的”%T”这个参数的存在，导致使用了文件的修改时间，所以只有文件有被修改，md5值就会发生变化。

find_md5_reproducible因为 -print 0 |xargs -0 参数的使用，没有使用文件的修改时间，仅仅新增、删除了文件才会导致md5值发生变化，所以如果同名文件复制是不会触发重新编译的。

可以用下面的命令来学习验证：

find /home/zhoupeng/mtk/openwrt-21.02-orig/target/linux/generic/backport-5.4  -type f -and -not -path "*/.svn*" -and -not -path ".*" -and -not -path "*:*" -and -not -path "*\!*" -and -not -path "* *" -and -not -path "*\#*" -and -not -path "*/.*_check" -and -not -path "*/.*.swp" -and -not -path "*/.pkgdir*" -and -not -path "*/.dep_*" -print0|xargs -0 mkhash md5 |sort|mkhash md5

已知两个变量的赋值如下：

.dep_files的生存

 $(call rdep,$(KERNEL_FILE_DEPENDS),$(STAMP_PREPARED),$(PKG_BUILD_DIR)/.dep_files,-x "*/.dep_*")

$(call find_md5,$(1),$(4)) > $(3).1;

STAMP_PREPARED=$(LINUX_DIR)/.prepared$(if $(QUILT)$(DUMP),,_$(shell $(call $(if $(CONFIG_AUTOREMOVE),find_md5_reproducible,find_md5),$(KERNEL_FILE_DEPENDS),)))

.dep_files无条件使用了文件的修改时间

STAMP_PREPARED则分情况，当CONFIG_AUTOREMOVE配置打开时，不用文件的修改时间；否则用文件的修改时间。当前CONFIG_AUTOREMOVE配置没有打开，所以这两个变量目前是一样的。

### **3.3****.5).dep_files****触发的重新编译**

先看这个Makefile，它模拟了depends.mk中的 rdep函数以及kernel-build.mk中的BuildKernel函数的实现

  1 prepared11:prepared11_check

  2

  3 prepared11:test.c

  4     gcc -g -c test.c -o test.o

  5     @touch $@

  6

  7 prepared11_check::

  8     @echo "will touch " $@

  9     @touch $@

prepared11依赖了两个目标，prepared11_check和test.c

第7行的prepared11_check目标用了双引号，这会导致这个目标总是被执行，当这个目标被执行时总是会touch一下自己，所以它会导致prepared11_check这个依赖总是比prepared11这个目标新，也就会导致prepared11这个目标下的规则被执行。

![](file:////tmp/wps-ubuntu/ksohtml/wpsx9jwpG.jpg) 

### **3.3****.3)****定制修改**

两个修改：

可以新增补丁目录，这样自己的修改也级可以被动态依赖进来了

由哪些文件生存的STAMP_PREPARED文件名可以保存到一个日志文件中，方便后面调试查看