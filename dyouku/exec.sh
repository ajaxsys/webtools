#!/bin/sh
cd "$(dirname "$0")"

inputFile=$1
if [ "" == "$inputFile" ] || [ ! -f $inputFile ]; then
    echo "File not found! - $inputFile"
    echo "Usage: nohup ThisScript inputUrlList [password] > somelog &"
    exit 1
fi

psw=""
if [ ! "" == "$2" ]; then
    echo "Use password: - $2"
    pwd="&passwd=$2"
fi

#Keep Curl result
mkdir -p tmp
#Keep Video download result
mkdir -p output
#Keep merged videos
mkdir -p download

#rm -f tmp/*.*

SPLIT="	-#-	"

while read line
do
  #ignore blank line or line withou splitter
  if [[ ! "$line" == *"$SPLIT"* ]]; then
     echo "Skiped because no <tab>${SPLIT}<tab>"
     continue
  fi

  #DO: aaa -#- bbb  --> array[0]=aaa array[1]=bbb
  #IFS=' -#- ' read -a nameAndUrl <<< "$line"
  nameAndUrl=(${line//$SPLIT/ })
  name=${nameAndUrl[0]}
  #URL encoding use python
  url=$(python -c "import urllib; print urllib.quote('''${nameAndUrl[1]}''')")
  echo "Name:$name , url:${nameAndUrl[1]}. url_encoded:$url"


  tmpFile="tmp/video_list_${name}"
  videoDownloadPath="download/${name}/"
  mkdir -p $videoDownloadPath

  # Step1. Analize youku url
  # super high
  echo "Get $name (default super high)"
  echo "http://www.flvcd.com/parse.php?kw=${url}${pwd}&flag=one&format=super"
  curl "http://www.flvcd.com/parse.php?kw=${url}${pwd}&flag=one&format=super" | iconv -f gb18030 -t utf-8  >$tmpFile &
  wait

  #high
  isSupport=`grep "暂不支持" $tmpFile | wc -l | tr -d " "`
  if [ $isSupport -gt 0 ]; then
    echo "Super high not support, trying high"
    curl "http://www.flvcd.com/parse.php?kw=${url}${pwd}&flag=one&format=high" | iconv -f gb18030 -t utf-8  >$tmpFile &
    wait
  fi

  #normal
  isSupport=`grep "暂不支持" $tmpFile | wc -l | tr -d " "`
  if [ $isSupport -gt 0 ]; then
    echo "Super&high both not support, trying normal"
    curl "http://www.flvcd.com/parse.php?kw=${url}${pwd}&format=" | iconv -f gb18030 -t utf-8  >$tmpFile &
    wait
  fi

  #others - exception
  isSupport=`grep "暂不支持" $tmpFile | wc -l | tr -d " "`
  if [ $isSupport -gt 0 ]; then
    echo 'Exception. Unspport vedio?'
    continue
  fi


  # abstract urls
  egrep 'href="http://f.youku.com/[0-9a-zA-Z?/_=-]+"' -o $tmpFile > $tmpFile-urls

  # Step2. Change to download command
  lineNo=0
  # Get all line, with trim
  allLines=`cat $tmpFile-urls | wc -l | tr -d " "`
  if [ $allLines -lt 1 ]; then
    echo 'Exception. No Urls to download. Unspport vedio?'
    continue
  fi

  #Check flv or mp4
  flvOrMp4=`grep "/flv/" $tmpFile-urls | wc -l | tr -d " "`
  if [ $flvOrMp4 -gt 0 ]; then
    flvOrMp4='flv'
  else
    flvOrMp4='mp4'
  fi
  echo "Download type: $flvOrMp4 "

  while read downloadUrl
  do
    ((lineNo++))
    # 1 --> 001
    lineNoWithPadding=`printf "%03d\n" ${lineNo}`
    # href="xxx" --> xxx
    downloadUrl=`echo $downloadUrl | sed -e "s/href=//" | sed -e "s/\"//g"`

    echo "$lineNo / $allLines : $downloadUrl"
    curl -C - -o "$videoDownloadPath${lineNoWithPadding}.${flvOrMp4}" -L $downloadUrl &
    wait

  done <$tmpFile-urls

  #merge this video
  #escape shell file name. escaped char:' !&$()'
  #note: x=$(printf '%q' "$x") not work in UTF-8
  #fileToBeMerged=`echo "download/${name}*.flv" | sed -E 's/([ \!\&\$\(\)])/\\\1/g'`
  #outputFileName=`echo "output/${name}.flv" | sed -E 's/([ \!\&\$\(\)])/\\\1/g'`
  #echo "fileToBeMerged=$fileToBeMerged outputFileName=$outputFileName"
  #python flv_join.py --output $outputFileName $fileToBeMerged
  
  #Avoid escpae
  cp *_join.py $videoDownloadPath
  cd $videoDownloadPath
  pwd
  python ${flvOrMp4}_join.py --output "../../output/${name}.${flvOrMp4}" `ls *.${flvOrMp4}`
  cd -
  
  if [ -f "output/${name}.${flvOrMp4}" ]; then
    echo "Download and merge complete."
  else
    echo "Merge failed!!!"
  fi

done < $inputFile 



