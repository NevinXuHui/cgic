# Openwrt开源代码编译流程理解

# 开源代码编译流程理解

# 引言

本文主要总结编译开源包的流程，做到理解整个开源代码的编译流程后，可以做到只编译特定的模块；修改后可以快速编译。

# 1) 找到分析问题的口子

include/depends.mk的”need to rebuild”分支增加这样的代码：

read -p need-to-rebuild;

## 1.1)获取编译命令

设置完后执行make -j1 V=s

得到如下结果：

1151 4603 make -j1 V=s

1670 1151 /bin/sh -c _limit=`ulimit -n`; [ "$_limit" = "unlimited" -o "$_limit" -ge 1024 ] || ulimit -n 1024; umask 022; make -w -r world

1672 1670 make -w -r world

执行的编译目标是package/compile

7426 1672 make package/compile

7449 7426 bash -c /home/zhoupeng/mtk/openwrt-21.02-orig/scripts/time.pl "time: package/libs/libjson-c/host-compile" make -w -r -C package/libs/libjson-c BUILD_SUBDIR="package/libs/libjson-c" BUILD_VARIANT="" host-compile || ?( printf "%s\n" " ERROR: package/libs/libjson-c [host] failed to build."; exit 1;)

7450 7449 perl /home/zhoupeng/mtk/openwrt-21.02-orig/scripts/time.pl time: package/libs/libjson-c/host-compile make -w -r -C package/libs/libjson-c BUILD_SUBDIR=package/libs/libjson-c BUILD_VARIANT= host-compile

切换到package/libs/libjson-c目标执行编译， 编译目标是host-compile

7451 7450 make -w -r -C package/libs/libjson-c BUILD_SUBDIR=package/libs/libjson-c BUILD_VARIANT= host-compile

总结:

a)make world出发执行到了make package/compile命令。

b)make package/compile命令下去编译各个模块，如这儿的libjson-c模块。

## 1.2)从world目标查找编译的点

### 1.2.1)Makefile中定义了world的依赖

126 world: prepare $(target/stamp-compile) stopworld1 $(package/stamp-compile) stopword2 $(package/stamp-install) $(target/stamp-install) FORCE

调试发现$(package/stamp-compile)这个目标触发，它的值如下：

package/stamp-compile=/home/zhoupeng/mtk/openwrt-21.02-orig/staging_dir/target-aarch64_cortex-a53_musl/stamp/.package_compile

.package_compile的依赖规则如下:

/home/zhoupeng/mtk/openwrt-21.02-orig/staging_dir/target-aarch64_cortex-a53_musl/stamp/.package_compile:

/home/zhoupeng/mtk/openwrt-21.02-orig/staging_dir/target-aarch64_cortex-a53_musl/stamp/.target_compile /home/zhoupeng/mtk/openwrt-21.02-orig/staging_dir/target-aarch64_cortex-a53_musl/stamp/.package_cleanup

总结：

world触发了$(package/stamp-compile)这个目标

package/stamp-compile这个目标依赖stamp/.targt_compile这个目标，stamp/.target_compile目标触发了target/linux的编译. 需要理解的是target/inux只是触发了内核的编译，并不触发开源代码的编译，这个我们之前有分析过.

### 1.2.2)stamp/.target_compile目标的定义

target/Makefile中有对.target_compile定义

源代码如下：

$(eval $(call stampfile,$(curdir),target,compile,$(TMP_DIR)/.build))

生成的代码如下：

target/stamp-compile:=/home/zhoupeng/mtk/openwrt-21.02-orig/staging_dir/target-aarch64_cortex-a53_musl/stamp/.target_compile

$(target/stamp-compile):

/home/zhoupeng/mtk/openwrt-21.02-orig/tmp/.build /home/zhoupeng/mtk/openwrt-21.02-orig/tmp/.build

@+/home/zhoupeng/mtk/openwrt-21.02-orig/scripts/timestamp.pl -n $(target/stamp-compile) target /home/zhoupeng/mtk/openwrt-21.02-orig/tmp/.build || make --no-print-directory $(target/flags-compile) target/compile

@mkdir -p $$(dirname $(target/stamp-compile))

@touch $(target/stamp-compile)

$(if ,,.SILENT: $(target/stamp-compile))

.PRECIOUS: $(target/stamp-compile) # work around a make bug

target//clean:=target/stamp-compile/clean

target/stamp-compile/clean: FORCE

@rm -f $(target/stamp-compile)

总结：

target/stamp-compile就是.target_compile

它最终转换成了make target/compile

### 1.2.3)package_compile目标的定义

target/compile 目标在target/Makefile中调用stampfile函数完成。

因此很容易想到pakcage/Makefile中是否也调用了stampfile函数完成了package/compile的目标生成以及调用。

package/Makefile中有如下代码：

$(eval $(call stampfile,$(curdir),package,compile,$(TMP_DIR)/.build))

展开后的结果如下：

package/stamp-compile:=/home/zhoupeng/mtk/openwrt-21.02-orig/staging_dir/target-aarch64_cortex-a53_musl/stamp/.package_compile

$(package/stamp-compile):/home/zhoupeng/mtk/openwrt-21.02-orig/tmp/.build /home/zhoupeng/mtk/openwrt-21.02-orig/tmp/.build

@+/home/zhoupeng/mtk/openwrt-21.02-orig/scripts/timestamp.pl -n $(package/stamp-compile) package /home/zhoupeng/mtk/openwrt-21.02-orig/tmp/.build || make --no-print-directory $(package/flags-compile) package/compile

@mkdir -p $$(dirname $(package/stamp-compile))

@touch $(package/stamp-compile)

总结：

1.2.1节总world目标对package/stamp-compile目标的依赖触发了package/compile目标的执行。

### 1.2.4) package/compile目标的定义

package/Makefile中有如下定义：

62 ifndef SDK

63 $(curdir)/compile:$(curdir)/system/opkg/host/compile

64 endif

65 $(curdir)/compile: $(curdir)/cryptsetup/host/compile

因为curdir=package

所以63、65行的代码完成了package/compile目标的定义。

这个目标静态定义了对host目标的依赖，还有动态目标的自动生成，它就在package/Makefile中。

代码如下：

$(eval $(call subdir,$(curdir)))

如果加上如下调试代码，将会看到下面的动态生成的依赖目标，这个动态生成的依赖目标说明有这么多代码需要编译。

$(info $(call subdir,$(curdir)))

