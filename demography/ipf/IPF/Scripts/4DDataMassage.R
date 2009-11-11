#Read in the IPF functions.
source("R:/RA/RAPOP/EDDIE/IPF/Functions/ipf2df.txt")
source("R:/RA/RAPOP/EDDIE/IPF/Functions/ipf3df.txt")
source("R:/RA/RAPOP/EDDIE/IPF/Functions/ipf4df.txt")

#Read in the data.
pup<-read.table(file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/4DExample/Seed.csv", header=FALSE,sep=",")

#Update the dimensions here.
TableSize<-c(6,19,2,27) 
pup<-array(t(as.matrix(pup)),TableSize)

#Now we get the control matrices.
chow1 <- read.table(file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/4DExample/Margin1.csv",sep=',',header=F)
chow1 <- array(t(as.matrix(chow1)),c(19,2,27))

chow2 <- read.table(file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/4DExample/Margin2.csv",sep=',',header=F)
chow2 <- array(t(as.matrix(chow2)),c(6,19,2))

chow3 <- read.table(file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/4DExample/Margin3.csv",sep=',',header=F)
chow3 <- array(t(as.matrix(chow3)),c(6,2,27))

chow4 <- read.table(file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/4DExample/Margin4.csv",sep=',',header=F)
chow4 <- array(t(as.matrix(chow4)),c(6,19,27))

#Run the IPF functions and see the output.
result <- ipf4(chow1, chow2, chow3, chow4, pup) 
#result$fitted.table

#Write the data out.
write.table(t(matrix(result$fitted.table,c(6,1026))), file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/4DExample/Output.csv", row.names=T, sep=',', col.names=NA)



