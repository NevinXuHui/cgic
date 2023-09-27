---
url: https://blog.csdn.net/A493203176/article/details/78792274
title: 动态链接库 dlopen 的函数的使用_A493203176 的博客 - CSDN 博客
date: 2023-08-13 12:09:41
tag: 
banner: "https://images.unsplash.com/photo-1691256853764-f9917b70e5e5?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxODk5Nzc0fA&ixlib=rb-4.0.3&q=85&fit=crop&w=682&max-h=540"
banner_icon: 🔖
---
转自：http://blog.const.net.cn/a/17154.htm

编译时候要加入 -ldl (指定 dl 库)

dlopen

基本定义

功能：打开一个动态链接库 

[喝小酒的网摘]http://blog.const.net.cn/a/17154.htm

包含头文件： 

#include <dlfcn.h> 

函数定义： 

void * dlopen(const char * pathname, int mode); 

函数描述： 

在 dlopen 的（）函数以指定模式打开指定的动态连接库文件，并返回一个句柄给调用进程。使用 dlclose（）来卸载打开的库。 

mode：分为这两种 

RTLD_LAZY 暂缓决定，等有需要时再解出符号 

RTLD_NOW 立即决定，返回前解除所有未决定的符号。 

RTLD_LOCAL 

RTLD_GLOBAL 允许导出符号 

RTLD_GROUP 

RTLD_WORLD 

返回值: 

打开错误返回 NULL 

成功，返回库引用 

编译时候要加入 -ldl (指定 dl 库) 

例如 

gcc test.c -o test -ldl

使用 dlopen

dlopen() 是一个强大的库函数。该函数将打开一个新库，并把它装入内存。该函数主要用来加载库中的符号，这些符号在编译的时候是不知道的。比如 Apache Web 服务器利用这个函数在运行过程中加载模块，这为它提供了额外的能力。一个配置文件控制了加载模块的过程。这种机制使得在系统中添加或者删除一个模块时，都 不需要重新编译了。 

可以在自己的程序中使用 dlopen()。dlopen() 在 dlfcn.h 中定义，并在 dl 库中实现。它需要两个参数：一个文件名和一个标志。文件名可以是我们学习过的库中的 soname。标志指明是否立刻计算库的依赖性。如果设置为 RTLD_NOW 的话，则立刻计算；如果设置的是 RTLD_LAZY，则在需要的时候才计算。另外，可以指定 RTLD_GLOBAL，它使得那些在以后才加载的库可以获得其中的符号。 

　　当库被装入后，可以把 dlopen() 返回的句柄作为给 dlsym() 的第一个参数，以获得符号在库中的地址。使用这个地址，就可以获得库中特定函数的指针，并且调用装载库中的相应函数。

--------------------------------------------------------------------------------------------------------------------------

dlsym  
  
dlsym() 的函数原型是   
void* dlsym(void* handle,const char* symbol)   
该函数在 <dlfcn.h> 文件中。   
handle 是由 dlopen 打开动态链接库后返回的指针，symbol 就是要求获取的函数的名称，函数返回值是 void*, 指向函数的地址，供调用使用

取动态对象地址：  
#include <dlfcn.h>  
void *dlsym(void *pHandle, char *symbol);  
dlsym 根据动态链接库操作句柄 (pHandle) 与符号(symbol), 返回符号对应的地址。  
使用这个函数不但可以获取函数地址，也可以获取变量地址。比如，假设在 so 中  
定义了一个 void mytest() 函数，那在使用 so 时先声明一个函数指针：  
void (*pMytest)(), 然后使用 dlsym 函数将函数指针 pMytest 指向 mytest 函数，  
pMytest = (void (*)())dlsym(pHandle, "mytest");

--------------------------------------------------------------------------------------------------------------------------

dlclose  
dlclose（）   
包含头文件：   
#include <dlfcn.h>   
函数原型为:   
int dlclose (void *handle);   
函数描述：   
dlclose 用于关闭指定句柄的动态链接库，只有当此动态链接库的使用计数为 0 时, 才会真正被系统卸载。

--------------------------------------------------------------------------------------------------------------------------

dlerror  
dlerror（）   
包含头文件：   
#include <dlfcn.h>   
函数原型:   
const char *dlerror(void);   
函数描述：   
当动态链接库操作函数执行失败时，dlerror 可以返回出错信息，返回值为 NULL 时表示操作函数执行成功。

