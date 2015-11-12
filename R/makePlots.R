setwd("~/Dropbox/Datalogi/dm819/assignments/assignment2/R")
library(ggplot2)
testDir <- "../testResults"
files <- list.files(path=testDir, pattern="*.txt", full.names=T, recursive=FALSE)
data <- do.call(rbind, lapply(files, read.table, header=TRUE, sep="\t"))
ggplot(data,aes(x = outputSize,y=searchTime,fill = alg)) + geom_point()
       