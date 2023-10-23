from sqlalchemy import inspect
import tabula
import pandas as pd
from database_utils import DatabaseConnector
from data_cleaning import DataCleaning
import re
import requests
import boto3
import json
import pandas as pd
from io import StringIO
path="https://data-handling-public.s3.eu-west-1.amazonaws.com/card_details.pdf"    

headers = {"x-api-key":"yFBQbwXe9J3sd6zWVAMrK6lcxxr0q1lr2PT6DDMX"}
url=" https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/number_stores"
url2="https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/store_details/1"
#Create class DataExtrator to extract data from tables RDS database provided
class DataExtrator:
    # the method that extract database table to a pandas dataframe
    def read_rds_table(table):
        DatabaseConnector.init_db_engine().execute('''SELECT * FROM %s'''%(table)).fetchall()
        users = pd.read_sql_table(table, DatabaseConnector.init_db_engine())
        return users
    def list_db_tables(engine):

        inspector = inspect(engine)
    
        return inspector.get_table_names()
    #the method that returns a pdf file in a dataframe 
    def retrieve_pdf_data(path):
        path="https://data-handling-public.s3.eu-west-1.amazonaws.com/card_details.pdf"
        tabula.convert_into("https://data-handling-public.s3.eu-west-1.amazonaws.com/card_details.pdf", "C:/Users/laura/OneDrive/Desktop/MRDC/output.csv", output_format="csv", pages='all')
        dfs2= pd.read_csv('C:/Users/laura/OneDrive/Desktop/MRDC/output.csv')
        return dfs2
    ##############-------------------Tomorrow ask for help------------------------------------
    # the method that return the number of stores
    def list_number_of_stores(url, headers):
        response = requests.get(url, headers=headers)
        repos=response.json()
        return repos

    # the method that return the store data
    def retrieve_stores_data(url2):
        data_store=[]
        for i in range((DataExtrator.list_number_of_stores(url, headers))['number_stores']):
            response = requests.get("https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/store_details/%s"%i, headers=headers)
            data_store.append(response.json())
        df=pd.DataFrame.from_dict(data_store) 
        print(df)
        return df

    def extract_from_s3(bucket, key):
        s3 = boto3.client('s3')
        obj = s3.get_object(Bucket=bucket, Key=key)
        data = obj['Body'].read().decode('utf-8')
        df = pd.read_csv(StringIO(data))
        return df

    # the method that return the json data
    def extrac_json():
        s3 = boto3.client('s3')
        obj = s3.get_object(Bucket='data-handling-public', Key='date_details.json')
        j = json.loads(obj['Body'].read())
        return j
    

# ### ------------------------UPLOAD user data in database----------------------------------------------
DatabaseConnector.upload_to_db(DataCleaning.standardise_phone_number(DataCleaning.clean_user_data(DataExtrator.read_rds_table('legacy_users')).phone_number), 'dim_users') 

# ### ------------------------UPLOAD card data in database----------------------------------------------
path="https://data-handling-public.s3.eu-west-1.amazonaws.com/card_details.pdf" 

DatabaseConnector.upload_to_db(DataCleaning.clean_card_data(DataExtrator.retrieve_pdf_data(path)), 'dim_card_details') 



# ### ------------------------UPLOAD store data in database----------------------------------------------
DatabaseConnector.upload_to_db(DataCleaning.called_clean_store_data(DataExtrator.retrieve_stores_data(url2)),'dim_store_details')

# ### ------------------------UPLOAD product data in database----------------------------------------------
bucket = 'data-handling-public'
key = 'products.csv'
DatabaseConnector.upload_to_db(DataCleaning.clean_product_data(DataCleaning.convert_product_weights(DataExtrator.extract_from_s3(bucket, key))), 'dim_products')


# ### ------------------------UPLOAD order data in database----------------------------------------------

DatabaseConnector.upload_to_db(DataCleaning.clean_order_data(DataExtrator.read_rds_table('orders_table')), 'orders_table')


# ### ------------------------UPLOAD JSON data in database----------------------------------------------
DatabaseConnector.upload_to_db(DataCleaning.clean_json(DataExtrator.extrac_json()),'dim_date_times')





