Data Visualization with ggplot2
================
Samantha Toet
7/2/2018

From [3. Data Visualization](http://r4ds.had.co.nz/data-visualisation.html)

*Ch. 1 in the printed copy*

Intro
-----

Load tidyverse package:

``` r
library(tidyverse)
```

The grammar of graphics assembles plots in layers, and each layer is relatively independent. That means you create your graph in a series of independent actions: creating the plot and assigning the axes, building a geometric object from your data, and mapping variables as different aesthetics.

Each geom function in ggplot2 takes a `mapping` argument. This defines how variables in your dataset are mapped to visual properties. The `mapping` argument is always paired with `aes()`, and the `x` and `y` arguments of `aes()` specify which variables to map to the x and y axes. The `x` and `y` variables are themselves aesthetic mappings.

Essentially anytime there is a variable that you want to look at, put it in aesthetics.

Y vs X

### Practice

**1. Run `ggplot(data = mpg)`. What do you see?**

``` r
ggplot(data = mpg)
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-2-1.png)

**Answer**: An empty plot.

**2. How many rows are in `mpg`? How many columns?**

``` r
dim(mpg)
```

    ## [1] 234  11

**Answer**: there are 234 rows and 11 columns.

**3. What does the `drv` variable describe? Read the help for `?mpg` to find out.**

``` r
?mpg
```

**Answer**: the `drv` variable describes the drive mode of the car. It is a factor with three levels `f` = front-wheel drive, `r` = rear wheel drive, `4` = 4wd.

**4. Make a scatterplot of `hwy` vs `cyl`.**

**Answer**: see below:

``` r
ggplot(mpg, mapping = aes(x = cyl, y = hwy)) +
    geom_point()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-5-1.png)

**5. What happens if you make a scatterplot of `class` vs `drv`? Why is the plot not useful?**

``` r
ggplot(mpg, mapping = aes(x = drv, y = class)) +
    geom_point()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-6-1.png)

**Answer**: it doesn't make sense to plot a non-numerical variable on the y axis.

Aesthetic Mappings
------------------

You can add a third variable to a two-dimensional plot by mapping it to an aesthetic.

To set an aesthetic manually, set the aesthetic by name as an argument of your geom function; i.e. it goes *outside* of `aes()`. You’ll need to pick a level that makes sense for that aesthetic:

-   The name of a color as a character string.
-   The size of a point in mm.
-   The shape of a point as a number

*Note*: Of the 25 point numbers, some are affected by the `fill` and `colour` aesthetics.

### Practice

**1. What’s gone wrong with this code? Why are the points not blue?**

``` r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-7-1.png)

**Answer**: the points appear red as an error message. If you want to set the point color to be blue, you need to set it outside of the call to `aes()` because it is not a variable and `aes()` only cares about variables, but also inside of `geom_point()` because we want to change the colors of the points only. To do this:

``` r
ggplot(mpg) +
    geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-8-1.png)

**2. Which variables in `mpg` are categorical? Which variables are continuous? (Hint: type `?mpg` to read the documentation for the dataset). How can you see this information when you run mpg?**

``` r
mpg
```

    ## # A tibble: 234 x 11
    ##    manufacturer model    displ  year   cyl trans   drv     cty   hwy fl   
    ##    <chr>        <chr>    <dbl> <int> <int> <chr>   <chr> <int> <int> <chr>
    ##  1 audi         a4         1.8  1999     4 auto(l… f        18    29 p    
    ##  2 audi         a4         1.8  1999     4 manual… f        21    29 p    
    ##  3 audi         a4         2    2008     4 manual… f        20    31 p    
    ##  4 audi         a4         2    2008     4 auto(a… f        21    30 p    
    ##  5 audi         a4         2.8  1999     6 auto(l… f        16    26 p    
    ##  6 audi         a4         2.8  1999     6 manual… f        18    26 p    
    ##  7 audi         a4         3.1  2008     6 auto(a… f        18    27 p    
    ##  8 audi         a4 quat…   1.8  1999     4 manual… 4        18    26 p    
    ##  9 audi         a4 quat…   1.8  1999     4 auto(l… 4        16    25 p    
    ## 10 audi         a4 quat…   2    2008     4 manual… 4        20    28 p    
    ## # ... with 224 more rows, and 1 more variable: class <chr>

``` r
?mpg
```

**Answer**: `manufacturer`, `model`, `trans`, `drv`, `fl`, `class`, `year`, and `cyl` are categorical, and `displ`, `cty`, and `hwy` are continuous.

**3. Map a continuous variable to `color`, `size`, and `shape`. How do these aesthetics behave differently for categorical vs. continuous variables?**

``` r
# Continuous variable cty mapped to color:
ggplot(mpg, mapping = aes(x = displ, y = hwy, color = cty)) +
    geom_point()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-10-1.png)

