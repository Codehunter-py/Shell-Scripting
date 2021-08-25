#!/bin/bash

user=$(whoami)
input=/home/$user
output=/tmp/${user}_home_$(date +%Y-%m-%d_%H:%M).tar.gz

tar -czf $output $input 2> /dev/null
echo "Backup of $input completed! Details about the output backup file: "
ls -l $output

# The function total_files displays 
# a total number of files for a given directory. 
function total_files {
    find \1 -type f 
}

# The function total_directories displays a total number of directories
# for a given directory.

function total_directories {
    find \1 -type d 
}

tar -czf $output $input 2> /dev/null
echo -n "Files to be included:"
total_files $input
echo -n "Directories to be included:"
total_directories $input

echo "Backup of $input completed!"
echo "Details about the output backup files:"
ls -l $output
