## * Packages
## always a good practice to load all the packages at the top of a script

library(tidyverse)
library(magrittr)
library(here)
library(sessioninfo)
library(anonymizer)

## * Getting information from within R

## open R manuals
help.start()

## look for help on package "dplyr"
package?dplyr

## list all functions of the package "dplyr"
help(package = dplyr)

## look for help on the function "inner_join"
## (note: dplyr has to be loaded)
?inner_join

## list all the vignettes of all the packages installed on your machine
## probably not the most useful...
vignette()

## list all the vignettes of all the packages currently loaded
vignette(all = F)

## list all the vignettes for the package "dplyr"
vignette(package = "dplyr")

## open the vignette "programming"
vignette("programming")

## look for package versions, R version, locales, etc.
sessionInfo()

## same but from the package "sessioninfo"
## more organized and tells you where you installed the packages from
## (GitHub, CRAN, etc.) which is very useful to run updates
session_info()

## look for the version of the package "dplyr"
packageVersion("dplyr")

## look for the R version
## note that this is not a function (so no ending parenthesis)
## it is an object of class simple.list
## (something you have probably never encountered, but don't worry about it.
## Simply remember to type it without parenthesis)
version

## * Let's play with some data

## ** The problem with paths

## absolute path: it works, but it is not portable
df <- read.csv("/home/marie/parvus/rc/r/surviving-r_workshop/count_data.csv")

## relative path: it is portable, but it is very easy to break
## (if you are not in the root of the project)
df <- read.csv("count_data.csv")

## the answer: here::here()
df <- read.csv(here("count_data.csv"))

## ** Data frames vs tibbles

df
## totally impractical (way too many rows!)

## you have to remember to call head() each time
head(df)

## Notice how the variable names got changed

str(df)
## ugh... factors?...

## you can fix that with
df <- read.csv(here("count_data.csv"), stringsAsFactor = F)

str(df)

## let's look at a tibble now
## note: all functions in the tidyverse will output tibbles
## so if you use the tidyverse, you will end up with tibbles (but that's good!)
## note also that tibbles will never coerce your strings as factors
tbl <- read_csv(here("count_data.csv"))

tbl

## ** Variable names

## Exercise: look at the stringr cheatsheet and try to find a function that will allow us to replace all "-" and " " by "_"

names(tbl) %<>% str_replace_all("-| ", "_")
## note the use of the fancy assignment pipe from magrittr

## without using pipes, this is what the code looks like:
names(tbl) <- str_replace_all(names(tbl), "-| ", "_")

tbl

## Let's re-import our data
tbl <- read_csv(here("count_data.csv"))

## the base R read.csv() function was changing our variable names
## by running make.names() in the background

## demonstration: we can run that function on names(tbl)
## and we will get the names that base R had created from our variable names
names(tbl) %<>% make.names()

tbl

## Exercise: use str_replace_all() to replace the dots by underscores
## if you ran the code:
## names(tbl) %<>% str_replace_all(".", "_")
## you must have had exciting variable names :)

names(tbl) %<>% str_replace_all("\\.", "_")
## the stringr cheatsheet explains why you have to escape the dot
## with 2 backslashes
## you can find more information on regexp here:
## https://www.regular-expressions.info/tutorialcnt.html
## (regexp and incredibly useful, so you should spend the time learning them)

## ** Dates

## *** date3

## Exercise: go to section "11.3.4 Dates, date-times, and times" of "R for data science" and try to parse date3 into a standard R date format

tbl$date3 %<>% parse_date("%y/%m/%d")

tbl

## *** date4

tbl$date4 %<>% as.character()

tbl
## ugh... not exactly working...

## Exercise: look at the help file for `read_csv` and try to find a solution to import date4 as character.
## don't forget to use ?read_csv

## We could do this:
tbl_date4 <- read_csv("count_data.csv", col_types = "???c?????")

## but we have already made some transformation to our data frame...
## and this would reimport everything and make us loose those transformations.

## Another option is to import only the 4rth column:
tbl_date4 <- read_csv("count_data.csv", col_types = "---c-----")

tbl_date4

## then replace our date4 variable by this new date4
## note that we have to use $ even if tbl_date4 only had a column
## otherwise, we would be trying to replace a variable (= a vector)
## by a whole tibble...
tbl$date4 <- tbl_date4$date4

