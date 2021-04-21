#!/bin/bash

backupdir = /mnt/e/alfresco-backup

if [ ! -d $backupdir ]
then
    sudo mkdir -p $backupdir
fi

# Crea archivo de cron
cat << EOF | sudo tee /etc/cron.d/alfresco_backup

SHELL=/usr/bin/bash
# HP Data protector respalda estos datos
# Se deben copiar de forma manual hacia el equipo destino

# Realizamos respaldo de alfresco y trazas 
50 20 * * * postgres /usr/bin/pg_dump -Fc -U postgres alfresco -f $backupdir/respaldo-bd-\$(date +\%F-\%s).sql.gz 2>&1 > /dev/null
50 20 * * * postgres /usr/bin/pg_dump -Fc -U postgres trazas -f $backupdir/respaldo-trazas-\$(date +\%F-\%s).sql.gz 2>&1 > /dev/null

# Realizamos tar para no perder permisos por WSL
0 20 * * * root tar cJf $backupdir/alfresco-backup-\$(date +\%F-\%s).tar.xz /opt/alfresco/

# Limpiamos respaldos todos los días
30 19 * * * postgres /usr/bin/rm $backupdir/*

EOF
