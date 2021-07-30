## munging script for Columbia River environmental data

## setup

## load libraries
library(tidyverse)
library(here)

## set data directory
dir_data <- here("data")

## read raw temp data
temp_raw <- read_csv(file.path(dir_data, "adultpass.csv"))

## summarize by year
temp_raw %>%
  filter(year >= 1970 & year <= 2020) %>%
  filter(mo >= 3 & mo <= 6) %>%
  group_by(year) %>%
  summarise(temp_C = round(mean(tempc), 1)) %>%
  complete(year = seq(1975, 2020)) %>%
  write_csv(file.path(dir_data, "BON_temp.csv"))


## read raw flow data
flow_raw <- read_csv(file.path(dir_data, "BON_flow_raw.csv"))

flow_raw %>%
  #select(-mm_dd)
  pivot_longer(!mm_dd,
               names_to = "year",
               values_to = "flow") %>%
  group_by(year) %>%
  summarise(flow_CFS = round(mean(flow), 1)) %>%
  write_csv(file.path(dir_data, "BON_flow.csv"))

