---
url: https://blog.csdn.net/qq_41139677/article/details/108928989
title: C_C++ 文件读写操作 (二进制文件 & 文本文件)_c++ 二进制文件读写结构体_Articoder 的博客 - CSDN 博客
date: 2023-06-30 14:29:26
tag: 
banner: "undefined"
banner_icon: 🔖
---
### 1. C++ 文件读写操作

包含的头文件是`fstream`，`ifstream`是文件输入流，`ofstream`是文件输出流。  
打开文件方式为`ofstream fout(file_name, ios::out|...|...)`或者`ofstream fout; fout.open(file_name, ios::out|...|...)`。

<table><thead><tr><th>打开模式</th><th>说明</th></tr></thead><tbody><tr><td>ios::in</td><td>为输入打开文件；文件不存在则打开失败，文件存在则打开。(ifstream 默认打开方式)</td></tr><tr><td>ios:out</td><td>为输出打开文件；文件不存在则创建打开，文件存在则清空。(ofstream 默认打开方式)</td></tr><tr><td>ios::nocreate</td><td>文件存在的时候不起作用，文件不存在的时候，强制文件不存在也不创建，此项针对输出文件打开。</td></tr><tr><td>ios::noreplace</td><td>不覆盖文件，若打开文件时如果文件存在则失败。文件不存在时，参数无效。文件存在时，此选项对 ios::in 无效，但是对于 ios::out 有效，当文件存在时打开失败。</td></tr><tr><td>ios::binary</td><td>文件默认是以<strong>文本</strong>形式打开的，此模式为二进制模式打开。</td></tr><tr><td>ios::trunc</td><td>若文件不存在，则无效，若文件存在首先清空里面的内容。</td></tr><tr><td>ios::app</td><td>所有的输出<strong>附加</strong>在文件末尾，读操作与写操作共享指针，具有读文件的特性，与 ios::out 组合使用的时候不清空文件内容。</td></tr><tr><td>ios::ate</td><td>文件指针的初始位置在文件尾。</td></tr></tbody></table>

#### 1.1 C++ 操作文本文件

##### 1.1.1 写文件

```
#include <iostream>
#include <fstream>
using namespace std;

int main()
{

    ofstream fout("out.txt",ios::out); //默认是ios::trunc
    /*读文件*/
    if(!fout.is_open())
    {
        exit(1);
    }
    char ch;
    while(!(EOF == (ch =getchar()))) //ctrl + z
    {
        fout << ch;
    }

    fout.close();

    return 0;

}

```

##### 1.1.2 读文件

```
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main()
{

    ifstream fin("in.txt",ios::in);//默认是ios::trunc
    /*读文件*/
    if(!fin.is_open())
    {
        exit(1);
    }

    char ch;

    fin >> noskipws; //不跳过空格和回车
    //默认跳过空格和回车

    //读取单个字符
    /*while(!fin.eof())
    {
        fin >> ch;
        cout << ch;
    }*/
    //读取单个字符
    /*while(!(EOF == (ch = fin.get())))
    {
        cout << ch;
    }*/

    //读取一行字符串 getline
    string str;
    while(getline(fin, str))
    {
        cout << str <<"*"<<endl;
    }
    fin.close();

    return 0;
}

```

#### 1.2 C++ 操作[二进制](https://so.csdn.net/so/search?q=%E4%BA%8C%E8%BF%9B%E5%88%B6&spm=1001.2101.3001.7020)文件

二进制文件比文本文件的好处是占用内存空间小，且便于检索。比如要存放结构体或者类时，文本文件存储的只是单纯的文本，不但浪费空间而且效率低下。因为在结构体或者类中每个对象的占用字节数不同，即使文本文件按照某个值排好序，只能从文件头向文件尾搜索，没有什么其他好办法。  
但是用二进制来存储，每个结构体或者类占用的字节数都是相同的，直接将该对象写入文件，称作 “记录”，每个对象对应一条记录，按照某个值排序之后可以用比如二分搜索等算法进行检索，这样就快了很多。  
读写二进制文件不能用类似于`cin cout`之类的流数据读取方法，这时需要调用`fstream`和`ofstream`的成员函数`write`向文件中写入数据，`fstream`和`ifstream`的成员函数`read`从文件中读取数据。

