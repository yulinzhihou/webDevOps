#!/usr/bin/env bash
# This shell is to auto backup mysql database for web project
#
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# create : 2019-08-22
#存放备份数据库的目录
PINK="\033[1;35;25m"
PLAIN="\033[0m"
DIR=$1
#备份文件后缀时间
TIME=`date +%Y%m%d%H%M%S`
#需要备份的数据库名称
DB_NAME=$2
#判断用户输入的第一个参数
case $1 in
    '/data/backup/mysql')
        if [[ ! -e $1 ]]; then
            echo -e "${PINK}your enter the directory $1 is not exists,please check it out${PLAIN}"
            exit
        fi
   ;;
    *)
        echo -e "${PINK}your enter the directory is not correct!!${PLAIN}"
        exit
    ;;
esac
#/etc/my.cnf文件里面
# [mysqldump]项下面增加如下字段
#user=
#password=
#mysqldump命令使用绝对路径
#/usr/bin/mysqldump $DB_NAME | gzip > $DIR/$DB_NAME.sql.gz
/usr/local/mysql/bin/mysqldump ${DB_NAME} > ${DIR}/${DB_NAME}-${TIME}.sql
#删除7天之前的备份文件
find $1 -name ${DB_NAME}"*.sql" -type f -mtime +7 -exec rm -rf {} \; > /dev/null 2>&1
#传送到专用备份服务器
if [[ $HOSTNAME -eq 'DataMaster-48164' ]]; then
    curl -kv --pubkey ~/.ssh/id_rsa.pub -T ${DIR}/${DB_NAME}-${TIME}.sql sftp://root@222.240.0.29/backup/online/mysql/ &>/dev/null
    if [[ $? -eq 0 ]]; then
        echo -e "${PINK}upload backup file of $DB_NAME successfully ...... ${PLAIN}"
    else
        echo -e "${PINK}upload backup file of $DB_NAME failure ...... ${PLAIN}"
    fi
fi

