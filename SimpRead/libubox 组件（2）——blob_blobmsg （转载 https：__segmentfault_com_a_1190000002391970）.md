---
url: https://www.cnblogs.com/xuyh/p/5615096.html
title: libubox 组件（2）——blob_blobmsg （转载 https：__segmentfault_com_a_1190000002391970）
date: 2023-08-13 19:09:34
tag: 
banner: "https://images.unsplash.com/photo-1689955060038-436bee644833?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxOTI0OTY4fA&ixlib=rb-4.0.3&q=85&fit=crop&w=970&max-h=540"
banner_icon: 🔖
---
一：blob 相关接口

1. 数据结构

```
   1:  struct blob_attr {

```

```
   2:      uint32_t id_len;    /** 高1位为extend标志，高7位存储id，

```

```
   3:                           *  低24位存储data的内存大小+结构大小(blob_attr) */

```

```
   4:      char data[];

```

```
   5:  } __packed;

```

```
   6:   实际使用中每个blob_attr的长度包含：结构长度(4)+数据长度+对齐特性= id_len+pad_len

```

```
   7:  struct blob_attr_info {

```

```
   8:      unsigned int type;

```

```
   9:      unsigned int minlen;

```

```
  10:      unsigned int maxlen;

```

```
  11:      bool (*validate)(const struct blob_attr_info *, struct blob_attr *);

```

```
  12:  };

```

```
  13:   

```

```
  14:  struct blob_buf {

```

```
  15:      struct blob_attr *head;

```

```
  16:      bool (*grow)(struct blob_buf *buf, int minlen);

```

```
  17:      int buflen;

```

```
  18:      void *buf;

```

```
  19:  };

```

.csharpcode, .csharpcode pre {font-size: small; color: rgba(0, 0, 0, 1); font-family: consolas, "Courier New", courier, monospace; background-color: rgba(255, 255, 255, 1) } .csharpcode pre { margin: 0 } .csharpcode .rem { color: rgba(0, 128, 0, 1) } .csharpcode .kwrd { color: rgba(0, 0, 255, 1) } .csharpcode .str { color: rgba(0, 96, 128, 1) } .csharpcode .op { color: rgba(0, 0, 192, 1) } .csharpcode .preproc { color: rgba(204, 102, 51, 1) } .csharpcode .asp { background-color: rgba(255, 255, 0, 1) } .csharpcode .html { color: rgba(128, 0, 0, 1) } .csharpcode .attr { color: rgba(255, 0, 0, 1) } .csharpcode .alt { background-color: rgba(244, 244, 244, 1); width: 100%; margin: 0 } .csharpcode .lnum { color: rgba(96, 96, 96, 1) }

2. 存储结构

