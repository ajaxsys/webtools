#!/bin/sh
############################################
# Check params & init
############################################
cd "$(dirname "$0")"

inputFile=$1
if [ "" == "$inputFile" ] || [ ! -f $inputFile ]; then
    echo "File not found! - $inputFile"
    echo "Usage: quick_start.sh inputUrlList [password]"
    exit 1
fi

psw=""
if [ ! "" == "$2" ]; then
    echo "Use password: - $2"
fi

nohup ./exec.sh $inputFile $pwd > ${inputFile}.log 2>&1 &
echo "Process ID: $!"