``` r
# Continuous variable cty mapped to size:
ggplot(mpg, mapping = aes(x = displ, y = hwy, size = cty)) +
    geom_point()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-11-1.png)

``` r
# Continuous variable cty mapped to shape:
ggplot(mpg, mapping = aes(x = displ, y = hwy, shape = cty)) +
    geom_point()
```

    ## Error: A continuous variable can not be mapped to shape

![](ggplot2_files/figure-markdown_github/unnamed-chunk-12-1.png)

**Answer**: color becomes gradient when used on a continuous variable, size becomes increasingly large when used on a continuous variable, and shape cannot have a continous variable mapped to it.

**4. What happens if you map the same variable to multiple aesthetics?**

``` r
# hwy mapped to y axis and color
ggplot(mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, color = hwy)) 
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-13-1.png)

**Answer**: It's doable, but not really necessary, unless you really need to emphasize something or need to convert it to black and white.

**5. What does the `stroke` aesthetic do? What shapes does it work with? (Hint: use `?geom_point`)**

``` r
?geom_point
```

**Answer**: `stroke` controls the thickness of the border width of shapes 21-25. The `size` and `stroke` are additive so a point with size = 5 and stroke = 5 will have a diameter of 10mm.

**6. What happens if you map an aesthetic to something other than a variable name, like `aes(colour = displ < 5)`?**

``` r
ggplot(mpg, mapping = aes(x = displ, y = hwy, color = displ < 5)) +
    geom_point()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-15-1.png)

**Answer**: ggplot2 it treats `displ < 5` as a logical variable and maps color to the `TRUE` or `FALSE` responses.

Facets
------

-   subplots that contain one subset of data
-   useful for categorical variables
-   to facet by a single variable, use `facet_wrap()`, for multiple use `facet_grid()`

### Practice

**1. What happens if you facet on a continuous variable?**

**Answer**: ggplot tries to create a subplot for each value of the continuous variable - this can get very long and difficult to read the more values there are in the continuous variable. For example, in the below plot we facet on the continuous variable, `cty`. There are 21 different values for `cty` and ggplot tries to plot each of those 21 values as a subplot.

``` r
# facet on continuous variable, cty
ggplot(mpg) +
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_wrap( ~ cty)
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-16-1.png)

**2. What do the empty cells in plot with `facet_grid(drv ~ cyl)` mean? How do they relate to this plot?**

``` r
ggplot(mpg) +
    geom_point(mapping = aes(x = displ, y = hwy))
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-17-1.png)

**Answer**: empty cells mean that there are no values that satisfy both the x and y conditions in the subplot grid. For example, the plot below shows that only front wheel drive cars have 5 cylinders and that there are no 4 cylinder cars that have rear wheel drive.

``` r
ggplot(mpg) +
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_grid(drv ~ cyl)
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-18-1.png)

**3. What plots does the following code make? What does `.` do?**

``` r
ggplot(mpg) + # plot 1
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_grid(drv ~ .) +
    ggtitle("Plot 1")
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-19-1.png)

``` r
ggplot(mpg) + # plot 2
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_grid(. ~ cyl) +
    ggtitle("Plot 2")
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-19-2.png)

**Answer**: a `.` in place of a variable tells ggplot that you do not want to facet on that dimension. In Plot 1, the `.` is placed in the columns dimension, so it is faceted into only rows. In Plot 2, the `.` is placed in the rows dimension, so it is facted into only columns.

