library(shiny)
library(nivo.bubblechart)

df <- data.frame(
  product = c("Laptop", "Phone", "Tablet", "Watch"),
  sales = c(45000, 38000, 22000, 15000),
  category_color = c("#3498db", "#e74c3c", "#f39c12", "#9b59b6"),
  text_color = rep("#ffffff", 4)
)

ui <- fluidPage(
  titlePanel("Interactive Bubble Chart Example"),
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

  # Convert to bubble chart format
  chart_data <- prepare_bubble_data(
    df,
    name_col = "product",
    value_col = "sales",
    color_col = "category_color",
    label_color_col = "text_color"
  )

  # Render chart
  output$chart <- renderBubblechart({
    bubblechart(
      element_id = "product_viz",
      main_color = "#3498db",
      label_color = "#ffffff",
      on_hover_title_color = "#f39c12",
      data = chart_data,
      height = "600px"
    )
  })

  # Handle clicks
  output$click_info <- renderPrint({
    clicked <- input$product_viz_clicked
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
