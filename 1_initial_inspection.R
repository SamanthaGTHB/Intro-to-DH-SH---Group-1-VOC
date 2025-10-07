library(tidyverse)
library(tidymodels)
library(here)
library(naniar)

persons_contracts <- read_csv(here("data/voc_persons_contracts.csv"))
ranks <-  read_csv(here("data/voc_ranks.csv"))

miss_var_summary(persons_contracts) |>
print(n = 27)

miss_var_summary(ranks) |>
print(n = 11)

persons_contracts %>%
  distinct(reason_end_contract) |>
  print(n = 32)

persons_contracts %>%
  distinct(rank) |>
  print(n = 201)


ranks|>
  distinct(category)
  