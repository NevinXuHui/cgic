# 一、新建补丁文件

## 1. 准备内核源码树

使用如下命令

```Plain Text
make target/linux/clean V=s QUILT=1
make targe/linux/prepare V=s QUILT=1

```

## 2. 进入 kernel 源码树目录

```Plain Text
/OpenWrt/LS1046A-19.07/build_dir/target-aarch64_generic_glibc/linux-layerscape_armv8_64b/linux-4.14.200$ ls
arch   certs    CREDITS  Documentation  firmware  include  ipc     Kconfig  lib          Makefile  net      README   scripts   sound  usr
block  COPYING  crypto   drivers        fs        init     Kbuild  kernel   MAINTAINERS  mm        patches  samples  security  tools  virt

```

## 3. 更新内核补丁文件

```Plain Text
linux-4.14.200$ quilt push -a

Applying patch generic-backport/010-Kbuild-don-t-hardcode-path-to-awk-in-scripts-ld-vers.patch
patching file scripts/ld-version.sh

Applying patch generic-backport/011-kbuild-export-SUBARCH.patch
patching file Makefile

Applying patch generic-backport/012-kbuild-add-macro-for-controlling-warnings-to-linux-c.patch
patching file include/linux/compiler-gcc.h
patching file include/linux/compiler_types.h

Applying patch generic-backport/013-disable-Wattribute-alias-warning-for-SYSCALL_DEFINEx.patch
patching file include/linux/compat.h

```

## 4. 创建新 patch、修改内核驱动

以修改 SIM8200 的 5G 模块驱动为例

```Plain Text
# 查看最新补丁文件号
linux-4.14.200$ quilt top 
platform/825-tmu-support-layerscape.patch

# 创建新 '补丁文件'
linux-4.14.200$ quilt new platform/826-ls10xx-usb-serial-option.patch

# 添加补丁文件、修订的文件
linux-4.14.200$ quilt add drivers/usb/serial/option.c

# 编辑文件、增删改的内容都会记录近 补丁文件中,编辑后直接保存退出。
linux-4.14.200$ vim drivers/usb/serial/option.c 补充修改内容

# 查看补丁文件内容
linux-4.14.200$ quilt diff
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -85,6 +85,7 @@ static void option_instat_callback(struc
 #define HUAWEI_PRODUCT_K3765                   0x1465
 #define HUAWEI_PRODUCT_K4605                   0x14C6
 #define HUAWEI_PRODUCT_E173S6                  0x1C07
+#define HUAWEI_PRODUCT_ME906S                  0x15c1
 
 #define QUANTA_VENDOR_ID                       0x0408
 #define QUANTA_PRODUCT_Q101                    0xEA02
@@ -348,6 +349,7 @@ static void option_instat_callback(struc
 
 #define ALINK_VENDOR_ID                        0x1e0e
 #define SIMCOM_PRODUCT_SIM7100E                0x9001 /* Yes, ALINK_VENDOR_ID */
+#define SIMCOM_PRODUCT_SIM8200                 0x9011 /* SIMCOM 7600,8200 serial */
 #define ALINK_PRODUCT_PH300                    0x9100
 #define ALINK_PRODUCT_3GU                      0x9200

```

## 5. 更新 patch 文件

此操作等于保存 新生成的 patch 文件。

```Plain Text
linux-4.14.200$ quilt refresh 
Refreshed patch 1000-ls10xx-usb-serial-option.patch

```

## 6. 保存 patch 文件到 buildroot

```Plain Text
linux-4.14.200$ cd ../../../../
robot@ubuntu:~/OpenWrt/LS1046A-19.07$ make target/linux/update V=s

make[1]: Entering directory '/home/robot/OpenWrt/LS1046A-19.07'
make[2]: Entering directory '/home/robot/OpenWrt/LS1046A-19.07/target/linux'
make[3]: Entering directory '/home/robot/OpenWrt/LS1046A-19.07/target/linux/layerscape'
if [ -s "/home/robot/OpenWrt/LS1046A-19.07/build_dir/target-aarch64_generic_glibc/linux-layerscape_armv8_64b/linux-4.14.200/patches/series" ]; then (cd "/home/robot/OpenWrt/LS1046A-19.07/build_dir/target-aarch64_generic_glibc/linux-layerscape_armv8_64b/linux-4.14.200"; if quilt --quiltrc=- next >/dev/null 2>&1; then quilt --quiltrc=- push -a; else quilt --quiltrc=- top >/dev/null 2>&1; fi ); fi
'/home/robot/OpenWrt/LS1046A-19.07/build_dir/target-aarch64_generic_glibc/linux-layerscape_armv8_64b/linux-4.14.200/patches/platform/825-tmu-support-layerscape.patch' -> '/home/robot/OpenWrt/LS1046A-19.07/target/linux/layerscape/patches-4.14/825-tmu-support-layerscape.patch'
# 新产生补丁包路径及名称
'/home/robot/OpenWrt/LS1046A-19.07/build_dir/target-aarch64_generic_glibc/linux-layerscape_armv8_64b/linux-4.14.200/patches/platform/826-ls10xx-usb-serial-option.patch' -> '/home/robot/OpenWrt/LS1046A-19.07/target/linux/layerscape/patches-4.14/***826-ls10xx-usb-serial-option.patch***'
make[3]: Leaving directory '/home/robot/OpenWrt/LS1046A-19.07/target/linux/layerscape'
make[2]: Leaving directory '/home/robot/OpenWrt/LS1046A-19.07/target/linux'

```

