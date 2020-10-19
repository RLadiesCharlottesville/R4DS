---
title: "Data Transformation"
author: "Samantha Toet"
date: "7/20/2018"
output: html_document
---

## Intro

From [5. Data Transformation](http://r4ds.had.co.nz/transform.html)

*Ch.3 in the printed copy*

Load packages and sample dataset:

```{r, echo=TRUE, message=FALSE, warning=FALSE, results = 'hide'}
library(tidyverse)
library(nycflights13)
nycflights13::flights
```

## The 5 Main `dplyr` Functions:

- `filter()` rows
- `arrange()` rows
- `select()` columns
- add columns with `mutate()`
- `summarise()` to a single row

All of these functions work in the same way: 

`function`(`dataframe`, what you want to do to the dataframe based on its variables)

```{r, echo=FALSE}
print("a new dataframe")
```

This new dataframe is not saved, so you should assign it to something if you want to use it again. A **tibble** is a dataframe that is slightly tweaked to work better in the tidyverse.

All of these functions can be used with `group_by()` which changes the scope of each function from operating on the entire dataset to operating on it group-by-group. *Think layers in ggplot.*

## 1.) `filter()` rows

- subset objects based on values
- structure: `filter(dataset, column comparison_and/or_logical_operation, ...)`
- if you want to determine if a value is missing, use `is.na()`

###Practice###

**1.) Find all flights that:**

**1.  Had an arrival delay of two or more hours**

```{r, echo=TRUE, results='hide', warning=FALSE}
filter(flights, arr_delay >= 120)
```

There were 10,200 flights that had an arrival delay of two or more hours. 

**2. Flew to Houston (IAH or HOU)**

```{r, echo=TRUE, results='hide'}
filter(flights, dest %in% c('IAH', 'HOU'))
```

There were 9,313 flight that landed in Houston. 

**3. Were operated by United, American, or Delta**

```{r, echo=TRUE, results='hide'}
filter(flights, carrier %in% c('UA', 'AA', 'DL'))
```

There were 139,504 flights operated by United, American Airlines, or Delta.

**4. Departed in summer (July, August, and September)**

```{r, echo=TRUE, results='hide'}
filter(flights, month %in% 7:9)
```

There were 86,326 flights between July - September. 

**5. Arrived more than two hours late, but didn’t leave late**

```{r, echo=TRUE, results='hide'}
filter(flights, arr_delay > 120 & dep_delay <= 0)
```

There were 29 flights that arrived more than 2 hours late but didn't leave late. 

**6. Were delayed by at least an hour, but made up over 30 minutes in flight**

```{r, echo=TRUE, results='hide'}
filter(flights, dep_delay >= 60, (dep_delay - arr_delay > 30))
```

There were 1,844 flights that were delayed by at least an hour but made up over 30 minutes in flights. 

**7. Departed between midnight and 6am (inclusive)**

```{r, echo=TRUE, results='hide'}
filter(flights, dep_time == 2400 | dep_time <= 600)
```

There were 9,373 flights that departed between midnight and six am. 

**2.) Another useful dplyr filtering helper is `between()`. What does it do? Can you use it to simplify the code needed to answer the previous challenges?** 

**Answer**: `between()` tells us if the values in a numeric vector fall within a specified range. It is a shortcut for `x >= left & x <= right`. 

You could rewrite 1.4.:
```{r, echo=TRUE, results = 'hide'}
filter(flights, month %in% 7:9) # original
filter(flights, between(month, 7, 9)) # using between()
```

**3.) How many flights have a missing `dep_time`? What other variables are missing? What might these rows represent?**

```{r, echo=TRUE, results='hide'}
filter(flights, is.na(dep_time)) 
```

**Answer**: there are 8,255 flights that are missing a departure time. These flights are all missing arrival times, delays, and air times so they were most likey cancelled. 

**4.) Why is `NA ^ 0` not missing? Why is `NA | TRUE` not missing? Why is `FALSE & NA` not missing? Can you figure out the general rule? (`NA * 0` is a tricky counterexample!)**

**Answer**: <span style="color:blue"> `NA ^ 0` = 1, or not missing, because any number divided by itself equals 1. For `NA | TRUE`, since the `|` operator returns `TRUE` if either of the terms are true, the whole expression returns `TRUE` or not missing.  With `FALSE & NA`, `&` returns `TRUE` when both terms are true. So for `FALSE & NA`, one of the terms is false, so the entire expression evaluates to `FALSE`. </span>

