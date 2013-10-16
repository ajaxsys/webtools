#!/bin/sh
cd "$(dirname "$0")"

# FWs-iMac:dict fw$ ./search_dict.sh test.txt output http://dict.hjenglish.com/web/\${key}
USAGE="Usage: nohup ThisScript inputWordList outputDirectory searchEngineURLwith\${key} > somelog &"

if [ $# -ne 3 ]; then
	echo $USAGE
	exit 1
fi

# check file exists
inputFile=$1
if [ ! -f $inputFile ]; then
    echo "File not found! - $inputFile"
    echo $USAGE
    exit 1
fi

outDir=$2
# check is directory exists
if [ ! -e $outDir ] ; then
	mkdir -p $outDir
fi

# check is directory
if [ ! -d $outDir ]; then
    echo "NOT a folder - $outDir"
    echo $USAGE
    exit 1
fi

engine=$3
if [[ ! "$engine" =~ ^http://.*\$\{key\}$ ]]; then
	echo "NOT a url with string `\${key}` - $engine"
    echo $USAGE
    exit 1
fi

#english-->chinese  http://dict.hjenglish.com/web/bash
#japanese-->chinese curl 'http://dict.hjenglish.com/jp/web/%E5%A4%89%E6%9B%B4%E3%81%99&type=jc' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'Host: dict.hjenglish.com' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Referer: http://d.hatena.ne.jp/adsaria/20100107/1262842850' -H 'Cookie: wrap_language=jp; _hotlink_uid=136397091775671; bdshare_firstime=1363970918114; dict_user=%5C62%5C60%5C60%5C67%5C62%5C66%5C71%5C60%5C60%5C70%5C52%5C174%5C52%5C61%5C70%5C67%5C70%5C64%5C66%5C60%5C52%5C174%5C52%5C143%5C150%5C165%5C141%5C156%5C154%5C151%5C156%5C171%5C141%5C156; hjd_mode=normal; ASP.NET_SessionId=omhunpqnwitbdhjurf03ny3j; Hm_lvt_8f9f4e96769741f9eec7774d35239d85=1375567218,1375567252,1375702987,1376178614; Hm_lpvt_8f9f4e96769741f9eec7774d35239d85=1376779803; Hm_lvt_7ac87158ce7cd3c36bdfadb76b939020=1375567218,1375567252,1375702987,1376178614; Hm_lpvt_7ac87158ce7cd3c36bdfadb76b939020=1376779803; _hotlink_source_track=; home_language=jp; cck_lasttime=1376812335735; cck_count=1; hjhistory=%e3%81%92|%e3%83%8f%e3%82%a4%e3%83%a9%e3%82%a4%e3%83%88|%e3%82%b7%e3%83%a7%e3%83%ab%e3%83%80%e3%83%bc|%e3%83%88%e3%83%bc%e3%83%88|%e3%83%87%e3%82%a4%e3%83%aa%e3%83%bc; _pk_ref.3.250c=%5B%22%22%2C%22%22%2C1376819022%2C%22http%3A%2F%2Fajaxsys.appspot.com%2FTransIt%2Findex.htm%22%5D; _pk_id.3.250c=dc13b7a80ddfd78f.1372118711.20.1376819022.1376811381.; ClubAuth=31416858F4FEA04D068F95D72F84FF9A9491A6FF6BA0B55D7D4CF7E9522165DF7DDD7AE99E9A0F2188014ED29BC5BD68537BFF2D62A040FD5E6298F0A76A09A099C7DB96C496DF82B3437571FB99C69FAACF71333B3349B997273AD30E5835964FB8B4751C99B7F5FF35563D948FF18B5CFFF49C55E2B200C847CB07116AA38C2C2336AACE82622D694E8D824777E2B20BAACE832236C573E2A525D3; _pk_id.18.2f95=2f25f45621e91f00.1375864167.13.1376819024.1376811383.; Hm_lvt_0e95f1361bea6bbacc4669dfb29bf92f=1375569625,1375750187,1376178626; Hm_lpvt_0e95f1361bea6bbacc4669dfb29bf92f=1376819026; hjd_ajax_Language2011=en; __utma=76399744.246818798.1375567215.1376811374.1376819022.22; __utmc=76399744; __utmz=76399744.1375567215.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)' -H 'Connection: keep-alive' --compressed

echo "All inputs: $inputFile $outDir $engine"
####################################
# main read all words from file
####################################
while read key
do
	if [ ! "" == "$key" ]; then
	    url=`echo $engine | sed -e s/\$\{key\}/$key/`
		echo $url
		curl -C - -o "$outDir/${key}.html" -L $url
		sleep 10
	fi
done < $inputFile
	
	