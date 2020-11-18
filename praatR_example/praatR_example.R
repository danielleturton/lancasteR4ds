# Sam Kirkham 2020-11-18
# Running Praat scripts from R

library(tidyverse)
library(speakr) # for praat_run() function

# setwd
setwd("~/Dropbox/projects/dialect_app/formant_test/")

# function: run Praat script on files in directory + save output to tibble
# ...filepath is relative to working directory specified above
get_formants <- function(speaker, max_formant){
  praat_run("get_formants.praat", speaker, max_formant, 5, capture = TRUE) %>% read_csv()
}

# get formants for each speaker + put in tibble (+ factorise variables)
# ...this creates a column called speaker and assigns a speaker number to each speaker's set of data
data <- bind_rows(
  "872" = get_formants("speaker872/", 5500),
  "926" = get_formants("speaker926/", 5500),
  "977" = get_formants("speaker977/", 5500),
  "1385" = get_formants("speaker1385/", 5500),
  "2579" = get_formants("speaker2579/", 5500),
  .id = 'speaker')
