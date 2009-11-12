## agespecv -- visualizing age specific rates in the ACS PUMS dataset

## webb.sprague@gmail.com

## Function to graph age- and sex- specific rates from PUMS data using an event
## variable and a partitioning variable

## input parameters
##    data
##    eventv=NULL  If empty, calculates proportion of population 
##    partv=NULL  If empty, doesn't partition
##    file=NULL  If empty, uses default displays


## xyplot(Freq~AGEF.EQUAL, as.data.frame(prop.table(xtabs(pwgtp~AGEF.EQUAL+SEX, subset=DMV.MEX))), groups=SEX, type='l')
