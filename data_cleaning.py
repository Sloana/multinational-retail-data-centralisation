import pandas as pd

class DataCleaning:
    def clean_user_data(table):
        table.drop(index=table[table['user_uuid']=='NULL'].index, inplace=True)
        print(table.info())
        table.drop(index=table[table['user_uuid'].str.len()!=36].index, inplace=True)
        print(table.info())
        table.phone_number=table.phone_number.str.translate({ord('+'): None})
        table.phone_number=table.phone_number.str.translate({ord('.'): None})
        table.phone_number=table.phone_number.str.translate({ord(' '): None})
        if table.phone_number[[1,2]].all()!='00':
            table.phone_number='00'+table.phone_number
        print("Columns that have missing values are: ", table[table.columns[table.isnull().all()]])
        table["date_of_birth"]=pd.to_datetime(table["date_of_birth"],infer_datetime_format=True, errors='coerce')
        return table
    def clean_card_data(card_table):
        print(card_table.info())
        #check is is any null value
        isnull=card_table.isnull().sum()
        print("Nr of null value in data users is=",isnull)
        print(pd.DataFrame(card_table))
        print(card_table.info())
        card_table.loc['date_payment_confirmed']=pd.to_datetime(card_table['date_payment_confirmed'],infer_datetime_format=True, errors='coerce')
        return (card_table)

    def called_clean_store_data (store_data):
        isnull=store_data.isnull().sum()
        print("Nr of null value in data users is=",isnull)
        store_data=store_data.drop_duplicates()
        return store_data
    def convert_product_weights(df):
        print(df)
        result = df.weight.str.extract('(\d+\.?\d+)([a-zA-Z]+)', expand=True)
        result.columns = ['Number','Text']
        result.loc[(result['Text']=='g')|(result['Text']=='ml'),'Number']=pd.to_numeric(result.loc[(result['Text']=='g')|(result['Text']=='ml'),'Number'])/1000
        print(result['Number'])
        df['weight']=result['Number']
        newdf=df
        print(newdf)
        return newdf
    def clean_product_data(df):
        print(df.info())
        df=df.drop_duplicates()
        return (df)
    def clean_order_data(table):
        table.drop(columns=['first_name','last_name','level_0'],inplace=True)
        return table
    def clean_json(data):
        df=pd.DataFrame.from_dict(data)
        df.drop_duplicates()
        return df
    def standardise_phone_number(phone_number):
        phone_number=phone_number.str.translate({ord('+'): None})
        phone_number=phone_number.str.translate({ord('.'): None})
        phone_number=phone_number.str.translate({ord(' '): None})
        if phone_number[[1,2]].all()!='00':
            phone_number='00'+phone_number
        return phone_number



