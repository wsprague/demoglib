source('agespecv.R')

if (FALSE) {
  ## Mexican only data
  load('pums.mex.RData')

  ## Make dichotomous variables for calc rates
  pums.mex$FER.LOGIC = pums.mex$FER==1    # baby in last year?
  pums.mex$MIL.LOGIC = pums.mex$MIL==1    # active service?
  pums.mex$MIG.LOGIC = pums.mex$MIG>=2    # any move in last year (both domestica and international)
  pums.mex$MAR.LOGIC = pums.mex$MAR<=4    # ever married?

  ## Make factor variable for grouping
  pums.mex$MARF = factor(pums.mex$MAR, labels = c('mar', 'wid', 'div', 'sep', 'nev'))

  ## Clear output
  try(system('rm ./foo*.pdf'))

  ## make pictures to test
  print ('Fertility no grouping')
  pdf('./foo1.pdf')
  print(agespecv(data=pums.mex, agev='AGEF.EQUAL', weightv='pwgtp', eventv='FER.LOGIC')) # filename='~/public_html/foo1.pdf'))
  dev.off() 
  readline(prompt='enter? ')
 
  print ('Marriage, group by sex')
  pdf('./foo2.pdf')
  print(agespecv(data=pums.mex, agev='AGEF.EQUAL', weightv='pwgtp', eventv='MAR.LOGIC', partv='SEX')) #filename='~/public_html/foo2.pdf'))
  dev.off()
  readline(prompt='enter? ')

  print('Fertility, group by marriage')
  pdf('./foo3.pdf')
  print(agespecv(data=pums.mex, agev='AGEF.EQUAL', weightv='pwgtp', eventv='FER.LOGIC', partv='MARF'))# filename='~/public_html/foo2.pdf'))
  dev.off()
  readline(prompt='enter')


  rm("pums.mex")
}

if (TRUE) {
  ## Clear output
  try(system('rm ./foo*.pdf'))

  ## grab data
  load('persondata.Munged.RData')

  ## Migration
  pums.2005.2007.p$INMIG.LOGIC = FALSE
  pums.2005.2007.p$INMIG.LOGIC = (!is.na(pums.2005.2007.p$MIGSP) & pums.2005.2007.p$MIGSP != 41 )
  pdf('./fooMig.pdf')
  print(agespecv(data=pums.2005.2007.p, agev='AGEF.EQUAL', weightv='pwgtp', eventv='INMIG.LOGIC'))
  dev.off()
  readline(prompt='enter?')
  
  ## Fertility
  pums.2005.2007.p$MEX.LOGIC = pums.2005.2007.p$POBP == 303 #Mexican?
  pums.2005.2007.p$FER.LOGIC = pums.2005.2007.p$FER==1    # baby in last year?
  pdf('./fooFert.pdf')
  print(agespecv(data=pums.2005.2007.p, agev='AGEF.EQUAL', weightv='pwgtp', eventv='FER.LOGIC', partv='MEX.LOGIC'))
  dev.off()
  readline(prompt='enter?')

  ## Labor force participation
  ## partition on Sex
  pums.2005.2007.p$WORK.LOGIC = !(pums.2005.2007.p$ESR == 3 | pums.2005.2007.p$ESR == 6)
  pdf('./fooLF.pdf')
  print(agespecv(data=pums.2005.2007.p, agev='AGEF.EQUAL', weightv='pwgtp', eventv='WORK.LOGIC', partv='SEX'))
  dev.off()

  ## Partition on PUMA
  readline(prompt='enter?')
  pdf('./fooLFPUMA.pdf')
  print(agespecv(data=pums.2005.2007.p, agev='AGEF.EQUAL', weightv='pwgtp', eventv='WORK.LOGIC', partv='PUMA'))
  dev.off()
  readline(prompt='enter?')

}
