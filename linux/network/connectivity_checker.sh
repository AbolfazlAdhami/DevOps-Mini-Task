#!/bin/bash
# connectivity_checker.sh

LOGFILE="connectivity.log"
TARGETS=("8.8.8.8" "1.1.1.1" "google.com" "yahoo.com")

echo "=== Connectivity Check $(date) ===" >> $LOGFILE

for target in "${TARGETS[@]}"; do
    echo "Pinging $target..."
    PING_RESULT=$(ping -c 4 $target 2>&1)

    if [[ $? -eq 0 ]]; then
        AVG_LATENCY=$(echo "$PING_RESULT" | tail -1 | awk -F '/' '{print $5}')
        echo "SUCCESS: $target reachable, Avg Latency = ${AVG_LATENCY} ms" | tee -a $LOGFILE
    else
        echo "FAILURE: $target unreachable" | tee -a $LOGFILE
    fi
done
