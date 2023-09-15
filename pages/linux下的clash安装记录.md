## 安装clash

例如相关文件夹  为   /mine/code/clash/clash_premium_installer


```
./installer.sh install
```


因不可抗拒的原因  不能通过网络下载的方式下载相关执行文件 采用提前下载方式    修改相关文件夹路径 需要修改install.sh脚本内容 

![[Pasted image 20230908130322.png]]



## 安装前台控制YACD



```
yay  docker
```

```



```

```
systemctl enable  docker
```

```


```

```
systemctl  start docker
```

```


```text
docker run -p 1234:80 -d --name yacd --rm ghcr.io/haishanh/yacd:master
```


## 登陆 YACD验证是否正确
浏览器登陆   

```
172.0.0.1:1234
```
出现以下界面表示安装成功

![[Pasted image 20230908130722.png]]
## 配置相关clash启动项
文件夹下的config.yaml 复制到 /srv/clash/的文件夹下

启动clash进程


```
systemctl  enable  clash
```


```
systemctl start clash
```

## 代理服务器环境变量设置
将以下命令复制到某一个启动脚本  例如  /etc/profile文件夹下 

```
export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"
export no_proxy="localhost, 127.0.0.1"
```


  ## 浏览器代理服务器设置
  ![[Pasted image 20230908131211.png]]

##  最最最最重要  
重启  


##   关闭

```
systemctl stop  clash
```


```
unset http_porxy
```


```
  unset https_porxy
```

浏览器关闭代理设置