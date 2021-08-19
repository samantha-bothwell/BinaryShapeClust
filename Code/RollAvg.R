#######################################
##   Binary Shape-Based Clustering   ##
##                                   ##
## Author : Samantha Bothwell, MS    ##
## Advisor : Julia Wrobel, PhD       ##
##                                   ##
## Purpose : Create rolling avg      ##
##           function                ##
#######################################

### Libraries
library(roll) # calculate rolling sums for rolling probabilities


# Rolling average : Initialize with a rolling window of 14 days
roll_avg = function(x, window = 14){
  roll_mat = matrix(nrow = dim(x)[1], ncol = dim(x)[2])
  for(i in 1:dim(x)[1]){
    roll_mat[i,] = roll_sum(x[i,], width = window, min_obs = 1)/window
  }
  return(roll_mat[,-c(1:(window - 1))])
}