##### 1.2.1 写文件

`ostream & write(char* buffer, int count);`

```
#include <iostream>
#include <fstream>
#include <string>
using namespace std;
class MyClass{
public:
    int a;
    char b[10];
    char c;
};

int main()
{

    ofstream fout("out.dat",ios::out | ios::binary);
    if(!fout.is_open()) exit(1);

    MyClass mc;
    while(cin >> mc.a >> mc.b >> mc.c)
    {
        fout.write((char*)&mc, sizeof(mc));//mc的地址就是要写入内存文件缓冲区的地址
    }
    fout.close();

    return 0;
}


```

##### 1.2.2 读文件

`istream & read(char* buffer, int count);`  
`int gcount();`

```
#include <iostream>
#include <fstream>
#include <string>
using namespace std;
class MyClass{
public:
    int a;
    char b[10];
    char c;
};

int main()
{

    ifstream fin("out.dat",ios::in | ios::binary);
    if(!fin.is_open()) exit(1);

    MyClass mc;

    while(fin.read((char*)&mc, sizeof(mc)))
    {
        int cnt_bytes = fin.gcount();//查看刚才读取了多少字节
        cout << cnt_bytes<<endl;
        cout << mc.a << " "<<mc.b << " "<< mc.c<<endl;
    }

    fin.close();

    return 0;
}

```

**为什么在 MyClass 中 b 定义为 string 类型的变量，在读取 out.dat 文件的时候读不出来呢？**

### 2. C 文件读写操作

<table><thead><tr><th>打开模式</th><th>说明</th></tr></thead><tbody><tr><td>r</td><td>以只读方式打开文件，该文件必须存在。</td></tr><tr><td>r+</td><td>以可读写方式打开文件，该文件必须存在。</td></tr><tr><td>rb+</td><td>读写打开一个二进制文件，允许读写数据。</td></tr><tr><td>rw+</td><td>读写打开一个文本文件，允许读和写。</td></tr><tr><td>w</td><td>打开只写文件，若文件存在则文件长度清为 0，即该文件内容会消失。若文件不存在则建立该文件。</td></tr><tr><td>w+</td><td>打开可读写文件，若文件存在则文件长度清为零，即该文件内容会消失。若文件不存在则建立该文件。</td></tr><tr><td>a</td><td>以附加的方式打开只写文件。若文件不存在，则会建立该文件，如果文件存在，写入的数据会被加到文件尾，即文件原先的内容会被保留。（EOF 符保留）</td></tr><tr><td>a+</td><td>以附加方式打开可读写的文件。若文件不存在，则会建立该文件，如果文件存在，写入的数据会被加到文件尾后，即文件原先的内容会被保留。 （原来的 EOF 符不保留）</td></tr><tr><td>wb</td><td>只写打开或新建一个二进制文件；只允许写数据。</td></tr><tr><td>wb+</td><td>读写打开或建立一个二进制文件，允许读和写。</td></tr><tr><td>ab+</td><td>读写打开一个二进制文件，允许读或在文件末追加数据。</td></tr><tr><td>at+</td><td>打开一个叫 string 的文件，a 表示 append, 就是说写入处理的时候是接着原来文件已有内容写入，不是从头写入覆盖掉，t 表示打开文件的类型是文本文件，+ 号表示对文件既可以读也可以写。</td></tr></tbody></table>

#### 2.1 C 操作文本文件

##### 2.1.1 写文件

```
#include<stdio.h>
#include<stdlib.h>

int main()
{
    FILE *fp = fopen("out.txt", "w");//只写方式打开文件

    if(!fp)
        exit(1);//写文件失败

    int a;
    while(scanf("%d", &a))
    {
        fprintf(fp, "%d ",a);
    }

    fclose(fp);

    return 0;
}

```

##### 2.1.2 读文件