![](https://docimg4.docs.qq.com/image/ojy3VTlyS4GmtW9CrxqZlg.png?w=1877&h=631)

### 1.2.5)package/system/opkg/host/compile目标的定义

该目标也由package/Makefile中的subdir函数完成：

已知curdir=package

$(eval $(call subdir,$(curdir)))

其中的生成代码如下：

package/system/opkg/host/compile: package/libs/libubox/host/compile

@+ /home/zhoupeng/mtk/openwrt-21.02-orig/scripts/time.pl "time: package/system/opkg/host-compile" $(SUBMAKE) -r -C package/system/opkg BUILD_SUBDIR="package/system/opkg" BUILD_VARIANT="" host-compile || ( printf "%s\n" " ERROR: package/system/opkg [host] failed to build."; exit 1;)

总结：

package/compile动态依赖的目标由package/Makefile文件调用$(call subdir,package)代码完成。

它的本质是将开源代码都编译进来。

因此开源代码直接的依赖关系是另外一个关键点，也是openwrt的编译框架实现的核心功能之一。

理解开源代码的依赖动态建立之前先看看libjson-c模块的编译这个具体例子。

# 2) libjson-c的编译

这个代码还是在package/Makefile的subdir函数调用

$(eval $(call subdir,$(curdir)))

1.2.4节已经知道了package/compile目标的定义，可以看到它依赖了package/libs/libjson-c/compile这个目标

![](data:image/svg+xml,%3c%3fxml version='1.0' encoding='UTF-8'%3f%3e %3csvg width='48px' height='48px' viewBox='0 0 48 48' version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'%3e %3ctitle%3eplaceholder_48_image%3c/title%3e %3cg id='%e6%8e%a7%e4%bb%b6' stroke='none' stroke-width='1' fill='none' fill-rule='evenodd'%3e %3cg id='Placeholder%e5%8d%a0%e4%bd%8d%e5%9b%be/%e5%85%83%e7%b4%a0/%e5%9b%be%e7%89%87' fill='%23CBCDD1' fill-rule='nonzero'%3e %3cpath d='M35%2c20 C39.9705627%2c20 44%2c24.0294373 44%2c29 C44%2c33.9705627 39.9705627%2c38 35%2c38 C30.0294373%2c38 26%2c33.9705627 26%2c29 C26%2c24.0294373 30.0294373%2c20 35%2c20 Z M37%2c10 C38.1045695%2c10 39%2c10.8954305 39%2c12 L39.0009157%2c17.6831465 C38.3576249%2c17.4557168 37.6891541%2c17.2815836 37.0008092%2c17.1660527 L37%2c12 L9%2c12 L9%2c29.963 L18.2179386%2c19.6026975 L23.8194981%2c24.6326614 C23.5464713%2c25.3310937 23.3370002%2c26.0613699 23.1981963%2c26.8163786 L18.3760779%2c22.4852107 L9%2c33.022 L9%2c34 L24.0886278%2c34.0011836 C24.4127992%2c34.7072892 24.8034951%2c35.3765123 25.2526901%2c36.0008275 L9%2c36 C7.8954305%2c36 7%2c35.1045695 7%2c34 L7%2c12 C7%2c10.8954305 7.8954305%2c10 9%2c10 L37%2c10 Z M35%2c22 C31.1340068%2c22 28%2c25.1340068 28%2c29 C28%2c32.8659932 31.1340068%2c36 35%2c36 C38.8659932%2c36 42%2c32.8659932 42%2c29 C42%2c25.1340068 38.8659932%2c22 35%2c22 Z M36%2c31 L36%2c33 L34%2c33 L34%2c31 L36%2c31 Z M36%2c25 L36%2c30 L34%2c30 L34%2c25 L36%2c25 Z' id='%e5%bd%a2%e7%8a%b6%e7%bb%93%e5%90%88'%3e%3c/path%3e %3c/g%3e %3c/g%3e %3c/svg%3e)

文件表示时看到的信息如下：

package/compile: package/base-files/compile package/boot/uboot-envtools/compile package/feeds/luci/luci/compile package/feeds/luci/luci-app-firewall/compile package/feeds/luci/luci-app-ksmbd/compile package/feeds/luci/luci-app-opkg/compile package/feeds/luci/luci-base/compile package/feeds/luci/luci-compat/compile package/feeds/luci/luci-lib-base/compile package/feeds/luci/luci-lib-ip/compile package/feeds/luci/luci-lib-jsonc/compile package/feeds/luci/luci-lib-nixio/compile package/feeds/luci/luci-mod-admin-full/compile package/feeds/luci/luci-mod-network/compile package/feeds/luci/luci-mod-status/compile package/feeds/luci/luci-mod-system/compile package/feeds/luci/luci-proto-ipv6/compile package/feeds/luci/luci-proto-ppp/compile package/feeds/luci/luci-theme-bootstrap/compile package/feeds/luci/lucihttp/compile package/feeds/luci/rpcd-mod-luci/compile package/feeds/luci/rpcd-mod-rrdns/compile package/feeds/mtk_openwrt_feed/mii_mgr/compile package/feeds/mtk_openwrt_feed/mtk_factory_rw/compile package/feeds/mtk_openwrt_feed/mtkhnat_util/compile package/feeds/mtk_openwrt_feed/regs/compile package/feeds/mtk_openwrt_feed/switch/compile package/feeds/packages/cgi-io/compile package/feeds/packages/ksmbd/compile package/feeds/packages/ksmbd-tools/compile package/feeds/packages/libcap-ng/compile package/feeds/packages/luasocket/compile package/feeds/packages/miniupnpd/compile package/feeds/packages/wsdd2/compile package/feeds/packages/xl2tpd/compile package/firmware/wireless-regdb/compile package/kernel/gpio-button-hotplug/compile package/kernel/linux/compile package/libs/libjson-c/compile package/libs/libnl/compile package/libs/libnl-tiny/compile package/libs/libpcap/compile package/libs/libubox/compile package/libs/openssl/compile package/libs/toolchain/compile package/libs/uclient/compile package/libs/ustream-ssl/compile package/libs/wolfssl/compile package/mtk/applications/1905daemon/compile package/mtk/applications/8021xd/compile package/mtk/applications/ated_ext/compile package/mtk/applications/datconf/compile package/mtk/applications/fwdd/compile package/mtk/applications/libmapd/compile package/mtk/applications/luci-app-mtk/compile package/mtk/applications/mapd/compile package/mtk/applications/mtk-base-files/compile package/mtk/applications/sigma_daemon/compile package/mtk/applications/sigma_dut_v9.0.0/compile package/mtk/applications/wappd/compile package/mtk/applications/wificonf/compile package/mtk/drivers/connectivity/conninfra/compile package/mtk/drivers/mapfilter/compile package/mtk/drivers/mt_wifi/compile package/mtk/drivers/mtfwd/compile package/mtk/drivers/mtqos/compile package/mtk/drivers/warp/compile package/mtk/drivers/wifi-profile/compile package/network/config/firewall/compile package/network/config/netifd/compile package/network/config/swconfig/compile package/network/ipv6/odhcp6c/compile package/network/services/dnsmasq/compile package/network/services/dropbear/compile package/network/services/odhcpd/compile package/network/services/omcproxy/compile package/network/services/ppp/compile package/network/services/uhttpd/compile package/network/utils/ethtool/compile package/network/utils/iproute2/compile package/network/utils/iptables/compile package/network/utils/iw/compile package/network/utils/iwinfo/compile package/network/utils/resolveip/compile package/network/utils/tcpdump/compile package/network/utils/wireless-tools/compile package/system/ca-certificates/compile package/system/fstools/compile package/system/fwtool/compile package/system/mtd/compile package/system/openwrt-keyring/compile package/system/opkg/compile package/system/procd/compile package/system/rpcd/compile package/system/ubox/compile package/system/ubus/compile package/system/uci/compile package/system/urandom-seed/compile package/system/urngd/compile package/system/usign/compile package/utils/busybox/compile package/utils/e2fsprogs/compile package/utils/f2fs-tools/compile package/utils/jsonfilter/compile package/utils/lua/compile package/utils/mtd-utils/compile package/utils/util-linux/compile

package/libs/libjson-c/compile这个目标也是在subdir这个函数中完成定义：

部分生成的代码如下($(info $(call subdir,package))命令就可以得到)：

package/libs/libjson-c/host/compile:

@+ /home/zhoupeng/mtk/openwrt-21.02-orig/scripts/time.pl "time: package/libs/libjson-c/host-compile" $(SUBMAKE) -r -C package/libs/libjson-c BUILD_SUBDIR="package/libs/libjson-c" BUILD_VARIANT="" host-compile || ( printf "%s\n" " ERROR: package/libs/libjson-c [host] failed to build."; exit 1;)

package/libjson-c/host/compile: package/libs/libjson-c/host/compile

从上面的目标来看，它切换到package/libs/libjson-c目录去执行host-compile目标了

总结：

开源代码的编译都是通过package/compile这个目标触发的。

package/compile这个目标依赖了一堆开源模块，这些开源模块由$(call subdir,package)代码生成，为什么能生成这样的目标依赖需要进一步理解。

# 3) package/compile依赖目标的动态生成理解

## 3.1）subdir函数

这一切都和subdir函数强相关，再一次理解这个强大的函数

### 3.1.1)package/compile为什么依赖这么多目标

现在来看看是什么原因

体现这个原因的关键代码如下，通过两个for循环完成这些动态目标的生成，包括这些动态目标本身实现规则的生成。

功能十分强大，值得研究清楚。

60 $(foreach bd,$($(1)/builddirs),

61 $(call warn,$(1),d,BD $(1)/$(bd))

62 $(foreach target,$(SUBTARGETS) $($(1)/subtargets),

69 $(call warn_eval,$(1)/$(bd),t,T,$(1)/$(bd)/$(target): $(if $(NO_DEPS)$(QUILT),,$($(1)/$(bd)/ $(target)) $(call $(1)//$(target),$(1)/$(bd))))

...

第一个循环变化builddirs, 当$(1)=package时，它就是package/builddirs

第二个循环遍历SUBTARGETS这个变量，package/subtargets这个值为空，不用关注。

已知SUBTARGETS的值为：

SUBTARGETS=clean download prepare compile update refresh prereq dist distcheck configure check check-depends install-image clean-linux

builddirs的值为：

builddirs=base-files boot/arm-trusted-firmware-bcm63xx boot/arm-trusted-firmware-mediatek boot/arm-trusted-firmware-mvebu boot/arm-trusted-firmware-rockchip boot/arm-trusted-firmware-sunxi boot/arm-trusted-firmware-tools boot/at91bootstrap boot/fconfig boot/grub2 boot/imx-bootlets boot/kexec-tools boot/kobs-ng boot/mt7623n-preloader boot/tfa-layerscape boot/uboot-at91 boot/uboot-bcm4908 boot/uboot-envtools boot/uboot-fritz4040 boot/uboot-imx6 boot/uboot-kirkwood boot/uboot-lantiq boot/uboot-layerscape boot/uboot-mediatek boot/uboot-mvebu boot/uboot-mxs boot/uboot-omap boot/uboot-oxnas boot/uboot-ramips boot/uboot-rockchip boot/uboot-sunxi boot/uboot-tegra boot/uboot-zynq devel/binutils devel/gdb devel/perf devel/strace devel/trace-cmd devel/valgrind feeds/luci/csstidy feeds/luci/luci feeds/luci/luci-app-acl feeds/luci/luci-app-acme feeds/luci/luci-app-adblock feeds/luci/luci-app-advanced-reboot feeds/luci/luci-app-ahcp feeds/luci/luci-app-aria2 feeds/luci/luci-app-attendedsysupgrade feeds/luci/luci-app-babeld feeds/luci/luci-app-banip feeds/luci/luci-app-bcp38 feeds/luci/luci-app-bmx7 feeds/luci/luci-app-clamav feeds/luci/luci-app-commands feeds/luci/luci-app-coovachilli feeds/luci/luci-app-cshark feeds/luci/luci-app-dawn feeds/luci/luci-app-dcwapd feeds/luci/luci-app-ddns feeds/luci/luci-app-diag-core feeds/luci/luci-app-dnscrypt-proxy feeds/luci/luci-app-dockerman feeds/luci/luci-app-dump1090 feeds/luci/luci-app-dynapoint feeds/luci/luci-app-eoip feeds/luci/luci-app-firewall feeds/luci/luci-app-frpc feeds/luci/luci-app-frps feeds/luci/luci-app-fwknopd feeds/luci/luci-app-hd-idle feeds/luci/luci-app-https-dns-proxy feeds/luci/luci-app-ksmbd feeds/luci/luci-app-ledtrig-rssi feeds/luci/luci-app-ledtrig-switch feeds/luci/luci-app-ledtrig-usbport feeds/luci/luci-app-ltqtapi feeds/luci/luci-app-lxc feeds/luci/luci-app-minidlna feeds/luci/luci-app-mjpg-streamer feeds/luci/luci-app-mosquitto feeds/luci/luci-app-mwan3 feeds/luci/luci-app-nextdns feeds/luci/luci-app-nft-qos feeds/luci/luci-app-nlbwmon feeds/luci/luci-app-ntpc feeds/luci/luci-app-nut feeds/luci/luci-app-ocserv feeds/luci/luci-app-olsr feeds/luci/luci-app-olsr-services feeds/luci/luci-app-olsr-viz feeds/luci/luci-app-omcproxy feeds/luci/luci-app-openvpn feeds/luci/luci-app-opkg feeds/luci/luci-app-p910nd feeds/luci/luci-app-pagekitec feeds/luci/luci-app-polipo feeds/luci/luci-app-privoxy feeds/luci/luci-app-qos feeds/luci/luci-app-radicale feeds/luci/luci-app-radicale2 feeds/luci/luci-app-rp-pppoe-server feeds/luci/luci-app-samba4 feeds/luci/luci-app-ser2net feeds/luci/luci-app-shadowsocks-libev feeds/luci/luci-app-shairplay feeds/luci/luci-app-siitwizard feeds/luci/luci-app-simple-adblock feeds/luci/luci-app-smartdns feeds/luci/luci-app-snmpd feeds/luci/luci-app-softether feeds/luci/luci-app-splash feeds/luci/luci-app-sqm feeds/luci/luci-app-squid feeds/luci/luci-app-statistics feeds/luci/luci-app-tinyproxy feeds/luci/luci-app-transmission feeds/luci/luci-app-travelmate feeds/luci/luci-app-ttyd feeds/luci/luci-app-udpxy feeds/luci/luci-app-uhttpd feeds/luci/luci-app-unbound feeds/luci/luci-app-upnp feeds/luci/luci-app-vnstat feeds/luci/luci-app-vnstat2 feeds/luci/luci-app-vpn-policy-routing feeds/luci/luci-app-vpnbypass feeds/luci/luci-app-watchcat feeds/luci/luci-app-wifischedule feeds/luci/luci-app-wireguard feeds/luci/luci-app-wol feeds/luci/luci-app-xinetd feeds/luci/luci-app-yggdrasil feeds/luci/luci-base feeds/luci/luci-compat feeds/luci/luci-lib-base feeds/luci/luci-lib-docker feeds/luci/luci-lib-httpclient feeds/luci/luci-lib-httpprotoutils feeds/luci/luci-lib-ip feeds/luci/luci-lib-ipkg feeds/luci/luci-lib-iptparser feeds/luci/luci-lib-json feeds/luci/luci-lib-jsonc feeds/luci/luci-lib-nixio feeds/luci/luci-lib-px5g feeds/luci/luci-lib-rpcc feeds/luci/luci-light feeds/luci/luci-mod-admin-full feeds/luci/luci-mod-admin-mini feeds/luci/luci-mod-battstatus feeds/luci/luci-mod-dashboard feeds/luci/luci-mod-failsafe feeds/luci/luci-mod-network feeds/luci/luci-mod-rpc feeds/luci/luci-mod-status feeds/luci/luci-mod-system feeds/luci/luci-nginx feeds/luci/luci-proto-3g feeds/luci/luci-proto-bonding feeds/luci/luci-proto-gre feeds/luci/luci-proto-hnet feeds/luci/luci-proto-ipip feeds/luci/luci-proto-ipv6 feeds/luci/luci-proto-modemmanager feeds/luci/luci-proto-ncm feeds/luci/luci-proto-openconnect feeds/luci/luci-proto-openfortivpn feeds/luci/luci-proto-ppp feeds/luci/luci-proto-pppossh feeds/luci/luci-proto-qmi feeds/luci/luci-proto-relay feeds/luci/luci-proto-sstp feeds/luci/luci-proto-vpnc feeds/luci/luci-proto-vxlan feeds/luci/luci-proto-wireguard feeds/luci/luci-ssl feeds/luci/luci-ssl-nginx feeds/luci/luci-ssl-openssl feeds/luci/luci-theme-bootstrap feeds/luci/luci-theme-material feeds/luci/luci-theme-openwrt feeds/luci/luci-theme-openwrt-2020 feeds/luci/lucihttp feeds/luci/rpcd-mod-luci feeds/luci/rpcd-mod-rad2-enc feeds/luci/rpcd-mod-rrdns feeds/mtk_openwrt_feed/atenl feeds/mtk_openwrt_feed/mii_mgr feeds/mtk_openwrt_feed/mt76-vendor feeds/mtk_openwrt_feed/mtk_factory_rw feeds/mtk_openwrt_feed/mtk_failsafe feeds/mtk_openwrt_feed/mtkhnat_util feeds/mtk_openwrt_feed/mwctl feeds/mtk_openwrt_feed/regs feeds/mtk_openwrt_feed/switch feeds/packages/2to3 feeds/packages/Flask feeds/packages/Jinja2 feeds/packages/MarkupSafe feeds/packages/Werkzeug feeds/packages/acl feeds/packages/acme feeds/packages/acpica-unix feeds/packages/acpid feeds/packages/acsccid feeds/packages/adblock feeds/packages/addrwatch feeds/packages/adguardhome feeds/packages/afalg_engine feeds/packages/afuse feeds/packages/aggregate feeds/packages/aircrack-ng feeds/packages/airos-dfs-reset feeds/packages/alpine feeds/packages/alsa-lib feeds/packages/alsa-ucm-conf feeds/packages/alsa-utils feeds/packages/announce feeds/packages/antfs feeds/packages/antfs-mount feeds/packages/ap51-flash feeds/packages/apache feeds/packages/apcupsd feeds/packages/apfree-wifidog feeds/packages/apinger feeds/packages/apk feeds/packages/apr feeds/packages/apr-util feeds/packages/aria2 feeds/packages/ariang feeds/packages/arp-scan feeds/packages/asu feeds/packages/at feeds/packages/atftp feeds/packages/atheepmgr feeds/packages/atlas-probe feeds/packages/atlas-sw-probe feeds/packages/atop feeds/packages/attendedsysupgrade-common feeds/packages/attr feeds/packages/auc feeds/packages/audit feeds/packages/augeas feeds/packages/autoconf feeds/packages/automake feeds/packages/autossh feeds/packages/avahi feeds/packages/avrdude feeds/packages/backuppc feeds/packages/bandwidthd feeds/packages/banhosts feeds/packages/banip feeds/packages/bash feeds/packages/bc feeds/packages/bcm27xx-eeprom feeds/packages/bcp38 feeds/packages/bcrypt feeds/packages/beanstalkd feeds/packages/beep feeds/packages/bfdd feeds/packages/bigclown-control-tool feeds/packages/bigclown-firmware-tool feeds/packages/bigclown-gateway feeds/packages/bigclown-mqtt2influxdb feeds/packages/bind feeds/packages/bitlbee feeds/packages/bluelog feeds/packages/bluez feeds/packages/bmon feeds/packages/bmx7-dnsupdate feeds/packages/bogofilter feeds/packages/boinc feeds/packages/bonding feeds/packages/bonnie++ feeds/packages/boost feeds/packages/bottlerocket feeds/packages/bridge-utils feeds/packages/btrfs-progs feeds/packages/bwm-ng feeds/packages/bwping feeds/packages/byobu feeds/packages/c-ares feeds/packages/cache-domains feeds/packages/canutils feeds/packages/ccid feeds/packages/ccrypt feeds/packages/cereal feeds/packages/cgi-io feeds/packages/cgroupfs-mount feeds/packages/chaosvpn feeds/packages/check feeds/packages/checksec feeds/packages/chicken-scheme feeds/packages/chrony feeds/packages/cifs-utils feeds/packages/cjson feeds/packages/clamav feeds/packages/click feeds/packages/click-log feeds/packages/cmdpad feeds/packages/cni feeds/packages/cni-plugins feeds/packages/collectd feeds/packages/confuse feeds/packages/conmon feeds/packages/conntrack-tools feeds/packages/conserver feeds/packages/containerd feeds/packages/coova-chilli feeds/packages/coremark feeds/packages/coreutils feeds/packages/crconf feeds/packages/crelay feeds/packages/crowdsec feeds/packages/crowdsec-firewall-bouncer feeds/packages/crun feeds/packages/cryptsetup feeds/packages/cshark feeds/packages/ctop feeds/packages/curl feeds/packages/cyrus-sasl feeds/packages/czmq feeds/packages/daemonlogger feeds/packages/darkstat feeds/packages/davfs2 feeds/packages/dawn feeds/packages/db47 feeds/packages/dbus feeds/packages/dcstad feeds/packages/dcwapd feeds/packages/ddns-scripts feeds/packages/debian-archive-keyring feeds/packages/debootstrap feeds/packages/dejavu-fonts-ttf feeds/packages/delve feeds/packages/device-observatory feeds/packages/dfu-programmer feeds/packages/dfu-util feeds/packages/dhcp-forwarder feeds/packages/dhcpcd feeds/packages/diffutils feeds/packages/digitemp feeds/packages/django feeds/packages/django-appconf feeds/packages/django-compressor feeds/packages/django-formtools feeds/packages/django-jsonfield feeds/packages/django-jsonfield2 feeds/packages/django-picklefield feeds/packages/django-postoffice feeds/packages/django-ranged-response feeds/packages/django-restframework feeds/packages/django-restframework39 feeds/packages/django-simple-captcha feeds/packages/django-statici18n feeds/packages/django-webpack-loader feeds/packages/django1 feeds/packages/dkjson feeds/packages/dmapd feeds/packages/dmidecode feeds/packages/dmx_usb_module feeds/packages/dnscrypt-proxy feeds/packages/dnscrypt-proxy2 feeds/packages/dnsdist feeds/packages/dnstap feeds/packages/dnstop feeds/packages/docker feeds/packages/docker-compose feeds/packages/dockerd feeds/packages/domoticz feeds/packages/dosfstools feeds/packages/dovecot feeds/packages/dtndht feeds/packages/dumb-init feeds/packages/dump1090 feeds/packages/dvtm feeds/packages/dynapoint feeds/packages/ecdsautils feeds/packages/elektra feeds/packages/emailrelay feeds/packages/eoip feeds/packages/erlang feeds/packages/esniper feeds/packages/espeak feeds/packages/etebase feeds/packages/etherwake feeds/packages/etherwake-nfqueue feeds/packages/evtest feeds/packages/exfatprogs feeds/packages/exim feeds/packages/expat feeds/packages/faad2 feeds/packages/fail2ban feeds/packages/fakeidentd feeds/packages/fakepop feeds/packages/family-dns feeds/packages/fastd feeds/packages/fdk-aac feeds/packages/fdm feeds/packages/ffmpeg feeds/packages/fft-eval feeds/packages/file feeds/packages/findutils feeds/packages/fio feeds/packages/fish feeds/packages/flac feeds/packages/flashrom feeds/packages/flent-tools feeds/packages/flup feeds/packages/fontconfig feeds/packages/foolsm feeds/packages/forked-daapd feeds/packages/fping feeds/packages/freeradius3 feeds/packages/freetype feeds/packages/frp feeds/packages/frr feeds/packages/fswebcam feeds/packages/fuse feeds/packages/fuse3 feeds/packages/fwknop feeds/packages/gammu feeds/packages/gateway-go feeds/packages/gawk feeds/packages/gcc feeds/packages/gdbm feeds/packages/gddrescue feeds/packages/generate-ipv6-address feeds/packages/gerbera feeds/packages/getdns feeds/packages/geth feeds/packages/giflib feeds/packages/git feeds/packages/git-lfs feeds/packages/gitlab-runner feeds/packages/gitolite feeds/packages/gkermit feeds/packages/gkrellmd feeds/packages/gl-mifi-mcu feeds/packages/glib2 feeds/packages/gnunet feeds/packages/gnunet-fuse feeds/packages/gnupg feeds/packages/gnupg2 feeds/packages/gnuplot feeds/packages/gnurl feeds/packages/gnutls feeds/packages/golang feeds/packages/google-authenticator-libpam feeds/packages/gperf feeds/packages/gpgme feeds/packages/gphoto2 feeds/packages/gpsd feeds/packages/gptfdisk feeds/packages/graphicsmagick feeds/packages/grep feeds/packages/greyfix feeds/packages/grilo feeds/packages/grilo-plugins feeds/packages/gst1-libav feeds/packages/gst1-plugins-bad feeds/packages/gst1-plugins-base feeds/packages/gst1-plugins-good feeds/packages/gst1-plugins-ugly feeds/packages/gstreamer1 feeds/packages/gunicorn feeds/packages/gzip feeds/packages/h2o feeds/packages/hamlib feeds/packages/haproxy feeds/packages/haserl feeds/packages/hashdeep feeds/packages/haveged feeds/packages/hcxdumptool feeds/packages/hcxtools feeds/packages/hd-idle feeds/packages/hdparm feeds/packages/hfsprogs feeds/packages/hidapi feeds/packages/hiredis feeds/packages/horst feeds/packages/hplip feeds/packages/hs20 feeds/packages/htop feeds/packages/htpdate feeds/packages/httping feeds/packages/https-dns-proxy feeds/packages/hub-ctrl feeds/packages/hwdata feeds/packages/hwinfo feeds/packages/hwloc feeds/packages/i2c-tools feeds/packages/i2pd feeds/packages/ibrcommon feeds/packages/ibrdtn feeds/packages/ibrdtn-tools feeds/packages/ibrdtnd feeds/packages/icecast feeds/packages/ices feeds/packages/icu feeds/packages/idevicerestore feeds/packages/ifstat feeds/packages/iftop feeds/packages/imagemagick feeds/packages/inadyn feeds/packages/inotify-tools feeds/packages/intltool feeds/packages/io feeds/packages/iodine feeds/packages/iperf feeds/packages/iperf3 feeds/packages/ipfs-http-client feeds/packages/ipmitool feeds/packages/iptraf-ng feeds/packages/iputils feeds/packages/ipvsadm feeds/packages/irqbalance feeds/packages/irssi feeds/packages/isc-dhcp feeds/packages/itsdangerous feeds/packages/joe feeds/packages/jool feeds/packages/jose feeds/packages/jq feeds/packages/json-glib feeds/packages/json4lua feeds/packages/jsoncpp feeds/packages/jupp feeds/packages/kadnode feeds/packages/kcptun feeds/packages/kea feeds/packages/keepalived feeds/packages/keyutils feeds/packages/kismet feeds/packages/klish feeds/packages/kmod feeds/packages/knot feeds/packages/knot-resolver feeds/packages/knxd feeds/packages/kplex feeds/packages/krb5 feeds/packages/ksmbd feeds/packages/ksmbd-tools feeds/packages/lame feeds/packages/lcd4linux feeds/packages/lcdgrilo feeds/packages/lcdproc feeds/packages/lcdringer feeds/packages/ldbus feeds/packages/ldns feeds/packages/leech feeds/packages/leptonica feeds/packages/less feeds/packages/lftp feeds/packages/libaio feeds/packages/libantlr3c feeds/packages/libao feeds/packages/libarchive feeds/packages/libassuan feeds/packages/libatasmart feeds/packages/libcap feeds/packages/libcap-ng feeds/packages/libcbor feeds/packages/libcgroup feeds/packages/libcoap feeds/packages/libconfig feeds/packages/libcups feeds/packages/libdaemon feeds/packages/libdaq feeds/packages/libdaq3 feeds/packages/libdbi feeds/packages/libdbi-drivers feeds/packages/libdcwproto feeds/packages/libdcwsocket feeds/packages/libdmapsharing feeds/packages/libdnet feeds/packages/libdrm feeds/packages/libdvbcsa feeds/packages/libebml feeds/packages/libedit feeds/packages/libesmtp feeds/packages/libestr feeds/packages/libev feeds/packages/libevdev feeds/packages/libevhtp feeds/packages/libexif feeds/packages/libextractor feeds/packages/libfastjson feeds/packages/libffi feeds/packages/libfido2 feeds/packages/libfmt feeds/packages/libfstrm feeds/packages/libftdi feeds/packages/libftdi1 feeds/packages/libgabe feeds/packages/libgcrypt feeds/packages/libgd feeds/packages/libgee feeds/packages/libgpg-error feeds/packages/libgphoto2 feeds/packages/libgpiod feeds/packages/libhttp-parser feeds/packages/libical feeds/packages/libid3tag feeds/packages/libidn feeds/packages/libidn2 feeds/packages/libiio feeds/packages/libimobiledevice feeds/packages/libinput feeds/packages/libirecovery feeds/packages/libjpeg-turbo feeds/packages/libksba feeds/packages/liblo feeds/packages/liblz4 feeds/packages/libmad feeds/packages/libmariadb feeds/packages/libmatroska feeds/packages/libmaxminddb feeds/packages/libmbim feeds/packages/libmcrypt feeds/packages/libmicrohttpd feeds/packages/libmms feeds/packages/libmodbus feeds/packages/libmpdclient feeds/packages/libmpeg2 feeds/packages/libmraa feeds/packages/libnatpmp feeds/packages/libndp feeds/packages/libndpi feeds/packages/libnet-1.2.x feeds/packages/libnetconf2 feeds/packages/libnetfilter-acct feeds/packages/libnetfilter-cthelper feeds/packages/libnetfilter-cttimeout feeds/packages/libnetfilter-log feeds/packages/libnetfilter-queue feeds/packages/libnetwork feeds/packages/libnopoll feeds/packages/libnpupnp feeds/packages/libogg feeds/packages/liboil feeds/packages/liboping feeds/packages/libopusenc feeds/packages/liborcania feeds/packages/libowfat feeds/packages/libp11 feeds/packages/libpam feeds/packages/libpbc feeds/packages/libpciaccess feeds/packages/libpfring feeds/packages/libplist feeds/packages/libpng feeds/packages/libpqxx feeds/packages/libpsl feeds/packages/libqmi feeds/packages/libqrtr-glib feeds/packages/libradcli feeds/packages/libradiotap feeds/packages/libre2 feeds/packages/libredblack feeds/packages/librespeed-cli feeds/packages/librespeed-go feeds/packages/libreswan feeds/packages/librouteros feeds/packages/libroxml feeds/packages/libsamplerate feeds/packages/libsearpc feeds/packages/libseccomp feeds/packages/libshout feeds/packages/libsndfile feeds/packages/libsoc feeds/packages/libsodium feeds/packages/libsoup feeds/packages/libsoxr feeds/packages/libssh feeds/packages/libssh2 feeds/packages/libstrophe feeds/packages/libtalloc feeds/packages/libtasn1 feeds/packages/libtheora feeds/packages/libtins feeds/packages/libtirpc feeds/packages/libtool-bin feeds/packages/libtorrent feeds/packages/libtorrent-rasterbar feeds/packages/libudev-zero feeds/packages/libuecc feeds/packages/libugpio feeds/packages/libuhttpd feeds/packages/libulfius feeds/packages/libunistring feeds/packages/libupm feeds/packages/libupnp feeds/packages/libupnpp feeds/packages/liburcu feeds/packages/liburing feeds/packages/libusb-compat feeds/packages/libusbmuxd feeds/packages/libuv feeds/packages/libuwifi feeds/packages/libuwsc feeds/packages/libv4l feeds/packages/libvorbis feeds/packages/libvorbisidec feeds/packages/libvpx feeds/packages/libwebp feeds/packages/libwebsockets feeds/packages/libwslay feeds/packages/libx264 feeds/packages/libxcrypt feeds/packages/libxerces-c feeds/packages/libxml2 feeds/packages/libxslt feeds/packages/libyaml-cpp feeds/packages/libyang feeds/packages/libyubikey feeds/packages/libzip feeds/packages/lighttpd feeds/packages/linknx feeds/packages/linotify feeds/packages/linuxptp feeds/packages/lksctp-tools feeds/packages/lm-sensors feeds/packages/lmdb feeds/packages/log4cplus feeds/packages/logrotate feeds/packages/lora-gateway-hal feeds/packages/loudmouth feeds/packages/lpc21isp feeds/packages/lpeg feeds/packages/lrzsz feeds/packages/lsof feeds/packages/lttng-modules feeds/packages/lttng-tools feeds/packages/lttng-ust feeds/packages/lua-argparse feeds/packages/lua-bencode feeds/packages/lua-bit32 feeds/packages/lua-cjson feeds/packages/lua-copas feeds/packages/lua-coxpcall feeds/packages/lua-ev feeds/packages/lua-libmodbus feeds/packages/lua-lsqlite3 feeds/packages/lua-lzlib feeds/packages/lua-md5 feeds/packages/lua-mobdebug feeds/packages/lua-mosquitto feeds/packages/lua-openssl feeds/packages/lua-penlight feeds/packages/lua-rings feeds/packages/lua-rs232 feeds/packages/lua-sha2 feeds/packages/lua-wsapi feeds/packages/lua-xavante feeds/packages/luabitop feeds/packages/luaexpat feeds/packages/luafilesystem feeds/packages/luajit feeds/packages/lualanes feeds/packages/luaposix feeds/packages/luarocks feeds/packages/luasec feeds/packages/luasoap feeds/packages/luasocket feeds/packages/luasql feeds/packages/luasrcdiet feeds/packages/luv feeds/packages/lvm2 feeds/packages/lxc feeds/packages/lyaml feeds/packages/lynx feeds/packages/lzmq feeds/packages/lzo feeds/packages/m4 feeds/packages/mac-telnet feeds/packages/maccalc feeds/packages/macchanger feeds/packages/macremapper feeds/packages/madplay feeds/packages/mailsend feeds/packages/make feeds/packages/mariadb feeds/packages/mblaze feeds/packages/mbtools feeds/packages/mbusd feeds/packages/mc feeds/packages/mdnsresponder feeds/packages/memcached feeds/packages/meson feeds/packages/mg feeds/packages/micrond feeds/packages/micropython feeds/packages/micropython-lib feeds/packages/mikrotik-btest feeds/packages/mini_snmpd feeds/packages/minicom feeds/packages/minidlna feeds/packages/miniflux feeds/packages/minisatip feeds/packages/miniupnpc feeds/packages/miniupnpd feeds/packages/minizip feeds/packages/miredo feeds/packages/mjpg-streamer feeds/packages/mksh feeds/packages/mktorrent feeds/packages/mmc-utils feeds/packages/mocp feeds/packages/modemmanager feeds/packages/monit feeds/packages/moreutils feeds/packages/mosh feeds/packages/mosquitto feeds/packages/motion feeds/packages/mpack feeds/packages/mpc feeds/packages/mpd feeds/packages/mpg123 feeds/packages/mrmctl feeds/packages/msgpack-c feeds/packages/msmtp feeds/packages/mstpd feeds/packages/mt-st feeds/packages/mtd-rw feeds/packages/mtdev feeds/packages/mtr feeds/packages/muninlite feeds/packages/mutt feeds/packages/mwan3 feeds/packages/mxml feeds/packages/nacl feeds/packages/nail feeds/packages/nano feeds/packages/nbd feeds/packages/ncdu feeds/packages/ncp feeds/packages/nebula feeds/packages/neon feeds/packages/net-snmp feeds/packages/net-tools feeds/packages/netatalk feeds/packages/netatop feeds/packages/netcat feeds/packages/netdata feeds/packages/netdiscover feeds/packages/netifyd feeds/packages/netopeer2 feeds/packages/netperf feeds/packages/netsniff-ng feeds/packages/netstinky feeds/packages/netwhere feeds/packages/newt feeds/packages/nextdns feeds/packages/nfdump feeds/packages/nfs-kernel-server feeds/packages/nft-qos feeds/packages/nghttp2 feeds/packages/nginx feeds/packages/nginx-util feeds/packages/ngircd feeds/packages/ninja feeds/packages/nlbwmon feeds/packages/nlohmannjson feeds/packages/nmap feeds/packages/nnn feeds/packages/node feeds/packages/node-arduino-firmata feeds/packages/node-cylon feeds/packages/node-hid feeds/packages/node-homebridge feeds/packages/node-javascript-obfuscator feeds/packages/node-serialport feeds/packages/node-serialport-bindings feeds/packages/node-yarn feeds/packages/npth feeds/packages/nsd feeds/packages/nspr feeds/packages/nss feeds/packages/ntfs-3g feeds/packages/ntpclient feeds/packages/ntpd feeds/packages/ntripcaster feeds/packages/ntripclient feeds/packages/ntripserver feeds/packages/numpy feeds/packages/nut feeds/packages/nyx feeds/packages/oath-toolkit feeds/packages/obfs4proxy feeds/packages/oci-runtime-tools feeds/packages/ocserv feeds/packages/oggfwd feeds/packages/ola feeds/packages/oniguruma feeds/packages/onionshare-cli feeds/packages/ooniprobe feeds/packages/oor feeds/packages/open-iscsi feeds/packages/open-isns feeds/packages/open-plc-utils feeds/packages/open-vm-tools feeds/packages/open2300 feeds/packages/openconnect feeds/packages/opendkim feeds/packages/openfortivpn feeds/packages/openldap feeds/packages/openobex feeds/packages/openocd feeds/packages/openpyxl feeds/packages/opensc feeds/packages/openssh feeds/packages/opentracker feeds/packages/openvpn feeds/packages/openvpn-easy-rsa feeds/packages/openvswitch feeds/packages/openwisp-config feeds/packages/openwisp-monitoring feeds/packages/openzwave feeds/packages/opus feeds/packages/opus-tools feeds/packages/opusfile feeds/packages/ostiary feeds/packages/overture feeds/packages/ovn feeds/packages/owfs feeds/packages/owipcalc feeds/packages/p11-kit feeds/packages/p910nd feeds/packages/packr feeds/packages/pagekitec feeds/packages/parted feeds/packages/passlib feeds/packages/patch feeds/packages/pcapplusplus feeds/packages/pciutils feeds/packages/pcmciautils feeds/packages/pcre2 feeds/packages/pcsc-lite feeds/packages/pcsc-tools feeds/packages/pdns feeds/packages/pdns-recursor feeds/packages/pen feeds/packages/perl feeds/packages/perl-authen-sasl feeds/packages/perl-authen-sasl-xs feeds/packages/perl-cgi feeds/packages/perl-compress-bzip2 feeds/packages/perl-dbi feeds/packages/perl-device-serialport feeds/packages/perl-device-usb feeds/packages/perl-encode-locale feeds/packages/perl-file-listing feeds/packages/perl-file-rsyncp feeds/packages/perl-file-sharedir-install feeds/packages/perl-html-form feeds/packages/perl-html-parser feeds/packages/perl-html-tagset feeds/packages/perl-html-tree feeds/packages/perl-http-cookies feeds/packages/perl-http-daemon feeds/packages/perl-http-date feeds/packages/perl-http-message feeds/packages/perl-http-negotiate feeds/packages/perl-http-server-simple feeds/packages/perl-inline feeds/packages/perl-inline-c feeds/packages/perl-io-html feeds/packages/perl-lockfile-simple feeds/packages/perl-lwp-mediatypes feeds/packages/perl-mail-spamassassin feeds/packages/perl-net-cidr-lite feeds/packages/perl-net-dns feeds/packages/perl-net-http feeds/packages/perl-net-telnet feeds/packages/perl-netaddr-ip feeds/packages/perl-parse-recdescent feeds/packages/perl-parse-yapp feeds/packages/perl-sub-uplevel feeds/packages/perl-test-harness feeds/packages/perl-test-warn feeds/packages/perl-text-csv_xs feeds/packages/perl-try-tiny feeds/packages/perl-uri feeds/packages/perl-www feeds/packages/perl-www-curl feeds/packages/perl-www-mechanize feeds/packages/perl-www-robotrules feeds/packages/perl-xml-parser feeds/packages/phantap feeds/packages/php7 feeds/packages/php7-pecl-dio feeds/packages/php7-pecl-http feeds/packages/php7-pecl-imagick feeds/packages/php7-pecl-krb5 feeds/packages/php7-pecl-libevent feeds/packages/php7-pecl-mcrypt feeds/packages/php7-pecl-propro feeds/packages/php7-pecl-raphf feeds/packages/php7-pecl-redis feeds/packages/php8 feeds/packages/pianod feeds/packages/picocom feeds/packages/pigeonhole feeds/packages/pigz feeds/packages/pillow feeds/packages/pingcheck feeds/packages/pixiewps feeds/packages/pixman feeds/packages/pkg-config feeds/packages/pkgconf feeds/packages/poco feeds/packages/podman feeds/packages/polipo feeds/packages/port-mirroring feeds/packages/portaudio feeds/packages/postfix feeds/packages/postgresql feeds/packages/powertop feeds/packages/pppossh feeds/packages/pps-tools feeds/packages/pptpd feeds/packages/privoxy feeds/packages/procps-ng feeds/packages/progress feeds/packages/prometheus feeds/packages/prometheus-node-exporter-lua feeds/packages/prometheus-statsd-exporter feeds/packages/prosody feeds/packages/protobuf feeds/packages/protobuf-c feeds/packages/proxychains-ng feeds/packages/pservice feeds/packages/psmisc feeds/packages/psqlodbc feeds/packages/pthsem feeds/packages/ptunnel-ng feeds/packages/pugixml feeds/packages/pulseaudio feeds/packages/pv feeds/packages/pyjwt feeds/packages/pymysql feeds/packages/pyodbc feeds/packages/python-aiohttp feeds/packages/python-aiohttp-cors feeds/packages/python-apipkg feeds/packages/python-appdirs feeds/packages/python-asn1crypto feeds/packages/python-astral feeds/packages/python-async-timeout feeds/packages/python-atomicwrites feeds/packages/python-attrs feeds/packages/python-augeas feeds/packages/python-automat feeds/packages/python-awscli feeds/packages/python-babel feeds/packages/python-bidict feeds/packages/python-boto3 feeds/packages/python-botocore feeds/packages/python-cached-property feeds/packages/python-cachelib feeds/packages/python-cachetools feeds/packages/python-certifi feeds/packages/python-cffi feeds/packages/python-chardet feeds/packages/python-ciso8601 feeds/packages/python-colorama feeds/packages/python-constantly feeds/packages/python-contextlib2 feeds/packages/python-cryptodome feeds/packages/python-cryptodomex feeds/packages/python-cryptography feeds/packages/python-curl feeds/packages/python-dateutil feeds/packages/python-decorator feeds/packages/python-defusedxml feeds/packages/python-distro feeds/packages/python-dns feeds/packages/python-docker feeds/packages/python-dockerpty feeds/packages/python-docopt feeds/packages/python-docutils feeds/packages/python-dotenv feeds/packages/python-engineio feeds/packages/python-et_xmlfile feeds/packages/python-evdev feeds/packages/python-eventlet feeds/packages/python-execnet feeds/packages/python-flask-babel feeds/packages/python-flask-httpauth feeds/packages/python-flask-login feeds/packages/python-flask-seasurf feeds/packages/python-flask-session feeds/packages/python-flask-socketio feeds/packages/python-gmpy2 feeds/packages/python-gnupg feeds/packages/python-greenlet feeds/packages/python-hyperlink feeds/packages/python-idna feeds/packages/python-ifaddr feeds/packages/python-incremental feeds/packages/python-influxdb feeds/packages/python-iniconfig feeds/packages/python-intelhex feeds/packages/python-jdcal feeds/packages/python-jmespath feeds/packages/python-jsonpath-ng feeds/packages/python-jsonschema feeds/packages/python-libmodbus feeds/packages/python-lxml feeds/packages/python-markdown feeds/packages/python-more-itertools feeds/packages/python-msgpack feeds/packages/python-multidict feeds/packages/python-netdisco feeds/packages/python-oauthlib feeds/packages/python-packaging feeds/packages/python-paho-mqtt feeds/packages/python-paramiko feeds/packages/python-parsley feeds/packages/python-pip-conf feeds/packages/python-pluggy feeds/packages/python-ply feeds/packages/python-psutil feeds/packages/python-psycopg2 feeds/packages/python-py feeds/packages/python-pyasn1 feeds/packages/python-pyasn1-modules feeds/packages/python-pycparser feeds/packages/python-pynacl feeds/packages/python-pyopenssl feeds/packages/python-pyotp feeds/packages/python-pyparsing feeds/packages/python-pyrsistent feeds/packages/python-pyserial feeds/packages/python-pysocks feeds/packages/python-pytest feeds/packages/python-pytest-forked feeds/packages/python-pytest-xdist feeds/packages/python-pytz feeds/packages/python-qrcode feeds/packages/python-rcssmin feeds/packages/python-requests feeds/packages/python-requests-oauthlib feeds/packages/python-rsa feeds/packages/python-s3transfer feeds/packages/python-schedule feeds/packages/python-schema feeds/packages/python-sentry-sdk feeds/packages/python-service-identity feeds/packages/python-simplejson feeds/packages/python-six feeds/packages/python-slugify feeds/packages/python-socketio feeds/packages/python-sqlalchemy feeds/packages/python-stem feeds/packages/python-texttable feeds/packages/python-toml feeds/packages/python-tornado feeds/packages/python-twisted feeds/packages/python-typing-extensions feeds/packages/python-ubus feeds/packages/python-uci feeds/packages/python-urllib3 feeds/packages/python-voluptuous feeds/packages/python-voluptuous-serialize feeds/packages/python-wcwidth feeds/packages/python-websocket-client feeds/packages/python-websockets feeds/packages/python-yaml feeds/packages/python-yarl feeds/packages/python-zeroconf feeds/packages/python-zipp feeds/packages/python-zope-interface feeds/packages/python3 feeds/packages/python3-asgiref feeds/packages/python3-bottle feeds/packages/python3-django-cors-headers feeds/packages/python3-django-etesync-journal feeds/packages/python3-drf-nested-routers feeds/packages/python3-libselinux feeds/packages/python3-libsemanage feeds/packages/python3-maxminddb feeds/packages/python3-netifaces feeds/packages/python3-networkx feeds/packages/python3-packages feeds/packages/python3-pyinotify feeds/packages/python3-pyroute2 feeds/packages/python3-speedtest-cli feeds/packages/python3-sqlparse feeds/packages/python3-unidecode feeds/packages/qemu feeds/packages/qrencode feeds/packages/quassel-irssi feeds/packages/quasselc feeds/packages/quota feeds/packages/radicale feeds/packages/radicale2 feeds/packages/radsecproxy feeds/packages/ratched feeds/packages/ratechecker feeds/packages/rclone feeds/packages/rclone-ng feeds/packages/rclone-webui-react feeds/packages/readsb feeds/packages/reaver feeds/packages/redis feeds/packages/redsocks feeds/packages/relayctl feeds/packages/remserial feeds/packages/reptyr feeds/packages/restic feeds/packages/restic-rest-server feeds/packages/rng-tools feeds/packages/rp-pppoe feeds/packages/rpcbind feeds/packages/rpcd-mod-lxc feeds/packages/rpcsvc-proto feeds/packages/rrdtool1 feeds/packages/rsync feeds/packages/rsyslog feeds/packages/rtklib feeds/packages/rtl-ais feeds/packages/rtl-sdr feeds/packages/rtl_433 feeds/packages/rtorrent feeds/packages/rtty feeds/packages/ruamel-yaml feeds/packages/ruby feeds/packages/runc feeds/packages/safe-search feeds/packages/samba4 feeds/packages/samplicator feeds/packages/sane-backends feeds/packages/sbc feeds/packages/scapy feeds/packages/schroot feeds/packages/scons feeds/packages/screen feeds/packages/seafile-ccnet feeds/packages/seafile-seahub feeds/packages/seafile-server feeds/packages/sed feeds/packages/selinux-python feeds/packages/semodule-utils

feeds/packages/sendmail feeds/packages/ser2net feeds/packages/serdisplib feeds/packages/serialconsole feeds/packages/setools feeds/packages/setserial feeds/packages/shadow feeds/packages/shadowsocks-libev feeds/packages/shairplay feeds/packages/shairport-sync feeds/packages/shine feeds/packages/shorewall feeds/packages/shorewall-core feeds/packages/shorewall-lite feeds/packages/shorewall6 feeds/packages/shorewall6-lite feeds/packages/siit feeds/packages/simple-adblock feeds/packages/sipcalc feeds/packages/sispmctl feeds/packages/slang2 feeds/packages/slide-switch feeds/packages/smartdns feeds/packages/smartmontools feeds/packages/smcroute feeds/packages/smstools3 feeds/packages/snort feeds/packages/snort3 feeds/packages/snowflake feeds/packages/socat feeds/packages/sockread feeds/packages/softethervpn feeds/packages/softethervpn5 feeds/packages/softflowd feeds/packages/sox feeds/packages/spawn-fcgi feeds/packages/spdlog feeds/packages/speedtest-netperf feeds/packages/speex feeds/packages/speexdsp feeds/packages/spi-tools feeds/packages/spice feeds/packages/spice-protocol feeds/packages/spoofer feeds/packages/sqlite3 feeds/packages/sqm-scripts feeds/packages/sqm-scripts-extra feeds/packages/squashfs-tools feeds/packages/squeezelite feeds/packages/squid feeds/packages/ssdeep feeds/packages/sshfs feeds/packages/sshpass feeds/packages/sshtunnel feeds/packages/sslh feeds/packages/sstp-client feeds/packages/static-neighbor-reports feeds/packages/stm32flash feeds/packages/stoken feeds/packages/stress feeds/packages/stress-ng feeds/packages/strongswan feeds/packages/stubby feeds/packages/stunnel feeds/packages/subversion feeds/packages/sudo feeds/packages/sumo feeds/packages/svox feeds/packages/swig feeds/packages/switchdev-poller feeds/packages/syncthing feeds/packages/syslog-ng feeds/packages/sysrepo feeds/packages/sysstat feeds/packages/tac_plus feeds/packages/taglib feeds/packages/tailscale feeds/packages/tang feeds/packages/tar feeds/packages/taskwarrior feeds/packages/tayga feeds/packages/tcl feeds/packages/tcp_wrappers feeds/packages/tcpproxy feeds/packages/tcpreplay feeds/packages/tcsh feeds/packages/tdb feeds/packages/telegraf feeds/packages/telldus-core feeds/packages/temperusb feeds/packages/tessdata feeds/packages/tesseract feeds/packages/text-unidecode feeds/packages/tgt feeds/packages/tiff feeds/packages/tinc feeds/packages/tini feeds/packages/tinycdb feeds/packages/tinyionice feeds/packages/tinyproxy feeds/packages/tio feeds/packages/tmate feeds/packages/tmux feeds/packages/tor feeds/packages/tor-fw-helper feeds/packages/tor-hs feeds/packages/torsocks feeds/packages/tracertools feeds/packages/trafficshaper feeds/packages/transmission feeds/packages/transmission-web-control feeds/packages/travelmate feeds/packages/tree feeds/packages/triggerhappy feeds/packages/ttyd feeds/packages/tvheadend feeds/packages/u2pnpd feeds/packages/uacme feeds/packages/uanytun feeds/packages/ubnt-manager feeds/packages/uci2 feeds/packages/udns feeds/packages/udpspeeder feeds/packages/udptunnel feeds/packages/udpxy feeds/packages/uhubctl feeds/packages/uledd feeds/packages/ulogd feeds/packages/umurmur feeds/packages/unbound feeds/packages/unixodbc feeds/packages/unrar feeds/packages/unzip feeds/packages/upmpdcli feeds/packages/usbip feeds/packages/usbmuxd feeds/packages/usbutils feeds/packages/usteer feeds/packages/uuid feeds/packages/uvcdynctrl feeds/packages/uw-imap feeds/packages/uwsgi feeds/packages/v2raya feeds/packages/v4l2rtspserver feeds/packages/vala feeds/packages/vallumd feeds/packages/vim feeds/packages/vips feeds/packages/vncrepeater feeds/packages/vnstat feeds/packages/vnstat2 feeds/packages/vobject feeds/packages/vpn-policy-routing feeds/packages/vpnbypass feeds/packages/vpnc feeds/packages/vpnc-scripts feeds/packages/vsftpd feeds/packages/wakeonlan feeds/packages/watchcat feeds/packages/wavemon feeds/packages/websocketpp feeds/packages/webui-aria2 feeds/packages/wg-installer feeds/packages/wget feeds/packages/which feeds/packages/whois feeds/packages/wifidog feeds/packages/wifischedule feeds/packages/wifitoggle feeds/packages/wipe feeds/packages/wsdd2 feeds/packages/xfsprogs feeds/packages/xinetd feeds/packages/xl2tpd feeds/packages/xmlrpc-c feeds/packages/xmltodict feeds/packages/xr_usb_serial_common feeds/packages/xray-core feeds/packages/xtables-addons feeds/packages/xupnpd feeds/packages/xz feeds/packages/yajl feeds/packages/yaml feeds/packages/yara feeds/packages/yggdrasil feeds/packages/ykclient feeds/packages/ykpers feeds/packages/youtube-dl feeds/packages/yq feeds/packages/yubico-pam feeds/packages/zabbix feeds/packages/zerotier feeds/packages/zile feeds/packages/zmq feeds/packages/znc feeds/packages/zoneinfo feeds/packages/zsh feeds/packages/zstd feeds/routing/ahcpd feeds/routing/alfred feeds/routing/babel-pinger feeds/routing/babeld feeds/routing/batctl feeds/routing/batman-adv feeds/routing/batmand feeds/routing/bird1 feeds/routing/bird1-ipv4-openwrt feeds/routing/bird1-ipv6-openwrt feeds/routing/bird2 feeds/routing/bmx6 feeds/routing/bmx7 feeds/routing/cjdns feeds/routing/hnetd feeds/routing/luci-app-bmx6 feeds/routing/luci-app-cjdns feeds/routing/mcproxy feeds/routing/mesh11sd feeds/routing/minimalist-pcproxy feeds/routing/mrd6 feeds/routing/naywatch feeds/routing/ndppd feeds/routing/nodogsplash feeds/routing/ohybridproxy feeds/routing/olsrd feeds/routing/oonf-dlep-proxy feeds/routing/oonf-dlep-radio feeds/routing/oonf-init-scripts feeds/routing/oonf-olsrd2 feeds/routing/opennds feeds/routing/pimbd feeds/routing/prince feeds/routing/quagga feeds/routing/vis firmware/ath10k-ct-firmware firmware/b43legacy-firmware firmware/cypress-firmware firmware/cypress-nvram firmware/intel-microcode firmware/ipq-wifi firmware/lantiq/dsl-vrx200-firmware-xdsl firmware/layerscape/fman-ucode firmware/layerscape/ls-ddr-phy firmware/layerscape/ls-dpl firmware/layerscape/ls-mc firmware/layerscape/ls-rcw firmware/layerscape/ppfe-firmware firmware/linux-firmware firmware/prism54-firmware firmware/wireless-regdb kernel/acx-mac80211 kernel/ath10k-ct kernel/bcm27xx-gpu-fw kernel/bcm63xx-cfe kernel/broadcom-wl kernel/button-hotplug kernel/cryptodev-linux kernel/exfat kernel/gpio-button-hotplug kernel/gpio-nct5104d kernel/gpio-nxp-74hc153 kernel/hwmon-gsc kernel/lantiq/ltq-adsl kernel/lantiq/ltq-adsl-fw kernel/lantiq/ltq-adsl-mei kernel/lantiq/ltq-atm kernel/lantiq/ltq-deu kernel/lantiq/ltq-ifxos kernel/lantiq/ltq-ptm kernel/lantiq/ltq-tapi kernel/lantiq/ltq-vdsl kernel/lantiq/ltq-vdsl-fw kernel/lantiq/ltq-vdsl-mei kernel/lantiq/ltq-vmmc kernel/linux kernel/mac80211 kernel/mt76 kernel/mt7621-qtn-rgmii kernel/mwlwifi kernel/nat46 kernel/om-watchdog kernel/rtc-rv5c386a kernel/rtl8812au-ct kernel/trelay libs/argp-standalone libs/elfutils libs/gettext libs/gettext-full libs/gmp libs/jansson libs/libaudit libs/libbsd libs/libevent2 libs/libiconv libs/libiconv-full libs/libjson-c libs/libmnl libs/libnetfilter-conntrack libs/libnfnetlink libs/libnftnl libs/libnl libs/libnl-tiny libs/libpcap libs/libselinux libs/libsemanage libs/libsepol libs/libtool libs/libubox libs/libunwind libs/libusb libs/mbedtls libs/musl-fts libs/ncurses libs/nettle libs/openssl libs/pcre libs/popt libs/readline libs/sysfsutils libs/toolchain libs/uclibc++ libs/uclient libs/ustream-ssl libs/wolfssl libs/zlib mtk/applications/1905daemon mtk/applications/8021xd mtk/applications/ated_ext mtk/applications/bndstrg_plus mtk/applications/datconf mtk/applications/fwdd mtk/applications/libmapd mtk/applications/luci-app-mtk mtk/applications/mapd mtk/applications/miniupnpd-1.6 mtk/applications/mtk-base-files mtk/applications/sigma_daemon mtk/applications/sigma_dut_v9.0.0 mtk/applications/wappd mtk/applications/wificonf mtk/drivers/connectivity/conninfra mtk/drivers/mapfilter mtk/drivers/mt7915 mtk/drivers/mt_wifi mtk/drivers/mtfwd mtk/drivers/mtqos mtk/drivers/warp mtk/drivers/wifi-profile network/config/firewall network/config/gre network/config/ipip network/config/ltq-adsl-app network/config/ltq-vdsl-app network/config/netifd network/config/qos-scripts network/config/soloscli network/config/swconfig network/config/vti network/config/vxlan network/config/xfrm network/ipv6/464xlat network/ipv6/6in4 network/ipv6/6rd network/ipv6/6to4 network/ipv6/ds-lite network/ipv6/map network/ipv6/odhcp6c network/ipv6/thc-ipv6 network/services/dnsmasq network/services/dropbear network/services/ead network/services/hostapd network/services/igmpproxy network/services/ipset-dns network/services/lldpd network/services/odhcpd network/services/omcproxy network/services/ppp network/services/relayd network/services/uhttpd network/services/umdns network/utils/adb-enablemodem network/utils/arptables network/utils/bpftools network/utils/comgt network/utils/dante network/utils/ebtables network/utils/ethtool network/utils/iproute2 network/utils/ipset network/utils/iptables network/utils/iw network/utils/iwcap network/utils/iwinfo network/utils/layerscape/restool network/utils/linux-atm network/utils/ltq-dsl-base network/utils/nftables network/utils/resolveip network/utils/rssileds network/utils/tcpdump network/utils/umbim network/utils/uqmi network/utils/wireguard-tools network/utils/wireless-tools network/utils/wpan-tools network/utils/wwan system/ca-certificates system/fstools system/fwtool system/iucode-tool system/mtd system/openwrt-keyring system/opkg system/procd system/refpolicy system/rpcd system/selinux-policy system/ubox system/ubus system/ucert system/uci system/urandom-seed system/urngd system/usign system/zram-swap utils/adb utils/bcm27xx-userland utils/bcm4908img utils/bsdiff utils/busybox utils/bzip2 utils/checkpolicy utils/ct-bugcheck utils/dtc utils/e2fsprogs utils/f2fs-tools utils/fbtest utils/fritz-tools utils/jboot-tools utils/jsonfilter utils/lua utils/lua5.3 utils/mdadm utils/mtd-utils utils/nvram utils/osafeloader utils/oseama utils/otrx utils/policycoreutils utils/px5g-mbedtls utils/px5g-wolfssl utils/ravpower-mcu utils/secilc utils/spidev_test utils/ugps utils/usbmode utils/util-linux

总结：

a)subdir函数中以二重循环的方式遍历SUBTARGETS和package/builddirs，然后调用subtarget函数生成目标

b)builddirs说明了有这么多模块需要编译，SUBTARGETS体现了每个模块有这么多目标需要对应实现，如下载、编译、清除等等。

c)SUBTARGETS是一个静态定义的常熟值，builddirs则动态生成，现在继续理解builddirs的生成

### 3.1.2)builddir的值从哪儿来

对于package, 需要看package/Makefile, 该文件中有如下代码：

13 -include $(TMP_DIR)/.packagedeps

14 package-y += kernel/linux

15 $(curdir)/autoremove:=1

16 $(curdir)/builddirs:=$(sort $(package-) $(package-y) $(package-m))

$(TMP_DIR)=tmp

builddirs的值来自tmp/.packagedeps

如该文件中对json的定义如下：

1935 package-$(CONFIG_PACKAGE_libjson-c) += libs/libjson-c

结论：

package/builddirs的值来自tmp/.packagedeps这个文件，因此需要看看这个文件是如何生成的。

### 3.1.3)tmp/.packagedeps文件的生成

include/toplevel.mk中：

76 prepare-tmpinfo: FORCE

86 ./scripts/package-metadata.pl mk tmp/.packageinfo > tmp/.packagedeps || { rm -f tmp/.packagedeps; false; }

perl脚本分析tmp/.packageinfo输入文件，输出了tmp/.packagedeps文件

prereq这个目标触发了上面的prepare-tmpinfo目标的执行

207 prereq:: prepare-tmpinfo .config

查看package-metadata.pl的实现，发现它根据后面的mk命令，利用输入文件tmp/.packageinfo生成了tmp/.packagedeps文件。

具体的实现在gen_package_mk函数中完成

391 sub gen_package_mk() {

392 my $line;

393 printf "argv0= %s\n", $ARGV[0];

394 parse_package_metadata($ARGV[0]) or exit 1;

ARGV[0]就是传入进来的参数tmp/.packageinfo

结论：

a)tmp/.packagedeps文件由perl脚本生成，它基于输入文件tmp/.packageinfo文件生成

b)需要继续查看tmp/.packageinfo文件是如何生成的，该文件的生成比较复杂，通过一个大的章节来描述。

## 3.2)tmp/.packageinfo的生成

### 3.2.1)找到实现的入口代码

实现的代码在include/scan.mk中，代码如下：

6 SCAN_TARGET ?= packageinfo

10 FILELIST:=$(TMP_DIR)/info/.files-$(SCAN_TARGET)-$(SCAN_COOKIE)

$(TMP_DIR)/.$(SCAN_TARGET): $(TARGET_STAMP)

$(call progress,Collecting $(SCAN_NAME) info: merging...)

-cat $(FILELIST) | awk '{gsub(/\//, "_", $$0);print "$(TMP_DIR)/info/.$(SCAN_TARGET)-" $$0}' | xargs cat > $@ 2>/dev/null

$(call progress,Collecting $(SCAN_NAME) info: donezp)

echo

SCAN_TARRGET=packageinfo,所以

$(TMP_DIR)/.$(SCAN_TARGET)的值是：

/home/zhoupeng/mtk/openwrt-21.02-orig/tmp/.packageinfo

该值就是要生成的目标

总结：

a) 生成tmp/.packageinfo文件的代码在include/scan.mk中

b) 生成需要FILELIST这个输入文件，继续看这个文件是如何生成的

### 3.2.2)FILELIST文件的生成

还是在include/scan.mk中，生成它的代码如下：

75 $(FILELIST): $(OVERRIDELIST)

76 rm -f $(TMP_DIR)/info/.files-$(SCAN_TARGET)-*

78 find -L $(SCAN_DIR) $(SCAN_EXTRA) -mindepth 1 $(if $(SCAN_DEPTH),-maxdepth $(SCAN_DEPTH)) -name Makefile | xargs grep -aHE 'call $(GREP_STRING)' | sed -e 's#^$(SCAN_DIR)/##' -e 's#/Makefile:.* ##' | uniq | awk -v of=$(OVERRIDELIST) -f include/scan.awk > $@

78行的代码展开后如下：

find -L package -mindepth 1 -maxdepth 5 -name Makefile | xargs grep -aHE 'call (Build/DefaultTargets|BuildPackage|KernelPackage)' | sed -e 's#^package/##' -e 's#/Makefile:.*##' | uniq | awk -v of=/home/zhoupeng/mtk/openwrt-21.02-orig/tmp/info/.overrides-packageinfo-28017 -f include/scan.awk > /home/zhoupeng/mtk/openwrt-21.02-orig/tmp/info/.files-packageinfo-28017

a)find -L package -mindepth 1 -maxdepth 5 -name Makefile

