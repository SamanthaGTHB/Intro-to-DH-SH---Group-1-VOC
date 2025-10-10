library(tidyverse)
library(tidymodels)
library(here)

persons_contracts_processed <- read_csv(here("data/persons_contracts_processed.csv"))
ranks <- read.csv(here("data/voc_ranks.csv"))


persons_contracts_processed |>
  ggplot(aes(x = rank_group, fill = factor(died))) +
  geom_bar(position = "dodge") +
  labs(
    x = "Rank Group",
    y = "Count of Individuals",
    fill = "Died (1 = Yes, 0 = No)"
  ) +
 theme(axis.text.x = element_text(angle = 45, hjust = 1))



persons_contracts_processed |>
  ggplot(aes(x = rank_group, fill = factor(died))) +
  geom_bar(position = "fill") +
  labs(
    x = "Rank Group",
    y = "Proportion of Individuals",
    fill = "Died (1 = Yes, 0 = No)"
  ) +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


## creating proportion chart

persons_contracts_processed |>
  group_by(rank_group) |>
  summarise(death_rate = mean(died, na.rm = TRUE)) |>
  ggplot(aes(x = fct_reorder(rank_group, death_rate), y = death_rate)) +
  geom_col(fill = "lightblue") +
  geom_text(aes(label = scales::percent(death_rate, accuracy = 0.1)), 
            vjust = -0.3, size = 3) +
  labs(
    x = "Rank Group",
    y = "Proportion Died",
    title = "Death Rate by Rank Group"
  ) +
  scale_y_continuous(labels = scales::percent_format()) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))




## incorporating wages
ranks |>
  ggplot(aes(x = category, y = median_wage)) +
  geom_boxplot()



persons_contracts_processed |>
  filter(rank_group == "OTHER") |>
  distinct(rank) |>
  print( n = 46)


persons_contracts_processed |>
  filter(rank_group == "OTHER") |>
  distinct(rank) |>
  print( n = 46)
  