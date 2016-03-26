# -*- coding: utf-8 -*-
"""
Created on Fri Mar 25 20:21:49 2016

@author: YI
"""

import pandas as pd
import re
import nltk
from nltk.corpus import stopwords

#read csv
amazon=pd.read_csv('amazon.csv')

#create a function to pre-process the text
def words(text):
    text=re.sub(r'''(?i)\b((?:https?://|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))''', \
    '',text,flags=re.MULTILINE)
    letters=re.sub('[^a-zA-Z]', ' ', text)
    words=letters.lower().split()
    stop=set(stopwords.words('english'))
    meanfulwords=[w for w in words if not w in stop]
    return(' '.join(meanfulwords))
     
#create a loop to get the clean text
num_text=amazon['text'].size
cleantext=[]
for i in xrange(0,num_text):
    cleantext.append(words(amazon['text'][i]))