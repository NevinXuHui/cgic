最近因为要使用实验室的集群服务器，必须配置一个 docker 镜像，整个过程还蛮麻烦的，我摸索了大半天才搞好，为了防止以后忘记，决定记录下来~~

**[Docker 教程 | 菜鸟教程 (runoob.com)](https://www.runoob.com/docker/docker-tutorial.html)**

**[关于 docker 容器和镜像的区别 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/120982681)**

关于 docker **镜像（image）和容器（container）到底是什么，我也不是很懂，我的理解是 docker 镜像类似于虚拟机镜像，是一个只读的文件，包含进程运行所需要的可执行文件、依赖软件、库文件、配置文件等等，而容器则是基于镜像创建的进程，我们可以利用容器来运行应用。总结来说，镜像是只读的，而容器是动态的，我们又可以基于容器创建新的镜像，而 docker 就是帮助我们实现这些功能的应用引擎。本教程的目标是配置一个可运行深度强化学习代码的镜像**。

P.S, 网上大部分教程介绍的都是通过 DockerFile 来配置镜像，我个人觉得这个方法太专业了，不适合普通人上手，我只是需要一个镜像用来跑 Python 代码就行了，完全不需要那么复杂的方法。其实配置一个镜像只需要以下几步：1. 从 docker hub 下载一个基础镜像；2. 在基础镜像的基础上安装 Python 代码所需要的 package；3. 更新镜像。理清楚了还是挺简单的~~

## **一、安装 Docker**

直接使用官方安装脚本自动安装即可

```Plain Text
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

```

测试一下 docker 是否安装成功：

```Plain Text
sudo docker help

```

使用`docker help`命令可查看 docker 的所有命令，说明已安装成功。

![](https://pic3.zhimg.com/v2-055c66f07342e33c9d0d9202a6b33b1a_r.jpg)

## **二、Docker 镜像加速**

国内从 DockerHub 拉取镜像有时会遇到困难，此时可以配置镜像加速器。例如：科大镜像，阿里云等等。

以阿里云为例，阿里云镜像获取地址：[https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)，登陆后，左侧菜单选中镜像加速器就可以看到你的专属地址了：

![](https://pic4.zhimg.com/v2-ee45bfff2e85fc24312c57ef717f4a9f_r.jpg)

然后在 /etc/docker/daemon.json 中写入如下内容（如果文件不存在请新建该文件）：

```Plain Text
{"registry-mirrors":["https://XXX.mirror.aliyuncs.com/"]}

```

之后重新启动服务：

```Plain Text
sudo systemctl daemon-reload
sudo systemctl restart docker

```

## **三、登录 Docker Hub**

Docker 官方维护了一个公共仓库 **[Docker Hub](https://hub.docker.com/)**，里边包含了大多数我们需要的基础镜像。

首先注册一个账号，然后在本地登录：

```Plain Text
sudo docker login

```

![](https://pic1.zhimg.com/v2-23fdabd8178cf34ca6d8ea1f8249c20c_r.jpg)

登录成功之后，我们就可以从 docker hub 上直接拉取自己账号下的全部镜像。

## **四、从 Docker Hub 下载基础镜像**

制作镜像是一件非常麻烦的事情，还好 Docker Hub 上有其他人已经配好的基础镜像，我们只需要在这些基础镜像上进行修改就可以了~

我需要在服务器上跑深度强化学习算法，所以需要一个有 pytorch-cuda 包的镜像，此时我们既可以直接在命令行搜索：

```Plain Text
sudo docker search torch1.9

```

也可以在网页上搜索：

![](https://pic1.zhimg.com/v2-daf0b0eeebf38cf4d18452f6671647b0_r.jpg)

从中选择一个合适的镜像下载即可

```Plain Text
sudo docker pull lingjunlh/torch1.9.1-cuda11.1

```

之后就是漫长的下载过程~

![](https://pic2.zhimg.com/v2-149853470c5655e91401aa0b1008f339_r.jpg)

这样我们就把这个镜像下载到了本地，使用`docker images`命令查看一下

```Plain Text
sudo docker images

```

![](https://pic3.zhimg.com/v2-2059789c6b1ad89030073e072c493b4e_r.jpg)

可以看到此时我们已经成功地把镜像下载到了本地

## **五、根据镜像创建容器**

镜像只是一个可读的配置文件，真正用来运行程序的是容器，因此我们需要根据镜像创建一个容器~

```Plain Text
sudo docker run -it lingjunlh/torch1.9.1-cuda11.1:v1 /bin/bash

```

参数说明：

- `-i`：交互式操作

- `-t`：终端

- `lingjunlh/torch1.9.1-cuda11.1:v1`：镜像名称：镜像标签

- `/bin/bash`：放在镜像名后的是命令，这里我们希望有个交互式 Shell，因此用的是 /bin/bash

![](https://pic4.zhimg.com/v2-12fc313454b268bfac0e87638b034bf7_r.jpg)

这样就进入了容器，该容器的 ID 是`26569156de64`，一个容器就相当于是一个进程，是镜像的实例化，里边包含了运行程序所需要的环境和配置环境，例如 python，conda，list 等等，我们可以在容器内执行命令，例如查看所安装的包`pip list`

![](https://pic1.zhimg.com/v2-c7003533e96e34985afd27a0d21abbfc_b.jpg)

## **六、在容器内安装所需要的包**

通常情况下，为了达到我们自己的目标，还需要在基础镜像的基础上安装新的包，这一过程可以直接在容器内进行，具体操作和在本地命令行操作一样，即直接在容器内通过`conda install`或者`pip install`。

![](https://pic1.zhimg.com/v2-a1b72659ed0274f6cb6d22d40b28d388_r.jpg)

安装完之后用`exit`命令退出容器

![](https://pic4.zhimg.com/v2-d38a346a00d401390f205faad0c3daef_b.jpg)

这样就又退回了本地命令行。

## **七、更新镜像**

容器是动态的，镜像是静态的。我们在容器里更新了 Python 包，为了以后可以持久地使用，还需要使用`commit`将容器打包为镜像。

```Plain Text
docker commit -m="update packages" -a="XXX" 26569156de64 XXX/pymarl:v1

```

各个参数说明：

- `-m`: 提交的描述信息

- `-a`: 指定镜像作者

- `26569156de64`：容器 ID

- `XXX/mypymarl:v1`: 指定要创建的目标镜像名（作者名 / 镜像名：标签）

![](https://pic3.zhimg.com/v2-2e27af40aed1d73fa96bf9a735b1b69a_r.jpg)

查看镜像，可以看到我们已经成功的构建了自己的镜像 pymarl:v1

![](https://pic4.zhimg.com/v2-dac91b0b60ab983dfc34211f2261dd73_r.jpg)

之后我们就可以直接利用该镜像创建容器，在容器里跑代码啦~

## **八、在本地使用容器运行代码**

为了测试镜像能否正常运行我们的代码，可以现在本地用容器测试一下。

首先我们需要创建一个本地 Ubuntu 系统和 docker 容器共享的文件夹：

```Plain Text
sudo mkdir /data
sudo docker run -v /data:/data -itd zhouxuanhan/pymarl:v1 bash

```

![](https://pic3.zhimg.com/v2-966629e811debcef0ba4c8b079dac61e_r.jpg)

然后将代码文件复制到 Ubuntu 系统的`/data`目录下，这样该目录就和容器内部的`/data`目录连通了。

查看此时正在运行的容器

```Plain Text
sudo docker ps 

```

![](https://pic2.zhimg.com/v2-dbdd35b47aa5d9e0f1e52703e631755d_r.jpg)

该容器就是我们刚刚所创建的用于本地测试代码的容器，用`docker attach`进入容器

```Plain Text
sudo docker attach 500ad76de1cf

```

![](https://pic4.zhimg.com/v2-e311c78ceebb821030f7124b44e40193_r.jpg)

之后的步骤就是与在本地系统命令行的操作一样，进入代码的文件夹，用`python`命令执行代码

![](https://pic2.zhimg.com/v2-55247f8308a3df70fb548d3f6fc37de5_r.jpg)

## *** 九、安装 nvidia-cuda**

Docker 默认是不支持在容器内 GPU 加速的，从上一张图标黄的语句也可以看出，在 docker 容器中运行代码会显示没有 cuda。还好 NVIDIA 官方做了个工具箱来支持容器内 GPU 加速运算，这大大方便了深度学习开发者。这里直接根据官方教程安装即可。

**[Installation Guide — NVIDIA Cloud Native Technologies documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#installing-on-ubuntu-and-debian)**

（这一步其实可以省略，因为我们实验室集群在使用的时候会自动调用 GPU，这里只是为了在本地 Ubuntu 系统下运行容器也可以调用 GPU）

安装完 nvidia-cuda 之后，再创建容器时加上`--gpus all`，即可在容器内调用 cuda，即

```Plain Text
sudo docker run -v /data:/data -itd -gpus all zhouxuanhan/pymarl:v1 bash

```

其他步骤和上一节一样。

## *** 十、推送镜像到 Docker Hub**

```Plain Text
sudo docker push XXX/pymarl:v

```

## **常见命令**

### **1. 查看所有镜像**

```Plain Text
docker images

```

### **2. 查找镜像**

```Plain Text
docker search XXXimage

```

### **3. 下载镜像**

```Plain Text
docker pull XXXimages:tag

```

### **4. 删除镜像**

```Plain Text
docker rmi XXXimages:ta

```

### **5. 启动容器**

```Plain Text
docker run -it image:tag /bin/bash

```

### **6. 退出容器**

```Plain Text
exi

```

### **7. 查看正在运行的容器**

```Plain Text
docker p

```

### **8. 进入正在运行的容器**

```Plain Text
docker attach container_ID

```

### **9. 查看已停止运行的容器**

```Plain Text
docker ps -a

```

### **10. 启动已停止的容器**

```Plain Text
docker start container_ID

```

### **11. 停止容器**

```Plain Text
docker stop container_ID

```

### **12. 重启已停止容器**

```Plain Text
docker restart container_I

```

### **13. 退出容器终端（但不停止）**

```Plain Text
docker exec

```

### **14. 更新镜像**

先用镜像创建容器

```Plain Text
docker run -it image:tag /bin/bash

```

在容器内操作

然后 commit 提交容器副本创建新的镜像

```Plain Text
docker commit -m='description' -a='author' container_ID author/image:tag2 

```

## **总结**

总结一下，镜像实际上就是一个虚拟的操作系统，容器是镜像的实例化，在容器里操作和在本地系统的命令行操作没有任何区别，容器如果发生了改变，可以直接 commit 成新的镜像，方便下一次使用~

