library(tidyverse)
library(dplyr)
library(scales)

# Visualisation of survey repsonses/likert scales/perception responses

# Data are usually in the form of 'Strongly agree, Agree, Disagree, Strongly disagree, Don't know'
# This kind of data might be found in attitudinal surveys, language testing, perception responses
# Could be something like 
# 'How similar do you find the speakers in these extracts?' 
# 'How posh does this speaker sound?'
# 'How intelligible is this extract?' etc etc

# Data are not the same as a formant/VOT plot (continuous) and not quite the same as t or d deletion (2 categories)

# Demo with data from the department's Athena Swan staff survey (yay...)
# Format: Long survey with mainly likert style responses to statements about gender in the department
# e.g. 'My department actively encourages women to apply for promotion'

# There are a few options for visualisation
# I wanted to show the responses for different genders separately
# i.e. it is interesting to know whether women think women are encouraged to apply for promotion and whether men think women are encouraged to apply for promotion
# Then we can say things like '50% of women think they are actively encouraged to apply for promotion but 75% of mean think women are actively encouraged to apply for promotion'.
# You might want to split your perception responses by gender, location, social class, age etc etc

# Final product: two options (see graphs)
# Option 1: Proportion of responses on the x axis - easy comparison across genders and survey questions
# Includes number of respones on each bit of each bar
# Option 2: Number of responses on the x axis - perhaps more transparency about number of responses in each case
# Includes percentage of that gender's responses in each bar

# Data format for this demo
# Q8 contains answers to the statement 'In my department, women are actively encouraged to apply for promotion'
# Q66 asked participants about their gender

# change to wherever you're working
setwd("/Users/clairenance/Dropbox/Lancaster/Training/R book/Chapter 4/Claire_demo/")

# read in data
data <- read.csv("Q8.csv")

# what does it look like?
# responses exported as numbers
# view(data)

# we need to convert the numbers into text to make them meaningful
# 'select' allows just working with one bit of the dataframe
likert <- data %>%
  select(Q8)
gender <- data %>%
  select(Q66)

# convert likert responses into text
likert[likert == 1] = "Strongly disagree"
likert[likert == 2] = "Disagree"
likert[likert == 3] = "Agree"
likert[likert == 4] = "Strongly agree"
likert[likert == 5] = "Don't know"

# convert gender responses into text
gender[gender == 1] = "Female"
gender[gender == 2] = "Male"
gender[gender == 3] = "Non-binary"
gender[gender == 4] = "Another gender"
gender[gender == 5] = "Prefer not\n to say"

# put the dataframe back together
all <- bind_cols(likert, gender)

# change the column name containing gender information to something sensible instead of the question number
colnames(all)[2] <- 'gender'

# what we need now is to know the number of females who replied 'Agree', the number of males who answered 'Agree' etc etc
# this code gives us the number of responses according to gender for each question
all_gender <- all %>%
  pivot_longer(cols = !gender, 
               names_to = "question",
               values_to = "answer") %>%
  group_by(question, answer, gender) %>%
  count()

# relevel answers so they appear in the order which makes most sense rather than alphabetical
all_gender$answer <- fct_relevel(all_gender$answer, "Strongly disagree", "Disagree", "Agree", "Strongly agree", "Don't know")

# theme for plots
# give a consistent appearance to all plots
# reduce the code you write in each plot
theme_set(theme_bw(base_size = 14))
# specific for these plots
text <- theme(legend.title = element_blank(), 
              plot.title = element_text(size = 14, hjust = 0.5),
              axis.text.x = element_text(vjust = 0.4))

# Option 1 ####

# Q8 In my Department, women are actively encouraged to apply for promotion 
all_gender %>%
  ggplot(aes(x = gender, y = n, fill = answer)) +
  geom_bar(stat = 'identity', position = 'fill')

# change colours manually
all_gender %>%
  ggplot(aes(x = gender, y = n, fill = answer)) +
  geom_bar(stat = 'identity', position = 'fill') +
  scale_fill_manual(values = c("darkgoldenrod", "palegoldenrod", "darkslategray1", "steelblue1", "grey56"))