**4. Take the first faceted plot in this section. What are the advantages to using faceting instead of the colour aesthetic? What are the disadvantages? How might the balance change if you had a larger dataset?**

``` r
ggplot(mpg) +
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_wrap(~ class, nrow = 2)
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-20-1.png)

**Answer**: it's better to use facets when you have a lot of levels to distinguish between. It can be difficult to tell levels from another if they are too similar in color. Facets are harder to read at a glance though, so for data with less than 9 levels you should use color. If the `mpg` dataset were larger, we would use facets to show differences.

**5. Read `?facet_wrap`. What does `nrow` do? What does `ncol` do? What other options control the layout of the individual panels? Why doesn’t `facet_grid()` have `nrow` and `ncol` arguments?**

``` r
?facet_wrap
```

**Answer**: `facet_wrap` turns a 1 dimensional sequence of panels into a 2 dimensional one with area determined by the values given to `nrow` and `ncol`. The arguments `nrow` and `ncol` refer to the number of rows and columns in the resulting grid. The function `facet_grid` forms a matrix of panels defined by row and column faceting variables.

**6. When using `facet_grid()` you should usually put the variable with more unique levels in the columns. Why?**

**Answer**: most screens are wider than they are tall.

Geoms
-----

-   people often describe plots by the type of geom that the plot uses: EX. bar plot, line plot, etc.
-   every geom takes a `mapping` argument
-   set the `group` aesthetic to a categorical variable to draw multiple objects. For example, in the below plot, the line geom is grouped by `drv`. That tells ggplot to create a separate geom for each group in drv, rather than one geom for all of the data.

``` r
ggplot(data = mpg) +
    geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](ggplot2_files/figure-markdown_github/unnamed-chunk-22-1.png)

-   the mappings inside of a geom function are applied *to that layer only*, so it is possible to display different aesthetics **and data** in different layers.

### Practice

**1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?**

**Answer**: `geom_line` to draw a line chart, `geom_boxplot` to draw a boxplot, `geom_histogram` to draw a histogram, and `geom_area` for an area chart.

**2. Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.**

``` r
ggplot(mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
    geom_point() +
    geom_smooth(se=FALSE)
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](ggplot2_files/figure-markdown_github/unnamed-chunk-23-1.png)

**Answer**: the above code creates a scatterplot of `hwy` vs. `displ` with each point's color based on its value for `drv`. There is also a trend line overlayed on top of the points layer, also grouped by `drv`, with the confidence interval shading (standard error) turned off.

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](ggplot2_files/figure-markdown_github/unnamed-chunk-24-1.png)

**3. What does `show.legend = FALSE` do? What happens if you remove it? Why do you think I used it earlier in the chapter?**

**Answer**: `show.legend` tells ggplot whether or not to print the legend for the layer or not. The more layers you have, the more complex the levels are. Also if you're trying to line the plots up in a more visually appealing way you may not have enough room to show the legend for each plot.

**4. What does the `se` argument to `geom_smooth()` do?**

**Answer**: `se` tells ggplot whether or not to display a confidence interval around the smoothed line. The default is `se = TRUE`.

**5. Will these two graphs look different? Why/why not?**

``` r
# plot 1:
ggplot(mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point() +
    geom_smooth()

# plot 2:
ggplot() +
    geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))
```

**Answer**: the plots will look the exact same. The first plot establishes the mappings in the first layer, while the second plot establishes the mappings in each layer. The first plot is much easier to read though.

Statistical Transformations
---------------------------

This section uses the `diamonds` dataset.

``` r
data("diamonds")
```

-   Every geom has a default stat; and every stat has a default geom, so you can generally use geoms and stats interchangeably unless you need to override something.
-   Bar charts, histograms, and frequency polygons bin your data and then plot bin counts, the number of points that fall in each bin
-   Smoothers fit a model to your data and then plot predictions from the model
-   Boxplots compute a robust summary of the distribution and then display a specially formatted box

### Practice

**1.) What is the default geom associated with `stat_summary()`? How could you rewrite the previous plot to use that geom function instead of the stat function?**

``` r
?stat_summary

# original plot:
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-27-1.png)

