---
url: https://blog.csdn.net/u011238620/article/details/83445299
title: cJSON 排序（双链表排序的另一种方式）_shengwen91 的博客 - CSDN 博客
date: 2023-08-03 11:21:02
tag: 
banner: "https://images.unsplash.com/photo-1688889517070-2deb08808d6a?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxMDMyODU4fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
## 双[链表](https://so.csdn.net/so/search?q=%E9%93%BE%E8%A1%A8&spm=1001.2101.3001.7020)排序算法

本文提供一种双链表排序方法，主要思路是：双链表的 next，prev 指针不变，即链表的前后关系不变，只交换链表中的数据内容；如升序排序，从开始向后两两比较，若前面 A 比后面大 B，交换 AB 的内容，保证了是升序，但不能保证 B 比 A 前面的内容小，所以要向前遍历，发现前面的比后面的大，交换数据；这样向后一次遍历完成，排序完成；  
这样做的好处是：比网上交换指针的那种算法简单，思路清晰；  
cJSON 是 C 语言处理 json 的方法（cJSON.c 和 cJSON.h 两个文件），具体用法可百度；  
cJSON 组的数据其实就是一个双链表，所以用 cJSON 组 json 的数据作为双链表的数据（这样不用自己写双链表了）；  
cJSON 的节点数据：

```
/* cJSON Types: */
#define cJSON_False 0
#define cJSON_True 1
#define cJSON_NULL 2
#define cJSON_Number 3
#define cJSON_String 4
#define cJSON_Array 5
#define cJSON_Object 6

typedef struct cJSON {
	struct cJSON *next,*prev;	
	struct cJSON *child;		/* An array or object item will have a child pointer pointing to a chain of the items in the array/object. */
	int type;					/* The type of the item, as above. */
	char *valuestring;			/* The item's string, if type==cJSON_String */
	int valueint;				/* The item's number, if type==cJSON_Number */
	double valuedouble;			/* The item's number, if type==cJSON_Number */
	char *string;				/* The item's name string, if this item is the child of, or is in the list of subitems of an object. */
} cJSON;

```

代码：

