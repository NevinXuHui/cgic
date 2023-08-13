---
url: https://blog.csdn.net/TuxedoLinux/article/details/111332565
title: pthread_mutex_t_TuxedoLinux 的博客 - CSDN 博客
date: 2023-05-04 11:27:47
tag: 
banner: "undefined"
banner_icon: 🔖
---
[https://www.cnblogs.com/wangqiwen-jer/p/11741933.html](https://www.cnblogs.com/wangqiwen-jer/p/11741933.html)

在使用互斥锁之前，需要先创建一个互斥锁的对象。 互斥锁的类型是 pthread_mutex_t ，所以定义一个变量就是创建了一个互斥锁。

```
pthread_mutex_t mtx;

```

这就定义了一个互斥锁。但是如果想使用这个互斥锁还是不行的，我们还需要对这个互斥锁进行初始化， 使用函数 pthread_mutex_init() 对互斥锁进行初始化操作。

```
//第二个参数是 NULL 的话，互斥锁的属性会设置为默认属性
pthread_mutex_init(&mtx, NULL);

```

除了使用 pthread_mutex_init() 初始化一个互斥锁，我们还可以使用下面的方式定义一个互斥锁：

```
pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;

```

在头文件 /usr/include/pthread.h 中，对 PTHREAD_MUTEX_INITIALIZER 的声明如下

```
# define PTHREAD_MUTEX_INITIALIZER \
   { { 0, 0, 0, 0, 0, 0, { 0, 0 } } }

```

为什么可以这样初始化呢，因为互斥锁的类型 pthread_mutex_t 是一个联合体， 其声明在文件 /usr/include/bits/pthreadtypes.h 中，代码如下：

/* Data structures for mutex handling.  The structure of the attribute  
   type is not exposed on purpose.  */  
typedef union  
{  
    struct __pthread_mutex_s  
    {  
        int __lock;  
        unsigned int __count;  
        int __owner;  
#if __WORDSIZE == 64  
        unsigned int __nusers;  
#endif  
        /* KIND must stay at this position in the structure to maintain  
           binary compatibility.  */  
        int __kind;  
#if __WORDSIZE == 64  
        int __spins;  
        __pthread_list_t __list;  
# define __PTHREAD_MUTEX_HAVE_PREV  1  
#else  
        unsigned int __nusers;  
        __extension__ union  
        {  
            int __spins;  
            __pthread_slist_t __list;  
        };  
#endif  
    } __data;  
    char __size[__SIZEOF_PTHREAD_MUTEX_T];  
    long int __align;  
} pthread_mutex_t;

## 获取互斥锁

接下来是如何使用互斥锁进行互斥操作。在进行互斥操作的时候， 应该先 "拿到锁" 再执行需要互斥的操作，否则可能会导致多个线程都需要访问的数据结果不一致。 例如在一个线程在试图修改一个变量的时候，另一个线程也试图去修改这个变量， 那就很可能让后修改的这个线程把前面线程所做的修改覆盖了。

下面是获取锁的操作：

### 阻塞调用

```
pthread_mutex_lock(&mtx);

```

这个操作是阻塞调用的，也就是说，如果这个锁此时正在被其它线程占用， 那么 pthread_mutex_lock() 调用会进入到这个锁的排队队列中，并会进入阻塞状态， 直到拿到锁之后才会返回。

### 非阻塞调用

如果不想阻塞，而是想尝试获取一下，如果锁被占用咱就不用，如果没被占用那就用， 这该怎么实现呢？可以使用 pthread_mutex_trylock() 函数。 这个函数和 pthread_mutex_lock() 用法一样，只不过当请求的锁正在被占用的时候， 不会进入阻塞状态，而是立刻返回，并返回一个错误代码 EBUSY，意思是说， 有其它线程正在使用这个锁。

int err = pthread_mutex_trylock(&mtx);  
if(0 != err) {  
    if(EBUSY == err) {  
        //The mutex could not be acquired because it was already locked.  
    }  
}

## 释放互斥锁

用完了互斥锁，一定要记得释放，不然下一个想要获得这个锁的线程， 就只能去等着了，如果那个线程很不幸的使用了阻塞等待，那就悲催了。

释放互斥锁比较简单，使用 pthread_mutex_unlock() 即可：

```
pthread_mutex_unlock(&mtx);

```