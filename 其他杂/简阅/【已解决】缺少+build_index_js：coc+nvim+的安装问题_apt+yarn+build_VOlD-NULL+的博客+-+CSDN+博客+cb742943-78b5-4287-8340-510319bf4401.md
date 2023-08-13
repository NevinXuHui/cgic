neovim 的自动补全插件`coc.nvim`在正常使用之前，需要进行如下操作：

1. 安装`node`

```Plain Text
sudo apt install node npm

```

2. 安装`yarn`
这里要注意 yarn 在 apt 默认里没有维护，想要正常使用`coc.nvim`需要添加第三方

[参考问题](https://linuxize.com/post/how-to-install-yarn-on-debian-10/)

```Plain Text
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

```

现在在安装`yarn`

```Plain Text
sudo apt-get update
sudo apt-get install yarn

```

运行`yarn`检查版本

```Plain Text
yarn --version

```

出现 1.xx 就可以了

3. 用`yarn`编译安装 coc

首先找到 coc 的安装位置，比如：`<neovim config>/plugged/coc.nvim`
然后运行：

```Plain Text
yarn install
yarn build

```

问题解决

