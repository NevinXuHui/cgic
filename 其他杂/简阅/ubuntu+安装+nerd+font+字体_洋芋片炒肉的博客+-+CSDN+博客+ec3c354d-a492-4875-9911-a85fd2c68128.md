## 步骤

### 1. 下载 nerd font 字体文件到某个文件夹

在网址 [https://www.nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads)，找到 JetBrainsMono ，DroidSansMono， DejaVuSansMono， UbuntuMono， CodeNewRoman， BitstreamVeraSansMono 等（我个人感觉好看的几个字体）

### 2. 执行以下脚本

```Plain Text
# array中换成你要安装的字体的文件名
array=(JetBrainsMono DroidSansMono DejaVuSansMono UbuntuMono CodeNewRoman BitstreamVeraSansMono)
current_dir=`pwd`
for font in ${array[@]}
do
    sudo unzip ${font} -d /usr/share/fonts/${font}
    cd /usr/share/fonts/${font}
	sudo mkfontscale # 生成核心字体信息
	sudo mkfontdir # 生成字体文件夹
	sudo fc-cache -fv # 刷新系统字体缓存
    cd ${current_dir}
done

```

## 参考资源

- [https://www.cnblogs.com/zi-wang/p/12566898.html](https://www.cnblogs.com/zi-wang/p/12566898.html)

