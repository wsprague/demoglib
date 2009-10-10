#Read in the IPF functions.
source("R:/RA/RAPOP/EDDIE/IPF/Functions/ipf2df.txt")
source("R:/RA/RAPOP/EDDIE/IPF/Functions/ipf3df.txt")

#Read in the data.
data <- read.table(file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/3DExample/Seed.csv",sep=',',header=F)

#Update the dimensions here.
TableSize<-c(5,19,27)
data <-array(t(as.matrix(data)),TableSize)

#Now we get the control matrices.
stack.control <- read.table(file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/3DExample/Stack.csv",sep=',',header=F)
stack.control <- as.matrix(stack.control)

col.control <- read.table(file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/3DExample/Col.csv",sep=',',header=F)
col.control <- as.matrix(col.control)

row.control <- read.table(file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/3DExample/Row.csv",sep=',',header=F)
row.control <- as.matrix(row.control)

#Run the IPF functions and see the output.
result <- ipf3df(row.control, col.control, stack.control, data) 
#result$fitted.table

#Write the data out. It will still need rounding after this.
write.table(t(matrix(result$fitted.table,c(5,513))), file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/3DExample/Output.csv", row.names=T, sep=',', col.names=NA)
