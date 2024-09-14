#view the ev_data
select * from electric_vehicle_population_data;

#rename the column names
alter table electric_vehicle_population_data
rename column `Model Year` to model_year,
rename column `Electric Vehicle Type` to ev_type,
rename column `Electric Range` to electric_range,
rename column `Base MSRP` to base_MSRP,
rename column `Legislative District` to legislative_district,
rename column `Vehicle Location` to vehicle_location,
rename column `2020 Census Tract` to 2020_census_trac;

#top 5 cities with the most ev
select distinct city, count(*) as EV_number from electric_vehicle_population_data
group by city order by count(*) desc limit 5;

#percentage of ev population city ranking
select ev_data.city, ev_data.EV_number, wa_population.POP_2024, 
(ev_data.EV_number/wa_population.POP_2024)*100 as EV_percentage
from (select distinct city, count(*) as EV_number from electric_vehicle_population_data
group by city order by count(*)) as ev_data
join wa_population
on ev_data.city = wa_population.city
order by EV_percentage desc;

#top 5 counties with the most ev
select county, count(*) as EV_number from electric_vehicle_population_data
group by county order by EV_number desc limit 5;

select COUNTY, sum(POP_2024) as county_pop from wa_population group by COUNTY;

select distinct ev_data.County, ev_data.EV_number, wa_pop.county_pop, 
(ev_data.EV_number/wa_pop.county_pop)*100 as EV_percentage
from ((select County, count(*) as EV_number from electric_vehicle_population_data
group by County order by EV_number) as ev_data, 
(select COUNTY, sum(POP_2024) as county_pop from wa_population group by COUNTY) as wa_pop)
join wa_population
on ev_data.County = wa_pop.COUNTY
order by EV_percentage desc; 

#Best Range
alter table electric_vehicle_population_data
add column year_make_model varchar(255);
SET SQL_SAFE_UPDATES = 0;
UPDATE electric_vehicle_population_data
SET year_make_model = CONCAT(model_year, make, model);
SET SQL_SAFE_UPDATES = 1;
select year_make_model, electric_range from electric_vehicle_population_data
order by electric_range desc limit 1;

#Cheapest

#Average Cost

#Average Mileage
select year_make_model, avg(electric_range) as avg_mileage from electric_vehicle_population_data
group by year_make_model order by avg_mileage desc limit 10;

#Most Cost Effective

#Most Popular EV Model
select model, count(*) as EV_sales from electric_vehicle_population_data
group by model order by EV_sales desc limit 10;

#Year with the most EV manufactured
select model_year, count(*) as EV_Produced from electric_vehicle_population_data
group by model_year order by count(*) desc; 
