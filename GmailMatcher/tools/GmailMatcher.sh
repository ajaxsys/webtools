cd ../target/classes/

M2_REPO=~/.m2/repository
mailPath=$M2_REPO/javax/mail/mail/1.4.5/mail-1.4.5.jar

export CLASSPATH=$CLASSPATH:$mailPath:.
java -Dfile.encoding=UTF-8 com.azusa.GmailMatcher $@


