## munging script for Columbia River environmental data

## setup

## load libraries
library(tidyverse)
library(here)

## set data directory
dir_data <- here("data")

## read raw temp data
temp_raw <- read_csv(file.path(dir_data, "adultpass.csv"))

temp_summary <- temp_raw %>%
  filter(year >= 1970 & year <= 2020)


