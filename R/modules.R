# UI for Athlete Comparison Module
compare_ui <- function(id) {
    ns <- NS(id)
    tagList(
        fluidRow(
            column(
                6,
                selectizeInput(
                    ns("athlete1"),
                    "Athlete 1:",
                    choices = NULL,
                    options = list(maxOptions = 5)
                )
            ),
            column(
                6,
                selectizeInput(
                    ns("athlete2"),
                    "Athlete 2:",
                    choices = NULL,
                    options = list(maxOptions = 5)
                )
            )
        ),
        fluidRow(
            column(
                12,
                plotlyOutput(ns("comparison_plot"), height = "500px")
            )
        )
    )
}

# Server Logic for Athlete Comparison
compare_server <- function(id, data) {
    moduleServer(id, function(input, output, session) {
        # Update athlete selection dropdowns
        observe({
            req(data())
            athletes <- unique(data()$name)
            updateSelectizeInput(
                session,
                "athlete1",
                choices = athletes,
                server = TRUE
            )
            updateSelectizeInput(
                session,
                "athlete2",
                choices = athletes,
                server = TRUE
            )
        })

        # Prepare comparison data in long format
        comparison_data <- reactive({
            req(input$athlete1, input$athlete2)

            data() %>%
                filter(name %in% c(input$athlete1, input$athlete2)) %>%
                select(
                    name,
                    best_squat,
                    best_bench,
                    best_deadlift,
                    total,
                    weight_class
                ) %>%
                pivot_longer(
                    cols = -c(name, weight_class),
                    names_to = "lift",
                    values_to = "weight"
                ) %>%
                mutate(
                    lift = factor(
                        lift,
                        levels = c(
                            "best_squat",
                            "best_bench",
                            "best_deadlift",
                            "total"
                        ),
                        labels = c("Squat", "Bench", "Deadlift", "Total")
                    )
                )
        })

        # Render comparison plot
        output$comparison_plot <- renderPlotly({
            df <- comparison_data()
            validate(
                need(nrow(df) > 0, "Please select two athletes to compare")
            )

            ggplotly(
                ggplot(
                    df,
                    aes(x = lift, y = weight, fill = name)
                ) +
                geom_col(position = "dodge") +
                labs(
                    title = "Performance Comparison",
                    x = "",
                    y = "Weight (kg)",
                    fill = "Athlete"
                ) +
                theme_minimal() +
                scale_fill_manual(
                    values = c("#2c3e50", "#18bc9c")
                )
            )
        })
    })
}