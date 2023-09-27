---
url: https://blog.csdn.net/helloxiaozhe/article/details/118755685
title: shell 数组及其遍历的 3 种方法_shell 遍历数组_Data_IT_Farmer 的博客 - CSDN 博客
date: 2023-06-29 13:10:03
tag: 
banner: "undefined"
banner_icon: 🔖
---
## 1、shell 数组

### 1.1、数组概述

数组中可以存放多个值。Bash Shell 只支持[一维数组](https://so.csdn.net/so/search?q=%E4%B8%80%E7%BB%B4%E6%95%B0%E7%BB%84&spm=1001.2101.3001.7020)（不支持多维数组），初始化时不需要定义数组大小（与 PHP 类似）。

与大部分编程语言类似，[数组元素](https://so.csdn.net/so/search?q=%E6%95%B0%E7%BB%84%E5%85%83%E7%B4%A0&spm=1001.2101.3001.7020)的下标由 0 开始。

Shell 数组用括号来表示，元素用” 空格” 符号分割开，语法格式如下：

array_name=(value1 value2 … valuen)

例如：my_array=(A B “C” D)

我们也可以使用下标来定义数组:

array_name[0]=value0  
array_name[1]=value1  
array_name[2]=value2

### 1.2、数组中的主要方法

*   **读取数组 ：读取数组元素值的一般格式是：${array_name[index]}**
*   **获取数组中的所有元素：使用 @ 或 * 可以获取数组中的所有元素，**
*   **获取数组的长度：获取数组长度的方法与获取字符串长度的方法相同**

## 2、shell 数组遍历的 3 种方法

*   **标准的 for 循环**
*   **for … in 循环方法**
*   **While 循环法**

## 3、闲话不说，直接上代码

```
[work@master]$ cat test.sh 
#!/bin/bash
cwd=$(cd $(dirname $0); pwd)
function main()
{
    echo "shell 数组介绍"
    echo "1.读取数组元素值的一般格式，例如:"
    my_array=(A B "C" D)
    echo "第一个元素为: ${my_array[0]}"
    echo "第二个元素为: ${my_array[1]}"
    echo "第三个元素为: ${my_array[2]}"
    echo "第四个元素为: ${my_array[3]}"
    
    echo "2.获取数组中的所有元素: 使用@ 或 * 可以获取数组中的所有元素,例如:"
    my_array=(A B "C" D)
    echo "数组的元素为: ${my_array[*]}"
    echo "数组的元素为: ${my_array[@]}"
  
    echo "3.获取数组的长度: 获取数组长度的方法与获取字符串长度的方法相同,例如:"
    my_array=(A B "C" D)
    echo "数组元素个数为: ${#my_array[*]}"
    echo "数组元素个数为: ${#my_array[@]}"
 
    echo "***************************************"
    echo "shell 数组遍历的3种方法"
    echo "创建一个数组"
    array=( A B C D 1 2 3 4)
    
    echo "1.标准的for循环"
    for(( i=0;i<${#array[@]};i++)) do
    #${#array[@]}获取数组长度用于循环
    echo ${array[i]};
    done;
 
    echo "2.for … in"
    echo "2.1 遍历(不带数组下标)"
    for element in ${array[@]}
    #也可以写成for element in ${array[*]}
    do
    echo $element
    done
 
    echo "2.2 遍历(带数组下标)"
    for i in "${!array[@]}";   
    do 
    printf "%s\t%s\n" "$i" "${array[$i]}"  
    done
   
   echo "3.While循环法"
   i=0  
   while [ $i -lt ${#array[@]} ]  
   #当变量（下标）小于数组长度时进入循环体
   do  
    echo ${array[$i]}  
    #按下标打印数组元素
    let i++  
   done
    
   echo "4.我的示例"
 
   pos=0
   array=( 20200630 20210731 20200831 )
   for element in ${array[@]}
   do
      end_date=$element
      start_date="${element: 0: 6}01"
      let pos++
      echo "序号: echo ${pos}, start_date: ${start_date}, end_date: ${end_date}"
   done
  
 
}
main $@
```

## 4、执行和输出结果

[work@master]$ bash ./test.sh   
shell 数组介绍  
1. 读取数组元素值的一般格式，例如:  
第一个元素为: A  
第二个元素为: B  
第三个元素为: C  
第四个元素为: D  
2. 获取数组中的所有元素: 使用 @ 或 * 可以获取数组中的所有元素, 例如:  
数组的元素为: A B C D  
数组的元素为: A B C D  
3. 获取数组的长度: 获取数组长度的方法与获取字符串长度的方法相同, 例如:  
数组元素个数为: 4  
数组元素个数为: 4  
***************************************  
shell 数组遍历的 3 种方法  
创建一个数组  
1. 标准的 for 循环  
A  
B  
C  
D  
1  
2  
3  
4  
2.for … in  
2.1 遍历 (不带数组下标)  
A  
B  
C  
D  
1  
2  
3  
4  
2.2 遍历 (带数组下标)  
0    A  
1    B  
2    C  
3    D  
4    1  
5    2  
6    3  
7    4  
3.While 循环法  
A  
B  
C  
D  
1  
2  
3  
4  
4. 我的示例  
序号: echo 1, start_date: 20200601, end_date: 20200630  
序号: echo 2, start_date: 20210701, end_date: 20210731  
序号: echo 3, start_date: 20200801, end_date: 20200831 

参考:  
https://blog.csdn.net/lockey23/article/details/74625636  
https://blog.csdn.net/jingwen3699/article/details/82114603