#!/bin/bash

##################################################################################
# Name          : deploy__elk_beats.sh                                           #
# Author        : Ibrahim Musayev                                                #
# Purpose       : Downloading of beats rpm files from artifactory and installing # 
#                 them on servers by using sudo privileges in install_root.sh    #
#                 script.                                                        #            
# History       : 18.02.22 Ibrahim Musayev, creation                             #
##################################################################################

DATE=`date +'%Y%m%d'`
TIMESTAMP=`date +'%Y%m%d_%H%M%S'`
BEATS_SETUP=/opt/setup/beats
OLD_VERSION_FILEBEAT=`/usr/share/filebeat/bin/filebeat version| awk '{print $3 }' 2>/dev/null`
OLD_VERSION_METRICBEAT=`/usr/share/metricbeat/bin/metricbeat version| awk '{print $3 }' 2>/dev/null`
LOGFILE=/opt/operations/logs/deploy_beats.log
INSTALL_ROOT=/opt/source/custom/scripts/install_root.sh
MASK=$1

if [ ! -d ${BEATS_SETUP} ]; then
   mkdir -p ${BEATS_SETUP}
elif [ -d ${BEATS_SETUP} ] && [ $(ls "$BEATS_SETUP" | wc -l) -ne 0 ]; then
   rm -r ${BEATS_SETUP}/*
fi

if [[ ! -d $(dirname ${LOGFILE}) ]]; then
    mkdir -p $(dirname ${LOGFILE})
fi

cd $BEATS_SETUP
echo "${TIMESTAMP}  WARN   Stop filebeat and metricbeat on all nodes with operate_services.sh." | tee -a ${LOGFILE}
read -p 'Enter the APITOKEN: ' APITOKEN
read -p 'Enter desired filebeat & metricbeat version: ' VERSION_BEATS

curl -H X-JFrog-Art-Api:${APITOKEN} -O -s "https://artifactory.$MASKED/elastic/${VERSION_BEATS}/filebeat-${VERSION_BEATS}-x86_64.rpm" # masking the domain regarding security. 
curl -H X-JFrog-Art-Api:${APITOKEN} -O -s "https://artifactory.$MASKED/elastic/${VERSION_BEATS}/metricbeat-${VERSION_BEATS}-x86_64.rpm" # masking the domain regarding security. 

if [ $(ls "$BEATS_SETUP" | wc -l) -ne 0 ]; then
   echo "${TIMESTAMP}  INFO   filebeat-${VERSION_BEATS} and metricbeat-${VERSION_BEATS} downloads completed." | tee -a ${LOGFILE}
else
   echo "${TIMESTAMP}  ERROR  Something went wrong. Please retry to download update again!" | tee -a ${LOGFILE}
   exit 1 
fi

if [[ "${VERSION_BEATS}" == "${OLD_VERSION_FILEBEAT}" ]]; then
   echo "${TIMESTAMP}  INFO   filebeat-${VERSION_BEATS} is already installed. Nothing to do. Complete!" | tee -a ${LOGFILE}
   exit 0
else
   sudo ${INSTALL_ROOT} install_filebeat
fi

if [[ "${VERSION_BEATS}" == "${OLD_VERSION_METRICBEAT}" ]]; then
   echo "${TIMESTAMP}  INFO   metricbeat-${VERSION_BEATS} is already installed. Nothing to do. Complete!" | tee -a ${LOGFILE}
   exit 0
else
   sudo ${INSTALL_ROOT} install_metricbeat
fi

CHECK_FILEBEAT_VERSION=`/usr/share/filebeat/bin/filebeat version| awk '{print $3 }' 2>/dev/null`
CHECK_METRICBEAT_VERSION=`/usr/share/metricbeat/bin/metricbeat version| awk '{print $3 }' 2>/dev/null`
TIMESTAMP=`date +'%Y%m%d_%H%M%S'`

if [[ "${CHECK_FILEBEAT_VERSION}" == "${VERSION_BEATS}" ]]; then
   echo "${TIMESTAMP}  INFO   filebeat-${VERSION_BEATS} is successfully installed."
else
   echo "${TIMESTAMP}  ERROR  Fatal error during filebeat-${VERSION_BEATS} installation. Exiting..." | tee -a ${LOGFILE}
   exit 1
fi   

if [[ "${CHECK_METRICBEAT_VERSION}" == "${VERSION_BEATS}" ]]; then
   echo "${TIMESTAMP}  INFO   metricbeat-${VERSION_BEATS} is successfully installed."
else
   echo "${TIMESTAMP}  ERROR  Fatal error during metricbeat-${VERSION_BEATS} installation. Exiting..." | tee -a ${LOGFILE}
   exit 1
fi

EXITCODE=$?
TIMESTAMP=`date +'%Y%m%d_%H%M%S'`
if [[ ${EXITCODE} -ne 0 ]]; then
   echo "${TIMESTAMP}  ERROR  Got exit code ${EXITCODE} on installation. Exiting ..." | tee -a ${LOGFILE}
   exit 1
else
   echo "${TIMESTAMP}  INFO   Starting to copy parameters in installation folders" | tee -a ${LOGFILE}
   sudo ${INSTALL_ROOT} sync_source ${ENV} ${VERSION_BEATS}
fi

exit 0
