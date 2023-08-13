#coc_nvim
### 文章目录

- [[coc.nvim] build/index.js not found, please install dependencies and compile coc.nvim by: yarn install
](#cocnvim_buildindexjs_not_found_please_install_dependencies_and_compile_cocnvim_by_yarn_installbrPress_ENTER_or_type_command_to_continue_1)[Press ENTER or type command to continue](#cocnvim_buildindexjs_not_found_please_install_dependencies_and_compile_cocnvim_by_yarn_installbrPress_ENTER_or_type_command_to_continue_1)

- 

  - [解决方案](#_3)

  - [命令执行结果如下图](#_14)

- [参考文献](#_24)

# [coc.nvim] build/index.js not found, please install dependencies and compile coc.nvim by: [yarn](https://so.csdn.net/so/search?q=yarn&spm=1001.2101.3001.7020) install

Press ENTER or type command to continue

![](https://img-blog.csdnimg.cn/df0ebfddb7464554ac51f9441334397d.png#pic_center)

## 解决方案

```Plain Text
sudo apt install nodejs
sudo npm install -g yarn
# ~/.vim/plugged/coc.nvim/是我的coc.nvim插件的安装目录
cd ~/.vim/plugged/coc.nvim/	
yarn install
yarn build

```

## 命令执行结果如下图

![](https://img-blog.csdnimg.cn/5527d5533822431a8ff085e5a58f0007.png#pic_center)

![](https://img-blog.csdnimg.cn/63a787d6841547be80fb0fdc1eb81f73.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5rKh5pyJQuagkQ==,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

![](https://img-blog.csdnimg.cn/e36fa5c5cafc4961993ac482a85dff8e.png#pic_center)

![](https://img-blog.csdnimg.cn/d72d3bc527494bbeaad664dc5804fe02.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5rKh5pyJQuagkQ==,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

![](https://img-blog.csdnimg.cn/13ea4b313f0d4b34b46ac993f7141355.png#pic_center)

![](https://img-blog.csdnimg.cn/b09426e6be1c48739e38389fe447ef37.png#pic_center)

# 参考文献

[[coc.nvim] build/index.js not found, please compile coc.nvim by: npm run build #3258](https://github.com/neoclide/coc.nvim/issues/3258)

[Yarn shows command not found](https://stackoverflow.com/questions/56770380/yarn-shows-command-not-found)

