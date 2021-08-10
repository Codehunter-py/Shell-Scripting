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
