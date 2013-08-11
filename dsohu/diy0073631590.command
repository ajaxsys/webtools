#!/bin/sh
echo '正在检查当前系统环境......'

appPath='/Documents/flvcd/'
appfile='/Documents/flvcd/touch_0511.tar.gz'
applib='/Documents/flvcd/libcgunwind.1.0.dylib'
app='/Documents/flvcd/touch_0511'
id='myflvcd://diy0073631590/'
cmd='/Documents/flvcd/touch_0511  '$id

appPath=$HOME$appPath
appfile=$HOME$appfile
applib=$HOME$applib
app=$HOME$app
cmd=$HOME$cmd


# 参数判断程序目录是否存在 
if [ ! -d "$appPath" ]; then
echo "您是第一次使用硕鼠mac版,将会花费一点时间部署一些文件,请耐心等待"
mkdir "$appPath"
fi 




# 判断最新版下载器是否存在 
if [ ! -f "$appfile" ]; then 
echo '正在下载更新......'
curl -o $appfile 'http://download.flvcd.com/mac/touch_0511.tar.gz'
echo '正在解压......'
if [ -f "$appfile" ]; then 
cd $appPath
tar zxf $appfile
fi
fi 



# 这里的-f参数判断最新版库是否存在 
if [ ! -f "$applib" ]; then 
echo '正在更新运行库......'
curl -o $applib 'http://download.flvcd.com/mac/libcgunwind.1.0.dylib'
fi 


if [ -f "$app" ]; then 
echo $cmd
nohup $cmd &
echo '硕鼠下载器已经启动,请关闭本窗口'
exit
else 
echo '查找相关文件失败,无法启动下载器,请检查网络环境设置或者发送邮件到flvcd@126.com寻求技术支持'
fi