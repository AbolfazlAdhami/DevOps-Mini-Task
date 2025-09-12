#!/bin/bash

: << END_COMMENT
Build a Simple Calculator
 Write a Python program that simulates a simple calculator. The program should: Ask the user to enter two numbers. Ask the user to enter an operation (+, -, *, %). Perform the operation on the two numbers and display the result. If the user enters an invalid operation, print an error message. in bash script
END_COMMENT

# Enable associative arrays (bash 4+)
declare -A students
declare -A evaluations

# Function to calculate average
calculate_average() {
    local sum=0
    local count=0
    for grade in "${students[@]}"; do
        ((sum+=grade))
        ((count++))
    done
    echo "scale=2; $sum / $count" | bc
}

# Input for 3 students
for i in {1..3}
do
    echo -n "Enter name of student $i: "
    read name
    echo -n "Enter grade of $name: "
    read grade

    students[$name]=$grade

    # Evaluation
    if [ $grade -ge 17 ]; then
        evaluations[$name]="Excellent"
    elif [ $grade -ge 12 ]; then
        evaluations[$name]="Good"
    else
        evaluations[$name]="Needs more effort"
    fi
done

# Display results
echo -e "\n--- Student Grades Report ---"
printf "%-15s %-10s %-20s\n" "Name" "Grade" "Evaluation"
echo "-----------------------------------------------------"

for name in "${!students[@]}"
do
    printf "%-15s %-10s %-20s\n" "$name" "${students[$name]}" "${evaluations[$name]}"
done

# Average
avg=$(calculate_average)
echo -e "\nAverage Grade: $avg"
