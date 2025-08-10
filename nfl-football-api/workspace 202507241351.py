#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 24 12:20:23 2025

here we have found the desired endpoint

@author: rcole
"""



import http.client
import json

conn = http.client.HTTPSConnection("nfl-football-api.p.rapidapi.com")

headers = {
    'x-rapidapi-key': "",
    'x-rapidapi-host': "nfl-football-api.p.rapidapi.com"
}

conn.request("GET", "/nfl-ath-gamelog?id=4262921", headers=headers)

res = conn.getresponse()
data = res.read()

my_json = data.decode('utf8').replace("'", '"')
json_loads = json.loads(my_json)

a = json_loads['seasonTypes']
b = a[1]
c = b['categories']
d = c[0]
e = d['events']


receptions = e[0]['stats'][0]
receiving_targets = e[0]['stats'][1]
receiving_yards = e[0]['stats'][2]
yards_per_reception = e[0]['stats'][3]
receiving_touchdowns = e[0]['stats'][4]
long_reception = e[0]['stats'][5]
rushing_attempts = e[0]['stats'][6]
rushing_yards = e[0]['stats'][7]
yards_per_rush_attempt = e[0]['stats'][8]
long_rushing = e[0]['stats'][9]
rushing_touchdowns = e[0]['stats'][10]
fumbles = e[0]['stats'][11]
fumbles_lost = e[0]['stats'][12]
fumbles_forced = e[0]['stats'][13]
kicks_blocked = e[0]['stats'][14]



#with open(r'/Users/rcole/Desktop/imacgration/lfn/texttxt.txt', "w") as f:
#   json.dump(data, f)
