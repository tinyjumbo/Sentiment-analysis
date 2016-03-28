# -*- coding: utf-8 -*-
"""
Created on Sat Mar 12 12:49:21 2016

@author: YI
"""

import pandas as pd
import re
import nltk
from nltk.corpus import stopwords
from senti_classifier import senti_classifier

#read csv and convert datetime format to date format 
def read(a):
    tweet=pd.read_csv(a)
    date=tweet['time']
    text=tweet['text']
    day=pd.to_datetime(date,format='%Y-%m-%d')
    day=day.map(lambda x: x.strftime('%Y-%m-%d'))
    text = map(lambda x: [x], text)
    tweet=pd.DataFrame(text,index=day,columns=['Text'])
    return tweet
    
tweet=read('amazon.csv')

#filter data based on date
sub226=tweet.loc[['2016-02-26']]

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
def corpus(sub):
    num_text=sub['Text'].size
    cleantext=[]
    for i in xrange(0,num_text):
        cleantext.append(words(sub['Text'][i]))
    return cleantext
        
sub=corpus(sub226) 

#calculate the sentiment score
def sentiment_score(dataset, sample):
    count = net_sum = 0
    for sentence in dataset:
        if count%sample==0:
            pos_score, neg_score = senti_classifier.polarity_scores([sentence])
            #print "pos_score: " + str(pos_score) + "  neg_score" + str(neg_score)
            count += 1
            if (pos_score - neg_score)>0:
                net_sum += 1
    length = count / sample + 1
    score = net_sum * 1.0 / length 
    return score

