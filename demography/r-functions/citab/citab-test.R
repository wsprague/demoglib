
## Get function and sample data
source('citab.R')
load('testdata.RData')                  #this loads pums.mex

## Begin
print('Starting citab-test.R')

## Simple tabulation with error
print (citab(varname='SEX', x=pums.mex))

## Two-way tabulation with error
citab(varname='PUMA+SEX', x=pums.mex)

## Simple tabulation with error and subset
print (citab(varname='SEX', x=pums.mex, subset=(pums.mex$AGEP==16)))

## Two-way tabulation with error and subset
print (citab(varname='SEX+AGEP', x=pums.mex, subset=(pums.mex$AGEP>=16 & pums.mex$AGEP<=21)))

## Test error
print('Following this message you should see an error due to bad CI.')
try(citab(varname='SEX+AGEP', x=pums.mex, ci=1.05))

## Finis
print ('\nFinished with citab-test.R')

