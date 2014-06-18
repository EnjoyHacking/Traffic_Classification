rm(list = ls())

# setting working directory
setwd("D:/Traffic Classification/code/249/")
setwd("./data/")
file.list <- list.files(".")
file.list

library(foreign)

t.start <- proc.time()
df <- do.call(rbind, lapply(list.files(path=".", pattern="entry")[1:1], read.arff))
t.end <- proc.time() - t.start 
message(paste("Read files completed!\nCost time:",round(t.end[3],3)))

# rename colnames to according codes
names(df) <- paste0("C",1:ncol(df))

# trim those factors predictors, since they have a lot of NA
dfa <- df[, -c(65:68, 71:72)]
rm(df)
dim(dfa)

# delete almost zero variable
nzv1 <- nearZeroVar (dfa, saveMetrics = T)
nzv1

nzv
length(nzv)
?nearZeroVar

# explory analysis of this datafile
names(df)
summary(df)
library(plyr)
s1 <- apply(df,2, function(i) length(unique(i)) / length(i) )
sum(round(s1,2) < 0.001)

ddply(df, .(C249), summarize, count = length(C249))
