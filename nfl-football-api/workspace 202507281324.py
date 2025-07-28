#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 28 09:10:54 2025


getting player ids by game id (for various seasons)

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




#df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi game ids 2024.csv')
#df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi game ids 2023.csv')
#df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi game ids 2022.csv')
#df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi game ids 2021.csv')
#df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi game ids 2020.csv')
#df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi game ids 2019.csv')
#df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi game ids 2018.csv')
df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi game ids 2017.csv')
#df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi game ids 2016.csv')
#df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi game ids 2015.csv')
#df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi game ids 2014.csv')
#df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi game ids 2013.csv')
input_game_id_list = list(df['external_id'])


player_id_list = []
game_id_list = []
stat_type_list = []
stat_value_list = []



for game_id in input_game_id_list:

    print(game_id)
    conn.request("GET", "/nfl-boxscore?id=" + str(game_id), headers=headers)
    
    res = conn.getresponse()
    data = res.read()
    
    
    my_json = data.decode('utf8').replace("'", '"')
    my_json = data.decode('utf8').replace("'", 'APOSTROPHE')
    json_loads = json.loads(my_json)
    
    a = json_loads['boxscore']
    
    
    number_of_teams = len(a['players'])
    for team in a['players']:
        #player_team_category_stats_dic = team['statistics'][0]
        player_team_category_stats_dic = team['statistics']
        for stat in player_team_category_stats_dic:
        
            #if 'stats' in stat['athletes'][0]:
            if len(stat['athletes']) > 0:
                player_id = stat['athletes'][0]['athlete']['id']
                stat_type = stat['labels']
                stat_value = stat['athletes'][0]['stats']
                number_of_stats = len(stat_value)
                
                player_id_list.extend([player_id] * number_of_stats)
                stat_type_list.extend(stat_type)
                stat_value_list.extend(stat_value)
    
                #game_id_list = [game_id] * len(player_id_list)
                game_id_list.extend([game_id] * number_of_stats)

df_result = pd.DataFrame({'player_id' : player_id_list, 'game_id' : game_id_list, 'stat_type' : stat_type_list, 'stat_value' : stat_value_list})
#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi player game stats 2024.csv', index = False)
#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi player game stats 2023.csv', index = False)
#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi player game stats 2022.csv', index = False)
#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi player game stats 2021.csv', index = False)
#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi player game stats 2020.csv', index = False)
#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi player game stats 2019.csv', index = False)
#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi player game stats 2018.csv', index = False)
df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi player game stats 2017.csv', index = False)
#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi player game stats 2016.csv', index = False)
#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi player game stats 2015.csv', index = False)
#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi player game stats 2014.csv', index = False)
#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/example nfapi player game stats 2013.csv', index = False)
