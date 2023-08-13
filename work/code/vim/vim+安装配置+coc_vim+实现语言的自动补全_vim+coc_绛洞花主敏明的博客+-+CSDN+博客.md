coc.nvim 是一个 vim 以及 neovim 的自动补全插件。

具体安装的官方 wiki：
[https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim](https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim)

## vim 版本要求

```Plain Text
neovim >= 0.3.1
vim >= 8.1
```

## 1. 依赖安装

**安装 nodejs 和 yarn**

```Plain Text
curl -sL install-node.now.sh | sh
curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

```

不过我安装一直下载不成功，所以使用离线的方式

**一、离线安装 nodejs**

在[官网](https://nodejs.org/zh-cn/download/)下载 node-v16.13.0-linux-x64.tar.xz

在 /usr/local 下进行解压

```Plain Text
[root@VM-4-12-centos local]# tar -xvf node-v16.13.0-linux-x64.tar.xz 
[root@VM-4-12-centos local]# mv node-v16.13.0-linux-x64 nodejs

```

建立软连接，变为全局

```Plain Text
[root@VM-4-12-centos bin]# cd /usr/local/nodejs/bin
[root@VM-4-12-centos bin]# ln -s /usr/local/nodejs/bin/npm /usr/local/bin
[root@VM-4-12-centos bin]# ln -s /usr/local/nodejs/bin/node /usr/local/bin

```

检验 nodejs 是否已变为全局

```Plain Text
[root@VM-4-12-centos bin]# node -v
v16.13.0

```

**二、离线安装 yarn**

从官网下载源码包并上传到目标服务器
[https://yarnpkg.com/latest.tar.gz](https://yarnpkg.com/latest.tar.gz)

解压程序包到目标目录

```Plain Text
tar zvxf yarn-v1.12.3.tar.gz -C /opt

```

设置环境变量 vim /etc/profile，将下面代码添加到文件最后

```Plain Text
export NODEJS_HOME=/opt/yarn-v1.12.3/bin
export PATH=$NODEJS_HOME:$PATH

```

刷新文件配置

```Plain Text
. /etc/profile

```

运行命令来测试 Yarn 是否安装：

```Plain Text
yarn --version

```

## 2. 安装 coc.nvim 插件

在使用 vim-plug 管理 vim 插件的话
在 vimrc 中添加

```Plain Text
Plug 'neoclide/coc.nvim', {'branch': 'release'}

```

然后运行

```Plain Text
:PlugInstall

```

## 3. 安装后检查

打开 vim
执行

```Plain Text
:CocInfo##测试是否安装成功

```

如果有异常会列出异常情况，并给出解决方案，按照上面的命令执行，基本就可以解决安装过程中的异常。

## 4. 语言支持

要让 coc.nvim 支持某个语言，需要在配置文件中写上关于文件的配置。
打开 vim，执行

```Plain Text
:CocConfig

```

打开配置文件，配置文件格式为 json。

在下面的 wiki 中，找到不同语音的配置，复制到自己的配置中。并安装对应的 language-server 即可。（不同的 server 安装方式不同。具体见里面的 wiki）
[https://github.com/neoclide/coc.nvim/wiki/Language-servers](https://github.com/neoclide/coc.nvim/wiki/Language-servers)

**#vim 下输入**

```Plain Text
:CocInstall coc-clangd##安装 C/C++/Objective-C 扩展

```

## 5. 安装 clangd

安装 Clangd（C/C++ 语言服务器）
coc-nvim 插件基于语言服务器协议（Language Server Protocol，LSP）提供代码提示，所系需要安装对应的语言服务器。

从 github 下载 Clangd

```Plain Text
wget https://github.com/clangd/clangd/releases/download/11.0.0/clangd-linux-11.0.0.zip

```

解压文件

```Plain Text
unzip clangd-linux-11.0.0.zip
mv clangd_11.0.0/ /usr/share/

```

创建软连接

```Plain Text
ln -s /usr/share/clangd_11.0.0/bin/clangd /usr/bin/clangd
clangd

```

报错

```Plain Text
clangd: /lib64/libc.so.6: version `GLIBC_2.18' not found (required by clangd)

```

解决

```Plain Text
wget http://mirrors.ustc.edu.cn/gnu/libc/glibc-2.18.tar.gz
tar -zxvf glibc-2.18.tar.gz
cd glibc-2.18/
mkdir build
cd build
../configure --prefix=/usr

```

编译大概 5 分钟

```Plain Text
make -j4

```

安装大概 2 分钟

```Plain Text
sudo make install

```

## 三、补充离线安装 coc 插件方法

为了能快速开发代码，可以使用的 vim-snippets 插件进行安装，不过 vim-snippets 只是一个公共的补全的库（自己也可以定义需要补充的内容，在. vimrc 文件中进行配置路径即可）
此时可以通过两种方式实现对代码的自动补充、、

1、安装补全代码的引擎，如：SnipMate, Neosnippet, Xptemplate
2、安装 coc 的补全插件，coc-snippets

个人推荐使用`coc`的补全插件这种方式，采用第一种方式进行补全，一般需要设置一个激活的按键，即每次需要补全时按下按键，即可补全，第二种方式是在写代码过程中自动提示，只需要在候选框选择是否选择自己设置的补全还是库函数提供的补全方式即可。第一种安装插件的方式为`plugInstall`安装，以下主要介绍第二种 coc 插件的安装方式

**1、有网环境**
如果在有网的环境下可以通过以下方式安装`coc-snippets`

```Plain Text
：CocInstall coc-snippets

```

**2、无网环境**

方式一：在有网环境中已经下载安装好的插件移植过来。

安装的插件是在家目录下 `.config/coc`
可以将整个`coc`文件夹进行复制，在无网环境导入其中`coc`文件夹到同样的家目录的`.config`文件夹下

方式二：在有网的环境下通过仓库进行下载，下载的内容同样放入`.config`文件夹下，

这种方式一般适用于，通过`CocInstall coc-snippets`安装时，仓库不能访问的时候

```Plain Text
#进入目录
cd ~/.config/coc/extensions/node_modules

#手动下载
wget  https://registry.npmjs.org/coc-snippets/-/coc-snippets-3.1.4.tgz

#解压
tar -xvf coc-snippets-3.1.4.tgz

#解压的目录重命名为coc-snippets
mv coc-snippets-3.1.4 coc-snippets

```

