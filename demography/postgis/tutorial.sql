
-- magic with shp2pgsql here

BEGIN;

-- calculating polygon centroids, 

select * from geometry_columns; -- metadata table containing geometry columns

-- store and calculate centroids for zip codes

alter table orwa_zp add column the_geom_cent geometry; -- add a geometry type column
update orwa_zp set the_geom_cent = centroid(the_geom); -- create a centroid and store it
select populate_geometry_columns('orwa_zp'::regclass); -- update geometry metadata
select * from geometry_columns;	-- ... it worked!
create index orwa_zp_cent_idx on orwa_zp using gist (the_geom_cent);

-- illustrative selects

select id as zipcode, po_name || ', ' || st_abbrev as location, totpop_cy as population,  medhinc_cy,
		round(st_y(the_geom_cent)::numeric,6) as lat, round(st_x(the_geom_cent)::numeric,6) as long
	from orwa_zp
	order by id
	limit 10;
select id, st_asgeojson(the_geom_cent) from orwa_zp order by id limit 10;

-- store and calculate centroids for tracts
alter table orwa_tr add column the_geom_cent geometry; -- add a geometry type column
update orwa_tr set the_geom_cent = centroid(the_geom); -- create a centroid and store it
select populate_geometry_columns('orwa_tr'::regclass); -- update geometry metadata
create index orwa_tr_cent_idx on orwa_tr using gist (the_geom_cent);

-- don't know why i need these select dropgeometrycolumn('orwa_tr',
-- 'the_geom_cent'); select dropgeometrycolumn('orwa_zp', 'the_geom_cent');



-- Calculating distances between points, enter a zipcode and a distance (kilometers), find
-- all the tracts with a centroid within the radius

create or replace function get_nearby_tracts 
		(in text, in numeric) 
		returns table( zip text, "PO Name" text, tractfips text, population int, MHI int, cent_distance numeric) as $_$
	select a.id as zipcode, po_name || ', ' || a.st_abbrev as "PO Name", b.id as tractfips, 
			b.totpop_cy as population, b.medhinc_cy as MHI,
			round(st_distance_sphere(a.the_geom_cent, b.the_geom_cent)::numeric/1000, 4) as cent_distance
			from orwa_zp a, orwa_tr b
			where a.id = $1 and st_distance_sphere(a.the_geom_cent, b.the_geom_cent) <= $2 *1000
			order by st_distance_sphere(a.the_geom_cent, b.the_geom_cent);
$_$ language sql;

select * from get_nearby_tracts('97215',5);



-- and joining using geographic criteria.

create table crosswalk as 
	select a.id as zip, b.id as tractfips, 0.0 as area, 0.0 as propzip, 0.0 as proptract,
				st_intersection(a.the_geom, b.the_geom) as the_geom, a.the_geom as zip_geom, b.the_geom as tract_geom
		from orwa_zp a , orwa_tr b
		where st_intersects(a.the_geom, b.the_geom);
create index crosswalk_geom_idx on crosswalk using gist (the_geom);
update crosswalk set propzip = area(the_geom) / area(zip_geom);
update crosswalk set proptract = area(the_geom) / area(tract_geom);
select zip, tractfips, proptract, propzip from crosswalk order by zip, tractfips;


ROLLBACK;