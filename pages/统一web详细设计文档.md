# 1. 整体设计流程

#### 1.1 统一 web 后端服务器
采用 uhttpd 作为 web 服务器，作为优秀稳定的、适合嵌入式设备的轻量级任务的 HTTP 服务器，当前只需要 ubus 相关库（ **<span style="background:#00ff00">json-c,libubox,ubus 等</span>**  ）的支持，即可满足当前业务的需求。
提供单执行文件及相关动态库，厂家需要按照最新接口规范  **《智能组网操作系统集成规范 V 1.5.1》**     实现全部的 ubus 接口，直接运行即可。

##### 相关文件列表：
```
├── uhttpd
└── uhttpd_ubus. so
```

uhttpd：web 服务器主程序，厂家加入到启动脚本，并将该进程加入守护进程中
uhttpd_ubus. so: 与 ahsapd 相关接口交互的功能实现库，厂家需要将该文件放置到<font color=#ed1c24>LD_LIBRARY_PATH</font>环境变量设置的文件路径下。后续的接口更新及界面功能的增加，更新该库及前端页面即可。

|  参数  |  功能                       |    |
|:-----|:--------------------------|:---|
|  -p  |  http端口设置，默认为80           |    |
|  -f  |  客户请求强制进行fork， 默认关闭       |    |
| -u   | 当前ubus相关接口请求的路径前缀，当前为/api |    |
| -h   | 前端页面路径                    |    |  

##### 举例如下：

```
uhttpd -p80 -f -u/api -h/web
```


#### 1.2 统一 web 的前端页面
当前大小为8M 左右，分为手机端及电脑端，用户通过不同的浏览器登陆首页，会自动跳转到特定页面。
##### 相关文件列表：
```
├── wifiRouterMobile
│   ├── 033abe60fb048661a6a32a0b2b4a5cae.png
│   ├── 2b61b5a28ffff4477f005d528d10a884.png
│   ├── 489426c249ee2b757e3f3f2d8262f6d3.png
│   ├── 5f5b9f5b390896e448c6925853af01db.png
│   ├── 8dc3621204d9b8626d4e0cbb0fdd9b76.png
│   ├── a12debdbecdcec12975e2717de8173f2.png
│   ├── ab788ba9218f314f8d79948f721f06d1.png
│   ├── commons.css
│   ├── commons.js
│   ├── e9f778435207731f50d8c9b38232f2da.png
│   ├── favicon.ico
│   ├── pages
│   ├── vendor.css
│   └── vendor.js
├── wifiRouterWeb
│   ├── 015392a2b29ec4243cb51b3a16d4a81c.png
│   ├── 0463e4ea0c514b9b5786a04dec82e9f2.png
│   ├── 100994036d89c638db29fb9e60a07aee.png
│   ├── 12c8e9f9f7c443dee9a627fa242dbc4b.png
│   ├── 133515f8112afe7589137ed693dc4496.png
│   ├── 175854d7c2fef8f977392080b44edcf6.png
│   ├── 1ba8c9017144d9767502ce53f3985392.png
│   ├── 1c2115ba3983dc0a670c7f5a1529eb8e.png
│   ├── 21fc2bb98a60192f577830f1d707552e.png
│   ├── 2587a9b06beee34a4bcd5be4727371a9.png
│   ├── 2e8115ec08127528d64fdeee941f072d.png
│   ├── 2fe31de9d920fd6a3f9920abedd28e0c.png
│   ├── 35a177123e3f0f7ab705451b419c3917.png
│   ├── 385e4433bcb92b02bb3449268e9d6174.png
│   ├── 3c5217814b638949bfdd4b729d680794.png
│   ├── 42a23da715bceee0f1c9fcc3af1bbcf0.png
│   ├── 43f203346ea094099c20cad8091de861.png
│   ├── 440777ce093fd592ee8750de54bac21b.png
│   ├── 51d82037461e7eab10e11ce041c547ca.png
│   ├── 5f5b9f5b390896e448c6925853af01db.png
│   ├── 60caae32f3c23bc98d3203d9936fc169.png
│   ├── 68119dc89daa40440123366f48819fde.png
│   ├── 684b2abef68c1d44577d01757f711061.png
│   ├── 6c6a9dc655d49ac02586953808ef6e34.png
│   ├── 764a0281334de3eba071c9a6f3ce43ef.png
│   ├── 843d50732c7aa7a812d07d0fdd32319a.png
│   ├── 8d3bb29e1f3dd70a4329134223a68995.png
│   ├── 8dc3621204d9b8626d4e0cbb0fdd9b76.png
│   ├── 90f7bcf74759383655fb781a3d0dda1e.png
│   ├── 935546bc12fe5d7bf9d10bd2a79c629e.png
│   ├── 945e9c9e76fa0222a4dfe328128857ce.png
│   ├── 977b9a89f34f7952d2e11222a7c524f9.png
│   ├── 99293785ce56584aa864181538159f8b.png
│   ├── 9f2da4a1faecbd4959b84d62ae4dc701.png
│   ├── 9fa0e28ae175be144f89a2bb6cdf0e17.png
│   ├── a31e393884af2836f0c99d563852dfa5.png
│   ├── b14324c0192d29aff06ea03b4c3c1c7b.png
│   ├── b6bf7270e0c41331b99718cb8472d054.png
│   ├── bd19a6c971985dcb309dceb47bb5db75.png
│   ├── c1127d387ce3ca60cceeb8f65dfdf8c7.png
│   ├── c3c6c40733687cb6c371b437bf0b49db.png
│   ├── ce15e7977ff57e47c0450ed40cd9847c.png
│   ├── commons.css
│   ├── commons.js
│   ├── commons.js.gz
│   ├── d9427e4b453817ed3d1bbbacc3e484b3.png
│   ├── dc2b60eeb8c75cb243f3b541a7890156.png
│   ├── dcc9b6bf5d5e1862e3e6fa30680feac9.png
│   ├── de51fed0b036347336d8960747c78c96.png
│   ├── dff256559da77ee419188fe53ecd7e77.png
│   ├── e206567e0c7b3fc895c149492d75c501.png
│   ├── e5840adabb8f1050603ad75c2da373fb.png
│   ├── e8840fdaf6a088e99dcb555222837808.png
│   ├── e8fb3c1cff5fd2ac84cb586e4fa90a4f.png
│   ├── e9f778435207731f50d8c9b38232f2da.png
│   ├── eb3586326fe8c60d0ecb2b7d7459a35c.png
│   ├── favicon.ico
│   ├── fec5a858fc84c9f9998ce4bb7edcec6d.png
│   ├── logo1.png
│   ├── logo2.png
│   ├── logo.png
│   ├── pagest
│   ├── vendor.css
│   ├── vendor.css.gz
│   ├── vendor.js
│   ├── vendor.js.gz
│   ├── vendor.js.sync-conflict-20230919-203618-MRXIPY4.gz
│── └── vendor.sync-conflict-20230919-203617-MRXIPY4.js

```