LINUX 创建与使用动态链接库并不是一件难事。  
编译函数源程序时选用 - shared 选项即可创建动态链接库，注意应以. so 后缀命名，最好放到公用库目录 (如 / lib,/usr/lib 等) 下面，并要写好用户接口文件，以便其它用户共享。  
使用动态链接库，源程序中要包含 dlfcn.h 头文件，写程序时注意 dlopen 等函数的正确调用，编译时要采用 - rdynamic 选项与 - ldl 选项 ，以产生可调用动态链接库的执行代码。  
  
    EXAMPLE    
    Load the math library, and print the cosine of 2.0: #include <stdio.h>    
    #include <dlfcn.h>    
        
    int main(int argc, char **argv) {    
        void *handle;    
        double (*cosine)(double);    
        char *error;    
        
        handle = dlopen ("libm.so", RTLD_LAZY);    
        if (!handle) {    
            fprintf (stderr, "%s", dlerror());    
            exit(1);    
        }    
        
        cosine = dlsym(handle, "cos");    
        if ((error = dlerror()) != NULL)  {    
            fprintf (stderr, "%s", error);    
            exit(1);    
        }    
        
        printf ("%f", (*cosine)(2.0));    
        dlclose(handle);    
        return 0;    
    }    
    #include <stdio.h>    
    #include <dlfcn.h>    
        
    int main(int argc, char **argv) {    
        void *handle;    
        double (*cosine)(double);    
        char *error;    
        
        handle = dlopen ("libm.so", RTLD_LAZY);    
        if (!handle) {    
            fprintf (stderr, "%s", dlerror());    
            exit(1);    
        }    
        
        cosine = dlsym(handle, "cos");    
        if ((error = dlerror()) != NULL)  {    
            fprintf (stderr, "%s", error);    
            exit(1);    
        }    
        
        printf ("%f", (*cosine)(2.0));    
        dlclose(handle);    
        return 0;    
    }    
        
     If this program were in a file named "foo.c", you would build the program with the following command:     
        
     gcc -rdynamic -o foo foo.c -ldl    
  
如果文件名 filename 是以 “/” 开头，也就是使用绝对路径，那么 dlopne 就直接使用它，而不去查找某些环境变量或者系统设置的函数库所在的目录了。否则 dlopen（）  
  
就会按照下面的次序查找函数库文件：  
  
1. 环境变量 LD_LIBRARY 指明的路径。   
2. /etc/ld.so.cache 中的函数库列表。   
3. /lib 目录，然后 / usr/lib。不过一些很老的 a.out 的 loader 则是采用相反的次序，也就是先查 / usr/lib，然后是 / lib。  
Dlopen() 函数中，参数 flag 的值必须是 RTLD_LAZY 或者 RTLD_NOW，RTLD_LAZY 的意思是 resolve undefined symbols as code from the dynamic library is executed，而 RTLD_NOW 的含义是 resolve all undefined symbols before dlopen() returns and fail if this cannot be done'。  
  
如果有好几个函数库，它们之间有一些依赖关系的话，例如 X 依赖 Y，那么你就要先加载那些被依赖的函数。例如先加载 Y，  
然后加载 X。  
  
dlopen（）函数的返回值是一个句柄，然后后面的函数就通过使用这个句柄来做进一步的操作。如果打开失败 dlopen() 就返回一个 NULL。如果一个函数库被多次打开，它会返回同样的句柄。  
  

如果一个函数库里面有一个输出的函数名字为_init, 那么_init 就会在 dlopen（）这个函数返回前被执行。我们可以利用这个函数在我的函数库里面做一些初始化的工作。我们后面会继续讨论这个问题的。

# [采用 dlopen、dlsym、dlclose 加载动态链接库【总结】](http://www.cnblogs.com/Anker/p/3746802.html)

1、前言

　　为了使程序方便扩展，具备通用性，可以采用插件形式。采用异步事件驱动模型，保证主程序逻辑不变，将各个业务已动态链接库的形式加载进来，这就是所谓的插件。linux 提供了加载和处理动态链接库的系统调用，非常方便。本文先从使用上进行总结，涉及到基本的操作方法，关于动态链接库的本质及如何加载进来，需要进一步学习，后续继续补充。如何将程序设计为插件形式，挖掘出主题和业务之间的关系，需要进一步去学习。

2、生产动态链接库

编译参数 gcc -fPIC -shared 

例如将如下程序编译为动态链接库 libcaculate.so，程序如下：

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAACbklEQVRoQ+2aMU4dMRCGZw6RC1CSSyQdLZJtKQ2REgoiRIpQkCYClCYpkgIESQFIpIlkW+IIcIC0gUNwiEFGz+hlmbG9b1nesvGW++zxfP7H4/H6IYzkwZFwQAUZmpJVkSeniFJKA8ASIi7MyfkrRPxjrT1JjZ8MLaXUDiJuzwngn2GJaNd7vyP5IoIYY94Q0fEQIKIPRGS8947zSQTRWh8CwLuBgZx479+2BTkHgBdDAgGAC+fcywoyIFWqInWN9BSONbTmFVp/AeA5o+rjKRJ2XwBYRsRXM4ZXgAg2LAPzOCDTJYQx5pSIVlrC3EI45y611osMTHuQUPUiYpiVooerg7TWRwDAlhSM0TuI+BsD0x4kGCuFSRVzSqkfiLiWmY17EALMbCAlMCmI6IwxZo+INgQYEYKBuW5da00PKikjhNNiiPGm01rrbwDwofGehQjjNcv1SZgddALhlJEgwgJFxDNr7acmjFLqCyJuTd6LEGFttpmkYC91Hrk3s1GZFERMmUT01Xv/sQljjPlMRMsxO6WULwnb2D8FEs4j680wScjO5f3vzrlNJszESWq2LYXJgTzjZm56MCHf3zVBxH1r7ftU1splxxKYHEgoUUpTo+grEf303rPH5hxENJqDKQEJtko2q9zGeeycWy3JhpKhWT8+NM/sufIhBwKI+Mta+7pkfxKMtd8Qtdbcx4dUQZcFCQ2I6DcAnLUpf6YMPxhIDDOuxC4C6djoQUE6+tKpewWZ1wlRkq0qUhXptKTlzv93aI3jWmE0Fz2TeujpX73F9TaKy9CeMk8vZusfBnqZ1g5GqyIdJq+XrqNR5AahKr9CCcxGSwAAAABJRU5ErkJggg==)

