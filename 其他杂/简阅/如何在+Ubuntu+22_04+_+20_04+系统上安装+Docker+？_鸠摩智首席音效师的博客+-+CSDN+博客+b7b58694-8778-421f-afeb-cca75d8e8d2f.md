### 什么是 Docker ?

Docker 是一个免费的开源工具，设计用于在容器中构建、部署和运行应用程序。安装 docker 的主机是已知的 docker 引擎。Docker 使用操作系统级[虚拟化](https://so.csdn.net/so/search?q=%E8%99%9A%E6%8B%9F%E5%8C%96&spm=1001.2101.3001.7020)，并提供容器运行时环境。换句话说，Docker 也可以被定义为 PaaS(平台即服务) 工具。

因为 docker 是一个基于[守护进程](https://so.csdn.net/so/search?q=%E5%AE%88%E6%8A%A4%E8%BF%9B%E7%A8%8B&spm=1001.2101.3001.7020)的服务，所以要确保 docker 服务启动并运行。当你启动一个需要多个容器的应用程序，而这些容器之间有依赖关系时，在这种情况下，docker 组合就是解决方案。

在本指南中，我们将逐步介绍如何在 Ubuntu 22.04 (Jammy Jellyfish) 上安装 Docker。这些也适用于 Ubuntu 20.04 (Focal Fossa)。

### 必备条件

- Ubuntu 22.04 / 20.04 along with ssh access

- sudo user with privilege rights

- Stable Internet Connection

### (1) 安装 Docker 依赖项

登录到 Ubuntu 22.04 /20.04 系统，并运行以下 APT 命令以安装 Docker 依赖项

```Plain Text
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

```

### (2) 启用 Docker 官方存储库

虽然 docker 包在默认的包存储库中可用，但建议使用 docker 官方存储库。要启用 docker 存储库，请运行以下命令

```Plain Text
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

```

### (3) 使用 Apt 命令安装 Docker

Docker 有两个版本：社区版和企业版。我们将安装社区版，运行下面的命令

```Plain Text
sudo apt-get update
sudo apt install docker-ce docker-ce-cli containerd.io -y
```

docker 包安装完成后，请将本地用户加入 docker 组，以便该用户无需 sudo 即可执行 docker 命令

```Plain Text
sudo usermod -aG docker $USER
newgrp docker
```

**注意:** 将本地用户添加到 docker 组后，请确保注销并再次登录

通过执行以下命令验证 Docker 版本

```Plain Text
docker version
```

![](https://img-blog.csdnimg.cn/img_convert/2e5405dd4e992319b5c4c7c7c648ace9.jpeg)

验证 docker 守护进程服务状态，执行 systemctl 命令

```Plain Text
sudo systemctl status docker
```

![](https://img-blog.csdnimg.cn/img_convert/2ac23ee2d5ce084378fa971e43b58583.jpeg)

以上输出确认 docker 守护进程服务已启动并正在运行

### (4) 验证和测试 Docker

要测试和验证 docker，使用下面的 docker 命令启动一个 hello-world 容器

```Plain Text
docker run hello-world
```

上面的 docker 命令将下载 hello-world 容器镜像，然后将启动一个容器。如果容器显示提示信息，那么我们可以说 docker 安装成功了。以上 docker 运行的输出如下所示。

![](https://img-blog.csdnimg.cn/img_convert/4ced96f6019ce7080d3f20cfc2512f02.jpeg)

### 安装 Docker Compose

在 Ubuntu Linux 上安装 docker compose，请依次执行以下命令

```Plain Text
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

运行如下命令检查 docker-compose 版本

```Plain Text
docker-compose --version
docker-compose version 1.29.2, build cabd5cfb
```

很好，上面的输出确认安装了 1.29.2 版本的 docker-compose

### 测试 Docker Compose

To test docker compose, let’s try to deploy WordPress using compose file. Create a project directory ‘wordpress’ using mkdir command.

为了测试 docker-compose，我们使用 docker-compose.yaml 文件部署 WordPress，使用 mkdir 命令创建一个 wordpress 目录

```Plain Text
mkdir wordpress ; cd wordpress
```

创建一个带有以下内容的 Docker-compose.yaml 文件

```Plain Text
vim docker-compose.yaml
```

```Plain Text

version: '3.3'

services:
   db:
     image: mysql:latest
     volumes:
       - db_data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: sqlpass@123#
       MYSQL_DATABASE: wordpress_db
       MYSQL_USER: dbuser
       MYSQL_PASSWORD: dbpass@123#
   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - "8000:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: dbuser
       WORDPRESS_DB_PASSWORD: dbpass@123#
       WORDPRESS_DB_NAME: wordpress_db
volumes:
    db_data: {}
```

保存并关闭该文件

![](https://img-blog.csdnimg.cn/img_convert/60cde06582c1dff8065e5e5c31ed4bb9.jpeg)

正如我们所看到的，我们使用了两个容器，一个用于 WordPress web，另一个用于数据库。我们还为 DB 容器创建了持久卷，WordPress web 暴露在 8000 端口上。

要部署 WordPress，请在 wordpress 目录中运行以下命令

```Plain Text
docker-compose up -d
```

以上命令的输出如下所示

[外链图片转存失败, 源站可能有防盗链机制, 建议将图片保存下来直接上传 (img-D5ExOZG1-1671158358950)([https://portal-1255691183.file.myqcloud.com/img/content/637f0c8e005e9.jpg](https://portal-1255691183.file.myqcloud.com/img/content/637f0c8e005e9.jpg))]

以上确认两个容器已经成功创建。现在尝试通过输入 URL 从 Web 浏览器访问 WordPress

```Plain Text
http://:8000
```

![](https://img-blog.csdnimg.cn/img_convert/0f64558010a1de052004002f23b28b15.jpeg)

完美，以上证实了 WordPress 的安装是通过 docker-compose 启动的。单击 Continue 并按照屏幕指示完成安装。

### 我的开源项目

![](https://img-blog.csdnimg.cn/img_convert/e8aefccf98e345405ae5571f163502af.png)

- [course-tencent-cloud（酷瓜云课堂 - gitee 仓库）](https://gitee.com/koogua/course-tencent-cloud)

- [course-tencent-cloud（酷瓜云课堂 - github 仓库）](https://github.com/xiaochong0302/course-tencent-cloud)

