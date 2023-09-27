SourceURL:file:///ntfs-data/work/linux内核/理解subst函数.wps

# **理解****subst****函数**

# **1****)****自己写****M****akfile**

tools_enabled="y y y y n y y n n y y y y n y y y y y y y n y y n n y y y y n y y y y y y y y y y y y y y y y n y n n y y y y y y y"

empty:=

space=$(empty) $(empty)

mystr=$(subst $(space),,$(tools_enabled))

$(info tools_enabled=$(tools_enabled))

$(info mystr=$(mystr))

# **2)****执行**

make

执行结果：

tools_enabled="y y y y n y y n n y y y y n y y y y y y y n y y n n y y y y n y y y y y y y y y y y y y y y y n y n n y y y y y y y"

mystr="yyyynyynnyyyynyyyyyyynyynnyyyynyyyyyyyyyyyyyyyynynnyyyyyyy"

可以看到tools_enabled中的空格被替换了，相当于去掉了原字符串中的所有空格

# **3)****结论**

substs是substitue的简称

subst arg1, arg2, arg3

arg1表示替换关键字，也就是被替换后的新内容

arg2 被替换关键字，也就是原字符串中的这个内容要被替换

arg3 表示被替换的原始字符串，需要去搜索它