将package目录下面所有的Makefile找出来，但查找的最大深度为5

b)xargs grep -aHE 'call (Build/DefaultTargets|BuildPackage|KernelPackage)'

从这些Makefile中搜索所有的带call函数的，函数是Build/DefaultTargets、BuildPackage、KernelPackage其中之一。

举例：

package/mtk/drivers/mtfwd/Makefile:$(eval $(call KernelPackage,mtfwd))

c)sed -e 's#^package/##' -e 's#/Makefile:.*##'

开头为package被替换为空，因为##之间没有内容，表示被替换为空，此时的结果为：

mtk/drivers/mtfwd/Makefile:$(eval $(call KernelPackage,mtfwd))

查找到/Makefile:.*, 也就是从/Makefile:之后开始的所有内容，都被去掉，因为##之间没有内容,此时的结果为：

mtk/drivers/mtfwd

去除这儿就是包含这些目标函数的调用的文件夹名称了。

d)unqi

去除重复的，因为同一个Makefile中有可能调用多次目标函数去编译这些模块

e)awk -v of=aa -f include/scan.awk

scan.awk中的函数会处理，临时结果放到aa中.

这个过程可以忽略

最终的输出在：

/home/zhoupeng/mtk/openwrt-21.02-orig/tmp/info/.files-packageinfo-19926

