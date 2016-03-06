library(tm)
library(NLP)
library(openNLP)
library(twitteR)
library(RCurl)
library(bitops)
library(ROAuth)
library(plyr)
library(SnowballC)  
library(wordcloud)
library(slam)
library(dplyr)
library(ggplot2)

#read csv
tweet=read.csv('tweet.csv')
tweet=read.csv('amazon.csv')
tweet=read.csv('facebook.csv')
tweet=select(tweet,1,2)
day=as.Date(tweet$time)
tweet=data.frame(day,tweet$text)
day215=filter(tweet, day=='2016-02-15')
day216=filter(tweet, day=='2016-02-16')
day217=filter(tweet, day=='2016-02-17')
day218=filter(tweet, day=='2016-02-18')
day219=filter(tweet, day=='2016-02-19')
day220=filter(tweet, day=='2016-02-20')
day221=filter(tweet, day=='2016-02-21')
day222=filter(tweet, day=='2016-02-22')
day223=filter(tweet, day=='2016-02-23')
day224=filter(tweet, day=='2016-02-24')
day225=filter(tweet, day=='2016-02-25')
day226=filter(tweet, day=='2016-02-26')
day227=filter(tweet, day=='2016-02-27')
day228=filter(tweet, day=='2016-02-28')
day229=filter(tweet, day=='2016-02-29')
day301=filter(tweet, day=='2016-03-01')
day302=filter(tweet, day=='2016-03-02')
day303=filter(tweet, day=='2016-03-03')
day304=filter(tweet, day=='2016-03-04')
day305=filter(tweet, day=='2016-03-05')
daynew=filter(tweet, day==Sys.Date())

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
  which_pos = Terms(dtm) %in% pos
  
  # identify negative terms
  which_neg <- Terms(dtm) %in% neg
  
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


t215=scoreCorpus(day215$tweet.text,pos,neg)
t216=scoreCorpus(day216$tweet.text,pos,neg)
t217=scoreCorpus(day217$tweet.text,pos,neg)
t218=scoreCorpus(day218$tweet.text,pos,neg)
t219=scoreCorpus(day219$tweet.text,pos,neg)
t220=scoreCorpus(day220$tweet.text,pos,neg)
t221=scoreCorpus(day221$tweet.text,pos,neg)
t222=scoreCorpus(day222$tweet.text,pos,neg)
t223=scoreCorpus(day223$tweet.text,pos,neg)
t224=scoreCorpus(day224$tweet.text,pos,neg)
t225=scoreCorpus(day225$tweet.text,pos,neg)
t226=scoreCorpus(day226$tweet.text,pos,neg)
t227=scoreCorpus(day227$tweet.text,pos,neg)
t228=scoreCorpus(day228$tweet.text,pos,neg)
t229=scoreCorpus(day229$tweet.text,pos,neg)
t301=scoreCorpus(day301$tweet.text,pos,neg)
t302=scoreCorpus(day302$tweet.text,pos,neg)
t303=scoreCorpus(day303$tweet.text,pos,neg)
t304=scoreCorpus(day304$tweet.text,pos,neg)
t305=scoreCorpus(day305$tweet.text,pos,neg)
tnew=scoreCorpus(daynew$tweet.text,pos,neg)

t225=0.167


date=c('2016-02-16','2016-02-17','2016-02-18','2016-02-19', '2016-02-20','2016-02-21',
       '2016-02-22', '2016-02-23', '2016-02-24','2016-02-25','2016-02-26','2016-02-27',
       '2016-02-28','2016-02-29','2016-03-01','2016-03-02','2016-03-03','2016-03-04','2016-03-05')

date=append(date,toString(Sys.Date()))

score=c(t216, t217, t218, t219,t220,t221,t222,t223,t224,t225,t226,t227,t228,t229,t301,
        t302,t303,t304,t305)

score=append(score,tnew)

result=data.frame(date,score)
result %>%
  ggplot(aes(x=date, y=score,group=1)) + 
  geom_point()+
  geom_line()+
  labs(title="Sentiment Analysis")

#####


