#!/bin/bash

# VERSIÓN 2.1 mysqlbackup.sh
# Esta es una nueva modificacion de la segunda versión del Script para Mysql.
# Mejoras:
# Mejor utilizacion de las variables 


declare -a ARRAY1
declare -a COUNTS


## BEGIN CONFIG ## 

HOST=XX.XX.XX.XX
USER=dumps
PASS='PASSword'
DATETIME=$(date +%Y.%m.%d-%T)
BACKUPDIR=/var/local/dumps
ARRYSFILE=$BACKUPDIR/arrays.file
LOGDIR=$BACKUPDIR/LOG/

## END CONFIG ##

a=0


 if [ ! -d $BACKUPDIR ]; then    

    mkdir -p $BACKUPDIR
    mkdir -p $LOGDIR
    chown -R mysql.mysql $BACKUPDIR
    chmod -R 755 $BACKUPDIR 
    touch $ARRYSFILE

 else

    touch $ARRYSFILE

 fi  


args=("-h $HOST -u $USER -p$PASS" "-h $HOST -u $USER -p$PASS --opt ")
mysqlshow ${args[0]} > $ARRYSFILE


COUNTS=( `cat "$ARRYSFILE" | sed -e '/+/d' | tr -d '|' | sed -e '/Database/d'| sed -e '/information_schema/d' | wc -w `)
ARRAY1=( `cat "$ARRYSFILE" | sed -e '/+/d' | tr -d '|'  | sed -e '/Database/d' | sed -e '/information_schema/d'` )


while [ $a -lt $COUNTS ]

    do
        echo ${ARRAY1[$a]}-$DATETIME.sql
        
        mysqldump ${args[1]} ${ARRAY1[$a]} > $BACKUPDIR/${ARRAY1[$a]}-$DATETIME.sql 2>&1

        if [ "$?" != "0" ]; then 
            
        	echo ${ARRAY1[$a]}-$DATETIME.sql "FALLO DUMPS" >>  $LOGDIR/dumps-error.log
        
        else
        
        	echo ${ARRAY1[$a]}-$DATETIME.sql "CORRECTO DUMPS" >>  $LOGDIR/dumps-exito.log
        
        fi

        let a+=1

    done

rm -f $ARRYSFILE

exit 0
