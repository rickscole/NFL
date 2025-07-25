#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 24 12:20:23 2025

JJ and Tredavious Wihite, to test out different positions
and this one is stacked now (since they have different stats)

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


#player_ids = ['4262921', '4429205']
#player_ids = ['4262921']
#player_ids = ['3042717']
player_ids = ['3042717', '4262921']
player_id_list = []
game_id_list = []
stats_value_list = []
stats_type_list = []
for player in player_ids:
    
    
    ## compile and send request
    conn.request("GET", "/nfl-ath-gamelog?id=" + player, headers=headers)
    res = conn.getresponse()
    
    ## download data
    data = res.read()
    my_json = data.decode('utf8').replace("'", '"')
    json_loads = json.loads(my_json)
    
    a = json_loads['seasonTypes']
    b = a[1]
    c = b['categories']
    d = c[0]
    e = d['events']
    stats_type = json_loads['labels']
    
    for game in e:
        game_id = game['eventId']
        stats_value_list.extend(game['stats'])
        game_id_list.extend([game_id] * len(stats_type))
    
    ## add to player list
    player_id_list.extend([player] * len(e) * len(stats_type))
    stats_type_list.extend(stats_type * len(e))

df = pd.DataFrame({'player_id' : player_id_list, 'game_id' : game_id_list, 'stat_type' : stats_type_list, 'stat_value' : stats_value_list})

#with open(r'/Users/rcole/Desktop/imacgration/lfn/texttxt.txt', "w") as f:
#   json.dump(data, f)
