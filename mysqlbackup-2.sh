#!/bin/bash


declare -a array1
declare -a counts


## BEGIN CONFIG ## 

host=XX.XX.XX.XX
user=dumps
pass='password'
datetime=$(date +%Y%m%d)
timedate=$(date +%T)
pathbkp=/var/local/dumps
filename=$pathbkp/arrays.file
logdir=$pathbkp/LOG/

## END CONFIG ##


a=0


 if [ ! -d $pathbkp ]; then    

    mkdir -p $pathbkp

    mkdir -p $logdir

    chown -R mysql.mysql $pathbkp

    chmod -R 755 $pathbkp 

    touch $filename

 else

    touch $filename

 fi  


args=("-h $host -u $user -p$pass" "-h $host -u $user -p$pass --opt ")


mysqlshow ${args[0]} > $filename


counts=( `cat "$filename" | sed -e '/+/d' | tr -d '|' | sed -e '/Database/d'| sed -e '/information_schema/d' | wc -w `)

array1=( `cat "$filename" | sed -e '/+/d' | tr -d '|'  | sed -e '/Database/d' | sed -e '/information_schema/d'` )


while [ $a -lt $counts ]

    do

        echo ${array1[$a]}-$datetime.sql

        mysqldump ${args[1]} ${array1[$a]} > $pathbkp/${array1[$a]}-$datetime.sql 2>&1


        if [ "$?" != "0" ]; then

       

        echo ${array1[$a]}-$datetime.sql - $datetime - $timedate "No se realizo Dumps" >>  $logdir/dumps-error.log


        else


        echo ${array1[$a]}-$datetime.sql - $datetime - $timedate "Se realizo Dumps" >>  $logdir/dumps-exito.log


        fi

       

        let a+=1

    done


rm -f $filename


exit 0
