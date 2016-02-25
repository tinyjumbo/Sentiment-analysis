# Sentiment-analysis-in-R

library(tm)
library(NLP)
library(tm.plugin.webmining)
library(tm.plugin.tags)
library(openNLP)
library(twitteR)
library(RCurl)
library(bitops)
library(RJSONIO)
library(ROAuth)
library(plyr)
library(SnowballC)  
library(wordcloud)
library(slam)
library(dplyr)

#read csv
tweet=read.csv('tweets.csv')
tweet=select(tweet,1,2)
day=as.Date(tweet$time)
tweet=data.frame(day,tweet$text)
day215=filter(tweet, day=='2016-02-15')
day216=filter(tweet, day=='2016-02-16')
day217=filter(tweet, day=='2016-02-17')
day218=filter(tweet, day=='2016-02-18')
day219=filter(tweet, day=='2016-02-19')
day220=filter(tweet, day=='2016-02-20')

#input positive and negtive words to R
pos = scan('positive-words.txt',
           what='character', comment.char=';')
neg = scan('negative-words.txt',
           what='character', comment.char=';')

#a function to score the corpus
scoreCorpus = function(text, pos, neg) {
  myCorpus = Corpus(VectorSource(text))
  myCorpus=tm_map(myCorpus,tolower)
  myCorpus=tm_map(myCorpus,removePunctuation)
  myCorpus=tm_map(myCorpus,removeNumbers)
  myCorpus=tm_map(myCorpus,removeWords,stopwords("english"))
  myCorpus=tm_map(myCorpus,stemDocument)
  myCorpus=tm_map(myCorpus,stripWhitespace)
  myCorpus=tm_map(myCorpus,PlainTextDocument)
  #termfreq_control = list(removePunctuation = TRUE,
                         # stemming=FALSE, stopwords=TRUE, wordLengths=c(2,100))
  dtm = DocumentTermMatrix(myCorpus)
  # term frequency matrix
 tfidf = weightTfIdf(dtm)
  # identify positive terms
  #pos.match=match(dtm,pos)
  which_pos = Terms(dtm) %in% pos
  
  # identify negative terms
  #neg.match=match(dtm,neg)
  which_neg <- Terms(dtm) %in% neg
  
 # pos.match = !is.na(pos.match)
  #neg.match = !is.na(neg.match)
  # number of positive terms in each row
  score_pos = row_sums(dtm[, which_pos])
  # number of negative terms in each row
  score_neg = row_sums(dtm[, which_neg])
  # number of rows having positive score makes up the net score
  net_score = sum((score_pos - score_neg)>0)
  # length is the total number of instances in the corpus
  length = length(score_pos - score_neg)
  #score = net_score /length
  score = net_score/length
  return(score)
}
