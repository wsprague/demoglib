#!/bin/bash

PSQL='/usr/local/postgresql-8.4.1/bin/psql'

set -e 

# # create sql statements from shapefiles and import
# if [ -e orwa_tracts.sql ]; then
# 	echo "tracts already imported" 1>&2
# else 
# 	echo "importing tracts" 1>&2
# 	shp2pgsql  OR_WA_TR -s 4326 -i -I  OR_WA_TR orwa_tracts > orwa_tracts.sql
# 	psql opensqlcamp2009 -f orwa_tracts.sql
# fi

# if [ -e orwa_zips.sql ]; then 
# 	echo "zips already imported" 1>&2
# else
# 	echo "importing zips" 1>&2
# 	shp2pgsql  OR_WA_ZP -s 4326 -i -I  OR_WA_ZP orwa_zips > orwa_zips.sql
# 	psql opensqlcamp2009 -f orwa_zips.sql 
# fi 

# Run the tutorial script
i=0
while `true`; do
	let '++i'
	echo "running tutorial script -- $i"
	$PSQL opensqlcamp2009  -e -f tutorial.sql 1>tutorial.$i.out 2>tutorial.$i.err
	sleep 1
done