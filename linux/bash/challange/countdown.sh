#!/bin/bash
# Countdown Timer Script
if [ -z "$1" ]; then
  echo "Error: Input is incorrect Please input a positive integer number."
  exit 1
fi

# Validate input (must be a positive integer)
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
  echo "Error: Input must be a positive integer."
  exit 1
fi

count=$1

# Countdown loop
while [ $count -gt 0 ]; do
  echo $count
  sleep 1
  ((count--))
done

echo "Time's up!"
