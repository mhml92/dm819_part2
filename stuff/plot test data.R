library(ggplot2)
df <- read.table("testingRand.txt",sep = "\t",header = F)

points <- df[1:10000,]
names(points) <- c("x","y")
ggplot(data=points,aes(x = x,y=y)) + geom_point()
