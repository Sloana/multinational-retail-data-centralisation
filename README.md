# Multinational-retail-data-centralisation

A company that sells various products across the world has data spread across different data sources and formats, making access and analysis difficult.
This project aims to create a system that stores the current company data in a database so data can be accessed from one central location.
After data is located in one database, query the database to get up-to-date metrics for business.


There are created three classes.
1. DataExtractor: it will create methods that will extract data from different sources, such as CSV, API, and S3 bucket.
2. DataConnector: it will create methods to connect and upload data into a database.
3. DataCleaning: It will be created methods that will clean the data to be ready for further analyses.


Methods created under the DataExtractor class are:
1. read_rds_table(table). This method extracts tables from Amazon RDS, where table is any table in the database.
2. list_db_tables (engine): list all tables from the Amazon RDS database.
3. retrieve_pdf_data(path). This method extracts data from the provided path: "https://data-handling-public.s3.eu-west-1.amazonaws.com/card_details.pdf.
4. retrieve_stores_data(url2) and list_number_of_stores(url, headers). These methods extract data from API-provided headers. {
"key": "x-api-key",
"value": "yFBQbwXe9J3sd6zWVAMrK6lcxxr0q1lr2PT6DDMX"
}
url=" https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/number_stores"
url2="https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/store_details/{store_number}"
5. extract_from_s3(bucket, key) and extrac_json() This method extracts data from S3 proved bucket and key.



Methods that are under the DataConnector class are:
1. init_db_engine() and init2_db_engine() are two methods that connect with Amazon RDS and local databases, respectively.
2. upload_to_db(table, name), which loads the table with the name 'name' in the local database.


Methods that are under the DataCleaning class are:
1. clean_user_data(table)
2. clean_card_data(card_table)
3. called_clean_store_data (store_data)
4. convert_product_weights(df)
5. clean_product_data(df)
6. clean_order_data(table)
7. clean_json(data)
8. standardise_phone_number(phone_number)
where the arguments in each method are tables or data sources that need to be cleaned.



# Creating Database Schema
After different resources have collected data, they are now located in the PGadmin database. Tables have been updated and changed, to be fitted for further analyses. Most of the tables have changed the datatype of most of the columns, also 
some cleaning has been done. Also, Primary keys and Foreign keys have been added to corresponding tables, so that to make them fit for queries in different tables.
# Quering the data
To answer some business questions, there needed to query of the data using different operations and aggregation. some of the business questions are: 
1. What percentage of sales comes through each type of store?
2. How quickly the company is making sales?
that is been addressed in the file Quering_data.sql
