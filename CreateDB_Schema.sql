--Change the data type in orders table where in three of them need to be calculated the max length.
select max(length(card_number)) as max_card_nr, max(length(store_code)) as max_store_code, max(length(product_code))from orders_table;
ALTER TABLE orders_table
ALTER COLUMN date_uuid TYPE UUID USING date_uuid::UUID,
ALTER COLUMN user_uuid TYPE UUID USING user_uuid::UUID,
ALTER COLUMN card_number TYPE VARCHAR(19),
ALTER COLUMN store_code TYPE VARCHAR(12),
ALTER COLUMN product_code TYPE VARCHAR(11),
ALTER COLUMN product_quantity TYPE SMALLINT using product_quantity::SMALLINT;

-- change the type of data in the following columns in table dim_users.
select max(length(country_code)) as max_card_nr from dim_users;

ALTER TABLE dim_users
ALTER COLUMN first_name TYPE VARCHAR(255),
ALTER COLUMN last_name TYPE VARCHAR(255),
ALTER COLUMN date_of_birth TYPE DATE USING date_of_birth::DATE,
ALTER COLUMN country_code TYPE VARCHAR(3),
ALTER COLUMN user_uuid TYPE UUID USING user_uuid::UUID,
ALTER COLUMN join_date TYPE DATE using join_date::DATE;

-- Change data type in dim_store_details table and also some cleaning need to be sorted.

delete from dim_store_details where store_code is null;
select max(length(store_code)) as max_store_code, max(length(country_code)) as max_country_code from dim_store_details;


ALTER TABLE dim_store_details
ALTER COLUMN longitude TYPE FLOAT USING nullif(trim(nullif(longitude,'N/A')),'')::double precision,
ALTER COLUMN locality TYPE VARCHAR(255),
ALTER COLUMN store_code TYPE VARCHAR(12),
ALTER COLUMN staff_numbers TYPE SMALLINT USING staff_numbers::SMALLINT,
ALTER COLUMN opening_date TYPE date USING opening_date::DATE,
ALTER COLUMN store_type TYPE VARCHAR(255),
ALTER COLUMN latitude TYPE FLOAT USING nullif(trim(nullif(latitude,'N/A')),'')::double precision,
ALTER COLUMN country_code TYPE VARCHAR(10),
ALTER COLUMN continent TYPE VARCHAR(255);

-- Add a new column to_dim products that classifies the products in four categories regarding their weight:Light, mid_sized, heavy and Truck required.
-- Also some cleaning need to be done.
select * from dim_products;
delete from dim_products
WHERE product_price='ODPMASE7V7';
delete from dim_products
WHERE product_price='XCD69KUI0K';

delete from dim_products
WHERE product_price='N9D2BZQX63';
select * from dim_products;


alter table dim_products alter column product_price type text using (replace(product_price, '£', '')::varchar);


delete from dim_products where product_code is null;

select * from dim_products;

ALTER TABLE dim_products 
ALTER COLUMN weight TYPE FLOAT 
USING weight::real;


ALTER TABLE dim_products
ADD weight_class VARCHAR(15); 

UPDATE dim_products
SET weight_class = 'Light' where weight< 2;

UPDATE dim_products
SET weight_class = 'Mid_Sized' where weight>=2 and weight <40;

UPDATE dim_products
SET weight_class = 'Heavy' where weight>=40 and weight<140;

UPDATE dim_products
SET weight_class = 'Truck_Required' where weight>=140;


-- change type of data 
Alter table dim_products
rename column Removed TO still_avaliable;

select * from dim_products;

delete from dim_products
WHERE product_code is null;

select max(length(product_code)) as max_product_code, max(length(weight_class)) as weight_class from dim_products;

UPDATE dim_products
SET still_avaliable = 1 
where still_avaliable='Still_avaliable';


UPDATE dim_products
SET still_avaliable = 0 
where still_avaliable='Removed';

ALTER TABLE dim_products
ALTER COLUMN product_price TYPE FLOAT USING product_price::double precision;

ALTER TABLE dim_products
ALTER COLUMN weight TYPE FLOAT USING weight:: real;

ALTER TABLE dim_products
ALTER COLUMN product_code TYPE VARCHAR(11),
ALTER COLUMN date_added TYPE DATE USING date_added ::DATE,
ALTER COLUMN uuid TYPE UUID using uuid::UUID,
ALTER COLUMN still_avaliable TYPE BOOL USING still_avaliable::boolean,
ALTER COLUMN weight_class TYPE VARCHAR(14);

-- change data type in following columns, but first should be checked the max length for month, year, day, and time_period.
select max(length(month)), max(length(year)), max(length(day)), max(length(time_period)) from dim_date_times;
-- Also we have deleted some errorness in records.
delete from dim_date_times
where length(date_uuid)<36;

Alter table dim_date_times
ALTER COLUMN month TYPE VARCHAR(10),
ALTER COLUMN year TYPE VARCHAR(10),
ALTER COLUMN day TYPE VARCHAR(10),
ALTER COLUMN time_period TYPE VARCHAR(10),
ALTER COLUMN date_uuid TYPE UUID USING (date_uuid ::UUID);


-- Change the type of data in dim_card_details table
select max(length(card_number)) as max_card_nr, max(length(expiry_date)) as max_date_nr, max(length(date_payment_confirmed))from dim_card_details;
select * from dim_card_details
where card_number like '?%';
alter table dim_card_details alter column card_number type text using (replace(card_number, '?', ''));
delete from dim_card_details where card_number='card_number';
delete from dim_card_details where card_number is null;
delete from orders_table where card_number is null;
ALTER Table dim_card_details 
ALTER COLUMN card_number TYPE VARCHAR(22),
ALTER COLUMN expiry_date TYPE VARCHAR(11),
ALTER COLUMN date_payment_confirmed TYPE DATE USING (date_payment_confirmed ::DATE);



-- Add primary keys for each table 
ALTER TABLE dim_date_times ADD PRIMARY KEY (date_uuid);
ALTER TABLE dim_card_details ADD PRIMARY KEY (card_number);
ALTER TABLE dim_products ADD PRIMARY KEY (product_code);
ALTER TABLE dim_store_details ADD PRIMARY KEY (store_code);
ALTER TABLE dim_users ADD PRIMARY KEY (user_uuid);


-- ADD foreign keys in orders_table

ALTER TABLE orders_table
    ADD CONSTRAINT fk_orders_card FOREIGN KEY (card_number) REFERENCES dim_card_details (card_number);
	
ALTER TABLE orders_table
    ADD CONSTRAINT fk_date_times FOREIGN KEY (date_uuid) REFERENCES dim_date_times (date_uuid);
	

ALTER TABLE orders_table
    ADD CONSTRAINT fk_products FOREIGN KEY (product_code) REFERENCES dim_products (product_code);
	
ALTER TABLE orders_table
    ADD CONSTRAINT fk_store FOREIGN KEY (store_code) REFERENCES dim_store_details (store_code);
	
	
ALTER TABLE orders_table
    ADD CONSTRAINT fk_users FOREIGN KEY (user_uuid) REFERENCES dim_users (user_uuid);