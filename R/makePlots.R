setwd("~/Dropbox/Datalogi/dm819/assignments/assignment2/R")
library(ggplot2)
data <- read.table(file = "test.txt",sep="\t", header = T)
ggplot(data = data,aes(x = outputSize,y = searchTime)) + geom_line()
