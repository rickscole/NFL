#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 26 15:15:42 2025

data goes back to 1920s season
i pass in the season, it spits out the game id
1997 gives an error so, I have to divide it up

NOTES:
    202507270911
    for whatever reason, sometimes the game dictionary is empty
    so have to check for this

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


#seasons = list(range(1998, 2025 + 1))
#seasons = list(range(1922, 2025 + 1))
#seasons = list(range(2024, 2024 + 1))
seasons = list(range(1997, 1997 + 1))
game_id_list = []
season_list = []
for season in seasons:
    
    print(season)
    
    conn.request("GET", "/nfl-scoreboard?year=" + str(season), headers=headers)
    res = conn.getresponse()
    data = res.read()
    my_json = data.decode('utf8').replace("'", '"')
    my_json = data.decode('utf8').replace("'", 'APOSTROPHE')
    json_loads = json.loads(my_json)
    
    ## 202507270911
    for game in json_loads['events']: 
        if len(game) > 0:
            game_id = game['id']
            
            game_id_list.append(game_id)
            season_list.append(season)
    
    #number_of_games = len(json_loads['events'])
    #season_list.extend([season] * number_of_games)


df = pd.DataFrame({ 'external_id' : game_id_list, 'season' : season_list})
#df.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/games_01.csv')
#df.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/games_02.csv')
#df.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/games_03.csv')
df.to_csv(r'/Users/rcole/Desktop/imacgration/lfn/games_04.csv')
        
