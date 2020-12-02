library(tidyverse)
as_tibble(iris)

## Exercises 10.5

# 1. tibble restricts no. of rows, gives dimensions of data, removes rownames
print(mtcars)
as_tibble(iris)

# 2.

#3.


#4.
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
#4.1 
annoying$`1`

plot(annoying$`1`, annoying$`2`)
ggplot(annoying, aes(`1`, `2`)) + geom_point()

annoying$`3` = annoying$`2`/annoying$`1`

annoying = annoying %>%
  rename(one = 1, two = 2, three = 3)

#5. #adds a row number? NO, CONVERTS VECTORS INTO DATAFRAMES - GREAT
tibble::enframe(annoying$two)
tibble::enframe(mtcars$mpg)


#6.
print(as_tibble(iris), n = 30)

