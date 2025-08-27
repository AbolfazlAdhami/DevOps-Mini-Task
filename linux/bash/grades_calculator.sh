#!/bin/bash

# Student Grades Management + Simple Calculator (Bash version)



# --- Part 1: Student Grades Management ---
declare A students
grades=()

for i in {1..3}; do
        read -p "Enter the name of student $i:" name
        read  -p "Ender the grade of $name" grade
        student["$name"]=$grades
        grades+=($grade)
done


# Calculate average
sum=0
for g in "${grades[@]}"; do
        sum=$(echo "$sum + $g"| bc)
done
average=$(echo "scale=2; $sum / ${#grades[@]}" | bc)


echo -e "\n--- Student Report ---"
for name in "${!students[@]}"; do 
        grades=${students["$name"]}