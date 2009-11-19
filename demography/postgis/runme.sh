#!/bin/bash

set -e 

# create sql statements from shapefiles and import
if [ -e orwa_tracts.sql ]; then
	echo "tracts already imported" 1>&2
else 
	echo "importing tracts" 1>&2
	shp2pgsql  OR_WA_TR -s 4326 -i -I  OR_WA_TR orwa_tracts > orwa_tracts.sql
	psql opensqlcamp2009 -f orwa_tracts.sql
fi

if [ -e orwa_zips.sql ]; then 
	echo "zips already imported" 1>&2
else
	echo "importing zips" 1>&2
	shp2pgsql  OR_WA_ZP -s 4326 -i -I  OR_WA_ZP orwa_zips > orwa_zips.sql
	psql opensqlcamp2009 -f orwa_zips.sql 
fi 

# Run the tutorial script
echo "running tutorial script"
psql opensqlcamp2009 -e -f tutorial.sql 1>tutorial.out 2>tutorial.err