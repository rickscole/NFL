#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul 25 10:17:14 2025

@author: rcole
"""

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

conn.request("GET", "/nfl-team-list", headers=headers)

res = conn.getresponse()
data = res.read()

my_json = data.decode('utf8').replace("APOSTROPHE", '"')
json_loads = json.loads(my_json)
teams = json_loads['teams']

id_list = []
abbreviation_list = []
display_name_list = []
short_display_name_list = []
name_list = []
nickname_list = []
location_list = []
for team in teams:
    id_value = team['id']
    abbreviation = team['abbreviation']    
    display_name = team['displayName']
    short_display_name = team['shortDisplayName']
    name = team['name']
    nickname = team['nickname']
    location = team['location']
    
    id_list.append(id_value)
    abbreviation_list.append(abbreviation)
    display_name_list.append(display_name)
    short_display_name_list.append(short_display_name)
    name_list.append(name)
    nickname_list.append(nickname)
    location_list.append(location)

df = pd.DataFrame({ 'id' : id_list, 'abbreviation' : abbreviation_list, 'display_name' : display_name_list, 'short_display_name' : short_display_name_list
                   , 'name' : name_list, 'nickname' : nickname_list, 'location' : location_list})
df.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/nfapi_nfl_team.csv', index = False)


