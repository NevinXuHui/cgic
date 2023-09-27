vim 是一款功能及其强大的编辑器，但是之前一直不会使用 vim 与系统的剪贴板一起交互使用，不会将在其他位置复制的文字或者代码，粘贴在 vim 中，将在 vim 中复制的文字或者代码粘贴在系统的其他位置，今天研究了一下 vim 的寄存器

使用前，使用如下命令，看看自己的计算机的 vim 版本

```Plain Text
vim --version | grep clipboard
```

如果出现 “-clipboard” 则说明系统的 vim 版本不支持与系统剪贴板的交互操作，需要采用如下的命令安装新的 vim

```Plain Text
sudo apt install vim-gtk

```
```
dsjdjdkldjlkdjdkkd
```
安装完成之后再利用代码检查一次，出现 “+clipboard”，那么系统的 vim 没有问题。

```Plain Text
vim --version | grep clipboard
```

在 vim 中复制的代码或者文字，存储在寄存器（register）中，寄存器有好多个, 使用如下 vim 命令查看系统 vim 的寄存器的个数

```Plain Text
：help  registers

```

输出结果为

```Plain Text
There are ten types of registers:			*registers* *E354*
1. The unnamed register ""
2. 10 numbered registers "0 to "9
3. The small delete register "-
4. 26 named registers "a to "z or "A to "Z
5. three read-only registers ":, "., "%
6. alternate buffer register "#
7. the expression register "=
8. The selection and drop registers "*, "+ and "~ 
9. The black hole register "_
10. Last search pattern register "/
```
```Plain Text
1.无名（unnamed）寄存器：""，缓存最后一次操作内容；

2.数字（numbered）寄存器："0 ～"9，缓存最近操作内容，复制与删除有别, "0寄存器缓存最近一次复制的内容，"1-"9缓存最近9次删除内容

3.行内删除（small delete）寄存器："-，缓存行内删除内容；

4.具名（named）寄存器："a ～ "z或"A - "0Z，指定时可用；

5.只读（read-only）寄存器：":,".,"%,"#，分别缓存最近命令、最近插入文本、当前文件名、当前交替文件名；

6.表达式（expression）寄存器："=，只读，用于执行表达式命令；

7.选择及拖拽（selection and drop）寄存器："*,"+,"~，存取GUI选择文本，可用于与外部应用交互，使用前提为系统剪切板（clipboard）可用；

8.黑洞（black hole）寄存器："_，不缓存操作内容（干净删除）；

9.模式寄存器（last search pattern）："/，缓存最近的搜索模式。
```

从上述寄存器列表，可以知道，利用平时的 yy，nyy 等命令复制或者使用其他删除等命令操作的结果存储在 unname 寄存器中，如果想要与系统的剪切板进行交互，就需要利用 "+ 这个寄存器，使用如下命令：

```Plain Text
#将vim中的代码或者文字复制到剪切板
"+yy
"+nyy
#将系统剪切板中的代码或者文字复制到vim中
"+p
"+P
```

亲测可以使用，整理不易，点个赞再走呗，不要只收藏

