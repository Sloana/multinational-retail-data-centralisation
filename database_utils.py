from sqlalchemy import inspect
import yaml
import json

# from data_extraction import DataExtrator
from data_cleaning import DataCleaning
from sqlalchemy import create_engine
import requests
with open('C:/Users/laura/OneDrive/Desktop/MRDC/db_creds.yaml', 'r') as stream:
    data_loaded = yaml.safe_load(stream)
with open('C:/Users/laura/OneDrive/Desktop/MRDC/db_creds.yml', 'r') as stream:
    data_in = yaml.safe_load(stream)
class DatabaseConnector:
    def read_db_creds():
        return data_loaded['read_db_creds']

    # print(read_db_creds())
    # init_db_engine() method is the menthod to connect with the data in amazone RDS
    def init_db_engine():
        # Database connection details with the RDS 
        DATABASE_TYPE = 'postgresql'
        DBAPI = 'psycopg2'
        ENDPOINT = DatabaseConnector.read_db_creds()['RDS_HOST']
        USER = DatabaseConnector.read_db_creds()['RDS_USER']
        PASSWORD = DatabaseConnector.read_db_creds()['RDS_PASSWORD']
        PORT = DatabaseConnector.read_db_creds()['RDS_PORT']
        DATABASE = DatabaseConnector.read_db_creds()['RDS_DATABASE']
        engine = create_engine(f"{DATABASE_TYPE}+{DBAPI}://{USER}:{PASSWORD}@{ENDPOINT}:{PORT}/{DATABASE}")
        engine.connect()
        return engine
      #  # init2_db_engine() method to connect with localhost
    def init2_db_engine():
        # Database connection details
        DATABASE_TYPE = 'postgresql'
        DBAPI = 'psycopg2'
        ENDPOINT = 'localhost'
        USER = 'postgres'
        PASSWORD = 'Sloana1989'
        PORT = 5432
        DATABASE = 'sale_data'
        engine = create_engine(f"{DATABASE_TYPE}+{DBAPI}://{USER}:{PASSWORD}@{ENDPOINT}:{PORT}/{DATABASE}")
        engine.connect()
        return engine
# the method that uploads tables with cleaned data in the local database named sale_data



    def upload_to_db(table, name):
        table.to_sql(name, DatabaseConnector.init2_db_engine(), if_exists='replace')
path="https://data-handling-public.s3.eu-west-1.amazonaws.com/card_details.pdf"    
engine=DatabaseConnector.init_db_engine()




