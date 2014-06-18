# plot function
plot.error2 <- function(step, rlist, title = ""){
    require(gridExtra)
    if(length(rlist) == 1){
        tr.acc <- sum(diag(rlist$train)) / sum(rlist$train)
        tt.acc <- sum(diag(rlist$test)) / sum(rlist$test)
        time <- rlist$time
    } else{
        tr.acc <- sapply(rlist, function(i) sum(diag(i$train)) / sum(i$train))
        tt.acc <- sapply(rlist, function(i) sum(diag(i$test)) / sum(i$test))    
        time <- sapply(rlist, function(i) i$time)    
    }
    
    
    # calculate overall accuracy
    all.tr <- data.frame(step = step, acc = tr.acc, type = "train")
    all.tt <- data.frame(step = step, acc = tt.acc, type = "test")
    all.time <- data.frame(step = step, time = time)
    all.res <- rbind(all.tr, all.tt)
    
    all.p <- ddply(all.res, .(step, type), summarize, sd = sd(acc), mean = mean(acc), se = sd(acc)/sqrt(length(acc)), count = length(acc))
    all.time.p <- ddply(all.time, .(step), summarize, sd = sd(time), mean = mean(time), se = sd(time) / sqrt(length(time)), count = length(time))
    
    p1 <- ggplot(all.p, aes(x = step, y = mean, colour = type, label = round(mean,2))) + 
        geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 1, lwd = 0.7) +
        geom_line(lwd = 0.7) +
        geom_point(size = 2) +
        geom_text(size = 4, color = "black", hjust = 1) +
        theme_bw() +
        ggtitle(paste0(title, " on 249 features (rept num = ", unique(all.p$count), ")")) + 
        xlab("Iteration Number") +  
        ylab("Overall Accuracy")
    
    p2 <- ggplot(all.time.p, aes(x = step, y = mean, color = "red", label = round(mean,2))) + 
        geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 3, lwd = 0.7) +
        geom_line(lwd = 0.7) +
        geom_point(size = 2) +
        geom_text(size = 4, color = "black", hjust = 1) +
        theme_bw() +
        theme(legend.position="none") +
        ggtitle(paste0(title, "'s Average Computational Time")) + 
        xlab("Iteration Number") +  
        ylab("Time in Second") 
    grid.arrange(p1, p2, ncol = 2)
    
}

