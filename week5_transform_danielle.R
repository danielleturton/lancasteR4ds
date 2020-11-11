## LOAD PACKAGES####
library(nycflights13)
library(tidyverse)

## 5.2.4 Exercises ####

# 1. Had an arrival delay of two or more hours
filter(flights, dep_delay > 120)

# 2. Flew to Houston (IAH or HOU)
filter(flights, dest %in% c("IAH", "HOU"))

# 3. Were operated by United, American, or Delta
filter(flights, carrier %in% c("UA", "DL", "AA"))

# 4. Departed in summer (July, August, and September)
filter(flights, month > 5 & month < 9)

# 5. Arrived more than two hours late, but didn’t leave late
filter(flights, dep_delay < 1 & arr_delay > 120)

# 6. Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights_clean, dep_delay > 60 & arr_delay < 31)

# 7. Departed between midnight and 6am (inclusive)
filter(flights, dep_time < 601)

#2. 
filter(flights, between(month, 6, 8))

#3. How many flights have a missing dep_time? What other variables are missing? What might these rows represent?
filter(flights, is.na(dep_time))
 #8,255 flights  

summary(flights)
# NAs in   dep_time, dep_delay,  arr_time  arr_delay  , air_time  :9430   - cancelled flights? CRASHED flights!!?


# 5.3.1 Exercises ####
# 1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
# from https://stackoverflow.com/questions/37760580/dplyr-arrange-function-sort-by-missing-values
flights %>% 
  arrange(desc(is.na(dep_time)),
          desc(is.na(dep_delay)),
          desc(is.na(arr_time)), 
          desc(is.na(arr_delay)),
          desc(is.na(tailnum)),
          desc(is.na(air_time)))

# 2. Sort flights to find the most delayed flights. Find the flights that left earliest.
arrange(flights, desc(dep_delay))
arrange(flights, desc(-dep_delay))

# 3. Sort flights to find the fastest (highest speed) flights.
flights %>% 
  arrange(desc(distance/air_time))

# 4. Which flights travelled the farthest? Which travelled the shortest?
arrange(flights, desc(distance)) %>% 
  select(origin, dest) #NY to Hawaii

arrange(flights, desc(-distance)) %>% 
  select(origin, dest)  #Newark to LaGuardia!

#5.5.1
# I didn't know how to do this
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)  

# 5.5.2 Exercises  ####
#1. Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they’re not really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.
transmute(flights,
          dep_time,
          sched_dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100,
          hour_sched = sched_dep_time %/% 100,
          minute_sched = sched_dep_time %% 100,
          mins_since_midnight_dep = hour*60 + minute,
          mins_since_midnight_sched = hour_sched*60 + minute_sched,
) 


# 2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?
transmute(flights,
          air_time, arr_time, dep_time,
          arr_time - dep_time
)
# you expect to see the minutes of air time but it doesn't work because hours/minutes

flights %>%
  mutate(dep_time_mins = (dep_time %/% 100)*60 + dep_time %% 100,
         arr_time_mins = (arr_time %/% 100)*60 + arr_time %% 100,
         air_time2 = arr_time_mins - dep_time_mins) %>%
  select(air_time, air_time2, dep_time, arr_time, dep_time_mins, arr_time_mins)
# THIS ISN'T RIGHT - CAN ANYONE FIX? IS IT TO DO WITH TIME ZONES?


# 3. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
flights %>%
  select(dep_time, sched_dep_time, dep_delay)
# sched_dep_time - dep_time, taking into account hours an minutes as above...

  
# 4. Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().

arrange(flights, min_rank(desc(dep_delay))) %>% select(dep_delay) %>% print(n = 10)

# 5. What does 1:3 + 1:10 return? Why?
  
# 6.What trigonometric functions does R provide?
sin(pi/6)


# 5.6.7 Exercises ####

# 4. Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights related to the average delay?
cancelled = flights %>% 
  filter(is.na(dep_delay) | is.na(arr_delay) )

cancelled %>% 
  group_by(day) %>% 
  summarise(n = n()) %>%
  ggplot(aes( x = day, y = n)) +  geom_point() + geom_smooth()


# 5. Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n()))

# 5.7.1 Exercises ####

# 1. Refer back to the lists of useful mutate and filtering functions. Describe how each operation changes when you combine it with grouping.

# 2. Which plane (tailnum) has the worst on-time record?

flights %>% 
  filter(!is.na(arr_delay)) %>% 
  group_by(tailnum) %>% 
  summarise(mean_arr_delay = mean(arr_delay)) %>%
  arrange(mean_arr_delay)

































