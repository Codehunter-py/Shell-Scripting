#!/bin/bash

################################################################################
# Name    : check_file_delivery.sh                                             #
# Author  : Ibrahim Musayev                                                    #
# Purpose : To avoid single point of failure on condition                      #
#           when control-M is down or maintained.                              #
#           Time based job is running in CTM at 6 pm to alert in addition on   #
#           not started ETL run.                                               # 
# History : 05.10.21 Ibrahim Musayev, creation                                 #
################################################################################

TIMESTAMP=`date +'%Y%m%d_%H%M%S'`
FILEPREFIX="CC"
DATE=`date +'%y%m%d'`
EXITCODE=0
hostname=$(hostname -s)
LOGFILE=$HOME/masterdata_monitor.log


if [[ ${hostname:1:1} == "p" && ${hostname:7:3} == "a01" ]]; then
    FILEPREFIX="PBSI4C"
    FILENUMBER_MAX_MASTER=7
    FILENUMBER_MAX_CC=30
elif [[ ${hostname:1:1} == "i" && ${hostname:7:3} == "a02" ]]; then
    FILENUMBER_MAX_MASTER=7
    FILENUMBER_MAX_CC=30
elif [[ ${hostname:1:1} == "q" && ${hostname:7:3} == "a03" ]]; then
    FILEPREFIX="PBSI4C"
    FILENUMBER_MAX_MASTER=7
    FILENUMBER_MAX_CC=30   
else
    echo "${TIMESTAMP}  WARN:   Script called in a wrong environment or server ${hostname}. Exiting!" | tee -a ${LOGFILE}
    exit 0
fi

if [[ ! -d $(dirname ${LOGFILE}) ]]; then
    mkdir -p $(dirname ${LOGFILE})
fi

cd /opt/bsi/transfer/_master_current
FILECOUNT=`find . -type f -print | grep "${FILEPREFIX}.MASTERDATA.*${DATE}.zip" |wc -l 2>/dev/null`

if [[ ${FILECOUNT} -lt ${FILENUMBER_MAX_MASTER} ]]; then
    echo "${TIMESTAMP} ERROR:   Masterdata files are not processed. Setting status NOT OK" | tee -a ${LOGFILE}
    EXITCODE=1
else
    echo "${TIMESTAMP}  INFO:   Masterdata files are successfully proceeded" | tee -a ${LOGFILE}
fi

cd /opt/bsi/transfer/_cc_current
FILECOUNT=`find . -type f -print | grep "${FILEPREFIX}.[M]*.*P${DATE}.*[0-9]" |wc -l 2>/dev/null`

if [[ ${FILECOUNT} -lt ${FILENUMBER_MAX_CC} ]]; then
    echo "${TIMESTAMP} ERROR:   Masterdata files are not processed. Setting status NOT OK" | tee -a ${LOGFILE}
    EXITCODE=1 
else
    echo "${TIMESTAMP}  INFO:   Masterdata files are successfully proceeded" | tee -a ${LOGFILE}
fi

exit ${EXITCODE}
