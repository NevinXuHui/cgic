# [shell 连续执行命令](https://www.cnblogs.com/lege/p/4938397.html)

连续执行shell命令可以有几种写法，他们的意义也各不相同。

第一种写法： command1; command2;command3

表示顺序执行command1，command2，command3而不管命令是否成功执行了。

第二种写法： command1 && command2 && command3

也表示顺序执行，但是与第一种写法的不同之处在于必须前面的成功执行后才会执行下一个命令，前一个失败了，则不会继续执行。

第三种写法： command1 || command2 || command3

这种写法各个命令之间是逻辑或的关系，表示如果command1成功执行了，那么就不再执行后面的命令了；而如果command1执行失败了则会执行command2，依次类推。