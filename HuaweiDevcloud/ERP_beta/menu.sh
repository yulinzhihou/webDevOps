#!/bin/bash
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# create : 2019-08-07
PATH=/bin:/sbin:/usr/bin:/user/sbin
export PATH
PINK="\033[1;35;25m"
PLAIN="\033[0m"
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

if [[ -e /data/wwwroot ]] ; then
    cd /data/wwwroot/$1
    echo 'run command menu for project ........' >> /data/aslog/`date "+%Y%m%d"`/$1.log
    #执行菜单生成
    bash data/command/menu.sh >> /data/aslog/`date "+%Y%m%d"`/erp_bash_menu.log 2>&1
    sleep 5
    cat /data/aslog/`date "+%Y%m%d"`/erp_beta_bash_menu.log
else
    cd /webData/$1
    echo 'run command menu for project ........' >> /data/aslog/`date "+%Y%m%d"`/$1.log
    #执行菜单生成
    bash data/command/menu.sh >> /data/aslog/`date "+%Y%m%d"`/erp_test_bash_menu.log 2>&1
    sleep 5
    cat /data/aslog/`date "+%Y%m%d"`/erp_test_bash_menu.log
fi