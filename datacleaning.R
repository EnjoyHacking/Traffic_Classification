getwd()
setwd("./Data/")
dir()

# read the dataset as characters to avoid numeric rounding
df <- read.csv("lbl.csv", comment.char = "#", colClasses = 'character', header = F,skip = 10)
df <- df[,-ncol(df)]

# read the colnames and set df to the colnames
cnames <- readLines("lbl.csv",10)[10]
cnames <- strsplit(cnames, ",", fixed = T)
names(df) <- sub("#", "num", cnames[[1]], fixed = T)

# add two column indicating a human readable time stamp
df$first_packet_time <- as.POSIXct(as.numeric(df$first_packet), origin = "1970-01-01")
df$last_packet_time <- as.POSIXct(as.numeric(df$last_packet), origin = "1970-01-01")

# read the time stamp of every packet 
lines <- readLines("lblt.txt")
View(lines)

write.csv(df, "trace.csv")


lines <- readLines("lblt.txt")
View(lines)
head(lines)
head(grep("\\d{4}-\\d{2}-\\d{2}", lines, value = T))
install.packages("stringr")
library(stringr)
date <- str_extract(lines,"\\d{4}-\\d{2}-\\d{2}")
time <- str_extract(lines, "\\d{2}:\\d{2}:\\d{2}.\\d+")
srcip <- sub("IP ", "", str_extract(lines, "IP\\s\\d+\\.\\d+\\.\\d+.\\d+"))
srcport <- sub(" >", "", str_extract(lines, "\\d+\\s>"))
dstip <- sub("> ", "", str_extract(lines, "> \\d+.\\d+.\\d+.\\d+"))
dstport <- gsub("\\.|:", "", str_extract(lines, "\\.\\d+:"))
flag <- str_extract(lines,"\\[(.{1}|.{2})\\]")
seq <- sub("seq ", "",str_extract(lines, "seq\\s\\d+:\\d+"))
ack <- sub("ack ", "", str_extract(lines, "ack\\s\\d+"))
win <- sub("win ", "", str_extract(lines, "win\\s\\d+"))
length <- sub("length ", "", str_extract(lines, "length\\s\\d+"))

tdf <- data.frame(date = date, time = time, srcip = srcip, srcpot = srcport,
                  dstip = dstip, dstport = dstport, flag = flag, ack = ack, win = win, length = length)
View(tdf)

dim(tdf)
dim(df)

write.csv(tdf, "./tt.csv")

