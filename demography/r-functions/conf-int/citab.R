## function to tabulate and give CI's for a given variable name
citab = function (varname, x) {
    formT = sprintf("pwgtp ~ %s", varname)
    T = xtabs(formT, x,exclude=NULL, na.action=na.pass)
    cT = T
    cT = cT * 0
    for (i in 1:80){
        formt = sprintf("pwgtp%i ~ %s", i, varname)
        t = xtabs (formt, x,exclude=NULL, na.action=na.pass)
        cT = cT + (t-T)^2
    }
    se = sqrt( (4/80)*cT )
    return (list(table=ftable(T), lb=ftable(T-(1.645*se)), ub=ftable(T+(1.645*se)),
                         se=ftable(se), se_over_T=ftable(se/T)))
}

# Run as the following, given a data.frame with appropriate column names
#citab(varname='SEX', x=pums.2005.2007.p.mex)
#citab(varname='PUMA+SEX', x=pums.2005.2007.p.mex)