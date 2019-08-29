#!/bin/bash
# This shell is to update web project auto
#
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# create : 2018-09-04
# Update : 2019-08-29
PATH=/bin:/sbin:/usr/bin:/user/sbin
export PATH
PINK="\033[1;35;25m"
PLAIN="\033[0m"
#判断用户输入的第一个参数
case $1 in
    www.homemoji.com)
        if [[ ! -e /data/wwwroot/$1 ]]; then
            echo "your enter the directory $1 is not exists,please check it out"
            exit
        fi
   ;;
#    erp.io)
#        if [[ ! -e /webData/$1 ]]; then
#            echo "your enter the directory $1 is not exists,please check it out"
#            exit
#        fi
#   ;;
    *)
        echo 'your enter the directory is not correct!!'
        exit
    ;;
esac
#判断用户输入的第二个参数
case $2 in
[0-1])
    [[ $2 -eq 0 ]] && TAR=shop-test-`date "+%Y-%m-%d"`.tar.gz || TAR=shop-`date "+%Y-%m-%d"`.tar.gz
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
if [[ -e /data ]] && [[ ! -e /data/aslog/`date "+%Y%m%d"` ]]  && [[ $2 -eq 1 ]] ;then
    case $1 in
    www.homemoji.com)
    mkdir -p /data/aslog/`date "+%Y%m%d"`
    ;;
    esac
fi

#if [[ -e /webData ]]  && [[ ! -e /webData/aslog/`date "+%Y%m%d"` ]] &&  [[ $2 -eq 0 ]] ;then
# case $1 in
#    erp.io)
#    mkdir -p /webData/aslog/`date "+%Y%m%d"`
#    ;;
#    esac
#fi

#判断当前项目目录是否存在
if [[ -e /data ]] &&  [[ ! -e /data/wwwroot/$1 ]] && [[ $2 -eq 1 ]]; then
    case $1 in
    www.homemoji.com)
    mkdir -p /data/wwwroot/$1
    ;;
    esac
fi

#if [[ -e /webData ]] &&  [[ ! -e /webData/$1 ]] && [[ $2 -eq 0 ]]; then
#    case $1 in
#    erp.io)
#    mkdir -p /webData/$1
#    ;;
#    esac
#fi

if [[ -e /data/wwwroot ]] && [[ $2 -eq 1 ]]; then
    case $1 in
    www.homemoji.com)
    cd /data/wwwroot/
    echo 'tar the project directory and the sql file to package please hold a minutes ........'
    tar zcf ${TAR} homemoji_vn1
    echo "tar $TAR of $1 successfully" >> /data/aslog/`date "+%Y%m%d"`/$1.log
    sleep 5
    #进入ERP项目目录
    if [[ ! -e /data/wwwroot/homemoji_vn1 ]];then
        echo "the project directory is not exists in this server, now init the project........."
        git clone git@codehub-cn-south-1.devcloud.huaweicloud.com:homemoji_vn100001/homemoji_vn1.git
        sleep 15
    fi
    #进入项目目录并更新项目
    cd /data/wwwroot/homemoji_vn1
    echo "enter the directory `pwd`";

    echo "It's being ready to git clone from origin master branch to local..........." >> /data/aslog/`date "+%Y%m%d"`/$1.log
    echo "It's being ready to git clone from origin master branch to local..........."
    git pull origin master --force

    if [[ $? -eq 0 ]];then
        echo "git logs ten nubers nearby below" >> /data/aslog/`date "+%Y%m%d"`/$1.log
        git log --oneline | head -10 >> /data/aslog/`date "+%Y%m%d"`/$1.log
        echo "It's Being ready to copy backend web project to folder /data/wwwroot/$1" >> /data/aslog/`date "+%Y%m%d"`/$1.log
        chown -R www:www /data/wwwroot/homemoji_vn1
        ls -lha /data/wwwroot/homemoji_vn1 >> /data/aslog/`date "+%Y%m%d"`/$1.log
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
    ;;
    esac

elif [[ -e /data/wwwroot/$1 ]] && [[ $2 -eq 0 ]]; then
    case $1 in
    www.homemoji.com.cn)
    cd /data/wwwroot
    echo 'tar the project directory and the sql file to package please hold a minutes ........'
    tar zcf ${TAR} homemoji_vn1_test
    echo "tar ${TAR} of $1 successfully" >> /data/aslog/`date "+%Y%m%d"`/$1.log
    sleep 5
    #进入ERP项目目录
    if [[ ! -e /data/wwwroot/homemoji_vn1_test ]];then
        echo "the project directory is not exists in this server, now init the project........."
        git clone git@codehub-cn-south-1.devcloud.huaweicloud.com:ERP00003/ERP.git homemoji_vn1_test
        sleep 5
    fi
    #进入项目目录并更新项目
    cd /data/wwwroot/homemoji_vn1_test
    echo "enter the directory `pwd`";
    if [[ $2 -eq 0 ]]; then
        echo "It's being ready to git pull from origin develop branch to local..........." >> /data/aslog/`date "+%Y%m%d"`/$1.log
        echo "It's being ready to git pull from origin develop branch to local..........."
        git pull origin develop  --force
    fi

    if [[ $? -eq 0 ]];then
        echo "git logs ten nubers nearby below" >> /data/aslog/`date "+%Y%m%d"`/$1.log
        git log --oneline | head -10 >> /data/aslog/`date "+%Y%m%d"`/$1.log
        echo "It's Being ready to copy backend web project to folder /webData/$1" >> /data/aslog/`date "+%Y%m%d"`/$1.log
        chown -R www:www /data/wwwroot/homemoji_vn1
        ls -lha /data/wwwroot/homemoji_vn1 >> /data/aslog/`date "+%Y%m%d"`/$1.log
        sleep 3
    fi

     if [[ ! $2 -eq 0 ]]; then
        sed -i "s/offcialConnect:true/offcialConnect:false/g" /data/wwwroot/homemoji_vn1/pc/static/js/global.js
        sed -i "s/offcialConnect:true/offcialConnect:false/g" /data/wwwroot/homemoji_vn1/mobile/static/js/style.js
    fi
    ;;
    esac
fi