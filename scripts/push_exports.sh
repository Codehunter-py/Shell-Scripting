#!/bin/bash

################################################################################
# Name    : push_exports.sh                                                    #
# Author  : Ibrahim Musayev                                                    #
# Purpose : Automation of SFTP Gateway file transfers                          #
#                                                                              #
# History : 05.09.22 Ibrahim Musayev, creation                                 #
################################################################################

TIMESTAMP=`date +'%Y%m%d_%H%M%S'`
DATE=`date +'%y%m%d'`
YEAR=`date +'%Y'`
WEEK=`date -d 'last week' +'%U'`
LAST_MONDAY=`date -d 'last monday' +'%Y%m%d'`
LAST_SUNDAY=`date -d 'last sunday' +'%Y%m%d'`
DESTINATION=$Gateway
KEY=$PUBLIC_KEY
hostname=$(hostname -s)
FILENAME_1="${MASKED}_${LAST_MONDAY}__${LAST_SUNDAY}.zip"
FILENAME_2="${MASKED}_${LAST_MONDAY}__${LAST_SUNDAY}.zip"
FILENAME_3="${MASKED}_${LAST_MONDAY}__${LAST_SUNDAY}.zip"
OPT_ROOT="/opt/${DIR_1}/${YEAR}"
ZIP_SOURCE="${MASKED}.${WEEK}.${DATE}.zip"
LOGFILE=$C_LOG
DEBUG=false

if [[ ! -d $(dirname ${LOGFILE}) ]]; then
    mkdir -p $(dirname ${LOGFILE})
fi

FindAndPush () {
    cd $OPT_ROOT/w$WEEK
    FILELIST=`find . -type f \( -name "${FILENAME_1}" -o -name "${FILENAME_2}"  -o -name "${FILENAME_3}" \) 2>/dev/null`

    for FILE in $FILELIST; do
      if [ -s ${FILE} ]; then
        zip -qu ${ZIP_SOURCE} ${FILE}
        EXITCODE=$?
      else
        echo -e "${TIMESTAMP}  INFO   Zip file is empty. Waiting for the job to complete ${FILE}.\n" | tee -a ${LOGFILE}
      fi
    done

    echo "put ${ZIP_SOURCE}" |sftp -P 6323 -p -i /home/$USER/.ssh/${KEY} ${DESTINATION} >> ${LOGFILE}

    if [[ ${EXITCODE} -ne 0 ]]; then
      echo "`date +'%Y%m%d_%H%M%S'`  ERROR  Got exit code ${EXITCODE} during zipping. Exiting ..." | tee -a ${LOGFILE}
      exit 1
    else
      TIMESTAMP=`date +'%Y%m%d_%H%M%S'`
      echo -e "${TIMESTAMP}  INFO   File transfer to server ${DESTINATION} completed.\n" | tee -a ${LOGFILE}
      exit 0
    fi
}

FindAndPush