tbl

## Exercise: now parse date4 to date. Go back to "11.3.4 Dates, date-times, and times" of "R for data science" if you need.

tbl$date4 %<>% parse_date("%Y/%d/%m")

tbl

## Exercise: look at the "Data Transformation" cheatsheet and
## 1. remove date2, date3, and date4
## 2. rename date1 to date

tbl %<>%
  select(- c(2:4)) %>%
  rename(date = date1)

tbl

## Exercise: in a single graph, plot the number of individuals over time for each of the species.
## Note: use the "Data Visualization" cheatsheet if you need.

tbl_long <-
  tbl %>%
  gather("species", "abundance", - 1)

tbl_long

tbl_long %>% ggplot(aes(date, abundance)) +
  geom_line(aes(color = species))

## * Making a reproducible example

## Imagine that you want to get the total across the whole season for each species.
## This is what you do:

tbl_long %>%
  group_by(species) %>%
  summarise(sum())

## Oh no...
## You cannot understand why this is not working, so you decide to post a question on the RStudio Community website.

## ** The reprex package

## Here comes the package "reprex", with its main function "reprex".
## You probably don't want to have "library(reprex)" in your script since
## reprex() is not a function that you want to run every time you run your script
## This is equivalent to looking at the help file of a function with "?"
## These things are better run in the console.
## But you can use "reprex::reprex()" which allows to run the function reprex()
## without loading the package reprex.
## Note that the first "reprex" refers to the package, the second to the function

## To use it, copy the code to your clipboard

tbl_long %>%
  group_by(species) %>%
  summarise(sum())

## then run reprex::reprex()

## Oh no... The pipe is not recognized
## Why? You have to load the libraries in your reprex. Let us try again.
## Copy this:

library(tidyverse)

tbl_long %>%
  group_by(species) %>%
  summarise(sum())

## and run reprex::reprex()

## Uh oh... we also need to load the data...
## without the data, the code cannot be run.

## *** How to provide data for a reprex

## **** Using dput()

## Do not upload a .csv file nor a .rds object somewhere on the web to be downloaded. People hate downloading stuff and it is likely that you will not get help or be asked to produce a reprex instead...
## On Stack Overflow, this might even cost you some downvotes

dput(tbl_long)