方便理解，该文件的内容如下：

base-files

boot/arm-trusted-firmware-bcm63xx

boot/arm-trusted-firmware-mediatek

boot/arm-trusted-firmware-mvebu

boot/arm-trusted-firmware-rockchip

boot/arm-trusted-firmware-sunxi

boot/arm-trusted-firmware-tools

总结：

a)这儿的FILELIST就是/home/zhoupeng/mtk/openwrt-21.02-orig/tmp/info/.files-packageinfo-19926

b)文件名最后的19926是一个动态生成的cookie值，每次运行都不一样

c)FILELIST中保存的内容是每个模块的文件夹目录名

### 3.2.3).packageinfo的生成

FILELIST文件的内容理解后，继续来理解.packageinfo文件的生成

cat $(FILELIST) | awk '{gsub(/\//,"_",$$0);print "$(TMP_DIR)/info/.$(SCAN_TARGET)-" $$0}' | xargs cat > $@

假设文件

/home/zhoupeng/mtk/openwrt-21.02-orig/tmp/info/.files-packageinfo-11703

的第一行内容为：

boot/arm-trusted-firmware-bcm63xx

a)gsub(/\//,"_",$$0)

’/’将会被替换成’_’, 替换后的结果赋值给$$0变量

替换后的结果就是：

boot_arm-trusted-firmware-bcm63xx

b)print "$(TMP_DIR)/info/.$(SCAN_TARGET)-" $$0}

