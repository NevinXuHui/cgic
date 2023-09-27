---
url: https://blog.csdn.net/vegeta852/article/details/111923290
title: ​json-c 简介及基本使用_vegeta852 的博客 - CSDN 博客
date: 2023-06-29 12:16:23
tag: 
banner: "undefined"
banner_icon: 🔖
---
## ​json-c 简介及基本使用

JSON(JavaScript Object Notation) 是一种**轻量级的数据交换格式**。它基于 [ECMAScript](https://so.csdn.net/so/search?q=ECMAScript&spm=1001.2101.3001.7020) 的一个子集。 JSON 选用完全独立于言语的文本格局，但是也使用了类似于 C 言语宗族的习气（包含 C、C++、C#、Java、JavaScript、Perl、Python 等）。这些特性使 json 调试成为抱负的数据交换言语。 易于人阅览和编写，同时也易于机器解析和生成 (一般用于提高网络传输速率)。

**JSON 的格式**  
JSON 数据的书写格式是**键（名称）/ 值对**。  
JSON 键值对是用来保存 JS 对象的一种方式，和 JS 对象的写法也大同小异，键 / 值对包括字段名称（在双引号中），后面写一个冒号，然后是值。  
JSON 值可以是：字符串（在双引号中）、数组（在中括号中）、数字（整数或浮点数）、逻辑值（true 或 false）、对象（在大括号中）、 null。

**JSON 结构**  
JSON 结构有两种结构，就是**对象和数组**。通过这两种结构可以表示各种复杂的结构。  
`{"province": "Shanxi"}` 可以理解为是一个包含 province 为 Shanxi 的对象，  
`["Shanxi","Shandong"]`这是一个包含两个元素的数组  
而 `[{"province": "Shanxi"},{"province": "Shandong"}]` 就表示包含两个对象的数组。

当然了, 你也可以使用 `{"province":["Shanxi","Shandong"]}` 来简化上面的 JSON, 这是一个拥有一个 name 数组的对象。

下面是一小段 JSON 代码：

{“skillz”: {“web”:[ {“name”: “html”， “years”: “5” }， {“name”: “css”， “years”: “3” }],”database”:[ {“name”: “sql”， “years”: “7” }]}}

**花括弧，方括弧，冒号和逗号**  
花括弧表示一个 “容器”  
方括号装载数组  
名称和值用冒号隔开

数组元素通过逗号隔开

json-c 数据类型

```
typedef enum json_type {
  /* If you change this, be sure to update json_type_to_name() too */
  json_type_null,
  json_type_boolean,
  json_type_double,
  json_type_int,
  json_type_object,
  json_type_array,
  json_type_string,
} json_type;

```

基础 API

```
extern struct json_object* json_object_new_object(void);

extern struct json_object* json_object_new_boolean(json_bool b);
extern struct json_object* json_object_new_double(double d);
extern struct json_object* json_object_new_int(int32_t i);
extern struct json_object* json_object_new_int64(int64_t i);
extern struct json_object* json_object_new_array(void);
extern struct json_object* json_object_new_string(const char *s);

json_object_object_add(struct json_object* obj, const char *key,
				   struct json_object *val);

```

get

```
extern json_bool json_object_get_boolean(struct json_object *obj);
extern double json_object_get_double(struct json_object *obj);
extern int32_t json_object_get_int(struct json_object *obj);
extern int64_t json_object_get_int64(struct json_object *obj);
extern const char* json_object_get_string(struct json_object *obj);
extern int json_object_array_length(struct json_object *obj);
extern struct array_list* json_object_get_array(struct json_object *obj);

```

json-c 创建 json 对象

```
/* object type methods */

/** Create a new empty object with a reference count of 1.  The caller of
 * this object initially has sole ownership.  Remember, when using
 * json_object_object_add or json_object_array_put_idx, ownership will
 * transfer to the object/array.  Call json_object_get if you want to maintain
 * shared ownership or also add this object as a child of multiple objects or
 * arrays.  Any ownerships you acquired but did not transfer must be released
 * through json_object_put.
 *
 * @returns a json_object of type json_type_object
 */
extern struct json_object* json_object_new_object(void);

    struct json_object *myJson = NULL;
    struct json_object *boolType = NULL;
    struct json_object *intType = NULL;
    struct json_object *string = NULL;
    struct json_object *array = NULL;
    struct json_object *oneInArray = NULL;
    const char* content = NULL;

    myJson = json_object_new_object();
    /*bool*/
    boolType = json_object_new_boolean(false);
    json_object_object_add(myJson, "BoolType", boolType);
	/*int*/
    intType = json_object_new_int(1);
    json_object_object_add(myJson, "IntType", intType);
	/*string*/
    string = json_object_new_string("string");
    json_object_object_add(myJson, "String", string);
    /*array*/
    array = json_object_new_array();
    json_object_object_add(myJson, "Array", array);
    size_t loop = 0;
    for (loop = 0; loop < 2; loop ++)
    {
        /*create one object and add it to array*/
        oneInArray = json_object_new_object();
        json_object_array_add(array, oneInArray);
        /*int*/
        intType = json_object_new_int(2);
        json_object_object_add(oneInArray, "IntTypeInArray", intType);
        /*string*/
        string = json_object_new_string("stringInArray");
        json_object_object_add(oneInArray, "StringInArray", string);
    }

	content = json_object_to_json_string(myJson);
	printf("content %s\n", content);

	/*only need to free main object*/
	json_object_put(myJson);

```

```
注意事项：
1. json_object_new_object生成的对象需要释放
/** Create a new empty object with a reference count of 1.  The caller of
 * this object initially has sole ownership.  Remember, when using
 * json_object_object_add or json_object_array_put_idx, ownership will
 * transfer to the object/array.  Call json_object_get if you want to maintain
 * shared ownership or also add this object as a child of multiple objects or
 * arrays.  Any ownerships you acquired but did not transfer must be released
 * through json_object_put.
 *
 * @returns a json_object of type json_type_object
 */
json_object_new_object生成的对象必须调用json_object_put释放（主object）。

2. json_tokener_parse生成的对象需要释放
json_tokener_parse生成的对象，必须使用json_object_put释放.

3. json_object_object_get出来的对象要不要释放
通过json_object_object_get获取的对象不能单独释放，因为它仍然归父节点所有。

4. 通过json_object_object_add添加到其他节点的，能不能释放
通过json_object_object_add添加到其他节点的不能再单独释放，因为他已经成为别人的子节点，他的生命周期由父节点维护了。
    
5. json_object_to_json_string获取到的字串要不要释放
这个free也是非法的，因为json_object_to_json_string只是把json对象内部的指针暴露给你了，借你用下而已，千万别释放。

```

json-c 解析 json 对象

```
int
JsonSafeGetI32(
    __in struct json_object *JObj,
    __in const char *Key,
    __out int32_t *ValInt
    )
{
    struct json_object *valueObjPtr = NULL;
    int32_t val = 0;
    int ret = 0;

    if (json_object_object_get_ex(JObj, Key, &valueObjPtr))
    {
        val = json_object_get_int(valueObjPtr);
        switch (val)
        {
            case 0:
                if (EINVAL == errno)  ret = -EINVAL;
                break;
            case INT32_MAX:
            case INT32_MIN:
                ret = -EOVERFLOW;
                break;
            default:
                break;
        }
    }
    else
    {
        ret = -EINVAL;
    }

    *ValInt = val;

    return ret;
}

int
JsonSafeGetBool(
    __in struct json_object *JObj,
    __in const char *Key,
    __out BOOL *ValBool
    )
{
    int ret = 0;
    struct json_object *valueObjPtr = NULL;

    if (json_object_object_get_ex(JObj, Key, &valueObjPtr))
    {
        *ValBool = (BOOL)json_object_get_boolean(valueObjPtr);
    }
    else
    {
        ret = -EINVAL;
    }

    return ret;
}

int
JsonSafeGetStr(
    __in struct json_object *JObj,
    __in const char *Key,
    __out_bcount(OutStrSize) char *OutStr,
    __in size_t OutStrSize
    )
{
    int ret = 0;
    struct json_object *jsonStrPtr = NULL;
    const char *srcStr;
    size_t len;

    json_object_object_get_ex(JObj, Key, &jsonStrPtr);

    /* this function allow input NULL, so don't check JsonStrPtr */
    srcStr = json_object_get_string(jsonStrPtr);
    if (NULL == srcStr)
    {
        ret = -EINVAL;
        goto CommonReturn;
    }

    /*copy your str*/

CommonReturn:
    return ret;
}

```

parser

```
	struct json_object *myJson = NULL;
    struct json_object *boolType = NULL;
    struct json_object *intType = NULL;
    struct json_object *string = NULL;
    struct json_object *array = NULL;
    struct json_object *oneInArray = NULL;
	int32_t tmpVal = 0; 
	bool boolType = false;
	size_t arrayNum = 0;
	size_t loop = 0;

	myJson = json_tokener_parse(JsonContentStr);
    //myJson = json_object_from_file("./JsonContent.json");
	/*bool*/
	JsonSafeGetBool(myJson, "BoolType", &boolType);
	/*int*/
    JsonSafeGetI32(myJson, "IntType", &tmpVal);
	/*str*/
	JsonSafeGetStr(myJson, "String", str);
	/*Array*/
	
	json_object_object_get_ex(myJson, "Array", &array);
    arrayNum = json_object_array_length(array);
	for(loop = 0; loop < arrayNum; loop++)
    {
        oneInArray = json_object_array_get_idx(array, loop);
        /*int*/
        JsonSafeGetI32(oneInArray, "IntTypeInArray", &tmpVal);
        /*string*/
        JsonSafeGetStr(oneInArray, "StringInArray", str);
    }
    
    json_object_put(myJson);

```