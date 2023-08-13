SourceURL:file:///ntfs-data/work/linux内核/从openwrt编译工程之执行下载代码点找到编译工程的根入口.wps

# **从****openwrt****编译工程之执行下载代码点找到编译工程的根入口**

# 1) **问题描述**

本文主要描述如何通过从下载开源包出发反向找到Makefile编译的根入口。

下载开源包这个特征点很明显，也容易观察到，可以通过相关的关键字方向跟踪，从而找到Makefile编译的入口。

# **2)****反向跟踪**

## **2.1)****查看打印日志**

通过正在下载的包发现，正在下载的包是dosfstools-4.1.tar.xz.

因此通过此关键字搜索：

SHELL= flock /home/zhoupeng/mtk/openwrt-21.02/tmp/.dosfstools-4.1.tar.xz.flock -c '     /home/zhoupeng/mtk/openwrt-21.02/scripts/download.pl "/home/zhoupeng/mtk/openwrt-21.02/dl" "dosfstools-4.1.tar.xz" "e6b2aca70ccc3fe3687365009dd94a2e18e82b688ed4e260e04b7412471cc173" "" "https://github.com/dosfstools/dosfstools/releases/download/v4.1/" "http://fossies.org/linux/misc"    '

+ wget --tries=5 --timeout=20 --output-document=- https://github.com/dosfstools/dosfstools/releases/download/v4.1/dosfstools-4.1.tar.xz

从上面的命令可以看到，下载是通过download.pl来完成的，因此进一步看看谁调用了它

## **2.2)****查看谁调用了****download.pl**

include/download.mk中有如下代码：

128 define DownloadMethod/default

129     $(SCRIPT_DIR)/download.pl "$(DL_DIR)" "$(FILE)" "$(HASH)" "$(URL_FILE)" $(foreach url,$    (URL),"$(url)") \

130     $(if $(filter check,$(1)), \

131         $(call check_hash,$(FILE),$(HASH),$(2)$(call hash_var,$(MD5SUM))) \

132         $(call check_md5,$(MD5SUM),$(2)MD5SUM,$(2)HASH) \

133     )

134 endef

结论：

download.mk的DownloadMethod/default调用了download.pl

## **2.3)****谁调用了****DownloadMethod/default**

还是在download.mk中，有如下代码：

grep -rns --exclude=*.log DownloadMethod .|grep default

303 define Download

304   $(eval $(Download/Defaults))

305   $(eval $(Download/$(1)))

306   $(foreach FIELD,URL FILE $(Validate/$(call dl_method,$(URL),$(PROTO))),

307     ifeq ($($(FIELD)),)

308       $$(error Download/$(1) is missing the $(FIELD) field.)

309     endif

310   )

311

312   $(foreach dep,$(DOWNLOAD_RDEP),

313     $(dep): $(DL_DIR)/$(FILE)

314   )

315   download: $(DL_DIR)/$(FILE)

316

317   $(DL_DIR)/$(FILE):

318     mkdir -p $(DL_DIR)

319     $(call locked, \

320         $(if $(DownloadMethod/$(call dl_method,$(URL),$(PROTO))), \

321             $(call DownloadMethod/$(call dl_method,$(URL),$(PROTO)),check,$(if $(filter def    ault,$(1)),PKG_,Download/$(1):)), \

322             $(DownloadMethod/unknown) \

323         ),\

324         $(FILE))

325

326 endef

结论：

看来是谁调用了Download方法，继续查看谁调用了这个方法

## **2.4)** **谁调用了****Download****方法**

在Download方法中增加如下打印：

303 define Download

304   $(error "stop..................")

结果看到了如下日志信息：

make[3]: Entering directory '/home/zhoupeng/mtk/openwrt-21.02/tools/xz'

Makefile:36: *** "stop..................".  Stop.

tools/xz/Makefile:36行的内容如下：

36 $(eval $(call HostBuild))

结论：

HostBuild方法调用了Download方法

## **2.****5****）****HostBuild****方法确认**

在./include/host-build.mk:206 中定义，定义的方法如下：

206 define HostBuild

207   $(HostBuild/Core)

208   $(if $(if $(PKG_HOST_ONLY),,$(STAMP_PREPARED)),,$(if $(strip $(PKG_SOURCE_URL)),$(call Do    wnload,default)))

209 endef

## **2.****6****）谁调用了****HostBuild****方法**

从前面的分析可以知道，每个工具的Makefile完成了这个实现和调用，如

