#!/bin/bash

databases=$(mysql -uroot -p123456 -e "SHOW DATABASES")


basepath='/var/lib/mysql/'


if [ ! -d "$basepath" ]; then

mkdir -p "$basepath"

fi

echo $databases

for db in ${databases}

do

if [ "$db" = "Database" ]; then

continue

fi

if [ "$db" = "information_schema" ]; then

continue

fi

if [ "$db" = "performance_schema" ]; then

continue

fi

if [ ! -d "$basepath$db" ]; then 

mkdir -p "$basepath$db"

fi

echo $db

mysqldump -uroot -p123456 $db > $basepath$db/$db-$(date +%Y%m%d).sql

find $basepath$db -mtime +7 -name '*.sql' | xargs rm -rf

done