```
int add(int a,int b)
{
    return (a + b);
}

int sub(int a, int b)
{
    return (a - b);
}

int mul(int a, int b)
{
    return (a * b);
}

int div(int a, int b)
{
    return (a / b);
}

```

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAACbklEQVRoQ+2aMU4dMRCGZw6RC1CSSyQdLZJtKQ2REgoiRIpQkCYClCYpkgIESQFIpIlkW+IIcIC0gUNwiEFGz+hlmbG9b1nesvGW++zxfP7H4/H6IYzkwZFwQAUZmpJVkSeniFJKA8ASIi7MyfkrRPxjrT1JjZ8MLaXUDiJuzwngn2GJaNd7vyP5IoIYY94Q0fEQIKIPRGS8947zSQTRWh8CwLuBgZx479+2BTkHgBdDAgGAC+fcywoyIFWqInWN9BSONbTmFVp/AeA5o+rjKRJ2XwBYRsRXM4ZXgAg2LAPzOCDTJYQx5pSIVlrC3EI45y611osMTHuQUPUiYpiVooerg7TWRwDAlhSM0TuI+BsD0x4kGCuFSRVzSqkfiLiWmY17EALMbCAlMCmI6IwxZo+INgQYEYKBuW5da00PKikjhNNiiPGm01rrbwDwofGehQjjNcv1SZgddALhlJEgwgJFxDNr7acmjFLqCyJuTd6LEGFttpmkYC91Hrk3s1GZFERMmUT01Xv/sQljjPlMRMsxO6WULwnb2D8FEs4j680wScjO5f3vzrlNJszESWq2LYXJgTzjZm56MCHf3zVBxH1r7ftU1splxxKYHEgoUUpTo+grEf303rPH5hxENJqDKQEJtko2q9zGeeycWy3JhpKhWT8+NM/sufIhBwKI+Mta+7pkfxKMtd8Qtdbcx4dUQZcFCQ2I6DcAnLUpf6YMPxhIDDOuxC4C6djoQUE6+tKpewWZ1wlRkq0qUhXptKTlzv93aI3jWmE0Fz2TeujpX73F9TaKy9CeMk8vZusfBnqZ1g5GqyIdJq+XrqNR5AahKr9CCcxGSwAAAABJRU5ErkJggg==)

编译如下： gcc -fPIC -shared caculate.c -o libcaculate.so 

![](http://images.cnitblog.com/i/305504/201405/230024317939129.png)

3、dlopen、dlsym 函数介绍

      在 linux 上 man dlopen 可以看到使用说明，函数声明如下：

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAACbklEQVRoQ+2aMU4dMRCGZw6RC1CSSyQdLZJtKQ2REgoiRIpQkCYClCYpkgIESQFIpIlkW+IIcIC0gUNwiEFGz+hlmbG9b1nesvGW++zxfP7H4/H6IYzkwZFwQAUZmpJVkSeniFJKA8ASIi7MyfkrRPxjrT1JjZ8MLaXUDiJuzwngn2GJaNd7vyP5IoIYY94Q0fEQIKIPRGS8947zSQTRWh8CwLuBgZx479+2BTkHgBdDAgGAC+fcywoyIFWqInWN9BSONbTmFVp/AeA5o+rjKRJ2XwBYRsRXM4ZXgAg2LAPzOCDTJYQx5pSIVlrC3EI45y611osMTHuQUPUiYpiVooerg7TWRwDAlhSM0TuI+BsD0x4kGCuFSRVzSqkfiLiWmY17EALMbCAlMCmI6IwxZo+INgQYEYKBuW5da00PKikjhNNiiPGm01rrbwDwofGehQjjNcv1SZgddALhlJEgwgJFxDNr7acmjFLqCyJuTd6LEGFttpmkYC91Hrk3s1GZFERMmUT01Xv/sQljjPlMRMsxO6WULwnb2D8FEs4j680wScjO5f3vzrlNJszESWq2LYXJgTzjZm56MCHf3zVBxH1r7ftU1splxxKYHEgoUUpTo+grEf303rPH5hxENJqDKQEJtko2q9zGeeycWy3JhpKhWT8+NM/sufIhBwKI+Mta+7pkfxKMtd8Qtdbcx4dUQZcFCQ2I6DcAnLUpf6YMPxhIDDOuxC4C6djoQUE6+tKpewWZ1wlRkq0qUhXptKTlzv93aI3jWmE0Fz2TeujpX73F9TaKy9CeMk8vZusfBnqZ1g5GqyIdJq+XrqNR5AahKr9CCcxGSwAAAABJRU5ErkJggg==)

