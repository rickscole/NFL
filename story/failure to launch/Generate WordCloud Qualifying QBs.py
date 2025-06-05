#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun  4 13:39:15 2025

@author: rsc

PURPOSE:
    Generate a WordCloud from a CSV, and save to image

NOTES:
    202506050949
    Apart of the NFL QBR Failure to Launch story (schema: qbrftl)
    
    202506050950
    The native separator for the wordcloud is the space, so first we replace the space with "_".
    Later, we inject the space back in.
"""


#%% IMPORT LIBARIES


## import libraries
import pandas as pd
from wordcloud import WordCloud
import matplotlib.pyplot as plt
import random


#%% DEFINE FUNCTIONS


# create a custom color function
def random_color_func(word, font_size, position, orientation, random_state=None, **kwargs):
    return random.choice(colors)


#%% READ DATA


# variables
csv_file_path = r'/Users/rcole/Desktop/imacgration/lfn/qbrftl nfl qualifying qb.csv'
text_column_name = 'name_display'
count_column = 'number_of_regimes'
colors = ['#6c869d', '#a3c6d9', '#c5e2e2', '#eb5b38', '#2f3647']
output_file_path = r'/Users/rcole/Desktop/imacgration/lfn/qbrftl nfl qualifying qb.png'


# load the CSV
df = pd.read_csv(csv_file_path)
df['full_name_fixed'] = df[text_column_name].astype(str).str.replace(' ', '_') #202506050950


#%% CREATE WORDCLOUD


# combine all text from the column into a single string
text = ' '.join(df['full_name_fixed'].astype(str).tolist())

# create the word cloud
wordcloud = WordCloud(width=800, height=400, background_color='white', collocations=False).generate(text) #create wordcloud
frequencies = dict(zip(df['full_name_fixed'], df[count_column])) #create dictionary object
frequencies_display = {word.replace('_', ' '): freq for word, freq in frequencies.items()} #202506050950
final_wordcloud = WordCloud(width=800, height=400, background_color='white', collocations=False).generate_from_frequencies(frequencies_display)
final_wordcloud = final_wordcloud.recolor(color_func=random_color_func) #randomly assign colors from the color palette


#%% SAVE IMAGE


# save the word cloud to a file
final_wordcloud.to_file(output_file_path)
