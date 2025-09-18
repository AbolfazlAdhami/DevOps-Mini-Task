#!/bin/bash

# Ask for two numbers
read -p "Enter the first number: " num1
read -p "Enter the second number: " num2

# Ask for operation
read -p "Enter an operation (+, -, *, %): " op

# Perform calculation
case $op in
    +)
        result=$((num1 + num2))
        echo "Result: $num1 + $num2 = $result"
        ;;
    -)
        result=$((num1 - num2))
        echo "Result: $num1 - $num2 = $result"
        ;;
    \*)
        result=$((num1 * num2))
        echo "Result: $num1 * $num2 = $result"
        ;;
    %)
        if [ "$num2" -ne 0 ]; then
            result=$((num1 % num2))
            echo "Result: $num1 % $num2 = $result"
        else
            echo "Error: Cannot perform modulo by zero!"
        fi
        ;;
    *)
        echo "Error: Invalid operation! Please use +, -, * or %."
        ;;
esac
