#!/usr/bin/env bash
# This shell is to clear file after expire auto
#
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# create : 2019-08-30
# Update : 2019-08-30
PATH=/bin:/sbin:/usr/bin:/user/sbin
export PATH
PINK="\033[1;35;25m"
PLAIN="\033[0m"
#判断用户输入的第一个参数
case $1 in
    mysql)
        case $2 in
            0)
                if [[ ! -e /backup/local/mysql ]]; then
                    echo -e "${PINK}your enter the directory [/backup/local/$1] is not exists,please check it out${PLAIN}"
                    exit
                fi
            ;;
            1)
                if [[ ! -e /backup/online/mysql ]]; then
                    echo -e "${PINK}your enter the directory [/backup/online/$1] is not exists,please check it out${PLAIN}"
                    exit
                fi
            ;;
        esac
   ;;
   web)
        case $2 in
            0)
                if [[ ! -e /backup/local/website ]]; then
                    echo -e "${PINK}your enter the directory [/backup/local/$1] is not exists,please check it out${PLAIN}"
                    exit
                fi
            ;;
            1)
                if [[ ! -e /backup/online/website ]]; then
                    echo -e "${PINK}your enter the directory [/backup/online/$1] is not exists,please check it out${PLAIN}"
                    exit
                fi
            ;;
        esac
   ;;
    *)
        echo -e "${PINK}your enter the directory is not correct!!${PLAIN}"
        exit
    ;;
esac

#删除7天之前的备份文件
if [[ $1 -eq mysql ]] && [[ $2 -eq 0 ]]; then
    find /backup/local/mysql -name "*.sql" -type f -mtime +7 -exec rm -rf {} \; > /dev/null 2>&1
elif [[ $1 -eq mysql ]] && [[ $2 -eq 1 ]]; then
    find /backup/online/mysql -name "*.sql" -type f -mtime +7 -exec rm -rf {} \; > /dev/null 2>&1
elif [[ $1 -eq web ]] && [[ $2 -eq 0 ]]; then
    find /backup/local/website -name "*.tar.gz" -type f -mtime +2 -exec rm -rf {} \; > /dev/null 2>&1
elif [[ $1 -eq web ]] && [[ $2 -eq 1 ]]; then
    find /backup/online/website -name "*.tar.gz" -type f -mtime +2 -exec rm -rf {} \; > /dev/null 2>&1
fi
