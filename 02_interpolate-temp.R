## munging script for Columbia River environmental data

## setup

## load libraries
library(tidyverse)
library(here)

## set data directory
dir_data <- here("data")

## read raw temp data
temp_raw <- read_csv(file.path(dir_data, "temp_all_dams.csv"))


temp_re <- temp_raw %>%
  pivot_longer(cols = `2020`:`1970`,
               names_to = "year",
               values_to = "temp") %>%
  pivot_wider(names_from = day_of_year,
              values_from = temp) %>%
  arrange(year, dam)
  
n_years <- temp_re %>%
  select(year) %>%
  unique() %>%
  nrow()

ZZ <- matrix(0, nrow(temp_re), ncol(temp_re) - 2)

for(i = 1:n_years) {
  
  
  
}
  