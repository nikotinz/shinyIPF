create_density_plot <- function(
  data,
  lift_col,
  xaxis_title,
  user_val = 0
) {
  # Если недостаточно данных для оценки плотности, возвращаем пустой график с сообщением
  if (nrow(data) < 2) {
    p <- plot_ly() %>%
      layout(
        title = list(
          text = "Not enough data for density estimation",
          x = 0.5
        ),
        xaxis = list(title = xaxis_title),
        yaxis = list(title = "Density")
      )
    return(p)
  }

  # Расчёт плотности для выбранной переменной
  dens <- density(data[[lift_col]], na.rm = TRUE)

  # Вычисляем квантиль для user_val на основе эмпирической функции распределения
  q_val <- ecdf(data[[lift_col]])(user_val)

  # Создаем график плотности с plot_ly
  p <- plot_ly(
    x = dens$x,
    y = dens$y,
    type = 'scatter',
    mode = 'lines',
    line = list(color = "#3498db")
  ) %>%
    layout(
      xaxis = list(title = xaxis_title),
      yaxis = list(title = "Density"),
      # Добавляем вертикальную линию, соответствующую значению user_val
      shapes = list(
        list(
          type = "line",
          x0 = user_val,
          x1 = user_val,
          y0 = 0,
          y1 = max(dens$y) * 1.1,
          xref = "x",
          yref = "y",
          line = list(color = "red", dash = "dash")
        )
      ),
      # Добавляем аннотацию с квантилью
      annotations = list(
        list(
          x = user_val,
          y = max(dens$y) * 1.1,
          text = paste0("Q: ", round(q_val, 3) * 100, "%"),
          xref = "x",
          yref = "y",
          showarrow = FALSE
        )
      )
    )
  return(p)
}
