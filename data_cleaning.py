import pandas as pd

from database_utils import DatabaseConnector
class DataCleaning:
    def clean_user_data(table):
        #check is is any null value
        isnull=table.isnull().sum()
        print("Nr of null value in data users is=",isnull)

        #Check errors in dates
        date_format = "%Y-%m-%d"
        table["date_of_birth"]=pd.to_datetime(table["date_of_birth"],infer_datetime_format=True, errors='coerce')

       
        return table

