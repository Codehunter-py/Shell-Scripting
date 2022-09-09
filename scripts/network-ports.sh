#!/bin/bash

# This script displays the open network ports on a system
# Use -4 as an argument to limit to tcpv4 ports.

netstat -nutl ${1} | grep ':'| awk '{print $4}' | awk -F ':' '{print $NF}' |uniq
