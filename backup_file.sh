#!/bin/bash

log() {
  # This function sends a message to syslog and to standard output if VERBOSE is true.

  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
  logger -t backup_file.sh "${MESSAGE}"
}

# Function below creates a backup of a file. Returns non-zero status on error.
backup_file() {
    local FILE="${1}"
    if [[ -f "${FILE}" ]]
    then
      local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
      log "Backing up ${FILE} to ${BACKUP_FILE}"

      cp -p ${FILE} ${BACKUP_FILE}
    else

      return 1
    fi
}  

readonly VERBOSE='true'
backup_file '/etc/passwd'

# A decision based exit status of the function.
if [[ "${?}" -eq '0' ]]
then 
  log 'File backup succeeded!'
else
  log 'File backup failed!'
  exit 1
fi
