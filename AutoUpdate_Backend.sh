#!/bin/bash
# This shell is to update web project auto
# 
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# Update : 2018-09-10
PATH=/bin:/sbin:/usr/bin:/user/sbin
export PATH
PINK="\033[1;35;25m"
PLAIN="\033[0m"

#判断用户输入的第一个参数
case $1 in
    api.homemoji.com)
        if [ ! -e /data/$1 ]; then
            echo -e "${PINK}your enter the directory $1 is not exists,please check it out${PLAIN}"
            exit
        fi
   ;;
   api.homemoji.com.cn)
        if [ ! -e /data/$1 ]; then
            echo -e "${PINK}your enter the directory $1 is not exists,please check it out${PLAIN}"
            exit
        else
            mkdir -p /data/$1
        fi
   ;;
    *)
        echo -e "${PINK}your enter the directory is not correct!!${PLAIN}"
        exit
    ;;
esac
#判断用户输入的第二个参数
case "$2" in
[0-1])
    [ $2 -eq 0 ] && TAR=api-test-`date "+%Y-%m-%d"`.tar.gz || TAR=api-`date "+%Y-%m-%d"`.tar.gz
    [ $2 -eq 0 ] && TAR1=emoji-test-`date "+%Y-%m-%d"`.sql || TAR1=emoji-`date "+%Y-%m-%d"`.sql
;;
[a-z][A-Z])
    echo -e "${PINK}your character is alphabet, please enter a param after the first param in 0 or 1${PLAIN}"
    exit
   ;;
[2-9])
    echo -e "${PINK}your input was out of rang for number,please into 0 or 1${PLAIN}"
    exit
    ;;
*)
    echo -e "${PINK}your input was not correct,please check it out${PLAIN}"
    exit
    ;;
esac

#判断日志目录是否存在，
if [ ! -e /data/AutoShellLog/`date "+%Y-%m-%d"` ];
then
    mkdir -p /data/AutoShellLog/`date "+%Y-%m-%d"`
fi

#判断当前项目目录是否存在
if [ ! -e /data/$1 ]; then
    mkdir -p /data/$1
fi
#备份数据库
echo -e "${PINK}it is prepare for backup the databases to a SQL file${PLAIN}"
mysqldump -u$3 -p$4 emoji > /data/$TAR1
sleep 5
#进入项目目录。进行打包备份
cd /data
echo -e "${PINK}tar the project directory and the sql file to package please hold a minutes ........${PLAIN}"
tar zcf $TAR $TAR1 $1 --exclude=$1/public/uploads
echo -e "${PINK}tar $TAR of $1 successfully${PLAIN}" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
sleep 5


#进入后台项目目录
if [ ! -e /data/backend ];then
    echo -e "${PINK}the project directory is not exists in this server, now init the project.........${PLAIN}"
    git clone git@gitee.com:homemoji/backend.git
    sleep 5
fi
#进入项目目录进行数据更新
cd /data/backend
echo "enter the directory `pwd`";

if [ $2 -eq 0 ]; then
    echo -e "${PINK}It's being ready to git clone from origin develop branch to local...........${PLAIN}" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
    echo -e "${PINK}It's being ready to git clone from origin develop branch to local...........${PLAIN}"
    git pull origin develop  --force
else
    echo -e "${PINK}It's being ready to git clone from origin master branch to local...........${PLAIN}" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
    echo -e "${PINK}It's being ready to git clone from origin master branch to local...........${PLAIN}"
    git pull origin master --force
fi

if [ $? -eq 0 ]; then
        echo "git logs ten nubers nearby below" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
        git log --oneline | head -10 >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
        echo "It's Being ready to copy backend web project to folder /data/$2" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
        `\cp -rf /data/backend/*  /data/$1`
        if [ ! $? -eq 0 ]; then
            echo -e "${PINK}copy project from git repsitory to website directory unsuccessful,please check it out${PLAIN}"
        fi
        chown -R apache:apache /data/$1
        ls -lha /data/$1 >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
        sleep 3
fi

echo -e "${PINK}the backup file of $TAR will uploads to server save ..............${PLAIN}"
curl -k -u root:qepyjfnfss1314. -T "/data/$TAR" sftp://47.98.105.236/root/homemoji-bak/ &>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${PINK}upload backup file of $TAR successfully ...... ${PLAIN}"
else
    echo -e "${PINK}upload backup file of $TAR failure ...... ${PLAIN}"
fi
