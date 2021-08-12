#!/bin/bash

# This script demonstrates Input/Output redirection

# Redirect STDOUT to a file
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}

# Redirect Standard Input to a program
read LINE < ${FILE}
echo "LINE contains: ${FILE}"

# Redirect Standard Output to a file, overwriting the file.
head -c3 /etc/passwd > ${FILE}
echo
echo "Content of ${FILE}"
cat ${FILE}

# Redirect Standard Output to a file, appending to the file.
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo
echo "Contents of ${FILE}: "
cat ${FILE}

#################################

# Redirect Standart Input to a program, using File Descriptor 0
read LINE 0< ${FILE}
echo
echo "LINE contains: ${LINE}"

# Redirect Standart Output to a file using File Descriptor 1, overwriting the file
head -n3 /etc/passwd 1> ${FILE}
echo
echo "Contents of ${FILE}"
cat ${FILE}

# Redirect Standart Error to a file using FD 2 (File Descriptor).
ERR_FILE="/tmp/data.err"
head -n3 /etc/passwd /fakefile 2> ${ERR_FILE}

# Redirect Standart Out and Standart Error to a file.
head -n3 /etc/passwd /fakefile &> ${FILE}
echo
echo "Contents of ${FILE}"
cat ${FILE}

# Redirect Standart Output and Standart Error through a pipe 
echo
head -n3 /etc/passwd /fakefile |& cat -n

# Send output to Standart Error
echo "This is STDERR!" >&2

# Discard Standart Output
echo
echo "Discarding STDOUT:"
head -n3 /etc/passwd /fakefile > /dev/null

# Discard Standart Error
echo
echo "Discarding STDERR:"
head -n3 /etc/passwd /fakefile 2> /dev/null

# Discard STDOUT and STDERR
echo
echo "Discarding STDOUT and STDERR"
head -n3 /etc/passwd /fakefile &> /dev/null

# Clean up
rm ${FILE} ${ERR_FILE} &> /dev/null
