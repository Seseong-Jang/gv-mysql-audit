#!/bin/sh

if [ $# -ne 2 ]; then
echo "You must input Mysql Root Password And OS type(CentOS | Ubuntu)."
echo "ex) ./setup_filter.sh rpdlaqlf Ubuntu"
exit
fi

# install package for rsync, expect
case $2 in
"CentOS")
yum install -y rsync
yum install -y expect
yum install -y cronie
/etc/init.d/crond restart
;;
"Ubuntu")
apt-get install -y rsync
apt-get install -y expect
;;
*)
echo "Error input parameter must input CentOS or Ubuntu."
;;
esac

PW=$1
ERR_FILE_FULL_PATH=`mysql -uroot -p${PW} --max_allowed_packet=16M -N -e"show variables like 'log_error'" | grep error | awk '{print $2}'`
ERR_FILE_NAME=`ls ${ERR_FILE_FULL_PATH} | xargs -l basename`
echo "error_log_file is ${ERR_FILE_FULL_PATH}"
mkdir -p /data/audit/
touch ${ERR_FILE_FULL_PATH}_tmp
echo ${ERR_FILE_FULL_PATH}_tmp
ls ${ERR_FILE_FULL_PATH} > /data/audit/error_file_name

mysql -uroot -p${PW} --max_allowed_packet=16M -e"set global log_warnings = 2;"

# copy script to /root
cp filter.sh /root

echo "======== gm connect logging installed. =========="
echo "======== log is /data/audit/filter.log ========"
echo "======== info /data/audit/error_file_name ====="
echo "======== shell is /root/filter.sh =========="


# crontab install
cp -f filter_croned /etc/cron.d/
echo "======== crontab installed audit_loggin filter =========="

