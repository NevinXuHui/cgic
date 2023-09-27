---
url: https://qa.1r1g.com/sf/ask/552376821/
title: Makefile 中的双冒号规则是什么？ _
date: 2023-03-31 17:20:27
tag: 
banner: "undefined"
banner_icon: 🔖
---
[zco*_*tin](https://qa.1r1g.com/sf/users/385928931/ "zco*_*tin") 7

有三种情况, 双冒号是有用的:

1.  在编译规则之间交替, 基于哪个先决条件比目标更新. 以下示例基于 [http://books.gigatux.nl/mirror/cinanutshell/0596006977/cinanut-CHP-19-SECT-3.html](http://books.gigatux.nl/mirror/cinanutshell/0596006977/cinanut-CHP-19-SECT-3.html) 上的 "示例 19-3. 双冒号规则"[](http://books.gigatux.nl/mirror/cinanutshell/0596006977/cinanut-CHP-19-SECT-3.html)

示例. c 文件:

```
c@desk:~/test/circle$ cat circle.c 


int main (void)
{
  printf("Example.\n");
  return 0;
}


```

Makefile 使用:

```
c@desk:~/test/circle$ cat Makefile 


CC = gcc
RM = rm -f
CFLAGS = -Wall -std=c99
DBGFLAGS = -ggdb -pg
DEBUGFILE = ./debug
SRC = circle.c

circle :: $(SRC)
        $(CC) $(CFLAGS) -o $@ -lm $^

circle :: $(DEBUGFILE)
        $(CC) $(CFLAGS) $(DBGFLAGS) -o $@ -lm $(SRC)

.PHONY : clean

clean  :
        $(RM) circle


```

结果:

```
c@desk:~/test/circle$ make circle
gcc -Wall -std=c99 -o circle -lm circle.c
make: *** No rule to make target 'debug', needed by 'circle'.  Stop.
c@desk:~/test/circle$ make circle
gcc -Wall -std=c99 -o circle -lm circle.c
gcc -Wall -std=c99 -ggdb -pg -o circle -lm circle.c
c@desk:~/test/circle$ vim circle.c 
c@desk:~/test/circle$ make circle
gcc -Wall -std=c99 -o circle -lm circle.c
c@desk:~/test/circle$ vim debug 
c@desk:~/test/circle$ make circle
gcc -Wall -std=c99 -ggdb -pg -o circle -lm circle.c


```

2.  制作模式规则终端.

下面的例子解释了这种情况: a.config 文件是从 a.cfg 获得的, 而 a.cfg 又是从 a.cfg1 获得的 (a.cfg 是中间文件).

```
c@desk:~/test/circle1$ ls
a.cfg1  log.txt  Makefile
c@desk:~/test/circle1$ cat Makefile 
CP=/bin/cp

%.config:: %.cfg
        @echo "$@ from $<"
        @$(CP) $< $@

%.cfg: %.cfg1
        @echo "$@ from $<"
        @$(CP) $< $@

clean:
        -$(RM) *.config


```

结果 (因为 %.config 规则是终端, make 禁止从 a.cfg1 创建中间 a.cfg 文件):

```
c@desk:~/test/circle1$ make a.conf
make: *** No rule to make target 'a.conf'.  Stop.


```

没有 %.config 的双冒号, 结果是:

```
c@desk:~/test/circle1$ make a.config
a.cfg from a.cfg1
a.config from a.cfg
rm a.cfg


```

3.  制定一个始终执行的规则 (对于干净的规则很有用). 规则必须没有先决条件!

c @ desk:〜/ test/circle3 $ cat Makefile

```
CP=/bin/cp  
a.config::  
    @echo "Always" >> $@  

a.config::  
    @echo "Always!" >> $@  

clean:  
    -$(RM) *.config  


```

结果:

```
c@desk:~/test/circle3$ make a.config
c@desk:~/test/circle3$ cat a.config 
Always
Always!
c@desk:~/test/circle3$ make a.config
c@desk:~/test/circle3$ cat a.config
Always
Always!
Always
Always!


```

* * *

[Max*_*kin](https://qa.1r1g.com/sf/users/28845631/ "Max*_*kin") 5

它们非常适合非递归的 makefile 和目标`clean`. 也就是说, 单个. mk 文件可以将自己的命令添加到`clean`已在别处定义的目标.

[文档](http://www.gnu.org/software/make/manual/make.html#Double_002dColon)给出了答案:

双冒号规则有点模糊, 通常不太有用; **它们为用于更新目标的方法根据导致更新的先决条件文件而不同的情况提供了一种机制, 这种情况很少见.**

* * *

[thi*_*ton](https://qa.1r1g.com/sf/users/59332101/ "thi*_*ton") 5

正如文档所说, 双冒号规则很少有用. 它们是一种很好的, 没有命名复合虚假目标的单个目标的方法 (如 all::), 但在这个角色中并不是必需的. 我只能在必要时形成一个人为的例子:

假设您有一个日志文件 L, 它与其他几个日志文件 L1,L2,.... 连接起来. 您可以制定一些双冒号规则, 例如:

```
L :: L1
     cat $< >> $@ && rm $<

L :: L2
     cat $< >> $@ && rm $<


```

现在在 GNU make 中, 你当然会使用`$^`这种魔法, 但它被列为 GNU make 的功能选项卡上的灵感功能.

* * *