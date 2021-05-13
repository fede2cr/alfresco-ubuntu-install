#!/bin/bash

# Crea archivo de cron
cat << EOF | sudo tee /etc/cron.d/alfresco_maint

SHELL=/usr/bin/bash

# Ejecutamos vacuumdb, los Sábados a las 2am
0 2 * * 6 postgres /usr/bin/vacuumdb -a -z 2>&1 > /dev/null

# Ejecutamos apt upgrade, los Sábados, de 2am a 3am
0 2 * * 6 root /usr/bin/apt update -y 2>&1 > /dev/null
0 3 * * 6 root /usr/bin/apt upgrade -y 2>&1 > /dev/null
EOF

cat << EOF | sudo tee /etc/logrotate.d/alfresco
# src https://gist.github.com/AFaust/68a93c1164b09907e896e5ec76c9d073
/opt/alfresco/tomcat/logs/catalina.out {
        daily
        rotate 27
        notifempty
        missingok
        compress
        delaycompress
        copytruncate
}

/opt/alfresco/tomcat/logs/dummy {
        rotate 0
        daily
        create
        ifempty
        missingok
        lastaction
                /usr/bin/find /opt/alfresco/tomcat/logs/localhost_access_log.*.txt.gz -daystart -mtime +26 -delete
                /usr/bin/find /opt/alfresco/tomcat/logs/alfresco.log.*.gz -daystart -mtime +26 -delete
                /usr/bin/find /opt/alfresco/tomcat/logs/localhost_access_log.????-??-??.txt -daystart -mtime +1 -exec gzip -q '{}' \;
                /usr/bin/find /opt/alfresco/tomcat/logs/alfresco.log.????-??-?? -daystart -mtime +1 -exec gzip -q '{}' \;
        endscript
}
EOF
