#!/bin/bash
PROJECT="spring-boot-hello-world"
INSTALL_FOLDER="$JENKINS_HOME/$PROJECT"
mvn clean package

#Kill the old one
PID_LOCATION="$INSTALL_FOLDER/PID"
OLD_PID=$(cat $PID_LOCATION)
kill -9 $OLD_PID

#Make the folder
mkdir -p $INSTALL_FOLDER
rm -rf $INSTALL_FOLDER/*

#Copy the Jar
JAR="$(ls target/ | grep .jar | grep -v .original)"
cp target/$JAR $INSTALL_FOLDER/$JAR
scp target/$JAR 10.0.0.5:~
ssh 10.0.0.5 ./runhelloworld.sh

#Run the Jar
BUILD_ID=dontKillMe java -jar $INSTALL_FOLDER/$JAR 2>&1 &
echo $! >$PID_LOCATION
disown