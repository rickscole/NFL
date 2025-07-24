#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 24 12:20:23 2025

this is to find what time is the Vikings, and finding JJs ID

@author: rcole
"""



import http.client
import json

conn = http.client.HTTPSConnection("nfl-football-api.p.rapidapi.com")

headers = {
    'x-rapidapi-key': "16b08d3c3emshba4d425ac4bc9a9p1e6e4cjsn0b14d9c5bece",
    'x-rapidapi-host': "nfl-football-api.p.rapidapi.com"
}

conn.request("GET", "/nfl-team-roster?id=16", headers=headers)

res = conn.getresponse()
data = res.read()

my_json = data.decode('utf8').replace("'", '"')
json_loads = json.loads(my_json)


#with open(r'/Users/rcole/Desktop/imacgration/lfn/texttxt.txt', "w") as f:
#   json.dump(data, f)
