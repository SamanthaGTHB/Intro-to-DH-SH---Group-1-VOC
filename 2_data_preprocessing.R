library(tidyverse)
library(tidymodels)
library(here)

persons_contracts <- read_csv(here("data/voc_persons_contracts.csv"))
ranks <-  read_csv(here("data/voc_ranks.csv"))

# creating rank groups

persons_contracts_processed <- persons_contracts |>
  mutate(
    rank_group = case_when(
      # Missing or unknown
      is.na(rank) | str_detect(rank, regex("unknown|NA|all occupations", ignore_case = TRUE)) ~ "NA",
      
      # SEA: general seafarers and ship crew
      str_detect(rank, regex("sail|seaman|ship.?s boy|skipper|mate$|boatswain|helmsman|
                              water.?maker|quartermaster|steward|cook|cooper|carpenter|
                              pilot|navigator|gunner|trumpeter|piper|block maker|midshipman", ignore_case = TRUE)) ~ "SEA",
      
      # MILITARY: soldiers and officers
      str_detect(rank, regex("soldier|corporal|sergeant|bombardier|fusilier|
                              grenadier|artillery|cadet|officer|commander of the soldiers|
                              colonel|major|captain.*military|cavalry|recruit", ignore_case = TRUE)) ~ "MILITARY",
      
      # MEDICAL staff
      str_detect(rank, regex("surgeon|medical master|barber.?surgeon|midwife|
                              infirmary|assistant surgeon", ignore_case = TRUE)) ~ "MEDICAL",
      
      # TRADE & administrative
      str_detect(rank, regex("merchant|assistant to.*merchant|bookkeeper|
                              clergyman|preacher|spiritual comforter|
                              council of justice|lawyer|prosecutor|maker|miller|
                             locksmith|builder|craftsman|smith|cartwright|painter", ignore_case = TRUE)) ~ "TRADE",
      
      # SHIP officers (optional separate group)
      str_detect(rank, regex("captain.*sea|master$|lieutenant.*sea|officer cadet", ignore_case = TRUE)) ~ "SHIP",
      
      # Everyone else
      TRUE ~ "OTHER"
    )
  )
persons_contracts_processed <- persons_contracts_processed |>
  relocate(rank_group, .before = 1) |>
  janitor::clean_names()


# minimizing levels for "reason_end_contract

persons_contracts_processed <- persons_contracts_processed %>%
  mutate(
    reason_cat = forcats::fct_collapse(
      reason_end_contract,
      `Return/Remain`      = c("Repatriated", "Remains at the Cape"),
      `Death/Perished`     = c("Deceased", "Murdered", "Shipwrecked", "Death penalty"),
      `Missing/Deserted`   = c("Missing", "Absent upon departure", "Deserted"),
      `Transfer/Separation`= c("Transferred","Resignation","Dismissal","Removed",
                               "To a private ship","To a man of war","to regiment"),
      `Health/Age`         = c("Unfit to work", "Age"),
      `Disciplinary/Legal` = c("Penalised or punished", "In lening gaan"),
      `Admin/Status`       = c("Zeeland chamber","Amsterdam chamber","Rotterdam chamber",
                               "Enkhuizen chamber","Hoorn chamber","Delft chamber",
                               "Free citizen","Woman"),
      `Unknown/Other`      = c("Unknown","Not recorded","Otherwise","Last record")
    ),
    
    died = if_else(
      reason_end_contract %in% c("Deceased"),
      1,    # 1 = died
      0     # 0 = did not die
  )
)

# writing in pre-processed data
write_csv(persons_contracts_processed, here::here("data", "persons_contracts_processed.csv"))

