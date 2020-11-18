## LOAD PACKAGES ####
library(tidyverse)

# 7.2.4 Exercises ####

# 1 Explore the distribution of each of the x, y, and z variables in diamonds. What do you learn? Think about a diamond and how you might decide which dimension is the length, width, and depth.

unusual = diamonds %>% 
  filter(y < 3 | y > 20) 

diamonds_usual = diamonds %>%
  setdiff(unusual) # I just googled this, never used setdiff before

summary(diamonds)
summary(diamonds_usual)

ggplot(diamonds, mapping = aes(x = x)) +
  geom_histogram(binwidth = 0.01)
ggplot(diamonds, mapping = aes(x = y)) +
  geom_histogram(binwidth = 0.01)
ggplot(diamonds, mapping = aes(x = z)) +
  geom_histogram(binwidth = 0.01)

#z is probs height, x and y depth and width


#2. Explore the distribution of price. Do you discover anything unusual or surprising? (Hint: Carefully think about the binwidth and make sure you try a wide range of values.)

ggplot(diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 1)
# ? there is a gap around 1750?


#3. How many diamonds are 0.99 carat? How many are 1 carat? What do you think is the cause of the difference?

diamonds %>% 
  filter(carat == 0.99) %>% 
  count(carat)

# 23

diamonds %>% 
  filter(carat == 1) %>% 
  count(carat)

#1558

#You want it to be in the next range, can probs sell for more

diamonds %>% 
  filter(carat >= 0.99 & carat <=1) %>% 
  group_by(carat) %>% 
  summarise(mean_price = mean(price))

diamonds %>% 
  filter(carat >= 0.5 & carat <=1.5) %>% 
ggplot(aes(carat, price)) + geom_point()
# yes there's a big jump in price at 1
  
#4. Compare and contrast coord_cartesian() vs xlim() or ylim() when zooming in on a histogram. What happens if you leave binwidth unset? What happens if you try and zoom so only half a bar shows?

ggplot(diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 100) 

ggplot(diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 100) +
  coord_cartesian(xlim = c(0,5000))

ggplot(diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 100) +
  xlim(c(0,5000))

ggplot(diamonds, mapping = aes(x = price)) +
  geom_histogram() +
  coord_cartesian(xlim = c(0,5000))

ggplot(diamonds, mapping = aes(x = price)) +
  geom_histogram() +
  xlim(c(0,5000))

# with xlim you get a warning about missing values, so it must remove values from calc? so subsets and then plots, whereas coord_cartesian literally zooms in.  Important for smooths!
# the difference is shown more clearly when you don't set binwidth

# Exercises 7.4.1 ####
# 1. What happens to missing values in a histogram? What happens to missing values in a bar chart? Why is there a difference?  idk, both have removed values???

diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

ggplot(diamonds2, mapping = aes(x = y)) +
  geom_histogram() 

ggplot(diamonds2, mapping = aes(x = y)) +
  geom_bar() 

  
#2.  What does na.rm = TRUE do in mean() and sum()?
mean(diamonds2$y)
mean(diamonds2$y, na.rm = TRUE)

sum(diamonds2$y)
sum(diamonds2$y, na.rm = TRUE) #gets rid of NAs

# 7.5.11 Exercises ####
# 1. Use what you’ve learned to improve the visualisation of the departure times of cancelled vs. non-cancelled flights.

library(nycflights13)

nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(binwidth = 1/4) + facet_wrap(~cancelled, scales = "free")
# I don't know what I'm doing here