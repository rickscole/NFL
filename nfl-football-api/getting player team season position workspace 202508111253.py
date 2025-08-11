#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 11 09:40:05 2025

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


'''
conn.request("GET", "/nfl-boxscore?id=401038115", headers=headers)

res = conn.getresponse()
data = res.read()
my_json = data.decode('utf8').replace("'", '"')(
my_json = data.decode('utf8').replace("'", 'APOSTROPHE')
json_loads = json.loads(my_json)
json_loads['boxscore']['players'][0]['statistics']
'''


#teams = [22, 1, 33, 2, 29, 3, 4, 5, 6, 7, 8, 9, 34, 11, 30, 12, 13, 24, 14, 15, 16, 17, 18, 19, 20, 21, 23, 25, 26, 27, 10, 28]
teams = [23, 25, 26, 27, 10, 28]
seasons = list(range(2013, 2025 + 1))
player_id_list = []
team_id_list = []
season_list = []
player_name_list = []
position_list = []


for team in teams:
    counter_02 = 0
    print(team)
    for season in seasons:
        print(season)
        conn.request("GET", "/nfl-team-depthcharts?year=" + str(season) + "&id=" + str(team), headers=headers)
        
        
        res = conn.getresponse()
        data = res.read()
        my_json = data.decode('utf8').replace("'", '"')
        my_json = data.decode('utf8').replace("'", 'APOSTROPHE')
        json_loads = json.loads(my_json)
        
        #a = json_loads['depthcharts']['items'][0]['positions']
        #json_loads['depthcharts']['items'][2]['positions']['lt']
        counter_01 = 0
        for off_def_sp in json_loads['depthcharts']['items']:
            positions = off_def_sp['positions']
            for position_key, position_value in positions.items():
                position_name = position_value['position']['abbreviation']
                
                number_of_players = len(position_value['athletes'])
                for athlete in position_value['athletes']:
                    player_id = athlete['athlete']['id']
                    player_name = athlete['athlete']['fullname']
                     
                    player_id_list.append(player_id)
                    player_name_list.append(player_name)
                    counter_01 = counter_01 + 1
                    counter_02 = counter_02 + 1
                position_list.extend([position_name] * number_of_players)
            
        
        season_list.extend([season] * counter_01)
    team_id_list.extend([team] * counter_02)    
    

df_result = pd.DataFrame({ 'player_id' : player_id_list, 'team_id' : team_id_list, 'season' : season_list, 'player_name' : player_name_list, 'position' : position_list })
#df_result = pd.DataFrame({ 'player_id' : player_id_list, 'season' : season_list, 'player_name' : player_name_list, 'position' : position_list })
#df_team = pd.DataFrame({'team' : team_id_list})

#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/player_team_season_position_01.csv', index = False)
#df_result.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/player_team_season_position_02.csv', index = False)
#df_team.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/thing_02.csv', index = False)
        
        
                
        


