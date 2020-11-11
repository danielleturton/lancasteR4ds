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

# 5.6
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

       