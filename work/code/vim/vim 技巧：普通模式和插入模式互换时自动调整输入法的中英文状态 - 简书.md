#输入法  #vim   #切换
---
url: https://www.jianshu.com/p/d6067b47cec4
title: vim 技巧：普通模式和插入模式互换时自动调整输入法的中英文状态 - 简书
date: 2023-03-29 09:32:44
tag: 
banner: "https://upload.jianshu.io/users/upload_avatars/937712/838f41b9660b.jpg"
banner_icon: 🔖
---
使用 vim 进行中文写作时最大的麻烦就是中文输入法的问题：

插入模式调整出来中文输入法了，按了 esc 进入普通模式，按 i 之类的想进入插入模式，发现还是中文输入法，次数多了实在是闹心。

我使用的是 Ubuntu 操作系统，使用的输入法是基于 fcitx 的搜狗输入法。

编辑. vimrc 文件，在文件末尾添加以下代码：

```
let g:input_toggle = 1
function! Fcitx2en()
   let s:input_status = system("fcitx5-remote")
   if s:input_status == 2
      let g:input_toggle = 1
      let l:a = system("fcitx5-remote -c")
   endif
endfunction

function! Fcitx2zh()
   let s:input_status = system("fcitx5-remote")
   if s:input_status != 2 && g:input_toggle == 1
      let l:a = system("fcitx5-remote -o")
      let g:input_toggle = 0
   endif
endfunction

set timeoutlen=150
autocmd InsertLeave * call Fcitx2en()
"autocmd InsertEnter * call Fcitx2zh()


```

以上代码就可以让 vim 在从插入模式进入普通模式时变成英文输入法，  
如果删除最后一行的注释符号，还可以实现在从普通模式进入插入模式时自动进入中文输入法，不过进入中文输入法对大多数 Linuxer 可能会造成更多的困扰吧。

祝大家使用愉快。