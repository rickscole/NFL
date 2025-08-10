#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 23 22:40:21 2025

@author: rcole
"""


import http.client
import json

conn = http.client.HTTPSConnection("nfl-football-api.p.rapidapi.com")

headers = {
    'x-rapidapi-key': "",
    'x-rapidapi-host': "nfl-football-api.p.rapidapi.com"
}

conn.request("GET", "/nfl-ath-statistics?year=2023&id=14876", headers=headers)

res = conn.getresponse()
data = res.read()

my_json = data.decode('utf8').replace("'", '"')
a = json.loads(my_json)
b = a['statistics']
c = b['splits']
d = c['id']
da = c['name']
db = c['abbreviation']
dc = c['type']
dd = c['categories']
e = dd[0] 
f = e['stats']
g = f[0]


#print(a.keys())

with open(r'/Users/rcole/Desktop/imacgration/lfn/texttxt.txt', "w") as f:
    json.dump(dd, f)
