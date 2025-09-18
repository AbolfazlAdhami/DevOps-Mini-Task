#!/bin/bash

# Navigate to /tmp
cd /tmp

# Create the directory 
mkdir $1 

# Move into the directory
cd $1

# Create a file named by users
touch $2

# List files with detailed information
ls -l