test <- structure(
  list(
    date = structure(
      c(17604, 
        17605, 17606, 17607, 17609, 17610, 17611, 17612, 17613, 17614, 
        17615, 17616, 17617, 17618, 17619, 17620, 17621, 17622, 17623, 
        17624, 17625, 17626, 17628, 17629, 17630, 17631, 17632, 17633, 
        17634, 17635, 17636, 17637, 17638, 17639, 17640, 17642, 17643, 
        17644, 17645, 17647, 17648, 17649, 17650, 17651, 17604, 17605, 
        17606, 17607, 17609, 17610, 17611, 17612, 17613, 17614, 17615, 
        17616, 17617, 17618, 17619, 17620, 17621, 17622, 17623, 17624, 
        17625, 17626, 17628, 17629, 17630, 17631, 17632, 17633, 17634, 
        17635, 17636, 17637, 17638, 17639, 17640, 17642, 17643, 17644, 
        17645, 17647, 17648, 17649, 17650, 17651, 17604, 17605, 17606, 
        17607, 17609, 17610, 17611, 17612, 17613, 17614, 17615, 17616, 
        17617, 17618, 17619, 17620, 17621, 17622, 17623, 17624, 17625, 
        17626, 17628, 17629, 17630, 17631, 17632, 17633, 17634, 17635, 
        17636, 17637, 17638, 17639, 17640, 17642, 17643, 17644, 17645, 
        17647, 17648, 17649, 17650, 17651, 17604, 17605, 17606, 17607, 
        17609, 17610, 17611, 17612, 17613, 17614, 17615, 17616, 17617, 
        17618, 17619, 17620, 17621, 17622, 17623, 17624, 17625, 17626, 
        17628, 17629, 17630, 17631, 17632, 17633, 17634, 17635, 17636, 
        17637, 17638, 17639, 17640, 17642, 17643, 17644, 17645, 17647, 
        17648, 17649, 17650, 17651, 17604, 17605, 17606, 17607, 17609, 
        17610, 17611, 17612, 17613, 17614, 17615, 17616, 17617, 17618, 
        17619, 17620, 17621, 17622, 17623, 17624, 17625, 17626, 17628, 
        17629, 17630, 17631, 17632, 17633, 17634, 17635, 17636, 17637, 
        17638, 17639, 17640, 17642, 17643, 17644, 17645, 17647, 17648, 
        17649, 17650, 17651),
      class = "Date"
    ),
    species = c("big_eared_fish", 
                "big_eared_fish", "big_eared_fish", "big_eared_fish", "big_eared_fish", 
                "big_eared_fish", "big_eared_fish", "big_eared_fish", "big_eared_fish", 
                "big_eared_fish", "big_eared_fish", "big_eared_fish", "big_eared_fish", 
                "big_eared_fish", "big_eared_fish", "big_eared_fish", "big_eared_fish", 
                "big_eared_fish", "big_eared_fish", "big_eared_fish", "big_eared_fish", 
                "big_eared_fish", "big_eared_fish", "big_eared_fish", "big_eared_fish", 
                "big_eared_fish", "big_eared_fish", "big_eared_fish", "big_eared_fish", 
                "big_eared_fish", "big_eared_fish", "big_eared_fish", "big_eared_fish", 
                "big_eared_fish", "big_eared_fish", "big_eared_fish", "big_eared_fish", 
                "big_eared_fish", "big_eared_fish", "big_eared_fish", "big_eared_fish", 
                "big_eared_fish", "big_eared_fish", "big_eared_fish", "bigfoot", 
                "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", 
                "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", 
                "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", 
                "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", 
                "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", 
                "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", 
                "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", "bigfoot", 
                "bigfoot", "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", 
                "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", 
                "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", 
                "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", 
                "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", 
                "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", 
                "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", 
                "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", 
                "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", 
                "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", 
                "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", "long_nosed_bird", 
                "long_nosed_bird", "long_toed_rat", "long_toed_rat", "long_toed_rat", 
                "long_toed_rat", "long_toed_rat", "long_toed_rat", "long_toed_rat", 
                "long_toed_rat", "long_toed_rat", "long_toed_rat", "long_toed_rat", 
                "long_toed_rat", "long_toed_rat", "long_toed_rat", "long_toed_rat", 
                "long_toed_rat", "long_toed_rat", "long_toed_rat", "long_toed_rat", 
                "long_toed_rat", "long_toed_rat", "long_toed_rat", "long_toed_rat", 
                "long_toed_rat", "long_toed_rat", "long_toed_rat", "long_toed_rat", 
                "long_toed_rat", "long_toed_rat", "long_toed_rat", "long_toed_rat", 
                "long_toed_rat", "long_toed_rat", "long_toed_rat", "long_toed_rat", 
                "long_toed_rat", "long_toed_rat", "long_toed_rat", "long_toed_rat", 
                "long_toed_rat", "long_toed_rat", "long_toed_rat", "long_toed_rat", 
                "long_toed_rat", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit", 
                "thick_furred_rabbit", "thick_furred_rabbit", "thick_furred_rabbit"
                ),
    abundance = c(5L, 8L, 11L, 7L, 11L, 10L, 11L, 10L, 7L, 9L, 
                  8L, 6L, 7L, 7L, 8L, 10L, 6L, 6L, 8L, 5L, 8L, 5L, 12L, 6L, 8L, 
                  8L, 12L, 6L, 9L, 2L, 7L, 15L, 7L, 10L, 7L, 8L, 5L, 8L, 6L, 12L, 
                  6L, 10L, 4L, 11L, 1L, 0L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 1L, 
                  1L, 1L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 1L, 0L, 0L, 0L, 0L, 0L, 
                  1L, 0L, 1L, 0L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 0L, 1L, 
                  1L, 1L, 2L, 2L, 1L, 2L, 3L, 1L, 1L, 2L, 2L, 1L, 1L, 2L, 3L, 1L, 
                  1L, 2L, 3L, 3L, 1L, 2L, 4L, 2L, 1L, 2L, 3L, 1L, 1L, 2L, 1L, 1L, 
                  2L, 1L, 1L, 3L, 3L, 3L, 1L, 1L, 2L, 2L, 2L, 2L, 1L, 17L, 10L, 
                  14L, 4L, 11L, 10L, 11L, 7L, 5L, 8L, 9L, 9L, 10L, 11L, 16L, 6L, 
                  8L, 9L, 12L, 15L, 13L, 11L, 10L, 11L, 4L, 7L, 9L, 4L, 8L, 10L, 
                  7L, 16L, 11L, 10L, 11L, 16L, 8L, 7L, 9L, 15L, 4L, 8L, 10L, 12L, 
                  34L, 34L, 29L, 37L, 27L, 34L, 30L, 28L, 30L, 31L, 31L, 34L, 24L, 
                  30L, 33L, 29L, 27L, 28L, 34L, 32L, 21L, 33L, 32L, 34L, 39L, 33L, 
                  28L, 24L, 36L, 26L, 30L, 34L, 32L, 39L, 33L, 25L, 31L, 31L, 35L, 
                  23L, 33L, 31L, 27L, 35L)
  ),
  row.names = c(NA, -220L),
  class = c("tbl_df", "tbl", "data.frame")
)

