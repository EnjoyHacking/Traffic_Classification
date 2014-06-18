# function omp: Orthogonal Matching Pursuit
# > input:
# train : the numeric feature matrix use for training
# test  : the numeric feature matrix use for testing
# trlab : the training label
# telab : the test label for evaluation of the algorithm
# regu  : regularization methods used
#    1  : (X - EX) / sd(X),  default
# other : X / ||X||_2, normalized by 2nd norm

# < output:
# return a vector of predicted class for test features
omp <- function(train, test, trlab, regu){
    # Regularization
    if (regu == 1){
        D <- scale(as.matrix(t(train)))
    }
    if (regu == 2){
        D <- apply(as.matrix(t(train)), 2, function(x) x / norm(x,'2'))
    }
    
    # omp algorithm to be used later
    iter.num = 6
    omp.iter <- function(f){
        Phi.p <- rep(NA, iter.num)
        for(i in 1:iter.num){
            
            # step 1
            if(i == 1){
                residual = scale(f)
            }
            
            # step 2
            tmp = abs(t(D) %*% residual)
            # donot select the same atom twice
            repeat{
                atom.index <- which(max(tmp) == tmp)
                if(atom.index %in% Phi.p){
                    tmp = tmp[-atom.index]
                } else{
                    Phi.p[i] <- atom.index
                    break
                }
            }
            
            message(paste("Zeros:",sum(round(tmp,2) < 0.01)),"\n")
            
            # step 3
            Phi = as.matrix(D[, as.numeric(na.omit(Phi.p))])
            P = Phi%*%solve(t(Phi)%*%Phi)%*%t(Phi)
            
            message(paste("Dimension:", nrow(P),
                          "\nRank:",qr(P)$rank,"\n"))
            
            # step 5
            residual = (diag(1,nrow(P)) - P) %*% residual
        }
        
        # majority voting
        freq <- table(trlab[Phi.p])
        factor(names(freq[which(max(freq) == freq)]), levels(trlab))
        
#         select the first one
#         factor(train.label[Phi.p[1]], levels(trlab))
    }
    omp.predict <- apply(test, 1, omp.iter)
    omp.predict
}


# omp.model
isp.omp <- function(p, tr.num, tt.num, dataset = isp, rand.seed, method, regu){
    ompt <- proc.time()
    # sample data
    if(method == 1){
        df <- sample.dataset1(tr.num, tt.num, dataset, rand.seed)
    } else {
        df <- sample.dataset2(p, tt.num, dataset, rand.seed)    
    }
    
    # train test
    ntrain <- nrow(df$train)
    if(ntrain <= 100){
        train.idx <- c(1:ntrain) 
    }else{
        train.idx <- sample(1:ntrain, 100)
    }
    omp.tr.predict <- omp(df$train[,5:10], df$train[train.idx, 5:10], df$train[ ,11], regu = 1)
    omp.tr.accu <- table(omp.tr.predict, df$train[train.idx, 11])
    
    # test test
    omp.tt.predict <- omp(df$train[,5:10], df$test[, 5:10], df$train[ ,11], regu)
    omp.tt.accu <- table(omp.tt.predict, df$test[, 11])
    
    # return the result
    result <- list(train = omp.tr.accu, test = omp.tt.accu)
    message(paste("Time take: ",round((proc.time() - ompt)[3], 3)))
    result
}

