#!/bin/bash
# -------
# Script for install of Alfresco
#
# Copyright 2013-2017 Loftux AB, Peter Löfgren
# Distributed under the Creative Commons Attribution-ShareAlike 3.0 Unported License (CC BY-SA 3.0)
# -------

/opt/alfresco/alfresco-service.sh servicestop


export ALF_HOME=/opt/alfresco
export ALF_DATA_HOME=$ALF_HOME/alf_data
export CATALINA_HOME=$ALF_HOME/tomcat
export ALF_USER=alfresco
export ALF_GROUP=$ALF_USER
export APTVERBOSITY="-qq -y"
export TMP_INSTALL=/tmp/alfrescoinstall
export DEFAULTYESNO="y"

# Branch name to pull from server. Use master for stable.
BRANCH=6.2.0GA
#BRANCH=master
export BASE_DOWNLOAD=https://raw.githubusercontent.com/Greencorecr/alfresco-ubuntu-install/$BRANCH
export KEYSTOREBASE=https://svn.alfresco.com/repos/alfresco-open-mirror/alfresco/HEAD/root/projects/repository/config/alfresco/keystore

export LOCALESUPPORT=en_US.utf8

export ALFREPOWAR=https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/content-services-community/6.2.0-ga/content-services-community-6.2.0-ga.war
export ALFSHAREWAR=https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/share/6.2.0/share-6.2.0.war
export ALFSHARESERVICES=https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/alfresco-share-services/6.2.0/alfresco-share-services-6.2.0.amp
export ALFMMTJAR=https://downloads.loftux.net/public/content/org/alfresco/alfresco-mmt/6.0/alfresco-mmt-6.0.jar

cd /tmp
if [ -d "alfrescoinstall" ]; then
	rm -rf alfrescoinstall
fi
mkdir alfrescoinstall
cd ./alfrescoinstall

URLERROR=0

for REMOTE in $TOMCAT_DOWNLOAD $ALFREPOWAR $ALFSHAREWAR $ALFSHARESERVICES

do
        wget --spider $REMOTE --no-check-certificate >& /dev/null
        if [ $? != 0 ]
        then
                echored "In alfinstall.sh, please fix this URL: $REMOTE"
                URLERROR=1
        fi
done

if [ $URLERROR = 1 ]
then
    echo
    echored "Please fix the above errors and rerun."
    echo
    exit
fi

installjdk=y
if [ "$installjdk" = "y" ]; then
  sudo apt-get $APTVERBOSITY purge openjdk-8-jre-headless
  sudo apt-get $APTVERBOSITY install openjdk-11-jre-headless
  sudo curl -c 5  -# -o $ALF_HOME/alfresco-service.sh $BASE_DOWNLOAD/scripts/alfresco-service.sh
  sudo update-alternatives --config java
fi

installwar=y
if [ "$installwar" = "y" ]; then

  sudo curl -c 5  -# -o $ALF_HOME/addons/war/alfresco.war $ALFREPOWAR
  sudo curl -c 5  -# -o $CATALINA_HOME/conf/Catalina/localhost/alfresco.xml $BASE_DOWNLOAD/tomcat/alfresco.xml
fi


installsharewar=y
if [ "$installsharewar" = "y" ]; then

  sudo curl -c 5  -# -o $ALF_HOME/addons/war/share.war $ALFSHAREWAR
  sudo curl -c 5  -# -o $CATALINA_HOME/conf/Catalina/localhost/share.xml $BASE_DOWNLOAD/tomcat/share.xml
fi

if [ "$installwar" = "y" ]; then
    installshareservices=y
    if [ "$installshareservices" = "y" ]; then
      curl -c 5  -# -O $ALFSHARESERVICES
      sudo mv alfresco-share-services*.amp $ALF_HOME/addons/alfresco/
    fi
fi

# Install of war and addons complete, apply them to war file
if [ "$installwar" = "y" ] || [ "$installsharewar" = "y" ] || [ "$installssharepoint" = "y" ]; then
    # Check if Java is installed before trying to apply
    if type -p java; then
        _java=java
    elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
        _java="$JAVA_HOME/bin/java"
        echored "No JDK installed. When you have installed JDK, run "
        echored "$ALF_HOME/addons/apply.sh all"
        echored "to install addons with Alfresco or Share."
    fi
    if [[ "$_java" ]]; then
        sudo $ALF_HOME/addons/apply.sh all
    fi
fi

sudo nohup /opt/alfresco/alfresco-service.sh servicestart
