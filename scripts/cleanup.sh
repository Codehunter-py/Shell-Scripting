#!/bin/bash

PYCACHE=__pycache__
MY_HOME=/c/Users/Ibrahim/Desktop
SHOW_FINDING=`find . -type d -name "${PYCACHE}" 2>/dev/null`
TIMESTAMP=`date '+%F %T'`

for RESULT in "${SHOW_FINDING}"; do
	echo "#############################"
	echo "Result found: $RESULT"
	echo "#############################"
done

cd $MY_HOME

if [ -z "${SHOW_FINDING}" ]; then
	echo "${TIMESTAMP}  INFO  No ${PYCACHE} found."
	read
	exit 2 
else
	find . -type d -name "${PYCACHE}" -exec rm -rf {} +
	echo "${TIMESTAMP}  INFO  Cleanup is completed."
	read
	exit 0
fi