```
#include <dlfcn.h>

void *dlopen(const char *filename, int flag);

char *dlerror(void);

void *dlsym(void *handle, const char *symbol);

int dlclose(void *handle);

```

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAACbklEQVRoQ+2aMU4dMRCGZw6RC1CSSyQdLZJtKQ2REgoiRIpQkCYClCYpkgIESQFIpIlkW+IIcIC0gUNwiEFGz+hlmbG9b1nesvGW++zxfP7H4/H6IYzkwZFwQAUZmpJVkSeniFJKA8ASIi7MyfkrRPxjrT1JjZ8MLaXUDiJuzwngn2GJaNd7vyP5IoIYY94Q0fEQIKIPRGS8947zSQTRWh8CwLuBgZx479+2BTkHgBdDAgGAC+fcywoyIFWqInWN9BSONbTmFVp/AeA5o+rjKRJ2XwBYRsRXM4ZXgAg2LAPzOCDTJYQx5pSIVlrC3EI45y611osMTHuQUPUiYpiVooerg7TWRwDAlhSM0TuI+BsD0x4kGCuFSRVzSqkfiLiWmY17EALMbCAlMCmI6IwxZo+INgQYEYKBuW5da00PKikjhNNiiPGm01rrbwDwofGehQjjNcv1SZgddALhlJEgwgJFxDNr7acmjFLqCyJuTd6LEGFttpmkYC91Hrk3s1GZFERMmUT01Xv/sQljjPlMRMsxO6WULwnb2D8FEs4j680wScjO5f3vzrlNJszESWq2LYXJgTzjZm56MCHf3zVBxH1r7ftU1splxxKYHEgoUUpTo+grEf303rPH5hxENJqDKQEJtko2q9zGeeycWy3JhpKhWT8+NM/sufIhBwKI+Mta+7pkfxKMtd8Qtdbcx4dUQZcFCQ2I6DcAnLUpf6YMPxhIDDOuxC4C6djoQUE6+tKpewWZ1wlRkq0qUhXptKTlzv93aI3jWmE0Fz2TeujpX73F9TaKy9CeMk8vZusfBnqZ1g5GqyIdJq+XrqNR5AahKr9CCcxGSwAAAABJRU5ErkJggg==)

 dlopen 以指定模式打开指定的动态连接库文件，并返回一个句柄给调用进程，dlerror 返回出现的错误，dlsym 通过句柄和连接符名称获取函数名或者变量名，dlclose 来卸载打开的库。 dlopen 打开模式如下：

 RTLD_LAZY 暂缓决定，等有需要时再解出符号   
　　RTLD_NOW 立即决定，返回前解除所有未决定的符号。

采用上面生成的 libcaculate.so，写个测试程序如下：

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAACbklEQVRoQ+2aMU4dMRCGZw6RC1CSSyQdLZJtKQ2REgoiRIpQkCYClCYpkgIESQFIpIlkW+IIcIC0gUNwiEFGz+hlmbG9b1nesvGW++zxfP7H4/H6IYzkwZFwQAUZmpJVkSeniFJKA8ASIi7MyfkrRPxjrT1JjZ8MLaXUDiJuzwngn2GJaNd7vyP5IoIYY94Q0fEQIKIPRGS8947zSQTRWh8CwLuBgZx479+2BTkHgBdDAgGAC+fcywoyIFWqInWN9BSONbTmFVp/AeA5o+rjKRJ2XwBYRsRXM4ZXgAg2LAPzOCDTJYQx5pSIVlrC3EI45y611osMTHuQUPUiYpiVooerg7TWRwDAlhSM0TuI+BsD0x4kGCuFSRVzSqkfiLiWmY17EALMbCAlMCmI6IwxZo+INgQYEYKBuW5da00PKikjhNNiiPGm01rrbwDwofGehQjjNcv1SZgddALhlJEgwgJFxDNr7acmjFLqCyJuTd6LEGFttpmkYC91Hrk3s1GZFERMmUT01Xv/sQljjPlMRMsxO6WULwnb2D8FEs4j680wScjO5f3vzrlNJszESWq2LYXJgTzjZm56MCHf3zVBxH1r7ftU1splxxKYHEgoUUpTo+grEf303rPH5hxENJqDKQEJtko2q9zGeeycWy3JhpKhWT8+NM/sufIhBwKI+Mta+7pkfxKMtd8Qtdbcx4dUQZcFCQ2I6DcAnLUpf6YMPxhIDDOuxC4C6djoQUE6+tKpewWZ1wlRkq0qUhXptKTlzv93aI3jWmE0Fz2TeujpX73F9TaKy9CeMk8vZusfBnqZ1g5GqyIdJq+XrqNR5AahKr9CCcxGSwAAAABJRU5ErkJggg==)

