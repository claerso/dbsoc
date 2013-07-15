#!/bin/bash

#PRIMERA VERSION DEL SCRIPT
#Este script nos permite hacer dumps a las bases de un servidor Mysql.
#La ventaja que posee este script es que cuando se sube una base nueva al servidor, 
#no debemos preocuparnos por el dumps, ya que el script a travez de utilizar vectores 
#tiene la capacidad de detectar los cambios automaticamente.

declare -a array1
host="10.0.48.214"
user=claudio
pass=smarc2011
datetime=$(date +%Y%m%d)
filename=/var/local/arrays
pathbkp=/var/local/dumps
a=0

args=("-h $host -u $user -p$pass" "-h $host -u $user -p$pass --opt ") 

mysqlshow ${args[0]} > $filename

counts=( `cat "$filename" | sed -e '/+/d' | tr -d '|' | sed -e '/Database/d'| sed -e '/information_schema/d' | wc -w `)
array1=( `cat "$filename" | sed -e '/+/d' | tr -d '|'  | sed -e '/Database/d' | sed -e '/information_schema/d'` )


while [ $a -lt $counts ]
       	    do
		echo ${array1[$a]}-$datetime.sql
		mysqldump ${args[1]} ${array1[$a]} > $pathbkp/${array1[$a]}-$datetime.sql
		let a+=1
            done

echo
exit 0
