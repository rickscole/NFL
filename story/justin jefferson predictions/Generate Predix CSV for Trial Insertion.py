#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 27 14:00:57 2025


PURPOSE:
    For use in JJPRX project
    Generate CSV of linear regression predictions, for trial ingestion into DB


NOTES:
    202506281435
    Credentials link
    https://docs.google.com/document/d/1dmTtsvDZdA64_WlaRRuijPj8PW4QogTSZvbWuQJLwRI/edit?tab=t.0


@author: rcole
"""


#%% IMPORT LIBRARIES


## import libraries
import pandas as pd
from azure.storage.blob import BlobServiceClient
from io import BytesIO
from io import StringIO
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score


#%% VARIABLES


test_size = 0.33


#%% ZDERC


# zderc for azure blob
# 202506281435
azure_storage_connection_string = '' 
container_name = 'nfl'
blob_name = 'jjprx time series input.csv'


#%% GET DATA


# Connect to blob service
blob_service_client = BlobServiceClient.from_connection_string(azure_storage_connection_string)


# Get the blob client
blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)


# Download blob content as bytes
blob_data = blob_client.download_blob()
csv_content = blob_data.readall().decode('utf-8')


#%% DEFINE DATA

# Convert CSV content to DataFrame
df = pd.read_csv(StringIO(csv_content))
df.set_index('player_game_id', inplace=True)



## partition dataset
y = df['actual']
x_columns = ['instant_trend', 'short_trend', 'medium_trend', 'intermediate_trend', 'long_trend']
x = df[[c for c in df.columns if c in x_columns]]


## divide dataset into train and test
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size = test_size, random_state = 42)


#%% CREATE MODEL


## Fit a linear regression model
model = LinearRegression(fit_intercept = False)
model.fit(x_train, y_train)
y_fit = list(model.predict(x_train))
y_predix = list(model.predict(x_test))
 

## define variable and create lists
max_index_value = max(df.index)
train_length = len(y_train)
test_length = len(y_test)
number_of_predictions = 12
id_list = list(y_train.index) + list(y_test.index) + list(range(max_index_value + 1, max_index_value + 1 + number_of_predictions))
train_test_predix_list = ['train'] * train_length + ['test'] * test_length + ['predix'] * number_of_predictions


## generate predictions
values_list = list(y)
#intercept = model.intercept_
instant_coef = list(model.coef_)[0]
short_coef = list(model.coef_)[1]
medium_coef = list(model.coef_)[2]
intermediate_coef = list(model.coef_)[3]
long_coef = list(model.coef_)[4]
for i in range(1, number_of_predictions + 1):
    instant_trend = sum(values_list[-2:])/2
    short_trend = sum(values_list[-4:])/4
    medium_trend = sum(values_list[-8:])/8
    intermediate_trend = sum(values_list[-16:])/16
    long_trend = sum(values_list[-32:])/32
    prediction = instant_coef * instant_trend + short_coef * short_trend + medium_coef * medium_trend + intermediate_coef * intermediate_trend + long_coef * long_trend
    values_list.append(prediction)



#%% WRITE TO CSV


## write to local csv
df = pd.DataFrame({ 'id' : id_list, 'forecast_value' : values_list, 'forecast_type' : train_test_predix_list})
df.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/jjprx predix 202506281413.csv', index = False)





