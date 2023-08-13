grep 作为 linux 中使用频率非常高的一个命令，和 [cut 命令](https://www.jiyik.com/tm/xwzj/opersys_192.html)一样都是管道命令中的一员。并且其功能也是对一行数据进行分析，从分析的数据中取出我们想要的数据。也就是相当于一个检索的功能。当然了，grep 的功能要比 cut 强大的多了。grep 检索的条件是多种多样的，甚至还可以和[正则表达式](https://www.jiyik.com/w/BA4j11165)合作来检索。

下面我们来看 grep 的用法

```Plain Text
$ grep [选项] '字符串' 文件名

```

说明：grep 用法中，字符串就是我们想要检索的字符串；文件名就是数据来源，也就是我们需要分析的数据。因为 grep 可以接受来自标准输入的数据，所以一般情况下 grep 作为[管道命令](https://www.jiyik.com/tm/xwzj/opersys_191.html)来使用。

首先我们来看一个实例，该实例不使用任何选项。查找 / etc/passwd 中带有 mail 字符串的用户的信息：

```Plain Text
$ grep mail /etc/passwd
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
# 输出两行结果

```

### 选项一

-v 这里的 v 是小写，其含义是输出没有匹配到的字符串的那些数据

-s 不显示错误信息

-V 这里的 v 是大写，打印 grep 命令的信息

看下面的例子

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```Plain Text
$ grep -v mail /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
……
# 显示了多行信息，唯独没有包含mail的那些行的数据。这个例子的结果和第一个例子的结果是相反的。

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

下面我们看 - s 的用法

```Plain Text
$ grep mail /etc/passwds
grep: /etc/passwds: No such file or directory  //显示错误信息，因为我们的系统中没有/etc/passwds这个文件
$ grep –s mail /etc/passwds
#这时输出的信息是空的，因为-s限制错误信息的输出

```

-V 选项没有什么好介绍的，就是打印我们当前系统使用的 grep 命令的信息，其中包含其版本

```Plain Text
$ grep -V
grep (GNU grep) 2.5.1
Copyright 1988, 1992-1999, 2000, 2001 Free Software Foundation, Inc.
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

```

### 选项二

这组我们主要介绍对 grep 输出信息的进行控制的选项。

-m 当显示的行数达到该选项指定的行数限制的时候即停止输出。也就是说如果 - m 指定显示行数最大为 3，如果检索出来的结果有 4 行，那也只显示前三行。

```Plain Text
$ grep mail –m 1 /etc/passwd
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin  #只显示一行结果，通过前面的例子我们知道其实含有mail字符串的一共有两行数据。
# or
$ grep mail –max-count=1 /etc/passwd    # -m NUM  <=> --max-count=NUM
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin //同样结果也是一行

```

-n 在输出被检索到的字符串的数据之前同时在前面显示每行数据所在的行号。

```Plain Text
$ grep mail –n /etc/passwd
9:mail: x:8:12:mail:/var/spool/mail:/sbin/nologin
22:mailnull: x:47:47::/var/spool/mqueue:/sbin/nologin
#这两行数据是其在/etc/passwd中所在的行号

```

-b 匹配到字符串的那些行所在的起始位置，该位置是以字节为单位计算的。意思是说，在改行数据之前有 230 个字节的数据，那该行的起始位置就是 230。

```Plain Text
$ grep mail –b /etc/passwd
293:mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
877:mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin

```

-o 只显示匹配的字符串

```Plain Text
$ grep mail –o /etc/passwd
mail
mail
mail
mail

```

-H 在显示的信息前面加上文件名作为前缀，对于检索单个文件来说，默认情况下不用文件名作为前缀。而该选项就是在前面加上文件名作为前缀。

```Plain Text
$ grep mail –H /etc/passwd
/etc/passwd:mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
/etc/passwd:mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin

```

-h 该选项和 - H 的功能正相反，是取出文件名作为前缀。该选项用于多文件检索的时候，因为单文件检索默认情况下是没有文件名前缀的。

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```Plain Text
$ grep mail /etc/passwd /etc/group
/etc/passwd:mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
/etc/passwd:mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
/etc/group:mail:x:12:mail
/etc/group:mailnull:x:47:
#多文件检索会在每一行前面加上改行所在的文件名作为前缀
#grep mail –h /etc/passwd /etc/group
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
mail:x:12:mail
mailnull:x:47:
#此时结果中就没有文件名的前缀了

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

-q 不显示标准输出的信息，即使检索到字符串也不会显示。该选项和 - s 有点类似，-s 是将标准错误输出给屏蔽掉，而该选项是屏蔽标准输出信息。

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```Plain Text
$ grep mail –q /etc/passwd
#结果为空
$ grep mail –q /etc/passwd /etc/passwds
grep: /etc/passwds: No such file or directory
# 我们看，对于错误信息-q并不会屏蔽
$ grep mail –qs /etc/passwd /etc/passwds
# 什么也不显示，标准输出和标准错误输出都被屏蔽掉了

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

-c 小写 c，显示匹配到指定字符串的行数

```Plain Text
$ grep mail –c /etc/passwd
2

```

-d ACTION 如果输入文件是一个目录，我们要使用该选项后面跟上 ACTION 来处理。ACTION 的默认值是 read，表示目录就像普通文件一样被读取；如果 ACTION 是 skip，那么就会跳过该目录；如果 ACTION 是 recurse，grep 就会读取该目录下的所有的文件作为数据源（相当于 grep 的 - r 选项）。针对 recurse 我们举一个例子——查找 / etc 目录下的所有文件的内容，检索包含以 mail 作为开头的行数据

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```Plain Text
$ grep ^mail –d recurse /etc
/etc/passwd:mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
/etc/passwd:mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
/etc/mail/helpfile:mail MAIL From:<sender> [ <parameters> ]
/etc/mail/helpfile:mail         Specifies the sender.  Parameters are ESMTP extensions.
/etc/mail/helpfile:mail         See "HELP DSN" for details.
……
#等价于
$ grep ^mail –r /etc
#结果相同。

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

同时我们在这里也顺便介绍了 - r 选项的用法。还有复习 - h 选项的用途，因为检索了目录的所有文件，所以会在每行结果前加上文件名作为前缀。可以用 - h 去掉

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```Plain Text
$ grep ^mail –hd recurse /etc  //这里注意 h和d的顺序
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
mail    MAIL From:<sender> [ <parameters> ]
mail            Specifies the sender.  Parameters are ESMTP extensions.
mail            See "HELP DSN" for details.
mail.*                                                  -/var/log/maillog
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
mail:*:16619:0:99999:7:::
mailnull:!!:16619:0:99999:7:::
…..

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

-D ACTION 该选项和 - d 基本相同，只是输入文件是一个设备的时候（FIFO 或者 socket）使用该选项，其 ACTION 和 - d 的相同，只是没有 recurse。这里就不再举例子。

-a 将 binary 文件以 text 文件的方式检索数据

-I 大写的 I 忽略 binary 文件

查找 pdo 下面所有文件，检索出含有 main 的数据。

```Plain Text
$ grep main –a –r /software/php-5.5.23 /ext/pdo 
# pdo下面的二进制文件会被当做普通文本文件来检索  相当于–binary-files=text。
$ grep main –binary-files=text –r /software/php-5.5.23 /ext/pdo
#结果同-a相同

```

对于 pdo 下面的二进制文件会进行忽略

```Plain Text
$ grep main –I –r /software/php-5.5.23 /ext/pdo
#相当于 –binary-files=without-match
$ grep main –binary-files=without-match –r /software/php-5.5.23 /ext/pdo
#结果同-I 相同

```

-L 同 - l 相反，显示文件内容不包含检索字符串的文件名 等价于 --files-without-match

-l 显示包含检索字符串的数据所在的文件的文件名 等价于 --files-with-matches

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```Plain Text
$ grep main -l -r /software/php-5.5.23/ext/ftp
/software/php-5.5.23/ext/ftp/package.xml
# 或者
$ grep main --files-with-matches -r /software/php-5.5.23/ext/ftp
# 结果同上
$ grep main –L –r /software/php-5.5.23/ext/ftp
/software/php-5.5.23/ext/ftp/php_ftp.h
/software/php-5.5.23/ext/ftp/tests/006.phpt
/software/php-5.5.23/ext/ftp/tests/ftp_exec_basic.phpt
/software/php-5.5.23/ext/ftp/tests/ftp_nb_get_large.phpt
/software/php-5.5.23/ext/ftp/tests/ftp_get_basic.phpt
….
//部分结果，所有的显示结果中唯独没有/software/php-5.5.23/ext/ftp/package.xml这个文件
# 或者
$ grep main --files-without-match –r /software/php-5.5.23/ext/ftp

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

-A NUM 在检索到的结果后面添加 NUM 行数据，这些数据就是目标行数据下面挨着的 NUM 行数据

-B NUM 同 - A 相反，是在结果前面添加 NUM 行数据

-C NUM 在结果前后都添加 NUM 行数据

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```Plain Text
$ grep mail –B 1 /etc/passwd
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
--
rpc:x:32:32:Portmapper RPC user:/:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
$ grep mail –A 1 /etc/passwd
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
news:x:9:13:news:/etc/news:
--
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
smmsp:x:51:51::/var/spool/mqueue:/sbin/nologin
$ grep mail –C 1 /etc/passwd
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
news:x:9:13:news:/etc/news:
--
rpc:x:32:32:Portmapper RPC user:/:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
smmsp:x:51:51::/var/spool/mqueue:/sbin/nologin

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

### 选项三

-i 对检索的的字符串不区分大小写

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```Plain Text
$ grep Mail /etc/passwd
# 大写的M检索的结果为空，因为默认是区分大小写的
$ grep Mail –i /etc/passwd
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
# -i 使其不区分大小写

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

-w 小写的 w。强制匹配整个单词

```Plain Text
$ grep mail –w /etc/passwd
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
# 这时只有一行数据

```

-x 小写的 x。 强制匹配整行

```Plain Text
$ grep mail –x /etc/passwd
# 结果为空

```

-f 指定检索字符串所在的文件，读取该文件的每一行的内容作为检索的字符串。

文件 /reg.txt

```Plain Text
mail
nobody

```

使用该文件作为 - f 指定的文件

```Plain Text
$ grep –f /reg.txt /etc/passwd
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
nfsnobody:x:65534:65534:Anonymous NFS User:/var/lib/nfs:/sbin/nologin

```

```Plain Text
当然文件中的内容也可以是正则表达式

```

例如 将内容 nobody 改成 ^nobody(以 nobody 开头)

```Plain Text
$ grep –f /reg.txt /etc/passwd
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin

```

我们看到结果中少了一条数据。

-E 指定检索的字符串为正则表达式模式

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```Plain Text
$ grep mail /etc/passwd
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
$ grep ‘(mail)’ /etc/passwd
#结果为空 这里grep将’(mail)’作为一个字符串来进行检索，检索到的结果为空
$ grep –E ‘(mail)’ /etc/passwd
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
#使用-E 指定’(mail)’为正则表达式，所以检索出来两条数据

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

-e 指定字符串作为查找内容的检索条件，其不一样的地方是可以指定多个。

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

```Plain Text
$ grep mail nobody /etc/passwd   #我们的原意是想在passwd中检索mail和nobody
grep: nobody: No such file or directory
/etc/passwd:mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
/etc/passwd:mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
//但是我们看报错了，这时我们可以用-e来指定
$ grep –e mail –e nobody /etc/passwd
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
nfsnobody:x:65534:65534:Anonymous NFS User:/var/lib/nfs:/sbin/nologin

```

[

![](http://common.cnblogs.com/images/copycode.gif)

](javascript:void(0); "复制代码")

我们看结果已经出来了。是不是很好用

-G 指定检索条件是一个基本的正则表达式

-P 指定检索的条件是 perl 正则表达式

通过对 grep 命令的介绍，我们可以看到，其实 grep 命令之所以强大，和它支持[正则表达式](https://www.jiyik.com/w/BA4j11165)是分不开的，所以说熟悉正则表达式是很重要的。