```
 1 #include <stdio.h>
 2 #include <stdlib.h>
 3 #include <dlfcn.h>
 4 
 5 //动态链接库路径
 6 #define LIB_CACULATE_PATH "./libcaculate.so"
 7 
 8 //函数指针
 9 typedef int (*CAC_FUNC)(int, int);
10 
11 int main()
12 {
13     void *handle;
14     char *error;
15     CAC_FUNC cac_func = NULL;
16 
17     //打开动态链接库
18     handle = dlopen(LIB_CACULATE_PATH, RTLD_LAZY);
19     if (!handle) {
20     fprintf(stderr, "%s\n", dlerror());
21     exit(EXIT_FAILURE);
22     }
23 
24     //清除之前存在的错误
25     dlerror();
26 
27     //获取一个函数
28     *(void **) (&cac_func) = dlsym(handle, "add");
29     if ((error = dlerror()) != NULL)  {
30     fprintf(stderr, "%s\n", error);
31     exit(EXIT_FAILURE);
32     }
33     printf("add: %d\n", (*cac_func)(2,7));
34 
35     cac_func = (CAC_FUNC)dlsym(handle, "sub");
36     printf("sub: %d\n", cac_func(9,2));
37 
38     cac_func = (CAC_FUNC)dlsym(handle, "mul");
39     printf("mul: %d\n", cac_func(3,2));
40 
41     cac_func = (CAC_FUNC)dlsym(handle, "div");
42     printf("div: %d\n", cac_func(8,2));
43 
44     //关闭动态链接库
45     dlclose(handle);
46     exit(EXIT_SUCCESS);
47 }

```

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAACbklEQVRoQ+2aMU4dMRCGZw6RC1CSSyQdLZJtKQ2REgoiRIpQkCYClCYpkgIESQFIpIlkW+IIcIC0gUNwiEFGz+hlmbG9b1nesvGW++zxfP7H4/H6IYzkwZFwQAUZmpJVkSeniFJKA8ASIi7MyfkrRPxjrT1JjZ8MLaXUDiJuzwngn2GJaNd7vyP5IoIYY94Q0fEQIKIPRGS8947zSQTRWh8CwLuBgZx479+2BTkHgBdDAgGAC+fcywoyIFWqInWN9BSONbTmFVp/AeA5o+rjKRJ2XwBYRsRXM4ZXgAg2LAPzOCDTJYQx5pSIVlrC3EI45y611osMTHuQUPUiYpiVooerg7TWRwDAlhSM0TuI+BsD0x4kGCuFSRVzSqkfiLiWmY17EALMbCAlMCmI6IwxZo+INgQYEYKBuW5da00PKikjhNNiiPGm01rrbwDwofGehQjjNcv1SZgddALhlJEgwgJFxDNr7acmjFLqCyJuTd6LEGFttpmkYC91Hrk3s1GZFERMmUT01Xv/sQljjPlMRMsxO6WULwnb2D8FEs4j680wScjO5f3vzrlNJszESWq2LYXJgTzjZm56MCHf3zVBxH1r7ftU1splxxKYHEgoUUpTo+grEf303rPH5hxENJqDKQEJtko2q9zGeeycWy3JhpKhWT8+NM/sufIhBwKI+Mta+7pkfxKMtd8Qtdbcx4dUQZcFCQ2I6DcAnLUpf6YMPxhIDDOuxC4C6djoQUE6+tKpewWZ1wlRkq0qUhXptKTlzv93aI3jWmE0Fz2TeujpX73F9TaKy9CeMk8vZusfBnqZ1g5GqyIdJq+XrqNR5AahKr9CCcxGSwAAAABJRU5ErkJggg==)

编译选项如下：gcc -rdynamic -o main main.c -ldl

测试结果如下所示：

