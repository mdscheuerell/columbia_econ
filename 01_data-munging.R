## munging script for Columbia River environmental data

## setup

## load libraries
library(tidyverse)
library(here)

## read raw temp data
temp_raw <- read_csv(here("data", "adultpass.csv"))

## summarize temp by year for 3/1 thru 6/30
temp_raw %>%
  filter(year >= 1970 & year <= 2020) %>%
  filter(mo >= 3 & mo <= 6) %>%
  group_by(year) %>%
  summarise(temp_C = round(mean(tempc), 1)) %>%
  complete(year = seq(1975, 2020)) %>%
  write_csv(file.path(dir_data, "BON_temp.csv"))


## read raw flow data
flow_raw <- read_csv(here("data", "BON_flow_raw.csv"))

## summarize flow by year for 3/1 thru 6/30
flow_raw %>%
  pivot_longer(!mm_dd,
               names_to = "year",
               values_to = "flow") %>%
  group_by(year) %>%
  summarise(flow_kcfs = round(mean(flow), 1)) %>%
  write_csv(file.path(dir_data, "BON_flow.csv"))


## read raw PDO data
pdo_raw <- read_csv(here("data", "pdo_data_raw.csv"))

## summarize PDO by year
pdo_raw %>%
  extract(year_month, c("year", "month"), "([0-9]{4})([0-9]{2})") %>%
  filter(year >= 1970 & year <= 2020) %>%
  group_by(year) %>%
  summarise(pdo = round(mean(value), 2)) %>%
  write_csv(file.path(dir_data, "PDO.csv"))




