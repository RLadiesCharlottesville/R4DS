---
title: "Workflows in RStudio: Basics, Scripts, & Projects"
author: "Samantha Toet"
date: "7/5/2018"
output: html_document
---


## Coding Basics

From [4. Workflows: Basic](http://r4ds.had.co.nz/workflow-basics.html)

*Ch. 2 in the printed copy*

- assignments: dont use =
- naming conventions: snake case
- calling functions: If you want more help, press `F1` to get all the details in the help tab in the lower right pane.
- the continuiation character `+`: tells you that R is waiting for more input; it doesn’t think you’re done yet. Usually that means you’ve forgotten either a `"` or a `)`. Either add the missing pair, or press `ESC` to abort the expression and try again.
- print to screen by surrounding in parantheses 

### Practice:

**1. Why does this code not work?**
```{r example, include=TRUE, echo=TRUE, error=TRUE}
my_variable <- 10
my_varıable
```

**Answer**: R is very picky about spelling and capitalization. The two variables must be spelled and formatted identially. In the above example, the i's in *variable* are different. 

**2. Tweak each of the following R commands so that they run correctly:**

```{r, include=TRUE, echo=TRUE, error=TRUE, warning=F, message=FALSE}
library(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

fliter(mpg, cyl = 8)
filter(diamond, carat > 3)
```

**Answer**: see below output
```{r, include=TRUE, echo=TRUE, error=TRUE, warning=F, message=FALSE}
library(tidyverse)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + # slightly cleaner
  geom_point()

filter(mpg, cyl == 8) # filter spelled correctly and correct boolean token used

ggplot2::diamonds # dataset loaded 
filter(diamonds, carat > 3) # diamonds dataset correctly spelled 
```

**3. Press `Alt` + `Shift` + `K`. What happens? How can you get to the same place using the menus?**

**Answer**: 
Pressing `Alt` + `Shift` + `K` bring up the Keyboard Shortcut Quick Reference. To get to the same place using the menus you'd have to select Tools, then Keyboard Shortcuts Help.  


## Scripts

From [6. Workflows: Scripts](http://r4ds.had.co.nz/workflow-scripts.html)

*Ch. 4 in the book*

- execute the complete script in one step: `Cmd/Ctrl` + `Shift` + `S`
- never include `install.packages()` or `setwd()` in a script that you share. It’s very antisocial to change settings on someone else’s computer!

### Practice

**1. Go to the RStudio Tips twitter account, https://twitter.com/rstudiotips and find one tip that looks interesting. Practice using it!**

**Answer**: This status is a game changer, practice gif included in Tweet.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Loved the cooking metaphors 🔪🎂 in <a href="https://twitter.com/hadleywickham?ref_src=twsrc%5Etfw">@hadleywickham</a>&#39;s <a href="https://twitter.com/RLadiesSF?ref_src=twsrc%5Etfw">@RLadiesSF</a> talk yesterday!  but the best part was watching Hadley speed-code live and learning neat tricks like this: <a href="https://t.co/UVmrPbxpho">pic.twitter.com/UVmrPbxpho</a></p>&mdash; Irene Steves (@i_steves) <a href="https://twitter.com/i_steves/status/995394452821721088?ref_src=twsrc%5Etfw">May 12, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Also the [RStudio IDE Cheat Sheet](https://www.rstudio.com/wp-content/uploads/2016/01/rstudio-IDE-cheatsheet.pdf)

**2. What other common mistakes will RStudio diagnostics report? Read https://support.rstudio.com/hc/en-us/articles/205753617-Code-Diagnostics to find out.**

**Answer**: Some other mistakes that RStudio diagnostics will report are:

- missing arguments, unmatched arguments, partially matched arguments, and too many arguments
- extra or missing commas
- warn if a symbol is used with no definition in the scope - might ask if it's a typo of something similar
- warn if variable is defined but not used
- style diagnostic checks to see if your code conforms to [Hadley Wickham’s style guide](http://adv-r.had.co.nz/Style.html), and reports style warnings when encountered, esp. whitespace 


## Projects

From [8. Workflow: Projects](http://r4ds.had.co.nz/workflow-projects.html)

*Ch. 6 in the book*

- Code should be saved in scripts, not just in your environment
- RStudio shows your current working directory at the top of the console *(I always forget this!)*
- never use absolute paths in your scripts (EX. C:), because they hinder sharing
- keep all the files associated with a project together — input data, R scripts, analytical results, figures -- and keep it in the appropriate subdirectory
- when you click on an `.Rproj` file, you'll openthe same working directory, command history, and all the files you were working on that were saved to that project but with a fresh environment

There are no practice question for this section. 

*Adios!*
