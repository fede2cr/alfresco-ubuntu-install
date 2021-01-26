#!/bin/bash

sudo apt-get install -qy openjdk-8-jre-headless openjdk-8-jdk-headless unzip
wget https://phoenixnap.dl.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/7.1/pentaho-server-ce-7.1.0.0-12.zip

unzip -d /opt pentaho-server-ce-7.1.0.0-12.zip

# V.
#sed -i 's/8080/7080/g' /opt/pentaho-server/tomcat/conf/server.xml


# Instalación de Alflytics
wget https://github.com/fcorti/Alflytics/releases/download/5.0.EA/Alflytics_v5.0.EA.zip
unzip -d /opt/pentaho-server/pentaho-solutions/system/ Alflytics_v5.0.EA.zip


# Instalación de módulo Saiku
wget http://downloads.meteorite.bi/saiku3/saiku-plugin-p7.1-3.90.zip
unzip -d /opt/pentaho-server/pentaho-solutions/system/ saiku-plugin-p7.1-3.90.zip

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/ 
export PENTAHO_JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/ 
/opt/pentaho-server/start-pentaho.sh
