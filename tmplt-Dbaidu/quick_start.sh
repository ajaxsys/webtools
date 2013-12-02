#!/bin/sh
cd "$(dirname "$0")"

#Nano
#time=`date +%s`
#YYYYmmDDHHMMSS
time=`date +%Y%m%d%H%M%S`

nohup ./exec.sh > exec_${time}.log 2>&1 &
echo "Process ID: $!"