## 2.) `arrange()` rows

- order rows based on values in columns
- use `desc()` to arrange from highest to lowest
- missing values always stored at the end

### Practice 

**1.) How could you use `arrange()` to sort all missing values to the start? (Hint: use `is.na()`)**

**Answer** to sort all missing values to the front, use `!is.na()`:

```{r, echo=TRUE}
arrange(flights, !is.na(dep_time))
```

**2.) Sort `flights` to find the most delayed flights. Find the flights that left earliest.**

**Answer**: the most delayed flight was delayed by 1301 minutes, and the earliest flight left 43 minutes before scheduled take off. 

```{r, results='hide'}
arrange(flights, desc(dep_delay)) # latest
arrange(flights, dep_delay) # earliest
```

**3.) Sort `flights` to find the fastest flights.**

**Answer**: speed is (distance / time), so we'll have to make a new column, called `speed` with the calculated speed for each flight and then sort on that variable. 
```{r, echo=TRUE, results='hide'}
flights$speed <- flights$distance / flights$air_time # create new variable
arrange(flights, desc(speed)) # sort on that variable
```

The fastest flight flew at an average speed of 11.72 miles per minute from `LGA` to `ATL`. 

**4.) Which flights travelled the longest? Which travelled the shortest?**

**Answer**: the longest flight traveled 4983 miles from `JFK` (New York) to `HNL` (Hawaii), and the shortest flight would have (it was cancelled) traveled 17 miles from `EWR` (New Jersey) to `LGA` (New York). 

```{r, echo=TRUE, results='hide'}
arrange(flights, desc(distance)) # longest
arrange(flights, distance) # shortest
```

## 3.) `select()` columns

- zoom in on a subset using operations based on the names of the variables
- helper functions:
+ `starts_with("abc")` matches names that start with "abc"
+ `ends_with("xyx")` matches names that end with "xyz"
+ `contains("ijk")` matches all names that contain "ijk"
+ `matches(regex)` selects variables that match a regular expression
- since `select()` drops variables not selected, use `rename()`

### Practice

**1.) Brainstorm as many ways as possible to select `dep_time`, `dep_delay`, `arr_time`, and `arr_delay` from `flights`.**

**Answer**: I'm sure there are more ways than this:

```{r, echo=TRUE}
select(flights, dep_time, dep_delay, arr_time, arr_delay)
```

**2.) What happens if you include the name of a variable multiple times in a `select()` call?**

**Answer**: `select()` only keeps the first call of the variable. However if you call it twice, but rename the variable the second time, `select()` only takes the newly named column. 

```{r, echo=TRUE}
select(flights, dep_time, dep_time) # only one column for dep_time
select(flights, dep_time, test = dep_time) # only one column, called test 
```

**3.) What does the `one_of()` function do? Why might it be helpful in conjunction with this vector?**

`vars <- c("year", "month", "day", "dep_delay", "arr_delay")`

**Answer**: `one_of()` selects variables in a character (strings) vector. If you have a character vector that you want to pass in, rather than list each of the bare column names, you can use `one_of()`. It lets you misspell names. 

```{r, echo=TRUE}
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))

select(flights, year, month, day, dep_delay, arr_delay) # same thing
```

**4.) Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can you change that default?**

```{r, echo=TRUE}
select(flights, contains("TIME"))
```

**Answer**: the helper function `contains()` ignores cases with the string. To make the function case sensitive, set `ignore.case = TRUE` within the call. 

## 4.) add columns with `mutate()`

- add new columns that are functions of existing columns
- new columns added to the end of the dataset
- if you only want to keep the new variables, use `transmute()`
- function must be *vectorised*: it must take a vector of values as input, return a vector with the same number of values as output

### Practice

**1.) Currently `dep_time` and `sched_dep_time` are convenient to look at, but hard to compute with because they’re not really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.**

**Answer**: lets convert all the time variables from integers (HHMM) into the number of minutes since midnight and save these new variables to `flights`. To do this we take the time variable and count the number of times 100 (because the numbers are base 10) can go into the number (only whole numbers) and store as `num_hours`. Then multiply `num_hours` by 60 to get total minutes. Then use the remainder function `%%` to figure out how many minutes need to be added. 

