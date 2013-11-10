#!/bin/sh
############################################
# Simple shell download manager for download all links in a html file.
# This Script is used for 'DownloadThemAll' for BYTubeD.
#
# BYTubeD: a batch youtube downloader
#  * https://addons.mozilla.org/ja/firefox/addon/bytubed/
#
# TESTED: Mac OS 10.8, MyBookLive
# Usage : nohup ThisScript outputHtmlByBYTubeD > somelog &
#
# Author: javaeecoding(at)gmail.com
# Licence: apache 2.0
# 
############################################

############################################
# Check params & init
############################################
cd "$(dirname "$0")"

inputFile=$1
if [ "" == "$inputFile" ] || [ ! -f $inputFile ]; then
    echo "File not found! - $inputFile"
    echo "Usage: nohup ThisScript outputHtmlByBYTubeD > somelog &"
    exit 1
fi

#Keep Video download result
OUT_FOLDER="output"
mkdir -p $OUT_FOLDER

############################################
# Check if a file is downloading.
# If no download speed in specified period, it will be canceled
############################################
function waitOrCancel() {
  thisPID=$1
  outFile=$2
  echo "Process id is ${thisPID} , target file is ${outFile}"

  #Get file size
  if [ ! -f "$outFile" ]; then
    oldSize=0
  else
    oldSize=`stat -c %s "$outFile"`
  fi
  #echo " [DEBUG]Size 1: $oldSize"

  #If file size no change in WAIT_SECONDS*WAIT_MAX_COUNT, and process live, kill process
  WAIT_SECONDS=5
  WAIT_MAX_COUNT=12 
  waitCount=-1

  while :
  do

    #If all ready downloaded (no process)
    if ! ps -p $thisPID > /dev/null
    then
      echo " Download completed"
      break
    fi

    sleep $WAIT_SECONDS

    newSize=`stat -c %s "$outFile"`
    #echo " [DEBUG]Size 1: $oldSize -VS- Size 2: $newSize"

    if [ "$oldSize" -eq "$newSize" ]; then
        ((waitCount++))
        if [ $waitCount -lt $WAIT_MAX_COUNT ]; then
           continue
        else
           echo "[ERROR]Donwload canceled. Process $thisPID is killed , cause it do NOT have download speed. File: $outFile" 
           kill $thisPID
           break
        fi
    else
        #echo " [DEBUG]downloading..."
        waitCount=-1
        oldSize=$newSize
    fi
  done
}

# Low performance.
rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER) 
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

####################################
# main
####################################
# match a url tag e.g: 
# <a href='http://xxxx'>FileName</a>
# or 
# <a href="ftp://xxx">FileName</a>
# and more protocal which cURL supports
regex="^.*<a href=['\"]?([^:]+:\/\/[^'\">]+)['\"]?>([^<'\"]+)['\"]?</a>.*$"
lineNo=0

while read line
do
  [[ $line =~ $regex ]]
  if [ "" == "${BASH_REMATCH}" ]; then
     continue
  fi

  ((lineNo++))
  # 1 --> 001
  lineNoWithPadding=`printf "%03d\n" ${lineNo}`

  url="${BASH_REMATCH[1]}"
  fileName="${BASH_REMATCH[2]}"

  
  #echo "URL: ${url}END"
  #Encode URL
  # downloadUrl=$( rawurlencode $url )
  #encode kanji only, ingnore :/_\?=.,&-
  downloadUrl=`echo -n $url | perl -p -e 's/([^A-Za-z0-9:\/_\?=\.,&\-])/sprintf("%%%02X", ord($1))/seg'`
  #downloadUrl=$url

  #Repalce NG chars in file name
  fileName=`echo $fileName | sed -e "s/[\" '\?\/\\:]/_/g"`
  #fileName=`echo $fileName | sed -e "s/ /\\ /g"`

  #echo "line    -->  $line"
  #echo "file    -->  $fileName"
  #echo "encoded -->  $downloadUrl"
  echo "$lineNo : $fileName : $downloadUrl"

  curl -C - -o "${OUT_FOLDER}/${fileName}" -L "${downloadUrl}" -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Connection: keep-alive' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'Accept-Language: ja,en-US;q=0.8,en;q=0.6,zh;q=0.4' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101 Safari/537.36' &

  #Wait response(speed up re-download)
  sleep 0.33
  waitOrCancel $! "${OUT_FOLDER}/${fileName}"

done < $inputFile 
