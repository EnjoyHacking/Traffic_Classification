# plot function
plot.error2 <- function(rlist, title){
    tr.acc <- sapply(rlist, function(i) sum(diag(i$train)) / sum(i$train))
    tt.acc <- sapply(rlist, function(i) sum(diag(i$test)) / sum(i$test))
    
    # calculate overall accuracy
    all.tr <- data.frame(step = step, acc = tr.acc, type = "train")
    all.tt <- data.frame(step = step, acc = tt.acc, type = "test")
    
    all.res <- rbind(all.tr, all.tt)
    
    all.p <- ddply(all.res, .(step, type), summarize, sd = sd(acc), mean = mean(acc), se = sd(acc)/sqrt(length(acc)),count = length(acc))
    
    ggplot(all.p, aes(x = step, y = mean, colour = type, label = round(mean,2))) + 
        geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 10, lwd = 0.7) +
        geom_line(lwd = 0.7) +
        geom_point(size = 2) +
        geom_text(size = 4, color = "black", hjust = 1) +
        theme_bw() +
        ggtitle(paste(title, "on ISP (rept num = ", unique(all.p$count), ")")) + 
        xlab("Number per class") +  
        ylab("Overall Accuracy") 
}