![](https://segmentfault.com/img/bVkcqc)

3. 获取 BLOB 属性信息

```
   1:  /**

```

```
   2:   * 返回指向BLOB属性数据区指针

```

```
   3:   */

```

```
   4:  static inline void * blob_data(const struct blob_attr *attr)

```

```
   5:   

```

```
   6:  /**

```

```
   7:   * 返回BLOB属性ID

```

```
   8:   */

```

```
   9:  static inline unsigned int blob_id(const struct blob_attr *attr)

```

```
  10:   

```

```
  11:  /**

```

```
  12:   * 判断BLOB属性扩展标志是否为真

```

```
  13:   */

```

```
  14:  static inline bool blob_is_extended(const struct blob_attr *attr)

```

```
  15:   

```

```
  16:  /**

```

```
  17:   * 返回BLOB属性有效存储空间大小

```

```
  18:   */

```

```
  19:  static inline unsigned int blob_len(const struct blob_attr *attr)

```

```
  20:   

```

```
  21:  /*

```

```
  22:   * 返回BLOB属性完全存储空间大小(包括头部)

```

```
  23:   */

```

```
  24:  static inline unsigned int blob_raw_len(const struct blob_attr *attr)

```

```
  25:   

```

```
  26:  /*

```

```
  27:   * 返回BLOB属性填补后存储空间大小(包括头部)

```

```
  28:   */

```

```
  29:  static inline unsigned int blob_pad_len(const struct blob_attr *attr)

```

```
4.获取BLOB数据信息

```

```
   1:  static inline uint8_t blob_get_u8(const struct blob_attr *attr)

```

```
   2:   

```

```
   3:  static inline uint16_t blob_get_u16(const struct blob_attr *attr)

```

```
   4:   

```

```
   5:  static inline uint32_t blob_get_u32(const struct blob_attr *attr)

```

```
   6:   

```

```
   7:  static inline uint64_t blob_get_u64(const struct blob_attr *attr)

```

```
   8:   

```

```
   9:  static inline int8_t blob_get_int8(const struct blob_attr *attr)

```

```
  10:   

```

```
  11:  static inline int16_t blob_get_int16(const struct blob_attr *attr)

```

```
  12:   

```

```
  13:  static inline int32_t blob_get_int32(const struct blob_attr *attr)

```

```
  14:   

```

```
  15:  static inline int64_t blob_get_int64(const struct blob_attr *attr)

```

```
  16:   

```

```
  17:  static inline const char * blob_get_string(const struct blob_attr *attr)

```

.csharpcode, .csharpcode pre {font-size: small; color: rgba(0, 0, 0, 1); font-family: consolas, "Courier New", courier, monospace; background-color: rgba(255, 255, 255, 1) } .csharpcode pre { margin: 0 } .csharpcode .rem { color: rgba(0, 128, 0, 1) } .csharpcode .kwrd { color: rgba(0, 0, 255, 1) } .csharpcode .str { color: rgba(0, 96, 128, 1) } .csharpcode .op { color: rgba(0, 0, 192, 1) } .csharpcode .preproc { color: rgba(204, 102, 51, 1) } .csharpcode .asp { background-color: rgba(255, 255, 0, 1) } .csharpcode .html { color: rgba(128, 0, 0, 1) } .csharpcode .attr { color: rgba(255, 0, 0, 1) } .csharpcode .alt { background-color: rgba(244, 244, 244, 1); width: 100%; margin: 0 } .csharpcode .lnum { color: rgba(96, 96, 96, 1) }

5. 设置 BLOB 数据信息

```
   1:  static inline struct blob_attr *

```

```
   2:  blob_put_string(struct blob_buf *buf, int id, const char *str)

```

```
   3:   

```

```
   4:  static inline struct blob_attr *

```

```
   5:  blob_put_u8(struct blob_buf *buf, int id, uint8_t val)

```

```
   6:   

```

```
   7:  static inline struct blob_attr *

```

```
   8:  blob_put_u16(struct blob_buf *buf, int id, uint16_t val)

```

```
   9:   

```

```
  10:  static inline struct blob_attr *

```

```
  11:  blob_put_u32(struct blob_buf *buf, int id, uint32_t val)

```

```
  12:   

```

```
  13:  static inline struct blob_attr *

```

```
  14:  blob_put_u64(struct blob_buf *buf, int id, uint64_t val)

```

```
  15:   

```

```
  16:  #define blob_put_int8   blob_put_u8

```

```
  17:  #define blob_put_int16  blob_put_u16

```

```
  18:  #define blob_put_int32  blob_put_u32

```

```
  19:  #define blob_put_int64  blob_put_u64

```

```
  20:   

```

```
  21:  struct blob_attr *

```

```
  22:  blob_put(struct blob_buf *buf, int id, const void *ptr, unsigned int len)

```

```
  23:   

```

```
  24:  /**

```

```
  25:   * ptr - 指向struct blob_attr

```

```
  26:   */

```

```
  27:  struct blob_attr *

```

```
  28:  blob_put_raw(struct blob_buf *buf, const void *ptr, unsigned int len)

```

.csharpcode, .csharpcode pre {font-size: small; color: rgba(0, 0, 0, 1); font-family: consolas, "Courier New", courier, monospace; background-color: rgba(255, 255, 255, 1) } .csharpcode pre { margin: 0 } .csharpcode .rem { color: rgba(0, 128, 0, 1) } .csharpcode .kwrd { color: rgba(0, 0, 255, 1) } .csharpcode .str { color: rgba(0, 96, 128, 1) } .csharpcode .op { color: rgba(0, 0, 192, 1) } .csharpcode .preproc { color: rgba(204, 102, 51, 1) } .csharpcode .asp { background-color: rgba(255, 255, 0, 1) } .csharpcode .html { color: rgba(128, 0, 0, 1) } .csharpcode .attr { color: rgba(255, 0, 0, 1) } .csharpcode .alt { background-color: rgba(244, 244, 244, 1); width: 100%; margin: 0 } .csharpcode .lnum { color: rgba(96, 96, 96, 1) }

6. 遍历

```
#define __blob_for_each_attr(pos, attr, rem)
#define blob_for_each_attr(pos, attr, rem)

```

###### 7. 复制

```
struct blob_attr * blob_memdup(struct blob_attr *attr)

```

8. 数据类型判断

```
   1:  enum {

```

```
   2:      BLOB_ATTR_UNSPEC,

```

```
   3:      BLOB_ATTR_NESTED,  /** 嵌套 */

```

```
   4:      BLOB_ATTR_BINARY,

```

```
   5:      BLOB_ATTR_STRING,

```

```
   6:      BLOB_ATTR_INT8,

```

```
   7:      BLOB_ATTR_INT16,

```

```
   8:      BLOB_ATTR_INT32,

```

```
   9:      BLOB_ATTR_INT64,

```

```
  10:      BLOB_ATTR_LAST

```

```
  11:  };

```

```
  12:  bool blob_check_type(const void *ptr, unsigned int len, int type)

```

.csharpcode, .csharpcode pre {font-size: small; color: rgba(0, 0, 0, 1); font-family: consolas, "Courier New", courier, monospace; background-color: rgba(255, 255, 255, 1) } .csharpcode pre { margin: 0 } .csharpcode .rem { color: rgba(0, 128, 0, 1) } .csharpcode .kwrd { color: rgba(0, 0, 255, 1) } .csharpcode .str { color: rgba(0, 96, 128, 1) } .csharpcode .op { color: rgba(0, 0, 192, 1) } .csharpcode .preproc { color: rgba(204, 102, 51, 1) } .csharpcode .asp { background-color: rgba(255, 255, 0, 1) } .csharpcode .html { color: rgba(128, 0, 0, 1) } .csharpcode .attr { color: rgba(255, 0, 0, 1) } .csharpcode .alt { background-color: rgba(244, 244, 244, 1); width: 100%; margin: 0 } .csharpcode .lnum { color: rgba(96, 96, 96, 1) }

9. 嵌套操作

```
   1:  void * blob_nest_start(struct blob_buf *buf, int id)

```

```
   2:  Void blob_nest_end(struct blob_buf *buf, void *cookie)

```

.csharpcode, .csharpcode pre {font-size: small; color: rgba(0, 0, 0, 1); font-family: consolas, "Courier New", courier, monospace; background-color: rgba(255, 255, 255, 1) } .csharpcode pre { margin: 0 } .csharpcode .rem { color: rgba(0, 128, 0, 1) } .csharpcode .kwrd { color: rgba(0, 0, 255, 1) } .csharpcode .str { color: rgba(0, 96, 128, 1) } .csharpcode .op { color: rgba(0, 0, 192, 1) } .csharpcode .preproc { color: rgba(204, 102, 51, 1) } .csharpcode .asp { background-color: rgba(255, 255, 0, 1) } .csharpcode .html { color: rgba(128, 0, 0, 1) } .csharpcode .attr { color: rgba(255, 0, 0, 1) } .csharpcode .alt { background-color: rgba(244, 244, 244, 1); width: 100%; margin: 0 } .csharpcode .lnum { color: rgba(96, 96, 96, 1) }

10. 判断

```
bool blob_attr_equal(const struct blob_attr *a1, const struct blob_attr *a2)

```

11. 初始 / 销毁，解析

```
   1:  /**

```

```
   2:   * 初始化BLOB buffer

```

```
   3:   */

```

```
   4:  int blob_buf_init(struct blob_buf *buf, int id)

```

```
   5:   

```

```
   6:  /**

```

```
   7:   * 销毁BLOB buffer

```

```
   8:   */

```

```
   9:  void blob_buf_free(struct blob_buf *buf)

```

```
  10:   

```

```
  11:  /**

```

```
  12:   * 从attr串中根据info策略过滤，得到的结果存储在data属性数组中

```

```
  13:   *

```

```
  14:   * @param  attr 输入BLOB属性串

```

```
  15:   * @param  data 输出BLOB属性数组

```

```
  16:   * @param  info 属性过滤策略

```

```
  17:   * @param  max data数组大小

```

```
  18:   */

```

```
  19:  int blob_parse(struct blob_attr *attr, struct blob_attr **data, 

```

```
  20:                 const struct blob_attr_info *info, int max)

```

```
二：blobmsg相关接口

```

```
1.数据结构

```

```
   1:  struct blobmsg_hdr {

```

```
   2:      uint16_t namelen;

```

```
   3:      uint8_t name[];

```

```
   4:  } __packed;

```

```
   5:   

```

```
   6:  struct blobmsg_policy {

```

```
   7:      const char *name;

```

```
   8:      enum blobmsg_type type;

```

```
   9:  };

```

.csharpcode, .csharpcode pre {font-size: small; color: rgba(0, 0, 0, 1); font-family: consolas, "Courier New", courier, monospace; background-color: rgba(255, 255, 255, 1) } .csharpcode pre { margin: 0 } .csharpcode .rem { color: rgba(0, 128, 0, 1) } .csharpcode .kwrd { color: rgba(0, 0, 255, 1) } .csharpcode .str { color: rgba(0, 96, 128, 1) } .csharpcode .op { color: rgba(0, 0, 192, 1) } .csharpcode .preproc { color: rgba(204, 102, 51, 1) } .csharpcode .asp { background-color: rgba(255, 255, 0, 1) } .csharpcode .html { color: rgba(128, 0, 0, 1) } .csharpcode .attr { color: rgba(255, 0, 0, 1) } .csharpcode .alt { background-color: rgba(244, 244, 244, 1); width: 100%; margin: 0 } .csharpcode .lnum { color: rgba(96, 96, 96, 1) }

2. 存储结构

![](https://segmentfault.com/img/bVkcqj)

3. 消息类型

```
   1:  enum blobmsg_type {

```

```
   2:      BLOBMSG_TYPE_UNSPEC,

```

```
   3:      BLOBMSG_TYPE_ARRAY,

```

```
   4:      BLOBMSG_TYPE_TABLE,

```

```
   5:      BLOBMSG_TYPE_STRING,

```

```
   6:      BLOBMSG_TYPE_INT64,

```

```
   7:      BLOBMSG_TYPE_INT32,

```

```
   8:      BLOBMSG_TYPE_INT16,

```

```
   9:      BLOBMSG_TYPE_INT8,

```

```
  10:      __BLOBMSG_TYPE_LAST,

```

```
  11:      BLOBMSG_TYPE_LAST = __BLOBMSG_TYPE_LAST - 1,

```

```
  12:      BLOBMSG_TYPE_BOOL = BLOBMSG_TYPE_INT8,

```

```
  13:  };

```

.csharpcode, .csharpcode pre {font-size: small; color: rgba(0, 0, 0, 1); font-family: consolas, "Courier New", courier, monospace; background-color: rgba(255, 255, 255, 1) } .csharpcode pre { margin: 0 } .csharpcode .rem { color: rgba(0, 128, 0, 1) } .csharpcode .kwrd { color: rgba(0, 0, 255, 1) } .csharpcode .str { color: rgba(0, 96, 128, 1) } .csharpcode .op { color: rgba(0, 0, 192, 1) } .csharpcode .preproc { color: rgba(204, 102, 51, 1) } .csharpcode .asp { background-color: rgba(255, 255, 0, 1) } .csharpcode .html { color: rgba(128, 0, 0, 1) } .csharpcode .attr { color: rgba(255, 0, 0, 1) } .csharpcode .alt { background-color: rgba(244, 244, 244, 1); width: 100%; margin: 0 } .csharpcode .lnum { color: rgba(96, 96, 96, 1) }

4. 基本操作

```
   1:  /**

```

```
   2:   * 根据BLOB消息名字长度计算出blobmsg头部大小

```

```
   3:   */

```

```
   4:  static inline int blobmsg_hdrlen(unsigned int namelen)

```

```
   5:   

```

```
   6:  /**

```

```
   7:   * 获取BLOB消息名字

```

```
   8:   */

```

```
   9:  static inline const char *blobmsg_name(const struct blob_attr *attr)

```

```
  10:   

```

```
  11:  /**

```

```
  12:   * 获取BLOB消息类型

```

```
  13:   */

```

```
  14:  static inline int blobmsg_type(const struct blob_attr *attr)

```

```
  15:   

```

```
  16:  /**

```

```
  17:   * 获取BLOB消息数据内容

```

```
  18:   */

```

```
  19:  static inline void *blobmsg_data(const struct blob_attr *attr)

```

```
  20:   

```

```
  21:  /**

```

```
  22:   * 获取BLOB消息数据内容大小

```

```
  23:   */

```

```
  24:  static inline int blobmsg_data_len(const struct blob_attr *attr)

```

```
  25:  static inline int blobmsg_len(const struct blob_attr *attr)

```

```
  26:  数据类型判断

```

```
  27:   

```

```
  28:  /**

```

```
  29:   * 判断BLOBMSG属性类型是否合法

```

```
  30:   */

```

```
  31:  bool blobmsg_check_attr(const struct blob_attr *attr, bool name)

```

```
  32:  设置

```

```
  33:   

```

```
  34:  int blobmsg_add_field(struct blob_buf *buf, int type, const char *name,

```

```
  35:                        const void *data, unsigned int len)

```

```
  36:   

```

```
  37:  static inline int

```

```
  38:  blobmsg_add_u8(struct blob_buf *buf, const char *name, uint8_t val)

```

```
  39:   

```

```
  40:  static inline int

```

```
  41:  blobmsg_add_u16(struct blob_buf *buf, const char *name, uint16_t val)

```

```
  42:   

```

```
  43:  static inline int

```

```
  44:  blobmsg_add_u32(struct blob_buf *buf, const char *name, uint32_t val)

```

```
  45:   

```

```
  46:  static inline int

```

```
  47:  blobmsg_add_u64(struct blob_buf *buf, const char *name, uint64_t val)

```

```
  48:   

```

```
  49:  static inline int

```

```
  50:  blobmsg_add_string(struct blob_buf *buf, const char *name, const char *string)

```

```
  51:   

```

```
  52:  static inline int

```

```
  53:  blobmsg_add_blob(struct blob_buf *buf, struct blob_attr *attr)

```

```
  54:   

```

```
  55:  /**

```

```
  56:   * 格式化设备BLOGMSG

```

```
  57:   */

```

```
  58:  void blobmsg_printf(struct blob_buf *buf, const char *name, const char *format, ...)

```

```
  59:  获取

```

```
  60:   

```

```
  61:  static inline uint8_t blobmsg_get_u8(struct blob_attr *attr)

```

```
  62:  static inline bool blobmsg_get_bool(struct blob_attr *attr)

```

```
  63:  static inline uint16_t blobmsg_get_u16(struct blob_attr *attr)

```

```
  64:  static inline uint32_t blobmsg_get_u32(struct blob_attr *attr)

```

```
  65:  static inline uint64_t blobmsg_get_u64(struct blob_attr *attr)

```

```
  66:  static inline char *blobmsg_get_string(struct blob_attr *attr)

```

```
  67:  创建

```

```
  68:   

```

```
  69:  /**

```

```
  70:   * 创建BLOBMSG，返回数据区开始地址

```

```
  71:   */

```

```
  72:  void *blobmsg_alloc_string_buffer(struct blob_buf *buf, const char *name, 

```

```
  73:  unsigned int maxlen)

```

```
  74:   

```

```
  75:  /**

```

```
  76:   * 扩大BLOGMSG，返回数据区开始地址

```

```
  77:   */

```

```
  78:  void *blobmsg_realloc_string_buffer(struct blob_buf *buf, unsigned int maxlen)

```

```
  79:   

```

```
  80:  void blobmsg_add_string_buffer(struct blob_buf *buf)

```

```
  81:  遍历

```

```
  82:   

```

```
  83:  #define blobmsg_for_each_attr(pos, attr, rem)

```

```
  84:  嵌套

```

```
  85:   

```

```
  86:  static inline void * blobmsg_open_array(struct blob_buf *buf, const char *name)

```

```
  87:  static inline void blobmsg_close_array(struct blob_buf *buf, void *cookie)

```

```
  88:   

```

```
  89:  static inline void *blobmsg_open_table(struct blob_buf *buf, const char *name)

```

```
  90:  static inline void blobmsg_close_table(struct blob_buf *buf, void *cookie)

```

```
  91:  解析BLOGMSG

```

```
  92:   

```

```
  93:  /**

```

```
  94:   * 从data BLOGMSG串中根据policy策略过滤，得到的结果存储在tb BLOGATTR数组中

```

```
  95:   *

```

```
  96:   * @param  policy 过滤策略

```

```
  97:   * @param  policy_len 策略个数

```

```
  98:   * @param  tb 返回属性数据

```

```
  99:   * @param  len data属性个数

```

```
 100:   */

```

```
 101:  int blobmsg_parse(const struct blobmsg_policy *policy, int policy_len,

```

```
 102:                    struct blob_attr **tb, void *data, unsigned int len)

```

```
三：实例操作

```

##### 把 UCI 转化为 BLOB

UCI 配置文件:  
/etc/config/test

```
config policy test
    option name 'test'
    option enable '1'
    option dns '1.1.1.1 2.2.2.2'

```

```
   1:  定义参数列表:

```

```
   2:   

```

```
   3:  enum {

```

```
   4:      POLICY_ATTR_NAME,       /** name */

```

```
   5:      POLICY_ATTR_ENABLE,     /** enable */

```

```
   6:      POLICY_ATTR_DNS,        /** dns */

```

```
   7:      __POLICY_ATTR_MAX

```

```
   8:  };

```

```
   9:   

```

```
  10:  static const struct blobmsg_policy policy_attrs[__POLICY_ATTR_MAX] = {

```

```
  11:      [POLICY_ATTR_NAME] = { .name = "name", .type = BLOBMSG_TYPE_STRING },

```

```
  12:      [POLICY_ATTR_ENABLE] = { .name = "enable", .type = BLOBMSG_TYPE_BOOL },

```

```
  13:      [POLICY_ATTR_DNS] = { .name = "dns", .type = BLOBMSG_TYPE_ARRAY },

```

```
  14:  };

```

```
  15:   

```

```
  16:  /** 定义BLOBMSG_TYPE_ARRAY类型参数的实际数据类型 */

```

```
  17:  static const struct uci_blob_param_info policy_attr_info[__POLICY_ATTR_MAX] = {

```

```
  18:      [POLICY_ATTR_DNS] = { .type = BLOBMSG_TYPE_STRING },

```

```
  19:  };

```

```
  20:   

```

```
  21:  static const struct uci_blob_param_list policy_attr_list = {

```

```
  22:      .n_params = __POLICY_ATTR_MAX,

```

```
  23:      .params = policy_attrs,

```

```
  24:      .info = policy_attr_info,

```

```
  25:  };

```

```
  26:  转化为BLOB:

```

```
  27:   

```

```
  28:  static struct uci_context *g_uci_ctx;

```

```
  29:  static struct blob_buf *b;

```

```
  30:   

```

```
  31:  void

```

```
  32:  transform(const char *config)

```

```
  33:  {

```

```
  34:      struct uci_context *ctx = g_uci_ctx;

```

```
  35:      struct uci_package *p = NULL;

```

```
  36:   

```

```
  37:      if (!ctx) {

```

```
  38:          ctx = uci_alloc_context();

```

```
  39:          g_uci_ctx = ctx;

```

```
  40:          uci_set_confdir(ctx, NULL);

```

```
  41:      } else {

```

```
  42:          p = uci_lookup_package(ctx, config);

```

```
  43:          if (p)

```

```
  44:              uci_unload(ctx, p);

```

```
  45:      }

```

```
  46:   

```

```
  47:      if (uci_load(ctx, config, &p))

```

```
  48:          return;    

```

```
  49:   

```

```
  50:      struct uci_element *e;

```

```
  51:      struct blob_attr *config = NULL;

```

```
  52:      uci_foreach_element(&p->sectons, e) {

```

```
  53:          struct uci_section *s = uci_to_section(e);

```

```
  54:   

```

```
  55:          blob_buf_init(&b, 0);

```

```
  56:          uci_to_blob(&b, s, &policy_attr_list);

```

```
  57:          config = blob_memdup(b.head);

```

```
  58:   

```

```
  59:          /**

```

```
  60:           * do something with `config` 

```

```
  61:           * free(config), when not use it

```

```
  62:           */

```

```
  63:      }

```

```
  64:  }

```

```
  65:  使用转化后的blob_attr

```

```
  66:   

```

```
  67: void

```

```
  68:  foo(blob_attr *confg)

```

```
  69:  {

```

```
  70:      struct blob_attr *tb[__POLICY_ATTR_MAX];

```

```
  71:   

```

```
  72:      blobmsg_parse(policy_attrs, __POLICY_ATTR_MAX, tb,

```

```
  73:              blob_data(config), blob_len(config));

```

```
  74:   

```

```
  75:      /**

```

```
  76:       * do something with *tb[] 

```

```
  77:       */

```

```
  78:  }

```

.csharpcode, .csharpcode pre {font-size: small; color: rgba(0, 0, 0, 1); font-family: consolas, "Courier New", courier, monospace; background-color: rgba(255, 255, 255, 1) } .csharpcode pre { margin: 0 } .csharpcode .rem { color: rgba(0, 128, 0, 1) } .csharpcode .kwrd { color: rgba(0, 0, 255, 1) } .csharpcode .str { color: rgba(0, 96, 128, 1) } .csharpcode .op { color: rgba(0, 0, 192, 1) } .csharpcode .preproc { color: rgba(204, 102, 51, 1) } .csharpcode .asp { background-color: rgba(255, 255, 0, 1) } .csharpcode .html { color: rgba(128, 0, 0, 1) } .csharpcode .attr { color: rgba(255, 0, 0, 1) } .csharpcode .alt { background-color: rgba(244, 244, 244, 1); width: 100%; margin: 0 } .csharpcode .lnum { color: rgba(96, 96, 96, 1) }

.csharpcode, .csharpcode pre {font-size: small; color: rgba(0, 0, 0, 1); font-family: consolas, "Courier New", courier, monospace; background-color: rgba(255, 255, 255, 1) } .csharpcode pre { margin: 0 } .csharpcode .rem { color: rgba(0, 128, 0, 1) } .csharpcode .kwrd { color: rgba(0, 0, 255, 1) } .csharpcode .str { color: rgba(0, 96, 128, 1) } .csharpcode .op { color: rgba(0, 0, 192, 1) } .csharpcode .preproc { color: rgba(204, 102, 51, 1) } .csharpcode .asp { background-color: rgba(255, 255, 0, 1) } .csharpcode .html { color: rgba(128, 0, 0, 1) } .csharpcode .attr { color: rgba(255, 0, 0, 1) } .csharpcode .alt { background-color: rgba(244, 244, 244, 1); width: 100%; margin: 0 } .csharpcode .lnum { color: rgba(96, 96, 96, 1) }

.csharpcode, .csharpcode pre {font-size: small; color: rgba(0, 0, 0, 1); font-family: consolas, "Courier New", courier, monospace; background-color: rgba(255, 255, 255, 1) } .csharpcode pre { margin: 0 } .csharpcode .rem { color: rgba(0, 128, 0, 1) } .csharpcode .kwrd { color: rgba(0, 0, 255, 1) } .csharpcode .str { color: rgba(0, 96, 128, 1) } .csharpcode .op { color: rgba(0, 0, 192, 1) } .csharpcode .preproc { color: rgba(204, 102, 51, 1) } .csharpcode .asp { background-color: rgba(255, 255, 0, 1) } .csharpcode .html { color: rgba(128, 0, 0, 1) } .csharpcode .attr { color: rgba(255, 0, 0, 1) } .csharpcode .alt { background-color: rgba(244, 244, 244, 1); width: 100%; margin: 0 } .csharpcode .lnum { color: rgba(96, 96, 96, 1) }