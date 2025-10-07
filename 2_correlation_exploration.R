library(tidyverse)
library(tidymodels)
library(here)

persons_contracts <- read_csv(here("data/voc_persons_contracts.csv"))
ranks <-  read_csv(here("data/voc_ranks.csv"))

persons_contracts <- persons_contracts |>
  mutate(
    rank_group = case_when(
      # Missing or unknown
      is.na(rank) | str_detect(rank, regex("unknown|NA|all occupations", ignore_case = TRUE)) ~ "NA",
      
      # SEA: general seafarers and ship crew
      str_detect(rank, regex("sail|seaman|ship.?s boy|skipper|mate$|boatswain|helmsman|
                              water.?maker|quartermaster|steward|cook|cooper|carpenter|
                              pilot|navigator|gunner|trumpeter|piper|block maker", ignore_case = TRUE)) ~ "SEA",
      
      # MILITARY: soldiers and officers
      str_detect(rank, regex("soldier|corporal|sergeant|bombardier|fusilier|
                              grenadier|artillery|cadet|officer|commander of the soldiers|
                              colonel|major|captain.*military|cavalry", ignore_case = TRUE)) ~ "MILITARY",
      
      # MEDICAL staff
      str_detect(rank, regex("surgeon|medical master|barber.?surgeon|midwife|
                              infirmary|assistant surgeon", ignore_case = TRUE)) ~ "MEDICAL",
      
      # TRADE & administrative
      str_detect(rank, regex("merchant|assistant to.*merchant|bookkeeper|
                              clergyman|preacher|spiritual comforter|
                              council of justice|lawyer|prosecutor", ignore_case = TRUE)) ~ "TRADE",
      
      # SHIP officers (optional separate group)
      str_detect(rank, regex("captain.*sea|master$|lieutenant.*sea|officer cadet", ignore_case = TRUE)) ~ "SHIP",
      
      # Everyone else
      TRUE ~ "OTHER"
    )
  )
persons_contracts <- persons_contracts |>
  relocate(rank_group, .before = 1)

