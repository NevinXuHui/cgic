## 查找 target/install

该目标主要用于安装 target 系统。但是搜索代码可以发现，该目标没有任何 Makefile 直接、明确的定义过。那么该目标是怎么执行的呢？

从顶层 Makefile 我们可以看到有`include target/Makefile`指令。所以多半这个目标应该和 target/Makefile 有关系了。而打开 target/Makefile 你会发现，除了一堆变量定义，最后就是将 target 目录名作为 $1 参数调用了之前文章中提到的 subdir 函数。

按照之前文章中的解析，subdir 函数肯定定义了`$1/install`也就是 target/instal 目标，该目标没有执行体，只有依赖目标。由于 target/Makefile 中存在 target/builddirs-install 变量，根据前面的解析，其变量值就是 target/install 的依赖目标。

target/builddirs-install 的内容第一个就是写死的 linux。其次，如果定义了 CONFIG_SDK 那么还包含 sdk，如果定义了 CONFIG_IB，还包含 imagebuilder。

所以综合起来，执行 target/install，实质就是执行其依赖 target/linux/install。而根据前面的解析，target/linux/install 的执行体，就是进入到 target 下的 linux / 子目录，执行 install 目标。

## 深入 target/linux 子目录

该目录下的 Makefile 非常简单，直接定义了 install 这个目标。依赖 FORCE 这个伪目标，表示每次都必须执行。执行体也只有一行，就是进入到`BOARD`这个变量定义的子目录下，执行 install 目标。

那么`BOARD`在哪儿定义的呢？跟踪代码容易发现，该变量定义在顶层目录的 rules.mk 文件，值大概就是`CONFIG_TARGET_BOARD`变量。这个变量就不用说了，定义在配置文件. config 中。针对本文所用的 WNDR4300v2 而言，该变量的值就是`wndr4500v3`（擦，竟然不是 wndr4300v2，Netgear 也是够懒的）。

OK，那么接下来 make 就会进入到 target/linux 目录的 wndr4500v3 子目录了。

## 深入 target/linux/wndr4500v3

和 target/Makefile 的尿性一样，wndr4500v3 目录中的 Makefile，特么也没有定义任何目标，只是在文件末尾调用了 BuildGitTarget 函数。该函数定义在哪儿呢？答案是顶层目录下 include/target.mk 文件。

这个文件更奇葩了。的确是有 BuildGitTarget 的定义。一个是当`DUMP`变量为 1 时，该函数等价于`BuildTargets/DumpCurrent`。一个是当`TARGET_BUILD`变量为 1 时，该函数就是直接等价于`BuildGitKernel`。

由于调用我们的 targe/linux/Makefile 文件中，明确通过 export 定义了`TARGET_BUILD`为 1。加上根据经验猜测，`BuildTargets/DumpCurrent`并不会真正 Build，只是将当前已经 Built 的显示出来而已。所以我们可以直接认为`BuildGitTarget`就等价于`BuildGitKernel`。

那么`BuildGitKernel`在哪儿定义的呢？答案就是顶层目录下的 include/kernel-build.mk 文件中。该文件就是在`BuildGitKernel`赋值给`BuildGitTarget`前，通过`include`指令明确引用的。

从 include/kernel-build.mk 文件中，很容易看到，`BuildGitTarget`函数中，定义了一个`install`目标，由于是 target/linux/wndr4500v3/Makefile 中调用的，所以 target/linux/wndr4500v3/Makefile 中`install`目标，实际上也就是该目标。那么该目标的具体内容是什么呢？

首先，该目标依赖于 *$(LINUX_DIR)/.image * 目标。其执行体也很简单，把 TARGET_BUILD 变量的值清空后，进入到 image 子目录，执行 compile、install 两个目标。

先说依赖，该依赖目标同样也是在`BuildGitKernel`函数中定义的，主要调用了`Kernel/CompileImage`函数。该函数也在该文件中定义，直接调用`Kernel/CompileImage/Default`。该函数定义在顶层目录的 include/kernel-default.mk 文件中。主要干了两件事，一是编译内核。一是将内核通过 objcopy 打包成 vmlinux。

再说执行体，执行体就是进入 image 子目录，执行 compile 和 install 两个目标。

## 深入 target/linux/wndr4500v3/image

在目录下执行 compile 和 install 两个目标，就要先看看该目录下的 Makefile 了。不错，又是一个更坑爹的货。照样没有直接定义目标，照样在最后调用了一个`BuildImage`的函数。是的，通过搜索代码很容易发现，这个函数定义在顶层目录下的 include/image.mk 中。

打开该文件发现，根据`IB`变量的不同，`compile`和`install`目标的定义也不同。`IB`变量主要当使用 ImageBuilder 制作镜像时定义（别问我为什么知道，我真的是凭感觉猜的），其他情况未定义。所以：

- 对于 compile 目标，其依赖是`compile-targets`，执行体调用`Build/Compile`函数。这两个函数实际上都没有定义。所以该目标什么都没做。（注意 include/package.mk 中定义了`Build/Compile`函数，但那是 package 的默认编译函数，和这里的无关）

- 对于 install 目标，其以来是 compile、install-targets（该目标依赖和执行体没有，可以忽略），执行体依次调用

  - `Image/Prepare`

  - `Image/mkfs/prepare`

  - `Image/BuildKernel`

  - `Image/mkfs/jffs2`

  - `Image/mkfs/squashfs`

  - `Image/mkfs/tgz`

  - `Image/mkfs/cpiogz`

  - `Image/mkfs/ext2`

  - `Image/mkfs/iso`

  - `Image/Checksum` (定义在 include/image.mk) 这一系列目标中，除了`Image/Prepare`和`Image/BuildKernel`两个目标和具体的平台相关，所以就在 target/linux/wndr4500v3/image/Makefile 中定义。。其他的都定义在顶层目录下的 include/image.mk 中

## 总结

*target/xxx* 目标，通过层层嵌套，最终执行的是 *target/linux/wndr4500v3 / 中的* xxx * 目标。

target/compile 的执行流程就是：

1. 通过`Kernel/Configure`配置内核，依赖 FORCE 每次都执行

2. 通过`Kernel/CompileModules`编译内核模块，依赖 FORCE 每次都执行

3. 进入到 images 目录执行 compile，本质上没做什么。

target/install 的执行流程就是：

4. 通过`Kernel/Configure`配置内核，依赖 FORCE 每次都执行

5. 通过`Kernel/CompileImage`编译内核，依赖 FORCE 每次都执行

6. 进入到 images 目录执行 install 和 compile（compile 本质上没做什么）。

其中，`Kernel/CompileModules`和`Kernel/CompileImage`定义在顶层目录下的 include/kernel-defaults.mk 中。

