source('agespecv.R')
load('pums.mex.RData')
pums.mex$FER.LOGIC = pums.mex$FER==1    # baby in last year?
pums.mex$MIL.LOGIC = pums.mex$MIL==1    # active service?
pums.mex$MIL.LOGIC = pums.mex$MIG>=2    # any move in last year (both domestica and international)
pums.mex$MAR.LOGIC = pums.mex$MAR<=4    # ever married?

pums.mex$MARF = factor(pums.mex$MAR, labels = c('mar', 'wid', 'div', 'sep', 'nev'))

print ('first\n\n')
quartz()
print(agespecv(data=pums.mex, agev='AGEF.EQUAL', weightv='pwgtp', eventv='FER.LOGIC')) # filename='~/public_html/foo1.pdf'))
readline(prompt='enter')
dev.off()

if (FALSE){
print ('second\n\n')
print(agespecv(data=pums.mex, agev='AGEF.EQUAL', weightv='pwgtp', eventv='MAR.LOGIC', partv='SEX')) #filename='~/public_html/foo2.pdf'))
readline(prompt='enter')
dev.off()

print('third\n\n')
print(agespecv(data=pums.mex, agev='AGEF.EQUAL', weightv='pwgtp', eventv='FER.LOGIC', partv='MARF'))# filename='~/public_html/foo2.pdf'))
readline(prompt='enter')
dev.off()

}

rm("pums.mex")

