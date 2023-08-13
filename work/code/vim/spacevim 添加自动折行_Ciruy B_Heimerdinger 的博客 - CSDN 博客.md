#SpaceVim #vim 
---
url: https://blog.csdn.net/qq_31433709/article/details/116058721
title: (133 条消息) spacevim 添加自动折行_Ciruy B_Heimerdinger 的博客 - CSDN 博客
date: 2023-03-29 18:55:47
tag: 
banner: "undefined"
banner_icon: 🔖
---
spacevim 非常好用，强烈的安利。但是有一样不好用的地方就是写 markdown 的时候不会自动的折行，这点体验非常的不好。经过查询我找到了方法。

```
vim ~/.SpaceVim/vimrc 
添加一行
set wrap
```

```
cat ~/.SpaceVim/vimrc
"=============================================================================
" vimrc --- Entry file for vim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Note: Skip initialization for vim-tiny or vim-small.
if 1
    execute 'source' fnamemodify(expand('<sfile>'), ':h').'/config/main.vim'
endif
" vim:set et sw=2
set wrap
```