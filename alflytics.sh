#!/bin/bash

wget https://phoenixnap.dl.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/7.1/pentaho-server-ce-7.1.0.0-12.zip

sudo apt-get install -qy openjdk-8-jre-headless openjdk-8-jdk-headless unzip

unzip -d /opt $OLDPWD/pentaho-server-ce-7.1.0.0-12.zip

sed -i 's/8080/7080/g' /opt/pentaho-server/tomcat/conf/server.xml

JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/ /opt/pentaho-server/start-pentaho.sh
