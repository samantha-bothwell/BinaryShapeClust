
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Binary Shape-Based Clustering

<!-- badges: start -->

<!-- badges: end -->

This repository is accompanies “Shape-Based Clustering of Daily Weigh-In
Trajectories using Dynamic Time Warping” (doi). The aim of the paper was
to use Dynamic Time Warping, a shape-based clutering method, to cluster
binary trajectories and evaluate patterns. Study data is not made
publically available, however simulated data to resemble the study data
is used and shared in this repository.

  - Source files to load in data (data cleaning and simulation data)

<!-- end list -->

``` r
### Libraries 
library(tidyverse)
library(ggplot2)
library(dtwclust) # cluster time series with dynamic time warping
library(ecodist) # distance function for jaccard

### Source files
source("Code/01_CleanStudyData.R")
source("Code/02_SimulateClusters.R")
```

  - Plot the binary heatmap (this should be a file of its own to make
    heat maps based on the data)

<!-- end list -->

``` r
#### Function not incorporated yet
#### Sort by % adherence
source("Code/ClusterHeatmap.R")

ggplot(sim_plot, aes(x = day, y = participant_id, fill = weighed_in)) +
    geom_tile() + ggtitle("True Data Clusters and Mean Adherence %") + 
    theme(plot.title = element_text(hjust = 0.5)) + 
    scale_fill_viridis(discrete = TRUE, option="A") +
    facet_wrap(~cluster_assignment, scales = "free", ncol = 5)
```

![](README_files/figure-gfm/simfig-1.png)<!-- -->

  - Cluster the data using Euclidean, Jaccard, and DTW and show how to
    use probability windows and linkages

<!-- end list -->

``` r
### Using binary data
jac_dist <- distance(adherence_mat, method = 'jaccard')
dtw_dist <- dist(adherence_mat, method = 'dtw')
euc_dist <- distance(adherence_mat, method = 'euclidean')
```

``` r
### Using continuous data
source("Code/RollAvg.R")
roll_mat = roll_avg(adherence_mat, window = 14) # window size can be adjusted

jac_dist_roll <- distance(roll_mat, method = 'jaccard')
dtw_dist_roll <- dist(roll_mat, method = 'dtw')
euc_dist_roll <- distance(roll_mat, method = 'euclidean')
```
