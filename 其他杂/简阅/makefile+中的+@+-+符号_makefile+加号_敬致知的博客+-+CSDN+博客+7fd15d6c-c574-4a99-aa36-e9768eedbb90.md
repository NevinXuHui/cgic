### 【make 中命令行前面加上减号】

-means ignore the exit [status](https://so.csdn.net/so/search?q=status&spm=1001.2101.3001.7020) of the command that is executed (normally, a non-zero exit status would stop that part of htat build) 通常情况下，Makefile 在执行到某一条命令时，如果返回值不正常，就会退出当前 make 进程，通常结合 rm mkdir 命令使用，（空文件或者文件不存在都会返回错误）
就是，忽略当前此行命令执行时候所遇到的错误。
而如果不忽略，make 在执行命令的时候，如果遇到 error，会退出执行的，加上减号的目的，是即便此行命令执行中出错，比如删除一个不存在的文件等，那么也不要管，继续执行 make。

### 【make 中命令行前面加上 @】

@suppress the normal ‘echo’ of the command that is executed. 通常 [makefile](https://so.csdn.net/so/search?q=makefile&spm=1001.2101.3001.7020) 执行到每一行时都会打印出该行信息，加上 @符号后就可以不现实该条命令。 通常结合 @echo 来使用表示当前 Makefile 执行到哪里。
就是，在 make 执行时候，输出的信息中，不要显示此行命令。
而正常情况下，make 执行过程中，都是会显示其所执行的任何的命令的。如果你不想要显示某行的命令，那么就在其前面加上 @符号即可。

### 【make 中命令行前面加上加号 +】

- means execute this comand under make -n (when commands are not normally executed)
对于命令行前面加上加号 + 的含义，表明在使用 make -n 命令的时候，其他行都只是显示命令而不执行，只有 + 行的才会被执行。

转载自：[在路上 » 【整理】make/makefile 中的加号 +，减号 - 和 at 号 @的含义](https://www.crifan.com/order_make__makefile_in_the_plus__minus_-_and_at_the_meaning_of_numbers/#:~:text=%E3%80%90make%E4%B8%AD%E5%91%BD%E4%BB%A4%E8%A1%8C%E5%89%8D%E9%9D%A2,%E4%B8%8D%E8%A6%81%E7%AE%A1%EF%BC%8C%E7%BB%A7%E7%BB%AD%E6%89%A7%E8%A1%8Cmake%E3%80%82)

