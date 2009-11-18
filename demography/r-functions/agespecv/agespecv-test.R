source('agespecv.R')
load('pums.mex.RData')
pums.mex$FER.LOGIC = pums.mex$FER==1    # baby in last year?
pums.mex$MIL.LOGIC = pums.mex$MIL==1    # active service?
pums.mex$MIL.LOGIC = pums.mex$MIG>=2    # any move in last year (both domestica and international)
pums.mex$MAR.LOGIC = pums.mex$MAR<=4    # ever married?
print(agespecv(data=pums.mex, agev='AGEF.EQUAL', weightv='pwgtp', eventv='FER.LOGIC'))
rm("pums.mex")