/home/zhoupeng/mtk/openwrt-21.02/tools/xz/Makefile

如果是cmake包的下载，那么就是

tools/cmake/Makefile完成了这种下载实现

结论：

进一步查看工具的Makefile是如何被调用的，如tools/xz/Makefile

## **2.7)****谁调用了****tools/xz/Makefile**

tools/xz/Makefile中增加一个错误信息：

 26 $(error "stop.........")

 27 $(eval $(call HostBuild))

执行编译时看到如下错误信息：

make[1]: ***

[tools/Makefile:157: /home/zhoupeng/mtk/openwrt-21.02/staging_dir/host/stamp/.tools_compile_yyyynyynnyyyynyyyyyyynyynnyyyynyyyyyyyyyyyyyyyynynnyyyyyyy] Error 2

tools/Makefile中有如下代码：

157 $(eval $(call

stampfile,$(curdir),tools,compile,,_$(subst $(space),,$(tools_enabled)),$(STAGING_DIR_HOST)    ))

结论：

tools/Makefile中的stampfile函数执行到了tools/xz/Makefile

## **2.8)****查找****stampfile****的定义**

grep -rns stampfile .|grep define

./include/subdir.mk:87:define stampfile

结论：

stampfile函数在subdir.mk中定义

## **2.9)****谁****include subdir.mk**

 mv include/subdir.mk include/subdir.mk-nouse

编译看到如下错误：

zhoupeng@zhoupeng-PC:~/mtk/openwrt-21.02$ make -j1 V=s

Makefile:35: /home/zhoupeng/mtk/openwrt-21.02/include/subdir.mk: No such file or directory

make[3]: *** No rule to make target '/home/zhoupeng/mtk/openwrt-21.02/include/subdir.mk'.  Stop

根Makefil中果然有如下代码：

 35   include $(INCLUDE_DIR)/subdir.mk

结论：

根Makefile包含了subdir.mk, subdir.mk中的stampfile函数可以触发工具包的下载。

但是stampfile函数被tools/Makefile中的如下代码调用：

$(eval $(call stampfile,$(curdir),tools,compile,,_$(subst $(space),,$(tools_enabled)),$(STAGING_DIR_HOST)))

所以可以进一步看看stampfile函数到底是如何实现的

## **2.10) stampfile****函数实现分析**

再次回到这条语句：

$(eval $(call stampfile,$(curdir),tools,compile,,_$(subst $(space),,$(tools_enabled)),$(STAGING_DIR_HOST)))

这儿tools_enabled的值如下：

y y y y n y y n n y y y y n y y y y y y y n y y n n y y y y n y y y y y y y y y y y y y y y y n y n n y y y y y y y

STAGING_DIR_HOST的值为：

/home/zhoupeng/mtk/openwrt-21.02/staging_dir/host.

curdir的值为tools

 87 define stampfile

 88   $(1)/stamp-$(3):=$(if $(6),$(6),$(STAGING_DIR))/stamp/.$(2)_$(3)$(5)

 89   $(info aaaaaa=$$($(1)/stamp-$(3)))

 90   $(info bbbbbbb=$(TMP_DIR)/.build $(4))

 91   $$($(1)/stamp-$(3)): $(TMP_DIR)/.build $(4)

 92     $(SCRIPT_DIR)/timestamp.pl -n $$($(1)/stamp-$(3)) $(1) $(4) || \

 93         $(MAKE) $(if $(QUIET),--no-print-directory) $$($(1)/flags-$(3)) $(1)/$(3)

 94     $(info 4s=$$$$(dirname $$($(1)/stamp-$(3))))

 95     mkdir -p $$$$(dirname $$($(1)/stamp-$(3)))

 96     touch $$($(1)/stamp-$(3))

touch文件是一个比较明显的点，可以基于堵在touch这个点反向推理Makefile的执行流程了

# **3)****理解****touch****过的文件**

## **3.****1)****堵在****touch**

#include <stdio.h>

#include <string.h>

int g_c=0;

int main(int argc, char** argv) {

    if (argv[1]) {

                if (!strstr(argv[1],"/home/zhoupeng")) {

                        system(argv[1]);

                        return 0;

                }

        }

        while(1) {

                sleep(1);

                if (g_c) {

                        char cmd[256];

                        snprintf(cmd, sizeof(cmd),"touch-nouse %s",argv[1]);

                        system(cmd);

                        break;

                }

        }

        return 0;

}

编译成touch, 然后：

mv /usr/bin/touch /usr/bin/touch-nouse

