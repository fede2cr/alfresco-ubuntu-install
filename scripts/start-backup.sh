#!/bin/bash

if [ ! -d /mnt/e/alfresco_pgsql ]
then
    sudo mkdir -p /mnt/e/alfresco_pgsql
fi


# Crea archivo de cron
echo EOF | sudo tee /etc/cron.d/pg_dump
50 9,12,15,20 * * * postgres /usr/bin/pg_dump -Fc -U postgres alfresco -f /mnt/e/alfresco_pgsql/respaldo-bd-$(date +%F-%s).sql.gz 2>&1 > /dev/null


30 9 * * * postgres /usr/bin/rm /mnt/e/alfresco_pgsql/*.sql.gz

EOF

