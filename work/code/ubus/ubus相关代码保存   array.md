

```
```
  // printf("%s",blobmsg_format_json(msg, false)); 

 

    // int len = blobmsg_data_len(tb[ADD_TIMED_TASK_TEST_TABLE]); 

    blobmsg_parse(addTimedTask_test_policy, ARRAY_SIZE(addTimedTask_test_policy), tb2, blobmsg_data(tb[ADD_TIMED_TASK_TEST_TABLE]), blobmsg_len(tb[ADD_TIMED_TASK_TEST_TABLE])); 

    if (tb2[ADD_TIMED_TASK_TEST1_TASKID] != NULL) 

    { 

        char *name = blobmsg_name(tb2[ADD_TIMED_TASK_TEST1_TASKID]); 

        int item = blobmsg_get_u32(tb2[ADD_TIMED_TASK_TEST1_TASKID]); 

        printf("%s %d: name:%s item:%d\n", __FUNCTION__, __LINE__, name, item); 

 

    } 

 

 

 

    blobmsg_parse_array(addTimedTask_table2_policy, ARRAY_SIZE(addTimedTask_table2_policy), tb3, blobmsg_data(tb[ADD_TIMED_TASK_TEST_ARRAY]), blobmsg_len(tb[ADD_TIMED_TASK_TEST_ARRAY])); 

    blobmsg_parse(addTimedTask_test2_policy, __ADD_TIMED_TASK_TEST21_TASKID_MAX, tb4, blobmsg_data(tb3[ADD_TIMED_TASK_TEST_TABLE2]), blobmsg_len(tb3[ADD_TIMED_TASK_TEST_TABLE2])); 

    if (tb4[ADD_TIMED_TASK_TEST1_TASKID] != NULL) 

    { 

        char *name = blobmsg_name(tb4[ADD_TIMED_TASK_TEST21_TASKID]); 

        int item = blobmsg_get_u32(tb4[ADD_TIMED_TASK_TEST21_TASKID]); 

        printf("%s %d: name:%s item:%d\n", __FUNCTION__, __LINE__, name, item); 

    } 

 

    blobmsg_parse(addTimedTask_test2_policy, __ADD_TIMED_TASK_TEST21_TASKID_MAX, tb4, blobmsg_data(tb3[ADD_TIMED_TASK_TEST_TABLE3]), blobmsg_len(tb3[ADD_TIMED_TASK_TEST_TABLE3])); 

    if (tb4[ADD_TIMED_TASK_TEST1_TASKID] != NULL) 

    { 

        char *name = blobmsg_name(tb4[ADD_TIMED_TASK_TEST21_TASKID]); 

        int item = blobmsg_get_u32(tb4[ADD_TIMED_TASK_TEST21_TASKID]); 

        printf("%s %d: name:%s item:%d\n", __FUNCTION__, __LINE__, name, item); 

    } 
```

```