#!/bin/bash

# Crea archivo de cron
echo EOF | sudo tee /etc/cron.d/bart
0 1 * * * alfresco /opt/alfresco/scripts/bart/alfresco-bart.sh backup all
EOF

# Descarga archivo de bart
sudo wget -O /opt/alfresco/scripts/bart/alfresco-bart.properties https://raw.githubusercontent.com/fede2cr/alfresco-ubuntu-install/master/scripts/alfresco-bart.properties

# Agrega start de cron en service
sudo wget -O /opt/alfresco/alfresco-service.sh https://raw.githubusercontent.com/fede2cr/alfresco-ubuntu-install/master/scripts/alfresco-service.sh

