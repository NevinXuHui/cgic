### 1、安装samba   这个应该没问题
### 2、配置/etc/samba/smb.conf  这个应该也没问题
### 3、这里需要启动的服务是  smb  nmb   不是samba哦

### 4、创建用户   smbpasswd -a _samba_user

smbpasswd -a _samba_user_

[myshare]
   comment = Mary's and Fred's stuff
   path = /mine
   valid users = arch
   public = yes
   writable = yes
  #printable = no
   create mask = 0765

不能用printable    会出现问题


配置问题模板地址：
https://git.samba.org/samba.git/?p=samba.git;a=blob_plain;f=examples/smb.conf.default;hb=HEAD
