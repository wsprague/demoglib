############################################################
##Alaska Department of Labor and Workforce Development, 2008
############################################################

ipf2 <- function(rowcontrol, colcontrol, seed, maxiter=50, closure=0.0001, debugger=FALSE){
   # input data checks: 
if(debugger)print("checking inputs")
#sum of marginal totals equal and no zeros in marginal totals
if(debugger){print("checking rowsum=colsum")}
   if(sum(rowcontrol) != sum(colcontrol)) 
stop("sum of rowcontrol must equal sum of colcontrol")
if(debugger){print("checking rowsums for zeros")}
   if(any(rowcontrol==0)){
      numzero <- sum(rowcontrol==0)
      rowcontrol[rowcontrol==0] <- 0.001
      warning(paste(numzero, "zeros in rowcontrol argument replaced with 0.001", sep=" "))
      }
if(debugger){print("Checking colsums for zeros")}
   if(any(colcontrol==0)){
      numzero <- sum(colcontrol==0)
      colcontrol[colcontrol==0] <- 0.001
      warning(paste(numzero, "zeros in colcontrol argument replaced with 0.001", sep=" "))
      }
if(debugger){print("Checking seed for zeros")}
   if(any(seed==0)){
      numzero <- sum(seed==0)
      seed[seed==0] <- 0.001
      warning(paste(numzero, "zeros in seed argument replaced with 0.001", sep=" "))
      }
   # set initial values
   result <- seed
   rowcheck <- 1
   colcheck <- 1
   checksum <- 1
   iter <- 0
   # successively proportion rows and columns until closure or iteration criteria are met
##########
if(debugger){print(checksum > closure);print(iter < maxiter)}
   while((checksum > closure) && (iter < maxiter))
      {
#########
if(debugger){print(paste("(re)starting the while loop, iteration=",iter)) }

 coltotal <- colSums(result)
 colfactor <- colcontrol/coltotal
 result <- sweep(result, 2, colfactor, "*")
if(debugger){
print(paste("column factor = ",colfactor))
print(result)}

 rowtotal <- rowSums(result)
 rowfactor <- rowcontrol/rowtotal
 result <- sweep(result, 1, rowfactor, "*")
if(debugger){
print(paste("row factor = ",rowfactor))
print(result)}

       rowcheck <- sum(abs(1-rowfactor))
 colcheck <- sum(abs(1-colfactor))
         checksum <- max(rowcheck,colcheck)
 iter <- iter + 1
#print(paste("Ending while loop, checksum > closure",checksum > closure,"iter < maxiter",iter < maxiter))
      }#End while loop

#round the result
result <- round(result, digits=0)
   rowcontrol <- round(rowcontrol, digits=0)
   colcontrol <- round(colcontrol, digits=0)

#Apply corrections to the largest element of the row/column
   row.corn <- rowcontrol-apply(result,1,sum)
   temp <- apply(result,1,max)
   for (i in 1:dim(result)[1]){
k <- which(result[i,]==temp[i])
result[i,k] <- result[i,k]+row.corn[i]
}
   col.corn <- colcontrol-apply(result,2,sum)
   temp <- apply(result,2,max)
   for (i in 1:dim(result)[2]){
k <- which(result[,i]==temp[i])
result[k,i] <- result[k,i]+col.corn[i]
}
   #Compute the corrections again.
   row.corn <- rowcontrol-apply(result,1,sum)
   col.corn <- colcontrol-apply(result,2,sum)


   result <- list(fitted.table=result, number.iterations=iter, tolerance=max(rowcheck,colcheck), row.adj=row.corn, col.adj=col.corn)
   result
   }#End IPF2
