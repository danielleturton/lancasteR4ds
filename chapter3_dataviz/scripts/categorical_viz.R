## LOAD PACKAGES ####
#install.packages("tidyverse") # install if first time using
library(tidyverse)

## LOAD DATA ####
td_data = read.csv("chapter3_dataviz/data/td.csv")

td_clean = td_data %>%
  mutate(td = factor(td, levels = c("retained", "deleted"))) %>%
  mutate(td_num = as.numeric(td)-1)

## MAKE GRAPHS ####
# I will start off simple and then make them better

# STEP 1: raw counts####
# typically we do not want this kind of graph

ggplot(td_clean,  aes(x = fol_seg, fill = td)) + geom_bar()


#STEP 2: percentages ####
ggplot(td_clean,  aes(x = fol_seg, fill = td)) + geom_bar(position = "fill")
# better, but we don't really need to plot both AND we're not accounting for influential speakers or words.  Plus, some of the aesthetics could be better.

# STEP 3: fixing aesthetics
ggplot(td_clean,  aes(x = fol_seg, fill = td)) + 
  geom_bar(position = "fill", colour = "black") + # nice black line around the bars
  xlab("following segment") + # x axis
  ylab("% td") + # y axis
  theme_bw(base_size = 16) + # nice white background and bigger font 
  scale_y_continuous(labels = scales::percent) # y axis in percentage instead of decimal

# STEP 4: plotting deletion rates averaged by speaker and word

# create a new data table
td_folseg_figs = td_clean %>%
  group_by(fol_seg, speaker, word)%>%
  summarise(td = mean(td_num))%>%
  summarise(td = mean(td))%>%
  summarise(td = mean(td, na.rm=TRUE))%>%
  #mutate(fol_seg = reorder(fol_seg, -td, mean))%>%
  ungroup()


# plot data table
ggplot(td_folseg_figs, aes(x = fol_seg, y = td)) + #notice we don't use 'fill' now
  geom_bar(stat = "identity") # we need identity rather than fill now

# make it look nice
ggplot(td_folseg_figs, aes(x = fol_seg, y = td)) +
  geom_bar(stat = "identity", fill = "#F1C40F", colour = "black") +
  ylab("% deletion") + # relabel axes
  xlab("following segment") +
  scale_y_continuous(labels = scales::percent, limits = c(0, 1)) + # keep axes from 0 to 1
  theme_bw(base_size = 16)

# STEP 5: Save
ggsave(filename = "td-folseg.png")