cp ./touch /usr/bin/touch

## **3.2)****第一次****touch**

touch /home/zhoupeng/mtk/openwrt-21.02/tmp/info/.overrides-packageinfo-13399

执行touch的文件

make V=ss -j1 -r -s -f include/scan.mk SCAN_TARGET=packageinfo SCAN_DIR=package SCAN_NAME=package SCAN_DEPTH=5 SCAN_EXTRA=

执行make的父进程是：

 /bin/sh -c export MAKEFLAGS= ;make V=ss -j1 -r -s -f include/scan.mk SCAN_TARGET="packageinfo" SCAN_DIR="package" SCAN_NAME="package" SCAN_DEPTH=5 SCAN_EXTRA=""

进一步查找父进程：

make V=ss -r -s prereq

进一步查找父进程：

/bin/sh -c OPENWRT_BUILD= QUIET=0 make V=ss -r -s prereq

进一步查找父进程

make -j1 V=s

**结论：**

到这儿为止已经找到了根，且从根出发是去执行prereq目标执行到了touch文件和下载开源代码。

继续看看第二个touch的文件是不是也是这样

## **3.2)****第二次****touch**

touch的文件

touch /home/zhoupeng/mtk/openwrt-21.02/tmp/info/.files-packageinfo.stamp.c59a0648d1f5bfc75502405a4652fe65

/bin/sh -c ( \ ?make V=ss /home/zhoupeng/mtk/openwrt-21.02/tmp/info/.files-packageinfo-17876; \ ?MD5SUM=$(cat /home/zhoupeng/mtk/openwrt-21.02/tmp/info/.files-packageinfo-17876 /home/zhoupeng/mtk/openwrt-21.02/tmp/info/.overrides-packageinfo-17876 | mkhash md5 | awk '{print $1}'); \ ?[ -f "/home/zhoupeng/mtk/openwrt-21.02/tmp/info/.files-packageinfo.stamp.$MD5SUM" ] || { \ ??rm -f /home/zhoupeng/mtk/openwrt-21.02/tmp/info/.files-packageinfo.stamp.*; \ ??touch /home/zhoupeng/mtk/openwrt-21.02/tmp/info/.files-packageinfo.stamp.$MD5SUM; \ ??touch /home/zhoupeng/mtk/openwrt-21.02/tmp/info/.files-packageinfo.stamp; \ ?} \ )

上一个进程是：

make V=ss -j1 -r -s -f include/scan.mk SCAN_TARGET=packageinfo SCAN_DIR=package SCAN_NAME=package SCAN_DEPTH=5 SCAN_EXTRA=

再上一个进程是：

zhoupeng 17982 17981  0 10:40 pts/6    00:00:00 make V=ss -j1 -r -s -f include/scan.mk SCAN_TARGET=packageinfo SCAN_DIR=package SCAN_NAME=package SCAN_DEPTH=5 SCAN_EXTRA=

再上一个进程是：

zhoupeng 17981 17880  0 10:40 pts/6    00:00:00 /bin/sh -c export MAKEFLAGS= ;make V=ss -j1 -r -s -f include/scan.mk SCAN_TARGET="packageinfo" SCAN_DIR="package" SCAN_NAME="package" SCAN_DEPTH=5 SCAN_EXTRA=""

再上一个进程是:

zhoupeng 17880 17879  0 10:40 pts/6    00:00:00 make V=ss -r -s prereq

zhoupeng 17879 17828  0 10:40 pts/6    00:00:00 /bin/sh -c OPENWRT_BUILD= QUIET=0 make V=ss -r -s prereq

zhoupeng 17828  7270  0 10:40 pts/6    00:00:00 make -j1 V=s

结论：

到这儿为止也找到了根，且从根出发是去执行prereq目标，和第一次一样

## **3.3)****流程分析**

首先根据OPENWRT_BUILD搜索到如下关键字信息

./include/toplevel.mk:5:PREP_MK= OPENWRT_BUILD= QUIET=0

进一步跟踪，发现在include/toplevel.mk的如下代码：prereq这个目标已经看到

227 %::

228     echo "execute........" $@

229     @+$(PREP_MK) $(NO_TRACE_MAKE) -r -s prereq

NO_TRACE_MAKE在include/verbose.mk文件中定义：

 19 ifeq ($(NO_TRACE_MAKE),)

 20 NO_TRACE_MAKE := $(MAKE) V=s$(OPENWRT_VERBOSE)

 21 export NO_TRACE_MAKE

 22 endif

