#!/bin/bash

LOG_FILE="${1}"

if [[ ! -e "${LOG_FILE}" ]]
then
echo "Could not open ${LOG_FILE}" >&2
exit 1
fi

cut -d '"' -f 2 ${LOG_FILE} | cut -d ' ' -f 2 | sort | uniq -c | sort -n
