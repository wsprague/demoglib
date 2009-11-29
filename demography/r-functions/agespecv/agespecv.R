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
    ratesdf$age = ordered(levels(data[[agev]]))
    ratesdf$group = rep('g1')
    colnames (ratesdf) = c('rate', 'age', 'group')

    ## make a big df
    alldf = ratesdf
    alldf$exposures = expos
    alldf$events = events
    
    ## Get rid of NA's
    ratesdf = ratesdf[!is.na(ratesdf$rate),]
    ratesdf = as.data.frame(lapply(ratesdf, function(x) x[,drop=TRUE]))
    
    ## Make the graph
    g = ggplot() + layer(data = ratesdf, mapping = aes(x = age, y = rate, group=group),
      geom = c("point", 'smooth'), stat="identity") +
        layer(data = ratesdf, mapping = aes(x = age, y = rate, group=1), geom = "smooth", stat = "identity") +
          xlab('Age') + ylab('Rate')
    print(g)

    ##print(barchart(rate~age, data=ratesdf, horizontal=FALSE))
    ##plot(as.numeric(ratesdf$age), ratesdf$rate, type='l', labels=FALSE)
    ##axis(side=1,labels=ratesdf$age, at=(as.numeric(ratesdf$age)))
    
         
    ## return the rates and stuff as a list
    return(alldf=alldf)
    
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
    ratesdf$age = ordered(levels(data[[agev]]))
        
    ## reshape -- melt is maybe not the best, but at least it makes sense 
    ratesdf = (melt(ratesdf))
    colnames (ratesdf) = c('age', 'group', 'rate')
    exposdf = melt(expos)
    colnames(exposdf)  = c('age', 'group', 'exposures')
    eventsdf = melt(events)
    colnames(eventsdf) = c('age', 'group', 'events')

    ## make a big df (god I wish there were a proc SQL)
    alldf = merge (exposdf, eventsdf)
    alldf = merge (alldf, ratesdf)
    
    ## Get rid of NAs
    ratesdf = ratesdf[!is.na(ratesdf$rate),]
    ratesdf = as.data.frame(lapply(ratesdf, function(x) x[,drop=TRUE]))
    
    ## Make the graph
    g = ggplot() + layer(data = ratesdf, mapping = aes(x = age, y = rate, color=group, group = group),
      geom = c("point", 'smooth'), stat="identity") +
        layer(data = ratesdf, mapping = aes(x = age, y = rate, group=group, color=group),
              geom = "smooth", stat = "identity") +
                xlab('Age') + ylab('Rate')
    print(g)
    
    ## return the rates and stuff
    return(alldf=alldf)
  }
}