``` r
# rewritten with geom instead of stat:
diamonds %>%
    group_by(cut) %>%
    summarize(min = min(depth), max = max(depth), median = median(depth)) %>% 
    ggplot(mapping = aes(x = cut, y = median, ymin = min, ymax = max)) +
    geom_pointrange()
```

    ## Warning: package 'bindrcpp' was built under R version 3.4.4

![](ggplot2_files/figure-markdown_github/unnamed-chunk-27-2.png)

**Answer**: the default geom for `stat_summary()` is `pointrange`. For each group on the x-axis (`cut`), ggplot computes the min, max, and median of the y-value (`depth`) and shows it as a point range (i.e. a vertical line for each x, with the top being the max, bottom being the min, and the point representing the median value). To rewrite the above plot with `geom` instead of `stat`, group the diamonds df by cut, then get summary stats of depth, then plot those stats using `geom_pointrange()`.

**2.) What does `geom_col()` do? How is it different to `geom_bar()`?**

``` r
?geom_col
?geom_bar

# Using geom_col to show the VALUE of depth in each cut group:
ggplot(diamonds) +
    geom_col(mapping = aes(x = cut, y = depth))
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-28-1.png)

``` r
# Using geom_bar to show the NUMBER of diamonds in each cut group:
ggplot(diamonds) +
    geom_bar(mapping = aes(x = cut))
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-28-2.png)

**Answer**: both `geom_col()` and `geom_bar()` make bar charts, however with `geom_col()` the heights of the bars represent the values in the data (i.e. it uses `stat_identity`), while `geom_bar` makes the height of the bar proportional to the number of cases in each group (i.e. it uses `stat_count` by default).

**3.) Most geoms and stats come in pairs that are almost always used in concert. Read through the documentation and make a list of all the pairs. What do they have in common?**

**Answer**: in general, the default stat for each geom is the identity of the y variable, or the stat invloved in the geom transformation.

All geoms and their associated stats:

-   Reference lines: `geom_abline()`, `geom_hline()`, and `geom_vline()` use their own geom ("abline", "hline", and "vline") as the associated stat
-   Ribbons and area plots: `geom_area()` and `geom_ribbon()` use `stat = "identity"`
-   Bar charts based on counts: `geom_bar()` uses `stat = "count"`
-   Bar charts based on values: `geom_col()` uses `stat = "identity"`
-   2D bin count heatmaps: `geom_bin2d()` uses `stat = "bin2d"`
-   Blank plots: `geom_blank()` uses `stat = "identity"`
-   Boxplots: `geom_boxplot()` uses `stat = "boxplot"`
-   2D contours of 3D surfaces: `geom_contour()` uses `stat = "contour"`
-   Overlapping points counts: `geom_count()` uses `stat = "sum"`
-   Vertical intervals (lines, crossbars, and errorbars): `geom_crossbar()`, `geom_errorbar()`, `geom_linerange()`, and `geom_pointrange()` uses `stat = "identity"`
-   Line segments and curves: `geom_curve()` and `geom_segment()` use `stat = "identity"`
-   Smoothed denisty estimates: `geom_density()` uses `stat = "density"`
-   Histograms and frequency polygons: `geom_histogram()` and `geom_freqpoly()` use `stat = "bin"`
-   Hexagonal heatmaps of 2D bin counts: `geom_hex()` uses `stat = "binhex"`
-   Jittered points: `geom_jitter()` uses `stat = "identity"`
-   Text: `geom_label()` and `geom_text()` use `stat = "identity"`
-   Connected observations: `geom_line()`, `geom_path()`, and `geom_step()` use `stat = "identity"`
-   Polygons: `geom_polygon()` uses `stat = "identity"`
-   Polygons from a reference map: `geom_map()` uses `stat = "identity"`
-   Scatterplots: `geom_point()` uses `stat = "identity"`
-   Quantile regressions: `geom_quantile()` uses `stat = "quantile"`
-   Rectangles: `geom_raster()`, `geom_rect()`, and `geom_tile` use `stat = "identity"`
-   Rug plots in the margins: `geom_rug()` uses `stat = "identity"`
-   Smoothed conditional means: `geom_smooth()` uses `stat = "smooth"`
-   Violin plots: `geom_violin()` uses `stat = "ydensity"`

