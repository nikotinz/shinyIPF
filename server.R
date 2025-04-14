server <- function(input, output, session) {
  # Update weight class choices based on selected gender
  observeEvent(input$gender_selector, {
    if (input$gender_selector == "M") {
      updateSelectInput(
        session,
        "weight_class_selector",
        choices = weight_class_choices_M,
        selected = "53"
      )
    } else if (input$gender_selector == "F") {
      updateSelectInput(
        session,
        "weight_class_selector",
        choices = weight_class_choices_F,
        selected = "43"
      )
    }
  })

  # Reactive filtered data based on filters
  filtered_df <- reactive({
    df <- ipf_df
    if (!is.null(input$gender_selector) && input$gender_selector != "all") {
      df <- df[df$sex == input$gender_selector, ]
    }
    if (
      !is.null(input$weight_class_selector) &&
        input$weight_class_selector != "all"
    ) {
      df <- df[df$modern_class == input$weight_class_selector, ]
    }
    if (
      !is.null(input$year_class_selector) && input$year_class_selector != "all"
    ) {
      df <- df[df$birth_year_class == input$year_class_selector, ]
    }
    if (!is.null(input$event_selector) && input$event_selector != "all") {
      df <- df[df$event == input$event_selector, ]
    }
    if (
      !is.null(input$federation_selector) && input$federation_selector != "all"
    ) {
      df <- df[df$federation == input$federation_selector, ]
    }

    if (input$gender_selector == "M") {
      df$modern_class <- factor(
        df$modern_class,
        levels = weight_class_choices_M
      )
    } else if (input$gender_selector == "F") {
      df$modern_class <- factor(
        df$modern_class,
        levels = weight_class_choices_F
      )
    }
    df
  })

  output$plot_squat <- renderPlotly({
    df <- filtered_df()
    create_density_plot(
      df,
      "best_squat",
      "Best Squat (kg)",
      input$usersquat_selector
    )
  })

  output$plot_bench <- renderPlotly({
    df <- filtered_df()
    create_density_plot(
      df,
      "best_bench",
      "Best Bench (kg)",
      input$userbench_selector
    )
  })

  output$plot_deadlift <- renderPlotly({
    df <- filtered_df()
    create_density_plot(
      df,
      "best_deadlift",
      "Best Deadlift (kg)",
      input$userdeadlift_selector
    )
  })

  output$plot_total <- renderPlotly({
    df <- filtered_df()
    create_density_plot(
      df,
      "total",
      "Best Lifts (kg)",
      input$usersquat_selector +
        input$userbench_selector +
        input$userdeadlift_selector
    )
  })
}
