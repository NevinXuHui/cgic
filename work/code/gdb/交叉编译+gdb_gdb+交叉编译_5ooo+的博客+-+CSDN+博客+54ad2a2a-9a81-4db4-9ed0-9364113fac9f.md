**1、下载 GDB 源码**

gdb 源码下载地址：[https://ftp.gnu.org/gnu/gdb/](https://ftp.gnu.org/gnu/gdb/)

这里示例所下载的版本是 gdb-9.2.tar.gz

**2、解压源码，创建 build 目录，避免污染源码**

```Plain Text
# tar xvf gdb-9.2.tar.gz
# cd gdb-9.2/
# mkdir build
# cd build

```

**3、添加交叉编译工具链路径到环境变量**

例如我的交叉编译工具链的路径是：
/home/share/toolchains/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/

那么执行：

```Plain Text
# export PATH=$PATH:/home/share/toolchains/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin

```

**4、执行上层 configure，指定编译器、链接器，生成 makefile**

```Plain Text
# ../configure --host=arm-linux CC=aarch64-linux-gnu-gcc CXX=aarch64-linux-gnu-g++ AR=aarch64-linux-gnu-ar LD=aarch64-linux-gnu-ld

```

**5、开始交叉编译**

```Plain Text
# make

```

编译途中遇到相关问题见文末；

**6、编译完成，查看文件类型**

```Plain Text
# file gdb/gdb
gdb/gdb: ELF 64-bit LSB executable, ARM aarch64, version 1 (GNU/Linux), dynamically linked, interpreter /lib/ld-linux-aarch64.so.1, for GNU/Linux 3.7.0, BuildID[sha1]=2a15c3054ae93c62650aac86d50693b50c3f3c72, not stripped

```

**7、进行瘦身**

查看文件大小，83M 对于嵌入式设备来说太大了。使用交叉编译工具中的 strip 命令进行文件瘦身:

```Plain Text
# ls -lth gdb/gdb
-rwxr-xr-x 1 root root 83M 11月  8 14:14 gdb/gdb

# aarch64-linux-gnu-strip gdb/gdb

# ls -lth gdb/gdb
-rwxr-xr-x 1 root root 5.9M 11月  8 14:20 gdb/gdb

```

可以看到，瘦身后的 gdb 文件大小变成 5.9M；

**8、上传到板子上测试**

可以使用 scp、ftp、lrzsz、tftp 等命令，能把文件传到嵌入式设备上就行；

例如使用 tftp，PC(IP:10.5.1.86) 开启 tftpd 程序后，在嵌入式设备获取 gdb 文件并添加执行权限：

```Plain Text
# tftp -g -r gdb 10.5.1.86
# chmod +x gdb 

# ./gdb --version                                             
GNU gdb (GDB) 9.2                                                               
Copyright (C) 2020 Free Software Foundation, Inc.                               
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>   
This is free software: you are free to change and redistribute it.              
There is NO WARRANTY, to the extent permitted by law. 

```

注：若执行 gdb 出现 error while loading shared libraries: libexpat.so.1: cannot open shared object file: No such file or directory 之类的错误，只需上传缺少的动态库文件，放到默认库路径 (/usr/lib) 或者 使用 export LD_LIBRARY_PATH 添加库所在路径，再执行 gdb 程序即可。

**9、编译问题处理**

问题 1：missing: makeinfo: not found，WARNING: ‘makeinfo’ is missing on your system.

解决：apt-get install texinfo

问题 2：…/…/gdb/nat/linux-ptrace.h:21:22: error: ‘PTRACE_GETFPREGS’ was not declared in this scope

解决：编辑 ptrace.h 添加相关缺省的定义

```Plain Text
# vi ./aarch64-linux-gnu/libc/usr/include/sys/ptrace.h
...
  /* Get all general purpose registers used by a process.  */
  PTRACE_GETREGS = 12, 
#define PT_GETREGS PTRACE_GETREGS

  /* Set all general purpose registers used by a process.  */
  PTRACE_SETREGS = 13,
#define PT_SETREGS PTRACE_SETREGS

  /* Get all floating point registers used by a process.  */
  PTRACE_GETFPREGS = 14,
#define PT_GETFPREGS PTRACE_GETFPREGS                                          

  /* Set all floating point registers used by a process.  */
  PTRACE_SETFPREGS = 15,
#define PT_SETFPREGS PTRACE_SETFPREGS
...

```

问题 3：…/…/…/gdb/gdbserver/linux-arm-low.c:779:29: error: ‘__NR_sigreturn’ was not declared in this scope

解决：编辑交叉工具链中相关定义文件，添加其定义 (不要和已有宏的值冲突)。

```Plain Text
# vi ./aarch64-linux-gnu/libc/usr/include/asm-generic/unistd.h
...
#define __NR_sigreturn 292
...

```

