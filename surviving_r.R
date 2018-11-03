library(tidyverse)
library(magrittr)
library(here)
## library(lubridate)

help.start()

package?dplyr

help(package = dplyr)

?bind_rows

vignette(package = "dplyr")

vignette(all = F)

vignette()

vignette("programming")

sessionInfo()

packageVersion("dplyr")

df <- read.csv("/home/marie/parvus/rc/r/surviving-r_workshop/count_data.csv")

df <- read.csv(here("count_data.csv"))

df

head(df)

tbl <- read_csv(here("count_data.csv"))

names(tbl) %<>% make.names()

tbl <- read_csv(here("count_data.csv"))

names(tbl) %<>% str_replace_all("-| ", "_")

tbl <- read_csv(here("count_data_date.csv"))



dat <- tibble(
  date = sample(seq(as_date('2018-03-14'), as_date('2018-08-31'), by = "day"),
                200, replace = T),
  site = sample(LETTERS[1:4], 200, replace = T),
  sample = rep(sample(1000:3000, 10), 2),
  value = rnorm(20, 5, 1),
  gene = rep(letters[1:10], 2),
  tag = paste(sample, gene, sep = "|"),
  isPTV = rep(0:1, each = 10),
  DOY = sample(150:300, 20, replace = T),
  Transect = sample(letters[1:18], 20, replace = T),
  position = sample(1:4, 20, replace = T),
  Distance.num = rnorm(20, 56, 2)
)

  dat <- tibble(
    date = rep(seq(as_date("2018-03-14"), as_date("2018-04-30"), by = "day"),
               each = 4),
    site = rep(c("thisplace", "thatotherplace", "aplace", "niceplace"),
               each = 48),
    species = sample(c("bigfoot", "long-nosed_bird", "big-eared_fish", "long-toed_rat", "thick-fur_rabbit"), 1:5)
    value = rnorm(20, 5, 1),
    gene = rep(letters[1:10], 2),
    tag = paste(sample, gene, sep = "|"),
    isPTV = rep(0:1, each = 10),
    DOY = sample(150:300, 20, replace = T),
    Transect = sample(letters[1:18], 20, replace = T),
    position = sample(1:4, 20, replace = T),
    Distance.num = rnorm(20, 56, 2)
  )

  set.seed(32)

  arguments <- list(
    list(c("bigfoot", "long-nosed_bird", "big-eared_fish", "long-toed_rat", "thick-fur_rabbit")),
    sample(0:5, 48, replace = T)
  )

  species <- pmap(arguments, sample)

  obs <- map2(1:48, lengths(species), rep)

  date <- map2(
    seq(as_date("2018-03-14"), as_date("2018-04-30"), by = "day"), lengths(species), rep)

  dat <- tibble(
    obs = unlist(obs),
    date = as_date(unlist(date)),
    species = unlist(species),
    count = sample(1:20, 149, replace = T)
  )

  dat_wide <- spread(dat, species, count)

  dat_wide[is.na(dat_wide)] <- 0

  write_csv(dat_wide, "count_data.csv")


  df<-structure(list(StimulusName = c("Alpha5", "Alpha5", "Alpha5", 
                                      "Alpha5", "Alpha5", "Alpha5", "Alpha5", "Alpha5", "Alpha5", "Alpha5", 
                                      "Alpha5", "Alpha5", "Alpha5", "Alpha5", "Alpha5", "Alpha5", "Alpha5", 
                                      "Alpha5", "Alpha5", "Alpha5", "Alpha5", "Alpha5", "Alpha5", "Alpha5", 
                                      "Alpha5", "Alpha5", "Alpha5", "Alpha5", "Alpha5", "Alpha5", "Alpha5", 
                                      "Alpha5", "Alpha5"), Label = c(NA, NA, NA, NA, NA, "Onset", NA, 
                                                                     NA, NA, NA, NA, "Offset", NA, NA, NA, NA, NA, NA, NA, "Onset", 
                                                                     NA, NA, NA, NA, NA, NA, NA, NA, "Offset", NA, NA, NA, NA)), row.names = c(NA, 
                                                                                                                                               -33L), class = c("tbl_df", "tbl", "data.frame"))

  rownames(df)

  df$Label[df$Label %between% c("Onset", "Offset")] <- 3

  df$Label[df$Label %inrange% c("Onset", "Offset")] <- 3

  x[findInterval(x, c(2,5)) == 1L] <- -1

  df$Label[findInterval(df$Label, c("Onset", "Offset"))]

  <- -1

  dat$date[c(8, 35, 111)] <- NA

  dat <- tibble(
    date = sample(seq(as_date('2018-03-14'), as_date('2018-08-31'), by = "day"),
                  200, replace = T),
    site = sample(c("thisplace", "thatotherplace", "aplace", "niceplace"),
                  200, replace = T),
    sample = rep(sample(1000:3000, 10), 2),
    value = rnorm(20, 5, 1),
    species = rep(letters[1:10], 2),
    tag = paste(sample, gene, sep = "|"),
    isPTV = rep(0:1, each = 10),
    DOY = sample(150:300, 20, replace = T),
    Transect = sample(letters[1:18], 20, replace = T),
  position = sample(1:4, 20, replace = T),
  Distance.num = rnorm(20, 56, 2)
)
