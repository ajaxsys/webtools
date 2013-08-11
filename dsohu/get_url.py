import urllib2
import urllib
import sys
import re
import json

args = sys.argv

# argv[0] == script name
if ( len(args) != 2 ):
	print 'Usage : python %s sohu_tv_url' % args[0]
	quit()

#url e.g: http://tv.sohu.com/20130423/n373710167.shtml
url_step1 = 'http://www.flvcd.com/interface/parsem-flvcd_utf8.php?id=78787878&format=high&url=' + args[1]

response = urllib2.urlopen(url_step1)
html = response.read()
print html

#get video url:http://data.vod.itc.cn/tv/20130423/815824-1103105-d3ea8130-c909-49d8-a6a8-f259d39f6694.mp4&new=/111/225/2oryRGJYlLOx4sinPD7bs6.mp4
v_list = re.findall( '(?<=http://data.vod.itc.cn/)tv/.*', html);

for u in v_list :
	url_step2 = 'http://220.181.61.212/?prot=2&t=0.94206&file=' + u
	print '[url_step2]' + url_step2
	#Get key
	response = urllib2.urlopen(url_step2)
	html = response.read()
	print '[key]' + html 
	#http://newflv.sohu.ccgslb.net/|623|126.36.139.219|tEHptJFJUmLsSRZlq_r6kQWJMJTQTDCP|1|0|1|53
	m = re.search( '[0-9a-zA-Z\-\._]{32,}' , html)
	key=m.group(0)
	#Get Real url
	new_part = re.sub(r'.*new=', '', url_step2)
	#http://newsflv.sohu.rewrite.ccgslb.com/51/181/1u86kWqa8hRE1AK3IiSHL2.mp4?key=LDeHkxUux9APRX1MDjszc6fE2d0sN32b
	#url_step3 = 'http://209.177.82.4' + new_part + '?key='+key
	url_step3 = 'http://newsflv.sohu.rewrite.ccgslb.com' + new_part + '?key='+key
	print '[TargetURL]try and try with: curl -L -v -O ' + url_step3