重新组装成

$(TMP_DIR)/info/.$(SCAN_TARGET)-$$0

这儿TMP_DIR= /home/zhoupeng/mtk/openwrt-21.02-orig/tmp

SCAN_TARGET=packageinfo

$$0是boot_arm-trusted-firmware-bcm63xx

所以最后的结果就是：

/home/zhoupeng/mtk/openwrt-21.02-orig/tmp/info/.packageinfo-boot_arm-trusted-firmware-bcm63xx

这个文件也是动态生成的，它的内容被读出来写到了./tmp/.packageinfo文件中

总结：

a) 这儿输入文件是每个模块的文件，如这儿的.packageinfo-boot_arm-trusted-firmware-bcm63xx, 输出文件是./tmp/.packageinfo

b) 每个模块的内容都被统一输入到了./tmp/.packageinfo文件中

### 3.2.4)PackageDir函数生成.packageinfo-XXX模块文件

include/scan.mk的PackageDir函数完成

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

openwrt-block here

mv $$@.tmp $$@

endef

验证步骤：

a)删除tmp/info目录下面的文件：

rm .packageinfo-boot_arm-trusted-firmware-bcm63xx

b)include/scan.mk的PackageDir函数增加堵在代码

openwrt-block here

mv $$@.tmp $$@

