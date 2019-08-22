#!/bin/bash
# This shell is to update web project auto
# 
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# create : 2018-09-04
# Update : 2018-11-15
PATH=/bin:/sbin:/usr/bin:/user/sbin
export PATH
PINK="\033[1;35;25m"
PLAIN="\033[0m"
#判断用户输入的第一个参数
case $1 in
    erp.homemoji.com)
        if [ ! -e /data/$1 ]; then
            echo "your enter the directory $1 is not exists,please check it out"
            exit
        fi
   ;;
   erp.homemoji.com.cn)
        if [ ! -e /data/$1 ]; then
            echo "your enter the directory $1 is not exists,please check it out"
            exit
        fi
   ;;
    erp.io)
        if [ ! -e /webData/$1 ]; then
            echo "your enter the directory $1 is not exists,please check it out"
            exit
        fi
   ;;
    *)
        echo 'your enter the directory is not correct!!'
        exit
    ;;
esac
#判断用户输入的第二个参数
case "$2" in
[0-1])
    [ $2 -eq 0 ] && TAR=erp-test-`date "+%Y-%m-%d"`.tar.gz || TAR=erp-`date "+%Y-%m-%d"`.tar.gz
    [ $2 -eq 0 ] && TAR1=emoji-test-`date "+%Y-%m-%d"`.sql || TAR1=emoji-`date "+%Y-%m-%d"`.sql
;;
[a-z][A-Z])
    echo "your character is alphabet, please enter a param after the first param in 0 or 1"
    exit
   ;;
[2-9])
    echo "your input was out of rang for number,please into 0 or 1"
    exit
    ;;
*)
    echo "your input was not correct,please check it out"
    exit
    ;;
esac

#判断日志目录
if [ -e /data ] && [ ! -e /data/AutoShellLog/`date "+%Y-%m-%d"` ] ;then
    mkdir -p /data/AutoShellLog/`date "+%Y-%m-%d"`
fi

if [ -e /webData ]  && [ ! -e /webData/AutoShellLog/`date "+%Y-%m-%d"` ];then
    mkdir -p /webData/AutoShellLog/`date "+%Y-%m-%d"`
fi

#判断当前项目目录是否存在
if [ -e /data ]  &&  [ ! -e /data/$1 ]; then
    mkdir -p /data/$1
elif [ -e /webData ] && [ ! -e /webData/$1 ]; then
    mkdir -p /webData/$1
fi

#备份数据库
echo 'it is prepare for backup the databases to a SQL file'
if [ -e /data ]; then
    mysqldump -u$3 -p$4 emoji > /data/$TAR1
    sleep 5
else
    mysqldump -u$3 -p$4 emoji > /webData/$TAR1
    sleep 5
fi

if [ -e /data ] ; then
    cd /data
    echo 'tar the project directory and the sql file to package please hold a minutes ........'
    tar zcf $TAR $TAR1 $1
    echo "tar $TAR of $1 successfully" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
    sleep 5
    #进入ERP项目目录
    if [ ! -e /data/ERP ];then
        echo "the project directory is not exists in this server, now init the project........."
        git clone git@gitee.com:homemoji/ERP.git
        sleep 5
    fi
    #进入项目目录并更新项目
    cd /data/ERP
    echo "enter the directory `pwd`";
    if [ $2 -eq 0 ]; then
        echo "It's being ready to git clone from origin develop branch to local..........." >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
        echo "It's being ready to git clone from origin develop branch to local..........."
        git pull origin develop  --force
    else
        echo "It's being ready to git clone from origin master branch to local..........." >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
        echo "It's being ready to git clone from origin master branch to local..........."
        git pull origin master --force
    fi

    if [ $? -eq 0 ];then
            echo "git logs ten nubers nearby below" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
            git log --oneline | head -10 >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
            echo "It's Being ready to copy backend web project to folder /data/$1" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
            `\cp -rf /data/ERP/*  /data/$1`
            chown -R apache:apache /data/$1
            ls -lha /data/$1 >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
            sleep 3
    fi

    echo "the backup file of $TAR will uploads to server save .............."
    curl -k -u root:qepyjfnfss1314. -T "/data/$TAR" sftp://47.98.105.236/root/homemoji-bak/
    if [ $? -eq 0 ]; then
        echo "upload backup file of $TAR successfully ...... "
    else
         echo "upload backup file of $TAR failure ...... "
    fi
else
    cd /webData
    echo 'tar the project directory and the sql file to package please hold a minutes ........'
    tar zcf $TAR $TAR1 $1
    echo "tar $TAR of $1 successfully" >> /webData/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
    sleep 5
    #进入ERP项目目录
    if [ ! -e /webData/GitRepository/ERP ];then
        echo "the project directory is not exists in this server, now init the project........."
        git clone git@gitee.com:homemoji/ERP.git
        sleep 5
    fi
    #进入项目目录并更新项目
    cd /webData/GitRepository/ERP
    echo "enter the directory `pwd`";
    if [ $2 -eq 0 ]; then
        echo "It's being ready to git pull from origin develop branch to local..........." >> /webData/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
        echo "It's being ready to git pull from origin develop branch to local..........."
        git pull origin develop  --force
    else
        echo "It's being ready to git pull from origin master branch to local..........." >> /webData/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
        echo "It's being ready to git pull from origin master branch to local..........."
        git pull origin master --force
    fi

    if [ $? -eq 0 ];then
            echo "git logs ten nubers nearby below" >> /webData/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
            git log --oneline | head -10 >> /webData/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
            echo "It's Being ready to copy backend web project to folder /data/$1" >> /webData/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
            `\cp -rf /webData/GitRepository/ERP/*  /webData/$1`
            chown -R apache:apache /webData/$1
            ls -lha /webData/$1 >> /webData/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
            sleep 3
    fi

    echo "the backup file of $TAR will uploads to server save .............."
    curl -k -u root:qepyjfnfss1314. -T "/webData/$TAR" sftp://47.98.105.236/root/homemoji-bak/
    if [ $? -eq 0 ]; then
        echo "upload backup file of $TAR successfully ...... "
    else
         echo "upload backup file of $TAR failure ...... "
    fi

fi