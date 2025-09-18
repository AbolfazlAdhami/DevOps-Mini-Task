#!/bin/bash
# Log Analysis and Reporting Script
# Description:
#   This script analyzes a given log file and produces a summary report
#   including total log entries, counts per log level, frequent IPs, 
#   and failed login attempts (for auth.log).
# Usage:
# chmod +x log_analysis.sh
# ./log_analysis.sh /var/log/syslog
# ./log_analysis.sh /var/log/auth.log

# -------------------------
# Functions
# -------------------------

# Function: Print error and exit
error_exit() {
    echo "Error: $1"
    exit 1
}

# Function: Validate input file
validate_file() {
    if [[ -z "$1" ]]; then
        error_exit "No log file provided. Usage: $0 <logfile>"
    elif [[ ! -f "$1" ]]; then
        error_exit "File '$1' does not exist or is not a regular file."
    elif [[ ! -r "$1" ]]; then
        error_exit "File '$1' is not readable."
    fi
}

# Function: Count log entries
count_entries() {
    wc -l < "$1"
}

# Function: Count log levels (INFO, WARNING, ERROR)
count_log_levels() {
    local file="$1"
    local info_count warning_count error_count

    info_count=$(grep -c -i "INFO" "$file")
    warning_count=$(grep -c -i "WARNING" "$file")
    error_count=$(grep -c -i "ERROR" "$file")

    echo "INFO: $info_count"
    echo "WARNING: $warning_count"
    echo "ERROR: $error_count"
}

# Function: Top 5 most frequent IP addresses
top_ips() {
    local file="$1"
    echo "Top 5 IP addresses:"
    grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "$file" \
        | sort \
        | uniq -c \
        | sort -nr \
        | head -5
}

# Function: Count failed login attempts (only for auth.log)
failed_logins() {
    local file="$1"
    local count
    count=$(grep -c "Failed password" "$file")
    echo "Failed login attempts: $count"
}

# -------------------------
# Main Script
# -------------------------

LOG_FILE="$1"
# Validate file
validate_file "$LOG_FILE"
# Generate timestamp for report
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORT_FILE="log_summary_${TIMESTAMP}.txt"
{
    echo "Log Summary Report"
    echo "=================="
    echo "Log File: $LOG_FILE"
    echo "Generated: $(date)"
    echo

    echo "Total log entries: $(count_entries "$LOG_FILE")"
    echo
    echo "Log Levels:"
    count_log_levels "$LOG_FILE"
    echo

    top_ips "$LOG_FILE"
    echo

    # Only check failed logins if file looks like auth.log
    if [[ "$LOG_FILE" == *"auth.log"* ]]; then
        failed_logins "$LOG_FILE"
    fi
} > "$REPORT_FILE"

echo "Report generated: $REPORT_FILE"
