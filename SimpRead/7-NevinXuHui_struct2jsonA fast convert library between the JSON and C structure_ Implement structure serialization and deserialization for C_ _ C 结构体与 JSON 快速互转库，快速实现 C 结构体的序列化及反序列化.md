---
url: https://github.com/NevinXuHui/struct2json
title: NevinXuHui_struct2json： A fast convert library between the JSON and C structure_ Implement structure serialization and deserialization for C_ _ C 结构体与 JSON 快速互转库，快速实现 C 结构体的序列化及反序列化
date: 2023-07-26 07:09:28
tag: 
banner: "https://images.unsplash.com/photo-1688582866340-6fa68a6a968a?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkwMzI2NDAxfA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
* * *

## [](#struct2json)struct2json

[struct2json](https://github.com/armink/struct2json) 是一个开源的 C 结构体与 JSON 快速互转库，它可以快速实现 **结构体对象** 与 **JSON 对象** 之间序列化及反序列化要求。快速、简洁的 API 设计，大大降低直接使用 JSON 解析库来实现此类功能的代码复杂度。

## [](#起源)起源

把面向对象设计应用到 C 语言中，是当下很流行的设计思想。由于 C 语言中没有类，所以一般使用结构体 `struct` 充当类，那么结构体变量就是对象。有了对象之后，很多时候需要考虑对象的序列化及反序列化问题。C 语言不像很多高级语言拥有反射等机制，使得对象序列化及反序列化被原生的支持。

对于 C 语言来说，序列化为 JSON 字符串是个不错的选择，所以就得使用 [cJSON](https://github.com/kbranigan/cJSON) 这类 JSON 解析库，但是使用后的代码冗余且逻辑性差，所以萌生对 cJSON 库进行二次封装，实现一个 struct 与 JSON 之间快速互转的库。 struct2json 就诞生于此。下面是 struct2json 主要使用场景：

*   **持久化** ：结构体对象序列化为 JSON 对象后，可直接保存至文件、Flash，实现对结构体对象的掉电存储；
*   **通信** ：高级语言对 JSON 支持的很友好，例如： Javascript、Groovy 就对 JSON 具有原生的支持，所以 JSON 也可作为 C 语言与其他语言软件之间的通信协议格式及对象传递格式；
*   **可视化** ：序列化为 JSON 后的对象，可以更加直观的展示到控制台或者 UI 上，可用于产品调试、产品二次开发等场景；

## [](#如何使用)如何使用

### [](#声明结构体)声明结构体

如下声明了两个结构体，结构体 `Hometown` 是结构体 `Student` 的子结构体

```
/* 籍贯 */
typedef struct {
    char name[16];
} Hometown;

/* 学生 */
typedef struct {
    uint8_t id;
    uint8_t score[8];
    char name[10];
    double weight;
    Hometown hometown;
} Student;

```

### [](#将结构体对象序列化为-json-对象)将结构体对象序列化为 JSON 对象

<table><thead><tr><th>使用前（<a href="https://github.com/armink/struct2json/blob/master/docs/zh/assets/not_use_struct2json.c">源文件</a>）</th><th>使用后（<a href="https://github.com/armink/struct2json/blob/master/docs/zh/assets/used_struct2json.c">源文件</a>）</th></tr></thead><tbody><tr><td><div class="sr-rd-content-center"><img class="" src="https://camo.githubusercontent.com/322eb7434df80f09879a410c8c7448dbb798519dee495caee1403c03b086bdae/68747470733a2f2f6769742e6f736368696e612e6e65742f41726d696e6b2f737472756374326a736f6e2f7261772f6d61737465722f646f63732f7a682f696d616765732f6e6f745f7573655f737472756374326a736f6e2e706e67" style="width: auto;"></div></td><td><div class="sr-rd-content-center"><img class="" src="https://camo.githubusercontent.com/4ad076eb0ec2e7b48dcb261e9c92671a48fdeca1d68d6c93fe54416c698fb812/68747470733a2f2f6769742e6f736368696e612e6e65742f41726d696e6b2f737472756374326a736f6e2f7261772f6d61737465722f646f63732f7a682f696d616765732f757365645f737472756374326a736f6e2e706e67"></div></td></tr></tbody></table>

### [](#将-json-对象反序列化为结构体对象)将 JSON 对象反序列化为结构体对象

<table><thead><tr><th>使用前（<a href="https://github.com/armink/struct2json/blob/master/docs/zh/assets/not_use_struct2json_for_json.c">源文件</a>）</th><th>使用后（<a href="https://github.com/armink/struct2json/blob/master/docs/zh/assets/used_struct2json_for_json.c">源文件</a>）</th></tr></thead><tbody><tr><td><div class="sr-rd-content-center"><img class="" src="https://camo.githubusercontent.com/f94128e24eb32bb064a1fd4eaf71f2737f7013c3cabe7ed10e2e8430d12f429e/68747470733a2f2f6769742e6f736368696e612e6e65742f41726d696e6b2f737472756374326a736f6e2f7261772f6d61737465722f646f63732f7a682f696d616765732f6e6f745f7573655f737472756374326a736f6e5f666f725f6a736f6e2e706e67" style="width: auto;"></div></td><td><div class="sr-rd-content-center"><img class="" src="https://camo.githubusercontent.com/54b93dd9232256145e5926a9cee0967f7aa43a696f9bf156d39ade38f42f83ea/68747470733a2f2f6769742e6f736368696e612e6e65742f41726d696e6b2f737472756374326a736f6e2f7261772f6d61737465722f646f63732f7a682f696d616765732f757365645f737472756374326a736f6e5f666f725f6a736f6e2e706e67"></div></td></tr></tbody></table>

### [](#v20版本新增功能yuxuebao)V2.0 版本新增功能【yuxuebao】

#### [](#1-更新cjson库至1712版本并扩充实现支持int64-long-long类型数据pscjson原来int64类型以double方式处理如果超过16位会有精度损失)1) 更新 cJSON 库至 1.7.12 版本，并扩充实现，支持 int64 (long long) 类型数据。PS：cJSON 原来 int64 类型以 double 方式处理，如果超过 16 位会有精度损失。

#### [](#2-扩展struct2json功能增加支持结构体内包含结构体成员支持包含数组成员)2) 扩展 struct2json 功能，增加支持结构体内包含结构体成员，支持包含数组成员。

#### [](#3-增加struct2json-结构体与json转换代码自动生成的python脚本支持从头文件中提取结构体定义并根据结构体定义自动生成结构体与json互转代码并提供相关示例)3) 增加 struct2json 结构体与 JSON 转换代码自动生成的 Python 脚本，支持从头文件中提取结构体定义，并根据结构体定义自动生成结构体与 JSON 互转代码，并提供相关示例。

### [](#v20-使用说明)V2.0 使用说明：

#### [](#1-提取结构体定义)1) 提取结构体定义:

```
	将头文件（eg:mc_usr_def.h）放在demo\inc目录下；
	执行generate_struct_defination.py，生成struct_defination.txt；


```

#### [](#2-生成结构体与json互转代码)2) 生成结构体与 JSON 互转代码:

```
	执行generate_s2j_code.py，根据结构体定义自动生成结构体与JSON互转代码：my_struct_2_json.c,my_struct_2_json.h；
	该脚本支持的参数类型有 基本类型 和 结构体类型，enum和指针按int处理，不支持union和位域；
	支持的数组类型:支持基本类型一维数组，结构体一维数组，字符二维数组（字符串数组）


```

#### [](#3-测试结构体与json转换)3) 测试结构体与 JSON 转换:

```
	cd demo
	编译测试代码，gcc ../cJSON/cJSON.c ../struct2json/src/*.c ./*.c -I ../cJSON/ -I ../struct2json/inc/ -lm -DDEBUGS2J  -g -o tests2j
	测试 ./tests2j 
	查看output输出和生成的JSON样例文件struct_defination.json；
	预期输出：*:strcmp:0     *:strcmp:0


```

*:json_cmp:1

欢迎大家 **fork and pull request**([Github](https://github.com/armink/struct2json)|[OSChina](http://git.oschina.net/armink/struct2json)|[Coding](https://coding.net/u/armink/p/struct2json/git)) 。如果觉得这个开源项目很赞，可以点击[项目主页](https://github.com/armink/struct2json) 右上角的 **Star**，同时把它推荐给更多有需要的朋友。

## [](#文档)文档

具体内容参考 [`\docs\zh\`](https://github.com/armink/struct2json/tree/master/docs/zh)下的文件。务必保证在 **阅读文档** 后再使用。

## [](#许可)许可

*   Armink (original author)
*   Yu Xuebao (current maintainer)
*   and the other contributors (CONTRIBUTORS.md)

MIT Copyright (c) [armink.ztl@gmail.com](mailto:armink.ztl@gmail.com)