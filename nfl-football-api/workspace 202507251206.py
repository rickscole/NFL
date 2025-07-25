#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 24 12:20:23 2025

trying to get the working script
testing out on JJ and Addison
regular season only

@author: rcole
"""



import http.client
import json

conn = http.client.HTTPSConnection("nfl-football-api.p.rapidapi.com")

headers = {
    'x-rapidapi-key': "",
    'x-rapidapi-host': "nfl-football-api.p.rapidapi.com"
}


#player_ids = ['4262921', '4429205']
#player_ids = ['4262921']
player_ids = ['3042717']
player_id_list = []
game_id_list = []
receptions_list = []
receiving_targets_list = []
receiving_yards_list = []
yards_per_reception_list = []
receiving_touchdowns_list = []
long_reception_list = []
rushing_attempts_list = []
rushing_yards_list = []
yards_per_rush_attempt_list = []
long_rushing_list = []
rushing_touchdowns_list = []
fumbles_list = []
fumbles_lost_list = []
fumbles_forced_list = []
kicks_blocked_list = []

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
    
    for game in e:
        game_id = game['eventId']
        receptions = game['stats'][0]
        receiving_targets = game['stats'][1]
        receiving_yards = game['stats'][2]
        yards_per_reception = game['stats'][3]
        receiving_touchdowns = game['stats'][4]
        long_reception = game['stats'][5]
        rushing_attempts = game['stats'][6]
        rushing_yards = game['stats'][7]
        yards_per_rush_attempt = game['stats'][8]
        long_rushing = game['stats'][9]
        rushing_touchdowns = game['stats'][10]
        fumbles = game['stats'][11]
        fumbles_lost = game['stats'][12]
        fumbles_forced = game['stats'][13]
        kicks_blocked = game['stats'][14]
        
        game_id_list.append(game_id)
        receptions_list.append(receptions)
        receiving_targets_list.append(receiving_targets)
        receiving_yards_list.append(receiving_yards)
        yards_per_reception_list.append(yards_per_reception)
        receiving_touchdowns_list.append(receiving_touchdowns)
        long_reception_list.append(long_reception)
        rushing_attempts_list.append(rushing_attempts)
        rushing_yards_list.append(rushing_yards)
        yards_per_rush_attempt_list.append(yards_per_rush_attempt)
        long_rushing_list.append(long_rushing)
        rushing_touchdowns_list.append(rushing_touchdowns)
        fumbles_list.append(fumbles)
        fumbles_lost_list.append(fumbles_lost)
        fumbles_forced_list.append(fumbles_forced)
        kicks_blocked_list.append(kicks_blocked)
    
    ## add to player list
    player_id_list.extend([player] * len(e))



#with open(r'/Users/rcole/Desktop/imacgration/lfn/texttxt.txt', "w") as f:
#   json.dump(data, f)
