## wsprague@pdx.edu

## Function to tabulate and give CI's for a given variable name in a dataframe
## of ACS PUMS data, using the "replicate weights method" described in
## http://www.census.gov/acs/www/Downloads/2005-2007/AccuracyPUMS.pdf.  

## input parameters:
##   varname -- name of the column in the PUMS dataframe
##   x -- the dataframe
##   subset -- an optional boolean vector defining the subset of records to calculate
##   ci -- optional decimal for 
 
## returns a list with the following fields:
##   tab -- the tabulated data without ci's
##   lowerb, upperb -- lower and upperbounds
##   se -- the standard error
##   se_over_T -- the ratio of the standard error over the actual estimate

citab = function (varname, x, subset=NULL, ci=.95) {

  ## error checking
  if (abs(ci) >= 1.0 | abs(ci) <= 0.0) {
    print (sprintf("Error in citab(): bad CI: %s.  Stopping.", ci))
    stop()
  }

  ## Calculate base table using official weight...
  formT = sprintf("pwgtp ~ %s", varname)
  T = xtabs(formT, x,exclude=NULL, na.action=na.pass, subset=subset)

  ## ... prepare collector table for summation of tables using replicate weights...
  cT = T
  cT = cT * 0

  ## ... for all the replicate weights, collect the sum of
  ## squares difference of that tabulation with the original ...
  for (i in 1:80){
    
    ## Create a "formula" from the canonical names for the replicate weights --
    ## pwgtpXX where XX is 1..80 ...
    formt = sprintf("pwgtp%i ~ %s", i, varname)

    ## ... tabulate ...
    t = xtabs (formt, x,exclude=NULL, na.action=na.pass, subset=subset)

    ## ... collect sum of squares of difference.
    cT = cT + (t-T)^2
  }
  
  ## ... calculate SE ...
  se = sqrt( (4/80)*cT )

  ## ... (finally) get z multiplier to generate se and return list.
  z = qnorm(1-(1-ci)*2)
  return (list(tab=(T), lowerb=(T-(z*se)), upperb=(T+(z*se)), se=(se)))
}
