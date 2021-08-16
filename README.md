
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
source("Code/01_CleanStudyData.R")
#> -- Attaching packages -------------------------------------------------------------------------------------------- tidyverse 1.3.0 --
#> v ggplot2 3.3.2     v purrr   0.3.4
#> v tibble  3.0.3     v dplyr   1.0.1
#> v tidyr   1.1.2     v stringr 1.4.0
#> v readr   1.3.1     v forcats 0.5.0
#> Warning: package 'tidyr' was built under R version 4.0.3
#> -- Conflicts ----------------------------------------------------------------------------------------------- tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

  - Plot the binary heatmap (this should be a file of its own to make
    heat maps based on the data)  
  - Cluster the data using Euclidean, Jaccard, and DTW and show how to
    use probability windows and linkages
