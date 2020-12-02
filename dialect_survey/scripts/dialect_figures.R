## LOAD PACKAGES ####
library(tidyverse)

## LOAD DATA ####
source("scripts/dialect_cleaning.R")

## PLOTTING ####
ggplot(data_clean, aes(occ_code.1, fill = pour.poor)) + 
  geom_bar(position = "fill")
ggsave("figures/pourpoor_occ.pdf")
