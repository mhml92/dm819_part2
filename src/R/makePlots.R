setwd("/home/mikkel/Dropbox/Datalogi/dm819/assignments/assignment2/src/R/")
library(ggplot2)


testDir <- "../results"
files <- list.files(path=testDir, pattern="*.txt", full.names=T, recursive=FALSE)
files <- files[which(file.info(files)$size>0)]
data <- do.call(rbind, lapply(files, read.table, header=TRUE, sep="\t"))

ggplot(data,aes(factor(dim),searchTime,color = alg)) +
   geom_boxplot(outlier.size = 1,outlier.colour = "darkgrey") +
   scale_y_log10()

data_rangeTree <- data[which(data$alg == "rangeTree"),]
data_kdTree <- data[which(data$alg == "kdTree"),]

ggplot(data_rangeTree,aes(n,memory,color = factor(dim))) +
   theme(legend.position="top") + 
   ggtitle("Memory vs input size") + 
   geom_point() + 
   geom_line(alpha = 0.5)+
   scale_x_log10(breaks=unique(data_rangeTree$n))

ggplot(data_kdTree,aes(n,memory,color = factor(dim))) +
   theme(legend.position="top") + 
   ggtitle("Memory vs input size") + 
   geom_point() + 
   geom_line(alpha = 0.5)+
   scale_x_log10(breaks=unique(data_kdTree$n))