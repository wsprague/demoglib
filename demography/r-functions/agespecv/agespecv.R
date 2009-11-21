## agespecv -- visualizing age specific rates in the ACS PUMS dataset

## webb.sprague@gmail.com

## Function to graph age- and sex- specific rates from PUMS data using an event
## variable and a partitioning variable

## input parameters -- except for data, all string names for columns in data

##    data -- Data frame

##    agev -- Ordered.factor along which to calculate rates

##    weightv -- weights for records

##    eventv=NULL -- Boolean variable of whether event happened or not.  These
##    are counted up for the numberator. If NULL, calculates proportion of
##    population

##    partv=NULL -- Factor variable by which to partition the calculations and
##    graphs. If NULL, doesn't partition

##    period=1 -- multiplier for fractional periods (might be 1.5 for 18 months
##    and yearly rates, for ex)

##    filename=NULL -- output filename. If empty, uses default displays

## Weidnesses:

##    xtabs() ignores Na's and NULLs, so when we calculate rates with it, if the
## these invalid results are not even part of the universe

## xyplot(Freq~AGEF.EQUAL, as.data.frame(prop.table(xtabs(pwgtp~AGEF.EQUAL+SEX,
## subset=DMV.MEX))), groups=SEX, type='l')

agespecv = function (data, agev, weightv=NULL, eventv=NULL, partv=NULL, period=1, filename=NULL) {

  require(ggplot2)
  require(lattice)
  
  ## calc rates -- numerator, ...
  if (is.null(partv) & is.null(eventv)) { # age dist, no groups
    ;
  } else if (is.null(partv) & !is.null(eventv)) { 
    ## age spec rate, no groups

    ## Calculate rates etc
    eventsf = as.formula(sprintf('%s ~ %s + %s', weightv, eventv, agev))
    counts = (xtabs(eventsf, data))         #see note on xtabs() above
    events = counts['TRUE',]
    expos = colSums(counts)*period 
    rates = (events / expos)
    ratesdf = as.data.frame(rates)
    ratesdf$age = levels(data[[agev]])

    ## Make the graph
    g = ggplot() + layer(data = ratesdf, mapping = aes(x = age, y = rates), geom = "point", stat="identity") +
      layer(data = ratesdf, mapping = aes(x = age, y = rates, group=1), geom = "smooth", stat = "smooth", method = loess)
    print(g)

    ## return the rates and stuff as a list
    return(list(counts=counts,events=events, expos=expos, rates=rates, ratesdf=ratesdf))
    
  } else if (!is.null(partv) & is.null(eventv)){ # age dist, groups
    ;
  } else if (!is.null(partv) & !is.null(eventv)) { #age spec rate, groups

    ## Calculate rates etc
    eventsf = as.formula(sprintf('%s ~ %s + %s + %s', weightv, eventv, agev, partv))
    counts = (xtabs(eventsf, data))         #see note on xtabs() above
    events = counts['TRUE',,]
    expos = colSums(counts)*period 
    rates = (events / expos)
    ratesdf = as.data.frame(rates)
    ratesdf$age = levels(data[[agev]])

    ## reshape -- melt is maybe not the best, but at least it makes sense 
    ratesdf = (melt(ratesdf))
    colnames (ratesdf) = c('age', 'group', 'rate')

    ## Make the graph
    g = ggplot() + layer(data = ratesdf, mapping = aes(x = age, y = rate, group = group), geom = "point", stat="identity") +
      layer(data = ratesdf, mapping = aes(x = age, y = rate, group=group), geom = "smooth", stat = "smooth", method = loess)
    print(g)

    ## return the rates and stuff as a list
    return(list(counts=counts,events=events, expos=expos, rates=rates, ratesdf=ratesdf))
  }
}
