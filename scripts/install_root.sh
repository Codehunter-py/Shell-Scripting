#!/bin/bash

# Purpose:
# wrapper script for install commands that require a root shell
# the script should support a list of options to run 

echo "Running with root shell"
echo "Arguments given for options $1 $@"

OPS_CONF="/opt/operations/conf/opt_elastic.conf"
if [[ -f ${OPS_CONF} ]]; then
   . ${OPS_CONF}
else
   echo "ERROR: Could not find ${OPS_CONF}"
   exit 99
fi

DATE=`date +'%Y%m%d'`
ELK_ROOT=${GLOBAL_ELK_YAML_DIR}
BEATS_SETUP=${GLOBAL_BEATS_SETUP_DIR}
ENV=$2
NEW_VERSION_BEATS=$3

case $1 in 
  install_filebeat) 
    yum install -y ${BEATS_SETUP}/filebeat-*.rpm 2>/dev/null
    ;;

  install_metricbeat) 
    yum install -y ${BEATS_SETUP}/metricbeat-*.rpm 2>/dev/null
    ;;

  sync_source) # copy/change parameters and ownerships and restart services
    cd /etc/filebeat
    mv filebeat.yml.rpmnew filebeat.yml.${NEW_VERSION_BEATS} 2>/dev/null
    cp -p ${ELK_ROOT}/filebeat.yml filebeat.yml.server 2>/dev/null

    if [[ "${ENV}" == "dev"]]; then
       cp -p ${ELK_ROOT}/filebeat_${ENV}.yml /etc/filebeat/filebeat.yml.server 2>/dev/null
    elif [[ "${ENV}" == "prod"]]; then
       cp -p ${ELK_ROOT}/filebeat_${ENV}.yml /etc/filebeat/filebeat.yml.server 2>/dev/null
    fi   
           
    chown root:root filebeat.yml.server 2>/dev/null
    chmod 600 filebeat.yml.server 2>/dev/null
    cp -p  filebeat.yml.server filebeat.yml 2>/dev/null
    cd /etc/metricbeat/
    mv metricbeat.yml.rpmnew metricbeat.yml.${NEW_VERSION_BEATS} 2>/dev/null
    cp -p ${ELK_ROOT}/metricbeat_${ENV}.yml metricbeat.yml.server 2>/dev/null
    # change ownerships and restart services  
    chown root:root metricbeat.yml.server 2>/dev/null
    chmod 600  metricbeat.yml.server 2>/dev/null
    cp -p metricbeat.yml.server metricbeat.yml 2>/dev/null
    systemctl restart filebeat.service 
    systemctl restart metricbeat.service 
    ;;

  *) # unsupported arguments for operation provided
    echo -e "\n unsupported arguments for operation provided."
    help
    ;;
    
esac

exit 0