![](http://images.cnitblog.com/i/305504/201405/230024471528503.png)

参考资料：

[http://blog.chinaunix.net/uid-26285146-id-3262288.html](http://blog.chinaunix.net/uid-26285146-id-3262288.html)

[http://www.360doc.com/content/10/1213/22/4947005_77867631.shtml](http://www.360doc.com/content/10/1213/22/4947005_77867631.shtml)

### [dlopen、dlsym 和 dlclose 的使用和举例](http://blog.csdn.net/ostar_liang/article/details/14422423) 

  

  之前用过这三个函数一直没时间整理一下。今天抽时间整理一下。

1、函数简介

dlopen

基本定义

功能：打开一个动态链接库   
 包含头文件：   
 #include <dlfcn.h>   
 函数定义：   
 void * dlopen(const char * pathname, int mode);   
 函数描述：   
 在 dlopen 的（）函数以指定模式打开指定的动态连接库文件，并返回一个句柄给调用进程。使用 dlclose（）来卸载打开的库。   
 mode：分为这两种   
 RTLD_LAZY 暂缓决定，等有需要时再解出符号   
 RTLD_NOW 立即决定，返回前解除所有未决定的符号。   
 RTLD_LOCAL   
 RTLD_GLOBAL 允许导出符号   
 RTLD_GROUP   
 RTLD_WORLD 

  
 返回值:   
 打开错误返回 NULL   
 成功，返回库引用   
 编译时候要加入 -ldl (指定 dl 库)   

dlsym()

   功能：

根据动态链接库操作句柄与符号，返回符号对应的地址。

包含头文件：

#include <dlfcn.h>

函数定义：

void*dlsym(void* handle,const char* symbol)

函数描述：

dlsym 根据动态链接库操作句柄 (handle) 与符号(symbol)，返回符号对应的地址。使用这个函数不但可以获取函数地址，也可以获取变量地址。

handle 是由 [dlopen](http://baike.baidu.com/view/2907309.htm) 打开 [动态链接库](http://baike.baidu.com/view/887.htm)后返回的 [指针](http://baike.baidu.com/view/159417.htm)，symbol 就是要求获取的函数或 [全局变量](http://baike.baidu.com/view/261041.htm)的名称。

dlclose()

dlclose 用于关闭指定句柄的动态链接库，只有当此动态链接库的使用计数为 0 时, 才会真正被系统卸载。

上述都是摘抄，总结为链接的时候需要用到 dl 库，编译的时候需要加上 dlfcn.h 头文件。才能保证编译不会报错。

2、生成动态库

hello.c 函数原型：

  

#include <sys/types.h>  
#include <signal.h>  
#include <stdio.h>  
#include <unistd.h>

typedef struct {  
 const char *module;  
 int  (*GetValue)(char *pszVal);  
 int   (*PrintfHello)();  
} hello_ST_API;

  
int GetValue(char *pszVal)  
{  
 int retval = -1;  
   
 if (pszVal)  
  retval = sprintf(pszVal, "%s", "123456");  
  printf("%s, %d, pszVer = %s\n", __FUNCTION__, __LINE__, pszVal);  
 return retval;  
}

int PrintfHello()  
{  
 int retval = -1;  
   
 printf("%s, %d, hello everyone\n", __FUNCTION__, __LINE__);  
 return 0;  
}

const hello_ST_API  Hello = {  
     .module = "hello",  
   GetValue,  
   PrintfHello,  
};

编译的时候用指令：

gcc -shared -o hello.so hello.c

上面的函数是用一个全局结构体 hello 来指向。在 dlsym 定义中说不仅可以获取函数的地址，还可以获取全局变量的地址。所以此处是想通过 dlsym 来获取全局变量的地址。好处自己慢慢体会。

3、dlopen 代码

#include <sys/types.h>  
#include <signal.h>  
#include <stdio.h>  
#include <unistd.h>  
#include <dlfcn.h>

typedef struct {  
 const char *module;  
 int  (*GetValue)(char *pszVal);  
 int   (*PrintfHello)();  
} hello_ST_API;

  
int main(int argc, char **argv)  
{  
 hello_ST_API *hello;  
 int i = 0;  
 void *handle;  
 char psValue[20] = {0};  
   
 handle = dlopen(“库存放的绝对路径，你可以试试相对路径是不行的 ", RTLD_LAZY);  
 if (! handle) {  
  printf("%s,%d, NULL == handle\n", __FUNCTION__, __LINE__);  
  return -1;  
 }  
 dlerror();

 hello = dlsym(handle, "Hello");  
 if (!hello) {  
  printf("%s,%d, NULL == handle\n", __FUNCTION__, __LINE__);  
  return -1;  
 }

 if (hello && hello->PrintfHello)  
  i = hello->PrintfHello();  
  printf("%s, %d, i = %d\n", __FUNCTION__, __LINE__, i);  
 if (hello && hello->GetValue)  
  i = hello->GetValue(psValue);

 if (hello && hello->module)  
  {  
   printf("%s, %d, module = %s\n", __FUNCTION__, __LINE__, hello->module);  
  }

    dlclose(handle);  
    return 0;  
}

编译指令：gcc -o test hello_dlopen.c -ldl

运行./test 结果如下。

PrintfHello, 27, hello everyone  
main, 36, i = 0  
GetValue, 19, pszVer = 123456  
main, 42, module = hello

可以看到结果正常出来了。

看到没用? dlsym 找到全局结构体 hello 后，可以直接用这个全局结构体指针来使用库里面的函数了，因为我们有时候提供的库不仅仅是一个两个函数的，一般的一个库都会存在多个函数，用这种方式就可以直接使用了。不然找函数名称的话要写多少个 dlsym 啊？

# [dlopen 方式调用 Linux 的动态链接库](http://www.cnblogs.com/brucemengbm/p/6999503.html)

在 dlopen（）函数以指定模式打开指定的动态链接库文件。并返回一个句柄给 [dlsym](http://baike.baidu.com/view/1093952.htm)（）的调用进程。

使用 [dlclose](http://baike.baidu.com/view/3291332.htm)（）来[卸载](http://baike.baidu.com/view/386432.htm)打开的库。

```
功能：打开一个动态链接库，并返回动态链接库的句柄
包括头文件：
#include <dlfcn.h>
函数定义：
void * dlopen( const char * pathname, int mode);
函数描写叙述：
mode是打开方式，其值有多个，不同操作系统上实现的功能有所不同，在linux下，按功能可分为三类：
1、解析方式
RTLD_LAZY：在dlopen返回前，对于动态库中的没有定义的符号不运行解析（仅仅对函数引用有效。对于变量引用总是马上解析）。
RTLD_NOW： 须要在dlopen返回前。解析出全部没有定义符号，假设解析不出来。在dlopen会返回NULL，错误为：: undefined symbol: xxxx.......
2、作用范围，可与解析方式通过“|”组合使用。
RTLD_GLOBAL：动态库中定义的符号可被其后打开的其他库解析。
RTLD_LOCAL： 与RTLD_GLOBAL作用相反，动态库中定义的符号不能被其后打开的其他库重定位。假设没有指明是RTLD_GLOBAL还是RTLD_LOCAL。则缺省为RTLD_LOCAL。
3、作用方式
RTLD_NODELETE： 在dlclose()期间不卸载库，而且在以后使用dlopen()又一次载入库时不初始化库中的静态变量。这个flag不是POSIX-2001标准。
RTLD_NOLOAD： 不载入库。可用于測试库是否已载入(dlopen()返回NULL说明未载入，否则说明已载入），也可用于改变已载入库的flag，如：先前载入库的flag为RTLD_LOCAL，用dlopen(RTLD_NOLOAD|RTLD_GLOBAL)后flag将变成RTLD_GLOBAL。这个flag不是POSIX-2001标准。
RTLD_DEEPBIND：在搜索全局符号前先搜索库内的符号。避免同名符号的冲突。这个flag不是POSIX-2001标准。
返回值:
打开错误返回NULL
成功，返回库引用
编译时候要增加 -ldl (指定dl库)
比如
gcc test.c -o test -ldl
```

  
  

```
#include <stdlib.h>
#include <dlfcn.h>
#include <stdio.h>
 
//申明结构体
typedef struct __test {
    int i;
    void (* echo_fun)(struct __test *p);
}Test;
 
//供动态库使用的注冊函数
void __register(Test *p) {
    p->i = 1;
    p->echo_fun(p);
}
 
int main(void) {
 
    void *handle = NULL;
    char *myso = "./mylib.so";
 
    if((handle = dlopen(myso, RTLD_NOW)) == NULL) {
        printf("dlopen - %sn", dlerror());
        exit(-1);
    }
 
    return 0;
}
```

  

```
#include <stdio.h>
#include <stdlib.h>
 
//申明结构体类型
typedef struct __test {
    int i;
    void (*echo_fun)(struct __test *p);
}Test;
 
//申明注冊函数原型
void __register(Test *p);
 
static void __printf(Test *p) {
    printf("i = %dn", p->i);
}
 
//动态库申请一个全局变量空间
//这样的 ".成员"的赋值方式为c99标准
static Test config = {
    .i = 0,
    .echo_fun = __printf,
};
 
//载入动态库的自己主动初始化函数
void _init(void) {
    printf("initn");
    //调用主程序的注冊函数
    __register(&config);
}
```

  
  

主程序编译: gcc test.c -ldl -rdynamic

动态库编译: gcc -shared -fPIC -nostartfiles -o mylib.so mylib.c

主程序通过 dlopen() 载入一个. so 的动态库文件, 然后动态库会自己主动执行 _init() 初始化函数, 初始化函数打印一个提示信息, 然后调用主程序的注冊函数给结构体又一次赋值, 然后调用结构体的函数指针, 打印该结构体的值. 这样就充分的达到了主程序和动态库的函数相互调用和指针的相互传递.

gcc 參数 -rdynamic 用来通知链接器将全部符号加入到动态符号表中（目的是可以通过使用 dlopen 来实现向后跟踪）.

gcc 參数 -fPIC 作用: 当使用. so 等类的库时, 当遇到多个可运行文件共用这一个库时, 在内存中, 这个库就不会被复制多份, 让每一个可运行文件一对一的使用, 而是让多个可运行文件指向一个库文件, 达到共用. 宗旨: 节省了内存空间, 提高了空间利用率.

```
<pre name="code">dlsym函数：
  函数原型是
  void* dlsym(void* handle,const char* symbol)
  该函数在<dlfcn.h>文件里。
  handle是由dlopen打开动态链接库后返回的指针。symbol就是要求获取的函数的名称，函数  返回值是void*,指向函数的地址，供调用使用。
```

  
  

导入库函数使用方法：

<table bgcolor="#f1f1f1" border="1" cellpadding="0" cellspacing="0" width="95%"><tbody><tr><td><p><code onclick="mdcp.copyCode(event)"><span><span>#</span><span>include</span>&nbsp;<span>&lt;</span>dlfcn<span>.</span>h<span>&gt;</span><br><span>void</span><span>*</span>&nbsp;handle&nbsp;<span>=</span>&nbsp;dlopen<span>(</span><span>"./hello.so"</span><span>,</span>&nbsp;RTLD_LAZY<span>)</span><span>;</span><br><span>typedef</span>&nbsp;<span>void</span>&nbsp;<span>(</span><span>*</span>hello_t<span>)</span><span>(</span><span>)</span><span>;</span><br>hello_t hello&nbsp;<span>=</span>&nbsp;<span>(</span>hello_t<span>)</span>&nbsp;dlsym<span>(</span>handle<span>,</span>&nbsp;<span>"hello"</span><span>)</span><span>;</span><br><br>hello<span>(</span><span>)</span><span>;</span><br>dlclose<span>(</span>handle<span>)</span><span>;</span></span></code></p></td></tr></tbody></table>

注意库函数在库中的定义要用 extern“c”来申明，这样在主函数中才干通过 “hello” 来查找函数。申明的方式有下面两种：

<table bgcolor="#f1f1f1" border="1" cellpadding="0" cellspacing="0" width="95%"><tbody><tr><td><p><code onclick="mdcp.copyCode(event)"><span><span>extern</span>&nbsp;<span>"C"</span>&nbsp;<span>int</span>&nbsp;foo<span>;</span><br><span>extern</span>&nbsp;<span>"C"</span>&nbsp;<span>void</span>&nbsp;bar<span>(</span><span>)</span><span>;</span><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br><span>and</span>&nbsp;<br><br><span>extern</span>&nbsp;<span>"C"</span>&nbsp;<span>{</span><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span>extern</span>&nbsp;<span>int</span>&nbsp;foo<span>;</span><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span>extern</span>&nbsp;<span>void</span>&nbsp;bar<span>(</span><span>)</span><span>;</span><br><span>}</span><br></span></code></p></td></tr></tbody></table>

导入类库方法：

<table bgcolor="#f1f1f1" border="1" cellpadding="0" cellspacing="0" width="95%"><tbody><tr><td><p><code onclick="mdcp.copyCode(event)"><span><span>#</span><span>include</span>&nbsp;<span>"polygon.hpp"</span>&nbsp;<span>//类定义处<br></span><br><span>#</span><span>include</span>&nbsp;<span>&lt;</span>dlfcn<span>.</span>h<span>&gt;</span><br><br><span>void</span><span>*</span>&nbsp;triangle&nbsp;<span>=</span>&nbsp;dlopen<span>(</span><span>"./triangle.so"</span><span>,</span>&nbsp;RTLD_LAZY<span>)</span><span>;</span><br>create_t<span>*</span>&nbsp;create_triangle&nbsp;<span>=</span>&nbsp;<span>(</span>create_t<span>*</span><span>)</span>&nbsp;dlsym<span>(</span>triangle<span>,</span>&nbsp;<span>"create"</span><span>)</span><span>;</span><br><br>destroy_t<span>*</span>&nbsp;destroy_triangle&nbsp;<span>=</span>&nbsp;<span>(</span>destroy_t<span>*</span><span>)</span>&nbsp;dlsym<span>(</span>triangle<span>,</span>&nbsp;<span>"destroy"</span><span>)</span><span>;</span><br>polygon<span>*</span>&nbsp;poly&nbsp;<span>=</span>&nbsp;create_triangle<span>(</span><span>)</span><span>;</span><br><span>// use the class<br></span><br>&nbsp;&nbsp;&nbsp;&nbsp;poly<span>-</span><span>&gt;</span>set_side_length<span>(</span>7<span>)</span><span>;</span><br>&nbsp;&nbsp;&nbsp;&nbsp;<span>cout</span>&nbsp;<span>&lt;</span><span>&lt;</span>&nbsp;<span>"The area is: "</span>&nbsp;<span>&lt;</span><span>&lt;</span>&nbsp;poly<span>-</span><span>&gt;</span>area<span>(</span><span>)</span>&nbsp;<span>&lt;</span><span>&lt;</span>&nbsp;<span>'\n'</span><span>;</span><br><span>// destroy the class<br></span><br>&nbsp;&nbsp;&nbsp;&nbsp;destroy_triangle<span>(</span>poly<span>)</span><span>;</span><br><br>&nbsp;&nbsp;&nbsp;&nbsp;<span>// unload the triangle library<br></span><br>&nbsp;&nbsp;&nbsp;&nbsp;dlclose<span>(</span>triangle<span>)</span><span>;</span><br></span></code></p></td></tr></tbody></table>