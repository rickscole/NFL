#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jul 27 13:12:20 2025

PURPOSE:
    Get all Game IDs from most recent, and transfer to blob


NOTES:
    202507271507,rsc
    manually hard code for now
    
    202507271507, rss
    for whatever reason, somestimes the game dic is empty

    https://docs.google.com/document/d/1dmTtsvDZdA64_WlaRRuijPj8PW4QogTSZvbWuQJLwRI/edit?tab=t.0
    
@author: rsc
"""


#%% IMPORT LIBRARIES


## import libraries
import http.client
import json
import pandas as pd
from azure.storage.blob import BlobServiceClient
from io import StringIO


#%% GET DATA FROM API


## variables
current_season = 2025 #202507271507


## create connection
conn = http.client.HTTPSConnection("nfl-football-api.p.rapidapi.com")
headers = {
    'x-rapidapi-key': "",
    'x-rapidapi-host': "nfl-football-api.p.rapidapi.com"
}


## get data
conn.request("GET", "/nfl-scoreboard?year=" + str(current_season), headers=headers)
res = conn.getresponse()
data = res.read()
my_json = data.decode('utf8').replace("'", '"')
my_json = data.decode('utf8').replace("'", 'APOSTROPHE')
json_loads = json.loads(my_json)


#%% ASSEMBLE DATA


## loop through games
game_id_list = []
season_list = []
for game in json_loads['events']: #foreach game in season
    if len(game) > 0: #202507271507
        game_id = game['id']
        
        game_id_list.append(game_id)
        season_list.append(current_season)


## create dataframe
df = pd.DataFrame({'game_id' : game_id_list, 'season' : season_list})


#%% UPLOAD TO BLOBS


## blob credentials
azure_storage_connection_string = 'https://docs.google.com/document/d/1dmTtsvDZdA64_WlaRRuijPj8PW4QogTSZvbWuQJLwRI/edit?tab=t.0' 
container_name = 'nfl'
blob_name = 'nfapi current season game'


## write to blob
blob_service_client = BlobServiceClient.from_connection_string(azure_storage_connection_string) # create the BlobServiceClient
container_client = blob_service_client.get_container_client(container_name) # get the container client
csv_buffer_upload = StringIO() # convert DataFrame to CSV (in memory, no disk needed)
df.to_csv(csv_buffer_upload, index=False)  # index=False if you don't want pandas index column
blob_client = container_client.get_blob_client(blob_name)
blob_client.upload_blob(csv_buffer_upload.getvalue(), overwrite=True)



