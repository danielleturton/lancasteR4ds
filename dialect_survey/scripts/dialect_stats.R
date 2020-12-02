## LOAD PACKAGES ####
library(tidyverse)
library(lme4)

## LOAD DATA ####
source("scripts/dialect_cleaning.R")

data_stats = data_clean %>%
  mutate_at(.vars = vars(give.it.me:go.cinema), as.numeric)

## EXPLORATORY

mod = lm(give.it.me ~ occ_code.1, data = data_stats)
summary(mod)