```{r, echo=TRUE, results='hide'}
# departure time:
flights <-  mutate(flights, new_dep_time = (dep_time %/% 100)*60 + (dep_time %% 100) ) 

# scheduled departure time:
flights <-  mutate(flights, new_sched_dep_time = (sched_dep_time %/% 100)*60 + (sched_dep_time %% 100) ) 

# arrival time:
flights <-  mutate(flights, new_arr_time = (arr_time %/% 100)*60 + (arr_time %% 100) ) 

# scheduled arrival time:
flights <- mutate(flights, new_sched_arr_time = (sched_arr_time %/% 100)*60 + (sched_arr_time %% 100) )

my_func <- function(vec){ 60*(vec %/% 100) + vec%%100 }

flights %>% mutate(new_dep = my_func(dep_time))
```

**2.) Compare `air_time` with `arr_time - dep_time`. What do you expect to see? What do you see? What do you need to do to fix it?**

```{r, echo=TRUE}
mutate(flights, time2 = arr_time - dep_time) %>% # using HHMM 
    select(air_time, time2)

mutate(flights, time3 = new_arr_time - new_dep_time) %>% # using minutes after midnight
    select(air_time, time3)

# attempt at dealing with timezones:
airports %>%
    select(dest = faa, tz) %>%
    inner_join(flights) %>%
    mutate(tz = (tz + 5) * 60,
           new_arr_time = arr_time + tz,
           new_airtime = new_arr_time - dep_time) %>%
    select(new_airtime, air_time)
```

**Answer**: even when converted to minutes after midnight, `air_time` and `arr_time - dep_time` are still fairly different. Maybe it has something to do with timezones????

**3.) Compare `dep_time`, `sched_dep_time`, and `dep_delay`. How would you expect those three numbers to be related?**

```{r, echo=TRUE}
mutate(flights, new_est_delay = new_dep_time - new_sched_dep_time) %>% 
    select(new_est_delay, dep_delay) 
```

**Answer**: `dep_delay` = `sched_dep_time` - `dep_time`. 

**4.) Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for `min_rank()`.**

```{r, echo=TRUE}
filter(flights, min_rank(desc(dep_delay))<=10) 
# or:
flights %>% top_n(n = 10, wt = dep_delay)
```

**Answer**: `min_rank()` is equivalent to `rank(ties.method = "min")`. It does the most usual type of ranking (e.g. 1st, 2nd, 2nd, 4th). The default gives smallest values the small ranks. 

**5.) What does 1:3 + 1:10 return? Why?**

```{r, echo=TRUE}
1:3 + 1:10
```

**Answer**: When the vectors are added, the shorter vector is repeated out to the length of the longer one. Because 10 doesn't divide exactly by 3, the vectors do not line up properly and we get a warning message. 

**6.)What trigonometric functions does R provide?**
```{r, echo=TRUE}
?Trig
```

**Answer**: R provides functions to compute the cosine, sine, tangent, arc-cosine, arc-sine, arc-tangent, and the two-argument arc-tangent.

## 5.) `summarise()` to a single row

- collapse a dataset into a single row - not very interesting
- `group_by()` columns, then use `summarise()` to apply by group aka *group summaries* - much more interesting
- `group_by()` doesn't create a new df, but new groups within the df (split, apply, combine)
- the pipe `%>%` helps make data more readable
- if there’s any missing value in the input, the output will be a missing value
- include either a count `(n())`, or a count of non-missing values `(sum(!is.na(x)))` to check that you’re not drawing conclusions based on very small amounts of data
- use `ungroup()` to remove a grouping

### Practice

**1. Brainstorm at least 5 different ways to assess the typical delay characteristics of a group of flights. Consider the following scenarios:**

**- a.)  A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.**

**- b.) A flight is always 10 minutes late.**

**- c.) A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.**

**- d.) 99% of the time a flight is on time. 1% of the time it’s 2 hours late.**

**- e.) Which is more important: arrival delay or departure delay?**

**Answers**: these answers will relay on the following dataset:

```{r, echo=TRUE, results='hide'}
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
```

**1.a.) A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time:**

```{r, echo=TRUE}
not_cancelled %>%
    mutate(early = arr_delay < -15, # 15 min early = -15
           late = arr_delay > 15) %>%  # 15 min late
    group_by(flight) %>% # group by flight
    summarise(pct_early = sum(early) / n(), # find percentages (sum T's/n)
              pct_late = sum(late) / n()) %>%
    filter(pct_early == 0.5 & pct_late == 0.5) # filter only flights where percentages are 50
```

