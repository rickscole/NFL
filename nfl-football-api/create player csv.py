#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 24 16:41:07 2025

trying to get player id

@author: rcole
"""


import http.client
import json
import pandas as pd



conn = http.client.HTTPSConnection("nfl-football-api.p.rapidapi.com")

headers = {
    'x-rapidapi-key': "",
    'x-rapidapi-host': "nfl-football-api.p.rapidapi.com"
}


id_list = []
first_name_list = []
last_name_list = []
full_name_list = []
display_name_list = []
short_name_list = []
team_id_list = []
teams = [22, 1, 33, 2, 29, 3, 4, 5, 6, 7, 8, 9, 34, 11, 30, 12, 13, 24, 14, 15, 16, 17, 18, 19, 20, 21, 23, 25, 26, 27, 10, 28]
for team in teams:
    conn.request("GET", "/nfl-team-roster?id=" + str(team), headers=headers)
    
    res = conn.getresponse()
    data = res.read()
    
   
    
    my_json = data.decode('utf8').replace("APOSTROPHE", '"')
    json_loads = json.loads(my_json)
    a = json_loads['athletes']
    for player in a:
        id_value = player['id']
        first_name = player['firstName']
        last_name = player['lastName']
        full_name = player['fullName']
        display_name = player['displayName']
        short_name = player['shortName']
        
        id_list.append(id_value)
        first_name_list.append(first_name)
        last_name_list.append(last_name)
        full_name_list.append(full_name)
        display_name_list.append(display_name)
        short_name_list.append(short_name)
    
    team_id_list.extend([team] * len(a))

df = pd.DataFrame({ 'external_id' : id_list, 'first_name' : first_name_list, 'last_name' : last_name_list, 'full_name' :  full_name_list
                   , 'display_name' : display_name_list , 'short_name' : short_name_list, 'team_id' : team_id_list })
df.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/nfapi_nfl_player.csv', index = False)


    


#with open(r'/Users/rcole/Desktop/imacgration/lfn/texttxt.txt', "w") as file:
#    file.write(str(data))
