#!/bin/sh

if [ $# -ne 2 ]; then
echo "You must input Mysql Root Password And OS type(CentOS | Ubuntu)."
echo "ex) ./uninstall_filter.sh rpdlaqlf Ubuntu"
exit
fi

# install package for rsync, expect
case $2 in
"CentOS")
#yum install -y rsync
#yum install -y expect
#yum install -y cronie
#/etc/init.d/crond restart
echo "this machine is CentOS"
;;
"Ubuntu")
#apt-get install -y rsync
#apt-get install -y expect
echo "this machine is Ubuntu"
;;
*)
echo "Error input parameter must input CentOS or Ubuntu."
;;
esac

PW=$1
ERR_FILE_FULL_PATH=`mysql -uroot -p${PW} --max_allowed_packet=16M -N -e"show variables like 'log_error'" | grep error | awk '{print $2}'`
ERR_FILE_NAME=`ls ${ERR_FILE_FULL_PATH} | xargs -l basename`
echo "error_log_file is ${ERR_FILE_FULL_PATH}"
rm -rf ${ERR_FILE_FULL_PATH}_tmp
rm /data/audit/error_file_name

mysql -uroot -p${PW} --max_allowed_packet=16M -e"set global log_warnings = 1;"

#remove script to /root
rm -rf /root/filter.sh 

# remove crontab 
rm -rf /etc/cron.d/filter_croned

echo "======== gm connect logging removed. ======"