**Answer**: there 19 flights that are 15 minutes early 50% of the time and 15 minutes late 50% of the time. 

**1.b.) A flight is always 10 minutes late. **

```{r, echo=TRUE}
not_cancelled %>%
    group_by(flight) %>%
    filter(dep_delay > 10) %>% # all flights with dep delay > 10 minutes
    summarise(avg_dep_delay = mean(dep_delay)) %>% # avg dep delay by flight num
    arrange(desc(avg_dep_delay))
```

**Answer**: of all the flights that have a departure delay of over 10 minutes, the flight `5017` has an average delay of 372 minutes (or 6.2 hours)! 

**1.c.) A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.**

```{r, echo=TRUE}
not_cancelled %>%
    mutate(early = arr_delay < -30, # 30 min early = -30
           late = arr_delay > 30) %>%  # 30 min late
    group_by(flight) %>% # group by flight
    summarise(pct_early = sum(early) / n(), # find percentages (sum T's/n)
              pct_late = sum(late) / n()) %>%
    filter(pct_early == 0.5 & pct_late == 0.5) # filter only flights where percentages are 50
```

**Answer**: there are three flights that arrive 30 minutes early 50% of the time, and 30 minutes late 50% of the time: `3651`, `3916`, and `3951`.

**1.d.) 99% of the time a flight is on time. 1% of the time it’s 2 hours late.**

```{r, echo=TRUE}
not_cancelled %>%
    mutate(on_time = arr_delay == 0, 
           late = arr_delay > 120) %>%
    group_by(flight) %>%
    summarise(pct_on_time = sum(on_time) / n(),
              pct_late = sum(late) / n()) %>%
    filter(pct_on_time >= 0.99 & pct_late > 0.01) %>%
    arrange(desc(pct_late))
```

**Answer**: there are no flights that are on time 99% of the time and 2 hours late 1% of the time.

**1.e.) Which is more important: arrival delay or departure delay?**

**Answer**: while arrival delay might be more important (the reason people fly is to get to a place by a certain time), if there is a departure delay, then there is most likely going to be an arrival delay, so departure delay is a fairly good indicator of actual arrival time. 

**2.) Come up with another approach that will give you the same output as `not_cancelled %>% count(dest)` and `not_cancelled %>% count(tailnum, wt = distance)` (without using `count()`).**

```{r, echo=TRUE, results='hide', message=FALSE}
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
```

**Answer**: using `group_by()` and `summarise()` with `n` you can do similar things as `count()`.

```{r, echo=TRUE}
# 1
not_cancelled %>% 
    count(dest) 

# can be written as:
not_cancelled %>% 
    group_by(dest) %>%
    summarise(n = n())

# 2
not_cancelled %>% 
    count(tailnum, wt = distance)

# can be written as:
not_cancelled %>%
    group_by(tailnum) %>%
    summarise(n = sum(distance))

```

**3.) Our definition of cancelled flights `(is.na(dep_delay) | is.na(arr_delay)` ) is slightly suboptimal. Why? Which is the most important column?**

**Answer**: there are no flights which arrived but did not depart (<span style="color:blue">Why?</span>), so `dep_delay` is the most important column. 

```{r}
flights %>%
    group_by(departed = !is.na(dep_delay), arrived = !is.na(arr_delay)) %>%
    summarise(n=n())
```

**4.) Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights related to the average delay?**

```{r, echo=TRUE}
# to look at the number of flights cancelled per day:
filter(flights, is.na(dep_delay)) %>% # cancelled flights
    group_by(month, day) %>% # group by month and day
    count() %>% # count number of items in each group
    ggplot(aes(x = day, y = n, color = month)) + # n is number canceled flights
    geom_point() # plot it \


# to look for relationship b/w prop of cancelled flights to avg delay:
flights %>%
    group_by(month, day) %>% # group by month and day
    summarise(avg_delay = mean(dep_delay, na.rm = TRUE), # avg delay
              num_cancelled = sum(is.na(dep_delay)), # num cancelled
              prop_cancelled = num_cancelled / n()) %>% # prop cancelled
    ggplot(aes(x = avg_delay, y = prop_cancelled)) + # plot prop by avg_delay
    geom_point() + # scatterplot
    stat_smooth() # smooth line
```

