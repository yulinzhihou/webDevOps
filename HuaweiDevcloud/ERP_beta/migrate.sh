#!/bin/bash
# This shell is to update web project auto
#
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# create : 2019-08-21
PATH=/bin:/sbin:/usr/bin:/user/sbin
export PATH
PINK="\033[1;35;25m"
PLAIN="\033[0m"
#执行php think数据迁移，以及种子文件迁移组件安装
#判断用户输入的第一个参数
case $1 in
    erp.homemoji.com.cn)
        if [[ ! -e /data/wwwroot/$1 ]]; then
            echo "your enter the directory $1 is not exists,please check it out"
            exit
        fi
   ;;
    erp.io)
        if [[ ! -e /webData/$1 ]]; then
            echo "your enter the directory $1 is not exists,please check it out"
            exit
        fi
   ;;
    *)
        echo 'your enter the directory is not correct!!'
        exit
    ;;
esac
#执行操作
if [[ -e /data/wwwroot ]] ; then
    cd /data/wwwroot/$1
    echo 'run migration for project ........' >> /data/aslog/`date "+%Y%m%d"`/$1.log
    #执行数据迁移
    php think migrate:run >> /data/aslog/`date "+%Y%m%d"`/erp_migrate.log 2>&1
    #执行种子文件迁移
    echo "run seed for project" >> /data/aslog/`date "+%Y%m%d"`/$1.log
    php think seed:run >> /data/aslog/`date "+%Y%m%d"`/erp_migrate.log 2>&1
    sleep 5
else
    cd /webData/$1
    echo 'run migration for project ........' >> /data/aslog/`date "+%Y%m%d"`/$1.log
    #执行数据迁移
    php think migrate:run >> /data/aslog/`date "+%Y%m%d"`/erp_test_migrate.log 2>&1
    #执行种子文件迁移
    echo "run seed for project" >> /data/aslog/`date "+%Y%m%d"`/$1.log
    php think seed:run >> /data/aslog/`date "+%Y%m%d"`/erp_test_migrate.log 2>&1
    sleep 5
fi
