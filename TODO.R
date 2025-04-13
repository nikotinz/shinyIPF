# Selector to exclude Sub-Junior and Junior and vice versa (maybe three-way switch)




shiny::runApp("C:/GIT/shinyIPF/")


library(dplyr)
library(ggplot2)

# 1. Фильтруем и находим топовые результаты
top_male_40_49 <- data_clean %>%
  filter(
    sex == "M",
    birth_year_class == "40-49",
    !is.na(modern_class),
    !is.na(best_bench)
  ) %>%
  group_by(modern_class) %>%
  summarise(
    top_bench = max(best_bench, na.rm = TRUE),
    n_athletes = n(),
    .groups = "drop"
  ) %>%
  arrange(factor(modern_class, levels = c("53", "59", "66", "74", "83", "93", "105", "120", "120+"))) 

# 2. Строим график
ggplot(top_male_40_49, aes(x = factor(modern_class, levels = c("53", "59", "66", "74", "83", "93", "105", "120", "120+")), 
                           y = top_bench)) +
  geom_col(fill = "#3498db", width = 0.7) +
  geom_text(
    aes(label = paste0(round(top_bench), " кг\n(n=", n_athletes, ")")),
    vjust = -0.3,
    size = 3.5,
    color = "black"
  ) +
  scale_x_discrete(
    name = "Весовая категория (кг)",
    drop = FALSE
  ) +
  scale_y_continuous(
    name = "Топовый результат в жиме (кг)",
    expand = expansion(mult = c(0, 0.1))  # Добавляем 10% места сверху
  ) +
  labs(
    title = "Топовые результаты в жиме лежа (мужчины 40-49 лет)",
    caption = "IPF весовые категории"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.major.x = element_blank()
  )
