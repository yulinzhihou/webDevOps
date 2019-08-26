#!/bin/bash
# This shell is to update web project auto
#
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# create : 2018-09-04
# Update : 2019-08-07
PATH=/bin:/sbin:/usr/bin:/user/sbin
export PATH
PINK="\033[1;35;25m"
PLAIN="\033[0m"
#判断用户输入的第一个参数
case $1 in
    erp.homemoji.com)
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
#判断用户输入的第二个参数
case $2 in
[0-1])
    [[ $2 -eq 0 ]] && TAR=erp-test-`date "+%Y-%m-%d"`.tar.gz || TAR=erp-`date "+%Y-%m-%d"`.tar.gz
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
if [[ -e /data ]] && [[ ! -e /data/aslog/`date "+%Y%m%d"` ]]  && [[ $1 -eq 'erp.homemoji.com' ]] && [[ $2 -eq 1 ]] ;then
    mkdir -p /data/aslog/`date "+%Y%m%d"`
fi

if [[ -e /webData ]]  && [[ ! -e /webData/aslog/`date "+%Y%m%d"` ]] && [[ $1 -eq 'erp.io' ]] &&  [[ $2 -eq 0 ]] ;then
    mkdir -p /webData/aslog/`date "+%Y%m%d"`
fi

#判断当前项目目录是否存在
if [[ -e /data ]]  &&  [[ ! -e /data/wwwroot/$1 ]]; then
    mkdir -p /data/wwwroot/$1
elif [[ -e /webData ]] && [[ ! -e /webData/$1 ]]; then
    mkdir -p /webData/$1
fi


if [[ -e /data/wwwroot ]] && [[ $1 -eq 'erp.homemoji.com' ]] && [[ $2 -eq 1 ]]  ; then
    cd /data/wwwroot/
    echo 'tar the project directory and the sql file to package please hold a minutes ........'
    tar zcf ${TAR} $1 --exclude $1/public/uploads
    echo "tar $TAR of $1 successfully" >> /data/aslog/`date "+%Y%m%d"`/$1.log
    sleep 5
    #进入ERP项目目录
    if [[ ! -e /data/wwwroot/$1 ]];then
        echo "the project directory is not exists in this server, now init the project........."
        git clone git@codehub-cn-south-1.devcloud.huaweicloud.com:ERP00003/ERP.git $1
        sleep 15
    fi
    #进入项目目录并更新项目
    cd /data/wwwroot/$1
    echo "enter the directory `pwd`";
    if [[ $2 -eq 0 ]]; then
        echo "It's being ready to git clone from origin develop branch to local..........." >> /data/aslog/`date "+%Y%m%d"`/$1.log
        echo "It's being ready to git clone from origin develop branch to local..........."
        git pull origin develop  --force
    else
        echo "It's being ready to git clone from origin master branch to local..........." >> /data/aslog/`date "+%Y%m%d"`/$1.log
        echo "It's being ready to git clone from origin master branch to local..........."
        git pull origin master --force
    fi

    if [[ $? -eq 0 ]];then
        echo "git logs ten nubers nearby below" >> /data/aslog/`date "+%Y%m%d"`/$1.log
        git log --oneline | head -10 >> /data/aslog/`date "+%Y%m%d"`/$1.log
        echo "It's Being ready to copy backend web project to folder /data/wwwroot/$1" >> /data/aslog/`date "+%Y%m%d"`/$1.log
        chown -R www:www /data/wwwroot/$1
        ls -lha /data/wwwroot/$1 >> /data/aslog/`date "+%Y%m%d"`/$1.log
        sleep 3
        #传送到专用备份服务器 注：由于备份文件过大，导致会长期占用带宽。所以部署项目的时候不进行上传操作
#        if [[ $HOSTNAME -eq 'WebServer1-6264' ]]; then
#            curl -kv --pubkey ~/.ssh/id_rsa.pub -T /data/wwwroot/${TAR}.tar.gz sftp://root@222.240.0.29/backup/online/ &>/dev/null
#            if [[ $? -eq 0 ]]; then
#                echo -e "${PINK}upload backup file of $TAR successfully ...... ${PLAIN}"
#            else
#                echo -e "${PINK}upload backup file of $TAR failure ...... ${PLAIN}"
#            fi
#        fi

    fi

else
    cd /webData
    echo 'tar the project directory and the sql file to package please hold a minutes ........'
    tar zcf $TAR $1
    mv $TAR /backup/local/
    echo "tar $TAR of $1 successfully" >> /webData/aslog/`date "+%Y%m%d"`/$1.log
    sleep 5
    #进入ERP项目目录
    if [[ ! -e /webData/$1 ]];then
        echo "the project directory is not exists in this server, now init the project........."
        git clone git@codehub-cn-south-1.devcloud.huaweicloud.com:ERP00003/ERP.git $1
        sleep 5
    fi
    #进入项目目录并更新项目
    cd /webData/$1
    echo "enter the directory `pwd`";
    if [[ $2 -eq 0 ]]; then
        echo "It's being ready to git pull from origin develop branch to local..........." >> /webData/aslog/`date "+%Y%m%d"`/$1.log
        echo "It's being ready to git pull from origin develop branch to local..........."
        git pull origin develop  --force
    fi

    if [[ $? -eq 0 ]];then
        echo "git logs ten nubers nearby below" >> /webData/aslog/`date "+%Y%m%d"`/$1.log
        git log --oneline | head -10 >> /webData/aslog/`date "+%Y%m%d"`/$1.log
        echo "It's Being ready to copy backend web project to folder /webData/$1" >> /webData/aslog/`date "+%Y%m%d"`/$1.log
        chown -R apache:apache /webData/$1
        ls -lha /webData/$1 >> /webData/aslog/`date "+%Y%m%d"`/$1.log
        sleep 3
    fi
fi