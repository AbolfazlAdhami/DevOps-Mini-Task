#!/bin/bash

LOG_DIR="/home/*/logs" # wildcard for srarch all dir 
ERROR_PARTTERNS=('ERROR' 'FATAL' 'CRITICAL')

echo "analysing log file"
echo "================================"

echo -e "\nList of log files updated in last 24 hours"
LOG_FILES=$(find $LOG_DIR -name "*.log" -mtime -1)
echo $LOG_FILES

for LOG_FILE in $LOG_FILES; do
echo -e "\nsearching ${ERROR_PARTTERNS[0]} logs in $LOG_FILE"
grep    "${ERROR_PARTTERNS[0]}" $LOG_FILE

echo -e "\nNumber of ${ERROR_PARTTERNS[0]} logs in $LOG_FILE"
grep -c "${ERROR_PARTTERNS[0]}" $LOG_FILE

echo -e "\nNumber of ${ERROR_PARTTERNS[1]} logs in $LOG_FILE"
grep -c "${ERROR_PARTTERNS[1]}" $LOG_FILE

echo -e "\nNumber of  ${ERROR_PARTTERNS[2]} logs in $LOG_FILE"
grep -c "${ERROR_PARTTERNS[2]}" $LOG_FILE
done