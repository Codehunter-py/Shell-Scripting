#!/bin/bash

################################################################################
# Name    : housekeeping.sh                                                    #
# Author  : Ibrahim Musayev                                                    #
# Purpose : Clean the directories or files that last modified more than        # 
#           365 days ago on two servers.                                       #
#                                                                              #
# History : 22.12.22 Ibrahim Musayev, creation                                 #
################################################################################

hostname=$(hostname -s)

if [[ ${hostname:1:1} == "p" && ${hostname:9:10} == "01" ]]; then
  # Find all directories those are modified more than 365 days in the mcs directory in main env server 1
  mcs_dir="/opt/prai/mcs"

  for folder in $(find $mcs_dir -type d ! -path $mcs_dir -not -name "????" 2>/dev/null)
  do
    # Check if the directory was last modified more than 365 days ago
    if [[ $(find $folder -maxdepth 1 -type d -mtime +365 2>/dev/null) ]]
    then
      # Delete the contents of the directory if it meets the criteria
      echo "Target folder: $folder" && rm -r $folder/* && find $mcs_dir -type d -empty -delete
    fi
  done

elif [[ ${hostname:1:1} == "p" && ${hostname:9:10} == "02" ]]; then
  # Find all files those are modified more than 365 days in the projects/mcs_data directory in main env server 2 
  mcs_data="/var/opt/"
  acq_data="/var/opt/ACQ_DATA"
  iss_data="/var/opt/ISS_DATA"
  input_data="1_DATA_INPUT"
  output_data="4_DATA_OUTPUT"
    
  find $acq_data/{$input_data,$output_data} -type f -mtime +365 -delete && find $acq_data/{$input_data,$output_data} -type d -empty -delete
  find $iss_data/{$input_data,$output_data} -type f -mtime +365 -delete && find $iss_data/{$input_data,$output_data} -type d -empty -delete
 
  echo "Target folders cleaned: $acq_data/{$input_data,$output_data}"
  echo "Target folders cleaned: $iss_data/{$input_data,$output_data}"

fi
