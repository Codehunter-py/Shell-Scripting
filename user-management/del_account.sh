#!/bin/bash

# This script deletes, disables or archives users

readonly ARCHIVE_DIR='/archive'
usage() {
    echo "Usage: ${0} [-dra] USER [USERN]..." >&2
    echo 'Disable a local Linux account.' >&2
    echo '-d Deletes accounts.' >&2
    echo '-r Romves the home dir associated w/ the accounts.' >&2
    echo '-a Creates an archive of the home directory associated with accounts.' >&2
    
    exit 1
}

# run as root
if [[ "${UID}" -ne 0 ]]
then 
echo 'Please run with sudo or as root!' >&2
exit 1
fi

while getopts dra OPTION
do
  case ${OPTION} in
    d) DELETE_USER='true';;
    r) REMOVE_OPTION='-r';;
    a) ARCHIVE='true';;
    ?) usage ;;
  esac
done

if [[ "${#}" -lt 1 ]]
then
usage
fi

for USERNAME in "${@}"
do
 echo "Processing user: ${USERNAME}"

 USERID=$(id -u ${USERNAME})
 if [[ "${USERID}" -lt 1000 ]]
 then 
    echo "Refusing to remove the ${USERNAME}" >&2
    exit 1
 fi

if [[ "${ARCHIVE}" = 'true' ]]
then 
 if [[ ! -d "${ARCHIVE_DIR}" ]]
 then
    echo "Creating ${ARCHIVE_DIR} directory."
    mkdir -p ${ARCHIVE_DIR}
    if [[ "${?}" -ne 0 ]]
     then 
     echo "The archive directory could not be created." >&2
     exit 1
    fi
 fi

 HOME_DIR="/home/${USERNAME}"
 ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
 if [[ -d "${HOME_DIR}" ]]
 then 
  echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
  tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
  if [[ "${?}" -ne 0 ]]
  then
    echo "Cannot create ${ARCHIVE_FILE}" >&2
    exit 1
  fi
 else
  echo "${HOME_DIR} does not exist or is not a dir..." >&2
  exit 1
  fi
 fi

 if [[ "${DELETE_USER}" = 'true' ]] 
 then
 # Delete a user 
 userdel ${REMOVE_OPTION} ${USERNAME}
 # CHECK if it was successful
  if [[ "${?}" -ne 0 ]]
  then 
    echo "The account ${USERNAME} was not deleted" >&2
    exit 1
  fi
  echo "The accout ${USERNAME} was deleted."
 else
   chage -E 0 ${USERNAME}
 if [[ "${?}" -ne 0 ]]
 then 
   echo "The account ${USERNAME} was already deleted." >&2
   exit 1
 fi
 echo "The account ${USERNAME} was disabled."
 fi
done
exit 0