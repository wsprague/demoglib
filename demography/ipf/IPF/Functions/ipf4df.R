############################################################
##Alaska Department of Labor and Workforce Development, 2008
############################################################

ipf4 <- function(chow1, chow2, chow3, chow4, pup=array(1,dim=c(length(chow1),length(chow2),length(chow3),length(chow4))), maxiter=50, closure=0.0001)
{
   
#check that margins are of the same value
   if((sum(chow1) != sum(chow2)) || (sum(chow1) != sum(chow3)) ||(sum(chow1) != sum(chow4))) {
warning(paste("chow1=",sum(chow1),"chow2=",sum(chow2),"chow3=",sum(chow3), "chow4=",sum(chow4)))
stop("Marginal controls must sum to the same grand total.")}
   
#replace 0's with .001 so that they are flexible   
   if(any(chow1==0)){
      numzero <- sum(chow1==0)
      chow1[chow1==0] <- 0.001
      warning(paste(numzero, "zeros in chow1 replaced with 0.001", sep=" "))
      }
   if(any(chow2==0)){
      numzero <- sum(chow2==0)
      chow2[chow2==0] <- 0.001
      warning(paste(numzero, "zeros in chow2 replaced with 0.001", sep=" "))
      }
   if(any(chow3==0)){
      numzero <- sum(chow3==0)
      chow3[chow3==0] <- 0.001
      warning(paste(numzero, "zeros in chow3 replaced with 0.001", sep=" "))
      }
   if(any(chow4==0)){
      numzero <- sum(chow4==0)
      chow4[chow4==0] <- 0.001
      warning(paste(numzero, "zeros in chow4 replaced with 0.001", sep=" "))
      }
   if(any(pup==0)){
      numzero <- sum(pup==0)
      pup[pup==0] <- 0.001
      warning(paste(numzero, "zeros in pup replaced with 0.001", sep=" "))
      }
   result <- pup
   checksum <- 1
   iter <- 0
   while((checksum > closure) & (iter < maxiter))
{

#First the first dimension.
chow1total  <- apply(result,c(2,3,4),sum)
chow1factor <- chow1/chow1total
result <- sweep(result, c(2,3,4), chow1factor, "*")

#Then the second dimension:
chow2total  <- apply(result,c(1,2,3),sum)
chow2factor <- chow2/chow2total
result <- sweep(result, c(1,2,3), chow2factor, "*")

#Then the third dimension:
chow3total  <- apply(result,c(1,3,4),sum)
chow3factor <- chow3/chow3total
result <- sweep(result,c(1,3,4),chow3factor,"*")

#Finally the fourth dimension:
chow4total  <- apply(result,c(1,2,4),sum)
chow4factor <- chow4/chow4total
result <- sweep(result,c(1,2,4),chow4factor,"*")

#are we done yet?
checksum <- max(sum(abs(1-chow1factor)),sum(abs(1-chow2factor)),sum(abs(1-chow3factor)),sum(abs(1-chow4factor)))
iter <- iter + 1
      }

#Get rid of any fuzzies that were added to zeros in the control.
   chow1 <- round(chow1,digits=0)
   chow2 <- round(chow2,digits=0)
   chow3 <- round(chow3,digits=0)
   chow4 <- round(chow4,digits=0)

#Now we compute the three adjustments, just to see where we are
result <- round(result, digits=0)
chow1.corn <- chow1-apply(result,c(2,3,4),sum)
chow2.corn <- chow2-apply(result,c(1,2,3),sum)
chow3.corn <- chow3-apply(result,c(1,3,4),sum)
chow4.corn <- chow4-apply(result,c(1,2,4),sum)
   result <- list(fitted.table=result, number.iterations=iter, tolerance=checksum, chow1.adj=chow1.corn, chow2.adj=chow2.corn,chow3.adj=chow3.corn,chow4.adj=chow4.corn)
   result
   }
