#!/bin/bash

if [ ! -d /mnt/e/alfresco_pgsql ]
then
    sudo mkdir -p /mnt/e/alfresco_pgsql
fi

# Crea archivo de cron
cat << EOF | sudo tee /etc/cron.d/alfresco_backup

SHELL=/usr/bin/bash
# HP Data protector respalda estos datos
# Se deben copiar de forma manual hacia el equipo destino

# Realizamos respaldo de alfresco y trazas 
50 20 * * * postgres /usr/bin/pg_dump -Fc -U postgres alfresco -f /mnt/e/alfresco_pgsql/respaldo-bd-\$(date +\%F-\%s).sql.gz 2>&1 > /dev/null
50 20 * * * postgres /usr/bin/pg_dump -Fc -U postgres trazas -f /mnt/e/alfresco_pgsql/respaldo-trazas-\$(date +\%F-\%s).sql.gz 2>&1 > /dev/null

# Realizamos tar para no perder permisos por WSL
0 20 * * * root tar cJf /mnt/e/alfresco-backup-\$(date +\%F-\%s).tar.xz /opt/alfresco/

# Limpiamos respaldos todos los días
30 19 * * * postgres /usr/bin/rm /mnt/e/alfresco_pgsql/*.sql.gz

EOF
