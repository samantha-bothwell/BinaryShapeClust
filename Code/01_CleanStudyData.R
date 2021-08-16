#######################################
##   Binary Shape-Based Clustering   ##
##                                   ##
## Author : Samantha Bothwell, MS    ##
## Advisor : Julia Wrobel, PhD       ##
##                                   ##
## Purpose : Clean daily weights     ##
##           file                    ##
#######################################

### Libraries
library(tidyverse) # data wrangling

### Load weights data
weights <- read.csv("D:/CU/Thesis/Clustering/Data/daily_weights_with_confounding.csv") %>% janitor::clean_names()

### Filter data to 12 months
### Remove cohort 3 
### Calculate percent change in weight and weight loss
weights = weights %>%
  filter(study_days <= 365, cohort != 3) %>%
  arrange(participant_id, study_days) %>%
  group_by(participant_id) %>%
  mutate(percent_change = (wt_lb - first(wt_lb))/first(wt_lb) * 100,
    weight_loss = wt_lb - first(wt_lb)) %>%
  dplyr::select(participant_id, weight_dates, study_days, cohort, period, wt_lb, percent_change, weight_loss, everything()) %>%
  ungroup()

### Create a binary indicator of whether someone weighed in on a given day 
### Fill in missing days as a 0 for not having weighed in
adherence = weights %>% 
  mutate(weighed_in = 1) %>%
  complete(participant_id, nesting(study_days), fill = list(weighed_in = 0)) %>%
  group_by(participant_id) %>%
  mutate(percent_adherence = sum(weighed_in)/365 * 100) %>%
  ungroup() %>%
  arrange(percent_adherence, participant_id) %>%
  dplyr::select(participant_id, study_days, weighed_in, percent_adherence, everything())

### Transform adherence data to be presented in wide format
adher = adherence %>% 
  dplyr::select(participant_id, percent_adherence, study_days, weighed_in) %>%
  mutate(study_days = paste0("day_", study_days)) %>%
  distinct() %>%
  pivot_wider(names_from = study_days, values_from = weighed_in)

