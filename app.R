library(shiny)
library(plotly)
library(gridlayout)
library(bslib)
library(shinyWidgets) 
library(plotly)

source("R/load_data.R")
ipf_df = load_data()


weight_class_choices_M <- c(
  "all",
  "53",
  "59",
  "66",
  "74",
  "83",
  "93",
  "105",
  "120",
  "120+"
)

weight_class_choices_F <- c(
  "all",
  "43",
  "47",
  "52",
  "57",
  "63",
  "69",
  "76",
  "84",
  "84+"
)


ui <- grid_page(
  layout = c(
    "header  header  ",
    "sidebar plot "
  ),
  row_sizes = c("100px", "1fr"),
  col_sizes = c("250px", "1fr"),
  gap_size = "1rem",
  grid_card(
    area = "sidebar",
    card_header("Settings"),
    card_body(
      selectInput(
        inputId = "gender_selector",
        label = "Gender",
        choices = list("F" = "F", "M" = "M"),
        selected = "M"
      ),
      selectInput(
        inputId = "weight_class_selector",
        label = "Bodyweight Categories",
        choices = weight_class_choices_M,
        selected = "All",
        width = "100%"
      ),
      selectInput(
        inputId = "year_class_selector",
        label = "Age Categories",
        choices = list(
          "All" = "all",
          "Open" = "24-39",
          "Sub-Junior" = "14-18",
          "Junior" = "19-23",
          "Master I" = "40-49",
          "Master II" = "50-59",
          "Master III" = "60-69",
          "Master IV" = "70-999"
        )
      ),
      selectInput(
        inputId = "federation_selector",
        label = "Federation",
        choices = list(
          "All" = "all",
          "BP" = "BP"
        )
      ),
      selectInput(
        inputId = "event_selector",
        label = "Select event",
        choices = list(
          "All" = "all",
          "SBD" = "SBD",
          "B" = "B",
          "BD" = "BD",
          "SD" = "SD",
          "SB" = "SB",
          "S" = "S",
          "D" = "D"
        ),
        
        selected = "all"
      ),
      em("Select the paramters to view the lifts distribution.")
    )
  ),
  grid_card_text(
    area = "header",
    content = "Lifts¡",
    alignment = "start",
    is_title = FALSE
  ),
  grid_card(
    area = "plot",
    card_header("Interactive Plot"),
    card_body(
      plotlyOutput(
        outputId = "plot",
        width = "100%",
        height = "100%"
      )
    )
  )
)

# Сервер приложения
server <- function(input, output, session) {
  
  # При изменении выбора пола обновляем список весовых категорий
  observeEvent(input$gender_selector, {
    if (input$gender_selector == "M") {
      updateSelectInput(session, "weight_class_selector",
                        choices = weight_class_choices_M,
                        selected = "53")
    } else if (input$gender_selector == "F") {
      updateSelectInput(session, "weight_class_selector",
                        choices = weight_class_choices_F,
                        selected = "43")
    }
  })
  # Отрисовка интерактивного графика plotly с топовыми результатами в жиме лежа
  output$plot <- renderPlotly({
    # Фильтрация данных в зависимости от выбранных фильтров
    filtered_df <- ipf_df
    # Фильтр по полу (gender)
    if (!is.null(input$gender_selector) && input$gender_selector != "all") {
      filtered_df <- filtered_df[filtered_df$sex == input$gender_selector, ]
    }
    
    # Фильтр по весовой категории
    if (!is.null(input$weight_class_selector) && input$weight_class_selector != "all") {
      filtered_df <- filtered_df[filtered_df$modern_class == input$weight_class_selector, ]
    }
    
    # Фильтр по возрастной категории (year_class)
    if (!is.null(input$year_class_selector) && input$year_class_selector != "all") {
      filtered_df <- filtered_df[filtered_df$birth_year_class == input$year_class_selector, ]
    }
    
    # Фильтр по выбранному событию (event)
    if (!is.null(input$event_selector) && input$event_selector != "all") {
      filtered_df <- filtered_df[filtered_df$event == input$event_selector, ]
    }
    
    # Фильтр по федерации (federation)
    if (!is.null(input$federation_selector) && input$federation_selector != "all") {
      filtered_df <- filtered_df[filtered_df$federation == input$federation_selector, ]
    }
    # Для поддержания порядка уровней modern_class обновляем фактор в зависимости от пола
    if (input$gender_selector == "M") {
      filtered_df$modern_class <- factor(filtered_df$modern_class,
                                         levels = weight_class_choices_M)
    } else if (input$gender_selector == "F") {
      filtered_df$modern_class <- factor(filtered_df$modern_class,
                                         levels = weight_class_choices_F)
    }
    
    # Если в отфильтрованных данных достаточно наблюдений для оценки плотности
    if (nrow(filtered_df) >= 2) {
      dens <- density(filtered_df$best_bench, na.rm = TRUE)
      
      p <- plot_ly(
        x = dens$x,
        y = dens$y,
        type = 'scatter',
        mode = 'lines',
        line = list(color = "#3498db")
      ) 
    } else {
      # Если данных недостаточно, выводим информационное сообщение
      p <- plot_ly() %>%
        layout(
          title = list(text = "Not enough data for density estimation", x = 0.5),
          xaxis = list(title = "Best Bench (kg)"),
          yaxis = list(title = "Density")
        )
      return(p)
    }
    
    p %>% 
      layout(
        title = list(text = "Density Plot of Best Bench Press", x = 0.5),
        xaxis = list(title = "Best Bench (kg)"),
        yaxis = list(title = "Density")
      )
  })
}

shinyApp(ui, server)