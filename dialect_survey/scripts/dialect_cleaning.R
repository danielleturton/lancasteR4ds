## LOAD PACKAGES ####
library(tidyverse)

## LOAD DATA ####
data = read.csv("data/dialectsurvey.csv", na.strings = "")

## CLEAN DATA ####
data_clean = data %>%
  mutate(gender = tolower(gender))
