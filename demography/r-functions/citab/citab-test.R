
source('citab.R')
load('testdata.RData')

# Simple tabulation with error
print (citab(varname='SEX', x=pums.mex))

# Two-way tabulation with error
citab(varname='PUMA+SEX', x=pums.mex)

# Simple tabulation with error and subset
print (citab(varname='SEX', x=pums.mex, subset=(pums.mex$AGEP==16)))

# Two-way tabulation with error and subset
print (citab(varname='SEX+AGEP', x=pums.mex, subset=(pums.mex$AGEP>=16 & pums.mex$AGEP<=21)))

# Test error
try(citab(varname='SEX+AGEP', x=pums.mex, ci=1.05))
print ('finished')