# change text on x and y axes
# I added a blank x axis as gender was self explanatory
all_gender %>%
  ggplot(aes(x = gender, y = n, fill = answer)) +
  geom_bar(stat = 'identity', position = 'fill') +
  scale_fill_manual(values = c("darkgoldenrod", "palegoldenrod", "darkslategray1", "steelblue1", "grey56")) +
  ylab("Proportion of responses\n") +
  xlab("") 

# change y axis labels to percentages
all_gender %>%
  ggplot(aes(x = gender, y = n, fill = answer)) +
  geom_bar(stat = 'identity', position = 'fill') +
  scale_fill_manual(values = c("darkgoldenrod", "palegoldenrod", "darkslategray1", "steelblue1", "grey56")) +
  ylab("Proportion of responses\n") +
  xlab("") + 
  scale_y_continuous(labels = scales::percent)
  
# add in the number of responses to each option on each bar and our font size etc theme from earlier
all_gender %>%
  ggplot(aes(x = gender, y = n, fill = answer)) +
  geom_bar(stat = 'identity', position = 'fill') +
  scale_fill_manual(values = c("darkgoldenrod", "palegoldenrod", "darkslategray1", "steelblue1", "grey56")) +
  ylab("Proportion of responses\n") +
  xlab("") + 
  scale_y_continuous(labels = scales::percent) + 
  geom_text(aes(label = n, vjust = 1), position = position_fill()) + 
  text

# add title
all_gender %>%
  ggplot(aes(x = gender, y = n, fill = answer)) +
  geom_bar(stat = 'identity', position = 'fill') +
  scale_fill_manual(values = c("darkgoldenrod", "palegoldenrod", "darkslategray1", "steelblue1", "grey56")) +
  ylab("Proportion of responses\n") +
  xlab("") + 
  scale_y_continuous(labels = scales::percent) + 
  geom_text(aes(label = n, vjust = 1), position = position_fill()) + 
  text + 
  ggtitle("In my Department, women are actively encouraged \nto apply for promotion")

# save
ggsave("Q8_1.pdf", width = 7, height = 4)



# Option 2 ####

# work out number of responses as a percentage of total respondents of each gender

# get number of respondents of each gender from the whole survey
fem <- subset(all, all$gender == "Female")
response_f <- nrow(fem)
mal <- subset(all, all$gender == "Male")
response_m <- nrow(mal)
prefer <- subset(all, all$gender == "Prefer not\n to say")
response_pns <- nrow(prefer)

# separate out the data from each gender so we can calculate percentages
f <- all_gender %>%
  filter(gender == "Female")
m <- all_gender %>%
  filter(gender == "Male")
pns <- all_gender %>%
  filter(gender == "Prefer not\n to say")

# calculate percentages for each gender group
f$percent <- f$n/response_f *100
m$percent <- m$n/response_m *100
pns$percent <- pns$n/response_pns *100

# round numbers to make them look pretty
f$percent <- format(round(f$percent, 1), nsmall = 1)
m$percent <- format(round(m$percent, 1), nsmall = 1)
pns$percent <- format(round(pns$percent, 1), nsmall = 1)

# put everything together again
gender2 <- bind_rows(f, m, pns)

# theme for these plots (include angle = 90)
text <- theme(legend.title = element_blank(), 
              plot.title = element_text(size = 14, hjust = 0.5),
              axis.text.x = element_text(angle = 90, vjust = 0.4, hjust=1))

# set the y axis to be the maximum reponse value for any gender response combination (so it is consistent across all plots in the survey)
y_max <- max(all_gender$n)

# let's graph it
gender2 %>%
  ggplot(aes(x = answer, y = n, fill = answer)) +
  geom_bar(stat = 'identity') +
  scale_fill_manual(values = c("darkgoldenrod", "palegoldenrod", "darkslategray1", "dodgerblue2", "grey56")) +
  ylab("Number of responses\n") +
  xlab("") + 
  geom_text(aes(x = answer, 
                y = n-0.6, label = paste0(percent,"%")), 
            size = 3) +
  text +
  ggtitle("In my Department, women are actively encouraged \nto apply for promotion") +
  ylim(0,y_max) +
  facet_wrap(~ gender)

# save
ggsave("Q8_2.pdf", width = 9.5, height = 4)
