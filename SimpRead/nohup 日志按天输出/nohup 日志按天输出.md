---
url: https://www.cnblogs.com/jin-521/p/11417505.html
title: nohup 日志按天输出
date: 2023-06-17 12:13:51
tag: 
banner: "undefined"
banner_icon: 🔖
---
输出日志在当前目录：

nohup java -jar ace-auth.jar >> nohup`date +%Y-%m-%d`.out 2>&1 &

指定日志目录输出：

指定输出到当前目录 log 文件夹中

nohup java -jar ace-auth.jar >> ./log/nohup`date +%Y-%m-%d`.out 2>&1 &

发现无法自动切割日志，做一个定时脚本，凌晨时候 kill 掉进程然后再启动

kill -9 $(ps -ef |grep java |grep -w 'java'|grep -v 'grep'|awk '{print $2}')

或者

ps -ef | grep java | grep -v grep | awk '{print $2}' | xargs kill -9

定时执行：

crontab -e

0 0 * * * /root/everyday.sh

补：现在使用的方案：

将原日志文件复制出来，然后清空原日志文件

cat *.out >>　nohup`date +%Y-%m-%d`.out

echo " " > nohup.out