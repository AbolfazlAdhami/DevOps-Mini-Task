#!/bin/bash

# Countdown Timer Script
# Accepts a number and counts down to zero

if [ -z "$1" ]; then
    echo "Usage: $0 <seconds>"
    exit 1
fi

time=$1

# Validate input (must be a number)
if ! [[ "$time" =~ ^[0-9]+$ ]]; then
    echo "Error: Please enter a valid number."
    exit 1
fi

# Countdown loop
while [ $time -gt 0 ]
do
    echo "Time left: $time"
    sleep 1
    ((time--))
done

echo "Time's up!"
