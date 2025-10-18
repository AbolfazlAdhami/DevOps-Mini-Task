#!/bin/bash

# Log file
LOGFILE="connectivity_log.txt"

echo "===== Connectivity Checker ====="
echo "Enter domains or IPs to check connection: "
read -a targets

echo "---- Checking connectivity ----" | tee -a "$LOGFILE"
date | tee -a "$LOGFILE"

for target in "${targets[@]}"; do
    echo "Pinging $target..."
    
    # Ping 4 times and get the average latency
    ping_output=$(ping -c 4 "$target" 2>&1)
    if [[ $? -eq 0 ]]; then
        avg_latency=$(echo "$ping_output" | grep 'avg' | awk -F'/' '{print $5}')
        echo "[SUCCESS] $target reachable, avg latency: ${avg_latency} ms" | tee -a "$LOGFILE"
    else
        echo "[FAILED] $target unreachable" | tee -a "$LOGFILE"
    fi
    echo "--------------------------------------" | tee -a "$LOGFILE"
done

echo "Results saved to $LOGFILE"
