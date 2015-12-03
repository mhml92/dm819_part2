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
testDir <- "../tests/dimension_2"

files <- list.files(path=testDir, pattern="*.txt", full.names=T, recursive=FALSE)
df_files <- data.frame(files)
df_files$n <- as.numeric((lapply(files,function(x){unlist(strsplit(x,"_"))[3]})))

points <-   data.frame(
               apply(
                  df_files[1,],
                  1,
                  function(x){
                     read.table(
                        file = as.character(x[[1]]), 
                        sep="\t",
                        nrows=as.numeric(x[[2]])
                     )
                  }
               )
            )
names(points) <- c("x","y","z")


drops <- c("z")

points <- points[,!(names(points) %in% drops)]

o <- data.frame(
   rbind(
      points[6,],
      points[26,],
      points[27,],
      points[47,],
      points[60,],
      points[69,],
      points[72,],
      points[89,],
      points[91,],
      points[93,],
      points[94,],
      points[98,]
   )
)


ggplot(points,aes(x=x,y=y)) + 
   geom_point() +
   geom_hline(yintercept = 4.7785591165336) +
   geom_hline(yintercept = 7.940836776702) +
   geom_vline(xintercept = 5.4305621081919) + 
   geom_vline(xintercept = 8.5928397683603) +
   geom_point(data = o, aes(x,y),color = "red")

#:	4.7785591165336:7.940836776702	,6	26	27	47	60	69	72	89	91	93	94	98	

data <- do.call(rbind, lapply(df_files, read.table, header=F, sep="\t",nrows=))