c)make -j1 V=s

mv之前会堵住，且此时存在.tmp文件，真实的文件还不存在

.packageinfo-boot_arm-trusted-firmware-bcm63xx.tmp

结论：

a)每个模块的.packageinfo-xxxx文件都是PackageDir函数生成的

b)这儿还只确认了是PackageDir函数生成，如何生成、生成的内容是什么还需要继续分析

### 3.2.5)PackageDir函数的调用

include/scan.mk中有如下代码：

-include $(TMP_DIR)/info/.files-$(SCAN_TARGET).mk

此时的SCAN_TARGET=packageinfo

所以将会包含.file-packageinfo.mk文件

.file-packageinfo.mk的生成代码如下：

cat $(FILELIST) | awk '{gsub(/\//,"_",$$0);print "$(TMP_DIR)/info/.$(SCAN_TARGET)-" $$0}' | xargs cat > $@

它依赖的FILELIST也已经生成,该文件的生成过程以及文件内容都在3.2.2节描述了。

该文件生成之后，就准备调用PackageDir函数去生成每个模块的.packageinfo-xxx文件了

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

代码理解

真正执行时的代码为：

cat /home/zhoupeng/mtk/openwrt-21.02-orig/tmp/info/.files-packageinfo-539 | awk '{print "package/" $0 "/Makefile" }'| xargs grep -HE '^*SCAN_DEPS*=*'|awk -F: '{ gsub(/^.*DEPS *= */, "", $2); print "DEPS_" $1 "=" $2 }';

