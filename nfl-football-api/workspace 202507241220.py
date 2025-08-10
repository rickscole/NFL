#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 23 22:40:21 2025

Here we successfully get down to game level data ... 
but Im not sure who the player is 
So will return to this


@author: rcole
"""


import http.client
import json

conn = http.client.HTTPSConnection("nfl-football-api.p.rapidapi.com")

headers = {
    'x-rapidapi-key': "",
    'x-rapidapi-host': "nfl-football-api.p.rapidapi.com"
}

conn.request("GET", "/nfl-ath-gamelog?id=14876", headers=headers)

res = conn.getresponse()
data = res.read()

my_json = data.decode('utf8').replace("'", '"')
json_loads = json.loads(my_json)

a = json_loads['seasonTypes']
b = a[0]
c = b['categories']
d = c[0]
e = d['events']
f = e[0]
g = f['stats']
#b = a['401547229']
#c = b['gameResult']




with open(r'/Users/rcole/Desktop/imacgration/lfn/texttxt.txt', "w") as f:
    json.dump(json_loads, f)
