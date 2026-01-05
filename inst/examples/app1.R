library(shiny)
library(nivo.bubblechart)

ui <- fluidPage(
  titlePanel("Interactive Bubble Chart"),
  sidebarLayout(
    sidebarPanel(
      h4("Click Statistics"),
      verbatimTextOutput("click_info")
    ),
    mainPanel(
      bubblechartOutput("chart", height = "600px")
    )
  )
)

server <- function(input, output, session) {

  # Sample data
  chart_data <- list(
    name = "Companies",
    children = list(
      list(name = "Tech", value = 2800, color = "#3498db", labelColor = "#ffffff"),
      list(name = "Finance", value = 2100, color = "#2ecc71", labelColor = "#ffffff"),
      list(name = "Retail", value = 1500, color = "#e74c3c", labelColor = "#ffffff")
    )
  )

  # Render chart
  output$chart <- renderBubblechart({
    bubblechart(
      element_id = "company_viz",
      main_color = "#3498db",
      label_color = "#ffffff",
      on_hover_title_color = "#f39c12",
      data = chart_data,
      height = "600px"
    )
  })

  # Handle clicks
  output$click_info <- renderPrint({
    clicked <- input$company_viz_clicked
    if (is.null(clicked)) {
      cat("Click on a bubble to see details")
    } else if (clicked == "DESELECT_EVENT") {
      cat("Bubble deselected")
    } else {
      cat("Selected:", clicked)
    }
  })
}

shinyApp(ui, server)
