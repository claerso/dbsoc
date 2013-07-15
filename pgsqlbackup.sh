#!/bin/bash
#PRIMERA VERSION DEL SCRIPT
#Este script permite hacer dumps de las bases y tiene la particularidad que si creamos 
#indiscriminadamente bases en nuestro servidor, las reconoce y hace el dump !. 
#Lo unico el script debe estar en /var/lib/postgresql


declare -a counts
declare -a array1

## BEGIN CONFIG ##

HOST=XX.XX.XX.XX
BACKUP_DIR=/var/lib/postgresql/dumps
USER=postgres
datetime=$(date +%Y%m%d)
filename=/var/lib/postgresql/dumps/arrays

## END CONFIG ##


a=0

if [ ! -d $BACKUP_DIR ]; then

    mkdir -p $BACKUP_DIR
    chown -R postgres.postgres $BACKUP_DIR
    chmod -R 755 $BACKUP_DIR
    touch $filename

fi

psql -h $HOST -U $USER -l | awk ' (NR > 2) && (/[a-zA-Z0-9]+[ ]+[|]/) && ( $0 !~ /template[0-9]/) { print $1 }' > $filename
counts=( `cat "$filename" | wc -w `)
array1=( `cat "$filename"` )

while [ $a -lt $counts ]
  do
    echo ${array1[$a]}-$datetime.sql
    pg_dump -h $HOST -U $USER --column-inserts ${array1[$a]} > $BACKUP_DIR/${array1[$a]}-$datetime.sql
    let a+=1
  done
exit 0
