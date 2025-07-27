#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 26 15:15:42 2025

trying to figure out how to get data for past games
here i feed in a game id, and it spits out what I need
so id need a list of game ids

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

game_id = 401437954
conn.request("GET", "/nfl-boxscore?id=" + str(game_id), headers=headers)

res = conn.getresponse()
data = res.read()


my_json = data.decode('utf8').replace("'", '"')
my_json = data.decode('utf8').replace("'", 'APOSTROPHE')
json_loads = json.loads(my_json)

a = json_loads['boxscore']

player_id_list = []
game_id_list = []
stat_type_list = []
stat_value_list = []
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

game_id_list = [game_id] * len(player_id_list)

df = pd.DataFrame({'player_id' : player_id_list, 'game_id' : game_id_list, 'stat_type' : stat_type_list, 'stat_value' : stat_value_list})
