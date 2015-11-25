setwd("~/Dropbox/Datalogi/dm819/assignments/assignment2/R")
library(ggplot2)


testDir <- "../results"
files <- list.files(path=testDir, pattern="*.txt", full.names=T, recursive=FALSE)
files <- files[which(file.info(files)$size>0)]
data <- do.call(rbind, lapply(files, read.table, header=TRUE, sep="\t"))

ggplot(data,aes(factor(dim),searchTime,color = alg)) +
   geom_boxplot(outlier.size = 1,outlier.colour = "grey") +
   #geom_point() +
   #scale_x_log10() + 
   scale_y_log10()

ggplot(data,aes(n,memory,color = alg)) +
   ggtitle("Memory vs input size") + 
   geom_point(aes(shape=factor(dim)),size = 2,alpha=0.5)+
   scale_shape_manual(values = c(1,2,3,4,5)) +
   scale_x_log10() + 
   scale_y_log10()
   #ylim(0,0.00000075)