a) cat $<

$<是依赖的文件，假设它是/home/zhoupeng/mtk/openwrt-21.02-orig/tmp/info/.files-packageinfo-539

cat这个文件的内容，一行行来处理，如第二行的内容：

boot/arm-trusted-firmware-bcm63xx

b) awk '{print "$(SCAN_DIR)/" $$0 "/Makefile" }'

SCAN_DIR=package

$$0表示整行的内容都拿出来使用。

现在将$(SCAN_DIR)、读出来的内容、Makefile三段整合成一个完整的内容，如

package/boot/arm-trusted-firmware-bcm63xx/Makefile

c) xargs grep -HE '^ *SCAN_DEPS *= *'

搜索这些Makefile中有包含SCAN_DEPS关键字的Makefile, 且后面需要跟着一个”=”

搜索出来的结果如下：

package/firmware/linux-firmware/Makefile:SCAN_DEPS = *.mk

package/kernel/linux/Makefile:SCAN_DEPS=modules/*.mk $(TOPDIR)/target/linux/*/modules.mk $(TOPDIR)/include/netfilter.mk

只有两个文件满足

d) awk -F: '{ gsub(/^.*DEPS *= */, "", $2); print "DEPS_" $1 "=" $2 }';

已知原始内容为:

package/firmware/linux-firmware/Makefile:SCAN_DEPS = *.mk

