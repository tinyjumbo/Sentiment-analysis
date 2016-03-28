# -*- coding: utf-8 -*-
"""
Created on Sun Mar 27 20:56:56 2016

@author: YI
"""

def sentiment_score(dataset, sample):
	count = pos_sum = neg_sum = net_sum=0
	for sentence in dataset:
		if count%sample==0:
			pos_score, neg_score = senti_classifier.polarity_scores([sentence])
			print "pos_score: " + str(pos_score) + "  neg_score" + str(neg_score)
		count += 1
        if pos_score > neg_score:  #if pos_score - neg_score > 0 in the sentence, we plus 1
        	net_sum += 1
        length = count / sample + 1
        score = net_sum / length 
	return score
