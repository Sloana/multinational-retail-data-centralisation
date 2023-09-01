from sqlalchemy import inspect
import pandas as pd
from database_utils import DatabaseConnector
from data_cleaning import DataCleaning
#Create class DataExtrator to extract data from tables RDS database provided
class DataExtrator:
    def read_rds_table():
        DatabaseConnector.init_db_engine().execute('''SELECT * FROM legacy_users''').fetchall()
        users = pd.read_sql_table('legacy_users', DatabaseConnector.init_db_engine())
        print(users)
        return users
#Data extracted and cleaned will be saved in the local database named sale_data in the localhost
DatabaseConnector.upload_to_db(DataCleaning.clean_user_data(DataExtrator.read_rds_table())) 