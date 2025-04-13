library(arrow)
library(tidyverse)

load_data <- function() {
full_data <- arrow::read_feather("data/ipf_data.feather")


data_clean <- full_data %>% 
  select(!c("name")) %>% 
  filter(equipment == "Raw") %>% 
  filter(!is.na(weight_class))


data_clean <- data_clean %>%
  mutate(
    # Заменяем "+" на пустую строку и преобразуем в число
    weight_num = as.numeric(gsub("[+]", "", weight_class)),
    
    # Заменяем NA на Inf (для удобства обработки)
    weight_num = if_else(is.na(weight_num), Inf, weight_num),
    
    # Приводим пол к верхнему регистру и убираем пробелы
    sex_clean = toupper(trimws(sex))) %>% 
    select(-sex) %>% 
    rename(sex = sex_clean)

data_clean <- data_clean %>%
  mutate(
    modern_class = case_when(
      # Обработка для Sub-Junior & Junior (birth_year_class "14-18" или "19-23")
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 0, 53) ~ "53",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 53.01, 59) ~ "59",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 59.01, 66) ~ "66",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 66.01, 74) ~ "74",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 74.01, 83) ~ "83",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 83.01, 93) ~ "93",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 93.01, 105) ~ "105",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 105.01, 120) ~ "120",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & weight_num > 120 ~ "120+",
      
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 0, 43) ~ "43",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 43.01, 47) ~ "47",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 47.01, 52) ~ "52",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 52.01, 57) ~ "57",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 57.01, 63) ~ "63",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 63.01, 69) ~ "69",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 69.01, 76) ~ "76",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 76.01, 84) ~ "84",
      birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & weight_num > 84 ~ "84+",
      
      # Обработка для остальных (например, взрослых)
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 0, 59) ~ "59",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 59.01, 66) ~ "66",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 66.01, 74) ~ "74",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 74.01, 83) ~ "83",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 83.01, 93) ~ "93",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 93.01, 105) ~ "105",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & between(weight_num, 105.01, 120) ~ "120",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "M" & weight_num > 120 ~ "120+",
      
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 0, 47) ~ "47",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 47.01, 52) ~ "52",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 52.01, 57) ~ "57",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 57.01, 63) ~ "63",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 63.01, 69) ~ "69",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 69.01, 76) ~ "76",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & between(weight_num, 76.01, 84) ~ "84",
      !birth_year_class %in% c("14-18", "19-23") & 
        sex == "F" & weight_num > 84 ~ "84+",
      
      # Если ни одно условие не выполнилось — NA (или можно заменить на "UNKNOWN")
      TRUE ~ NA_character_
    )
  ) %>% 
  filter(!is.na(modern_class))



# # MALES FACTORS REORDER
# data_clean %>%
#   filter(sex == "M") %>%
#   mutate(
#     modern_class = factor(
#       modern_class,
#       levels = c("53", "59", "66", "74", "83", "93", "105", "120", "120+"),
#       ordered = TRUE
#     )
#   ) %>%
#   distinct(modern_class) %>%
#   arrange(modern_class)
# 
# # FEMALES FACTORS REORDER
# data_clean %>%
#   filter(sex == "F") %>%
#   mutate(
#     modern_class = factor(
#       modern_class,
#       levels = c("43", "47", "52", "57", "63", "69", "76", "84", "84+"),
#       ordered = TRUE
#     )
#   ) %>%
#   distinct(modern_class) %>%
#   arrange(modern_class)
# 
# 
# a = data_clean %>% 
# select(federation) %>% 
# distinct(federation)
#                 
}