#### 后续需要厂家适配的内容

1、需要厂家提供自己公司图标,格式为 PNG, 高度为 32像素，长度厂家可以按照自己的要求裁剪,命名为 logo.png,放置到前端页面的根目录，包括手机侧和 PC 侧. 要求背景适配当前的 web 页面的主题。
2、登陆初始密码预置, 根据最新的接口规范，预置 web 登入密码，要求与设备铭牌上的登陆密码一致，可通过相关 ubus 接口获取。

```
object： ahsapd.advanced 
method： getWebLogin
```
 
3、实现新增的相关接口




# 2. 相关接口实现方案
##  1.1 获取当前请求设备信息
路径：
```
getRequestDeviceInfo
```

web_api_get_request_device_info

## 1.2 获取周边wifi信息
路径：

```
{ "getNeighborInfo", 
```



web_api_get_neighbor_info }, 

##  1.3 web登录验证
路径：

```
{ "login"
```

, web_api_login }, 


## 1.4 配置组网设备wifi信息
路径：

```
{ "configWifiInfo"
```

, web_api_config_wifi_info }, 

##  1.5 获取组网设备wifi信息
路径：

```
{ "getWifiInfo"
```

, web_api_get_wifi_info }, 

##  1.6 配置上网设置页
路径：

```
{ "configWorkMode"
```

, web_api_config_workmode }, 


##  1.7 获取上网设置页
路径：
{ "getWorkMode", web_api_get_workmode }, 

##  1.8 获取设置完成状态
路径：

```
{ "getSetUpdateStatus"
```

, web_api_get_setupdate_status }, 

## 1.9 获取下挂设备列表信息
路径：

```
{ "getStaInfo"
```

, web_api_get_sta_info }, 
## 1.10 ping诊断
路径：

```
{ "pingTest"
```

, web_api_ping_test }, 

{ "pingTest2", web_api_ping_test }, // 1.10 ping诊断
## 1.11 traceroute诊断
路径：

```
{ "traceRouteTest"
```


, web_api_trace_route_test }, 
 1.11 traceroute诊断
{ "traceRouteTest2", web_api_trace_route_test }, 
## 1.12 获取设备基本信息
路径：

```
{ "getDeviceBasicInfo",
```


web_api_get_device_basic_info }, 
## 1.13 配置下挂设备是否允许联网
路径：

```
{ "configDeviceInternetWorking",
```


web_api_config_device_internet_working }, 
## 1.14 获取路由器状态
路径：

```
getDeviceStatus
```


web_api_get_device_status }, 
## 1.15 获取健康模式配置信息
路径：

```
getHealthModeInfo
```


web_api_get_healthmode_info },
## 1.16 配置健康模式任务
路径：

```
configHealthModeTask
```


web_api_config_healthmode_task }, 
## 1.17 删除健康模式任务
路径：

```
{ "deleteHealthModeTask", 
```


web_api_delete_healthmode_task }, 
## 1.18 获取静态IP绑定设备信息
路径：

```
{ "getStaticIPInfo"
```


, web_api_get_staticIP_info },
## 1.19 配置静态IP
路径：

