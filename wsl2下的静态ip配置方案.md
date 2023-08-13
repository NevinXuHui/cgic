[# ](logseq://graph/Obsidian_data?page=# )
[### 通过启动脚本 配置  /etc/resolv.conf文件信息  最终目的是配置dns地址为  192.168.11.100](logseq://graph/Obsidian_data?page=### 通过启动脚本 配置  /etc/resolv.conf文件信息  最终目的是配置dns地址为  192.168.11.100)


[```](logseq://graph/Obsidian_data?page=```)
[#! /bin/sh](logseq://graph/Obsidian_data?page=#! /bin/sh)

[# 启动对应服务](logseq://graph/Obsidian_data?page=# 启动对应服务)
[#service ssh ${1}](logseq://graph/Obsidian_data?page=#service ssh ${1})
[#service docker ${1}](logseq://graph/Obsidian_data?page=#service docker ${1})

[# 设置本地Wsl2域名，默认为wsl2host](logseq://graph/Obsidian_data?page=# 设置本地Wsl2域名，默认为wsl2host)
[ipaddr=$(ip -4 addr show dev eth0 | grep -E 'inet ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})' | awk '{print $2}' | awk -F/ '{print $1}')](logseq://graph/Obsidian_data?page=ipaddr=$(ip -4 addr show dev eth0 | grep -E 'inet ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})' | awk '{print $2}' | awk -F/ '{print $1}'))
[hostName='wsl2host'](logseq://graph/Obsidian_data?page=hostName='wsl2host')
[sed -i '/wsl2host/d' /mnt/c/Windows/System32/drivers/etc/hosts](logseq://graph/Obsidian_data?page=sed -i '/wsl2host/d' /mnt/c/Windows/System32/drivers/etc/hosts)
[echo "${ipaddr} ${hostName}" >> /mnt/c/Windows/System32/drivers/etc/hosts](logseq://graph/Obsidian_data?page=echo "${ipaddr} ${hostName}" >> /mnt/c/Windows/System32/drivers/etc/hosts)

[sed -i '/wsl2host/d' /etc/hosts](logseq://graph/Obsidian_data?page=sed -i '/wsl2host/d' /etc/hosts)
[echo "${ipaddr} ${hostName}" >> /etc/hosts](logseq://graph/Obsidian_data?page=echo "${ipaddr} ${hostName}" >> /etc/hosts)

[echo "nameserver 192.168.11.100" > /etc/resolv.conf](logseq://graph/Obsidian_data?page=echo "nameserver 192.168.11.100" > /etc/resolv.conf)

[```](logseq://graph/Obsidian_data?page=```)