**Answer**: there doesn't seem to be a pattern predicting the number of cancelled flights per day. However, there is a *slight* trend between the greater the average delay and the number of delays per day. 

**5.) Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about `flights %>% group_by(carrier, dest) %>% summarise(n())`)**

```{r, echo=TRUE}
# flight carriers that have the highest average delays:
flights %>%
    group_by(carrier) %>% # group flights by carrier
    summarise(avg_delay = mean(dep_delay, na.rm = TRUE)) %>% # avg delay
    arrange(desc(avg_delay)) # sort highest to lowest

# disentangle carrier from airport:
flights %>% 
    group_by(carrier, origin) %>% # group carrier and destination
    summarise(n(), avg_delay = mean(dep_delay, na.rm = TRUE)) %>% # avg delay
    ggplot(aes(x = carrier, y = avg_delay, col = origin)) + # plot
    geom_point()
```

**Answer**: the carrier `F9` has the highest average departure delay of 20.22 minutes. `EV`, `YV`, `FL` follow closely behind with an average delay of 19.96,  and 19.00 minutes, respectively. It's difficult to disentangle the carrier from the airport because both origin and destination airports play a factor in the delay of the flight. 

**6.) What does the `sort` argument to `count()` do. When might you use it?**

**Answer**: if `sort = TRUE`, then the output of `count()` will be sorted in descending order of `n`. 

## grouped mutates and filters

- use `group_by()` with `filter()` to find 
+ the worst members of each group
+ all groups bigger than a threshold
+ to standardise to compute per group metrics

### Practice

**1.) Refer back to the lists of useful mutate and filtering functions. Describe how each operation changes when you combine it with grouping.**

Mutate helper functions:

- Arithmetic operators: `+`, `-`, `*`, `/`, `^`
- Modular arithmetic: `%/%` (integer division) and `%%` (remainder)
- Logs: `log()`, `log2()`, `log10()`
- Offsets: `lead()` and `lag()`
- Cumulative and rolling aggregates: `cumsum()`, `cumprod()`, `cummin()`, `cummax()`, and `cumean()`
- Logical comparisons: `<`, `<=`, `>`, `>=`, `!=`, `==`, `&`, `|` 
- Ranking: `min_rank()`, `row_number()`, `dense_rank()`, `percent_rank()`, `cume_dist()`, `ntile()`

**Answer**: `mutate()` adds a new column with the group-wise value. This new column will have the length of the dataframe, but with repeated values corresponding to each group. For example:

```{r, echo=TRUE}
flights %>%
    group_by(flight) %>% # group by flight number
    mutate(avg_dep_delay = mean(dep_delay)) # avg delay for EACH FLIGHT NO.
```

In the case of `filter()`, `group_by()` sorts the data into groups, and `filter()` keeps only the rows that satisfy the filter, per group, leaving a smaller dataframe. For example:

```{r, echo=TRUE}
not_cancelled %>%
    group_by(flight) %>% # group by flight number
    filter(dep_delay == max(dep_delay)) # show only rows where dep delay = max
```

**2.) Which plane (tailnum) has the worst on-time record?**

```{r}
flights %>%
    group_by(tailnum)%>% # group by tailnum
    filter(!is.na(arr_delay)) %>% # filter to remove NA's
    summarise(avg_arr_delay = mean(arr_delay)) %>% # average arr delay
    arrange(desc(avg_arr_delay))
```

**Answer**: on average, flight `N844MH` has an average delay of 320 minutes. 

<span style="color:blue">Is there a better way to answer this question? Is there a more accurate function other than mean?</span>

**3.) What time of day should you fly if you want to avoid delays as much as possible?**

```{r, echo=TRUE}
# note that hour is dependent on arrival time and is in 24:00 format

flights %>%
    group_by(hour) %>% # group by (arrival) hour
    filter(!is.na(dep_delay)) %>% # filter to remove NA's
    summarise(avg_dep_delay = mean(dep_delay)) %>% # average dep delay
    ggplot(aes(x = hour, y = avg_dep_delay)) + # plot it
    geom_col()
```

**Answer**: on average, flights that *arrive* around 9pm are the most delayed. 

<span style="color:blue">But what about *departure* time? Since departure time affects arrival time, when most people book their flights they want it to depart on time. </span> 

