#######################################
##   Binary Shape-Based Clustering   ##
##                                   ##
## Author : Samantha Bothwell, MS    ##
## Advisor : Julia Wrobel, PhD       ##
##                                   ##
## Purpose : Heatmap Visualization   ##
#######################################

### Libraries 
library(ggplot2)
library(viridis)

### Visualize true clusters 
cluster_heatmap <- function(data, day, id, weighed, cluster, ncol){
  ggplot(data, aes(x = x, y = y, fill = weighed)) +
    geom_tile() + ggtitle("True Data Clusters and Mean Adherence %") + 
    theme(plot.title = element_text(hjust = 0.5)) + 
    scale_fill_viridis(discrete = TRUE, option="A") +
    facet_wrap(~cluster, scales = "free", ncol = ncol)
}