test

## It works. But good luck not getting any downvotes posting a question on Stack Overflow that would include this code though...

## *** Removing as much as possible from the data before using dput()

## Remember what our problem was:

tbl_long %>%
  group_by(species) %>%
  summarise(sum())

## We probably do not need the whole tibble to reproduce the problem.

## Exercise: remove as much from the data as possible and simplify the names as much as possible while keeping the problem. Remember to use the dplyr cheatsheet or Chapter 5 "Data transformation" from "R for data science" if you need.

data <- tbl_long

simplify names

data$species <- rep(letters[1:5], each = 44)

data

## select only 3 species and 2 rows per species and get rid of the date variable

data %<>%
  select(- 1) %>% 
  filter(species %in% letters[1:3]) %>% 
  group_by(species) %>%
  slice(1:2) %>%
  ungroup()

data

## Let us see if our problem is still there:

data %>%
  group_by(species) %>%
  summarise(sum())

## Yes. Good. So now, we can use dput() and it will not look as crazy.

## Exercise: use dput() and reprex::reprex() to prepare a question ready to post on the RStudio Community forum.

## First run this in the console to get the output

dput(data)

## Then copy the code below and run reprex::reprex() in the console 

library(tidyverse)

data <- structure(list(
  species = c("a", "a", "b", "b", "c", "c"),
  abundance = c(5L, 8L, 1L, 0L, 1L, 2L)),
  class = c("tbl_df", "tbl", "data.frame"),
  row.names = c(NA, -6L)
  )

data %>%
  group_by(species) %>%
  summarise(sum())

## Hooray. Now you can paste this directly into the RStudio Community forum or any other website which accepts markdown markup. For Stack Overflow, instead of reprex::reprex(), use reprex::reprex(venue = "so").

## *** Creating data

## You might want to simply create fake data instead of using bits of your actual data. Sometimes this is faster and simpler.

## Exercise: create a new tibble similar to the data tibble from scratch.
## Hint: functions very useful to create toy dtasets include: sample(), rep(), and rnorm(). And use google when you do not know how to do something.

data <- tibble(
  species = rep(letters[1:3], each = 2),
  abundance = sample(0:10, 6, replace = T)
)

## Let's make sure this reproduces our problem

data %>%
  group_by(species) %>%
  summarise(sum())

## Good.

## Exercise: write a reprex using this method of producing the data.

library(tidyverse)

data <- tibble(
  species = rep(letters[1:3], each = 2),
  abundance = sample(0:10, 6, replace = T)
)

data %>%
  group_by(species) %>%
  summarise(sum())

## Exercise: look at the dplyr cheatsheet and find out why our code is not working.
 
data %>%
  group_by(species) %>%
  summarise(sum(abundance))

## ** Anonymising data

## Let's imagine now that our data contains sensitive information. This can be personal information, government data, etc. Or maybe we simply do not wish to make our data useable when we post it along with our paper or while we ask for help. We can anonymize the data ourselves as we just did by renaming the species ourselves. But when lots of data has to be anonymized, this can be very tedious. 

## Exercise: look at the package anonymizer and try to anonymize the column "species" of our "tbl_long" tibble.

tbl_long_anonym <- tbl_long

tbl_long_anonym$species %<>% anonymize(.algo = "crc32")

table(tbl_long$species)

table(tbl_long_anonym$species)

unique(tbl_long$species)

unique(tbl_long_anonym$species)
