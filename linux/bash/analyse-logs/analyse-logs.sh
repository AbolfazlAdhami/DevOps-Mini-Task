#!/bin/bash

LOG_DIR="$PWD/logs" 
ERROR_PATTERNS=('ERROR' 'FATAL' 'CRITICAL')
#REPORT_FILE="/home/abolfazl/logs/log_analysis_report.txt"
REPORT_FILE="$PWD/logs/log_analysis_report.txt"


echo "analysing log file" > "$REPORT_FILE"
echo "================================" >> "$REPORT_FILE"
echo $LOG_DIR
echo -e "\nList of log files updated from 1st July to now" >> "$REPORT_FILE"
LOG_FILES=$(find $LOG_DIR  -name "*.log" -newermt "2025-06-01" ! -newermt "now" )

echo $LOG_FILES >> "$REPORT_FILE"

for LOG_FILE in $LOG_FILES; do
    echo -e "Serach Error in $LOG_FILE :" >> "$REPORT_FILE"
    for PATTERN in ${ERROR_PATTERNS[@]}; do
        echo -e "\nSearching ${PATTERN} logs in $LOG_FILE" >> "$REPORT_FILE"
        grep    "${PATTERN}" $LOG_FILE >> "$REPORT_FILE"

        echo -e "\nNumber of ${PATTERN} logs found in $LOG_FILE" >> "$REPORT_FILE"
        grep -c "${PATTERN}" $LOG_FILE >> "$REPORT_FILE"

        ERROR_COUNT=$(grep -c "$PATTERN" "$LOG_FILE")
        echo "Total Error Count: $ERROR_COUNT" >> "$REPORT_FILE"
        if [ "$ERROR_COUNT" -gt 10 ]; then
            echo " Action Required: too many $PATTERN issues in log file $LOG_FILE" >> $REPORT_FILE
        fi 
    done
done


echo -e "\nLog Analysis completed and report saved in $REPORT_FILE"