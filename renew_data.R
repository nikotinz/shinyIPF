library(tidyverse)
library(arrow)

ipf_raw <- read_csv(
  "./data/openipf-2025-04-05-f329403b.csv",
  col_types = cols(
    Name = col_character(),
    Sex = col_character(),
    Event = col_character(),
    Equipment = col_character(),
    BirthYearClass = col_character(),
    WeightClassKg = col_character(),
    Squat1Kg = col_double(),
    Squat2Kg = col_double(),
    Squat3Kg = col_double(),
    Bench1Kg = col_double(),
    Bench2Kg = col_double(),
    Bench3Kg = col_double(),
    Deadlift1Kg = col_double(),
    Deadlift2Kg = col_double(),
    Deadlift3Kg = col_double(),
    Best3SquatKg = col_double(),
    Best3BenchKg = col_double(),
    Best3DeadliftKg = col_double(),
    TotalKg = col_double(),
    Federation = col_character(),
    .default = col_skip() # Пропускаем все остальные столбцы
  ),
  progress = FALSE
)

# Проверка проблемных строк
if (exists("problems", where = ipf_raw)) {
  problems_df <- problems(ipf_raw)
  write_csv(problems_df, "data/problems_log.csv")
  rm(problems_df)
}


ipf_clean <- ipf_raw %>%
  select(
    name = Name,
    sex = Sex,
    event = Event,
    equipment = Equipment,
    birth_year_class = BirthYearClass,
    weight_class = WeightClassKg,
    squat_1 = Squat1Kg, squat_2 = Squat2Kg, squat_3 = Squat3Kg,
    bench_1 = Bench1Kg, bench_2 = Bench2Kg, bench_3 = Bench3Kg,
    deadlift_1 = Deadlift1Kg, deadlift_2 = Deadlift2Kg, deadlift_3 = Deadlift3Kg,
    best_squat = Best3SquatKg,
    best_bench = Best3BenchKg,
    best_deadlift = Best3DeadliftKg,
    total = TotalKg,
    federation = Federation
  ) %>%
  mutate(
    across(
      c(
        sex, event, equipment, birth_year_class, weight_class,
        federation
      ),
      ~ factor(.)
    ),
    weight_class = fct_relevel(weight_class, sort)
  ) %>%
  filter(
    !is.na(total),
    total > 0
  )

write_feather(ipf_clean, "data/ipf_data.feather")

factor_levels <- list(
  sex = levels(ipf_clean$sex),
  event = levels(ipf_clean$event),
  equipment = levels(ipf_clean$equipment),
  weight_class = levels(ipf_clean$weight_class),
  federation = levels(ipf_clean$federation)
)

saveRDS(factor_levels, "data/factor_levels.rds")
