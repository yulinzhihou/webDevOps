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
    w2.homemoji.com.cn)
        if [[ ! -e /data/wwwroot/$1 ]]; then
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

#判断线上正式服日志目录
if [[ -e /data ]] && [[ ! -e /data/aslog/`date "+%Y%m%d"` ]]  && [[ $2 -eq 1 ]] ;then
    case $1 in
    www.homemoji.com)
    mkdir -p /data/aslog/`date "+%Y%m%d"`
    ;;
    esac
fi

#判断线上测试服日志目录
if [[ -e /data ]] && [[ ! -e /data/aslog/`date "+%Y%m%d"` ]]  && [[ $2 -eq 0 ]] ;then
    case $1 in
    w2.homemoji.com.cn)
    mkdir -p /data/aslog/`date "+%Y%m%d"`
    ;;
    esac
fi

#判断当前项目目录是否存在
if [[ -e /data ]] &&  [[ ! -e /data/wwwroot/$1 ]] && [[ $2 -eq 1 ]]; then
    case $1 in
    www.homemoji.com)
    mkdir -p /data/wwwroot/$1
    ;;
    esac
fi

#判断当前项目目录是否存在
if [[ -e /data ]] &&  [[ ! -e /data/wwwroot/$1 ]] && [[ $2 -eq 0 ]]; then
    case $1 in
    w2.homemoji.com.cn)
    mkdir -p /data/wwwroot/$1
    ;;
    esac
fi


if [[ -e /data/wwwroot ]] && [[ $2 -eq 1 ]]; then
    case $1 in
    www.homemoji.com)
    cd /data/wwwroot/
    echo 'tar the project directory and the sql file to package please hold a minutes ........'
    tar zcf ${TAR} homemoji_vn2
    echo "tar $TAR of $1 successfully" >> /data/aslog/`date "+%Y%m%d"`/$1.log
    sleep 5
    #进入ERP项目目录
    if [[ ! -e /data/wwwroot/homemoji_vn2 ]];then
        echo "the project directory is not exists in this server, now init the project........."
        git clone git@codehub-cn-south-1.devcloud.huaweicloud.com:homemoji_vn200001/homemoji_vn2.git
        sleep 15
    fi
    #进入项目目录并更新项目
    cd /data/wwwroot/homemoji_vn2
    echo "enter the directory `pwd`";

    echo "It's being ready to git clone from origin master branch to local..........." >> /data/aslog/`date "+%Y%m%d"`/$1.log
    echo "It's being ready to git clone from origin master branch to local..........."
    git pull origin master --force

    if [[ $? -eq 0 ]];then
        echo "git logs ten nubers nearby below" >> /data/aslog/`date "+%Y%m%d"`/$1.log
        git log --oneline | head -10 >> /data/aslog/`date "+%Y%m%d"`/$1.log
        echo "It's Being ready to copy backend web project to folder /data/wwwroot/$1" >> /data/aslog/`date "+%Y%m%d"`/$1.log
        chown -R www:www /data/wwwroot/homemoji_vn2
        ls -lha /data/wwwroot/homemoji_vn2 >> /data/aslog/`date "+%Y%m%d"`/$1.log
        sleep 3
    fi
    ;;
    esac
elif [[ -e /data/wwwroot ]] && [[ $2 -eq 0 ]]; then
    case $1 in
    w1.homemoji.com.cn)
    cd /data/wwwroot/
    echo 'tar the project directory and the sql file to package please hold a minutes ........'
    tar zcf ${TAR} homemoji_vn2_beta
    echo "tar $TAR of $1 successfully" >> /data/aslog/`date "+%Y%m%d"`/$1.log
    sleep 5
    #进入ERP项目目录
    if [[ ! -e /data/wwwroot/homemoji_vn2_beta ]];then
        echo "the project directory is not exists in this server, now init the project........."
        git clone git@codehub-cn-south-1.devcloud.huaweicloud.com:homemoji_vn200001/homemoji_vn2.git homemoji_vn2_beta
        sleep 15
    fi
    #进入项目目录并更新项目
    cd /data/wwwroot/homemoji_vn2_beta
    echo "enter the directory `pwd`";
    git checkout .
    echo "It's being ready to git clone from origin develop branch to local..........." >> /data/aslog/`date "+%Y%m%d"`/$1.log
    echo "It's being ready to git clone from origin develop branch to local..........."
    git pull origin develop --force

    if [[ $? -eq 0 ]];then
        echo "git logs ten nubers nearby below" >> /data/aslog/`date "+%Y%m%d"`/$1.log
        git log --oneline | head -10 >> /data/aslog/`date "+%Y%m%d"`/$1.log
        echo "It's Being ready to copy backend web project to folder /data/wwwroot/$1" >> /data/aslog/`date "+%Y%m%d"`/$1.log
        chown -R www:www /data/wwwroot/homemoji_vn2_beta
        ls -lha /data/wwwroot/homemoji_vn2_beta >> /data/aslog/`date "+%Y%m%d"`/$1.log
        sleep 3
    fi
    echo "It's being ready to modify js configuration file..........." >> /data/aslog/`date "+%Y%m%d"`/$1.log
    echo "It's being ready to modify js configuration file..........."
    sed -i "s/offcialConnect:true/offcialConnect:false/g" /data/wwwroot/homemoji_vn2_beta/moblie/static/js/style.js
    sed -i "s/offcialConnect:true/offcialConnect:false/g" /data/wwwroot/homemoji_vn2_beta/pc/static/js/global.js
    ;;
    esac
fi