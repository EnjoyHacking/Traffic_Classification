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

omp <- function(train, test, trlab, regu, iter.num){
    # Regularization
    if (regu == 1){
        D <- scale(as.matrix(t(train)))
        message("Scaling Done!")
    }
    if (regu == 2){
        D <- apply(as.matrix(t(train)), 2, function(x) x / norm(x,'2'))
    }
    
    # omp algorithm to be used later
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
                atom.index <- which(max(tmp) == tmp)[1]
                if(atom.index %in% Phi.p){
                    tmp = tmp[-atom.index]
                } else{
                    Phi.p[i] <- atom.index
                    break
                }
            }
            #             message("Selection Done!")
            
            
            #             message(paste("Zeros:",sum(round(tmp,2) < 0.01)),"\n")
            
            
            # step 3
            Phi = as.matrix(D[, as.numeric(na.omit(Phi.p))])
            P = Phi%*%solve(t(Phi)%*%Phi)%*%t(Phi)
            
            
            #             message(paste("Dimension:", nrow(P),
            #                           "\nRank:",qr(P)$rank,"\n"))
            
            
            # step 5
            residual = (diag(1,nrow(P)) - P) %*% residual
            #             message("Residual computation Done!")
        }
        
        # majority voting
        freq <- table(trlab[Phi.p])
        # select the most frequently one
        f.pred <- factor(names(freq[which(max(freq) == freq)]), levels(trlab))
        # if mutiple classes present, then select the first one
        if(length(f.pred) > 1){
            f.pred <- factor(trlab[Phi.p[1]], levels(trlab))
        }
        #         message("Prediction Done!")
        f.pred
        #         
        #         select the first one
        #         factor(trlab[Phi.p[1]], levels(trlab))
    }
    omp.predict <- apply(test, 1, omp.iter)
    omp.predict
}


# omp.model
omp.249 <- function(p, tr.num, tt.num, dataset, rand.seed, method, regu, iter.num){    
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
    nfea <- ncol(df$train)
    omp.tr.predict <- omp(df$train[,1:(nfea - 1)], df$train[train.idx, 1:(nfea - 1)], df$train[,nfea], regu = regu, iter.num = iter.num)
    omp.tr.accu <- table(omp.tr.predict, df$train[train.idx, nfea])
    
    ompt <- proc.time()
    # test test
    omp.tt.predict <- omp(df$train[,1:(nfea - 1)], df$test[, 1:(nfea - 1)], df$train[,nfea], regu = regu, iter.num = iter.num)
    omp.tt.accu <- table(omp.tt.predict, df$test[, nfea])
    time <- round((proc.time() - ompt)[3], 3)
    
    # return the result
    result <- list(train = omp.tr.accu, test = omp.tt.accu, time = time)
    message(paste("Time take: ",time))
    result
}