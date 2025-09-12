#!/bin/bash

LOG_DIR="$PWD/logs" 
ERROR_PATTERNS=('ERROR' 'FATAL' 'CRITICAL')
echo "analysing log file"
echo "================================"
echo $LOG_DIR
echo -e "\nList of log files updated from 1st July to now"
LOG_FILES=$(find $LOG_DIR  -name "*.log" -newermt "2025-06-01" ! -newermt "now" )

echo $LOG_FILES

for LOG_FILE in $LOG_FILES; do
    echo -e "Serach Error in $LOG_FILE :"
    for PATTERN in ${ERROR_PATTERNS[@]}; do
        echo -e "\nsearching ${PATTERN} logs in $LOG_FILE"
        grep    "${PATTERN}" $LOG_FILE

        echo -e "\nNumber of ${PATTERN} logs in $LOG_FILE"
        grep -c "${PATTERN}" $LOG_FILE
    done
done