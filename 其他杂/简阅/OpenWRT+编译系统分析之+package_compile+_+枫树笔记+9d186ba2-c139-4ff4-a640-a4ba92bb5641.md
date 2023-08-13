## 查找 package/compile

`package/compile`目标没有明确的 Makefile 定义。所以我们考虑通过顶层 Makefile 中 include 进来的 package/Makefile 找到突破口。

该文件中直接定义的只有 cleanup、rootfs-prepare、index 三个目标。文件最后以 package 作为参数调用了 subdir 函数。根据之前文章中关于 subdir 函数作用的分析，我们可以得出结论：任何非直接定义的 package/xxx 目标，都依赖于其特定子目录的对应目标。特定子目录的读取规则参考前文，这里直接列出结论：

- `install`目标依赖于配置了`CONFIG_PACKAGE_xxx`为 y 的包目录

- `prereq`目标依赖于`CONFIG_PACKAGE_xxx`为 y 或者 m 的包目录

- 其他目标依赖于`CONFIG_PACKAGE_xxx`为 y 或者 m 的包目录

## 深入 package / 包名 /

进入到具体的包，每个包的 Makefile 内容都各不一样。但是大体上都包含以下几个部分：

1. `include`顶层的 rules.mk 文件

2. 定义名称、版本、下载地址、依赖等包信息

3. `include`顶层 include/package.mk 文件

4. 定义该软件包的一些非通用的函数（`Package/包名/操作`）。

5. 以包名为参数调用`BuildPackage`函数。

前面几步都没有什么特别的，最后一步的`BuildPackage`函数调用非常关键。该函数定义在前面 include 进来的顶层 include/pacakge.mk 文件中。

## 深入 BuildPackage 函数

定义在顶层 include/package.mk 文件的该函数，内容不多。主要包含：

6. 读取顶层`overlay/*/包名.mk`文件里定义的特殊规则

7. 读取默认的`Package/Default`、`Package/包名`函数以导入软件包的相关变量。

8. 检查必要的变量名是否正确定义。

9. **重要**通过遍历，构建目标规则。

10. 以 $1 作为参数调用`Build/DefaultTargets`函数设置一些默认目标规则。该函数就在本文件中定义

遍历构造规则部分，主要是遍历列表内容作为 target 变量的值，然后调用`BuildTarget/$(target)`。遍历的列表分为集中情况：

11. 当定义了`Package/包名/targets`时，将其作为遍历的内容。

12. 否则检查是否存在`PKG_TARGETS`变量，如果有，则将其作为遍历内容。

13. 否则将`ipkg`作为遍历的内容，如果 *CONFIG_DEBUG_DIR* 变量设置的话，将 debug 也添加为遍历的内容。

由此可见，默认情况下就是调用的`BuildTarget/ipkg`函数，该函数定义在`package.mk`前面 include 进来的`include/package-ipkg.mk`文件中。

`Build/DefaultTargets`函数主要定义了 prepare、configure、dist、distclean 这些准备性的目标，及其关联的目标 stamp 文件目标。

`BuildTarget/ipkg`函数定义了 compile、install 两个重要的目标，及其关联的依赖目标。需要注意的这两个目标定义，在`Package/包名/install`函数有定义的前提下才有效。而这个函数必须要自己定义。

所以，执行 package/compile 实质上执行的就是 include/package-ipkg.mk 中定义的 compile 目标。

## package / 包名 / compile 的依赖分析

每个软件包的 compile 目标，都依赖于`IPKG_包名`、`$(STAGING_DIR_ROOT)/stamp/.$(1)_installed`两个目标。前者主要是编译打包成 ipkg。后者主要调用`Package/包名/install`和`Package/包名/install_lib`两个方法，将软件包安装到`STAGING_DIR_ROOT`（`staging_dir/target-mips_uClibc-0.9.30.1/root-wndr4500v3/`）中。

`IPKG_包名`这个目标的执行体主要包括三个功能：

- 生成 ipkg 所需要的软件包的元数据

- 调用`Package/包名/install`安装软件包到临时目录`build_dir/target-mips_uClibc-0.9.30.1/包名/ipkg-wndr4500v3/包名`

- 把临时目录、元数据打包成 ipkg 格式的软件包，放在`bin/packages/wndr4500v3_uClibc-0.9.30.1/`。

`IPKG_包名`同时依赖于`$(STAMP_BUILT)`目标，该目标定义在 include/package.mk 中。

`$(STAMP_BUILT)`的执行体，主要调用`Build/Compile`、`Build/Install`两个函数，以及相关的 Hooks。这两个函数分别是等价于在 include/pacakge-defaults.mk 中定义的`Build/Compile/Default`、`Build/Install/Default`。

`$(STAMP_BUILT)`依赖于`$(STAMP_CONFIGURED)`。类似地，这个目标调用的是`Build/Configure/Default`。并依赖于`$(STAMP_PREPARED)`目标，这个目标同样类似的调用的是`Build/Prepare/Default`。

上面被最终调用的，定义在 include/package-defaults.mk 中的默认目标分别是：

- `Build/Prepare/Default`：调用`PKG_UNPACK`解压代码并调用`Build/Patch`打补丁

- `Build/Configure/Default`：带参数执行默认的`./configure`

- `Build/Compile/Default`：带参数执行默认的`make`

- `Build/Install/Default`：带参数执行默认的`make install`

## package / 包名 / install

该目标依赖于`IPKG_包名`目标，也就是说他也需要先将软件包打包成 ipkg 格式。该目标的执行体最简单，直接调用 ipkg 命令安装打包好的 ipkg 文件。需要注意的是 ipkg 命令本身设置了几个环境变量：

- `IPKG_TMP`安装所需临时目录，值为`tmp/ipkg`

- `IPKG_INSTROOT`安装目录，值为`build_dir/target-mips_uClibc-0.9.30.1/root-wndr4500v3/`

- `IPKG_CONF_DIR`配置目录，值为`staging_dir/target-mips_uClibc-0.9.30.1/etc`

- `IPKG_OFFLINE_ROOT`离线安装目录，值为`build_dir/target-mips_uClibc-0.9.30.1/root-wndr4500v3`

