**【推荐阅读】**

[一文看懂 linux 内核详解](https://zhuanlan.zhihu.com/p/550697826)

[linux 内核内存管理 - 写时复制](https://zhuanlan.zhihu.com/p/579491341)

[深入了解使用 linux 查看磁盘 io 使用情况](https://zhuanlan.zhihu.com/p/474111479)

众所周知，计算机系统在掉电后也能存储数据的就是磁盘了，所以大量数据大部分时间是存放在磁盘的；现在新买的 PC，磁盘从数百 G 到 1TB 不等；服务器的磁盘从数十 TB 到上百 TB，这么大的存储空间，该怎么高效地管理和使用了？站在硬件角度，cpu 的分页机制把虚拟内存切割成大量 4KB 大小的块，所以 4KB 也成了硬件层面最小的内存分配单元；对比内存，磁盘的管理方式也类似，只不过磁盘最小的存储或读写单元是 512byte，称之为扇区（用户哪怕只想读 1 格 byte，驱动每次也要读 512byte 的数据）；不过现在的文件一般都远超 512byte，所以存储单个文件肯定需要超过 1 个扇区的空间，这就导致了磁盘的磁头要挨个读不同的扇区，花费大量时间在磁盘上寻址，导致 IO 效率低下，形成了瓶颈！为了提升读取效率，磁盘一般都是一次性连续读取多个扇区，即一次性读取一个 "块"（block）。这种由多个扇区组成的 "块"，是文件存取的最小单位。**"块" 的大小，最常见的是 4KB（和内存页的大小保持一致，** 便于从磁盘读写数据？？？），即连续八个 sector 组成一个 block；

　　1、上一篇文章介绍了高速缓存区，为了方便管理这么一大块缓存区，linux 采用了 buffer_head 结构体来描述缓存区的各种属性；同理：磁盘上也是被人为划分成了很多 “块”，为了方便管理这些块，也需要相应的结构体，linux 采用结构体叫 m_inode（或则这样理解：**文件数据都存放在 block 中，那么很显然，我们还必须找到一个地方储存文件的元信息，比如文件的创建者、文件的创建日期、文件的大小等等。这种储存文件元信息的区域就叫做 inode，中文译名为 “索引节点”；每一个文件都有对应的 inode，里面包含了与该文件有关的一些信息**），如下：

　　注意：

- **一个文件只需要一个 inode 节点来存储文件的元信息就够了，所以文件和 inode 节点是一一对应的（注意这里是文件，不是文件名）；**

- **如果说文件很大，占用了很多的磁盘 block，怎么才能找全文件的占用的所有磁盘 block 了？此刻就要用到 inode 结构体的 i_zone[9] 字段了，文件中的数据存放在哪个硬盘上的逻辑块上就是由这个数组来映射的：前面 7 个是直接存储文件数据块，第 8 个是间接块，第 9 个是二级间接块！所有直接 + 间接 + 二级间接块加起来，一共 64M** ，这个在 0.11 版本所在的 1991 年已经非常大了！

```Plain Text
struct m_inode {
    unsigned short i_mode;/*文件类型和属性，ls查看的结果，比如drwx------*/
    unsigned short i_uid;/*文件宿主id*/
    unsigned long i_size;
    unsigned long i_mtime;/*文件内容上一次变动的时间*/
    unsigned char i_gid;/*groupid：宿主所在的组id*/
    unsigned char i_nlinks; /*链接数：有多少个其他的文件夹链接到这里*/
    unsigned short i_zone[9];/*文件映射的逻辑块号*/
/* these are in memory also */
    struct task_struct * i_wait;/*等待该inode节点的进程队列*/
    unsigned long i_atime;/*文件上一次打开的时间*/
    unsigned long i_ctime;/*文件的inode上一次变动的时间*/
    unsigned short i_dev;/*设备号*/
    unsigned short i_num;
    /* 多少个进程在使用这个inode*/
    unsigned short i_count;
    unsigned char i_lock;/*互斥锁*/
    unsigned char i_dirt;
    unsigned char i_pipe;
    unsigned char i_mount;
    unsigned char i_seek;
    /*
    数据是否是最新的，或者说有效的，
    update代表数据的有效性，dirt代表文件是否需要回写,
    比如写入文件的时候，a进程写入的时候，dirt是1，因为需要回写到硬盘，
    但是数据是最新的，update是1，这时候b进程读取这个文件的时候，可以从
    缓存里直接读取。
      */
    unsigned char i_update;
};

```

为了把内存文件块的数据映射到磁盘的 block，linux 专门写了_bmap 函数：

![](https://pic4.zhimg.com/v2-5836eae64e4402e70435b03aad25093b_r.jpg)

i_zone 映射关系图示：

```Plain Text
//// 文件数据块映射到盘块的处理操作。（block位图处理函数，bmap - block map）
// 参数：inode - 文件的i节点指针；block - 文件中的数据块号；create - 创建块标志。
// 该函数把指定的文件数据块block对应到设备上逻辑块上，并返回逻辑块号。如果创建标志
// 置位，则在设备上对应逻辑块不存在时就申请新磁盘块，返回文件数据块block对应在设备
// 上的逻辑块号（盘块号）。
static int _bmap(struct m_inode * inode,int block,int create)
{
    struct buffer_head * bh;
    int i;

    // 首先判断参数文件数据块号block的有效性。如果块号小于0，则停机。如果块号大于
    // 直接块数7+间接块数(相当于二级指针)512+二次间接块数(相当于三级指针)512*512，超出文件系统表示范围，则停机。
    // 这种间接块、二次间接块类似内存分页的机制
    if (block<0)
        panic("_bmap: block<0");
    if (block >= 7+512+512*512)
        panic("_bmap: block>big");
    // 然后根据文件块号的大小值和是否设置了创建标志分别进行处理。如果该块号小于7，
    // 则使用直接块表示。如果创建标志置位，并且i节点中对应块的逻辑块(区段)字段为0，
    // 则相应设备申请一磁盘块（逻辑块），并且将磁盘上逻辑块号（盘块号）填入逻辑块
    // 字段中。然后设置i节点改变时间，置i节点已修改标志。然后返回逻辑块号。
    if (block<7) {
        if (create && !inode->i_zone[block])
            if ((inode->i_zone[block]=new_block(inode->i_dev))) {
                inode->i_ctime=CURRENT_TIME;
                inode->i_dirt=1;
            }
        return inode->i_zone[block];
    }
    // 如果该块号>=7,且小于7+512，则说明使用的是一次间接块。下面对一次间接块进行处理。
    // 如果是创建，并且该i节点中对应间接块字段i_zone[7]是0，表明文件是首次使用间接块，
    // 则需申请一磁盘块用于存放间接块信息，并将此实际磁盘块号填入间接块字段中。然后
    // 设置i节点修改标志和修改时间。如果创建时申请磁盘块失败，则此时i节点间接块字段
    // i_zone[7] = 0,则返回0.或者不创建，但i_zone[7]原来就为0，表明i节点中没有间接块，
    // 于是映射磁盘是吧，则返回0退出。
    block -= 7;
    if (block<512) {
        if (create && !inode->i_zone[7])
            if ((inode->i_zone[7]=new_block(inode->i_dev))) {
                inode->i_dirt=1;
                inode->i_ctime=CURRENT_TIME;
            }
        if (!inode->i_zone[7])
            return 0;
        // 现在读取设备上该i节点的一次间接块。并取该间接块上第block项中的逻辑块号（盘块
        // 号）i。每一项占2个字节。如果是创建并且间接块的第block项中的逻辑块号为0的话，
        // 则申请一磁盘块，并让间接块中的第block项等于该新逻辑块块号。然后置位间接块的
        // 已修改标志。如果不是创建，则i就是需要映射（寻找）的逻辑块号。
        if (!(bh = bread(inode->i_dev,inode->i_zone[7])))
            return 0;
        i = ((unsigned short *) (bh->b_data))[block];
        if (create && !i)
            if ((i=new_block(inode->i_dev))) {
                ((unsigned short *) (bh->b_data))[block]=i;
                bh->b_dirt=1;
            }
        // 最后释放该间接块占用的缓冲块，并返回磁盘上新申请或原有的对应block的逻辑块号。
        brelse(bh);
        return i;
    }
    // 若程序运行到此，则表明数据块属于二次间接块。其处理过程与一次间接块类似。下面是对
    // 二次间接块的处理。首先将block再减去间接块所容纳的块数(512)，然后根据是否设置了
    // 创建标志进行创建或寻找处理。如果是新创建并且i节点的二次间接块字段为0，则序申请一
    // 磁盘块用于存放二次间接块的一级信息，并将此实际磁盘块号填入二次间接块字段中。之后，
    // 置i节点已修改标志和修改时间。同样地，如果创建时申请磁盘块失败，则此时i节点二次
    // 间接块字段i_zone[8]为0，则返回0.或者不是创建，但i_zone[8]原来为0，表明i节点中没有
    // 间接块，于是映射磁盘块失败，返回0退出。
    block -= 512;
    if (create && !inode->i_zone[8])
        if ((inode->i_zone[8]=new_block(inode->i_dev))) {
            inode->i_dirt=1;
            inode->i_ctime=CURRENT_TIME;
        }
    if (!inode->i_zone[8])
        return 0;
    // 现在读取设备上该i节点的二次间接块。并取该二次间接块的一级块上第 block/512 项中
    // 的逻辑块号i。如果是创建并且二次间接块的一级块上第 block/512 项中的逻辑块号为0的
    // 话，则需申请一磁盘块(逻辑块)作为二次间接块的二级快i，并让二次间接块的一级块中
    // 第block/512 项等于二级块的块号i。然后置位二次间接块的一级块已修改标志。并释放
    // 二次间接块的一级块。如果不是创建，则i就是需要映射的逻辑块号。
    if (!(bh=bread(inode->i_dev,inode->i_zone[8])))
        return 0;
    i = ((unsigned short *)bh->b_data)[block>>9];
    if (create && !i)
        if ((i=new_block(inode->i_dev))) {
            ((unsigned short *) (bh->b_data))[block>>9]=i;
            bh->b_dirt=1;
        }
    brelse(bh);
    // 如果二次间接块的二级块块号为0，表示申请磁盘块失败或者原来对应块号就为0，则返回
    // 0退出。否则就从设备上读取二次间接块的二级块，并取该二级块上第block项中的逻辑块号。
    if (!i)
        return 0;
    if (!(bh=bread(inode->i_dev,i)))
        return 0;
    i = ((unsigned short *)bh->b_data)[block&511];
    // 如果是创建并且二级块的第block项中逻辑块号为0的话，则申请一磁盘块（逻辑块），作为
    // 最终存放数据信息的块。并让二级块中的第block项等于该新逻辑块块号(i)。然后置位二级块
    // 的已修改标志。
    if (create && !i)
        if ((i=new_block(inode->i_dev))) {
            ((unsigned short *) (bh->b_data))[block&511]=i;
            bh->b_dirt=1;
        }
    // 最后释放该二次间接块的二级块，返回磁盘上新申请的或原有的对应block的逻辑块号。
    brelse(bh);
    return i;
}

```

通过上述的结构体，inode 是管理起来了，但还是不够，还缺了一些属性，比如 inode 又多少了？那些被使用了？哪些还空着？块被锁定了么等等，为了继续管理这些属性，linux 又创建了一个叫做 super_block 的结构体：

```Plain Text
struct super_block {
    unsigned short s_ninodes;/*i节点数量*/
    unsigned short s_nzones;/*文件系统总长度：block < sb->s_firstdatazone || block >= sb->s_nzones*/
    unsigned short s_imap_blocks;/*i节点位图数量*/
    unsigned short s_zmap_blocks;/*数据块位图数量*/
    unsigned short s_firstdatazone;/*第一个块的位置：block < sb->s_firstdatazone || block >= sb->s_nzones*/
    unsigned short s_log_zone_size;
    unsigned long s_max_size;
    unsigned short s_magic;
    /* These are only in memory */
    struct buffer_head * s_imap[8];/*i node位图在高速缓存区的指针数组*/
    struct buffer_head * s_zmap[8];/*逻辑块位图在高速缓存区的指针数组*/
    unsigned short s_dev;/*设备号，可以通过该号找到超级块*/
    struct m_inode * s_isup;/*根目录的i node*/
    struct m_inode * s_imount; /*文件系统filesystem安装的i node*/
    unsigned long s_time;/*修改时间*/
    struct task_struct * s_wait;/*等待该块的进程*/
    unsigned char s_lock;/*是否被锁定*/
    unsigned char s_rd_only;/*是否只读*/
    unsigned char s_dirt;/*是否被修改*/
};

```

Linux 文件系统格式化时候，格式化上面三个区域：supper block， inode 与 block 的区块，假设某一个数据的属性与权限数据是放置到 inode 5 号，而这个 inode 记录了档案数据的实际放置点为 3,4,10 这四个 block 号码，此时我们的操作系统就能够据此来寻找数据了，称为索引式文件系统；上述的文字描述看起来可能有点抽象，这些属性之间的关系如下图所示：**通过超级块检索数据块位图和 inode 块位图；再通过数据块位图检索数据块，inode 块位图检索 inode 节点块！所以说抓住了超级块，就等于检索了整个文件系统！**

　　注意：

- 　　下面图示中每个块的大小统一都是 1024byte=1KB，所以一个数据块位图能表示 1024*8=8192 个数据块！每个数据块是 1KB，单个超级块一共能管理 8MB 的磁盘空间！0.11 这个版本一共用了 8 个超级块，能管理 8*8MB=64MB 的磁盘空间！

- block 号是线性增加的，所以 block 号的计算方法 (inode.c/read_node 方法)：block = 2 + sb->s_imap_blocks + sb->s_zmap_blocks + (inode->i_num-1)/INODES_PER_BLOCK;

- 　　inode 也是存放在快里面的，每块能存放 inode 节点数量计算公式：#define INODES_PER_BLOCK ((BLOCK_SIZE)/(sizeof (struct d_inode)))

![](https://pic2.zhimg.com/v2-4f8bbf10f44a122a4685a08b34af2afd_r.jpg)

和 task 数组类似，linux 仍然采用数组的形式统一集中管理所有超级块，这个版本一共设置了 8 个超级块：

```Plain Text
// 超级块结构表数组（NR_SUPER = 8）
struct super_block super_block[NR_SUPER];

```

通过遍历超级块数组、比对设备号找到超级块结构体；这里注意：**linux 常见的 mount 命令，本质就是把 super_block 的 dev 字段设置成对应的设备，让 super_block 关联上设备；然后把 super_block 读到高速缓存区，后续操作系统或应用程序直接读写该缓存区；最后把 super_block 的实例加入超级块数组，便于统一管理**！

```Plain Text
//// 取指定设备的超级块
// 在超级块表（数组）中搜索指定设备dev的超级块结构信息。若找到刚返回超级块的指针，
// 否则返回空指针
struct super_block * get_super(int dev)
{
    struct super_block * s;
    // 首先判断参数给出设备的有效性。若设备号为0则返回NULL，然后让s指向超级块数组
    // 起始处，开始搜索整个超级块数组，以寻找指定设备dev的超级块。
    if (!dev)
        return NULL;
    s = 0+super_block;
    while (s < NR_SUPER+super_block)
        // 如果当前搜索项是指定设备的超级块，即该超级块的设备号字段值与函数参数指定的
        // 相同，则先等待该超级块解锁。在等待期间，该超级块项有可能被其他设备使用，因此
        // 等待返回之后需要再判断一次是否是指定设备的超级块，如果是则返回该超级块的指针。
        // 否则就重新对超级块数组再搜索一遍，因此此时s需重又指向超级块数组开始处。
        if (s->s_dev == dev) {
            wait_on_super(s);
            if (s->s_dev == dev)
                return s;
            s = 0+super_block;
        // 如果当前搜索项不是，则检查下一项，如果没有找到指定的超级块，则返回空指针。
        } else
            s++;
    return NULL;
}

```

2、上面的各种框架搭建好后，在正式填充和使用这些结构体之前，还需要完善位图工具，毕竟数据块和 inode 都涉及到位图块的使用了嘛！linux 有个 bitmap.c 文件提供了大量的位图操作，比如：

（1）clear_block: 清空 1024byte 的内存，作用了 memset 完全一样！

```Plain Text
//// 将指定地址（addr）处的一块1024字节内存清零
// 输入：eax = 0; ecx = 以字节为单位的数据块长度（BLOCK_SIZE/4）；edi ＝ 指定
// 起始地址addr。
#define clear_block(addr) \
__asm__ __volatile__ ("cld\n\t" \       // 清方向位
    "rep\n\t" \                         // 重复执行存储数据(0).
    "stosl" \
    ::"a" (0),"c" (BLOCK_SIZE/4),"D" ((long) (addr)))

```

(2) 指定 bit 位置 1，并返回原 bit 值；

```Plain Text
//// 把指定地址开始的第nr个位偏移处的bit位置位(nr可大于321).返回原bit位值。
// 输入：%0-eax(返回值)：%1 -eax(0)；%2-nr，位偏移值；%3-(addr)，addr的内容。
// res是一个局部寄存器变量。该变量将被保存在指定的eax寄存器中，以便于高效
// 访问和操作。这种定义变量的方法主要用于内嵌汇编程序中。详细说明可以参考
// gcc手册”在指定寄存器中的变量“。整个宏是一个语句表达式(即圆括号括住的组合句)，
// 其值是组合语句中最后一条表达式语句res的值。
// btsl指令用于测试并设置bit位。把基地址(%3)和bit位偏移值(%2)所指定的bit位值
// 先保存到进位标志CF中，然后设置该bit位为1.指令setb用于根据进位标志CF设置
// 操作数(%al)。如果CF=1则%al = 1,否则%al = 0。
#define set_bit(nr,addr) ({\
register int res ; \
__asm__ __volatile__("btsl %2,%3\n\tsetb %%al": \
"=a" (res):"0" (0),"r" (nr),"m" (*(addr))); \
res;})

```

相应的，也有对指定 bit 清 0 的方法：

```Plain Text
//// 复位指定地址开始的第nr位偏移处的bit位。返回原bit位值的反码。
// 输入：%0-eax(返回值)；%1-eax(0)；%2-nr,位偏移值；%3-(addr)，addr的内容。
// btrl指令用于测试并复位bit位。其作用与上面的btsl类似，但是复位指定bit位。
// 指令setnb用于根据进位标志CF设置操作数(%al).如果CF=1则%al=0,否则%al=1.
#define clear_bit(nr,addr) ({\
register int res ; \
__asm__ __volatile__("btrl %2,%3\n\tsetnb %%al": \
"=a" (res):"0" (0),"r" (nr),"m" (*(addr))); \
res;})

```

**【文章福利】小编推荐自己的 Linux 内核技术交流群：[【977878001】](https://jq.qq.com/?_wv=1027&k=vkcwSVb6)整理一些个人觉得比较好得学习书籍、视频资料；进群私聊群管理领取内核资料包**（含视频教程、电子书、实战项目及代码）

![](https://pic3.zhimg.com/v2-40ec6dbc76690dff8fb79f74333f6476_r.jpg)

**内核资料直通车：**[Linux 内核源码技术学习路线 + 视频教程代码资料](https://docs.qq.com/doc/DUGZVQk1qWVBHTEl3)

**学习直通车：**[Linux 内核源码 / 内存调优 / 文件系统 / 进程管理 / 设备驱动 / 网络协议栈](https://ke.qq.com/course/4032547?flowToken=1044374)

（3）从指定地址开始寻找第一个 bit 为 0 的位，目的就是找第一个没被用的块；

```Plain Text
//// 从addr开始寻找第1个0值bit位。
// 输入：%0-ecx(返回值)；%1-ecx(0); %2-esi(addr).
// 在addr指定地址开始的位图中寻找第1个是0的bit位，并将其距离addr的bit位偏移
// 值返回。addr是缓冲块数据区的地址，扫描寻找的范围是1024字节（8192bit位）。
#define find_first_zero(addr) ({ \
int __res; \
__asm__ __volatile__ ("cld\n" \         // 清方向位
    "1:\tlodsl\n\t" \                   // 取[esi]→eax.
    "notl %%eax\n\t" \                  // eax中每位取反。
    "bsfl %%eax,%%edx\n\t" \            // 从位0扫描eax中是1的第1个位，其偏移值→edx
    "je 2f\n\t" \                       // 如果eax中全是0，则向前跳转到标号2处。
    "addl %%edx,%%ecx\n\t" \            // 偏移值加入ecx(ecx是位图首个0值位的偏移值)
    "jmp 3f\n" \                        // 向前跳转到标号3处
    "2:\taddl $32,%%ecx\n\t" \          // 未找到0值位，则将ecx加1个字长的位偏移量32
    "cmpl $8192,%%ecx\n\t" \            // 已经扫描了8192bit位(1024字节)
    "jl 1b\n" \                         // 若还没有扫描完1块数据，则向前跳转到标号1处
    "3:" \                              // 结束。此时ecx中是位偏移量。
    :"=c" (__res):"c" (0),"S" (addr)); \
__res;})

```

3、光有工具还不够，要先生成超级块、inode 位图和数据块才能运营整个文件系统，不是么？所以还要先建 inode：

```Plain Text
//// 为设备dev建立一个新i节点。初始化并返回该新i节点的指针。
// 在内存i节点表中获取一个空闲i节点表项，并从i节点位图中找一个空闲i节点。
struct m_inode * new_inode(int dev)
{
    struct m_inode * inode;
    struct super_block * sb;
    struct buffer_head * bh;
    int i,j;

    // 首先从内存i节点表(inode_table)中获取一个空闲i节点项，并读取指定设备的
    // 超级块结构。然后扫描超级块中8块i节点位图，寻找首个0bit位，寻找空闲节点，
    // 获取放置该i节点的节点号。如果全部扫描完还没找到，或者位图所在的缓冲块无效
    // (bh=NULL),则放回先前申请的i节点表中的i节点，并返回NULL退出(没有空闲的i节点)。
    if (!(inode=get_empty_inode()))
        return NULL;
    if (!(sb = get_super(dev)))
        panic("new_inode with unknown device");
    j = 8192;
    for (i=0 ; i<8 ; i++)
        if ((bh=sb->s_imap[i]))
            if ((j=find_first_zero(bh->b_data))<8192)
                break;
    if (!bh || j >= 8192 || j+i*8192 > sb->s_ninodes) {
        iput(inode);
        return NULL;
    }
    // 现在我们已经找到了还未使用的i节点号j。于是置位i节点j对应的i节点位图相应bit位。
    // 然后置i节点位图所在缓冲块已修改标志。最后初始化该i节点结构(i_ctime是i节点内容改变时间)。
    if (set_bit(j,bh->b_data))
        panic("new_inode: bit already set");
    bh->b_dirt = 1;
    inode->i_count=1;                           // 引用计数
    inode->i_nlinks=1;                          // 文件目录项连接数
    inode->i_dev=dev;                           // i节点所在的设备号
    inode->i_uid=current->euid;                 // i节点所属用户ID
    inode->i_gid=current->egid;                 // 组id
    inode->i_dirt=1;                            // 已修改标志置位
    inode->i_num = j + i*8192;                  // 对应设备中的i节点号
    inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
    return inode;
}

```

上述方法调用了 get_empty_inode，核心思想是**从 inode_table 中找空闲的 inode，主要依靠判断 i_count、i_dirt、i_lock 这 3 个字段** ：

```Plain Text
//// 从i节点表(inode_table)中获取一个空闲i节点项。
// 寻找引用计数count为0的i节点，并将其写盘后清零，返回指针。引用计数被置1.
struct m_inode * get_empty_inode(void)
{
    struct m_inode * inode;
    static struct m_inode * last_inode = inode_table;
    int i;

    do {
        // 在初始化last_inode指针指向i节点表头一项后循环扫描整个i节点表。如果last_inode
        // 已经指向i节点表的最后一项之后，则让其重新指向i节点表开始处，以继续循环寻找空闲
        // i节点项。如果last_inode所指向的i节点的计数值为0，则说明可能找到空闲i节点项。
        // 让inode指向该i节点。如果该i节点的已修改标志和锁定标志均为0，则我们可以使用该i
        // 节点，于是退出for循环。
        inode = NULL;
        for (i = NR_INODE; i ; i--) {
            if (++last_inode >= inode_table + NR_INODE)
                last_inode = inode_table;
            if (!last_inode->i_count) {
                inode = last_inode;
                if (!inode->i_dirt && !inode->i_lock)
                    break;
            }
        }
        // 如果没有找到空闲i节点（inode=NULL）,则将i节点表打印出来供调试使用，并停机。
        if (!inode) {
            for (i=0 ; i<NR_INODE ; i++)
                printk("%04x: %6d\t",inode_table[i].i_dev,
                    inode_table[i].i_num);
            panic("No free inodes in mem");
        }
        // 等待该i节点解锁，如果该i节点已修改标志被置位的话，则将该i节点刷新，因为刷新时
        // 可能会睡眠，因此需要再次循环等待该i节点解锁。
        wait_on_inode(inode);
        while (inode->i_dirt) {
            write_inode(inode);
            wait_on_inode(inode);
        }
        // 如果i节点又被其他占用的话(i节点的计数值不为0了)，则重新寻找空闲i节点。否则
        // 说明已找到符合要求的空闲i节点项。则将该i节点项内容清零，并置引用计数为1，
        // 返回该i节点指针。
    } while (inode->i_count);
    memset(inode,0,sizeof(*inode));
    inode->i_count = 1;
    return inode;
}

```

用完后可以释放：注意看最后一行调用了 memset，直接把整个 inode 节点存的数据全部清零！（这里可以对比后续的 **iput 方法，只是执行了 inode->i_count--，把引用计数减一，并未清空 inode 的任何数据！** ）

```Plain Text
//// 释放指定的i节点
// 该函数首先判断参数给出的i节点号的有效性和课释放性。若i节点仍然在使用中则不能
// 被释放。然后利用超级块信息对i节点位图进行操作，复位i节点号对应的i节点位图中
// bit位，并清空i节点结构。
void free_inode(struct m_inode * inode)
{
    struct super_block * sb;
    struct buffer_head * bh;

    // 首先判断参数给出的需要释放的i节点有效性或合法性。如果i节点指针＝NULL，则
    // 退出。如果i节点上的设备号字段为0，则说明该节点没有使用。于是用0清空对应i
    // 节点所占内存区并返回。memset()定义在include/string.h中，这里表示用0填写
    // inode指针指定处、长度是sizeof(*inode)的内存快。
    if (!inode)
        return;
    if (!inode->i_dev) {
        memset(inode,0,sizeof(*inode));
        return;
    }
    // 如果此i节点还有其他程序引用，则不能释放，说明内核有问题，停机。如果文件
    // 连接数不为0，则表示还有其他文件目录项在使用该节点，因此也不应释放，而应该放回等。
    if (inode->i_count>1) {
        printk("trying to free inode with count=%d\n",inode->i_count);
        panic("free_inode");
    }
    if (inode->i_nlinks)
        panic("trying to free inode with links");
    // 在判断完i节点的合理性之后，我们开始利用超级块信息对其中的i节点位图进行
    // 操作。首先取i节点所在设备的超级块，测试设备是否存在。然后判断i节点号的
    // 范围是否正确，如果i节点号等于0或大于该设备上i节点总数，则出错(0号i节点
    // 保留没有使用)。如果该i节点对应的节点位图不存在，则出错。因为一个缓冲块
    // 的i节点位图有8192 bit。因此i_num>>13(即i_num/8192)可以得到当前i节点所在
    // 的s_imap[]项，即所在盘块。
    if (!(sb = get_super(inode->i_dev)))
        panic("trying to free inode on nonexistent device");
    if (inode->i_num < 1 || inode->i_num > sb->s_ninodes)
        panic("trying to free inode 0 or nonexistant inode");
    if (!(bh=sb->s_imap[inode->i_num>>13]))
        panic("nonexistent imap in superblock");
    // 现在我们复位i节点对应的节点位图中的bit位。如果该bit位已经等于0，则显示
    // 出错警告信息。最后置i节点位图所在缓冲区已修改标志，并清空该i节点结构
    // 所占内存区。
    if (clear_bit(inode->i_num&8191,bh->b_data))
        printk("free_inode: bit already cleared.\n\r");
    bh->b_dirt = 1;
    memset(inode,0,sizeof(*inode));
}

```

4、由于数据都是先存在高速缓存区，不会直接读写磁盘，所以此时要先在高速缓存区新建块，这里面就涉及到了上面的位图操作！

```Plain Text
//// 向设备申请一个逻辑块。
// 函数首先取得设备的超级块，并在超级块中的逻辑块位图中寻找第一个0值bit位(代表一个
// 空闲逻辑块)。然后位置对应逻辑块在逻辑块位图中的bit位。接着为该逻辑块在缓冲区中取得
// 一块对应缓冲块。最后将该缓冲块清零，并设置其已更新标志和已修改标志。并返回逻辑块
// 号。函数执行成功则返回逻辑块号，否则返回0.
int new_block(int dev)
{
    struct buffer_head * bh;
    struct super_block * sb;
    int i,j;

    // 首先获取设备dev的超级块。如果指定设备的超级块不存在，则出错当机。然后扫描
    // 文件系统的8块逻辑位图，寻找首个0值bit位，以寻找空闲逻辑块，获取放置该逻辑块的
    // 块号。如果全部扫描完8块逻辑块位图的所有bit位(i >= 8 或 j >= 8192)还没找到0值
    // bit位或者位图所在的缓冲块指针无效(bh=NULL)则返回0退出(没有空闲逻辑块)。
    if (!(sb = get_super(dev)))
        panic("trying to get new block from nonexistant device");
    j = 8192;
    for (i=0 ; i<8 ; i++)
        if ((bh=sb->s_zmap[i]))
            if ((j=find_first_zero(bh->b_data))<8192)
                break;
    if (i>=8 || !bh || j>=8192)
        return 0;
    // 接着设置找到的新逻辑块j对应逻辑块位图中的bit位。若对应bit位已经置位，则出错
    // 停机。否则置存放位图的对应缓冲区块已修改标志。因为逻辑块位图仅表示盘上数据区
    // 中逻辑块的占用情况，则逻辑块位图中bit位偏移值表示从数据区开始处算起的块号，
    // 因此这里需要加上数据区第1个逻辑块的块号，把j转换成逻辑块号。此时如果新逻辑块
    // 大于该设备上的总逻辑块数，则说明指定逻辑块在对应设备上不存在。申请失败，返回0退出。
    if (set_bit(j,bh->b_data))
        panic("new_block: bit already set");
    bh->b_dirt = 1;
    j += i*8192 + sb->s_firstdatazone-1;
    if (j >= sb->s_nzones)
        return 0;
    // 然后在高速缓冲区中为该设备上指定的逻辑块号取得一个缓冲块，并返回缓冲块头指针。
    // 因为刚取得的逻辑块其引用次数一定为1(getblk()中会设置)，因此若不为1则停机。
    // 最后将新逻辑块清零，并设置其已更新标志和已修改标志。然后释放对应缓冲块，返回
    // 逻辑块号。
    if (!(bh=getblk(dev,j)))
        panic("new_block: cannot get block");
    if (bh->b_count != 1)
        panic("new block: count is != 1");
    clear_block(bh->b_data);
    bh->b_uptodate = 1;
    bh->b_dirt = 1;
    brelse(bh);
    return j;
}

```

块用完后也需要释放，如下：先把位图对应的位置清 0，再把高速缓存区对应的块释放；

```Plain Text
//// 释放设备dev上数据区中的逻辑块block.
// 复位指定逻辑块block对应的逻辑块位图bit位
// 参数：dev是设备号，block是逻辑块号（盘块号）
void free_block(int dev, int block)
{
    struct super_block * sb;
    struct buffer_head * bh;

    // 首先取设备dev上文件系统的超级块信息，根据其中数据区开始逻辑块号和文件系统中逻辑
    // 块总数信息判断参数block的有效性。如果指定设备超级块不存在，则出错当机。若逻辑块
    // 号小于盘上面数据区第一个逻辑块的块号或者大于设备上总逻辑块数，也出错当机。
    if (!(sb = get_super(dev)))
        panic("trying to free block on nonexistent device");
    if (block < sb->s_firstdatazone || block >= sb->s_nzones)
        panic("trying to free block not in datazone");
    // 然后从hash表中寻找该块数据。若找到了则判断其有效性，并清已修改和更新标志，释放
    // 该数据块。该段代码的主要用途是如果该逻辑块目前存在于高速缓冲区中，就释放对应
    // 的缓冲块。
    bh = get_hash_table(dev,block);
    // 下面的代码会造成数据块不能释放。因为当b_count > 1时，这段代码会仅打印一段信息而
    // 没有执行释放操作。
    if (bh) {
        if (bh->b_count != 1) {
            printk("trying to free block (%04x:%d), count=%d\n",
                dev,block,bh->b_count);
            return;
        }
        bh->b_dirt=0;
        bh->b_uptodate=0;
        brelse(bh);
    }
    // 接着我们复位block在逻辑块位图中的bit（置0），先计算block在数据区开始算起的数据
    // 逻辑块号(从1开始计数)。然后对逻辑块(区块)位图进行操作，复位对应的bit位。如果对应
    // bit位原来就是0，则出错停机。由于1个缓冲块有1024字节，即8192比特位，因此block/8192
    // 即可计算出指定块block在逻辑位图中的哪个块上。而block&8192可以得到block在逻辑块位图
    // 当前块中的bit偏移位置。，不用担心偏移超出8191的范围。
    block -= sb->s_firstdatazone - 1 ;
    if (clear_bit(block&8191,sb->s_zmap[block/8192]->b_data)) {
        printk("block (%04x:%d) ",dev,block+sb->s_firstdatazone-1);
        panic("free_block: bit already cleared");
    }
    // 最后置相应逻辑块位图所在缓冲区已修改标志。
    sb->s_zmap[block/8192]->b_dirt = 1;
}

```

注意：上述的各种块操作，都是针对内存中的高速缓存区，并未直接操作磁盘！

5、（1）前面建好了 block 和 inode，至此终于可以开始读写数据了，比如这里的 write_inode 函数：

```Plain Text
//// 将i节点信息写入缓冲区中。
// 该函数把参数指定的i节点写入缓冲区相应的缓冲块中，待缓冲区刷新时会写入盘中。为了确定i节点
// 所在的设备逻辑块号（或缓冲块），必须首先读取相应设备上的超级块，以获取用于计算逻辑块号的
// 每块i节点数信息INODES_PER_BLOCK。在计算出i节点所在的逻辑块号后，就把该逻辑块读入一缓冲块
// 中。然后把i节点内容复制到缓冲块的相应位置处。
static void write_inode(struct m_inode * inode)
{
    struct super_block * sb;
    struct buffer_head * bh;
    int block;

    // 首先锁定该i节点，如果该i节点没有被修改或者该i节点的设备号等于零，则解锁该i节点，并退出。
    // 对于没有被修改过的i节点，其内容与缓冲区中或设备中的相同。然后获取该i节点的超级块。
    lock_inode(inode);
    if (!inode->i_dirt || !inode->i_dev) {
        unlock_inode(inode);
        return;
    }
    if (!(sb=get_super(inode->i_dev)))
        panic("trying to write inode without device");
    // 该i节点所在的设备逻辑块号＝（启动块+超级块）+i节点位图占用的块数+逻辑块位图占用的块数
    // +（i节点号-1）/每块含有的i节点数。我们从设备上读取i节点所在的逻辑块，并将该i节点信息复制
    // 到逻辑块对应i节点的项位置处。
    block = 2 + sb->s_imap_blocks + sb->s_zmap_blocks + (inode->i_num-1)/INODES_PER_BLOCK;
    if (!(bh=bread(inode->i_dev,block)))
        panic("unable to read i-node block");
    ((struct d_inode *)bh->b_data)
        [(inode->i_num-1)%INODES_PER_BLOCK] =
            *(struct d_inode *)inode;
    // 然后置缓冲区已修改标志，而i节点内容已经与缓冲区中的一致，因此修改标志置零。然后释放该
    // 含有i节点的缓冲区，并解锁该i节点。
    bh->b_dirt=1;
    inode->i_dirt=0;
    brelse(bh);
    unlock_inode(inode);
}

```

注意：上面的 write 函数并未直接把数据写入磁盘，而是先写入了缓存区，所以 linux 又提供了专门同步的接口，如下：这两个函数最终**都调用了 ll_rw_block 方法向磁盘写数据**！其中 sys_sync 还是个系统调用了！

```Plain Text
//// 设备数据同步，这是个系统调用；
// 同步设备和内存高速缓冲中数据，其中sync_inode()定义在inode.c中。
// 把内存中高速缓存区的数写回到磁盘，需要调用磁盘的驱动代码
int sys_sync(void)
{
    int i;
    struct buffer_head * bh;

    // 首先调用i节点同步函数，把内存i节点表中所有修改过的i节点写入高速缓冲中。
    // 然后扫描所有高速缓冲区，对已被修改的缓冲块产生写盘请求，将缓冲中数据写入
    // 盘中，做到高速缓冲中的数据与设备中的同步。
    sync_inodes();        /* write out inodes into buffers */
    bh = start_buffer;
    for (i=0 ; i<NR_BUFFERS ; i++,bh++) {
        wait_on_buffer(bh);                 // 等待缓冲区解锁(如果已经上锁的话)
        if (bh->b_dirt)
            ll_rw_block(WRITE,bh);          // 产生写设备块请求
    }
    return 0;
}

//// 对指定设备进行高速缓冲数据与设备上数据的同步操作
// 该函数首先搜索高速缓冲区所有缓冲块。对于指定设备dev的缓冲块，若其数据已经
// 被修改过就写入盘中(同步操作)。然后把内存中i节点表数据写入 高速缓冲中。之后
// 再对指定设备dev执行一次与上述相同的写盘操作。
int sync_dev(int dev)
{
    int i;
    struct buffer_head * bh;

    // 首先对参数指定的设备执行数据同步操作，让设备上的数据与高速缓冲区中的数据
    // 同步。方法是扫描高速缓冲区中所有缓冲块，对指定设备dev的缓冲块，先检测其
    // 是否已被上锁，若已被上锁就睡眠等待其解锁。然后再判断一次该缓冲块是否还是
    // 指定设备的缓冲块并且已修改过(b_dirt标志置位)，若是就对其执行写盘操作。
    // 因为在我们睡眠期间该缓冲块有可能已被释放或者被挪作他用，所以在继续执行前
    // 需要再次判断一下该缓冲块是否还是指定设备的缓冲块。
    bh = start_buffer;
    for (i=0 ; i<NR_BUFFERS ; i++,bh++) {
        if (bh->b_dev != dev)               // 不是设备dev的缓冲块则继续
            continue;
        wait_on_buffer(bh);                     // 等待缓冲区解锁
        if (bh->b_dev == dev && bh->b_dirt)
            ll_rw_block(WRITE,bh); //lowlevel
    }
    // 再将i节点数据吸入高速缓冲。让i节点表inode_table中的inode与缓冲中的信息同步。
    sync_inodes();
    // 然后在高速缓冲中的数据更新之后，再把他们与设备中的数据同步。这里采用两遍同步
    // 操作是为了提高内核执行效率。第一遍缓冲区同步操作可以让内核中许多"脏快"变干净，
    // 使得i节点的同步操作能够高效执行。本次缓冲区同步操作则把那些由于i节点同步操作
    // 而又变脏的缓冲块与设备中数据同步。
    bh = start_buffer;
    for (i=0 ; i<NR_BUFFERS ; i++,bh++) {
        if (bh->b_dev != dev)
            continue;
        wait_on_buffer(bh);
        if (bh->b_dev == dev && bh->b_dirt)
            ll_rw_block(WRITE,bh);
    }
    return 0;
}

```

（2）同理，也有读 read_inode 的函数：

```Plain Text
//// 读取指定i节点信息。
// 从设备上读取含有指定i节点信息的i节点盘块，然后复制到指定的i节点结构中。为了确定i节点
// 所在的设备逻辑块号（或缓冲块），必须首先读取相应设备上的超级块，以获取用于计算逻辑
// 块号的每块i节点数信息INODES_PER_BLOCK.在计算出i节点所在的逻辑块号后，就把该逻辑块读入
// 一缓冲块中。然后把缓冲块中相应位置处的i节点内容复制到参数指定的位置处。
static void read_inode(struct m_inode * inode)
{
    struct super_block * sb;
    struct buffer_head * bh;
    int block;

    // 首先锁定该i节点，并取该节点所在设备的超级块。
    lock_inode(inode);
    if (!(sb=get_super(inode->i_dev)))
        panic("trying to read inode without dev");
    // 该i节点所在的设备逻辑块号＝（启动块+超级块）+i节点位图占用的块数+逻辑块位图占用的块数
    // +（i节点号-1）/每块含有的i节点数。虽然i节点号从0开始编号，但第i个0号i节点不用，并且
    // 磁盘上也不保存对应的0号i节点结构。因此存放i节点的盘块的第i块上保存的是i节点号是1--16
    // 的i节点结构而不是0--15的。因此在上面计算i节点号对应的i节点结构所在盘块时需要减1，即：
    // B=（i节点号-1)/每块含有i节点结构数。例如，节点号16的i节点结构应该在B=（16-1）/16 = 0的
    // 块上。这里我们从设备上读取该i节点所在的逻辑块，并复制指定i节点内容到inode指针所指位置处。
    block = 2 + sb->s_imap_blocks + sb->s_zmap_blocks +
        (inode->i_num-1)/INODES_PER_BLOCK;
    if (!(bh=bread(inode->i_dev,block)))
        panic("unable to read i-node block");
    *(struct d_inode *)inode =
        ((struct d_inode *)bh->b_data)
            [(inode->i_num-1)%INODES_PER_BLOCK];
    // 最后释放读入的缓冲块，并解锁该i节点。
    brelse(bh);
    unlock_inode(inode);
}

```

（3）inode 用完后，并不是直接调用 free_inode 去清零 inode 节点的数据，而是先把 i_count 计数减一，如果计数是 0 了，再清零 inode 节点的数据，如下：

```Plain Text
//// 放回(放置)一个i节点引用计数值递减1，并且若是管道i节点，则唤醒等待的进程。
// 若是块设备文件i节点则刷新设备。并且若i节点的链接计数为0，则释放该i节点占用
// 的所有磁盘逻辑块，并释放该i节点。
void iput(struct m_inode * inode)
{
    // 首先判断参数给出的i节点的有效性，并等待inode节点解锁，如果i节点的引用计数
    // 为0，表示该i节点已经是空闲的。内核再要求对其进行放回操作，说明内核中其他
    // 代码有问题。于是显示错误信息并停机。
    if (!inode)
        return;
    wait_on_inode(inode);
    if (!inode->i_count)
        panic("iput: trying to free free inode");
    // 如果是管道i节点，则唤醒等待该管道的进程，引用次数减1，如果还有引用则返回。
    // 否则释放管道占用的内存页面，并复位该节点的引用计数值、已修改标志和管道标志，
    // 并返回。对于管道节点，inode->i_size存放这内存也地址。
    if (inode->i_pipe) {
        wake_up(&inode->i_wait);
        if (--inode->i_count)
            return;
        free_page(inode->i_size);
        inode->i_count=0;
        inode->i_dirt=0;
        inode->i_pipe=0;
        return;
    }
    // 如果i节点对应的设备号 ＝ 0，则将此节点的引用计数递减1，返回。例如用于管道操作
    // 的i节点，其i节点的设备号为0.
    if (!inode->i_dev) {
        inode->i_count--;
        return;
    }
    // 如果是块设备文件的i节点，此时逻辑块字段0(i_zone[0])中是设备号，则刷新该设备。
    // 并等待i节点解锁。
    if (S_ISBLK(inode->i_mode)) {
        sync_dev(inode->i_zone[0]);
        wait_on_inode(inode);
    }
    // 如果i节点的引用计数大于1，则计数递减1后就直接返回(因为该i节点还有人在用，不能
    // 释放)，否则就说明i节点的引用计数值为1。如果i节点的链接数为0，则说明i节点对应文件
    // 被删除。于是释放该i节点的所有逻辑块，并释放该i节点。函数free_inode()用于实际释
    // 放i节点操作，即复位i节点对应的i节点位图bit位，清空i节点结构内容。
repeat:
    if (inode->i_count>1) {
        inode->i_count--;
        return;
    }
    if (!inode->i_nlinks) {
        truncate(inode);
        free_inode(inode);
        return;
    }
    // 如果该i节点已做过修改，则回写更新该i节点，并等待该i节点解锁。由于这里在写i节点
    // 时需要等待睡眠，此时其他进程有可能修改i节点，因此在进程被唤醒后需要再次重复进行
    // 上述判断过程(repeat)。
    if (inode->i_dirt) {
        write_inode(inode);    /* we can sleep - so do again */
        wait_on_inode(inode);
        goto repeat;
    }
    // 程序若能执行到此，则说明该i节点的引用计数值i_count是1、链接数不为零，并且内容
    // 没有被修改过。因此此时只要把i节点引用计数递减1，返回。此时该i节点的i_count=0,
    // 表示已释放。
    inode->i_count--;
    return;
}

```

参考：

1、[https://www.jianshu.com/p/9ef6542ced92](https://www.jianshu.com/p/9ef6542ced92) Linux 文件系统和 inode

2、[https://blog.csdn.net/YuZhiHui_No1/article/details/43951153](https://blog.csdn.net/YuZhiHui_No1/article/details/43951153) Linux 内核源码分析 -- 文件系统

原文作者：[首页 - 内核技术中文网 - 构建全国最权威的内核技术交流分享论坛](https://kernel.0voice.com/)

原文地址：[Linux 内核源码分析之文件系统 --inode - 圈点 - 内核技术中文网 - 构建全国最权威的内核技术交流分享论坛](https://kernel.0voice.com/forum.php?mod=viewthread&tid=2837&extra=)（版权归原文作者所有，侵权联系删除）

![](https://pic4.zhimg.com/v2-cf633ed1f6b849dd6b681e7b9b37fd33_r.jpg)

