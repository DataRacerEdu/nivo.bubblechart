library(shiny)
library(nivo.bubblechart)
library(jsonlite)

json_data <- list(
  name = "nivo",
  children = list(
    list(
      name = "One",
      color = "#ffa970",
      labelColor = "#ffffff",
      value = 269
    ),
    list(
      name = "Two",
      color = "#ffa970",
      labelColor = "#ffffff",
      value = 4705
    ),
    list(
      name = "Three",
      color = "#ffa970",
      labelColor = "#ffffff",
      value = 643
    )
  )
) |> jsonlite::toJSON(na = 'null', pretty = TRUE, auto_unbox = TRUE)


ui <- fluidPage(
  titlePanel("`nivo.bubblechart` example"),
  bubblechartOutput('widgetOutput')
)

server <- function(input, output, session) {
  output$widgetOutput <- renderBubblechart(
    bubblechart(
      element_id = "bubble_el",
      data = json_data,
      main_color = "#ffa970",
      label_color = "#ffffff",
      on_hover_title_color = "#ffa970",
      isInteractive = TRUE
    )
  )

  observeEvent(input$bubble_el_clicked, {
    print(input$bubble_el_clicked)
  })

}

shinyApp(ui, server)


