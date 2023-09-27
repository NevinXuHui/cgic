---
title: "正则表达式 – 匹配规则 _ 菜鸟教程"
alias: 
  - "正则表达式 – 匹配规则 _ 菜鸟教程"
created-date: 2023-04-07T13:24:42+0800
type: Simpread
banner: "https://www.runoob.com/wp-content/uploads/2014/03/E691DDE1-E5CB-4EA8-8D16-759BD0D2B09D.jpg "
banner_icon: 🔖
tag: 
idx: 7
---

# 正则表达式 – 匹配规则 _ 菜鸟教程

> [!example]- [🧷内部链接](<http://localhost:7026/reading/7>) [🌐外部链接](<https://www.runoob.com/regexp/regexp-example.html>)    
> URI:: [🧷](<http://localhost:7026/reading/7>) [🌐](<https://www.runoob.com/regexp/regexp-example.html>) 
> intURI:: [🧷内部链接](<http://localhost:7026/reading/7>)

%%
> [!example]+ **Comments**  
> ```dataview
> TABLE 
>     WITHOUT ID
>     link(Source, dateformat(date(Source), "yyyy-MM-dd")) as Date___, 
>     regexreplace(rows.Comments,"^@@\[\[.+?\]\]\s","") as "Comments"
> FROM "journals"
> WHERE  contains(cmnt, this.file.name)
> FLATTEN cmnt as Comments
> WHERE contains(Comments, this.file.name)
> GROUP BY file.link as Source
> SORT rows.file.day desc
> ```
>  **Description**:: 正则表达式 - 语法  正则表达式 (regular expression) 描述了一种字符串匹配的模式（pattern），可以用来检查一个串是否含有某种子串、将匹配的子串替换或者从某个串中取出符合某个条件的子串等。
%%

> [!md] Metadata  
> **标题**:: [正则表达式 – 匹配规则 _ 菜鸟教程](https://www.runoob.com/regexp/regexp-example.html)  
> **日期**:: [[2023-04-07]]  
