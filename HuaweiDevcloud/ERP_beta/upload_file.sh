#!/bin/bash
# This shell is to upload backup files to BackupServer
#
# Author: yulinzhihou
# Email : yulinzhihou@gmail.com
# create : 2019-08-21
#存放备份数据库的目录
PINK="\033[1;35;25m"
PLAIN="\033[0m"
DIR=$1
#备份文件后缀时间
TIME=`date +%Y%m%d%H%M%S`
#需要备份的数据库名称
FILE_NAME=$2
#判断用户输入的第一个参数

#删除7天之前的备份文件
find $1 -name ${FILE_NAME} -type f -mtime +7 -exec rm -rf {} \; > /dev/null 2>&1
#传送到专用备份服务器
curl -kv --pubkey ~/.ssh/id_rsa.pub -T ${DIR}/${FILE_NAME} sftp://root@222.240.0.29/backup/online/ &>/dev/null
if [[ $? -eq 0 ]]; then
    echo -e "${PINK}upload backup file of $FILE_NAME successfully ...... ${PLAIN}"
else
    echo -e "${PINK}upload backup file of $FILE_NAME failure ...... ${PLAIN}"
fi