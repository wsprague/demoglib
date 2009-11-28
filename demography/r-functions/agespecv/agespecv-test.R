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
  try(system('rm ./foo1.pdf ./foo2.pdf ./foo3.pdf'))

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
  ## all data
  load('persondata.Munged.RData')

  ## Make dichotomous variables for calc rates
  pums.2005.2007.p$FER.LOGIC = pums.2005.2007.p$FER==1    # baby in last year?

  ## Make factor variables for grouping
  pums.2005.2007.p$MARF = factor(pums.2005.2007.p$MAR, labels = c('mar', 'wid', 'div', 'sep', 'nev'))
  pums.2005.2007.p$MEX.LOGIC = pums.2005.2007.p$POBP == 303

  ## Moves from out of state
  pums.2005.2007.p$INMIG.LOGIC = FALSE
  pums.2005.2007.p$INMIG.LOGIC = (!is.na(pums.2005.2007.p$MIGSP) & pums.2005.2007.p$MIGSP != 41 )
  
  ## Clear output
  try(system('rm ./foo*.pdf'))

  ## 
  print('Migration in state')
  pdf('./foo1.pdf')
  print(agespecv(data=pums.2005.2007.p, agev='AGEF.EQUAL', weightv='pwgtp', eventv='INMIG.LOGIC'))
  dev.off()
  readline(prompt='enter?')

}


