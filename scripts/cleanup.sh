#!/bin/bash

PYCACHE=__pycache__
MY_HOME=/c/Users/$USER
LIST_FINDINGS=`cd $MY_HOME && $find . -type d -name "${PYCACHE}" 2>/dev/null`
TIMESTAMP=`date '+%F %T'`

for RESULT in "${LIST_FINDINGS}"; do
	echo "#############################"
	echo "Result found: $RESULT"
	echo "#############################"
done

cd $MY_HOME

if [ -z "${LIST_FINDINGS}" ]; then
	echo "${TIMESTAMP}  INFO  No ${PYCACHE} found."
	read
	exit 2 
else
	find . -type d -name "${PYCACHE}" -exec rm -rf {} +
	echo "${TIMESTAMP}  INFO  Cleanup is completed."
	read
	exit 0
fi
