##################################################################
##   Binary Shape-Based Clustering                              ##
##                                                              ##
## Author : Samantha Bothwell, MS                               ##
## Advisor : Julia Wrobel, PhD                                  ##
##                                                              ##
## Purpose : Simulate Clusters (clusters are unequal size to    ##
##           represent our motivating data)                     ##
##################################################################

### Libraries 
library(tidyverse) # data wrangling

### Source MakeClusters function
source("Code/MakeClusters.R")
source("Code/01_CleanStudyData.R")

### Initialize number of days
days = 365

# Quartile clusters
low = make_clusters(N = 20, days = days, adherence_probability = summary(adher$percent_adherence)[2]/100, cluster_label = "low")
medium = make_clusters(N = 20, days = days, adherence_probability = summary(adher$percent_adherence)[3]/100, cluster_label = "med") %>% mutate(id = id + 20)
high = make_clusters(N = 20, days = days, adherence_probability = summary(adher$percent_adherence)[5]/100, cluster_label = "high") %>% mutate(id = id + 40)

### Dropout Cluster 
### Randomize the dropout day from a Normal distribution
N = 20
drop_day = ceiling(rnorm(N, mean = 150, sd = 50)) # randomized day of dropout
drop_adherence = c()
for(i in 1:N){
  drop_adherence = c(drop_adherence, rbinom(drop_day[i], size = 1, prob = summary(adher$percent_adherence)[3]/100), 
    rbinom(days - drop_day[i], size = 1, prob = 0.05))
}

dropout =  tibble(
  id = rep(1:N, each = days) + 60,
  day = rep(1:days, times = N),
  adherence = drop_adherence,
  cluster_label = "dropout")


### Large strings of no adherence
N = 20
vacation = make_clusters(N = N, days = days, adherence_probability = summary(adher$percent_adherence)[3]/100, 
  cluster_label = "vacation")[,-4]
zero_days = runif(N, min = 30, max = 300) # find which day the zero string starts 

zeros = tibble(
  id = 1:N, 
  length = ceiling(runif(N, min = 30, max = 90)), # specify length of each string of zeros
  day = ceiling(zero_days)
)

zeros <- zeros %>% group_by(id) %>% complete(day = seq(day, day + length, by = 1))
zeros <- zeros[zeros$day <= 400,]; zeros <- zeros[!duplicated(zeros[,c(1,2)]),]
zeros$adherence = 0

vacation = left_join(vacation, zeros, by = c("id", "day")) %>% 
  mutate(adherence = ifelse(!is.na(adherence.y), adherence.y, adherence.x)) %>% 
  dplyr::select(id, day, adherence) %>% 
  mutate(cluster_label = "vacation", id = id + 80)

# Combine data
sim_dat = rbind(low, medium, high, dropout, vacation)

# Mutate simulation data
sim_plot = sim_dat %>%
  mutate(id = paste0(cluster_label, "_", id)) %>% # Add cluster label to id
  group_by(id) %>% 
  mutate(percent_adherence = sum(adherence)/365 * 100) %>% # Calculate % adherence
  ungroup() %>% group_by(cluster_label) %>% 
  mutate(mean.adherence = paste0(round(mean(percent_adherence), 1), "%")) %>% 
  ungroup() %>% 
  mutate(weighed_in = factor(adherence, levels = 0:1, labels = c("no", "yes")),
    participant_id = fct_reorder(id, percent_adherence),
    cluster_assignment = paste0("cluster_", cluster_label, " \n Mean Adherence = ", mean.adherence))

sim_clust = sim_dat %>% 
  group_by(id) %>%
  mutate(percent_adherence = sum(adherence)/400 * 100) %>%
  ungroup() %>% 
  dplyr::select(id, percent_adherence, cluster_label, day, adherence) %>%
  mutate(day = paste0("day_", day)) %>%
  distinct() %>%
  pivot_wider(names_from = day, values_from = adherence)

adherence_mat = as.matrix(sim_clust[,-c(1:3)])
rownames(adherence_mat) <- sim_clust$id

