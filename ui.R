ui <- grid_page(
  tags$footer(
    paste("Version:", app_version),
    style = "font-size: 8px; color: #666; text-align: left; padding: 0px;"
  ),
  layout = c(
    "header    user_squat   user_bench   user_deadlift",
    "sidebar   plot_squat   plot_bench   plot_deadlift",
    "sidebar   info         info         plot_total"
  ),
  row_sizes = c("125px", "1fr", "1fr"),
  col_sizes = c("250px", "1fr", "1fr", "1fr"),
  gap_size = "1rem",
  # Header area
  grid_card_text(
    area = "header",
    content = HTML(
      '
      <div style="display: flex; align-items: center; height: 100%;">
        <img src="logo.png" alt="Logo" style="height: 100px; margin-right: 1rem;">
        <span style="font-size: 16px; font-weight: bold;">LiftsReview</span>
      </div>
    '
    ),
    alignment = "start",
    is_title = FALSE
  ),
  grid_card(
    area = "user_squat",
    card_body(
      numericInput(
        inputId = "usersquat_selector",
        label = "Enter your squat",
        value = 0,
        min = 0,
        width = "100%" # Optionally, adjust the width as well
      )
    )
  ),
  grid_card(
    area = "user_bench",
    card_body(
      numericInput(
        inputId = "userbench_selector",
        label = "Enter your bench",
        value = 0,
        min = 0,
        width = "100%" # Optionally, adjust the width as well
      )
    )
  ),
  grid_card(
    area = "user_deadlift",
    card_body(
      numericInput(
        inputId = "userdeadlift_selector",
        label = "Enter your deadlift",
        value = 0,
        min = 0,
        width = "100%" # Optionally, adjust the width as well
      )
    )
  ),
  # Sidebar area for settings
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
      selectizeInput(
        inputId = "federation_selector",
        label = "Federation",
        choices = c(All = "all", as.character(unique(ipf_df$federation))),
        options = list(placeholder = 'Type to search...')
      ),
      em("Select the parameters to view the lifts distribution.")
    )
  ),
  # Plot areas for each lift
  grid_card(
    area = "plot_squat",
    card_header("Squat Density"),
    card_body(
      plotlyOutput(
        outputId = "plot_squat",
        width = "100%",
        height = "100%"
      )
    )
  ),
  grid_card(
    area = "plot_bench",
    card_header("Bench Density"),
    card_body(
      plotlyOutput(
        outputId = "plot_bench",
        width = "100%",
        height = "100%"
      )
    )
  ),
  grid_card(
    area = "plot_deadlift",
    card_header("Deadlift Density"),
    card_body(
      plotlyOutput(
        outputId = "plot_deadlift",
        width = "100%",
        height = "100%"
      )
    )
  ),
  # Full-width information area with generic markdown text placeholder
  grid_card(
    area = "info",
    card_header("Information"),
    card_body(
      HTML(
        "<p>Generic markdown text goes here.</p>"
      )
    )
  ),
  grid_card(
    area = "plot_total",
    card_header("Total Lifts Density"),
    card_body(
      plotlyOutput(
        outputId = "plot_total",
        width = "100%",
        height = "100%"
      )
    )
  )
)
