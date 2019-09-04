#!/usr/bin/env bash
# This shell is to auto backup website to file
#
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# create : 2019-08-30
# Update : 2019-08-30
PATH=/bin:/sbin:/usr/bin:/user/sbin
export PATH
PINK="\033[1;35;25m"
PLAIN="\033[0m"

##判断用户输入的第一个参数
#case $1 in
#    erp)
#        case $2 in
#            0)
#                if [[ ! -e /backup/local/mysql ]]; then
#                    echo -e "${PINK}your enter the directory [/backup/local/$1] is not exists,please check it out${PLAIN}"
#                    exit
#                fi
#            ;;
#            1)
#                if [[ ! -e /backup/online/mysql ]]; then
#                    echo -e "${PINK}your enter the directory [/backup/online/$1] is not exists,please check it out${PLAIN}"
#                    exit
#                fi
#            ;;
#        esac
#   ;;
#   www)
#        case $2 in
#            0)
#                if [[ ! -e /backup/local/website ]]; then
#                    echo -e "${PINK}your enter the directory [/backup/local/$1] is not exists,please check it out${PLAIN}"
#                    exit
#                fi
#            ;;
#            1)
#                if [[ ! -e /backup/online/website ]]; then
#                    echo -e "${PINK}your enter the directory [/backup/online/$1] is not exists,please check it out${PLAIN}"
#                    exit
#                fi
#            ;;
#        esac
#   ;;
#    *)
#        echo -e "${PINK}your enter the directory is not correct!!${PLAIN}"
#        exit
#    ;;
#esac
#判断用户输入的第二个参数
case $2 in
    [0-1])
        [[ $2 -eq 0 ]] && TAR=$1-test-`date "+%Y-%m-%d"`.tar.gz || TAR=$1-`date "+%Y-%m-%d"`.tar.gz
    ;;
esac

if [[ $1 -eq erp ]] && [[ $2 -eq 1 ]]; then
    cd /data/wwwroot/
    echo 'tar the project directory and the sql file to package please hold a minutes ........'
    tar zcf ${TAR} erp.homemoji.com
    echo "tar $TAR of $1 successfully" >> /data/aslog/`date "+%Y%m%d"`/$1.log
    sleep 5
   #传送到专用备份服务器 注：由于备份文件过大，导致会长期占用带宽。所以部署项目的时候不进行上传操作
    if [[ $HOSTNAME -eq 'WebServer1-6264' ]]; then
        curl -kv --pubkey ~/.ssh/id_rsa.pub -T /data/wwwroot/${TAR} sftp://root@222.240.0.29/backup/online/website/ &>/dev/null
        if [[ $? -eq 0 ]]; then
            echo -e "${PINK}upload backup file of $TAR successfully ...... ${PLAIN}"
            rm -rf ${TAR}
        else
            echo -e "${PINK}upload backup file of $TAR failure ...... ${PLAIN}"
        fi
    fi
elif [[ $1 -eq www || $1 -eq h5 ]] && [[ $2 -eq 1 ]]; then
    cd /data/wwwroot/
    echo 'tar the project directory and the sql file to package please hold a minutes ........'
    tar zcf ${TAR} homemoji_vn1
    echo "tar $TAR of $1 successfully" >> /data/aslog/`date "+%Y%m%d"`/$1.log
    sleep 5
    #传送到专用备份服务器 注：由于备份文件过大，导致会长期占用带宽。所以部署项目的时候不进行上传操作
    if [[ $HOSTNAME -eq 'WebServer1-6264' ]]; then
        curl -kv --pubkey ~/.ssh/id_rsa.pub -T /data/wwwroot/${TAR} sftp://root@222.240.0.29/backup/online/website/ &>/dev/null
        if [[ $? -eq 0 ]]; then
            echo -e "${PINK}upload backup file of $TAR successfully ...... ${PLAIN}"
            rm -rf ${TAR}
        else
            echo -e "${PINK}upload backup file of $TAR failure ...... ${PLAIN}"
        fi
    fi
elif [[ $1 -eq api ]] && [[ $2 -eq 1 ]]; then
    cd /data/wwwroot/
    echo 'tar the project directory and the sql file to package please hold a minutes ........'
    tar zcf ${TAR} api.homemoji.com
    echo "tar $TAR of $1 successfully" >> /data/aslog/`date "+%Y%m%d"`/$1.log
    sleep 5
    #传送到专用备份服务器 注：由于备份文件过大，导致会长期占用带宽。所以部署项目的时候不进行上传操作
    if [[ $HOSTNAME -eq 'WebServer1-6264' ]]; then
        curl -kv --pubkey ~/.ssh/id_rsa.pub -T /data/wwwroot/${TAR} sftp://root@222.240.0.29/backup/online/website/ &>/dev/null
        if [[ $? -eq 0 ]]; then
            echo -e "${PINK}upload backup file of $TAR successfully ...... ${PLAIN}"
            rm -rf ${TAR}
        else
            echo -e "${PINK}upload backup file of $TAR failure ...... ${PLAIN}"
        fi
    fi
elif [[ $1 -eq cn ]] && [[ $2 -eq 1 ]]; then
    cd /data/wwwroot/
    echo 'tar the project directory and the sql file to package please hold a minutes ........'
    tar zcf ${TAR} www.homemoji.cn
    echo "tar $TAR of $1 successfully" >> /data/aslog/`date "+%Y%m%d"`/$1.log
    sleep 5
    #传送到专用备份服务器 注：由于备份文件过大，导致会长期占用带宽。所以部署项目的时候不进行上传操作
    if [[ $HOSTNAME -eq 'WebServer1-6264' ]]; then
        curl -kv --pubkey ~/.ssh/id_rsa.pub -T /data/wwwroot/${TAR} sftp://root@222.240.0.29/backup/online/website/ &>/dev/null
        if [[ $? -eq 0 ]]; then
            echo -e "${PINK}upload backup file of $TAR successfully ...... ${PLAIN}"
            rm -rf ${TAR}
        else
            echo -e "${PINK}upload backup file of $TAR failure ...... ${PLAIN}"
        fi
    fi
fi