**4.) What does the variable `stat_smooth()` compute? What parameters control its behavior?**

``` r
?stat_smooth
```

**Answer**: `stat_smooth()` aids the eye in seeing patterns in the presence of overplotting by overlaying a trend line over a scatterplot. This function computes the predicted value (`y`), the lower and upper pointwise confidence intervals around the mean (`ymin`), and the standard error (`se`). The parameters that control its behavior are the smoothing method (`lm`, `glm`, `gam`, `loess`, or `rlm`), the formula to use in the smoothing function (ex. `y ~ x`), `se` which determines if the confidence interval should be plotted, and `level` determines the level of the confidence interval.

**5.) In our proportion bar chart, we need to set `group = 1`. Why? In other words what is the problem with these two graphs?**

``` r
# Plot 1:
ggplot(diamonds) +
    geom_bar(mapping = aes(x = cut, y = ..prop..))
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-30-1.png)

``` r
# Plot 2:
ggplot(diamonds) +
    geom_bar(
        mapping = aes(x = cut, fill = color, y = ..prop..)
    )
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-30-2.png)

**Answer**: if group is not set to 1, then all the bars have `prop == 1`. If `prop == 1`, ggplot is trying to plot the number of observations in a group divided by the same number of observations in the group. By setting `group = 1` we're telling ggplot to use the entire (one group) data set to calculate the proportion for each group. The function `geom_bar` assumes the groups are equal to the x values, since the stat computes the count within the groups. In both of the above graphs, the proportions are calculated across all groups (i.e. it calculates the proportion in relation to the total, not within each group). Therefore the y values will be the same across all x vales. The correct way to plot the above graphs is:

``` r
# Plot 1:
ggplot(diamonds) +
    geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-31-1.png)

``` r
# Plot 2:
ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = color, y = ..prop.., group = color))
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-31-2.png)

Position Adjustments
--------------------

-   To edit the outline color, change the `color` aesthetic:

``` r
ggplot(diamonds) +
    geom_bar(mapping = aes(x = cut, color = cut)) # color aesthetic
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-32-1.png)

-   To edit the fill and outline color, change the `fill` aesthetic:

``` r
ggplot(diamonds) +
    geom_bar(mapping = aes(x = cut, fill = cut)) # fill aesthetic
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-33-1.png)

-   If you map the `fill` aesthetic to another variable, the bars are automatically stacked with each rectangle representing a combination of `x` and `fill`:

``` r
ggplot(diamonds) +
    geom_bar(mapping = aes(x = cut, fill = clarity))
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-34-1.png)

-   Setting `position = "fill"` makes each set of stacked bars the same height (useful for comparing proportions across groups):

``` r
ggplot(diamonds) +
    geom_bar(
        mapping = aes(x = cut, fill = clarity),
        position = "fill"
    )
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-35-1.png)

-   Setting `position = "dodge"` places overlapping objects directly beside one another (useful for comparing individual values):

``` r
ggplot(diamonds) +
    geom_bar(
        mapping = aes(x = cut, fill = clarity),
        position = "dodge"
    )
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-36-1.png)

### Practice

**1.) What is the problem with this plot? How could you improve it?**

``` r
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-37-1.png)

**Answer**: there is overplotting going on in the above plot. The values of `hwy` and `cty` are rounded so the points appear on a grid and many points overlap eaother. To fix this issue, add `position = "jitter"` as an argument to the `geom_point()` call:

``` r
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point(position = "jitter")
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-38-1.png)

**2.) What parameters to `geom_jitter()` control the amount of jittering?**

``` r
?geom_jitter
```

**Answer**: `geom_jitter()` adds a small amount of random variation to the location of each point. The `width` and `height` arguments control the amount of vertical and horizontal jitter. The jitter is added in both positive and negative directions, so the total spread is twice the value specified here. If omitted, these arguments default to 40% of the resolution of the data: this means the jitter values will occupy 80% of the implied bins.

Effects of changing the jitter values:

``` r
# Original plot with no jitter:
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-40-1.png)

``` r
# Low horizonal jitter, high vertical jitter:
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point(position = position_jitter(width = 0, height = 15))
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-40-2.png)

``` r
# High horizonal jitter, low vertical jitter:
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point(position = position_jitter(width = 15, height = 0))
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-40-3.png)

