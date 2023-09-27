---
url: https://www.cnblogs.com/futuretea/p/11995606.html
title: 如何快速查看 archlinux pacman 软件记录？
date: 2023-04-20 23:10:34
tag: 
banner: "undefined"
banner_icon: 🔖
---
## 设置别名[#](#447325012)

```
alias pacmanlog='cat /var/log/pacman.log | grep -E (installed|reinstalled|removed|downgraded|upgraded)'


```

## 使用效果[#](#2304986632)

```
[2019-11-22T01:27:06+0800] [ALPM] installed pass (1.7.3-1)
[2019-11-22T03:09:11+0800] [ALPM] installed ragel (6.10-2)
[2019-11-24T00:23:15+0800] [ALPM] installed pdftk (3.0.8-1)
[2019-11-24T03:17:49+0800] [ALPM] installed musl (1.1.24-1)
[2019-11-24T09:36:53+0800] [ALPM] installed jdk11-openjdk (11.0.5.u10-1)
[2019-11-24T09:37:50+0800] [ALPM] installed intellij-idea-community-edition (2:2019.2.4-1)
[2019-11-27T10:12:54+0800] [ALPM] removed python-sqlparse (0.3.0-1)
[2019-11-27T10:13:38+0800] [ALPM] installed python-sqlparse-cli_helpers (0.2.4-2)
[2019-11-30T21:20:17+0800] [ALPM] removed unzip (6.0-13)
[2019-11-30T21:20:17+0800] [ALPM] installed unzip-iconv (6.0-13)
[2019-12-06T10:51:23+0800] [ALPM] installed kolourpaint (19.08.3-1)
[2019-12-06T14:35:15+0800] [ALPM] installed img-bin (0.5.1-1)


```