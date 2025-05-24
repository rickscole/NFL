#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May  7 17:28:55 2025
    
PURPOSE:
    Get data from NFLPY API (QBR-related endpoint) and transfer to Azure Blob


NOTES:

    ## 2025-05-08_1237
    Creds stored at:
    https://docs.google.com/document/d/1dmTtsvDZdA64_WlaRRuijPj8PW4QogTSZvbWuQJLwRI/edit?tab=t.0

@author: rscole
"""


#%% IMPORT LIBRARIES


## import libraries
import pandas as pd
from azure.storage.blob import BlobServiceClient
from io import BytesIO
from io import StringIO
import nfl_data_py as nfl 


#%% ZDERC


# zderc for azure blob
azure_storage_connection_string = 'TURNMUSICOFF' ## 2025-05-08_1237
container_name = 'nfl'
week_blob_name = 'qbr week.csv'
season_blob_name = 'qbr season.csv'


#%% GET DATA


## api calls to get dfs
qbr_data_season = nfl.import_qbr(level = 'nfl', frequency = 'season')
qbr_data_week = nfl.import_qbr(level = 'nfl', frequency = 'weekly')


#%% TRANSFER DATA TO BLOB


## create clients
blob_service_client = BlobServiceClient.from_connection_string(azure_storage_connection_string) # create the BlobServiceClient
container_client = blob_service_client.get_container_client(container_name) # get the container client


## upload season data
csv_buffer_season = StringIO() # convert DataFrame to CSV (in memory, no disk needed)
qbr_data_season.to_csv(csv_buffer_season, index=False)  # index=False if you don't want pandas index column
blob_client = container_client.get_blob_client(season_blob_name)
blob_client.upload_blob(csv_buffer_season.getvalue(), overwrite=True)


## upload season data
csv_buffer_week = StringIO() # convert DataFrame to CSV (in memory, no disk needed)
qbr_data_week.to_csv(csv_buffer_week, index=False)  # index=False if you don't want pandas index column
blob_client = container_client.get_blob_client(week_blob_name)
blob_client.upload_blob(csv_buffer_week.getvalue(), overwrite=True)