``` r
# High horizonal jitter, high vertical jitter:
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point(position = position_jitter(width = 15, height = 15))
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-40-4.png)

``` r
# Low horizonal jitter, low vertical jitter (no jitter):
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point(position = position_jitter(width = 0, height = 0))
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-40-5.png)

**3.) Compare and contrast `geom_jitter()` with `geom_count()`.**

``` r
?geom_jitter
?geom_count
```

**Answer**: `geom_count()` is a variant to `geom_point()` that counts the number of observations at each location, then maps the count to point area. It computes `n`, the number of observations at a position, and `prop`, the percent of points in that panel at that position. The larger the size of the point, the more data it represents. While `geom_jitter` adds random variation to handle overplotting, `geom_count` changes the size of the point. For example:

``` r
# larger point sizes:
ggplot(mpg, aes(cty, hwy)) +
    geom_count()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-42-1.png)

``` r
# random jitter:
ggplot(mpg, aes(cty, hwy)) +
    geom_jitter()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-42-2.png)

**4.) What's the default position adjustment for `geom_boxplot()`? Create a visualization of the mpg dataset that demonstrates it.**

``` r
?geom_boxplot
```

**Answer**: the default position argument is `dodge`. This places overlapping objects directly beside eachother. For example, in the below plot the x axis shows the `class` group, while the y axis shows the corresponding `hwy` statistics. There is a boxplot for each group on the x axis (`class`), and the boxplots are side by side.

``` r
ggplot(mpg, aes(class, hwy)) +
    geom_boxplot()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-44-1.png)

Coordinate Systems
------------------

Default coordinate system is *Cartesian*, where the x and y positions act independently to determine the location of each point.

Some other coordinate systems:

-   `coord_flip()`: switches x and y axes. Useful for horizonal boxplots, and plots with long labels
-   `coord_quickmap()`: sets aspect ratio coorrectly for spatial maps
-   `coord_polar()`: uses polar coordinatesand shows an interesting connection between a bar chart and a *Coxcomb* chart.

### Practice

**1.) Turn a stacked bar chart into a pie chart using coord\_polar.**

``` r
# Stacked bar chart:
ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
    geom_bar()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-45-1.png)

``` r
#  Coxcomb chart:
ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
    geom_bar() +
    coord_polar()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-45-2.png)

**Answer**: the polar coordinate system is most commonly used for pie charts, which are stacked bar charts in polar coordinates.

**2.) What does labs() do? Read the documentation.**

``` r
?labs
```

**Answer**: `labs()` allows us to modify the axis', legend, and plot labels. For example:

``` r
# x and y axis labels:
ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
    geom_bar() +
    labs(y = "y axis label", x = "x axis label")
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-47-1.png)

**3.) What's the difference between `coord_quickmap()` and `coord_map()`?**

``` r
?coord_quickmap
?coord_map
```

**Answer**: `coord_map` projects a portion of the Earth, which is approx spherical, onto a flat 2D plane. These projections do not, in general, preserve straight lines, so this requires considerable computation. However `coord_quickmap` is a quick approximation that does preserve straight lines. It works best for smaller areas closer to the equator.

**4.) What does the following plot tell you about the relationship between city and highway mpg? Why is `coord_fixed` important? What does `geom_abline` do?**

``` r
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point() +
    geom_abline() +
    coord_fixed()
```

![](ggplot2_files/figure-markdown_github/unnamed-chunk-49-1.png)

**Answer**: the plot above shows that city and highway mpg are direct variants of the other; they are positively linear related. For each car, as city mpg increases, so does highway mpg. The `geom_abline` function adds a regression line showing the slope and y-intercept of the data. `Coord_fixed` forces a specific ratio between the physical representation of the data units on the axis. The ratio represents the number of units on the y axis equivalent to 1 unit on the x axis (y/x).

The Layered Grammar of Graphics
-------------------------------

All ggplots follow the same layering structure:

``` r
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(
     mapping = aes(<MAPPINGS>),
     stat = <STAT>, 
     position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>
```

*That's all folks!*
