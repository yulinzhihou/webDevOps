#!/bin/bash
# This shell is to update web project auto
# 
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# Update : 2019-01-17
PATH=/bin:/sbin:/usr/bin:/user/sbin
export PATH
PINK="\033[1;35;25m"
PLAIN="\033[0m"
PROJECT_PATH=gitlab.homemoji.com:homemoji/backend.git;
LOG_PATH=~/.local/logs/`date "+%Y-%m-%d"`
BACKUP_PATH=~/.local/backup
WEB_PATH=/data/wwwroot
TAR=api-`date "+%Y-%m-%d"`.tar.gz
#判断用户输入的第一个参数
case $1 in
    api.homemoji.com)
        if [ ! -e $WEB_PATH/$1 ]; then
            echo -e "${PINK}your enter the directory $1 is not exists,please check it out${PLAIN}"
            exit
        fi
   ;;
    *)
        echo -e "${PINK}your enter the directory is not correct!!${PLAIN}"
        echo "Usage: deploy project_path {0|1}"
        exit
    ;;
esac
#判断用户输入的第二个参数
#case "$2" in
#[0-1])
#    [ $2 -eq 0 ] && TAR=api-test-`date "+%Y-%m-%d"`.tar.gz || TAR=api-`date "+%Y-%m-%d"`.tar.gz
#    #[ $2 -eq 0 ] && TAR1=emoji-test-`date "+%Y-%m-%d"`.sql || TAR1=emoji-`date "+%Y-%m-%d"`.sql
#;;
#[a-z][A-Z])
#    echo -e "${PINK}your character is alphabet, please enter a param after the first param in 0 or 1${PLAIN}"
#    exit
#   ;;
#[2-9])
#    echo -e "${PINK}your input was out of rang for number,please into 0 or 1${PLAIN}"
#    exit
#    ;;
#*)
#    echo -e "${PINK}your input was not correct,please check it out${PLAIN}"
#    exit
#    ;;
#esac

#判断日志目录是否存在，
if [ ! -e $LOG_PATH ];
then
    mkdir -p $LOG_PATH
fi

#判断备份目录是否存在
if [ ! -e $BACKUP_PATH ];
then
    mkdir -p $BACKUP_PATH
fi

#判断当前项目目录是否存在
if [ -e $WEB_PATH/$1 ]; then
    #备份数据库
    #echo -e "${PINK}it is prepare for backup the databases to a SQL file${PLAIN}"
    #mysqldump emoji > $WEB_PATH/$TAR1
    #sleep 5
    #进入项目目录。进行打包备份
    cd $WEB_PATH
    echo -e "${PINK}tar the project directory and the sql file to package please hold a minutes ........${PLAIN}"
    sudo tar zcf $TAR $1 --exclude=$1/public/uploads --exclude=$1/,git
    sudo mv *.tar.gz $BACKUP_PATH
    echo -e "${PINK}tar $TAR of $1 successfully${PLAIN}" >>  $LOG_PATH/$1.log
    sleep 5
    #mv ./$TAR $BACKUP_PATH
    #rm -rf *.sql
    #更新项目
    cd $1
    #进入项目目录进行数据更新
    echo "enter the directory `pwd`";
#    if [ $2 -eq 0 ]; then
#        echo -e "${PINK}It's being ready to git clone from origin develop branch to local...........${PLAIN}" >> $LOG_PATH/$1.log
#        echo -e "${PINK}It's being ready to git clone from origin develop branch to local...........${PLAIN}"
#        git pull origin develop  --force
#    else
        echo -e "${PINK}It's being ready to git clone from origin master branch to local...........${PLAIN}" >>  $LOG_PATH/$1.log
        echo -e "${PINK}It's being ready to git clone from origin master branch to local...........${PLAIN}"
        git pull origin master --force
#    fi

    if [ $? -eq 0 ]; then
        echo "git logs ten nubers nearby below" >>  $LOG_PATH/$1.log
        git log --oneline | head -10 >>  $LOG_PATH/$1.log
        echo "It's Being ready to copy backend web project to folder /data/$2" >>  $LOG_PATH/$1.log
        sudo chown -R gitlab-runner:gitlab-runner $WEB_PATH/$1
        ls -lha $WEB_PATH/$1 >>  $LOG_PATH/$1.log
        sleep 3
    fi
else
    cd $WEB_PATH
    echo -e "${PINK}the project directory is not exists in this server, now init the project.........${PLAIN}"
    git clone $PROJECT_PATH $1
    sleep 5
    #TODO::可以集成初始化项目的所有命令，这里就直接省略，采用手动方式部署
fi


#echo -e "${PINK}the backup file of $TAR will uploads to server save ..............${PLAIN}"
#curl -k -u root:qepyjfnfss1314. -T "$BACKUP_PATH/$TAR" sftp://47.98.105.236/root/homemoji-bak/ &>/dev/null
#if [ $? -eq 0 ]; then
#    echo -e "${PINK}upload backup file of $TAR successfully ...... ${PLAIN}"
#else
#    echo -e "${PINK}upload backup file of $TAR failure ...... ${PLAIN}"
#fi