上面的227行生成的代码组合起来就是：

OPENWRT_BUILD= QUIET=0 make V=ss -r -s prereq  

**结论：**

这儿执行prerrq的目标已经看到，而且它是通过一个通用目标进来的

## **3.4)确认是谁匹配到了这个通用规则**

227行的%表示通用规则匹配，增加如下调试代码：

227 %::

228     echo "execute........" $@

229     @+$(PREP_MK) $(NO_TRACE_MAKE) -r -s prereq

结果得到如下打印：

echo "execute........" world

execute........ world

**总结：**

原来是world目标，看来需要看看world这个目标是如何进来的

## **3.****5)world****目标的指定**

grep -rns --include=Makefile --include=*.mk world

结果发现这个world目标就在根Makefile中，如下：

 15 world:

可以写一个简单的Makefile理解一下，是不是只要定义了一个目标，然后执行make时就会主动用通配符目标去匹配它了：

Makefile的代码如下：

  2 %::

  3     echo "execute......."$@

  4     gcc -g -Os -c test.c -o test.o

  5

  6 world:

  7

  8 obj:

  9    gcc -g -c  test.c -o test.o

 10

 11 .PHONY: help FORCE

这儿world目标在obj之前

最终的执行结果如下：

echo "execute......."world

execute.......world

gcc -g -Os -c test.c -o test.o

所以只要有一个简单的目标放到最前面，同时又定义了通配符目标，执行make命令时就会让这个放到最前面的目标去匹配这个通配符目标

**结论：**

至此编译工程的根源头已经找到，从根Makefile的world出发，找到了include/toplevel.mk中的通用匹配规则%::, 然后就可以一直往下运行了。

## **3.6****)****流程再次梳理**

以touch到文件为目标，从根Makefile中梳理从上往下调用的流程：

**a)**openwrt-21.02/Makefile中定义了world 目标

 15 world:

**b)**include/toplevel.mk中定义了一个通配符目标

PREP_MK的值为OPENWRT_BUILD= QUIET=0

NO_TRACE_MAKE的值为make

所以下面的代码执行的命令就是:

OPENWRT_BUILD= QUIET=0 make -r -s prereq

即去执行prereq这个目标了

233 %::

234     @echo "execute........" $@

235     +$(PREP_MK) $(NO_TRACE_MAKE) -r -s prereq

**c)**prereq目标也在toplevel.mk中定义了

213 prereq:: prepare-tmpinfo .config

214     +$(NO_TRACE_MAKE) -r -s $@

prereq 目标进一步依赖prepare-tmpinfo这个目标

**d)**prepare-tmpinfo目标也在toplevel.mk中定义了

 76 prepare-tmpinfo:FORCE

 79     +$(MAKE) -r -s staging_dir/host/.prereq-build $(PREP_MK)

 80     mkdir -p tmp/info

 81     $(_SINGLE)$(NO_TRACE_MAKE) -j1 -r -s -f include/scan.mk SCAN_TARGET="packageinfo" SCAN_DIR="package" SCAN_NAME="    package" SCAN_DEPTH=5 SCAN_EXTRA=""

首先执行了.prereq-build这个目标

然后执行了include/scan.mk文件，它里面有默认的目标

**e)**包含了动态生成的mk文件

100 -include $(TMP_DIR)/info/.files-$(SCAN_TARGET).mk

TMP_DIR=./tmp

SCAN_TARGET=packageinfo

所以这儿包含的文件是./tmp/info/.files-packageinfo.mk

**f)**上面包含的mk文件是一个目标，是这个目标触发了相应的动作

 45 debug1:

 46     @echo "execute debug1...."

 47 debug2:

 48     @echo "execute debug2..."

 84 $(TMP_DIR)/info/.files-$(SCAN_TARGET).mk: debug1 $(FILELIST) debug2

执行发现是FILELIST目标触发了

**g****)**FILELIST的定义

 79 $(FILELIST): $(OVERRIDELIST)

**h)**OVERRIDELIST目标如下

 68 $(OVERRIDELIST):

 69     @echo "execute OVERRIDELIST target="$@

 70     rm -f $(TMP_DIR)/info/.overrides-$(SCAN_TARGET)-*

 71     touch $@

它就是要创建的文件

/home/zhoupeng/mtk/openwrt-21.02/tmp/info/.overrides-packageinfo-32662

至此touch文件的流程已经全部搞清楚了。

后面可以继续用此思路去分析后面的流程