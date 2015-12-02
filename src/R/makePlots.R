setwd("/home/mikkel/Dropbox/Datalogi/dm819/assignments/assignment2/src/R/")
library(ggplot2)

WRITE_TO_REPORT = T
printPlot <- function(myPlot,name){
   if(WRITE_TO_REPORT){
      f <- paste("plots/",name,".pdf", sep = "")
      print(f)
      pdf(file = f)
      print(myPlot)
      dev.off()
   }else{
      myPlot
   }
}
testDir <- "../results"
files <- list.files(path=testDir, pattern="*.txt", full.names=T, recursive=FALSE)
files <- files[which(file.info(files)$size>0)]
data <- do.call(rbind, lapply(files, read.table, header=TRUE, sep="\t"))
boxplot <- ggplot(data,aes(factor(dim),searchTime,color = alg)) +
   theme(legend.position="top") + 
   geom_boxplot(outlier.size = 1,outlier.colour = "darkgrey") +
   scale_y_log10()
printPlot(boxplot,"boxplot")

data_rangeTree <- data[which(data$alg == "rangeTree"),]
data_kdTree <- data[which(data$alg == "kdTree"),]

rtmem <- ggplot(data_rangeTree,aes(n,memory,color = factor(dim))) +
   theme(legend.position="top") + 
   ggtitle("Memory vs input size") + 
   geom_point() + 
   geom_line(alpha = 0.5) +
   ylab("Memory (MB)")
printPlot(rtmem,"rtmem")

kdmem <- ggplot(data_kdTree,aes(n,memory,color = factor(dim))) +
   theme(legend.position="top") + 
   ggtitle("Memory vs input size") + 
   geom_point() + 
   geom_line(alpha = 0.5)+
   ylab("Memory (MB)")
printPlot(kdmem,"kdmem")

# rangetree searchtime/outputsize

# rt <- data[which(data$alg == "rangeTree"),]
# ggplot(
#    rt,
#    aes(
#       x = outputSize,
#       y = searchTime,
#       color = factor(dim),
#       shape = factor(alg))
#    ) +
#    geom_point(alpha=0.5) +
#    scale_y_log10() + 
#    theme(legend.position="top")  
# 
# ggplot(
#    data[which(data$alg == "kdTree"),],
#    aes(
#       x = outputSize,
#       y = searchTime,
#       color = factor(dim),
#       shape = factor(alg))
#    ) +
#    theme(legend.position="top") + 
#    geom_point() 