# 二、修改补丁文件

当文件需要再次修改文件时，如何修改补丁文件呢？如下所示，文本中有注释描述。

```Plain Text
# (1). 进入内核目录、查看需要修改的补丁文件
linux-4.14.200$ quilt top

# (2). 更换不同的补丁文件、pop 补丁文件
linux-4.14.200$ quilt pop  //弹出最后一个补丁文件
File series fully applied, ends at patch platform/826-ls10xx-usb-serial-option.patch

# (3). 更换不同的补丁文件、push 补丁文件
linux-4.14.200$ quilt push  

# (4). 直接编辑文件内容、增设改内容都会记录到补丁文件
linux-4.14.200$ vim drivers/usb/serial/option.c 

# (5). 查看补丁文件更新内容        
linux-4.14.200$ quilt diff
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -85,6 +85,7 @@ static void option_instat_callback(struc
 #define HUAWEI_PRODUCT_K3765                   0x1465
 #define HUAWEI_PRODUCT_K4605                   0x14C6
 #define HUAWEI_PRODUCT_E173S6                  0x1C07
+#define HUAWEI_PRODUCT_ME906S                  0x15C1
 #define QUANTA_VENDOR_ID                       0x0408
 #define QUANTA_PRODUCT_Q101                    0xEA02
@@ -348,6 +349,7 @@ static void option_instat_callback(struc
 #define ALINK_VENDOR_ID                                0x1e0e
 #define SIMCOM_PRODUCT_SIM7100E                        0x9001 /* Yes, ALINK_VENDOR_ID */
+#define SIMCOM_PRODUCT_SIM8200      0x9011 /* simcom 7600 & 8200 product id */
 #define ALINK_PRODUCT_PH300                    0x9100
 #define ALINK_PRODUCT_3GU                      0x9200
@@ -628,6 +630,8 @@ static const struct usb_device_id option
          .driver_info = RSVD(1) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0xff, 0xff),
          .driver_info = RSVD(1) | RSVD(2) },
+  { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ME906S, 0xff, 0xff, 0xff),
+    .driver_info = RSVD(1) | RSVD(2) },    
        { USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0xff, 0xff) },
        { USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x01) },
        { USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x02) },
@@ -1824,7 +1828,7 @@ static const struct usb_device_id option
        { USB_DEVICE(ALINK_VENDOR_ID, SIMCOM_PRODUCT_SIM7100E),
          .driver_info = RSVD(5) | RSVD(6) },
        { USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9003, 0xff) },   /* Simcom SIM7500/SIM7600 MBIM mode */
-       { USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9011, 0xff),     /* Simcom SIM7500/SIM7600 RNDIS mode */
+       { USB_DEVICE_INTERFACE_CLASS(0x1e0e, SIMCOM_PRODUCT_SIM8200, 0xff),     /* Simcom SIM7500/SIM7600 RNDIS mode */
          .driver_info = RSVD(7) },
        { USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9205, 0xff) },   /* Simcom SIM7070/SIM7080/SIM7090 AT+ECM mode */
        { USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9206, 0xff) },   /* Simcom SIM7070/SIM7080/SIM7090 AT-only mode */

# (6) 更新、保持补丁文件
linux-4.14.200$ quilt refresh 
Warning: trailing whitespace in line 634 of drivers/usb/serial/option.c
Refreshed patch platform/826-ls10xx-usb-serial-option.patch


# (7) 更新补丁文件内核补丁包中。 目录:target/linux/layerscape
/OpenWrt/LS1046A-19.07$ make target/linux/refresh V=s
make[1]: Entering directory '/home/robot/OpenWrt/LS1046A-19.07'
make[2]: Entering directory '/home/robot/OpenWrt/LS1046A-19.07/target/linux'
make[3]: Entering directory '/home/robot/OpenWrt/LS1046A-19.07/target/linux/layerscape'
Applying patch generic-backport/010-Kbuild-don-t-hardcode-path-to-awk-in-scripts-ld-vers.patch
patching file scripts/ld-version.sh
'/home/robot/OpenWrt/LS1046A-19.07/build_dir/target-aarch64_generic_glibc/linux-layerscape_armv8_64b/linux-4.14.200/patches/platform/826-ls10xx-usb-serial-option.patch' -> '/home/robot/OpenWrt/LS1046A-19.07/target/linux/layerscape/patches-4.14/826-ls10xx-usb-serial-option.patch'
make[3]: Leaving directory '/home/robot/OpenWrt/LS1046A-19.07/target/linux/layerscape'
make[2]: Leaving directory '/home/robot/OpenWrt/LS1046A-19.07/target/linux'
time: target/linux/refresh#51.70#18.13#65.19


```

# 三、 编译内核、验证修改内容

```Plain Text
robot@ubuntu:~/OpenWrt/LS1046A-19.07$ make target/linux/compile
time: target/linux/prereq#0.08#0.01#0.10
 make[1] target/linux/compile
 make[2] -C target/linux compile
 
robot@ubuntu:~/OpenWrt/LS1046A-19.07$ make target/linux/install
 make[1] target/linux/install
 make[2] -C target/linux install

```

## 8. 验证 5G 驱动程序

```Plain Text
在这里插入代码片

```