```
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "cJSON.h"

/*只交换cJSON中的数据内容，不交换next，prev 指针，前后顺数不变*/
int swapCont(cJSON *contSrc,cJSON *contDest)
{
	if(contSrc == NULL || contDest == NULL)
	{
		return -1;
	}

	cJSON tmpData;
	memset(&tmpData,0,sizeof(tmpData));
	tmpData.child = contSrc->child;
	tmpData.type = contSrc->type;
	tmpData.valuestring = contSrc->valuestring;
	tmpData.valueint = contSrc->valueint;
	tmpData.valuedouble = contSrc->valuedouble;
	tmpData.string = contSrc->string;

	contSrc->child = contDest->child;
	contSrc->type = contDest->type;
	contSrc->valuestring = contDest->valuestring;
	contSrc->valueint = contDest->valueint;
	contSrc->valuedouble = contDest->valuedouble;
	contSrc->string = contDest->string;

	contDest->child = tmpData.child;
	contDest->type = tmpData.type;
	contDest->valuestring = tmpData.valuestring;
	contDest->valueint = tmpData.valueint;
	contDest->valuedouble = tmpData.valuedouble;
	contDest->string = tmpData.string;

	return 0;
}

int sortJson(cJSON *jsonData)
{
	if(jsonData == NULL)
	{
		return 0;
	}
	
	int i = 0;
      int countArrItem = 0;
	int ret = 0;

	cJSON *p = jsonData;  // p 向后遍历指针
	cJSON *srcData = p ;
      cJSON *destData = p;

	cJSON *head = p;
	cJSON *q = p;  // q 向前遍历指针


	if(p->type == cJSON_Array)  /*数组内容排序*/
	{
		countArrItem = cJSON_GetArraySize(p);
		for(i = 0;i<countArrItem;i++)
		{
			cJSON *arrData = cJSON_GetArrayItem(p,i);
			ret = sortJson(arrData->child);
			if(ret < 0)
			{
				return -1;
			}
		}
	}

	p = p->next;
	if(p == NULL)
	{
		return 0;
	}
	
	while(p != NULL)   //向后遍历
    {
		if(p->type == cJSON_Array)
		{
			countArrItem = cJSON_GetArraySize(p);
			for(i = 0;i<countArrItem;i++)
			{
				cJSON *arrData = cJSON_GetArrayItem(p,i);
				ret = sortJson(arrData->child);
				if(ret < 0)
				{
					return -2;
				}
			}
		}	

		destData = p->prev;
		srcData = p;
	    if(strcmp(srcData->string,destData->string)<0) //升序 排序
		{
			ret = swapCont(srcData,destData);
			if (ret <0)
			{
				return -3;
			}
			
			q = p;
			while(q != head)   //向前遍历
			{
				destData = q->prev;
			    srcData = q;
				if(strcmp(srcData->string,destData->string)<0)
				{
					ret = swapCont(srcData,destData);
					if (ret <0)
					{
						return -4;
					}
				}
				q = q->prev;
			}
		}
		p = p->next;
	}
	return 0;
}


int main(int argc,char* argv[])
{
	//测试数据
	cJSON *root = cJSON_CreateObject();
	
	cJSON *head ;
	cJSON_AddItemToObject(root,"head",head = cJSON_CreateObject());

	cJSON *arr;    
	cJSON_AddItemToObject(head,"mpp",arr = cJSON_CreateArray());
	cJSON *arrItem1,*arrItem2;
	cJSON_AddItemToArray(arr, arrItem1 = cJSON_CreateObject());
	cJSON_AddItemToObject(arrItem1,"prin",cJSON_CreateString("10.12"));
	cJSON_AddItemToObject(arrItem1,"amt",cJSON_CreateString("amt"));
	cJSON_AddItemToObject(arrItem1,"goodsNo",cJSON_CreateString("1"));
	cJSON_AddItemToArray(arr, arrItem2 = cJSON_CreateObject());
	cJSON_AddItemToObject(arrItem2,"prin",cJSON_CreateString("10.12"));
	cJSON_AddItemToObject(arrItem2,"goodsNo",cJSON_CreateString("2"));
	
	cJSON_AddItemToObject(head,"version",cJSON_CreateString("V1.0"));
	cJSON_AddItemToObject(head,"appid",cJSON_CreateString("123456"));
      cJSON_AddItemToObject(head,"exit",cJSON_CreateString("exit"));
      cJSON_AddItemToObject(head,"aba",cJSON_CreateString("890"));
	cJSON_AddItemToObject(head,"aa",cJSON_CreateString("rty"));
	char *prnStr = cJSON_Print(root);
	printf("排序前\n");
	printf("%s\n",prnStr);

	sortJson(head->child);
	
	printf("排序后\n");
	prnStr = cJSON_Print(root);
	printf("%s\n",prnStr);

	return 0;
}


```

效果如下：

```
排序前：
{
	"head":	{
		"mpp":	[{
				"prin":	"10.12",
				"amt":	"amt",
				"goodsNo":	"1"
			}, {
				"prin":	"10.12",
				"goodsNo":	"2"
			}],
		"version":	"V1.0",
		"appid":	"123456",
		"exit":	"exit",
		"aba":	"890",
		"aa":	"rty"
	}
}
排序后：
{
	"head":	{
		"aa":	"rty",
		"aba":	"890",
		"appid":	"123456",
		"exit":	"exit",
		"mpp":	[{
				"amt":	"amt",
				"goodsNo":	"1",
				"prin":	"10.12"
			}, {
				"goodsNo":	"2",
				"prin":	"10.12"
			}],
		"version":	"V1.0"
	}
}


```