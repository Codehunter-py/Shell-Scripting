#!/bin/bash

#################################################################################
# Name          : update_elastic_container.sh                                   #
# Author        : Ibrahim Musayev                                               #
# Purpose       : Automating the setup of docker elastic container              #
# Prerequisites : create elk data snapshots,                                    #
#                 define repository and policy and run an index snapshot        #                 
# History       : 08.02.22 Ibrahim Musayev, creation                            #
#################################################################################

DATE=`date +'%Y%m%d'`
TIMESTAMP=`date +'%Y%m%d_%H%M%S'`
OPT_SETUP=/opt/setup/elastic
LOGFILE=/opt/operations/logs/update_elastic_container.log

if [ ! -d ${OPT_SETUP} ]; then
   mkdir -p ${OPT_SETUP}
elif [ -d ${OPT_SETUP} ] && [ $(ls "$OPT_SETUP" | wc -l) -ne 0 ]; then
   rm -r ${OPT_SETUP}/* 2>/dev/null
fi

if [[ ! -d $(dirname ${LOGFILE}) ]]; then
    mkdir -p $(dirname ${LOGFILE})
fi

cd $OPT_SETUP

echo "${TIMESTAMP}  WARN   Stop filebeat and metricbeat on all nodes with operate_services.sh." | tee -a ${LOGFILE}
read -p 'Enter filebeat & metricbeat version: ' VERSION_BEATS

function downloadElk {
    wget "https://artifactory.wdt.six-group.net:443/artifactory/cscao-generic-release-remote-cache/docker/elk_${VERSION_BEATS}.tar.gz"
    gzip -d elk_${VERSION_BEATS}.tar.gz
    
    if [ $(ls -l "$OPT_SETUP" | wc -l) -ne 0 ]; then
       echo "${TIMESTAMP}  INFO   RPM files are downloaded." | tee -a ${LOGFILE}
    else
       echo "${TIMESTAMP}  ERROR  Downloads are not completed. Please try manually!" | tee -a ${LOGFILE}
       exit 1 
    fi
}

function loadNewImage {
    docker stop elk
    docker container rm -v $(docker ps -aqf "name=elk") 2>/dev/null
    docker load -i ${OPT_SETUP}/elk_${VERSION_BEATS}.tar 2>/dev/null
    EXITCODE=$?
}

function runNewContainer {
    if [[ ${EXITCODE} -ne 0 ]]; then
       echo "`date +'%Y%m%d_%H%M%S'`  ERROR  Got exit code ${EXITCODE} on docker load. Exiting ..." | tee -a ${LOGFILE}
       exit 1
    else
       TIMESTAMP=`date +'%Y%m%d_%H%M%S'`
       echo "${TIMESTAMP}  INFO  Container build is being loaded..." | tee -a ${LOGFILE}
       docker run --name elk -d --restart=always -p 4560:4560 -it -v /opt/source/docker/bsicrm-json.conf:/etc/logstash/conf.d/05-bsicrm-json.conf -v /opt/source/docker/kibana.yml:/opt/kibana/config/kibana.yml -v /opt/data/elasticsearch:/var/log/elasticsearch sebp/elk:elk_${VERSION_BEATS}
       echo "${TIMESTAMP}  INFO  Container customization is being handled..." | tee -a ${LOGFILE}
       echo -e "-Xms4g\n-Xmx4g" > /opt/source/docker/heap.options
       docker cp /opt/source/docker/heap.options elk:/etc/elasticsearch/jvm.options.d/
       docker exec elk sed -i '0,/#bootstrap.memory_lock/s//bootstrap.memory_lock/' /etc/elasticsearch/elasticsearch.yml
       docker exec elk sed -i 's|/var/backups|/var/log/elasticsearch|' /etc/elasticsearch/elasticsearch.yml
       EXITCODE=$?
    fi
    
    TIMESTAMP=`date +'%Y%m%d_%H%M%S'`
    if [[ ${EXITCODE} -ne 0 ]]; then
       echo "${TIMESTAMP}  ERROR  Got exit code ${EXITCODE} on container build setup. Exiting ..." | tee -a ${LOGFILE}
       exit 1
    else
       echo "${TIMESTAMP}  INFO   Container build setup is successfully completed. Please continue with defined Post Action tasks" | tee -a ${LOGFILE}
       echo "${TIMESTAMP}  INFO   Update metricbeat and filebeat to release ${VERSION_BEATS}"
       exit 0
    fi
}

downloadElk
loadNewImage
runNewContainer
