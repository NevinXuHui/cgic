```
ubus call ahsapd.qos getQosConfig
```

ubus call network.device status '{"name":"lo"}' 截取了lo设备的信息 


ubus call network.interface status '{"interface":"lan"}' 等价于 ubus call network.interface.lan status 

ubus call ahsapd.config deleteItem '{ "item": "test"}' 

ubus call ahsapd.config getItem '{ "item": "test"}'    

ubus call ahsapd.macfilter setMacFilter '{ "macFilterEnable":1,"macFilterPolicy":1,"macFilterEntries ":"String"}' 


ubus -v list   列出所有项 


ubus call ahsapd.basic getBasicInfo  

ubus call ahsapd.hardware getHardware 
 

ubus call ahsapd.roaming getRoamingConfig 


ubus call ahsapd.roaming setRoamingConfig '{"roamingSwitch":1,"lowRSSI2.4G":-80,"lowRSSI5G":-85}' 

 
 

ubus call ahsapd.roaming getBandSteeringConfig 

ubus call ahsapd.roaming  setBandSteeringConfig '{"bandSteeringStatus":1,"rssiThreshold":-60,"rssiThreshold5G":-40}' 

ubus call ahsapd.roaming getBandSteeringConfig 


ubus call ahsapd.config getCfgPath '{"fileType":1}' 


ubus call ahsapd. control getMulticastEnable 


 
getHardware 

 

ubus call ahsapd.port getPortInfo 

 

ubus call ahsapd.timedtask getTimedTask  

 

ubus call ahsapd.timedtask addTimedTask  '{"taskId":1,"timeOffset":0,"week":2,"enable":1,"action":1,"index":87987}' 


 ubus call ahsapd .timedtask addTimedTask '{"taskId":1,"timeOffset":0,"week":2,"enable":1,"action":1,"index":87987,"test_table":{"taskId":88223322,"timeOffset":47678},"test_array":[{"taskId":8822332"timeOffset":47678}]}' 


ubus call ahsapd.config  getCfgPath '{"fileType": 1}' 


ubus call ahsapd.config  getItem '{"item":"logininfo"}' 


ubus call ahsapd.config addItem '{"item":"logininfo2","value":"12334566"}' 


ubus call ahsapd.uplink getUplinkInfo 


ubus call ahsapd.sta    getStaNum 


ubus call ahsapd.uplink  setWorkingMode '{"workingMode":1","internetType":0"}' 

ubus call ahsapd.control  getMulticastEnable 

ubus call ahsapd.control  setMulticastEnable  '{"multicastEnable":0}' 


ubus call ahsapd.qos getQosConfig 

 

来自 <https://d.docs.live.net/b2bc8c9a7b82d807/AOS_NET2/规范/中国移动智能组网业务中间件集成规范V1.4.9（1123）.docx>  

 
 

来自 <https://d.docs.live.net/b2bc8c9a7b82d807/AOS_NET2/规范/中国移动智能组网业务中间件集成规范V1.4.9（1123）.docx>  

 

ubus call ahsapd. 

 
 

 

stanum 
```
