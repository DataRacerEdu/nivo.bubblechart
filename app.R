library(shiny)
library(nivo.bubblechart)

input_tibble <- tidyr::tibble(
  topic = c("One", "Two", "Three"),
  total_spend = c(269, 4705, 643)
)
inner_list <- purrr::map(input_tibble$topic, function(.x) {
  list(
    name = .x,
    color = "#ff5f56",
    labelColor = "#ffffff",
    value = input_tibble[input_tibble$topic == .x, ]$total_spend
  )
})

json_data <- list(
  name = "nivo",
  children = inner_list
) |> jsonlite::toJSON(na = 'null',pretty = TRUE, auto_unbox = TRUE)


ui <- fluidPage(
  titlePanel("reactR HTMLWidget Example"),
  bubblechartOutput('widgetOutput')
)

server <- function(input, output, session) {
  output$widgetOutput <- renderBubblechart(
    bubblechart(element_id = "test", data = json_data, main_color = "#ff5f56", label_color = "#ffffff")
  )

  observeEvent(input$test_clicked, {
    print(input$test_clicked)
  })
}

shinyApp(ui, server)