```
{ "configStaticIP"
```


, web_api_config_staticIP }, 
## 1.20 删除静态IP
路径：

```
{ "deleteStaticIP"
```


, web_api_delete_staticIP }, `
## 1.21 修改登录密码
路径：

```
{ "updateLoginPassword",
```


web_api_update_login_password },
## 1.22 设备一键重启
路径：

```
{ "deviceReboot",
```


web_api_device_reboot }, 
## 1.23 获取重启任务配置信息
路径：

```
{ "getRebootTaskInfo",
```


web_api_getreboot_task_info }, 
## 1.24 配置重启任务
路径：

```
{ "configRebootTask
```


", web_api_config_reboot_task },
## 1.25 删除重启任务
路径：

```
{ "deleteRebootTask",
```


web_api_delete_reboot_task }, 
## 1.26 获取组网设备led灯控
路径：

```
{ "ledStatus
```


", web_api_led_status }, 
## 1.27 设置组网设备led灯控

路径：
```
{ "ledControl"
```


, web_api_led_control }, 
## 1.28 导入配置文件接口

{ "importCfgFile"

, web_api_import_cfgfile }, 
## 1.29 导出配置文件接口
{ "exportCfgFile

", web_api_export_cfgfile }, 
## 1.30 恢复出厂设置
{ "deviceReset"

, web_api_device_reset }, 
## 1.31 一键诊断
{ "onekeyTest

", web_api_onekey_test }, 
## 1.32 导出日志到本地接口
{ "exportLogFileLocal",

web_api_export_logfile_local }, 
## 1.33 导出日志到平台接口
{ "exportLogFilePlatform"

, web_api_export_logfile_platform }, 
## 1.34 获取黑白名单
{ "getMacFilter"

, web_api_get_mac_filter }, 
## 1.35 配置黑白名单
{ "configMacFilter"

, web_api_config_mac_filter }, 
## 1.36 删除黑白名单
{ "deleteMacFilter"

, web_api_delete_mac_filter }, 
## 1.37 获取上网保护配置信息
{ "getDeviceLimitInfo"

, web_api_get_device_limit_info }, 
## 1.38 配置上网保护规则
{ "configDeviceLimit

", web_api_config_device_limit }, 
## 1.39 删除上网保护规则
{ "deleteDeviceLimit

", web_api_delete_device_limit }, 
## 1.40 获取组网设备IPTV配置信息
{ "getIPTVInfo

", web_api_get_iptv_info }, 
## 1.41 配置组网设备iptv
{ "configIPTVInfo

", web_api_config_iptv_info }, 
## 1.42 Lan侧地址信息配置
{ "configLanAddress"

, web_api_config_lan_address },
## 1.43 Lan侧地址信息获取
{ "getLanAddress"

, web_api_get_lan_address }, 
## 1.44 设备信息-基本信息
{ "deviceBasicInfo"

, web_api_device_basic_info }, 
## 1.45 设备信息-WAN状态
{ "deviceWanStatus

", web_api_device_wan_status }, /
## 1.46 设备信息-LAN状态
{ "deviceLANStatus"

, web_api_device_lan_status },
## 1.47 设备信息-wifi状态
{ "deviceWiFiStatus

", web_api_device_wifi_status }, 
## 1.48 设备信息-报文统计
{ "deviceStatsInfo

", web_api_device_stats_info }, 
## 1.49 获取升级设备列表
{ "upgradeDeviceList

", web_api_upgrade_device_list }, 
## 1.50 设备升级_升级文件上传
{ "firmwareUpload"

, web_api_firmware_upload }, 
## 1.51 获取升级状态
{ "upgradeStatus"

, web_api_upgrade_status }, 
## 1.52 获取路由器当前时间
{ "getNTPTime

", web_api_get_ntp_time }, 
## 1.53 同步路由器网络时间接口
{ "configNTPTime

", web_api_config_ntp_time }, 
## 1.54 获取DNS地址列表
{ "getDNSList"

, web_api_get_dns_list }, 
## 1.55 配置DNS地址
{ "configDNSAddress"

, web_api_config_dns_address }, 
## 1.56 获取mesh拓扑结构
{ "getMeshTopology

", web_api_get_mesh_topology }, /
## 1.57 配置mesh角色
{ "configMeshRole

", web_api_config_mesh_role }, 
## 1.58 获取mesh状态信息
{ "getMeshInfo"

, web_api_get_mesh_info }, 
## 1.59 设置DMZ
{ "configDMZ

", web_api_config_dmz }, 
## 1.60 获取DMZ
{ "getDMZ"

, web_api_get_dmz }, 
## 1.61 设置UPnP
{ "configUPnP

", web_api_config_upnp }, 
## 1.62 获取UPnP
{ "getUPnP

", web_api_get_upnp }, 
## 1.63 删除UPnP项
 //{ "deleteUPnP
 
 ", web_api_delete_upnp }, 
## 1.64 获取iot专属通道信息
{ "getIOTChannel

", web_api_get_iot_channel }, 

{ "test", web_api_test },