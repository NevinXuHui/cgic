```Plain Text
申请了内存没有释放 造成内存申请失败，下面记录下使用的注意问题

```

***（1）使用 root = cJSON_Parse(text);***

将[字符串](https://so.csdn.net/so/search?q=%E5%AD%97%E7%AC%A6%E4%B8%B2&spm=1001.2101.3001.7020)转成 json 格式，函数中申请了一块内存给`root` 所以在最后要释放`root`，使用 `cJSON_Delete(root)`; 释放`cJSON_Parse()`分配出来的[内存](https://so.csdn.net/so/search?q=%E5%86%85%E5%AD%98&spm=1001.2101.3001.7020)空间

```Plain Text
prase = cJSON_Parse(json);
cJSON_Delete(prase);

```

***（2）使用 out = cJSON_Print(root);（含有 cJSON_PrintUnformatted 函数）***
函数将`json`数据转成字符串，这个函数内申请了一段内存给`out`，所以使用完`out`后也要释放， 由于`out`不是`json`指针的数据格式，使用`cJSON_free(out)`释放即可

```Plain Text
str = cJSON_Print(json);
cJSON_free(str);

```

**（3）使用 cJSON *new_json_str = cJSON_Create(str)***
将一个字符串转成一个`json`对象，函数里面也涉及了内存分配，用完以后也要释放`cJSON_Delete(new_json_str)`; 若`cJSON *new_json = cJSON_Create**(str)`创建后，通过`cJSON_AddItemToObject( json, "test", new_json )`;（或者`cJSON_AddItemToArray`），加入到数组或者 object 中，不需要单独释放`new_json` ，删除`json`时被添加的`item`（此处为申请的`new_json`）同时也会被删除。

```Plain Text
json = cJSON_CreateString(str);
cJSON_Delete(json);

```

