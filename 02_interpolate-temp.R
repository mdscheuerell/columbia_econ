## munging script for Columbia River environmental data

## setup

## load libraries
library(tidyverse)
library(here)
library(MARSS)

## read raw temp data
temp_raw <- read_csv(here("data", "temp_all_dams.csv"))

## reformatted data
temp_re <- temp_raw %>%
  pivot_longer(cols = `2020`:`1970`,
               names_to = "year",
               values_to = "temp") %>%
  pivot_wider(names_from = day_of_year,
              values_from = temp) %>%
  arrange(year, dam)
  
## number of years of data
n_years <- temp_re %>%
  select(year) %>%
  unique() %>%
  nrow()

## number of days
n_obs <- nrow(temp_re)

## ZZ matrix to map 4 dams onto single state
ZZ <- matrix(0, nrow(temp_re), n_years)
for(i in 1:n_years) {
  ZZ[seq(4) + 4 * (i - 1), i] <- rep(1, 4)
}
  
## AR(1) terms (= 1)
BB <- diag(n_years)

## slope (bias)
UU <- matrix("bias", n_years, 1)

## process error variance; IID
QQ <- matrix(list(0), n_years, n_years)
diag(QQ) <- "env"

## offsets for obs
AA <- matrix(as.character(seq(n_obs)), n_obs, 1)

## obs error variance; IID
RR <- matrix(list(0), n_obs, n_obs)
diag(RR) <- "obs"

## fit biased RW's to each year
mod_list <- list(
  B = BB,
  U = UU,
  Q = QQ,
  Z = ZZ,
  A = AA,
  R = RR
)

inits_list <- list(
  x0 = 4
)

## data for fitting; subtract mean to aid fitting
yy <- temp_re %>%
  select(-c("dam", "year")) %>%
  as.matrix()

## fit the model
mod_fit <- MARSS(yy, model = mod_list, inits = inits_list, method = "BFGS")

## calculate annual means
temp_mean <- mod_fit$states %>%
  apply(1, mean) %>%
  round(2)

## df with year and temp
tbl_temps <- data.frame(year = seq(1970, 2020),
                        temp = temp_mean,
                        row.names = NULL)

## write df to file
write.csv(tbl_temps, here("data", "mean_annual_temp_index.csv"))
