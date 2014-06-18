# function name: sample.dataset1
# df <- sample.dataset1(tr.num = 1, tt.num = 100, dataset = isp, rand.seed = 0)
# sample tr.num and tt.num from dataset

# Input <
# tr.num        sample used for training set (1)
# tt.num        sample used for testing set (1)
# dataset       dataset to be used for sampling (isp)
# rand.seed     the seed use for generating random sample (0)

sample.dataset1 <- function(tr.num, tt.num, dataset, rand.seed){
    set.seed(rand.seed)
    class.names <- unique(dataset$class)
    class.index <- lapply(class.names, function(i) which(dataset$class == i))
    sample.index <- lapply(class.index, function(i) sample(i, tr.num + tt.num))
    train.index <- sapply(sample.index, function(i) i[1:tr.num])
    test.index <- sapply(sample.index, function(i) i[-c(1:tr.num)])
    df <- list(train = dataset[train.index,], test = dataset[test.index,])
    df
}


# function name: sample.dataset2
# df <- sample.dataset2(p = 0.20, tt.num = 100, dataset = isp, rand.seed = 0)
# sample p% proportion of the dataset as training set
# then use sample n of the rest of the dataset as testing set

# Input>
# p         proportion of the dataset to be sampled (0.1)
# dataset   the dataset to be splited into training and testing (isp)
# rand.seed the seed use for generating random sample (0)
# tt.num the number to be sampled to training dataset (100)

sample.dataset2 <- function(p, tt.num, dataset, rand.seed){
    set.seed(rand.seed)
    train.idx <- createDataPartition(dataset$C249, p = p , list = F)
    train <- dataset[train.idx, ]
    test.idx <- c(1:nrow(dataset))[-train.idx]
    test <- dataset[sample(test.idx, tt.num), ]
    df <- list(train = train, test = test)
    df
}
