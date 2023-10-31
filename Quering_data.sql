--How many stores the business has and  in which countries.
select * from dim_store_details;

select country_code as country, count(store_code) as total_no_stores from dim_store_details
Group by country_code
order by count(store_code) Desc;

-- which location currently has the most stores
select locality, count(store_code) as total_no_stores from dim_store_details
Group by locality
order by count(locality) Desc
limit 7;

--which month produces the highest amount in sales
SELECT sum((dim_products.product_price)*(orders_table.product_quantity)) as total_sales, dim_date_times.month as months 
FROM orders_table
Inner JOIN dim_date_times ON dim_date_times.date_uuid = orders_table.date_uuid
Inner JOIN dim_products ON orders_table.product_code = dim_products.product_code
group by dim_date_times.month
order by sum((dim_products.product_price)*(orders_table.product_quantity)) desc
limit 6;

-- how many sales are coming from online?

select * from dim_store_details;


Alter table dim_store_details
add column store_online VARCHAR(15); 

UPDATE dim_store_details
SET store_online = 'Web' where store_type='Web Portal';

UPDATE dim_store_details
SET store_online = 'offline' where store_type !='Web Portal';

SELECT count(dim_store_details.store_online) as number_of_sales, sum(orders_table.product_quantity) as product_quanitity_count,
dim_store_details.store_online as location
FROM orders_table
inner JOIN dim_store_details ON dim_store_details.store_code = orders_table.store_code
inner JOIN dim_products ON orders_table.product_code = dim_products.product_code
group by dim_store_details.store_online;


-- what percentage of sales comes through each type of store?
SELECT sum((dim_products.product_price)*(orders_table.product_quantity)),cast(sum((dim_products.product_price)*(orders_table.product_quantity))/
(SELECT sum((dim_products.product_price)*(orders_table.product_quantity))as total_sales
FROM orders_table
Inner JOIN dim_date_times ON dim_date_times.date_uuid = orders_table.date_uuid
Inner JOIN dim_products ON orders_table.product_code = dim_products.product_code)*100 AS DOUBLE PRECISION),dim_store_details.store_type as store_type
FROM orders_table
Inner JOIN dim_store_details ON dim_store_details.store_code = orders_table.store_code
Inner JOIN dim_products ON orders_table.product_code = dim_products.product_code
group by dim_store_details.store_type
order by sum((dim_products.product_price)*(orders_table.product_quantity)) DESC;

-- Find which month in which year have had the most sales historically?

SELECT sum((dim_products.product_price)*(orders_table.product_quantity)) as total_sales, dim_date_times.year as year,dim_date_times.month as months
FROM orders_table
Inner JOIN dim_date_times ON dim_date_times.date_uuid = orders_table.date_uuid
inner JOIN dim_products ON orders_table.product_code = dim_products.product_code
group by dim_date_times.month,
dim_date_times.year
order by sum((dim_products.product_price)*(orders_table.product_quantity)) desc
limit 10;


-- what is our staff headcount?
--delete from dim_store_details where staff_numbers !~ '^-?([0-9]+\.?[0-9]*|\.[0-9]+)$';

UPDATE dim_store_details
SET staff_numbers = '78' where staff_numbers='J78';

UPDATE dim_store_details
SET staff_numbers = '39' where staff_numbers='3n9';

UPDATE dim_store_details
SET staff_numbers = '97' where staff_numbers='A97';

UPDATE dim_store_details
SET staff_numbers = '80' where staff_numbers='80R';

UPDATE dim_store_details
SET staff_numbers = '30' where staff_numbers='30e';

SELECT sum(cast(staff_numbers as numeric)), country_code 
FROM dim_store_details
group by country_code;

-- Which german store type is selling the most?
SELECT sum((dim_products.product_price)*(orders_table.product_quantity)) as total_sales, dim_store_details.store_type as store_type
,dim_store_details.country_code as country
FROM orders_table
Inner JOIN dim_store_details ON dim_store_details.store_code = orders_table.store_code
inner JOIN dim_products ON orders_table.product_code = dim_products.product_code
where dim_store_details.country_code='DE' and dim_store_details.store_type !='Web portal'
group by dim_store_details.store_type,
dim_store_details.country_code
order by total_sales desc;

-- How quickly the company is making sales?


Alter table dim_date_times
ALTER COLUMN timestamp type timestamp using timestamp::timestamp;
	   
select year, to_char(avg(diff), '"hours:"HH24 ", minutes:"MI ", seconds:"SS ", milliseconds:"MS') as actuale_time_taken from (select year, cast(year || '-' || month  || '-' || day  || ' ' ||timestamp  as timestamp) as ts_value,
LEAD(cast(year || '-' || month  || '-' || day  || ' ' ||timestamp  as timestamp),1) OVER (ORDER BY (cast(year || '-' || month  || '-' || day  || ' ' ||timestamp  as timestamp)) desc) next_order, 
AGE(cast(year || '-' || month  || '-' || day  || ' ' ||timestamp  as timestamp),(LEAD(cast(year || '-' || month  || '-' || day  || ' ' ||timestamp  as timestamp),1) OVER (ORDER BY (cast(year || '-' || month  || '-' || day  || ' ' ||timestamp  as timestamp)) desc))) as diff
from dim_date_times) di
	   group by year
	   order by avg(diff) desc
	   limit 5;