package/kernel/linux/Makefile:SCAN_DEPS=modules/*.mk $(TOPDIR)/target/linux/*/modules.mk $(TOPDIR)/include/netfilter.mk

以上内容是上要给管道给出来的

-F:表示用”:”去分割， 对于第一行内容，分割结果如下：

$1=package/firmware/linux-firmware/Makefile

$2=SCAN_DEPS = *.mk

/^.*DEPS *= */这是一个搜索关键字，^表示开头，.*配合使用，开头的通配符匹配，只要后面是DEPS就可以匹配了，

‘ *’注意这里面有空格，就是说这个匹配所有的空格

同样等号后面的’ *’也是匹配等号后面的所有空格。

所有这些匹配的内容都被空串替换掉，剩下的内容赋值给$2变量。此时$2=*.mk

所以最后pinrt打印出来的结果就是你：

DEPS_$1=$2

具体的结果就是

DEPS_package/firmware/linux-firmware/Makefile=*.mk

第二行内容就是：

DEPS_package/kernel/linux/Makefile=modules/*.mk $(TOPDIR)/target/linux/*/modules.mk $(TOPDIR)/include/netfilter.mk

结论：

主要是理解这个代码做了什么，没有什么用。

对PackageDir的代码调用的真正代码在这儿

98 info=$$0; \

99 gsub(/\//, "_", info); \

100 dir=$$0; \

101 pkg=""; \

102 if($$NF in override) \

103 pkg=override[$$NF]; \

104 print "$$(eval $$(call PackageDir," info "," dir "," pkg "))"; \

105 } ' < $<; \

$$0就是读到的/home/zhoupeng/mtk/openwrt-21.02-orig/tmp/info/.files-packageinfo-539文件的内容， 然后转换成参数来处理

已知读到的前三行的内容是：

base-files

boot/arm-trusted-firmware-bcm63xx

boot/arm-trusted-firmware-mediatek

那么调用PackageDir时，

info=base-files

dir =base-files

info=boot_arm-trusted-firmware-bcm63xx

dir=boot/arm-trusted-firmware-bcm63xx

info =boot_arm-trusted-firmware-mediatek

dir=boot/arm-trusted-firmware-mediatek

结论：

a)调用PackageDir函数的代码在include/scan.mk的如下代码中完成：

b)$(TMP_DIR)/info/.files-$(SCAN_TARGET).mk: $(FILELIST)

它实现的核心功能就是读tmp/info/.file-packageinfo-xxx文件，该文件里面的内容都是需要编译的模块的目录名。现在根据这些目录名构成参数去调用PackageDir函数

c)PackageDir函数如何生成的需要进一步分析

### 3.2.6)PackageDir函数如何生成.package-xxxx文件

继续基于3.2.4节来理解，以生成.packageinfo-boot_arm-trusted-firmware-bcm63xx.tmp文件来理解

/home/zhoupeng/mtk/openwrt-21.02-orig/tmp/info/.packageinfo-boot_arm-trusted-firmware-bcm63xx.tmp

#### 3.2.6.1)生成内容展示

生成的实现代码就在PackageDir函数中，最终生成的内容如下：

需要看看它是如何生成出来的

Source-Makefile: package/boot/arm-trusted-firmware-bcm63xx/Makefile

Package: trusted-firmware-a-bcm4908

Default: y

Version: 2.2-0

Depends: +libc +USE_GLIBC:librt +USE_GLIBC:libpthread @!IN_SDK @TARGET_bcm4908

Conflicts:

Menu-Depends:

Provides:

Build-Variant: bcm4908

Section: boot

Category: Boot Loaders

Title: Trusted-Firmware-A for BCM4908

Maintainer: Rafał Miłecki <rafal@milecki.pl>

Source: trusted-firmware-a-2.2.tar.xz

License: BSD-3-Clause

LicenseFiles: docs/license.rst

Type: bin

Description: Trusted-Firmware-A for BCM4908

[https://www.trustedfirmware.org/projects/tf-a/](https://www.trustedfirmware.org/projects/tf-a/)

Rafał Miłecki <rafal@milecki.pl>

@@

#### 3.2.6.2)生成内容的关键代码

PackageDir函数中增如下代码：

51 $(info $(NO_TRACE_MAKE) --no-print-dir -r DUMP=1 FEED="$(call feedname,$(2))" -C $(SCAN_DIR)/$(2) $(SCAN_MAKEOPTS) 2>/dev/null) && \

发现都转换成了这样的代码

make V=ss --no-print-dir -r DUMP=1 FEED="" -C package/base-files 2>/dev/null

很显然它就是调用package/base-files/Makefile来完成的

#### 3.2.6.3)手动调试关键代码

下面来手动执行这样的命令来调试

make V=ss --no-print-dir -r DUMP=1 FEED="" -C package/base-files INCLUDE_DIR=/home/zhoupeng/mtk/openwrt-21.02-orig/include TOPDIR=/home/zhoupeng/mtk/openwrt-21.02-orig

定位发现是这个完成输出

277 $(if $(DUMP), \

278 $(if $(CHECK),,$(Dumpinfo/Package))

279 )

Dumpinfo/Package函数在include/package-dumpinfo.mk中定义，如下：

16 define Dumpinfo/Package

17 $(info $(SOURCE_INFO)Package: $(1)

18 $(if $(MENU),Menu: $(MENU)

19 )$(if $(SUBMENU),Submenu: $(SUBMENU)

20 )$(if $(SUBMENUDEP),Submenu-Depends: $(SUBMENUDEP)

21 )$(if $(DEFAULT),Default: $(DEFAULT)

22 )$(if $(findstring $(PREREQ_CHECK),1),Prereq-Check: 1

23 )Version: $(VERSION)

24 Depends: $(call PKG_FIXUP_DEPENDS,$(1),$(DEPENDS))

...

endef

以实现依赖为例

a)首先include/package-defaults.mk的define Package/Default函数将DEPENDS设置为空：

17 DEPENDS:=

b)然后package/base-files/Makefile自己提供的Package/base-files函数定义了自己的依赖：

define Package/base-files

39 DEPENDS:=+netifd +libc +jsonfilter +SIGNED_PACKAGES:usign +SIGNED_PACKAGES:openwrt-keyring +NAND_SUPPORT:ubi-u tils +fstools +fwtool

c)加上PKG_FIXUP_DEPENDS完成修正, 最终生成的结果如下

PKG_FIXUP_DEPENDS在include/package-defaults.mk中定义，它的值如下：

PKG_FIXUP_DEPENDS=+libc +USE_GLIBC:librt +USE_GLIBC:libpthread

d)最终的结果如下

Depends: +libc +USE_GLIBC:librt +USE_GLIBC:libpthread +netifd +jsonfilter +SIGNED_PACKAGES:usign +SIGNED_PACKAGES:openwrt-keyring +NAND_SUPPORT:ubi-utils +fstools +fwtool

总结：

生成.package-xxxx.tmp文件的关键地方就是调用xxxx模块自己的Makefile来生成

这些Makefile文件都在package下面，如：

package/base-files/Makefile

![](https://docimg10.docs.qq.com/image/AgAAEW1pnZiRe65tm95HHaai1_0x_o9Q.png?w=847&h=591)

# 4) 总结

a)整个编译框架如下

![](https://docimg4.docs.qq.com/image/AgAAEW1pnZjy47or9N1Gn5ZrHtaPOVtK.png?w=897&h=727)

c) 从world出发，大的编译框架就是target和package, target主要是去编译内核，package主要是去编译各种开源包

d) target/Makefile文件完成了taget/stamp-compile到target/compile的转变，同时target/compile这个目标是subdir函数动态生成的。

e) package/Makefile文件完成了package/stamp-compile到package/compile的转变，pakcage/compile有静态目标定义，也有动态定义，动态目标的生成也是subdir函数生成的

f) subdir函数动态生成目标体现了openwrt编译框架的核心，对于开源包言，开源包之间的依赖关系、开源包编译的依赖规则的生成都依赖每个包提供的makefile文件，如对于base-files这个包，依赖package/base-files/Makefile