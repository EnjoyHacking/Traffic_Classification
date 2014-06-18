rm(list = ls())
load("D:/Traffic Classification/code/249/data/.RData")
# setting working directory
setwd("D:/Traffic Classification/code/249/")
setwd("./data/")
file.list <- list.files(".")
file.list

# install and load relevant packages
packages <- c("foreign", "ggplot2", "plyr", "nnet", "class", "caret", "stringr")
packages.list <- packages %in% rownames(installed.packages())
if (sum(!packages.list) != 0)
    install.packages(packages[!packages.list])
sapply(packages, require, character.only = T)

file.num = 4
# read 249 features file.num files from the folder.
t.start <- proc.time()
df <- do.call(rbind, lapply(list.files(path=".", pattern="entry")[1:file.num], read.arff))
t.end <- proc.time() - t.start 
message(paste("Read files completed!\nCost time:",round(t.end[3],3)))

# rename colnames to according to codes in the paper
names(df) <- paste0("C",1:ncol(df))

# A basic explory analysis of this datafile
# dimension of the dataset
dim(df)

# find the percentage of near-zero features
nzf <- apply(df,2, function(i) length(unique(i)) / length(i) )
sum(round(nzf,2) < 0.001)
# detect the names of features with unique values less than 0.1%
which(round(nzf,2) < 0.001)
nzf*100

# trim those factors predictors, since they have a lot of NA
df <- subset(df, select = -c(C65, C66, C67, C68, C71, C72))
dim(df)

# a summary of traffic classification
class.count <- ddply(df, .(C249), summarize, count = length(C249))
class.count

# trim the class observations less than 400
class.idx <- class.count$C249[class.count$count > 400]
class.idx

# subset dfa with class whose has observations larger than 400
df <- df[df$C249 %in% class.idx,]

# detect number of NA in every features
naf <- apply(df, 2, function(i) sum(is.na(i)))
naf

# trim all the na features
df <- subset(df, select = -c(C69, C70, C73, C209))
df <- na.omit(df)

# a summary of traffic classification
class.count1 <- ddply(df, .(C249), summarize, count = length(C249))
class.count1

# check that all NAs have been removed
sum(is.na(df))

setwd("..")
source("sample.R")
# subset the dataset by 1% and sample 100 datapoints as training
dfs <- sample.dataset2(p = 0.1, tt.num = 100, dataset = df, rand.seed = 2014)
# summary of class counts
class.count.train <- ddply(dfs$train, .(C249), summarize, count = length(C249))
class.count.train
class.count.test <- ddply(dfs$test, .(C249), summarize, count = length(C249))
class.count.test


source("omp.R")
accm <- omp(train = dfs$train[,1:ncol(dfs$train) - 1], 
            test = dfs$test[,1:ncol(dfs$test) - 1], trlab = dfs$train[,ncol(dfs$train)], regu = 1, iter.num = 20)
accm
sum(diag(table(dfs$test[, ncol(dfs$test)], accm))) / length(accm)

idx <- c(1:40)
iter <- rep(c(1, 2, 5, 10, 15, 20, 25, 50), 5)
length(iter)
seed <- 2000 + rep(c(1, 2, 3, 4, 5), each = 8)
length(seed)

rlist <- lapply(idx, function(i) omp.249(p = 0.1, tr.num = 100, 
                                         tt.num = 100, dataset = df, 
                                         rand.seed = seed[i], method = 2, 
                                         regu = 1, iter.num = iter[i]))
source("ploterror.R")
pdf("omp.pdf", width = 12, height = 6)
plot.error2(step = iter, rlist = rlist, title = "OMP")
dev.off()
