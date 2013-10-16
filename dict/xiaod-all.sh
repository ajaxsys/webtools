#!/bin/sh

#english --> chinese
nohup ./search_dict.sh ALL_ENGLISH output/xiaod_en-cn_all    http://dict.hjenglish.com/w/\${key}   > output/xiaod_en-cn_all.log &
nohup ./search_dict.sh ALL_ENGLISH output/xiaod_en-cn_simple http://dict.hjenglish.com/web/\${key} > output/xiaod_en-cn_simple.log &

#chinese --> english
#chinese --> japanese
nohup ./search_dict.sh ALL_CHINESE output/xiaod_cn-jp_all    http://dict.hjenglish.com/jp/web/\${key}&h=1&type=cj   > output/xiaod_en-cn_all.log &






#english --> japanese
nohup ./search_dict.sh ALL_ENGLISH  output/weblio_en-jp http://ejje.weblio.jp/content/\${key} > output/weblio_en-jp.log &
#japanese --> english
nohup ./search_dict.sh ALL_JAPANESE output/weblio_jp-en http://ejje.weblio.jp/content/\${key} > output/weblio_jp-en.log &



