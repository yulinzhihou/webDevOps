#!/bin/bash
# This shell is to auto backup mysql database for web project
#
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# Update : 2018-12-01
#存放备份数据库的目录
DIR=$1
#备份文件后缀时间
TIME=`date +%Y_%m_%d_%H_%M_%S`
#需要备份的数据库名称
DB_NAME=$2
#判断用户输入的第一个参数
case $1 in
    mysql)
        if [ ! -e /backup/$1 ]; then
            echo -e "${PINK}your enter the directory $1 is not exists,please check it out${PLAIN}"
            exit
        fi
   ;;
    *)
        echo -e "${PINK}your enter the directory is not correct!!${PLAIN}"
        exit
    ;;
esac

#mysql 用户名
#db_user=
#mysql 密码
#db_pass=
#mysqldump命令使用绝对路径
#/usr/bin/mysqldump $DB_NAME | gzip > $DIR/$DB_NAME.sql.gz
/usr/bin/mysqldump $DB_NAME > /backup/$DIR/$DB_NAME-$TIME.sql
#删除7天之前的备份文件
find /backup/$1 -name $DB_NAME "*.sql" -type f -mtime +7 -exec rm -rf {} \; > /dev/null 2>&1
