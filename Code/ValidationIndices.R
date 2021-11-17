#######################################
##   Binary Shape-Based Clustering   ##
##                                   ##
## Author : Samantha Bothwell, MS    ##
## Advisor : Julia Wrobel, PhD       ##
##                                   ##
## Purpose : Calculate Validation    ##
##           Indices                 ##
#######################################

## Libraries 
library(cluster) # silhouette index
library(fpc) # Calinski-Harabasz Index
library(clusterSim) # DB Index 
library(clValid) # Dunn index 


## Function to calculate validation indices 
# matrix - original matrix used to calculate distance - default is NULL (internal CVI)
# distance = calculated distance - default is NULL (internal CVI)
# cut_matrix = cut clusters given distance - required (external and internal CVI)
# true_cluters = true clusters if known - default is NULL (external CVI)

validation = function(matrix = NULL, distance = NULL, cut_matrix, true_clusters = NULL){
  if(is.null(cut_matrix)){
    print("Error : You need to specify cut_matrix")
    quit("yes")
  }
  else if(!is.null(distance) & !is.null(matrix)){
    validation_df = data.frame(Silhouette = summary(silhouette(cut_matrix, distance))$avg.width, 
      Dunn = dunn(distance, cut_matrix), 
      DaviesBouldin = index.DB(distance, cut_matrix)$DB, 
      Calinhara = calinhara(matrix, cut_matrix))
  }
  else if(!is.null(true_clusters)){
    validation_df = as.data.frame(t(cvi(cut_matrix, true_clusters, type = "external")))
  }
  
  return(validation_df)
}