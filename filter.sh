#!/bin/sh

ERR_FILE_NAME=`cat /data/audit/error_file_name`

cat ${ERR_FILE_NAME} |grep 'Access denied' >> /data/audit/filter.log

#because sed '/word/d' error.log > error.log is size 0byte

sed '/Access denied/d' ${ERR_FILE_NAME} > ${ERR_FILE_NAME}_tmp

cat ${ERR_FILE_NAME}_tmp > ${ERR_FILE_NAME}

