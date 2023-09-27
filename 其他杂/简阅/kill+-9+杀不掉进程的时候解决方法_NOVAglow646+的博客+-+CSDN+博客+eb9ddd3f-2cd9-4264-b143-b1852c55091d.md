[参考链接
](https://blog.csdn.net/qq_37508554/article/details/121783698?ops_request_misc=&request_id=&biz_id=102&utm_term=linux%20kill%E4%B8%8D%E6%8E%89&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-121783698.142%5Ev73%5Econtrol_1,201%5Ev4%5Eadd_ask,239%5Ev2%5Einsert_chatgpt&spm=1018.2226.3001.4187)kill -9 杀不掉进程，有可能是因为该进程是某个进程的子进程，这样的话杀不掉。比如，想杀死 226473，直接 kill -9 226473 不行，需要先查看其父进程：

```Plain Text
	cd /proc/226473
	cat status

```

之后看到条目 PPID=226472，则 kill -9 226472 即可。

（PS：今天在服务器上出现这个问题的时候，发现 kill 不掉的进程的父进程 PID 都是子进程 PID 减去 1，即 226473 的父进程是 226472）

