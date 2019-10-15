#!/bin/bash
# This shell is to update web project auto
#
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# create : 2019-08-07
PATH=/bin:/sbin:/usr/bin:/user/sbin
export PATH
PINK="\033[1;35;25m"
PLAIN="\033[0m"
#执行composer组件安装
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
    echo 'run composer install in project please hold a minutes ........'
    cd /data/wwwroot/erp.homemoji.com.cn && composer install
    echo "composer install was successfully" >> /data/aslog/`date "+%Y%m%d"`/$1.log
    sleep 5
else
    echo 'run composer install in project please hold a minutes ........'
     cd /webData/erp.io && composer install
    echo "composer install was successfully" >> /webData/aslog/`date "+%Y%m%d"`/$1.log
    sleep 5
fi