Let's take a look:

```{r, echo=TRUE}
flights %>%
    mutate(dep_hour = str_pad(sched_dep_time, 4, "left", "0")) %>% # make dep hr
    group_by(dep_hour) %>% # group by departure hour
    filter(!is.na(dep_delay)) %>% # filter to remove NA's
    summarise(avg_dep_delay = mean(dep_delay)) %>% # average dep delay by group
    arrange(desc(avg_dep_delay))
```

On average, flights that depart around 22:00 (9pm) have the greatest departure delays. 

**4.) For each destination, compute the total minutes of delay. For each flight, compute the proportion of the total delay for its destination.**

**Answer**: see below outputs

```{r, echo=TRUE}
# total minutes for each destination:
not_cancelled %>%
    group_by(dest) %>% 
    summarise(total_delay = sum(arr_delay)) # dest pertains to arival delay

# prop of total delay for dest by flight:
not_cancelled %>%
    group_by(flight) %>% # group by flight
    mutate(total_delay = sum(arr_delay)) %>% # total arr delay for each flight
    group_by(dest, flight) %>% # group by destination and flight
    summarise(prop_delay = sum(arr_delay) / unique(total_delay)) # prop of total delay for each flight
```

**5.) Delays are typically temporally correlated: even once the problem that caused the initial delay has been resolved, later flights are delayed to allow earlier flights to leave. Using `lag()`, explore how the delay of a flight is related to the delay of the immediately preceding flight.**

```{r, echo=TRUE}
not_cancelled %>%
    group_by(origin, month, day) %>% # group by origin, month, and day
    arrange(dep_time) %>% # arrange by departure time
    mutate(dep_lag = lag(dep_delay)) %>% # find lag for each dep_delay
    ggplot(aes(x = dep_delay, y = dep_lag)) + # plot it to compare
    geom_point()
```

**Answer**: this one is tricky, because there are a couple ways to look into it. Are we looking at delays at the origin airport, or delays along the flight? In this case, we looked at delays along a flight's daily route. 

**6.) Look at each destination. Can you find flights that are suspiciously fast? (i.e. flights that represent a potential data entry error). Compute the air time a flight relative to the shortest flight to that destination. Which flights were most delayed in the air?**

```{r, echo = TRUE}
# suspiciously fast flights:
not_cancelled %>%
    group_by(dest) %>% # group by destination
    mutate(speed = distance / air_time) %>% # calculate speed
    arrange(desc(speed)) # arrange highest to lowest

# shortest flight for destination:
not_cancelled %>%
    group_by(dest) %>% # group by destination
    filter(air_time == min(air_time)) %>% # only keep min air times
    select(dest, min_air = air_time) %>% # select destination and air time
    inner_join(flights, by = "dest") %>% # join flights by dest
    mutate(relative_air = air_time / min_air) %>% # calulate relative air time
    arrange(desc(relative_air)) # arrange highest to lowest
```

**Answer**: flight number `1499` (tailnum `N666DN`) flew from `LGA` to `ATL` going an average of 11.72 miles per minute. Flights arriving in `BOS` appear to be the most delayed in the air. 

**7.) Find all destinations that are flown by at least two carriers. Use that information to rank the carriers.**

```{r, echo=TRUE}
not_cancelled %>% 
    group_by(dest) %>% # group by destination
    mutate(num_carriers = length(unique(carrier))) %>% # find num carriers for dest
    filter(num_carriers > 1) %>% # keep only multiple carriers
    group_by(carrier, add = T) %>% # group by carriers
    summarise(avg_dep_delay = mean(dep_delay)) %>% # find avg dep delay
    mutate(rank = dense_rank(avg_dep_delay)) %>% # calculate rank w/o gaps
    group_by(carrier) %>% # group by carrier
    summarise(avg_rank = mean(rank)) %>% # find mean rank for carrier
    arrange(avg_rank) # sort
```

**Answer**: see above output. 

**8.) For each plane, count the number of flights before the first delay of greater than 1 hour.**

```{r, echo=TRUE}
not_cancelled %>% 
    group_by(tailnum) %>% # group by tail number
    arrange(time_hour) %>% # sort lowest time to highest time
    mutate(num_before_big_delay = sum(cumall(dep_delay <60))) # find num flights
```

**Answer**: see above output. 


*That's all folks!*












