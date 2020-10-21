# Sam Kirkham 2020-10-21
# A quick demo for lancasteR4ds group: on using functions and plotting

### A quick intro to functions ###

# here's the formula to convert Hertz to Bark scale
# ((26.81 * freq_hz) / (1960 + freq_hz)) - 0.53

# let's do this on some formants
# let's use some formants of a neutral vocal tract(i.e. F1 = 500 Hz, F2 = 1500 Hz, F3 = 2500 Hz, etc). We just substitue the above 'freq_hz' with the relevant formant value
((26.81 * 500) / (1960 + 500)) - 0.53
((26.81 * 1500) / (1960 + 1500)) - 0.53
((26.81 * 2500) / (1960 + 2500)) - 0.53

# however, it's quite tedious copying and pasting like the above, and we could also end up making an error somewhere

# instead, we can write a function 'bark()' to reduce code repetition
# inside the 'function()' are the arguments that our function takes. You'll see within the function code that 'freq_hz' is a variable that takes on whatever value we give it when we run the 'bark()' function
bark <- function(freq_hz){
  ((26.81 * freq_hz) / (1960 + freq_hz)) - 0.53
}

# now we can run bark function on different formant values
bark(500)
bark(1500)
bark(2500)

# or we can run the function on a list of numbers
bark(c(500, 1500, 2500))

# to illustrate this further, let's generate 10,000 Hz values (from 1-10,000 Hz)
hz_values <- c(1:10000)

# now let's convert all of those Hz values to Bark values
bark_values <- bark(hz_values)

# plot hz/bark values to examine the relationship between the two scales
# note: I've done this plot in base R as it's so simple and I was doing this live
plot(hz_values, bark_values, type = "l")


### Now let's do a basic plot within a function ###

# let's assume we want to make a plot and test out different colours and titles

# let's do a scatterplot in blue
ggplot(cars) +
  aes(x = speed, y = dist) +
  geom_point(colour = "blue") +
  ggtitle("This is a plot in blue")

# let's do a scatterplot in green
ggplot(cars) +
  aes(x = speed, y = dist) +
  geom_point(colour = "green") +
  ggtitle("This is a plot in green")

# let's do a scatterplot in red
ggplot(cars) +
  aes(x = speed, y = dist) +
  geom_point(colour = "red") +
  ggtitle("This is a plot in red")


# the above is fairly tedious
# instead of copy/paste, let's do a function
my.plot <- function(df, colour, title){
  ggplot(df) +
    aes(x = speed, y = dist) +
    geom_point(colour = colour) +
    ggtitle(title)
}

# run function to generate plots we made above
# this results in less code, as 4 lines for each plot has been reduced to 1
my.plot(cars, "blue", "This is a plot in blue")
my.plot(cars, "green", "This is a plot in green")
my.plot(cars, "red", "This is a plot in red")

# note you could also go further using R's apply functions, which would allow you to loop the my.plot function over a list of colours. This would avoid having to copy paste the my.plot function 4 times and make it more replicable and adaptable. I'll show something like that in the future.