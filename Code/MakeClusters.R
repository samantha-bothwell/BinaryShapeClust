#######################################
##   Binary Shape-Based Clustering   ##
##                                   ##
## Author : Samantha Bothwell, MS    ##
## Advisor : Julia Wrobel, PhD       ##
##                                   ##
## Purpose : Function to create      ##
##           clusters                ##
#######################################

### Libraries 
library(tidyverse) # data wrangling

### Function to create random clusters
make_clusters = function(N, days, adherence_probability, cluster_label, seed = 10000){
  adherence = c()
  for (i in 1:N){
    adherence = c(adherence, rbinom(days, size = 1, prob = adherence_probability))
  }
  tibble(
    id = rep(1:N, each = days),
    day = rep(1:days, times = N),
    adherence = adherence,
    cluster_label = cluster_label
  )
}