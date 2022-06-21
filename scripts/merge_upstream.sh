#!/bin/bash

PATH_DEVOPS=$HOME/90DaysOfDevOps # If this doesn't match yours then adapt the variable

if [ -d "$PATH_DEVOPS" ] 
then
    echo "Directory 90DaysOfDevOps exists." 
    echo "Starting to fetch upstream"

    cd $PATH_DEVOPS

    git fetch upstream
    sleep 3
    echo -ne '#####                     (33%)\r'
    sleep 1
    git merge upstream/main
    echo -ne '#############             (66%)\r'
    sleep 1
    git push origin main
    echo -ne '#######################   (100%)\r'
    echo -ne '\n'

else
    echo "Error: Directory /path/to/dir does not exists."
fi