```
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int main()
{
	FILE* fp = fopen("in.txt", "r");//只读方式打开文件

	if (!fp)
		exit(1);//读文件失败

	int mode = 1;
	printf("mode为1, 按字符读入并输出; mode为2, 按行读入并输出;\n请输入mode: ");
	scanf("%d", &mode);
	if (mode == 1)
	{
		//按字符读入并直接输出
		char ch;//读取的字符
		/*while (EOF != (ch = fgetc(fp)))//是否为文件结束符
			printf("%c", ch);*/
        while(EOF != fscanf(fp, "%c", &ch))
            printf("%c", ch);
	}
	else if (mode == 2)//按行读入并输出
	{
		char line[100];
		memset(line, 0, 100);
		while (!feof(fp))
		{
		    fgets(line, 100, fp);
			printf("%s", line); //输出
		}
	}

	fclose(fp);

	return 0;
}

```

#### 2.2 C 操作二进制文件

##### 2.2.1 写文件

此处要注意的就是在写结构体数据的时候，因为`char c`变量是字符，因此要注意要在每次输入结构体之后**吃掉回车符**，否则会导致输入失败，就像我在代码中写的那样，用空格来吃掉前面的空白字符 (包括回车 空格等)。

```
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct MyStruct{
    int a;
    char b[10];
    char c;
}MyStruct;

int main()
{
	FILE* fp = fopen("test.dat", "wb+");//读写打开或建立一个二进制文件，允许读和写。

	if (!fp)
		exit(1);//写文件失败

	/*写int数据*/
	
    /*int a;
    while(scanf("%d", &a))
        fwrite(&a, sizeof(int), 1, fp);//写入int数据*/


	/*写结构体数据*/
    MyStruct ms;

    //先将结构体存储在结构体数组中
    //MyStruct ms[4];
    //MyStruct *p = ms;
    /*for(int i = 0; i < 4; i++,p++)
    {
        scanf(" %d", &p->a);
        scanf(" %s", p->b);
        scanf(" %c",&p->c);
    }*/
    //fwrite(ms, sizeof(MyStruct), 4, fp);
    //最后写到二进制文件

    //直接输入 以ctrl+D 结束输入
    while(scanf(" %d %s %c ", &ms.a, ms.b, &ms.c))
    //while(scanf(" %d", &ms.a) && scanf(" %s ", ms.b) && scanf(" %c ",&ms.c))
    {	//每次输入结束之后直接写入二进制文件
        fwrite(&ms, sizeof(MyStruct), 1, fp);
    }

	fclose(fp);

	return 0;
}


```

##### 2.2.2 读文件

需要获取文件大小，否则只能自己主观设定数据长度。并不想 C++ 读取二进制文件那样通过是否读到 EOF 来确定读取是否结束。

```
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct MyStruct{
    int a;
    char b[10];
    char c;
}MyStruct;

int main()
{
	fp = fopen("test.dat", "rb+");//读写打开一个二进制文件，允许读写数据。

	if (!fp)
		exit(1);//写文件失败

    fseek(fp, 0L, SEEK_END);//定位到文件尾
    int len = ftell(fp); //获取到文件大小 字节数
    rewind(fp);//文件指针复位 到文件头

    /*读int数据*/
    
    /*int buffer[100];
    memset(buffer, 0, sizeof(buffer)); //数组初始化为0
    fread(buffer, sizeof(int), 100, fp);//读取数据到buffer缓冲区中

    //读取的时候只能都读出来 或者一次读一个数据 但还是需要知道数据总长度
    for(int i = 0; i < len / sizeof(int); i++)
        printf("%d ", buffer[i]);
    printf("\n");

    int j = 0;
    while(j < len/sizeof(int))
    {
        fread(&buffer[j], sizeof(int), 1, fp);
        printf("%d \n",buffer[j]);
        j++;
    }*/

    /*读结构体数据*/
    
    int j = 0;
    MyStruct ms[100];
    while( j < len /sizeof(MyStruct))
    {
        fread(&ms[j], sizeof(MyStruct), 1, fp);
        printf("%d %s %c\n", ms[j].a, ms[j].b, ms[j].c);
        j++;
    }
	fclose(fp);

	return 0;
}

```