#Read in the IPF function.
source("R:/RA/RAPOP/EDDIE/IPF/Functions/ipf2df.txt")

#Read in the seed data.
seed <- read.table(file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/2DExample/Seed.csv", header=F, sep=",")
seed #Inspect the seed you just read in: did you get the right numbers?

#Read in the controls.
rowc<-read.table(file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/2DExample/Row.csv", header=F, sep=",")
rowc <- as.matrix(rowc)

colc<-read.table(file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/2DExample/Col.csv", header=F, sep=",")
colc <- as.matrix(colc)

#Run the IPF function and look at the output.
ipf2(rowc, colc, seed)

#Run the ipf2 function and write it out.
write.table(ipf2(rowc, colc, seed)$fitted.table, file="R:/RA/RAPOP/EDDIE/IPF/HowTo/PracticeData/2DExample/Output.csv", sep=",")
