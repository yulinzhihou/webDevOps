#!/bin/bash
# This shell is to update web project auto
# 
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# Update  : 2018-10-16
PATH=/bin:/sbin:/usr/bin:/user/sbin
export PATH
PINK="\033[1;35;25m"
PLAIN="\033[0m"
#判断用户输入的第一个参数
case $1 in
    homemoji.com)
        if [ ! -e /data/$1 ]; then
            echo "your enter the directory $1 is not exists,please check it out"
            exit
        fi
   ;;
   homemoji.com.cn)
        if [ ! -e /data/$1 ]; then
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
    [ $2 -eq 0 ] && TAR=h5-test-`date "+%Y-%m-%d"`.tar.gz || TAR=h5-`date "+%Y-%m-%d"`.tar.gz
    [ $2 -eq 0 ] && TAR1=pc-test-`date "+%Y-%m-%d"`.tar.gz || TAR1=pc-`date "+%Y-%m-%d"`.tar.gz
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

if [  ! -e /data/AutoShellLog/`date "+%Y-%m-%d"` ]
then
mkdir -p /data/AutoShellLog/`date "+%Y-%m-%d"`
fi

cd /data
tar zcf /data/$TAR m.$1
echo "m.$1 is tar to $TAR succeefully" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/m.$1.log
echo "m.$1 is tar to $TAR succeefully........"
sleep 3
tar zcf /data/$TAR1 $1
echo "$1 is tar to $TAR1 succeefully" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
echo "$1 is tar to $TAR1 succeefully........."
sleep 5

if [ ! -e /data/tp_mobile ]; then
    cd /data
    git clone git@gitee.com:homemoji/tp_mobile.git
fi
cd /data/tp_mobile
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
if [ $? -eq 0 ]
then
        echo "git logs five nubers nearby below\n" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
        git log --oneline | head -5 >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
        echo "It's Being ready to copy pc web project to folder /data/$1" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
        `\cp -rf pc/* /data/$1`
        if [ ! $2 -eq 0 ]; then
            sed -i "s/offcialConnect:false/offcialConnect:true/g" /data/$1/static/js/global.js
        fi
        chown -R apache:apache /data/$1
        #修改全局接口
        ls -lha /data/m.$1 >> /data/AutoShellLog/`date "+%Y-%m-%d"`/m.$1.log
        sleep 3
        echo "It's Being ready to copy mobile project to folder /data/m.$1\n" >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
        `\cp -rf mobile/* /data/m.$1`
         if [ ! $2 -eq 0 ]; then
            sed -i "s/offcialConnect:false/offcialConnect:true/g" /data/m.$1/static/js/style.js
        fi
        chown -R apache:apache /data/m.$1
        ls -lha /data/m.$1 >> /data/AutoShellLog/`date "+%Y-%m-%d"`/$1.log
fi
echo "the backup file of $TAR will uploads to server save .............."
curl -k -u root:qepyjfnfss1314. -T /data/$TAR sftp://47.98.105.236/root/homemoji-bak/
if [ $? -eq 0 ]; then
    echo "upload backup file of $TAR successfully ...... "
else
     echo "upload backup file of $TAR failure ...... "
fi

echo "the backup file of $TAR1 will uploads to server save .............."
curl -k -u root:qepyjfnfss1314. -T /data/$TAR1 sftp://47.98.105.236/root/homemoji-bak/
if [ $? -eq 0 ]; then
    echo "upload backup file of $TAR1 successfully ...... "
else
     echo "upload backup file of $TAR1 failure ...... "
fi
