#!/bin/bash

if [ ! -d /mnt/e/alfresco_pgsql ]
then
    sudo mkdir -p /mnt/e/alfresco_pgsql
fi

# Crea archivo de cron
cat << EOF | sudo tee /etc/cron.d/pg_dump

SHELL=/usr/bin/bash
# HP Data protector corre a las 10am, 1pm, 3pm y 10pm.
# Nosotros, 10 minutos antes. pg_dump solo dura ~5s.

50 9,12,15,20 * * * postgres /usr/bin/pg_dump -Fc -U postgres alfresco -f /mnt/e/alfresco_pgsql/respaldo-bd-\$(date +\%F-\%s).sql.gz 2>&1 > /dev/null


# Limpiamos respaldos todos los días
30 9 * * * postgres /usr/bin/rm /mnt/e/alfresco_pgsql/*.sql.gz

# Copiamos config de Alfresco una vez por día
0 9 * * * root cp /opt/alfresco/tomcat/shared/classes/alfresco-global.properties /mnt/e/alfresco_pgsql/

EOF
